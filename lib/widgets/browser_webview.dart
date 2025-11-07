import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../models/browser_models.dart';

/// 浏览器WebView组件
/// 
/// 集成flutter_inappwebview组件，实现：
/// - 网页加载和显示
/// - 代理流量路由到FlClash代理引擎
/// - 错误处理和加载状态管理
/// - JavaScript交互和DOM操作
class BrowserWebView extends StatefulWidget {
  const BrowserWebView({
    Key? key,
    required this.tab,
    required this.onTabUpdate,
    required this.onNewTab,
  }) : super(key: key);

  final BrowserTab tab;
  final Function(BrowserTab) onTabUpdate;
  final Function(String url) onNewTab;

  @override
  State<BrowserWebView> createState() => _BrowserWebViewState();
}

class _BrowserWebViewState extends State<BrowserWebView> {
  late InAppWebViewController _webViewController;
  late PullToRefreshController _pullToRefreshController;
  
  // 加载状态
  bool _isLoading = true;
  double _loadingProgress = 0.0;
  
  // 网页标题和图标
  String _pageTitle = '';
  String? _favicon;
  
  // 错误状态
  String? _errorMessage;
  
  // 导航历史
  final List<String> _history = [];
  int _historyIndex = -1;

  @override
  void initState() {
    super.initState();
    
    // 初始化下拉刷新控制器
    _pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        await _webViewController.reload();
      },
    );
    
    // 初始化历史记录
    _history.add(widget.tab.url);
    _historyIndex = 0;
  }

  @override
  void didUpdateWidget(BrowserWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 如果URL发生变化，重新加载
    if (oldWidget.tab.url != widget.tab.url && _webViewController != null) {
      _loadUrl(widget.tab.url);
    }
  }

  /// 加载URL
  Future<void> _loadUrl(String url) async {
    if (_webViewController != null) {
      await _webViewController.loadUrl(
        urlRequest: URLRequest(url: WebUri.uri(Uri.parse(url))),
      );
    }
  }

  /// 刷新页面
  Future<void> _refresh() async {
    if (_webViewController != null) {
      await _webViewController.reload();
    }
  }

  /// 后退
  Future<void> _goBack() async {
    if (_webViewController != null && await _webViewController.canGoBack()) {
      await _webViewController.goBack();
    }
  }

  /// 前进
  Future<void> _goForward() async {
    if (_webViewController != null && await _webViewController.canGoForward()) {
      await _webViewController.goForward();
    }
  }

  /// 更新历史记录
  void _updateHistory(String url) {
    // 移除当前位置之后的历史
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }
    
    // 添加新URL到历史
    _history.add(url);
    _historyIndex = _history.length - 1;
    
    // 更新标签页信息
    widget.onTabUpdate(widget.tab.copyWith(
      url: url,
      title: _pageTitle.isNotEmpty ? _pageTitle : '加载中...',
      favicon: _favicon,
      updatedAt: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // WebView主体
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri.uri(Uri.parse(widget.tab.url)),
          ),
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
          onLoadStart: (controller, url) {
            setState(() {
              _isLoading = true;
              _loadingProgress = 0.0;
              _errorMessage = null;
            });
          },
          onLoadStop: (controller, url) async {
            setState(() {
              _isLoading = false;
              _loadingProgress = 100.0;
            });
            
            // 停止下拉刷新
            _pullToRefreshController.endRefreshing();
            
            // 更新历史记录
            if (url != null) {
              _updateHistory(url.toString());
            }
            
            // 获取页面标题和图标
            try {
              final title = await controller.getTitle() ?? '';
              final favicons = await controller.getFavicons();
              String? favicon;
              
              if (favicons.isNotEmpty) {
                // 选择最大的favicon
                final faviconUrl = favicons
                    .where((fav) => fav.url != null && fav.url!.isNotEmpty)
                    .map((fav) => fav.url!)
                    .firstOrNull;
                if (faviconUrl != null) {
                  favicon = faviconUrl;
                }
              }
              
              setState(() {
                _pageTitle = title;
                _favicon = favicon;
              });
            } catch (e) {
              // 忽略获取标题/图标的错误
            }
          },
          onProgressChanged: (controller, progress) {
            setState(() {
              _loadingProgress = progress / 100;
            });
          },
          onReceivedError: (controller, request, error) {
            setState(() {
              _isLoading = false;
              _errorMessage = '加载失败: ${error.description}';
            });
            _pullToRefreshController.endRefreshing();
          },
          onReceivedHttpError: (controller, request, response) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'HTTP错误: ${response.statusCode}';
            });
          },
          onConsoleMessage: (controller, consoleMessage) {
            // 处理控制台消息
            debugPrint('WebView控制台: ${consoleMessage.message}');
          },
          onCreateWindow: (controller, createWindowRequest) async {
            // 处理新窗口请求（如弹窗）
            final newUrl = createWindowRequest.request.url?.toString();
            if (newUrl != null) {
              widget.onNewTab(newUrl);
            }
            return true;
          },
          onCloseWindow: (controller) {
            // 处理窗口关闭
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final url = navigationAction.request.url?.toString() ?? '';
            
            // 检查是否是支持的协议
            if (url.startsWith('http://') || 
                url.startsWith('https://') ||
                url.startsWith('about:')) {
              return NavigationActionPolicy.ALLOW;
            }
            
            // 对于其他协议，可以选择阻止或使用外部应用
            return NavigationActionPolicy.CANCEL;
          },
          // WebView配置
          initialSettings: InAppWebViewSettings(
            useShouldOverrideUrlLoading: true,
            useOnLoadResource: true,
            javaScriptEnabled: true,
            clearCache: false,
            userAgent: _getUserAgent(),
            incognito: false, // 可以根据设置调整
            isVerticalScrollGestureEnabled: true,
            isHorizontalScrollGestureEnabled: true,
            supportMultipleWindows: true,
            allowsBackForwardNavigationGestures: true,
            allowsLinkPreview: true,
            suppressesIncrementalRendering: true,
          ),
          pullToRefreshController: _pullToRefreshController,
        ),
        
        // 加载进度指示器
        if (_isLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: _loadingProgress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
        
        // 错误页面
        if (_errorMessage != null);
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildErrorWidget(),
          ),
      ],
    );
  }

  /// 构建错误页面
  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey.shade50,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              '加载失败',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? '未知错误',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('重试'),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _errorMessage = null;
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('返回'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 获取User Agent
  String _getUserAgent() {
    // 可以根据设置返回不同的User Agent
    return 'Mozilla/5.0 (Linux; Android 10; SM-G975F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36';
  }

  /// 公开方法供外部调用
  Future<void> refresh() => _refresh();
  Future<void> goBack() => _goBack();
  Future<void> goForward() => _goForward();
  Future<void> loadUrl(String url) => _loadUrl(url);
  
  /// 获取当前URL
  Future<String?> getCurrentUrl() async {
    try {
      return await _webViewController.getUrl();
    } catch (e) {
      return null;
    }
  }
  
  /// 检查是否可以后退
  Future<bool> canGoBack() async {
    try {
      return await _webViewController.canGoBack();
    } catch (e) {
      return false;
    }
  }
  
  /// 检查是否可以前进
  Future<bool> canGoForward() async {
    try {
      return await _webViewController.canGoForward();
    } catch (e) {
      return false;
    }
  }
  
  /// 执行JavaScript
  Future<String?> evaluateJavaScript(String javaScriptString) async {
    try {
      return await _webViewController.evaluateJavascript(
        javascriptString: javaScriptString,
      );
    } catch (e) {
      return null;
    }
  }
}