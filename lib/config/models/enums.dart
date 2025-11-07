/// 配置模块核心枚举定义
/// 
/// 包含ProxyMode, LogLevel, RuleType, RulePriority等核心枚举

/// 代理模式枚举
enum ProxyMode {
  /// 直连模式
  direct,
  /// 全局代理
  global,
  /// 规则代理
  rule,
  /// 绕过模式
  bypass,
  /// 绕过大陆
  bypassChina,
}

/// 日志级别枚举
enum LogLevel {
  /// 跟踪级别
  trace,
  /// 调试级别
  debug,
  /// 信息级别
  info,
  /// 警告级别
  warning,
  /// 错误级别
  error,
  /// 严重错误级别
  fatal,
  /// 静默模式
  silent,
}

/// 规则类型枚举
enum RuleType {
  /// 域名规则
  domain,
  /// URL规则
  url,
  /// IP地址规则
  ip,
  /// IP CIDR规则
  ipcidr,
  /// 端口规则
  port,
  /// 协议规则
  protocol,
  /// 通配符规则
  wildcard,
  /// 正则表达式规则
  regex,
  /// 地理位置IP规则
  geoip,
  /// 广告屏蔽规则
  adblock,
  /// 用户代理规则
  useragent,
  /// CIDR规则（别名）
  cidr,
  /// 自定义规则
  custom,
}

/// 规则优先级枚举
enum RulePriority {
  /// 高优先级
  high,
  /// 普通优先级
  normal,
  /// 低优先级
  low,
}