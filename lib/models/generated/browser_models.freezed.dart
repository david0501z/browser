// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:freezed_annotation/freezed_annotation.dart';

part of '../browser_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

_$BrowserTabCopyWith _$BrowserTabCopyWithImpl(
    _BrowserTab value, $Res Function(_BrowserTab) then) {
  return _$_BrowserTabCopyWithImpl(value, then);
}

abstract class _$BrowserTabCopyWith<$Res> {
  factory _$BrowserTabCopyWith(
          _BrowserTab value, $Res Function(_BrowserTab) then) =
      $_BrowserTabCopyWithImpl<$Res>;
  $Res call(
      {String id, String url, String? title, String? favicon, bool pinned, DateTime createdAt, DateTime updatedAt, String? thumbnail, bool incognito});
}

class _$_BrowserTabCopyWithImpl<$Res> implements _$BrowserTabCopyWith<$Res> {
  _$_BrowserTabCopyWithImpl(this._value, this._then);

  final _BrowserTab _value;
  final $Res Function(_BrowserTab) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
    Object? title = freezed,
    Object? favicon = freezed,
    Object? pinned = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? thumbnail = freezed,
    Object? incognito = freezed,
  }) {
    return _then(_BrowserTab(
      id: id == freezed ? _value.id : id as String,
      url: url == freezed ? _value.url : url as String,
      title: title == freezed ? _value.title : title as String?,
      favicon: favicon == freezed ? _value.favicon : favicon as String?,
      pinned: pinned == freezed ? _value.pinned : pinned as bool,
      createdAt: createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      updatedAt: updatedAt == freezed ? _value.updatedAt : updatedAt as DateTime,
      thumbnail: thumbnail == freezed ? _value.thumbnail : thumbnail as String?,
      incognito: incognito == freezed ? _value.incognito : incognito as bool,
    ));
  }
}

@override
abstract class _$$_BrowserTabCopyWith<$Res> implements _$BrowserTabCopyWith<$Res> {
  factory _$$_BrowserTabCopyWith(
          _$_BrowserTab value, $Res Function(_$_BrowserTab) then) =
      __$$_BrowserTabCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id, String url, String? title, String? favicon, bool pinned, DateTime createdAt, DateTime updatedAt, String? thumbnail, bool incognito});
}

class __$$_BrowserTabCopyWithImpl<$Res> extends _$_BrowserTabCopyWithImpl<$Res>
    implements _$$_BrowserTabCopyWith<$Res> {
  __$$_BrowserTabCopyWithImpl(_$_BrowserTab _value, $Res Function(_$_BrowserTab) _then)
      : super(_value, _then);

  @override
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
    Object? title = freezed,
    Object? favicon = freezed,
    Object? pinned = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? thumbnail = freezed,
    Object? incognito = freezed,
  }) {
    return _then(_$_BrowserTab(
      id: id == freezed ? _value.id : id as String,
      url: url == freezed ? _value.url : url as String,
      title: title == freezed ? _value.title : title as String?,
      favicon: favicon == freezed ? _value.favicon : favicon as String?,
      pinned: pinned == freezed ? _value.pinned : pinned as bool,
      createdAt: createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      updatedAt: updatedAt == freezed ? _value.updatedAt : updatedAt as DateTime,
      thumbnail: thumbnail == freezed ? _value.thumbnail : thumbnail as String?,
      incognito: incognito == freezed ? _value.incognito : incognito as bool,
    ));
  }
}

/// @nodoc
@override
class _$_BrowserTab implements _BrowserTab {
  const _$_BrowserTab(
      {required this.id,
      required this.url,
      this.title,
      this.favicon,
      this.pinned = false,
      required this.createdAt,
      required this.updatedAt,
      this.thumbnail,
      this.incognito = false});

  factory _$_BrowserTab.fromJson(Map<String, dynamic> json) =>
      _$$_BrowserTabFromJson(json);

  @override
  final String id;
  @override
  final String url;
  @override
  final String? title;
  @override
  final String? favicon;
  @override
  final bool pinned;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? thumbnail;
  @override
  final bool incognito;

  @override
  String toString() {
    return 'BrowserTab(id: $id, url: $url, title: $title, favicon: $favicon, pinned: $pinned, createdAt: $createdAt, updatedAt: $updatedAt, thumbnail: $thumbnail, incognito: $incognito)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BrowserTab &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.favicon, favicon) || other.favicon == favicon) &&
            (identical(other.pinned, pinned) || other.pinned == pinned) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail) &&
            (identical(other.incognito, incognito) || other.incognito == incognito));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, url, title, favicon, pinned, createdAt, updatedAt, thumbnail, incognito);

  @override
  _$$_BrowserTabCopyWith<_$_BrowserTab> get copyWith =>
      __$$_BrowserTabCopyWithImpl<_$_BrowserTab>(this, _$identity);
}

abstract class _BrowserTab implements BrowserTab {
  const factory _BrowserTab(
      {required String id,
      required String url,
      String? title,
      String? favicon,
      bool pinned,
      required DateTime createdAt,
      required DateTime updatedAt,
      String? thumbnail,
      bool incognito}) = _$_BrowserTab;

  factory _BrowserTab.fromJson(Map<String, dynamic> json) =
      _$_BrowserTab.fromJson;

  @override
  String get id;
  @override
  String get url;
  @override
  String? get title;
  @override
  String? get favicon;
  @override
  bool get pinned;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get thumbnail;
  @override
  bool get incognito;
  @override
  @override
  _$$_BrowserTabCopyWith<_$_BrowserTab> get copyWith;
}

_$BookmarkCopyWith _$BookmarkCopyWithImpl(
    _Bookmark value, $Res Function(_Bookmark) then) {
  return _$_BookmarkCopyWithImpl(value, then);
}

abstract class _$BookmarkCopyWith<$Res> {
  factory _$BookmarkCopyWith(_Bookmark value, $Res Function(_Bookmark) then) =
      $_BookmarkCopyWithImpl<$Res>;
  $Res call(
      {String id, String title, String url, String? favicon, List<String> tags, DateTime createdAt, DateTime updatedAt, int visitCount, DateTime? lastVisitedAt});
}

