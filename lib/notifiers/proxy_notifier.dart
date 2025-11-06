import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/proxy_state.dart';
import '../services/proxy_service.dart';

/// 代理状态通知器
/// 负责管理代理状态的更新和通知
class ProxyNotifier extends StateNotifier<GlobalProxyState> {
  ProxyNotifier(this._proxyService) : super(_initialState()) {
    _initialize();
  }

  final ProxyService _proxyService;
  Timer? _reconnectTimer;
  StreamSubscription? _connectionSubscription;

  /// 初始化状态
  static GlobalProxyState _initialState() {
    return GlobalProxyState(
      status: ProxyStatus.disconnected,
      servers: [],
      connectionState: const ProxyConnectionState(
        isConnected: false,
        uploadBytes: 0,
        downloadBytes: 0,
        uploadSpeed: 0,
        downloadSpeed: 0,
      ),
      rules: [],
      isGlobalProxy: false,
      systemProxySettings: const SystemProxySettings(
        enabled: false,
        bypassList: [],
      ),
      autoConnectSettings: const AutoConnectSettings(
        enabled: false,
        autoConnectOnStartup: false,
        autoReconnect: false,
        reconnectInterval: 30,
        maxReconnectAttempts: 3,
      ),
      lastUpdated: DateTime.now(),
    );
  }

  /// 初始化通知器
  void _initialize() {
    // 监听服务连接状态变化
    _connectionSubscription = _proxyService.connectionStateStream.listen(
      (connectionState) {
        _updateConnectionState(connectionState);
      },
    );

    // 加载本地配置
    _loadLocalConfig();
  }

  /// 清理资源
  @override
  void dispose() {
    _connectionSubscription?.cancel();
    _reconnectTimer?.cancel();
    super.dispose();
  }

  /// 添加代理服务器
  Future<void> addServer(ProxyServer server) async {
    final updatedServers = [...state.servers, server];
    _updateState(
      state.copyWith(
        servers: updatedServers,
        lastUpdated: DateTime.now(),
      ),
    );
    
    // 保存到本地存储
    await _saveServersToStorage(updatedServers);
  }

  /// 更新代理服务器
  Future<void> updateServer(String serverId, ProxyServer updatedServer) async {
    final updatedServers = state.servers.map((server) {
      return server.id == serverId ? updatedServer : server;
    }).toList();
    
    _updateState(
      state.copyWith(
        servers: updatedServers,
        lastUpdated: DateTime.now(),
      ),
    );
    
    // 保存到本地存储
    await _saveServersToStorage(updatedServers);
  }

  /// 删除代理服务器
  Future<void> removeServer(String serverId) async {
    // 如果删除的是当前连接的服务器，先断连
    if (state.connectionState.currentServerId == serverId) {
      await disconnect();
    }
    
    final updatedServers = state.servers.where((server) => 
      server.id != serverId).toList();
    
    _updateState(
      state.copyWith(
        servers: updatedServers,
        lastUpdated: DateTime.now(),
      ),
    );
    
    // 保存到本地存储
    await _saveServersToStorage(updatedServers);
  }

  /// 启用/禁用服务器
  Future<void> toggleServer(String serverId, bool enabled) async {
    final updatedServers = state.servers.map((server) {
      if (server.id == serverId) {
        return server.copyWith(enabled: enabled);
      }
      return server;
    }).toList();
    
    _updateState(
      state.copyWith(
        servers: updatedServers,
        lastUpdated: DateTime.now(),
      ),
    );
    
    // 保存到本地存储
    await _saveServersToStorage(updatedServers);
  }

  /// 连接到代理服务器
  Future<bool> connect(String? serverId) async {
    if (state.status == ProxyStatus.connecting) {
      return false;
    }

    _updateStatus(ProxyStatus.connecting);

    try {
      final targetServerId = serverId ?? _getBestServerId();
      if (targetServerId == null) {
        throw Exception('没有可用的代理服务器');
      }

      final server = state.servers.firstWhere((s) => s.id == targetServerId);
      
      final success = await _proxyService.connect(server);
      
      if (success) {
        _updateConnectionState(
          state.connectionState.copyWith(
            isConnected: true,
            currentServerId: targetServerId,
            connectedAt: DateTime.now(),
            errorMessage: null,
          ),
        );
        _updateStatus(ProxyStatus.connected);
        
        // 更新服务器最后使用时间
        await _updateServerLastUsed(targetServerId);
      } else {
        throw Exception('连接失败');
      }
      
      return success;
    } catch (e) {
      _handleConnectionError(e.toString());
      return false;
    }
  }

  /// 断开连接
  Future<void> disconnect() async {
    if (state.status == ProxyStatus.disconnected) {
      return;
    }

    _updateStatus(ProxyStatus.disconnecting);

    try {
      await _proxyService.disconnect();
      
      _updateConnectionState(
        state.connectionState.copyWith(
          isConnected: false,
          currentServerId: null,
          disconnectedAt: DateTime.now(),
        ),
      );
      _updateStatus(ProxyStatus.disconnected);
    } catch (e) {
      // 即使出错也设置为断开状态
      _updateConnectionState(
        state.connectionState.copyWith(
          isConnected: false,
          currentServerId: null,
          disconnectedAt: DateTime.now(),
        ),
      );
      _updateStatus(ProxyStatus.disconnected);
    }
  }

  /// 测试代理服务器连接
  Future<int?> testServerConnection(String serverId) async {
    try {
      final server = state.servers.firstWhere((s) => s.id == serverId);
      final latency = await _proxyService.testConnection(server);
      
      // 更新服务器延迟
      await updateServer(
        serverId,
        server.copyWith(latency: latency),
      );
      
      return latency;
    } catch (e) {
      return null;
    }
  }

