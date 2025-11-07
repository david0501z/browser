// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proxy_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProxyConfig _$ProxyConfigFromJson(Map<String, dynamic> json) {
  return _ProxyConfig.fromJson(json);
}

/// @nodoc
mixin _$ProxyConfig {
  /// 基本配置
  bool get enabled => throw _privateConstructorUsedError;
  String get mode => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  String get listenAddress => throw _privateConstructorUsedError;

  /// 路由规则配置
  List<ProxyRule> get rules => throw _privateConstructorUsedError;
  bool get bypassChina => throw _privateConstructorUsedError;
  bool get bypassLAN => throw _privateConstructorUsedError;

  /// DNS配置
  String get primaryDNS => throw _privateConstructorUsedError;
  String get secondaryDNS => throw _privateConstructorUsedError;
  bool get dnsOverHttps => throw _privateConstructorUsedError;

  /// 安全配置
  bool get allowInsecure => throw _privateConstructorUsedError;
  bool get enableIPv6 => throw _privateConstructorUsedError;
  bool get enableMux => throw _privateConstructorUsedError;

  /// 连接配置
  int get connectionTimeout => throw _privateConstructorUsedError;
  int get readTimeout => throw _privateConstructorUsedError;
  int get retryCount => throw _privateConstructorUsedError;

  /// 日志配置
  bool get enableLog => throw _privateConstructorUsedError;
  String get logLevel => throw _privateConstructorUsedError;
  String get logPath => throw _privateConstructorUsedError;

  /// 流量配置
  bool get enableTrafficStats => throw _privateConstructorUsedError;
  bool get enableSpeedTest => throw _privateConstructorUsedError;

  /// 节点配置
  String get selectedNodeId => throw _privateConstructorUsedError;
  List<ProxyNode> get nodes => throw _privateConstructorUsedError;

  /// 自定义配置
  Map<String, dynamic> get customSettings => throw _privateConstructorUsedError;

  /// Serializes this ProxyConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProxyConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProxyConfigCopyWith<ProxyConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProxyConfigCopyWith<$Res> {
  factory $ProxyConfigCopyWith(
          ProxyConfig value, $Res Function(ProxyConfig) then) =
      _$ProxyConfigCopyWithImpl<$Res, ProxyConfig>;
  @useResult
  $Res call(
      {bool enabled,
      String mode,
      int port,
      String listenAddress,
      List<ProxyRule> rules,
      bool bypassChina,
      bool bypassLAN,
      String primaryDNS,
      String secondaryDNS,
      bool dnsOverHttps,
      bool allowInsecure,
      bool enableIPv6,
      bool enableMux,
      int connectionTimeout,
      int readTimeout,
      int retryCount,
      bool enableLog,
      String logLevel,
      String logPath,
      bool enableTrafficStats,
      bool enableSpeedTest,
      String selectedNodeId,
      List<ProxyNode> nodes,
      Map<String, dynamic> customSettings});
}

/// @nodoc
class _$ProxyConfigCopyWithImpl<$Res, $Val extends ProxyConfig>
    implements $ProxyConfigCopyWith<$Res> {
  _$ProxyConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProxyConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? mode = null,
    Object? port = null,
    Object? listenAddress = null,
    Object? rules = null,
    Object? bypassChina = null,
    Object? bypassLAN = null,
    Object? primaryDNS = null,
    Object? secondaryDNS = null,
    Object? dnsOverHttps = null,
    Object? allowInsecure = null,
    Object? enableIPv6 = null,
    Object? enableMux = null,
    Object? connectionTimeout = null,
    Object? readTimeout = null,
    Object? retryCount = null,
    Object? enableLog = null,
    Object? logLevel = null,
    Object? logPath = null,
    Object? enableTrafficStats = null,
    Object? enableSpeedTest = null,
    Object? selectedNodeId = null,
    Object? nodes = null,
    Object? customSettings = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      listenAddress: null == listenAddress
          ? _value.listenAddress
          : listenAddress // ignore: cast_nullable_to_non_nullable
              as String,
      rules: null == rules
          ? _value.rules
          : rules // ignore: cast_nullable_to_non_nullable
              as List<ProxyRule>,
      bypassChina: null == bypassChina
          ? _value.bypassChina
          : bypassChina // ignore: cast_nullable_to_non_nullable
              as bool,
      bypassLAN: null == bypassLAN
          ? _value.bypassLAN
          : bypassLAN // ignore: cast_nullable_to_non_nullable
              as bool,
      primaryDNS: null == primaryDNS
          ? _value.primaryDNS
          : primaryDNS // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryDNS: null == secondaryDNS
          ? _value.secondaryDNS
          : secondaryDNS // ignore: cast_nullable_to_non_nullable
              as String,
      dnsOverHttps: null == dnsOverHttps
          ? _value.dnsOverHttps
          : dnsOverHttps // ignore: cast_nullable_to_non_nullable
              as bool,
      allowInsecure: null == allowInsecure
          ? _value.allowInsecure
          : allowInsecure // ignore: cast_nullable_to_non_nullable
              as bool,
      enableIPv6: null == enableIPv6
          ? _value.enableIPv6
          : enableIPv6 // ignore: cast_nullable_to_non_nullable
              as bool,
      enableMux: null == enableMux
          ? _value.enableMux
          : enableMux // ignore: cast_nullable_to_non_nullable
              as bool,
      connectionTimeout: null == connectionTimeout
          ? _value.connectionTimeout
          : connectionTimeout // ignore: cast_nullable_to_non_nullable
              as int,
      readTimeout: null == readTimeout
          ? _value.readTimeout
          : readTimeout // ignore: cast_nullable_to_non_nullable
              as int,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      enableLog: null == enableLog
          ? _value.enableLog
          : enableLog // ignore: cast_nullable_to_non_nullable
              as bool,
      logLevel: null == logLevel
          ? _value.logLevel
          : logLevel // ignore: cast_nullable_to_non_nullable
              as String,
      logPath: null == logPath
          ? _value.logPath
          : logPath // ignore: cast_nullable_to_non_nullable
              as String,
      enableTrafficStats: null == enableTrafficStats
          ? _value.enableTrafficStats
          : enableTrafficStats // ignore: cast_nullable_to_non_nullable
              as bool,
      enableSpeedTest: null == enableSpeedTest
          ? _value.enableSpeedTest
          : enableSpeedTest // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedNodeId: null == selectedNodeId
          ? _value.selectedNodeId
          : selectedNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      nodes: null == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<ProxyNode>,
      customSettings: null == customSettings
          ? _value.customSettings
          : customSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProxyConfigImplCopyWith<$Res>
    implements $ProxyConfigCopyWith<$Res> {
  factory _$$ProxyConfigImplCopyWith(
          _$ProxyConfigImpl value, $Res Function(_$ProxyConfigImpl) then) =
      __$$ProxyConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      String mode,
      int port,
      String listenAddress,
      List<ProxyRule> rules,
      bool bypassChina,
      bool bypassLAN,
      String primaryDNS,
      String secondaryDNS,
      bool dnsOverHttps,
      bool allowInsecure,
      bool enableIPv6,
      bool enableMux,
      int connectionTimeout,
      int readTimeout,
      int retryCount,
      bool enableLog,
      String logLevel,
      String logPath,
      bool enableTrafficStats,
      bool enableSpeedTest,
      String selectedNodeId,
      List<ProxyNode> nodes,
      Map<String, dynamic> customSettings});
}

