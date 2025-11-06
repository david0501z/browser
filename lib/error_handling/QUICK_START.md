# 错误处理和异常恢复系统 - 快速开始指南

## 🚀 快速集成

### 1. 基础集成

最简单的集成方式，只需要几行代码：

```dart
import 'package:your_app/error_handling/index.dart';

void main() async {
  // 一行代码初始化整个错误处理系统
  await ErrorHandlingSystem.initialize();
  
  runApp(MyApp());
}
```

### 2. 在业务代码中使用

```dart
class MyService {
  // 自动处理错误的网络请求
  Future<String?> fetchData() async {
    return await ErrorHandlingUtils.safeExecute(() async {
      final response = await httpClient.get('https://api.example.com/data');
      return response.body;
    });
  }
  
  // 带重试的网络请求
  Future<String?> fetchDataWithRetry() async {
    return await ErrorHandlingUtils.safeExecuteWithRetry(
      () async => await httpClient.get('https://api.example.com/data'),
      operationName: 'Fetch User Data',
    );
  }
}
```

## 🔧 高级配置

### 自定义重试策略

```dart
class MyNetworkService {
  Future<String> fetchData() async {
    final retryManager = ConnectionRetryManager();
    
    return await retryManager.executeRetry(
      () async => await _makeApiCall(),
      operationName: 'User Data Fetch',
      config: RetryConfig(
        strategy: RetryStrategy.exponentialBackoff,
        maxAttempts: 5,
        initialDelay: Duration(seconds: 1),
        enableJitter: true,
        circuitBreakerThreshold: Duration(seconds: 60),
      ),
    ).then((result) {
      if (result.success) {
        return result.result!;
      } else {
        throw result.error ?? Exception('Failed after ${result.attempts} attempts');
      }
    });
  }
}
```

### 健康监控配置

```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late HealthCheckSystem healthSystem;
  
  @override
  void initState() {
    super.initState();
    _initializeHealthMonitoring();
  }
  
  Future<void> _initializeHealthMonitoring() async {
    healthSystem = HealthCheckSystem();
    await healthSystem.initialize();
    
    // 监听健康状态变更
    healthSystem.addHealthListener((oldStatus, newStatus) {
      if (newStatus == HealthStatus.error) {
        _showHealthAlert('系统健康状况恶化');
      }
    });
    
    // 定期检查健康状态
    Timer.periodic(Duration(minutes: 5), (_) {
      _checkSystemHealth();
    });
  }
  
  Future<void> _checkSystemHealth() async {
    final report = await ErrorHandlingUtils.getSystemHealthReport();
    
    if (!report.isHealthy) {
      _showHealthAlert('发现问题: ${report.allIssues.first}');
    }
  }
  
  void _showHealthAlert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('健康提醒: $message')),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HealthStatusWidget(healthSystem: healthSystem),
    );
  }
}
```

### 状态保存和恢复

```dart
class MyAppState extends State<MyApp> {
  late CrashRecoverySystem crashRecovery;
  
  @override
  void initState() {
    super.initState();
    _setupCrashRecovery();
  }
  
  Future<void> _setupCrashRecovery() async {
    crashRecovery = CrashRecoverySystem();
    
    // 检测崩溃并尝试恢复
    final detection = await crashRecovery.detectCrash();
    if (detection.isCrash) {
      _showRecoveryDialog();
    }
    
    // 设置自动状态保存
    Timer.periodic(Duration(minutes: 5), (_) {
      crashRecovery.saveCurrentState('Auto save');
    });
  }
  
  void _showRecoveryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('应用恢复'),
        content: Text('检测到应用异常终止，是否恢复之前的状态？'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              crashRecovery.clearCrashHistory();
            },
            child: Text('重新开始'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await crashRecovery.performRecovery();
            },
            child: Text('恢复状态'),
          ),
        ],
      ),
    );
  }
}
```

## 📊 监控和告警

