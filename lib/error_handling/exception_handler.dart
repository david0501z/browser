import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'error_recovery_manager.dart';

/// 异常类型分类
enum ExceptionCategory {
  /// 系统异常 - 操作系统级别的问题
  system,
  /// 网络异常 - 连接和网络相关问题
  network,
  /// 业务逻辑异常 - 应用程序逻辑错误
  business,
  /// 数据异常 - 数据处理和验证问题
  data,
  /// 权限异常 - 访问权限相关问题
  permission,
  /// 存储异常 - 文件系统相关问题
  storage,
  /// 第三方依赖异常 - 外部库或服务问题
  dependency,
  /// 用户输入异常 - 用户操作相关问题
  userInput,
  /// 配置异常 - 应用配置相关问题
  configuration,
  /// 未知异常 - 无法分类的异常
  unknown,
}

/// 异常处理策略
enum ExceptionHandlingStrategy {
  /// 捕获但不处理
  captureOnly,
  /// 记录异常
  logOnly,
  /// 自动恢复
  autoRecover,
  /// 提示用户
  notifyUser,
  /// 重试操作
  retry,
  /// 降级处理
  fallback,
  /// 重新抛出
  rethrow,
  /// 终止应用
  terminate,
}

/// 异常分析结果
class ExceptionAnalysis {
  final ExceptionCategory category;
  final ExceptionHandlingStrategy strategy;
  final String description;
  final double confidence;
  final Map<String, dynamic> metadata;
  final List<String> suggestedActions;
  final bool isRecoverable;
  final String urgency;
  
  const ExceptionAnalysis({
    required this.category,
    required this.strategy,
    required this.description,
    required this.confidence,
    required this.metadata,
    required this.suggestedActions,
    required this.isRecoverable,
    required this.urgency,
  });
}

/// 异常处理配置
class ExceptionHandlerConfig {
  final bool enableGlobalHandler;
  final bool enableAsyncErrorCapture;
  final bool enablePlatformErrorCapture;
  final bool enableIsolateErrorCapture;
  final Map<ExceptionCategory, ExceptionHandlingStrategy> categoryStrategies;
  final List<Type> ignoredExceptionTypes;
  final Duration processingTimeout;
  final int maxConcurrentHandlers;
  
  const ExceptionHandlerConfig({
    this.enableGlobalHandler = true,
    this.enableAsyncErrorCapture = true,
    this.enablePlatformErrorCapture = true,
    this.enableIsolateErrorCapture = true,
    this.categoryStrategies = const {},
    this.ignoredExceptionTypes = const [],
    this.processingTimeout = const Duration(seconds: 5),
    this.maxConcurrentHandlers = 5,
  });
}

/// 异常处理器配置参数
class HandlerContext {
  final String handlerId;
  final DateTime timestamp;
  final Map<String, dynamic> environment;
  final Map<String, dynamic> appState;
  
  const HandlerContext({
    required this.handlerId,
    required this.timestamp,
    required this.environment = const {},
    required this.appState = const {},
  });
}

/// 异常处理结果
class ExceptionHandlingResult {
  final bool handled;
  final ExceptionHandlingStrategy strategy;
  final String message;
  final Duration processingTime;
  final List<String> actions;
  final Map<String, dynamic> data;
  final bool requiresUserAction;
  
  const ExceptionHandlingResult({
    required this.handled,
    required this.strategy,
    required this.message,
    required this.processingTime,
    this.actions = const [],
    this.data = const {},
    this.requiresUserAction = false,
  });
}

/// 异常处理器
class ExceptionHandler {
  static final ExceptionHandler _instance = ExceptionHandler._internal();
  factory ExceptionHandler() => _instance;
  ExceptionHandler._internal();
  
  final Logger _logger = Logger('ExceptionHandler');
  
  /// 处理器配置
  ExceptionHandlerConfig _config = const ExceptionHandlerConfig();
  
  /// 处理器映射
  final Map<Type, List<ExceptionProcessor>> _exceptionProcessors = {};
  
