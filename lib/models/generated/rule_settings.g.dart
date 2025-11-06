// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************/

_$RuleSettings _$$RuleSettingsFromJson(Map<String, dynamic> json) =>
    _$RuleSettings(
      customRules: json['customRules'] as bool? ?? false,
      rulePath: json['rulePath'] as String?,
      ruleType: RuleType.values.byName(json['ruleType'] as String),
      adBlock: json['adBlock'] as bool? ?? true,
      trackingBlock: json['trackingBlock'] as bool? ?? true,
    );

Map<String, dynamic> _$$RuleSettingsToJson(_$RuleSettings instance) =>
    <String, dynamic>{
      'customRules': instance.customRules,
      'rulePath': instance.rulePath,
      'ruleType': instance.ruleType.name,
      'adBlock': instance.adBlock,
      'trackingBlock': instance.trackingBlock,
    };
