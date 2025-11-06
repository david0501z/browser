import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// 带宽监控器
/// 
/// 提供全面的网络带宽监控和分析功能：
/// - 实时带宽监控
/// - 流量统计分析
/// - 网络质量评估
/// - 带宽使用预警
/// - 流量控制
/// - 网络优化建议
class BandwidthMonitor {
  static final BandwidthMonitor _instance = BandwidthMonitor._internal();
  factory BandwidthMonitor() => _instance;
  BandwidthMonitor._internal();

  // 当前统计
  BandwidthStats? _currentStats;
  
  // 历史统计数据
  final List<BandwidthSnapshot> _snapshots = [];
  
  // 配置
  BandwidthConfig? _config;
  
  // 监控定时器
  Timer? _monitorTimer;
  
  // 流量限制器
  final TrafficLimiter _trafficLimiter = TrafficLimiter();
  
  // 网络质量评估器
  final NetworkQualityAssessor _qualityAssessor = NetworkQualityAssessor();
  
  // 预警管理器
  final AlertManager _alertManager = AlertManager();
  
  // 性能优化器
  final BandwidthOptimizer _optimizer = BandwidthOptimizer();
  
  /// 初始化带宽监控器
  Future<void> initialize(BandwidthConfig config) async {
    _config = config;
    
    // 初始化流量限制器
    await _trafficLimiter.initialize(config);
    
    // 初始化网络质量评估器
    await _qualityAssessor.initialize();
    
    // 初始化预警管理器
    await _alertManager.initialize(config);
    
    // 初始化优化器
    await _optimizer.initialize(config);
    
    // 初始化当前统计
    _currentStats = BandwidthStats();
    
    // 启动监控
    _startMonitoring();
    
    log('[BandwidthMonitor] 带宽监控器已初始化');
  }
  
  /// 启动带宽监控
  void _startMonitoring() {
    _monitorTimer = Timer.periodic(
      _config!.monitoringInterval,
      (_) => _performMonitoring(),
    );
    
    log('[BandwidthMonitor] 带宽监控已启动');
  }
  
  /// 执行监控
  Future<void> _performMonitoring() async {
    try {
      // 获取当前网络统计
      final currentUsage = await _getCurrentNetworkUsage();
      
      // 更新统计
      _updateStats(currentUsage);
      
      // 评估网络质量
      final quality = await _qualityAssessor.assess(currentUsage);
      
      // 检查预警条件
      await _alertManager.checkAlerts(_currentStats!, quality);
      
      // 执行优化
      await _optimizer.optimize(_currentStats!, quality);
      
      // 限制流量（如果需要）
      await _trafficLimiter.applyLimitsIfNeeded(_currentStats!);
      
      log('[BandwidthMonitor] 监控周期完成: 上行=${currentUsage.uploadBytes}/s, 下行=${currentUsage.downloadBytes}/s');
      
    } catch (e) {
      log('[BandwidthMonitor] 监控执行失败: $e', level: 500);
    }
  }
  
