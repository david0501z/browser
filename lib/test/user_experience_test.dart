import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import '../main.dart' as app;
import '../core/services/proxy_service.dart';
import '../core/services/webview_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('用户体验测试', () {
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

    testWidgets('用户启动代理到浏览网页的完整流程', (WidgetTester tester) async {
      // 模拟用户打开应用
      app.main();
      await tester.pumpAndSettle();
      
      // 模拟用户点击代理设置
      final proxySettingsButton = find.byKey(const Key('proxy_settings_button'));
      await tester.tap(proxySettingsButton);
      await tester.pumpAndSettle();
      
      // 模拟用户输入代理配置
      final proxyUrlField = find.byKey(const Key('proxy_url_field'));
      await tester.enterText(proxyUrlField, 'http://127.0.0.1:8080');
      await tester.pumpAndSettle();
      
      final connectButton = find.byKey(const Key('connect_button'));
      await tester.tap(connectButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // 验证代理连接状态
      final statusText = find.byKey(const Key('proxy_status_text'));
      expect(statusText, findsOneWidget);
      
      // 模拟用户点击浏览器按钮
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      // 验证浏览器界面显示
      final addressBar = find.byKey(const Key('address_bar'));
      expect(addressBar, findsOneWidget);
      
      // 模拟用户在地址栏输入网址
      await tester.enterText(addressBar, 'https://example.com');
      await tester.pumpAndSettle();
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // 验证页面加载成功
      final webView = find.byKey(const Key('main_webview'));
      expect(webView, findsOneWidget);
      
      // 验证页面标题
      final pageTitle = find.byKey(const Key('page_title'));
      expect(pageTitle, findsOneWidget);
    });

    testWidgets('代理连接失败时的用户体验', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // 模拟用户配置无效代理
      final proxySettingsButton = find.byKey(const Key('proxy_settings_button'));
      await tester.tap(proxySettingsButton);
      await tester.pumpAndSettle();
      
      final proxyUrlField = find.byKey(const Key('proxy_url_field'));
      await tester.enterText(proxyUrlField, 'http://invalid.proxy:8080');
      await tester.pumpAndSettle();
      
      final connectButton = find.byKey(const Key('connect_button'));
      await tester.tap(connectButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证显示连接失败错误信息
      final errorDialog = find.byKey(const Key('connection_error_dialog'));
      expect(errorDialog, findsOneWidget);
      
      // 验证错误信息内容
      final errorText = find.byKey(const Key('error_message_text'));
      expect(errorText, findsWidgets); // 可能显示多条错误信息
      
      // 模拟用户关闭错误对话框
      final okButton = find.byKey(const Key('error_ok_button'));
      await tester.tap(okButton);
      await tester.pumpAndSettle();
      
      // 验证应用返回到可用状态
      final connectButtonAgain = find.byKey(const Key('connect_button'));
      expect(connectButtonAgain, findsOneWidget);
    });

    testWidgets('网络加载进度指示器测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      app.main();
      await tester.pumpAndSettle();
      
      // 进入浏览器
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://httpbin.org/delay/3'); // 3秒延迟
      await tester.pumpAndSettle();
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle(); // 开始加载
      
      // 验证加载指示器显示
      final loadingIndicator = find.byKey(const Key('loading_indicator'));
      expect(loadingIndicator, findsOneWidget);
      
      // 验证进度条或加载动画
      final progressBar = find.byKey(const Key('loading_progress_bar'));
      expect(progressBar, findsOneWidget);
      
      // 等待加载完成
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // 验证加载完成后指示器消失
      expect(loadingIndicator, findsNothing);
      expect(progressBar, findsNothing);
    });

    testWidgets('多标签页用户体验测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      app.main();
      await tester.pumpAndSettle();
      
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      // 创建第一个标签页
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://example.com');
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证第一个标签页加载
      final tab1 = find.byKey(const Key('tab_1'));
      expect(tab1, findsOneWidget);
      
      // 创建第二个标签页
      final newTabButton = find.byKey(const Key('new_tab_button'));
      await tester.tap(newTabButton);
      await tester.pumpAndSettle();
      
      final addressBar2 = find.byKey(const Key('address_bar_tab2'));
      await tester.enterText(addressBar2, 'https://httpbin.org/ip');
      await tester.pumpAndSettle();
      
      final goButton2 = find.byKey(const Key('go_button_tab2'));
      await tester.tap(goButton2);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证第二个标签页加载
      final tab2 = find.byKey(const Key('tab_2'));
      expect(tab2, findsOneWidget);
      
      // 测试标签页切换
      await tester.tap(tab1);
      await tester.pumpAndSettle();
      
      final webView1 = find.byKey(const Key('webview_tab1'));
      expect(webView1, findsOneWidget);
      
      await tester.tap(tab2);
      await tester.pumpAndSettle();
      
      final webView2 = find.byKey(const Key('webview_tab2'));
      expect(webView2, findsOneWidget);
      
      // 测试关闭标签页
      final closeTabButton = find.byKey(const Key('close_tab_button_tab2'));
      await tester.tap(closeTabButton);
      await tester.pumpAndSettle();
      
      expect(tab2, findsNothing);
      expect(webView2, findsNothing);
    });

    testWidgets('代理切换时的用户体验', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // 配置第一个代理
      final proxySettingsButton = find.byKey(const Key('proxy_settings_button'));
      await tester.tap(proxySettingsButton);
      await tester.pumpAndSettle();
      
      final proxyUrlField = find.byKey(const Key('proxy_url_field'));
      await tester.enterText(proxyUrlField, 'http://127.0.0.1:8080');
      await tester.pumpAndSettle();
      
      final connectButton = find.byKey(const Key('connect_button'));
      await tester.tap(connectButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // 进入浏览器并加载页面
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://httpbin.org/ip');
      await tester.pumpAndSettle();
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 切换代理配置
      final settingsButton = find.byKey(const Key('settings_button'));
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();
      
      final proxySettingsAgain = find.byKey(const Key('proxy_settings_button'));
      await tester.tap(proxySettingsAgain);
      await tester.pumpAndSettle();
      
      // 清除并输入新代理
      await tester.tap(proxyUrlField);
      await tester.pumpAndSettle();
      
      final clearButton = find.byKey(const Key('clear_proxy_url_button'));
      await tester.tap(clearButton);
      await tester.pumpAndSettle();
      
      await tester.enterText(proxyUrlField, 'socks5://127.0.0.1:1080');
      await tester.pumpAndSettle();
      
      final connectButton2 = find.byKey(const Key('connect_button'));
      await tester.tap(connectButton2);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // 验证代理切换提示信息
      final switchNotification = find.byKey(const Key('proxy_switch_notification'));
      expect(switchNotification, findsOneWidget);
      
      // 返回浏览器验证页面重新加载
      final backToBrowser = find.byKey(const Key('back_to_browser_button'));
      await tester.tap(backToBrowser);
      await tester.pumpAndSettle();
      
      // 验证页面状态
      final webView = find.byKey(const Key('main_webview'));
      expect(webView, findsOneWidget);
    });

    testWidgets('错误页面和重试用户体验', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // 进入浏览器
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      // 尝试访问不存在的网站
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://this-domain-does-not-exist-12345.com');
      await tester.pumpAndSettle();
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // 验证显示错误页面
      final errorPage = find.byKey(const Key('error_page'));
      expect(errorPage, findsOneWidget);
      
      // 验证错误信息显示
      final errorMessage = find.byKey(const Key('error_message'));
      expect(errorMessage, findsOneWidget);
      
      // 验证重试按钮显示
      final retryButton = find.byKey(const Key('retry_button'));
      expect(retryButton, findsOneWidget);
      
      // 模拟用户点击重试
      await tester.tap(retryButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证重试后显示加载状态
      final loadingIndicator = find.byKey(const Key('loading_indicator'));
      expect(loadingIndicator, findsOneWidget);
      
      // 等待重试完成
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // 验证重试后仍显示错误页面（因为域名确实不存在）
      expect(errorPage, findsOneWidget);
    });

    testWidgets('用户设置和偏好设置测试', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // 打开设置页面
      final settingsButton = find.byKey(const Key('settings_button'));
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();
      
      // 测试代理设置
      final proxySettings = find.byKey(const Key('proxy_settings_option'));
      await tester.tap(proxySettings);
      await tester.pumpAndSettle();
      
      // 测试代理类型选择
      final proxyTypeDropdown = find.byKey(const Key('proxy_type_dropdown'));
      await tester.tap(proxyTypeDropdown);
      await tester.pumpAndSettle();
      
      final socks5Option = find.byKey(const Key('proxy_type_socks5'));
      await tester.tap(socks5Option);
      await tester.pumpAndSettle();
      
      // 测试代理认证设置
      final authenticationSwitch = find.byKey(const Key('proxy_auth_switch'));
      await tester.tap(authenticationSwitch);
      await tester.pumpAndSettle();
      
      final usernameField = find.byKey(const Key('proxy_username_field'));
      await tester.enterText(usernameField, 'testuser');
      await tester.pumpAndSettle();
      
      final passwordField = find.byKey(const Key('proxy_password_field'));
      await tester.enterText(passwordField, 'testpass');
      await tester.pumpAndSettle();
      
      // 保存设置
      final saveButton = find.byKey(const Key('save_settings_button'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      
      // 验证设置保存成功提示
      final savedMessage = find.byKey(const Key('settings_saved_message'));
      expect(savedMessage, findsOneWidget);
      
      // 返回主界面
      final backButton = find.byKey(const Key('back_button'));
      await tester.tap(backButton);
      await tester.pumpAndSettle();
      
      // 验证设置已生效（显示SOCKS5）
      final proxyStatus = find.byKey(const Key('proxy_status_text'));
      expect(proxyStatus, findsOneWidget);
    });
  });
}