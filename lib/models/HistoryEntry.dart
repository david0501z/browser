/// 浏览器历史记录数据模型
/// 
/// 该模型定义了浏览器访问历史记录的信息结构，包括访问时间、停留时长、页面信息等。
/// 使用freezed实现不可变数据类，支持JSON序列化。
library history_entry;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/HistoryEntry.freezed.dart';
part 'generated/HistoryEntry.g.dart';

/// 浏览器历史记录模型
/// 
/// 表示一次浏览器访问记录，包含页面信息、访问时间、停留时长等数据。
@freezed
abstract class HistoryEntry with _$HistoryEntry {
  const factory HistoryEntry({
    /// 历史记录唯一标识符
    required String id,
    
    /// 页面标题
    required String title,
    
    /// 页面URL
    required String url,
    
    /// 页面图标URL或Base64编码
    String? favicon,
    
    /// 访问时间
    required DateTime visitedAt,
    
    /// 访问结束时间（用于计算停留时长）
    DateTime? exitAt,
    
    /// 停留时长（秒）
    @Default(0) int duration,
    
    /// 访问来源页面URL
    String? referrer,
    
    /// 设备类型
    @Default(DeviceType.unknown) DeviceType deviceType,
    
    /// 浏览器用户代理
    String? userAgent,
    
    /// 页面加载状态
    @Default(PageLoadStatus.success) PageLoadStatus loadStatus,
    
    /// 页面加载耗时（毫秒）
    int? loadTime,
    
    /// 数据传输量（字节）
    @Default(0) int dataTransferred,
    
    /// 安全状态
    @Default(BrowserSecurityStatus.unknown) BrowserSecurityStatus securityStatus,
    
    /// HTTP状态码
    int? httpStatusCode,
    
    /// 错误信息（如果有）
    String? errorMessage,
    
    /// 页面类型
    @Default(PageType.webpage) PageType pageType,
    
    /// 搜索关键词（如果是从搜索引擎访问）
    String? searchQuery,
    
    /// 是否为新标签页访问
    @Default(false) bool isNewTab,
    
    /// 是否为书签访问
    @Default(false) bool isFromBookmark,
    
    /// 缩略图Base64编码
    String? thumbnail,
    
    /// 页面语言
    String? pageLanguage,
    
    /// 地理位置信息
    String? geoLocation,
  }) = _HistoryEntry;
  
  /// 从JSON创建HistoryEntry实例
  factory HistoryEntry.fromJson(Map<String, Object?> json) =>
      _$HistoryEntryFromJson(json);
}

/// 设备类型枚举
/// 
/// 用于标识访问设备类型。
enum DeviceType {
  /// 未知设备
  unknown,
  
  /// 桌面设备
  desktop,
  
  /// 移动设备
  mobile,
  
  /// 平板设备
  tablet,
}

/// 页面加载状态枚举
/// 
/// 表示页面加载的结果状态。
enum PageLoadStatus {
  /// 加载成功
  success,
  
  /// 加载失败
  failed,
  
  /// 加载超时
  timeout,
  
  /// 用户取消
  cancelled,
  
  /// 网络错误
  networkError,
}

/// 页面类型枚举
/// 
/// 用于分类不同类型的页面。
enum PageType {
  /// 普通网页
  webpage,
  
  /// 搜索引擎结果页
  searchResults,
  
  /// 图片页面
  image,
  
  /// 视频页面
  video,
  
  /// 文档页面
  document,
  
  /// 邮件页面
  email,
  
  /// 社交媒体页面
  socialMedia,
  
  /// 购物页面
  shopping,
  
  /// 新闻页面
  news,
  
  /// 博客页面
  blog,
}

/// 浏览器安全状态枚举
enum BrowserSecurityStatus {
  /// 未知状态
  unknown,
  
  /// 安全连接 (HTTPS)
  secure,
  
  /// 不安全连接 (HTTP)
  insecure,
  
  /// 混合内容警告
  mixedContent,
  
  /// SSL证书错误
  certificateError,
}

/// HistoryEntry扩展方法
/// 
/// 为HistoryEntry模型提供额外的功能方法。
extension HistoryEntryExt on HistoryEntry {
  /// 获取显示标题
  String get displayTitle {
    return title.isNotEmpty ? title : _extractTitleFromUrl(url);
  }
  
