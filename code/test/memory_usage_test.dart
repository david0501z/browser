import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;

/// 内存使用测试套件
/// 专门用于测试应用的内存使用情况和垃圾回收效果
class MemoryUsageTest {
  static const String _tag = 'MemoryUsageTest';
  
  // 内存监控配置
  static const int _monitoringIntervalMs = 1000; // 监控间隔1秒
  static const int _maxMemoryThreshold = 256 * 1024 * 1024; // 256MB阈值
  static const int _warningMemoryThreshold = 128 * 1024 * 1024; // 128MB警告阈值
  
  // 内存使用记录
  final List<MemorySnapshot> _memorySnapshots = [];
  final List<MemoryLeak> _detectedLeaks = [];
  StreamController<MemorySnapshot>? _memoryStreamController;
  
  // 内存监控状态
  bool _isMonitoring = false;
  Timer? _monitoringTimer;

  /// 开始内存监控
  Stream<MemorySnapshot> startMonitoring() {
    if (_isMonitoring) {
      log('内存监控已在运行中', name: _tag);
      return _memoryStreamController?.stream ?? const Stream.empty();
    }
    
    _isMonitoring = true;
    _memoryStreamController = StreamController<MemorySnapshot>.broadcast();
    _monitoringTimer = Timer.periodic(
      Duration(milliseconds: _monitoringIntervalMs),
      _collectMemorySnapshot,
    );
    
    log('开始内存监控', name: _tag);
    return _memoryStreamController!.stream;
  }

  /// 停止内存监控
  void stopMonitoring() {
    if (!_isMonitoring) return;
    
    _isMonitoring = false;
    _monitoringTimer?.cancel();
    _memoryStreamController?.close();
    _memoryStreamController = null;
    
    log('停止内存监控', name: _tag);
  }

  /// 收集内存快照
  void _collectMemorySnapshot(Timer timer) async {
    if (!_isMonitoring) return;
    
    try {
      final snapshot = await _createMemorySnapshot();
      _memorySnapshots.add(snapshot);
      
      // 检测内存泄漏
      _detectMemoryLeaks(snapshot);
      
      // 检查内存使用是否超限
      if (snapshot.usedMemory > _maxMemoryThreshold) {
        log('内存使用超过最大阈值: ${snapshot.usedMemory / (1024 * 1024)}MB', 
            name: _tag, level: 1000);
      }
      
      _memoryStreamController?.add(snapshot);
      
      // 保持快照列表在合理大小
      if (_memorySnapshots.length > 1000) {
        _memorySnapshots.removeRange(0, 500);
      }
      
    } catch (e, stackTrace) {
      log('收集内存快照失败: $e', name: _tag, error: e, stackTrace: stackTrace);
    }
  }

  /// 创建内存快照
  Future<MemorySnapshot> _createMemorySnapshot() async {
    final timestamp = DateTime.now();
    
    // 获取当前内存使用情况
    final memoryInfo = await _getMemoryInfo();
    
    return MemorySnapshot(
      timestamp: timestamp,
      usedMemory: memoryInfo['used'] ?? 0,
      totalMemory: memoryInfo['total'] ?? 0,
      availableMemory: memoryInfo['available'] ?? 0,
      gcCount: memoryInfo['gcCount'] ?? 0,
      heapSize: memoryInfo['heapSize'] ?? 0,
      nativeHeapSize: memoryInfo['nativeHeapSize'] ?? 0,
    );
  }

  /// 获取内存信息
  Future<Map<String, int>> _getMemoryInfo() async {
    // 在实际实现中，这里应该调用平台特定的API
    // 例如Android的ActivityManager.getMemoryInfo()或iOS的vm_statistics
    
    // 这里使用模拟数据
    final random = math.Random();
    final baseMemory = 64 * 1024 * 1024; // 64MB基础内存
    
    return {
      'used': baseMemory + (random.nextInt(32) * 1024 * 1024), // 64-96MB
      'total': 256 * 1024 * 1024, // 256MB总内存
      'available': 256 * 1024 * 1024 - baseMemory - (random.nextInt(32) * 1024 * 1024),
      'gcCount': random.nextInt(10),
      'heapSize': baseMemory + (random.nextInt(16) * 1024 * 1024),
      'nativeHeapSize': baseMemory + (random.nextInt(24) * 1024 * 1024),
    };
  }

