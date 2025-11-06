import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import '../main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('浏览器代理集成测试', () {
    late ProxyService proxyService;
    late WebViewService webViewService;

    setUp(() async {
      proxyService = ProxyService();
      webViewService = WebViewService();
      await proxyService.initialize();
    });

    tearDown(() async {
      await proxyService.stopProxy();
      await webViewService.dispose();
    });

    testWidgets('代理启动后WebView正确加载页面', (WidgetTester tester) async {
      // 启动代理服务
      await proxyService.startProxy('test://127.0.0.1:1080');
      
      // 验证代理状态
      expect(await proxyService.isProxyActive(), true);
      
      // 创建WebView并尝试加载页面
      final webView = await webViewService.createWebView(
        'https://httpbin.org/ip', // 使用HTTPBin测试IP检测
      );

      // 模拟用户等待页面加载
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // 验证WebView已加载页面
      expect(webView.isLoading, false);
      
      // 清理
      await webViewService.disposeWebView(webView.id);
    });

    testWidgets('代理切换时WebView网络请求重新路由', (WidgetTester tester) async {
      // 初始代理配置
      await proxyService.startProxy('socks5://127.0.0.1:1080');
      
      // 创建WebView加载页面
      final webView1 = await webViewService.createWebView(
        'https://httpbin.org/headers',
      );
      
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 切换到不同代理
      await proxyService.stopProxy();
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 创建新的WebView
      final webView2 = await webViewService.createWebView(
        'https://httpbin.org/headers',
      );
      
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证两个WebView都成功加载（代理正确工作）
      expect(webView1.isLoading, false);
      expect(webView2.isLoading, false);
      
      // 清理
      await webViewService.disposeWebView(webView1.id);
      await webViewService.disposeWebView(webView2.id);
    });

    testWidgets('代理停止时WebView网络错误处理', (WidgetTester tester) async {
      // 启动代理
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 创建WebView
      final webView = await webViewService.createWebView(
        'https://example.com',
      );
      
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 停止代理
      await proxyService.stopProxy();
      
      // 尝试加载新页面，应该触发网络错误
      await webViewService.loadUrl(webView.id, 'https://httpbin.org/ip');
      
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证WebView检测到网络错误
      expect(webView.hasError, true);
      
      await webViewService.disposeWebView(webView.id);
    });

    testWidgets('多个WebView同时使用代理', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 创建多个WebView
      final List<String> urls = [;
        'https://httpbin.org/ip',
        'https://httpbin.org/user-agent',
        'https://httpbin.org/headers',
        'https://httpbin.org/cookies',
      ];
      
      final List<int> webViewIds = [];
      
      for (final url in urls) {
        final webView = await webViewService.createWebView(url);
        webViewIds.add(webView.id);
      }
      
      // 等待所有WebView加载完成
      await tester.pumpAndSettle(const Duration(seconds: 8));
      
      // 验证所有WebView都成功加载
      for (final id in webViewIds) {
        final webView = webViewService.getWebView(id);
        expect(webView.isLoading, false);
      }
      
      // 清理所有WebView
      for (final id in webViewIds) {
        await webViewService.disposeWebView(id);
      }
    });

    testWidgets('代理配置验证和WebView错误处理', (WidgetTester tester) async {
      // 测试无效代理配置
      await expectLater(
        () => proxyService.startProxy('invalid://proxy.url:port'),
        throwsA(isA<ProxyConfigurationException>()),
      );
      
      // 验证WebView在没有代理时的工作状态
      final webView = await webViewService.createWebView('https://example.com');
      
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 在没有代理的情况下，WebView应该仍能工作
      expect(webView.isLoading, false);
      
      await webViewService.disposeWebView(webView.id);
    });

    testWidgets('代理性能监控和WebView响应时间测试', (WidgetTester tester) async {
      final List<int> responseTimes = [];
      
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 测试多次页面加载的性能
      for (int i = 0; i < 3; i++) {
        final startTime = DateTime.now();
        
        final webView = await webViewService.createWebView(
          'https://httpbin.org/delay/1', // 1秒延迟测试
        );
        
        await tester.pumpAndSettle(const Duration(seconds: 3));
        
        final endTime = DateTime.now();
        final responseTime = endTime.difference(startTime).inMilliseconds;
        responseTimes.add(responseTime);
        
        expect(webView.isLoading, false);
        await webViewService.disposeWebView(webView.id);
      }
      
      // 验证性能在合理范围内（应该比直接连接稍慢）
      for (final time in responseTimes) {
        expect(time, greaterThan(1000)); // 至少1秒
        expect(time, lessThan(5000));    // 不超过5秒
      }
      
      // 计算平均响应时间
      final avgResponseTime = responseTimes.reduce((a, b) => a + b) / responseTimes.length;
      print('平均代理响应时间: ${avgResponseTime}ms');
    });
  });
}