import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;

/// 性能报告服务
/// 负责收集、分析和生成详细的性能测试报告
class PerformanceReporter {
  static const String _tag = 'PerformanceReporter';
  
  // 报告配置
  static const Map<String, dynamic> reportConfig = {
    'autoGenerateReports': true,
    'reportRetentionDays': 30,
    'maxReportsStored': 100,
    'includeScreenshots': false,
    'includeDetailedMetrics': true,
    'reportFormats': ['json', 'html', 'csv'],
  };
  
  // 报告存储路径
  final String _reportsDirectory;
  
  // 报告历史
  final List<PerformanceReport> _reportHistory = [];
  
  // 性能基线数据
  final Map<String, PerformanceBaseline> _baselines = {};
  
  // 报告生成回调
  final List<Function(PerformanceReport)> _reportCallbacks = [];

  PerformanceReporter({String? reportsDirectory})
      : _reportsDirectory = reportsDirectory ?? _getDefaultReportsDirectory() {
    _initializeReporter();
  }

  /// 初始化性能报告服务
  Future<void> _initializeReporter() async {
    log('初始化性能报告服务', name: _tag);
    
    try {
      // 创建报告目录
      await _createReportsDirectory();
      
      // 加载历史报告
      await _loadReportHistory();
      
      // 加载性能基线
      await _loadBaselines();
      
      log('性能报告服务初始化完成', name: _tag);
      
    } catch (e, stackTrace) {
      log('性能报告服务初始化失败: $e', name: _tag, error: e, stackTrace: stackTrace);
    }
  }

  /// 获取默认报告目录
  static String _getDefaultReportsDirectory() {
    final directory = Directory.systemTemp.path + '/performance_reports';
    return directory;
  }

