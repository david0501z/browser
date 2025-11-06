// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************/

_$TrafficSettings _$$TrafficSettingsFromJson(Map<String, dynamic> json) =>
    _$TrafficSettings(
      enabled: json['enabled'] as bool? ?? true,
      realTime: json['realTime'] as bool? ?? true,
      period: StatisticPeriod.values.byName(json['period'] as String),
      trafficAlert: json['trafficAlert'] as bool? ?? false,
      alertThreshold: json['alertThreshold'] as int? ?? 10,
    );

Map<String, dynamic> _$$TrafficSettingsToJson(_$TrafficSettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'realTime': instance.realTime,
      'period': instance.period.name,
      'trafficAlert': instance.trafficAlert,
      'alertThreshold': instance.alertThreshold,
    };