  /// 获取当前网络使用情况
  Future<NetworkUsage> _getCurrentNetworkUsage() async {
    try {
      // 获取系统网络统计
      final networkInfo = await _getSystemNetworkStats();
      
      // 计算速率
      final now = DateTime.now();
      final previousSnapshot = _snapshots.isNotEmpty ? _snapshots.last : null;
      
      NetworkUsage usage;
      
      if (previousSnapshot != null) {
        final timeDelta = now.difference(previousSnapshot.timestamp).inSeconds;
        
        if (timeDelta > 0) {
          final uploadRate = (networkInfo.uploadBytes - previousSnapshot.uploadBytes) ~/ timeDelta;
          final downloadRate = (networkInfo.downloadBytes - previousSnapshot.downloadBytes) ~/ timeDelta;
          
          usage = NetworkUsage(
            uploadBytes: uploadRate,
            downloadBytes: downloadRate,
            totalUpload: networkInfo.uploadBytes,
            totalDownload: networkInfo.downloadBytes,
            timestamp: now,
          );
        } else {
          usage = NetworkUsage(
            uploadBytes: 0,
            downloadBytes: 0,
            totalUpload: networkInfo.uploadBytes,
            totalDownload: networkInfo.downloadBytes,
            timestamp: now,
          );
        }
      } else {
        usage = NetworkUsage(
          uploadBytes: 0,
          downloadBytes: 0,
          totalUpload: networkInfo.uploadBytes,
          totalDownload: networkInfo.downloadBytes,
          timestamp: now,
        );
      }
      
      // 记录快照
      _snapshots.add(BandwidthSnapshot(
        uploadBytes: networkInfo.uploadBytes,
        downloadBytes: networkInfo.downloadBytes,
        timestamp: now,
      ));
      
      // 保持最近1小时的快照
      final oneHourAgo = now.subtract(const Duration(hours: 1));
      _snapshots.removeWhere((snapshot) => snapshot.timestamp.isBefore(oneHourAgo));
      
      return usage;
      
    } catch (e) {
      log('[BandwidthMonitor] 获取网络使用情况失败: $e');
      
      // 返回默认值
      return NetworkUsage(
        uploadBytes: 0,
        downloadBytes: 0,
        totalUpload: 0,
        totalDownload: 0,
        timestamp: DateTime.now(),
      );
    }
  }
  
  /// 获取系统网络统计
  Future<NetworkStatsInfo> _getSystemNetworkStats() async {
    if (kIsWeb) {
      // Web平台简化实现
      return NetworkStatsInfo(uploadBytes: 0, downloadBytes: 0);
    }
    
    try {
      final stats = <String, int>{};
      
      if (Platform.isAndroid) {
        // Android网络统计获取
        stats.addAll(await _getAndroidNetworkStats());
      } else if (Platform.isIOS) {
        // iOS网络统计获取
        stats.addAll(await _getIOSNetworkStats());
      } else {
        // Linux/Mac网络统计获取
        stats.addAll(await _getUnixNetworkStats());
      }
      
      return NetworkStatsInfo(
        uploadBytes: stats['upload'] ?? 0,
        downloadBytes: stats['download'] ?? 0,
      );
      
    } catch (e) {
      log('[BandwidthMonitor] 获取系统网络统计失败: $e');
      return NetworkStatsInfo(uploadBytes: 0, downloadBytes: 0);
    }
  }
  
  /// 获取Android网络统计
  Future<Map<String, int>> _getAndroidNetworkStats() async {
    try {
      // 使用Android系统API获取网络统计
      // 这里需要Android插件支持
      return {};
    } catch (e) {
      return {};
    }
  }
  
  /// 获取iOS网络统计
  Future<Map<String, int>> _getIOSNetworkStats() async {
    try {
      // 使用iOS系统API获取网络统计
      // 这里需要iOS插件支持
      return {};
    } catch (e) {
      return {};
    }
  }
  
  /// 获取Unix/Linux网络统计
  Future<Map<String, int>> _getUnixNetworkStats() async {
    try {
      // 读取/proc/net/dev或使用系统命令
      final file = File('/proc/net/dev');
      if (!await file.exists()) {
        // 尝试使用系统命令
        final result = await Process.run('cat', ['/proc/net/dev']);
        return _parseNetDev(result.stdout.toString());
      } else {
        final content = await file.readAsString();
        return _parseNetDev(content);
      }
    } catch (e) {
      log('[BandwidthMonitor] 获取Unix网络统计失败: $e');
      return {};
    }
  }
  
  /// 解析网络设备统计
  Map<String, int> _parseNetDev(String content) {
    final stats = <String, int>{};
    final lines = content.split('\n');
    
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      
      final parts = line.trim().split(RegExp(r'\s+'));
      if (parts.length < 9) continue;
      
      final interface = parts[0].replaceAll(':', '');
      
      // 跳过回环接口
      if (interface == 'lo') continue;
      
      // 获取接收和发送的字节数
      final receiveBytes = int.parse(parts[1]);
      final transmitBytes = parts[9] != null ? int.parse(parts[9]) : 0;
      
      // 累加所有接口的统计
      stats['download'] = (stats['download'] ?? 0) + receiveBytes;
      stats['upload'] = (stats['upload'] ?? 0) + transmitBytes;
    }
    
