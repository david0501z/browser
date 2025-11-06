import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/proxy_state.dart';
import '../../providers/proxy_providers.dart';

/// 代理状态指示器组件
/// 用于显示当前代理的状态，包括连接状态、服务器信息等
class ProxyStatusWidget extends ConsumerWidget {
  const ProxyStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proxyState = ref.watch(globalProxyStateProvider);
    final currentServer = ref.watch(currentProxyServerProvider);
    final isConnected = ref.watch(isConnectedProvider);

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
                  Icons.security,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '代理状态',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 状态指示器
            _StatusIndicator(status: proxyState.status),
            const SizedBox(height: 16),

            // 当前服务器信息
            if (currentServer != null && isConnected) ...[
              _ServerInfoCard(server: currentServer),
              const SizedBox(height: 16),
            ],

            // 连接统计信息
            _ConnectionStatsCard(connectionState: proxyState.connectionState),
            const SizedBox(height: 16),

            // 全局代理设置
            _GlobalProxyToggle(isEnabled: proxyState.isGlobalProxy),
          ],
        ),
      ),
    );
  }
}

/// 状态指示器子组件
class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({required this.status});

  final ProxyStatus status;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status) {
      case ProxyStatus.connected:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = '已连接';
        break;
      case ProxyStatus.connecting:
        statusColor = Colors.orange;
        statusIcon = Icons.sync;
        statusText = '连接中';
        break;
      case ProxyStatus.disconnecting:
        statusColor = Colors.orange;
        statusIcon = Icons.sync_disabled;
        statusText = '断开连接中';
        break;
      case ProxyStatus.error:
        statusColor = Colors.red;
        statusIcon = Icons.error;
        statusText = '连接错误';
        break;
      case ProxyStatus.disconnected:
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.cancel;
        statusText = '未连接';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          AnimatedRotation(
            duration: status == ProxyStatus.connecting 
                ? const Duration(seconds: 1) 
                : Duration.zero,
            turns: status == ProxyStatus.connecting ? 1 : 0,
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (status == ProxyStatus.error) ...[
                  const SizedBox(height: 4),
                  Text(
                    '请检查网络连接和代理配置',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 服务器信息卡片
class _ServerInfoCard extends StatelessWidget {
  const _ServerInfoCard({required this.server});

  final ProxyServer server;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Icon(
              Icons.dns,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  server.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${server.server}:${server.port}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          if (server.latency != null)
            _LatencyIndicator(latency: server.latency!),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: latencyColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            latencyIcon,
            color: latencyColor,
            size: 16,
          ),
          const SizedBox(width: 4),
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

/// 连接统计信息卡片
class _ConnectionStatsCard extends ConsumerWidget {
  const _ConnectionStatsCard({required this.connectionState});

  final ProxyConnectionState connectionState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedStats = ref.watch(formattedProxyTrafficProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '连接统计',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _StatItem(
                icon: Icons.upload,
                label: '上传',
                value: formattedStats.uploadBytesFormatted,
                speed: formattedStats.uploadSpeedFormatted,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatItem(
                icon: Icons.download,
                label: '下载',
                value: formattedStats.downloadBytesFormatted,
                speed: formattedStats.downloadSpeedFormatted,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 统计项组件
class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.speed,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String speed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            speed,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}

/// 全局代理切换组件
class _GlobalProxyToggle extends ConsumerWidget {
  const _GlobalProxyToggle({required this.isEnabled});

  final bool isEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operations = ref.watch(proxyOperationsProvider);

    return Row(
      children: [
        Icon(
          Icons.public,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '全局代理',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                isEnabled ? '所有应用都将通过代理访问网络' : '仅当前应用使用代理',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
        Switch(
          value: isEnabled,
          onChanged: (value) {
            operations.setGlobalProxy(value);
          },
        ),
      ],
    );
  }
}