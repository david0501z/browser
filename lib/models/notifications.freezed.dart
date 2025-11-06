// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Notifications _$NotificationsFromJson(Map<String, dynamic> json) {
  return _Notifications.fromJson(json);
}

/// @nodoc
mixin _$Notifications {
  /// 是否启用通知
  bool get enabled => throw _privateConstructorUsedError;

  /// 连接状态通知
  bool get connectionStatus => throw _privateConstructorUsedError;

  /// 流量警告通知
  bool get trafficAlert => throw _privateConstructorUsedError;

  /// 节点切换通知
  bool get nodeSwitch => throw _privateConstructorUsedError;

  /// 系统代理通知
  bool get systemProxy => throw _privateConstructorUsedError;

  /// 更新通知
  bool get update => throw _privateConstructorUsedError;

  /// 错误通知
  bool get errors => throw _privateConstructorUsedError;

  /// Serializes this Notifications to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Notifications
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationsCopyWith<Notifications> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsCopyWith<$Res> {
  factory $NotificationsCopyWith(
          Notifications value, $Res Function(Notifications) then) =;
      _$NotificationsCopyWithImpl<$Res, Notifications>;
  @useResult
  $Res call(
      {bool enabled,
      bool connectionStatus,
      bool trafficAlert,
      bool nodeSwitch,
      bool systemProxy,
      bool update,
      bool errors});
}

/// @nodoc
class _$NotificationsCopyWithImpl<$Res, $Val extends Notifications>
    implements $NotificationsCopyWith<$Res> {
  _$NotificationsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Notifications
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? connectionStatus = null,
    Object? trafficAlert = null,
    Object? nodeSwitch = null,
    Object? systemProxy = null,
    Object? update = null,
    Object? errors = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled;
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      connectionStatus: null == connectionStatus;
          ? _value.connectionStatus
          : connectionStatus // ignore: cast_nullable_to_non_nullable
              as bool,
      trafficAlert: null == trafficAlert;
          ? _value.trafficAlert
          : trafficAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      nodeSwitch: null == nodeSwitch;
          ? _value.nodeSwitch
          : nodeSwitch // ignore: cast_nullable_to_non_nullable
              as bool,
      systemProxy: null == systemProxy;
          ? _value.systemProxy
          : systemProxy // ignore: cast_nullable_to_non_nullable
              as bool,
      update: null == update;
          ? _value.update
          : update // ignore: cast_nullable_to_non_nullable
              as bool,
      errors: null == errors;
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationsImplCopyWith<$Res>
    implements $NotificationsCopyWith<$Res> {
  factory _$$NotificationsImplCopyWith(
          _$NotificationsImpl value, $Res Function(_$NotificationsImpl) then) =;
      __$$NotificationsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      bool connectionStatus,
      bool trafficAlert,
      bool nodeSwitch,
      bool systemProxy,
      bool update,
      bool errors});
}

/// @nodoc
class __$$NotificationsImplCopyWithImpl<$Res>
    extends _$NotificationsCopyWithImpl<$Res, _$NotificationsImpl>
    implements _$$NotificationsImplCopyWith<$Res> {
  __$$NotificationsImplCopyWithImpl(
      _$NotificationsImpl _value, $Res Function(_$NotificationsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Notifications
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? connectionStatus = null,
    Object? trafficAlert = null,
    Object? nodeSwitch = null,
    Object? systemProxy = null,
    Object? update = null,
    Object? errors = null,
  }) {
    return _then(_$NotificationsImpl(
      enabled: null == enabled;
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      connectionStatus: null == connectionStatus;
          ? _value.connectionStatus
          : connectionStatus // ignore: cast_nullable_to_non_nullable
              as bool,
      trafficAlert: null == trafficAlert;
          ? _value.trafficAlert
          : trafficAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      nodeSwitch: null == nodeSwitch;
          ? _value.nodeSwitch
          : nodeSwitch // ignore: cast_nullable_to_non_nullable
              as bool,
      systemProxy: null == systemProxy;
          ? _value.systemProxy
          : systemProxy // ignore: cast_nullable_to_non_nullable
              as bool,
      update: null == update;
          ? _value.update
          : update // ignore: cast_nullable_to_non_nullable
              as bool,
      errors: null == errors;
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationsImpl extends _Notifications {
  const _$NotificationsImpl(
      {this.enabled = true,
      this.connectionStatus = true,
      this.trafficAlert = false,
      this.nodeSwitch = false,
      this.systemProxy = false,
      this.update = true,
      this.errors = true});
      : super._();

  factory _$NotificationsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationsImplFromJson(json);

  /// 是否启用通知
  @override
  @JsonKey()
  final bool enabled;

  /// 连接状态通知
  @override
  @JsonKey()
  final bool connectionStatus;

  /// 流量警告通知
  @override
  @JsonKey()
  final bool trafficAlert;

  /// 节点切换通知
  @override
  @JsonKey()
  final bool nodeSwitch;

  /// 系统代理通知
  @override
  @JsonKey()
  final bool systemProxy;

  /// 更新通知
  @override
  @JsonKey()
  final bool update;

  /// 错误通知
  @override
  @JsonKey()
  final bool errors;

  @override
  String toString() {
    return 'Notifications(enabled: $enabled, connectionStatus: $connectionStatus, trafficAlert: $trafficAlert, nodeSwitch: $nodeSwitch, systemProxy: $systemProxy, update: $update, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.connectionStatus, connectionStatus) ||
                other.connectionStatus == connectionStatus) &&
            (identical(other.trafficAlert, trafficAlert) ||
                other.trafficAlert == trafficAlert) &&
            (identical(other.nodeSwitch, nodeSwitch) ||
                other.nodeSwitch == nodeSwitch) &&
            (identical(other.systemProxy, systemProxy) ||
                other.systemProxy == systemProxy) &&
            (identical(other.update, update) || other.update == update) &&
            (identical(other.errors, errors) || other.errors == errors));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, enabled, connectionStatus,
      trafficAlert, nodeSwitch, systemProxy, update, errors);

  /// Create a copy of Notifications
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationsImplCopyWith<_$NotificationsImpl> get copyWith =>
      __$$NotificationsImplCopyWithImpl<_$NotificationsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationsImplToJson(
      this,
    );
  }
}

abstract class _Notifications extends Notifications {
  const factory _Notifications(
      {final bool enabled,
      final bool connectionStatus,
      final bool trafficAlert,
      final bool nodeSwitch,
      final bool systemProxy,
      final bool update,
      final bool errors}) = _$NotificationsImpl;
  const _Notifications._() : super._();

  factory _Notifications.fromJson(Map<String, dynamic> json) =;
      _$NotificationsImpl.fromJson;

  /// 是否启用通知
  @override
  bool get enabled;

  /// 连接状态通知
  @override
  bool get connectionStatus;

  /// 流量警告通知
  @override
  bool get trafficAlert;

  /// 节点切换通知
  @override
  bool get nodeSwitch;

  /// 系统代理通知
  @override
  bool get systemProxy;

  /// 更新通知
  @override
  bool get update;

  /// 错误通知
  @override
  bool get errors;

  /// Create a copy of Notifications
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationsImplCopyWith<_$NotificationsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