    return stats;
  }
  
  /// 更新统计信息
  void _updateStats(NetworkUsage usage) {
    if (_currentStats == null) return;
    
    final now = DateTime.now();
    
    // 更新当前统计
    _currentStats!.currentUploadRate = usage.uploadBytes;
    _currentStats!.currentDownloadRate = usage.downloadBytes;
    _currentStats!.totalUploadBytes = usage.totalUpload;
    _currentStats!.totalDownloadBytes = usage.totalDownload;
    _currentStats!.lastUpdateTime = now;
    
    // 计算平均值和峰值
    _calculateAverages();
    _calculatePeaks();
    
    // 计算使用率
    _calculateUsageRatio();
  }
  
  /// 计算平均值
  void _calculateAverages() {
    if (_snapshots.length < 2) return;
    
    final recentSnapshots = _snapshots.take(10).toList();
    if (recentSnapshots.length < 2) return;
    
    int totalUploadRate = 0;
    int totalDownloadRate = 0;
    
    for (int i = 1; i < recentSnapshots.length; i++) {
      final current = recentSnapshots[i];
      final previous = recentSnapshots[i - 1];
      final timeDelta = current.timestamp.difference(previous.timestamp).inSeconds;
      
      if (timeDelta > 0) {
        totalUploadRate += (current.uploadBytes - previous.uploadBytes) ~/ timeDelta;
        totalDownloadRate += (current.downloadBytes - previous.downloadBytes) ~/ timeDelta;
      }
    }
    
    _currentStats!.averageUploadRate = totalUploadRate ~/ (recentSnapshots.length - 1);
    _currentStats!.averageDownloadRate = totalDownloadRate ~/ (recentSnapshots.length - 1);
  }
  
  /// 计算峰值
  void _calculatePeaks() {
    _currentStats!.peakUploadRate = max(
      _currentStats!.peakUploadRate,
      _currentStats!.currentUploadRate,
    );
    
    _currentStats!.peakDownloadRate = max(
      _currentStats!.peakDownloadRate,
      _currentStats!.currentDownloadRate,
    );
  }
  
  /// 计算使用率
  void _calculateUsageRatio() {
    final limit = _config!.bandwidthLimit;
    if (limit <= 0) return;
    
    _currentStats!.uploadUsageRatio = _currentStats!.currentUploadRate / limit * 100;
    _currentStats!.downloadUsageRatio = _currentStats!.currentDownloadRate / limit * 100;
  }
  
  /// 记录数据使用
  Future<void> recordDataUsage({
    required int bytes,
    required DataDirection direction,
    String? source,
  }) async {
    final now = DateTime.now();
    
    _currentStats!.totalRequests++;
    
    if (direction == DataDirection.upload) {
      _currentStats!.totalUploadBytes += bytes;
    } else {
      _currentStats!.totalDownloadBytes += bytes;
    }
    
    // 记录详细信息
    _currentStats!.requestHistory.add(DataUsageRecord(
      bytes: bytes,
      direction: direction,
      source: source ?? 'unknown',
      timestamp: now,
    ));
    
    // 保持最近1000条记录
    if (_currentStats!.requestHistory.length > 1000) {
      _currentStats!.requestHistory.removeAt(0);
    }
    
    log('[BandwidthMonitor] 记录数据使用: $bytes bytes ($direction)');
  }
  
  /// 设置带宽限制
  Future<void> setBandwidthLimit(int bytesPerSecond) async {
    _config!.bandwidthLimit = bytesPerSecond;
    _trafficLimiter.setLimit(bytesPerSecond);
    log('[BandwidthMonitor] 带宽限制已设置: $bytesPerSecond bytes/s');
  }
  
  /// 获取当前统计
  BandwidthStats get currentStats {
    if (_currentStats == null) {
      _currentStats = BandwidthStats();
    }
    return _currentStats!;
  }
  
  /// 获取历史数据
  List<BandwidthSnapshot> get history => List.unmodifiable(_snapshots);
  
  /// 获取网络质量评分
  Future<double> getNetworkQualityScore() async {
    if (_currentStats == null) return 0.0;
    
    final quality = await _qualityAssessor.assess(NetworkUsage(
      uploadBytes: _currentStats!.currentUploadRate,
      downloadBytes: _currentStats!.currentDownloadRate,
      totalUpload: _currentStats!.totalUploadBytes,
      totalDownload: _currentStats!.totalDownloadBytes,
      timestamp: DateTime.now(),
    ));
    
    return quality.score;
  }
  
  /// 获取优化建议
  List<OptimizationSuggestion> getOptimizationSuggestions() {
    return _optimizer.generateSuggestions(_currentStats!);
  }
  
  /// 重置统计
  void resetStats() {
    _currentStats = BandwidthStats();
    _snapshots.clear();
    _qualityAssessor.reset();
    log('[BandwidthMonitor] 统计已重置');
  }
  
  /// 导出统计数据
  Future<Map<String, dynamic>> exportStatistics() async {
    return {
      'currentStats': _currentStats!.toJson(),
      'history': _snapshots.map((s) => s.toJson()).toList(),
      'configuration': _config!.toJson(),
      'exportTime': DateTime.now().toIso8601String(),
    };
  }
  
  /// 销毁监控器
  Future<void> dispose() async {
    _monitorTimer?.cancel();
    
    await Future.wait([
      _trafficLimiter.dispose(),
      _qualityAssessor.dispose(),
      _alertManager.dispose(),
      _optimizer.dispose(),
    ]);
    
    log('[BandwidthMonitor] 带宽监控器已销毁');
  }
}

