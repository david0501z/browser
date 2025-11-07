/// 代理模式枚举
enum ProxyMode {
  /// 规则模式
  rule,
  /// 全局模式
  global,
  /// 直连模式
  direct,
}

/// 日志级别枚举
enum LogLevel {
  /// 调试级别
  debug,
  /// 信息级别
  info,
  /// 警告级别
  warning,
  /// 错误级别
  error,
  /// 静默级别
  silent,
}

/// 代理类型枚举
enum ProxyType {
  /// VMess
  vmess,
  /// VLESS
  vless,
  /// Trojan
  trojan,
  /// Shadowsocks
  ss,
  /// ShadowsocksR
  ssr,
  /// SOCKS5
  socks5,
  /// HTTP
  http,
  /// TUIC
  tuic,
  /// HY2
  hy2,
}

/// 代理组类型枚举
enum ProxyGroupType {
  /// 选择组
  select,
  /// URL测试组
  urlTest,
  /// 负载均衡组
  loadBalance,
  /// 故障转移组
  fallback,
}

/// 配置类型枚举
enum ConfigType {
  /// Clash配置
  clash,
  /// Surge配置
  surge,
  /// 通用配置
  generic,
}