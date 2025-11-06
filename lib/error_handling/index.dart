/// 错误处理和异常恢复系统
/// 
/// 这个模块提供了一套完整的错误处理和异常恢复解决方案，包括：
/// - 错误恢复管理器
/// - 异常处理器
/// - 崩溃恢复系统
/// - 网络错误处理器
/// - 连接重试管理器
/// - 健康检查系统
/// 
/// ## 使用示例
/// 
/// ```dart
/// import 'package:your_app/error_handling/index.dart';
/// 
/// void main() async {
///   // 初始化错误处理系统
///   await ErrorHandlingSystem.initialize();
///   
///   // 启动健康检查
///   await HealthCheckSystem().initialize();
///   
///   runApp(MyApp());
/// }
/// ```
/// 
/// ## 自动恢复特性
/// 
/// - 自动检测和分类错误类型
/// - 智能重试策略和退避算法
/// - 断路器模式防止级联失败
/// - 状态保存和恢复机制
/// - 自适应错误处理
/// 
/// ## 用户体验优化
/// 
/// - 静默恢复，不中断用户体验
/// - 渐进式降级处理
/// - 友好的错误提示
/// - 智能重试通知
/// - 性能监控和优化

// 错误恢复管理器
export 'error_recovery_manager.dart';

// 异常处理器
export 'exception_handler.dart';

// 崩溃恢复系统
export 'crash_recovery_system.dart';

// 网络错误处理器
export 'network_error_handler.dart';

// 连接重试管理器
export 'connection_retry_manager.dart';

// 健康检查系统
export 'health_check_system.dart';

/// 错误处理系统主入口
class ErrorHandlingSystem {
  static final ErrorHandlingSystem _instance = ErrorHandlingSystem._internal();
  factory ErrorHandlingSystem() => _instance;
  ErrorHandlingSystem._internal();
  
  /// 初始化整个错误处理系统
  static Future<void> initialize([
    ErrorHandlingConfig? config,
  ]) async {
    // 初始化错误恢复管理器
    await ErrorRecoveryManager().initialize();
    
    // 初始化异常处理器
    await ExceptionHandler().initialize();
    
    // 初始化崩溃恢复系统
    await CrashRecoverySystem().initialize();
    
    // 初始化网络错误处理器
    await NetworkErrorHandler().initialize();
    
    // 初始化连接重试管理器
    await ConnectionRetryManager().initialize();
  }
}

/// 错误处理系统配置
class ErrorHandlingConfig {
  final bool enableAutoRecovery;
  final bool enableCrashRecovery;
  final bool enableNetworkRecovery;
  final bool enableHealthMonitoring;
  final bool enablePerformanceMonitoring;
  final Duration systemCheckInterval;
  
  const ErrorHandlingConfig({
    this.enableAutoRecovery = true,
    this.enableCrashRecovery = true,
    this.enableNetworkRecovery = true,
    this.enableHealthMonitoring = true,
    this.enablePerformanceMonitoring = true,
    this.systemCheckInterval = const Duration(minutes: 5),
  });
}

/// 快速使用工具类
class ErrorHandlingUtils {
  /// 快速处理错误
  static Future<T?> safeExecute<T>(
    Future<T> Function() operation, {
    String? context,
    RecoveryStrategy? recoveryStrategy,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      final recoveryManager = ErrorRecoveryManager();
      await recoveryManager.handleError(error, stackTrace, recoveryStrategy);
      return null;
    }
  }
  
  /// 带重试的安全执行
  static Future<T?> safeExecuteWithRetry<T>(
    Future<T> Function() operation, {
    String operationName = 'Safe Operation',
    RetryConfig? retryConfig,
  }) async {
    final retryManager = ConnectionRetryManager();
    final result = await retryManager.executeRetry(
      operation,
      operationName: operationName,
      config: retryConfig,
    );
    
    return result.result;
  }
  
  /// 网络操作的快速重试包装
  static Future<T?> safeNetworkOperation<T>(
    Future<T> Function() operation, {
    String operationName = 'Network Operation',
    NetworkConnectionConfig? networkConfig,
  }) async {
    final networkHandler = NetworkErrorHandler();
    if (networkConfig != null) {
      networkHandler.updateConfig(networkConfig);
    }
    
    try {
      return await operation();
    } catch (error, stackTrace) {
      await networkHandler.handleNetworkError(error, stackTrace);
      return null;
    }
  }
  
