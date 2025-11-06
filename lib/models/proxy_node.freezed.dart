// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proxy_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProxyNode _$ProxyNodeFromJson(Map<String, dynamic> json) {
  return _ProxyNode.fromJson(json);
}

/// @nodoc
mixin _$ProxyNode {
  /// 节点唯一标识符
  String get id => throw _privateConstructorUsedError;

  /// 节点名称
  String get name => throw _privateConstructorUsedError;

  /// 代理类型
  ProxyType get type => throw _privateConstructorUsedError;

  /// 代理版本
  ProxyVersion get version => throw _privateConstructorUsedError;

  /// 服务器地址
  String get server => throw _privateConstructorUsedError;

  /// 服务器端口
  int get port => throw _privateConstructorUsedError;

  /// 加密方式（如适用）
  String? get security => throw _privateConstructorUsedError;

  /// 认证信息（如适用）
  String? get auth => throw _privateConstructorUsedError;

  /// VMess 特有参数
  VMessConfig? get vmessConfig => throw _privateConstructorUsedError;

  /// VLESS 特有参数
  VLessConfig? get vlessConfig => throw _privateConstructorUsedError;

  /// SS/SSR 特有参数
  SSConfig? get ssConfig => throw _privateConstructorUsedError;

  /// Trojan 特有参数
  TrojanConfig? get trojanConfig => throw _privateConstructorUsedError;

  /// 节点状态
  NodeStatus get status => throw _privateConstructorUsedError;

  /// 测试延迟（毫秒）
  int? get latency => throw _privateConstructorUsedError;

  /// 下载速度（MB/s）
  double? get downloadSpeed => throw _privateConstructorUsedError;

  /// 上传速度（MB/s）
  double? get uploadSpeed => throw _privateConstructorUsedError;

  /// 最后测试时间
  DateTime? get lastTested => throw _privateConstructorUsedError;

  /// 是否启用
  bool get enabled => throw _privateConstructorUsedError;

  /// 是否自动选择
  bool get autoSelect => throw _privateConstructorUsedError;

  /// 是否收藏
  bool get favorite => throw _privateConstructorUsedError;

  /// 节点标签
  List<String> get tags => throw _privateConstructorUsedError;

  /// 节点备注
  String? get remark => throw _privateConstructorUsedError;

  /// 节点国家/地区
  String? get country => throw _privateConstructorUsedError;

  /// 节点城市
  String? get city => throw _privateConstructorUsedError;

  /// ISP 信息
  String? get isp => throw _privateConstructorUsedError;

  /// 节点延迟历史记录
  List<int> get latencyHistory => throw _privateConstructorUsedError;

  /// 节点优先级（用于自动选择）
  int get priority => throw _privateConstructorUsedError;

  /// 错误信息
  String? get errorMessage => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// 节点来源订阅 ID
  String? get subscriptionId => throw _privateConstructorUsedError;

  /// 节点所在组名
  String? get group => throw _privateConstructorUsedError;

  /// 节点的原始配置文本
  String? get rawConfig => throw _privateConstructorUsedError;

  /// 节点图标 URL（用于显示）
  String? get iconUrl => throw _privateConstructorUsedError;

  /// 节点的地理位置信息
  GeoInfo? get geoInfo => throw _privateConstructorUsedError;

  /// 节点性能指标
  NodePerformance? get performance => throw _privateConstructorUsedError;

  /// Serializes this ProxyNode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProxyNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProxyNodeCopyWith<ProxyNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProxyNodeCopyWith<$Res> {
  factory $ProxyNodeCopyWith(ProxyNode value, $Res Function(ProxyNode) then) =
      _$ProxyNodeCopyWithImpl<$Res, ProxyNode>;
  @useResult
  $Res call(
      {String id,
      String name,
      ProxyType type,
      ProxyVersion version,
      String server,
      int port,
      String? security,
      String? auth,
      VMessConfig? vmessConfig,
      VLessConfig? vlessConfig,
      SSConfig? ssConfig,
      TrojanConfig? trojanConfig,
      NodeStatus status,
      int? latency,
      double? downloadSpeed,
      double? uploadSpeed,
      DateTime? lastTested,
      bool enabled,
      bool autoSelect,
      bool favorite,
      List<String> tags,
      String? remark,
      String? country,
      String? city,
      String? isp,
      List<int> latencyHistory,
      int priority,
      String? errorMessage,
      DateTime createdAt,
      DateTime? updatedAt,
      String? subscriptionId,
      String? group,
      String? rawConfig,
      String? iconUrl,
      GeoInfo? geoInfo,
      NodePerformance? performance});

  $VMessConfigCopyWith<$Res>? get vmessConfig;
  $VLessConfigCopyWith<$Res>? get vlessConfig;
  $SSConfigCopyWith<$Res>? get ssConfig;
  $TrojanConfigCopyWith<$Res>? get trojanConfig;
  $GeoInfoCopyWith<$Res>? get geoInfo;
  $NodePerformanceCopyWith<$Res>? get performance;
}

/// @nodoc
class _$ProxyNodeCopyWithImpl<$Res, $Val extends ProxyNode>
    implements $ProxyNodeCopyWith<$Res> {
  _$ProxyNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProxyNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? version = null,
    Object? server = null,
    Object? port = null,
    Object? security = freezed,
    Object? auth = freezed,
    Object? vmessConfig = freezed,
    Object? vlessConfig = freezed,
    Object? ssConfig = freezed,
    Object? trojanConfig = freezed,
    Object? status = null,
    Object? latency = freezed,
    Object? downloadSpeed = freezed,
    Object? uploadSpeed = freezed,
    Object? lastTested = freezed,
    Object? enabled = null,
    Object? autoSelect = null,
    Object? favorite = null,
    Object? tags = null,
    Object? remark = freezed,
    Object? country = freezed,
    Object? city = freezed,
    Object? isp = freezed,
    Object? latencyHistory = null,
    Object? priority = null,
    Object? errorMessage = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? subscriptionId = freezed,
    Object? group = freezed,
    Object? rawConfig = freezed,
    Object? iconUrl = freezed,
    Object? geoInfo = freezed,
    Object? performance = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ProxyType,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as ProxyVersion,
      server: null == server
          ? _value.server
          : server // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      security: freezed == security
          ? _value.security
          : security // ignore: cast_nullable_to_non_nullable
              as String?,
      auth: freezed == auth
          ? _value.auth
          : auth // ignore: cast_nullable_to_non_nullable
              as String?,
      vmessConfig: freezed == vmessConfig
          ? _value.vmessConfig
          : vmessConfig // ignore: cast_nullable_to_non_nullable
              as VMessConfig?,
      vlessConfig: freezed == vlessConfig
          ? _value.vlessConfig
          : vlessConfig // ignore: cast_nullable_to_non_nullable
              as VLessConfig?,
      ssConfig: freezed == ssConfig
          ? _value.ssConfig
          : ssConfig // ignore: cast_nullable_to_non_nullable
              as SSConfig?,
      trojanConfig: freezed == trojanConfig
          ? _value.trojanConfig
          : trojanConfig // ignore: cast_nullable_to_non_nullable
              as TrojanConfig?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as NodeStatus,
      latency: freezed == latency
          ? _value.latency
          : latency // ignore: cast_nullable_to_non_nullable
              as int?,
      downloadSpeed: freezed == downloadSpeed
          ? _value.downloadSpeed
          : downloadSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      uploadSpeed: freezed == uploadSpeed
          ? _value.uploadSpeed
          : uploadSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      lastTested: freezed == lastTested
          ? _value.lastTested
          : lastTested // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      autoSelect: null == autoSelect
          ? _value.autoSelect
          : autoSelect // ignore: cast_nullable_to_non_nullable
              as bool,
      favorite: null == favorite
          ? _value.favorite
          : favorite // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      isp: freezed == isp
          ? _value.isp
          : isp // ignore: cast_nullable_to_non_nullable
              as String?,
      latencyHistory: null == latencyHistory
          ? _value.latencyHistory
          : latencyHistory // ignore: cast_nullable_to_non_nullable
              as List<int>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subscriptionId: freezed == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String?,
      rawConfig: freezed == rawConfig
          ? _value.rawConfig
          : rawConfig // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      geoInfo: freezed == geoInfo
          ? _value.geoInfo
          : geoInfo // ignore: cast_nullable_to_non_nullable
              as GeoInfo?,
      performance: freezed == performance
          ? _value.performance
          : performance // ignore: cast_nullable_to_non_nullable
              as NodePerformance?,
    ) as $Val);
  }

  /// Create a copy of ProxyNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VMessConfigCopyWith<$Res>? get vmessConfig {
    if (_value.vmessConfig == null) {
      return null;
    }

    return $VMessConfigCopyWith<$Res>(_value.vmessConfig!, (value) {
      return _then(_value.copyWith(vmessConfig: value) as $Val);
    });
  }

  /// Create a copy of ProxyNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VLessConfigCopyWith<$Res>? get vlessConfig {
    if (_value.vlessConfig == null) {
      return null;
    }

    return $VLessConfigCopyWith<$Res>(_value.vlessConfig!, (value) {
      return _then(_value.copyWith(vlessConfig: value) as $Val);
    });
  }

  /// Create a copy of ProxyNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SSConfigCopyWith<$Res>? get ssConfig {
    if (_value.ssConfig == null) {
      return null;
    }

    return $SSConfigCopyWith<$Res>(_value.ssConfig!, (value) {
      return _then(_value.copyWith(ssConfig: value) as $Val);
    });
  }

  /// Create a copy of ProxyNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrojanConfigCopyWith<$Res>? get trojanConfig {
    if (_value.trojanConfig == null) {
      return null;
    }

    return $TrojanConfigCopyWith<$Res>(_value.trojanConfig!, (value) {
      return _then(_value.copyWith(trojanConfig: value) as $Val);
    });
  }

  /// Create a copy of ProxyNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoInfoCopyWith<$Res>? get geoInfo {
    if (_value.geoInfo == null) {
      return null;
    }

    return $GeoInfoCopyWith<$Res>(_value.geoInfo!, (value) {
      return _then(_value.copyWith(geoInfo: value) as $Val);
    });
  }

  /// Create a copy of ProxyNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NodePerformanceCopyWith<$Res>? get performance {
    if (_value.performance == null) {
      return null;
    }

    return $NodePerformanceCopyWith<$Res>(_value.performance!, (value) {
      return _then(_value.copyWith(performance: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProxyNodeImplCopyWith<$Res>
    implements $ProxyNodeCopyWith<$Res> {
  factory _$$ProxyNodeImplCopyWith(
          _$ProxyNodeImpl value, $Res Function(_$ProxyNodeImpl) then) =
      __$$ProxyNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      ProxyType type,
      ProxyVersion version,
      String server,
      int port,
      String? security,
      String? auth,
      VMessConfig? vmessConfig,
      VLessConfig? vlessConfig,
      SSConfig? ssConfig,
      TrojanConfig? trojanConfig,
      NodeStatus status,
      int? latency,
      double? downloadSpeed,
      double? uploadSpeed,
      DateTime? lastTested,
      bool enabled,
      bool autoSelect,
      bool favorite,
      List<String> tags,
      String? remark,
      String? country,
      String? city,
      String? isp,
      List<int> latencyHistory,
      int priority,
      String? errorMessage,
      DateTime createdAt,
      DateTime? updatedAt,
      String? subscriptionId,
      String? group,
      String? rawConfig,
      String? iconUrl,
      GeoInfo? geoInfo,
      NodePerformance? performance});

  @override
  $VMessConfigCopyWith<$Res>? get vmessConfig;
  @override
  $VLessConfigCopyWith<$Res>? get vlessConfig;
  @override
  $SSConfigCopyWith<$Res>? get ssConfig;
  @override
  $TrojanConfigCopyWith<$Res>? get trojanConfig;
  @override
  $GeoInfoCopyWith<$Res>? get geoInfo;
  @override
  $NodePerformanceCopyWith<$Res>? get performance;
}

/// @nodoc
class __$$ProxyNodeImplCopyWithImpl<$Res>
    extends _$ProxyNodeCopyWithImpl<$Res, _$ProxyNodeImpl>
    implements _$$ProxyNodeImplCopyWith<$Res> {
  __$$ProxyNodeImplCopyWithImpl(
      _$ProxyNodeImpl _value, $Res Function(_$ProxyNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProxyNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? version = null,
    Object? server = null,
    Object? port = null,
    Object? security = freezed,
    Object? auth = freezed,
    Object? vmessConfig = freezed,
    Object? vlessConfig = freezed,
    Object? ssConfig = freezed,
    Object? trojanConfig = freezed,
    Object? status = null,
    Object? latency = freezed,
    Object? downloadSpeed = freezed,
    Object? uploadSpeed = freezed,
    Object? lastTested = freezed,
    Object? enabled = null,
    Object? autoSelect = null,
    Object? favorite = null,
    Object? tags = null,
    Object? remark = freezed,
    Object? country = freezed,
    Object? city = freezed,
    Object? isp = freezed,
    Object? latencyHistory = null,
    Object? priority = null,
    Object? errorMessage = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? subscriptionId = freezed,
    Object? group = freezed,
    Object? rawConfig = freezed,
    Object? iconUrl = freezed,
    Object? geoInfo = freezed,
    Object? performance = freezed,
  }) {
    return _then(_$ProxyNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ProxyType,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as ProxyVersion,
      server: null == server
          ? _value.server
          : server // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      security: freezed == security
          ? _value.security
          : security // ignore: cast_nullable_to_non_nullable
              as String?,
      auth: freezed == auth
          ? _value.auth
          : auth // ignore: cast_nullable_to_non_nullable
              as String?,
      vmessConfig: freezed == vmessConfig
          ? _value.vmessConfig
          : vmessConfig // ignore: cast_nullable_to_non_nullable
              as VMessConfig?,
      vlessConfig: freezed == vlessConfig
          ? _value.vlessConfig
          : vlessConfig // ignore: cast_nullable_to_non_nullable
              as VLessConfig?,
      ssConfig: freezed == ssConfig
          ? _value.ssConfig
          : ssConfig // ignore: cast_nullable_to_non_nullable
              as SSConfig?,
      trojanConfig: freezed == trojanConfig
          ? _value.trojanConfig
          : trojanConfig // ignore: cast_nullable_to_non_nullable
              as TrojanConfig?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as NodeStatus,
      latency: freezed == latency
          ? _value.latency
          : latency // ignore: cast_nullable_to_non_nullable
              as int?,
      downloadSpeed: freezed == downloadSpeed
          ? _value.downloadSpeed
          : downloadSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      uploadSpeed: freezed == uploadSpeed
          ? _value.uploadSpeed
          : uploadSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      lastTested: freezed == lastTested
          ? _value.lastTested
          : lastTested // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      autoSelect: null == autoSelect
          ? _value.autoSelect
          : autoSelect // ignore: cast_nullable_to_non_nullable
              as bool,
      favorite: null == favorite
          ? _value.favorite
          : favorite // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      isp: freezed == isp
          ? _value.isp
          : isp // ignore: cast_nullable_to_non_nullable
              as String?,
      latencyHistory: null == latencyHistory
          ? _value._latencyHistory
          : latencyHistory // ignore: cast_nullable_to_non_nullable
              as List<int>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subscriptionId: freezed == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String?,
      rawConfig: freezed == rawConfig
          ? _value.rawConfig
          : rawConfig // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      geoInfo: freezed == geoInfo
          ? _value.geoInfo
          : geoInfo // ignore: cast_nullable_to_non_nullable
              as GeoInfo?,
      performance: freezed == performance
          ? _value.performance
          : performance // ignore: cast_nullable_to_non_nullable
              as NodePerformance?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProxyNodeImpl implements _ProxyNode {
  const _$ProxyNodeImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.version = ProxyVersion.vmess,
      required this.server,
      required this.port,
      this.security,
      this.auth,
      this.vmessConfig,
      this.vlessConfig,
      this.ssConfig,
      this.trojanConfig,
      this.status = NodeStatus.untested,
      this.latency,
      this.downloadSpeed,
      this.uploadSpeed,
      this.lastTested,
      this.enabled = true,
      this.autoSelect = false,
      this.favorite = false,
      final List<String> tags = const [],
      this.remark,
      this.country,
      this.city,
      this.isp,
      final List<int> latencyHistory = const [],
      this.priority = 0,
      this.errorMessage,
      this.createdAt = DateTime.now,
      this.updatedAt,
      this.subscriptionId,
      this.group,
      this.rawConfig,
      this.iconUrl,
      this.geoInfo,
      this.performance})
      : _tags = tags,
        _latencyHistory = latencyHistory;

  factory _$ProxyNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProxyNodeImplFromJson(json);

  /// 节点唯一标识符
  @override
  final String id;

  /// 节点名称
  @override
  final String name;

  /// 代理类型
  @override
  final ProxyType type;

  /// 代理版本
  @override
  @JsonKey()
  final ProxyVersion version;

  /// 服务器地址
  @override
  final String server;

  /// 服务器端口
  @override
  final int port;

  /// 加密方式（如适用）
  @override
  final String? security;

  /// 认证信息（如适用）
  @override
  final String? auth;

  /// VMess 特有参数
  @override
  final VMessConfig? vmessConfig;

  /// VLESS 特有参数
  @override
  final VLessConfig? vlessConfig;

  /// SS/SSR 特有参数
  @override
  final SSConfig? ssConfig;

  /// Trojan 特有参数
  @override
  final TrojanConfig? trojanConfig;

  /// 节点状态
  @override
  @JsonKey()
  final NodeStatus status;

  /// 测试延迟（毫秒）
  @override
  final int? latency;

  /// 下载速度（MB/s）
  @override
  final double? downloadSpeed;

  /// 上传速度（MB/s）
  @override
  final double? uploadSpeed;

  /// 最后测试时间
  @override
  final DateTime? lastTested;

  /// 是否启用
  @override
  @JsonKey()
  final bool enabled;

  /// 是否自动选择
  @override
  @JsonKey()
  final bool autoSelect;

  /// 是否收藏
  @override
  @JsonKey()
  final bool favorite;

  /// 节点标签
  final List<String> _tags;

  /// 节点标签
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// 节点备注
  @override
  final String? remark;

  /// 节点国家/地区
  @override
  final String? country;

  /// 节点城市
  @override
  final String? city;

  /// ISP 信息
  @override
  final String? isp;

  /// 节点延迟历史记录
  final List<int> _latencyHistory;

  /// 节点延迟历史记录
  @override
  @JsonKey()
  List<int> get latencyHistory {
    if (_latencyHistory is EqualUnmodifiableListView) return _latencyHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_latencyHistory);
  }

  /// 节点优先级（用于自动选择）
  @override
  @JsonKey()
  final int priority;

  /// 错误信息
  @override
  final String? errorMessage;

  /// 创建时间
  @override
  @JsonKey()
  final DateTime createdAt;

  /// 更新时间
  @override
  final DateTime? updatedAt;

  /// 节点来源订阅 ID
  @override
  final String? subscriptionId;

  /// 节点所在组名
  @override
  final String? group;

  /// 节点的原始配置文本
  @override
  final String? rawConfig;

  /// 节点图标 URL（用于显示）
  @override
  final String? iconUrl;

  /// 节点的地理位置信息
  @override
  final GeoInfo? geoInfo;

  /// 节点性能指标
  @override
  final NodePerformance? performance;

  @override
  String toString() {
    return 'ProxyNode(id: $id, name: $name, type: $type, version: $version, server: $server, port: $port, security: $security, auth: $auth, vmessConfig: $vmessConfig, vlessConfig: $vlessConfig, ssConfig: $ssConfig, trojanConfig: $trojanConfig, status: $status, latency: $latency, downloadSpeed: $downloadSpeed, uploadSpeed: $uploadSpeed, lastTested: $lastTested, enabled: $enabled, autoSelect: $autoSelect, favorite: $favorite, tags: $tags, remark: $remark, country: $country, city: $city, isp: $isp, latencyHistory: $latencyHistory, priority: $priority, errorMessage: $errorMessage, createdAt: $createdAt, updatedAt: $updatedAt, subscriptionId: $subscriptionId, group: $group, rawConfig: $rawConfig, iconUrl: $iconUrl, geoInfo: $geoInfo, performance: $performance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProxyNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.server, server) || other.server == server) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.security, security) ||
                other.security == security) &&
            (identical(other.auth, auth) || other.auth == auth) &&
            (identical(other.vmessConfig, vmessConfig) ||
                other.vmessConfig == vmessConfig) &&
            (identical(other.vlessConfig, vlessConfig) ||
                other.vlessConfig == vlessConfig) &&
            (identical(other.ssConfig, ssConfig) ||
                other.ssConfig == ssConfig) &&
            (identical(other.trojanConfig, trojanConfig) ||
                other.trojanConfig == trojanConfig) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.latency, latency) || other.latency == latency) &&
            (identical(other.downloadSpeed, downloadSpeed) ||
                other.downloadSpeed == downloadSpeed) &&
            (identical(other.uploadSpeed, uploadSpeed) ||
                other.uploadSpeed == uploadSpeed) &&
            (identical(other.lastTested, lastTested) ||
                other.lastTested == lastTested) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.autoSelect, autoSelect) ||
                other.autoSelect == autoSelect) &&
            (identical(other.favorite, favorite) ||
                other.favorite == favorite) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.isp, isp) || other.isp == isp) &&
            const DeepCollectionEquality()
                .equals(other._latencyHistory, _latencyHistory) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.rawConfig, rawConfig) ||
                other.rawConfig == rawConfig) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.geoInfo, geoInfo) || other.geoInfo == geoInfo) &&
            (identical(other.performance, performance) ||
                other.performance == performance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        type,
        version,
        server,
        port,
        security,
        auth,
        vmessConfig,
        vlessConfig,
        ssConfig,
        trojanConfig,
        status,
        latency,
        downloadSpeed,
        uploadSpeed,
        lastTested,
        enabled,
        autoSelect,
        favorite,
        const DeepCollectionEquality().hash(_tags),
        remark,
        country,
        city,
        isp,
        const DeepCollectionEquality().hash(_latencyHistory),
        priority,
        errorMessage,
        createdAt,
        updatedAt,
        subscriptionId,
        group,
        rawConfig,
        iconUrl,
        geoInfo,
        performance
      ]);

  /// Create a copy of ProxyNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProxyNodeImplCopyWith<_$ProxyNodeImpl> get copyWith =>
      __$$ProxyNodeImplCopyWithImpl<_$ProxyNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProxyNodeImplToJson(
      this,
    );
  }
}

