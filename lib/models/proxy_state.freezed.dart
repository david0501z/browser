// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proxy_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProxyServer _$ProxyServerFromJson(Map<String, dynamic> json) {
  return _ProxyServer.fromJson(json);
}

/// @nodoc
mixin _$ProxyServer {
  /// 服务器ID
  String get id => throw _privateConstructorUsedError;

  /// 服务器名称
  String get name => throw _privateConstructorUsedError;

  /// 服务器地址
  String get server => throw _privateConstructorUsedError;

  /// 服务器端口
  int get port => throw _privateConstructorUsedError;

  /// 用户名
  String? get username => throw _privateConstructorUsedError;

  /// 密码
  String? get password => throw _privateConstructorUsedError;

  /// 协议类型 (HTTP, HTTPS, SOCKS5)
  ProxyProtocol get protocol => throw _privateConstructorUsedError;

  /// 是否启用
  bool get enabled => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 最后使用时间
  DateTime? get lastUsedAt => throw _privateConstructorUsedError;

  /// 连接延迟 (毫秒)
  int? get latency => throw _privateConstructorUsedError;

  /// Serializes this ProxyServer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProxyServer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProxyServerCopyWith<ProxyServer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProxyServerCopyWith<$Res> {
  factory $ProxyServerCopyWith(
          ProxyServer value, $Res Function(ProxyServer) then) =
      _$ProxyServerCopyWithImpl<$Res, ProxyServer>;
  @useResult
  $Res call(
      {String id,
      String name,
      String server,
      int port,
      String? username,
      String? password,
      ProxyProtocol protocol,
      bool enabled,
      DateTime createdAt,
      DateTime? lastUsedAt,
      int? latency});
}

/// @nodoc
class _$ProxyServerCopyWithImpl<$Res, $Val extends ProxyServer>
    implements $ProxyServerCopyWith<$Res> {
  _$ProxyServerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProxyServer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? server = null,
    Object? port = null,
    Object? username = freezed,
    Object? password = freezed,
    Object? protocol = null,
    Object? enabled = null,
    Object? createdAt = null,
    Object? lastUsedAt = freezed,
    Object? latency = freezed,
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
      server: null == server
          ? _value.server
          : server // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      protocol: null == protocol
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as ProxyProtocol,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUsedAt: freezed == lastUsedAt
          ? _value.lastUsedAt
          : lastUsedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      latency: freezed == latency
          ? _value.latency
          : latency // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProxyServerImplCopyWith<$Res>
    implements $ProxyServerCopyWith<$Res> {
  factory _$$ProxyServerImplCopyWith(
          _$ProxyServerImpl value, $Res Function(_$ProxyServerImpl) then) =
      __$$ProxyServerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String server,
      int port,
      String? username,
      String? password,
      ProxyProtocol protocol,
      bool enabled,
      DateTime createdAt,
      DateTime? lastUsedAt,
      int? latency});
}

/// @nodoc
class __$$ProxyServerImplCopyWithImpl<$Res>
    extends _$ProxyServerCopyWithImpl<$Res, _$ProxyServerImpl>
    implements _$$ProxyServerImplCopyWith<$Res> {
  __$$ProxyServerImplCopyWithImpl(
      _$ProxyServerImpl _value, $Res Function(_$ProxyServerImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProxyServer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? server = null,
    Object? port = null,
    Object? username = freezed,
    Object? password = freezed,
    Object? protocol = null,
    Object? enabled = null,
    Object? createdAt = null,
    Object? lastUsedAt = freezed,
    Object? latency = freezed,
  }) {
    return _then(_$ProxyServerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      server: null == server
          ? _value.server
          : server // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      protocol: null == protocol
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as ProxyProtocol,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUsedAt: freezed == lastUsedAt
          ? _value.lastUsedAt
          : lastUsedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      latency: freezed == latency
          ? _value.latency
          : latency // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProxyServerImpl implements _ProxyServer {
  const _$ProxyServerImpl(
      {required this.id,
      required this.name,
      required this.server,
      required this.port,
      this.username,
      this.password,
      required this.protocol,
      required this.enabled,
      required this.createdAt,
      this.lastUsedAt,
      this.latency});

  factory _$ProxyServerImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProxyServerImplFromJson(json);

  /// 服务器ID
  @override
  final String id;

  /// 服务器名称
  @override
  final String name;

  /// 服务器地址
  @override
  final String server;

  /// 服务器端口
  @override
  final int port;

  /// 用户名
  @override
  final String? username;

  /// 密码
  @override
  final String? password;

  /// 协议类型 (HTTP, HTTPS, SOCKS5)
  @override
  final ProxyProtocol protocol;

  /// 是否启用
  @override
  final bool enabled;

  /// 创建时间
  @override
  final DateTime createdAt;

  /// 最后使用时间
  @override
  final DateTime? lastUsedAt;

  /// 连接延迟 (毫秒)
  @override
  final int? latency;

  @override
  String toString() {
    return 'ProxyServer(id: $id, name: $name, server: $server, port: $port, username: $username, password: $password, protocol: $protocol, enabled: $enabled, createdAt: $createdAt, lastUsedAt: $lastUsedAt, latency: $latency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProxyServerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.server, server) || other.server == server) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.protocol, protocol) ||
                other.protocol == protocol) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastUsedAt, lastUsedAt) ||
                other.lastUsedAt == lastUsedAt) &&
            (identical(other.latency, latency) || other.latency == latency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, server, port, username,
      password, protocol, enabled, createdAt, lastUsedAt, latency);

  /// Create a copy of ProxyServer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProxyServerImplCopyWith<_$ProxyServerImpl> get copyWith =>
      __$$ProxyServerImplCopyWithImpl<_$ProxyServerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProxyServerImplToJson(
      this,
    );
  }
}

