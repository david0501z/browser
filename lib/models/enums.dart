/// 枚举类型定义文件
/// 
/// 包含应用中使用的枚举类型定义。

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
}

/// 云服务类型枚举
enum CloudService {
  /// 阿里云OSS
  aliyun,
  
  /// 腾讯云COS
  tencent,
  
  /// 百度云BOS
  baidu,
  
  /// 华为云OBS
  huawei,
  
  /// AWS S3
  aws,
}

/// 缓存模式枚举
enum CacheMode {
  /// 默认缓存
  defaultCache,
  
  /// 忽略缓存
  ignore,
  
  /// 强制缓存
  force,
}

/// 字体大小枚举
enum FontSize {
  /// 小号
  small,
  
  /// 中号
  medium,
  
  /// 大号
  large,
}

/// 主题模式枚举
enum ThemeMode {
  /// 浅色主题
  light,
  
  /// 深色主题
  dark,
  
  /// 系统自动
  system,
}

/// 语言设置枚举
enum Language {
  /// 中文简体
  zhCN,
  
  /// 中文繁体
  zhTW,
  
  /// 英语
  en,
  
  /// 日语
  ja,
  
  /// 韩语
  ko,
}

/// 网络状态枚举
enum NetworkStatus {
  /// 已连接
  connected,
  
  /// 连接中
  connecting,
  
  /// 断开连接
  disconnected,
  
  /// 网络错误
  error,
}

/// 下载状态枚举
enum DownloadStatus {
  /// 等待中
  pending,
  
  /// 下载中
  downloading,
  
  /// 已完成
  completed,
  
  /// 已取消
  cancelled,
  
  /// 下载失败
  failed,
}

/// 浏览器状态枚举
enum BrowserStatus {
  /// 空闲状态
  idle,
  
  /// 加载中
  loading,
  
  /// 已加载
  loaded,
  
  /// 错误状态
  error,
}

/// 搜索类型枚举
enum SearchType {
  /// 标题搜索
  title,
  
  /// URL搜索
  url,
  
  /// 内容搜索
  content,
  
  /// 标签搜索
  tag,
}

/// 排序方式枚举
enum SortOrder {
  /// 升序
  ascending,
  
  /// 降序
  descending,
  
  /// 按时间排序
  byTime,
  
  /// 按名称排序
  byName,
}

/// 数据加密类型枚举
enum EncryptionType {
  /// 无加密
  none,
  
  /// AES加密
  aes,
  
  /// RSA加密
  rsa,
}

/// 性能监控级别枚举
enum PerformanceLevel {
  /// 关闭
  off,
  
  /// 低级别
  low,
  
  /// 中级别
  medium,
  
  /// 高级别
  high,
}

/// 通知类型枚举
enum NotificationType {
  /// 连接状态通知
  connection,
  
  /// 更新通知
  update,
  
  /// 错误通知
  error,
  
  /// 下载通知
  download,
}

/// 用户偏好设置枚举
enum UserPreference {
  /// 记住密码
  rememberPassword,
  
  /// 自动登录
  autoLogin,
  
  /// 同步设置
  syncSettings,
  
  /// 发送使用统计
  sendAnalytics,
}

/// 网络协议枚举
enum NetworkProtocol {
  /// HTTP
  http,
  
  /// HTTPS
  https,
  
  /// WebSocket
  websocket,
  
  /// SOCKS5
  socks5,
}

/// 地理位置枚举
enum GeoLocation {
  /// 中国大陆
  china,
  
  /// 中国香港
  hongkong,
  
  /// 中国台湾
  taiwan,
  
  /// 美国
  usa,
  
  /// 日本
  japan,
}

/// 安全级别枚举
enum SecurityLevel {
  /// 低级别
  low,
  
  /// 中级别
  medium,
  
  /// 高级别
  high,
}

/// 备份频率枚举
enum BackupFrequency {
  /// 手动备份
  manual,
  
  /// 每日备份
  daily,
  
  /// 每周备份
  weekly,
  
  /// 每月备份
  monthly,
}

/// 数据清理类型枚举
enum CleanupType {
  /// 清理缓存
  cache,
  
  /// 清理Cookie
  cookies,
  
  /// 清理历史记录
  history,
  
  /// 清理下载记录
  downloads,
}

/// 应用状态枚举
enum AppStatus {
  /// 未初始化
  uninitialized,
  
  /// 初始化中
  initializing,
  
  /// 已就绪
  ready,
  
  /// 运行中
  running,
}

/// 设备类型枚举
enum DeviceType {
  /// 手机
  mobile,
  
  /// 平板
  tablet,
  
  /// 桌面
  desktop,
  
  /// 电视
  tv,
}

/// 操作系统枚举
enum OperatingSystem {
  /// Android
  android,
  
  /// iOS
  ios,
  
  /// Windows
  windows,
  
  /// macOS
  macos,
  
  /// Linux
  linux,
}

/// 浏览器引擎枚举
enum BrowserEngine {
  /// WebKit
  webkit,
  
  /// Blink
  blink,
  
  /// Gecko
  gecko,
  
  /// EdgeHTML
  edgehtml,
}

/// 网络连接类型枚举
enum ConnectionType {
  /// WiFi
  wifi,
  
  /// 移动网络
  mobile,
  
  /// 以太网
  ethernet,
  
  /// 蓝牙
  bluetooth,
}

/// 电源状态枚举
enum PowerState {
  /// 充电中
  charging,
  
  /// 电池供电
  battery,
  
  /// 低电量
  lowBattery,
  
  /// 省电模式
  powerSave,
}

/// 存储类型枚举
enum StorageType {
  /// 内部存储
  internal,
  
  /// 外部存储
  external,
  
  /// 云存储
  cloud,
  
  /// 缓存存储
  cache,
}

/// 文件类型枚举
enum FileType {
  /// 文档
  document,
  
  /// 图片
  image,
  
  /// 视频
  video,
  
  /// 音频
  audio,
  
  /// 压缩包
  archive,
}

/// 权限类型枚举
enum PermissionType {
  /// 网络权限
  network,
  
  /// 存储权限
  storage,
  
  /// 相机权限
  camera,
  
  /// 麦克风权限
  microphone,
  
  /// 位置权限
  location,
}

/// 更新类型枚举
enum UpdateType {
  /// 检查更新
  check,
  
  /// 下载更新
  download,
  
  /// 安装更新
  install,
  
  /// 回滚更新
  rollback,
}

/// 错误类型枚举
enum ErrorType {
  /// 网络错误
  network,
  
