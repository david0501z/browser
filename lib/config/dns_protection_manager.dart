import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'dns_settings_manager.dart';

/// DNS保护级别
enum DNSProtectionLevel {
  basic,        // 基础保护
  standard,     // 标准保护
  enhanced,     // 增强保护
  maximum,      // 最高保护
}

/// DNS泄漏类型
enum DNSLeakType {
  ipv6Leak,     // IPv6泄漏
  localLeak,    // 本地DNS泄漏
  directLeak,   // 直连DNS泄漏
  smartDNSLeak, // SmartDNS泄漏
  transparentLeak, // 透明DNS泄漏
}

/// 保护结果
@immutable
class ProtectionResult {
  final bool isProtected;
  final List<DNSLeakType> detectedLeaks;
  final double protectionScore;
  final List<String> warnings;
  final Map<String, dynamic>? details;
  final DateTime timestamp;

  const ProtectionResult({
    required this.isProtected,
    required this.detectedLeaks,
    required this.protectionScore,
    this.warnings = const [],
    this.details,
    required this.timestamp,
  });

  /// 创建成功的保护结果
  factory ProtectionResult.success({List<String>? warnings}) {
    return ProtectionResult(
      isProtected: true,
      detectedLeaks: [],
      protectionScore: 100.0,
      warnings: warnings ?? [],
      timestamp: DateTime.now(),
    );
  }

  /// 创建失败的保护结果
  factory ProtectionResult.failure(List<DNSLeakType> leaks, {List<String>? warnings, Map<String, dynamic>? details}) {
    return ProtectionResult(
      isProtected: false,
      detectedLeaks: leaks,
      protectionScore: 0.0,
      warnings: warnings ?? [],
      details: details,
      timestamp: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'ProtectionResult{protected: $isProtected, score: $protectionScore%, leaks: ${detectedLeaks.length}}';
  }
}

/// DNS优化配置
@immutable
class DNSOptimizationConfig {
  final bool enableCompression;
  final bool enableCaching;
  final int cacheSize;
  final Duration cacheTimeout;
  final bool enableDNSSEC;
  final bool enableEDNS;
  final int maxRetries;
  final Duration timeout;
  final bool enableLoadBalancing;
  final int healthyServerCount;
  final bool enableHealthCheck;
  final Duration healthCheckInterval;

  const DNSOptimizationConfig({
    this.enableCompression = true,
    this.enableCaching = true,
    this.cacheSize = 1000,
    this.cacheTimeout = const Duration(minutes: 30),
    this.enableDNSSEC = true,
    this.enableEDNS = true,
    this.maxRetries = 3,
    this.timeout = const Duration(seconds: 5),
    this.enableLoadBalancing = true,
    this.healthyServerCount = 2,
    this.enableHealthCheck = true,
    this.healthCheckInterval = const Duration(minutes: 5),
  });

  DNSOptimizationConfig copyWith({
    bool? enableCompression,
    bool? enableCaching,
    int? cacheSize,
    Duration? cacheTimeout,
    bool? enableDNSSEC,
    bool? enableEDNS,
    int? maxRetries,
    Duration? timeout,
    bool? enableLoadBalancing,
    int? healthyServerCount,
    bool? enableHealthCheck,
    Duration? healthCheckInterval,
  }) {
    return DNSOptimizationConfig(
      enableCompression: enableCompression ?? this.enableCompression,
      enableCaching: enableCaching ?? this.enableCaching,
      cacheSize: cacheSize ?? this.cacheSize,
      cacheTimeout: cacheTimeout ?? this.cacheTimeout,
      enableDNSSEC: enableDNSSEC ?? this.enableDNSSEC,
      enableEDNS: enableEDNS ?? this.enableEDNS,
      maxRetries: maxRetries ?? this.maxRetries,
      timeout: timeout ?? this.timeout,
      enableLoadBalancing: enableLoadBalancing ?? this.enableLoadBalancing,
      healthyServerCount: healthyServerCount ?? this.healthyServerCount,
      enableHealthCheck: enableHealthCheck ?? this.enableHealthCheck,
      healthCheckInterval: healthCheckInterval ?? this.healthCheckInterval,
    );
  }
}

/// DNS保护状态
@immutable
class DNSProtectionStatus {
  final bool isEnabled;
  final DNSProtectionLevel level;
  final bool isLeakDetected;
  final List<DNSLeakType> activeLeaks;
  final double protectionScore;
  final DateTime lastCheck;
  final DateTime? lastLeakTime;

