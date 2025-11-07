/// Clash 核心设置类
class ClashCoreSettings {
  /// 获取HTTP端口
  int get port => ports.httpPort;
  
  /// 获取SOCKS端口
  int get socksPort => ports.socksPort;
  
  /// 获取透明代理端口
  int? get tproxyPort => ports.controllerPort;
  
  /// 代理模式
  final ProxyMode mode;
  
  /// 日志级别
  final LogLevel logLevel;
  
  /// 外部控制器地址
  final String externalController;
  
  /// 是否允许局域网
  final bool allowLan;
  
  /// 是否共享局域网
  final bool lanShare;
  
  /// 是否启用IPv6
  final bool ipv6;
  
  /// 端口设置
  final PortSettings ports;
  
  /// DNS设置
  final DNSSettings dns;
  
  /// 规则设置
  final RuleConfiguration rules;
  
  /// 流量统计设置
  final TrafficPerformanceSettings? traffic;
  
  /// 自定义配置
  final Map<String, dynamic> customSettings;

  const ClashCoreSettings({
    this.mode = ProxyMode.rule,
    this.logLevel = LogLevel.info,
    this.externalController = '127.0.0.1:9090',
    this.allowLan = false,
    this.lanShare = false,
    this.ipv6 = false,
    required this.ports,
    required this.dns,
    required this.rules,
    this.traffic,
    this.customSettings = const {},
  });

  /// 从JSON创建
  factory ClashCoreSettings.fromJson(Map<String, dynamic> json) {
    return ClashCoreSettings(
      mode: ProxyMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => ProxyMode.rule,
      ),
      logLevel: LogLevel.values.firstWhere(
        (e) => e.name == json['logLevel'],
        orElse: () => LogLevel.info,
      ),
      externalController: json['externalController'] ?? '127.0.0.1:9090',
      allowLan: json['allowLan'] ?? false,
      lanShare: json['lanShare'] ?? false,
      ipv6: json['ipv6'] ?? false,
      ports: PortSettings.fromJson(json['ports']),
      dns: DNSSettings.fromJson(json['dns']),
      rules: RuleConfiguration.fromJson(json['rules']),
      traffic: json['traffic'] != null 
          ? TrafficPerformanceSettings.fromJson(json['traffic']) 
          : null,
      customSettings: json['customSettings'] ?? {},
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'mode': mode.name,
      'logLevel': logLevel.name,
      'externalController': externalController,
      'allowLan': allowLan,
      'lanShare': lanShare,
      'ipv6': ipv6,
      'ports': ports.toJson(),
      'dns': dns.toJson(),
      'rules': rules.toJson(),
      'traffic': traffic?.toJson(),
      'customSettings': customSettings,
    };
  }

  /// 复制并修改
  ClashCoreSettings copyWith({
    ProxyMode? mode,
    LogLevel? logLevel,
    String? externalController,
    bool? allowLan,
    bool? lanShare,
    bool? ipv6,
    PortSettings? ports,
    DNSSettings? dns,
    RuleConfiguration? rules,
    TrafficPerformanceSettings? traffic,
    Map<String, dynamic>? customSettings,
  }) {
    return ClashCoreSettings(
      mode: mode ?? this.mode,
      logLevel: logLevel ?? this.logLevel,
      externalController: externalController ?? this.externalController,
      allowLan: allowLan ?? this.allowLan,
      lanShare: lanShare ?? this.lanShare,
      ipv6: ipv6 ?? this.ipv6,
      ports: ports ?? this.ports,
      dns: dns ?? this.dns,
      rules: rules ?? this.rules,
      traffic: traffic ?? this.traffic,
      customSettings: customSettings ?? this.customSettings,
    );
  }

  @override
  String toString() {
    return 'ClashCoreSettings{mode: $mode, logLevel: $logLevel, lanShare: $lanShare, ipv6: $ipv6, ports: $ports, dns: $dns, rules: $rules}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClashCoreSettings &&
        other.mode == mode &&
        other.logLevel == logLevel &&
        other.externalController == externalController &&
        other.allowLan == allowLan &&
        other.lanShare == lanShare &&
        other.ipv6 == ipv6 &&
        other.ports == ports &&
        other.dns == dns &&
        other.rules == rules &&
        other.traffic == traffic;
  }

  @override
  int get hashCode {
    return mode.hashCode ^
        logLevel.hashCode ^
        externalController.hashCode ^
        allowLan.hashCode ^
        lanShare.hashCode ^
        ipv6.hashCode ^
        ports.hashCode ^
        dns.hashCode ^
        rules.hashCode ^
        (traffic?.hashCode ?? 0);
  }
}