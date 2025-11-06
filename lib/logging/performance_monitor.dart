import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'logger.dart';
import 'log_entry.dart';

/// 性能监控配置
class PerformanceConfig {
  /// 是否启用性能监控
  final bool enabled;
  
  /// 监控间隔
  final Duration monitorInterval;
  
  /// 最大记录数量
  final int maxRecords;
  
  /// 是否记录CPU使用情况
  final bool monitorCpu;
  
  /// 是否记录内存使用情况
  final bool monitorMemory;
  
  /// 是否记录帧率
  final bool monitorFrameRate;
  
  /// 是否记录网络请求
  final bool monitorNetwork;
  
  /// 性能警告阈值（响应时间超过此值将记录警告）
  final Duration warningThreshold;
  
  /// 性能严重警告阈值（响应时间超过此值将记录严重警告）
  final Duration criticalThreshold;

  const PerformanceConfig({
    this.enabled = false,
    this.monitorInterval = const Duration(seconds: 1),
    this.maxRecords = 1000,
    this.monitorCpu = true,
    this.monitorMemory = true,
    this.monitorFrameRate = true,
    this.monitorNetwork = true,
    this.warningThreshold = const Duration(milliseconds: 100),
    this.criticalThreshold = const Duration(milliseconds: 500),
  });

  PerformanceConfig copyWith({
    bool? enabled,
    Duration? monitorInterval,
    int? maxRecords,
    bool? monitorCpu,
    bool? monitorMemory,
    bool? monitorFrameRate,
    bool? monitorNetwork,
    Duration? warningThreshold,
    Duration? criticalThreshold,
  }) {
    return PerformanceConfig(
      enabled: enabled ?? this.enabled,
      monitorInterval: monitorInterval ?? this.monitorInterval,
      maxRecords: maxRecords ?? this.maxRecords,
      monitorCpu: monitorCpu ?? this.monitorCpu,
      monitorMemory: monitorMemory ?? this.monitorMemory,
      monitorFrameRate: monitorFrameRate ?? this.monitorFrameRate,
      monitorNetwork: monitorNetwork ?? this.monitorNetwork,
      warningThreshold: warningThreshold ?? this.warningThreshold,
      criticalThreshold: criticalThreshold ?? this.criticalThreshold,
    );
  }
}

/// 性能指标类型
enum MetricType {
  responseTime,
  cpuUsage,
  memoryUsage,
  frameRate,
  networkLatency,
  fileOperationTime,
  databaseQueryTime,
  custom;
}

/// 性能指标
class PerformanceMetric {
  /// 指标类型
  final MetricType type;
  
  /// 指标名称
  final String name;
  
  /// 指标值
  final double value;
  
  /// 单位
  final String unit;
  
  /// 时间戳
  final DateTime timestamp;
  
  /// 标签
  final Map<String, dynamic> tags;
  
  /// 额外信息
  final Map<String, dynamic>? metadata;