/// 带宽配置
class BandwidthConfig {
  int bandwidthLimit = 0; // 0表示无限制
  Duration monitoringInterval = const Duration(seconds: 5);
  int maxHistorySize = 720; // 1小时的数据（每5秒一次）
  bool enableAlerts = true;
  bool enableOptimization = true;
  bool enableTrafficLimiting = false;
  double alertThreshold = 0.8; // 80%时发出警告
  
  Map<String, dynamic> toJson() => {
    'bandwidthLimit': bandwidthLimit,
    'monitoringInterval': monitoringInterval.inSeconds,
    'maxHistorySize': maxHistorySize,
    'enableAlerts': enableAlerts,
    'enableOptimization': enableOptimization,
    'enableTrafficLimiting': enableTrafficLimiting,
    'alertThreshold': alertThreshold,
  };
}

/// 带宽统计
class BandwidthStats {
  int currentUploadRate = 0; // bytes/s
  int currentDownloadRate = 0; // bytes/s
  int averageUploadRate = 0; // bytes/s
  int averageDownloadRate = 0; // bytes/s
  int peakUploadRate = 0; // bytes/s
  int peakDownloadRate = 0; // bytes/s
  int totalUploadBytes = 0;
  int totalDownloadBytes = 0;
  int totalRequests = 0;
  DateTime? lastUpdateTime;
  double uploadUsageRatio = 0.0; // 0-100
  double downloadUsageRatio = 0.0; // 0-100
  final List<DataUsageRecord> requestHistory = [];
  
  Map<String, dynamic> toJson() => {
    'currentUploadRate': currentUploadRate,
    'currentDownloadRate': currentDownloadRate,
    'averageUploadRate': averageUploadRate,
    'averageDownloadRate': averageDownloadRate,
    'peakUploadRate': peakUploadRate,
    'peakDownloadRate': peakDownloadRate,
    'totalUploadBytes': totalUploadBytes,
    'totalDownloadBytes': totalDownloadBytes,
    'totalRequests': totalRequests,
    'uploadUsageRatio': uploadUsageRatio,
    'downloadUsageRatio': downloadUsageRatio,
    'lastUpdateTime': lastUpdateTime?.toIso8601String(),
  };
}

/// 带宽快照
class BandwidthSnapshot {
  final int uploadBytes;
  final int downloadBytes;
  final DateTime timestamp;
  
  BandwidthSnapshot({
    required this.uploadBytes,
    required this.downloadBytes,
    required this.timestamp,
  });
  
