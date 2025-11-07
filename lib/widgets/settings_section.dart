/// 设置分组组件
/// 
/// 用于组织和展示相关设置项的容器组件。
/// 支持折叠/展开、搜索过滤和分组标题。
library settings_section;

import '../providers/proxy_widget_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 设置分组组件
/// 
/// 提供设置项的分组展示，支持：
/// - 分组标题和描述
/// - 折叠/展开功能
/// - 搜索过滤
/// - 图标和颜色主题
/// - 错误状态显示
class SettingsSection extends StatefulWidget {
  /// 分组标题
  final String title;
  
  /// 分组描述
  final String? description;
  
  /// 子组件列表
  final List<Widget> children;
  
  /// 是否可折叠
  final bool collapsible;
  
  /// 是否默认展开
  final bool initiallyExpanded;
  
  /// 图标
  final IconData? icon;
  
  /// 图标颜色
  final Color? iconColor;
  
  /// 标题颜色
  final Color? titleColor;
  
  /// 背景颜色
  final Color? backgroundColor;
  
  /// 边框颜色
  final Color? borderColor;
  
  /// 是否显示错误状态
  final bool hasError;
  
  /// 错误消息
  final String? errorMessage;
  
  /// 搜索关键词
  final String? searchQuery;
  
  /// 分组权重（用于排序）
  final int priority;
  
  /// 点击回调
  final VoidCallback? onTap;
  
  /// 展开状态变更回调
  final ValueChanged<bool>? onExpansionChanged;
  
  const SettingsSection({
    super.key,
    required this.title,
    this.description,
    required this.children,
    this.collapsible = true,
    this.initiallyExpanded = true,
    this.icon,
    this.iconColor,
    this.titleColor,
    this.backgroundColor,
    this.borderColor,
    this.hasError = false,
    this.errorMessage,
    this.searchQuery,
    this.priority = 0,
    this.onTap,
    this.onExpansionChanged,
  });

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = true;
  
  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(SettingsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _isExpanded = widget.initiallyExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }
  
  /// 过滤子组件
  List<Widget> _filterChildren() {
    if (widget.searchQuery == null || widget.searchQuery!.isEmpty) {
      return widget.children;
    }
    
    final query = widget.searchQuery!.toLowerCase();
    return widget.children.where((child) {
      if (child is SettingTile) {
        final title = child.title.toLowerCase();
        final subtitle = child.subtitle?.toLowerCase() ?? '';
        return title.contains(query) || subtitle.contains(query);
      }
      return true;
    }).toList();
  }
  
  /// 处理展开/折叠
  void _handleExpansion() {
    if (!widget.collapsible) return;
    
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    
    widget.onExpansionChanged?.call(_isExpanded);
  }
  
