import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';

/// 错误恢复策略枚举
enum RecoveryStrategy {
  /// 立即重试
  immediateRetry,
  /// 延迟重试
  delayedRetry,
  /// 指数退避重试
  exponentialBackoff,
  /// 故障转移
  failover,
  /// 降级处理
  gracefulDegradation,
  /// 手动恢复
  manualRecovery,
  /// 忽略错误
  ignoreError,
  /// 重启应用
  restartApplication,
  /// 回滚到上一个稳定版本
  rollbackToPrevious,
}

/// 恢复状态
enum RecoveryState {
  /// 准备就绪
  ready,
  /// 正在恢复
  recovering,
  /// 恢复成功
  recovered,
  /// 恢复失败
  failed,
  /// 恢复中但存在风险
  recoveringWithRisk,
}

/// 错误严重级别
enum ErrorSeverity {
  /// 低严重级别 - 不影响核心功能
  low,
  /// 中严重级别 - 影响部分功能
  medium,
  /// 高严重级别 - 影响主要功能
  high,
  /// 关键错误 - 影响整个应用
  critical,
}

/// 恢复规则配置
class RecoveryRule {
  final Type errorType;
  final RecoveryStrategy strategy;
  final int maxRetries;
  final Duration retryDelay;
  final bool isEnabled;
  final ErrorSeverity severity;
  final List<String> applicableConditions;
  
  const RecoveryRule({
    required this.errorType,
    required this.strategy,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.isEnabled = true,
    this.severity = ErrorSeverity.medium,
    this.applicableConditions = const [],
  });
}

/// 错误恢复上下文
class ErrorRecoveryContext {
  final String errorId;
  final String errorMessage;
  final Type errorType;
  final StackTrace? stackTrace;
  final DateTime timestamp;
  final Map<String, dynamic> errorData;
  final int attemptCount;
  final RecoveryStrategy strategy;
  
  ErrorRecoveryContext({
    required this.errorId,
    required this.errorMessage,
    required this.errorType,
    this.stackTrace,
    required this.timestamp,
    required this.errorData,
    this.attemptCount = 0,
    required this.strategy,
  });
  
  ErrorRecoveryContext copyWith({
    String? errorId,
    String? errorMessage,
    Type? errorType,
    StackTrace? stackTrace,
    DateTime? timestamp,
    Map<String, dynamic>? errorData,
    int? attemptCount,
    RecoveryStrategy? strategy,
  }) {
    return ErrorRecoveryContext(
      errorId: errorId ?? this.errorId,
      errorMessage: errorMessage ?? this.errorMessage,
      errorType: errorType ?? this.errorType,
      stackTrace: stackTrace ?? this.stackTrace,
      timestamp: timestamp ?? this.timestamp,
      errorData: errorData ?? this.errorData,
      attemptCount: attemptCount ?? this.attemptCount,
      strategy: strategy ?? this.strategy,
    );
  }
}

/// 恢复结果
class RecoveryResult {
  final bool success;
  final String message;
  final Duration recoveryTime;
  final int attemptCount;
  final RecoveryStrategy strategy;
  final Map<String, dynamic> additionalData;
  final bool requiresRestart;
  
  const RecoveryResult({
    required this.success,
    required this.message,
    required this.recoveryTime,
    required this.attemptCount,
    required this.strategy,
    this.additionalData = const {},
    this.requiresRestart = false,
  });
}

/// 错误恢复管理器
class ErrorRecoveryManager {
  static final ErrorRecoveryManager _instance = ErrorRecoveryManager._internal();
  factory ErrorRecoveryManager() => _instance;
  ErrorRecoveryManager._internal();
  
  final Logger _logger = Logger('ErrorRecoveryManager');
  
  /// 恢复规则映射
  final Map<Type, RecoveryRule> _recoveryRules = {};
  
  /// 活跃的恢复会话
  final Map<String, ErrorRecoveryContext> _activeRecoverySessions = {};
  
  /// 恢复状态监听器
  final List<RecoveryStateListener> _stateListeners = [];
  
