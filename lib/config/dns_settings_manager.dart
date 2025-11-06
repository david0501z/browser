/// DNS服务器类型枚举
/// 
/// 定义了DNS服务器的不同类型，包括系统DNS、自定义DNS以及基于加密协议的DNS
enum DNSServerType {
  /// 系统DNS - 使用系统默认的DNS服务器
  system('system'),
  
  /// 自定义DNS - 用户自定义的传统DNS服务器
  custom('custom'),
  
  /// DNS over HTTPS (DoH) - 基于HTTPS协议的加密DNS
  doh('doh'),
  
  /// DNS over TLS (DoT) - 基于TLS协议的加密DNS
  dot('dot');

  const DNSServerType(this.value);
  final String value;

  /// 获取枚举值的字符串表示
  @override
  String toString() => value;
}

/// DNS协议类型枚举
/// 
/// 定义了DNS传输使用的不同协议类型
enum DNSProtocolType {
  /// UDP协议 - 最常用的DNS传输协议
  udp('udp'),
  
  /// TCP协议 - 用于大数据包的DNS传输
  tcp('tcp'),
  
  /// DNS over TLS (DoT) - 基于TLS加密的DNS协议
  dot('dot'),
  
  /// DNS over HTTPS (DoH) - 基于HTTPS加密的DNS协议
  doh('doh');

  const DNSProtocolType(this.value);
  final String value;

  /// 获取枚举值的字符串表示
  @override
  String toString() => value;
}

/// DNS服务器配置类
/// 
/// 包含DNS服务器的所有配置信息，包括服务器地址、协议类型、端口等
class DNSServerConfig {
  /// 服务器ID
  final String id;
  
  /// 服务器名称
  final String name;
  
  /// 服务器地址（IP地址或域名）
  final String server;
  
  /// 端口号
  final int? port;
  
  /// DNS服务器类型
  final DNSServerType type;
  
  /// DNS协议类型
  final DNSProtocolType protocol;
  
  /// DoH/DoT的URL地址（仅在使用DoH/DoT协议时需要）
  final String? url;
  
  /// 是否启用
  final bool enabled;
  
  /// 优先级（数值越小优先级越高）
  final int priority;
  
  /// 额外选项
  final Map<String, dynamic>? options;

  /// 构造函数
  const DNSServerConfig({
    required this.id,
    required this.name,
    required this.server,
    this.port,
    required this.type,
    required this.protocol,
    this.url,
    this.enabled = true,
    this.priority = 100,
    this.options,
  });

  /// 创建系统DNS配置
  factory DNSServerConfig.system({
    String? id,
    String name = 'System DNS',
    String server = '8.8.8.8',
    int? port,
  }) {
    return DNSServerConfig(
      id: id ?? 'system_dns_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      server: server,
      port: port ?? 53,
      type: DNSServerType.system,
      protocol: DNSProtocolType.udp,
      priority: 50,
    );
  }

  /// 创建自定义DNS配置
  factory DNSServerConfig.custom({
    String? id,
    required String name,
    required String server,
    int? port,
    DNSProtocolType protocol = DNSProtocolType.udp,
    int priority = 100,
  }) {
    return DNSServerConfig(
      id: id ?? 'custom_dns_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      server: server,
      port: port ?? (protocol == DNSProtocolType.udp ? 53 : 443),
      type: DNSServerType.custom,
      protocol: protocol,
      priority: priority,
    );
  }

  /// 创建DoH DNS配置
  factory DNSServerConfig.doh({
    String? id,
    required String name,
    required String url,
    int priority = 80,
  }) {
    return DNSServerConfig(
      id: id ?? 'doh_dns_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      server: '', // DoH使用URL而不是server
      url: url,
      type: DNSServerType.doh,
      protocol: DNSProtocolType.doh,
      priority: priority,
    );
  }

  /// 创建DoT DNS配置
  factory DNSServerConfig.dot({
    String? id,
    required String name,
    required String server,
    int? port,
    int priority = 80,
  }) {
    return DNSServerConfig(
      id: id ?? 'dot_dns_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      server: server,
      port: port ?? 853,
      type: DNSServerType.dot,
      protocol: DNSProtocolType.dot,
      priority: priority,
    );
  }

