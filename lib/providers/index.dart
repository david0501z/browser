/// 状态管理提供者导出
/// 
/// 这个模块包含了应用的所有状态管理提供者：
/// - 代理状态提供者 (proxy_providers.dart)
/// - 代理状态监控提供者 (proxy_status_provider.dart)
/// - 浏览器状态提供者 (browser_providers.dart)
/// - 共享状态提供者 (shared_state_provider.dart)
/// 
/// 使用方法：
/// ```dart
/// import 'package:flclash_browser_app/providers/index.dart';
/// 
/// // 使用Riverpod消费者
/// class MyWidget extends ConsumerWidget {
///   Widget build(BuildContext context, WidgetRef ref) {
///     final status = ref.watch(globalProxyStateProvider);
///     final monitor = ref.watch(proxyStatusMonitorProvider);
///     
///     return Text('Status: ${status.status.value}');
///   }
/// }
/// ```

// 核心代理状态提供者
export 'proxy_providers.dart';

// 代理状态监控提供者
export 'proxy_status_provider.dart';

// 浏览器相关提供者
export 'browser_providers.dart';

// 共享状态提供者
export 'shared_state_provider.dart';