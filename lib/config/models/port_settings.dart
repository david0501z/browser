/// 端口设置类
class PortSettings {
  /// HTTP代理端口
  final int httpPort;
  
  /// SOCKS代理端口
  final int socksPort;
  
  /// 混合代理端口
  final int? mixedPort;
  
  /// 外部控制端口
  final int? controllerPort;
  
  /// 最小端口号
  static const int minPort = 1024;
  
  /// 最大端口号
  static const int maxPort = 65535;

  /// 获取HTTP端口
  int get port => ports.httpPort;
  
  /// 获取SOCKS端口
  int get socksPort => ports.socksPort;
  
  /// 获取透明代理端口
  int? get tproxyPort => ports.controllerPort;
  
  /// HTTP代理端口
  final int httpPort;
  
  /// SOCKS代理端口
  final int socksPort;
  
  /// 混合代理端口
  final int? mixedPort;
  
  /// 外部控制端口
  final int? controllerPort;
  
  /// 最小端口号
  static const int minPort = 1024;
  
  /// 最大端口号
  static const int maxPort = 65535;

  const PortSettings({
    this.httpPort = 7890,
    this.socksPort = 7891,
    this.mixedPort,
    this.controllerPort,
  });

  /// 验证端口号是否有效
  static bool isValidPort(int port) {
    return port >= minPort && port <= maxPort;
  }

  /// 获取所有端口列表
  List<int> get allPorts {
    final ports = <int>{httpPort, socksPort};
    if (mixedPort != null) ports.add(mixedPort!);
    if (controllerPort != null) ports.add(controllerPort!);
    return ports.toList()..sort();
  }

  /// 检查端口是否冲突
  bool hasPortConflict() {
    final ports = <int>{httpPort, socksPort};
    if (mixedPort != null) ports.add(mixedPort!);
    if (controllerPort != null) ports.add(controllerPort!);
    return ports.length != 4; // 如果去重后长度不等于4，说明有重复
  }

  /// 从JSON创建
  factory PortSettings.fromJson(Map<String, dynamic> json) {
    return PortSettings(
      httpPort: json['httpPort'] ?? 7890,
      socksPort: json['socksPort'] ?? 7891,
      mixedPort: json['mixedPort'],
      controllerPort: json['controllerPort'],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'httpPort': httpPort,
      'socksPort': socksPort,
      'mixedPort': mixedPort,
      'controllerPort': controllerPort,
    };
  }

  /// 复制并修改
  PortSettings copyWith({
    int? httpPort,
    int? socksPort,
    int? mixedPort,
    int? controllerPort,
  }) {
    return PortSettings(
      httpPort: httpPort ?? this.httpPort,
      socksPort: socksPort ?? this.socksPort,
      mixedPort: mixedPort ?? this.mixedPort,
      controllerPort: controllerPort ?? this.controllerPort,
    );
  }

  @override
  String toString() {
    return 'PortSettings{httpPort: $httpPort, socksPort: $socksPort, mixedPort: $mixedPort, controllerPort: $controllerPort}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PortSettings &&
        other.httpPort == httpPort &&
        other.socksPort == socksPort &&
        other.mixedPort == mixedPort &&
        other.controllerPort == controllerPort;
  }

  @override
  int get hashCode {
    return httpPort.hashCode ^
        socksPort.hashCode ^
        (mixedPort?.hashCode ?? 0) ^
        (controllerPort?.hashCode ?? 0);
  }
}