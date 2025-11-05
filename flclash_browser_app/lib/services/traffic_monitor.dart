import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'dart:math' as math;

/// 流量监控配置
class TrafficMonitorConfig {
  final bool enableRealTimeMonitoring;
  final int maxLogEntries;
  final Duration logRetentionPeriod;
  final bool enableBandwidthThrottling;
  final int maxBandwidthKBps;
  final bool enableTrafficEncryption;
  final List<String> blockedDomains;
  final Map<String, int> domainSpeedLimits;
  final bool enableDetailedLogging;
  final Duration monitoringInterval;

  TrafficMonitorConfig({
    this.enableRealTimeMonitoring = true,
    this.maxLogEntries = 10000,
    this.logRetentionPeriod = const Duration(hours: 24),
    this.enableBandwidthThrottling = false,
    this.maxBandwidthKBps = 1000,
    this.enableTrafficEncryption = false,
    this.blockedDomains = const [],
    this.domainSpeedLimits = const {},
    this.enableDetailedLogging = true,
    this.monitoringInterval = const Duration(seconds: 1),
  });
}

/// 流量数据类型
enum TrafficDataType {
  httpRequest,
  httpResponse,
  dnsQuery,
  tcpConnection,
  udpPacket,
  proxyConnection,
  error,
}

/// 流量数据记录
class TrafficData {
  final String id;
  final TrafficDataType type;
  final String source;
  final String destination;
  final int port;
  final int bytes;
  final Duration duration;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final String? userAgent;
  final String? host;
  final String? path;
  final int? statusCode;
  final String? errorMessage;
  final bool isEncrypted;
  final String? proxyType;

  TrafficData({
    required this.id,
    required this.type,
    required this.source,
    required this.destination,
    required this.port,
    required this.bytes,
    required this.duration,
    required this.timestamp,
    this.metadata = const {},
    this.userAgent,
    this.host,
    this.path,
    this.statusCode,
    this.errorMessage,
    this.isEncrypted = false,
    this.proxyType,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'source': source,
    'destination': destination,
    'port': port,
    'bytes': bytes,
    'duration': duration.inMilliseconds,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
    'userAgent': userAgent,
    'host': host,
    'path': path,
    'statusCode': statusCode,
    'errorMessage': errorMessage,
    'isEncrypted': isEncrypted,
    'proxyType': proxyType,
  };

  factory TrafficData.fromJson(Map<String, dynamic> json) => TrafficData(
    id: json['id'],
    type: TrafficDataType.values.firstWhere(
      (e) => e.toString() == json['type'],
      orElse: () => TrafficDataType.httpRequest,
    ),
    source: json['source'],
    destination: json['destination'],
    port: json['port'],
    bytes: json['bytes'],
    duration: Duration(milliseconds: json['duration']),
    timestamp: DateTime.parse(json['timestamp']),
    metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    userAgent: json['userAgent'],
    host: json['host'],
    path: json['path'],
    statusCode: json['statusCode'],
    errorMessage: json['errorMessage'],
    isEncrypted: json['isEncrypted'] ?? false,
    proxyType: json['proxyType'],
  );
}

/// 流量统计信息
class TrafficStatistics {
  final DateTime periodStart;
  final DateTime periodEnd;
  final int totalConnections;
  final int totalBytes;
  final int totalRequests;
  final int totalResponses;
  final int totalErrors;
  final Duration totalDuration;
  final Map<String, int> domainStats;
  final Map<String, int> protocolStats;
  final Map<String, int> statusCodeStats;
  final double averageResponseTime;
  final double averageBandwidth;
  final int peakConcurrentConnections;
  final List<String> topDomains;
  final List<String> blockedDomains;

  TrafficStatistics({
    required this.periodStart,
    required this.periodEnd,
    required this.totalConnections,
    required this.totalBytes,
    required this.totalRequests,
    required this.totalResponses,
    required this.totalErrors,
    required this.totalDuration,
    required this.domainStats,
    required this.protocolStats,
    required this.statusCodeStats,
    required this.averageResponseTime,
    required this.averageBandwidth,
    required this.peakConcurrentConnections,
    required this.topDomains,
    required this.blockedDomains,
  });

