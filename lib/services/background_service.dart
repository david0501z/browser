import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// 后台服务管理器
class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  // 服务状态
  bool _isRunning = false;
  bool _isPaused = false;
  
  // 定时器
  Timer? _cleanupTimer;
  Timer? _freezeTimer;
  Timer? _memoryCheckTimer;
  
  // 配置
  BackgroundConfig? _config;
  
  // 标签页管理
  final Map<String, TabInfo> _backgroundTabs = {};
  final Set<String> _frozenTabs = {};
  
  // 事件流
  final StreamController<BackgroundEvent> _eventController = 
      StreamController<BackgroundEvent>.broadcast();
  
  // 性能优化
  final List<OptimizationTask> _pendingOptimizations = [];

  /// 初始化后台服务
  Future<void> initialize({BackgroundConfig? config}) async {
    if (_isRunning) return;
    
    _config = config ?? BackgroundConfig.defaultConfig();
    
    // 启动后台任务
    _startBackgroundTasks();
    
    _isRunning = true;
    _emitEvent(BackgroundEventType.started, '后台服务已启动');
    
    log('后台服务初始化完成');
  }

  /// 启动后台任务
  void _startBackgroundTasks() {
    // 启动清理定时器
    _cleanupTimer = Timer.periodic(
      _config!.cleanupInterval,
      _performBackgroundCleanup,
    );
    
    // 启动冻结检查定时器
    _freezeTimer = Timer.periodic(
      _config!.freezeCheckInterval,
      _checkTabFreezing,
    );
    
    // 启动内存检查定时器
    _memoryCheckTimer = Timer.periodic(
      _config!.memoryCheckInterval,
      _performMemoryOptimization,
    );
    
    // 注册应用生命周期回调
    _registerLifecycleCallbacks();
  }

  /// 注册应用生命周期回调
  void _registerLifecycleCallbacks() {
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver());
  }

  /// 添加后台标签页
  void addBackgroundTab(String tabId, TabInfo tabInfo) {
    _backgroundTabs[tabId] = tabInfo;
    
    _emitEvent(BackgroundEventType.tabAdded, 
      '添加后台标签页: $tabId', 
      data: {'tab_id': tabId, 'url': tabInfo.url}
    );
    
    // 如果标签页数量超过限制，冻结最旧的标签页
    if (_backgroundTabs.length > _config!.maxBackgroundTabs) {
      _freezeOldestTab();
    }
  }

  /// 移除后台标签页
  void removeBackgroundTab(String tabId) {
    if (_backgroundTabs.remove(tabId) != null) {
      _frozenTabs.remove(tabId);
      
      _emitEvent(BackgroundEventType.tabRemoved, 
        '移除后台标签页: $tabId', 
        data: {'tab_id': tabId}
      );
    }
  }

  /// 冻结标签页
  void freezeTab(String tabId) {
    if (_backgroundTabs.containsKey(tabId)) {
      _frozenTabs.add(tabId);
      
      _emitEvent(BackgroundEventType.tabFrozen, 
        '冻结标签页: $tabId', 
        data: {'tab_id': tabId}
      );
    }
  }

  /// 解冻标签页
  void unfreezeTab(String tabId) {
    if (_frozenTabs.remove(tabId)) {
      _emitEvent(BackgroundEventType.tabUnfrozen, 
        '解冻标签页: $tabId', 
        data: {'tab_id': tabId}
      );
    }
  }

  /// 冻结最旧的标签页
  void _freezeOldestTab() {
    if (_backgroundTabs.isEmpty) return;
    
    final oldestTab = _backgroundTabs.values
        .reduce((a, b) => a.lastAccessed.isBefore(b.lastAccessed) ? a : b);
    
    freezeTab(oldestTab.id);
  }

  /// 检查标签页冻结
  void _checkTabFreezing(Timer timer) {
    final now = DateTime.now();
    final freezeThreshold = _config!.freezeThreshold;
    
    for (final entry in _backgroundTabs.entries) {
      final tabId = entry.key;
      final tabInfo = entry.value;
      
      // 检查是否应该冻结
      if (!_frozenTabs.contains(tabId)) {
        final inactiveTime = now.difference(tabInfo.lastAccessed);
        final memoryUsage = tabInfo.estimatedMemoryUsage;
        
        if (inactiveTime > freezeThreshold || memoryUsage > _config!.memoryFreezeThreshold) {
          freezeTab(tabId);
        }
      }
    }
  }

  /// 执行后台清理
  void _performBackgroundCleanup(Timer timer) {
    final now = DateTime.now();
    final cleanupThreshold = _config!.cleanupThreshold;
    
    // 清理长时间未访问的标签页
    final tabsToRemove = <String>[];
    
    _backgroundTabs.forEach((tabId, tabInfo) {
      final inactiveTime = now.difference(tabInfo.lastAccessed);
      if (inactiveTime > cleanupThreshold) {
        tabsToRemove.add(tabId);
      }
    });
    
    for (final tabId in tabsToRemove) {
      removeBackgroundTab(tabId);
    }
    
    // 执行内存优化任务
    _executePendingOptimizations();
    
    _emitEvent(BackgroundEventType.cleanup, 
      '清理完成，移除 ${tabsToRemove.length} 个标签页',
      data: {'removed_tabs': tabsToRemove.length}
    );
  }

  /// 执行内存优化
  void _performMemoryOptimization(Timer timer) {
    final totalMemoryUsage = _backgroundTabs.values
        .fold(0.0, (sum, tab) => sum + tab.estimatedMemoryUsage);
    
    if (totalMemoryUsage > _config!.totalMemoryThreshold) {
      // 添加优化任务
      _pendingOptimizations.add(OptimizationTask(
        type: OptimizationType.memoryCleanup,
        priority: Priority.high,
        data: {'current_usage': totalMemoryUsage},
      ));
      
      _emitEvent(BackgroundEventType.optimizationQueued, 
        '内存使用过高: ${totalMemoryUsage.toStringAsFixed(1)}MB',
        data: {'memory_usage': totalMemoryUsage}
      );
    }
  }

  /// 执行待处理的优化任务
  void _executePendingOptimizations() {
    if (_pendingOptimizations.isEmpty) return;
    
    // 按优先级排序
    _pendingOptimizations.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    
    final tasksToExecute = _pendingOptimizations.take(5); // 每次最多执行5个任务
    _pendingOptimizations.removeRange(0, tasksToExecute.length);
    
    for (final task in tasksToExecute) {
      _executeOptimizationTask(task);
    }
  }

  /// 执行优化任务
  void _executeOptimizationTask(OptimizationTask task) {
    switch (task.type) {
      case OptimizationType.memoryCleanup:
        _performMemoryCleanup();
        break;
      case OptimizationType.cacheCleanup:
        _performCacheCleanup();
        break;
      case OptimizationType.tabConsolidation:
        _performTabConsolidation();
        break;
      case OptimizationType.resourceOptimization:
        _performResourceOptimization();
        break;
    }
    
    _emitEvent(BackgroundEventType.optimizationCompleted, 
      '执行优化任务: ${task.type}',
      data: {'task_type': task.type.toString()}
    );
  }

  /// 执行内存清理
  void _performMemoryCleanup() {
    // 冻结内存使用最高的标签页
    final sortedTabs = _backgroundTabs.entries
        .where((entry) => !_frozenTabs.contains(entry.key))
        .toList()
      ..sort((a, b) => b.value.estimatedMemoryUsage.compareTo(a.value.estimatedMemoryUsage));
    
    for (final entry in sortedTabs.take(3)) {
      freezeTab(entry.key);
    }
  }

  /// 执行缓存清理
  void _performCacheCleanup() {
    // 这里可以调用缓存管理器的清理方法
    _emitEvent(BackgroundEventType.cacheCleanup, '执行缓存清理');
  }

  /// 执行标签页合并
  void _performTabConsolidation() {
    // 合并相似的标签页（相同域名的标签页）
    final domainGroups = <String, List<String>>{};
    
    _backgroundTabs.forEach((tabId, tabInfo) {
      final domain = _extractDomain(tabInfo.url);
      if (!domainGroups.containsKey(domain)) {
        domainGroups[domain] = [];
      }
      domainGroups[domain]!.add(tabId);
    });
    
    // 为每个域名组保留一个标签页
    domainGroups.forEach((domain, tabIds) {
      if (tabIds.length > 1) {
        for (final tabId in tabIds.skip(1)) {
          removeBackgroundTab(tabId);
        }
      }
    });
  }

  /// 执行资源优化
  void _performResourceOptimization() {
    // 优化资源加载
    _emitEvent(BackgroundEventType.resourceOptimization, '执行资源优化');
  }

  /// 提取域名
  String _extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return 'unknown';
    }
  }

  /// 暂停后台服务
  void pause() {
    if (!_isPaused) {
      _isPaused = true;
      _cleanupTimer?.cancel();
      _freezeTimer?.cancel();
      _memoryCheckTimer?.cancel();
      
      _emitEvent(BackgroundEventType.paused, '后台服务已暂停');
    }
  }

  /// 恢复后台服务
  void resume() {
    if (_isPaused && _isRunning) {
      _isPaused = false;
      _startBackgroundTasks();
      
      _emitEvent(BackgroundEventType.resumed, '后台服务已恢复');
    }
  }

  /// 停止后台服务
  void stop() {
    if (_isRunning) {
      _isRunning = false;
      _isPaused = false;
      
      _cleanupTimer?.cancel();
      _freezeTimer?.cancel();
      _memoryCheckTimer?.cancel();
      
      _backgroundTabs.clear();
      _frozenTabs.clear();
      _pendingOptimizations.clear();
      
      _emitEvent(BackgroundEventType.stopped, '后台服务已停止');
    }
  }

  /// 更新标签页访问时间
  void updateTabAccessTime(String tabId) {
    final tabInfo = _backgroundTabs[tabId];
    if (tabInfo != null) {
      tabInfo.lastAccessed = DateTime.now();
      
      // 如果标签页被冻结，则解冻
      if (_frozenTabs.contains(tabId)) {
        unfreezeTab(tabId);
      }
    }
  }

  /// 获取后台标签页列表
  List<TabInfo> getBackgroundTabs() {
    return _backgroundTabs.values.toList();
  }

  /// 获取冻结的标签页列表
  List<String> getFrozenTabs() {
    return _frozenTabs.toList();
  }

  /// 获取后台服务状态
  BackgroundServiceStatus getStatus() {
    return BackgroundServiceStatus(
      isRunning: _isRunning,
      isPaused: _isPaused,
      backgroundTabCount: _backgroundTabs.length,
      frozenTabCount: _frozenTabs.length,
      pendingOptimizations: _pendingOptimizations.length,
    );
  }

  /// 获取事件流
  Stream<BackgroundEvent> get eventStream => _eventController.stream;

  /// 发出事件
  void _emitEvent(BackgroundEventType type, String message, {Map<String, dynamic>? data}) {
    _eventController.add(BackgroundEvent(
      type: type,
      timestamp: DateTime.now(),
      message: message,
      data: data,
    ));
  }

  /// 清理所有资源
  void dispose() {
    stop();
    _eventController.close();
  }
}