/// @nodoc
class __$$ProxyConfigImplCopyWithImpl<$Res>
    extends _$ProxyConfigCopyWithImpl<$Res, _$ProxyConfigImpl>
    implements _$$ProxyConfigImplCopyWith<$Res> {
  __$$ProxyConfigImplCopyWithImpl(
      _$ProxyConfigImpl _value, $Res Function(_$ProxyConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProxyConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? mode = null,
    Object? port = null,
    Object? listenAddress = null,
    Object? rules = null,
    Object? bypassChina = null,
    Object? bypassLAN = null,
    Object? primaryDNS = null,
    Object? secondaryDNS = null,
    Object? dnsOverHttps = null,
    Object? allowInsecure = null,
    Object? enableIPv6 = null,
    Object? enableMux = null,
    Object? connectionTimeout = null,
    Object? readTimeout = null,
    Object? retryCount = null,
    Object? enableLog = null,
    Object? logLevel = null,
    Object? logPath = null,
    Object? enableTrafficStats = null,
    Object? enableSpeedTest = null,
    Object? selectedNodeId = null,
    Object? nodes = null,
    Object? customSettings = null,
  }) {
    return _then(_$ProxyConfigImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      listenAddress: null == listenAddress
          ? _value.listenAddress
          : listenAddress // ignore: cast_nullable_to_non_nullable
              as String,
      rules: null == rules
          ? _value._rules
          : rules // ignore: cast_nullable_to_non_nullable
              as List<ProxyRule>,
      bypassChina: null == bypassChina
          ? _value.bypassChina
          : bypassChina // ignore: cast_nullable_to_non_nullable
              as bool,
      bypassLAN: null == bypassLAN
          ? _value.bypassLAN
          : bypassLAN // ignore: cast_nullable_to_non_nullable
              as bool,
      primaryDNS: null == primaryDNS
          ? _value.primaryDNS
          : primaryDNS // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryDNS: null == secondaryDNS
          ? _value.secondaryDNS
          : secondaryDNS // ignore: cast_nullable_to_non_nullable
              as String,
      dnsOverHttps: null == dnsOverHttps
          ? _value.dnsOverHttps
          : dnsOverHttps // ignore: cast_nullable_to_non_nullable
              as bool,
      allowInsecure: null == allowInsecure
          ? _value.allowInsecure
          : allowInsecure // ignore: cast_nullable_to_non_nullable
              as bool,
      enableIPv6: null == enableIPv6
          ? _value.enableIPv6
          : enableIPv6 // ignore: cast_nullable_to_non_nullable
              as bool,
      enableMux: null == enableMux
          ? _value.enableMux
          : enableMux // ignore: cast_nullable_to_non_nullable
              as bool,
      connectionTimeout: null == connectionTimeout
          ? _value.connectionTimeout
          : connectionTimeout // ignore: cast_nullable_to_non_nullable
              as int,
      readTimeout: null == readTimeout
          ? _value.readTimeout
          : readTimeout // ignore: cast_nullable_to_non_nullable
              as int,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      enableLog: null == enableLog
          ? _value.enableLog
          : enableLog // ignore: cast_nullable_to_non_nullable
              as bool,
      logLevel: null == logLevel
          ? _value.logLevel
          : logLevel // ignore: cast_nullable_to_non_nullable
              as String,
      logPath: null == logPath
          ? _value.logPath
          : logPath // ignore: cast_nullable_to_non_nullable
              as String,
      enableTrafficStats: null == enableTrafficStats
          ? _value.enableTrafficStats
          : enableTrafficStats // ignore: cast_nullable_to_non_nullable
              as bool,
      enableSpeedTest: null == enableSpeedTest
          ? _value.enableSpeedTest
          : enableSpeedTest // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedNodeId: null == selectedNodeId
          ? _value.selectedNodeId
          : selectedNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      nodes: null == nodes
          ? _value._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<ProxyNode>,
      customSettings: null == customSettings
          ? _value._customSettings
          : customSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProxyConfigImpl implements _ProxyConfig {
  const _$ProxyConfigImpl(
      {this.enabled = false,
      this.mode = 'auto',
      this.port = 7890,
      this.listenAddress = '127.0.0.1',
      final List<ProxyRule> rules = const [],
      this.bypassChina = false,
      this.bypassLAN = false,
      this.primaryDNS = '1.1.1.1',
      this.secondaryDNS = '8.8.8.8',
      this.dnsOverHttps = false,
      this.allowInsecure = false,
      this.enableIPv6 = true,
      this.enableMux = true,
      this.connectionTimeout = 30,
      this.readTimeout = 60,
      this.retryCount = 10,
      this.enableLog = false,
      this.logLevel = 'info',
      this.logPath = '/tmp/proxy.log',
      this.enableTrafficStats = true,
      this.enableSpeedTest = true,
      this.selectedNodeId = '',
      final List<ProxyNode> nodes = const [],
      final Map<String, dynamic> customSettings = const {}})
      : _rules = rules,
        _nodes = nodes,
        _customSettings = customSettings;

  factory _$ProxyConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProxyConfigImplFromJson(json);

  /// 基本配置
  @override
  @JsonKey()
  final bool enabled;
  @override
  @JsonKey()
  final String mode;
  @override
  @JsonKey()
  final int port;
  @override
  @JsonKey()
  final String listenAddress;

  /// 路由规则配置
  final List<ProxyRule> _rules;

  /// 路由规则配置
  @override
  @JsonKey()
  List<ProxyRule> get rules {
    if (_rules is EqualUnmodifiableListView) return _rules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rules);
  }

  @override
  @JsonKey()
  final bool bypassChina;
  @override
  @JsonKey()
  final bool bypassLAN;

  /// DNS配置
  @override
  @JsonKey()
  final String primaryDNS;
  @override
  @JsonKey()
  final String secondaryDNS;
  @override
  @JsonKey()
  final bool dnsOverHttps;

  /// 安全配置
  @override
  @JsonKey()
  final bool allowInsecure;
  @override
  @JsonKey()
  final bool enableIPv6;
  @override
  @JsonKey()
  final bool enableMux;

  /// 连接配置
  @override
  @JsonKey()
  final int connectionTimeout;
  @override
  @JsonKey()
  final int readTimeout;
  @override
  @JsonKey()
  final int retryCount;

  /// 日志配置
  @override
  @JsonKey()
  final bool enableLog;
  @override
  @JsonKey()
  final String logLevel;
  @override
  @JsonKey()
  final String logPath;

  /// 流量配置
  @override
  @JsonKey()
  final bool enableTrafficStats;
  @override
  @JsonKey()
  final bool enableSpeedTest;

  /// 节点配置
  @override
  @JsonKey()
  final String selectedNodeId;
  final List<ProxyNode> _nodes;
  @override
  @JsonKey()
  List<ProxyNode> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  /// 自定义配置
  final Map<String, dynamic> _customSettings;

  /// 自定义配置
  @override
  @JsonKey()
  Map<String, dynamic> get customSettings {
    if (_customSettings is EqualUnmodifiableMapView) return _customSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_customSettings);
  }

  @override
  String toString() {
    return 'ProxyConfig(enabled: $enabled, mode: $mode, port: $port, listenAddress: $listenAddress, rules: $rules, bypassChina: $bypassChina, bypassLAN: $bypassLAN, primaryDNS: $primaryDNS, secondaryDNS: $secondaryDNS, dnsOverHttps: $dnsOverHttps, allowInsecure: $allowInsecure, enableIPv6: $enableIPv6, enableMux: $enableMux, connectionTimeout: $connectionTimeout, readTimeout: $readTimeout, retryCount: $retryCount, enableLog: $enableLog, logLevel: $logLevel, logPath: $logPath, enableTrafficStats: $enableTrafficStats, enableSpeedTest: $enableSpeedTest, selectedNodeId: $selectedNodeId, nodes: $nodes, customSettings: $customSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProxyConfigImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.listenAddress, listenAddress) ||
                other.listenAddress == listenAddress) &&
            const DeepCollectionEquality().equals(other._rules, _rules) &&
            (identical(other.bypassChina, bypassChina) ||
                other.bypassChina == bypassChina) &&
            (identical(other.bypassLAN, bypassLAN) ||
                other.bypassLAN == bypassLAN) &&
            (identical(other.primaryDNS, primaryDNS) ||
                other.primaryDNS == primaryDNS) &&
            (identical(other.secondaryDNS, secondaryDNS) ||
                other.secondaryDNS == secondaryDNS) &&
            (identical(other.dnsOverHttps, dnsOverHttps) ||
                other.dnsOverHttps == dnsOverHttps) &&
            (identical(other.allowInsecure, allowInsecure) ||
                other.allowInsecure == allowInsecure) &&
            (identical(other.enableIPv6, enableIPv6) ||
                other.enableIPv6 == enableIPv6) &&
            (identical(other.enableMux, enableMux) ||
                other.enableMux == enableMux) &&
            (identical(other.connectionTimeout, connectionTimeout) ||
                other.connectionTimeout == connectionTimeout) &&
            (identical(other.readTimeout, readTimeout) ||
                other.readTimeout == readTimeout) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.enableLog, enableLog) ||
                other.enableLog == enableLog) &&
            (identical(other.logLevel, logLevel) ||
                other.logLevel == logLevel) &&
            (identical(other.logPath, logPath) || other.logPath == logPath) &&
            (identical(other.enableTrafficStats, enableTrafficStats) ||
                other.enableTrafficStats == enableTrafficStats) &&
            (identical(other.enableSpeedTest, enableSpeedTest) ||
                other.enableSpeedTest == enableSpeedTest) &&
            (identical(other.selectedNodeId, selectedNodeId) ||
                other.selectedNodeId == selectedNodeId) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            const DeepCollectionEquality()
                .equals(other._customSettings, _customSettings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        enabled,
        mode,
        port,
        listenAddress,
        const DeepCollectionEquality().hash(_rules),
        bypassChina,
        bypassLAN,
        primaryDNS,
        secondaryDNS,
        dnsOverHttps,
        allowInsecure,
        enableIPv6,
        enableMux,
        connectionTimeout,
        readTimeout,
        retryCount,
        enableLog,
        logLevel,
        logPath,
        enableTrafficStats,
        enableSpeedTest,
        selectedNodeId,
        const DeepCollectionEquality().hash(_nodes),
        const DeepCollectionEquality().hash(_customSettings)
      ]);

  /// Create a copy of ProxyConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProxyConfigImplCopyWith<_$ProxyConfigImpl> get copyWith =>
      __$$ProxyConfigImplCopyWithImpl<_$ProxyConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProxyConfigImplToJson(
      this,
    );
  }
}