  /// 认证错误
  authentication,
  
  /// 权限错误
  permission,
  
  /// 配置错误
  configuration,
  
  /// 数据错误
  data,
}

/// 日志类型枚举
enum LogType {
  /// 访问日志
  access,
  
  /// 错误日志
  error,
  
  /// 调试日志
  debug,
  
  /// 性能日志
  performance,
  
  /// 安全日志
  security,
}

/// 配置源枚举
enum ConfigSource {
  /// 默认配置
  defaultConfig,
  
  /// 用户配置
  userConfig,
  
  /// 云端配置
  cloudConfig,
  
  /// 导入配置
  importedConfig,
}

/// 验证状态枚举
enum ValidationState {
  /// 未验证
  unvalidated,
  
  /// 验证中
  validating,
  
  /// 验证通过
  valid,
  
  /// 验证失败
  invalid,
}

/// 同步状态枚举
enum SyncState {
  /// 未同步
  unsynced,
  
  /// 同步中
  syncing,
  
  /// 已同步
  synced,
  
  /// 同步失败
  syncFailed,
}

/// 部署状态枚举
enum DeploymentState {
  /// 未部署
  undeployed,
  
  /// 部署中
  deploying,
  
  /// 已部署
  deployed,
  
  /// 部署失败
  deploymentFailed,
}

/// 监控状态枚举
enum MonitoringState {
  /// 未监控
  unmonitored,
  
  /// 监控中
  monitoring,
  
  /// 已监控
  monitored,
  
  /// 监控异常
  monitoringError,
}

/// 压缩类型枚举
enum CompressionType {
  /// 无压缩
  none,
  
  /// GZIP压缩
  gzip,
  
  /// Deflate压缩
  deflate,
  
  /// Brotli压缩
  brotli,
}

/// 编码类型枚举
enum EncodingType {
  /// UTF-8编码
  utf8,
  
  /// UTF-16编码
  utf16,
  
  /// ASCII编码
  ascii,
  
  /// Base64编码
  base64,
}

/// 哈希算法枚举
enum HashAlgorithm {
  /// MD5
  md5,
  
  /// SHA1
  sha1,
  
  /// SHA256
  sha256,
  
  /// SHA512
  sha512,
}

/// 证书类型枚举
enum CertificateType {
  /// 自签名证书
  selfSigned,
  
  /// CA证书
  ca,
  
  /// 客户端证书
  client,
  
  /// 服务器证书
  server,
}

/// 密钥长度枚举
enum KeyLength {
  /// 128位
  bit128,
  
  /// 192位
  bit192,
  
  /// 256位
  bit256,
  
  /// 512位
  bit512,
}

/// 签名算法枚举
enum SignatureAlgorithm {
  /// RSA
  rsa,
  
  /// ECDSA
  ecdsa,
  
  /// DSA
  dsa,
  
  /// EdDSA
  eddsa,
}

/// 密钥交换算法枚举
enum KeyExchangeAlgorithm {
  /// RSA
  rsa,
  
  /// Diffie-Hellman
  dh,
  
  /// Elliptic Curve Diffie-Hellman
  ecdh,
}

/// 加密模式枚举
enum CipherMode {
  /// 电子密码本模式
  ecb,
  
  /// 密码分组链接模式
  cbc,
  
  /// 密码反馈模式
  cfb,
  
  /// 输出反馈模式
  ofb,
  
  /// 计数器模式
  ctr,
}

/// 填充方式枚举
enum PaddingType {
  /// PKCS7填充
  pkcs7,
  
  /// PKCS1填充
  pkcs1,
  
  /// Zero填充
  zero,
  
  /// 无填充
  noPadding,
}

/// 消息认证码算法枚举
enum MacAlgorithm {
  /// HMAC-MD5
  hmacMd5,
  
  /// HMAC-SHA1
  hmacSha1,
  
  /// HMAC-SHA256
  hmacSha256,
  
  /// HMAC-SHA512
  hmacSha512,
}

/// 随机数生成器类型枚举
enum RandomGeneratorType {
  /// 系统随机数生成器
  system,
  
  /// 伪随机数生成器
  pseudo,
  
  /// 密码学安全随机数生成器
  crypto,
}

/// 密钥派生函数枚举
enum KeyDerivationFunction {
  /// PBKDF2
  pbkdf2,
  
  /// Scrypt
  scrypt,
  
  /// Argon2
  argon2,
  
  /// bcrypt
  bcrypt,
}

/// 证书验证结果枚举
enum CertificateValidationResult {
  /// 验证通过
  valid,
  
  /// 证书过期
  expired,
  
  /// 证书撤销
  revoked,
  
  /// 证书格式错误
  malformed,
  
  /// 信任链错误
  chainError,
}

/// 协议版本枚举
enum ProtocolVersion {
  /// HTTP/1.0
  http10,
  
  /// HTTP/1.1
  http11,
  
  /// HTTP/2.0
  http2,
  
  /// HTTP/3.0
  http3,
  
  /// TLS 1.2
  tls12,
  
  /// TLS 1.3
  tls13,
}

/// 内容类型枚举
enum ContentType {
  /// HTML
  html,
  
  /// CSS
  css,
  
  /// JavaScript
  javascript,
  
  /// JSON
  json,
  
  /// XML
  xml,
  
  /// 纯文本
  text,
}

/// HTTP方法枚举
enum HttpMethod {
  /// GET
  get,
  
  /// POST
  post,
  
  /// PUT
  put,
  
  /// DELETE
  delete,
  
  /// PATCH
  patch,
  
  /// HEAD
  head,
  
  /// OPTIONS
  options,
}

/// HTTP状态码枚举
enum HttpStatusCode {
  /// 200 OK
  ok200,
  
  /// 201 Created
  created201,
  
  /// 204 No Content
  noContent204,
  
  /// 301 Moved Permanently
  movedPermanently301,
  
  /// 302 Found
  found302,
  
  /// 304 Not Modified
  notModified304,
  
  /// 400 Bad Request
  badRequest400,
  
  /// 401 Unauthorized
  unauthorized401,
  
  /// 403 Forbidden
  forbidden403,
  
  /// 404 Not Found
  notFound404,
  
  /// 405 Method Not Allowed
  methodNotAllowed405,
  
  /// 500 Internal Server Error
  internalServerError500,
  
  /// 502 Bad Gateway
  badGateway502,
  
  /// 503 Service Unavailable
  serviceUnavailable503,
  
  /// 504 Gateway Timeout
  gatewayTimeout504,
}

/// 重定向类型枚举
enum RedirectType {
  /// 临时重定向
  temporary,
  