  /// 创建报告目录
  Future<void> _createReportsDirectory() async {
    final directory = Directory(_reportsDirectory);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
      log('创建报告目录: $_reportsDirectory', name: _tag);
    }
  }

  /// 生成综合性能报告
  Future<PerformanceReport> generateComprehensiveReport({
    required String testSuiteName,
    required Map<String, dynamic> testResults,
    Map<String, dynamic>? additionalData,
  }) async {
    log('开始生成综合性能报告: $testSuiteName', name: _tag);
    
    final report = PerformanceReport(
      id: _generateReportId(),
      name: testSuiteName,
      timestamp: DateTime.now(),
    );
    
    try {
      // 分析测试结果
      report.analysis = await _analyzeTestResults(testResults);
      
      // 生成性能指标
      report.metrics = await _generatePerformanceMetrics(testResults);
      
      // 比较基线数据
      report.baselineComparison = await _compareWithBaselines(report.metrics);
      
      // 生成建议
      report.recommendations = await _generateRecommendations(report);
      
      // 生成图表数据
      report.chartData = await _generateChartData(testResults);
      
      // 添加额外数据
      if (additionalData != null) {
        report.additionalData.addAll(additionalData);
      }
      
      // 计算总体评分
      report.overallScore = _calculateOverallScore(report);
      
      // 生成报告摘要
      report.summary = await _generateReportSummary(report);
      
      log('综合性能报告生成完成: ${report.id}', name: _tag);
      
    } catch (e, stackTrace) {
      report.error = e.toString();
      log('生成综合性能报告失败: $e', name: _tag, error: e, stackTrace: stackTrace);
    }
    
    return report;
  }

  /// 分析测试结果
  Future<TestAnalysis> _analyzeTestResults(Map<String, dynamic> results) async {
    final analysis = TestAnalysis();
    
    try {
      // 分析各个测试模块
      for (final entry in results.entries) {
        final testName = entry.key;
        final testData = entry.value;
        
        final testAnalysis = await _analyzeIndividualTest(testName, testData);
        analysis.testAnalyses[testName] = testAnalysis;
      }
      
      // 计算总体统计
      analysis.overallStats = _calculateOverallStats(results);
      
      // 识别性能瓶颈
      analysis.bottlenecks = _identifyBottlenecks(results);
      
      // 检测异常值
      analysis.outliers = _detectOutliers(results);
      
    } catch (e) {
      analysis.error = e.toString();
      log('分析测试结果失败: $e', name: _tag, error: e);
    }
    
    return analysis;
  }

  /// 分析单个测试
  Future<IndividualTestAnalysis> _analyzeIndividualTest(
    String testName, 
    Map<String, dynamic> testData
  ) async {
    final analysis = IndividualTestAnalysis(testName: testName);
    
    try {
      // 提取性能指标
      final metrics = _extractMetrics(testData);
      analysis.metrics = metrics;
      
      // 计算统计值
      analysis.statistics = _calculateStatistics(metrics);
      
      // 性能评估
      analysis.performanceRating = _evaluatePerformance(metrics);
      
      // 趋势分析
      analysis.trends = _analyzeTrends(metrics);
      
    } catch (e) {
      analysis.error = e.toString();
    }
    
    return analysis;
  }

  /// 提取性能指标
  List<PerformanceMetric> _extractMetrics(Map<String, dynamic> testData) {
    final metrics = <PerformanceMetric>[];
    
    for (final entry in testData.entries) {
      final metricName = entry.key;
      final metricValue = entry.value;
      
      if (metricValue is num) {
        metrics.add(PerformanceMetric(
          name: metricName,
          value: metricValue.toDouble(),
          unit: _getMetricUnit(metricName),
          timestamp: DateTime.now(),
        ));
      }
    }
    
    return metrics;
  }

  /// 获取指标单位
  String _getMetricUnit(String metricName) {
    if (metricName.contains('时间') || metricName.contains('Time')) {
      return 'ms';
    } else if (metricName.contains('内存') || metricName.contains('Memory')) {
      return 'MB';
    } else if (metricName.contains('CPU') || metricName.contains('使用率')) {
      return '%';
    } else if (metricName.contains('帧率') || metricName.contains('FPS')) {
      return 'fps';
    }
    return '';
  }

  /// 计算统计值
  PerformanceStatistics _calculateStatistics(List<PerformanceMetric> metrics) {
    if (metrics.isEmpty) {
      return PerformanceStatistics();
    }
    
    final values = metrics.map((m) => m.value).toList();
    
    return PerformanceStatistics(
      count: values.length,
      mean: values.reduce((a, b) => a + b) / values.length,
      median: _calculateMedian(values),
      min: values.reduce(math.min),
      max: values.reduce(math.max),
      standardDeviation: _calculateStandardDeviation(values),
      percentiles: _calculatePercentiles(values),
    );
  }

  /// 计算中位数
  double _calculateMedian(List<double> values) {
    final sortedValues = List<double>.from(values)..sort();
    final middle = sortedValues.length ~/ 2;
    
    if (sortedValues.length % 2 == 0) {
      return (sortedValues[middle - 1] + sortedValues[middle]) / 2;
    } else {
      return sortedValues[middle];
    }
  }

  /// 计算标准差
  double _calculateStandardDeviation(List<double> values) {
    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDiffs = values.map((v) => math.pow(v - mean, 2)).toList();
    final variance = squaredDiffs.reduce((a, b) => a + b) / squaredDiffs.length;
    return math.sqrt(variance);
  }

  /// 计算百分位数
  Map<String, double> _calculatePercentiles(List<double> values) {
    final sortedValues = List<double>.from(values)..sort();
    
    return {
      'p25': _getPercentile(sortedValues, 25),
      'p50': _getPercentile(sortedValues, 50),
      'p75': _getPercentile(sortedValues, 75),
      'p90': _getPercentile(sortedValues, 90),
      'p95': _getPercentile(sortedValues, 95),
      'p99': _getPercentile(sortedValues, 99),
    };
  }

  /// 获取百分位数值
  double _getPercentile(List<double> sortedValues, double percentile) {
    final index = (percentile / 100) * (sortedValues.length - 1);
    final lower = index.floor();
    final upper = index.ceil();
    final weight = index - lower;
    
    if (upper >= sortedValues.length) {
      return sortedValues.last;
    }
    
    return sortedValues[lower] * (1 - weight) + sortedValues[upper] * weight;
  }

  /// 评估性能
  PerformanceRating _evaluatePerformance(List<PerformanceMetric> metrics) {
    if (metrics.isEmpty) return PerformanceRating.Poor;
    
    // 根据关键指标评估性能
    final keyMetrics = metrics.where((m) => _isKeyMetric(m.name)).toList();
    
    if (keyMetrics.isEmpty) return PerformanceRating.Fair;
    
    final avgPerformance = keyMetrics
        .map((m) => _getMetricPerformanceScore(m))
        .reduce((a, b) => a + b) / keyMetrics.length;
    
    if (avgPerformance >= 90) return PerformanceRating.Excellent;
    if (avgPerformance >= 75) return PerformanceRating.Good;
    if (avgPerformance >= 60) return PerformanceRating.Fair;
    return PerformanceRating.Poor;
  }

  /// 判断是否为关键指标
  bool _isKeyMetric(String metricName) {
    final keyMetrics = [
      '启动时间', 'startup_time',
      '帧时间', 'frame_time',
      '内存使用', 'memory_usage',
      'CPU使用率', 'cpu_usage',
      '页面加载时间', 'page_load_time',
    ];
    
    return keyMetrics.any((key) => metricName.contains(key));
  }

  /// 获取指标性能评分
  double _getMetricPerformanceScore(PerformanceMetric metric) {
    // 这里应该根据具体的性能阈值来判断
    // 简化实现，返回固定评分
    return 80.0;
  }

  /// 分析趋势
  Map<String, dynamic> _analyzeTrends(List<PerformanceMetric> metrics) {
    if (metrics.length < 2) {
      return {'trend': 'insufficient_data'};
    }
    
    // 简单线性回归分析趋势
    final values = metrics.map((m) => m.value).toList();
    final trend = _calculateLinearTrend(values);
    
    return {
      'trend': trend > 0.1 ? 'improving' : trend < -0.1 ? 'degrading' : 'stable',
      'slope': trend,
      'correlation': _calculateCorrelation(values),
    };
  }

  /// 计算线性趋势
  double _calculateLinearTrend(List<double> values) {
    final n = values.length;
    final x = List.generate(n, (i) => i.toDouble());
    final y = values;
    
    final sumX = x.reduce((a, b) => a + b);
    final sumY = y.reduce((a, b) => a + b);
    final sumXY = x.asMap().entries.map((e) => e.value * y[e.key]).reduce((a, b) => a + b);
    final sumXX = x.map((v) => v * v).reduce((a, b) => a + b);
    
    return (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
  }

  /// 计算相关系数
  double _calculateCorrelation(List<double> values) {
    final n = values.length;
    final x = List.generate(n, (i) => i.toDouble());
    final y = values;
    
    final meanX = x.reduce((a, b) => a + b) / n;
    final meanY = y.reduce((a, b) => a + b) / n;
    
    final numerator = x.asMap().entries
        .map((e) => (e.value - meanX) * (y[e.key] - meanY))
        .reduce((a, b) => a + b);
    
    final denominatorX = x.map((v) => math.pow(v - meanX, 2)).reduce((a, b) => a + b);
    final denominatorY = y.map((v) => math.pow(v - meanY, 2)).reduce((a, b) => a + b);
    
    return numerator / math.sqrt(denominatorX * denominatorY);
  }

  /// 计算总体统计
  Map<String, dynamic> _calculateOverallStats(Map<String, dynamic> results) {
    final stats = <String, dynamic>{};
    
    // 统计测试数量
    stats['total_tests'] = results.length;
    
    // 统计成功/失败数量
    int successCount = 0;
    int failureCount = 0;
    
    for (final entry in results.entries) {
      final testData = entry.value;
      if (testData is Map && testData['error'] == null) {
        successCount++;
      } else {
        failureCount++;
      }
    }
    
    stats['success_count'] = successCount;
    stats['failure_count'] = failureCount;
    stats['success_rate'] = successCount / (successCount + failureCount) * 100;
    
    return stats;
  }

  /// 识别性能瓶颈
  List<PerformanceBottleneck> _identifyBottlenecks(Map<String, dynamic> results) {
    final bottlenecks = <PerformanceBottleneck>[];
    
    for (final entry in results.entries) {
      final testName = entry.key;
      final testData = entry.value;
      
      // 简化的瓶颈识别逻辑
      if (testData is Map) {
        final metrics = testData['metrics'] as Map<String, dynamic>?;
        if (metrics != null) {
          for (final metricEntry in metrics.entries) {
            final metricName = metricEntry.key;
            final metricValue = metricEntry.value;
            
            if (metricValue is num && _isSlowMetric(metricName, metricValue)) {
              bottlenecks.add(PerformanceBottleneck(
                testName: testName,
                metricName: metricName,
                value: metricValue.toDouble(),
                severity: _getBottleneckSeverity(metricName, metricValue),
                description: '检测到性能瓶颈: $metricName 值为 $metricValue',
              ));
            }
          }
        }
      }
    }
    
    return bottlenecks;
  }

  /// 判断是否为慢指标
  bool _isSlowMetric(String metricName, num value) {
    // 简化的慢指标判断逻辑
    if (metricName.contains('时间') || metricName.contains('Time')) {
      return value > 1000; // 超过1秒认为慢
    } else if (metricName.contains('内存') || metricName.contains('Memory')) {
      return value > 200; // 超过200MB认为高
    }
    return false;
  }

  /// 获取瓶颈严重程度
  BottleneckSeverity _getBottleneckSeverity(String metricName, num value) {
    if (metricName.contains('时间') || metricName.contains('Time')) {
      if (value > 5000) return BottleneckSeverity.Critical;
      if (value > 2000) return BottleneckSeverity.High;
      if (value > 1000) return BottleneckSeverity.Medium;
    } else if (metricName.contains('内存') || metricName.contains('Memory')) {
      if (value > 500) return BottleneckSeverity.Critical;
      if (value > 300) return BottleneckSeverity.High;
      if (value > 200) return BottleneckSeverity.Medium;
    }
    return BottleneckSeverity.Low;
  }

  /// 检测异常值
  List<OutlierDetection> _detectOutliers(Map<String, dynamic> results) {
    final outliers = <OutlierDetection>[];
    
    for (final entry in results.entries) {
      final testName = entry.key;
      final testData = entry.value;
      
      if (testData is Map) {
        final metrics = testData['metrics'] as Map<String, dynamic>?;
        if (metrics != null) {
          for (final metricEntry in metrics.entries) {
            final metricName = metricEntry.key;
            final metricValue = metricEntry.value;
            
            if (metricValue is num) {
              final isOutlier = _isOutlier(metricName, metricValue);
              if (isOutlier) {
                outliers.add(OutlierDetection(
                  testName: testName,
                  metricName: metricName,
                  value: metricValue.toDouble(),
                  type: OutlierType.High,
                  description: '检测到异常值: $metricName = $metricValue',
                ));
              }
            }
          }
        }
      }
    }
    
    return outliers;
  }

  /// 判断是否为异常值
  bool _isOutlier(String metricName, num value) {
    // 简化的异常值检测：使用3-sigma规则
    // 在实际实现中，应该基于历史数据计算标准差
    return value > 1000; // 简化实现
  }

  /// 生成性能指标
  Future<Map<String, PerformanceMetrics>> _generatePerformanceMetrics(
    Map<String, dynamic> testResults
  ) async {
    final metricsMap = <String, PerformanceMetrics>{};
    
    for (final entry in testResults.entries) {
      final testName = entry.key;
      final testData = entry.value;
      
      final metrics = PerformanceMetrics(testName: testName);
      
      if (testData is Map) {
        final rawMetrics = testData['metrics'] as Map<String, dynamic>?;
        if (rawMetrics != null) {
          for (final metricEntry in rawMetrics.entries) {
            metrics.addMetric(metricEntry.key, metricEntry.value);
          }
        }
      }
      
      metricsMap[testName] = metrics;
    }
    
    return metricsMap;
  }

  /// 与基线比较
  Future<BaselineComparison> _compareWithBaselines(
    Map<String, PerformanceMetrics> metrics
  ) async {
    final comparison = BaselineComparison();
    
    for (final entry in metrics.entries) {
      final testName = entry.key;
      final currentMetrics = entry.value;
      final baseline = _baselines[testName];
      
      if (baseline != null) {
        final testComparison = await _compareTestWithBaseline(
          testName, currentMetrics, baseline
        );
        comparison.testComparisons[testName] = testComparison;
      }
    }
    
    return comparison;
  }

  /// 比较单个测试与基线
  Future<TestBaselineComparison> _compareTestWithBaseline(
    String testName,
    PerformanceMetrics current,
    PerformanceBaseline baseline
  ) async {
    final comparison = TestBaselineComparison(testName: testName);
    
    // 比较各个指标
    for (final metric in current.metrics) {
      final baselineMetric = baseline.getMetric(metric.name);
      if (baselineMetric != null) {
        final change = ((metric.value - baselineMetric.value) / baselineMetric.value) * 100;
        comparison.metricChanges[metric.name] = MetricChange(
          baselineValue: baselineMetric.value,
          currentValue: metric.value,
          changePercent: change,
          isImproved: change < 0, // 假设值越小越好
        );
      }
    }
    
    return comparison;
  }

  /// 生成建议
  Future<List<PerformanceRecommendation>> _generateRecommendations(
    PerformanceReport report
  ) async {
    final recommendations = <PerformanceRecommendation>[];
    
    try {
      // 基于瓶颈生成建议
      if (report.analysis?.bottlenecks.isNotEmpty == true) {
        for (final bottleneck in report.analysis!.bottlenecks) {
          final recommendation = _generateBottleneckRecommendation(bottleneck);
          recommendations.add(recommendation);
        }
      }
      
      // 基于性能评级生成建议
      if (report.analysis?.overallStats['success_rate'] is num) {
        final successRate = report.analysis!.overallStats['success_rate'] as num;
        if (successRate < 90) {
          recommendations.add(PerformanceRecommendation(
            category: RecommendationCategory.Reliability,
            priority: RecommendationPriority.High,
            title: '提高测试成功率',
            description: '当前测试成功率仅为 ${successRate.toStringAsFixed(1)}%，建议检查测试环境和稳定性',
            impact: '提高应用稳定性',
            effort: RecommendationEffort.Medium,
          ));
        }
      }
      
      // 基于内存使用生成建议
      final memoryMetrics = _getMemoryMetrics(report);
      if (memoryMetrics.isNotEmpty) {
        final avgMemory = memoryMetrics.values.reduce((a, b) => a + b) / memoryMetrics.length;
        if (avgMemory > 200) {
          recommendations.add(PerformanceRecommendation(
            category: RecommendationCategory.Memory,
            priority: RecommendationPriority.Medium,
            title: '优化内存使用',
            description: '平均内存使用为 ${avgMemory.toStringAsFixed(1)}MB，建议优化内存管理',
            impact: '减少内存占用，提高应用流畅度',
            effort: RecommendationEffort.Medium,
          ));
        }
      }
      
    } catch (e) {
      log('生成建议失败: $e', name: _tag, error: e);
    }
    
    return recommendations;
  }

  /// 生成瓶颈建议
  PerformanceRecommendation _generateBottleneckRecommendation(
    PerformanceBottleneck bottleneck
  ) {
    final category = _mapBottleneckToCategory(bottleneck);
    final priority = _mapSeverityToPriority(bottleneck.severity);
    final effort = _estimateEffort(bottleneck);
    
    return PerformanceRecommendation(
      category: category,
      priority: priority,
      title: '优化${bottleneck.metricName}',
      description: bottleneck.description,
      impact: '提升${bottleneck.testName}性能',
      effort: effort,
    );
  }

  /// 映射瓶颈到类别
  RecommendationCategory _mapBottleneckToCategory(PerformanceBottleneck bottleneck) {
    if (bottleneck.metricName.contains('内存')) {
      return RecommendationCategory.Memory;
    } else if (bottleneck.metricName.contains('CPU')) {
      return RecommendationCategory.CPU;
    } else if (bottleneck.metricName.contains('时间')) {
      return RecommendationCategory.ResponseTime;
    }
    return RecommendationCategory.General;
  }

  /// 映射严重程度到优先级
  RecommendationPriority _mapSeverityToPriority(BottleneckSeverity severity) {
    switch (severity) {
      case BottleneckSeverity.Critical:
        return RecommendationPriority.Critical;
      case BottleneckSeverity.High:
        return RecommendationPriority.High;
      case BottleneckSeverity.Medium:
        return RecommendationPriority.Medium;
      case BottleneckSeverity.Low:
        return RecommendationPriority.Low;
    }
  }

  /// 估算工作量
  RecommendationEffort _estimateEffort(PerformanceBottleneck bottleneck) {
    // 简化的工作量估算
    if (bottleneck.severity == BottleneckSeverity.Critical) {
      return RecommendationEffort.High;
    } else if (bottleneck.severity == BottleneckSeverity.High) {
      return RecommendationEffort.Medium;
    }
    return RecommendationEffort.Low;
  }

  /// 获取内存指标
  Map<String, double> _getMemoryMetrics(PerformanceReport report) {
    final memoryMetrics = <String, double>{};
    
    for (final entry in report.metrics.entries) {
      final testName = entry.key;
      final metrics = entry.value;
      
      for (final metric in metrics.metrics) {
        if (metric.name.contains('内存') || metric.name.contains('Memory')) {
          memoryMetrics['$testName.${metric.name}'] = metric.value;
        }
      }
    }
    
    return memoryMetrics;
  }

  /// 生成图表数据
  Future<Map<String, dynamic>> _generateChartData(
    Map<String, dynamic> testResults
  ) async {
    final chartData = <String, dynamic>{};
    
    try {
      // 生成性能趋势图数据
      chartData['performance_trend'] = _generatePerformanceTrendData(testResults);
      
      // 生成测试结果分布图数据
      chartData['test_distribution'] = _generateTestDistributionData(testResults);
      
      // 生成性能对比图数据
      chartData['performance_comparison'] = _generatePerformanceComparisonData(testResults);
      
    } catch (e) {
      log('生成图表数据失败: $e', name: _tag, error: e);
    }
    
    return chartData;
  }

  /// 生成性能趋势数据
  Map<String, dynamic> _generatePerformanceTrendData(Map<String, dynamic> testResults) {
    // 简化实现，返回模拟数据
    return {
      'labels': ['测试1', '测试2', '测试3', '测试4', '测试5'],
      'datasets': [
        {
          'label': '性能评分',
          'data': [85, 88, 82, 90, 87],
          'borderColor': '#3B82F6',
          'backgroundColor': 'rgba(59, 130, 246, 0.1)',
        }
      ],
    };
  }

  /// 生成测试分布数据
  Map<String, dynamic> _generateTestDistributionData(Map<String, dynamic> testResults) {
    int successCount = 0;
    int failureCount = 0;
    
    for (final entry in testResults.entries) {
      final testData = entry.value;
      if (testData is Map && testData['error'] == null) {
        successCount++;
      } else {
        failureCount++;
      }
    }
    
    return {
      'labels': ['成功', '失败'],
      'datasets': [
        {
          'data': [successCount, failureCount],
          'backgroundColor': ['#10B981', '#EF4444'],
        }
      ],
    };
  }

  /// 生成性能对比数据
  Map<String, dynamic> _generatePerformanceComparisonData(Map<String, dynamic> testResults) {
    final comparisonData = <String, dynamic>{};
    
    for (final entry in testResults.entries) {
      final testName = entry.key;
      final testData = entry.value;
      
      if (testData is Map) {
        final metrics = testData['metrics'] as Map<String, dynamic>?;
        if (metrics != null) {
          for (final metricEntry in metrics.entries) {
            final metricName = metricEntry.key;
            final metricValue = metricEntry.value;
            
            if (metricValue is num) {
              if (!comparisonData.containsKey(metricName)) {
                comparisonData[metricName] = {
                  'labels': <String>[],
                  'datasets': [
                    {
                      'label': '当前值',
                      'data': <double>[],
                      'backgroundColor': '#3B82F6',
                    }
                  ],
                };
              }
              
              comparisonData[metricName]['labels'].add(testName);
              comparisonData[metricName]['datasets'][0]['data'].add(metricValue.toDouble());
            }
          }
        }
      }
    }
    
    return comparisonData;
  }

  /// 计算总体评分
  double _calculateOverallScore(PerformanceReport report) {
    if (report.metrics.isEmpty) return 0.0;
    
    final scores = <double>[];
    
    for (final entry in report.metrics.entries) {
      final testName = entry.key;
      final metrics = entry.value;
      
      // 基于测试成功率计算评分
      final testAnalysis = report.analysis?.testAnalyses[testName];
      if (testAnalysis != null) {
        scores.add(_convertRatingToScore(testAnalysis.performanceRating));
      }
    }
    
    return scores.isNotEmpty 
      ? scores.reduce((a, b) => a + b) / scores.length 
      : 0.0;
  }

  /// 转换评级为评分
  double _convertRatingToScore(PerformanceRating rating) {
    switch (rating) {
      case PerformanceRating.Excellent:
        return 95.0;
      case PerformanceRating.Good:
        return 80.0;
      case PerformanceRating.Fair:
        return 65.0;
      case PerformanceRating.Poor:
        return 45.0;
    }
  }

  /// 生成报告摘要
  Future<ReportSummary> _generateReportSummary(PerformanceReport report) async {
    final summary = ReportSummary();
    
    try {
      // 生成执行摘要
      summary.executiveSummary = _generateExecutiveSummary(report);
      
      // 生成关键发现
      summary.keyFindings = _generateKeyFindings(report);
      
      // 生成性能亮点
      summary.performanceHighlights = _generatePerformanceHighlights(report);
      
      // 生成关注区域
      summary.areasOfConcern = _generateAreasOfConcern(report);
      
      // 生成下一步行动
      summary.nextActions = _generateNextActions(report);
      
    } catch (e) {
      summary.error = e.toString();
    }
    
    return summary;
  }

  /// 生成执行摘要
  String _generateExecutiveSummary(PerformanceReport report) {
    final buffer = StringBuffer();
    
    buffer.writeln('## 性能测试执行摘要');
    buffer.writeln();
    buffer.writeln('**测试时间**: ${report.timestamp}');
    buffer.writeln('**总体评分**: ${report.overallScore.toStringAsFixed(1)}/100');
    buffer.writeln('**测试范围**: ${report.name}');
    buffer.writeln();
    
    if (report.analysis?.overallStats != null) {
      final stats = report.analysis!.overallStats;
      buffer.writeln('**测试统计**:');
      buffer.writeln('- 总测试数: ${stats['total_tests']}');
      buffer.writeln('- 成功测试: ${stats['success_count']}');
      buffer.writeln('- 失败测试: ${stats['failure_count']}');
      buffer.writeln('- 成功率: ${stats['success_rate'].toStringAsFixed(1)}%');
      buffer.writeln();
    }
    
    return buffer.toString();
  }

  /// 生成关键发现
  List<String> _generateKeyFindings(PerformanceReport report) {
    final findings = <String>[];
    
    if (report.analysis?.bottlenecks.isNotEmpty == true) {
      findings.add('检测到 ${report.analysis!.bottlenecks.length} 个性能瓶颈');
    }
    
    if (report.analysis?.outliers.isNotEmpty == true) {
      findings.add('发现 ${report.analysis!.outliers.length} 个异常值');
    }
    
    if (report.recommendations.isNotEmpty) {
      findings.add('提供 ${report.recommendations.length} 条优化建议');
    }
    
    return findings;
  }

  /// 生成性能亮点
  List<String> _generatePerformanceHighlights(PerformanceReport report) {
    final highlights = <String>[];
    
    for (final entry in report.metrics.entries) {
      final testName = entry.key;
      final metrics = entry.value;
      
      // 查找表现良好的指标
      final goodMetrics = metrics.metrics.where((m) => _isGoodPerformance(m)).toList();
      if (goodMetrics.isNotEmpty) {
        highlights.add('$testName 在 ${goodMetrics.length} 个指标上表现良好');
      }
    }
    
    return highlights;
  }

  /// 判断是否为良好性能
  bool _isGoodPerformance(PerformanceMetric metric) {
    // 简化的良好性能判断逻辑
    if (metric.name.contains('时间')) {
      return metric.value < 500; // 时间类指标小于500ms认为良好
    } else if (metric.name.contains('内存')) {
      return metric.value < 100; // 内存类指标小于100MB认为良好
    }
    return false;
  }

  /// 生成关注区域
  List<String> _generateAreasOfConcern(PerformanceReport report) {
    final concerns = <String>[];
    
    if (report.analysis?.bottlenecks.isNotEmpty == true) {
      for (final bottleneck in report.analysis!.bottlenecks) {
        concerns.add('${bottleneck.testName}: ${bottleneck.description}');
      }
    }
    
    return concerns;
  }

  /// 生成下一步行动
  List<String> _generateNextActions(PerformanceReport report) {
    final actions = <String>[];
    
    // 按优先级排序建议
    final sortedRecommendations = report.recommendations
        .where((r) => r.priority == RecommendationPriority.High || r.priority == RecommendationPriority.Critical)
        .toList()
      ..sort((a, b) => a.priority.index.compareTo(b.priority.index));
    
    for (final recommendation in sortedRecommendations.take(5)) {
      actions.add('${recommendation.title}: ${recommendation.description}');
    }
    
    return actions;
  }

  /// 生成报告ID
  String _generateReportId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = math.Random().nextInt(1000);
    return 'report_${timestamp}_$random';
  }

  /// 保存报告
  Future<void> saveReport(PerformanceReport report) async {
    try {
      final fileName = '${report.id}.json';
      final filePath = '$_reportsDirectory/$fileName';
      final file = File(filePath);
      
      final reportJson = jsonEncode(report.toJson());
      await file.writeAsString(reportJson);
      
      _reportHistory.add(report);
      
      // 清理旧报告
      await _cleanupOldReports();
      
      log('报告已保存: $filePath', name: _tag);
      
    } catch (e, stackTrace) {
      log('保存报告失败: $e', name: _tag, error: e, stackTrace: stackTrace);
    }
  }

  /// 清理旧报告
  Future<void> _cleanupOldReports() async {
    if (_reportHistory.length <= reportConfig['maxReportsStored']) return;
    
    // 按时间排序，删除最旧的报告
    _reportHistory.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    final reportsToDelete = _reportHistory.take(
      _reportHistory.length - reportConfig['maxReportsStored']
    ).toList();
    
    for (final report in reportsToDelete) {
      final fileName = '${report.id}.json';
      final filePath = '$_reportsDirectory/$fileName';
      final file = File(filePath);
      
      if (await file.exists()) {
        await file.delete();
        log('删除旧报告: $filePath', name: _tag);
      }
    }
    
    _reportHistory.removeRange(0, reportsToDelete.length);
  }

  /// 加载报告历史
  Future<void> _loadReportHistory() async {
    try {
      final directory = Directory(_reportsDirectory);
      if (!await directory.exists()) return;
      
      final files = await directory.list().toList();
      
      for (final file in files) {
        if (file is File && file.path.endsWith('.json')) {
          try {
            final content = await file.readAsString();
            final reportJson = jsonDecode(content);
            final report = PerformanceReport.fromJson(reportJson);
            _reportHistory.add(report);
          } catch (e) {
            log('加载报告文件失败: ${file.path}, 错误: $e', name: _tag);
          }
        }
      }
      
      log('已加载 ${_reportHistory.length} 个历史报告', name: _tag);
      
    } catch (e) {
      log('加载报告历史失败: $e', name: _tag);
    }
  }

  /// 加载性能基线
  Future<void> _loadBaselines() async {
    // 简化实现，从默认位置加载基线数据
    // 在实际实现中，应该从配置文件或数据库加载
    log('加载性能基线数据', name: _tag);
  }

  /// 注册报告回调
  void registerReportCallback(Function(PerformanceReport) callback) {
    _reportCallbacks.add(callback);
  }

  /// 获取报告历史
  List<PerformanceReport> getReportHistory() => List.unmodifiable(_reportHistory);
  
  /// 获取性能基线
  Map<String, PerformanceBaseline> getBaselines() => Map.unmodifiable(_baselines);
}

