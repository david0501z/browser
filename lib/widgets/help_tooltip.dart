import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/help_content.dart';

/// 帮助工具提示组件
/// 提供上下文相关的帮助提示功能
class HelpTooltip extends StatefulWidget {
  final Widget child;
  final String tooltipKey;
  final TooltipPosition position;
  final VoidCallback? onTap;
  final bool showArrow;
  final Color? backgroundColor;
  final Duration? duration;
  final bool autoShow;
  final bool dismissOnTap;

  const HelpTooltip({
    Key? key,
    required this.child,
    required this.tooltipKey,
    this.position = TooltipPosition.bottom,
    this.onTap,
    this.showArrow = true,
    this.backgroundColor,
    this.duration,
    this.autoShow = false,
    this.dismissOnTap = true,
  }) : super(key: key);

  @override
  State<HelpTooltip> createState() => _HelpTooltipState();
}

class _HelpTooltipState extends State<HelpTooltip>
    with SingleTickerProviderStateMixin {
  late OverlayEntry _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isVisible = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
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

    if (widget.autoShow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTooltip();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (_overlayEntry.mounted) {
      _overlayEntry.remove();
    }
    super.dispose();
  }

  void _showTooltip() {
    if (_isVisible || _isAnimating) return;

    final tooltipContent = HelpContent.tooltips[widget.tooltipKey];
    if (tooltipContent == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildTooltipOverlay(tooltipContent),
    );

    Overlay.of(context).insert(_overlayEntry);
    
    setState(() {
      _isVisible = true;
      _isAnimating = true;
    });

    _animationController.forward().then((_) {
      setState(() {
        _isAnimating = false;
      });

      // 自动隐藏
      if (widget.duration != null) {
        Future.delayed(widget.duration!, () {
          _hideTooltip();
        });
      }
    });
  }

  void _hideTooltip() {
    if (!_isVisible || _isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    _animationController.reverse().then((_) {
      _overlayEntry.remove();
      setState(() {
        _isVisible = false;
        _isAnimating = false;
      });
    });
  }

  void _toggleTooltip() {
    if (_isVisible) {
      _hideTooltip();
    } else {
      _showTooltip();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        if (widget.dismissOnTap) {
          _toggleTooltip();
        }
      },
      child: widget.child,
    );
  }

  Widget _buildTooltipOverlay(TooltipContent tooltipContent) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.dismissOnTap ? _hideTooltip : null,
        child: Container(
          color: Colors.transparent,
          child: _buildTooltipContent(tooltipContent),
        ),
      ),
    );
  }

  Widget _buildTooltipContent(TooltipContent tooltipContent) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: _buildTooltipWidget(tooltipContent),
          ),
        );
      },
    );
  }

  Widget _buildTooltipWidget(TooltipContent tooltipContent) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: _buildTooltipByPosition(tooltipContent, constraints),
        );
      },
    );
  }

  Widget _buildTooltipByPosition(
    TooltipContent tooltipContent, 
    BoxConstraints constraints
  ) {
    switch (widget.position) {
      case TooltipPosition.top:
        return _buildTopTooltip(tooltipContent);
      case TooltipPosition.bottom:
        return _buildBottomTooltip(tooltipContent);
      case TooltipPosition.left:
        return _buildLeftTooltip(tooltipContent);
      case TooltipPosition.right:
        return _buildRightTooltip(tooltipContent);
      case TooltipPosition.center:
        return _buildCenterTooltip(tooltipContent);
    }
  }

  Widget _buildTopTooltip(TooltipContent tooltipContent) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: _buildTooltipCard(tooltipContent),
      ),
    );
  }

  Widget _buildBottomTooltip(TooltipContent tooltipContent) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: _buildTooltipCard(tooltipContent),
      ),
    );
  }

  Widget _buildLeftTooltip(TooltipContent tooltipContent) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 50),
        child: _buildTooltipCard(tooltipContent),
      ),
    );
  }

  Widget _buildRightTooltip(TooltipContent tooltipContent) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: _buildTooltipCard(tooltipContent),
      ),
    );
  }

  Widget _buildCenterTooltip(TooltipContent tooltipContent) {
    return Center(
      child: _buildTooltipCard(tooltipContent),
    );
  }

  Widget _buildTooltipCard(TooltipContent tooltipContent) {
    final backgroundColor = widget.backgroundColor ?? 
        Theme.of(context).colorScheme.surface;
    
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showArrow) _buildTooltipArrow(),
          _buildTooltipContent(tooltipContent),
        ],
      ),
    );
  }

  Widget _buildTooltipArrow() {
    switch (widget.position) {
      case TooltipPosition.top:
        return _buildArrowDown();
      case TooltipPosition.bottom:
        return _buildArrowUp();
      case TooltipPosition.left:
        return _buildArrowRight();
      case TooltipPosition.right:
        return _buildArrowLeft();
      case TooltipPosition.center:
        return const SizedBox.shrink();
    }
  }

  Widget _buildArrowDown() {
    return ClipPath(
      clipper: _TriangleClipper(),
      child: Container(
        width: 20,
        height: 10,
        color: widget.backgroundColor ?? 
            Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Widget _buildArrowUp() {
    return Transform.rotate(
      angle: 3.14159,
      child: ClipPath(
        clipper: _TriangleClipper(),
        child: Container(
          width: 20,
          height: 10,
          color: widget.backgroundColor ?? 
              Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }

  Widget _buildArrowRight() {
    return Transform.rotate(
      angle: -1.5708,
      child: ClipPath(
        clipper: _TriangleClipper(),
        child: Container(
          width: 20,
          height: 10,
          color: widget.backgroundColor ?? 
              Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }

  Widget _buildArrowLeft() {
    return Transform.rotate(
      angle: 1.5708,
      child: ClipPath(
        clipper: _TriangleClipper(),
        child: Container(
          width: 20,
          height: 10,
          color: widget.backgroundColor ?? 
              Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }

  Widget _buildTooltipContent(TooltipContent tooltipContent) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tooltipContent.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: _hideTooltip,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            tooltipContent.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// 三角形剪裁器，用于绘制箭头
class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

/// 帮助工具提示的管理器
class HelpTooltipManager {
  static final Map<String, GlobalKey> _tooltipKeys = {};
  static final List<String> _shownTooltips = [];

  static GlobalKey getTooltipKey(String key) {
    if (!_tooltipKeys.containsKey(key)) {
      _tooltipKeys[key] = GlobalKey();
    }
    return _tooltipKeys[key]!;
  }

  static void markTooltipShown(String key) {
    if (!_shownTooltips.contains(key)) {
      _shownTooltips.add(key);
    }
  }

  static bool isTooltipShown(String key) {
    return _shownTooltips.contains(key);
  }

  static void resetTooltipHistory() {
    _shownTooltips.clear();
  }

  static void showTooltipForKey(String key) {
    final tooltipKey = _tooltipKeys[key];
    if (tooltipKey?.currentState is _HelpTooltipState) {
      (tooltipKey!.currentState as _HelpTooltipState)._showTooltip();
    }
  }
}

/// 帮助按钮组件
class HelpButton extends StatelessWidget {
  final String tooltipKey;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? text;
  final TooltipPosition position;
  final Color? color;

  const HelpButton({
    Key? key,
    required this.tooltipKey,
    this.onPressed,
    this.icon,
    this.text,
    this.position = TooltipPosition.bottom,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpTooltip(
      tooltipKey: tooltipKey,
      position: position,
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: icon ?? const Icon(Icons.help_outline, size: 20),
          onPressed: onPressed,
          color: color != null ? null : Theme.of(context).colorScheme.onPrimaryContainer,
          tooltip: text,
        ),
      ),
    );
  }
}

/// 内联帮助提示组件
class InlineHelpTooltip extends StatelessWidget {
  final String tooltipKey;
  final Widget child;
  final TooltipPosition position;
  final bool showIcon;
  final Color? iconColor;

  const InlineHelpTooltip({
    Key? key,
    required this.tooltipKey,
    required this.child,
    this.position = TooltipPosition.bottom,
    this.showIcon = true,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        if (showIcon) ...[
          const SizedBox(width: 4),
          HelpTooltip(
            tooltipKey: tooltipKey,
            position: position,
            child: Icon(
              Icons.help_outline,
              size: 16,
              color: iconColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}