import 'package:freezed_annotation/freezed_annotation.dart';

part 'traffic_performance_settings.freezed.dart';
part 'traffic_performance_settings.g.dart';

@freezed
class TrafficPerformanceSettings with _$TrafficPerformanceSettings {
  const factory TrafficPerformanceSettings({
    @JsonKey(name: 'max_speed')
    @Default(0)
    int maxSpeed,
    
    @JsonKey(name: 'bandwidth_limit')
    @Default(0)
    int bandwidthLimit,
    
    @JsonKey(name: 'throttle')
    @Default(false)
    bool throttle,
    
    @JsonKey(name: 'buffer_size')
    @Default(64)
    int bufferSize,
    
    @JsonKey(name: 'download_speed')
    @Default(0)
    int downloadSpeed,
    
    @JsonKey(name: 'upload_speed')
    @Default(0)
    int uploadSpeed,
    
    @JsonKey(name: 'connection_timeout')
    @Default(5000)
    int connectionTimeout,
    
    @JsonKey(name: 'keep_alive')
    @Default(true)
    bool keepAlive,
  }) = _TrafficPerformanceSettings;

  factory TrafficPerformanceSettings.fromJson(Map<String, dynamic> json) =>
      _$TrafficPerformanceSettingsFromJson(json);
}