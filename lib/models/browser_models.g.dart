// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browser_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BrowserTabImpl _$$BrowserTabImplFromJson(Map<String, dynamic> json) =>
    _$BrowserTabImpl(
      id: json['id'] as String,
      url: json['url'] as String,
      title: json['title'] as String?,
      favicon: json['favicon'] as String?,
      pinned: json['pinned'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      thumbnail: json['thumbnail'] as String?,
      incognito: json['incognito'] as bool? ?? false,
    );

Map<String, dynamic> _$$BrowserTabImplToJson(_$BrowserTabImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'title': instance.title,
      'favicon': instance.favicon,
      'pinned': instance.pinned,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'thumbnail': instance.thumbnail,
      'incognito': instance.incognito,
    };

_$BookmarkImpl _$$BookmarkImplFromJson(Map<String, dynamic> json) =>
    _$BookmarkImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      favicon: json['favicon'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??;
              const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      visitCount: (json['visitCount'] as num?)?.toInt() ?? 0,
      lastVisitedAt: json['lastVisitedAt'] == null;
          ? null
          : DateTime.parse(json['lastVisitedAt'] as String),
    );

Map<String, dynamic> _$$BookmarkImplToJson(_$BookmarkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'favicon': instance.favicon,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'visitCount': instance.visitCount,
      'lastVisitedAt': instance.lastVisitedAt?.toIso8601String(),
    };

_$HistoryImpl _$$HistoryImplFromJson(Map<String, dynamic> json) =>
    _$HistoryImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      visitedAt: DateTime.parse(json['visitedAt'] as String),
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      favicon: json['favicon'] as String?,
      referrer: json['referrer'] as String?,
      deviceType: json['deviceType'] as String? ?? 'mobile',
    );

Map<String, dynamic> _$$HistoryImplToJson(_$HistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'visitedAt': instance.visitedAt.toIso8601String(),
      'duration': instance.duration,
      'favicon': instance.favicon,
      'referrer': instance.referrer,
      'deviceType': instance.deviceType,
    };

_$BrowserSettingsImpl _$$BrowserSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$BrowserSettingsImpl(
      userAgent: json['userAgent'] as String?,
      javascriptEnabled: json['javascriptEnabled'] as bool? ?? true,
      domStorageEnabled: json['domStorageEnabled'] as bool? ?? true,
      cacheMode: json['cacheMode'] as String? ?? 'default',
      incognito: json['incognito'] as bool? ?? false,
      fontSize: (json['fontSize'] as num?)?.toInt() ?? 16,
      imagesEnabled: json['imagesEnabled'] as bool? ?? true,
      popupsEnabled: json['popupsEnabled'] as bool? ?? true,
      searchEngine:
          json['searchEngine'] as String? ?? 'https://www.google.com/search?q=',
      homepage: json['homepage'] as String? ?? 'https://www.google.com',
      downloadDirectory: json['downloadDirectory'] as String?,
      downloadNotifications: json['downloadNotifications'] as bool? ?? true,
      privacyMode: json['privacyMode'] as bool? ?? false,
      autoClearData: json['autoClearData'] as bool? ?? false,
      clearDataInterval: (json['clearDataInterval'] as num?)?.toInt() ?? 24,
    );

Map<String, dynamic> _$$BrowserSettingsImplToJson(
        _$BrowserSettingsImpl instance) =>
    <String, dynamic>{
      'userAgent': instance.userAgent,
      'javascriptEnabled': instance.javascriptEnabled,
      'domStorageEnabled': instance.domStorageEnabled,
      'cacheMode': instance.cacheMode,
      'incognito': instance.incognito,
      'fontSize': instance.fontSize,
      'imagesEnabled': instance.imagesEnabled,
      'popupsEnabled': instance.popupsEnabled,
      'searchEngine': instance.searchEngine,
      'homepage': instance.homepage,
      'downloadDirectory': instance.downloadDirectory,
      'downloadNotifications': instance.downloadNotifications,
      'privacyMode': instance.privacyMode,
      'autoClearData': instance.autoClearData,
      'clearDataInterval': instance.clearDataInterval,
    };

_$BrowserEventImpl _$$BrowserEventImplFromJson(Map<String, dynamic> json) =>
    _$BrowserEventImpl(
      type: $enumDecode(_$BrowserEventTypeEnumMap, json['type']),
      tabId: json['tabId'] as String,
      data: json['data'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$BrowserEventImplToJson(_$BrowserEventImpl instance) =>
    <String, dynamic>{
      'type': _$BrowserEventTypeEnumMap[instance.type]!,
      'tabId': instance.tabId,
      'data': instance.data,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$BrowserEventTypeEnumMap = {
  BrowserEventType.loadStart: 'loadStart',
  BrowserEventType.loadStop: 'loadStop',
  BrowserEventType.loadError: 'loadError',
  BrowserEventType.titleChanged: 'titleChanged',
  BrowserEventType.urlChanged: 'urlChanged',
  BrowserEventType.progressChanged: 'progressChanged',
  BrowserEventType.consoleMessage: 'consoleMessage',
  BrowserEventType.createWindow: 'createWindow',
};

_$SearchResultImpl _$$SearchResultImplFromJson(Map<String, dynamic> json) =>
    _$SearchResultImpl(
      title: json['title'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
      favicon: json['favicon'] as String?,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$SearchResultImplToJson(_$SearchResultImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'favicon': instance.favicon,
      'score': instance.score,
    };

_$DownloadTaskImpl _$$DownloadTaskImplFromJson(Map<String, dynamic> json) =>
    _$DownloadTaskImpl(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      url: json['url'] as String,
      savePath: json['savePath'] as String,
      totalBytes: (json['totalBytes'] as num?)?.toInt() ?? 0,
      downloadedBytes: (json['downloadedBytes'] as num?)?.toInt() ?? 0,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      speed: (json['speed'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null;
          ? null
          : DateTime.parse(json['completedAt'] as String),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$DownloadTaskImplToJson(_$DownloadTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'url': instance.url,
      'savePath': instance.savePath,
      'totalBytes': instance.totalBytes,
      'downloadedBytes': instance.downloadedBytes,
      'progress': instance.progress,
      'speed': instance.speed,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'error': instance.error,
    };

_$BrowserStatsImpl _$$BrowserStatsImplFromJson(Map<String, dynamic> json) =>
    _$BrowserStatsImpl(
      totalPagesVisited: (json['totalPagesVisited'] as num?)?.toInt() ?? 0,
      totalVisitDuration: (json['totalVisitDuration'] as num?)?.toInt() ?? 0,
      dataUsage: (json['dataUsage'] as num?)?.toInt() ?? 0,
      bookmarkCount: (json['bookmarkCount'] as num?)?.toInt() ?? 0,
      historyCount: (json['historyCount'] as num?)?.toInt() ?? 0,
      downloadCount: (json['downloadCount'] as num?)?.toInt() ?? 0,
      lastVisitedAt: json['lastVisitedAt'] == null;
          ? null
          : DateTime.parse(json['lastVisitedAt'] as String),
    );

Map<String, dynamic> _$$BrowserStatsImplToJson(_$BrowserStatsImpl instance) =>
    <String, dynamic>{
      'totalPagesVisited': instance.totalPagesVisited,
      'totalVisitDuration': instance.totalVisitDuration,
      'dataUsage': instance.dataUsage,
      'bookmarkCount': instance.bookmarkCount,
      'historyCount': instance.historyCount,
      'downloadCount': instance.downloadCount,
      'lastVisitedAt': instance.lastVisitedAt?.toIso8601String(),
    };
