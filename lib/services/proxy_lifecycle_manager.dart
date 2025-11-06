import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'proxy_service.dart';

/// 生命周期事件类型
enum LifecycleType {
  /// 应用启动
  appStart,
  /// 应用停止
  appStop,
  /// 应用暂停
  appPause,
  /// 应用恢复
  appResume,
  /// 屏幕锁定
  screenLock,
  /// 屏幕解锁
  screenUnlock,
  /// 网络连接变化
  networkChanged,
  /// 代理启动
  proxyStart,
  /// 代理停止
  proxyStop,
  /// 配置更新
  configUpdate,
  /// 权限变化
  permissionChange,
}

/// 生命周期事件
class LifecycleEvent {
  final LifecycleType type;
  final String? message;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  const LifecycleEvent({
    required this.type,
    this.message,
    this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'LifecycleEvent{type: $type, message: $message, timestamp: $timestamp}';
  }
}

/// 应用状态
class AppState {
  final bool isActive;
  final bool isConnected;
  final bool isScreenLocked;
  final String? networkType;
  final DateTime lastActiveTime;
  final int sessionId;

  const AppState({
    required this.isActive,
    required this.isConnected,
    required this.isScreenLocked,
    this.networkType,
    required this.lastActiveTime,
    required this.sessionId,
  });

  Map<String, dynamic> toJson() => {
    'isActive': isActive,
    'isConnected': isConnected,
    'isScreenLocked': isScreenLocked,
    'networkType': networkType,
    'lastActiveTime': lastActiveTime.toIso8601String(),
    'sessionId': sessionId,
  };

  factory AppState.fromJson(Map<String, dynamic> json) => AppState(
    isActive: json['isActive'] as bool,
    isConnected: json['isConnected'] as bool,
    isScreenLocked: json['isScreenLocked'] as bool,
    networkType: json['networkType'] as String?,
    lastActiveTime: DateTime.parse(json['lastActiveTime'] as String),
    sessionId: json['sessionId'] as int,
  );
}

/// 生命周期状态
enum LifecycleState {
  /// 初始化
  initializing,
  /// 运行中
  running,
  /// 暂停
  paused,
  /// 后台运行
  background,
  /// 关闭
  closed,
}

/// 代理生命周期管理器
/// 
/// 负责管理代理服务的生命周期：
/// - 应用生命周期监听
/// - 代理连接状态管理
/// - 资源自动回收
/// - 性能监控
class ProxyLifecycleManager {
  static ProxyLifecycleManager? _instance;
  static ProxyLifecycleManager get instance => _instance ??= ProxyLifecycleManager._();
  
  ProxyLifecycleManager._();

  // 事件流控制器
  final StreamController<LifecycleEvent> _eventController = StreamController.broadcast();
  Stream<LifecycleEvent> get eventStream => _eventController.stream;

  // 状态流控制器
  final StreamController<LifecycleState> _stateController = StreamController.broadcast();
  Stream<LifecycleState> get stateStream => _stateController.stream;

  // 当前状态
  LifecycleState _currentState = LifecycleState.initializing;
  LifecycleState get currentState => _currentState;

  // 当前应用状态
  AppState _currentAppState = const AppState(
    isActive: true,
    isConnected: false,
    isScreenLocked: false,
    networkType: null,
    lastActiveTime: kDebugMode ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(0),
    sessionId: 0,
  );

  // 依赖服务
  ProxyService? _proxyService;
  
  // 定时器
  Timer? _heartbeatTimer;
  Timer? _idleTimer;
  Timer? _reconnectionTimer;

  // 会话管理
  int _sessionCounter = 0;
  int get currentSessionId => _sessionCounter;

  // 监控配置
  static const Duration _heartbeatInterval = Duration(seconds: 30);
  static const Duration _idleTimeout = Duration(minutes: 5);
  static const Duration _reconnectionDelay = Duration(seconds: 5);

  // 统计信息
  int _connectionCount = 0;
  int _disconnectionCount = 0;
  Duration _totalConnectionTime = Duration.zero;
  DateTime? _lastConnectionTime;

