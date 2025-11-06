import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/browser_models.dart';

/// 浏览器设置Provider
final browserSettingsProvider = StateNotifierProvider<BrowserSettingsNotifier, BrowserSettings>(
  (ref) => BrowserSettingsNotifier(),
);

/// 浏览器标签页列表Provider
final browserTabsProvider = StateNotifierProvider<BrowserTabsNotifier, List<BrowserTab>>(
  (ref) => BrowserTabsNotifier(),
);

/// 当前活动标签页Provider
final currentTabProvider = StateProvider<BrowserTab?>((ref) {
  final tabs = ref.watch(browserTabsProvider);
  return tabs.isNotEmpty ? tabs.first : null;
});

/// 书签列表Provider
final bookmarksProvider = StateNotifierProvider<BookmarkNotifier, List<Bookmark>>(
  (ref) => BookmarkNotifier(),
);

/// 历史记录Provider
final historyProvider = StateNotifierProvider<HistoryNotifier, List<History>>(
  (ref) => HistoryNotifier(),
);

/// 浏览器状态Provider
final browserStateProvider = StateProvider<BrowserState>((ref) => BrowserState.idle);

/// 浏览器事件Provider
final browserEventProvider = StateProvider<BrowserEvent?>((ref) => null);

/// 下载任务Provider
final downloadTasksProvider = StateNotifierProvider<DownloadTasksNotifier, List<DownloadTask>>(
  (ref) => DownloadTasksNotifier(),
);

/// 浏览器统计信息Provider
final browserStatsProvider = StateProvider<BrowserStats>((ref) => const BrowserStats());

/// 搜索结果Provider
final searchResultsProvider = StateProvider<List<SearchResult>>((ref) => []);

/// 浏览器设置管理器
class BrowserSettingsNotifier extends StateNotifier<BrowserSettings> {
  BrowserSettingsNotifier() : super(_loadDefaultSettings()) {
    _loadSettings();
  }

  static const String _settingsKey = 'browser_settings';

  /// 加载默认设置
  static BrowserSettings _loadDefaultSettings() {
    return const BrowserSettings();
  }

  /// 从本地存储加载设置
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);
      
      if (settingsJson != null) {
        // 这里需要实际的JSON解析逻辑
        // final settings = BrowserSettings.fromJson(jsonDecode(settingsJson));
        // state = settings;
      }
    } catch (e) {
      debugPrint('加载浏览器设置失败: $e');
    }
  }

  /// 保存设置到本地存储
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // final settingsJson = jsonEncode(state.toJson());
      // await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      debugPrint('保存浏览器设置失败: $e');
    }
  }

  /// 更新设置
  void updateSettings(BrowserSettings newSettings) {
    state = newSettings;
    _saveSettings();
  }

  /// 重置为默认设置
  void resetToDefault() {
    state = _loadDefaultSettings();
    _saveSettings();
  }
}

/// 浏览器标签页管理器
class BrowserTabsNotifier extends StateNotifier<List<BrowserTab>> {
  BrowserTabsNotifier() : super([]);

  /// 添加新标签页
  void addTab(BrowserTab tab) {
    state = [...state, tab];
  }

  /// 关闭标签页
  void removeTab(String tabId) {
    state = state.where((tab) => tab.id != tabId).toList();
  }

  /// 更新标签页
  void updateTab(String tabId, BrowserTab updatedTab) {
    state = state.map((tab) => 
      tab.id == tabId ? updatedTab : tab
    ).toList();
  }

  /// 固定/取消固定标签页
  void togglePinTab(String tabId) {
    state = state.map((tab) {
      if (tab.id == tabId) {
        return tab.copyWith(
          pinned: !tab.pinned,
          updatedAt: DateTime.now(),
        );
      }
      return tab;
    }).toList();
  }

  /// 移动标签页位置
  void moveTab(String tabId, int newIndex) {
    final tabIndex = state.indexWhere((tab) => tab.id == tabId);
    if (tabIndex >= 0 && tabIndex < state.length && newIndex < state.length) {
      final newTabs = List<BrowserTab>.from(state);
      final tab = newTabs.removeAt(tabIndex);
      newTabs.insert(newIndex, tab);
      state = newTabs;
    }
  }

