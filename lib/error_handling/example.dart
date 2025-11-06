import 'dart:async';
import 'dart:io';

/// 错误处理和异常恢复系统使用示例
/// 
/// 这个文件展示了如何在实际项目中使用完整的错误处理和异常恢复系统

// 导入错误处理系统
import 'index.dart';

void main() async {
  print('=== 错误处理和异常恢复系统示例 ===\n');
  
  // 1. 初始化整个错误处理系统
  await initializeErrorHandlingSystem();
  
  // 2. 演示各种错误处理场景
  await demonstrateErrorHandling();
  
  // 3. 演示网络错误处理
  await demonstrateNetworkErrorHandling();
  
  // 4. 演示健康检查
  await demonstrateHealthMonitoring();
  
  // 5. 演示崩溃恢复
  await demonstrateCrashRecovery();
  
  print('\n=== 示例完成 ===');
}

/// 初始化错误处理系统
Future<void> initializeErrorHandlingSystem() async {
  print('🔧 初始化错误处理系统...');
  
  try {
    // 初始化整个系统
    await ErrorHandlingSystem.initialize();
    
    // 或者单独初始化各个组件
    await ErrorRecoveryManager().initialize();
    await ExceptionHandler().initialize();
    await CrashRecoverySystem().initialize();
    await NetworkErrorHandler().initialize();
    await ConnectionRetryManager().initialize();
    await HealthCheckSystem().initialize();
    
    print('✅ 错误处理系统初始化完成\n');
  } catch (e) {
    print('❌ 系统初始化失败: $e');
  }
}

/// 演示错误处理功能
Future<void> demonstrateErrorHandling() async {
  print('🔄 演示错误处理功能...\n');
  
  final errorHandler = ExceptionHandler();
  final recoveryManager = ErrorRecoveryManager();
  
  // 示例1: 处理自定义异常
  await handleCustomException(errorHandler, recoveryManager);
  
  // 示例2: 处理网络异常
  await handleNetworkException(errorHandler, recoveryManager);
  
  // 示例3: 处理文件系统异常
  await handleFileSystemException(errorHandler, recoveryManager);
  
  print();
}

/// 演示自定义异常处理
Future<void> handleCustomException(ExceptionHandler errorHandler, ErrorRecoveryManager recoveryManager) async {
  print('📋 场景1: 自定义业务异常');
  
  try {
    // 模拟业务逻辑异常
    throw CustomBusinessException('用户余额不足', 'INSUFFICIENT_FUNDS');
  } catch (error, stackTrace) {
    print('   触发异常: $error');
    
    // 使用异常处理器
    final result = await errorHandler.handleException(
      error,
      stackTrace,
      '用户交易处理',
    );
    
    print('   处理结果: ${result.handled ? '已处理' : '未处理'}');
    print('   处理策略: ${result.strategy}');
    
    // 使用恢复管理器
    final recoveryResult = await recoveryManager.handleError(
      error,
      stackTrace,
      RecoveryStrategy.manualRecovery,
    );
    
    if (recoveryResult?.success == true) {
      print('   恢复结果: ✅ 自动恢复成功');
    } else {
      print('   恢复结果: ❌ 需要手动处理');
    }
  }
  
  print();
}

/// 演示网络异常处理
Future<void> handleNetworkException(ExceptionHandler errorHandler, ErrorRecoveryManager recoveryManager) async {
  print('🌐 场景2: 网络连接异常');
  
  try {
    // 模拟网络连接失败
    throw SocketException('Connection failed to api.example.com:443');
  } catch (error, stackTrace) {
    print('   触发异常: $error');
    
    // 使用恢复管理器进行自动重试
    final recoveryResult = await recoveryManager.handleError(
      error,
      stackTrace,
      RecoveryStrategy.exponentialBackoff,
    );
    
    print('   恢复策略: 指数退避重试');
    if (recoveryResult?.success == true) {
      print('   恢复结果: ✅ 重试成功');
    } else {
      print('   恢复结果: ❌ 重试失败');
    }
  }
  
  print();
}

