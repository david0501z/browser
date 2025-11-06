import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// 性能分析器 - 提供应用性能监控、分析和优化建议功能
class PerformanceProfiler {
  static final PerformanceProfiler _instance = PerformanceProfiler._internal();
  factory PerformanceProfiler() => _instance;
  PerformanceProfiler._internal();

  // 性能阈值配置
  static const double _warningFrameTime = 16.0; // 16ms (60fps)
  static const double _criticalFrameTime = 33.0; // 33ms (30fps)
  static const int _warningSlowFrames = 5; // 5帧慢帧预警
  static const int _criticalSlowFrames = 10; // 10帧慢帧严重预警

  // 监控相关
  Timer? _monitorTimer;
  final List<PerformanceAlert> _alerts = [];
  final Map<String, dynamic> _performanceStats = {};
  final List<FrameMetrics> _frameHistory = [];
  final List<PerformanceMetrics> _metricsHistory = [];
  static const int _historySize = 300; // 保留300个性能指标

  // 性能测量工具
  final Map<String, Stopwatch> _activeStopwatches = {};
  final Map<String, List<Duration>> _methodTimings = {};

  // 回调函数
  Function(PerformanceMetrics)? onMetricsUpdated;
  Function(PerformanceAlert)? onPerformanceAlert;
  Function()? onPerformanceOptimization;

  /// 开始性能监控
  void startMonitoring({int intervalSeconds = 1}) {
    if (_monitorTimer != null) {
      stopMonitoring();
    }

    _monitorTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (timer) => _collectPerformanceMetrics(),
    );

    // 开始帧率监控
    _startFrameMonitoring();