  /// 清空所有标签页
  void clearAll() {
    state = [];
  }

  /// 创建新标签页
  BrowserTab createNewTab({
    String? url,
    bool incognito = false,
  }) {
    return BrowserTab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: url ?? 'https://www.google.com',
      title: '新标签页',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      incognito: incognito,
    );
  }
}

/// 书签管理器
class BookmarkNotifier extends StateNotifier<List<Bookmark>> {
  BookmarkNotifier() : super([]);

  /// 添加书签
  void addBookmark(Bookmark bookmark) {
    // 检查是否已存在
    final exists = state.any((b) => b.url == bookmark.url);
    if (!exists) {
      state = [...state, bookmark];
    }
  }

  /// 删除书签
  void removeBookmark(String bookmarkId) {
    state = state.where((bookmark) => bookmark.id != bookmarkId).toList();
  }

  /// 更新书签
  void updateBookmark(Bookmark updatedBookmark) {
    state = state.map((bookmark) => 
      bookmark.id == updatedBookmark.id ? updatedBookmark : bookmark
    ).toList();
  }

  /// 搜索书签
  List<Bookmark> searchBookmarks(String query) {
    if (query.isEmpty) return state;
    
    final lowercaseQuery = query.toLowerCase();
    return state.where((bookmark) =>
      bookmark.title.toLowerCase().contains(lowercaseQuery) ||
      bookmark.url.toLowerCase().contains(lowercaseQuery) ||
      bookmark.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery))
    ).toList();
  }

  /// 按标签筛选书签
  List<Bookmark> filterByTag(String tag) {
    return state.where((bookmark) => bookmark.tags.contains(tag)).toList();
  }

  /// 获取所有标签
  Set<String> getAllTags() {
    return state.expand((bookmark) => bookmark.tags).toSet();
  }
}

/// 历史记录管理器
class HistoryNotifier extends StateNotifier<List<History>> {
  HistoryNotifier() : super([]);

  /// 添加历史记录
  void addHistory(History history) {
    state = [history, ...state.take(999)]; // 最多保留1000条记录
  }

  /// 删除历史记录
  void removeHistory(String historyId) {
    state = state.where((history) => history.id != historyId).toList();
  }

  /// 清空历史记录
  void clearAll() {
    state = [];
  }

  /// 清空指定时间范围的历史记录
  void clearByDateRange(DateTime start, DateTime end) {
    state = state.where((history) => 
      history.visitedAt.isBefore(start) || history.visitedAt.isAfter(end)
    ).toList();
  }

  /// 搜索历史记录
  List<History> searchHistory(String query) {
    if (query.isEmpty) return state;
    
    final lowercaseQuery = query.toLowerCase();
    return state.where((history) =>
      history.title.toLowerCase().contains(lowercaseQuery) ||
      history.url.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }

  /// 获取今日访问的网站
  List<History> getTodayHistory() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return state.where((history) =>
      history.visitedAt.isAfter(startOfDay) && history.visitedAt.isBefore(endOfDay)
    ).toList();
  }
}

/// 下载任务管理器
class DownloadTasksNotifier extends StateNotifier<List<DownloadTask>> {
  DownloadTasksNotifier() : super([]);

  /// 添加下载任务
  void addDownloadTask(DownloadTask task) {
    state = [...state, task];
  }

  /// 更新下载任务
  void updateDownloadTask(String taskId, DownloadTask updatedTask) {
    state = state.map((task) => 
      task.id == taskId ? updatedTask : task
    ).toList();
  }

  /// 移除下载任务
  void removeDownloadTask(String taskId) {
    state = state.where((task) => task.id != taskId).toList();
  }

  /// 获取进行中的下载任务
  List<DownloadTask> getActiveDownloads() {
    return state.where((task) => 
      task.status == 'downloading' || task.status == 'pending'
    ).toList();
  }

  /// 获取已完成的下载任务
  List<DownloadTask> getCompletedDownloads() {
    return state.where((task) => task.status == 'completed').toList();
  }
}