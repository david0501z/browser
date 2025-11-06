// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DNSSettingsImpl _$$DNSSettingsImplFromJson(Map<String, dynamic> json) =>
    _$DNSSettingsImpl(
      enable: json['enable'] as bool? ?? false,
      servers: (json['servers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      fallback: (json['fallback'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      strategy: (json['strategy'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DNSSettingsImplToJson(_$DNSSettingsImpl instance) =>
    <String, dynamic>{
      'enable': instance.enable,
      'servers': instance.servers,
      'fallback': instance.fallback,
      'strategy': instance.strategy,
    };
