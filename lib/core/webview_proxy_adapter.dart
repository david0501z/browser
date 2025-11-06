import 'dart:io';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'proxy_config.dart';

/// WebView代理适配器
/// 
/// 负责将代理配置转换为WebView可用的格式，
/// 并处理代理切换和动态配置更新。
class WebViewProxyAdapter {
  static WebViewProxyAdapter? _instance;
  static WebViewProxyAdapter get instance => _instance ??= WebViewProxyAdapter._();

  WebViewProxyAdapter._();

  /// 当前代理配置
  ProxyConfig? _currentConfig;

  /// 代理配置变更监听器
  final List<ProxyConfigListener> _listeners = [];

  /// 设置代理配置
  void setProxyConfig(ProxyConfig config) {
    final oldConfig = _currentConfig;
    _currentConfig = config;

    // 通知配置变更
    for (final listener in _listeners) {
      listener(oldConfig, config);
    }
  }

  /// 获取当前代理配置
  ProxyConfig? get currentConfig => _currentConfig;

  /// 检查代理是否启用
  bool get isProxyEnabled => 
      _currentConfig?.enabled == true && 
      _currentConfig?.proxyUrl?.isNotEmpty == true;

  /// 获取代理URL
  String? get proxyUrl => _currentConfig?.proxyUrl;

  /// 获取认证信息
  ProxyAuth? get proxyAuth => _currentConfig?.proxyAuth;

  /// 添加配置变更监听器
  void addConfigListener(ProxyConfigListener listener) {
    _listeners.add(listener);
  }

  /// 移除配置变更监听器
  void removeConfigListener(ProxyConfigListener listener) {
    _listeners.remove(listener);
  }

  /// 为WebView生成代理配置
  ProxySettings? generateProxySettings() {
    if (!isProxyEnabled || _currentConfig == null) {
      return null;
    }

    final config = _currentConfig!;
    
    switch (config.type) {
      case ProxyType.http:
        return _buildHttpProxySettings(config);
      case ProxyType.https:
        return _buildHttpsProxySettings(config);
      case ProxyType.socks4:
        return _buildSocks4ProxySettings(config);
      case ProxyType.socks5:
        return _buildSocks5ProxySettings(config);
      default:
        return null;
    }
  }

  /// 构建HTTP代理设置
  ProxySettings _buildHttpProxySettings(ProxyConfig config) {
    final uri = Uri.parse(config.proxyUrl!);
    final host = uri.host;
    final port = uri.port;
    final username = config.proxyAuth?.username;
    final password = config.proxyAuth?.password;

    if (username != null && password != null) {
      final credentials = base64Encode('$username:$password'.codeUnits);
      return ProxySettings(
        proxyRules: ProxyRules(
          proxyList: ProxyList([
            ProxyServer(host: host, port: port, scheme: ProxyServerScheme.HTTP),
          ]),
          bypassHosts: config.bypassHosts?.split(',').map((e) => e.trim()).toList(),
        ),
        proxyServerRules: ProxyServerRules(
          host: host,
          port: port,
          scheme: ProxyServerScheme.HTTP,
          proxyServerAuthConfig: ProxyServerAuthConfig(
            username: username,
            password: password,
          ),
        ),
      );
    }

    return ProxySettings(
      proxyRules: ProxyRules(
        proxyList: ProxyList([
          ProxyServer(host: host, port: port, scheme: ProxyServerScheme.HTTP),
        ]),
        bypassHosts: config.bypassHosts?.split(',').map((e) => e.trim()).toList(),
      ),
    );
  }

  /// 构建HTTPS代理设置
  ProxySettings _buildHttpsProxySettings(ProxyConfig config) {
    final uri = Uri.parse(config.proxyUrl!);
    final host = uri.host;
    final port = uri.port;
    final username = config.proxyAuth?.username;
    final password = config.proxyAuth?.password;

    if (username != null && password != null) {
      return ProxySettings(
        proxyServerRules: ProxyServerRules(
          host: host,
          port: port,
          scheme: ProxyServerScheme.HTTPS,
          proxyServerAuthConfig: ProxyServerAuthConfig(
            username: username,
            password: password,
          ),
        ),
      );
    }

    return ProxySettings(
      proxyServerRules: ProxyServerRules(
        host: host,
        port: port,
        scheme: ProxyServerScheme.HTTPS,
      ),
    );
  }

  /// 构建SOCKS4代理设置
  ProxySettings _buildSocks4ProxySettings(ProxyConfig config) {
    final uri = Uri.parse(config.proxyUrl!);
    final host = uri.host;
    final port = uri.port;

    return ProxySettings(
      proxyServerRules: ProxyServerRules(
        host: host,
        port: port,
        scheme: ProxyServerScheme.SOCKS4,
      ),
    );
  }

