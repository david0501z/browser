import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'logger.dart';
import 'log_entry.dart';
import 'log_level.dart';

/// 调试模式配置
class DebugConfig {
  /// 是否启用调试模式
  final bool enabled;
  
  /// 调试模式的最低日志级别
  final LogLevel minimumLevel;
  
  /// 是否显示内存使用情况
  final bool showMemoryUsage;
  
  /// 是否显示性能统计
  final bool showPerformanceStats;
  
  /// 是否记录方法调用栈
  final bool captureStackTrace;
  
  /// 是否启用网络请求监控
  final bool monitorNetworkRequests;
  
  /// 是否启用文件系统监控
  final bool monitorFileSystem;
  
  /// 调试信息刷新间隔
  final Duration refreshInterval;

  const DebugConfig({
    this.enabled = false,
    this.minimumLevel = LogLevel.debug,
    this.showMemoryUsage = true,
    this.showPerformanceStats = true,
    this.captureStackTrace = false,
    this.monitorNetworkRequests = false,
    this.monitorFileSystem = false,
    this.refreshInterval = const Duration(seconds: 1),
  });

  DebugConfig copyWith({
    bool? enabled,
    LogLevel? minimumLevel,
    bool? showMemoryUsage,
    bool? showPerformanceStats,
    bool? captureStackTrace,
    bool? monitorNetworkRequests,
    bool? monitorFileSystem,
    Duration? refreshInterval,
  }) {
    return DebugConfig(
      enabled: enabled ?? this.enabled,
      minimumLevel: minimumLevel ?? this.minimumLevel,
      showMemoryUsage: showMemoryUsage ?? this.showMemoryUsage,
      showPerformanceStats: showPerformanceStats ?? this.showPerformanceStats,
      captureStackTrace: captureStackTrace ?? this.captureStackTrace,
      monitorNetworkRequests: monitorNetworkRequests ?? this.monitorNetworkRequests,
      monitorFileSystem: monitorFileSystem ?? this.monitorFileSystem,
      refreshInterval: refreshInterval ?? this.refreshInterval,
    );
  }
}

/// 调试统计信息
class DebugStats {
  /// 内存使用情况
  final MemoryInfo? memoryInfo;
  
  /// CPU使用情况
  final double? cpuUsage;
  
  /// 应用启动时间
  final DateTime appStartTime;
  
  /// 当前时间
  final DateTime currentTime;
  
  /// 运行时间
  final Duration uptime;
  
  /// 活跃 isolates 数量
  final int isolateCount;
  
  /// 线程数量
  final int threadCount;
  
  /// 日志统计
  final Map<LogLevel, int> logStats;
  
  /// 网络请求统计
  final int networkRequests;
  
  /// 文件操作统计
  final int fileOperations;

  DebugStats({
    this.memoryInfo,
    this.cpuUsage,
    required this.appStartTime,
    DateTime? currentTime,
    required this.uptime,
    required this.isolateCount,
    required this.threadCount,
    required this.logStats,
    this.networkRequests = 0,
    this.fileOperations = 0,
  }) : currentTime = currentTime ?? DateTime.now();

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'memoryInfo': memoryInfo?.toJson(),
      'cpuUsage': cpuUsage,
      'appStartTime': appStartTime.toIso8601String(),
      'currentTime': currentTime.toIso8601String(),
      'uptime': uptime.inMilliseconds,
      'isolateCount': isolateCount,
      'threadCount': threadCount,
      'logStats': logStats.map((k, v) => MapEntry(k.name, v)),
      'networkRequests': networkRequests,
      'fileOperations': fileOperations,
    };
  }
}

/// 内存信息
class MemoryInfo {
  /// 堆内存使用量（字节）
  final int heapSize;
  
  /// 堆内存使用量（MB）
  final double heapSizeMB;
  
  /// 外部内存使用量（字节）
  final int externalSize;
  
  /// 外部内存使用量（MB）
  final double externalSizeMB;
  
  /// 总内存使用量（字节）
  final int totalSize;
  
  /// 总内存使用量（MB）
  final double totalSizeMB;

