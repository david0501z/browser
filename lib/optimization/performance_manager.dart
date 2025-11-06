import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'proxy_performance_optimizer.dart';
import 'network_connection_manager.dart';
import 'cache_manager.dart';
import 'bandwidth_monitor.dart';

/// 性能统计和自动优化管理器
/// 
/// 这是优化系统的核心入口点，集成所有优化组件：
/// - 代理性能优化
/// - 网络连接管理
/// - 缓存管理
/// - 带宽监控
/// - 性能统计分析
/// - 自动优化调度
/// 
/// 提供统一的API接口和完整的性能监控解决方案。
class PerformanceManager {
  static final PerformanceManager _instance = PerformanceManager._internal();
  factory PerformanceManager() => _instance;
  PerformanceManager._internal();

  // 组件实例
  late ProxyPerformanceOptimizer _optimizer;
  late NetworkConnectionManager _connectionManager;
  late CacheManager _cacheManager;
  late BandwidthMonitor _bandwidthMonitor;
  
  // 集成统计
  final IntegratedStats _integratedStats = IntegratedStats();
  
  // 配置
  PerformanceManagerConfig? _config;
  
  // 自动优化调度器
  OptimizationScheduler? _scheduler;
  
  // 性能事件流控制器
  final StreamController<PerformanceEvent> _eventController = StreamController.broadcast();
  
  // 是否已初始化
  bool _isInitialized = false;
  
  /// 初始化性能管理器
  /// 
  /// [config] 配置参数，如果为null则使用默认配置
  /// [enableAutoOptimization] 是否启用自动优化
  Future<void> initialize({
    PerformanceManagerConfig? config,
    bool enableAutoOptimization = true,
  }) async {
    if (_isInitialized) {
      log('[PerformanceManager] 性能管理器已经初始化');
      return;
    }
    
    try {
      _config = config ?? PerformanceManagerConfig.defaultConfig();
      
      // 初始化各个组件
      _optimizer = ProxyPerformanceOptimizer();
      _connectionManager = NetworkConnectionManager();
      _cacheManager = CacheManager();
      _bandwidthMonitor = BandwidthMonitor();
      
      // 初始化性能优化器
      await _optimizer.initialize(
        config: _config!.optimizerConfig,
        autoOptimize: enableAutoOptimization,
      );
      
      // 初始化网络连接管理器
      await _connectionManager.initialize(_config!.optimizerConfig);
      
      // 初始化缓存管理器
      await _cacheManager.initialize(
        config: _config!.cacheConfig,
        enableAutoCleanup: _config!.enableAutoCacheCleanup,
        enablePreload: _config!.enableIntelligentPreload,
      );
      
      // 初始化带宽监控器
      await _bandwidthMonitor.initialize(_config!.bandwidthConfig);
      
      // 初始化自动优化调度器
      if (enableAutoOptimization && _config!.enableSmartScheduling) {
        _scheduler = OptimizationScheduler(_optimizer, _config!);
        await _scheduler!.initialize();
      }
      
      // 启动综合性能监控
      _startIntegratedMonitoring();
      
      _isInitialized = true;
      _integratedStats.managerStartTime = DateTime.now();
      
      log('[PerformanceManager] 性能管理器已成功初始化');
      
      // 发送初始化完成事件
      _emitEvent(PerformanceEvent(
        type: EventType.managerInitialized,
        timestamp: DateTime.now(),
        data: {'config': _config!.toJson()},
      ));
      
    } catch (e, stackTrace) {
      log('[PerformanceManager] 初始化失败: $e', level: 500);
      log('StackTrace: $stackTrace');
      rethrow;
    }
  }
  
  /// 启动综合性能监控
  void _startIntegratedMonitoring() {
    // 每10秒收集一次综合统计
    Timer.periodic(const Duration(seconds: 10), (_) => _collectIntegratedStats());
    
    log('[PerformanceManager] 综合性能监控已启动');
  }
  