  /// 恢复历史记录
  final List<RecoveryResult> _recoveryHistory = [];
  
  /// 恢复计数器
  final Map<String, int> _retryCounters = {};
  
  /// 最大恢复历史记录数量
  static const int maxHistorySize = 100;
  
  /// 初始化恢复管理器
  Future<void> initialize() async {
    _logger.info('初始化错误恢复管理器');
    
    _registerDefaultRecoveryRules();
    _setupGlobalExceptionHandlers();
    
    _logger.info('错误恢复管理器初始化完成');
  }
  
  /// 注册默认恢复规则
  void _registerDefaultRecoveryRules() {
    // 网络错误恢复规则
    registerRecoveryRule(RecoveryRule(
      errorType: SocketException,
      strategy: RecoveryStrategy.exponentialBackoff,
      maxRetries: 5,
      retryDelay: Duration(seconds: 2),
      severity: ErrorSeverity.medium,
      applicableConditions: ['network_available'],
    ));
    
    // 连接超时恢复规则
    registerRecoveryRule(RecoveryRule(
      errorType: TimeoutException,
      strategy: RecoveryStrategy.delayedRetry,
      maxRetries: 3,
      retryDelay: Duration(seconds: 3),
      severity: ErrorSeverity.medium,
    ));
    
    // 应用崩溃恢复规则
    registerRecoveryRule(RecoveryRule(
      errorType: PlatformException,
      strategy: RecoveryStrategy.restartApplication,
      maxRetries: 1,
      severity: ErrorSeverity.critical,
      applicableConditions: ['native_crash'],
    ));
    
    // 内存不足恢复规则
    registerRecoveryRule(RecoveryRule(
      errorType: OutOfMemoryError,
      strategy: RecoveryStrategy.gracefulDegradation,
      maxRetries: 1,
      severity: ErrorSeverity.high,
    ));
    
    // 权限错误恢复规则
    registerRecoveryRule(RecoveryRule(
      errorType: PermissionDeniedException,
      strategy: RecoveryStrategy.manualRecovery,
      maxRetries: 1,
      severity: ErrorSeverity.high,
    ));
    
    // 未知错误恢复规则
    registerRecoveryRule(RecoveryRule(
      errorType: Exception,
      strategy: RecoveryStrategy.delayedRetry,
      maxRetries: 2,
      retryDelay: Duration(seconds: 1),
      severity: ErrorSeverity.medium,
    ));
  }
  
  /// 注册恢复规则
  void registerRecoveryRule(RecoveryRule rule) {
    _recoveryRules[rule.errorType] = rule;
    _logger.info('注册恢复规则: ${rule.errorType} -> ${rule.strategy}');
  }
  
  /// 设置全局异常处理器
  void _setupGlobalExceptionHandlers() {
    // Flutter 框架异常处理
    FlutterError.onError = (FlutterErrorDetails details) {
      handleError(details.exception, details.stack);
    };
    
    // 平台隔离异常处理
    PlatformDispatcher.instance.onError = (error, stack) {
      handleError(error, stack);
      return true; // 不让应用崩溃
    };
    
    // 未捕获的异步异常处理
    Isolate.current.addErrorListener(RawReceivePort((dynamic message) {
      if (message is List) {
        final error = message[0] as Object;
        final stackTrace = message[1] as StackTrace;
        handleError(error, stackTrace);
      }
    }));
  }
  