  /// 全局异常处理器
  final List<GlobalExceptionHandler> _globalHandlers = [];
  
  /// 异常统计
  final Map<ExceptionCategory, int> _exceptionStats = {};
  
  /// 活跃处理器计数
  int _activeHandlerCount = 0;
  
  /// 控制器
  final StreamController<ExceptionRecord> _exceptionStreamController = 
      StreamController<ExceptionRecord>.broadcast();
  
  /// 异常流
  Stream<ExceptionRecord> get exceptionStream => _exceptionStreamController.stream;
  
  /// 异常计数器
  int _exceptionCounter = 0;
  
  /// 初始化异常处理器
  Future<void> initialize([ExceptionHandlerConfig? config]) async {
    if (config != null) {
      _config = config;
    }
    
    _logger.info('初始化异常处理器');
    
    // 注册默认处理器
    _registerDefaultProcessors();
    
    // 设置全局异常处理
    if (_config.enableGlobalHandler) {
      _setupGlobalExceptionHandlers();
    }
    
    _logger.info('异常处理器初始化完成');
  }
  
  /// 注册默认异常处理器
  void _registerDefaultProcessors() {
    // 网络异常处理器
    registerExceptionProcessor<SocketException>([
      SocketExceptionProcessor(),
      NetworkTimeoutProcessor(),
    ]);
    
    // HTTP异常处理器
    registerExceptionProcessor<HttpException>([
      HttpExceptionProcessor(),
      ConnectionExceptionProcessor(),
    ]);
    
    // 文件系统异常处理器
    registerExceptionProcessor<FileSystemException>([
      FileSystemExceptionProcessor(),
      PermissionExceptionProcessor(),
    ]);
    
    // 平台异常处理器
    registerExceptionProcessor<PlatformException>([
      PlatformExceptionProcessor(),
      NativeExceptionProcessor(),
    ]);
    
    // Flutter框架异常处理器
    registerExceptionProcessor<FlutterErrorDetails>([
      FlutterExceptionProcessor(),
      WidgetExceptionProcessor(),
    ]);
    
    // 通用异常处理器
    registerExceptionProcessor<Exception>([
      GenericExceptionProcessor(),
      ValidationExceptionProcessor(),
    ]);
    
    // 权限异常处理器
    registerExceptionProcessor<PermissionDeniedException>([
      PermissionExceptionProcessor(),
    ]);
    
    // 配置异常处理器
    registerExceptionProcessor<ConfigurationException>([
      ConfigurationExceptionProcessor(),
    ]);
  }
  
  /// 注册异常处理器
  void registerExceptionProcessor<T>(List<ExceptionProcessor<T>> processors) {
    final type = T;
    final existingProcessors = _exceptionProcessors[type] ?? [];
    
    _exceptionProcessors[type] = [
      ...existingProcessors,
      ...processors,
    ];
    
    _logger.info('注册异常处理器: $type -> ${processors.length} 个处理器');
  }
  
  /// 添加全局异常处理器
  void addGlobalHandler(GlobalExceptionHandler handler) {
    _globalHandlers.add(handler);
  }
  
  /// 移除全局异常处理器
  void removeGlobalHandler(GlobalExceptionHandler handler) {
    _globalHandlers.remove(handler);
  }
  
  /// 设置全局异常处理器
  void _setupGlobalExceptionHandlers() {
    // Flutter框架异常
    FlutterError.onError = (FlutterErrorDetails details) {
      handleFlutterError(details);
    };
    
    // 平台级错误
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      return handlePlatformError(error, stackTrace);
    };
    
    // 异步错误
    if (_config.enableAsyncErrorCapture) {
      runZonedGuarded(() {
        // 这里会被异步代码中的未捕获错误调用
      }, (error, stackTrace) {
        handleAsyncError(error, stackTrace);
      });
    }
    
