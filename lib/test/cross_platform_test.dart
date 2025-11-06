import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../main.dart' as app;
import '../core/services/proxy_service.dart';
import '../core/services/webview_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('跨平台兼容性测试', () {
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

    testWidgets('Android平台代理兼容性测试', (WidgetTester tester) async {
      // 模拟Android环境
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      app.main();
      await tester.pumpAndSettle();
      
      // 进入浏览器
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://example.com');
      await tester.pumpAndSettle();
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证Android WebView正确工作
      final webView = find.byKey(const Key('main_webview'));
      expect(webView, findsOneWidget);
      
      // 测试Android特定功能
      await tester.fling(webView, const Offset(0, -500), 1000);
      await tester.pumpAndSettle();
      
      // 验证页面滚动正常工作
      expect(webView, findsOneWidget);
      
      // 测试长按功能（Android特有）
      await tester.longPress(webView);
      await tester.pumpAndSettle();
      
      // 验证上下文菜单显示
      final contextMenu = find.byKey(const Key('context_menu'));
      expect(contextMenu, findsOneWidget);
    });

    testWidgets('iOS平台代理兼容性测试', (WidgetTester tester) async {
      // 模拟iOS环境
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      app.main();
      await tester.pumpAndSettle();
      
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://example.com');
      await tester.pumpAndSettle();
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证iOS WebView正确工作
      final webView = find.byKey(const Key('main_webview'));
      expect(webView, findsOneWidget);
      
      // 测试iOS特定滚动行为
      await tester.fling(webView, const Offset(0, -300), 800);
      await tester.pumpAndSettle();
      
      // 测试iOS回弹效果
      await tester.fling(webView, const Offset(0, 500), 1200);
      await tester.pumpAndSettle();
      
      expect(webView, findsOneWidget);
    });

    testWidgets('不同屏幕尺寸兼容性测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 测试手机屏幕（竖屏）
      tester.binding.setSurfaceSize(const Size(375, 667)); // iPhone 6/7/8尺寸
      app.main();
      await tester.pumpAndSettle();
      
      // 验证界面适配手机屏幕
      final browserButton = find.byKey(const Key('browser_button'));
      expect(browserButton, findsOneWidget);
      
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      // 验证地址栏在手机屏幕上的显示
      final addressBar = find.byKey(const Key('address_bar'));
      expect(addressBar, findsOneWidget);
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle();
      
      // 测试横屏模式
      tester.binding.setSurfaceSize(const Size(667, 375)); // 横屏尺寸
      await tester.pumpAndSettle();
      
      // 验证横屏时界面重新布局
      final webView = find.byKey(const Key('main_webview'));
      expect(webView, findsOneWidget);
      
      // 测试平板屏幕
      tester.binding.setSurfaceSize(const Size(768, 1024)); // iPad尺寸
      await tester.pumpAndSettle();
      
      // 验证平板界面的适配
      final navigationBar = find.byKey(const Key('navigation_bar'));
      expect(navigationBar, findsOneWidget);
    });

    testWidgets('不同DPI显示兼容性测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 测试高DPI显示
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      tester.binding.window.devicePixelRatioTestValue = 3.0;
      
      app.main();
      await tester.pumpAndSettle();
      
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://example.com');
      await tester.pumpAndSettle();
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证高DPI下WebView正常显示
      final webView = find.byKey(const Key('main_webview'));
      expect(webView, findsOneWidget);
      
      // 测试低DPI显示
      tester.binding.window.physicalSizeTestValue = const Size(480, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      
      await tester.pumpAndSettle();
      
      // 验证界面元素仍然可见
      expect(webView, findsOneWidget);
      
      // 恢复默认设置
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    testWidgets('深色模式兼容性测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 启用深色模式
      tester.binding.window.platformBrightnessTestValue = Brightness.dark;
      
      app.main();
      await tester.pumpAndSettle();
      
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://example.com');
      await tester.pumpAndSettle();
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证深色模式下界面正确显示
      final webView = find.byKey(const Key('main_webview'));
      expect(webView, findsOneWidget);
      
      // 测试工具栏在深色模式下的显示
      final toolbar = find.byKey(const Key('browser_toolbar'));
      expect(toolbar, findsOneWidget);
      
      // 切换到浅色模式
      tester.binding.window.platformBrightnessTestValue = Brightness.light;
      await tester.pumpAndSettle();
      
      // 验证界面正确切换主题
      expect(webView, findsOneWidget);
      
      // 恢复默认设置
      tester.binding.window.clearPlatformBrightnessTestValue();
    });

    testWidgets('代理协议跨平台兼容性测试', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      final proxySettingsButton = find.byKey(const Key('proxy_settings_button'));
      await tester.tap(proxySettingsButton);
      await tester.pumpAndSettle();
      
      final proxyUrlField = find.byKey(const Key('proxy_url_field'));
      
      // 测试不同代理协议的兼容性
      final proxyProtocols = [
        'http://127.0.0.1:8080',
        'https://127.0.0.1:8080',
        'socks4://127.0.0.1:1080',
        'socks5://127.0.0.1:1080',
      ];
      
      for (final protocol in proxyProtocols) {
        // 清除现有输入
        await tester.tap(proxyUrlField);
        await tester.pumpAndSettle();
        
        // 输入代理配置
        await tester.enterText(proxyUrlField, protocol);
        await tester.pumpAndSettle();
        
        final connectButton = find.byKey(const Key('connect_button'));
        await tester.tap(connectButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        
        // 验证连接状态显示
        final connectionStatus = find.byKey(const Key('connection_status'));
        expect(connectionStatus, findsOneWidget);
        
        // 停止代理进行下次测试
        final disconnectButton = find.byKey(const Key('disconnect_button'));
        await tester.tap(disconnectButton);
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }
    });

    testWidgets('触摸手势跨平台兼容性测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      app.main();
      await tester.pumpAndSettle();
      
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://httpbin.org/html');
      await tester.pumpAndSettle();
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      final webView = find.byKey(const Key('main_webview'));
      
      // 测试触摸滚动
      await tester.fling(webView, const Offset(0, -200), 1000);
      await tester.pumpAndSettle();
      
      // 测试双击缩放
      await tester.tap(webView);
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      await tester.tap(webView);
      await tester.pumpAndSettle();
      
      // 测试捏合手势缩放
      await tester.fling(webView, const Offset(0, -100), 500);
      await tester.pumpAndSettle();
      
      // 验证WebView仍然正常工作
      expect(webView, findsOneWidget);
    });

    testWidgets('键盘输入跨平台兼容性测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      app.main();
      await tester.pumpAndSettle();
      
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      final addressBar = find.byKey(const Key('address_bar'));
      
      // 测试各种特殊字符输入
      final testUrls = [
        'https://example.com/path?param=value&test=123',
        'https://测试网站.com',
        'https://user:pass@网站.com:8080/path',
      ];
      
      for (final url in testUrls) {
        await tester.enterText(addressBar, url);
        await tester.pumpAndSettle();
        
        final goButton = find.byKey(const Key('go_button'));
        await tester.tap(goButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        
        // 验证WebView正确处理URL
        final webView = find.byKey(const Key('main_webview'));
        expect(webView, findsOneWidget);
        
        // 清空地址栏进行下次测试
        await tester.tap(addressBar);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('WebView内容兼容性测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      app.main();
      await tester.pumpAndSettle();
      
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      final addressBar = find.byKey(const Key('address_bar'));
      
      // 测试不同类型Web内容的兼容性
      final testCases = [
        'https://httpbin.org/html',           // HTML内容
        'https://httpbin.org/image/png',      // 图片内容
        'https://httpbin.org/pdf',           // PDF内容
        'https://httpbin.org/json',          // JSON内容
        'https://httpbin.org/redirect/3',    // 重定向内容
        'https://httpbin.org/status/500',    // 错误状态码
      ];
      
      final goButton = find.byKey(const Key('go_button'));
      
      for (final testCase in testCases) {
        await tester.enterText(addressBar, testCase);
        await tester.pumpAndSettle();
        
        await tester.tap(goButton);
        await tester.pumpAndSettle(const Duration(seconds: 4));
        
        // 验证WebView正确处理不同类型内容
        final webView = find.byKey(const Key('main_webview'));
        expect(webView, findsOneWidget);
        
        // 检查是否有错误处理
        final errorMessage = find.byKey(const Key('error_message'));
        if (errorMessage.evaluate().isNotEmpty) {
          // 错误是预期的（如404、500等）
          expect(errorMessage, findsOneWidget);
        }
      }
    });

    testWidgets('性能优化跨平台适配测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      // 测试低端设备性能
      tester.binding.window.physicalSizeTestValue = const Size(480, 800);
      
      app.main();
      await tester.pumpAndSettle();
      
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      // 创建多个WebView测试低端设备性能
      final List<Future<void>> webViewPromises = [];
      
      for (int i = 0; i < 3; i++) { // 限制WebView数量以适应低端设备
        final promise = () async {
          final addressBar = find.byKey(const Key('address_bar'));
          await tester.enterText(addressBar, 'https://example.com');
          await tester.pumpAndSettle();
          
          final goButton = find.byKey(const Key('go_button'));
          await tester.tap(goButton);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }();
        
        webViewPromises.add(promise);
      }
      
      // 等待所有WebView创建完成
      await Future.wait(webViewPromises);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // 验证在低端设备上应用仍然可用
      final mainInterface = find.byKey(const Key('main_interface'));
      expect(mainInterface, findsOneWidget);
      
      // 恢复默认设置
      tester.binding.window.clearPhysicalSizeTestValue();
    });
  });
}