  /// 复制配置并修改指定属性
  DNSServerConfig copyWith({
    String? id,
    String? name,
    String? server,
    int? port,
    DNSServerType? type,
    DNSProtocolType? protocol,
    String? url,
    bool? enabled,
    int? priority,
    Map<String, dynamic>? options,
  }) {
    return DNSServerConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      server: server ?? this.server,
      port: port ?? this.port,
      type: type ?? this.type,
      protocol: protocol ?? this.protocol,
      url: url ?? this.url,
      enabled: enabled ?? this.enabled,
      priority: priority ?? this.priority,
      options: options ?? this.options,
    );
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'server': server,
      'port': port,
      'type': type.value,
      'protocol': protocol.value,
      'url': url,
      'enabled': enabled,
      'priority': priority,
      'options': options,
    };
  }

  /// 从JSON格式创建配置
  factory DNSServerConfig.fromJson(Map<String, dynamic> json) {
    return DNSServerConfig(
      id: json['id'] as String? ?? 'dns_${DateTime.now().millisecondsSinceEpoch}',
      name: json['name'] as String,
      server: json['server'] as String,
      port: json['port'] as int?,
      type: DNSServerType.values.firstWhere(
        (e) => e.value == json['type'],
        orElse: () => DNSServerType.custom,
      ),
      protocol: DNSProtocolType.values.firstWhere(
        (e) => e.value == json['protocol'],
        orElse: () => DNSProtocolType.udp,
      ),
      url: json['url'] as String?,
      enabled: json['enabled'] as bool? ?? true,
      priority: json['priority'] as int? ?? 100,
      options: json['options'] as Map<String, dynamic>?,
    );
  }

  /// 判断是否为加密DNS（DoH/DoT）
  bool get isEncrypted => type == DNSServerType.doh || type == DNSServerType.dot;

  /// 获取完整的服务器地址（包含端口）
  String get fullAddress {
    if (type == DNSServerType.doh && url != null) {
      return url!;
    }
    final portStr = port != null ? ':$port' : '';
    return '$server$portStr';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DNSServerConfig &&
        other.id == id &&
        other.name == name &&
        other.server == server &&
        other.port == port &&
        other.type == type &&
        other.protocol == protocol &&
        other.url == url &&
        other.enabled == enabled &&
        other.priority == priority;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      server,
      port,
      type,
      protocol,
      url,
      enabled,
      priority,
    );
  }

  @override
  String toString() {
    return 'DNSServerConfig{id: $id, name: $name, server: $fullAddress, type: $type, protocol: $protocol, enabled: $enabled, priority: $priority}';
  }
}

/// DNS设置管理器类
/// 
/// 负责管理DNS服务器配置的添加、删除、修改和查询操作
class DNSSettingsManager {
  static DNSSettingsManager? _instance;
  static DNSSettingsManager get instance => _instance ??= DNSSettingsManager._();

  DNSSettingsManager._();

  /// DNS服务器配置列表
  final List<DNSServerConfig> _configs = [];

  /// 获取所有配置
  List<DNSServerConfig> get allConfigs => List.unmodifiable(_configs);

  /// 获取当前DNS设置（获取启用的服务器）
  List<DNSServerConfig> get settings {
    return enabledConfigs;
  }

  /// 获取启用的服务器（为兼容旧版本）
  List<DNSServerConfig> get enabledServers => enabledConfigs;

  /// 获取启用的配置（按优先级排序）
  List<DNSServerConfig> get enabledConfigs {
    return _configs
        .where((config) => config.enabled)
        .toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
  }

  /// 获取特定类型的配置
  List<DNSServerConfig> getConfigsByType(DNSServerType type) {
    return _configs
        .where((config) => config.type == type)
        .toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
  }

  /// 获取加密DNS配置（DoH/DoT）
  List<DNSServerConfig> get encryptedConfigs {
    return _configs
        .where((config) => config.isEncrypted)
        .toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
  }

