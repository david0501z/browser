import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'proxy_performance_optimizer.dart';

/// 网络连接管理器
/// 
/// 提供高性能的网络连接管理功能：
/// - 连接池管理
/// - 连接复用
/// - 健康检查
/// - 自动重连
/// - 连接负载均衡
/// - 网络质量检测
/// - 连接路径优化
/// - QoS支持
class NetworkConnectionManager {
  static final NetworkConnectionManager _instance = NetworkConnectionManager._internal();
  factory NetworkConnectionManager() => _instance;
  NetworkConnectionManager._internal();

  // 连接池
  final Map<String, ConnectionPool> _connectionPools = {};
  
  // 活跃连接
  final Map<String, HttpClient> _activeConnections = {};
  
  // 连接统计
  late NetworkConnectionStats _stats;
  
  // 配置
  PerformanceConfig? _config;
  
  // 连接超时
  Duration _connectionTimeout = const Duration(seconds: 30);
  
  // 健康检查定时器
  Timer? _healthCheckTimer;
  
  // 连接清理定时器
  Timer? _cleanupTimer;
  
  // 网络质量检测器
  final NetworkQualityDetector _qualityDetector = NetworkQualityDetector();
  
  // 路径优化器
  final PathOptimizer _pathOptimizer = PathOptimizer();
  
  // DNS解析器
  final DnsResolver _dnsResolver = DnsResolver();
  
  /// 初始化网络连接管理器
  Future<void> initialize(PerformanceConfig config) async {
    _config = config;
    _connectionTimeout = config.connectionTimeout;
    
    // 初始化网络质量检测
    await _qualityDetector.initialize();
    
    // 初始化路径优化
    await _pathOptimizer.initialize();
    
    // 初始化DNS解析器
    await _dnsResolver.initialize();
    
    // 启动健康检查
    _startHealthCheck();
    
    // 启动连接清理
    _startConnectionCleanup();
    
    // 初始化统计
    _stats = NetworkConnectionStats();
    
    log('[NetworkConnectionManager] 网络连接管理器已初始化');
  }
  
  /// 创建或获取连接池
  ConnectionPool getOrCreatePool(String host, {int? port, ProxyType? type}) {
    final key = _generatePoolKey(host, port, type);
    
    if (!_connectionPools.containsKey(key)) {
      _connectionPools[key] = ConnectionPool(
        host: host,
        port: port ?? 80,
        type: type ?? ProxyType.http,
        maxSize: _calculatePoolSize(),
        config: _config!,
      );
    }
    
    return _connectionPools[key]!;
  }
  
  /// 获取连接
  Future<HttpClientConnection> getConnection({
    required String host,
    int? port,
    ProxyType type = ProxyType.http,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final pool = getOrCreatePool(host, port: port, type: type);
      
      // 检查网络质量
      final quality = await _qualityDetector.detectQuality();
      if (quality == NetworkQuality.poor) {
        log('[NetworkConnectionManager] 网络质量较差，调整连接策略');
        pool.adjustForNetworkQuality(quality);
      }
      
      // 获取或创建连接
      final connection = await pool.acquireConnection(
        timeout: timeout ?? _connectionTimeout,
      );
      
      // 设置请求头
      if (headers != null) {
        connection.client.headers.addAll(headers);
      }
      
      // 记录统计
      _stats.totalConnections++;
      _stats.activeConnections++;
      
      return connection;
    } catch (e, stackTrace) {
      log('[NetworkConnectionManager] 获取连接失败: $e', level: 500);
      log('StackTrace: $stackTrace');
      rethrow;
    }
  }
  
  /// 释放连接
  Future<void> releaseConnection(HttpClientConnection connection) async {
    try {
      final pool = _connectionPools[_generatePoolKey(
        connection.host,
        connection.port,
        connection.type,
      )];
      
      if (pool != null) {
        await pool.releaseConnection(connection);
        _stats.activeConnections--;
        _stats.successfulConnections++;
      }
    } catch (e) {
      log('[NetworkConnectionManager] 释放连接失败: $e');
    }
  }
  