abstract class _ProxyConfig implements ProxyConfig {
  const factory _ProxyConfig(
      {final bool enabled,
      final String mode,
      final int port,
      final String listenAddress,
      final List<ProxyRule> rules,
      final bool bypassChina,
      final bool bypassLAN,
      final String primaryDNS,
      final String secondaryDNS,
      final bool dnsOverHttps,
      final bool allowInsecure,
      final bool enableIPv6,
      final bool enableMux,
      final int connectionTimeout,
      final int readTimeout,
      final int retryCount,
      final bool enableLog,
      final String logLevel,
      final String logPath,
      final bool enableTrafficStats,
      final bool enableSpeedTest,
      final String selectedNodeId,
      final List<ProxyNode> nodes,
      final Map<String, dynamic> customSettings}) = _$ProxyConfigImpl;

  factory _ProxyConfig.fromJson(Map<String, dynamic> json) =
      _$ProxyConfigImpl.fromJson;

  /// 基本配置
  @override
  bool get enabled;
  @override
  String get mode;
  @override
  int get port;
  @override
  String get listenAddress;

  /// 路由规则配置
  @override
  List<ProxyRule> get rules;
  @override
  bool get bypassChina;
  @override
  bool get bypassLAN;

  /// DNS配置
  @override
  String get primaryDNS;
  @override
  String get secondaryDNS;
  @override
  bool get dnsOverHttps;

