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

DNSSettings _$DNSSettingsFromJson(Map<String, dynamic> json) {
  return _DNSSettings.fromJson(json);
}

/// @nodoc
mixin _$DNSSettings {
  /// 是否启用DNS配置
  bool get enable => throw _privateConstructorUsedError;

  /// DNS服务器列表
  List<String> get servers => throw _privateConstructorUsedError;

  /// DNS备用服务器列表
  List<String> get fallback => throw _privateConstructorUsedError;

  /// DNS策略（整数参数）
  int get strategy => throw _privateConstructorUsedError;

  /// Serializes this DNSSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DNSSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {bool enable, List<String> servers, List<String> fallback, int strategy});
}

/// @nodoc
class _$DNSSettingsCopyWithImpl<$Res, $Val extends DNSSettings>
    implements $DNSSettingsCopyWith<$Res> {
  _$DNSSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DNSSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enable = null,
    Object? servers = null,
    Object? fallback = null,
    Object? strategy = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DNSSettingsImplCopyWith<$Res>
    implements $DNSSettingsCopyWith<$Res> {
  factory _$$DNSSettingsImplCopyWith(
          _$DNSSettingsImpl value, $Res Function(_$DNSSettingsImpl) then) =
      __$$DNSSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enable, List<String> servers, List<String> fallback, int strategy});
}

/// @nodoc
class __$$DNSSettingsImplCopyWithImpl<$Res>
    extends _$DNSSettingsCopyWithImpl<$Res, _$DNSSettingsImpl>
    implements _$$DNSSettingsImplCopyWith<$Res> {
  __$$DNSSettingsImplCopyWithImpl(
      _$DNSSettingsImpl _value, $Res Function(_$DNSSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DNSSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enable = null,
    Object? servers = null,
    Object? fallback = null,
    Object? strategy = null,
  }) {
    return _then(_$DNSSettingsImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DNSSettingsImpl implements _DNSSettings {
  const _$DNSSettingsImpl(
      {this.enable = false,
      final List<String> servers = const [],
      final List<String> fallback = const [],
      this.strategy = 0})
      : _servers = servers,
        _fallback = fallback;

  factory _$DNSSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DNSSettingsImplFromJson(json);

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

  @override
  String toString() {
    return 'DNSSettings(enable: $enable, servers: $servers, fallback: $fallback, strategy: $strategy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DNSSettingsImpl &&
            (identical(other.enable, enable) || other.enable == enable) &&
            const DeepCollectionEquality().equals(other._servers, _servers) &&
            const DeepCollectionEquality().equals(other._fallback, _fallback) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      enable,
      const DeepCollectionEquality().hash(_servers),
      const DeepCollectionEquality().hash(_fallback),
      strategy);

  /// Create a copy of DNSSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DNSSettingsImplCopyWith<_$DNSSettingsImpl> get copyWith =>
      __$$DNSSettingsImplCopyWithImpl<_$DNSSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DNSSettingsImplToJson(
      this,
    );
  }
}

abstract class _DNSSettings implements DNSSettings {
  const factory _DNSSettings(
      {final bool enable,
      final List<String> servers,
      final List<String> fallback,
      final int strategy}) = _$DNSSettingsImpl;

  factory _DNSSettings.fromJson(Map<String, dynamic> json) =
      _$DNSSettingsImpl.fromJson;

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

  /// Create a copy of DNSSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DNSSettingsImplCopyWith<_$DNSSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
