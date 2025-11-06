import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 代理状态管理器
/// 提供状态管理的统一接口和高级功能
class ProxyStateManager {
  ProxyStateManager(this._ref);

  final Ref _ref;

  /// 获取通知器实例
  late final ProxyNotifier _notifier = _ref.read(proxyNotifierProvider.notifier);
  
  /// 获取状态监听器
  late final StateNotifierProvider<ProxyNotifier, GlobalProxyState> _proxyProvider = proxyNotifierProvider;

  /// 连接状态变化监听器列表
  final List<Function(ProxyStatus)> _statusListeners = [];
  
  /// 流量统计监听器列表
  final List<Function(int, int)> _trafficListeners = [];
  
  /// 错误监听器列表
  final List<Function(String)> _errorListeners = [];

  /// 定时器
  Timer? _statusCheckTimer;
  Timer? _trafficMonitorTimer;

  /// 初始化状态管理器
  Future<void> initialize() async {
    _startStatusMonitoring();
    _startTrafficMonitoring();
    
    // 应用启动时的自动连接逻辑
    _handleStartupAutoConnect();
  }

  /// 清理资源
  void dispose() {
    _statusCheckTimer?.cancel();
    _trafficMonitorTimer?.cancel();
    _statusListeners.clear();
    _trafficListeners.clear();
    _errorListeners.clear();
  }

  // ===== 状态监听器管理 =====

  /// 添加连接状态监听器
  void addStatusListener(Function(ProxyStatus) listener) {
    _statusListeners.add(listener);
  }

  /// 移除连接状态监听器
  void removeStatusListener(Function(ProxyStatus) listener) {
    _statusListeners.remove(listener);
  }

  /// 添加流量统计监听器
  void addTrafficListener(Function(int upload, int download) listener) {
    _trafficListeners.add(listener);
  }

  /// 移除流量统计监听器
  void removeTrafficListener(Function(int upload, int download) listener) {
    _trafficListeners.remove(listener);
  }

  /// 添加错误监听器
  void addErrorListener(Function(String error) listener) {
    _errorListeners.add(listener);
  }

  /// 移除错误监听器
  void removeErrorListener(Function(String error) listener) {
    _errorListeners.remove(listener);
  }

  // ===== 代理服务器管理 =====

  /// 添加代理服务器
  Future<bool> addProxyServer({
    required String name,
    required String server,
    required int port,
    required ProxyProtocol protocol,
    String? username,
    String? password,
  }) async {
    try {
      final server = ProxyServer(
        id: _generateId(),
        name: name,
        server: server,
        port: port,
        protocol: protocol,
        username: username,
        password: password,
        enabled: true,
        createdAt: DateTime.now(),
      );

      await _notifier.addServer(server);
      return true;
    } catch (e) {
      _notifyError('添加代理服务器失败: $e');
      return false;
    }
  }

  /// 更新代理服务器
  Future<bool> updateProxyServer({
    required String serverId,
    String? name,
    String? server,
    int? port,
    ProxyProtocol? protocol,
    String? username,
    String? password,
  }) async {
    try {
      final currentState = _ref.read(_proxyProvider);
      final currentServer = currentState.servers.firstWhere((s) => s.id == serverId);
      
      final updatedServer = currentServer.copyWith(
        name: name ?? currentServer.name,
        server: server ?? currentServer.server,
        port: port ?? currentServer.port,
        protocol: protocol ?? currentServer.protocol,
        username: username ?? currentServer.username,
        password: password ?? currentServer.password,
      );

      await _notifier.updateServer(serverId, updatedServer);
      return true;
    } catch (e) {
      _notifyError('更新代理服务器失败: $e');
      return false;
    }
  }

  /// 删除代理服务器
  Future<bool> removeProxyServer(String serverId) async {
    try {
      await _notifier.removeServer(serverId);
      return true;
    } catch (e) {
      _notifyError('删除代理服务器失败: $e');
      return false;
    }
  }

  /// 启用/禁用代理服务器
  Future<bool> toggleProxyServer(String serverId, bool enabled) async {
    try {
      await _notifier.toggleServer(serverId, enabled);
      return true;
    } catch (e) {
      _notifyError('切换代理服务器状态失败: $e');
      return false;
    }
  }

  /// 测试代理服务器连接
  Future<int?> testProxyServer(String serverId) async {
    try {
      return await _notifier.testServerConnection(serverId);
    } catch (e) {
      _notifyError('测试代理服务器连接失败: $e');
      return null;
    }
  }

