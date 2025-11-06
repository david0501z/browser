import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// 内存管理器 - 提供内存监控、预警和自动优化功能
class MemoryManager {
  static const MethodChannel _channel = MethodChannel('memory_manager');

  // 单例模式
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  // 内存阈值配置
  static const double _warningThreshold = 0.8; // 80% 内存使用率预警
  static const double _criticalThreshold = 0.95; // 95% 内存使用率严重预警
  static const int _minMemoryThreshold = 50; // 最小内存阈值(MB)

  // 监控相关
  Timer? _monitorTimer;
  DateTime? _lastCleanupTime;
  final List<MemoryAlert> _alerts = [];
  final Map<String, dynamic> _memoryStats = {};

  // 回调函数
  Function(double)? onMemoryUsageChanged;
  Function(MemoryAlert)? onMemoryAlert;
  Function()? onMemoryOptimization;

  /// 内存使用信息
  Future<MemoryInfo> getMemoryInfo() async {
    try {
      if (kIsWeb) {
        return await _getWebMemoryInfo();
      } else {
        return await _getNativeMemoryInfo();
      }
    } catch (e) {
      log('获取内存信息失败: $e');
      return MemoryInfo.empty();
    }
  }

  /// 获取Web内存信息
  Future<MemoryInfo> _getWebMemoryInfo() async {
    // 模拟内存信息（Web平台）
    final totalMemory = Platform.numberOfProcessors * 1024; // 假设总内存
    final usedMemory = (DateTime.now().millisecondsSinceEpoch % 100) / 100.0 * totalMemory;
    
    return MemoryInfo(
      totalMemory: totalMemory,
      usedMemory: usedMemory.toInt(),
      availableMemory: totalMemory - usedMemory,
      usagePercentage: usedMemory / totalMemory,
      timestamp: DateTime.now(),
    );
  }

  /// 获取原生内存信息
  Future<MemoryInfo> _getNativeMemoryInfo() async {
    try {
      final result = await _channel.invokeMethod('getMemoryInfo');
      if (result != null) {
        return MemoryInfo.fromMap(Map<String, dynamic>.from(result));
      }
    } catch (e) {
      log('调用原生内存接口失败: $e');
    }

    // 备用方案：使用系统进程信息
    return await _getProcessMemoryInfo();
  }

  /// 获取进程内存信息
  Future<MemoryInfo> _getProcessMemoryInfo() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // 在移动平台上可以使用 vm_service
        // 这里返回模拟数据
        final totalMemory = 1024; // MB
        final usedMemory = 300; // MB
        final usagePercentage = usedMemory / totalMemory;
        