### 错误监控

```dart
class ErrorMonitoringWidget extends StatefulWidget {
  @override
  _ErrorMonitoringWidgetState createState() => _ErrorMonitoringWidgetState();
}

class _ErrorMonitoringWidgetState extends State<ErrorMonitoringWidget> {
  late ExceptionHandler exceptionHandler;
  late NetworkErrorHandler networkHandler;
  
  @override
  void initState() {
    super.initState();
    _setupErrorMonitoring();
  }
  
  void _setupErrorMonitoring() {
    exceptionHandler = ExceptionHandler();
    exceptionHandler.addGlobalHandler((record) async {
      // 发送错误到远程监控服务
      await _sendErrorToMonitoring(record);
      return true;
    });
    
    networkHandler = NetworkErrorHandler();
    networkHandler.addErrorListener((errorInfo) {
      _handleNetworkError(errorInfo);
    });
  }
  
  Future<void> _sendErrorToMonitoring(ExceptionRecord record) async {
    // 实现错误上报逻辑
    print('Error reported: ${record.toDetailedString()}');
  }
  
  void _handleNetworkError(NetworkErrorInfo errorInfo) {
    if (errorInfo.severity == NetworkErrorSeverity.critical) {
      // 立即告警
      _showCriticalAlert('网络连接异常: ${errorInfo.message}');
    }
  }
  
  void _showCriticalAlert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ExceptionRecord>(
      stream: exceptionHandler.exceptionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ErrorCountWidget(count: snapshot.data!.id.length);
        }
        return SizedBox.shrink();
      },
    );
  }
}
```

## 🛠️ 最佳实践

### 1. 错误分类策略

```dart
class MyErrorHandler {
  void registerCustomErrorTypes() {
    final recoveryManager = ErrorRecoveryManager();
    
    // 业务逻辑错误 - 手动恢复
    recoveryManager.registerRecoveryRule(RecoveryRule(
      errorType: BusinessLogicException,
      strategy: RecoveryStrategy.manualRecovery,
      severity: ErrorSeverity.medium,
    ));
    
    // 网络错误 - 自动重试
    recoveryManager.registerRecoveryRule(RecoveryRule(
      errorType: SocketException,
      strategy: RecoveryStrategy.exponentialBackoff,
      maxRetries: 5,
      severity: ErrorSeverity.high,
    ));
    
    // 权限错误 - 提示用户
    recoveryManager.registerRecoveryRule(RecoveryRule(
      errorType: PermissionDeniedException,
      strategy: RecoveryStrategy.manualRecovery,
      severity: ErrorSeverity.high,
    ));
  }
}
```

### 2. 用户友好的错误处理

```dart
class UserFriendlyErrorHandler {
  void handleErrorWithUserFeedback(Object error, StackTrace? stackTrace) async {
    final recoveryManager = ErrorRecoveryManager();
    final result = await recoveryManager.handleError(error, stackTrace);
    
    if (result == null) return;
    
    switch (result.strategy) {
      case RecoveryStrategy.manualRecovery:
        _showUserDialog('操作失败', '请检查您的设置后重试');
        break;
      case RecoveryStrategy.delayedRetry:
        _showRetryNotification('正在重试...');
        break;
      case RecoveryStrategy.gracefulDegradation:
        _showFeatureDisabledMessage();
        break;
      default:
        _showGenericErrorMessage();
    }
  }
  
  void _showUserDialog(String title, String message) {
    // 显示用户友好的对话框
    print('$title: $message');
  }
  
  void _showRetryNotification(String message) {
    // 显示重试通知
    print('🔄 $message');
  }
  
  void _showFeatureDisabledMessage() {
    // 显示功能降级消息
    print('⚠️  部分功能暂时不可用');
  }
  
  void _showGenericErrorMessage() {
    // 显示通用错误消息
    print('❌ 操作失败，请稍后重试');
  }
}
```

