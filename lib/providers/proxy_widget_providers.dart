import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/proxy_state.dart';
import '../core/proxy_types.dart';

/// 代理状态提供者
final proxyStatusProvider = StateProvider<ProxyStatus>((ref) {
  return ProxyStatus.disconnected;
});

/// 连接状态提供者
final isConnectedProvider = StateProvider<bool>((ref) {
  return false;
});

/// 连接中状态提供者
final isConnectingProvider = StateProvider<bool>((ref) {
  return false;
});

/// 格式化流量统计提供者
final formattedProxyTrafficProvider = StateProvider<FormattedTrafficStats>((ref) {
  return const FormattedTrafficStats(
    uploadBytesFormatted: '0 B',
    downloadBytesFormatted: '0 B',
    uploadSpeedFormatted: '0 B/s',
    downloadSpeedFormatted: '0 B/s',
    uploadBytes: 0,
    downloadBytes: 0,
    uploadSpeed: 0,
    downloadSpeed: 0,
  );
});

/// 当前代理服务器提供者
final currentProxyServerProvider = StateProvider<ProxyServer?>((ref) {
  return null;
});

/// 可用代理服务器提供者
final availableProxyServersProvider = StateProvider<List<ProxyServer>>((ref) {
  return [];
});

/// 代理操作提供者
final proxyOperationsProvider = StateProvider<ProxyOperations>((ref) {
  return ProxyOperations.empty();
});

/// 代理流量统计提供者
final proxyTrafficStatsProvider = StateProvider<ProxyTrafficStats>((ref) {
  return const ProxyTrafficStats.empty();
});

/// 全局代理状态提供者
final globalProxyStateProvider = StateProvider<GlobalProxyState>((ref) {
  return const GlobalProxyState(
    status: ProxyStatus.disconnected,
    servers: [],
    connectionState: ProxyConnectionState(
      isConnected: false,
      uploadBytes: 0,
      downloadBytes: 0,
      uploadSpeed: 0,
      downloadSpeed: 0,
    ),
    rules: [],
    isGlobalProxy: false,
    systemProxySettings: SystemProxySettings(
      enabled: false,
      bypassList: [],
    ),
    autoConnectSettings: AutoConnectSettings(
      enabled: false,
      autoConnectOnStartup: false,
      autoReconnect: false,
      reconnectInterval: 30,
      maxReconnectAttempts: 3,
    ),
    lastUpdated: null,
  );
});

/// 代理服务器统计提供者
final proxyServerStatsProvider = StateProvider<ProxyServerStats>((ref) {
  return ProxyServerStats.empty();
});

/// 代理配置提供者
final proxyConfigProvider = StateProvider<ProxyConfig>((ref) {
  return ProxyConfig.empty();
});

/// 代理模式提供者
final proxyModeProvider = StateProvider<ProxyMode>((ref) {
  return ProxyMode.rule;
});

/// 工具函数
String _formatBytes(int bytes) {
  if (bytes < 1024) return '${bytes}B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
}

String _formatSpeed(int bytesPerSecond) {
  if (bytesPerSecond < 1024) return '${bytesPerSecond}B/s';
  if (bytesPerSecond < 1024 * 1024) {
    return '${(bytesPerSecond / 1024).toStringAsFixed(1)}KB/s';
  }
  return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(1)}MB/s';
}

/// 格式化流量统计
class FormattedTrafficStats {
  final String uploadBytesFormatted;
  final String downloadBytesFormatted;
  final String uploadSpeedFormatted;
  final String downloadSpeedFormatted;
  final int uploadBytes;
  final int downloadBytes;
  final int uploadSpeed;
  final int downloadSpeed;

  const FormattedTrafficStats({
    required this.uploadBytesFormatted,
    required this.downloadBytesFormatted,
    required this.uploadSpeedFormatted,
    required this.downloadSpeedFormatted,
    required this.uploadBytes,
    required this.downloadBytes,
    required this.uploadSpeed,
    required this.downloadSpeed,
  });
}

/// 代理操作类
class ProxyOperations {
  final bool isStarting;
  final bool isStopping;
  final String? errorMessage;
  final DateTime? lastOperationTime;

  const ProxyOperations({
    this.isStarting = false,
    this.isStopping = false,
    this.errorMessage,
    this.lastOperationTime,
  });

  factory ProxyOperations.empty() {
    return const ProxyOperations();
  }

  /// 智能连接
  Future<void> smartConnect() async {
    // 模拟智能连接逻辑
    await Future.delayed(const Duration(seconds: 1));
    print('执行智能连接...');
  }

  /// 断开连接
  Future<void> disconnect() async {
    // 模拟断开连接逻辑
    await Future.delayed(const Duration(milliseconds: 500));
    print('断开代理连接...');
  }

  /// 测试服务器延迟
  Future<void> testServer(String serverId) async {
    // 模拟测试延迟逻辑
    await Future.delayed(const Duration(seconds: 2));
    print('测试服务器 $serverId 延迟...');
  }

  /// 连接服务器
  Future<void> connect() async {
    // 模拟连接逻辑
    await Future.delayed(const Duration(seconds: 2));
    print('连接代理服务器...');
  }

  /// 切换服务器
  Future<void> switchServer(String serverId) async {
    // 模拟切换服务器逻辑
    await Future.delayed(const Duration(seconds: 1));
    print('切换到服务器 $serverId...');
  }
}

/// 代理流量统计
class ProxyTrafficStats {
  final int totalUploadBytes;
  final int totalDownloadBytes;
  final int currentUploadSpeed;
  final int currentDownloadSpeed;
  final DateTime? lastUpdated;

  const ProxyTrafficStats.empty() : 
    this.totalUploadBytes = 0,
    this.totalDownloadBytes = 0,
    this.currentUploadSpeed = 0,
    this.currentDownloadSpeed = 0,
    this.lastUpdated = null;

  const ProxyTrafficStats({
    required this.totalUploadBytes,
    required this.totalDownloadBytes,
    required this.currentUploadSpeed,
    required this.currentDownloadSpeed,
    this.lastUpdated,
  });
}

/// 代理服务器统计
class ProxyServerStats {
  final int totalServers;
  final int enabledServers;
  final int connectedServers;
  final String? fastestServer;
  final String? mostUsedServer;

  const ProxyServerStats.empty() :
    this.totalServers = 0,
    this.enabledServers = 0,
    this.connectedServers = 0,
    this.fastestServer = null,
    this.mostUsedServer = null;

  const ProxyServerStats({
    required this.totalServers,
    required this.enabledServers,
    required this.connectedServers,
    this.fastestServer,
    this.mostUsedServer,
  });
}

/// 代理配置
class ProxyConfig {
  final ProxyMode mode;
  final ProxyServer? selectedServer;
  final bool systemProxy;
  final List<String> bypassList;

  const ProxyConfig.empty() :
    this.mode = ProxyMode.rule,
    this.selectedServer = null,
    this.systemProxy = false,
    this.bypassList = const [];

  const ProxyConfig({
    required this.mode,
    this.selectedServer,
    this.systemProxy = false,
    this.bypassList = const [],
  });
}