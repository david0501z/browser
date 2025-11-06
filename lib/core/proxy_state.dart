/// 状态管理模型
/// 定义代理服务的状态管理和状态变更

import 'package:freezed_annotation/freezed_annotation.dart';
import 'proxy_config.dart';

part 'proxy_state.freezed.dart';
part 'proxy_state.g.dart';

/// 代理状态管理器
@freezed
class ProxyState with _$ProxyState {
  const factory ProxyState({
    /// 连接状态
    @Default(ProxyConnectionState.disconnected) ProxyConnectionState connectionState,
    /// 当前节点信息
    ProxyNode? currentNode,
    /// 配置信息
    ProxyConfig? config,
    /// 流量统计
    @Default(TrafficStats.empty()) TrafficStats trafficStats,
    /// 错误信息
    @Default('') String errorMessage,
    /// 上次连接时间
    @DateTimeConverter() DateTime? lastConnectedTime,
    /// 连接次数
    @Default(0) int connectionCount,
    /// 状态更新时间
    @DateTimeConverter() @Default(DateTime.now()) DateTime stateUpdateTime,
    /// 状态历史
    @Default([]) List<StateHistory> stateHistory,
  }) = _ProxyState;
  
  factory ProxyState.fromJson(Map<String, dynamic> json) => _$ProxyStateFromJson(json);
}

/// 连接状态
enum ProxyConnectionState {
  /// 断开连接
  disconnected,
  /// 正在连接
  connecting,
  /// 已连接
  connected,
  /// 正在断开
  disconnecting,
  /// 连接错误
  error,
}

/// 状态变更历史
@freezed
class StateHistory with _$StateHistory {
  const factory StateHistory({
    /// 记录ID
    required String id,
    /// 状态
    required ProxyConnectionState state,
    /// 时间戳
    @DateTimeConverter() required DateTime timestamp,
    /// 状态描述
    required String description,
    /// 相关节点
    String? nodeId,
    /// 额外信息
    @Default({}) Map<String, dynamic> metadata,
  }) = _StateHistory;
  
  factory StateHistory.fromJson(Map<String, dynamic> json) => _$StateHistoryFromJson(json);
}

/// 状态变更事件
@freezed
class StateChangeEvent with _$StateChangeEvent {
  const factory StateChangeEvent({
    /// 事件类型
    required StateEventType eventType,
    /// 事件状态
    required ProxyConnectionState state,
    /// 时间戳
    @DateTimeConverter() required DateTime timestamp,
    /// 相关节点
    String? nodeId,
    /// 事件数据
    @Default({}) Map<String, dynamic> data,
  }) = _StateChangeEvent;
  
  factory StateChangeEvent.fromJson(Map<String, dynamic> json) => _$StateChangeEventFromJson(json);
}

/// 状态事件类型
enum StateEventType {
  /// 状态变更
  stateChanged,
  /// 配置更新
  configUpdated,
  /// 连接开始
  connectionStarted,
  /// 连接成功
  connectionEstablished,
  /// 连接失败
  connectionFailed,
  /// 连接断开
  connectionDisconnected,
  /// 节点切换
  nodeSwitched,
  /// 错误发生
  errorOccurred,
}

/// 状态管理器
class ProxyStateManager {
  static final ProxyStateManager _instance = ProxyStateManager._internal();
  factory ProxyStateManager() => _instance;
  ProxyStateManager._internal();
  
  ProxyState _currentState = ProxyState();
  final List<StateChangeEvent> _eventHistory = [];
  final List<VoidCallback> _listeners = [];
  
  /// 获取当前状态
  ProxyState get currentState => _currentState;
  
  /// 状态变更监听器
  Stream<StateChangeEvent> get stateChanges => _createStateChangeStream();
  
  StreamController<StateChangeEvent>? _stateController;
  
  Stream<StateChangeEvent> _createStateChangeStream() {
    _stateController ??= StreamController<StateChangeEvent>.broadcast();
    return _stateController!.stream;
  }
  
  /// 更新状态
  void updateState(ProxyState newState) {
    final oldState = _currentState;
    _currentState = newState;
    
    // 通知监听器
    _notifyListeners();
    
    // 记录状态变更
    _recordStateChange(oldState, newState);
  }
  
