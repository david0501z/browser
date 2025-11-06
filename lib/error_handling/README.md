# 错误处理和异常恢复系统

一个全面的Flutter错误处理和异常恢复系统，提供自动恢复、错误分类、健康监控等功能。

## 特性

### 🚀 核心功能
- **错误恢复管理器** - 智能错误分类和恢复策略
- **异常处理器** - 全局异常捕获和处理
- **崩溃恢复系统** - 应用状态保存和恢复
- **网络错误处理器** - 网络连接监控和恢复
- **连接重试管理器** - 智能重试和断路器模式
- **健康检查系统** - 组件健康状态监控

### 🔧 自动恢复特性
- 智能错误分类和优先级处理
- 多种重试策略（固定间隔、线性退避、指数退避、抖动等）
- 断路器模式防止级联失败
- 自适应重试参数调整
- 状态保存和自动恢复

### 📊 监控和报告
- 实时健康状态监控
- 详细的错误统计和分析
- 性能指标收集
- 系统健康报告生成
- 历史记录和趋势分析

### 🎯 用户体验优化
- 静默恢复，不中断用户体验
- 渐进式降级处理
- 友好的错误提示
- 智能重试通知
- 自适应网络处理

## 文件结构

```
lib/error_handling/
├── index.dart                    # 主入口和工具类
├── error_recovery_manager.dart   # 错误恢复管理器
├── exception_handler.dart        # 异常处理器
├── crash_recovery_system.dart    # 崩溃恢复系统
├── network_error_handler.dart    # 网络错误处理器
├── connection_retry_manager.dart # 连接重试管理器
├── health_check_system.dart      # 健康检查系统
└── README.md                     # 使用说明
```

## 快速开始

### 1. 初始化系统

```dart
import 'package:your_app/error_handling/index.dart';

void main() async {
  // 初始化整个错误处理系统
  await ErrorHandlingSystem.initialize();
  
  // 或者单独初始化各个组件
  await ErrorRecoveryManager().initialize();
  await ExceptionHandler().initialize();
  await CrashRecoverySystem().initialize();
  await NetworkErrorHandler().initialize();
  await ConnectionRetryManager().initialize();
  await HealthCheckSystem().initialize();
  
  runApp(MyApp());
}
```

### 2. 快速使用工具类

```dart
import 'package:your_app/error_handling/index.dart';

class MyService {
  // 安全的操作执行，自动处理错误
  Future<String?> fetchData() async {
    return await ErrorHandlingUtils.safeExecute(() async {
      // 你的业务逻辑
      return await apiClient.fetchData();
    });
  }
  
  // 带重试的网络操作
  Future<String?> fetchDataWithRetry() async {
    return await ErrorHandlingUtils.safeExecuteWithRetry(
      () async => await apiClient.fetchData(),
      operationName: 'Fetch Data',
    );
  }
  
  // 网络操作的安全包装
  Future<String?> fetchFromNetwork() async {
    return await ErrorHandlingUtils.safeNetworkOperation(() async {
      return await httpClient.get('https://api.example.com/data');
    });
  }
  
  // 检查系统健康状态
  Future<void> checkSystemHealth() async {
    final isHealthy = await ErrorHandlingUtils.isSystemHealthy();
    if (!isHealthy) {
      final report = await ErrorHandlingUtils.getSystemHealthReport();
      print('System Health Issues: ${report.allIssues}');
    }
  }
}
```

## 详细使用指南

### 错误恢复管理器

```dart
final recoveryManager = ErrorRecoveryManager();

// 注册自定义恢复规则
recoveryManager.registerRecoveryRule(RecoveryRule(
  errorType: MyCustomException,
  strategy: RecoveryStrategy.exponentialBackoff,
  maxRetries: 5,
  retryDelay: Duration(seconds: 2),
  severity: ErrorSeverity.high,
));

// 手动处理错误
try {
  await riskyOperation();
} catch (error, stackTrace) {
  final result = await recoveryManager.handleError(error, stackTrace);
  if (result?.success == true) {
    print('Error recovered automatically');
  } else {
    // 处理恢复失败的情况
  }
}
```

### 异常处理器

```dart
final exceptionHandler = ExceptionHandler();

// 添加自定义异常处理器
exceptionHandler.registerExceptionProcessor<MyException>([
  MyCustomExceptionProcessor(),
]);

// 全局异常处理
exceptionHandler.addGlobalHandler((record) async {
  // 记录异常到远程服务
  await logService.recordError(record);
  return true; // 表示已处理，阻止应用崩溃
});
```

### 连接重试管理器

```dart
final retryManager = ConnectionRetryManager();

class NetworkService {
  Future<String> fetchData() async {
    final result = await retryManager.executeRetry(
      () async => await httpClient.get('https://api.example.com/data'),
      operationName: 'Fetch Data',
      config: RetryConfig(
        strategy: RetryStrategy.exponentialBackoff,
        maxAttempts: 5,
        initialDelay: Duration(seconds: 1),
        enableJitter: true,
      ),
    );
    
    if (result.success) {
      return result.result!;
    } else {
      throw result.error ?? Exception('Failed after ${result.attempts} attempts');
    }
  }
}
```

