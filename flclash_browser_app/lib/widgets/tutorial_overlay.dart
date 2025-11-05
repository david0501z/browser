import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/help_content.dart';

/// 教程覆盖层页面
/// 提供交互式引导体验
class TutorialOverlayPage extends StatefulWidget {
  final List<TutorialStep> steps;
  final String? title;
  final VoidCallback? onComplete;
  final bool allowSkip;
  final bool showProgress;

  const TutorialOverlayPage({
    Key? key,
    required this.steps,
    this.title,
    this.onComplete,
    this.allowSkip = true,
    this.showProgress = true,
  }) : super(key: key);

  @override
  State<TutorialOverlayPage> createState() => _TutorialOverlayPageState();
}

class _TutorialOverlayPageState extends State<TutorialOverlayPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _overlayController;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  
  late Animation<double> _overlayFade;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentStep = 0;
  bool _isAnimating = false;
  final GlobalKey _highlightKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _overlayFade = Tween<double>(
      begin: 0.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // 启动初始动画
    _overlayController.forward();
    _pulseController.repeat(reverse: true);
    _slideController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _overlayController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _nextStep() async {
    if (_isAnimating || _currentStep >= widget.steps.length - 1) {
      _completeTutorial();
      return;
    }

    setState(() {
      _isAnimating = true;
    });

    await _slideController.reverse();
    
    setState(() {
      _currentStep++;
      _isAnimating = false;
    });

    _slideController.forward();
  }

  void _previousStep() async {
    if (_isAnimating || _currentStep <= 0) return;

    setState(() {
      _isAnimating = true;
    });

    await _slideController.reverse();
    
    setState(() {
      _currentStep--;
      _isAnimating = false;
    });

    _slideController.forward();
  }

  void _skipTutorial() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('跳过教程'),
        content: const Text('确定要跳过教程吗？您可以随时在设置中重新开始。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('继续'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _completeTutorial();
            },
            child: const Text('跳过'),
          ),
        ],
      ),
    );
  }

  void _completeTutorial() {
    widget.onComplete?.call();
    Navigator.of(context).pop();
    
    // 显示完成提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('教程完成！您现在可以开始使用应用了。'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 背景遮罩
          _buildOverlayBackground(),
          
          // 高亮区域
          _buildHighlightArea(),
          
          // 教程内容
          _buildTutorialContent(),
          
          // 进度指示器
          if (widget.showProgress) _buildProgressIndicator(),
          
          // 跳过按钮
          if (widget.allowSkip) _buildSkipButton(),
        ],
      ),
    );
  }

  Widget _buildOverlayBackground() {
    return AnimatedBuilder(
      animation: _overlayController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _overlayFade,
          child: Container(
            color: Colors.black,
          ),
        );
      },
    );
  }

  Widget _buildHighlightArea() {
    final currentStep = widget.steps[_currentStep];
    
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: currentStep.action != TutorialAction.highlight,
        child: _buildHighlightWidget(currentStep),
      ),
    );
  }

  Widget _buildHighlightWidget(TutorialStep step) {
    // 这里应该根据 targetWidget 查找对应的组件
    // 在实际应用中，需要通过 GlobalKey 或其他方式定位目标组件
    return Center(
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
              child: Icon(
                Icons.touch_app,
                color: Theme.of(context).colorScheme.primary,
                size: 48,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTutorialContent() {
    final currentStep = widget.steps[_currentStep];
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: _buildContentCard(currentStep),
      ),
    );
  }

  Widget _buildContentCard(TutorialStep step) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            step.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 描述
          Text(
            step.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          
          const SizedBox(height: 24),
          
          // 操作按钮
          Row(
            children: [
              // 上一步按钮
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isAnimating ? null : _previousStep,
                    child: const Text('上一步'),
                  ),
                ),
              
              if (_currentStep > 0) const SizedBox(width: 12),
              
              // 下一步按钮
              Expanded(
                flex: _currentStep > 0 ? 1 : 2,
                child: ElevatedButton(
                  onPressed: _isAnimating ? null : _nextStep,
                  child: Text(
                    _currentStep == widget.steps.length - 1
                        ? '完成'
                        : '下一步',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / widget.steps.length,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${_currentStep + 1}/${widget.steps.length}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Positioned(
      top: 50,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _skipTutorial,
          tooltip: '跳过教程',
        ),
      ),
    );
  }
}

/// 教程覆盖层管理器
class TutorialOverlayManager {
  static OverlayEntry? _currentOverlay;
  static bool _isShowing = false;

  static void showTutorial({
    required BuildContext context,
    required List<TutorialStep> steps,
    String? title,
    VoidCallback? onComplete,
    bool allowSkip = true,
  }) {
    if (_isShowing) return;

    _currentOverlay = OverlayEntry(
      builder: (context) => TutorialOverlayPage(
        steps: steps,
        title: title,
        onComplete: () {
          hideTutorial();
          onComplete?.call();
        },
        allowSkip: allowSkip,
      ),
    );

    Overlay.of(context).insert(_currentOverlay!);
    _isShowing = true;
  }

  static void hideTutorial() {
    if (_currentOverlay != null && _currentOverlay!.mounted) {
      _currentOverlay!.remove();
    }
    _currentOverlay = null;
    _isShowing = false;
  }

  static bool isShowing() => _isShowing;
}

/// 交互式引导组件
class InteractiveGuide extends StatefulWidget {
  final Widget child;
  final String guideId;
  final String title;
  final String description;
  final TutorialAction action;
  final VoidCallback? onActionCompleted;

  const InteractiveGuide({
    Key? key,
    required this.child,
    required this.guideId,
    required this.title,
    required this.description,
    this.action = TutorialAction.highlight,
    this.onActionCompleted,
  }) : super(key: key);

  @override
  State<InteractiveGuide> createState() => _InteractiveGuideState();
}

class _InteractiveGuideState extends State<InteractiveGuide>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isHighlighted = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startHighlight() {
    setState(() {
      _isHighlighted = true;
    });
    _pulseController.repeat(reverse: true);
  }

  void _stopHighlight() {
    setState(() {
      _isHighlighted = false;
    });
    _pulseController.stop();
  }

  void _onAction() {
    widget.onActionCompleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.action == TutorialAction.tap ? _onAction : null,
      onLongPress: widget.action == TutorialAction.longPress ? _onAction : null,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isHighlighted ? _pulseAnimation.value : 1.0,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// 引导步骤指示器
class GuideStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<TutorialStep> steps;

  const GuideStepIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 进度条
          LinearProgressIndicator(
            value: (currentStep + 1) / totalSteps,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          
          // 步骤信息
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '步骤 ${currentStep + 1} / $totalSteps',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                steps[currentStep].title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 引导操作按钮
class GuideActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final IconData? icon;

  const GuideActionButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.style,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: style,
      icon: icon != null ? Icon(icon) : null,
      label: Text(text),
    );
  }
}

/// 引导内容卡片
class GuideContentCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget? image;
  final List<Widget>? actions;

  const GuideContentCard({
    Key? key,
    required this.title,
    required this.description,
    this.image,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片
            if (image != null) ...[
              Center(child: image),
              const SizedBox(height: 16),
            ],
            
            // 标题
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // 描述
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            
            // 操作按钮
            if (actions != null) ...[
              const SizedBox(height: 24),
              ...actions!,
            ],
          ],
        ),
      ),
    );
  }
}