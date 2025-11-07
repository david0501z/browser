/// 代理配置类
class ProxyConfig {
  /// 代理名称
  final String name;
  
  /// 代理类型
  final ProxyType type;
  
  /// 服务器地址
  final String server;
  
  /// 服务器端口
  final int port;
  
  /// 用户名
  final String? username;
  
  /// 密码
  final String? password;
  
  /// 代理URL
  final String? proxyUrl;
  
  /// 是否启用
  final bool enable;
  
  /// 延迟
  final int? delay;
  
  /// 代理配置
  final Map<String, dynamic> config;

  const ProxyConfig({
    required this.name,
    required this.type,
    required this.server,
    required this.port,
    this.username,
    this.password,
    this.proxyUrl,
    this.enable = true,
    this.delay,
    this.config = const {},
  });

  /// 从JSON创建
  factory ProxyConfig.fromJson(Map<String, dynamic> json) {
    return ProxyConfig(
      name: json['name'] ?? '',
      type: ProxyType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ProxyType.socks5,
      ),
      server: json['server'] ?? '',
      port: json['port'] ?? 0,
      username: json['username'],
      password: json['password'],
      proxyUrl: json['proxyUrl'],
      enable: json['enable'] ?? true,
      delay: json['delay'],
      config: json['config'] ?? {},
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.name,
      'server': server,
      'port': port,
      'username': username,
      'password': password,
      'proxyUrl': proxyUrl,
      'enable': enable,
      'delay': delay,
      'config': config,
    };
  }

  /// 复制并修改
  ProxyConfig copyWith({
    String? name,
    ProxyType? type,
    String? server,
    int? port,
    String? username,
    String? password,
    String? proxyUrl,
    bool? enable,
    int? delay,
    Map<String, dynamic>? config,
  }) {
    return ProxyConfig(
      name: name ?? this.name,
      type: type ?? this.type,
      server: server ?? this.server,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      proxyUrl: proxyUrl ?? this.proxyUrl,
      enable: enable ?? this.enable,
      delay: delay ?? this.delay,
      config: config ?? this.config,
    );
  }

  @override
  String toString() {
    return 'ProxyConfig{name: $name, type: $type, server: $server:$port, enable: $enable}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProxyConfig &&
        other.name == name &&
        other.type == type &&
        other.server == server &&
        other.port == port &&
        other.username == username &&
        other.password == password &&
        other.proxyUrl == proxyUrl &&
        other.enable == enable &&
        other.delay == delay &&
        other.config == config;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        type.hashCode ^
        server.hashCode ^
        port.hashCode ^
        (username?.hashCode ?? 0) ^
        (password?.hashCode ?? 0) ^
        (proxyUrl?.hashCode ?? 0) ^
        enable.hashCode ^
        (delay?.hashCode ?? 0) ^
        config.hashCode;
  }
}

/// 代理组配置类
class ProxyGroupConfig {
  /// 组名称
  final String name;
  
  /// 组类型
  final ProxyGroupType type;
  
  /// 代理列表
  final List<String> proxies;
  
  /// URL测试
  final String? urlTest;
  
  /// 测试间隔
  final int? testInterval;
  
  /// 是否启用
  final bool enable;
  
  /// 策略选择
  final String? strategy;

  const ProxyGroupConfig({
    required this.name,
    required this.type,
    required this.proxies,
    this.urlTest,
    this.testInterval,
    this.enable = true,
    this.strategy,
  });

  /// 从JSON创建
  factory ProxyGroupConfig.fromJson(Map<String, dynamic> json) {
    return ProxyGroupConfig(
      name: json['name'] ?? '',
      type: ProxyGroupType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ProxyGroupType.select,
      ),
      proxies: json['proxies'] != null 
          ? List<String>.from(json['proxies']) 
          : [],
      urlTest: json['urlTest'],
      testInterval: json['testInterval'],
      enable: json['enable'] ?? true,
      strategy: json['strategy'],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.name,
      'proxies': proxies,
      'urlTest': urlTest,
      'testInterval': testInterval,
      'enable': enable,
      'strategy': strategy,
    };
  }

  @override
  String toString() {
    return 'ProxyGroupConfig{name: $name, type: $type, proxies: ${proxies.length}}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProxyGroupConfig &&
        other.name == name &&
        other.type == type &&
        other.proxies == proxies &&
        other.urlTest == urlTest &&
        other.testInterval == testInterval &&
        other.enable == enable &&
        other.strategy == strategy;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        type.hashCode ^
        proxies.hashCode ^
        (urlTest?.hashCode ?? 0) ^
        (testInterval?.hashCode ?? 0) ^
        enable.hashCode ^
        (strategy?.hashCode ?? 0);
  }
}