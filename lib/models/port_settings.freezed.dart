// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'port_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PortConfiguration _$PortConfigurationFromJson(Map<String, dynamic> json) {
  return _PortConfiguration.fromJson(json);
}

/// @nodoc
mixin _$PortConfiguration {
  /// SOCKS代理端口
  ///
  /// 用于SOCKS协议代理服务的监听端口，默认为1080
  int get socksPort => throw _privateConstructorUsedError;

  /// HTTP代理端口
  ///
  /// 用于HTTP协议代理服务的监听端口，默认为8080
  int get httpPort => throw _privateConstructorUsedError;

  /// API服务端口
  ///
  /// 用于内部API服务的监听端口，默认为9090
  int get apiPort => throw _privateConstructorUsedError;

  /// 是否启用重定向
  ///
  /// 控制是否启用流量重定向功能，默认为false
  bool get enableRedirect => throw _privateConstructorUsedError;

  /// Serializes this PortConfiguration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PortConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PortConfigurationCopyWith<PortConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortConfigurationCopyWith<$Res> {
  factory $PortConfigurationCopyWith(
          PortConfiguration value, $Res Function(PortConfiguration) then) =
      _$PortConfigurationCopyWithImpl<$Res, PortConfiguration>;
  @useResult
  $Res call({int socksPort, int httpPort, int apiPort, bool enableRedirect});
}

/// @nodoc
class _$PortConfigurationCopyWithImpl<$Res, $Val extends PortConfiguration>
    implements $PortConfigurationCopyWith<$Res> {
  _$PortConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PortConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? socksPort = null,
    Object? httpPort = null,
    Object? apiPort = null,
    Object? enableRedirect = null,
  }) {
    return _then(_value.copyWith(
      socksPort: null == socksPort
          ? _value.socksPort
          : socksPort // ignore: cast_nullable_to_non_nullable
              as int,
      httpPort: null == httpPort
          ? _value.httpPort
          : httpPort // ignore: cast_nullable_to_non_nullable
              as int,
      apiPort: null == apiPort
          ? _value.apiPort
          : apiPort // ignore: cast_nullable_to_non_nullable
              as int,
      enableRedirect: null == enableRedirect
          ? _value.enableRedirect
          : enableRedirect // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PortConfigurationImplCopyWith<$Res>
    implements $PortConfigurationCopyWith<$Res> {
  factory _$$PortConfigurationImplCopyWith(_$PortConfigurationImpl value,
          $Res Function(_$PortConfigurationImpl) then) =
      __$$PortConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int socksPort, int httpPort, int apiPort, bool enableRedirect});
}

/// @nodoc
class __$$PortConfigurationImplCopyWithImpl<$Res>
    extends _$PortConfigurationCopyWithImpl<$Res, _$PortConfigurationImpl>
    implements _$$PortConfigurationImplCopyWith<$Res> {
  __$$PortConfigurationImplCopyWithImpl(_$PortConfigurationImpl _value,
      $Res Function(_$PortConfigurationImpl) _then)
      : super(_value, _then);

  /// Create a copy of PortConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? socksPort = null,
    Object? httpPort = null,
    Object? apiPort = null,
    Object? enableRedirect = null,
  }) {
    return _then(_$PortConfigurationImpl(
      socksPort: null == socksPort
          ? _value.socksPort
          : socksPort // ignore: cast_nullable_to_non_nullable
              as int,
      httpPort: null == httpPort
          ? _value.httpPort
          : httpPort // ignore: cast_nullable_to_non_nullable
              as int,
      apiPort: null == apiPort
          ? _value.apiPort
          : apiPort // ignore: cast_nullable_to_non_nullable
              as int,
      enableRedirect: null == enableRedirect
          ? _value.enableRedirect
          : enableRedirect // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PortConfigurationImpl implements _PortConfiguration {
  const _$PortConfigurationImpl(
      {this.socksPort = 1080,
      this.httpPort = 8080,
      this.apiPort = 9090,
      this.enableRedirect = false});

  factory _$PortConfigurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortConfigurationImplFromJson(json);

  /// SOCKS代理端口
  ///
  /// 用于SOCKS协议代理服务的监听端口，默认为1080
  @override
  @JsonKey()
  final int socksPort;

  /// HTTP代理端口
  ///
  /// 用于HTTP协议代理服务的监听端口，默认为8080
  @override
  @JsonKey()
  final int httpPort;

  /// API服务端口
  ///
  /// 用于内部API服务的监听端口，默认为9090
  @override
  @JsonKey()
  final int apiPort;

  /// 是否启用重定向
  ///
  /// 控制是否启用流量重定向功能，默认为false
  @override
  @JsonKey()
  final bool enableRedirect;

  @override
  String toString() {
    return 'PortConfiguration(socksPort: $socksPort, httpPort: $httpPort, apiPort: $apiPort, enableRedirect: $enableRedirect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortConfigurationImpl &&
            (identical(other.socksPort, socksPort) ||
                other.socksPort == socksPort) &&
            (identical(other.httpPort, httpPort) ||
                other.httpPort == httpPort) &&
            (identical(other.apiPort, apiPort) || other.apiPort == apiPort) &&
            (identical(other.enableRedirect, enableRedirect) ||
                other.enableRedirect == enableRedirect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, socksPort, httpPort, apiPort, enableRedirect);

  /// Create a copy of PortConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PortConfigurationImplCopyWith<_$PortConfigurationImpl> get copyWith =>
      __$$PortConfigurationImplCopyWithImpl<_$PortConfigurationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PortConfigurationImplToJson(
      this,
    );
  }
}

abstract class _PortConfiguration implements PortConfiguration {
  const factory _PortConfiguration(
      {final int socksPort,
      final int httpPort,
      final int apiPort,
      final bool enableRedirect}) = _$PortConfigurationImpl;

  factory _PortConfiguration.fromJson(Map<String, dynamic> json) =
      _$PortConfigurationImpl.fromJson;

  /// SOCKS代理端口
  ///
  /// 用于SOCKS协议代理服务的监听端口，默认为1080
  @override
  int get socksPort;

  /// HTTP代理端口
  ///
  /// 用于HTTP协议代理服务的监听端口，默认为8080
  @override
  int get httpPort;

  /// API服务端口
  ///
  /// 用于内部API服务的监听端口，默认为9090
  @override
  int get apiPort;

  /// 是否启用重定向
  ///
  /// 控制是否启用流量重定向功能，默认为false
  @override
  bool get enableRedirect;

  /// Create a copy of PortConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PortConfigurationImplCopyWith<_$PortConfigurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