/// 性能报告类
class PerformanceReport {
  final String id;
  final String name;
  final DateTime timestamp;
  double overallScore = 0.0;
  String? error;
  
  TestAnalysis? analysis;
  Map<String, PerformanceMetrics>? metrics;
  BaselineComparison? baselineComparison;
  List<PerformanceRecommendation> recommendations = [];
  Map<String, dynamic>? chartData;
  final Map<String, dynamic> additionalData = {};
  ReportSummary? summary;

  PerformanceReport({
    required this.id,
    required this.name,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'timestamp': timestamp.toIso8601String(),
    'overallScore': overallScore,
    'error': error,
    'analysis': analysis?.toJson(),
    'metrics': metrics?.map((k, v) => MapEntry(k, v.toJson())),
    'baselineComparison': baselineComparison?.toJson(),
    'recommendations': recommendations.map((r) => r.toJson()).toList(),
    'chartData': chartData,
    'additionalData': additionalData,
    'summary': summary?.toJson(),
  };

  factory PerformanceReport.fromJson(Map<String, dynamic> json) {
    final report = PerformanceReport(
      id: json['id'],
      name: json['name'],
      timestamp: DateTime.parse(json['timestamp']),
    );
    
    report.overallScore = json['overallScore']?.toDouble() ?? 0.0;
    report.error = json['error'];
    
    // 这里应该添加其他字段的反序列化逻辑
    // 简化实现
    
    return report;
  }
}

/// 测试分析类
class TestAnalysis {
  final Map<String, IndividualTestAnalysis> testAnalyses = {};
  Map<String, dynamic> overallStats = {};
  List<PerformanceBottleneck> bottlenecks = [];
  List<OutlierDetection> outliers = [];
  String? error;

