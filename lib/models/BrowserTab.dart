/// 浏览器标签页数据模型
/// 
/// 该模型定义了浏览器标签页的核心状态信息，包括URL、标题、图标等属性。
/// 使用freezed实现不可变数据类，支持JSON序列化。
library browser_tab;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/BrowserTab.freezed.dart';
part 'generated/BrowserTab.g.dart';

/// 浏览器标签页模型
/// 
/// 表示一个浏览器标签页的状态信息，包括当前页面URL、标题、图标等。
/// 该模型是不可变的，通过copyWith方法进行状态更新。
@freezed
abstract class BrowserTab with _$BrowserTab {
  const factory BrowserTab({
    /// 标签页唯一标识符
    required String id,
    
    /// 当前页面URL
    required String url,
    
    /// 页面标题
    required String title,
    
    /// 页面图标URL或Base64编码
    String? favicon,
    
    /// 是否为固定标签页
    @Default(false) bool pinned,
    
    /// 是否为无痕模式标签页
    @Default(false) bool incognito,
    
    /// 是否正在加载中
    @Default(false) bool isLoading,
    
    /// 是否可前进
    @Default(false) bool canGoForward,
    
    /// 是否可后退
    @Default(false) bool canGoBack,
    
    /// 标签页创建时间
    required DateTime createdAt,
    
    /// 标签页最后更新时间
    required DateTime updatedAt,
    
    /// 访问次数统计
    @Default(0) int visitCount,
    
    /// 标签页缩略图Base64编码
    String? thumbnail,
    
    /// 页面加载进度 (0-100)
    @Default(0) int progress,
    
    /// 安全状态 (https/http)
    @Default(BrowserSecurityStatus.unknown) BrowserSecurityStatus securityStatus,
    
    /// 页面加载错误信息
    String? errorMessage,
    
    /// 自定义标签页标题（用户可编辑）
    String? customTitle,
    
    /// 标签页备注
    String? note,
  }) = _BrowserTab;
  
  /// 从JSON创建BrowserTab实例
  factory BrowserTab.fromJson(Map<String, Object?> json) =>
      _$BrowserTabFromJson(json);
}

/// 浏览器安全状态枚举
/// 
/// 表示当前页面的安全状态，用于在UI中显示相应的安全指示器。
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

/// BrowserTab扩展方法
/// 
/// 为BrowserTab模型提供额外的功能方法，增强其实用性。
extension BrowserTabExt on BrowserTab {
  /// 获取显示标题
  /// 
  /// 优先使用自定义标题，其次是页面标题，最后是域名
  String get displayTitle {
    if (customTitle != null && customTitle!.isNotEmpty) {
      return customTitle!;
    }
    if (title.isNotEmpty) {
      return title;
    }
    return _extractDomainFromUrl(url);
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
  
  /// 获取安全状态颜色值
  /// 
  /// 用于UI显示不同安全状态的指示颜色
  int get securityStatusColor {
    switch (securityStatus) {
      case BrowserSecurityStatus.secure:
        return 0xFF4CAF50; // 绿色
      case BrowserSecurityStatus.insecure:
        return 0xFFFF9800; // 橙色
      case BrowserSecurityStatus.mixedContent:
        return 0xFFFF5722; // 深橙色
      case BrowserSecurityStatus.certificateError:
        return 0xFFF44336; // 红色
      case BrowserSecurityStatus.unknown:
        return 0xFF9E9E9E; // 灰色
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
  
  /// 获取域名
  String get domain {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (_) {
      return '';
    }
  }
  
  /// 检查是否为搜索引擎URL
  bool get isSearchEngine {
    const searchEngines = [
      'google.com',
      'bing.com',
      'baidu.com',
      'duckduckgo.com',
      'yahoo.com',
      'sogou.com',
    ];
    return searchEngines.any((engine) => domain.contains(engine));
  }
  
  /// 检查是否为社交媒体URL
  bool get isSocialMedia {
    const socialMediaDomains = [
      'facebook.com',
      'twitter.com',
      'instagram.com',
      'linkedin.com',
      'youtube.com',
      'tiktok.com',
      'weibo.com',
      'qq.com',
      'weixin.qq.com',
    ];
    return socialMediaDomains.any((domain) => this.domain.contains(domain));
  }
  
  /// 提取URL中的域名
  String _extractDomainFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.isEmpty ? url : uri.host;
    } catch (_) {
      return url;
    }
  }
}

/// BrowserTab工具方法
/// 
/// 提供BrowserTab相关的工具函数。
class BrowserTabUtils {
  /// 生成唯一标签页ID
  static String generateTabId() {
    return 'tab_${DateTime.now().millisecondsSinceEpoch}_${_randomString(8)}';
  }
  
  /// 创建新的浏览器标签页
  static BrowserTab create({
    required String url,
    String? title,
    bool incognito = false,
    bool pinned = false,
  }) {
    final now = DateTime.now();
    return BrowserTab(
      id: generateTabId(),
      url: url,
      title: title ?? _extractTitleFromUrl(url),
      incognito: incognito,
      pinned: pinned,
      createdAt: now,
      updatedAt: now,
    );
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