  const DNSProtectionStatus({
    required this.isEnabled,
    required this.level,
    required this.isLeakDetected,
    required this.activeLeaks,
    required this.protectionScore,
    required this.lastCheck,
    this.lastLeakTime,
  });

  /// 复制并修改属性
  DNSProtectionStatus copyWith({
    bool? isEnabled,
    DNSProtectionLevel? level,
    bool? isLeakDetected,
    List<DNSLeakType>? activeLeaks,
    double? protectionScore,
    DateTime? lastCheck,
    DateTime? lastLeakTime,
  }) {
    return DNSProtectionStatus(
      isEnabled: isEnabled ?? this.isEnabled,
      level: level ?? this.level,
      isLeakDetected: isLeakDetected ?? this.isLeakDetected,
      activeLeaks: activeLeaks ?? this.activeLeaks,
      protectionScore: protectionScore ?? this.protectionScore,
      lastCheck: lastCheck ?? this.lastCheck,
      lastLeakTime: lastLeakTime ?? this.lastLeakTime,
    );
  }

  @override
  String toString() {
    return 'DNSProtectionStatus{enabled: $isEnabled, level: $level, leak: $isLeakDetected, score: $protectionScore%}';
  }
}

/// DNS性能指标
@immutable
class DNSPerformanceMetrics {
  final double averageResponseTime;
  final double successRate;
  final int totalQueries;
  final int cacheHitRate;
  final Map<String, double> serverResponseTimes;
  final DateTime timestamp;

  const DNSPerformanceMetrics({
    required this.averageResponseTime,
    required this.successRate,
    required this.totalQueries,
    required this.cacheHitRate,
    required this.serverResponseTimes,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'DNSPerformanceMetrics{avg: ${averageResponseTime.toStringAsFixed(1)}ms, success: ${(successRate * 100).toStringAsFixed(1)}%, cache: ${(cacheHitRate * 100).toStringAsFixed(1)}%}';
  }
}

/// DNS保护管理器
class DNSProtectionManager extends ChangeNotifier {
  static DNSProtectionManager? _instance;
  static DNSProtectionManager get instance => _instance ??= DNSProtectionManager._();

  DNSProtectionManager._();

  DNSProtectionStatus? _status;
  DNSOptimizationConfig _optimizationConfig = const DNSOptimizationConfig();
  DNSPerformanceMetrics? _metrics;
  
  final Map<String, List<DNSServerConfig>> _serverHealth = {};
  final Map<String, Duration> _responseTimes = {};
  final Queue<ProtectionResult> _protectionHistory = Queue();
  
  bool _isMonitoring = false;
  Timer? _monitoringTimer;
  Timer? _healthCheckTimer;
  int _maxHistorySize = 100;

  /// 当前保护状态
  DNSProtectionStatus? get status => _status;

  /// 优化配置
  DNSOptimizationConfig get optimizationConfig => _optimizationConfig;

  /// 性能指标
  DNSPerformanceMetrics? get metrics => _metrics;

  /// 保护历史
  List<ProtectionResult> get protectionHistory => List.unmodifiable(_protectionHistory);

  /// 是否正在监控
  bool get isMonitoring => _isMonitoring;

  /// 初始化保护管理器
  Future<void> initialize() async {
    _status = DNSProtectionStatus(
      isEnabled: true,
      level: DNSProtectionLevel.standard,
      isLeakDetected: false,
      activeLeaks: [],
      protectionScore: 100.0,
      lastCheck: DateTime.now(),
    );
    
    await loadConfiguration();
    _startMonitoring();
    
    notifyListeners();
  }

