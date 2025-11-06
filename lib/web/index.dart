/// WebView代理功能模块
/// 
/// 提供完整的WebView代理配置和管理功能：
/// - WebView管理器：统一管理多个WebView实例的代理配置
/// - 代理配置页面：可视化的代理配置管理界面
/// 
/// 使用示例：
/// ```dart
/// import 'package:your_package/web/web_view_manager.dart';
/// 
/// // 在应用的根Widget中使用WebViewManagerProvider
/// WebViewManagerProvider(
///   notifier: WebViewManager.instance,
///   child: YourApp(),
/// )
/// 
/// // 在子组件中获取WebViewManager
/// final webViewManager = WebViewManagerProvider.of(context);
/// await webViewManager.setProxyEnabled(true);
/// ```
library web_view_proxy;

// WebView管理器
export 'web_view_manager.dart';

// WebView代理配置页面
export 'web_view_proxy_config_page.dart';