  @override
  Widget build(BuildContext context) {
    final filteredChildren = _filterChildren();
    
    // 如果没有匹配的子组件，不显示该分组
    if (filteredChildren.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final theme = Theme.of(context);
    final iconColor = widget.iconColor ?? theme.primaryColor;
    final titleColor = widget.titleColor ?? theme.textTheme.titleMedium?.color;
    final backgroundColor = widget.backgroundColor ?? theme.cardColor;
    final borderColor = widget.borderColor ?? theme.dividerColor;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.hasError ? theme.colorScheme.error : borderColor,
          width: widget.hasError ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 分组标题
          InkWell(
            onTap: widget.onTap ?? (widget.collapsible ? _handleExpansion : null),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // 图标
                  if (widget.icon != null) ...[
                Icon(
                      widget.icon,
                      color: iconColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                  ],
                  
                  // 标题和描述
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: titleColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            
                            // 错误指示器
                            if (widget.hasError) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.error_outline,
                                color: theme.colorScheme.error,
                                size: 16,
                              ),
                            ],
                            
                            // 展开/折叠指示器
                            if (widget.collapsible) ...[
                              const SizedBox(width: 8),
                              AnimatedRotation(
                                turns: _isExpanded ? 0.5 : 0.0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  Icons.expand_more,
                                  color: theme.iconTheme.color,
                                  size: 20,
                                ),
                              ),
                            ],
                          ],
                        ),
                        
                        // 描述
                        if (widget.description != null) ...[
                const SizedBox(height: 4),
                          Text(
                            widget.description!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        
                        // 错误消息
                        if (widget.hasError && widget.errorMessage != null) ...[
                const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.errorMessage!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 子组件列表
          if (filteredChildren.isNotEmpty)
            ClipRect(
              child: AnimatedBuilder(
                animation: _expandAnimation,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment.topCenter,
                    heightFactor: _expandAnimation.value,
                    child: child,
                  );
                },
                child: Column(
                  children: filteredChildren,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 设置分组构建器
/// 
/// 用于动态构建设置分组的辅助类。
class SettingsSectionBuilder {
  final List<SettingsSection> _sections = [];
  
  /// 添加设置分组
  SettingsSectionBuilder addSection({
    required String title,
    String? description,
    required List<Widget> children,
    bool collapsible = true,
    bool initiallyExpanded = true,
    IconData? icon,
    Color? iconColor,
    Color? titleColor,
    Color? backgroundColor,
    Color? borderColor,
    bool hasError = false,
    String? errorMessage,
    String? searchQuery,
    int priority = 0,
    VoidCallback? onTap,
    ValueChanged<bool>? onExpansionChanged,
  }) {
    _sections.add(
      SettingsSection(
        title: title,
        description: description,
        children: children,
        collapsible: collapsible,
        initiallyExpanded: initiallyExpanded,
        icon: icon,
        iconColor: iconColor,
        titleColor: titleColor,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        hasError: hasError,
        errorMessage: errorMessage,
        searchQuery: searchQuery,
        priority: priority,
        onTap: onTap,
        onExpansionChanged: onExpansionChanged,
      ),
    );
    return this;
  }
  
  /// 构建分组列表
  List<SettingsSection> build({String? searchQuery}) {
    var sections = _sections;
    
    // 应用搜索过滤
    if (searchQuery != null && searchQuery.isNotEmpty) {
      sections = sections.where((section) {
        final title = section.title.toLowerCase();
        final description = section.description?.toLowerCase() ?? '';
        final query = searchQuery.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }
    
    // 按优先级排序
    sections.sort((a, b) => a.priority.compareTo(b.priority));
    
    return sections;
  }
  
  /// 清空所有分组
  void clear() {
    _sections.clear();
  }
}

/// 设置分组样式
/// 
/// 预定义的设置分组样式。
class SettingsSectionStyles {
  /// 浏览器设置样式
  static SettingsSectionStyle browser = const SettingsSectionStyle(
    icon: Icons.web,
    iconColor: Colors.blue,
    backgroundColor: Colors.blue50,
  );
  
  /// 代理设置样式
  static SettingsSectionStyle proxy = const SettingsSectionStyle(
    icon: Icons.vpn_lock,
    iconColor: Colors.green,
    backgroundColor: Colors.green50,
  );
  
  /// 界面设置样式
  static SettingsSectionStyle interface = const SettingsSectionStyle(
    icon: Icons.palette,
    iconColor: Colors.purple,
    backgroundColor: Colors.purple50,
  );
  
  /// 隐私设置样式
  static SettingsSectionStyle privacy = const SettingsSectionStyle(
    icon: Icons.security,
    iconColor: Colors.orange,
    backgroundColor: Colors.orange50,
  );
  
  /// 通知设置样式
  static SettingsSectionStyle notifications = const SettingsSectionStyle(
    icon: Icons.notifications,
    iconColor: Colors.red,
    backgroundColor: Colors.red50,
  );
  
  /// 备份设置样式
  static SettingsSectionStyle backup = const SettingsSectionStyle(
    icon: Icons.backup,
    iconColor: Colors.teal,
    backgroundColor: Colors.teal50,
  );
}


/// 书签类
class Bookmark {
  final String id;
  final String title;
  final String url;
  final DateTime? createdAt;
  final List<String>? tags;
  
  const Bookmark({
    required this.id,
    required this.title,
    required this.url,
    this.createdAt,
    this.tags,
  });
}

/// 历史记录项类  
class HistoryItem {
  final String id;
  final String title;
  final String url;
  final DateTime? visitedAt;
  final List<String>? tags;
  
  const HistoryItem({
    required this.id,
    required this.title,
    required this.url,
    this.visitedAt,
    this.tags,
  });
}

/// 教程步骤类
class TutorialStep {
  final String id;
  final String title;
  final String description;
  final String targetWidget;
  
  const TutorialStep({
    required this.id,
    required this.title,
    required this.description,
    required this.targetWidget,
  });
}

/// 教程动作类
enum TutorialAction {
  next,
  previous,
  skip,
  complete;
}

/// 工具提示位置类
enum TooltipPosition {
  top,
  bottom,
  left,
  right,
  center;
}

/// 工具提示内容类
class TooltipContent {
  final String title;
  final String description;
  final Widget? icon;
  
  const TooltipContent({
    required this.title,
    required this.description,
    this.icon,
  });
}

/// 帮助内容类
class HelpContent {
  final String title;
  final String content;
  final String? link;
  
  const HelpContent({
    required this.title,
    required this.content,
    this.link,
  });
}


}

/// 设置分组样式数据类
class SettingsSectionStyle {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  
  const SettingsSectionStyle({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
}