  /// 启动DNS泄漏保护
  Future<ProtectionResult> enableProtection(DNSProtectionLevel level) async {
    _status = _status?.copyWith(
      isEnabled: true,
      level: level,
      lastCheck: DateTime.now(),
    ) ?? DNSProtectionStatus(
      isEnabled: true,
      level: level,
      isLeakDetected: false,
      activeLeaks: [],
      protectionScore: 100.0,
      lastCheck: DateTime.now(),
    );

    final result = await performProtectionCheck();
    _recordProtectionResult(result);
    
    await saveConfiguration();
    notifyListeners();
    
    return result;
  }

  /// 禁用DNS泄漏保护
  Future<void> disableProtection() async {
    _status = _status?.copyWith(
      isEnabled: false,
      lastCheck: DateTime.now(),
    );
    
    await saveConfiguration();
    notifyListeners();
  }

  /// 执行DNS泄漏检测
  Future<ProtectionResult> performProtectionCheck() async {
    final startTime = DateTime.now();
    final leaks = <DNSLeakType>[];
    final warnings = <String>[];
    final details = <String, dynamic>{};

    try {
      // 检查各种DNS泄漏类型
      final leakChecks = await Future.wait([;
        _checkIPv6Leak(),
        _checkLocalDNSLeak(),
        _checkDirectDNSLeak(),
        _checkSmartDNSLeak(),
        _checkTransparentDNSLeak(),
      ]);

      for (int i = 0; i < leakChecks.length; i++) {
        if (leakChecks[i]) {
          leaks.add(DNSLeakType.values[i]);
          warnings.add(_getLeakWarning(DNSLeakType.values[i]));
        }
      }

      // 计算保护分数
      final protectionScore = _calculateProtectionScore(leaks, _status?.level);
      
      // 根据保护级别添加额外检查
      if (_status?.level == DNSProtectionLevel.enhanced ||;
          _status?.level == DNSProtectionLevel.maximum) {
        await _performAdvancedChecks(details);
      }

      final result = leaks.isEmpty;
          ? ProtectionResult.success(warnings: warnings)
          : ProtectionResult.failure(leaks, warnings: warnings, details: details);

      _status = _status?.copyWith(
        isLeakDetected: leaks.isNotEmpty,
        activeLeaks: leaks,
        protectionScore: protectionScore,
        lastCheck: DateTime.now(),
        lastLeakTime: leaks.isNotEmpty ? DateTime.now() : null,
      );

      return result;
    } catch (e) {
      debugPrint('DNS保护检查失败: $e');
      return ProtectionResult.failure([], warnings: ['保护检查失败: $e']);
    }
  }

  /// 更新优化配置
  Future<void> updateOptimizationConfig(DNSOptimizationConfig config) async {
    _optimizationConfig = config;
    await saveConfiguration();
    notifyListeners();
  }

  /// 优化DNS设置
  Future<ProtectionResult> optimizeDNS() async {
    final result = await performProtectionCheck();
    
    if (!result.isProtected) {
      // DNS优化：根据检测结果优化设置
      await _applyOptimizations(result.detectedLeaks);
    }
    
    return result;
  }

  /// 获取推荐的保护配置
  DNSProtectionLevel getRecommendedProtectionLevel() {
    // 简单的推荐算法
    if (_status?.activeLeaks.isNotEmpty == true) {
      return DNSProtectionLevel.maximum;
    } else if (_metrics?.successRate ?? 1.0 < 0.9) {
      return DNSProtectionLevel.enhanced;
    } else {
      return DNSProtectionLevel.standard;
    }
  }

  /// 启动监控
  void _startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _monitoringTimer = Timer.periodic(
      const Duration(minutes: 5),
      (timer) => _periodicProtectionCheck(),
    );
    
    _healthCheckTimer = Timer.periodic(
      const Duration(minutes: 2),
      (timer) => _periodicHealthCheck(),
    );
  }

  /// 停止监控
  void stopMonitoring() {
    _isMonitoring = false;
    _monitoringTimer?.cancel();
    _healthCheckTimer?.cancel();
  }

  /// 定期保护检查
  Future<void> _periodicProtectionCheck() async {
    if (!_isMonitoring) return;
    
    try {
      final result = await performProtectionCheck();
      _recordProtectionResult(result);
      
      if (result.isProtected) {
        notifyListeners();
      }
    } catch (e) {
      debugPrint('定期保护检查失败: $e');
    }
  }

