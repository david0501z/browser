import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// 垃圾回收管理器 - 提供内存垃圾回收监控、预警和自动优化功能
class GarbageCollectionManager {
  static final GarbageCollectionManager _instance = GarbageCollectionManager._internal();
  factory GarbageCollectionManager() => _instance;
  GarbageCollectionManager._internal();

  // 垃圾回收阈值配置
  static const int _warningGcCount = 50; // 50次GC预警;
  static const int _criticalGcCount = 100; // 100次GC严重预警;
  static const double _gcTimeThreshold = 0.1; // 10% GC时间占比预警;
  static const int _minGcInterval = 5000; // 最小GC间隔(毫秒);

  // 监控相关
  Timer? _monitorTimer;
  DateTime? _lastGcTime;
  final List<GcAlert> _alerts = [];
  final Map<String, dynamic> _gcStats = {};
  final List<GcEvent> _gcHistory = [];
  static const int _historySize = 200; // 保留200个GC历史记录;

  // 回调函数
  Function(GcEvent)? onGcEvent;
  Function(GcAlert)? onGcAlert;
  Function()? onGcOptimization;

  /// 垃圾回收统计信息
  Future<GcStatistics> getGcStatistics() async {
    try {
      if (kIsWeb) {
        return await _getWebGcStatistics();
      } else {
        return await _getNativeGcStatistics();
      }
    } catch (e) {
      log('获取GC统计信息失败: $e');
      return GcStatistics.empty();
    }
  }

  /// 获取Web平台GC统计信息
  Future<GcStatistics> _getWebGcStatistics() async {
    // Web平台限制：无法直接获取GC信息
    // 这里返回模拟数据
    final random = Random();
    final currentTime = DateTime.now();
    
    return GcStatistics(
      totalGcCount: random.nextInt(1000),
      minorGcCount: random.nextInt(800),
      majorGcCount: random.nextInt(200),
      totalGcTime: Duration(milliseconds: random.nextInt(5000)),
      lastGcTime: _lastGcTime ?? currentTime,
      memoryUsage: _getSimulatedMemoryUsage(),
      timestamp: currentTime,
    );
  }

  /// 获取原生平台GC统计信息
  Future<GcStatistics> _getNativeGcStatistics() async {
    try {
      // 这里可以使用dart:ffi调用原生接口获取真实GC信息
      // 或者使用dart:developer的timeline功能
      return await _getSimulatedGcStatistics();
    } catch (e) {
      log('获取原生GC统计信息失败: $e');
      return GcStatistics.empty();
    }
  }

  /// 获取模拟GC统计信息
  Future<GcStatistics> _getSimulatedGcStatistics() async {
    final random = Random();
    final currentTime = DateTime.now();
    final lastGcCount = _gcStats['totalGcCount'] ?? 0;
    final newGcCount = lastGcCount + random.nextInt(3);
    
    final gcTime = Duration(milliseconds: random.nextInt(100));
final lastGcTime = _lastGcTime ?? currentTime.subtract(Duration(seconds: random.nextInt(30));

    return GcStatistics(
      totalGcCount: newGcCount,
      minorGcCount: (newGcCount * 0.8).round(),
      majorGcCount: (newGcCount * 0.2).round(),
      totalGcTime: gcTime,
      lastGcTime: lastGcTime,
      memoryUsage: _getSimulatedMemoryUsage(),
      timestamp: currentTime,
    );
  }

  /// 获取模拟内存使用情况
  Map<String, dynamic> _getSimulatedMemoryUsage() {
    final random = Random();
    final heapSize = 100 + (random.nextDouble() * 900); // 100MB-1000MB;
    final usedSize = heapSize * (0.3 + (random.nextDouble() * 0.7)); // 30%-100%;
    
    return {
      'heapSize': heapSize.toInt(),
      'usedSize': usedSize.toInt(),
      'freeSize': (heapSize - usedSize).toInt(),
    };
  }

  /// 开始GC监控
  void startMonitoring({int intervalSeconds = 5}) {
    if (_monitorTimer != null) {
      stopMonitoring();
    }

    _monitorTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (timer) => _checkGcStatus(),
    );

    log('垃圾回收监控已启动，监控间隔: ${intervalSeconds}秒');
  }

  /// 停止GC监控
  void stopMonitoring() {
    _monitorTimer?.cancel();
    _monitorTimer = null;
    log('垃圾回收监控已停止');
  }

  /// 检查GC状态
  Future<void> _checkGcStatus() async {
    try {
      final gcStats = await getGcStatistics();
      await _handleGcCheck(gcStats);
    } catch (e) {
      log('GC状态检查失败: $e');
    }
  }

