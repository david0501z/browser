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
mixin _$NodeSettings {
  bool get autoSwitch => throw _privateConstructorUsedError;
  int get switchInterval => throw _privateConstructorUsedError;
  bool get loadBalance => throw _privateConstructorUsedError;
  bool get healthCheck => throw _privateConstructorUsedError;
  int get healthCheckInterval => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NodeSettingsCopyWith<NodeSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeSettingsCopyWith<$Res> {
  factory $NodeSettingsCopyWith(
          NodeSettings value, $Res Function(NodeSettings) then) =
      _$NodeSettingsCopyWithImpl<$Res, NodeSettings>;
  @useResult
  $Res call(
      {bool autoSwitch,
      int switchInterval,
      bool loadBalance,
      bool healthCheck,
      int healthCheckInterval});
}

/// @nodoc
class _$NodeSettingsCopyWithImpl<$Res, $Val extends NodeSettings>
    implements $NodeSettingsCopyWith<$Res> {
  _$NodeSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_element
  final $Val _value;
  // ignore: unused_element
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoSwitch = null,
    Object? switchInterval = null,
    Object? loadBalance = null,
    Object? healthCheck = null,
    Object? healthCheckInterval = null,
  }) {
    return _then(_value.copyWith(
      autoSwitch: null == autoSwitch ? _value.autoSwitch : autoSwitch as bool,
      switchInterval: null == switchInterval
          ? _value.switchInterval
          : switchInterval as int,
      loadBalance: null == loadBalance ? _value.loadBalance : loadBalance as bool,
      healthCheck: null == healthCheck ? _value.healthCheck : healthCheck as bool,
      healthCheckInterval: null == healthCheckInterval
          ? _value.healthCheckInterval
          : healthCheckInterval as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NodeSettingsCopyWith<$Res>
    implements $NodeSettingsCopyWith<$Res> {
  factory _$$NodeSettingsCopyWith(
          _$NodeSettings value, $Res Function(_$NodeSettings) then) =
      __$$NodeSettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool autoSwitch,
      int switchInterval,
      bool loadBalance,
      bool healthCheck,
      int healthCheckInterval});
}

/// @nodoc
class __$$NodeSettingsCopyWithImpl<$Res>
    extends _$NodeSettingsCopyWithImpl<$Res, _$NodeSettings>
    implements _$$NodeSettingsCopyWith<$Res> {
  __$$NodeSettingsCopyWithImpl(
      _$NodeSettings _value, $Res Function(_$NodeSettings) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoSwitch = null,
    Object? switchInterval = null,
    Object? loadBalance = null,
    Object? healthCheck = null,
    Object? healthCheckInterval = null,
  }) {
    return _then(_$NodeSettings(
      autoSwitch: null == autoSwitch ? _value.autoSwitch : autoSwitch as bool,
      switchInterval: null == switchInterval
          ? _value.switchInterval
          : switchInterval as int,
      loadBalance: null == loadBalance ? _value.loadBalance : loadBalance as bool,
      healthCheck: null == healthCheck ? _value.healthCheck : healthCheck as bool,
      healthCheckInterval: null == healthCheckInterval
          ? _value.healthCheckInterval
          : healthCheckInterval as int,
    ));
  }
}

/// @nodoc

class _$NodeSettings extends _NodeSettings {
  const _$NodeSettings(
      {this.autoSwitch = false,
      this.switchInterval = 30,
      this.loadBalance = false,
      this.healthCheck = true,
      this.healthCheckInterval = 5})
      : super._();

  @override
  final bool autoSwitch;
  @override
  final int switchInterval;
  @override
  final bool loadBalance;
  @override
  final bool healthCheck;
  @override
  final int healthCheckInterval;

  @override
  String toString() {
    return 'NodeSettings(autoSwitch: $autoSwitch, switchInterval: $switchInterval, loadBalance: $loadBalance, healthCheck: $healthCheck, healthCheckInterval: $healthCheckInterval)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeSettings &&
            (identical(other.autoSwitch, autoSwitch) ||
                other.autoSwitch == autoSwitch) &&
            (identical(other.switchInterval, switchInterval) ||
                other.switchInterval == switchInterval) &&
            (identical(other.loadBalance, loadBalance) ||
                other.loadBalance == loadBalance) &&
            (identical(other.healthCheck, healthCheck) ||
                other.healthCheck == healthCheck) &&
            (identical(other.healthCheckInterval, healthCheckInterval) ||
                other.healthCheckInterval == healthCheckInterval));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      autoSwitch,
      switchInterval,
      loadBalance,
      healthCheck,
      healthCheckInterval);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeSettingsCopyWith<_$NodeSettings> get copyWith =>
      __$$NodeSettingsCopyWithImpl<_$NodeSettings>(this, _$identity);
}

abstract class _NodeSettings extends NodeSettings {
  const factory _NodeSettings(
      {final bool autoSwitch,
      final int switchInterval,
      final bool loadBalance,
      final bool healthCheck,
      final int healthCheckInterval}) = _$NodeSettings;
  const _NodeSettings._() : super._();

  @override
  bool get autoSwitch;
  @override
  int get switchInterval;
  @override
  bool get loadBalance;
  @override
  bool get healthCheck;
  @override
  int get healthCheckInterval;
  @override
  @JsonKey(ignore: true)
  _$$NodeSettingsCopyWith<_$NodeSettings> get copyWith;
}
