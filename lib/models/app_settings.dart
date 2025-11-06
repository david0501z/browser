/// 统一的应用设置数据模型
/// 
/// 该模型整合了浏览器设置和FlClash代理设置，提供统一的配置管理。
/// 使用freezed实现不可变数据类，支持JSON序列化和版本控制。
library app_settings;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'browser_settings.dart';

part 'generated/app_settings.freezed.dart';
part 'generated/app_settings.g.dart';

/// 统一应用设置模型
/// 
/// 包含所有应用配置选项，支持分类管理和版本控制。
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    /// 设置版本号
    @Default('1.0.0') String version,
    
    /// 设置创建时间
    @Default(0) int createdAt,
    
    /// 设置最后更新时间
    @Default(0) int updatedAt,
    
    /// 设置模式
    @Default(SettingsMode.standard) SettingsMode mode,
    
    /// 浏览器设置
    @Default(BrowserSettings()) BrowserSettings browserSettings,
    
    /// FlClash代理设置
    @Default(FlClashSettings()) FlClashSettings flclashSettings,
    
    /// 界面设置
    @Default(UI()) UI ui,
    
    /// 通知设置
    @Default(Notifications()) Notifications notifications,
    
    /// 隐私设置
    @Default(Privacy()) Privacy privacy,
    
    /// 备份设置
    @Default(Backup()) Backup backup,
  }) = _AppSettings;
  
  /// 从JSON创建AppSettings实例
  factory AppSettings.fromJson(Map<String, Object?> json) =>
      _$AppSettingsFromJson(json);
}

/// 设置模式枚举
enum SettingsMode {
  /// 标准模式
  standard,
  
  /// 隐私模式
  privacy,
  
  /// 开发者模式
  developer,
  
  /// 高性能模式
  performance,
  
  /// 自定义模式
  custom,
}

/// FlClash代理设置模型
@freezed
abstract class FlClashSettings with _$FlClashSettings {
  const factory FlClashSettings({
    /// 是否启用FlClash
    @Default(false) bool enabled,
    
    /// 代理模式
    @Default(ProxyMode.rule) ProxyMode mode,
    
    /// 核心版本
    @Default('') String coreVersion,
    
    /// 配置文件路径
    String? configPath,
    
    /// 日志级别
    @Default(LogLevel.info) LogLevel logLevel,
    
    /// 是否启用自动更新
    @Default(true) bool autoUpdate,
    
    /// 是否启用IPv6
    @Default(false) bool ipv6,
    
    /// 是否启用TUN模式
    @Default(false) bool tunMode,
    
    /// 是否启用混合模式
    @Default(false) bool mixedMode,
    
    /// 是否启用系统代理
    @Default(false) bool systemProxy,
    
    /// 是否启用局域网共享
    @Default(false) bool lanShare,
    
    /// 是否启用DNS转发
    @Default(false) bool dnsForward,
    
    /// 端口设置
    @Default(PortSettings()) PortSettings ports,
    
    /// DNS设置
    @Default(DNSSettings()) DNSSettings dns,
    
    /// 规则设置
    @Default(RuleSettings()) RuleSettings rules,
    
    /// 节点设置
    @Default(NodeSettings()) NodeSettings nodes,
    
    /// 流量统计设置
    @Default(TrafficStatsSettings()) TrafficStatsSettings traffic,
  }) = _FlClashSettings;
  
  factory FlClashSettings.fromJson(Map<String, Object?> json) =>
      _$FlClashSettingsFromJson(json);
}



/// 日志级别枚举
/// 注意：LogLevel定义已迁移到 logging/log_level.dart
/// 请使用：import 'package:flclash_browser_app/logging/log_level.dart';

/// 端口设置模型
@freezed
abstract class PortSettings with _$PortSettings {
  const factory PortSettings({
    /// HTTP代理端口
    @Default(7890) int httpPort,
    
    /// SOCKS代理端口
    @Default(7891) int socksPort,
    
    /// 混合代理端口
    @Default(7892) int mixedPort,
    
    /// API控制端口
    @Default(9090) int apiPort,
  }) = _PortSettings;
  
