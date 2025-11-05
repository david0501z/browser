import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/browser_tab_widget.dart';
import '../models/browser_models.dart';
import '../providers/browser_providers.dart';

/// FlClash主页面 - 集成浏览器选项卡
/// 在原有代理功能基础上，新增浏览器选项卡，实现统一的用户体验
class MainPageBrowserIntegration extends ConsumerStatefulWidget {
  const MainPageBrowserIntegration({super.key});

  @override
  ConsumerState<MainPageBrowserIntegration> createState() => _MainPageBrowserIntegrationState();
}

class _MainPageBrowserIntegrationState extends ConsumerState<MainPageBrowserIntegration> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  
  // 浏览器相关状态
  int _browserTabIndex = 0;
  final List<BrowserTab> _browserTabs = [];
  BrowserTab? _currentBrowserTab;
  
  // 页面切换动画
  bool _isSwitchingToBrowser = false;

  @override
  void initState() {
    super.initState();
    
    // 初始化Tab控制器（包含浏览器选项卡）
    _tabController = TabController(length: 4, vsync: this);
    
    // 初始化FAB动画控制器
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );
    
    // 监听Tab切换
    _tabController.addListener(_onTabChanged);
    
    // 初始化浏览器标签页
    _initializeBrowserTabs();
    
    // 启动FAB动画
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  /// 初始化浏览器标签页
  void _initializeBrowserTabs() {
    // 创建默认首页标签页
    final homeTab = BrowserTab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: 'https://www.google.com',
      title: '首页',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    setState(() {
      _browserTabs.add(homeTab);
      _currentBrowserTab = homeTab;
    });
  }

  /// Tab切换监听
  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final currentIndex = _tabController.index;
      
      // 判断是否切换到浏览器选项卡
      setState(() {
        _isSwitchingToBrowser = currentIndex == 3; // 浏览器选项卡索引为3
      });
      
      if (currentIndex == 3) {
        // 进入浏览器模式，隐藏其他FAB
        _fabAnimationController.reverse();
      } else {
        // 退出浏览器模式，显示其他FAB
        _fabAnimationController.forward();
      }
    }
  }

  /// 创建新浏览器标签页
  void _createNewBrowserTab() {
    final newTab = BrowserTab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: 'https://www.google.com',
      title: '新标签页',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    setState(() {
      _browserTabs.add(newTab);
      _currentBrowserTab = newTab;
      _browserTabIndex = _browserTabs.length - 1;
    });
    
    // 切换到新标签页
    _tabController.animateTo(3); // 浏览器选项卡索引
  }

  /// 关闭浏览器标签页
  void _closeBrowserTab(int index) {
    if (_browserTabs.length <= 1) {
      // 至少保留一个标签页
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('至少需要保留一个标签页')),
      );
      return;
    }
    
    setState(() {
      _browserTabs.removeAt(index);
      
      // 调整当前标签页索引
      if (_browserTabIndex >= _browserTabs.length) {
        _browserTabIndex = _browserTabs.length - 1;
      }
      
      _currentBrowserTab = _browserTabs.isNotEmpty ? _browserTabs[_browserTabIndex] : null;
    });
  }

  /// 切换到指定浏览器标签页
  void _switchToBrowserTab(int index) {
    setState(() {
      _browserTabIndex = index;
      _currentBrowserTab = _browserTabs[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlClash'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.primaryColor,
          indicatorWeight: 3,
          tabs: const [
            Tab(
              icon: Icon(Icons.dashboard),
              text: '仪表盘',
            ),
            Tab(
              icon: Icon(Icons.tunnel),
              text: '代理',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: '日志',
            ),
            Tab(
              icon: Icon(Icons.public),
              text: '浏览器',
            ),
          ],
        ),
        actions: [
          // 浏览器选项卡专用操作按钮
          if (_tabController.index == 3) ...[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _createNewBrowserTab,
              tooltip: '新建标签页',
            ),
            IconButton(
              icon: const Icon(Icons.bookmarks),
              onPressed: _showBookmarks,
              tooltip: '书签',
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showBrowserSettings,
              tooltip: '浏览器设置',
            ),
          ],
          // 其他选项卡的操作按钮
          if (_tabController.index != 3) ...[
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshCurrentPage,
              tooltip: '刷新',
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showSettings,
              tooltip: '设置',
            ),
          ],
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 仪表盘页面
          _buildDashboardTab(),
          
          // 代理页面
          _buildProxyTab(),
          
          // 日志页面
          _buildLogsTab(),
          
          // 浏览器页面
          _buildBrowserTab(),
        ],
      ),
      
      // 浮动操作按钮 - 根据当前选项卡显示不同的FAB
      floatingActionButton: _buildFloatingActionButton(),
      
      // 浏览器选项卡的底部导航栏
      bottomNavigationBar: _tabController.index == 3 ? _buildBrowserBottomBar() : null,
    );
  }

  /// 构建仪表盘选项卡
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 状态卡片
          _buildStatusCard(),
          const SizedBox(height: 16),
          
          // 快速操作卡片
          _buildQuickActionsCard(),
          const SizedBox(height: 16),
          
          // 统计信息卡片
          _buildStatsCard(),
        ],
      ),
    );
  }

  /// 构建代理选项卡
  Widget _buildProxyTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.tunnel,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            '代理功能',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '代理配置和管理功能',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建日志选项卡
  Widget _buildLogsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            '日志记录',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '查看代理和浏览器日志',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建浏览器选项卡
  Widget _buildBrowserTab() {
    if (_browserTabs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.public,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              '浏览器',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '点击下方按钮创建新标签页',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _createNewBrowserTab,
              icon: const Icon(Icons.add),
              label: const Text('创建标签页'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // 浏览器标签页栏
        _buildBrowserTabBar(),
        
        // 浏览器内容区
        Expanded(
          child: _currentBrowserTab != null
              ? BrowserTabWidget(
                  tab: _currentBrowserTab!,
                  onClose: () => _closeBrowserTab(_browserTabIndex),
                  onTitleChanged: (title) => _updateBrowserTabTitle(title),
                  onUrlChanged: (url) => _updateBrowserTabUrl(url),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ],
    );
  }

  /// 构建浏览器标签页栏
  Widget _buildBrowserTabBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _browserTabs.length,
        itemBuilder: (context, index) {
          final tab = _browserTabs[index];
          final isActive = index == _browserTabIndex;
          
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: Tab(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive 
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive 
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 标签页图标
                    if (tab.favicon != null)
                      Image.network(
                        tab.favicon!,
                        width: 16,
                        height: 16,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.public,
                            size: 16,
                            color: Colors.grey,
                          );
                        },
                      )
                    else
                      const Icon(
                        Icons.public,
                        size: 16,
                        color: Colors.grey,
                      ),
                    
                    const SizedBox(width: 8),
                    
                    // 标签页标题
                    Text(
                      tab.title ?? '无标题',
                      style: TextStyle(
                        fontSize: 12,
                        color: isActive 
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // 关闭按钮
                    if (_browserTabs.length > 1)
                      GestureDetector(
                        onTap: () => _closeBrowserTab(index),
                        child: Container(
                          margin: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: isActive 
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建浏览器底部导航栏
  Widget _buildBrowserBottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            // 主页
            if (_currentBrowserTab != null) {
              // TODO: 导航到首页
            }
            break;
          case 1:
            // 书签
            _showBookmarks();
            break;
          case 2:
            // 历史
            _showHistory();
            break;
          case 3:
            // 设置
            _showBrowserSettings();
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '主页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmarks),
          label: '书签',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: '历史',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '设置',
        ),
      ],
    );
  }

  /// 构建浮动操作按钮
  Widget? _buildFloatingActionButton() {
    if (_tabController.index == 3) {
      // 浏览器选项卡 - 显示创建新标签页按钮
      return ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: _createNewBrowserTab,
          tooltip: '新建标签页',
          child: const Icon(Icons.add),
        ),
      );
    }
    
    // 其他选项卡 - 可以根据需要显示不同的FAB
    return null;
  }

  /// 构建状态卡片
  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 12,
                ),
                const SizedBox(width: 8),
                Text(
                  '连接状态',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('代理服务运行中'),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.public,
                  color: Theme.of(context).primaryColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text('浏览器模式已启用'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建快速操作卡片
  Widget _buildQuickActionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '快速操作',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickActionButton(
                  Icons.public,
                  '浏览器',
                  () => _tabController.animateTo(3),
                ),
                _buildQuickActionButton(
                  Icons.tunnel,
                  '代理',
                  () => _tabController.animateTo(1),
                ),
                _buildQuickActionButton(
                  Icons.history,
                  '日志',
                  () => _tabController.animateTo(2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建快速操作按钮
  Widget _buildQuickActionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon),
          iconSize: 32,
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  /// 构建统计信息卡片
  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '统计信息',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('0', '活跃连接'),
                _buildStatItem('${_browserTabs.length}', '浏览器标签'),
                _buildStatItem('0', '今日访问'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 更新浏览器标签页标题
  void _updateBrowserTabTitle(String title) {
    if (_currentBrowserTab != null) {
      final updatedTab = _currentBrowserTab!.copyWith(
        title: title,
        updatedAt: DateTime.now(),
      );
      
      setState(() {
        _currentBrowserTab = updatedTab;
        final index = _browserTabs.indexOf(_currentBrowserTab!);
        if (index >= 0) {
          _browserTabs[index] = updatedTab;
        }
      });
    }
  }

  /// 更新浏览器标签页URL
  void _updateBrowserTabUrl(String url) {
    if (_currentBrowserTab != null) {
      final updatedTab = _currentBrowserTab!.copyWith(
        url: url,
        updatedAt: DateTime.now(),
      );
      
      setState(() {
        _currentBrowserTab = updatedTab;
        final index = _browserTabs.indexOf(_currentBrowserTab!);
        if (index >= 0) {
          _browserTabs[index] = updatedTab;
        }
      });
    }
  }

  /// 显示书签
  void _showBookmarks() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('书签功能开发中')),
    );
  }

  /// 显示历史记录
  void _showHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('历史记录功能开发中')),
    );
  }

  /// 显示浏览器设置
  void _showBrowserSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BrowserSettingsPage(),
      ),
    );
  }

  /// 刷新当前页面
  void _refreshCurrentPage() {
    // TODO: 根据当前选项卡实现刷新逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('刷新功能开发中')),
    );
  }

  /// 显示设置
  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('设置功能开发中')),
    );
  }
}