/// 演示文件系统异常处理
Future<void> handleFileSystemException(ExceptionHandler errorHandler, ErrorRecoveryManager recoveryManager) async {
  print('📁 场景3: 文件系统异常');
  
  try {
    // 模拟文件访问权限错误
    throw PermissionDeniedException('storage', '缺少存储权限');
  } catch (error, stackTrace) {
    print('   触发异常: $error');
    
    // 使用恢复管理器
    final recoveryResult = await recoveryManager.handleError(
      error,
      stackTrace,
      RecoveryStrategy.manualRecovery,
    );
    
    print('   恢复策略: 手动恢复');
    print('   恢复结果: ❌ 需要用户授权');
    print('   建议操作: 请求存储权限');
  }
  
  print();
}

/// 演示网络错误处理
Future<void> demonstrateNetworkErrorHandling() async {
  print('🌐 演示网络错误处理...\n');
  
  final networkHandler = NetworkErrorHandler();
  
  // 添加网络状态监听器
  networkHandler.addStatusListener((oldStatus, newStatus, networkType) {
    print('📡 网络状态变更: ${oldStatus} → ${newStatus} (${networkType})');
  });
  
  // 添加网络错误监听器
  networkHandler.addErrorListener((errorInfo) {
    print('❌ 网络错误: ${errorInfo.type} - ${errorInfo.message}');
  });
  
  // 检查当前网络状态
  print('🔍 当前网络状态: ${networkHandler.currentStatus}');
  print('🔌 网络连接: ${networkHandler.isConnected ? '已连接' : '未连接'}');
  print('📊 网络健康度: ${(networkHandler.networkHealth * 100).toInt()}%');
  
  // 执行连接测试
  print('🔬 执行网络连接测试...');
  final testResult = await networkHandler.testConnection('8.8.8.8', 53);
  
  if (testResult.success) {
    print('   ✅ 连接成功，延迟: ${testResult.latency.inMilliseconds}ms');
  } else {
    print('   ❌ 连接失败: ${testResult.errorMessage}');
  }
  
  // 获取网络连接详情
  final connectionDetails = await networkHandler.connectionDetails;
  if (connectionDetails != null) {
    print('📋 连接详情:');
    print('   类型: ${connectionDetails.type}');
    print('   状态: ${connectionDetails.isConnected ? '已连接' : '未连接'}');
    print('   安全: ${connectionDetails.isSecure ? '是' : '否'}');
  }
  
  print();
}

/// 演示健康检查
Future<void> demonstrateHealthMonitoring() async {
  print('💊 演示健康检查系统...\n');
  
  final healthSystem = HealthCheckSystem();
  await healthSystem.initialize();
  
  // 添加健康状态监听器
  healthSystem.addHealthListener((oldStatus, newStatus) {
    print('🏥 系统健康状态变更: ${oldStatus} → ${newStatus}');
  });
  
  // 添加检查结果监听器
  healthSystem.addCheckListener((result) {
    final statusIcon = getHealthStatusIcon(result.status);
    print('${statusIcon} ${result.componentId}: ${result.status} (${(result.healthScore * 100).toInt()}%)');
  });
  
  // 执行健康检查
  print('🔍 执行系统健康检查...');
  final results = await healthSystem.performHealthCheck();
  
  print('\\n📊 健康检查结果汇总:');
  print('   检查组件数: ${results.length}');
  
  final healthyCount = results.where((r) => r.status == HealthStatus.healthy).length;
  final warningCount = results.where((r) => r.status == HealthStatus.warning).length;
  final errorCount = results.where((r) => r.status == HealthStatus.error).length;
  
  print('   🟢 健康: $healthyCount');
  print('   🟡 警告: $warningCount');
  print('   🔴 错误: $errorCount');
  
  // 获取系统健康报告
  final report = await ErrorHandlingUtils.getSystemHealthReport();
  print('\\n📋 系统健康报告:');
  print('   整体状态: ${report.overallHealth}');
  print('   健康度: ${report.healthPercentage}%');
  print('   需要关注: ${report.requiresAttention ? '是' : '否'}');
  
  if (report.allIssues.isNotEmpty) {
    print('\\n⚠️  发现的问题:');
    for (final issue in report.allIssues.take(5)) {
      print('   - $issue');
    }
  }
  
  if (report.allRecommendations.isNotEmpty) {
    print('\\n💡 建议措施:');
    for (final recommendation in report.allRecommendations.take(5)) {
      print('   - $recommendation');
    }
  }
  
  print();
}

