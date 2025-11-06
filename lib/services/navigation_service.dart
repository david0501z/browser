import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 导航服务 - 管理浏览器和代理功能之间的流畅切换
class NavigationService {
  static NavigationService? _instance;
  static NavigationService get instance => _instance ??= NavigationService._();
  
  NavigationService._();

  final Map<String, PageRoute> _activeRoutes = {};
  final Map<String, Widget> _preloadedWidgets = {};
  final Set<String> _navigationHistory = {};
  late final PageController _pageController;
  late final NavigatorObserver _navigationObserver;
  
  /// 初始化导航服务
  void initialize() {
    _pageController = PageController();
    _navigationObserver = _CustomNavigationObserver(this);
    _startPerformanceMonitoring();
  }

  /// 释放资源
  void dispose() {
    _pageController.dispose();
    _activeRoutes.clear();
    _preloadedWidgets.clear();
    _navigationHistory.clear();
  }

  /// 获取页面控制器
  PageController get pageController => _pageController;

  /// 获取导航观察器
  NavigatorObserver get navigationObserver => _navigationObserver;

  /// 切换到指定模式
  Future<bool> switchToMode(
    BuildContext context, 
    SwitchMode mode, {
    bool animated = true,
    Duration? duration,
  }) async {
    try {
      final sharedStateNotifier = context.read<SharedStateNotifier>();
      final currentMode = context.read<SwitchMode>(currentSwitchModeProvider);
      
      if (currentMode == mode) {
        return true; // 已经在目标模式
      }

      // 开始切换
      await sharedStateNotifier.startSwitch(mode);

      // 根据模式执行导航
      switch (mode) {
        case SwitchMode.browser:
          return await _navigateToBrowser(context, animated: animated, duration: duration);
        case SwitchMode.proxy:
          return await _navigateToProxy(context, animated: animated, duration: duration);
        case SwitchMode.switching:
          return false; // 切换状态不执行导航
      }
    } catch (e) {
      debugPrint('导航切换失败: $e');
      return false;
    }
  }

  /// 导航到浏览器模式
  Future<bool> _navigateToBrowser(
    BuildContext context, {
    bool animated = true,
    Duration? duration,
  }) async {
    try {
      // 预加载浏览器页面
      await _preloadBrowserWidget();

      // 执行导航
      if (animated) {
        return await Navigator.of(context).pushReplacement(
          _createRoute(
            const BrowserPage(),
            duration: duration ?? const Duration(milliseconds: 300),
          ),
        );
      } else {
        Navigator.of(context).pushReplacementNamed('/browser');
        return true;
      }
    } catch (e) {
      debugPrint('导航到浏览器失败: $e');
      return false;
    }
  }

  /// 导航到代理模式
  Future<bool> _navigateToProxy(
    BuildContext context, {
    bool animated = true,
    Duration? duration,
  }) async {
    try {
      // 预加载代理页面
      await _preloadProxyWidget();

      // 执行导航
      if (animated) {
        return await Navigator.of(context).pushReplacement(
          _createRoute(
            const ProxyPage(),
            duration: duration ?? const Duration(milliseconds: 300),
          ),
        );
      } else {
        Navigator.of(context).pushReplacementNamed('/proxy');
        return true;
      }
    } catch (e) {
      debugPrint('导航到代理失败: $e');
      return false;
    }
  }

  /// 创建路由
  PageRoute<T> _createRoute<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// 预加载浏览器组件
  Future<void> _preloadBrowserWidget() async {
    if (!_preloadedWidgets.containsKey('browser')) {
      _preloadedWidgets['browser'] = const BrowserPage();
    }
  }

  /// 预加载代理组件
  Future<void> _preloadProxyWidget() async {
    if (!_preloadedWidgets.containsKey('proxy')) {
      _preloadedWidgets['proxy'] = const ProxyPage();
    }
  }

  /// 智能预加载
  Future<void> smartPreload(BuildContext context, SwitchMode mode) async {
    try {
      switch (mode) {
        case SwitchMode.browser:
          await _preloadBrowserWidget();
          await _warmUpBrowserResources();
          break;
        case SwitchMode.proxy:
          await _preloadProxyWidget();
          await _warmUpProxyResources();
          break;
        case SwitchMode.switching:
          // 切换状态不需要预加载
          break;
      }
    } catch (e) {
      debugPrint('智能预加载失败: $e');
    }
  }

