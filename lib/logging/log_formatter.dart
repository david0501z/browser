import 'log_entry.dart';
import 'log_filter.dart';

/// 日志格式化器接口
abstract class LogFormatter {
  /// 格式化日志条目
  String format(LogEntry entry, LogFilter filter);
}

/// 默认日志格式化器
class DefaultLogFormatter implements LogFormatter {
  /// 构造函数
  const DefaultLogFormatter();

  @override
  String format(LogEntry entry, LogFilter filter) {
    final buffer = StringBuffer();
    
    // 时间戳
    if (filter.showTimestamp) {
      buffer.write('[');
      buffer.write(_formatTimestamp(entry.timestamp));
      buffer.write('] ');
    }
    
    // 日志级别
    buffer.write('[');
    buffer.write(entry.level.name);
    buffer.write('] ');
    
    // 来源
    buffer.write('[');
    buffer.write(entry.source);
    buffer.write('] ');
    
    // 线程信息
    if (filter.showThreadInfo && entry.threadName != null) {
      buffer.write('[Thread:');
      buffer.write(entry.threadName);
      buffer.write('] ');
    }
    
    // 消息
    buffer.write(entry.message);
    
    // 标签
    if (entry.tags.isNotEmpty) {
      buffer.write(' [Tags: ');
      buffer.write(entry.tags.join(', '));
      buffer.write(']');
    }
    
    // 异常信息
    if (entry.exception != null) {
      buffer.write('\nException: ');
      buffer.write(entry.exception.toString());
    }
    
    // 栈跟踪
    if (filter.showStackTrace && entry.stackTrace != null) {
      buffer.write('\nStack Trace:');
      for (final stackEntry in entry.stackTrace!) {
        buffer.write('\n  ');
        buffer.write(stackEntry.toString());
      }
    }
    
    // 上下文信息
    if (entry.context != null && entry.context!.isNotEmpty) {
      buffer.write('\nContext: ');
      buffer.write(_formatContext(entry.context!));
    }
    
    return buffer.toString();
  }

  /// 格式化时间戳
  String _formatTimestamp(DateTime timestamp) {
    // 格式: yyyy-MM-dd HH:mm:ss.SSS
    return '${timestamp.year.toString().padLeft(4, '0')}-'
           '${timestamp.month.toString().padLeft(2, '0')}-'
           '${timestamp.day.toString().padLeft(2, '0')} '
           '${timestamp.hour.toString().padLeft(2, '0')}:'
           '${timestamp.minute.toString().padLeft(2, '0')}:'
           '${timestamp.second.toString().padLeft(2, '0')}.'
           '${timestamp.millisecond.toString().padLeft(3, '0')}';
  }

  /// 格式化上下文信息
  String _formatContext(Map<String, dynamic> context) {
    if (context.isEmpty) return '';
    
    final parts = <String>[];
    for (final entry in context.entries) {
      parts.add('${entry.key}: ${entry.value}');
    }
    
    return '{${parts.join(', ')}}';
  }
}

/// 简洁日志格式化器
class SimpleLogFormatter implements LogFormatter {
  const SimpleLogFormatter();

  @override
  String format(LogEntry entry, LogFilter filter) {
    final buffer = StringBuffer();
    
    // 简化的时间戳
    if (filter.showTimestamp) {
      buffer.write('[');
      buffer.write(_formatSimpleTimestamp(entry.timestamp));
      buffer.write('] ');
    }
    
    // 简化的级别和来源
    buffer.write('[');
    buffer.write(_getShortLevelName(entry.level));
    buffer.write(' ');
    buffer.write(_getShortSourceName(entry.source));
    buffer.write('] ');
    
    // 消息
    buffer.write(entry.message);
    
    return buffer.toString();
  }

  /// 简化的时间戳格式
  String _formatSimpleTimestamp(DateTime timestamp) {
    // 格式: MM-dd HH:mm:ss
    return '${timestamp.month.toString().padLeft(2, '0')}-'
           '${timestamp.day.toString().padLeft(2, '0')} '
           '${timestamp.hour.toString().padLeft(2, '0')}:'
           '${timestamp.minute.toString().padLeft(2, '0')}:'
           '${timestamp.second.toString().padLeft(2, '0')}';
  }

  /// 获取简化的级别名称
  String _getShortLevelName(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return 'V';
      case LogLevel.debug:
        return 'D';
      case LogLevel.info:
        return 'I';
      case LogLevel.warning:
        return 'W';
      case LogLevel.error:
        return 'E';
      case LogLevel.critical:
        return 'C';
    }
  }

  /// 获取简化的来源名称
  String _getShortSourceName(String source) {
    // 取最后一个点后的部分作为简化名称
    final parts = source.split('.');
    return parts.isNotEmpty ? parts.last : source;
  }
}

/// JSON日志格式化器
class JsonLogFormatter implements LogFormatter {
  const JsonLogFormatter();

  @override
  String format(LogEntry entry, LogFilter filter) {
    return _formatJsonLog(entry);
  }

