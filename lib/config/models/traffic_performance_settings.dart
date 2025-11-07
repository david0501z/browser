/// 流量性能设置类
class TrafficPerformanceSettings {
  /// 是否启用流量统计
  final bool enable;
  
  /// 是否启用历史记录
  final bool enableHistory;
  
  /// 是否实时统计
  final bool realTime;
  
  /// 统计间隔（秒）
  final int interval;
  
  /// 最大历史记录数量
  final int maxHistory;
  
  /// 是否启用流量限制
  final bool enableLimit;
  
  /// 上行速度限制 (bytes/s)
  final int? uploadLimit;
  
  /// 下行速度限制 (bytes/s)
  final int? downloadLimit;
  
  /// 是否启用连接统计
  final bool enableConnections;
  
  /// 最大连接数
  final int? maxConnections;
  
  /// 性能监控间隔
  final int performanceInterval;

  const TrafficPerformanceSettings({
    this.enable = true,
    this.enableHistory = true,
    this.realTime = true,
    this.interval = 1000,
    this.maxHistory = 1000,
    this.enableLimit = false,
    this.uploadLimit,
    this.downloadLimit,
    this.enableConnections = true,
    this.maxConnections,
    this.performanceInterval = 5000,
  });

  /// 格式化字节数
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  /// 格式化速度
  static String formatSpeed(int bytesPerSecond) {
    return '${formatBytes(bytesPerSecond)}/s';
  }

  /// 从JSON创建
  factory TrafficPerformanceSettings.fromJson(Map<String, dynamic> json) {
    return TrafficPerformanceSettings(
      enable: json['enable'] ?? true,
      enableHistory: json['enableHistory'] ?? true,
      realTime: json['realTime'] ?? true,
      interval: json['interval'] ?? 1000,
      maxHistory: json['maxHistory'] ?? 1000,
      enableLimit: json['enableLimit'] ?? false,
      uploadLimit: json['uploadLimit'],
      downloadLimit: json['downloadLimit'],
      enableConnections: json['enableConnections'] ?? true,
      maxConnections: json['maxConnections'],
      performanceInterval: json['performanceInterval'] ?? 5000,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'enable': enable,
      'enableHistory': enableHistory,
      'realTime': realTime,
      'interval': interval,
      'maxHistory': maxHistory,
      'enableLimit': enableLimit,
      'uploadLimit': uploadLimit,
      'downloadLimit': downloadLimit,
      'enableConnections': enableConnections,
      'maxConnections': maxConnections,
      'performanceInterval': performanceInterval,
    };
  }

  /// 复制并修改
  TrafficPerformanceSettings copyWith({
    bool? enable,
    bool? enableHistory,
    bool? realTime,
    int? interval,
    int? maxHistory,
    bool? enableLimit,
    int? uploadLimit,
    int? downloadLimit,
    bool? enableConnections,
    int? maxConnections,
    int? performanceInterval,
  }) {
    return TrafficPerformanceSettings(
      enable: enable ?? this.enable,
      enableHistory: enableHistory ?? this.enableHistory,
      realTime: realTime ?? this.realTime,
      interval: interval ?? this.interval,
      maxHistory: maxHistory ?? this.maxHistory,
      enableLimit: enableLimit ?? this.enableLimit,
      uploadLimit: uploadLimit ?? this.uploadLimit,
      downloadLimit: downloadLimit ?? this.downloadLimit,
      enableConnections: enableConnections ?? this.enableConnections,
      maxConnections: maxConnections ?? this.maxConnections,
      performanceInterval: performanceInterval ?? this.performanceInterval,
    );
  }

  /// 检查是否有速度限制
  bool get hasSpeedLimit => uploadLimit != null || downloadLimit != null;

  @override
  String toString() {
    return 'TrafficPerformanceSettings{enable: $enable, realTime: $realTime, interval: $interval}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrafficPerformanceSettings &&
        other.enable == enable &&
        other.enableHistory == enableHistory &&
        other.realTime == realTime &&
        other.interval == interval &&
        other.maxHistory == maxHistory &&
        other.enableLimit == enableLimit &&
        other.uploadLimit == uploadLimit &&
        other.downloadLimit == downloadLimit &&
        other.enableConnections == enableConnections &&
        other.maxConnections == maxConnections &&
        other.performanceInterval == performanceInterval;
  }

  @override
  int get hashCode {
    return enable.hashCode ^
        enableHistory.hashCode ^
        realTime.hashCode ^
        interval.hashCode ^
        maxHistory.hashCode ^
        enableLimit.hashCode ^
        (uploadLimit?.hashCode ?? 0) ^
        (downloadLimit?.hashCode ?? 0) ^
        enableConnections.hashCode ^
        (maxConnections?.hashCode ?? 0) ^
        performanceInterval.hashCode;
  }
}