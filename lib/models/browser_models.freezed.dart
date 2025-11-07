// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'browser_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BrowserTab _$BrowserTabFromJson(Map<String, dynamic> json) {
  return _BrowserTab.fromJson(json);
}

/// @nodoc
mixin _$BrowserTab {
  /// 标签页唯一标识
  String get id => throw _privateConstructorUsedError;

  /// 当前URL
  String get url => throw _privateConstructorUsedError;

  /// 页面标题
  String? get title => throw _privateConstructorUsedError;

  /// 图标URL
  String? get favicon => throw _privateConstructorUsedError;

  /// 是否固定标签页
  bool get pinned => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// 缩略图数据（Base64编码）
  String? get thumbnail => throw _privateConstructorUsedError;

  /// 是否为无痕模式
  bool get incognito => throw _privateConstructorUsedError;

  /// Serializes this BrowserTab to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BrowserTab
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BrowserTabCopyWith<BrowserTab> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrowserTabCopyWith<$Res> {
  factory $BrowserTabCopyWith(
          BrowserTab value, $Res Function(BrowserTab) then) =
      _$BrowserTabCopyWithImpl<$Res, BrowserTab>;
  @useResult
  $Res call(
      {String id,
      String url,
      String? title,
      String? favicon,
      bool pinned,
      DateTime createdAt,
      DateTime updatedAt,
      String? thumbnail,
      bool incognito});
}

/// @nodoc
class _$BrowserTabCopyWithImpl<$Res, $Val extends BrowserTab>
    implements $BrowserTabCopyWith<$Res> {
  _$BrowserTabCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BrowserTab
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? title = freezed,
    Object? favicon = freezed,
    Object? pinned = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? thumbnail = freezed,
    Object? incognito = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      favicon: freezed == favicon
          ? _value.favicon
          : favicon // ignore: cast_nullable_to_non_nullable
              as String?,
      pinned: null == pinned
          ? _value.pinned
          : pinned // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      incognito: null == incognito
          ? _value.incognito
          : incognito // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BrowserTabImplCopyWith<$Res>
    implements $BrowserTabCopyWith<$Res> {
  factory _$$BrowserTabImplCopyWith(
          _$BrowserTabImpl value, $Res Function(_$BrowserTabImpl) then) =
      __$$BrowserTabImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String url,
      String? title,
      String? favicon,
      bool pinned,
      DateTime createdAt,
      DateTime updatedAt,
      String? thumbnail,
      bool incognito});
}

/// @nodoc
class __$$BrowserTabImplCopyWithImpl<$Res>
    extends _$BrowserTabCopyWithImpl<$Res, _$BrowserTabImpl>
    implements _$$BrowserTabImplCopyWith<$Res> {
  __$$BrowserTabImplCopyWithImpl(
      _$BrowserTabImpl _value, $Res Function(_$BrowserTabImpl) _then)
      : super(_value, _then);

  /// Create a copy of BrowserTab
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? title = freezed,
    Object? favicon = freezed,
    Object? pinned = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? thumbnail = freezed,
    Object? incognito = null,
  }) {
    return _then(_$BrowserTabImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      favicon: freezed == favicon
          ? _value.favicon
          : favicon // ignore: cast_nullable_to_non_nullable
              as String?,
      pinned: null == pinned
          ? _value.pinned
          : pinned // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      incognito: null == incognito
          ? _value.incognito
          : incognito // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BrowserTabImpl implements _BrowserTab {
  const _$BrowserTabImpl(
      {required this.id,
      required this.url,
      this.title,
      this.favicon,
      this.pinned = false,
      required this.createdAt,
      required this.updatedAt,
      this.thumbnail,
      this.incognito = false});

  factory _$BrowserTabImpl.fromJson(Map<String, dynamic> json) =>
      _$$BrowserTabImplFromJson(json);

  /// 标签页唯一标识
  @override
  final String id;

  /// 当前URL
  @override
  final String url;

  /// 页面标题
  @override
  final String? title;

  /// 图标URL
  @override
  final String? favicon;

  /// 是否固定标签页
  @override
  @JsonKey()
  final bool pinned;

  /// 创建时间
  @override
  final DateTime createdAt;

  /// 更新时间
  @override
  final DateTime updatedAt;

  /// 缩略图数据（Base64编码）
  @override
  final String? thumbnail;

  /// 是否为无痕模式
  @override
  @JsonKey()
  final bool incognito;

  @override
  String toString() {
    return 'BrowserTab(id: $id, url: $url, title: $title, favicon: $favicon, pinned: $pinned, createdAt: $createdAt, updatedAt: $updatedAt, thumbnail: $thumbnail, incognito: $incognito)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrowserTabImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.favicon, favicon) || other.favicon == favicon) &&
            (identical(other.pinned, pinned) || other.pinned == pinned) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.incognito, incognito) ||
                other.incognito == incognito));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, title, favicon, pinned,
      createdAt, updatedAt, thumbnail, incognito);

  /// Create a copy of BrowserTab
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BrowserTabImplCopyWith<_$BrowserTabImpl> get copyWith =>
      __$$BrowserTabImplCopyWithImpl<_$BrowserTabImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BrowserTabImplToJson(
      this,
    );
  }
}

abstract class _BrowserTab implements BrowserTab {
  const factory _BrowserTab(
      {required final String id,
      required final String url,
      final String? title,
      final String? favicon,
      final bool pinned,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? thumbnail,
      final bool incognito}) = _$BrowserTabImpl;

  factory _BrowserTab.fromJson(Map<String, dynamic> json) =
      _$BrowserTabImpl.fromJson;

  /// 标签页唯一标识
  @override
  String get id;

  /// 当前URL
  @override
  String get url;

  /// 页面标题
  @override
  String? get title;

  /// 图标URL
  @override
  String? get favicon;

  /// 是否固定标签页
  @override
  bool get pinned;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// 更新时间
  @override
  DateTime get updatedAt;

  /// 缩略图数据（Base64编码）
  @override
  String? get thumbnail;

  /// 是否为无痕模式
  @override
  bool get incognito;

  /// Create a copy of BrowserTab
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrowserTabImplCopyWith<_$BrowserTabImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) {
  return _Bookmark.fromJson(json);
}

