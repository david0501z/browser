/// 日志系统完整包
/// 提供完整的日志记录、调试、监控和错误收集功能
/// 
/// 主要组件：
/// - Logger: 核心日志系统
/// - DebugService: 调试服务和工具
/// - PerformanceMonitor: 性能监控
/// - ErrorCollector: 错误收集和崩溃报告
/// - DebugUI: 调试界面
/// - LogFileManager: 日志文件管理
/// 
/// 使用示例：
/// ```dart
/// import 'package:your_app/logging/index.dart';
/// 
/// // 初始化日志系统
/// final logger = Logger();
/// 
/// // 添加输出器
/// logger.addSink(ConsoleSink());
/// logger.addSink(FileSink(filePath: 'logs/app.log'));
/// 
/// // 记录日志
/// logger.info('应用启动', source: 'App', tags: ['startup']);
/// logger.error('操作失败', source: 'UserService', exception: e, stackTrace: stack);
/// 
/// // 启用调试模式
/// final debugService = DebugService();
/// debugService.enable();
/// 
/// // 启用性能监控
/// final performanceMonitor = PerformanceMonitor();
/// performanceMonitor.enable();
/// 
/// // 记录性能数据
/// performanceMonitor.recordResponseTime('API调用', Duration(milliseconds: 250));
/// 
/// // 启用错误收集
/// final errorCollector = ErrorCollector();
/// errorCollector.enable();
/// 
/// // 显示调试界面
/// Navigator.push(context, MaterialPageRoute(
///   builder: (context) => const DebugPage()
/// ));
/// ```

// Core logging components
export 'log_level.dart';
export 'log_entry.dart';
export 'log_formatter.dart';
export 'log_sink.dart';
export 'logger.dart';
export 'log_filter.dart';

// Management and monitoring
export 'log_file_manager.dart';
export 'performance_monitor.dart';
export 'debug_service.dart';

// Error handling
export 'error_reporter.dart';

// UI components
export 'debug_ui.dart';

/// 日志系统管理器
/// 提供统一的日志系统初始化和管理
class LoggingSystem {
  static final LoggingSystem _instance = LoggingSystem._internal();
  factory LoggingSystem() => _instance;
  LoggingSystem._internal();

  late final Logger _logger;
  late final DebugService _debugService;
  late final PerformanceMonitor _performanceMonitor;
  late final ErrorCollector _errorCollector;
  late final LogFileManager _logFileManager;
  
  bool _initialized = false;

  /// 获取Logger实例
  Logger get logger => _logger;

  /// 获取DebugService实例
  DebugService get debugService => _debugService;

  /// 获取PerformanceMonitor实例
  PerformanceMonitor get performanceMonitor => _performanceMonitor;

  /// 获取ErrorCollector实例
  ErrorCollector get errorCollector => _errorCollector;

  /// 获取LogFileManager实例
  LogFileManager get logFileManager => _logFileManager;

  /// 初始化日志系统
  void initialize({
    bool enableDebug = false,
    bool enablePerformance = true,
    bool enableErrorCollection = true,
    String? logDirectory,
    LogLevel minimumLogLevel = LogLevel.info,
    bool addConsoleSink = true,
    bool addFileSink = false,
  }) {
    if (_initialized) {
      return;
    }

    // 初始化核心组件
    _logger = Logger();
    _debugService = DebugService();
    _performanceMonitor = PerformanceMonitor();
    _errorCollector = ErrorCollector();
    
    if (logDirectory != null) {
      _logFileManager = LogFileManager(
        LogFileManagerConfig(logDirectory: logDirectory)
      );
    }

    // 设置日志级别
    _logger.setFilter(LogFilter(minimumLevel: minimumLogLevel));

    // 添加输出器
    if (addConsoleSink) {
      _logger.addSink(ConsoleSink());
    }

    if (addFileSink && logDirectory != null) {
      final fileSink = FileSink(
        filePath: '$logDirectory/app.log',
        flushInterval: const Duration(seconds: 1),
      );
      _logger.addSink(fileSink);
    }

    // 启用各组件
    if (enableDebug) {
      _debugService.enable();
    }

    if (enablePerformance) {
      _performanceMonitor.enable();
    }

    if (enableErrorCollection) {
      _errorCollector.enable();
    }

    _initialized = true;
    
    _logger.info('日志系统初始化完成', source: 'LoggingSystem', tags: ['init']);
  }

