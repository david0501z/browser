/// 订阅管理数据模型
library subscription;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'proxy_node.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

/// 订阅链接类型枚举
enum SubscriptionType {
  /// V2Ray 订阅
  v2ray,
  /// Clash 订阅
  clash,
  /// Clash Meta 订阅
  clashMeta,
  /// SS/SSR 订阅
  ss,
  /// Trojan 订阅
  trojan,
  /// 未知类型
  unknown,
}

/// 订阅状态
enum SubscriptionStatus {
  /// 正常
  active,
  /// 已禁用
  disabled,
  /// 更新中
  updating,
  /// 错误
  error,
}

/// 订阅链接模型
@freezed
class SubscriptionLink with _$SubscriptionLink {
  const factory SubscriptionLink({
    /// 订阅 ID
    required String id,
    
    /// 订阅名称
    required String name,
    
    /// 订阅 URL
    required String url,
    
    /// 订阅类型
    @Default(SubscriptionType.unknown) SubscriptionType type,
    
    /// 订阅状态
    @Default(SubscriptionStatus.active) SubscriptionStatus status,
    
    /// 上次更新时间
    DateTime? lastUpdated,
    
    /// 下次更新计划时间
    DateTime? nextUpdate,
    
    /// 更新间隔（小时）
    @Default(24) int updateIntervalHours,
    
    /// 是否自动更新
    @Default(true) bool autoUpdate,
    
    /// 是否启用
    @Default(true) bool enabled,
    
    /// 节点列表
    @Default([]) List<ProxyNode> nodes,
    
    /// 订阅描述
    String? description,
    
    /// 订阅分组信息
    List<String>? groups,
    
    /// 订阅标签
    List<String>? tags,
    
    /// 订阅来源
    String? source,
    
    /// 创建时间
    @Default(DateTime.now) DateTime createdAt,
    
    /// 更新时间
    DateTime? updatedAt,
    
    /// 错误信息
    String? errorMessage,
    
    /// 解析结果统计
    @Default(_emptyStats) ParseStats parseStats,
  }) = _SubscriptionLink;

  factory SubscriptionLink.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionLinkFromJson(json);
}

/// 订阅解析统计
@freezed
class ParseStats with _$ParseStats {
  const factory ParseStats({
    /// 总节点数
    @Default(0) int totalNodes,
    
    /// 有效节点数
    @Default(0) int validNodes,
    
    /// 无效节点数
    @Default(0) int invalidNodes,
    
    /// 跳过节点数
    @Default(0) int skippedNodes,
    
    /// 解析错误数
    @Default(0) int parseErrors,
    
    /// 解析耗时（毫秒）
    @Default(0) int parseTimeMs,
    
    /// 最后一次解析时间
    DateTime? lastParsedAt,
  }) = _ParseStats;

  factory ParseStats.fromJson(Map<String, dynamic> json) =>
      _$ParseStatsFromJson(json);
}

/// 空统计对象
const ParseStats _emptyStats = ParseStats();

/// 订阅管理模型
@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    /// 当前激活的订阅 ID
    String? activeSubscriptionId,
    
    /// 订阅列表
    @Default([]) List<SubscriptionLink> subscriptions,
    
    /// 是否正在更新所有订阅
    @Default(false) bool isUpdating,
    
    /// 自动更新间隔（小时）
    @Default(24) int globalUpdateIntervalHours,
    
    /// 是否启用自动更新
    @Default(true) bool autoUpdateEnabled,
    
    /// 更新模式：并发或串行
    @Default(true) bool concurrentUpdate,
    
    /// 订阅缓存策略
    @Default(CacheStrategy.memory) CacheStrategy cacheStrategy,
    
    /// 默认订阅设置
    SubscriptionSettings? defaultSettings,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}

/// 订阅设置
@freezed
class SubscriptionSettings with _$SubscriptionSettings {
  const factory SubscriptionSettings({
    /// 连接超时时间（秒）
    @Default(30) int connectTimeoutSeconds,
    
    /// 读取超时时间（秒）
    @Default(60) int readTimeoutSeconds,
    
    /// 最大重试次数
    @Default(3) int maxRetries,
    
    /// 是否验证 SSL 证书
    @Default(true) bool verifySSLCert,
    
    /// 是否使用代理获取订阅
    @Default(false) bool useProxy,
    
    /// 订阅获取代理地址
    String? proxyUrl,
    
    /// 是否自动合并相同节点
    @Default(true) bool mergeDuplicateNodes,
    
    /// 是否过滤重复节点
    @Default(true) bool filterDuplicateNodes,
    
    /// 节点验证级别
    @Default(ValidationLevel.medium) ValidationLevel validationLevel,
  }) = _SubscriptionSettings;

  factory SubscriptionSettings.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionSettingsFromJson(json);
}

/// 缓存策略
enum CacheStrategy {
  /// 内存缓存
  memory,
  /// 持久化缓存
  persistent,
  /// 无缓存
  none,
}

/// 验证级别
enum ValidationLevel {
  /// 低级验证
  low,
  /// 中级验证
  medium,
  /// 高级验证
  high,
}

/// 订阅更新结果
@freezed
class UpdateResult with _$UpdateResult {
  const factory UpdateResult({
    /// 是否成功
    required bool success,
    
    /// 订阅 ID
    required String subscriptionId,
    
    /// 新增节点数
    @Default(0) int addedNodes,
    
    /// 更新节点数
    @Default(0) int updatedNodes,
    
    /// 移除节点数
    @Default(0) int removedNodes,
    
    /// 错误信息
    String? error,
    
    /// 更新耗时（毫秒）
    @Default(0) int durationMs,
    
    /// 更新开始时间
    required DateTime startTime,
    
    /// 更新结束时间
    required DateTime endTime,
  }) = _UpdateResult;

  factory UpdateResult.fromJson(Map<String, dynamic> json) =>
      _$UpdateResultFromJson(json);
}

/// 订阅导入结果
@freezed
class ImportResult with _$ImportResult {
  const factory ImportResult({
    /// 是否成功
    required bool success,
    
    /// 导入的订阅数量
    @Default(0) int importedSubscriptions,
    
    /// 导入的节点总数
    @Default(0) int totalNodes,
    
    /// 有效的节点数
    @Default(0) int validNodes,
    
    /// 失败的订阅数量
    @Default(0) int failedSubscriptions,
    
    /// 错误列表
    @Default([]) List<String> errors,
    
    /// 导入统计
    @Default(_emptyImportStats) ImportStats importStats,
  }) = _ImportResult;

  factory ImportResult.fromJson(Map<String, dynamic> json) =>
      _$ImportResultFromJson(json);
}

/// 导入统计
@freezed
class ImportStats with _$ImportStats {
  const factory ImportStats({
    /// V2Ray 节点数
    @Default(0) int v2rayCount,
    
    /// SS 节点数
    @Default(0) int ssCount,
    
    /// SSR 节点数
    @Default(0) int ssrCount,
    
    /// Trojan 节点数
    @Default(0) int trojanCount,
    
    /// 错误节点数
    @Default(0) int errorCount,
    
    /// 总导入耗时（毫秒）
    @Default(0) int totalImportTimeMs,
  }) = _ImportStats;

  factory ImportStats.fromJson(Map<String, dynamic> json) =>
      _$ImportStatsFromJson(json);
}

/// 空导入统计对象
const ImportStats _emptyImportStats = ImportStats();