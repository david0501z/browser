import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'logger.dart';
import 'log_level.dart';
import 'log_entry.dart';
import 'performance_monitor.dart';
import 'error_reporter.dart';
import 'debug_service.dart';
import 'log_file_manager.dart';

/// 调试页面主界面
class DebugPage extends StatefulWidget {
  const DebugPage({Key? key}) : super(key: key);

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Logger _logger = Logger();
  final DebugService _debugService = DebugService();
  final PerformanceMonitor _performanceMonitor = PerformanceMonitor();
  final ErrorCollector _errorCollector = ErrorCollector();
  final LogFileManager _logFileManager = LogFileManager(
    LogFileManagerConfig(logDirectory: 'logs')
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _initializeServices();
  }

  void _initializeServices() {
    _debugService.enable();
    _performanceMonitor.enable();
    _errorCollector.enable();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _debugService.dispose();
    _performanceMonitor.dispose();
    _errorCollector.dispose();
    _logFileManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('调试控制台'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.logs), text: '日志'),
            Tab(icon: Icon(Icons.speed), text: '性能'),
            Tab(icon: Icon(Icons.bug_report), text: '错误'),
            Tab(icon: Icon(Icons.memory), text: '系统'),
            Tab(icon: Icon(Icons.storage), text: '文件'),
            Tab(icon: Icon(Icons.settings), text: '设置'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLogTab(),
          _buildPerformanceTab(),
          _buildErrorTab(),
          _buildSystemTab(),
          _buildFileTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  /// 日志标签页
  Widget _buildLogTab() {
    return LogConsoleWidget(logger: _logger);
  }

  /// 性能监控标签页
  Widget _buildPerformanceTab() {
    return PerformanceMonitorWidget(monitor: _performanceMonitor);
  }

  /// 错误监控标签页
  Widget _buildErrorTab() {
    return ErrorMonitorWidget(collector: _errorCollector);
  }

  /// 系统信息标签页
  Widget _buildSystemTab() {
    return SystemInfoWidget(debugService: _debugService);
  }

  /// 文件管理标签页
  Widget _buildFileTab() {
    return FileManagerWidget(manager: _logFileManager);
  }

  /// 设置标签页
  Widget _buildSettingsTab() {
    return DebugSettingsWidget(
      debugService: _debugService,
      performanceMonitor: _performanceMonitor,
      errorCollector: _errorCollector,
    );
  }
}

/// 日志控制台组件
class LogConsoleWidget extends StatefulWidget {
  final Logger logger;

  const LogConsoleWidget({Key? key, required this.logger}) : super(key: key);

  @override
  State<LogConsoleWidget> createState() => _LogConsoleWidgetState();
}

class _LogConsoleWidgetState extends State<LogConsoleWidget> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  LogLevel _selectedLevel = LogLevel.verbose;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    widget.logger.setDebugMode(true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildControls(),
        Expanded(
          child: _buildLogList(),
        ),
        _buildLogInput(),
      ],
    );
  }

  /// 构建控制面板
  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // 级别筛选
          DropdownButton<LogLevel>(
            value: _selectedLevel,
            items: LogLevel.allValues.map((level) =>
              DropdownMenuItem<LogLevel>(
                value: level,
                child: Text(level.name),
              )
            ).toList(),
            onChanged: (level) {
              if (level != null) {
                setState(() {
                  _selectedLevel = level;
                });
              }
            },
          ),
          const SizedBox(width: 16),
          // 搜索框
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: '搜索日志...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          // 清空按钮
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              widget.logger.clearMemory();
              setState(() {});
            },
          ),
          // 导出按钮
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportLogs,
          ),
        ],
      ),
    );
  }

  /// 构建日志列表
  Widget _buildLogList() {
    return StreamBuilder<LogEntry>(
      stream: widget.logger.logStream,
      builder: (context, snapshot) {
        final logs = _getFilteredLogs();
        
        return ListView.builder(
          controller: _scrollController,
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            return _buildLogItem(log);
          },
        );
      },
    );
  }

  /// 获取筛选后的日志
  List<LogEntry> _getFilteredLogs() {
    var logs = widget.logger.logEntries;
    
    // 级别筛选
    logs = logs.where((log) => 
        log.level.value >= _selectedLevel.value;
    ).toList();
    
    // 搜索筛选
    if (_searchQuery.isNotEmpty) {
      logs = logs.where((log) => 
          log.message.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          log.source.toLowerCase().contains(_searchQuery.toLowerCase()) ||
log.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase());
      ).toList();
    }
    
    return logs.reversed.toList(); // 最新的在前
  }

  /// 构建单个日志项
  Widget _buildLogItem(LogEntry log) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