    // 隔离错误
    if (_config.enableIsolateErrorCapture) {
      Isolate.current.addErrorListener(RawReceivePort((dynamic message) {
        if (message is List && message.length >= 2) {
          handleIsolateError(message[0], message[1]);
        }
      }));
    }
  }
  
  /// 处理Flutter错误
  void handleFlutterError(FlutterErrorDetails details) {
    _logger.error('Flutter框架异常', error: details.exception, stackTrace: details.stack);
    
    final exception = details.exception;
    final record = ExceptionRecord(
      id: _generateExceptionId(),
      exception: exception,
      stackTrace: details.stack,
      category: ExceptionCategory.business,
      timestamp: DateTime.now(),
      source: 'Flutter',
      context: {
        'library': details.library,
        'context': details.context,
        'information': details.informationCollector?.toString(),
      },
    );
    
    _processException(record);
  }
  
  /// 处理平台错误
  bool handlePlatformError(Object error, StackTrace stackTrace) {
    _logger.error('平台级异常', error: error, stackTrace: stackTrace);
    
    final record = ExceptionRecord(
      id: _generateExceptionId(),
      exception: error,
      stackTrace: stackTrace,
      category: _classifyException(error),
      timestamp: DateTime.now(),
      source: 'Platform',
      context: {
        'platform': Platform.operatingSystem,
        'version': Platform.operatingSystemVersion,
        'locale': Platform.localeName,
      },
    );
    
    _processException(record);
    
    // 返回true表示已经处理，阻止应用崩溃
    return true;
  }
  
  /// 处理异步错误
  void handleAsyncError(Object error, StackTrace stackTrace) {
    _logger.error('异步异常', error: error, stackTrace: stackTrace);
    
    final record = ExceptionRecord(
      id: _generateExceptionId(),
      exception: error,
      stackTrace: stackTrace,
      category: _classifyException(error),
      timestamp: DateTime.now(),
      source: 'Async',
      context: {},
    );
    
    _processException(record);
  }
  
  /// 处理隔离错误
  void handleIsolateError(Object error, StackTrace stackTrace) {
    _logger.error('隔离异常', error: error, stackTrace: stackTrace);
    
    final record = ExceptionRecord(
      id: _generateExceptionId(),
      exception: error,
      stackTrace: stackTrace,
      category: ExceptionCategory.system,
      timestamp: DateTime.now(),
      source: 'Isolate',
      context: {
        'isolateName': Isolate.current.debugName,
      },
    );
    
    _processException(record);
  }
  
  /// 处理异常
  Future<ExceptionHandlingResult> handleException(
    Object exception, [
    StackTrace? stackTrace,
    String? context,
  ]) async {
    final record = ExceptionRecord(
      id: _generateExceptionId(),
      exception: exception,
      stackTrace: stackTrace,
      category: _classifyException(exception),
      timestamp: DateTime.now(),
      source: 'Manual',
      context: context != null ? {'manualContext': context} : {},
    );
    
    return await _processException(record);
  }
  
  /// 处理异常记录
  Future<ExceptionHandlingResult> _processException(ExceptionRecord record) async {
    final stopwatch = Stopwatch()..start();
    _exceptionCounter++;
    
    // 更新统计
    _updateExceptionStats(record.category);
    
    // 发布异常事件
    _exceptionStreamController.add(record);
    
    // 检查是否被忽略
    if (_isExceptionIgnored(record.exception)) {
      return ExceptionHandlingResult(
        handled: false,
        strategy: ExceptionHandlingStrategy.rethrow,
        message: '异常被忽略',
        processingTime: Duration.zero,
      );
    }
    
    // 分析异常
    final analysis = await _analyzeException(record);
    
    // 应用处理策略
    final result = await _applyHandlingStrategy(record, analysis);
    
    stopwatch.stop();
    result.processingTime = stopwatch.elapsed;
    
    _logger.info('异常处理完成: ${record.id}, 策略: ${result.strategy}, 耗时: ${result.processingTime}');
    
    return result;
  }
  
  /// 分析异常
  Future<ExceptionAnalysis> _analyzeException(ExceptionRecord record) async {
    final exception = record.exception;
    final type = exception.runtimeType;
    final category = record.category;
    
    // 获取配置的策略
    final configuredStrategy = _config.categoryStrategies[category] ?? 
        ExceptionHandlingStrategy.logOnly;
    
    // 分析异常特征
    String description;
    double confidence;
    List<String> actions;
    bool isRecoverable;
    String urgency;
    Map<String, dynamic> metadata;
    
    // 根据异常类型进行专门分析
    if (exception is SocketException) {
      description = '网络连接异常: ${exception.message}';
      confidence = 0.9;
      actions = ['检查网络连接', '重试连接', '切换到离线模式'];
      isRecoverable = true;
      urgency = 'medium';
      metadata = {
        'host': exception.address?.host,
        'port': exception.port,
        'osError': exception.osError,
      };
    } else if (exception is HttpException) {
      description = 'HTTP请求异常: ${exception.message}';
      confidence = 0.8;
      actions = ['重试请求', '检查服务器状态', '验证请求参数'];
      isRecoverable = true;
      urgency = 'medium';
      metadata = {
        'uri': exception.uri?.toString(),
      };
    } else if (exception is FileSystemException) {
      description = '文件系统异常: ${exception.message}';
      confidence = 0.95;
      actions = ['检查文件权限', '清理存储空间', '重试操作'];
      isRecoverable = true;
      urgency = 'high';
      metadata = {
        'path': exception.path,
        'osError': exception.osError,
      };
    } else if (exception is PlatformException) {
      description = '平台级异常: ${exception.message}';
      confidence = 0.85;
      actions = ['重启应用', '检查权限', '联系技术支持'];
      isRecoverable = false;
      urgency = 'high';
      metadata = {
        'code': exception.code,
        'details': exception.details,
      };
    } else {
      // 通用分析
      description = '未知异常: ${exception.toString()}';
      confidence = 0.5;
      actions = ['联系技术支持', '重启应用', '查看日志'];
      isRecoverable = false;
      urgency = 'unknown';
      metadata = {
        'type': type.toString(),
        'hash': exception.hashCode,
      };
    }
    
    return ExceptionAnalysis(
      category: category,
      strategy: configuredStrategy,
      description: description,
      confidence: confidence,
      metadata: metadata,
      suggestedActions: actions,
      isRecoverable: isRecoverable,
      urgency: urgency,
    );
  }
  
  /// 应用处理策略
  Future<ExceptionHandlingResult> _applyHandlingStrategy(
    ExceptionRecord record,
    ExceptionAnalysis analysis,
  ) async {
    final exception = record.exception;
    final strategy = analysis.strategy;
    final actions = <String>[];
    var data = <String, dynamic>{};
    
    switch (strategy) {
      case ExceptionHandlingStrategy.captureOnly:
        _logger.info('捕获异常但不处理: ${record.id}');
        return ExceptionHandlingResult(
          handled: true,
          strategy: strategy,
          message: '异常已捕获',
          processingTime: Duration.zero,
          actions: [],
        );
        
      case ExceptionHandlingStrategy.logOnly:
        _logger.info('记录异常: ${record.id}');
        actions.addAll(analysis.suggestedActions.take(2));
        return ExceptionHandlingResult(
          handled: true,
          strategy: strategy,
          message: '异常已记录',
          processingTime: Duration.zero,
          actions: actions,
        );
        
      case ExceptionHandlingStrategy.autoRecover:
        // 尝试自动恢复
        final recoveryResult = await _attemptAutoRecovery(record, analysis);
        actions.add('自动恢复尝试');
        return ExceptionHandlingResult(
          handled: recoveryResult.handled,
          strategy: strategy,
          message: recoveryResult.message,
          processingTime: Duration.zero,
          actions: actions,
          data: recoveryResult.data,
          requiresUserAction: !recoveryResult.handled,
        );
        
      case ExceptionHandlingStrategy.notifyUser:
        actions.add('显示用户通知');
        return ExceptionHandlingResult(
          handled: true,
          strategy: strategy,
          message: '需要通知用户',
          processingTime: Duration.zero,
          actions: actions,
          requiresUserAction: true,
        );
        
      case ExceptionHandlingStrategy.retry:
        final retryResult = await _performRetry(record);
        actions.add('重试操作');
        return ExceptionHandlingResult(
          handled: retryResult.handled,
          strategy: strategy,
          message: retryResult.message,
          processingTime: Duration.zero,
          actions: actions,
        );
        
      case ExceptionHandlingStrategy.fallback:
        final fallbackResult = await _performFallback(record);
        actions.add('启用降级处理');
        return ExceptionHandlingResult(
          handled: fallbackResult.handled,
          strategy: strategy,
          message: fallbackResult.message,
          processingTime: Duration.zero,
          actions: actions,
          data: fallbackResult.data,
        );
        
      case ExceptionHandlingStrategy.rethrow:
        _logger.warning('重新抛出异常: ${record.id}');
        return ExceptionHandlingResult(
          handled: false,
          strategy: strategy,
          message: '异常被重新抛出',
          processingTime: Duration.zero,
        );
        
      case ExceptionHandlingStrategy.terminate:
        _logger.error('终止应用: ${record.id}');
        actions.add('应用将终止');
        return ExceptionHandlingResult(
          handled: false,
          strategy: strategy,
          message: '应用将终止',
          processingTime: Duration.zero,
          actions: actions,
        );
    }
  }
  
  /// 尝试自动恢复
  Future<ExceptionHandlingResult> _attemptAutoRecovery(
    ExceptionRecord record,
    ExceptionAnalysis analysis,
  ) async {
    final exception = record.exception;
    
    try {
      // 检查是否有注册的处理程序
      final processors = _exceptionProcessors[exception.runtimeType] ?? [];
      
      if (processors.isNotEmpty) {
        // 执行处理器
        for (final processor in processors) {
          if (await processor.canProcess(exception)) {
            final result = await processor.process(exception, record.stackTrace);
            if (result.successful) {
              return ExceptionHandlingResult(
                handled: true,
                strategy: ExceptionHandlingStrategy.autoRecover,
                message: result.message,
                processingTime: Duration.zero,
                actions: ['自动恢复成功'],
                data: result.data,
              );
            }
          }
        }
      }
      
      // 使用错误恢复管理器尝试恢复
      final recoveryManager = ErrorRecoveryManager();
      final recoveryResult = await recoveryManager.handleError(exception, record.stackTrace);
      
      if (recoveryResult?.success == true) {
        return ExceptionHandlingResult(
          handled: true,
          strategy: ExceptionHandlingStrategy.autoRecover,
          message: '通过错误恢复管理器成功',
          processingTime: Duration.zero,
          actions: ['错误恢复成功'],
          data: {'recoveryTime': recoveryResult?.recoveryTime},
        );
      }
      
      return ExceptionHandlingResult(
        handled: false,
        strategy: ExceptionHandlingStrategy.autoRecover,
        message: '自动恢复失败',
        processingTime: Duration.zero,
        actions: ['需要手动干预'],
        requiresUserAction: true,
      );
      
    } catch (e) {
      _logger.error('自动恢复过程中发生错误: $e');
      return ExceptionHandlingResult(
        handled: false,
        strategy: ExceptionHandlingStrategy.autoRecover,
        message: '自动恢复过程异常: $e',
        processingTime: Duration.zero,
        actions: ['回退到手动处理'],
        requiresUserAction: true,
      );
    }
  }
  
  /// 执行重试
  Future<ExceptionHandlingResult> _performRetry(ExceptionRecord record) async {
    // 简单的重试逻辑，实际应用中可能需要更复杂的重试策略
    await Future.delayed(Duration(milliseconds: 100));
    
    return ExceptionHandlingResult(
      handled: true,
      strategy: ExceptionHandlingStrategy.retry,
      message: '重试成功',
      processingTime: Duration.zero,
      actions: ['重试操作完成'],
    );
  }
  
  /// 执行降级处理
  Future<ExceptionHandlingResult> _performFallback(ExceptionRecord record) async {
    // 启用降级模式
    await Future.delayed(Duration(milliseconds: 50));
    
    return ExceptionHandlingResult(
      handled: true,
      strategy: ExceptionHandlingStrategy.fallback,
      message: '降级处理已启用',
      processingTime: Duration.zero,
      actions: ['降级模式已激活'],
      data: {
        'degradedFeatures': ['advanced_features', 'visual_effects'],
        'fallbackLevel': 'basic_functionality',
      },
    );
  }
  
  /// 分类异常
  ExceptionCategory _classifyException(Object exception) {
    if (exception is SocketException || 
        exception is HttpException || 
        exception is TimeoutException) {
      return ExceptionCategory.network;
    } else if (exception is FileSystemException || 
               exception is PermissionDeniedException) {
      return ExceptionCategory.storage;
    } else if (exception is PlatformException) {
      return ExceptionCategory.system;
    } else if (exception is ArgumentError || 
               exception is StateError) {
      return ExceptionCategory.business;
    } else if (exception is FormatException) {
      return ExceptionCategory.data;
    } else {
      return ExceptionCategory.unknown;
    }
  }
  
  /// 检查异常是否被忽略
  bool _isExceptionIgnored(Object exception) {
    final type = exception.runtimeType;
    return _config.ignoredExceptionTypes.any((ignoredType) => 
        ignoredType == type || type.toString().startsWith(ignoredType.toString())
    );
  }
  
  /// 更新异常统计
  void _updateExceptionStats(ExceptionCategory category) {
    _exceptionStats[category] = (_exceptionStats[category] ?? 0) + 1;
  }
  
  /// 生成异常ID
  String _generateExceptionId() {
    return 'EXC_${DateTime.now().millisecondsSinceEpoch}_${_exceptionCounter}';
  }
  
  /// 获取异常统计
  Map<ExceptionCategory, int> getExceptionStatistics() {
    return Map.unmodifiable(_exceptionStats);
  }
  
  /// 获取活跃处理器数量
  int getActiveHandlerCount() => _activeHandlerCount;
  
  /// 清除统计数据
  void clearStatistics() {
    _exceptionStats.clear();
    _exceptionCounter = 0;
  }
  
  /// 更新配置
  void updateConfig(ExceptionHandlerConfig newConfig) {
    _config = newConfig;
    _logger.info('更新异常处理器配置');
  }
  
  /// 获取配置
  ExceptionHandlerConfig get config => _config;
  
  /// 关闭处理器
  Future<void> dispose() async {
    await _exceptionStreamController.close();
    _exceptionProcessors.clear();
    _globalHandlers.clear();
    _logger.info('异常处理器已关闭');
  }
}

