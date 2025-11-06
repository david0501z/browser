import 'package:freezed_annotation/freezed_annotation.dart';

part 'proxy_node.freezed.dart';
part 'proxy_node.g.dart';

/// 代理协议类型
enum ProxyType {
  /// V2Ray VMess
  vmess,
  /// V2Ray VLESS
  vless,
  /// Shadowsocks
  ss,
  /// ShadowsocksR
  ssr,
  /// Trojan
  trojan,
  /// SOCKS5
  socks5,
  /// HTTP 代理
  http,
  /// 未知类型
  unknown,
}

/// 代理协议版本
enum ProxyVersion {
  /// VMess
  vmess,
  /// VLESS
  vless,
  /// Shadowsocks 2018-2022
  ss,
  /// ShadowsocksR
  ssr,
  /// Trojan
  trojan,
}

/// 代理节点状态
enum NodeStatus {
  /// 正常连接
  normal,
  /// 连接失败
  error,
  /// 连接超时
  timeout,
  /// 正在测试
  testing,
  /// 未测试
  untested,
  /// 已禁用
  disabled,
  /// 已选中
  selected,
}

/// 代理节点安全性级别
enum SecurityLevel {
  /// 低安全
  low,
  /// 中等安全
  medium,
  /// 高安全
  high,
  /// 极高安全
  veryHigh,
}

/// 代理节点模型
@freezed
class ProxyNode with _$ProxyNode {
  const factory ProxyNode({
    /// 节点唯一标识符
    required String id,
    
    /// 节点名称
    required String name,
    
    /// 代理类型
    required ProxyType type,
    
    /// 代理版本
    @Default(ProxyVersion.vmess) ProxyVersion version,
    
    /// 服务器地址
    required String server,
    
    /// 服务器端口
    required int port,
    
    /// 加密方式（如适用）
    String? security,
    
    /// 认证信息（如适用）
    String? auth,
    
    /// VMess 特有参数
    VMessConfig? vmessConfig,
    
    /// VLESS 特有参数
    VLessConfig? vlessConfig,
    
    /// SS/SSR 特有参数
    SSConfig? ssConfig,
    
    /// Trojan 特有参数
    TrojanConfig? trojanConfig,
    
    /// 节点状态
    @Default(NodeStatus.untested) NodeStatus status,
    
    /// 测试延迟（毫秒）
    int? latency,
    
    /// 下载速度（MB/s）
    double? downloadSpeed,
    
    /// 上传速度（MB/s）
    double? uploadSpeed,
    
    /// 最后测试时间
    DateTime? lastTested,
    
    /// 是否启用
    @Default(true) bool enabled,
    
    /// 是否自动选择
    @Default(false) bool autoSelect,
    
    /// 是否收藏
    @Default(false) bool favorite,
    
    /// 节点标签
    @Default([]) List<String> tags,
    
    /// 节点备注
    String? remark,
    
    /// 节点国家/地区
    String? country,
    
    /// 节点城市
    String? city,
    
    /// ISP 信息
    String? isp,
    
    /// 节点延迟历史记录
    @Default([]) List<int> latencyHistory,
    
    /// 节点优先级（用于自动选择）
    @Default(0) int priority,
    
    /// 错误信息
    String? errorMessage,
    
    /// 创建时间
    @Default(DateTime.now) DateTime createdAt,
    
    /// 更新时间
    DateTime? updatedAt,
    
    /// 节点来源订阅 ID
    String? subscriptionId,
    
    /// 节点所在组名
    String? group,
    
    /// 节点的原始配置文本
    String? rawConfig,
    
    /// 节点图标 URL（用于显示）
    String? iconUrl,
    
    /// 节点的地理位置信息
    GeoInfo? geoInfo,
    
    /// 节点性能指标
    NodePerformance? performance,
  }) = _ProxyNode;

  factory ProxyNode.fromJson(Map<String, dynamic> json) =>
      _$ProxyNodeFromJson(json);
}

/// VMess 配置
@freezed
class VMessConfig with _$VMessConfig {
  const factory VMessConfig({
    /// VMess 用户 ID
    required String uuid,
    
    /// 加密方式
    @Default('auto') String encryption,
    
    /// 传输协议
    @Default('ws') String transport,
    
    /// 传输伪装类型
    String? streamSecurity,
    
    /// 传输路径
    String? path,
    
    /// 传输主机名
    String? host,
    
    /// 是否启用 TLS
    @Default(false) bool tls,
    
    /// TLS 证书路径
    String? tlsCert,
    
    /// TLS 私钥路径
    String? tlsKey,
    
    /// SNI 域名
    String? sni,
    
    /// 是否验证证书
    @Default(true) bool verifyCertificate,
    
    /// WebSocket 特定配置
    WSConfig? wsConfig,
    
    /// HTTP/2 特定配置
    HTTP2Config? http2Config,
    
    /// TCP 特定配置
    TCPConfig? tcpConfig,
    
    /// gRPC 特定配置
    GRPCConfig? grpcConfig,
  }) = _VMessConfig;