  /// 收集综合统计
  Future<void> _collectIntegratedStats() async {
    if (!_isInitialized) return;
    
    try {
      final optimizerStats = _optimizer.performanceStats;
      final connectionStats = _connectionManager.connectionStats;
      final cacheStats = _cacheManager.stats;
      final bandwidthStats = _bandwidthMonitor.currentStats;
      
      // 更新综合统计
      _updateIntegratedStats(optimizerStats, connectionStats, cacheStats, bandwidthStats);
      
      // 检查性能问题
      _checkPerformanceIssues();
      
      // 生成性能报告（每小时）
      if (_shouldGenerateReport()) {
        await _generatePerformanceReport();
      }
      
    } catch (e) {
      log('[PerformanceManager] 收集综合统计失败: $e');
    }
  }
  
  /// 更新综合统计
  void _updateIntegratedStats(
    PerformanceStats optimizerStats,
    NetworkConnectionStats connectionStats,
    CacheStats cacheStats,
    BandwidthStats bandwidthStats,
  ) {
    _integratedStats.totalMemoryUsage = optimizerStats.currentMemoryUsage;
    _integratedStats.peakMemoryUsage = optimizerStats.peakMemoryUsage;
    _integratedStats.totalConnections = connectionStats.totalConnections;
    _integratedStats.activeConnections = connectionStats.activeConnections;
    _integratedStats.connectionSuccessRate = connectionStats.successRate;
    _integratedStats.cacheHitRate = cacheStats.hitRate;
    _integratedStats.cacheTotalSize = cacheStats.totalSize;
    _integratedStats.bandwidthUsage = bandwidthStats.currentDownloadRate;
    _integratedStats.totalRequests = bandwidthStats.totalRequests;
    _integratedStats.lastUpdateTime = DateTime.now();
    
    // 计算综合性能分数
    _integratedStats.performanceScore = _calculatePerformanceScore();
  }
  
  /// 计算综合性能分数
  double _calculatePerformanceScore() {
    double score = 100.0;
    
    // 内存使用率影响 (-20分)
    final memoryUsagePercent = _integratedStats.totalMemoryUsage / 1024.0;
    if (memoryUsagePercent > 80) {
      score -= 20;
    } else if (memoryUsagePercent > 60) {
      score -= 10;
    }
    
    // 连接成功率影响 (-15分)
    final connectionSuccessRate = _integratedStats.connectionSuccessRate;
    if (connectionSuccessRate < 80) {
      score -= 15;
    } else if (connectionSuccessRate < 90) {
      score -= 8;
    }
    
    // 缓存命中率影响 (-10分)
    final cacheHitRate = _integratedStats.cacheHitRate;
    if (cacheHitRate < 50) {
      score -= 10;
    } else if (cacheHitRate < 70) {
      score -= 5;
    }
    
    // 带宽使用情况影响 (-10分)
    final bandwidthUsage = _integratedStats.bandwidthUsage;
    if (bandwidthUsage > 50 * 1024 * 1024) { // 50MB/s
      score -= 5;
    }
    
    return score.clamp(0.0, 100.0);
  }
  
  /// 检查性能问题
  void _checkPerformanceIssues() {
    final issues = <PerformanceIssue>[];
    
    // 检查内存使用
    if (_integratedStats.totalMemoryUsage > 1024 * 1024 * 500) { // 500MB
      issues.add(PerformanceIssue(
        type: IssueType.highMemoryUsage,
        severity: IssueSeverity.warning,
        description: '内存使用量过高: ${_integratedStats.totalMemoryUsage ~/ (1024 * 1024)}MB',
        timestamp: DateTime.now(),
      ));
    }
    
    // 检查连接成功率
    if (_integratedStats.connectionSuccessRate < 80) {
      issues.add(PerformanceIssue(
        type: IssueType.lowConnectionSuccessRate,
        severity: IssueSeverity.error,
        description: '连接成功率过低: ${_integratedStats.connectionSuccessRate.toStringAsFixed(1)}%',
        timestamp: DateTime.now(),
      ));
    }
    
    // 检查缓存命中率
    if (_integratedStats.cacheHitRate < 30) {
      issues.add(PerformanceIssue(
        type: IssueType.lowCacheHitRate,
        severity: IssueSeverity.warning,
        description: '缓存命中率过低: ${_integratedStats.cacheHitRate.toStringAsFixed(1)}%',
        timestamp: DateTime.now(),
      ));
    }
    
    // 检查性能分数
    if (_integratedStats.performanceScore < 60) {
      issues.add(PerformanceIssue(
        type: IssueType.poorOverallPerformance,
        severity: IssueSeverity.critical,
        description: '综合性能分数过低: ${_integratedStats.performanceScore.toStringAsFixed(1)}',
        timestamp: DateTime.now(),
      ));
    }
    
    // 发送问题事件
    for (final issue in issues) {
      _emitEvent(PerformanceEvent(
        type: EventType.performanceIssue,
        timestamp: issue.timestamp,
        data: {'issue': issue.toJson()},
      ));
    }
  }
  
