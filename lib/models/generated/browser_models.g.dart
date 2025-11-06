// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../browser_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BrowserTab _$$_BrowserTabFromJson(Map<String, dynamic> json) =>
    _$_BrowserTab(
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

Map<String, dynamic> _$$_BrowserTabToJson(_$_BrowserTab instance) =>
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

_$_Bookmark _$$_BookmarkFromJson(Map<String, dynamic> json) =>
    _$_Bookmark(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      favicon: json['favicon'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      visitCount: json['visitCount'] as int? ?? 0,
      lastVisitedAt: json['lastVisitedAt'] == null;
          ? null
          : DateTime.parse(json['lastVisitedAt'] as String),
    );

Map<String, dynamic> _$$_BookmarkToJson(_$_Bookmark instance) =>
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

_$_History _$$_HistoryFromJson(Map<String, dynamic> json) =>
    _$_History(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      visitedAt: DateTime.parse(json['visitedAt'] as String),
      duration: json['duration'] as int? ?? 0,
      favicon: json['favicon'] as String?,
      referrer: json['referrer'] as String?,
      deviceType: json['deviceType'] as String? ?? 'mobile',
    );

Map<String, dynamic> _$$_HistoryToJson(_$_History instance) =>
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

_$_BrowserSettings _$$_BrowserSettingsFromJson(Map<String, dynamic> json) =>
    _$_BrowserSettings(
      userAgent: json['userAgent'] as String?,
      javascriptEnabled: json['javascriptEnabled'] as bool? ?? true,
      domStorageEnabled: json['domStorageEnabled'] as bool? ?? true,
      cacheMode: json['cacheMode'] as String? ?? 'default',
      incognito: json['incognito'] as bool? ?? false,
      fontSize: json['fontSize'] as int? ?? 16,
      imagesEnabled: json['imagesEnabled'] as bool? ?? true,
      popupsEnabled: json['popupsEnabled'] as bool? ?? true,
      searchEngine: json['searchEngine'] as String? ?? 'https://www.google.com/search?q=',
      homepage: json['homepage'] as String? ?? 'https://www.google.com',
      downloadDirectory: json['downloadDirectory'] as String?,
      downloadNotifications: json['downloadNotifications'] as bool? ?? true,
      privacyMode: json['privacyMode'] as bool? ?? false,
      autoClearData: json['autoClearData'] as bool? ?? false,
      clearDataInterval: json['clearDataInterval'] as int? ?? 24,
    );

Map<String, dynamic> _$$_BrowserSettingsToJson(_$_BrowserSettings instance) =>
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

_$_BrowserEvent _$$_BrowserEventFromJson(Map<String, dynamic> json) =>
    _$_BrowserEvent(
      type: BrowserEventType.values.byName(json['type'] as String),
      tabId: json['tabId'] as String,
      data: json['data'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$_BrowserEventToJson(_$_BrowserEvent instance) =>
    <String, dynamic>{
      'type': instance.type.name,
      'tabId': instance.tabId,
      'data': instance.data,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_$_SearchResult _$$_SearchResultFromJson(Map<String, dynamic> json) =>
    _$_SearchResult(
      title: json['title'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
      favicon: json['favicon'] as String?,
      score: (json['score'] as num).toDouble(),
    );

Map<String, dynamic> _$$_SearchResultToJson(_$_SearchResult instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'favicon': instance.favicon,
      'score': instance.score,
    };

_$_DownloadTask _$$_DownloadTaskFromJson(Map<String, dynamic> json) =>
    _$_DownloadTask(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      url: json['url'] as String,
      savePath: json['savePath'] as String,
      totalBytes: json['totalBytes'] as int? ?? 0,
      downloadedBytes: json['downloadedBytes'] as int? ?? 0,
      progress: (json['progress'] as num).toDouble(),
      speed: json['speed'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null;
          ? null
          : DateTime.parse(json['completedAt'] as String),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$_DownloadTaskToJson(_$_DownloadTask instance) =>
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

_$_BrowserStats _$$_BrowserStatsFromJson(Map<String, dynamic> json) =>
    _$_BrowserStats(
      totalPagesVisited: json['totalPagesVisited'] as int? ?? 0,
      totalVisitDuration: json['totalVisitDuration'] as int? ?? 0,
      dataUsage: json['dataUsage'] as int? ?? 0,
      bookmarkCount: json['bookmarkCount'] as int? ?? 0,
      historyCount: json['historyCount'] as int? ?? 0,
      downloadCount: json['downloadCount'] as int? ?? 0,
      lastVisitedAt: json['lastVisitedAt'] == null;
          ? null
          : DateTime.parse(json['lastVisitedAt'] as String),
    );

Map<String, dynamic> _$$_BrowserStatsToJson(_$_BrowserStats instance) =>
    <String, dynamic>{
      'totalPagesVisited': instance.totalPagesVisited,
      'totalVisitDuration': instance.totalVisitDuration,
      'dataUsage': instance.dataUsage,
      'bookmarkCount': instance.bookmarkCount,
      'historyCount': instance.historyCount,
      'downloadCount': instance.downloadCount,
      'lastVisitedAt': instance.lastVisitedAt?.toIso8601String(),
    };