  /// 检测内存泄漏
  void _detectMemoryLeaks(MemorySnapshot snapshot) {
    if (_memorySnapshots.length < 10) return;
    
    // 检查最近10个快照的内存增长趋势
    final recentSnapshots = _memorySnapshots.takeLast(10).toList();
    final memoryGrowth = _calculateMemoryGrowth(recentSnapshots);
    
    if (memoryGrowth > 10 * 1024 * 1024) { // 10MB增长
      _detectedLeaks.add(MemoryLeak(
        timestamp: snapshot.timestamp,
        severity: memoryGrowth > 50 * 1024 * 1024 ? LeakSeverity.High : LeakSeverity.Medium,
        description: '检测到持续内存增长: ${(memoryGrowth / (1024 * 1024)).toStringAsFixed(2)}MB',
        suggestedAction: _getLeakSuggestion(memoryGrowth),
      ));
      
      log('检测到内存泄漏: ${memoryGrowth / (1024 * 1024)}MB', name: _tag, level: 500);
    }
  }

  /// 计算内存增长
  double _calculateMemoryGrowth(List<MemorySnapshot> snapshots) {
    if (snapshots.length < 2) return 0;
    
    final firstMemory = snapshots.first.usedMemory;
    final lastMemory = snapshots.last.usedMemory;
    
    return lastMemory - firstMemory;
  }

  /// 获取泄漏建议
  String _getLeakSuggestion(double memoryGrowth) {
    if (memoryGrowth > 100 * 1024 * 1024) {
      return '建议立即检查大对象生命周期，及时释放不再使用的资源';
    } else if (memoryGrowth > 50 * 1024 * 1024) {
      return '建议检查缓存策略和资源释放机制';
    } else {
      return '建议优化对象创建和销毁逻辑';
    }
  }

  /// 执行内存压力测试
  Future<MemoryStressTestResult> performMemoryStressTest() async {
    log('开始内存压力测试', name: _tag);
    
    final result = MemoryStressTestResult();
    final stopwatch = Stopwatch()..start();
    
    try {
      // 记录初始内存状态
      final initialSnapshot = await _createMemorySnapshot();
      result.initialSnapshot = initialSnapshot;
      
      // 执行各种内存压力场景
      await _testLargeObjectCreation(result);
      await _testFrequentObjectCreation(result);
      await _testMemoryLeakScenario(result);
      await _testCacheGrowthScenario(result);
      
      // 执行垃圾回收
      await _performGarbageCollection();
      
      // 记录最终内存状态
      final finalSnapshot = await _createMemorySnapshot();
      result.finalSnapshot = finalSnapshot;
      
      // 分析结果
      result.memoryGrowth = finalSnapshot.usedMemory - initialSnapshot.usedMemory;
      result.memoryGrowthPercentage = (result.memoryGrowth / initialSnapshot.usedMemory) * 100;
      result.recoveryRate = _calculateRecoveryRate(initialSnapshot, finalSnapshot);
      result.passed = result.memoryGrowth < _warningMemoryThreshold;
      
      stopwatch.stop();
      result.testDuration = stopwatch.elapsedMilliseconds;
      
      log('内存压力测试完成，增长: ${result.memoryGrowth / (1024 * 1024)}MB', name: _tag);
      
    } catch (e, stackTrace) {
      result.error = e.toString();
      log('内存压力测试失败: $e', name: _tag, error: e, stackTrace: stackTrace);
    }
    
    return result;
  }