  /// 初始化生命周期管理器
  Future<bool> initialize() async {
    try {
      if (_currentState != LifecycleState.initializing) {
        return _currentState != LifecycleState.closed;
      }

      _proxyService = ProxyService.instance;
      
      // 开始会话
      _startNewSession();
      
      // 设置生命周期监听
      _setupLifecycleListeners();
      
      // 开始心跳监控
      _startHeartbeat();
      
      _updateState(LifecycleState.running);
      
      _emitEvent(LifecycleEvent(
        type: LifecycleType.appStart,
        message: 'Lifecycle manager initialized',
        data: {
          'sessionId': _sessionCounter,
          'platform': Platform.operatingSystem,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ));

      return true;
    } catch (e, stackTrace) {
      _updateState(LifecycleState.closed);
      debugPrint('Failed to initialize lifecycle manager: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// 开始新会话
  void _startNewSession() {
    _sessionCounter++;
    _currentAppState = AppState(
      isActive: true,
      isConnected: false,
      isScreenLocked: false,
      networkType: _currentAppState.networkType,
      lastActiveTime: DateTime.now(),
      sessionId: _sessionCounter,
    );
  }

  /// 设置生命周期监听器
  void _setupLifecycleListeners() {
    // 设置应用生命周期监听（通过Platform channels或其他方式）
    // 这里使用模拟实现，实际中需要集成AppLifecycle等监听器
    
    // 网络状态监听（实际中需要NetworkInfo等插件）
    
    // 屏幕锁定状态监听（实际中需要DeviceInfo等插件）
  }

  /// 开始心跳监控
  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) {
      _handleHeartbeat();
    });
  }

  /// 开始空闲监控
  void _startIdleMonitoring() {
    _idleTimer?.cancel();
    _idleTimer = Timer(_idleTimeout, () {
      _handleIdleTimeout();
    });
  }

  /// 停止空闲监控
  void _stopIdleMonitoring() {
    _idleTimer?.cancel();
    _idleTimer = null;
  }

  /// 处理心跳
  void _handleHeartbeat() {
    try {
      // 更新最后活跃时间
      _currentAppState = AppState(
        isActive: _currentAppState.isActive,
        isConnected: _currentAppState.isConnected,
        isScreenLocked: _currentAppState.isScreenLocked,
        networkType: _currentAppState.networkType,
        lastActiveTime: DateTime.now(),
        sessionId: _currentAppState.sessionId,
      );

      // 检查连接状态
      if (_proxyService?.isConnected == true) {
        // 连接正常，记录连接时间
        if (_lastConnectionTime == null) {
          _lastConnectionTime = DateTime.now();
        }
      } else {
        // 连接丢失，处理重连逻辑
        _handleConnectionLost();
      }
    } catch (e, stackTrace) {
      debugPrint('Heartbeat error: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// 处理空闲超时
  void _handleIdleTimeout() {
    if (_currentAppState.isScreenLocked) {
      // 屏幕锁定时暂停监控
      _updateState(LifecycleState.paused);
      
      _emitEvent(LifecycleEvent(
        type: LifecycleType.screenLock,
        message: 'App paused due to idle timeout',
        data: {
          'sessionId': _sessionCounter,
          'lastActiveTime': _currentAppState.lastActiveTime.toIso8601String(),
        },
      ));
    }
  }

  /// 处理连接丢失
  void _handleConnectionLost() {
    _disconnectionCount++;
    
    if (_lastConnectionTime != null) {
      final connectionTime = DateTime.now().difference(_lastConnectionTime!);
      _totalConnectionTime += connectionTime;
      _lastConnectionTime = null;
    }

    _emitEvent(LifecycleEvent(
      type: LifecycleType.proxyStop,
      message: 'Proxy connection lost, attempting reconnection',
      data: {
        'sessionId': _sessionCounter,
        'disconnectionCount': _disconnectionCount,
        'totalConnectionTime': _totalConnectionTime.inSeconds,
      },
    ));

    // 尝试自动重连
    _startReconnectionTimer();
  }

  /// 开始重连定时器
  void _startReconnectionTimer() {
    _reconnectionTimer?.cancel();
    _reconnectionTimer = Timer(_reconnectionDelay, () {
      _attemptReconnection();
    });
  }

  /// 尝试重连
  void _attemptReconnection() {
    // 这里需要根据保存的配置进行重连
    // 实际实现中需要从ConfigManager获取连接配置
    debugPrint('Attempting to reconnect proxy...');
  }

  /// 处理代理连接建立
  void onConnectionEstablished(ProxyConnectionInfo connection) {
    _connectionCount++;
    _lastConnectionTime = DateTime.now();
    
    _currentAppState = AppState(
      isActive: _currentAppState.isActive,
      isConnected: true,
      isScreenLocked: _currentAppState.isScreenLocked,
      networkType: _currentAppState.networkType,
      lastActiveTime: DateTime.now(),
      sessionId: _currentAppState.sessionId,
    );

    _emitEvent(LifecycleEvent(
      type: LifecycleType.proxyStart,
      message: 'Proxy connection established',
      data: {
        'sessionId': _sessionCounter,
        'connectionCount': _connectionCount,
        'server': '${connection.serverHost}:${connection.serverPort}',
        'type': connection.proxyType,
      },
    ));
  }

  /// 处理代理连接丢失
  void onConnectionLost() {
    if (_lastConnectionTime != null) {
      final connectionTime = DateTime.now().difference(_lastConnectionTime!);
      _totalConnectionTime += connectionTime;
      _lastConnectionTime = null;
    }

    _currentAppState = AppState(
      isActive: _currentAppState.isActive,
      isConnected: false,
      isScreenLocked: _currentAppState.isScreenLocked,
      networkType: _currentAppState.networkType,
      lastActiveTime: DateTime.now(),
      sessionId: _currentAppState.sessionId,
    );

    _emitEvent(LifecycleEvent(
      type: LifecycleType.proxyStop,
      message: 'Proxy connection lost',
      data: {
        'sessionId': _sessionCounter,
        'disconnectionCount': _disconnectionCount,
        'totalConnectionTime': _totalConnectionTime.inSeconds,
      },
    ));
  }

  /// 处理应用启动事件
  void onAppStart() {
    _startNewSession();
    _startHeartbeat();
    _updateState(LifecycleState.running);
    
    _emitEvent(LifecycleEvent(
      type: LifecycleType.appStart,
      message: 'Application started',
      data: {
        'sessionId': _sessionCounter,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ));
  }

  /// 处理应用停止事件
  void onAppStop() {
    _updateState(LifecycleState.closed);
    
    // 停止所有定时器
    _heartbeatTimer?.cancel();
    _idleTimer?.cancel();
    _reconnectionTimer?.cancel();
    
    // 记录会话结束
    final sessionDuration = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(_currentAppState.lastActiveTime.millisecondsSinceEpoch)
    );
    
    _emitEvent(LifecycleEvent(
      type: LifecycleType.appStop,
      message: 'Application stopped',
      data: {
        'sessionId': _sessionCounter,
        'sessionDuration': sessionDuration.inSeconds,
        'connectionCount': _connectionCount,
        'totalConnectionTime': _totalConnectionTime.inSeconds,
      },
    ));
  }

  /// 处理应用暂停事件
  void onAppPause() {
    _currentAppState = AppState(
      isActive: false,
      isConnected: _currentAppState.isConnected,
      isScreenLocked: _currentAppState.isScreenLocked,
      networkType: _currentAppState.networkType,
      lastActiveTime: DateTime.now(),
      sessionId: _currentAppState.sessionId,
    );
    
    _updateState(LifecycleState.paused);
    _startIdleMonitoring();
    
    _emitEvent(LifecycleEvent(
      type: LifecycleType.appPause,
      message: 'Application paused',
      data: {
        'sessionId': _sessionCounter,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ));
  }

  /// 处理应用恢复事件
  void onAppResume() {
    _stopIdleMonitoring();
    
    _currentAppState = AppState(
      isActive: true,
      isConnected: _currentAppState.isConnected,
      isScreenLocked: _currentAppState.isScreenLocked,
      networkType: _currentAppState.networkType,
      lastActiveTime: DateTime.now(),
      sessionId: _currentAppState.sessionId,
    );
    
    _updateState(LifecycleState.running);
    
    _emitEvent(LifecycleEvent(
      type: LifecycleType.appResume,
      message: 'Application resumed',
      data: {
        'sessionId': _sessionCounter,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ));
  }

  /// 处理网络状态变化
  void onNetworkChanged(String networkType) {
    _currentAppState = AppState(
      isActive: _currentAppState.isActive,
      isConnected: _currentAppState.isConnected,
      isScreenLocked: _currentAppState.isScreenLocked,
      networkType: networkType,
      lastActiveTime: DateTime.now(),
      sessionId: _currentAppState.sessionId,
    );

    _emitEvent(LifecycleEvent(
      type: LifecycleType.networkChanged,
      message: 'Network type changed to $networkType',
      data: {
        'sessionId': _sessionCounter,
        'networkType': networkType,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ));
  }

  /// 处理屏幕锁定状态变化
  void onScreenLockChanged(bool isLocked) {
    _currentAppState = AppState(
      isActive: _currentAppState.isActive,
      isConnected: _currentAppState.isConnected,
      isScreenLocked: isLocked,
      networkType: _currentAppState.networkType,
      lastActiveTime: DateTime.now(),
      sessionId: _currentAppState.sessionId,
    );

    final eventType = isLocked ? LifecycleType.screenLock : LifecycleType.screenUnlock;
    final message = isLocked ? 'Screen locked' : 'Screen unlocked';

    _emitEvent(LifecycleEvent(
      type: eventType,
      message: message,
      data: {
        'sessionId': _sessionCounter,
        'isLocked': isLocked,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ));
  }

  /// 处理配置更新事件
  void onConfigUpdate(Map<String, dynamic> config) {
    _emitEvent(LifecycleEvent(
      type: LifecycleType.configUpdate,
      message: 'Configuration updated',
      data: {
        'sessionId': _sessionCounter,
        'configKeys': config.keys.toList(),
        'timestamp': DateTime.now().toIso8601String(),
      },
    ));
  }

  /// 获取统计信息
  Map<String, dynamic> getStatistics() {
    final now = DateTime.now();
    final currentSessionTime = now.difference(
      DateTime.fromMillisecondsSinceEpoch(_currentAppState.lastActiveTime.millisecondsSinceEpoch)
    );

    return {
      'sessionId': _sessionCounter,
      'currentSessionTime': currentSessionTime.inSeconds,
      'connectionCount': _connectionCount,
      'disconnectionCount': _disconnectionCount,
      'totalConnectionTime': _totalConnectionTime.inSeconds,
      'currentAppState': _currentAppState.toJson(),
      'lifecycleState': _currentState.toString(),
      'isActive': _currentAppState.isActive,
      'isConnected': _currentAppState.isConnected,
      'isScreenLocked': _currentAppState.isScreenLocked,
      'networkType': _currentAppState.networkType,
      'lastHeartbeat': now.toIso8601String(),
    };
  }

  /// 更新管理器状态
  void _updateState(LifecycleState newState) {
    if (_currentState != newState) {
      final oldState = _currentState;
      _currentState = newState;
      _stateController.add(newState);
    }
  }

  /// 发送生命周期事件
  void _emitEvent(LifecycleEvent event) {
    _eventController.add(event);
  }

  /// 获取当前应用状态
  AppState get currentAppState => _currentAppState;

  /// 检查是否在活跃状态
  bool get isAppActive => _currentAppState.isActive;

  /// 检查代理是否已连接
  bool get isProxyConnected => _currentAppState.isConnected;

  /// 检查屏幕是否锁定
  bool get isScreenLocked => _currentAppState.isScreenLocked;

  /// 获取网络类型
  String? get networkType => _currentAppState.networkType;

  /// 释放资源
  Future<void> dispose() async {
    try {
      // 停止所有定时器
      _heartbeatTimer?.cancel();
      _idleTimer?.cancel();
      _reconnectionTimer?.cancel();

      // 关闭流控制器
      await _eventController.close();
      await _stateController.close();

      _updateState(LifecycleState.closed);
      
      _instance = null;
    } catch (e, stackTrace) {
      debugPrint('Error disposing lifecycle manager: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }
}