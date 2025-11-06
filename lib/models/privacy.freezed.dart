// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Privacy _$PrivacyFromJson(Map<String, dynamic> json) {
  return _Privacy.fromJson(json);
}

/// @nodoc
mixin _$Privacy {
  /// 隐私模式
  bool get privacyMode => throw _privateConstructorUsedError;

  /// 匿名模式
  bool get anonymousMode => throw _privateConstructorUsedError;

  /// 数据加密
  bool get dataEncryption => throw _privateConstructorUsedError;

  /// 本地数据加密
  bool get localDataEncryption => throw _privateConstructorUsedError;

  /// 自动清理
  bool get autoClean => throw _privateConstructorUsedError;

  /// 清理间隔（天）
  int get cleanInterval => throw _privateConstructorUsedError;

  /// 遥测数据
  bool get telemetry => throw _privateConstructorUsedError;

  /// 崩溃报告
  bool get crashReporting => throw _privateConstructorUsedError;

  /// Serializes this Privacy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Privacy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
    Object? anonymousMode = null,
    Object? dataEncryption = null,
    Object? localDataEncryption = null,
    Object? autoClean = null,
    Object? cleanInterval = null,
    Object? telemetry = null,
    Object? crashReporting = null,
  }) {
    return _then(_value.copyWith(
      privacyMode: null == privacyMode;
          ? _value.privacyMode
          : privacyMode // ignore: cast_nullable_to_non_nullable
              as bool,
      anonymousMode: null == anonymousMode;
          ? _value.anonymousMode
          : anonymousMode // ignore: cast_nullable_to_non_nullable
              as bool,
      dataEncryption: null == dataEncryption;
          ? _value.dataEncryption
          : dataEncryption // ignore: cast_nullable_to_non_nullable
              as bool,
      localDataEncryption: null == localDataEncryption;
          ? _value.localDataEncryption
          : localDataEncryption // ignore: cast_nullable_to_non_nullable
              as bool,
      autoClean: null == autoClean;
          ? _value.autoClean
          : autoClean // ignore: cast_nullable_to_non_nullable
              as bool,
      cleanInterval: null == cleanInterval;
          ? _value.cleanInterval
          : cleanInterval // ignore: cast_nullable_to_non_nullable
              as int,
      telemetry: null == telemetry;
          ? _value.telemetry
          : telemetry // ignore: cast_nullable_to_non_nullable
              as bool,
      crashReporting: null == crashReporting;
          ? _value.crashReporting
          : crashReporting // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivacyImplCopyWith<$Res> implements $PrivacyCopyWith<$Res> {
  factory _$$PrivacyImplCopyWith(
          _$PrivacyImpl value, $Res Function(_$PrivacyImpl) then) =;
      __$$PrivacyImplCopyWithImpl<$Res>;
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
    Object? anonymousMode = null,
    Object? dataEncryption = null,
    Object? localDataEncryption = null,
    Object? autoClean = null,
    Object? cleanInterval = null,
    Object? telemetry = null,
    Object? crashReporting = null,
  }) {
    return _then(_$PrivacyImpl(
      privacyMode: null == privacyMode;
          ? _value.privacyMode
          : privacyMode // ignore: cast_nullable_to_non_nullable
              as bool,
      anonymousMode: null == anonymousMode;
          ? _value.anonymousMode
          : anonymousMode // ignore: cast_nullable_to_non_nullable
              as bool,
      dataEncryption: null == dataEncryption;
          ? _value.dataEncryption
          : dataEncryption // ignore: cast_nullable_to_non_nullable
              as bool,
      localDataEncryption: null == localDataEncryption;
          ? _value.localDataEncryption
          : localDataEncryption // ignore: cast_nullable_to_non_nullable
              as bool,
      autoClean: null == autoClean;
          ? _value.autoClean
          : autoClean // ignore: cast_nullable_to_non_nullable
              as bool,
      cleanInterval: null == cleanInterval;
          ? _value.cleanInterval
          : cleanInterval // ignore: cast_nullable_to_non_nullable
              as int,
      telemetry: null == telemetry;
          ? _value.telemetry
          : telemetry // ignore: cast_nullable_to_non_nullable
              as bool,
      crashReporting: null == crashReporting;
          ? _value.crashReporting
          : crashReporting // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivacyImpl extends _Privacy {
  const _$PrivacyImpl(
      {this.privacyMode = false,
      this.anonymousMode = false,
      this.dataEncryption = true,
      this.localDataEncryption = false,
      this.autoClean = false,
      this.cleanInterval = 7,
      this.telemetry = false,
      this.crashReporting = false});
      : super._();

  factory _$PrivacyImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacyImplFromJson(json);

  /// 隐私模式
  @override
  @JsonKey()
  final bool privacyMode;

  /// 匿名模式
  @override
  @JsonKey()
  final bool anonymousMode;

  /// 数据加密
  @override
  @JsonKey()
  final bool dataEncryption;

  /// 本地数据加密
  @override
  @JsonKey()
  final bool localDataEncryption;

  /// 自动清理
  @override
  @JsonKey()
  final bool autoClean;

  /// 清理间隔（天）
  @override
  @JsonKey()
  final int cleanInterval;

  /// 遥测数据
  @override
  @JsonKey()
  final bool telemetry;

  /// 崩溃报告
  @override
  @JsonKey()
  final bool crashReporting;

  @override
  String toString() {
    return 'Privacy(privacyMode: $privacyMode, anonymousMode: $anonymousMode, dataEncryption: $dataEncryption, localDataEncryption: $localDataEncryption, autoClean: $autoClean, cleanInterval: $cleanInterval, telemetry: $telemetry, crashReporting: $crashReporting)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacyImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

abstract class _Privacy extends Privacy {
  const factory _Privacy(
      {final bool privacyMode,
      final bool anonymousMode,
      final bool dataEncryption,
      final bool localDataEncryption,
      final bool autoClean,
      final int cleanInterval,
      final bool telemetry,
      final bool crashReporting}) = _$PrivacyImpl;
  const _Privacy._() : super._();

  factory _Privacy.fromJson(Map<String, dynamic> json) = _$PrivacyImpl.fromJson;

  /// 隐私模式
  @override
  bool get privacyMode;

  /// 匿名模式
  @override
  bool get anonymousMode;

  /// 数据加密
  @override
  bool get dataEncryption;

  /// 本地数据加密
  @override
  bool get localDataEncryption;

  /// 自动清理
  @override
  bool get autoClean;

  /// 清理间隔（天）
  @override
  int get cleanInterval;

  /// 遥测数据
  @override
  bool get telemetry;

  /// 崩溃报告
  @override
  bool get crashReporting;

  /// Create a copy of Privacy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrivacyImplCopyWith<_$PrivacyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
