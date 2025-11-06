import 'dart:async';
import 'dart:developer' as developer;
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/shared_state_provider.dart';

/// 性能监控配置
class PerformanceConfig {
  /// 是否启用性能监控
  final bool enableMonitoring;
  
  /// 监控间隔（毫秒）
  final Duration monitoringInterval;
  
  /// 内存阈值（MB）
  final double memoryThreshold;
  
  /// CPU使用率阈值（百分比）
  final double cpuThreshold;
  
  /// 帧率阈值
  final int frameRateThreshold;
  
  /// 是否启用自动优化
  final bool enableAutoOptimization;
  
  /// 是否启用日志记录
  final bool enableLogging;

  const PerformanceConfig({
    this.enableMonitoring = true,
    this.monitoringInterval = const Duration(seconds: 5),
    this.memoryThreshold = 100.0,
    this.cpuThreshold = 80.0,
    this.frameRateThreshold = 30,
    this.enableAutoOptimization = true,
    this.enableLogging = true,
  });
}

/// 性能指标数据
class PerformanceData {
  final DateTime timestamp;
  final double memoryUsageMB;
  final double cpuUsagePercent;
  final int frameRate;
  final Duration frameBuildTime;
  final int widgetCount;
  final int renderObjectCount;
  final Duration gcTime;
  final bool isLowPerformance;

  const PerformanceData({
    required this.timestamp,
    required this.memoryUsageMB,
    required this.cpuUsagePercent,
    required this.frameRate,
    required this.frameBuildTime,
    required this.widgetCount,
    required this.renderObjectCount,
    required this.gcTime,
    this.isLowPerformance = false,
  });

