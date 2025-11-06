// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'HistoryEntry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HistoryEntry _$HistoryEntryFromJson(Map<String, dynamic> json) {
  return _HistoryEntry.fromJson(json);
}

/// @nodoc
mixin _$HistoryEntry {
  /// 历史记录唯一标识符
  String get id => throw _privateConstructorUsedError;

  /// 页面标题
  String get title => throw _privateConstructorUsedError;

  /// 页面URL
  String get url => throw _privateConstructorUsedError;

  /// 页面图标URL或Base64编码
  String? get favicon => throw _privateConstructorUsedError;

  /// 访问时间
  DateTime get visitedAt => throw _privateConstructorUsedError;

  /// 访问结束时间（用于计算停留时长）
  DateTime? get exitAt => throw _privateConstructorUsedError;

  /// 停留时长（秒）
  int get duration => throw _privateConstructorUsedError;

  /// 访问来源页面URL
  String? get referrer => throw _privateConstructorUsedError;

  /// 设备类型
  DeviceType get deviceType => throw _privateConstructorUsedError;

  /// 浏览器用户代理
  String? get userAgent => throw _privateConstructorUsedError;

  /// 页面加载状态
  PageLoadStatus get loadStatus => throw _privateConstructorUsedError;

  /// 页面加载耗时（毫秒）
  int? get loadTime => throw _privateConstructorUsedError;

  /// 数据传输量（字节）
  int get dataTransferred => throw _privateConstructorUsedError;

  /// 安全状态
  BrowserSecurityStatus get securityStatus =>
      throw _privateConstructorUsedError;

  /// HTTP状态码
  int? get httpStatusCode => throw _privateConstructorUsedError;

  /// 错误信息（如果有）
  String? get errorMessage => throw _privateConstructorUsedError;

  /// 页面类型
  PageType get pageType => throw _privateConstructorUsedError;

  /// 搜索关键词（如果是从搜索引擎访问）
  String? get searchQuery => throw _privateConstructorUsedError;

  /// 是否为新标签页访问
  bool get isNewTab => throw _privateConstructorUsedError;

  /// 是否为书签访问
  bool get isFromBookmark => throw _privateConstructorUsedError;

  /// 缩略图Base64编码
  String? get thumbnail => throw _privateConstructorUsedError;

  /// 页面语言
  String? get pageLanguage => throw _privateConstructorUsedError;

  /// 地理位置信息
  String? get geoLocation => throw _privateConstructorUsedError;

  /// Serializes this HistoryEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoryEntryCopyWith<HistoryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryEntryCopyWith<$Res> {
  factory $HistoryEntryCopyWith(
          HistoryEntry value, $Res Function(HistoryEntry) then) =
      _$HistoryEntryCopyWithImpl<$Res, HistoryEntry>;
  @useResult
  $Res call(
      {String id,
      String title,
      String url,
      String? favicon,
      DateTime visitedAt,
      DateTime? exitAt,
      int duration,
      String? referrer,
      DeviceType deviceType,
      String? userAgent,
      PageLoadStatus loadStatus,
      int? loadTime,
      int dataTransferred,
      BrowserSecurityStatus securityStatus,
      int? httpStatusCode,
      String? errorMessage,
      PageType pageType,
      String? searchQuery,
      bool isNewTab,
      bool isFromBookmark,
      String? thumbnail,
      String? pageLanguage,
      String? geoLocation});
}

