/// 优化模块索引文件
/// 
/// 导出所有优化相关的类，提供统一的导入入口：
/// - 代理性能优化器
/// - 网络连接管理器  
/// - 缓存管理器
/// - 带宽监控器
/// - 性能统计和自动优化管理器
/// 
/// ## 使用示例
/// 
/// ```dart
/// import 'package:flclash_browser_app/optimization/index.dart';
/// 
/// // 初始化性能管理器
/// final performanceManager = PerformanceManager();
/// await performanceManager.initialize();
/// 
/// // 获取缓存
/// final cachedData = await performanceManager.getCache<String>('key');
/// 
/// // 执行网络请求
/// final response = await performanceManager.executeNetworkRequest(
///   host: 'example.com',
///   method: 'GET',
///   path: '/api/data',
/// );
/// 
/// // 获取性能统计
/// final stats = performanceManager.integratedStats;
/// print('Performance Score: ${stats.performanceScore}');
/// ```

// 核心优化组件
export 'proxy_performance_optimizer.dart';
export 'network_connection_manager.dart';
export 'cache_manager.dart';
export 'bandwidth_monitor.dart';
export 'performance_manager.dart';

// 性能配置和统计类
export 'proxy_performance_optimizer.dart' show PerformanceConfig, PerformanceStats;
export 'cache_manager.dart' show CacheConfig, CacheStats, CachePolicy;
export 'bandwidth_monitor.dart' show BandwidthConfig, BandwidthStats;
export 'performance_manager.dart' show 
  PerformanceManagerConfig,
  IntegratedStats,
  PerformanceReport,
  PerformanceRecommendation;

// 性能事件和问题
export 'performance_manager.dart' show 
  PerformanceEvent,
  PerformanceIssue,
  IssueType,
  IssueSeverity,
  EventType;

// 性能统计相关
export 'performance_manager.dart' show 
  MemoryStats,
  NetworkStats,
  OptimizationStats,
  PerformanceHistoryEntry;

// 缓存相关枚举和类
export 'cache_manager.dart' show 
  CacheSource,
  CacheStatus,
  CacheUsage,
  CacheEntry,
  NetworkCacheEntry,
  UsagePattern,
  PreloadCandidate;

// 网络连接相关
export 'network_connection_manager.dart' show 
  HttpClientConnection,
  ConnectionPool,
  NetworkConnectionStats,
  PoolStatus,
  ProxyType,
  NetworkQuality;

// 带宽监控相关
export 'bandwidth_monitor.dart' show 
  BandwidthSnapshot,
  NetworkUsage,
  NetworkStatsInfo,
  DataDirection,
  DataUsageRecord,
  NetworkQuality,
  QualityLevel,
  OptimizationSuggestion,
  SuggestionPriority,
  BandwidthAlert,
  AlertType,
  AlertSeverity,
  BandwidthConfig;

// 内存和性能优化相关
export 'proxy_performance_optimizer.dart' show 
  MemoryInfo,
  BatteryState;

// 缓存策略和配置
// export 'cache_manager.dart' show CachePolicy; // 已在上面导出

/// 快速初始化优化系统的辅助函数
/// 
/// [config] 可选的性能管理器配置，如果为null则使用默认配置
/// [enableAutoOptimization] 是否启用自动优化
/// 
/// 返回初始化完成的PerformanceManager实例
Future<PerformanceManager> initOptimizationSystem({
  PerformanceManagerConfig? config,
  bool enableAutoOptimization = true,
}) async {
  final manager = PerformanceManager();
  await manager.initialize(
    config: config,
    enableAutoOptimization: enableAutoOptimization,
  );
  return manager;
}

/// 创建默认优化配置的辅助函数
PerformanceManagerConfig createDefaultConfig() {
  return PerformanceManagerConfig(
    optimizerConfig: PerformanceConfig(
      enableAutoOptimization: true,
      enableForceGc: true,
      optimizationIntervalSeconds: 60,
      memoryThreshold: 80.0,
      maxConcurrentConnections: 10,
      enableBatteryOptimization: true,
      enableCpuOptimization: true,
    ),
    cacheConfig: CacheConfig(
      enableMemoryCache: true,
      enableDiskCache: true,
      enableNetworkCache: false,
      promoteToMemory: true,
      defaultExpiry: const Duration(hours: 24),
      cleanupInterval: const Duration(minutes: 30),
      preloadInterval: const Duration(minutes: 15),
      maxMemorySize: 100 * 1024 * 1024, // 100MB
      maxDiskSize: 500 * 1024 * 1024,   // 500MB
      compressionThreshold: 0.8,
    ),
    bandwidthConfig: BandwidthConfig(
      bandwidthLimit: 0, // 无限制
      monitoringInterval: const Duration(seconds: 5),
      maxHistorySize: 720,
      enableAlerts: true,
      enableOptimization: true,
      enableTrafficLimiting: false,
      alertThreshold: 0.8,
    ),
    enableSmartScheduling: true,
    enableAutoCacheCleanup: true,
    enableIntelligentPreload: true,
    enableAdvancedAnalytics: false,
    reportingInterval: const Duration(hours: 1),
  );
}