  /// 获取域名
  String get domain {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (_) {
      return '';
    }
  }
  
  /// 检查是否为有效URL
  bool get isValidUrl {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (_) {
      return false;
    }
  }
  
  /// 获取停留时长显示文本
  String get durationText {
    if (duration <= 0) return '未知';
    
    if (duration < 60) {
      return '${duration}秒';
    } else if (duration < 3600) {
      final minutes = duration ~/ 60;
      final seconds = duration % 60;
      return '${minutes}分${seconds > 0 ? '${seconds}秒' : ''}';
    } else {
      final hours = duration ~/ 3600;
      final minutes = (duration % 3600) ~/ 60;
      return '${hours}小时${minutes > 0 ? '${minutes}分' : ''}';
    }
  }
  
  /// 获取加载时间显示文本
  String get loadTimeText {
    if (loadTime == null) return '未知';
    
    if (loadTime! < 1000) {
      return '${loadTime}ms';
    } else {
      final seconds = (loadTime! / 1000).toStringAsFixed(1);
      return '${seconds}s';
    }
  }
  
  /// 获取数据传输量显示文本
  String get dataTransferredText {
    if (dataTransferred <= 0) return '0 B';
    
    const units = ['B', 'KB', 'MB', 'GB'];
    int unitIndex = 0;
    double size = dataTransferred.toDouble();
    
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    
    return '${size.toStringAsFixed(unitIndex == 0 ? 0 : 1)} ${units[unitIndex]}';
  }
  
  /// 获取访问时间显示文本
  String get visitedAtText {
    final now = DateTime.now();
    final diff = now.difference(visitedAt);
    
    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${visitedAt.year}-${visitedAt.month.toString().padLeft(2, '0')}-${visitedAt.day.toString().padLeft(2, '0')}';
    }
  }
  
  /// 获取加载状态显示文本
  String get loadStatusText {
    switch (loadStatus) {
      case PageLoadStatus.success:
        return '成功';
      case PageLoadStatus.failed:
        return '失败';
      case PageLoadStatus.timeout:
        return '超时';
      case PageLoadStatus.cancelled:
        return '已取消';
      case PageLoadStatus.networkError:
        return '网络错误';
    }
  }
  
  /// 获取页面类型显示名称
  String get pageTypeDisplayName {
    switch (pageType) {
      case PageType.webpage:
        return '网页';
      case PageType.searchResults:
        return '搜索结果';
      case PageType.image:
        return '图片';
      case PageType.video:
        return '视频';
      case PageType.document:
        return '文档';
      case PageType.email:
        return '邮件';
      case PageType.socialMedia:
        return '社交媒体';
      case PageType.shopping:
        return '购物';
      case PageType.news:
        return '新闻';
      case PageType.blog:
        return '博客';
    }
  }
  
  /// 获取设备类型显示名称
  String get deviceTypeDisplayName {
    switch (deviceType) {
      case DeviceType.unknown:
        return '未知';
      case DeviceType.desktop:
        return '桌面';
      case DeviceType.mobile:
        return '手机';
      case DeviceType.tablet:
        return '平板';
    }
  }
  
  /// 获取安全状态显示文本
  String get securityStatusText {
    switch (securityStatus) {
      case BrowserSecurityStatus.secure:
        return '安全';
      case BrowserSecurityStatus.insecure:
        return '不安全';
      case BrowserSecurityStatus.mixedContent:
        return '混合内容';
      case BrowserSecurityStatus.certificateError:
        return '证书错误';
      case BrowserSecurityStatus.unknown:
        return '未知';
    }
  }
  
  /// 检查是否包含搜索关键词
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    final lowerQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowerQuery) ||
           url.toLowerCase().contains(lowerQuery) ||
           searchQuery?.toLowerCase().contains(lowerQuery) == true ||
           referrer?.toLowerCase().contains(lowerQuery) == true;
  }
  
  /// 检查是否为搜索引擎访问
  bool get isFromSearchEngine {
    if (referrer == null) return false;
    
    const searchEngines = [
      'google.com',
      'bing.com',
      'baidu.com',
      'duckduckgo.com',
      'yahoo.com',
      'sogou.com',
    ];
    
    return searchEngines.any((engine) => referrer!.contains(engine));
  }
  
  /// 从URL提取默认标题
  String _extractTitleFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host;
      if (host.isEmpty) return url;
      
      // 移除www前缀
      final cleanHost = host.replaceFirst('www.', '');
      return cleanHost;
    } catch (_) {
      return url;
    }
  }
}

