import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;

import 'package:http/http.dart' as http;

/// 性能指标
class PerformanceMetrics {
  final DateTime timestamp;
  final double responseTime; // 毫秒
  final double throughput;   // 请求/秒
  final double successRate;  // 成功率 (0-1)
  final int totalRequests;
  final int successfulRequests;
  final int failedRequests;
  final double errorRate;
  final Map<String, dynamic> additionalMetrics;

  PerformanceMetrics({
    required this.timestamp,
    required this.responseTime,
    required this.throughput,
    required this.successRate,
    required this.totalRequests,
    required this.successfulRequests,
    required this.failedRequests,
    required this.errorRate,
    this.additionalMetrics = const {},
  });

  PerformanceMetrics copyWith({
    DateTime? timestamp,
    double? responseTime,
    double? throughput,
    double? successRate,
    int? totalRequests,
    int? successfulRequests,
    int? failedRequests,
    double? errorRate,
    Map<String, dynamic>? additionalMetrics,
  }) {
    return PerformanceMetrics(
      timestamp: timestamp ?? this.timestamp,
      responseTime: responseTime ?? this.responseTime,
      throughput: throughput ?? this.throughput,
      successRate: successRate ?? this.successRate,
      totalRequests: totalRequests ?? this.totalRequests,
      successfulRequests: successfulRequests ?? this.successfulRequests,
      failedRequests: failedRequests ?? this.failedRequests,
      errorRate: errorRate ?? this.errorRate,
      additionalMetrics: additionalMetrics ?? this.additionalMetrics,
    );
  }

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'responseTime': responseTime,
    'throughput': throughput,
    'successRate': successRate,
    'totalRequests': totalRequests,
    'successfulRequests': successfulRequests,
    'failedRequests': failedRequests,
    'errorRate': errorRate,
    'additionalMetrics': additionalMetrics,
  };

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) => 
    PerformanceMetrics(
      timestamp: DateTime.parse(json['timestamp']),
      responseTime: json['responseTime'].toDouble(),
      throughput: json['throughput'].toDouble(),
      successRate: json['successRate'].toDouble(),
      totalRequests: json['totalRequests'],
      successfulRequests: json['successfulRequests'],
      failedRequests: json['failedRequests'],
      errorRate: json['errorRate'].toDouble(),
      additionalMetrics: json['additionalMetrics'] ?? {},
    );
}

/// 性能监控配置
class PerformanceMonitoringConfig {
  final Duration samplingInterval;
  final int maxSampleCount;
  final List<String> testUrls;
  final Duration timeout;
  final int concurrentRequests;
  final bool enableAutoStart;
  final Duration alertThresholds;

  const PerformanceMonitoringConfig({
    this.samplingInterval = const Duration(seconds: 30),
    this.maxSampleCount = 100,
    this.testUrls = const [;
      'https://www.google.com',
      'https://httpbin.org/get',
      'https://httpbin.org/delay/1',
    ],
    this.timeout = const Duration(seconds: 10),
    this.concurrentRequests = 5,
    this.enableAutoStart = false,
    this.alertThresholds = const Duration(seconds: 5),
  });

  PerformanceMonitoringConfig copyWith({
    Duration? samplingInterval,
    int? maxSampleCount,
    List<String>? testUrls,
    Duration? timeout,
    int? concurrentRequests,
    bool? enableAutoStart,
    Duration? alertThresholds,
  }) {
    return PerformanceMonitoringConfig(
      samplingInterval: samplingInterval ?? this.samplingInterval,
      maxSampleCount: maxSampleCount ?? this.maxSampleCount,
      testUrls: testUrls ?? this.testUrls,
      timeout: timeout ?? this.timeout,
      concurrentRequests: concurrentRequests ?? this.concurrentRequests,
      enableAutoStart: enableAutoStart ?? this.enableAutoStart,
      alertThresholds: alertThresholds ?? this.alertThresholds,
    );
  }
}

