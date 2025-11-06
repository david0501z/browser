// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HistoryEntry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryEntryImpl _$$HistoryEntryImplFromJson(Map<String, dynamic> json) =>
    _$HistoryEntryImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      favicon: json['favicon'] as String?,
      visitedAt: DateTime.parse(json['visitedAt'] as String),
      exitAt: json['exitAt'] == null
          ? null
          : DateTime.parse(json['exitAt'] as String),
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      referrer: json['referrer'] as String?,
      deviceType:
          $enumDecodeNullable(_$DeviceTypeEnumMap, json['deviceType']) ??
              DeviceType.unknown,
      userAgent: json['userAgent'] as String?,
      loadStatus:
          $enumDecodeNullable(_$PageLoadStatusEnumMap, json['loadStatus']) ??
              PageLoadStatus.success,
      loadTime: (json['loadTime'] as num?)?.toInt(),
      dataTransferred: (json['dataTransferred'] as num?)?.toInt() ?? 0,
      securityStatus: $enumDecodeNullable(
              _$BrowserSecurityStatusEnumMap, json['securityStatus']) ??
          BrowserSecurityStatus.unknown,
      httpStatusCode: (json['httpStatusCode'] as num?)?.toInt(),
      errorMessage: json['errorMessage'] as String?,
      pageType: $enumDecodeNullable(_$PageTypeEnumMap, json['pageType']) ??
          PageType.webpage,
      searchQuery: json['searchQuery'] as String?,
      isNewTab: json['isNewTab'] as bool? ?? false,
      isFromBookmark: json['isFromBookmark'] as bool? ?? false,
      thumbnail: json['thumbnail'] as String?,
      pageLanguage: json['pageLanguage'] as String?,
      geoLocation: json['geoLocation'] as String?,
    );

Map<String, dynamic> _$$HistoryEntryImplToJson(_$HistoryEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'favicon': instance.favicon,
      'visitedAt': instance.visitedAt.toIso8601String(),
      'exitAt': instance.exitAt?.toIso8601String(),
      'duration': instance.duration,
      'referrer': instance.referrer,
      'deviceType': _$DeviceTypeEnumMap[instance.deviceType]!,
      'userAgent': instance.userAgent,
      'loadStatus': _$PageLoadStatusEnumMap[instance.loadStatus]!,
      'loadTime': instance.loadTime,
      'dataTransferred': instance.dataTransferred,
      'securityStatus':
          _$BrowserSecurityStatusEnumMap[instance.securityStatus]!,
      'httpStatusCode': instance.httpStatusCode,
      'errorMessage': instance.errorMessage,
      'pageType': _$PageTypeEnumMap[instance.pageType]!,
      'searchQuery': instance.searchQuery,
      'isNewTab': instance.isNewTab,
      'isFromBookmark': instance.isFromBookmark,
      'thumbnail': instance.thumbnail,
      'pageLanguage': instance.pageLanguage,
      'geoLocation': instance.geoLocation,
    };

const _$DeviceTypeEnumMap = {
  DeviceType.unknown: 'unknown',
  DeviceType.desktop: 'desktop',
  DeviceType.mobile: 'mobile',
  DeviceType.tablet: 'tablet',
};

const _$PageLoadStatusEnumMap = {
  PageLoadStatus.success: 'success',
  PageLoadStatus.failed: 'failed',
  PageLoadStatus.timeout: 'timeout',
  PageLoadStatus.cancelled: 'cancelled',
  PageLoadStatus.networkError: 'networkError',
};

const _$BrowserSecurityStatusEnumMap = {
  BrowserSecurityStatus.unknown: 'unknown',
  BrowserSecurityStatus.secure: 'secure',
  BrowserSecurityStatus.insecure: 'insecure',
  BrowserSecurityStatus.mixedContent: 'mixedContent',
  BrowserSecurityStatus.certificateError: 'certificateError',
};

const _$PageTypeEnumMap = {
  PageType.webpage: 'webpage',
  PageType.searchResults: 'searchResults',
  PageType.image: 'image',
  PageType.video: 'video',
  PageType.document: 'document',
  PageType.email: 'email',
  PageType.socialMedia: 'socialMedia',
  PageType.shopping: 'shopping',
  PageType.news: 'news',
  PageType.blog: 'blog',
};
