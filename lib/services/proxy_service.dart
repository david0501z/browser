import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'proxy_lifecycle_manager.dart';
import 'config_manager.dart';
import 'error_handler.dart';

/// 代理服务状态枚举
enum ProxyServiceState {
  /// 未初始化
  uninitialized,
  /// 已初始化
  initialized,
  /// 连接中
  connecting,
  /// 已连接
  connected,
  /// 断开连接
  disconnected,
  /// 错误状态
  error,
  /// 关闭中
  closing,
  /// 已关闭
  closed,
}

/// 代理服务事件类型
enum ProxyEventType {
  /// 服务启动
  serviceStarted,
  /// 服务停止
  serviceStopped,
  /// 连接建立
  connectionEstablished,
  /// 连接断开
  connectionLost,
  /// 配置加载
  configLoaded,
  /// 错误发生
  error,
  /// 状态变化
  stateChanged,
}

/// 代理服务事件
class ProxyServiceEvent {
  final ProxyEventType type;
  final String? message;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  const ProxyServiceEvent({
    required this.type,
    this.message,
    this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'ProxyServiceEvent{type: $type, message: $message, timestamp: $timestamp}';
  }
}

/// 代理连接信息
class ProxyConnectionInfo {
  final String proxyType;
  final String serverHost;
  final int serverPort;
  final String? username;
  final String? password;
  final Map<String, dynamic>? additionalConfig;
  final DateTime connectedAt;

  const ProxyConnectionInfo({
    required this.proxyType,
    required this.serverHost,
    required this.serverPort,
    this.username,
    this.password,
    this.additionalConfig,
    DateTime? connectedAt,
  }) : connectedAt = connectedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'proxyType': proxyType,
    'serverHost': serverHost,
    'serverPort': serverPort,
    'username': username,
    'password': password,
    'additionalConfig': additionalConfig,
    'connectedAt': connectedAt.toIso8601String(),
  };

  factory ProxyConnectionInfo.fromJson(Map<String, dynamic> json) => ProxyConnectionInfo(
    proxyType: json['proxyType'] as String,
    serverHost: json['serverHost'] as String,
    serverPort: json['serverPort'] as int,
    username: json['username'] as String?,
    password: json['password'] as String?,
    additionalConfig: json['additionalConfig'] as Map<String, dynamic>?,
    connectedAt: DateTime.parse(json['connectedAt'] as String),
  );
}

/// 高级代理服务类
/// 
/// 封装FFI桥接功能，提供高级代理服务：
/// - 代理连接管理
/// - 配置管理
/// - 生命周期控制
/// - 错误处理
/// - 事件监控
class ProxyService {
  static ProxyService? _instance;
  static ProxyService get instance => _instance ??= ProxyService._();
  
  ProxyService._();

  // FFI桥接变量
  late DynamicLibrary _library;
  
  // FFI函数指针
  late Pointer<NativeFunction<Int32 Function(Pointer<Char>)>> _connectFunction;
  late Pointer<NativeFunction<Int32 Function()>> _disconnectFunction;
  late Pointer<NativeFunction<Int32 Function(Pointer<Char>)>> _testFunction;
  late Pointer<NativeFunction<Int32 Function(Pointer<Char>)>> _getStatusFunction;
  late Pointer<NativeFunction<Int32 Function(Pointer<Char>)>> _setConfigFunction;

  // 事件流控制器
  final StreamController<ProxyServiceEvent> _eventController = StreamController.broadcast();
  Stream<ProxyServiceEvent> get eventStream => _eventController.stream;

  // 状态流控制器
  final StreamController<ProxyServiceState> _stateController = StreamController.broadcast();
  Stream<ProxyServiceState> get stateStream => _stateController.stream;

  // 当前状态
  ProxyServiceState _currentState = ProxyServiceState.uninitialized;
  ProxyServiceState get currentState => _currentState;

  // 当前连接信息
  ProxyConnectionInfo? _currentConnection;
  ProxyConnectionInfo? get currentConnection => _currentConnection;

  // 依赖服务
  late final ProxyLifecycleManager _lifecycleManager;
  late final ConfigManager _configManager;
  late final ErrorHandler _errorHandler;

  // 订阅句柄
  int? _statusSubscriptionHandle;
  Timer? _statusCheckTimer;

