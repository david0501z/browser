/// 代理状态管理器扩展
/// 提供更丰富的状态管理功能

import 'dart:async';
import 'proxy_state.dart';
import 'proxy_core_interface.dart';
import 'proxy_config.dart';
import 'traffic_stats.dart';

/// 代理服务管理器
class ProxyServiceManager {
  static final ProxyServiceManager _instance = ProxyServiceManager._internal();
  factory ProxyServiceManager() => _instance;
  ProxyServiceManager._internal();

  late ProxyCoreInterface _core;
  final ProxyStateManager _stateManager = ProxyStateManager();

  /// 初始化代理服务
  Future<bool> initialize() async {
    try {
      _core = ProxyCoreBridge.instance;
      await _core.initialize();
      
      // 监听状态变化
      _stateManager.addListener(_onStateChanged);
      
      return true;
    } catch (e) {
      _stateManager.setError('代理服务初始化失败: $e');
      return false;
    }
  }

  /// 启动代理
  Future<ProxyResult> start() async {
    try {
      _stateManager.updateConnectionState(ProxyConnectionState.connecting);
      final result = await _core.start();
      
      if (result.success) {
        _stateManager.updateConnectionState(ProxyConnectionState.connected);
        _stateManager.setLastConnectedTime(DateTime.now());
        _stateManager.incrementConnectionCount();
      } else {
        _stateManager.updateConnectionState(ProxyConnectionState.error);
        _stateManager.setError(result.message ?? '启动失败');
      }
      
      return result;
    } catch (e) {
      final error = ProxyResult.error('启动代理时发生异常: $e');
      _stateManager.setError(error.message!);
      return error;
    }
  }

  /// 停止代理
  Future<ProxyResult> stop() async {
    try {
      _stateManager.updateConnectionState(ProxyConnectionState.disconnecting);
      final result = await _core.stop();
      
      if (result.success) {
        _stateManager.updateConnectionState(ProxyConnectionState.disconnected);
      } else {
        _stateManager.updateConnectionState(ProxyConnectionState.error);
        _stateManager.setError(result.message ?? '停止失败');
      }
      
      return result;
    } catch (e) {
      final error = ProxyResult.error('停止代理时发生异常: $e');
      _stateManager.setError(error.message!);
      return error;
    }
  }

  /// 配置代理
  Future<ProxyResult> configure(ProxyConfig config) async {
    try {
      final configJson = _convertConfigToJson(config);
      final result = await _core.configure(configJson);
      
      if (result.success) {
        _stateManager.updateConfig(config);
      } else {
        _stateManager.setError(result.message ?? '配置失败');
      }
      
      return result;
    } catch (e) {
      final error = ProxyResult.error('配置代理时发生异常: $e');
      _stateManager.setError(error.message!);
      return error;
    }
  }

  /// 获取代理状态
  Future<ProxyStatus> getStatus() async {
    try {
      return await _core.getStatus().then((status) {
        final connectionState = _mapProxyStatusToConnectionState(status);
        _stateManager.updateConnectionState(connectionState);
        return status;
      });
    } catch (e) {
      _stateManager.setError('获取代理状态失败: $e');
      return ProxyStatus.error;
    }
  }

  /// 切换节点
  Future<ProxyResult> switchNode(String nodeId) async {
    try {
      final result = await _core.switchNode(nodeId);
      
      if (result.success) {
        // 查找节点信息
        final nodes = await _core.getNodes();
        final node = nodes.firstWhere(
          (n) => n.id == nodeId,
          orElse: () => throw Exception('节点不存在'),
        );
        _stateManager.updateCurrentNode(node);
      } else {
        _stateManager.setError(result.message ?? '切换节点失败');
      }
      
      return result;
    } catch (e) {
      final error = ProxyResult.error('切换节点时发生异常: $e');
      _stateManager.setError(error.message!);
      return error;
    }
  }

  /// 获取流量统计
  Future<TrafficStats> getTrafficStats() async {
    try {
      final stats = await _core.getTrafficStats();
      _stateManager.updateTrafficStats(stats);
      return stats;
    } catch (e) {
      _stateManager.setError('获取流量统计失败: $e');
      return TrafficStats.empty();
    }
  }

  /// 获取节点列表
  Future<List<ProxyNode>> getNodes() async {
    try {
      return await _core.getNodes();
    } catch (e) {
      _stateManager.setError('获取节点列表失败: $e');
      return [];
    }
  }

  /// 清理资源
  void dispose() {
    _stateManager.dispose();
  }

  /// 状态变更回调
  void _onStateChanged() {
    // 处理状态变更逻辑
    // 例如：更新UI、重启服务等
  }

  /// 将ProxyStatus映射为ProxyConnectionState
  ProxyConnectionState _mapProxyStatusToConnectionState(ProxyStatus status) {
    switch (status) {
      case ProxyStatus.disconnected:
        return ProxyConnectionState.disconnected;
      case ProxyStatus.connecting:
        return ProxyConnectionState.connecting;
      case ProxyStatus.connected:
        return ProxyConnectionState.connected;
      case ProxyStatus.disconnecting:
        return ProxyConnectionState.disconnecting;
      case ProxyStatus.error:
        return ProxyConnectionState.error;
    }
  }

  /// 转换配置为JSON字符串
  String _convertConfigToJson(ProxyConfig config) {
    // 这里应该实现配置对象的JSON序列化
    return '{"config": "json"}';
  }
}

/// 状态监听器
abstract class ProxyStateListener {
  void onConnectionStateChanged(ProxyConnectionState newState, ProxyConnectionState oldState);
  void onNodeChanged(ProxyNode? node);
  void onConfigUpdated(ProxyConfig config);
  void onErrorOccurred(String error);
  void onTrafficStatsUpdated(TrafficStats stats);
}