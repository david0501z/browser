// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'BrowserTab.dart';

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
  /// 标签页唯一标识符
  String get id => throw _privateConstructorUsedError;

  /// 当前页面URL
  String get url => throw _privateConstructorUsedError;

  /// 页面标题
  String get title => throw _privateConstructorUsedError;

  /// 页面图标URL或Base64编码
  String? get favicon => throw _privateConstructorUsedError;

  /// 是否为固定标签页
  bool get pinned => throw _privateConstructorUsedError;

  /// 是否为无痕模式标签页
  bool get incognito => throw _privateConstructorUsedError;

  /// 是否正在加载中
  bool get isLoading => throw _privateConstructorUsedError;

  /// 是否可前进
  bool get canGoForward => throw _privateConstructorUsedError;

  /// 是否可后退
  bool get canGoBack => throw _privateConstructorUsedError;

  /// 标签页创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 标签页最后更新时间
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// 访问次数统计
  int get visitCount => throw _privateConstructorUsedError;

  /// 标签页缩略图Base64编码
  String? get thumbnail => throw _privateConstructorUsedError;

  /// 页面加载进度 (0-100)
  int get progress => throw _privateConstructorUsedError;

  /// 安全状态 (https/http)
  BrowserSecurityStatus get securityStatus =>
      throw _privateConstructorUsedError;

  /// 页面加载错误信息
  String? get errorMessage => throw _privateConstructorUsedError;

  /// 自定义标签页标题（用户可编辑）
  String? get customTitle => throw _privateConstructorUsedError;

  /// 标签页备注
  String? get note => throw _privateConstructorUsedError;

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
    Object? title = null,
    Object? favicon = freezed,
    Object? pinned = null,
    Object? incognito = null,
    Object? isLoading = null,
    Object? canGoForward = null,
    Object? canGoBack = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? visitCount = null,
    Object? thumbnail = freezed,
    Object? progress = null,
    Object? securityStatus = null,
    Object? errorMessage = freezed,
    Object? customTitle = freezed,
    Object? note = freezed,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      favicon: freezed == favicon
          ? _value.favicon
          : favicon // ignore: cast_nullable_to_non_nullable
              as String?,
      pinned: null == pinned
          ? _value.pinned
          : pinned // ignore: cast_nullable_to_non_nullable
              as bool,
      incognito: null == incognito
          ? _value.incognito
          : incognito // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      canGoForward: null == canGoForward
          ? _value.canGoForward
          : canGoForward // ignore: cast_nullable_to_non_nullable
              as bool,
      canGoBack: null == canGoBack
          ? _value.canGoBack
          : canGoBack // ignore: cast_nullable_to_non_nullable
              as bool,
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
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      securityStatus: null == securityStatus
          ? _value.securityStatus
          : securityStatus // ignore: cast_nullable_to_non_nullable
              as BrowserSecurityStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      customTitle: freezed == customTitle
          ? _value.customTitle
          : customTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
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
    Object? title = null,
    Object? favicon = freezed,
    Object? pinned = null,
    Object? incognito = null,
    Object? isLoading = null,
    Object? canGoForward = null,
    Object? canGoBack = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? visitCount = null,
    Object? thumbnail = freezed,
    Object? progress = null,
    Object? securityStatus = null,
    Object? errorMessage = freezed,
    Object? customTitle = freezed,
    Object? note = freezed,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      favicon: freezed == favicon
          ? _value.favicon
          : favicon // ignore: cast_nullable_to_non_nullable
              as String?,
      pinned: null == pinned
          ? _value.pinned
          : pinned // ignore: cast_nullable_to_non_nullable
              as bool,
      incognito: null == incognito
          ? _value.incognito
          : incognito // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      canGoForward: null == canGoForward
          ? _value.canGoForward
          : canGoForward // ignore: cast_nullable_to_non_nullable
              as bool,
      canGoBack: null == canGoBack
          ? _value.canGoBack
          : canGoBack // ignore: cast_nullable_to_non_nullable
              as bool,
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
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      securityStatus: null == securityStatus
          ? _value.securityStatus
          : securityStatus // ignore: cast_nullable_to_non_nullable
              as BrowserSecurityStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      customTitle: freezed == customTitle
          ? _value.customTitle
          : customTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BrowserTabImpl implements _BrowserTab {
  const _$BrowserTabImpl(
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

  factory _$BrowserTabImpl.fromJson(Map<String, dynamic> json) =>
      _$$BrowserTabImplFromJson(json);

  /// 标签页唯一标识符
  @override
  final String id;

  /// 当前页面URL
  @override
  final String url;

  /// 页面标题
  @override
  final String title;

  /// 页面图标URL或Base64编码
  @override
  final String? favicon;

  /// 是否为固定标签页
  @override
  @JsonKey()
  final bool pinned;

  /// 是否为无痕模式标签页
  @override
  @JsonKey()
  final bool incognito;

  /// 是否正在加载中
  @override
  @JsonKey()
  final bool isLoading;

  /// 是否可前进
  @override
  @JsonKey()
  final bool canGoForward;

  /// 是否可后退
  @override
  @JsonKey()
  final bool canGoBack;

  /// 标签页创建时间
  @override
  final DateTime createdAt;

  /// 标签页最后更新时间
  @override
  final DateTime updatedAt;

  /// 访问次数统计
  @override
  @JsonKey()
  final int visitCount;

  /// 标签页缩略图Base64编码
  @override
  final String? thumbnail;

  /// 页面加载进度 (0-100)
  @override
  @JsonKey()
  final int progress;

  /// 安全状态 (https/http)
  @override
  @JsonKey()
  final BrowserSecurityStatus securityStatus;

  /// 页面加载错误信息
  @override
  final String? errorMessage;

  /// 自定义标签页标题（用户可编辑）
  @override
  final String? customTitle;

  /// 标签页备注
  @override
  final String? note;

  @override
  String toString() {
    return 'BrowserTab(id: $id, url: $url, title: $title, favicon: $favicon, pinned: $pinned, incognito: $incognito, isLoading: $isLoading, canGoForward: $canGoForward, canGoBack: $canGoBack, createdAt: $createdAt, updatedAt: $updatedAt, visitCount: $visitCount, thumbnail: $thumbnail, progress: $progress, securityStatus: $securityStatus, errorMessage: $errorMessage, customTitle: $customTitle, note: $note)';
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
            (identical(other.incognito, incognito) ||
                other.incognito == incognito) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.canGoForward, canGoForward) ||
                other.canGoForward == canGoForward) &&
            (identical(other.canGoBack, canGoBack) ||
                other.canGoBack == canGoBack) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.visitCount, visitCount) ||
                other.visitCount == visitCount) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.securityStatus, securityStatus) ||
                other.securityStatus == securityStatus) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.customTitle, customTitle) ||
                other.customTitle == customTitle) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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
      required final String title,
      final String? favicon,
      final bool pinned,
      final bool incognito,
      final bool isLoading,
      final bool canGoForward,
      final bool canGoBack,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final int visitCount,
      final String? thumbnail,
      final int progress,
      final BrowserSecurityStatus securityStatus,
      final String? errorMessage,
      final String? customTitle,
      final String? note}) = _$BrowserTabImpl;

  factory _BrowserTab.fromJson(Map<String, dynamic> json) =
      _$BrowserTabImpl.fromJson;

  /// 标签页唯一标识符
  @override
  String get id;

  /// 当前页面URL
  @override
  String get url;

  /// 页面标题
  @override
  String get title;

  /// 页面图标URL或Base64编码
  @override
  String? get favicon;

  /// 是否为固定标签页
  @override
  bool get pinned;

  /// 是否为无痕模式标签页
  @override
  bool get incognito;

  /// 是否正在加载中
  @override
  bool get isLoading;

  /// 是否可前进
  @override
  bool get canGoForward;

  /// 是否可后退
  @override
  bool get canGoBack;

  /// 标签页创建时间
  @override
  DateTime get createdAt;

  /// 标签页最后更新时间
  @override
  DateTime get updatedAt;

  /// 访问次数统计
  @override
  int get visitCount;

  /// 标签页缩略图Base64编码
  @override
  String? get thumbnail;

  /// 页面加载进度 (0-100)
  @override
  int get progress;

  /// 安全状态 (https/http)
  @override
  BrowserSecurityStatus get securityStatus;

  /// 页面加载错误信息
  @override
  String? get errorMessage;

  /// 自定义标签页标题（用户可编辑）
  @override
  String? get customTitle;

  /// 标签页备注
  @override
  String? get note;

  /// Create a copy of BrowserTab
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrowserTabImplCopyWith<_$BrowserTabImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
