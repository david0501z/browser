/// 流量统计模型
/// 定义代理服务的流量监控和统计功能

import 'package:freezed_annotation/freezed_annotation.dart';

part 'traffic_stats.freezed.dart';
part 'traffic_stats.g.dart';

/// 流量统计数据
@freezed
class TrafficStats with _$TrafficStats {
  const factory TrafficStats({
    /// 当前连接状态
    @Default(false) bool isConnected,
    /// 上行流量（字节）
    @Default(0) int uploadBytes,
    /// 下行流量（字节）
    @Default(0) int downloadBytes,
    /// 总流量（字节）
    @Default(0) int totalBytes,
    /// 当前上传速度（字节/秒）
    @Default(0) int uploadSpeed,
    /// 当前下载速度（字节/秒）
    @Default(0) int downloadSpeed,
    /// 平均上传速度（字节/秒）
    @Default(0) int avgUploadSpeed,
    /// 平均下载速度（字节/秒）
    @Default(0) int avgDownloadSpeed,
    /// 连接持续时间（秒）
    @Default(0) int connectionTime,
    /// 连接次数
    @Default(0) int connectionCount,
    /// 连接成功率（百分比）
    @Default(0.0) double connectionSuccessRate,
    /// 错误次数
    @Default(0) int errorCount,
    /// 最后更新时间
    @DateTimeConverter() @Default(DateTime.now()) DateTime lastUpdateTime,
    /// 详细统计信息
    @Default({}) Map<String, dynamic> details,
  }) = _TrafficStats;
  
  factory TrafficStats.fromJson(Map<String, dynamic> json) => _$TrafficStatsFromJson(json);
}

/// 流量历史记录
@freezed
class TrafficHistory with _$TrafficHistory {
  const factory TrafficHistory({
    /// 记录ID
    required String id,
    /// 时间戳
    @DateTimeConverter() required DateTime timestamp,
    /// 上行流量
    required int uploadBytes,
    /// 下行流量
    required int downloadBytes,
    /// 总流量
    required int totalBytes,
    /// 上行速度
    required int uploadSpeed,
    /// 下行速度
    required int downloadSpeed,
    /// 连接时长
    required int connectionTime,
    /// 节点ID
    required String nodeId,
    /// 节点名称
    required String nodeName,
    /// 记录类型
    required RecordType recordType,
  }) = _TrafficHistory;
  
  factory TrafficHistory.fromJson(Map<String, dynamic> json) => _$TrafficHistoryFromJson(json);
}

/// 记录类型
enum RecordType {
  /// 实时记录
  realtime,
  /// 小时汇总
  hourly,
  /// 日汇总
  daily,
  /// 月汇总
  monthly,
}

/// 流量警告配置
@freezed
class TrafficAlertConfig with _$TrafficAlertConfig {
  const factory TrafficAlertConfig({
    /// 是否启用流量警告
    @Default(false) bool enableAlert,
    /// 流量警告阈值（MB）
    @Default(1000) int threshold,
    /// 警告类型
    @Default(AlertType.total) AlertType alertType,
    /// 警告级别
    @Default(AlertLevel.warning) AlertLevel alertLevel,
    /// 是否启用自动断开
    @Default(false) bool autoDisconnect,
    /// 重置周期
    @Default(AlertReset.daily) AlertReset resetCycle,
  }) = _TrafficAlertConfig;
  
  factory TrafficAlertConfig.fromJson(Map<String, dynamic> json) => _$TrafficAlertConfigFromJson(json);
}

/// 警告类型
enum AlertType {
  /// 总量警告
  total,
  /// 上行警告
  upload,
  /// 下行警告
  download,
}

/// 警告级别
enum AlertLevel {
  /// 提示
  info,
  /// 警告
  warning,
  /// 严重
  critical,
}

/// 重置周期
enum AlertReset {
  /// 不重置
  never,
  /// 每日重置
  daily,
  /// 每周重置
  weekly,
  /// 每月重置
  monthly,
}

