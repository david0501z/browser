/// 代理系统常量定义
/// 包含各种常量和默认值

/// 代理服务常量
class ProxyConstants {
  ProxyConstants._();

  /// 默认配置值
  static const int defaultPort = 7890;
  static const String defaultListenAddress = '127.0.0.1';
  static const String defaultPrimaryDNS = '1.1.1.1';
  static const String defaultSecondaryDNS = '8.8.8.8';
  static const int defaultConnectionTimeout = 30;
  static const int defaultReadTimeout = 60;
  static const int defaultRetryCount = 3;
  static const String defaultLogLevel = 'info';
  static const String defaultLogPath = '/tmp/proxy.log';
  static const int defaultStatsInterval = 60;

  /// 端口范围限制
  static const int minPort = 1024;
  static const int maxPort = 65535;

  /// 连接状态常量
  static const int statusDisconnected = 0;
  static const int statusConnecting = 1;
  static const int statusConnected = 2;
  static const int statusDisconnecting = 3;
  static const int statusError = 4;

  /// 错误码常量
  static const int errorNone = 0;
  static const int errorUnknown = 1;
  static const int errorInvalidConfig = 2;
  static const int errorConnectionFailed = 3;
  static const int errorAuthentication = 4;
  static const int errorTimeout = 5;
  static const int errorNetworkUnavailable = 6;
  static const int errorServerUnavailable = 7;

  /// 性能阈值常量
  static const int slowSpeedThreshold = 100 * 1024; // 100KB/s
  static const int normalSpeedThreshold = 1024 * 1024; // 1MB/s
  static const int fastSpeedThreshold = 10 * 1024 * 1024; // 10MB/s
  static const int maxLatency = 5000; // 5秒
  static const int minLatency = 0;

  /// 统计常量
  static const int maxHistoryRetentionDays = 30;
  static const int defaultHistoryRetentionDays = 7;
  static const int maxTrafficAlertThreshold = 10240; // 10GB
  static const int minTrafficAlertThreshold = 1; // 1MB
  static const int maxConnectionAttempts = 10;

  /// FFI库名常量
  static const String androidLibraryName = 'libproxycore.so';
  static const String iosLibraryName = 'libproxycore.dylib';

  /// 配置文件常量
  static const String configFileName = 'proxy_config.json';
  static const String nodesFileName = 'proxy_nodes.json';
  static const String rulesFileName = 'proxy_rules.json';
  static const String statsFileName = 'proxy_stats.json';

  /// 日志常量
  static const List<String> validLogLevels = ['debug', 'info', 'warning', 'error', 'fatal'];
  static const String defaultLogFormat = '[{timestamp}] [{level}] {message}';

  /// API常量
  static const String apiVersion = 'v1';
  static const int defaultApiTimeout = 10;

  /// 缓存常量
  static const int cacheExpirationTime = 300; // 5分钟
  static const int maxCacheSize = 100;

  /// 规则常量
  static const int maxRuleCount = 1000;
  static const int defaultRulePriority = 0;
  static const int maxRulePriority = 100;

  /// 节点常量
  static const int maxNodeCount = 100;
  static const int defaultLatency = 0;
  static const int maxLatency = 30000; // 30秒
  static const int maxBandwidth = 1000000; // 1Gbps

  /// 网络常量
  static const int maxConnectionTimeout = 300; // 5分钟
  static const int minConnectionTimeout = 1; // 1秒
  static const int maxReadTimeout = 600; // 10分钟
  static const int minReadTimeout = 1; // 1秒
  static const int maxRetryCount = 10;
  static const int minRetryCount = 0;

  /// 流量常量
  static const int bytesInKB = 1024;
  static const int bytesInMB = 1024 * 1024;
  static const int bytesInGB = 1024 * 1024 * 1024;
  static const int bytesInTB = 1024 * 1024 * 1024 * 1024;

  /// 时间常量
  static const int secondsInMinute = 60;
  static const int secondsInHour = 3600;
  static const int secondsInDay = 86400;
  static const int millisecondsInSecond = 1000;

  /// 文件路径常量
  static const String defaultConfigPath = '/etc/proxy/config.json';
  static const String defaultLogFile = '/var/log/proxy.log';
  static const String defaultDataPath = '/var/lib/proxy';
  static const String defaultCachePath = '/tmp/proxy/cache';
}

/// 代理状态常量
class ProxyStateConstants {
  ProxyStateConstants._();

  /// 状态更新间隔
  static const int statusUpdateInterval = 1000; // 1秒
  static const int statsUpdateInterval = 5000; // 5秒

  /// 状态历史记录数量
  static const int maxStateHistoryCount = 100;

  /// 连接状态变化监听器数量
  static const int maxStateListeners = 20;

  /// 状态同步间隔
  static const int stateSyncInterval = 30000; // 30秒
}

/// 流量统计常量
class TrafficStatsConstants {
  TrafficStatsConstants._();

  /// 统计更新间隔
  static const int statsUpdateInterval = 60000; // 1分钟

  /// 实时统计缓存大小
  static const int realtimeCacheSize = 60; // 1小时

  /// 历史记录缓存大小
  static const int historyCacheSize = 1440; // 24小时

