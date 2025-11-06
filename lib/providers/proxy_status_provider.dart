import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/proxy_state.dart';
import '../providers/proxy_providers.dart';

// ===== 实时状态监控提供者 =====

/// 代理状态监控提供者
final proxyStatusMonitorProvider = StateProvider<bool>((ref) {
  return false;
});

/// 状态变更监听器接口
abstract class StatusChangeListener {
  void onStatusChanged(ProxyStatus previousStatus, ProxyStatus currentStatus);
  void onConnectionChanged(dynamic previousState, dynamic currentState);
  void onTrafficChanged(dynamic previousState, dynamic currentState);
}

/// 默认状态变更监听器实现
class DefaultStatusChangeListener implements StatusChangeListener {
  final void Function(ProxyStatus, ProxyStatus)? onStatusChanged;
  final void Function(dynamic, dynamic)? onConnectionChanged;
  final void Function(dynamic, dynamic)? onTrafficChanged;

  const DefaultStatusChangeListener({
    this.onStatusChanged,
    this.onConnectionChanged,
    this.onTrafficChanged,
  });

  @override
  void onConnectionChanged(dynamic previousState, dynamic currentState) {
    onConnectionChanged?.call(previousState, currentState);
  }

  @override
  void onStatusChanged(ProxyStatus previousStatus, ProxyStatus currentStatus) {
    onStatusChanged?.call(previousStatus, currentStatus);
  }

  @override
  void onTrafficChanged(dynamic previousState, dynamic currentState) {
    onTrafficChanged?.call(previousState, currentState);
  }
}