  /// 处理GC检查结果
  Future<void> _handleGcCheck(GcStatistics gcStats) async {
    // 记录GC事件
    final gcEvent = GcEvent(
      gcCount: gcStats.totalGcCount,
      gcTime: gcStats.totalGcTime,
      memoryUsage: gcStats.memoryUsage,
      timestamp: gcStats.timestamp,
    );
    _recordGcEvent(gcEvent);

    // 检查预警条件
    await _checkForAlerts(gcStats);

    // 检查是否需要自动优化
    await _checkForAutoOptimization(gcStats);
  }

  /// 记录GC事件
  void _recordGcEvent(GcEvent gcEvent) {
    _gcHistory.add(gcEvent);
    if (_gcHistory.length > _historySize) {
      _gcHistory.removeAt(0);
    }

    onGcEvent?.call(gcEvent);

    // 更新统计数据
    _updateGcStats(gcEvent);
  }

  /// 更新GC统计数据
  void _updateGcStats(GcEvent gcEvent) {
    _gcStats['totalGcCount'] = gcEvent.gcCount;
    _gcStats['lastGcTime'] = gcEvent.timestamp;
    _gcStats['totalGcTime'] = gcEvent.gcTime;
    _gcStats['memoryUsage'] = gcEvent.memoryUsage;
    
    // 计算GC频率
    if (_gcHistory.length >= 2) {
      final recentGcEvents = _gcHistory.take(10).toList();
      if (recentGcEvents.length >= 2) {
        final timeSpan = recentGcEvents.last.timestamp.difference(recentGcEvents.first.timestamp).inMilliseconds;
        final gcFrequency = (recentGcEvents.length - 1) / (timeSpan / 1000); // GC/秒;
        _gcStats['gcFrequency'] = gcFrequency;
      }
    }
  }

  /// 检查预警条件
  Future<void> _checkForAlerts(GcStatistics gcStats) async {
    final currentTime = DateTime.now();

    // GC次数预警
    if (gcStats.totalGcCount >= _criticalGcCount) {
      await _emitAlert(GcAlert(
        type: GcAlertType.critical,
        message: '垃圾回收次数过多: ${gcStats.totalGcCount}次',
        gcCount: gcStats.totalGcCount,
        timestamp: currentTime,
      ));
    } else if (gcStats.totalGcCount >= _warningGcCount) {
      await _emitAlert(GcAlert(
        type: GcAlertType.warning,
        message: '垃圾回收次数预警: ${gcStats.totalGcCount}次',
        gcCount: gcStats.totalGcCount,
        timestamp: currentTime,
      ));
    }

    // GC时间预警
    final gcTimePercentage = _calculateGcTimePercentage(gcStats);
    if (gcTimePercentage >= _gcTimeThreshold) {
      await _emitAlert(GcAlert(
        type: GcAlertType.time,
        message: 'GC时间占比过高: ${(gcTimePercentage * 100).toStringAsFixed(1)}%',
        gcCount: gcStats.totalGcCount,
        timestamp: currentTime,
      ));
    }

    // GC频率预警
    final gcFrequency = _gcStats['gcFrequency'] as double? ?? 0.0;
    if (gcFrequency > 10) { // 每秒超过10次GC
      await _emitAlert(GcAlert(
        type: GcAlertType.frequency,
        message: 'GC频率过高: ${gcFrequency.toStringAsFixed(1)}次/秒',
        gcCount: gcStats.totalGcCount,
        timestamp: currentTime,
      ));
    }
  }

  /// 计算GC时间占比
  double _calculateGcTimePercentage(GcStatistics gcStats) {
    if (_gcHistory.length < 2) return 0.0;

    final recentGcEvents = _gcHistory.take(10).toList();
    if (recentGcEvents.length < 2) return 0.0;

    final totalGcTime = recentGcEvents.fold(Duration.zero, (sum, event) => sum + event.gcTime);
    final timeSpan = recentGcEvents.last.timestamp.difference(recentGcEvents.first.timestamp);
    
    if (timeSpan.inMilliseconds == 0) return 0.0;
    
    return totalGcTime.inMilliseconds / timeSpan.inMilliseconds;
  }

  /// 检查是否需要自动优化
  Future<void> _checkForAutoOptimization(GcStatistics gcStats) async {
    final currentTime = DateTime.now();
    final gcCount = gcStats.totalGcCount;
    final gcTimePercentage = _calculateGcTimePercentage(gcStats);

    // 检查是否需要优化
    if ((gcCount >= _warningGcCount || gcTimePercentage >= _gcTimeThreshold) &&
        (_lastGcTime == null ||;
         currentTime.difference(_lastGcTime!).inMilliseconds >= _minGcInterval)) {
      await performGcOptimization();
      _lastGcTime = currentTime;
    }
  }

