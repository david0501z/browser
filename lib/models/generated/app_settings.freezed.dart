// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:freezed_annotation/freezed_annotation.dart';
part of '../app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppSettings {
  String get version => throw _privateConstructorUsedError;
  int get createdAt => throw _privateConstructorUsedError;
  int get updatedAt => throw _privateConstructorUsedError;
  SettingsMode get mode => throw _privateConstructorUsedError;
  BrowserSettings get browserSettings => throw _privateConstructorUsedError;
  ClashCoreSettings get flclashSettings => throw _privateConstructorUsedError;
  UI get ui => throw _privateConstructorUsedError;
  Notifications get notifications => throw _privateConstructorUsedError;
  Privacy get privacy => throw _privateConstructorUsedError;
  Backup get backup => throw _privateConstructorUsedError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =;
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call({
    String version,
    int createdAt,
    int updatedAt,
    SettingsMode mode,
    BrowserSettings browserSettings,
    ClashCoreSettings flclashSettings,
    UI ui,
    Notifications notifications,
    Privacy privacy,
    Backup backup,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_element
  final $Val _value;
  // ignore: unused_element
  $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? mode = null,
    Object? browserSettings = null,
    Object? flclashSettings = null,
    Object? ui = null,
    Object? notifications = null,
    Object? privacy = null,
    Object? backup = null,
  }) {
    return _then(_value.copyWith(
      version: null == version;
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt;
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt;
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      mode: null == mode;
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as SettingsMode,
      browserSettings: null == browserSettings;
          ? _value.browserSettings
          : browserSettings // ignore: cast_nullable_to_non_nullable
              as BrowserSettings,
      flclashSettings: null == flclashSettings;
          ? _value.flclashSettings
          : flclashSettings // ignore: cast_nullable_to_non_nullable
              as ClashCoreSettings,
      ui: null == ui;
          ? _value.ui
          : ui // ignore: cast_nullable_to_non_nullable
              as UI,
      notifications: null == notifications;
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as Notifications,
      privacy: null == privacy;
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as Privacy,
      backup: null == backup;
          ? _value.backup
          : backup // ignore: cast_nullable_to_non_nullable
              as Backup,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppSettingsCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsCopyWith(
          _AppSettings value, $Res Function(_AppSettings) then) =;
      __$$AppSettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String version,
    int createdAt,
    int updatedAt,
    SettingsMode mode,
    BrowserSettings browserSettings,
    ClashCoreSettings flclashSettings,
    UI ui,
    Notifications notifications,
    Privacy privacy,
    Backup backup,
  });
}

/// @nodoc
class __$$AppSettingsCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _AppSettings>
    implements _$$AppSettingsCopyWith<$Res> {
  __$$AppSettingsCopyWithImpl(
      _AppSettings _value, $Res Function(_AppSettings) _then)
      : super(_value, _then);
}

/// @nodoc
class _AppSettings implements AppSettings {
  const _AppSettings(
      {this.version = '1.0.0',
      this.createdAt = 0,
      this.updatedAt = 0,
      this.mode = SettingsMode.standard,
      this.browserSettings = const BrowserSettings(),
      this.flclashSettings = const ClashCoreSettings(),
      this.ui = const UI(),
      this.notifications = const Notifications(),
      this.privacy = const Privacy(),
      this.backup = const Backup()});

  @override
  final String version;
  @override
  final int createdAt;
  @override
  final int updatedAt;
  @override
  final SettingsMode mode;
  @override
  final BrowserSettings browserSettings;
  @override
  final ClashCoreSettings flclashSettings;
  @override
  final UI ui;
  @override
  final Notifications notifications;
  @override
  final Privacy privacy;
  @override
  final Backup backup;

  @override
  String toString() {
    return 'AppSettings(version: $version, createdAt: $createdAt, updatedAt: $updatedAt, mode: $mode, browserSettings: $browserSettings, flclashSettings: $flclashSettings, ui: $ui, notifications: $notifications, privacy: $privacy, backup: $backup)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppSettings &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.browserSettings, browserSettings) ||
                other.browserSettings == browserSettings) &&
            (identical(other.flclashSettings, flclashSettings) ||
                other.flclashSettings == flclashSettings) &&
            (identical(other.ui, ui) || other.ui == ui) &&
            (identical(other.notifications, notifications) ||
                other.notifications == notifications) &&
            (identical(other.privacy, privacy) || other.privacy == privacy) &&
            (identical(other.backup, backup) || other.backup == backup));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, version, createdAt, updatedAt, mode, browserSettings, flclashSettings, ui, notifications, privacy, backup);
  }

  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsCopyWith<_AppSettings> get copyWith =>
      __$$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);
}
