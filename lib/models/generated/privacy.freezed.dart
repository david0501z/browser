// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:freezed_annotation/freezed_annotation.dart';
part of '../privacy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is an error, and will not work in Dart 2. '
    'Please use `MyClass()` constructor instead.');

/// @nodoc
mixin _$Privacy {
  bool get privacyMode => throw _privateConstructorUsedError;
  bool get anonymousMode => throw _privateConstructorUsedError;
  bool get dataEncryption => throw _privateConstructorUsedError;
  bool get localDataEncryption => throw _privateConstructorUsedError;
  bool get autoClean => throw _privateConstructorUsedError;
  int get cleanInterval => throw _privateConstructorUsedError;
  bool get telemetry => throw _privateConstructorUsedError;
  bool get crashReporting => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PrivacyCopyWith<Privacy> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacyCopyWith<$Res> {
  factory $PrivacyCopyWith(Privacy value, $Res Function(Privacy) then) =;
      _$PrivacyCopyWithImpl<$Res, Privacy>;
  @useResult
  $Res call(
      {bool privacyMode,
      bool anonymousMode,
      bool dataEncryption,
      bool localDataEncryption,
      bool autoClean,
      int cleanInterval,
      bool telemetry,
      bool crashReporting});
}

/// @nodoc
class _$PrivacyCopyWithImpl<$Res, $Val extends Privacy>
    implements $PrivacyCopyWith<$Res> {
  _$PrivacyCopyWithImpl(this._value, this._then);

  // ignore: unused_element
  final $Val _value;
  // ignore: unused_element
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? privacyMode = null,
    Object? anonymousMode = null,
    Object? dataEncryption = null,
    Object? localDataEncryption = null,
    Object? autoClean = null,
    Object? cleanInterval = null,
    Object? telemetry = null,
    Object? crashReporting = null,
  }) {
    return _then(_value.copyWith(
      privacyMode: null == privacyMode ? _value.privacyMode : privacyMode as bool,
      anonymousMode: null == anonymousMode;
          ? _value.anonymousMode
          : anonymousMode as bool,
      dataEncryption: null == dataEncryption;
          ? _value.dataEncryption
          : dataEncryption as bool,
      localDataEncryption: null == localDataEncryption;
          ? _value.localDataEncryption
          : localDataEncryption as bool,
      autoClean: null == autoClean ? _value.autoClean : autoClean as bool,
      cleanInterval: null == cleanInterval;
          ? _value.cleanInterval
          : cleanInterval as int,
      telemetry: null == telemetry ? _value.telemetry : telemetry as bool,
      crashReporting: null == crashReporting;
          ? _value.crashReporting
          : crashReporting as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivacyCopyWith<$Res> implements $PrivacyCopyWith<$Res> {
  factory _$$PrivacyCopyWith(
          _$Privacy value, $Res Function(_$Privacy) then) =;
      __$$PrivacyCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool privacyMode,
      bool anonymousMode,
      bool dataEncryption,
      bool localDataEncryption,
      bool autoClean,
      int cleanInterval,
      bool telemetry,
      bool crashReporting});
}

/// @nodoc
class __$$PrivacyCopyWithImpl<$Res>
    extends _$PrivacyCopyWithImpl<$Res, _$Privacy>
    implements _$$PrivacyCopyWith<$Res> {
  __$$PrivacyCopyWithImpl(_$Privacy _value, $Res Function(_$Privacy) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? privacyMode = null,
    Object? anonymousMode = null,
    Object? dataEncryption = null,
    Object? localDataEncryption = null,
    Object? autoClean = null,
    Object? cleanInterval = null,
    Object? telemetry = null,
    Object? crashReporting = null,
  }) {
    return _then(_$Privacy(
      privacyMode: null == privacyMode ? _value.privacyMode : privacyMode as bool,
      anonymousMode: null == anonymousMode;
          ? _value.anonymousMode
          : anonymousMode as bool,
      dataEncryption: null == dataEncryption;
          ? _value.dataEncryption
          : dataEncryption as bool,
      localDataEncryption: null == localDataEncryption;
          ? _value.localDataEncryption
          : localDataEncryption as bool,
      autoClean: null == autoClean ? _value.autoClean : autoClean as bool,
      cleanInterval: null == cleanInterval;
          ? _value.cleanInterval
          : cleanInterval as int,
      telemetry: null == telemetry ? _value.telemetry : telemetry as bool,
      crashReporting: null == crashReporting;
          ? _value.crashReporting
          : crashReporting as bool,
    ));
  }
}

/// @nodoc

class _$Privacy extends _Privacy {
  const _$Privacy(
      {this.privacyMode = false,
      this.anonymousMode = false,
      this.dataEncryption = true,
      this.localDataEncryption = false,
      this.autoClean = false,
      this.cleanInterval = 7,
      this.telemetry = false,
      this.crashReporting = false});
      : super._();

  @override
  final bool privacyMode;
  @override
  final bool anonymousMode;
  @override
  final bool dataEncryption;
  @override
  final bool localDataEncryption;
  @override
  final bool autoClean;
  @override
  final int cleanInterval;
  @override
  final bool telemetry;
  @override
  final bool crashReporting;

  @override
  String toString() {
    return 'Privacy(privacyMode: $privacyMode, anonymousMode: $anonymousMode, dataEncryption: $dataEncryption, localDataEncryption: $localDataEncryption, autoClean: $autoClean, cleanInterval: $cleanInterval, telemetry: $telemetry, crashReporting: $crashReporting)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Privacy &&
            (identical(other.privacyMode, privacyMode) ||
                other.privacyMode == privacyMode) &&
            (identical(other.anonymousMode, anonymousMode) ||
                other.anonymousMode == anonymousMode) &&
            (identical(other.dataEncryption, dataEncryption) ||
                other.dataEncryption == dataEncryption) &&
            (identical(other.localDataEncryption, localDataEncryption) ||
                other.localDataEncryption == localDataEncryption) &&
            (identical(other.autoClean, autoClean) ||
                other.autoClean == autoClean) &&
            (identical(other.cleanInterval, cleanInterval) ||
                other.cleanInterval == cleanInterval) &&
            (identical(other.telemetry, telemetry) ||
                other.telemetry == telemetry) &&
            (identical(other.crashReporting, crashReporting) ||
                other.crashReporting == crashReporting));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      privacyMode,
      anonymousMode,
      dataEncryption,
      localDataEncryption,
      autoClean,
      cleanInterval,
      telemetry,
      crashReporting);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacyCopyWith<_$Privacy> get copyWith =>
      __$$PrivacyCopyWithImpl<_$Privacy>(this, _$identity);
}

abstract class _Privacy extends Privacy {
  const factory _Privacy(
      {final bool privacyMode,
      final bool anonymousMode,
      final bool dataEncryption,
      final bool localDataEncryption,
      final bool autoClean,
      final int cleanInterval,
      final bool telemetry,
      final bool crashReporting}) = _$Privacy;
  const _Privacy._() : super._();

  @override
  bool get privacyMode;
  @override
  bool get anonymousMode;
  @override
  bool get dataEncryption;
  @override
  bool get localDataEncryption;
  @override
  bool get autoClean;
  @override
  int get cleanInterval;
  @override
  bool get telemetry;
  @override
  bool get crashReporting;
  @override
  @JsonKey(ignore: true)
  _$$PrivacyCopyWith<_$Privacy> get copyWith;
}
