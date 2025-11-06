import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'logger.dart';
import 'log_entry.dart';

/// 错误类型
enum ErrorType {
  /// 一般错误
  general,
  
  /// 网络错误
  network,
  
  /// 文件系统错误
  fileSystem,
  
  /// 解析错误
  parse,
  
  /// 权限错误
  permission,
  
  /// 超时错误
  timeout,
  
  /// 验证错误
  validation,
  
  /// 业务逻辑错误
  businessLogic,
  
  /// 系统错误
  system,
  
  /// 未知错误
  unknown;
}

/// 错误严重程度
enum ErrorSeverity {
  /// 信息级别
  info,
  
  /// 警告级别
  warning,
  
  /// 错误级别
  error,
  
  /// 严重错误
  critical,
  
  /// 致命错误
  fatal;
}

/// 错误报告信息
class ErrorReport {
  /// 报告唯一ID
  final String id;
  
  /// 错误类型
  final ErrorType type;
  
  /// 严重程度
  final ErrorSeverity severity;
  
  /// 错误消息
  final String message;
  
  /// 异常对象
  final Object? exception;
  
  /// 堆栈跟踪
  final StackTrace? stackTrace;
  
  /// 错误时间
  final DateTime timestamp;
  
  /// 应用状态信息
  final Map<String, dynamic> appState;
  
  /// 系统信息
  final Map<String, dynamic> systemInfo;
  
  /// 用户操作上下文
  final Map<String, dynamic>? userContext;
  
  /// 错误发生时的环境信息
  final Map<String, dynamic> environment;
  
  /// 是否已处理
  final bool isHandled;
  
  /// 错误发生时的调用栈
  final List<String> callStack;

  ErrorReport({
    required this.id,
    required this.type,
    required this.severity,
    required this.message,
    this.exception,
    this.stackTrace,
    required this.timestamp,
    required this.appState,
    required this.systemInfo,
    this.userContext,
    required this.environment,
    this.isHandled = false,
    List<String>? callStack,
  }) : callStack = callStack ?? [];

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'severity': severity.name,
      'message': message,
      'exception': exception?.toString(),
      'stackTrace': stackTrace?.toString(),
      'timestamp': timestamp.toIso8601String(),
      'appState': appState,
      'systemInfo': systemInfo,
      'userContext': userContext,
      'environment': environment,
      'isHandled': isHandled,
      'callStack': callStack,
    };
  }

  /// 从JSON创建
  factory ErrorReport.fromJson(Map<String, dynamic> json) {
    return ErrorReport(
      id: json['id'] as String,
      type: ErrorType.values.firstWhere((e) => e.name == json['type']),
      severity: ErrorSeverity.values.firstWhere((s) => s.name == json['severity']),
      message: json['message'] as String,
      exception: json['exception'] != null ? json['exception'] as String : null,
      stackTrace: json['stackTrace'] != null ? StackTrace.fromString(json['stackTrace'] as String) : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
      appState: Map<String, dynamic>.from(json['appState'] as Map),
      systemInfo: Map<String, dynamic>.from(json['systemInfo'] as Map),
      userContext: json['userContext'] as Map<String, dynamic>?,
      environment: Map<String, dynamic>.from(json['environment'] as Map),
      isHandled: json['isHandled'] as bool? ?? false,
      callStack: (json['callStack'] as List<dynamic>).cast<String>(),
    );
  }

  @override
  String toString() {
    return 'ErrorReport{id: $id, type: $type, severity: $severity, message: $message, timestamp: $timestamp}';
  }
}

/// 崩溃信息
class CrashInfo {
  /// 崩溃ID
  final String id;
  
  /// 崩溃时间
  final DateTime timestamp;
  
  /// 异常信息
  final Object exception;
  
  /// 堆栈跟踪
  final StackTrace stackTrace;
  
  /// 应用状态
  final Map<String, dynamic> appState;
  
  /// 系统信息
  final Map<String, dynamic> systemInfo;
  
  /// 崩溃前的操作序列
  final List<String> userActions;
  
  /// 内存使用情况
  final Map<String, dynamic>? memoryInfo;
  
