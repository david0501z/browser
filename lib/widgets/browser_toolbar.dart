import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 浏览器工具栏组件
/// 
/// 实现浏览器工具栏功能：
/// - 地址栏和搜索功能
/// - 前进、后退、刷新按钮
/// - 菜单按钮
/// - 新标签页按钮
class BrowserToolbar extends StatefulWidget {
  const BrowserToolbar({
    Key? key,
    this.currentTab,
    required this.onSearch,
    required this.onRefresh,
    required this.onGoBack,
    required this.onGoForward,
    required this.onNewTab,
  }) : super(key: key);

  final BrowserTab? currentTab;
  final Function(String) onSearch;
  final VoidCallback onRefresh;
  final VoidCallback onGoBack;
  final VoidCallback onGoForward;
  final VoidCallback onNewTab;

  @override
  State<BrowserToolbar> createState() => _BrowserToolbarState();
}

class _BrowserToolbarState extends State<BrowserToolbar> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  
  // 按钮状态
  bool _canGoBack = false;
  bool _canGoForward = false;
  bool _isLoading = false;
  
  // 搜索建议
  final List<String> _searchSuggestions = [
                'https://www.google.com',
    'https://www.baidu.com',
    'https://github.com',
    'https://stackoverflow.com',
    'https://www.youtube.com',
    'https://twitter.com',
    'https://www.reddit.com',
    'https://www.wikipedia.org',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSearchController();
  }

  @override
  void didUpdateWidget(BrowserToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSearchController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// 更新搜索控制器内容
  void _updateSearchController() {
    if (widget.currentTab != null &&
        _searchController.text != widget.currentTab!.url) {
      _searchController.text = widget.currentTab!.url;
    }
  }

  /// 处理搜索提交
  void _handleSearchSubmitted(String value) {
    if (value.trim().isEmpty) return;
    
    widget.onSearch(value.trim());
    _searchFocusNode.unfocus();
  }

  /// 处理搜索框变化
  void _handleSearchChanged(String value) {
    // 可以在这里实现搜索建议功能
  }

  /// 复制当前URL
  void _copyCurrentUrl() async {
    if (widget.currentTab?.url != null) {
      await Clipboard.setData(ClipboardData(text: widget.currentTab!.url!));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('URL已复制到剪贴板'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// 分享当前页面
  void _shareCurrentPage() async {
    if (widget.currentTab?.url != null) {
      // TODO: 实现分享功能
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('分享功能即将推出'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// 切换到桌面版网站
  void _toggleDesktopSite() async {
    // TODO: 实现桌面版网站切换
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('桌面版网站切换功能即将推出'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// 清除搜索框
  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          // 主要工具栏
          Row(
            children: [
              // 后退按钮
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: _canGoBack 
                      ? Theme.of(context).iconTheme.color 
                      : Colors.grey.shade400,
                ),
                onPressed: _canGoBack ? widget.onGoBack : null,
                tooltip: '后退',
              ),
              
              // 前进按钮
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: _canGoForward 
                      ? Theme.of(context).iconTheme.color 
                      : Colors.grey.shade400,
                ),
                onPressed: _canGoForward ? widget.onGoForward : null,
                tooltip: '前进',
              ),
              
              // 刷新按钮
              IconButton(
                icon: Icon(
                  _isLoading ? Icons.close : Icons.refresh,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: widget.onRefresh,
                tooltip: _isLoading ? '停止' : '刷新',
              ),
              
              // 地址栏/搜索框
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: _handleSearchChanged,
                    onSubmitted: _handleSearchSubmitted,
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
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey.shade500,
                                size: 20,
                              ),
                              onPressed: _clearSearch,
                              tooltip: '清除',
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    textInputAction: TextInputAction.go,
                  ),
                ),
              ),
              
              // 新标签页按钮
              IconButton(
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: widget.onNewTab,
                tooltip: '新标签页',
              ),
              
              // 菜单按钮
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).iconTheme.color,
                ),
                tooltip: '更多选项',
                onSelected: (value) {
                  switch (value) {
                    case 'copy_url':
                      _copyCurrentUrl();
                      break;
                    case 'share':
                      _shareCurrentPage();
                      break;
                    case 'desktop_site':
                      _toggleDesktopSite();
                      break;
                    case 'find':
                      _showFindDialog();
                      break;
                    case 'settings':
                      _showSettingsDialog();
                      break;
                  }
                },
                itemBuilder: (context) => [
                PopupMenuItem(
                    value: 'copy_url',
                    child: Row(
                      children: [
                        const Icon(Icons.copy),
                        const SizedBox(width: 12),
                        const Text('复制链接'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        const Icon(Icons.share),
                        const SizedBox(width: 12),
                        const Text('分享'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'desktop_site',
                    child: Row(
                      children: [
                        const Icon(Icons.desktop_mac),
                        const SizedBox(width: 12),
                        const Text('桌面版网站'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'find',
                    child: Row(
                      children: [
                        const Icon(Icons.search),
                        const SizedBox(width: 12),
                        const Text('查找页面内容'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        const Icon(Icons.settings),
                        const SizedBox(width: 12),
                        const Text('浏览器设置'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // 搜索建议栏（可选）
          if (_searchFocusNode.hasFocus && _searchController.text.isEmpty)
            Container(
              height: 120,
              margin: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                itemCount: _searchSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _searchSuggestions[index];
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.history,
                      color: Colors.grey.shade500,
                      size: 16,
                    ),
                    title: Text(
                      suggestion,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    onTap: () {
                      _handleSearchSubmitted(suggestion);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// 显示查找对话框
  void _showFindDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('查找页面内容'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: '输入要查找的内容',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            // TODO: 在WebView中执行查找
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              // TODO: 执行查找
              Navigator.pop(context);
            },
            child: const Text('查找'),
          ),
        ],
      ),
    );
  }

  /// 显示设置对话框
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('浏览器设置'),
        content: const Text('设置功能即将推出'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 更新按钮状态
  void updateButtonStates({
    bool? canGoBack,
    bool? canGoForward,
    bool? isLoading,
  }) {
    setState(() {
      if (canGoBack != null) _canGoBack = canGoBack;
      if (canGoForward != null) _canGoForward = canGoForward;
      if (isLoading != null) _isLoading = isLoading;
    });
  }
}