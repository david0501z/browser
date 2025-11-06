import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 浏览器页面主组件
/// 
/// 实现浏览器的主要功能：
/// - 多标签页管理
/// - 地址栏和搜索功能
/// - 前进、后退、刷新功能
/// - 进度指示器
/// - 错误处理和加载状态管理
class BrowserPage extends ConsumerStatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  ConsumerState<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends ConsumerState<BrowserPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  
  // 当前选中的标签页索引
  int _currentIndex = 0;
  
  // 标签页列表
  final List<BrowserTab> _tabs = [];

  @override
  void initState() {
    super.initState();
    
    // 初始化标签页控制器
    _tabController = TabController(length: 0, vsync: this);
    _pageController = PageController();
    
    // 添加默认标签页
    _addNewTab();
    
    // 监听标签页变化
    _tabController.addListener(() {
      if (_tabController.index != _currentIndex) {
        setState(() {
          _currentIndex = _tabController.index;
        });
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  /// 添加新标签页
  void _addNewTab({String? url}) {
    final newTab = BrowserTab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: url ?? 'https://www.google.com',
      title: '新标签页',
      favicon: null,
      pinned: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    setState(() {
      _tabs.add(newTab);
      _tabController = TabController(
        length: _tabs.length,
        vsync: this,
      );
      _currentIndex = _tabs.length - 1;
    });
    
    // 同步页面控制器
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// 关闭标签页
  void _closeTab(int index) {
    if (_tabs.length <= 1) {
      // 至少保留一个标签页
      return;
    }
    
    setState(() {
      _tabs.removeAt(index);
      _tabController = TabController(
        length: _tabs.length,
        vsync: this,
      );
      
      // 调整当前索引
      if (_currentIndex >= _tabs.length) {
        _currentIndex = _tabs.length - 1;
      }
    });
    
    // 同步页面控制器
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// 切换标签页
  void _switchToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
    _tabController.animateTo(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// 处理地址栏搜索
  void _handleSearch(String query) {
    if (query.isEmpty) return;
    
    String url;
    if (query.startsWith('http://') || query.startsWith('https://')) {
      url = query;
    } else if (query.contains('.') && !query.contains(' ')) {
      url = 'https://$query';
    } else {
      url = 'https://www.google.com/search?q=${Uri.encodeComponent(query)}';
    }
    
    _updateCurrentTabUrl(url);
  }

  /// 更新当前标签页URL
  void _updateCurrentTabUrl(String url) {
    if (_currentIndex >= 0 && _currentIndex < _tabs.length) {
      setState(() {
        _tabs[_currentIndex] = _tabs[_currentIndex].copyWith(
          url: url,
          updatedAt: DateTime.now(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlClash 浏览器'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 2,
          tabs: _tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            return Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tab.favicon != null);
                    Image.network(
                      tab.favicon!,
                      width: 16,
                      height: 16,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.language,
                        size: 16,
                      ),
                    )
                  else
                    const Icon(Icons.language, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tab.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () => _closeTab(index),
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addNewTab(),
            tooltip: '新建标签页',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // 显示更多选项菜单
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildMoreOptionsMenu(),
              );
            },
            tooltip: '更多选项',
          ),
        ],
      ),
      body: Column(
        children: [
          // 浏览器工具栏
          BrowserToolbar(
            currentTab: _tabs.isNotEmpty ? _tabs[_currentIndex] : null,
            onSearch: _handleSearch,
            onRefresh: () {
              // 触发当前标签页刷新
              _refreshCurrentTab();
            },
            onGoBack: () {
              // 触发当前标签页后退
              _goBackCurrentTab();
            },
            onGoForward: () {
              // 触发当前标签页前进
              _goForwardCurrentTab();
            },
            onNewTab: () => _addNewTab(),
          ),
          // WebView内容区
          Expanded(
            child: _tabs.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                      _tabController.animateTo(index);
                    },
                    itemCount: _tabs.length,
                    itemBuilder: (context, index) {
                      return BrowserWebView(
                        tab: _tabs[index],
                        onTabUpdate: (updatedTab) {
                          setState(() {
                            _tabs[index] = updatedTab;
                          });
                        },
                        onNewTab: (url) => _addNewTab(url: url),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// 构建更多选项菜单
  Widget _buildMoreOptionsMenu() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: const Text('书签'),
            onTap: () {
              Navigator.pop(context);
              // TODO: 打开书签页面
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('历史记录'),
            onTap: () {
              Navigator.pop(context);
              // TODO: 打开历史记录页面
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('下载'),
            onTap: () {
              Navigator.pop(context);
              // TODO: 打开下载页面
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('浏览器设置'),
            onTap: () {
              Navigator.pop(context);
              // TODO: 打开浏览器设置页面
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('隐私与安全'),
            onTap: () {
              Navigator.pop(context);
              // TODO: 打开隐私与安全页面
            },
          ),
        ],
      ),
    );
  }

  /// 刷新当前标签页
  void _refreshCurrentTab() {
    // 通过GlobalKey刷新WebView
    // 这里需要从BrowserWebView组件获取刷新方法
  }

  /// 当前标签页后退
  void _goBackCurrentTab() {
    // 通过GlobalKey执行后退操作
  }

  /// 当前标签页前进
  void _goForwardCurrentTab() {
    // 通过GlobalKey执行前进操作
  }
}