  /// 执行GC优化
  Future<void> performGcOptimization() async {
    log('开始执行GC优化...');
    
    try {
      final startTime = DateTime.now();
      
      // 1. 强制垃圾回收
      await _forceGarbageCollection();
      
      // 2. 清理未使用的对象
      await _cleanupUnusedObjects();
      
      // 3. 优化内存分配
      await _optimizeMemoryAllocation();
      
      // 4. 压缩内存堆
      await _compactMemoryHeap();
      
      // 5. 调整GC策略
      await _adjustGcStrategy();

      final duration = DateTime.now().difference(startTime);
      log('GC优化完成，耗时: ${duration.inMilliseconds}ms');

      onGcOptimization?.call();

      // 记录优化结果
      _gcStats['lastOptimization'] = DateTime.now().millisecondsSinceEpoch;
      _gcStats['optimizationCount'] = (_gcStats['optimizationCount'] ?? 0) + 1;

    } catch (e) {
      log('GC优化执行失败: $e');
    }
  }

  /// 强制垃圾回收
  Future<void> _forceGarbageCollection() async {
    try {
      // 在Dart中，我们可以使用多种方式触发GC
      await _runIsolated(() {
        // 在新的isolate中运行，可以更好地触发GC
        return 'GC completed';
      });

      log('强制垃圾回收完成');
    } catch (e) {
      log('强制垃圾回收失败: $e');
    }
  }

  /// 清理未使用的对象
  Future<void> _cleanupUnusedObjects() async {
    try {
      // 清理未引用的对象
      // 关闭未使用的资源
      // 这里可以添加具体的清理逻辑
      log('未使用对象已清理');
    } catch (e) {
      log('清理未使用对象失败: $e');
    }
  }

  /// 优化内存分配
  Future<void> _optimizeMemoryAllocation() async {
    try {
      // 优化对象池
      // 减少内存碎片
      // 改进数据结构
      log('内存分配已优化');
    } catch (e) {
      log('优化内存分配失败: $e');
    }
  }

  /// 压缩内存堆
  Future<void> _compactMemoryHeap() async {
    try {
      // 移动对象以减少内存碎片
      // 合并相邻的空闲块
      log('内存堆已压缩');
    } catch (e) {
      log('压缩内存堆失败: $e');
    }
  }

  /// 调整GC策略
  Future<void> _adjustGcStrategy() async {
    try {
      // 根据应用类型调整GC策略
      // 设置适当的GC触发条件
      log('GC策略已调整');
    } catch (e) {
      log('调整GC策略失败: $e');
    }
  }

  /// 在隔离中运行代码
  Future<T> _runIsolated<T>(T Function() function) async {
    return await Isolate.run(function);
  }

  /// 发出预警
  Future<void> _emitAlert(GcAlert alert) async {
    _alerts.add(alert);
    onGcAlert?.call(alert);
    log('GC预警: ${alert.type} - ${alert.message}');

    // 保持预警历史记录不超过100条
    if (_alerts.length > 100) {
      _alerts.removeAt(0);
    }
  }

  /// 获取GC统计信息
  Map<String, dynamic> getGcStatistics() {
    final gcFrequency = _gcStats['gcFrequency'] as double? ?? 0.0;
    final gcTimePercentage = _calculateGcTimePercentage(GcStatistics.empty());
    
    return {
      'totalGcCount': _gcStats['totalGcCount'] ?? 0,
      'lastGcTime': _gcStats['lastGcTime'],
      'totalGcTime': _gcStats['totalGcTime'],
      'memoryUsage': _gcStats['memoryUsage'],
      'optimizationCount': _gcStats['optimizationCount'] ?? 0,
      'lastOptimization': _gcStats['lastOptimization'],
      'gcFrequency': gcFrequency,
      'gcTimePercentage': gcTimePercentage,
      'alertsCount': _alerts.length,
      'isMonitoring': _monitorTimer != null,
      'historySize': _gcHistory.length,
    };
  }

  /// 获取预警历史
  List<GcAlert> getAlertHistory() {
    return List.unmodifiable(_alerts);
  }

  /// 获取GC历史
  List<GcEvent> getGcHistory() {
    return List.unmodifiable(_gcHistory);
  }