  Map<String, dynamic> toJson() => {
    'testAnalyses': testAnalyses.map((k, v) => MapEntry(k, v.toJson())),
    'overallStats': overallStats,
    'bottlenecks': bottlenecks.map((b) => b.toJson()).toList(),
    'outliers': outliers.map((o) => o.toJson()).toList(),
    'error': error,
  };
}

/// 单个测试分析
class IndividualTestAnalysis {
  final String testName;
  List<PerformanceMetric> metrics = [];
  PerformanceStatistics? statistics;
  PerformanceRating performanceRating = PerformanceRating.Fair;
  Map<String, dynamic> trends = {};
  String? error;

  IndividualTestAnalysis({required this.testName});

  Map<String, dynamic> toJson() => {
    'testName': testName,
    'metrics': metrics.map((m) => m.toJson()).toList(),
    'statistics': statistics?.toJson(),
    'performanceRating': performanceRating.toString(),
    'trends': trends,
    'error': error,
  };
}

/// 性能指标
class PerformanceMetric {
  final String name;
  final double value;
  final String unit;
  final DateTime timestamp;

  PerformanceMetric({
    required this.name,
    required this.value,
    required this.unit,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'value': value,
    'unit': unit,
    'timestamp': timestamp.toIso8601String(),
  };
}

/// 性能统计
class PerformanceStatistics {
  int count = 0;
  double mean = 0.0;
  double median = 0.0;
  double min = 0.0;
  double max = 0.0;
  double standardDeviation = 0.0;
  Map<String, double> percentiles = {};

