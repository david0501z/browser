import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 新用户引导页面
/// 提供完整的首次使用引导体验
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentIndex = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // 启动初始动画
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _nextStep() async {
    if (_isAnimating || _currentIndex >= HelpContent.onboardingSteps.length - 1) {
      return;
    }

    setState(() {
      _isAnimating = true;
    });

    // 执行退出动画
    await _slideController.reverse();
    
    setState(() {
      _currentIndex++;
      _isAnimating = false;
    });

    // 执行进入动画
    _slideController.forward();
    
    // 如果是最后一步，显示完成按钮
    if (_currentIndex == HelpContent.onboardingSteps.length - 1) {
      _showCompletionDialog();
    }
  }

  void _previousStep() async {
    if (_isAnimating || _currentIndex <= 0) {
      return;
    }

    setState(() {
      _isAnimating = true;
    });

    await _slideController.reverse();
    
    setState(() {
      _currentIndex--;
      _isAnimating = false;
    });

    _slideController.forward();
  }

  void _skipOnboarding() {
    Navigator.of(context).pop();
    // 标记引导已完成
    _markOnboardingCompleted();
  }

  void _markOnboardingCompleted() async {
    // 保存引导完成状态到本地存储
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _CompletionDialog(
          onStartTutorial: () {
            Navigator.of(context).pop();
            _startInteractiveTutorial();
          },
          onSkip: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _startInteractiveTutorial() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TutorialOverlayPage(
          steps: HelpContent.tutorialSteps,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildTopBar(),
            
            // 引导内容区域
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildOnboardingContent(),
                ),
              ),
            ),
            
            // 底部操作按钮
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // 进度指示器
          Expanded(
            child: _buildProgressIndicator(),
          ),
          
          // 跳过按钮
          TextButton(
            onPressed: _isAnimating ? null : _skipOnboarding,
            child: Text(
              HelpLocalization.getLocalizedText('skip', 'zh'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(
        HelpContent.onboardingSteps.length,
        (index) {
          final isActive = index == _currentIndex;
          final isCompleted = index < _currentIndex;
          
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(
                right: index < HelpContent.onboardingSteps.length - 1 ? 8 : 0,
              ),
              decoration: BoxDecoration(
                color: isCompleted
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isActive
                    ? FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOnboardingContent() {
    final step = HelpContent.onboardingSteps[_currentIndex];
    
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: HelpContent.onboardingSteps.length,
      itemBuilder: (context, index) {
        return _buildStepContent(step);
      },
    );
  }

  Widget _buildStepContent(OnboardingStep step) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 步骤图片或动画
          Expanded(
            flex: 3,
            child: _buildStepImage(step),
          ),
          
          const SizedBox(height: 32),
          
          // 步骤标题
          Text(
            step.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // 步骤描述
          Text(
            step.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepImage(OnboardingStep step) {
    // 如果有动画文件，使用Lottie动画
    if (step.animation != null) {
      return _buildLottieAnimation(step.animation!);
    }
    
    // 否则使用静态图片
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(step.image),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildLottieAnimation(String animationFile) {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // 上一步按钮
          if (_currentIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _isAnimating ? null : _previousStep,
                child: Text(
                  HelpLocalization.getLocalizedText('previous', 'zh'),
                ),
              ),
            ),
          
          if (_currentIndex > 0) const SizedBox(width: 16),
          
          // 下一步按钮
          Expanded(
            flex: _currentIndex > 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: _isAnimating ? null : _nextStep,
              child: Text(
                _currentIndex == HelpContent.onboardingSteps.length - 1;
                    ? HelpLocalization.getLocalizedText('finish', 'zh')
                    : HelpLocalization.getLocalizedText('next', 'zh'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 完成引导对话框
class _CompletionDialog extends StatelessWidget {
  final VoidCallback onStartTutorial;
  final VoidCallback onSkip;

  const _CompletionDialog({
    required this.onStartTutorial,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text('引导完成！'),
      content: const Text(
        '您已完成新用户引导。现在可以开始使用应用，或者观看交互式教程了解更多功能。',
      ),
      actions: [
        TextButton(
          onPressed: onSkip,
          child: const Text('跳过教程'),
        ),
        ElevatedButton(
          onPressed: onStartTutorial,
          child: const Text('观看教程'),
        ),
      ],
    );
  }
}