/// 代理性能监控器
class ProxyPerformanceMonitor {
  static final ProxyPerformanceMonitor _instance =;
    ProxyPerformanceMonitor._internal();
  factory ProxyPerformanceMonitor() => _instance;
  ProxyPerformanceMonitor._internal();

  // 监控配置
  PerformanceMonitoringConfig _config = const PerformanceMonitoringConfig();
  PerformanceMonitoringConfig get config => _config;

  // 性能数据
  final List<PerformanceMetrics> _metrics = [];
  final StreamController<PerformanceMetrics> _metricsController =;
    StreamController<PerformanceMetrics>.broadcast();
  final StreamController<PerformanceMetrics> _metricsHistoryController =;
    StreamController<List<PerformanceMetrics>>.broadcast();

  // 监控状态
  bool _isMonitoring = false;
  Timer? _monitorTimer;
  DateTime? _lastSampleTime;

  // 统计数据
  int _totalRequests = 0;
  int _successfulRequests = 0;
  int _failedRequests = 0;
  final List<double> _responseTimes = [];
  final List<double> _throughputValues = [];

  Stream<PerformanceMetrics> get metrics => _metricsController.stream;
  Stream<List<PerformanceMetrics>> get metricsHistory => _metricsHistoryController.stream;
  bool get isMonitoring => _isMonitoring;
  List<PerformanceMetrics> get currentMetrics => List.unmodifiable(_metrics);

  /// 配置监控参数
  void configure(PerformanceMonitoringConfig config) {
    _config = config;
    
    if (_config.enableAutoStart && !_isMonitoring) {
      startMonitoring();
    }
  }

  /// 开始监控
  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _lastSampleTime = DateTime.now();
    _monitorTimer = Timer.periodic(_config.samplingInterval, _performSample);
    