  factory PortSettings.fromJson(Map<String, Object?> json) =>
      _$PortSettingsFromJson(json);
}

/// DNS设置模型
@freezed
abstract class DNSSettings with _$DNSSettings {
  const factory DNSSettings({
    /// 是否启用自定义DNS
    @Default(false) bool customDNS,
    
    /// DNS服务器列表
    @Default([]) List<String> dnsServers,
    
    /// 是否启用DNS over HTTPS
    @Default(false) bool dnsOverHttps,
    
    /// DNS over HTTPS服务器
    String? dohServer,
  }) = _DNSSettings;
  
  factory DNSSettings.fromJson(Map<String, Object?> json) =>
      _$DNSSettingsFromJson(json);
}

/// 规则设置模型
@freezed
abstract class RuleSettings with _$RuleSettings {
  const factory RuleSettings({
    /// 是否启用自定义规则
    @Default(false) bool customRules,
    
    /// 规则文件路径
    String? rulePath,
    
    /// 规则类型
    @Default(RuleType.auto) RuleType ruleType,
    
    /// 是否启用广告拦截
    @Default(true) bool adBlock,
    
    /// 是否启用跟踪拦截
    @Default(true) bool trackingBlock,
  }) = _RuleSettings;
  
  factory RuleSettings.fromJson(Map<String, Object?> json) =>
      _$RuleSettingsFromJson(json);
}

/// 规则类型枚举
enum RuleType {
  /// 自动
  auto,
  
  /// 自定义
  custom,
  
  /// 仅国内
  domestic,
  
  /// 全球
  global,
}

/// 节点设置模型
@freezed
abstract class NodeSettings with _$NodeSettings {
  const factory NodeSettings({
    /// 是否启用自动切换
    @Default(false) bool autoSwitch,
    
    /// 切换间隔（分钟）
    @Default(30) int switchInterval,
    
    /// 是否启用负载均衡
    @Default(false) bool loadBalance,
    
    /// 节点健康检查
    @Default(true) bool healthCheck,
    
    /// 健康检查间隔（分钟）
    @Default(5) int healthCheckInterval,
  }) = _NodeSettings;
  
  factory NodeSettings.fromJson(Map<String, Object?> json) =>
      _$NodeSettingsFromJson(json);
}

/// 流量统计设置模型
@freezed
abstract class TrafficStatsSettings with _$TrafficStatsSettings {
  const factory TrafficStatsSettings({
    /// 是否启用流量统计
    @Default(true) bool enabled,
    
    /// 是否启用实时统计
    @Default(true) bool realTime,
    
    /// 统计周期
    @Default(StatisticPeriod.daily) StatisticPeriod period,
    
    /// 是否启用流量提醒
    @Default(false) bool trafficAlert,
    
    /// 流量提醒阈值（GB）
    @Default(10) int alertThreshold,
  }) = _TrafficStatsSettings;
  
  factory TrafficStatsSettings.fromJson(Map<String, Object?> json) =>
      _$TrafficStatsSettingsFromJson(json);
}

/// 统计周期枚举
enum StatisticPeriod {
  /// 实时
  realTime,
  
  /// 每小时
  hourly,
  
  /// 每天
  daily,
  
  /// 每周
  weekly,
  
  /// 每月
  monthly,
}

/// 界面设置模型
@freezed
abstract class UI with _$UI {
  const factory UI({
    /// 主题模式
    @Default(ThemeMode.system) ThemeMode themeMode,
    
    /// 语言设置
    @Default('zh-CN') String language,
    
    /// 是否启用动画
    @Default(true) bool animations,
    
    /// 是否启用沉浸式状态栏
    @Default(true) bool immersiveStatusBar,
    
    /// 是否启用沉浸式导航栏
    @Default(true) bool immersiveNavigationBar,
    
    /// 是否启用底部安全区域
    @Default(true) bool safeAreaBottom,
    
    /// 字体大小
    @Default(FontSize.normal) FontSize fontSize,
    
    /// 字体粗细
    @Default(FontWeight.normal) FontWeight fontWeight,
    
    /// 是否启用高对比度
    @Default(false) bool highContrast,
    
    /// 是否启用粗体标签
    @Default(false) bool boldLabels,
  }) = _UI;
  