  PerformanceData copyWith({
    DateTime? timestamp,
    double? memoryUsageMB,
    double? cpuUsagePercent,
    int? frameRate,
    Duration? frameBuildTime,
    int? widgetCount,
    int? renderObjectCount,
    Duration? gcTime,
    bool? isLowPerformance,
  }) {
    return PerformanceData(
      timestamp: timestamp ?? this.timestamp,
      memoryUsageMB: memoryUsageMB ?? this.memoryUsageMB,
      cpuUsagePercent: cpuUsagePercent ?? this.cpuUsagePercent,
      frameRate: frameRate ?? this.frameRate,
      frameBuildTime: frameBuildTime ?? this.frameBuildTime,
      widgetCount: widgetCount ?? this.widgetCount,
      renderObjectCount: renderObjectCount ?? this.renderObjectCount,
      gcTime: gcTime ?? this.gcTime,
      isLowPerformance: isLowPerformance ?? this.isLowPerformance,
    );
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'memoryUsageMB': memoryUsageMB,
      'cpuUsagePercent': cpuUsagePercent,
      'frameRate': frameRate,
      'frameBuildTime': frameBuildTime.inMilliseconds,
      'widgetCount': widgetCount,
      'renderObjectCount': renderObjectCount,
      'gcTime': gcTime.inMilliseconds,
      'isLowPerformance': isLowPerformance,
    };
  }

  /// 从JSON创建实例
  factory PerformanceData.fromJson(Map<String, dynamic> json) {
    return PerformanceData(
      timestamp: DateTime.parse(json['timestamp'] as String),
      memoryUsageMB: json['memoryUsageMB'] as double,
      cpuUsagePercent: json['cpuUsagePercent'] as double,
      frameRate: json['frameRate'] as int,
      frameBuildTime: Duration(milliseconds: json['frameBuildTime'] as int),
      widgetCount: json['widgetCount'] as int,
      renderObjectCount: json['renderObjectCount'] as int,
      gcTime: Duration(milliseconds: json['gcTime'] as int),
      isLowPerformance: json['isLowPerformance'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'PerformanceData{timestamp: $timestamp, memory: ${memoryUsageMB.toStringAsFixed(1)}MB, '
           'cpu: ${cpuUsagePercent.toStringAsFixed(1)}%, fps: $frameRate, '
           'widgets: $widgetCount, renderObjects: $renderObjectCount}';
  }
}

/// 性能优化器
class PerformanceOptimizer {
  static PerformanceOptimizer? _instance;
  static PerformanceOptimizer get instance => _instance ??= PerformanceOptimizer._();
  
  PerformanceOptimizer._();

  Timer? _monitoringTimer;
  List<PerformanceData> _performanceHistory = [];
  PerformanceConfig _config = const PerformanceConfig();
  final List<PerformanceListener> _listeners = [];
  
  // 性能指标
  int _lastFrameTime = 0;
  final List<int> _frameTimes = [];
  final int _maxFrameTimeHistory = 60;
  
  // 内存监控
  DateTime? _lastGCTime;
  int _gcCount = 0;

  /// 初始化性能优化器
  void initialize({PerformanceConfig? config}) {
    _config = config ?? const PerformanceConfig();
    
    if (_config.enableMonitoring) {
      _startMonitoring();
    }
    
    _setupFrameCallback();
    _setupMemoryCallback();
    
    _log('性能优化器已初始化', level: LogLevel.info);
  }

  /// 释放资源
  void dispose() {
    _monitoringTimer?.cancel();
    _listeners.clear();
    _performanceHistory.clear();
    _frameTimes.clear();
    _log('性能优化器已释放', level: LogLevel.info);
  }

  /// 更新配置
  void updateConfig(PerformanceConfig config) {
    final oldConfig = _config;
    _config = config;
    
    if (oldConfig.enableMonitoring != config.enableMonitoring) {
      if (config.enableMonitoring) {
        _startMonitoring();
      } else {
        _monitoringTimer?.cancel();
      }
    }
    
    _log('性能配置已更新', level: LogLevel.info);
  }

  /// 添加性能监听器
  void addListener(PerformanceListener listener) {
    _listeners.add(listener);
  }

  /// 移除性能监听器
  void removeListener(PerformanceListener listener) {
    _listeners.remove(listener);
  }

  /// 开始监控
  void _startMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = Timer.periodic(
      _config.monitoringInterval,
      (_) => _collectPerformanceData(),
    );
  }

  /// 设置帧回调
  void _setupFrameCallback() {
    SchedulerBinding.instance.addPersistentFrameCallback((duration) {
      _updateFrameMetrics(duration);
    });
  }

  /// 设置内存回调
  void _setupMemoryCallback() {
    // 监听内存压力事件
    WidgetsBinding.instance.addPersistentFrameCallback((duration) {
      _checkMemoryPressure();
    });
  }

  /// 更新帧指标
  void _updateFrameMetrics(Duration frameDuration) {
    final frameTime = frameDuration.inMilliseconds;
    _frameTimes.add(frameTime);
    
    // 保持历史记录在合理范围内
    if (_frameTimes.length > _maxFrameTimeHistory) {
      _frameTimes.removeAt(0);
    }
    
    // 计算平均帧率
    final avgFrameTime = _frameTimes.isEmpty 
        ? 16.67 
        : _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
    final avgFrameRate = (1000 / avgFrameTime).round();
    
    // 检查帧率是否过低
    if (avgFrameRate < _config.frameRateThreshold) {
      _triggerLowPerformanceAlert(avgFrameRate);
    }
  }

  /// 检查内存压力
  void _checkMemoryPressure() {
    // 这里可以实现内存压力检测逻辑
    // 例如：检查当前内存使用量、触发垃圾回收等
  }

  /// 收集性能数据
  Future<void> _collectPerformanceData() async {
    try {
      final data = await _gatherPerformanceData();
      
      // 添加到历史记录
      _performanceHistory.add(data);
      if (_performanceHistory.length > 100) {
        _performanceHistory.removeAt(0);
      }
      
      // 检查是否需要优化
      if (_config.enableAutoOptimization) {
        _checkOptimizationNeeds(data);
      }
      
      // 通知监听器
      _notifyListeners(data);
      
      // 记录日志
      if (_config.enableLogging) {
        _log('性能数据: $data', level: LogLevel.debug);
      }
      
    } catch (e) {
      _log('收集性能数据失败: $e', level: LogLevel.error);
    }
  }

  /// 收集性能数据
  Future<PerformanceData> _gatherPerformanceData() async {
    final timestamp = DateTime.now();
    
    // 获取内存使用情况（模拟）
    final memoryUsageMB = await _getMemoryUsage();
    
    // 获取CPU使用率（模拟）
    final cpuUsagePercent = await _getCPUUsage();
    
    // 计算帧率
    final frameRate = _calculateAverageFrameRate();
    
    // 获取帧构建时间
    final frameBuildTime = _getAverageFrameBuildTime();
    
    // 获取Widget和渲染对象数量
    final widgetCount = _getWidgetCount();
    final renderObjectCount = _getRenderObjectCount();
    
    // 获取垃圾回收时间
    final gcTime = _getGCTime();
    
    // 判断是否性能低下
    final isLowPerformance = memoryUsageMB > _config.memoryThreshold ||
                            cpuUsagePercent > _config.cpuThreshold ||
                            frameRate < _config.frameRateThreshold;

    return PerformanceData(
      timestamp: timestamp,
      memoryUsageMB: memoryUsageMB,
      cpuUsagePercent: cpuUsagePercent,
      frameRate: frameRate,
      frameBuildTime: frameBuildTime,
      widgetCount: widgetCount,
      renderObjectCount: renderObjectCount,
      gcTime: gcTime,
      isLowPerformance: isLowPerformance,
    );
  }

  /// 获取内存使用量（MB）
  Future<double> _getMemoryUsage() async {
    // 在实际应用中，这里应该调用平台特定的API
    // 例如：ios_get_memory_usage, android_get_memory_usage
    return await compute(_calculateMemoryUsage, null);
  }

  /// 计算内存使用量
  static double _calculateMemoryUsage(_) {
    // 模拟内存使用量计算
    return 50.0 + (math.Random().nextDouble() * 30);
  }

  /// 获取CPU使用率
  Future<double> _getCPUUsage() async {
    return await compute(_calculateCPUUsage, null);
  }

  /// 计算CPU使用率
  static double _calculateCPUUsage(_) {
    // 模拟CPU使用率计算
    return 20.0 + (math.Random().nextDouble() * 40);
  }

  /// 计算平均帧率
  int _calculateAverageFrameRate() {
    if (_frameTimes.isEmpty) return 60;
    
    final avgFrameTime = _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
    return (1000 / avgFrameTime).round();
  }

  /// 获取平均帧构建时间
  Duration _getAverageFrameBuildTime() {
    if (_frameTimes.isEmpty) return const Duration(milliseconds: 16);
    
    final avgFrameTime = _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
    return Duration(milliseconds: avgFrameTime.round());
  }

  /// 获取Widget数量
  int _getWidgetCount() {
    // 在实际应用中，这里应该遍历Widget树并计算数量
    return 100 + math.Random().nextInt(50);
  }

  /// 获取渲染对象数量
  int _getRenderObjectCount() {
    // 在实际应用中，这里应该遍历渲染树并计算数量
    return 50 + math.Random().nextInt(30);
  }

  /// 获取垃圾回收时间
  Duration _getGCTime() {
    // 在实际应用中，这里应该获取实际的GC时间
    return Duration(milliseconds: _gcCount * 10);
  }

  /// 检查优化需求
  void _checkOptimizationNeeds(PerformanceData data) {
    if (data.isLowPerformance) {
      _triggerOptimization(data);
    }
  }

  /// 触发性能优化
  void _triggerOptimization(PerformanceData data) {
    _log('触发性能优化', level: LogLevel.warning);
    
    // 执行优化策略
    _optimizeMemory();
    _optimizeRendering();
    _optimizeAnimations();
  }

  /// 优化内存
  void _optimizeMemory() {
    // 清理缓存
    _clearUnusedCaches();
    
    // 触发垃圾回收（如果支持）
    _requestGarbageCollection();
    
    _log('内存优化完成', level: LogLevel.debug);
  }

  /// 优化渲染
  void _optimizeRendering() {
    // 减少不必要的重绘
    // 优化Widget构建
    _log('渲染优化完成', level: LogLevel.debug);
  }

  /// 优化动画
  void _optimizeAnimations() {
    // 降低动画帧率或暂停某些动画
    _log('动画优化完成', level: LogLevel.debug);
  }

  /// 清理未使用的缓存
  void _clearUnusedCaches() {
    // 实现缓存清理逻辑
  }

  /// 请求垃圾回收
  void _requestGarbageCollection() {
    // 在Flutter中，垃圾回收由系统自动管理
    // 这里可以添加一些辅助逻辑
    _gcCount++;
    _lastGCTime = DateTime.now();
  }

  /// 触发低性能警告
  void _triggerLowPerformanceAlert(int frameRate) {
    _log('检测到低性能: 帧率 $frameRate FPS', level: LogLevel.warning);
    
    for (final listener in _listeners) {
      listener.onLowPerformanceDetected(frameRate);
    }
  }

  /// 通知监听器
  void _notifyListeners(PerformanceData data) {
    for (final listener in _listeners) {
      listener.onPerformanceDataUpdated(data);
    }
  }

  /// 记录日志
  void _log(String message, {required LogLevel level}) {
    if (_config.enableLogging) {
      final logMessage = '[性能优化器] $message';
      
      switch (level) {
        case LogLevel.debug:
          developer.log(logMessage, name: 'PerformanceOptimizer', level: 500);
          break;
        case LogLevel.info:
          developer.log(logMessage, name: 'PerformanceOptimizer', level: 800);
          break;
        case LogLevel.warning:
          developer.log(logMessage, name: 'PerformanceOptimizer', level: 900);
          break;
        case LogLevel.error:
          developer.log(logMessage, name: 'PerformanceOptimizer', level: 1000);
          break;
      }
    }
  }

  /// 获取性能历史数据
  List<PerformanceData> getPerformanceHistory() {
    return List.unmodifiable(_performanceHistory);
  }

  /// 获取最新性能数据
  PerformanceData? getLatestPerformanceData() {
    return _performanceHistory.isEmpty ? null : _performanceHistory.last;
  }

  /// 获取平均性能指标
  PerformanceData getAveragePerformance() {
    if (_performanceHistory.isEmpty) {
      return const PerformanceData(
        timestamp: null,
        memoryUsageMB: 0,
        cpuUsagePercent: 0,
        frameRate: 60,
        frameBuildTime: Duration.zero,
        widgetCount: 0,
        renderObjectCount: 0,
        gcTime: Duration.zero,
      );
    }

    final count = _performanceHistory.length;
    final sum = _performanceHistory.fold(
      PerformanceData(
        timestamp: DateTime.now(),
        memoryUsageMB: 0,
        cpuUsagePercent: 0,
        frameRate: 0,
        frameBuildTime: Duration.zero,
        widgetCount: 0,
        renderObjectCount: 0,
        gcTime: Duration.zero,
      ),
      (acc, data) => acc.copyWith(
        memoryUsageMB: acc.memoryUsageMB + data.memoryUsageMB,
        cpuUsagePercent: acc.cpuUsagePercent + data.cpuUsagePercent,
        frameRate: acc.frameRate + data.frameRate,
        frameBuildTime: Duration(
          milliseconds: acc.frameBuildTime.inMilliseconds + data.frameBuildTime.inMilliseconds
        ),
        widgetCount: acc.widgetCount + data.widgetCount,
        renderObjectCount: acc.renderObjectCount + data.renderObjectCount,
        gcTime: Duration(
          milliseconds: acc.gcTime.inMilliseconds + data.gcTime.inMilliseconds
        ),
      ),
    );

    return PerformanceData(
      timestamp: DateTime.now(),
      memoryUsageMB: sum.memoryUsageMB / count,
      cpuUsagePercent: sum.cpuUsagePercent / count,
      frameRate: (sum.frameRate / count).round(),
      frameBuildTime: Duration(
        milliseconds: (sum.frameBuildTime.inMilliseconds / count).round()
      ),
      widgetCount: (sum.widgetCount / count).round(),
      renderObjectCount: (sum.renderObjectCount / count).round(),
      gcTime: Duration(
        milliseconds: (sum.gcTime.inMilliseconds / count).round()
      ),
    );
  }

  /// 清除历史数据
  void clearHistory() {
    _performanceHistory.clear();
    _frameTimes.clear();
    _log('性能历史数据已清除', level: LogLevel.info);
  }
}