abstract class _ProxyServer implements ProxyServer {
  const factory _ProxyServer(
      {required final String id,
      required final String name,
      required final String server,
      required final int port,
      final String? username,
      final String? password,
      required final ProxyProtocol protocol,
      required final bool enabled,
      required final DateTime createdAt,
      final DateTime? lastUsedAt,
      final int? latency}) = _$ProxyServerImpl;

  factory _ProxyServer.fromJson(Map<String, dynamic> json) =
      _$ProxyServerImpl.fromJson;

  /// 服务器ID
  @override
  String get id;

  /// 服务器名称
  @override
  String get name;

  /// 服务器地址
  @override
  String get server;

  /// 服务器端口
  @override
  int get port;

  /// 用户名
  @override
  String? get username;

  /// 密码
  @override
  String? get password;

  /// 协议类型 (HTTP, HTTPS, SOCKS5)
  @override
  ProxyProtocol get protocol;

  /// 是否启用
  @override
  bool get enabled;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// 最后使用时间
  @override
  DateTime? get lastUsedAt;

  /// 连接延迟 (毫秒)
  @override
  int? get latency;

  /// Create a copy of ProxyServer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProxyServerImplCopyWith<_$ProxyServerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProxyConnectionState _$ProxyConnectionStateFromJson(Map<String, dynamic> json) {
  return _ProxyConnectionState.fromJson(json);
}

/// @nodoc
mixin _$ProxyConnectionState {
  /// 是否已连接
  bool get isConnected => throw _privateConstructorUsedError;

  /// 当前使用的代理服务器ID
  String? get currentServerId => throw _privateConstructorUsedError;

  /// 连接时间
  DateTime? get connectedAt => throw _privateConstructorUsedError;

  /// 断连时间
  DateTime? get disconnectedAt => throw _privateConstructorUsedError;

  /// 连接错误信息
  String? get errorMessage => throw _privateConstructorUsedError;

  /// 上传流量 (字节)
  int get uploadBytes => throw _privateConstructorUsedError;

  /// 下载流量 (字节)
  int get downloadBytes => throw _privateConstructorUsedError;

  /// 上传速度 (字节/秒)
  int get uploadSpeed => throw _privateConstructorUsedError;

  /// 下载速度 (字节/秒)
  int get downloadSpeed => throw _privateConstructorUsedError;

  /// Serializes this ProxyConnectionState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProxyConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProxyConnectionStateCopyWith<ProxyConnectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProxyConnectionStateCopyWith<$Res> {
  factory $ProxyConnectionStateCopyWith(ProxyConnectionState value,
          $Res Function(ProxyConnectionState) then) =
      _$ProxyConnectionStateCopyWithImpl<$Res, ProxyConnectionState>;
  @useResult
  $Res call(
      {bool isConnected,
      String? currentServerId,
      DateTime? connectedAt,
      DateTime? disconnectedAt,
      String? errorMessage,
      int uploadBytes,
      int downloadBytes,
      int uploadSpeed,
      int downloadSpeed});
}