  /// 是否应该生成报告
  bool _shouldGenerateReport() {
    final now = DateTime.now();
    final lastReport = _integratedStats.lastReportTime;
    
    if (lastReport == null) return true;
    
    return now.difference(lastReport).inMinutes >= 60; // 每小时生成一次;
  }
  
  /// 生成性能报告
  Future<void> _generatePerformanceReport() async {
    final report = PerformanceReport(
      timestamp: DateTime.now(),
      overallScore: _integratedStats.performanceScore,
      memoryStats: MemoryStats(
        currentUsage: _integratedStats.totalMemoryUsage,
        peakUsage: _integratedStats.peakMemoryUsage,
      ),
      networkStats: NetworkStats(
        totalConnections: _integratedStats.totalConnections,
        activeConnections: _integratedStats.activeConnections,
        successRate: _integratedStats.connectionSuccessRate,
      ),
      cacheStats: CacheStats(
        hitRate: _integratedStats.cacheHitRate,
        totalSize: _integratedStats.cacheTotalSize,
      ),
      bandwidthStats: BandwidthStats(
        currentUsage: _integratedStats.bandwidthUsage,
        totalRequests: _integratedStats.totalRequests,
      ),
      optimizationStats: OptimizationStats(
        totalOptimizations: _optimizer.performanceStats.totalOptimizations,
        avgOptimizationDuration: _optimizer.performanceStats.avgOptimizationDuration,
      ),
    );
    
    _integratedStats.lastReportTime = DateTime.now();
    
    log('[PerformanceManager] 性能报告已生成: 分数=${report.overallScore.toStringAsFixed(1)}');
    
    _emitEvent(PerformanceEvent(
      type: EventType.performanceReport,
      timestamp: DateTime.now(),
      data: {'report': report.toJson()},
    ));
  }
  
  /// 获取缓存数据
  Future<T?> getCache<T>(String key) async {
    _ensureInitialized();
    return await _cacheManager.get<T>(key);
  }
  
  /// 设置缓存数据
  Future<void> setCache<T>(String key, T value, {
    Duration? expiry,
    CachePolicy? policy,
  }) async {
    _ensureInitialized();
    await _cacheManager.set(key, value, expiry: expiry, policy: policy);
  }
  
  /// 执行网络请求
  Future<HttpClientResponse> executeNetworkRequest({
    required String host,
    int? port,
    required String method,
    required String path,
    Map<String, String>? headers,
    dynamic body,
    Duration? timeout,
    ProxyType type = ProxyType.http,
  }) async {
    _ensureInitialized();
    
    final stopwatch = Stopwatch()..start();
    
    try {
      final response = await _connectionManager.executeRequest(
        host: host,
        port: port,
        method: method,
        path: path,
        headers: headers,
        body: body,
        timeout: timeout,
        type: type,
      );
      
      // 记录带宽使用
      final contentLength = response.headers['content-length'] != null;
          ? int.parse(response.headers['content-length']!.first)
          : 0;
      
      await _bandwidthMonitor.recordDataUsage(
        bytes: contentLength,
        direction: DataDirection.download,
        source: '$host:$port',
      );
      
      final duration = stopwatch.elapsedMilliseconds;
      
      _emitEvent(PerformanceEvent(
        type: EventType.networkRequest,
        timestamp: DateTime.now(),
        data: {
          'host': host,
          'path': path,
          'duration': duration,
          'statusCode': response.statusCode,
          'contentLength': contentLength,
        },
      ));
      
      return response;
    } finally {
      stopwatch.stop();
    }
  }
  