  /// 执行HTTP请求
  Future<HttpClientResponse> executeRequest({
    required String host,
    int? port,
    required String method,
    required String path,
    Map<String, String>? headers,
    dynamic body,
    Duration? timeout,
    ProxyType type = ProxyType.http,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final connection = await getConnection(
        host: host,
        port: port,
        type: type,
        headers: headers,
        timeout: timeout,
      );
      
      final request = await connection.open(method, path);
      
      // 设置请求体
      if (body != null) {
        if (body is String) {
          request.write(body);
        } else if (body is List<int>) {
          request.add(body);
        } else {
          request.write(jsonEncode(body));
        }
      }
      
      final response = await request.close();
      final responseTime = stopwatch.elapsedMilliseconds;
      
      // 更新统计
      _stats.totalRequests++;
      _stats.avgResponseTime = (_stats.avgResponseTime + responseTime) ~/ 2;
      _stats.lastActivityTime = DateTime.now();
      
      // 检查响应质量
      _analyzeResponse(response, responseTime);
      
      // 释放连接
      await releaseConnection(connection);
      
      return response;
    } catch (e) {
      _stats.failedRequests++;
      log('[NetworkConnectionManager] HTTP请求失败: $e');
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }
  
  /// 检查连接健康状态
  Future<bool> checkConnectionHealth(String host, {int? port}) async {
    try {
      final connection = await getConnection(host: host, port: port);
      final startTime = DateTime.now();
      
      // 发送简单的HEAD请求检查
      final response = await connection.open('HEAD', '/');
      await response.close();
      
      final responseTime = DateTime.now().difference(startTime).inMilliseconds;
      
      final isHealthy = response.statusCode >= 200 && response.statusCode < 400;
      
      if (isHealthy) {
        _stats.healthyConnections++;
        log('[NetworkConnectionManager] 连接健康检查通过: $host:$port (${responseTime}ms)');
      } else {
        _stats.unhealthyConnections++;
        log('[NetworkConnectionManager] 连接健康检查失败: $host:$port (状态码: ${response.statusCode})');
      }
      
      await releaseConnection(connection);
      return isHealthy;
    } catch (e) {
      _stats.unhealthyConnections++;
      log('[NetworkConnectionManager] 健康检查异常: $host:$port - $e');
      return false;
    }
  }
  
  /// 重新连接不健康的连接
  Future<void> reconnectUnhealthyConnections() async {
    log('[NetworkConnectionManager] 开始检查和重建不健康连接');
    
    final List<String> unhealthyHosts = [];
    
    for (final pool in _connectionPools.values) {
      final isHealthy = await checkConnectionHealth(
        pool.host,
        port: pool.port,
      );
      
      if (!isHealthy) {
        unhealthyHosts.add(pool.host);
      }
    }
    
    // 清理不健康的连接
    for (final host in unhealthyHosts) {
      await _cleanupConnectionsForHost(host);
      log('[NetworkConnectionManager] 已清理不健康连接: $host');
    }
  }
  
  /// 清理过期连接
  Future<void> cleanupExpiredConnections() async {
    final now = DateTime.now();
    final expiredConnections = <String>[];
    
    _connectionPools.forEach((key, pool) {
      pool.cleanupExpiredConnections(now);
      if (pool.isEmpty) {
        expiredConnections.add(key);
      }
    });
    
    // 移除空连接池
    for (final key in expiredConnections) {
      _connectionPools.remove(key);
      log('[NetworkConnectionManager] 移除过期连接池: $key');
    }
  }
  
  /// 调整连接池大小
  Future<void> adjustConnectionPool(int newSize) async {
    for (final pool in _connectionPools.values) {
      pool.resize(newSize);
    }
    log('[NetworkConnectionManager] 连接池大小已调整: $newSize');
  }
  
  /// 启用路径优化
  Future<void> enablePathOptimization() async {
    await _pathOptimizer.enableOptimization();
    log('[NetworkConnectionManager] 路径优化已启用');
  }
  
  /// 设置网络QoS
  Future<void> setNetworkQos() async {
    try {
      // 根据网络质量设置QoS
      final quality = await _qualityDetector.detectQuality();
      
      switch (quality) {
        case NetworkQuality.excellent:
          _config?.maxConcurrentConnections = 20;
          break;
        case NetworkQuality.good:
          _config?.maxConcurrentConnections = 15;
          break;
        case NetworkQuality.fair:
          _config?.maxConcurrentConnections = 10;
          break;
        case NetworkQuality.poor:
          _config?.maxConcurrentConnections = 5;
          break;
      }
      
      log('[NetworkConnectionManager] 网络QoS已设置: ${quality.toString()}');
    } catch (e) {
      log('[NetworkConnectionManager] 设置网络QoS失败: $e');
    }
  }
  
  /// 清理指定主机的连接
  Future<void> _cleanupConnectionsForHost(String host) async {
    final keysToRemove = _connectionPools.keys;
        .where((key) => key.contains(host));
        .toList();
    
    for (final key in keysToRemove) {
      final pool = _connectionPools[key];
      if (pool != null) {
        await pool.dispose();
        _connectionPools.remove(key);
      }
    }
  }
  
  /// 分析响应质量
  void _analyzeResponse(HttpClientResponse response, int responseTime) {
    // 记录响应时间分布
    if (responseTime < 100) {
      _stats.fastResponses++;
    } else if (responseTime < 500) {
      _stats.normalResponses++;
    } else {
      _stats.slowResponses++;
    }
    
    // 记录状态码分布
    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      _stats.successfulRequests++;
    } else if (statusCode >= 400) {
      _stats.failedRequests++;
    }
  }
  
