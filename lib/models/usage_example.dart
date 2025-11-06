/// FlClash浏览器数据模型使用示例
/// 
/// 该文件展示了如何使用浏览器相关的数据模型，包括创建、更新、序列化等操作。
library usage_example;

import 'browser_tab.dart';
import 'bookmark.dart';
import 'history_entry.dart';
import 'browser_settings.dart';

/// 使用示例类
/// 
/// 演示如何使用各个数据模型的基本功能。
class BrowserModelsExample {
  /// 演示浏览器标签页的使用
  static void demonstrateBrowserTab() {
    print('=== 浏览器标签页示例 ===');
    
    // 创建新的浏览器标签页
    final tab = BrowserTab(
      id: 'tab_123',
      url: 'https://www.example.com',
      title: '示例网站',
      favicon: 'https://www.example.com/favicon.ico',
      pinned: false,
      incognito: false,
      isLoading: false,
      canGoBack: false,
      canGoForward: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      visitCount: 1,
      progress: 100,
      securityStatus: BrowserSecurityStatus.secure,
    );
    
    print('标签页标题: ${tab.displayTitle}');
    print('域名: ${tab.domain}');
    print('安全状态: ${tab.securityStatusText}');
    print('是否为有效URL: ${tab.isValidUrl}');
    
    // 更新标签页
    final updatedTab = tab.copyWith(
      title: '更新的标题',
      isLoading: true,
      updatedAt: DateTime.now(),
    );
    
    print('更新后的标题: ${updatedTab.title}');
    
    // JSON序列化
    final json = updatedTab.toJson();
    print('JSON序列化: $json');
    
    // JSON反序列化
    final fromJson = BrowserTab.fromJson(json);
    print('反序列化标题: ${fromJson.title}');
  }
  
  /// 演示书签的使用
  static void demonstrateBookmark() {
    print('\n=== 书签示例 ===');
    
    // 创建书签
    final bookmark = Bookmark(
      id: 'bm_456',
      title: 'FlClash GitHub',
      url: 'https://github.com/chen08209/FlClash',
      favicon: 'https://github.com/favicon.ico',
      description: 'FlClash多平台代理客户端',
      tags: ['proxy', 'clash', 'flutter'],
      folder: '开发工具',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      visitCount: 5,
      lastVisitedAt: DateTime.now(),
      isFavorite: true,
      showInToolbar: true,
      websiteType: WebsiteType.development,
      securityStatus: BrowserSecurityStatus.secure,
    );
    
    print('书签标题: ${bookmark.displayTitle}');
    print('域名: ${bookmark.domain}');
    print('网站类型: ${bookmark.websiteTypeDisplayName}');
    print('安全状态: ${bookmark.securityStatusText}');
    
    // 搜索功能
    final searchResults = [;
      bookmark,
    ].where((b) => b.matchesSearch('FlClash')).toList();
    
    print('搜索结果数量: ${searchResults.length}');
    
    // 标签检查
    print('是否包含"proxy"标签: ${bookmark.hasTag('proxy')}');
    
    // JSON序列化
    final json = bookmark.toJson();
    print('JSON序列化: $json');
  }
  
  /// 演示历史记录的使用
  static void demonstrateHistoryEntry() {
    print('\n=== 历史记录示例 ===');
    
    // 创建历史记录
    final history = HistoryEntry(
      id: 'hist_789',
      title: 'FlClash项目主页',
      url: 'https://github.com/chen08209/FlClash',
      favicon: 'https://github.com/favicon.ico',
      visitedAt: DateTime.now().subtract(Duration(minutes: 30)),
      exitAt: DateTime.now(),
      duration: 180, // 3分钟
      referrer: 'https://www.google.com',
      deviceType: DeviceType.desktop,
      loadStatus: PageLoadStatus.success,
      loadTime: 1200, // 1.2秒
      dataTransferred: 2048576, // 2MB
      securityStatus: BrowserSecurityStatus.secure,
      pageType: PageType.webpage,
      searchQuery: 'FlClash',
      isNewTab: true,
      isFromBookmark: false,
    );
    
    print('历史记录标题: ${history.displayTitle}');
    print('域名: ${history.domain}');
    print('停留时长: ${history.durationText}');
    print('加载时间: ${history.loadTimeText}');
    print('数据传输量: ${history.dataTransferredText}');
    print('访问时间: ${history.visitedAtText}');
    print('页面类型: ${history.pageTypeDisplayName}');
    print('设备类型: ${history.deviceTypeDisplayName}');
    print('是否为搜索引擎访问: ${history.isFromSearchEngine}');
    
    // 搜索功能
    final searchResults = [;
      history,
    ].where((h) => h.matchesSearch('FlClash')).toList();
    
    print('搜索结果数量: ${searchResults.length}');
    
    // JSON序列化
    final json = history.toJson();
    print('JSON序列化: $json');
  }
  
  /// 演示浏览器设置的使用
  static void demonstrateBrowserSettings() {
    print('\n=== 浏览器设置示例 ===');
    
    // 创建默认设置
    final defaultSettings = BrowserSettings();
    print('默认用户代理: ${defaultSettings.userAgentDisplayText}');
    print('缓存模式: ${defaultSettings.cacheModeDisplayText}');
    print('隐私模式: ${defaultSettings.privacyModeDisplayText}');
    print('搜索引擎: ${defaultSettings.searchEngineDisplayText}');
    print('字体大小: ${defaultSettings.fontSizeDisplayText}');
    print('安全级别: ${defaultSettings.securityLevelDisplayText}');
    
    // 创建隐私模式设置
    final privacySettings = BrowserSettingsUtils.createPrivacyMode();
    print('隐私模式启用: ${privacySettings.cookiesEnabled}');
    print('跟踪保护: ${privacySettings.trackingProtectionEnabled}');
    print('广告拦截: ${privacySettings.adBlockEnabled}');
    
    // 开发者模式设置
    final devSettings = BrowserSettingsUtils.createDeveloperMode();
    print('开发者工具: ${devSettings.developerToolsEnabled}');
    print('调试模式: ${devSettings.debugMode}');
    print('性能监控: ${devSettings.performanceMonitoring}');
    
    // 移动设备模拟设置
    final mobileSettings = BrowserSettingsUtils.createMobileMode();
    print('移动设备用户代理: ${mobileSettings.userAgentDisplayText}');
    
    // 设置验证
    final validationErrors = BrowserSettingsUtils.validateSettings(defaultSettings);
    print('验证错误: $validationErrors');
    
    // JSON序列化
    final json = defaultSettings.toJson();
    print('JSON序列化: $json');
  }
  