  /// 安全配置
  @override
  bool get allowInsecure;
  @override
  bool get enableIPv6;
  @override
  bool get enableMux;

  /// 连接配置
  @override
  int get connectionTimeout;
  @override
  int get readTimeout;
  @override
  int get retryCount;

  /// 日志配置
  @override
  bool get enableLog;
  @override
  String get logLevel;
  @override
  String get logPath;

  /// 流量配置
  @override
  bool get enableTrafficStats;
  @override
  bool get enableSpeedTest;

  /// 节点配置
  @override
  String get selectedNodeId;
  @override
  List<ProxyNode> get nodes;

  /// 自定义配置
  @override
  Map<String, dynamic> get customSettings;

  /// Create a copy of ProxyConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProxyConfigImplCopyWith<_$ProxyConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
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

  /// 规则类型
  ProxyRuleType get type => throw _privateConstructorUsedError;

  /// 匹配模式
  ProxyMatchType get matchType => throw _privateConstructorUsedError;

  /// 匹配内容
  String get match => throw _privateConstructorUsedError;

  /// 动作
  ProxyAction get action => throw _privateConstructorUsedError;

  /// 是否启用
  bool get enabled => throw _privateConstructorUsedError;

  /// 优先级
  int get priority => throw _privateConstructorUsedError;

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
      ProxyRuleType type,
      ProxyMatchType matchType,
      String match,
      ProxyAction action,
      bool enabled,
      int priority});
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
    Object? type = null,
    Object? matchType = null,
    Object? match = null,
    Object? action = null,
    Object? enabled = null,
    Object? priority = null,
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
              as ProxyRuleType,
      matchType: null == matchType
          ? _value.matchType
          : matchType // ignore: cast_nullable_to_non_nullable
              as ProxyMatchType,
      match: null == match
          ? _value.match
          : match // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as ProxyAction,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
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
      ProxyRuleType type,
      ProxyMatchType matchType,
      String match,
      ProxyAction action,
      bool enabled,
      int priority});
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
    Object? type = null,
    Object? matchType = null,
    Object? match = null,
    Object? action = null,
    Object? enabled = null,
    Object? priority = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ProxyRuleType,
      matchType: null == matchType
          ? _value.matchType
          : matchType // ignore: cast_nullable_to_non_nullable
              as ProxyMatchType,
      match: null == match
          ? _value.match
          : match // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as ProxyAction,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProxyRuleImpl implements _ProxyRule {
  const _$ProxyRuleImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.matchType,
      required this.match,
      required this.action,
      this.enabled = true,
      this.priority = 0});

  factory _$ProxyRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProxyRuleImplFromJson(json);

  /// 规则ID
  @override
  final String id;

  /// 规则名称
  @override
  final String name;

  /// 规则类型
  @override
  final ProxyRuleType type;

  /// 匹配模式
  @override
  final ProxyMatchType matchType;

  /// 匹配内容
  @override
  final String match;

  /// 动作
  @override
  final ProxyAction action;

  /// 是否启用
  @override
  @JsonKey()
  final bool enabled;

  /// 优先级
  @override
  @JsonKey()
  final int priority;

  @override
  String toString() {
    return 'ProxyRule(id: $id, name: $name, type: $type, matchType: $matchType, match: $match, action: $action, enabled: $enabled, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProxyRuleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.matchType, matchType) ||
                other.matchType == matchType) &&
            (identical(other.match, match) || other.match == match) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, type, matchType, match, action, enabled, priority);

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
      required final ProxyRuleType type,
      required final ProxyMatchType matchType,
      required final String match,
      required final ProxyAction action,
      final bool enabled,
      final int priority}) = _$ProxyRuleImpl;

  factory _ProxyRule.fromJson(Map<String, dynamic> json) =
      _$ProxyRuleImpl.fromJson;

  /// 规则ID
  @override
  String get id;

  /// 规则名称
  @override
  String get name;

  /// 规则类型
  @override
  ProxyRuleType get type;

  /// 匹配模式
  @override
  ProxyMatchType get matchType;

  /// 匹配内容
  @override
  String get match;

  /// 动作
  @override
  ProxyAction get action;

  /// 是否启用
  @override
  bool get enabled;

  /// 优先级
  @override
  int get priority;

  /// Create a copy of ProxyRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProxyRuleImplCopyWith<_$ProxyRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProxyNode _$ProxyNodeFromJson(Map<String, dynamic> json) {
  return _ProxyNode.fromJson(json);
}

