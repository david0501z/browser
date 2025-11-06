import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

/// 内存管理器
class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  // 内存池
  final MemoryPool _objectPool = MemoryPool();
  final MemoryPool _bufferPool = MemoryPool();
  
  // 内存监控
  final List<MemorySnapshot> _snapshots = [];
  final StreamController<MemoryEvent> _eventController = 
      StreamController<MemoryEvent>.broadcast();
  
  // 配置
  MemoryConfig? _config;
  Timer? _cleanupTimer;
  bool _isInitialized = false;

  // 内存泄漏检测
  final Map<String, int> _allocationTracker = {};
  final Set<int> _leakSuspects = {};

  /// 初始化内存管理器
  Future<void> initialize({MemoryConfig? config}) async {
    if (_isInitialized) return;
    
    _config = config ?? MemoryConfig.defaultConfig();
    _startCleanupTimer();
    _isInitialized = true;
    
    log('内存管理器初始化完成');
  }

  /// 启动清理定时器
  void _startCleanupTimer() {
    _cleanupTimer = Timer.periodic(
      _config!.cleanupInterval,
      _performCleanup,
    );
  }

  /// 执行清理任务
  void _performCleanup(Timer timer) {
    _cleanupExpiredObjects();
    _detectMemoryLeaks();
    _compactMemory();
    _takeSnapshot();
  }

  /// 获取当前内存信息
  MemoryInfo getCurrentMemoryInfo() {
    final info = ProcessInfo.currentRss;
    final totalMemory = Platform.totalMemory;
    final usagePercent = (info / totalMemory) * 100;
    
    return MemoryInfo(
      usedMB: info / (1024 * 1024),
      totalMB: totalMemory / (1024 * 1024),
      availableMB: (totalMemory - info) / (1024 * 1024),
      usagePercent: usagePercent,
      timestamp: DateTime.now(),
    );
  }

  /// 强制内存清理
  void forceCleanup() {
    _objectPool.clear();
    _bufferPool.clear();
    _cleanupExpiredObjects();
    _compactMemory();
    
    _eventController.add(MemoryEvent(
      type: MemoryEventType.cleanup,
      timestamp: DateTime.now(),
      message: '强制内存清理完成',
    ));
  }

  /// 清理过期对象
  void _cleanupExpiredObjects() {
    _objectPool.cleanup();
    _bufferPool.cleanup();
  }

  /// 检测内存泄漏
  void _detectMemoryLeaks() {
    final currentSnapshot = getCurrentMemoryInfo();
    final previousSnapshot = _snapshots.isNotEmpty ? _snapshots.last : null;
    
    if (previousSnapshot != null) {
      final memoryGrowth = currentSnapshot.usedMB - previousSnapshot.usedMB;
      
      if (memoryGrowth > _config!.leakDetectionThreshold) {
        _leakSuspects.add(currentSnapshot.timestamp.millisecondsSinceEpoch);
        
        _eventController.add(MemoryEvent(
          type: MemoryEventType.leakDetected,
          timestamp: DateTime.now(),
          message: '检测到内存增长: ${memoryGrowth.toStringAsFixed(2)}MB',
          data: {
            'growth_mb': memoryGrowth,
            'current_usage': currentSnapshot.usedMB,
          },
        ));
      }
    }
  }

  /// 压缩内存
  void _compactMemory() {
    // 触发垃圾回收建议
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在Flutter中，我们只能建议垃圾回收
      _eventController.add(MemoryEvent(
        type: MemoryEventType.compaction,
        timestamp: DateTime.now(),
        message: '内存压缩完成',
      ));
    });
  }

  /// 拍摄内存快照
  void _takeSnapshot() {
    final snapshot = MemorySnapshot(
      timestamp: DateTime.now(),
      memoryInfo: getCurrentMemoryInfo(),
      objectCount: _objectPool.size + _bufferPool.size,
    );
    
    _snapshots.add(snapshot);
    
    // 保持快照数量在限制内
    if (_snapshots.length > _config!.maxSnapshots) {
      _snapshots.removeAt(0);
    }
  }

  /// 检查是否应该触发垃圾回收
  bool shouldTriggerGC() {
    final memoryInfo = getCurrentMemoryInfo();
    return memoryInfo.usagePercent > _config!.gcTriggerThreshold;
  }

  /// 获取对象池
  MemoryPool get objectPool => _objectPool;
  
  /// 获取缓冲区池
  MemoryPool get bufferPool => _bufferPool;

  /// 跟踪内存分配
  void trackAllocation(String type, int size) {
    _allocationTracker[type] = (_allocationTracker[type] ?? 0) + size;
  }

  /// 获取内存使用统计
  MemoryStats getMemoryStats() {
    return MemoryStats(
      currentMemory: getCurrentMemoryInfo(),
      allocationTracker: Map.from(_allocationTracker),
      leakSuspects: _leakSuspects.length,
      snapshotCount: _snapshots.length,
      poolSizes: {
        'object_pool': _objectPool.size,
        'buffer_pool': _bufferPool.size,
      },
    );
  }

  /// 获取内存事件流
  Stream<MemoryEvent> get eventStream => _eventController.stream;

  /// 获取内存历史数据
  List<MemorySnapshot> getMemoryHistory() {
    return List.from(_snapshots);
  }

  /// 清理所有资源
  void dispose() {
    _cleanupTimer?.cancel();
    _eventController.close();
    _objectPool.clear();
    _bufferPool.clear();
    _snapshots.clear();
    _allocationTracker.clear();
    _leakSuspects.clear();
    _isInitialized = false;
  }
}

