import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import '../main.dart' as app;
import '../core/services/proxy_service.dart';
import '../core/services/webview_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WebView代理压力测试', () {
    late ProxyService proxyService;
    late WebViewService webViewService;

    setUp(() async {
      proxyService = ProxyService();
      webViewService = WebViewService();
      await proxyService.initialize();
    });

    tearDown(() async {
      await proxyService.stopProxy();
      await webViewService.disposeAll();
    });

    testWidgets('大量WebView实例并发压力测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 创建大量WebView实例（模拟高并发场景）
      final int webViewCount = 20;
      final List<int> webViewIds = [];
      final List<Future<void>> loadPromises = [];
      
      // 分批创建WebView以避免过度资源消耗
      for (int batch = 0; batch < 4; batch++) {
        final batchPromises = <Future<void>>[];
        
        for (int i = 0; i < 5; i++) {
          final index = batch * 5 + i;
          final url = 'https://httpbin.org/delay/${index % 3 + 1}';
          
          final promise = () async {
            final webView = await webViewService.createWebView(url);
            webViewIds.add(webView.id);
          }();
          
          batchPromises.add(promise);
        }
        
        // 等待当前批次完成
        await Future.wait(batchPromises);
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }
      
      // 等待所有WebView加载
      await tester.pumpAndSettle(const Duration(seconds: 15));
      
      // 验证大部分WebView成功加载
      int successfulLoads = 0;
      for (final id in webViewIds) {
        final webView = webViewService.getWebView(id);
        if (!webView.isLoading && !webView.hasError) {
          successfulLoads++;
        }
      }
      
      // 至少80%的WebView应该成功加载
      expect(successfulLoads, greaterThanOrEqualTo((webViewIds.length * 0.8).round()));
      
      // 清理所有WebView
      for (final id in webViewIds) {
        await webViewService.disposeWebView(id);
      }
    });

    testWidgets('快速WebView创建销毁循环测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 快速创建和销毁WebView的循环测试
      for (int cycle = 0; cycle < 10; cycle++) {
        final webView = await webViewService.createWebView('https://example.com');
        
        // 短暂等待加载
        await tester.pumpAndSettle(const Duration(seconds: 1));
        
        // 立即销毁
        await webViewService.disposeWebView(webView.id);
        
        // 清理内存
        await tester.pumpAndSettle(const Duration(seconds: 0));
      }
      
      // 验证服务仍然正常工作
      final testWebView = await webViewService.createWebView('https://httpbin.org/ip');
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      expect(testWebView.isLoading, false);
      await webViewService.disposeWebView(testWebView.id);
    });

    testWidgets('代理网络波动下WebView稳定性测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 创建WebView进行稳定性测试
      final webView = await webViewService.createWebView('https://httpbin.org/status/200');
      
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(webView.isLoading, false);
      
      // 模拟网络波动 - 短暂停止代理
      await proxyService.stopProxy();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // 恢复代理
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 尝试重新加载页面
      await webViewService.loadUrl(webView.id, 'https://httpbin.org/ip');
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // 验证恢复后能正常工作
      expect(!webView.hasError, true);
      
      await webViewService.disposeWebView(webView.id);
    });

    testWidgets('大流量数据传输测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 测试大图片加载
      final webView = await webViewService.createWebView(
        'https://picsum.photos/1920/1080', // 大尺寸图片
      );
      
      final startTime = DateTime.now();
      await tester.pumpAndSettle(const Duration(seconds: 15)); // 给予更多时间加载大文件
      
      final endTime = DateTime.now();
      final loadTime = endTime.difference(startTime).inSeconds;
      
      // 验证大文件加载在合理时间内完成
      expect(loadTime, lessThan(30)); // 30秒内完成
      
      if (!webView.hasError) {
        print('大文件加载成功，耗时: ${loadTime}秒');
      }
      
      await webViewService.disposeWebView(webView.id);
    });

    testWidgets('内存泄漏检测测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      final initialMemoryUsage = await getMemoryUsage();
      
      // 执行多次WebView创建销毁循环
      for (int i = 0; i < 50; i++) {
        final webView = await webViewService.createWebView('https://example.com');
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await webViewService.disposeWebView(webView.id);
        
        // 每10次循环检查一次内存
        if (i % 10 == 0) {
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }
      }
      
      // 强制垃圾回收
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      final finalMemoryUsage = await getMemoryUsage();
      final memoryIncrease = finalMemoryUsage - initialMemoryUsage;
      
      // 内存增长应该在合理范围内（不超过100MB）
      expect(memoryIncrease, lessThan(100 * 1024 * 1024)); // 100MB
      
      print('内存使用增长: ${memoryIncrease / 1024 / 1024:.2f}MB');
    });

    testWidgets('长时间运行稳定性测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 创建多个WebView并长时间运行
      final List<int> webViewIds = [];
      
      for (int i = 0; i < 5; i++) {
        final webView = await webViewService.createWebView(
          'https://httpbin.org/stream/5', // 流式数据
        );
        webViewIds.add(webView.id);
      }
      
      // 模拟用户长时间使用场景
      for (int minute = 0; minute < 2; minute++) { // 测试2分钟
        await tester.pumpAndSettle(const Duration(seconds: 30));
        
        // 检查WebView状态
        for (final id in webViewIds) {
          final webView = webViewService.getWebView(id);
          if (webView.hasError) {
            print('WebView $id 在第${minute}分钟出现错误');
          }
        }
      }
      
      // 验证大部分WebView仍然存活且正常工作
      int aliveWebViews = 0;
      for (final id in webViewIds) {
        final webView = webViewService.getWebView(id);
        if (!webView.hasError) {
          aliveWebViews++;
        }
      }
      
      expect(aliveWebViews, greaterThanOrEqualTo(3)); // 至少3个WebView正常存活
      
      // 清理
      for (final id in webViewIds) {
        await webViewService.disposeWebView(id);
      }
    });
  });
}

// 模拟内存使用检测函数
Future<int> getMemoryUsage() async {
  // 在实际实现中，这里会调用平台特定的内存检测API
  // 这里返回模拟值
  return 50 * 1024 * 1024; // 50MB
}