// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:freezed_annotation/freezed_annotation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

part of '../app_settings.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is an error, and will not work in Dart 2. '
    'Please use `MyClass()` constructor instead.');

/// @nodoc
mixin _$PortSettings {
  int get httpPort => throw _privateConstructorUsedError;
  int get socksPort => throw _privateConstructorUsedError;
  int get mixedPort => throw _privateConstructorUsedError;
  int get apiPort => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PortSettingsCopyWith<PortSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortSettingsCopyWith<$Res> {
  factory $PortSettingsCopyWith(
          PortSettings value, $Res Function(PortSettings) then) =
      _$PortSettingsCopyWithImpl<$Res, PortSettings>;
  @useResult
  $Res call({int httpPort, int socksPort, int mixedPort, int apiPort});
}

/// @nodoc
class _$PortSettingsCopyWithImpl<$Res, $Val extends PortSettings>
    implements $PortSettingsCopyWith<$Res> {
  _$PortSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_element
  final $Val _value;
  // ignore: unused_element
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? httpPort = null,
    Object? socksPort = null,
    Object? mixedPort = null,
    Object? apiPort = null,
  }) {
    return _then(_value.copyWith(
      httpPort: null == httpPort ? _value.httpPort : httpPort as int,
      socksPort: null == socksPort ? _value.socksPort : socksPort as int,
      mixedPort: null == mixedPort ? _value.mixedPort : mixedPort as int,
      apiPort: null == apiPort ? _value.apiPort : apiPort as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PortSettingsCopyWith<$Res>
    implements $PortSettingsCopyWith<$Res> {
  factory _$$PortSettingsCopyWith(
          _$PortSettings value, $Res Function(_$PortSettings) then) =
      __$$PortSettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int httpPort, int socksPort, int mixedPort, int apiPort});
}

/// @nodoc
class __$$PortSettingsCopyWithImpl<$Res>
    extends _$PortSettingsCopyWithImpl<$Res, _$PortSettings>
    implements _$$PortSettingsCopyWith<$Res> {
  __$$PortSettingsCopyWithImpl(
      _$PortSettings _value, $Res Function(_$PortSettings) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? httpPort = null,
    Object? socksPort = null,
    Object? mixedPort = null,
    Object? apiPort = null,
  }) {
    return _then(_$PortSettings(
      httpPort: null == httpPort ? _value.httpPort : httpPort as int,
      socksPort: null == socksPort ? _value.socksPort : socksPort as int,
      mixedPort: null == mixedPort ? _value.mixedPort : mixedPort as int,
      apiPort: null == apiPort ? _value.apiPort : apiPort as int,
    ));
  }
}

/// @nodoc

class _$PortSettings extends _PortSettings {
  const _$PortSettings(
      {this.httpPort = 7890,
      this.socksPort = 7891,
      this.mixedPort = 7892,
      this.apiPort = 9090})
      : super._();

  @override
  final int httpPort;
  @override
  final int socksPort;
  @override
  final int mixedPort;
  @override
  final int apiPort;

  @override
  String toString() {
    return 'PortSettings(httpPort: $httpPort, socksPort: $socksPort, mixedPort: $mixedPort, apiPort: $apiPort)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortSettings &&
            (identical(other.httpPort, httpPort) ||
                other.httpPort == httpPort) &&
            (identical(other.socksPort, socksPort) ||
                other.socksPort == socksPort) &&
            (identical(other.mixedPort, mixedPort) ||
                other.mixedPort == mixedPort) &&
            (identical(other.apiPort, apiPort) || other.apiPort == apiPort));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, httpPort, socksPort, mixedPort, apiPort);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PortSettingsCopyWith<_$PortSettings> get copyWith =>
      __$$PortSettingsCopyWithImpl<_$PortSettings>(this, _$identity);
}

abstract class _PortSettings extends PortSettings {
  const factory _PortSettings(
      {final int httpPort,
      final int socksPort,
      final int mixedPort,
      final int apiPort}) = _$PortSettings;
  const _PortSettings._() : super._();

  @override
  int get httpPort;
  @override
  int get socksPort;
  @override
  int get mixedPort;
  @override
  int get apiPort;
  @override
  @JsonKey(ignore: true)
  _$$PortSettingsCopyWith<_$PortSettings> get copyWith;
}