  /// 永久重定向
  permanent,
  
  /// 手动重定向
  manual,
}

/// 缓存控制枚举
enum CacheControl {
  /// 公共缓存
  public,
  
  /// 私有缓存
  private,
  
  /// 无缓存
  noCache,
  
  /// 无存储
  noStore,
}

/// 内容编码枚举
enum ContentEncoding {
  /// 身份编码
  identity,
  
  /// GZIP编码
  gzip,
  
  /// Deflate编码
  deflate,
  
  /// Brotli编码
  br,
}

/// 字符集枚举
enum Charset {
  /// UTF-8
  utf8,
  
  /// UTF-16
  utf16,
  
  /// ISO-8859-1
  iso88591,
  
  /// ASCII
  ascii,
}

/// 语言代码枚举
enum LanguageCode {
  /// 中文简体
  zhCN,
  
  /// 中文繁体
  zhTW,
  
  /// 英语
  enUS,
  
  /// 英语英国
  enGB,
  
  /// 日语
  jaJP,
  
  /// 韩语
  koKR,
}

/// 时区枚举
enum TimeZone {
  /// UTC
  utc,
  
  /// 北京时间
  beijing,
  
  /// 东京时间
  tokyo,
  
  /// 纽约时间
  newYork,
  
  /// 伦敦时间
  london,
}

/// 日期格式枚举
enum DateFormat {
  /// ISO 8601
  iso8601,
  
  /// RFC 2822
  rfc2822,
  
  /// HTTP日期
  httpDate,
  
  /// Unix时间戳
  unixTimestamp,
}

/// 数字格式枚举
enum NumberFormat {
  /// 十进制
  decimal,
  
  /// 十六进制
  hexadecimal,
  
  /// 八进制
  octal,
  
  /// 二进制
  binary,
}

/// 单位类型枚举
enum UnitType {
  /// 字节
  bytes,
  
  /// 千字节
  kilobytes,
  
  /// 兆字节
  megabytes,
  
  /// 千兆字节
  gigabytes,
  
  /// 毫秒
  milliseconds,
  
  /// 秒
  seconds,
  
  /// 分钟
  minutes,
  
  /// 小时
  hours,
  
  /// 天
  days,
}

/// 颜色格式枚举
enum ColorFormat {
  /// RGB
  rgb,
  
  /// RGBA
  rgba,
  
  /// 十六进制
  hex,
  
  /// HSL
  hsl,
  
  /// HSLA
  hsla,
}

/// 图像格式枚举
enum ImageFormat {
  /// JPEG
  jpeg,
  
  /// PNG
  png,
  
  /// GIF
  gif,
  
  /// WebP
  webp,
  
  /// BMP
  bmp,
  
  /// TIFF
  tiff,
  
  /// SVG
  svg,
}

/// 音频格式枚举
enum AudioFormat {
  /// MP3
  mp3,
  
  /// WAV
  wav,
  
  /// FLAC
  flac,
  
  /// AAC
  aac,
  
  /// OGG
  ogg,
  
  /// WMA
  wma,
}

/// 视频格式枚举
enum VideoFormat {
  /// MP4
  mp4,
  
  /// AVI
  avi,
  
  /// MOV
  mov,
  
  /// MKV
  mkv,
  
  /// FLV
  flv,
  
  /// WMV
  wmv,
  
  /// WebM
  webm,
}

/// 压缩格式枚举
enum ArchiveFormat {
  /// ZIP
  zip,
  
  /// RAR
  rar,
  
  /// 7Z
  sevenZip,
  
  /// TAR
  tar,
  
  /// GZ
  gz,
  
  /// BZ2
  bz2,
  
  /// XZ
  xz,
}

/// 文档格式枚举
enum DocumentFormat {
  /// PDF
  pdf,
  
  /// DOC
  doc,
  
  /// DOCX
  docx,
  
  /// RTF
  rtf,
  
  /// TXT
  txt,
  
  /// ODT
  odt,
  
  /// HTML
  html,
  
  /// Markdown
  markdown,
}

/// 字体格式枚举
enum FontFormat {
  /// TTF
  ttf,
  
  /// OTF
  otf,
  
  /// WOFF
  woff,
  
  /// WOFF2
  woff2,
  
  /// EOT
  eot,
  
  /// SVG Font
  svgFont,
}

/// 3D模型格式枚举
enum ModelFormat {
  /// OBJ
  obj,
  
  /// FBX
  fbx,
  
  /// COLLADA
  dae,
  
  /// 3DS
  threeDs,
  
  /// STL
  stl,
  
  /// PLY
  ply,
  
  /// GLTF
  gltf,
}

/// 矢量图形格式枚举
enum VectorFormat {
  /// SVG
  svg,
  
  /// EPS
  eps,
  
  /// AI
  ai,
  
  /// CDR
  cdr,
  
  /// EMF
  emf,
  
  /// WMF
  wmf,
}

/// 数据格式枚举
enum DataFormat {
  /// JSON
  json,
  
  /// XML
  xml,
  
  /// YAML
  yaml,
  
  /// TOML
  toml,
  
  /// CSV
  csv,
  
  /// TSV
  tsv,
  
  /// INI
  ini,
  
  /// Properties
  properties,
}

/// 配置文件格式枚举
enum ConfigFormat {
  /// JSON配置
  json,
  
  /// YAML配置
  yaml,
  
  /// TOML配置
  toml,
  
  /// INI配置
  ini,
  
  /// XML配置
  xml,
  
  /// Properties配置
  properties,
  
  /// 环境变量
  environment,
}

/// 日志格式枚举
enum LogFormat {
  /// 纯文本
  plain,
  
  /// JSON格式
  json,
  
  /// XML格式
  xml,
  
  /// CSV格式
  csv,
  
  /// 自定义格式
  custom,
}

/// 序列化格式枚举
enum SerializationFormat {
  /// JSON
  json,
  
  /// XML
  xml,
  
  /// YAML
  yaml,
  
  /// MessagePack
  msgpack,
  
  /// Protocol Buffers
  protobuf,
  
  /// Avro
  avro,
  
  /// Thrift
  thrift,
}

/// 网络地址格式枚举
enum AddressFormat {
  /// IPv4
  ipv4,
  
  /// IPv6
  ipv6,
  
  /// 域名
  domain,
  
  /// MAC地址
  mac,
  
  /// 邮箱地址
  email,
  
  /// 电话号码
  phone,
}

/// URL格式枚举
enum UrlFormat {
  /// HTTP
  http,
  
