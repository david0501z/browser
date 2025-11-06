import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/proxy_state.dart';

// ===== 核心状态提供者 =====

/// 代理状态枚举
enum ProxyStatus {
  disconnected,
  connecting,
  connected,
  error,
}

/// 基础代理状态提供者
final globalProxyStateProvider = StateProvider<ProxyStatus>((ref) {
  return ProxyStatus.disconnected;
});

/// 代理连接状态提供者
final proxyConnectionStateProvider = StateProvider<bool>((ref) {
  return false;
});

/// 代理服务器列表提供者
final proxyServersProvider = StateProvider<List<dynamic>>((ref) {
  return [];
});

/// 代理规则列表提供者
final proxyRulesProvider = StateProvider<List<dynamic>>((ref) {
  return [];
});

/// 是否启用全局代理提供者
final isGlobalProxyProvider = StateProvider<bool>((ref) {
  return false;
});

// ===== 工具函数 =====

/// 格式化字节数
String _formatBytes(int bytes) {
  if (bytes < 1024) return '${bytes}B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
}

/// 格式化速度
String _formatSpeed(int bytesPerSecond) {
  if (bytesPerSecond < 1024) return '${bytesPerSecond}B/s';
  if (bytesPerSecond < 1024 * 1024) {
    return '${(bytesPerSecond / 1024).toStringAsFixed(1)}KB/s';
  }
  return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(1)}MB/s';
}