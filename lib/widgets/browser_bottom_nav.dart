import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/browser_theme.dart';

/// 浏览器底部导航栏组件
/// 
/// 实现：
/// - 多功能底部导航
/// - 响应式图标和标签
/// - 动画过渡效果
/// - 主题适配
/// - 手势支持
class BrowserBottomNav extends StatefulWidget {
  const BrowserBottomNav({
    Key? key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedIconColor,
    this.unselectedIconColor,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.type = BottomNavigationBarType.fixed,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    this.enableHapticFeedback = true,
  }) : super(key: key);

  final List<BrowserBottomNavItem> items;
  final int currentIndex;
  final Function(int)? onTap;
  final Function(int)? onLongPress;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color? selectedIconColor;
  final Color? unselectedIconColor;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final BottomNavigationBarType type;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;
  final bool enableHapticFeedback;

  @override
  State<BrowserBottomNav> createState() => _BrowserBottomNavState();
}

class _BrowserBottomNavState extends State<BrowserBottomNav>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<double>> _slideAnimations;
  
  // 触摸状态
  int? _pressedIndex;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(BrowserBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 如果项目数量变化，重新初始化动画
    if (widget.items.length != oldWidget.items.length) {
      _initializeAnimations();
    }
    
    // 触发动画
    if (widget.currentIndex != oldWidget.currentIndex) {
      _animateToIndex(widget.currentIndex);
    }
  }

  /// 初始化动画控制器
  void _initializeAnimations() {
    _animationControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );
    
    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
    }).toList();
    
    _fadeAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 0.5,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();
    
    _slideAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 0.2,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));
    }).toList();
    
    // 设置初始状态
    for (int i = 0; i < _animationControllers.length; i++) {
      if (i == widget.currentIndex) {
        _animationControllers[i].value = 1.0;
      } else {
        _animationControllers[i].value = 0.0;
      }
    }
  }

  /// 动画到指定索引
  void _animateToIndex(int index) {
    if (_isAnimating) return;
    
    setState(() {
      _isAnimating = true;
    });
    
    // 并行动画
    for (int i = 0; i < _animationControllers.length; i++) {
      if (i == index) {
        _animationControllers[i].forward();
      } else {
        _animationControllers[i].reverse();
      }
    }
    
    // 动画完成后重置状态
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _isAnimating = false;
        });
      }
    });
  }

  /// 处理触摸反馈
  void _handleHapticFeedback() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? 
            ExtensionData.getBrowserColor(context, 'surface'),
        border: Border(
          top: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: ExtensionData.bottomNavHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == widget.currentIndex;
              final isPressed = index == _pressedIndex;
              
              return Expanded(
                child: _buildNavItem(
                  item: item,
                  index: index,
                  isSelected: isSelected,
                  isPressed: isPressed,
                  theme: theme,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// 构建导航项
  Widget _buildNavItem({
    required BrowserBottomNavItem item,
    required int index,
    required bool isSelected,
    required bool isPressed,
    required ThemeData theme,
  }) {
    return AnimatedBuilder(
      animation: _animationControllers[index],
      builder: (context, child) {
        final scale = _scaleAnimations[index].value;
        final fade = _fadeAnimations[index].value;
        final slide = _slideAnimations[index].value;
        
        return Transform.scale(
          scale: isPressed ? 0.95 : scale,
          child: Transform.translate(
            offset: Offset(0, slide * 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _handleTap(index),
                onLongPress: () => _handleLongPress(index),
                onTapDown: (_) => _handleTapDown(index),
                onTapCancel: () => _handleTapCancel(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 图标容器
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (widget.selectedIconColor ?? theme.primaryColor).withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            // 主图标
                            Center(
                              child: Icon(
                                item.icon,
                                size: isSelected ? 26 : 24,
                                color: isSelected
                                    ? (widget.selectedIconColor ?? 
                                        widget.selectedItemColor ?? 
                                        theme.primaryColor)
                                    : (widget.unselectedIconColor ??
                                        widget.unselectedItemColor ??
                                        theme.colorScheme.onSurface.withOpacity(0.6)),
                              ),
                            ),
                            
                            // 徽章
                            if (item.badgeCount != null && item.badgeCount! > 0)
                              Positioned(
                                top: -2,
                                right: -2,
                                child: _buildBadge(item.badgeCount!),
                              ),
                            
                            // 加载指示器
                            if (item.isLoading)
                              Positioned(
                                bottom: -2,
                                right: -2,
                                child: SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // 标签
                      if ((isSelected && widget.showSelectedLabels) ||
                          (!isSelected && widget.showUnselectedLabels))
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          child: Opacity(
                            opacity: fade,
                            child: Text(
                              item.label,
                              style: isSelected
                                  ? (widget.selectedLabelStyle ??
                                      theme.textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: widget.selectedItemColor ??
                                            theme.primaryColor,
                                      ))
                                  : (widget.unselectedLabelStyle ??
                                      theme.textTheme.labelSmall?.copyWith(
                                        color: widget.unselectedItemColor ??
                                            theme.colorScheme.onSurface.withOpacity(0.6),
                                      )),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
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
  }

  /// 构建徽章
  Widget _buildBadge(int count) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      constraints: const BoxConstraints(
        minWidth: 16,
        minHeight: 16,
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// 处理点击
  void _handleTap(int index) {
    _handleHapticFeedback();
    
    setState(() {
      _pressedIndex = null;
    });
    
    widget.onTap?.call(index);
  }

  /// 处理长按
  void _handleLongPress(int index) {
    _handleHapticFeedback();
    widget.onLongPress?.call(index);
  }

  /// 处理按下
  void _handleTapDown(int index) {
    setState(() {
      _pressedIndex = index;
    });
  }

  /// 处理取消触摸
  void _handleTapCancel() {
    setState(() {
      _pressedIndex = null;
    });
  }
}

/// 浏览器底部导航项
class BrowserBottomNavItem {
  const BrowserBottomNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.badgeCount,
    this.isLoading = false,
    this.tooltip,
  });

  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String? tooltip;
  final int? badgeCount;
  final bool isLoading;

  /// 创建副本
  BrowserBottomNavItem copyWith({
    IconData? icon,
    IconData? activeIcon,
    String? label,
    String? tooltip,
    int? badgeCount,
    bool? isLoading,
  }) {
    return BrowserBottomNavItem(
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      label: label ?? this.label,
      tooltip: tooltip ?? this.tooltip,
      badgeCount: badgeCount ?? this.badgeCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 浏览器底部导航栏预设配置
class BrowserBottomNavPresets {
  /// 标准浏览器导航
  static List<BrowserBottomNavItem> get standardBrowser => const [
    BrowserBottomNavItem(
      icon: Icons.home,
      label: '主页',
      tooltip: '返回主页',
    ),
    BrowserBottomNavItem(
      icon: Icons.bookmarks,
      label: '书签',
      tooltip: '管理书签',
    ),
    BrowserBottomNavItem(
      icon: Icons.add,
      label: '新建',
      tooltip: '新建标签页',
    ),
    BrowserBottomNavItem(
      icon: Icons.history,
      label: '历史',
      tooltip: '浏览历史',
    ),
    BrowserBottomNavItem(
      icon: Icons.settings,
      label: '设置',
      tooltip: '浏览器设置',
    ),
  ];

  /// 简化版导航
  static List<BrowserBottomNavItem> get simplified => const [
    BrowserBottomNavItem(
      icon: Icons.home,
      label: '主页',
    ),
    BrowserBottomNavItem(
      icon: Icons.bookmarks,
      label: '书签',
    ),
    BrowserBottomNavItem(
      icon: Icons.history,
      label: '历史',
    ),
    BrowserBottomNavItem(
      icon: Icons.settings,
      label: '设置',
    ),
  ];

  /// 高级用户导航
  static List<BrowserBottomNavItem> get advanced => const [
    BrowserBottomNavItem(
      icon: Icons.dashboard,
      label: '仪表盘',
      tooltip: '浏览器仪表盘',
    ),
    BrowserBottomNavItem(
      icon: Icons.bookmarks,
      label: '书签',
      tooltip: '书签管理',
    ),
    BrowserBottomNavItem(
      icon: Icons.add,
      label: '新建',
      tooltip: '新建标签页',
    ),
    BrowserBottomNavItem(
      icon: Icons.history,
      label: '历史',
      tooltip: '浏览历史',
    ),
    BrowserBottomNavItem(
      icon: Icons.download,
      label: '下载',
      tooltip: '下载管理',
    ),
    BrowserBottomNavItem(
      icon: Icons.security,
      label: '安全',
      tooltip: '隐私与安全',
    ),
  ];
}