  /// 网络状态
  final Map<String, dynamic>? networkInfo;

  CrashInfo({
    required this.id,
    required this.timestamp,
    required this.exception,
    required this.stackTrace,
    required this.appState,
    required this.systemInfo,
    required this.userActions,
    this.memoryInfo,
    this.networkInfo,
  });

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'exception': exception.toString(),
      'stackTrace': stackTrace.toString(),
      'appState': appState,
      'systemInfo': systemInfo,
      'userActions': userActions,
      'memoryInfo': memoryInfo,
      'networkInfo': networkInfo,
    };
  }

  /// 从JSON创建
  factory CrashInfo.fromJson(Map<String, dynamic> json) {
    return CrashInfo(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      exception: Exception(json['exception'] as String),
      stackTrace: StackTrace.fromString(json['stackTrace'] as String),
      appState: Map<String, dynamic>.from(json['appState'] as Map),
      systemInfo: Map<String, dynamic>.from(json['systemInfo'] as Map),
      userActions: (json['userActions'] as List<dynamic>).cast<String>(),
      memoryInfo: json['memoryInfo'] as Map<String, dynamic>?,
      networkInfo: json['networkInfo'] as Map<String, dynamic>?,
    );
  }

  @override
  String toString() {
    return 'CrashInfo{id: $id, exception: $exception, timestamp: $timestamp}';
  }
}

/// 错误收集配置
class ErrorCollectionConfig {
  /// 是否启用错误收集
  final bool enabled;
  
  /// 是否自动收集崩溃信息
  final bool autoCaptureCrashes;
  
  /// 最大错误报告数量
  final int maxErrorReports;
  
  /// 最大崩溃信息数量
  final int maxCrashInfos;
  
  /// 是否记录用户操作上下文
  final bool recordUserContext;
  
  /// 是否收集系统信息
  final bool collectSystemInfo;
  
  /// 是否启用错误过滤
  final bool enableFiltering;
  
  /// 过滤的错误类型
  final Set<ErrorType> filteredTypes;
  
  /// 过滤的错误消息关键字
  final Set<String> filteredKeywords;

  const ErrorCollectionConfig({
    this.enabled = false,
    this.autoCaptureCrashes = true,
    this.maxErrorReports = 100,
    this.maxCrashInfos = 10,
    this.recordUserContext = true,
    this.collectSystemInfo = true,
    this.enableFiltering = false,
    this.filteredTypes = const {},
    this.filteredKeywords = const {},
  });

  ErrorCollectionConfig copyWith({
    bool? enabled,
    bool? autoCaptureCrashes,
    int? maxErrorReports,
    int? maxCrashInfos,
    bool? recordUserContext,
    bool? collectSystemInfo,
    bool? enableFiltering,
    Set<ErrorType>? filteredTypes,
    Set<String>? filteredKeywords,
  }) {
    return ErrorCollectionConfig(
      enabled: enabled ?? this.enabled,
      autoCaptureCrashes: autoCaptureCrashes ?? this.autoCaptureCrashes,
      maxErrorReports: maxErrorReports ?? this.maxErrorReports,
      maxCrashInfos: maxCrashInfos ?? this.maxCrashInfos,
      recordUserContext: recordUserContext ?? this.recordUserContext,
      collectSystemInfo: collectSystemInfo ?? this.collectSystemInfo,
      enableFiltering: enableFiltering ?? this.enableFiltering,
      filteredTypes: filteredTypes ?? this.filteredTypes,
      filteredKeywords: filteredKeywords ?? this.filteredKeywords,
    );
  }
}

/// 错误和崩溃收集器
class ErrorCollector {
  final Logger _logger = Logger();
  final ErrorCollectionConfig _config;
  final List<ErrorReport> _errorReports = [];
  final List<CrashInfo> _crashInfos = [];
  final StreamController<ErrorReport> _errorStreamController = StreamController.broadcast();
  final StreamController<CrashInfo> _crashStreamController = StreamController.broadcast();
  
  /// 用户操作历史
  final List<String> _userActions = [];
  
  /// 错误ID生成器
  int _errorIdCounter = 0;
  
  /// 崩溃ID生成器
  int _crashIdCounter = 0;

