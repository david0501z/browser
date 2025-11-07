/// 代理控制面板组件
/// 
/// 提供代理连接控制、状态监控和快速操作的界面组件。
/// 包括连接/断开按钮、状态指示、流量统计等功能。
library proxy_control_panel;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../models/proxy_state.dart';
import '../../providers/proxy_widget_providers.dart';
import 'proxy_status_indicator.dart';

/// 代理控制面板
/// 
/// 提供代理服务的完整控制界面，包括：
/// - 连接/断开控制
/// - 实时状态显示
/// - 流量监控
/// - 快速操作按钮
/// - 服务器信息展示
class ProxyControlPanel extends ConsumerStatefulWidget {
  /// 是否显示流量统计
  final bool showTrafficStats;
  
  /// 是否显示快速操作
  final bool showQuickActions;
  
  /// 是否显示服务器信息
  final bool showServerInfo;
  
  /// 自定义连接按钮样式
  final ButtonStyle? connectButtonStyle;
  
  /// 自定义主题颜色
  final Color? primaryColor;
  
  /// 面板紧凑模式
  final bool compact;
  
  const ProxyControlPanel({
    super.key,
    this.showTrafficStats = true,
    this.showQuickActions = true,
    this.showServerInfo = true,
    this.connectButtonStyle,
    this.primaryColor,
    this.compact = false,
  });

  @override
  ConsumerState<ProxyControlPanel> createState() => _ProxyControlPanelState();
}

