import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'log_level.dart';
import 'log_entry.dart';
import 'log_formatter.dart';
import 'log_sink.dart';
import 'log_filter.dart';

/// 日志系统核心类
/// 提供完整的日志记录、管理和输出功能
class Logger {
  // 单例模式
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;
  Logger._internal();

  /// 日志记录列表（内存缓存）
  final List<LogEntry> _logEntries = [];

  /// 日志筛选器
  LogFilter _filter = const LogFilter();

  /// 日志输出器列表
  final List<LogSink> _sinks = [];

  /// 日志格式化器
  LogFormatter _formatter = const DefaultLogFormatter();

  /// 最大内存缓存日志条数
  int _maxMemoryEntries = 1000;

  /// 日志统计信息
  LogStatistics? _statistics;

  /// 是否启用调试模式
  bool _debugMode = false;

  /// 流控制器用于通知新日志
  final StreamController<LogEntry> _logStreamController =;
      StreamController<LogEntry>.broadcast();

  /// 日志事件流
  Stream<LogEntry> get logStream => _logStreamController.stream;

  /// 日志统计信息流
  Stream<LogStatistics> get statisticsStream => 
      _statistics?.stream ?? const Stream.empty();

  /// 获取当前日志筛选器
  LogFilter get filter => _filter;

  /// 获取日志统计信息
  LogStatistics? get statistics => _statistics;

  /// 获取是否启用调试模式
  bool get debugMode => _debugMode;

  /// 获取内存中的日志条目
  List<LogEntry> get logEntries => List.unmodifiable(_logEntries);

  /// 获取所有输出器
  List<LogSink> get sinks => List.unmodifiable(_sinks);

  /// 添加日志输出器
  void addSink(LogSink sink) {
    _sinks.add(sink);
  }

  /// 移除日志输出器
  void removeSink(LogSink sink) {
    _sinks.remove(sink);
  }

  /// 清空所有输出器
  void clearSinks() {
    _sinks.clear();
  }

  /// 设置日志筛选器
  void setFilter(LogFilter filter) {
    _filter = filter;
  }

  /// 设置日志格式化器
  void setFormatter(LogFormatter formatter) {
    _formatter = formatter;
  }

  /// 设置最大内存缓存条数
  void setMaxMemoryEntries(int maxEntries) {
    _maxMemoryEntries = maxEntries.clamp(100, 10000);
    _trimMemoryEntries();
  }

  /// 启用/禁用调试模式
  void setDebugMode(bool enabled) {
    _debugMode = enabled;
  }

