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
mixin _$Backup {
  bool get autoBackup => throw _privateConstructorUsedError;
  int get backupInterval => throw _privateConstructorUsedError;
  bool get cloudBackup => throw _privateConstructorUsedError;
  CloudService get cloudService => throw _privateConstructorUsedError;
  bool get backupEncryption => throw _privateConstructorUsedError;
  int get keepCount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
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

  // ignore: unused_element
  final $Val _value;
  // ignore: unused_element
  final $Res Function($Val) _then;

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
      autoBackup: null == autoBackup ? _value.autoBackup : autoBackup as bool,
      backupInterval: null == backupInterval
          ? _value.backupInterval
          : backupInterval as int,
      cloudBackup: null == cloudBackup ? _value.cloudBackup : cloudBackup as bool,
      cloudService: null == cloudService
          ? _value.cloudService
          : cloudService as CloudService,
      backupEncryption: null == backupEncryption
          ? _value.backupEncryption
          : backupEncryption as bool,
      keepCount: null == keepCount ? _value.keepCount : keepCount as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BackupCopyWith<$Res> implements $BackupCopyWith<$Res> {
  factory _$$BackupCopyWith(_$Backup value, $Res Function(_$Backup) then) =
      __$$BackupCopyWithImpl<$Res>;
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
class __$$BackupCopyWithImpl<$Res>
    extends _$BackupCopyWithImpl<$Res, _$Backup>
    implements _$$BackupCopyWith<$Res> {
  __$$BackupCopyWithImpl(_$Backup _value, $Res Function(_$Backup) _then)
      : super(_value, _then);

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
    return _then(_$Backup(
      autoBackup: null == autoBackup ? _value.autoBackup : autoBackup as bool,
      backupInterval: null == backupInterval
          ? _value.backupInterval
          : backupInterval as int,
      cloudBackup: null == cloudBackup ? _value.cloudBackup : cloudBackup as bool,
      cloudService: null == cloudService
          ? _value.cloudService
          : cloudService as CloudService,
      backupEncryption: null == backupEncryption
          ? _value.backupEncryption
          : backupEncryption as bool,
      keepCount: null == keepCount ? _value.keepCount : keepCount as int,
    ));
  }
}

/// @nodoc

class _$Backup extends _Backup {
  const _$Backup(
      {this.autoBackup = false,
      this.backupInterval = 7,
      this.cloudBackup = false,
      this.cloudService = CloudService.none,
      this.backupEncryption = true,
      this.keepCount = 5})
      : super._();

  @override
  final bool autoBackup;
  @override
  final int backupInterval;
  @override
  final bool cloudBackup;
  @override
  final CloudService cloudService;
  @override
  final bool backupEncryption;
  @override
  final int keepCount;

  @override
  String toString() {
    return 'Backup(autoBackup: $autoBackup, backupInterval: $backupInterval, cloudBackup: $cloudBackup, cloudService: $cloudService, backupEncryption: $backupEncryption, keepCount: $keepCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Backup &&
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

  @override
  int get hashCode => Object.hash(
      runtimeType,
      autoBackup,
      backupInterval,
      cloudBackup,
      cloudService,
      backupEncryption,
      keepCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BackupCopyWith<_$Backup> get copyWith =>
      __$$BackupCopyWithImpl<_$Backup>(this, _$identity);
}

abstract class _Backup extends Backup {
  const factory _Backup(
      {final bool autoBackup,
      final int backupInterval,
      final bool cloudBackup,
      final CloudService cloudService,
      final bool backupEncryption,
      final int keepCount}) = _$Backup;
  const _Backup._() : super._();

  @override
  bool get autoBackup;
  @override
  int get backupInterval;
  @override
  bool get cloudBackup;
  @override
  CloudService get cloudService;
  @override
  bool get backupEncryption;
  @override
  int get keepCount;
  @override
  @JsonKey(ignore: true)
  _$$BackupCopyWith<_$Backup> get copyWith;
}
