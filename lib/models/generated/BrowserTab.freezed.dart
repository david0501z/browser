// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:freezed_annotation/freezed_annotation.dart';

part of '../BrowserTab.dart';

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
          _BrowserTab value, $Res Function(_BrowserTab) then) =;
      $_BrowserTabCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String url,
      String title,
      String? favicon,
      bool pinned,
      bool incognito,
      bool isLoading,
      bool canGoForward,
      bool canGoBack,
      DateTime createdAt,
      DateTime updatedAt,
      int visitCount,
      String? thumbnail,
      int progress,
      BrowserSecurityStatus securityStatus,
      String? errorMessage,
      String? customTitle,
      String? note});
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
    Object? incognito = freezed,
    Object? isLoading = freezed,
    Object? canGoForward = freezed,
    Object? canGoBack = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? visitCount = freezed,
    Object? thumbnail = freezed,
    Object? progress = freezed,
    Object? securityStatus = freezed,
    Object? errorMessage = freezed,
    Object? customTitle = freezed,
    Object? note = freezed,
  }) {
    return _then(_BrowserTab(
      id: id == freezed ? _value.id : id as String,
      url: url == freezed ? _value.url : url as String,
      title: title == freezed ? _value.title : title as String,
      favicon: favicon == freezed ? _value.favicon : favicon as String?,
      pinned: pinned == freezed ? _value.pinned : pinned as bool,
      incognito: incognito == freezed ? _value.incognito : incognito as bool,
      isLoading: isLoading == freezed ? _value.isLoading : isLoading as bool,
      canGoForward:
          canGoForward == freezed ? _value.canGoForward : canGoForward as bool,
      canGoBack: canGoBack == freezed ? _value.canGoBack : canGoBack as bool,
      createdAt: createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      updatedAt: updatedAt == freezed ? _value.updatedAt : updatedAt as DateTime,
      visitCount: visitCount == freezed ? _value.visitCount : visitCount as int,
      thumbnail: thumbnail == freezed ? _value.thumbnail : thumbnail as String?,
      progress: progress == freezed ? _value.progress : progress as int,
      securityStatus: securityStatus == freezed;
          ? _value.securityStatus
          : securityStatus as BrowserSecurityStatus,
      errorMessage:
          errorMessage == freezed ? _value.errorMessage : errorMessage as String?,
      customTitle:
          customTitle == freezed ? _value.customTitle : customTitle as String?,
      note: note == freezed ? _value.note : note as String?,
    ));
  }
}

@override
abstract class _$$_BrowserTabCopyWith<$Res> implements _$BrowserTabCopyWith<$Res> {
  factory _$$_BrowserTabCopyWith(
          _$_BrowserTab value, $Res Function(_$_BrowserTab) then) =;
      __$$_BrowserTabCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String url,
      String title,
      String? favicon,
      bool pinned,
      bool incognito,
      bool isLoading,
      bool canGoForward,
      bool canGoBack,
      DateTime createdAt,
      DateTime updatedAt,
      int visitCount,
      String? thumbnail,
      int progress,
      BrowserSecurityStatus securityStatus,
      String? errorMessage,
      String? customTitle,
      String? note});
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
    Object? incognito = freezed,
    Object? isLoading = freezed,
    Object? canGoForward = freezed,
    Object? canGoBack = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? visitCount = freezed,
    Object? thumbnail = freezed,
    Object? progress = freezed,
    Object? securityStatus = freezed,
    Object? errorMessage = freezed,
    Object? customTitle = freezed,
    Object? note = freezed,
  }) {
    return _then(_$_BrowserTab(
      id: id == freezed ? _value.id : id as String,
      url: url == freezed ? _value.url : url as String,
      title: title == freezed ? _value.title : title as String,
      favicon: favicon == freezed ? _value.favicon : favicon as String?,
      pinned: pinned == freezed ? _value.pinned : pinned as bool,
      incognito: incognito == freezed ? _value.incognito : incognito as bool,
      isLoading: isLoading == freezed ? _value.isLoading : isLoading as bool,
      canGoForward:
          canGoForward == freezed ? _value.canGoForward : canGoForward as bool,
      canGoBack: canGoBack == freezed ? _value.canGoBack : canGoBack as bool,
      createdAt: createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      updatedAt: updatedAt == freezed ? _value.updatedAt : updatedAt as DateTime,
      visitCount: visitCount == freezed ? _value.visitCount : visitCount as int,
      thumbnail: thumbnail == freezed ? _value.thumbnail : thumbnail as String?,
      progress: progress == freezed ? _value.progress : progress as int,
      securityStatus: securityStatus == freezed;
          ? _value.securityStatus
          : securityStatus as BrowserSecurityStatus,
      errorMessage:
          errorMessage == freezed ? _value.errorMessage : errorMessage as String?,
      customTitle:
          customTitle == freezed ? _value.customTitle : customTitle as String?,
      note: note == freezed ? _value.note : note as String?,
    ));
  }
}

