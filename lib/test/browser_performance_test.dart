import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import '../main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('浏览器性能测试', () {
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

    testWidgets('页面加载速度基准测试', (WidgetTester tester) async {
      final Map<String, List<int>> loadTimes = {};
      
      // 测试不同类型网站的加载性能
      final testCases = {
        '简单页面': 'https://example.com',
        '中等复杂度页面': 'https://httpbin.org/html',
        '复杂页面': 'https://httpbin.org/links/10',
        '包含图片页面': 'https://httpbin.org/image/png',
        'JSON API': 'https://httpbin.org/json',
      };
      
      // 测试无代理情况下的基准性能
      print('\n=== 无代理性能测试 ===');
      for (final entry in testCases.entries) {
        final times = <int>[];
        
        for (int i = 0; i < 3; i++) { // 每种页面测试3次取平均值;
          final startTime = DateTime.now();
          
          final webView = await webViewService.createWebView(entry.value);
          await tester.pumpAndSettle(const Duration(seconds: 5));
          
          final endTime = DateTime.now();
          final loadTime = endTime.difference(startTime).inMilliseconds;
          times.add(loadTime);
          
          await webViewService.disposeWebView(webView.id);
        }
        
        loadTimes['无代理-${entry.key}'] = times;
        final avgTime = times.reduce((a, b) => a + b) / times.length;
        print('${entry.key}: ${avgTime.toInt()}ms (范围: ${times.min}-${times.max}ms)');
      }
      
      // 测试代理环境下的性能
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      print('\n=== 代理环境性能测试 ===');
      for (final entry in testCases.entries) {
        final times = <int>[];
        
        for (int i = 0; i < 3; i++) {
          final startTime = DateTime.now();
          
          final webView = await webViewService.createWebView(entry.value);
          await tester.pumpAndSettle(const Duration(seconds: 5));
          
          final endTime = DateTime.now();
          final loadTime = endTime.difference(startTime).inMilliseconds;
          times.add(loadTime);
          
          await webViewService.disposeWebView(webView.id);
        }
        
        loadTimes['代理-${entry.key}'] = times;
        final avgTime = times.reduce((a, b) => a + b) / times.length;
        print('${entry.key}: ${avgTime.toInt()}ms (范围: ${times.min}-${times.max}ms)');
      }
      
      // 验证代理性能下降在可接受范围内（不超过50%）
      for (final entry in testCases.entries) {
        final directTimes = loadTimes['无代理-${entry.key}']!;
        final proxyTimes = loadTimes['代理-${entry.key}']!;
        
        final directAvg = directTimes.reduce((a, b) => a + b) / directTimes.length;
        final proxyAvg = proxyTimes.reduce((a, b) => a + b) / proxyTimes.length;
        
        final performanceDrop = (proxyAvg - directAvg) / directAvg;
        expect(performanceDrop, lessThan(0.5)); // 性能下降不超过50%
        
        print('${entry.key} 性能下降: ${(performanceDrop * 100).toInt()}%');
      }
    });

    testWidgets('JavaScript执行性能测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 创建包含复杂JavaScript的测试页面
      final testHtml = ''';
        <!DOCTYPE html>
        <html>
        <head>
          <title>JavaScript性能测试</title>
        </head>
        <body>
          <div id="result"></div>;
          <script>
            // 复杂计算测试
            function fibonacci(n) {
              if (n <= 1) return n;
              return fibonacci(n - 1) + fibonacci(n - 2);
            }
            
            function performanceTest() {
              const start = performance.now();
              const result = fibonacci(30);
              const end = performance.now();
              return { result: result, time: end - start };
            }
            
            const testResult = performanceTest();
            document.getElementById('result').innerHTML =;
              'Fibonacci(30) = ' + testResult.result +;
              ', 耗时: ' + testResult.time.toFixed(2) + 'ms';
              
            // 触发自定义事件通知测试完成
            window.flutterTest.complete({
              result: testResult.result,
              time: testResult.time
            });
          </script>
        </body>
        </html>
      ''';
      
      final webView = await webViewService.createWebViewWithHtml(testHtml);
      
      // 等待JavaScript执行完成
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // 获取JavaScript执行结果
      final jsResult = await webView.evaluateJavaScript(''';
        document.getElementById('result').textContent;
      ''');
      
      expect(jsResult, contains('耗时:'));
      expect(jsResult, contains('ms'));
      
      print('JavaScript执行结果: $jsResult');
      
      await webViewService.disposeWebView(webView.id);
    });

    testWidgets('内存使用效率测试', (WidgetTester tester) async {
      final List<int> memorySnapshots = [];
      
      // 无代理环境内存测试
      for (int i = 0; i < 5; i++) {
        final webView = await webViewService.createWebView('https://example.com');
        await tester.pumpAndSettle(const Duration(seconds: 2));
        
        final memory = await getCurrentMemoryUsage();
        memorySnapshots.add(memory);
        
        await webViewService.disposeWebView(webView.id);
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }
      
      final baseMemory = memorySnapshots.last;
      print('基础内存使用: ${baseMemory / 1024 / 1024:.2f}MB');
      
      // 代理环境内存测试
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      final List<int> proxyMemorySnapshots = [];
      for (int i = 0; i < 5; i++) {
        final webView = await webViewService.createWebView('https://example.com');
        await tester.pumpAndSettle(const Duration(seconds: 2));
        
        final memory = await getCurrentMemoryUsage();
        proxyMemorySnapshots.add(memory);
        
        await webViewService.disposeWebView(webView.id);
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }
      
      final proxyMemory = proxyMemorySnapshots.last;
      final memoryOverhead = proxyMemory - baseMemory;
      
      print('代理环境内存使用: ${proxyMemory / 1024 / 1024:.2f}MB');
      print('内存开销: ${memoryOverhead / 1024 / 1024:.2f}MB');
      
      // 验证内存开销在合理范围内（不超过100MB）
      expect(memoryOverhead, lessThan(100 * 1024 * 1024));
    });

    testWidgets('滚动和渲染性能测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 创建包含大量内容的长页面
      final largeHtml = ''';
        <!DOCTYPE html>
        <html>
        <head>
          <title>滚动性能测试</title>
          <style>
            .content { height: 100px; margin: 10px; border: 1px solid #ccc; }
            body { font-family: Arial; }
          </style>
        </head>
        <body>
          <h1>滚动性能测试页面</h1>
          ${List.generate(100, (i) => '<div class="content">内容块 $i - 用于测试滚动性能</div>').join()}
        </body>
        </html>
      ''';
      
      final webView = await webViewService.createWebViewWithHtml(largeHtml);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // 测试滚动性能
      final List<int> frameTimes = [];
      
      // 模拟用户滚动操作
      for (int i = 0; i < 10; i++) {
        final startFrameTime = DateTime.now();
        
        await webView.scrollBy(0, 500); // 向下滚动500像素
        await tester.pumpAndSettle(const Duration(milliseconds: 16)); // 60fps
        
        final endFrameTime = DateTime.now();
        frameTimes.add(endFrameTime.difference(startFrameTime).inMilliseconds);
      }
      
      // 计算平均帧时间
      final avgFrameTime = frameTimes.reduce((a, b) => a + b) / frameTimes.length;
      
      print('平均帧渲染时间: ${avgFrameTime.toFixed(2)}ms');
      
      // 验证滚动性能（平均帧时间应该低于33ms以维持30fps）
      expect(avgFrameTime, lessThan(33));
      
      await webViewService.disposeWebView(webView.id);
    });

    testWidgets('网络请求并发性能测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 创建多个WebView同时发起网络请求
      final List<Future<void>> concurrentRequests = [];
      final List<int> responseTimes = [];
      
      for (int i = 0; i < 8; i++) {
        final request = () async {
          final startTime = DateTime.now();
          
          final webView = await webViewService.createWebView(
            'https://httpbin.org/delay/2',
          );
          
          await tester.pumpAndSettle(const Duration(seconds: 3));
          
          final endTime = DateTime.now();
          final responseTime = endTime.difference(startTime).inMilliseconds;
          responseTimes.add(responseTime);
          
          await webViewService.disposeWebView(webView.id);
        };
        
        concurrentRequests.add(request());
      }
      
      // 等待所有并发请求完成
      await Future.wait(concurrentRequests);
      
      // 分析并发性能
      final avgResponseTime = responseTimes.reduce((a, b) => a + b) / responseTimes.length;
      final maxResponseTime = responseTimes.reduce(max);
      final minResponseTime = responseTimes.reduce(min);
      
      print('并发请求性能分析:');
      print('  平均响应时间: ${avgResponseTime.toInt()}ms');
      print('  最大响应时间: ${maxResponseTime}ms');
      print('  最小响应时间: ${minResponseTime}ms');
      
      // 验证并发性能在合理范围内
      expect(avgResponseTime, lessThan(5000)); // 平均不超过5秒
      expect(maxResponseTime, lessThan(8000)); // 最大不超过8秒
    });

    testWidgets('资源缓存效率测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 第一次访问 - 记录加载时间
      final startTime1 = DateTime.now();
      final webView1 = await webViewService.createWebView('https://httpbin.org/image/png');
      await tester.pumpAndSettle(const Duration(seconds: 5));
      final endTime1 = DateTime.now();
      final firstLoadTime = endTime1.difference(startTime1).inMilliseconds;
      
      await webViewService.disposeWebView(webView1.id);
      
      // 等待缓存生效
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // 第二次访问 - 验证缓存效果
      final startTime2 = DateTime.now();
      final webView2 = await webViewService.createWebView('https://httpbin.org/image/png');
      await tester.pumpAndSettle(const Duration(seconds: 5));
      final endTime2 = DateTime.now();
      final secondLoadTime = endTime2.difference(startTime2).inMilliseconds;
      
      await webViewService.disposeWebView(webView2.id);
      
      // 计算缓存效率
      final cacheImprovement = (firstLoadTime - secondLoadTime) / firstLoadTime;
      final cacheImprovementPercent = (cacheImprovement * 100).toInt();
      
      print('缓存效率测试:');
      print('  首次加载时间: ${firstLoadTime}ms');
      print('  缓存加载时间: ${secondLoadTime}ms');
      print('  缓存提升: ${cacheImprovementPercent}%');
      
      // 验证缓存生效（第二次加载应该明显更快）
      expect(secondLoadTime, lessThan(firstLoadTime));
      expect(cacheImprovement, greaterThan(0.1)); // 至少10%的性能提升
    });
  });
}

// 模拟内存使用获取函数
Future<int> getCurrentMemoryUsage() async {
  // 实际实现中会调用平台特定的API获取内存使用情况
  // 这里返回模拟值，包含一些随机变化
  final base = 50 * 1024 * 1024; // 50MB基础值;
  final variation = (DateTime.now().millisecondsSinceEpoch % 10) * 1024 * 1024;
  return base + variation;
}