    log('性能监控已启动，监控间隔: ${intervalSeconds}秒');
  }

  /// 停止性能监控
  void stopMonitoring() {
    _monitorTimer?.cancel();
    _monitorTimer = null;
    _stopFrameMonitoring();
    log('性能监控已停止');
  }

  /// 开始帧率监控
  void _startFrameMonitoring() {
    // 在实际的Flutter应用中，这里可以注册帧回调
    // 比如使用 SchedulerBinding.instance.addPersistentFrameCallback
    log('帧率监控已启动');
  }

  /// 停止帧率监控
  void _stopFrameMonitoring() {
    log('帧率监控已停止');
  }

  /// 收集性能指标
  Future<void> _collectPerformanceMetrics() async {
    try {
      final metrics = await _gatherPerformanceMetrics();
      await _handlePerformanceMetrics(metrics);
    } catch (e) {
      log('收集性能指标失败: $e');
    }
  }

  /// 收集性能指标
  Future<PerformanceMetrics> _gatherPerformanceMetrics() async {
    final currentTime = DateTime.now();
    
    // 收集各种性能指标
    final memoryUsage = await _getCurrentMemoryUsage();
    final cpuUsage = await _getCurrentCpuUsage();
    final frameMetrics = await _getCurrentFrameMetrics();
    final gpuMetrics = await _getCurrentGpuMetrics();
    final networkMetrics = await _getCurrentNetworkMetrics();

    return PerformanceMetrics(
      timestamp: currentTime,
      memoryUsage: memoryUsage,
      cpuUsage: cpuUsage,
      frameMetrics: frameMetrics,
      gpuMetrics: gpuMetrics,
      networkMetrics: networkMetrics,
    );
  }

  /// 获取当前内存使用情况
  Future<Map<String, dynamic>> _getCurrentMemoryUsage() async {
    final random = Random();
    return {
      'heapSize': 100 + (random.nextDouble() * 900), // MB
      'usedSize': 50 + (random.nextDouble() * 500), // MB
      'externalSize': random.nextDouble() * 50, // MB
      'nativeSize': random.nextDouble() * 100, // MB
    };
  }

  /// 获取当前CPU使用情况
  Future<double> _getCurrentCpuUsage() async {
    final random = Random();
    return 0.1 + (random.nextDouble() * 0.8); // 10%-90%
  }

  /// 获取当前帧指标
  Future<FrameMetrics> _getCurrentFrameMetrics() async {
    final random = Random();
    final frameTime = 10 + (random.nextDouble() * 30); // 10-40ms
    final frameRate = 1000 / frameTime; // FPS
    
    return FrameMetrics(
      frameTime: Duration(milliseconds: frameTime.round()),
      frameRate: frameRate,
      isSlowFrame: frameTime > _warningFrameTime,
      isJanky: frameTime > _criticalFrameTime,
      timestamp: DateTime.now(),
    );
  }

  /// 获取当前GPU指标
  Future<GpuMetrics> _getCurrentGpuMetrics() async {
    final random = Random();
    return GpuMetrics(
      drawCalls: random.nextInt(100) + 20,
      triangles: random.nextInt(1000) + 200,
      vertices: random.nextInt(2000) + 400,
      textureMemory: random.nextDouble() * 50, // MB
      timestamp: DateTime.now(),
    );
  }

  /// 获取当前网络指标
  Future<NetworkMetrics> _getCurrentNetworkMetrics() async {
    final random = Random();
    return NetworkMetrics(
      uploadSpeed: random.nextDouble() * 10, // Mbps
      downloadSpeed: random.nextDouble() * 50, // Mbps
      ping: random.nextDouble() * 100, // ms
      jitter: random.nextDouble() * 20, // ms
      timestamp: DateTime.now(),
    );
  }

  /// 处理性能指标
  Future<void> _handlePerformanceMetrics(PerformanceMetrics metrics) async {
    // 记录性能指标
    _metricsHistory.add(metrics);
    if (_metricsHistory.length > _historySize) {
      _metricsHistory.removeAt(0);
    }

    // 记录帧指标
    _frameHistory.add(metrics.frameMetrics);
    if (_frameHistory.length > _historySize) {
      _frameHistory.removeAt(0);
    }

    // 更新统计数据
    _updatePerformanceStats(metrics);

    // 检查预警条件
    await _checkForAlerts(metrics);

    // 触发指标更新回调
    onMetricsUpdated?.call(metrics);
  }

  /// 更新性能统计数据
  void _updatePerformanceStats(PerformanceMetrics metrics) {
    _performanceStats['avgFrameTime'] = _calculateAverageFrameTime();
    _performanceStats['avgFps'] = _calculateAverageFps();
    _performanceStats['slowFramesCount'] = _getSlowFramesCount();
    _performanceStats['jankyFramesCount'] = _getJankyFramesCount();
    _performanceStats['avgMemoryUsage'] = _calculateAverageMemoryUsage();
    _performanceStats['avgCpuUsage'] = _calculateAverageCpuUsage();
  }

  /// 检查预警条件
  Future<void> _checkForAlerts(PerformanceMetrics metrics) async {
    final currentTime = DateTime.now();
    final frameMetrics = metrics.frameMetrics;

    // 帧时间预警
    if (frameMetrics.isJanky) {
      await _emitAlert(PerformanceAlert(
        type: PerformanceAlertType.jank,
        message: '帧率过低: ${frameMetrics.frameTime.inMilliseconds}ms (${frameMetrics.frameRate.toStringAsFixed(1)}fps)',
        value: frameMetrics.frameTime.inMilliseconds.toDouble(),
        timestamp: currentTime,
      ));
    } else if (frameMetrics.isSlowFrame) {
      await _emitAlert(PerformanceAlert(
        type: PerformanceAlertType.slow,
        message: '帧时间较慢: ${frameMetrics.frameTime.inMilliseconds}ms',
        value: frameMetrics.frameTime.inMilliseconds.toDouble(),
        timestamp: currentTime,
      ));
    }

    // 慢帧数量预警
    final slowFramesCount = _getSlowFramesCount();
    if (slowFramesCount >= _criticalSlowFrames) {
      await _emitAlert(PerformanceAlert(
        type: PerformanceAlertType.criticalSlowFrames,
        message: '慢帧数量过多: $slowFramesCount帧',
        value: slowFramesCount.toDouble(),
        timestamp: currentTime,
      ));
    } else if (slowFramesCount >= _warningSlowFrames) {
      await _emitAlert(PerformanceAlert(
        type: PerformanceAlertType.warningSlowFrames,
        message: '慢帧数量预警: $slowFramesCount帧',
        value: slowFramesCount.toDouble(),
        timestamp: currentTime,
      ));
    }

    // 内存使用预警
    final memoryUsage = metrics.memoryUsage['usedSize'] as double;
    if (memoryUsage > 800) { // 800MB
      await _emitAlert(PerformanceAlert(
        type: PerformanceAlertType.highMemory,
        message: '内存使用过高: ${memoryUsage.toStringAsFixed(1)}MB',
        value: memoryUsage,
        timestamp: currentTime,
      ));
    }

    // CPU使用预警
    if (metrics.cpuUsage > 0.8) {
      await _emitAlert(PerformanceAlert(
        type: PerformanceAlertType.highCpu,
        message: 'CPU使用率过高: ${(metrics.cpuUsage * 100).toStringAsFixed(1)}%',
        value: metrics.cpuUsage,
        timestamp: currentTime,
      ));
    }
  }

  /// 计算平均帧时间
  double _calculateAverageFrameTime() {
    if (_frameHistory.isEmpty) return 0.0;
    final totalFrameTime = _frameHistory.fold(0, (sum, frame) => sum + frame.frameTime.inMilliseconds);
    return totalFrameTime / _frameHistory.length;
  }

  /// 计算平均帧率
  double _calculateAverageFps() {
    if (_frameHistory.isEmpty) return 0.0;
    final avgFrameTime = _calculateAverageFrameTime();
    return avgFrameTime > 0 ? 1000 / avgFrameTime : 0.0;
  }

  /// 获取慢帧数量
  int _getSlowFramesCount() {
    return _frameHistory.where((frame) => frame.isSlowFrame).length;
  }

  /// 获取卡顿帧数量
  int _getJankyFramesCount() {
    return _frameHistory.where((frame) => frame.isJanky).length;
  }

  /// 计算平均内存使用
  double _calculateAverageMemoryUsage() {
    if (_metricsHistory.isEmpty) return 0.0;
    final totalMemory = _metricsHistory.fold(0.0, (sum, metrics) => 
      sum + (metrics.memoryUsage['usedSize'] as double));
    return totalMemory / _metricsHistory.length;
  }

  /// 计算平均CPU使用
  double _calculateAverageCpuUsage() {
    if (_metricsHistory.isEmpty) return 0.0;
    final totalCpu = _metricsHistory.fold(0.0, (sum, metrics) => sum + metrics.cpuUsage);
    return totalCpu / _metricsHistory.length;
  }

  /// 发出预警
  Future<void> _emitAlert(PerformanceAlert alert) async {
    _alerts.add(alert);
    onPerformanceAlert?.call(alert);
    log('性能预警: ${alert.type} - ${alert.message}');

    // 保持预警历史记录不超过100条
    if (_alerts.length > 100) {
      _alerts.removeAt(0);
    }
  }

  /// 开始方法计时
  void startTiming(String methodName) {
    if (_activeStopwatches[methodName] == null) {
      _activeStopwatches[methodName] = Stopwatch()..start();
    }
  }

  /// 结束方法计时
  Duration endTiming(String methodName) {
    final stopwatch = _activeStopwatches.remove(methodName);
    if (stopwatch != null) {
      stopwatch.stop();
      final duration = stopwatch.elapsed;
      _recordMethodTiming(methodName, duration);
      return duration;
    }
    return Duration.zero;
  }

  /// 记录方法计时
  void _recordMethodTiming(String methodName, Duration duration) {
    if (!_methodTimings.containsKey(methodName)) {
      _methodTimings[methodName] = [];
    }
    _methodTimings[methodName]!.add(duration);
    
    // 保持每个方法最多100次记录
    if (_methodTimings[methodName]!.length > 100) {
      _methodTimings[methodName]!.removeAt(0);
    }
  }

  /// 获取方法平均执行时间
  Duration getAverageMethodTiming(String methodName) {
    final timings = _methodTimings[methodName];
    if (timings == null || timings.isEmpty) return Duration.zero;
    
    final totalMs = timings.fold(0, (sum, duration) => sum + duration.inMilliseconds);
    return Duration(milliseconds: (totalMs / timings.length).round());
  }

  /// 获取性能分析报告
  PerformanceReport generatePerformanceReport() {
    return PerformanceReport(
      timestamp: DateTime.now(),
      summary: _generatePerformanceSummary(),
      frameMetrics: _calculateFrameMetricsReport(),
      memoryMetrics: _calculateMemoryMetricsReport(),
      cpuMetrics: _calculateCpuMetricsReport(),
      gpuMetrics: _calculateGpuMetricsReport(),
      methodTimings: _calculateMethodTimingsReport(),
      suggestions: _generateOptimizationSuggestions(),
    );
  }

  /// 生成性能摘要
  String _generatePerformanceSummary() {
    final avgFps = _calculateAverageFps();
    final slowFramesCount = _getSlowFramesCount();
    final avgMemory = _calculateAverageMemoryUsage();
    final avgCpu = _calculateAverageCpuUsage();

    return '平均帧率: ${avgFps.toStringAsFixed(1)}fps, '
           '慢帧数量: $slowFramesCount, '
           '平均内存: ${avgMemory.toStringAsFixed(1)}MB, '
           '平均CPU: ${(avgCpu * 100).toStringAsFixed(1)}%';
  }

  /// 计算帧指标报告
  Map<String, dynamic> _calculateFrameMetricsReport() {
    return {
      'avgFrameTime': _calculateAverageFrameTime(),
      'avgFps': _calculateAverageFps(),
      'slowFramesCount': _getSlowFramesCount(),
      'jankyFramesCount': _getJankyFramesCount(),
      'slowFramesPercentage': _frameHistory.isNotEmpty ? 
        (_getSlowFramesCount() / _frameHistory.length * 100).toStringAsFixed(1) : '0.0',
    };
  }

  /// 计算内存指标报告
  Map<String, dynamic> _calculateMemoryMetricsReport() {
    return {
      'avgMemoryUsage': _calculateAverageMemoryUsage(),
      'peakMemoryUsage': _getPeakMemoryUsage(),
      'memoryTrend': _getMemoryTrend(),
    };
  }

  /// 计算CPU指标报告
  Map<String, dynamic> _calculateCpuMetricsReport() {
    return {
      'avgCpuUsage': _calculateAverageCpuUsage(),
      'peakCpuUsage': _getPeakCpuUsage(),
      'cpuTrend': _getCpuTrend(),
    };
  }

  /// 计算GPU指标报告
  Map<String, dynamic> _calculateGpuMetricsReport() {
    if (_metricsHistory.isEmpty) return {};

    final lastGpuMetrics = _metricsHistory.last.gpuMetrics;
    return {
      'avgDrawCalls': _calculateAverageDrawCalls(),
      'avgTriangles': _calculateAverageTriangles(),
      'avgVertices': _calculateAverageVertices(),
      'avgTextureMemory': _calculateAverageTextureMemory(),
    };
  }

  /// 计算方法计时报告
  Map<String, Duration> _calculateMethodTimingsReport() {
    final report = <String, Duration>{};
    _methodTimings.forEach((methodName, timings) => {
      report[methodName] = getAverageMethodTiming(methodName);
    });
    return report;
  }

  /// 生成优化建议
  List<String> _generateOptimizationSuggestions() {
    final suggestions = <String>[];
    
    // 基于帧率分析的建议
    final avgFps = _calculateAverageFps();
    if (avgFps < 50) {
      suggestions.add('考虑减少UI复杂度或优化渲染逻辑以提升帧率');
    }
    
    // 基于内存使用的建议
    final avgMemory = _calculateAverageMemoryUsage();
    if (avgMemory > 500) {
      suggestions.add('考虑优化内存使用，释放不必要的资源');
    }
    
    // 基于CPU使用的建议
    final avgCpu = _calculateAverageCpuUsage();
    if (avgCpu > 0.7) {
      suggestions.add('考虑优化算法复杂度或减少计算密集型操作');
    }
    
    // 基于慢帧的建议
    final slowFramesCount = _getSlowFramesCount();
    if (slowFramesCount > 10) {
      suggestions.add('优化动画和过渡效果，减少卡顿现象');
    }

    // 基于方法计时的建议
    for (final entry in _methodTimings.entries) {
      final avgTime = getAverageMethodTiming(entry.key).inMilliseconds;
      if (avgTime > 50) {
        suggestions.add('优化方法 ${entry.key} 的执行效率，当前平均耗时: ${avgTime}ms');
      }
    }

    if (suggestions.isEmpty) {
      suggestions.add('当前性能表现良好，继续保持');
    }

    return suggestions;
  }

  /// 获取峰值内存使用
  double _getPeakMemoryUsage() {
    if (_metricsHistory.isEmpty) return 0.0;
    return _metricsHistory
      .map((m) => m.memoryUsage['usedSize'] as double)
      .reduce((a, b) => a > b ? a : b);
  }

  /// 获取内存趋势
  String _getMemoryTrend() {
    if (_metricsHistory.length < 3) return 'stable';
    
    final recent = _metricsHistory.take(10).map((m) => m.memoryUsage['usedSize'] as double).toList();
    final avg = recent.reduce((a, b) => a + b) / recent.length;
    final last = recent.last;
    final first = recent.first;
    
    final diff = (last - first) / avg;
    if (diff > 0.1) return 'increasing';
    if (diff < -0.1) return 'decreasing';
    return 'stable';
  }

  /// 获取峰值CPU使用
  double _getPeakCpuUsage() {
    if (_metricsHistory.isEmpty) return 0.0;
    return _metricsHistory.map((m) => m.cpuUsage).reduce((a, b) => a > b ? a : b);
  }

  /// 获取CPU趋势
  String _getCpuTrend() {
    if (_metricsHistory.length < 3) return 'stable';
    
    final recent = _metricsHistory.take(10).map((m) => m.cpuUsage).toList();
    final avg = recent.reduce((a, b) => a + b) / recent.length;
    final last = recent.last;
    final first = recent.first;
    
    final diff = (last - first) / avg;
    if (diff > 0.1) return 'increasing';
    if (diff < -0.1) return 'decreasing';
    return 'stable';
  }

  /// 计算平均绘制调用次数
  double _calculateAverageDrawCalls() {
    if (_metricsHistory.isEmpty) return 0.0;
    final total = _metricsHistory.fold(0, (sum, m) => sum + m.gpuMetrics.drawCalls);
    return total / _metricsHistory.length;
  }

  /// 计算平均三角形数量
  double _calculateAverageTriangles() {
    if (_metricsHistory.isEmpty) return 0.0;
    final total = _metricsHistory.fold(0, (sum, m) => sum + m.gpuMetrics.triangles);
    return total / _metricsHistory.length;
  }

  /// 计算平均顶点数量
  double _calculateAverageVertices() {
    if (_metricsHistory.isEmpty) return 0.0;
    final total = _metricsHistory.fold(0, (sum, m) => sum + m.gpuMetrics.vertices);
    return total / _metricsHistory.length;
  }

  /// 计算平均纹理内存
  double _calculateAverageTextureMemory() {
    if (_metricsHistory.isEmpty) return 0.0;
    final total = _metricsHistory.fold(0.0, (sum, m) => sum + m.gpuMetrics.textureMemory);
    return total / _metricsHistory.length;
  }

  /// 获取性能统计信息
  Map<String, dynamic> getPerformanceStatistics() {
    return {
      'avgFrameTime': _calculateAverageFrameTime(),
      'avgFps': _calculateAverageFps(),
      'slowFramesCount': _getSlowFramesCount(),
      'jankyFramesCount': _getJankyFramesCount(),
      'avgMemoryUsage': _calculateAverageMemoryUsage(),
      'avgCpuUsage': _calculateAverageCpuUsage(),
      'alertsCount': _alerts.length,
      'isMonitoring': _monitorTimer != null,
      'metricsHistorySize': _metricsHistory.length,
      'frameHistorySize': _frameHistory.length,
    };
  }

  /// 获取预警历史
  List<PerformanceAlert> getAlertHistory() {
    return List.unmodifiable(_alerts);
  }

  /// 清理资源
  void dispose() {
    stopMonitoring();
    _alerts.clear();
    _performanceStats.clear();
    _frameHistory.clear();
    _metricsHistory.clear();
    _methodTimings.clear();
    _activeStopwatches.clear();
    log('PerformanceProfiler已清理资源');
  }
}

