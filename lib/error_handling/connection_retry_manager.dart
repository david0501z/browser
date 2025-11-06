import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// 重试策略类型
enum RetryStrategy {
  /// 固定间隔重试
  fixedInterval,
  /// 线性退避重试
  linearBackoff,
  /// 指数退避重试
  exponentialBackoff,
  /// 抖动退避重试
  jitterBackoff,
  /// 自适应重试
  adaptiveRetry,
  /// 组合策略
  compositeRetry,
}

/// 重试状态
enum RetryState {
  /// 空闲状态
  idle,
  /// 正在重试
  retrying,
  /// 等待下一次重试
  waiting,
  /// 重试成功
  succeeded,
  /// 重试失败
  failed,
  /// 重试超时
  timeout,
}

/// 错误类型分类
enum RetryableError {
  /// 网络超时
  networkTimeout,
  /// 连接被拒绝
  connectionRefused,
  /// 网络不可达
  networkUnreachable,
  /// DNS解析失败
  dnsResolutionFailed,
  /// 服务不可用
  serviceUnavailable,
  /// 临时错误
  temporaryError,
  /// 认证失败（可重试）
  authenticationRetryable,
  /// 速率限制
  rateLimited,
  /// 服务器错误
  serverError,
  /// 未知错误（默认可重试）
  unknown,
}

/// 重试配置
class RetryConfig {
  final RetryStrategy strategy;
  final int maxAttempts;
  final Duration initialDelay;
  final Duration maxDelay;
  final double backoffMultiplier;
  final bool enableJitter;
  final double jitterFactor;
  final Duration timeout;
  final List<RetryableError> retryableErrors;
  final List<Type> retryableExceptionTypes;
  final bool exponentialBackoffResetOnSuccess;
  final Duration? circuitBreakerThreshold;
  final int? adaptiveRetryThreshold;
  
  const RetryConfig({
    this.strategy = RetryStrategy.exponentialBackoff,
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 60),
    this.backoffMultiplier = 2.0,
    this.enableJitter = true,
    this.jitterFactor = 0.1,
    this.timeout = const Duration(seconds: 30),
    this.retryableErrors = const [
      RetryableError.networkTimeout,
      RetryableError.connectionRefused,
      RetryableError.networkUnreachable,
      RetryableError.serviceUnavailable,
      RetryableError.temporaryError,
      RetryableError.rateLimited,
      RetryableError.serverError,
      RetryableError.unknown,
    ],
    this.retryableExceptionTypes = const [
      SocketException,
      TimeoutException,
      HttpException,
    ],
    this.exponentialBackoffResetOnSuccess = true,
    this.circuitBreakerThreshold,
    this.adaptiveRetryThreshold,
  });
}

/// 重试上下文
class RetryContext {
  final String operationId;
  final String operationName;
  final DateTime startTime;
  final int currentAttempt;
  final Duration totalElapsedTime;
  final Duration lastDelay;
  final List<Duration> attemptDelays;
  final Map<String, dynamic> metadata;
  final RetryableError? lastErrorType;
  
  RetryContext({
    required this.operationId,
    required this.operationName,
    required this.startTime,
    required this.currentAttempt,
    required this.totalElapsedTime,
    required this.lastDelay,
    required this.attemptDelays,
    required this.metadata,
    this.lastErrorType,
  });
  
  RetryContext copyWith({
    String? operationId,
    String? operationName,
    DateTime? startTime,
    int? currentAttempt,
    Duration? totalElapsedTime,
    Duration? lastDelay,
    List<Duration>? attemptDelays,
    Map<String, dynamic>? metadata,
    RetryableError? lastErrorType,
  }) {
    return RetryContext(
      operationId: operationId ?? this.operationId,
      operationName: operationName ?? this.operationName,
      startTime: startTime ?? this.startTime,
      currentAttempt: currentAttempt ?? this.currentAttempt,
      totalElapsedTime: totalElapsedTime ?? this.totalElapsedTime,
      lastDelay: lastDelay ?? this.lastDelay,
      attemptDelays: attemptDelays ?? List.from(this.attemptDelays),
      metadata: metadata ?? Map.from(this.metadata),
      lastErrorType: lastErrorType ?? this.lastErrorType,
    );
  }
}

/// 重试结果
class RetryResult<T> {
  final bool success;
  final T? result;
  final Exception? error;
  final RetryState state;
  final int attempts;
  final Duration totalTime;
  final List<Duration> attemptDelays;
  final List<String> errorMessages;
  final bool isCircuitBreakerOpen;
  final Duration? nextRetryDelay;
  