class _$_BookmarkCopyWithImpl<$Res> implements _$BookmarkCopyWith<$Res> {
  _$_BookmarkCopyWithImpl(this._value, this._then);

  final _Bookmark _value;
  final $Res Function(_Bookmark) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? url = freezed,
    Object? favicon = freezed,
    Object? tags = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? visitCount = freezed,
    Object? lastVisitedAt = freezed,
  }) {
    return _then(_Bookmark(
      id: id == freezed ? _value.id : id as String,
      title: title == freezed ? _value.title : title as String,
      url: url == freezed ? _value.url : url as String,
      favicon: favicon == freezed ? _value.favicon : favicon as String?,
      tags: tags == freezed ? _value.tags : tags as List<String>,
      createdAt: createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      updatedAt: updatedAt == freezed ? _value.updatedAt : updatedAt as DateTime,
      visitCount: visitCount == freezed ? _value.visitCount : visitCount as int,
      lastVisitedAt: lastVisitedAt == freezed
          ? _value.lastVisitedAt
          : lastVisitedAt as DateTime?,
    ));
  }
}

@override
abstract class _$$_BookmarkCopyWith<$Res> implements _$BookmarkCopyWith<$Res> {
  factory _$$_BookmarkCopyWith(
          _$_Bookmark value, $Res Function(_$_Bookmark) then) =
      __$$_BookmarkCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id, String title, String url, String? favicon, List<String> tags, DateTime createdAt, DateTime updatedAt, int visitCount, DateTime? lastVisitedAt});
}

class __$$_BookmarkCopyWithImpl<$Res> extends _$_BookmarkCopyWithImpl<$Res>
    implements _$$_BookmarkCopyWith<$Res> {
  __$$_BookmarkCopyWithImpl(_$_Bookmark _value, $Res Function(_$_Bookmark) _then)
      : super(_value, _then);

  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? url = freezed,
    Object? favicon = freezed,
    Object? tags = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? visitCount = freezed,
    Object? lastVisitedAt = freezed,
  }) {
    return _then(_$_Bookmark(
      id: id == freezed ? _value.id : id as String,
      title: title == freezed ? _value.title : title as String,
      url: url == freezed ? _value.url : url as String,
      favicon: favicon == freezed ? _value.favicon : favicon as String?,
      tags: tags == freezed ? _value.tags : tags as List<String>,
      createdAt: createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      updatedAt: updatedAt == freezed ? _value.updatedAt : updatedAt as DateTime,
      visitCount: visitCount == freezed ? _value.visitCount : visitCount as int,
      lastVisitedAt: lastVisitedAt == freezed
          ? _value.lastVisitedAt
          : lastVisitedAt as DateTime?,
    ));
  }
}

/// @nodoc
@override
class _$_Bookmark implements _Bookmark {
  const _$_Bookmark(
      {required this.id,
      required this.title,
      required this.url,
      this.favicon,
      this.tags = const [],
      required this.createdAt,
      required this.updatedAt,
      this.visitCount = 0,
      this.lastVisitedAt});

  factory _$_Bookmark.fromJson(Map<String, dynamic> json) =>
      _$$_BookmarkFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String url;
  @override
  final String? favicon;
  @override
  final List<String> tags;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int visitCount;
  @override
  final DateTime? lastVisitedAt;

  @override
  String toString() {
    return 'Bookmark(id: $id, title: $title, url: $url, favicon: $favicon, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, visitCount: $visitCount, lastVisitedAt: $lastVisitedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Bookmark &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.favicon, favicon) || other.favicon == favicon) &&
            (identical(other.tags, tags) || other.tags == tags) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.visitCount, visitCount) || other.visitCount == visitCount) &&
            (identical(other.lastVisitedAt, lastVisitedAt) ||
                other.lastVisitedAt == lastVisitedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, url, favicon, Object.hashAll(tags), createdAt, updatedAt, visitCount, lastVisitedAt);

  @override
  _$$_BookmarkCopyWith<_$_Bookmark> get copyWith =>
      __$$_BookmarkCopyWithImpl<_$_Bookmark>(this, _$identity);
}

abstract class _Bookmark implements Bookmark {
  const factory _Bookmark(
      {required String id,
      required String title,
      required String url,
      String? favicon,
      List<String> tags,
      required DateTime createdAt,
      required DateTime updatedAt,
      int visitCount,
      DateTime? lastVisitedAt}) = _$_Bookmark;

  factory _Bookmark.fromJson(Map<String, dynamic> json) =
      _$_Bookmark.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get url;
  @override
  String? get favicon;
  @override
  List<String> get tags;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  int get visitCount;
  @override
  DateTime? get lastVisitedAt;
  @override
  @override
  _$$_BookmarkCopyWith<_$_Bookmark> get copyWith;
}

_$HistoryCopyWith _$HistoryCopyWithImpl(_History value, $Res Function(_History) then) {
  return _$_HistoryCopyWithImpl(value, then);
}

abstract class _$HistoryCopyWith<$Res> {
  factory _$HistoryCopyWith(_History value, $Res Function(_History) then) =
      $_HistoryCopyWithImpl<$Res>;
  $Res call(
      {String id, String title, String url, DateTime visitedAt, int duration, String? favicon, String? referrer, String deviceType});
}

class _$_HistoryCopyWithImpl<$Res> implements _$HistoryCopyWith<$Res> {
  _$_HistoryCopyWithImpl(this._value, this._then);

  final _History _value;
  final $Res Function(_History) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? url = freezed,
    Object? visitedAt = freezed,
    Object? duration = freezed,
    Object? favicon = freezed,
    Object? referrer = freezed,
    Object? deviceType = freezed,
  }) {
    return _then(_History(
      id: id == freezed ? _value.id : id as String,
      title: title == freezed ? _value.title : title as String,
      url: url == freezed ? _value.url : url as String,
      visitedAt: visitedAt == freezed ? _value.visitedAt : visitedAt as DateTime,
      duration: duration == freezed ? _value.duration : duration as int,
      favicon: favicon == freezed ? _value.favicon : favicon as String?,
      referrer: referrer == freezed ? _value.referrer : referrer as String?,
      deviceType: deviceType == freezed ? _value.deviceType : deviceType as String,
    ));
  }
}

