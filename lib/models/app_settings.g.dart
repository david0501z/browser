// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      version: json['version'] as String? ?? '1.0.0',
      createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
      mode: $enumDecodeNullable(_$SettingsModeEnumMap, json['mode']) ??
          SettingsMode.standard,
      browserSettings: json['browserSettings'] == null
          ? const BrowserSettings()
          : BrowserSettings.fromJson(
              json['browserSettings'] as Map<String, dynamic>),
      flclashSettings: json['flclashSettings'] == null
          ? const FlClashSettings()
          : FlClashSettings.fromJson(
              json['flclashSettings'] as Map<String, dynamic>),
      ui: json['ui'] == null
          ? const UI()
          : UI.fromJson(json['ui'] as Map<String, dynamic>),
      notifications: json['notifications'] == null
          ? const Notifications()
          : Notifications.fromJson(
              json['notifications'] as Map<String, dynamic>),
      privacy: json['privacy'] == null
          ? const Privacy()
          : Privacy.fromJson(json['privacy'] as Map<String, dynamic>),
      backup: json['backup'] == null
          ? const Backup()
          : Backup.fromJson(json['backup'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'mode': _$SettingsModeEnumMap[instance.mode]!,
      'browserSettings': instance.browserSettings,
      'flclashSettings': instance.flclashSettings,
      'ui': instance.ui,
      'notifications': instance.notifications,
      'privacy': instance.privacy,
      'backup': instance.backup,
    };

const _$SettingsModeEnumMap = {
  SettingsMode.standard: 'standard',
  SettingsMode.privacy: 'privacy',
  SettingsMode.developer: 'developer',
  SettingsMode.performance: 'performance',
  SettingsMode.custom: 'custom',
};

_$UIImpl _$$UIImplFromJson(Map<String, dynamic> json) => _$UIImpl(
      themeMode: json['themeMode'] as String? ?? 'system',
      language: json['language'] as String? ?? 'zh-CN',
      animations: json['animations'] as bool? ?? true,
      fontSize: (json['fontSize'] as num?)?.toInt() ?? 16,
      darkMode: json['darkMode'] as bool? ?? false,
    );

Map<String, dynamic> _$$UIImplToJson(_$UIImpl instance) => <String, dynamic>{
      'themeMode': instance.themeMode,
      'language': instance.language,
      'animations': instance.animations,
      'fontSize': instance.fontSize,
      'darkMode': instance.darkMode,
    };

_$NotificationsImpl _$$NotificationsImplFromJson(Map<String, dynamic> json) =>
    _$NotificationsImpl(
      enabled: json['enabled'] as bool? ?? true,
      connectionNotifications: json['connectionNotifications'] as bool? ?? true,
      updateNotifications: json['updateNotifications'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$$NotificationsImplToJson(_$NotificationsImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'connectionNotifications': instance.connectionNotifications,
      'updateNotifications': instance.updateNotifications,
      'soundEnabled': instance.soundEnabled,
    };

_$PrivacyImpl _$$PrivacyImplFromJson(Map<String, dynamic> json) =>
    _$PrivacyImpl(
      privacyMode: json['privacyMode'] as bool? ?? false,
      dataEncryption: json['dataEncryption'] as bool? ?? true,
      telemetry: json['telemetry'] as bool? ?? false,
      autoClearHistory: json['autoClearHistory'] as bool? ?? false,
    );

Map<String, dynamic> _$$PrivacyImplToJson(_$PrivacyImpl instance) =>
    <String, dynamic>{
      'privacyMode': instance.privacyMode,
      'dataEncryption': instance.dataEncryption,
      'telemetry': instance.telemetry,
      'autoClearHistory': instance.autoClearHistory,
    };

_$BackupImpl _$$BackupImplFromJson(Map<String, dynamic> json) => _$BackupImpl(
      autoBackup: json['autoBackup'] as bool? ?? false,
      backupInterval: (json['backupInterval'] as num?)?.toInt() ?? 7,
      keepBackups: (json['keepBackups'] as num?)?.toInt() ?? 5,
      backupPath: json['backupPath'] as String?,
    );

Map<String, dynamic> _$$BackupImplToJson(_$BackupImpl instance) =>
    <String, dynamic>{
      'autoBackup': instance.autoBackup,
      'backupInterval': instance.backupInterval,
      'keepBackups': instance.keepBackups,
      'backupPath': instance.backupPath,
    };

_$FlClashSettingsImpl _$$FlClashSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$FlClashSettingsImpl(
      enabled: json['enabled'] as bool? ?? false,
      mode: $enumDecodeNullable(_$ProxyModeEnumMap, json['mode']) ??
          ProxyMode.rule,
      coreVersion: json['coreVersion'] as String? ?? '',
      configPath: json['configPath'] as String?,
      logLevel: $enumDecodeNullable(_$LogLevelEnumMap, json['logLevel']) ??
          LogLevel.info,
      autoUpdate: json['autoUpdate'] as bool? ?? true,
      ipv6: json['ipv6'] as bool? ?? false,
      tunMode: json['tunMode'] as bool? ?? false,
      mixedMode: json['mixedMode'] as bool? ?? false,
      systemProxy: json['systemProxy'] as bool? ?? false,
      lanShare: json['lanShare'] as bool? ?? false,
      dnsForward: json['dnsForward'] as bool? ?? false,
      ports: json['ports'] == null
          ? const PortSettings()
          : PortSettings.fromJson(json['ports'] as Map<String, dynamic>),
      dns: json['dns'] == null
          ? const DNSSettings()
          : DNSSettings.fromJson(json['dns'] as Map<String, dynamic>),
      rules: json['rules'] == null
          ? const RuleSettings()
          : RuleSettings.fromJson(json['rules'] as Map<String, dynamic>),
      nodes: json['nodes'] == null
          ? const NodeSettings()
          : NodeSettings.fromJson(json['nodes'] as Map<String, dynamic>),
      traffic: json['traffic'] == null
          ? const TrafficSettings()
          : TrafficSettings.fromJson(json['traffic'] as Map<String, dynamic>),
      proxyCoreSettings: json['proxyCoreSettings'] == null
          ? null
          : ProxyCoreSettings.fromJson(
              json['proxyCoreSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FlClashSettingsImplToJson(
        _$FlClashSettingsImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'mode': _$ProxyModeEnumMap[instance.mode]!,
      'coreVersion': instance.coreVersion,
      'configPath': instance.configPath,
      'logLevel': _$LogLevelEnumMap[instance.logLevel]!,
      'autoUpdate': instance.autoUpdate,
      'ipv6': instance.ipv6,
      'tunMode': instance.tunMode,
      'mixedMode': instance.mixedMode,
      'systemProxy': instance.systemProxy,
      'lanShare': instance.lanShare,
      'dnsForward': instance.dnsForward,
      'ports': instance.ports,
      'dns': instance.dns,
      'rules': instance.rules,
      'nodes': instance.nodes,
      'traffic': instance.traffic,
      'proxyCoreSettings': instance.proxyCoreSettings,
    };

const _$ProxyModeEnumMap = {
  ProxyMode.rule: 'rule',
  ProxyMode.global: 'global',
  ProxyMode.direct: 'direct',
};

const _$LogLevelEnumMap = {
  LogLevel.debug: 'debug',
  LogLevel.info: 'info',
  LogLevel.warning: 'warning',
  LogLevel.error: 'error',
};

_$PortSettingsImpl _$$PortSettingsImplFromJson(Map<String, dynamic> json) =>
    _$PortSettingsImpl(
      httpPort: (json['httpPort'] as num?)?.toInt() ?? 7890,
      httpsPort: (json['httpsPort'] as num?)?.toInt() ?? 7891,
      socksPort: (json['socksPort'] as num?)?.toInt() ?? 7892,
      mixedPort: (json['mixedPort'] as num?)?.toInt() ?? 7893,
      allowLan: json['allowLan'] as bool? ?? true,
      lanOnly: json['lanOnly'] as bool? ?? false,
    );

Map<String, dynamic> _$$PortSettingsImplToJson(_$PortSettingsImpl instance) =>
    <String, dynamic>{
      'httpPort': instance.httpPort,
      'httpsPort': instance.httpsPort,
      'socksPort': instance.socksPort,
      'mixedPort': instance.mixedPort,
      'allowLan': instance.allowLan,
      'lanOnly': instance.lanOnly,
    };

_$DNSSettingsImpl _$$DNSSettingsImplFromJson(Map<String, dynamic> json) =>
    _$DNSSettingsImpl(
      primary: json['primary'] as String? ?? '1.1.1.1',
      secondary: json['secondary'] as String? ?? '8.8.8.8',
      doh: json['doh'] as bool? ?? false,
      dohUrl:
          json['dohUrl'] as String? ?? 'https://cloudflare-dns.com/dns-query',
      bypassChina: json['bypassChina'] as bool? ?? true,
    );

Map<String, dynamic> _$$DNSSettingsImplToJson(_$DNSSettingsImpl instance) =>
    <String, dynamic>{
      'primary': instance.primary,
      'secondary': instance.secondary,
      'doh': instance.doh,
      'dohUrl': instance.dohUrl,
      'bypassChina': instance.bypassChina,
    };

_$RuleSettingsImpl _$$RuleSettingsImplFromJson(Map<String, dynamic> json) =>
    _$RuleSettingsImpl(
      bypassChina: json['bypassChina'] as bool? ?? true,
      bypassLan: json['bypassLan'] as bool? ?? true,
      bypassPrivate: json['bypassPrivate'] as bool? ?? true,
      customRules: (json['customRules'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      ruleProviders: (json['ruleProviders'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RuleSettingsImplToJson(_$RuleSettingsImpl instance) =>
    <String, dynamic>{
      'bypassChina': instance.bypassChina,
      'bypassLan': instance.bypassLan,
      'bypassPrivate': instance.bypassPrivate,
      'customRules': instance.customRules,
      'ruleProviders': instance.ruleProviders,
    };

_$NodeSettingsImpl _$$NodeSettingsImplFromJson(Map<String, dynamic> json) =>
    _$NodeSettingsImpl(
      currentNodeId: json['currentNodeId'] as String?,
      nodes: (json['nodes'] as List<dynamic>?)
              ?.map((e) => ProxyNode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      autoSelect: json['autoSelect'] as bool? ?? false,
      latencyTestUrl: json['latencyTestUrl'] as String? ??
          'http://www.gstatic.com/generate_204',
      sortMode: $enumDecodeNullable(_$NodeSortModeEnumMap, json['sortMode']) ??
          NodeSortMode.latency,
    );

Map<String, dynamic> _$$NodeSettingsImplToJson(_$NodeSettingsImpl instance) =>
    <String, dynamic>{
      'currentNodeId': instance.currentNodeId,
      'nodes': instance.nodes,
      'autoSelect': instance.autoSelect,
      'latencyTestUrl': instance.latencyTestUrl,
      'sortMode': _$NodeSortModeEnumMap[instance.sortMode]!,
    };

const _$NodeSortModeEnumMap = {
  NodeSortMode.latency: 'latency',
  NodeSortMode.name: 'name',
  NodeSortMode.region: 'region',
  NodeSortMode.speed: 'speed',
};

_$TrafficSettingsImpl _$$TrafficSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$TrafficSettingsImpl(
      enableStats: json['enableStats'] as bool? ?? true,
      enableSpeed: json['enableSpeed'] as bool? ?? true,
      enableLimit: json['enableLimit'] as bool? ?? false,
      uploadLimit: (json['uploadLimit'] as num?)?.toInt() ?? 0,
      downloadLimit: (json['downloadLimit'] as num?)?.toInt() ?? 0,
      unit: $enumDecodeNullable(_$TrafficUnitEnumMap, json['unit']) ??
          TrafficUnit.auto,
      historyRetention: (json['historyRetention'] as num?)?.toInt() ?? 30,
    );

Map<String, dynamic> _$$TrafficSettingsImplToJson(
        _$TrafficSettingsImpl instance) =>
    <String, dynamic>{
      'enableStats': instance.enableStats,
      'enableSpeed': instance.enableSpeed,
      'enableLimit': instance.enableLimit,
      'uploadLimit': instance.uploadLimit,
      'downloadLimit': instance.downloadLimit,
      'unit': _$TrafficUnitEnumMap[instance.unit]!,
      'historyRetention': instance.historyRetention,
    };

const _$TrafficUnitEnumMap = {
  TrafficUnit.auto: 'auto',
  TrafficUnit.bytes: 'bytes',
  TrafficUnit.kb: 'kb',
  TrafficUnit.mb: 'mb',
  TrafficUnit.gb: 'gb',
};

_$ProxyCoreSettingsImpl _$$ProxyCoreSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$ProxyCoreSettingsImpl(
      enabled: json['enabled'] as bool? ?? true,
      coreType: $enumDecodeNullable(_$ProxyCoreTypeEnumMap, json['coreType']) ??
          ProxyCoreType.clashMeta,
      coreVersion: json['coreVersion'] as String? ?? '',
      corePath: json['corePath'] as String? ?? '',
      tempPath: json['tempPath'] as String? ?? '',
      workingPath: json['workingPath'] as String? ?? '',
      debugMode: json['debugMode'] as bool? ?? false,
      autoRestart: json['autoRestart'] as bool? ?? true,
      restartInterval: (json['restartInterval'] as num?)?.toInt() ?? 300,
      maxRestartCount: (json['maxRestartCount'] as num?)?.toInt() ?? 3,
      coreArgs: (json['coreArgs'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      environmentVars: (json['environmentVars'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ProxyCoreSettingsImplToJson(
        _$ProxyCoreSettingsImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'coreType': _$ProxyCoreTypeEnumMap[instance.coreType]!,
      'coreVersion': instance.coreVersion,
      'corePath': instance.corePath,
      'tempPath': instance.tempPath,
      'workingPath': instance.workingPath,
      'debugMode': instance.debugMode,
      'autoRestart': instance.autoRestart,
      'restartInterval': instance.restartInterval,
      'maxRestartCount': instance.maxRestartCount,
      'coreArgs': instance.coreArgs,
      'environmentVars': instance.environmentVars,
    };

const _$ProxyCoreTypeEnumMap = {
  ProxyCoreType.clashMeta: 'clashMeta',
  ProxyCoreType.v2ray: 'v2ray',
  ProxyCoreType.singBox: 'singBox',
  ProxyCoreType.xray: 'xray',
};