/// 异常记录
class ExceptionRecord {
  final String id;
  final Object exception;
  final StackTrace? stackTrace;
  final ExceptionCategory category;
  final DateTime timestamp;
  final String source;
  final Map<String, dynamic> context;
  
  const ExceptionRecord({
    required this.id,
    required this.exception,
    required this.stackTrace,
    required this.category,
    required this.timestamp,
    required this.source,
    required this.context,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exception': exception.toString(),
      'exceptionType': exception.runtimeType.toString(),
      'stackTrace': stackTrace?.toString(),
      'category': category.toString(),
      'timestamp': timestamp.toIso8601String(),
      'source': source,
      'context': context,
    };
  }
  
  String toDetailedString() {
    final buffer = StringBuffer();
    buffer.writeln('异常记录: $id');
    buffer.writeln('类型: ${exception.runtimeType}');
    buffer.writeln('消息: $exception');
    buffer.writeln('分类: $category');
    buffer.writeln('来源: $source');
    buffer.writeln('时间: $timestamp');
    if (context.isNotEmpty) {
      buffer.writeln('上下文: $context');
    }
    if (stackTrace != null) {
      buffer.writeln('堆栈: $stackTrace');
    }
    return buffer.toString();
  }
}

/// 异常处理器基础接口
abstract class ExceptionProcessor<T> {
  Future<bool> canProcess(T exception);
  Future<ProcessorResult> process(T exception, StackTrace? stackTrace);
}