@override
abstract class _$$_HistoryCopyWith<$Res> implements _$HistoryCopyWith<$Res> {
  factory _$$_HistoryCopyWith(_$_History value, $Res Function(_$_History) then) =
      __$$_HistoryCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id, String title, String url, DateTime visitedAt, int duration, String? favicon, String? referrer, String deviceType});
}

class __$$_HistoryCopyWithImpl<$Res> extends _$_HistoryCopyWithImpl<$Res>
    implements _$$_HistoryCopyWith<$Res> {
  __$$_HistoryCopyWithImpl(_$_History _value, $Res Function(_$_History) _then)
      : super(_value, _then);

  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? url = freezed,
    Object? visitedAt = freezed,
    Object? duration = freezed,
    Object? favicon = freezed,
    Object? referrer = freezed,
    Object? deviceType = freezed,
  }) {
    return _then(_$_History(
      id: id == freezed ? _value.id : id as String,
      title: title == freezed ? _value.title : title as String,
      url: url == freezed ? _value.url : url as String,
      visitedAt: visitedAt == freezed ? _value.visitedAt : visitedAt as DateTime,
      duration: duration == freezed ? _value.duration : duration as int,
      favicon: favicon == freezed ? _value.favicon : favicon as String?,
      referrer: referrer == freezed ? _value.referrer : referrer as String?,
      deviceType: deviceType == freezed ? _value.deviceType : deviceType as String,
    ));
  }
}

/// @nodoc
@override
class _$_History implements _History {
  const _$_History(
      {required this.id,
      required this.title,
      required this.url,
      required this.visitedAt,
      this.duration = 0,
      this.favicon,
      this.referrer,
      this.deviceType = 'mobile'});

  factory _$_History.fromJson(Map<String, dynamic> json) =>
      _$$_HistoryFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String url;
  @override
  final DateTime visitedAt;
  @override
  final int duration;
  @override
  final String? favicon;
  @override
  final String? referrer;
  @override
  final String deviceType;

  @override
  String toString() {
    return 'History(id: $id, title: $title, url: $url, visitedAt: $visitedAt, duration: $duration, favicon: $favicon, referrer: $referrer, deviceType: $deviceType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_History &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.visitedAt, visitedAt) || other.visitedAt == visitedAt) &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.favicon, favicon) || other.favicon == favicon) &&
            (identical(other.referrer, referrer) || other.referrer == referrer) &&
            (identical(other.deviceType, deviceType) || other.deviceType == deviceType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, url, visitedAt, duration, favicon, referrer, deviceType);

  @override
  _$$_HistoryCopyWith<_$_History> get copyWith =>
      __$$_HistoryCopyWithImpl<_$_History>(this, _$identity);
}

abstract class _History implements History {
  const factory _History(
      {required String id,
      required String title,
      required String url,
      required DateTime visitedAt,
      int duration,
      String? favicon,
      String? referrer,
      String deviceType}) = _$_History;

  factory _History.fromJson(Map<String, dynamic> json) =
      _$_History.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get url;
  @override
  DateTime get visitedAt;
  @override
  int get duration;
  @override
  String? get favicon;
  @override
  String? get referrer;
  @override
  String get deviceType;
  @override
  @override
  _$$_HistoryCopyWith<_$_History> get copyWith;
}

_$BrowserSettingsCopyWith _$BrowserSettingsCopyWithImpl(
    _BrowserSettings value, $Res Function(_BrowserSettings) then) {
  return _$_BrowserSettingsCopyWithImpl(value, then);
}

abstract class _$BrowserSettingsCopyWith<$Res> {
  factory _$BrowserSettingsCopyWith(
          _BrowserSettings value, $Res Function(_BrowserSettings) then) =
      $_BrowserSettingsCopyWithImpl<$Res>;
  $Res call(
      {String? userAgent,
      bool javascriptEnabled,
      bool domStorageEnabled,
      String cacheMode,
      bool incognito,
      int fontSize,
      bool imagesEnabled,
      bool popupsEnabled,
      String searchEngine,
      String homepage,
      String? downloadDirectory,
      bool downloadNotifications,
      bool privacyMode,
      bool autoClearData,
      int clearDataInterval});
}

class _$_BrowserSettingsCopyWithImpl<$Res>
    implements _$BrowserSettingsCopyWith<$Res> {
  _$_BrowserSettingsCopyWithImpl(this._value, this._then);

  final _BrowserSettings _value;
  final $Res Function(_BrowserSettings) _then;

  @override
  $Res call({
    Object? userAgent = freezed,
    Object? javascriptEnabled = freezed,
    Object? domStorageEnabled = freezed,
    Object? cacheMode = freezed,
    Object? incognito = freezed,
    Object? fontSize = freezed,
    Object? imagesEnabled = freezed,
    Object? popupsEnabled = freezed,
    Object? searchEngine = freezed,
    Object? homepage = freezed,
    Object? downloadDirectory = freezed,
    Object? downloadNotifications = freezed,
    Object? privacyMode = freezed,
    Object? autoClearData = freezed,
    Object? clearDataInterval = freezed,
  }) {
    return _then(_BrowserSettings(
      userAgent: userAgent == freezed ? _value.userAgent : userAgent as String?,
      javascriptEnabled: javascriptEnabled == freezed
          ? _value.javascriptEnabled
          : javascriptEnabled as bool,
      domStorageEnabled: domStorageEnabled == freezed
          ? _value.domStorageEnabled
          : domStorageEnabled as bool,
      cacheMode: cacheMode == freezed ? _value.cacheMode : cacheMode as String,
      incognito: incognito == freezed ? _value.incognito : incognito as bool,
      fontSize: fontSize == freezed ? _value.fontSize : fontSize as int,
      imagesEnabled: imagesEnabled == freezed
          ? _value.imagesEnabled
          : imagesEnabled as bool,
      popupsEnabled: popupsEnabled == freezed
          ? _value.popupsEnabled
          : popupsEnabled as bool,
      searchEngine: searchEngine == freezed
          ? _value.searchEngine
          : searchEngine as String,
      homepage: homepage == freezed ? _value.homepage : homepage as String,
      downloadDirectory: downloadDirectory == freezed
          ? _value.downloadDirectory
          : downloadDirectory as String?,
      downloadNotifications: downloadNotifications == freezed
          ? _value.downloadNotifications
          : downloadNotifications as bool,
      privacyMode: privacyMode == freezed
          ? _value.privacyMode
          : privacyMode as bool,
      autoClearData: autoClearData == freezed
          ? _value.autoClearData
          : autoClearData as bool,
      clearDataInterval: clearDataInterval == freezed
          ? _value.clearDataInterval
          : clearDataInterval as int,
    ));
  }
}

@override
abstract class _$$_BrowserSettingsCopyWith<$Res>
    implements _$BrowserSettingsCopyWith<$Res> {
  factory _$$_BrowserSettingsCopyWith(
          _$_BrowserSettings value, $Res Function(_$_BrowserSettings) then) =
      __$$_BrowserSettingsCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? userAgent,
      bool javascriptEnabled,
      bool domStorageEnabled,
      String cacheMode,
      bool incognito,
      int fontSize,
      bool imagesEnabled,
      bool popupsEnabled,
      String searchEngine,
      String homepage,
      String? downloadDirectory,
      bool downloadNotifications,
      bool privacyMode,
      bool autoClearData,
      int clearDataInterval});
}

