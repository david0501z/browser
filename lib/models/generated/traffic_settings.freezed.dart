// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is an error, and will not work in Dart 2. '
    'Please use `MyClass()` constructor instead.');

/// @nodoc
mixin _$TrafficSettings {
  bool get enabled => throw _privateConstructorUsedError;
  bool get realTime => throw _privateConstructorUsedError;
  StatisticPeriod get period => throw _privateConstructorUsedError;
  bool get trafficAlert => throw _privateConstructorUsedError;
  int get alertThreshold => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TrafficSettingsCopyWith<TrafficSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrafficSettingsCopyWith<$Res> {
  factory $TrafficSettingsCopyWith(
          TrafficSettings value, $Res Function(TrafficSettings) then) =
      _$TrafficSettingsCopyWithImpl<$Res, TrafficSettings>;
  @useResult
  $Res call(
      {bool enabled,
      bool realTime,
      StatisticPeriod period,
      bool trafficAlert,
      int alertThreshold});
}

/// @nodoc
class _$TrafficSettingsCopyWithImpl<$Res, $Val extends TrafficSettings>
    implements $TrafficSettingsCopyWith<$Res> {
  _$TrafficSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_element
  final $Val _value;
  // ignore: unused_element
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? realTime = null,
    Object? period = null,
    Object? trafficAlert = null,
    Object? alertThreshold = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled ? _value.enabled : enabled as bool,
      realTime: null == realTime ? _value.realTime : realTime as bool,
      period: null == period ? _value.period : period as StatisticPeriod,
      trafficAlert: null == trafficAlert
          ? _value.trafficAlert
          : trafficAlert as bool,
      alertThreshold: null == alertThreshold
          ? _value.alertThreshold
          : alertThreshold as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrafficSettingsCopyWith<$Res>
    implements $TrafficSettingsCopyWith<$Res> {
  factory _$$TrafficSettingsCopyWith(
          _$TrafficSettings value, $Res Function(_$TrafficSettings) then) =
      __$$TrafficSettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      bool realTime,
      StatisticPeriod period,
      bool trafficAlert,
      int alertThreshold});
}

/// @nodoc
class __$$TrafficSettingsCopyWithImpl<$Res>
    extends _$TrafficSettingsCopyWithImpl<$Res, _$TrafficSettings>
    implements _$$TrafficSettingsCopyWith<$Res> {
  __$$TrafficSettingsCopyWithImpl(
      _$TrafficSettings _value, $Res Function(_$TrafficSettings) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? realTime = null,
    Object? period = null,
    Object? trafficAlert = null,
    Object? alertThreshold = null,
  }) {
    return _then(_$TrafficSettings(
      enabled: null == enabled ? _value.enabled : enabled as bool,
      realTime: null == realTime ? _value.realTime : realTime as bool,
      period: null == period ? _value.period : period as StatisticPeriod,
      trafficAlert: null == trafficAlert
          ? _value.trafficAlert
          : trafficAlert as bool,
      alertThreshold: null == alertThreshold
          ? _value.alertThreshold
          : alertThreshold as int,
    ));
  }
}

/// @nodoc

class _$TrafficSettings extends _TrafficSettings {
  const _$TrafficSettings(
      {this.enabled = true,
      this.realTime = true,
      this.period = StatisticPeriod.daily,
      this.trafficAlert = false,
      this.alertThreshold = 10})
      : super._();

  @override
  final bool enabled;
  @override
  final bool realTime;
  @override
  final StatisticPeriod period;
  @override
  final bool trafficAlert;
  @override
  final int alertThreshold;

  @override
  String toString() {
    return 'TrafficSettings(enabled: $enabled, realTime: $realTime, period: $period, trafficAlert: $trafficAlert, alertThreshold: $alertThreshold)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrafficSettings &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.realTime, realTime) || other.realTime == realTime) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.trafficAlert, trafficAlert) ||
                other.trafficAlert == trafficAlert) &&
            (identical(other.alertThreshold, alertThreshold) ||
                other.alertThreshold == alertThreshold));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, enabled, realTime, period, trafficAlert, alertThreshold);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TrafficSettingsCopyWith<_$TrafficSettings> get copyWith =>
      __$$TrafficSettingsCopyWithImpl<_$TrafficSettings>(this, _$identity);
}

abstract class _TrafficSettings extends TrafficSettings {
  const factory _TrafficSettings(
      {final bool enabled,
      final bool realTime,
      final StatisticPeriod period,
      final bool trafficAlert,
      final int alertThreshold}) = _$TrafficSettings;
  const _TrafficSettings._() : super._();

  @override
  bool get enabled;
  @override
  bool get realTime;
  @override
  StatisticPeriod get period;
  @override
  bool get trafficAlert;
  @override
  int get alertThreshold;
  @override
  @JsonKey(ignore: true)
  _$$TrafficSettingsCopyWith<_$TrafficSettings> get copyWith;
}
