import 'package:flutter/material.dart';
import '../test/performance_benchmark.dart';
import '../test/memory_usage_test.dart';
import '../test/webview_performance_test.dart';
import '../services/performance_reporter.dart';

/// 性能测试演示页面
/// 展示如何使用性能测试工具套件
class PerformanceTestDemo extends StatefulWidget {
  const PerformanceTestDemo({Key? key}) : super(key: key);

  @override
  State<PerformanceTestDemo> createState() => _PerformanceTestDemoState();
}

class _PerformanceTestDemoState extends State<PerformanceTestDemo> {
  final PerformanceBenchmark _benchmark = PerformanceBenchmark();
  final MemoryUsageTest _memoryTest = MemoryUsageTest();
  final WebviewPerformanceTest _webviewTest = WebviewPerformanceTest();
  final PerformanceReporter _reporter = PerformanceReporter();

  bool _isRunning = false;
  String _currentTest = '';
  List<String> _testResults = [];
  StreamSubscription<MemorySnapshot>? _memorySubscription;

  @override
  void dispose() {
    _memorySubscription?.cancel();
    super.dispose();
  }

  /// 运行完整性能测试套件
  Future<void> _runFullPerformanceTest() async {
    setState(() {
      _isRunning = true;
      _testResults.clear();
    });

    try {
      // 1. 运行性能基准测试
      await _runBenchmarkTest();
      
      // 2. 运行内存使用测试
      await _runMemoryTest();
      
      // 3. 运行WebView性能测试
      await _runWebviewTest();
      
      // 4. 生成综合报告
      await _generateReport();
      
      _addResult('✅ 完整性能测试套件执行完成');
      
    } catch (e) {
      _addResult('❌ 测试执行失败: $e');
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }

  /// 运行性能基准测试
  Future<void> _runBenchmarkTest() async {
    _setCurrentTest('运行性能基准测试');
    
    final report = await _benchmark.runFullBenchmark();
    
    _addResult('📊 性能基准测试结果:');
    _addResult('  - 总体评分: ${report.overallScore.toStringAsFixed(1)}/100');
    
    if (report.startupTest != null) {
      _addResult('  - 启动时间: ${report.startupTest!.duration}ms');
    }
    
    if (report.renderTest != null) {
      final avgFrameTime = report.renderTest!.metrics['平均帧时间'];
      _addResult('  - 平均帧时间: ${avgFrameTime?.toStringAsFixed(2)}ms');
    }
    
    if (report.memoryTest != null) {
      final memoryUsage = report.memoryTest!.metrics['GC后内存(MB)'];
      _addResult('  - GC后内存: ${memoryUsage?.toStringAsFixed(2)}MB');
    }
  }

  /// 运行内存使用测试
  Future<void> _runMemoryTest() async {
    _setCurrentTest('运行内存使用测试');
    
    // 开始内存监控
    _memorySubscription = _memoryTest.startMonitoring().listen((snapshot) {
      if (_isRunning) {
        _addResult('📈 内存监控: ${snapshot.usedMemoryMB.toStringAsFixed(2)}MB');
      }
    });
    
    // 执行内存压力测试
    final stressResult = await _memoryTest.performMemoryStressTest();
    
    _addResult('🧠 内存压力测试结果:');
    _addResult('  - 内存增长: ${stressResult.memoryGrowth / (1024 * 1024).toStringAsFixed(2)}MB');
    _addResult('  - 增长率: ${stressResult.memoryGrowthPercentage.toStringAsFixed(2)}%');
    _addResult('  - 恢复率: ${stressResult.recoveryRate.toStringAsFixed(2)}%');
    _addResult('  - 测试是否通过: ${stressResult.passed ? "是" : "否"}');
    
    // 停止内存监控
    _memoryTest.stopMonitoring();
    _memorySubscription?.cancel();
  }

  /// 运行WebView性能测试
  Future<void> _runWebviewTest() async {
    _setCurrentTest('运行WebView性能测试');
    
    final report = await _webviewTest.runFullPerformanceTest();
    
    _addResult('🌐 WebView性能测试结果:');
    _addResult('  - 总体评分: ${report.overallScore.toStringAsFixed(1)}/100');
    
    if (report.pageLoadTest != null) {
      final avgLoadTime = report.pageLoadTest!.metrics['平均加载时间'];
      _addResult('  - 平均页面加载时间: ${avgLoadTime?.toStringAsFixed(0)}ms');
    }
    
    if (report.javascriptTest != null) {
      final avgJsTime = report.javascriptTest!.metrics['平均执行时间'];
      _addResult('  - 平均JavaScript执行时间: ${avgJsTime?.toStringAsFixed(0)}ms');
    }
    
    if (report.memoryTest != null) {
      final avgMemory = report.memoryTest!.metrics['平均内存使用'];
      _addResult('  - 平均WebView内存使用: ${(avgMemory as num?)?.toInt() / (1024 * 1024).toStringAsFixed(2)}MB');
    }
  }

  /// 生成综合性能报告
  Future<void> _generateReport() async {
    _setCurrentTest('生成综合性能报告');
    
    // 模拟测试结果数据
    final testResults = {
      '基准测试': {
        '总体评分': 85.5,
        '启动时间': 1200,
        '帧时间': 15.2,
        '内存使用': 128,
      },
      '内存测试': {
        '内存增长': 15.2,
        '增长率': 12.5,
        '恢复率': 85.0,
      },
      'WebView测试': {
        '页面加载时间': 2100,
        'JavaScript执行时间': 320,
        '内存使用': 45.6,
      },
    };
    
    final report = await _reporter.generateComprehensiveReport(
      testSuiteName: 'FlClash性能测试演示',
      testResults: testResults,
      additionalData: {
        '测试环境': 'Flutter 3.16.0',
        '设备信息': 'Android Emulator',
        '测试时间': DateTime.now().toIso8601String(),
      },
    );
    
    _addResult('📋 综合性能报告:');
    _addResult('  - 报告ID: ${report.id}');
    _addResult('  - 总体评分: ${report.overallScore.toStringAsFixed(1)}/100');
    _addResult('  - 测试项目: ${report.metrics?.length ?? 0}项');
    _addResult('  - 优化建议: ${report.recommendations.length}条');
    
    // 保存报告
    await _reporter.saveReport(report);
    _addResult('  - 报告已保存到: ${_reporter.getReportHistory().last.id}.json');
  }

  /// 设置当前测试状态
  void _setCurrentTest(String testName) {
    setState(() {
      _currentTest = testName;
    });
    _addResult('🔄 $_currentTest...');
  }

  /// 添加测试结果
  void _addResult(String result) {
    setState(() {
      _testResults.add(result);
    });
  }

  /// 清空测试结果
  void _clearResults() {
    setState(() {
      _testResults.clear();
    });
  }

  /// 运行单项测试
  Widget _buildTestButton({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('性能测试演示'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 测试控制面板
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '性能测试控制台',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  
                  // 运行完整测试按钮
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isRunning ? null : _runFullPerformanceTest,
                      icon: _isRunning 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.play_arrow),
                      label: Text(_isRunning ? '测试运行中...' : '运行完整测试套件'),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 清空结果按钮
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _isRunning ? null : _clearResults,
                      child: const Text('清空结果'),
                    ),
                  ),
                  
                  // 当前测试状态
                  if (_currentTest.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 8),
                          Text(_currentTest),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // 单项测试按钮
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Text(
                  '单项性能测试',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                
                _buildTestButton(
                  title: '性能基准测试',
                  description: '测试应用启动、渲染、内存等核心性能指标',
                  icon: Icons.speed,
                  onPressed: () => _runSingleTest('基准测试', _runBenchmarkTest),
                ),
                
                _buildTestButton(
                  title: '内存使用测试',
                  description: '监控内存使用情况，检测内存泄漏',
                  icon: Icons.memory,
                  onPressed: () => _runSingleTest('内存测试', _runMemoryTest),
                ),
                
                _buildTestButton(
                  title: 'WebView性能测试',
                  description: '测试WebView加载、执行、内存等性能',
                  icon: Icons.web,
                  onPressed: () => _runSingleTest('WebView测试', _runWebviewTest),
                ),
                
                _buildTestButton(
                  title: '生成性能报告',
                  description: '基于测试结果生成详细的性能分析报告',
                  icon: Icons.assessment,
                  onPressed: () => _runSingleTest('报告生成', _generateReport),
                ),
              ],
            ),
          ),
          
          // 测试结果展示
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '测试结果输出',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _testResults.map((result) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              result,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 运行单项测试
  void _runSingleTest(String testName, Future<void> Function() testFunction) async {
    if (_isRunning) return;
    
    setState(() {
      _isRunning = true;
    });
    
    try {
      await testFunction();
      _addResult('✅ $testName 完成');
    } catch (e) {
      _addResult('❌ $testName 失败: $e');
    } finally {
      setState(() {
        _isRunning = false;
        _currentTest = '';
      });
    }
  }
}

/// 性能测试结果展示组件
class PerformanceResultWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> results;
  final Color? color;

  const PerformanceResultWidget({
    Key? key,
    required this.title,
    required this.results,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...results.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key),
                    Text(entry.value.toString()),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}