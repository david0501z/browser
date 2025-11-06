import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

/// FFI桥接服务类
/// 
/// 负责与FlClash的Go核心进行通信：
/// - 启动/停止代理服务
/// - 代理配置管理
/// - 事件监听和状态同步
/// - 流量统计
class FlClashFFIService {
  static FlClashFFIService? _instance;
  static FlClashFFIService get instance => _instance ??= FlClashFFIService._();
  
  FlClashFFIService._();

  // FFI动态库加载器
  late DynamicLibrary _library;
  
  // FFI函数指针
  late Pointer<NativeFunction<Int32 Function(Pointer<Char>)>> _startFunction;
  late Pointer<NativeFunction<Int32 Function()>> _stopFunction;
  late Pointer<NativeFunction<Int32 Function(Pointer<Char>)>> _changeFunction;
  late Pointer<NativeFunction<Int32 Function(Pointer<Char>)>> _loadConfigFunction;
  late Pointer<NativeFunction<Int32 Function(Pointer<Char>)>> _queryStatusFunction;
  late Pointer<NativeFunction<Int32 Function(Pointer<Char>, Pointer<Char>)>> _subscribeFunction;
  late Pointer<NativeFunction<Int32 Function(Int32)>> _unsubscribeFunction;
  late Pointer<NativeFunction<Int32 Function(Pointer<Char>)>> _getTrafficFunction;

  // 事件流控制器
  final StreamController<BrowserEvent> _eventController = StreamController.broadcast();
  Stream<BrowserEvent> get eventStream => _eventController.stream;

  // 状态控制器
  final StreamController<BrowserState> _stateController = StreamController.broadcast();
  Stream<BrowserState> get stateStream => _stateController.stream;

  // 流量统计控制器
  final StreamController<TrafficStats> _trafficController = StreamController.broadcast();
  Stream<TrafficStats> get trafficStream => _trafficController.stream;

  // 订阅句柄
  int? _eventSubscriptionHandle;
  int? _trafficSubscriptionHandle;

  /// 初始化FFI服务
  Future<bool> initialize() async {
    try {
      // 根据平台加载对应的动态库
      if (Platform.isAndroid) {
        _library = DynamicLibrary.open('libclash.so');
      } else if (Platform.isWindows) {
        _library = DynamicLibrary.open('clash.dll');
      } else if (Platform.isLinux) {
        _library = DynamicLibrary.open('libclash.so');
      } else if (Platform.isMacOS) {
        _library = DynamicLibrary.open('libclash.dylib');
      } else {
        throw UnsupportedError('Unsupported platform');
      }

      // 初始化函数指针
      _initializeFunctionPointers();

      return true;
    } catch (e) {
      debugPrint('FFI服务初始化失败: $e');
      return false;
    }
  }

  /// 初始化函数指针
  void _initializeFunctionPointers() {
    _startFunction = _library.lookup<NativeFunction<Int32 Function(Pointer<Char>)>>('start');
    _stopFunction = _library.lookup<NativeFunction<Int32 Function()>>('stop');
    _changeFunction = _library.lookup<NativeFunction<Int32 Function(Pointer<Char>)>>('change');
    _loadConfigFunction = _library.lookup<NativeFunction<Int32 Function(Pointer<Char>)>>('loadConfig');
    _queryStatusFunction = _library.lookup<NativeFunction<Int32 Function(Pointer<Char>)>>('queryStatus');
    _subscribeFunction = _library.lookup<NativeFunction<Int32 Function(Pointer<Char>, Pointer<Char>)>>('subscribe');
    _unsubscribeFunction = _library.lookup<NativeFunction<Int32 Function(Int32)>>('unsubscribe');
    _getTrafficFunction = _library.lookup<NativeFunction<Int32 Function(Pointer<Char>)>>('getTraffic');
  }