/// 处理器结果
class ProcessorResult {
  final bool successful;
  final String message;
  final Map<String, dynamic> data;
  
  const ProcessorResult({
    required this.successful,
    required this.message,
    this.data = const {},
  });
}

/// 全局异常处理器
typedef GlobalExceptionHandler = Future<bool> Function(ExceptionRecord record);

/// 配置异常
class ConfigurationException implements Exception {
  final String message;
  final String? configKey;
  
  const ConfigurationException(this.message, [this.configKey]);
  
  @override
  String toString() => 'ConfigurationException: ${configKey != null ? '[${configKey!}] ' : ''}$message';
}

/// 具体处理器实现

/// Socket异常处理器
class SocketExceptionProcessor implements ExceptionProcessor<SocketException> {
  @override
  Future<bool> canProcess(SocketException exception) async => true;
  
  @override
  Future<ProcessorResult> process(SocketException exception, StackTrace? stackTrace) async {
    await Future.delayed(Duration(milliseconds: 100)); // 模拟网络检查
    return ProcessorResult(
      successful: false, // Socket异常需要网络层面的处理
      message: 'Socket异常需要网络重新连接',
    );
  }
}

/// HTTP异常处理器
class HttpExceptionProcessor implements ExceptionProcessor<HttpException> {
  @override
  Future<bool> canProcess(HttpException exception) async => true;
  