class __$$_BrowserSettingsCopyWithImpl<$Res>
    extends _$_BrowserSettingsCopyWithImpl<$Res>
    implements _$$_BrowserSettingsCopyWith<$Res> {
  __$$_BrowserSettingsCopyWithImpl(
      _$_BrowserSettings _value, $Res Function(_$_BrowserSettings) _then)
      : super(_value, _then);

  @override
  $Res call({
    Object? userAgent = freezed,
    Object? javascriptEnabled = freezed,
    Object? domStorageEnabled = freezed,
    Object? cacheMode = freezed,
    Object? incognito = freezed,
    Object? fontSize = freezed,
    Object? imagesEnabled = freezed,
    Object? popupsEnabled = freezed,
    Object? searchEngine = freezed,
    Object? homepage = freezed,
    Object? downloadDirectory = freezed,
    Object? downloadNotifications = freezed,
    Object? privacyMode = freezed,
    Object? autoClearData = freezed,
    Object? clearDataInterval = freezed,
  }) {
    return _then(_$_BrowserSettings(
      userAgent: userAgent == freezed ? _value.userAgent : userAgent as String?,
      javascriptEnabled: javascriptEnabled == freezed
          ? _value.javascriptEnabled
          : javascriptEnabled as bool,
      domStorageEnabled: domStorageEnabled == freezed
          ? _value.domStorageEnabled
          : domStorageEnabled as bool,
      cacheMode: cacheMode == freezed ? _value.cacheMode : cacheMode as String,
      incognito: incognito == freezed ? _value.incognito : incognito as bool,
      fontSize: fontSize == freezed ? _value.fontSize : fontSize as int,
      imagesEnabled: imagesEnabled == freezed
          ? _value.imagesEnabled
          : imagesEnabled as bool,
      popupsEnabled: popupsEnabled == freezed
          ? _value.popupsEnabled
          : popupsEnabled as bool,
      searchEngine: searchEngine == freezed
          ? _value.searchEngine
          : searchEngine as String,
      homepage: homepage == freezed ? _value.homepage : homepage as String,
      downloadDirectory: downloadDirectory == freezed
          ? _value.downloadDirectory
          : downloadDirectory as String?,
      downloadNotifications: downloadNotifications == freezed
          ? _value.downloadNotifications
          : downloadNotifications as bool,
      privacyMode: privacyMode == freezed
          ? _value.privacyMode
          : privacyMode as bool,
      autoClearData: autoClearData == freezed
          ? _value.autoClearData
          : autoClearData as bool,
      clearDataInterval: clearDataInterval == freezed
          ? _value.clearDataInterval
          : clearDataInterval as int,
    ));
  }
}

/// @nodoc
@override
class _$_BrowserSettings implements _BrowserSettings {
  const _$_BrowserSettings(
      {this.userAgent,
      this.javascriptEnabled = true,
      this.domStorageEnabled = true,
      this.cacheMode = 'default',
      this.incognito = false,
      this.fontSize = 16,
      this.imagesEnabled = true,
      this.popupsEnabled = true,
      this.searchEngine = 'https://www.google.com/search?q=',
      this.homepage = 'https://www.google.com',
      this.downloadDirectory,
      this.downloadNotifications = true,
      this.privacyMode = false,
      this.autoClearData = false,
      this.clearDataInterval = 24});

  factory _$_BrowserSettings.fromJson(Map<String, dynamic> json) =>
      _$$_BrowserSettingsFromJson(json);

  @override
  final String? userAgent;
  @override
  final bool javascriptEnabled;
  @override
  final bool domStorageEnabled;
  @override
  final String cacheMode;
  @override
  final bool incognito;
  @override
  final int fontSize;
  @override
  final bool imagesEnabled;
  @override
  final bool popupsEnabled;
  @override
  final String searchEngine;
  @override
  final String homepage;
  @override
  final String? downloadDirectory;
  @override
  final bool downloadNotifications;
  @override
  final bool privacyMode;
  @override
  final bool autoClearData;
  @override
  final int clearDataInterval;

