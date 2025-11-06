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
mixin _$Notifications {
  bool get enabled => throw _privateConstructorUsedError;
  bool get connectionStatus => throw _privateConstructorUsedError;
  bool get trafficAlert => throw _privateConstructorUsedError;
  bool get nodeSwitch => throw _privateConstructorUsedError;
  bool get systemProxy => throw _privateConstructorUsedError;
  bool get update => throw _privateConstructorUsedError;
  bool get errors => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationsCopyWith<Notifications> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsCopyWith<$Res> {
  factory $NotificationsCopyWith(
          Notifications value, $Res Function(Notifications) then) =
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

  // ignore: unused_element
  final $Val _value;
  // ignore: unused_element
  final $Res Function($Val) _then;

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
      enabled: null == enabled ? _value.enabled : enabled as bool,
      connectionStatus: null == connectionStatus
          ? _value.connectionStatus
          : connectionStatus as bool,
      trafficAlert: null == trafficAlert
          ? _value.trafficAlert
          : trafficAlert as bool,
      nodeSwitch: null == nodeSwitch ? _value.nodeSwitch : nodeSwitch as bool,
      systemProxy: null == systemProxy ? _value.systemProxy : systemProxy as bool,
      update: null == update ? _value.update : update as bool,
      errors: null == errors ? _value.errors : errors as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationsCopyWith<$Res>
    implements $NotificationsCopyWith<$Res> {
  factory _$$NotificationsCopyWith(
          _$Notifications value, $Res Function(_$Notifications) then) =
      __$$NotificationsCopyWithImpl<$Res>;
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
class __$$NotificationsCopyWithImpl<$Res>
    extends _$NotificationsCopyWithImpl<$Res, _$Notifications>
    implements _$$NotificationsCopyWith<$Res> {
  __$$NotificationsCopyWithImpl(
      _$Notifications _value, $Res Function(_$Notifications) _then)
      : super(_value, _then);

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
    return _then(_$Notifications(
      enabled: null == enabled ? _value.enabled : enabled as bool,
      connectionStatus: null == connectionStatus
          ? _value.connectionStatus
          : connectionStatus as bool,
      trafficAlert: null == trafficAlert
          ? _value.trafficAlert
          : trafficAlert as bool,
      nodeSwitch: null == nodeSwitch ? _value.nodeSwitch : nodeSwitch as bool,
      systemProxy: null == systemProxy ? _value.systemProxy : systemProxy as bool,
      update: null == update ? _value.update : update as bool,
      errors: null == errors ? _value.errors : errors as bool,
    ));
  }
}

/// @nodoc

class _$Notifications extends _Notifications {
  const _$Notifications(
      {this.enabled = true,
      this.connectionStatus = true,
      this.trafficAlert = false,
      this.nodeSwitch = false,
      this.systemProxy = false,
      this.update = true,
      this.errors = true})
      : super._();

  @override
  final bool enabled;
  @override
  final bool connectionStatus;
  @override
  final bool trafficAlert;
  @override
  final bool nodeSwitch;
  @override
  final bool systemProxy;
  @override
  final bool update;
  @override
  final bool errors;

  @override
  String toString() {
    return 'Notifications(enabled: $enabled, connectionStatus: $connectionStatus, trafficAlert: $trafficAlert, nodeSwitch: $nodeSwitch, systemProxy: $systemProxy, update: $update, errors: $errors)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Notifications &&
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

  @override
  int get hashCode => Object.hash(
      runtimeType,
      enabled,
      connectionStatus,
      trafficAlert,
      nodeSwitch,
      systemProxy,
      update,
      errors);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationsCopyWith<_$Notifications> get copyWith =>
      __$$NotificationsCopyWithImpl<_$Notifications>(this, _$identity);
}

abstract class _Notifications extends Notifications {
  const factory _Notifications(
      {final bool enabled,
      final bool connectionStatus,
      final bool trafficAlert,
      final bool nodeSwitch,
      final bool systemProxy,
      final bool update,
      final bool errors}) = _$Notifications;
  const _Notifications._() : super._();

  @override
  bool get enabled;
  @override
  bool get connectionStatus;
  @override
  bool get trafficAlert;
  @override
  bool get nodeSwitch;
  @override
  bool get systemProxy;
  @override
  bool get update;
  @override
  bool get errors;
  @override
  @JsonKey(ignore: true)
  _$$NotificationsCopyWith<_$Notifications> get copyWith;
}