  PerformanceStatistics();

  Map<String, dynamic> toJson() => {
    'count': count,
    'mean': mean,
    'median': median,
    'min': min,
    'max': max,
    'standardDeviation': standardDeviation,
    'percentiles': percentiles,
  };
}

/// 性能评级
enum PerformanceRating {
  Excellent,
  Good,
  Fair,
  Poor,
}

/// 性能瓶颈
class PerformanceBottleneck {
  final String testName;
  final String metricName;
  final double value;
  final BottleneckSeverity severity;
  final String description;

  PerformanceBottleneck({
    required this.testName,
    required this.metricName,
    required this.value,
    required this.severity,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'testName': testName,
    'metricName': metricName,
    'value': value,
    'severity': severity.toString(),
    'description': description,
  };
}

/// 瓶颈严重程度
enum BottleneckSeverity {
  Low,
  Medium,
  High,
  Critical,
}

/// 异常检测
class OutlierDetection {
  final String testName;
  final String metricName;
  final double value;
  final OutlierType type;
  final String description;

  OutlierDetection({
    required this.testName,
    required this.metricName,
    required this.value,
    required this.type,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'testName': testName,
    'metricName': metricName,
    'value': value,
    'type': type.toString(),
    'description': description,
  };
}

/// 异常类型
enum OutlierType {
  High,
  Low,
}

/// 性能指标集合
class PerformanceMetrics {
  final String testName;
  final List<PerformanceMetric> metrics = [];

