import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'error_recovery_manager.dart';
import 'exception_handler.dart';

/// 网络状态枚举
enum NetworkStatus {
  /// 未知状态
  unknown,
  /// 已连接
  connected,
  /// 断开连接
  disconnected,
  /// 连接中
  connecting,
  /// 连接超时
  timeout,
  /// 网络不可用
  unavailable,
  /// 网络切换
  switching,
}

/// 网络类型
enum NetworkType {
  /// 未知类型
  unknown,
  /// WiFi
  wifi,
  /// 移动网络
  mobile,
  /// 以太网
  ethernet,
  /// 蓝牙
  bluetooth,
}

/// 网络错误严重程度
enum NetworkErrorSeverity {
  /// 轻微 - 不影响核心功能
  minor,
  /// 中等 - 影响部分功能
  moderate,
  /// 严重 - 影响主要功能
  severe,
  /// 关键 - 影响整个网络功能
  critical,
}

/// 网络错误类型
enum NetworkErrorType {
  /// 连接超时
  connectionTimeout,
  /// 连接拒绝
  connectionRefused,
  /// 网络不可达
  networkUnreachable,
  /// DNS解析失败
  dnsResolutionFailed,
  /// 连接中断
  connectionReset,
  /// SSL/TLS错误
  sslError,
  /// 认证失败
  authenticationFailed,
  /// 代理错误
  proxyError,
  /// 服务器错误
  serverError,
  /// 带宽不足
  bandwidthInsufficient,
  /// 未知错误
  unknown,
}

/// 网络连接配置
class NetworkConnectionConfig {
  final Duration connectionTimeout;
  final Duration readTimeout;
  final Duration writeTimeout;
  final int maxRetries;
  final Duration retryDelay;
  final bool enableAutomaticRetry;
  final bool enableConnectionPooling;
  final bool enableSSLVerification;
  final List<String> trustedCertificates;
  final Map<String, String> customHeaders;
  
  const NetworkConnectionConfig({
    this.connectionTimeout = const Duration(seconds: 30),
    this.readTimeout = const Duration(seconds: 30),
    this.writeTimeout = const Duration(seconds: 30),
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
    this.enableAutomaticRetry = true,
    this.enableConnectionPooling = true,
    this.enableSSLVerification = true,
    this.trustedCertificates = const [],
    this.customHeaders = const {},
  });
}

/// 网络连接详情
class NetworkConnectionDetails {
  final NetworkType type;
  final String? ssid;
  final String? bssid;
  final int? signalStrength;
  final bool isConnected;
  final bool isSecure;
  final String? gatewayAddress;
  final String? dnsServers;
  final Duration lastConnectionDuration;
  
  const NetworkConnectionDetails({
    required this.type,
    this.ssid,
    this.bssid,
    this.signalStrength,
    required this.isConnected,
    required this.isSecure,
    this.gatewayAddress,
    this.dnsServers,
    required this.lastConnectionDuration,
  });
}

/// 网络错误信息
class NetworkErrorInfo {
  final String errorId;
  final NetworkErrorType type;
  final NetworkErrorSeverity severity;
  final String message;
  final String? host;
  final int? port;
  final String? protocol;
  final DateTime timestamp;
  final StackTrace? stackTrace;
  final Map<String, dynamic> context;
  final int retryCount;
  
  const NetworkErrorInfo({
    required this.errorId,
    required this.type,
    required this.severity,
    required this.message,
    this.host,
    this.port,
    this.protocol,
    required this.timestamp,
    this.stackTrace,
    this.context = const {},
    this.retryCount = 0,
  });
}

/// 网络连接测试结果
class NetworkTestResult {
  final bool success;
  final Duration latency;
  final String? errorMessage;
  final String? serverResponse;
  final int bytesDownloaded;
  final int bytesUploaded;
  final double throughputMbps;
  
  const NetworkTestResult({
    required this.success,
    required this.latency,
    this.errorMessage,
    this.serverResponse,
    required this.bytesDownloaded,
    required this.bytesUploaded,
    required this.throughputMbps,
  });
}

/// 网络状态变更监听器
typedef NetworkStatusListener = void Function(NetworkStatus oldStatus, NetworkStatus newStatus, NetworkType? type);

/// 网络错误监听器
typedef NetworkErrorListener = void Function(NetworkErrorInfo errorInfo);

/// 网络连接测试监听器
typedef NetworkTestListener = void Function(NetworkTestResult result);

