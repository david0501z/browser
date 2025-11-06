// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../port_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************/

_$PortSettings _$$PortSettingsFromJson(Map<String, dynamic> json) =>
    _$PortSettings(
      httpPort: json['httpPort'] as int? ?? 7890,
      socksPort: json['socksPort'] as int? ?? 7891,
      mixedPort: json['mixedPort'] as int? ?? 7892,
      apiPort: json['apiPort'] as int? ?? 9090,
    );

Map<String, dynamic> _$$PortSettingsToJson(_$PortSettings instance) =>
    <String, dynamic>{
      'httpPort': instance.httpPort,
      'socksPort': instance.socksPort,
      'mixedPort': instance.mixedPort,
      'apiPort': instance.apiPort,
    };