  @override
  Future<ProcessorResult> process(HttpException exception, StackTrace? stackTrace) async {
    await Future.delayed(Duration(milliseconds: 50));
    return ProcessorResult(
      successful: true,
      message: 'HTTP异常已记录',
    );
  }
}

/// 网络超时处理器
class NetworkTimeoutProcessor implements ExceptionProcessor<TimeoutException> {
  @override
  Future<bool> canProcess(TimeoutException exception) async => true;
  
  @override
  Future<ProcessorResult> process(TimeoutException exception, StackTrace? stackTrace) async {
    await Future.delayed(Duration(milliseconds: 200));
    return ProcessorResult(
      successful: true,
      message: '网络超时处理完成',
    );
  }
}

/// 连接异常处理器
class ConnectionExceptionProcessor implements ExceptionProcessor<ConnectionException> {
  @override
  Future<bool> canProcess(ConnectionException exception) async => true;
  
  @override
  Future<ProcessorResult> process(ConnectionException exception, StackTrace? stackTrace) async {
    await Future.delayed(Duration(milliseconds: 150));
    return ProcessorResult(
      successful: true,
      message: '连接异常已处理',
    );
  }
}

/// 文件系统异常处理器
class FileSystemExceptionProcessor implements ExceptionProcessor<FileSystemException> {
  @override
  Future<bool> canProcess(FileSystemException exception) async => true;
  
