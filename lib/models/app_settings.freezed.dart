// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  /// 版本号
  String get version => throw _privateConstructorUsedError;

  /// 创建时间戳
  int get createdAt => throw _privateConstructorUsedError;

  /// 更新时间戳
  int get updatedAt => throw _privateConstructorUsedError;

  /// 设置模式
  SettingsMode get mode => throw _privateConstructorUsedError;

  /// 浏览器设置
  BrowserSettings get browserSettings => throw _privateConstructorUsedError;

  /// FlClash设置
  FlClashSettings get flclashSettings => throw _privateConstructorUsedError;

  /// UI设置
  UI get ui => throw _privateConstructorUsedError;

  /// 通知设置
  Notifications get notifications => throw _privateConstructorUsedError;

  /// 隐私设置
  Privacy get privacy => throw _privateConstructorUsedError;

  /// 备份设置
  Backup get backup => throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call(
      {String version,
      int createdAt,
      int updatedAt,
      SettingsMode mode,
      BrowserSettings browserSettings,
      FlClashSettings flclashSettings,
      UI ui,
      Notifications notifications,
      Privacy privacy,
      Backup backup});

  $BrowserSettingsCopyWith<$Res> get browserSettings;
  $FlClashSettingsCopyWith<$Res> get flclashSettings;
  $UICopyWith<$Res> get ui;
  $NotificationsCopyWith<$Res> get notifications;
  $PrivacyCopyWith<$Res> get privacy;
  $BackupCopyWith<$Res> get backup;
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
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
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as SettingsMode,
      browserSettings: null == browserSettings
          ? _value.browserSettings
          : browserSettings // ignore: cast_nullable_to_non_nullable
              as BrowserSettings,
      flclashSettings: null == flclashSettings
          ? _value.flclashSettings
          : flclashSettings // ignore: cast_nullable_to_non_nullable
              as FlClashSettings,
      ui: null == ui
          ? _value.ui
          : ui // ignore: cast_nullable_to_non_nullable
              as UI,
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as Notifications,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as Privacy,
      backup: null == backup
          ? _value.backup
          : backup // ignore: cast_nullable_to_non_nullable
              as Backup,
    ) as $Val);
  }

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BrowserSettingsCopyWith<$Res> get browserSettings {
    return $BrowserSettingsCopyWith<$Res>(_value.browserSettings, (value) {
      return _then(_value.copyWith(browserSettings: value) as $Val);
    });
  }

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlClashSettingsCopyWith<$Res> get flclashSettings {
    return $FlClashSettingsCopyWith<$Res>(_value.flclashSettings, (value) {
      return _then(_value.copyWith(flclashSettings: value) as $Val);
    });
  }

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UICopyWith<$Res> get ui {
    return $UICopyWith<$Res>(_value.ui, (value) {
      return _then(_value.copyWith(ui: value) as $Val);
    });
  }

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NotificationsCopyWith<$Res> get notifications {
    return $NotificationsCopyWith<$Res>(_value.notifications, (value) {
      return _then(_value.copyWith(notifications: value) as $Val);
    });
  }

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PrivacyCopyWith<$Res> get privacy {
    return $PrivacyCopyWith<$Res>(_value.privacy, (value) {
      return _then(_value.copyWith(privacy: value) as $Val);
    });
  }

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BackupCopyWith<$Res> get backup {
    return $BackupCopyWith<$Res>(_value.backup, (value) {
      return _then(_value.copyWith(backup: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String version,
      int createdAt,
      int updatedAt,
      SettingsMode mode,
      BrowserSettings browserSettings,
      FlClashSettings flclashSettings,
      UI ui,
      Notifications notifications,
      Privacy privacy,
      Backup backup});

  @override
  $BrowserSettingsCopyWith<$Res> get browserSettings;
  @override
  $FlClashSettingsCopyWith<$Res> get flclashSettings;
  @override
  $UICopyWith<$Res> get ui;
  @override
  $NotificationsCopyWith<$Res> get notifications;
  @override
  $PrivacyCopyWith<$Res> get privacy;
  @override
  $BackupCopyWith<$Res> get backup;
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
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
    return _then(_$AppSettingsImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as SettingsMode,
      browserSettings: null == browserSettings
          ? _value.browserSettings
          : browserSettings // ignore: cast_nullable_to_non_nullable
              as BrowserSettings,
      flclashSettings: null == flclashSettings
          ? _value.flclashSettings
          : flclashSettings // ignore: cast_nullable_to_non_nullable
              as FlClashSettings,
      ui: null == ui
          ? _value.ui
          : ui // ignore: cast_nullable_to_non_nullable
              as UI,
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as Notifications,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as Privacy,
      backup: null == backup
          ? _value.backup
          : backup // ignore: cast_nullable_to_non_nullable
              as Backup,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl(
      {this.version = '1.0.0',
      this.createdAt = 0,
      this.updatedAt = 0,
      this.mode = SettingsMode.standard,
      this.browserSettings = const BrowserSettings(),
      this.flclashSettings = const FlClashSettings(),
      this.ui = const UI(),
      this.notifications = const Notifications(),
      this.privacy = const Privacy(),
      this.backup = const Backup()});

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  /// 版本号
  @override
  @JsonKey()
  final String version;

  /// 创建时间戳
  @override
  @JsonKey()
  final int createdAt;

  /// 更新时间戳
  @override
  @JsonKey()
  final int updatedAt;

  /// 设置模式
  @override
  @JsonKey()
  final SettingsMode mode;

  /// 浏览器设置
  @override
  @JsonKey()
  final BrowserSettings browserSettings;

  /// FlClash设置
  @override
  @JsonKey()
  final FlClashSettings flclashSettings;

  /// UI设置
  @override
  @JsonKey()
  final UI ui;

  /// 通知设置
  @override
  @JsonKey()
  final Notifications notifications;

  /// 隐私设置
  @override
  @JsonKey()
  final Privacy privacy;

  /// 备份设置
  @override
  @JsonKey()
  final Backup backup;

  @override
  String toString() {
    return 'AppSettings(version: $version, createdAt: $createdAt, updatedAt: $updatedAt, mode: $mode, browserSettings: $browserSettings, flclashSettings: $flclashSettings, ui: $ui, notifications: $notifications, privacy: $privacy, backup: $backup)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      version,
      createdAt,
      updatedAt,
      mode,
      browserSettings,
      flclashSettings,
      ui,
      notifications,
      privacy,
      backup);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(
      this,
    );
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings(
      {final String version,
      final int createdAt,
      final int updatedAt,
      final SettingsMode mode,
      final BrowserSettings browserSettings,
      final FlClashSettings flclashSettings,
      final UI ui,
      final Notifications notifications,
      final Privacy privacy,
      final Backup backup}) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  /// 版本号
  @override
  String get version;

  /// 创建时间戳
  @override
  int get createdAt;

  /// 更新时间戳
  @override
  int get updatedAt;

  /// 设置模式
  @override
  SettingsMode get mode;

  /// 浏览器设置
  @override
  BrowserSettings get browserSettings;

  /// FlClash设置
  @override
  FlClashSettings get flclashSettings;

  /// UI设置
  @override
  UI get ui;

  /// 通知设置
  @override
  Notifications get notifications;

  /// 隐私设置
  @override
  Privacy get privacy;

  /// 备份设置
  @override
  Backup get backup;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UI _$UIFromJson(Map<String, dynamic> json) {
  return _UI.fromJson(json);
}

/// @nodoc
mixin _$UI {
  /// 主题模式
  String get themeMode => throw _privateConstructorUsedError;

  /// 语言设置
  String get language => throw _privateConstructorUsedError;

  /// 动画设置
  bool get animations => throw _privateConstructorUsedError;

  /// 字体大小
  int get fontSize => throw _privateConstructorUsedError;

  /// 暗色模式
  bool get darkMode => throw _privateConstructorUsedError;

  /// Serializes this UI to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UI
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UICopyWith<UI> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UICopyWith<$Res> {
  factory $UICopyWith(UI value, $Res Function(UI) then) =
      _$UICopyWithImpl<$Res, UI>;
  @useResult
  $Res call(
      {String themeMode,
      String language,
      bool animations,
      int fontSize,
      bool darkMode});
}

/// @nodoc
class _$UICopyWithImpl<$Res, $Val extends UI> implements $UICopyWith<$Res> {
  _$UICopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UI
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? language = null,
    Object? animations = null,
    Object? fontSize = null,
    Object? darkMode = null,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      animations: null == animations
          ? _value.animations
          : animations // ignore: cast_nullable_to_non_nullable
              as bool,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as int,
      darkMode: null == darkMode
          ? _value.darkMode
          : darkMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UIImplCopyWith<$Res> implements $UICopyWith<$Res> {
  factory _$$UIImplCopyWith(_$UIImpl value, $Res Function(_$UIImpl) then) =
      __$$UIImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String themeMode,
      String language,
      bool animations,
      int fontSize,
      bool darkMode});
}

/// @nodoc
class __$$UIImplCopyWithImpl<$Res> extends _$UICopyWithImpl<$Res, _$UIImpl>
    implements _$$UIImplCopyWith<$Res> {
  __$$UIImplCopyWithImpl(_$UIImpl _value, $Res Function(_$UIImpl) _then)
      : super(_value, _then);

  /// Create a copy of UI
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? language = null,
    Object? animations = null,
    Object? fontSize = null,
    Object? darkMode = null,
  }) {
    return _then(_$UIImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      animations: null == animations
          ? _value.animations
          : animations // ignore: cast_nullable_to_non_nullable
              as bool,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as int,
      darkMode: null == darkMode
          ? _value.darkMode
          : darkMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UIImpl implements _UI {
  const _$UIImpl(
      {this.themeMode = 'system',
      this.language = 'zh-CN',
      this.animations = true,
      this.fontSize = 16,
      this.darkMode = false});

  factory _$UIImpl.fromJson(Map<String, dynamic> json) =>
      _$$UIImplFromJson(json);

  /// 主题模式
  @override
  @JsonKey()
  final String themeMode;

  /// 语言设置
  @override
  @JsonKey()
  final String language;

  /// 动画设置
  @override
  @JsonKey()
  final bool animations;

  /// 字体大小
  @override
  @JsonKey()
  final int fontSize;

  /// 暗色模式
  @override
  @JsonKey()
  final bool darkMode;

  @override
  String toString() {
    return 'UI(themeMode: $themeMode, language: $language, animations: $animations, fontSize: $fontSize, darkMode: $darkMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UIImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.animations, animations) ||
                other.animations == animations) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.darkMode, darkMode) ||
                other.darkMode == darkMode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, themeMode, language, animations, fontSize, darkMode);

  /// Create a copy of UI
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UIImplCopyWith<_$UIImpl> get copyWith =>
      __$$UIImplCopyWithImpl<_$UIImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UIImplToJson(
      this,
    );
  }
}

abstract class _UI implements UI {
  const factory _UI(
      {final String themeMode,
      final String language,
      final bool animations,
      final int fontSize,
      final bool darkMode}) = _$UIImpl;

  factory _UI.fromJson(Map<String, dynamic> json) = _$UIImpl.fromJson;

  /// 主题模式
  @override
  String get themeMode;

  /// 语言设置
  @override
  String get language;

  /// 动画设置
  @override
  bool get animations;

  /// 字体大小
  @override
  int get fontSize;

  /// 暗色模式
  @override
  bool get darkMode;

  /// Create a copy of UI
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UIImplCopyWith<_$UIImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Notifications _$NotificationsFromJson(Map<String, dynamic> json) {
  return _Notifications.fromJson(json);
}

/// @nodoc
mixin _$Notifications {
  /// 是否启用通知
  bool get enabled => throw _privateConstructorUsedError;

  /// 是否显示连接通知
  bool get connectionNotifications => throw _privateConstructorUsedError;

  /// 是否显示更新通知
  bool get updateNotifications => throw _privateConstructorUsedError;

  /// 通知声音
  bool get soundEnabled => throw _privateConstructorUsedError;

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
          Notifications value, $Res Function(Notifications) then) =
      _$NotificationsCopyWithImpl<$Res, Notifications>;
  @useResult
  $Res call(
      {bool enabled,
      bool connectionNotifications,
      bool updateNotifications,
      bool soundEnabled});
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
    Object? connectionNotifications = null,
    Object? updateNotifications = null,
    Object? soundEnabled = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      connectionNotifications: null == connectionNotifications
          ? _value.connectionNotifications
          : connectionNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      updateNotifications: null == updateNotifications
          ? _value.updateNotifications
          : updateNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      soundEnabled: null == soundEnabled
          ? _value.soundEnabled
          : soundEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationsImplCopyWith<$Res>
    implements $NotificationsCopyWith<$Res> {
  factory _$$NotificationsImplCopyWith(
          _$NotificationsImpl value, $Res Function(_$NotificationsImpl) then) =
      __$$NotificationsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      bool connectionNotifications,
      bool updateNotifications,
      bool soundEnabled});
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
    Object? connectionNotifications = null,
    Object? updateNotifications = null,
    Object? soundEnabled = null,
  }) {
    return _then(_$NotificationsImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      connectionNotifications: null == connectionNotifications
          ? _value.connectionNotifications
          : connectionNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      updateNotifications: null == updateNotifications
          ? _value.updateNotifications
          : updateNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      soundEnabled: null == soundEnabled
          ? _value.soundEnabled
          : soundEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationsImpl implements _Notifications {
  const _$NotificationsImpl(
      {this.enabled = true,
      this.connectionNotifications = true,
      this.updateNotifications = true,
      this.soundEnabled = true});

  factory _$NotificationsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationsImplFromJson(json);

  /// 是否启用通知
  @override
  @JsonKey()
  final bool enabled;

  /// 是否显示连接通知
  @override
  @JsonKey()
  final bool connectionNotifications;

  /// 是否显示更新通知
  @override
  @JsonKey()
  final bool updateNotifications;

  /// 通知声音
  @override
  @JsonKey()
  final bool soundEnabled;

  @override
  String toString() {
    return 'Notifications(enabled: $enabled, connectionNotifications: $connectionNotifications, updateNotifications: $updateNotifications, soundEnabled: $soundEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(
                    other.connectionNotifications, connectionNotifications) ||
                other.connectionNotifications == connectionNotifications) &&
            (identical(other.updateNotifications, updateNotifications) ||
                other.updateNotifications == updateNotifications) &&
            (identical(other.soundEnabled, soundEnabled) ||
                other.soundEnabled == soundEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, enabled, connectionNotifications,
      updateNotifications, soundEnabled);

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

abstract class _Notifications implements Notifications {
  const factory _Notifications(
      {final bool enabled,
      final bool connectionNotifications,
      final bool updateNotifications,
      final bool soundEnabled}) = _$NotificationsImpl;

  factory _Notifications.fromJson(Map<String, dynamic> json) =
      _$NotificationsImpl.fromJson;

  /// 是否启用通知
  @override
  bool get enabled;

  /// 是否显示连接通知
  @override
  bool get connectionNotifications;

  /// 是否显示更新通知
  @override
  bool get updateNotifications;

  /// 通知声音
  @override
  bool get soundEnabled;

  /// Create a copy of Notifications
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationsImplCopyWith<_$NotificationsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Privacy _$PrivacyFromJson(Map<String, dynamic> json) {
  return _Privacy.fromJson(json);
}

/// @nodoc
mixin _$Privacy {
  /// 隐私模式
  bool get privacyMode => throw _privateConstructorUsedError;

  /// 数据加密
  bool get dataEncryption => throw _privateConstructorUsedError;

  /// 遥测数据
  bool get telemetry => throw _privateConstructorUsedError;

  /// 自动清除历史
  bool get autoClearHistory => throw _privateConstructorUsedError;

  /// Serializes this Privacy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Privacy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrivacyCopyWith<Privacy> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacyCopyWith<$Res> {
  factory $PrivacyCopyWith(Privacy value, $Res Function(Privacy) then) =
      _$PrivacyCopyWithImpl<$Res, Privacy>;
  @useResult
  $Res call(
      {bool privacyMode,
      bool dataEncryption,
      bool telemetry,
      bool autoClearHistory});
}

/// @nodoc
class _$PrivacyCopyWithImpl<$Res, $Val extends Privacy>
    implements $PrivacyCopyWith<$Res> {
  _$PrivacyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Privacy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? privacyMode = null,
    Object? dataEncryption = null,
    Object? telemetry = null,
    Object? autoClearHistory = null,
  }) {
    return _then(_value.copyWith(
      privacyMode: null == privacyMode
          ? _value.privacyMode
          : privacyMode // ignore: cast_nullable_to_non_nullable
              as bool,
      dataEncryption: null == dataEncryption
          ? _value.dataEncryption
          : dataEncryption // ignore: cast_nullable_to_non_nullable
              as bool,
      telemetry: null == telemetry
          ? _value.telemetry
          : telemetry // ignore: cast_nullable_to_non_nullable
              as bool,
      autoClearHistory: null == autoClearHistory
          ? _value.autoClearHistory
          : autoClearHistory // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivacyImplCopyWith<$Res> implements $PrivacyCopyWith<$Res> {
  factory _$$PrivacyImplCopyWith(
          _$PrivacyImpl value, $Res Function(_$PrivacyImpl) then) =
      __$$PrivacyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool privacyMode,
      bool dataEncryption,
      bool telemetry,
      bool autoClearHistory});
}

/// @nodoc
class __$$PrivacyImplCopyWithImpl<$Res>
    extends _$PrivacyCopyWithImpl<$Res, _$PrivacyImpl>
    implements _$$PrivacyImplCopyWith<$Res> {
  __$$PrivacyImplCopyWithImpl(
      _$PrivacyImpl _value, $Res Function(_$PrivacyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Privacy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? privacyMode = null,
    Object? dataEncryption = null,
    Object? telemetry = null,
    Object? autoClearHistory = null,
  }) {
    return _then(_$PrivacyImpl(
      privacyMode: null == privacyMode
          ? _value.privacyMode
          : privacyMode // ignore: cast_nullable_to_non_nullable
              as bool,
      dataEncryption: null == dataEncryption
          ? _value.dataEncryption
          : dataEncryption // ignore: cast_nullable_to_non_nullable
              as bool,
      telemetry: null == telemetry
          ? _value.telemetry
          : telemetry // ignore: cast_nullable_to_non_nullable
              as bool,
      autoClearHistory: null == autoClearHistory
          ? _value.autoClearHistory
          : autoClearHistory // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivacyImpl implements _Privacy {
  const _$PrivacyImpl(
      {this.privacyMode = false,
      this.dataEncryption = true,
      this.telemetry = false,
      this.autoClearHistory = false});

  factory _$PrivacyImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacyImplFromJson(json);

  /// 隐私模式
  @override
  @JsonKey()
  final bool privacyMode;

  /// 数据加密
  @override
  @JsonKey()
  final bool dataEncryption;

  /// 遥测数据
  @override
  @JsonKey()
  final bool telemetry;

  /// 自动清除历史
  @override
  @JsonKey()
  final bool autoClearHistory;

  @override
  String toString() {
    return 'Privacy(privacyMode: $privacyMode, dataEncryption: $dataEncryption, telemetry: $telemetry, autoClearHistory: $autoClearHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacyImpl &&
            (identical(other.privacyMode, privacyMode) ||
                other.privacyMode == privacyMode) &&
            (identical(other.dataEncryption, dataEncryption) ||
                other.dataEncryption == dataEncryption) &&
            (identical(other.telemetry, telemetry) ||
                other.telemetry == telemetry) &&
            (identical(other.autoClearHistory, autoClearHistory) ||
                other.autoClearHistory == autoClearHistory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, privacyMode, dataEncryption, telemetry, autoClearHistory);

  /// Create a copy of Privacy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacyImplCopyWith<_$PrivacyImpl> get copyWith =>
      __$$PrivacyImplCopyWithImpl<_$PrivacyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivacyImplToJson(
      this,
    );
  }
}

abstract class _Privacy implements Privacy {
  const factory _Privacy(
      {final bool privacyMode,
      final bool dataEncryption,
      final bool telemetry,
      final bool autoClearHistory}) = _$PrivacyImpl;

  factory _Privacy.fromJson(Map<String, dynamic> json) = _$PrivacyImpl.fromJson;

  /// 隐私模式
  @override
  bool get privacyMode;

  /// 数据加密
  @override
  bool get dataEncryption;

  /// 遥测数据
  @override
  bool get telemetry;

  /// 自动清除历史
  @override
  bool get autoClearHistory;

  /// Create a copy of Privacy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrivacyImplCopyWith<_$PrivacyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Backup _$BackupFromJson(Map<String, dynamic> json) {
  return _Backup.fromJson(json);
}

/// @nodoc
mixin _$Backup {
  /// 是否自动备份
  bool get autoBackup => throw _privateConstructorUsedError;

  /// 备份间隔（天）
  int get backupInterval => throw _privateConstructorUsedError;

  /// 保留备份数量
  int get keepBackups => throw _privateConstructorUsedError;

  /// 备份路径
  String? get backupPath => throw _privateConstructorUsedError;

  /// Serializes this Backup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Backup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackupCopyWith<Backup> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackupCopyWith<$Res> {
  factory $BackupCopyWith(Backup value, $Res Function(Backup) then) =
      _$BackupCopyWithImpl<$Res, Backup>;
  @useResult
  $Res call(
      {bool autoBackup,
      int backupInterval,
      int keepBackups,
      String? backupPath});
}

/// @nodoc
class _$BackupCopyWithImpl<$Res, $Val extends Backup>
    implements $BackupCopyWith<$Res> {
  _$BackupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Backup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoBackup = null,
    Object? backupInterval = null,
    Object? keepBackups = null,
    Object? backupPath = freezed,
  }) {
    return _then(_value.copyWith(
      autoBackup: null == autoBackup
          ? _value.autoBackup
          : autoBackup // ignore: cast_nullable_to_non_nullable
              as bool,
      backupInterval: null == backupInterval
          ? _value.backupInterval
          : backupInterval // ignore: cast_nullable_to_non_nullable
              as int,
      keepBackups: null == keepBackups
          ? _value.keepBackups
          : keepBackups // ignore: cast_nullable_to_non_nullable
              as int,
      backupPath: freezed == backupPath
          ? _value.backupPath
          : backupPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BackupImplCopyWith<$Res> implements $BackupCopyWith<$Res> {
  factory _$$BackupImplCopyWith(
          _$BackupImpl value, $Res Function(_$BackupImpl) then) =
      __$$BackupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool autoBackup,
      int backupInterval,
      int keepBackups,
      String? backupPath});
}

/// @nodoc
class __$$BackupImplCopyWithImpl<$Res>
    extends _$BackupCopyWithImpl<$Res, _$BackupImpl>
    implements _$$BackupImplCopyWith<$Res> {
  __$$BackupImplCopyWithImpl(
      _$BackupImpl _value, $Res Function(_$BackupImpl) _then)
      : super(_value, _then);

  /// Create a copy of Backup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoBackup = null,
    Object? backupInterval = null,
    Object? keepBackups = null,
    Object? backupPath = freezed,
  }) {
    return _then(_$BackupImpl(
      autoBackup: null == autoBackup
          ? _value.autoBackup
          : autoBackup // ignore: cast_nullable_to_non_nullable
              as bool,
      backupInterval: null == backupInterval
          ? _value.backupInterval
          : backupInterval // ignore: cast_nullable_to_non_nullable
              as int,
      keepBackups: null == keepBackups
          ? _value.keepBackups
          : keepBackups // ignore: cast_nullable_to_non_nullable
              as int,
      backupPath: freezed == backupPath
          ? _value.backupPath
          : backupPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BackupImpl implements _Backup {
  const _$BackupImpl(
      {this.autoBackup = false,
      this.backupInterval = 7,
      this.keepBackups = 5,
      this.backupPath});

  factory _$BackupImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackupImplFromJson(json);

  /// 是否自动备份
  @override
  @JsonKey()
  final bool autoBackup;

  /// 备份间隔（天）
  @override
  @JsonKey()
  final int backupInterval;

  /// 保留备份数量
  @override
  @JsonKey()
  final int keepBackups;

  /// 备份路径
  @override
  final String? backupPath;

  @override
  String toString() {
    return 'Backup(autoBackup: $autoBackup, backupInterval: $backupInterval, keepBackups: $keepBackups, backupPath: $backupPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackupImpl &&
            (identical(other.autoBackup, autoBackup) ||
                other.autoBackup == autoBackup) &&
            (identical(other.backupInterval, backupInterval) ||
                other.backupInterval == backupInterval) &&
            (identical(other.keepBackups, keepBackups) ||
                other.keepBackups == keepBackups) &&
            (identical(other.backupPath, backupPath) ||
                other.backupPath == backupPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, autoBackup, backupInterval, keepBackups, backupPath);

  /// Create a copy of Backup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackupImplCopyWith<_$BackupImpl> get copyWith =>
      __$$BackupImplCopyWithImpl<_$BackupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BackupImplToJson(
      this,
    );
  }
}

abstract class _Backup implements Backup {
  const factory _Backup(
      {final bool autoBackup,
      final int backupInterval,
      final int keepBackups,
      final String? backupPath}) = _$BackupImpl;

  factory _Backup.fromJson(Map<String, dynamic> json) = _$BackupImpl.fromJson;

  /// 是否自动备份
  @override
  bool get autoBackup;

  /// 备份间隔（天）
  @override
  int get backupInterval;

  /// 保留备份数量
  @override
  int get keepBackups;

  /// 备份路径
  @override
  String? get backupPath;

  /// Create a copy of Backup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackupImplCopyWith<_$BackupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FlClashSettings _$FlClashSettingsFromJson(Map<String, dynamic> json) {
  return _FlClashSettings.fromJson(json);
}

/// @nodoc
mixin _$FlClashSettings {
  /// 是否启用FlClash
  bool get enabled => throw _privateConstructorUsedError;

  /// 代理模式
  ProxyMode get mode => throw _privateConstructorUsedError;

  /// 核心版本
  String get coreVersion => throw _privateConstructorUsedError;

  /// 配置文件路径
  String? get configPath => throw _privateConstructorUsedError;

  /// 日志级别
  LogLevel get logLevel => throw _privateConstructorUsedError;

  /// 是否自动更新
  bool get autoUpdate => throw _privateConstructorUsedError;

  /// 是否启用IPv6
  bool get ipv6 => throw _privateConstructorUsedError;

  /// 是否启用TUN模式
  bool get tunMode => throw _privateConstructorUsedError;

  /// 是否启用混合模式
  bool get mixedMode => throw _privateConstructorUsedError;

  /// 是否启用系统代理
  bool get systemProxy => throw _privateConstructorUsedError;

  /// 是否启用局域网共享
  bool get lanShare => throw _privateConstructorUsedError;

  /// 是否启用DNS转发
  bool get dnsForward => throw _privateConstructorUsedError;

  /// 端口设置
  PortSettings get ports => throw _privateConstructorUsedError;

  /// DNS设置
  DNSSettings get dns => throw _privateConstructorUsedError;

  /// 规则设置
  RuleSettings get rules => throw _privateConstructorUsedError;

  /// 节点设置
  NodeSettings get nodes => throw _privateConstructorUsedError;

  /// 流量设置
  TrafficSettings get traffic => throw _privateConstructorUsedError;

  /// 代理核心相关字段
  ProxyCoreSettings? get proxyCoreSettings =>
      throw _privateConstructorUsedError;

  /// Serializes this FlClashSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FlClashSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlClashSettingsCopyWith<FlClashSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlClashSettingsCopyWith<$Res> {
  factory $FlClashSettingsCopyWith(
          FlClashSettings value, $Res Function(FlClashSettings) then) =
      _$FlClashSettingsCopyWithImpl<$Res, FlClashSettings>;
  @useResult
  $Res call(
      {bool enabled,
      ProxyMode mode,
      String coreVersion,
      String? configPath,
      LogLevel logLevel,
      bool autoUpdate,
      bool ipv6,
      bool tunMode,
      bool mixedMode,
      bool systemProxy,
      bool lanShare,
      bool dnsForward,
      PortSettings ports,
      DNSSettings dns,
      RuleSettings rules,
      NodeSettings nodes,
      TrafficSettings traffic,
      ProxyCoreSettings? proxyCoreSettings});

  $PortSettingsCopyWith<$Res> get ports;
  $DNSSettingsCopyWith<$Res> get dns;
  $RuleSettingsCopyWith<$Res> get rules;
  $NodeSettingsCopyWith<$Res> get nodes;
  $TrafficSettingsCopyWith<$Res> get traffic;
  $ProxyCoreSettingsCopyWith<$Res>? get proxyCoreSettings;
}

/// @nodoc
class _$FlClashSettingsCopyWithImpl<$Res, $Val extends FlClashSettings>
    implements $FlClashSettingsCopyWith<$Res> {
  _$FlClashSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlClashSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? mode = null,
    Object? coreVersion = null,
    Object? configPath = freezed,
    Object? logLevel = null,
    Object? autoUpdate = null,
    Object? ipv6 = null,
    Object? tunMode = null,
    Object? mixedMode = null,
    Object? systemProxy = null,
    Object? lanShare = null,
    Object? dnsForward = null,
    Object? ports = null,
    Object? dns = null,
    Object? rules = null,
    Object? nodes = null,
    Object? traffic = null,
    Object? proxyCoreSettings = freezed,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ProxyMode,
      coreVersion: null == coreVersion
          ? _value.coreVersion
          : coreVersion // ignore: cast_nullable_to_non_nullable
              as String,
      configPath: freezed == configPath
          ? _value.configPath
          : configPath // ignore: cast_nullable_to_non_nullable
              as String?,
      logLevel: null == logLevel
          ? _value.logLevel
          : logLevel // ignore: cast_nullable_to_non_nullable
              as LogLevel,
      autoUpdate: null == autoUpdate
          ? _value.autoUpdate
          : autoUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
      ipv6: null == ipv6
          ? _value.ipv6
          : ipv6 // ignore: cast_nullable_to_non_nullable
              as bool,
      tunMode: null == tunMode
          ? _value.tunMode
          : tunMode // ignore: cast_nullable_to_non_nullable
              as bool,
      mixedMode: null == mixedMode
          ? _value.mixedMode
          : mixedMode // ignore: cast_nullable_to_non_nullable
              as bool,
      systemProxy: null == systemProxy
          ? _value.systemProxy
          : systemProxy // ignore: cast_nullable_to_non_nullable
              as bool,
      lanShare: null == lanShare
          ? _value.lanShare
          : lanShare // ignore: cast_nullable_to_non_nullable
              as bool,
      dnsForward: null == dnsForward
          ? _value.dnsForward
          : dnsForward // ignore: cast_nullable_to_non_nullable
              as bool,
      ports: null == ports
          ? _value.ports
          : ports // ignore: cast_nullable_to_non_nullable
              as PortSettings,
      dns: null == dns
          ? _value.dns
          : dns // ignore: cast_nullable_to_non_nullable
              as DNSSettings,
      rules: null == rules
          ? _value.rules
          : rules // ignore: cast_nullable_to_non_nullable
              as RuleSettings,
      nodes: null == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as NodeSettings,
      traffic: null == traffic
          ? _value.traffic
          : traffic // ignore: cast_nullable_to_non_nullable
              as TrafficSettings,
      proxyCoreSettings: freezed == proxyCoreSettings
          ? _value.proxyCoreSettings
          : proxyCoreSettings // ignore: cast_nullable_to_non_nullable
              as ProxyCoreSettings?,
    ) as $Val);
  }

  /// Create a copy of FlClashSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PortSettingsCopyWith<$Res> get ports {
    return $PortSettingsCopyWith<$Res>(_value.ports, (value) {
      return _then(_value.copyWith(ports: value) as $Val);
    });
  }

  /// Create a copy of FlClashSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DNSSettingsCopyWith<$Res> get dns {
    return $DNSSettingsCopyWith<$Res>(_value.dns, (value) {
      return _then(_value.copyWith(dns: value) as $Val);
    });
  }

  /// Create a copy of FlClashSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RuleSettingsCopyWith<$Res> get rules {
    return $RuleSettingsCopyWith<$Res>(_value.rules, (value) {
      return _then(_value.copyWith(rules: value) as $Val);
    });
  }

  /// Create a copy of FlClashSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NodeSettingsCopyWith<$Res> get nodes {
    return $NodeSettingsCopyWith<$Res>(_value.nodes, (value) {
      return _then(_value.copyWith(nodes: value) as $Val);
    });
  }

  /// Create a copy of FlClashSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrafficSettingsCopyWith<$Res> get traffic {
    return $TrafficSettingsCopyWith<$Res>(_value.traffic, (value) {
      return _then(_value.copyWith(traffic: value) as $Val);
    });
  }

  /// Create a copy of FlClashSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProxyCoreSettingsCopyWith<$Res>? get proxyCoreSettings {
    if (_value.proxyCoreSettings == null) {
      return null;
    }

    return $ProxyCoreSettingsCopyWith<$Res>(_value.proxyCoreSettings!, (value) {
      return _then(_value.copyWith(proxyCoreSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FlClashSettingsImplCopyWith<$Res>
    implements $FlClashSettingsCopyWith<$Res> {
  factory _$$FlClashSettingsImplCopyWith(_$FlClashSettingsImpl value,
          $Res Function(_$FlClashSettingsImpl) then) =
      __$$FlClashSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      ProxyMode mode,
      String coreVersion,
      String? configPath,
      LogLevel logLevel,
      bool autoUpdate,
      bool ipv6,
      bool tunMode,
      bool mixedMode,
      bool systemProxy,
      bool lanShare,
      bool dnsForward,
      PortSettings ports,
      DNSSettings dns,
      RuleSettings rules,
      NodeSettings nodes,
      TrafficSettings traffic,
      ProxyCoreSettings? proxyCoreSettings});

  @override
  $PortSettingsCopyWith<$Res> get ports;
  @override
  $DNSSettingsCopyWith<$Res> get dns;
  @override
  $RuleSettingsCopyWith<$Res> get rules;
  @override
  $NodeSettingsCopyWith<$Res> get nodes;
  @override
  $TrafficSettingsCopyWith<$Res> get traffic;
  @override
  $ProxyCoreSettingsCopyWith<$Res>? get proxyCoreSettings;
}

/// @nodoc
class __$$FlClashSettingsImplCopyWithImpl<$Res>
    extends _$FlClashSettingsCopyWithImpl<$Res, _$FlClashSettingsImpl>
    implements _$$FlClashSettingsImplCopyWith<$Res> {
  __$$FlClashSettingsImplCopyWithImpl(
      _$FlClashSettingsImpl _value, $Res Function(_$FlClashSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FlClashSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? mode = null,
    Object? coreVersion = null,
    Object? configPath = freezed,
    Object? logLevel = null,
    Object? autoUpdate = null,
    Object? ipv6 = null,
    Object? tunMode = null,
    Object? mixedMode = null,
    Object? systemProxy = null,
    Object? lanShare = null,
    Object? dnsForward = null,
    Object? ports = null,
    Object? dns = null,
    Object? rules = null,
    Object? nodes = null,
    Object? traffic = null,
    Object? proxyCoreSettings = freezed,
  }) {
    return _then(_$FlClashSettingsImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ProxyMode,
      coreVersion: null == coreVersion
          ? _value.coreVersion
          : coreVersion // ignore: cast_nullable_to_non_nullable
              as String,
      configPath: freezed == configPath
          ? _value.configPath
          : configPath // ignore: cast_nullable_to_non_nullable
              as String?,
      logLevel: null == logLevel
          ? _value.logLevel
          : logLevel // ignore: cast_nullable_to_non_nullable
              as LogLevel,
      autoUpdate: null == autoUpdate
          ? _value.autoUpdate
          : autoUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
      ipv6: null == ipv6
          ? _value.ipv6
          : ipv6 // ignore: cast_nullable_to_non_nullable
              as bool,
      tunMode: null == tunMode
          ? _value.tunMode
          : tunMode // ignore: cast_nullable_to_non_nullable
              as bool,
      mixedMode: null == mixedMode
          ? _value.mixedMode
          : mixedMode // ignore: cast_nullable_to_non_nullable
              as bool,
      systemProxy: null == systemProxy
          ? _value.systemProxy
          : systemProxy // ignore: cast_nullable_to_non_nullable
              as bool,
      lanShare: null == lanShare
          ? _value.lanShare
          : lanShare // ignore: cast_nullable_to_non_nullable
              as bool,
      dnsForward: null == dnsForward
          ? _value.dnsForward
          : dnsForward // ignore: cast_nullable_to_non_nullable
              as bool,
      ports: null == ports
          ? _value.ports
          : ports // ignore: cast_nullable_to_non_nullable
              as PortSettings,
      dns: null == dns
          ? _value.dns
          : dns // ignore: cast_nullable_to_non_nullable
              as DNSSettings,
      rules: null == rules
          ? _value.rules
          : rules // ignore: cast_nullable_to_non_nullable
              as RuleSettings,
      nodes: null == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as NodeSettings,
      traffic: null == traffic
          ? _value.traffic
          : traffic // ignore: cast_nullable_to_non_nullable
              as TrafficSettings,
      proxyCoreSettings: freezed == proxyCoreSettings
          ? _value.proxyCoreSettings
          : proxyCoreSettings // ignore: cast_nullable_to_non_nullable
              as ProxyCoreSettings?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FlClashSettingsImpl extends _FlClashSettings {
  const _$FlClashSettingsImpl(
      {this.enabled = false,
      this.mode = ProxyMode.rule,
      this.coreVersion = '',
      this.configPath,
      this.logLevel = LogLevel.info,
      this.autoUpdate = true,
      this.ipv6 = false,
      this.tunMode = false,
      this.mixedMode = false,
      this.systemProxy = false,
      this.lanShare = false,
      this.dnsForward = false,
      this.ports = const PortSettings(),
      this.dns = const DNSSettings(),
      this.rules = const RuleSettings(),
      this.nodes = const NodeSettings(),
      this.traffic = const TrafficSettings(),
      this.proxyCoreSettings})
      : super._();

  factory _$FlClashSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlClashSettingsImplFromJson(json);

  /// 是否启用FlClash
  @override
  @JsonKey()
  final bool enabled;

  /// 代理模式
  @override
  @JsonKey()
  final ProxyMode mode;

  /// 核心版本
  @override
  @JsonKey()
  final String coreVersion;

  /// 配置文件路径
  @override
  final String? configPath;

  /// 日志级别
  @override
  @JsonKey()
  final LogLevel logLevel;

  /// 是否自动更新
  @override
  @JsonKey()
  final bool autoUpdate;

  /// 是否启用IPv6
  @override
  @JsonKey()
  final bool ipv6;

  /// 是否启用TUN模式
  @override
  @JsonKey()
  final bool tunMode;

  /// 是否启用混合模式
  @override
  @JsonKey()
  final bool mixedMode;

  /// 是否启用系统代理
  @override
  @JsonKey()
  final bool systemProxy;

  /// 是否启用局域网共享
  @override
  @JsonKey()
  final bool lanShare;

  /// 是否启用DNS转发
  @override
  @JsonKey()
  final bool dnsForward;

  /// 端口设置
  @override
  @JsonKey()
  final PortSettings ports;

  /// DNS设置
  @override
  @JsonKey()
  final DNSSettings dns;

  /// 规则设置
  @override
  @JsonKey()
  final RuleSettings rules;

  /// 节点设置
  @override
  @JsonKey()
  final NodeSettings nodes;

  /// 流量设置
  @override
  @JsonKey()
  final TrafficSettings traffic;

  /// 代理核心相关字段
  @override
  final ProxyCoreSettings? proxyCoreSettings;

  @override
  String toString() {
    return 'FlClashSettings(enabled: $enabled, mode: $mode, coreVersion: $coreVersion, configPath: $configPath, logLevel: $logLevel, autoUpdate: $autoUpdate, ipv6: $ipv6, tunMode: $tunMode, mixedMode: $mixedMode, systemProxy: $systemProxy, lanShare: $lanShare, dnsForward: $dnsForward, ports: $ports, dns: $dns, rules: $rules, nodes: $nodes, traffic: $traffic, proxyCoreSettings: $proxyCoreSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlClashSettingsImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.coreVersion, coreVersion) ||
                other.coreVersion == coreVersion) &&
            (identical(other.configPath, configPath) ||
                other.configPath == configPath) &&
            (identical(other.logLevel, logLevel) ||
                other.logLevel == logLevel) &&
            (identical(other.autoUpdate, autoUpdate) ||
                other.autoUpdate == autoUpdate) &&
            (identical(other.ipv6, ipv6) || other.ipv6 == ipv6) &&
            (identical(other.tunMode, tunMode) || other.tunMode == tunMode) &&
            (identical(other.mixedMode, mixedMode) ||
                other.mixedMode == mixedMode) &&
            (identical(other.systemProxy, systemProxy) ||
                other.systemProxy == systemProxy) &&
            (identical(other.lanShare, lanShare) ||
                other.lanShare == lanShare) &&
            (identical(other.dnsForward, dnsForward) ||
                other.dnsForward == dnsForward) &&
            (identical(other.ports, ports) || other.ports == ports) &&
            (identical(other.dns, dns) || other.dns == dns) &&
            (identical(other.rules, rules) || other.rules == rules) &&
            (identical(other.nodes, nodes) || other.nodes == nodes) &&
            (identical(other.traffic, traffic) || other.traffic == traffic) &&
            (identical(other.proxyCoreSettings, proxyCoreSettings) ||
                other.proxyCoreSettings == proxyCoreSettings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      enabled,
      mode,
      coreVersion,
      configPath,
      logLevel,
      autoUpdate,
      ipv6,
      tunMode,
      mixedMode,
      systemProxy,
      lanShare,
      dnsForward,
      ports,
      dns,
      rules,
      nodes,
      traffic,
      proxyCoreSettings);

  /// Create a copy of FlClashSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlClashSettingsImplCopyWith<_$FlClashSettingsImpl> get copyWith =>
      __$$FlClashSettingsImplCopyWithImpl<_$FlClashSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FlClashSettingsImplToJson(
      this,
    );
  }
}

abstract class _FlClashSettings extends FlClashSettings {
  const factory _FlClashSettings(
      {final bool enabled,
      final ProxyMode mode,
      final String coreVersion,
      final String? configPath,
      final LogLevel logLevel,
      final bool autoUpdate,
      final bool ipv6,
      final bool tunMode,
      final bool mixedMode,
      final bool systemProxy,
      final bool lanShare,
      final bool dnsForward,
      final PortSettings ports,
      final DNSSettings dns,
      final RuleSettings rules,
      final NodeSettings nodes,
      final TrafficSettings traffic,
      final ProxyCoreSettings? proxyCoreSettings}) = _$FlClashSettingsImpl;
  const _FlClashSettings._() : super._();

  factory _FlClashSettings.fromJson(Map<String, dynamic> json) =
      _$FlClashSettingsImpl.fromJson;

  /// 是否启用FlClash
  @override
  bool get enabled;

  /// 代理模式
  @override
  ProxyMode get mode;

  /// 核心版本
  @override
  String get coreVersion;

  /// 配置文件路径
  @override
  String? get configPath;

  /// 日志级别
  @override
  LogLevel get logLevel;

  /// 是否自动更新
  @override
  bool get autoUpdate;

  /// 是否启用IPv6
  @override
  bool get ipv6;

  /// 是否启用TUN模式
  @override
  bool get tunMode;

  /// 是否启用混合模式
  @override
  bool get mixedMode;

  /// 是否启用系统代理
  @override
  bool get systemProxy;

  /// 是否启用局域网共享
  @override
  bool get lanShare;

  /// 是否启用DNS转发
  @override
  bool get dnsForward;

  /// 端口设置
  @override
  PortSettings get ports;

  /// DNS设置
  @override
  DNSSettings get dns;

  /// 规则设置
  @override
  RuleSettings get rules;

  /// 节点设置
  @override
  NodeSettings get nodes;

  /// 流量设置
  @override
  TrafficSettings get traffic;

  /// 代理核心相关字段
  @override
  ProxyCoreSettings? get proxyCoreSettings;

  /// Create a copy of FlClashSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlClashSettingsImplCopyWith<_$FlClashSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PortSettings _$PortSettingsFromJson(Map<String, dynamic> json) {
  return _PortSettings.fromJson(json);
}

/// @nodoc
mixin _$PortSettings {
  /// HTTP端口
  int get httpPort => throw _privateConstructorUsedError;

  /// HTTPS端口
  int get httpsPort => throw _privateConstructorUsedError;

  /// SOCKS端口
  int get socksPort => throw _privateConstructorUsedError;

  /// 混合端口
  int get mixedPort => throw _privateConstructorUsedError;

  /// 允许来自局域网的连接
  bool get allowLan => throw _privateConstructorUsedError;

  /// 仅允许来自局域网的连接
  bool get lanOnly => throw _privateConstructorUsedError;

  /// Serializes this PortSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PortSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PortSettingsCopyWith<PortSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortSettingsCopyWith<$Res> {
  factory $PortSettingsCopyWith(
          PortSettings value, $Res Function(PortSettings) then) =
      _$PortSettingsCopyWithImpl<$Res, PortSettings>;
  @useResult
  $Res call(
      {int httpPort,
      int httpsPort,
      int socksPort,
      int mixedPort,
      bool allowLan,
      bool lanOnly});
}

/// @nodoc
class _$PortSettingsCopyWithImpl<$Res, $Val extends PortSettings>
    implements $PortSettingsCopyWith<$Res> {
  _$PortSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PortSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? httpPort = null,
    Object? httpsPort = null,
    Object? socksPort = null,
    Object? mixedPort = null,
    Object? allowLan = null,
    Object? lanOnly = null,
  }) {
    return _then(_value.copyWith(
      httpPort: null == httpPort
          ? _value.httpPort
          : httpPort // ignore: cast_nullable_to_non_nullable
              as int,
      httpsPort: null == httpsPort
          ? _value.httpsPort
          : httpsPort // ignore: cast_nullable_to_non_nullable
              as int,
      socksPort: null == socksPort
          ? _value.socksPort
          : socksPort // ignore: cast_nullable_to_non_nullable
              as int,
      mixedPort: null == mixedPort
          ? _value.mixedPort
          : mixedPort // ignore: cast_nullable_to_non_nullable
              as int,
      allowLan: null == allowLan
          ? _value.allowLan
          : allowLan // ignore: cast_nullable_to_non_nullable
              as bool,
      lanOnly: null == lanOnly
          ? _value.lanOnly
          : lanOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PortSettingsImplCopyWith<$Res>
    implements $PortSettingsCopyWith<$Res> {
  factory _$$PortSettingsImplCopyWith(
          _$PortSettingsImpl value, $Res Function(_$PortSettingsImpl) then) =
      __$$PortSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int httpPort,
      int httpsPort,
      int socksPort,
      int mixedPort,
      bool allowLan,
      bool lanOnly});
}

/// @nodoc
class __$$PortSettingsImplCopyWithImpl<$Res>
    extends _$PortSettingsCopyWithImpl<$Res, _$PortSettingsImpl>
    implements _$$PortSettingsImplCopyWith<$Res> {
  __$$PortSettingsImplCopyWithImpl(
      _$PortSettingsImpl _value, $Res Function(_$PortSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PortSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? httpPort = null,
    Object? httpsPort = null,
    Object? socksPort = null,
    Object? mixedPort = null,
    Object? allowLan = null,
    Object? lanOnly = null,
  }) {
    return _then(_$PortSettingsImpl(
      httpPort: null == httpPort
          ? _value.httpPort
          : httpPort // ignore: cast_nullable_to_non_nullable
              as int,
      httpsPort: null == httpsPort
          ? _value.httpsPort
          : httpsPort // ignore: cast_nullable_to_non_nullable
              as int,
      socksPort: null == socksPort
          ? _value.socksPort
          : socksPort // ignore: cast_nullable_to_non_nullable
              as int,
      mixedPort: null == mixedPort
          ? _value.mixedPort
          : mixedPort // ignore: cast_nullable_to_non_nullable
              as int,
      allowLan: null == allowLan
          ? _value.allowLan
          : allowLan // ignore: cast_nullable_to_non_nullable
              as bool,
      lanOnly: null == lanOnly
          ? _value.lanOnly
          : lanOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PortSettingsImpl implements _PortSettings {
  const _$PortSettingsImpl(
      {this.httpPort = 7890,
      this.httpsPort = 7891,
      this.socksPort = 7892,
      this.mixedPort = 7893,
      this.allowLan = true,
      this.lanOnly = false});

  factory _$PortSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortSettingsImplFromJson(json);

  /// HTTP端口
  @override
  @JsonKey()
  final int httpPort;

  /// HTTPS端口
  @override
  @JsonKey()
  final int httpsPort;

  /// SOCKS端口
  @override
  @JsonKey()
  final int socksPort;

  /// 混合端口
  @override
  @JsonKey()
  final int mixedPort;

  /// 允许来自局域网的连接
  @override
  @JsonKey()
  final bool allowLan;

  /// 仅允许来自局域网的连接
  @override
  @JsonKey()
  final bool lanOnly;

  @override
  String toString() {
    return 'PortSettings(httpPort: $httpPort, httpsPort: $httpsPort, socksPort: $socksPort, mixedPort: $mixedPort, allowLan: $allowLan, lanOnly: $lanOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortSettingsImpl &&
            (identical(other.httpPort, httpPort) ||
                other.httpPort == httpPort) &&
            (identical(other.httpsPort, httpsPort) ||
                other.httpsPort == httpsPort) &&
            (identical(other.socksPort, socksPort) ||
                other.socksPort == socksPort) &&
            (identical(other.mixedPort, mixedPort) ||
                other.mixedPort == mixedPort) &&
            (identical(other.allowLan, allowLan) ||
                other.allowLan == allowLan) &&
            (identical(other.lanOnly, lanOnly) || other.lanOnly == lanOnly));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, httpPort, httpsPort, socksPort,
      mixedPort, allowLan, lanOnly);

  /// Create a copy of PortSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PortSettingsImplCopyWith<_$PortSettingsImpl> get copyWith =>
      __$$PortSettingsImplCopyWithImpl<_$PortSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PortSettingsImplToJson(
      this,
    );
  }
}

abstract class _PortSettings implements PortSettings {
  const factory _PortSettings(
      {final int httpPort,
      final int httpsPort,
      final int socksPort,
      final int mixedPort,
      final bool allowLan,
      final bool lanOnly}) = _$PortSettingsImpl;

  factory _PortSettings.fromJson(Map<String, dynamic> json) =
      _$PortSettingsImpl.fromJson;

  /// HTTP端口
  @override
  int get httpPort;

  /// HTTPS端口
  @override
  int get httpsPort;

  /// SOCKS端口
  @override
  int get socksPort;

  /// 混合端口
  @override
  int get mixedPort;

  /// 允许来自局域网的连接
  @override
  bool get allowLan;

  /// 仅允许来自局域网的连接
  @override
  bool get lanOnly;

  /// Create a copy of PortSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PortSettingsImplCopyWith<_$PortSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DNSSettings _$DNSSettingsFromJson(Map<String, dynamic> json) {
  return _DNSSettings.fromJson(json);
}

/// @nodoc
mixin _$DNSSettings {
  /// 主DNS服务器
  String get primary => throw _privateConstructorUsedError;

  /// 备用DNS服务器
  String get secondary => throw _privateConstructorUsedError;

  /// DNS-over-HTTPS
  bool get doh => throw _privateConstructorUsedError;

  /// DOH URL
  String get dohUrl => throw _privateConstructorUsedError;

  /// 绕过中国大陆域名
  bool get bypassChina => throw _privateConstructorUsedError;

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
      {String primary,
      String secondary,
      bool doh,
      String dohUrl,
      bool bypassChina});
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
    Object? primary = null,
    Object? secondary = null,
    Object? doh = null,
    Object? dohUrl = null,
    Object? bypassChina = null,
  }) {
    return _then(_value.copyWith(
      primary: null == primary
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as String,
      secondary: null == secondary
          ? _value.secondary
          : secondary // ignore: cast_nullable_to_non_nullable
              as String,
      doh: null == doh
          ? _value.doh
          : doh // ignore: cast_nullable_to_non_nullable
              as bool,
      dohUrl: null == dohUrl
          ? _value.dohUrl
          : dohUrl // ignore: cast_nullable_to_non_nullable
              as String,
      bypassChina: null == bypassChina
          ? _value.bypassChina
          : bypassChina // ignore: cast_nullable_to_non_nullable
              as bool,
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
      {String primary,
      String secondary,
      bool doh,
      String dohUrl,
      bool bypassChina});
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
    Object? primary = null,
    Object? secondary = null,
    Object? doh = null,
    Object? dohUrl = null,
    Object? bypassChina = null,
  }) {
    return _then(_$DNSSettingsImpl(
      primary: null == primary
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as String,
      secondary: null == secondary
          ? _value.secondary
          : secondary // ignore: cast_nullable_to_non_nullable
              as String,
      doh: null == doh
          ? _value.doh
          : doh // ignore: cast_nullable_to_non_nullable
              as bool,
      dohUrl: null == dohUrl
          ? _value.dohUrl
          : dohUrl // ignore: cast_nullable_to_non_nullable
              as String,
      bypassChina: null == bypassChina
          ? _value.bypassChina
          : bypassChina // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DNSSettingsImpl implements _DNSSettings {
  const _$DNSSettingsImpl(
      {this.primary = '1.1.1.1',
      this.secondary = '8.8.8.8',
      this.doh = false,
      this.dohUrl = 'https://cloudflare-dns.com/dns-query',
      this.bypassChina = true});

  factory _$DNSSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DNSSettingsImplFromJson(json);

  /// 主DNS服务器
  @override
  @JsonKey()
  final String primary;

  /// 备用DNS服务器
  @override
  @JsonKey()
  final String secondary;

  /// DNS-over-HTTPS
  @override
  @JsonKey()
  final bool doh;

  /// DOH URL
  @override
  @JsonKey()
  final String dohUrl;

  /// 绕过中国大陆域名
  @override
  @JsonKey()
  final bool bypassChina;

  @override
  String toString() {
    return 'DNSSettings(primary: $primary, secondary: $secondary, doh: $doh, dohUrl: $dohUrl, bypassChina: $bypassChina)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DNSSettingsImpl &&
            (identical(other.primary, primary) || other.primary == primary) &&
            (identical(other.secondary, secondary) ||
                other.secondary == secondary) &&
            (identical(other.doh, doh) || other.doh == doh) &&
            (identical(other.dohUrl, dohUrl) || other.dohUrl == dohUrl) &&
            (identical(other.bypassChina, bypassChina) ||
                other.bypassChina == bypassChina));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, primary, secondary, doh, dohUrl, bypassChina);

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
      {final String primary,
      final String secondary,
      final bool doh,
      final String dohUrl,
      final bool bypassChina}) = _$DNSSettingsImpl;

  factory _DNSSettings.fromJson(Map<String, dynamic> json) =
      _$DNSSettingsImpl.fromJson;

  /// 主DNS服务器
  @override
  String get primary;

  /// 备用DNS服务器
  @override
  String get secondary;

  /// DNS-over-HTTPS
  @override
  bool get doh;

  /// DOH URL
  @override
  String get dohUrl;

  /// 绕过中国大陆域名
  @override
  bool get bypassChina;

  /// Create a copy of DNSSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DNSSettingsImplCopyWith<_$DNSSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RuleSettings _$RuleSettingsFromJson(Map<String, dynamic> json) {
  return _RuleSettings.fromJson(json);
}

/// @nodoc
mixin _$RuleSettings {
  /// 绕过中国大陆
  bool get bypassChina => throw _privateConstructorUsedError;

  /// 绕过局域网
  bool get bypassLan => throw _privateConstructorUsedError;

  /// 绕过私有网络
  bool get bypassPrivate => throw _privateConstructorUsedError;

  /// 自定义规则列表
  List<String> get customRules => throw _privateConstructorUsedError;

  /// 规则提供程序
  List<String> get ruleProviders => throw _privateConstructorUsedError;

  /// Serializes this RuleSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RuleSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RuleSettingsCopyWith<RuleSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RuleSettingsCopyWith<$Res> {
  factory $RuleSettingsCopyWith(
          RuleSettings value, $Res Function(RuleSettings) then) =
      _$RuleSettingsCopyWithImpl<$Res, RuleSettings>;
  @useResult
  $Res call(
      {bool bypassChina,
      bool bypassLan,
      bool bypassPrivate,
      List<String> customRules,
      List<String> ruleProviders});
}

/// @nodoc
class _$RuleSettingsCopyWithImpl<$Res, $Val extends RuleSettings>
    implements $RuleSettingsCopyWith<$Res> {
  _$RuleSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RuleSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bypassChina = null,
    Object? bypassLan = null,
    Object? bypassPrivate = null,
    Object? customRules = null,
    Object? ruleProviders = null,
  }) {
    return _then(_value.copyWith(
      bypassChina: null == bypassChina
          ? _value.bypassChina
          : bypassChina // ignore: cast_nullable_to_non_nullable
              as bool,
      bypassLan: null == bypassLan
          ? _value.bypassLan
          : bypassLan // ignore: cast_nullable_to_non_nullable
              as bool,
      bypassPrivate: null == bypassPrivate
          ? _value.bypassPrivate
          : bypassPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      customRules: null == customRules
          ? _value.customRules
          : customRules // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ruleProviders: null == ruleProviders
          ? _value.ruleProviders
          : ruleProviders // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RuleSettingsImplCopyWith<$Res>
    implements $RuleSettingsCopyWith<$Res> {
  factory _$$RuleSettingsImplCopyWith(
          _$RuleSettingsImpl value, $Res Function(_$RuleSettingsImpl) then) =
      __$$RuleSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool bypassChina,
      bool bypassLan,
      bool bypassPrivate,
      List<String> customRules,
      List<String> ruleProviders});
}

/// @nodoc
class __$$RuleSettingsImplCopyWithImpl<$Res>
    extends _$RuleSettingsCopyWithImpl<$Res, _$RuleSettingsImpl>
    implements _$$RuleSettingsImplCopyWith<$Res> {
  __$$RuleSettingsImplCopyWithImpl(
      _$RuleSettingsImpl _value, $Res Function(_$RuleSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of RuleSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bypassChina = null,
    Object? bypassLan = null,
    Object? bypassPrivate = null,
    Object? customRules = null,
    Object? ruleProviders = null,
  }) {
    return _then(_$RuleSettingsImpl(
      bypassChina: null == bypassChina
          ? _value.bypassChina
          : bypassChina // ignore: cast_nullable_to_non_nullable
              as bool,
      bypassLan: null == bypassLan
          ? _value.bypassLan
          : bypassLan // ignore: cast_nullable_to_non_nullable
              as bool,
      bypassPrivate: null == bypassPrivate
          ? _value.bypassPrivate
          : bypassPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      customRules: null == customRules
          ? _value._customRules
          : customRules // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ruleProviders: null == ruleProviders
          ? _value._ruleProviders
          : ruleProviders // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RuleSettingsImpl implements _RuleSettings {
  const _$RuleSettingsImpl(
      {this.bypassChina = true,
      this.bypassLan = true,
      this.bypassPrivate = true,
      final List<String> customRules = const [],
      final List<String> ruleProviders = const []})
      : _customRules = customRules,
        _ruleProviders = ruleProviders;

  factory _$RuleSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RuleSettingsImplFromJson(json);

  /// 绕过中国大陆
  @override
  @JsonKey()
  final bool bypassChina;

  /// 绕过局域网
  @override
  @JsonKey()
  final bool bypassLan;

  /// 绕过私有网络
  @override
  @JsonKey()
  final bool bypassPrivate;

  /// 自定义规则列表
  final List<String> _customRules;

  /// 自定义规则列表
  @override
  @JsonKey()
  List<String> get customRules {
    if (_customRules is EqualUnmodifiableListView) return _customRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customRules);
  }

  /// 规则提供程序
  final List<String> _ruleProviders;

  /// 规则提供程序
  @override
  @JsonKey()
  List<String> get ruleProviders {
    if (_ruleProviders is EqualUnmodifiableListView) return _ruleProviders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ruleProviders);
  }

  @override
  String toString() {
    return 'RuleSettings(bypassChina: $bypassChina, bypassLan: $bypassLan, bypassPrivate: $bypassPrivate, customRules: $customRules, ruleProviders: $ruleProviders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RuleSettingsImpl &&
            (identical(other.bypassChina, bypassChina) ||
                other.bypassChina == bypassChina) &&
            (identical(other.bypassLan, bypassLan) ||
                other.bypassLan == bypassLan) &&
            (identical(other.bypassPrivate, bypassPrivate) ||
                other.bypassPrivate == bypassPrivate) &&
            const DeepCollectionEquality()
                .equals(other._customRules, _customRules) &&
            const DeepCollectionEquality()
                .equals(other._ruleProviders, _ruleProviders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      bypassChina,
      bypassLan,
      bypassPrivate,
      const DeepCollectionEquality().hash(_customRules),
      const DeepCollectionEquality().hash(_ruleProviders));

  /// Create a copy of RuleSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RuleSettingsImplCopyWith<_$RuleSettingsImpl> get copyWith =>
      __$$RuleSettingsImplCopyWithImpl<_$RuleSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RuleSettingsImplToJson(
      this,
    );
  }
}

abstract class _RuleSettings implements RuleSettings {
  const factory _RuleSettings(
      {final bool bypassChina,
      final bool bypassLan,
      final bool bypassPrivate,
      final List<String> customRules,
      final List<String> ruleProviders}) = _$RuleSettingsImpl;

  factory _RuleSettings.fromJson(Map<String, dynamic> json) =
      _$RuleSettingsImpl.fromJson;

  /// 绕过中国大陆
  @override
  bool get bypassChina;

  /// 绕过局域网
  @override
  bool get bypassLan;

  /// 绕过私有网络
  @override
  bool get bypassPrivate;

  /// 自定义规则列表
  @override
  List<String> get customRules;

  /// 规则提供程序
  @override
  List<String> get ruleProviders;

  /// Create a copy of RuleSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RuleSettingsImplCopyWith<_$RuleSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NodeSettings _$NodeSettingsFromJson(Map<String, dynamic> json) {
  return _NodeSettings.fromJson(json);
}

/// @nodoc
mixin _$NodeSettings {
  /// 当前选中节点ID
  String? get currentNodeId => throw _privateConstructorUsedError;

  /// 节点列表
  List<ProxyNode> get nodes => throw _privateConstructorUsedError;

  /// 自动选择延迟最低节点
  bool get autoSelect => throw _privateConstructorUsedError;

  /// 延迟测试URL
  String get latencyTestUrl => throw _privateConstructorUsedError;

  /// 节点排序方式
  NodeSortMode get sortMode => throw _privateConstructorUsedError;

  /// Serializes this NodeSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NodeSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NodeSettingsCopyWith<NodeSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeSettingsCopyWith<$Res> {
  factory $NodeSettingsCopyWith(
          NodeSettings value, $Res Function(NodeSettings) then) =
      _$NodeSettingsCopyWithImpl<$Res, NodeSettings>;
  @useResult
  $Res call(
      {String? currentNodeId,
      List<ProxyNode> nodes,
      bool autoSelect,
      String latencyTestUrl,
      NodeSortMode sortMode});
}

/// @nodoc
class _$NodeSettingsCopyWithImpl<$Res, $Val extends NodeSettings>
    implements $NodeSettingsCopyWith<$Res> {
  _$NodeSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NodeSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentNodeId = freezed,
    Object? nodes = null,
    Object? autoSelect = null,
    Object? latencyTestUrl = null,
    Object? sortMode = null,
  }) {
    return _then(_value.copyWith(
      currentNodeId: freezed == currentNodeId
          ? _value.currentNodeId
          : currentNodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      nodes: null == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<ProxyNode>,
      autoSelect: null == autoSelect
          ? _value.autoSelect
          : autoSelect // ignore: cast_nullable_to_non_nullable
              as bool,
      latencyTestUrl: null == latencyTestUrl
          ? _value.latencyTestUrl
          : latencyTestUrl // ignore: cast_nullable_to_non_nullable
              as String,
      sortMode: null == sortMode
          ? _value.sortMode
          : sortMode // ignore: cast_nullable_to_non_nullable
              as NodeSortMode,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NodeSettingsImplCopyWith<$Res>
    implements $NodeSettingsCopyWith<$Res> {
  factory _$$NodeSettingsImplCopyWith(
          _$NodeSettingsImpl value, $Res Function(_$NodeSettingsImpl) then) =
      __$$NodeSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? currentNodeId,
      List<ProxyNode> nodes,
      bool autoSelect,
      String latencyTestUrl,
      NodeSortMode sortMode});
}

/// @nodoc
class __$$NodeSettingsImplCopyWithImpl<$Res>
    extends _$NodeSettingsCopyWithImpl<$Res, _$NodeSettingsImpl>
    implements _$$NodeSettingsImplCopyWith<$Res> {
  __$$NodeSettingsImplCopyWithImpl(
      _$NodeSettingsImpl _value, $Res Function(_$NodeSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of NodeSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentNodeId = freezed,
    Object? nodes = null,
    Object? autoSelect = null,
    Object? latencyTestUrl = null,
    Object? sortMode = null,
  }) {
    return _then(_$NodeSettingsImpl(
      currentNodeId: freezed == currentNodeId
          ? _value.currentNodeId
          : currentNodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      nodes: null == nodes
          ? _value._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<ProxyNode>,
      autoSelect: null == autoSelect
          ? _value.autoSelect
          : autoSelect // ignore: cast_nullable_to_non_nullable
              as bool,
      latencyTestUrl: null == latencyTestUrl
          ? _value.latencyTestUrl
          : latencyTestUrl // ignore: cast_nullable_to_non_nullable
              as String,
      sortMode: null == sortMode
          ? _value.sortMode
          : sortMode // ignore: cast_nullable_to_non_nullable
              as NodeSortMode,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NodeSettingsImpl implements _NodeSettings {
  const _$NodeSettingsImpl(
      {this.currentNodeId,
      final List<ProxyNode> nodes = const [],
      this.autoSelect = false,
      this.latencyTestUrl = 'http://www.gstatic.com/generate_204',
      this.sortMode = NodeSortMode.latency})
      : _nodes = nodes;

  factory _$NodeSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NodeSettingsImplFromJson(json);

  /// 当前选中节点ID
  @override
  final String? currentNodeId;

  /// 节点列表
  final List<ProxyNode> _nodes;

  /// 节点列表
  @override
  @JsonKey()
  List<ProxyNode> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  /// 自动选择延迟最低节点
  @override
  @JsonKey()
  final bool autoSelect;

  /// 延迟测试URL
  @override
  @JsonKey()
  final String latencyTestUrl;

  /// 节点排序方式
  @override
  @JsonKey()
  final NodeSortMode sortMode;

  @override
  String toString() {
    return 'NodeSettings(currentNodeId: $currentNodeId, nodes: $nodes, autoSelect: $autoSelect, latencyTestUrl: $latencyTestUrl, sortMode: $sortMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeSettingsImpl &&
            (identical(other.currentNodeId, currentNodeId) ||
                other.currentNodeId == currentNodeId) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            (identical(other.autoSelect, autoSelect) ||
                other.autoSelect == autoSelect) &&
            (identical(other.latencyTestUrl, latencyTestUrl) ||
                other.latencyTestUrl == latencyTestUrl) &&
            (identical(other.sortMode, sortMode) ||
                other.sortMode == sortMode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentNodeId,
      const DeepCollectionEquality().hash(_nodes),
      autoSelect,
      latencyTestUrl,
      sortMode);

  /// Create a copy of NodeSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeSettingsImplCopyWith<_$NodeSettingsImpl> get copyWith =>
      __$$NodeSettingsImplCopyWithImpl<_$NodeSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NodeSettingsImplToJson(
      this,
    );
  }
}

abstract class _NodeSettings implements NodeSettings {
  const factory _NodeSettings(
      {final String? currentNodeId,
      final List<ProxyNode> nodes,
      final bool autoSelect,
      final String latencyTestUrl,
      final NodeSortMode sortMode}) = _$NodeSettingsImpl;

  factory _NodeSettings.fromJson(Map<String, dynamic> json) =
      _$NodeSettingsImpl.fromJson;

  /// 当前选中节点ID
  @override
  String? get currentNodeId;

  /// 节点列表
  @override
  List<ProxyNode> get nodes;

  /// 自动选择延迟最低节点
  @override
  bool get autoSelect;

  /// 延迟测试URL
  @override
  String get latencyTestUrl;

  /// 节点排序方式
  @override
  NodeSortMode get sortMode;

  /// Create a copy of NodeSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NodeSettingsImplCopyWith<_$NodeSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrafficSettings _$TrafficSettingsFromJson(Map<String, dynamic> json) {
  return _TrafficSettings.fromJson(json);
}

/// @nodoc
mixin _$TrafficSettings {
  /// 启用流量统计
  bool get enableStats => throw _privateConstructorUsedError;

  /// 启用实时速度监控
  bool get enableSpeed => throw _privateConstructorUsedError;

  /// 启用流量限制
  bool get enableLimit => throw _privateConstructorUsedError;

  /// 上传速度限制 (KB/s)
  int get uploadLimit => throw _privateConstructorUsedError;

  /// 下载速度限制 (KB/s)
  int get downloadLimit => throw _privateConstructorUsedError;

  /// 流量单位
  TrafficUnit get unit => throw _privateConstructorUsedError;

  /// 历史记录保留天数
  int get historyRetention => throw _privateConstructorUsedError;

  /// Serializes this TrafficSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrafficSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrafficSettingsCopyWith<TrafficSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrafficSettingsCopyWith<$Res> {
  factory $TrafficSettingsCopyWith(
          TrafficSettings value, $Res Function(TrafficSettings) then) =
      _$TrafficSettingsCopyWithImpl<$Res, TrafficSettings>;
  @useResult
  $Res call(
      {bool enableStats,
      bool enableSpeed,
      bool enableLimit,
      int uploadLimit,
      int downloadLimit,
      TrafficUnit unit,
      int historyRetention});
}

/// @nodoc
class _$TrafficSettingsCopyWithImpl<$Res, $Val extends TrafficSettings>
    implements $TrafficSettingsCopyWith<$Res> {
  _$TrafficSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrafficSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableStats = null,
    Object? enableSpeed = null,
    Object? enableLimit = null,
    Object? uploadLimit = null,
    Object? downloadLimit = null,
    Object? unit = null,
    Object? historyRetention = null,
  }) {
    return _then(_value.copyWith(
      enableStats: null == enableStats
          ? _value.enableStats
          : enableStats // ignore: cast_nullable_to_non_nullable
              as bool,
      enableSpeed: null == enableSpeed
          ? _value.enableSpeed
          : enableSpeed // ignore: cast_nullable_to_non_nullable
              as bool,
      enableLimit: null == enableLimit
          ? _value.enableLimit
          : enableLimit // ignore: cast_nullable_to_non_nullable
              as bool,
      uploadLimit: null == uploadLimit
          ? _value.uploadLimit
          : uploadLimit // ignore: cast_nullable_to_non_nullable
              as int,
      downloadLimit: null == downloadLimit
          ? _value.downloadLimit
          : downloadLimit // ignore: cast_nullable_to_non_nullable
              as int,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as TrafficUnit,
      historyRetention: null == historyRetention
          ? _value.historyRetention
          : historyRetention // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrafficSettingsImplCopyWith<$Res>
    implements $TrafficSettingsCopyWith<$Res> {
  factory _$$TrafficSettingsImplCopyWith(_$TrafficSettingsImpl value,
          $Res Function(_$TrafficSettingsImpl) then) =
      __$$TrafficSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enableStats,
      bool enableSpeed,
      bool enableLimit,
      int uploadLimit,
      int downloadLimit,
      TrafficUnit unit,
      int historyRetention});
}

/// @nodoc
class __$$TrafficSettingsImplCopyWithImpl<$Res>
    extends _$TrafficSettingsCopyWithImpl<$Res, _$TrafficSettingsImpl>
    implements _$$TrafficSettingsImplCopyWith<$Res> {
  __$$TrafficSettingsImplCopyWithImpl(
      _$TrafficSettingsImpl _value, $Res Function(_$TrafficSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrafficSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableStats = null,
    Object? enableSpeed = null,
    Object? enableLimit = null,
    Object? uploadLimit = null,
    Object? downloadLimit = null,
    Object? unit = null,
    Object? historyRetention = null,
  }) {
    return _then(_$TrafficSettingsImpl(
      enableStats: null == enableStats
          ? _value.enableStats
          : enableStats // ignore: cast_nullable_to_non_nullable
              as bool,
      enableSpeed: null == enableSpeed
          ? _value.enableSpeed
          : enableSpeed // ignore: cast_nullable_to_non_nullable
              as bool,
      enableLimit: null == enableLimit
          ? _value.enableLimit
          : enableLimit // ignore: cast_nullable_to_non_nullable
              as bool,
      uploadLimit: null == uploadLimit
          ? _value.uploadLimit
          : uploadLimit // ignore: cast_nullable_to_non_nullable
              as int,
      downloadLimit: null == downloadLimit
          ? _value.downloadLimit
          : downloadLimit // ignore: cast_nullable_to_non_nullable
              as int,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as TrafficUnit,
      historyRetention: null == historyRetention
          ? _value.historyRetention
          : historyRetention // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrafficSettingsImpl implements _TrafficSettings {
  const _$TrafficSettingsImpl(
      {this.enableStats = true,
      this.enableSpeed = true,
      this.enableLimit = false,
      this.uploadLimit = 0,
      this.downloadLimit = 0,
      this.unit = TrafficUnit.auto,
      this.historyRetention = 30});

  factory _$TrafficSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrafficSettingsImplFromJson(json);

  /// 启用流量统计
  @override
  @JsonKey()
  final bool enableStats;

  /// 启用实时速度监控
  @override
  @JsonKey()
  final bool enableSpeed;

  /// 启用流量限制
  @override
  @JsonKey()
  final bool enableLimit;

  /// 上传速度限制 (KB/s)
  @override
  @JsonKey()
  final int uploadLimit;

  /// 下载速度限制 (KB/s)
  @override
  @JsonKey()
  final int downloadLimit;

  /// 流量单位
  @override
  @JsonKey()
  final TrafficUnit unit;

  /// 历史记录保留天数
  @override
  @JsonKey()
  final int historyRetention;

  @override
  String toString() {
    return 'TrafficSettings(enableStats: $enableStats, enableSpeed: $enableSpeed, enableLimit: $enableLimit, uploadLimit: $uploadLimit, downloadLimit: $downloadLimit, unit: $unit, historyRetention: $historyRetention)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrafficSettingsImpl &&
            (identical(other.enableStats, enableStats) ||
                other.enableStats == enableStats) &&
            (identical(other.enableSpeed, enableSpeed) ||
                other.enableSpeed == enableSpeed) &&
            (identical(other.enableLimit, enableLimit) ||
                other.enableLimit == enableLimit) &&
            (identical(other.uploadLimit, uploadLimit) ||
                other.uploadLimit == uploadLimit) &&
            (identical(other.downloadLimit, downloadLimit) ||
                other.downloadLimit == downloadLimit) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.historyRetention, historyRetention) ||
                other.historyRetention == historyRetention));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, enableStats, enableSpeed,
      enableLimit, uploadLimit, downloadLimit, unit, historyRetention);

  /// Create a copy of TrafficSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrafficSettingsImplCopyWith<_$TrafficSettingsImpl> get copyWith =>
      __$$TrafficSettingsImplCopyWithImpl<_$TrafficSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrafficSettingsImplToJson(
      this,
    );
  }
}

abstract class _TrafficSettings implements TrafficSettings {
  const factory _TrafficSettings(
      {final bool enableStats,
      final bool enableSpeed,
      final bool enableLimit,
      final int uploadLimit,
      final int downloadLimit,
      final TrafficUnit unit,
      final int historyRetention}) = _$TrafficSettingsImpl;

  factory _TrafficSettings.fromJson(Map<String, dynamic> json) =
      _$TrafficSettingsImpl.fromJson;

  /// 启用流量统计
  @override
  bool get enableStats;

  /// 启用实时速度监控
  @override
  bool get enableSpeed;

  /// 启用流量限制
  @override
  bool get enableLimit;

  /// 上传速度限制 (KB/s)
  @override
  int get uploadLimit;

  /// 下载速度限制 (KB/s)
  @override
  int get downloadLimit;

  /// 流量单位
  @override
  TrafficUnit get unit;

  /// 历史记录保留天数
  @override
  int get historyRetention;

  /// Create a copy of TrafficSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrafficSettingsImplCopyWith<_$TrafficSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProxyCoreSettings _$ProxyCoreSettingsFromJson(Map<String, dynamic> json) {
  return _ProxyCoreSettings.fromJson(json);
}

/// @nodoc
mixin _$ProxyCoreSettings {
  /// 是否启用代理核心
  bool get enabled => throw _privateConstructorUsedError;

  /// 核心类型
  ProxyCoreType get coreType => throw _privateConstructorUsedError;

  /// 核心版本
  String get coreVersion => throw _privateConstructorUsedError;

  /// 核心路径
  String get corePath => throw _privateConstructorUsedError;

  /// 临时目录
  String get tempPath => throw _privateConstructorUsedError;

  /// 工作目录
  String get workingPath => throw _privateConstructorUsedError;

  /// 是否启用调试模式
  bool get debugMode => throw _privateConstructorUsedError;

  /// 是否自动重启
  bool get autoRestart => throw _privateConstructorUsedError;

  /// 重启间隔（秒）
  int get restartInterval => throw _privateConstructorUsedError;

  /// 最大重启次数
  int get maxRestartCount => throw _privateConstructorUsedError;

  /// 核心参数
  Map<String, String> get coreArgs => throw _privateConstructorUsedError;

  /// 环境变量
  Map<String, String> get environmentVars => throw _privateConstructorUsedError;

  /// Serializes this ProxyCoreSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProxyCoreSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProxyCoreSettingsCopyWith<ProxyCoreSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProxyCoreSettingsCopyWith<$Res> {
  factory $ProxyCoreSettingsCopyWith(
          ProxyCoreSettings value, $Res Function(ProxyCoreSettings) then) =
      _$ProxyCoreSettingsCopyWithImpl<$Res, ProxyCoreSettings>;
  @useResult
  $Res call(
      {bool enabled,
      ProxyCoreType coreType,
      String coreVersion,
      String corePath,
      String tempPath,
      String workingPath,
      bool debugMode,
      bool autoRestart,
      int restartInterval,
      int maxRestartCount,
      Map<String, String> coreArgs,
      Map<String, String> environmentVars});
}

/// @nodoc
class _$ProxyCoreSettingsCopyWithImpl<$Res, $Val extends ProxyCoreSettings>
    implements $ProxyCoreSettingsCopyWith<$Res> {
  _$ProxyCoreSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProxyCoreSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? coreType = null,
    Object? coreVersion = null,
    Object? corePath = null,
    Object? tempPath = null,
    Object? workingPath = null,
    Object? debugMode = null,
    Object? autoRestart = null,
    Object? restartInterval = null,
    Object? maxRestartCount = null,
    Object? coreArgs = null,
    Object? environmentVars = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      coreType: null == coreType
          ? _value.coreType
          : coreType // ignore: cast_nullable_to_non_nullable
              as ProxyCoreType,
      coreVersion: null == coreVersion
          ? _value.coreVersion
          : coreVersion // ignore: cast_nullable_to_non_nullable
              as String,
      corePath: null == corePath
          ? _value.corePath
          : corePath // ignore: cast_nullable_to_non_nullable
              as String,
      tempPath: null == tempPath
          ? _value.tempPath
          : tempPath // ignore: cast_nullable_to_non_nullable
              as String,
      workingPath: null == workingPath
          ? _value.workingPath
          : workingPath // ignore: cast_nullable_to_non_nullable
              as String,
      debugMode: null == debugMode
          ? _value.debugMode
          : debugMode // ignore: cast_nullable_to_non_nullable
              as bool,
      autoRestart: null == autoRestart
          ? _value.autoRestart
          : autoRestart // ignore: cast_nullable_to_non_nullable
              as bool,
      restartInterval: null == restartInterval
          ? _value.restartInterval
          : restartInterval // ignore: cast_nullable_to_non_nullable
              as int,
      maxRestartCount: null == maxRestartCount
          ? _value.maxRestartCount
          : maxRestartCount // ignore: cast_nullable_to_non_nullable
              as int,
      coreArgs: null == coreArgs
          ? _value.coreArgs
          : coreArgs // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      environmentVars: null == environmentVars
          ? _value.environmentVars
          : environmentVars // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProxyCoreSettingsImplCopyWith<$Res>
    implements $ProxyCoreSettingsCopyWith<$Res> {
  factory _$$ProxyCoreSettingsImplCopyWith(_$ProxyCoreSettingsImpl value,
          $Res Function(_$ProxyCoreSettingsImpl) then) =
      __$$ProxyCoreSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      ProxyCoreType coreType,
      String coreVersion,
      String corePath,
      String tempPath,
      String workingPath,
      bool debugMode,
      bool autoRestart,
      int restartInterval,
      int maxRestartCount,
      Map<String, String> coreArgs,
      Map<String, String> environmentVars});
}

/// @nodoc
class __$$ProxyCoreSettingsImplCopyWithImpl<$Res>
    extends _$ProxyCoreSettingsCopyWithImpl<$Res, _$ProxyCoreSettingsImpl>
    implements _$$ProxyCoreSettingsImplCopyWith<$Res> {
  __$$ProxyCoreSettingsImplCopyWithImpl(_$ProxyCoreSettingsImpl _value,
      $Res Function(_$ProxyCoreSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProxyCoreSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? coreType = null,
    Object? coreVersion = null,
    Object? corePath = null,
    Object? tempPath = null,
    Object? workingPath = null,
    Object? debugMode = null,
    Object? autoRestart = null,
    Object? restartInterval = null,
    Object? maxRestartCount = null,
    Object? coreArgs = null,
    Object? environmentVars = null,
  }) {
    return _then(_$ProxyCoreSettingsImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      coreType: null == coreType
          ? _value.coreType
          : coreType // ignore: cast_nullable_to_non_nullable
              as ProxyCoreType,
      coreVersion: null == coreVersion
          ? _value.coreVersion
          : coreVersion // ignore: cast_nullable_to_non_nullable
              as String,
      corePath: null == corePath
          ? _value.corePath
          : corePath // ignore: cast_nullable_to_non_nullable
              as String,
      tempPath: null == tempPath
          ? _value.tempPath
          : tempPath // ignore: cast_nullable_to_non_nullable
              as String,
      workingPath: null == workingPath
          ? _value.workingPath
          : workingPath // ignore: cast_nullable_to_non_nullable
              as String,
      debugMode: null == debugMode
          ? _value.debugMode
          : debugMode // ignore: cast_nullable_to_non_nullable
              as bool,
      autoRestart: null == autoRestart
          ? _value.autoRestart
          : autoRestart // ignore: cast_nullable_to_non_nullable
              as bool,
      restartInterval: null == restartInterval
          ? _value.restartInterval
          : restartInterval // ignore: cast_nullable_to_non_nullable
              as int,
      maxRestartCount: null == maxRestartCount
          ? _value.maxRestartCount
          : maxRestartCount // ignore: cast_nullable_to_non_nullable
              as int,
      coreArgs: null == coreArgs
          ? _value._coreArgs
          : coreArgs // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      environmentVars: null == environmentVars
          ? _value._environmentVars
          : environmentVars // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProxyCoreSettingsImpl extends _ProxyCoreSettings {
  const _$ProxyCoreSettingsImpl(
      {this.enabled = true,
      this.coreType = ProxyCoreType.clashMeta,
      this.coreVersion = '',
      this.corePath = '',
      this.tempPath = '',
      this.workingPath = '',
      this.debugMode = false,
      this.autoRestart = true,
      this.restartInterval = 300,
      this.maxRestartCount = 3,
      final Map<String, String> coreArgs = const {},
      final Map<String, String> environmentVars = const {}})
      : _coreArgs = coreArgs,
        _environmentVars = environmentVars,
        super._();

  factory _$ProxyCoreSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProxyCoreSettingsImplFromJson(json);

  /// 是否启用代理核心
  @override
  @JsonKey()
  final bool enabled;

  /// 核心类型
  @override
  @JsonKey()
  final ProxyCoreType coreType;

  /// 核心版本
  @override
  @JsonKey()
  final String coreVersion;

  /// 核心路径
  @override
  @JsonKey()
  final String corePath;

  /// 临时目录
  @override
  @JsonKey()
  final String tempPath;

  /// 工作目录
  @override
  @JsonKey()
  final String workingPath;

  /// 是否启用调试模式
  @override
  @JsonKey()
  final bool debugMode;

  /// 是否自动重启
  @override
  @JsonKey()
  final bool autoRestart;

  /// 重启间隔（秒）
  @override
  @JsonKey()
  final int restartInterval;

  /// 最大重启次数
  @override
  @JsonKey()
  final int maxRestartCount;

  /// 核心参数
  final Map<String, String> _coreArgs;

  /// 核心参数
  @override
  @JsonKey()
  Map<String, String> get coreArgs {
    if (_coreArgs is EqualUnmodifiableMapView) return _coreArgs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_coreArgs);
  }

  /// 环境变量
  final Map<String, String> _environmentVars;

  /// 环境变量
  @override
  @JsonKey()
  Map<String, String> get environmentVars {
    if (_environmentVars is EqualUnmodifiableMapView) return _environmentVars;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_environmentVars);
  }

  @override
  String toString() {
    return 'ProxyCoreSettings(enabled: $enabled, coreType: $coreType, coreVersion: $coreVersion, corePath: $corePath, tempPath: $tempPath, workingPath: $workingPath, debugMode: $debugMode, autoRestart: $autoRestart, restartInterval: $restartInterval, maxRestartCount: $maxRestartCount, coreArgs: $coreArgs, environmentVars: $environmentVars)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProxyCoreSettingsImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.coreType, coreType) ||
                other.coreType == coreType) &&
            (identical(other.coreVersion, coreVersion) ||
                other.coreVersion == coreVersion) &&
            (identical(other.corePath, corePath) ||
                other.corePath == corePath) &&
            (identical(other.tempPath, tempPath) ||
                other.tempPath == tempPath) &&
            (identical(other.workingPath, workingPath) ||
                other.workingPath == workingPath) &&
            (identical(other.debugMode, debugMode) ||
                other.debugMode == debugMode) &&
            (identical(other.autoRestart, autoRestart) ||
                other.autoRestart == autoRestart) &&
            (identical(other.restartInterval, restartInterval) ||
                other.restartInterval == restartInterval) &&
            (identical(other.maxRestartCount, maxRestartCount) ||
                other.maxRestartCount == maxRestartCount) &&
            const DeepCollectionEquality().equals(other._coreArgs, _coreArgs) &&
            const DeepCollectionEquality()
                .equals(other._environmentVars, _environmentVars));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      enabled,
      coreType,
      coreVersion,
      corePath,
      tempPath,
      workingPath,
      debugMode,
      autoRestart,
      restartInterval,
      maxRestartCount,
      const DeepCollectionEquality().hash(_coreArgs),
      const DeepCollectionEquality().hash(_environmentVars));

  /// Create a copy of ProxyCoreSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProxyCoreSettingsImplCopyWith<_$ProxyCoreSettingsImpl> get copyWith =>
      __$$ProxyCoreSettingsImplCopyWithImpl<_$ProxyCoreSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProxyCoreSettingsImplToJson(
      this,
    );
  }
}

abstract class _ProxyCoreSettings extends ProxyCoreSettings {
  const factory _ProxyCoreSettings(
      {final bool enabled,
      final ProxyCoreType coreType,
      final String coreVersion,
      final String corePath,
      final String tempPath,
      final String workingPath,
      final bool debugMode,
      final bool autoRestart,
      final int restartInterval,
      final int maxRestartCount,
      final Map<String, String> coreArgs,
      final Map<String, String> environmentVars}) = _$ProxyCoreSettingsImpl;
  const _ProxyCoreSettings._() : super._();

  factory _ProxyCoreSettings.fromJson(Map<String, dynamic> json) =
      _$ProxyCoreSettingsImpl.fromJson;

  /// 是否启用代理核心
  @override
  bool get enabled;

  /// 核心类型
  @override
  ProxyCoreType get coreType;

  /// 核心版本
  @override
  String get coreVersion;

  /// 核心路径
  @override
  String get corePath;

  /// 临时目录
  @override
  String get tempPath;

  /// 工作目录
  @override
  String get workingPath;

  /// 是否启用调试模式
  @override
  bool get debugMode;

  /// 是否自动重启
  @override
  bool get autoRestart;

  /// 重启间隔（秒）
  @override
  int get restartInterval;

  /// 最大重启次数
  @override
  int get maxRestartCount;

  /// 核心参数
  @override
  Map<String, String> get coreArgs;

  /// 环境变量
  @override
  Map<String, String> get environmentVars;

  /// Create a copy of ProxyCoreSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProxyCoreSettingsImplCopyWith<_$ProxyCoreSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