/// @nodoc
class _$ProxyConnectionStateCopyWithImpl<$Res,
        $Val extends ProxyConnectionState>
    implements $ProxyConnectionStateCopyWith<$Res> {
  _$ProxyConnectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProxyConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isConnected = null,
    Object? currentServerId = freezed,
    Object? connectedAt = freezed,
    Object? disconnectedAt = freezed,
    Object? errorMessage = freezed,
    Object? uploadBytes = null,
    Object? downloadBytes = null,
    Object? uploadSpeed = null,
    Object? downloadSpeed = null,
  }) {
    return _then(_value.copyWith(
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      currentServerId: freezed == currentServerId
          ? _value.currentServerId
          : currentServerId // ignore: cast_nullable_to_non_nullable
              as String?,
      connectedAt: freezed == connectedAt
          ? _value.connectedAt
          : connectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      disconnectedAt: freezed == disconnectedAt
          ? _value.disconnectedAt
          : disconnectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadBytes: null == uploadBytes
          ? _value.uploadBytes
          : uploadBytes // ignore: cast_nullable_to_non_nullable
              as int,
      downloadBytes: null == downloadBytes
          ? _value.downloadBytes
          : downloadBytes // ignore: cast_nullable_to_non_nullable
              as int,
      uploadSpeed: null == uploadSpeed
          ? _value.uploadSpeed
          : uploadSpeed // ignore: cast_nullable_to_non_nullable
              as int,
      downloadSpeed: null == downloadSpeed
          ? _value.downloadSpeed
          : downloadSpeed // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProxyConnectionStateImplCopyWith<$Res>
    implements $ProxyConnectionStateCopyWith<$Res> {
  factory _$$ProxyConnectionStateImplCopyWith(_$ProxyConnectionStateImpl value,
          $Res Function(_$ProxyConnectionStateImpl) then) =
      __$$ProxyConnectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isConnected,
      String? currentServerId,
      DateTime? connectedAt,
      DateTime? disconnectedAt,
      String? errorMessage,
      int uploadBytes,
      int downloadBytes,
      int uploadSpeed,
      int downloadSpeed});
}

/// @nodoc
class __$$ProxyConnectionStateImplCopyWithImpl<$Res>
    extends _$ProxyConnectionStateCopyWithImpl<$Res, _$ProxyConnectionStateImpl>
    implements _$$ProxyConnectionStateImplCopyWith<$Res> {
  __$$ProxyConnectionStateImplCopyWithImpl(_$ProxyConnectionStateImpl _value,
      $Res Function(_$ProxyConnectionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProxyConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isConnected = null,
    Object? currentServerId = freezed,
    Object? connectedAt = freezed,
    Object? disconnectedAt = freezed,
    Object? errorMessage = freezed,
    Object? uploadBytes = null,
    Object? downloadBytes = null,
    Object? uploadSpeed = null,
    Object? downloadSpeed = null,
  }) {
    return _then(_$ProxyConnectionStateImpl(
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      currentServerId: freezed == currentServerId
          ? _value.currentServerId
          : currentServerId // ignore: cast_nullable_to_non_nullable
              as String?,
      connectedAt: freezed == connectedAt
          ? _value.connectedAt
          : connectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      disconnectedAt: freezed == disconnectedAt
          ? _value.disconnectedAt
          : disconnectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadBytes: null == uploadBytes
          ? _value.uploadBytes
          : uploadBytes // ignore: cast_nullable_to_non_nullable
              as int,
      downloadBytes: null == downloadBytes
          ? _value.downloadBytes
          : downloadBytes // ignore: cast_nullable_to_non_nullable
              as int,
      uploadSpeed: null == uploadSpeed
          ? _value.uploadSpeed
          : uploadSpeed // ignore: cast_nullable_to_non_nullable
              as int,
      downloadSpeed: null == downloadSpeed
          ? _value.downloadSpeed
          : downloadSpeed // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProxyConnectionStateImpl implements _ProxyConnectionState {
  const _$ProxyConnectionStateImpl(
      {required this.isConnected,
      this.currentServerId,
      this.connectedAt,
      this.disconnectedAt,
      this.errorMessage,
      required this.uploadBytes,
      required this.downloadBytes,
      required this.uploadSpeed,
      required this.downloadSpeed});

  factory _$ProxyConnectionStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProxyConnectionStateImplFromJson(json);

  /// 是否已连接
  @override
  final bool isConnected;

  /// 当前使用的代理服务器ID
  @override
  final String? currentServerId;

  /// 连接时间
  @override
  final DateTime? connectedAt;

  /// 断连时间
  @override
  final DateTime? disconnectedAt;

  /// 连接错误信息
  @override
  final String? errorMessage;

  /// 上传流量 (字节)
  @override
  final int uploadBytes;

  /// 下载流量 (字节)
  @override
  final int downloadBytes;

  /// 上传速度 (字节/秒)
  @override
  final int uploadSpeed;

  /// 下载速度 (字节/秒)
  @override
  final int downloadSpeed;

  @override
  String toString() {
    return 'ProxyConnectionState(isConnected: $isConnected, currentServerId: $currentServerId, connectedAt: $connectedAt, disconnectedAt: $disconnectedAt, errorMessage: $errorMessage, uploadBytes: $uploadBytes, downloadBytes: $downloadBytes, uploadSpeed: $uploadSpeed, downloadSpeed: $downloadSpeed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProxyConnectionStateImpl &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.currentServerId, currentServerId) ||
                other.currentServerId == currentServerId) &&
            (identical(other.connectedAt, connectedAt) ||
                other.connectedAt == connectedAt) &&
            (identical(other.disconnectedAt, disconnectedAt) ||
                other.disconnectedAt == disconnectedAt) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.uploadBytes, uploadBytes) ||
                other.uploadBytes == uploadBytes) &&
            (identical(other.downloadBytes, downloadBytes) ||
                other.downloadBytes == downloadBytes) &&
            (identical(other.uploadSpeed, uploadSpeed) ||
                other.uploadSpeed == uploadSpeed) &&
            (identical(other.downloadSpeed, downloadSpeed) ||
                other.downloadSpeed == downloadSpeed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isConnected,
      currentServerId,
      connectedAt,
      disconnectedAt,
      errorMessage,
      uploadBytes,
      downloadBytes,
      uploadSpeed,
      downloadSpeed);

  /// Create a copy of ProxyConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProxyConnectionStateImplCopyWith<_$ProxyConnectionStateImpl>
      get copyWith =>
          __$$ProxyConnectionStateImplCopyWithImpl<_$ProxyConnectionStateImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProxyConnectionStateImplToJson(
      this,
    );
  }
}

abstract class _ProxyConnectionState implements ProxyConnectionState {
  const factory _ProxyConnectionState(
      {required final bool isConnected,
      final String? currentServerId,
      final DateTime? connectedAt,
      final DateTime? disconnectedAt,
      final String? errorMessage,
      required final int uploadBytes,
      required final int downloadBytes,
      required final int uploadSpeed,
      required final int downloadSpeed}) = _$ProxyConnectionStateImpl;

  factory _ProxyConnectionState.fromJson(Map<String, dynamic> json) =
      _$ProxyConnectionStateImpl.fromJson;

  /// 是否已连接
  @override
  bool get isConnected;

  /// 当前使用的代理服务器ID
  @override
  String? get currentServerId;

  /// 连接时间
  @override
  DateTime? get connectedAt;

  /// 断连时间
  @override
  DateTime? get disconnectedAt;

  /// 连接错误信息
  @override
  String? get errorMessage;

  /// 上传流量 (字节)
  @override
  int get uploadBytes;

  /// 下载流量 (字节)
  @override
  int get downloadBytes;

  /// 上传速度 (字节/秒)
  @override
  int get uploadSpeed;

  /// 下载速度 (字节/秒)
  @override
  int get downloadSpeed;

  /// Create a copy of ProxyConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProxyConnectionStateImplCopyWith<_$ProxyConnectionStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProxyRule _$ProxyRuleFromJson(Map<String, dynamic> json) {
  return _ProxyRule.fromJson(json);
}

/// @nodoc
mixin _$ProxyRule {
  /// 规则ID
  String get id => throw _privateConstructorUsedError;

  /// 规则名称
  String get name => throw _privateConstructorUsedError;

  /// 匹配模式 (域名、IP、正则表达式)
  String get pattern => throw _privateConstructorUsedError;

  /// 规则类型
  ProxyRuleType get type => throw _privateConstructorUsedError;

  /// 匹配的代理服务器ID
  String get proxyServerId => throw _privateConstructorUsedError;

  /// 是否启用
  bool get enabled => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ProxyRule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProxyRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProxyRuleCopyWith<ProxyRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProxyRuleCopyWith<$Res> {
  factory $ProxyRuleCopyWith(ProxyRule value, $Res Function(ProxyRule) then) =
      _$ProxyRuleCopyWithImpl<$Res, ProxyRule>;
  @useResult
  $Res call(
      {String id,
      String name,
      String pattern,
      ProxyRuleType type,
      String proxyServerId,
      bool enabled,
      DateTime createdAt});
}

/// @nodoc
class _$ProxyRuleCopyWithImpl<$Res, $Val extends ProxyRule>
    implements $ProxyRuleCopyWith<$Res> {
  _$ProxyRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProxyRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? pattern = null,
    Object? type = null,
    Object? proxyServerId = null,
    Object? enabled = null,
    Object? createdAt = null,
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
      pattern: null == pattern
          ? _value.pattern
          : pattern // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ProxyRuleType,
      proxyServerId: null == proxyServerId
          ? _value.proxyServerId
          : proxyServerId // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProxyRuleImplCopyWith<$Res>
    implements $ProxyRuleCopyWith<$Res> {
  factory _$$ProxyRuleImplCopyWith(
          _$ProxyRuleImpl value, $Res Function(_$ProxyRuleImpl) then) =
      __$$ProxyRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String pattern,
      ProxyRuleType type,
      String proxyServerId,
      bool enabled,
      DateTime createdAt});
}

/// @nodoc
class __$$ProxyRuleImplCopyWithImpl<$Res>
    extends _$ProxyRuleCopyWithImpl<$Res, _$ProxyRuleImpl>
    implements _$$ProxyRuleImplCopyWith<$Res> {
  __$$ProxyRuleImplCopyWithImpl(
      _$ProxyRuleImpl _value, $Res Function(_$ProxyRuleImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProxyRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? pattern = null,
    Object? type = null,
    Object? proxyServerId = null,
    Object? enabled = null,
    Object? createdAt = null,
  }) {
    return _then(_$ProxyRuleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      pattern: null == pattern
          ? _value.pattern
          : pattern // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ProxyRuleType,
      proxyServerId: null == proxyServerId
          ? _value.proxyServerId
          : proxyServerId // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProxyRuleImpl implements _ProxyRule {
  const _$ProxyRuleImpl(
      {required this.id,
      required this.name,
      required this.pattern,
      required this.type,
      required this.proxyServerId,
      required this.enabled,
      required this.createdAt});

  factory _$ProxyRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProxyRuleImplFromJson(json);

  /// 规则ID
  @override
  final String id;

  /// 规则名称
  @override
  final String name;

  /// 匹配模式 (域名、IP、正则表达式)
  @override
  final String pattern;

  /// 规则类型
  @override
  final ProxyRuleType type;

  /// 匹配的代理服务器ID
  @override
  final String proxyServerId;

  /// 是否启用
  @override
  final bool enabled;

  /// 创建时间
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ProxyRule(id: $id, name: $name, pattern: $pattern, type: $type, proxyServerId: $proxyServerId, enabled: $enabled, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProxyRuleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.pattern, pattern) || other.pattern == pattern) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.proxyServerId, proxyServerId) ||
                other.proxyServerId == proxyServerId) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, pattern, type, proxyServerId, enabled, createdAt);

  /// Create a copy of ProxyRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProxyRuleImplCopyWith<_$ProxyRuleImpl> get copyWith =>
      __$$ProxyRuleImplCopyWithImpl<_$ProxyRuleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProxyRuleImplToJson(
      this,
    );
  }
}