abstract class _ProxyNode implements ProxyNode {
  const factory _ProxyNode(
      {required final String id,
      required final String name,
      required final ProxyType type,
      final ProxyVersion version,
      required final String server,
      required final int port,
      final String? security,
      final String? auth,
      final VMessConfig? vmessConfig,
      final VLessConfig? vlessConfig,
      final SSConfig? ssConfig,
      final TrojanConfig? trojanConfig,
      final NodeStatus status,
      final int? latency,
      final double? downloadSpeed,
      final double? uploadSpeed,
      final DateTime? lastTested,
      final bool enabled,
      final bool autoSelect,
      final bool favorite,
      final List<String> tags,
      final String? remark,
      final String? country,
      final String? city,
      final String? isp,
      final List<int> latencyHistory,
      final int priority,
      final String? errorMessage,
      final DateTime createdAt,
      final DateTime? updatedAt,
      final String? subscriptionId,
      final String? group,
      final String? rawConfig,
      final String? iconUrl,
      final GeoInfo? geoInfo,
      final NodePerformance? performance}) = _$ProxyNodeImpl;

  factory _ProxyNode.fromJson(Map<String, dynamic> json) =
      _$ProxyNodeImpl.fromJson;

  /// 节点唯一标识符
  @override
  String get id;

  /// 节点名称
  @override
  String get name;

  /// 代理类型
  @override
  ProxyType get type;

  /// 代理版本
  @override
  ProxyVersion get version;

  /// 服务器地址
  @override
  String get server;

  /// 服务器端口
  @override
  int get port;

  /// 加密方式（如适用）
  @override
  String? get security;

  /// 认证信息（如适用）
  @override
  String? get auth;

  /// VMess 特有参数
  @override
  VMessConfig? get vmessConfig;

  /// VLESS 特有参数
  @override
  VLessConfig? get vlessConfig;

  /// SS/SSR 特有参数
  @override
  SSConfig? get ssConfig;

  /// Trojan 特有参数
  @override
  TrojanConfig? get trojanConfig;

  /// 节点状态
  @override
  NodeStatus get status;

  /// 测试延迟（毫秒）
  @override
  int? get latency;

  /// 下载速度（MB/s）
  @override
  double? get downloadSpeed;

  /// 上传速度（MB/s）
  @override
  double? get uploadSpeed;

  /// 最后测试时间
  @override
  DateTime? get lastTested;

  /// 是否启用
  @override
  bool get enabled;

  /// 是否自动选择
  @override
  bool get autoSelect;

  /// 是否收藏
  @override
  bool get favorite;

  /// 节点标签
  @override
  List<String> get tags;

  /// 节点备注
  @override
  String? get remark;

  /// 节点国家/地区
  @override
  String? get country;

  /// 节点城市
  @override
  String? get city;

  /// ISP 信息
  @override
  String? get isp;

  /// 节点延迟历史记录
  @override
  List<int> get latencyHistory;

  /// 节点优先级（用于自动选择）
  @override
  int get priority;

  /// 错误信息
  @override
  String? get errorMessage;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// 更新时间
  @override
  DateTime? get updatedAt;

  /// 节点来源订阅 ID
  @override
  String? get subscriptionId;

  /// 节点所在组名
  @override
  String? get group;

  /// 节点的原始配置文本
  @override
  String? get rawConfig;

  /// 节点图标 URL（用于显示）
  @override
  String? get iconUrl;

  /// 节点的地理位置信息
  @override
  GeoInfo? get geoInfo;

  /// 节点性能指标
  @override
  NodePerformance? get performance;

  /// Create a copy of ProxyNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProxyNodeImplCopyWith<_$ProxyNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VMessConfig _$VMessConfigFromJson(Map<String, dynamic> json) {
  return _VMessConfig.fromJson(json);
}

/// @nodoc
mixin _$VMessConfig {
  /// VMess 用户 ID
  String get uuid => throw _privateConstructorUsedError;

  /// 加密方式
  String get encryption => throw _privateConstructorUsedError;

  /// 传输协议
  String get transport => throw _privateConstructorUsedError;

  /// 传输伪装类型
  String? get streamSecurity => throw _privateConstructorUsedError;

  /// 传输路径
  String? get path => throw _privateConstructorUsedError;

  /// 传输主机名
  String? get host => throw _privateConstructorUsedError;

  /// 是否启用 TLS
  bool get tls => throw _privateConstructorUsedError;

  /// TLS 证书路径
  String? get tlsCert => throw _privateConstructorUsedError;

  /// TLS 私钥路径
  String? get tlsKey => throw _privateConstructorUsedError;

  /// SNI 域名
  String? get sni => throw _privateConstructorUsedError;

  /// 是否验证证书
  bool get verifyCertificate => throw _privateConstructorUsedError;

  /// WebSocket 特定配置
  WSConfig? get wsConfig => throw _privateConstructorUsedError;

  /// HTTP/2 特定配置
  HTTP2Config? get http2Config => throw _privateConstructorUsedError;

  /// TCP 特定配置
  TCPConfig? get tcpConfig => throw _privateConstructorUsedError;

  /// gRPC 特定配置
  GRPCConfig? get grpcConfig => throw _privateConstructorUsedError;

  /// Serializes this VMessConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VMessConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VMessConfigCopyWith<VMessConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VMessConfigCopyWith<$Res> {
  factory $VMessConfigCopyWith(
          VMessConfig value, $Res Function(VMessConfig) then) =
      _$VMessConfigCopyWithImpl<$Res, VMessConfig>;
  @useResult
  $Res call(
      {String uuid,
      String encryption,
      String transport,
      String? streamSecurity,
      String? path,
      String? host,
      bool tls,
      String? tlsCert,
      String? tlsKey,
      String? sni,
      bool verifyCertificate,
      WSConfig? wsConfig,
      HTTP2Config? http2Config,
      TCPConfig? tcpConfig,
      GRPCConfig? grpcConfig});

  $WSConfigCopyWith<$Res>? get wsConfig;
  $HTTP2ConfigCopyWith<$Res>? get http2Config;
  $TCPConfigCopyWith<$Res>? get tcpConfig;
  $GRPCConfigCopyWith<$Res>? get grpcConfig;
}

