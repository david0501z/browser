// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../privacy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************/

_$Privacy _$$PrivacyFromJson(Map<String, dynamic> json) => _$Privacy(
      privacyMode: json['privacyMode'] as bool? ?? false,
      anonymousMode: json['anonymousMode'] as bool? ?? false,
      dataEncryption: json['dataEncryption'] as bool? ?? true,
      localDataEncryption: json['localDataEncryption'] as bool? ?? false,
      autoClean: json['autoClean'] as bool? ?? false,
      cleanInterval: json['cleanInterval'] as int? ?? 7,
      telemetry: json['telemetry'] as bool? ?? false,
      crashReporting: json['crashReporting'] as bool? ?? false,
    );

Map<String, dynamic> _$$PrivacyToJson(_$Privacy instance) => <String, dynamic>{
      'privacyMode': instance.privacyMode,
      'anonymousMode': instance.anonymousMode,
      'dataEncryption': instance.dataEncryption,
      'localDataEncryption': instance.localDataEncryption,
      'autoClean': instance.autoClean,
      'cleanInterval': instance.cleanInterval,
      'telemetry': instance.telemetry,
      'crashReporting': instance.crashReporting,
    };