  /// 预加载数据
  Future<void> preloadData(String key, Future<dynamic> Function() loader) async {
    _ensureInitialized();
    await _cacheManager.preload(key, loader);
  }
  
  /// 获取综合性能统计
  IntegratedStats get integratedStats => _integratedStats;
  
  /// 获取详细统计
  PerformanceStats get optimizerStats => _optimizer.performanceStats;
  NetworkConnectionStats get connectionStats => _connectionManager.connectionStats;
  CacheStats get cacheStats => _cacheManager.stats;
  BandwidthStats get bandwidthStats => _bandwidthMonitor.currentStats;
  
  /// 获取性能建议
  List<PerformanceRecommendation> getRecommendations() {
    final recommendations = <PerformanceRecommendation>[];
    
    // 基于内存使用情况
    if (_integratedStats.totalMemoryUsage > 1024 * 1024 * 300) {
      recommendations.add(PerformanceRecommendation(
        title: '优化内存使用',
        description: '当前内存使用较高，建议启用更强的内存优化策略',
        priority: RecommendationPriority.high,
        category: RecommendationCategory.memory,
        estimatedImpact: ImpactLevel.medium,
      ));
    }
    
    // 基于缓存命中率
    if (_integratedStats.cacheHitRate < 50) {
      recommendations.add(PerformanceRecommendation(
        title: '优化缓存策略',
        description: '缓存命中率较低，建议调整缓存大小和策略',
        priority: RecommendationPriority.medium,
        category: RecommendationCategory.cache,
        estimatedImpact: ImpactLevel.high,
      ));
    }
    
    // 基于连接成功率
    if (_integratedStats.connectionSuccessRate < 85) {
      recommendations.add(PerformanceRecommendation(
        title: '优化网络连接',
        description: '连接成功率较低，建议检查网络配置和重试策略',
        priority: RecommendationPriority.high,
        category: RecommendationCategory.network,
        estimatedImpact: ImpactLevel.high,
      ));
    }
    
    // 基于性能分数
    if (_integratedStats.performanceScore < 70) {
      recommendations.add(PerformanceRecommendation(
        title: '全面性能优化',
        description: '综合性能分数较低，建议执行全面的性能优化',
        priority: RecommendationPriority.critical,
        category: RecommendationCategory.overall,
        estimatedImpact: ImpactLevel.high,
      ));
    }
    
    return recommendations;
  }
  
  /// 手动触发优化
  Future<void> triggerOptimization() async {
    _ensureInitialized();
    await _optimizer.triggerOptimization();
    
    _emitEvent(PerformanceEvent(
      type: EventType.manualOptimization,
      timestamp: DateTime.now(),
      data: {},
    ));
  }
  
  /// 重置所有统计
  Future<void> resetAllStats() async {
    _ensureInitialized();
    
    _optimizer.configure(_config!.optimizerConfig);
    await _connectionManager.dispose();
    await _cacheManager.clear();
    _bandwidthMonitor.resetStats();
    
    _integratedStats.reset();
    
    _emitEvent(PerformanceEvent(
      type: EventType.statsReset,
      timestamp: DateTime.now(),
      data: {},
    ));
    
    log('[PerformanceManager] 所有统计已重置');
  }
  
