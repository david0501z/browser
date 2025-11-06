/// 代理系统类型定义
/// 定义各种枚举和基础类型

/// 代理协议类型
enum ProxyProtocol {
  http,
  https,
  socks5,
  socks4,
}

/// 代理认证类型
enum AuthType {
  none,
  username,
  certificate,
  token,
}

/// 代理日志级别
enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

/// 连接状态
enum ConnectionStatus {
  idle,
  connecting,
  connected,
  reconnecting,
  disconnected,
  error,
}

/// 网络状态
enum NetworkStatus {
  offline,
  wifi,
  cellular,
  ethernet,
  vpn,
}

/// 流量统计单位
enum TrafficUnit {
  bytes,
  kb,
  mb,
  gb,
  tb,
}

/// 速度单位
enum SpeedUnit {
  bps,
  kbps,
  mbps,
  gbps,
}

/// 时间单位
enum TimeUnit {
  seconds,
  minutes,
  hours,
  days,
}

/// 消息类型
enum MessageType {
  info,
  warning,
  error,
  success,
}

/// 操作类型
enum OperationType {
  connect,
  disconnect,
  switchNode,
  updateConfig,
  getStatus,
  getStats,
}

/// 错误类型
enum ErrorType {
  connection,
  authentication,
  configuration,
  network,
  system,
  unknown,
}

/// 验证结果
enum ValidationResult {
  valid,
  invalid,
  warning,
  pending,
}

/// 节点类型
enum NodeType {
  /// 免费节点
  free,
  /// 付费节点
  premium,
  /// 自建节点
  custom,
  /// 共享节点
  shared,
}

/// 连接协议
enum ConnectionProtocol {
  tcp,
  udp,
  http2,
  quic,
}

/// 加密类型
enum EncryptionType {
  none,
  aes128,
  aes192,
  aes256,
  rc4,
  chacha20,
}

/// 压缩类型
enum CompressionType {
  none,
  gzip,
  deflate,
  brotli,
}

/// 代理模式
enum ProxyMode {
  /// 直连模式
  direct,
  /// 全局代理
  global,
  /// 规则代理
  rules,
  /// 绕过大陆
  bypassChina,
}

/// 路由规则
enum RouteRule {
  /// 绕过局域网
  bypassLan,
  /// 绕过中国大陆
  bypassChina,
  /// 绕过私有地址
  bypassPrivate,
  /// 绕过广告
  bypassAds,
  /// 绕过代理
  bypassProxy,
}

/// 地理区域
enum GeographicRegion {
  /// 亚洲
  asia,
  /// 北美
  northAmerica,
  /// 欧洲
  europe,
  /// 南美
  southAmerica,
  /// 非洲
  africa,
  /// 大洋洲
  oceania,
}

/// 服务器类型
enum ServerType {
  /// 虚拟服务器
  vps,
  /// 云服务器
  cloud,
  /// 物理服务器
  dedicated,
  /// 共享服务器
  shared,
}

/// 性能指标
enum PerformanceMetric {
  /// 延迟
  latency,
  /// 丢包率
  packetLoss,
  /// 速度
  speed,
  /// 稳定性
  stability,
  /// 可用性
  availability,
}

/// 通知类型
enum NotificationType {
  /// 连接成功
  connectionSuccess,
  /// 连接失败
  connectionFailed,
  /// 节点切换
  nodeSwitch,
  /// 流量警告
  trafficAlert,
  /// 系统通知
  systemMessage,
}

/// 系统事件类型
enum SystemEventType {
  /// 启动应用
  appStart,
  /// 启动服务
  serviceStart,
  /// 停止服务
  serviceStop,
  /// 应用退出
  appExit,
  /// 网络切换
  networkChanged,
  /// 配置更新
  configUpdated,
}

/// API响应类型
enum ApiResponseType {
  success,
  error,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  serverError,
}

/// 数据同步类型
enum SyncType {
  /// 同步配置
  config,
  /// 同步节点
  nodes,
  /// 同步规则
  rules,
  /// 同步统计数据
  stats,
}

/// 缓存类型
enum CacheType {
  /// 节点缓存
  nodes,
  /// 配置缓存
  config,
  /// 统计数据缓存
  stats,
  /// 用户数据缓存
  userData,
}

/// 日志类型
enum LogType {
  /// 系统日志
  system,
  /// 连接日志
  connection,
  /// 错误日志
  error,
  /// 性能日志
  performance,
  /// 安全日志
  security,
}

/// 配置文件类型
enum ConfigFileType {
  /// 主配置文件
  main,
  /// 节点配置
  nodes,
  /// 规则配置
  rules,
  /// 用户配置
  user,
}

/// 安全级别
enum SecurityLevel {
  /// 低级
  low,
  /// 中级
  medium,
  /// 高级
  high,
  /// 最高
  critical,
}