# Flutter 日志和调试系统

一个完整的Flutter应用日志记录、调试和监控解决方案。

## 功能特性

### 🔍 核心日志功能
- **多级别日志记录**: Verbose, Debug, Info, Warning, Error, Critical
- **灵活日志筛选**: 按级别、来源、标签过滤
- **多种输出方式**: 控制台、文件、内存、网络
- **多种日志格式**: 默认、简洁、JSON、彩色
- **日志统计**: 级别分布、来源统计、标签使用情况

### 🛠️ 调试工具
- **调试模式**: 详细的调试信息和状态监控
- **命令执行**: 交互式调试命令
- **方法跟踪**: 自动记录方法调用和执行时间
- **变量监控**: 记录变量值变化

### ⚡ 性能监控
- **实时监控**: CPU、内存、帧率监控
- **性能指标**: 响应时间、网络延迟、文件操作时间
- **趋势分析**: 性能趋势和统计分析
- **阈值警告**: 自动性能警告

### 🐛 错误处理
- **自动错误捕获**: Flutter框架错误和平台错误
- **错误分类**: 按类型和严重程度分类
- **崩溃收集**: 自动崩溃信息收集
- **错误过滤**: 可配置的错误过滤规则

### 📁 文件管理
- **日志文件管理**: 自动文件轮转和清理
- **压缩支持**: 旧日志文件自动压缩
- **搜索功能**: 全文搜索日志内容
- **导出功能**: JSON、CSV格式导出

### 🎨 调试界面
- **实时日志显示**: 可视化日志监控
- **性能仪表盘**: 实时性能数据展示
- **错误浏览器**: 错误信息和崩溃详情
- **系统信息**: 应用和系统状态查看

## 快速开始

### 1. 基本初始化

```dart
import 'package:your_app/logging/index.dart';

// 在应用启动时初始化
void main() {
  // 初始化日志系统
  initLogging(
    enableDebug: true,
    enablePerformance: true,
    enableErrorCollection: true,
    logDirectory: 'logs',
    minimumLogLevel: LogLevel.debug,
    addConsoleSink: true,
    addFileSink: true,
  );
  
  // 记录应用启动
  logAppStartup();
  
  runApp(MyApp());
}
```

### 2. 基本日志记录

```dart
// 记录不同级别的日志
logger.info('应用启动完成', source: 'MyApp', tags: ['startup']);
logger.debug('用户点击了按钮', source: 'ButtonHandler', tags: ['ui', 'user_action']);
logger.warning('配置文件中缺少必要参数', source: 'ConfigLoader', context: {'param': 'api_key'});
logger.error('网络请求失败', source: 'ApiClient', exception: e, stackTrace: stack);
logger.critical('数据库连接丢失', source: 'Database', tags: ['critical', 'database']);

// 记录用户操作
logUserAction('点击登录按钮', {'screen': 'login', 'button': 'login'});

// 性能测量
final result = measureAndLog('数据加载', () {
  return fetchDataFromApi();
});

final userData = await measureAsyncAndLog('用户数据获取', () async {
  return await getUserData(userId);
});
```

### 3. 调试模式使用

```dart
// 启用调试模式
debugService.enable();

// 记录方法调用
void myFunction() {
  debugService.logMethodCall('myFunction', {'param1': 'value1'});
  
  // 方法逻辑
  try {
    // 业务逻辑
    debugService.logMethodReturn('myFunction', 'success');
  } catch (e) {
    debugService.logMethodReturn('myFunction', 'failed');
    rethrow;
  }
}

// 执行调试命令
final result = await debugService.executeCommand('memory', []);
print('内存信息: $result');
```

### 4. 性能监控

```dart
// 启用性能监控
performanceMonitor.enable();

// 记录响应时间
performanceMonitor.recordResponseTime('API调用', Duration(milliseconds: 250));

// 记录网络延迟
performanceMonitor.recordNetworkLatency('/api/users', Duration(milliseconds: 120));

// 记录文件操作时间
performanceMonitor.recordFileOperation('read', 'data.json', Duration(milliseconds: 50));

// 记录自定义指标
performanceMonitor.recordCustomMetric(
  '用户登录成功率', 
  0.95, 
  '%',
  tags: {'metric_type': 'business'},
);

// 使用性能测量器
final measurer = PerformanceMeasurer(performanceMonitor, '数据处理');
final result = measurer.measure(() => processData());
```