  factory VMessConfig.fromJson(Map<String, dynamic> json) =>
      _$VMessConfigFromJson(json);
}

/// VLESS 配置
@freezed
class VLessConfig with _$VLessConfig {
  const factory VLessConfig({
    /// VLESS 用户 ID
    required String uuid,
    
    /// 流控类型
    @Default('xtls-rprx-vision') String flow,
    
    /// 传输协议
    @Default('ws') String transport,
    
    /// 传输伪装类型
    String? streamSecurity,
    
    /// 传输路径
    String? path,
    
    /// 传输主机名
    String? host,
    
    /// 是否启用 TLS
    @Default(false) bool tls,
    
    /// TLS 类型（xtls 或 tls）
    @Default('xtls') String tlsType,
    
    /// TLS 证书路径
    String? tlsCert,
    
    /// TLS 私钥路径
    String? tlsKey,
    
    /// SNI 域名
    String? sni,
    
    /// WebSocket 特定配置
    WSConfig? wsConfig,
  }) = _VLessConfig;

  factory VLessConfig.fromJson(Map<String, dynamic> json) =>
      _$VLessConfigFromJson(json);
}

/// Shadowsocks 配置
@freezed
class SSConfig with _$SSConfig {
  const factory SSConfig({
    /// 密码
    required String password,
    
    /// 加密方法
    @Default('aes-256-gcm') String method,
    
    /// 插件类型
    String? plugin,
    
    /// 插件配置
    String? pluginOpts,
  }) = _SSConfig;

  factory SSConfig.fromJson(Map<String, dynamic> json) =>
      _$SSConfigFromJson(json);
}

/// Trojan 配置
@freezed
class TrojanConfig with _$TrojanConfig {
  const factory TrojanConfig({
    /// Trojan 密码
    required String password,
    
    /// TLS 配置
    TLSConfig? tlsConfig,
    
    /// WebSocket 配置
    WSConfig? wsConfig,
  }) = _TrojanConfig;

  factory TrojanConfig.fromJson(Map<String, dynamic> json) =>
      _$TrojanConfigFromJson(json);
}

/// 传输配置
@freezed
class WSConfig with _$WSConfig {
  const factory WSConfig({
    /// WebSocket 路径
    required String path,
    
    /// WebSocket 主机头
    String? headers,
    
    /// 是否提前数据
    @Default(false) bool earlyDataHeaderName,
  }) = _WSConfig;

  factory WSConfig.fromJson(Map<String, dynamic> json) =>
      _$WSConfigFromJson(json);
}

/// HTTP/2 配置
@freezed
class HTTP2Config with _$HTTP2Config {
  const factory HTTP2Config({
    /// HTTP/2 路径
    required String path,
    
    /// SNI 域名
    required String sni,
    
    /// HTTP/2 主机
    String? host,
  }) = _HTTP2Config;

  factory HTTP2Config.fromJson(Map<String, dynamic> json) =>
      _$HTTP2ConfigFromJson(json);
}

/// TCP 配置
@freezed
class TCPConfig with _$TCPConfig {
  const factory TCPConfig({
    /// TCP 伪装类型
    @Default('none') String acceptQueryProtocol,
    
    /// HTTP 头部路径
    String? headerPath,
    
    /// HTTP 头部端口
    int? headerPorts,
  }) = _TCPConfig;

  factory TCPConfig.fromJson(Map<String, dynamic> json) =>
      _$TCPConfigFromJson(json);
}

/// gRPC 配置
@freezed
class GRPCConfig with _$GRPCConfig {
  const factory GRPCConfig({
    /// gRPC 服务名称
    required String serviceName,
    
    /// gRPC 模式
    @Default('multi') String mode,
  }) = _GRPCConfig;

  factory GRPCConfig.fromJson(Map<String, dynamic> json) =>
      _$GRPCConfigFromJson(json);
}

/// TLS 配置
@freezed
class TLSConfig with _$TLSConfig {
  const factory TLSConfig({
    /// SNI 域名
    required String sni,
    
    /// ALPN 协议
    @Default(['http/1.1']) List<String> alpn,
    
    /// TLS 证书路径
    String? certPath,
    
    /// TLS 私钥路径
    String? keyPath,
  }) = _TLSConfig;

  factory TLSConfig.fromJson(Map<String, dynamic> json) =>
      _$TLSConfigFromJson(json);
}

/// 地理位置信息
@freezed
class GeoInfo with _$GeoInfo {
  const factory GeoInfo({
    /// 国家代码
    String? countryCode,
    
    /// 国家名称
    String? country,
    
    /// 地区名称
    String? region,
    
    /// 城市名称
    String? city,
    
    /// 时区
    String? timezone,
    
    /// ISP 名称
    String? isp,
    
    /// ASN 信息
    String? asn,
    
    /// 纬度
    double? latitude,
    
    /// 经度
    double? longitude,
  }) = _GeoInfo;

