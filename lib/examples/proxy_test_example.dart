import 'package:flutter/material.dart';

/// 代理测试功能使用示例
class ProxyTestExample extends StatefulWidget {
  const ProxyTestExample({Key? key}) : super(key: key);

  @override
  State<ProxyTestExample> createState() => _ProxyTestExampleState();
}

class _ProxyTestExampleState extends State<ProxyTestExample> {
  // 服务实例
  final ProxyTestService _testService = ProxyTestService();
  final NetworkValidator _networkValidator = NetworkValidator();
  final ProxyPerformanceMonitor _performanceMonitor = ProxyPerformanceMonitor();
  
  // 测试结果
  List<ProxyTestResult> _testResults = [];
  NetworkValidationResult? _validationResult;
  List<PerformanceMetrics> _performanceData = [];
  
  // 测试配置
  final TextEditingController _hostController = TextEditingController(text: '127.0.0.1');
  final TextEditingController _portController = TextEditingController(text: '1080');
  ProxyType _proxyType = ProxyType.http;
  
  @override
  void initState() {
    super.initState();
    _setupListeners();
    _startMonitoring();
  }
  
  void _setupListeners() {
    _testService.testResults.listen((result) {
      setState(() {
        _testResults.add(result);
      });
      _showTestResultSnackBar(result);
    });
    
    _performanceMonitor.metrics.listen((metrics) {
      setState(() {
        _performanceData = List.from(_performanceMonitor.currentMetrics);
      });
    });
    
    _networkValidator.stateStream.listen((state) {
      debugPrint('网络状态变更: $state');
    });
  }
  