  /// HTTPS
  https,
  
  /// FTP
  ftp,
  
  /// FTPS
  ftps,
  
  /// SFTP
  sftp,
  
  /// WebSocket
  websocket,
  
  /// File
  file,
  
  /// Data
  data,
}

/// 协议格式枚举
enum ProtocolFormat {
  /// HTTP
  http,
  
  /// HTTPS
  https,
  
  /// FTP
  ftp,
  
  /// FTPS
  ftps,
  
  /// SFTP
  sftp,
  
  /// SSH
  ssh,
  
  /// Telnet
  telnet,
  
  /// SMTP
  smtp,
  
  /// POP3
  pop3,
  
  /// IMAP
  imap,
  
  /// DNS
  dns,
  
  /// DHCP
  dhcp,
  
  /// SNMP
  snmp,
  
  /// LDAP
  ldap,
  
  /// WebSocket
  websocket,
  
  /// WebRTC
  webrtc,
}

/// 数据库类型枚举
enum DatabaseType {
  /// SQLite
  sqlite,
  
  /// MySQL
  mysql,
  
  /// PostgreSQL
  postgresql,
  
  /// MongoDB
  mongodb,
  
  /// Redis
  redis,
  
  /// Elasticsearch
  elasticsearch,
  
  /// InfluxDB
  influxdb,
  
  /// Cassandra
  cassandra,
  
  /// Neo4j
  neo4j,
  
  /// CouchDB
  couchdb,
  
  /// DynamoDB
  dynamodb,
  
  /// Firestore
  firestore,
}

/// 缓存类型枚举
enum CacheDatabaseType {
  /// 内存缓存
  memory,
  
  /// 磁盘缓存
  disk,
  
  /// Redis缓存
  redis,
  
  /// Memcached缓存
  memcached,
  
  /// 文件缓存
  file,
  
  /// 数据库缓存
  database,
}

/// 消息队列类型枚举
enum MessageQueueType {
  /// RabbitMQ
  rabbitmq,
  
  /// Apache Kafka
  kafka,
  
  /// Redis Pub/Sub
  redis,
  
  /// Amazon SQS
  sqs,
  
  /// Google Pub/Sub
  pubsub,
  
  /// Azure Service Bus
  servicebus,
  
  /// ActiveMQ
  activemq,
  
  /// ZeroMQ
  zmq,
}

/// 微服务通信协议枚举
enum MicroserviceProtocol {
  /// REST API
  rest,
  
  /// GraphQL
  graphql,
  
  /// gRPC
  grpc,
  
  /// WebSocket
  websocket,
  
  /// AMQP
  amqp,
  
  /// MQTT
  mqtt,
}

/// 容器化技术枚举
enum ContainerTechnology {
  /// Docker
  docker,
  
  /// Kubernetes
  kubernetes,
  
  /// Docker Swarm
  swarm,
  
  /// OpenShift
  openshift,
  
  /// Nomad
  nomad,
  
  /// Mesos
  mesos,
}

/// 云服务提供商枚举
enum CloudProvider {
  /// Amazon Web Services
  aws,
  
  /// Microsoft Azure
  azure,
  
  /// Google Cloud Platform
  gcp,
  
  /// Alibaba Cloud
  aliyun,
  
  /// Tencent Cloud
  tencent,
  
  /// Baidu Cloud
  baidu,
  
  /// Huawei Cloud
  huawei,
  
  /// IBM Cloud
  ibm,
  
  /// Oracle Cloud
  oracle,
  
  /// DigitalOcean
  digitalocean,
  
  /// Linode
  linode,
  
  /// Vultr
  vultr,
}

/// 部署环境枚举
enum DeploymentEnvironment {
  /// 开发环境
  development,
  
  /// 测试环境
  testing,
  
  /// 预发布环境
  staging,
  
  /// 生产环境
  production,
  
  /// 演示环境
  demo,
}

/// 监控指标类型枚举
enum MonitoringMetricType {
  /// CPU使用率
  cpu,
  
  /// 内存使用率
  memory,
  
  /// 磁盘使用率
  disk,
  
  /// 网络流量
  network,
  
  /// 响应时间
  responseTime,
  
  /// 吞吐量
  throughput,
  
  /// 错误率
  errorRate,
  
  /// 可用性
  availability,
  
  /// 并发数
  concurrency,
  
  /// 队列长度
  queueLength,
}

/// 告警级别枚举
enum AlertLevel {
  /// 信息
  info,
  
  /// 警告
  warning,
  
  /// 错误
  error,
  
  /// 严重
  critical,
  
  /// 紧急
  emergency,
}

/// 资源类型枚举
enum ResourceType {
  /// CPU
  cpu,
  
  /// 内存
  memory,
  
  /// 磁盘
  disk,
  
  /// 网络
  network,
  
  /// GPU
  gpu,
  
  /// 数据库连接
  databaseConnection,
  
  /// 文件描述符
  fileDescriptor,
  
  /// 线程
  thread,
}

/// 负载均衡算法枚举
enum LoadBalancingAlgorithm {
  /// 轮询
  roundRobin,
  
  /// 加权轮询
  weightedRoundRobin,
  
  /// 最少连接
  leastConnections,
  
  /// 加权最少连接
  weightedLeastConnections,
  
  /// 最短响应时间
  shortestResponseTime,
  
  /// 哈希
  hash,
  
  /// 随机
  random,
}

/// 服务发现类型枚举
enum ServiceDiscoveryType {
  /// DNS
  dns,
  
  /// Consul
  consul,
  
  /// etcd
  etcd,
  
  /// ZooKeeper
  zookeeper,
  
  /// Eureka
  eureka,
  
  /// Kubernetes DNS
  k8sDns,
}

/// 配置管理工具枚举
enum ConfigurationTool {
  /// etcd
  etcd,
  
  /// Consul
  consul,
  
  /// ZooKeeper
  zookeeper,
  
  /// Apollo
  apollo,
  
  /// Nacos
  nacos,
  
  /// Spring Cloud Config
  springConfig,
  
  /// AWS Parameter Store
  parameterStore,
  
  /// AWS Secrets Manager
  secretsManager,
  
  /// Azure Key Vault
  keyVault,
  
  /// Google Secret Manager
  secretManager,
}

/// CI/CD工具枚举
enum CICDTool {
  /// Jenkins
  jenkins,
  
  /// GitLab CI
  gitlab,
  
  /// GitHub Actions
  github,
  
  /// CircleCI
  circleci,
  
  /// Travis CI
  travis,
  
  /// Azure DevOps
  azure,
  