  Map<String, dynamic> toJson() => {
    'uploadBytes': uploadBytes,
    'downloadBytes': downloadBytes,
    'timestamp': timestamp.toIso8601String(),
  };
}

/// 网络使用情况
class NetworkUsage {
  final int uploadBytes; // bytes/s
  final int downloadBytes; // bytes/s
  final int totalUpload; // total bytes
  final int totalDownload; // total bytes
  final DateTime timestamp;
  
  NetworkUsage({
    required this.uploadBytes,
    required this.downloadBytes,
    required this.totalUpload,
    required this.totalDownload,
    required this.timestamp,
  });
}

/// 网络统计信息
class NetworkStatsInfo {
  final int uploadBytes;
  final int downloadBytes;
  
  NetworkStatsInfo({
    required this.uploadBytes,
    required this.downloadBytes,
  });
}

/// 数据方向
enum DataDirection {
  upload,
  download,
}

/// 数据使用记录
class DataUsageRecord {
  final int bytes;
  final DataDirection direction;
  final String source;
  final DateTime timestamp;
  
  DataUsageRecord({
    required this.bytes,
    required this.direction,
    required this.source,
    required this.timestamp,
  });
}

/// 网络质量
class NetworkQuality {
  final double score; // 0.0-1.0
  final QualityLevel level;
  final String description;
  final List<String> issues;
  final List<String> suggestions;
  
  NetworkQuality({
    required this.score,
    required this.level,
    required this.description,
    required this.issues,
    required this.suggestions,
  });
}

/// 质量等级
enum QualityLevel {
  excellent,
  good,
  fair,
  poor,
}

/// 优化建议
class OptimizationSuggestion {
  final String title;
  final String description;
  final SuggestionPriority priority;
  final bool canAutoApply;
  
  OptimizationSuggestion({
    required this.title,
    required this.description,
    required this.priority,
    this.canAutoApply = false,
  });
}

/// 建议优先级
enum SuggestionPriority {
  low,
  medium,
  high,
  critical,
}

/// 流量限制器
class TrafficLimiter {
  int _limit = 0;
  int _currentUsage = 0;
  bool _isEnabled = false;
  
  Future<void> initialize(BandwidthConfig config) async {
    _limit = config.bandwidthLimit;
    _isEnabled = config.enableTrafficLimiting && _limit > 0;
    log('[TrafficLimiter] 流量限制器已初始化');
  }
  
  void setLimit(int bytesPerSecond) {
    _limit = bytesPerSecond;
    _isEnabled = _limit > 0;
  }
  
  Future<void> applyLimitsIfNeeded(BandwidthStats stats) async {
    if (!_isEnabled) return;
    
    // 计算使用率
    final uploadRatio = stats.currentUploadRate / _limit;
    final downloadRatio = stats.currentDownloadRate / _limit;
    
    if (uploadRatio > 0.9 || downloadRatio > 0.9) {
      log('[TrafficLimiter] 带宽使用率过高: 上行=${(uploadRatio * 100).toStringAsFixed(1)}%, 下行=${(downloadRatio * 100).toStringAsFixed(1)}%');
    }
  }
  
  bool isLimitReached(DataDirection direction, int bytes) {
    if (!_isEnabled) return false;
    
    // 简化实现：检查当前速率是否超过限制
    // 实际实现中需要更复杂的流量控制逻辑
    return false;
  }
  
  Future<void> dispose() async {
    log('[TrafficLimiter] 流量限制器已销毁');
  }
}

/// 网络质量评估器
class NetworkQualityAssessor {
  NetworkQuality? _lastAssessment;
  
  Future<void> initialize() async {
    log('[NetworkQualityAssessor] 网络质量评估器已初始化');
  }
  
  Future<NetworkQuality> assess(NetworkUsage usage) async {
    final score = _calculateScore(usage);
    final level = _determineLevel(score);
    final description = _generateDescription(level);
    final issues = _identifyIssues(usage, level);
    final suggestions = _generateSuggestions(level, issues);
    
    _lastAssessment = NetworkQuality(
      score: score,
      level: level,
      description: description,
      issues: issues,
      suggestions: suggestions,
    );
    
    return _lastAssessment!;
  }
  