  /// 生成连接池键
  String _generatePoolKey(String host, int? port, ProxyType? type) {
    return '${type ?? ProxyType.http}://$host:${port ?? 80}';
  }
  
  /// 计算最优连接池大小
  int _calculatePoolSize() {
    if (_config == null) return 5;
    
    final baseSize = _config!.maxConcurrentConnections;
    final networkQuality = _qualityDetector.currentQuality;
    
    switch (networkQuality) {
      case NetworkQuality.excellent:
        return (baseSize * 1.5).round();
      case NetworkQuality.good:
        return baseSize;
      case NetworkQuality.fair:
        return (baseSize * 0.8).round();
      case NetworkQuality.poor:
        return (baseSize * 0.5).round();
    }
  }
  
  /// 启动健康检查
  void _startHealthCheck() {
    _healthCheckTimer = Timer.periodic(
      const Duration(minutes: 2),
      (_) => _performHealthCheck(),
    );
  }
  
  /// 启动连接清理
  void _startConnectionCleanup() {
    _cleanupTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => cleanupExpiredConnections(),
    );
  }
  
  /// 执行健康检查
  Future<void> _performHealthCheck() async {
    try {
      final tasks = _connectionPools.keys.map((key) => 
        checkConnectionHealth(_connectionPools[key]!.host, port: _connectionPools[key]!.port)
      ).toList();
      
      await Future.wait(tasks);
    } catch (e) {
      log('[NetworkConnectionManager] 健康检查执行失败: $e');
    }
  }
  
  /// 获取连接统计
  NetworkConnectionStats get connectionStats => _stats;
  
  /// 获取网络质量
  NetworkQuality get networkQuality => _qualityDetector.currentQuality;
  
  /// 获取活跃连接数
  int get activeConnectionCount => _connectionPools.values;
      .fold(0, (sum, pool) => sum + pool.activeConnections);
  
  /// 获取连接池状态
  Map<String, PoolStatus> get poolStatuses => {
    for (final entry in _connectionPools.entries)
      entry.key: entry.value.getStatus(),
  };
  
  /// 销毁管理器
  Future<void> dispose() async {
    _healthCheckTimer?.cancel();
    _cleanupTimer?.cancel();
    
    // 清理所有连接池
    for (final pool in _connectionPools.values) {
      await pool.dispose();
    }
    _connectionPools.clear();
    
    await _qualityDetector.dispose();
    await _pathOptimizer.dispose();
    await _dnsResolver.dispose();
    
    log('[NetworkConnectionManager] 网络连接管理器已销毁');
  }
}

/// HTTP客户端连接封装
class HttpClientConnection {
  final HttpClient client;
  final String host;
  final int port;
  final ProxyType type;
  final DateTime createdAt = DateTime.now();
  final DateTime lastUsed = DateTime.now();
  bool isInUse = false;
  
  HttpClientConnection({
    required this.client,
    required this.host,
    required this.port,
    required this.type,
  });
  
  Future<HttpClientRequest> open(String method, String path) async {
    isInUse = true;
    return client.openUrl(method, Uri.https(host, path));
  }
  
  void markUsed() {
    lastUsed = DateTime.now();
  }
  
  void release() {
    isInUse = false;
    markUsed();
  }
  
  bool isExpired(Duration maxAge) {
    return DateTime.now().difference(lastUsed) > maxAge;
  }
  
  int get ageInSeconds => DateTime.now().difference(createdAt).inSeconds;
}