  /// 统计数据类型
  static const String typeRealtime = 'realtime';
  static const String typeHourly = 'hourly';
  static const String typeDaily = 'daily';
  static const String typeMonthly = 'monthly';
}

/// 网络配置常量
class NetworkConstants {
  NetworkConstants._();

  /// TCP连接参数
  static const int tcpKeepAlive = 1;
  static const int tcpNoDelay = 1;
  static const int tcpKeepAliveTime = 600; // 10分钟
  static const int tcpKeepAliveInterval = 60; // 1分钟
  static const int tcpKeepAliveProbes = 3;

  /// UDP连接参数
  static const int udpBufferSize = 65535;
  static const int udpTimeout = 30; // 30秒

  /// HTTP连接参数
  static const int httpConnectionPool = 10;
  static const int httpKeepAlive = 30; // 30秒
  static const int httpMaxRedirects = 3;
  static const int httpUserAgentLength = 255;

  /// SOCKS连接参数
  static const int socksVersion = 5;
  static const int socksMaxAttempts = 3;
  static const int socksTimeout = 15; // 15秒

  /// 连接池参数
  static const int connectionPoolSize = 32;
  static const int connectionPoolIdleTimeout = 300; // 5分钟
  static const int connectionPoolMaxIdle = 8;
}

/// 安全配置常量
class SecurityConstants {
  SecurityConstants._();

  /// 加密算法
  static const String aes128Cbc = 'AES-128-CBC';
  static const String aes256Cbc = 'AES-256-CBC';
  static const String aes256Gcm = 'AES-256-GCM';
  static const String chacha20Poly1305 = 'ChaCha20-Poly1305';

  /// 证书验证
  static const bool verifyCertificate = true;
  static const bool allowSelfSignedCertificate = false;
  static const bool allowInsecureConnection = false;

  /// 认证超时
  static const int authTimeout = 10; // 10秒
  static const int tokenRefreshInterval = 3600; // 1小时
  static const int tokenExpireBuffer = 300; // 5分钟

  /// 安全头部
  static const List<String> securityHeaders = [
    'X-Requested-With',
    'X-Forwarded-For',
    'X-Forwarded-Proto',
    'X-Real-IP',
  ];
}

/// 日志常量
class LogConstants {
  LogConstants._();

  /// 日志级别常量
  static const String levelDebug = 'DEBUG';
  static const String levelInfo = 'INFO';
  static const String levelWarning = 'WARNING';
  static const String levelError = 'ERROR';
  static const String levelFatal = 'FATAL';

  /// 日志文件大小限制
  static const int maxLogFileSize = 100 * 1024 * 1024; // 100MB
  static const int maxLogFileCount = 10;

  /// 日志格式模板
  static const String timestampFormat = 'yyyy-MM-dd HH:mm:ss.SSS';
  static const String logFormat = '[$timestamp] [$level] [$component] $message';

  /// 日志组件常量
  static const String componentCore = 'CORE';
  static const String componentBridge = 'BRIDGE';
  static const String componentNetwork = 'NETWORK';
  static const String componentSecurity = 'SECURITY';
  static const String componentStats = 'STATS';
}

/// 错误消息常量
class ErrorMessages {
  ErrorMessages._();

  /// 系统错误
  static const String initializationFailed = '系统初始化失败';
  static const String libraryNotFound = '找不到原生库';
  static const String invalidConfiguration = '配置无效';
  static const String networkUnavailable = '网络不可用';
  static const String serviceUnavailable = '服务不可用';

  /// 连接错误
  static const String connectionFailed = '连接失败';
  static const String connectionTimeout = '连接超时';
  static const String authenticationFailed = '认证失败';
  static const String invalidCredentials = '凭据无效';

  /// 配置错误
  static const String invalidPort = '端口号无效';
  static const String invalidIP = 'IP地址无效';
  static const String invalidDNS = 'DNS地址无效';
  static const String invalidNode = '节点配置无效';

  /// 通用错误
  static const String operationNotSupported = '不支持的操作';
  static const String resourceNotFound = '资源未找到';
  static const String permissionDenied = '权限被拒绝';
  static const String unknownError = '未知错误';
}

/// 成功消息常量
class SuccessMessages {
  SuccessMessages._();

  /// 操作成功
  static const String initializationSuccess = '系统初始化成功';
  static const String connectionSuccess = '连接成功';
  static const String disconnectionSuccess = '断开连接成功';
  static const String configurationSuccess = '配置成功';
  static const String nodeSwitchSuccess = '节点切换成功';
  static const String operationSuccess = '操作成功';
}

/// 正则表达式常量
class RegexPatterns {
  RegexPatterns._();

  /// IP地址正则
  static const String ipAddress = r'^([0-9]{1,3}\.){3}[0-9]{1,3}$';

  /// 端口号正则
  static const String port = r'^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$';

  /// 域名正则
  static const String domain = r'^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$';

  /// URL正则
  static const String url = r'^https?:\/\/([^\s$.?#].[^\s]*)$';

  /// 配置文件正则
  static const String configFile = r'^[\w\-]+(\.json)?$';

  /// 日志级别正则
  static const String logLevel = r'^(DEBUG|INFO|WARNING|ERROR|FATAL)$';
}