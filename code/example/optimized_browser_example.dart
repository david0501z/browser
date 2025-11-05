import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/browser_theme.dart';
import '../widgets/responsive_browser_layout.dart';
import '../widgets/browser_app_bar.dart';
import '../widgets/browser_bottom_nav.dart';

/// 优化后的浏览器页面示例
/// 
/// 展示如何使用新的UI组件：
/// - 响应式布局
/// - 动态应用栏
/// - 主题切换
/// - 底部导航
class OptimizedBrowserPage extends StatefulWidget {
  const OptimizedBrowserPage({Key? key}) : super(key: key);

  @override
  State<OptimizedBrowserPage> createState() => _OptimizedBrowserPageState();
}

class _OptimizedBrowserPageState extends State<OptimizedBrowserPage>
    with TickerProviderStateMixin {
  // 主题状态
  bool _isDarkMode = false;
  
  // 标签页状态
  int _currentTabIndex = 0;
  final List<BrowserTabItem> _tabs = [
    const BrowserTabItem(
      id: '1',
      title: 'Google 搜索',
      url: 'https://www.google.com',
      favicon: 'https://www.google.com/favicon.ico',
    ),
    const BrowserTabItem(
      id: '2',
      title: 'FlClash GitHub',
      url: 'https://github.com/chenfsong/flclash',
      favicon: 'https://github.com/favicon.ico',
    ),
    const BrowserTabItem(
      id: '3',
      title: 'Flutter 官网',
      url: 'https://flutter.dev',
      favicon: 'https://flutter.dev/favicon.ico',
    ),
  ];
  
  // 底部导航状态
  int _currentNavIndex = 0;
  
  // 动画控制器
  late AnimationController _themeAnimationController;
  late Animation<double> _themeAnimation;

  @override
  void initState() {
    super.initState();
    
    // 初始化主题动画
    _themeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _themeAnimation = CurvedAnimation(
      parent: _themeAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _themeAnimationController.dispose();
    super.dispose();
  }

  /// 切换主题
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    
    if (_isDarkMode) {
      _themeAnimationController.forward();
    } else {
      _themeAnimationController.reverse();
    }
    
    HapticFeedback.lightImpact();
  }

  /// 处理标签页变化
  void _handleTabChanged(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  /// 关闭标签页
  void _handleTabClosed(int index) {
    setState(() {
      _tabs.removeAt(index);
      if (_currentTabIndex >= _tabs.length) {
        _currentTabIndex = _tabs.length - 1;
      }
    });
  }

  /// 添加新标签页
  void _addNewTab() {
    final newTab = BrowserTabItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '新标签页',
      url: 'https://www.google.com',
    );
    
    setState(() {
      _tabs.add(newTab);
      _currentTabIndex = _tabs.length - 1;
    });
    
    HapticFeedback.mediumImpact();
  }

  /// 处理搜索
  void _handleSearch(String query) {
    if (query.isEmpty) return;
    
    // 更新当前标签页URL
    setState(() {
      if (_currentTabIndex < _tabs.length) {
        _tabs[_currentTabIndex] = _tabs[_currentTabIndex].copyWith(
          title: query,
          url: _isValidUrl(query) ? query : 'https://www.google.com/search?q=${Uri.encodeComponent(query)}',
        );
      }
    });
    
    HapticFeedback.lightImpact();
  }

  /// 检查是否为有效URL
  bool _isValidUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  /// 处理底部导航点击
  void _handleBottomNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });
    
    HapticFeedback.lightImpact();
    
    // 根据索引执行相应操作
    switch (index) {
      case 0:
        _goHome();
        break;
      case 1:
        _openBookmarks();
        break;
      case 2:
        _addNewTab();
        break;
      case 3:
        _openHistory();
        break;
      case 4:
        _showSettings();
        break;
    }
  }

  /// 底部导航操作方法
  void _goHome() {
    // TODO: 实现返回主页
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('返回主页')),
    );
  }

  void _openBookmarks() {
    // TODO: 打开书签页面
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('打开书签页面')),
    );
  }

  void _openHistory() {
    // TODO: 打开历史记录页面
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('打开历史记录页面')),
    );
  }

  void _showSettings() {
    // TODO: 显示设置页面
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSettingsSheet(),
    );
  }

  /// 构建设置底部表单
  Widget _buildSettingsSheet() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 拖拽手柄
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // 设置标题
                Text(
                  '浏览器设置',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                
                // 主题设置
                _buildSettingItem(
                  icon: Icons.brightness_6,
                  title: '深色模式',
                  subtitle: '切换深色和浅色主题',
                  trailing: Switch(
                    value: _isDarkMode,
                    onChanged: (value) => _toggleTheme(),
                  ),
                ),
                
                // 搜索引擎设置
                _buildSettingItem(
                  icon: Icons.search,
                  title: '搜索引擎',
                  subtitle: '选择默认搜索引擎',
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showSearchEngineDialog(),
                ),
                
                // 隐私设置
                _buildSettingItem(
                  icon: Icons.security,
                  title: '隐私与安全',
                  subtitle: '管理隐私设置',
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showPrivacyDialog(),
                ),
                
                // 高级设置
                _buildSettingItem(
                  icon: Icons.tune,
                  title: '高级设置',
                  subtitle: '浏览器高级选项',
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showAdvancedDialog(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 构建设置项
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  /// 显示搜索引擎对话框
  void _showSearchEngineDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择搜索引擎'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSearchEngineOption('Google', 'https://www.google.com/search?q='),
            _buildSearchEngineOption('百度', 'https://www.baidu.com/s?wd='),
            _buildSearchEngineOption('必应', 'https://www.bing.com/search?q='),
            _buildSearchEngineOption('DuckDuckGo', 'https://duckduckgo.com/?q='),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  /// 构建搜索引擎选项
  Widget _buildSearchEngineOption(String name, String url) {
    return RadioListTile<String>(
      title: Text(name),
      value: url,
      groupValue: 'https://www.google.com/search?q=',
      onChanged: (value) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已选择 $name 作为默认搜索引擎')),
        );
      },
    );
  }

  /// 显示隐私设置对话框
  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('隐私与安全'),
        content: const Text('隐私设置功能即将推出'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示高级设置对话框
  void _showAdvancedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('高级设置'),
        content: const Text('高级设置功能即将推出'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeAnimation,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlClash 浏览器',
          theme: _isDarkMode ? BrowserTheme.darkTheme : BrowserTheme.lightTheme,
          home: ResponsiveBrowserLayout(
            showAppBar: true,
            showToolbar: true,
            showBottomNav: true,
            child: _buildBrowserContent(),
          ),
        );
      },
    );
  }

  /// 构建浏览器内容
  Widget _buildBrowserContent() {
    return Column(
      children: [
        // 浏览器应用栏
        BrowserAppBar(
          title: 'FlClash 浏览器',
          showTabs: true,
          showSearch: true,
          showActions: true,
          tabs: _tabs,
          currentTabIndex: _currentTabIndex,
          onTabChanged: _handleTabChanged,
          onTabClosed: _handleTabClosed,
          onNewTab: _addNewTab,
          onSearch: _handleSearch,
          onMenuPressed: _showSettings,
          onThemeToggle: _toggleTheme,
        ),
        
        // 主要内容区域
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.language,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _tabs.isNotEmpty 
                        ? _tabs[_currentTabIndex].title 
                        : '新标签页',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _tabs.isNotEmpty 
                        ? _tabs[_currentTabIndex].url ?? ''
                        : 'https://www.google.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _addNewTab,
                        icon: const Icon(Icons.add),
                        label: const Text('新建标签页'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: _handleSearch,
                        icon: const Icon(Icons.search),
                        label: const Text('搜索'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // 底部导航栏
        BrowserBottomNav(
          items: BrowserBottomNavPresets.standardBrowser,
          currentIndex: _currentNavIndex,
          onTap: _handleBottomNavTap,
          enableHapticFeedback: true,
        ),
      ],
    );
  }
}

/// 主应用入口
void main() {
  runApp(const OptimizedBrowserPage());
}