/// 连接池
class ConnectionPool {
  final String host;
  final int port;
  final ProxyType type;
  int maxSize;
  final PerformanceConfig config;
  
  final List<HttpClientConnection> _connections = [];
  final List<HttpClientConnection> _availableConnections = [];
  
  ConnectionPool({
    required this.host,
    required this.port,
    required this.type,
    required this.maxSize,
    required this.config,
  });
  
  Future<HttpClientConnection> acquireConnection({Duration? timeout}) async {
    // 尝试获取可用连接
    while (_availableConnections.isNotEmpty) {
      final connection = _availableConnections.removeAt(0);
      
if (!connection.isExpired(const Duration(minutes: 5)) {
        connection.markUsed();
        return connection;
      } else {
        // 连接过期，关闭它
        await _closeConnection(connection);
      }
    }
    
    // 如果还有空间，创建新连接
    if (_connections.length < maxSize) {
      final client = HttpClient();
      client.connectionTimeout = timeout ?? config.connectionTimeout;
      
      final connection = HttpClientConnection(
        client: client,
        host: host,
        port: port,
        type: type,
      );
      
      _connections.add(connection);
      connection.markUsed();
      return connection;
    }
    
    // 连接池已满，等待连接释放
    await Future.delayed(const Duration(milliseconds: 100));
    return acquireConnection(timeout: timeout);
  }
  
  Future<void> releaseConnection(HttpClientConnection connection) async {
    connection.release();
    
    // 检查连接是否仍然有效
    if (_isConnectionValid(connection)) {
      _availableConnections.add(connection);
    } else {
      await _closeConnection(connection);
    }
    
    // 保持连接池大小
    _trimPoolIfNeeded();
  }
  
  bool _isConnectionValid(HttpClientConnection connection) {
    return connection.ageInSeconds < 300 && // 5分钟过期
           !connection.client.connectionTimeout.isNegative;
  }
  
  void _trimPoolIfNeeded() {
    while (_availableConnections.length > maxSize) {
      final connection = _availableConnections.removeAt(0);
      _closeConnection(connection);
    }
  }
  
  Future<void> _closeConnection(HttpClientConnection connection) async {
    try {
      _connections.remove(connection);
      connection.client.close();
    } catch (e) {
      // 忽略关闭错误
    }
  }
  
  void cleanupExpiredConnections(DateTime now) {
    final expiredConnections = _availableConnections;
.where((conn) => conn.isExpired(const Duration(minutes: 5));
        .toList();
    
    for (final connection in expiredConnections) {
      _availableConnections.remove(connection);
      _closeConnection(connection);
    }
  }
  
  void resize(int newSize) {
    maxSize = newSize;
    _trimPoolIfNeeded();
  }
  
  void adjustForNetworkQuality(NetworkQuality quality) {
    switch (quality) {
      case NetworkQuality.excellent:
        maxSize = (maxSize * 1.2).round();
        break;
      case NetworkQuality.poor:
        maxSize = (maxSize * 0.8).round();
        break;
      default:
        // 不调整
        break;
    }
    maxSize = maxSize.clamp(1, 50);
  }
  
  bool get isEmpty => _connections.isEmpty;
  
  int get activeConnections => _connections.where((conn) => conn.isInUse).length;
  
  PoolStatus getStatus() {
    return PoolStatus(
      host: host,
      port: port,
      type: type,
      totalConnections: _connections.length,
      availableConnections: _availableConnections.length,
      activeConnections: activeConnections,
      maxSize: maxSize,
    );
  }
  
  Future<void> dispose() async {
    for (final connection in _connections) {
      await _closeConnection(connection);
    }
    _connections.clear();
    _availableConnections.clear();
  }
}

/// 网络连接统计
class NetworkConnectionStats {
  int totalConnections = 0;
  int activeConnections = 0;
  int successfulConnections = 0;
  int unhealthyConnections = 0;
  int healthyConnections = 0;
  int totalRequests = 0;
  int successfulRequests = 0;
  int failedRequests = 0;
  int fastResponses = 0;
  int normalResponses = 0;
  int slowResponses = 0;
  int avgResponseTime = 0;
  DateTime? lastActivityTime;
  
  double get successRate {
    if (totalConnections == 0) return 0.0;
    return (successfulConnections / totalConnections * 100).toDouble();
  }
  
  double get avgResponseTimeMs => avgResponseTime.toDouble();
  
  Map<String, dynamic> toJson() {
    return {
      'totalConnections': totalConnections,
      'activeConnections': activeConnections,
      'successfulConnections': successfulConnections,
      'unhealthyConnections': unhealthyConnections,
      'healthyConnections': healthyConnections,
      'totalRequests': totalRequests,
      'successfulRequests': successfulRequests,
      'failedRequests': failedRequests,
      'fastResponses': fastResponses,
      'normalResponses': normalResponses,
      'slowResponses': slowResponses,
      'avgResponseTime': avgResponseTime,
      'successRate': successRate,
      'lastActivityTime': lastActivityTime?.toIso8601String(),
    };
  }
}

/// 连接池状态
class PoolStatus {
  final String host;
  final int port;
  final ProxyType type;
  final int totalConnections;
  final int availableConnections;
  final int activeConnections;
  final int maxSize;
  
  PoolStatus({
    required this.host,
    required this.port,
    required this.type,
    required this.totalConnections,
    required this.availableConnections,
    required this.activeConnections,
    required this.maxSize,
  });
  
  double get utilizationRate {
    if (maxSize == 0) return 0.0;
    return (activeConnections / maxSize * 100).toDouble();
  }
  
  bool get isHealthy => activeConnections < maxSize * 0.8;
}

/// 代理类型
enum ProxyType {
  http,
  https,
  socks4,
  socks5,
}

/// 网络质量
enum NetworkQuality {
  excellent,
  good,
  fair,
  poor,
}

/// 网络质量检测器
class NetworkQualityDetector {
  NetworkQuality _currentQuality = NetworkQuality.good;
  
  Future<void> initialize() async {
    log('[NetworkQualityDetector] 网络质量检测器已初始化');
  }
  
  Future<NetworkQuality> detectQuality() async {
    try {
      // 简单的网络质量检测
      final stopwatch = Stopwatch()..start();
      
      final socket = await Socket.connect('8.8.8.8', 53, timeout: const Duration(seconds: 5));
      socket.destroy();
      
      final responseTime = stopwatch.elapsedMilliseconds;
      stopwatch.stop();
      
      if (responseTime < 50) {
        _currentQuality = NetworkQuality.excellent;
      } else if (responseTime < 150) {
        _currentQuality = NetworkQuality.good;
      } else if (responseTime < 300) {
        _currentQuality = NetworkQuality.fair;
      } else {
        _currentQuality = NetworkQuality.poor;
      }
      
      return _currentQuality;
    } catch (e) {
      _currentQuality = NetworkQuality.poor;
      return _currentQuality;
    }
  }
  
  NetworkQuality get currentQuality => _currentQuality;
  
  Future<void> dispose() async {
    log('[NetworkQualityDetector] 网络质量检测器已销毁');
  }
}

/// 路径优化器
class PathOptimizer {
  bool _isEnabled = false;
  
  Future<void> initialize() async {
    log('[PathOptimizer] 路径优化器已初始化');
  }
  
  Future<void> enableOptimization() async {
    _isEnabled = true;
    log('[PathOptimizer] 路径优化已启用');
  }
  
  Future<List<String>> optimizePath(String target) async {
    // 简化的路径优化实现
    return [target];
  }
  
  Future<void> dispose() async {
    log('[PathOptimizer] 路径优化器已销毁');
  }
}

/// DNS解析器
class DnsResolver {
  final Map<String, InternetAddress> _cache = {};
  
  Future<void> initialize() async {
    log('[DnsResolver] DNS解析器已初始化');
  }
  
  Future<InternetAddress> resolve(String hostname) async {
    if (_cache.containsKey(hostname)) {
      return _cache[hostname]!;
    }
    
    try {
      final addresses = await InternetAddress.lookup(hostname);
      final address = addresses.first;
      _cache[hostname] = address;
      return address;
    } catch (e) {
      log('[DnsResolver] DNS解析失败: $hostname - $e');
      rethrow;
    }
  }
  
  void clearCache() {
    _cache.clear();
    log('[DnsResolver] DNS缓存已清理');
  }
  
  Future<void> dispose() async {
    _cache.clear();
    log('[DnsResolver] DNS解析器已销毁');
  }
}

/// 日志辅助函数
void log(String message, {int level = 200, String tag = 'NetworkConnectionManager'}) {
  final logMessage = '[$tag] $message';
  if (level >= 500) {
    developer.log(logMessage, level: level, name: tag);
  }
}