  /// 错误报告流
  Stream<ErrorReport> get errorStream => _errorStreamController.stream;
  
  /// 崩溃信息流
  Stream<CrashInfo> get crashStream => _crashStreamController.stream;
  
  /// 配置
  ErrorCollectionConfig get config => _config;

  ErrorCollector({ErrorCollectionConfig? config}) 
      : _config = config ?? const ErrorCollectionConfig() {
    _initialize();
  }

  /// 初始化错误收集器
  void _initialize() {
    if (_config.enabled) {
      _startErrorCapture();
      _logger.info('错误收集器已启动', source: 'ErrorCollector');
    }
  }

  /// 启动错误捕获
  void _startErrorCapture() {
    // 设置Flutter错误处理器
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };

    // 设置平台错误处理器
    PlatformDispatcher.instance.onError = (error, stack) {
      _handlePlatformError(error, stack);
      return true; // 阻止默认错误处理
    };
  }

  /// 处理Flutter错误
  void _handleFlutterError(FlutterErrorDetails details) {
    try {
      final errorReport = _createErrorReport(
        type: ErrorType.general,
        severity: ErrorSeverity.error,
        message: details.exception?.toString() ?? 'Flutter渲染错误',
        exception: details.exception,
        stackTrace: details.stack,
      );

      _addErrorReport(errorReport);
      _logger.critical('Flutter错误', 
          exception: details.exception, 
          stackTrace: details.stack,
          source: 'FlutterError',
          context: details.context?.toString());
    } catch (e) {
      // 错误处理过程中的异常不应该导致崩溃
      print('错误收集器处理Flutter错误时发生异常: $e');
    }
  }

  /// 处理平台错误
  bool _handlePlatformError(Object error, StackTrace stackTrace) {
    try {
      final errorReport = _createErrorReport(
        type: _classifyError(error),
        severity: ErrorSeverity.error,
        message: error.toString(),
        exception: error,
        stackTrace: stackTrace,
      );

      _addErrorReport(errorReport);
      _logger.error('平台错误', 
          exception: error, 
          stackTrace: stackTrace,
          source: 'PlatformError');
      
      return true; // 继续处理
    } catch (e) {
      print('错误收集器处理平台错误时发生异常: $e');
      return false;
    }
  }

  /// 创建错误报告
  ErrorReport _createErrorReport({
    required ErrorType type,
    required ErrorSeverity severity,
    required String message,
    Object? exception,
    StackTrace? stackTrace,
    Map<String, dynamic>? userContext,
  }) {
    final id = 'error_${DateTime.now().microsecondsSinceEpoch}_${_errorIdCounter++}';
    
    final appState = _collectAppState();
    final systemInfo = _config.collectSystemInfo ? _collectSystemInfo() : {};
    final environment = _collectEnvironment();
    
    final errorReport = ErrorReport(
      id: id,
      type: type,
      severity: severity,
      message: message,
      exception: exception,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      appState: appState,
      systemInfo: systemInfo,
      userContext: _config.recordUserContext ? userContext : null,
      environment: environment,
      callStack: stackTrace != null ? _parseCallStack(stackTrace.toString()) : [],
    );

    return errorReport;
  }

  /// 添加错误报告
  void _addErrorReport(ErrorReport report) {
    // 检查过滤规则
    if (_shouldFilter(report)) {
      _logger.debug('错误被过滤: ${report.message}', source: 'ErrorCollector');
      return;
    }

    // 限制内存中的错误报告数量
    _errorReports.add(report);
    if (_errorReports.length > _config.maxErrorReports) {
      _errorReports.removeAt(0);
    }

    // 发送流事件
    if (!_errorStreamController.isClosed) {
      _errorStreamController.add(report);
    }

    _logger.info('错误报告已添加: ${report.id}', source: 'ErrorCollector');
  }

  /// 检查是否应该过滤错误
  bool _shouldFilter(ErrorReport report) {
    if (!_config.enableFiltering) return false;

    // 过滤特定类型
    if (_config.filteredTypes.contains(report.type)) {
      return true;
    }

    // 过滤包含特定关键字的消息
    for (final keyword in _config.filteredKeywords) {
if (report.message.toLowerCase().contains(keyword.toLowerCase()) {
        return true;
      }
    }

    return false;
  }

  /// 分类错误类型
  ErrorType _classifyError(Object error) {
    final message = error.toString().toLowerCase();
    
    if (message.contains('network') || message.contains('socket') || message.contains('http')) {
      return ErrorType.network;
    } else if (message.contains('file') || message.contains('io') || message.contains('permission')) {
      return ErrorType.fileSystem;
    } else if (message.contains('parse') || message.contains('format') || message.contains('json')) {
      return ErrorType.parse;
    } else if (message.contains('timeout')) {
      return ErrorType.timeout;
    } else if (message.contains('permission') || message.contains('access')) {
      return ErrorType.permission;
    } else if (message.contains('validate') || message.contains('invalid')) {
      return ErrorType.validation;
    } else if (message.contains('business') || message.contains('logic')) {
      return ErrorType.businessLogic;
    } else {
      return ErrorType.general;
    }
  }

  /// 收集应用状态信息
  Map<String, dynamic> _collectAppState() {
    final appState = <String, dynamic>{};
    
    try {
      // 应用运行时间（这里需要从应用启动时记录）
      appState['uptime'] = DateTime.now().millisecondsSinceEpoch;
      
      // 内存使用情况（模拟）
      appState['memory_usage'] = '50MB';
      
      // 活跃页面信息
      appState['current_route'] = 'unknown';
      
      // 用户会话信息
      appState['user_session'] = 'active';
    } catch (e) {
      _logger.warning('收集应用状态失败', exception: e, source: 'ErrorCollector');
    }
    
    return appState;
  }

  /// 收集系统信息
  Map<String, dynamic> _collectSystemInfo() {
    final systemInfo = <String, dynamic>{};
    
    try {
      // 操作系统信息
      systemInfo['platform'] = Platform.operatingSystem;
      systemInfo['operating_system'] = Platform.operatingSystemVersion;
      
      // 应用版本信息
      systemInfo['app_version'] = '1.0.0'; // 这里应该从应用配置获取;
      systemInfo['dart_version'] = Platform.version;
      
      // 硬件信息
      systemInfo['processor_count'] = Platform.numberOfProcessors;
      
      // 环境信息
      systemInfo['is_production'] = kDebugMode ? false : true;
      systemInfo['is_debug'] = kDebugMode;
    } catch (e) {
      _logger.warning('收集系统信息失败', exception: e, source: 'ErrorCollector');
    }
    
    return systemInfo;
  }

  /// 收集环境信息
  Map<String, dynamic> _collectEnvironment() {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'timezone': DateTime.now().timeZoneName,
      'locale': 'zh-CN', // 这里应该从系统获取实际locale
      'is_connected': true, // 这里应该检查网络连接状态
    };
  }

  /// 解析调用栈
  List<String> _parseCallStack(String stackTraceString) {
    return stackTraceString.split('\n').take(10).toList();
  }

  /// 手动记录错误
  void reportError({
    required ErrorType type,
    required ErrorSeverity severity,
    required String message,
    Object? exception,
    StackTrace? stackTrace,
    Map<String, dynamic>? userContext,
  }) {
    if (!_config.enabled) return;

    final report = _createErrorReport(
      type: type,
      severity: severity,
      message: message,
      exception: exception,
      stackTrace: stackTrace,
      userContext: userContext,
    );

    _addErrorReport(report);
  }

  /// 记录用户操作
  void recordUserAction(String action) {
    if (!_config.enabled) return;

    _userActions.add('${DateTime.now().toIso8601String()}: $action');
    
    // 限制用户操作历史长度
    if (_userActions.length > 50) {
      _userActions.removeAt(0);
    }
  }

  /// 记录崩溃信息
  void recordCrash(Object exception, StackTrace stackTrace) {
    if (!_config.enabled || !_config.autoCaptureCrashes) return;

    try {
      final id = 'crash_${DateTime.now().microsecondsSinceEpoch}_${_crashIdCounter++}';
      
      final crashInfo = CrashInfo(
        id: id,
        timestamp: DateTime.now(),
        exception: exception,
        stackTrace: stackTrace,
        appState: _collectAppState(),
        systemInfo: _config.collectSystemInfo ? _collectSystemInfo() : {},
        userActions: List<String>.from(_userActions),
        memoryInfo: _collectMemoryInfo(),
        networkInfo: _collectNetworkInfo(),
      );

      // 添加到崩溃列表
      _crashInfos.add(crashInfo);
      if (_crashInfos.length > _config.maxCrashInfos) {
        _crashInfos.removeAt(0);
      }

      // 发送流事件
      if (!_crashStreamController.isClosed) {
        _crashStreamController.add(crashInfo);
      }

      _logger.critical('应用崩溃', 
          exception: exception, 
          stackTrace: stackTrace,
          source: 'AppCrash');
    } catch (e) {
      _logger.warning('记录崩溃信息失败', exception: e, source: 'ErrorCollector');
    }
  }

  /// 收集内存信息
  Map<String, dynamic>? _collectMemoryInfo() {
    try {
      return {
        'heap_size': '50MB', // 模拟数据
        'external_size': '10MB', // 模拟数据
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return null;
    }
  }

  /// 收集网络信息
  Map<String, dynamic>? _collectNetworkInfo() {
    try {
      return {
        'is_connected': true, // 模拟数据
        'network_type': 'wifi', // 模拟数据
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return null;
    }
  }

  /// 获取错误报告列表
  List<ErrorReport> getErrorReports() {
    return List.unmodifiable(_errorReports);
  }

  /// 获取崩溃信息列表
  List<CrashInfo> getCrashInfos() {
    return List.unmodifiable(_crashInfos);
  }

  /// 根据类型获取错误报告
  List<ErrorReport> getErrorReportsByType(ErrorType type) {
    return _errorReports.where((report) => report.type == type).toList();
  }

  /// 根据严重程度获取错误报告
  List<ErrorReport> getErrorReportsBySeverity(ErrorSeverity severity) {
    return _errorReports.where((report) => report.severity == severity).toList();
  }

  /// 获取错误统计
  Map<String, dynamic> getErrorStatistics() {
    final typeCount = <String, int>{};
    final severityCount = <String, int>{};
    
    for (final report in _errorReports) {
      typeCount[report.type.name] = (typeCount[report.type.name] ?? 0) + 1;
      severityCount[report.severity.name] = (severityCount[report.severity.name] ?? 0) + 1;
    }
    
    return {
      'total_errors': _errorReports.length,
      'total_crashes': _crashInfos.length,
      'type_distribution': typeCount,
      'severity_distribution': severityCount,
      'recent_errors': _errorReports.take(5).map((r) => r.toJson()).toList(),
    };
  }

  /// 导出错误报告
  String exportErrorReports() {
    final data = {
      'export_time': DateTime.now().toIso8601String(),
      'config': {
        'enabled': _config.enabled,
        'max_error_reports': _config.maxErrorReports,
        'max_crash_infos': _config.maxCrashInfos,
      },
      'statistics': getErrorStatistics(),
      'error_reports': _errorReports.map((r) => r.toJson()).toList(),
      'crash_infos': _crashInfos.map((c) => c.toJson()).toList(),
      'user_actions': _userActions,
    };
    
    return json.encode(data);
  }

  /// 清空所有错误和崩溃信息
  void clear() {
    _errorReports.clear();
    _crashInfos.clear();
    _userActions.clear();
    _logger.info('错误和崩溃信息已清空', source: 'ErrorCollector');
  }

  /// 启用错误收集
  void enable() {
    if (!_config.enabled) {
      _config = _config.copyWith(enabled: true);
      _startErrorCapture();
      _logger.info('错误收集已启用', source: 'ErrorCollector');
    }
  }

  /// 禁用错误收集
  void disable() {
    if (_config.enabled) {
      _config = _config.copyWith(enabled: false);
      _logger.info('错误收集已禁用', source: 'ErrorCollector');
    }
  }

  /// 关闭错误收集器
  void dispose() {
    _errorStreamController.close();
    _crashStreamController.close();
    _logger.info('错误收集器已关闭', source: 'ErrorCollector');
  }
}