/// @nodoc
class _$HistoryEntryCopyWithImpl<$Res, $Val extends HistoryEntry>
    implements $HistoryEntryCopyWith<$Res> {
  _$HistoryEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? url = null,
    Object? favicon = freezed,
    Object? visitedAt = null,
    Object? exitAt = freezed,
    Object? duration = null,
    Object? referrer = freezed,
    Object? deviceType = null,
    Object? userAgent = freezed,
    Object? loadStatus = null,
    Object? loadTime = freezed,
    Object? dataTransferred = null,
    Object? securityStatus = null,
    Object? httpStatusCode = freezed,
    Object? errorMessage = freezed,
    Object? pageType = null,
    Object? searchQuery = freezed,
    Object? isNewTab = null,
    Object? isFromBookmark = null,
    Object? thumbnail = freezed,
    Object? pageLanguage = freezed,
    Object? geoLocation = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      favicon: freezed == favicon
          ? _value.favicon
          : favicon // ignore: cast_nullable_to_non_nullable
              as String?,
      visitedAt: null == visitedAt
          ? _value.visitedAt
          : visitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      exitAt: freezed == exitAt
          ? _value.exitAt
          : exitAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      referrer: freezed == referrer
          ? _value.referrer
          : referrer // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceType: null == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as DeviceType,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      loadStatus: null == loadStatus
          ? _value.loadStatus
          : loadStatus // ignore: cast_nullable_to_non_nullable
              as PageLoadStatus,
      loadTime: freezed == loadTime
          ? _value.loadTime
          : loadTime // ignore: cast_nullable_to_non_nullable
              as int?,
      dataTransferred: null == dataTransferred
          ? _value.dataTransferred
          : dataTransferred // ignore: cast_nullable_to_non_nullable
              as int,
      securityStatus: null == securityStatus
          ? _value.securityStatus
          : securityStatus // ignore: cast_nullable_to_non_nullable
              as BrowserSecurityStatus,
      httpStatusCode: freezed == httpStatusCode
          ? _value.httpStatusCode
          : httpStatusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      pageType: null == pageType
          ? _value.pageType
          : pageType // ignore: cast_nullable_to_non_nullable
              as PageType,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      isNewTab: null == isNewTab
          ? _value.isNewTab
          : isNewTab // ignore: cast_nullable_to_non_nullable
              as bool,
      isFromBookmark: null == isFromBookmark
          ? _value.isFromBookmark
          : isFromBookmark // ignore: cast_nullable_to_non_nullable
              as bool,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      pageLanguage: freezed == pageLanguage
          ? _value.pageLanguage
          : pageLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      geoLocation: freezed == geoLocation
          ? _value.geoLocation
          : geoLocation // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HistoryEntryImplCopyWith<$Res>
    implements $HistoryEntryCopyWith<$Res> {
  factory _$$HistoryEntryImplCopyWith(
          _$HistoryEntryImpl value, $Res Function(_$HistoryEntryImpl) then) =
      __$$HistoryEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String url,
      String? favicon,
      DateTime visitedAt,
      DateTime? exitAt,
      int duration,
      String? referrer,
      DeviceType deviceType,
      String? userAgent,
      PageLoadStatus loadStatus,
      int? loadTime,
      int dataTransferred,
      BrowserSecurityStatus securityStatus,
      int? httpStatusCode,
      String? errorMessage,
      PageType pageType,
      String? searchQuery,
      bool isNewTab,
      bool isFromBookmark,
      String? thumbnail,
      String? pageLanguage,
      String? geoLocation});
}

