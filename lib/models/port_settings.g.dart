// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'port_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PortConfigurationImpl _$$PortConfigurationImplFromJson(
        Map<String, dynamic> json) =>
    _$PortConfigurationImpl(
      socksPort: (json['socksPort'] as num?)?.toInt() ?? 1080,
      httpPort: (json['httpPort'] as num?)?.toInt() ?? 8080,
      apiPort: (json['apiPort'] as num?)?.toInt() ?? 9090,
      enableRedirect: json['enableRedirect'] as bool? ?? false,
    );

Map<String, dynamic> _$$PortConfigurationImplToJson(
        _$PortConfigurationImpl instance) =>
    <String, dynamic>{
      'socksPort': instance.socksPort,
      'httpPort': instance.httpPort,
      'apiPort': instance.apiPort,
      'enableRedirect': instance.enableRedirect,
    };