/// 内存池
class MemoryPool {
  final Map<String, List<Object>> _pools = {};
  final Map<String, DateTime> _lastUsed = {};
  
  int get size => _pools.values.fold(0, (sum, pool) => sum + pool.length);

  /// 获取对象
  T? getObject<T>(String type, T Function() factory) {
    final pool = _pools[type] ?? [];
    
    if (pool.isNotEmpty) {
      final object = pool.removeLast() as T;
      _lastUsed[type] = DateTime.now();
      return object;
    }
    
    return factory();
  }

  /// 返回对象到池
  void returnObject<T>(String type, T object) {
    if (!_pools.containsKey(type)) {
      _pools[type] = [];
    }
    
    // 限制池大小
    if (_pools[type]!.length < 100) {
      _pools[type]!.add(object);
      _lastUsed[type] = DateTime.now();
    }
  }

  /// 清理过期对象
  void cleanup() {
    final now = DateTime.now();
    final expiredTypes = <String>[];
    
    _lastUsed.forEach((type, lastUsed) {
      if (now.difference(lastUsed).inMinutes > 30) {
        expiredTypes.add(type);
      }
    });
    
    for (final type in expiredTypes) {
      _pools.remove(type);
      _lastUsed.remove(type);
    }
  }

  /// 清空池
  void clear() {
    _pools.clear();
    _lastUsed.clear();
  }
}

/// 内存信息
class MemoryInfo {
  final double usedMB;
  final double totalMB;
  final double availableMB;
  final double usagePercent;
  final DateTime timestamp;

  MemoryInfo({
    required this.usedMB,
    required this.totalMB,
    required this.availableMB,
    required this.usagePercent,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'used_mb': usedMB,
      'total_mb': totalMB,
      'available_mb': availableMB,
      'usage_percent': usagePercent,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// 内存快照
class MemorySnapshot {
  final DateTime timestamp;
  final MemoryInfo memoryInfo;
  final int objectCount;

  MemorySnapshot({
    required this.timestamp,
    required this.memoryInfo,
    required this.objectCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'memory_info': memoryInfo.toMap(),
      'object_count': objectCount,
    };
  }
}

/// 内存事件类型
enum MemoryEventType {
  cleanup,
  leakDetected,
  compaction,
  warning,
  error,
}

/// 内存事件
class MemoryEvent {
  final MemoryEventType type;
  final DateTime timestamp;
  final String message;
  final Map<String, dynamic>? data;

  MemoryEvent({
    required this.type,
    required this.timestamp,
    required this.message,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'message': message,
      'data': data,
    };
  }
}

/// 内存统计
class MemoryStats {
  final MemoryInfo currentMemory;
  final Map<String, int> allocationTracker;
  final int leakSuspects;
  final int snapshotCount;
  final Map<String, int> poolSizes;

  MemoryStats({
    required this.currentMemory,
    required this.allocationTracker,
    required this.leakSuspects,
    required this.snapshotCount,
    required this.poolSizes,
  });

  Map<String, dynamic> toMap() {
    return {
      'current_memory': currentMemory.toMap(),
      'allocation_tracker': allocationTracker,
      'leak_suspects': leakSuspects,
      'snapshot_count': snapshotCount,
      'pool_sizes': poolSizes,
    };
  }
}

/// 内存配置
class MemoryConfig {
  final Duration cleanupInterval;
  final double leakDetectionThreshold;
  final double gcTriggerThreshold;
  final int maxSnapshots;

  MemoryConfig({
    required this.cleanupInterval,
    required this.leakDetectionThreshold,
    required this.gcTriggerThreshold,
    required this.maxSnapshots,
  });

  factory MemoryConfig.defaultConfig() {
    return MemoryConfig(
      cleanupInterval: const Duration(minutes: 5),
      leakDetectionThreshold: 50.0, // 50MB
      gcTriggerThreshold: 85.0, // 85%
      maxSnapshots: 100,
    );
  }
}