### 健康检查系统

```dart
final healthSystem = HealthCheckSystem();
await healthSystem.initialize();

// 添加自定义组件监控器
healthSystem.registerMonitor(MyCustomMonitor());

// 监听健康状态变更
healthSystem.addHealthListener((oldStatus, newStatus) {
  if (newStatus == HealthStatus.error) {
    // 系统健康状况恶化，可以发送通知
    notificationService.sendAlert('System health degraded');
  }
});

// 执行健康检查
final results = await healthSystem.performHealthCheck();
for (final result in results) {
  print('${result.componentId}: ${result.status} (${result.healthScore})');
}
```

### 网络错误处理器

```dart
final networkHandler = NetworkErrorHandler();

// 监听网络状态变更
networkHandler.addStatusListener((oldStatus, newStatus, type) {
  print('Network status changed: $oldStatus -> $newStatus');
});

// 处理网络错误
try {
  await httpClient.get('https://api.example.com/data');
} catch (error) {
  await networkHandler.handleNetworkError(
    error,
    null, // stackTrace
    'api.example.com',
    443,
    'https',
  );
}
```

### 崩溃恢复系统

```dart
final crashRecovery = CrashRecoverySystem();
await crashRecovery.initialize();

// 检测崩溃并尝试恢复
final detectionResult = await crashRecovery.detectCrash();
if (detectionResult.isCrash) {
  final recoveryResult = await crashRecovery.performRecovery(
    RecoveryOptions(
      restoreAppState: true,
      restoreUserData: true,
      showRecoveryDialog: true,
    ),
  );
  
  if (recoveryResult.success) {
    print('App state recovered successfully');
  }
}
```

## 配置选项

### 错误恢复配置

```dart
final recoveryConfig = RecoveryStrategyConfig(
  enableAutoSave: true,
  saveInterval: Duration(minutes: 5),
  maxSnapshots: 10,
  enableStateRecovery: true,
  enableDataRecovery: true,
  enablePreferenceRecovery: true,
  stateRetentionPeriod: Duration(hours: 24),
);
```

### 重试配置

```dart
final retryConfig = RetryConfig(
  strategy: RetryStrategy.exponentialBackoff,
  maxAttempts: 3,
  initialDelay: Duration(seconds: 1),
  maxDelay: Duration(seconds: 60),
  backoffMultiplier: 2.0,
  enableJitter: true,
  jitterFactor: 0.1,
  timeout: Duration(seconds: 30),
  circuitBreakerThreshold: Duration(seconds: 60),
);
```

### 健康检查配置

```dart
final healthConfig = HealthCheckConfig(
  checkInterval: Duration(minutes: 5),
  timeout: Duration(seconds: 30),
  enableAutomaticCheck: true,
  enableAlerts: true,
  criticalComponents: [
    ComponentType.applicationCore,
    ComponentType.networkConnection,
    ComponentType.dataStorage,
  ],
  healthThreshold: 0.8,
);
```

## 最佳实践

### 1. 错误分类和策略选择

- **网络错误**: 使用指数退避重试策略
- **权限错误**: 使用手动恢复策略
- **内存错误**: 使用降级处理策略
- **崩溃错误**: 使用重启应用策略

### 2. 重试策略选择

- **固定间隔**: 适用于简单的重试场景
- **指数退避**: 适用于网络不稳定场景
- **抖动退避**: 适用于高并发场景
- **自适应重试**: 适用于动态网络环境

### 3. 健康监控设置

- 关键组件使用较短检查间隔
- 非关键组件使用较长检查间隔
- 设置合理的健康阈值
- 启用自动告警功能

### 4. 用户体验优化

- 静默处理低严重性错误
- 显示有意义的错误消息
- 提供手动恢复选项
- 记录错误分析数据

## 性能考虑

- 异步错误处理，不阻塞主线程
- 限制历史记录大小
- 使用连接池减少资源消耗
- 智能降级减少计算开销

## 依赖项

- `shared_preferences`: 状态持久化
- `connectivity_plus`: 网络连接检测
- `flutter/foundation`: Flutter核心功能

## 注意事项

1. 在应用启动时尽早初始化错误处理系统
2. 定期清理历史记录避免内存泄漏
3. 监控错误处理系统的性能影响
4. 根据应用特点调整配置参数
5. 在生产环境中禁用调试日志

## 扩展功能

系统支持自定义扩展：

- 自定义异常处理器
- 自定义组件监控器
- 自定义恢复策略
- 自定义告警机制
- 自定义日志系统

## 故障排除

### 常见问题

1. **重试次数过多**: 检查网络连接和服务器状态
2. **内存泄漏**: 定期清理历史记录和监听器
3. **性能下降**: 调整检查间隔和超时时间
4. **误报**: 调整健康检查阈值和策略

### 调试技巧

- 启用详细日志记录
- 使用健康检查报告分析问题
- 监控错误统计和趋势
- 检查网络连接状态

## 贡献

欢迎提交Pull Request和Issue来改进这个系统。

## 许可证

MIT License