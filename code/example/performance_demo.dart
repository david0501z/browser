import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'services/performance_service.dart';
import 'services/background_service.dart';
import 'utils/memory_manager.dart';
import 'utils/cache_manager.dart';
import 'widgets/performance_monitor.dart';

/// 性能优化示例页面
class PerformanceOptimizationDemo extends ConsumerStatefulWidget {
  const PerformanceOptimizationDemo({Key? key}) : super(key: key);

  @override
  ConsumerState<PerformanceOptimizationDemo> createState() => 
      _PerformanceOptimizationDemoState();
}

class _PerformanceOptimizationDemoState 
    extends ConsumerState<PerformanceOptimizationDemo> {
  final PerformanceService _performanceService = PerformanceService();
  final MemoryManager _memoryManager = MemoryManager();
  final CacheManager _cacheManager = CacheManager();
  final BackgroundService _backgroundService = BackgroundService();

  bool _isInitialized = false;
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  /// 初始化服务
  Future<void> _initializeServices() async {
    await _performanceService.initialize();
    await _memoryManager.initialize();
    await _cacheManager.initialize();
    await _backgroundService.initialize();

    setState(() {
      _isInitialized = true;
    });

    // 启动定期统计更新
    Timer.periodic(const Duration(seconds: 2), (_) {
      _updateStats();
    });
  }

  /// 更新统计信息
  void _updateStats() {
    setState(() {
      _stats = _performanceService.getPerformanceStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('性能优化演示'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isInitialized ? _buildBody() : _buildLoading(),
      floatingActionButton: _buildFAB(),
    );
  }

  /// 构建主体内容
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('性能监控'),
          _buildPerformanceCards(),
          const SizedBox(height: 24),
          
          _buildSectionTitle('内存管理'),
          _buildMemoryCards(),
          const SizedBox(height: 24),
          
          _buildSectionTitle('缓存管理'),
          _buildCacheCards(),
          const SizedBox(height: 24),
          
          _buildSectionTitle('后台服务'),
          _buildBackgroundCards(),
          const SizedBox(height: 24),
          
          _buildSectionTitle('操作按钮'),
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// 构建加载界面
  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('正在初始化性能服务...'),
        ],
      ),
    );
  }

  /// 构建分区标题
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  /// 构建性能卡片
  Widget _buildPerformanceCards() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.speed, color: Colors.blue),
                const SizedBox(width: 8),
                const Text('性能统计', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('活动指标: ${_stats['active_metrics'] ?? 0}'),
                Text('事件数量: ${_stats['event_count'] ?? 0}'),
              ],
            ),
            const SizedBox(height: 8),
            Text('监控状态: ${_stats['is_monitoring'] == true ? '运行中' : '已停止'}'),
          ],
        ),
      ),
    );
  }

  /// 构建内存卡片
  Widget _buildMemoryCards() {
    final memoryInfo = _memoryManager.getCurrentMemoryInfo();
    final memoryStats = _memoryManager.getMemoryStats();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.memory, color: Colors.green),
                const SizedBox(width: 8),
                const Text('内存信息', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('已使用: ${memoryInfo.usedMB.toStringAsFixed(1)} MB'),
                Text('使用率: ${memoryInfo.usagePercent.toStringAsFixed(1)}%'),
              ],
            ),
            const SizedBox(height: 8),
            Text('泄漏嫌疑: ${memoryStats.leakSuspects} 个'),
            const SizedBox(height: 8),
            Text('快照数量: ${memoryStats.snapshotCount} 个'),
          ],
        ),
      ),
    );
  }

  /// 构建缓存卡片
  Widget _buildCacheCards() {
    final cacheStats = _cacheManager.getCacheStats();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.storage, color: Colors.orange),
                const SizedBox(width: 8),
                const Text('缓存统计', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('内存项: ${cacheStats.memoryEntries}'),
                Text('磁盘项: ${cacheStats.diskEntries}'),
              ],
            ),
            const SizedBox(height: 8),
            Text('命中率: ${(cacheStats.memoryHitRate * 100).toStringAsFixed(1)}%'),
            const SizedBox(height: 8),
            Text('总命中: ${cacheStats.totalHits} / 总未命中: ${cacheStats.totalMisses}'),
          ],
        ),
      ),
    );
  }

  /// 构建后台服务卡片
  Widget _buildBackgroundCards() {
    final status = _backgroundService.getStatus();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.background_replace, color: Colors.purple),
                const SizedBox(width: 8),
                const Text('后台服务', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('运行状态: ${status.isRunning ? '运行中' : '已停止'}'),
                Text('暂停状态: ${status.isPaused ? '已暂停' : '正常'}'),
              ],
            ),
            const SizedBox(height: 8),
            Text('后台标签: ${status.backgroundTabCount} 个'),
            const SizedBox(height: 8),
            Text('冻结标签: ${status.frozenTabCount} 个'),
            const SizedBox(height: 8),
            Text('待优化任务: ${status.pendingOptimizations} 个'),
          ],
        ),
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _performMemoryCleanup,
                icon: const Icon(Icons.cleaning_services),
                label: const Text('内存清理'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _clearCache,
                icon: const Icon(Icons.delete_sweep),
                label: const Text('清理缓存'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _addTestTab,
                icon: const Icon(Icons.add),
                label: const Text('添加测试标签'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _generatePerformanceReport,
                icon: const Icon(Icons.analytics),
                label: const Text('生成报告'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _showPerformanceMonitor,
            icon: const Icon(Icons.monitor),
            label: const Text('显示性能监控面板'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
          ),
        ),
      ],
    );
  }

  /// 构建悬浮按钮
  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: _showPerformanceMonitor,
      backgroundColor: Colors.blue,
      child: const Icon(Icons.monitor, color: Colors.white),
    );
  }

  /// 执行内存清理
  void _performMemoryCleanup() {
    _memoryManager.forceCleanup();
    _showMessage('内存清理完成');
  }

  /// 清理缓存
  void _clearCache() {
    _cacheManager.clearOldestEntries();
    _showMessage('缓存清理完成');
  }

  /// 添加测试标签页
  void _addTestTab() {
    final tabId = 'test_tab_${DateTime.now().millisecondsSinceEpoch}';
    _backgroundService.addBackgroundTab(tabId, TabInfo(
      id: tabId,
      url: 'https://example.com',
      title: '测试页面 $tabId',
    ));
    _showMessage('已添加测试标签页');
  }

  /// 生成性能报告
  Future<void> _generatePerformanceReport() async {
    final report = await _performanceService.generateReport();
    _showMessage('性能报告已生成:\n'
      '内存使用: ${report.memoryInfo.usedMB.toStringAsFixed(1)} MB\n'
      '缓存项: ${report.cacheStats.memoryEntries + report.cacheStats.diskEntries} 个\n'
      '事件数: ${report.recentEvents.length} 个');
  }

  /// 显示性能监控面板
  void _showPerformanceMonitor() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    '性能监控面板',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildPerformanceCard('当前内存', 
                    '${_memoryManager.getCurrentMemoryInfo().usedMB.toStringAsFixed(1)} MB'),
                  const SizedBox(height: 12),
                  _buildPerformanceCard('缓存命中率', 
                    '${(_cacheManager.getCacheStats().memoryHitRate * 100).toStringAsFixed(1)}%'),
                  const SizedBox(height: 12),
                  _buildPerformanceCard('后台标签页', 
                    '${_backgroundService.getStatus().backgroundTabCount} 个'),
                  const SizedBox(height: 12),
                  _buildPerformanceCard('监控状态', 
                    _performanceService.getPerformanceStats()['is_monitoring'] == true ? '运行中' : '已停止'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建性能卡片
  Widget _buildPerformanceCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info, color: Colors.blue),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Text(value, 
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              )),
          ],
        ),
      ),
    );
  }

  /// 显示消息
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _performanceService.dispose();
    _memoryManager.dispose();
    _cacheManager.dispose();
    _backgroundService.dispose();
    super.dispose();
  }
}

/// 演示应用主页面
class PerformanceDemoApp extends StatelessWidget {
  const PerformanceDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PerformanceMonitor(
      showOverlay: true,
      enableDebugMode: true,
      child: MaterialApp(
        title: '性能优化演示',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const PerformanceOptimizationDemo(),
      ),
    );
  }
}

/// 主函数
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化性能服务
  await PerformanceService().initialize();
  await BackgroundService().initialize();
  
  runApp(const ProviderScope(
    child: PerformanceDemoApp(),
  ));
}