  const RetryResult({
    required this.success,
    this.result,
    this.error,
    required this.state,
    required this.attempts,
    required this.totalTime,
    required this.attemptDelays,
    required this.errorMessages,
    this.isCircuitBreakerOpen = false,
    this.nextRetryDelay,
  });
}

/// 重试监听器
typedef RetryListener = void Function(RetryContext context, RetryState state, dynamic result);

/// 断路器状态
enum CircuitBreakerState {
  /// 关闭状态（正常工作）
  closed,
  /// 打开状态（拒绝请求）
  open,
  /// 半开状态（尝试恢复）
  halfOpen,
}

/// 断路器配置
class CircuitBreakerConfig {
  final int failureThreshold;
  final Duration timeout;
  final Duration resetTimeout;
  final int successThreshold;
  final List<Exception> failureTypes;
  
  const CircuitBreakerConfig({
    this.failureThreshold = 5,
    this.timeout = const Duration(seconds: 60),
    this.resetTimeout = const Duration(seconds: 30),
    this.successThreshold = 3,
    this.failureTypes = const [
      SocketException,
      TimeoutException,
      ServiceUnavailableException,
    ],
  });
}

/// 断路器
class CircuitBreaker {
  final String key;
  final CircuitBreakerConfig config;
  
  CircuitBreakerState _state = CircuitBreakerState.closed;
  int _failureCount = 0;
  int _successCount = 0;
  DateTime? _lastFailureTime;
  Timer? _resetTimer;
  
  CircuitBreaker(this.key, this.config);
  
  bool get canExecute => _state == CircuitBreakerState.closed || _state == CircuitBreakerState.halfOpen;
  CircuitBreakerState get state => _state;
  
  void recordSuccess() {
    _failureCount = 0;
    _successCount++;
    
    if (_state == CircuitBreakerState.halfOpen && _successCount >= config.successThreshold) {
      _reset();
    }
  }
  
  void recordFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();
    
    if (_failureCount >= config.failureThreshold) {
      _trip();
    }
  }
  
  void _trip() {
    if (_state != CircuitBreakerState.open) {
      _state = CircuitBreakerState.open;
      _resetTimer = Timer(config.resetTimeout, () => _transitionToHalfOpen());
    }
  }
  
  void _transitionToHalfOpen() {
    _state = CircuitBreakerState.halfOpen;
    _successCount = 0;
  }
  
  void _reset() {
    _state = CircuitBreakerState.closed;
    _failureCount = 0;
    _successCount = 0;
    _lastFailureTime = null;
    _resetTimer?.cancel();
    _resetTimer = null;
  }
  
  void dispose() {
    _resetTimer?.cancel();
  }
}

/// 连接重试管理器
class ConnectionRetryManager {
  static final ConnectionRetryManager _instance = ConnectionRetryManager._internal();
  factory ConnectionRetryManager() => _instance;
  ConnectionRetryManager._internal();
  
  final Logger _logger = Logger('ConnectionRetryManager');
  
  /// 重试配置
  RetryConfig _defaultConfig = const RetryConfig();
  
  /// 断路器映射
  final Map<String, CircuitBreaker> _circuitBreakers = {};
  
  /// 重试统计
  final Map<String, RetryStatistics> _statistics = {};
  
  /// 活跃的重试操作
  final Map<String, RetryContext> _activeRetries = {};
  
  /// 重试监听器
  final List<RetryListener> _retryListeners = [];
  
  /// 随机数生成器
  final Random _random = Random();
  
  /// 自适应重试参数
  final Map<String, AdaptiveRetryParams> _adaptiveParams = {};
  
  /// 初始化重试管理器
  Future<void> initialize([RetryConfig? defaultConfig]) async {
    if (defaultConfig != null) {
      _defaultConfig = defaultConfig;
    }
    
    _logger.info('初始化连接重试管理器');
    _logger.info('默认配置: ${_defaultConfig.toString()}');
  }
  
