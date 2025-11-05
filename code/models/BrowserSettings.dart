/// 浏览器设置数据模型
/// 
/// 该模型定义了浏览器功能的各种配置选项，包括用户代理、JavaScript支持、缓存设置等。
/// 使用freezed实现不可变数据类，支持JSON序列化。
library browser_settings;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/browser_settings.freezed.dart';
part 'generated/browser_settings.g.dart';

/// 浏览器设置模型
/// 
/// 包含浏览器的各种配置选项，支持个性化定制和功能控制。
@freezed
abstract class BrowserSettings with _$BrowserSettings {
  const factory BrowserSettings({
    /// 用户代理字符串
    String? userAgent,
    
    /// 是否启用JavaScript
    @Default(true) bool javascriptEnabled,
    
    /// 是否启用DOM存储
    @Default(true) bool domStorageEnabled,
    
    /// 是否启用混合内容
    @Default(false) bool mixedContentEnabled,
    
    /// 缓存模式
    @Default(CacheMode.defaultCache) CacheMode cacheMode,
    
    /// 是否启用无痕模式
    @Default(false) bool incognito,
    
    /// 是否启用Cookie
    @Default(true) bool cookiesEnabled,
    
    /// 是否启用图片加载
    @Default(true) bool imagesEnabled,
    
    /// 是否启用CSS
    @Default(true) bool cssEnabled,
    
    /// 是否启用插件
    @Default(false) bool pluginsEnabled,
    
    /// 是否启用自动播放媒体
    @Default(false) bool mediaAutoplayEnabled,
    
    /// 是否启用地理位置
    @Default(false) bool geolocationEnabled,
    
    /// 是否启用摄像头
    @Default(false) bool cameraEnabled,
    
    /// 是否启用麦克风
    @Default(false) bool microphoneEnabled,
    
    /// 是否启用通知
    @Default(false) bool notificationsEnabled,
    
    /// 是否启用WebRTC
    @Default(true) bool webrtcEnabled,
    
    /// 是否启用文件访问
    @Default(false) bool fileAccessEnabled,
    
    /// 是否启用下载管理
    @Default(true) bool downloadManagerEnabled,
    
    /// 默认下载路径
    String? defaultDownloadPath,
    
    /// 页面编码
    @Default('UTF-8') String defaultEncoding,
    
    /// 字体大小
    @Default(FontSize.medium) FontSize fontSize,
    
    /// 缩放级别 (0.5 - 3.0)
    @Default(1.0) double zoomLevel,
    
    /// 是否启用夜间模式
    @Default(false) bool darkMode,
    
    /// 是否启用阅读模式
    @Default(false) bool readerMode,
    
    /// 是否启用广告拦截
    @Default(false) bool adBlockEnabled,
    
    /// 是否启用跟踪保护
    @Default(false) bool trackingProtectionEnabled,
    
    /// 是否启用弹出窗口拦截
    @Default(true) bool popupBlockerEnabled,
    
    /// 是否启用自动填充
    @Default(false) bool autofillEnabled,
    
    /// 是否启用密码保存
    @Default(false) bool passwordSaveEnabled,
    
    /// 是否启用表单自动填充
    @Default(false) bool formAutofillEnabled,
    
    /// 隐私模式设置
    @Default(PrivacyMode.standard) PrivacyMode privacyMode,
    
    /// 搜索引擎设置
    @Default(SearchEngine.google) SearchEngine defaultSearchEngine,
    
    /// 主页URL
    @Default('about:blank') String homepage,
    
    /// 新标签页设置
    @Default(NewTabPage.homepage) NewTabPage newTabPage,
    
    /// 是否启用快捷键
    @Default(true) bool keyboardShortcutsEnabled,
    
    /// 是否启用鼠标手势
    @Default(false) bool mouseGesturesEnabled,
    
    /// 是否启用开发者工具
    @Default(false) bool developerToolsEnabled,
    
    /// 是否启用控制台日志
    @Default(false) bool consoleLoggingEnabled,
    
    /// 网络超时时间（毫秒）
    @Default(30000) int networkTimeout,
    
    /// 页面加载超时时间（毫秒）
    @Default(60000) int pageLoadTimeout,
    
    /// 最大并发连接数
    @Default(10) int maxConcurrentConnections,
    
    /// 缓存大小限制（MB）
    @Default(100) int cacheSizeLimit,
    
    /// 是否启用数据压缩
    @Default(false) bool dataCompressionEnabled,
    
    /// 是否启用离线模式
    @Default(false) bool offlineModeEnabled,
    
    /// 字体族设置
    @Default(FontFamily.system) FontFamily fontFamily,
    
    /// 是否启用硬件加速
    @Default(true) bool hardwareAccelerationEnabled,
    
    /// 是否启用多进程模式
    @Default(true) bool multiprocessEnabled,
    
    /// 安全设置
    @Default(BrowserSecurityLevel.medium) BrowserSecurityLevel securityLevel,
    
    /// SSL验证设置
    @Default(SslVerification.strict) SslVerification sslVerification,
    
    /// 证书固定设置
    @Default(CertificatePinning.disabled) CertificatePinning certificatePinning,
    
    /// 内容过滤设置
    @Default(ContentFilterMode.none) ContentFilterMode contentFilterMode,
    
    /// 代理设置
    ProxySettings? proxySettings,
    
    /// 用户自定义CSS
    String? customCSS,
    
    /// 用户自定义JavaScript
    String? customJavaScript,
    
    /// 扩展程序设置
    @Default([]) List<ExtensionSettings> extensionSettings,
    
    /// 同步设置
    SyncSettings? syncSettings,
    
    /// 高级设置
    AdvancedSettings? advancedSettings,
  }) = _BrowserSettings;
  
