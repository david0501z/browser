/// 通知设置模型
library notifications;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications.freezed.dart';
part 'notifications.g.dart';

@freezed
class Notifications with _$Notifications {
  const factory Notifications({
    /// 是否启用通知
    @Default(true) bool enabled,
    
    /// 连接状态通知
    @Default(true) bool connectionStatus,
    
    /// 流量警告通知
    @Default(false) bool trafficAlert,
    
    /// 节点切换通知
    @Default(false) bool nodeSwitch,
    
    /// 系统代理通知
    @Default(false) bool systemProxy,
    
    /// 更新通知
    @Default(true) bool update,
    
    /// 错误通知
    @Default(true) bool errors,
  }) = _Notifications;
  
  const Notifications._();
  
  factory Notifications.fromJson(Map<String, Object?> json) => _$NotificationsFromJson(json);
}