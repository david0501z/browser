import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import '../main.dart' as app;
import '../core/services/proxy_service.dart';
import '../core/services/webview_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('导航和功能测试', () {
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

    testWidgets('基本页面导航功能测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      app.main();
      await tester.pumpAndSettle();
      
      // 进入浏览器
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      // 测试前进导航
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://example.com');
      await tester.pumpAndSettle();
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证前进按钮状态
      final forwardButton = find.byKey(const Key('forward_button'));
      expect(forwardButton, findsOneWidget);
      
      // 测试后退导航
      final backButton = find.byKey(const Key('back_button'));
      await tester.tap(backButton);
      await tester.pumpAndSettle();
      
      // 验证返回到地址栏
      expect(addressBar, findsOneWidget);
      
      // 再次前进到第一个页面
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证前进按钮现在可用
      expect(forwardButton, findsOneWidget);
    });

    testWidgets('页面内搜索功能测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      app.main();
      await tester.pumpAndSettle();
      
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      // 加载包含大量文本的页面
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://httpbin.org/html');
      await tester.pumpAndSettle();
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 打开搜索功能
      final searchButton = find.byKey(const Key('search_button'));
      await tester.tap(searchButton);
      await tester.pumpAndSettle();
      
      // 验证搜索框显示
      final searchBox = find.byKey(const Key('search_box'));
      expect(searchBox, findsOneWidget);
      
      // 输入搜索关键词
      await tester.enterText(searchBox, 'Herman Melville');
      await tester.pumpAndSettle();
      
      // 执行搜索
      final searchGoButton = find.byKey(const Key('search_go_button'));
      await tester.tap(searchGoButton);
      await tester.pumpAndSettle();
      
      // 验证搜索高亮显示
      final highlightedText = find.byKey(const Key('search_highlight'));
      expect(highlightedText, findsOneWidget);
      
      // 测试搜索下一个
      final searchNextButton = find.byKey(const Key('search_next_button'));
      await tester.tap(searchNextButton);
      await tester.pumpAndSettle();
      
      // 测试搜索上一个
      final searchPrevButton = find.byKey(const Key('search_prev_button'));
      await tester.tap(searchPrevButton);
      await tester.pumpAndSettle();
      
      // 关闭搜索
      final closeSearchButton = find.byKey(const Key('close_search_button'));
      await tester.tap(closeSearchButton);
      await tester.pumpAndSettle();
      
      // 验证搜索框消失
      expect(searchBox, findsNothing);
    });

    testWidgets('书签功能测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      app.main();
      await tester.pumpAndSettle();
      
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      // 加载第一个页面并添加到书签
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://example.com');
      await tester.pumpAndSettle();
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 添加书签
      final bookmarkButton = find.byKey(const Key('bookmark_button'));
      await tester.tap(bookmarkButton);
      await tester.pumpAndSettle();
      
      // 验证书签添加对话框
      final bookmarkDialog = find.byKey(const Key('bookmark_dialog'));
      expect(bookmarkDialog, findsOneWidget);
      
      // 输入书签名称
      final bookmarkNameField = find.byKey(const Key('bookmark_name_field'));
      await tester.enterText(bookmarkNameField, '示例网站');
      await tester.pumpAndSettle();
      
      // 保存书签
      final saveBookmarkButton = find.byKey(const Key('save_bookmark_button'));
      await tester.tap(saveBookmarkButton);
      await tester.pumpAndSettle();
      
      // 加载第二个页面
      await tester.enterText(addressBar, 'https://httpbin.org/ip');
      await tester.pumpAndSettle();
      
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 打开书签管理器
      final bookmarksButton = find.byKey(const Key('bookmarks_button'));
      await tester.tap(bookmarksButton);
      await tester.pumpAndSettle();
      
      // 验证书签列表显示
      final bookmarkList = find.byKey(const Key('bookmark_list'));
      expect(bookmarkList, findsOneWidget);
      
      // 验证书签项目
      final exampleBookmark = find.byKey(const Key('bookmark_example'));
      expect(exampleBookmark, findsOneWidget);
      
      // 点击书签访问
      await tester.tap(exampleBookmark);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证成功跳转到书签页面
      expect(addressBar, findsOneWidget);
    });

    testWidgets('下载管理功能测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      app.main();
      await tester.pumpAndSettle();
      
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      // 访问包含下载链接的页面
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://httpbin.org/redirect-to?url=https://httpbin.org/image/png');
      await tester.pumpAndSettle();
      
      final goButton = find.byKey('go_button');
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 模拟长按下载图片
      final webView = find.byKey(const Key('main_webview'));
      await tester.longPress(webView);
      await tester.pumpAndSettle();
      
      // 验证上下文菜单显示
      final contextMenu = find.byKey(const Key('context_menu'));
      expect(contextMenu, findsOneWidget);
      
      // 点击下载选项
      final downloadOption = find.byKey(const Key('download_option'));
      await tester.tap(downloadOption);
      await tester.pumpAndSettle();
      
      // 验证下载进度对话框
      final downloadDialog = find.byKey(const Key('download_dialog'));
      expect(downloadDialog, findsOneWidget);
      
      // 验证下载进度显示
      final downloadProgress = find.byKey(const Key('download_progress'));
      expect(downloadProgress, findsOneWidget);
      
      // 等待下载完成
      await tester.pumpAndSettle(const Duration(seconds: 10));
      
      // 验证下载完成提示
      final downloadCompleteMessage = find.byKey(const Key('download_complete_message'));
      expect(downloadCompleteMessage, findsOneWidget);
      
      // 打开下载管理器
      final downloadsButton = find.byKey(const Key('downloads_button'));
      await tester.tap(downloadsButton);
      await tester.pumpAndSettle();
      
      // 验证下载项目显示
      final downloadItem = find.byKey(const Key('download_item'));
      expect(downloadItem, findsOneWidget);
    });

    testWidgets('页面缩放功能测试', (WidgetTester tester) async {
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
      
      // 打开缩放控件
      final zoomControls = find.byKey(const Key('zoom_controls'));
      expect(zoomControls, findsOneWidget);
      
      // 测试放大
      final zoomInButton = find.byKey(const Key('zoom_in_button'));
      await tester.tap(zoomInButton);
      await tester.pumpAndSettle();
      
      await tester.tap(zoomInButton);
      await tester.pumpAndSettle();
      
      // 验证缩放级别增加
      final zoomLevelIndicator = find.byKey(const Key('zoom_level_indicator'));
      expect(zoomLevelIndicator, findsOneWidget);
      
      // 测试缩小
      final zoomOutButton = find.byKey(const Key('zoom_out_button'));
      await tester.tap(zoomOutButton);
      await tester.pumpAndSettle();
      
      await tester.tap(zoomOutButton);
      await tester.pumpAndSettle();
      
      // 测试重置缩放
      final zoomResetButton = find.byKey(const Key('zoom_reset_button'));
      await tester.tap(zoomResetButton);
      await tester.pumpAndSettle();
      
      // 验证缩放级别重置
      final resetZoomText = find.byKey(const Key('zoom_reset_text'));
      expect(resetZoomText, findsOneWidget);
    });

    testWidgets('历史记录功能测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      app.main();
      await tester.pumpAndSettle();
      
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      // 访问多个页面创建历史记录
      final List<String> urls = [
        'https://example.com',
        'https://httpbin.org/ip',
        'https://httpbin.org/html',
      ];
      
      final addressBar = find.byKey(const Key('address_bar'));
      final goButton = find.byKey(const Key('go_button'));
      
      for (final url in urls) {
        await tester.enterText(addressBar, url);
        await tester.pumpAndSettle();
        
        await tester.tap(goButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }
      
      // 打开历史记录
      final historyButton = find.byKey(const Key('history_button'));
      await tester.tap(historyButton);
      await tester.pumpAndSettle();
      
      // 验证历史记录显示
      final historyList = find.byKey(const Key('history_list'));
      expect(historyList, findsOneWidget);
      
      // 验证历史记录项目数量
      final historyItems = find.byKey(const Key('history_item'));
      expect(historyItems, findsNWidgets(3)); // 应该有三个历史记录项
      
      // 点击历史记录项
      await tester.tap(historyItems.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证成功跳转到历史页面
      expect(addressBar, findsOneWidget);
      
      // 清空历史记录
      final clearHistoryButton = find.byKey(const Key('clear_history_button'));
      await tester.tap(clearHistoryButton);
      await tester.pumpAndSettle();
      
      // 确认清空
      final confirmClearButton = find.byKey(const Key('confirm_clear_history_button'));
      await tester.tap(confirmClearButton);
      await tester.pumpAndSettle();
      
      // 验证历史记录已清空
      expect(historyItems, findsNothing);
    });

    testWidgets('多窗口和弹窗处理测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      app.main();
      await tester.pumpAndSettle();
      
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      // 访问包含弹窗的测试页面
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://httpbin.org/response-headers?popup=true');
      await tester.pumpAndSettle();
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证弹窗处理设置显示
      final popupSettings = find.byKey(const Key('popup_settings'));
      expect(popupSettings, findsOneWidget);
      
      // 启用弹窗拦截
      final blockPopupsSwitch = find.byKey(const Key('block_popups_switch'));
      await tester.tap(blockPopupsSwitch);
      await tester.pumpAndSettle();
      
      // 重新加载页面测试弹窗拦截
      await tester.tap(goButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 验证弹窗被拦截
      final popupBlockedMessage = find.byKey(const Key('popup_blocked_message'));
      expect(popupBlockedMessage, findsOneWidget);
      
      // 测试新窗口处理
      final openNewWindowButton = find.byKey(const Key('open_new_window_button'));
      await tester.tap(openNewWindowButton);
      await tester.pumpAndSettle();
      
      // 验证新窗口处理选项
      final newWindowHandling = find.byKey(const Key('new_window_handling'));
      expect(newWindowHandling, findsOneWidget);
    });

    testWidgets('刷新和停止功能测试', (WidgetTester tester) async {
      await proxyService.startProxy('http://127.0.0.1:8080');
      
      app.main();
      await tester.pumpAndSettle();
      
      final browserButton = find.byKey(const Key('browser_button'));
      await tester.tap(browserButton);
      await tester.pumpAndSettle();
      
      final addressBar = find.byKey(const Key('address_bar'));
      await tester.enterText(addressBar, 'https://httpbin.org/delay/3');
      await tester.pumpAndSettle();
      
      final goButton = find.byKey(const Key('go_button'));
      await tester.tap(goButton);
      await tester.pumpAndSettle();
      
      // 验证停止按钮在加载时显示
      final stopButton = find.byKey(const Key('stop_button'));
      expect(stopButton, findsOneWidget);
      
      // 模拟用户点击停止按钮
      await tester.tap(stopButton);
      await tester.pumpAndSettle();
      
      // 验证加载停止，停止按钮消失，刷新按钮显示
      final refreshButton = find.byKey(const Key('refresh_button'));
      expect(refreshButton, findsOneWidget);
      expect(stopButton, findsNothing);
      
      // 测试刷新功能
      await tester.tap(refreshButton);
      await tester.pumpAndSettle();
      
      // 验证刷新后停止按钮再次显示
      expect(stopButton, findsOneWidget);
      
      // 等待刷新完成
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // 验证刷新完成后显示刷新按钮
      expect(refreshButton, findsOneWidget);
      expect(stopButton, findsNothing);
    });
  });
}