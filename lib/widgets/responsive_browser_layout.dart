import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/browser_theme.dart';

/// 响应式浏览器布局组件
/// 
/// 实现：
/// - 自适应不同屏幕尺寸
/// - 桌面端和移动端布局优化
/// - 横屏和竖屏支持
/// - 触摸友好的交互设计
class ResponsiveBrowserLayout extends StatefulWidget {
  const ResponsiveBrowserLayout({
    Key? key,
    required this.child,
    this.showBottomNav = true,
    this.showAppBar = true,
    this.showToolbar = true,
    this.extendBodyBehindAppBar = false,
  }) : super(key: key);

  final Widget child;
  final bool showBottomNav;
  final bool showAppBar;
  final bool showToolbar;
  final bool extendBodyBehindAppBar;

  @override
  State<ResponsiveBrowserLayout> createState() => _ResponsiveBrowserLayoutState();
}

class _ResponsiveBrowserLayoutState extends State<ResponsiveBrowserLayout>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // 屏幕信息
  bool _isTablet = false;
  bool _isLandscape = false;
  double _screenWidth = 0;
  double _screenHeight = 0;
  
  // 手势状态
  bool _isDragging = false;
  Offset? _startPosition;
  Offset? _currentPosition;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.02),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateScreenInfo();
  }

  @override
  void didUpdateWidget(ResponsiveBrowserLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateScreenInfo();
  }

  /// 更新屏幕信息
  void _updateScreenInfo() {
    final size = MediaQuery.of(context).size;
    setState(() {
      _screenWidth = size.width;
      _screenHeight = size.height;
      _isLandscape = size.width > size.height;
      _isTablet = size.width >= 768;
    });
  }

  /// 获取响应式布局配置
  LayoutConfig _getLayoutConfig() {
    return LayoutConfig(
      isTablet: _isTablet,
      isLandscape: _isLandscape,
      screenWidth: _screenWidth,
      screenHeight: _screenHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final layoutConfig = _getLayoutConfig();
    
    return Scaffold(
      extendBody: widget.extendBodyBehindAppBar,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      body: GestureDetector(
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ExtensionData.getBrowserColor(context, 'safe'),
                ExtensionData.getBrowserColor(context, 'surface'),
              ],
            ),
          ),
          child: SafeArea(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildLayout(layoutConfig),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// 构建主布局
  Widget _buildLayout(LayoutConfig config) {
    if (config.isTablet) {
      return _buildTabletLayout(config);
    } else {
      return _buildMobileLayout(config);
    }
  }

  /// 构建移动端布局
  Widget _buildMobileLayout(LayoutConfig config) {
    return Column(
      children: [
        // 顶部应用栏
        if (widget.showAppBar) _buildAppBar(config),
        
        // 浏览器工具栏
        if (widget.showToolbar) _buildToolbar(config),
        
        // 主要内容区域
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: config.isLandscape ? _screenWidth * 0.1 : 0,
            ),
            child: widget.child,
          ),
        ),
        
        // 底部导航栏
        if (widget.showBottomNav) _buildBottomNav(config),
      ],
    );
  }

  /// 构建平板端布局
  Widget _buildTabletLayout(LayoutConfig config) {
    if (config.isLandscape) {
      // 横屏平板：侧边栏 + 主内容区
      return Row(
        children: [
          // 左侧边栏
          SizedBox(
            width: _screenWidth * 0.25,
            child: _buildSidebar(config),
          ),
          
          // 右侧主内容区
          Expanded(
            child: Column(
              children: [
                // 顶部工具栏（简化版）
                if (widget.showToolbar) _buildTabletToolbar(config),
                
                // 主内容
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // 竖屏平板：类似移动端但更大
      return Column(
        children: [
          // 顶部应用栏
          if (widget.showAppBar) _buildAppBar(config),
          
          // 浏览器工具栏
          if (widget.showToolbar) _buildToolbar(config),
          
          // 主要内容区域
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: _screenWidth * 0.05,
              ),
              child: widget.child,
            ),
          ),
          
          // 底部导航栏
          if (widget.showBottomNav) _buildBottomNav(config),
        ],
      );
    }
  }

  /// 构建应用栏
  Widget _buildAppBar(LayoutConfig config) {
    return Container(
      height: ExtensionData.tabHeight,
      decoration: BoxDecoration(
        color: ExtensionData.getBrowserColor(context, 'toolbar'),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // 应用图标和标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'FlClash 浏览器',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // 右侧操作按钮
          if (config.isTablet)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => _showSettings(),
                    tooltip: '设置',
                  ),
                  IconButton(
                    icon: const Icon(Icons.brightness_6),
                    onPressed: () => _toggleTheme(),
                    tooltip: '切换主题',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 构建浏览器工具栏
  Widget _buildToolbar(LayoutConfig config) {
    return Container(
      height: ExtensionData.toolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ExtensionData.getBrowserColor(context, 'toolbar'),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // 导航按钮组
          _buildNavButtons(config),
          
          const SizedBox(width: 12),
          
          // 搜索框
          Expanded(
            child: _buildSearchField(config),
          ),
          
          const SizedBox(width: 12),
          
          // 功能按钮组
          _buildActionButtons(config),
        ],
      ),
    );
  }

  /// 构建平板端工具栏
  Widget _buildTabletToolbar(LayoutConfig config) {
    return Container(
      height: ExtensionData.toolbarHeight * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: ExtensionData.getBrowserColor(context, 'toolbar'),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // 简化导航按钮
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _goBack(),
            tooltip: '后退',
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => _goForward(),
            tooltip: '前进',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refresh(),
            tooltip: '刷新',
          ),
          
          const SizedBox(width: 16),
          
          // 搜索框
          Expanded(
            child: Container(
              height: ExtensionData.browserInputHeight,
              child: TextField(
                decoration: InputDecoration(
                  hintText: '搜索或输入网址',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onSubmitted: _handleSearch,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 功能按钮
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(),
            tooltip: '更多选项',
          ),
        ],
      ),
    );
  }

  /// 构建导航按钮组
  Widget _buildNavButtons(LayoutConfig config) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNavButton(
          icon: Icons.arrow_back_ios,
          onPressed: _goBack,
          tooltip: '后退',
        ),
        const SizedBox(width: 4),
        _buildNavButton(
          icon: Icons.arrow_forward_ios,
          onPressed: _goForward,
          tooltip: '前进',
        ),
      ],
    );
  }

  /// 构建导航按钮
  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Container(
            width: 32,
            height: 32,
            child: Icon(
              icon,
              size: 18,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建搜索框
  Widget _buildSearchField(LayoutConfig config) {
    return Container(
      height: ExtensionData.browserInputHeight,
      decoration: BoxDecoration(
        color: ExtensionData.getBrowserColor(context, 'search'),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: '搜索或输入网址',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade500,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        textInputAction: TextInputAction.go,
        onSubmitted: _handleSearch,
      ),
    );
  }

  /// 构建功能按钮组
  Widget _buildActionButtons(LayoutConfig config) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: Icons.add_box_outlined,
          onPressed: _newTab,
          tooltip: '新标签页',
        ),
        const SizedBox(width: 4),
        _buildActionButton(
          icon: Icons.more_vert,
          onPressed: _showMoreOptions,
          tooltip: '更多选项',
        ),
      ],
    );
  }

  /// 构建功能按钮
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Container(
            width: 32,
            height: 32,
            child: Icon(
              icon,
              size: 18,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建侧边栏
  Widget _buildSidebar(LayoutConfig config) {
    return Container(
      decoration: BoxDecoration(
        color: ExtensionData.getBrowserColor(context, 'surface'),
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          // 侧边栏标题
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              '浏览器工具',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // 侧边栏内容
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSidebarItem(
                  icon: Icons.bookmarks,
                  title: '书签',
                  onTap: () => _openBookmarks(),
                ),
                _buildSidebarItem(
                  icon: Icons.history,
                  title: '历史记录',
                  onTap: () => _openHistory(),
                ),
                _buildSidebarItem(
                  icon: Icons.download,
                  title: '下载',
                  onTap: () => _openDownloads(),
                ),
                _buildSidebarItem(
                  icon: Icons.settings,
                  title: '设置',
                  onTap: () => _showSettings(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建侧边栏项
  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建底部导航栏
  Widget _buildBottomNav(LayoutConfig config) {
    return Container(
      height: ExtensionData.bottomNavHeight,
      decoration: BoxDecoration(
        color: ExtensionData.getBrowserColor(context, 'surface'),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomNavItem(
            icon: Icons.home,
            label: '主页',
            onTap: () => _goHome(),
          ),
          _buildBottomNavItem(
            icon: Icons.bookmarks,
            label: '书签',
            onTap: () => _openBookmarks(),
          ),
          _buildBottomNavItem(
            icon: Icons.history,
            label: '历史',
            onTap: () => _openHistory(),
          ),
          _buildBottomNavItem(
            icon: Icons.download,
            label: '下载',
            onTap: () => _openDownloads(),
          ),
          _buildBottomNavItem(
            icon: Icons.settings,
            label: '设置',
            onTap: () => _showSettings(),
          ),
        ],
      ),
    );
  }

  /// 构建底部导航项
  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 手势处理
  void _handlePanStart(DragStartDetails details) {
    _isDragging = true;
    _startPosition = details.globalPosition;
    _currentPosition = details.globalPosition;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_isDragging && _startPosition != null) {
      _currentPosition = details.globalPosition;
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    _isDragging = false;
    _startPosition = null;
    _currentPosition = null;
  }

  // 事件处理方法
  void _handleSearch(String query) {
    // TODO: 实现搜索逻辑
  }

  void _goBack() {
    // TODO: 实现后退逻辑
  }

  void _goForward() {
    // TODO: 实现前进逻辑
  }

  void _refresh() {
    // TODO: 实现刷新逻辑
  }

  void _newTab() {
    // TODO: 实现新标签页逻辑
  }

  void _showMoreOptions() {
    // TODO: 显示更多选项
  }

  void _showSettings() {
    // TODO: 显示设置页面
  }

  void _toggleTheme() {
    // TODO: 切换主题
  }

  void _goHome() {
    // TODO: 返回主页
  }

  void _openBookmarks() {
    // TODO: 打开书签页面
  }

  void _openHistory() {
    // TODO: 打开历史记录页面
  }

  void _openDownloads() {
    // TODO: 打开下载页面
  }
}

/// 布局配置类
class LayoutConfig {
  final bool isTablet;
  final bool isLandscape;
  final double screenWidth;
  final double screenHeight;

  const LayoutConfig({
    required this.isTablet,
    required this.isLandscape,
    required this.screenWidth,
    required this.screenHeight,
  });

  /// 获取断点类型
  BreakpointType get breakpoint {
    if (screenWidth >= 1200) return BreakpointType.desktop;
    if (screenWidth >= 768) return BreakpointType.tablet;
    return BreakpointType.mobile;
  }

  /// 是否为桌面端
  bool get isDesktop => breakpoint == BreakpointType.desktop;

  /// 是否为移动端
  bool get isMobile => breakpoint == BreakpointType.mobile;

  /// 获取内容宽度
  double get contentWidth {
    switch (breakpoint) {
      case BreakpointType.desktop:
        return 1200;
      case BreakpointType.tablet:
        return 768;
      case BreakpointType.mobile:
        return screenWidth;
    }
  }
}

/// 断点类型
enum BreakpointType {
  mobile,
  tablet,
  desktop,
}