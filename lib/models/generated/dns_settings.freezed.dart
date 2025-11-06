// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:freezed_annotation/freezed_annotation.dart';
part of '../app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is an error, and will not work in Dart 2. '
    'Please use `MyClass()` constructor instead.');

/// @nodoc
mixin _$DNSSettings {
  bool get customDNS => throw _privateConstructorUsedError;
  List<String> get dnsServers => throw _privateConstructorUsedError;
  bool get dnsOverHttps => throw _privateConstructorUsedError;
  String? get dohServer => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DNSSettingsCopyWith<DNSSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DNSSettingsCopyWith<$Res> {
  factory $DNSSettingsCopyWith(
          DNSSettings value, $Res Function(DNSSettings) then) =
      _$DNSSettingsCopyWithImpl<$Res, DNSSettings>;
  @useResult
  $Res call(
      {bool customDNS,
      List<String> dnsServers,
      bool dnsOverHttps,
      String? dohServer});
}

/// @nodoc
class _$DNSSettingsCopyWithImpl<$Res, $Val extends DNSSettings>
    implements $DNSSettingsCopyWith<$Res> {
  _$DNSSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_element
  final $Val _value;
  // ignore: unused_element
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customDNS = null,
    Object? dnsServers = null,
    Object? dnsOverHttps = null,
    Object? dohServer = freezed,
  }) {
    return _then(_value.copyWith(
      customDNS: null == customDNS ? _value.customDNS : customDNS as bool,
      dnsServers: null == dnsServers
          ? _value.dnsServers
          : dnsServers as List<String>,
      dnsOverHttps: null == dnsOverHttps
          ? _value.dnsOverHttps
          : dnsOverHttps as bool,
      dohServer: freezed == dohServer ? _value.dohServer : dohServer as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DNSSettingsCopyWith<$Res>
    implements $DNSSettingsCopyWith<$Res> {
  factory _$$DNSSettingsCopyWith(
          _$DNSSettings value, $Res Function(_$DNSSettings) then) =
      __$$DNSSettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool customDNS,
      List<String> dnsServers,
      bool dnsOverHttps,
      String? dohServer});
}

/// @nodoc
class __$$DNSSettingsCopyWithImpl<$Res>
    extends _$DNSSettingsCopyWithImpl<$Res, _$DNSSettings>
    implements _$$DNSSettingsCopyWith<$Res> {
  __$$DNSSettingsCopyWithImpl(
      _$DNSSettings _value, $Res Function(_$DNSSettings) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customDNS = null,
    Object? dnsServers = null,
    Object? dnsOverHttps = null,
    Object? dohServer = freezed,
  }) {
    return _then(_$DNSSettings(
      customDNS: null == customDNS ? _value.customDNS : customDNS as bool,
      dnsServers: null == dnsServers
          ? _value.dnsServers
          : dnsServers as List<String>,
      dnsOverHttps: null == dnsOverHttps
          ? _value.dnsOverHttps
          : dnsOverHttps as bool,
      dohServer: freezed == dohServer ? _value.dohServer : dohServer as String?,
    ));
  }
}

/// @nodoc

class _$DNSSettings extends _DNSSettings {
  const _$DNSSettings(
      {this.customDNS = false,
      this.dnsServers = const [],
      this.dnsOverHttps = false,
      this.dohServer})
      : super._();

  @override
  final bool customDNS;
  @override
  final List<String> dnsServers;
  @override
  final bool dnsOverHttps;
  @override
  final String? dohServer;

  @override
  String toString() {
    return 'DNSSettings(customDNS: $customDNS, dnsServers: $dnsServers, dnsOverHttps: $dnsOverHttps, dohServer: $dohServer)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DNSSettings &&
            (identical(other.customDNS, customDNS) ||
                other.customDNS == customDNS) &&
            const DeepCollectionEquality()
                .equals(other.dnsServers, dnsServers) &&
            (identical(other.dnsOverHttps, dnsOverHttps) ||
                other.dnsOverHttps == dnsOverHttps) &&
            (identical(other.dohServer, dohServer) ||
                other.dohServer == dohServer));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      customDNS,
      const DeepCollectionEquality().hash(dnsServers),
      dnsOverHttps,
      dohServer);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DNSSettingsCopyWith<_$DNSSettings> get copyWith =>
      __$$DNSSettingsCopyWithImpl<_$DNSSettings>(this, _$identity);
}

abstract class _DNSSettings extends DNSSettings {
  const factory _DNSSettings(
      {final bool customDNS,
      final List<String> dnsServers,
      final bool dnsOverHttps,
      final String? dohServer}) = _$DNSSettings;
  const _DNSSettings._() : super._();

  @override
  bool get customDNS;
  @override
  List<String> get dnsServers;
  @override
  bool get dnsOverHttps;
  @override
  String? get dohServer;
  @override
  @JsonKey(ignore: true)
  _$$DNSSettingsCopyWith<_$DNSSettings> get copyWith;
}
