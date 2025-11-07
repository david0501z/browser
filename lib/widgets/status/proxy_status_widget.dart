import 'package:flutter/material.dart';
import '../../providers/proxy_widget_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/proxy_state.dart';

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

            // 流量统计
            if (isConnected) ...[
              _TrafficStatsCard(
                connectionState: proxyState.connectionState,
              ),
              const SizedBox(height: 16),
            ],

            // 操作按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: isConnected ? Icons.link_off : Icons.link,
                  label: isConnected ? '断开' : '连接',
                  onPressed: () {
                    final operations = ref.read(proxyOperationsProvider);
                    if (isConnected) {
                      operations.disconnect();
                    } else {
                      operations.smartConnect();
                    }
                  },
                ),
                _ActionButton(
                  icon: Icons.settings,
                  label: '设置',
                  onPressed: () {
                    // 打开设置页面
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 状态指示器
class _StatusIndicator extends StatelessWidget {
  final ProxyStatus status;

  const _StatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
        statusColor = theme.primaryColor;
        statusIcon = Icons.refresh;
        statusText = '连接中';
        break;
      case ProxyStatus.disconnected:
        statusColor = Colors.grey;
        statusIcon = Icons.link_off;
        statusText = '已断开';
        break;
      case ProxyStatus.error:
        statusColor = Colors.red;
        statusIcon = Icons.error;
        statusText = '连接错误';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusText,
              style: theme.textTheme.titleMedium?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 服务器信息卡片
class _ServerInfoCard extends StatelessWidget {
  final ProxyServer server;

  const _ServerInfoCard({required this.server});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.dns,
                color: theme.colorScheme.onSurface,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  server.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (server.latency != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getLatencyColor(server.latency!, context).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${server.latency}ms',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getLatencyColor(server.latency!, context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${server.server}:${server.port}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Color _getLatencyColor(int latency, BuildContext context) {
    if (latency < 50) return Colors.green;
    if (latency < 100) return Colors.orange;
    return Colors.red;
  }
}

/// 流量统计卡片
class _TrafficStatsCard extends StatelessWidget {
  final ProxyConnectionState connectionState;

  const _TrafficStatsCard({required this.connectionState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.speed,
                color: theme.colorScheme.onSurface,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                '流量统计',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _TrafficItem(
                  label: '上传速度',
                  value: _formatSpeed(connectionState.uploadSpeed),
                  icon: Icons.upload,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _TrafficItem(
                  label: '下载速度',
                  value: _formatSpeed(connectionState.downloadSpeed),
                  icon: Icons.download,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _TrafficItem(
                  label: '已上传',
                  value: _formatBytes(connectionState.uploadBytes),
                  icon: Icons.upload_outlined,
                  color: theme.colorScheme.primary.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _TrafficItem(
                  label: '已下载',
                  value: _formatBytes(connectionState.downloadBytes),
                  icon: Icons.download_outlined,
                  color: theme.colorScheme.secondary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  String _formatSpeed(int bytesPerSecond) {
    if (bytesPerSecond < 1024) return '${bytesPerSecond}B/s';
    if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)}KB/s';
    }
    return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(1)}MB/s';
  }
}

/// 流量项目
class _TrafficItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _TrafficItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// 操作按钮
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}