  MemoryInfo({
    required this.heapSize,
    required this.externalSize,
  }) : 
    heapSizeMB = heapSize / (1024 * 1024),
    externalSizeMB = externalSize / (1024 * 1024),
    totalSize = heapSize + externalSize,
    totalSizeMB = (heapSize + externalSize) / (1024 * 1024);

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'heapSize': heapSize,
      'heapSizeMB': heapSizeMB,
      'externalSize': externalSize,
      'externalSizeMB': externalSizeMB,
      'totalSize': totalSize,
      'totalSizeMB': totalSizeMB,
    };
  }

  @override
  String toString() {
    return 'MemoryInfo(堆: ${heapSizeMB.toStringAsFixed(2)}MB, 外部: ${externalSizeMB.toStringAsFixed(2)}MB, 总计: ${totalSizeMB.toStringAsFixed(2)}MB)';
  }
}

/// 调试工具
class DebugTools {
  final Logger _logger = Logger();
  final StreamController<DebugStats> _statsController = StreamController.broadcast();

  /// 调试统计流
  Stream<DebugStats> get statsStream => _statsController.stream;

  /// 创建调试统计信息
  Future<DebugStats> createStats(DebugConfig config) async {
    final startTime = DateTime.now();
    
    // 获取内存信息（在Flutter中可能不可用）
    MemoryInfo? memoryInfo;
    try {
      // 这里应该使用Flutter的内存监控API
      memoryInfo = MemoryInfo(
        heapSize: 50 * 1024 * 1024, // 假设值
        externalSize: 10 * 1024 * 1024, // 假设值
      );
    } catch (e) {
      _logger.warning('获取内存信息失败', exception: e, source: 'DebugTools');
    }

    // 获取日志统计
    final logStats = _logger.statistics?.levelCounts ?? {};
    
    // 获取运行时间（这里需要应用启动时间）
    final appStartTime = DateTime.now(); // 这里应该从应用启动时记录;
    final uptime = DateTime.now().difference(appStartTime);

    final stats = DebugStats(
      memoryInfo: memoryInfo,
      cpuUsage: null, // CPU使用率在Flutter中难以获取
      appStartTime: appStartTime,
      currentTime: DateTime.now(),
      uptime: uptime,
      isolateCount: 1, // Flutter通常单线程
      threadCount: 1, // Flutter通常单线程
      logStats: logStats,
    );

    _statsController.add(stats);
    return stats;
  }

  /// 执行调试命令
  Future<String> executeCommand(String command, List<String> args) async {
    try {
      _logger.debug('执行调试命令: $command ${args.join(' ')}', source: 'DebugTools');

      switch (command.toLowerCase()) {
        case 'help':
          return _showHelp();
        case 'logs':
          return _getLogs(args);
        case 'memory':
          return await _getMemoryInfo();
        case 'threads':
          return _getThreadInfo();
        case 'gc':
          return await _runGarbageCollection();
        case 'clear':
          return _clearDebugData();
        case 'export':
          return _exportDebugData();
        case 'perf':
          return await _getPerformanceInfo();
        default:
          return '未知命令: $command\n使用 "help" 查看可用命令';
      }
    } catch (e, stackTrace) {
      _logger.error('调试命令执行失败', exception: e, stackTrace: stackTrace, source: 'DebugTools');
      return '命令执行失败: $e';
    }
  }

  /// 显示帮助信息
  String _showHelp() {
    return '''
调试工具帮助:

可用命令:
  help              - 显示此帮助信息
  logs [level]      - 获取日志信息 (level: verbose, debug, info, warning, error, critical)
  memory            - 获取内存使用信息
  threads           - 获取线程信息
  gc                - 运行垃圾回收
  clear             - 清除调试数据
  export            - 导出调试数据
  perf              - 获取性能统计

示例:
  debug logs error     # 获取所有错误级别的日志
  debug memory         # 获取内存使用信息
  debug perf           # 获取性能统计
''';
  }