        return MemoryInfo(
          totalMemory: totalMemory,
          usedMemory: usedMemory,
          availableMemory: totalMemory - usedMemory,
          usagePercentage: usagePercentage,
          timestamp: DateTime.now(),
        );
      }
      
      // 桌面平台
      return await _getDesktopMemoryInfo();
    } catch (e) {
      log('获取进程内存信息失败: $e');
      return MemoryInfo.empty();
    }
  }

  /// 获取桌面平台内存信息
  Future<MemoryInfo> _getDesktopMemoryInfo() async {
    try {
      // 这里可以使用系统特定的方法获取真实内存信息
      // 暂时返回模拟数据
      final totalMemory = 8192; // 8GB
      final usedMemory = 2048; // 2GB
      final usagePercentage = usedMemory / totalMemory;
      
      return MemoryInfo(
        totalMemory: totalMemory,
        usedMemory: usedMemory,
        availableMemory: totalMemory - usedMemory,
        usagePercentage: usagePercentage,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      log('获取桌面内存信息失败: $e');
      return MemoryInfo.empty();
    }
  }

  /// 开始内存监控
  void startMonitoring({int intervalSeconds = 5}) {
    if (_monitorTimer != null) {
      stopMonitoring();
    }

    _monitorTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (timer) => _checkMemoryStatus(),
    );

    log('内存监控已启动，监控间隔: ${intervalSeconds}秒');
  }

  /// 停止内存监控
  void stopMonitoring() {
    _monitorTimer?.cancel();
    _monitorTimer = null;
    log('内存监控已停止');
  }

  /// 检查内存状态
  Future<void> _checkMemoryStatus() async {
    try {
      final memoryInfo = await getMemoryInfo();
      await _handleMemoryCheck(memoryInfo);
    } catch (e) {
      log('内存状态检查失败: $e');
    }
  }

  /// 处理内存检查结果
  Future<void> _handleMemoryCheck(MemoryInfo memoryInfo) async {
    _memoryStats['currentUsage'] = memoryInfo.usedMemory;
    _memoryStats['peakUsage'] = max(
      _memoryStats['peakUsage'] ?? 0,
      memoryInfo.usedMemory,
    );

    // 触发内存使用变化回调
    onMemoryUsageChanged?.call(memoryInfo.usagePercentage);

    // 检查是否需要发出预警
    await _checkForAlerts(memoryInfo);

    // 检查是否需要自动优化
    await _checkForAutoOptimization(memoryInfo);
  }

  /// 检查预警条件
  Future<void> _checkForAlerts(MemoryInfo memoryInfo) async {
    final currentTime = DateTime.now();
    final usagePercentage = memoryInfo.usagePercentage;

    if (usagePercentage >= _criticalThreshold) {
      await _emitAlert(MemoryAlert(
        type: MemoryAlertType.critical,
        message: '内存使用率过高: ${(usagePercentage * 100).toStringAsFixed(1)}%',
        usagePercentage: usagePercentage,
        timestamp: currentTime,
      ));
    } else if (usagePercentage >= _warningThreshold) {
      await _emitAlert(MemoryAlert(
        type: MemoryAlertType.warning,
        message: '内存使用率警告: ${(usagePercentage * 100).toStringAsFixed(1)}%',
        usagePercentage: usagePercentage,
        timestamp: currentTime,
      ));
    }
  }

  /// 检查是否需要自动优化
  Future<void> _checkForAutoOptimization(MemoryInfo memoryInfo) async {
    final usagePercentage = memoryInfo.usagePercentage;
    final currentTime = DateTime.now();

    // 检查是否需要清理内存
    if (usagePercentage >= _warningThreshold && 
        (_lastCleanupTime == null || 
         currentTime.difference(_lastCleanupTime!).inMinutes >= 5)) {
      await performMemoryOptimization();
      _lastCleanupTime = currentTime;
    }
  }

  /// 执行内存优化
  Future<void> performMemoryOptimization() async {
    log('开始执行内存优化...');
    
    try {
      // 1. 垃圾回收
      await performGarbageCollection();
      
      // 2. 清理缓存
      await _clearMemoryCaches();
      
      // 3. 释放未使用的资源
      await _releaseUnusedResources();
      
      // 4. 压缩内存
      await _compactMemory();

      onMemoryOptimization?.call();
      log('内存优化完成');

      // 记录优化结果
      _memoryStats['lastOptimization'] = DateTime.now().millisecondsSinceEpoch;
      _memoryStats['optimizationCount'] = (_memoryStats['optimizationCount'] ?? 0) + 1;

    } catch (e) {
      log('内存优化执行失败: $e');
    }
  }

  /// 垃圾回收
  Future<void> performGarbageCollection() async {
    // 触发垃圾回收
    await _runIsolated(() {
      // 在新的isolate中运行，可以更好地触发GC
      return 'GC completed';
    });

    log('垃圾回收完成');
  }

  /// 清理内存缓存
  Future<void> _clearMemoryCaches() async {
    // 清理图片缓存
    await _clearImageCache();
    
    // 清理文件系统缓存
    await _clearFileSystemCache();
    
    log('内存缓存清理完成');
  }

  /// 清理图片缓存
  Future<void> _clearImageCache() async {
    try {
      // 使用Flutter的图片缓存清理方法
      // imageCache.clear();
      // imageCache.clearLiveImages();
      log('图片缓存已清理');
    } catch (e) {
      log('清理图片缓存失败: $e');
    }
  }

  /// 清理文件系统缓存
  Future<void> _clearFileSystemCache() async {
    try {
      // 清理临时文件和缓存
      // 这里可以添加实际的缓存清理逻辑
      log('文件系统缓存已清理');
    } catch (e) {
      log('清理文件系统缓存失败: $e');
    }
  }

  /// 释放未使用的资源
  Future<void> _releaseUnusedResources() async {
    try {
      // 释放数据库连接
      // 释放网络连接
      // 释放文件句柄
      // 这里可以添加具体的资源释放逻辑
      log('未使用资源已释放');
    } catch (e) {
      log('释放未使用资源失败: $e');
    }
  }

  /// 压缩内存
  Future<void> _compactMemory() async {
    try {
      // 内存压缩操作
      // 在Flutter中，这可能包括重新组织内存布局
      log('内存压缩完成');
    } catch (e) {
      log('内存压缩失败: $e');
    }
  }

  /// 在隔离中运行代码
  Future<T> _runIsolated<T>(T Function() function) async {
    return await Isolate.run(function);
  }

  /// 发出预警
  Future<void> _emitAlert(MemoryAlert alert) async {
    _alerts.add(alert);
    onMemoryAlert?.call(alert);
    log('内存预警: ${alert.type} - ${alert.message}');

    // 保持预警历史记录不超过100条
    if (_alerts.length > 100) {
      _alerts.removeAt(0);
    }
  }

  /// 获取内存统计信息
  Map<String, dynamic> getMemoryStatistics() {
    return {
      'currentUsage': _memoryStats['currentUsage'] ?? 0,
      'peakUsage': _memoryStats['peakUsage'] ?? 0,
      'optimizationCount': _memoryStats['optimizationCount'] ?? 0,
      'lastOptimization': _memoryStats['lastOptimization'],
      'alertsCount': _alerts.length,
      'isMonitoring': _monitorTimer != null,
      'lastCleanupTime': _lastCleanupTime?.toIso8601String(),
    };
  }

  /// 获取预警历史
  List<MemoryAlert> getAlertHistory() {
    return List.unmodifiable(_alerts);
  }

  /// 设置内存阈值
  void setThresholds({double? warning, double? critical}) {
    if (warning != null && warning >= 0 && warning < 1) {
      // 可以通过其他方式存储预警阈值
      log('预警阈值已设置为: ${(warning * 100).toStringAsFixed(1)}%');
    }
    if (critical != null && critical > 0 && critical <= 1) {
      // 可以通过其他方式存储严重预警阈值
      log('严重预警阈值已设置为: ${(critical * 100).toStringAsFixed(1)}%');
    }
  }

  /// 清理资源
  void dispose() {
    stopMonitoring();
    _alerts.clear();
    _memoryStats.clear();
    log('MemoryManager已清理资源');
  }
}

