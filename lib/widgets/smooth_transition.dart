import 'dart:async';
import '../providers/proxy_widget_providers.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 切换模式枚举
enum SwitchMode {
  auto('AUTO'),
  manual('MANUAL');

  const SwitchMode(this.value);
  final String value;
}

/// 共享状态类
class SharedState {
  final SwitchMode mode;
  final bool isAnimating;

  const SharedState({
    required this.mode,
    this.isAnimating = false,
  });
}

/// 过渡状态类
class TransitionState {
  final bool isForward;
  final Duration duration;

  const TransitionState({
    required this.isForward,
    this.duration = const Duration(milliseconds: 300),
  });
}

/// 共享状态提供者
final sharedStateProvider = StateProvider<SharedState>((ref) {
  return const SharedState(mode: SwitchMode.auto);
});

/// 平滑过渡动画组件
class SmoothTransition extends ConsumerStatefulWidget {
  final Widget child;
  final SwitchMode targetMode;
  final Duration duration;
  final Curve curve;
  final bool enableScale;
  final bool enableRotation;
  final bool enableFade;
  final VoidCallback? onTransitionStart;
  final VoidCallback? onTransitionEnd;

  const SmoothTransition({
    super.key,
    required this.child,
    required this.targetMode,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.enableScale = true,
    this.enableRotation = false,
    this.enableFade = true,
    this.onTransitionStart,
    this.onTransitionEnd,
  });

  @override
  ConsumerState<SmoothTransition> createState() => _SmoothTransitionState();
}

class _SmoothTransitionState extends ConsumerState<SmoothTransition>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupAnimationListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkTransitionState();
  }

  @override
  void didUpdateWidget(SmoothTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetMode != widget.targetMode) {
      _checkTransitionState();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 初始化动画
  void _initializeAnimations() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // 缩放动画
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // 旋转动画
    _rotationAnimation = Tween<double>(
      begin: widget.targetMode == SwitchMode.proxy ? -0.1 : 0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // 淡入淡出动画
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // 滑动动画
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  /// 设置动画监听器
  void _setupAnimationListener() {
    _controller.addListener(() {
      // 更新共享状态的过渡进度
      ref.read(sharedStateProvider.notifier).updateTransitionProgress(
        _controller.value,
      );
    });

    _controller.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
          if (!_isAnimating) {
            _isAnimating = true;
            widget.onTransitionStart?.call();
          }
          break;
        case AnimationStatus.completed:
        case AnimationStatus.dismissed:
          if (_isAnimating) {
            _isAnimating = false;
            widget.onTransitionEnd?.call();
          }
          break;
        default:
          break;
      }
    });
  }

  /// 检查过渡状态
  void _checkTransitionState() {
    final sharedState = ref.read(sharedStateProvider);
    final isTargetMode = sharedState.currentMode == widget.targetMode;
    final shouldAnimate = sharedState.enableAnimations &&
                         sharedState.transitionState == TransitionState.switching;

    if (shouldAnimate && !_controller.isAnimating) {
      _startTransition();
    } else if (isTargetMode && _controller.value != 1.0) {
      _controller.value = 1.0;
    }
  }

  /// 开始过渡动画
  void _startTransition() {
    if (_controller.isAnimating) return;

    _controller.forward().then((_) {
      // 动画完成后重置控制器
      if (mounted) {
        _controller.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sharedState = ref.watch(sharedStateProvider);
    final shouldShowTransition = sharedState.transitionState == TransitionState.switching &&
                                sharedState.targetMode == widget.targetMode;

    if (!sharedState.enableAnimations || !shouldShowTransition) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..scale(widget.enableScale ? _scaleAnimation.value : 1.0)
            ..rotateZ(widget.enableRotation ? _rotationAnimation.value : 0.0),
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.enableFade
                ? Opacity(
                    opacity: _fadeAnimation.value,
                    child: widget.child,
                  )
                : widget.child,
          ),
        );
      },
    );
  }
}

/// Hero风格的平滑过渡组件
class HeroSmoothTransition extends ConsumerStatefulWidget {
  final String tag;
  final Widget child;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onTransitionStart;
  final VoidCallback? onTransitionEnd;

  const HeroSmoothTransition({
    super.key,
    required this.tag,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.elasticOut,
    this.onTransitionStart,
    this.onTransitionEnd,
  });

  @override
  ConsumerState<HeroSmoothTransition> createState() => _HeroSmoothTransitionState();
}