    // 立即执行一次采样
    _performSample(_monitorTimer!);
  }

  /// 停止监控
  void stopMonitoring() {
    _isMonitoring = false;
    _monitorTimer?.cancel();
    _monitorTimer = null;
  }

  /// 重置统计数据
  void resetStatistics() {
    _totalRequests = 0;
    _successfulRequests = 0;
    _failedRequests = 0;
    _responseTimes.clear();
    _throughputValues.clear();
    _metrics.clear();
    _metricsHistoryController.add([]);
  }

  /// 执行性能测试
  Future<PerformanceMetrics> runPerformanceTest() async {
    final startTime = DateTime.now();
    final results = <String, dynamic>{};

    try {
      final testResults = <String, double>{};
      int successfulTests = 0;
      int totalTests = 0;

      // 并发测试多个URL
      final futures = _config.testUrls.map((url) => 
        _testUrlPerformance(url)
      ).toList();

      final responses = await Future.wait(futures);
      for (int i = 0; i < responses.length; i++) {
        totalTests++;
        final response = responses[i];
        final url = _config.testUrls[i];
        
        if (response['success']) {
          successfulTests++;
          testResults[url] = response['responseTime'];
        } else {
          testResults[url] = -1; // 失败标记;
        }
      }

      // 计算平均响应时间
      final validResponseTimes = testResults.values;
        .where((time) => time > 0);
        .toList();
      
      double avgResponseTime = 0;
      if (validResponseTimes.isNotEmpty) {
        avgResponseTime = validResponseTimes.reduce((a, b) => a + b) /;
          validResponseTimes.length;
      }

      // 计算成功率
      final successRate = successfulTests / totalTests;

      // 计算吞吐量 (简化计算)
      final testDuration = DateTime.now().difference(startTime).inMilliseconds;
      final throughput = (successfulTests * 1000) / testDuration;

      // 更新统计数据
      _updateStatistics(
        responseTime: avgResponseTime,
        throughput: throughput,
        successRate: successRate,
      );

      final metrics = PerformanceMetrics(
        timestamp: startTime,
        responseTime: avgResponseTime,
        throughput: throughput,
        successRate: successRate,
        totalRequests: totalTests,
        successfulRequests: successfulTests,
        failedRequests: totalTests - successfulTests,
        errorRate: 1 - successRate,
        additionalMetrics: {
          'testResults': testResults,
          'testDuration': testDuration,
          'concurrentRequests': _config.concurrentRequests,
        },
      );

      _addMetrics(metrics);
      _metricsController.add(metrics);

      return metrics;

    } catch (e) {
      // 返回错误指标
      final metrics = PerformanceMetrics(
        timestamp: startTime,
        responseTime: -1,
        throughput: 0,
        successRate: 0,
        totalRequests: _config.testUrls.length,
        successfulRequests: 0,
        failedRequests: _config.testUrls.length,
        errorRate: 1.0,
        additionalMetrics: {'error': e.toString()},
      );

      _addMetrics(metrics);
      _metricsController.add(metrics);

      return metrics;
    }
  }

  /// 测试单个URL性能
  Future<Map<String, dynamic>> _testUrlPerformance(String url) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'PerformanceMonitor/1.0'},
      ).timeout(_config.timeout);
      
      stopwatch.stop();
      
      return {
        'success': response.statusCode == 200,
        'responseTime': stopwatch.elapsedMilliseconds.toDouble(),
        'statusCode': response.statusCode,
        'contentLength': response.contentLength ?? 0,
      };
    } catch (e) {
      stopwatch.stop();
      return {
        'success': false,
        'responseTime': stopwatch.elapsedMilliseconds.toDouble(),
        'error': e.toString(),
      };
    }
  }

  /// 获取历史性能数据
  List<PerformanceMetrics> getMetricsHistory({
    Duration? duration,
    int? limit,
  }) {
    List<PerformanceMetrics> filtered = List.from(_metrics);
    
    if (duration != null) {
      final cutoff = DateTime.now().subtract(duration);
      filtered = filtered.where((m) => m.timestamp.isAfter(cutoff)).toList();
    }
    
    if (limit != null && filtered.length > limit) {
      filtered = filtered.skip(filtered.length - limit).toList();
    }
    
    return filtered;
  }

  /// 获取性能统计摘要
  Map<String, dynamic> getPerformanceSummary({
    Duration duration = const Duration(hours: 1),
  }) {
    final recentMetrics = getMetricsHistory(duration: duration);
    
    if (recentMetrics.isEmpty) {
      return {
        'totalSamples': 0,
        'averageResponseTime': 0,
        'averageThroughput': 0,
        'averageSuccessRate': 0,
        'minResponseTime': 0,
        'maxResponseTime': 0,
        'totalRequests': 0,
        'totalSuccessfulRequests': 0,
        'totalFailedRequests': 0,
      };
    }

    final responseTimes = recentMetrics;
      .where((m) => m.responseTime > 0);
      .map((m) => m.responseTime);
      .toList();
    
    final throughputs = recentMetrics;
      .map((m) => m.throughput);
      .toList();
    
    final successRates = recentMetrics;
      .map((m) => m.successRate);
      .toList();

    final totalRequests = recentMetrics;
      .fold<int>(0, (sum, m) => sum + m.totalRequests);
    final totalSuccessfulRequests = recentMetrics;
      .fold<int>(0, (sum, m) => sum + m.successfulRequests);
    final totalFailedRequests = recentMetrics;
      .fold<int>(0, (sum, m) => sum + m.failedRequests);

    return {
      'totalSamples': recentMetrics.length,
      'averageResponseTime': responseTimes.isNotEmpty 
        ? responseTimes.reduce((a, b) => a + b) / responseTimes.length;
        : 0,
      'averageThroughput': throughputs.isNotEmpty 
        ? throughputs.reduce((a, b) => a + b) / throughputs.length;
        : 0,
      'averageSuccessRate': successRates.isNotEmpty 
        ? successRates.reduce((a, b) => a + b) / successRates.length;
        : 0,
      'minResponseTime': responseTimes.isNotEmpty 
        ? responseTimes.reduce((a, b) => a < b ? a : b);
        : 0,
      'maxResponseTime': responseTimes.isNotEmpty 
        ? responseTimes.reduce((a, b) => a > b ? a : b);
        : 0,
      'totalRequests': totalRequests,
      'totalSuccessfulRequests': totalSuccessfulRequests,
      'totalFailedRequests': totalFailedRequests,
    };
  }

  /// 检查性能告警
  List<Map<String, dynamic>> checkPerformanceAlerts() {
    final alerts = <Map<String, dynamic>>[];
    
    if (_metrics.isEmpty) return alerts;

    final latestMetrics = _metrics.last;
    
    // 检查响应时间告警
    if (latestMetrics.responseTime > _config.alertThresholds.inMilliseconds) {
      alerts.add({
        'type': 'high_response_time',
        'severity': 'warning',
        'message': '响应时间过高: ${latestMetrics.responseTime.toInt()}ms',
        'threshold': _config.alertThresholds.inMilliseconds,
        'current': latestMetrics.responseTime.toInt(),
        'timestamp': latestMetrics.timestamp,
      });
    }
    
    // 检查成功率告警
    if (latestMetrics.successRate < 0.8) {
      alerts.add({
        'type': 'low_success_rate',
        'severity': 'error',
        'message': '成功率过低: ${(latestMetrics.successRate * 100).toStringAsFixed(1)}%',
        'threshold': 0.8,
        'current': latestMetrics.successRate,
        'timestamp': latestMetrics.timestamp,
      });
    }
    
    // 检查错误率告警
    if (latestMetrics.errorRate > 0.2) {
      alerts.add({
        'type': 'high_error_rate',
        'severity': 'error',
        'message': '错误率过高: ${(latestMetrics.errorRate * 100).toStringAsFixed(1)}%',
        'threshold': 0.2,
        'current': latestMetrics.errorRate,
        'timestamp': latestMetrics.timestamp,
      });
    }
    
    return alerts;
  }

  /// 导出性能数据
  Future<String> exportMetrics({Duration? duration}) async {
    final data = getMetricsHistory(duration: duration);
    final jsonData = {
      'exportTime': DateTime.now().toIso8601String(),
      'duration': duration?.inHours ?? 0,
      'totalMetrics': data.length,
      'summary': getPerformanceSummary(duration: duration),
      'metrics': data.map((m) => m.toJson()).toList(),
    };
    
    return jsonEncode(jsonData);
  }

  /// 清理过期数据
  void cleanupOldMetrics({Duration retention = const Duration(days: 7)}) {
    final cutoff = DateTime.now().subtract(retention);
    _metrics.removeWhere((m) => m.timestamp.isBefore(cutoff));
    _metricsHistoryController.add(List.from(_metrics));
  }

  // 私有方法

  void _performSample(Timer timer) {
    if (!_isMonitoring) return;

    runPerformanceTest().catchError((error) {
      // 静默处理错误，避免干扰监控流程
    });
  }

  void _updateStatistics({
    required double responseTime,
    required double throughput,
    required double successRate,
  }) {
    _totalRequests++;
    if (responseTime > 0) {
      _responseTimes.add(responseTime);
      if (_responseTimes.length > 100) {
        _responseTimes.removeAt(0);
      }
    }
    
    _throughputValues.add(throughput);
    if (_throughputValues.length > 100) {
      _throughputValues.removeAt(0);
    }
    
    if (successRate > 0) {
      _successfulRequests++;
    } else {
      _failedRequests++;
    }
  }

  void _addMetrics(PerformanceMetrics metrics) {
    _metrics.add(metrics);
    
    // 限制样本数量
    if (_metrics.length > _config.maxSampleCount) {
      _metrics.removeAt(0);
    }
    
    // 通知历史数据更新
    _metricsHistoryController.add(List.from(_metrics));
  }

  /// 资源清理
  void dispose() {
    stopMonitoring();
    _metricsController.close();
    _metricsHistoryController.close();
  }
}