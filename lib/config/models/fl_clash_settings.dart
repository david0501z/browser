/// FlClash设置类
class FlClashSettings {
  /// 配置文件名称
  final String configName;
  
  /// Clash核心设置
  final ClashCoreSettings clashCore;
  
  /// 代理列表
  final List<ProxyConfig> proxies;
  
  /// 代理组列表
  final List<ProxyGroupConfig> proxyGroups;
  
  /// 规则列表
  final List<RuleItem> rules;
  
  /// 规则提供者列表
  final List<RuleProvider> providers;
  
  /// DNS设置
  final DNSSettings dns;
  
  /// 端口设置
  final PortSettings ports;
  
  /// 流量统计设置
  final TrafficPerformanceSettings? traffic;
  
  /// 是否启用
  final bool enable;
  
  /// 是否自动启动
  final bool autoStart;
  
  /// 创建时间
  final DateTime createdAt;
  
  /// 更新时间
  final DateTime updatedAt;
  
  /// 使用统计
  final UsageStats? usageStats;

  const FlClashSettings({
    required this.configName,
    required this.clashCore,
    required this.proxies,
    this.proxyGroups = const [],
    this.rules = const [],
    this.providers = const [],
    required this.dns,
    required this.ports,
    this.traffic,
    this.enable = true,
    this.autoStart = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.usageStats,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// 从JSON创建
  factory FlClashSettings.fromJson(Map<String, dynamic> json) {
    return FlClashSettings(
      configName: json['configName'] ?? '',
      clashCore: ClashCoreSettings.fromJson(json['clashCore']),
      proxies: json['proxies'] != null 
          ? (json['proxies'] as List).map((proxy) => ProxyConfig.fromJson(proxy)).toList() 
          : [],
      proxyGroups: json['proxyGroups'] != null 
          ? (json['proxyGroups'] as List).map((group) => ProxyGroupConfig.fromJson(group)).toList() 
          : [],
      rules: json['rules'] != null 
          ? (json['rules'] as List).map((rule) => RuleItem.fromJson(rule)).toList() 
          : [],
      providers: json['providers'] != null 
          ? (json['providers'] as List).map((provider) => RuleProvider.fromJson(provider)).toList() 
          : [],
      dns: DNSSettings.fromJson(json['dns']),
      ports: PortSettings.fromJson(json['ports']),
      traffic: json['traffic'] != null 
          ? TrafficPerformanceSettings.fromJson(json['traffic']) 
          : null,
      enable: json['enable'] ?? true,
      autoStart: json['autoStart'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
      usageStats: json['usageStats'] != null 
          ? UsageStats.fromJson(json['usageStats']) 
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'configName': configName,
      'clashCore': clashCore.toJson(),
      'proxies': proxies.map((proxy) => proxy.toJson()).toList(),
      'proxyGroups': proxyGroups.map((group) => group.toJson()).toList(),
      'rules': rules.map((rule) => rule.toJson()).toList(),
      'providers': providers.map((provider) => provider.toJson()).toList(),
      'dns': dns.toJson(),
      'ports': ports.toJson(),
      'traffic': traffic?.toJson(),
      'enable': enable,
      'autoStart': autoStart,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'usageStats': usageStats?.toJson(),
    };
  }

  /// 复制并修改
  FlClashSettings copyWith({
    String? configName,
    ClashCoreSettings? clashCore,
    List<ProxyConfig>? proxies,
    List<ProxyGroupConfig>? proxyGroups,
    List<RuleItem>? rules,
    List<RuleProvider>? providers,
    DNSSettings? dns,
    PortSettings? ports,
    TrafficPerformanceSettings? traffic,
    bool? enable,
    bool? autoStart,
    DateTime? createdAt,
    DateTime? updatedAt,
    UsageStats? usageStats,
  }) {
    return FlClashSettings(
      configName: configName ?? this.configName,
      clashCore: clashCore ?? this.clashCore,
      proxies: proxies ?? this.proxies,
      proxyGroups: proxyGroups ?? this.proxyGroups,
      rules: rules ?? this.rules,
      providers: providers ?? this.providers,
      dns: dns ?? this.dns,
      ports: ports ?? this.ports,
      traffic: traffic ?? this.traffic,
      enable: enable ?? this.enable,
      autoStart: autoStart ?? this.autoStart,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      usageStats: usageStats ?? this.usageStats,
    );
  }

  /// 获取代理数量
  int get proxyCount => proxies.length;
  
  /// 获取代理组数量
  int get groupCount => proxyGroups.length;
  
  /// 获取规则数量
  int get ruleCount => rules.length;
  
  /// 获取提供者数量
  int get providerCount => providers.length;

  /// 检查配置是否有效
  bool get isValid {
    return configName.isNotEmpty &&
        clashCore != null &&
        proxies.isNotEmpty &&
        dns != null &&
        ports != null;
  }

  @override
  String toString() {
    return 'FlClashSettings{configName: $configName, proxies: $proxyCount, rules: $ruleCount, enable: $enable}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlClashSettings &&
        other.configName == configName &&
        other.clashCore == clashCore &&
        other.proxies == proxies &&
        other.proxyGroups == proxyGroups &&
        other.rules == rules &&
        other.providers == providers &&
        other.dns == dns &&
        other.ports == ports &&
        other.traffic == traffic &&
        other.enable == enable &&
        other.autoStart == autoStart &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.usageStats == usageStats;
  }

  @override
  int get hashCode {
    return configName.hashCode ^
        clashCore.hashCode ^
        proxies.hashCode ^
        proxyGroups.hashCode ^
        rules.hashCode ^
        providers.hashCode ^
        dns.hashCode ^
        ports.hashCode ^
        (traffic?.hashCode ?? 0) ^
        enable.hashCode ^
        autoStart.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        (usageStats?.hashCode ?? 0);
  }
}

/// 使用统计类
class UsageStats {
  /// 连接次数
  final int connectionCount;
  
  /// 使用时长（秒）
  final int totalUsageTime;
  
  /// 流量使用量
  final TrafficUsage totalTraffic;
  
  /// 最后使用时间
  final DateTime? lastUsed;
  
  /// 创建时间
  final DateTime createdAt;

  const UsageStats({
    this.connectionCount = 0,
    this.totalUsageTime = 0,
    required this.totalTraffic,
    this.lastUsed,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// 从JSON创建
  factory UsageStats.fromJson(Map<String, dynamic> json) {
    return UsageStats(
      connectionCount: json['connectionCount'] ?? 0,
      totalUsageTime: json['totalUsageTime'] ?? 0,
      totalTraffic: TrafficUsage.fromJson(json['totalTraffic']),
      lastUsed: json['lastUsed'] != null 
          ? DateTime.parse(json['lastUsed']) 
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'connectionCount': connectionCount,
      'totalUsageTime': totalUsageTime,
      'totalTraffic': totalTraffic.toJson(),
      'lastUsed': lastUsed?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// 流量使用量类
class TrafficUsage {
  /// 上行流量（字节）
  final int uploadBytes;
  
  /// 下行流量（字节）
  final int downloadBytes;

  const TrafficUsage({
    this.uploadBytes = 0,
    this.downloadBytes = 0,
  });

  /// 从JSON创建
  factory TrafficUsage.fromJson(Map<String, dynamic> json) {
    return TrafficUsage(
      uploadBytes: json['uploadBytes'] ?? 0,
      downloadBytes: json['downloadBytes'] ?? 0,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'uploadBytes': uploadBytes,
      'downloadBytes': downloadBytes,
    };
  }

  /// 获取总流量
  int get totalBytes => uploadBytes + downloadBytes;

  /// 格式化流量
  String formatBytes() {
    return TrafficPerformanceSettings.formatBytes(totalBytes);
  }

  @override
  String toString() {
    return 'TrafficUsage{upload: ${TrafficPerformanceSettings.formatBytes(uploadBytes)}, download: ${TrafficPerformanceSettings.formatBytes(downloadBytes)}}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrafficUsage &&
        other.uploadBytes == uploadBytes &&
        other.downloadBytes == downloadBytes;
  }

  @override
  int get hashCode {
    return uploadBytes.hashCode ^ downloadBytes.hashCode;
  }
}