  /// 预热浏览器资源
  Future<void> _warmUpBrowserResources() async {
    try {
      // 预加载常用的浏览器资源
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      debugPrint('浏览器资源预热失败: $e');
    }
  }

  /// 预热代理资源
  Future<void> _warmUpProxyResources() async {
    try {
      // 预加载常用的代理资源
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      debugPrint('代理资源预热失败: $e');
    }
  }

  /// 获取导航历史
  List<String> getNavigationHistory() {
    return _navigationHistory.toList();
  }

  /// 清除导航历史
  void clearNavigationHistory() {
    _navigationHistory.clear();
  }

  /// 添加到导航历史
  void addToHistory(String route) {
    _navigationHistory.add(route);
    // 保持历史记录在合理范围内
    if (_navigationHistory.length > 50) {
      final first = _navigationHistory.first;
      _navigationHistory.remove(first);
    }
  }

  /// 启动性能监控
  void _startPerformanceMonitoring() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _collectPerformanceMetrics();
    });
  }

  /// 收集性能指标
  void _collectPerformanceMetrics() {
    // 这里可以收集实际的性能指标
    // 例如：内存使用、CPU使用率、帧率等
  }

  /// 处理返回导航
  Future<bool> handleBackNavigation(BuildContext context) async {
    try {
      final currentMode = context.read<SwitchMode>(currentSwitchModeProvider);
      
      // 如果在代理模式，询问是否切换到浏览器
      if (currentMode == SwitchMode.proxy) {
        final shouldSwitch = await _showSwitchConfirmationDialog(context);
        if (shouldSwitch) {
          return await switchToMode(context, SwitchMode.browser);
        }
        return false;
      }
      
      // 在浏览器模式下，执行默认返回逻辑
      return Navigator.of(context).canPop();
    } catch (e) {
      debugPrint('处理返回导航失败: $e');
      return false;
    }
  }

  /// 显示切换确认对话框
  Future<bool> _showSwitchConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('切换模式'),
        content: const Text('是否切换回浏览器模式？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确定'),
          ),
        ],
      ),
    ) ?? false;
  }

  /// 获取当前页面标识
  String getCurrentPageIdentifier() {
    final route = _activeRoutes.values.lastOrNull;
    return route?.settings.name ?? 'unknown';
  }

  /// 注册活跃路由
  void registerRoute(String identifier, PageRoute route) {
    _activeRoutes[identifier] = route;
  }

  /// 注销路由
  void unregisterRoute(String identifier) {
    _activeRoutes.remove(identifier);
  }
}

/// 自定义导航观察器
class _CustomNavigationObserver extends NavigatorObserver {
  final NavigationService _navigationService;

  _CustomNavigationObserver(this._navigationService);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _navigationService.addToHistory(route.settings.name ?? 'push');
    _navigationService.registerRoute(route.settings.name ?? 'unnamed', route as PageRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _navigationService.unregisterRoute(route.settings.name ?? 'unnamed');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      _navigationService.unregisterRoute(oldRoute.settings.name ?? 'unnamed');
    }
    if (newRoute != null) {
      _navigationService.addToHistory(newRoute.settings.name ?? 'replace');
      _navigationService.registerRoute(newRoute.settings.name ?? 'unnamed', newRoute as PageRoute);
    }
  }
}

/// 浏览器页面组件
class BrowserPage extends ConsumerWidget {
  const BrowserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('浏览器模式'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.web,
              size: 64,
              color: Colors.blue,
            ),
            SizedBox(height: 16),
            Text(
              '浏览器模式',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '浏览网页、查看书签、管理历史记录',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 代理页面组件
class ProxyPage extends ConsumerWidget {
  const ProxyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('代理模式'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.security,
              size: 64,
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              '代理模式',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '安全代理、网络加速、隐私保护',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 扩展方法：获取列表的最后一个元素或null
extension<T> on List<T> {
  T? get lastOrNull => isEmpty ? null : last;
}