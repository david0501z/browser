// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'traffic_performance_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrafficPerformanceSettings _$TrafficPerformanceSettingsFromJson(
    Map<String, dynamic> json) {
  return _TrafficPerformanceSettings.fromJson(json);
}

/// @nodoc
mixin _$TrafficPerformanceSettings {
  @JsonKey(name: 'max_speed')
  int get maxSpeed => throw _privateConstructorUsedError;
  @JsonKey(name: 'bandwidth_limit')
  int get bandwidthLimit => throw _privateConstructorUsedError;
  @JsonKey(name: 'throttle')
  bool get throttle => throw _privateConstructorUsedError;
  @JsonKey(name: 'buffer_size')
  int get bufferSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'download_speed')
  int get downloadSpeed => throw _privateConstructorUsedError;
  @JsonKey(name: 'upload_speed')
  int get uploadSpeed => throw _privateConstructorUsedError;
  @JsonKey(name: 'connection_timeout')
  int get connectionTimeout => throw _privateConstructorUsedError;
  @JsonKey(name: 'keep_alive')
  bool get keepAlive => throw _privateConstructorUsedError;

  /// Serializes this TrafficPerformanceSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrafficPerformanceSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrafficPerformanceSettingsCopyWith<TrafficPerformanceSettings>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrafficPerformanceSettingsCopyWith<$Res> {
  factory $TrafficPerformanceSettingsCopyWith(TrafficPerformanceSettings value,
          $Res Function(TrafficPerformanceSettings) then) =
      _$TrafficPerformanceSettingsCopyWithImpl<$Res,
          TrafficPerformanceSettings>;
  @useResult
  $Res call(
      {@JsonKey(name: 'max_speed') int maxSpeed,
      @JsonKey(name: 'bandwidth_limit') int bandwidthLimit,
      @JsonKey(name: 'throttle') bool throttle,
      @JsonKey(name: 'buffer_size') int bufferSize,
      @JsonKey(name: 'download_speed') int downloadSpeed,
      @JsonKey(name: 'upload_speed') int uploadSpeed,
      @JsonKey(name: 'connection_timeout') int connectionTimeout,
      @JsonKey(name: 'keep_alive') bool keepAlive});
}

/// @nodoc
class _$TrafficPerformanceSettingsCopyWithImpl<$Res,
        $Val extends TrafficPerformanceSettings>
    implements $TrafficPerformanceSettingsCopyWith<$Res> {
  _$TrafficPerformanceSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrafficPerformanceSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxSpeed = null,
    Object? bandwidthLimit = null,
    Object? throttle = null,
    Object? bufferSize = null,
    Object? downloadSpeed = null,
    Object? uploadSpeed = null,
    Object? connectionTimeout = null,
    Object? keepAlive = null,
  }) {
    return _then(_value.copyWith(
      maxSpeed: null == maxSpeed
          ? _value.maxSpeed
          : maxSpeed // ignore: cast_nullable_to_non_nullable
              as int,
      bandwidthLimit: null == bandwidthLimit
          ? _value.bandwidthLimit
          : bandwidthLimit // ignore: cast_nullable_to_non_nullable
              as int,
      throttle: null == throttle
          ? _value.throttle
          : throttle // ignore: cast_nullable_to_non_nullable
              as bool,
      bufferSize: null == bufferSize
          ? _value.bufferSize
          : bufferSize // ignore: cast_nullable_to_non_nullable
              as int,
      downloadSpeed: null == downloadSpeed
          ? _value.downloadSpeed
          : downloadSpeed // ignore: cast_nullable_to_non_nullable
              as int,
      uploadSpeed: null == uploadSpeed
          ? _value.uploadSpeed
          : uploadSpeed // ignore: cast_nullable_to_non_nullable
              as int,
      connectionTimeout: null == connectionTimeout
          ? _value.connectionTimeout
          : connectionTimeout // ignore: cast_nullable_to_non_nullable
              as int,
      keepAlive: null == keepAlive
          ? _value.keepAlive
          : keepAlive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrafficPerformanceSettingsImplCopyWith<$Res>
    implements $TrafficPerformanceSettingsCopyWith<$Res> {
  factory _$$TrafficPerformanceSettingsImplCopyWith(
          _$TrafficPerformanceSettingsImpl value,
          $Res Function(_$TrafficPerformanceSettingsImpl) then) =
      __$$TrafficPerformanceSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'max_speed') int maxSpeed,
      @JsonKey(name: 'bandwidth_limit') int bandwidthLimit,
      @JsonKey(name: 'throttle') bool throttle,
      @JsonKey(name: 'buffer_size') int bufferSize,
      @JsonKey(name: 'download_speed') int downloadSpeed,
      @JsonKey(name: 'upload_speed') int uploadSpeed,
      @JsonKey(name: 'connection_timeout') int connectionTimeout,
      @JsonKey(name: 'keep_alive') bool keepAlive});
}

