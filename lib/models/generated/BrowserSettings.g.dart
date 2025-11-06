// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../BrowserSettings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BrowserSettings _$$BrowserSettingsFromJson(Map<String, dynamic> json) =>
    _$_BrowserSettings(
      userAgent: json['userAgent'] as String?,
      javascriptEnabled: json['javascriptEnabled'] as bool? ?? true,
      domStorageEnabled: json['domStorageEnabled'] as bool? ?? true,
      mixedContentEnabled: json['mixedContentEnabled'] as bool? ?? false,
      cacheMode: CacheMode.values.byName(json['cacheMode'] as String),
      incognito: json['incognito'] as bool? ?? false,
      cookiesEnabled: json['cookiesEnabled'] as bool? ?? true,
      imagesEnabled: json['imagesEnabled'] as bool? ?? true,
      cssEnabled: json['cssEnabled'] as bool? ?? true,
      pluginsEnabled: json['pluginsEnabled'] as bool? ?? false,
      mediaAutoplayEnabled: json['mediaAutoplayEnabled'] as bool? ?? false,
      geolocationEnabled: json['geolocationEnabled'] as bool? ?? false,
      cameraEnabled: json['cameraEnabled'] as bool? ?? false,
      microphoneEnabled: json['microphoneEnabled'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? false,
      webrtcEnabled: json['webrtcEnabled'] as bool? ?? true,
      fileAccessEnabled: json['fileAccessEnabled'] as bool? ?? false,
      downloadManagerEnabled: json['downloadManagerEnabled'] as bool? ?? true,
      defaultDownloadPath: json['defaultDownloadPath'] as String?,
      defaultEncoding: json['defaultEncoding'] as String? ?? 'UTF-8',
      fontSize: FontSize.values.byName(json['fontSize'] as String),
      zoomLevel: (json['zoomLevel'] as num).toDouble(),
      darkMode: json['darkMode'] as bool? ?? false,
      readerMode: json['readerMode'] as bool? ?? false,
      adBlockEnabled: json['adBlockEnabled'] as bool? ?? false,
      trackingProtectionEnabled: json['trackingProtectionEnabled'] as bool? ?? false,
      popupBlockerEnabled: json['popupBlockerEnabled'] as bool? ?? true,
      autofillEnabled: json['autofillEnabled'] as bool? ?? false,
      passwordSaveEnabled: json['passwordSaveEnabled'] as bool? ?? false,
      formAutofillEnabled: json['formAutofillEnabled'] as bool? ?? false,
      privacyMode: PrivacyMode.values.byName(json['privacyMode'] as String),
      defaultSearchEngine: SearchEngine.values.byName(json['defaultSearchEngine'] as String),
      homepage: json['homepage'] as String? ?? 'about:blank',
      newTabPage: NewTabPage.values.byName(json['newTabPage'] as String),
      keyboardShortcutsEnabled: json['keyboardShortcutsEnabled'] as bool? ?? true,
      mouseGesturesEnabled: json['mouseGesturesEnabled'] as bool? ?? false,
      developerToolsEnabled: json['developerToolsEnabled'] as bool? ?? false,
      consoleLoggingEnabled: json['consoleLoggingEnabled'] as bool? ?? false,
      networkTimeout: json['networkTimeout'] as int? ?? 30000,
      pageLoadTimeout: json['pageLoadTimeout'] as int? ?? 60000,
      maxConcurrentConnections: json['maxConcurrentConnections'] as int? ?? 10,
      cacheSizeLimit: json['cacheSizeLimit'] as int? ?? 100,
      dataCompressionEnabled: json['dataCompressionEnabled'] as bool? ?? false,
      offlineModeEnabled: json['offlineModeEnabled'] as bool? ?? false,
      fontFamily: FontFamily.values.byName(json['fontFamily'] as String),
      hardwareAccelerationEnabled: json['hardwareAccelerationEnabled'] as bool? ?? true,
      multiprocessEnabled: json['multiprocessEnabled'] as bool? ?? true,
      securityLevel: BrowserSecurityLevel.values.byName(json['securityLevel'] as String),
      sslVerification: SslVerification.values.byName(json['sslVerification'] as String),
      certificatePinning: CertificatePinning.values.byName(json['certificatePinning'] as String),
      contentFilterMode: ContentFilterMode.values.byName(json['contentFilterMode'] as String),
      proxySettings: json['proxySettings'] == null
          ? null
          : ProxySettings.fromJson(json['proxySettings'] as Map<String, dynamic>),
      customCSS: json['customCSS'] as String?,
      customJavaScript: json['customJavaScript'] as String?,
      extensionSettings: (json['extensionSettings'] as List<dynamic>)
          .map((e) => ExtensionSettings.fromJson(e as Map<String, dynamic>))
          .toList(),
      syncSettings: json['syncSettings'] == null
          ? null
          : SyncSettings.fromJson(json['syncSettings'] as Map<String, dynamic>),
      advancedSettings: json['advancedSettings'] == null
          ? null
          : AdvancedSettings.fromJson(json['advancedSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BrowserSettingsToJson(_$_BrowserSettings instance) =>
    <String, dynamic>{
      'userAgent': instance.userAgent,
      'javascriptEnabled': instance.javascriptEnabled,
      'domStorageEnabled': instance.domStorageEnabled,
      'mixedContentEnabled': instance.mixedContentEnabled,
      'cacheMode': instance.cacheMode.name,
      'incognito': instance.incognito,
      'cookiesEnabled': instance.cookiesEnabled,
      'imagesEnabled': instance.imagesEnabled,
      'cssEnabled': instance.cssEnabled,
      'pluginsEnabled': instance.pluginsEnabled,
      'mediaAutoplayEnabled': instance.mediaAutoplayEnabled,
      'geolocationEnabled': instance.geolocationEnabled,
      'cameraEnabled': instance.cameraEnabled,
      'microphoneEnabled': instance.microphoneEnabled,
      'notificationsEnabled': instance.notificationsEnabled,
      'webrtcEnabled': instance.webrtcEnabled,
      'fileAccessEnabled': instance.fileAccessEnabled,
      'downloadManagerEnabled': instance.downloadManagerEnabled,
      'defaultDownloadPath': instance.defaultDownloadPath,
      'defaultEncoding': instance.defaultEncoding,
      'fontSize': instance.fontSize.name,
      'zoomLevel': instance.zoomLevel,
      'darkMode': instance.darkMode,
      'readerMode': instance.readerMode,
      'adBlockEnabled': instance.adBlockEnabled,
      'trackingProtectionEnabled': instance.trackingProtectionEnabled,
      'popupBlockerEnabled': instance.popupBlockerEnabled,
      'autofillEnabled': instance.autofillEnabled,
      'passwordSaveEnabled': instance.passwordSaveEnabled,
      'formAutofillEnabled': instance.formAutofillEnabled,
      'privacyMode': instance.privacyMode.name,
      'defaultSearchEngine': instance.defaultSearchEngine.name,
      'homepage': instance.homepage,
      'newTabPage': instance.newTabPage.name,
      'keyboardShortcutsEnabled': instance.keyboardShortcutsEnabled,
      'mouseGesturesEnabled': instance.mouseGesturesEnabled,
      'developerToolsEnabled': instance.developerToolsEnabled,
      'consoleLoggingEnabled': instance.consoleLoggingEnabled,
      'networkTimeout': instance.networkTimeout,
      'pageLoadTimeout': instance.pageLoadTimeout,
      'maxConcurrentConnections': instance.maxConcurrentConnections,
      'cacheSizeLimit': instance.cacheSizeLimit,
      'dataCompressionEnabled': instance.dataCompressionEnabled,
      'offlineModeEnabled': instance.offlineModeEnabled,
      'fontFamily': instance.fontFamily.name,
      'hardwareAccelerationEnabled': instance.hardwareAccelerationEnabled,
      'multiprocessEnabled': instance.multiprocessEnabled,
      'securityLevel': instance.securityLevel.name,
      'sslVerification': instance.sslVerification.name,
      'certificatePinning': instance.certificatePinning.name,
      'contentFilterMode': instance.contentFilterMode.name,
      'proxySettings': instance.proxySettings,
      'customCSS': instance.customCSS,
      'customJavaScript': instance.customJavaScript,
      'extensionSettings': instance.extensionSettings,
      'syncSettings': instance.syncSettings,
      'advancedSettings': instance.advancedSettings,
    };

_$_ProxySettings _$$ProxySettingsFromJson(Map<String, dynamic> json) =>
    _$_ProxySettings(
      enabled: json['enabled'] as bool? ?? false,
      type: ProxyType.values.byName(json['type'] as String),
      host: json['host'] as String?,
      port: json['port'] as int?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      bypassList: (json['bypassList'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$ProxySettingsToJson(_$_ProxySettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'type': instance.type.name,
      'host': instance.host,
      'port': instance.port,
      'username': instance.username,
      'password': instance.password,
      'bypassList': instance.bypassList,
    };

_$_ExtensionSettings _$$ExtensionSettingsFromJson(Map<String, dynamic> json) =>
    _$_ExtensionSettings(
      id: json['id'] as String,
      name: json['name'] as String,
      enabled: json['enabled'] as bool? ?? true,
      config: json['config'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ExtensionSettingsToJson(_$_ExtensionSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'enabled': instance.enabled,
      'config': instance.config,
    };

_$_SyncSettings _$$SyncSettingsFromJson(Map<String, dynamic> json) =>
    _$_SyncSettings(
      enabled: json['enabled'] as bool? ?? false,
      serverUrl: json['serverUrl'] as String?,
      syncInterval: json['syncInterval'] as int? ?? 60,
      dataTypes: (json['dataTypes'] as List<dynamic>)
          .map((e) => SyncDataType.values.byName(e as String))
          .toList(),
    );

Map<String, dynamic> _$$SyncSettingsToJson(_$_SyncSettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'serverUrl': instance.serverUrl,
      'syncInterval': instance.syncInterval,
      'dataTypes': instance.dataTypes.map((e) => e.name).toList(),
    };

_$_AdvancedSettings _$$AdvancedSettingsFromJson(Map<String, dynamic> json) =>
    _$_AdvancedSettings(
      debugMode: json['debugMode'] as bool? ?? false,
      performanceMonitoring: json['performanceMonitoring'] as bool? ?? false,
      networkLogging: json['networkLogging'] as bool? ?? false,
      memoryMonitoring: json['memoryMonitoring'] as bool? ?? false,
      webViewVersion: json['webViewVersion'] as String?,
      customWebViewParams: json['customWebViewParams'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AdvancedSettingsToJson(_$_AdvancedSettings instance) =>
    <String, dynamic>{
      'debugMode': instance.debugMode,
      'performanceMonitoring': instance.performanceMonitoring,
      'networkLogging': instance.networkLogging,
      'memoryMonitoring': instance.memoryMonitoring,
      'webViewVersion': instance.webViewVersion,
      'customWebViewParams': instance.customWebViewParams,
    };
