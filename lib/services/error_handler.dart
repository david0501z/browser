import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';

/// 错误严重级别
enum ErrorSeverity {
  /// 低级 - 不影响功能
  low,
  /// 中级 - 部分功能受影响
  medium,
  /// 高级 - 核心功能受影响
  high,
  /// 致命 - 应用崩溃
  critical,
}

/// 错误类别
enum ErrorCategory {
  /// 系统错误
  system,
  /// 网络错误
  network,
  /// 配置错误
  configuration,
  /// 权限错误
  permission,
  /// FFI桥接错误
  ffi,
  /// 生命周期错误
  lifecycle,
  /// UI错误
  ui,
  /// 未知错误
  unknown,
}

/// 错误处理策略
enum ErrorHandlingStrategy {
  /// 忽略错误
  ignore,
  /// 记录日志
  log,
  /// 显示通知
  notify,
  /// 重试操作
  retry,
  /// 回退到默认
  fallback,
  /// 关闭应用
  crash,
}

/// 错误事件类型
enum ErrorEventType {
  /// 错误发生
  errorOccurred,
  /// 错误恢复
  errorRecovered,
  /// 重试尝试
  retryAttempted,
  /// 错误报告
  errorReported,
  /// 错误统计更新
  errorStatsUpdated,
}

/// 错误事件
class ErrorEvent {
  final ErrorEventType type;
  final String message;
  final dynamic error;
  final String? stackTrace;
  final ErrorSeverity severity;
  final ErrorCategory category;
  final Map<String, dynamic>? context;
  final DateTime timestamp;

  const ErrorEvent({
    required this.type,
    required this.message,
    this.error,
    this.stackTrace,
    required this.severity,
    required this.category,
    this.context,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'ErrorEvent{type: $type, message: $message, severity: $severity, category: $category, timestamp: $timestamp}';
  }
}

/// 错误统计信息
class ErrorStatistics {
  final Map<ErrorCategory, int> errorCounts;
  final Map<ErrorSeverity, int> severityCounts;
  final int totalErrors;
  final int recoveredErrors;
  final DateTime lastErrorTime;
  final String mostCommonError;

  const ErrorStatistics({
    required this.errorCounts,
    required this.severityCounts,
    required this.totalErrors,
    required this.recoveredErrors,
    required this.lastErrorTime,
    required this.mostCommonError,
  });

  Map<String, dynamic> toJson() => {
    'errorCounts': errorCounts.map((k, v) => MapEntry(k.toString(), v)),
    'severityCounts': severityCounts.map((k, v) => MapEntry(k.toString(), v)),
    'totalErrors': totalErrors,
    'recoveredErrors': recoveredErrors,
    'lastErrorTime': lastErrorTime.toIso8601String(),
    'mostCommonError': mostCommonError,
  };

  factory ErrorStatistics.fromJson(Map<String, dynamic> json) => ErrorStatistics(
    errorCounts: Map.fromEntries(
      (json['errorCounts'] as Map).entries.map(
        (e) => MapEntry(ErrorCategory.values.firstWhere((v) => v.toString() == e.key), e.value as int),
      ),
    ),
    severityCounts: Map.fromEntries(
      (json['severityCounts'] as Map).entries.map(
        (e) => MapEntry(ErrorSeverity.values.firstWhere((v) => v.toString() == e.key), e.value as int),
      ),
    ),
    totalErrors: json['totalErrors'] as int,
    recoveredErrors: json['recoveredErrors'] as int,
    lastErrorTime: DateTime.parse(json['lastErrorTime'] as String),
    mostCommonError: json['mostCommonError'] as String,
  );
}

/// 错误恢复策略
class ErrorRecoveryStrategy {
  final String name;
  final ErrorHandlingStrategy strategy;
  final int maxRetries;
  final Duration retryDelay;
  final List<ErrorCategory> applicableCategories;
  final List<ErrorSeverity> applicableSeverities;
  final Future<bool> Function(dynamic error)? customRecovery;

  const ErrorRecoveryStrategy({
    required this.name,
    required this.strategy,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.applicableCategories = const [],
    this.applicableSeverities = const [],
    this.customRecovery,
  });
}

/// 错误处理配置
class ErrorHandlingConfig {
  final bool enableCrashReporting;
  final bool enableLogToFile;
  final bool enableConsoleOutput;
  final bool enableUserNotification;
  final String logDirectory;
  final int maxLogFiles;
  final Duration logRotationInterval;
  final bool enableAutoRecovery;
  final bool enableErrorStats;
  final Duration errorCooldown;

