import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/shared_state_provider.dart';
import 'services/navigation_service.dart';
import 'widgets/smooth_transition.dart';
import 'utils/performance_optimizer.dart';

/// 流畅切换主页面示例
class SmoothSwitchingExample extends ConsumerStatefulWidget {
  const SmoothSwitchingExample({super.key});

  @override
  ConsumerState<SmoothSwitchingExample> createState() => _SmoothSwitchingExampleState();
}

class _SmoothSwitchingExampleState extends ConsumerState<SmoothSwitchingExample> {
  late NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _navigationService = NavigationService.instance;
    _navigationService.initialize();
    
    // 初始化性能优化器
    PerformanceOptimizationService.instance.initialize(
      config: const PerformanceConfig(
        enableMonitoring: true,
        enableAutoOptimization: true,
        enableLogging: true,
      ),
    );
  }

  @override
  void dispose() {
    _navigationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sharedState = ref.watch(sharedStateProvider);
    final performanceData = ref.watch(performanceDataProvider);
    final isSwitching = ref.watch(isSwitchingProvider);
    final transitionProgress = ref.watch(transitionProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('流畅切换示例'),
        backgroundColor: _getModeColor(sharedState.currentMode),
        foregroundColor: Colors.white,
        actions: [
          // 性能监控按钮
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showPerformanceDialog,
          ),
          // 设置按钮
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          // 主内容区域
          _buildMainContent(sharedState),
          
          // 切换进度指示器
          if (isSwitching) _buildProgressIndicator(transitionProgress),
          
          // 性能警告
          if (sharedState.cachedData['performance_warning'] == true)
            _buildPerformanceWarning(),
        ],
      ),
      
      // 底部导航栏
      bottomNavigationBar: _buildBottomNavigationBar(sharedState),
      
      // 浮动操作按钮
      floatingActionButton: _buildFloatingActionButton(sharedState),
    );
  }

  /// 构建主内容区域
  Widget _buildMainContent(SharedState sharedState) {
    return SmoothTransition(
      targetMode: sharedState.currentMode,
      duration: sharedState.transitionDuration,
      onTransitionStart: () {
        ref.read(sharedStateProvider.notifier).updateTransitionProgress(0.0);
      },
      onTransitionEnd: () {
        ref.read(sharedStateProvider.notifier).updateTransitionProgress(1.0);
      },
      child: PageContentTransition(
        mode: sharedState.currentMode,
        child: _buildModeSpecificContent(sharedState.currentMode),
      ),
    );
  }

  /// 构建模式特定内容
  Widget _buildModeSpecificContent(SwitchMode mode) {
    switch (mode) {
      case SwitchMode.browser:
        return _buildBrowserContent();
      case SwitchMode.proxy:
        return _buildProxyContent();
      case SwitchMode.switching:
        return const Center(child: CircularProgressIndicator());
    }
  }

  /// 构建浏览器内容
  Widget _buildBrowserContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🌐 浏览器模式',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          
          // 功能卡片
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                  icon: Icons.web,
                  title: '浏览网页',
                  description: '访问您喜欢的网站',
                  color: Colors.blue,
                  onTap: () => _showSnackBar('浏览网页功能'),
                ),
                _buildFeatureCard(
                  icon: Icons.bookmark,
                  title: '书签管理',
                  description: '管理您的书签',
                  color: Colors.orange,
                  onTap: () => _showSnackBar('书签管理功能'),
                ),
                _buildFeatureCard(
                  icon: Icons.history,
                  title: '历史记录',
                  description: '查看浏览历史',
                  color: Colors.green,
                  onTap: () => _showSnackBar('历史记录功能'),
                ),
                _buildFeatureCard(
                  icon: Icons.download,
                  title: '下载管理',
                  description: '管理下载文件',
                  color: Colors.purple,
                  onTap: () => _showSnackBar('下载管理功能'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建代理内容
  Widget _buildProxyContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔒 代理模式',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          
          // 代理状态卡片
          Card(
            child: ListTile(
              leading: const Icon(Icons.security, color: Colors.green),
              title: const Text('代理状态'),
              subtitle: const Text('已连接 - 高速代理'),
              trailing: Switch(
                value: true,
                onChanged: (value) => _showSnackBar('代理开关: $value'),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 功能列表
          Expanded(
            child: ListView(
              children: [
                _buildFunctionListItem(
                  icon: Icons.speed,
                  title: '网络加速',
                  subtitle: '优化网络连接速度',
                  onTap: () => _showSnackBar('网络加速功能'),
                ),
                _buildFunctionListItem(
                  icon: Icons.privacy_tip,
                  title: '隐私保护',
                  subtitle: '保护您的浏览隐私',
                  onTap: () => _showSnackBar('隐私保护功能'),
                ),
                _buildFunctionListItem(
                  icon: Icons.location_off,
                  title: '位置隐藏',
                  subtitle: '隐藏真实地理位置',
                  onTap: () => _showSnackBar('位置隐藏功能'),
                ),
                _buildFunctionListItem(
                  icon: Icons.block,
                  title: '广告拦截',
                  subtitle: '拦截恶意广告',
                  onTap: () => _showSnackBar('广告拦截功能'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建功能卡片
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建功能列表项
  Widget _buildFunctionListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  /// 构建进度指示器
  Widget _buildProgressIndicator(double progress) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 4,
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(
            _getModeColor(ref.read(sharedStateProvider).targetMode),
          ),
        ),
      ),
    );
  }

  /// 构建性能警告
  Widget _buildPerformanceWarning() {
    return Positioned(
      top: 80,
      right: 16,
      child: Card(
        color: Colors.orange.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              const Text(
                '性能警告',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建底部导航栏
  Widget _buildBottomNavigationBar(SharedState sharedState) {
    return BottomAppBar(
      color: _getModeColor(sharedState.currentMode),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.web,
            label: '浏览器',
            isActive: sharedState.currentMode == SwitchMode.browser,
            onTap: () => _switchMode(SwitchMode.browser),
          ),
          _buildNavItem(
            icon: Icons.security,
            label: '代理',
            isActive: sharedState.currentMode == SwitchMode.proxy,
            onTap: () => _switchMode(SwitchMode.proxy),
          ),
          _buildNavItem(
            icon: Icons.settings,
            label: '设置',
            isActive: false,
            onTap: () => _showSettingsDialog(),
          ),
        ],
      ),
    );
  }

  /// 构建导航项
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建浮动操作按钮
  Widget _buildFloatingActionButton(SharedState sharedState) {
    return FloatingActionButton(
      onPressed: () => _switchMode(
        sharedState.currentMode == SwitchMode.browser 
            ? SwitchMode.proxy 
            : SwitchMode.browser,
      ),
      backgroundColor: _getModeColor(
        sharedState.currentMode == SwitchMode.browser 
            ? SwitchMode.proxy 
            : SwitchMode.browser,
      ),
      child: Icon(
        sharedState.currentMode == SwitchMode.browser 
            ? Icons.security 
            : Icons.web,
        color: Colors.white,
      ),
    );
  }

  /// 切换模式
  void _switchMode(SwitchMode targetMode) async {
    final success = await _navigationService.switchToMode(
      context,
      targetMode,
      animated: true,
    );
    
    if (!success) {
      _showSnackBar('切换失败，请重试');
    }
  }

  /// 显示性能对话框
  void _showPerformanceDialog() {
    final report = PerformanceOptimizationService.instance.getPerformanceReport();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('性能监控'),
        content: SingleChildScrollView(
          child: Text(report),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
          TextButton(
            onPressed: () {
              PerformanceOptimizationService.instance.triggerOptimization();
              Navigator.of(context).pop();
              _showSnackBar('性能优化已触发');
            },
            child: const Text('优化'),
          ),
        ],
      ),
    );
  }

  /// 显示设置对话框
  void _showSettingsDialog() {
    final sharedState = ref.read(sharedStateProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('切换设置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('启用动画'),
              value: sharedState.enableAnimations,
              onChanged: (value) {
                ref.read(sharedStateProvider.notifier).setAnimationsEnabled(value);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('切换持续时间'),
              subtitle: Text('${sharedState.transitionDuration.inMilliseconds}ms'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showDurationDialog(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  /// 显示持续时间设置对话框
  void _showDurationDialog() {
    final sharedState = ref.read(sharedStateProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('切换持续时间'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDurationOption('快速', const Duration(milliseconds: 200)),
            _buildDurationOption('正常', const Duration(milliseconds: 300)),
            _buildDurationOption('慢速', const Duration(milliseconds: 500)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  /// 构建持续时间选项
  Widget _buildDurationOption(String label, Duration duration) {
    final sharedState = ref.read(sharedStateProvider);
    final isSelected = sharedState.transitionDuration == duration;
    
    return ListTile(
      title: Text(label),
      subtitle: Text('${duration.inMilliseconds}ms'),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        ref.read(sharedStateProvider.notifier).setTransitionDuration(duration);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
  }

  /// 显示消息
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 获取模式颜色
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
}

/// 主入口函数
void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: '流畅切换示例',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const SmoothSwitchingExample(),
      ),
    ),
  );
}