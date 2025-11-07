/// 代理模式选择组件
/// 
/// 提供代理模式的可视化选择界面，包括规则模式、全局模式和直连模式。
/// 支持模式切换、状态显示和交互反馈。
library proxy_mode_selector;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/proxy_types.dart';
import '../../providers/proxy_widget_providers.dart';
import '../../core/proxy_types.dart';

/// 代理模式选项类
class ProxyModeOption {
  final ProxyMode mode;
  final String title;
  final String? description;
  final String? usage;
  final List<String>? features;
  final IconData icon;

  const ProxyModeOption({
    required this.mode,
    required this.title,
    this.description,
    this.usage,
    this.features,
    required this.icon,
  });
}

/// 代理模式选择器
/// 
/// 用于选择和管理代理模式，支持：
/// - 规则模式：基于规则的智能代理
/// - 全局模式：所有流量走代理
/// - 直连模式：直接连接，不使用代理
class ProxyModeSelector extends ConsumerStatefulWidget {
  /// 当前选择的代理模式
  final ProxyMode selectedMode;
  
  /// 模式变更回调
  final ValueChanged<ProxyMode>? onModeChanged;
  
  /// 是否禁用
  final bool disabled;
  
  /// 自定义模式列表
  final List<ProxyModeOption>? customModes;
  
  /// 是否显示模式描述
  final bool showDescriptions;
  
  /// 是否紧凑显示
  final bool compact;
  
  /// 自定义主题颜色
  final Color? primaryColor;
  
  const ProxyModeSelector({
    super.key,
    required this.selectedMode,
    this.onModeChanged,
    this.disabled = false,
    this.customModes,
    this.showDescriptions = true,
    this.compact = false,
    this.primaryColor,
  });

  @override
  ConsumerState<ProxyModeSelector> createState() => _ProxyModeSelectorState();
}