abstract class _ProxyRule implements ProxyRule {
  const factory _ProxyRule(
      {required final String id,
      required final String name,
      required final String pattern,
      required final ProxyRuleType type,
      required final String proxyServerId,
      required final bool enabled,
      required final DateTime createdAt}) = _$ProxyRuleImpl;

  factory _ProxyRule.fromJson(Map<String, dynamic> json) =
      _$ProxyRuleImpl.fromJson;

  /// 规则ID
  @override
  String get id;

  /// 规则名称
  @override
  String get name;

  /// 匹配模式 (域名、IP、正则表达式)
  @override
  String get pattern;

  /// 规则类型
  @override
  ProxyRuleType get type;

  /// 匹配的代理服务器ID
  @override
  String get proxyServerId;

  /// 是否启用
  @override
  bool get enabled;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// Create a copy of ProxyRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProxyRuleImplCopyWith<_$ProxyRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GlobalProxyState _$GlobalProxyStateFromJson(Map<String, dynamic> json) {
  return _GlobalProxyState.fromJson(json);
}

/// @nodoc
mixin _$GlobalProxyState {
  /// 当前代理状态
  ProxyStatus get status => throw _privateConstructorUsedError;

  /// 代理服务器列表
  List<ProxyServer> get servers => throw _privateConstructorUsedError;

  /// 当前连接状态
  ProxyConnectionState get connectionState =>
      throw _privateConstructorUsedError;

  /// 代理规则列表
  List<ProxyRule> get rules => throw _privateConstructorUsedError;

  /// 是否启用全局代理
  bool get isGlobalProxy => throw _privateConstructorUsedError;

  /// 系统代理设置
  SystemProxySettings get systemProxySettings =>
      throw _privateConstructorUsedError;

  /// 自动连接设置
  AutoConnectSettings get autoConnectSettings =>
      throw _privateConstructorUsedError;

  /// 最后更新时间
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this GlobalProxyState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GlobalProxyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GlobalProxyStateCopyWith<GlobalProxyState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalProxyStateCopyWith<$Res> {
  factory $GlobalProxyStateCopyWith(
          GlobalProxyState value, $Res Function(GlobalProxyState) then) =
      _$GlobalProxyStateCopyWithImpl<$Res, GlobalProxyState>;
  @useResult
  $Res call(
      {ProxyStatus status,
      List<ProxyServer> servers,
      ProxyConnectionState connectionState,
      List<ProxyRule> rules,
      bool isGlobalProxy,
      SystemProxySettings systemProxySettings,
      AutoConnectSettings autoConnectSettings,
      DateTime lastUpdated});

  $ProxyConnectionStateCopyWith<$Res> get connectionState;
  $SystemProxySettingsCopyWith<$Res> get systemProxySettings;
  $AutoConnectSettingsCopyWith<$Res> get autoConnectSettings;
}

/// @nodoc
class _$GlobalProxyStateCopyWithImpl<$Res, $Val extends GlobalProxyState>
    implements $GlobalProxyStateCopyWith<$Res> {
  _$GlobalProxyStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GlobalProxyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? servers = null,
    Object? connectionState = null,
    Object? rules = null,
    Object? isGlobalProxy = null,
    Object? systemProxySettings = null,
    Object? autoConnectSettings = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProxyStatus,
      servers: null == servers
          ? _value.servers
          : servers // ignore: cast_nullable_to_non_nullable
              as List<ProxyServer>,
      connectionState: null == connectionState
          ? _value.connectionState
          : connectionState // ignore: cast_nullable_to_non_nullable
              as ProxyConnectionState,
      rules: null == rules
          ? _value.rules
          : rules // ignore: cast_nullable_to_non_nullable
              as List<ProxyRule>,
      isGlobalProxy: null == isGlobalProxy
          ? _value.isGlobalProxy
          : isGlobalProxy // ignore: cast_nullable_to_non_nullable
              as bool,
      systemProxySettings: null == systemProxySettings
          ? _value.systemProxySettings
          : systemProxySettings // ignore: cast_nullable_to_non_nullable
              as SystemProxySettings,
      autoConnectSettings: null == autoConnectSettings
          ? _value.autoConnectSettings
          : autoConnectSettings // ignore: cast_nullable_to_non_nullable
              as AutoConnectSettings,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of GlobalProxyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProxyConnectionStateCopyWith<$Res> get connectionState {
    return $ProxyConnectionStateCopyWith<$Res>(_value.connectionState, (value) {
      return _then(_value.copyWith(connectionState: value) as $Val);
    });
  }

  /// Create a copy of GlobalProxyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SystemProxySettingsCopyWith<$Res> get systemProxySettings {
    return $SystemProxySettingsCopyWith<$Res>(_value.systemProxySettings,
        (value) {
      return _then(_value.copyWith(systemProxySettings: value) as $Val);
    });
  }

  /// Create a copy of GlobalProxyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AutoConnectSettingsCopyWith<$Res> get autoConnectSettings {
    return $AutoConnectSettingsCopyWith<$Res>(_value.autoConnectSettings,
        (value) {
      return _then(_value.copyWith(autoConnectSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GlobalProxyStateImplCopyWith<$Res>
    implements $GlobalProxyStateCopyWith<$Res> {
  factory _$$GlobalProxyStateImplCopyWith(_$GlobalProxyStateImpl value,
          $Res Function(_$GlobalProxyStateImpl) then) =
      __$$GlobalProxyStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ProxyStatus status,
      List<ProxyServer> servers,
      ProxyConnectionState connectionState,
      List<ProxyRule> rules,
      bool isGlobalProxy,
      SystemProxySettings systemProxySettings,
      AutoConnectSettings autoConnectSettings,
      DateTime lastUpdated});

  @override
  $ProxyConnectionStateCopyWith<$Res> get connectionState;
  @override
  $SystemProxySettingsCopyWith<$Res> get systemProxySettings;
  @override
  $AutoConnectSettingsCopyWith<$Res> get autoConnectSettings;
}

/// @nodoc
class __$$GlobalProxyStateImplCopyWithImpl<$Res>
    extends _$GlobalProxyStateCopyWithImpl<$Res, _$GlobalProxyStateImpl>
    implements _$$GlobalProxyStateImplCopyWith<$Res> {
  __$$GlobalProxyStateImplCopyWithImpl(_$GlobalProxyStateImpl _value,
      $Res Function(_$GlobalProxyStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GlobalProxyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? servers = null,
    Object? connectionState = null,
    Object? rules = null,
    Object? isGlobalProxy = null,
    Object? systemProxySettings = null,
    Object? autoConnectSettings = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$GlobalProxyStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProxyStatus,
      servers: null == servers
          ? _value._servers
          : servers // ignore: cast_nullable_to_non_nullable
              as List<ProxyServer>,
      connectionState: null == connectionState
          ? _value.connectionState
          : connectionState // ignore: cast_nullable_to_non_nullable
              as ProxyConnectionState,
      rules: null == rules
          ? _value._rules
          : rules // ignore: cast_nullable_to_non_nullable
              as List<ProxyRule>,
      isGlobalProxy: null == isGlobalProxy
          ? _value.isGlobalProxy
          : isGlobalProxy // ignore: cast_nullable_to_non_nullable
              as bool,
      systemProxySettings: null == systemProxySettings
          ? _value.systemProxySettings
          : systemProxySettings // ignore: cast_nullable_to_non_nullable
              as SystemProxySettings,
      autoConnectSettings: null == autoConnectSettings
          ? _value.autoConnectSettings
          : autoConnectSettings // ignore: cast_nullable_to_non_nullable
              as AutoConnectSettings,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GlobalProxyStateImpl implements _GlobalProxyState {
  const _$GlobalProxyStateImpl(
      {required this.status,
      required final List<ProxyServer> servers,
      required this.connectionState,
      required final List<ProxyRule> rules,
      required this.isGlobalProxy,
      required this.systemProxySettings,
      required this.autoConnectSettings,
      required this.lastUpdated})
      : _servers = servers,
        _rules = rules;

  factory _$GlobalProxyStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$GlobalProxyStateImplFromJson(json);

  /// 当前代理状态
  @override
  final ProxyStatus status;

  /// 代理服务器列表
  final List<ProxyServer> _servers;

  /// 代理服务器列表
  @override
  List<ProxyServer> get servers {
    if (_servers is EqualUnmodifiableListView) return _servers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_servers);
  }

  /// 当前连接状态
  @override
  final ProxyConnectionState connectionState;

  /// 代理规则列表
  final List<ProxyRule> _rules;

  /// 代理规则列表
  @override
  List<ProxyRule> get rules {
    if (_rules is EqualUnmodifiableListView) return _rules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rules);
  }

  /// 是否启用全局代理
  @override
  final bool isGlobalProxy;

  /// 系统代理设置
  @override
  final SystemProxySettings systemProxySettings;

  /// 自动连接设置
  @override
  final AutoConnectSettings autoConnectSettings;

  /// 最后更新时间
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'GlobalProxyState(status: $status, servers: $servers, connectionState: $connectionState, rules: $rules, isGlobalProxy: $isGlobalProxy, systemProxySettings: $systemProxySettings, autoConnectSettings: $autoConnectSettings, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlobalProxyStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._servers, _servers) &&
            (identical(other.connectionState, connectionState) ||
                other.connectionState == connectionState) &&
            const DeepCollectionEquality().equals(other._rules, _rules) &&
            (identical(other.isGlobalProxy, isGlobalProxy) ||
                other.isGlobalProxy == isGlobalProxy) &&
            (identical(other.systemProxySettings, systemProxySettings) ||
                other.systemProxySettings == systemProxySettings) &&
            (identical(other.autoConnectSettings, autoConnectSettings) ||
                other.autoConnectSettings == autoConnectSettings) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_servers),
      connectionState,
      const DeepCollectionEquality().hash(_rules),
      isGlobalProxy,
      systemProxySettings,
      autoConnectSettings,
      lastUpdated);

  /// Create a copy of GlobalProxyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GlobalProxyStateImplCopyWith<_$GlobalProxyStateImpl> get copyWith =>
      __$$GlobalProxyStateImplCopyWithImpl<_$GlobalProxyStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GlobalProxyStateImplToJson(
      this,
    );
  }
}

abstract class _GlobalProxyState implements GlobalProxyState {
  const factory _GlobalProxyState(
      {required final ProxyStatus status,
      required final List<ProxyServer> servers,
      required final ProxyConnectionState connectionState,
      required final List<ProxyRule> rules,
      required final bool isGlobalProxy,
      required final SystemProxySettings systemProxySettings,
      required final AutoConnectSettings autoConnectSettings,
      required final DateTime lastUpdated}) = _$GlobalProxyStateImpl;

  factory _GlobalProxyState.fromJson(Map<String, dynamic> json) =
      _$GlobalProxyStateImpl.fromJson;

  /// 当前代理状态
  @override
  ProxyStatus get status;

  /// 代理服务器列表
  @override
  List<ProxyServer> get servers;

  /// 当前连接状态
  @override
  ProxyConnectionState get connectionState;

  /// 代理规则列表
  @override
  List<ProxyRule> get rules;

  /// 是否启用全局代理
  @override
  bool get isGlobalProxy;

  /// 系统代理设置
  @override
  SystemProxySettings get systemProxySettings;

  /// 自动连接设置
  @override
  AutoConnectSettings get autoConnectSettings;

  /// 最后更新时间
  @override
  DateTime get lastUpdated;

  /// Create a copy of GlobalProxyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GlobalProxyStateImplCopyWith<_$GlobalProxyStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SystemProxySettings _$SystemProxySettingsFromJson(Map<String, dynamic> json) {
  return _SystemProxySettings.fromJson(json);
}

/// @nodoc
mixin _$SystemProxySettings {
  /// 是否启用系统代理
  bool get enabled => throw _privateConstructorUsedError;

  /// HTTP代理地址
  String? get httpProxy => throw _privateConstructorUsedError;

  /// HTTPS代理地址
  String? get httpsProxy => throw _privateConstructorUsedError;

  /// SOCKS代理地址
  String? get socksProxy => throw _privateConstructorUsedError;

  /// 跳过代理的地址列表
  List<String> get bypassList => throw _privateConstructorUsedError;

  /// Serializes this SystemProxySettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SystemProxySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SystemProxySettingsCopyWith<SystemProxySettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemProxySettingsCopyWith<$Res> {
  factory $SystemProxySettingsCopyWith(
          SystemProxySettings value, $Res Function(SystemProxySettings) then) =
      _$SystemProxySettingsCopyWithImpl<$Res, SystemProxySettings>;
  @useResult
  $Res call(
      {bool enabled,
      String? httpProxy,
      String? httpsProxy,
      String? socksProxy,
      List<String> bypassList});
}

/// @nodoc
class _$SystemProxySettingsCopyWithImpl<$Res, $Val extends SystemProxySettings>
    implements $SystemProxySettingsCopyWith<$Res> {
  _$SystemProxySettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SystemProxySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? httpProxy = freezed,
    Object? httpsProxy = freezed,
    Object? socksProxy = freezed,
    Object? bypassList = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      httpProxy: freezed == httpProxy
          ? _value.httpProxy
          : httpProxy // ignore: cast_nullable_to_non_nullable
              as String?,
      httpsProxy: freezed == httpsProxy
          ? _value.httpsProxy
          : httpsProxy // ignore: cast_nullable_to_non_nullable
              as String?,
      socksProxy: freezed == socksProxy
          ? _value.socksProxy
          : socksProxy // ignore: cast_nullable_to_non_nullable
              as String?,
      bypassList: null == bypassList
          ? _value.bypassList
          : bypassList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SystemProxySettingsImplCopyWith<$Res>
    implements $SystemProxySettingsCopyWith<$Res> {
  factory _$$SystemProxySettingsImplCopyWith(_$SystemProxySettingsImpl value,
          $Res Function(_$SystemProxySettingsImpl) then) =
      __$$SystemProxySettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      String? httpProxy,
      String? httpsProxy,
      String? socksProxy,
      List<String> bypassList});
}