  /// 检查是否已初始化
  bool get isInitialized => _initialized;

  /// 关闭日志系统
  Future<void> dispose() async {
    if (!_initialized) return;

    _logger.info('正在关闭日志系统...', source: 'LoggingSystem');

    await _logger.dispose();
    _debugService.dispose();
    _performanceMonitor.dispose();
    _errorCollector.dispose();
    _logFileManager.dispose();

    _initialized = false;
  }

  /// 获取系统状态信息
  Map<String, dynamic> getSystemStatus() {
    if (!_initialized) {
      return {'status': 'not_initialized'};
    }

    return {
      'status': 'active',
      'components': {
        'logger': {
          'enabled': true,
          'logCount': _logger.logEntries.length,
          'sinks': _logger.sinks.length,
        },
        'debug': {
          'enabled': _debugService.config.enabled,
        },
        'performance': {
          'enabled': _performanceMonitor.config.enabled,
          'metrics': _performanceMonitor.statistics.getAllStatistics(),
        },
        'errorCollection': {
          'enabled': _errorCollector.config.enabled,
          'errorCount': _errorCollector.getErrorReports().length,
          'crashCount': _errorCollector.getCrashInfos().length,
        },
        'fileManager': {
          'initialized': true,
          'fileCount': _logFileManager.getAllLogFiles().length,
        },
      },
    };
  }
}

/// 便捷函数：快速初始化日志系统
void initLogging({
  bool enableDebug = false,
  bool enablePerformance = true,
  bool enableErrorCollection = true,
  String? logDirectory,
  LogLevel minimumLogLevel = LogLevel.info,
  bool addConsoleSink = true,
  bool addFileSink = false,
}) {
  LoggingSystem().initialize(
    enableDebug: enableDebug,
    enablePerformance: enablePerformance,
    enableErrorCollection: enableErrorCollection,
    logDirectory: logDirectory,
    minimumLogLevel: minimumLogLevel,
    addConsoleSink: addConsoleSink,
    addFileSink: addFileSink,
  );
}

/// 便捷函数：获取Logger实例
Logger get logger => LoggingSystem().logger;

/// 便捷函数：获取DebugService实例
DebugService get debugService => LoggingSystem().debugService;

/// 便捷函数：获取PerformanceMonitor实例
PerformanceMonitor get performanceMonitor => LoggingSystem().performanceMonitor;

/// 便捷函数：获取ErrorCollector实例
ErrorCollector get errorCollector => LoggingSystem().errorCollector;

/// 便捷函数：显示调试页面
void showDebugPage(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const DebugPage(),
    ),
  );
}

/// 便捷函数：记录应用启动事件
void logAppStartup() {
  logger.info('应用启动', 
      source: 'AppStartup',
      tags: ['startup', 'app_lifecycle'],
      context: {
        'timestamp': DateTime.now().toIso8601String(),
        'platform': 'Flutter',
        'environment': 'Production',
      });
}

/// 便捷函数：记录应用关闭事件
void logAppShutdown() {
  logger.info('应用关闭', 
      source: 'AppShutdown',
      tags: ['shutdown', 'app_lifecycle']);
}

/// 便捷函数：记录用户操作
void logUserAction(String action, [Map<String, dynamic>? context]) {
  logger.info('用户操作: $action', 
      source: 'UserAction',
      tags: ['user_action', 'ui'],
      context: context);
}