  /// 启动代理服务
  Future<bool> start(String configJson) async {
    try {
      final configCString = configJson.toNativeUtf8();
      final result = _startFunction.asFunction<int Function(Pointer<Utf8>)>()(configCString);
      malloc.free(configCString);
      
      if (result == 0) {
        // 启动成功后订阅事件
        _subscribeToEvents();
        _subscribeToTraffic();
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('启动代理服务失败: $e');
      return false;
    }
  }

  /// 停止代理服务
  Future<bool> stop() async {
    try {
      // 先取消订阅
      _unsubscribeFromEvents();
      _unsubscribeFromTraffic();
      
      final result = _stopFunction.asFunction<int Function()>()();
      return result == 0;
    } catch (e) {
      debugPrint('停止代理服务失败: $e');
      return false;
    }
  }

  /// 切换代理配置
  Future<bool> change(String policyJson) async {
    try {
      final policyCString = policyJson.toNativeUtf8();
      final result = _changeFunction.asFunction<int Function(Pointer<Utf8>)>()(policyCString);
      malloc.free(policyCString);
      return result == 0;
    } catch (e) {
      debugPrint('切换代理配置失败: $e');
      return false;
    }
  }

  /// 加载配置文件
  Future<bool> loadConfig(String configJson) async {
    try {
      final configCString = configJson.toNativeUtf8();
      final result = _loadConfigFunction.asFunction<int Function(Pointer<Utf8>)>()(configCString);
      malloc.free(configCString);
      return result == 0;
    } catch (e) {
      debugPrint('加载配置文件失败: $e');
      return false;
    }
  }

  /// 查询运行状态
  Future<String> queryStatus() async {
    try {
      final statusCString = 'status'.toNativeUtf8();
      final result = _queryStatusFunction.asFunction<int Function(Pointer<Utf8>)>()(statusCString);
      malloc.free(statusCString);
      
      // 这里需要处理返回的JSON字符串
      // 实际实现中需要从C内存中读取返回的字符串
      return '{}';
    } catch (e) {
      debugPrint('查询运行状态失败: $e');
      return '{}';
    }
  }

  /// 订阅事件
  void _subscribeToEvents() {
    try {
      final eventTypeCString = 'event'.toNativeUtf8();
      final handleCString = 'event_handle'.toNativeUtf8();
      
      final result = _subscribeFunction.asFunction<int Function(Pointer<Utf8>, Pointer<Utf8>)>()(
        eventTypeCString,
        handleCString,
      );
      
      malloc.free(eventTypeCString);
      malloc.free(handleCString);
      
      if (result > 0) {
        _eventSubscriptionHandle = result;
        // 开始监听事件
        _startEventListening();
      }
    } catch (e) {
      debugPrint('订阅事件失败: $e');
    }
  }

  /// 订阅流量统计
  void _subscribeToTraffic() {
    try {
      final trafficTypeCString = 'traffic'.toNativeUtf8();
      final handleCString = 'traffic_handle'.toNativeUtf8();
      
      final result = _subscribeFunction.asFunction<int Function(Pointer<Utf8>, Pointer<Utf8>)>()(
        trafficTypeCString,
        handleCString,
      );
      
      malloc.free(trafficTypeCString);
      malloc.free(handleCString);
      
      if (result > 0) {
        _trafficSubscriptionHandle = result;
        // 开始监听流量统计
        _startTrafficListening();
      }
    } catch (e) {
      debugPrint('订阅流量统计失败: $e');
    }
  }

  /// 取消事件订阅
  void _unsubscribeFromEvents() {
    if (_eventSubscriptionHandle != null) {
      try {
        _unsubscribeFunction.asFunction<int Function(int)>()(_eventSubscriptionHandle!);
        _eventSubscriptionHandle = null;
      } catch (e) {
        debugPrint('取消事件订阅失败: $e');
      }
    }
  }

  /// 取消流量统计订阅
  void _unsubscribeFromTraffic() {
    if (_trafficSubscriptionHandle != null) {
      try {
        _unsubscribeFunction.asFunction<int Function(int)>()(_trafficSubscriptionHandle!);
        _trafficSubscriptionHandle = null;
      } catch (e) {
        debugPrint('取消流量统计订阅失败: $e');
      }
    }
  }

  /// 开始事件监听
  void _startEventListening() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      // 这里应该从FFI获取事件数据
      // 实际实现中需要调用FFI函数获取事件
      // 然后解析并发送到事件流
    });
  }

  /// 开始流量统计监听
  void _startTrafficListening() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      try {
        final trafficCString = 'traffic'.toNativeUtf8();
        final result = _getTrafficFunction.asFunction<int Function(Pointer<Utf8>)>()(trafficCString);
        malloc.free(trafficCString);
        
        // 解析流量统计数据并发送
        if (result == 0) {
          // 实际实现中需要解析返回的JSON数据
          final trafficStats = TrafficStats(
            uploadBytes: 0,
            downloadBytes: 0,
            uploadSpeed: 0,
            downloadSpeed: 0,
            timestamp: DateTime.now(),
          );
          _trafficController.add(trafficStats);
        }
      } catch (e) {
        debugPrint('获取流量统计失败: $e');
      }
    });
  }

  /// 解析事件数据
  BrowserEvent? _parseEventData(String eventJson) {
    try {
      final eventMap = jsonDecode(eventJson);
      final eventTypeString = eventMap['type'] as String?;
      
      if (eventTypeString == null) return null;
      
      BrowserEventType eventType;
      switch (eventTypeString) {
        case 'loadStart':
          eventType = BrowserEventType.loadStart;
          break;
        case 'loadStop':
          eventType = BrowserEventType.loadStop;
          break;
        case 'loadError':
          eventType = BrowserEventType.loadError;
          break;
        case 'titleChanged':
          eventType = BrowserEventType.titleChanged;
          break;
        case 'urlChanged':
          eventType = BrowserEventType.urlChanged;
          break;
        case 'progressChanged':
          eventType = BrowserEventType.progressChanged;
          break;
        case 'consoleMessage':
          eventType = BrowserEventType.consoleMessage;
          break;
        case 'createWindow':
          eventType = BrowserEventType.createWindow;
          break;
        default:
          eventType = BrowserEventType.loadStart;
      }
      
      return BrowserEvent(
        type: eventType,
        tabId: eventMap['tabId'] as String? ?? '',
        data: eventMap['data'] as Map<String, dynamic>?,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      debugPrint('解析事件数据失败: $e');
      return null;
    }
  }

  /// 释放资源
  void dispose() {
    _unsubscribeFromEvents();
    _unsubscribeFromTraffic();
    _eventController.close();
    _stateController.close();
    _trafficController.close();
  }
}