/// @nodoc
mixin _$ProxyNode {
  /// 节点ID
  String get id => throw _privateConstructorUsedError;

  /// 节点名称
  String get name => throw _privateConstructorUsedError;

  /// 节点类型
  ProxyNodeType get type => throw _privateConstructorUsedError;

  /// 服务器地址
  String get server => throw _privateConstructorUsedError;

  /// 端口
  int get port => throw _privateConstructorUsedError;

  /// 协议
  String get protocol => throw _privateConstructorUsedError;

  /// 认证信息
  String get auth => throw _privateConstructorUsedError;

  /// 加密方式
  String get encryption => throw _privateConstructorUsedError;

  /// 代理标识
  String get proxyId => throw _privateConstructorUsedError;

  /// 节点状态
  NodeStatus get status => throw _privateConstructorUsedError;

  /// 延迟
  int get latency => throw _privateConstructorUsedError;

  /// 带宽
  int get bandwidth => throw _privateConstructorUsedError;

  /// 地区
  String get region => throw _privateConstructorUsedError;

  /// 标签
  List<String> get tags => throw _privateConstructorUsedError;

  /// 是否可用
  bool get available => throw _privateConstructorUsedError;

  /// 配置参数
  Map<String, dynamic> get config => throw _privateConstructorUsedError;

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
      ProxyNodeType type,
      String server,
      int port,
      String protocol,
      String auth,
      String encryption,
      String proxyId,
      NodeStatus status,
      int latency,
      int bandwidth,
      String region,
      List<String> tags,
      bool available,
      Map<String, dynamic> config});
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
    Object? server = null,
    Object? port = null,
    Object? protocol = null,
    Object? auth = null,
    Object? encryption = null,
    Object? proxyId = null,
    Object? status = null,
    Object? latency = null,
    Object? bandwidth = null,
    Object? region = null,
    Object? tags = null,
    Object? available = null,
    Object? config = null,
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
              as ProxyNodeType,
      server: null == server
          ? _value.server
          : server // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      protocol: null == protocol
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as String,
      auth: null == auth
          ? _value.auth
          : auth // ignore: cast_nullable_to_non_nullable
              as String,
      encryption: null == encryption
          ? _value.encryption
          : encryption // ignore: cast_nullable_to_non_nullable
              as String,
      proxyId: null == proxyId
          ? _value.proxyId
          : proxyId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as NodeStatus,
      latency: null == latency
          ? _value.latency
          : latency // ignore: cast_nullable_to_non_nullable
              as int,
      bandwidth: null == bandwidth
          ? _value.bandwidth
          : bandwidth // ignore: cast_nullable_to_non_nullable
              as int,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
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
      ProxyNodeType type,
      String server,
      int port,
      String protocol,
      String auth,
      String encryption,
      String proxyId,
      NodeStatus status,
      int latency,
      int bandwidth,
      String region,
      List<String> tags,
      bool available,
      Map<String, dynamic> config});
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
    Object? server = null,
    Object? port = null,
    Object? protocol = null,
    Object? auth = null,
    Object? encryption = null,
    Object? proxyId = null,
    Object? status = null,
    Object? latency = null,
    Object? bandwidth = null,
    Object? region = null,
    Object? tags = null,
    Object? available = null,
    Object? config = null,
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
              as ProxyNodeType,
      server: null == server
          ? _value.server
          : server // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      protocol: null == protocol
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as String,
      auth: null == auth
          ? _value.auth
          : auth // ignore: cast_nullable_to_non_nullable
              as String,
      encryption: null == encryption
          ? _value.encryption
          : encryption // ignore: cast_nullable_to_non_nullable
              as String,
      proxyId: null == proxyId
          ? _value.proxyId
          : proxyId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as NodeStatus,
      latency: null == latency
          ? _value.latency
          : latency // ignore: cast_nullable_to_non_nullable
              as int,
      bandwidth: null == bandwidth
          ? _value.bandwidth
          : bandwidth // ignore: cast_nullable_to_non_nullable
              as int,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
      config: null == config
          ? _value._config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
      required this.server,
      required this.port,
      this.protocol = 'http',
      this.auth = '',
      this.encryption = '',
      this.proxyId = '',
      this.status = NodeStatus.disconnected,
      this.latency = 0,
      this.bandwidth = 0,
      this.region = '',
      final List<String> tags = const [],
      this.available = true,
      final Map<String, dynamic> config = const {}})
      : _tags = tags,
        _config = config;

  factory _$ProxyNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProxyNodeImplFromJson(json);

  /// 节点ID
  @override
  final String id;

  /// 节点名称
  @override
  final String name;

  /// 节点类型
  @override
  final ProxyNodeType type;

  /// 服务器地址
  @override
  final String server;

  /// 端口
  @override
  final int port;

  /// 协议
  @override
  @JsonKey()
  final String protocol;

  /// 认证信息
  @override
  @JsonKey()
  final String auth;

  /// 加密方式
  @override
  @JsonKey()
  final String encryption;

  /// 代理标识
  @override
  @JsonKey()
  final String proxyId;

  /// 节点状态
  @override
  @JsonKey()
  final NodeStatus status;

  /// 延迟
  @override
  @JsonKey()
  final int latency;

  /// 带宽
  @override
  @JsonKey()
  final int bandwidth;

  /// 地区
  @override
  @JsonKey()
  final String region;

  /// 标签
  final List<String> _tags;

  /// 标签
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// 是否可用
  @override
  @JsonKey()
  final bool available;

  /// 配置参数
  final Map<String, dynamic> _config;

  /// 配置参数
  @override
  @JsonKey()
  Map<String, dynamic> get config {
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_config);
  }

  @override
  String toString() {
    return 'ProxyNode(id: $id, name: $name, type: $type, server: $server, port: $port, protocol: $protocol, auth: $auth, encryption: $encryption, proxyId: $proxyId, status: $status, latency: $latency, bandwidth: $bandwidth, region: $region, tags: $tags, available: $available, config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProxyNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.server, server) || other.server == server) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.protocol, protocol) ||
                other.protocol == protocol) &&
            (identical(other.auth, auth) || other.auth == auth) &&
            (identical(other.encryption, encryption) ||
                other.encryption == encryption) &&
            (identical(other.proxyId, proxyId) || other.proxyId == proxyId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.latency, latency) || other.latency == latency) &&
            (identical(other.bandwidth, bandwidth) ||
                other.bandwidth == bandwidth) &&
            (identical(other.region, region) || other.region == region) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.available, available) ||
                other.available == available) &&
            const DeepCollectionEquality().equals(other._config, _config));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      server,
      port,
      protocol,
      auth,
      encryption,
      proxyId,
      status,
      latency,
      bandwidth,
      region,
      const DeepCollectionEquality().hash(_tags),
      available,
      const DeepCollectionEquality().hash(_config));

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
      required final ProxyNodeType type,
      required final String server,
      required final int port,
      final String protocol,
      final String auth,
      final String encryption,
      final String proxyId,
      final NodeStatus status,
      final int latency,
      final int bandwidth,
      final String region,
      final List<String> tags,
      final bool available,
      final Map<String, dynamic> config}) = _$ProxyNodeImpl;

  factory _ProxyNode.fromJson(Map<String, dynamic> json) =
      _$ProxyNodeImpl.fromJson;

  /// 节点ID
  @override
  String get id;

  /// 节点名称
  @override
  String get name;

  /// 节点类型
  @override
  ProxyNodeType get type;

  /// 服务器地址
  @override
  String get server;

  /// 端口
  @override
  int get port;

  /// 协议
  @override
  String get protocol;

  /// 认证信息
  @override
  String get auth;

  /// 加密方式
  @override
  String get encryption;

  /// 代理标识
  @override
  String get proxyId;

  /// 节点状态
  @override
  NodeStatus get status;

  /// 延迟
  @override
  int get latency;

  /// 带宽
  @override
  int get bandwidth;

  /// 地区
  @override
  String get region;

  /// 标签
  @override
  List<String> get tags;

  /// 是否可用
  @override
  bool get available;

  /// 配置参数
  @override
  Map<String, dynamic> get config;

  /// Create a copy of ProxyNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProxyNodeImplCopyWith<_$ProxyNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrafficConfig _$TrafficConfigFromJson(Map<String, dynamic> json) {
  return _TrafficConfig.fromJson(json);
}