/// 便捷函数：记录性能度量
void measureAndLog(
  String operation,
  dynamic Function() function, {
  LogLevel logLevel = LogLevel.debug,
  List<String>? tags,
  Map<String, dynamic>? context,
}) {
  final stopwatch = Stopwatch()..start();
  
  try {
    final result = function();
    stopwatch.stop();
    
    final duration = stopwatch.elapsed;
    final metric = {
      'operation': operation,
      'duration_ms': duration.inMilliseconds,
      'success': true,
      ...?context,
    };
    
    final logMessage = '$operation 完成，耗时: ${duration.inMilliseconds}ms';
    
    switch (logLevel) {
      case LogLevel.verbose:
        logger.verbose(logMessage, source: 'Performance', tags: tags, context: metric);
        break;
      case LogLevel.debug:
        logger.debug(logMessage, source: 'Performance', tags: tags, context: metric);
        break;
      case LogLevel.info:
        logger.info(logMessage, source: 'Performance', tags: tags, context: metric);
        break;
      case LogLevel.warning:
        logger.warning(logMessage, source: 'Performance', tags: tags, context: metric);
        break;
      case LogLevel.error:
        logger.error(logMessage, source: 'Performance', tags: tags, context: metric);
        break;
      case LogLevel.critical:
        logger.critical(logMessage, source: 'Performance', tags: tags, context: metric);
        break;
    }
    
    // 同时记录到性能监控器
    performanceMonitor.recordResponseTime(operation, duration, tags: tags);
    
    return result;
  } catch (e, stackTrace) {
    stopwatch.stop();
    
    logger.error('$operation 失败', 
        exception: e, 
        stackTrace: stackTrace,
        source: 'Performance',
        tags: [...?tags, 'error'],
        context: {
          'operation': operation,
          'duration_ms': stopwatch.elapsedMilliseconds,
          'success': false,
          ...?context,
        });
    
    rethrow;
  }
}

/// 便捷函数：异步性能度量
Future<T> measureAsyncAndLog<T>(
  String operation,
  Future<T> Function() function, {
  LogLevel logLevel = LogLevel.debug,
  List<String>? tags,
  Map<String, dynamic>? context,
}) async {
  final stopwatch = Stopwatch()..start();
  
  try {
    final result = await function();
    stopwatch.stop();
    
    final duration = stopwatch.elapsed;
    final metric = {
      'operation': operation,
      'duration_ms': duration.inMilliseconds,
      'success': true,
      ...?context,
    };
    
    final logMessage = '$operation 完成，耗时: ${duration.inMilliseconds}ms';
    
    switch (logLevel) {
      case LogLevel.verbose:
        logger.verbose(logMessage, source: 'Performance', tags: tags, context: metric);
        break;
      case LogLevel.debug:
        logger.debug(logMessage, source: 'Performance', tags: tags, context: metric);
        break;
      case LogLevel.info:
        logger.info(logMessage, source: 'Performance', tags: tags, context: metric);
        break;
      case LogLevel.warning:
        logger.warning(logMessage, source: 'Performance', tags: tags, context: metric);
        break;
      case LogLevel.error:
        logger.error(logMessage, source: 'Performance', tags: tags, context: metric);
        break;
      case LogLevel.critical:
        logger.critical(logMessage, source: 'Performance', tags: tags, context: metric);
        break;
    }
    
    // 同时记录到性能监控器
    performanceMonitor.recordResponseTime(operation, duration, tags: tags);
    
    return result;
  } catch (e, stackTrace) {
    stopwatch.stop();
    
    logger.error('$operation 失败', 
        exception: e, 
        stackTrace: stackTrace,
        source: 'Performance',
        tags: [...?tags, 'error'],
        context: {
          'operation': operation,
          'duration_ms': stopwatch.elapsedMilliseconds,
          'success': false,
          ...?context,
        });
    
    rethrow;
  }
}

/// 版本信息
const String loggingPackageVersion = '1.0.0';

/// 包信息
const Map<String, dynamic> loggingPackageInfo = {
  'name': 'flutter_logging_system',
  'version': loggingPackageVersion,
  'description': '完整的Flutter日志和调试系统',
  'author': 'Logging System Team',
  'license': 'MIT',
};