  /// Bitbucket Pipelines
  bitbucket,
  
  /// Drone
  drone,
  
  /// TeamCity
  teamcity,
  
  /// Bamboo
  bamboo,
}

/// 版本控制系统枚举
enum VersionControlSystem {
  /// Git
  git,
  
  /// Subversion
  svn,
  
  /// Mercurial
  hg,
  
  /// CVS
  cvs,
  
  /// Perforce
  perforce,
  
  /// TFS
  tfs,
}

/// 包管理器枚举
enum PackageManager {
  /// npm
  npm,
  
  /// Yarn
  yarn,
  
  /// pnpm
  pnpm,
  
  /// Maven
  maven,
  
  /// Gradle
  gradle,
  
  /// pip
  pip,
  
  /// conda
  conda,
  
  /// NuGet
  nuget,
  
  /// Cargo
  cargo,
  
  /// Composer
  composer,
  
  /// Go Modules
  goModules,
}

/// 构建工具枚举
enum BuildTool {
  /// Make
  make,
  
  /// CMake
  cmake,
  
  /// Ant
  ant,
  
  /// Maven
  maven,
  
  /// Gradle
  gradle,
  
  /// MSBuild
  msbuild,
  
  /// Xcodebuild
  xcodebuild,
  
  /// SCons
  scons,
  
  /// Bazel
  bazel,
  
  /// Buck
  buck,
  
  /// Ninja
  ninja,
  
  /// Meson
  meson,
}

/// 测试框架枚举
enum TestingFramework {
  /// JUnit
  junit,
  
  /// TestNG
  testng,
  
  /// NUnit
  nunit,
  
  /// xUnit
  xunit,
  
  /// pytest
  pytest,
  
  /// unittest
  unittest,
  
  /// Mocha
  mocha,
  
  /// Jest
  jest,
  
  /// Jasmine
  jasmine,
  
  /// Cypress
  cypress,
  
  /// Selenium
  selenium,
  
  /// Appium
  appium,
}

/// 代码质量工具枚举
enum CodeQualityTool {
  /// SonarQube
  sonarqube,
  
  /// CodeClimate
  codeclimate,
  
  /// Codacy
  codacy,
  
  /// Codebeat
  codebeat,
  
  /// Better Code Hub
  bettercodehub,
  
  /// CodeFactor
  codefactor,
  
  /// Scrutinizer
  scrutinizer,
  
  /// Coverity
  coverity,
  
  /// Checkmarx
  checkmarx,
  
  /// Veracode
  veracode,
}

/// 安全扫描工具枚举
enum SecurityScanTool {
  /// OWASP ZAP
  zap,
  
  /// Burp Suite
  burp,
  
  /// Nessus
  nessus,
  
  /// OpenVAS
  openvas,
  
  /// Nmap
  nmap,
  
  /// Metasploit
  metasploit,
  
  /// Nikto
  nikto,
  
  /// SQLMap
  sqlmap,
  
  /// Aircrack-ng
  aircrack,
  
  /// Wireshark
  wireshark,
}

/// 性能测试工具枚举
enum PerformanceTestingTool {
  /// JMeter
  jmeter,
  
  /// LoadRunner
  loadrunner,
  
  /// Gatling
  gatling,
  
  /// K6
  k6,
  
  /// Artillery
  artillery,
  
  /// Locust
  locust,
  
  /// Tsung
  tsung,
  
  /// WebLOAD
  webload,
  
  /// NeoLoad
  neoload,
  
  /// BlazeMeter
  blazemeter,
}

/// API测试工具枚举
enum APITestingTool {
  /// Postman
  postman,
  
  /// Insomnia
  insomnia,
  
  /// Paw
  paw,
  
  /// SoapUI
  soapui,
  
  /// REST Assured
  restassured,
  
  /// Karate
  karate,
  
  /// Dredd
  dredd,
  
  /// Prism
  prism,
  
  /// WireMock
  wiremock,
  
  /// MockServer
  mockserver,
}

/// 文档工具枚举
enum DocumentationTool {
  /// Swagger
  swagger,
  
  /// OpenAPI
  openapi,
  
  /// GraphQL
  graphql,
  
  /// RAML
  raml,
  
  /// API Blueprint
  apiblueprint,
  
  /// AsyncAPI
  asyncapi,
  
  /// Slate
  slate,
  
  /// GitBook
  gitbook,
  
  /// Docusaurus
  docusaurus,
  
  /// Jekyll
  jekyll,
  
  /// Hugo
  hugo,
  
  /// MkDocs
  mkdocs,
}

/// 监控工具枚举
enum MonitoringTool {
  /// Prometheus
  prometheus,
  
  /// Grafana
  grafana,
  
  /// ELK Stack
  elk,
  
  /// Datadog
  datadog,
  
  /// New Relic
  newrelic,
  
  /// AppDynamics
  appdynamics,
  
  /// Dynatrace
  dynatrace,
  
  /// Splunk
  splunk,
  
  /// Nagios
  nagios,
  
  /// Zabbix
  zabbix,
  
  /// Icinga
  icinga,
  
  /// Sensu
  sensu,
}

/// 日志管理工具枚举
enum LogManagementTool {
  /// ELK Stack
  elk,
  
  /// Splunk
  splunk,
  
  /// Fluentd
  fluentd,
  
  /// Fluent Bit
  fluentbit,
  
  /// Filebeat
  filebeat,
  
  /// Logstash
  logstash,
  
  /// Loggly
  loggly,
  
  /// Papertrail
  papertrail,
  
  /// Sumo Logic
  sumologic,
  
  /// LogDNA
  logdna,
  
  /// Timber
  timber,
}

/// 错误追踪工具枚举
enum ErrorTrackingTool {
  /// Sentry
  sentry,
  
  /// Rollbar
  rollbar,
  
  /// Bugsnag
  bugsnag,
  
  /// Airbrake
  airbrake,
  
  /// Honeybadger
  honeybadger,
  
  /// TrackJS
  trackjs,
  
  /// LogRocket
  logrocket,
  
  /// Raygun
  raygun,
  
  /// OverOps
  overops,
  
  /// Datadog RUM
  datadogRUM,
}

/// 性能监控工具枚举
enum APMTool {
  /// New Relic
  newrelic,
  
  /// AppDynamics
  appdynamics,
  
  /// Datadog
  datadog,
  
  /// Dynatrace
  dynatrace,
  
  /// Splunk APM
  splunkapm,
  
  /// Elastic APM
  elasticapm,
  
  /// SkyWalking
  skywalking,
  