  /// 格式化JSON日志
  String _formatJsonLog(LogEntry entry) {
    return '${_encodeJson(entry.toJson())}\n';
  }

  /// 手动编码JSON（避免dart:convert依赖）
  String _encodeJson(Map<String, dynamic> json) {
    final buffer = StringBuffer();
    buffer.write('{');
    
    final entries = json.entries.toList();
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      buffer.write('"${entry.key}":');
      
      final value = entry.value;
      if (value == null) {
        buffer.write('null');
      } else if (value is String) {
        buffer.write('"${_escapeString(value)}"');
      } else if (value is num || value is bool) {
        buffer.write(value.toString());
      } else if (value is List) {
        buffer.write(_encodeList(value));
      } else if (value is Map) {
buffer.write(_encodeJson(Map<String, dynamic>.from(value));
      } else {
        buffer.write('"${_escapeString(value.toString())}"');
      }
      
      if (i < entries.length - 1) {
        buffer.write(',');
      }
    }
    
    buffer.write('}');
    return buffer.toString();
  }

  /// 编码列表
  String _encodeList(List<dynamic> list) {
    final buffer = StringBuffer();
    buffer.write('[');
    
    for (var i = 0; i < list.length; i++) {
      final value = list[i];
      if (value == null) {
        buffer.write('null');
      } else if (value is String) {
        buffer.write('"${_escapeString(value)}"');
      } else if (value is num || value is bool) {
        buffer.write(value.toString());
      } else if (value is List) {
        buffer.write(_encodeList(value));
      } else if (value is Map) {
buffer.write(_encodeJson(Map<String, dynamic>.from(value));
      } else {
        buffer.write('"${_escapeString(value.toString())}"');
      }
      
      if (i < list.length - 1) {
        buffer.write(',');
      }
    }
    
    buffer.write(']');
    return buffer.toString();
  }

  /// 转义字符串
  String _escapeString(String str) {
    return str
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }
}

/// 彩色日志格式化器（用于控制台输出）
class ColoredLogFormatter implements LogFormatter {
  const ColoredLogFormatter();

  @override
  String format(LogEntry entry, LogFilter filter) {
    final buffer = StringBuffer();
    
    // 添加颜色代码
    final colorCode = _getColorCode(entry.level);
    buffer.write(colorCode);
    
    // 时间戳
    if (filter.showTimestamp) {
      buffer.write('[');
      buffer.write(_formatTimestamp(entry.timestamp));
      buffer.write('] ');
    }
    
    // 级别（带颜色）
    buffer.write('[');
    buffer.write(_getColoredLevelName(entry.level));
    buffer.write('] ');
    
    // 来源
    buffer.write('[');
    buffer.write(entry.source);
    buffer.write('] ');
    
    // 消息
    buffer.write(entry.message);
    
    // 标签
    if (entry.tags.isNotEmpty) {
      buffer.write(' [\x1b[36mTags: ');
      buffer.write(entry.tags.join(', '));
      buffer.write('\x1b[0m]');
    }
    
    // 异常信息
    if (entry.exception != null) {
      buffer.write('\n\x1b[31mException: ');
      buffer.write(entry.exception.toString());
      buffer.write('\x1b[0m');
    }
    
    // 栈跟踪
    if (filter.showStackTrace && entry.stackTrace != null) {
      buffer.write('\n\x1b[33mStack Trace:\x1b[0m');
      for (final stackEntry in entry.stackTrace!) {
        buffer.write('\n  ');
        buffer.write(stackEntry.toString());
      }
    }
    
    // 重置颜色
    buffer.write('\x1b[0m');
    
    return buffer.toString();
  }

  /// 获取颜色代码
  String _getColorCode(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return '\x1b[90m'; // 灰色
      case LogLevel.debug:
        return '\x1b[34m'; // 蓝色
      case LogLevel.info:
        return '\x1b[32m'; // 绿色
      case LogLevel.warning:
        return '\x1b[33m'; // 黄色
      case LogLevel.error:
        return '\x1b[31m'; // 红色
      case LogLevel.critical:
        return '\x1b[35m'; // 紫色
    }
  }

  /// 获取带颜色的级别名称
  String _getColoredLevelName(LogLevel level) {
    final colorCode = _getColorCode(level);
    return '$colorCode${level.name}\x1b[0m';
  }

  /// 格式化时间戳
  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
           '${timestamp.minute.toString().padLeft(2, '0')}:'
           '${timestamp.second.toString().padLeft(2, '0')}.'
           '${timestamp.millisecond.toString().padLeft(3, '0')}';
  }
}

/// 自定义日志格式化器
class CustomLogFormatter implements LogFormatter {
  final String Function(LogEntry entry, LogFilter filter) _formatFunction;

  const CustomLogFormatter(this._formatFunction);

  @override
  String format(LogEntry entry, LogFilter filter) {
    return _formatFunction(entry, filter);
  }
}