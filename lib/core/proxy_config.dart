/// 代理配置数据模型
/// 定义代理服务的各种配置参数

import 'package:freezed_annotation/freezed_annotation.dart';

part 'proxy_config.freezed.dart';
part 'proxy_config.g.dart';

/// 代理配置实体
@freezed
class ProxyConfig with _$ProxyConfig {
  const factory ProxyConfig({
    /// 基本配置
    @Default(false) bool enabled,
    @Default('auto') String mode,
    @Default(7890) int port,
    @Default('127.0.0.1') String listenAddress,
    
    /// 路由规则配置
    @Default([]) List<ProxyRule> rules,
    @Default(false) bool bypassChina,
    @Default(false) bool bypassLAN,
    
    /// DNS配置
    @Default('1.1.1.1') String primaryDNS,
    @Default('8.8.8.8') String secondaryDNS,
    @Default(false) bool dnsOverHttps,
    
    /// 安全配置
    @Default(false) bool allowInsecure,
    @Default(true) bool enableIPv6,
    @Default(true) bool enableMux,
    
    /// 连接配置
    @Default(30) int connectionTimeout,
    @Default(60) int readTimeout,
    @Default(10) int retryCount,
    
    /// 日志配置
    @Default(false) bool enableLog,
    @Default('info') String logLevel,
    @Default('/tmp/proxy.log') String logPath,
    
    /// 流量配置
    @Default(true) bool enableTrafficStats,
    @Default(true) bool enableSpeedTest,
    
    /// 节点配置
    @Default('') String selectedNodeId,
    @Default([]) List<ProxyNode> nodes,
    
    /// 自定义配置
    @Default({}) Map<String, dynamic> customSettings,
  }) = _ProxyConfig;
  
  factory ProxyConfig.fromJson(Map<String, dynamic> json) => _$ProxyConfigFromJson(json);
}

/// 代理规则
@freezed
class ProxyRule with _$ProxyRule {
  const factory ProxyRule({
    /// 规则ID
    required String id,
    /// 规则名称
    required String name,
    /// 规则类型
    required ProxyRuleType type,
    /// 匹配模式
    required ProxyMatchType matchType,
    /// 匹配内容
    required String match,
    /// 动作
    required ProxyAction action,
    /// 是否启用
    @Default(true) bool enabled,
    /// 优先级
    @Default(0) int priority,
  }) = _ProxyRule;
  
  factory ProxyRule.fromJson(Map<String, dynamic> json) => _$ProxyRuleFromJson(json);
}

/// 代理规则类型
enum ProxyRuleType {
  /// 域名规则
  domain,
  /// IP规则
  ip,
  /// 端口规则
  port,
  /// 进程规则
  process,
  /// URL规则
  url,
}

/// 匹配类型
enum ProxyMatchType {
  /// 精确匹配
  exact,
  /// 前缀匹配
  prefix,
  /// 后缀匹配
  suffix,
  /// 正则匹配
  regex,
  /// 包含匹配
  contains,
}

/// 代理动作
enum ProxyAction {
  /// 直连
  direct,
  /// 代理
  proxy,
  /// 拒绝
  reject,
  /// 重定向
  redirect,
}

/// 代理节点
@freezed
class ProxyNode with _$ProxyNode {
  const factory ProxyNode({
    /// 节点ID
    required String id,
    /// 节点名称
    required String name,
    /// 节点类型
    required ProxyNodeType type,
    /// 服务器地址
    required String server,
    /// 端口
    required int port,
    /// 协议
    @Default('http') String protocol,
    /// 认证信息
    @Default('') String auth,
    /// 加密方式
    @Default('') String encryption,
    /// 代理标识
    @Default('') String proxyId,
    /// 节点状态
    @Default(NodeStatus.disconnected) NodeStatus status,
    /// 延迟
    @Default(0) int latency,
    /// 带宽
    @Default(0) int bandwidth,
    /// 地区
    @Default('') String region,
    /// 标签
    @Default([]) List<String> tags,
    /// 是否可用
    @Default(true) bool available,
    /// 配置参数
    @Default({}) Map<String, dynamic> config,
  }) = _ProxyNode;
  
  factory ProxyNode.fromJson(Map<String, dynamic> json) => _$ProxyNodeFromJson(json);
}

/// 代理节点类型
enum ProxyNodeType {
  /// HTTP代理
  http,
  /// SOCKS5代理
  socks5,
  /// Shadowsocks
  shadowsocks,
  /// VMess
  vmess,
  /// Trojan
  trojan,
  /// VLESS
  vless,
}

/// 节点状态
enum NodeStatus {
  /// 未连接
  disconnected,
  /// 正在连接
  connecting,
  /// 已连接
  connected,
  /// 错误
  error,
}

/// 流量统计配置
@freezed
class TrafficConfig with _$TrafficConfig {
  const factory TrafficConfig({
    /// 是否启用流量统计
    @Default(true) bool enableStats,
    /// 统计间隔（秒）
    @Default(60) int statsInterval,
    /// 是否记录历史数据
    @Default(true) bool recordHistory,
    /// 历史数据保留天数
    @Default(7) int historyRetentionDays,
    /// 是否启用速度限制
    @Default(false) bool enableSpeedLimit,
    /// 上传速度限制（KB/s）
    @Default(0) int uploadLimit,
    /// 下载速度限制（KB/s）
    @Default(0) int downloadLimit,
    /// 是否启用流量警告
    @Default(false) bool enableTrafficAlert,
    /// 流量警告阈值（MB）
    @Default(1000) int alertThreshold,
  }) = _TrafficConfig;
  
  factory TrafficConfig.fromJson(Map<String, dynamic> json) => _$TrafficConfigFromJson(json);
}

/// 代理配置验证器
class ProxyConfigValidator {
  static List<String> validate(ProxyConfig config) {
    final List<String> errors = [];
    
    // 验证端口范围
    if (config.port < 1 || config.port > 65535) {
      errors.add('端口号必须在 1-65535 范围内');
    }
    
    // 验证DNS地址格式
    if (!_isValidIP(config.primaryDNS)) {
      errors.add('主DNS地址格式无效');
    }
    
    if (!_isValidIP(config.secondaryDNS)) {
      errors.add('辅DNS地址格式无效');
    }
    
    // 验证超时时间
    if (config.connectionTimeout <= 0) {
      errors.add('连接超时时间必须大于0');
    }
    
    if (config.readTimeout <= 0) {
      errors.add('读取超时时间必须大于0');
    }
    
    // 验证重试次数
    if (config.retryCount < 0) {
      errors.add('重试次数不能为负数');
    }
    
    return errors;
  }
  
  static bool _isValidIP(String ip) {
    final regex = RegExp(r'^([0-9]{1,3}\.){3}[0-9]{1,3}$');
    return regex.hasMatch(ip);
  }
}