  /// 构建SOCKS5代理设置
  ProxySettings _buildSocks5ProxySettings(ProxyConfig config) {
    final uri = Uri.parse(config.proxyUrl!);
    final host = uri.host;
    final port = uri.port;
    final username = config.proxyAuth?.username;
    final password = config.proxyAuth?.password;

    if (username != null && password != null) {
      return ProxySettings(
        proxyServerRules: ProxyServerRules(
          host: host,
          port: port,
          scheme: ProxyServerScheme.SOCKS5,
          proxyServerAuthConfig: ProxyServerAuthConfig(
            username: username,
            password: password,
          ),
        ),
      );
    }

    return ProxySettings(
      proxyServerRules: ProxyServerRules(
        host: host,
        port: port,
        scheme: ProxyServerScheme.SOCKS5,
      ),
    );
  }

  /// 验证代理配置
  bool validateConfig(ProxyConfig config) {
    if (!config.enabled) {
      return true; // 禁用代理的配置总是有效的
    }

    if (config.proxyUrl?.isEmpty != false) {
      return false;
    }

    // 验证URL格式
    try {
      final uri = Uri.parse(config.proxyUrl!);
      if (uri.host.isEmpty || uri.port == 0) {
        return false;
      }
    } catch (e) {
      return false;
    }

    // 验证认证信息（如果有）
    if (config.proxyAuth != null) {
      final auth = config.proxyAuth!;
      if (auth.username?.isEmpty == false && auth.password == null) {
        return false;
      }
      if (auth.password?.isEmpty == false && auth.username == null) {
        return false;
      }
    }

    return true;
  }

  /// 清理配置
  void clearConfig() {
    _currentConfig = null;
  }
}

/// 代理配置类型
enum ProxyType {
  http,
  https,
  socks4,
  socks5,
}

/// 代理配置
class ProxyConfig {
  final bool enabled;
  final String? proxyUrl;
  final ProxyType type;
  final ProxyAuth? proxyAuth;
  final String? bypassHosts;
  final String? name;

  const ProxyConfig({
    this.enabled = false,
    this.proxyUrl,
    this.type = ProxyType.http,
    this.proxyAuth,
    this.bypassHosts,
    this.name,
  });

  ProxyConfig copyWith({
    bool? enabled,
    String? proxyUrl,
    ProxyType? type,
    ProxyAuth? proxyAuth,
    String? bypassHosts,
    String? name,
  }) {
    return ProxyConfig(
      enabled: enabled ?? this.enabled,
      proxyUrl: proxyUrl ?? this.proxyUrl,
      type: type ?? this.type,
      proxyAuth: proxyAuth ?? this.proxyAuth,
      bypassHosts: bypassHosts ?? this.bypassHosts,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'proxyUrl': proxyUrl,
      'type': type.name,
      'proxyAuth': proxyAuth?.toJson(),
      'bypassHosts': bypassHosts,
      'name': name,
    };
  }

  factory ProxyConfig.fromJson(Map<String, dynamic> json) {
    return ProxyConfig(
      enabled: json['enabled'] as bool? ?? false,
      proxyUrl: json['proxyUrl'] as String?,
      type: ProxyType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ProxyType.http,
      ),
      proxyAuth: json['proxyAuth'] != null
          ? ProxyAuth.fromJson(json['proxyAuth'] as Map<String, dynamic>)
          : null,
      bypassHosts: json['bypassHosts'] as String?,
      name: json['name'] as String?,
    );
  }

  @override
  String toString() {
    return 'ProxyConfig(enabled: $enabled, proxyUrl: $proxyUrl, type: $type, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProxyConfig &&
        other.enabled == enabled &&
        other.proxyUrl == proxyUrl &&
        other.type == type &&
        other.proxyAuth == proxyAuth &&
        other.bypassHosts == bypassHosts &&
        other.name == name;
  }

  @override
  int get hashCode {
    return Object.hash(
      enabled,
      proxyUrl,
      type,
      proxyAuth,
      bypassHosts,
      name,
    );
  }
}

/// 代理认证信息
class ProxyAuth {
  final String? username;
  final String? password;

  const ProxyAuth({
    this.username,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  factory ProxyAuth.fromJson(Map<String, dynamic> json) {
    return ProxyAuth(
      username: json['username'] as String?,
      password: json['password'] as String?,
    );
  }

  @override
  String toString() {
    return 'ProxyAuth(username: $username, password: ${password?.isNotEmpty == true ? '****' : null})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProxyAuth &&
        other.username == username &&
        other.password == password;
  }

  @override
  int get hashCode => Object.hash(username, password);
}

/// 代理配置监听器类型
typedef ProxyConfigListener = void Function(ProxyConfig? oldConfig, ProxyConfig? newConfig);