  /// 测试大对象创建
  Future<void> _testLargeObjectCreation(MemoryStressTestResult result) async {
    log('测试大对象创建', name: _tag);
    
    final largeObjects = <List<int>>[];
    final stopwatch = Stopwatch()..start();
    
    try {
      // 创建多个大对象
      for (int i = 0; i < 10; i++) {
        final largeObject = List.generate(1000000, (index) => index); // 1M integers
        largeObjects.add(largeObject);
        
        // 记录内存使用
        final snapshot = await _createMemorySnapshot();
        result.memorySamples.add(snapshot);
        
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
      stopwatch.stop();
      result.largeObjectTestDuration = stopwatch.elapsedMilliseconds;
      
      // 清理大对象
      largeObjects.clear();
      
    } catch (e) {
      result.largeObjectTestError = e.toString();
    }
  }

  /// 测试频繁对象创建
  Future<void> _testFrequentObjectCreation(MemoryStressTestResult result) async {
    log('测试频繁对象创建', name: _tag);
    
    final stopwatch = Stopwatch()..start();
    final createdObjects = <dynamic>[];
    
    try {
      // 快速创建和销毁大量小对象
      for (int i = 0; i < 10000; i++) {
        final obj = _createTestObject(i);
        createdObjects.add(obj);
        
        // 每1000个对象清理一次
        if (i % 1000 == 0) {
          createdObjects.clear();
          final snapshot = await _createMemorySnapshot();
          result.memorySamples.add(snapshot);
        }
      }
      
      // 最终清理
      createdObjects.clear();
      
      stopwatch.stop();
      result.frequentObjectTestDuration = stopwatch.elapsedMilliseconds;
      
    } catch (e) {
      result.frequentObjectTestError = e.toString();
    }
  }

  /// 测试内存泄漏场景
  Future<void> _testMemoryLeakScenario(MemoryStressTestResult result) async {
    log('测试内存泄漏场景', name: _tag);
    
    final stopwatch = Stopwatch()..start();
    final leakedObjects = <_LeakTestObject>[];
    
    try {
      // 创建可能导致泄漏的对象
      for (int i = 0; i < 1000; i++) {
        final obj = _LeakTestObject(i);
        leakedObjects.add(obj);
        
        // 模拟对象被持有但不再使用
        if (i % 100 == 0) {
          final snapshot = await _createMemorySnapshot();
          result.memorySamples.add(snapshot);
        }
      }
      
      // 注意：这里故意不清理对象来模拟泄漏
      // 在实际测试中，应该测试泄漏检测和清理机制
      
      stopwatch.stop();
      result.leakTestDuration = stopwatch.elapsedMilliseconds;
      
    } catch (e) {
      result.leakTestError = e.toString();
    }
  }

  /// 测试缓存增长场景
  Future<void> _testCacheGrowthScenario(MemoryStressTestResult result) async {
    log('测试缓存增长场景', name: _tag);
    
    final stopwatch = Stopwatch()..start();
    final cache = <String, List<int>>{};
    
    try {
      // 模拟缓存不断增长
      for (int i = 0; i < 100; i++) {
        final key = 'cache_key_$i';
        final value = List.generate(10000, (index) => index);
        cache[key] = value;
        
        // 记录内存使用
        if (i % 10 == 0) {
          final snapshot = await _createMemorySnapshot();
          result.memorySamples.add(snapshot);
        }
      }
      
      // 测试缓存清理
      cache.clear();
      
      stopwatch.stop();
      result.cacheTestDuration = stopwatch.elapsedMilliseconds;
      
    } catch (e) {
      result.cacheTestError = e.toString();
    }
  }

  /// 执行垃圾回收
  Future<void> _performGarbageCollection() async {
    log('执行垃圾回收', name: _tag);
    
    // 在Flutter中，无法直接触发GC
    // 这里模拟垃圾回收过程
    await Future.delayed(const Duration(milliseconds: 500));
    
    // 强制释放一些变量
    // 在实际实现中，可以使用System.gc() (Android) 或 objc_msgSend (iOS)
  }

  /// 计算恢复率
  double _calculateRecoveryRate(MemorySnapshot initial, MemorySnapshot finalSnapshot) {
    final memoryBeforeGC = finalSnapshot.usedMemory;
    // 模拟GC后的内存使用
    final memoryAfterGC = memoryBeforeGC * 0.8; // 假设80%的内存被回收
    
    return ((memoryBeforeGC - memoryAfterGC) / (finalSnapshot.usedMemory - initial.usedMemory)) * 100;
  }

  /// 创建测试对象
  dynamic _createTestObject(int id) {
    return {
      'id': id,
      'data': List.generate(100, (index) => 'data_$index'),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  /// 获取内存使用历史
  List<MemorySnapshot> getMemoryHistory() => List.unmodifiable(_memorySnapshots);
  
  /// 获取检测到的内存泄漏
  List<MemoryLeak> getDetectedLeaks() => List.unmodifiable(_detectedLeaks);
  
  /// 生成内存使用报告
  MemoryReport generateMemoryReport() {
    final report = MemoryReport();
    
    if (_memorySnapshots.isEmpty) return report;
    
    final memories = _memorySnapshots.map((s) => s.usedMemory).toList();
    final totalMemory = _memorySnapshots.map((s) => s.totalMemory).toList();
    
    report.averageMemoryUsage = memories.reduce((a, b) => a + b) / memories.length;
    report.peakMemoryUsage = memories.reduce(math.max);
    report.minMemoryUsage = memories.reduce(math.min);
    report.memoryVariance = _calculateVariance(memories);
    report.averageUtilization = (report.averageMemoryUsage / totalMemory.first) * 100;
    report.leakCount = _detectedLeaks.length;
    report.totalSnapshots = _memorySnapshots.length;
    report.monitoringDuration = _memorySnapshots.isNotEmpty 
      ? _memorySnapshots.last.timestamp.difference(_memorySnapshots.first.timestamp).inSeconds
      : 0;
    
    return report;
  }

  /// 计算方差
  double _calculateVariance(List<double> values) {
    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDiffs = values.map((v) => math.pow(v - mean, 2)).toList();
    return squaredDiffs.reduce((a, b) => a + b) / squaredDiffs.length;
  }
}

/// 内存快照类
class MemorySnapshot {
  final DateTime timestamp;
  final int usedMemory; // 已使用内存(字节)
  final int totalMemory; // 总内存(字节)
  final int availableMemory; // 可用内存(字节)
  final int gcCount; // GC次数
  final int heapSize; // 堆大小
  final int nativeHeapSize; // 原生堆大小

  MemorySnapshot({
    required this.timestamp,
    required this.usedMemory,
    required this.totalMemory,
    required this.availableMemory,
    required this.gcCount,
    required this.heapSize,
    required this.nativeHeapSize,
  });

  double get usedMemoryMB => usedMemory / (1024 * 1024);
  double get totalMemoryMB => totalMemory / (1024 * 1024);
  double get availableMemoryMB => availableMemory / (1024 * 1024);
  double get utilization => (usedMemory / totalMemory) * 100;

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'usedMemory': usedMemory,
    'totalMemory': totalMemory,
    'availableMemory': availableMemory,
    'gcCount': gcCount,
    'heapSize': heapSize,
    'nativeHeapSize': nativeHeapSize,
    'usedMemoryMB': usedMemoryMB,
    'totalMemoryMB': totalMemoryMB,
    'availableMemoryMB': availableMemoryMB,
    'utilization': utilization,
  };
}

/// 内存泄漏类
class MemoryLeak {
  final DateTime timestamp;
  final LeakSeverity severity;
  final String description;
  final String suggestedAction;

  MemoryLeak({
    required this.timestamp,
    required this.severity,
    required this.description,
    required this.suggestedAction,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'severity': severity.toString(),
    'description': description,
    'suggestedAction': suggestedAction,
  };
}

/// 泄漏严重程度
enum LeakSeverity {
  Low,
  Medium,
  High,
  Critical,
}

/// 内存压力测试结果
class MemoryStressTestResult {
  MemorySnapshot? initialSnapshot;
  MemorySnapshot? finalSnapshot;
  List<MemorySnapshot> memorySamples = [];
  int memoryGrowth = 0;
  double memoryGrowthPercentage = 0.0;
  double recoveryRate = 0.0;
  bool passed = false;
  int testDuration = 0;
  String? error;
  
  // 各项测试的详细结果
  int? largeObjectTestDuration;
  String? largeObjectTestError;
  int? frequentObjectTestDuration;
  String? frequentObjectTestError;
  int? leakTestDuration;
  String? leakTestError;
  int? cacheTestDuration;
  String? cacheTestError;

  Map<String, dynamic> toJson() => {
    'initialSnapshot': initialSnapshot?.toJson(),
    'finalSnapshot': finalSnapshot?.toJson(),
    'memorySamples': memorySamples.map((s) => s.toJson()).toList(),
    'memoryGrowth': memoryGrowth,
    'memoryGrowthPercentage': memoryGrowthPercentage,
    'recoveryRate': recoveryRate,
    'passed': passed,
    'testDuration': testDuration,
    'error': error,
    'largeObjectTestDuration': largeObjectTestDuration,
    'largeObjectTestError': largeObjectTestError,
    'frequentObjectTestDuration': frequentObjectTestDuration,
    'frequentObjectTestError': frequentObjectTestError,
    'leakTestDuration': leakTestDuration,
    'leakTestError': leakTestError,
    'cacheTestDuration': cacheTestDuration,
    'cacheTestError': cacheTestError,
  };
}

/// 内存使用报告
class MemoryReport {
  double averageMemoryUsage = 0.0;
  double peakMemoryUsage = 0.0;
  double minMemoryUsage = 0.0;
  double memoryVariance = 0.0;
  double averageUtilization = 0.0;
  int leakCount = 0;
  int totalSnapshots = 0;
  int monitoringDuration = 0;

  Map<String, dynamic> toJson() => {
    'averageMemoryUsage': averageMemoryUsage,
    'peakMemoryUsage': peakMemoryUsage,
    'minMemoryUsage': minMemoryUsage,
    'memoryVariance': memoryVariance,
    'averageUtilization': averageUtilization,
    'leakCount': leakCount,
    'totalSnapshots': totalSnapshots,
    'monitoringDuration': monitoringDuration,
  };
}

/// 测试用泄漏对象
class _LeakTestObject {
  final int id;
  final List<String> data;
  _LeakTestObject(this.id) : data = List.generate(1000, (index) => 'data_$index');
  
  @override
  String toString() => 'LeakTestObject(id: $id, dataSize: ${data.length})';
}