### 5. 错误收集

```dart
// 启用错误收集
errorCollector.enable();

// 手动记录错误
errorCollector.reportError(
  type: ErrorType.network,
  severity: ErrorSeverity.warning,
  message: '网络连接超时',
  userContext: {'url': 'https://api.example.com', 'timeout': 5000},
);

// 记录用户操作历史
errorCollector.recordUserAction('用户在设置页面修改了密码');

// 获取错误统计
final stats = errorCollector.getErrorStatistics();
print('总错误数: ${stats['total_errors']}');
print('严重错误数: ${stats['total_crashes']}');

// 按类型获取错误
final networkErrors = errorCollector.getErrorReportsByType(ErrorType.network);
```

### 6. 显示调试界面

```dart
// 在应用中添加调试页面入口
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('我的应用'),
          actions: [
            // 添加调试按钮
            IconButton(
              icon: Icon(Icons.bug_report),
              onPressed: () => showDebugPage(context),
            ),
          ],
        ),
        body: MyHomePage(),
      ),
    );
  }
}
```

### 7. 自定义配置

```dart
// 自定义日志配置
logger.setFilter(LogFilter(
  minimumLevel: LogLevel.warning,
  showTimestamp: true,
  showThreadInfo: true,
  showStackTrace: true,
));

// 自定义日志格式化器
logger.setFormatter(ColoredLogFormatter());

// 添加自定义输出器
logger.addSink(MemorySink(maxEntries: 500));

// 自定义文件输出器
final rollingSink = RollingFileSink(
  directoryPath: 'logs',
  fileNamePattern: 'app_%d{yyyy-MM-dd-HH}.log',
  maxFileSize: 5 * 1024 * 1024, // 5MB
  maxFiles: 24, // 保留24个文件
);
logger.addSink(rollingSink);
```

## 高级用法

### 1. 日志文件管理

```dart
// 配置文件管理器
final fileManager = LogFileManager(LogFileManagerConfig(
  logDirectory: 'logs',
  maxFileSize: 10 * 1024 * 1024, // 10MB
  maxFileCount: 50,
  maxRetentionDays: 30,
  enableCompression: true,
  cleanupInterval: Duration(hours: 1),
));

// 执行清理
await fileManager.performCleanup();

// 导出指定日期范围的日志
final start = DateTime.now().subtract(Duration(days: 7));
final end = DateTime.now();
final logs = await fileManager.exportLogs(start, end);

// 搜索日志内容
final results = await fileManager.searchInLogs('error', start: start);

// 获取目录统计
final stats = fileManager.getDirectoryStatistics();
```

### 2. 性能监控自定义

```dart
// 自定义性能监控配置
final config = PerformanceConfig(
  enabled: true,
  monitorInterval: Duration(seconds: 2),
  maxRecords: 2000,
  monitorCpu: true,
  monitorMemory: true,
  monitorFrameRate: true,
  warningThreshold: Duration(milliseconds: 100),
  criticalThreshold: Duration(milliseconds: 500),
);

final monitor = PerformanceMonitor(config: config);

// 获取性能统计
final memoryStats = monitor.statistics.getStatistics(MetricType.memoryUsage);
print('平均内存使用: ${memoryStats['avg']} MB');

// 获取指定时间范围的指标
final metrics = monitor.getMetricsInTimeRange(start, end);
```

### 3. 错误报告自定义

```dart
// 自定义错误收集配置
final config = ErrorCollectionConfig(
  enabled: true,
  autoCaptureCrashes: true,
  maxErrorReports: 200,
  maxCrashInfos: 20,
  recordUserContext: true,
  collectSystemInfo: true,
  enableFiltering: true,
  filteredTypes: {ErrorType.validation},
  filteredKeywords: {'test', 'debug'},
);

final collector = ErrorCollector(config: config);

// 获取错误统计信息
final stats = collector.getErrorStatistics();
final typeDistribution = stats['type_distribution'];
final severityDistribution = stats['severity_distribution'];

// 导出错误报告
final report = collector.exportErrorReports();
```