/// 演示崩溃恢复
Future<void> demonstrateCrashRecovery() async {
  print('🔄 演示崩溃恢复系统...\n');
  
  final crashRecovery = CrashRecoverySystem();
  
  // 保存当前状态（模拟）
  print('💾 保存应用状态...');
  final snapshot = await crashRecovery.saveCurrentState('示例保存');
  print('   快照ID: ${snapshot.id}');
  print('   时间戳: ${snapshot.timestamp}');
  print('   状态哈希: ${snapshot.stateHash}');
  
  // 检测崩溃状态
  print('\\n🔍 检测崩溃状态...');
  final detectionResult = await crashRecovery.detectCrash();
  
  if (detectionResult.isCrash) {
    print('   ⚠️  检测到崩溃: ${detectionResult.crashReason}');
    print('   严重程度: ${detectionResult.severity}');
    
    // 尝试恢复
    print('\\n🔧 尝试恢复...');
    final recoveryResult = await crashRecovery.performRecovery(
      const RecoveryOptions(
        restoreAppState: true,
        restoreUserData: true,
        showRecoveryDialog: false, // 示例中不显示对话框
      ),
    );
    
    if (recoveryResult.success) {
      print('   ✅ 恢复成功!');
      print('   恢复的组件: ${recoveryResult.restoredComponents.join(', ')}');
    } else {
      print('   ❌ 恢复失败: ${recoveryResult.message}');
    }
  } else {
    print('   ✅ 正常启动，未检测到崩溃');
  }
  
  // 获取崩溃统计
  final stats = await crashRecovery.getCrashStatistics();
  print('\\n📊 崩溃统计:');
  for (final entry in stats.entries) {
    print('   ${entry.key}: ${entry.value}');
  }
  
  print();
}

/// 获取健康状态图标
String getHealthStatusIcon(HealthStatus status) {
  switch (status) {
    case HealthStatus.healthy:
      return '🟢';
    case HealthStatus.warning:
      return '🟡';
    case HealthStatus.error:
      return '🔴';
    case HealthStatus.unknown:
      return '❓';
    case HealthStatus.checking:
      return '🔍';
    default:
      return '❓';
  }
}

/// 演示重试管理器
Future<void> demonstrateRetryManager() async {
  print('🔄 演示连接重试管理器...\n');
  
  final retryManager = ConnectionRetryManager();
  
  // 添加重试监听器
  retryManager.addRetryListener((context, state, result) {
    final status = getRetryStateIcon(state);
    print('${status} ${context.operationName}: 尝试 ${context.currentAttempt}/${context.metadata['maxAttempts'] ?? '∞'}');
  });
  
  // 模拟重试场景
  int attemptCount = 0;
  final unreliableOperation = () async {
    attemptCount++;
    
    // 前两次失败，第三次成功
    if (attemptCount < 3) {
      throw Exception('Operation failed (attempt $attemptCount)');
    }
    
    return 'Operation succeeded after $attemptCount attempts';
  };
  
  print('🔬 执行不稳定的操作...');
  final result = await retryManager.executeRetry(
    unreliableOperation,
    operationName: '示例重试操作',
    config: const RetryConfig(
      strategy: RetryStrategy.exponentialBackoff,
      maxAttempts: 5,
      initialDelay: Duration(seconds: 1),
      enableJitter: true,
    ),
  );
  
  print('\\n📊 重试结果:');
  print('   成功: ${result.success}');
  print('   尝试次数: ${result.attempts}');
  print('   总耗时: ${result.totalTime}');
  print('   结果: ${result.result ?? result.error?.toString()}');
  
  if (result.attemptDelays.isNotEmpty) {
    print('   重试延迟: ${result.attemptDelays.map((d) => '${d.inMilliseconds}ms').join(', ')}');
  }
}

/// 获取重试状态图标
String getRetryStateIcon(RetryState state) {
  switch (state) {
    case RetryState.retrying:
      return '🔄';
    case RetryState.waiting:
      return '⏳';
    case RetryState.succeeded:
      return '✅';
    case RetryState.failed:
      return '❌';
    case RetryState.timeout:
      return '⏰';
    default:
      return '❓';
  }
}

/// 自定义业务异常类
class CustomBusinessException implements Exception {
  final String message;
  final String code;
  
  const CustomBusinessException(this.message, [this.code = 'BUSINESS_ERROR']);
  
  @override
  String toString() => 'CustomBusinessException($code): $message';
}