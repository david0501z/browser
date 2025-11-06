/// 代理状态数据模型
library proxy_state;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'proxy_state.freezed.dart';
part 'proxy_state.g.dart';

/// 代理服务器配置
@freezed
class ProxyServer with _$ProxyServer {
  const factory ProxyServer({
    /// 服务器ID
    required String id,
    
    /// 服务器名称
    required String name,
    
    /// 服务器地址
    required String server,
    
    /// 服务器端口
    required int port,
    
    /// 用户名
    String? username,
    
    /// 密码
    String? password,
    
    /// 协议类型 (HTTP, HTTPS, SOCKS5)
    required ProxyProtocol protocol,
    
    /// 是否启用
    required bool enabled,
    
    /// 创建时间
    required DateTime createdAt,
    
    /// 最后使用时间
    DateTime? lastUsedAt,
    
    /// 连接延迟 (毫秒)
    int? latency,
  }) = _ProxyServer;
  
  factory ProxyServer.fromJson(Map<String, dynamic> json) =>
      _$ProxyServerFromJson(json);
}

/// 代理协议类型
enum ProxyProtocol {
  @JsonValue('HTTP')
  http('HTTP'),
  @JsonValue('HTTPS')
  https('HTTPS'),
  @JsonValue('SOCKS5')
  socks5('SOCKS5');

  const ProxyProtocol(this.value);
  final String value;
}

/// 代理连接状态
@freezed
class ProxyConnectionState with _$ProxyConnectionState {
  const factory ProxyConnectionState({
    /// 是否已连接
    required bool isConnected,
    
    /// 当前使用的代理服务器ID
    String? currentServerId,
    
    /// 连接时间
    DateTime? connectedAt,
    
    /// 断连时间
    DateTime? disconnectedAt,
    
    /// 连接错误信息
    String? errorMessage,
    
    /// 上传流量 (字节)
    required int uploadBytes,
    
    /// 下载流量 (字节)
    required int downloadBytes,
    
    /// 上传速度 (字节/秒)
    required int uploadSpeed,
    
    /// 下载速度 (字节/秒)
    required int downloadSpeed,
  }) = _ProxyConnectionState;
  
  factory ProxyConnectionState.fromJson(Map<String, dynamic> json) =>
      _$ProxyConnectionStateFromJson(json);
}

/// 代理规则配置
@freezed
class ProxyRule with _$ProxyRule {
  const factory ProxyRule({
    /// 规则ID
    required String id,
    
    /// 规则名称
    required String name,
    
    /// 匹配模式 (域名、IP、正则表达式)
    required String pattern,
    
    /// 规则类型
    required ProxyRuleType type,
    
    /// 匹配的代理服务器ID
    required String proxyServerId,
    
    /// 是否启用
    required bool enabled,
    
    /// 创建时间
    required DateTime createdAt,
  }) = _ProxyRule;
  
  factory ProxyRule.fromJson(Map<String, dynamic> json) =>
      _$ProxyRuleFromJson(json);
}

/// 代理规则类型
enum ProxyRuleType {
  @JsonValue('DOMAIN')
  domain('域名'),
  @JsonValue('IP')
  ip('IP'),
  @JsonValue('REGEX')
  regex('正则表达式');

  const ProxyRuleType(this.value);
  final String value;
}

/// 代理状态枚举
enum ProxyStatus {
  @JsonValue('DISCONNECTED')
  disconnected('未连接'),
  @JsonValue('CONNECTING')
  connecting('连接中'),
  @JsonValue('CONNECTED')
  connected('已连接'),
  @JsonValue('DISCONNECTING')
  disconnecting('断连中'),
  @JsonValue('ERROR')
  error('错误');

  const ProxyStatus(this.value);
  final String value;
}

/// 全局代理状态
@freezed
class GlobalProxyState with _$GlobalProxyState {
  const factory GlobalProxyState({
    /// 当前代理状态
    required ProxyStatus status,
    
    /// 代理服务器列表
    required List<ProxyServer> servers,
    
    /// 当前连接状态
    required ProxyConnectionState connectionState,
    
    /// 代理规则列表
    required List<ProxyRule> rules,
    
    /// 是否启用全局代理
    required bool isGlobalProxy,
    
    /// 系统代理设置
    required SystemProxySettings systemProxySettings,
    
    /// 自动连接设置
    required AutoConnectSettings autoConnectSettings,
    
    /// 最后更新时间
    required DateTime lastUpdated,
  }) = _GlobalProxyState;
  
  factory GlobalProxyState.fromJson(Map<String, dynamic> json) =>
      _$GlobalProxyStateFromJson(json);
}

/// 系统代理设置
@freezed
class SystemProxySettings with _$SystemProxySettings {
  const factory SystemProxySettings({
    /// 是否启用系统代理
    required bool enabled,
    
    /// HTTP代理地址
    String? httpProxy,
    
    /// HTTPS代理地址
    String? httpsProxy,
    
    /// SOCKS代理地址
    String? socksProxy,
    
    /// 跳过代理的地址列表
    required List<String> bypassList,
  }) = _SystemProxySettings;
  
  factory SystemProxySettings.fromJson(Map<String, dynamic> json) =>
      _$SystemProxySettingsFromJson(json);
}

/// 自动连接设置
@freezed
class AutoConnectSettings with _$AutoConnectSettings {
  const factory AutoConnectSettings({
    /// 是否启用自动连接
    required bool enabled,
    
    /// 应用启动时自动连接
    required bool autoConnectOnStartup,
    
    /// 断线时自动重连
    required bool autoReconnect,
    
    /// 重连间隔 (秒)
    required int reconnectInterval,
    
    /// 最大重连次数
    required int maxReconnectAttempts,
  }) = _AutoConnectSettings;
  
  factory AutoConnectSettings.fromJson(Map<String, dynamic> json) =>
      _$AutoConnectSettingsFromJson(json);
}