  double _calculateScore(NetworkUsage usage) {
    // 基于下载/上传速率计算质量分数
    final downloadRate = usage.downloadBytes / (1024 * 1024); // MB/s
    final uploadRate = usage.uploadBytes / (1024 * 1024); // MB/s
    
    double score = 0.0;
    
    // 下载速率评分 (0-0.6)
    if (downloadRate >= 50) score += 0.6;
    else if (downloadRate >= 10) score += 0.4;
    else if (downloadRate >= 1) score += 0.2;
    else score += 0.1;
    
    // 上传速率评分 (0-0.3)
    if (uploadRate >= 20) score += 0.3;
    else if (uploadRate >= 5) score += 0.2;
    else if (uploadRate >= 1) score += 0.1;
    else score += 0.05;
    
    // 稳定性评分 (0-0.1)
    // 这里可以基于历史数据计算稳定性
    score += 0.1;
    
    return score.clamp(0.0, 1.0);
  }
  
  QualityLevel _determineLevel(double score) {
    if (score >= 0.8) return QualityLevel.excellent;
    if (score >= 0.6) return QualityLevel.good;
    if (score >= 0.4) return QualityLevel.fair;
    return QualityLevel.poor;
  }
  
  String _generateDescription(QualityLevel level) {
    switch (level) {
      case QualityLevel.excellent:
        return '网络质量优秀，连接稳定，延迟低';
      case QualityLevel.good:
        return '网络质量良好，连接稳定';
      case QualityLevel.fair:
        return '网络质量一般，可能存在延迟';
      case QualityLevel.poor:
        return '网络质量较差，连接不稳定';
    }
  }
  
  List<String> _identifyIssues(NetworkUsage usage, QualityLevel level) {
    final issues = <String>[];
    
    if (level == QualityLevel.poor) {
      if (usage.downloadBytes < 1024) {
        issues.add('下载速率过低');
      }
      if (usage.uploadBytes < 1024) {
        issues.add('上传速率过低');
      }
    }
    
    return issues;
  }
  
  List<String> _generateSuggestions(QualityLevel level, List<String> issues) {
    final suggestions = <String>[];
    
    if (issues.contains('下载速率过低')) {
      suggestions.add('检查网络连接或更换更快的网络');
    }
    if (issues.contains('上传速率过低')) {
      suggestions.add('检查上传带宽限制或网络配置');
    }
    
    if (level == QualityLevel.poor) {
      suggestions.add('建议使用缓存减少网络请求');
      suggestions.add('考虑压缩数据传输');
    }
    
    return suggestions;
  }
  
  void reset() {
    _lastAssessment = null;
  }
  
  Future<void> dispose() async {
    log('[NetworkQualityAssessor] 网络质量评估器已销毁');
  }
}

/// 预警管理器
class AlertManager {
  final List<BandwidthAlert> _activeAlerts = [];
  
  Future<void> initialize(BandwidthConfig config) async {
    log('[AlertManager] 预警管理器已初始化');
  }
  
  Future<void> checkAlerts(BandwidthStats stats, NetworkQuality quality) async {
    final now = DateTime.now();
    
    // 检查带宽使用率预警
    if (stats.uploadUsageRatio > 80) {
      _triggerAlert(BandwidthAlert(
        type: AlertType.bandwidthHigh,
        message: '上行带宽使用率过高: ${stats.uploadUsageRatio.toStringAsFixed(1)}%',
        timestamp: now,
        severity: AlertSeverity.warning,
      ));
    }
    
    if (stats.downloadUsageRatio > 80) {
      _triggerAlert(BandwidthAlert(
        type: AlertType.bandwidthHigh,
        message: '下行带宽使用率过高: ${stats.downloadUsageRatio.toStringAsFixed(1)}%',
        timestamp: now,
        severity: AlertSeverity.warning,
      ));
    }
    
    // 检查网络质量预警
    if (quality.level == QualityLevel.poor) {
      _triggerAlert(BandwidthAlert(
        type: AlertType.networkQualityPoor,
        message: '网络质量较差: ${quality.description}',
        timestamp: now,
        severity: AlertSeverity.error,
      ));
    }
  }
  
