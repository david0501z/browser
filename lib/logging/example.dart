import 'dart:async';
import 'package:flutter/material.dart';
import 'index.dart';

/// 日志系统使用示例
class LoggingSystemExample extends StatefulWidget {
  const LoggingSystemExample({Key? key}) : super(key: key);

  @override
  State<LoggingSystemExample> createState() => _LoggingSystemExampleState();
}

class _LoggingSystemExampleState extends State<LoggingSystemExample> {
  @override
  void initState() {
    super.initState();
    _initializeLogging();
  }

  void _initializeLogging() {
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
    
    // 记录一些示例日志
    _generateSampleLogs();
  }

  void _generateSampleLogs() {
    // 生成一些示例日志数据
    for (int i = 0; i < 10; i++) {
      Timer(Duration(milliseconds: i * 100), () {
        logger.info('应用初始化进度: ${(i + 1) * 10}%', 
            source: 'Initialization', 
            tags: ['startup', 'progress'],
            context: {'progress': (i + 1) * 10});
      });
    }
  }

  @override
  void dispose() {
    logAppShutdown();
    LoggingSystem().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日志系统示例'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () => showDebugPage(context),
            tooltip: '打开调试控制台',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(
              '基本日志记录',
              [
                ElevatedButton(
                  onPressed: () => _testBasicLogging,
                  child: const Text('测试基本日志'),
                ),
                ElevatedButton(
                  onPressed: () => _testPerformanceLogging,
                  child: const Text('测试性能日志'),
                ),
                ElevatedButton(
                  onPressed: () => _testErrorLogging,
                  child: const Text('测试错误日志'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              '调试功能',
              [
                ElevatedButton(
                  onPressed: () => _testDebugMethods,
                  child: const Text('测试调试方法'),
                ),
                ElevatedButton(
                  onPressed: () => _testDebugCommands,
                  child: const Text('测试调试命令'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              '性能监控',
              [
                ElevatedButton(
                  onPressed: () => _testPerformanceMonitor,
                  child: const Text('测试性能监控'),
                ),
                ElevatedButton(
                  onPressed: () => _testPerformanceMeasure,
                  child: const Text('测试性能测量'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              '错误收集',
              [
                ElevatedButton(
                  onPressed: () => _testErrorCollection,
                  child: const Text('测试错误收集'),
                ),
                ElevatedButton(
                  onPressed: () => _testCrashReporting,
                  child: const Text('测试崩溃报告'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              '文件管理',
              [
                ElevatedButton(
                  onPressed: () => _testFileManager,
                  child: const Text('测试文件管理'),
                ),
                ElevatedButton(
                  onPressed: () => _testLogExport,
                  child: const Text('测试日志导出'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              '系统信息',
              [
                ElevatedButton(
                  onPressed: () => _showSystemStatus,
                  child: const Text('查看系统状态'),
                ),
                ElevatedButton(
                  onPressed: () => _showDebugPage,
                  child: const Text('打开调试界面'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: children,
            ),
          ],
        ),
      ),
    );
  }

  // 基本日志记录测试
  void _testBasicLogging() {
    logger.verbose('这是一条verbose级别的日志', source: 'BasicTest');
    logger.debug('这是一条debug级别的日志', source: 'BasicTest', tags: ['debug']);
    logger.info('这是一条info级别的日志', source: 'BasicTest', tags: ['info'], context: {'timestamp': DateTime.now().toIso8601String()});
    logger.warning('这是一条warning级别的日志', source: 'BasicTest', tags: ['warning']);
    
    // 记录用户操作
    logUserAction('点击了基本日志测试按钮');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('基本日志记录测试完成')),
    );
  }

  // 性能日志测试
  void _testPerformanceLogging() {
    // 测量同步函数执行时间
    final syncResult = measureAndLog('同步数据处理', () {
      // 模拟数据处理
      var data = List.generate(1000, (i) => i * i);
      return data.length;
    });
    
    // 测量异步函数执行时间
    measureAsyncAndLog('异步数据加载', () async {
      await Future.delayed(const Duration(milliseconds: 200));
      return '数据加载完成';
    }).then((result) {
      logger.info('异步操作结果: $result', source: 'PerformanceTest');
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('性能日志记录测试完成 (同步结果: $syncResult)')),
    );
  }

  // 错误日志测试
  void _testErrorLogging() {
    try {
      // 故意触发一个异常
      throw Exception('这是一个测试异常');
    } catch (e, stack) {
      logger.error('捕获到测试异常', 
          source: 'ErrorTest', 
          exception: e, 
          stackTrace: stack,
          tags: ['test', 'error'],
          context: {'test_case': 'exception_test'});
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('错误日志记录测试完成')),
    );
  }

  // 调试方法测试
  void _testDebugMethods() {
    debugService.enable();
    
    // 模拟方法调用
    _sampleMethod('测试参数1', 42);
    _sampleMethod('测试参数2', 100);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('调试方法测试完成')),
    );
  }

  void _sampleMethod(String param1, int param2) {
    debugService.logMethodCall('sampleMethod', {
      'param1': param1,
      'param2': param2,
    });
    
    // 模拟一些处理
    var result = param1.length * param2;
    debugService.logVariableChange('result', 0, result);
    
    debugService.logMethodReturn('sampleMethod', result);
  }

  // 调试命令测试
  Future<void> _testDebugCommands() async {
    debugService.enable();
    
    try {
      // 执行不同的调试命令
      final helpResult = await debugService.executeCommand('help', []);
      logger.debug('帮助命令结果: $helpResult', source: 'DebugCommandTest');
      
      final perfResult = await debugService.executeCommand('perf', []);
      logger.info('性能命令结果: $perfResult', source: 'DebugCommandTest');
      
    } catch (e) {
      logger.error('调试命令执行失败', exception: e, source: 'DebugCommandTest');
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('调试命令测试完成')),
    );
  }

  // 性能监控测试
  void _testPerformanceMonitor() {
    performanceMonitor.enable();
    
    // 记录各种性能指标
    performanceMonitor.recordResponseTime('API响应', Duration(milliseconds: 150));
    performanceMonitor.recordNetworkLatency('/api/users', Duration(milliseconds: 80));
    performanceMonitor.recordFileOperation('read', 'config.json', Duration(milliseconds: 25));
    
    performanceMonitor.recordCustomMetric('用户满意度', 4.2, 'rating');
    performanceMonitor.recordCustomMetric('系统负载', 0.65, 'percentage');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('性能监控测试完成')),
    );
  }

  // 性能测量测试
  void _testPerformanceMeasure() {
    performanceMonitor.enable();
    
    final measurer = PerformanceMeasurer(performanceMonitor, '示例操作');
    
    // 测量同步操作
    final syncResult = measurer.measure(() {
      // 模拟一些计算
      var sum = 0;
      for (int i = 0; i < 10000; i++) {
        sum += i;
      }
      return sum;
    }, tags: {'operation_type': 'calculation'});
    
    // 测量异步操作
    measurer.measureAsync(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      return '异步操作完成';
    }, tags: {'operation_type': 'async'}).then((result) {
      logger.info('异步测量结果: $result', source: 'PerformanceMeasureTest');
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('性能测量测试完成 (同步结果: $syncResult)')),
    );
  }

  // 错误收集测试
  void _testErrorCollection() {
    errorCollector.enable();
    
    // 记录不同类型的错误
    errorCollector.reportError(
      type: ErrorType.network,
      severity: ErrorSeverity.warning,
      message: '网络连接超时',
      userContext: {'url': 'https://api.example.com', 'timeout': 5000},
    );
    
    errorCollector.reportError(
      type: ErrorType.validation,
      severity: ErrorSeverity.error,
      message: '用户输入验证失败',
      userContext: {'field': 'email', 'value': 'invalid-email'},
    );
    
    // 记录用户操作
    errorCollector.recordUserAction('用户在错误测试页面进行了操作');
    
    // 显示错误统计
    final stats = errorCollector.getErrorStatistics();
    logger.info('错误统计: ${stats.toString()}', source: 'ErrorTest');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('错误收集测试完成')),
    );
  }

  // 崩溃报告测试
  void _testCrashReporting() {
    errorCollector.enable();
    
    try {
      // 模拟一个崩溃
      final random = DateTime.now().millisecondsSinceEpoch;
      if (random % 2 == 0) {
        throw StateError('这是一个测试状态错误');
      } else {
        throw ArgumentError('这是一个测试参数错误');
      }
    } catch (e, stack) {
      errorCollector.recordCrash(e, stack);
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('崩溃报告测试完成')),
    );
  }

  // 文件管理测试
  void _testFileManager() {
    try {
      // 执行文件清理
      LoggingSystem().logFileManager.performCleanup();
      
      // 获取文件统计
      final stats = LoggingSystem().logFileManager.getDirectoryStatistics();
      logger.info('文件统计: ${stats.toString()}', source: 'FileManagerTest');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('文件管理测试完成 (文件数: ${stats['totalFiles']})')),
      );
    } catch (e) {
      logger.error('文件管理测试失败', exception: e, source: 'FileManagerTest');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('文件管理测试失败: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // 日志导出测试
  void _testLogExport() {
    try {
      // 导出JSON格式日志
      final jsonData = logger.exportToJson();
      logger.info('日志导出完成，大小: ${jsonData.length} 字符', source: 'ExportTest');
      
      // 导出CSV格式日志
      final csvData = logger.exportToCsv();
      logger.info('CSV导出完成，大小: ${csvData.length} 字符', source: 'ExportTest');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('日志导出测试完成')),
      );
    } catch (e) {
      logger.error('日志导出失败', exception: e, source: 'ExportTest');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('日志导出失败: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // 显示系统状态
  void _showSystemStatus() {
    final status = LoggingSystem().getSystemStatus();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('系统状态'),
        content: SingleChildScrollView(
          child: SelectableText(status.toString()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  // 显示调试页面
  void _showDebugPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DebugPage(),
      ),
    );
  }
}

/// 示例：集成到主应用
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '日志系统示例',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoggingSystemExample(),
    );
  }
}

void main() {
  // 在应用启动时初始化日志系统
  runApp(const MyApp());
}