  /// Jaeger
  jaeger,
  
  /// Zipkin
  zipkin,
  
  /// Pinpoint
  pinpoint,
}

/// 容器镜像仓库枚举
enum ContainerRegistry {
  /// Docker Hub
  dockerhub,
  
  /// Amazon ECR
  ecr,
  
  /// Google Container Registry
  gcr,
  
  /// Azure Container Registry
  acr,
  
  /// Quay.io
  quay,
  
  /// Harbor
  harbor,
  
  /// GitLab Container Registry
  gitlab,
  
  /// Nexus Repository
  nexus,
  
  /// Artifactory
  artifactory,
  
  /// ChartMuseum
  chartmuseum,
}

/// 基础设施即代码工具枚举
enum InfrastructureAsCodeTool {
  /// Terraform
  terraform,
  
  /// CloudFormation
  cloudformation,
  
  /// Ansible
  ansible,
  
  /// Chef
  chef,
  
  /// Puppet
  puppet,
  
  /// SaltStack
  saltstack,
  
  /// Pulumi
  pulum,
  
  /// CDK
  cdk,
  
  /// Bicep
  bicep,
  
  /// ARM Templates
  arm,
}

/// 配置管理工具枚举
enum ConfigurationManagementTool {
  /// Ansible
  ansible,
  
  /// Chef
  chef,
  
  /// Puppet
  puppet,
  
  /// SaltStack
  saltstack,
  
  /// CFEngine
  cfengine,
  
  /// Otter
  otter,
  
  /// Rex
  rex,
}

/// 编排工具枚举
enum OrchestrationTool {
  /// Kubernetes
  kubernetes,
  
  /// Docker Swarm
  swarm,
  
  /// Nomad
  nomad,
  
  /// Mesos
  mesos,
  
  /// OpenShift
  openshift,
  
  /// Rancher
  rancher,
  
  /// Portainer
  portainer,
  
  /// DC/OS
  dcos,
  
  /// ECS
  ecs,
  
  /// EKS
  eks,
  
  /// GKE
  gke,
  
  /// AKS
  aks,
}

/// 服务网格枚举
enum ServiceMesh {
  /// Istio
  istio,
  
  /// Linkerd
  linkerd,
  
  /// Consul Connect
  consul,
  
  /// AWS App Mesh
  appmesh,
  
  /// Google Anthos
  anthos,
  
  /// Azure Service Fabric
  servicefabric,
  
  /// Kuma
  kuma,
  
  /// Maesh
  maesh,
}

/// API网关枚举
enum APIGateway {
  /// Kong
  kong,
  
  /// NGINX
  nginx,
  
  /// HAProxy
  haproxy,
  
  /// Traefik
  traefik,
  
  /// Envoy
  envoy,
  
  /// Istio Gateway
  istio,
  
  /// Ambassador
  ambassador,
  
  /// Gloo
  gloo,
  
  /// Zuul
  zuul,
  
  /// Spring Cloud Gateway
  spring,
  
  /// AWS API Gateway
  aws,
  
  /// Azure API Management
  azure,
  
  /// Google Cloud Endpoints
  gcp,
}

/// 消息代理枚举
enum MessageBroker {
  /// RabbitMQ
  rabbitmq,
  
  /// Apache Kafka
  kafka,
  
  /// Apache Pulsar
  pulsar,
  
  /// Redis Pub/Sub
  redis,
  
  /// Amazon SQS
  sqs,
  
  /// Amazon SNS
  sns,
  
  /// Google Pub/Sub
  pubsub,
  
  /// Azure Service Bus
  servicebus,
  
  /// IBM MQ
  ibmmq,
  
  /// TIBCO EMS
  tibco,
  
  /// ActiveMQ
  activemq,
  
  /// HornetQ
  hornetq,
  
  /// Qpid
  qpid,
  
  /// ZeroMQ
  zmq,
  
  /// NATS
  nats,
}

/// 缓存服务器枚举
enum CacheServer {
  /// Redis
  redis,
  
  /// Memcached
  memcached,
  
  /// Hazelcast
  hazelcast,
  
  /// Apache Ignite
  ignite,
  
  /// Infinispan
  infinispan,
  
  /// Couchbase
  couchbase,
  
  /// Aerospike
  aerospike,
  
  /// Riak KV
  riak,
  
  /// etcd
  etcd,
  
  /// Consul
  consul,
  
  /// Voldemort
  voldemort,
  
  /// Tokyo Cabinet
  tokyo,
  
  /// LevelDB
  leveldb,
  
  /// RocksDB
  rocksdb,
  
  /// Cassandra
  cassandra,
  
  /// ScyllaDB
  scylladb,
}

/// 搜索引擎枚举
enum SearchEngine {
  /// Elasticsearch
  elasticsearch,
  
  /// Solr
  solr,
  
  /// Sphinx
  sphinx,
  
  /// Lucene
  lucene,
  
  /// Algolia
  algolia,
  
  /// MeiliSearch
  meilisearch,
  
  /// Typesense
  typesense,
  
  /// OpenSearch
  opensearch,
  
  /// Amazon CloudSearch
  cloudsearch,
  
  /// Azure Cognitive Search
  cognitive,
  
  /// Google Custom Search
  customsearch,
}

/// 流处理框架枚举
enum StreamProcessingFramework {
  /// Apache Kafka Streams
  kafka,
  
  /// Apache Flink
  flink,
  
  /// Apache Storm
  storm,
  
  /// Apache Samza
  samza,
  
  /// Apache Beam
  beam,
  
  /// Apache Pulsar Functions
  pulsar,
  
  /// Akka Streams
  akka,
  
  /// RxJava
  rxjava,
  
  /// Reactor
  reactor,
  
  /// Vert.x
  vertx,
  
  /// Quarkus
  quarkus,
  
  /// Micronaut
  micronaut,
}

/// 批处理框架枚举
enum BatchProcessingFramework {
  /// Apache Spark
  spark,
  
  /// Apache Hadoop MapReduce
  mapreduce,
  
  /// Apache Pig
  pig,
  
  /// Apache Hive
  hive,
  
  /// Apache Impala
  impala,
  
  /// Apache Drill
  drill,
  
  /// Apache Flink
  flink,
  
  /// Apache Beam
  beam,
  
  /// Dask
  dask,
  
  /// Ray
  ray,
  
  /// Celery
  celery,
}

/// 数据仓库枚举
enum DataWarehouse {
  /// Amazon Redshift
  redshift,
  
  /// Google BigQuery
  bigquery,
  
  /// Snowflake
  snowflake,
  