/// 流量统计数据模型
class TrafficStats {
  final int uploadBytes;
  final int downloadBytes;
  final int uploadSpeed;
  final int downloadSpeed;
  final DateTime timestamp;

  const TrafficStats({
    required this.uploadBytes,
    required this.downloadBytes,
    required this.uploadSpeed,
    required this.downloadSpeed,
    required this.timestamp,
  });

  /// 格式化流量大小
  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// 格式化速度
  String formatSpeed(int speed) {
    if (speed < 1024) return '$speed B/s';
    if (speed < 1024 * 1024) return '${(speed / 1024).toStringAsFixed(1)} KB/s';
    if (speed < 1024 * 1024 * 1024) return '${(speed / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    return '${(speed / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB/s';
  }

  @override
  String toString() {
    return 'TrafficStats(upload: ${formatBytes(uploadBytes)}, download: ${formatBytes(downloadBytes)}, uploadSpeed: ${formatSpeed(uploadSpeed)}, downloadSpeed: ${formatSpeed(downloadSpeed)})';
  }
}

/// 浏览器FFI服务管理器
class BrowserFFIManager {
  static BrowserFFIManager? _instance;
  static BrowserFFIManager get instance => _instance ??= BrowserFFIManager._();
  
  BrowserFFIManager._();

  final FlClashFFIService _ffiService = FlClashFFIService.instance;
  bool _isInitialized = false;

  /// 初始化服务
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    final success = await _ffiService.initialize();
    if (success) {
      _isInitialized = true;
      _setupEventListeners();
    }
    
    return success;
  }

  /// 设置事件监听器
  void _setupEventListeners() {
    // 监听浏览器事件
    _ffiService.eventStream.listen((event) {
      _handleBrowserEvent(event);
    });

    // 监听代理状态变化
    _ffiService.stateStream.listen((state) {
      _handleProxyStateChange(state);
    });

    // 监听流量统计
    _ffiService.trafficStream.listen((traffic) {
      _handleTrafficUpdate(traffic);
    });
  }

  /// 处理浏览器事件
  void _handleBrowserEvent(BrowserEvent event) {
    switch (event.type) {
      case BrowserEventType.loadStart:
        // 页面开始加载
        break;
      case BrowserEventType.loadStop:
        // 页面加载完成
        break;
      case BrowserEventType.loadError:
        // 页面加载错误
        break;
      case BrowserEventType.titleChanged:
        // 页面标题改变
        break;
      case BrowserEventType.urlChanged:
        // URL改变
        break;
      case BrowserEventType.progressChanged:
        // 加载进度改变
        break;
      case BrowserEventType.consoleMessage:
        // 控制台消息
        break;
      case BrowserEventType.createWindow:
        // 创建新窗口
        break;
    }
  }

  /// 处理代理状态变化
  void _handleProxyStateChange(BrowserState state) {
    // 更新浏览器状态
  }

  /// 处理流量更新
  void _handleTrafficUpdate(TrafficStats traffic) {
    // 更新流量统计显示
  }

  /// 启动浏览器代理
  Future<bool> startBrowserProxy(String configJson) async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _ffiService.start(configJson);
  }

  /// 停止浏览器代理
  Future<bool> stopBrowserProxy() async {
    return await _ffiService.stop();
  }

  /// 切换代理策略
  Future<bool> changeProxyPolicy(String policyJson) async {
    return await _ffiService.change(policyJson);
  }

  /// 获取当前代理状态
  Future<String> getProxyStatus() async {
    return await _ffiService.queryStatus();
  }

  /// 获取流量统计
  Stream<TrafficStats> getTrafficStats() {
    return _ffiService.trafficStream;
  }

  /// 获取浏览器事件流
  Stream<BrowserEvent> getBrowserEvents() {
    return _ffiService.eventStream;
  }

  /// 释放资源
  void dispose() {
    _ffiService.dispose();
    _isInitialized = false;
  }
}