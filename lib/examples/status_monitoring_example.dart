import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 代理状态监控示例页面
/// 
/// 这个例子展示了如何使用代理状态指示器和监控组件
/// 包括：
/// - 代理状态指示器
/// - 流量统计组件
/// - 连接状态组件
/// 
class ProxyStatusMonitoringExample extends ConsumerStatefulWidget {
  const ProxyStatusMonitoringExample({super.key});

  @override
  ConsumerState<ProxyStatusMonitoringExample> createState() => _ProxyStatusMonitoringExampleState();
}

class _ProxyStatusMonitoringExampleState extends ConsumerState<ProxyStatusMonitoringExample> {
  bool _isMonitoring = false;

  @override
  void initState() {
    super.initState();
    
    // 添加状态变更监听器
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupStatusListeners();
    });
  }

  /// 设置状态监听器
  void _setupStatusListeners() {
    final notifier = ref.read(statusChangeNotifierProvider.notifier);
    
    notifier.addListener(
      DefaultStatusChangeListener(
        onStatusChanged: (previous, current) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('代理状态变更: ${previous.value} -> ${current.value}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        onConnectionChanged: (previous, current) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('连接状态: ${current.isConnected ? "已连接" : "已断开"}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        onTrafficChanged: (previous, current) {
          // 流量变化监听（可用于更新图表等）
          print('流量更新: 上传 ${current.uploadSpeed} B/s, 下载 ${current.downloadSpeed} B/s');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final proxyState = ref.watch(globalProxyStateProvider);
    final trafficStats = ref.watch(formattedProxyTrafficProvider);
    final isConnected = ref.watch(isConnectedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('代理状态监控'),
        actions: [
          IconButton(
            icon: Icon(_isMonitoring ? Icons.pause : Icons.play_arrow),
            onPressed: _toggleMonitoring,
            tooltip: _isMonitoring ? '停止监控' : '开始监控',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showStatusHistory,
            tooltip: '查看状态历史',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 总体状态概览
            _buildOverviewCard(),
            const SizedBox(height: 16),
            
            // 代理状态指示器
            const ProxyStatusWidget(),
            const SizedBox(height: 16),
            
            // 流量统计组件
            const TrafficMeterWidget(),
            const SizedBox(height: 16),
            
            // 连接状态组件
            const ConnectionStatusWidget(),
            const SizedBox(height: 16),
            
            // 实时信息面板
            _buildRealtimeInfoPanel(),
            const SizedBox(height: 16),
            
            // 状态变化日志
            _buildStatusLogPanel(),
          ],
        ),
      ),
    );
  }

  /// 构建概览卡片
  Widget _buildOverviewCard() {
    final proxyState = ref.watch(globalProxyStateProvider);
    final trafficStats = ref.watch(formattedProxyTrafficProvider);
    final isConnected = ref.watch(isConnectedProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '状态概览',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewItem(
                    '连接状态',
                    isConnected ? '已连接' : '未连接',
                    isConnected ? Colors.green : Colors.grey,
                    Icons.link,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildOverviewItem(
                    '上传流量',
                    trafficStats.uploadBytesFormatted,
                    Colors.blue,
                    Icons.upload,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildOverviewItem(
                    '下载流量',
                    trafficStats.downloadBytesFormatted,
                    Colors.green,
                    Icons.download,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建概览项
  Widget _buildOverviewItem(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 构建实时信息面板
  Widget _buildRealtimeInfoPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  '实时信息',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('监控状态', _isMonitoring ? '运行中' : '已停止'),
            _buildInfoRow('最后更新', DateTime.now().toString().split(' ')[1].split('.')[0]),
            _buildInfoRow('更新时间间隔', '5秒'),
          ],
        ),
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建状态日志面板
  Widget _buildStatusLogPanel() {
    final history = ref.watch(proxyStatusHistoryProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '状态变化日志',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (history.isEmpty)
              Text(
                '暂无状态变化记录',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              )
            else
              Container(
                height: 200,
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final record = history[history.length - 1 - index]; // 最新的在前;
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        _getStatusIcon(record.status),
                        color: _getStatusColor(record.status),
                        size: 20,
                      ),
                      title: Text(record.description ?? record.status.value),
                      subtitle: Text(
                        record.timestamp.toString().split(' ')[1].split('.')[0],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 切换监控状态
  void _toggleMonitoring() {
    final monitor = ref.read(proxyStatusMonitorProvider.notifier);
    
    setState(() {
      _isMonitoring = !_isMonitoring;
    });

    if (_isMonitoring) {
      monitor.startMonitoring();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('监控已开始')),
      );
    } else {
      monitor.stopMonitoring();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('监控已停止')),
      );
    }
  }

  /// 显示状态历史
  void _showStatusHistory() {
    final history = ref.read(proxyStatusHistoryProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('状态变化历史'),
        content: SizedBox(
          width: double.maxFinite,
          child: history.isEmpty
              ? const Text('暂无历史记录')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final record = history[history.length - 1 - index];
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        _getStatusIcon(record.status),
                        color: _getStatusColor(record.status),
                        size: 20,
                      ),
                      title: Text(record.description ?? record.status.value),
                      subtitle: Text(
                        record.timestamp.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
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

  /// 获取状态图标
  IconData _getStatusIcon(ProxyStatus status) {
    switch (status) {
      case ProxyStatus.connected:
        return Icons.check_circle;
      case ProxyStatus.connecting:
        return Icons.sync;
      case ProxyStatus.disconnecting:
        return Icons.sync_disabled;
      case ProxyStatus.error:
        return Icons.error;
      case ProxyStatus.disconnected:
      default:
        return Icons.cancel;
    }
  }

  /// 获取状态颜色
  Color _getStatusColor(ProxyStatus status) {
    switch (status) {
      case ProxyStatus.connected:
        return Colors.green;
      case ProxyStatus.connecting:
        return Colors.orange;
      case ProxyStatus.disconnecting:
        return Colors.orange;
      case ProxyStatus.error:
        return Colors.red;
      case ProxyStatus.disconnected:
      default:
        return Colors.grey;
    }
  }
}

/// 简单的状态监控页面
class SimpleStatusMonitor extends ConsumerWidget {
  const SimpleStatusMonitor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ProxyStatusWidget(),
            SizedBox(height: 16),
            TrafficMeterWidget(),
            SizedBox(height: 16),
            ConnectionStatusWidget(),
          ],
        ),
      ),
    );
  }
}