/// 流量监控器
class TrafficMonitor {
  static const int _speedCalculationInterval = 1000; // 1秒;
  static const int _historyRetentionDays = 30;
  
  final List<TrafficRecord> _records = [];
  final DateTime _startTime = DateTime.now();
  int _lastUploadBytes = 0;
  int _lastDownloadBytes = 0;
  
  /// 开始监控
  void startMonitoring() {
    // 启动监控逻辑
  }
  
  /// 停止监控
  void stopMonitoring() {
    // 停止监控逻辑
  }
  
  /// 获取当前流量统计
  TrafficStats getCurrentStats() {
    // 计算当前统计信息
    return TrafficStats.empty();
  }
  
  /// 获取流量历史
  List<TrafficHistory> getTrafficHistory({
    DateTime? startTime,
    DateTime? endTime,
    RecordType? recordType,
  }) {
    var filtered = _records;
    
    if (startTime != null) {
      filtered = filtered.where((record) => record.timestamp.isAfter(startTime)).toList();
    }
    
    if (endTime != null) {
      filtered = filtered.where((record) => record.timestamp.isBefore(endTime)).toList();
    }
    
    return filtered.map((record) => TrafficHistory(
      id: record.id,
      timestamp: record.timestamp,
      uploadBytes: record.uploadBytes,
      downloadBytes: record.downloadBytes,
      totalBytes: record.uploadBytes + record.downloadBytes,
      uploadSpeed: record.uploadSpeed,
      downloadSpeed: record.downloadSpeed,
      connectionTime: record.connectionTime,
      nodeId: record.nodeId,
      nodeName: record.nodeName,
      recordType: RecordType.realtime,
    )).toList();
  }
  
  /// 添加流量记录
  void addRecord(TrafficRecord record) {
    _records.add(record);
    _cleanOldRecords();
  }
  
  /// 清理旧记录
  void _cleanOldRecords() {
    final cutoff = DateTime.now().subtract(Duration(days: _historyRetentionDays));
    _records.removeWhere((record) => record.timestamp.isBefore(cutoff));
  }
}

/// 流量记录
class TrafficRecord {
  final String id;
  final DateTime timestamp;
  final int uploadBytes;
  final int downloadBytes;
  final int uploadSpeed;
  final int downloadSpeed;
  final int connectionTime;
  final String nodeId;
  final String nodeName;
  
  TrafficRecord({
    required this.id,
    required this.timestamp,
    required this.uploadBytes,
    required this.downloadBytes,
    required this.uploadSpeed,
    required this.downloadSpeed,
    required this.connectionTime,
    required this.nodeId,
    required this.nodeName,
  });
}

/// 流量格式化工具
class TrafficFormatter {
  static const int _kb = 1024;
  static const int _mb = _kb * 1024;
  static const int _gb = _mb * 1024;
  static const int _tb = _gb * 1024;
  
  /// 格式化字节数
  static String formatBytes(int bytes) {
    if (bytes < _kb) {
      return '$bytes B';
    } else if (bytes < _mb) {
      return '${(bytes / _kb).toStringAsFixed(2)} KB';
    } else if (bytes < _gb) {
      return '${(bytes / _mb).toStringAsFixed(2)} MB';
    } else if (bytes < _tb) {
      return '${(bytes / _gb).toStringAsFixed(2)} GB';
    } else {
      return '${(bytes / _tb).toStringAsFixed(2)} TB';
    }
  }
  
  /// 格式化速度
  static String formatSpeed(int bytesPerSecond) {
    return '${formatBytes(bytesPerSecond)}/s';
  }
  
  /// 格式化持续时间
  static String formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds}秒';
    } else if (seconds < 3600) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return '${minutes}分${remainingSeconds}秒';
    } else {
      final hours = seconds ~/ 3600;
      final remainingMinutes = (seconds % 3600) ~/ 60;
      final remainingSeconds = seconds % 60;
      return '${hours}时${remainingMinutes}分${remainingSeconds}秒';
    }
  }
}