  /// 更新连接状态
  void updateConnectionState(ProxyConnectionState state, {String? nodeId, Map<String, dynamic>? metadata}) {
    final event = StateChangeEvent(
      eventType: StateEventType.stateChanged,
      state: state,
      timestamp: DateTime.now(),
      nodeId: nodeId,
      data: metadata ?? {},
    );
    
    _addStateEvent(event);
    updateState(_currentState.copyWith(
      connectionState: state,
      stateUpdateTime: DateTime.now(),
    ));
  }
  
  /// 更新当前节点
  void updateCurrentNode(ProxyNode? node) {
    final event = StateChangeEvent(
      eventType: StateEventType.nodeSwitched,
      state: _currentState.connectionState,
      timestamp: DateTime.now(),
      nodeId: node?.id,
      data: {'node': node?.toJson()},
    );
    
    _addStateEvent(event);
    updateState(_currentState.copyWith(
      currentNode: node,
      stateUpdateTime: DateTime.now(),
    ));
  }
  
  /// 更新配置
  void updateConfig(ProxyConfig config) {
    final event = StateChangeEvent(
      eventType: StateEventType.configUpdated,
      state: _currentState.connectionState,
      timestamp: DateTime.now(),
      data: {'config': config.toJson()},
    );
    
    _addStateEvent(event);
    updateState(_currentState.copyWith(
      config: config,
      stateUpdateTime: DateTime.now(),
    ));
  }
  
  /// 更新流量统计
  void updateTrafficStats(TrafficStats stats) {
    updateState(_currentState.copyWith(
      trafficStats: stats,
      stateUpdateTime: DateTime.now(),
    ));
  }
  
  /// 设置错误
  void setError(String errorMessage) {
    final event = StateChangeEvent(
      eventType: StateEventType.errorOccurred,
      state: ProxyConnectionState.error,
      timestamp: DateTime.now(),
      data: {'error': errorMessage},
    );
    
    _addStateEvent(event);
    updateState(_currentState.copyWith(
      connectionState: ProxyConnectionState.error,
      errorMessage: errorMessage,
      stateUpdateTime: DateTime.now(),
    ));
  }
  
  /// 清除错误
  void clearError() {
    updateState(_currentState.copyWith(
      errorMessage: '',
      stateUpdateTime: DateTime.now(),
    ));
  }
  
  /// 增加连接计数
  void incrementConnectionCount() {
    final count = _currentState.connectionCount + 1;
    updateState(_currentState.copyWith(
      connectionCount: count,
      stateUpdateTime: DateTime.now(),
    ));
  }
  
  /// 设置最后连接时间
  void setLastConnectedTime(DateTime time) {
    updateState(_currentState.copyWith(
      lastConnectedTime: time,
      stateUpdateTime: DateTime.now(),
    ));
  }
  
  /// 添加状态变更监听器
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }
  
  /// 移除状态变更监听器
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
  
  /// 获取状态历史
  List<StateChangeEvent> getStateHistory({int? limit}) {
    final events = List.from(_eventHistory);
    events.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    if (limit != null && events.length > limit) {
      return events.take(limit).toList();
    }
    
    return events;
  }
  
  /// 重置状态
  void reset() {
    _currentState = ProxyState();
    _eventHistory.clear();
    _notifyListeners();
  }
  
  void _addStateEvent(StateChangeEvent event) {
    _eventHistory.add(event);
    _stateController?.add(event);
    
    // 限制历史记录数量
    if (_eventHistory.length > 100) {
      _eventHistory.removeAt(0);
    }
  }
  
  void _notifyListeners() {
    for (final listener in _listeners) {
      try {
        listener();
      } catch (e) {
        // 忽略监听器错误
      }
    }
  }
  
  void _recordStateChange(ProxyState oldState, ProxyState newState) {
    if (oldState.connectionState != newState.connectionState) {
      _addStateEvent(StateChangeEvent(
        eventType: StateEventType.stateChanged,
        state: newState.connectionState,
        timestamp: DateTime.now(),
        data: {
          'oldState': oldState.connectionState.name,
          'newState': newState.connectionState.name,
        },
      ));
    }
  }
  
  void dispose() {
    _stateController?.close();
    _listeners.clear();
  }
}