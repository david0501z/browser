/// 代理核心FFI桥接实现
/// 负责与原生代理库的通信

import 'dart:ffi';
import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'proxy_core_interface.dart';

/// FFI库管理器
class ProxyCoreBridge implements ProxyCoreInterface {
  static ProxyCoreBridge? _instance;
  static ProxyCoreBridge get instance => _instance ??= ProxyCoreBridge._();
  
  ProxyCoreBridge._();
  
  late DynamicLibrary _library;
  late ProxyCoreNativeApi _nativeApi;
  bool _isInitialized = false;
  
  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // 根据平台加载相应的原生库
      if (Platform.isAndroid) {
        _library = DynamicLibrary.open('libproxycore.so');
      } else if (Platform.isIOS) {
        _library = DynamicLibrary.process();
      } else {
        // 其他平台的默认处理
        throw UnsupportedError('当前平台不支持原生桥接');
      }
      
      _nativeApi = ProxyCoreNativeApi(_library);
      _isInitialized = true;
    } catch (e) {
      throw Exception('代理核心初始化失败: $e');
    }
  }
  
  @override
  Future<ProxyResult> start() async {
    _checkInitialized();
    
    try {
      final result = _nativeApi.start();
      if (result == 0) {
        return ProxyResult.success('代理服务启动成功');
      } else {
        return ProxyResult.error('代理服务启动失败', result);
      }
    } catch (e) {
      return ProxyResult.error('启动代理服务时发生错误: $e');
    }
  }
  
  @override
  Future<ProxyResult> stop() async {
    _checkInitialized();
    
    try {
      final result = _nativeApi.stop();
      if (result == 0) {
        return ProxyResult.success('代理服务停止成功');
      } else {
        return ProxyResult.error('代理服务停止失败', result);
      }
    } catch (e) {
      return ProxyResult.error('停止代理服务时发生错误: $e');
    }
  }
  
  @override
  Future<ProxyStatus> getStatus() async {
    _checkInitialized();
    
    try {
      final statusCode = _nativeApi.getStatus();
      return ProxyStatus.values.firstWhere(
        (status) => status.name.toLowerCase() == _statusCodeToString(statusCode),
        orElse: () => ProxyStatus.disconnected,
      );
    } catch (e) {
      return ProxyStatus.error;
    }
  }
  
  @override
  Future<ProxyResult> configure(String configJson) async {
    _checkInitialized();
    
    try {
      final result = _nativeApi.configure(configJson.toNativeUtf8());
      if (result == 0) {
        return ProxyResult.success('代理配置成功');
      } else {
        return ProxyResult.error('代理配置失败', result);
      }
    } catch (e) {
      return ProxyResult.error('配置代理服务时发生错误: $e');
    }
  }
  
  @override
  Future<TrafficStats> getTrafficStats() async {
    _checkInitialized();
    
    try {
      final statsPtr = _nativeApi.getStats();
      // 这里应该从原生指针中解析统计数据
      // 目前返回模拟数据
      return TrafficStats.empty();
    } catch (e) {
      return TrafficStats.empty();
    }
  }
  
  @override
  Future<List<ProxyNode>> getNodes() async {
    _checkInitialized();
    
    try {
      // 这里应该从原生库获取节点列表
      // 目前返回空列表作为占位符
      return [];
    } catch (e) {
      return [];
    }
  }
  
  @override
  Future<ProxyResult> switchNode(String nodeId) async {
    _checkInitialized();
    
    try {
      final result = _nativeApi.configure(jsonEncode({'nodeId': nodeId}).toNativeUtf8());
      if (result == 0) {
        return ProxyResult.success('节点切换成功');
      } else {
        return ProxyResult.error('节点切换失败', result);
      }
    } catch (e) {
      return ProxyResult.error('切换节点时发生错误: $e');
    }
  }
  
  @override
  Stream<String> getConnectionLogs() async* {
    _checkInitialized();
    
    // 模拟日志流，实际应该从原生库获取
    yield '代理服务日志启动';
    yield '正在连接代理服务器...';
    yield '代理连接已建立';
  }
  
  @override
  void dispose() {
    if (_isInitialized) {
      _isInitialized = false;
      // 释放资源
    }
  }
  
  void _checkInitialized() {
    if (!_isInitialized) {
      throw Exception('代理核心未初始化，请先调用 initialize() 方法');
    }
  }
  
  String _statusCodeToString(int code) {
    switch (code) {
      case 0: return 'disconnected';
      case 1: return 'connecting';
      case 2: return 'connected';
      case 3: return 'disconnecting';
      default: return 'error';
    }
  }
}

/// 原生API接口封装
class ProxyCoreNativeApi {
  final DynamicLibrary _library;
  
  late final ProxyInitFunc _init;
  late final ProxyStartFunc _start;
  late final ProxyStopFunc _stop;
  late final ProxyStatusFunc _status;
  late final ProxyConfigFunc _config;
  late final ProxyStatsFunc _stats;
  
  ProxyCoreNativeApi(this._library) {
    _init = _library.lookup<NativeFunction<ProxyInitFunc>>('proxy_init');
    _start = _library.lookup<NativeFunction<ProxyStartFunc>>('proxy_start');
    _stop = _library.lookup<NativeFunction<ProxyStopFunc>>('proxy_stop');
    _status = _library.lookup<NativeFunction<ProxyStatusFunc>>('proxy_status');
    _config = _library.lookup<NativeFunction<ProxyConfigFunc>>('proxy_config');
    _stats = _library.lookup<NativeFunction<ProxyStatsFunc>>('proxy_stats');
  }
  
  void init() => _init();
  
  int start() => _start();
  
  int stop() => _stop();
  
  int getStatus() => _status();
  
  int configure(Pointer<Utf8> configJson) => _config(configJson);
  
  Pointer<Void> getStats() => _stats();
}