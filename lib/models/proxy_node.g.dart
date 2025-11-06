// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProxyNodeImpl _$$ProxyNodeImplFromJson(Map<String, dynamic> json) =>
    _$ProxyNodeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$ProxyTypeEnumMap, json['type']),
      version: $enumDecodeNullable(_$ProxyVersionEnumMap, json['version']) ??
          ProxyVersion.vmess,
      server: json['server'] as String,
      port: (json['port'] as num).toInt(),
      security: json['security'] as String?,
      auth: json['auth'] as String?,
      vmessConfig: json['vmessConfig'] == null
          ? null
          : VMessConfig.fromJson(json['vmessConfig'] as Map<String, dynamic>),
      vlessConfig: json['vlessConfig'] == null
          ? null
          : VLessConfig.fromJson(json['vlessConfig'] as Map<String, dynamic>),
      ssConfig: json['ssConfig'] == null
          ? null
          : SSConfig.fromJson(json['ssConfig'] as Map<String, dynamic>),
      trojanConfig: json['trojanConfig'] == null
          ? null
          : TrojanConfig.fromJson(json['trojanConfig'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$NodeStatusEnumMap, json['status']) ??
          NodeStatus.untested,
      latency: (json['latency'] as num?)?.toInt(),
      downloadSpeed: (json['downloadSpeed'] as num?)?.toDouble(),
      uploadSpeed: (json['uploadSpeed'] as num?)?.toDouble(),
      lastTested: json['lastTested'] == null
          ? null
          : DateTime.parse(json['lastTested'] as String),
      enabled: json['enabled'] as bool? ?? true,
      autoSelect: json['autoSelect'] as bool? ?? false,
      favorite: json['favorite'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      remark: json['remark'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      isp: json['isp'] as String?,
      latencyHistory: (json['latencyHistory'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      errorMessage: json['errorMessage'] as String?,
      createdAt: json['createdAt'] == null
          ? DateTime.now
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      subscriptionId: json['subscriptionId'] as String?,
      group: json['group'] as String?,
      rawConfig: json['rawConfig'] as String?,
      iconUrl: json['iconUrl'] as String?,
      geoInfo: json['geoInfo'] == null
          ? null
          : GeoInfo.fromJson(json['geoInfo'] as Map<String, dynamic>),
      performance: json['performance'] == null
          ? null
          : NodePerformance.fromJson(
              json['performance'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProxyNodeImplToJson(_$ProxyNodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$ProxyTypeEnumMap[instance.type]!,
      'version': _$ProxyVersionEnumMap[instance.version]!,
      'server': instance.server,
      'port': instance.port,
      'security': instance.security,
      'auth': instance.auth,
      'vmessConfig': instance.vmessConfig,
      'vlessConfig': instance.vlessConfig,
      'ssConfig': instance.ssConfig,
      'trojanConfig': instance.trojanConfig,
      'status': _$NodeStatusEnumMap[instance.status]!,
      'latency': instance.latency,
      'downloadSpeed': instance.downloadSpeed,
      'uploadSpeed': instance.uploadSpeed,
      'lastTested': instance.lastTested?.toIso8601String(),
      'enabled': instance.enabled,
      'autoSelect': instance.autoSelect,
      'favorite': instance.favorite,
      'tags': instance.tags,
      'remark': instance.remark,
      'country': instance.country,
      'city': instance.city,
      'isp': instance.isp,
      'latencyHistory': instance.latencyHistory,
      'priority': instance.priority,
      'errorMessage': instance.errorMessage,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'subscriptionId': instance.subscriptionId,
      'group': instance.group,
      'rawConfig': instance.rawConfig,
      'iconUrl': instance.iconUrl,
      'geoInfo': instance.geoInfo,
      'performance': instance.performance,
    };

const _$ProxyTypeEnumMap = {
  ProxyType.vmess: 'vmess',
  ProxyType.vless: 'vless',
  ProxyType.ss: 'ss',
  ProxyType.ssr: 'ssr',
  ProxyType.trojan: 'trojan',
  ProxyType.socks5: 'socks5',
  ProxyType.http: 'http',
  ProxyType.unknown: 'unknown',
};

const _$ProxyVersionEnumMap = {
  ProxyVersion.vmess: 'vmess',
  ProxyVersion.vless: 'vless',
  ProxyVersion.ss: 'ss',
  ProxyVersion.ssr: 'ssr',
  ProxyVersion.trojan: 'trojan',
};

const _$NodeStatusEnumMap = {
  NodeStatus.normal: 'normal',
  NodeStatus.error: 'error',
  NodeStatus.timeout: 'timeout',
  NodeStatus.testing: 'testing',
  NodeStatus.untested: 'untested',
  NodeStatus.disabled: 'disabled',
  NodeStatus.selected: 'selected',
};

_$VMessConfigImpl _$$VMessConfigImplFromJson(Map<String, dynamic> json) =>
    _$VMessConfigImpl(
      uuid: json['uuid'] as String,
      encryption: json['encryption'] as String? ?? 'auto',
      transport: json['transport'] as String? ?? 'ws',
      streamSecurity: json['streamSecurity'] as String?,
      path: json['path'] as String?,
      host: json['host'] as String?,
      tls: json['tls'] as bool? ?? false,
      tlsCert: json['tlsCert'] as String?,
      tlsKey: json['tlsKey'] as String?,
      sni: json['sni'] as String?,
      verifyCertificate: json['verifyCertificate'] as bool? ?? true,
      wsConfig: json['wsConfig'] == null
          ? null
          : WSConfig.fromJson(json['wsConfig'] as Map<String, dynamic>),
      http2Config: json['http2Config'] == null
          ? null
          : HTTP2Config.fromJson(json['http2Config'] as Map<String, dynamic>),
      tcpConfig: json['tcpConfig'] == null
          ? null
          : TCPConfig.fromJson(json['tcpConfig'] as Map<String, dynamic>),
      grpcConfig: json['grpcConfig'] == null
          ? null
          : GRPCConfig.fromJson(json['grpcConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$VMessConfigImplToJson(_$VMessConfigImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'encryption': instance.encryption,
      'transport': instance.transport,
      'streamSecurity': instance.streamSecurity,
      'path': instance.path,
      'host': instance.host,
      'tls': instance.tls,
      'tlsCert': instance.tlsCert,
      'tlsKey': instance.tlsKey,
      'sni': instance.sni,
      'verifyCertificate': instance.verifyCertificate,
      'wsConfig': instance.wsConfig,
      'http2Config': instance.http2Config,
      'tcpConfig': instance.tcpConfig,
      'grpcConfig': instance.grpcConfig,
    };

_$VLessConfigImpl _$$VLessConfigImplFromJson(Map<String, dynamic> json) =>
    _$VLessConfigImpl(
      uuid: json['uuid'] as String,
      flow: json['flow'] as String? ?? 'xtls-rprx-vision',
      transport: json['transport'] as String? ?? 'ws',
      streamSecurity: json['streamSecurity'] as String?,
      path: json['path'] as String?,
      host: json['host'] as String?,
      tls: json['tls'] as bool? ?? false,
      tlsType: json['tlsType'] as String? ?? 'xtls',
      tlsCert: json['tlsCert'] as String?,
      tlsKey: json['tlsKey'] as String?,
      sni: json['sni'] as String?,
      wsConfig: json['wsConfig'] == null
          ? null
          : WSConfig.fromJson(json['wsConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$VLessConfigImplToJson(_$VLessConfigImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'flow': instance.flow,
      'transport': instance.transport,
      'streamSecurity': instance.streamSecurity,
      'path': instance.path,
      'host': instance.host,
      'tls': instance.tls,
      'tlsType': instance.tlsType,
      'tlsCert': instance.tlsCert,
      'tlsKey': instance.tlsKey,
      'sni': instance.sni,
      'wsConfig': instance.wsConfig,
    };

_$SSConfigImpl _$$SSConfigImplFromJson(Map<String, dynamic> json) =>
    _$SSConfigImpl(
      password: json['password'] as String,
      method: json['method'] as String? ?? 'aes-256-gcm',
      plugin: json['plugin'] as String?,
      pluginOpts: json['pluginOpts'] as String?,
    );

Map<String, dynamic> _$$SSConfigImplToJson(_$SSConfigImpl instance) =>
    <String, dynamic>{
      'password': instance.password,
      'method': instance.method,
      'plugin': instance.plugin,
      'pluginOpts': instance.pluginOpts,
    };

_$TrojanConfigImpl _$$TrojanConfigImplFromJson(Map<String, dynamic> json) =>
    _$TrojanConfigImpl(
      password: json['password'] as String,
      tlsConfig: json['tlsConfig'] == null
          ? null
          : TLSConfig.fromJson(json['tlsConfig'] as Map<String, dynamic>),
      wsConfig: json['wsConfig'] == null
          ? null
          : WSConfig.fromJson(json['wsConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TrojanConfigImplToJson(_$TrojanConfigImpl instance) =>
    <String, dynamic>{
      'password': instance.password,
      'tlsConfig': instance.tlsConfig,
      'wsConfig': instance.wsConfig,
    };

_$WSConfigImpl _$$WSConfigImplFromJson(Map<String, dynamic> json) =>
    _$WSConfigImpl(
      path: json['path'] as String,
      headers: json['headers'] as String?,
      earlyDataHeaderName: json['earlyDataHeaderName'] as bool? ?? false,
    );

Map<String, dynamic> _$$WSConfigImplToJson(_$WSConfigImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'headers': instance.headers,
      'earlyDataHeaderName': instance.earlyDataHeaderName,
    };

_$HTTP2ConfigImpl _$$HTTP2ConfigImplFromJson(Map<String, dynamic> json) =>
    _$HTTP2ConfigImpl(
      path: json['path'] as String,
      sni: json['sni'] as String,
      host: json['host'] as String?,
    );

Map<String, dynamic> _$$HTTP2ConfigImplToJson(_$HTTP2ConfigImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'sni': instance.sni,
      'host': instance.host,
    };

_$TCPConfigImpl _$$TCPConfigImplFromJson(Map<String, dynamic> json) =>
    _$TCPConfigImpl(
      acceptQueryProtocol: json['acceptQueryProtocol'] as String? ?? 'none',
      headerPath: json['headerPath'] as String?,
      headerPorts: (json['headerPorts'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TCPConfigImplToJson(_$TCPConfigImpl instance) =>
    <String, dynamic>{
      'acceptQueryProtocol': instance.acceptQueryProtocol,
      'headerPath': instance.headerPath,
      'headerPorts': instance.headerPorts,
    };

_$GRPCConfigImpl _$$GRPCConfigImplFromJson(Map<String, dynamic> json) =>
    _$GRPCConfigImpl(
      serviceName: json['serviceName'] as String,
      mode: json['mode'] as String? ?? 'multi',
    );

Map<String, dynamic> _$$GRPCConfigImplToJson(_$GRPCConfigImpl instance) =>
    <String, dynamic>{
      'serviceName': instance.serviceName,
      'mode': instance.mode,
    };

_$TLSConfigImpl _$$TLSConfigImplFromJson(Map<String, dynamic> json) =>
    _$TLSConfigImpl(
      sni: json['sni'] as String,
      alpn:
          (json['alpn'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const ['http/1.1'],
      certPath: json['certPath'] as String?,
      keyPath: json['keyPath'] as String?,
    );

Map<String, dynamic> _$$TLSConfigImplToJson(_$TLSConfigImpl instance) =>
    <String, dynamic>{
      'sni': instance.sni,
      'alpn': instance.alpn,
      'certPath': instance.certPath,
      'keyPath': instance.keyPath,
    };

_$GeoInfoImpl _$$GeoInfoImplFromJson(Map<String, dynamic> json) =>
    _$GeoInfoImpl(
      countryCode: json['countryCode'] as String?,
      country: json['country'] as String?,
      region: json['region'] as String?,
      city: json['city'] as String?,
      timezone: json['timezone'] as String?,
      isp: json['isp'] as String?,
      asn: json['asn'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$GeoInfoImplToJson(_$GeoInfoImpl instance) =>
    <String, dynamic>{
      'countryCode': instance.countryCode,
      'country': instance.country,
      'region': instance.region,
      'city': instance.city,
      'timezone': instance.timezone,
      'isp': instance.isp,
      'asn': instance.asn,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_$NodePerformanceImpl _$$NodePerformanceImplFromJson(
        Map<String, dynamic> json) =>
    _$NodePerformanceImpl(
      avgLatency: (json['avgLatency'] as num?)?.toInt(),
      minLatency: (json['minLatency'] as num?)?.toInt(),
      maxLatency: (json['maxLatency'] as num?)?.toInt(),
      successRate: (json['successRate'] as num?)?.toDouble() ?? 0.0,
      testCount: (json['testCount'] as num?)?.toInt() ?? 0,
      lastSuccessTime: json['lastSuccessTime'] == null
          ? null
          : DateTime.parse(json['lastSuccessTime'] as String),
      lastFailTime: json['lastFailTime'] == null
          ? null
          : DateTime.parse(json['lastFailTime'] as String),
      consecutiveFailures: (json['consecutiveFailures'] as num?)?.toInt() ?? 0,
      stabilityScore: (json['stabilityScore'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$NodePerformanceImplToJson(
        _$NodePerformanceImpl instance) =>
    <String, dynamic>{
      'avgLatency': instance.avgLatency,
      'minLatency': instance.minLatency,
      'maxLatency': instance.maxLatency,
      'successRate': instance.successRate,
      'testCount': instance.testCount,
      'lastSuccessTime': instance.lastSuccessTime?.toIso8601String(),
      'lastFailTime': instance.lastFailTime?.toIso8601String(),
      'consecutiveFailures': instance.consecutiveFailures,
      'stabilityScore': instance.stabilityScore,
    };

_$NodeFilterImpl _$$NodeFilterImplFromJson(Map<String, dynamic> json) =>
    _$NodeFilterImpl(
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ProxyTypeEnumMap, e))
          .toList(),
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$NodeStatusEnumMap, e))
          .toList(),
      countries: (json['countries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isps: (json['isps'] as List<dynamic>?)?.map((e) => e as String).toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isFavorite: json['isFavorite'] as bool?,
      isEnabled: json['isEnabled'] as bool?,
      maxLatency: (json['maxLatency'] as num?)?.toInt(),
      minSuccessRate: (json['minSuccessRate'] as num?)?.toDouble(),
      keyword: json['keyword'] as String?,
      customFilter: json['customFilter'] as String?,
    );

Map<String, dynamic> _$$NodeFilterImplToJson(_$NodeFilterImpl instance) =>
    <String, dynamic>{
      'types': instance.types?.map((e) => _$ProxyTypeEnumMap[e]!).toList(),
      'statuses':
          instance.statuses?.map((e) => _$NodeStatusEnumMap[e]!).toList(),
      'countries': instance.countries,
      'isps': instance.isps,
      'tags': instance.tags,
      'isFavorite': instance.isFavorite,
      'isEnabled': instance.isEnabled,
      'maxLatency': instance.maxLatency,
      'minSuccessRate': instance.minSuccessRate,
      'keyword': instance.keyword,
      'customFilter': instance.customFilter,
    };

_$NodeSortImpl _$$NodeSortImplFromJson(Map<String, dynamic> json) =>
    _$NodeSortImpl(
      field: $enumDecodeNullable(_$NodeSortFieldEnumMap, json['field']) ??
          NodeSortField.name,
      order: $enumDecodeNullable(_$SortOrderEnumMap, json['order']) ??
          SortOrder.asc,
    );

Map<String, dynamic> _$$NodeSortImplToJson(_$NodeSortImpl instance) =>
    <String, dynamic>{
      'field': _$NodeSortFieldEnumMap[instance.field]!,
      'order': _$SortOrderEnumMap[instance.order]!,
    };

const _$NodeSortFieldEnumMap = {
  NodeSortField.name: 'name',
  NodeSortField.latency: 'latency',
  NodeSortField.speed: 'speed',
  NodeSortField.priority: 'priority',
  NodeSortField.createdAt: 'createdAt',
  NodeSortField.successRate: 'successRate',
};

const _$SortOrderEnumMap = {
  SortOrder.asc: 'asc',
  SortOrder.desc: 'desc',
};

_$NodeImportResultImpl _$$NodeImportResultImplFromJson(
        Map<String, dynamic> json) =>
    _$NodeImportResultImpl(
      success: json['success'] as bool,
      importedNodes: (json['importedNodes'] as num?)?.toInt() ?? 0,
      validNodes: (json['validNodes'] as num?)?.toInt() ?? 0,
      invalidNodes: (json['invalidNodes'] as num?)?.toInt() ?? 0,
      duplicateNodes: (json['duplicateNodes'] as num?)?.toInt() ?? 0,
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nodes: (json['nodes'] as List<dynamic>?)
              ?.map((e) => ProxyNode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      importStats: json['importStats'] == null
          ? _emptyImportStats
          : NodeImportStats.fromJson(
              json['importStats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NodeImportResultImplToJson(
        _$NodeImportResultImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'importedNodes': instance.importedNodes,
      'validNodes': instance.validNodes,
      'invalidNodes': instance.invalidNodes,
      'duplicateNodes': instance.duplicateNodes,
      'errors': instance.errors,
      'nodes': instance.nodes,
      'importStats': instance.importStats,
    };

_$NodeImportStatsImpl _$$NodeImportStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$NodeImportStatsImpl(
      vmessCount: (json['vmessCount'] as num?)?.toInt() ?? 0,
      vlessCount: (json['vlessCount'] as num?)?.toInt() ?? 0,
      ssCount: (json['ssCount'] as num?)?.toInt() ?? 0,
      ssrCount: (json['ssrCount'] as num?)?.toInt() ?? 0,
      trojanCount: (json['trojanCount'] as num?)?.toInt() ?? 0,
      parseErrors: (json['parseErrors'] as num?)?.toInt() ?? 0,
      totalTimeMs: (json['totalTimeMs'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$NodeImportStatsImplToJson(
        _$NodeImportStatsImpl instance) =>
    <String, dynamic>{
      'vmessCount': instance.vmessCount,
      'vlessCount': instance.vlessCount,
      'ssCount': instance.ssCount,
      'ssrCount': instance.ssrCount,
      'trojanCount': instance.trojanCount,
      'parseErrors': instance.parseErrors,
      'totalTimeMs': instance.totalTimeMs,
    };
