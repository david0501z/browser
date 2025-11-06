// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../BrowserTab.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BrowserTab _$$_BrowserTabFromJson(Map<String, dynamic> json) =>
    _$_BrowserTab(
      id: json['id'] as String,
      url: json['url'] as String,
      title: json['title'] as String,
      favicon: json['favicon'] as String?,
      pinned: json['pinned'] as bool? ?? false,
      incognito: json['incognito'] as bool? ?? false,
      isLoading: json['isLoading'] as bool? ?? false,
      canGoForward: json['canGoForward'] as bool? ?? false,
      canGoBack: json['canGoBack'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      visitCount: json['visitCount'] as int? ?? 0,
      thumbnail: json['thumbnail'] as String?,
      progress: json['progress'] as int? ?? 0,
      securityStatus: BrowserSecurityStatus.values.byName(json['securityStatus'] as String),
      errorMessage: json['errorMessage'] as String?,
      customTitle: json['customTitle'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$_BrowserTabToJson(_$_BrowserTab instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'title': instance.title,
      'favicon': instance.favicon,
      'pinned': instance.pinned,
      'incognito': instance.incognito,
      'isLoading': instance.isLoading,
      'canGoForward': instance.canGoForward,
      'canGoBack': instance.canGoBack,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'visitCount': instance.visitCount,
      'thumbnail': instance.thumbnail,
      'progress': instance.progress,
      'securityStatus': instance.securityStatus.name,
      'errorMessage': instance.errorMessage,
      'customTitle': instance.customTitle,
      'note': instance.note,
    };
