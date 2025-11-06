// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubscriptionLink _$SubscriptionLinkFromJson(Map<String, dynamic> json) {
  return _SubscriptionLink.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionLink {
  /// 订阅 ID
  String get id => throw _privateConstructorUsedError;

  /// 订阅名称
  String get name => throw _privateConstructorUsedError;

  /// 订阅 URL
  String get url => throw _privateConstructorUsedError;

  /// 订阅类型
  SubscriptionType get type => throw _privateConstructorUsedError;

  /// 订阅状态
  SubscriptionStatus get status => throw _privateConstructorUsedError;

  /// 上次更新时间
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// 下次更新计划时间
  DateTime? get nextUpdate => throw _privateConstructorUsedError;

  /// 更新间隔（小时）
  int get updateIntervalHours => throw _privateConstructorUsedError;

  /// 是否自动更新
  bool get autoUpdate => throw _privateConstructorUsedError;

  /// 是否启用
  bool get enabled => throw _privateConstructorUsedError;

  /// 节点列表
  List<ProxyNode> get nodes => throw _privateConstructorUsedError;

  /// 订阅描述
  String? get description => throw _privateConstructorUsedError;

  /// 订阅分组信息
  List<String>? get groups => throw _privateConstructorUsedError;

  /// 订阅标签
  List<String>? get tags => throw _privateConstructorUsedError;

  /// 订阅来源
  String? get source => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// 错误信息
  String? get errorMessage => throw _privateConstructorUsedError;

  /// 解析结果统计
  ParseStats get parseStats => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionLink to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionLinkCopyWith<SubscriptionLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionLinkCopyWith<$Res> {
  factory $SubscriptionLinkCopyWith(
          SubscriptionLink value, $Res Function(SubscriptionLink) then) =;
      _$SubscriptionLinkCopyWithImpl<$Res, SubscriptionLink>;
  @useResult
  $Res call(
      {String id,
      String name,
      String url,
      SubscriptionType type,
      SubscriptionStatus status,
      DateTime? lastUpdated,
      DateTime? nextUpdate,
      int updateIntervalHours,
      bool autoUpdate,
      bool enabled,
      List<ProxyNode> nodes,
      String? description,
      List<String>? groups,
      List<String>? tags,
      String? source,
      DateTime createdAt,
      DateTime? updatedAt,
      String? errorMessage,
      ParseStats parseStats});

  $ParseStatsCopyWith<$Res> get parseStats;
}

/// @nodoc
class _$SubscriptionLinkCopyWithImpl<$Res, $Val extends SubscriptionLink>
    implements $SubscriptionLinkCopyWith<$Res> {
  _$SubscriptionLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? url = null,
    Object? type = null,
    Object? status = null,
    Object? lastUpdated = freezed,
    Object? nextUpdate = freezed,
    Object? updateIntervalHours = null,
    Object? autoUpdate = null,
    Object? enabled = null,
    Object? nodes = null,
    Object? description = freezed,
    Object? groups = freezed,
    Object? tags = freezed,
    Object? source = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? errorMessage = freezed,
    Object? parseStats = null,
  }) {
    return _then(_value.copyWith(
      id: null == id;
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name;
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url;
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type;
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SubscriptionType,
      status: null == status;
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubscriptionStatus,
      lastUpdated: freezed == lastUpdated;
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextUpdate: freezed == nextUpdate;
          ? _value.nextUpdate
          : nextUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updateIntervalHours: null == updateIntervalHours;
          ? _value.updateIntervalHours
          : updateIntervalHours // ignore: cast_nullable_to_non_nullable
              as int,
      autoUpdate: null == autoUpdate;
          ? _value.autoUpdate
          : autoUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
      enabled: null == enabled;
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      nodes: null == nodes;
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<ProxyNode>,
      description: freezed == description;
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      groups: freezed == groups;
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: freezed == tags;
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      source: freezed == source;
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt;
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt;
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      errorMessage: freezed == errorMessage;
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      parseStats: null == parseStats;
          ? _value.parseStats
          : parseStats // ignore: cast_nullable_to_non_nullable
              as ParseStats,
    ) as $Val);
  }

  /// Create a copy of SubscriptionLink
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParseStatsCopyWith<$Res> get parseStats {
    return $ParseStatsCopyWith<$Res>(_value.parseStats, (value) {
      return _then(_value.copyWith(parseStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SubscriptionLinkImplCopyWith<$Res>
    implements $SubscriptionLinkCopyWith<$Res> {
  factory _$$SubscriptionLinkImplCopyWith(_$SubscriptionLinkImpl value,
          $Res Function(_$SubscriptionLinkImpl) then) =;
      __$$SubscriptionLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String url,
      SubscriptionType type,
      SubscriptionStatus status,
      DateTime? lastUpdated,
      DateTime? nextUpdate,
      int updateIntervalHours,
      bool autoUpdate,
      bool enabled,
      List<ProxyNode> nodes,
      String? description,
      List<String>? groups,
      List<String>? tags,
      String? source,
      DateTime createdAt,
      DateTime? updatedAt,
      String? errorMessage,
      ParseStats parseStats});

  @override
  $ParseStatsCopyWith<$Res> get parseStats;
}

/// @nodoc
class __$$SubscriptionLinkImplCopyWithImpl<$Res>
    extends _$SubscriptionLinkCopyWithImpl<$Res, _$SubscriptionLinkImpl>
    implements _$$SubscriptionLinkImplCopyWith<$Res> {
  __$$SubscriptionLinkImplCopyWithImpl(_$SubscriptionLinkImpl _value,
      $Res Function(_$SubscriptionLinkImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? url = null,
    Object? type = null,
    Object? status = null,
    Object? lastUpdated = freezed,
    Object? nextUpdate = freezed,
    Object? updateIntervalHours = null,
    Object? autoUpdate = null,
    Object? enabled = null,
    Object? nodes = null,
    Object? description = freezed,
    Object? groups = freezed,
    Object? tags = freezed,
    Object? source = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? errorMessage = freezed,
    Object? parseStats = null,
  }) {
    return _then(_$SubscriptionLinkImpl(
      id: null == id;
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name;
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url;
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type;
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SubscriptionType,
      status: null == status;
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubscriptionStatus,
      lastUpdated: freezed == lastUpdated;
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextUpdate: freezed == nextUpdate;
          ? _value.nextUpdate
          : nextUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updateIntervalHours: null == updateIntervalHours;
          ? _value.updateIntervalHours
          : updateIntervalHours // ignore: cast_nullable_to_non_nullable
              as int,
      autoUpdate: null == autoUpdate;
          ? _value.autoUpdate
          : autoUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
      enabled: null == enabled;
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      nodes: null == nodes;
          ? _value._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<ProxyNode>,
      description: freezed == description;
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      groups: freezed == groups;
          ? _value._groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: freezed == tags;
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      source: freezed == source;
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt;
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt;
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      errorMessage: freezed == errorMessage;
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      parseStats: null == parseStats;
          ? _value.parseStats
          : parseStats // ignore: cast_nullable_to_non_nullable
              as ParseStats,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionLinkImpl implements _SubscriptionLink {
  const _$SubscriptionLinkImpl(
      {required this.id,
      required this.name,
      required this.url,
      this.type = SubscriptionType.unknown,
      this.status = SubscriptionStatus.active,
      this.lastUpdated,
      this.nextUpdate,
      this.updateIntervalHours = 24,
      this.autoUpdate = true,
      this.enabled = true,
      final List<ProxyNode> nodes = const [],
      this.description,
      final List<String>? groups,
      final List<String>? tags,
      this.source,
      this.createdAt = DateTime.now,
      this.updatedAt,
      this.errorMessage,
      this.parseStats = _emptyStats});
      : _nodes = nodes,
        _groups = groups,
        _tags = tags;

  factory _$SubscriptionLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionLinkImplFromJson(json);

  /// 订阅 ID
  @override
  final String id;

  /// 订阅名称
  @override
  final String name;

  /// 订阅 URL
  @override
  final String url;

  /// 订阅类型
  @override
  @JsonKey()
  final SubscriptionType type;

  /// 订阅状态
  @override
  @JsonKey()
  final SubscriptionStatus status;

  /// 上次更新时间
  @override
  final DateTime? lastUpdated;

  /// 下次更新计划时间
  @override
  final DateTime? nextUpdate;

  /// 更新间隔（小时）
  @override
  @JsonKey()
  final int updateIntervalHours;

  /// 是否自动更新
  @override
  @JsonKey()
  final bool autoUpdate;

  /// 是否启用
  @override
  @JsonKey()
  final bool enabled;

  /// 节点列表
  final List<ProxyNode> _nodes;

  /// 节点列表
  @override
  @JsonKey()
  List<ProxyNode> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  /// 订阅描述
  @override
  final String? description;

  /// 订阅分组信息
  final List<String>? _groups;

  /// 订阅分组信息
  @override
  List<String>? get groups {
    final value = _groups;
    if (value == null) return null;
    if (_groups is EqualUnmodifiableListView) return _groups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 订阅标签
  final List<String>? _tags;

  /// 订阅标签
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 订阅来源
  @override
  final String? source;

  /// 创建时间
  @override
  @JsonKey()
  final DateTime createdAt;

  /// 更新时间
  @override
  final DateTime? updatedAt;

  /// 错误信息
  @override
  final String? errorMessage;

  /// 解析结果统计
  @override
  @JsonKey()
  final ParseStats parseStats;

  @override
  String toString() {
    return 'SubscriptionLink(id: $id, name: $name, url: $url, type: $type, status: $status, lastUpdated: $lastUpdated, nextUpdate: $nextUpdate, updateIntervalHours: $updateIntervalHours, autoUpdate: $autoUpdate, enabled: $enabled, nodes: $nodes, description: $description, groups: $groups, tags: $tags, source: $source, createdAt: $createdAt, updatedAt: $updatedAt, errorMessage: $errorMessage, parseStats: $parseStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionLinkImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.nextUpdate, nextUpdate) ||
                other.nextUpdate == nextUpdate) &&
            (identical(other.updateIntervalHours, updateIntervalHours) ||
                other.updateIntervalHours == updateIntervalHours) &&
            (identical(other.autoUpdate, autoUpdate) ||
                other.autoUpdate == autoUpdate) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._groups, _groups) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.parseStats, parseStats) ||
                other.parseStats == parseStats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([;
        runtimeType,
        id,
        name,
        url,
        type,
        status,
        lastUpdated,
        nextUpdate,
        updateIntervalHours,
        autoUpdate,
        enabled,
        const DeepCollectionEquality().hash(_nodes),
        description,
        const DeepCollectionEquality().hash(_groups),
        const DeepCollectionEquality().hash(_tags),
        source,
        createdAt,
        updatedAt,
        errorMessage,
        parseStats
      ]);

  /// Create a copy of SubscriptionLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionLinkImplCopyWith<_$SubscriptionLinkImpl> get copyWith =>
      __$$SubscriptionLinkImplCopyWithImpl<_$SubscriptionLinkImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionLinkImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionLink implements SubscriptionLink {
  const factory _SubscriptionLink(
      {required final String id,
      required final String name,
      required final String url,
      final SubscriptionType type,
      final SubscriptionStatus status,
      final DateTime? lastUpdated,
      final DateTime? nextUpdate,
      final int updateIntervalHours,
      final bool autoUpdate,
      final bool enabled,
      final List<ProxyNode> nodes,
      final String? description,
      final List<String>? groups,
      final List<String>? tags,
      final String? source,
      final DateTime createdAt,
      final DateTime? updatedAt,
      final String? errorMessage,
      final ParseStats parseStats}) = _$SubscriptionLinkImpl;

  factory _SubscriptionLink.fromJson(Map<String, dynamic> json) =;
      _$SubscriptionLinkImpl.fromJson;

  /// 订阅 ID
  @override
  String get id;

  /// 订阅名称
  @override
  String get name;

  /// 订阅 URL
  @override
  String get url;

  /// 订阅类型
  @override
  SubscriptionType get type;

  /// 订阅状态
  @override
  SubscriptionStatus get status;

  /// 上次更新时间
  @override
  DateTime? get lastUpdated;

  /// 下次更新计划时间
  @override
  DateTime? get nextUpdate;

  /// 更新间隔（小时）
  @override
  int get updateIntervalHours;

  /// 是否自动更新
  @override
  bool get autoUpdate;

  /// 是否启用
  @override
  bool get enabled;

  /// 节点列表
  @override
  List<ProxyNode> get nodes;

  /// 订阅描述
  @override
  String? get description;

  /// 订阅分组信息
  @override
  List<String>? get groups;

  /// 订阅标签
  @override
  List<String>? get tags;

  /// 订阅来源
  @override
  String? get source;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// 更新时间
  @override
  DateTime? get updatedAt;

  /// 错误信息
  @override
  String? get errorMessage;

  /// 解析结果统计
  @override
  ParseStats get parseStats;

  /// Create a copy of SubscriptionLink
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionLinkImplCopyWith<_$SubscriptionLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ParseStats _$ParseStatsFromJson(Map<String, dynamic> json) {
  return _ParseStats.fromJson(json);
}

/// @nodoc
mixin _$ParseStats {
  /// 总节点数
  int get totalNodes => throw _privateConstructorUsedError;

  /// 有效节点数
  int get validNodes => throw _privateConstructorUsedError;

  /// 无效节点数
  int get invalidNodes => throw _privateConstructorUsedError;

  /// 跳过节点数
  int get skippedNodes => throw _privateConstructorUsedError;

  /// 解析错误数
  int get parseErrors => throw _privateConstructorUsedError;

  /// 解析耗时（毫秒）
  int get parseTimeMs => throw _privateConstructorUsedError;

  /// 最后一次解析时间
  DateTime? get lastParsedAt => throw _privateConstructorUsedError;

  /// Serializes this ParseStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ParseStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParseStatsCopyWith<ParseStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParseStatsCopyWith<$Res> {
  factory $ParseStatsCopyWith(
          ParseStats value, $Res Function(ParseStats) then) =;
      _$ParseStatsCopyWithImpl<$Res, ParseStats>;
  @useResult
  $Res call(
      {int totalNodes,
      int validNodes,
      int invalidNodes,
      int skippedNodes,
      int parseErrors,
      int parseTimeMs,
      DateTime? lastParsedAt});
}

/// @nodoc
class _$ParseStatsCopyWithImpl<$Res, $Val extends ParseStats>
    implements $ParseStatsCopyWith<$Res> {
  _$ParseStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParseStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalNodes = null,
    Object? validNodes = null,
    Object? invalidNodes = null,
    Object? skippedNodes = null,
    Object? parseErrors = null,
    Object? parseTimeMs = null,
    Object? lastParsedAt = freezed,
  }) {
    return _then(_value.copyWith(
      totalNodes: null == totalNodes;
          ? _value.totalNodes
          : totalNodes // ignore: cast_nullable_to_non_nullable
              as int,
      validNodes: null == validNodes;
          ? _value.validNodes
          : validNodes // ignore: cast_nullable_to_non_nullable
              as int,
      invalidNodes: null == invalidNodes;
          ? _value.invalidNodes
          : invalidNodes // ignore: cast_nullable_to_non_nullable
              as int,
      skippedNodes: null == skippedNodes;
          ? _value.skippedNodes
          : skippedNodes // ignore: cast_nullable_to_non_nullable
              as int,
      parseErrors: null == parseErrors;
          ? _value.parseErrors
          : parseErrors // ignore: cast_nullable_to_non_nullable
              as int,
      parseTimeMs: null == parseTimeMs;
          ? _value.parseTimeMs
          : parseTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
      lastParsedAt: freezed == lastParsedAt;
          ? _value.lastParsedAt
          : lastParsedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParseStatsImplCopyWith<$Res>
    implements $ParseStatsCopyWith<$Res> {
  factory _$$ParseStatsImplCopyWith(
          _$ParseStatsImpl value, $Res Function(_$ParseStatsImpl) then) =;
      __$$ParseStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalNodes,
      int validNodes,
      int invalidNodes,
      int skippedNodes,
      int parseErrors,
      int parseTimeMs,
      DateTime? lastParsedAt});
}

/// @nodoc
class __$$ParseStatsImplCopyWithImpl<$Res>
    extends _$ParseStatsCopyWithImpl<$Res, _$ParseStatsImpl>
    implements _$$ParseStatsImplCopyWith<$Res> {
  __$$ParseStatsImplCopyWithImpl(
      _$ParseStatsImpl _value, $Res Function(_$ParseStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParseStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalNodes = null,
    Object? validNodes = null,
    Object? invalidNodes = null,
    Object? skippedNodes = null,
    Object? parseErrors = null,
    Object? parseTimeMs = null,
    Object? lastParsedAt = freezed,
  }) {
    return _then(_$ParseStatsImpl(
      totalNodes: null == totalNodes;
          ? _value.totalNodes
          : totalNodes // ignore: cast_nullable_to_non_nullable
              as int,
      validNodes: null == validNodes;
          ? _value.validNodes
          : validNodes // ignore: cast_nullable_to_non_nullable
              as int,
      invalidNodes: null == invalidNodes;
          ? _value.invalidNodes
          : invalidNodes // ignore: cast_nullable_to_non_nullable
              as int,
      skippedNodes: null == skippedNodes;
          ? _value.skippedNodes
          : skippedNodes // ignore: cast_nullable_to_non_nullable
              as int,
      parseErrors: null == parseErrors;
          ? _value.parseErrors
          : parseErrors // ignore: cast_nullable_to_non_nullable
              as int,
      parseTimeMs: null == parseTimeMs;
          ? _value.parseTimeMs
          : parseTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
      lastParsedAt: freezed == lastParsedAt;
          ? _value.lastParsedAt
          : lastParsedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParseStatsImpl implements _ParseStats {
  const _$ParseStatsImpl(
      {this.totalNodes = 0,
      this.validNodes = 0,
      this.invalidNodes = 0,
      this.skippedNodes = 0,
      this.parseErrors = 0,
      this.parseTimeMs = 0,
      this.lastParsedAt});

  factory _$ParseStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParseStatsImplFromJson(json);

  /// 总节点数
  @override
  @JsonKey()
  final int totalNodes;

  /// 有效节点数
  @override
  @JsonKey()
  final int validNodes;

  /// 无效节点数
  @override
  @JsonKey()
  final int invalidNodes;

  /// 跳过节点数
  @override
  @JsonKey()
  final int skippedNodes;

  /// 解析错误数
  @override
  @JsonKey()
  final int parseErrors;

  /// 解析耗时（毫秒）
  @override
  @JsonKey()
  final int parseTimeMs;

  /// 最后一次解析时间
  @override
  final DateTime? lastParsedAt;

  @override
  String toString() {
    return 'ParseStats(totalNodes: $totalNodes, validNodes: $validNodes, invalidNodes: $invalidNodes, skippedNodes: $skippedNodes, parseErrors: $parseErrors, parseTimeMs: $parseTimeMs, lastParsedAt: $lastParsedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParseStatsImpl &&
            (identical(other.totalNodes, totalNodes) ||
                other.totalNodes == totalNodes) &&
            (identical(other.validNodes, validNodes) ||
                other.validNodes == validNodes) &&
            (identical(other.invalidNodes, invalidNodes) ||
                other.invalidNodes == invalidNodes) &&
            (identical(other.skippedNodes, skippedNodes) ||
                other.skippedNodes == skippedNodes) &&
            (identical(other.parseErrors, parseErrors) ||
                other.parseErrors == parseErrors) &&
            (identical(other.parseTimeMs, parseTimeMs) ||
                other.parseTimeMs == parseTimeMs) &&
            (identical(other.lastParsedAt, lastParsedAt) ||
                other.lastParsedAt == lastParsedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalNodes, validNodes,
      invalidNodes, skippedNodes, parseErrors, parseTimeMs, lastParsedAt);

  /// Create a copy of ParseStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParseStatsImplCopyWith<_$ParseStatsImpl> get copyWith =>
      __$$ParseStatsImplCopyWithImpl<_$ParseStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParseStatsImplToJson(
      this,
    );
  }
}

abstract class _ParseStats implements ParseStats {
  const factory _ParseStats(
      {final int totalNodes,
      final int validNodes,
      final int invalidNodes,
      final int skippedNodes,
      final int parseErrors,
      final int parseTimeMs,
      final DateTime? lastParsedAt}) = _$ParseStatsImpl;

  factory _ParseStats.fromJson(Map<String, dynamic> json) =;
      _$ParseStatsImpl.fromJson;

  /// 总节点数
  @override
  int get totalNodes;

  /// 有效节点数
  @override
  int get validNodes;

  /// 无效节点数
  @override
  int get invalidNodes;

  /// 跳过节点数
  @override
  int get skippedNodes;

  /// 解析错误数
  @override
  int get parseErrors;

  /// 解析耗时（毫秒）
  @override
  int get parseTimeMs;

  /// 最后一次解析时间
  @override
  DateTime? get lastParsedAt;

  /// Create a copy of ParseStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParseStatsImplCopyWith<_$ParseStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) {
  return _Subscription.fromJson(json);
}

/// @nodoc
mixin _$Subscription {
  /// 当前激活的订阅 ID
  String? get activeSubscriptionId => throw _privateConstructorUsedError;

  /// 订阅列表
  List<SubscriptionLink> get subscriptions =>
      throw _privateConstructorUsedError;

  /// 是否正在更新所有订阅
  bool get isUpdating => throw _privateConstructorUsedError;

  /// 自动更新间隔（小时）
  int get globalUpdateIntervalHours => throw _privateConstructorUsedError;

  /// 是否启用自动更新
  bool get autoUpdateEnabled => throw _privateConstructorUsedError;

  /// 更新模式：并发或串行
  bool get concurrentUpdate => throw _privateConstructorUsedError;

  /// 订阅缓存策略
  CacheStrategy get cacheStrategy => throw _privateConstructorUsedError;

  /// 默认订阅设置
  SubscriptionSettings? get defaultSettings =>
      throw _privateConstructorUsedError;

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionCopyWith<Subscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionCopyWith<$Res> {
  factory $SubscriptionCopyWith(
          Subscription value, $Res Function(Subscription) then) =;
      _$SubscriptionCopyWithImpl<$Res, Subscription>;
  @useResult
  $Res call(
      {String? activeSubscriptionId,
      List<SubscriptionLink> subscriptions,
      bool isUpdating,
      int globalUpdateIntervalHours,
      bool autoUpdateEnabled,
      bool concurrentUpdate,
      CacheStrategy cacheStrategy,
      SubscriptionSettings? defaultSettings});

  $SubscriptionSettingsCopyWith<$Res>? get defaultSettings;
}

/// @nodoc
class _$SubscriptionCopyWithImpl<$Res, $Val extends Subscription>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeSubscriptionId = freezed,
    Object? subscriptions = null,
    Object? isUpdating = null,
    Object? globalUpdateIntervalHours = null,
    Object? autoUpdateEnabled = null,
    Object? concurrentUpdate = null,
    Object? cacheStrategy = null,
    Object? defaultSettings = freezed,
  }) {
    return _then(_value.copyWith(
      activeSubscriptionId: freezed == activeSubscriptionId;
          ? _value.activeSubscriptionId
          : activeSubscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      subscriptions: null == subscriptions;
          ? _value.subscriptions
          : subscriptions // ignore: cast_nullable_to_non_nullable
              as List<SubscriptionLink>,
      isUpdating: null == isUpdating;
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      globalUpdateIntervalHours: null == globalUpdateIntervalHours;
          ? _value.globalUpdateIntervalHours
          : globalUpdateIntervalHours // ignore: cast_nullable_to_non_nullable
              as int,
      autoUpdateEnabled: null == autoUpdateEnabled;
          ? _value.autoUpdateEnabled
          : autoUpdateEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      concurrentUpdate: null == concurrentUpdate;
          ? _value.concurrentUpdate
          : concurrentUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
      cacheStrategy: null == cacheStrategy;
          ? _value.cacheStrategy
          : cacheStrategy // ignore: cast_nullable_to_non_nullable
              as CacheStrategy,
      defaultSettings: freezed == defaultSettings;
          ? _value.defaultSettings
          : defaultSettings // ignore: cast_nullable_to_non_nullable
              as SubscriptionSettings?,
    ) as $Val);
  }

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubscriptionSettingsCopyWith<$Res>? get defaultSettings {
    if (_value.defaultSettings == null) {
      return null;
    }

    return $SubscriptionSettingsCopyWith<$Res>(_value.defaultSettings!,
        (value) {
      return _then(_value.copyWith(defaultSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SubscriptionImplCopyWith<$Res>
    implements $SubscriptionCopyWith<$Res> {
  factory _$$SubscriptionImplCopyWith(
          _$SubscriptionImpl value, $Res Function(_$SubscriptionImpl) then) =;
      __$$SubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? activeSubscriptionId,
      List<SubscriptionLink> subscriptions,
      bool isUpdating,
      int globalUpdateIntervalHours,
      bool autoUpdateEnabled,
      bool concurrentUpdate,
      CacheStrategy cacheStrategy,
      SubscriptionSettings? defaultSettings});

  @override
  $SubscriptionSettingsCopyWith<$Res>? get defaultSettings;
}

/// @nodoc
class __$$SubscriptionImplCopyWithImpl<$Res>
    extends _$SubscriptionCopyWithImpl<$Res, _$SubscriptionImpl>
    implements _$$SubscriptionImplCopyWith<$Res> {
  __$$SubscriptionImplCopyWithImpl(
      _$SubscriptionImpl _value, $Res Function(_$SubscriptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeSubscriptionId = freezed,
    Object? subscriptions = null,
    Object? isUpdating = null,
    Object? globalUpdateIntervalHours = null,
    Object? autoUpdateEnabled = null,
    Object? concurrentUpdate = null,
    Object? cacheStrategy = null,
    Object? defaultSettings = freezed,
  }) {
    return _then(_$SubscriptionImpl(
      activeSubscriptionId: freezed == activeSubscriptionId;
          ? _value.activeSubscriptionId
          : activeSubscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      subscriptions: null == subscriptions;
          ? _value._subscriptions
          : subscriptions // ignore: cast_nullable_to_non_nullable
              as List<SubscriptionLink>,
      isUpdating: null == isUpdating;
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      globalUpdateIntervalHours: null == globalUpdateIntervalHours;
          ? _value.globalUpdateIntervalHours
          : globalUpdateIntervalHours // ignore: cast_nullable_to_non_nullable
              as int,
      autoUpdateEnabled: null == autoUpdateEnabled;
          ? _value.autoUpdateEnabled
          : autoUpdateEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      concurrentUpdate: null == concurrentUpdate;
          ? _value.concurrentUpdate
          : concurrentUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
      cacheStrategy: null == cacheStrategy;
          ? _value.cacheStrategy
          : cacheStrategy // ignore: cast_nullable_to_non_nullable
              as CacheStrategy,
      defaultSettings: freezed == defaultSettings;
          ? _value.defaultSettings
          : defaultSettings // ignore: cast_nullable_to_non_nullable
              as SubscriptionSettings?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionImpl implements _Subscription {
  const _$SubscriptionImpl(
      {this.activeSubscriptionId,
      final List<SubscriptionLink> subscriptions = const [],
      this.isUpdating = false,
      this.globalUpdateIntervalHours = 24,
      this.autoUpdateEnabled = true,
      this.concurrentUpdate = true,
      this.cacheStrategy = CacheStrategy.memory,
      this.defaultSettings})
      : _subscriptions = subscriptions;

  factory _$SubscriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionImplFromJson(json);

  /// 当前激活的订阅 ID
  @override
  final String? activeSubscriptionId;

  /// 订阅列表
  final List<SubscriptionLink> _subscriptions;

  /// 订阅列表
  @override
  @JsonKey()
  List<SubscriptionLink> get subscriptions {
    if (_subscriptions is EqualUnmodifiableListView) return _subscriptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subscriptions);
  }

  /// 是否正在更新所有订阅
  @override
  @JsonKey()
  final bool isUpdating;

  /// 自动更新间隔（小时）
  @override
  @JsonKey()
  final int globalUpdateIntervalHours;

  /// 是否启用自动更新
  @override
  @JsonKey()
  final bool autoUpdateEnabled;

  /// 更新模式：并发或串行
  @override
  @JsonKey()
  final bool concurrentUpdate;

  /// 订阅缓存策略
  @override
  @JsonKey()
  final CacheStrategy cacheStrategy;

  /// 默认订阅设置
  @override
  final SubscriptionSettings? defaultSettings;

  @override
  String toString() {
    return 'Subscription(activeSubscriptionId: $activeSubscriptionId, subscriptions: $subscriptions, isUpdating: $isUpdating, globalUpdateIntervalHours: $globalUpdateIntervalHours, autoUpdateEnabled: $autoUpdateEnabled, concurrentUpdate: $concurrentUpdate, cacheStrategy: $cacheStrategy, defaultSettings: $defaultSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionImpl &&
            (identical(other.activeSubscriptionId, activeSubscriptionId) ||
                other.activeSubscriptionId == activeSubscriptionId) &&
            const DeepCollectionEquality()
                .equals(other._subscriptions, _subscriptions) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating) &&
            (identical(other.globalUpdateIntervalHours,
                    globalUpdateIntervalHours) ||
                other.globalUpdateIntervalHours == globalUpdateIntervalHours) &&
            (identical(other.autoUpdateEnabled, autoUpdateEnabled) ||
                other.autoUpdateEnabled == autoUpdateEnabled) &&
            (identical(other.concurrentUpdate, concurrentUpdate) ||
                other.concurrentUpdate == concurrentUpdate) &&
            (identical(other.cacheStrategy, cacheStrategy) ||
                other.cacheStrategy == cacheStrategy) &&
            (identical(other.defaultSettings, defaultSettings) ||
                other.defaultSettings == defaultSettings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      activeSubscriptionId,
      const DeepCollectionEquality().hash(_subscriptions),
      isUpdating,
      globalUpdateIntervalHours,
      autoUpdateEnabled,
      concurrentUpdate,
      cacheStrategy,
      defaultSettings);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      __$$SubscriptionImplCopyWithImpl<_$SubscriptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionImplToJson(
      this,
    );
  }
}

abstract class _Subscription implements Subscription {
  const factory _Subscription(
      {final String? activeSubscriptionId,
      final List<SubscriptionLink> subscriptions,
      final bool isUpdating,
      final int globalUpdateIntervalHours,
      final bool autoUpdateEnabled,
      final bool concurrentUpdate,
      final CacheStrategy cacheStrategy,
      final SubscriptionSettings? defaultSettings}) = _$SubscriptionImpl;

  factory _Subscription.fromJson(Map<String, dynamic> json) =;
      _$SubscriptionImpl.fromJson;

  /// 当前激活的订阅 ID
  @override
  String? get activeSubscriptionId;

  /// 订阅列表
  @override
  List<SubscriptionLink> get subscriptions;

  /// 是否正在更新所有订阅
  @override
  bool get isUpdating;

  /// 自动更新间隔（小时）
  @override
  int get globalUpdateIntervalHours;

  /// 是否启用自动更新
  @override
  bool get autoUpdateEnabled;

  /// 更新模式：并发或串行
  @override
  bool get concurrentUpdate;

  /// 订阅缓存策略
  @override
  CacheStrategy get cacheStrategy;

  /// 默认订阅设置
  @override
  SubscriptionSettings? get defaultSettings;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubscriptionSettings _$SubscriptionSettingsFromJson(Map<String, dynamic> json) {
  return _SubscriptionSettings.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionSettings {
  /// 连接超时时间（秒）
  int get connectTimeoutSeconds => throw _privateConstructorUsedError;

  /// 读取超时时间（秒）
  int get readTimeoutSeconds => throw _privateConstructorUsedError;

  /// 最大重试次数
  int get maxRetries => throw _privateConstructorUsedError;

  /// 是否验证 SSL 证书
  bool get verifySSLCert => throw _privateConstructorUsedError;

  /// 是否使用代理获取订阅
  bool get useProxy => throw _privateConstructorUsedError;

  /// 订阅获取代理地址
  String? get proxyUrl => throw _privateConstructorUsedError;

  /// 是否自动合并相同节点
  bool get mergeDuplicateNodes => throw _privateConstructorUsedError;

  /// 是否过滤重复节点
  bool get filterDuplicateNodes => throw _privateConstructorUsedError;

  /// 节点验证级别
  ValidationLevel get validationLevel => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionSettingsCopyWith<SubscriptionSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionSettingsCopyWith<$Res> {
  factory $SubscriptionSettingsCopyWith(SubscriptionSettings value,
          $Res Function(SubscriptionSettings) then) =;
      _$SubscriptionSettingsCopyWithImpl<$Res, SubscriptionSettings>;
  @useResult
  $Res call(
      {int connectTimeoutSeconds,
      int readTimeoutSeconds,
      int maxRetries,
      bool verifySSLCert,
      bool useProxy,
      String? proxyUrl,
      bool mergeDuplicateNodes,
      bool filterDuplicateNodes,
      ValidationLevel validationLevel});
}

/// @nodoc
class _$SubscriptionSettingsCopyWithImpl<$Res,
        $Val extends SubscriptionSettings>
    implements $SubscriptionSettingsCopyWith<$Res> {
  _$SubscriptionSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectTimeoutSeconds = null,
    Object? readTimeoutSeconds = null,
    Object? maxRetries = null,
    Object? verifySSLCert = null,
    Object? useProxy = null,
    Object? proxyUrl = freezed,
    Object? mergeDuplicateNodes = null,
    Object? filterDuplicateNodes = null,
    Object? validationLevel = null,
  }) {
    return _then(_value.copyWith(
      connectTimeoutSeconds: null == connectTimeoutSeconds;
          ? _value.connectTimeoutSeconds
          : connectTimeoutSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      readTimeoutSeconds: null == readTimeoutSeconds;
          ? _value.readTimeoutSeconds
          : readTimeoutSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      maxRetries: null == maxRetries;
          ? _value.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      verifySSLCert: null == verifySSLCert;
          ? _value.verifySSLCert
          : verifySSLCert // ignore: cast_nullable_to_non_nullable
              as bool,
      useProxy: null == useProxy;
          ? _value.useProxy
          : useProxy // ignore: cast_nullable_to_non_nullable
              as bool,
      proxyUrl: freezed == proxyUrl;
          ? _value.proxyUrl
          : proxyUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      mergeDuplicateNodes: null == mergeDuplicateNodes;
          ? _value.mergeDuplicateNodes
          : mergeDuplicateNodes // ignore: cast_nullable_to_non_nullable
              as bool,
      filterDuplicateNodes: null == filterDuplicateNodes;
          ? _value.filterDuplicateNodes
          : filterDuplicateNodes // ignore: cast_nullable_to_non_nullable
              as bool,
      validationLevel: null == validationLevel;
          ? _value.validationLevel
          : validationLevel // ignore: cast_nullable_to_non_nullable
              as ValidationLevel,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionSettingsImplCopyWith<$Res>
    implements $SubscriptionSettingsCopyWith<$Res> {
  factory _$$SubscriptionSettingsImplCopyWith(_$SubscriptionSettingsImpl value,
          $Res Function(_$SubscriptionSettingsImpl) then) =;
      __$$SubscriptionSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int connectTimeoutSeconds,
      int readTimeoutSeconds,
      int maxRetries,
      bool verifySSLCert,
      bool useProxy,
      String? proxyUrl,
      bool mergeDuplicateNodes,
      bool filterDuplicateNodes,
      ValidationLevel validationLevel});
}

/// @nodoc
class __$$SubscriptionSettingsImplCopyWithImpl<$Res>
    extends _$SubscriptionSettingsCopyWithImpl<$Res, _$SubscriptionSettingsImpl>
    implements _$$SubscriptionSettingsImplCopyWith<$Res> {
  __$$SubscriptionSettingsImplCopyWithImpl(_$SubscriptionSettingsImpl _value,
      $Res Function(_$SubscriptionSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectTimeoutSeconds = null,
    Object? readTimeoutSeconds = null,
    Object? maxRetries = null,
    Object? verifySSLCert = null,
    Object? useProxy = null,
    Object? proxyUrl = freezed,
    Object? mergeDuplicateNodes = null,
    Object? filterDuplicateNodes = null,
    Object? validationLevel = null,
  }) {
    return _then(_$SubscriptionSettingsImpl(
      connectTimeoutSeconds: null == connectTimeoutSeconds;
          ? _value.connectTimeoutSeconds
          : connectTimeoutSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      readTimeoutSeconds: null == readTimeoutSeconds;
          ? _value.readTimeoutSeconds
          : readTimeoutSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      maxRetries: null == maxRetries;
          ? _value.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      verifySSLCert: null == verifySSLCert;
          ? _value.verifySSLCert
          : verifySSLCert // ignore: cast_nullable_to_non_nullable
              as bool,
      useProxy: null == useProxy;
          ? _value.useProxy
          : useProxy // ignore: cast_nullable_to_non_nullable
              as bool,
      proxyUrl: freezed == proxyUrl;
          ? _value.proxyUrl
          : proxyUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      mergeDuplicateNodes: null == mergeDuplicateNodes;
          ? _value.mergeDuplicateNodes
          : mergeDuplicateNodes // ignore: cast_nullable_to_non_nullable
              as bool,
      filterDuplicateNodes: null == filterDuplicateNodes;
          ? _value.filterDuplicateNodes
          : filterDuplicateNodes // ignore: cast_nullable_to_non_nullable
              as bool,
      validationLevel: null == validationLevel;
          ? _value.validationLevel
          : validationLevel // ignore: cast_nullable_to_non_nullable
              as ValidationLevel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionSettingsImpl implements _SubscriptionSettings {
  const _$SubscriptionSettingsImpl(
      {this.connectTimeoutSeconds = 30,
      this.readTimeoutSeconds = 60,
      this.maxRetries = 3,
      this.verifySSLCert = true,
      this.useProxy = false,
      this.proxyUrl,
      this.mergeDuplicateNodes = true,
      this.filterDuplicateNodes = true,
      this.validationLevel = ValidationLevel.medium});

  factory _$SubscriptionSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionSettingsImplFromJson(json);

  /// 连接超时时间（秒）
  @override
  @JsonKey()
  final int connectTimeoutSeconds;

  /// 读取超时时间（秒）
  @override
  @JsonKey()
  final int readTimeoutSeconds;

  /// 最大重试次数
  @override
  @JsonKey()
  final int maxRetries;

  /// 是否验证 SSL 证书
  @override
  @JsonKey()
  final bool verifySSLCert;

  /// 是否使用代理获取订阅
  @override
  @JsonKey()
  final bool useProxy;

  /// 订阅获取代理地址
  @override
  final String? proxyUrl;

  /// 是否自动合并相同节点
  @override
  @JsonKey()
  final bool mergeDuplicateNodes;

  /// 是否过滤重复节点
  @override
  @JsonKey()
  final bool filterDuplicateNodes;

  /// 节点验证级别
  @override
  @JsonKey()
  final ValidationLevel validationLevel;

  @override
  String toString() {
    return 'SubscriptionSettings(connectTimeoutSeconds: $connectTimeoutSeconds, readTimeoutSeconds: $readTimeoutSeconds, maxRetries: $maxRetries, verifySSLCert: $verifySSLCert, useProxy: $useProxy, proxyUrl: $proxyUrl, mergeDuplicateNodes: $mergeDuplicateNodes, filterDuplicateNodes: $filterDuplicateNodes, validationLevel: $validationLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionSettingsImpl &&
            (identical(other.connectTimeoutSeconds, connectTimeoutSeconds) ||
                other.connectTimeoutSeconds == connectTimeoutSeconds) &&
            (identical(other.readTimeoutSeconds, readTimeoutSeconds) ||
                other.readTimeoutSeconds == readTimeoutSeconds) &&
            (identical(other.maxRetries, maxRetries) ||
                other.maxRetries == maxRetries) &&
            (identical(other.verifySSLCert, verifySSLCert) ||
                other.verifySSLCert == verifySSLCert) &&
            (identical(other.useProxy, useProxy) ||
                other.useProxy == useProxy) &&
            (identical(other.proxyUrl, proxyUrl) ||
                other.proxyUrl == proxyUrl) &&
            (identical(other.mergeDuplicateNodes, mergeDuplicateNodes) ||
                other.mergeDuplicateNodes == mergeDuplicateNodes) &&
            (identical(other.filterDuplicateNodes, filterDuplicateNodes) ||
                other.filterDuplicateNodes == filterDuplicateNodes) &&
            (identical(other.validationLevel, validationLevel) ||
                other.validationLevel == validationLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      connectTimeoutSeconds,
      readTimeoutSeconds,
      maxRetries,
      verifySSLCert,
      useProxy,
      proxyUrl,
      mergeDuplicateNodes,
      filterDuplicateNodes,
      validationLevel);

  /// Create a copy of SubscriptionSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionSettingsImplCopyWith<_$SubscriptionSettingsImpl>
      get copyWith =>
          __$$SubscriptionSettingsImplCopyWithImpl<_$SubscriptionSettingsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionSettingsImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionSettings implements SubscriptionSettings {
  const factory _SubscriptionSettings(
      {final int connectTimeoutSeconds,
      final int readTimeoutSeconds,
      final int maxRetries,
      final bool verifySSLCert,
      final bool useProxy,
      final String? proxyUrl,
      final bool mergeDuplicateNodes,
      final bool filterDuplicateNodes,
      final ValidationLevel validationLevel}) = _$SubscriptionSettingsImpl;

  factory _SubscriptionSettings.fromJson(Map<String, dynamic> json) =;
      _$SubscriptionSettingsImpl.fromJson;

  /// 连接超时时间（秒）
  @override
  int get connectTimeoutSeconds;

  /// 读取超时时间（秒）
  @override
  int get readTimeoutSeconds;

  /// 最大重试次数
  @override
  int get maxRetries;

  /// 是否验证 SSL 证书
  @override
  bool get verifySSLCert;

  /// 是否使用代理获取订阅
  @override
  bool get useProxy;

  /// 订阅获取代理地址
  @override
  String? get proxyUrl;

  /// 是否自动合并相同节点
  @override
  bool get mergeDuplicateNodes;

  /// 是否过滤重复节点
  @override
  bool get filterDuplicateNodes;

  /// 节点验证级别
  @override
  ValidationLevel get validationLevel;

  /// Create a copy of SubscriptionSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionSettingsImplCopyWith<_$SubscriptionSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateResult _$UpdateResultFromJson(Map<String, dynamic> json) {
  return _UpdateResult.fromJson(json);
}

/// @nodoc
mixin _$UpdateResult {
  /// 是否成功
  bool get success => throw _privateConstructorUsedError;

  /// 订阅 ID
  String get subscriptionId => throw _privateConstructorUsedError;

  /// 新增节点数
  int get addedNodes => throw _privateConstructorUsedError;

  /// 更新节点数
  int get updatedNodes => throw _privateConstructorUsedError;

  /// 移除节点数
  int get removedNodes => throw _privateConstructorUsedError;

  /// 错误信息
  String? get error => throw _privateConstructorUsedError;

  /// 更新耗时（毫秒）
  int get durationMs => throw _privateConstructorUsedError;

  /// 更新开始时间
  DateTime get startTime => throw _privateConstructorUsedError;

  /// 更新结束时间
  DateTime get endTime => throw _privateConstructorUsedError;

  /// Serializes this UpdateResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateResultCopyWith<UpdateResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateResultCopyWith<$Res> {
  factory $UpdateResultCopyWith(
          UpdateResult value, $Res Function(UpdateResult) then) =;
      _$UpdateResultCopyWithImpl<$Res, UpdateResult>;
  @useResult
  $Res call(
      {bool success,
      String subscriptionId,
      int addedNodes,
      int updatedNodes,
      int removedNodes,
      String? error,
      int durationMs,
      DateTime startTime,
      DateTime endTime});
}

/// @nodoc
class _$UpdateResultCopyWithImpl<$Res, $Val extends UpdateResult>
    implements $UpdateResultCopyWith<$Res> {
  _$UpdateResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? subscriptionId = null,
    Object? addedNodes = null,
    Object? updatedNodes = null,
    Object? removedNodes = null,
    Object? error = freezed,
    Object? durationMs = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_value.copyWith(
      success: null == success;
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      subscriptionId: null == subscriptionId;
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String,
      addedNodes: null == addedNodes;
          ? _value.addedNodes
          : addedNodes // ignore: cast_nullable_to_non_nullable
              as int,
      updatedNodes: null == updatedNodes;
          ? _value.updatedNodes
          : updatedNodes // ignore: cast_nullable_to_non_nullable
              as int,
      removedNodes: null == removedNodes;
          ? _value.removedNodes
          : removedNodes // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error;
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      durationMs: null == durationMs;
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      startTime: null == startTime;
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime;
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateResultImplCopyWith<$Res>
    implements $UpdateResultCopyWith<$Res> {
  factory _$$UpdateResultImplCopyWith(
          _$UpdateResultImpl value, $Res Function(_$UpdateResultImpl) then) =;
      __$$UpdateResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String subscriptionId,
      int addedNodes,
      int updatedNodes,
      int removedNodes,
      String? error,
      int durationMs,
      DateTime startTime,
      DateTime endTime});
}

/// @nodoc
class __$$UpdateResultImplCopyWithImpl<$Res>
    extends _$UpdateResultCopyWithImpl<$Res, _$UpdateResultImpl>
    implements _$$UpdateResultImplCopyWith<$Res> {
  __$$UpdateResultImplCopyWithImpl(
      _$UpdateResultImpl _value, $Res Function(_$UpdateResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? subscriptionId = null,
    Object? addedNodes = null,
    Object? updatedNodes = null,
    Object? removedNodes = null,
    Object? error = freezed,
    Object? durationMs = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_$UpdateResultImpl(
      success: null == success;
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      subscriptionId: null == subscriptionId;
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String,
      addedNodes: null == addedNodes;
          ? _value.addedNodes
          : addedNodes // ignore: cast_nullable_to_non_nullable
              as int,
      updatedNodes: null == updatedNodes;
          ? _value.updatedNodes
          : updatedNodes // ignore: cast_nullable_to_non_nullable
              as int,
      removedNodes: null == removedNodes;
          ? _value.removedNodes
          : removedNodes // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error;
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      durationMs: null == durationMs;
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      startTime: null == startTime;
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime;
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateResultImpl implements _UpdateResult {
  const _$UpdateResultImpl(
      {required this.success,
      required this.subscriptionId,
      this.addedNodes = 0,
      this.updatedNodes = 0,
      this.removedNodes = 0,
      this.error,
      this.durationMs = 0,
      required this.startTime,
      required this.endTime});

  factory _$UpdateResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateResultImplFromJson(json);

  /// 是否成功
  @override
  final bool success;

  /// 订阅 ID
  @override
  final String subscriptionId;

  /// 新增节点数
  @override
  @JsonKey()
  final int addedNodes;

  /// 更新节点数
  @override
  @JsonKey()
  final int updatedNodes;

  /// 移除节点数
  @override
  @JsonKey()
  final int removedNodes;

  /// 错误信息
  @override
  final String? error;

  /// 更新耗时（毫秒）
  @override
  @JsonKey()
  final int durationMs;

  /// 更新开始时间
  @override
  final DateTime startTime;

  /// 更新结束时间
  @override
  final DateTime endTime;

  @override
  String toString() {
    return 'UpdateResult(success: $success, subscriptionId: $subscriptionId, addedNodes: $addedNodes, updatedNodes: $updatedNodes, removedNodes: $removedNodes, error: $error, durationMs: $durationMs, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId) &&
            (identical(other.addedNodes, addedNodes) ||
                other.addedNodes == addedNodes) &&
            (identical(other.updatedNodes, updatedNodes) ||
                other.updatedNodes == updatedNodes) &&
            (identical(other.removedNodes, removedNodes) ||
                other.removedNodes == removedNodes) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      subscriptionId,
      addedNodes,
      updatedNodes,
      removedNodes,
      error,
      durationMs,
      startTime,
      endTime);

  /// Create a copy of UpdateResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateResultImplCopyWith<_$UpdateResultImpl> get copyWith =>
      __$$UpdateResultImplCopyWithImpl<_$UpdateResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateResultImplToJson(
      this,
    );
  }
}

abstract class _UpdateResult implements UpdateResult {
  const factory _UpdateResult(
      {required final bool success,
      required final String subscriptionId,
      final int addedNodes,
      final int updatedNodes,
      final int removedNodes,
      final String? error,
      final int durationMs,
      required final DateTime startTime,
      required final DateTime endTime}) = _$UpdateResultImpl;

  factory _UpdateResult.fromJson(Map<String, dynamic> json) =;
      _$UpdateResultImpl.fromJson;

  /// 是否成功
  @override
  bool get success;

  /// 订阅 ID
  @override
  String get subscriptionId;

  /// 新增节点数
  @override
  int get addedNodes;

  /// 更新节点数
  @override
  int get updatedNodes;

  /// 移除节点数
  @override
  int get removedNodes;

  /// 错误信息
  @override
  String? get error;

  /// 更新耗时（毫秒）
  @override
  int get durationMs;

  /// 更新开始时间
  @override
  DateTime get startTime;

  /// 更新结束时间
  @override
  DateTime get endTime;

  /// Create a copy of UpdateResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateResultImplCopyWith<_$UpdateResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ImportResult _$ImportResultFromJson(Map<String, dynamic> json) {
  return _ImportResult.fromJson(json);
}

/// @nodoc
mixin _$ImportResult {
  /// 是否成功
  bool get success => throw _privateConstructorUsedError;

  /// 导入的订阅数量
  int get importedSubscriptions => throw _privateConstructorUsedError;

  /// 导入的节点总数
  int get totalNodes => throw _privateConstructorUsedError;

  /// 有效的节点数
  int get validNodes => throw _privateConstructorUsedError;

  /// 失败的订阅数量
  int get failedSubscriptions => throw _privateConstructorUsedError;

  /// 错误列表
  List<String> get errors => throw _privateConstructorUsedError;

  /// 导入统计
  ImportStats get importStats => throw _privateConstructorUsedError;

  /// Serializes this ImportResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImportResultCopyWith<ImportResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImportResultCopyWith<$Res> {
  factory $ImportResultCopyWith(
          ImportResult value, $Res Function(ImportResult) then) =;
      _$ImportResultCopyWithImpl<$Res, ImportResult>;
  @useResult
  $Res call(
      {bool success,
      int importedSubscriptions,
      int totalNodes,
      int validNodes,
      int failedSubscriptions,
      List<String> errors,
      ImportStats importStats});

  $ImportStatsCopyWith<$Res> get importStats;
}

/// @nodoc
class _$ImportResultCopyWithImpl<$Res, $Val extends ImportResult>
    implements $ImportResultCopyWith<$Res> {
  _$ImportResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? importedSubscriptions = null,
    Object? totalNodes = null,
    Object? validNodes = null,
    Object? failedSubscriptions = null,
    Object? errors = null,
    Object? importStats = null,
  }) {
    return _then(_value.copyWith(
      success: null == success;
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      importedSubscriptions: null == importedSubscriptions;
          ? _value.importedSubscriptions
          : importedSubscriptions // ignore: cast_nullable_to_non_nullable
              as int,
      totalNodes: null == totalNodes;
          ? _value.totalNodes
          : totalNodes // ignore: cast_nullable_to_non_nullable
              as int,
      validNodes: null == validNodes;
          ? _value.validNodes
          : validNodes // ignore: cast_nullable_to_non_nullable
              as int,
      failedSubscriptions: null == failedSubscriptions;
          ? _value.failedSubscriptions
          : failedSubscriptions // ignore: cast_nullable_to_non_nullable
              as int,
      errors: null == errors;
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      importStats: null == importStats;
          ? _value.importStats
          : importStats // ignore: cast_nullable_to_non_nullable
              as ImportStats,
    ) as $Val);
  }

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImportStatsCopyWith<$Res> get importStats {
    return $ImportStatsCopyWith<$Res>(_value.importStats, (value) {
      return _then(_value.copyWith(importStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ImportResultImplCopyWith<$Res>
    implements $ImportResultCopyWith<$Res> {
  factory _$$ImportResultImplCopyWith(
          _$ImportResultImpl value, $Res Function(_$ImportResultImpl) then) =;
      __$$ImportResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      int importedSubscriptions,
      int totalNodes,
      int validNodes,
      int failedSubscriptions,
      List<String> errors,
      ImportStats importStats});

  @override
  $ImportStatsCopyWith<$Res> get importStats;
}

/// @nodoc
class __$$ImportResultImplCopyWithImpl<$Res>
    extends _$ImportResultCopyWithImpl<$Res, _$ImportResultImpl>
    implements _$$ImportResultImplCopyWith<$Res> {
  __$$ImportResultImplCopyWithImpl(
      _$ImportResultImpl _value, $Res Function(_$ImportResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? importedSubscriptions = null,
    Object? totalNodes = null,
    Object? validNodes = null,
    Object? failedSubscriptions = null,
    Object? errors = null,
    Object? importStats = null,
  }) {
    return _then(_$ImportResultImpl(
      success: null == success;
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      importedSubscriptions: null == importedSubscriptions;
          ? _value.importedSubscriptions
          : importedSubscriptions // ignore: cast_nullable_to_non_nullable
              as int,
      totalNodes: null == totalNodes;
          ? _value.totalNodes
          : totalNodes // ignore: cast_nullable_to_non_nullable
              as int,
      validNodes: null == validNodes;
          ? _value.validNodes
          : validNodes // ignore: cast_nullable_to_non_nullable
              as int,
      failedSubscriptions: null == failedSubscriptions;
          ? _value.failedSubscriptions
          : failedSubscriptions // ignore: cast_nullable_to_non_nullable
              as int,
      errors: null == errors;
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      importStats: null == importStats;
          ? _value.importStats
          : importStats // ignore: cast_nullable_to_non_nullable
              as ImportStats,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImportResultImpl implements _ImportResult {
  const _$ImportResultImpl(
      {required this.success,
      this.importedSubscriptions = 0,
      this.totalNodes = 0,
      this.validNodes = 0,
      this.failedSubscriptions = 0,
      final List<String> errors = const [],
      this.importStats = _emptyImportStats});
      : _errors = errors;

  factory _$ImportResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImportResultImplFromJson(json);

  /// 是否成功
  @override
  final bool success;

  /// 导入的订阅数量
  @override
  @JsonKey()
  final int importedSubscriptions;

  /// 导入的节点总数
  @override
  @JsonKey()
  final int totalNodes;

  /// 有效的节点数
  @override
  @JsonKey()
  final int validNodes;

  /// 失败的订阅数量
  @override
  @JsonKey()
  final int failedSubscriptions;

  /// 错误列表
  final List<String> _errors;

  /// 错误列表
  @override
  @JsonKey()
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  /// 导入统计
  @override
  @JsonKey()
  final ImportStats importStats;

  @override
  String toString() {
    return 'ImportResult(success: $success, importedSubscriptions: $importedSubscriptions, totalNodes: $totalNodes, validNodes: $validNodes, failedSubscriptions: $failedSubscriptions, errors: $errors, importStats: $importStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImportResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.importedSubscriptions, importedSubscriptions) ||
                other.importedSubscriptions == importedSubscriptions) &&
            (identical(other.totalNodes, totalNodes) ||
                other.totalNodes == totalNodes) &&
            (identical(other.validNodes, validNodes) ||
                other.validNodes == validNodes) &&
            (identical(other.failedSubscriptions, failedSubscriptions) ||
                other.failedSubscriptions == failedSubscriptions) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.importStats, importStats) ||
                other.importStats == importStats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      importedSubscriptions,
      totalNodes,
      validNodes,
      failedSubscriptions,
      const DeepCollectionEquality().hash(_errors),
      importStats);

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImportResultImplCopyWith<_$ImportResultImpl> get copyWith =>
      __$$ImportResultImplCopyWithImpl<_$ImportResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImportResultImplToJson(
      this,
    );
  }
}

abstract class _ImportResult implements ImportResult {
  const factory _ImportResult(
      {required final bool success,
      final int importedSubscriptions,
      final int totalNodes,
      final int validNodes,
      final int failedSubscriptions,
      final List<String> errors,
      final ImportStats importStats}) = _$ImportResultImpl;

  factory _ImportResult.fromJson(Map<String, dynamic> json) =;
      _$ImportResultImpl.fromJson;

  /// 是否成功
  @override
  bool get success;

  /// 导入的订阅数量
  @override
  int get importedSubscriptions;

  /// 导入的节点总数
  @override
  int get totalNodes;

  /// 有效的节点数
  @override
  int get validNodes;

  /// 失败的订阅数量
  @override
  int get failedSubscriptions;

  /// 错误列表
  @override
  List<String> get errors;

  /// 导入统计
  @override
  ImportStats get importStats;

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImportResultImplCopyWith<_$ImportResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ImportStats _$ImportStatsFromJson(Map<String, dynamic> json) {
  return _ImportStats.fromJson(json);
}

/// @nodoc
mixin _$ImportStats {
  /// V2Ray 节点数
  int get v2rayCount => throw _privateConstructorUsedError;

  /// SS 节点数
  int get ssCount => throw _privateConstructorUsedError;

  /// SSR 节点数
  int get ssrCount => throw _privateConstructorUsedError;

  /// Trojan 节点数
  int get trojanCount => throw _privateConstructorUsedError;

  /// 错误节点数
  int get errorCount => throw _privateConstructorUsedError;

  /// 总导入耗时（毫秒）
  int get totalImportTimeMs => throw _privateConstructorUsedError;

  /// Serializes this ImportStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImportStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImportStatsCopyWith<ImportStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImportStatsCopyWith<$Res> {
  factory $ImportStatsCopyWith(
          ImportStats value, $Res Function(ImportStats) then) =;
      _$ImportStatsCopyWithImpl<$Res, ImportStats>;
  @useResult
  $Res call(
      {int v2rayCount,
      int ssCount,
      int ssrCount,
      int trojanCount,
      int errorCount,
      int totalImportTimeMs});
}

/// @nodoc
class _$ImportStatsCopyWithImpl<$Res, $Val extends ImportStats>
    implements $ImportStatsCopyWith<$Res> {
  _$ImportStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImportStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? v2rayCount = null,
    Object? ssCount = null,
    Object? ssrCount = null,
    Object? trojanCount = null,
    Object? errorCount = null,
    Object? totalImportTimeMs = null,
  }) {
    return _then(_value.copyWith(
      v2rayCount: null == v2rayCount;
          ? _value.v2rayCount
          : v2rayCount // ignore: cast_nullable_to_non_nullable
              as int,
      ssCount: null == ssCount;
          ? _value.ssCount
          : ssCount // ignore: cast_nullable_to_non_nullable
              as int,
      ssrCount: null == ssrCount;
          ? _value.ssrCount
          : ssrCount // ignore: cast_nullable_to_non_nullable
              as int,
      trojanCount: null == trojanCount;
          ? _value.trojanCount
          : trojanCount // ignore: cast_nullable_to_non_nullable
              as int,
      errorCount: null == errorCount;
          ? _value.errorCount
          : errorCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalImportTimeMs: null == totalImportTimeMs;
          ? _value.totalImportTimeMs
          : totalImportTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImportStatsImplCopyWith<$Res>
    implements $ImportStatsCopyWith<$Res> {
  factory _$$ImportStatsImplCopyWith(
          _$ImportStatsImpl value, $Res Function(_$ImportStatsImpl) then) =;
      __$$ImportStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int v2rayCount,
      int ssCount,
      int ssrCount,
      int trojanCount,
      int errorCount,
      int totalImportTimeMs});
}

/// @nodoc
class __$$ImportStatsImplCopyWithImpl<$Res>
    extends _$ImportStatsCopyWithImpl<$Res, _$ImportStatsImpl>
    implements _$$ImportStatsImplCopyWith<$Res> {
  __$$ImportStatsImplCopyWithImpl(
      _$ImportStatsImpl _value, $Res Function(_$ImportStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImportStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? v2rayCount = null,
    Object? ssCount = null,
    Object? ssrCount = null,
    Object? trojanCount = null,
    Object? errorCount = null,
    Object? totalImportTimeMs = null,
  }) {
    return _then(_$ImportStatsImpl(
      v2rayCount: null == v2rayCount;
          ? _value.v2rayCount
          : v2rayCount // ignore: cast_nullable_to_non_nullable
              as int,
      ssCount: null == ssCount;
          ? _value.ssCount
          : ssCount // ignore: cast_nullable_to_non_nullable
              as int,
      ssrCount: null == ssrCount;
          ? _value.ssrCount
          : ssrCount // ignore: cast_nullable_to_non_nullable
              as int,
      trojanCount: null == trojanCount;
          ? _value.trojanCount
          : trojanCount // ignore: cast_nullable_to_non_nullable
              as int,
      errorCount: null == errorCount;
          ? _value.errorCount
          : errorCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalImportTimeMs: null == totalImportTimeMs;
          ? _value.totalImportTimeMs
          : totalImportTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImportStatsImpl implements _ImportStats {
  const _$ImportStatsImpl(
      {this.v2rayCount = 0,
      this.ssCount = 0,
      this.ssrCount = 0,
      this.trojanCount = 0,
      this.errorCount = 0,
      this.totalImportTimeMs = 0});

  factory _$ImportStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImportStatsImplFromJson(json);

  /// V2Ray 节点数
  @override
  @JsonKey()
  final int v2rayCount;

  /// SS 节点数
  @override
  @JsonKey()
  final int ssCount;

  /// SSR 节点数
  @override
  @JsonKey()
  final int ssrCount;

  /// Trojan 节点数
  @override
  @JsonKey()
  final int trojanCount;

  /// 错误节点数
  @override
  @JsonKey()
  final int errorCount;

  /// 总导入耗时（毫秒）
  @override
  @JsonKey()
  final int totalImportTimeMs;

  @override
  String toString() {
    return 'ImportStats(v2rayCount: $v2rayCount, ssCount: $ssCount, ssrCount: $ssrCount, trojanCount: $trojanCount, errorCount: $errorCount, totalImportTimeMs: $totalImportTimeMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImportStatsImpl &&
            (identical(other.v2rayCount, v2rayCount) ||
                other.v2rayCount == v2rayCount) &&
            (identical(other.ssCount, ssCount) || other.ssCount == ssCount) &&
            (identical(other.ssrCount, ssrCount) ||
                other.ssrCount == ssrCount) &&
            (identical(other.trojanCount, trojanCount) ||
                other.trojanCount == trojanCount) &&
            (identical(other.errorCount, errorCount) ||
                other.errorCount == errorCount) &&
            (identical(other.totalImportTimeMs, totalImportTimeMs) ||
                other.totalImportTimeMs == totalImportTimeMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, v2rayCount, ssCount, ssrCount,
      trojanCount, errorCount, totalImportTimeMs);

  /// Create a copy of ImportStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImportStatsImplCopyWith<_$ImportStatsImpl> get copyWith =>
      __$$ImportStatsImplCopyWithImpl<_$ImportStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImportStatsImplToJson(
      this,
    );
  }
}

abstract class _ImportStats implements ImportStats {
  const factory _ImportStats(
      {final int v2rayCount,
      final int ssCount,
      final int ssrCount,
      final int trojanCount,
      final int errorCount,
      final int totalImportTimeMs}) = _$ImportStatsImpl;

  factory _ImportStats.fromJson(Map<String, dynamic> json) =;
      _$ImportStatsImpl.fromJson;

  /// V2Ray 节点数
  @override
  int get v2rayCount;

  /// SS 节点数
  @override
  int get ssCount;

  /// SSR 节点数
  @override
  int get ssrCount;

  /// Trojan 节点数
  @override
  int get trojanCount;

  /// 错误节点数
  @override
  int get errorCount;

  /// 总导入耗时（毫秒）
  @override
  int get totalImportTimeMs;

  /// Create a copy of ImportStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImportStatsImplCopyWith<_$ImportStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
