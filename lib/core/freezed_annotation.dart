/// Freezed 数据类简化实现
/// 用于替代缺少的 freezed_annotation

/// Freezed 注解
class freezed {
  const freezed();
}

class Default<T> {
  final T value;
  const Default(this.value);
}

class JsonKey {
  final String? name;
  final bool? fromJson;
  final bool? toJson;
  
  const JsonKey({this.name, this.fromJson, this.toJson});
}

// 简化的日期时间转换器
class DateTimeConverter {
  const DateTimeConverter();
  
  DateTime fromJson(String json) {
    return DateTime.parse(json);
  }
  
  String toJson(DateTime dateTime) {
    return dateTime.toIso8601String();
  }
}

/// 免费zed 生成的代码占位符
class _ProxyConfig {
  factory _ProxyConfig({
    bool enabled = false,
    String mode = 'auto',
    int port = 7890,
    String listenAddress = '127.0.0.1',
    List<dynamic> rules = const [],
    bool bypassChina = false,
    bool bypassLAN = false,
    String primaryDNS = '1.1.1.1',
    String secondaryDNS = '8.8.8.8',
    bool dnsOverHttps = false,
    bool allowInsecure = false,
    bool enableIPv6 = true,
    bool enableMux = true,
    int connectionTimeout = 30,
    int readTimeout = 60,
    int retryCount = 3,
    bool enableLog = false,
    String logLevel = 'info',
    String logPath = '/tmp/proxy.log',
    bool enableTrafficStats = true,
    bool enableSpeedTest = true,
    String selectedNodeId = '',
    List<dynamic> nodes = const [],
    Map<String, dynamic> customSettings = const {},
  }) = _ProxyConfigImpl;
}

class _ProxyConfigImpl implements _ProxyConfig {
  final bool enabled;
  final String mode;
  final int port;
  final String listenAddress;
  final List<dynamic> rules;
  final bool bypassChina;
  final bool bypassLAN;
  final String primaryDNS;
  final String secondaryDNS;
  final bool dnsOverHttps;
  final bool allowInsecure;
  final bool enableIPv6;
  final bool enableMux;
  final int connectionTimeout;
  final int readTimeout;
  final int retryCount;
  final bool enableLog;
  final String logLevel;
  final String logPath;
  final bool enableTrafficStats;
  final bool enableSpeedTest;
  final String selectedNodeId;
  final List<dynamic> nodes;
  final Map<String, dynamic> customSettings;

  const _ProxyConfigImpl({
    required this.enabled,
    required this.mode,
    required this.port,
    required this.listenAddress,
    required this.rules,
    required this.bypassChina,
    required this.bypassLAN,
    required this.primaryDNS,
    required this.secondaryDNS,
    required this.dnsOverHttps,
    required this.allowInsecure,
    required this.enableIPv6,
    required this.enableMux,
    required this.connectionTimeout,
    required this.readTimeout,
    required this.retryCount,
    required this.enableLog,
    required this.logLevel,
    required this.logPath,
    required this.enableTrafficStats,
    required this.enableSpeedTest,
    required this.selectedNodeId,
    required this.nodes,
    required this.customSettings,
  });

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'mode': mode,
      'port': port,
      'listenAddress': listenAddress,
      'rules': rules,
      'bypassChina': bypassChina,
      'bypassLAN': bypassLAN,
      'primaryDNS': primaryDNS,
      'secondaryDNS': secondaryDNS,
      'dnsOverHttps': dnsOverHttps,
      'allowInsecure': allowInsecure,
      'enableIPv6': enableIPv6,
      'enableMux': enableMux,
      'connectionTimeout': connectionTimeout,
      'readTimeout': readTimeout,
      'retryCount': retryCount,
      'enableLog': enableLog,
      'logLevel': logLevel,
      'logPath': logPath,
      'enableTrafficStats': enableTrafficStats,
      'enableSpeedTest': enableSpeedTest,
      'selectedNodeId': selectedNodeId,
      'nodes': nodes,
      'customSettings': customSettings,
    };
  }

  factory _ProxyConfigImpl.fromJson(Map<String, dynamic> json) {
    return _ProxyConfigImpl(
      enabled: json['enabled'] ?? false,
      mode: json['mode'] ?? 'auto',
      port: json['port'] ?? 7890,
      listenAddress: json['listenAddress'] ?? '127.0.0.1',
      rules: json['rules'] ?? [],
      bypassChina: json['bypassChina'] ?? false,
      bypassLAN: json['bypassLAN'] ?? false,
      primaryDNS: json['primaryDNS'] ?? '1.1.1.1',
      secondaryDNS: json['secondaryDNS'] ?? '8.8.8.8',
      dnsOverHttps: json['dnsOverHttps'] ?? false,
      allowInsecure: json['allowInsecure'] ?? false,
      enableIPv6: json['enableIPv6'] ?? true,
      enableMux: json['enableMux'] ?? true,
      connectionTimeout: json['connectionTimeout'] ?? 30,
      readTimeout: json['readTimeout'] ?? 60,
      retryCount: json['retryCount'] ?? 3,
      enableLog: json['enableLog'] ?? false,
      logLevel: json['logLevel'] ?? 'info',
      logPath: json['logPath'] ?? '/tmp/proxy.log',
      enableTrafficStats: json['enableTrafficStats'] ?? true,
      enableSpeedTest: json['enableSpeedTest'] ?? true,
      selectedNodeId: json['selectedNodeId'] ?? '',
      nodes: json['nodes'] ?? [],
      customSettings: json['customSettings'] ?? {},
    );
  }
}