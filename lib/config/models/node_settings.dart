/// 节点设置类
class NodeSettings {
  /// 节点ID
  final String id;
  
  /// 节点名称
  final String name;
  
  /// 节点类型
  final ProxyType type;
  
  /// 服务器地址
  final String server;
  
  /// 服务器端口
  final int port;
  
  /// 节点配置
  final Map<String, dynamic> nodeConfig;
  
  /// 节点状态
  final NodeStatus status;
  
  /// 节点延迟
  final int? delay;
  
  /// 节点速度
  final int? speed;
  
  /// 节点位置
  final String? location;
  
  /// 是否启用
  final bool enable;
  
  /// 是否自动选择
  final bool autoSelect;
  
  /// 节点权重
  final int weight;

  const NodeSettings({
    required this.id,
    required this.name,
    required this.type,
    required this.server,
    required this.port,
    this.nodeConfig = const {},
    this.status = NodeStatus.unknown,
    this.delay,
    this.speed,
    this.location,
    this.enable = true,
    this.autoSelect = false,
    this.weight = 1,
  });

  /// 从JSON创建
  factory NodeSettings.fromJson(Map<String, dynamic> json) {
    return NodeSettings(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: ProxyType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ProxyType.socks5,
      ),
      server: json['server'] ?? '',
      port: json['port'] ?? 0,
      nodeConfig: json['nodeConfig'] ?? {},
      status: NodeStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => NodeStatus.unknown,
      ),
      delay: json['delay'],
      speed: json['speed'],
      location: json['location'],
      enable: json['enable'] ?? true,
      autoSelect: json['autoSelect'] ?? false,
      weight: json['weight'] ?? 1,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'server': server,
      'port': port,
      'nodeConfig': nodeConfig,
      'status': status.name,
      'delay': delay,
      'speed': speed,
      'location': location,
      'enable': enable,
      'autoSelect': autoSelect,
      'weight': weight,
    };
  }

  /// 复制并修改
  NodeSettings copyWith({
    String? id,
    String? name,
    ProxyType? type,
    String? server,
    int? port,
    Map<String, dynamic>? nodeConfig,
    NodeStatus? status,
    int? delay,
    int? speed,
    String? location,
    bool? enable,
    bool? autoSelect,
    int? weight,
  }) {
    return NodeSettings(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      server: server ?? this.server,
      port: port ?? this.port,
      nodeConfig: nodeConfig ?? this.nodeConfig,
      status: status ?? this.status,
      delay: delay ?? this.delay,
      speed: speed ?? this.speed,
      location: location ?? this.location,
      enable: enable ?? this.enable,
      autoSelect: autoSelect ?? this.autoSelect,
      weight: weight ?? this.weight,
    );
  }

  /// 获取节点描述
  String get description {
    final parts = <String>['$name ($server:$port)'];
    if (location != null) parts.add(location!);
    if (delay != null) parts.add('延迟: ${delay!}ms');
    if (speed != null) parts.add('速度: ${speed!}Mbps');
    return parts.join(' - ');
  }

  /// 检查节点是否可用
  bool get isAvailable {
    return enable && (status == NodeStatus.online || status == NodeStatus.unknown);
  }

  @override
  String toString() {
    return 'NodeSettings{name: $name, type: $type, server: $server:$port, status: $status}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NodeSettings &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.server == server &&
        other.port == port &&
        other.nodeConfig == nodeConfig &&
        other.status == status &&
        other.delay == delay &&
        other.speed == speed &&
        other.location == location &&
        other.enable == enable &&
        other.autoSelect == autoSelect &&
        other.weight == weight;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        server.hashCode ^
        port.hashCode ^
        nodeConfig.hashCode ^
        status.hashCode ^
        (delay?.hashCode ?? 0) ^
        (speed?.hashCode ?? 0) ^
        (location?.hashCode ?? 0) ^
        enable.hashCode ^
        autoSelect.hashCode ^
        weight.hashCode;
  }
}

/// 节点状态枚举
enum NodeStatus {
  /// 未知
  unknown,
  /// 在线
  online,
  /// 离线
  offline,
  /// 错误
  error,
  /// 检测中
  checking,
  /// 等待中
  waiting,
}