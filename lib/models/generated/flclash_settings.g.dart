// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************/

_$FlClashSettings _$$FlClashSettingsFromJson(Map<String, dynamic> json) =>
    _$FlClashSettings(
      enabled: json['enabled'] as bool? ?? false,
      mode: ProxyMode.values.byName(json['mode'] as String),
      coreVersion: json['coreVersion'] as String? ?? '',
      configPath: json['configPath'] as String?,
      logLevel: LogLevel.values.byName(json['logLevel'] as String),
      autoUpdate: json['autoUpdate'] as bool? ?? true,
      ipv6: json['ipv6'] as bool? ?? false,
      tunMode: json['tunMode'] as bool? ?? false,
      mixedMode: json['mixedMode'] as bool? ?? false,
      systemProxy: json['systemProxy'] as bool? ?? false,
      lanShare: json['lanShare'] as bool? ?? false,
      dnsForward: json['dnsForward'] as bool? ?? false,
      ports: PortSettings.fromJson(json['ports'] as Map<String, dynamic>),
      dns: DNSSettings.fromJson(json['dns'] as Map<String, dynamic>),
      rules: RuleSettings.fromJson(json['rules'] as Map<String, dynamic>),
      nodes: NodeSettings.fromJson(json['nodes'] as Map<String, dynamic>),
      traffic: TrafficSettings.fromJson(json['traffic'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FlClashSettingsToJson(_$FlClashSettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'mode': instance.mode.name,
      'coreVersion': instance.coreVersion,
      'configPath': instance.configPath,
      'logLevel': instance.logLevel.name,
      'autoUpdate': instance.autoUpdate,
      'ipv6': instance.ipv6,
      'tunMode': instance.tunMode,
      'mixedMode': instance.mixedMode,
      'systemProxy': instance.systemProxy,
      'lanShare': instance.lanShare,
      'dnsForward': instance.dnsForward,
      'ports': instance.ports.toJson(),
      'dns': instance.dns.toJson(),
      'rules': instance.rules.toJson(),
      'nodes': instance.nodes.toJson(),
      'traffic': instance.traffic.toJson(),
    };