class _HeroSmoothTransitionState extends ConsumerState<HeroSmoothTransition>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Rect?> _rectAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.5 + (_animation.value * 0.5),
            child: Transform.rotate(
              angle: (1.0 - _animation.value) * 0.1,
              child: Opacity(
                opacity: _animation.value,
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 加载指示器过渡组件
class LoadingSmoothTransition extends ConsumerWidget {
  final bool isLoading;
  final Widget child;
  final Widget loadingWidget;
  final Duration fadeDuration;
  final Curve curve;

  const LoadingSmoothTransition({
    super.key,
    required this.isLoading,
    required this.child,
    required this.loadingWidget,
    this.fadeDuration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSwitcher(
      duration: fadeDuration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: isLoading ? loadingWidget : child,
    );
  }
}

/// 页面内容过渡组件
class PageContentTransition extends ConsumerStatefulWidget {
  final Widget child;
  final SwitchMode mode;
  final Duration duration;
  final bool enableSlide;
  final bool enableScale;

  const PageContentTransition({
    super.key,
    required this.child,
    required this.mode,
    this.duration = const Duration(milliseconds: 350),
    this.enableSlide = true,
    this.enableScale = true,
  });

  @override
  ConsumerState<PageContentTransition> createState() => _PageContentTransitionState();
}

class _PageContentTransitionState extends ConsumerState<PageContentTransition>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAndStartAnimation();
  }

  @override
  void didUpdateWidget(PageContentTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode) {
      _checkAndStartAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
  }

  void _checkAndStartAnimation() {
    final sharedState = ref.read(sharedStateProvider);
    final shouldAnimate = sharedState.currentMode == widget.mode &&
                         sharedState.transitionState == TransitionState.completed;

    if (shouldAnimate && !_controller.isAnimating) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: widget.enableSlide ? _slideAnimation.value : Offset.zero,
          child: Transform.scale(
            scale: widget.enableScale ? _scaleAnimation.value : 1.0,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

/// 切换模式指示器组件
class SwitchModeIndicator extends ConsumerWidget {
  final SwitchMode currentMode;
  final VoidCallback? onTap;
  final bool showLabels;
  final double size;

  const SwitchModeIndicator({
    super.key,
    required this.currentMode,
    this.onTap,
    this.showLabels = true,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getModeColor(currentMode).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _getModeColor(currentMode).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getModeIcon(currentMode),
              size: size,
              color: _getModeColor(currentMode),
            ),
            if (showLabels) ...[
              const SizedBox(width: 8),
              Text(
                _getModeLabel(currentMode),
                style: TextStyle(
                  color: _getModeColor(currentMode),
                  fontSize: size * 0.7,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getModeColor(SwitchMode mode) {
    switch (mode) {
      case SwitchMode.browser:
        return Colors.blue;
      case SwitchMode.proxy:
        return Colors.green;
      case SwitchMode.switching:
        return Colors.orange;
    }
  }

  IconData _getModeIcon(SwitchMode mode) {
    switch (mode) {
      case SwitchMode.browser:
        return Icons.web;
      case SwitchMode.proxy:
        return Icons.security;
      case SwitchMode.switching:
        return Icons.sync;
    }
  }

  String _getModeLabel(SwitchMode mode) {
    switch (mode) {
      case SwitchMode.browser:
        return '浏览器';
      case SwitchMode.proxy:
        return '代理';
      case SwitchMode.switching:
        return '切换中';
    }
  }
}

/// 自定义曲线扩展
extension CustomCurves on Curve {
  /// 弹性输出曲线
  static const Curve elasticOut = _ElasticOutCurve();
  
  /// 弹性输入曲线
  static const Curve elasticIn = _ElasticInCurve();
  
  /// 回弹输出曲线
  static const Curve backOut = _BackOutCurve();
  
  /// 回弹输入曲线
  static const Curve backIn = _BackInCurve();
}

/// 弹性输出曲线
class _ElasticOutCurve extends Curve {
  const _ElasticOutCurve();

  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return t;
    }
    final p = 0.3;
    return math.pow(2, -10 * t) * math.sin((t - p / 4) * (2 * math.pi) / p) + 1;
  }
}

/// 弹性输入曲线
class _ElasticInCurve extends Curve {
  const _ElasticInCurve();

  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return t;
    }
    final p = 0.3;
    return -math.pow(2, 10 * (t - 1)) * math.sin((t - 1 - p / 4) * (2 * math.pi) / p);
  }
}

/// 回弹输出曲线
class _BackOutCurve extends Curve {
  const _BackOutCurve();

  @override
  double transform(double t) {
    const c1 = 1.70158;
    const c3 = c1 + 1;
    return 1 + c3 * math.pow(t - 1, 3) + c1 * math.pow(t - 1, 2);
  }
}

/// 回弹输入曲线
class _BackInCurve extends Curve {
  const _BackInCurve();

  @override
  double transform(double t) {
    const c1 = 1.70158;
    const c3 = c1 + 1;
    return c3 * t * t * t - c1 * t * t;
  }
}