  /// 从JSON创建BrowserSettings实例
  factory BrowserSettings.fromJson(Map<String, Object?> json) =>
      _$BrowserSettingsFromJson(json);
}

/// 缓存模式枚举
enum CacheMode {
  /// 默认缓存
  defaultCache,
  
  /// 忽略缓存
  noCache,
  
  /// 离线优先
  cacheFirst,
  
  /// 网络优先
  networkFirst,
}

/// 字体大小枚举
enum FontSize {
  /// 小号
  small,
  
  /// 中号
  medium,
  
  /// 大号
  large,
  
  /// 超大号
  extraLarge,
}

/// 隐私模式枚举
enum PrivacyMode {
  /// 标准模式
  standard,
  
  /// 增强隐私模式
  enhanced,
  
  /// 严格隐私模式
  strict,
}

/// 搜索引擎枚举
enum SearchEngine {
  /// Google
  google,
  
  /// 百度
  baidu,
  
  /// Bing
  bing,
  
  /// DuckDuckGo
  duckduckgo,
  
  /// Yahoo
  yahoo,
  
  /// 搜狗
  sogou,
}

/// 新标签页设置枚举
enum NewTabPage {
  /// 主页
  homepage,
  
  /// 空白页
  blank,
  
  /// 书签页
  bookmarks,
  
  /// 历史记录页
  history,
  
  /// 快速拨号页
  speedDial,
}

/// 字体族枚举
enum FontFamily {
  /// 系统默认字体
  system,
  
  /// 衬线字体
  serif,
  
  /// 无衬线字体
  sansSerif,
  
  /// 等宽字体
  monospace,
}

/// 浏览器安全级别枚举
enum BrowserSecurityLevel {
  /// 低级别
  low,
  
  /// 中级别
  medium,
  
  /// 高级别
  high,
}

/// SSL验证枚举
enum SslVerification {
  /// 严格验证
  strict,
  
  /// 宽松验证
  relaxed,
  
  /// 禁用验证
  disabled,
}

/// 证书固定枚举
enum CertificatePinning {
  /// 禁用
  disabled,
  
  /// 启用
  enabled,
  
  /// 仅HTTPS
  httpsOnly,
}

/// 内容过滤模式枚举
enum ContentFilterMode {
  /// 无过滤
  none,
  
  /// 基础过滤
  basic,
  
  /// 严格过滤
  strict,
}

/// 代理设置模型
@freezed
abstract class ProxySettings with _$ProxySettings {
  const factory ProxySettings({
    /// 是否启用代理
    @Default(false) bool enabled,
    
    /// 代理类型
    @Default(ProxyType.direct) ProxyType type,
    
    /// 代理主机
    String? host,
    
    /// 代理端口
    int? port,
    
    /// 用户名
    String? username,
    
    /// 密码
    String? password,
    
    /// 排除的域名列表
    @Default([]) List<String> bypassList,
  }) = _ProxySettings;
  