  /// 初始化代理服务
  Future<bool> initialize() async {
    try {
      if (_currentState != ProxyServiceState.uninitialized) {
        return _currentState != ProxyServiceState.error;
      }

      _updateState(ProxyServiceState.initialized);
      
      // 初始化依赖服务
      await _initializeDependencies();
      
      // 加载动态库
      await _loadLibrary();
      
      // 初始化函数指针
      _initializeFunctionPointers();
      
      _emitEvent(ProxyServiceEvent(
        type: ProxyEventType.serviceStarted,
        message: 'Proxy service initialized successfully',
      ));
      
      return true;
    } catch (e, stackTrace) {
      _updateState(ProxyServiceState.error);
      _errorHandler.handleError(
        'ProxyService.initialize',
        e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// 初始化依赖服务
  Future<void> _initializeDependencies() async {
    try {
      _lifecycleManager = ProxyLifecycleManager.instance;
      _configManager = ConfigManager.instance;
      _errorHandler = ErrorHandler.instance;

      // 初始化依赖服务
      await _lifecycleManager.initialize();
      await _configManager.initialize();
      await _errorHandler.initialize();

      // 订阅生命周期事件
      _lifecycleManager.eventStream.listen(_handleLifecycleEvent);
    } catch (e, stackTrace) {
      _errorHandler.handleError(
        'ProxyService._initializeDependencies',
        e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// 加载动态库
  Future<void> _loadLibrary() async {
    try {
      if (Platform.isAndroid) {
        _library = DynamicLibrary.open('libflutter_proxy_bridge.so');
      } else if (Platform.isWindows) {
        _library = DynamicLibrary.open('flutter_proxy_bridge.dll');
      } else if (Platform.isLinux) {
        _library = DynamicLibrary.open('libflutter_proxy_bridge.so');
      } else if (Platform.isMacOS) {
        _library = DynamicLibrary.open('libflutter_proxy_bridge.dylib');
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    } catch (e, stackTrace) {
      _errorHandler.handleError(
        'ProxyService._loadLibrary',
        e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// 初始化函数指针
  void _initializeFunctionPointers() {
    try {
      _connectFunction = _library.lookup<NativeFunction<Int32 Function(Pointer<Char>)>>('proxy_connect');
      _disconnectFunction = _library.lookup<NativeFunction<Int32 Function()>>('proxy_disconnect');
      _testFunction = _library.lookup<NativeFunction<Int32 Function(Pointer<Char>)>>('proxy_test');
      _getStatusFunction = _library.lookup<NativeFunction<Int32 Function(Pointer<Char>)>>('proxy_get_status');
      _setConfigFunction = _library.lookup<NativeFunction<Int32 Function(Pointer<Char>)>>('proxy_set_config');
    } catch (e, stackTrace) {
      _errorHandler.handleError(
        'ProxyService._initializeFunctionPointers',
        e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// 建立代理连接
  Future<bool> connect({
    required String proxyType,
    required String serverHost,
    required int serverPort,
    String? username,
    String? password,
    Map<String, dynamic>? additionalConfig,
  }) async {
    try {
      if (_currentState == ProxyServiceState.connected) {
        await disconnect();
      }

      _updateState(ProxyServiceState.connecting);

      // 创建连接信息
      _currentConnection = ProxyConnectionInfo(
        proxyType: proxyType,
        serverHost: serverHost,
        serverPort: serverPort,
        username: username,
        password: password,
        additionalConfig: additionalConfig,
      );

      // 构建配置JSON
      final configJson = jsonEncode({
        'type': proxyType,
        'host': serverHost,
        'port': serverPort,
        'username': username,
        'password': password,
        'additional': additionalConfig ?? {},
      });

      // 调用FFI连接函数
      final configCString = configJson.toNativeUtf8();
      final result = _connectFunction.asFunction<int Function(Pointer<Utf8>)>()(configCString);
      malloc.free(configCString);

      if (result == 0) {
        _updateState(ProxyServiceState.connected);
        _startStatusMonitoring();
        
        _emitEvent(ProxyServiceEvent(
          type: ProxyEventType.connectionEstablished,
          message: 'Connected to proxy server: $serverHost:$serverPort',
          data: _currentConnection?.toJson(),
        ));

        // 通知生命周期管理器
        _lifecycleManager.onConnectionEstablished(_currentConnection!);
        
        return true;
      } else {
        throw ProxyException('Failed to connect to proxy server', result);
      }
    } catch (e, stackTrace) {
      _updateState(ProxyServiceState.error);
      _errorHandler.handleError(
        'ProxyService.connect',
        e,
        stackTrace: stackTrace,
      );
      _emitEvent(ProxyServiceEvent(
        type: ProxyEventType.error,
        message: 'Connection failed: $e',
        data: {'error': e.toString()},
      ));
      return false;
    }
  }

  /// 断开代理连接
  Future<bool> disconnect() async {
    try {
      if (_currentState != ProxyServiceState.connected) {
        return true;
      }

      _updateState(ProxyServiceState.closing);

      // 停止状态监控
      _stopStatusMonitoring();

      // 调用FFI断开函数
      final result = _disconnectFunction.asFunction<int Function()>()();

      if (result == 0) {
        _updateState(ProxyServiceState.disconnected);
        _currentConnection = null;
        
        _emitEvent(ProxyServiceEvent(
          type: ProxyEventType.connectionLost,
          message: 'Disconnected from proxy server',
        ));

        // 通知生命周期管理器
        _lifecycleManager.onConnectionLost();
        
        return true;
      } else {
        throw ProxyException('Failed to disconnect from proxy server', result);
      }
    } catch (e, stackTrace) {
      _updateState(ProxyServiceState.error);
      _errorHandler.handleError(
        'ProxyService.disconnect',
        e,
        stackTrace: stackTrace,
      );
      _emitEvent(ProxyServiceEvent(
        type: ProxyEventType.error,
        message: 'Disconnection failed: $e',
        data: {'error': e.toString()},
      ));
      return false;
    }
  }

  /// 测试代理连接
  Future<bool> testConnection(String? testUrl) async {
    try {
      final testData = jsonEncode({
        'url': testUrl ?? 'https://www.google.com',
        'timeout': 5000,
      });

      final testCString = testData.toNativeUtf8();
      final result = _testFunction.asFunction<int Function(Pointer<Utf8>)>()(testCString);
      malloc.free(testCString);

      return result == 0;
    } catch (e, stackTrace) {
      _errorHandler.handleError(
        'ProxyService.testConnection',
        e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// 获取代理状态
  Future<String> getProxyStatus() async {
    try {
      final statusCString = 'status'.toNativeUtf8();
      final result = _getStatusFunction.asFunction<int Function(Pointer<Utf8>)>()(statusCString);
      malloc.free(statusCString);

      // 这里需要处理返回的JSON字符串
      // 实际实现中需要从C内存中读取返回的字符串
      return '{"status": "unknown"}';
    } catch (e, stackTrace) {
      _errorHandler.handleError(
        'ProxyService.getProxyStatus',
        e,
        stackTrace: stackTrace,
      );
      return '{"status": "error", "message": "$e"}';
    }
  }

  /// 设置代理配置
  Future<bool> setProxyConfig(Map<String, dynamic> config) async {
    try {
      final configJson = jsonEncode(config);
      final configCString = configJson.toNativeUtf8();
      final result = _setConfigFunction.asFunction<int Function(Pointer<Utf8>)>()(configCString);
      malloc.free(configCString);

      if (result == 0) {
        _emitEvent(ProxyServiceEvent(
          type: ProxyEventType.configLoaded,
          message: 'Configuration updated',
          data: config,
        ));
        return true;
      }

      return false;
    } catch (e, stackTrace) {
      _errorHandler.handleError(
        'ProxyService.setProxyConfig',
        e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// 开始状态监控
  void _startStatusMonitoring() {
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        final status = await getProxyStatus();
        // 这里可以解析状态并更新UI
      } catch (e, stackTrace) {
        _errorHandler.handleError(
          'ProxyService._statusCheckTimer',
          e,
          stackTrace: stackTrace,
        );
      }
    });
  }

  /// 停止状态监控
  void _stopStatusMonitoring() {
    _statusCheckTimer?.cancel();
    _statusCheckTimer = null;
  }

  /// 处理生命周期事件
  void _handleLifecycleEvent(LifecycleEvent event) {
    switch (event.type) {
      case LifecycleType.appStart:
        _handleAppStart();
        break;
      case LifecycleType.appStop:
        _handleAppStop();
        break;
      case LifecycleType.appPause:
        _handleAppPause();
        break;
      case LifecycleType.appResume:
        _handleAppResume();
        break;
    }
  }

  /// 处理应用启动
  void _handleAppStart() {
    // 应用启动时的处理
  }

  /// 处理应用停止
  void _handleAppStop() {
    // 应用停止时的处理
    disconnect();
  }

  /// 处理应用暂停
  void _handleAppPause() {
    // 应用暂停时的处理
  }

  /// 处理应用恢复
  void _handleAppResume() {
    // 应用恢复时的处理
  }

  /// 更新服务状态
  void _updateState(ProxyServiceState newState) {
    if (_currentState != newState) {
      final oldState = _currentState;
      _currentState = newState;
      _stateController.add(newState);
      
      _emitEvent(ProxyServiceEvent(
        type: ProxyEventType.stateChanged,
        message: 'State changed from $oldState to $newState',
        data: {
          'oldState': oldState.toString(),
          'newState': newState.toString(),
        },
      ));
    }
  }

  /// 发送事件
  void _emitEvent(ProxyServiceEvent event) {
    _eventController.add(event);
  }

  /// 检查服务是否已连接
  bool get isConnected => _currentState == ProxyServiceState.connected;

  /// 检查服务是否正在连接
  bool get isConnecting => _currentState == ProxyServiceState.connecting;

  /// 检查服务是否可用
  bool get isAvailable => [;
    ProxyServiceState.initialized,
    ProxyServiceState.connected,
    ProxyServiceState.disconnected,
  ].contains(_currentState);

  /// 释放资源
  Future<void> dispose() async {
    try {
      // 断开连接
      if (isConnected) {
        await disconnect();
      }

      // 停止状态监控
      _stopStatusMonitoring();

      // 关闭流控制器
      await _eventController.close();
      await _stateController.close();

      // 释放依赖服务
      await _lifecycleManager.dispose();
      await _configManager.dispose();
      await _errorHandler.dispose();

      _updateState(ProxyServiceState.closed);
      
      _instance = null;
    } catch (e, stackTrace) {
      _errorHandler.handleError(
        'ProxyService.dispose',
        e,
        stackTrace: stackTrace,
      );
    }
  }
}

/// 代理异常类
class ProxyException implements Exception {
  final String message;
  final int? code;

  const ProxyException(this.message, [this.code]);

  @override
  String toString() => 'ProxyException{message: $message, code: $code}';
}

/// 代理服务管理器
class ProxyServiceManager {
  static ProxyServiceManager? _instance;
  static ProxyServiceManager get instance => _instance ??= ProxyServiceManager._();
  
  ProxyServiceManager._();

  final ProxyService _proxyService = ProxyService.instance;
  bool _isInitialized = false;

  /// 初始化管理器
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    final success = await _proxyService.initialize();
    if (success) {
      _isInitialized = true;
    }
    
    return success;
  }

  /// 启动代理服务
  Future<bool> startProxy({
    required String proxyType,
    required String serverHost,
    required int serverPort,
    String? username,
    String? password,
    Map<String, dynamic>? additionalConfig,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _proxyService.connect(
      proxyType: proxyType,
      serverHost: serverHost,
      serverPort: serverPort,
      username: username,
      password: password,
      additionalConfig: additionalConfig,
    );
  }

  /// 停止代理服务
  Future<bool> stopProxy() async {
    return await _proxyService.disconnect();
  }

  /// 测试代理连接
  Future<bool> testProxyConnection(String? testUrl) async {
    return await _proxyService.testConnection(testUrl);
  }

  /// 获取代理服务实例
  ProxyService get proxyService => _proxyService;

  /// 获取代理服务事件流
  Stream<ProxyServiceEvent> get proxyEvents => _proxyService.eventStream;

  /// 获取代理服务状态流
  Stream<ProxyServiceState> get proxyStates => _proxyService.stateStream;

  /// 获取当前代理状态
  ProxyServiceState get currentProxyState => _proxyService.currentState;

  /// 获取当前连接信息
  ProxyConnectionInfo? get currentConnection => _proxyService.currentConnection;

  /// 检查代理是否已连接
  bool get isProxyConnected => _proxyService.isConnected;

  /// 释放资源
  Future<void> dispose() async {
    await _proxyService.dispose();
    _isInitialized = false;
  }
}