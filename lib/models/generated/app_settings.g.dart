// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppSettings _$$AppSettingsFromJson(Map<String, dynamic> json) =>
    _$_AppSettings(
      version: json['version'] as String? ?? '1.0.0',
      createdAt: json['createdAt'] as int? ?? 0,
      updatedAt: json['updatedAt'] as int? ?? 0,
      mode: SettingsMode.values.byName(json['mode'] as String),
      browserSettings: BrowserSettings.fromJson(
          json['browserSettings'] as Map<String, dynamic>),
      flclashSettings: ClashCoreSettings.fromJson(
          json['flclashSettings'] as Map<String, dynamic>),
      ui: UI.fromJson(json['ui'] as Map<String, dynamic>),
      notifications: Notifications.fromJson(
          json['notifications'] as Map<String, dynamic>),
      privacy: Privacy.fromJson(json['privacy'] as Map<String, dynamic>),
      backup: Backup.fromJson(json['backup'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AppSettingsToJson(_$_AppSettings instance) =>
    <String, dynamic>{
      'version': instance.version,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'mode': instance.mode.name,
      'browserSettings': instance.browserSettings,
      'flclashSettings': instance.flclashSettings,
      'ui': instance.ui,
      'notifications': instance.notifications,
      'privacy': instance.privacy,
      'backup': instance.backup,
    };

_$_ClashCoreSettings _$$ClashCoreSettingsFromJson(Map<String, dynamic> json) =>
    _$_ClashCoreSettings(
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

Map<String, dynamic> _$$ClashCoreSettingsToJson(_$_ClashCoreSettings instance) =>
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
      'ports': instance.ports,
      'dns': instance.dns,
      'rules': instance.rules,
      'nodes': instance.nodes,
      'traffic': instance.traffic,
    };

_$_PortSettings _$$PortSettingsFromJson(Map<String, dynamic> json) =>
    _$_PortSettings(
      httpPort: json['httpPort'] as int? ?? 7890,
      socksPort: json['socksPort'] as int? ?? 7891,
      mixedPort: json['mixedPort'] as int? ?? 7892,
      apiPort: json['apiPort'] as int? ?? 9090,
    );

Map<String, dynamic> _$$PortSettingsToJson(_$_PortSettings instance) =>
    <String, dynamic>{
      'httpPort': instance.httpPort,
      'socksPort': instance.socksPort,
      'mixedPort': instance.mixedPort,
      'apiPort': instance.apiPort,
    };

_$_DNSSettings _$$DNSSettingsFromJson(Map<String, dynamic> json) =>
    _$_DNSSettings(
      customDNS: json['customDNS'] as bool? ?? false,
      dnsServers: (json['dnsServers'] as List<dynamic>).map((e) => e as String).toList(),
      dnsOverHttps: json['dnsOverHttps'] as bool? ?? false,
      dohServer: json['dohServer'] as String?,
    );

Map<String, dynamic> _$$DNSSettingsToJson(_$_DNSSettings instance) =>
    <String, dynamic>{
      'customDNS': instance.customDNS,
      'dnsServers': instance.dnsServers,
      'dnsOverHttps': instance.dnsOverHttps,
      'dohServer': instance.dohServer,
    };

_$_RuleSettings _$$RuleSettingsFromJson(Map<String, dynamic> json) =>
    _$_RuleSettings(
      customRules: json['customRules'] as bool? ?? false,
      rulePath: json['rulePath'] as String?,
      ruleType: RuleType.values.byName(json['ruleType'] as String),
      adBlock: json['adBlock'] as bool? ?? true,
      trackingBlock: json['trackingBlock'] as bool? ?? true,
    );

Map<String, dynamic> _$$RuleSettingsToJson(_$_RuleSettings instance) =>
    <String, dynamic>{
      'customRules': instance.customRules,
      'rulePath': instance.rulePath,
      'ruleType': instance.ruleType.name,
      'adBlock': instance.adBlock,
      'trackingBlock': instance.trackingBlock,
    };

_$_NodeSettings _$$NodeSettingsFromJson(Map<String, dynamic> json) =>
    _$_NodeSettings(
      autoSwitch: json['autoSwitch'] as bool? ?? false,
      switchInterval: json['switchInterval'] as int? ?? 30,
      loadBalance: json['loadBalance'] as bool? ?? false,
      healthCheck: json['healthCheck'] as bool? ?? true,
      healthCheckInterval: json['healthCheckInterval'] as int? ?? 5,
    );

Map<String, dynamic> _$$NodeSettingsToJson(_$_NodeSettings instance) =>
    <String, dynamic>{
      'autoSwitch': instance.autoSwitch,
      'switchInterval': instance.switchInterval,
      'loadBalance': instance.loadBalance,
      'healthCheck': instance.healthCheck,
      'healthCheckInterval': instance.healthCheckInterval,
    };

_$_TrafficSettings _$$TrafficSettingsFromJson(Map<String, dynamic> json) =>
    _$_TrafficSettings(
      enabled: json['enabled'] as bool? ?? true,
      realTime: json['realTime'] as bool? ?? true,
      period: StatisticPeriod.values.byName(json['period'] as String),
      trafficAlert: json['trafficAlert'] as bool? ?? false,
      alertThreshold: json['alertThreshold'] as int? ?? 10,
    );

Map<String, dynamic> _$$TrafficSettingsToJson(_$_TrafficSettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'realTime': instance.realTime,
      'period': instance.period.name,
      'trafficAlert': instance.trafficAlert,
      'alertThreshold': instance.alertThreshold,
    };

_$_UI _$$UIFromJson(Map<String, dynamic> json) => _$_UI(
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

Map<String, dynamic> _$$UIToJson(_$_UI instance) => <String, dynamic>{
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

_$_Notifications _$$NotificationsFromJson(Map<String, dynamic> json) =>
    _$_Notifications(
      enabled: json['enabled'] as bool? ?? true,
      connectionStatus: json['connectionStatus'] as bool? ?? true,
      trafficAlert: json['trafficAlert'] as bool? ?? false,
      nodeSwitch: json['nodeSwitch'] as bool? ?? false,
      systemProxy: json['systemProxy'] as bool? ?? false,
      update: json['update'] as bool? ?? true,
      errors: json['errors'] as bool? ?? true,
    );

Map<String, dynamic> _$$NotificationsToJson(_$_Notifications instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'connectionStatus': instance.connectionStatus,
      'trafficAlert': instance.trafficAlert,
      'nodeSwitch': instance.nodeSwitch,
      'systemProxy': instance.systemProxy,
      'update': instance.update,
      'errors': instance.errors,
    };

_$_Privacy _$$PrivacyFromJson(Map<String, dynamic> json) => _$_Privacy(
      privacyMode: json['privacyMode'] as bool? ?? false,
      anonymousMode: json['anonymousMode'] as bool? ?? false,
      dataEncryption: json['dataEncryption'] as bool? ?? true,
      localDataEncryption: json['localDataEncryption'] as bool? ?? false,
      autoClean: json['autoClean'] as bool? ?? false,
      cleanInterval: json['cleanInterval'] as int? ?? 7,
      telemetry: json['telemetry'] as bool? ?? false,
      crashReporting: json['crashReporting'] as bool? ?? false,
    );

Map<String, dynamic> _$$PrivacyToJson(_$_Privacy instance) =>
    <String, dynamic>{
      'privacyMode': instance.privacyMode,
      'anonymousMode': instance.anonymousMode,
      'dataEncryption': instance.dataEncryption,
      'localDataEncryption': instance.localDataEncryption,
      'autoClean': instance.autoClean,
      'cleanInterval': instance.cleanInterval,
      'telemetry': instance.telemetry,
      'crashReporting': instance.crashReporting,
    };

_$_Backup _$$BackupFromJson(Map<String, dynamic> json) => _$_Backup(
      autoBackup: json['autoBackup'] as bool? ?? false,
      backupInterval: json['backupInterval'] as int? ?? 7,
      cloudBackup: json['cloudBackup'] as bool? ?? false,
      cloudService: CloudService.values.byName(json['cloudService'] as String),
      backupEncryption: json['backupEncryption'] as bool? ?? true,
      keepCount: json['keepCount'] as int? ?? 5,
    );

Map<String, dynamic> _$$BackupToJson(_$_Backup instance) =>
    <String, dynamic>{
      'autoBackup': instance.autoBackup,
      'backupInterval': instance.backupInterval,
      'cloudBackup': instance.cloudBackup,
      'cloudService': instance.cloudService.name,
      'backupEncryption': instance.backupEncryption,
      'keepCount': instance.keepCount,
    };