  factory UI.fromJson(Map<String, Object?> json) =>
      _$UIFromJson(json);
}

/// 字体大小枚举
enum FontSize {
  small,
  normal,
  large,
  extraLarge,
}

/// 字体粗细枚举
enum FontWeight {
  light,
  normal,
  bold,
}

/// 通知设置模型
@freezed
abstract class Notifications with _$Notifications {
  const factory Notifications({
    /// 是否启用通知
    @Default(true) bool enabled,
    
    /// 是否启用连接状态通知
    @Default(true) bool connectionStatus,
    
    /// 是否启用流量提醒通知
    @Default(false) bool trafficAlert,
    
    /// 是否启用节点切换通知
    @Default(false) bool nodeSwitch,
    
    /// 是否启用系统代理通知
    @Default(false) bool systemProxy,
    
    /// 是否启用更新通知
    @Default(true) bool update,
    
    /// 是否启用错误通知
    @Default(true) bool errors,
  }) = _Notifications;
  
  factory Notifications.fromJson(Map<String, Object?> json) =>
      _$NotificationsFromJson(json);
}

/// 隐私设置模型
@freezed
abstract class Privacy with _$Privacy {
  const factory Privacy({
    /// 是否启用隐私模式
    @Default(false) bool privacyMode,
    
    /// 是否启用匿名模式
    @Default(false) bool anonymousMode,
    
    /// 是否启用数据加密
    @Default(true) bool dataEncryption,
    
    /// 是否启用本地数据加密
    @Default(false) bool localDataEncryption,
    
    /// 是否启用自动清理
    @Default(false) bool autoClean,
    
    /// 自动清理间隔（天）
    @Default(7) int cleanInterval,
    
    /// 是否启用遥测
    @Default(false) bool telemetry,
    
    /// 是否启用崩溃报告
    @Default(false) bool crashReporting,
  }) = _Privacy;
  
  factory Privacy.fromJson(Map<String, Object?> json) =>
      _$PrivacyFromJson(json);
}

/// 备份设置模型
@freezed
abstract class Backup with _$Backup {
  const factory Backup({
    /// 是否启用自动备份
    @Default(false) bool autoBackup,
    
    /// 备份间隔（天）
    @Default(7) int backupInterval,
    
    /// 是否启用云备份
    @Default(false) bool cloudBackup,
    
    /// 云备份服务
    @Default(CloudService.none) CloudService cloudService,
    
    /// 是否启用备份加密
    @Default(true) bool backupEncryption,
    
    /// 备份保留数量
    @Default(5) int keepCount,
  }) = _Backup;
  
  factory Backup.fromJson(Map<String, Object?> json) =>
      _$BackupFromJson(json);
}

/// 云服务枚举
enum CloudService {
  none,
  googleDrive,
  dropbox,
  oneDrive,
  icloud,
}

/// AppSettings扩展方法
/// 
/// 为AppSettings模型提供额外的功能方法。
extension AppSettingsExt on AppSettings {
  /// 获取设置显示名称
  String get modeDisplayText {
    switch (mode) {
      case SettingsMode.standard:
        return '标准模式';
      case SettingsMode.privacy:
        return '隐私模式';
      case SettingsMode.developer:
        return '开发者模式';
      case SettingsMode.performance:
        return '高性能模式';
      case SettingsMode.custom:
        return '自定义模式';
    }
  }
  
  /// 检查是否为高性能模式
  bool get isHighPerformance {
    return mode == SettingsMode.performance ||;
           browserSettings.isHighPerformance;
  }
  
  /// 检查是否为隐私优先模式
  bool get isPrivacyFirst {
    return mode == SettingsMode.privacy ||;
           browserSettings.isPrivacyFirst ||
           privacy.privacyMode;
  }
  
