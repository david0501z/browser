// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dns_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DNSConfiguration _$DNSConfigurationFromJson(Map<String, dynamic> json) {
  return _DNSConfiguration.fromJson(json);
}

/// @nodoc
mixin _$DNSConfiguration {
  /// 是否启用DNS配置
  bool get enable => throw _privateConstructorUsedError;

  /// DNS服务器列表
  List<String> get servers => throw _privateConstructorUsedError;

  /// DNS备用服务器列表
  List<String> get fallback => throw _privateConstructorUsedError;

  /// DNS策略（整数参数）
  int get strategy => throw _privateConstructorUsedError;

  /// 自定义DNS端口
  int get port => throw _privateConstructorUsedError;

  /// 是否启用IPv6 DNS
  bool get enableIPv6 => throw _privateConstructorUsedError;

  /// 是否启用缓存
  bool get enableCache => throw _privateConstructorUsedError;

  /// DNS缓存过期时间(秒)
  int get cacheTimeout => throw _privateConstructorUsedError;

  /// Serializes this DNSConfiguration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DNSConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DNSConfigurationCopyWith<DNSConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DNSConfigurationCopyWith<$Res> {
  factory $DNSConfigurationCopyWith(
          DNSConfiguration value, $Res Function(DNSConfiguration) then) =
      _$DNSConfigurationCopyWithImpl<$Res, DNSConfiguration>;
  @useResult
  $Res call(
      {bool enable,
      List<String> servers,
      List<String> fallback,
      int strategy,
      int port,
      bool enableIPv6,
      bool enableCache,
      int cacheTimeout});
}

