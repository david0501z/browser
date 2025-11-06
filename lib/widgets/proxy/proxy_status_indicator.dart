/// 代理状态指示器组件
/// 
/// 用于显示代理服务状态的视觉指示器组件。
/// 支持多种状态类型、动画效果和自定义样式。
library proxy_status_indicator;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../models/enums.dart';
import '../../../providers/proxy_providers.dart';
import '../../../themes/browser_theme.dart';

/// 代理状态指示器
/// 
/// 提供代理连接状态的视觉反馈，包括：
/// - 状态图标和颜色编码
/// - 状态描述文字
/// - 连接时间显示
/// - 动画过渡效果
/// - 自定义样式支持
class ProxyStatusIndicator extends ConsumerStatefulWidget {
  /// 代理状态
  final ProxyStatus status;
  
  /// 是否紧凑显示
  final bool compact;
  
  /// 是否显示连接时间
  final bool showConnectionTime;
  
  /// 是否显示详细状态
  final bool showDetailedStatus;
  
  /// 自定义主题颜色
  final Color? primaryColor;
  
  /// 自定义尺寸
  final double? size;
  
  /// 连接开始时间
  final DateTime? connectionStartTime;
  
  const ProxyStatusIndicator({
    super.key,
    required this.status,
    this.compact = false,
    this.showConnectionTime = true,
    this.showDetailedStatus = true,
    this.primaryColor,
    this.size,
    this.connectionStartTime,
  });

  @override
  ConsumerState<ProxyStatusIndicator> createState() => _ProxyStatusIndicatorState();
}

class _ProxyStatusIndicatorState extends ConsumerState<ProxyStatusIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  Timer? _connectionTimer;
  String _connectionTimeText = '';

  @override
  void initState() {
    super.initState();
    
    // 脉冲动画用于活跃状态
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
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    // 启动动画
    _startAnimations();
    
    // 启动连接时间计时器
    if (widget.showConnectionTime) {
      _startConnectionTimer();
    }
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _connectionTimer?.cancel();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(ProxyStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 更新计时器
    if (oldWidget.status != widget.status) {
      _updateAnimationForStatus(widget.status);
      if (widget.showConnectionTime) {
        _restartConnectionTimer();
      }
    }
  }
  
  /// 根据状态启动相应动画
  void _startAnimations() {
    _updateAnimationForStatus(widget.status);
  }
  
  /// 根据状态更新动画
  void _updateAnimationForStatus(ProxyStatus status) {
    switch (status) {
      case ProxyStatus.connected:
        // 已连接状态轻微脉冲
        _pulseController.repeat(reverse: true);
        _rotationController.stop();
        break;
        
      case ProxyStatus.connecting:
        // 连接中状态旋转动画
        _rotationController.repeat();
        _pulseController.stop();
        break;
        
      case ProxyStatus.disconnected:
      case ProxyStatus.error:
        // 断开和错误状态停止动画
        _pulseController.stop();
        _rotationController.stop();
        break;
    }
  }
  
  /// 启动连接时间计时器
  void _startConnectionTimer() {
    _updateConnectionTimeText();
    _connectionTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _updateConnectionTimeText();
      },
    );
  }
  
  /// 重启连接时间计时器
  void _restartConnectionTimer() {
    _connectionTimer?.cancel();
    _updateConnectionTimeText();
    _startConnectionTimer();
  }
  
  /// 更新连接时间文本
  void _updateConnectionTimeText() {
    if (widget.connectionStartTime != null && widget.status == ProxyStatus.connected) {
      final now = DateTime.now();
      final diff = now.difference(widget.connectionStartTime!);
      _connectionTimeText = _formatDuration(diff);
    } else {
      _connectionTimeText = '';
    }
  }
  
  /// 格式化持续时间
  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    } else {
      return '${duration.inMinutes}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.colorScheme.brightness == Brightness.dark;
    final statusInfo = _getStatusInfo(widget.status, theme, isDark);
    
    return widget.compact 
        ? _buildCompactIndicator(theme, statusInfo)
        : _buildDetailedIndicator(theme, statusInfo);
  }
  
  /// 构建紧凑指示器
  Widget _buildCompactIndicator(ThemeData theme, StatusInfo statusInfo) {
    return Row(
      children: [
        // 状态图标
        AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _rotationAnimation]),
          builder: (context, child) {
            if (widget.status == ProxyStatus.connected) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: statusInfo.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    statusInfo.icon,
                    color: statusInfo.color,
                    size: widget.size ?? 16,
                  ),
                ),
              );
            } else if (widget.status == ProxyStatus.connecting) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: Icon(
                  statusInfo.icon,
                  color: statusInfo.color,
                  size: widget.size ?? 16,
                ),
              );
            } else {
              return Icon(
                statusInfo.icon,
                color: statusInfo.color,
                size: widget.size ?? 16,
              );
            }
          },
        ),
        
        const SizedBox(width: 8),
        
        // 状态文本
        Expanded(
          child: Text(
            statusInfo.shortLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: statusInfo.color,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // 连接时间
        if (widget.showConnectionTime && _connectionTimeText.isNotEmpty)
          Text(
            _connectionTimeText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
          ),
      ],
    );
  }
  
  /// 构建详细指示器
  Widget _buildDetailedIndicator(ThemeData theme, StatusInfo statusInfo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusInfo.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusInfo.color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 状态图标
              AnimatedBuilder(
                animation: Listenable.merge([_pulseAnimation, _rotationAnimation]),
                builder: (context, child) {
                  if (widget.status == ProxyStatus.connected) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusInfo.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          statusInfo.icon,
                          color: statusInfo.color,
                          size: widget.size ?? 24,
                        ),
                      ),
                    );
                  } else if (widget.status == ProxyStatus.connecting) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 2 * 3.14159,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusInfo.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          statusInfo.icon,
                          color: statusInfo.color,
                          size: widget.size ?? 24,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusInfo.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        statusInfo.icon,
                        color: statusInfo.color,
                        size: widget.size ?? 24,
                      ),
                    );
                  }
                },
              ),
              
              const SizedBox(width: 16),
              
              // 状态信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          statusInfo.label,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: statusInfo.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        // 状态点指示器
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusInfo.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    
                    if (widget.showDetailedStatus && statusInfo.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        statusInfo.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: statusInfo.color.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          
          // 连接时间
          if (widget.showConnectionTime && _connectionTimeText.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  color: statusInfo.color.withOpacity(0.7),
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  '已连接 $_connectionTimeText',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: statusInfo.color.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  /// 获取状态信息
  StatusInfo _getStatusInfo(ProxyStatus status, ThemeData theme, bool isDark) {
    final primaryColor = widget.primaryColor ?? theme.primaryColor;
    
    switch (status) {
      case ProxyStatus.connected:
        return StatusInfo(
          label: '已连接',
          shortLabel: '已连接',
          description: '代理服务正常运行',
          icon: Icons.check_circle,
          color: Colors.green,
        );
        
      case ProxyStatus.connecting:
        return StatusInfo(
          label: '连接中',
          shortLabel: '连接中',
          description: '正在建立代理连接',
          icon: Icons.refresh,
          color: primaryColor,
        );
        
      case ProxyStatus.disconnected:
        return StatusInfo(
          label: '已断开',
          shortLabel: '已断开',
          description: '代理服务已停止',
          icon: Icons.link_off,
          color: Colors.grey,
        );
        
      case ProxyStatus.error:
        return StatusInfo(
          label: '连接错误',
          shortLabel: '错误',
          description: '代理连接遇到问题',
          icon: Icons.error,
          color: Colors.red,
        );
    }
  }
}

/// 状态信息数据类
class StatusInfo {
  final String label;
  final String shortLabel;
  final String? description;
  final IconData icon;
  final Color color;
  
  const StatusInfo({
    required this.label,
    required this.shortLabel,
    this.description,
    required this.icon,
    required this.color,
  });
}

/// 代理状态扩展方法
extension ProxyStatusExtension on ProxyStatus {
  /// 获取状态显示名称
  String get displayName {
    switch (this) {
      case ProxyStatus.connected:
        return '已连接';
      case ProxyStatus.connecting:
        return '连接中';
      case ProxyStatus.disconnected:
        return '已断开';
      case ProxyStatus.error:
        return '连接错误';
    }
  }
  
  /// 获取状态图标
  IconData get icon {
    switch (this) {
      case ProxyStatus.connected:
        return Icons.check_circle;
      case ProxyStatus.connecting:
        return Icons.refresh;
      case ProxyStatus.disconnected:
        return Icons.link_off;
      case ProxyStatus.error:
        return Icons.error;
    }
  }
  
  /// 获取状态颜色
  Color getColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (this) {
      case ProxyStatus.connected:
        return Colors.green;
      case ProxyStatus.connecting:
        return theme.primaryColor;
      case ProxyStatus.disconnected:
        return Colors.grey;
      case ProxyStatus.error:
        return Colors.red;
    }
  }
  
  /// 是否为活跃状态
  bool get isActive => this == ProxyStatus.connected || this == ProxyStatus.connecting;
  
  /// 是否为错误状态
  bool get hasError => this == ProxyStatus.error;
}

