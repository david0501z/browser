// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************/

_$Notifications _$$NotificationsFromJson(Map<String, dynamic> json) =>
    _$Notifications(
      enabled: json['enabled'] as bool? ?? true,
      connectionStatus: json['connectionStatus'] as bool? ?? true,
      trafficAlert: json['trafficAlert'] as bool? ?? false,
      nodeSwitch: json['nodeSwitch'] as bool? ?? false,
      systemProxy: json['systemProxy'] as bool? ?? false,
      update: json['update'] as bool? ?? true,
      errors: json['errors'] as bool? ?? true,
    );

Map<String, dynamic> _$$NotificationsToJson(_$Notifications instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'connectionStatus': instance.connectionStatus,
      'trafficAlert': instance.trafficAlert,
      'nodeSwitch': instance.nodeSwitch,
      'systemProxy': instance.systemProxy,
      'update': instance.update,
      'errors': instance.errors,
    };