  PerformanceMetric({
    required this.type,
    required this.name,
    required this.value,
    required this.unit,
    DateTime? timestamp,
    this.tags = const {},
    this.metadata,
  }) : timestamp = timestamp ?? DateTime.now();

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'name': name,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'tags': tags,
      'metadata': metadata,
    };
  }

  /// 从JSON创建
  factory PerformanceMetric.fromJson(Map<String, dynamic> json) {
    return PerformanceMetric(
      type: MetricType.values.firstWhere((t) => t.name == json['type']),
      name: json['name'] as String,
      value: json['value'] as double,
      unit: json['unit'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      tags: Map<String, dynamic>.from(json['tags'] as Map),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  String toString() {
    return '$name: $value $unit (${timestamp.toIso8601String()})';
  }
}

/// 性能统计
class PerformanceStatistics {
  final Map<MetricType, List<double>> _values = {};
  final Map<MetricType, DateTime> _firstRecord = {};
  final Map<MetricType, DateTime> _lastRecord = {};
  final Map<MetricType, int> _count = {};
  final Map<MetricType, double> _min = {};
  final Map<MetricType, double> _max = {};
  final Map<MetricType, double> _sum = {};
  final Map<MetricType, double> _avg = {};

  /// 添加指标
  void addMetric(PerformanceMetric metric) {
    final type = metric.type;
    
    if (!_values.containsKey(type)) {
      _values[type] = [];
      _firstRecord[type] = metric.timestamp;
      _min[type] = metric.value;
      _max[type] = metric.value;
      _sum[type] = metric.value;
      _count[type] = 1;
    } else {
      _values[type]!.add(metric.value);
      _count[type] = (_count[type] ?? 0) + 1;
      _sum[type] = (_sum[type] ?? 0) + metric.value;
      
      _min[type] = math.min(_min[type]!, metric.value);
      _max[type] = math.max(_max[type]!, metric.value);
    }
    
    _lastRecord[type] = metric.timestamp;
    _avg[type] = (_sum[type] ?? 0) / (_count[type] ?? 1);
    
    // 限制数组大小
    if (_values[type]!.length > 1000) {
      _values[type] = _values[type]!.sublist(-500); // 保留最近500个值
    }
  }

  /// 获取指定类型的统计信息
  Map<String, dynamic> getStatistics(MetricType type) {
    if (!_values.containsKey(type)) {
      return {'error': 'No data for type: $type'};
    }

    final values = _values[type]!;
    if (values.isEmpty) {
      return {'error': 'No data for type: $type'};
    }

    return {
      'type': type.name,
      'count': _count[type],
      'min': _min[type],
      'max': _max[type],
      'avg': _avg[type],
      'firstRecord': _firstRecord[type]?.toIso8601String(),
      'lastRecord': _lastRecord[type]?.toIso8601String(),
      'trend': _calculateTrend(type),
      'percentiles': _calculatePercentiles(values),
    };
  }

  /// 计算趋势
  String _calculateTrend(MetricType type) {
    final values = _values[type];
    if (values == null || values.length < 2) {
      return 'unknown';
    }

    final recent = values.sublist(math.max(0, values.length - 10));
    final older = values.sublist(0, math.min(10, values.length - 10));

    if (older.isEmpty) return 'unknown';

    final recentAvg = recent.reduce((a, b) => a + b) / recent.length;
    final olderAvg = older.reduce((a, b) => a + b) / older.length;

    final change = (recentAvg - olderAvg) / olderAvg;

    if (change > 0.1) return 'increasing';
    if (change < -0.1) return 'decreasing';
    return 'stable';
  }

  /// 计算百分位数
  Map<String, double> _calculatePercentiles(List<double> values) {
    final sorted = List<double>.from(values)..sort();
    final size = sorted.length;

    return {
      'p50': _percentile(sorted, 50),
      'p90': _percentile(sorted, 90),
      'p95': _percentile(sorted, 95),
      'p99': _percentile(sorted, 99),
    };
  }

  /// 计算百分位数
  double _percentile(List<double> sorted, double percentile) {
    if (sorted.isEmpty) return 0.0;
    
    final index = (sorted.length - 1) * percentile / 100;
    final lower = index.floor();
    final upper = index.ceil();
    final weight = index - lower;

    if (upper >= sorted.length) return sorted.last;
    if (weight == 0) return sorted[lower];

    return sorted[lower] * (1 - weight) + sorted[upper] * weight;
  }

  /// 获取所有统计信息
  Map<String, dynamic> getAllStatistics() {
    final stats = <String, dynamic>{};
    for (final type in MetricType.values) {
      stats[type.name] = getStatistics(type);
    }
    return stats;
  }

  /// 清空统计
  void clear() {
    _values.clear();
    _firstRecord.clear();
    _lastRecord.clear();
    _count.clear();
    _min.clear();
    _max.clear();
    _sum.clear();
    _avg.clear();
  }
}

/// 性能监控器
class PerformanceMonitor {
  final Logger _logger = Logger();
  final PerformanceConfig _config;
  final List<PerformanceMetric> _metrics = [];
  final PerformanceStatistics _statistics = PerformanceStatistics();
  final StreamController<PerformanceMetric> _metricsController = StreamController.broadcast();
  final StreamController<PerformanceStatistics> _statisticsController = StreamController.broadcast();
  
  Timer? _monitorTimer;
  final Stopwatch _globalStopwatch = Stopwatch();
  
  /// 指标流
  Stream<PerformanceMetric> get metricsStream => _metricsController.stream;
  
  /// 统计信息流
  Stream<PerformanceStatistics> get statisticsStream => _statisticsController.stream;
  
  /// 当前统计
  PerformanceStatistics get statistics => _statistics;
  
  /// 配置
  PerformanceConfig get config => _config;

  PerformanceMonitor({PerformanceConfig? config}) 
      : _config = config ?? const PerformanceConfig() {
    _initialize();
  }

  /// 初始化性能监控器
  void _initialize() {
    if (_config.enabled) {
      _startMonitoring();
      _logger.info('性能监控器已启动', source: 'PerformanceMonitor');
    }
  }

  /// 启动监控
  void _startMonitoring() {
    _globalStopwatch.start();
    _monitorTimer = Timer.periodic(_config.monitorInterval, (_) {
      _collectMetrics();
    });
  }

  /// 停止监控
  void _stopMonitoring() {
    _monitorTimer?.cancel();
    _monitorTimer = null;
    _globalStopwatch.stop();
  }

  /// 收集指标
  Future<void> _collectMetrics() async {
    if (!_config.enabled) return;

    try {
      // 收集CPU使用率
      if (_config.monitorCpu) {
        await _collectCpuMetrics();
      }

      // 收集内存使用情况
      if (_config.monitorMemory) {
        await _collectMemoryMetrics();
      }

      // 收集帧率
      if (_config.monitorFrameRate) {
        await _collectFrameRateMetrics();
      }

      // 发送统计信息
      if (!_statisticsController.isClosed) {
        _statisticsController.add(_statistics);
      }
    } catch (e) {
      _logger.warning('性能指标收集失败', exception: e, source: 'PerformanceMonitor');
    }
  }

  /// 收集CPU指标
  Future<void> _collectCpuMetrics() async {
    // 在Flutter中，CPU使用率获取有限，这里使用模拟数据
    final cpuUsage = _calculateCpuUsage();
    
    final metric = PerformanceMetric(
      type: MetricType.cpuUsage,
      name: 'CPU使用率',
      value: cpuUsage,
      unit: '%',
      tags: {'monitor': 'cpu'},
    );
    
    _addMetric(metric);
  }

  /// 计算CPU使用率（模拟）
  double _calculateCpuUsage() {
    // 这里应该实现真正的CPU使用率计算
    // 在Flutter中，可以尝试通过系统调用或第三方库获取
    return math.Random().nextDouble() * 100; // 模拟数据
  }

  /// 收集内存指标
  Future<void> _collectMemoryMetrics() async {
    // 内存信息获取
    final memoryInfo = await _getMemoryInfo();
    
    final heapMetric = PerformanceMetric(
      type: MetricType.memoryUsage,
      name: '堆内存使用',
      value: memoryInfo['heap'] / (1024 * 1024), // 转换为MB
      unit: 'MB',
      tags: {'memory': 'heap'},
    );
    
    final totalMetric = PerformanceMetric(
      type: MetricType.memoryUsage,
      name: '总内存使用',
      value: memoryInfo['total'] / (1024 * 1024), // 转换为MB
      unit: 'MB',
      tags: {'memory': 'total'},
    );
    
    _addMetric(heapMetric);
    _addMetric(totalMetric);
  }

  /// 获取内存信息（模拟）
  Future<Map<String, int>> _getMemoryInfo() async {
    // 这里应该实现真正的内存信息获取
    return {
      'heap': 50 * 1024 * 1024, // 50MB模拟
      'total': 60 * 1024 * 1024, // 60MB模拟
    };
  }

  /// 收集帧率指标
  Future<void> _collectFrameRateMetrics() async {
    final frameRate = await _getCurrentFrameRate();
    
    final metric = PerformanceMetric(
      type: MetricType.frameRate,
      name: '帧率',
      value: frameRate,
      unit: 'fps',
      tags: {'render': 'frame_rate'},
    );
    
    _addMetric(metric);
  }

  /// 获取当前帧率
  Future<double> _getCurrentFrameRate() async {
    // 在Flutter中，可以使用WidgetsBinding.instance.renderView.flutterView.display.refreshRate
    return 60.0; // 假设60fps
  }

  /// 添加指标
  void _addMetric(PerformanceMetric metric) {
    _metrics.add(metric);
    _statistics.addMetric(metric);
    
    // 限制内存中的指标数量
    while (_metrics.length > _config.maxRecords) {
      _metrics.removeAt(0);
    }
    
    // 发送指标事件
    if (!_metricsController.isClosed) {
      _metricsController.add(metric);
    }
    
    // 检查阈值
    _checkThresholds(metric);
  }

  /// 检查性能阈值
  void _checkThresholds(PerformanceMetric metric) {
    if (metric.type == MetricType.responseTime) {
      final duration = Duration(milliseconds: metric.value.toInt());
      
      if (duration >= _config.criticalThreshold) {
        _logger.critical('性能严重警告: ${metric.name} 超过严重阈值', 
            source: 'PerformanceMonitor',
            context: metric.metadata,
            tags: ['performance', 'critical']);
      } else if (duration >= _config.warningThreshold) {
        _logger.warning('性能警告: ${metric.name} 超过警告阈值', 
            source: 'PerformanceMonitor',
            context: metric.metadata,
            tags: ['performance', 'warning']);
      }
    }
  }

  /// 启用性能监控
  void enable() {
    if (!_config.enabled) {
      _config = _config.copyWith(enabled: true);
      _startMonitoring();
      _logger.info('性能监控已启用', source: 'PerformanceMonitor');
    }
  }

  /// 禁用性能监控
  void disable() {
    if (_config.enabled) {
      _config = _config.copyWith(enabled: false);
      _stopMonitoring();
      _logger.info('性能监控已禁用', source: 'PerformanceMonitor');
    }
  }

  /// 切换监控状态
  void toggle() {
    if (_config.enabled) {
      disable();
    } else {
      enable();
    }
  }

  /// 更新配置
  void updateConfig(PerformanceConfig newConfig) {
    final wasEnabled = _config.enabled;
    _config = newConfig;
    
    if (wasEnabled != newConfig.enabled) {
      if (newConfig.enabled) {
        _startMonitoring();
      } else {
        _stopMonitoring();
      }
    }
    
    _logger.debug('性能监控配置已更新', source: 'PerformanceMonitor');
  }

  /// 记录响应时间
  void recordResponseTime(String operation, Duration duration, {Map<String, dynamic>? tags}) {
    final metric = PerformanceMetric(
      type: MetricType.responseTime,
      name: operation,
      value: duration.inMilliseconds.toDouble(),
      unit: 'ms',
      tags: {'operation': operation, ...?tags},
      metadata: {
        'operation': operation,
        'duration_ms': duration.inMilliseconds,
      },
    );
    
    _addMetric(metric);
  }

  /// 记录网络延迟
  void recordNetworkLatency(String endpoint, Duration latency, {Map<String, dynamic>? tags}) {
    final metric = PerformanceMetric(
      type: MetricType.networkLatency,
      name: '网络延迟',
      value: latency.inMilliseconds.toDouble(),
      unit: 'ms',
      tags: {'endpoint': endpoint, 'network': 'latency', ...?tags},
      metadata: {
        'endpoint': endpoint,
        'latency_ms': latency.inMilliseconds,
      },
    );
    
    _addMetric(metric);
  }

  /// 记录文件操作时间
  void recordFileOperation(String operation, String filePath, Duration duration) {
    final metric = PerformanceMetric(
      type: MetricType.fileOperationTime,
      name: '文件操作',
      value: duration.inMilliseconds.toDouble(),
      unit: 'ms',
      tags: {'file': filePath, 'operation': operation},
      metadata: {
        'file_path': filePath,
        'operation': operation,
        'duration_ms': duration.inMilliseconds,
      },
    );
    
    _addMetric(metric);
  }

  /// 记录数据库查询时间
  void recordDatabaseQuery(String table, String query, Duration duration) {
    final metric = PerformanceMetric(
      type: MetricType.databaseQueryTime,
      name: '数据库查询',
      value: duration.inMilliseconds.toDouble(),
      unit: 'ms',
      tags: {'table': table, 'database': 'query'},
      metadata: {
        'table': table,
        'query': query,
        'duration_ms': duration.inMilliseconds,
      },
    );
    
    _addMetric(metric);
  }

  /// 记录自定义指标
  void recordCustomMetric(String name, double value, String unit, {Map<String, dynamic>? tags, Map<String, dynamic>? metadata}) {
    final metric = PerformanceMetric(
      type: MetricType.custom,
      name: name,
      value: value,
      unit: unit,
      tags: tags ?? {},
      metadata: metadata,
    );
    
    _addMetric(metric);
  }

  /// 获取指定时间范围的指标
  List<PerformanceMetric> getMetricsInTimeRange(DateTime start, DateTime end) {
    return _metrics.where((metric) => 
        metric.timestamp.isAfter(start) && metric.timestamp.isBefore(end)
    ).toList();
  }

  /// 获取指定类型的指标
  List<PerformanceMetric> getMetricsByType(MetricType type) {
    return _metrics.where((metric) => metric.type == type).toList();
  }

  /// 导出性能数据
  String exportPerformanceData() {
    final data = {
      'export_time': DateTime.now().toIso8601String(),
      'config': {
        'enabled': _config.enabled,
        'monitor_interval_ms': _config.monitorInterval.inMilliseconds,
        'max_records': _config.maxRecords,
      },
      'statistics': _statistics.getAllStatistics(),
      'metrics': _metrics.map((m) => m.toJson()).toList(),
      'global_uptime_ms': _globalStopwatch.elapsedMilliseconds,
    };
    
    return json.encode(data);
  }

  /// 清空所有数据
  void clear() {
    _metrics.clear();
    _statistics.clear();
    _logger.info('性能监控数据已清空', source: 'PerformanceMonitor');
  }

  /// 关闭性能监控器
  void dispose() {
    _stopMonitoring();
    _metricsController.close();
    _statisticsController.close();
    _logger.info('性能监控器已关闭', source: 'PerformanceMonitor');
  }
}

/// 性能测量装饰器
class PerformanceMeasurer {
  final PerformanceMonitor _monitor;
  final String _operation;

  PerformanceMeasurer(this._monitor, this._operation);

  void measure<T>(T Function() function, {Map<String, dynamic>? tags}) {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = function();
      stopwatch.stop();
      
      _monitor.recordResponseTime(_operation, stopwatch.elapsed, tags: tags);
      return result as T;
    } catch (e) {
      stopwatch.stop();
      _monitor.recordResponseTime(_operation, stopwatch.elapsed, tags: {...?tags, 'error': 'true'});
      rethrow;
    }
  }

  Future<T> measureAsync<T>(Future<T> Function() function, {Map<String, dynamic>? tags}) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await function();
      stopwatch.stop();
      
      _monitor.recordResponseTime(_operation, stopwatch.elapsed, tags: tags);
      return result;
    } catch (e) {
      stopwatch.stop();
      _monitor.recordResponseTime(_operation, stopwatch.elapsed, tags: {...?tags, 'error': 'true'});
      rethrow;
    }
  }
}