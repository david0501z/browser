import 'package:flutter/material.dart';
import '../../providers/proxy_widget_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 流量统计显示组件
/// 用于显示代理的实时流量统计信息
class TrafficMeterWidget extends ConsumerWidget {
  const TrafficMeterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trafficStats = ref.watch(proxyTrafficStatsProvider);
    final formattedStats = ref.watch(formattedProxyTrafficProvider);
    final isConnected = ref.watch(isConnectedProvider);

    return Card(
      elevation: 2,
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
                  Icons.speed,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '流量统计',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                if (isConnected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: 8,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '在线',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            if (!isConnected) ...[
              // 未连接状态
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.link_off,
                      color: Colors.grey,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '代理未连接',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // 实时速度
              _SpeedIndicator(
                uploadSpeed: formattedStats.uploadSpeedFormatted,
                downloadSpeed: formattedStats.downloadSpeedFormatted,
              ),
              const SizedBox(height: 16),

              // 流量统计
              _TrafficStatsRow(
                uploadBytes: formattedStats.uploadBytesFormatted,
                downloadBytes: formattedStats.downloadBytesFormatted,
              ),
              const SizedBox(height: 16),

              // 流量图表（简化版）
              _TrafficChart(
                uploadData: [10, 25, 15, 30, 20, 35, 25],
                downloadData: [15, 20, 35, 25, 40, 30, 45],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 速度指示器
class _SpeedIndicator extends StatelessWidget {
  final String uploadSpeed;
  final String downloadSpeed;

  const _SpeedIndicator({
    required this.uploadSpeed,
    required this.downloadSpeed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.upload,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '上传',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  uploadSpeed,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: theme.colorScheme.outline.withOpacity(0.3),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.download,
                      color: theme.colorScheme.secondary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '下载',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  downloadSpeed,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 流量统计行
class _TrafficStatsRow extends StatelessWidget {
  final String uploadBytes;
  final String downloadBytes;

  const _TrafficStatsRow({
    required this.uploadBytes,
    required this.downloadBytes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Expanded(
          child: _TrafficStatItem(
            label: '总上传',
            value: uploadBytes,
            icon: Icons.upload_outlined,
            color: theme.colorScheme.primary.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _TrafficStatItem(
            label: '总下载',
            value: downloadBytes,
            icon: Icons.download_outlined,
            color: theme.colorScheme.secondary.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

/// 流量统计项
class _TrafficStatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _TrafficStatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
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
      ),
    );
  }
}

/// 流量图表（简化版）
class _TrafficChart extends StatelessWidget {
  final List<int> uploadData;
  final List<int> downloadData;

  const _TrafficChart({
    required this.uploadData,
    required this.downloadData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxValue = [...uploadData, ...downloadData].reduce((a, b) => a > b ? a : b);
    
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          // 图表
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < uploadData.length; i++) ...[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // 上传柱状图
                        Container(
                          height: (uploadData[i] / maxValue * 30).toDouble(),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(2),
                              topRight: Radius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // 下载柱状图
                        Container(
                          height: (downloadData[i] / maxValue * 30).toDouble(),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(2),
                              bottomRight: Radius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < uploadData.length - 1) const SizedBox(width: 2),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          // 图例
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '上传',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '下载',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}