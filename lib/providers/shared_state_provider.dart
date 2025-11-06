import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

/// 切换模式枚举
enum SwitchMode {
  /// 浏览器模式
  browser,
  /// 代理模式
  proxy,
  /// 切换中
  switching,
}

/// 切换状态枚举
enum TransitionState {
  /// 空闲状态
  idle,
  /// 预加载中
  preloading,
  /// 切换中
  switching,
  /// 完成
  completed,
}

/// 共享状态数据模型
class SharedState {
  final SwitchMode currentMode;
  final SwitchMode targetMode;
  final TransitionState transitionState;
  final double transitionProgress;
  final bool isPreloading;
  final Map<String, dynamic> cachedData;
  final DateTime lastSwitchTime;
  final int switchCount;
  final bool enableAnimations;
  final Duration transitionDuration;

  const SharedState({
    this.currentMode = SwitchMode.browser,
    this.targetMode = SwitchMode.browser,
    this.transitionState = TransitionState.idle,
    this.transitionProgress = 0.0,
    this.isPreloading = false,
    this.cachedData = const {},
    DateTime? lastSwitchTime,
    this.switchCount = 0,
    this.enableAnimations = true,
    this.transitionDuration = const Duration(milliseconds: 300),
  }) : lastSwitchTime = lastSwitchTime ?? DateTime.now();

  SharedState copyWith({
    SwitchMode? currentMode,
    SwitchMode? targetMode,
    TransitionState? transitionState,
    double? transitionProgress,
    bool? isPreloading,
    Map<String, dynamic>? cachedData,
    DateTime? lastSwitchTime,
    int? switchCount,
    bool? enableAnimations,
    Duration? transitionDuration,
  }) {
    return SharedState(
      currentMode: currentMode ?? this.currentMode,
      targetMode: targetMode ?? this.targetMode,
      transitionState: transitionState ?? this.transitionState,
      transitionProgress: transitionProgress ?? this.transitionProgress,
      isPreloading: isPreloading ?? this.isPreloading,
      cachedData: cachedData ?? this.cachedData,
      lastSwitchTime: lastSwitchTime ?? this.lastSwitchTime,
      switchCount: switchCount ?? this.switchCount,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      transitionDuration: transitionDuration ?? this.transitionDuration,
    );
  }

  /// 是否正在切换中
  bool get isSwitching => 
      transitionState == TransitionState.switching ||;
      transitionState == TransitionState.preloading;

  /// 是否可以开始新的切换
  bool get canStartSwitch => 
      transitionState == TransitionState.idle ||;
      transitionState == TransitionState.completed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedState &&
          runtimeType == other.runtimeType &&
          currentMode == other.currentMode &&
          targetMode == other.targetMode &&
          transitionState == other.transitionState &&
          transitionProgress == other.transitionProgress &&
          isPreloading == other.isPreloading &&
          cachedData == other.cachedData &&
          lastSwitchTime == other.lastSwitchTime &&
          switchCount == other.switchCount &&
          enableAnimations == other.enableAnimations &&
          transitionDuration == other.transitionDuration;

  @override
  int get hashCode =>
      currentMode.hashCode ^
      targetMode.hashCode ^
      transitionState.hashCode ^
      transitionProgress.hashCode ^
      isPreloading.hashCode ^
      cachedData.hashCode ^
      lastSwitchTime.hashCode ^
      switchCount.hashCode ^
      enableAnimations.hashCode ^
      transitionDuration.hashCode;
}

/// 共享状态管理器
class SharedStateNotifier extends StateNotifier<SharedState> {
  SharedStateNotifier() : super(const SharedState());

  /// 开始切换模式
  Future<void> startSwitch(SwitchMode targetMode) async {
    if (!state.canStartSwitch || state.currentMode == targetMode) {
      return;
    }

    // 更新状态为预加载
    state = state.copyWith(
      targetMode: targetMode,
      transitionState: TransitionState.preloading,
      isPreloading: true,
    );

    try {
      // 预加载目标模式的数据
      await _preloadTargetModeData(targetMode);
      
      // 开始切换动画
      state = state.copyWith(
        transitionState: TransitionState.switching,
        transitionProgress: 0.0,
      );

      // 执行切换
      await _performSwitch(targetMode);

      // 完成切换
      state = state.copyWith(
        currentMode: targetMode,
        transitionState: TransitionState.completed,
        transitionProgress: 1.0,
        isPreloading: false,
        lastSwitchTime: DateTime.now(),
        switchCount: state.switchCount + 1,
      );

      // 重置为空闲状态
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          state = state.copyWith(transitionState: TransitionState.idle);
        }
      });

    } catch (e) {
      // 切换失败，恢复原状态
      state = state.copyWith(
        transitionState: TransitionState.idle,
        isPreloading: false,
      );
      debugPrint('切换模式失败: $e');
    }
  }

  /// 预加载目标模式数据
  Future<void> _preloadTargetModeData(SwitchMode mode) async {
    final cachedData = Map<String, dynamic>.from(state.cachedData);
    
    switch (mode) {
      case SwitchMode.browser:
        // 预加载浏览器相关数据
        cachedData['browser_preloaded'] = true;
        cachedData['browser_cache_time'] = DateTime.now().millisecondsSinceEpoch;
        break;
      case SwitchMode.proxy:
        // 预加载代理相关数据
        cachedData['proxy_preloaded'] = true;
        cachedData['proxy_cache_time'] = DateTime.now().millisecondsSinceEpoch;
        break;
      case SwitchMode.switching:
        // 切换状态不需要预加载
        break;
    }

    state = state.copyWith(cachedData: cachedData);
  }

  /// 执行实际切换
  Future<void> _performSwitch(SwitchMode targetMode) async {
    // 模拟切换过程
    final steps = 10;
    for (int i = 0; i <= steps; i++) {
      if (!mounted) break;
      
      final progress = i / steps;
      state = state.copyWith(transitionProgress: progress);
      
      // 等待一小段时间以显示动画
      await Future.delayed(Duration(milliseconds: state.transitionDuration.inMilliseconds ~/ steps));
    }
  }

  /// 更新切换进度
  void updateTransitionProgress(double progress) {
    if (state.isSwitching) {
      state = state.copyWith(transitionProgress: progress.clamp(0.0, 1.0));
    }
  }

  /// 设置动画开关
  void setAnimationsEnabled(bool enabled) {
    state = state.copyWith(enableAnimations: enabled);
  }

  /// 设置切换持续时间
  void setTransitionDuration(Duration duration) {
    state = state.copyWith(transitionDuration: duration);
  }

  /// 清除缓存数据
  void clearCache() {
    state = state.copyWith(cachedData: {});
  }

  /// 获取缓存的数据
  T? getCachedData<T>(String key) {
    return state.cachedData[key] as T?;
  }

  /// 设置缓存数据
  void setCachedData(String key, dynamic value) {
    final cachedData = Map<String, dynamic>.from(state.cachedData);
    cachedData[key] = value;
    state = state.copyWith(cachedData: cachedData);
  }

  /// 检查数据是否过期
  bool isCacheExpired(String key, Duration maxAge) {
    final cacheTime = state.cachedData['${key}_cache_time'] as int?;
    if (cacheTime == null) return true;
    
    final age = DateTime.now().millisecondsSinceEpoch - cacheTime;
    return age > maxAge.inMilliseconds;
  }

  /// 重置状态
  void reset() {
    state = const SharedState();
  }
}