/// @nodoc
class _$VMessConfigCopyWithImpl<$Res, $Val extends VMessConfig>
    implements $VMessConfigCopyWith<$Res> {
  _$VMessConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VMessConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? encryption = null,
    Object? transport = null,
    Object? streamSecurity = freezed,
    Object? path = freezed,
    Object? host = freezed,
    Object? tls = null,
    Object? tlsCert = freezed,
    Object? tlsKey = freezed,
    Object? sni = freezed,
    Object? verifyCertificate = null,
    Object? wsConfig = freezed,
    Object? http2Config = freezed,
    Object? tcpConfig = freezed,
    Object? grpcConfig = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      encryption: null == encryption
          ? _value.encryption
          : encryption // ignore: cast_nullable_to_non_nullable
              as String,
      transport: null == transport
          ? _value.transport
          : transport // ignore: cast_nullable_to_non_nullable
              as String,
      streamSecurity: freezed == streamSecurity
          ? _value.streamSecurity
          : streamSecurity // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
      tls: null == tls
          ? _value.tls
          : tls // ignore: cast_nullable_to_non_nullable
              as bool,
      tlsCert: freezed == tlsCert
          ? _value.tlsCert
          : tlsCert // ignore: cast_nullable_to_non_nullable
              as String?,
      tlsKey: freezed == tlsKey
          ? _value.tlsKey
          : tlsKey // ignore: cast_nullable_to_non_nullable
              as String?,
      sni: freezed == sni
          ? _value.sni
          : sni // ignore: cast_nullable_to_non_nullable
              as String?,
      verifyCertificate: null == verifyCertificate
          ? _value.verifyCertificate
          : verifyCertificate // ignore: cast_nullable_to_non_nullable
              as bool,
      wsConfig: freezed == wsConfig
          ? _value.wsConfig
          : wsConfig // ignore: cast_nullable_to_non_nullable
              as WSConfig?,
      http2Config: freezed == http2Config
          ? _value.http2Config
          : http2Config // ignore: cast_nullable_to_non_nullable
              as HTTP2Config?,
      tcpConfig: freezed == tcpConfig
          ? _value.tcpConfig
          : tcpConfig // ignore: cast_nullable_to_non_nullable
              as TCPConfig?,
      grpcConfig: freezed == grpcConfig
          ? _value.grpcConfig
          : grpcConfig // ignore: cast_nullable_to_non_nullable
              as GRPCConfig?,
    ) as $Val);
  }

  /// Create a copy of VMessConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WSConfigCopyWith<$Res>? get wsConfig {
    if (_value.wsConfig == null) {
      return null;
    }

    return $WSConfigCopyWith<$Res>(_value.wsConfig!, (value) {
      return _then(_value.copyWith(wsConfig: value) as $Val);
    });
  }

  /// Create a copy of VMessConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HTTP2ConfigCopyWith<$Res>? get http2Config {
    if (_value.http2Config == null) {
      return null;
    }

    return $HTTP2ConfigCopyWith<$Res>(_value.http2Config!, (value) {
      return _then(_value.copyWith(http2Config: value) as $Val);
    });
  }

  /// Create a copy of VMessConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TCPConfigCopyWith<$Res>? get tcpConfig {
    if (_value.tcpConfig == null) {
      return null;
    }

    return $TCPConfigCopyWith<$Res>(_value.tcpConfig!, (value) {
      return _then(_value.copyWith(tcpConfig: value) as $Val);
    });
  }

  /// Create a copy of VMessConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GRPCConfigCopyWith<$Res>? get grpcConfig {
    if (_value.grpcConfig == null) {
      return null;
    }

    return $GRPCConfigCopyWith<$Res>(_value.grpcConfig!, (value) {
      return _then(_value.copyWith(grpcConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VMessConfigImplCopyWith<$Res>
    implements $VMessConfigCopyWith<$Res> {
  factory _$$VMessConfigImplCopyWith(
          _$VMessConfigImpl value, $Res Function(_$VMessConfigImpl) then) =
      __$$VMessConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      String encryption,
      String transport,
      String? streamSecurity,
      String? path,
      String? host,
      bool tls,
      String? tlsCert,
      String? tlsKey,
      String? sni,
      bool verifyCertificate,
      WSConfig? wsConfig,
      HTTP2Config? http2Config,
      TCPConfig? tcpConfig,
      GRPCConfig? grpcConfig});

  @override
  $WSConfigCopyWith<$Res>? get wsConfig;
  @override
  $HTTP2ConfigCopyWith<$Res>? get http2Config;
  @override
  $TCPConfigCopyWith<$Res>? get tcpConfig;
  @override
  $GRPCConfigCopyWith<$Res>? get grpcConfig;
}

/// @nodoc
class __$$VMessConfigImplCopyWithImpl<$Res>
    extends _$VMessConfigCopyWithImpl<$Res, _$VMessConfigImpl>
    implements _$$VMessConfigImplCopyWith<$Res> {
  __$$VMessConfigImplCopyWithImpl(
      _$VMessConfigImpl _value, $Res Function(_$VMessConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of VMessConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? encryption = null,
    Object? transport = null,
    Object? streamSecurity = freezed,
    Object? path = freezed,
    Object? host = freezed,
    Object? tls = null,
    Object? tlsCert = freezed,
    Object? tlsKey = freezed,
    Object? sni = freezed,
    Object? verifyCertificate = null,
    Object? wsConfig = freezed,
    Object? http2Config = freezed,
    Object? tcpConfig = freezed,
    Object? grpcConfig = freezed,
  }) {
    return _then(_$VMessConfigImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      encryption: null == encryption
          ? _value.encryption
          : encryption // ignore: cast_nullable_to_non_nullable
              as String,
      transport: null == transport
          ? _value.transport
          : transport // ignore: cast_nullable_to_non_nullable
              as String,
      streamSecurity: freezed == streamSecurity
          ? _value.streamSecurity
          : streamSecurity // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
      tls: null == tls
          ? _value.tls
          : tls // ignore: cast_nullable_to_non_nullable
              as bool,
      tlsCert: freezed == tlsCert
          ? _value.tlsCert
          : tlsCert // ignore: cast_nullable_to_non_nullable
              as String?,
      tlsKey: freezed == tlsKey
          ? _value.tlsKey
          : tlsKey // ignore: cast_nullable_to_non_nullable
              as String?,
      sni: freezed == sni
          ? _value.sni
          : sni // ignore: cast_nullable_to_non_nullable
              as String?,
      verifyCertificate: null == verifyCertificate
          ? _value.verifyCertificate
          : verifyCertificate // ignore: cast_nullable_to_non_nullable
              as bool,
      wsConfig: freezed == wsConfig
          ? _value.wsConfig
          : wsConfig // ignore: cast_nullable_to_non_nullable
              as WSConfig?,
      http2Config: freezed == http2Config
          ? _value.http2Config
          : http2Config // ignore: cast_nullable_to_non_nullable
              as HTTP2Config?,
      tcpConfig: freezed == tcpConfig
          ? _value.tcpConfig
          : tcpConfig // ignore: cast_nullable_to_non_nullable
              as TCPConfig?,
      grpcConfig: freezed == grpcConfig
          ? _value.grpcConfig
          : grpcConfig // ignore: cast_nullable_to_non_nullable
              as GRPCConfig?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VMessConfigImpl implements _VMessConfig {
  const _$VMessConfigImpl(
      {required this.uuid,
      this.encryption = 'auto',
      this.transport = 'ws',
      this.streamSecurity,
      this.path,
      this.host,
      this.tls = false,
      this.tlsCert,
      this.tlsKey,
      this.sni,
      this.verifyCertificate = true,
      this.wsConfig,
      this.http2Config,
      this.tcpConfig,
      this.grpcConfig});

  factory _$VMessConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$VMessConfigImplFromJson(json);

  /// VMess 用户 ID
  @override
  final String uuid;

  /// 加密方式
  @override
  @JsonKey()
  final String encryption;

  /// 传输协议
  @override
  @JsonKey()
  final String transport;

  /// 传输伪装类型
  @override
  final String? streamSecurity;

  /// 传输路径
  @override
  final String? path;

  /// 传输主机名
  @override
  final String? host;

  /// 是否启用 TLS
  @override
  @JsonKey()
  final bool tls;

  /// TLS 证书路径
  @override
  final String? tlsCert;

  /// TLS 私钥路径
  @override
  final String? tlsKey;

  /// SNI 域名
  @override
  final String? sni;

  /// 是否验证证书
  @override
  @JsonKey()
  final bool verifyCertificate;

  /// WebSocket 特定配置
  @override
  final WSConfig? wsConfig;

  /// HTTP/2 特定配置
  @override
  final HTTP2Config? http2Config;

  /// TCP 特定配置
  @override
  final TCPConfig? tcpConfig;

  /// gRPC 特定配置
  @override
  final GRPCConfig? grpcConfig;

  @override
  String toString() {
    return 'VMessConfig(uuid: $uuid, encryption: $encryption, transport: $transport, streamSecurity: $streamSecurity, path: $path, host: $host, tls: $tls, tlsCert: $tlsCert, tlsKey: $tlsKey, sni: $sni, verifyCertificate: $verifyCertificate, wsConfig: $wsConfig, http2Config: $http2Config, tcpConfig: $tcpConfig, grpcConfig: $grpcConfig)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VMessConfigImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.encryption, encryption) ||
                other.encryption == encryption) &&
            (identical(other.transport, transport) ||
                other.transport == transport) &&
            (identical(other.streamSecurity, streamSecurity) ||
                other.streamSecurity == streamSecurity) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.tls, tls) || other.tls == tls) &&
            (identical(other.tlsCert, tlsCert) || other.tlsCert == tlsCert) &&
            (identical(other.tlsKey, tlsKey) || other.tlsKey == tlsKey) &&
            (identical(other.sni, sni) || other.sni == sni) &&
            (identical(other.verifyCertificate, verifyCertificate) ||
                other.verifyCertificate == verifyCertificate) &&
            (identical(other.wsConfig, wsConfig) ||
                other.wsConfig == wsConfig) &&
            (identical(other.http2Config, http2Config) ||
                other.http2Config == http2Config) &&
            (identical(other.tcpConfig, tcpConfig) ||
                other.tcpConfig == tcpConfig) &&
            (identical(other.grpcConfig, grpcConfig) ||
                other.grpcConfig == grpcConfig));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uuid,
      encryption,
      transport,
      streamSecurity,
      path,
      host,
      tls,
      tlsCert,
      tlsKey,
      sni,
      verifyCertificate,
      wsConfig,
      http2Config,
      tcpConfig,
      grpcConfig);

  /// Create a copy of VMessConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VMessConfigImplCopyWith<_$VMessConfigImpl> get copyWith =>
      __$$VMessConfigImplCopyWithImpl<_$VMessConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VMessConfigImplToJson(
      this,
    );
  }
}

abstract class _VMessConfig implements VMessConfig {
  const factory _VMessConfig(
      {required final String uuid,
      final String encryption,
      final String transport,
      final String? streamSecurity,
      final String? path,
      final String? host,
      final bool tls,
      final String? tlsCert,
      final String? tlsKey,
      final String? sni,
      final bool verifyCertificate,
      final WSConfig? wsConfig,
      final HTTP2Config? http2Config,
      final TCPConfig? tcpConfig,
      final GRPCConfig? grpcConfig}) = _$VMessConfigImpl;

  factory _VMessConfig.fromJson(Map<String, dynamic> json) =
      _$VMessConfigImpl.fromJson;

  /// VMess 用户 ID
  @override
  String get uuid;

  /// 加密方式
  @override
  String get encryption;

  /// 传输协议
  @override
  String get transport;

  /// 传输伪装类型
  @override
  String? get streamSecurity;

  /// 传输路径
  @override
  String? get path;

  /// 传输主机名
  @override
  String? get host;

  /// 是否启用 TLS
  @override
  bool get tls;

  /// TLS 证书路径
  @override
  String? get tlsCert;

  /// TLS 私钥路径
  @override
  String? get tlsKey;

  /// SNI 域名
  @override
  String? get sni;

  /// 是否验证证书
  @override
  bool get verifyCertificate;

  /// WebSocket 特定配置
  @override
  WSConfig? get wsConfig;

  /// HTTP/2 特定配置
  @override
  HTTP2Config? get http2Config;

  /// TCP 特定配置
  @override
  TCPConfig? get tcpConfig;

  /// gRPC 特定配置
  @override
  GRPCConfig? get grpcConfig;

  /// Create a copy of VMessConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VMessConfigImplCopyWith<_$VMessConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VLessConfig _$VLessConfigFromJson(Map<String, dynamic> json) {
  return _VLessConfig.fromJson(json);
}

/// @nodoc
mixin _$VLessConfig {
  /// VLESS 用户 ID
  String get uuid => throw _privateConstructorUsedError;

  /// 流控类型
  String get flow => throw _privateConstructorUsedError;

  /// 传输协议
  String get transport => throw _privateConstructorUsedError;

  /// 传输伪装类型
  String? get streamSecurity => throw _privateConstructorUsedError;

  /// 传输路径
  String? get path => throw _privateConstructorUsedError;

  /// 传输主机名
  String? get host => throw _privateConstructorUsedError;

  /// 是否启用 TLS
  bool get tls => throw _privateConstructorUsedError;

  /// TLS 类型（xtls 或 tls）
  String get tlsType => throw _privateConstructorUsedError;

  /// TLS 证书路径
  String? get tlsCert => throw _privateConstructorUsedError;

  /// TLS 私钥路径
  String? get tlsKey => throw _privateConstructorUsedError;

  /// SNI 域名
  String? get sni => throw _privateConstructorUsedError;

  /// WebSocket 特定配置
  WSConfig? get wsConfig => throw _privateConstructorUsedError;

  /// Serializes this VLessConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VLessConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VLessConfigCopyWith<VLessConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VLessConfigCopyWith<$Res> {
  factory $VLessConfigCopyWith(
          VLessConfig value, $Res Function(VLessConfig) then) =
      _$VLessConfigCopyWithImpl<$Res, VLessConfig>;
  @useResult
  $Res call(
      {String uuid,
      String flow,
      String transport,
      String? streamSecurity,
      String? path,
      String? host,
      bool tls,
      String tlsType,
      String? tlsCert,
      String? tlsKey,
      String? sni,
      WSConfig? wsConfig});

  $WSConfigCopyWith<$Res>? get wsConfig;
}

