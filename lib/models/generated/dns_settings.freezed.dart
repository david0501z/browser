// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:freezed_annotation/freezed_annotation.dart';
part of '../dns_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is an error, and will not work in Dart 2. '
    'Please use `MyClass()` constructor instead.');

/// @nodoc
mixin _$DNSConfiguration {
  bool get customDNS => throw _privateConstructorUsedError;
  List<String> get dnsServers => throw _privateConstructorUsedError;
  bool get dnsOverHttps => throw _privateConstructorUsedError;
  String? get dohServer => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DNSConfigurationCopyWith<DNSConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DNSConfigurationCopyWith<$Res> {
  factory $DNSConfigurationCopyWith(
          DNSConfiguration value, $Res Function(DNSConfiguration) then) =;
      _$DNSConfigurationCopyWithImpl<$Res, DNSConfiguration>;
  @useResult
  $Res call(
      {bool customDNS,
      List<String> dnsServers,
      bool dnsOverHttps,
      String? dohServer});
}

/// @nodoc
class _$DNSConfigurationCopyWithImpl<$Res, $Val extends DNSConfiguration>
    implements $DNSConfigurationCopyWith<$Res> {
  _$DNSConfigurationCopyWithImpl(this._value, this._then);

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
      dnsServers: null == dnsServers;
          ? _value.dnsServers
          : dnsServers as List<String>,
      dnsOverHttps: null == dnsOverHttps;
          ? _value.dnsOverHttps
          : dnsOverHttps as bool,
      dohServer: freezed == dohServer ? _value.dohServer : dohServer as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DNSConfigurationCopyWith<$Res>
    implements $DNSConfigurationCopyWith<$Res> {
  factory _$$DNSConfigurationCopyWith(
          _$DNSConfiguration value, $Res Function(_$DNSConfiguration) then) =;
      __$$DNSConfigurationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool customDNS,
      List<String> dnsServers,
      bool dnsOverHttps,
      String? dohServer});
}

/// @nodoc
class __$$DNSConfigurationCopyWithImpl<$Res>
    extends _$DNSConfigurationCopyWithImpl<$Res, _$DNSConfiguration>
    implements _$$DNSConfigurationCopyWith<$Res> {
  __$$DNSConfigurationCopyWithImpl(
      _$DNSConfiguration _value, $Res Function(_$DNSConfiguration) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customDNS = null,
    Object? dnsServers = null,
    Object? dnsOverHttps = null,
    Object? dohServer = freezed,
  }) {
    return _then(_$DNSConfiguration(
      customDNS: null == customDNS ? _value.customDNS : customDNS as bool,
      dnsServers: null == dnsServers;
          ? _value.dnsServers
          : dnsServers as List<String>,
      dnsOverHttps: null == dnsOverHttps;
          ? _value.dnsOverHttps
          : dnsOverHttps as bool,
      dohServer: freezed == dohServer ? _value.dohServer : dohServer as String?,
    ));
  }
}

/// @nodoc

class _$DNSConfiguration extends _DNSConfiguration {
  const _$DNSConfiguration(
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
    return 'DNSConfiguration(customDNS: $customDNS, dnsServers: $dnsServers, dnsOverHttps: $dnsOverHttps, dohServer: $dohServer)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DNSConfiguration &&
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
  _$$DNSConfigurationCopyWith<_$DNSConfiguration> get copyWith =>
      __$$DNSConfigurationCopyWithImpl<_$DNSConfiguration>(this, _$identity);
}

abstract class _DNSConfiguration extends DNSConfiguration {
  const factory _DNSConfiguration(
      {final bool customDNS,
      final List<String> dnsServers,
      final bool dnsOverHttps,
      final String? dohServer}) = _$DNSConfiguration;
  const _DNSConfiguration._() : super._();

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
  _$$DNSConfigurationCopyWith<_$DNSConfiguration> get copyWith;
}