  /// 导出完整性能数据
  Future<Map<String, dynamic>> exportPerformanceData() async {
    _ensureInitialized();
    
    return {
      'managerInfo': {
        'version': '1.0.0',
        'startTime': _integratedStats.managerStartTime?.toIso8601String(),
        'lastUpdateTime': _integratedStats.lastUpdateTime?.toIso8601String(),
        'configuration': _config!.toJson(),
      },
      'integratedStats': _integratedStats.toJson(),
      'optimizerStats': optimizerStats.toJson(),
      'connectionStats': connectionStats.toJson(),
      'cacheStats': cacheStats.toJson(),
      'bandwidthStats': bandwidthStats.toJson(),
      'performanceHistory': _integratedStats.performanceHistory.map((h) => h.toJson()).toList(),
      'activeIssues': _getActiveIssues().map((i) => i.toJson()).toList(),
      'recommendations': getRecommendations().map((r) => r.toJson()).toList(),
      'exportTime': DateTime.now().toIso8601String(),
    };
  }
  
  /// 获取当前活跃问题
  List<PerformanceIssue> _getActiveIssues() {
    // 这里应该维护一个活跃问题列表
    // 简化实现，返回空列表
    return [];
  }
  
  /// 确保已初始化
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('性能管理器尚未初始化，请先调用initialize()方法');
    }
  }
  
  /// 发送性能事件
  void _emitEvent(PerformanceEvent event) {
    _eventController.add(event);
  }
  
  /// 监听性能事件
  Stream<PerformanceEvent> get eventStream => _eventController.stream;
  
  /// 配置性能管理器
  Future<void> configure(PerformanceManagerConfig config) async {
    _config = config;
    
    // 重新配置各个组件
    await _optimizer.configure(config.optimizerConfig);
    await _connectionManager.initialize(config.optimizerConfig);
    await _cacheManager.initialize(
      config: config.cacheConfig,
      enableAutoCleanup: config.enableAutoCacheCleanup,
      enablePreload: config.enableIntelligentPreload,
    );
    await _bandwidthMonitor.initialize(config.bandwidthConfig);
    
    log('[PerformanceManager] 性能管理器配置已更新');
  }
  
  /// 销毁性能管理器
  Future<void> dispose() async {
    if (!_isInitialized) return;
    
    await Future.wait([
      _optimizer.dispose(),
      _connectionManager.dispose(),
      _cacheManager.dispose(),
      _bandwidthMonitor.dispose(),
      _scheduler?.dispose(),
    ]);
    
    _eventController.close();
    _isInitialized = false;
    
    log('[PerformanceManager] 性能管理器已销毁');
  }
}

/// 性能管理器配置
class PerformanceManagerConfig {
  final PerformanceConfig optimizerConfig;
  final CacheConfig cacheConfig;
  final BandwidthConfig bandwidthConfig;
  final bool enableSmartScheduling;
  final bool enableAutoCacheCleanup;
  final bool enableIntelligentPreload;
  final bool enableAdvancedAnalytics;
  final Duration reportingInterval;
  
  PerformanceManagerConfig({
    PerformanceConfig? optimizerConfig,
    CacheConfig? cacheConfig,
    BandwidthConfig? bandwidthConfig,
    this.enableSmartScheduling = true,
    this.enableAutoCacheCleanup = true,
    this.enableIntelligentPreload = true,
    this.enableAdvancedAnalytics = false,
    this.reportingInterval = const Duration(hours: 1),
  }) : optimizerConfig = optimizerConfig ?? PerformanceConfig.defaultConfig(),
       cacheConfig = cacheConfig ?? CacheConfig.defaultConfig(),
       bandwidthConfig = bandwidthConfig ?? BandwidthConfig();
  
  factory PerformanceManagerConfig.defaultConfig() => PerformanceManagerConfig();
  
  Map<String, dynamic> toJson() => {
    'enableSmartScheduling': enableSmartScheduling,
    'enableAutoCacheCleanup': enableAutoCacheCleanup,
    'enableIntelligentPreload': enableIntelligentPreload,
    'enableAdvancedAnalytics': enableAdvancedAnalytics,
    'reportingInterval': reportingInterval.inMinutes,
    'optimizerConfig': optimizerConfig.toJson(),
    'cacheConfig': cacheConfig.toJson(),
    'bandwidthConfig': bandwidthConfig.toJson(),
  };
}

