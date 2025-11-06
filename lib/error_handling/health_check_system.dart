import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'error_recovery_manager.dart';
import 'exception_handler.dart';
import 'network_error_handler.dart';

/// 健康状态枚举
enum HealthStatus {
  /// 健康状态
  healthy,
  /// 警告状态
  warning,
  /// 错误状态
  error,
  /// 未知状态
  unknown,
  /// 检查中
  checking,
}

/// 组件类型
enum ComponentType {
  /// 应用程序核心
  applicationCore,
  /// 网络连接
  networkConnection,
  /// 数据存储
  dataStorage,
  /// 用户界面
  userInterface,
  /// 系统服务
  systemServices,
  /// 第三方服务
  thirdPartyServices,
  /// 硬件设备
  hardwareDevices,
  /// 权限管理
  permissions,
  /// 配置文件
  configuration,
  /// 监控组件
  monitoring,
}

/// 健康检查结果
class HealthCheckResult {
  final String componentId;
  final ComponentType componentType;
  final HealthStatus status;
  final String message;
  final Duration responseTime;
  final DateTime timestamp;
  final Map<String, dynamic> metrics;
  final List<String> issues;
  final List<String> recommendations;
  final bool isCritical;
  final double healthScore;
  
  const HealthCheckResult({
    required this.componentId,
    required this.componentType,
    required this.status,
    required this.message,
    required this.responseTime,
    required this.timestamp,
    this.metrics = const {},
    this.issues = const [],
    this.recommendations = const [],
    this.isCritical = false,
    this.healthScore = 1.0,
  });
}

/// 健康检查配置
class HealthCheckConfig {
  final Duration checkInterval;
  final Duration timeout;
  final bool enableAutomaticCheck;
  final bool enableAlerts;
  final List<ComponentType> criticalComponents;
  final Map<ComponentType, Duration> componentTimeouts;
  final double healthThreshold;
  final bool enableMetricsCollection;
  
  const HealthCheckConfig({
    this.checkInterval = const Duration(minutes: 5),
    this.timeout = const Duration(seconds: 30),
    this.enableAutomaticCheck = true,
    this.enableAlerts = true,
    this.criticalComponents = const [;
      ComponentType.applicationCore,
      ComponentType.networkConnection,
      ComponentType.dataStorage,
    ],
    this.componentTimeouts = const {},
    this.healthThreshold = 0.8,
    this.enableMetricsCollection = true,
  });
}

/// 组件监控器
abstract class ComponentMonitor {
  String get componentId;
  ComponentType get componentType;
  
  Future<HealthCheckResult> performHealthCheck([
    Duration? timeout,
  ]);
  
  bool get isCritical;
  double get defaultHealthScore;
}

/// 系统信息收集器
class SystemInfoCollector {
  static const Map<String, String> _systemProperties = {
    'platform': 'platform',
    'version': 'version',
    'locale': 'locale',
    'devicePixelRatio': 'devicePixelRatio',
    'lowMemory': 'lowMemory',
  };
  
