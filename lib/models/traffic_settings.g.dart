// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'traffic_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************/

TrafficSettings _$TrafficSettingsFromJson(Map<String, dynamic> json) =>
    TrafficSettings(
      enableMonitoring: json['enableMonitoring'] as bool? ?? true,
      historyLimit: json['historyLimit'] as int? ?? 1000,
      enableLogging: json['enableLogging'] as bool? ?? true,
      logLevel: json['logLevel'] as int? ?? 1,
    );

Map<String, dynamic> _$TrafficSettingsToJson(TrafficSettings instance) =>
    <String, dynamic>{
      'enableMonitoring': instance.enableMonitoring,
      'historyLimit': instance.historyLimit,
      'enableLogging': instance.enableLogging,
      'logLevel': instance.logLevel,
    };