/// 标签页信息
class TabInfo {
  final String id;
  final String url;
  final String title;
  DateTime lastAccessed;
  double estimatedMemoryUsage;
  final TabState state;

  TabInfo({
    required this.id,
    required this.url,
    required this.title,
    DateTime? lastAccessed,
    double? estimatedMemoryUsage,
    this.state = TabState.background,
  }) : lastAccessed = lastAccessed ?? DateTime.now(),
       estimatedMemoryUsage = estimatedMemoryUsage ?? 0.0;
}

/// 标签页状态
enum TabState {
  active,
  background,
  frozen,
}

/// 后台事件类型
enum BackgroundEventType {
  started,
  stopped,
  paused,
  resumed,
  tabAdded,
  tabRemoved,
  tabFrozen,
  tabUnfrozen,
  cleanup,
  optimizationQueued,
  optimizationCompleted,
  cacheCleanup,
  resourceOptimization,
}

/// 后台事件
class BackgroundEvent {
  final BackgroundEventType type;
  final DateTime timestamp;
  final String message;
  final Map<String, dynamic>? data;

  BackgroundEvent({
    required this.type,
    required this.timestamp,
    required this.message,
    this.data,
  });
}

/// 优化任务类型
enum OptimizationType {
  memoryCleanup,
  cacheCleanup,
  tabConsolidation,
  resourceOptimization,
}

