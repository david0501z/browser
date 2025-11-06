import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

// 导入错误处理系统
import 'error_handling/index.dart';

/// 错误处理系统测试
void main() {
  group('Error Handling System', () {
    setUp(() async {
      // 在每个测试前初始化系统
      await ErrorHandlingSystem.initialize();
    });

    tearDown(() {
      // 清理资源
      ErrorRecoveryManager().clearHistory();
      ExceptionHandler().clearStatistics();
      NetworkErrorHandler().clearErrorStatistics();
      ConnectionRetryManager().clearStatistics();
      HealthCheckSystem().dispose();
    });

    test('ErrorRecoveryManager should handle errors correctly', () async {
      final recoveryManager = ErrorRecoveryManager();
      
      // 测试错误处理
      try {
        throw Exception('Test error');
      } catch (error, stackTrace) {
        final result = await recoveryManager.handleError(error, stackTrace);
        
        expect(result, isNotNull);
        expect(result!.success, isTrue);
        expect(result.strategy, isA<RecoveryStrategy>());
      }
    });

    test('ExceptionHandler should capture and classify exceptions', () async {
      final exceptionHandler = ExceptionHandler();
      
      // 测试异常处理
      final result = await exceptionHandler.handleException(
        Exception('Test exception'),
        StackTrace.current,
        'Test Context',
      );
      
      expect(result.handled, isTrue);
      expect(result.strategy, isA<ExceptionHandlingStrategy>());
    });

    test('ConnectionRetryManager should retry failed operations', () async {
      final retryManager = ConnectionRetryManager();
      int attemptCount = 0;
      
      // 创建一个总是失败的操作，前两次失败，第三次成功
      final operation = () async {
        attemptCount++;
        if (attemptCount < 3) {
          throw Exception('Operation failed');
        }
        return 'Success';
      };
      
      final result = await retryManager.executeRetry(
        operation,
        operationName: 'Test Retry Operation',
        config: const RetryConfig(
          maxAttempts: 5,
          strategy: RetryStrategy.fixedInterval,
          initialDelay: Duration(milliseconds: 100),
        ),
      );
      
      expect(result.success, isTrue);
      expect(result.attempts, equals(3));
      expect(result.result, equals('Success'));
    });

    test('NetworkErrorHandler should detect and handle network issues', () async {
      final networkHandler = NetworkErrorHandler();
      
      // 测试连接状态检查
      final isConnected = networkHandler.isConnected;
      expect(isConnected, isA<bool>());
      
      // 测试网络健康度
      final networkHealth = networkHandler.networkHealth;
      expect(networkHealth, greaterThanOrEqualTo(0.0));
      expect(networkHealth, lessThanOrEqualTo(1.0));
    });

    test('CrashRecoverySystem should save and recover app state', () async {
      final crashRecovery = CrashRecoverySystem();
      
      // 测试状态保存
      final snapshot = await crashRecovery.saveCurrentState('Test save');
      
      expect(snapshot, isNotNull);
      expect(snapshot.id, isNotEmpty);
      expect(snapshot.timestamp, isNotNull);
      
      // 测试崩溃检测
      final detectionResult = await crashRecovery.detectCrash();
      expect(detectionResult.isCrash, isA<bool>());
    });

    test('HealthCheckSystem should monitor component health', () async {
      final healthSystem = HealthCheckSystem();
      await healthSystem.initialize();
      
      // 执行健康检查
      final results = await healthSystem.performHealthCheck();
      
      expect(results, isNotEmpty);
      expect(results.length, greaterThan(0));
      
      for (final result in results) {
        expect(result.componentId, isNotEmpty);
        expect(result.status, isA<HealthStatus>());
        expect(result.responseTime, greaterThanOrEqualTo(Duration.zero));
        expect(result.healthScore, greaterThanOrEqualTo(0.0));
        expect(result.healthScore, lessThanOrEqualTo(1.0));
      }
    });

    test('ErrorHandlingUtils should provide convenient helpers', () async {
      int successCount = 0;
      
      // 测试安全执行
      final result = await ErrorHandlingUtils.safeExecute(() async {
        successCount++;
        return 'Success';
      });
      
      expect(result, equals('Success'));
      expect(successCount, equals(1));
      
      // 测试安全执行与重试
      int retryAttemptCount = 0;
      final retryResult = await ErrorHandlingUtils.safeExecuteWithRetry(() async {
        retryAttemptCount++;
        if (retryAttemptCount < 3) {
          throw Exception('Temporary failure');
        }
        return 'Retry Success';
      });
      
      expect(retryResult, equals('Retry Success'));
      expect(retryAttemptCount, equals(3));
    });

    test('SystemHealthReport should generate comprehensive reports', () async {
      // 获取系统健康报告
      final report = await ErrorHandlingUtils.getSystemHealthReport();
      
      expect(report.timestamp, isNotNull);
      expect(report.overallHealth, isA<HealthStatus>());
      expect(report.totalComponents, greaterThanOrEqualTo(0));
      expect(report.healthyComponents, greaterThanOrEqualTo(0));
      expect(report.warningComponents, greaterThanOrEqualTo(0));
      expect(report.errorComponents, greaterThanOrEqualTo(0));
      expect(report.criticalFailures, greaterThanOrEqualTo(0));
      expect(report.averageHealthScore, greaterThanOrEqualTo(0.0));
      expect(report.averageHealthScore, lessThanOrEqualTo(1.0));
      expect(report.healthPercentage, greaterThanOrEqualTo(0));
      expect(report.healthPercentage, lessThanOrEqualTo(100));
      
      // 测试文本报告生成
      final textReport = report.generateTextReport();
      expect(textReport, isNotEmpty);
      expect(textReport, contains('=== 系统健康报告 ==='));
    });

    test('Should handle different error types appropriately', () async {
      final recoveryManager = ErrorRecoveryManager();
      
      // 测试不同类型的错误
      final testErrors = [
        SocketException('Test socket error'),
        TimeoutException('Test timeout', Duration(seconds: 5)),
        FileSystemException('Test file error', '/test/path'),
        PlatformException(code: 'test_code', message: 'Test platform error'),
      ];
      
      for (final error in testErrors) {
        try {
          rethrow;
        } catch (_, stackTrace) {
          final result = await recoveryManager.handleError(error, stackTrace);
          expect(result, isNotNull);
        }
      }
    });

    test('Should respect retry limits and circuit breaker', () async {
      final retryManager = ConnectionRetryManager();
      int callCount = 0;
      
      // 创建一个总是失败的操作
      final failingOperation = () async {
        callCount++;
        throw Exception('Always fails');
      };
      
      final result = await retryManager.executeRetry(
        failingOperation,
        operationName: 'Test Circuit Breaker',
        config: const RetryConfig(
          maxAttempts: 3,
          strategy: RetryStrategy.fixedInterval,
          initialDelay: Duration(milliseconds: 50),
        ),
      );
      
      expect(result.success, isFalse);
      expect(result.attempts, equals(3));
      expect(callCount, equals(3));
      expect(result.error, isNotNull);
    });

    test('Should handle component health monitoring correctly', () async {
      final healthSystem = HealthCheckSystem();
      await healthSystem.initialize();
      
      // 检查注册的组件数量
      final components = healthSystem.registeredComponents;
      expect(components, isNotEmpty);
      
      // 测试特定组件的健康检查
      for (final componentId in components) {
        final componentHealth = await healthSystem.getComponentHealth(componentId);
        expect(componentHealth, isNotNull);
        
        if (componentHealth != null) {
          expect(componentHealth.componentId, equals(componentId));
          expect(componentHealth.status, isA<HealthStatus>());
        }
      }
    });

    test('Should properly clean up resources', () async {
      final healthSystem = HealthCheckSystem();
      await healthSystem.initialize();
      
      // 添加监听器
      int listenerCallCount = 0;
      healthSystem.addHealthListener((oldStatus, newStatus) {
        listenerCallCount++;
      });
      
      healthSystem.addCheckListener((result) {
        listenerCallCount++;
      });
      
      // 执行健康检查以触发监听器
      await healthSystem.performHealthCheck();
      
      // 清理资源
      healthSystem.clearHistory();
      healthSystem.dispose();
      
      // 验证清理后的状态
      expect(healthSystem.registeredComponents, isEmpty);
      expect(listenerCallCount, greaterThan(0));
    });

    test('Should handle recovery state changes correctly', () async {
      final recoveryManager = ErrorRecoveryManager();
      bool stateChangeReceived = false;
      
      // 添加状态监听器
      recoveryManager.addRecoveryStateListener((state, context) {
        stateChangeReceived = true;
        expect(state, isA<RecoveryState>());
        expect(context, isNotNull);
      });
      
      // 触发错误处理以测试状态变更
      try {
        throw Exception('Test state change');
      } catch (error, stackTrace) {
        await recoveryManager.handleError(error, stackTrace);
      }
      
      expect(stateChangeReceived, isTrue);
    });

    test('Should handle network connectivity changes', () async {
      final networkHandler = NetworkErrorHandler();
      
      // 添加状态监听器
      bool statusChangeReceived = false;
      NetworkStatus? oldStatus, newStatus;
      
      networkHandler.addStatusListener((status, newNetStatus, type) {
        statusChangeReceived = true;
        oldStatus = status;
        newStatus = newNetStatus;
      });
      
      // 由于我们不能真正模拟网络变更，这里只测试监听器注册
      expect(networkHandler.currentStatus, isA<NetworkStatus>());
      
      // 清理监听器
      // 注意：这里不能测试真正的网络变更，因为需要真实的网络环境
    });
  });

  group('Error Handling Integration Tests', () {
    test('Full system integration should work together', () async {
      // 初始化整个系统
      await ErrorHandlingSystem.initialize();
      
      // 测试各个组件之间的协作
      final recoveryManager = ErrorRecoveryManager();
      final exceptionHandler = ExceptionHandler();
      final retryManager = ConnectionRetryManager();
      final networkHandler = NetworkErrorHandler();
      final healthSystem = HealthCheckSystem();
      await healthSystem.initialize();
      
      // 模拟一个复杂的错误场景
      final complexOperation = () async {
        // 模拟网络请求失败
        throw SocketException('Connection failed');
      };
      
      final result = await retryManager.executeRetry(
        complexOperation,
        operationName: 'Complex Error Test',
      );
      
      // 验证重试管理器处理了错误
      expect(result.success, isFalse);
      expect(result.attempts, greaterThan(0));
      
      // 执行健康检查
      final healthResults = await healthSystem.performHealthCheck();
      expect(healthResults, isNotEmpty);
      
      // 获取系统健康报告
      final systemReport = await ErrorHandlingUtils.getSystemHealthReport();
      expect(systemReport.totalComponents, greaterThan(0));
      expect(systemReport.healthPercentage, greaterThanOrEqualTo(0));
      
      // 验证系统整体状态
      final isHealthy = await ErrorHandlingUtils.isSystemHealthy();
      expect(isHealthy, isA<bool>());
    });
  });
}

