// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Backup _$BackupFromJson(Map<String, dynamic> json) {
  return _Backup.fromJson(json);
}

/// @nodoc
mixin _$Backup {
  /// 自动备份
  bool get autoBackup => throw _privateConstructorUsedError;

  /// 备份间隔（天）
  int get backupInterval => throw _privateConstructorUsedError;

  /// 云备份
  bool get cloudBackup => throw _privateConstructorUsedError;

  /// 云服务类型
  CloudService get cloudService => throw _privateConstructorUsedError;

  /// 备份加密
  bool get backupEncryption => throw _privateConstructorUsedError;

  /// 保留数量
  int get keepCount => throw _privateConstructorUsedError;

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
      bool cloudBackup,
      CloudService cloudService,
      bool backupEncryption,
      int keepCount});
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
    Object? cloudBackup = null,
    Object? cloudService = null,
    Object? backupEncryption = null,
    Object? keepCount = null,
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
      cloudBackup: null == cloudBackup
          ? _value.cloudBackup
          : cloudBackup // ignore: cast_nullable_to_non_nullable
              as bool,
      cloudService: null == cloudService
          ? _value.cloudService
          : cloudService // ignore: cast_nullable_to_non_nullable
              as CloudService,
      backupEncryption: null == backupEncryption
          ? _value.backupEncryption
          : backupEncryption // ignore: cast_nullable_to_non_nullable
              as bool,
      keepCount: null == keepCount
          ? _value.keepCount
          : keepCount // ignore: cast_nullable_to_non_nullable
              as int,
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
      bool cloudBackup,
      CloudService cloudService,
      bool backupEncryption,
      int keepCount});
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
    Object? cloudBackup = null,
    Object? cloudService = null,
    Object? backupEncryption = null,
    Object? keepCount = null,
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
      cloudBackup: null == cloudBackup
          ? _value.cloudBackup
          : cloudBackup // ignore: cast_nullable_to_non_nullable
              as bool,
      cloudService: null == cloudService
          ? _value.cloudService
          : cloudService // ignore: cast_nullable_to_non_nullable
              as CloudService,
      backupEncryption: null == backupEncryption
          ? _value.backupEncryption
          : backupEncryption // ignore: cast_nullable_to_non_nullable
              as bool,
      keepCount: null == keepCount
          ? _value.keepCount
          : keepCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BackupImpl extends _Backup {
  const _$BackupImpl(
      {this.autoBackup = false,
      this.backupInterval = 7,
      this.cloudBackup = false,
      this.cloudService = CloudService.aliyun,
      this.backupEncryption = true,
      this.keepCount = 5})
      : super._();

  factory _$BackupImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackupImplFromJson(json);

  /// 自动备份
  @override
  @JsonKey()
  final bool autoBackup;

  /// 备份间隔（天）
  @override
  @JsonKey()
  final int backupInterval;

  /// 云备份
  @override
  @JsonKey()
  final bool cloudBackup;

  /// 云服务类型
  @override
  @JsonKey()
  final CloudService cloudService;

  /// 备份加密
  @override
  @JsonKey()
  final bool backupEncryption;

  /// 保留数量
  @override
  @JsonKey()
  final int keepCount;

  @override
  String toString() {
    return 'Backup(autoBackup: $autoBackup, backupInterval: $backupInterval, cloudBackup: $cloudBackup, cloudService: $cloudService, backupEncryption: $backupEncryption, keepCount: $keepCount)';
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
            (identical(other.cloudBackup, cloudBackup) ||
                other.cloudBackup == cloudBackup) &&
            (identical(other.cloudService, cloudService) ||
                other.cloudService == cloudService) &&
            (identical(other.backupEncryption, backupEncryption) ||
                other.backupEncryption == backupEncryption) &&
            (identical(other.keepCount, keepCount) ||
                other.keepCount == keepCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, autoBackup, backupInterval,
      cloudBackup, cloudService, backupEncryption, keepCount);

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

abstract class _Backup extends Backup {
  const factory _Backup(
      {final bool autoBackup,
      final int backupInterval,
      final bool cloudBackup,
      final CloudService cloudService,
      final bool backupEncryption,
      final int keepCount}) = _$BackupImpl;
  const _Backup._() : super._();

  factory _Backup.fromJson(Map<String, dynamic> json) = _$BackupImpl.fromJson;

  /// 自动备份
  @override
  bool get autoBackup;

  /// 备份间隔（天）
  @override
  int get backupInterval;

  /// 云备份
  @override
  bool get cloudBackup;

  /// 云服务类型
  @override
  CloudService get cloudService;

  /// 备份加密
  @override
  bool get backupEncryption;

  /// 保留数量
  @override
  int get keepCount;

  /// Create a copy of Backup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackupImplCopyWith<_$BackupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