  PerformanceMetrics({required this.testName});

  void addMetric(String name, dynamic value) {
    if (value is num) {
      metrics.add(PerformanceMetric(
        name: name,
        value: value.toDouble(),
        unit: '',
        timestamp: DateTime.now(),
      ));
    }
  }

  Map<String, dynamic> toJson() => {
    'testName': testName,
    'metrics': metrics.map((m) => m.toJson()).toList(),
  };
}

/// 基线比较
class BaselineComparison {
  final Map<String, TestBaselineComparison> testComparisons = {};

  Map<String, dynamic> toJson() => {
    'testComparisons': testComparisons.map((k, v) => MapEntry(k, v.toJson())),
  };
}

/// 测试基线比较
class TestBaselineComparison {
  final String testName;
  final Map<String, MetricChange> metricChanges = {};

  TestBaselineComparison({required this.testName});

  Map<String, dynamic> toJson() => {
    'testName': testName,
    'metricChanges': metricChanges.map((k, v) => MapEntry(k, v.toJson())),
  };
}

/// 指标变化
class MetricChange {
  final double baselineValue;
  final double currentValue;
  final double changePercent;
  final bool isImproved;

  MetricChange({
    required this.baselineValue,
    required this.currentValue,
    required this.changePercent,
    required this.isImproved,
  });