/// @nodoc
class _$VLessConfigCopyWithImpl<$Res, $Val extends VLessConfig>
    implements $VLessConfigCopyWith<$Res> {
  _$VLessConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VLessConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? flow = null,
    Object? transport = null,
    Object? streamSecurity = freezed,
    Object? path = freezed,
    Object? host = freezed,
    Object? tls = null,
    Object? tlsType = null,
    Object? tlsCert = freezed,
    Object? tlsKey = freezed,
    Object? sni = freezed,
    Object? wsConfig = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      flow: null == flow
          ? _value.flow
          : flow // ignore: cast_nullable_to_non_nullable
              as String,
      transport: null == transport
          ? _value.transport
          : transport // ignore: cast_nullable_to_non_nullable
              as String,
      streamSecurity: freezed == streamSecurity
          ? _value.streamSecurity
          : streamSecurity // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
      tls: null == tls
          ? _value.tls
          : tls // ignore: cast_nullable_to_non_nullable
              as bool,
      tlsType: null == tlsType
          ? _value.tlsType
          : tlsType // ignore: cast_nullable_to_non_nullable
              as String,
      tlsCert: freezed == tlsCert
          ? _value.tlsCert
          : tlsCert // ignore: cast_nullable_to_non_nullable
              as String?,
      tlsKey: freezed == tlsKey
          ? _value.tlsKey
          : tlsKey // ignore: cast_nullable_to_non_nullable
              as String?,
      sni: freezed == sni
          ? _value.sni
          : sni // ignore: cast_nullable_to_non_nullable
              as String?,
      wsConfig: freezed == wsConfig
          ? _value.wsConfig
          : wsConfig // ignore: cast_nullable_to_non_nullable
              as WSConfig?,
    ) as $Val);
  }

  /// Create a copy of VLessConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WSConfigCopyWith<$Res>? get wsConfig {
    if (_value.wsConfig == null) {
      return null;
    }

    return $WSConfigCopyWith<$Res>(_value.wsConfig!, (value) {
      return _then(_value.copyWith(wsConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VLessConfigImplCopyWith<$Res>
    implements $VLessConfigCopyWith<$Res> {
  factory _$$VLessConfigImplCopyWith(
          _$VLessConfigImpl value, $Res Function(_$VLessConfigImpl) then) =
      __$$VLessConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      String flow,
      String transport,
      String? streamSecurity,
      String? path,
      String? host,
      bool tls,
      String tlsType,
      String? tlsCert,
      String? tlsKey,
      String? sni,
      WSConfig? wsConfig});

  @override
  $WSConfigCopyWith<$Res>? get wsConfig;
}

/// @nodoc
class __$$VLessConfigImplCopyWithImpl<$Res>
    extends _$VLessConfigCopyWithImpl<$Res, _$VLessConfigImpl>
    implements _$$VLessConfigImplCopyWith<$Res> {
  __$$VLessConfigImplCopyWithImpl(
      _$VLessConfigImpl _value, $Res Function(_$VLessConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of VLessConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? flow = null,
    Object? transport = null,
    Object? streamSecurity = freezed,
    Object? path = freezed,
    Object? host = freezed,
    Object? tls = null,
    Object? tlsType = null,
    Object? tlsCert = freezed,
    Object? tlsKey = freezed,
    Object? sni = freezed,
    Object? wsConfig = freezed,
  }) {
    return _then(_$VLessConfigImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      flow: null == flow
          ? _value.flow
          : flow // ignore: cast_nullable_to_non_nullable
              as String,
      transport: null == transport
          ? _value.transport
          : transport // ignore: cast_nullable_to_non_nullable
              as String,
      streamSecurity: freezed == streamSecurity
          ? _value.streamSecurity
          : streamSecurity // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
      tls: null == tls
          ? _value.tls
          : tls // ignore: cast_nullable_to_non_nullable
              as bool,
      tlsType: null == tlsType
          ? _value.tlsType
          : tlsType // ignore: cast_nullable_to_non_nullable
              as String,
      tlsCert: freezed == tlsCert
          ? _value.tlsCert
          : tlsCert // ignore: cast_nullable_to_non_nullable
              as String?,
      tlsKey: freezed == tlsKey
          ? _value.tlsKey
          : tlsKey // ignore: cast_nullable_to_non_nullable
              as String?,
      sni: freezed == sni
          ? _value.sni
          : sni // ignore: cast_nullable_to_non_nullable
              as String?,
      wsConfig: freezed == wsConfig
          ? _value.wsConfig
          : wsConfig // ignore: cast_nullable_to_non_nullable
              as WSConfig?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VLessConfigImpl implements _VLessConfig {
  const _$VLessConfigImpl(
      {required this.uuid,
      this.flow = 'xtls-rprx-vision',
      this.transport = 'ws',
      this.streamSecurity,
      this.path,
      this.host,
      this.tls = false,
      this.tlsType = 'xtls',
      this.tlsCert,
      this.tlsKey,
      this.sni,
      this.wsConfig});

  factory _$VLessConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$VLessConfigImplFromJson(json);

  /// VLESS 用户 ID
  @override
  final String uuid;

  /// 流控类型
  @override
  @JsonKey()
  final String flow;

  /// 传输协议
  @override
  @JsonKey()
  final String transport;

  /// 传输伪装类型
  @override
  final String? streamSecurity;

  /// 传输路径
  @override
  final String? path;

  /// 传输主机名
  @override
  final String? host;

  /// 是否启用 TLS
  @override
  @JsonKey()
  final bool tls;

  /// TLS 类型（xtls 或 tls）
  @override
  @JsonKey()
  final String tlsType;

  /// TLS 证书路径
  @override
  final String? tlsCert;

  /// TLS 私钥路径
  @override
  final String? tlsKey;

  /// SNI 域名
  @override
  final String? sni;

  /// WebSocket 特定配置
  @override
  final WSConfig? wsConfig;

  @override
  String toString() {
    return 'VLessConfig(uuid: $uuid, flow: $flow, transport: $transport, streamSecurity: $streamSecurity, path: $path, host: $host, tls: $tls, tlsType: $tlsType, tlsCert: $tlsCert, tlsKey: $tlsKey, sni: $sni, wsConfig: $wsConfig)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VLessConfigImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.flow, flow) || other.flow == flow) &&
            (identical(other.transport, transport) ||
                other.transport == transport) &&
            (identical(other.streamSecurity, streamSecurity) ||
                other.streamSecurity == streamSecurity) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.tls, tls) || other.tls == tls) &&
            (identical(other.tlsType, tlsType) || other.tlsType == tlsType) &&
            (identical(other.tlsCert, tlsCert) || other.tlsCert == tlsCert) &&
            (identical(other.tlsKey, tlsKey) || other.tlsKey == tlsKey) &&
            (identical(other.sni, sni) || other.sni == sni) &&
            (identical(other.wsConfig, wsConfig) ||
                other.wsConfig == wsConfig));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, flow, transport,
      streamSecurity, path, host, tls, tlsType, tlsCert, tlsKey, sni, wsConfig);

  /// Create a copy of VLessConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VLessConfigImplCopyWith<_$VLessConfigImpl> get copyWith =>
      __$$VLessConfigImplCopyWithImpl<_$VLessConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VLessConfigImplToJson(
      this,
    );
  }
}

abstract class _VLessConfig implements VLessConfig {
  const factory _VLessConfig(
      {required final String uuid,
      final String flow,
      final String transport,
      final String? streamSecurity,
      final String? path,
      final String? host,
      final bool tls,
      final String tlsType,
      final String? tlsCert,
      final String? tlsKey,
      final String? sni,
      final WSConfig? wsConfig}) = _$VLessConfigImpl;

  factory _VLessConfig.fromJson(Map<String, dynamic> json) =
      _$VLessConfigImpl.fromJson;

  /// VLESS 用户 ID
  @override
  String get uuid;

  /// 流控类型
  @override
  String get flow;

  /// 传输协议
  @override
  String get transport;

  /// 传输伪装类型
  @override
  String? get streamSecurity;

  /// 传输路径
  @override
  String? get path;

  /// 传输主机名
  @override
  String? get host;

  /// 是否启用 TLS
  @override
  bool get tls;

  /// TLS 类型（xtls 或 tls）
  @override
  String get tlsType;

  /// TLS 证书路径
  @override
  String? get tlsCert;

  /// TLS 私钥路径
  @override
  String? get tlsKey;

  /// SNI 域名
  @override
  String? get sni;

  /// WebSocket 特定配置
  @override
  WSConfig? get wsConfig;

  /// Create a copy of VLessConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VLessConfigImplCopyWith<_$VLessConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SSConfig _$SSConfigFromJson(Map<String, dynamic> json) {
  return _SSConfig.fromJson(json);
}

/// @nodoc
mixin _$SSConfig {
  /// 密码
  String get password => throw _privateConstructorUsedError;

  /// 加密方法
  String get method => throw _privateConstructorUsedError;

  /// 插件类型
  String? get plugin => throw _privateConstructorUsedError;

  /// 插件配置
  String? get pluginOpts => throw _privateConstructorUsedError;

  /// Serializes this SSConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SSConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SSConfigCopyWith<SSConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SSConfigCopyWith<$Res> {
  factory $SSConfigCopyWith(SSConfig value, $Res Function(SSConfig) then) =
      _$SSConfigCopyWithImpl<$Res, SSConfig>;
  @useResult
  $Res call(
      {String password, String method, String? plugin, String? pluginOpts});
}

/// @nodoc
class _$SSConfigCopyWithImpl<$Res, $Val extends SSConfig>
    implements $SSConfigCopyWith<$Res> {
  _$SSConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SSConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
    Object? method = null,
    Object? plugin = freezed,
    Object? pluginOpts = freezed,
  }) {
    return _then(_value.copyWith(
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      plugin: freezed == plugin
          ? _value.plugin
          : plugin // ignore: cast_nullable_to_non_nullable
              as String?,
      pluginOpts: freezed == pluginOpts
          ? _value.pluginOpts
          : pluginOpts // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SSConfigImplCopyWith<$Res>
    implements $SSConfigCopyWith<$Res> {
  factory _$$SSConfigImplCopyWith(
          _$SSConfigImpl value, $Res Function(_$SSConfigImpl) then) =
      __$$SSConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String password, String method, String? plugin, String? pluginOpts});
}

/// @nodoc
class __$$SSConfigImplCopyWithImpl<$Res>
    extends _$SSConfigCopyWithImpl<$Res, _$SSConfigImpl>
    implements _$$SSConfigImplCopyWith<$Res> {
  __$$SSConfigImplCopyWithImpl(
      _$SSConfigImpl _value, $Res Function(_$SSConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of SSConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
    Object? method = null,
    Object? plugin = freezed,
    Object? pluginOpts = freezed,
  }) {
    return _then(_$SSConfigImpl(
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      plugin: freezed == plugin
          ? _value.plugin
          : plugin // ignore: cast_nullable_to_non_nullable
              as String?,
      pluginOpts: freezed == pluginOpts
          ? _value.pluginOpts
          : pluginOpts // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SSConfigImpl implements _SSConfig {
  const _$SSConfigImpl(
      {required this.password,
      this.method = 'aes-256-gcm',
      this.plugin,
      this.pluginOpts});

  factory _$SSConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SSConfigImplFromJson(json);

  /// 密码
  @override
  final String password;

  /// 加密方法
  @override
  @JsonKey()
  final String method;

  /// 插件类型
  @override
  final String? plugin;

  /// 插件配置
  @override
  final String? pluginOpts;

  @override
  String toString() {
    return 'SSConfig(password: $password, method: $method, plugin: $plugin, pluginOpts: $pluginOpts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SSConfigImpl &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.plugin, plugin) || other.plugin == plugin) &&
            (identical(other.pluginOpts, pluginOpts) ||
                other.pluginOpts == pluginOpts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, password, method, plugin, pluginOpts);

  /// Create a copy of SSConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SSConfigImplCopyWith<_$SSConfigImpl> get copyWith =>
      __$$SSConfigImplCopyWithImpl<_$SSConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SSConfigImplToJson(
      this,
    );
  }
}

abstract class _SSConfig implements SSConfig {
  const factory _SSConfig(
      {required final String password,
      final String method,
      final String? plugin,
      final String? pluginOpts}) = _$SSConfigImpl;

  factory _SSConfig.fromJson(Map<String, dynamic> json) =
      _$SSConfigImpl.fromJson;

  /// 密码
  @override
  String get password;

  /// 加密方法
  @override
  String get method;

  /// 插件类型
  @override
  String? get plugin;

  /// 插件配置
  @override
  String? get pluginOpts;

  /// Create a copy of SSConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SSConfigImplCopyWith<_$SSConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrojanConfig _$TrojanConfigFromJson(Map<String, dynamic> json) {
  return _TrojanConfig.fromJson(json);
}

/// @nodoc
mixin _$TrojanConfig {
  /// Trojan 密码
  String get password => throw _privateConstructorUsedError;

  /// TLS 配置
  TLSConfig? get tlsConfig => throw _privateConstructorUsedError;

  /// WebSocket 配置
  WSConfig? get wsConfig => throw _privateConstructorUsedError;

  /// Serializes this TrojanConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrojanConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrojanConfigCopyWith<TrojanConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrojanConfigCopyWith<$Res> {
  factory $TrojanConfigCopyWith(
          TrojanConfig value, $Res Function(TrojanConfig) then) =
      _$TrojanConfigCopyWithImpl<$Res, TrojanConfig>;
  @useResult
  $Res call({String password, TLSConfig? tlsConfig, WSConfig? wsConfig});

  $TLSConfigCopyWith<$Res>? get tlsConfig;
  $WSConfigCopyWith<$Res>? get wsConfig;
}

/// @nodoc
class _$TrojanConfigCopyWithImpl<$Res, $Val extends TrojanConfig>
    implements $TrojanConfigCopyWith<$Res> {
  _$TrojanConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrojanConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
    Object? tlsConfig = freezed,
    Object? wsConfig = freezed,
  }) {
    return _then(_value.copyWith(
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      tlsConfig: freezed == tlsConfig
          ? _value.tlsConfig
          : tlsConfig // ignore: cast_nullable_to_non_nullable
              as TLSConfig?,
      wsConfig: freezed == wsConfig
          ? _value.wsConfig
          : wsConfig // ignore: cast_nullable_to_non_nullable
              as WSConfig?,
    ) as $Val);
  }

  /// Create a copy of TrojanConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TLSConfigCopyWith<$Res>? get tlsConfig {
    if (_value.tlsConfig == null) {
      return null;
    }

    return $TLSConfigCopyWith<$Res>(_value.tlsConfig!, (value) {
      return _then(_value.copyWith(tlsConfig: value) as $Val);
    });
  }

  /// Create a copy of TrojanConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WSConfigCopyWith<$Res>? get wsConfig {
    if (_value.wsConfig == null) {
      return null;
    }

    return $WSConfigCopyWith<$Res>(_value.wsConfig!, (value) {
      return _then(_value.copyWith(wsConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TrojanConfigImplCopyWith<$Res>
    implements $TrojanConfigCopyWith<$Res> {
  factory _$$TrojanConfigImplCopyWith(
          _$TrojanConfigImpl value, $Res Function(_$TrojanConfigImpl) then) =
      __$$TrojanConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String password, TLSConfig? tlsConfig, WSConfig? wsConfig});

  @override
  $TLSConfigCopyWith<$Res>? get tlsConfig;
  @override
  $WSConfigCopyWith<$Res>? get wsConfig;
}

/// @nodoc
class __$$TrojanConfigImplCopyWithImpl<$Res>
    extends _$TrojanConfigCopyWithImpl<$Res, _$TrojanConfigImpl>
    implements _$$TrojanConfigImplCopyWith<$Res> {
  __$$TrojanConfigImplCopyWithImpl(
      _$TrojanConfigImpl _value, $Res Function(_$TrojanConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrojanConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
    Object? tlsConfig = freezed,
    Object? wsConfig = freezed,
  }) {
    return _then(_$TrojanConfigImpl(
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      tlsConfig: freezed == tlsConfig
          ? _value.tlsConfig
          : tlsConfig // ignore: cast_nullable_to_non_nullable
              as TLSConfig?,
      wsConfig: freezed == wsConfig
          ? _value.wsConfig
          : wsConfig // ignore: cast_nullable_to_non_nullable
              as WSConfig?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrojanConfigImpl implements _TrojanConfig {
  const _$TrojanConfigImpl(
      {required this.password, this.tlsConfig, this.wsConfig});

  factory _$TrojanConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrojanConfigImplFromJson(json);

  /// Trojan 密码
  @override
  final String password;

  /// TLS 配置
  @override
  final TLSConfig? tlsConfig;

  /// WebSocket 配置
  @override
  final WSConfig? wsConfig;

  @override
  String toString() {
    return 'TrojanConfig(password: $password, tlsConfig: $tlsConfig, wsConfig: $wsConfig)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrojanConfigImpl &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.tlsConfig, tlsConfig) ||
                other.tlsConfig == tlsConfig) &&
            (identical(other.wsConfig, wsConfig) ||
                other.wsConfig == wsConfig));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, password, tlsConfig, wsConfig);

  /// Create a copy of TrojanConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrojanConfigImplCopyWith<_$TrojanConfigImpl> get copyWith =>
      __$$TrojanConfigImplCopyWithImpl<_$TrojanConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrojanConfigImplToJson(
      this,
    );
  }
}

abstract class _TrojanConfig implements TrojanConfig {
  const factory _TrojanConfig(
      {required final String password,
      final TLSConfig? tlsConfig,
      final WSConfig? wsConfig}) = _$TrojanConfigImpl;

  factory _TrojanConfig.fromJson(Map<String, dynamic> json) =
      _$TrojanConfigImpl.fromJson;

  /// Trojan 密码
  @override
  String get password;

  /// TLS 配置
  @override
  TLSConfig? get tlsConfig;

  /// WebSocket 配置
  @override
  WSConfig? get wsConfig;

  /// Create a copy of TrojanConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrojanConfigImplCopyWith<_$TrojanConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WSConfig _$WSConfigFromJson(Map<String, dynamic> json) {
  return _WSConfig.fromJson(json);
}

/// @nodoc
mixin _$WSConfig {
  /// WebSocket 路径
  String get path => throw _privateConstructorUsedError;

  /// WebSocket 主机头
  String? get headers => throw _privateConstructorUsedError;

  /// 是否提前数据
  bool get earlyDataHeaderName => throw _privateConstructorUsedError;

  /// Serializes this WSConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WSConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WSConfigCopyWith<WSConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WSConfigCopyWith<$Res> {
  factory $WSConfigCopyWith(WSConfig value, $Res Function(WSConfig) then) =
      _$WSConfigCopyWithImpl<$Res, WSConfig>;
  @useResult
  $Res call({String path, String? headers, bool earlyDataHeaderName});
}

/// @nodoc
class _$WSConfigCopyWithImpl<$Res, $Val extends WSConfig>
    implements $WSConfigCopyWith<$Res> {
  _$WSConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WSConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? headers = freezed,
    Object? earlyDataHeaderName = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as String?,
      earlyDataHeaderName: null == earlyDataHeaderName
          ? _value.earlyDataHeaderName
          : earlyDataHeaderName // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WSConfigImplCopyWith<$Res>
    implements $WSConfigCopyWith<$Res> {
  factory _$$WSConfigImplCopyWith(
          _$WSConfigImpl value, $Res Function(_$WSConfigImpl) then) =
      __$$WSConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, String? headers, bool earlyDataHeaderName});
}

/// @nodoc
class __$$WSConfigImplCopyWithImpl<$Res>
    extends _$WSConfigCopyWithImpl<$Res, _$WSConfigImpl>
    implements _$$WSConfigImplCopyWith<$Res> {
  __$$WSConfigImplCopyWithImpl(
      _$WSConfigImpl _value, $Res Function(_$WSConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of WSConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? headers = freezed,
    Object? earlyDataHeaderName = null,
  }) {
    return _then(_$WSConfigImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as String?,
      earlyDataHeaderName: null == earlyDataHeaderName
          ? _value.earlyDataHeaderName
          : earlyDataHeaderName // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WSConfigImpl implements _WSConfig {
  const _$WSConfigImpl(
      {required this.path, this.headers, this.earlyDataHeaderName = false});

  factory _$WSConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$WSConfigImplFromJson(json);

  /// WebSocket 路径
  @override
  final String path;

  /// WebSocket 主机头
  @override
  final String? headers;

  /// 是否提前数据
  @override
  @JsonKey()
  final bool earlyDataHeaderName;

  @override
  String toString() {
    return 'WSConfig(path: $path, headers: $headers, earlyDataHeaderName: $earlyDataHeaderName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WSConfigImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.headers, headers) || other.headers == headers) &&
            (identical(other.earlyDataHeaderName, earlyDataHeaderName) ||
                other.earlyDataHeaderName == earlyDataHeaderName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, path, headers, earlyDataHeaderName);

  /// Create a copy of WSConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WSConfigImplCopyWith<_$WSConfigImpl> get copyWith =>
      __$$WSConfigImplCopyWithImpl<_$WSConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WSConfigImplToJson(
      this,
    );
  }
}

abstract class _WSConfig implements WSConfig {
  const factory _WSConfig(
      {required final String path,
      final String? headers,
      final bool earlyDataHeaderName}) = _$WSConfigImpl;

  factory _WSConfig.fromJson(Map<String, dynamic> json) =
      _$WSConfigImpl.fromJson;

  /// WebSocket 路径
  @override
  String get path;

  /// WebSocket 主机头
  @override
  String? get headers;

  /// 是否提前数据
  @override
  bool get earlyDataHeaderName;

  /// Create a copy of WSConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WSConfigImplCopyWith<_$WSConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HTTP2Config _$HTTP2ConfigFromJson(Map<String, dynamic> json) {
  return _HTTP2Config.fromJson(json);
}

/// @nodoc
mixin _$HTTP2Config {
  /// HTTP/2 路径
  String get path => throw _privateConstructorUsedError;

  /// SNI 域名
  String get sni => throw _privateConstructorUsedError;

  /// HTTP/2 主机
  String? get host => throw _privateConstructorUsedError;

  /// Serializes this HTTP2Config to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HTTP2Config
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HTTP2ConfigCopyWith<HTTP2Config> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HTTP2ConfigCopyWith<$Res> {
  factory $HTTP2ConfigCopyWith(
          HTTP2Config value, $Res Function(HTTP2Config) then) =
      _$HTTP2ConfigCopyWithImpl<$Res, HTTP2Config>;
  @useResult
  $Res call({String path, String sni, String? host});
}

/// @nodoc
class _$HTTP2ConfigCopyWithImpl<$Res, $Val extends HTTP2Config>
    implements $HTTP2ConfigCopyWith<$Res> {
  _$HTTP2ConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HTTP2Config
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? sni = null,
    Object? host = freezed,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      sni: null == sni
          ? _value.sni
          : sni // ignore: cast_nullable_to_non_nullable
              as String,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HTTP2ConfigImplCopyWith<$Res>
    implements $HTTP2ConfigCopyWith<$Res> {
  factory _$$HTTP2ConfigImplCopyWith(
          _$HTTP2ConfigImpl value, $Res Function(_$HTTP2ConfigImpl) then) =
      __$$HTTP2ConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, String sni, String? host});
}

/// @nodoc
class __$$HTTP2ConfigImplCopyWithImpl<$Res>
    extends _$HTTP2ConfigCopyWithImpl<$Res, _$HTTP2ConfigImpl>
    implements _$$HTTP2ConfigImplCopyWith<$Res> {
  __$$HTTP2ConfigImplCopyWithImpl(
      _$HTTP2ConfigImpl _value, $Res Function(_$HTTP2ConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of HTTP2Config
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? sni = null,
    Object? host = freezed,
  }) {
    return _then(_$HTTP2ConfigImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      sni: null == sni
          ? _value.sni
          : sni // ignore: cast_nullable_to_non_nullable
              as String,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HTTP2ConfigImpl implements _HTTP2Config {
  const _$HTTP2ConfigImpl({required this.path, required this.sni, this.host});

  factory _$HTTP2ConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$HTTP2ConfigImplFromJson(json);

  /// HTTP/2 路径
  @override
  final String path;

  /// SNI 域名
  @override
  final String sni;

  /// HTTP/2 主机
  @override
  final String? host;

  @override
  String toString() {
    return 'HTTP2Config(path: $path, sni: $sni, host: $host)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HTTP2ConfigImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.sni, sni) || other.sni == sni) &&
            (identical(other.host, host) || other.host == host));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, path, sni, host);

  /// Create a copy of HTTP2Config
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HTTP2ConfigImplCopyWith<_$HTTP2ConfigImpl> get copyWith =>
      __$$HTTP2ConfigImplCopyWithImpl<_$HTTP2ConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HTTP2ConfigImplToJson(
      this,
    );
  }
}

abstract class _HTTP2Config implements HTTP2Config {
  const factory _HTTP2Config(
      {required final String path,
      required final String sni,
      final String? host}) = _$HTTP2ConfigImpl;

  factory _HTTP2Config.fromJson(Map<String, dynamic> json) =
      _$HTTP2ConfigImpl.fromJson;

  /// HTTP/2 路径
  @override
  String get path;

  /// SNI 域名
  @override
  String get sni;

  /// HTTP/2 主机
  @override
  String? get host;

  /// Create a copy of HTTP2Config
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HTTP2ConfigImplCopyWith<_$HTTP2ConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TCPConfig _$TCPConfigFromJson(Map<String, dynamic> json) {
  return _TCPConfig.fromJson(json);
}

/// @nodoc
mixin _$TCPConfig {
  /// TCP 伪装类型
  String get acceptQueryProtocol => throw _privateConstructorUsedError;

  /// HTTP 头部路径
  String? get headerPath => throw _privateConstructorUsedError;

  /// HTTP 头部端口
  int? get headerPorts => throw _privateConstructorUsedError;

  /// Serializes this TCPConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TCPConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TCPConfigCopyWith<TCPConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TCPConfigCopyWith<$Res> {
  factory $TCPConfigCopyWith(TCPConfig value, $Res Function(TCPConfig) then) =
      _$TCPConfigCopyWithImpl<$Res, TCPConfig>;
  @useResult
  $Res call({String acceptQueryProtocol, String? headerPath, int? headerPorts});
}

/// @nodoc
class _$TCPConfigCopyWithImpl<$Res, $Val extends TCPConfig>
    implements $TCPConfigCopyWith<$Res> {
  _$TCPConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TCPConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acceptQueryProtocol = null,
    Object? headerPath = freezed,
    Object? headerPorts = freezed,
  }) {
    return _then(_value.copyWith(
      acceptQueryProtocol: null == acceptQueryProtocol
          ? _value.acceptQueryProtocol
          : acceptQueryProtocol // ignore: cast_nullable_to_non_nullable
              as String,
      headerPath: freezed == headerPath
          ? _value.headerPath
          : headerPath // ignore: cast_nullable_to_non_nullable
              as String?,
      headerPorts: freezed == headerPorts
          ? _value.headerPorts
          : headerPorts // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TCPConfigImplCopyWith<$Res>
    implements $TCPConfigCopyWith<$Res> {
  factory _$$TCPConfigImplCopyWith(
          _$TCPConfigImpl value, $Res Function(_$TCPConfigImpl) then) =
      __$$TCPConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String acceptQueryProtocol, String? headerPath, int? headerPorts});
}

/// @nodoc
class __$$TCPConfigImplCopyWithImpl<$Res>
    extends _$TCPConfigCopyWithImpl<$Res, _$TCPConfigImpl>
    implements _$$TCPConfigImplCopyWith<$Res> {
  __$$TCPConfigImplCopyWithImpl(
      _$TCPConfigImpl _value, $Res Function(_$TCPConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of TCPConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acceptQueryProtocol = null,
    Object? headerPath = freezed,
    Object? headerPorts = freezed,
  }) {
    return _then(_$TCPConfigImpl(
      acceptQueryProtocol: null == acceptQueryProtocol
          ? _value.acceptQueryProtocol
          : acceptQueryProtocol // ignore: cast_nullable_to_non_nullable
              as String,
      headerPath: freezed == headerPath
          ? _value.headerPath
          : headerPath // ignore: cast_nullable_to_non_nullable
              as String?,
      headerPorts: freezed == headerPorts
          ? _value.headerPorts
          : headerPorts // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TCPConfigImpl implements _TCPConfig {
  const _$TCPConfigImpl(
      {this.acceptQueryProtocol = 'none', this.headerPath, this.headerPorts});

  factory _$TCPConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$TCPConfigImplFromJson(json);

  /// TCP 伪装类型
  @override
  @JsonKey()
  final String acceptQueryProtocol;

  /// HTTP 头部路径
  @override
  final String? headerPath;

  /// HTTP 头部端口
  @override
  final int? headerPorts;

  @override
  String toString() {
    return 'TCPConfig(acceptQueryProtocol: $acceptQueryProtocol, headerPath: $headerPath, headerPorts: $headerPorts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TCPConfigImpl &&
            (identical(other.acceptQueryProtocol, acceptQueryProtocol) ||
                other.acceptQueryProtocol == acceptQueryProtocol) &&
            (identical(other.headerPath, headerPath) ||
                other.headerPath == headerPath) &&
            (identical(other.headerPorts, headerPorts) ||
                other.headerPorts == headerPorts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, acceptQueryProtocol, headerPath, headerPorts);

  /// Create a copy of TCPConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TCPConfigImplCopyWith<_$TCPConfigImpl> get copyWith =>
      __$$TCPConfigImplCopyWithImpl<_$TCPConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TCPConfigImplToJson(
      this,
    );
  }
}

abstract class _TCPConfig implements TCPConfig {
  const factory _TCPConfig(
      {final String acceptQueryProtocol,
      final String? headerPath,
      final int? headerPorts}) = _$TCPConfigImpl;

  factory _TCPConfig.fromJson(Map<String, dynamic> json) =
      _$TCPConfigImpl.fromJson;

  /// TCP 伪装类型
  @override
  String get acceptQueryProtocol;

  /// HTTP 头部路径
  @override
  String? get headerPath;

  /// HTTP 头部端口
  @override
  int? get headerPorts;

  /// Create a copy of TCPConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TCPConfigImplCopyWith<_$TCPConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GRPCConfig _$GRPCConfigFromJson(Map<String, dynamic> json) {
  return _GRPCConfig.fromJson(json);
}

/// @nodoc
mixin _$GRPCConfig {
  /// gRPC 服务名称
  String get serviceName => throw _privateConstructorUsedError;

  /// gRPC 模式
  String get mode => throw _privateConstructorUsedError;

  /// Serializes this GRPCConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GRPCConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GRPCConfigCopyWith<GRPCConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GRPCConfigCopyWith<$Res> {
  factory $GRPCConfigCopyWith(
          GRPCConfig value, $Res Function(GRPCConfig) then) =
      _$GRPCConfigCopyWithImpl<$Res, GRPCConfig>;
  @useResult
  $Res call({String serviceName, String mode});
}

/// @nodoc
class _$GRPCConfigCopyWithImpl<$Res, $Val extends GRPCConfig>
    implements $GRPCConfigCopyWith<$Res> {
  _$GRPCConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GRPCConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceName = null,
    Object? mode = null,
  }) {
    return _then(_value.copyWith(
      serviceName: null == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GRPCConfigImplCopyWith<$Res>
    implements $GRPCConfigCopyWith<$Res> {
  factory _$$GRPCConfigImplCopyWith(
          _$GRPCConfigImpl value, $Res Function(_$GRPCConfigImpl) then) =
      __$$GRPCConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String serviceName, String mode});
}

/// @nodoc
class __$$GRPCConfigImplCopyWithImpl<$Res>
    extends _$GRPCConfigCopyWithImpl<$Res, _$GRPCConfigImpl>
    implements _$$GRPCConfigImplCopyWith<$Res> {
  __$$GRPCConfigImplCopyWithImpl(
      _$GRPCConfigImpl _value, $Res Function(_$GRPCConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of GRPCConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceName = null,
    Object? mode = null,
  }) {
    return _then(_$GRPCConfigImpl(
      serviceName: null == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GRPCConfigImpl implements _GRPCConfig {
  const _$GRPCConfigImpl({required this.serviceName, this.mode = 'multi'});

  factory _$GRPCConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$GRPCConfigImplFromJson(json);

  /// gRPC 服务名称
  @override
  final String serviceName;

  /// gRPC 模式
  @override
  @JsonKey()
  final String mode;

  @override
  String toString() {
    return 'GRPCConfig(serviceName: $serviceName, mode: $mode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GRPCConfigImpl &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, serviceName, mode);

  /// Create a copy of GRPCConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GRPCConfigImplCopyWith<_$GRPCConfigImpl> get copyWith =>
      __$$GRPCConfigImplCopyWithImpl<_$GRPCConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GRPCConfigImplToJson(
      this,
    );
  }
}

abstract class _GRPCConfig implements GRPCConfig {
  const factory _GRPCConfig(
      {required final String serviceName,
      final String mode}) = _$GRPCConfigImpl;

  factory _GRPCConfig.fromJson(Map<String, dynamic> json) =
      _$GRPCConfigImpl.fromJson;

  /// gRPC 服务名称
  @override
  String get serviceName;

  /// gRPC 模式
  @override
  String get mode;

  /// Create a copy of GRPCConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GRPCConfigImplCopyWith<_$GRPCConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TLSConfig _$TLSConfigFromJson(Map<String, dynamic> json) {
  return _TLSConfig.fromJson(json);
}

/// @nodoc
mixin _$TLSConfig {
  /// SNI 域名
  String get sni => throw _privateConstructorUsedError;

  /// ALPN 协议
  List<String> get alpn => throw _privateConstructorUsedError;

  /// TLS 证书路径
  String? get certPath => throw _privateConstructorUsedError;

  /// TLS 私钥路径
  String? get keyPath => throw _privateConstructorUsedError;

  /// Serializes this TLSConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TLSConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TLSConfigCopyWith<TLSConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TLSConfigCopyWith<$Res> {
  factory $TLSConfigCopyWith(TLSConfig value, $Res Function(TLSConfig) then) =
      _$TLSConfigCopyWithImpl<$Res, TLSConfig>;
  @useResult
  $Res call({String sni, List<String> alpn, String? certPath, String? keyPath});
}

/// @nodoc
class _$TLSConfigCopyWithImpl<$Res, $Val extends TLSConfig>
    implements $TLSConfigCopyWith<$Res> {
  _$TLSConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TLSConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sni = null,
    Object? alpn = null,
    Object? certPath = freezed,
    Object? keyPath = freezed,
  }) {
    return _then(_value.copyWith(
      sni: null == sni
          ? _value.sni
          : sni // ignore: cast_nullable_to_non_nullable
              as String,
      alpn: null == alpn
          ? _value.alpn
          : alpn // ignore: cast_nullable_to_non_nullable
              as List<String>,
      certPath: freezed == certPath
          ? _value.certPath
          : certPath // ignore: cast_nullable_to_non_nullable
              as String?,
      keyPath: freezed == keyPath
          ? _value.keyPath
          : keyPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TLSConfigImplCopyWith<$Res>
    implements $TLSConfigCopyWith<$Res> {
  factory _$$TLSConfigImplCopyWith(
          _$TLSConfigImpl value, $Res Function(_$TLSConfigImpl) then) =
      __$$TLSConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sni, List<String> alpn, String? certPath, String? keyPath});
}

/// @nodoc
class __$$TLSConfigImplCopyWithImpl<$Res>
    extends _$TLSConfigCopyWithImpl<$Res, _$TLSConfigImpl>
    implements _$$TLSConfigImplCopyWith<$Res> {
  __$$TLSConfigImplCopyWithImpl(
      _$TLSConfigImpl _value, $Res Function(_$TLSConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of TLSConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sni = null,
    Object? alpn = null,
    Object? certPath = freezed,
    Object? keyPath = freezed,
  }) {
    return _then(_$TLSConfigImpl(
      sni: null == sni
          ? _value.sni
          : sni // ignore: cast_nullable_to_non_nullable
              as String,
      alpn: null == alpn
          ? _value._alpn
          : alpn // ignore: cast_nullable_to_non_nullable
              as List<String>,
      certPath: freezed == certPath
          ? _value.certPath
          : certPath // ignore: cast_nullable_to_non_nullable
              as String?,
      keyPath: freezed == keyPath
          ? _value.keyPath
          : keyPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TLSConfigImpl implements _TLSConfig {
  const _$TLSConfigImpl(
      {required this.sni,
      final List<String> alpn = const ['http/1.1'],
      this.certPath,
      this.keyPath})
      : _alpn = alpn;

  factory _$TLSConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$TLSConfigImplFromJson(json);

  /// SNI 域名
  @override
  final String sni;

  /// ALPN 协议
  final List<String> _alpn;

  /// ALPN 协议
  @override
  @JsonKey()
  List<String> get alpn {
    if (_alpn is EqualUnmodifiableListView) return _alpn;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alpn);
  }

  /// TLS 证书路径
  @override
  final String? certPath;

  /// TLS 私钥路径
  @override
  final String? keyPath;

  @override
  String toString() {
    return 'TLSConfig(sni: $sni, alpn: $alpn, certPath: $certPath, keyPath: $keyPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TLSConfigImpl &&
            (identical(other.sni, sni) || other.sni == sni) &&
            const DeepCollectionEquality().equals(other._alpn, _alpn) &&
            (identical(other.certPath, certPath) ||
                other.certPath == certPath) &&
            (identical(other.keyPath, keyPath) || other.keyPath == keyPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sni,
      const DeepCollectionEquality().hash(_alpn), certPath, keyPath);

  /// Create a copy of TLSConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TLSConfigImplCopyWith<_$TLSConfigImpl> get copyWith =>
      __$$TLSConfigImplCopyWithImpl<_$TLSConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TLSConfigImplToJson(
      this,
    );
  }
}

abstract class _TLSConfig implements TLSConfig {
  const factory _TLSConfig(
      {required final String sni,
      final List<String> alpn,
      final String? certPath,
      final String? keyPath}) = _$TLSConfigImpl;

  factory _TLSConfig.fromJson(Map<String, dynamic> json) =
      _$TLSConfigImpl.fromJson;

  /// SNI 域名
  @override
  String get sni;

  /// ALPN 协议
  @override
  List<String> get alpn;

  /// TLS 证书路径
  @override
  String? get certPath;

  /// TLS 私钥路径
  @override
  String? get keyPath;

  /// Create a copy of TLSConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TLSConfigImplCopyWith<_$TLSConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GeoInfo _$GeoInfoFromJson(Map<String, dynamic> json) {
  return _GeoInfo.fromJson(json);
}

/// @nodoc
mixin _$GeoInfo {
  /// 国家代码
  String? get countryCode => throw _privateConstructorUsedError;

  /// 国家名称
  String? get country => throw _privateConstructorUsedError;

  /// 地区名称
  String? get region => throw _privateConstructorUsedError;

  /// 城市名称
  String? get city => throw _privateConstructorUsedError;

  /// 时区
  String? get timezone => throw _privateConstructorUsedError;

  /// ISP 名称
  String? get isp => throw _privateConstructorUsedError;

  /// ASN 信息
  String? get asn => throw _privateConstructorUsedError;

  /// 纬度
  double? get latitude => throw _privateConstructorUsedError;

  /// 经度
  double? get longitude => throw _privateConstructorUsedError;

  /// Serializes this GeoInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeoInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeoInfoCopyWith<GeoInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeoInfoCopyWith<$Res> {
  factory $GeoInfoCopyWith(GeoInfo value, $Res Function(GeoInfo) then) =
      _$GeoInfoCopyWithImpl<$Res, GeoInfo>;
  @useResult
  $Res call(
      {String? countryCode,
      String? country,
      String? region,
      String? city,
      String? timezone,
      String? isp,
      String? asn,
      double? latitude,
      double? longitude});
}

/// @nodoc
class _$GeoInfoCopyWithImpl<$Res, $Val extends GeoInfo>
    implements $GeoInfoCopyWith<$Res> {
  _$GeoInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeoInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countryCode = freezed,
    Object? country = freezed,
    Object? region = freezed,
    Object? city = freezed,
    Object? timezone = freezed,
    Object? isp = freezed,
    Object? asn = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_value.copyWith(
      countryCode: freezed == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      isp: freezed == isp
          ? _value.isp
          : isp // ignore: cast_nullable_to_non_nullable
              as String?,
      asn: freezed == asn
          ? _value.asn
          : asn // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeoInfoImplCopyWith<$Res> implements $GeoInfoCopyWith<$Res> {
  factory _$$GeoInfoImplCopyWith(
          _$GeoInfoImpl value, $Res Function(_$GeoInfoImpl) then) =
      __$$GeoInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? countryCode,
      String? country,
      String? region,
      String? city,
      String? timezone,
      String? isp,
      String? asn,
      double? latitude,
      double? longitude});
}

/// @nodoc
class __$$GeoInfoImplCopyWithImpl<$Res>
    extends _$GeoInfoCopyWithImpl<$Res, _$GeoInfoImpl>
    implements _$$GeoInfoImplCopyWith<$Res> {
  __$$GeoInfoImplCopyWithImpl(
      _$GeoInfoImpl _value, $Res Function(_$GeoInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of GeoInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countryCode = freezed,
    Object? country = freezed,
    Object? region = freezed,
    Object? city = freezed,
    Object? timezone = freezed,
    Object? isp = freezed,
    Object? asn = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_$GeoInfoImpl(
      countryCode: freezed == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      isp: freezed == isp
          ? _value.isp
          : isp // ignore: cast_nullable_to_non_nullable
              as String?,
      asn: freezed == asn
          ? _value.asn
          : asn // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeoInfoImpl implements _GeoInfo {
  const _$GeoInfoImpl(
      {this.countryCode,
      this.country,
      this.region,
      this.city,
      this.timezone,
      this.isp,
      this.asn,
      this.latitude,
      this.longitude});

  factory _$GeoInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeoInfoImplFromJson(json);

  /// 国家代码
  @override
  final String? countryCode;

  /// 国家名称
  @override
  final String? country;

  /// 地区名称
  @override
  final String? region;

  /// 城市名称
  @override
  final String? city;

  /// 时区
  @override
  final String? timezone;

  /// ISP 名称
  @override
  final String? isp;

  /// ASN 信息
  @override
  final String? asn;

  /// 纬度
  @override
  final double? latitude;

  /// 经度
  @override
  final double? longitude;

  @override
  String toString() {
    return 'GeoInfo(countryCode: $countryCode, country: $country, region: $region, city: $city, timezone: $timezone, isp: $isp, asn: $asn, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeoInfoImpl &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.isp, isp) || other.isp == isp) &&
            (identical(other.asn, asn) || other.asn == asn) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, countryCode, country, region,
      city, timezone, isp, asn, latitude, longitude);

  /// Create a copy of GeoInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeoInfoImplCopyWith<_$GeoInfoImpl> get copyWith =>
      __$$GeoInfoImplCopyWithImpl<_$GeoInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeoInfoImplToJson(
      this,
    );
  }
}

abstract class _GeoInfo implements GeoInfo {
  const factory _GeoInfo(
      {final String? countryCode,
      final String? country,
      final String? region,
      final String? city,
      final String? timezone,
      final String? isp,
      final String? asn,
      final double? latitude,
      final double? longitude}) = _$GeoInfoImpl;

  factory _GeoInfo.fromJson(Map<String, dynamic> json) = _$GeoInfoImpl.fromJson;

  /// 国家代码
  @override
  String? get countryCode;

  /// 国家名称
  @override
  String? get country;

  /// 地区名称
  @override
  String? get region;

  /// 城市名称
  @override
  String? get city;

  /// 时区
  @override
  String? get timezone;

  /// ISP 名称
  @override
  String? get isp;

  /// ASN 信息
  @override
  String? get asn;

  /// 纬度
  @override
  double? get latitude;

  /// 经度
  @override
  double? get longitude;

  /// Create a copy of GeoInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeoInfoImplCopyWith<_$GeoInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NodePerformance _$NodePerformanceFromJson(Map<String, dynamic> json) {
  return _NodePerformance.fromJson(json);
}

/// @nodoc
mixin _$NodePerformance {
  /// 平均延迟
  int? get avgLatency => throw _privateConstructorUsedError;

  /// 最小延迟
  int? get minLatency => throw _privateConstructorUsedError;

  /// 最大延迟
  int? get maxLatency => throw _privateConstructorUsedError;

  /// 成功率百分比
  double get successRate => throw _privateConstructorUsedError;

  /// 测试次数
  int get testCount => throw _privateConstructorUsedError;

  /// 最后成功时间
  DateTime? get lastSuccessTime => throw _privateConstructorUsedError;

  /// 最后失败时间
  DateTime? get lastFailTime => throw _privateConstructorUsedError;

  /// 连续失败次数
  int get consecutiveFailures => throw _privateConstructorUsedError;

  /// 稳定性评分（0-100）
  int get stabilityScore => throw _privateConstructorUsedError;

  /// Serializes this NodePerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NodePerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NodePerformanceCopyWith<NodePerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodePerformanceCopyWith<$Res> {
  factory $NodePerformanceCopyWith(
          NodePerformance value, $Res Function(NodePerformance) then) =
      _$NodePerformanceCopyWithImpl<$Res, NodePerformance>;
  @useResult
  $Res call(
      {int? avgLatency,
      int? minLatency,
      int? maxLatency,
      double successRate,
      int testCount,
      DateTime? lastSuccessTime,
      DateTime? lastFailTime,
      int consecutiveFailures,
      int stabilityScore});
}

/// @nodoc
class _$NodePerformanceCopyWithImpl<$Res, $Val extends NodePerformance>
    implements $NodePerformanceCopyWith<$Res> {
  _$NodePerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NodePerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgLatency = freezed,
    Object? minLatency = freezed,
    Object? maxLatency = freezed,
    Object? successRate = null,
    Object? testCount = null,
    Object? lastSuccessTime = freezed,
    Object? lastFailTime = freezed,
    Object? consecutiveFailures = null,
    Object? stabilityScore = null,
  }) {
    return _then(_value.copyWith(
      avgLatency: freezed == avgLatency
          ? _value.avgLatency
          : avgLatency // ignore: cast_nullable_to_non_nullable
              as int?,
      minLatency: freezed == minLatency
          ? _value.minLatency
          : minLatency // ignore: cast_nullable_to_non_nullable
              as int?,
      maxLatency: freezed == maxLatency
          ? _value.maxLatency
          : maxLatency // ignore: cast_nullable_to_non_nullable
              as int?,
      successRate: null == successRate
          ? _value.successRate
          : successRate // ignore: cast_nullable_to_non_nullable
              as double,
      testCount: null == testCount
          ? _value.testCount
          : testCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastSuccessTime: freezed == lastSuccessTime
          ? _value.lastSuccessTime
          : lastSuccessTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastFailTime: freezed == lastFailTime
          ? _value.lastFailTime
          : lastFailTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      consecutiveFailures: null == consecutiveFailures
          ? _value.consecutiveFailures
          : consecutiveFailures // ignore: cast_nullable_to_non_nullable
              as int,
      stabilityScore: null == stabilityScore
          ? _value.stabilityScore
          : stabilityScore // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NodePerformanceImplCopyWith<$Res>
    implements $NodePerformanceCopyWith<$Res> {
  factory _$$NodePerformanceImplCopyWith(_$NodePerformanceImpl value,
          $Res Function(_$NodePerformanceImpl) then) =
      __$$NodePerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? avgLatency,
      int? minLatency,
      int? maxLatency,
      double successRate,
      int testCount,
      DateTime? lastSuccessTime,
      DateTime? lastFailTime,
      int consecutiveFailures,
      int stabilityScore});
}

/// @nodoc
class __$$NodePerformanceImplCopyWithImpl<$Res>
    extends _$NodePerformanceCopyWithImpl<$Res, _$NodePerformanceImpl>
    implements _$$NodePerformanceImplCopyWith<$Res> {
  __$$NodePerformanceImplCopyWithImpl(
      _$NodePerformanceImpl _value, $Res Function(_$NodePerformanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of NodePerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgLatency = freezed,
    Object? minLatency = freezed,
    Object? maxLatency = freezed,
    Object? successRate = null,
    Object? testCount = null,
    Object? lastSuccessTime = freezed,
    Object? lastFailTime = freezed,
    Object? consecutiveFailures = null,
    Object? stabilityScore = null,
  }) {
    return _then(_$NodePerformanceImpl(
      avgLatency: freezed == avgLatency
          ? _value.avgLatency
          : avgLatency // ignore: cast_nullable_to_non_nullable
              as int?,
      minLatency: freezed == minLatency
          ? _value.minLatency
          : minLatency // ignore: cast_nullable_to_non_nullable
              as int?,
      maxLatency: freezed == maxLatency
          ? _value.maxLatency
          : maxLatency // ignore: cast_nullable_to_non_nullable
              as int?,
      successRate: null == successRate
          ? _value.successRate
          : successRate // ignore: cast_nullable_to_non_nullable
              as double,
      testCount: null == testCount
          ? _value.testCount
          : testCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastSuccessTime: freezed == lastSuccessTime
          ? _value.lastSuccessTime
          : lastSuccessTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastFailTime: freezed == lastFailTime
          ? _value.lastFailTime
          : lastFailTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      consecutiveFailures: null == consecutiveFailures
          ? _value.consecutiveFailures
          : consecutiveFailures // ignore: cast_nullable_to_non_nullable
              as int,
      stabilityScore: null == stabilityScore
          ? _value.stabilityScore
          : stabilityScore // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NodePerformanceImpl implements _NodePerformance {
  const _$NodePerformanceImpl(
      {this.avgLatency,
      this.minLatency,
      this.maxLatency,
      this.successRate = 0.0,
      this.testCount = 0,
      this.lastSuccessTime,
      this.lastFailTime,
      this.consecutiveFailures = 0,
      this.stabilityScore = 0});

  factory _$NodePerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$NodePerformanceImplFromJson(json);

  /// 平均延迟
  @override
  final int? avgLatency;

  /// 最小延迟
  @override
  final int? minLatency;

  /// 最大延迟
  @override
  final int? maxLatency;

  /// 成功率百分比
  @override
  @JsonKey()
  final double successRate;

  /// 测试次数
  @override
  @JsonKey()
  final int testCount;

  /// 最后成功时间
  @override
  final DateTime? lastSuccessTime;

  /// 最后失败时间
  @override
  final DateTime? lastFailTime;

  /// 连续失败次数
  @override
  @JsonKey()
  final int consecutiveFailures;

  /// 稳定性评分（0-100）
  @override
  @JsonKey()
  final int stabilityScore;

  @override
  String toString() {
    return 'NodePerformance(avgLatency: $avgLatency, minLatency: $minLatency, maxLatency: $maxLatency, successRate: $successRate, testCount: $testCount, lastSuccessTime: $lastSuccessTime, lastFailTime: $lastFailTime, consecutiveFailures: $consecutiveFailures, stabilityScore: $stabilityScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodePerformanceImpl &&
            (identical(other.avgLatency, avgLatency) ||
                other.avgLatency == avgLatency) &&
            (identical(other.minLatency, minLatency) ||
                other.minLatency == minLatency) &&
            (identical(other.maxLatency, maxLatency) ||
                other.maxLatency == maxLatency) &&
            (identical(other.successRate, successRate) ||
                other.successRate == successRate) &&
            (identical(other.testCount, testCount) ||
                other.testCount == testCount) &&
            (identical(other.lastSuccessTime, lastSuccessTime) ||
                other.lastSuccessTime == lastSuccessTime) &&
            (identical(other.lastFailTime, lastFailTime) ||
                other.lastFailTime == lastFailTime) &&
            (identical(other.consecutiveFailures, consecutiveFailures) ||
                other.consecutiveFailures == consecutiveFailures) &&
            (identical(other.stabilityScore, stabilityScore) ||
                other.stabilityScore == stabilityScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      avgLatency,
      minLatency,
      maxLatency,
      successRate,
      testCount,
      lastSuccessTime,
      lastFailTime,
      consecutiveFailures,
      stabilityScore);

  /// Create a copy of NodePerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NodePerformanceImplCopyWith<_$NodePerformanceImpl> get copyWith =>
      __$$NodePerformanceImplCopyWithImpl<_$NodePerformanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NodePerformanceImplToJson(
      this,
    );
  }
}

abstract class _NodePerformance implements NodePerformance {
  const factory _NodePerformance(
      {final int? avgLatency,
      final int? minLatency,
      final int? maxLatency,
      final double successRate,
      final int testCount,
      final DateTime? lastSuccessTime,
      final DateTime? lastFailTime,
      final int consecutiveFailures,
      final int stabilityScore}) = _$NodePerformanceImpl;

  factory _NodePerformance.fromJson(Map<String, dynamic> json) =
      _$NodePerformanceImpl.fromJson;

  /// 平均延迟
  @override
  int? get avgLatency;

  /// 最小延迟
  @override
  int? get minLatency;

  /// 最大延迟
  @override
  int? get maxLatency;

  /// 成功率百分比
  @override
  double get successRate;

  /// 测试次数
  @override
  int get testCount;

  /// 最后成功时间
  @override
  DateTime? get lastSuccessTime;

  /// 最后失败时间
  @override
  DateTime? get lastFailTime;

  /// 连续失败次数
  @override
  int get consecutiveFailures;

  /// 稳定性评分（0-100）
  @override
  int get stabilityScore;

  /// Create a copy of NodePerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NodePerformanceImplCopyWith<_$NodePerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NodeFilter _$NodeFilterFromJson(Map<String, dynamic> json) {
  return _NodeFilter.fromJson(json);
}

/// @nodoc
mixin _$NodeFilter {
  /// 节点类型过滤
  List<ProxyType>? get types => throw _privateConstructorUsedError;

  /// 节点状态过滤
  List<NodeStatus>? get statuses => throw _privateConstructorUsedError;

  /// 国家过滤
  List<String>? get countries => throw _privateConstructorUsedError;

  /// ISP 过滤
  List<String>? get isps => throw _privateConstructorUsedError;

  /// 标签过滤
  List<String>? get tags => throw _privateConstructorUsedError;

  /// 是否收藏
  bool? get isFavorite => throw _privateConstructorUsedError;

  /// 是否启用
  bool? get isEnabled => throw _privateConstructorUsedError;

  /// 最大延迟
  int? get maxLatency => throw _privateConstructorUsedError;

  /// 最小成功率
  double? get minSuccessRate => throw _privateConstructorUsedError;

  /// 关键词过滤
  String? get keyword => throw _privateConstructorUsedError;

  /// 自定义过滤函数
  String? get customFilter => throw _privateConstructorUsedError;

  /// Serializes this NodeFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NodeFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NodeFilterCopyWith<NodeFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeFilterCopyWith<$Res> {
  factory $NodeFilterCopyWith(
          NodeFilter value, $Res Function(NodeFilter) then) =
      _$NodeFilterCopyWithImpl<$Res, NodeFilter>;
  @useResult
  $Res call(
      {List<ProxyType>? types,
      List<NodeStatus>? statuses,
      List<String>? countries,
      List<String>? isps,
      List<String>? tags,
      bool? isFavorite,
      bool? isEnabled,
      int? maxLatency,
      double? minSuccessRate,
      String? keyword,
      String? customFilter});
}

/// @nodoc
class _$NodeFilterCopyWithImpl<$Res, $Val extends NodeFilter>
    implements $NodeFilterCopyWith<$Res> {
  _$NodeFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NodeFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? types = freezed,
    Object? statuses = freezed,
    Object? countries = freezed,
    Object? isps = freezed,
    Object? tags = freezed,
    Object? isFavorite = freezed,
    Object? isEnabled = freezed,
    Object? maxLatency = freezed,
    Object? minSuccessRate = freezed,
    Object? keyword = freezed,
    Object? customFilter = freezed,
  }) {
    return _then(_value.copyWith(
      types: freezed == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as List<ProxyType>?,
      statuses: freezed == statuses
          ? _value.statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as List<NodeStatus>?,
      countries: freezed == countries
          ? _value.countries
          : countries // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isps: freezed == isps
          ? _value.isps
          : isps // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isFavorite: freezed == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool?,
      isEnabled: freezed == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      maxLatency: freezed == maxLatency
          ? _value.maxLatency
          : maxLatency // ignore: cast_nullable_to_non_nullable
              as int?,
      minSuccessRate: freezed == minSuccessRate
          ? _value.minSuccessRate
          : minSuccessRate // ignore: cast_nullable_to_non_nullable
              as double?,
      keyword: freezed == keyword
          ? _value.keyword
          : keyword // ignore: cast_nullable_to_non_nullable
              as String?,
      customFilter: freezed == customFilter
          ? _value.customFilter
          : customFilter // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NodeFilterImplCopyWith<$Res>
    implements $NodeFilterCopyWith<$Res> {
  factory _$$NodeFilterImplCopyWith(
          _$NodeFilterImpl value, $Res Function(_$NodeFilterImpl) then) =
      __$$NodeFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ProxyType>? types,
      List<NodeStatus>? statuses,
      List<String>? countries,
      List<String>? isps,
      List<String>? tags,
      bool? isFavorite,
      bool? isEnabled,
      int? maxLatency,
      double? minSuccessRate,
      String? keyword,
      String? customFilter});
}

/// @nodoc
class __$$NodeFilterImplCopyWithImpl<$Res>
    extends _$NodeFilterCopyWithImpl<$Res, _$NodeFilterImpl>
    implements _$$NodeFilterImplCopyWith<$Res> {
  __$$NodeFilterImplCopyWithImpl(
      _$NodeFilterImpl _value, $Res Function(_$NodeFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of NodeFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? types = freezed,
    Object? statuses = freezed,
    Object? countries = freezed,
    Object? isps = freezed,
    Object? tags = freezed,
    Object? isFavorite = freezed,
    Object? isEnabled = freezed,
    Object? maxLatency = freezed,
    Object? minSuccessRate = freezed,
    Object? keyword = freezed,
    Object? customFilter = freezed,
  }) {
    return _then(_$NodeFilterImpl(
      types: freezed == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as List<ProxyType>?,
      statuses: freezed == statuses
          ? _value._statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as List<NodeStatus>?,
      countries: freezed == countries
          ? _value._countries
          : countries // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isps: freezed == isps
          ? _value._isps
          : isps // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isFavorite: freezed == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool?,
      isEnabled: freezed == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      maxLatency: freezed == maxLatency
          ? _value.maxLatency
          : maxLatency // ignore: cast_nullable_to_non_nullable
              as int?,
      minSuccessRate: freezed == minSuccessRate
          ? _value.minSuccessRate
          : minSuccessRate // ignore: cast_nullable_to_non_nullable
              as double?,
      keyword: freezed == keyword
          ? _value.keyword
          : keyword // ignore: cast_nullable_to_non_nullable
              as String?,
      customFilter: freezed == customFilter
          ? _value.customFilter
          : customFilter // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NodeFilterImpl implements _NodeFilter {
  const _$NodeFilterImpl(
      {final List<ProxyType>? types,
      final List<NodeStatus>? statuses,
      final List<String>? countries,
      final List<String>? isps,
      final List<String>? tags,
      this.isFavorite,
      this.isEnabled,
      this.maxLatency,
      this.minSuccessRate,
      this.keyword,
      this.customFilter})
      : _types = types,
        _statuses = statuses,
        _countries = countries,
        _isps = isps,
        _tags = tags;

  factory _$NodeFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$NodeFilterImplFromJson(json);

  /// 节点类型过滤
  final List<ProxyType>? _types;

  /// 节点类型过滤
  @override
  List<ProxyType>? get types {
    final value = _types;
    if (value == null) return null;
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 节点状态过滤
  final List<NodeStatus>? _statuses;

  /// 节点状态过滤
  @override
  List<NodeStatus>? get statuses {
    final value = _statuses;
    if (value == null) return null;
    if (_statuses is EqualUnmodifiableListView) return _statuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 国家过滤
  final List<String>? _countries;

  /// 国家过滤
  @override
  List<String>? get countries {
    final value = _countries;
    if (value == null) return null;
    if (_countries is EqualUnmodifiableListView) return _countries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// ISP 过滤
  final List<String>? _isps;

  /// ISP 过滤
  @override
  List<String>? get isps {
    final value = _isps;
    if (value == null) return null;
    if (_isps is EqualUnmodifiableListView) return _isps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 标签过滤
  final List<String>? _tags;

  /// 标签过滤
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 是否收藏
  @override
  final bool? isFavorite;

  /// 是否启用
  @override
  final bool? isEnabled;

  /// 最大延迟
  @override
  final int? maxLatency;

  /// 最小成功率
  @override
  final double? minSuccessRate;

  /// 关键词过滤
  @override
  final String? keyword;

  /// 自定义过滤函数
  @override
  final String? customFilter;

  @override
  String toString() {
    return 'NodeFilter(types: $types, statuses: $statuses, countries: $countries, isps: $isps, tags: $tags, isFavorite: $isFavorite, isEnabled: $isEnabled, maxLatency: $maxLatency, minSuccessRate: $minSuccessRate, keyword: $keyword, customFilter: $customFilter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeFilterImpl &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            const DeepCollectionEquality().equals(other._statuses, _statuses) &&
            const DeepCollectionEquality()
                .equals(other._countries, _countries) &&
            const DeepCollectionEquality().equals(other._isps, _isps) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.maxLatency, maxLatency) ||
                other.maxLatency == maxLatency) &&
            (identical(other.minSuccessRate, minSuccessRate) ||
                other.minSuccessRate == minSuccessRate) &&
            (identical(other.keyword, keyword) || other.keyword == keyword) &&
            (identical(other.customFilter, customFilter) ||
                other.customFilter == customFilter));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_types),
      const DeepCollectionEquality().hash(_statuses),
      const DeepCollectionEquality().hash(_countries),
      const DeepCollectionEquality().hash(_isps),
      const DeepCollectionEquality().hash(_tags),
      isFavorite,
      isEnabled,
      maxLatency,
      minSuccessRate,
      keyword,
      customFilter);

  /// Create a copy of NodeFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeFilterImplCopyWith<_$NodeFilterImpl> get copyWith =>
      __$$NodeFilterImplCopyWithImpl<_$NodeFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NodeFilterImplToJson(
      this,
    );
  }
}

abstract class _NodeFilter implements NodeFilter {
  const factory _NodeFilter(
      {final List<ProxyType>? types,
      final List<NodeStatus>? statuses,
      final List<String>? countries,
      final List<String>? isps,
      final List<String>? tags,
      final bool? isFavorite,
      final bool? isEnabled,
      final int? maxLatency,
      final double? minSuccessRate,
      final String? keyword,
      final String? customFilter}) = _$NodeFilterImpl;

  factory _NodeFilter.fromJson(Map<String, dynamic> json) =
      _$NodeFilterImpl.fromJson;

  /// 节点类型过滤
  @override
  List<ProxyType>? get types;

  /// 节点状态过滤
  @override
  List<NodeStatus>? get statuses;

  /// 国家过滤
  @override
  List<String>? get countries;

  /// ISP 过滤
  @override
  List<String>? get isps;

  /// 标签过滤
  @override
  List<String>? get tags;

  /// 是否收藏
  @override
  bool? get isFavorite;

  /// 是否启用
  @override
  bool? get isEnabled;

  /// 最大延迟
  @override
  int? get maxLatency;

  /// 最小成功率
  @override
  double? get minSuccessRate;

  /// 关键词过滤
  @override
  String? get keyword;

  /// 自定义过滤函数
  @override
  String? get customFilter;

  /// Create a copy of NodeFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NodeFilterImplCopyWith<_$NodeFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NodeSort _$NodeSortFromJson(Map<String, dynamic> json) {
  return _NodeSort.fromJson(json);
}

/// @nodoc
mixin _$NodeSort {
  /// 排序字段
  NodeSortField get field => throw _privateConstructorUsedError;

  /// 排序方式
  SortOrder get order => throw _privateConstructorUsedError;

  /// Serializes this NodeSort to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NodeSort
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NodeSortCopyWith<NodeSort> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeSortCopyWith<$Res> {
  factory $NodeSortCopyWith(NodeSort value, $Res Function(NodeSort) then) =
      _$NodeSortCopyWithImpl<$Res, NodeSort>;
  @useResult
  $Res call({NodeSortField field, SortOrder order});
}

/// @nodoc
class _$NodeSortCopyWithImpl<$Res, $Val extends NodeSort>
    implements $NodeSortCopyWith<$Res> {
  _$NodeSortCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NodeSort
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? order = null,
  }) {
    return _then(_value.copyWith(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as NodeSortField,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as SortOrder,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NodeSortImplCopyWith<$Res>
    implements $NodeSortCopyWith<$Res> {
  factory _$$NodeSortImplCopyWith(
          _$NodeSortImpl value, $Res Function(_$NodeSortImpl) then) =
      __$$NodeSortImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({NodeSortField field, SortOrder order});
}

/// @nodoc
class __$$NodeSortImplCopyWithImpl<$Res>
    extends _$NodeSortCopyWithImpl<$Res, _$NodeSortImpl>
    implements _$$NodeSortImplCopyWith<$Res> {
  __$$NodeSortImplCopyWithImpl(
      _$NodeSortImpl _value, $Res Function(_$NodeSortImpl) _then)
      : super(_value, _then);

  /// Create a copy of NodeSort
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? order = null,
  }) {
    return _then(_$NodeSortImpl(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as NodeSortField,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as SortOrder,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NodeSortImpl implements _NodeSort {
  const _$NodeSortImpl(
      {this.field = NodeSortField.name, this.order = SortOrder.asc});

  factory _$NodeSortImpl.fromJson(Map<String, dynamic> json) =>
      _$$NodeSortImplFromJson(json);

  /// 排序字段
  @override
  @JsonKey()
  final NodeSortField field;

  /// 排序方式
  @override
  @JsonKey()
  final SortOrder order;

  @override
  String toString() {
    return 'NodeSort(field: $field, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeSortImpl &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, field, order);

  /// Create a copy of NodeSort
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeSortImplCopyWith<_$NodeSortImpl> get copyWith =>
      __$$NodeSortImplCopyWithImpl<_$NodeSortImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NodeSortImplToJson(
      this,
    );
  }
}

abstract class _NodeSort implements NodeSort {
  const factory _NodeSort({final NodeSortField field, final SortOrder order}) =
      _$NodeSortImpl;

  factory _NodeSort.fromJson(Map<String, dynamic> json) =
      _$NodeSortImpl.fromJson;

  /// 排序字段
  @override
  NodeSortField get field;

  /// 排序方式
  @override
  SortOrder get order;

  /// Create a copy of NodeSort
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NodeSortImplCopyWith<_$NodeSortImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NodeImportResult _$NodeImportResultFromJson(Map<String, dynamic> json) {
  return _NodeImportResult.fromJson(json);
}

/// @nodoc
mixin _$NodeImportResult {
  /// 是否成功
  bool get success => throw _privateConstructorUsedError;

  /// 导入的节点数量
  int get importedNodes => throw _privateConstructorUsedError;

  /// 有效节点数量
  int get validNodes => throw _privateConstructorUsedError;

  /// 无效节点数量
  int get invalidNodes => throw _privateConstructorUsedError;

  /// 重复节点数量
  int get duplicateNodes => throw _privateConstructorUsedError;

  /// 错误信息列表
  List<String> get errors => throw _privateConstructorUsedError;

  /// 导入的节点列表
  List<ProxyNode> get nodes => throw _privateConstructorUsedError;

  /// 导入统计信息
  NodeImportStats get importStats => throw _privateConstructorUsedError;

  /// Serializes this NodeImportResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NodeImportResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NodeImportResultCopyWith<NodeImportResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeImportResultCopyWith<$Res> {
  factory $NodeImportResultCopyWith(
          NodeImportResult value, $Res Function(NodeImportResult) then) =
      _$NodeImportResultCopyWithImpl<$Res, NodeImportResult>;
  @useResult
  $Res call(
      {bool success,
      int importedNodes,
      int validNodes,
      int invalidNodes,
      int duplicateNodes,
      List<String> errors,
      List<ProxyNode> nodes,
      NodeImportStats importStats});

  $NodeImportStatsCopyWith<$Res> get importStats;
}

/// @nodoc
class _$NodeImportResultCopyWithImpl<$Res, $Val extends NodeImportResult>
    implements $NodeImportResultCopyWith<$Res> {
  _$NodeImportResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NodeImportResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? importedNodes = null,
    Object? validNodes = null,
    Object? invalidNodes = null,
    Object? duplicateNodes = null,
    Object? errors = null,
    Object? nodes = null,
    Object? importStats = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      importedNodes: null == importedNodes
          ? _value.importedNodes
          : importedNodes // ignore: cast_nullable_to_non_nullable
              as int,
      validNodes: null == validNodes
          ? _value.validNodes
          : validNodes // ignore: cast_nullable_to_non_nullable
              as int,
      invalidNodes: null == invalidNodes
          ? _value.invalidNodes
          : invalidNodes // ignore: cast_nullable_to_non_nullable
              as int,
      duplicateNodes: null == duplicateNodes
          ? _value.duplicateNodes
          : duplicateNodes // ignore: cast_nullable_to_non_nullable
              as int,
      errors: null == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nodes: null == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<ProxyNode>,
      importStats: null == importStats
          ? _value.importStats
          : importStats // ignore: cast_nullable_to_non_nullable
              as NodeImportStats,
    ) as $Val);
  }

  /// Create a copy of NodeImportResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NodeImportStatsCopyWith<$Res> get importStats {
    return $NodeImportStatsCopyWith<$Res>(_value.importStats, (value) {
      return _then(_value.copyWith(importStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NodeImportResultImplCopyWith<$Res>
    implements $NodeImportResultCopyWith<$Res> {
  factory _$$NodeImportResultImplCopyWith(_$NodeImportResultImpl value,
          $Res Function(_$NodeImportResultImpl) then) =
      __$$NodeImportResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      int importedNodes,
      int validNodes,
      int invalidNodes,
      int duplicateNodes,
      List<String> errors,
      List<ProxyNode> nodes,
      NodeImportStats importStats});

  @override
  $NodeImportStatsCopyWith<$Res> get importStats;
}

/// @nodoc
class __$$NodeImportResultImplCopyWithImpl<$Res>
    extends _$NodeImportResultCopyWithImpl<$Res, _$NodeImportResultImpl>
    implements _$$NodeImportResultImplCopyWith<$Res> {
  __$$NodeImportResultImplCopyWithImpl(_$NodeImportResultImpl _value,
      $Res Function(_$NodeImportResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of NodeImportResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? importedNodes = null,
    Object? validNodes = null,
    Object? invalidNodes = null,
    Object? duplicateNodes = null,
    Object? errors = null,
    Object? nodes = null,
    Object? importStats = null,
  }) {
    return _then(_$NodeImportResultImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      importedNodes: null == importedNodes
          ? _value.importedNodes
          : importedNodes // ignore: cast_nullable_to_non_nullable
              as int,
      validNodes: null == validNodes
          ? _value.validNodes
          : validNodes // ignore: cast_nullable_to_non_nullable
              as int,
      invalidNodes: null == invalidNodes
          ? _value.invalidNodes
          : invalidNodes // ignore: cast_nullable_to_non_nullable
              as int,
      duplicateNodes: null == duplicateNodes
          ? _value.duplicateNodes
          : duplicateNodes // ignore: cast_nullable_to_non_nullable
              as int,
      errors: null == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nodes: null == nodes
          ? _value._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<ProxyNode>,
      importStats: null == importStats
          ? _value.importStats
          : importStats // ignore: cast_nullable_to_non_nullable
              as NodeImportStats,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NodeImportResultImpl implements _NodeImportResult {
  const _$NodeImportResultImpl(
      {required this.success,
      this.importedNodes = 0,
      this.validNodes = 0,
      this.invalidNodes = 0,
      this.duplicateNodes = 0,
      final List<String> errors = const [],
      final List<ProxyNode> nodes = const [],
      this.importStats = _emptyImportStats})
      : _errors = errors,
        _nodes = nodes;

  factory _$NodeImportResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$NodeImportResultImplFromJson(json);

  /// 是否成功
  @override
  final bool success;

  /// 导入的节点数量
  @override
  @JsonKey()
  final int importedNodes;

  /// 有效节点数量
  @override
  @JsonKey()
  final int validNodes;

  /// 无效节点数量
  @override
  @JsonKey()
  final int invalidNodes;

  /// 重复节点数量
  @override
  @JsonKey()
  final int duplicateNodes;

  /// 错误信息列表
  final List<String> _errors;

  /// 错误信息列表
  @override
  @JsonKey()
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  /// 导入的节点列表
  final List<ProxyNode> _nodes;

  /// 导入的节点列表
  @override
  @JsonKey()
  List<ProxyNode> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  /// 导入统计信息
  @override
  @JsonKey()
  final NodeImportStats importStats;

  @override
  String toString() {
    return 'NodeImportResult(success: $success, importedNodes: $importedNodes, validNodes: $validNodes, invalidNodes: $invalidNodes, duplicateNodes: $duplicateNodes, errors: $errors, nodes: $nodes, importStats: $importStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeImportResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.importedNodes, importedNodes) ||
                other.importedNodes == importedNodes) &&
            (identical(other.validNodes, validNodes) ||
                other.validNodes == validNodes) &&
            (identical(other.invalidNodes, invalidNodes) ||
                other.invalidNodes == invalidNodes) &&
            (identical(other.duplicateNodes, duplicateNodes) ||
                other.duplicateNodes == duplicateNodes) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            (identical(other.importStats, importStats) ||
                other.importStats == importStats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      importedNodes,
      validNodes,
      invalidNodes,
      duplicateNodes,
      const DeepCollectionEquality().hash(_errors),
      const DeepCollectionEquality().hash(_nodes),
      importStats);

  /// Create a copy of NodeImportResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeImportResultImplCopyWith<_$NodeImportResultImpl> get copyWith =>
      __$$NodeImportResultImplCopyWithImpl<_$NodeImportResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NodeImportResultImplToJson(
      this,
    );
  }
}

abstract class _NodeImportResult implements NodeImportResult {
  const factory _NodeImportResult(
      {required final bool success,
      final int importedNodes,
      final int validNodes,
      final int invalidNodes,
      final int duplicateNodes,
      final List<String> errors,
      final List<ProxyNode> nodes,
      final NodeImportStats importStats}) = _$NodeImportResultImpl;

  factory _NodeImportResult.fromJson(Map<String, dynamic> json) =
      _$NodeImportResultImpl.fromJson;

  /// 是否成功
  @override
  bool get success;

  /// 导入的节点数量
  @override
  int get importedNodes;

  /// 有效节点数量
  @override
  int get validNodes;

  /// 无效节点数量
  @override
  int get invalidNodes;

  /// 重复节点数量
  @override
  int get duplicateNodes;

  /// 错误信息列表
  @override
  List<String> get errors;

  /// 导入的节点列表
  @override
  List<ProxyNode> get nodes;

  /// 导入统计信息
  @override
  NodeImportStats get importStats;

  /// Create a copy of NodeImportResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NodeImportResultImplCopyWith<_$NodeImportResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NodeImportStats _$NodeImportStatsFromJson(Map<String, dynamic> json) {
  return _NodeImportStats.fromJson(json);
}

/// @nodoc
mixin _$NodeImportStats {
  /// VMess 节点数量
  int get vmessCount => throw _privateConstructorUsedError;

  /// VLESS 节点数量
  int get vlessCount => throw _privateConstructorUsedError;

  /// SS 节点数量
  int get ssCount => throw _privateConstructorUsedError;

  /// SSR 节点数量
  int get ssrCount => throw _privateConstructorUsedError;

  /// Trojan 节点数量
  int get trojanCount => throw _privateConstructorUsedError;

  /// 解析错误数量
  int get parseErrors => throw _privateConstructorUsedError;

  /// 总导入时间（毫秒）
  int get totalTimeMs => throw _privateConstructorUsedError;

  /// Serializes this NodeImportStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NodeImportStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NodeImportStatsCopyWith<NodeImportStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeImportStatsCopyWith<$Res> {
  factory $NodeImportStatsCopyWith(
          NodeImportStats value, $Res Function(NodeImportStats) then) =
      _$NodeImportStatsCopyWithImpl<$Res, NodeImportStats>;
  @useResult
  $Res call(
      {int vmessCount,
      int vlessCount,
      int ssCount,
      int ssrCount,
      int trojanCount,
      int parseErrors,
      int totalTimeMs});
}

/// @nodoc
class _$NodeImportStatsCopyWithImpl<$Res, $Val extends NodeImportStats>
    implements $NodeImportStatsCopyWith<$Res> {
  _$NodeImportStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NodeImportStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vmessCount = null,
    Object? vlessCount = null,
    Object? ssCount = null,
    Object? ssrCount = null,
    Object? trojanCount = null,
    Object? parseErrors = null,
    Object? totalTimeMs = null,
  }) {
    return _then(_value.copyWith(
      vmessCount: null == vmessCount
          ? _value.vmessCount
          : vmessCount // ignore: cast_nullable_to_non_nullable
              as int,
      vlessCount: null == vlessCount
          ? _value.vlessCount
          : vlessCount // ignore: cast_nullable_to_non_nullable
              as int,
      ssCount: null == ssCount
          ? _value.ssCount
          : ssCount // ignore: cast_nullable_to_non_nullable
              as int,
      ssrCount: null == ssrCount
          ? _value.ssrCount
          : ssrCount // ignore: cast_nullable_to_non_nullable
              as int,
      trojanCount: null == trojanCount
          ? _value.trojanCount
          : trojanCount // ignore: cast_nullable_to_non_nullable
              as int,
      parseErrors: null == parseErrors
          ? _value.parseErrors
          : parseErrors // ignore: cast_nullable_to_non_nullable
              as int,
      totalTimeMs: null == totalTimeMs
          ? _value.totalTimeMs
          : totalTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NodeImportStatsImplCopyWith<$Res>
    implements $NodeImportStatsCopyWith<$Res> {
  factory _$$NodeImportStatsImplCopyWith(_$NodeImportStatsImpl value,
          $Res Function(_$NodeImportStatsImpl) then) =
      __$$NodeImportStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int vmessCount,
      int vlessCount,
      int ssCount,
      int ssrCount,
      int trojanCount,
      int parseErrors,
      int totalTimeMs});
}

/// @nodoc
class __$$NodeImportStatsImplCopyWithImpl<$Res>
    extends _$NodeImportStatsCopyWithImpl<$Res, _$NodeImportStatsImpl>
    implements _$$NodeImportStatsImplCopyWith<$Res> {
  __$$NodeImportStatsImplCopyWithImpl(
      _$NodeImportStatsImpl _value, $Res Function(_$NodeImportStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of NodeImportStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vmessCount = null,
    Object? vlessCount = null,
    Object? ssCount = null,
    Object? ssrCount = null,
    Object? trojanCount = null,
    Object? parseErrors = null,
    Object? totalTimeMs = null,
  }) {
    return _then(_$NodeImportStatsImpl(
      vmessCount: null == vmessCount
          ? _value.vmessCount
          : vmessCount // ignore: cast_nullable_to_non_nullable
              as int,
      vlessCount: null == vlessCount
          ? _value.vlessCount
          : vlessCount // ignore: cast_nullable_to_non_nullable
              as int,
      ssCount: null == ssCount
          ? _value.ssCount
          : ssCount // ignore: cast_nullable_to_non_nullable
              as int,
      ssrCount: null == ssrCount
          ? _value.ssrCount
          : ssrCount // ignore: cast_nullable_to_non_nullable
              as int,
      trojanCount: null == trojanCount
          ? _value.trojanCount
          : trojanCount // ignore: cast_nullable_to_non_nullable
              as int,
      parseErrors: null == parseErrors
          ? _value.parseErrors
          : parseErrors // ignore: cast_nullable_to_non_nullable
              as int,
      totalTimeMs: null == totalTimeMs
          ? _value.totalTimeMs
          : totalTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NodeImportStatsImpl implements _NodeImportStats {
  const _$NodeImportStatsImpl(
      {this.vmessCount = 0,
      this.vlessCount = 0,
      this.ssCount = 0,
      this.ssrCount = 0,
      this.trojanCount = 0,
      this.parseErrors = 0,
      this.totalTimeMs = 0});

  factory _$NodeImportStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NodeImportStatsImplFromJson(json);

  /// VMess 节点数量
  @override
  @JsonKey()
  final int vmessCount;

  /// VLESS 节点数量
  @override
  @JsonKey()
  final int vlessCount;

  /// SS 节点数量
  @override
  @JsonKey()
  final int ssCount;

  /// SSR 节点数量
  @override
  @JsonKey()
  final int ssrCount;

  /// Trojan 节点数量
  @override
  @JsonKey()
  final int trojanCount;

  /// 解析错误数量
  @override
  @JsonKey()
  final int parseErrors;

  /// 总导入时间（毫秒）
  @override
  @JsonKey()
  final int totalTimeMs;

  @override
  String toString() {
    return 'NodeImportStats(vmessCount: $vmessCount, vlessCount: $vlessCount, ssCount: $ssCount, ssrCount: $ssrCount, trojanCount: $trojanCount, parseErrors: $parseErrors, totalTimeMs: $totalTimeMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeImportStatsImpl &&
            (identical(other.vmessCount, vmessCount) ||
                other.vmessCount == vmessCount) &&
            (identical(other.vlessCount, vlessCount) ||
                other.vlessCount == vlessCount) &&
            (identical(other.ssCount, ssCount) || other.ssCount == ssCount) &&
            (identical(other.ssrCount, ssrCount) ||
                other.ssrCount == ssrCount) &&
            (identical(other.trojanCount, trojanCount) ||
                other.trojanCount == trojanCount) &&
            (identical(other.parseErrors, parseErrors) ||
                other.parseErrors == parseErrors) &&
            (identical(other.totalTimeMs, totalTimeMs) ||
                other.totalTimeMs == totalTimeMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vmessCount, vlessCount, ssCount,
      ssrCount, trojanCount, parseErrors, totalTimeMs);

  /// Create a copy of NodeImportStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeImportStatsImplCopyWith<_$NodeImportStatsImpl> get copyWith =>
      __$$NodeImportStatsImplCopyWithImpl<_$NodeImportStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NodeImportStatsImplToJson(
      this,
    );
  }
}

abstract class _NodeImportStats implements NodeImportStats {
  const factory _NodeImportStats(
      {final int vmessCount,
      final int vlessCount,
      final int ssCount,
      final int ssrCount,
      final int trojanCount,
      final int parseErrors,
      final int totalTimeMs}) = _$NodeImportStatsImpl;

  factory _NodeImportStats.fromJson(Map<String, dynamic> json) =
      _$NodeImportStatsImpl.fromJson;

  /// VMess 节点数量
  @override
  int get vmessCount;

  /// VLESS 节点数量
  @override
  int get vlessCount;

  /// SS 节点数量
  @override
  int get ssCount;

  /// SSR 节点数量
  @override
  int get ssrCount;

  /// Trojan 节点数量
  @override
  int get trojanCount;

  /// 解析错误数量
  @override
  int get parseErrors;

  /// 总导入时间（毫秒）
  @override
  int get totalTimeMs;

  /// Create a copy of NodeImportStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NodeImportStatsImplCopyWith<_$NodeImportStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
