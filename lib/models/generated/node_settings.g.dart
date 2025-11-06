// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************/

_$NodeSettings _$$NodeSettingsFromJson(Map<String, dynamic> json) =>
    _$NodeSettings(
      autoSwitch: json['autoSwitch'] as bool? ?? false,
      switchInterval: json['switchInterval'] as int? ?? 30,
      loadBalance: json['loadBalance'] as bool? ?? false,
      healthCheck: json['healthCheck'] as bool? ?? true,
      healthCheckInterval: json['healthCheckInterval'] as int? ?? 5,
    );

Map<String, dynamic> _$$NodeSettingsToJson(_$NodeSettings instance) =>
    <String, dynamic>{
      'autoSwitch': instance.autoSwitch,
      'switchInterval': instance.switchInterval,
      'loadBalance': instance.loadBalance,
      'healthCheck': instance.healthCheck,
      'healthCheckInterval': instance.healthCheckInterval,
    };