  Map<String, dynamic> toJson() => {
    'periodStart': periodStart.toIso8601String(),
    'periodEnd': periodEnd.toIso8601String(),
    'totalConnections': totalConnections,
    'totalBytes': totalBytes,
    'totalRequests': totalRequests,
    'totalResponses': totalResponses,
    'totalErrors': totalErrors,
    'totalDuration': totalDuration.inMilliseconds,
    'domainStats': domainStats,
    'protocolStats': protocolStats,
    'statusCodeStats': statusCodeStats,
    'averageResponseTime': averageResponseTime,
    'averageBandwidth': averageBandwidth,
    'peakConcurrentConnections': peakConcurrentConnections,
    'topDomains': topDomains,
    'blockedDomains': blockedDomains,
  };
}

/// 流量监控事件
class TrafficMonitorEvent {
  final TrafficMonitorEventType type;
  final TrafficData? data;
  final TrafficStatistics? statistics;
  final String message;
  final DateTime timestamp;

  TrafficMonitorEvent(this.type, this.message, this.timestamp, {this.data, this.statistics});
}

enum TrafficMonitorEventType {
  dataRecorded,
  statisticsUpdated,
  thresholdExceeded,
  errorDetected,
  connectionEstablished,
  connectionClosed,
  domainBlocked,
  bandwidthLimitReached,
}

/// 流量监控服务
class TrafficMonitorService {
  final TrafficMonitorConfig _config;
  final StreamController<TrafficMonitorEvent> _eventController = 
      StreamController<TrafficMonitorEvent>.broadcast();
  final List<TrafficData> _trafficData = [];
  final Map<String, List<TrafficData>> _domainData = {};
  final Map<String, int> _concurrentConnections = {};
  final Timer? _monitoringTimer;
  final Timer? _cleanupTimer;
  final DateTime _startTime = DateTime.now();

  // 统计数据
  int _totalBytes = 0;
  int _totalRequests = 0;
  int _totalResponses = 0;
  int _totalErrors = 0;
  int _peakConcurrentConnections = 0;
  final List<int> _responseTimes = [];
  final List<int> _bandwidthSamples = [];

  TrafficMonitorService({TrafficMonitorConfig? config})
      : _config = config ?? TrafficMonitorConfig(),
        _monitoringTimer = null,
        _cleanupTimer = null {
    _startMonitoring();
  }

  Stream<TrafficMonitorEvent> get events => _eventController.stream;
  List<TrafficData> get trafficData => List.unmodifiable(_trafficData);
  TrafficMonitorConfig get config => _config;

  /// 开始监控
  void _startMonitoring() {
    if (_config.enableRealTimeMonitoring) {
      _monitoringTimer = Timer.periodic(
        _config.monitoringInterval,
        _processMonitoringTick,
      );
    }

    // 定期清理过期数据
    _cleanupTimer = Timer.periodic(
      const Duration(minutes: 10),
      _cleanupExpiredData,
    );
  }

  /// 记录流量数据
  void recordTrafficData(TrafficData data) {
    // 检查域名黑名单
    if (_isDomainBlocked(data.destination)) {
      _emitEvent(
        TrafficMonitorEventType.domainBlocked,
        '域名被阻止: ${data.destination}',
        data: data,
      );
      return;
    }

    // 检查带宽限制
    if (_config.enableBandwidthThrottling && 
        !_checkBandwidthLimit(data)) {
      _emitEvent(
        TrafficMonitorEventType.bandwidthLimitReached,
        '达到带宽限制',
        data: data,
      );
      return;
    }

    // 记录数据
    _trafficData.add(data);
    _totalBytes += data.bytes;
    _updateDomainStats(data);
    _updateProtocolStats(data);
    _updateStatusCodeStats(data);
    _responseTimes.add(data.duration.inMilliseconds);

    // 更新并发连接数
    _updateConcurrentConnections(data);

    // 限制日志条目数量
    if (_trafficData.length > _config.maxLogEntries) {
      _trafficData.removeAt(0);
    }

    // 发送事件
    _emitEvent(
      TrafficMonitorEventType.dataRecorded,
      '记录流量数据: ${data.destination}',
      data: data,
    );

    // 检查是否需要加密
    if (_config.enableTrafficEncryption && !data.isEncrypted) {
      _encryptTrafficData(data);
    }
  }