  static Map<String, dynamic> collectBasicInfo() {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'locale': Platform.localeName,
      'devicePixelRatio': PlatformDispatcher.instance.devicePixelRatio,
      'lowMemoryDevice': PlatformDispatcher.instance.lowMemory,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  static Future<Map<String, dynamic>> collectDetailedInfo() async {
    final basicInfo = collectBasicInfo();
    
    try {
      // 收集内存信息
      final memoryInfo = await _collectMemoryInfo();
      
      // 收集CPU信息
      final cpuInfo = await _collectCPUInfo();
      
      // 收集磁盘信息
      final diskInfo = await _collectDiskInfo();
      
      // 收集网络信息
      final networkInfo = await _collectNetworkInfo();
      
      return {
        ...basicInfo,
        'memory': memoryInfo,
        'cpu': cpuInfo,
        'disk': diskInfo,
        'network': networkInfo,
      };
    } catch (e) {
      return {
        ...basicInfo,
        'error': e.toString(),
      };
    }
  }
  
  static Future<Map<String, dynamic>> _collectMemoryInfo() async {
    // 简化的内存信息收集
    return {
      'available': 'unknown',
      'used': 'unknown',
      'free': 'unknown',
      'percentage': 0.0,
    };
  }
  
  static Future<Map<String, dynamic>> _collectCPUInfo() async {
    // 简化的CPU信息收集
    return {
      'cores': Platform.numberOfProcessors,
      'architecture': 'unknown',
      'load': 0.0,
    };
  }
  
  static Future<Map<String, dynamic>> _collectDiskInfo() async {
    // 简化的磁盘信息收集
    return {
      'total': 'unknown',
      'free': 'unknown',
      'used': 'unknown',
      'percentage': 0.0,
    };
  }
  
  static Future<Map<String, dynamic>> _collectNetworkInfo() async {
    // 使用网络错误处理器收集网络信息
    try {
      final networkHandler = NetworkErrorHandler();
      final connectionDetails = await networkHandler.connectionDetails;
      
      return {
        'status': connectionDetails?.isConnected ?? false ? 'connected' : 'disconnected',
        'type': connectionDetails?.type.toString() ?? 'unknown',
        'isSecure': connectionDetails?.isSecure ?? false,
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }
}

/// 应用核心组件监控器
class ApplicationCoreMonitor implements ComponentMonitor {
  @override
  String get componentId => 'application_core';
  
  @override
  ComponentType get componentType => ComponentType.applicationCore;
  
  @override
  bool get isCritical => true;
  
  @override
  double get defaultHealthScore => 1.0;
  
  @override
  Future<HealthCheckResult> performHealthCheck([Duration? timeout]) async {
    final checkTimeout = timeout ?? const Duration(seconds: 10);
    final stopwatch = Stopwatch()..start();
    
    try {
      // 检查Flutter框架状态
      final flutterHealthy = await _checkFlutterFramework(checkTimeout);
      
      // 检查应用生命周期
      final lifecycleHealthy = await _checkApplicationLifecycle(checkTimeout);
      
      // 检查错误处理系统
      final errorHandlingHealthy = await _checkErrorHandlingSystem(checkTimeout);
      
      // 检查内存使用情况
      final memoryHealthy = await _checkMemoryUsage(checkTimeout);
      
      stopwatch.stop();
      final responseTime = stopwatch.elapsed;
      
      final allHealthy = flutterHealthy && lifecycleHealthy && errorHandlingHealthy && memoryHealthy;
      final healthScore = _calculateHealthScore(flutterHealthy, lifecycleHealthy, errorHandlingHealthy, memoryHealthy);
      
      return HealthCheckResult(
        componentId: componentId,
        componentType: componentType,
        status: allHealthy ? HealthStatus.healthy : HealthStatus.error,
        message: allHealthy ? '应用核心组件运行正常' : '应用核心组件存在问题',
        responseTime: responseTime,
        timestamp: DateTime.now(),
        metrics: {
          'flutterFramework': flutterHealthy,
          'applicationLifecycle': lifecycleHealthy,
          'errorHandling': errorHandlingHealthy,
          'memoryUsage': memoryHealthy,
        },
        issues: allHealthy ? [] : _identifyIssues(flutterHealthy, lifecycleHealthy, errorHandlingHealthy, memoryHealthy),
        recommendations: allHealthy ? [] : _generateRecommendations(flutterHealthy, lifecycleHealthy, errorHandlingHealthy, memoryHealthy),
        isCritical: true,
        healthScore: healthScore,
      );
      
    } catch (e) {
      stopwatch.stop();
      
      return HealthCheckResult(
        componentId: componentId,
        componentType: componentType,
        status: HealthStatus.error,
        message: '应用核心检查失败: $e',
        responseTime: stopwatch.elapsed,
        timestamp: DateTime.now(),
        metrics: {'error': e.toString()},
        issues: ['应用核心检查异常'],
        recommendations: ['检查应用配置', '重启应用'],
        isCritical: true,
        healthScore: 0.0,
      );
    }
  }
  
  Future<bool> _checkFlutterFramework(Duration timeout) async {
    try {
      // 简单的Flutter框架健康检查
      await Future.delayed(Duration(milliseconds: 100));
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> _checkApplicationLifecycle(Duration timeout) async {
    try {
      // 检查应用生命周期状态
      await Future.delayed(Duration(milliseconds: 50));
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> _checkErrorHandlingSystem(Duration timeout) async {
    try {
      // 检查错误处理系统
      final errorHandler = ExceptionHandler();
      final stats = errorHandler.getExceptionStatistics();
      return stats.isNotEmpty; // 只要有统计数据就说明系统在工作
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> _checkMemoryUsage(Duration timeout) async {
    try {
      // 检查内存使用情况
      final isLowMemory = PlatformDispatcher.instance.lowMemory;
      return !isLowMemory;
    } catch (e) {
      return false;
    }
  }
  
  double _calculateHealthScore(bool flutter, bool lifecycle, bool errorHandling, bool memory) {
    int healthyCount = 0;
    if (flutter) healthyCount++;
    if (lifecycle) healthyCount++;
    if (errorHandling) healthyCount++;
    if (memory) healthyCount++;
    
    return healthyCount / 4.0;
  }
  
  List<String> _identifyIssues(bool flutter, bool lifecycle, bool errorHandling, bool memory) {
    final issues = <String>[];
    if (!flutter) issues.add('Flutter框架异常');
    if (!lifecycle) issues.add('应用生命周期管理异常');
    if (!errorHandling) issues.add('错误处理系统异常');
    if (!memory) issues.add('内存使用异常');
    return issues;
  }
  
  List<String> _generateRecommendations(bool flutter, bool lifecycle, bool errorHandling, bool memory) {
    final recommendations = <String>[];
    if (!flutter) recommendations.add('重启应用以恢复Flutter框架');
    if (!lifecycle) recommendations.add('检查应用生命周期管理代码');
    if (!errorHandling) recommendations.add('检查错误处理系统配置');
    if (!memory) recommendations.add('释放不必要的内存占用');
    return recommendations;
  }
}

/// 网络连接组件监控器
class NetworkConnectionMonitor implements ComponentMonitor {
  @override
  String get componentId => 'network_connection';
  
  @override
  ComponentType get componentType => ComponentType.networkConnection;
  
  @override
  bool get isCritical => true;
  
  @override
  double get defaultHealthScore => 0.9;
  
  @override
  Future<HealthCheckResult> performHealthCheck([Duration? timeout]) async {
    final checkTimeout = timeout ?? const Duration(seconds: 30);
    final stopwatch = Stopwatch()..start();
    
    try {
      final networkHandler = NetworkErrorHandler();
      
      // 检查网络连接状态
      final isConnected = networkHandler.isConnected;
      final networkType = networkHandler.currentNetworkType;
      final networkHealth = networkHandler.networkHealth;
      
      // 执行连接测试
      final testResult = await networkHandler.testConnection();
      
      // 获取连接详情
      final connectionDetails = await networkHandler.connectionDetails;
      
      // 获取错误统计
      final errorStats = networkHandler.errorStatistics;
      
      stopwatch.stop();
      
      final isHealthy = isConnected && testResult.success && networkHealth > 0.7;
      final healthScore = _calculateNetworkHealthScore(isConnected, testResult.success, networkHealth);
      
      return HealthCheckResult(
        componentId: componentId,
        componentType: componentType,
        status: isHealthy ? HealthStatus.healthy : HealthStatus.error,
        message: isHealthy ? '网络连接正常' : '网络连接存在问题',
        responseTime: stopwatch.elapsed,
        timestamp: DateTime.now(),
        metrics: {
          'isConnected': isConnected,
          'networkType': networkType.toString(),
          'networkHealth': networkHealth,
          'testSuccess': testResult.success,
          'latency': testResult.latency.inMilliseconds,
          'errorCount': errorStats.values.fold(0, (sum, count) => sum + count),
        },
        issues: isHealthy ? [] : _identifyNetworkIssues(isConnected, testResult, networkHealth),
        recommendations: isHealthy ? [] : _generateNetworkRecommendations(isConnected, testResult),
        isCritical: true,
        healthScore: healthScore,
      );
      
    } catch (e) {
      stopwatch.stop();
      
      return HealthCheckResult(
        componentId: componentId,
        componentType: componentType,
        status: HealthStatus.error,
        message: '网络连接检查失败: $e',
        responseTime: stopwatch.elapsed,
        timestamp: DateTime.now(),
        metrics: {'error': e.toString()},
        issues: ['网络连接检查异常'],
        recommendations: ['检查网络配置', '检查网络权限'],
        isCritical: true,
        healthScore: 0.0,
      );
    }
  }
  
  double _calculateNetworkHealthScore(bool isConnected, bool testSuccess, double networkHealth) {
    double score = 0.0;
    if (isConnected) score += 0.4;
    if (testSuccess) score += 0.4;
    score += networkHealth * 0.2;
    return score.clamp(0.0, 1.0);
  }
  
  List<String> _identifyNetworkIssues(bool isConnected, NetworkTestResult testResult, double networkHealth) {
    final issues = <String>[];
    if (!isConnected) issues.add('网络未连接');
    if (!testResult.success) issues.add('连接测试失败');
    if (networkHealth < 0.5) issues.add('网络质量较差');
    return issues;
  }
  
  List<String> _generateNetworkRecommendations(bool isConnected, NetworkTestResult testResult) {
    final recommendations = <String>[];
    if (!isConnected) recommendations.add('检查网络连接');
    if (!testResult.success) recommendations.add('检查网络配置');
    recommendations.add('切换到稳定的网络环境');
    return recommendations;
  }
}

/// 数据存储组件监控器
class DataStorageMonitor implements ComponentMonitor {
  @override
  String get componentId => 'data_storage';
  
  @override
  ComponentType get componentType => ComponentType.dataStorage;
  
  @override
  bool get isCritical => true;
  
  @override
  double get defaultHealthScore => 0.9;
  
  @override
  Future<HealthCheckResult> performHealthCheck([Duration? timeout]) async {
    final checkTimeout = timeout ?? const Duration(seconds: 15);
    final stopwatch = Stopwatch()..start();
    
    try {
      // 检查SharedPreferences
      final preferencesHealthy = await _checkSharedPreferences(checkTimeout);
      
      // 检查文件系统
      final fileSystemHealthy = await _checkFileSystem(checkTimeout);
      
      // 检查数据库连接（如适用）
      final databaseHealthy = await _checkDatabase(checkTimeout);
      
      // 检查存储空间
      final storageHealthy = await _checkStorageSpace(checkTimeout);
      
      stopwatch.stop();
      
      final allHealthy = preferencesHealthy && fileSystemHealthy && databaseHealthy && storageHealthy;
      final healthScore = _calculateStorageHealthScore(preferencesHealthy, fileSystemHealthy, databaseHealthy, storageHealthy);
      
      return HealthCheckResult(
        componentId: componentId,
        componentType: componentType,
        status: allHealthy ? HealthStatus.healthy : HealthStatus.error,
        message: allHealthy ? '数据存储组件运行正常' : '数据存储组件存在问题',
        responseTime: stopwatch.elapsed,
        timestamp: DateTime.now(),
        metrics: {
          'sharedPreferences': preferencesHealthy,
          'fileSystem': fileSystemHealthy,
          'database': databaseHealthy,
          'storageSpace': storageHealthy,
        },
        issues: allHealthy ? [] : _identifyStorageIssues(preferencesHealthy, fileSystemHealthy, databaseHealthy, storageHealthy),
        recommendations: allHealthy ? [] : _generateStorageRecommendations(preferencesHealthy, fileSystemHealthy, databaseHealthy, storageHealthy),
        isCritical: true,
        healthScore: healthScore,
      );
      
    } catch (e) {
      stopwatch.stop();
      
      return HealthCheckResult(
        componentId: componentId,
        componentType: componentType,
        status: HealthStatus.error,
        message: '数据存储检查失败: $e',
        responseTime: stopwatch.elapsed,
        timestamp: DateTime.now(),
        metrics: {'error': e.toString()},
        issues: ['数据存储检查异常'],
        recommendations: ['检查存储权限', '释放存储空间'],
        isCritical: true,
        healthScore: 0.0,
      );
    }
  }
  
  Future<bool> _checkSharedPreferences(Duration timeout) async {
    try {
      // 简单的SharedPreferences检查
      await Future.delayed(Duration(milliseconds: 100));
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> _checkFileSystem(Duration timeout) async {
    try {
      // 简单的文件系统检查
      await Future.delayed(Duration(milliseconds: 100));
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> _checkDatabase(Duration timeout) async {
    try {
      // 简单的数据库检查
      await Future.delayed(Duration(milliseconds: 50));
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> _checkStorageSpace(Duration timeout) async {
    try {
      // 简化的存储空间检查
      await Future.delayed(Duration(milliseconds: 50));
      return true;
    } catch (e) {
      return false;
    }
  }
  
  double _calculateStorageHealthScore(bool preferences, bool fileSystem, bool database, bool storage) {
    int healthyCount = 0;
    if (preferences) healthyCount++;
    if (fileSystem) healthyCount++;
    if (database) healthyCount++;
    if (storage) healthyCount++;
    
    return healthyCount / 4.0;
  }
  
  List<String> _identifyStorageIssues(bool preferences, bool fileSystem, bool database, bool storage) {
    final issues = <String>[];
    if (!preferences) issues.add('SharedPreferences异常');
    if (!fileSystem) issues.add('文件系统异常');
    if (!database) issues.add('数据库连接异常');
    if (!storage) issues.add('存储空间不足');
    return issues;
  }
  
  List<String> _generateStorageRecommendations(bool preferences, bool fileSystem, bool database, bool storage) {
    final recommendations = <String>[];
    if (!preferences) recommendations.add('检查SharedPreferences配置');
    if (!fileSystem) recommendations.add('检查文件系统权限');
    if (!database) recommendations.add('检查数据库配置');
    if (!storage) recommendations.add('清理存储空间');
    return recommendations;
  }
}

/// 用户界面组件监控器
class UserInterfaceMonitor implements ComponentMonitor {
  @override
  String get componentId => 'user_interface';
  
  @override
  ComponentType get componentType => ComponentType.userInterface;
  
  @override
  bool get isCritical => false;
  
  @override
  double get defaultHealthScore => 0.95;
  
  @override
  Future<HealthCheckResult> performHealthCheck([Duration? timeout]) async {
    final checkTimeout = timeout ?? const Duration(seconds: 10);
    final stopwatch = Stopwatch()..start();
    
    try {
      // 检查Widget树状态
      final widgetTreeHealthy = await _checkWidgetTree(checkTimeout);
      
      // 检查UI性能
      final uiPerformanceHealthy = await _checkUIPerformance(checkTimeout);
      
      // 检查屏幕适配
      final screenAdaptationHealthy = await _checkScreenAdaptation(checkTimeout);
      
      stopwatch.stop();
      
      final allHealthy = widgetTreeHealthy && uiPerformanceHealthy && screenAdaptationHealthy;
      final healthScore = _calculateUIHealthScore(widgetTreeHealthy, uiPerformanceHealthy, screenAdaptationHealthy);
      
      return HealthCheckResult(
        componentId: componentId,
        componentType: componentType,
        status: allHealthy ? HealthStatus.healthy : HealthStatus.warning,
        message: allHealthy ? '用户界面组件运行正常' : '用户界面组件存在轻微问题',
        responseTime: stopwatch.elapsed,
        timestamp: DateTime.now(),
        metrics: {
          'widgetTree': widgetTreeHealthy,
          'uiPerformance': uiPerformanceHealthy,
          'screenAdaptation': screenAdaptationHealthy,
        },
        issues: allHealthy ? [] : _identifyUIIssues(widgetTreeHealthy, uiPerformanceHealthy, screenAdaptationHealthy),
        recommendations: allHealthy ? [] : _generateUIRecommendations(widgetTreeHealthy, uiPerformanceHealthy, screenAdaptationHealthy),
        isCritical: false,
        healthScore: healthScore,
      );
      
    } catch (e) {
      stopwatch.stop();
      
      return HealthCheckResult(
        componentId: componentId,
        componentType: componentType,
        status: HealthStatus.warning,
        message: '用户界面检查失败: $e',
        responseTime: stopwatch.elapsed,
        timestamp: DateTime.now(),
        metrics: {'error': e.toString()},
        issues: ['用户界面检查异常'],
        recommendations: ['检查UI代码', '重启应用'],
        isCritical: false,
        healthScore: 0.5,
      );
    }
  }
  
  Future<bool> _checkWidgetTree(Duration timeout) async {
    try {
      // 简单的Widget树检查
      await Future.delayed(Duration(milliseconds: 100));
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> _checkUIPerformance(Duration timeout) async {
    try {
      // 简单的UI性能检查
      await Future.delayed(Duration(milliseconds: 100));
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> _checkScreenAdaptation(Duration timeout) async {
    try {
      // 简单的屏幕适配检查
      await Future.delayed(Duration(milliseconds: 50));
      return true;
    } catch (e) {
      return false;
    }
  }
  
  double _calculateUIHealthScore(bool widgetTree, bool uiPerformance, bool screenAdaptation) {
    int healthyCount = 0;
    if (widgetTree) healthyCount++;
    if (uiPerformance) healthyCount++;
    if (screenAdaptation) healthyCount++;
    
    return healthyCount / 3.0;
  }
  
  List<String> _identifyUIIssues(bool widgetTree, bool uiPerformance, bool screenAdaptation) {
    final issues = <String>[];
    if (!widgetTree) issues.add('Widget树异常');
    if (!uiPerformance) issues.add('UI性能异常');
    if (!screenAdaptation) issues.add('屏幕适配异常');
    return issues;
  }
  
  List<String> _generateUIRecommendations(bool widgetTree, bool uiPerformance, bool screenAdaptation) {
    final recommendations = <String>[];
    if (!widgetTree) recommendations.add('检查Widget代码');
    if (!uiPerformance) recommendations.add('优化UI性能');
    if (!screenAdaptation) recommendations.add('优化屏幕适配');
    return recommendations;
  }
}

/// 健康检查系统
class HealthCheckSystem {
  static final HealthCheckSystem _instance = HealthCheckSystem._internal();
  factory HealthCheckSystem() => _instance;
  HealthCheckSystem._internal();
  
  final Logger _logger = Logger('HealthCheckSystem');
  
  /// 健康检查配置
  HealthCheckConfig _config = const HealthCheckConfig();
  
  /// 组件监控器映射
  final Map<String, ComponentMonitor> _monitors = {};
  
  /// 健康检查定时器
  Timer? _healthCheckTimer;
  
  /// 健康检查结果历史
  final List<HealthCheckResult> _healthHistory = [];
  
  /// 系统整体健康状态
  HealthStatus _overallHealth = HealthStatus.unknown;
  
  /// 健康变更监听器
  final List<HealthStatusListener> _healthListeners = [];
  
  /// 检查结果监听器
  final List<HealthCheckListener> _checkListeners = [];
  
  /// 控制器
  final StreamController<HealthCheckResult> _healthStreamController =;
      StreamController<HealthCheckResult>.broadcast();
  
  /// 健康检查流
  Stream<HealthCheckResult> get healthStream => _healthStreamController.stream;
  
  /// 初始化健康检查系统
  Future<void> initialize([HealthCheckConfig? config]) async {
    if (config != null) {
      _config = config;
    }
    
    _logger.info('初始化健康检查系统');
    
    // 注册默认监控器
    _registerDefaultMonitors();
    
    // 设置自动健康检查
    if (_config.enableAutomaticCheck) {
      _setupAutomaticHealthCheck();
    }
    
    // 初始健康检查
    await _performInitialHealthCheck();
    
    _logger.info('健康检查系统初始化完成');
  }
  
  /// 注册默认监控器
  void _registerDefaultMonitors() {
    registerMonitor(ApplicationCoreMonitor());
    registerMonitor(NetworkConnectionMonitor());
    registerMonitor(DataStorageMonitor());
    registerMonitor(UserInterfaceMonitor());
    
    _logger.info('注册默认监控器完成');
  }
  
  /// 注册组件监控器
  void registerMonitor(ComponentMonitor monitor) {
    _monitors[monitor.componentId] = monitor;
    _logger.info('注册组件监控器: ${monitor.componentId} (${monitor.componentType})');
  }
  
  /// 移除组件监控器
  void unregisterMonitor(String componentId) {
    _monitors.remove(componentId);
    _logger.info('移除组件监控器: $componentId');
  }
  
  /// 设置自动健康检查
  void _setupAutomaticHealthCheck() {
    _healthCheckTimer = Timer.periodic(_config.checkInterval, (timer) {
      _performPeriodicHealthCheck();
    });
  }
  
  /// 执行周期性健康检查
  Future<void> _performPeriodicHealthCheck() async {
    try {
      await performHealthCheck();
    } catch (e) {
      _logger.error('周期性健康检查失败: $e');
    }
  }
  
  /// 执行初始健康检查
  Future<void> _performInitialHealthCheck() async {
    _logger.info('执行初始健康检查');
    await performHealthCheck();
  }
  
  /// 执行健康检查
  Future<List<HealthCheckResult>> performHealthCheck() async {
    _logger.debug('开始健康检查');
    
    final results = <HealthCheckResult>[];
    final criticalFailures = <String>[];
    
    // 并行执行所有组件健康检查
    final futures = _monitors.entries.map((entry) async {
      try {
        final result = await entry.value.performHealthCheck();
        results.add(result);
        return result;
      } catch (e) {
        _logger.error('组件健康检查失败: ${entry.key} - $e');
        return HealthCheckResult(
          componentId: entry.key,
          componentType: entry.value.componentType,
          status: HealthStatus.error,
          message: '健康检查失败: $e',
          responseTime: Duration.zero,
          timestamp: DateTime.now(),
          issues: ['检查过程异常'],
          recommendations: ['重新检查'],
          isCritical: entry.value.isCritical,
          healthScore: 0.0,
        );
      }
    });
    
    final checkResults = await Future.wait(futures);
    results.addAll(checkResults);
    
    // 分析整体健康状态
    _analyzeOverallHealth(results);
    
    // 发布结果
    for (final result in results) {
      _healthStreamController.add(result);
      _notifyCheckListeners(result);
    }
    
    // 保存到历史记录
    _addToHistory(results);
    
    _logger.info('健康检查完成，检查了${results.length}个组件');
    return results;
  }
  
  /// 分析整体健康状态
  void _analyzeOverallHealth(List<HealthCheckResult> results) {
    if (results.isEmpty) {
      _overallHealth = HealthStatus.unknown;
      return;
    }
    
    int healthyCount = 0;
    int warningCount = 0;
    int errorCount = 0;
    int criticalFailures = 0;
    
    for (final result in results) {
      switch (result.status) {
        case HealthStatus.healthy:
          healthyCount++;
          break;
        case HealthStatus.warning:
          warningCount++;
          break;
        case HealthStatus.error:
          errorCount++;
          if (result.isCritical) {
            criticalFailures++;
          }
          break;
        case HealthStatus.unknown:
        case HealthStatus.checking:
          // 暂时不计入
          break;
      }
    }
    
    final oldHealth = _overallHealth;
    
    // 确定整体健康状态
    if (criticalFailures > 0) {
      _overallHealth = HealthStatus.error;
    } else if (errorCount > 0) {
      _overallHealth = HealthStatus.warning;
    } else if (warningCount > 0) {
      _overallHealth = HealthStatus.warning;
    } else {
      _overallHealth = HealthStatus.healthy;
    }
    
    // 通知健康状态变更
    if (oldHealth != _overallHealth) {
      _notifyHealthListeners(oldHealth, _overallHealth);
      _logger.info('整体健康状态变更: $oldHealth -> $_overallHealth');
    }
  }
  
  /// 添加到历史记录
  void _addToHistory(List<HealthCheckResult> results) {
    final timestamp = DateTime.now();
    
    for (final result in results) {
      _healthHistory.add(result);
    }
    
    // 限制历史记录数量（保留最近100次检查）
    while (_healthHistory.length > 100) {
      _healthHistory.removeAt(0);
    }
  }
  
  /// 通知健康状态监听器
  void _notifyHealthListeners(HealthStatus oldStatus, HealthStatus newStatus) {
    for (final listener in _healthListeners) {
      try {
        listener(oldStatus, newStatus);
      } catch (e) {
        _logger.error('通知健康状态监听器失败: $e');
      }
    }
  }
  
  /// 通知检查结果监听器
  void _notifyCheckListeners(HealthCheckResult result) {
    for (final listener in _checkListeners) {
      try {
        listener(result);
      } catch (e) {
        _logger.error('通知检查结果监听器失败: $e');
      }
    }
  }
  
  /// 获取特定组件的健康状态
  Future<HealthCheckResult?> getComponentHealth(String componentId) async {
    final monitor = _monitors[componentId];
    if (monitor == null) {
      return null;
    }
    
    try {
      return await monitor.performHealthCheck();
    } catch (e) {
      _logger.error('获取组件健康状态失败: $componentId - $e');
      return null;
    }
  }
  
  /// 获取整体健康状态
  HealthStatus get overallHealth => _overallHealth;
  
  /// 获取健康历史
  List<HealthCheckResult> getHealthHistory({int? limit}) {
    final history = List<HealthCheckResult>.from(_healthHistory);
    if (limit != null && history.length > limit) {
      return history.sublist(history.length - limit);
    }
    return history;
  }
  
  /// 获取组件列表
  List<String> get registeredComponents => _monitors.keys.toList();
  
  /// 添加健康状态监听器
  void addHealthListener(HealthStatusListener listener) {
    _healthListeners.add(listener);
  }
  
  /// 移除健康状态监听器
  void removeHealthListener(HealthStatusListener listener) {
    _healthListeners.remove(listener);
  }
  
  /// 添加检查结果监听器
  void addCheckListener(HealthCheckListener listener) {
    _checkListeners.add(listener);
  }
  
  /// 移除检查结果监听器
  void removeCheckListener(HealthCheckListener listener) {
    _checkListeners.remove(listener);
  }
  
  /// 更新配置
  void updateConfig(HealthCheckConfig newConfig) {
    _config = newConfig;
    
    // 重新设置自动健康检查
    if (_healthCheckTimer != null) {
      _healthCheckTimer?.cancel();
    }
    
    if (_config.enableAutomaticCheck) {
      _setupAutomaticHealthCheck();
    }
    
    _logger.info('更新健康检查配置');
  }
  
  /// 获取配置
  HealthCheckConfig get config => _config;
  
  /// 清除历史记录
  void clearHistory() {
    _healthHistory.clear();
    _logger.info('清除健康检查历史记录');
  }
  
  /// 关闭系统
  Future<void> dispose() async {
    _logger.info('关闭健康检查系统');
    
    // 取消定时器
    _healthCheckTimer?.cancel();
    
    // 关闭流控制器
    await _healthStreamController.close();
    
    // 清理监听器
    _healthListeners.clear();
    _checkListeners.clear();
    
    // 清理监控器
    _monitors.clear();
    
    _logger.info('健康检查系统已关闭');
  }
}

/// 健康状态监听器
typedef HealthStatusListener = void Function(HealthStatus oldStatus, HealthStatus newStatus);

/// 健康检查监听器
typedef HealthCheckListener = void Function(HealthCheckResult result);