  @override
  String toString() {
    return 'BrowserSettings(userAgent: $userAgent, javascriptEnabled: $javascriptEnabled, domStorageEnabled: $domStorageEnabled, cacheMode: $cacheMode, incognito: $incognito, fontSize: $fontSize, imagesEnabled: $imagesEnabled, popupsEnabled: $popupsEnabled, searchEngine: $searchEngine, homepage: $homepage, downloadDirectory: $downloadDirectory, downloadNotifications: $downloadNotifications, privacyMode: $privacyMode, autoClearData: $autoClearData, clearDataInterval: $clearDataInterval)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BrowserSettings &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.javascriptEnabled, javascriptEnabled) ||
                other.javascriptEnabled == javascriptEnabled) &&
            (identical(other.domStorageEnabled, domStorageEnabled) ||
                other.domStorageEnabled == domStorageEnabled) &&
            (identical(other.cacheMode, cacheMode) || other.cacheMode == cacheMode) &&
            (identical(other.incognito, incognito) || other.incognito == incognito) &&
            (identical(other.fontSize, fontSize) || other.fontSize == fontSize) &&
            (identical(other.imagesEnabled, imagesEnabled) ||
                other.imagesEnabled == imagesEnabled) &&
            (identical(other.popupsEnabled, popupsEnabled) ||
                other.popupsEnabled == popupsEnabled) &&
            (identical(other.searchEngine, searchEngine) ||
                other.searchEngine == searchEngine) &&
            (identical(other.homepage, homepage) || other.homepage == homepage) &&
            (identical(other.downloadDirectory, downloadDirectory) ||
                other.downloadDirectory == downloadDirectory) &&
            (identical(other.downloadNotifications, downloadNotifications) ||
                other.downloadNotifications == downloadNotifications) &&
            (identical(other.privacyMode, privacyMode) ||
                other.privacyMode == privacyMode) &&
            (identical(other.autoClearData, autoClearData) ||
                other.autoClearData == autoClearData) &&
            (identical(other.clearDataInterval, clearDataInterval) ||
                other.clearDataInterval == clearDataInterval));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      userAgent,
      javascriptEnabled,
      domStorageEnabled,
      cacheMode,
      incognito,
      fontSize,
      imagesEnabled,
      popupsEnabled,
      searchEngine,
      homepage,
      downloadDirectory,
      downloadNotifications,
      privacyMode,
      autoClearData,
      clearDataInterval);

  @override
  _$$_BrowserSettingsCopyWith<_$_BrowserSettings> get copyWith =>
      __$$_BrowserSettingsCopyWithImpl<_$_BrowserSettings>(this, _$identity);
}

abstract class _BrowserSettings implements BrowserSettings {
  const factory _BrowserSettings(
      {String? userAgent,
      bool javascriptEnabled,
      bool domStorageEnabled,
      String cacheMode,
      bool incognito,
      int fontSize,
      bool imagesEnabled,
      bool popupsEnabled,
      String searchEngine,
      String homepage,
      String? downloadDirectory,
      bool downloadNotifications,
      bool privacyMode,
      bool autoClearData,
      int clearDataInterval}) = _$_BrowserSettings;

  factory _BrowserSettings.fromJson(Map<String, dynamic> json) =
      _$_BrowserSettings.fromJson;

  @override
  String? get userAgent;
  @override
  bool get javascriptEnabled;
  @override
  bool get domStorageEnabled;
  @override
  String get cacheMode;
  @override
  bool get incognito;
  @override
  int get fontSize;
  @override
  bool get imagesEnabled;
  @override
  bool get popupsEnabled;
  @override
  String get searchEngine;
  @override
  String get homepage;
  @override
  String? get downloadDirectory;
  @override
  bool get downloadNotifications;
  @override
  bool get privacyMode;
  @override
  bool get autoClearData;
  @override
  int get clearDataInterval;
  @override
  @override
  _$$_BrowserSettingsCopyWith<_$_BrowserSettings> get copyWith;
}

_$BrowserEventCopyWith _$BrowserEventCopyWithImpl(
    _BrowserEvent value, $Res Function(_BrowserEvent) then) {
  return _$_BrowserEventCopyWithImpl(value, then);
}

abstract class _$BrowserEventCopyWith<$Res> {
  factory _$BrowserEventCopyWith(
          _BrowserEvent value, $Res Function(_BrowserEvent) then) =
      $_BrowserEventCopyWithImpl<$Res>;
  $Res call(
      {BrowserEventType type, String tabId, Map<String, dynamic>? data, DateTime timestamp});
}

class _$_BrowserEventCopyWithImpl<$Res> implements _$BrowserEventCopyWith<$Res> {
  _$_BrowserEventCopyWithImpl(this._value, this._then);

  final _BrowserEvent _value;
  final $Res Function(_BrowserEvent) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? tabId = freezed,
    Object? data = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_BrowserEvent(
      type: type == freezed ? _value.type : type as BrowserEventType,
      tabId: tabId == freezed ? _value.tabId : tabId as String,
      data: data == freezed ? _value.data : data as Map<String, dynamic>?,
      timestamp: timestamp == freezed ? _value.timestamp : timestamp as DateTime,
    ));
  }
}

@override
abstract class _$$_BrowserEventCopyWith<$Res>
    implements _$BrowserEventCopyWith<$Res> {
  factory _$$_BrowserEventCopyWith(
          _$_BrowserEvent value, $Res Function(_$_BrowserEvent) then) =
      __$$_BrowserEventCopyWithImpl<$Res>;
  @override
  $Res call(
      {BrowserEventType type, String tabId, Map<String, dynamic>? data, DateTime timestamp});
}

class __$$_BrowserEventCopyWithImpl<$Res>
    extends _$_BrowserEventCopyWithImpl<$Res>
    implements _$$_BrowserEventCopyWith<$Res> {
  __$$_BrowserEventCopyWithImpl(
      _$_BrowserEvent _value, $Res Function(_$_BrowserEvent) _then)
      : super(_value, _then);

  @override
  $Res call({
    Object? type = freezed,
    Object? tabId = freezed,
    Object? data = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_$_BrowserEvent(
      type: type == freezed ? _value.type : type as BrowserEventType,
      tabId: tabId == freezed ? _value.tabId : tabId as String,
      data: data == freezed ? _value.data : data as Map<String, dynamic>?,
      timestamp: timestamp == freezed ? _value.timestamp : timestamp as DateTime,
    ));
  }
}

/// @nodoc
@override
class _$_BrowserEvent implements _BrowserEvent {
  const _$_BrowserEvent(
      {required this.type,
      required this.tabId,
      this.data,
      required this.timestamp});

  factory _$_BrowserEvent.fromJson(Map<String, dynamic> json) =>
      _$$_BrowserEventFromJson(json);

  @override
  final BrowserEventType type;
  @override
  final String tabId;
  @override
  final Map<String, dynamic>? data;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'BrowserEvent(type: $type, tabId: $tabId, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BrowserEvent &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.tabId, tabId) || other.tabId == tabId) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, tabId, data, timestamp);

  @override
  _$$_BrowserEventCopyWith<_$_BrowserEvent> get copyWith =>
      __$$_BrowserEventCopyWithImpl<_$_BrowserEvent>(this, _$identity);
}