  const ErrorHandlingConfig({
    this.enableCrashReporting = true,
    this.enableLogToFile = true,
    this.enableConsoleOutput = kDebugMode,
    this.enableUserNotification = true,
    this.logDirectory = 'logs',
    this.maxLogFiles = 5,
    this.logRotationInterval = const Duration(days: 7),
    this.enableAutoRecovery = true,
    this.enableErrorStats = true,
    this.errorCooldown = const Duration(seconds: 5),
  });
}

/// 全局错误处理器
/// 
/// 负责统一处理应用中的所有错误：
/// - 错误分类和严重级别判断
/// - 错误恢复策略执行
/// - 错误日志记录
/// - 错误统计和报告
/// - 用户通知
class ErrorHandler {
  static ErrorHandler? _instance;
  static ErrorHandler get instance => _instance ??= ErrorHandler._();
  
  ErrorHandler._();

  // 事件流控制器
  final StreamController<ErrorEvent> _eventController = StreamController.broadcast();
  Stream<ErrorEvent> get eventStream => _eventController.stream;

  // 错误统计
  final Map<ErrorCategory, int> _errorCounts = {};
  final Map<ErrorSeverity, int> _severityCounts = {};
  int _totalErrors = 0;
  int _recoveredErrors = 0;
  DateTime? _lastErrorTime;
  String _mostCommonError = '';

  // 重试管理
  final Map<String, int> _retryAttempts = {};
  final Map<String, DateTime> _lastErrorTimeByKey = {};

  // 配置
  ErrorHandlingConfig _config = const ErrorHandlingConfig();
  
  // 恢复策略
  final List<ErrorRecoveryStrategy> _recoveryStrategies = [];

  // 错误冷却机制
  final Map<String, DateTime> _errorCooldown = {};

  // 日志文件
  String? _logFilePath;
  IOSink? _logFile;

  // 状态
  bool _isInitialized = false;