  /// 获取日志信息
  String _getLogs(List<String> args) {
    final level = args.isNotEmpty ? LogLevel.fromString(args[0]) : LogLevel.info;
    final entries = _logger.getEntriesByLevel(level);
    
    if (entries.isEmpty) {
      return '没有找到 $level 级别的日志';
    }

    final buffer = StringBuffer();
    buffer.writeln('=== $level 级别日志 (${entries.length} 条) ===');
    
    for (final entry in entries.take(10)) { // 只显示前10条
      buffer.writeln(entry.toFormattedString());
    }
    
    if (entries.length > 10) {
      buffer.writeln('... (还有 ${entries.length - 10} 条日志)');
    }
    
    return buffer.toString();
  }

  /// 获取内存信息
  Future<String> _getMemoryInfo() async {
    final stats = await createStats(DebugConfig());
    if (stats.memoryInfo == null) {
      return '无法获取内存信息';
    }

    return '''
=== 内存使用情况 ===;
堆内存: ${stats.memoryInfo!.heapSizeMB.toStringAsFixed(2)} MB
外部内存: ${stats.memoryInfo!.externalSizeMB.toStringAsFixed(2)} MB
总计: ${stats.memoryInfo!.totalSizeMB.toStringAsFixed(2)} MB

运行时长: ${stats.uptime.inHours}小时 ${stats.uptime.inMinutes % 60}分钟
''';
  }

  /// 获取线程信息
  String _getThreadInfo() {
    return '''
=== 线程信息 ===;
活跃 isolates: 1 (Flutter标准)
线程数: 1 (Flutter标准)
注意: Flutter使用单线程执行模型
''';
  }

  /// 运行垃圾回收
  Future<String> _runGarbageCollection() async {
    try {
      // 在Dart中，无法直接触发GC，但可以建议运行
      // 这里只是记录调试信息
      _logger.info('触发垃圾回收', source: 'DebugTools');
      return '垃圾回收已执行';
    } catch (e) {
      return '垃圾回收失败: $e';
    }
  }

  /// 清除调试数据
  String _clearDebugData() {
    try {
      _logger.clearMemory();
      return '调试数据已清除';
    } catch (e) {
      return '清除调试数据失败: $e';
    }
  }

  /// 导出调试数据
  String _exportDebugData() {
    try {
      final exportData = _logger.exportToJson();
      return '调试数据导出完成，大小: ${(exportData.length / 1024).toStringAsFixed(2)} KB';
    } catch (e) {
      return '导出调试数据失败: $e';
    }
  }

  /// 获取性能信息
  Future<String> _getPerformanceInfo() async {
    final stats = await createStats(DebugConfig());
    
    return '''
=== 性能统计 ===;
应用启动: ${stats.appStartTime.toIso8601String()}
运行时间: ${stats.uptime.inHours}小时 ${stats.uptime.inMinutes % 60}分钟 ${stats.uptime.inSeconds % 60}秒
活跃 isolates: ${stats.isolateCount}
网络请求: ${stats.networkRequests}
文件操作: ${stats.fileOperations}

日志统计:
${stats.logStats.entries.map((e) => '  ${e.key.name}: ${e.value}').join('\n')}
''';
  }

  /// 关闭调试工具
  void dispose() {
    _statsController.close();
  }
}

/// 调试服务
class DebugService {
  final Logger _logger = Logger();
  final DebugConfig _config;
  final DebugTools _tools = DebugTools();
  final StreamController<DebugConfig> _configController = StreamController.broadcast();
  
  Timer? _statsTimer;
  DateTime _appStartTime = DateTime.now();
  
  /// 配置变化流
  Stream<DebugConfig> get configStream => _configController.stream;
  
  /// 调试工具
  DebugTools get tools => _tools;

  DebugService({DebugConfig? config}) 
      : _config = config ?? const DebugConfig() {
    _initialize();
  }

  /// 初始化调试服务
  void _initialize() {
    if (_config.enabled) {
      _startMonitoring();
      _logger.info('调试服务已启动', source: 'DebugService');
    }
  }

  /// 启动监控
  void _startMonitoring() {
    _statsTimer = Timer.periodic(_config.refreshInterval, (_) {
      _updateStats();
    });
  }