/// @nodoc
class __$$SystemProxySettingsImplCopyWithImpl<$Res>
    extends _$SystemProxySettingsCopyWithImpl<$Res, _$SystemProxySettingsImpl>
    implements _$$SystemProxySettingsImplCopyWith<$Res> {
  __$$SystemProxySettingsImplCopyWithImpl(_$SystemProxySettingsImpl _value,
      $Res Function(_$SystemProxySettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of SystemProxySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? httpProxy = freezed,
    Object? httpsProxy = freezed,
    Object? socksProxy = freezed,
    Object? bypassList = null,
  }) {
    return _then(_$SystemProxySettingsImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      httpProxy: freezed == httpProxy
          ? _value.httpProxy
          : httpProxy // ignore: cast_nullable_to_non_nullable
              as String?,
      httpsProxy: freezed == httpsProxy
          ? _value.httpsProxy
          : httpsProxy // ignore: cast_nullable_to_non_nullable
              as String?,
      socksProxy: freezed == socksProxy
          ? _value.socksProxy
          : socksProxy // ignore: cast_nullable_to_non_nullable
              as String?,
      bypassList: null == bypassList
          ? _value._bypassList
          : bypassList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SystemProxySettingsImpl implements _SystemProxySettings {
  const _$SystemProxySettingsImpl(
      {required this.enabled,
      this.httpProxy,
      this.httpsProxy,
      this.socksProxy,
      required final List<String> bypassList})
      : _bypassList = bypassList;

  factory _$SystemProxySettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemProxySettingsImplFromJson(json);

  /// 是否启用系统代理
  @override
  final bool enabled;

  /// HTTP代理地址
  @override
  final String? httpProxy;

  /// HTTPS代理地址
  @override
  final String? httpsProxy;

  /// SOCKS代理地址
  @override
  final String? socksProxy;

  /// 跳过代理的地址列表
  final List<String> _bypassList;

  /// 跳过代理的地址列表
  @override
  List<String> get bypassList {
    if (_bypassList is EqualUnmodifiableListView) return _bypassList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bypassList);
  }

  @override
  String toString() {
    return 'SystemProxySettings(enabled: $enabled, httpProxy: $httpProxy, httpsProxy: $httpsProxy, socksProxy: $socksProxy, bypassList: $bypassList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemProxySettingsImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.httpProxy, httpProxy) ||
                other.httpProxy == httpProxy) &&
            (identical(other.httpsProxy, httpsProxy) ||
                other.httpsProxy == httpsProxy) &&
            (identical(other.socksProxy, socksProxy) ||
                other.socksProxy == socksProxy) &&
            const DeepCollectionEquality()
                .equals(other._bypassList, _bypassList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, enabled, httpProxy, httpsProxy,
      socksProxy, const DeepCollectionEquality().hash(_bypassList));

  /// Create a copy of SystemProxySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemProxySettingsImplCopyWith<_$SystemProxySettingsImpl> get copyWith =>
      __$$SystemProxySettingsImplCopyWithImpl<_$SystemProxySettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SystemProxySettingsImplToJson(
      this,
    );
  }
}

abstract class _SystemProxySettings implements SystemProxySettings {
  const factory _SystemProxySettings(
      {required final bool enabled,
      final String? httpProxy,
      final String? httpsProxy,
      final String? socksProxy,
      required final List<String> bypassList}) = _$SystemProxySettingsImpl;

  factory _SystemProxySettings.fromJson(Map<String, dynamic> json) =
      _$SystemProxySettingsImpl.fromJson;

  /// 是否启用系统代理
  @override
  bool get enabled;

  /// HTTP代理地址
  @override
  String? get httpProxy;

  /// HTTPS代理地址
  @override
  String? get httpsProxy;

  /// SOCKS代理地址
  @override
  String? get socksProxy;

  /// 跳过代理的地址列表
  @override
  List<String> get bypassList;

  /// Create a copy of SystemProxySettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SystemProxySettingsImplCopyWith<_$SystemProxySettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AutoConnectSettings _$AutoConnectSettingsFromJson(Map<String, dynamic> json) {
  return _AutoConnectSettings.fromJson(json);
}

/// @nodoc
mixin _$AutoConnectSettings {
  /// 是否启用自动连接
  bool get enabled => throw _privateConstructorUsedError;

  /// 应用启动时自动连接
  bool get autoConnectOnStartup => throw _privateConstructorUsedError;

  /// 断线时自动重连
  bool get autoReconnect => throw _privateConstructorUsedError;

  /// 重连间隔 (秒)
  int get reconnectInterval => throw _privateConstructorUsedError;

  /// 最大重连次数
  int get maxReconnectAttempts => throw _privateConstructorUsedError;

  /// Serializes this AutoConnectSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AutoConnectSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AutoConnectSettingsCopyWith<AutoConnectSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutoConnectSettingsCopyWith<$Res> {
  factory $AutoConnectSettingsCopyWith(
          AutoConnectSettings value, $Res Function(AutoConnectSettings) then) =
      _$AutoConnectSettingsCopyWithImpl<$Res, AutoConnectSettings>;
  @useResult
  $Res call(
      {bool enabled,
      bool autoConnectOnStartup,
      bool autoReconnect,
      int reconnectInterval,
      int maxReconnectAttempts});
}

/// @nodoc
class _$AutoConnectSettingsCopyWithImpl<$Res, $Val extends AutoConnectSettings>
    implements $AutoConnectSettingsCopyWith<$Res> {
  _$AutoConnectSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AutoConnectSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? autoConnectOnStartup = null,
    Object? autoReconnect = null,
    Object? reconnectInterval = null,
    Object? maxReconnectAttempts = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      autoConnectOnStartup: null == autoConnectOnStartup
          ? _value.autoConnectOnStartup
          : autoConnectOnStartup // ignore: cast_nullable_to_non_nullable
              as bool,
      autoReconnect: null == autoReconnect
          ? _value.autoReconnect
          : autoReconnect // ignore: cast_nullable_to_non_nullable
              as bool,
      reconnectInterval: null == reconnectInterval
          ? _value.reconnectInterval
          : reconnectInterval // ignore: cast_nullable_to_non_nullable
              as int,
      maxReconnectAttempts: null == maxReconnectAttempts
          ? _value.maxReconnectAttempts
          : maxReconnectAttempts // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AutoConnectSettingsImplCopyWith<$Res>
    implements $AutoConnectSettingsCopyWith<$Res> {
  factory _$$AutoConnectSettingsImplCopyWith(_$AutoConnectSettingsImpl value,
          $Res Function(_$AutoConnectSettingsImpl) then) =
      __$$AutoConnectSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      bool autoConnectOnStartup,
      bool autoReconnect,
      int reconnectInterval,
      int maxReconnectAttempts});
}