  /// 执行重试操作
  Future<RetryResult<T>> executeRetry<T>(
    Future<T> Function() operation, {
    String? operationId,
    String operationName = 'Unknown Operation',
    RetryConfig? config,
    Map<String, dynamic>? metadata,
  }) async {
    final effectiveConfig = config ?? _defaultConfig;
    final opId = operationId ?? _generateOperationId();
    final startTime = DateTime.now();
    
    _logger.info('开始重试操作: $operationName (ID: $opId)');
    
    // 检查断路器
    if (!_canExecute(opId, effectiveConfig)) {
      return RetryResult<T>(
        success: false,
        state: RetryState.failed,
        attempts: 0,
        totalTime: Duration.zero,
        attemptDelays: [],
        errorMessages: ['Circuit breaker is open'],
        isCircuitBreakerOpen: true,
      );
    }
    
    // 创建重试上下文
    var context = RetryContext(
      operationId: opId,
      operationName: operationName,
      startTime: startTime,
      currentAttempt: 0,
      totalElapsedTime: Duration.zero,
      lastDelay: Duration.zero,
      attemptDelays: [],
      metadata: metadata ?? {},
    );
    
    final errorMessages = <String>[];
    final attemptDelays = <Duration>[];
    final stopwatch = Stopwatch()..start();
    
    try {
      while (context.currentAttempt < effectiveConfig.maxAttempts) {
        context = context.copyWith(currentAttempt: context.currentAttempt + 1);
        
        _notifyRetryListeners(context, RetryState.retrying, null);
        
        try {
          // 执行操作
          final result = await operation().timeout(effectiveConfig.timeout);
          
          stopwatch.stop();
          
          // 记录成功
          _recordSuccess(opId, context, stopwatch.elapsed);
          
          _notifyRetryListeners(context, RetryState.succeeded, result);
          
          _logger.info('重试操作成功: $operationName (尝试次数: ${context.currentAttempt})');
          
          return RetryResult<T>(
            success: true,
            result: result,
            state: RetryState.succeeded,
            attempts: context.currentAttempt,
            totalTime: stopwatch.elapsed,
            attemptDelays: attemptDelays,
            errorMessages: errorMessages,
          );
          
        } catch (error, stackTrace) {
          errorMessages.add('尝试 ${context.currentAttempt}: $error');
          
          _logger.warning('重试操作失败: $error', error: error, stackTrace: stackTrace);
          
          // 分类错误
          final errorType = _classifyError(error);
          final updatedContext = context.copyWith(
            lastErrorType: errorType,
            totalElapsedTime: stopwatch.elapsed,
          );
          
          // 检查是否可重试
          if (!_isRetryable(error, errorType, effectiveConfig)) {
            _recordFailure(opId, updatedContext, error);
            
            stopwatch.stop();
            _notifyRetryListeners(updatedContext, RetryState.failed, error);
            
            return RetryResult<T>(
              success: false,
              error: error as Exception?,
              state: RetryState.failed,
              attempts: context.currentAttempt,
              totalTime: stopwatch.elapsed,
              attemptDelays: attemptDelays,
              errorMessages: errorMessages,
            );
          }
          
          // 检查是否还有重试机会
          if (context.currentAttempt >= effectiveConfig.maxAttempts) {
            _recordFailure(opId, updatedContext, error);
            
            stopwatch.stop();
            _notifyRetryListeners(updatedContext, RetryState.failed, error);
            
            return RetryResult<T>(
              success: false,
              error: error as Exception?,
              state: RetryState.failed,
              attempts: context.currentAttempt,
              totalTime: stopwatch.elapsed,
              attemptDelays: attemptDelays,
              errorMessages: errorMessages,
            );
          }
          
          // 计算下次重试延迟
          final delay = _calculateDelay(
            context,
            effectiveConfig,
            errorType,
          );
          
          attemptDelays.add(delay);
          final nextContext = updatedContext.copyWith(
            lastDelay: delay,
            attemptDelays: attemptDelays,
            totalElapsedTime: stopwatch.elapsed + delay,
          );
          
          _notifyRetryListeners(nextContext, RetryState.waiting, null);
          
          _logger.debug('等待重试延迟: ${delay.inMilliseconds}ms');
          
          // 等待重试
          await Future.delayed(delay);
          
          // 更新上下文
          context = nextContext;
          
          // 自适应调整
          _updateAdaptiveParams(opId, errorType, delay);
        }
      }
      
      // 达到最大重试次数
      _recordFailure(opId, context, Exception('达到最大重试次数'));
      
      stopwatch.stop();
      _notifyRetryListeners(context, RetryState.failed, null);
      
      return RetryResult<T>(
        success: false,
        error: Exception('达到最大重试次数: ${effectiveConfig.maxAttempts}') as Exception?,
        state: RetryState.failed,
        attempts: effectiveConfig.maxAttempts,
        totalTime: stopwatch.elapsed,
        attemptDelays: attemptDelays,
        errorMessages: errorMessages,
      );
      
    } catch (error, stackTrace) {
      _logger.error('重试操作异常: $error', error: error, stackTrace: stackTrace);
      
      stopwatch.stop();
      _notifyRetryListeners(context, RetryState.failed, error);
      
      return RetryResult<T>(
        success: false,
        error: error as Exception?,
        state: RetryState.failed,
        attempts: context.currentAttempt,
        totalTime: stopwatch.elapsed,
        attemptDelays: attemptDelays,
        errorMessages: errorMessages,
      );
    }
  }
  