/// HistoryEntry工具方法
/// 
/// 提供HistoryEntry相关的工具函数。
class HistoryEntryUtils {
  /// 生成唯一历史记录ID
  static String generateHistoryId() {
    return 'hist_${DateTime.now().millisecondsSinceEpoch}_${_randomString(8)}';
  }
  
  /// 创建新的历史记录
  static HistoryEntry create({
    required String title,
    required String url,
    required DateTime visitedAt,
    String? favicon,
    String? referrer,
    DeviceType deviceType = DeviceType.unknown,
    PageLoadStatus loadStatus = PageLoadStatus.success,
    int? loadTime,
    int dataTransferred = 0,
    PageType pageType = PageType.webpage,
    String? searchQuery,
    bool isNewTab = false,
    bool isFromBookmark = false,
    String? userAgent,
  }) {
    return HistoryEntry(
      id: generateHistoryId(),
      title: title,
      url: url,
      favicon: favicon,
      visitedAt: visitedAt,
      referrer: referrer,
      deviceType: deviceType,
      loadStatus: loadStatus,
      loadTime: loadTime,
      dataTransferred: dataTransferred,
      pageType: pageType,
      searchQuery: searchQuery,
      isNewTab: isNewTab,
      isFromBookmark: isFromBookmark,
      userAgent: userAgent,
    );
  }
  
  /// 从URL创建历史记录
  static HistoryEntry createFromUrl({
    required String url,
    String? title,
    DateTime? visitedAt,
    String? referrer,
  }) {
    final now = visitedAt ?? DateTime.now();
    final detectedTitle = title ?? _extractTitleFromUrl(url);
    final detectedType = _detectPageType(url);
    
    return HistoryEntry(
      id: generateHistoryId(),
      title: detectedTitle,
      url: url,
      visitedAt: now,
      referrer: referrer,
      pageType: detectedType,
    );
  }
  
  /// 从URL检测页面类型
  static PageType _detectPageType(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path.toLowerCase();
      
      // 图片页面
      if (path.endsWith('.jpg') || path.endsWith('.jpeg') || 
          path.endsWith('.png') || path.endsWith('.gif') || 
          path.endsWith('.webp') || path.endsWith('.bmp')) {
        return PageType.image;
      }
      
      // 视频页面
      if (path.endsWith('.mp4') || path.endsWith('.avi') || 
          path.endsWith('.mkv') || path.endsWith('.mov') ||
          path.contains('/video/') || path.contains('/watch/')) {
        return PageType.video;
      }
      
      // 文档页面
      if (path.endsWith('.pdf') || path.endsWith('.doc') || 
          path.endsWith('.docx') || path.endsWith('.txt')) {
        return PageType.document;
      }
      
      // 社交媒体
      if (uri.host.contains('facebook.') || uri.host.contains('twitter.') ||
          uri.host.contains('instagram.') || uri.host.contains('linkedin.')) {
        return PageType.socialMedia;
      }
      
      // 搜索引擎
      if (uri.host.contains('google.') || uri.host.contains('bing.') ||
          uri.host.contains('baidu.') || uri.host.contains('duckduckgo.')) {
        return PageType.searchResults;
      }
      
      // 默认返回网页类型
      return PageType.webpage;
    } catch (_) {
      return PageType.webpage;
    }
  }
  
  /// 从URL提取默认标题
  static String _extractTitleFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host;
      if (host.isEmpty) return url;
      
      // 移除www前缀
      final cleanHost = host.replaceFirst('www.', '');
      return cleanHost;
    } catch (_) {
      return url;
    }
  }
  
  /// 生成随机字符串
  static String _randomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch % chars.length;
    return List.generate(length, (index) => chars[(random + index) % chars.length]).join();
  }
}