  /// 定期健康检查
  Future<void> _periodicHealthCheck() async {
    if (!_isMonitoring || !_optimizationConfig.enableHealthCheck) return;
    
    try {
      await _checkServerHealth();
    } catch (e) {
      debugPrint('定期健康检查失败: $e');
    }
  }

  /// IPv6泄漏检查
  Future<bool> _checkIPv6Leak() async {
    // 模拟IPv6泄漏检测
    await Future.delayed(const Duration(milliseconds: 100));
    
    // 实际实现中需要检查IPv6 DNS查询是否泄漏
    return math.Random().nextBool(); // 模拟结果
  }

  /// 本地DNS泄漏检查
  Future<bool> _checkLocalDNSLeak() async {
    // 模拟本地DNS泄漏检测
    await Future.delayed(const Duration(milliseconds: 80));
    
    return math.Random().nextBool(); // 模拟结果
  }

  /// 直连DNS泄漏检查
  Future<bool> _checkDirectDNSLeak() async {
    // 模拟直连DNS泄漏检测
    await Future.delayed(const Duration(milliseconds: 120));
    
    return math.Random().nextBool(); // 模拟结果
  }

  /// SmartDNS泄漏检查
  Future<bool> _checkSmartDNSLeak() async {
    // 模拟SmartDNS泄漏检测
    await Future.delayed(const Duration(milliseconds: 150));
    
    return math.Random().nextBool(); // 模拟结果
  }

  /// 透明DNS泄漏检查
  Future<bool> _checkTransparentDNSLeak() async {
    // 模拟透明DNS泄漏检测
    await Future.delayed(const Duration(milliseconds: 90));
    
    return math.Random().nextBool(); // 模拟结果
  }

  /// 执行高级检查
  Future<void> _performAdvancedChecks(Map<String, dynamic> details) async {
    // 检查DNS over HTTPS
    details['dohCheck'] = await _checkDoHSupport();
    
    // 检查DNS over TLS
    details['dotCheck'] = await _checkDoTSupport();
    
    // 检查DNSSEC
    details['dnssecCheck'] = await _checkDNSSECSupport();
    
    // 检查响应时间
    details['responseTimeCheck'] = await _checkResponseTime();
  }