  /// 检查是否可执行
  bool _canExecute(String operationId, RetryConfig config) {
    // 检查断路器
    final circuitBreaker = _getCircuitBreaker(operationId, config);
    if (circuitBreaker != null && !circuitBreaker.canExecute) {
      return false;
    }
    
    return true;
  }
  
  /// 获取或创建断路器
  CircuitBreaker? _getCircuitBreaker(String operationId, RetryConfig config) {
    if (config.circuitBreakerThreshold == null) {
      return null;
    }
    
    return _circuitBreakers.putIfAbsent(
      operationId,
      () => CircuitBreaker(
        operationId,
        CircuitBreakerConfig(
          failureThreshold: config.circuitBreakerThreshold!.inSeconds ~/ 10,
          timeout: config.circuitBreakerThreshold!,
          resetTimeout: Duration(seconds: 30),
        ),
      ),
    );
  }
  
  /// 记录成功
  void _recordSuccess(String operationId, RetryContext context, Duration totalTime) {
    final stats = _statistics[operationId] ?? RetryStatistics(operationId);
    stats.recordAttempt(true, totalTime);
    _statistics[operationId] = stats;
    
    final circuitBreaker = _circuitBreakers[operationId];
    circuitBreaker?.recordSuccess();
  }
  
  /// 记录失败
  void _recordFailure(String operationId, RetryContext context, Object error) {
    final stats = _statistics[operationId] ?? RetryStatistics(operationId);
    stats.recordAttempt(false, context.totalElapsedTime);
    _statistics[operationId] = stats;
    
    final circuitBreaker = _circuitBreakers[operationId];
    circuitBreaker?.recordFailure();
  }
  
  /// 分类错误
  RetryableError _classifyError(Object error) {
    final errorString = error.toString().toLowerCase();
    
    if (error is SocketException) {
      if (errorString.contains('timeout') || errorString.contains('timed out')) {
        return RetryableError.networkTimeout;
      } else if (errorString.contains('connection refused')) {
        return RetryableError.connectionRefused;
      } else if (errorString.contains('network unreachable')) {
        return RetryableError.networkUnreachable;
      }
    } else if (error is TimeoutException) {
      return RetryableError.networkTimeout;
    } else if (error is HttpException) {
      if (errorString.contains('503') || errorString.contains('service unavailable')) {
        return RetryableError.serviceUnavailable;
      } else if (errorString.contains('500')) {
        return RetryableError.serverError;
      } else if (errorString.contains('429')) {
        return RetryableError.rateLimited;
      } else if (errorString.contains('401') || errorString.contains('403')) {
        return RetryableError.authenticationRetryable;
      }
    } else if (error is ServiceUnavailableException) {
      return RetryableError.serviceUnavailable;
    } else if (errorString.contains('dns')) {
      return RetryableError.dnsResolutionFailed;
    }
    
    return RetryableError.unknown;
  }
  
  /// 检查是否可重试
  bool _isRetryable(Object error, RetryableError errorType, RetryConfig config) {
    // 检查异常类型
    if (error is Exception) {
      for (final type in config.retryableExceptionTypes) {
        if (error.runtimeType == type || error is type) {
          return true;
        }
      }
    }
    
    // 检查错误类型
    return config.retryableErrors.contains(errorType);
  }
  
