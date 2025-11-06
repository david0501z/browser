import 'log_level.dart';

/// 单条日志记录的数据模型
/// 包含日志的所有相关信息和元数据
class LogEntry {
  /// 日志级别
  final LogLevel level;

  /// 日志消息内容
  final String message;

  /// 日志来源（模块/类名）
  final String source;

  /// 日志标签（用于分类和过滤）
  final List<String> tags;

  /// 时间戳
  final DateTime timestamp;

  /// 线程ID
  final int threadId;

  /// 线程名称
  final String? threadName;

  /// 调用栈信息
  final List<StackTraceEntry>? stackTrace;

  /// 额外的上下文数据
  final Map<String, dynamic>? context;

  /// 异常对象（如果有）
  final Object? exception;

  /// 日志记录的唯一ID
  final String id;

  /// 构造函数
  LogEntry({
    required this.level,
    required this.message,
    required this.source,
    this.tags = const [],
    DateTime? timestamp,
    int? threadId,
    this.threadName,
    this.stackTrace,
    this.context,
    this.exception,
    String? id,
  }) : 
    timestamp = timestamp ?? DateTime.now(),
    threadId = threadId ?? _getCurrentThreadId(),
    id = id ?? _generateId();

  /// 生成唯一的日志ID
  static String _generateId() {
    return DateTime.now().microsecondsSinceEpoch.toString() + 
           '_' + _getCurrentThreadId().toString();
  }

  /// 获取当前线程ID
  static int _getCurrentThreadId() {
    // 在Flutter中，线程信息可能不可用，返回进程ID作为替代
    return DateTime.now().millisecondsSinceEpoch % 1000000;
  }