## API 参考

### Logger

核心日志记录器，支持多级别日志记录和多种输出方式。

主要方法：
- `verbose()`, `debug()`, `info()`, `warning()`, `error()`, `critical()`: 记录不同级别的日志
- `measureExecution()`, `measureExecutionSync()`: 测量函数执行时间
- `addSink()`, `removeSink()`: 管理输出器
- `setFilter()`, `setFormatter()`: 配置日志筛选和格式化
- `exportToJson()`, `exportToCsv()`: 导出日志数据

### DebugService

调试服务和工具提供器。

主要方法：
- `enable()`, `disable()`, `toggle()`: 管理调试模式
- `executeCommand()`: 执行调试命令
- `logMethodCall()`, `logMethodReturn()`: 记录方法调用
- `logVariableChange()`: 记录变量变化

### PerformanceMonitor

性能监控和统计工具。

主要方法：
- `enable()`, `disable()`, `toggle()`: 管理监控状态
- `recordResponseTime()`, `recordNetworkLatency()`, `recordFileOperation()`: 记录性能指标
- `recordCustomMetric()`: 记录自定义指标
- `exportPerformanceData()`: 导出性能数据

### ErrorCollector

错误收集和崩溃报告工具。

主要方法：
- `enable()`, `disable()`: 管理收集状态
- `reportError()`: 手动记录错误
- `recordCrash()`: 记录崩溃信息
- `recordUserAction()`: 记录用户操作
- `getErrorStatistics()`: 获取错误统计

### DebugPage

完整的调试界面，提供实时的日志监控和系统信息查看。

## 最佳实践

### 1. 日志记录规范

```dart
// ✅ 好的做法：包含上下文信息
logger.info('用户登录成功', 
    source: 'AuthService',
    tags: ['auth', 'user_action'],
    context: {'user_id': userId, 'login_time': loginTime});

// ❌ 避免：信息过少
logger.info('登录成功');
```

### 2. 性能监控

```dart
// ✅ 好的做法：测量关键操作
final result = measureAsyncAndLog('用户数据加载', () async {
  return await fetchUserData(userId);
});

// ❌ 避免：过于频繁的监控
for (int i = 0; i < 1000; i++) {
  performanceMonitor.recordCustomMetric('loop', i.toDouble(), 'count');
}
```

### 3. 错误处理

```dart
// ✅ 好的做法：包含错误上下文
try {
  await apiCall();
} catch (e, stack) {
  errorCollector.reportError(
    type: ErrorType.network,
    severity: ErrorSeverity.error,
    message: 'API调用失败: ${e.toString()}',
    exception: e,
    stackTrace: stack,
    userContext: {'endpoint': '/api/users', 'method': 'GET'},
  );
  rethrow;
}
```

### 4. 调试信息

```dart
// ✅ 好的做法：记录关键状态变化
void updateUserProfile(Map<String, dynamic> updates) {
  debugService.logMethodCall('updateUserProfile', {'updates_count': updates.length});
  
  final oldProfile = {...currentProfile};
  applyUpdates(updates);
  
  debugService.logVariableChange('userProfile', oldProfile, currentProfile);
  debugService.logMethodReturn('updateUserProfile', 'success');
}
```

## 配置建议

### 开发环境
```dart
initLogging(
  enableDebug: true,
  enablePerformance: true,
  enableErrorCollection: true,
  logDirectory: 'logs',
  minimumLogLevel: LogLevel.debug,
  addConsoleSink: true,
  addFileSink: true,
);
```

### 生产环境
```dart
initLogging(
  enableDebug: false,
  enablePerformance: true,
  enableErrorCollection: true,
  logDirectory: 'logs',
  minimumLogLevel: LogLevel.warning,
  addConsoleSink: false,
  addFileSink: true,
);
```

## 故障排除

### 1. 日志不显示
- 检查日志级别设置
- 确认输出器已正确添加
- 验证筛选器配置

### 2. 性能数据不准确
- 确保性能监控已启用
- 检查监控间隔设置
- 验证数据收集配置

### 3. 错误未被捕获
- 确认错误收集已启用
- 检查错误过滤规则
- 验证Flutter错误处理器设置

## 许可证

MIT License