// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../ui.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************/

_$UI _$$UIFromJson(Map<String, dynamic> json) => _$UI(
      themeMode: ThemeMode.values.byName(json['themeMode'] as String),
      language: json['language'] as String? ?? 'zh-CN',
      animations: json['animations'] as bool? ?? true,
      immersiveStatusBar: json['immersiveStatusBar'] as bool? ?? true,
      immersiveNavigationBar: json['immersiveNavigationBar'] as bool? ?? true,
      safeAreaBottom: json['safeAreaBottom'] as bool? ?? true,
      fontSize: FontSize.values.byName(json['fontSize'] as String),
      fontWeight: FontWeight.values.byName(json['fontWeight'] as String),
      highContrast: json['highContrast'] as bool? ?? false,
      boldLabels: json['boldLabels'] as bool? ?? false,
    );

Map<String, dynamic> _$$UIToJson(_$UI instance) => <String, dynamic>{
      'themeMode': instance.themeMode.name,
      'language': instance.language,
      'animations': instance.animations,
      'immersiveStatusBar': instance.immersiveStatusBar,
      'immersiveNavigationBar': instance.immersiveNavigationBar,
      'safeAreaBottom': instance.safeAreaBottom,
      'fontSize': instance.fontSize.name,
      'fontWeight': instance.fontWeight.name,
      'highContrast': instance.highContrast,
      'boldLabels': instance.boldLabels,
    };
