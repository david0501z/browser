/// 代理模式枚举定义
/// 定义了 Clash 代理服务器的工作模式
enum ProxyMode {
  /// 全局模式：所有流量都通过代理服务器
  global('global'),
  
  /// 规则模式：根据配置的规则决定哪些流量走代理
  rule('rule'),
  
  /// 直连模式：所有流量都直接连接，不经过代理服务器
  direct('direct');

  const ProxyMode(this.value);

  /// 枚举对应的字符串值
  final String value;

  /// 根据字符串值获取对应的枚举
  static ProxyMode fromString(String value) {
    return ProxyMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => ProxyMode.rule, // 默认返回规则模式
    );
  }

  @override
  String toString() => value;
}

/// 日志级别枚举定义
/// 定义了 Clash 日志记录的详细程度
enum LogLevel {
  /// 静默模式：不记录任何日志信息
  silent('silent'),
  
  /// 错误级别：只记录错误信息
  error('error'),
  
  /// 警告级别：记录错误和警告信息
  warning('warning'),
  
  /// 信息级别：记录错误、警告和一般信息
  info('info'),
  
  /// 调试级别：记录所有日志信息，包括详细的调试信息
  debug('debug');

  const LogLevel(this.value);

  /// 枚举对应的字符串值
  final String value;

  /// 根据字符串值获取对应的枚举
  static LogLevel fromString(String value) {
    return LogLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => LogLevel.info, // 默认返回信息级别
    );
  }

  @override
  String toString() => value;
}

import 'dns_settings.dart';
import 'port_settings.dart';
import 'rule_settings.dart';
import 'traffic_settings.dart';

/// FlClashSettings 类
/// 用于存储和管理 Clash 配置设置
class FlClashSettings {
  /// 构造函数
  const FlClashSettings({
    this.proxyMode = ProxyMode.rule,
    this.logLevel = LogLevel.info,
    this.port = 7890,
    this.socksPort = 7891,
    this.allowLan = false,
    this.externalController = '127.0.0.1:9090',
    this.secret = '',
    this.ipv6 = false,
    this.tproxyPort = 7892,
  });

  /// 代理模式配置
  /// 默认为规则模式
  final ProxyMode proxyMode;

  /// 日志级别配置
  /// 默认为信息级别
  final LogLevel logLevel;

  /// HTTP 代理端口
  /// 默认为 7890
  final int port;

  /// SOCKS 代理端口
  /// 默认为 7891
  final int socksPort;

  /// 是否允许局域网连接
  /// 默认为 false（不允许）
  final bool allowLan;

  /// 外部控制器地址
  /// 用于外部管理 Clash 配置
  final String externalController;

  /// 外部控制器密码
  /// 用于验证外部管理请求
  final String secret;

  /// 是否启用 IPv6
  /// 默认为 false
  final bool ipv6;

  /// TProxy 端口
  /// 用于透明代理
  final int tproxyPort;

  /// 端口设置 getter
  /// 返回端口配置实例
  PortSettings get ports {
    return PortSettings(
      socksPort: socksPort,
      httpPort: port,
      apiPort: 9090, // 使用默认值
      enableRedirect: false, // 使用默认值
    );
  }

  /// DNS设置 getter
  /// 返回DNS配置实例
  DNSSettings get dns {
    return const DNSSettings(
      enable: false,
      servers: [],
      fallback: [],
      strategy: 0,
      port: 53,
      enableIPv6: false,
      enableCache: true,
      cacheTimeout: 300,
    );
  }

  /// 规则设置 getter
  /// 返回规则配置实例
  RuleSettings get rules {
    return const RuleSettings(
      enable: false,
      rules: [],
      useUrlPayload: false,
      useDomainPayload: false,
    );
  }

  /// 流量设置 getter
  /// 返回流量配置实例
  TrafficSettings get traffic {
    return const TrafficSettings(
      maxSpeed: 0,
      bandwidthLimit: 0,
      throttle: false,
      bufferSize: 64,
      downloadSpeed: 0,
      uploadSpeed: 0,
      connectionTimeout: 5000,
      keepAlive: true,
    );
  }