/// 创建高性能优化配置的辅助函数
PerformanceManagerConfig createHighPerformanceConfig() {
  return PerformanceManagerConfig(
    optimizerConfig: PerformanceConfig(
      enableAutoOptimization: true,
      enableForceGc: true,
      optimizationIntervalSeconds: 30,
      memoryThreshold: 70.0,
      maxConcurrentConnections: 20,
      enableBatteryOptimization: false,
      enableCpuOptimization: true,
    ),
    cacheConfig: CacheConfig(
      enableMemoryCache: true,
      enableDiskCache: true,
      enableNetworkCache: true,
      promoteToMemory: true,
      defaultExpiry: const Duration(hours: 48),
      cleanupInterval: const Duration(minutes: 15),
      preloadInterval: const Duration(minutes: 5),
      maxMemorySize: 200 * 1024 * 1024, // 200MB
      maxDiskSize: 1024 * 1024 * 1024,  // 1GB
      compressionThreshold: 0.9,
    ),
    bandwidthConfig: BandwidthConfig(
      bandwidthLimit: 0,
      monitoringInterval: const Duration(seconds: 2),
      maxHistorySize: 1800,
      enableAlerts: true,
      enableOptimization: true,
      enableTrafficLimiting: false,
      alertThreshold: 0.7,
    ),
    enableSmartScheduling: true,
    enableAutoCacheCleanup: true,
    enableIntelligentPreload: true,
    enableAdvancedAnalytics: true,
    reportingInterval: const Duration(minutes: 30),
  );
}

/// 创建省电优化配置的辅助函数
PerformanceManagerConfig createPowerSavingConfig() {
  return PerformanceManagerConfig(
    optimizerConfig: PerformanceConfig(
      enableAutoOptimization: true,
      enableForceGc: true,
      optimizationIntervalSeconds: 120,
      memoryThreshold: 60.0,
      maxConcurrentConnections: 5,
      enableBatteryOptimization: true,
      enableCpuOptimization: true,
    ),
    cacheConfig: CacheConfig(
      enableMemoryCache: true,
      enableDiskCache: true,
      enableNetworkCache: false,
      promoteToMemory: false,
      defaultExpiry: const Duration(hours: 12),
      cleanupInterval: const Duration(hours: 1),
      preloadInterval: const Duration(minutes: 30),
      maxMemorySize: 50 * 1024 * 1024,  // 50MB
      maxDiskSize: 200 * 1024 * 1024,   // 200MB
      compressionThreshold: 0.6,
    ),
    bandwidthConfig: BandwidthConfig(
      bandwidthLimit: 10 * 1024 * 1024, // 10MB/s
      monitoringInterval: const Duration(seconds: 10),
      maxHistorySize: 360,
      enableAlerts: true,
      enableOptimization: true,
      enableTrafficLimiting: true,
      alertThreshold: 0.9,
    ),
    enableSmartScheduling: true,
    enableAutoCacheCleanup: true,
    enableIntelligentPreload: false,
    enableAdvancedAnalytics: false,
    reportingInterval: const Duration(hours: 6),
  );
}

/// 优化工具集合类
class OptimizationUtils {
  /// 格式化字节大小
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
  
  /// 格式化速率
  static String formatSpeed(int bytesPerSecond) {
    return '${formatBytes(bytesPerSecond)}/s';
  }
  
  /// 格式化百分比
  static String formatPercent(double value) {
    return '${value.toStringAsFixed(1)}%';
  }
  