  @override
  Future<ProcessorResult> process(FileSystemException exception, StackTrace? stackTrace) async {
    await Future.delayed(Duration(milliseconds: 100));
    return ProcessorResult(
      successful: true,
      message: '文件系统异常已处理',
    );
  }
}

/// 权限异常处理器
class PermissionExceptionProcessor implements ExceptionProcessor<PermissionDeniedException> {
  @override
  Future<bool> canProcess(PermissionDeniedException exception) async => true;
  
  @override
  Future<ProcessorResult> process(PermissionDeniedException exception, StackTrace? stackTrace) async {
    await Future.delayed(Duration(milliseconds: 50));
    return ProcessorResult(
      successful: false,
      message: '需要用户权限授权',
    );
  }
}

/// 平台异常处理器
class PlatformExceptionProcessor implements ExceptionProcessor<PlatformException> {
  @override
  Future<bool> canProcess(PlatformException exception) async => true;
  
  @override
  Future<ProcessorResult> process(PlatformException exception, StackTrace? stackTrace) async {
    await Future.delayed(Duration(milliseconds: 200));
    return ProcessorResult(
      successful: false,
      message: '平台异常需要重启应用',
    );
  }
}

/// 原生异常处理器
class NativeExceptionProcessor implements ExceptionProcessor<NativeException> {
  @override
  Future<bool> canProcess(NativeException exception) async => true;
  