/// @nodoc
class __$$AutoConnectSettingsImplCopyWithImpl<$Res>
    extends _$AutoConnectSettingsCopyWithImpl<$Res, _$AutoConnectSettingsImpl>
    implements _$$AutoConnectSettingsImplCopyWith<$Res> {
  __$$AutoConnectSettingsImplCopyWithImpl(_$AutoConnectSettingsImpl _value,
      $Res Function(_$AutoConnectSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AutoConnectSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? autoConnectOnStartup = null,
    Object? autoReconnect = null,
    Object? reconnectInterval = null,
    Object? maxReconnectAttempts = null,
  }) {
    return _then(_$AutoConnectSettingsImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      autoConnectOnStartup: null == autoConnectOnStartup
          ? _value.autoConnectOnStartup
          : autoConnectOnStartup // ignore: cast_nullable_to_non_nullable
              as bool,
      autoReconnect: null == autoReconnect
          ? _value.autoReconnect
          : autoReconnect // ignore: cast_nullable_to_non_nullable
              as bool,
      reconnectInterval: null == reconnectInterval
          ? _value.reconnectInterval
          : reconnectInterval // ignore: cast_nullable_to_non_nullable
              as int,
      maxReconnectAttempts: null == maxReconnectAttempts
          ? _value.maxReconnectAttempts
          : maxReconnectAttempts // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AutoConnectSettingsImpl implements _AutoConnectSettings {
  const _$AutoConnectSettingsImpl(
      {required this.enabled,
      required this.autoConnectOnStartup,
      required this.autoReconnect,
      required this.reconnectInterval,
      required this.maxReconnectAttempts});

  factory _$AutoConnectSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AutoConnectSettingsImplFromJson(json);

  /// 是否启用自动连接
  @override
  final bool enabled;

  /// 应用启动时自动连接
  @override
  final bool autoConnectOnStartup;

  /// 断线时自动重连
  @override
  final bool autoReconnect;

  /// 重连间隔 (秒)
  @override
  final int reconnectInterval;

  /// 最大重连次数
  @override
  final int maxReconnectAttempts;

  @override
  String toString() {
    return 'AutoConnectSettings(enabled: $enabled, autoConnectOnStartup: $autoConnectOnStartup, autoReconnect: $autoReconnect, reconnectInterval: $reconnectInterval, maxReconnectAttempts: $maxReconnectAttempts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutoConnectSettingsImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.autoConnectOnStartup, autoConnectOnStartup) ||
                other.autoConnectOnStartup == autoConnectOnStartup) &&
            (identical(other.autoReconnect, autoReconnect) ||
                other.autoReconnect == autoReconnect) &&
            (identical(other.reconnectInterval, reconnectInterval) ||
                other.reconnectInterval == reconnectInterval) &&
            (identical(other.maxReconnectAttempts, maxReconnectAttempts) ||
                other.maxReconnectAttempts == maxReconnectAttempts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, enabled, autoConnectOnStartup,
      autoReconnect, reconnectInterval, maxReconnectAttempts);

  /// Create a copy of AutoConnectSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AutoConnectSettingsImplCopyWith<_$AutoConnectSettingsImpl> get copyWith =>
      __$$AutoConnectSettingsImplCopyWithImpl<_$AutoConnectSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AutoConnectSettingsImplToJson(
      this,
    );
  }
}

abstract class _AutoConnectSettings implements AutoConnectSettings {
  const factory _AutoConnectSettings(
      {required final bool enabled,
      required final bool autoConnectOnStartup,
      required final bool autoReconnect,
      required final int reconnectInterval,
      required final int maxReconnectAttempts}) = _$AutoConnectSettingsImpl;

  factory _AutoConnectSettings.fromJson(Map<String, dynamic> json) =
      _$AutoConnectSettingsImpl.fromJson;

  /// 是否启用自动连接
  @override
  bool get enabled;

  /// 应用启动时自动连接
  @override
  bool get autoConnectOnStartup;

  /// 断线时自动重连
  @override
  bool get autoReconnect;

  /// 重连间隔 (秒)
  @override
  int get reconnectInterval;

  /// 最大重连次数
  @override
  int get maxReconnectAttempts;

  /// Create a copy of AutoConnectSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AutoConnectSettingsImplCopyWith<_$AutoConnectSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
