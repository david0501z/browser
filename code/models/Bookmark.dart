/// 浏览器书签数据模型
/// 
/// 该模型定义了浏览器书签的信息结构，包括标题、URL、标签、图标等属性。
/// 使用freezed实现不可变数据类，支持JSON序列化。
library bookmark;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/bookmark.freezed.dart';
part 'generated/bookmark.g.dart';

/// 浏览器书签模型
/// 
/// 表示一个浏览器书签，包含标题、URL、图标、标签等信息。
/// 支持分类管理和搜索功能。
@freezed
abstract class Bookmark with _$Bookmark {
  const factory Bookmark({
    /// 书签唯一标识符
    required String id,
    
    /// 书签标题
    required String title,
    
    /// 书签URL
    required String url,
    
    /// 书签图标URL或Base64编码
    String? favicon,
    
    /// 书签描述
    String? description,
    
    /// 标签列表
    @Default([]) List<String> tags,
    
    /// 所属文件夹
    @Default('default') String folder,
    
    /// 创建时间
    required DateTime createdAt,
    
    /// 最后访问时间
    DateTime? lastVisitedAt,
    
    /// 更新时间
    required DateTime updatedAt,
    
    /// 访问次数
    @Default(0) int visitCount,
    
    /// 是否为收藏夹（星标）
    @Default(false) bool isFavorite,
    
    /// 是否在工具栏显示
    @Default(false) bool showInToolbar,
    
    /// 排序权重（用于自定义排序）
    @Default(0) int sortOrder,
    
    /// 自定义图标颜色（十六进制颜色值）
    int? iconColor,
    
    /// 书签备注
    String? note,
    
    /// 网站类型分类
    @Default(WebsiteType.general) WebsiteType websiteType,
    
    /// 安全状态
    @Default(BrowserSecurityStatus.unknown) BrowserSecurityStatus securityStatus,
    
    /// 缩略图Base64编码
    String? thumbnail,
  }) = _Bookmark;
  
  /// 从JSON创建Bookmark实例
  factory Bookmark.fromJson(Map<String, Object?> json) =>
      _$BookmarkFromJson(json);
}

/// 网站类型枚举
/// 
/// 用于对书签进行分类管理。
enum WebsiteType {
  /// 通用类型
  general,
  
  /// 搜索引擎
  searchEngine,
  
  /// 社交媒体
  socialMedia,
  
  /// 新闻资讯
  news,
  
  /// 娱乐视频
  entertainment,
  
  /// 购物网站
  shopping,
  
  /// 工作工具
  productivity,
  
  /// 技术开发
  development,
  
  /// 教育学习
  education,
  
  /// 金融服务
  finance,
  
  /// 游戏娱乐
  gaming,
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

/// Bookmark扩展方法
/// 
/// 为Bookmark模型提供额外的功能方法。
extension BookmarkExt on Bookmark {
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
  
  /// 获取网站类型显示名称
  String get websiteTypeDisplayName {
    switch (websiteType) {
      case WebsiteType.general:
        return '通用';
      case WebsiteType.searchEngine:
        return '搜索引擎';
      case WebsiteType.socialMedia:
        return '社交媒体';
      case WebsiteType.news:
        return '新闻资讯';
      case WebsiteType.entertainment:
        return '娱乐视频';
      case WebsiteType.shopping:
        return '购物网站';
      case WebsiteType.productivity:
        return '工作工具';
      case WebsiteType.development:
        return '技术开发';
      case WebsiteType.education:
        return '教育学习';
      case WebsiteType.finance:
        return '金融服务';
      case WebsiteType.gaming:
        return '游戏娱乐';
    }
  }
  
  /// 检查是否包含指定标签
  bool hasTag(String tag) {
    return tags.contains(tag.toLowerCase());
  }
  
  /// 检查是否包含搜索关键词
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    final lowerQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowerQuery) ||
           url.toLowerCase().contains(lowerQuery) ||
           description?.toLowerCase().contains(lowerQuery) == true ||
           tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
           folder.toLowerCase().contains(lowerQuery);
  }
  
  /// 获取排序键值
  String get sortKey {
    if (isFavorite) return '0_${title.toLowerCase()}';
    if (showInToolbar) return '1_${title.toLowerCase()}';
    return '2_${title.toLowerCase()}';
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

/// Bookmark工具方法
/// 
/// 提供Bookmark相关的工具函数。
class BookmarkUtils {
  /// 生成唯一书签ID
  static String generateBookmarkId() {
    return 'bm_${DateTime.now().millisecondsSinceEpoch}_${_randomString(8)}';
  }
  
  /// 创建新的书签
  static Bookmark create({
    required String title,
    required String url,
    String? description,
    List<String>? tags,
    String folder = 'default',
    bool isFavorite = false,
    WebsiteType websiteType = WebsiteType.general,
  }) {
    final now = DateTime.now();
    return Bookmark(
      id: generateBookmarkId(),
      title: title,
      url: url,
      description: description,
      tags: tags ?? [],
      folder: folder,
      createdAt: now,
      updatedAt: now,
      isFavorite: isFavorite,
      websiteType: websiteType,
    );
  }
  
  /// 从URL自动创建书签
  static Bookmark createFromUrl({
    required String url,
    String? title,
    String folder = 'default',
  }) {
    final now = DateTime.now();
    final detectedTitle = title ?? _extractTitleFromUrl(url);
    final detectedType = _detectWebsiteType(url);
    
    return Bookmark(
      id: generateBookmarkId(),
      title: detectedTitle,
      url: url,
      folder: folder,
      createdAt: now,
      updatedAt: now,
      websiteType: detectedType,
    );
  }
  
  /// 从URL自动检测网站类型
  static WebsiteType _detectWebsiteType(String url) {
    try {
      final uri = Uri.parse(url);
      final domain = uri.host.toLowerCase();
      
      // 搜索引擎
      if (domain.contains('google.') || 
          domain.contains('bing.') || 
          domain.contains('baidu.') ||
          domain.contains('duckduckgo.') ||
          domain.contains('yahoo.') ||
          domain.contains('sogou.')) {
        return WebsiteType.searchEngine;
      }
      
      // 社交媒体
      if (domain.contains('facebook.') ||
          domain.contains('twitter.') ||
          domain.contains('instagram.') ||
          domain.contains('linkedin.') ||
          domain.contains('youtube.') ||
          domain.contains('tiktok.') ||
          domain.contains('weibo.') ||
          domain.contains('qq.') ||
          domain.contains('weixin.')) {
        return WebsiteType.socialMedia;
      }
      
      // 购物网站
      if (domain.contains('amazon.') ||
          domain.contains('taobao.') ||
          domain.contains('jd.') ||
          domain.contains('tmall.') ||
          domain.contains('ebay.')) {
        return WebsiteType.shopping;
      }
      
      // 技术开发
      if (domain.contains('github.') ||
          domain.contains('stackoverflow.') ||
          domain.contains('gitlab.') ||
          domain.contains('npm.') ||
          domain.contains('pypi.')) {
        return WebsiteType.development;
      }
      
      // 默认返回通用类型
      return WebsiteType.general;
    } catch (_) {
      return WebsiteType.general;
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