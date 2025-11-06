import 'package:flutter/material.dart';
import 'dart:async';

/// 代理测试结果状态
enum TestResultStatus {
  idle,
  running,
  completed,
  error,
}

/// 代理测试Widget
class ProxyTestWidget extends StatefulWidget {
  final ProxyConfig? initialProxy;
  final bool showPerformanceMonitor;
  final bool showNetworkValidator;
  final void Function(ProxyTestResult)? onTestComplete;
  final void Function(NetworkValidationResult)? onValidationComplete;
  final void Function(PerformanceMetrics)? onMetricsUpdate;

  const ProxyTestWidget({
    Key? key,
    this.initialProxy,
    this.showPerformanceMonitor = true,
    this.showNetworkValidator = true,
    this.onTestComplete,
    this.onValidationComplete,
    this.onMetricsUpdate,
  }) : super(key: key);

  @override
  State<ProxyTestWidget> createState() => _ProxyTestWidgetState();
}

class _ProxyTestWidgetState extends State<ProxyTestWidget> 
    with TickerProviderStateMixin {
  
  // 服务实例
  final ProxyTestService _testService = ProxyTestService();
  final NetworkValidator _networkValidator = NetworkValidator();
  final ProxyPerformanceMonitor _performanceMonitor = ProxyPerformanceMonitor();
  
  // 状态管理
  TestResultStatus _testStatus = TestResultStatus.idle;
  ProxyConfig? _currentProxy;
  final List<ProxyTestResult> _testResults = [];
  NetworkValidationResult? _validationResult;
  List<PerformanceMetrics> _performanceData = [];
  
  // 动画控制器
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  
  // UI状态
  bool _showAdvancedOptions = false;
  String _currentTestPhase = '';
  Map<String, bool> _selectedTests = {
    'connectivity': true,
    'speed': true,
    'dns': true,
    'leak': false,
    'latency': false,
    'bandwidth': false,
  };
  
  final TextEditingController _customUrlController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _currentProxy = widget.initialProxy;
    _setupAnimations();
    _setupListeners();
    _startPerformanceMonitoring();
  }
  
  void _setupAnimations() {
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
  }
  
  void _setupListeners() {
    // 监听测试结果
    _testService.testResults.listen((result) {
      setState(() {
        _testResults.add(result);
        _currentTestPhase = '';
      });
      
      widget.onTestComplete?.call(result);
      
      // 如果是最后一个测试，停止旋转动画
      if (result.testType == ProxyTestType.values.last) {
        _stopLoadingAnimation();
      }
    });
    
    // 监听性能数据
    _performanceMonitor.metrics.listen((metrics) {
      setState(() {
        _performanceData = List.from(_performanceMonitor.currentMetrics);
      });
      
      widget.onMetricsUpdate?.call(metrics);
    });
    
    // 监听性能历史数据
    _performanceMonitor.metricsHistory.listen((metrics) {
      setState(() {
        _performanceData = metrics;
      });
    });
  }
  
  void _startPerformanceMonitoring() {
    _performanceMonitor.configure(
      const PerformanceMonitoringConfig(
        samplingInterval: Duration(seconds: 30),
        enableAutoStart: true,
      ),
    );
    _performanceMonitor.startMonitoring();
  }
  
  @override
  void dispose() {
    _rotationController.dispose();
    _customUrlController.dispose();
    _performanceMonitor.dispose();
    _testService.dispose();
    _networkValidator.stopMonitoring();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            _buildHeader(),
            const Divider(),
            
            // 代理配置
            _buildProxyConfig(),
            const SizedBox(height: 16),
            
            // 测试选项
            _buildTestOptions(),
            const SizedBox(height: 16),
            
            // 控制按钮
            _buildControlButtons(),
            const SizedBox(height: 16),
            
            // 测试进度
            if (_testStatus == TestResultStatus.running);
              _buildProgressIndicator(),
            
            // 网络验证
            if (widget.showNetworkValidator && _validationResult != null);
              _buildNetworkValidationResult(),
            
            // 性能监控
            if (widget.showPerformanceMonitor && _performanceData.isNotEmpty)
              _buildPerformanceMonitor(),
            
            // 测试结果
            if (_testResults.isNotEmpty)
              _buildTestResults(),
            
            // 高级选项
            _buildAdvancedOptions(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.network_check,
          size: 24,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 8),
        const Text(
          '代理测试与验证',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (_performanceMonitor.isMonitoring)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: const Text(
              '实时监控中',
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildProxyConfig() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '代理配置',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: '代理地址',
                  hintText: '如: 127.0.0.1',
                  prefixIcon: Icon(Icons.language),
                ),
                controller: TextEditingController(
                  text: _currentProxy?.host ?? '',
                ),
                onChanged: (value) {
                  _currentProxy = _currentProxy?.copyWith(host: value);
                },
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: '端口',
                  hintText: '1080',
                ),
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: _currentProxy?.port.toString() ?? '',
                ),
                onChanged: (value) {
                  final port = int.tryParse(value) ?? 0;
                  _currentProxy = _currentProxy?.copyWith(port: port);
                },
              ),
            ),
            const SizedBox(width: 8),
            DropdownButton<ProxyType>(
              value: _currentProxy?.type ?? ProxyType.http,
              onChanged: (type) {
                setState(() {
                  _currentProxy = _currentProxy?.copyWith(type: type);
                });
              },
              items: ProxyType.values.map((type) {
                return DropdownMenuItem<ProxyType>(
                  value: type,
                  child: Text(_getProxyTypeName(type)),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildTestOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '测试选项',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedTests.keys.map((testType) {
            return FilterChip(
              label: Text(_getTestTypeName(testType)),
              selected: _selectedTests[testType]!,
              onSelected: (selected) {
                setState(() {
                  _selectedTests[testType] = selected;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildControlButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _testStatus == TestResultStatus.running ? null : _runTests,
            icon: _buildLoadingIcon(),
            label: Text(_getTestButtonText()),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _testStatus == TestResultStatus.running ? null : _validateNetwork,
            icon: const Icon(Icons.security),
            label: const Text('网络验证'),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            setState(() {
              _showAdvancedOptions = !_showAdvancedOptions;
            });
          },
          icon: Icon(
            _showAdvancedOptions ? Icons.expand_less : Icons.expand_more,
          ),
          tooltip: '高级选项',
        ),
      ],
    );
  }
  
  Widget _buildLoadingIcon() {
    if (_testStatus == TestResultStatus.running) {
      return AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159,
            child: const Icon(Icons.refresh),
          );
        },
      );
    }
    return const Icon(Icons.play_arrow);
  }
  
  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: _getProgressValue(),
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
          const SizedBox(height: 8),
          Text(
            _currentTestPhase.isEmpty 
              ? '正在执行测试...' 
              : '正在测试: $_currentTestPhase',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
  
  Widget _buildNetworkValidationResult() {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _validationResult!.isValid 
                    ? Icons.check_circle 
                    : Icons.error,
                  color: _validationResult!.isValid ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  '网络验证结果',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _validationResult!.isValid ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            if (_validationResult!.errors.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                '错误:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              ..._validationResult!.errors.map((error) => 
                Text('• $error', style: const TextStyle(color: Colors.red))
              ),
            ],
            if (_validationResult!.warnings.isNotEmpty) ...[
              const SizedBox(height: 4),
              const Text(
                '警告:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              ..._validationResult!.warnings.map((warning) => 
                Text('• $warning', style: const TextStyle(color: Colors.orange))
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildPerformanceMonitor() {
    final latestMetrics = _performanceData.isNotEmpty ? _performanceData.last : null;
    if (latestMetrics == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '性能监控',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricCard(
                  '响应时间',
                  '${latestMetrics.responseTime.toInt()}ms',
                  Icons.timer,
                ),
                _buildMetricCard(
                  '成功率',
                  '${(latestMetrics.successRate * 100).toStringAsFixed(1)}%',
                  Icons.check_circle,
                ),
                _buildMetricCard(
                  '吞吐量',
                  '${latestMetrics.throughput.toStringAsFixed(2)}req/s',
                  Icons.speed,
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: _buildPerformanceChart(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
  
  Widget _buildPerformanceChart() {
    // 简化的性能图表实现
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _performanceData.take(10).length,
        itemBuilder: (context, index) {
          final metrics = _performanceData[_performanceData.length - 1 - index];
          final barHeight = (metrics.responseTime / 1000 * 100).clamp(0, 100);
          
          return Container(
            width: 10,
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Tooltip(
              message: '${metrics.responseTime.toInt()}ms',
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildTestResults() {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '测试结果',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._testResults.map((result) => _buildTestResultItem(result)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTestResultItem(ProxyTestResult result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: result.success 
          ? Colors.green.withOpacity(0.1)
          : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: result.success ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                result.success ? Icons.check_circle : Icons.error,
                color: result.success ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                _getTestTypeName(result.testType.name),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: result.success ? Colors.green : Colors.red,
                ),
              ),
              const Spacer(),
              Text(
                '${result.duration.inMilliseconds}ms',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          if (result.message != null);
            Text(
              result.message!,
              style: const TextStyle(fontSize: 12),
            ),
          if (result.details != null && result.details!.isNotEmpty);
            _buildResultDetails(result.details!),
        ],
      ),
    );
  }
  
  Widget _buildResultDetails(Map<String, dynamic> details) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details.entries.take(3).map((entry) {
          return Text(
            '${entry.key}: ${entry.value}',
            style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildAdvancedOptions() {
    if (!_showAdvancedOptions) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '高级选项',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _customUrlController,
              decoration: const InputDecoration(
                labelText: '自定义测试URL',
                hintText: 'https://example.com',
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _performanceMonitor.isMonitoring 
                      ? _performanceMonitor.stopMonitoring
                      : _performanceMonitor.startMonitoring,
                    icon: Icon(
                      _performanceMonitor.isMonitoring ? Icons.stop : Icons.play_arrow,
                    ),
                    label: Text(
                      _performanceMonitor.isMonitoring 
                        ? '停止监控' 
                        : '开始监控',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _exportResults(),
                    icon: const Icon(Icons.download),
                    label: const Text('导出结果'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // 事件处理方法
  
  Future<void> _runTests() async {
    if (_currentProxy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先配置代理信息')),
      );
      return;
    }

    setState(() {
      _testStatus = TestResultStatus.running;
      _testResults.clear();
      _currentTestPhase = '准备测试...';
    });

    _startLoadingAnimation();

    try {
      final selectedTestTypes = _selectedTests.entries;
        .where((entry) => entry.value);
        .map((entry) => ProxyTestType.values.firstWhere(
          (type) => type.name == entry.key,
        ))
        .toList();

      for (final testType in selectedTestTypes) {
        setState(() {
          _currentTestPhase = _getTestTypeName(testType.name);
        });

        await _testService.runSingleTest(testType);
      }

      setState(() {
        _testStatus = TestResultStatus.completed;
        _currentTestPhase = '';
      });
    } catch (e) {
      setState(() {
        _testStatus = TestResultStatus.error;
        _currentTestPhase = '';
      });
      _stopLoadingAnimation();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('测试失败: $e')),
      );
    }
  }

  Future<void> _validateNetwork() async {
    setState(() {
      _validationResult = null;
    });

    try {
      final result = await _networkValidator.validateNetworkConnection();
      setState(() {
        _validationResult = result;
      });
      
      widget.onValidationComplete?.call(result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('网络验证失败: $e')),
      );
    }
  }
  
  void _startLoadingAnimation() {
    _rotationController.repeat();
  }
  
  void _stopLoadingAnimation() {
    _rotationController.stop();
    _rotationController.reset();
  }
  
  double _getProgressValue() {
    if (_testResults.isEmpty) return 0;
    final totalTests = _selectedTests.values.where((selected) => selected).length;
    return _testResults.length / totalTests;
  }
  
  String _getTestButtonText() {
    switch (_testStatus) {
      case TestResultStatus.idle:
        return '开始测试';
      case TestResultStatus.running:
        return '测试中...';
      case TestResultStatus.completed:
        return '重新测试';
      case TestResultStatus.error:
        return '重试';
    }
  }
  
  String _getTestTypeName(String type) {
    const names = {
      'connectivity': '连通性',
      'speed': '速度',
      'dns': 'DNS',
      'leak': '泄漏检测',
      'latency': '延迟',
      'bandwidth': '带宽',
    };
    return names[type] ?? type;
  }
  
  String _getProxyTypeName(ProxyType type) {
    switch (type) {
      case ProxyType.http:
        return 'HTTP';
      case ProxyType.https:
        return 'HTTPS';
      case ProxyType.socks:
        return 'SOCKS';
      case ProxyType.socks4:
        return 'SOCKS4';
      case ProxyType.socks5:
        return 'SOCKS5';
    }
  }
  
  Future<void> _exportResults() async {
    try {
      final exportData = {
        'proxy': _currentProxy?.toJson(),
        'testResults': _testResults.map((r) => r.toJson()).toList(),
        'networkValidation': _validationResult?.toJson(),
        'performanceMetrics': _performanceData.map((m) => m.toJson()).toList(),
        'exportTime': DateTime.now().toIso8601String(),
      };
      
      // 这里可以保存到文件或分享
      final jsonString = exportData.toString();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('结果已导出到控制台')),
      );
      
      debugPrint('导出数据: $jsonString');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导出失败: $e')),
      );
    }
  }
}