  /// 记录Verbose级别日志
  void verbose(
    String message, {
    String? source,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) {
    _log(
      LogEntry.verbose(
        message,
        source: source,
        tags: tags,
        context: context,
      ),
    );
  }

  /// 记录Debug级别日志
  void debug(
    String message, {
    String? source,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) {
    _log(
      LogEntry.debug(
        message,
        source: source,
        tags: tags,
        context: context,
      ),
    );
  }

  /// 记录Info级别日志
  void info(
    String message, {
    String? source,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) {
    _log(
      LogEntry.info(
        message,
        source: source,
        tags: tags,
        context: context,
      ),
    );
  }

  /// 记录Warning级别日志
  void warning(
    String message, {
    String? source,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) {
    _log(
      LogEntry.warning(
        message,
        source: source,
        tags: tags,
        context: context,
      ),
    );
  }

  /// 记录Error级别日志
  void error(
    String message, {
    String? source,
    Object? exception,
    StackTrace? stackTrace,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) {
    _log(
      LogEntry.error(
        message,
        source: source,
        exception: exception,
        stackTrace: stackTrace,
        tags: tags,
        context: context,
      ),
    );
  }

  /// 记录Critical级别日志
  void critical(
    String message, {
    String? source,
    Object? exception,
    StackTrace? stackTrace,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) {
    _log(
      LogEntry.critical(
        message,
        source: source,
        exception: exception,
        stackTrace: stackTrace,
        tags: tags,
        context: context,
      ),
    );
  }

  /// 记录异常信息
  void logException(
    Object exception,
    StackTrace stackTrace, {
    String? source,
    String? message,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) {
    _log(
      LogEntry.error(
        message ?? exception.toString(),
        source: source,
        exception: exception,
        stackTrace: stackTrace,
        tags: tags,
        context: context,
      ),
    );
  }

  /// 执行函数并记录执行时间和结果
  Future<T> measureExecution<T>(
    Future<T> Function() function, {
    String? source,
    String? functionName,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) async {
    final startTime = DateTime.now();
    final executionTag = ['performance', 'execution'];
    if (tags != null) {
      executionTag.addAll(tags);
    }

    try {
      verbose(
        '开始执行: ${functionName ?? function.runtimeType}',
        source: source,
        tags: executionTag,
        context: {...?context, 'startTime': startTime.toIso8601String()},
      );

      final result = await function();

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      debug(
        '执行完成: ${functionName ?? function.runtimeType}, 耗时: ${duration.inMilliseconds}ms',
        source: source,
        tags: executionTag,
        context: {
          ...?context,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'durationMs': duration.inMilliseconds,
          'result': result.toString(),
        },
      );

      return result;
    } catch (e, stackTrace) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      error(
        '执行失败: ${functionName ?? function.runtimeType}, 耗时: ${duration.inMilliseconds}ms, 错误: $e',
        source: source,
        exception: e,
        stackTrace: stackTrace,
        tags: executionTag,
        context: {
          ...?context,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'durationMs': duration.inMilliseconds,
        },
      );
      
      rethrow;
    }
  }

  /// 同步函数执行时间测量
  T measureExecutionSync<T>(
    T Function() function, {
    String? source,
    String? functionName,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) {
    final startTime = DateTime.now();
    final executionTag = ['performance', 'execution'];
    if (tags != null) {
      executionTag.addAll(tags);
    }

    try {
      verbose(
        '开始执行: ${functionName ?? function.runtimeType}',
        source: source,
        tags: executionTag,
        context: {...?context, 'startTime': startTime.toIso8601String()},
      );

      final result = function();

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      debug(
        '执行完成: ${functionName ?? function.runtimeType}, 耗时: ${duration.inMilliseconds}ms',
        source: source,
        tags: executionTag,
        context: {
          ...?context,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'durationMs': duration.inMilliseconds,
          'result': result.toString(),
        },
      );

      return result;
    } catch (e, stackTrace) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      error(
        '执行失败: ${functionName ?? function.runtimeType}, 耗时: ${duration.inMilliseconds}ms, 错误: $e',
        source: source,
        exception: e,
        stackTrace: stackTrace,
        tags: executionTag,
        context: {
          ...?context,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'durationMs': duration.inMilliseconds,
        },
      );
      
      rethrow;
    }
  }

  /// 核心日志记录方法
  void _log(LogEntry entry) {
    // 应用筛选器
    if (!_filter.shouldLog(entry)) {
      return;
    }

    // 添加到内存缓存
    _addToMemory(entry);

    // 更新统计信息
    _updateStatistics(entry);

    // 格式化日志消息
    final formattedMessage = _formatter.format(entry, _filter);

    // 输出到所有输出器
    for (final sink in _sinks) {
      try {
        sink.write(entry, formattedMessage);
      } catch (e) {
        // 输出器错误不应影响主日志流程
        print('Logger输出器错误: $e');
      }
    }

    // 发送流事件
    if (!_logStreamController.isClosed) {
      _logStreamController.add(entry);
    }

    // 打印到控制台（仅在调试模式或错误级别）
    if (_debugMode || entry.level.value >= LogLevel.error.value) {
      print(formattedMessage);
    }
  }

  /// 添加到内存缓存
  void _addToMemory(LogEntry entry) {
    _logEntries.add(entry);
    
    // 限制内存中的日志数量
    if (_logEntries.length > _maxMemoryEntries) {
      _logEntries.removeAt(0);
    }
  }

  /// 修剪内存中的日志条目
  void _trimMemoryEntries() {
    while (_logEntries.length > _maxMemoryEntries) {
      _logEntries.removeAt(0);
    }
  }

  /// 更新统计信息
  void _updateStatistics(LogEntry entry) {
    if (_statistics == null) {
      _statistics = LogStatistics();
    }
    _statistics!.addEntry(entry);
  }

  /// 清理内存中的所有日志
  void clearMemory() {
    _logEntries.clear();
  }

  /// 根据级别过滤日志
  List<LogEntry> getEntriesByLevel(LogLevel level) {
    return _logEntries.where((entry) => entry.level == level).toList();
  }

  /// 根据来源过滤日志
  List<LogEntry> getEntriesBySource(String source) {
    return _logEntries.where((entry) => entry.source == source).toList();
  }

  /// 根据标签过滤日志
  List<LogEntry> getEntriesByTag(String tag) {
    return _logEntries.where((entry) => entry.tags.contains(tag)).toList();
  }

  /// 根据时间范围过滤日志
  List<LogEntry> getEntriesByTimeRange(DateTime start, DateTime end) {
    return _logEntries.where((entry) => 
        entry.timestamp.isAfter(start) && entry.timestamp.isBefore(end)
    ).toList();
  }

  /// 搜索日志
  List<LogEntry> searchLogs(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _logEntries.where((entry) {
      return entry.message.toLowerCase().contains(lowercaseQuery) ||
             entry.source.toLowerCase().contains(lowercaseQuery) ||
             entry.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  /// 导出日志为JSON
  String exportToJson() {
    final logsJson = _logEntries.map((entry) => entry.toJson()).toList();
    return json.encode({
      'exportTime': DateTime.now().toIso8601String(),
      'totalEntries': _logEntries.length,
      'logs': logsJson,
    });
  }

  /// 导出日志为CSV格式
  String exportToCsv() {
    final buffer = StringBuffer();
    
    // CSV头部
    buffer.writeln('时间戳,级别,来源,消息,标签,线程ID,线程名,异常');
    
    // 数据行
    for (final entry in _logEntries) {
      buffer.write('"${entry.timestamp.toIso8601String()}",');
      buffer.write('"${entry.level.name}",');
      buffer.write('"${entry.source}",');
      buffer.write('"${entry.message.replaceAll('"', '""')}",');
      buffer.write('"${entry.tags.join(';')}",');
      buffer.write('${entry.threadId},');
      buffer.write('"${entry.threadName ?? ""}",');
      buffer.write('"${entry.exception?.toString() ?? ""}"\n');
    }
    
    return buffer.toString();
  }

  /// 关闭日志系统
  Future<void> dispose() async {
    // 关闭流控制器
    await _logStreamController.close();
    
    // 关闭所有输出器
    for (final sink in _sinks) {
      if (sink is DisposableSink) {
        await sink.dispose();
      }
    }
    
    // 重置状态
    _logEntries.clear();
    _sinks.clear();
    _statistics = null;
  }
}

/// 日志统计信息
class LogStatistics {
  final Map<LogLevel, int> _levelCounts = {};
  final Map<String, int> _sourceCounts = {};
  final Map<String, int> _tagCounts = {};
  int _totalEntries = 0;
  
  DateTime _startTime = DateTime.now();
  DateTime _lastEntryTime = DateTime.now();
  
  StreamController<LogStatistics>? _streamController;
  
  /// 统计信息变化流
  Stream<LogStatistics>? get stream => _streamController?.stream;

  /// 获取总数
  int get totalEntries => _totalEntries;

  /// 获取各级别统计
  Map<LogLevel, int> get levelCounts => Map.unmodifiable(_levelCounts);

  /// 获取各来源统计
  Map<String, int> get sourceCounts => Map.unmodifiable(_sourceCounts);

  /// 获取各标签统计
  Map<String, int> get tagCounts => Map.unmodifiable(_tagCounts);

  /// 获取开始时间
  DateTime get startTime => _startTime;

  /// 获取最后一条日志时间
  DateTime get lastEntryTime => _lastEntryTime;

  /// 添加日志条目
  void addEntry(LogEntry entry) {
    _totalEntries++;
    _lastEntryTime = entry.timestamp;
    
    // 更新级别统计
    _levelCounts[entry.level] = (_levelCounts[entry.level] ?? 0) + 1;
    
    // 更新来源统计
    _sourceCounts[entry.source] = (_sourceCounts[entry.source] ?? 0) + 1;
    
    // 更新标签统计
    for (final tag in entry.tags) {
      _tagCounts[tag] = (_tagCounts[tag] ?? 0) + 1;
    }
    
    // 发送流事件
    _streamController?.add(this);
  }

  /// 获取最活跃的来源
  Map<String, int> getTopSources({int limit = 10}) {
    final sortedEntries = _sourceCounts.entries.toList();
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(sortedEntries.take(limit));
  }

  /// 获取最常用的标签
  Map<String, int> getTopTags({int limit = 10}) {
    final sortedEntries = _tagCounts.entries.toList();
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(sortedEntries.take(limit));
  }

  /// 获取平均每秒日志数
  double getEntriesPerSecond() {
    final duration = _lastEntryTime.difference(_startTime).inSeconds;
    return duration > 0 ? _totalEntries / duration : 0.0;
  }

  /// 重置统计
  void reset() {
    _levelCounts.clear();
    _sourceCounts.clear();
    _tagCounts.clear();
    _totalEntries = 0;
    _startTime = DateTime.now();
    _lastEntryTime = DateTime.now();
    
    _streamController?.add(this);
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'totalEntries': _totalEntries,
      'levelCounts': _levelCounts.map((k, v) => MapEntry(k.name, v)),
      'sourceCounts': _sourceCounts,
      'tagCounts': _tagCounts,
      'startTime': _startTime.toIso8601String(),
      'lastEntryTime': _lastEntryTime.toIso8601String(),
      'entriesPerSecond': getEntriesPerSecond(),
    };
  }
}