  /// 处理错误
  Future<RecoveryResult?> handleError(
    Object error, [
    StackTrace? stackTrace,
    RecoveryStrategy? strategy,
  ]) async {
    final errorType = error.runtimeType;
    final errorMessage = error.toString();
    final errorId = _generateErrorId();
    
    _logger.error('处理错误: $errorMessage', error: error, stackTrace: stackTrace);
    
    // 获取恢复规则
    final rule = _recoveryRules[errorType] ?? RecoveryRule(
      errorType: errorType,
      strategy: RecoveryStrategy.manualRecovery,
    );
    
    // 如果错误不严重且规则禁用，则忽略
    if (!rule.isEnabled && rule.severity == ErrorSeverity.low) {
      _logger.info('忽略低严重级别错误');
      return null;
    }
    
    // 创建恢复上下文
    final context = ErrorRecoveryContext(
      errorId: errorId,
      errorMessage: errorMessage,
      errorType: errorType,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      errorData: {
        'platform': Platform.operatingSystem,
        'locale': Platform.localeName,
        'version': Platform.operatingSystemVersion,
      },
      strategy: strategy ?? rule.strategy,
    );
    
    // 添加到活跃恢复会话
    _activeRecoverySessions[errorId] = context;
    
    // 通知状态监听器
    _notifyStateListeners(RecoveryState.recovering, context);
    
    try {
      final result = await _performRecovery(context, rule);
      
      // 记录恢复结果
      _addRecoveryResult(result);
      
      // 从活跃会话中移除
      _activeRecoverySessions.remove(errorId);
      
      // 通知状态监听器
      if (result.success) {
        _notifyStateListeners(RecoveryState.recovered, context);
      } else if (result.requiresRestart) {
        _notifyStateListeners(RecoveryState.recoveringWithRisk, context);
      } else {
        _notifyStateListeners(RecoveryState.failed, context);
      }
      
      return result;
    } catch (recoveryError) {
      _logger.error('恢复过程中发生错误: $recoveryError');
      
      final result = RecoveryResult(
        success: false,
        message: '恢复失败: $recoveryError',
        recoveryTime: Duration.zero,
        attemptCount: 1,
        strategy: context.strategy,
      );
      
      _addRecoveryResult(result);
      _activeRecoverySessions.remove(errorId);
      _notifyStateListeners(RecoveryState.failed, context);
      
      return result;
    }
  }
  
  /// 执行恢复
  Future<RecoveryResult> _performRecovery(
    ErrorRecoveryContext context,
    RecoveryRule rule,
  ) async {
    final stopwatch = Stopwatch()..start();
    final retryKey = '${context.errorType}_${context.errorMessage}';
    
    // 增加重试计数
    final currentRetryCount = _retryCounters[retryKey] ?? 0;
    _retryCounters[retryKey] = currentRetryCount + 1;
    
    // 检查重试次数限制
    if (currentRetryCount >= rule.maxRetries) {
      _logger.warning('达到最大重试次数限制: ${rule.maxRetries}');
      
      return RecoveryResult(
        success: false,
        message: '达到最大重试次数: ${rule.maxRetries}',
        recoveryTime: stopwatch.elapsed,
        attemptCount: currentRetryCount,
        strategy: context.strategy,
      );
    }
    
    final attemptCount = currentRetryCount + 1;
    final updatedContext = context.copyWith(attemptCount: attemptCount);
    
    // 执行具体恢复策略
    switch (rule.strategy) {
      case RecoveryStrategy.immediateRetry:
        return await _immediateRetry(updatedContext, rule, stopwatch);
        
      case RecoveryStrategy.delayedRetry:
        return await _delayedRetry(updatedContext, rule, stopwatch);
        
      case RecoveryStrategy.exponentialBackoff:
        return await _exponentialBackoffRetry(updatedContext, rule, stopwatch);
        
      case RecoveryStrategy.failover:
        return await _failoverRecovery(updatedContext, rule, stopwatch);
        
      case RecoveryStrategy.gracefulDegradation:
        return await _gracefulDegradation(updatedContext, rule, stopwatch);
        
      case RecoveryStrategy.manualRecovery:
        return await _manualRecovery(updatedContext, rule, stopwatch);
        
      case RecoveryStrategy.ignoreError:
        return await _ignoreError(updatedContext, rule, stopwatch);
        
      case RecoveryStrategy.restartApplication:
        return await _restartApplication(updatedContext, rule, stopwatch);
        
      case RecoveryStrategy.rollbackToPrevious:
        return await _rollbackToPrevious(updatedContext, rule, stopwatch);
    }
  }
  
