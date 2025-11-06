import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

/// 性能监控服务
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  // 性能指标
  final Map<String, PerformanceMetric> _metrics = {};
  final List<PerformanceEvent> _events = [];
  final StreamController<PerformanceEvent> _eventController =;
      StreamController<PerformanceEvent>.broadcast();
  
  // 监控配置
  PerformanceConfig? _config;
  Timer? _monitorTimer;
  bool _isMonitoring = false;

  // 内存监控
  final MemoryManager _memoryManager = MemoryManager();
  final CacheManager _cacheManager = CacheManager();

  /// 初始化性能服务
  Future<void> initialize({PerformanceConfig? config}) async {
    _config = config ?? PerformanceConfig.defaultConfig();
    
    // 启动内存管理
    await _memoryManager.initialize();
    
    // 启动缓存管理
    await _cacheManager.initialize(
      maxCacheSize: _config!.maxCacheSize,
      maxMemoryCache: _config!.maxMemoryCache,
    );

    // 启动性能监控
    _startMonitoring();

    log('性能服务初始化完成');
  }

  /// 启动性能监控
  void _startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _monitorTimer = Timer.periodic(
      _config!.monitoringInterval,
      _monitorPerformance,
    );
  }

  /// 停止性能监控
  void stopMonitoring() {
    _isMonitoring = false;
    _monitorTimer?.cancel();
    _monitorTimer = null;
  }

  /// 性能监控循环
  void _monitorPerformance(Timer timer) {
    _checkMemoryUsage();
    _checkPerformanceMetrics();
    _cleanupOldEvents();
    _optimizeResources();
  }

  /// 检查内存使用情况
  void _checkMemoryUsage() {
    final memoryInfo = _memoryManager.getCurrentMemoryInfo();
    
    if (memoryInfo.usagePercent > _config!.memoryWarningThreshold) {
      _triggerMemoryCleanup();
    }

    // 记录内存事件
    _recordEvent(PerformanceEvent(
      type: PerformanceEventType.memory,
      timestamp: DateTime.now(),
      data: {
        'usage_percent': memoryInfo.usagePercent,
        'used_mb': memoryInfo.usedMB,
        'available_mb': memoryInfo.availableMB,
      },
    ));
  }

  /// 检查性能指标
  void _checkPerformanceMetrics() {
    for (final metric in _metrics.values) {
      if (metric.value > metric.threshold) {
        _recordEvent(PerformanceEvent(
          type: PerformanceEventType.performance,
          timestamp: DateTime.now(),
          data: {
            'metric_name': metric.name,
            'current_value': metric.value,
            'threshold': metric.threshold,
          },
        ));
      }
    }
  }

  /// 清理旧事件
  void _cleanupOldEvents() {
    final cutoff = DateTime.now().subtract(_config!.eventRetentionPeriod);
    _events.removeWhere((event) => event.timestamp.isBefore(cutoff));
  }

  /// 优化资源
  void _optimizeResources() {
    // 清理过期缓存
    _cacheManager.cleanupExpired();
    
    // 压缩内存
    _memoryManager.compactMemory();
    
    // 垃圾回收建议
    if (_memoryManager.shouldTriggerGC()) {
      _triggerGarbageCollection();
    }
  }

  /// 触发内存清理
  void _triggerMemoryCleanup() {
    _cacheManager.clearOldestEntries();
    _memoryManager.forceCleanup();
    
    _recordEvent(PerformanceEvent(
      type: PerformanceEventType.cleanup,
      timestamp: DateTime.now(),
      data: {'reason': 'memory_threshold_exceeded'},
    ));
  }

  /// 触发垃圾回收
  void _triggerGarbageCollection() {
    // 在Flutter中，我们只能建议垃圾回收
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recordEvent(PerformanceEvent(
        type: PerformanceEventType.gc,
        timestamp: DateTime.now(),
        data: {'triggered': true},
      ));
    });
  }

  /// 记录性能事件
  void _recordEvent(PerformanceEvent event) {
    _events.add(event);
    _eventController.add(event);
  }

  /// 开始性能测量
  String startMeasure(String name) {
    final measureId = '${name}_${DateTime.now().millisecondsSinceEpoch}';
    _metrics[measureId] = PerformanceMetric(
      name: name,
      startTime: DateTime.now(),
      threshold: _config!.defaultThreshold,
    );
    return measureId;
  }

  /// 结束性能测量
  void endMeasure(String measureId) {
    final metric = _metrics[measureId];
    if (metric != null) {
      metric.endTime = DateTime.now();
      metric.value = metric.endTime!.difference(metric.startTime).inMilliseconds.toDouble();
      _metrics.remove(measureId);
      
      _recordEvent(PerformanceEvent(
        type: PerformanceEventType.measurement,
        timestamp: DateTime.now(),
        data: {
          'name': metric.name,
          'duration_ms': metric.value,
        },
      ));
    }
  }

  /// 获取性能事件流
  Stream<PerformanceEvent> get eventStream => _eventController.stream;

  /// 获取当前性能统计
  Map<String, dynamic> getPerformanceStats() {
    return {
      'active_metrics': _metrics.length,
      'event_count': _events.length,
      'memory_info': _memoryManager.getCurrentMemoryInfo().toMap(),
      'cache_info': _cacheManager.getCacheStats(),
      'is_monitoring': _isMonitoring,
    };
  }

  /// 获取性能报告
  Future<PerformanceReport> generateReport() async {
    final now = DateTime.now();
    final recentEvents = _events;
        .where((e) => now.difference(e.timestamp).inMinutes < 60);
        .toList();

    return PerformanceReport(
      generatedAt: now,
      memoryInfo: _memoryManager.getCurrentMemoryInfo(),
      cacheStats: _cacheManager.getCacheStats(),
      recentEvents: recentEvents,
      performanceMetrics: Map.from(_metrics),
    );
  }

  /// 清理所有资源
  void dispose() {
    stopMonitoring();
    _eventController.close();
    _memoryManager.dispose();
    _cacheManager.dispose();
    _metrics.clear();
    _events.clear();
  }
}