/// @nodoc
mixin _$Bookmark {
  /// 唯一标识
  String get id => throw _privateConstructorUsedError;

  /// 站点标题
  String get title => throw _privateConstructorUsedError;

  /// 链接地址
  String get url => throw _privateConstructorUsedError;

  /// 图标URL
  String? get favicon => throw _privateConstructorUsedError;

  /// 标签列表
  List<String> get tags => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// 访问次数
  int get visitCount => throw _privateConstructorUsedError;

  /// 最后访问时间
  DateTime? get lastVisitedAt => throw _privateConstructorUsedError;

  /// Serializes this Bookmark to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Bookmark
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookmarkCopyWith<Bookmark> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookmarkCopyWith<$Res> {
  factory $BookmarkCopyWith(Bookmark value, $Res Function(Bookmark) then) =
      _$BookmarkCopyWithImpl<$Res, Bookmark>;
  @useResult
  $Res call(
      {String id,
      String title,
      String url,
      String? favicon,
      List<String> tags,
      DateTime createdAt,
      DateTime updatedAt,
      int visitCount,
      DateTime? lastVisitedAt});
}

/// @nodoc
class _$BookmarkCopyWithImpl<$Res, $Val extends Bookmark>
    implements $BookmarkCopyWith<$Res> {
  _$BookmarkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Bookmark
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? url = null,
    Object? favicon = freezed,
    Object? tags = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? visitCount = null,
    Object? lastVisitedAt = freezed,
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
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      visitCount: null == visitCount
          ? _value.visitCount
          : visitCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastVisitedAt: freezed == lastVisitedAt
          ? _value.lastVisitedAt
          : lastVisitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookmarkImplCopyWith<$Res>
    implements $BookmarkCopyWith<$Res> {
  factory _$$BookmarkImplCopyWith(
          _$BookmarkImpl value, $Res Function(_$BookmarkImpl) then) =
      __$$BookmarkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String url,
      String? favicon,
      List<String> tags,
      DateTime createdAt,
      DateTime updatedAt,
      int visitCount,
      DateTime? lastVisitedAt});
}