  /// 初始化错误处理器
  Future<bool> initialize([ErrorHandlingConfig? config]) async {
    try {
      if (_isInitialized) return true;

      if (config != null) {
        _config = config;
      }

      // 设置恢复策略
      _setupRecoveryStrategies();

      // 初始化日志文件
      if (_config.enableLogToFile) {
        await _initializeLogFile();
      }

      // 设置全局错误处理器
      _setupGlobalErrorHandlers();

      _isInitialized = true;

      _emitEvent(ErrorEvent(
        type: ErrorEventType.errorOccurred,
        message: 'Error handler initialized',
        severity: ErrorSeverity.low,
        category: ErrorCategory.system,
        context: {
          'config': {
            'enableCrashReporting': _config.enableCrashReporting,
            'enableLogToFile': _config.enableLogToFile,
            'enableConsoleOutput': _config.enableConsoleOutput,
            'enableUserNotification': _config.enableUserNotification,
          },
        },
      ));

      return true;
    } catch (e, stackTrace) {
      debugPrint('Failed to initialize error handler: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// 设置恢复策略
  void _setupRecoveryStrategies() {
    _recoveryStrategies.addAll([
      ErrorRecoveryStrategy(
        name: 'network_retry',
        strategy: ErrorHandlingStrategy.retry,
        maxRetries: 3,
        retryDelay: const Duration(seconds: 2),
        applicableCategories: [ErrorCategory.network],
        applicableSeverities: [ErrorSeverity.medium, ErrorSeverity.high],
      ),
      ErrorRecoveryStrategy(
        name: 'ffi_fallback',
        strategy: ErrorHandlingStrategy.fallback,
        maxRetries: 1,
        applicableCategories: [ErrorCategory.ffi],
        applicableSeverities: [ErrorSeverity.high, ErrorSeverity.critical],
      ),
      ErrorRecoveryStrategy(
        name: 'config_reset',
        strategy: ErrorHandlingStrategy.fallback,
        applicableCategories: [ErrorCategory.configuration],
        applicableSeverities: [ErrorSeverity.medium, ErrorSeverity.high],
      ),
      ErrorRecoveryStrategy(
        name: 'permission_notify',
        strategy: ErrorHandlingStrategy.notify,
        applicableCategories: [ErrorCategory.permission],
      ),
    ]);
  }

  /// 初始化日志文件
  Future<void> _initializeLogFile() async {
    try {
      final directory = Directory(_config.logDirectory);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      _logFilePath = '${_config.logDirectory}/error_$timestamp.log';
      _logFile = File(_logFilePath!).openWrite(mode: FileMode.append, encoding: utf8);
    } catch (e, stackTrace) {
      debugPrint('Failed to initialize log file: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// 设置全局错误处理器
  void _setupGlobalErrorHandlers() {
    // Flutter错误处理器
    FlutterError.onError = (FlutterErrorDetails details) {
      handleError(
        'FlutterError',
        details.exception,
        stackTrace: details.stack,
        severity: ErrorSeverity.high,
        category: ErrorCategory.ui,
      );
    };

    // 平台错误处理器
    PlatformDispatcher.instance.onError = (error, stack) {
      handleError(
        'PlatformError',
        error,
        stackTrace: stack,
        severity: ErrorSeverity.critical,
        category: ErrorCategory.system,
      );
      return true; // 防止应用崩溃
    };
  }

  /// 处理错误
  Future<bool> handleError(
    String source,
    dynamic error, {
    StackTrace? stackTrace,
    ErrorSeverity severity = ErrorSeverity.medium,
    ErrorCategory category = ErrorCategory.unknown,
    Map<String, dynamic>? context,
    String? retryKey,
    ErrorHandlingStrategy? customStrategy,
  }) async {
    try {
      // 检查错误冷却
      if (_isInCooldown(source)) {
        return false;
      }

      // 分类错误
      final detectedCategory = category == ErrorCategory.unknown 
        ? _categorizeError(error) 
        : category;
      
      final detectedSeverity = severity == ErrorSeverity.medium
        ? _determineSeverity(error, detectedCategory)
        : severity;

      // 记录错误
      await _logError(source, error, stackTrace, detectedSeverity, detectedCategory, context);

      // 更新统计
      _updateStatistics(detectedCategory, detectedSeverity, error.toString());

      // 发送事件
      _emitEvent(ErrorEvent(
        type: ErrorEventType.errorOccurred,
        message: '$source: ${error.toString()}',
        error: error,
        stackTrace: stackTrace?.toString(),
        severity: detectedSeverity,
        category: detectedCategory,
        context: {
          'source': source,
          ...?context,
        },
      ));

      // 执行恢复策略
      final recovered = await _executeRecoveryStrategy(
        error,
        retryKey,
        customStrategy ?? _getDefaultStrategy(detectedCategory, detectedSeverity),
      );

      if (recovered) {
        _recoveredErrors++;
        _emitEvent(ErrorEvent(
          type: ErrorEventType.errorRecovered,
          message: 'Error recovered: $source',
          severity: detectedSeverity,
          category: detectedCategory,
          context: {
            'originalError': error.toString(),
            'recoveryStrategy': customStrategy?.toString() ?? 'default',
          },
        ));
      }

      // 设置冷却时间
      _setCooldown(source);

      return recovered;
    } catch (e, stackTrace) {
      // 错误处理器本身的错误
      debugPrint('Error in error handler: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// 分类错误
  ErrorCategory _categorizeError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') || 
        errorString.contains('socket') || 
        errorString.contains('connection')) {
      return ErrorCategory.network;
    }
    
    if (errorString.contains('permission') || 
        errorString.contains('access denied')) {
      return ErrorCategory.permission;
    }
    
    if (errorString.contains('ffi') || 
        errorString.contains('dynamic library') ||
        errorString.contains('native function')) {
      return ErrorCategory.ffi;
    }
    
    if (errorString.contains('config') || 
        errorString.contains('setting')) {
      return ErrorCategory.configuration;
    }
    
    if (errorString.contains('lifecycle') || 
        errorString.contains('app state')) {
      return ErrorCategory.lifecycle;
    }
    
    if (errorString.contains('ui') || 
        errorString.contains('widget') ||
        errorString.contains('render')) {
      return ErrorCategory.ui;
    }
    
    return ErrorCategory.system;
  }

  /// 确定错误严重级别
  ErrorSeverity _determineSeverity(dynamic error, ErrorCategory category) {
    final errorString = error.toString().toLowerCase();
    
    // 致命错误
    if (errorString.contains('fatal') || 
        errorString.contains('critical') ||
        category == ErrorCategory.ffi && errorString.contains('failed to load')) {
      return ErrorSeverity.critical;
    }
    
    // 高级错误
    if (errorString.contains('exception') ||
        errorString.contains('failed') ||
        category == ErrorCategory.network) {
      return ErrorSeverity.high;
    }
    
    // 中级错误
    if (errorString.contains('warning') ||
        errorString.contains('timeout') ||
        category == ErrorCategory.configuration) {
      return ErrorSeverity.medium;
    }
    
    // 低级错误
    return ErrorSeverity.low;
  }

  /// 记录错误到日志
  Future<void> _logError(
    String source,
    dynamic error,
    StackTrace? stackTrace,
    ErrorSeverity severity,
    ErrorCategory category,
    Map<String, dynamic>? context,
  ) async {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '''
[$timestamp] [$severity] [$category] $source: $error
${stackTrace ?? ''}
${context != null ? 'Context: ${jsonEncode(context)}' : ''}
---
''';

    // 控制台输出
    if (_config.enableConsoleOutput) {
      debugPrint(logMessage);
    }

    // 文件日志
    if (_config.enableLogToFile && _logFile != null) {
      try {
        _logFile!.write(logMessage);
        await _logFile!.flush();
      } catch (e) {
        debugPrint('Failed to write to log file: $e');
      }
    }

    // 崩溃报告
    if (_config.enableCrashReporting && severity == ErrorSeverity.critical) {
      // 这里可以集成崩溃报告服务（如Firebase Crashlytics）
      debugPrint('Critical error reported: $error');
    }
  }

  /// 更新错误统计
  void _updateStatistics(ErrorCategory category, ErrorSeverity severity, String errorMessage) {
    _errorCounts[category] = (_errorCounts[category] ?? 0) + 1;
    _severityCounts[severity] = (_severityCounts[severity] ?? 0) + 1;
    _totalErrors++;
    _lastErrorTime = DateTime.now();
    
    // 更新最常见错误
    _updateMostCommonError(errorMessage);
    
    // 发送统计更新事件
    _emitEvent(ErrorEvent(
      type: ErrorEventType.errorStatsUpdated,
      message: 'Error statistics updated',
      severity: ErrorSeverity.low,
      category: ErrorCategory.system,
      context: getStatistics().toJson(),
    ));
  }

  /// 更新最常见错误
  void _updateMostCommonError(String errorMessage) {
    final errors = <String, int>{};
    final lines = errorMessage.split('\n');
    
    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isNotEmpty) {
        errors[trimmedLine] = (errors[trimmedLine] ?? 0) + 1;
      }
    }
    
    if (errors.isNotEmpty) {
      _mostCommonError = errors.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    }
  }

  /// 执行恢复策略
  Future<bool> _executeRecoveryStrategy(
    dynamic error,
    String? retryKey,
    ErrorRecoveryStrategy strategy,
  ) async {
    try {
      switch (strategy.strategy) {
        case ErrorHandlingStrategy.ignore:
          return true;
          
        case ErrorHandlingStrategy.log:
          // 已经在_logError中处理
          return true;
          
        case ErrorHandlingStrategy.notify:
          // 显示用户通知
          _showUserNotification(error);
          return true;
          
        case ErrorHandlingStrategy.retry:
          return await _performRetry(error, retryKey, strategy);
          
        case ErrorHandlingStrategy.fallback:
          return await _performFallback(error, strategy);
          
        case ErrorHandlingStrategy.crash:
          // 故意崩溃应用（仅在测试环境）
          if (kDebugMode) {
            throw error;
          }
          return false;
      }
    } catch (e, stackTrace) {
      debugPrint('Recovery strategy failed: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// 执行重试
  Future<bool> _performRetry(
    dynamic error,
    String? retryKey,
    ErrorRecoveryStrategy strategy,
  ) async {
    final key = retryKey ?? error.toString();
    final attempts = _retryAttempts[key] ?? 0;
    
    if (attempts >= strategy.maxRetries) {
      return false;
    }
    
    _retryAttempts[key] = attempts + 1;
    
    _emitEvent(ErrorEvent(
      type: ErrorEventType.retryAttempted,
      message: 'Retry attempt ${attempts + 1}/${strategy.maxRetries}',
      severity: ErrorSeverity.medium,
      category: ErrorCategory.system,
      context: {
        'retryKey': key,
        'attemptNumber': attempts + 1,
        'maxRetries': strategy.maxRetries,
      },
    ));
    
    // 等待延迟
    await Future.delayed(strategy.retryDelay);
    
    // 执行自定义恢复逻辑
    if (strategy.customRecovery != null) {
      return await strategy.customRecovery!(error);
    }
    
    // 默认重试逻辑（这里应该根据具体错误类型实现）
    return true;
  }

  /// 执行回退策略
  Future<bool> _performFallback(
    dynamic error,
    ErrorRecoveryStrategy strategy,
  ) async {
    // 根据错误类别执行不同的回退策略
    final category = _categorizeError(error);
    
    switch (category) {
      case ErrorCategory.configuration:
        // 重置配置到默认值
        return await _resetConfiguration();
      case ErrorCategory.ffi:
        // 回退到模拟实现
        return await _fallbackToMockImplementation();
      case ErrorCategory.network:
        // 切换到离线模式
        return await _switchToOfflineMode();
      default:
        return false;
    }
  }

  /// 重置配置
  Future<bool> _resetConfiguration() async {
    try {
      // 这里应该调用ConfigManager重置配置
      debugPrint('Resetting configuration to defaults');
      return true;
    } catch (e) {
      debugPrint('Failed to reset configuration: $e');
      return false;
    }
  }

  /// 回退到模拟实现
  Future<bool> _fallbackToMockImplementation() async {
    try {
      // 这里应该切换到模拟的FFI实现
      debugPrint('Falling back to mock implementation');
      return true;
    } catch (e) {
      debugPrint('Failed to fallback to mock: $e');
      return false;
    }
  }

  /// 切换到离线模式
  Future<bool> _switchToOfflineMode() async {
    try {
      // 这里应该禁用网络功能
      debugPrint('Switching to offline mode');
      return true;
    } catch (e) {
      debugPrint('Failed to switch to offline mode: $e');
      return false;
    }
  }

  /// 显示用户通知
  void _showUserNotification(dynamic error) {
    if (_config.enableUserNotification) {
      // 这里应该显示用户友好的错误通知
      debugPrint('User notification: ${error.toString()}');
    }
  }

  /// 检查是否在冷却期
  bool _isInCooldown(String source) {
    final lastErrorTime = _lastErrorTimeByKey[source];
    if (lastErrorTime == null) return false;
    
    final elapsed = DateTime.now().difference(lastErrorTime);
    return elapsed < _config.errorCooldown;
  }

  /// 设置冷却时间
  void _setCooldown(String source) {
    _lastErrorTimeByKey[source] = DateTime.now();
  }

  /// 获取默认恢复策略
  ErrorRecoveryStrategy _getDefaultStrategy(ErrorCategory category, ErrorSeverity severity) {
    // 查找匹配的策略
    for (final strategy in _recoveryStrategies) {
      if (strategy.applicableCategories.contains(category) &&
          strategy.applicableSeverities.contains(severity)) {
        return strategy;
      }
    }
    
    // 返回通用策略
    return const ErrorRecoveryStrategy(
      name: 'default',
      strategy: ErrorHandlingStrategy.log,
    );
  }

  /// 清除错误统计
  void clearStatistics() {
    _errorCounts.clear();
    _severityCounts.clear();
    _totalErrors = 0;
    _recoveredErrors = 0;
    _lastErrorTime = null;
    _mostCommonError = '';
    _retryAttempts.clear();
    _lastErrorTimeByKey.clear();
    _errorCooldown.clear();

    _emitEvent(ErrorEvent(
      type: ErrorEventType.errorStatsUpdated,
      message: 'Error statistics cleared',
      severity: ErrorSeverity.low,
      category: ErrorCategory.system,
    ));
  }

  /// 获取错误统计
  ErrorStatistics getStatistics() {
    return ErrorStatistics(
      errorCounts: Map.from(_errorCounts),
      severityCounts: Map.from(_severityCounts),
      totalErrors: _totalErrors,
      recoveredErrors: _recoveredErrors,
      lastErrorTime: _lastErrorTime ?? DateTime.fromMillisecondsSinceEpoch(0),
      mostCommonError: _mostCommonError,
    );
  }

  /// 获取最近的错误日志
  Future<List<String>> getRecentErrorLogs([int limit = 50]) async {
    if (!_config.enableLogToFile || _logFilePath == null) {
      return [];
    }
    
    try {
      final file = File(_logFilePath!);
      if (!await file.exists()) {
        return [];
      }
      
      final lines = await file.readAsLines();
      return lines.length > limit 
        ? lines.sublist(lines.length - limit) 
        : lines;
    } catch (e, stackTrace) {
      debugPrint('Failed to read error logs: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  /// 设置配置
  void updateConfig(ErrorHandlingConfig newConfig) {
    final oldConfig = _config;
    _config = newConfig;
    
    // 如果日志配置发生变化，重新初始化日志
    if (oldConfig.logDirectory != newConfig.logDirectory ||
        oldConfig.enableLogToFile != newConfig.enableLogToFile) {
      _initializeLogFile();
    }
  }

  /// 发送错误事件
  void _emitEvent(ErrorEvent event) {
    _eventController.add(event);
  }

  /// 检查是否已初始化
  bool get isInitialized => _isInitialized;

  /// 获取配置
  ErrorHandlingConfig get config => _config;

  /// 释放资源
  Future<void> dispose() async {
    try {
      // 关闭日志文件
      await _logFile?.flush();
      await _logFile?.close();
      _logFile = null;
      
      // 关闭事件流
      await _eventController.close();
      
      _isInitialized = false;
      _instance = null;
    } catch (e, stackTrace) {
      debugPrint('Error disposing error handler: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }
}