/// 代理状态指示器样式
class ProxyStatusIndicatorStyles {
  /// 紧凑模式尺寸
  static const double compactSize = 16.0;
  
  /// 常规模式尺寸
  static const double normalSize = 24.0;
  
  /// 图标内边距
  static const EdgeInsets iconPadding = EdgeInsets.all(8);
  
  /// 紧凑图标内边距
  static const EdgeInsets compactIconPadding = EdgeInsets.all(4);
  
  /// 卡片内边距
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  
  /// 圆角半径
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(12));
  
  /// 图标圆角半径
  static const BorderRadius iconBorderRadius = BorderRadius.all(Radius.circular(8));
  
  /// 紧凑图标圆角半径
  static const BorderRadius compactIconBorderRadius = BorderRadius.all(Radius.circular(12));
  
  /// 状态点大小
  static const double statusDotSize = 8.0;
  
  /// 间距
  static const double spacing = 8.0;
  
  /// 详细模式额外间距
  static const double detailedSpacing = 4.0;
}

/// 状态颜色常量
class StatusColors {
  /// 连接成功
  static const Color connected = Colors.green;
  
  /// 连接中
  static const Color connecting = Colors.blue;
  
  /// 已断开
  static const Color disconnected = Colors.grey;
  
  /// 连接错误
  static const Color error = Colors.red;
  
  /// 获取状态颜色
  static Color getStatusColor(ProxyStatus status) {
    switch (status) {
      case ProxyStatus.connected:
        return connected;
      case ProxyStatus.connecting:
        return connecting;
      case ProxyStatus.disconnected:
        return disconnected;
      case ProxyStatus.error:
        return error;
    }
  }
}