  Future<bool> _checkDoHSupport() async {
    // 模拟DoH支持检查
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Future<bool> _checkDoTSupport() async {
    // 模拟DoT支持检查
    await Future.delayed(const Duration(milliseconds: 180));
    return true;
  }

  Future<bool> _checkDNSSECSupport() async {
    // 模拟DNSSEC支持检查
    await Future.delayed(const Duration(milliseconds: 250));
    return true;
  }

  Future<double> _checkResponseTime() async {
    // 模拟响应时间检查
    await Future.delayed(const Duration(milliseconds: 300));
    return 50.0 + math.Random().nextDouble() * 100;
  }

  /// 服务器健康检查
  Future<void> _checkServerHealth() async {
    final servers = DNSSettingsManager.instance.enabledServers;
    
    for (final server in servers) {
      try {
        final startTime = DateTime.now();
        
        // 模拟DNS查询
        await _performTestQuery(server);
        
        final responseTime = DateTime.now().difference(startTime);
        _responseTimes[server.id] = responseTime;
        
        // 更新服务器健康状态
        _updateServerHealth(server, true, responseTime);
      } catch (e) {
        debugPrint('服务器健康检查失败 (${server.name}): $e');
        _updateServerHealth(server, false, null);
      }
    }
  }

  Future<void> _performTestQuery(DNSServerConfig server) async {
    // 模拟DNS查询
await Future.delayed(Duration(milliseconds: 50 + math.Random().nextInt(100));
    
    if (math.Random().nextDouble() < 0.1) {
      throw Exception('模拟查询失败');
    }
  }

  void _updateServerHealth(DNSServerConfig server, bool healthy, Duration? responseTime) {
    _serverHealth.putIfAbsent(server.id, () => []);
    
    final healthList = _serverHealth[server.id]!;
    healthList.add(server.copyWith(
      enabled: healthy,
      options: {
        'responseTime': responseTime?.inMilliseconds,
        'lastCheck': DateTime.now().toIso8601String(),
        'healthy': healthy,
      },
    ));
    
    // 保持最近100条记录
    if (healthList.length > 100) {
      healthList.removeAt(0);
    }
  }

  /// 计算保护分数
  double _calculateProtectionScore(List<DNSLeakType> leaks, DNSProtectionLevel? level) {
    double score = 100.0;
    
    // 根据检测到的泄漏类型扣分
    for (final leak in leaks) {
      switch (leak) {
        case DNSLeakType.ipv6Leak:
          score -= 30;
          break;
        case DNSLeakType.localLeak:
          score -= 25;
          break;
        case DNSLeakType.directLeak:
          score -= 20;
          break;
        case DNSLeakType.smartDNSLeak:
          score -= 15;
          break;
        case DNSLeakType.transparentLeak:
          score -= 10;
          break;
      }
    }
    
    // 根据保护级别调整
    if (level != null) {
      switch (level) {
        case DNSProtectionLevel.basic:
          score *= 0.8;
          break;
        case DNSProtectionLevel.standard:
          score *= 0.9;
          break;
        case DNSProtectionLevel.enhanced:
          score *= 1.0;
          break;
        case DNSProtectionLevel.maximum:
          score *= 1.1;
          break;
      }
    }
    
    return score.clamp(0.0, 100.0);
  }

  /// 获取泄漏警告信息
  String _getLeakWarning(DNSLeakType leakType) {
    switch (leakType) {
      case DNSLeakType.ipv6Leak:
        return '检测到IPv6 DNS泄漏，可能暴露您的真实位置';
      case DNSLeakType.localLeak:
        return '检测到本地DNS泄漏，建议使用加密DNS';
      case DNSLeakType.directLeak:
        return '检测到直连DNS泄漏，建议通过代理进行DNS查询';
      case DNSLeakType.smartDNSLeak:
        return '检测到SmartDNS泄漏，可能影响地理位置';
      case DNSLeakType.transparentLeak:
        return '检测到透明DNS泄漏，建议检查网络配置';
    }
  }

  /// 应用优化
  Future<void> _applyOptimizations(List<DNSLeakType> leaks) async {
    final optimizations = <String>[];
    
    for (final leak in leaks) {
      switch (leak) {
        case DNSLeakType.ipv6Leak:
          optimizations.add('disable_ipv6');
          break;
        case DNSLeakType.localLeak:
          optimizations.add('force_proxy_dns');
          break;
        case DNSLeakType.directLeak:
          optimizations.add('block_direct_dns');
          break;
        case DNSLeakType.smartDNSLeak:
          optimizations.add('use_secure_dns');
          break;
        case DNSLeakType.transparentLeak:
          optimizations.add('configure_transparent_dns');
          break;
      }
    }
    
    debugPrint('应用DNS优化: ${optimizations.join(", ")}');
  }

  /// 记录保护结果
  void _recordProtectionResult(ProtectionResult result) {
    if (_protectionHistory.length >= _maxHistorySize) {
      _protectionHistory.removeFirst();
    }
    _protectionHistory.add(result);
  }

  /// 配置持久化
  Future<File> _getConfigFile() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final configDir = Directory(path.join(appDocDir.path, 'dns_protection'));
    
    if (!await configDir.exists()) {
      await configDir.create(recursive: true);
    }
    
    return File(path.join(configDir.path, 'protection_config.json'));
  }

  Future<void> saveConfiguration() async {
    try {
      final file = await _getConfigFile();
      final data = {
        'status': {
          'isEnabled': _status?.isEnabled,
          'level': _status?.level.name,
          'isLeakDetected': _status?.isLeakDetected,
          'activeLeaks': _status?.activeLeaks.map((l) => l.name).toList(),
          'protectionScore': _status?.protectionScore,
          'lastCheck': _status?.lastCheck.toIso8601String(),
          'lastLeakTime': _status?.lastLeakTime?.toIso8601String(),
        },
        'optimizationConfig': {
          'enableCompression': _optimizationConfig.enableCompression,
          'enableCaching': _optimizationConfig.enableCaching,
          'cacheSize': _optimizationConfig.cacheSize,
          'cacheTimeout': _optimizationConfig.cacheTimeout.inMilliseconds,
          'enableDNSSEC': _optimizationConfig.enableDNSSEC,
          'enableEDNS': _optimizationConfig.enableEDNS,
          'maxRetries': _optimizationConfig.maxRetries,
          'timeout': _optimizationConfig.timeout.inMilliseconds,
          'enableLoadBalancing': _optimizationConfig.enableLoadBalancing,
          'healthyServerCount': _optimizationConfig.healthyServerCount,
          'enableHealthCheck': _optimizationConfig.enableHealthCheck,
          'healthCheckInterval': _optimizationConfig.healthCheckInterval.inMilliseconds,
        },
        'lastModified': DateTime.now().toIso8601String(),
        'version': '1.0',
      };
      
      await file.writeAsString(json.encode(data), flush: true);
    } catch (e) {
      debugPrint('保存DNS保护配置失败: $e');
      rethrow;
    }
  }

  Future<void> loadConfiguration() async {
    try {
      final file = await _getConfigFile();
      if (!await file.exists()) {
        return;
      }

      final content = await file.readAsString();
      final data = json.decode(content) as Map<String, dynamic>;
      
      if (data['status'] case final statusData) {
        _status = DNSProtectionStatus(
          isEnabled: statusData['isEnabled'] as bool? ?? true,
          level: DNSProtectionLevel.values.byName(statusData['level'] ?? 'standard'),
          isLeakDetected: statusData['isLeakDetected'] as bool? ?? false,
          activeLeaks: (statusData['activeLeaks'] as List?)
              ?.map((leak) => DNSLeakType.values.byName(leak));
              .toList() ?? [],
          protectionScore: (statusData['protectionScore'] as num?)?.toDouble() ?? 100.0,
          lastCheck: DateTime.parse(statusData['lastCheck'] as String? ?? DateTime.now().toIso8601String()),
          lastLeakTime: statusData['lastLeakTime'] != null;
              ? DateTime.parse(statusData['lastLeakTime'] as String)
              : null,
        );
      }
      
      if (data['optimizationConfig'] case final configData) {
        _optimizationConfig = DNSOptimizationConfig(
          enableCompression: configData['enableCompression'] as bool? ?? true,
          enableCaching: configData['enableCaching'] as bool? ?? true,
          cacheSize: configData['cacheSize'] as int? ?? 1000,
          cacheTimeout: Duration(milliseconds: configData['cacheTimeout'] as int? ?? 1800000),
          enableDNSSEC: configData['enableDNSSEC'] as bool? ?? true,
          enableEDNS: configData['enableEDNS'] as bool? ?? true,
          maxRetries: configData['maxRetries'] as int? ?? 3,
          timeout: Duration(milliseconds: configData['timeout'] as int? ?? 5000),
          enableLoadBalancing: configData['enableLoadBalancing'] as bool? ?? true,
          healthyServerCount: configData['healthyServerCount'] as int? ?? 2,
          enableHealthCheck: configData['enableHealthCheck'] as bool? ?? true,
          healthCheckInterval: Duration(milliseconds: configData['healthCheckInterval'] as int? ?? 300000),
        );
      }
    } catch (e) {
      debugPrint('加载DNS保护配置失败: $e');
    }
  }

  /// 获取保护报告
  Map<String, dynamic> getProtectionReport() {
    final report = <String, dynamic>{
      'status': _status?.toString(),
      'metrics': _metrics?.toString(),
      'protectionHistory': _protectionHistory.map((r) => r.toString()).toList(),
      'optimizationConfig': _optimizationConfig.toString(),
    };
    
    if (_status != null) {
      report['isEnabled'] = _status!.isEnabled;
      report['protectionLevel'] = _status!.level.name;
      report['isLeakDetected'] = _status!.isLeakDetected;
      report['protectionScore'] = _status!.protectionScore;
      report['activeLeaks'] = _status!.activeLeaks.map((l) => l.name).toList();
    }
    
    return report;
  }

  /// 清理历史记录
  void clearHistory() {
    _protectionHistory.clear();
    notifyListeners();
  }

  /// 清理资源
  @override
  void dispose() {
    stopMonitoring();
    _serverHealth.clear();
    _responseTimes.clear();
    _protectionHistory.clear();
    super.dispose();
  }
}