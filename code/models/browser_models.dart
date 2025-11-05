import 'package:freezed_annotation/freezed_annotation.dart';

part 'browser_models.freezed.dart';
part 'browser_models.g.dart';

/// 浏览器标签页数据模型
@freezed
class BrowserTab with _$BrowserTab {
  const factory BrowserTab({
    /// 标签页唯一标识
    required String id,
    
    /// 当前URL
    required String url,
    
    /// 页面标题
    String? title,
    
    /// 图标URL
    String? favicon,
    
    /// 是否固定标签页
    @Default(false) bool pinned,
    
    /// 创建时间
    required DateTime createdAt,
    
    /// 更新时间
    required DateTime updatedAt,
    
    /// 缩略图数据（Base64编码）
    String? thumbnail,
    
    /// 是否为无痕模式
    @Default(false) bool incognito,
  }) = _BrowserTab;

  factory BrowserTab.fromJson(Map<String, dynamic> json) =>
      _$BrowserTabFromJson(json);
}

/// 书签数据模型
@freezed
class Bookmark with _$Bookmark {
  const factory Bookmark({
    /// 唯一标识
    required String id,
    
    /// 站点标题
    required String title,
    
    /// 链接地址
    required String url,
    
    /// 图标URL
    String? favicon,
    
    /// 标签列表
    @Default([]) List<String> tags,
    
    /// 创建时间
    required DateTime createdAt,
    
    /// 更新时间
    required DateTime updatedAt,
    
    /// 访问次数
    @Default(0) int visitCount,
    
    /// 最后访问时间
    DateTime? lastVisitedAt,
  }) = _Bookmark;

  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);
}

/// 历史记录数据模型
@freezed
class History with _$History {
  const factory History({
    /// 唯一标识
    required String id,
    
    /// 站点标题
    required String title,
    
    /// 链接地址
    required String url,
    
    /// 访问时间
    required DateTime visitedAt,
    
    /// 访问时长（秒）
    @Default(0) int duration,
    
    /// 图标URL
    String? favicon,
    
    /// 访问来源
    String? referrer,
    
    /// 设备类型
    @Default('mobile') String deviceType,
  }) = _History;

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);
}

/// 浏览器设置数据模型
@freezed
class BrowserSettings with _$BrowserSettings {
  const factory BrowserSettings({
    /// 用户代理
    String? userAgent,
    
    /// JavaScript开关
    @Default(true) bool javascriptEnabled,
    
    /// DOM存储开关
    @Default(true) bool domStorageEnabled,
    
    /// 缓存模式
    @Default('default') String cacheMode,
    
    /// 无痕模式
    @Default(false) bool incognito,
    
    /// 字体大小
    @Default(16) int fontSize,
    
    /// 是否启用图片加载
    @Default(true) bool imagesEnabled,
    
    /// 是否启用弹出窗口拦截
    @Default(true) bool popupsEnabled,
    
    /// 默认搜索引擎
    @Default('https://www.google.com/search?q=') String searchEngine,
    
    /// 首页URL
    @Default('https://www.google.com') String homepage,
    
    /// 下载目录
    String? downloadDirectory,
    
    /// 是否启用下载通知
    @Default(true) bool downloadNotifications,
    
    /// 是否启用隐私模式
    @Default(false) bool privacyMode,
    
    /// 是否自动清除数据
    @Default(false) bool autoClearData,
    
    /// 数据清除间隔（小时）
    @Default(24) int clearDataInterval,
  }) = _BrowserSettings;

  factory BrowserSettings.fromJson(Map<String, dynamic> json) =>
      _$BrowserSettingsFromJson(json);
}

/// 浏览器状态枚举
enum BrowserState {
  /// 空闲状态
  idle,
  
  /// 加载中
  loading,
  
  /// 加载完成
  loaded,
  
  /// 错误状态
  error,
  
  /// 离线状态
  offline,
}

/// 浏览器事件类型
enum BrowserEventType {
  /// 页面开始加载
  loadStart,
  
  /// 页面加载完成
  loadStop,
  
  /// 页面加载错误
  loadError,
  
  /// 页面标题改变
  titleChanged,
  
  /// URL改变
  urlChanged,
  
  /// 进度改变
  progressChanged,
  
  /// 控制台消息
  consoleMessage,
  
  /// 新窗口请求
  createWindow,
}

/// 浏览器事件数据
@freezed
class BrowserEvent with _$BrowserEvent {
  const factory BrowserEvent({
    /// 事件类型
    required BrowserEventType type,
    
    /// 关联的标签页ID
    required String tabId,
    
    /// 事件数据
    Map<String, dynamic>? data,
    
    /// 事件时间戳
    required DateTime timestamp,
  }) = _BrowserEvent;

  factory BrowserEvent.fromJson(Map<String, dynamic> json) =>
      _$BrowserEventFromJson(json);
}

/// 搜索结果数据模型
@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    /// 标题
    required String title,
    
    /// 描述
    String? description,
    
    /// URL
    required String url,
    
    /// 图标URL
    String? favicon,
    
    /// 匹配度分数
    @Default(0.0) double score,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}

/// 下载任务数据模型
@freezed
class DownloadTask with _$DownloadTask {
  const factory DownloadTask({
    /// 任务ID
    required String id,
    
    /// 文件名
    required String fileName,
    
    /// 下载URL
    required String url,
    
    /// 保存路径
    required String savePath,
    
    /// 文件大小（字节）
    @Default(0) int totalBytes,
    
    /// 已下载大小（字节）
    @Default(0) int downloadedBytes,
    
    /// 下载进度（0.0-1.0）
    @Default(0.0) double progress,
    
    /// 下载速度（字节/秒）
    @Default(0) int speed,
    
    /// 状态
    @Default('pending') String status,
    
    /// 创建时间
    required DateTime createdAt,
    
    /// 完成时间
    DateTime? completedAt,
    
    /// 错误信息
    String? error,
  }) = _DownloadTask;

  factory DownloadTask.fromJson(Map<String, dynamic> json) =>
      _$DownloadTaskFromJson(json);
}

/// 浏览器统计信息
@freezed
class BrowserStats with _$BrowserStats {
  const factory BrowserStats({
    /// 总访问页面数
    @Default(0) int totalPagesVisited,
    
    /// 总访问时长（秒）
    @Default(0) int totalVisitDuration,
    
    /// 数据使用量（字节）
    @Default(0) int dataUsage,
    
    /// 书签数量
    @Default(0) int bookmarkCount,
    
    /// 历史记录数量
    @Default(0) int historyCount,
    
    /// 下载任务数量
    @Default(0) int downloadCount,
    
    /// 最后访问时间
    DateTime? lastVisitedAt,
  }) = _BrowserStats;

  factory BrowserStats.fromJson(Map<String, dynamic> json) =>
      _$BrowserStatsFromJson(json);
}