/// 优先级
enum Priority {
  low,
  medium,
  high,
}

/// 优化任务
class OptimizationTask {
  final OptimizationType type;
  final Priority priority;
  final Map<String, dynamic> data;
  final DateTime createdAt;

  OptimizationTask({
    required this.type,
    required this.priority,
    required this.data,
  }) : createdAt = DateTime.now();
}

/// 后台服务状态
class BackgroundServiceStatus {
  final bool isRunning;
  final bool isPaused;
  final int backgroundTabCount;
  final int frozenTabCount;
  final int pendingOptimizations;

  BackgroundServiceStatus({
    required this.isRunning,
    required this.isPaused,
    required this.backgroundTabCount,
    required this.frozenTabCount,
    required this.pendingOptimizations,
  });
}

/// 后台配置
class BackgroundConfig {
  final Duration cleanupInterval;
  final Duration freezeCheckInterval;
  final Duration memoryCheckInterval;
  final Duration freezeThreshold;
  final Duration cleanupThreshold;
  final int maxBackgroundTabs;
  final double memoryFreezeThreshold;
  final double totalMemoryThreshold;

  BackgroundConfig({
    required this.cleanupInterval,
    required this.freezeCheckInterval,
    required this.memoryCheckInterval,
    required this.freezeThreshold,
    required this.cleanupThreshold,
    required this.maxBackgroundTabs,
    required this.memoryFreezeThreshold,
    required this.totalMemoryThreshold,
  });

  factory BackgroundConfig.defaultConfig() {
    return BackgroundConfig(
      cleanupInterval: const Duration(minutes: 10),
      freezeCheckInterval: const Duration(minutes: 2),
      memoryCheckInterval: const Duration(minutes: 5),
      freezeThreshold: const Duration(minutes: 15),
      cleanupThreshold: const Duration(hours: 2),
      maxBackgroundTabs: 10,
      memoryFreezeThreshold: 50.0, // 50MB
      totalMemoryThreshold: 200.0, // 200MB
    );
  }
}

/// 应用生命周期观察者
class _AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final backgroundService = BackgroundService();
    
    switch (state) {
      case AppLifecycleState.paused:
        backgroundService.pause();
        break;
      case AppLifecycleState.resumed:
        backgroundService.resume();
        break;
      case AppLifecycleState.detached:
        backgroundService.stop();
        break;
      default:
        break;
    }
  }
}