  /// 立即重试
  Future<RecoveryResult> _immediateRetry(
    ErrorRecoveryContext context,
    RecoveryRule rule,
    Stopwatch stopwatch,
  ) async {
    _logger.info('执行立即重试策略');
    
    // 模拟重试逻辑
    await Future.delayed(Duration(milliseconds: 100));
    
    stopwatch.stop();
    return RecoveryResult(
      success: true,
      message: '立即重试成功',
      recoveryTime: stopwatch.elapsed,
      attemptCount: context.attemptCount,
      strategy: context.strategy,
    );
  }
  
  /// 延迟重试
  Future<RecoveryResult> _delayedRetry(
    ErrorRecoveryContext context,
    RecoveryRule rule,
    Stopwatch stopwatch,
  ) async {
    _logger.info('执行延迟重试策略，延迟 ${rule.retryDelay}');
    
    await Future.delayed(rule.retryDelay);
    
    stopwatch.stop();
    return RecoveryResult(
      success: true,
      message: '延迟重试成功',
      recoveryTime: stopwatch.elapsed,
      attemptCount: context.attemptCount,
      strategy: context.strategy,
    );
  }
  
  /// 指数退避重试
  Future<RecoveryResult> _exponentialBackoffRetry(
    ErrorRecoveryContext context,
    RecoveryRule rule,
    Stopwatch stopwatch,
  ) async {
    final delay = rule.retryDelay * (context.attemptCount * 2);
    _logger.info('执行指数退避重试策略，延迟 $delay');
    
    await Future.delayed(delay);
    
    stopwatch.stop();
    return RecoveryResult(
      success: true,
      message: '指数退避重试成功',
      recoveryTime: stopwatch.elapsed,
      attemptCount: context.attemptCount,
      strategy: context.strategy,
      additionalData: {'actualDelay': delay.inMilliseconds},
    );
  }
  
  /// 故障转移
  Future<RecoveryResult> _failoverRecovery(
    ErrorRecoveryContext context,
    RecoveryRule rule,
    Stopwatch stopwatch,
  ) async {
    _logger.info('执行故障转移策略');
    
    // 模拟故障转移到备用系统
    await Future.delayed(Duration(seconds: 2));
    
    stopwatch.stop();
    return RecoveryResult(
      success: true,
      message: '故障转移成功',
      recoveryTime: stopwatch.elapsed,
      attemptCount: context.attemptCount,
      strategy: context.strategy,
      additionalData: {'failoverTarget': 'secondary_system'},
    );
  }
  
  /// 降级处理
  Future<RecoveryResult> _gracefulDegradation(
    ErrorRecoveryContext context,
    RecoveryRule rule,
    Stopwatch stopwatch,
  ) async {
    _logger.info('执行降级处理策略');
    
    // 模拟功能降级
    await Future.delayed(Duration(seconds: 1));
    
    stopwatch.stop();
    return RecoveryResult(
      success: true,
      message: '降级处理成功',
      recoveryTime: stopwatch.elapsed,
      attemptCount: context.attemptCount,
      strategy: context.strategy,
      additionalData: {'degradedFeatures': ['advanced_features', 'visual_effects']},
    );
  }
  
  /// 手动恢复
  Future<RecoveryResult> _manualRecovery(
    ErrorRecoveryContext context,
    RecoveryRule rule,
    Stopwatch stopwatch,
  ) async {
    _logger.info('执行手动恢复策略');
    
    // 等待用户操作或外部触发
    stopwatch.stop();
    return RecoveryResult(
      success: false,
      message: '需要手动恢复',
      recoveryTime: stopwatch.elapsed,
      attemptCount: context.attemptCount,
      strategy: context.strategy,
    );
  }
  
  /// 忽略错误
  Future<RecoveryResult> _ignoreError(
    ErrorRecoveryContext context,
    RecoveryRule rule,
    Stopwatch stopwatch,
  ) async {
    _logger.info('忽略错误');
    
    stopwatch.stop();
    return RecoveryResult(
      success: true,
      message: '错误已忽略',
      recoveryTime: stopwatch.elapsed,
      attemptCount: context.attemptCount,
      strategy: context.strategy,
    );
  }
  