  /// 创建Verbose级别的日志条目
  factory LogEntry.verbose(
    String message, {
    String? source,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) {
    return LogEntry(
      level: LogLevel.verbose,
      message: message,
      source: source ?? 'Unknown',
      tags: tags ?? [],
      context: context,
    );
  }

  /// 创建Debug级别的日志条目
  factory LogEntry.debug(
    String message, {
    String? source,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) {
    return LogEntry(
      level: LogLevel.debug,
      message: message,
      source: source ?? 'Unknown',
      tags: tags ?? [],
      context: context,
    );
  }

  /// 创建Info级别的日志条目
  factory LogEntry.info(
    String message, {
    String? source,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) {
    return LogEntry(
      level: LogLevel.info,
      message: message,
      source: source ?? 'Unknown',
      tags: tags ?? [],
      context: context,
    );
  }

  /// 创建Warning级别的日志条目
  factory LogEntry.warning(
    String message, {
    String? source,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) {
    return LogEntry(
      level: LogLevel.warning,
      message: message,
      source: source ?? 'Unknown',
      tags: tags ?? [],
      context: context,
    );
  }

  /// 创建Error级别的日志条目
  factory LogEntry.error(
    String message, {
    String? source,
    Object? exception,
    StackTrace? stackTrace,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) {
    return LogEntry(
      level: LogLevel.error,
      message: message,
      source: source ?? 'Unknown',
      tags: tags ?? [],
      context: context,
      exception: exception,
      stackTrace: stackTrace != null;
        ? _parseStackTrace(stackTrace.toString())
        : null,
    );
  }

  /// 创建Critical级别的日志条目
  factory LogEntry.critical(
    String message, {
    String? source,
    Object? exception,
    StackTrace? stackTrace,
    List<String>? tags,
    Map<String, dynamic>? context,
  }) {
    return LogEntry(
      level: LogLevel.critical,
      message: message,
      source: source ?? 'Unknown',
      tags: tags ?? [],
      context: context,
      exception: exception,
      stackTrace: stackTrace != null;
        ? _parseStackTrace(stackTrace.toString())
        : null,
    );
  }

  /// 解析栈跟踪字符串
  static List<StackTraceEntry>? _parseStackTrace(String stackTrace) {
    final lines = stackTrace.split('\n');
    final entries = <StackTraceEntry>[];
    
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      
      final match = _stackTraceRegex.firstMatch(line);
      if (match != null) {
        entries.add(StackTraceEntry(
          file: match.group(1) ?? 'unknown',
          line: int.tryParse(match.group(2) ?? '0') ?? 0,
          method: match.group(3) ?? 'unknown',
          column: int.tryParse(match.group(4) ?? '0') ?? 0,
        ));
      }
    }
    
    return entries.isNotEmpty ? entries : null;
  }

  /// 栈跟踪正则表达式
  static final RegExp _stackTraceRegex = RegExp(
    r'#(\d+)\s+(.+?)\((.+?):(\d+):(\d+)\)',
  );

  /// 获取格式化的日志字符串
  String toFormattedString({
    bool showTimestamp = true,
    bool showThreadInfo = false,
    bool showStackTrace = false,
  }) {
    final buffer = StringBuffer();
    
    // 添加时间戳
    if (showTimestamp) {
      buffer.write('[');
      buffer.write(timestamp.toIso8601String());
      buffer.write('] ');
    }
    
    // 添加级别
    buffer.write('[');
    buffer.write(level.name);
    buffer.write('] ');
    
    // 添加来源
    buffer.write('[');
    buffer.write(source);
    buffer.write('] ');
    
    // 添加线程信息
    if (showThreadInfo && threadName != null) {
      buffer.write('[Thread:');
      buffer.write(threadName);
      buffer.write('] ');
    }
    
    // 添加消息
    buffer.write(message);
    
    // 添加标签
    if (tags.isNotEmpty) {
      buffer.write(' [Tags: ');
      buffer.write(tags.join(', '));
      buffer.write(']');
    }
    
    // 添加异常信息
    if (exception != null) {
      buffer.write('\nException: ');
      buffer.write(exception.toString());
    }
    
    // 添加栈跟踪
    if (showStackTrace && stackTrace != null) {
      buffer.write('\nStack Trace:');
      for (final entry in stackTrace!) {
        buffer.write('\n  ${entry.file}:${entry.line}:${entry.column} in ${entry.method}');
      }
    }
    
    // 添加上下文信息
    if (context != null && context!.isNotEmpty) {
      buffer.write('\nContext: ');
      buffer.write(context.toString());
    }
    
    return buffer.toString();
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level.name,
      'message': message,
      'source': source,
      'tags': tags,
      'timestamp': timestamp.toIso8601String(),
      'threadId': threadId,
      'threadName': threadName,
      'stackTrace': stackTrace?.map((e) => e.toJson()).toList(),
      'context': context,
      'exception': exception?.toString(),
    };
  }

  /// 从JSON创建日志条目
  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      id: json['id'] as String?,
      level: LogLevel.fromString(json['level'] as String),
      message: json['message'] as String,
      source: json['source'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      threadId: json['threadId'] as int,
      threadName: json['threadName'] as String?,
      stackTrace: json['stackTrace'] != null;
        ? (json['stackTrace'] as List<dynamic>)
            .map((e) => StackTraceEntry.fromJson(e as Map<String, dynamic>));
            .toList()
        : null,
      context: json['context'] as Map<String, dynamic>?,
      exception: json['exception'] != null ? json['exception'] as String : null,
    );
  }

  @override
  String toString() {
    return toFormattedString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LogEntry && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// 栈跟踪条目
class StackTraceEntry {
  /// 文件名
  final String file;

  /// 行号
  final int line;

  /// 列号
  final int column;

  /// 方法名
  final String method;

  const StackTraceEntry({
    required this.file,
    required this.line,
    required this.column,
    required this.method,
  });

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'line': line,
      'column': column,
      'method': method,
    };
  }

  /// 从JSON创建
  factory StackTraceEntry.fromJson(Map<String, dynamic> json) {
    return StackTraceEntry(
      file: json['file'] as String,
      line: json['line'] as int,
      column: json['column'] as int,
      method: json['method'] as String,
    );
  }

  @override
  String toString() {
    return '$file:$line:$column in $method';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StackTraceEntry &&
        other.file == file &&
        other.line == line &&
        other.column == column &&
        other.method == method;
  }

  @override
  int get hashCode {
    return file.hashCode ^ line.hashCode ^ column.hashCode ^ method.hashCode;
  }
}