class _ProxyControlPanelState extends ConsumerState<ProxyControlPanel>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  Timer? _statsUpdateTimer;
  
  @override
  void initState() {
    super.initState();
    
    // 脉冲动画用于连接中状态
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // 旋转动画用于加载状态
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    // 启动动画循环
    _startAnimations();
    
    // 定时更新统计信息
    _statsUpdateTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        // 强制重建以更新统计显示
        if (mounted) {
          setState(() {});
        }
      },
    );
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _statsUpdateTimer?.cancel();
    super.dispose();
  }
  
  /// 启动动画
  void _startAnimations() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pulseController.repeat(reverse: true);
      _rotationController.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final proxyStatus = ref.watch(proxyStatusProvider);
    final isConnected = ref.watch(isConnectedProvider);
    final isConnecting = ref.watch(isConnectingProvider);
    final trafficStats = ref.watch(formattedProxyTrafficProvider);
    final currentServer = ref.watch(currentProxyServerProvider);
    
    return Container(
      margin: widget.compact 
          ? const EdgeInsets.all(8)
          : const EdgeInsets.all(16),
      child: Card(
        elevation: widget.compact ? 2 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: widget.compact 
              ? const EdgeInsets.all(16)
              : const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题行
              _buildHeader(theme),
              
              const SizedBox(height: 16),
              
              // 状态指示器
              ProxyStatusIndicator(
                status: proxyStatus,
                compact: widget.compact,
              ),
              
              const SizedBox(height: 16),
              
              // 连接/断开按钮
              _buildConnectButton(theme, isConnected, isConnecting),
              
              if (widget.showTrafficStats && isConnected) ...[
                const SizedBox(height: 16),
                _buildTrafficStats(theme, trafficStats),
              ],
              
              if (widget.showServerInfo && currentServer != null) ...[
                const SizedBox(height: 16),
                _buildServerInfo(theme, currentServer),
              ],
              
              if (widget.showQuickActions && !widget.compact) ...[
                const SizedBox(height: 16),
                _buildQuickActions(theme),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  /// 构建标题行
  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.control_point,
          color: widget.primaryColor ?? theme.primaryColor,
          size: widget.compact ? 20 : 24,
        ),
        const SizedBox(width: 8),
        Text(
          '代理控制',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: widget.primaryColor ?? theme.primaryColor,
          ),
        ),
      ],
    );
  }
  
  /// 构建连接按钮
  Widget _buildConnectButton(ThemeData theme, bool isConnected, bool isConnecting) {
    final operations = ref.read(proxyOperationsProvider);
    final primaryColor = widget.primaryColor ?? theme.primaryColor;
    
    return SizedBox(
      width: double.infinity,
      height: widget.compact ? 48 : 56,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _rotationAnimation]),
        builder: (context, child) {
          // 连接中状态使用脉冲和旋转效果
          if (isConnecting) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: ElevatedButton.icon(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor.withOpacity(0.8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 2 * 3.14159,
                      child: const Icon(Icons.refresh, size: 20),
                    );
                  },
                ),
                label: Text(
                  '连接中...',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }
          
          // 正常状态
          return ElevatedButton.icon(
            onPressed: isConnected 
                ? () => operations.disconnect()
                : () => operations.smartConnect(),
            style: widget.connectButtonStyle ?? ElevatedButton.styleFrom(
              backgroundColor: isConnected 
                  ? Colors.red.withOpacity(0.8)
                  : primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: isConnected ? 2 : 4,
              shadowColor: isConnected 
                  ? Colors.red.withOpacity(0.3)
                  : primaryColor.withOpacity(0.3),
            ),
            icon: Icon(
              isConnected ? Icons.link_off : Icons.link,
              size: 20,
            ),
            label: Text(
              isConnected ? '断开连接' : '智能连接',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }
  
  /// 构建流量统计
  Widget _buildTrafficStats(ThemeData theme, FormattedTrafficStats stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.speed,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '流量统计',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildTrafficItem(
                  theme,
                  '上传速度',
                  stats.uploadSpeedFormatted,
                  Icons.upload,
                  theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTrafficItem(
                  theme,
                  '下载速度',
                  stats.downloadSpeedFormatted,
                  Icons.download,
                  theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: _buildTrafficItem(
                  theme,
                  '已上传',
                  stats.uploadBytesFormatted,
                  Icons.upload_outlined,
                  theme.colorScheme.primary.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTrafficItem(
                  theme,
                  '已下载',
                  stats.downloadBytesFormatted,
                  Icons.download_outlined,
                  theme.colorScheme.secondary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// 构建流量项目
  Widget _buildTrafficItem(ThemeData theme, String label, String value, IconData icon, Color color) {
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
  
  /// 构建服务器信息
  Widget _buildServerInfo(ThemeData theme, ProxyServer server) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.dns,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '当前服务器',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      server.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${server.server}:${server.port}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              if (server.latency != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getLatencyColor(server.latency!, theme).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.speed,
                        size: 12,
                        color: _getLatencyColor(server.latency!, theme),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${server.latency}ms',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getLatencyColor(server.latency!, theme),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
  
  /// 构建快速操作
  Widget _buildQuickActions(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '快速操作',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                theme,
                '测试延迟',
                Icons.speed,
                Icons.arrow_forward_ios,
                () => _testLatency(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton(
                theme,
                '切换节点',
                Icons.swap_horiz,
                Icons.arrow_forward_ios,
                () => _switchServer(),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// 构建操作按钮
  Widget _buildActionButton(ThemeData theme, String label, IconData icon, IconData trailingIcon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.dividerColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              trailingIcon,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
  
  /// 获取延迟颜色
  Color _getLatencyColor(int latency, ThemeData theme) {
    if (latency < 50) return Colors.green;
    if (latency < 100) return Colors.orange;
    return Colors.red;
  }
  
  /// 测试延迟
  void _testLatency() {
    final operations = ref.read(proxyOperationsProvider);
    final currentServer = ref.read(currentProxyServerProvider);
    
    if (currentServer != null) {
      // 显示加载状态
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('正在测试延迟...'),
          duration: Duration(seconds: 2),
        ),
      );
      
      // 执行延迟测试
      operations.testServer(currentServer.id);
    }
  }
  
  /// 切换服务器
  void _switchServer() {
    // 打开服务器选择对话框
    showDialog(
      context: context,
      builder: (context) => _ServerSelectionDialog(),
    );
  }
}

/// 服务器选择对话框
class _ServerSelectionDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ServerSelectionDialog> createState() => _ServerSelectionDialogState();
}

class _ServerSelectionDialogState extends ConsumerState<_ServerSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    final availableServers = ref.watch(availableProxyServersProvider);
    final currentServer = ref.watch(currentProxyServerProvider);
    
    return AlertDialog(
      title: const Text('选择服务器'),
      content: SizedBox(
        width: double.maxFinite,
        child: availableServers.isEmpty 
            ? const Center(child: Text('暂无可用服务器'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: availableServers.length,
                itemBuilder: (context, index) {
                  final server = availableServers[index];
                  final isSelected = server.id == currentServer?.id;
                  
                  return ListTile(
                    title: Text(server.name),
                    subtitle: Text('${server.server}:${server.port}'),
                    trailing: isSelected 
                        ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
                        : null,
                    onTap: () {
                      // 这里需要实现服务器切换逻辑
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
      ],
    );
  }
}

/// 代理控制面板样式
class ProxyControlPanelStyles {
  /// 紧凑模式内边距
  static const EdgeInsets compactPadding = EdgeInsets.all(12);
  
  /// 常规模式内边距
  static const EdgeInsets regularPadding = EdgeInsets.all(20);
  
  /// 卡片圆角
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(16));
  
  /// 按钮高度
  static const double buttonHeight = 48.0;
  
  /// 卡片间距
  static const double cardSpacing = 12.0;
  
  /// 统计项目图标大小
  static const double statIconSize = 14.0;
  
  /// 操作按钮圆角
  static const BorderRadius actionButtonRadius = BorderRadius.all(Radius.circular(8));
}