  // ===== 连接管理 =====

  /// 连接到代理服务器
  Future<bool> connectToProxy({String? serverId}) async {
    try {
      final success = await _notifier.connect(serverId);
      if (!success) {
        _notifyError('连接代理服务器失败');
      }
      return success;
    } catch (e) {
      _notifyError('连接代理服务器异常: $e');
      return false;
    }
  }

  /// 断开连接
  Future<void> disconnectFromProxy() async {
    try {
      await _notifier.disconnect();
    } catch (e) {
      _notifyError('断开连接失败: $e');
    }
  }

  /// 智能连接 - 选择最佳服务器
  Future<bool> smartConnect() async {
    try {
      final state = _ref.read(_proxyProvider);
      final availableServers = state.servers.where((s) => s.enabled).toList();
      
      if (availableServers.isEmpty) {
        _notifyError('没有可用的代理服务器');
        return false;
      }

      // 按延迟排序
      availableServers.sort((a, b) {
        if (a.latency == null && b.latency == null) return 0;
        if (a.latency == null) return 1;
        if (b.latency == null) return -1;
        return a.latency!.compareTo(b.latency!);
      });

      // 尝试连接最快的服务器
      for (final server in availableServers) {
        final success = await _notifier.connect(server.id);
        if (success) {
          return true;
        }
      }

      _notifyError('所有代理服务器都无法连接');
      return false;
    } catch (e) {
      _notifyError('智能连接失败: $e');
      return false;
    }
  }

  // ===== 代理规则管理 =====

  /// 添加代理规则
  Future<bool> addProxyRule({
    required String name,
    required String pattern,
    required ProxyRuleType type,
    required String proxyServerId,
  }) async {
    try {
      final rule = ProxyRule(
        id: _generateId(),
        name: name,
        pattern: pattern,
        type: type,
        proxyServerId: proxyServerId,
        enabled: true,
        createdAt: DateTime.now(),
      );

      await _notifier.addRule(rule);
      return true;
    } catch (e) {
      _notifyError('添加代理规则失败: $e');
      return false;
    }
  }

  /// 删除代理规则
  Future<bool> removeProxyRule(String ruleId) async {
    try {
      await _notifier.removeRule(ruleId);
      return true;
    } catch (e) {
      _notifyError('删除代理规则失败: $e');
      return false;
    }
  }

  // ===== 设置管理 =====

  /// 设置全局代理
  Future<bool> setGlobalProxy(bool enabled) async {
    try {
      await _notifier.setGlobalProxy(enabled);
      return true;
    } catch (e) {
      _notifyError('设置全局代理失败: $e');
      return false;
    }
  }

  /// 更新系统代理设置
  Future<bool> updateSystemProxySettings({
    bool? enabled,
    String? httpProxy,
    String? httpsProxy,
    String? socksProxy,
    List<String>? bypassList,
  }) async {
    try {
      final currentState = _ref.read(_proxyProvider);
      final currentSettings = currentState.systemProxySettings;
      
      final updatedSettings = currentSettings.copyWith(
        enabled: enabled ?? currentSettings.enabled,
        httpProxy: httpProxy ?? currentSettings.httpProxy,
        httpsProxy: httpsProxy ?? currentSettings.httpsProxy,
        socksProxy: socksProxy ?? currentSettings.socksProxy,
        bypassList: bypassList ?? currentSettings.bypassList,
      );

      await _notifier.updateSystemProxySettings(updatedSettings);
      return true;
    } catch (e) {
      _notifyError('更新系统代理设置失败: $e');
      return false;
    }
  }

  /// 更新自动连接设置
  Future<bool> updateAutoConnectSettings({
    bool? enabled,
    bool? autoConnectOnStartup,
    bool? autoReconnect,
    int? reconnectInterval,
    int? maxReconnectAttempts,
  }) async {
    try {
      final currentState = _ref.read(_proxyProvider);
      final currentSettings = currentState.autoConnectSettings;
      
      final updatedSettings = currentSettings.copyWith(
        enabled: enabled ?? currentSettings.enabled,
        autoConnectOnStartup: autoConnectOnStartup ?? currentSettings.autoConnectOnStartup,
        autoReconnect: autoReconnect ?? currentSettings.autoReconnect,
        reconnectInterval: reconnectInterval ?? currentSettings.reconnectInterval,
        maxReconnectAttempts: maxReconnectAttempts ?? currentSettings.maxReconnectAttempts,
      );

      await _notifier.updateAutoConnectSettings(updatedSettings);
      return true;
    } catch (e) {
      _notifyError('更新自动连接设置失败: $e');
      return false;
    }
  }