/// 模拟的自定义异常类
class CustomTestException implements Exception {
  final String message;
  final String code;
  
  const CustomTestException(this.message, [this.code = 'CUSTOM_ERROR']);
  
  @override
  String toString() => 'CustomTestException($code): $message';
}

/// 模拟的自定义异常处理器
class CustomExceptionProcessor implements ExceptionProcessor<CustomTestException> {
  @override
  Future<bool> canProcess(CustomTestException exception) async => true;
  
  @override
  Future<ProcessorResult> process(CustomTestException exception, StackTrace? stackTrace) async {
    // 模拟处理过程
    await Future.delayed(Duration(milliseconds: 10));
    
    return ProcessorResult(
      successful: true,
      message: 'Custom exception processed',
      data: {'processed': true, 'code': exception.code},
    );
  }
}

/// 模拟的自定义组件监控器
class CustomComponentMonitor implements ComponentMonitor {
  @override
  String get componentId => 'custom_component';
  
  @override
  ComponentType get componentType => ComponentType.thirdPartyServices;
  
  @override
  bool get isCritical => false;
  
  @override
  double get defaultHealthScore => 0.8;
  
  @override
  Future<HealthCheckResult> performHealthCheck([Duration? timeout]) async {
    // 模拟健康检查过程
    await Future.delayed(Duration(milliseconds: 50));
    
    return const HealthCheckResult(
      componentId: 'custom_component',
      componentType: ComponentType.thirdPartyServices,
      status: HealthStatus.healthy,
      message: 'Custom component is healthy',
      responseTime: Duration(milliseconds: 50),
      timestamp: null, // 将被替换为实际时间戳
      metrics: {'customMetric': 100},
      issues: [],
      recommendations: [],
      isCritical: false,
      healthScore: 0.8,
    );
  }
}