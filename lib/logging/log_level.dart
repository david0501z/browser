/// 日志级别枚举定义
/// 包含所有日志级别，从最低级（VERBOSE）到最高级（ERROR）
enum LogLevel {
  /// 最详细的日志信息，用于调试目的
  verbose(0),
  
  /// 调试信息，开发者调试时使用
  debug(1),
  
  /// 一般信息，重要业务信息
  info(2),
  
  /// 警告信息，可能存在问题但不影响运行
  warning(3),
  
  /// 错误信息，已经发生错误但应用仍可继续运行
  error(4),
  
  /// 严重错误，应用可能崩溃或无法正常运行
  critical(5);

  const LogLevel(this.value);

  /// 日志级别的数值，用于比较和过滤
  final int value;

  /// 获取日志级别的字符串表示
  String get name {
    switch (this) {
      case LogLevel.verbose:
        return 'VERBOSE';
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.critical:
        return 'CRITICAL';
    }
  }

  /// 获取日志级别的颜色代码（用于UI显示）
  String get colorCode {
    switch (this) {
      case LogLevel.verbose:
        return '#9E9E9E'; // 灰色
      case LogLevel.debug:
        return '#2196F3'; // 蓝色
      case LogLevel.info:
        return '#4CAF50'; // 绿色
      case LogLevel.warning:
        return '#FF9800'; // 橙色
      case LogLevel.error:
        return '#F44336'; // 红色
      case LogLevel.critical:
        return '#9C27B0'; // 紫色
    }
  }

  /// 根据字符串值获取对应的LogLevel
  static LogLevel fromString(String level) {
    switch (level.toUpperCase()) {
      case 'VERBOSE':
        return LogLevel.verbose;
      case 'DEBUG':
        return LogLevel.debug;
      case 'INFO':
        return LogLevel.info;
      case 'WARNING':
        return LogLevel.warning;
      case 'ERROR':
        return LogLevel.error;
      case 'CRITICAL':
        return LogLevel.critical;
      default:
        return LogLevel.info;
    }
  }

  /// 获取所有日志级别列表
  static List<LogLevel> get allValues => LogLevel.values;

  /// 检查当前级别是否应该被记录（根据最小记录级别）
  bool shouldLog(LogLevel minimumLevel) {
    return value >= minimumLevel.value;
  }
}

/// 日志过滤器配置
class LogFilter {
  /// 最小记录级别
  final LogLevel minimumLevel;

  /// 是否启用来源过滤
  final bool enableSourceFilter;

  /// 允许的日志来源（如果启用来源过滤）
  final Set<String> allowedSources;

  /// 禁止的日志来源
  final Set<String> blockedSources;

  /// 是否启用标签过滤
  final bool enableTagFilter;

  /// 允许的日志标签
  final Set<String> allowedTags;

  /// 是否显示时间戳
  final bool showTimestamp;

  /// 是否显示线程信息
  final bool showThreadInfo;

  /// 是否显示调用栈
  final bool showStackTrace;

  const LogFilter({
    this.minimumLevel = LogLevel.info,
    this.enableSourceFilter = false,
    this.allowedSources = const {},
    this.blockedSources = const {},
    this.enableTagFilter = false,
    this.allowedTags = const {},
    this.showTimestamp = true,
    this.showThreadInfo = false,
    this.showStackTrace = false,
  });

  /// 检查是否应该记录某条日志
  bool shouldLog(LogEntry entry) {
    // 检查级别过滤
    if (!entry.level.shouldLog(minimumLevel)) {
      return false;
    }

    // 检查来源过滤
    if (enableSourceFilter && allowedSources.isNotEmpty) {
      if (!allowedSources.contains(entry.source)) {
        return false;
      }
    }

    if (blockedSources.contains(entry.source)) {
      return false;
    }

    // 检查标签过滤
    if (enableTagFilter && allowedTags.isNotEmpty) {
      if (!entry.tags.any((tag) => allowedTags.contains(tag))) {
        return false;
      }
    }

    return true;
  }

  /// 创建过滤器副本并更新指定属性
  LogFilter copyWith({
    LogLevel? minimumLevel,
    bool? enableSourceFilter,
    Set<String>? allowedSources,
    Set<String>? blockedSources,
    bool? enableTagFilter,
    Set<String>? allowedTags,
    bool? showTimestamp,
    bool? showThreadInfo,
    bool? showStackTrace,
  }) {
    return LogFilter(
      minimumLevel: minimumLevel ?? this.minimumLevel,
      enableSourceFilter: enableSourceFilter ?? this.enableSourceFilter,
      allowedSources: allowedSources ?? this.allowedSources,
      blockedSources: blockedSources ?? this.blockedSources,
      enableTagFilter: enableTagFilter ?? this.enableTagFilter,
      allowedTags: allowedTags ?? this.allowedTags,
      showTimestamp: showTimestamp ?? this.showTimestamp,
      showThreadInfo: showThreadInfo ?? this.showThreadInfo,
      showStackTrace: showStackTrace ?? this.showStackTrace,
    );
  }
}