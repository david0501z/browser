/// 设置项组件
/// 
/// 用于展示单个设置项的组件。
/// 支持多种设置项类型：开关、选择、输入、按钮等。
library setting_tile;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 设置项类型枚举
enum SettingTileType {
  /// 开关
  switchTile,
  
  /// 选择列表
  selection,
  
  /// 单选列表
  radio,
  
  /// 输入框
  input,
  
  /// 数字输入
  numberInput,
  
  /// 滑块
  slider,
  
  /// 按钮
  button,
  
  /// 信息显示
  info,
  
  /// 自定义
  custom,
}

/// 设置项组件
/// 
/// 提供统一的设置项展示，支持多种交互方式。
class SettingTile extends StatelessWidget {
  /// 设置项类型
  final SettingTileType type;
  
  /// 标题
  final String title;
  
  /// 副标题/描述
  final String? subtitle;
  
  /// 值
  final dynamic value;
  
  /// 值变更回调
  final ValueChanged<dynamic>? onChanged;
  
  /// 点击回调
  final VoidCallback? onTap;
  
  /// 长按回调
  final VoidCallback? onLongPress;
  
  /// 启用状态
  final bool enabled;
  
  /// 必填项
  final bool required;
  
  /// 错误状态
  final bool hasError;
  
  /// 错误消息
  final String? errorMessage;
  
  /// 警告状态
  final bool hasWarning;
  
  /// 警告消息
  final String? warningMessage;
  
  /// 图标
  final IconData? icon;
  
  /// 图标颜色
  final Color? iconColor;
  
  /// 标题颜色
  final Color? titleColor;
  
  /// 副标题颜色
  final Color? subtitleColor;
  
  /// 背景颜色
  final Color? backgroundColor;
  
  /// 边框颜色
  final Color? borderColor;
  
  /// 圆角半径
  final double borderRadius;
  
  /// 内边距
  final EdgeInsetsGeometry? padding;
  
  /// 外边距
  final EdgeInsetsGeometry? margin;
  
  /// 高度
  final double? height;
  
  /// 权重
  final int flex;
  
  /// 动画持续时间
  final Duration animationDuration;
  
  /// 搜索关键词
  final String? searchQuery;
  
  /// 自定义子组件
  final Widget? customChild;
  
  /// 选择项列表
  final List<SettingOption>? options;
  
  /// 输入配置
  final InputConfig? inputConfig;
  
  /// 滑块配置
  final SliderConfig? sliderConfig;
  
  /// 按钮配置
  final ButtonConfig? buttonConfig;
  
  /// 信息配置
  final InfoConfig? infoConfig;
  
