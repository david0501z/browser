// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../backup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************/

_$Backup _$$BackupFromJson(Map<String, dynamic> json) => _$Backup(
      autoBackup: json['autoBackup'] as bool? ?? false,
      backupInterval: json['backupInterval'] as int? ?? 7,
      cloudBackup: json['cloudBackup'] as bool? ?? false,
      cloudService: CloudService.values.byName(json['cloudService'] as String),
      backupEncryption: json['backupEncryption'] as bool? ?? true,
      keepCount: json['keepCount'] as int? ?? 5,
    );

Map<String, dynamic> _$$BackupToJson(_$Backup instance) => <String, dynamic>{
      'autoBackup': instance.autoBackup,
      'backupInterval': instance.backupInterval,
      'cloudBackup': instance.cloudBackup,
      'cloudService': instance.cloudService.name,
      'backupEncryption': instance.backupEncryption,
      'keepCount': instance.keepCount,
    };