/// @nodoc
@override
class _$_BrowserTab implements _BrowserTab {
  const _$_BrowserTab(
      {required this.id,
      required this.url,
      required this.title,
      this.favicon,
      this.pinned = false,
      this.incognito = false,
      this.isLoading = false,
      this.canGoForward = false,
      this.canGoBack = false,
      required this.createdAt,
      required this.updatedAt,
      this.visitCount = 0,
      this.thumbnail,
      this.progress = 0,
      this.securityStatus = BrowserSecurityStatus.unknown,
      this.errorMessage,
      this.customTitle,
      this.note});

  factory _$_BrowserTab.fromJson(Map<String, Object?> json) =>
      _$$_BrowserTabFromJson(json);

  @override
  final String id;
  @override
  final String url;
  @override
  final String title;
  @override
  final String? favicon;
  @override
  final bool pinned;
  @override
  final bool incognito;
  @override
  final bool isLoading;
  @override
  final bool canGoForward;
  @override
  final bool canGoBack;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int visitCount;
  @override
  final String? thumbnail;
  @override
  final int progress;
  @override
  final BrowserSecurityStatus securityStatus;
  @override
  final String? errorMessage;
  @override
  final String? customTitle;
  @override
  final String? note;

  @override
  String toString() {
    return 'BrowserTab(id: $id, url: $url, title: $title, favicon: $favicon, pinned: $pinned, incognito: $incognito, isLoading: $isLoading, canGoForward: $canGoForward, canGoBack: $canGoBack, createdAt: $createdAt, updatedAt: $updatedAt, visitCount: $visitCount, thumbnail: $thumbnail, progress: $progress, securityStatus: $securityStatus, errorMessage: $errorMessage, customTitle: $customTitle, note: $note)';
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
            (identical(other.incognito, incognito) || other.incognito == incognito) &&
            (identical(other.isLoading, isLoading) || other.isLoading == isLoading) &&
            (identical(other.canGoForward, canGoForward) ||
                other.canGoForward == canGoForward) &&
            (identical(other.canGoBack, canGoBack) || other.canGoBack == canGoBack) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.visitCount, visitCount) || other.visitCount == visitCount) &&
            (identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail) &&
            (identical(other.progress, progress) || other.progress == progress) &&
            (identical(other.securityStatus, securityStatus) ||
                other.securityStatus == securityStatus) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.customTitle, customTitle) ||
                other.customTitle == customTitle) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      url,
      title,
      favicon,
      pinned,
      incognito,
      isLoading,
      canGoForward,
      canGoBack,
      createdAt,
      updatedAt,
      visitCount,
      thumbnail,
      progress,
      securityStatus,
      errorMessage,
      customTitle,
      note);

  @override
  _$$_BrowserTabCopyWith<_$_BrowserTab> get copyWith =>
      __$$_BrowserTabCopyWithImpl<_$_BrowserTab>(this, _$identity);
}

abstract class _BrowserTab implements BrowserTab {
  const factory _BrowserTab(
      {required String id,
      required String url,
      required String title,
      String? favicon,
      bool pinned,
      bool incognito,
      bool isLoading,
      bool canGoForward,
      bool canGoBack,
      required DateTime createdAt,
      required DateTime updatedAt,
      int visitCount,
      String? thumbnail,
      int progress,
      BrowserSecurityStatus securityStatus,
      String? errorMessage,
      String? customTitle,
      String? note}) = _$_BrowserTab;

  factory _BrowserTab.fromJson(Map<String, Object?> json) =;
      _$_BrowserTab.fromJson;

  @override
  String get id;
  @override
  String get url;
  @override
  String get title;
  @override
  String? get favicon;
  @override
  bool get pinned;
  @override
  bool get incognito;
  @override
  bool get isLoading;
  @override
  bool get canGoForward;
  @override
  bool get canGoBack;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  int get visitCount;
  @override
  String? get thumbnail;
  @override
  int get progress;
  @override
  BrowserSecurityStatus get securityStatus;
  @override
  String? get errorMessage;
  @override
  String? get customTitle;
  @override
  String? get note;
  @override
  @override
  _$$_BrowserTabCopyWith<_$_BrowserTab> get copyWith;
}