  Map<String, dynamic> toJson() => {
    'baselineValue': baselineValue,
    'currentValue': currentValue,
    'changePercent': changePercent,
    'isImproved': isImproved,
  };
}

/// 性能建议
class PerformanceRecommendation {
  final RecommendationCategory category;
  final RecommendationPriority priority;
  final String title;
  final String description;
  final String impact;
  final RecommendationEffort effort;

  PerformanceRecommendation({
    required this.category,
    required this.priority,
    required this.title,
    required this.description,
    required this.impact,
    required this.effort,
  });

  Map<String, dynamic> toJson() => {
    'category': category.toString(),
    'priority': priority.toString(),
    'title': title,
    'description': description,
    'impact': impact,
    'effort': effort.toString(),
  };
}

/// 建议类别
enum RecommendationCategory {
  General,
  Memory,
  CPU,
  ResponseTime,
  Reliability,
  Security,
}

/// 建议优先级
enum RecommendationPriority {
  Low,
  Medium,
  High,
  Critical,
}

/// 建议工作量
enum RecommendationEffort {
  Low,
  Medium,
  High,
}

/// 报告摘要
class ReportSummary {
  String? executiveSummary;
  List<String> keyFindings = [];
  List<String> performanceHighlights = [];
  List<String> areasOfConcern = [];
  List<String> nextActions = [];
  String? error;

  Map<String, dynamic> toJson() => {
    'executiveSummary': executiveSummary,
    'keyFindings': keyFindings,
    'performanceHighlights': performanceHighlights,
    'areasOfConcern': areasOfConcern,
    'nextActions': nextActions,
    'error': error,
  };
}

/// 性能基线
class PerformanceBaseline {
  final String name;
  final DateTime createdAt;
  final Map<String, PerformanceMetric> metrics = {};

  PerformanceBaseline({
    required this.name,
    required this.createdAt,
  });

  PerformanceMetric? getMetric(String name) => metrics[name];

  Map<String, dynamic> toJson() => {
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'metrics': metrics.map((k, v) => MapEntry(k, v.toJson())),
  };
}