  const SettingTile({
    super.key,
    required this.type,
    required this.title,
    this.subtitle,
    this.value,
    this.onChanged,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.required = false,
    this.hasError = false,
    this.errorMessage,
    this.hasWarning = false,
    this.warningMessage,
    this.icon,
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 8.0,
    this.padding,
    this.margin,
    this.height,
    this.flex = 1,
    this.animationDuration = const Duration(milliseconds: 200),
    this.searchQuery,
    this.customChild,
    this.options,
    this.inputConfig,
    this.sliderConfig,
    this.buttonConfig,
    this.infoConfig,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = enabled && !hasError;
    
    // 搜索过滤
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      final titleMatch = title.toLowerCase().contains(query);
      final subtitleMatch = subtitle?.toLowerCase().contains(query) ?? false;
      if (!titleMatch && !subtitleMatch) {
        return const SizedBox.shrink();
      }
    }
    
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      height: height,
      child: Material(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          onLongPress: isEnabled ? onLongPress : null,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: _getBorderColor(theme),
                width: hasError ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              children: [
                // 图标
                if (icon != null) ...[;
                  Icon(
                    icon,
                    color: iconColor ?? theme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                ],
                
                // 标题和描述
                Expanded(
                  flex: flex,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: titleColor ?? theme.textTheme.bodyMedium?.color,
                                fontWeight: required ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                          
                          // 必填标记
                          if (required) ...[
                            const SizedBox(width: 4),
                            Text(
                              '*',
                              style: TextStyle(
                                color: theme.colorScheme.error,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                      // 副标题
                      if (subtitle != null) ...[;
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: subtitleColor ?? theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      
                      // 错误消息
                      if (hasError && errorMessage != null) ...[;
                        const SizedBox(height: 4),
                        Text(
                          errorMessage!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                      
                      // 警告消息
                      if (hasWarning && warningMessage != null) ...[;
                        const SizedBox(height: 4),
                        Text(
                          warningMessage!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // 右侧控件
                if (customChild != null);
                  customChild!
                else
                  _buildRightWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// 构建右侧控件
  Widget _buildRightWidget(BuildContext context) {
    switch (type) {
      case SettingTileType.switchTile:
        return Switch(
          value: value ?? false,
          onChanged: enabled && !hasError ? onChanged as ValueChanged<bool>? : null,
        );
        
      case SettingTileType.selection:
        return _buildSelectionWidget(context);
        
      case SettingTileType.radio:
        return _buildRadioWidget(context);
        
      case SettingTileType.input:
        return _buildInputWidget(context);
        
      case SettingTileType.numberInput:
        return _buildNumberInputWidget(context);
        
      case SettingTileType.slider:
        return _buildSliderWidget(context);
        
      case SettingTileType.button:
        return _buildButtonWidget(context);
        
      case SettingTileType.info:
        return _buildInfoWidget(context);
        
      case SettingTileType.custom:
        return const SizedBox.shrink();
    }
  }
  
  /// 构建选择控件
  Widget _buildSelectionWidget(BuildContext context) {
    final theme = Theme.of(context);
    final selectedOption = options?.firstWhere(
      (option) => option.value == value,
      orElse: () => options!.first,
    );
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selectedOption != null);
          Text(
            selectedOption.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
          ),
        const SizedBox(width: 4),
        Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: theme.iconTheme.color?.withOpacity(0.5),
        ),
      ],
    );
  }
  
  /// 构建单选控件
  Widget _buildRadioWidget(BuildContext context) {
    return const SizedBox.shrink(); // 单选控件通常在列表中展示
  }
  
  /// 构建输入控件
  Widget _buildInputWidget(BuildContext context) {
    return const SizedBox.shrink(); // 输入控件通常在弹窗中展示
  }
  
  /// 构建数字输入控件
  Widget _buildNumberInputWidget(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      value?.toString() ?? '',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
      ),
    );
  }
  
  /// 构建滑块控件
  Widget _buildSliderWidget(BuildContext context) {
    if (sliderConfig == null) return const SizedBox.shrink();
    
    return SizedBox(
      width: 100,
      child: Slider(
        value: (value as double?) ?? sliderConfig!.min,
        min: sliderConfig!.min,
        max: sliderConfig!.max,
        divisions: sliderConfig!.divisions,
        label: sliderConfig!.labelBuilder?.call(value) ?? value.toString(),
        onChanged: enabled && !hasError ? onChanged as ValueChanged<double>? : null,
      ),
    );
  }
  
  /// 构建按钮控件
  Widget _buildButtonWidget(BuildContext context) {
    if (buttonConfig == null) return const SizedBox.shrink();
    
    return ElevatedButton(
      onPressed: enabled && !hasError ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonConfig!.backgroundColor,
        foregroundColor: buttonConfig!.foregroundColor,
        minimumSize: Size(buttonConfig!.minWidth, buttonConfig!.minHeight),
      ),
      child: Text(buttonConfig!.text),
    );
  }
  
  /// 构建信息控件
  Widget _buildInfoWidget(BuildContext context) {
    if (infoConfig == null) return const SizedBox.shrink();
    
    final theme = Theme.of(context);
    Color iconColor = theme.iconTheme.color!;
    
    switch (infoConfig!.type) {
      case InfoType.success:
        iconColor = Colors.green;
        break;
      case InfoType.warning:
        iconColor = Colors.orange;
        break;
      case InfoType.error:
        iconColor = theme.colorScheme.error;
        break;
      case InfoType.info:
        iconColor = theme.primaryColor;
        break;
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          infoConfig!.icon ?? _getDefaultIcon(infoConfig!.type),
          color: iconColor,
          size: 16,
        ),
        if (infoConfig!.showValue && value != null) ...[;
          const SizedBox(width: 4),
          Text(
            value.toString(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: iconColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
  
  /// 获取边框颜色
  Color _getBorderColor(ThemeData theme) {
    if (hasError) return theme.colorScheme.error;
    if (hasWarning) return Colors.orange;
    if (!enabled) return theme.dividerColor.withOpacity(0.3);
    return borderColor ?? theme.dividerColor.withOpacity(0.3);
  }
  
  /// 获取默认图标
  IconData _getDefaultIcon(InfoType type) {
    switch (type) {
      case InfoType.success:
        return Icons.check_circle;
      case InfoType.warning:
        return Icons.warning;
      case InfoType.error:
        return Icons.error;
      case InfoType.info:
        return Icons.info;
    }
  }
}

/// 设置选项数据类
class SettingOption {
  final String label;
  final dynamic value;
  final IconData? icon;
  final String? description;
  
  const SettingOption({
    required this.label,
    required this.value,
    this.icon,
    this.description,
  });
}

/// 输入配置数据类
class InputConfig {
  final String? hintText;
  final String? helperText;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final String? Function(String?)? validator;
  
  const InputConfig({
    this.hintText,
    this.helperText,
    this.maxLines,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.validator,
  });
}

/// 滑块配置数据类
class SliderConfig {
  final double min;
  final double max;
  final int? divisions;
  final String Function(dynamic)? labelBuilder;
  
  const SliderConfig({
    required this.min,
    required this.max,
    this.divisions,
    this.labelBuilder,
  });
}

/// 按钮配置数据类
class ButtonConfig {
  final String text;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double minWidth;
  final double minHeight;
  
  const ButtonConfig({
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.minWidth = 80.0,
    this.minHeight = 36.0,
  });
}

/// 信息类型枚举
enum InfoType {
  success,
  warning,
  error,
  info,
}

/// 信息配置数据类
class InfoConfig {
  final InfoType type;
  final IconData? icon;
  final bool showValue;
  
  const InfoConfig({
    required this.type,
    this.icon,
    this.showValue = false,
  });
}

/// 设置项构建器
/// 
/// 用于快速构建设置项的辅助类。
class SettingTileBuilder {
  final List<SettingTile> _tiles = [];
  
  /// 添加开关设置项
  SettingTileBuilder addSwitch({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
    IconData? icon,
  }) {
    _tiles.add(SettingTile(
      type: SettingTileType.switchTile,
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
      enabled: enabled,
      icon: icon,
    ));
    return this;
  }
  
  /// 添加选择设置项
  SettingTileBuilder addSelection({
    required String title,
    String? subtitle,
    required dynamic value,
    required List<SettingOption> options,
    required ValueChanged<dynamic> onChanged,
    bool enabled = true,
    IconData? icon,
  }) {
    _tiles.add(SettingTile(
      type: SettingTileType.selection,
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
      enabled: enabled,
      icon: icon,
      options: options,
    ));
    return this;
  }
  
  /// 添加输入设置项
  SettingTileBuilder addInput({
    required String title,
    String? subtitle,
    required String value,
    required ValueChanged<String> onChanged,
    InputConfig? config,
    bool enabled = true,
    IconData? icon,
  }) {
    _tiles.add(SettingTile(
      type: SettingTileType.input,
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
      enabled: enabled,
      icon: icon,
      inputConfig: config,
    ));
    return this;
  }
  
  /// 添加滑块设置项
  SettingTileBuilder addSlider({
    required String title,
    String? subtitle,
    required double value,
    required ValueChanged<double> onChanged,
    required SliderConfig config,
    bool enabled = true,
    IconData? icon,
  }) {
    _tiles.add(SettingTile(
      type: SettingTileType.slider,
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
      enabled: enabled,
      icon: icon,
      sliderConfig: config,
    ));
    return this;
  }
  
  /// 添加信息显示设置项
  SettingTileBuilder addInfo({
    required String title,
    String? subtitle,
    required dynamic value,
    required InfoConfig config,
    bool enabled = true,
    IconData? icon,
  }) {
    _tiles.add(SettingTile(
      type: SettingTileType.info,
      title: title,
      subtitle: subtitle,
      value: value,
      enabled: enabled,
      icon: icon,
      infoConfig: config,
    ));
    return this;
  }
  
  /// 构建设置项列表
  List<SettingTile> build({String? searchQuery}) {
    var tiles = _tiles;
    
    // 应用搜索过滤
    if (searchQuery != null && searchQuery.isNotEmpty) {
      tiles = tiles.where((tile) {
        final title = tile.title.toLowerCase();
        final subtitle = tile.subtitle?.toLowerCase() ?? '';
        final query = searchQuery.toLowerCase();
        return title.contains(query) || subtitle.contains(query);
      }).toList();
    }
    
    return tiles;
  }
  
  /// 清空所有设置项
  void clear() {
    _tiles.clear();
  }
}