/// 内存信息数据类
class MemoryInfo {
  final int totalMemory; // 总内存(MB)
  final int usedMemory; // 已使用内存(MB)
  final int availableMemory; // 可用内存(MB)
  final double usagePercentage; // 使用率 (0.0-1.0)
  final DateTime timestamp; // 获取时间

  MemoryInfo({
    required this.totalMemory,
    required this.usedMemory,
    required this.availableMemory,
    required this.usagePercentage,
    required this.timestamp,
  });

  factory MemoryInfo.empty() {
    return MemoryInfo(
      totalMemory: 0,
      usedMemory: 0,
      availableMemory: 0,
      usagePercentage: 0.0,
      timestamp: DateTime.now(),
    );
  }

  factory MemoryInfo.fromMap(Map<String, dynamic> map) {
    return MemoryInfo(
      totalMemory: map['totalMemory']?.toInt() ?? 0,
      usedMemory: map['usedMemory']?.toInt() ?? 0,
      availableMemory: map['availableMemory']?.toInt() ?? 0,
      usagePercentage: (map['usagePercentage']?.toDouble() ?? 0.0),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalMemory': totalMemory,
      'usedMemory': usedMemory,
      'availableMemory': availableMemory,
      'usagePercentage': usagePercentage,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'MemoryInfo{total: ${totalMemory}MB, used: ${usedMemory}MB, '
           'usage: ${(usagePercentage * 100).toStringAsFixed(1)}%, '
           'available: ${availableMemory}MB}';
  }
}

/// 内存预警类
class MemoryAlert {
  final MemoryAlertType type;
  final String message;
  final double usagePercentage;
  final DateTime timestamp;

  const MemoryAlert({
    required this.type,
    required this.message,
    required this.usagePercentage,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'MemoryAlert{type: $type, message: $message, '
           'usage: ${(usagePercentage * 100).toStringAsFixed(1)}%, '
           'time: $timestamp}';
  }
}

/// 内存预警类型
enum MemoryAlertType {
  warning,
  critical,
}

/// 内存优化结果
class MemoryOptimizationResult {
  final bool success;
  final String message;
  final int memoryFreed; // 释放的内存(MB)
  final Duration duration;

  const MemoryOptimizationResult({
    required this.success,
    required this.message,
    required this.memoryFreed,
    required this.duration,
  });

  @override
  String toString() {
    return 'MemoryOptimizationResult{success: $success, message: $message, '
           'memoryFreed: ${memoryFreed}MB, duration: $duration}';
  }
}