  factory ProxySettings.fromJson(Map<String, Object?> json) =>
      _$ProxySettingsFromJson(json);
}

/// 代理类型枚举
enum ProxyType {
  /// 直连
  direct,
  
  /// HTTP代理
  http,
  
  /// HTTPS代理
  https,
  
  /// SOCKS代理
  socks,
  
  /// SOCKS5代理
  socks5,
}

/// 扩展程序设置模型
@freezed
abstract class ExtensionSettings with _$ExtensionSettings {
  const factory ExtensionSettings({
    /// 扩展程序ID
    required String id,
    
    /// 扩展程序名称
    required String name,
    
    /// 是否启用
    @Default(true) bool enabled,
    
    /// 扩展程序配置
    Map<String, dynamic>? config,
  }) = _ExtensionSettings;
  
  factory ExtensionSettings.fromJson(Map<String, Object?> json) =>
      _$ExtensionSettingsFromJson(json);
}

/// 同步设置模型
@freezed
abstract class SyncSettings with _$SyncSettings {
  const factory SyncSettings({
    /// 是否启用同步
    @Default(false) bool enabled,
    
    /// 同步服务器URL
    String? serverUrl,
    
    /// 同步间隔（分钟）
    @Default(60) int syncInterval,
    
    /// 同步数据类型
    @Default([]) List<SyncDataType> dataTypes,
  }) = _SyncSettings;
  
  factory SyncSettings.fromJson(Map<String, Object?> json) =>
      _$SyncSettingsFromJson(json);
}

/// 同步数据类型枚举
enum SyncDataType {
  /// 书签
  bookmarks,
  
  /// 历史记录
  history,
  
  /// 密码
  passwords,
  
  /// 表单数据
  formData,
  
  /// 设置
  settings,
}

/// 高级设置模型
@freezed
abstract class AdvancedSettings with _$AdvancedSettings {
  const factory AdvancedSettings({
    /// 是否启用调试模式
    @Default(false) bool debugMode,
    
    /// 是否启用性能监控
    @Default(false) bool performanceMonitoring,
    
    /// 是否启用网络日志
    @Default(false) bool networkLogging,
    
    /// 是否启用内存监控
    @Default(false) bool memoryMonitoring,
    
    /// WebView版本
    String? webViewVersion,
    
    /// 自定义WebView参数
    Map<String, dynamic>? customWebViewParams,
  }) = _AdvancedSettings;
  
  factory AdvancedSettings.fromJson(Map<String, Object?> json) =>
      _$AdvancedSettingsFromJson(json);
}

/// BrowserSettings扩展方法
/// 
/// 为BrowserSettings模型提供额外的功能方法。
extension BrowserSettingsExt on BrowserSettings {
  /// 获取用户代理显示文本
  String get userAgentDisplayText {
    if (userAgent == null || userAgent!.isEmpty) {
      return '默认';
    }
    
    // 截取用户代理字符串前50个字符
    final ua = userAgent!;
    return ua.length > 50 ? '${ua.substring(0, 50)}...' : ua;
  }
  
  /// 获取缓存模式显示文本
  String get cacheModeDisplayText {
    switch (cacheMode) {
      case CacheMode.defaultCache:
        return '默认缓存';
      case CacheMode.noCache:
        return '忽略缓存';
      case CacheMode.cacheFirst:
        return '离线优先';
      case CacheMode.networkFirst:
        return '网络优先';
    }
  }
  
  /// 获取隐私模式显示文本
  String get privacyModeDisplayText {
    switch (privacyMode) {
      case PrivacyMode.standard:
        return '标准';
      case PrivacyMode.enhanced:
        return '增强';
      case PrivacyMode.strict:
        return '严格';
    }
  }
  
  /// 获取搜索引擎显示文本
  String get searchEngineDisplayText {
    switch (defaultSearchEngine) {
      case SearchEngine.google:
        return 'Google';
      case SearchEngine.baidu:
        return '百度';
      case SearchEngine.bing:
        return 'Bing';
      case SearchEngine.duckduckgo:
        return 'DuckDuckGo';
      case SearchEngine.yahoo:
        return 'Yahoo';
      case SearchEngine.sogou:
        return '搜狗';
    }
  }
  
  /// 获取字体大小显示文本
  String get fontSizeDisplayText {
    switch (fontSize) {
      case FontSize.small:
        return '小';
      case FontSize.medium:
        return '中';
      case FontSize.large:
        return '大';
      case FontSize.extraLarge:
        return '超大';
    }
  }
  