  /// 添加DNS配置
  /// 
  /// [config] 要添加的DNS配置
  /// 返回添加是否成功
  bool addConfig(DNSServerConfig config) {
    // 检查配置是否已存在（基于名称和服务器地址）
    final exists = _configs.any(
      (existing) =>
          existing.name == config.name ||
          (existing.server == config.server &&
              existing.port == config.port &&
              existing.type == config.type),
    );

    if (!exists) {
      _configs.add(config);
      return true;
    }
    return false;
  }

  /// 添加DNS服务器（别名方法）
  bool addServer(DNSServerConfig server) {
    return addConfig(server);
  }

  /// 初始化DNS设置
  Future<void> initialize() async {
    addDefaultPublicDNS();
  }

  /// 应用预设配置
  Future<void> applyPreset(String presetName) async {
    switch (presetName.toLowerCase()) {
      case 'secure':
        _applySecurePreset();
        break;
      case 'balanced':
        _applyBalancedPreset();
        break;
      case 'fast':
        _applyFastPreset();
        break;
      default:
        throw ArgumentError('未知的预设配置: $presetName');
    }
  }

  /// 获取最优DNS服务器
  DNSServerConfig? getOptimalDNSServer() {
    final enabled = enabledConfigs;
    if (enabled.isEmpty) return null;
    
    // 简单选择优先级最高的服务器
    return enabled.first;
  }

  /// 根据索引移除DNS配置
  /// 
  /// [index] 配置索引
  /// 返回移除是否成功
  bool removeConfigAt(int index) {
    if (index >= 0 && index < _configs.length) {
      _configs.removeAt(index);
      return true;
    }
    return false;
  }

  /// 根据配置移除DNS配置
  /// 
  /// [config] 要移除的配置
  /// 返回移除是否成功
  bool removeConfig(DNSServerConfig config) {
    return _configs.remove(config);
  }

  /// 根据名称移除DNS配置
  /// 
  /// [name] 配置名称
  /// 返回移除是否成功
  bool removeConfigByName(String name) {
    return _configs.removeWhere((config) => config.name == name) > 0;
  }

  /// 更新DNS配置
  /// 
  /// [index] 配置索引
  /// [newConfig] 新的配置
  /// 返回更新是否成功
  bool updateConfig(int index, DNSServerConfig newConfig) {
    if (index >= 0 && index < _configs.length) {
      _configs[index] = newConfig;
      return true;
    }
    return false;
  }

  /// 根据名称更新DNS配置
  /// 
  /// [name] 配置名称
  /// [newConfig] 新的配置
  /// 返回更新是否成功
  bool updateConfigByName(String name, DNSServerConfig newConfig) {
    final index = _configs.indexWhere((config) => config.name == name);
    if (index != -1) {
      _configs[index] = newConfig;
      return true;
    }
    return false;
  }

  /// 启用/禁用配置
  /// 
  /// [index] 配置索引
  /// [enabled] 是否启用
  /// 返回操作是否成功
  bool setConfigEnabled(int index, bool enabled) {
    if (index >= 0 && index < _configs.length) {
      _configs[index] = _configs[index].copyWith(enabled: enabled);
      return true;
    }
    return false;
  }

  /// 根据名称启用/禁用配置
  /// 
  /// [name] 配置名称
  /// [enabled] 是否启用
  /// 返回操作是否成功
  bool setConfigEnabledByName(String name, bool enabled) {
    final index = _configs.indexWhere((config) => config.name == name);
    if (index != -1) {
      _configs[index] = _configs[index].copyWith(enabled: enabled);
      return true;
    }
    return false;
  }

  /// 设置配置优先级
  /// 
  /// [index] 配置索引
  /// [priority] 新优先级
  /// 返回操作是否成功
  bool setConfigPriority(int index, int priority) {
    if (index >= 0 && index < _configs.length) {
      _configs[index] = _configs[index].copyWith(priority: priority);
      return true;
    }
    return false;
  }

  /// 根据名称设置配置优先级
  /// 
  /// [name] 配置名称
  /// [priority] 新优先级
  /// 返回操作是否成功
  bool setConfigPriorityByName(String name, int priority) {
    final index = _configs.indexWhere((config) => config.name == name);
    if (index != -1) {
      _configs[index] = _configs[index].copyWith(priority: priority);
      return true;
    }
    return false;
  }