abstract class _BrowserEvent implements BrowserEvent {
  const factory _BrowserEvent(
      {required BrowserEventType type,
      required String tabId,
      Map<String, dynamic>? data,
      required DateTime timestamp}) = _$_BrowserEvent;

  factory _BrowserEvent.fromJson(Map<String, dynamic> json) =
      _$_BrowserEvent.fromJson;

  @override
  BrowserEventType get type;
  @override
  String get tabId;
  @override
  Map<String, dynamic>? get data;
  @override
  DateTime get timestamp;
  @override
  @override
  _$$_BrowserEventCopyWith<_$_BrowserEvent> get copyWith;
}

_$SearchResultCopyWith _$SearchResultCopyWithImpl(
    _SearchResult value, $Res Function(_SearchResult) then) {
  return _$_SearchResultCopyWithImpl(value, then);
}

abstract class _$SearchResultCopyWith<$Res> {
  factory _$SearchResultCopyWith(
          _SearchResult value, $Res Function(_SearchResult) then) =
      $_SearchResultCopyWithImpl<$Res>;
  $Res call(
      {String title, String? description, String url, String? favicon, double score});
}

class _$_SearchResultCopyWithImpl<$Res>
    implements _$SearchResultCopyWith<$Res> {
  _$_SearchResultCopyWithImpl(this._value, this._then);

  final _SearchResult _value;
  final $Res Function(_SearchResult) _then;

  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? url = freezed,
    Object? favicon = freezed,
    Object? score = freezed,
  }) {
    return _then(_SearchResult(
      title: title == freezed ? _value.title : title as String,
      description: description == freezed ? _value.description : description as String?,
      url: url == freezed ? _value.url : url as String,
      favicon: favicon == freezed ? _value.favicon : favicon as String?,
      score: score == freezed ? _value.score : score as double,
    ));
  }
}

@override
abstract class _$$_SearchResultCopyWith<$Res>
    implements _$SearchResultCopyWith<$Res> {
  factory _$$_SearchResultCopyWith(
          _$_SearchResult value, $Res Function(_$_SearchResult) then) =
      __$$_SearchResultCopyWithImpl<$Res>;
  @override
  $Res call(
      {String title, String? description, String url, String? favicon, double score});
}

class __$$_SearchResultCopyWithImpl<$Res>
    extends _$_SearchResultCopyWithImpl<$Res>
    implements _$$_SearchResultCopyWith<$Res> {
  __$$_SearchResultCopyWithImpl(
      _$_SearchResult _value, $Res Function(_$_SearchResult) _then)
      : super(_value, _then);

  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? url = freezed,
    Object? favicon = freezed,
    Object? score = freezed,
  }) {
    return _then(_$_SearchResult(
      title: title == freezed ? _value.title : title as String,
      description: description == freezed ? _value.description : description as String?,
      url: url == freezed ? _value.url : url as String,
      favicon: favicon == freezed ? _value.favicon : favicon as String?,
      score: score == freezed ? _value.score : score as double,
    ));
  }
}

/// @nodoc
@override
class _$_SearchResult implements _SearchResult {
  const _$_SearchResult(
      {required this.title,
      this.description,
      required this.url,
      this.favicon,
      this.score = 0.0});

  factory _$_SearchResult.fromJson(Map<String, dynamic> json) =>
      _$$_SearchResultFromJson(json);

  @override
  final String title;
  @override
  final String? description;
  @override
  final String url;
  @override
  final String? favicon;
  @override
  final double score;

  @override
  String toString() {
    return 'SearchResult(title: $title, description: $description, url: $url, favicon: $favicon, score: $score)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SearchResult &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.favicon, favicon) || other.favicon == favicon) &&
            (identical(other.score, score) || other.score == score));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, description, url, favicon, score);

  @override
  _$$_SearchResultCopyWith<_$_SearchResult> get copyWith =>
      __$$_SearchResultCopyWithImpl<_$_SearchResult>(this, _$identity);
}

abstract class _SearchResult implements SearchResult {
  const factory _SearchResult(
      {required String title,
      String? description,
      required String url,
      String? favicon,
      double score}) = _$_SearchResult;

  factory _SearchResult.fromJson(Map<String, dynamic> json) =
      _$_SearchResult.fromJson;

  @override
  String get title;
  @override
  String? get description;
  @override
  String get url;
  @override
  String? get favicon;
  @override
  double get score;
  @override
  @override
  _$$_SearchResultCopyWith<_$_SearchResult> get copyWith;
}

_$DownloadTaskCopyWith _$DownloadTaskCopyWithImpl(
    _DownloadTask value, $Res Function(_DownloadTask) then) {
  return _$_DownloadTaskCopyWithImpl(value, then);
}

abstract class _$DownloadTaskCopyWith<$Res> {
  factory _$DownloadTaskCopyWith(
          _DownloadTask value, $Res Function(_DownloadTask) then) =
      $_DownloadTaskCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String fileName,
      String url,
      String savePath,
      int totalBytes,
      int downloadedBytes,
      double progress,
      int speed,
      String status,
      DateTime createdAt,
      DateTime? completedAt,
      String? error});
}

class _$_DownloadTaskCopyWithImpl<$Res>
    implements _$DownloadTaskCopyWith<$Res> {
  _$_DownloadTaskCopyWithImpl(this._value, this._then);

  final _DownloadTask _value;
  final $Res Function(_DownloadTask) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? fileName = freezed,
    Object? url = freezed,
    Object? savePath = freezed,
    Object? totalBytes = freezed,
    Object? downloadedBytes = freezed,
    Object? progress = freezed,
    Object? speed = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? completedAt = freezed,
    Object? error = freezed,
  }) {
    return _then(_DownloadTask(
      id: id == freezed ? _value.id : id as String,
      fileName: fileName == freezed ? _value.fileName : fileName as String,
      url: url == freezed ? _value.url : url as String,
      savePath: savePath == freezed ? _value.savePath : savePath as String,
      totalBytes: totalBytes == freezed ? _value.totalBytes : totalBytes as int,
      downloadedBytes: downloadedBytes == freezed
          ? _value.downloadedBytes
          : downloadedBytes as int,
      progress: progress == freezed ? _value.progress : progress as double,
      speed: speed == freezed ? _value.speed : speed as int,
      status: status == freezed ? _value.status : status as String,
      createdAt: createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      completedAt: completedAt == freezed
          ? _value.completedAt
          : completedAt as DateTime?,
      error: error == freezed ? _value.error : error as String?,
    ));
  }
}

