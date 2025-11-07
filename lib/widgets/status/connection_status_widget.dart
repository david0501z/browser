import 'package:flutter/material.dart';
import '../../providers/proxy_widget_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/proxy_state.dart';

/// 连接状态组件
/// 用于显示和管理代理连接状态，包括连接、断开、切换服务器等操作
class ConnectionStatusWidget extends ConsumerWidget {
  const ConnectionStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proxyStatus = ref.watch(proxyStatusProvider);
    final isConnected = ref.watch(isConnectedProvider);
    final isConnecting = ref.watch(isConnectingProvider);
    final currentServer = ref.watch(currentProxyServerProvider);
    final availableServers = ref.watch(availableProxyServersProvider);
    final operations = ref.watch(proxyOperationsProvider);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Icon(
                  Icons.network_check,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '连接管理',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                _ConnectionStatusBadge(status: proxyStatus),
              ],
            ),
            const SizedBox(height: 16),

            // 主连接控制区域
            if (isConnected) ...[
              _ConnectedStatePanel(
                currentServer: currentServer,
                operations: operations,
              ),
            ] else if (isConnecting) ...[
              _ConnectingStatePanel(
                operations: operations,
              ),
            ] else ...[
              _DisconnectedStatePanel(
                availableServers: availableServers,
                operations: operations,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 连接状态徽章
class _ConnectionStatusBadge extends StatelessWidget {
  final ProxyStatus status;

  const _ConnectionStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case ProxyStatus.connected:
        color = Colors.green;
        text = '已连接';
        icon = Icons.check_circle;
        break;
      case ProxyStatus.connecting:
        color = Colors.orange;
        text = '连接中';
        icon = Icons.refresh;
        break;
      case ProxyStatus.disconnected:
        color = Colors.grey;
        text = '已断开';
        icon = Icons.link_off;
        break;
      case ProxyStatus.error:
        color = Colors.red;
        text = '错误';
        icon = Icons.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// 已连接状态面板
class _ConnectedStatePanel extends StatelessWidget {
  final ProxyServer? currentServer;
  final ProxyOperations operations;

  const _ConnectedStatePanel({
    required this.currentServer,
    required this.operations,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // 服务器信息
        if (currentServer != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.dns,
                      color: theme.colorScheme.onSurface,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '当前服务器',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  currentServer!.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${currentServer!.server}:${currentServer!.port}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                if (currentServer!.latency != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getLatencyColor(currentServer!.latency!, context).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${currentServer!.latency}ms',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getLatencyColor(currentServer!.latency!, context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // 操作按钮
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => operations.disconnect(),
                icon: const Icon(Icons.link_off, size: 18),
                label: const Text('断开连接'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showServerSwitchDialog(context),
                icon: const Icon(Icons.swap_horiz, size: 18),
                label: const Text('切换服务器'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showServerSwitchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _ServerSwitchDialog(),
    );
  }

  Color _getLatencyColor(int latency, BuildContext context) {
    if (latency < 50) return Colors.green;
    if (latency < 100) return Colors.orange;
    return Colors.red;
  }
}

/// 连接中状态面板
class _ConnectingStatePanel extends StatelessWidget {
  final ProxyOperations operations;

  const _ConnectingStatePanel({required this.operations});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 加载动画
        Center(
          child: Column(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '正在连接代理服务器...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '请稍候，正在建立安全连接',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 取消按钮
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => operations.disconnect(),
            child: const Text('取消连接'),
          ),
        ),
      ],
    );
  }
}

/// 未连接状态面板
class _DisconnectedStatePanel extends StatelessWidget {
  final List<ProxyServer> availableServers;
  final ProxyOperations operations;

  const _DisconnectedStatePanel({
    required this.availableServers,
    required this.operations,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 连接按钮
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => operations.smartConnect(),
            icon: const Icon(Icons.link, size: 20),
            label: const Text('智能连接'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // 快速连接选项
        if (availableServers.isNotEmpty) ...[
          Text(
            '或选择服务器快速连接',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          // 显示前3个服务器
          ...availableServers.take(3).map(
            (server) => ListTile(
              leading: CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.dns,
                  size: 16,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(server.name),
              subtitle: Text('${server.server}:${server.port}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _connectToServer(context, server),
            ),
          ),
          if (availableServers.length > 3) ...[
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => _showAllServersDialog(context),
              child: Text('查看全部 ${availableServers.length} 个服务器'),
            ),
          ],
        ],
      ],
    );
  }

  void _connectToServer(BuildContext context, ProxyServer server) {
    // 模拟连接逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('正在连接到 ${server.name}...')),
    );
  }

  void _showAllServersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _ServerListDialog(),
    );
  }
}

/// 服务器切换对话框
class _ServerSwitchDialog extends StatelessWidget {
  const _ServerSwitchDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('切换服务器'),
      content: const Text('请选择要连接的服务器'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
      ],
    );
  }
}

/// 服务器列表对话框
class _ServerListDialog extends StatelessWidget {
  const _ServerListDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('所有服务器'),
      content: const Text('服务器列表功能开发中...'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('关闭'),
        ),
      ],
    );
  }
}