color: Color(int.parse(log.level.colorCode.replaceAll('#', '0xFF')),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              log.level.name[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          log.message,
          style: const TextStyle(fontSize: 12),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '[${log.source}] ${log.timestamp.toIso8601String()}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            if (log.tags.isNotEmpty)
              Wrap(
                spacing: 4,
                children: log.tags.map((tag) => 
                  Chip(
                    label: Text(tag, style: const TextStyle(fontSize: 8)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )
                ).toList(),
              ),
          ],
        ),
        onTap: () => _showLogDetail(log),
      ),
    );
  }

  /// 显示日志详情
  void _showLogDetail(LogEntry log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('日志详情 - ${log.level.name}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('消息: ${log.message}'),
              Text('来源: ${log.source}'),
              Text('时间: ${log.timestamp.toIso8601String()}'),
              Text('标签: ${log.tags.join(', ')}'),
              if (log.exception != null) Text('异常: ${log.exception}'),
              if (log.context != null) Text('上下文: ${log.context}'),
              if (log.stackTrace != null);
                Text('栈跟踪: ${log.stackTrace!.join('\n')}'),
            ],
          ),
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

  /// 构建日志输入
  Widget _buildLogInput() {
    final TextEditingController controller = TextEditingController();
    
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '输入测试日志消息...',
              ),
              onSubmitted: (message) {
                if (message.isNotEmpty) {
                  widget.logger.info(message, source: 'DebugUI');
                  controller.clear();
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                widget.logger.info(controller.text, source: 'DebugUI');
                controller.clear();
              }
            },
            child: const Text('发送'),
          ),
        ],
      ),
    );
  }

  /// 导出日志
  void _exportLogs() {
    try {
      final jsonData = widget.logger.exportToJson();
      final now = DateTime.now();
      final filename = 'logs_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}.json';
      
      // 在实际应用中，这里应该保存到文件或分享
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('日志已准备导出到: $filename')),
      );
      
      // 显示导出的JSON内容
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('日志导出'),
          content: SingleChildScrollView(
            child: SelectableText(jsonData),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('关闭'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导出失败: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

/// 性能监控组件
class PerformanceMonitorWidget extends StatefulWidget {
  final PerformanceMonitor monitor;

  const PerformanceMonitorWidget({Key? key, required this.monitor}) : super(key: key);

  @override
  State<PerformanceMonitorWidget> createState() => _PerformanceMonitorWidgetState();
}

class _PerformanceMonitorWidgetState extends State<PerformanceMonitorWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PerformanceStatistics>(
      stream: widget.monitor.statisticsStream,
      builder: (context, snapshot) {
        final stats = widget.monitor.statistics;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('性能统计'),
              _buildPerformanceCard(stats),
              const SizedBox(height: 16),
              _buildSectionTitle('实时指标'),
              _buildRealtimeMetrics(),
              const SizedBox(height: 16),
              _buildSectionTitle('性能测试'),
              _buildPerformanceTests(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildPerformanceCard(PerformanceStatistics stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('内存使用'),
            const SizedBox(height: 8),
            Text('堆内存: ${stats.getStatistics(MetricType.memoryUsage)['avg']?.toStringAsFixed(2) ?? 'N/A'} MB'),
            Text('总内存: ${stats.getStatistics(MetricType.memoryUsage)['max']?.toStringAsFixed(2) ?? 'N/A'} MB'),
            const SizedBox(height: 16),
            const Text('CPU使用率'),
            const SizedBox(height: 8),
            Text('平均: ${stats.getStatistics(MetricType.cpuUsage)['avg']?.toStringAsFixed(1) ?? 'N/A'}%'),
            Text('峰值: ${stats.getStatistics(MetricType.cpuUsage)['max']?.toStringAsFixed(1) ?? 'N/A'}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildRealtimeMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMetricRow('帧率', '60', 'fps'),
            _buildMetricRow('响应时间', '45', 'ms'),
            _buildMetricRow('内存使用', '52', 'MB'),
            _buildMetricRow('CPU使用', '23', '%'),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('$value $unit'),
        ],
      ),
    );
  }

  Widget _buildPerformanceTests() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _testMemoryUsage,
                child: const Text('内存测试'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: _testResponseTime,
                child: const Text('响应时间测试'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _testNetworkLatency,
                child: const Text('网络延迟测试'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: _clearMetrics,
                child: const Text('清空指标'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _testMemoryUsage() {
    final size = 10 * 1024 * 1024; // 10MB;
    final data = List<int>.filled(size, 1);
    widget.monitor.recordCustomMetric('Memory Test', data.length.toDouble(), 'bytes');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('内存测试完成')),
    );
  }

  void _testResponseTime() {
    final stopwatch = Stopwatch()..start();
    
    // 模拟一些计算
    for (int i = 0; i < 1000000; i++) {
      var result = i * i;
    }
    
    stopwatch.stop();
    widget.monitor.recordResponseTime('Response Time Test', stopwatch.elapsed);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('响应时间测试完成: ${stopwatch.elapsedMilliseconds}ms')),
    );
  }

  void _testNetworkLatency() {
    final stopwatch = Stopwatch()..start();
    
    // 模拟网络请求
    Future.delayed(const Duration(milliseconds: 100), () {
      stopwatch.stop();
      widget.monitor.recordNetworkLatency('test-endpoint', stopwatch.elapsed);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('网络延迟测试完成: ${stopwatch.elapsedMilliseconds}ms')),
      );
    });
  }

  void _clearMetrics() {
    widget.monitor.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('性能指标已清空')),
    );
  }
}

