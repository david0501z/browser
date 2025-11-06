import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 流量统计组件
/// 用于实时显示网络流量数据，包括上传/下载速度和总量
class TrafficMeterWidget extends ConsumerWidget {
  const TrafficMeterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trafficStats = ref.watch(proxyTrafficStatsProvider);
    final formattedTraffic = ref.watch(formattedProxyTrafficProvider);
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
                  Icons.show_chart,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '流量统计',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                if (isConnected)
                  _RealtimeIndicator(),
              ],
            ),
            const SizedBox(height: 16),

            // 流量可视化图表
            _TrafficVisualization(
              uploadBytes: trafficStats.uploadBytes,
              downloadBytes: trafficStats.downloadBytes,
              uploadSpeed: trafficStats.uploadSpeed,
              downloadSpeed: trafficStats.downloadSpeed,
              isConnected: isConnected,
            ),
            const SizedBox(height: 16),

            // 详细统计信息
            _DetailedTrafficStats(formattedTraffic: formattedTraffic),
            const SizedBox(height: 16),

            // 流量历史
            _TrafficHistory(),
          ],
        ),
      ),
    );
  }
}

/// 实时指示器
class _RealtimeIndicator extends StatefulWidget {
  @override
  State<_RealtimeIndicator> createState() => _RealtimeIndicatorState();
}

class _RealtimeIndicatorState extends State<_RealtimeIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
              Text(
                '实时',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 流量可视化组件
class _TrafficVisualization extends StatelessWidget {
  const _TrafficVisualization({
    required this.uploadBytes,
    required this.downloadBytes,
    required this.uploadSpeed,
    required this.downloadSpeed,
    required this.isConnected,
  });

  final int uploadBytes;
  final int downloadBytes;
  final int uploadSpeed;
  final int downloadSpeed;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: isConnected
          ? Row(
              children: [
                // 上传进度条
                Expanded(
                  child: _SpeedBar(
                    label: '上传',
                    speed: uploadSpeed,
                    color: Colors.blue,
                    maxSpeed: _calculateMaxSpeed(uploadSpeed, downloadSpeed),
                  ),
                ),
                const SizedBox(width: 16),
                // 下载进度条
                Expanded(
                  child: _SpeedBar(
                    label: '下载',
                    speed: downloadSpeed,
                    color: Colors.green,
                    maxSpeed: _calculateMaxSpeed(uploadSpeed, downloadSpeed),
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.link_off,
                    size: 32,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '未连接',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
    );
  }

  int _calculateMaxSpeed(int upload, int download) {
    final max = upload > download ? upload : download;
    return max > 0 ? max : 1024 * 1024; // 默认 1MB/s
  }
}

/// 速度进度条组件
class _SpeedBar extends StatelessWidget {
  const _SpeedBar({
    required this.label,
    required this.speed,
    required this.color,
    required this.maxSpeed,
  });

  final String label;
  final int speed;
  final Color color;
  final int maxSpeed;

  @override
  Widget build(BuildContext context) {
    final progress = maxSpeed > 0 ? speed / maxSpeed : 0.0;
    final formattedSpeed = _formatSpeed(speed);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const Spacer(),
            Text(
              formattedSpeed,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
      ],
    );
  }

  String _formatSpeed(int bytesPerSecond) {
    if (bytesPerSecond < 1024) return '${bytesPerSecond}B/s';
    if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)}KB/s';
    }
    return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(1)}MB/s';
  }
}

/// 详细流量统计信息
class _DetailedTrafficStats extends StatelessWidget {
  const _DetailedTrafficStats({required this.formattedTraffic});

  final FormattedTrafficStats formattedTraffic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _TrafficStatCard(
                icon: Icons.upload,
                label: '总上传',
                value: formattedTraffic.uploadBytesFormatted,
                speed: formattedTraffic.uploadSpeedFormatted,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TrafficStatCard(
                icon: Icons.download,
                label: '总下载',
                value: formattedTraffic.downloadBytesFormatted,
                speed: formattedTraffic.downloadSpeedFormatted,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 总体统计
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.data_usage,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '总流量',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Text(
                _calculateTotalTraffic(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _calculateTotalTraffic() {
    // 简化计算，实际应该从数据模型获取
    final totalBytes = formattedTraffic.uploadBytesFormatted + formattedTraffic.downloadBytesFormatted;
    return totalBytes;
  }
}

/// 流量统计卡片
class _TrafficStatCard extends StatelessWidget {
  const _TrafficStatCard({
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
            '速度: $speed',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}

/// 流量历史组件
class _TrafficHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '流量历史',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              '流量历史图表（待实现）',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 格式化流量统计扩展
extension TrafficFormatter on FormattedTrafficStats {
  String get totalTraffic {
    // 简单的流量总和计算（实际应该考虑单位转换）
    return '$uploadBytesFormatted + $downloadBytesFormatted';
  }
}