### 3. 性能优化

```dart
class OptimizedErrorHandling {
  void configureForProduction() {
    final healthConfig = HealthCheckConfig(
      checkInterval: Duration(minutes: 10), // 减少检查频率
      timeout: Duration(seconds: 15),       // 缩短超时时间
      enableAlerts: true,                   // 启用告警
    );
    
    final retryConfig = RetryConfig(
      maxAttempts: 3,                       // 减少重试次数
      initialDelay: Duration(seconds: 2),   // 增加初始延迟
      circuitBreakerThreshold: Duration(minutes: 5),
    );
    
    final crashConfig = RecoveryStrategyConfig(
      saveInterval: Duration(minutes: 10),  // 减少保存频率
      maxSnapshots: 5,                      // 减少快照数量
      stateRetentionPeriod: Duration(hours: 12),
    );
    
    // 应用配置
    final healthSystem = HealthCheckSystem();
    healthSystem.updateConfig(healthConfig);
    
    final retryManager = ConnectionRetryManager();
    retryManager.updateDefaultConfig(retryConfig);
    
    final crashRecovery = CrashRecoverySystem();
    crashRecovery.updateConfig(crashConfig);
  }
}
```

## 📱 完整示例项目

创建一个完整的示例：

```dart
import 'package:flutter/material.dart';
import 'error_handling/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化错误处理系统
  await ErrorHandlingSystem.initialize();
  
  runApp(ErrorHandlingDemoApp());
}

class ErrorHandlingDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '错误处理系统演示',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ErrorHandlingDemoScreen(),
    );
  }
}

class ErrorHandlingDemoScreen extends StatefulWidget {
  @override
  _ErrorHandlingDemoScreenState createState() => _ErrorHandlingDemoScreenState();
}

class _ErrorHandlingDemoScreenState extends State<ErrorHandlingDemoScreen> {
  late HealthCheckSystem healthSystem;
  String healthStatus = '检查中...';
  
  @override
  void initState() {
    super.initState();
    _initHealthMonitoring();
  }
  
  void _initHealthMonitoring() async {
    healthSystem = HealthCheckSystem();
    await healthSystem.initialize();
    
    healthSystem.addHealthListener((oldStatus, newStatus) {
      setState(() {
        healthStatus = _getHealthStatusText(newStatus);
      });
    });
    
    // 初始健康检查
    _checkHealth();
  }
  
  void _checkHealth() async {
    final report = await ErrorHandlingUtils.getSystemHealthReport();
    setState(() {
      healthStatus = _getHealthStatusText(report.overallHealth);
    });
  }
  
  String _getHealthStatusText(HealthStatus status) {
    switch (status) {
      case HealthStatus.healthy:
        return '🟢 系统健康';
      case HealthStatus.warning:
        return '🟡 需要关注';
      case HealthStatus.error:
        return '🔴 系统异常';
      default:
        return '❓ 状态未知';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('错误处理系统演示'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _checkHealth,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '系统健康状态:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 20),
            Text(
              healthStatus,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _triggerTestError,
              icon: Icon(Icons.bug_report),
              label: Text('触发测试错误'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showHealthReport,
              icon: Icon(Icons.assessment),
              label: Text('查看详细报告'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _triggerTestError() async {
    try {
      throw Exception('这是一个测试错误');
    } catch (error, stackTrace) {
      await ErrorHandlingUtils.safeExecute(() async {
        // 模拟错误处理
        await Future.delayed(Duration(seconds: 1));
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('错误已被自动处理'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  void _showHealthReport() async {
    final report = await ErrorHandlingUtils.getSystemHealthReport();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('系统健康报告'),
        content: SingleChildScrollView(
          child: Text(report.toString()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('关闭'),
          ),
        ],
      ),
    );
  }
}
```

这个系统提供了完整的错误处理和异常恢复能力，可以大大提高应用的稳定性和用户体验。