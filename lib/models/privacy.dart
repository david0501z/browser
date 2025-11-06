/// 隐私设置模型
library privacy;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy.freezed.dart';
part 'privacy.g.dart';

@freezed
class Privacy with _$Privacy {
  const factory Privacy({
    /// 隐私模式
    @Default(false) bool privacyMode,
    
    /// 匿名模式
    @Default(false) bool anonymousMode,
    
    /// 数据加密
    @Default(true) bool dataEncryption,
    
    /// 本地数据加密
    @Default(false) bool localDataEncryption,
    
    /// 自动清理
    @Default(false) bool autoClean,
    
    /// 清理间隔（天）
    @Default(7) int cleanInterval,
    
    /// 遥测数据
    @Default(false) bool telemetry,
    
    /// 崩溃报告
    @Default(false) bool crashReporting,
  }) = _Privacy;
  
  const Privacy._();
  
  factory Privacy.fromJson(Map<String, Object?> json) => _$PrivacyFromJson(json);
}