  /// 获取指定索引的配置
  /// 
  /// [index] 配置索引
  /// 返回配置对象，如果索引无效则返回null
  DNSServerConfig? getConfig(int index) {
    if (index >= 0 && index < _configs.length) {
      return _configs[index];
    }
    return null;
  }

  /// 根据名称获取配置
  /// 
  /// [name] 配置名称
  /// 返回配置对象，如果未找到则返回null
  DNSServerConfig? getConfigByName(String name) {
    try {
      return _configs.firstWhere((config) => config.name == name);
    } catch (e) {
      return null;
    }
  }

  /// 获取主要DNS配置（优先级最高的启用配置）
  /// 
  /// 返回主要DNS配置，如果未找到启用配置则返回null
  DNSServerConfig? getPrimaryConfig() {
    final enabled = enabledConfigs;
    if (enabled.isNotEmpty) {
      return enabled.first;
    }
    return null;
  }

  /// 清理所有配置
  void clearAllConfigs() {
    _configs.clear();
  }

  /// 添加默认的公共DNS服务器
  void addDefaultPublicDNS() {
    // Google DNS
    addConfig(DNSServerConfig.custom(
      name: 'Google DNS',
      server: '8.8.8.8',
      port: 53,
      type: DNSServerType.custom,
      protocol: DNSProtocolType.udp,
      priority: 10,
    ));

    // Cloudflare DNS
    addConfig(DNSServerConfig.custom(
      name: 'Cloudflare DNS',
      server: '1.1.1.1',
      port: 53,
      type: DNSServerType.custom,
      protocol: DNSProtocolType.udp,
      priority: 20,
    ));

    // Google DoH
    addConfig(DNSServerConfig.doh(
      name: 'Google DoH',
      url: 'https://dns.google/dns-query',
      priority: 30,
    ));

    // Cloudflare DoH
    addConfig(DNSServerConfig.doh(
      name: 'Cloudflare DoH',
      url: 'https://cloudflare-dns.com/dns-query',
      priority: 40,
    ));
  }

  /// 验证配置是否有效
  /// 
  /// [config] 要验证的配置
  /// 返回验证结果，如果有效返回null，否则返回错误信息
  String? validateConfig(DNSServerConfig config) {
    if (config.name.isEmpty) {
      return '配置名称不能为空';
    }

    if (config.server.isEmpty && config.type != DNSServerType.doh) {
      return '服务器地址不能为空';
    }

    if (config.port != null && (config.port! < 1 || config.port! > 65535)) {
      return '端口号必须在1-65535之间';
    }

    if (config.priority < 0) {
      return '优先级不能为负数';
    }

    if (config.type == DNSServerType.doh && config.url == null) {
      return 'DoH配置必须提供URL';
    }

    if (config.type == DNSServerType.doh && config.url != null) {
      try {
        Uri.parse(config.url!);
      } catch (e) {
        return 'URL格式不正确';
      }
    }

    return null;
  }

  /// 获取配置数量
  int get configCount => _configs.length;

  /// 获取启用的配置数量
  int get enabledConfigCount => _configs.where((c) => c.enabled).length;

  /// 应用安全预设配置
  void _applySecurePreset() {
    // 禁用所有非加密DNS
    for (final config in _configs) {
      if (!config.isEncrypted) {
        _configs[_configs.indexOf(config)] = config.copyWith(enabled: false);
      }
    }
  }

  /// 应用平衡预设配置
  void _applyBalancedPreset() {
    // 启用加密DNS，保留一些传统DNS作为备选
    for (final config in _configs) {
      if (config.isEncrypted) {
        _configs[_configs.indexOf(config)] = config.copyWith(enabled: true);
      } else {
        _configs[_configs.indexOf(config)] = config.copyWith(enabled: config.priority < 50);
      }
    }
  }

  /// 应用快速预设配置
  void _applyFastPreset() {
    // 优先启用低延迟的DNS服务器
    for (final config in _configs) {
      final isFast = config.priority < 50 || config.isEncrypted;
      _configs[_configs.indexOf(config)] = config.copyWith(enabled: isFast);
    }
  }

  @override
  String toString() {
    return 'DNSSettingsManager(configs: ${_configs.length}, enabled: $enabledConfigCount)';
  }
}