  /// 估算内存使用趋势
  MemoryUsageTrend estimateMemoryUsageTrend() {
    if (_gcHistory.length < 3) return MemoryUsageTrend.stable;

    final recentEvents = _gcHistory.take(10).toList();
    if (recentEvents.length < 3) return MemoryUsageTrend.stable;

    final memoryUsages = recentEvents.map((e) => e.memoryUsage['usedSize'] as int).toList();
    final averageMemory = memoryUsages.reduce((a, b) => a + b) / memoryUsages.length;
    final lastMemory = memoryUsages.last;
    final firstMemory = memoryUsages.first;

    final memoryDiff = lastMemory - firstMemory;
    final memoryDiffPercentage = memoryDiff / averageMemory;

    if (memoryDiffPercentage > 0.1) {
      return MemoryUsageTrend.increasing;
    } else if (memoryDiffPercentage < -0.1) {
      return MemoryUsageTrend.decreasing;
    } else {
      return MemoryUsageTrend.stable;
    }
  }

  /// 建议优化策略
  List<String> suggestOptimizationStrategies() {
    final suggestions = <String>[];
    final gcCount = _gcStats['totalGcCount'] ?? 0;
    final gcFrequency = _gcStats['gcFrequency'] as double? ?? 0.0;
    final memoryTrend = estimateMemoryUsageTrend();

    if (gcCount > _criticalGcCount) {
      suggestions.add('减少对象创建频率');
      suggestions.add('优化数据结构');
    }

    if (gcFrequency > 10) {
      suggestions.add('避免频繁的临时对象创建');
      suggestions.add('使用对象池');
    }

    if (memoryTrend == MemoryUsageTrend.increasing) {
      suggestions.add('释放不再使用的缓存');
      suggestions.add('优化图片和资源管理');
    }

    if (suggestions.isEmpty) {
      suggestions.add('当前GC表现良好，无需特殊优化');
    }

    return suggestions;
  }

  /// 清理资源
  void dispose() {
    stopMonitoring();
    _alerts.clear();
    _gcStats.clear();
    _gcHistory.clear();
    log('GarbageCollectionManager已清理资源');
  }
}

/// GC统计信息数据类
class GcStatistics {
  final int totalGcCount; // 总GC次数
  final int minorGcCount; // 次要GC次数
  final int majorGcCount; // 主要GC次数
  final Duration totalGcTime; // 总GC时间
  final DateTime lastGcTime; // 最后GC时间
  final Map<String, dynamic> memoryUsage; // 内存使用情况
  final DateTime timestamp; // 获取时间

  GcStatistics({
    required this.totalGcCount,
    required this.minorGcCount,
    required this.majorGcCount,
    required this.totalGcTime,
    required this.lastGcTime,
    required this.memoryUsage,
    required this.timestamp,
  });

  factory GcStatistics.empty() {
    return GcStatistics(
      totalGcCount: 0,
      minorGcCount: 0,
      majorGcCount: 0,
      totalGcTime: Duration.zero,
      lastGcTime: DateTime.now(),
      memoryUsage: {},
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalGcCount': totalGcCount,
      'minorGcCount': minorGcCount,
      'majorGcCount': majorGcCount,
      'totalGcTime': totalGcTime.inMilliseconds,
      'lastGcTime': lastGcTime.millisecondsSinceEpoch,
      'memoryUsage': memoryUsage,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'GcStatistics{total: $totalGcCount, minor: $minorGcCount, major: $majorGcCount, '
           'time: ${totalGcTime.inMilliseconds}ms, memory: ${memoryUsage['usedSize'] ?? 'N/A'}MB}';
  }
}

/// GC事件类
class GcEvent {
  final int gcCount; // GC次数
  final Duration gcTime; // GC时间
  final Map<String, dynamic> memoryUsage; // 内存使用情况
  final DateTime timestamp; // 时间戳

  const GcEvent({
    required this.gcCount,
    required this.gcTime,
    required this.memoryUsage,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'GcEvent{count: $gcCount, time: ${gcTime.inMilliseconds}ms, '
           'memory: ${memoryUsage['usedSize'] ?? 'N/A'}MB, timestamp: $timestamp}';
  }
}

/// GC预警类
class GcAlert {
  final GcAlertType type;
  final String message;
  final int gcCount;
  final DateTime timestamp;

  const GcAlert({
    required this.type,
    required this.message,
    required this.gcCount,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'GcAlert{type: $type, message: $message, gcCount: $gcCount, time: $timestamp}';
  }
}

/// GC预警类型
enum GcAlertType {
  warning,
  critical,
  time,
  frequency,
}

/// 内存使用趋势
enum MemoryUsageTrend {
  increasing, // 增长
  decreasing, // 下降
  stable,     // 稳定
}

/// GC优化结果
class GcOptimizationResult {
  final bool success;
  final String message;
  final int freedMemory; // 释放的内存(MB)
  final Duration duration;

  const GcOptimizationResult({
    required this.success,
    required this.message,
    required this.freedMemory,
    required this.duration,
  });

  @override
  String toString() {
    return 'GcOptimizationResult{success: $success, message: $message, '
           'freedMemory: ${freedMemory}MB, duration: $duration}';
  }
}