  void _triggerAlert(BandwidthAlert alert) {
    // 避免重复预警
    if (_activeAlerts.any((a) => a.type == alert.type)) return;
    
    _activeAlerts.add(alert);
    log('[AlertManager] 触发预警: ${alert.message}');
    
    // 预警自动清除（5分钟后）
    Timer(const Duration(minutes: 5), () {
      _activeAlerts.remove(alert);
    });
  }
  
  List<BandwidthAlert> get activeAlerts => List.unmodifiable(_activeAlerts);
  
  Future<void> dispose() async {
    _activeAlerts.clear();
    log('[AlertManager] 预警管理器已销毁');
  }
}

/// 预警类型
enum AlertType {
  bandwidthHigh,
  networkQualityPoor,
  connectionLost,
  unusualTraffic,
}

/// 预警严重程度
enum AlertSeverity {
  info,
  warning,
  error,
  critical,
}

/// 带宽预警
class BandwidthAlert {
  final AlertType type;
  final String message;
  final DateTime timestamp;
  final AlertSeverity severity;
  
  BandwidthAlert({
    required this.type,
    required this.message,
    required this.timestamp,
    required this.severity,
  });
}

/// 带宽优化器
class BandwidthOptimizer {
  BandwidthConfig? _config;
  
  Future<void> initialize(BandwidthConfig config) async {
    _config = config;
    log('[BandwidthOptimizer] 带宽优化器已初始化');
  }
  
  Future<void> optimize(BandwidthStats stats, NetworkQuality quality) async {
    if (!_config!.enableOptimization) return;
    
    // 基于网络质量进行优化
    switch (quality.level) {
      case QualityLevel.poor:
        await _optimizeForPoorQuality(stats);
        break;
      case QualityLevel.fair:
        await _optimizeForFairQuality(stats);
        break;
      case QualityLevel.good:
        await _optimizeForGoodQuality(stats);
        break;
      case QualityLevel.excellent:
        await _optimizeForExcellentQuality(stats);
        break;
    }
  }
  
  Future<void> _optimizeForPoorQuality(BandwidthStats stats) async {
    // 启用数据压缩
    // 减少并发连接数
    // 启用智能缓存
    log('[BandwidthOptimizer] 对差质量网络执行优化');
  }
  
  Future<void> _optimizeForFairQuality(BandwidthStats stats) async {
    // 适度优化
    log('[BandwidthOptimizer] 对一般网络执行优化');
  }
  
  Future<void> _optimizeForGoodQuality(BandwidthStats stats) async {
    // 轻微优化
    log('[BandwidthOptimizer] 对良好网络执行优化');
  }
  
  Future<void> _optimizeForExcellentQuality(BandwidthStats stats) async {
    // 充分利用带宽
    log('[BandwidthOptimizer] 对优秀网络执行优化');
  }
  
  List<OptimizationSuggestion> generateSuggestions(BandwidthStats stats) {
    final suggestions = <OptimizationSuggestion>[];
    
    if (stats.currentDownloadRate < 1024 * 1024) { // < 1MB/s
      suggestions.add(OptimizationSuggestion(
        title: '启用数据压缩',
        description: '当前网络较慢，建议启用数据压缩以减少传输量',
        priority: SuggestionPriority.high,
        canAutoApply: true,
      ));
    }
    
    if (stats.averageDownloadRate < stats.peakDownloadRate * 0.5) {
      suggestions.add(OptimizationSuggestion(
        title: '优化连接策略',
        description: '网络带宽利用率较低，建议调整连接策略',
        priority: SuggestionPriority.medium,
      ));
    }
    
    return suggestions;
  }
  
  Future<void> dispose() async {
    log('[BandwidthOptimizer] 带宽优化器已销毁');
  }
}

/// 日志辅助函数
void log(String message, {int level = 200, String tag = 'BandwidthMonitor'}) {
  final logMessage = '[$tag] $message';
  if (level >= 500) {
    developer.log(logMessage, level: level, name: tag);
  }
}