/// 性能指标数据模型
class PerformanceMetrics {
  final DateTime timestamp;
  final double cpuUsage;
  final double memoryUsage;
  final int frameRate;
  final Duration loadTime;
  final int cacheHitRate;

  const PerformanceMetrics({
    required this.timestamp,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.frameRate,
    required this.loadTime,
    required this.cacheHitRate,
  });

  PerformanceMetrics copyWith({
    DateTime? timestamp,
    double? cpuUsage,
    double? memoryUsage,
    int? frameRate,
    Duration? loadTime,
    int? cacheHitRate,
  }) {
    return PerformanceMetrics(
      timestamp: timestamp ?? this.timestamp,
      cpuUsage: cpuUsage ?? this.cpuUsage,
      memoryUsage: memoryUsage ?? this.memoryUsage,
      frameRate: frameRate ?? this.frameRate,
      loadTime: loadTime ?? this.loadTime,
      cacheHitRate: cacheHitRate ?? this.cacheHitRate,
    );
  }
}

/// 性能监控管理器
class PerformanceMonitorNotifier extends StateNotifier<List<PerformanceMetrics>> {
  PerformanceMonitorNotifier() : super([]);

  /// 添加性能指标
  void addMetrics(PerformanceMetrics metrics) {
    state = [...state, metrics].take(100).toList(); // 保留最近100条记录;
  }

  /// 获取平均性能指标
  PerformanceMetrics getAverageMetrics() {
    if (state.isEmpty) {
      return const PerformanceMetrics(
        timestamp: null,
        cpuUsage: 0,
        memoryUsage: 0,
        frameRate: 60,
        loadTime: Duration.zero,
        cacheHitRate: 0,
      );
    }

    final avgCpu = state.fold<double>(0, (sum, m) => sum + m.cpuUsage) / state.length;
    final avgMemory = state.fold<double>(0, (sum, m) => sum + m.memoryUsage) / state.length;
    final avgFrameRate = state.fold<int>(0, (sum, m) => sum + m.frameRate) / state.length;
    final avgLoadTime = Duration(
      milliseconds: (state.fold<int>(0, (sum, m) => sum + m.loadTime.inMilliseconds) / state.length).round();
    );
    final avgCacheHit = state.fold<int>(0, (sum, m) => sum + m.cacheHitRate) / state.length;

    return PerformanceMetrics(
      timestamp: DateTime.now(),
      cpuUsage: avgCpu,
      memoryUsage: avgMemory,
      frameRate: avgFrameRate.round(),
      loadTime: avgLoadTime,
      cacheHitRate: avgCacheHit.round(),
    );
  }

  /// 清除历史记录
  void clearHistory() {
    state = [];
  }
}

/// Provider定义
final sharedStateProvider = StateNotifierProvider<SharedStateNotifier, SharedState>(
  (ref) => SharedStateNotifier(),
);

final performanceMonitorProvider = StateNotifierProvider<PerformanceMonitorNotifier, List<PerformanceMetrics>>(
  (ref) => PerformanceMonitorNotifier(),
);

/// 当前切换模式Provider
final currentSwitchModeProvider = Provider<SwitchMode>((ref) {
  return ref.watch(sharedStateProvider).currentMode;
});

/// 切换状态Provider
final transitionStateProvider = Provider<TransitionState>((ref) {
  return ref.watch(sharedStateProvider).transitionState;
});

/// 是否正在切换Provider
final isSwitchingProvider = Provider<bool>((ref) {
  return ref.watch(sharedStateProvider).isSwitching;
});

/// 切换进度Provider
final transitionProgressProvider = Provider<double>((ref) {
  return ref.watch(sharedStateProvider).transitionProgress;
});

/// 性能指标Provider
final performanceMetricsProvider = Provider<PerformanceMetrics>((ref) {
  return ref.watch(performanceMonitorProvider.notifier).getAverageMetrics();
});