/// @nodoc
class __$$HistoryEntryImplCopyWithImpl<$Res>
    extends _$HistoryEntryCopyWithImpl<$Res, _$HistoryEntryImpl>
    implements _$$HistoryEntryImplCopyWith<$Res> {
  __$$HistoryEntryImplCopyWithImpl(
      _$HistoryEntryImpl _value, $Res Function(_$HistoryEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? url = null,
    Object? favicon = freezed,
    Object? visitedAt = null,
    Object? exitAt = freezed,
    Object? duration = null,
    Object? referrer = freezed,
    Object? deviceType = null,
    Object? userAgent = freezed,
    Object? loadStatus = null,
    Object? loadTime = freezed,
    Object? dataTransferred = null,
    Object? securityStatus = null,
    Object? httpStatusCode = freezed,
    Object? errorMessage = freezed,
    Object? pageType = null,
    Object? searchQuery = freezed,
    Object? isNewTab = null,
    Object? isFromBookmark = null,
    Object? thumbnail = freezed,
    Object? pageLanguage = freezed,
    Object? geoLocation = freezed,
  }) {
    return _then(_$HistoryEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      favicon: freezed == favicon
          ? _value.favicon
          : favicon // ignore: cast_nullable_to_non_nullable
              as String?,
      visitedAt: null == visitedAt
          ? _value.visitedAt
          : visitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      exitAt: freezed == exitAt
          ? _value.exitAt
          : exitAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      referrer: freezed == referrer
          ? _value.referrer
          : referrer // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceType: null == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as DeviceType,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      loadStatus: null == loadStatus
          ? _value.loadStatus
          : loadStatus // ignore: cast_nullable_to_non_nullable
              as PageLoadStatus,
      loadTime: freezed == loadTime
          ? _value.loadTime
          : loadTime // ignore: cast_nullable_to_non_nullable
              as int?,
      dataTransferred: null == dataTransferred
          ? _value.dataTransferred
          : dataTransferred // ignore: cast_nullable_to_non_nullable
              as int,
      securityStatus: null == securityStatus
          ? _value.securityStatus
          : securityStatus // ignore: cast_nullable_to_non_nullable
              as BrowserSecurityStatus,
      httpStatusCode: freezed == httpStatusCode
          ? _value.httpStatusCode
          : httpStatusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      pageType: null == pageType
          ? _value.pageType
          : pageType // ignore: cast_nullable_to_non_nullable
              as PageType,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      isNewTab: null == isNewTab
          ? _value.isNewTab
          : isNewTab // ignore: cast_nullable_to_non_nullable
              as bool,
      isFromBookmark: null == isFromBookmark
          ? _value.isFromBookmark
          : isFromBookmark // ignore: cast_nullable_to_non_nullable
              as bool,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      pageLanguage: freezed == pageLanguage
          ? _value.pageLanguage
          : pageLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      geoLocation: freezed == geoLocation
          ? _value.geoLocation
          : geoLocation // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoryEntryImpl implements _HistoryEntry {
  const _$HistoryEntryImpl(
      {required this.id,
      required this.title,
      required this.url,
      this.favicon,
      required this.visitedAt,
      this.exitAt,
      this.duration = 0,
      this.referrer,
      this.deviceType = DeviceType.unknown,
      this.userAgent,
      this.loadStatus = PageLoadStatus.success,
      this.loadTime,
      this.dataTransferred = 0,
      this.securityStatus = BrowserSecurityStatus.unknown,
      this.httpStatusCode,
      this.errorMessage,
      this.pageType = PageType.webpage,
      this.searchQuery,
      this.isNewTab = false,
      this.isFromBookmark = false,
      this.thumbnail,
      this.pageLanguage,
      this.geoLocation});

  factory _$HistoryEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoryEntryImplFromJson(json);

  /// 历史记录唯一标识符
  @override
  final String id;

  /// 页面标题
  @override
  final String title;

  /// 页面URL
  @override
  final String url;

  /// 页面图标URL或Base64编码
  @override
  final String? favicon;

  /// 访问时间
  @override
  final DateTime visitedAt;

  /// 访问结束时间（用于计算停留时长）
  @override
  final DateTime? exitAt;

  /// 停留时长（秒）
  @override
  @JsonKey()
  final int duration;

  /// 访问来源页面URL
  @override
  final String? referrer;

  /// 设备类型
  @override
  @JsonKey()
  final DeviceType deviceType;

  /// 浏览器用户代理
  @override
  final String? userAgent;

  /// 页面加载状态
  @override
  @JsonKey()
  final PageLoadStatus loadStatus;

  /// 页面加载耗时（毫秒）
  @override
  final int? loadTime;

  /// 数据传输量（字节）
  @override
  @JsonKey()
  final int dataTransferred;

  /// 安全状态
  @override
  @JsonKey()
  final BrowserSecurityStatus securityStatus;

  /// HTTP状态码
  @override
  final int? httpStatusCode;

  /// 错误信息（如果有）
  @override
  final String? errorMessage;

  /// 页面类型
  @override
  @JsonKey()
  final PageType pageType;

  /// 搜索关键词（如果是从搜索引擎访问）
  @override
  final String? searchQuery;

  /// 是否为新标签页访问
  @override
  @JsonKey()
  final bool isNewTab;

  /// 是否为书签访问
  @override
  @JsonKey()
  final bool isFromBookmark;

  /// 缩略图Base64编码
  @override
  final String? thumbnail;

  /// 页面语言
  @override
  final String? pageLanguage;

  /// 地理位置信息
  @override
  final String? geoLocation;

  @override
  String toString() {
    return 'HistoryEntry(id: $id, title: $title, url: $url, favicon: $favicon, visitedAt: $visitedAt, exitAt: $exitAt, duration: $duration, referrer: $referrer, deviceType: $deviceType, userAgent: $userAgent, loadStatus: $loadStatus, loadTime: $loadTime, dataTransferred: $dataTransferred, securityStatus: $securityStatus, httpStatusCode: $httpStatusCode, errorMessage: $errorMessage, pageType: $pageType, searchQuery: $searchQuery, isNewTab: $isNewTab, isFromBookmark: $isFromBookmark, thumbnail: $thumbnail, pageLanguage: $pageLanguage, geoLocation: $geoLocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.favicon, favicon) || other.favicon == favicon) &&
            (identical(other.visitedAt, visitedAt) ||
                other.visitedAt == visitedAt) &&
            (identical(other.exitAt, exitAt) || other.exitAt == exitAt) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.referrer, referrer) ||
                other.referrer == referrer) &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.loadStatus, loadStatus) ||
                other.loadStatus == loadStatus) &&
            (identical(other.loadTime, loadTime) ||
                other.loadTime == loadTime) &&
            (identical(other.dataTransferred, dataTransferred) ||
                other.dataTransferred == dataTransferred) &&
            (identical(other.securityStatus, securityStatus) ||
                other.securityStatus == securityStatus) &&
            (identical(other.httpStatusCode, httpStatusCode) ||
                other.httpStatusCode == httpStatusCode) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.pageType, pageType) ||
                other.pageType == pageType) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.isNewTab, isNewTab) ||
                other.isNewTab == isNewTab) &&
            (identical(other.isFromBookmark, isFromBookmark) ||
                other.isFromBookmark == isFromBookmark) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.pageLanguage, pageLanguage) ||
                other.pageLanguage == pageLanguage) &&
            (identical(other.geoLocation, geoLocation) ||
                other.geoLocation == geoLocation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        url,
        favicon,
        visitedAt,
        exitAt,
        duration,
        referrer,
        deviceType,
        userAgent,
        loadStatus,
        loadTime,
        dataTransferred,
        securityStatus,
        httpStatusCode,
        errorMessage,
        pageType,
        searchQuery,
        isNewTab,
        isFromBookmark,
        thumbnail,
        pageLanguage,
        geoLocation
      ]);

  /// Create a copy of HistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryEntryImplCopyWith<_$HistoryEntryImpl> get copyWith =>
      __$$HistoryEntryImplCopyWithImpl<_$HistoryEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoryEntryImplToJson(
      this,
    );
  }
}