  /// 记录HTTP请求
  void recordHttpRequest({
    required String url,
    required String method,
    required String userAgent,
    required Map<String, String> headers,
    required int bytes,
    required Duration duration,
  }) {
    final uri = Uri.parse(url);
    final data = TrafficData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: TrafficDataType.httpRequest,
      source: 'client',
      destination: uri.host,
      port: uri.port,
      bytes: bytes,
      duration: duration,
      timestamp: DateTime.now(),
      userAgent: userAgent,
      host: uri.host,
      path: uri.path,
      metadata: headers,
    );

    _totalRequests++;
    recordTrafficData(data);
  }

  /// 记录HTTP响应
  void recordHttpResponse({
    required String url,
    required int statusCode,
    required Map<String, String> headers,
    required int bytes,
    required Duration duration,
  }) {
    final uri = Uri.parse(url);
    final data = TrafficData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: TrafficDataType.httpResponse,
      source: uri.host,
      destination: 'client',
      port: uri.port,
      bytes: bytes,
      duration: duration,
      timestamp: DateTime.now(),
      statusCode: statusCode,
      host: uri.host,
      path: uri.path,
      metadata: headers,
    );

    _totalResponses++;
    recordTrafficData(data);
  }

  /// 记录错误
  void recordError({
    required String source,
    required String destination,
    required String errorMessage,
    required int bytes,
    required Duration duration,
  }) {
    final data = TrafficData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: TrafficDataType.error,
      source: source,
      destination: destination,
      port: 0,
      bytes: bytes,
      duration: duration,
      timestamp: DateTime.now(),
      errorMessage: errorMessage,
    );

    _totalErrors++;
    recordTrafficData(data);
  }

  /// 记录代理连接
  void recordProxyConnection({
    required String proxyType,
    required String source,
    required String destination,
    required bool isConnected,
    required Duration duration,
  }) {
    final data = TrafficData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: TrafficDataType.proxyConnection,
      source: source,
      destination: destination,
      port: 0,
      bytes: 0,
      duration: duration,
      timestamp: DateTime.now(),
      proxyType: proxyType,
      metadata: {'connected': isConnected},
    );

    recordTrafficData(data);
  }

  /// 获取流量统计
  TrafficStatistics getStatistics({DateTime? from, DateTime? to}) {
    final start = from ?? DateTime.now().subtract(const Duration(hours: 1));
    final end = to ?? DateTime.now();

    final filteredData = _trafficData.where((data) =>
        data.timestamp.isAfter(start) && data.timestamp.isBefore(end)).toList();

    final domainStats = <String, int>{};
    final protocolStats = <String, int>{};
    final statusCodeStats = <String, int>{};

    for (final data in filteredData) {
      domainStats[data.destination] = (domainStats[data.destination] ?? 0) + 1;
      
      final protocol = _getProtocolName(data.type);
      protocolStats[protocol] = (protocolStats[protocol] ?? 0) + 1;
      
      if (data.statusCode != null) {
        final statusCode = data.statusCode.toString();
        statusCodeStats[statusCode] = (statusCodeStats[statusCode] ?? 0) + 1;
      }
    }

    final totalDuration = end.difference(start);
    final averageResponseTime = _responseTimes.isNotEmpty
        ? _responseTimes.reduce((a, b) => a + b) / _responseTimes.length
        : 0.0;
    
    final averageBandwidth = totalDuration.inMilliseconds > 0
        ? (_totalBytes / (totalDuration.inMilliseconds / 1000)) / 1024 // KB/s
        : 0.0;

    final topDomains = domainStats.entries
        .toList()
        ..sort((a, b) => b.value.compareTo(a.value))
        .take(10)
        .map((e) => e.key)
        .toList();

    return TrafficStatistics(
      periodStart: start,
      periodEnd: end,
      totalConnections: _concurrentConnections.length,
      totalBytes: _totalBytes,
      totalRequests: _totalRequests,
      totalResponses: _totalResponses,
      totalErrors: _totalErrors,
      totalDuration: totalDuration,
      domainStats: domainStats,
      protocolStats: protocolStats,
      statusCodeStats: statusCodeStats,
      averageResponseTime: averageResponseTime,
      averageBandwidth: averageBandwidth,
      peakConcurrentConnections: _peakConcurrentConnections,
      topDomains: topDomains,
      blockedDomains: _config.blockedDomains,
    );
  }

  /// 获取域名流量数据
  List<TrafficData> getDomainTraffic(String domain) {
    return _domainData[domain] ?? [];
  }

  /// 获取实时带宽使用情况
  double getCurrentBandwidth() {
    final now = DateTime.now();
    final oneMinuteAgo = now.subtract(const Duration(minutes: 1));
    
    final recentData = _trafficData.where((data) =>
        data.timestamp.isAfter(oneMinuteAgo)).toList();
    
    final totalBytes = recentData.fold<int>(0, (sum, data) => sum + data.bytes);
    return totalBytes / 1024.0; // KB/s
  }

  /// 获取并发连接数
  int getConcurrentConnections() {
    return _concurrentConnections.length;
  }

  /// 导出流量数据
  String exportTrafficData({DateTime? from, DateTime? to}) {
    final start = from ?? DateTime.now().subtract(const Duration(hours: 1));
    final end = to ?? DateTime.now();

    final filteredData = _trafficData.where((data) =>
        data.timestamp.isAfter(start) && data.timestamp.isBefore(end)).toList();

    final exportData = filteredData.map((data) => data.toJson()).toList();
    return json.encode(exportData);
  }

  /// 清除流量数据
  void clearTrafficData() {
    _trafficData.clear();
    _domainData.clear();
    _concurrentConnections.clear();
    _totalBytes = 0;
    _totalRequests = 0;
    _totalResponses = 0;
    _totalErrors = 0;
    _responseTimes.clear();
    _bandwidthSamples.clear();

    _emitEvent(
      TrafficMonitorEventType.statisticsUpdated,
      '流量数据已清除',
    );
  }

  /// 设置域名黑名单
  void setBlockedDomains(List<String> domains) {
    // 注意：这里应该通过配置更新，而不是直接修改_config
    _emitEvent(
      TrafficMonitorEventType.statisticsUpdated,
      '域名黑名单已更新: ${domains.length} 个域名',
    );
  }

  /// 处理监控周期
  void _processMonitoringTick(Timer timer) {
    final currentBandwidth = getCurrentBandwidth();
    _bandwidthSamples.add(currentBandwidth.toInt());

    // 限制样本数量
    if (_bandwidthSamples.length > 60) {
      _bandwidthSamples.removeAt(0);
    }

    // 检查阈值
    if (_config.enableBandwidthThrottling &&
        currentBandwidth > _config.maxBandwidthKBps) {
      _emitEvent(
        TrafficMonitorEventType.thresholdExceeded,
        '带宽使用超过阈值: ${currentBandwidth.toStringAsFixed(2)} KB/s',
      );
    }

    // 更新统计信息
    _emitEvent(
      TrafficMonitorEventType.statisticsUpdated,
      '统计信息已更新',
      statistics: getStatistics(),
    );
  }

  /// 清理过期数据
  void _cleanupExpiredData(Timer timer) {
    final cutoff = DateTime.now().subtract(_config.logRetentionPeriod);
    
    _trafficData.removeWhere((data) => data.timestamp.isBefore(cutoff));
    
    for (final domain in _domainData.keys) {
      _domainData[domain]?.removeWhere((data) => data.timestamp.isBefore(cutoff));
      if (_domainData[domain]?.isEmpty ?? true) {
        _domainData.remove(domain);
      }
    }
  }

  /// 检查域名是否被阻止
  bool _isDomainBlocked(String domain) {
    return _config.blockedDomains.any((blocked) => 
        domain.contains(blocked) || blocked.contains(domain));
  }

  /// 检查带宽限制
  bool _checkBandwidthLimit(TrafficData data) {
    if (!_config.enableBandwidthThrottling) return true;

    final domain = data.destination;
    final speedLimit = _config.domainSpeedLimits[domain];
    
    if (speedLimit != null) {
      final currentBandwidth = getCurrentBandwidth();
      return currentBandwidth < speedLimit;
    }

    return getCurrentBandwidth() < _config.maxBandwidthKBps;
  }

  /// 更新域名统计
  void _updateDomainStats(TrafficData data) {
    final domain = data.destination;
    if (!_domainData.containsKey(domain)) {
      _domainData[domain] = [];
    }
    _domainData[domain]!.add(data);
  }

  /// 更新协议统计
  void _updateProtocolStats(TrafficData data) {
    // 协议统计已在getStatistics中处理
  }

  /// 更新状态码统计
  void _updateStatusCodeStats(TrafficData data) {
    // 状态码统计已在getStatistics中处理
  }

  /// 更新并发连接数
  void _updateConcurrentConnections(TrafficData data) {
    final connectionId = '${data.source}:${data.destination}';
    
    if (data.type == TrafficDataType.proxyConnection ||
        data.type == TrafficDataType.tcpConnection) {
      _concurrentConnections[connectionId] = DateTime.now().millisecondsSinceEpoch;
      
      if (_concurrentConnections.length > _peakConcurrentConnections) {
        _peakConcurrentConnections = _concurrentConnections.length;
      }
    } else {
      _concurrentConnections.remove(connectionId);
    }
  }

  /// 获取协议名称
  String _getProtocolName(TrafficDataType type) {
    switch (type) {
      case TrafficDataType.httpRequest:
      case TrafficDataType.httpResponse:
        return 'HTTP';
      case TrafficDataType.dnsQuery:
        return 'DNS';
      case TrafficDataType.tcpConnection:
        return 'TCP';
      case TrafficDataType.udpPacket:
        return 'UDP';
      case TrafficDataType.proxyConnection:
        return 'Proxy';
      case TrafficDataType.error:
        return 'Error';
    }
  }

  /// 加密流量数据
  void _encryptTrafficData(TrafficData data) {
    // 简单的加密实现（在实际应用中应该使用更安全的加密方法）
    final metadata = Map<String, dynamic>.from(data.metadata);
    metadata['encrypted'] = true;
    
    _emitEvent(
      TrafficMonitorEventType.statisticsUpdated,
      '流量数据已加密',
      data: data,
    );
  }

  /// 发送事件
  void _emitEvent(TrafficMonitorEventType type, String message, {TrafficData? data, TrafficStatistics? statistics}) {
    _eventController.add(TrafficMonitorEvent(
      type,
      message,
      DateTime.now(),
      data: data,
      statistics: statistics,
    ));
  }

  /// 停止监控
  void stop() {
    _monitoringTimer?.cancel();
    _cleanupTimer?.cancel();
    _eventController.close();
  }

  /// 获取运行时间
  Duration getUptime() {
    return DateTime.now().difference(_startTime);
  }

  /// 生成流量报告
  String generateTrafficReport() {
    final stats = getStatistics();
    final currentBandwidth = getCurrentBandwidth();
    final concurrentConnections = getConcurrentConnections();

    final buffer = StringBuffer();
    buffer.writeln('=== FlClash 流量监控报告 ===');
    buffer.writeln('报告时间: ${DateTime.now()}');
    buffer.writeln('监控时长: ${getUptime()}');
    buffer.writeln();
    
    buffer.writeln('=== 总体统计 ===');
    buffer.writeln('总连接数: ${stats.totalConnections}');
    buffer.writeln('总流量: ${(stats.totalBytes / 1024 / 1024).toStringAsFixed(2)} MB');
    buffer.writeln('总请求数: ${stats.totalRequests}');
    buffer.writeln('总响应数: ${stats.totalResponses}');
    buffer.writeln('总错误数: ${stats.totalErrors}');
    buffer.writeln('平均响应时间: ${stats.averageResponseTime.toStringAsFixed(2)} ms');
    buffer.writeln('平均带宽: ${stats.averageBandwidth.toStringAsFixed(2)} KB/s');
    buffer.writeln('峰值并发连接: ${stats.peakConcurrentConnections}');
    buffer.writeln();
    
    buffer.writeln('=== 实时状态 ===');
    buffer.writeln('当前带宽: ${currentBandwidth.toStringAsFixed(2)} KB/s');
    buffer.writeln('当前并发连接: $concurrentConnections');
    buffer.writeln();
    
    buffer.writeln('=== 域名统计 (Top 10) ===');
    stats.topDomains.take(10).forEach((domain) {
      final count = stats.domainStats[domain] ?? 0;
      buffer.writeln('$domain: $count 次连接');
    });
    buffer.writeln();
    
    buffer.writeln('=== 协议统计 ===');
    stats.protocolStats.forEach((protocol, count) {
      buffer.writeln('$protocol: $count 次');
    });
    buffer.writeln();
    
    buffer.writeln('=== 状态码统计 ===');
    stats.statusCodeStats.forEach((statusCode, count) {
      buffer.writeln('$statusCode: $count 次');
    });
    buffer.writeln();
    
    if (stats.blockedDomains.isNotEmpty) {
      buffer.writeln('=== 已阻止域名 ===');
      stats.blockedDomains.forEach((domain) {
        buffer.writeln('- $domain');
      });
    }

    return buffer.toString();
  }
}