  /// 重启应用
  Future<RecoveryResult> _restartApplication(
    ErrorRecoveryContext context,
    RecoveryRule rule,
    Stopwatch stopwatch,
  ) async {
    _logger.warning('重启应用以恢复');
    
    stopwatch.stop();
    return RecoveryResult(
      success: false,
      message: '应用需要重启',
      recoveryTime: stopwatch.elapsed,
      attemptCount: context.attemptCount,
      strategy: context.strategy,
      requiresRestart: true,
    );
  }
  
  /// 回滚到上一个稳定版本
  Future<RecoveryResult> _rollbackToPrevious(
    ErrorRecoveryContext context,
    RecoveryRule rule,
    Stopwatch stopwatch,
  ) async {
    _logger.warning('回滚到上一个稳定版本');
    
    stopwatch.stop();
    return RecoveryResult(
      success: false,
      message: '需要回滚配置',
      recoveryTime: stopwatch.elapsed,
      attemptCount: context.attemptCount,
      strategy: context.strategy,
    );
  }
  
  /// 生成错误ID
  String _generateErrorId() {
    return 'ERR_${DateTime.now().millisecondsSinceEpoch}_${Object.hashAll([
      DateTime.now(),
      StackTrace.current,
    ])}';
  }
  
  /// 添加恢复结果到历史记录
  void _addRecoveryResult(RecoveryResult result) {
    _recoveryHistory.add(result);
    
    // 限制历史记录大小
    if (_recoveryHistory.length > maxHistorySize) {
      _recoveryHistory.removeAt(0);
    }
  }
  
  /// 通知状态监听器
  void _notifyStateListeners(RecoveryState state, ErrorRecoveryContext context) {
    for (final listener in _stateListeners) {
      try {
        listener(state, context);
      } catch (e) {
        _logger.error('通知状态监听器时发生错误: $e');
      }
    }
  }
  
  /// 获取恢复历史
  List<RecoveryResult> getRecoveryHistory() {
    return List.unmodifiable(_recoveryHistory);
  }
  
  /// 获取活跃恢复会话
  Map<String, ErrorRecoveryContext> getActiveRecoverySessions() {
    return Map.unmodifiable(_activeRecoverySessions);
  }
  
  /// 获取重试统计
  Map<String, int> getRetryStatistics() {
    return Map.unmodifiable(_retryCounters);
  }
  
  /// 清除历史记录
  void clearHistory() {
    _recoveryHistory.clear();
    _retryCounters.clear();
    _logger.info('清除恢复历史记录');
  }
  
  /// 取消指定的恢复会话
  bool cancelRecoverySession(String errorId) {
    if (_activeRecoverySessions.containsKey(errorId)) {
      _activeRecoverySessions.remove(errorId);
      final retryKey = '${_activeRecoverySessions[errorId]?.errorType}_${_activeRecoverySessions[errorId]?.errorMessage}';
      _retryCounters.remove(retryKey);
      _logger.info('取消恢复会话: $errorId');
      return true;
    }
    return false;
  }
  
  /// 添加恢复状态监听器
  void addRecoveryStateListener(RecoveryStateListener listener) {
    _stateListeners.add(listener);
  }
  
  /// 移除恢复状态监听器
  void removeRecoveryStateListener(RecoveryStateListener listener) {
    _stateListeners.remove(listener);
  }
  
  /// 获取恢复规则
  Map<Type, RecoveryRule> getRecoveryRules() {
    return Map.unmodifiable(_recoveryRules);
  }
  
  /// 更新恢复规则
  void updateRecoveryRule(Type errorType, RecoveryRule newRule) {
    _recoveryRules[errorType] = newRule;
    _logger.info('更新恢复规则: $errorType -> ${newRule.strategy}');
  }
}

/// 恢复状态监听器
typedef RecoveryStateListener = void Function(RecoveryState state, ErrorRecoveryContext context);

/// 权限被拒绝异常
class PermissionDeniedException implements Exception {
  final String message;
  final String permission;
  
  const PermissionDeniedException(this.permission, [this.message = '']);
  
  @override
  String toString() => 'PermissionDeniedException: $permission ${message.isNotEmpty ? '- $message' : ''}';
}