abstract class _HistoryEntry implements HistoryEntry {
  const factory _HistoryEntry(
      {required final String id,
      required final String title,
      required final String url,
      final String? favicon,
      required final DateTime visitedAt,
      final DateTime? exitAt,
      final int duration,
      final String? referrer,
      final DeviceType deviceType,
      final String? userAgent,
      final PageLoadStatus loadStatus,
      final int? loadTime,
      final int dataTransferred,
      final BrowserSecurityStatus securityStatus,
      final int? httpStatusCode,
      final String? errorMessage,
      final PageType pageType,
      final String? searchQuery,
      final bool isNewTab,
      final bool isFromBookmark,
      final String? thumbnail,
      final String? pageLanguage,
      final String? geoLocation}) = _$HistoryEntryImpl;

  factory _HistoryEntry.fromJson(Map<String, dynamic> json) =
      _$HistoryEntryImpl.fromJson;

  /// 历史记录唯一标识符
  @override
  String get id;

  /// 页面标题
  @override
  String get title;

  /// 页面URL
  @override
  String get url;

  /// 页面图标URL或Base64编码
  @override
  String? get favicon;

  /// 访问时间
  @override
  DateTime get visitedAt;

  /// 访问结束时间（用于计算停留时长）
  @override
  DateTime? get exitAt;

  /// 停留时长（秒）
  @override
  int get duration;

  /// 访问来源页面URL
  @override
  String? get referrer;

  /// 设备类型
  @override
  DeviceType get deviceType;

  /// 浏览器用户代理
  @override
  String? get userAgent;

  /// 页面加载状态
  @override
  PageLoadStatus get loadStatus;

  /// 页面加载耗时（毫秒）
  @override
  int? get loadTime;

  /// 数据传输量（字节）
  @override
  int get dataTransferred;

  /// 安全状态
  @override
  BrowserSecurityStatus get securityStatus;

  /// HTTP状态码
  @override
  int? get httpStatusCode;

  /// 错误信息（如果有）
  @override
  String? get errorMessage;

  /// 页面类型
  @override
  PageType get pageType;

  /// 搜索关键词（如果是从搜索引擎访问）
  @override
  String? get searchQuery;

  /// 是否为新标签页访问
  @override
  bool get isNewTab;

  /// 是否为书签访问
  @override
  bool get isFromBookmark;

  /// 缩略图Base64编码
  @override
  String? get thumbnail;

  /// 页面语言
  @override
  String? get pageLanguage;

  /// 地理位置信息
  @override
  String? get geoLocation;

  /// Create a copy of HistoryEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoryEntryImplCopyWith<_$HistoryEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