class _ProxyModeSelectorState extends ConsumerState<ProxyModeSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  /// 获取可用模式列表
  List<ProxyModeOption> get _availableModes => widget.customModes ?? _defaultModes;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = widget.primaryColor ??
        (isDark ? const Color(0xFF64B5F6) : const Color(0xFF2196F3));
    
    return Container(
      margin: widget.compact 
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Padding(
            padding: widget.compact 
                ? const EdgeInsets.only(bottom: 8)
                : const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(
                  Icons.route,
                  color: primaryColor,
                  size: widget.compact ? 18 : 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '代理模式',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // 模式选择卡片
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: widget.compact 
                    ? _buildCompactModeSelector(theme, primaryColor)
                    : _buildDetailedModeSelector(theme, primaryColor),
              );
            },
          ),
        ],
      ),
    );
  }
  
  /// 构建紧凑模式选择器
  Widget _buildCompactModeSelector(ThemeData theme, Color primaryColor) {
    return Row(
      children: _availableModes.map((mode) {
        final isSelected = mode.mode == widget.selectedMode;
        final isDisabled = widget.disabled;
        
        return Expanded(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isSelected ? _scaleAnimation.value : 1.0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          mode.icon,
                          size: 14,
                          color: isSelected 
                              ? (isDark ? Colors.white : Colors.white)
                              : primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          mode.title,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected 
                                ? (isDark ? Colors.white : Colors.white)
                                : theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: isDisabled ? null : (selected) {
                      if (selected && mode.mode != widget.selectedMode) {
                        widget.onModeChanged?.call(mode.mode);
                      }
                    },
                    backgroundColor: theme.cardColor,
                    selectedColor: primaryColor.withOpacity(0.2),
                    disabledColor: theme.disabledColor,
                    side: BorderSide(
                      color: isSelected 
                          ? primaryColor 
                          : theme.dividerColor.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
  
  /// 构建详细模式选择器
  Widget _buildDetailedModeSelector(ThemeData theme, Color primaryColor) {
    return Column(
      children: _availableModes.map((mode) {
        final isSelected = mode.mode == widget.selectedMode;
        final isDisabled = widget.disabled;
        
        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isSelected ? _scaleAnimation.value : 1.0,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: isSelected 
                      ? primaryColor.withOpacity(0.1)
                      : theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? primaryColor 
                        : theme.dividerColor.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: isDisabled ? null : () {
                      if (mode.mode != widget.selectedMode) {
                        widget.onModeChanged?.call(mode.mode);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // 模式图标
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? primaryColor.withOpacity(0.2)
                                  : theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              mode.icon,
                              color: isSelected 
                                  ? primaryColor
                                  : theme.iconTheme.color,
                              size: 20,
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // 模式信息
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      mode.title,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected 
                                            ? primaryColor
                                            : theme.textTheme.titleSmall?.color,
                                      ),
                                    ),
                                    
                                    // 选择指示器
                                    if (isSelected) ...[
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.check_circle,
                                        color: primaryColor,
                                        size: 16,
                                      ),
                                    ],
                                  ],
                                ),
                                
                                if (widget.showDescriptions && mode.description != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    mode.description!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          
                          // 状态指示器
                          if (!isDisabled)
                            Icon(
                              Icons.chevron_right,
                              color: theme.iconTheme.color?.withOpacity(0.5),
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

/// 默认代理模式选项
List<ProxyModeOption> get _defaultModes => [
  const ProxyModeOption(
    mode: ProxyMode.rule,
    title: '规则模式',
    icon: Icons.rule,
    description: '基于规则文件的智能分流，适合日常使用',
  ),
  const ProxyModeOption(
    mode: ProxyMode.global,
    title: '全局模式',
    icon: Icons.public,
    description: '所有网络请求都通过代理服务器',
  ),
  const ProxyModeOption(
    mode: ProxyMode.direct,
    title: '直连模式',
    icon: Icons.link_off,
    description: '不使用代理，直接连接网络',
  ),
];

/// 代理模式选择器样式
class ProxyModeSelectorStyles {
  /// 紧凑样式
  static const EdgeInsets compactPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  
  /// 详细样式
  static const EdgeInsets detailedPadding = EdgeInsets.all(16);
  
  /// 卡片圆角
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(12));
  
  /// 模式卡片间距
  static const double cardSpacing = 8.0;
  
  /// 图标大小
  static const double iconSize = 20.0;
  
  /// 紧凑模式图标大小
  static const double compactIconSize = 14.0;
}

/// 代理模式扩展方法
extension ProxyModeExtension on ProxyMode {
  /// 获取模式显示名称
  String get displayName {
    switch (this) {
      case ProxyMode.rule:
        return '规则模式';
      case ProxyMode.global:
        return '全局模式';
      case ProxyMode.direct:
        return '直连模式';
    }
  }
  
  /// 获取模式图标
  IconData get icon {
    switch (this) {
      case ProxyMode.rule:
        return Icons.rule;
      case ProxyMode.global:
        return Icons.public;
      case ProxyMode.direct:
        return Icons.link_off;
    }
  }
  
  /// 获取模式描述
  String? get description {
    switch (this) {
      case ProxyMode.rule:
        return '基于规则文件的智能分流，适合日常使用';
      case ProxyMode.global:
        return '所有网络请求都通过代理服务器';
      case ProxyMode.direct:
        return '不使用代理，直接连接网络';
    }
  }
  
  /// 获取模式使用场景
  String? get usage {
    switch (this) {
      case ProxyMode.rule:
        return '日常浏览、游戏加速、绕过地域限制';
      case ProxyMode.global:
        return '完全匿名访问、测试代理效果、企业环境';
      case ProxyMode.direct:
        return '本地网络访问、调试网络问题';
    }
  }
  
  /// 获取模式特性
  List<String> get features {
    switch (this) {
      case ProxyMode.rule:
        return ['智能分流', '节省流量', '支持广告屏蔽'];
      case ProxyMode.global:
        return ['完全匿名', '全网加速', '统一管理'];
      case ProxyMode.direct:
        return ['无延迟', '节省带宽', '简单直接'];
    }
  }
}