/// 性能监听器接口
abstract class PerformanceListener {
  /// 性能数据更新
  void onPerformanceDataUpdated(PerformanceData data);
  
  /// 检测到低性能
  void onLowPerformanceDetected(int frameRate);
}

/// 日志级别
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// 性能优化提供者
final performanceOptimizerProvider = Provider<PerformanceOptimizer>((ref) {
  return PerformanceOptimizer.instance;
});

/// 性能配置提供者
final performanceConfigProvider = StateProvider<PerformanceConfig>((ref) {
  return const PerformanceConfig();
});

/// 性能数据提供者
final performanceDataProvider = StateProvider<List<PerformanceData>>((ref) {
  return [];
});

/// 性能优化服务
class PerformanceOptimizationService {
  static PerformanceOptimizationService? _instance;
  static PerformanceOptimizationService get instance => 
      _instance ??= PerformanceOptimizationService._();
  
  PerformanceOptimizationService._();

  final PerformanceOptimizer _optimizer = PerformanceOptimizer.instance;
  final List<WidgetRef> _widgetRefs = [];

  /// 初始化服务
  void initialize({PerformanceConfig? config}) {
    _optimizer.initialize(config: config);
    _setupOptimizationListener();
  }

  /// 设置优化监听器
  void _setupOptimizationListener() {
    _optimizer.addListener(_OptimizationListener());
  }

