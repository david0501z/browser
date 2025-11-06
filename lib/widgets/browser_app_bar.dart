import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 浏览器应用栏组件
/// 
/// 实现：
/// - 动态应用栏标题
/// - 标签页管理
/// - 搜索功能集成
/// - 主题切换支持
/// - 响应式设计
class BrowserAppBar extends StatefulWidget implements PreferredSizeWidget {
  const BrowserAppBar({
    Key? key,
    this.title = 'FlClash 浏览器',
    this.showTabs = true,
    this.showSearch = true,
    this.showActions = true,
    this.tabs = const [],
    this.currentTabIndex = 0,
    this.onTabChanged,
    this.onTabClosed,
    this.onNewTab,
    this.onSearch,
    this.onMenuPressed,
    this.onThemeToggle,
    this.elevation = 0,
  }) : super(key: key);

  final String title;
  final bool showTabs;
  final bool showSearch;
  final bool showActions;
  final List<BrowserTabItem> tabs;
  final int currentTabIndex;
  final Function(int)? onTabChanged;
  final Function(int)? onTabClosed;
  final VoidCallback? onNewTab;
  final Function(String)? onSearch;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onThemeToggle;
  final double elevation;

  @override
  State<BrowserAppBar> createState() => _BrowserAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _BrowserAppBarState extends State<BrowserAppBar>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  // 搜索状态
  bool _isSearchMode = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  // 屏幕信息
  bool _isTablet = false;
  double _screenWidth = 0;

  @override
  void initState() {
    super.initState();
    
    // 初始化动画控制器
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
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    // 初始化标签页控制器
    if (widget.showTabs) {
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
      );
      _tabController.addListener(_handleTabChanged);
    }
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BrowserAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.showTabs && 
        (widget.tabs.length != oldWidget.tabs.length ||;
         widget.currentTabIndex != oldWidget.currentTabIndex)) {
      _tabController.dispose();
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
      );
      _tabController.addListener(_handleTabChanged);
      
      // 同步当前标签页
      if (widget.currentTabIndex < widget.tabs.length) {
        _tabController.index = widget.currentTabIndex;
      }
    }
    
    // 更新搜索文本
    if (widget.currentTabIndex < widget.tabs.length) {
      final currentTab = widget.tabs[widget.currentTabIndex];
      if (_searchController.text != currentTab.title) {
        _searchController.text = currentTab.title;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateScreenInfo();
  }

  /// 更新屏幕信息
  void _updateScreenInfo() {
    final size = MediaQuery.of(context).size;
    setState(() {
      _screenWidth = size.width;
      _isTablet = size.width >= 768;
    });
  }

  /// 处理标签页变化
  void _handleTabChanged() {
    if (!_tabController.indexIsChanging) {
      widget.onTabChanged?.call(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: _buildAppBar(),
          ),
        );
      },
    );
  }

  /// 构建应用栏
  Widget _buildAppBar() {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: ExtensionData.getBrowserColor(context, 'toolbar'),
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
        boxShadow: widget.elevation > 0 ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: widget.elevation,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 主应用栏
            _buildMainBar(),
            
            // 标签页栏
            if (widget.showTabs && widget.tabs.isNotEmpty)
              _buildTabBar(),
          ],
        ),
      ),
    );
  }

  /// 构建主应用栏
  Widget _buildMainBar() {
    return SizedBox(
      height: ExtensionData.tabHeight,
      child: Row(
        children: [
          // 左侧：应用图标和标题
          _buildAppInfo(),
          
          // 中间：搜索框（平板端）
          if (_isTablet && widget.showSearch)
            Expanded(
              child: _buildSearchField(),
            ),
          
          // 右侧：操作按钮
          if (widget.showActions)
            _buildActions(),
        ],
      ),
    );
  }

  /// 构建应用信息区域
  Widget _buildAppInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 应用图标
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.language,
              color: Colors.white,
              size: 18,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // 应用标题
          if (!_isTablet)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (widget.tabs.isNotEmpty)
                  Text(
                    '${widget.currentTabIndex + 1}/${widget.tabs.length}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  /// 构建搜索框
  Widget _buildSearchField() {
    return Container(
      height: ExtensionData.browserInputHeight,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: '搜索或输入网址',
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    widget.onSearch?.call('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        textInputAction: TextInputAction.go,
        onSubmitted: (value) {
          widget.onSearch?.call(value);
          _searchFocusNode.unfocus();
        },
        onChanged: (value) {
          setState(() {}); // 触发UI更新以显示/隐藏清除按钮
        },
      ),
    );
  }

  /// 构建操作按钮区域
  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 主题切换按钮
          if (widget.onThemeToggle != null);
            _buildActionButton(
              icon: Icons.brightness_6,
              onPressed: widget.onThemeToggle!,
              tooltip: '切换主题',
            ),
          
          // 菜单按钮
          if (widget.onMenuPressed != null);
            _buildActionButton(
              icon: Icons.more_vert,
              onPressed: widget.onMenuPressed!,
              tooltip: '菜单',
            ),
        ],
      ),
    );
  }

  /// 构建操作按钮
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
            width: 36,
            height: 36,
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建标签页栏
  Widget _buildTabBar() {
    return Container(
      height: ExtensionData.tabHeight,
      decoration: BoxDecoration(
        color: ExtensionData.getBrowserColor(context, 'tab'),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        onTap: (index) {
          // 延迟执行，允许TabController先处理动画
          Future.delayed(const Duration(milliseconds: 50), () {
            widget.onTabChanged?.call(index);
          });
        },
        tabs: widget.tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          
          return Tab(
            height: ExtensionData.tabHeight,
            child: _buildTabItem(tab, index),
          );
        }).toList(),
      ),
    );
  }

  /// 构建标签页项
  Widget _buildTabItem(BrowserTabItem tab, int index) {
    final isSelected = index == widget.currentTabIndex;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isSelected 
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 网站图标
          if (tab.favicon != null);
            Image.network(
              tab.favicon!,
              width: 16,
              height: 16,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.language,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            )
          else
            Icon(
              Icons.language,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          
          const SizedBox(width: 8),
          
          // 网站标题
          Expanded(
            child: Text(
              tab.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: isSelected
                  ? Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  )
                  : Theme.of(context).textTheme.labelMedium,
            ),
          ),
          
          const SizedBox(width: 4),
          
          // 关闭按钮
          if (!tab.pinned)
            _buildTabCloseButton(index),
        ],
      ),
    );
  }

  /// 构建标签页关闭按钮
  Widget _buildTabCloseButton(int index) {
    return Tooltip(
      message: '关闭标签页',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: (e) {
            e.stopPropagation(); // 防止触发标签页切换
            widget.onTabClosed?.call(index);
          },
          child: Container(
            width: 20,
            height: 20,
            child: Icon(
              Icons.close,
              size: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}

/// 浏览器标签页项数据类
class BrowserTabItem {
  const BrowserTabItem({
    required this.id,
    required this.title,
    this.url,
    this.favicon,
    this.pinned = false,
    this.isLoading = false,
  });

  final String id;
  final String title;
  final String? url;
  final String? favicon;
  final bool pinned;
  final bool isLoading;

  /// 创建副本
  BrowserTabItem copyWith({
    String? id,
    String? title,
    String? url,
    String? favicon,
    bool? pinned,
    bool? isLoading,
  }) {
    return BrowserTabItem(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      favicon: favicon ?? this.favicon,
      pinned: pinned ?? this.pinned,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}