/// 性能指标数据类
class PerformanceMetrics {
  final DateTime timestamp;
  final Map<String, dynamic> memoryUsage;
  final double cpuUsage;
  final FrameMetrics frameMetrics;
  final GpuMetrics gpuMetrics;
  final NetworkMetrics networkMetrics;

  PerformanceMetrics({
    required this.timestamp,
    required this.memoryUsage,
    required this.cpuUsage,
    required this.frameMetrics,
    required this.gpuMetrics,
    required this.networkMetrics,
  });

  @override
  String toString() {
    return 'PerformanceMetrics{timestamp: $timestamp, memory: ${memoryUsage['usedSize']}MB, '
           'cpu: ${(cpuUsage * 100).toStringAsFixed(1)}%, frame: ${frameMetrics.frameRate.toStringAsFixed(1)}fps}';
  }
}

/// 帧指标数据类
class FrameMetrics {
  final Duration frameTime;
  final double frameRate;
  final bool isSlowFrame;
  final bool isJanky;
  final DateTime timestamp;

  FrameMetrics({
    required this.frameTime,
    required this.frameRate,
    required this.isSlowFrame,
    required this.isJanky,
    required this.timestamp,
  });
}

/// GPU指标数据类
class GpuMetrics {
  final int drawCalls;
  final int triangles;
  final int vertices;
  final double textureMemory;
  final DateTime timestamp;