@override
abstract class _$$_DownloadTaskCopyWith<$Res>
    implements _$DownloadTaskCopyWith<$Res> {
  factory _$$_DownloadTaskCopyWith(
          _$_DownloadTask value, $Res Function(_$_DownloadTask) then) =
      __$$_DownloadTaskCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String fileName,
      String url,
      String savePath,
      int totalBytes,
      int downloadedBytes,
      double progress,
      int speed,
      String status,
      DateTime createdAt,
      DateTime? completedAt,
      String? error});
}

class __$$_DownloadTaskCopyWithImpl<$Res>
    extends _$_DownloadTaskCopyWithImpl<$Res>
    implements _$$_DownloadTaskCopyWith<$Res> {
  __$$_DownloadTaskCopyWithImpl(
      _$_DownloadTask _value, $Res Function(_$_DownloadTask) _then)
      : super(_value, _then);

  @override
  $Res call({
    Object? id = freezed,
    Object? fileName = freezed,
    Object? url = freezed,
    Object? savePath = freezed,
    Object? totalBytes = freezed,
    Object? downloadedBytes = freezed,
    Object? progress = freezed,
    Object? speed = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? completedAt = freezed,
    Object? error = freezed,
  }) {
    return _then(_$_DownloadTask(
      id: id == freezed ? _value.id : id as String,
      fileName: fileName == freezed ? _value.fileName : fileName as String,
      url: url == freezed ? _value.url : url as String,
      savePath: savePath == freezed ? _value.savePath : savePath as String,
      totalBytes: totalBytes == freezed ? _value.totalBytes : totalBytes as int,
      downloadedBytes: downloadedBytes == freezed
          ? _value.downloadedBytes
          : downloadedBytes as int,
      progress: progress == freezed ? _value.progress : progress as double,
      speed: speed == freezed ? _value.speed : speed as int,
      status: status == freezed ? _value.status : status as String,
      createdAt: createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      completedAt: completedAt == freezed
          ? _value.completedAt
          : completedAt as DateTime?,
      error: error == freezed ? _value.error : error as String?,
    ));
  }
}

/// @nodoc
@override
class _$_DownloadTask implements _DownloadTask {
  const _$_DownloadTask(
      {required this.id,
      required this.fileName,
      required this.url,
      required this.savePath,
      this.totalBytes = 0,
      this.downloadedBytes = 0,
      this.progress = 0.0,
      this.speed = 0,
      this.status = 'pending',
      required this.createdAt,
      this.completedAt,
      this.error});

  factory _$_DownloadTask.fromJson(Map<String, dynamic> json) =>
      _$$_DownloadTaskFromJson(json);

  @override
  final String id;
  @override
  final String fileName;
  @override
  final String url;
  @override
  final String savePath;
  @override
  final int totalBytes;
  @override
  final int downloadedBytes;
  @override
  final double progress;
  @override
  final int speed;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;
  @override
  final String? error;

  @override
  String toString() {
    return 'DownloadTask(id: $id, fileName: $fileName, url: $url, savePath: $savePath, totalBytes: $totalBytes, downloadedBytes: $downloadedBytes, progress: $progress, speed: $speed, status: $status, createdAt: $createdAt, completedAt: $completedAt, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DownloadTask &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fileName, fileName) || other.fileName == fileName) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.savePath, savePath) || other.savePath == savePath) &&
            (identical(other.totalBytes, totalBytes) ||
                other.totalBytes == totalBytes) &&
            (identical(other.downloadedBytes, downloadedBytes) ||
                other.downloadedBytes == downloadedBytes) &&
            (identical(other.progress, progress) || other.progress == progress) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fileName,
      url,
      savePath,
      totalBytes,
      downloadedBytes,
      progress,
      speed,
      status,
      createdAt,
      completedAt,
      error);

  @override
  _$$_DownloadTaskCopyWith<_$_DownloadTask> get copyWith =>
      __$$_DownloadTaskCopyWithImpl<_$_DownloadTask>(this, _$identity);
}

abstract class _DownloadTask implements DownloadTask {
  const factory _DownloadTask(
      {required String id,
      required String fileName,
      required String url,
      required String savePath,
      int totalBytes,
      int downloadedBytes,
      double progress,
      int speed,
      String status,
      required DateTime createdAt,
      DateTime? completedAt,
      String? error}) = _$_DownloadTask;

  factory _DownloadTask.fromJson(Map<String, dynamic> json) =
      _$_DownloadTask.fromJson;

  @override
  String get id;
  @override
  String get fileName;
  @override
  String get url;
  @override
  String get savePath;
  @override
  int get totalBytes;
  @override
  int get downloadedBytes;
  @override
  double get progress;
  @override
  int get speed;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;
  @override
  String? get error;
  @override
  @override
  _$$_DownloadTaskCopyWith<_$_DownloadTask> get copyWith;
}

_$BrowserStatsCopyWith _$BrowserStatsCopyWithImpl(
    _BrowserStats value, $Res Function(_BrowserStats) then) {
  return _$_BrowserStatsCopyWithImpl(value, then);
}

abstract class _$BrowserStatsCopyWith<$Res> {
  factory _$BrowserStatsCopyWith(
          _BrowserStats value, $Res Function(_BrowserStats) then) =
      $_BrowserStatsCopyWithImpl<$Res>;
  $Res call(
      {int totalPagesVisited,
      int totalVisitDuration,
      int dataUsage,
      int bookmarkCount,
      int historyCount,
      int downloadCount,
      DateTime? lastVisitedAt});
}