/// 网络错误处理器
class NetworkErrorHandler {
  static final NetworkErrorHandler _instance = NetworkErrorHandler._internal();
  factory NetworkErrorHandler() => _instance;
  NetworkErrorHandler._internal();
  
  final Logger _logger = Logger('NetworkErrorHandler');
  
  /// 网络连接配置
  NetworkConnectionConfig _config = const NetworkConnectionConfig();
  
  /// 当前网络状态
  NetworkStatus _currentStatus = NetworkStatus.unknown;
  
  /// 当前网络类型
  NetworkType _currentNetworkType = NetworkType.unknown;
  
  /// 连接检查器
  final List<ConnectivityResult> _connectivityResults = [];
  
  /// 活跃的网络监听器
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  
  /// 状态变更监听器
  final List<NetworkStatusListener> _statusListeners = [];
  
  /// 错误监听器
  final List<NetworkErrorListener> _errorListeners = [];
  
  /// 测试监听器
  final List<NetworkTestListener> _testListeners = [];
  
  /// 连接尝试次数映射
  final Map<String, int> _connectionAttempts = {};
  
  /// 网络错误统计
  final Map<NetworkErrorType, int> _errorStats = {};
  
  /// 最后连接时间
  DateTime? _lastConnectedTime;
  
  /// 网络健康状态
  double _networkHealth = 1.0;
  
  /// 网络监控定时器
  Timer? _networkMonitorTimer;
  
  /// 连接测试定时器
  Timer? _connectivityTestTimer;
  
  /// 初始化网络错误处理器
  Future<void> initialize([NetworkConnectionConfig? config]) async {
    if (config != null) {
      _config = config;
    }
    
    _logger.info('初始化网络错误处理器');
    
    // 初始化连接监听
    await _setupConnectivityMonitoring();
    
    // 设置定时网络监控
    _setupNetworkMonitoring();
    
    // 设置定时连接测试
    _setupConnectivityTesting();
    
    // 初始网络状态检查
    await _checkInitialNetworkStatus();
    
    _logger.info('网络错误处理器初始化完成');
  }
  
