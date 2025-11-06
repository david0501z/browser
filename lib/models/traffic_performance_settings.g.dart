// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'traffic_performance_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrafficPerformanceSettingsImpl _$$TrafficPerformanceSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$TrafficPerformanceSettingsImpl(
      maxSpeed: (json['max_speed'] as num?)?.toInt() ?? 0,
      bandwidthLimit: (json['bandwidth_limit'] as num?)?.toInt() ?? 0,
      throttle: json['throttle'] as bool? ?? false,
      bufferSize: (json['buffer_size'] as num?)?.toInt() ?? 64,
      downloadSpeed: (json['download_speed'] as num?)?.toInt() ?? 0,
      uploadSpeed: (json['upload_speed'] as num?)?.toInt() ?? 0,
      connectionTimeout: (json['connection_timeout'] as num?)?.toInt() ?? 5000,
      keepAlive: json['keep_alive'] as bool? ?? true,
    );

Map<String, dynamic> _$$TrafficPerformanceSettingsImplToJson(
        _$TrafficPerformanceSettingsImpl instance) =>
    <String, dynamic>{
      'max_speed': instance.maxSpeed,
      'bandwidth_limit': instance.bandwidthLimit,
      'throttle': instance.throttle,
      'buffer_size': instance.bufferSize,
      'download_speed': instance.downloadSpeed,
      'upload_speed': instance.uploadSpeed,
      'connection_timeout': instance.connectionTimeout,
      'keep_alive': instance.keepAlive,
    };