/// @nodoc
mixin _$TrafficConfig {
  /// 是否启用流量统计
  bool get enableStats => throw _privateConstructorUsedError;

  /// 统计间隔（秒）
  int get statsInterval => throw _privateConstructorUsedError;

  /// 是否记录历史数据
  bool get recordHistory => throw _privateConstructorUsedError;

  /// 历史数据保留天数
  int get historyRetentionDays => throw _privateConstructorUsedError;

  /// 是否启用速度限制
  bool get enableSpeedLimit => throw _privateConstructorUsedError;

  /// 上传速度限制（KB/s）
  int get uploadLimit => throw _privateConstructorUsedError;

  /// 下载速度限制（KB/s）
  int get downloadLimit => throw _privateConstructorUsedError;

  /// 是否启用流量警告
  bool get enableTrafficAlert => throw _privateConstructorUsedError;

  /// 流量警告阈值（MB）
  int get alertThreshold => throw _privateConstructorUsedError;

  /// Serializes this TrafficConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrafficConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrafficConfigCopyWith<TrafficConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrafficConfigCopyWith<$Res> {
  factory $TrafficConfigCopyWith(
          TrafficConfig value, $Res Function(TrafficConfig) then) =
      _$TrafficConfigCopyWithImpl<$Res, TrafficConfig>;
  @useResult
  $Res call(
      {bool enableStats,
      int statsInterval,
      bool recordHistory,
      int historyRetentionDays,
      bool enableSpeedLimit,
      int uploadLimit,
      int downloadLimit,
      bool enableTrafficAlert,
      int alertThreshold});
}