  /// 计算重试延迟
  Duration _calculateDelay(
    RetryContext context,
    RetryConfig config,
    RetryableError errorType,
  ) {
    final attempt = context.currentAttempt;
    
    switch (config.strategy) {
      case RetryStrategy.fixedInterval:
        return config.initialDelay;
        
      case RetryStrategy.linearBackoff:
        final delay = config.initialDelay * attempt;
        return delay.clamp(config.initialDelay, config.maxDelay) as Duration;
        
      case RetryStrategy.exponentialBackoff:
        final baseDelay = config.initialDelay.inMilliseconds;
        final exponentialDelay = (baseDelay * pow(config.backoffMultiplier, attempt - 1)).round();
        final finalDelay = exponentialDelay.clamp(
          config.initialDelay.inMilliseconds,
          config.maxDelay.inMilliseconds,
        );
        
        var duration = Duration(milliseconds: finalDelay);
        
        // 添加抖动
        if (config.enableJitter) {
          duration = _addJitter(duration, config.jitterFactor);
        }
        
        return duration;
        
      case RetryStrategy.jitterBackoff:
        final baseDelay = config.initialDelay.inMilliseconds;
        final delay = (baseDelay * (1 + _random.nextDouble())).round();
        final finalDelay = delay.clamp(
          config.initialDelay.inMilliseconds,
          config.maxDelay.inMilliseconds,
        );
        
        return Duration(milliseconds: finalDelay);
        
      case RetryStrategy.adaptiveRetry:
        return _calculateAdaptiveDelay(context, config, errorType);
        
      case RetryStrategy.compositeRetry:
        // 组合策略：先指数退避，再固定间隔
        if (attempt <= 3) {
          return _calculateDelay(context.copyWith(currentAttempt: attempt), config, errorType);
        } else {
          return config.initialDelay;
        }
    }
  }
  
  /// 添加抖动
  Duration _addJitter(Duration baseDuration, double factor) {
    final jitterRange = baseDuration.inMilliseconds * factor;
    final jitter = (_random.nextDouble() - 0.5) * 2 * jitterRange;
    final finalMilliseconds = (baseDuration.inMilliseconds + jitter).round().clamp(
      baseDuration.inMilliseconds ~/ 2,
      baseDuration.inMilliseconds * 2,
    );
    
    return Duration(milliseconds: finalMilliseconds);
  }
  
  /// 计算自适应延迟
  Duration _calculateAdaptiveDelay(
    RetryContext context,
    RetryConfig config,
    RetryableError errorType,
  ) {
    final params = _adaptiveParams[context.operationId] ?? AdaptiveRetryParams();
    
    // 根据错误类型调整基础延迟
    double baseMultiplier = 1.0;
    switch (errorType) {
      case RetryableError.networkTimeout:
        baseMultiplier = 1.0;
        break;
      case RetryableError.connectionRefused:
        baseMultiplier = 1.5;
        break;
      case RetryableError.networkUnreachable:
        baseMultiplier = 2.0;
        break;
      case RetryableError.serviceUnavailable:
        baseMultiplier = 1.2;
        break;
      case RetryableError.rateLimited:
        baseMultiplier = 3.0;
        break;
      default:
        baseMultiplier = 1.0;
    }
    
    // 调整基于历史成功率的延迟
    final successRate = params.successRate;
    final rateAdjustment = successRate < 0.5 ? 2.0 : (successRate > 0.8 ? 0.8 : 1.0);
    
    final adjustedDelay = config.initialDelay.inMilliseconds * baseMultiplier * rateAdjustment;
    final finalDelay = adjustedDelay.clamp(
      config.initialDelay.inMilliseconds,
      config.maxDelay.inMilliseconds,
    );
    
    return Duration(milliseconds: finalDelay.round());
  }
  
  /// 更新自适应参数
  void _updateAdaptiveParams(String operationId, RetryableError errorType, Duration delay) {
    final params = _adaptiveParams[operationId] ?? AdaptiveRetryParams();
    params.recordDelay(delay.inMilliseconds);
    _adaptiveParams[operationId] = params;
  }
  
  /// 通知重试监听器
  void _notifyRetryListeners(RetryContext context, RetryState state, dynamic result) {
    for (final listener in _retryListeners) {
      try {
        listener(context, state, result);
      } catch (e) {
        _logger.error('通知重试监听器失败: $e');
      }
    }
  }
  
  /// 生成操作ID
  String _generateOperationId() {
    return 'OP_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(1000)}';
  }
  
  /// 添加重试监听器
  void addRetryListener(RetryListener listener) {
    _retryListeners.add(listener);
  }
  
  /// 移除重试监听器
  void removeRetryListener(RetryListener listener) {
    _retryListeners.remove(listener);
  }
  
  /// 获取重试统计
  RetryStatistics? getRetryStatistics(String operationId) {
    return _statistics[operationId];
  }
  
  /// 获取所有统计信息
  Map<String, RetryStatistics> getAllStatistics() {
    return Map.unmodifiable(_statistics);
  }
  
