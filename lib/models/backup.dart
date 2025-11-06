/// 备份设置模型
library backup;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'backup.freezed.dart';
part 'backup.g.dart';

@freezed
class Backup with _$Backup {
  const factory Backup({
    /// 自动备份
    @Default(false) bool autoBackup,
    
    /// 备份间隔（天）
    @Default(7) int backupInterval,
    
    /// 云备份
    @Default(false) bool cloudBackup,
    
    /// 云服务类型
    @Default(CloudService.aliyun) CloudService cloudService,
    
    /// 备份加密
    @Default(true) bool backupEncryption,
    
    /// 保留数量
    @Default(5) int keepCount,
  }) = _Backup;
  
  const Backup._();
  
  factory Backup.fromJson(Map<String, Object?> json) => _$BackupFromJson(json);
}