  /// 添加代理规则
  Future<void> addRule(ProxyRule rule) async {
    final updatedRules = [...state.rules, rule];
    _updateState(
      state.copyWith(
        rules: updatedRules,
        lastUpdated: DateTime.now(),
      ),
    );
    
    // 保存到本地存储
    await _saveRulesToStorage(updatedRules);
  }

  /// 删除代理规则
  Future<void> removeRule(String ruleId) async {
    final updatedRules = state.rules.where((rule) => 
      rule.id != ruleId).toList();
    
    _updateState(
      state.copyWith(
        rules: updatedRules,
        lastUpdated: DateTime.now(),
      ),
    );
    
    // 保存到本地存储
    await _saveRulesToStorage(updatedRules);
  }

  /// 启用/禁用全局代理
  Future<void> setGlobalProxy(bool enabled) async {
    _updateState(
      state.copyWith(
        isGlobalProxy: enabled,
        lastUpdated: DateTime.now(),
      ),
    );
    
    if (state.status == ProxyStatus.connected) {
      // 如果已连接，更新全局代理设置
      await _proxyService.setGlobalProxy(enabled);
    }
    
    // 保存到本地存储
    await _saveGlobalProxyToStorage(enabled);
  }

  /// 更新系统代理设置
  Future<void> updateSystemProxySettings(SystemProxySettings settings) async {
    _updateState(
      state.copyWith(
        systemProxySettings: settings,
        lastUpdated: DateTime.now(),
      ),
    );
    
    // 保存到本地存储
    await _saveSystemProxySettingsToStorage(settings);
  }

  /// 更新自动连接设置
  Future<void> updateAutoConnectSettings(AutoConnectSettings settings) async {
    _updateState(
      state.copyWith(
        autoConnectSettings: settings,
        lastUpdated: DateTime.now(),
      ),
    );
    
    // 保存到本地存储
    await _saveAutoConnectSettingsToStorage(settings);
  }

  /// 自动连接管理
  void _handleAutoConnect() {
    final settings = state.autoConnectSettings;
    
    if (settings.autoConnectOnStartup && 
        settings.enabled && 
        state.status == ProxyStatus.disconnected) {
      connect();
    }
  }

  /// 获取最佳服务器ID
  String? _getBestServerId() {
    final enabledServers = state.servers.where((s) => s.enabled).toList();
    
    if (enabledServers.isEmpty) {
      return null;
    }
    
    // 按延迟排序，返回最快的服务器
    enabledServers.sort((a, b) {
      if (a.latency == null && b.latency == null) return 0;
      if (a.latency == null) return 1;
      if (b.latency == null) return -1;
      return a.latency!.compareTo(b.latency!);
    });
    
    return enabledServers.first.id;
  }

  /// 处理连接状态更新
  void _updateConnectionState(ProxyConnectionState newState) {
    _updateState(
      state.copyWith(
        connectionState: newState,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  /// 处理状态更新
  void _updateState(GlobalProxyState newState) {
    state = newState;
  }

  /// 更新连接状态
  void _updateStatus(ProxyStatus status) {
    _updateState(
      state.copyWith(
        status: status,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  /// 处理连接错误
  void _handleConnectionError(String error) {
    _updateConnectionState(
      state.connectionState.copyWith(
        isConnected: false,
        errorMessage: error,
        disconnectedAt: DateTime.now(),
      ),
    );
    _updateStatus(ProxyStatus.error);
    
    // 自动重连逻辑
    _handleAutoReconnect();
  }

  /// 处理自动重连
  void _handleAutoReconnect() {
    final settings = state.autoConnectSettings;
    
    if (settings.autoReconnect && settings.enabled) {
      _startReconnectTimer();
    }
  }

  /// 启动重连计时器
  void _startReconnectTimer() {
    _reconnectTimer?.cancel();
    
    final settings = state.autoConnectSettings;
    _reconnectTimer = Timer(Duration(seconds: settings.reconnectInterval), () {
      if (state.status == ProxyStatus.error || 
          state.status == ProxyStatus.disconnected) {
        connect();
      }
    });
  }

  /// 更新服务器最后使用时间
  Future<void> _updateServerLastUsed(String serverId) async {
    try {
      final server = state.servers.firstWhere((s) => s.id == serverId);
      await updateServer(
        serverId,
        server.copyWith(lastUsedAt: DateTime.now()),
      );
    } catch (e) {
      // 忽略错误
    }
  }

  /// 本地存储相关方法
  Future<void> _loadLocalConfig() async {
    // TODO: 实现从本地存储加载配置
    // 这里可以实现 SharedPreferences 或本地数据库的加载逻辑
  }

  Future<void> _saveServersToStorage(List<ProxyServer> servers) async {
    // TODO: 实现保存到本地存储
  }

  Future<void> _saveRulesToStorage(List<ProxyRule> rules) async {
    // TODO: 实现保存到本地存储
  }

  Future<void> _saveGlobalProxyToStorage(bool enabled) async {
    // TODO: 实现保存到本地存储
  }

  Future<void> _saveSystemProxySettingsToStorage(SystemProxySettings settings) async {
    // TODO: 实现保存到本地存储
  }

  Future<void> _saveAutoConnectSettingsToStorage(AutoConnectSettings settings) async {
    // TODO: 实现保存到本地存储
  }
}

/// 代理服务抽象接口
abstract class ProxyService {
  /// 连接状态流
  Stream<ProxyConnectionState> get connectionStateStream;
  
  /// 连接到代理服务器
  Future<bool> connect(ProxyServer server);
  
  /// 断开连接
  Future<void> disconnect();
  
  /// 测试连接
  Future<int?> testConnection(ProxyServer server);
  
  /// 设置全局代理
  Future<void> setGlobalProxy(bool enabled);
}