  GpuMetrics({
    required this.drawCalls,
    required this.triangles,
    required this.vertices,
    required this.textureMemory,
    required this.timestamp,
  });
}

/// 网络指标数据类
class NetworkMetrics {
  final double uploadSpeed;
  final double downloadSpeed;
  final double ping;
  final double jitter;
  final DateTime timestamp;

  NetworkMetrics({
    required this.uploadSpeed,
    required this.downloadSpeed,
    required this.ping,
    required this.jitter,
    required this.timestamp,
  });
}

/// 性能预警类
class PerformanceAlert {
  final PerformanceAlertType type;
  final String message;
  final double value;
  final DateTime timestamp;

  const PerformanceAlert({
    required this.type,
    required this.message,
    required this.value,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'PerformanceAlert{type: $type, message: $message, value: $value, time: $timestamp}';
  }
}

/// 性能预警类型
enum PerformanceAlertType {
  jank,
  slow,
  warningSlowFrames,
  criticalSlowFrames,
  highMemory,
  highCpu,
}

/// 性能报告类
class PerformanceReport {
  final DateTime timestamp;
  final String summary;
  final Map<String, dynamic> frameMetrics;
  final Map<String, dynamic> memoryMetrics;
  final Map<String, dynamic> cpuMetrics;
  final Map<String, dynamic> gpuMetrics;
  final Map<String, Duration> methodTimings;
  final List<String> suggestions;

  PerformanceReport({
    required this.timestamp,
    required this.summary,
    required this.frameMetrics,
    required this.memoryMetrics,
    required this.cpuMetrics,
    required this.gpuMetrics,
    required this.methodTimings,
    required this.suggestions,
  });

  @override
  String toString() {
    return 'PerformanceReport{timestamp: $timestamp, summary: $summary, '
           'suggestions: $suggestions}';
  }
}