  /// Azure Synapse
  synapse,
  
  /// Oracle Data Warehouse
  oracle,
  
  /// IBM Db2 Warehouse
  db2,
  
  /// SAP HANA
  hana,
  
  /// Vertica
  vertica,
  
  /// Greenplum
  greenplum,
  
  /// ClickHouse
  clickhouse,
  
  /// Apache Druid
  druid,
  
  /// Apache Pinot
  pinot,
}

/// 数据湖枚举
enum DataLake {
  /// Amazon S3
  s3,
  
  /// Azure Data Lake
  datalake,
  
  /// Google Cloud Storage
  gcs,
  
  /// Apache HDFS
  hdfs,
  
  /// Delta Lake
  delta,
  
  /// Apache Iceberg
  iceberg,
  
  /// Apache Hudi
  hudi,
  
  /// Apache Parquet
  parquet,
  
  /// Apache Avro
  avro,
  
  /// Apache ORC
  orc,
}

/// 机器学习框架枚举
enum MachineLearningFramework {
  /// TensorFlow
  tensorflow,
  
  /// PyTorch
  pytorch,
  
  /// scikit-learn
  sklearn,
  
  /// Keras
  keras,
  
  /// MXNet
  mxnet,
  
  /// Caffe
  caffe,
  
  /// CNTK
  cntk,
  
  /// XGBoost
  xgboost,
  
  /// LightGBM
  lightgbm,
  
  /// CatBoost
  catboost,
  
  /// H2O
  h2o,
  
  /// Spark MLlib
  mllib,
  
  /// Mahout
  mahout,
  
  /// Weka
  weka,
  
  /// RapidMiner
  rapidminer,
  
  /// R
  r,
  
  /// Julia
  julia,
}

/// 深度学习框架枚举
enum DeepLearningFramework {
  /// TensorFlow
  tensorflow,
  
  /// PyTorch
  pytorch,
  
  /// Keras
  keras,
  
  /// MXNet
  mxnet,
  
  /// Caffe
  caffe,
  
  /// CNTK
  cntk,
  
  /// Chainer
  chainer,
  
  /// Theano
  theano,
  
  /// TensorLayer
  tensorlayer,
  
  /// DeepLearning4J
  dl4j,
  
  /// Neon
  neon,
  
  /// Brainstorm
  brainstorm,
  
  /// Lasagne
  lasagne,
  
  /// Blocks
  blocks,
  
  /// TFLearn
  tflearn,
  
  /// Sonnet
  sonnet,
}

/// 自然语言处理框架枚举
enum NLPFramework {
  /// spaCy
  spacy,
  
  /// NLTK
  nltk,
  
  /// Stanford CoreNLP
  corenlp,
  
  /// OpenNLP
  opennlp,
  
  /// Gensim
  gensim,
  
  /// TextBlob
  textblob,
  
  /// Pattern
  pattern,
  
  /// Polyglot
  polyglot,
  
  /// Word2Vec
  word2vec,
  
  /// GloVe
  glove,
  
  /// FastText
  fasttext,
  
  /// BERT
  bert,
  
  /// GPT
  gpt,
  
  /// Transformer
  transformer,
  
  /// Hugging Face Transformers
  transformers,
  
  /// AllenNLP
  allennlp,
  
  /// Flair
  flair,
  
  /// Stanza
  stanza,
}

/// 计算机视觉框架枚举
enum ComputerVisionFramework {
  /// OpenCV
  opencv,
  
  /// PIL
  pil,
  
  /// scikit-image
  skimage,
  
  /// SimpleCV
  simplecv,
  
  /// Mahotas
  mahotas,
  
  /// imutils
  imutils,
  
  /// Pillow
  pillow,
  
  /// ImageIO
  imageio,
  
  /// image
  image,
  
  /// dlib
  dlib,
  
  /// face_recognition
  facerecognition,
  
  /// MediaPipe
  mediapipe,
  
  /// YOLO
  yolo,
  
  /// R-CNN
  rcnn,
  
  /// SSD
  ssd,
  
  /// Faster R-CNN
  fasterrcnn,
  
  /// Mask R-CNN
  maskrcnn,
  
  /// Detectron2
  detectron2,
  
  /// MMDetection
  mmdetection,
  
  /// OpenMMLab
  openmmlab,
}

/// 语音识别框架枚举
enum SpeechRecognitionFramework {
  /// SpeechRecognition
  speechrecognition,
  
  /// pocketsphinx
  pocketsphinx,
  
  /// deepspeech
  deepspeech,
  
  /// wav2letter
  wav2letter,
  
  /// wav2vec2
  wav2vec2,
  
  /// Facebook wav2vec
  wav2vec,
  
  /// OpenAI Whisper
  whisper,
  
  /// Google Speech-to-Text
  speechtotext,
  
  /// Azure Speech Services
  azure,
  
  /// Amazon Transcribe
  transcribe,
  
  /// IBM Watson Speech to Text
  watson,
  
  /// CMU Sphinx
  sphinx,
}

/// 推荐系统框架枚举
enum RecommendationFramework {
  /// Surprise
  surprise,
  
  /// LightFM
  lightfm,
  
  /// implicit
  implicit,
  
  /// LensKit
  lenskit,
  
  /// Crab
  crab,
  
  /// recsys
  recsys,
  
  /// Spotlight
  spotlight,
  
  /// Cornac
  cornac,
  
  /// TensorRec
  tensorrec,
  
  /// PyRec
  pyrec,
  
  /// scikit-recommender
  scikit,
  
  /// FastFM
  fastfm,
  
  /// LightGBM
  lightgbm,
  
  /// XGBoost
  xgboost,
  
  /// LibFM
  libfm,
  
  /// LibFFM
  libffm,
  
  /// Field-aware Factorization Machine
  ffm,
}

/// 强化学习框架枚举
enum ReinforcementLearningFramework {
  /// OpenAI Gym
  gym,
  
  /// Stable Baselines3
  sb3,
  
  /// Ray RLlib
  rllib,
  
  /// TensorFlow Agents
  tfagents,
  
  /// Keras-RL
  kerasrl,
  
  /// Dopamine
  dopamine,
  
  /// Coach
  coach,
  
  /// ReAgent
  reagent,
  
  /// PettingZoo
  pettingzoo,
  
  /// DeepMind Lab
  lab,
  
  /// Malmo
  malmo,
  
  /// Unity ML-Agents
  mlagents,
  
  /// OpenAI Retro
  retro,
  
  /// VizDoom
  vizdoom,
  
  /// PyGame Learning Environment
  pgle,
  