/// @nodoc
class _$TrafficConfigCopyWithImpl<$Res, $Val extends TrafficConfig>
    implements $TrafficConfigCopyWith<$Res> {
  _$TrafficConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrafficConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableStats = null,
    Object? statsInterval = null,
    Object? recordHistory = null,
    Object? historyRetentionDays = null,
    Object? enableSpeedLimit = null,
    Object? uploadLimit = null,
    Object? downloadLimit = null,
    Object? enableTrafficAlert = null,
    Object? alertThreshold = null,
  }) {
    return _then(_value.copyWith(
      enableStats: null == enableStats
          ? _value.enableStats
          : enableStats // ignore: cast_nullable_to_non_nullable
              as bool,
      statsInterval: null == statsInterval
          ? _value.statsInterval
          : statsInterval // ignore: cast_nullable_to_non_nullable
              as int,
      recordHistory: null == recordHistory
          ? _value.recordHistory
          : recordHistory // ignore: cast_nullable_to_non_nullable
              as bool,
      historyRetentionDays: null == historyRetentionDays
          ? _value.historyRetentionDays
          : historyRetentionDays // ignore: cast_nullable_to_non_nullable
              as int,
      enableSpeedLimit: null == enableSpeedLimit
          ? _value.enableSpeedLimit
          : enableSpeedLimit // ignore: cast_nullable_to_non_nullable
              as bool,
      uploadLimit: null == uploadLimit
          ? _value.uploadLimit
          : uploadLimit // ignore: cast_nullable_to_non_nullable
              as int,
      downloadLimit: null == downloadLimit
          ? _value.downloadLimit
          : downloadLimit // ignore: cast_nullable_to_non_nullable
              as int,
      enableTrafficAlert: null == enableTrafficAlert
          ? _value.enableTrafficAlert
          : enableTrafficAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      alertThreshold: null == alertThreshold
          ? _value.alertThreshold
          : alertThreshold // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrafficConfigImplCopyWith<$Res>
    implements $TrafficConfigCopyWith<$Res> {
  factory _$$TrafficConfigImplCopyWith(
          _$TrafficConfigImpl value, $Res Function(_$TrafficConfigImpl) then) =
      __$$TrafficConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enableStats,
      int statsInterval,
      bool recordHistory,
      int historyRetentionDays,
      bool enableSpeedLimit,
      int uploadLimit,
      int downloadLimit,
      bool enableTrafficAlert,
      int alertThreshold});
}

/// @nodoc
class __$$TrafficConfigImplCopyWithImpl<$Res>
    extends _$TrafficConfigCopyWithImpl<$Res, _$TrafficConfigImpl>
    implements _$$TrafficConfigImplCopyWith<$Res> {
  __$$TrafficConfigImplCopyWithImpl(
      _$TrafficConfigImpl _value, $Res Function(_$TrafficConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrafficConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableStats = null,
    Object? statsInterval = null,
    Object? recordHistory = null,
    Object? historyRetentionDays = null,
    Object? enableSpeedLimit = null,
    Object? uploadLimit = null,
    Object? downloadLimit = null,
    Object? enableTrafficAlert = null,
    Object? alertThreshold = null,
  }) {
    return _then(_$TrafficConfigImpl(
      enableStats: null == enableStats
          ? _value.enableStats
          : enableStats // ignore: cast_nullable_to_non_nullable
              as bool,
      statsInterval: null == statsInterval
          ? _value.statsInterval
          : statsInterval // ignore: cast_nullable_to_non_nullable
              as int,
      recordHistory: null == recordHistory
          ? _value.recordHistory
          : recordHistory // ignore: cast_nullable_to_non_nullable
              as bool,
      historyRetentionDays: null == historyRetentionDays
          ? _value.historyRetentionDays
          : historyRetentionDays // ignore: cast_nullable_to_non_nullable
              as int,
      enableSpeedLimit: null == enableSpeedLimit
          ? _value.enableSpeedLimit
          : enableSpeedLimit // ignore: cast_nullable_to_non_nullable
              as bool,
      uploadLimit: null == uploadLimit
          ? _value.uploadLimit
          : uploadLimit // ignore: cast_nullable_to_non_nullable
              as int,
      downloadLimit: null == downloadLimit
          ? _value.downloadLimit
          : downloadLimit // ignore: cast_nullable_to_non_nullable
              as int,
      enableTrafficAlert: null == enableTrafficAlert
          ? _value.enableTrafficAlert
          : enableTrafficAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      alertThreshold: null == alertThreshold
          ? _value.alertThreshold
          : alertThreshold // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrafficConfigImpl implements _TrafficConfig {
  const _$TrafficConfigImpl(
      {this.enableStats = true,
      this.statsInterval = 60,
      this.recordHistory = true,
      this.historyRetentionDays = 7,
      this.enableSpeedLimit = false,
      this.uploadLimit = 0,
      this.downloadLimit = 0,
      this.enableTrafficAlert = false,
      this.alertThreshold = 1000});

  factory _$TrafficConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrafficConfigImplFromJson(json);

  /// 是否启用流量统计
  @override
  @JsonKey()
  final bool enableStats;

  /// 统计间隔（秒）
  @override
  @JsonKey()
  final int statsInterval;

  /// 是否记录历史数据
  @override
  @JsonKey()
  final bool recordHistory;

  /// 历史数据保留天数
  @override
  @JsonKey()
  final int historyRetentionDays;

  /// 是否启用速度限制
  @override
  @JsonKey()
  final bool enableSpeedLimit;

  /// 上传速度限制（KB/s）
  @override
  @JsonKey()
  final int uploadLimit;

  /// 下载速度限制（KB/s）
  @override
  @JsonKey()
  final int downloadLimit;

  /// 是否启用流量警告
  @override
  @JsonKey()
  final bool enableTrafficAlert;

  /// 流量警告阈值（MB）
  @override
  @JsonKey()
  final int alertThreshold;

  @override
  String toString() {
    return 'TrafficConfig(enableStats: $enableStats, statsInterval: $statsInterval, recordHistory: $recordHistory, historyRetentionDays: $historyRetentionDays, enableSpeedLimit: $enableSpeedLimit, uploadLimit: $uploadLimit, downloadLimit: $downloadLimit, enableTrafficAlert: $enableTrafficAlert, alertThreshold: $alertThreshold)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrafficConfigImpl &&
            (identical(other.enableStats, enableStats) ||
                other.enableStats == enableStats) &&
            (identical(other.statsInterval, statsInterval) ||
                other.statsInterval == statsInterval) &&
            (identical(other.recordHistory, recordHistory) ||
                other.recordHistory == recordHistory) &&
            (identical(other.historyRetentionDays, historyRetentionDays) ||
                other.historyRetentionDays == historyRetentionDays) &&
            (identical(other.enableSpeedLimit, enableSpeedLimit) ||
                other.enableSpeedLimit == enableSpeedLimit) &&
            (identical(other.uploadLimit, uploadLimit) ||
                other.uploadLimit == uploadLimit) &&
            (identical(other.downloadLimit, downloadLimit) ||
                other.downloadLimit == downloadLimit) &&
            (identical(other.enableTrafficAlert, enableTrafficAlert) ||
                other.enableTrafficAlert == enableTrafficAlert) &&
            (identical(other.alertThreshold, alertThreshold) ||
                other.alertThreshold == alertThreshold));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      enableStats,
      statsInterval,
      recordHistory,
      historyRetentionDays,
      enableSpeedLimit,
      uploadLimit,
      downloadLimit,
      enableTrafficAlert,
      alertThreshold);

  /// Create a copy of TrafficConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrafficConfigImplCopyWith<_$TrafficConfigImpl> get copyWith =>
      __$$TrafficConfigImplCopyWithImpl<_$TrafficConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrafficConfigImplToJson(
      this,
    );
  }
}

abstract class _TrafficConfig implements TrafficConfig {
  const factory _TrafficConfig(
      {final bool enableStats,
      final int statsInterval,
      final bool recordHistory,
      final int historyRetentionDays,
      final bool enableSpeedLimit,
      final int uploadLimit,
      final int downloadLimit,
      final bool enableTrafficAlert,
      final int alertThreshold}) = _$TrafficConfigImpl;

  factory _TrafficConfig.fromJson(Map<String, dynamic> json) =
      _$TrafficConfigImpl.fromJson;

  /// 是否启用流量统计
  @override
  bool get enableStats;

  /// 统计间隔（秒）
  @override
  int get statsInterval;

  /// 是否记录历史数据
  @override
  bool get recordHistory;

  /// 历史数据保留天数
  @override
  int get historyRetentionDays;

  /// 是否启用速度限制
  @override
  bool get enableSpeedLimit;

  /// 上传速度限制（KB/s）
  @override
  int get uploadLimit;

  /// 下载速度限制（KB/s）
  @override
  int get downloadLimit;

  /// 是否启用流量警告
  @override
  bool get enableTrafficAlert;

  /// 流量警告阈值（MB）
  @override
  int get alertThreshold;

  /// Create a copy of TrafficConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrafficConfigImplCopyWith<_$TrafficConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
