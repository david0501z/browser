import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/browser_models.dart';

/// 浏览器标签页组件
/// 支持多标签页管理、导航控制、书签和历史记录
class BrowserTabWidget extends ConsumerStatefulWidget {
  final BrowserTab tab;
  final VoidCallback? onClose;
  final Function(String)? onTitleChanged;
  final Function(String)? onUrlChanged;

  const BrowserTabWidget({
    super.key,
    required this.tab,
    this.onClose,
    this.onTitleChanged,
    this.onUrlChanged,
  });

  @override
  ConsumerState<BrowserTabWidget> createState() => _BrowserTabWidgetState();
}

class _BrowserTabWidgetState extends ConsumerState<BrowserTabWidget> {
  late InAppWebViewController _webViewController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  bool _isLoading = false;
  double _progress = 0.0;
  bool _canGoBack = false;
  bool _canGoForward = false;
  String _currentUrl = '';
  String _currentTitle = '';

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.tab.url;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// 处理搜索提交
  void _handleSearchSubmitted(String value) {
    String url = value.trim();
    if (url.isEmpty) return;

    // 如果不是有效URL，尝试作为搜索词处理
    if (!_isValidUrl(url)) {
      url = 'https://www.google.com/search?q=${Uri.encodeComponent(url)}';
    }

    _webViewController.loadUrl(
      urlRequest: URLRequest(url: Uri.parse(url)),
    );
    _searchFocusNode.unfocus();
  }

  /// 验证URL格式
  bool _isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 刷新页面
  void _refresh() {
    _webViewController.reload();
  }

  /// 前进
  void _goForward() {
    _webViewController.goForward();
  }

  /// 后退
  void _goBack() {
    _webViewController.goBack();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 工具栏
        _buildToolbar(),
        // WebView内容区
        Expanded(
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse(widget.tab.url),
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
                _currentUrl = url.toString();
              });
              _searchController.text = _currentUrl;
              widget.onUrlChanged?.call(_currentUrl);
            },
            onLoadStop: (controller, url) async {
              setState(() {
                _isLoading = false;
                _currentUrl = url.toString();
              });
              
              // 获取页面标题
              String? title = await controller.getTitle();
              if (title != null && title.isNotEmpty) {
                setState(() {
                  _currentTitle = title;
                });
                widget.onTitleChanged?.call(title);
              }

              // 检查导航状态
              _canGoBack = await controller.canGoBack();
              _canGoForward = await controller.canGoForward();
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                _progress = progress / 100.0;
              });
            },
            onTitleChanged: (controller, title) {
              if (title != null && title.isNotEmpty) {
                setState(() {
                  _currentTitle = title;
                });
                widget.onTitleChanged?.call(title);
              }
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final uri = navigationAction.request.url!;
              
              // 处理特殊协议
              if (uri.scheme == 'http' || uri.scheme == 'https') {
                return NavigationActionPolicy.ALLOW;
              }
              
              // 阻止其他协议的跳转
              return NavigationActionPolicy.CANCEL;
            },
            onCreateWindow: (controller, createWindowRequest) {
              // 处理新窗口请求（如新标签页、弹窗等）
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('新窗口'),
                  content: const Text('是否在新标签页中打开？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // TODO: 实现新标签页逻辑
                      },
                      child: const Text('打开'),
                    ),
                  ],
                ),
              );
              return true;
            },
            onConsoleMessage: (controller, consoleMessage) {
              // 处理控制台消息（调试用）
              debugPrint('浏览器控制台: ${consoleMessage.message}');
            },
          ),
        ),
        // 加载进度条
        if (_isLoading)
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
      ],
    );
  }

  /// 构建工具栏
  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 导航按钮
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: _canGoBack 
                    ? Theme.of(context).iconTheme.color 
                    : Colors.grey,
              ),
              onPressed: _canGoBack ? _goBack : null,
              tooltip: '后退',
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward,
                color: _canGoForward 
                    ? Theme.of(context).iconTheme.color 
                    : Colors.grey,
              ),
              onPressed: _canGoForward ? _goForward : null,
              tooltip: '前进',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refresh,
              tooltip: '刷新',
            ),
            const SizedBox(width: 16),
            // 搜索栏
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: '搜索或输入网址',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onSubmitted: _handleSearchSubmitted,
                textInputAction: TextInputAction.go,
              ),
            ),
            const SizedBox(width: 16),
            // 更多选项菜单
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'bookmarks':
                    _showBookmarks();
                    break;
                  case 'history':
                    _showHistory();
                    break;
                  case 'settings':
                    _showSettings();
                    break;
                  case 'share':
                    _shareCurrentPage();
                    break;
                  case 'find':
                    _showFindDialog();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'bookmarks',
                  child: ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text('书签'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'history',
                  child: ListTile(
                    leading: Icon(Icons.history),
                    title: Text('历史记录'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'find',
                  child: ListTile(
                    leading: Icon(Icons.search),
                    title: Text('查找'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text('分享'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'settings',
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('浏览器设置'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 显示书签
  void _showBookmarks() {
    // TODO: 实现书签列表
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('书签功能开发中')),
    );
  }

  /// 显示历史记录
  void _showHistory() {
    // TODO: 实现历史记录列表
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('历史记录功能开发中')),
    );
  }

  /// 显示设置
  void _showSettings() {
    // TODO: 跳转到浏览器设置页面
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('设置功能开发中')),
    );
  }

  /// 分享当前页面
  void _shareCurrentPage() {
    if (_currentUrl.isNotEmpty) {
      // TODO: 实现分享功能
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('分享: $_currentTitle')),
      );
    }
  }

  /// 显示查找对话框
  void _showFindDialog() {
    showDialog(
      context: context,
      builder: (context) => FindDialog(
        controller: _webViewController,
      ),
    );
  }
}

/// 查找对话框组件
class FindDialog extends StatefulWidget {
  final InAppWebViewController controller;

  const FindDialog({
    super.key,
    required this.controller,
  });

  @override
  State<FindDialog> createState() => _FindDialogState();
}

class _FindDialogState extends State<FindDialog> {
  final TextEditingController _findController = TextEditingController();
  int _currentMatch = 0;
  int _totalMatches = 0;

  @override
  void initState() {
    super.initState();
    _findController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _findController.removeListener(_onTextChanged);
    _findController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _findInPage(_findController.text);
  }

  void _findInPage(String searchText) async {
    if (searchText.isEmpty) {
      setState(() {
        _currentMatch = 0;
        _totalMatches = 0;
      });
      return;
    }

    try {
      await widget.controller.findAll(
        find: searchText,
      );
      
      // 获取匹配数量
      // 注意：这里需要根据实际API调整
      setState(() {
        _totalMatches = 1; // 临时值
        _currentMatch = 1;
      });
    } catch (e) {
      debugPrint('查找出错: $e');
    }
  }

  void _findNext() {
    widget.controller.findNext(forward: true);
  }

  void _findPrevious() {
    widget.controller.findNext(forward: false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('查找'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _findController,
            decoration: const InputDecoration(
              hintText: '输入要查找的内容',
              prefixIcon: Icon(Icons.search),
            ),
            autofocus: true,
          ),
          if (_totalMatches > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '第 $_currentMatch 项，共 $_totalMatches 项',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        if (_totalMatches > 0) ...[
          IconButton(
            onPressed: _findPrevious,
            icon: const Icon(Icons.arrow_upward),
            tooltip: '上一个',
          ),
          IconButton(
            onPressed: _findNext,
            icon: const Icon(Icons.arrow_downward),
            tooltip: '下一个',
          ),
        ],
      ],
    );
  }
}