  /// 清除统计信息
  void clearStatistics([String? operationId]) {
    if (operationId != null) {
      _statistics.remove(operationId);
    } else {
      _statistics.clear();
    }
  }
  
  /// 关闭断路器
  void resetCircuitBreaker(String operationId) {
    final circuitBreaker = _circuitBreakers[operationId];
    circuitBreaker?._reset();
  }
  
  /// 获取断路器状态
  CircuitBreakerState? getCircuitBreakerState(String operationId) {
    return _circuitBreakers[operationId]?.state;
  }
  
  /// 更新默认配置
  void updateDefaultConfig(RetryConfig newConfig) {
    _defaultConfig = newConfig;
    _logger.info('更新默认重试配置');
  }
  
  /// 获取默认配置
  RetryConfig get defaultConfig => _defaultConfig;
  
  /// 关闭管理器
  Future<void> dispose() async {
    _logger.info('关闭连接重试管理器');
    
    // 清理断路器
    for (final circuitBreaker in _circuitBreakers.values) {
      circuitBreaker.dispose();
    }
    _circuitBreakers.clear();
    
    // 清理自适应参数
    _adaptiveParams.clear();
    
    // 清理监听器
    _retryListeners.clear();
    
    _logger.info('连接重试管理器已关闭');
  }
}

/// 重试统计
class RetryStatistics {
  final String operationId;
  int _totalAttempts = 0;
  int _successfulAttempts = 0;
  int _failedAttempts = 0;
  final List<Duration> _attemptTimes = [];
  final List<Duration> _delays = [];
  
  RetryStatistics(this.operationId);
  
  void recordAttempt(bool success, Duration time) {
    _totalAttempts++;
    if (success) {
      _successfulAttempts++;
    } else {
      _failedAttempts++;
    }
    _attemptTimes.add(time);
  }
  
  void recordDelay(Duration delay) {
    _delays.add(delay);
  }
  
  double get successRate => _totalAttempts > 0 ? _successfulAttempts / _totalAttempts : 0.0;
  double get failureRate => _totalAttempts > 0 ? _failedAttempts / _totalAttempts : 0.0;
  Duration get averageAttemptTime {
    if (_attemptTimes.isEmpty) return Duration.zero;
    final totalTime = _attemptTimes.reduce((a, b) => a + b);
    return Duration(milliseconds: totalTime.inMilliseconds ~/ _attemptTimes.length);
  }
  Duration get averageDelay {
    if (_delays.isEmpty) return Duration.zero;
    final totalDelay = _delays.reduce((a, b) => a + b);
    return Duration(milliseconds: totalDelay.inMilliseconds ~/ _delays.length);
  }
  int get totalAttempts => _totalAttempts;
  int get successfulAttempts => _successfulAttempts;
  int get failedAttempts => _failedAttempts;
}

/// 自适应重试参数
class AdaptiveRetryParams {
  final List<int> _recentDelays = [];
  final List<bool> _recentOutcomes = [];
  int _consecutiveFailures = 0;
  
  static const int maxHistorySize = 20;
  
  void recordDelay(int delay) {
    _recentDelays.add(delay);
    if (_recentDelays.length > maxHistorySize) {
      _recentDelays.removeAt(0);
    }
  }
  
  void recordOutcome(bool success) {
    _recentOutcomes.add(success);
    if (success) {
      _consecutiveFailures = 0;
    } else {
      _consecutiveFailures++;
    }
    
    if (_recentOutcomes.length > maxHistorySize) {
      _recentOutcomes.removeAt(0);
    }
  }
  
  double get successRate {
    if (_recentOutcomes.isEmpty) return 0.5;
    final successes = _recentOutcomes.where((outcome) => outcome).length;
    return successes / _recentOutcomes.length;
  }
  
  double get averageDelay {
    if (_recentDelays.isEmpty) return 1000.0;
    final total = _recentDelays.reduce((a, b) => a + b);
    return total / _recentDelays.length;
  }
  
  int get consecutiveFailures => _consecutiveFailures;
}

/// 服务不可用异常
class ServiceUnavailableException implements Exception {
  final String message;
  final String? serviceName;
  final Duration? retryAfter;
  
  const ServiceUnavailableException(this.message, [this.serviceName, this.retryAfter]);
  
  @override
  String toString() => 'ServiceUnavailableException: ${serviceName != null ? '[${serviceName!}] ' : ''}$message';
}