  /// 局域网共享 getter
  /// 返回是否允许局域网连接
  bool get lanShare => allowLan;

  /// 代理模式 getter
  /// 返回代理模式配置
  ProxyMode get mode => proxyMode;

  /// 创建副本，允许部分字段更新
  FlClashSettings copyWith({
    ProxyMode? proxyMode,
    LogLevel? logLevel,
    int? port,
    int? socksPort,
    bool? allowLan,
    String? externalController,
    String? secret,
    bool? ipv6,
    int? tproxyPort,
    PortSettings? ports,
    DNSSettings? dns,
    RuleSettings? rules,
    TrafficSettings? traffic,
  }) {
    return FlClashSettings(
      proxyMode: proxyMode ?? this.proxyMode,
      logLevel: logLevel ?? this.logLevel,
      port: port ?? this.port,
      socksPort: socksPort ?? this.socksPort,
      allowLan: allowLan ?? this.allowLan,
      externalController: externalController ?? this.externalController,
      secret: secret ?? this.secret,
      ipv6: ipv6 ?? this.ipv6,
      tproxyPort: tproxyPort ?? this.tproxyPort,
    );
  }

  /// 转换为 Map 数据结构
  /// 用于 JSON 序列化或其他数据传输
  Map<String, dynamic> toMap() {
    return {
      'proxyMode': proxyMode.value,
      'logLevel': logLevel.value,
      'port': port,
      'socksPort': socksPort,
      'allowLan': allowLan,
      'externalController': externalController,
      'secret': secret,
      'ipv6': ipv6,
      'tproxyPort': tproxyPort,
      'ports': ports.toJson(),
      'dns': dns.toJson(),
      'rules': rules.toJson(),
      'traffic': traffic.toJson(),
    };
  }

  /// 从 Map 数据创建 FlClashSettings 实例
  /// 用于 JSON 反序列化
  factory FlClashSettings.fromMap(Map<String, dynamic> map) {
    return FlClashSettings(
      proxyMode: ProxyMode.fromString(map['proxyMode'] ?? 'rule'),
      logLevel: LogLevel.fromString(map['logLevel'] ?? 'info'),
      port: map['port'] ?? 7890,
      socksPort: map['socksPort'] ?? 7891,
      allowLan: map['allowLan'] ?? false,
      externalController: map['externalController'] ?? '127.0.0.1:9090',
      secret: map['secret'] ?? '',
      ipv6: map['ipv6'] ?? false,
      tproxyPort: map['tproxyPort'] ?? 7892,
    );
  }

  /// 转换为 JSON 字符串
  String toJson() => toMap().toString();

  /// 从 JSON 字符串创建实例
  factory FlClashSettings.fromJson(String source) =>
      FlClashSettings.fromMap(source);

  @override
  String toString() {
    return 'FlClashSettings{'
        'proxyMode: $proxyMode, '
        'logLevel: $logLevel, '
        'port: $port, '
        'socksPort: $socksPort, '
        'allowLan: $allowLan, '
        'externalController: $externalController, '
        'secret: $secret, '
        'ipv6: $ipv6, '
        'tproxyPort: $tproxyPort, '
        'ports: ${ports.portSummary}, '
        'mode: $mode, '
        'lanShare: $lanShare'
        '}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is FlClashSettings &&
        other.proxyMode == proxyMode &&
        other.logLevel == logLevel &&
        other.port == port &&
        other.socksPort == socksPort &&
        other.allowLan == allowLan &&
        other.externalController == externalController &&
        other.secret == secret &&
        other.ipv6 == ipv6 &&
        other.tproxyPort == tproxyPort &&
        other.ports == ports &&
        other.dns == dns &&
        other.rules == rules &&
        other.traffic == traffic;
  }

  @override
  int get hashCode {
    return Object.hash(
      proxyMode,
      logLevel,
      port,
      socksPort,
      allowLan,
      externalController,
      secret,
      ipv6,
      tproxyPort,
      ports,
      dns,
      rules,
      traffic,
    );
  }
}