  // ===== 查询方法 =====

  /// 获取当前状态
  GlobalProxyState get currentState => _ref.read(_proxyProvider);

  /// 是否已连接
  bool get isConnected => currentState.status == ProxyStatus.connected;

  /// 是否正在连接
  bool get isConnecting => currentState.status == ProxyStatus.connecting;

  /// 获取当前代理服务器
  ProxyServer? get currentServer {
    final serverId = currentState.connectionState.currentServerId;
    if (serverId == null) return null;
    
    try {
      return currentState.servers.firstWhere((s) => s.id == serverId);
    } catch (e) {
      return null;
    }
  }

  /// 获取启用的服务器列表
  List<ProxyServer> get enabledServers {
    return currentState.servers.where((s) => s.enabled).toList();
  }

  /// 获取可用的服务器列表（有延迟信息的）
  List<ProxyServer> get availableServers {
    return enabledServers.where((s) => s.latency != null).toList();
      ..sort((a, b) => a.latency!.compareTo(b.latency!));
  }

  /// 获取流量统计
  ({int uploadBytes, int downloadBytes, int uploadSpeed, int downloadSpeed}) get trafficStats {
    final connectionState = currentState.connectionState;
    return (
      uploadBytes: connectionState.uploadBytes,
      downloadBytes: connectionState.downloadBytes,
      uploadSpeed: connectionState.uploadSpeed,
      downloadSpeed: connectionState.downloadSpeed,
    );
  }

  /// 格式化流量显示
  String formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  /// 格式化速度显示
  String formatSpeed(int bytesPerSecond) {
    if (bytesPerSecond < 1024) return '${bytesPerSecond}B/s';
    if (bytesPerSecond < 1024 * 1024) return '${(bytesPerSecond / 1024).toStringAsFixed(1)}KB/s';
    return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(1)}MB/s';
  }

  // ===== 私有方法 =====

  /// 启动状态监控
  void _startStatusMonitoring() {
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final state = _ref.read(_proxyProvider);
      _notifyStatusChange(state.status);
      
      // 检查是否需要自动重连
      if (state.status == ProxyStatus.error) {
        _handleAutoReconnect();
      }
    });
  }

  /// 启动流量监控
  void _startTrafficMonitoring() {
    _trafficMonitorTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final state = _ref.read(_proxyProvider);
      final connectionState = state.connectionState;
      
      _notifyTrafficUpdate(
        connectionState.uploadSpeed,
        connectionState.downloadSpeed,
      );
    });
  }

  /// 处理启动时自动连接
  void _handleStartupAutoConnect() {
    final state = currentState;
    final settings = state.autoConnectSettings;
    
    if (settings.autoConnectOnStartup && settings.enabled) {
      // 延迟一秒执行，避免应用启动时的阻塞
      Future.delayed(const Duration(seconds: 1), () {
        smartConnect();
      });
    }
  }

  /// 处理自动重连
  void _handleAutoReconnect() {
    final state = currentState;
    final settings = state.autoConnectSettings;
    
    if (settings.autoReconnect && settings.enabled) {
      // 简单的重连逻辑，实际实现中可能需要更复杂的逻辑
      Future.delayed(Duration(seconds: settings.reconnectInterval), () {
        if (state.status == ProxyStatus.error) {
          smartConnect();
        }
      });
    }
  }

  /// 通知状态变化
  void _notifyStatusChange(ProxyStatus status) {
    for (final listener in _statusListeners) {
      try {
        listener(status);
      } catch (e) {
        // 忽略监听器错误
      }
    }
  }

  /// 通知流量更新
  void _notifyTrafficUpdate(int uploadSpeed, int downloadSpeed) {
    for (final listener in _trafficListeners) {
      try {
        listener(uploadSpeed, downloadSpeed);
      } catch (e) {
        // 忽略监听器错误
      }
    }
  }

  /// 通知错误
  void _notifyError(String error) {
    for (final listener in _errorListeners) {
      try {
        listener(error);
      } catch (e) {
        // 忽略监听器错误
      }
    }
  }

  /// 生成唯一ID
  String _generateId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}

/// 全局状态管理器实例
final proxyStateManagerProvider = Provider<ProxyStateManager>((ref) {
  return ProxyStateManager(ref);
});