/// @nodoc
class _$DNSConfigurationCopyWithImpl<$Res, $Val extends DNSConfiguration>
    implements $DNSConfigurationCopyWith<$Res> {
  _$DNSConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DNSConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enable = null,
    Object? servers = null,
    Object? fallback = null,
    Object? strategy = null,
    Object? port = null,
    Object? enableIPv6 = null,
    Object? enableCache = null,
    Object? cacheTimeout = null,
  }) {
    return _then(_value.copyWith(
      enable: null == enable
          ? _value.enable
          : enable // ignore: cast_nullable_to_non_nullable
              as bool,
      servers: null == servers
          ? _value.servers
          : servers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fallback: null == fallback
          ? _value.fallback
          : fallback // ignore: cast_nullable_to_non_nullable
              as List<String>,
      strategy: null == strategy
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as int,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      enableIPv6: null == enableIPv6
          ? _value.enableIPv6
          : enableIPv6 // ignore: cast_nullable_to_non_nullable
              as bool,
      enableCache: null == enableCache
          ? _value.enableCache
          : enableCache // ignore: cast_nullable_to_non_nullable
              as bool,
      cacheTimeout: null == cacheTimeout
          ? _value.cacheTimeout
          : cacheTimeout // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DNSConfigurationImplCopyWith<$Res>
    implements $DNSConfigurationCopyWith<$Res> {
  factory _$$DNSConfigurationImplCopyWith(_$DNSConfigurationImpl value,
          $Res Function(_$DNSConfigurationImpl) then) =
      __$$DNSConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enable,
      List<String> servers,
      List<String> fallback,
      int strategy,
      int port,
      bool enableIPv6,
      bool enableCache,
      int cacheTimeout});
}

/// @nodoc
class __$$DNSConfigurationImplCopyWithImpl<$Res>
    extends _$DNSConfigurationCopyWithImpl<$Res, _$DNSConfigurationImpl>
    implements _$$DNSConfigurationImplCopyWith<$Res> {
  __$$DNSConfigurationImplCopyWithImpl(_$DNSConfigurationImpl _value,
      $Res Function(_$DNSConfigurationImpl) _then)
      : super(_value, _then);

  /// Create a copy of DNSConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enable = null,
    Object? servers = null,
    Object? fallback = null,
    Object? strategy = null,
    Object? port = null,
    Object? enableIPv6 = null,
    Object? enableCache = null,
    Object? cacheTimeout = null,
  }) {
    return _then(_$DNSConfigurationImpl(
      enable: null == enable
          ? _value.enable
          : enable // ignore: cast_nullable_to_non_nullable
              as bool,
      servers: null == servers
          ? _value._servers
          : servers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fallback: null == fallback
          ? _value._fallback
          : fallback // ignore: cast_nullable_to_non_nullable
              as List<String>,
      strategy: null == strategy
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as int,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      enableIPv6: null == enableIPv6
          ? _value.enableIPv6
          : enableIPv6 // ignore: cast_nullable_to_non_nullable
              as bool,
      enableCache: null == enableCache
          ? _value.enableCache
          : enableCache // ignore: cast_nullable_to_non_nullable
              as bool,
      cacheTimeout: null == cacheTimeout
          ? _value.cacheTimeout
          : cacheTimeout // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DNSConfigurationImpl implements _DNSConfiguration {
  const _$DNSConfigurationImpl(
      {this.enable = false,
      final List<String> servers = const [],
      final List<String> fallback = const [],
      this.strategy = 0,
      this.port = 53,
      this.enableIPv6 = false,
      this.enableCache = true,
      this.cacheTimeout = 300})
      : _servers = servers,
        _fallback = fallback;

  factory _$DNSConfigurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$DNSConfigurationImplFromJson(json);

  /// 是否启用DNS配置
  @override
  @JsonKey()
  final bool enable;

  /// DNS服务器列表
  final List<String> _servers;

  /// DNS服务器列表
  @override
  @JsonKey()
  List<String> get servers {
    if (_servers is EqualUnmodifiableListView) return _servers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_servers);
  }

  /// DNS备用服务器列表
  final List<String> _fallback;

  /// DNS备用服务器列表
  @override
  @JsonKey()
  List<String> get fallback {
    if (_fallback is EqualUnmodifiableListView) return _fallback;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fallback);
  }

  /// DNS策略（整数参数）
  @override
  @JsonKey()
  final int strategy;

  /// 自定义DNS端口
  @override
  @JsonKey()
  final int port;

  /// 是否启用IPv6 DNS
  @override
  @JsonKey()
  final bool enableIPv6;

  /// 是否启用缓存
  @override
  @JsonKey()
  final bool enableCache;

  /// DNS缓存过期时间(秒)
  @override
  @JsonKey()
  final int cacheTimeout;

  @override
  String toString() {
    return 'DNSConfiguration(enable: $enable, servers: $servers, fallback: $fallback, strategy: $strategy, port: $port, enableIPv6: $enableIPv6, enableCache: $enableCache, cacheTimeout: $cacheTimeout)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DNSConfigurationImpl &&
            (identical(other.enable, enable) || other.enable == enable) &&
            const DeepCollectionEquality().equals(other._servers, _servers) &&
            const DeepCollectionEquality().equals(other._fallback, _fallback) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.enableIPv6, enableIPv6) ||
                other.enableIPv6 == enableIPv6) &&
            (identical(other.enableCache, enableCache) ||
                other.enableCache == enableCache) &&
            (identical(other.cacheTimeout, cacheTimeout) ||
                other.cacheTimeout == cacheTimeout));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      enable,
      const DeepCollectionEquality().hash(_servers),
      const DeepCollectionEquality().hash(_fallback),
      strategy,
      port,
      enableIPv6,
      enableCache,
      cacheTimeout);

  /// Create a copy of DNSConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DNSConfigurationImplCopyWith<_$DNSConfigurationImpl> get copyWith =>
      __$$DNSConfigurationImplCopyWithImpl<_$DNSConfigurationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DNSConfigurationImplToJson(
      this,
    );
  }
}

abstract class _DNSConfiguration implements DNSConfiguration {
  const factory _DNSConfiguration(
      {final bool enable,
      final List<String> servers,
      final List<String> fallback,
      final int strategy,
      final int port,
      final bool enableIPv6,
      final bool enableCache,
      final int cacheTimeout}) = _$DNSConfigurationImpl;

  factory _DNSConfiguration.fromJson(Map<String, dynamic> json) =
      _$DNSConfigurationImpl.fromJson;

  /// 是否启用DNS配置
  @override
  bool get enable;

  /// DNS服务器列表
  @override
  List<String> get servers;

  /// DNS备用服务器列表
  @override
  List<String> get fallback;

  /// DNS策略（整数参数）
  @override
  int get strategy;

  /// 自定义DNS端口
  @override
  int get port;

  /// 是否启用IPv6 DNS
  @override
  bool get enableIPv6;

  /// 是否启用缓存
  @override
  bool get enableCache;

  /// DNS缓存过期时间(秒)
  @override
  int get cacheTimeout;

  /// Create a copy of DNSConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DNSConfigurationImplCopyWith<_$DNSConfigurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
