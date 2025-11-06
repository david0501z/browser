// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../HistoryEntry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_HistoryEntry _$$_HistoryEntryFromJson(Map<String, dynamic> json) =>
    _$_HistoryEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      favicon: json['favicon'] as String?,
      visitedAt: DateTime.parse(json['visitedAt'] as String),
      exitAt: json['exitAt'] == null;
          ? null
          : DateTime.parse(json['exitAt'] as String),
      duration: json['duration'] as int? ?? 0,
      referrer: json['referrer'] as String?,
      deviceType: DeviceType.values.byName(json['deviceType'] as String),
      userAgent: json['userAgent'] as String?,
      loadStatus: PageLoadStatus.values.byName(json['loadStatus'] as String),
      loadTime: json['loadTime'] as int?,
      dataTransferred: json['dataTransferred'] as int? ?? 0,
      securityStatus: BrowserSecurityStatus.values.byName(json['securityStatus'] as String),
      httpStatusCode: json['httpStatusCode'] as int?,
      errorMessage: json['errorMessage'] as String?,
      pageType: PageType.values.byName(json['pageType'] as String),
      searchQuery: json['searchQuery'] as String?,
      isNewTab: json['isNewTab'] as bool? ?? false,
      isFromBookmark: json['isFromBookmark'] as bool? ?? false,
      thumbnail: json['thumbnail'] as String?,
      pageLanguage: json['pageLanguage'] as String?,
      geoLocation: json['geoLocation'] as String?,
    );

Map<String, dynamic> _$$_HistoryEntryToJson(_$_HistoryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'favicon': instance.favicon,
      'visitedAt': instance.visitedAt.toIso8601String(),
      'exitAt': instance.exitAt?.toIso8601String(),
      'duration': instance.duration,
      'referrer': instance.referrer,
      'deviceType': instance.deviceType.name,
      'userAgent': instance.userAgent,
      'loadStatus': instance.loadStatus.name,
      'loadTime': instance.loadTime,
      'dataTransferred': instance.dataTransferred,
      'securityStatus': instance.securityStatus.name,
      'httpStatusCode': instance.httpStatusCode,
      'errorMessage': instance.errorMessage,
      'pageType': instance.pageType.name,
      'searchQuery': instance.searchQuery,
      'isNewTab': instance.isNewTab,
      'isFromBookmark': instance.isFromBookmark,
      'thumbnail': instance.thumbnail,
      'pageLanguage': instance.pageLanguage,
      'geoLocation': instance.geoLocation,
    };
