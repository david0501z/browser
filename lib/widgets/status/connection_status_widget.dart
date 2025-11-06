import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              const SizedBox(height: 16),
            ] else ...[
              _DisconnectedStatePanel(
                isConnecting: isConnecting,
                operations: operations,
                availableServers: availableServers,
              ),
              const SizedBox(height: 16),
            ],

            // 服务器列表
            if (availableServers.isNotEmpty) ...[
              _ServerListPanel(
                availableServers: availableServers,
                currentServer: currentServer,
                operations: operations,
              ),
              const SizedBox(height: 16),
            ],

            // 连接选项
            _ConnectionOptions(operations: operations),
          ],
        ),
      ),
    );
  }
}

/// 连接状态徽章
class _ConnectionStatusBadge extends StatelessWidget {
  const _ConnectionStatusBadge({required this.status});

  final ProxyStatus status;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (status) {
      case ProxyStatus.connected:
        statusColor = Colors.green;
        statusText = '已连接';
        break;
      case ProxyStatus.connecting:
        statusColor = Colors.orange;
        statusText = '连接中';
        break;
      case ProxyStatus.disconnecting:
        statusColor = Colors.orange;
        statusText = '断开中';
        break;
      case ProxyStatus.error:
        statusColor = Colors.red;
        statusText = '错误';
        break;
      case ProxyStatus.disconnected:
      default:
        statusColor = Colors.grey;
        statusText = '未连接';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == ProxyStatus.connecting);
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            )
          else
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor,
              ),
            ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

/// 已连接状态面板
class _ConnectedStatePanel extends StatelessWidget {
  const _ConnectedStatePanel({
    required this.currentServer,
    required this.operations,
  });

  final ProxyServer? currentServer;
  final ProxyOperations operations;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '连接成功',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => operations.disconnect(),
                icon: const Icon(Icons.link_off, size: 16),
                label: const Text('断开'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          if (currentServer != null) ...[;
            const SizedBox(height: 12),
            _ServerConnectionInfo(server: currentServer!),
          ],
        ],
      ),
    );
  }
}

/// 服务器连接信息
class _ServerConnectionInfo extends StatelessWidget {
  const _ServerConnectionInfo({required this.server});

  final ProxyServer server;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(
            Icons.dns,
            color: Theme.of(context).primaryColor,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                server.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                '${server.server}:${server.port} (${server.protocol.value})',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
        if (server.latency != null) ...[;
          const SizedBox(width: 8),
          _LatencyIndicator(latency: server.latency!),
        ],
      ],
    );
  }
}

/// 延迟指示器
class _LatencyIndicator extends StatelessWidget {
  const _LatencyIndicator({required this.latency});

  final int latency;

  @override
  Widget build(BuildContext context) {
    Color latencyColor;
    IconData latencyIcon;

    if (latency < 100) {
      latencyColor = Colors.green;
      latencyIcon = Icons.signal_wifi_4_bar;
    } else if (latency < 300) {
      latencyColor = Colors.orange;
      latencyIcon = Icons.signal_wifi_3_bar;
    } else if (latency < 500) {
      latencyColor = Colors.orange[700]!;
      latencyIcon = Icons.signal_wifi_2_bar;
    } else {
      latencyColor = Colors.red;
      latencyIcon = Icons.signal_wifi_1_bar;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: latencyColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            latencyIcon,
            color: latencyColor,
            size: 14,
          ),
          const SizedBox(width: 2),
          Text(
            '${latency}ms',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: latencyColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

/// 未连接状态面板
class _DisconnectedStatePanel extends StatelessWidget {
  const _DisconnectedStatePanel({
    required this.isConnecting,
    required this.operations,
    required this.availableServers,
  });

  final bool isConnecting;
  final ProxyOperations operations;
  final List<ProxyServer> availableServers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.link_off,
                color: Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '未连接',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (availableServers.isNotEmpty) ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isConnecting ? null : () => operations.smartConnect(),
                    icon: isConnecting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.autorenew, size: 16),
                    label: const Text('智能连接'),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isConnecting ? null : () => operations.disconnect(),
                  icon: const Icon(Icons.link, size: 16),
                  label: const Text('手动连接'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (availableServers.isEmpty) ...[
            const SizedBox(height: 12),
            Text(
              '没有可用的代理服务器，请先添加服务器配置',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.orange,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 服务器列表面板
class _ServerListPanel extends StatelessWidget {
  const _ServerListPanel({
    required this.availableServers,
    required this.currentServer,
    required this.operations,
  });

  final List<ProxyServer> availableServers;
  final ProxyServer? currentServer;
  final ProxyOperations operations;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '可用服务器 (${availableServers.length})',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: availableServers.length,
          itemBuilder: (context, index) {
            final server = availableServers[index];
            final isCurrentServer = currentServer?.id == server.id;
            
            return _ServerListItem(
              server: server,
              isCurrentServer: isCurrentServer,
              operations: operations,
            );
          },
        ),
      ],
    );
  }
}

/// 服务器列表项
class _ServerListItem extends StatelessWidget {
  const _ServerListItem({
    required this.server,
    required this.isCurrentServer,
    required this.operations,
  });

  final ProxyServer server;
  final bool isCurrentServer;
  final ProxyOperations operations;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentServer
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentServer
              ? Theme.of(context).primaryColor.withOpacity(0.3)
              : Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        server.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    if (isCurrentServer)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '当前',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${server.server}:${server.port}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                if (server.latency != null) ...[;
                  const SizedBox(height: 4),
                  _LatencyIndicator(latency: server.latency!),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              if (!isCurrentServer)
                ElevatedButton(
                  onPressed: () => operations.connect(serverId: server.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(60, 32),
                  ),
                  child: const Text('连接'),
                ),
              const SizedBox(height: 4),
              IconButton(
                onPressed: () => operations.testServer(server.id),
                icon: const Icon(Icons.speed, size: 16),
                tooltip: '测试延迟',
                style: IconButton.styleFrom(
                  minimumSize: const Size(32, 32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 连接选项面板
class _ConnectionOptions extends StatelessWidget {
  const _ConnectionOptions({required this.operations});

  final ProxyOperations operations;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '连接选项',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // 显示添加服务器对话框
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('添加服务器'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // 显示导入配置对话框
                },
                icon: const Icon(Icons.file_upload, size: 16),
                label: const Text('导入配置'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}