/// @nodoc
class __$$TrafficPerformanceSettingsImplCopyWithImpl<$Res>
    extends _$TrafficPerformanceSettingsCopyWithImpl<$Res,
        _$TrafficPerformanceSettingsImpl>
    implements _$$TrafficPerformanceSettingsImplCopyWith<$Res> {
  __$$TrafficPerformanceSettingsImplCopyWithImpl(
      _$TrafficPerformanceSettingsImpl _value,
      $Res Function(_$TrafficPerformanceSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrafficPerformanceSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxSpeed = null,
    Object? bandwidthLimit = null,
    Object? throttle = null,
    Object? bufferSize = null,
    Object? downloadSpeed = null,
    Object? uploadSpeed = null,
    Object? connectionTimeout = null,
    Object? keepAlive = null,
  }) {
    return _then(_$TrafficPerformanceSettingsImpl(
      maxSpeed: null == maxSpeed
          ? _value.maxSpeed
          : maxSpeed // ignore: cast_nullable_to_non_nullable
              as int,
      bandwidthLimit: null == bandwidthLimit
          ? _value.bandwidthLimit
          : bandwidthLimit // ignore: cast_nullable_to_non_nullable
              as int,
      throttle: null == throttle
          ? _value.throttle
          : throttle // ignore: cast_nullable_to_non_nullable
              as bool,
      bufferSize: null == bufferSize
          ? _value.bufferSize
          : bufferSize // ignore: cast_nullable_to_non_nullable
              as int,
      downloadSpeed: null == downloadSpeed
          ? _value.downloadSpeed
          : downloadSpeed // ignore: cast_nullable_to_non_nullable
              as int,
      uploadSpeed: null == uploadSpeed
          ? _value.uploadSpeed
          : uploadSpeed // ignore: cast_nullable_to_non_nullable
              as int,
      connectionTimeout: null == connectionTimeout
          ? _value.connectionTimeout
          : connectionTimeout // ignore: cast_nullable_to_non_nullable
              as int,
      keepAlive: null == keepAlive
          ? _value.keepAlive
          : keepAlive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrafficPerformanceSettingsImpl implements _TrafficPerformanceSettings {
  const _$TrafficPerformanceSettingsImpl(
      {@JsonKey(name: 'max_speed') this.maxSpeed = 0,
      @JsonKey(name: 'bandwidth_limit') this.bandwidthLimit = 0,
      @JsonKey(name: 'throttle') this.throttle = false,
      @JsonKey(name: 'buffer_size') this.bufferSize = 64,
      @JsonKey(name: 'download_speed') this.downloadSpeed = 0,
      @JsonKey(name: 'upload_speed') this.uploadSpeed = 0,
      @JsonKey(name: 'connection_timeout') this.connectionTimeout = 5000,
      @JsonKey(name: 'keep_alive') this.keepAlive = true});

  factory _$TrafficPerformanceSettingsImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$TrafficPerformanceSettingsImplFromJson(json);

  @override
  @JsonKey(name: 'max_speed')
  final int maxSpeed;
  @override
  @JsonKey(name: 'bandwidth_limit')
  final int bandwidthLimit;
  @override
  @JsonKey(name: 'throttle')
  final bool throttle;
  @override
  @JsonKey(name: 'buffer_size')
  final int bufferSize;
  @override
  @JsonKey(name: 'download_speed')
  final int downloadSpeed;
  @override
  @JsonKey(name: 'upload_speed')
  final int uploadSpeed;
  @override
  @JsonKey(name: 'connection_timeout')
  final int connectionTimeout;
  @override
  @JsonKey(name: 'keep_alive')
  final bool keepAlive;

  @override
  String toString() {
    return 'TrafficPerformanceSettings(maxSpeed: $maxSpeed, bandwidthLimit: $bandwidthLimit, throttle: $throttle, bufferSize: $bufferSize, downloadSpeed: $downloadSpeed, uploadSpeed: $uploadSpeed, connectionTimeout: $connectionTimeout, keepAlive: $keepAlive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrafficPerformanceSettingsImpl &&
            (identical(other.maxSpeed, maxSpeed) ||
                other.maxSpeed == maxSpeed) &&
            (identical(other.bandwidthLimit, bandwidthLimit) ||
                other.bandwidthLimit == bandwidthLimit) &&
            (identical(other.throttle, throttle) ||
                other.throttle == throttle) &&
            (identical(other.bufferSize, bufferSize) ||
                other.bufferSize == bufferSize) &&
            (identical(other.downloadSpeed, downloadSpeed) ||
                other.downloadSpeed == downloadSpeed) &&
            (identical(other.uploadSpeed, uploadSpeed) ||
                other.uploadSpeed == uploadSpeed) &&
            (identical(other.connectionTimeout, connectionTimeout) ||
                other.connectionTimeout == connectionTimeout) &&
            (identical(other.keepAlive, keepAlive) ||
                other.keepAlive == keepAlive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      maxSpeed,
      bandwidthLimit,
      throttle,
      bufferSize,
      downloadSpeed,
      uploadSpeed,
      connectionTimeout,
      keepAlive);

  /// Create a copy of TrafficPerformanceSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrafficPerformanceSettingsImplCopyWith<_$TrafficPerformanceSettingsImpl>
      get copyWith => __$$TrafficPerformanceSettingsImplCopyWithImpl<
          _$TrafficPerformanceSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrafficPerformanceSettingsImplToJson(
      this,
    );
  }
}

abstract class _TrafficPerformanceSettings
    implements TrafficPerformanceSettings {
  const factory _TrafficPerformanceSettings(
          {@JsonKey(name: 'max_speed') final int maxSpeed,
          @JsonKey(name: 'bandwidth_limit') final int bandwidthLimit,
          @JsonKey(name: 'throttle') final bool throttle,
          @JsonKey(name: 'buffer_size') final int bufferSize,
          @JsonKey(name: 'download_speed') final int downloadSpeed,
          @JsonKey(name: 'upload_speed') final int uploadSpeed,
          @JsonKey(name: 'connection_timeout') final int connectionTimeout,
          @JsonKey(name: 'keep_alive') final bool keepAlive}) =
      _$TrafficPerformanceSettingsImpl;

  factory _TrafficPerformanceSettings.fromJson(Map<String, dynamic> json) =
      _$TrafficPerformanceSettingsImpl.fromJson;

  @override
  @JsonKey(name: 'max_speed')
  int get maxSpeed;
  @override
  @JsonKey(name: 'bandwidth_limit')
  int get bandwidthLimit;
  @override
  @JsonKey(name: 'throttle')
  bool get throttle;
  @override
  @JsonKey(name: 'buffer_size')
  int get bufferSize;
  @override
  @JsonKey(name: 'download_speed')
  int get downloadSpeed;
  @override
  @JsonKey(name: 'upload_speed')
  int get uploadSpeed;
  @override
  @JsonKey(name: 'connection_timeout')
  int get connectionTimeout;
  @override
  @JsonKey(name: 'keep_alive')
  bool get keepAlive;

  /// Create a copy of TrafficPerformanceSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrafficPerformanceSettingsImplCopyWith<_$TrafficPerformanceSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