  void _startMonitoring() {
    // 配置性能监控
    _performanceMonitor.configure(
      const PerformanceMonitoringConfig(
        samplingInterval: Duration(seconds: 30),
        maxSampleCount: 100,
        testUrls: [
          'https://www.google.com',
          'https://httpbin.org/get',
          'https://httpbin.org/status/200',
        ],
      ),
    );
    
    _performanceMonitor.startMonitoring();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('代理测试示例'),
        actions: [
          IconButton(
            onPressed: _showQuickTestMenu,
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基本测试组件
            ProxyTestWidget(
              initialProxy: _getCurrentProxy(),
              onTestComplete: (result) {
                debugPrint('测试完成: ${result.testType.name} - ${result.success}');
              },
              onValidationComplete: (result) {
                setState(() {
                  _validationResult = result;
                });
              },
              onMetricsUpdate: (metrics) {
                debugPrint('性能指标更新: ${metrics.responseTime}ms');
              },
            ),
            
            const SizedBox(height: 24),
            
            // 单独测试按钮
            _buildQuickTestButtons(),
            
            const SizedBox(height: 24),
            
            // 实时监控数据
            if (_performanceData.isNotEmpty)
              _buildRealTimeMetrics(),
            
            const SizedBox(height: 24),
            
            // 测试历史
            if (_testResults.isNotEmpty)
              _buildTestHistory(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _runFullTestSuite,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
  
  Widget _buildQuickTestButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '快速测试',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _runQuickTest(ProxyTestType.connectivity),
                    icon: const Icon(Icons.network_check),
                    label: const Text('连通性测试'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _runQuickTest(ProxyTestType.speed),
                    icon: const Icon(Icons.speed),
                    label: const Text('速度测试'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _runQuickTest(ProxyTestType.dns),
                    icon: const Icon(Icons.dns),
                    label: const Text('DNS测试'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _validateNetwork,
                    icon: const Icon(Icons.security),
                    label: const Text('网络验证'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRealTimeMetrics() {
    final latestMetrics = _performanceData.last;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '实时性能指标',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricTile(
                  '响应时间',
                  '${latestMetrics.responseTime.toStringAsFixed(0)}ms',
                  Icons.timer,
                ),
                _buildMetricTile(
                  '成功率',
                  '${(latestMetrics.successRate * 100).toStringAsFixed(1)}%',
                  Icons.check_circle,
                ),
                _buildMetricTile(
                  '吞吐量',
                  '${latestMetrics.throughput.toStringAsFixed(2)}/s',
                  Icons.speed,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 性能历史图表（简化版）
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _performanceData.take(20).length,
                itemBuilder: (context, index) {
                  final metrics = _performanceData[_performanceData.length - 1 - index];
                  final barHeight = (metrics.responseTime / 1000 * 100).clamp(10, 100);
                  
                  return Container(
                    width: 6,
                    height: barHeight,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                },
              ),
            ),
            
            const Text(
              '响应时间趋势 (最近20次测试)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetricTile(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
  
  Widget _buildTestHistory() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '测试历史',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            ..._testResults.take(10).map((result) => _buildTestResultItem(result)),
            
            if (_testResults.length > 10)
              TextButton(
                onPressed: () => _showFullTestHistory(),
                child: Text('查看全部 ${_testResults.length} 个结果'),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTestResultItem(ProxyTestResult result) {
    return ListTile(
      dense: true,
      leading: Icon(
        result.success ? Icons.check_circle : Icons.error,
        color: result.success ? Colors.green : Colors.red,
      ),
      title: Text(_getTestTypeName(result.testType.name)),
      subtitle: Text(result.message ?? ''),
      trailing: Text(
        '${result.duration.inMilliseconds}ms',
        style: const TextStyle(fontFamily: 'monospace'),
      ),
    );
  }
  
  // 事件处理方法
  
  Future<void> _runQuickTest(ProxyTestType testType) async {
    final proxy = _getCurrentProxy();
    if (proxy == null) {
      _showErrorSnackBar('请先配置代理信息');
      return;
    }

    try {
      final result = await _testService.runSingleTest(testType);
      _showTestResultSnackBar(result);
    } catch (e) {
      _showErrorSnackBar('测试失败: $e');
    }
  }
  
  Future<void> _validateNetwork() async {
    try {
      final result = await _networkValidator.validateNetworkConnection();
      setState(() {
        _validationResult = result;
      });
      
      if (result.isValid) {
        _showSuccessSnackBar('网络验证通过');
      } else {
        _showErrorSnackBar('网络验证失败: ${result.errors.join(', ')}');
      }
    } catch (e) {
      _showErrorSnackBar('网络验证异常: $e');
    }
  }
  
  Future<void> _runFullTestSuite() async {
    final proxy = _getCurrentProxy();
    if (proxy == null) {
      _showErrorSnackBar('请先配置代理信息');
      return;
    }

    try {
      _showLoadingSnackBar('正在运行完整测试套件...');
      
      final results = await _testService.runFullTestSuite(
        proxy: proxy,
        testTypes: [
          ProxyTestType.connectivity,
          ProxyTestType.latency,
          ProxyTestType.speed,
          ProxyTestType.dns,
        ],
      );
      
      setState(() {
        _testResults.addAll(results);
      });
      
      _showSuccessSnackBar('完整测试套件执行完成');
    } catch (e) {
      _showErrorSnackBar('测试套件执行失败: $e');
    }
  }
  
  void _showQuickTestMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '更多选项',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('性能分析'),
              subtitle: const Text('查看详细的性能统计'),
              onTap: () {
                Navigator.pop(context);
                _showPerformanceAnalysis();
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('导出结果'),
              subtitle: const Text('导出测试数据到文件'),
              onTap: () {
                Navigator.pop(context);
                _exportTestResults();
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('监控设置'),
              subtitle: const Text('配置性能监控参数'),
              onTap: () {
                Navigator.pop(context);
                _showMonitoringSettings();
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showPerformanceAnalysis() {
    final summary = _performanceMonitor.getPerformanceSummary();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('性能分析报告'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnalysisItem('测试样本', summary['totalSamples'].toString()),
              _buildAnalysisItem('平均响应时间', '${summary['averageResponseTime'].toStringAsFixed(0)}ms'),
              _buildAnalysisItem('平均吞吐量', '${summary['averageThroughput'].toStringAsFixed(2)}/s'),
              _buildAnalysisItem('平均成功率', '${(summary['averageSuccessRate'] * 100).toStringAsFixed(1)}%'),
              _buildAnalysisItem('最小响应时间', '${summary['minResponseTime'].toStringAsFixed(0)}ms'),
              _buildAnalysisItem('最大响应时间', '${summary['maxResponseTime'].toStringAsFixed(0)}ms'),
              _buildAnalysisItem('总请求数', summary['totalRequests'].toString()),
              _buildAnalysisItem('成功请求数', summary['totalSuccessfulRequests'].toString()),
              _buildAnalysisItem('失败请求数', summary['totalFailedRequests'].toString()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnalysisItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  
  void _exportTestResults() async {
    try {
      final exportData = await _performanceMonitor.exportMetrics();
      
      // 这里可以保存到文件或分享
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('导出结果'),
          content: const Text('结果数据已在控制台输出'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        ),
      );
      
      debugPrint('导出的测试数据: $exportData');
    } catch (e) {
      _showErrorSnackBar('导出失败: $e');
    }
  }
  
  void _showMonitoringSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('监控设置'),
        content: const Text('监控配置功能待实现'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
  
  void _showFullTestHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('测试历史'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _testResults.length,
            itemBuilder: (context, index) {
              final result = _testResults[index];
              return ListTile(
                dense: true,
                leading: Icon(
                  result.success ? Icons.check : Icons.error,
                  color: result.success ? Colors.green : Colors.red,
                  size: 16,
                ),
                title: Text(_getTestTypeName(result.testType.name)),
                subtitle: Text(result.message ?? ''),
                trailing: Text('${result.duration.inMilliseconds}ms'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
  
  // 工具方法
  
  ProxyConfig? _getCurrentProxy() {
    final host = _hostController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 0;
    
    if (host.isEmpty || port <= 0) return null;
    
    return ProxyConfig(
      host: host,
      port: port,
      type: _proxyType,
    );
  }
  
  String _getTestTypeName(String type) {
    const names = {
      'connectivity': '连通性测试',
      'speed': '速度测试',
      'dns': 'DNS测试',
      'leak': '泄漏检测',
      'latency': '延迟测试',
      'bandwidth': '带宽测试',
    };
    return names[type] ?? type;
  }
  
  // 消息提示方法
  
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
  
  void _showLoadingSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
      ),
    );
  }
  
  void _showTestResultSnackBar(ProxyTestResult result) {
    final color = result.success ? Colors.green : Colors.red;
    final icon = result.success ? Icons.check : Icons.error;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('${_getTestTypeName(result.testType.name)}: ${result.message}'),
            ),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _performanceMonitor.dispose();
    _networkValidator.stopMonitoring();
    super.dispose();
  }
}

// 主函数示例
void main() {
  runApp(const MaterialApp(
    home: ProxyTestExample(),
  ));
}