  factory GeoInfo.fromJson(Map<String, dynamic> json) =>
      _$GeoInfoFromJson(json);
}

/// 节点性能指标
@freezed
class NodePerformance with _$NodePerformance {
  const factory NodePerformance({
    /// 平均延迟
    int? avgLatency,
    
    /// 最小延迟
    int? minLatency,
    
    /// 最大延迟
    int? maxLatency,
    
    /// 成功率百分比
    @Default(0.0) double successRate,
    
    /// 测试次数
    @Default(0) int testCount,
    
    /// 最后成功时间
    DateTime? lastSuccessTime,
    
    /// 最后失败时间
    DateTime? lastFailTime,
    
    /// 连续失败次数
    @Default(0) int consecutiveFailures,
    
    /// 稳定性评分（0-100）
    @Default(0) int stabilityScore,
  }) = _NodePerformance;

  factory NodePerformance.fromJson(Map<String, dynamic> json) =>
      _$NodePerformanceFromJson(json);
}

/// 节点过滤条件
@freezed
class NodeFilter with _$NodeFilter {
  const factory NodeFilter({
    /// 节点类型过滤
    List<ProxyType>? types,
    
    /// 节点状态过滤
    List<NodeStatus>? statuses,
    
    /// 国家过滤
    List<String>? countries,
    
    /// ISP 过滤
    List<String>? isps,
    
    /// 标签过滤
    List<String>? tags,
    
    /// 是否收藏
    bool? isFavorite,
    
    /// 是否启用
    bool? isEnabled,
    
    /// 最大延迟
    int? maxLatency,
    
    /// 最小成功率
    double? minSuccessRate,
    
    /// 关键词过滤
    String? keyword,
    
    /// 自定义过滤函数
    String? customFilter,
  }) = _NodeFilter;

  factory NodeFilter.fromJson(Map<String, dynamic> json) =>
      _$NodeFilterFromJson(json);
}

/// 节点排序规则
@freezed
class NodeSort with _$NodeSort {
  const factory NodeSort({
    /// 排序字段
    @Default(NodeSortField.name) NodeSortField field,
    
    /// 排序方式
    @Default(SortOrder.asc) SortOrder order,
  }) = _NodeSort;

  factory NodeSort.fromJson(Map<String, dynamic> json) =>
      _$NodeSortFromJson(json);
}

/// 排序字段
enum NodeSortField {
  /// 按名称排序
  name,
  /// 按延迟排序
  latency,
  /// 按速度排序
  speed,
  /// 按优先级排序
  priority,
  /// 按创建时间排序
  createdAt,
  /// 按成功率排序
  successRate,
}

/// 排序方式
enum SortOrder {
  /// 升序
  asc,
  /// 降序
  desc,
}

/// 节点导出格式
enum ExportFormat {
  /// Clash 格式
  clash,
  /// V2Ray 格式
  v2ray,
  /// SS 格式
  ss,
  /// Base64 格式
  base64,
  /// JSON 格式
  json,
}

/// 节点导入结果
@freezed
class NodeImportResult with _$NodeImportResult {
  const factory NodeImportResult({
    /// 是否成功
    required bool success,
    
    /// 导入的节点数量
    @Default(0) int importedNodes,
    
    /// 有效节点数量
    @Default(0) int validNodes,
    
    /// 无效节点数量
    @Default(0) int invalidNodes,
    
    /// 重复节点数量
    @Default(0) int duplicateNodes,
    
    /// 错误信息列表
    @Default([]) List<String> errors,
    
    /// 导入的节点列表
    @Default([]) List<ProxyNode> nodes,
    
    /// 导入统计信息
    @Default(_emptyImportStats) NodeImportStats importStats,
  }) = _NodeImportResult;

  factory NodeImportResult.fromJson(Map<String, dynamic> json) =>
      _$NodeImportResultFromJson(json);
}

/// 节点导入统计
@freezed
class NodeImportStats with _$NodeImportStats {
  const factory NodeImportStats({
    /// VMess 节点数量
    @Default(0) int vmessCount,
    
    /// VLESS 节点数量
    @Default(0) int vlessCount,
    
    /// SS 节点数量
    @Default(0) int ssCount,
    
    /// SSR 节点数量
    @Default(0) int ssrCount,
    
    /// Trojan 节点数量
    @Default(0) int trojanCount,
    
    /// 解析错误数量
    @Default(0) int parseErrors,
    
    /// 总导入时间（毫秒）
    @Default(0) int totalTimeMs,
  }) = _NodeImportStats;

  factory NodeImportStats.fromJson(Map<String, dynamic> json) =>
      _$NodeImportStatsFromJson(json);
}

/// 空导入统计对象
const NodeImportStats _emptyImportStats = NodeImportStats();