  /// 格式化时间
  static String formatDuration(Duration duration) {
    if (duration.inMilliseconds < 1000) {
      return '${duration.inMilliseconds}ms';
    } else if (duration.inSeconds < 60) {
      return '${duration.inSeconds}s';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
  }
  
  /// 获取性能等级描述
  static String getPerformanceLevel(double score) {
    if (score >= 90) return '优秀';
    if (score >= 80) return '良好';
    if (score >= 70) return '一般';
    if (score >= 60) return '较差';
    return '很差';
  }
  
  /// 获取网络质量等级
  static String getNetworkQualityLevel(QualityLevel level) {
    switch (level) {
      case QualityLevel.excellent:
        return '优秀';
      case QualityLevel.good:
        return '良好';
      case QualityLevel.fair:
        return '一般';
      case QualityLevel.poor:
        return '较差';
    }
  }
  
  /// 获取建议优先级描述
  static String getPriorityDescription(RecommendationPriority priority) {
    switch (priority) {
      case RecommendationPriority.low:
        return '低优先级';
      case RecommendationPriority.medium:
        return '中优先级';
      case RecommendationPriority.high:
        return '高优先级';
      case RecommendationPriority.critical:
        return '紧急';
    }
  }
}

/// 性能测试工具类
class PerformanceTester {
  /// 执行综合性能测试
  static Future<PerformanceTestResult> runComprehensiveTest(PerformanceManager manager) async {
    final results = <String, dynamic>{};
    final stopwatch = Stopwatch()..start();
    
    try {
      // 测试缓存性能
      await _testCachePerformance(manager, results);
      
      // 测试网络性能
      await _testNetworkPerformance(manager, results);
      
      // 测试内存使用
      await _testMemoryPerformance(manager, results);
      
      // 测试综合性能
      await _testOverallPerformance(manager, results);
      
      stopwatch.stop();
      
      return PerformanceTestResult(
        duration: stopwatch.elapsed,
        results: results,
        timestamp: DateTime.now(),
      );
      
    } catch (e) {
      stopwatch.stop();
      rethrow;
    }
  }
  
  static Future<void> _testCachePerformance(PerformanceManager manager, Map<String, dynamic> results) async {
    final testData = List.generate(1000, (i) => 'test_data_$i');
    
    final writeStopwatch = Stopwatch()..start();
    for (final data in testData) {
      await manager.setCache('cache_test_$data', data);
    }
    writeStopwatch.stop();
    
    final readStopwatch = Stopwatch()..start();
    for (final data in testData) {
      await manager.getCache<String>('cache_test_$data');
    }
    readStopwatch.stop();
    
    results['cache_write_time'] = writeStopwatch.elapsedMilliseconds;
    results['cache_read_time'] = readStopwatch.elapsedMilliseconds;
    results['cache_operations_per_second'] = (2000 / writeStopwatch.elapsedMilliseconds * 1000).round();
  }
  
  static Future<void> _testNetworkPerformance(PerformanceManager manager, Map<String, dynamic> results) async {
    // 这里可以模拟网络请求测试
    // 实际实现中需要连接到测试服务器
    results['network_test_status'] = 'skipped'; // 跳过网络测试;
  }
  
  static Future<void> _testMemoryPerformance(PerformanceManager manager, Map<String, dynamic> results) async {
    final memoryBefore = manager.integratedStats.totalMemoryUsage;
    
    // 创建大量测试数据
    final testData = List.generate(10000, (i) => 'x' * 1000);
    await manager.setCache('memory_test', testData);
    
    final memoryAfter = manager.integratedStats.totalMemoryUsage;
    final memoryUsed = memoryAfter - memoryBefore;
    
    results['memory_usage_test'] = memoryUsed;
    results['memory_efficiency'] = (testData.length * 1000) / memoryUsed; // bytes per byte used;
    
    // 清理测试数据
    await manager.setCache('memory_test', null);
  }
  
  static Future<void> _testOverallPerformance(PerformanceManager manager, Map<String, dynamic> results) async {
    final scoreBefore = manager.integratedStats.performanceScore;
    
    // 执行优化
    await manager.triggerOptimization();
    
    // 等待优化完成
    await Future.delayed(const Duration(seconds: 5));
    
    final scoreAfter = manager.integratedStats.performanceScore;
    final improvement = scoreAfter - scoreBefore;
    
    results['performance_improvement'] = improvement;
    results['final_performance_score'] = scoreAfter;
  }
}

/// 性能测试结果
class PerformanceTestResult {
  final Duration duration;
  final Map<String, dynamic> results;
  final DateTime timestamp;
  
  PerformanceTestResult({
    required this.duration,
    required this.results,
    required this.timestamp,
  });
  
  Map<String, dynamic> toJson() => {
    'duration': duration.inMilliseconds,
    'results': results,
    'timestamp': timestamp.toIso8601String(),
  };
}