  /// 检查系统健康状态
  static Future<bool> isSystemHealthy() async {
    final healthSystem = HealthCheckSystem();
    await healthSystem.initialize();
    
    final results = await healthSystem.performHealthCheck();
    final overallHealth = results.every((result) => 
        result.status == HealthStatus.healthy || result.status == HealthStatus.warning);
    
    return overallHealth;
  }
  
  /// 执行系统健康检查并获取详细报告
  static Future<SystemHealthReport> getSystemHealthReport() async {
    final healthSystem = HealthCheckSystem();
    await healthSystem.initialize();
    
    final results = await healthSystem.performHealthCheck();
    
    return SystemHealthReport(
      timestamp: DateTime.now(),
      overallHealth: healthSystem.overallHealth,
      componentResults: results,
      totalComponents: results.length,
      healthyComponents: results.where((r) => r.status == HealthStatus.healthy).length,
      warningComponents: results.where((r) => r.status == HealthStatus.warning).length,
      errorComponents: results.where((r) => r.status == HealthStatus.error).length,
      criticalFailures: results.where((r) => r.isCritical && r.status == HealthStatus.error).length,
      averageHealthScore: results.isNotEmpty 
          ? results.map((r) => r.healthScore).reduce((a, b) => a + b) / results.length;
          : 1.0,
    );
  }
}

/// 系统健康报告
class SystemHealthReport {
  final DateTime timestamp;
  final HealthStatus overallHealth;
  final List<HealthCheckResult> componentResults;
  final int totalComponents;
  final int healthyComponents;
  final int warningComponents;
  final int errorComponents;
  final int criticalFailures;
  final double averageHealthScore;
  
  const SystemHealthReport({
    required this.timestamp,
    required this.overallHealth,
    required this.componentResults,
    required this.totalComponents,
    required this.healthyComponents,
    required this.warningComponents,
    required this.errorComponents,
    required this.criticalFailures,
    required this.averageHealthScore,
  });
  
  /// 是否整体健康
  bool get isHealthy => overallHealth == HealthStatus.healthy;
  
  /// 是否需要关注
  bool get requiresAttention => overallHealth != HealthStatus.healthy;
  
  /// 是否存在严重问题
  bool get hasCriticalIssues => criticalFailures > 0;
  
  /// 健康度百分比
  int get healthPercentage => (averageHealthScore * 100).round();
  
  /// 获取问题组件列表
  List<HealthCheckResult> get problemComponents {
    return componentResults.where((result) => 
        result.status == HealthStatus.error || result.status == HealthStatus.warning).toList();
  }
  
  /// 获取所有问题描述
  List<String> get allIssues {
    final issues = <String>[];
    for (final result in problemComponents) {
      issues.addAll(result.issues);
    }
    return issues;
  }
  
  /// 获取所有建议
  List<String> get allRecommendations {
    final recommendations = <String>[];
    for (final result in componentResults) {
      recommendations.addAll(result.recommendations);
    }
    return recommendations;
  }
  
  /// 生成文本报告
  String generateTextReport() {
    final buffer = StringBuffer();
    
    buffer.writeln('=== 系统健康报告 ===');
    buffer.writeln('时间: ${timestamp.toIso8601String()}');
    buffer.writeln('整体状态: ${overallHealth.toString()}');
    buffer.writeln('健康度: ${healthPercentage}%');
    buffer.writeln();
    
    buffer.writeln('组件统计:');
    buffer.writeln('  总组件数: $totalComponents');
    buffer.writeln('  健康: $healthyComponents');
    buffer.writeln('  警告: $warningComponents');
    buffer.writeln('  错误: $errorComponents');
    buffer.writeln('  严重故障: $criticalFailures');
    buffer.writeln();
    
    if (problemComponents.isNotEmpty) {
      buffer.writeln('问题组件:');
      for (final component in problemComponents) {
        buffer.writeln('  - ${component.componentId}: ${component.status}');
        if (component.issues.isNotEmpty) {
          buffer.writeln('    问题: ${component.issues.join(', ')}');
        }
        if (component.recommendations.isNotEmpty) {
          buffer.writeln('    建议: ${component.recommendations.join(', ')}');
        }
      }
      buffer.writeln();
    }
    
    if (allIssues.isNotEmpty) {
      buffer.writeln('所有问题:');
      for (final issue in allIssues) {
        buffer.writeln('  - $issue');
      }
      buffer.writeln();
    }
    
    if (allRecommendations.isNotEmpty) {
      buffer.writeln('建议措施:');
      for (final recommendation in allRecommendations) {
        buffer.writeln('  - $recommendation');
      }
    }
    
    return buffer.toString();
  }
  
  @override
  String toString() => generateTextReport();
}