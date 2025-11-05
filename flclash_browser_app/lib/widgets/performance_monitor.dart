import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/performance_service.dart';
import '../utils/memory_manager.dart';
import '../utils/cache_manager.dart';

/// 性能监控Widget
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool showOverlay;
  final bool enableDebugMode;

  const PerformanceMonitor({
    Key? key,
    required this.child,
    this.showOverlay = true,
    this.enableDebugMode = false,
  }) : super(key: key);

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  final PerformanceService _performanceService = PerformanceService();
  final MemoryManager _memoryManager = MemoryManager();
  final CacheManager _cacheManager = CacheManager();

  // 状态
  bool _isVisible = false;
  Map<String, dynamic> _currentStats = {};
  List<PerformanceEvent> _recentEvents = [];
  
  // 性能数据
  double _cpuUsage = 0.0;
  double _memoryUsage = 0.0;
  double _fps = 60.0;
  int _frameCount = 0;
  DateTime _lastFrameTime = DateTime.now();

  StreamSubscription<PerformanceEvent>? _eventSubscription;
  StreamSubscription<MemoryEvent>? _memorySubscription;

  @override
  void initState() {
    super.initState();
    _initializePerformanceMonitoring();
    _startFrameRateMonitoring();
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    _memorySubscription?.cancel();
    _updateTimer?.cancel();
    super.dispose();
  }

  /// 初始化性能监控
  void _initializePerformanceMonitoring() {
    // 订阅性能事件
    _eventSubscription = _performanceService.eventStream.listen((event) {
      setState(() {
        _recentEvents.insert(0, event);
        if (_recentEvents.length > 10) {
          _recentEvents.removeLast();
        }
      });
    });

    // 订阅内存事件
    _memorySubscription = _memoryManager.eventStream.listen((event) {
      setState(() {
        _recentEvents.insert(0, PerformanceEvent(
          type: event.type == MemoryEventType.leakDetected 
              ? PerformanceEventType.performance 
              : PerformanceEventType.memory,
          timestamp: event.timestamp,
          data: {'message': event.message, ...?event.data},
        ));
        if (_recentEvents.length > 10) {
          _recentEvents.removeLast();
        }
      });
    });

    // 启动定期更新
    _startPeriodicUpdate();
  }

  /// 启动帧率监控
  void _startFrameRateMonitoring() {
    WidgetsBinding.instance.addPersistentFrameCallback((duration) {
      _updateFPS(duration);
    });
  }

  /// 更新FPS
  void _updateFPS(Duration duration) {
    final now = DateTime.now();
    final deltaTime = now.difference(_lastFrameTime).inMilliseconds;
    
    if (deltaTime >= 1000) {
      setState(() {
        _fps = (_frameCount * 1000) / deltaTime.toDouble();
        _frameCount = 0;
        _lastFrameTime = now;
      });
    } else {
      _frameCount++;
    }
  }

  Timer? _updateTimer;

  /// 启动定期更新
  void _startPeriodicUpdate() {
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _updateCurrentStats();
    });
  }

  /// 更新当前统计信息
  void _updateCurrentStats() {
    setState(() {
      _currentStats = _performanceService.getPerformanceStats();
      
      // 更新内存使用率
      final memoryInfo = _memoryManager.getCurrentMemoryInfo();
      _memoryUsage = memoryInfo.usagePercent;
      
      // 更新CPU使用率（模拟）
      _cpuUsage = _calculateCPUUsage();
    });
  }

  /// 计算CPU使用率
  double _calculateCPUUsage() {
    // 这里是一个简化的CPU使用率计算
    // 在实际应用中，您可能需要使用平台特定的方法
    return (_fps < 30) ? 80.0 : (_fps < 50) ? 50.0 : 20.0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showOverlay) _buildPerformanceOverlay(),
      ],
    );
  }

  /// 构建性能覆盖层
  Widget _buildPerformanceOverlay() {
    return Positioned(
      top: 50,
      right: 10,
      child: GestureDetector(
        onTap: () => setState(() => _isVisible = !_isVisible),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _getStatusColor(),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            _getStatusIcon(),
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  /// 获取状态颜色
  Color _getStatusColor() {
    if (_memoryUsage > 90 || _fps < 30) {
      return Colors.red;
    } else if (_memoryUsage > 70 || _fps < 45) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  /// 获取状态图标
  IconData _getStatusIcon() {
    if (_memoryUsage > 90 || _fps < 30) {
      return Icons.warning;
    } else if (_memoryUsage > 70 || _fps < 45) {
      return Icons.info;
    } else {
      return Icons.check_circle;
    }
  }

  /// 显示详细性能信息
  void _showPerformanceDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PerformanceDetailsSheet(
        stats: _currentStats,
        memoryUsage: _memoryUsage,
        cpuUsage: _cpuUsage,
        fps: _fps,
        recentEvents: _recentEvents,
        memoryManager: _memoryManager,
        cacheManager: _cacheManager,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isVisible) {
      _showPerformanceDetails();
    }
  }
}

/// 性能详细信息底部表单
class _PerformanceDetailsSheet extends StatefulWidget {
  final Map<String, dynamic> stats;
  final double memoryUsage;
  final double cpuUsage;
  final double fps;
  final List<PerformanceEvent> recentEvents;
  final MemoryManager memoryManager;
  final CacheManager cacheManager;

  const _PerformanceDetailsSheet({
    required this.stats,
    required this.memoryUsage,
    required this.cpuUsage,
    required this.fps,
    required this.recentEvents,
    required this.memoryManager,
    required this.cacheManager,
  });

  @override
  State<_PerformanceDetailsSheet> createState() => 
      _PerformanceDetailsSheetState();
}

class _PerformanceDetailsSheetState extends State<_PerformanceDetailsSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;
  StreamSubscription<PerformanceEvent>? _eventSubscription;
  StreamSubscription<MemoryEvent>? _memorySubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // 继续监听事件以实时更新
    _eventSubscription = PerformanceService().eventStream.listen((event) {
      if (mounted) {
        setState(() {});
      }
    });
    
    _memorySubscription = widget.memoryManager.eventStream.listen((event) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _eventSubscription?.cancel();
    _memorySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(icon: Icon(Icons.speed), text: '性能'),
              Tab(icon: Icon(Icons.memory), text: '内存'),
              Tab(icon: Icon(Icons.storage), text: '缓存'),
              Tab(icon: Icon(Icons.bug_report), text: '事件'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPerformanceTab(),
                _buildMemoryTab(),
                _buildCacheTab(),
                _buildEventsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建头部
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            '性能监控',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// 构建性能标签页
  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetricCard('FPS', '${widget.fps.toStringAsFixed(1)}', 
            _getFPSColor(widget.fps), Icons.fps_select),
          const SizedBox(height: 12),
          _buildMetricCard('CPU使用率', '${widget.cpuUsage.toStringAsFixed(1)}%', 
            _getCPUColor(widget.cpuUsage), Icons.memory),
          const SizedBox(height: 12),
          _buildMetricCard('内存使用率', '${widget.memoryUsage.toStringAsFixed(1)}%', 
            _getMemoryColor(widget.memoryUsage), Icons.memory),
          const SizedBox(height: 24),
          const Text(
            '实时监控',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildRealtimeChart(),
        ],
      ),
    );
  }

  /// 构建内存标签页
  Widget _buildMemoryTab() {
    final memoryStats = widget.memoryManager.getMemoryStats();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetricCard('当前内存', 
            '${memoryStats.currentMemory.usedMB.toStringAsFixed(1)} MB', 
            Colors.blue, Icons.memory),
          const SizedBox(height: 12),
          _buildMetricCard('总内存', 
            '${memoryStats.currentMemory.totalMB.toStringAsFixed(1)} MB', 
            Colors.green, Icons.storage),
          const SizedBox(height: 12),
          _buildMetricCard('可用内存', 
            '${memoryStats.currentMemory.availableMB.toStringAsFixed(1)} MB', 
            Colors.orange, Icons.available_storage),
          const SizedBox(height: 12),
          _buildMetricCard('泄漏嫌疑', '${memoryStats.leakSuspects}', 
            memoryStats.leakSuspects > 0 ? Colors.red : Colors.green, 
            Icons.warning),
          const SizedBox(height: 24),
          const Text(
            '内存池状态',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...memoryStats.poolSizes.entries.map((entry) => 
            _buildPoolStatus(entry.key, entry.value)),
        ],
      ),
    );
  }

  /// 构建缓存标签页
  Widget _buildCacheTab() {
    final cacheStats = widget.cacheManager.getCacheStats();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetricCard('内存缓存项', '${cacheStats.memoryEntries}', 
            Colors.blue, Icons.memory),
          const SizedBox(height: 12),
          _buildMetricCard('磁盘缓存项', '${cacheStats.diskEntries}', 
            Colors.green, Icons.storage),
          const SizedBox(height: 12),
          _buildMetricCard('内存命中率', 
            '${(cacheStats.memoryHitRate * 100).toStringAsFixed(1)}%', 
            _getHitRateColor(cacheStats.memoryHitRate), Icons.trending_up),
          const SizedBox(height: 12),
          _buildMetricCard('磁盘命中率', 
            '${(cacheStats.diskHitRate * 100).toStringAsFixed(1)}%', 
            _getHitRateColor(cacheStats.diskHitRate), Icons.trending_up),
          const SizedBox(height: 24),
          _buildMetricCard('总命中', '${cacheStats.totalHits}', 
            Colors.green, Icons.check_circle),
          const SizedBox(height: 12),
          _buildMetricCard('总未命中', '${cacheStats.totalMisses}', 
            Colors.red, Icons.cancel),
        ],
      ),
    );
  }

  /// 构建事件标签页
  Widget _buildEventsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.recentEvents.length,
      itemBuilder: (context, index) {
        final event = widget.recentEvents[index];
        return _buildEventItem(event);
      },
    );
  }

  /// 构建指标卡片
  Widget _buildMetricCard(String title, String value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建池状态
  Widget _buildPoolStatus(String poolName, int size) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.data_object, color: Colors.blue),
            const SizedBox(width: 12),
            Text(poolName),
            const Spacer(),
            Text('$size 项'),
          ],
        ),
      ),
    );
  }

  /// 构建事件项
  Widget _buildEventItem(PerformanceEvent event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          _getEventIcon(event.type),
          color: _getEventColor(event.type),
        ),
        title: Text(_getEventTitle(event)),
        subtitle: Text(
          '${event.timestamp.hour.toString().padLeft(2, '0')}:'
          '${event.timestamp.minute.toString().padLeft(2, '0')}:'
          '${event.timestamp.second.toString().padLeft(2, '0')} - '
          '${event.data.toString()}',
        ),
      ),
    );
  }

  /// 构建实时图表
  Widget _buildRealtimeChart() {
    // 这里可以添加一个简单的实时图表
    // 暂时用文本代替
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text('实时性能图表\n(需要集成图表库)', 
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  /// 获取FPS颜色
  Color _getFPSColor(double fps) {
    if (fps < 30) return Colors.red;
    if (fps < 45) return Colors.orange;
    return Colors.green;
  }

  /// 获取CPU颜色
  Color _getCPUColor(double cpu) {
    if (cpu > 80) return Colors.red;
    if (cpu > 50) return Colors.orange;
    return Colors.green;
  }

  /// 获取内存颜色
  Color _getMemoryColor(double memory) {
    if (memory > 90) return Colors.red;
    if (memory > 70) return Colors.orange;
    return Colors.green;
  }

  /// 获取命中率颜色
  Color _getHitRateColor(double rate) {
    if (rate < 0.5) return Colors.red;
    if (rate < 0.8) return Colors.orange;
    return Colors.green;
  }

  /// 获取事件图标
  IconData _getEventIcon(PerformanceEventType type) {
    switch (type) {
      case PerformanceEventType.memory:
        return Icons.memory;
      case PerformanceEventType.performance:
        return Icons.speed;
      case PerformanceEventType.cleanup:
        return Icons.cleaning_services;
      case PerformanceEventType.gc:
        return Icons.recycling;
      case PerformanceEventType.measurement:
        return Icons.timer;
      case PerformanceEventType.error:
        return Icons.error;
    }
  }

  /// 获取事件颜色
  Color _getEventColor(PerformanceEventType type) {
    switch (type) {
      case PerformanceEventType.memory:
        return Colors.blue;
      case PerformanceEventType.performance:
        return Colors.orange;
      case PerformanceEventType.cleanup:
        return Colors.green;
      case PerformanceEventType.gc:
        return Colors.purple;
      case PerformanceEventType.measurement:
        return Colors.cyan;
      case PerformanceEventType.error:
        return Colors.red;
    }
  }

  /// 获取事件标题
  String _getEventTitle(PerformanceEvent event) {
    switch (event.type) {
      case PerformanceEventType.memory:
        return '内存事件';
      case PerformanceEventType.performance:
        return '性能事件';
      case PerformanceEventType.cleanup:
        return '清理事件';
      case PerformanceEventType.gc:
        return '垃圾回收';
      case PerformanceEventType.measurement:
        return '性能测量';
      case PerformanceEventType.error:
        return '错误事件';
    }
  }
}