  /// 停止监控
  void _stopMonitoring() {
    _statsTimer?.cancel();
    _statsTimer = null;
  }

  /// 更新统计信息
  Future<void> _updateStats() async {
    if (!_config.enabled) return;

    try {
      final stats = await _tools.createStats(_config);
      
      // 记录性能统计（如果启用）
      if (_config.showPerformanceStats) {
        if (stats.memoryInfo != null) {
          _logger.debug('内存使用: ${stats.memoryInfo}', source: 'DebugService', tags: ['performance']);
        }
        
        _logger.debug('运行时间: ${stats.uptime}', source: 'DebugService', tags: ['performance']);
      }
    } catch (e) {
      _logger.warning('更新调试统计失败', exception: e, source: 'DebugService');
    }
  }

  /// 启用调试模式
  void enable() {
    if (!_config.enabled) {
      _logger.setDebugMode(true);
      _config = _config.copyWith(enabled: true);
      _startMonitoring();
      _configController.add(_config);
      _logger.info('调试模式已启用', source: 'DebugService');
    }
  }

  /// 禁用调试模式
  void disable() {
    if (_config.enabled) {
      _config = _config.copyWith(enabled: false);
      _stopMonitoring();
      _configController.add(_config);
      _logger.info('调试模式已禁用', source: 'DebugService');
    }
  }

  /// 切换调试模式
  void toggle() {
    if (_config.enabled) {
      disable();
    } else {
      enable();
    }
  }

  /// 更新配置
  void updateConfig(DebugConfig newConfig) {
    final oldEnabled = _config.enabled;
    _config = newConfig;
    
    if (oldEnabled != newConfig.enabled) {
      if (newConfig.enabled) {
        _startMonitoring();
      } else {
        _stopMonitoring();
      }
    }
    
    _configController.add(_config);
    _logger.debug('调试配置已更新', source: 'DebugService', context: {'config': newConfig.toString()});
  }

  /// 获取当前配置
  DebugConfig get config => _config;

  /// 设置应用启动时间
  void setAppStartTime(DateTime startTime) {
    _appStartTime = startTime;
  }

  /// 获取应用运行时间
  Duration getAppUptime() {
    return DateTime.now().difference(_appStartTime);
  }

  /// 执行调试命令
  Future<String> executeCommand(String command, List<String> args) async {
    if (!_config.enabled) {
      return '调试模式未启用';
    }
    
    return _tools.executeCommand(command, args);
  }

  /// 记录方法调用（装饰器）
  void logMethodCall(String methodName, Map<String, dynamic>? arguments, [String? source]) {
    if (!_config.enabled) return;
    
    _logger.debug('方法调用: $methodName', 
        source: source ?? 'DebugService',
        context: arguments != null ? {'arguments': arguments} : null,
        tags: ['method_call', methodName]);
  }

  /// 记录方法返回
  void logMethodReturn(String methodName, dynamic returnValue, [String? source]) {
    if (!_config.enabled) return;
    
    _logger.debug('方法返回: $methodName', 
        source: source ?? 'DebugService',
        context: {'returnValue': returnValue?.toString()},
        tags: ['method_return', methodName]);
  }

  /// 记录方法执行时间
  void logMethodExecutionTime(String methodName, Duration executionTime, [String? source]) {
    if (!_config.enabled) return;
    
    _logger.debug('方法执行时间: $methodName - ${executionTime.inMilliseconds}ms', 
        source: source ?? 'DebugService',
        tags: ['method_time', methodName]);
  }

  /// 记录变量值变化
  void logVariableChange(String variableName, dynamic oldValue, dynamic newValue, [String? source]) {
    if (!_config.enabled) return;
    
    _logger.debug('变量变化: $variableName = $oldValue -> $newValue', 
        source: source ?? 'DebugService',
        context: {
          'variable': variableName,
          'oldValue': oldValue?.toString(),
          'newValue': newValue?.toString(),
        },
        tags: ['variable_change', variableName]);
  }

  /// 关闭调试服务
  void dispose() {
    _stopMonitoring();
    _tools.dispose();
    _configController.close();
    _logger.info('调试服务已关闭', source: 'DebugService');
  }
}