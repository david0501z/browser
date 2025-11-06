/// 代理核心接口定义
/// 定义与原生库交互的接口规范

import 'dart:ffi';
import 'dart:async';

/// FFI 函数指针类型定义
typedef ProxyInitFunc = Void Function();
typedef ProxyStartFunc = Int32 Function();
typedef ProxyStopFunc = Int32 Function();
typedef ProxyStatusFunc = Int32 Function();
typedef ProxyConfigFunc = Int32 Function(Pointer<Utf8>);
typedef ProxyStatsFunc = Pointer<Void> Function();

/// 代理核心接口
abstract class ProxyCoreInterface {
  /// 初始化代理核心
  Future<void> initialize();
  
  /// 启动代理服务
  Future<ProxyResult> start();
  
  /// 停止代理服务
  Future<ProxyResult> stop();
  
  /// 获取代理状态
  Future<ProxyStatus> getStatus();
  
  /// 配置代理
  Future<ProxyResult> configure(String configJson);
  
  /// 获取流量统计
  Future<TrafficStats> getTrafficStats();
  
  /// 获取节点列表
  Future<List<ProxyNode>> getNodes();
  
  /// 切换节点
  Future<ProxyResult> switchNode(String nodeId);
  
  /// 获取连接日志
  Stream<String> getConnectionLogs();
  
  /// 清理资源
  void dispose();
}

/// 代理操作结果
class ProxyResult {
  final bool success;
  final String? message;
  final int? code;
  
  const ProxyResult({
    required this.success,
    this.message,
    this.code,
  });
  
  factory ProxyResult.success([String? message]) => ProxyResult(
    success: true,
    message: message,
  );
  
  factory ProxyResult.error(String message, [int? code]) => ProxyResult(
    success: false,
    message: message,
    code: code,
  );
}

/// 代理状态枚举
enum ProxyStatus {
  disconnected,
  connecting,
  connected,
  disconnecting,
  error;
  
  bool get isConnected => this == ProxyStatus.connected;
  bool get isConnecting => this == ProxyStatus.connecting;
  bool get isDisconnected => this == ProxyStatus.disconnected;
}

/// 代理节点信息
class ProxyNode {
  final String id;
  final String name;
  final String type;
  final String server;
  final int port;
  final String? protocol;
  final Map<String, dynamic> properties;
  final bool isActive;
  final int latency;
  
  const ProxyNode({
    required this.id,
    required this.name,
    required this.type,
    required this.server,
    required this.port,
    this.protocol,
    required this.properties,
    required this.isActive,
    required this.latency,
  });
  
  factory ProxyNode.fromJson(Map<String, dynamic> json) {
    return ProxyNode(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      server: json['server'] as String,
      port: json['port'] as int,
      protocol: json['protocol'] as String?,
      properties: Map<String, dynamic>.from(json['properties'] as Map? ?? {}),
      isActive: json['isActive'] as bool? ?? false,
      latency: json['latency'] as int? ?? 0,
    );
  }
}

/// 代理配置参数
class ProxyConfigParams {
  final List<String> rules;
  final String mode;
  final String dnsServer;
  final int port;
  final bool allowInsecure;
  final Map<String, dynamic> customSettings;
  
  const ProxyConfigParams({
    this.rules = const [],
    this.mode = 'global',
    this.dnsServer = '1.1.1.1',
    this.port = 7890,
    this.allowInsecure = false,
    this.customSettings = const {},
  });
  
  Map<String, dynamic> toJson() {
    return {
      'rules': rules,
      'mode': mode,
      'dnsServer': dnsServer,
      'port': port,
      'allowInsecure': allowInsecure,
      'customSettings': customSettings,
    };
  }
}