/// 集成性能统计
class IntegratedStats {
  DateTime? managerStartTime;
  DateTime? lastUpdateTime;
  DateTime? lastReportTime;
  
  int totalMemoryUsage = 0;
  int peakMemoryUsage = 0;
  int totalConnections = 0;
  int activeConnections = 0;
  double connectionSuccessRate = 0.0;
  double cacheHitRate = 0.0;
  int cacheTotalSize = 0;
  int bandwidthUsage = 0;
  int totalRequests = 0;
  double performanceScore = 100.0;
  
  final List<PerformanceHistoryEntry> performanceHistory = [];
  
  void reset() {
    managerStartTime = DateTime.now();
    lastUpdateTime = null;
    lastReportTime = null;
    totalMemoryUsage = 0;
    peakMemoryUsage = 0;
    totalConnections = 0;
    activeConnections = 0;
    connectionSuccessRate = 0.0;
    cacheHitRate = 0.0;
    cacheTotalSize = 0;
    bandwidthUsage = 0;
    totalRequests = 0;
    performanceScore = 100.0;
    performanceHistory.clear();
  }
  
  Map<String, dynamic> toJson() => {
    'managerStartTime': managerStartTime?.toIso8601String(),
    'lastUpdateTime': lastUpdateTime?.toIso8601String(),
    'lastReportTime': lastReportTime?.toIso8601String(),
    'totalMemoryUsage': totalMemoryUsage,
    'peakMemoryUsage': peakMemoryUsage,
    'totalConnections': totalConnections,
    'activeConnections': activeConnections,
    'connectionSuccessRate': connectionSuccessRate,
    'cacheHitRate': cacheHitRate,
    'cacheTotalSize': cacheTotalSize,
    'bandwidthUsage': bandwidthUsage,
    'totalRequests': totalRequests,
    'performanceScore': performanceScore,
    'performanceHistory': performanceHistory.map((h) => h.toJson()).toList(),
  };
}

/// 性能历史条目
class PerformanceHistoryEntry {
  final DateTime timestamp;
  final double score;
  final int memoryUsage;
  final double connectionSuccessRate;
  final double cacheHitRate;
  
  PerformanceHistoryEntry({
    required this.timestamp,
    required this.score,
    required this.memoryUsage,
    required this.connectionSuccessRate,
    required this.cacheHitRate,
  });
  
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'score': score,
    'memoryUsage': memoryUsage,
    'connectionSuccessRate': connectionSuccessRate,
    'cacheHitRate': cacheHitRate,
  };
}

/// 性能事件
class PerformanceEvent {
  final EventType type;
  final DateTime timestamp;
  final Map<String, dynamic> data;
  
  PerformanceEvent({
    required this.type,
    required this.timestamp,
    required this.data,
  });
}

/// 事件类型
enum EventType {
  managerInitialized,
  performanceIssue,
  performanceReport,
  networkRequest,
  manualOptimization,
  statsReset,
}

/// 性能问题
class PerformanceIssue {
  final IssueType type;
  final IssueSeverity severity;
  final String description;
  final DateTime timestamp;
  
  PerformanceIssue({
    required this.type,
    required this.severity,
    required this.description,
    required this.timestamp,
  });
  
  Map<String, dynamic> toJson() => {
    'type': type.toString(),
    'severity': severity.toString(),
    'description': description,
    'timestamp': timestamp.toIso8601String(),
  };
}

/// 问题类型
enum IssueType {
  highMemoryUsage,
  lowConnectionSuccessRate,
  lowCacheHitRate,
  poorOverallPerformance,
}

/// 问题严重程度
enum IssueSeverity {
  info,
  warning,
  error,
  critical,
}

/// 性能建议
class PerformanceRecommendation {
  final String title;
  final String description;
  final RecommendationPriority priority;
  final RecommendationCategory category;
  final ImpactLevel estimatedImpact;
  
  PerformanceRecommendation({
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    required this.estimatedImpact,
  });
  
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'priority': priority.toString(),
    'category': category.toString(),
    'estimatedImpact': estimatedImpact.toString(),
  };
}