  /// 检查是否启用了所有安全功能
  bool get isSecureMode {
    return browserSettings.isSecureMode &&
           privacy.dataEncryption;
  }
  
  /// 获取代理状态显示文本
  String get proxyStatusText {
    if (!flclashSettings.enabled) {
      return '未启用';
    }
    
    switch (flclashSettings.mode) {
      case ProxyMode.rule:
        return '规则模式';
      case ProxyMode.global:
        return '全局模式';
      case ProxyMode.direct:
        return '直连模式';
    }
  }
  
  /// 检查设置是否有效
  List<String> validateSettings() {
    final errors = <String>[];
    
    // 验证浏览器设置
    errors.addAll(BrowserSettingsUtils.validateSettings(browserSettings));
    
    // 验证FlClash设置
    if (flclashSettings.enabled) {
      if (flclashSettings.ports.httpPort == flclashSettings.ports.socksPort) {
        errors.add('HTTP和SOCKS端口不能相同');
      }
      if (flclashSettings.ports.httpPort == flclashSettings.ports.mixedPort) {
        errors.add('HTTP和混合端口不能相同');
      }
      if (flclashSettings.ports.socksPort == flclashSettings.ports.mixedPort) {
        errors.add('SOCKS和混合端口不能相同');
      }
    }
    
    return errors;
  }
}

/// AppSettings工具方法
/// 
/// 提供AppSettings相关的工具函数。
class AppSettingsUtils {
  /// 创建默认设置
  static AppSettings createDefault() {
    return AppSettings(
      version: '1.0.0',
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      mode: SettingsMode.standard,
    );
  }
  
  /// 创建隐私模式设置
  static AppSettings createPrivacyMode() {
    return AppSettings(
      version: '1.0.0',
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      mode: SettingsMode.privacy,
      browserSettings: BrowserSettingsUtils.createPrivacyMode(),
      privacy: const Privacy(
        privacyMode: true,
        anonymousMode: true,
        dataEncryption: true,
        localDataEncryption: true,
        autoClean: true,
        cleanInterval: 1,
        telemetry: false,
        crashReporting: false,
      ),
    );
  }
  
  /// 创建开发者模式设置
  static AppSettings createDeveloperMode() {
    return AppSettings(
      version: '1.0.0',
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      mode: SettingsMode.developer,
      browserSettings: BrowserSettingsUtils.createDeveloperMode(),
      flclashSettings: const FlClashSettings(
        logLevel: LogLevel.debug,
      ),
      ui: const UI(
        animations: true,
        fontSize: FontSize.normal,
      ),
    );
  }
  
  /// 创建高性能模式设置
  static AppSettings createPerformanceMode() {
    return AppSettings(
      version: '1.0.0',
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      mode: SettingsMode.performance,
      browserSettings: const BrowserSettings(
        hardwareAccelerationEnabled: true,
        multiprocessEnabled: true,
        cacheMode: CacheMode.cacheFirst,
        maxConcurrentConnections: 20,
      ),
      flclashSettings: const FlClashSettings(
        mixedMode: true,
        tunMode: true,
      ),
    );
  }
  
  /// 迁移设置版本
  static AppSettings migrateSettings(AppSettings settings, String targetVersion) {
    // 这里实现版本迁移逻辑
    // 目前只有一个版本，直接返回原设置
    return settings.copyWith(
      version: targetVersion,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }
  
  /// 导出设置到JSON
  static Map<String, dynamic> exportToJson(AppSettings settings) {
    return {
      'version': settings.version,
      'exportTime': DateTime.now().millisecondsSinceEpoch,
      'settings': settings.toJson(),
    };
  }
  
  /// 从JSON导入设置
  static AppSettings? importFromJson(Map<String, dynamic> json) {
    try {
      final version = json['version'] as String?;
      final settingsJson = json['settings'] as Map<String, dynamic>?;
      
      if (version == null || settingsJson == null) {
        return null;
      }
      
      return AppSettings.fromJson(settingsJson);
    } catch (e) {
      return null;
    }
  }
}