/// 错误监控组件
class ErrorMonitorWidget extends StatefulWidget {
  final ErrorCollector collector;

  const ErrorMonitorWidget({Key? key, required this.collector}) : super(key: key);

  @override
  State<ErrorMonitorWidget> createState() => _ErrorMonitorWidgetState();
}

class _ErrorMonitorWidgetState extends State<ErrorMonitorWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ErrorReport>(
      stream: widget.collector.errorStream,
      builder: (context, snapshot) {
        final errors = widget.collector.getErrorReports();
        final statistics = widget.collector.getErrorStatistics();
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('错误统计'),
              _buildStatisticsCard(statistics),
              const SizedBox(height: 16),
              _buildSectionTitle('最近错误'),
              _buildErrorsList(errors),
              const SizedBox(height: 16),
              _buildErrorActions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildStatisticsCard(Map<String, dynamic> statistics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('总错误', statistics['total_errors']?.toString() ?? '0'),
                _buildStatItem('严重错误', statistics['total_crashes']?.toString() ?? '0'),
              ],
            ),
            const SizedBox(height: 16),
            if (statistics['severity_distribution'] != null);
              Text('严重程度分布: ${statistics['severity_distribution']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
        Text(label),
      ],
    );
  }

  Widget _buildErrorsList(List<ErrorReport> errors) {
    if (errors.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('暂无错误'),
        ),
      );
    }

    return Card(
      child: Column(
        children: errors.take(10).map((error) => 
          ListTile(
            leading: _getErrorIcon(error.severity),
            title: Text(error.message, maxLines: 2),
            subtitle: Text('${error.type.name} - ${error.timestamp.toIso8601String()}'),
            onTap: () => _showErrorDetail(error),
          )
        ).toList(),
      ),
    );
  }

  Widget _getErrorIcon(ErrorSeverity severity) {
    IconData icon;
    Color color;
    
    switch (severity) {
      case ErrorSeverity.info:
        icon = Icons.info;
        color = Colors.blue;
        break;
      case ErrorSeverity.warning:
        icon = Icons.warning;
        color = Colors.orange;
        break;
      case ErrorSeverity.error:
        icon = Icons.error;
        color = Colors.red;
        break;
      case ErrorSeverity.critical:
        icon = Icons.critical;
        color = Colors.purple;
        break;
      case ErrorSeverity.fatal:
        icon = Icons.bug_report;
        color = Colors.deepPurple;
        break;
    }
    
    return Icon(icon, color: color);
  }

  Widget _buildErrorActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _triggerTestError(),
                child: const Text('触发测试错误'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _triggerTestCrash(),
                child: const Text('触发测试崩溃'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _exportErrors(),
                child: const Text('导出错误报告'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _clearErrors(),
                child: const Text('清空错误'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showErrorDetail(ErrorReport error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('错误详情 - ${error.severity.name}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('消息: ${error.message}'),
              Text('类型: ${error.type.name}'),
              Text('时间: ${error.timestamp.toIso8601String()}'),
              if (error.exception != null) Text('异常: ${error.exception}'),
              if (error.appState.isNotEmpty) 
                Text('应用状态: ${error.appState}'),
            ],
          ),
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

  void _triggerTestError() {
    widget.collector.reportError(
      type: ErrorType.general,
      severity: ErrorSeverity.warning,
      message: '这是一个测试错误',
      exception: Exception('测试异常'),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('测试错误已触发')),
    );
  }

  void _triggerTestCrash() {
    try {
      throw Exception('这是一个测试崩溃');
    } catch (e, stack) {
      widget.collector.recordCrash(e, stack);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('测试崩溃已触发')),
      );
    }
  }

  void _exportErrors() {
    try {
      final reportData = widget.collector.exportErrorReports();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('错误报告导出'),
          content: SingleChildScrollView(
            child: SelectableText(reportData),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('关闭'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导出失败: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _clearErrors() {
    widget.collector.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('错误信息已清空')),
    );
  }
}

/// 系统信息组件
class SystemInfoWidget extends StatelessWidget {
  final DebugService debugService;

  const SystemInfoWidget({Key? key, required this.debugService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DebugStats>(
      stream: debugService.tools.statsStream,
      builder: (context, snapshot) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('系统信息'),
              _buildSystemInfoCard(),
              const SizedBox(height: 16),
              _buildSectionTitle('调试工具'),
              _buildDebugTools(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildSystemInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('操作系统', Platform.operatingSystem),
            _buildInfoRow('操作系统版本', Platform.operatingSystemVersion),
            _buildInfoRow('处理器数量', Platform.numberOfProcessors.toString()),
            _buildInfoRow('Dart版本', Platform.version.split(' ').first),
            _buildInfoRow('当前时间', DateTime.now().toIso8601String()),
            _buildInfoRow('时区', DateTime.now().timeZoneName),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildDebugTools() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _executeDebugCommand('help'),
                    child: const Text('帮助'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _executeDebugCommand('memory'),
                    child: const Text('内存信息'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _executeDebugCommand('gc'),
                    child: const Text('垃圾回收'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _executeDebugCommand('perf'),
                    child: const Text('性能信息'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _executeDebugCommand('clear'),
              child: const Text('清空调试数据'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _executeDebugCommand(String command) async {
    try {
      final result = await debugService.executeCommand(command, []);
      if (result.isNotEmpty) {
        // 在实际应用中，这里应该显示结果
        debugService.tools._logger.info('调试命令执行结果: $result', source: 'DebugUI');
      }
    } catch (e) {
      debugService.tools._logger.warning('调试命令执行失败', exception: e, source: 'DebugUI');
    }
  }
}

/// 文件管理组件
class FileManagerWidget extends StatelessWidget {
  final LogFileManager manager;

  const FileManagerWidget({Key? key, required this.manager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('文件统计'),
          _buildFileStatsCard(),
          const SizedBox(height: 16),
          _buildSectionTitle('文件管理'),
          _buildFileActions(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildFileStatsCard() {
    final stats = manager.getDirectoryStatistics();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('文件总数: ${stats['totalFiles']}'),
            Text('总大小: ${(stats['totalSize'] as int) / (1024 * 1024).toStringAsFixed(2)} MB'),
            Text('压缩文件: ${stats['compressedFiles']}'),
            Text('过期文件: ${stats['oldFilesCount']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildFileActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _performCleanup(),
                child: const Text('执行清理'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _exportLogs(),
                child: const Text('导出日志'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _searchLogs(),
                child: const Text('搜索日志'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _refreshFiles(),
                child: const Text('刷新'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _performCleanup() {
    try {
      manager.performCleanup();
      // 这里应该显示成功消息
    } catch (e) {
      // 这里应该显示错误消息
    }
  }

  void _exportLogs() async {
    try {
      final start = DateTime.now().subtract(const Duration(days: 7));
      final end = DateTime.now();
      final content = await manager.exportLogs(start, end);
      
      // 在实际应用中，这里应该显示或保存导出的内容
    } catch (e) {
      // 这里应该显示错误消息
    }
  }

  void _searchLogs() {
    // 实现搜索功能
  }

  void _refreshFiles() {
    manager.reloadFiles();
  }
}

/// 调试设置组件
class DebugSettingsWidget extends StatefulWidget {
  final DebugService debugService;
  final PerformanceMonitor performanceMonitor;
  final ErrorCollector errorCollector;

  const DebugSettingsWidget({
    Key? key,
    required this.debugService,
    required this.performanceMonitor,
    required this.errorCollector,
  }) : super(key: key);

  @override
  State<DebugSettingsWidget> createState() => _DebugSettingsWidgetState();
}

class _DebugSettingsWidgetState extends State<DebugSettingsWidget> {
  bool _debugEnabled = true;
  bool _performanceEnabled = true;
  bool _errorCollectionEnabled = true;
  LogLevel _logLevel = LogLevel.debug;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('调试设置'),
          _buildDebugSettings(),
          const SizedBox(height: 16),
          _buildSectionTitle('日志设置'),
          _buildLogSettings(),
          const SizedBox(height: 16),
          _buildSectionTitle('性能监控设置'),
          _buildPerformanceSettings(),
          const SizedBox(height: 16),
          _buildSectionTitle('错误收集设置'),
          _buildErrorSettings(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildDebugSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('启用调试模式'),
              value: _debugEnabled,
              onChanged: (value) {
                setState(() {
                  _debugEnabled = value;
                });
                if (value) {
                  widget.debugService.enable();
                } else {
                  widget.debugService.disable();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<LogLevel>(
              value: _logLevel,
              decoration: const InputDecoration(labelText: '日志级别'),
              items: LogLevel.allValues.map((level) =>
                DropdownMenuItem<LogLevel>(
                  value: level,
                  child: Text(level.name),
                )
              ).toList(),
              onChanged: (level) {
                if (level != null) {
                  setState(() {
                    _logLevel = level;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('启用性能监控'),
              value: _performanceEnabled,
              onChanged: (value) {
                setState(() {
                  _performanceEnabled = value;
                });
                if (value) {
                  widget.performanceMonitor.enable();
                } else {
                  widget.performanceMonitor.disable();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('启用错误收集'),
              value: _errorCollectionEnabled,
              onChanged: (value) {
                setState(() {
                  _errorCollectionEnabled = value;
                });
                if (value) {
                  widget.errorCollector.enable();
                } else {
                  widget.errorCollector.disable();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}