/// 建议优先级
enum RecommendationPriority {
  low,
  medium,
  high,
  critical,
}

/// 建议类别
enum RecommendationCategory {
  memory,
  network,
  cache,
  overall,
}

/// 影响级别
enum ImpactLevel {
  low,
  medium,
  high,
}

/// 性能报告
class PerformanceReport {
  final DateTime timestamp;
  final double overallScore;
  final MemoryStats memoryStats;
  final NetworkStats networkStats;
  final CacheStats cacheStats;
  final BandwidthStats bandwidthStats;
  final OptimizationStats optimizationStats;
  
  PerformanceReport({
    required this.timestamp,
    required this.overallScore,
    required this.memoryStats,
    required this.networkStats,
    required this.cacheStats,
    required this.bandwidthStats,
    required this.optimizationStats,
  });
  
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'overallScore': overallScore,
    'memoryStats': memoryStats.toJson(),
    'networkStats': networkStats.toJson(),
    'cacheStats': cacheStats.toJson(),
    'bandwidthStats': bandwidthStats.toJson(),
    'optimizationStats': optimizationStats.toJson(),
  };
}

/// 内存统计
class MemoryStats {
  final int currentUsage;
  final int peakUsage;
  
  MemoryStats({
    required this.currentUsage,
    required this.peakUsage,
  });
  
  Map<String, dynamic> toJson() => {
    'currentUsage': currentUsage,
    'peakUsage': peakUsage,
  };
}

/// 网络统计
class NetworkStats {
  final int totalConnections;
  final int activeConnections;
  final double successRate;
  
  NetworkStats({
    required this.totalConnections,
    required this.activeConnections,
    required this.successRate,
  });
  
  Map<String, dynamic> toJson() => {
    'totalConnections': totalConnections,
    'activeConnections': activeConnections,
    'successRate': successRate,
  };
}

/// 缓存统计
class CacheStats {
  final double hitRate;
  final int totalSize;
  
  CacheStats({
    required this.hitRate,
    required this.totalSize,
  });
  
  Map<String, dynamic> toJson() => {
    'hitRate': hitRate,
    'totalSize': totalSize,
  };
}

/// 带宽统计
class BandwidthStats {
  final int currentUsage;
  final int totalRequests;
  
  BandwidthStats({
    required this.currentUsage,
    required this.totalRequests,
  });
  
  Map<String, dynamic> toJson() => {
    'currentUsage': currentUsage,
    'totalRequests': totalRequests,
  };
}

/// 优化统计
class OptimizationStats {
  final int totalOptimizations;
  final Duration avgOptimizationDuration;
  
  OptimizationStats({
    required this.totalOptimizations,
    required this.avgOptimizationDuration,
  });
  
  Map<String, dynamic> toJson() => {
    'totalOptimizations': totalOptimizations,
    'avgOptimizationDuration': avgOptimizationDuration.inMilliseconds,
  };
}

/// 自动优化调度器
class OptimizationScheduler {
  final ProxyPerformanceOptimizer _optimizer;
  final PerformanceManagerConfig _config;
  
  Timer? _schedulerTimer;
  
  OptimizationScheduler(this._optimizer, this._config);
  
  Future<void> initialize() async {
    _startScheduling();
    log('[OptimizationScheduler] 优化调度器已初始化');
  }
  
  void _startScheduling() {
    _schedulerTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _scheduleOptimization(),
    );
  }
  
  void _scheduleOptimization() {
    // 基于时间和条件调度优化
    // 简化实现：每5分钟检查是否需要优化
  }
  
  Future<void> dispose() async {
    _schedulerTimer?.cancel();
    log('[OptimizationScheduler] 优化调度器已销毁');
  }
}

/// 日志辅助函数
void log(String message, {int level = 200, String tag = 'PerformanceManager'}) {
  final logMessage = '[$tag] $message';
  if (level >= 500) {
    developer.log(logMessage, level: level, name: tag);
  }
}