/// @nodoc
class __$$BookmarkImplCopyWithImpl<$Res>
    extends _$BookmarkCopyWithImpl<$Res, _$BookmarkImpl>
    implements _$$BookmarkImplCopyWith<$Res> {
  __$$BookmarkImplCopyWithImpl(
      _$BookmarkImpl _value, $Res Function(_$BookmarkImpl) _then)
      : super(_value, _then);

  /// Create a copy of Bookmark
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? url = null,
    Object? favicon = freezed,
    Object? tags = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? visitCount = null,
    Object? lastVisitedAt = freezed,
  }) {
    return _then(_$BookmarkImpl(
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
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      visitCount: null == visitCount
          ? _value.visitCount
          : visitCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastVisitedAt: freezed == lastVisitedAt
          ? _value.lastVisitedAt
          : lastVisitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookmarkImpl implements _Bookmark {
  const _$BookmarkImpl(
      {required this.id,
      required this.title,
      required this.url,
      this.favicon,
      final List<String> tags = const [],
      required this.createdAt,
      required this.updatedAt,
      this.visitCount = 0,
      this.lastVisitedAt})
      : _tags = tags;

  factory _$BookmarkImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookmarkImplFromJson(json);

  /// 唯一标识
  @override
  final String id;

  /// 站点标题
  @override
  final String title;

  /// 链接地址
  @override
  final String url;

  /// 图标URL
  @override
  final String? favicon;

  /// 标签列表
  final List<String> _tags;

  /// 标签列表
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// 创建时间
  @override
  final DateTime createdAt;

  /// 更新时间
  @override
  final DateTime updatedAt;

  /// 访问次数
  @override
  @JsonKey()
  final int visitCount;

  /// 最后访问时间
  @override
  final DateTime? lastVisitedAt;

  @override
  String toString() {
    return 'Bookmark(id: $id, title: $title, url: $url, favicon: $favicon, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt, visitCount: $visitCount, lastVisitedAt: $lastVisitedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookmarkImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.favicon, favicon) || other.favicon == favicon) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.visitCount, visitCount) ||
                other.visitCount == visitCount) &&
            (identical(other.lastVisitedAt, lastVisitedAt) ||
                other.lastVisitedAt == lastVisitedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      url,
      favicon,
      const DeepCollectionEquality().hash(_tags),
      createdAt,
      updatedAt,
      visitCount,
      lastVisitedAt);

  /// Create a copy of Bookmark
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookmarkImplCopyWith<_$BookmarkImpl> get copyWith =>
      __$$BookmarkImplCopyWithImpl<_$BookmarkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookmarkImplToJson(
      this,
    );
  }
}

abstract class _Bookmark implements Bookmark {
  const factory _Bookmark(
      {required final String id,
      required final String title,
      required final String url,
      final String? favicon,
      final List<String> tags,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final int visitCount,
      final DateTime? lastVisitedAt}) = _$BookmarkImpl;

  factory _Bookmark.fromJson(Map<String, dynamic> json) =
      _$BookmarkImpl.fromJson;

  /// 唯一标识
  @override
  String get id;

  /// 站点标题
  @override
  String get title;

  /// 链接地址
  @override
  String get url;

  /// 图标URL
  @override
  String? get favicon;

  /// 标签列表
  @override
  List<String> get tags;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// 更新时间
  @override
  DateTime get updatedAt;

  /// 访问次数
  @override
  int get visitCount;

  /// 最后访问时间
  @override
  DateTime? get lastVisitedAt;

  /// Create a copy of Bookmark
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookmarkImplCopyWith<_$BookmarkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

History _$HistoryFromJson(Map<String, dynamic> json) {
  return _History.fromJson(json);
}

/// @nodoc
mixin _$History {
  /// 唯一标识
  String get id => throw _privateConstructorUsedError;

  /// 站点标题
  String get title => throw _privateConstructorUsedError;

  /// 链接地址
  String get url => throw _privateConstructorUsedError;

  /// 访问时间
  DateTime get visitedAt => throw _privateConstructorUsedError;

  /// 访问时长（秒）
  int get duration => throw _privateConstructorUsedError;

  /// 图标URL
  String? get favicon => throw _privateConstructorUsedError;

  /// 访问来源
  String? get referrer => throw _privateConstructorUsedError;

  /// 设备类型
  String get deviceType => throw _privateConstructorUsedError;

  /// Serializes this History to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of History
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoryCopyWith<History> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryCopyWith<$Res> {
  factory $HistoryCopyWith(History value, $Res Function(History) then) =
      _$HistoryCopyWithImpl<$Res, History>;
  @useResult
  $Res call(
      {String id,
      String title,
      String url,
      DateTime visitedAt,
      int duration,
      String? favicon,
      String? referrer,
      String deviceType});
}

/// @nodoc
class _$HistoryCopyWithImpl<$Res, $Val extends History>
    implements $HistoryCopyWith<$Res> {
  _$HistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of History
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? url = null,
    Object? visitedAt = null,
    Object? duration = null,
    Object? favicon = freezed,
    Object? referrer = freezed,
    Object? deviceType = null,
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
      visitedAt: null == visitedAt
          ? _value.visitedAt
          : visitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      favicon: freezed == favicon
          ? _value.favicon
          : favicon // ignore: cast_nullable_to_non_nullable
              as String?,
      referrer: freezed == referrer
          ? _value.referrer
          : referrer // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceType: null == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HistoryImplCopyWith<$Res> implements $HistoryCopyWith<$Res> {
  factory _$$HistoryImplCopyWith(
          _$HistoryImpl value, $Res Function(_$HistoryImpl) then) =
      __$$HistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String url,
      DateTime visitedAt,
      int duration,
      String? favicon,
      String? referrer,
      String deviceType});
}

/// @nodoc
class __$$HistoryImplCopyWithImpl<$Res>
    extends _$HistoryCopyWithImpl<$Res, _$HistoryImpl>
    implements _$$HistoryImplCopyWith<$Res> {
  __$$HistoryImplCopyWithImpl(
      _$HistoryImpl _value, $Res Function(_$HistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of History
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? url = null,
    Object? visitedAt = null,
    Object? duration = null,
    Object? favicon = freezed,
    Object? referrer = freezed,
    Object? deviceType = null,
  }) {
    return _then(_$HistoryImpl(
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
      visitedAt: null == visitedAt
          ? _value.visitedAt
          : visitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      favicon: freezed == favicon
          ? _value.favicon
          : favicon // ignore: cast_nullable_to_non_nullable
              as String?,
      referrer: freezed == referrer
          ? _value.referrer
          : referrer // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceType: null == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoryImpl implements _History {
  const _$HistoryImpl(
      {required this.id,
      required this.title,
      required this.url,
      required this.visitedAt,
      this.duration = 0,
      this.favicon,
      this.referrer,
      this.deviceType = 'mobile'});

  factory _$HistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoryImplFromJson(json);

  /// 唯一标识
  @override
  final String id;

  /// 站点标题
  @override
  final String title;

  /// 链接地址
  @override
  final String url;

  /// 访问时间
  @override
  final DateTime visitedAt;

  /// 访问时长（秒）
  @override
  @JsonKey()
  final int duration;

  /// 图标URL
  @override
  final String? favicon;

  /// 访问来源
  @override
  final String? referrer;

  /// 设备类型
  @override
  @JsonKey()
  final String deviceType;

  @override
  String toString() {
    return 'History(id: $id, title: $title, url: $url, visitedAt: $visitedAt, duration: $duration, favicon: $favicon, referrer: $referrer, deviceType: $deviceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.visitedAt, visitedAt) ||
                other.visitedAt == visitedAt) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.favicon, favicon) || other.favicon == favicon) &&
            (identical(other.referrer, referrer) ||
                other.referrer == referrer) &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, url, visitedAt,
      duration, favicon, referrer, deviceType);

  /// Create a copy of History
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryImplCopyWith<_$HistoryImpl> get copyWith =>
      __$$HistoryImplCopyWithImpl<_$HistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoryImplToJson(
      this,
    );
  }
}

abstract class _History implements History {
  const factory _History(
      {required final String id,
      required final String title,
      required final String url,
      required final DateTime visitedAt,
      final int duration,
      final String? favicon,
      final String? referrer,
      final String deviceType}) = _$HistoryImpl;

  factory _History.fromJson(Map<String, dynamic> json) = _$HistoryImpl.fromJson;

  /// 唯一标识
  @override
  String get id;

  /// 站点标题
  @override
  String get title;

  /// 链接地址
  @override
  String get url;

  /// 访问时间
  @override
  DateTime get visitedAt;

  /// 访问时长（秒）
  @override
  int get duration;

  /// 图标URL
  @override
  String? get favicon;

  /// 访问来源
  @override
  String? get referrer;

  /// 设备类型
  @override
  String get deviceType;

  /// Create a copy of History
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoryImplCopyWith<_$HistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BrowserSettings _$BrowserSettingsFromJson(Map<String, dynamic> json) {
  return _BrowserSettings.fromJson(json);
}

/// @nodoc
mixin _$BrowserSettings {
  /// 用户代理
  String? get userAgent => throw _privateConstructorUsedError;

  /// JavaScript开关
  bool get javascriptEnabled => throw _privateConstructorUsedError;

  /// DOM存储开关
  bool get domStorageEnabled => throw _privateConstructorUsedError;

  /// 缓存模式
  String get cacheMode => throw _privateConstructorUsedError;

  /// 无痕模式
  bool get incognito => throw _privateConstructorUsedError;

  /// 字体大小
  int get fontSize => throw _privateConstructorUsedError;

  /// 是否启用图片加载
  bool get imagesEnabled => throw _privateConstructorUsedError;

  /// 是否启用弹出窗口拦截
  bool get popupsEnabled => throw _privateConstructorUsedError;

  /// 默认搜索引擎
  String get searchEngine => throw _privateConstructorUsedError;

  /// 首页URL
  String get homepage => throw _privateConstructorUsedError;

  /// 下载目录
  String? get downloadDirectory => throw _privateConstructorUsedError;

  /// 是否启用下载通知
  bool get downloadNotifications => throw _privateConstructorUsedError;

  /// 是否启用隐私模式
  bool get privacyMode => throw _privateConstructorUsedError;

  /// 是否自动清除数据
  bool get autoClearData => throw _privateConstructorUsedError;

  /// 数据清除间隔（小时）
  int get clearDataInterval => throw _privateConstructorUsedError;

  /// Serializes this BrowserSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BrowserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BrowserSettingsCopyWith<BrowserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrowserSettingsCopyWith<$Res> {
  factory $BrowserSettingsCopyWith(
          BrowserSettings value, $Res Function(BrowserSettings) then) =
      _$BrowserSettingsCopyWithImpl<$Res, BrowserSettings>;
  @useResult
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

/// @nodoc
class _$BrowserSettingsCopyWithImpl<$Res, $Val extends BrowserSettings>
    implements $BrowserSettingsCopyWith<$Res> {
  _$BrowserSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BrowserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userAgent = freezed,
    Object? javascriptEnabled = null,
    Object? domStorageEnabled = null,
    Object? cacheMode = null,
    Object? incognito = null,
    Object? fontSize = null,
    Object? imagesEnabled = null,
    Object? popupsEnabled = null,
    Object? searchEngine = null,
    Object? homepage = null,
    Object? downloadDirectory = freezed,
    Object? downloadNotifications = null,
    Object? privacyMode = null,
    Object? autoClearData = null,
    Object? clearDataInterval = null,
  }) {
    return _then(_value.copyWith(
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      javascriptEnabled: null == javascriptEnabled
          ? _value.javascriptEnabled
          : javascriptEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      domStorageEnabled: null == domStorageEnabled
          ? _value.domStorageEnabled
          : domStorageEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      cacheMode: null == cacheMode
          ? _value.cacheMode
          : cacheMode // ignore: cast_nullable_to_non_nullable
              as String,
      incognito: null == incognito
          ? _value.incognito
          : incognito // ignore: cast_nullable_to_non_nullable
              as bool,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as int,
      imagesEnabled: null == imagesEnabled
          ? _value.imagesEnabled
          : imagesEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      popupsEnabled: null == popupsEnabled
          ? _value.popupsEnabled
          : popupsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      searchEngine: null == searchEngine
          ? _value.searchEngine
          : searchEngine // ignore: cast_nullable_to_non_nullable
              as String,
      homepage: null == homepage
          ? _value.homepage
          : homepage // ignore: cast_nullable_to_non_nullable
              as String,
      downloadDirectory: freezed == downloadDirectory
          ? _value.downloadDirectory
          : downloadDirectory // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadNotifications: null == downloadNotifications
          ? _value.downloadNotifications
          : downloadNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      privacyMode: null == privacyMode
          ? _value.privacyMode
          : privacyMode // ignore: cast_nullable_to_non_nullable
              as bool,
      autoClearData: null == autoClearData
          ? _value.autoClearData
          : autoClearData // ignore: cast_nullable_to_non_nullable
              as bool,
      clearDataInterval: null == clearDataInterval
          ? _value.clearDataInterval
          : clearDataInterval // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BrowserSettingsImplCopyWith<$Res>
    implements $BrowserSettingsCopyWith<$Res> {
  factory _$$BrowserSettingsImplCopyWith(_$BrowserSettingsImpl value,
          $Res Function(_$BrowserSettingsImpl) then) =
      __$$BrowserSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
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

/// @nodoc
class __$$BrowserSettingsImplCopyWithImpl<$Res>
    extends _$BrowserSettingsCopyWithImpl<$Res, _$BrowserSettingsImpl>
    implements _$$BrowserSettingsImplCopyWith<$Res> {
  __$$BrowserSettingsImplCopyWithImpl(
      _$BrowserSettingsImpl _value, $Res Function(_$BrowserSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BrowserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userAgent = freezed,
    Object? javascriptEnabled = null,
    Object? domStorageEnabled = null,
    Object? cacheMode = null,
    Object? incognito = null,
    Object? fontSize = null,
    Object? imagesEnabled = null,
    Object? popupsEnabled = null,
    Object? searchEngine = null,
    Object? homepage = null,
    Object? downloadDirectory = freezed,
    Object? downloadNotifications = null,
    Object? privacyMode = null,
    Object? autoClearData = null,
    Object? clearDataInterval = null,
  }) {
    return _then(_$BrowserSettingsImpl(
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      javascriptEnabled: null == javascriptEnabled
          ? _value.javascriptEnabled
          : javascriptEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      domStorageEnabled: null == domStorageEnabled
          ? _value.domStorageEnabled
          : domStorageEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      cacheMode: null == cacheMode
          ? _value.cacheMode
          : cacheMode // ignore: cast_nullable_to_non_nullable
              as String,
      incognito: null == incognito
          ? _value.incognito
          : incognito // ignore: cast_nullable_to_non_nullable
              as bool,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as int,
      imagesEnabled: null == imagesEnabled
          ? _value.imagesEnabled
          : imagesEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      popupsEnabled: null == popupsEnabled
          ? _value.popupsEnabled
          : popupsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      searchEngine: null == searchEngine
          ? _value.searchEngine
          : searchEngine // ignore: cast_nullable_to_non_nullable
              as String,
      homepage: null == homepage
          ? _value.homepage
          : homepage // ignore: cast_nullable_to_non_nullable
              as String,
      downloadDirectory: freezed == downloadDirectory
          ? _value.downloadDirectory
          : downloadDirectory // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadNotifications: null == downloadNotifications
          ? _value.downloadNotifications
          : downloadNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      privacyMode: null == privacyMode
          ? _value.privacyMode
          : privacyMode // ignore: cast_nullable_to_non_nullable
              as bool,
      autoClearData: null == autoClearData
          ? _value.autoClearData
          : autoClearData // ignore: cast_nullable_to_non_nullable
              as bool,
      clearDataInterval: null == clearDataInterval
          ? _value.clearDataInterval
          : clearDataInterval // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BrowserSettingsImpl implements _BrowserSettings {
  const _$BrowserSettingsImpl(
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

  factory _$BrowserSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BrowserSettingsImplFromJson(json);

  /// 用户代理
  @override
  final String? userAgent;

  /// JavaScript开关
  @override
  @JsonKey()
  final bool javascriptEnabled;

  /// DOM存储开关
  @override
  @JsonKey()
  final bool domStorageEnabled;

  /// 缓存模式
  @override
  @JsonKey()
  final String cacheMode;

  /// 无痕模式
  @override
  @JsonKey()
  final bool incognito;

  /// 字体大小
  @override
  @JsonKey()
  final int fontSize;

  /// 是否启用图片加载
  @override
  @JsonKey()
  final bool imagesEnabled;

  /// 是否启用弹出窗口拦截
  @override
  @JsonKey()
  final bool popupsEnabled;

  /// 默认搜索引擎
  @override
  @JsonKey()
  final String searchEngine;

  /// 首页URL
  @override
  @JsonKey()
  final String homepage;

  /// 下载目录
  @override
  final String? downloadDirectory;

  /// 是否启用下载通知
  @override
  @JsonKey()
  final bool downloadNotifications;

  /// 是否启用隐私模式
  @override
  @JsonKey()
  final bool privacyMode;

  /// 是否自动清除数据
  @override
  @JsonKey()
  final bool autoClearData;

  /// 数据清除间隔（小时）
  @override
  @JsonKey()
  final int clearDataInterval;

  @override
  String toString() {
    return 'BrowserSettings(userAgent: $userAgent, javascriptEnabled: $javascriptEnabled, domStorageEnabled: $domStorageEnabled, cacheMode: $cacheMode, incognito: $incognito, fontSize: $fontSize, imagesEnabled: $imagesEnabled, popupsEnabled: $popupsEnabled, searchEngine: $searchEngine, homepage: $homepage, downloadDirectory: $downloadDirectory, downloadNotifications: $downloadNotifications, privacyMode: $privacyMode, autoClearData: $autoClearData, clearDataInterval: $clearDataInterval)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrowserSettingsImpl &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.javascriptEnabled, javascriptEnabled) ||
                other.javascriptEnabled == javascriptEnabled) &&
            (identical(other.domStorageEnabled, domStorageEnabled) ||
                other.domStorageEnabled == domStorageEnabled) &&
            (identical(other.cacheMode, cacheMode) ||
                other.cacheMode == cacheMode) &&
            (identical(other.incognito, incognito) ||
                other.incognito == incognito) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.imagesEnabled, imagesEnabled) ||
                other.imagesEnabled == imagesEnabled) &&
            (identical(other.popupsEnabled, popupsEnabled) ||
                other.popupsEnabled == popupsEnabled) &&
            (identical(other.searchEngine, searchEngine) ||
                other.searchEngine == searchEngine) &&
            (identical(other.homepage, homepage) ||
                other.homepage == homepage) &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of BrowserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BrowserSettingsImplCopyWith<_$BrowserSettingsImpl> get copyWith =>
      __$$BrowserSettingsImplCopyWithImpl<_$BrowserSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BrowserSettingsImplToJson(
      this,
    );
  }
}

abstract class _BrowserSettings implements BrowserSettings {
  const factory _BrowserSettings(
      {final String? userAgent,
      final bool javascriptEnabled,
      final bool domStorageEnabled,
      final String cacheMode,
      final bool incognito,
      final int fontSize,
      final bool imagesEnabled,
      final bool popupsEnabled,
      final String searchEngine,
      final String homepage,
      final String? downloadDirectory,
      final bool downloadNotifications,
      final bool privacyMode,
      final bool autoClearData,
      final int clearDataInterval}) = _$BrowserSettingsImpl;

  factory _BrowserSettings.fromJson(Map<String, dynamic> json) =
      _$BrowserSettingsImpl.fromJson;

  /// 用户代理
  @override
  String? get userAgent;

  /// JavaScript开关
  @override
  bool get javascriptEnabled;

  /// DOM存储开关
  @override
  bool get domStorageEnabled;

  /// 缓存模式
  @override
  String get cacheMode;

  /// 无痕模式
  @override
  bool get incognito;

  /// 字体大小
  @override
  int get fontSize;

  /// 是否启用图片加载
  @override
  bool get imagesEnabled;

  /// 是否启用弹出窗口拦截
  @override
  bool get popupsEnabled;

  /// 默认搜索引擎
  @override
  String get searchEngine;

  /// 首页URL
  @override
  String get homepage;

  /// 下载目录
  @override
  String? get downloadDirectory;

  /// 是否启用下载通知
  @override
  bool get downloadNotifications;

  /// 是否启用隐私模式
  @override
  bool get privacyMode;

  /// 是否自动清除数据
  @override
  bool get autoClearData;

  /// 数据清除间隔（小时）
  @override
  int get clearDataInterval;

  /// Create a copy of BrowserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrowserSettingsImplCopyWith<_$BrowserSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BrowserEvent _$BrowserEventFromJson(Map<String, dynamic> json) {
  return _BrowserEvent.fromJson(json);
}

/// @nodoc
mixin _$BrowserEvent {
  /// 事件类型
  BrowserEventType get type => throw _privateConstructorUsedError;

  /// 关联的标签页ID
  String get tabId => throw _privateConstructorUsedError;

  /// 事件数据
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  /// 事件时间戳
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this BrowserEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BrowserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BrowserEventCopyWith<BrowserEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrowserEventCopyWith<$Res> {
  factory $BrowserEventCopyWith(
          BrowserEvent value, $Res Function(BrowserEvent) then) =
      _$BrowserEventCopyWithImpl<$Res, BrowserEvent>;
  @useResult
  $Res call(
      {BrowserEventType type,
      String tabId,
      Map<String, dynamic>? data,
      DateTime timestamp});
}

/// @nodoc
class _$BrowserEventCopyWithImpl<$Res, $Val extends BrowserEvent>
    implements $BrowserEventCopyWith<$Res> {
  _$BrowserEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BrowserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? tabId = null,
    Object? data = freezed,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BrowserEventType,
      tabId: null == tabId
          ? _value.tabId
          : tabId // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BrowserEventImplCopyWith<$Res>
    implements $BrowserEventCopyWith<$Res> {
  factory _$$BrowserEventImplCopyWith(
          _$BrowserEventImpl value, $Res Function(_$BrowserEventImpl) then) =
      __$$BrowserEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BrowserEventType type,
      String tabId,
      Map<String, dynamic>? data,
      DateTime timestamp});
}

/// @nodoc
class __$$BrowserEventImplCopyWithImpl<$Res>
    extends _$BrowserEventCopyWithImpl<$Res, _$BrowserEventImpl>
    implements _$$BrowserEventImplCopyWith<$Res> {
  __$$BrowserEventImplCopyWithImpl(
      _$BrowserEventImpl _value, $Res Function(_$BrowserEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of BrowserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? tabId = null,
    Object? data = freezed,
    Object? timestamp = null,
  }) {
    return _then(_$BrowserEventImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BrowserEventType,
      tabId: null == tabId
          ? _value.tabId
          : tabId // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BrowserEventImpl implements _BrowserEvent {
  const _$BrowserEventImpl(
      {required this.type,
      required this.tabId,
      final Map<String, dynamic>? data,
      required this.timestamp})
      : _data = data;

  factory _$BrowserEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$BrowserEventImplFromJson(json);

  /// 事件类型
  @override
  final BrowserEventType type;

  /// 关联的标签页ID
  @override
  final String tabId;

  /// 事件数据
  final Map<String, dynamic>? _data;

  /// 事件数据
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// 事件时间戳
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'BrowserEvent(type: $type, tabId: $tabId, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrowserEventImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.tabId, tabId) || other.tabId == tabId) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, tabId,
      const DeepCollectionEquality().hash(_data), timestamp);

  /// Create a copy of BrowserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BrowserEventImplCopyWith<_$BrowserEventImpl> get copyWith =>
      __$$BrowserEventImplCopyWithImpl<_$BrowserEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BrowserEventImplToJson(
      this,
    );
  }
}

abstract class _BrowserEvent implements BrowserEvent {
  const factory _BrowserEvent(
      {required final BrowserEventType type,
      required final String tabId,
      final Map<String, dynamic>? data,
      required final DateTime timestamp}) = _$BrowserEventImpl;

  factory _BrowserEvent.fromJson(Map<String, dynamic> json) =
      _$BrowserEventImpl.fromJson;

  /// 事件类型
  @override
  BrowserEventType get type;

  /// 关联的标签页ID
  @override
  String get tabId;

  /// 事件数据
  @override
  Map<String, dynamic>? get data;

  /// 事件时间戳
  @override
  DateTime get timestamp;

  /// Create a copy of BrowserEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrowserEventImplCopyWith<_$BrowserEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) {
  return _SearchResult.fromJson(json);
}

/// @nodoc
mixin _$SearchResult {
  /// 标题
  String get title => throw _privateConstructorUsedError;

  /// 描述
  String? get description => throw _privateConstructorUsedError;

  /// URL
  String get url => throw _privateConstructorUsedError;

  /// 图标URL
  String? get favicon => throw _privateConstructorUsedError;

  /// 匹配度分数
  double get score => throw _privateConstructorUsedError;

  /// Serializes this SearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchResultCopyWith<SearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultCopyWith<$Res> {
  factory $SearchResultCopyWith(
          SearchResult value, $Res Function(SearchResult) then) =
      _$SearchResultCopyWithImpl<$Res, SearchResult>;
  @useResult
  $Res call(
      {String title,
      String? description,
      String url,
      String? favicon,
      double score});
}

/// @nodoc
class _$SearchResultCopyWithImpl<$Res, $Val extends SearchResult>
    implements $SearchResultCopyWith<$Res> {
  _$SearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? url = null,
    Object? favicon = freezed,
    Object? score = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      favicon: freezed == favicon
          ? _value.favicon
          : favicon // ignore: cast_nullable_to_non_nullable
              as String?,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchResultImplCopyWith<$Res>
    implements $SearchResultCopyWith<$Res> {
  factory _$$SearchResultImplCopyWith(
          _$SearchResultImpl value, $Res Function(_$SearchResultImpl) then) =
      __$$SearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String? description,
      String url,
      String? favicon,
      double score});
}

/// @nodoc
class __$$SearchResultImplCopyWithImpl<$Res>
    extends _$SearchResultCopyWithImpl<$Res, _$SearchResultImpl>
    implements _$$SearchResultImplCopyWith<$Res> {
  __$$SearchResultImplCopyWithImpl(
      _$SearchResultImpl _value, $Res Function(_$SearchResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? url = null,
    Object? favicon = freezed,
    Object? score = null,
  }) {
    return _then(_$SearchResultImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      favicon: freezed == favicon
          ? _value.favicon
          : favicon // ignore: cast_nullable_to_non_nullable
              as String?,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchResultImpl implements _SearchResult {
  const _$SearchResultImpl(
      {required this.title,
      this.description,
      required this.url,
      this.favicon,
      this.score = 0.0});

  factory _$SearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchResultImplFromJson(json);

  /// 标题
  @override
  final String title;

  /// 描述
  @override
  final String? description;

  /// URL
  @override
  final String url;

  /// 图标URL
  @override
  final String? favicon;

  /// 匹配度分数
  @override
  @JsonKey()
  final double score;

  @override
  String toString() {
    return 'SearchResult(title: $title, description: $description, url: $url, favicon: $favicon, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.favicon, favicon) || other.favicon == favicon) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, description, url, favicon, score);

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultImplCopyWith<_$SearchResultImpl> get copyWith =>
      __$$SearchResultImplCopyWithImpl<_$SearchResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchResultImplToJson(
      this,
    );
  }
}

abstract class _SearchResult implements SearchResult {
  const factory _SearchResult(
      {required final String title,
      final String? description,
      required final String url,
      final String? favicon,
      final double score}) = _$SearchResultImpl;

  factory _SearchResult.fromJson(Map<String, dynamic> json) =
      _$SearchResultImpl.fromJson;

  /// 标题
  @override
  String get title;

  /// 描述
  @override
  String? get description;

  /// URL
  @override
  String get url;

  /// 图标URL
  @override
  String? get favicon;

  /// 匹配度分数
  @override
  double get score;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResultImplCopyWith<_$SearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DownloadTask _$DownloadTaskFromJson(Map<String, dynamic> json) {
  return _DownloadTask.fromJson(json);
}

/// @nodoc
mixin _$DownloadTask {
  /// 任务ID
  String get id => throw _privateConstructorUsedError;

  /// 文件名
  String get fileName => throw _privateConstructorUsedError;

  /// 下载URL
  String get url => throw _privateConstructorUsedError;

  /// 保存路径
  String get savePath => throw _privateConstructorUsedError;

  /// 文件大小（字节）
  int get totalBytes => throw _privateConstructorUsedError;

  /// 已下载大小（字节）
  int get downloadedBytes => throw _privateConstructorUsedError;

  /// 下载进度（0.0-1.0）
  double get progress => throw _privateConstructorUsedError;

  /// 下载速度（字节/秒）
  int get speed => throw _privateConstructorUsedError;

  /// 状态
  String get status => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 完成时间
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// 错误信息
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this DownloadTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DownloadTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DownloadTaskCopyWith<DownloadTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadTaskCopyWith<$Res> {
  factory $DownloadTaskCopyWith(
          DownloadTask value, $Res Function(DownloadTask) then) =
      _$DownloadTaskCopyWithImpl<$Res, DownloadTask>;
  @useResult
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

/// @nodoc
class _$DownloadTaskCopyWithImpl<$Res, $Val extends DownloadTask>
    implements $DownloadTaskCopyWith<$Res> {
  _$DownloadTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DownloadTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? url = null,
    Object? savePath = null,
    Object? totalBytes = null,
    Object? downloadedBytes = null,
    Object? progress = null,
    Object? speed = null,
    Object? status = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      savePath: null == savePath
          ? _value.savePath
          : savePath // ignore: cast_nullable_to_non_nullable
              as String,
      totalBytes: null == totalBytes
          ? _value.totalBytes
          : totalBytes // ignore: cast_nullable_to_non_nullable
              as int,
      downloadedBytes: null == downloadedBytes
          ? _value.downloadedBytes
          : downloadedBytes // ignore: cast_nullable_to_non_nullable
              as int,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DownloadTaskImplCopyWith<$Res>
    implements $DownloadTaskCopyWith<$Res> {
  factory _$$DownloadTaskImplCopyWith(
          _$DownloadTaskImpl value, $Res Function(_$DownloadTaskImpl) then) =
      __$$DownloadTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
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

/// @nodoc
class __$$DownloadTaskImplCopyWithImpl<$Res>
    extends _$DownloadTaskCopyWithImpl<$Res, _$DownloadTaskImpl>
    implements _$$DownloadTaskImplCopyWith<$Res> {
  __$$DownloadTaskImplCopyWithImpl(
      _$DownloadTaskImpl _value, $Res Function(_$DownloadTaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of DownloadTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? url = null,
    Object? savePath = null,
    Object? totalBytes = null,
    Object? downloadedBytes = null,
    Object? progress = null,
    Object? speed = null,
    Object? status = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? error = freezed,
  }) {
    return _then(_$DownloadTaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      savePath: null == savePath
          ? _value.savePath
          : savePath // ignore: cast_nullable_to_non_nullable
              as String,
      totalBytes: null == totalBytes
          ? _value.totalBytes
          : totalBytes // ignore: cast_nullable_to_non_nullable
              as int,
      downloadedBytes: null == downloadedBytes
          ? _value.downloadedBytes
          : downloadedBytes // ignore: cast_nullable_to_non_nullable
              as int,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DownloadTaskImpl implements _DownloadTask {
  const _$DownloadTaskImpl(
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

  factory _$DownloadTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$DownloadTaskImplFromJson(json);

  /// 任务ID
  @override
  final String id;

  /// 文件名
  @override
  final String fileName;

  /// 下载URL
  @override
  final String url;

  /// 保存路径
  @override
  final String savePath;

  /// 文件大小（字节）
  @override
  @JsonKey()
  final int totalBytes;

  /// 已下载大小（字节）
  @override
  @JsonKey()
  final int downloadedBytes;

  /// 下载进度（0.0-1.0）
  @override
  @JsonKey()
  final double progress;

  /// 下载速度（字节/秒）
  @override
  @JsonKey()
  final int speed;

  /// 状态
  @override
  @JsonKey()
  final String status;

  /// 创建时间
  @override
  final DateTime createdAt;

  /// 完成时间
  @override
  final DateTime? completedAt;

  /// 错误信息
  @override
  final String? error;

  @override
  String toString() {
    return 'DownloadTask(id: $id, fileName: $fileName, url: $url, savePath: $savePath, totalBytes: $totalBytes, downloadedBytes: $downloadedBytes, progress: $progress, speed: $speed, status: $status, createdAt: $createdAt, completedAt: $completedAt, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.savePath, savePath) ||
                other.savePath == savePath) &&
            (identical(other.totalBytes, totalBytes) ||
                other.totalBytes == totalBytes) &&
            (identical(other.downloadedBytes, downloadedBytes) ||
                other.downloadedBytes == downloadedBytes) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of DownloadTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadTaskImplCopyWith<_$DownloadTaskImpl> get copyWith =>
      __$$DownloadTaskImplCopyWithImpl<_$DownloadTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DownloadTaskImplToJson(
      this,
    );
  }
}

abstract class _DownloadTask implements DownloadTask {
  const factory _DownloadTask(
      {required final String id,
      required final String fileName,
      required final String url,
      required final String savePath,
      final int totalBytes,
      final int downloadedBytes,
      final double progress,
      final int speed,
      final String status,
      required final DateTime createdAt,
      final DateTime? completedAt,
      final String? error}) = _$DownloadTaskImpl;

  factory _DownloadTask.fromJson(Map<String, dynamic> json) =
      _$DownloadTaskImpl.fromJson;

  /// 任务ID
  @override
  String get id;

  /// 文件名
  @override
  String get fileName;

  /// 下载URL
  @override
  String get url;

  /// 保存路径
  @override
  String get savePath;

  /// 文件大小（字节）
  @override
  int get totalBytes;

  /// 已下载大小（字节）
  @override
  int get downloadedBytes;

  /// 下载进度（0.0-1.0）
  @override
  double get progress;

  /// 下载速度（字节/秒）
  @override
  int get speed;

  /// 状态
  @override
  String get status;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// 完成时间
  @override
  DateTime? get completedAt;

  /// 错误信息
  @override
  String? get error;

  /// Create a copy of DownloadTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DownloadTaskImplCopyWith<_$DownloadTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BrowserStats _$BrowserStatsFromJson(Map<String, dynamic> json) {
  return _BrowserStats.fromJson(json);
}

/// @nodoc
mixin _$BrowserStats {
  /// 总访问页面数
  int get totalPagesVisited => throw _privateConstructorUsedError;

  /// 总访问时长（秒）
  int get totalVisitDuration => throw _privateConstructorUsedError;

  /// 数据使用量（字节）
  int get dataUsage => throw _privateConstructorUsedError;

  /// 书签数量
  int get bookmarkCount => throw _privateConstructorUsedError;

  /// 历史记录数量
  int get historyCount => throw _privateConstructorUsedError;

  /// 下载任务数量
  int get downloadCount => throw _privateConstructorUsedError;

  /// 最后访问时间
  DateTime? get lastVisitedAt => throw _privateConstructorUsedError;

  /// Serializes this BrowserStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BrowserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BrowserStatsCopyWith<BrowserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrowserStatsCopyWith<$Res> {
  factory $BrowserStatsCopyWith(
          BrowserStats value, $Res Function(BrowserStats) then) =
      _$BrowserStatsCopyWithImpl<$Res, BrowserStats>;
  @useResult
  $Res call(
      {int totalPagesVisited,
      int totalVisitDuration,
      int dataUsage,
      int bookmarkCount,
      int historyCount,
      int downloadCount,
      DateTime? lastVisitedAt});
}

/// @nodoc
class _$BrowserStatsCopyWithImpl<$Res, $Val extends BrowserStats>
    implements $BrowserStatsCopyWith<$Res> {
  _$BrowserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BrowserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPagesVisited = null,
    Object? totalVisitDuration = null,
    Object? dataUsage = null,
    Object? bookmarkCount = null,
    Object? historyCount = null,
    Object? downloadCount = null,
    Object? lastVisitedAt = freezed,
  }) {
    return _then(_value.copyWith(
      totalPagesVisited: null == totalPagesVisited
          ? _value.totalPagesVisited
          : totalPagesVisited // ignore: cast_nullable_to_non_nullable
              as int,
      totalVisitDuration: null == totalVisitDuration
          ? _value.totalVisitDuration
          : totalVisitDuration // ignore: cast_nullable_to_non_nullable
              as int,
      dataUsage: null == dataUsage
          ? _value.dataUsage
          : dataUsage // ignore: cast_nullable_to_non_nullable
              as int,
      bookmarkCount: null == bookmarkCount
          ? _value.bookmarkCount
          : bookmarkCount // ignore: cast_nullable_to_non_nullable
              as int,
      historyCount: null == historyCount
          ? _value.historyCount
          : historyCount // ignore: cast_nullable_to_non_nullable
              as int,
      downloadCount: null == downloadCount
          ? _value.downloadCount
          : downloadCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastVisitedAt: freezed == lastVisitedAt
          ? _value.lastVisitedAt
          : lastVisitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BrowserStatsImplCopyWith<$Res>
    implements $BrowserStatsCopyWith<$Res> {
  factory _$$BrowserStatsImplCopyWith(
          _$BrowserStatsImpl value, $Res Function(_$BrowserStatsImpl) then) =
      __$$BrowserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalPagesVisited,
      int totalVisitDuration,
      int dataUsage,
      int bookmarkCount,
      int historyCount,
      int downloadCount,
      DateTime? lastVisitedAt});
}

/// @nodoc
class __$$BrowserStatsImplCopyWithImpl<$Res>
    extends _$BrowserStatsCopyWithImpl<$Res, _$BrowserStatsImpl>
    implements _$$BrowserStatsImplCopyWith<$Res> {
  __$$BrowserStatsImplCopyWithImpl(
      _$BrowserStatsImpl _value, $Res Function(_$BrowserStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BrowserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPagesVisited = null,
    Object? totalVisitDuration = null,
    Object? dataUsage = null,
    Object? bookmarkCount = null,
    Object? historyCount = null,
    Object? downloadCount = null,
    Object? lastVisitedAt = freezed,
  }) {
    return _then(_$BrowserStatsImpl(
      totalPagesVisited: null == totalPagesVisited
          ? _value.totalPagesVisited
          : totalPagesVisited // ignore: cast_nullable_to_non_nullable
              as int,
      totalVisitDuration: null == totalVisitDuration
          ? _value.totalVisitDuration
          : totalVisitDuration // ignore: cast_nullable_to_non_nullable
              as int,
      dataUsage: null == dataUsage
          ? _value.dataUsage
          : dataUsage // ignore: cast_nullable_to_non_nullable
              as int,
      bookmarkCount: null == bookmarkCount
          ? _value.bookmarkCount
          : bookmarkCount // ignore: cast_nullable_to_non_nullable
              as int,
      historyCount: null == historyCount
          ? _value.historyCount
          : historyCount // ignore: cast_nullable_to_non_nullable
              as int,
      downloadCount: null == downloadCount
          ? _value.downloadCount
          : downloadCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastVisitedAt: freezed == lastVisitedAt
          ? _value.lastVisitedAt
          : lastVisitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BrowserStatsImpl implements _BrowserStats {
  const _$BrowserStatsImpl(
      {this.totalPagesVisited = 0,
      this.totalVisitDuration = 0,
      this.dataUsage = 0,
      this.bookmarkCount = 0,
      this.historyCount = 0,
      this.downloadCount = 0,
      this.lastVisitedAt});

  factory _$BrowserStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BrowserStatsImplFromJson(json);

  /// 总访问页面数
  @override
  @JsonKey()
  final int totalPagesVisited;

  /// 总访问时长（秒）
  @override
  @JsonKey()
  final int totalVisitDuration;

  /// 数据使用量（字节）
  @override
  @JsonKey()
  final int dataUsage;

  /// 书签数量
  @override
  @JsonKey()
  final int bookmarkCount;

  /// 历史记录数量
  @override
  @JsonKey()
  final int historyCount;

  /// 下载任务数量
  @override
  @JsonKey()
  final int downloadCount;

  /// 最后访问时间
  @override
  final DateTime? lastVisitedAt;

  @override
  String toString() {
    return 'BrowserStats(totalPagesVisited: $totalPagesVisited, totalVisitDuration: $totalVisitDuration, dataUsage: $dataUsage, bookmarkCount: $bookmarkCount, historyCount: $historyCount, downloadCount: $downloadCount, lastVisitedAt: $lastVisitedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrowserStatsImpl &&
            (identical(other.totalPagesVisited, totalPagesVisited) ||
                other.totalPagesVisited == totalPagesVisited) &&
            (identical(other.totalVisitDuration, totalVisitDuration) ||
                other.totalVisitDuration == totalVisitDuration) &&
            (identical(other.dataUsage, dataUsage) ||
                other.dataUsage == dataUsage) &&
            (identical(other.bookmarkCount, bookmarkCount) ||
                other.bookmarkCount == bookmarkCount) &&
            (identical(other.historyCount, historyCount) ||
                other.historyCount == historyCount) &&
            (identical(other.downloadCount, downloadCount) ||
                other.downloadCount == downloadCount) &&
            (identical(other.lastVisitedAt, lastVisitedAt) ||
                other.lastVisitedAt == lastVisitedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of BrowserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BrowserStatsImplCopyWith<_$BrowserStatsImpl> get copyWith =>
      __$$BrowserStatsImplCopyWithImpl<_$BrowserStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BrowserStatsImplToJson(
      this,
    );
  }
}

abstract class _BrowserStats implements BrowserStats {
  const factory _BrowserStats(
      {final int totalPagesVisited,
      final int totalVisitDuration,
      final int dataUsage,
      final int bookmarkCount,
      final int historyCount,
      final int downloadCount,
      final DateTime? lastVisitedAt}) = _$BrowserStatsImpl;

  factory _BrowserStats.fromJson(Map<String, dynamic> json) =
      _$BrowserStatsImpl.fromJson;

  /// 总访问页面数
  @override
  int get totalPagesVisited;

  /// 总访问时长（秒）
  @override
  int get totalVisitDuration;

  /// 数据使用量（字节）
  @override
  int get dataUsage;

  /// 书签数量
  @override
  int get bookmarkCount;

  /// 历史记录数量
  @override
  int get historyCount;

  /// 下载任务数量
  @override
  int get downloadCount;

  /// 最后访问时间
  @override
  DateTime? get lastVisitedAt;

  /// Create a copy of BrowserStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrowserStatsImplCopyWith<_$BrowserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