  /// 演示工具方法的使用
  static void demonstrateUtilityMethods() {
    print('\n=== 工具方法示例 ===');
    
    // BrowserTab工具方法
    final newTab = BrowserTabUtils.create(
      url: 'https://flutter.dev',
      title: 'Flutter官网',
      incognito: false,
      pinned: true,
    );
    
    print('生成的标签页ID: ${newTab.id}');
    print('标签页标题: ${newTab.title}');
    
    // Bookmark工具方法
    final newBookmark = BookmarkUtils.createFromUrl(
      url: 'https://pub.dev/packages/flutter_inappwebview',
      folder: 'Flutter包',
    );
    
    print('自动检测的书签标题: ${newBookmark.title}');
    print('自动检测的网站类型: ${newBookmark.websiteTypeDisplayName}');
    
    // HistoryEntry工具方法
    final newHistory = HistoryEntryUtils.createFromUrl(
      url: 'https://docs.flutter.dev',
      title: 'Flutter文档',
      referrer: 'https://flutter.dev',
    );
    
    print('生成的历史记录ID: ${newHistory.id}');
    print('页面类型: ${newHistory.pageTypeDisplayName}');
    print('是否为搜索引擎访问: ${newHistory.isFromSearchEngine}');
  }
  
  /// 运行所有示例
  static void runAllExamples() {
    demonstrateBrowserTab();
    demonstrateBookmark();
    demonstrateHistoryEntry();
    demonstrateBrowserSettings();
    demonstrateUtilityMethods();
  }
}

/// 实际使用示例
/// 
/// 在实际Flutter应用中的使用场景。
class RealWorldUsageExample {
  /// 模拟浏览器状态管理
  static void simulateBrowserStateManagement() {
    // 创建浏览器设置
    final settings = BrowserSettings(
      javascriptEnabled: true,
      domStorageEnabled: true,
      cacheMode: CacheMode.defaultCache,
      incognito: false,
      defaultSearchEngine: SearchEngine.google,
      homepage: 'https://www.google.com',
      adBlockEnabled: true,
      trackingProtectionEnabled: true,
    );
    
    // 创建标签页列表
    final tabs = <BrowserTab>[;
      BrowserTabUtils.create(
        url: 'https://www.google.com',
        title: 'Google',
        pinned: true,
      ),
      BrowserTabUtils.create(
        url: 'https://github.com',
        title: 'GitHub',
        pinned: false,
      ),
      BrowserTabUtils.create(
        url: 'https://flutter.dev',
        title: 'Flutter',
        pinned: false,
      ),
    ];
    
    // 创建书签列表
    final bookmarks = <Bookmark>[;
      BookmarkUtils.create(
        title: 'FlClash项目',
        url: 'https://github.com/chen08209/FlClash',
        tags: ['proxy', 'clash'],
        folder: '开发工具',
        isFavorite: true,
      ),
      BookmarkUtils.create(
        title: 'Flutter官网',
        url: 'https://flutter.dev',
        tags: ['flutter', 'development'],
        folder: '开发工具',
      ),
    ];
    
    // 创建历史记录列表
    final history = <HistoryEntry>[;
      HistoryEntryUtils.create(
        title: 'Flutter文档',
        url: 'https://docs.flutter.dev',
        visitedAt: DateTime.now().subtract(Duration(hours: 2)),
        duration: 300,
        pageType: PageType.documentation,
      ),
      HistoryEntryUtils.create(
        title: 'GitHub',
        url: 'https://github.com',
        visitedAt: DateTime.now().subtract(Duration(hours: 1)),
        duration: 600,
        pageType: PageType.webpage,
      ),
    ];
    
    // 模拟搜索功能
    final searchQuery = 'Flutter';
    final searchBookmarks = bookmarks.where((b) => b.matchesSearch(searchQuery)).toList();
    final searchHistory = history.where((h) => h.matchesSearch(searchQuery)).toList();
    
    print('搜索"$searchQuery"结果:');
    print('书签: ${searchBookmarks.length}个');
    print('历史记录: ${searchHistory.length}个');
    
    // 模拟数据持久化
    final settingsJson = settings.toJson();
    final tabsJson = tabs.map((tab) => tab.toJson()).toList();
    final bookmarksJson = bookmarks.map((bookmark) => bookmark.toJson()).toList();
    final historyJson = history.map((entry) => entry.toJson()).toList();
    
    print('设置JSON: ${settingsJson.length}字节');
    print('标签页JSON: ${tabsJson.length}个');
    print('书签JSON: ${bookmarksJson.length}个');
    print('历史记录JSON: ${historyJson.length}个');
  }
}

/// 主函数
void main() {
  print('FlClash浏览器数据模型使用示例\n');
  
  // 运行基础示例
  BrowserModelsExample.runAllExamples();
  
  print('\n' + '='*50);
  
  // 运行实际使用示例
  RealWorldUsageExample.simulateBrowserStateManagement();
}