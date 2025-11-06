import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tab_manager.dart';

/// 自定义标签页栏组件
class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<TabData> tabs;
  final int currentIndex;
  final Function(int) onTabTap;
  final Function(int) onTabClose;
  final VoidCallback onNewTab;
  final VoidCallback onTogglePreview;
  final bool isPreviewMode;

  const CustomTabBar({
    Key? key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabTap,
    required this.onTabClose,
    required this.onNewTab,
    required this.onTogglePreview,
    this.isPreviewMode = false,
  }) : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  int? _hoveredTabIndex;
  int? _longPressedTabIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 标签页列表
          Expanded(
            child: widget.tabs.isEmpty
                ? _buildEmptyTabBar()
                : _buildTabList(),
          ),
          // 操作按钮
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildEmptyTabBar() {
    return Center(
      child: Text(
        '暂无标签页',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTabList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: widget.tabs.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_slideAnimation.value, 0),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: _buildTabItem(index),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTabItem(int index) {
    final tab = widget.tabs[index];
    final isActive = index == widget.currentIndex;
    final isHovered = index == _hoveredTabIndex;
    final isLongPressed = index == _longPressedTabIndex;

    return GestureDetector(
      onTap: () => widget.onTabTap(index),
      onLongPress: () => _showTabContextMenu(context, index),
      onSecondaryTap: () => _showTabContextMenu(context, index),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredTabIndex = index),
        onExit: (_) => setState(() => _hoveredTabIndex = null),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white
                : isHovered
                    ? Colors.grey[200]
                    : Colors.transparent,
            border: isActive
                ? Border(
                    bottom: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  )
                : null,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Favicon
              _buildFavicon(tab),
              const SizedBox(width: 8),
              // 标题
              Flexible(
                child: Text(
                  tab.title.isEmpty ? '新标签页' : tab.title,
                  style: TextStyle(
                    fontSize: 13,
                    color: isActive ? Colors.black : Colors.grey[700],
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              // 加载指示器
              if (tab.isLoading)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isActive ? Theme.of(context).primaryColor : Colors.grey[600]!,
                      ),
                    ),
                  ),
                ),
              // 关闭按钮
              GestureDetector(
                onTap: (e) {
                  e.stopPropagation();
                  widget.onTabClose(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isHovered ? Colors.grey[300] : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: isHovered ? Colors.grey[700] : Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavicon(TabData tab) {
    if (tab.faviconUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Image.network(
          tab.faviconUrl!,
          width: 16,
          height: 16,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultFavicon();
          },
        ),
      );
    }
    return _buildDefaultFavicon();
  }

  Widget _buildDefaultFavicon() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(2),
      ),
      child: Icon(
        Icons.language,
        size: 10,
        color: Colors.white,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 新建标签页按钮
          IconButton(
            onPressed: widget.onNewTab,
            icon: const Icon(Icons.add, size: 20),
            tooltip: '新建标签页 (Ctrl+T)',
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
          // 预览模式切换按钮
          IconButton(
            onPressed: widget.onTogglePreview,
            icon: Icon(
              widget.isPreviewMode ? Icons.grid_view : Icons.view_module,
              size: 20,
            ),
            tooltip: widget.isPreviewMode ? '退出预览模式' : '预览模式',
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
          // 更多操作菜单
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => [;
              const PopupMenuItem(
                value: 'close_all',
                child: Text('关闭所有标签页'),
              ),
              const PopupMenuItem(
                value: 'close_others',
                child: Text('关闭其他标签页'),
              ),
              const PopupMenuItem(
                value: 'reopen_closed',
                child: Text('重新打开关闭的标签页'),
              ),
              const PopupMenuItem(
                value: 'bookmarks',
                child: Text('书签'),
              ),
              const PopupMenuItem(
                value: 'history',
                child: Text('历史记录'),
              ),
            ],
            icon: const Icon(Icons.more_vert, size: 20),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ],
      ),
    );
  }

  void _showTabContextMenu(BuildContext context, int index) {
    setState(() => _longPressedTabIndex = index);
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('关闭标签页'),
              onTap: () {
                Navigator.pop(context);
                widget.onTabClose(index);
                setState(() => _longPressedTabIndex = null);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close_all),
              title: const Text('关闭其他标签页'),
              onTap: () {
                Navigator.pop(context);
                // 这里应该调用关闭其他标签页的逻辑
                setState(() => _longPressedTabIndex = null);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_add),
              title: const Text('添加书签'),
              onTap: () {
                Navigator.pop(context);
                // 这里应该调用添加书签的逻辑
                setState(() => _longPressedTabIndex = null);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('复制链接'),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: widget.tabs[index].url));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('链接已复制到剪贴板')),
                );
                setState(() => _longPressedTabIndex = null);
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text('在新窗口打开'),
              onTap: () {
                Navigator.pop(context);
                // 这里应该调用在新窗口打开的逻辑
                setState(() => _longPressedTabIndex = null);
              },
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      setState(() => _longPressedTabIndex = null);
    });
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'close_all':
        // 关闭所有标签页
        for (int i = widget.tabs.length - 1; i >= 0; i--) {
          widget.onTabClose(i);
        }
        break;
      case 'close_others':
        // 关闭其他标签页，保留当前标签页
        final currentIndex = widget.currentIndex;
        final currentTab = widget.tabs[currentIndex];
        for (int i = widget.tabs.length - 1; i >= 0; i--) {
          if (i != currentIndex) {
            widget.onTabClose(i);
          }
        }
        break;
      case 'reopen_closed':
        // 重新打开关闭的标签页
        _showReopenClosedTabsDialog();
        break;
      case 'bookmarks':
        // 显示书签
        _showBookmarksDialog();
        break;
      case 'history':
        // 显示历史记录
        _showHistoryDialog();
        break;
    }
  }

  void _showReopenClosedTabsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重新打开关闭的标签页'),
        content: const Text('此功能需要实现标签页历史记录管理'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showBookmarksDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('书签'),
        content: const Text('此功能需要实现书签管理系统'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('历史记录'),
        content: const Text('此功能需要实现浏览历史记录管理'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

/// 标签页拖拽排序组件
class TabDragWidget extends StatefulWidget {
  final List<TabData> tabs;
  final int currentIndex;
  final Function(int from, int to) onReorder;
  final Function(int) onTabTap;
  final Function(int) onTabClose;

  const TabDragWidget({
    Key? key,
    required this.tabs,
    required this.currentIndex,
    required this.onReorder,
    required this.onTabTap,
    required this.onTabClose,
  }) : super(key: key);

  @override
  State<TabDragWidget> createState() => _TabDragWidgetState();
}

class _TabDragWidgetState extends State<TabDragWidget> {
  int? _draggingIndex;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: widget.tabs.length,
      itemBuilder: (context, index) {
        return _buildDraggableTab(index);
      },
      onReorder: widget.onReorder,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.05,
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }

  Widget _buildDraggableTab(int index) {
    final tab = widget.tabs[index];
    final isActive = index == widget.currentIndex;
    final isDragging = index == _draggingIndex;

    return ReorderableDragStartListener(
      index: index,
      child: GestureDetector(
        onTap: () => widget.onTabTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white
                : Colors.grey[100],
            border: isActive
                ? Border(
                    bottom: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  )
                : null,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Favicon
              _buildFavicon(tab),
              const SizedBox(width: 8),
              // 标题
              Flexible(
                child: Text(
                  tab.title.isEmpty ? '新标签页' : tab.title,
                  style: TextStyle(
                    fontSize: 13,
                    color: isActive ? Colors.black : Colors.grey[700],
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              // 关闭按钮
              GestureDetector(
                onTap: (e) {
                  e.stopPropagation();
                  widget.onTabClose(index);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavicon(TabData tab) {
    if (tab.faviconUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Image.network(
          tab.faviconUrl!,
          width: 16,
          height: 16,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultFavicon();
          },
        ),
      );
    }
    return _buildDefaultFavicon();
  }

  Widget _buildDefaultFavicon() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(2),
      ),
      child: Icon(
        Icons.language,
        size: 10,
        color: Colors.white,
      ),
    );
  }
}