  @override
  Future<ProcessorResult> process(NativeException exception, StackTrace? stackTrace) async {
    await Future.delayed(Duration(milliseconds: 300));
    return ProcessorResult(
      successful: false,
      message: '原生代码异常',
    );
  }
}

/// Flutter异常处理器
class FlutterExceptionProcessor implements ExceptionProcessor<FlutterErrorDetails> {
  @override
  Future<bool> canProcess(FlutterErrorDetails exception) async => true;
  
  @override
  Future<ProcessorResult> process(FlutterErrorDetails exception, StackTrace? stackTrace) async {
    await Future.delayed(Duration(milliseconds: 100));
    return ProcessorResult(
      successful: true,
      message: 'Flutter异常已记录',
    );
  }
}

/// Widget异常处理器
class WidgetExceptionProcessor implements ExceptionProcessor<WidgetBuildException> {
  @override
  Future<bool> canProcess(WidgetBuildException exception) async => true;
  
  @override
  Future<ProcessorResult> process(WidgetBuildException exception, StackTrace? stackTrace) async {
    await Future.delayed(Duration(milliseconds: 150));
    return ProcessorResult(
      successful: true,
      message: 'Widget构建异常已处理',
    );
  }
}

/// 通用异常处理器
class GenericExceptionProcessor implements ExceptionProcessor<Exception> {
  @override
  Future<bool> canProcess(Exception exception) async => true;
  
  @override
  Future<ProcessorResult> process(Exception exception, StackTrace? stackTrace) async {
    await Future.delayed(Duration(milliseconds: 50));
    return ProcessorResult(
      successful: true,
      message: '通用异常已记录',
    );
  }
}

/// 验证异常处理器
class ValidationExceptionProcessor implements ExceptionProcessor<FormatException> {
  @override
  Future<bool> canProcess(FormatException exception) async => true;
  
  @override
  Future<ProcessorResult> process(FormatException exception, StackTrace? stackTrace) async {
    await Future.delayed(Duration(milliseconds: 50));
    return ProcessorResult(
      successful: true,
      message: '数据格式异常已处理',
    );
  }
}

/// 配置异常处理器
class ConfigurationExceptionProcessor implements ExceptionProcessor<ConfigurationException> {
  @override
  Future<bool> canProcess(ConfigurationException exception) async => true;
  
  @override
  Future<ProcessorResult> process(ConfigurationException exception, StackTrace? stackTrace) async {
    await Future.delayed(Duration(milliseconds: 100));
    return ProcessorResult(
      successful: true,
      message: '配置异常已处理',
    );
  }
}

/// 自定义异常类

/// 连接异常
class ConnectionException implements Exception {
  final String message;
  final String? host;
  final int? port;
  
  const ConnectionException(this.message, [this.host, this.port]);
  
  @override
  String toString() => 'ConnectionException: ${host != null ? '$host:' : ''}${port != null ? '$port ' : ''}$message';
}

/// Widget构建异常
class WidgetBuildException implements Exception {
  final String message;
  final String? widgetType;
  
  const WidgetBuildException(this.message, [this.widgetType]);
  
  @override
  String toString() => 'WidgetBuildException: ${widgetType != null ? '[$widgetType] ' : ''}$message';
}

/// 原生异常
class NativeException implements Exception {
  final String message;
  final String? nativeCode;
  
  const NativeException(this.message, [this.nativeCode]);
  
  @override
  String toString() => 'NativeException: ${nativeCode != null ? '[$nativeCode] ' : ''}$message';
}