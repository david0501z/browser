import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../core/webview_proxy_adapter.dart';
import '../services/webview_proxy_service.dart';
import '../widgets/webview/browser_webview.dart';

/// WebView管理器
/// 
/// 负责管理多个WebView实例的代理配置同步，
/// 提供统一的代理状态管理和切换接口。
class WebViewManager extends ChangeNotifier {
  static WebViewManager? _instance;
  static WebViewManager get instance => _instance ??= WebViewManager._();

  WebViewManager._();

  final List<BrowserWebView> _activeWebViews = [];
  final Map<String, BrowserWebView> _webViewMap = {};
  ProxyConfig? _currentProxyConfig;

  /// 代理配置变更监听器
  final List<ProxyConfigListener> _listeners = [];

  /// WebView列表
  List<BrowserWebView> get activeWebViews => List.unmodifiable(_activeWebViews);

  /// 当前代理配置
  ProxyConfig? get currentProxyConfig => _currentProxyConfig;

  /// 代理是否启用
  bool get isProxyEnabled => 
      _currentProxyConfig?.enabled == true && 
      _currentProxyConfig?.proxyUrl?.isNotEmpty == true;

  /// WebView数量
  int get webViewCount => _activeWebViews.length;

  /// 注册WebView
  void registerWebView(String id, BrowserWebView webView) {
    if (!_webViewMap.containsKey(id)) {
      _webViewMap[id] = webView;
      _activeWebViews.add(webView);
      notifyListeners();
      debugPrint('WebView已注册: $id，当前总数: $_activeWebViews');
    }
  }

  /// 取消注册WebView
  void unregisterWebView(String id) {
    final webView = _webViewMap.remove(id);
    if (webView != null) {
      _activeWebViews.remove(webView);
      notifyListeners();
      debugPrint('WebView已取消注册: $id，当前总数: $_activeWebViews');
    }
  }

  /// 根据ID获取WebView
  BrowserWebView? getWebView(String id) {
    return _webViewMap[id];
  }

  /// 更新所有WebView的代理配置
  Future<void> updateAllWebViewProxyConfig(ProxyConfig config) async {
    if (config.enabled && !_validateProxyConfig(config)) {
      debugPrint('代理配置验证失败，跳过更新');
      return;
    }

    final oldConfig = _currentProxyConfig;
    _currentProxyConfig = config;

    // 更新所有活跃的WebView
    final updateTasks = <Future<void>>[];
    for (final webView in _activeWebViews) {
      updateTasks.add(_updateSingleWebView(webView, config));
    }

    // 等待所有WebView更新完成
    await Future.wait(updateTasks);

    // 通知配置变更
    for (final listener in _listeners) {
      listener(oldConfig, config);
    }

    notifyListeners();
    debugPrint('所有WebView代理配置已更新: ${config.enabled ? '启用' : '禁用'}');
  }

  /// 更新单个WebView的代理配置
  Future<void> _updateSingleWebView(BrowserWebView webView, ProxyConfig config) async {
    try {
      // 这里需要触发WebView重新加载以应用新配置
      // 由于WebView的代理配置需要在创建时设置，
      // 这里通过重新加载当前页面来间接应用配置
      await webView.reload();
      debugPrint('WebView代理配置更新完成');
    } catch (e) {
      debugPrint('更新WebView代理配置失败: $e');
    }
  }

  /// 启用/禁用代理
  Future<void> setProxyEnabled(bool enabled) async {
    final currentConfig = _currentProxyConfig;
    if (currentConfig == null) {
      return;
    }

    final newConfig = currentConfig.copyWith(enabled: enabled);
    await updateAllWebViewProxyConfig(newConfig);
  }

  /// 切换代理状态
  Future<void> toggleProxy() async {
    await setProxyEnabled(!isProxyEnabled);
  }

  /// 获取代理配置
  ProxyConfig? getProxyConfig() {
    return _currentProxyConfig;
  }

  /// 设置代理配置
  Future<void> setProxyConfig(ProxyConfig config) async {
    await updateAllWebViewProxyConfig(config);
  }

  /// 验证代理配置
  bool _validateProxyConfig(ProxyConfig config) {
    if (!config.enabled) {
      return true; // 禁用代理的配置总是有效的
    }

    if (config.proxyUrl?.isEmpty != false) {
      return false;
    }

    try {
      final uri = Uri.parse(config.proxyUrl!);
      if (uri.host.isEmpty || uri.port == 0) {
        return false;
      }
    } catch (e) {
      return false;
    }

    return true;
  }

  /// 测试所有WebView的代理连接
  Future<List<ProxyTestResult>> testAllProxyConnections() async {
    final results = <ProxyTestResult>[];
    
    for (final webView in _activeWebViews) {
      final result = await webView.testProxyConnection();
      results.add(result);
    }

    return results;
  }

  /// 获取WebView统计信息
  WebViewManagerStats getStats() {
    return WebViewManagerStats(
      webViewCount: _activeWebViews.length,
      proxyEnabled: isProxyEnabled,
      proxyType: _currentProxyConfig?.type.name ?? 'none',
      hasConfig: _currentProxyConfig != null,
    );
  }

  /// 重新加载所有WebView
  Future<void> reloadAllWebViews() async {
    final reloadTasks = _activeWebViews.map((webView) => webView.reload());
    await Future.wait(reloadTasks);
  }

  /// 清除所有WebView
  void clearAllWebViews() {
    _activeWebViews.clear();
    _webViewMap.clear();
    notifyListeners();
    debugPrint('所有WebView已清除');
  }

  /// 添加配置变更监听器
  void addConfigListener(ProxyConfigListener listener) {
    _listeners.add(listener);
  }

  /// 移除配置变更监听器
  void removeConfigListener(ProxyConfigListener listener) {
    _listeners.remove(listener);
  }

  /// 获取代理URL
  String? get proxyUrl => _currentProxyConfig?.proxyUrl;

  /// 获取代理类型
  ProxyType? get proxyType => _currentProxyConfig?.type;

  /// 获取代理认证信息
  ProxyAuth? get proxyAuth => _currentProxyConfig?.proxyAuth;

  @override
  void dispose() {
    _listeners.clear();
    _activeWebViews.clear();
    _webViewMap.clear();
    _currentProxyConfig = null;
    super.dispose();
    debugPrint('WebView管理器已释放');
  }
}

/// WebView管理器统计信息
class WebViewManagerStats {
  final int webViewCount;
  final bool proxyEnabled;
  final String proxyType;
  final bool hasConfig;

  const WebViewManagerStats({
    required this.webViewCount,
    required this.proxyEnabled,
    required this.proxyType,
    required this.hasConfig,
  });

  @override
  String toString() {
    return 'WebViewManagerStats(webViewCount: $webViewCount, proxyEnabled: $proxyEnabled, proxyType: $proxyType, hasConfig: $hasConfig)';
  }
}

/// WebView管理器提供者
/// 
/// 用于在Widget树中提供WebViewManager实例
class WebViewManagerProvider extends InheritedNotifier<WebViewManager> {
  const WebViewManagerProvider({
    Key? key,
    required WebViewManager notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static WebViewManager of(BuildContext context) {
    final WebViewManagerProvider? result = context.dependOnInheritedWidgetOfExactType<WebViewManagerProvider>();
    assert(result != null, 'WebViewManagerProvider未找到在上下文中');
    return result!.notifier!;
  }

  @override
  bool updateShouldNotify(WebViewManagerProvider oldWidget) {
    return notifier != oldWidget.notifier;
  }
}