/// 性能指标
class PerformanceMetric {
  final String name;
  final DateTime startTime;
  DateTime? endTime;
  double value = 0.0;
  final double threshold;

  PerformanceMetric({
    required this.name,
    required this.startTime,
    this.threshold = 1000.0,
  });

  double get duration => endTime != null;
      ? endTime!.difference(startTime).inMilliseconds.toDouble()
      : 0.0;

  bool get isOverThreshold => value > threshold;
}

/// 性能事件类型
enum PerformanceEventType {
  memory,
  performance,
  cleanup,
  gc,
  measurement,
  error,
}

/// 性能事件
class PerformanceEvent {
  final PerformanceEventType type;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  PerformanceEvent({
    required this.type,
    required this.timestamp,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'data': data,
    };
  }
}

/// 性能配置
class PerformanceConfig {
  final Duration monitoringInterval;
  final Duration eventRetentionPeriod;
  final double memoryWarningThreshold;
  final int maxCacheSize;
  final int maxMemoryCache;
  final double defaultThreshold;

  PerformanceConfig({
    required this.monitoringInterval,
    required this.eventRetentionPeriod,
    required this.memoryWarningThreshold,
    required this.maxCacheSize,
    required this.maxMemoryCache,
    required this.defaultThreshold,
  });

  factory PerformanceConfig.defaultConfig() {
    return PerformanceConfig(
      monitoringInterval: const Duration(seconds: 5),
      eventRetentionPeriod: const Duration(hours: 24),
      memoryWarningThreshold: 80.0,
      maxCacheSize: 100 * 1024 * 1024, // 100MB
      maxMemoryCache: 50 * 1024 * 1024, // 50MB
      defaultThreshold: 1000.0,
    );
  }
}

/// 性能报告
class PerformanceReport {
  final DateTime generatedAt;
  final MemoryInfo memoryInfo;
  final CacheStats cacheStats;
  final List<PerformanceEvent> recentEvents;
  final Map<String, PerformanceMetric> performanceMetrics;

  PerformanceReport({
    required this.generatedAt,
    required this.memoryInfo,
    required this.cacheStats,
    required this.recentEvents,
    required this.performanceMetrics,
  });

  Map<String, dynamic> toMap() {
    return {
      'generated_at': generatedAt.toIso8601String(),
      'memory_info': memoryInfo.toMap(),
      'cache_stats': cacheStats.toMap(),
      'recent_events': recentEvents.map((e) => e.toMap()).toList(),
      'performance_metrics': performanceMetrics.map(
        (key, value) => MapEntry(key, {
          'name': value.name,
          'duration': value.duration,
          'threshold': value.threshold,
        }),
      ),
    };
  }
}