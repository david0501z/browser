// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DNSConfigurationImpl _$$DNSConfigurationImplFromJson(
        Map<String, dynamic> json) =>
    _$DNSConfigurationImpl(
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
      port: (json['port'] as num?)?.toInt() ?? 53,
      enableIPv6: json['enableIPv6'] as bool? ?? false,
      enableCache: json['enableCache'] as bool? ?? true,
      cacheTimeout: (json['cacheTimeout'] as num?)?.toInt() ?? 300,
    );

Map<String, dynamic> _$$DNSConfigurationImplToJson(
        _$DNSConfigurationImpl instance) =>
    <String, dynamic>{
      'enable': instance.enable,
      'servers': instance.servers,
      'fallback': instance.fallback,
      'strategy': instance.strategy,
      'port': instance.port,
      'enableIPv6': instance.enableIPv6,
      'enableCache': instance.enableCache,
      'cacheTimeout': instance.cacheTimeout,
    };
