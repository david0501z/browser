import 'package:flutter/material.dart';

/// WebView代理集成示例
/// 
/// 演示如何在实际应用中集成和使用WebView代理功能：
/// 1. 应用启动时初始化代理服务
/// 2. 在浏览器页面中集成代理功能
/// 3. 提供代理配置界面
/// 4. 动态代理切换
/// 
/// 运行此示例前请确保：
/// - 已安装flutter_inappwebview依赖
/// - 已在pubspec.yaml中配置相应权限
class WebViewProxyIntegrationExample extends StatefulWidget {
  const WebViewProxyIntegrationExample({Key? key}) : super(key: key);

  @override
  State<WebViewProxyIntegrationExample> createState() => _WebViewProxyIntegrationExampleState();
}

class _WebViewProxyIntegrationExampleState extends State<WebViewProxyIntegrationExample> {
  late WebViewManager _webViewManager;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  /// 初始化服务
  Future<void> _initializeServices() async {
    try {
      // 初始化代理服务
      await WebViewProxyService.instance.initialize();
      
      // 设置默认代理配置（可选）
      final defaultConfig = ProxyConfig(
        enabled: false, // 默认禁用代理
        type: ProxyType.http,
        name: '示例配置',
      );
      
      await WebViewProxyService.instance.applyProxyConfig(defaultConfig);
      
      setState(() {
        _webViewManager = WebViewManager.instance;
        _initialized = true;
      });
      
      debugPrint('WebView代理服务初始化完成');
    } catch (e) {
      debugPrint('初始化失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('初始化失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('正在初始化代理服务...'),
            ],
          ),
        ),
      );
    }

    return WebViewManagerProvider(
      notifier: _webViewManager,
      child: MaterialApp(
        title: 'WebView代理集成示例',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const MainBrowserPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// 主浏览器页面
class MainBrowserPage extends StatefulWidget {
  const MainBrowserPage({Key? key}) : super(key: key);

  @override
  State<MainBrowserPage> createState() => _MainBrowserPageState();
}

class _MainBrowserPageState extends State<MainBrowserPage> {
  final List<BrowserTab> _tabs = [];
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // 创建初始标签页
    _addNewTab('https://www.google.com');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView代理浏览器'),
        actions: [
          _buildProxyStatusIndicator(),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openProxySettings,
            tooltip: '代理设置',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addNewTab('https://www.google.com'),
            tooltip: '新建标签页',
          ),
        ],
        bottom: _buildTabBar(),
      ),
      body: _tabs.isEmpty
          ? const Center(child: Text('没有打开的标签页'))
          : _buildTabContent(),
      floatingActionButton: _tabs.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _refreshCurrentTab(),
              child: const Icon(Icons.refresh),
            )
          : null,
    );
  }

  /// 构建代理状态指示器
  Widget _buildProxyStatusIndicator() {
    return StreamBuilder<ProxyStats>(
      stream: _getProxyStatsStream(),
      builder: (context, snapshot) {
        final stats = snapshot.data;
        if (stats == null) return const SizedBox.shrink();

        return Icon(
          stats.isEnabled ? Icons.security : Icons.security_outlined,
          color: stats.isEnabled ? Colors.green : Colors.grey,
          tooltip: '代理状态: ${stats.isEnabled ? '已启用' : '已禁用'}',
        );
      },
    );
  }

  /// 获取代理统计信息流
  Stream<ProxyStats> _getProxyStatsStream() async* {
    while (true) {
      yield WebViewProxyService.instance.getProxyStats();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  /// 构建标签栏
  PreferredSizeWidget _buildTabBar() {
    if (_tabs.isEmpty) return const PreferredSize(child: SizedBox.shrink(), preferredSize: Size.zero);

    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        height: 48,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _tabs.length,
          itemBuilder: (context, index) {
            final tab = _tabs[index];
            final isSelected = index == _currentTabIndex;
            
            return GestureDetector(
              onTap: () => setState(() => _currentTabIndex = index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected ? null : Border.all(color: Colors.grey),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab.favicon != null ? Icons.language : Icons.language,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getTabTitle(tab),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _closeTab(index),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: isSelected ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 构建标签内容
  Widget _buildTabContent() {
    if (_tabs.isEmpty) return const SizedBox.shrink();

    final currentTab = _tabs[_currentTabIndex];
    final webViewManager = WebViewManagerProvider.of(context);

    return BrowserWebView(
      key: ValueKey(currentTab.id),
      tab: currentTab,
      onTabUpdate: (updatedTab) => _updateTab(_currentTabIndex, updatedTab),
      onNewTab: (url) => _addNewTab(url),
    );
  }

  /// 添加新标签页
  void _addNewTab(String url) {
    final newTab = BrowserTab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: url,
      title: '新标签页',
      favicon: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setState(() {
      _tabs.add(newTab);
      _currentTabIndex = _tabs.length - 1;
    });
  }

  /// 关闭标签页
  void _closeTab(int index) {
    setState(() {
      _tabs.removeAt(index);
      if (_currentTabIndex >= _tabs.length) {
        _currentTabIndex = _tabs.length - 1;
      }
    });
  }

  /// 更新标签页
  void _updateTab(int index, BrowserTab updatedTab) {
    setState(() {
      _tabs[index] = updatedTab;
    });
  }

  /// 刷新当前标签页
  Future<void> _refreshCurrentTab() async {
    final webViewManager = WebViewManagerProvider.of(context);
    await webViewManager.reloadAllWebViews();
  }

  /// 获取标签页标题
  String _getTabTitle(BrowserTab tab) {
    if (tab.title.isNotEmpty && tab.title != '新标签页') {
      return tab.title;
    }
    
    try {
      final uri = Uri.parse(tab.url);
      return uri.host;
    } catch (e) {
      return tab.url;
    }
  }

  /// 打开代理设置页面
  void _openProxySettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WebViewProxyConfigPage(),
      ),
    );
  }
}

/// 主入口函数
void main() {
  runApp(const WebViewProxyIntegrationExample());
}

/// 使用说明：
/// 
/// 1. 在main.dart中初始化代理服务：
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await WebViewProxyService.instance.initialize();
///   runApp(const YourApp());
/// }
/// ```
/// 
/// 2. 在应用的根Widget中使用WebViewManagerProvider：
/// ```dart
/// class YourApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return WebViewManagerProvider(
///       notifier: WebViewManager.instance,
///       child: MaterialApp(...),
///     );
///   }
/// }
/// ```
/// 
/// 3. 在浏览器页面中使用BrowserWebView组件：
/// ```dart
/// BrowserWebView(
///   tab: browserTab,
///   onTabUpdate: (tab) => updateTab(tab),
///   onNewTab: (url) => addNewTab(url),
/// )
/// ```
/// 
/// 4. 代理功能自动集成，无需额外配置