class _$_BrowserStatsCopyWithImpl<$Res>
    implements _$BrowserStatsCopyWith<$Res> {
  _$_BrowserStatsCopyWithImpl(this._value, this._then);

  final _BrowserStats _value;
  final $Res Function(_BrowserStats) _then;

  @override
  $Res call({
    Object? totalPagesVisited = freezed,
    Object? totalVisitDuration = freezed,
    Object? dataUsage = freezed,
    Object? bookmarkCount = freezed,
    Object? historyCount = freezed,
    Object? downloadCount = freezed,
    Object? lastVisitedAt = freezed,
  }) {
    return _then(_BrowserStats(
      totalPagesVisited: totalPagesVisited == freezed
          ? _value.totalPagesVisited
          : totalPagesVisited as int,
      totalVisitDuration: totalVisitDuration == freezed
          ? _value.totalVisitDuration
          : totalVisitDuration as int,
      dataUsage: dataUsage == freezed ? _value.dataUsage : dataUsage as int,
      bookmarkCount: bookmarkCount == freezed
          ? _value.bookmarkCount
          : bookmarkCount as int,
      historyCount: historyCount == freezed
          ? _value.historyCount
          : historyCount as int,
      downloadCount: downloadCount == freezed
          ? _value.downloadCount
          : downloadCount as int,
      lastVisitedAt: lastVisitedAt == freezed
          ? _value.lastVisitedAt
          : lastVisitedAt as DateTime?,
    ));
  }
}

@override
abstract class _$$_BrowserStatsCopyWith<$Res>
    implements _$BrowserStatsCopyWith<$Res> {
  factory _$$_BrowserStatsCopyWith(
          _$_BrowserStats value, $Res Function(_$_BrowserStats) then) =
      __$$_BrowserStatsCopyWithImpl<$Res>;
  @override
  $Res call(
      {int totalPagesVisited,
      int totalVisitDuration,
      int dataUsage,
      int bookmarkCount,
      int historyCount,
      int downloadCount,
      DateTime? lastVisitedAt});
}

class __$$_BrowserStatsCopyWithImpl<$Res>
    extends _$_BrowserStatsCopyWithImpl<$Res>
    implements _$$_BrowserStatsCopyWith<$Res> {
  __$$_BrowserStatsCopyWithImpl(
      _$_BrowserStats _value, $Res Function(_$_BrowserStats) _then)
      : super(_value, _then);

  @override
  $Res call({
    Object? totalPagesVisited = freezed,
    Object? totalVisitDuration = freezed,
    Object? dataUsage = freezed,
    Object? bookmarkCount = freezed,
    Object? historyCount = freezed,
    Object? downloadCount = freezed,
    Object? lastVisitedAt = freezed,
  }) {
    return _then(_$_BrowserStats(
      totalPagesVisited: totalPagesVisited == freezed
          ? _value.totalPagesVisited
          : totalPagesVisited as int,
      totalVisitDuration: totalVisitDuration == freezed
          ? _value.totalVisitDuration
          : totalVisitDuration as int,
      dataUsage: dataUsage == freezed ? _value.dataUsage : dataUsage as int,
      bookmarkCount: bookmarkCount == freezed
          ? _value.bookmarkCount
          : bookmarkCount as int,
      historyCount: historyCount == freezed
          ? _value.historyCount
          : historyCount as int,
      downloadCount: downloadCount == freezed
          ? _value.downloadCount
          : downloadCount as int,
      lastVisitedAt: lastVisitedAt == freezed
          ? _value.lastVisitedAt
          : lastVisitedAt as DateTime?,
    ));
  }
}

/// @nodoc
@override
class _$_BrowserStats implements _BrowserStats {
  const _$_BrowserStats(
      {this.totalPagesVisited = 0,
      this.totalVisitDuration = 0,
      this.dataUsage = 0,
      this.bookmarkCount = 0,
      this.historyCount = 0,
      this.downloadCount = 0,
      this.lastVisitedAt});

  factory _$_BrowserStats.fromJson(Map<String, dynamic> json) =>
      _$$_BrowserStatsFromJson(json);

  @override
  final int totalPagesVisited;
  @override
  final int totalVisitDuration;
  @override
  final int dataUsage;
  @override
  final int bookmarkCount;
  @override
  final int historyCount;
  @override
  final int downloadCount;
  @override
  final DateTime? lastVisitedAt;

  @override
  String toString() {
    return 'BrowserStats(totalPagesVisited: $totalPagesVisited, totalVisitDuration: $totalVisitDuration, dataUsage: $dataUsage, bookmarkCount: $bookmarkCount, historyCount: $historyCount, downloadCount: $downloadCount, lastVisitedAt: $lastVisitedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BrowserStats &&
            (identical(other.totalPagesVisited, totalPagesVisited) ||
                other.totalPagesVisited == totalPagesVisited) &&
            (identical(other.totalVisitDuration, totalVisitDuration) ||
                other.totalVisitDuration == totalVisitDuration) &&
            (identical(other.dataUsage, dataUsage) || other.dataUsage == dataUsage) &&
            (identical(other.bookmarkCount, bookmarkCount) ||
                other.bookmarkCount == bookmarkCount) &&
            (identical(other.historyCount, historyCount) ||
                other.historyCount == historyCount) &&
            (identical(other.downloadCount, downloadCount) ||
                other.downloadCount == downloadCount) &&
            (identical(other.lastVisitedAt, lastVisitedAt) ||
                other.lastVisitedAt == lastVisitedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalPagesVisited,
      totalVisitDuration,
      dataUsage,
      bookmarkCount,
      historyCount,
      downloadCount,
      lastVisitedAt);

  @override
  _$$_BrowserStatsCopyWith<_$_BrowserStats> get copyWith =>
      __$$_BrowserStatsCopyWithImpl<_$_BrowserStats>(this, _$identity);
}

abstract class _BrowserStats implements BrowserStats {
  const factory _BrowserStats(
      {int totalPagesVisited,
      int totalVisitDuration,
      int dataUsage,
      int bookmarkCount,
      int historyCount,
      int downloadCount,
      DateTime? lastVisitedAt}) = _$_BrowserStats;

  factory _BrowserStats.fromJson(Map<String, dynamic> json) =
      _$_BrowserStats.fromJson;

  @override
  int get totalPagesVisited;
  @override
  int get totalVisitDuration;
  @override
  int get dataUsage;
  @override
  int get bookmarkCount;
  @override
  int get historyCount;
  @override
  int get downloadCount;
  @override
  DateTime? get lastVisitedAt;
  @override
  @override
  _$$_BrowserStatsCopyWith<_$_BrowserStats> get copyWith;
}