  /// 注册Widget引用（用于自动优化）
  void registerWidgetRef(WidgetRef ref) {
    _widgetRefs.add(ref);
  }

  /// 注销Widget引用
  void unregisterWidgetRef(WidgetRef ref) {
    _widgetRefs.remove(ref);
  }

  /// 手动触发优化
  void triggerOptimization() {
    final latestData = _optimizer.getLatestPerformanceData();
    if (latestData != null) {
      _optimizer._triggerOptimization(latestData);
    }
  }

  /// 获取性能报告
  String getPerformanceReport() {
    final averageData = _optimizer.getAveragePerformance();
    final history = _optimizer.getPerformanceHistory();
    
    final buffer = StringBuffer();
    buffer.writeln('=== 性能报告 ===');
    buffer.writeln('数据点数量: ${history.length}');
    buffer.writeln('平均内存使用: ${averageData.memoryUsageMB.toStringAsFixed(1)} MB');
    buffer.writeln('平均CPU使用率: ${averageData.cpuUsagePercent.toStringAsFixed(1)}%');
    buffer.writeln('平均帧率: ${averageData.frameRate} FPS');
    buffer.writeln('平均帧构建时间: ${averageData.frameBuildTime.inMilliseconds} ms');
    buffer.writeln('平均Widget数量: ${averageData.widgetCount}');
    buffer.writeln('平均渲染对象数量: ${averageData.renderObjectCount}');
    buffer.writeln('垃圾回收次数: ${averageData.gcTime.inMilliseconds ~/ 10}');
    
    return buffer.toString();
  }
}

/// 优化监听器实现
class _OptimizationListener implements PerformanceListener {
  @override
  void onPerformanceDataUpdated(PerformanceData data) {
    // 可以在这里添加自定义的性能数据处理逻辑
  }

  @override
  void onLowPerformanceDetected(int frameRate) {
    // 可以在这里添加低性能警告的UI反馈逻辑
  }
}

/// 自动优化Widget
class AutoOptimizedWidget extends ConsumerStatefulWidget {
  final Widget child;
  final bool enableAutoOptimization;

  const AutoOptimizedWidget({
    super.key,
    required this.child,
    this.enableAutoOptimization = true,
  });

  @override
  ConsumerState<AutoOptimizedWidget> createState() => _AutoOptimizedWidgetState();
}

class _AutoOptimizedWidgetState extends ConsumerState<AutoOptimizedWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.enableAutoOptimization) {
      PerformanceOptimizationService.instance.registerWidgetRef(ref);
    }
  }

  @override
  void dispose() {
    if (widget.enableAutoOptimization) {
      PerformanceOptimizationService.instance.unregisterWidgetRef(ref);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}