  /// 获取安全级别显示文本
  String get securityLevelDisplayText {
    switch (securityLevel) {
      case BrowserSecurityLevel.low:
        return '低';
      case BrowserSecurityLevel.medium:
        return '中';
      case BrowserSecurityLevel.high:
        return '高';
    }
  }
  
  /// 检查是否为高性能模式
  bool get isHighPerformance {
    return hardwareAccelerationEnabled && 
           multiprocessEnabled && 
           cacheMode == CacheMode.cacheFirst;
  }
  
  /// 检查是否为隐私优先模式
  bool get isPrivacyFirst {
    return privacyMode == PrivacyMode.strict || 
           privacyMode == PrivacyMode.enhanced ||
           trackingProtectionEnabled ||
           adBlockEnabled;
  }
  
  /// 检查是否启用了所有安全功能
  bool get isSecureMode {
    return sslVerification == SslVerification.strict &&
           certificatePinning != CertificatePinning.disabled &&
           contentFilterMode != ContentFilterMode.none;
  }
  
  /// 获取推荐的用户代理
  String get recommendedUserAgent {
    switch (defaultSearchEngine) {
      case SearchEngine.google:
        return 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
      case SearchEngine.baidu:
        return 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
      case SearchEngine.bing:
        return 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
      default:
        return 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
    }
  }
}

/// BrowserSettings工具方法
/// 
/// 提供BrowserSettings相关的工具函数。
class BrowserSettingsUtils {
  /// 创建默认浏览器设置
  static BrowserSettings createDefault() {
    return const BrowserSettings();
  }
  
  /// 创建隐私模式设置
  static BrowserSettings createPrivacyMode() {
    return const BrowserSettings(
      privacyMode: PrivacyMode.strict,
      trackingProtectionEnabled: true,
      adBlockEnabled: true,
      cookiesEnabled: false,
      domStorageEnabled: false,
      geolocationEnabled: false,
      cameraEnabled: false,
      microphoneEnabled: false,
      notificationsEnabled: false,
      autofillEnabled: false,
      passwordSaveEnabled: false,
      formAutofillEnabled: false,
    );
  }
  
  /// 创建开发者模式设置
  static BrowserSettings createDeveloperMode() {
    return const BrowserSettings(
      developerToolsEnabled: true,
      consoleLoggingEnabled: true,
      debugMode: true,
      performanceMonitoring: true,
      networkLogging: true,
      memoryMonitoring: true,
      javascriptEnabled: true,
      pluginsEnabled: true,
      fileAccessEnabled: true,
    );
  }
  
  /// 创建移动设备模拟设置
  static BrowserSettings createMobileMode() {
    return const BrowserSettings(
      userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1',
      zoomLevel: 1.0,
      hardwareAccelerationEnabled: true,
    );
  }
  
  /// 验证设置配置
  static List<String> validateSettings(BrowserSettings settings) {
    final errors = <String>[];
    
    // 验证缩放级别
    if (settings.zoomLevel < 0.5 || settings.zoomLevel > 3.0) {
      errors.add('缩放级别必须在0.5到3.0之间');
    }
    
    // 验证超时时间
    if (settings.networkTimeout < 1000) {
      errors.add('网络超时时间不能少于1000毫秒');
    }
    
    if (settings.pageLoadTimeout < 5000) {
      errors.add('页面加载超时时间不能少于5000毫秒');
    }
    
    // 验证并发连接数
    if (settings.maxConcurrentConnections < 1 || settings.maxConcurrentConnections > 50) {
      errors.add('最大并发连接数必须在1到50之间');
    }
    
    // 验证缓存大小限制
    if (settings.cacheSizeLimit < 10 || settings.cacheSizeLimit > 1000) {
      errors.add('缓存大小限制必须在10MB到1000MB之间');
    }
    
    // 验证代理设置
    if (settings.proxySettings?.enabled == true) {
      final proxy = settings.proxySettings!;
      if (proxy.host == null || proxy.host!.isEmpty) {
        errors.add('启用代理时必须指定代理主机');
      }
      if (proxy.port == null || proxy.port! < 1 || proxy.port! > 65535) {
        errors.add('代理端口必须在1到65535之间');
      }
    }
    
    return errors;
  }
}