  /// 设置连接监听
  Future<void> _setupConnectivityMonitoring() async {
    try {
      _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
        _handleConnectivityChanged,
        onError: (error) {
          _logger.error('连接监听错误: $error');
        },
      );
    } catch (e) {
      _logger.error('设置连接监听失败: $e');
    }
  }
  
  /// 处理连接状态变更
  void _handleConnectivityChanged(ConnectivityResult result) {
    final oldStatus = _currentStatus;
    
    _logger.info('连接状态变更: $result');
    
    // 更新连接结果
    _connectivityResults.add(result);
    if (_connectivityResults.length > 10) {
      _connectivityResults.removeAt(0);
    }
    
    // 确定网络状态
    _updateNetworkStatus(result);
    
    // 通知监听器
    if (oldStatus != _currentStatus) {
      for (final listener in _statusListeners) {
        try {
          listener(oldStatus, _currentStatus, _currentNetworkType);
        } catch (e) {
          _logger.error('通知状态监听器失败: $e');
        }
      }
    }
  }
  
  /// 更新网络状态
  void _updateNetworkStatus(ConnectivityResult connectivityResult) {
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        _currentStatus = NetworkStatus.connected;
        _currentNetworkType = NetworkType.mobile;
        break;
      case ConnectivityResult.wifi:
        _currentStatus = NetworkStatus.connected;
        _currentNetworkType = NetworkType.wifi;
        break;
      case ConnectivityResult.ethernet:
        _currentStatus = NetworkStatus.connected;
        _currentNetworkType = NetworkType.ethernet;
        break;
      case ConnectivityResult.none:
        _currentStatus = NetworkStatus.disconnected;
        _currentNetworkType = NetworkType.unknown;
        break;
      case ConnectivityResult.vpn:
        _currentStatus = NetworkStatus.connected;
        _currentNetworkType = NetworkType.wifi;
        break;
      case ConnectivityResult.other:
        _currentStatus = NetworkStatus.connected;
        _currentNetworkType = NetworkType.unknown;
        break;
      default:
        _currentStatus = NetworkStatus.disconnected;
        _currentNetworkType = NetworkType.unknown;
    }
    
    if (_currentStatus == NetworkStatus.connected) {
      _lastConnectedTime = DateTime.now();
    }
  }
  
  /// 设置网络监控
  void _setupNetworkMonitoring() {
    _networkMonitorTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) => _performNetworkHealthCheck(),
    );
  }
  
  /// 设置连接测试
  void _setupConnectivityTesting() {
    _connectivityTestTimer = Timer.periodic(
      const Duration(minutes: 5),
      (timer) => _performConnectivityTest(),
    );
  }
  
  /// 执行网络健康检查
  Future<void> _performNetworkHealthCheck() async {
    try {
      // 执行简单的网络健康检查
      final testResult = await testConnection('8.8.8.8', 53);
      
      // 更新网络健康状态
      if (testResult.success) {
        _networkHealth = 1.0;
      } else {
        _networkHealth = (_networkHealth - 0.1).clamp(0.0, 1.0);
      }
      
      _logger.debug('网络健康检查: ${(testResult.success ? '健康' : '不健康')} (${(_networkHealth * 100).toInt()}%)');
      
    } catch (e) {
      _logger.error('网络健康检查失败: $e');
    }
  }
  
  /// 执行连接测试
  Future<void> _performConnectivityTest() async {
    try {
      final result = await testConnection();
      
      for (final listener in _testListeners) {
        try {
          listener(result);
        } catch (e) {
          _logger.error('通知测试监听器失败: $e');
        }
      }
      
    } catch (e) {
      _logger.error('执行连接测试失败: $e');
    }
  }
  
  /// 检查初始网络状态
  Future<void> _checkInitialNetworkStatus() async {
    try {
      final results = await Connectivity().checkConnectivity();
      if (results.isNotEmpty) {
        _handleConnectivityChanged(results.first);
      }
    } catch (e) {
      _logger.error('检查初始网络状态失败: $e');
    }
  }
  
  /// 处理网络错误
  Future<void> handleNetworkError(
    Object error, [
    StackTrace? stackTrace,
    String? host,
    int? port,
    String? protocol,
  ]) async {
    // 分类网络错误
    final errorType = _classifyNetworkError(error);
    final severity = _determineErrorSeverity(errorType, error);
    final errorId = _generateErrorId();
    
    _logger.error('网络错误处理: $error', error: error, stackTrace: stackTrace);
    
    // 创建错误信息
    final errorInfo = NetworkErrorInfo(
      errorId: errorId,
      type: errorType,
      severity: severity,
      message: error.toString(),
      host: host,
      port: port,
      protocol: protocol,
      timestamp: DateTime.now(),
      stackTrace: stackTrace,
      context: {
        'currentStatus': _currentStatus.toString(),
        'networkType': _currentNetworkType.toString(),
        'config': _config.toString(),
      },
    );
    
    // 更新错误统计
    _updateErrorStats(errorType);
    
    // 通知错误监听器
    for (final listener in _errorListeners) {
      try {
        listener(errorInfo);
      } catch (e) {
        _logger.error('通知错误监听器失败: $e');
      }
    }
    
    // 尝试自动恢复
    if (_config.enableAutomaticRetry) {
      await _attemptAutomaticRecovery(errorInfo);
    }
  }
  
  /// 分类网络错误
  NetworkErrorType _classifyNetworkError(Object error) {
    final errorString = error.toString().toLowerCase();
    
    if (error is SocketException) {
      if (errorString.contains('timeout') || errorString.contains('timed out')) {
        return NetworkErrorType.connectionTimeout;
      } else if (errorString.contains('connection refused')) {
        return NetworkErrorType.connectionRefused;
      } else if (errorString.contains('network unreachable')) {
        return NetworkErrorType.networkUnreachable;
      } else if (errorString.contains('reset')) {
        return NetworkErrorType.connectionReset;
      }
    } else if (error is TimeoutException) {
      return NetworkErrorType.connectionTimeout;
    } else if (error is HttpException) {
      if (errorString.contains('500') || errorString.contains('server error')) {
        return NetworkErrorType.serverError;
      }
    } else if (error is TlsException || error is HandshakeException) {
      return NetworkErrorType.sslError;
    } else if (errorString.contains('dns')) {
      return NetworkErrorType.dnsResolutionFailed;
    } else if (errorString.contains('proxy')) {
      return NetworkErrorType.proxyError;
    } else if (errorString.contains('authentication') || errorString.contains('unauthorized')) {
      return NetworkErrorType.authenticationFailed;
    }
    
    return NetworkErrorType.unknown;
  }
  
  /// 确定错误严重程度
  NetworkErrorSeverity _determineErrorSeverity(NetworkErrorType errorType, Object error) {
    switch (errorType) {
      case NetworkErrorType.connectionTimeout:
        return NetworkErrorSeverity.moderate;
      case NetworkErrorType.connectionRefused:
        return NetworkErrorSeverity.moderate;
      case NetworkErrorType.networkUnreachable:
        return NetworkErrorSeverity.severe;
      case NetworkErrorType.dnsResolutionFailed:
        return NetworkErrorSeverity.severe;
      case NetworkErrorType.connectionReset:
        return NetworkErrorSeverity.moderate;
      case NetworkErrorType.sslError:
        return NetworkErrorSeverity.critical;
      case NetworkErrorType.authenticationFailed:
        return NetworkErrorSeverity.moderate;
      case NetworkErrorType.proxyError:
        return NetworkErrorSeverity.moderate;
      case NetworkErrorType.serverError:
        return NetworkErrorSeverity.moderate;
      case NetworkErrorType.bandwidthInsufficient:
        return NetworkErrorSeverity.minor;
      case NetworkErrorType.unknown:
        return NetworkErrorSeverity.moderate;
    }
  }
  
  /// 生成错误ID
  String _generateErrorId() {
    return 'NET_${DateTime.now().millisecondsSinceEpoch}_${_errorStats.length}';
  }
  
  /// 更新错误统计
  void _updateErrorStats(NetworkErrorType errorType) {
    _errorStats[errorType] = (_errorStats[errorType] ?? 0) + 1;
  }
  
  /// 尝试自动恢复
  Future<void> _attemptAutomaticRecovery(NetworkErrorInfo errorInfo) async {
    final key = '${errorInfo.host}_${errorInfo.port}_${errorInfo.type}';
    final currentAttempts = _connectionAttempts[key] ?? 0;
    
    if (currentAttempts < _config.maxRetries) {
      _connectionAttempts[key] = currentAttempts + 1;
      
      _logger.info('尝试自动恢复: $key (第${currentAttempts + 1}次)');
      
      // 延迟重试
      await Future.delayed(_config.retryDelay * (currentAttempts + 1));
      
      // 重新尝试连接
      await _retryConnection(errorInfo);
    } else {
      _logger.warning('达到最大重试次数: $key');
      _connectionAttempts.remove(key);
    }
  }
  
  /// 重试连接
  Future<void> _retryConnection(NetworkErrorInfo errorInfo) async {
    if (errorInfo.host != null && errorInfo.port != null) {
      try {
        final socket = await Socket.connect(
          errorInfo.host!,
          errorInfo.port!,
          timeout: _config.connectionTimeout,
        );
        
        _logger.info('重试连接成功: ${errorInfo.host}:${errorInfo.port}');
        socket.close();
        
        // 清除重试计数
        final key = '${errorInfo.host}_${errorInfo.port}_${errorInfo.type}';
        _connectionAttempts.remove(key);
        
      } catch (e) {
        _logger.error('重试连接失败: $e');
        
        // 如果还是失败，记录并可能需要手动干预
        if (_connectionAttempts['${errorInfo.host}_${errorInfo.port}_${errorInfo.type}'] == _config.maxRetries) {
          _logger.warning('最终重试失败，需要手动干预: ${errorInfo.host}:${errorInfo.port}');
        }
      }
    }
  }
  
  /// 测试网络连接
  Future<NetworkTestResult> testConnection([
    String? host,
    int port = 80,
    Duration? timeout,
  ]) async {
    final testHost = host ?? '8.8.8.8';
    final testPort = port;
    final testTimeout = timeout ?? _config.connectionTimeout;
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.debug('测试连接: $testHost:$testPort');
      
      final socket = await Socket.connect(
        testHost,
        testPort,
        timeout: testTimeout,
      );
      
      stopwatch.stop();
      final latency = stopwatch.elapsed;
      socket.close();
      
      final result = NetworkTestResult(
        success: true,
        latency: latency,
        bytesDownloaded: 0,
        bytesUploaded: 0,
        throughputMbps: 0.0,
      );
      
      _logger.debug('连接测试成功: $testHost:$testPort, 延迟: $latency');
      return result;
      
    } catch (e) {
      stopwatch.stop();
      _logger.debug('连接测试失败: $testHost:$testPort, 错误: $e');
      
      return NetworkTestResult(
        success: false,
        latency: stopwatch.elapsed,
        errorMessage: e.toString(),
        bytesDownloaded: 0,
        bytesUploaded: 0,
        throughputMbps: 0.0,
      );
    }
  }
  
  /// 获取网络连接详情
  Future<NetworkConnectionDetails?> getConnectionDetails() async {
    try {
      final results = await Connectivity().checkConnectivity();
      if (results.isEmpty) {
        return null;
      }
      
      final result = results.first;
      NetworkType type;
      bool isConnected;
      String? ssid;
      String? bssid;
      int? signalStrength;
      
      switch (result) {
        case ConnectivityResult.mobile:
          type = NetworkType.mobile;
          isConnected = true;
          break;
        case ConnectivityResult.wifi:
          type = NetworkType.wifi;
          isConnected = true;
          // WiFi信息需要额外的权限和API获取
          ssid = 'Unknown'; // 占位符
          bssid = 'Unknown'; // 占位符
          signalStrength = 100; // 占位符
          break;
        case ConnectivityResult.ethernet:
          type = NetworkType.ethernet;
          isConnected = true;
          break;
        case ConnectivityResult.vpn:
          type = NetworkType.wifi;
          isConnected = true;
          break;
        case ConnectivityResult.other:
          type = NetworkType.unknown;
          isConnected = true;
          break;
        case ConnectivityResult.none:
          type = NetworkType.unknown;
          isConnected = false;
          break;
        default:
          type = NetworkType.unknown;
          isConnected = false;
      }
      
      return NetworkConnectionDetails(
        type: type,
        ssid: ssid,
        bssid: bssid,
        signalStrength: signalStrength,
        isConnected: isConnected,
        isSecure: type == NetworkType.wifi || type == NetworkType.ethernet,
        gatewayAddress: null,
        dnsServers: null,
        lastConnectionDuration: _lastConnectedTime != null 
            ? DateTime.now().difference(_lastConnectedTime!)
            : Duration.zero,
      );
      
    } catch (e) {
      _logger.error('获取连接详情失败: $e');
      return null;
    }
  }
  
  /// 获取网络状态
  NetworkStatus get currentStatus => _currentStatus;
  
  /// 获取网络类型
  NetworkType get currentNetworkType => _currentNetworkType;
  
  /// 检查是否连接
  bool get isConnected => _currentStatus == NetworkStatus.connected;
  
  /// 获取网络健康状态
  double get networkHealth => _networkHealth;
  
  /// 获取错误统计
  Map<NetworkErrorType, int> get errorStatistics => Map.unmodifiable(_errorStats);
  
  /// 获取连接详情
  Future<NetworkConnectionDetails?> get connectionDetails => getConnectionDetails();
  
  /// 添加状态监听器
  void addStatusListener(NetworkStatusListener listener) {
    _statusListeners.add(listener);
  }
  
  /// 移除状态监听器
  void removeStatusListener(NetworkStatusListener listener) {
    _statusListeners.remove(listener);
  }
  
  /// 添加错误监听器
  void addErrorListener(NetworkErrorListener listener) {
    _errorListeners.add(listener);
  }
  
  /// 移除错误监听器
  void removeErrorListener(NetworkErrorListener listener) {
    _errorListeners.remove(listener);
  }
  
  /// 添加测试监听器
  void addTestListener(NetworkTestListener listener) {
    _testListeners.add(listener);
  }
  
  /// 移除测试监听器
  void removeTestListener(NetworkTestListener listener) {
    _testListeners.remove(listener);
  }
  
  /// 更新配置
  void updateConfig(NetworkConnectionConfig newConfig) {
    _config = newConfig;
    _logger.info('更新网络连接配置');
  }
  
  /// 获取配置
  NetworkConnectionConfig get config => _config;
  
  /// 清除错误统计
  void clearErrorStatistics() {
    _errorStats.clear();
    _connectionAttempts.clear();
    _logger.info('清除网络错误统计');
  }
  
  /// 关闭处理器
  Future<void> dispose() async {
    _logger.info('关闭网络错误处理器');
    
    // 取消监听器
    await _connectivitySubscription?.cancel();
    
    // 取消定时器
    _networkMonitorTimer?.cancel();
    _connectivityTestTimer?.cancel();
    
    // 清理监听器列表
    _statusListeners.clear();
    _errorListeners.clear();
    _testListeners.clear();
    
    // 清理连接详情
    _lastConnectedTime = null;
  }
}