  /// MinPy
  minpy,
  
  /// RLlib
  rllib,
  
  /// ACME
  acme,
}

/// 时间序列分析框架枚举
enum TimeSeriesFramework {
  /// statsmodels
  statsmodels,
  
  /// Prophet
  prophet,
  
  /// Sktime
  sktime,
  
  /// tslearn
  tslearn,
  
  /// pyts
  pyts,
  
  /// cesium
  cesium,
  
  /// darts
  darts,
  
  /// Kats
  kats,
  
  /// AutoTS
  autots,
  
  /// AutoKeras
  autokeras,
  
  /// NeuralProphet
  neuralprophet,
  
  /// Orbit
  orbit,
  
  /// pmdarima
  pmdarima,
  
  /// arch
  arch,
  
  /// tbats
  tbats,
  
  /// seasonal
  seasonal,
  
  /// stldecompose
  stldecompose,
  
  /// PyFlux
  pyflux,
  
  /// tsfresh
  tsfresh,
  
  /// featuretools
  featuretools,
}

/// 异常检测框架枚举
enum AnomalyDetectionFramework {
  /// scikit-learn
  sklearn,
  
  /// PyOD
  pyod,
  
  /// IsolationForest
  isolationforest,
  
  /// LOF
  lof,
  
  /// One-Class SVM
  oneclasssvm,
  
  /// DBSCAN
  dbscan,
  
  /// Autoencoder
  autoencoder,
  
  /// LSTM
  lstm,
  
  /// GAN
  gan,
  
  /// Prophet
  prophet,
  
  /// STL
  stl,
  
  /// ESD
  esd,
  
  /// Grubbs
  grubbs,
  
  /// Dixon
  dixon,
  
  /// Hampel Filter
  hampel,
  
  /// IQR
  iqr,
  
  /// Z-Score
  zscore,
}

/// 图数据库枚举
enum GraphDatabase {
  /// Neo4j
  neo4j,
  
  /// Amazon Neptune
  neptune,
  
  /// JanusGraph
  janusgraph,
  
  /// ArangoDB
  arangodb,
  
  /// OrientDB
  orientdb,
  
  /// Cayley
  cayley,
  
  /// Dgraph
  dgraph,
  
  /// Titan
  titan,
  
  /// InfiniteGraph
  infinitegraph,
  
  /// GraphDB
  graphdb,
  
  /// Stardog
  stardog,
  
  /// AllegroGraph
  allegrograph,
  
  /// Blazegraph
  blazegraph,
  
  /// Apache Jena
  jena,
  
  /// Apache TinkerPop
  tinkerpop,
  
  /// Gremlin
  gremlin,
  
  /// Cypher
  cypher,
  
  /// SPARQL
  sparql,
}

/// 时序数据库枚举
enum TimeSeriesDatabase {
  /// InfluxDB
  influxdb,
  
  /// TimescaleDB
  timescale,
  
  /// Prometheus
  prometheus,
  
  /// OpenTSDB
  opentsdb,
  
  /// Druid
  druid,
  
  /// Pinot
  pinot,
  
  /// ClickHouse
  clickhouse,
  
  /// QuestDB
  questdb,
  
  /// TDengine
  tdengine,
  
  /// IoTDB
  iotdb,
  
  /// Kdb+
  kdb,
  
  /// Tick
  tick,
  
  /// Beringei
  beringei,
  
  /// Heroic
  heroic,
  
  /// Blueflood
  blueflood,
  
  /// KairosDB
  kairos,
  
  /// Whisper
  whisper,
  
  /// Graphite
  graphite,
  
  /// StatsD
  statsd,
}

/// 区块链平台枚举
enum BlockchainPlatform {
  /// Ethereum
  ethereum,
  
  /// Bitcoin
  bitcoin,
  
  /// Hyperledger Fabric
  fabric,
  
  /// Corda
  corda,
  
  /// Ripple
  ripple,
  
  /// Stellar
  stellar,
  
  /// EOS
  eos,
  
  /// Cardano
  cardano,
  
  /// Polkadot
  polkadot,
  
  /// Solana
  solana,
  
  /// Avalanche
  avalanche,
  
  /// Chainlink
  chainlink,
  
  /// Polygon
  polygon,
  
  /// Binance Smart Chain
  bsc,
  
  /// Tezos
  tezos,
  
  /// Algorand
  algorand,
  
  /// Cosmos
  cosmos,
  
  /// Near Protocol
  near,
  
  /// Terra
  terra,
  
  /// Fantom
  fantom,
}

/// 物联网平台枚举
enum IoTPlatform {
  /// AWS IoT Core
  awsiot,
  
  /// Azure IoT Hub
  azureiot,
  
  /// Google Cloud IoT Core
  gcp,
  
  /// IBM Watson IoT
  watson,
  
  /// Oracle IoT
  oracle,
  
  /// SAP IoT
  sap,
  
  /// Alibaba Cloud IoT
  aliyun,
  
  /// Tencent Cloud IoT
  tencent,
  
  /// Baidu Cloud IoT
  baidu,
  
  /// Huawei Cloud IoT
  huawei,
  
  /// ThingWorx
  thingworx,
  
  /// PTC Windchill
  windchill,
  
  /// GE Predix
  predix,
  
  /// Siemens MindSphere
  mindsphere,
  
  /// Schneider Electric EcoStruxure
  ecostruxure,
  
  /// ABB Ability
  ability,
  
  /// Cisco IoT
  cisco,
  
  /// Intel IoT
  intel,
  
  /// Qualcomm IoT
  qualcomm,
  
  /// MediaTek IoT
  mediatek,
  
  /// ARM IoT
  arm,
  
  /// Raspberry Pi
  raspberrypi,
  
  /// Arduino
  arduino,
  
  /// ESP32
  esp32,
  
  /// ESP8266
  esp8266,
  
  /// MicroPython
  micropython,
  
  /// CircuitPython
  circuitpython,
  
  /// PlatformIO
  platformio,
  
  /// Zephyr
  zephyr,
  
  /// FreeRTOS
  freertos,
  
  /// RIOT
  riot,
  
  /// Mynewt
  mynewt,
  
  /// mbed OS
  mbed,
  
  /// Contiki
  contiki,
  
  /// TinyOS
  tinyos,
  
  /// LiteOS
  liteos,
  
  /// AliOS Things
  alios,
  
  /// TencentOS tiny
  tenscentos,
  
  /// Huawei LiteOS
  huaweiliteos,
  
  /// Amazon FreeRTOS
  freertosaws,
}
