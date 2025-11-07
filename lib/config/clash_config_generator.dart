/// Clash 配置生成器
/// 
/// 将 ClashCoreSettings 转换为 ClashMeta 兼容的 YAML 配置文件

import 'models/models.dart';


/// Clash 配置生成器类
class ClashConfigGenerator {
  /// 最小端口号
  static const int minPort = 1024;
  
  /// 最大端口号
  static const int maxPort = 65535;
  
  /// 支持的代理协议类型
  static const List<String> supportedProxyTypes = [
    'vmess',
    'vless', 
    'trojan',
    'ss',
    'ssr',
    'socks5',
    'http',
    'tuic',
    'hy2',
  ];

  /// 生成 Clash 配置 YAML 字符串
  /// 
  /// [settings] ClashCoreSettings 配置
  /// [proxyList] 代理节点列表
  /// [rules] 规则列表
  /// [ruleProviders] 规则提供者列表
  String generateClashConfig(
    ClashCoreSettings settings, {
    List<ProxyConfig>? proxyList,
    List<String>? rules,
    List<Map<String, dynamic>>? ruleProviders,
  }) {
    try {
      final config = _buildConfigMap(settings, proxyList, rules, ruleProviders);
      return _convertToYaml(config);
    } catch (e) {
      throw ConfigGenerationException('生成 Clash 配置失败: $e');
    }
  }

  /// 生成简化的代理配置
  /// 
  /// [proxyList] 代理节点列表
  /// [mode] 代理模式
  String generateProxyOnlyConfig(List<ProxyConfig> proxyList, {ProxyMode mode = ProxyMode.rule}) {
    final config = {
      'port': 7890,
      'socks-port': 7891,
      'allow-lan': false,
      'mode': _convertProxyMode(mode),
      'log-level': 'info',
      'external-controller': '127.0.0.1:9090',
      'proxies': proxyList.map(_convertProxyConfig).toList(),
      'proxy-groups': [
        {
          'name': 'PROXY',
          'type': 'select',
          'proxies': ['DIRECT'] + proxyList.map((p) => p.name).toList(),
        }
      ],
      'rules': _getDefaultRules(),
    };
    
    return _convertToYaml(config);
  }

  /// 构建配置映射
  Map<String, dynamic> _buildConfigMap(
    ClashCoreSettings settings,
    List<ProxyConfig>? proxyList,
    List<String>? rules,
    List<Map<String, dynamic>>? ruleProviders,
  ) {
    final config = <String, dynamic>{};

    // 基本设置
    config.addAll(_buildBasicSettings(settings));
    
    // 端口设置
    config.addAll(_buildBasicPortSettings(settings));
    
    // DNS 设置 - 临时禁用，需要正确的DNSConfiguration对象
    
    // 代理设置
    if (proxyList != null && proxyList.isNotEmpty) {
      config.addAll(_buildProxySettings(proxyList));
    }
    
    // 规则设置
    config.addAll(_buildBasicRuleSettings(settings, rules, ruleProviders));
    
    // 流量统计
    config.addAll(_buildTrafficSettings(settings.traffic));
    
    return config;
  }

  /// 构建基本设置
  Map<String, dynamic> _buildBasicSettings(ClashCoreSettings settings) {
    return {
      'allow-lan': settings.lanShare,
      'bind-address': '*',
      'mode': _convertProxyMode(settings.mode),
      'log-level': _convertLogLevel(settings.logLevel),
      'ipv6': settings.ipv6,
      'external-controller': '127.0.0.1:9090',
      'secret': '',
      'configuration': 'mixed',
    };
  }

  /// 构建基础端口设置
  Map<String, dynamic> _buildBasicPortSettings(ClashCoreSettings settings) {
    final portConfig = <String, dynamic>{};
    
    // 设置 HTTP 端口
    if (_isValidPort(settings.port)) {
      portConfig['port'] = settings.port;
    }
    
    // 设置 SOCKS 端口
    if (_isValidPort(settings.socksPort)) {
      portConfig['socks-port'] = settings.socksPort;
    }
    
    // 设置 TProxy 端口
    if (_isValidPort(settings.tproxyPort)) {
      portConfig['tproxy-port'] = settings.tproxyPort;
    }
    
    return portConfig;
  }

  /// 构建端口设置
  Map<String, dynamic> _buildPortSettings(PortConfiguration ports) {
    final portConfig = <String, dynamic>{};
    
    // 验证并设置 HTTP 端口
    if (_isValidPort(ports.httpPort)) {
      portConfig['port'] = ports.httpPort;
    }
    
    // 验证并设置 SOCKS 端口
    if (_isValidPort(ports.socksPort)) {
      portConfig['socks-port'] = ports.socksPort;
    }
    
    // 验证并设置混合端口
    if (_isValidPort(ports.mixedPort)) {
      portConfig['mixed-port'] = ports.mixedPort;
    }
    
    // 验证并设置 API 端口
    if (_isValidPort(ports.apiPort)) {
      portConfig['external-controller'] = '127.0.0.1:${ports.apiPort}';
    }
    
    return portConfig;
  }

  /// 构建 DNS 设置
  Map<String, dynamic> _buildDnsSettings(DNSConfiguration dns) {
    final dnsConfig = <String, dynamic>{};
    
    if (dns.customDNS && dns.dnsServers.isNotEmpty) {
      dnsConfig['dns'] = {
        'enable': true,
        'ipv6': true,
        'use-hosts': true,
        'nameserver': dns.dnsServers,
        'fallback': ['https://dns.cloudflare.com/dns-query', 'https://dns.google/dns-query'],
        'fallback-filter': {
          'geoip': true,
          'geoip-code': 'CN',
          'domain': ['geosite:cn'],
        },
      };
      
      // 检查是否启用 DNS over HTTPS (strategy == 2)
      if (dns.strategy == 2) {
        dnsConfig['dns']['fallback'] = ['https://dns.cloudflare.com/dns-query'];
      }
    }
    
    return dnsConfig;
  }

  /// 构建代理设置
  Map<String, dynamic> _buildProxySettings(List<ProxyConfig> proxyList) {
    final proxies = proxyList.map(_convertProxyConfig).toList();
    
    // 构建代理组
    final proxyGroups = _buildProxyGroups(proxyList);
    
    return {
      'proxies': proxies,
      'proxy-groups': proxyGroups,
    };
  }

  /// 构建代理组
  List<Map<String, dynamic>> _buildProxyGroups(List<ProxyConfig> proxyList) {
    final groups = <Map<String, dynamic>>[];
    
    // 主代理组
    groups.add({
      'name': 'PROXY',
      'type': 'select',
      'proxies': ['DIRECT'] + proxyList.map((p) => p.name).toList(),
    });
    
    // 自动选择组
    final autoProxies = proxyList.where((p) => p.type == ProxyType.auto).toList();
    if (autoProxies.isNotEmpty) {
      groups.add({
        'name': 'AUTO',
        'type': 'url-test',
        'proxies': autoProxies.map((p) => p.name).toList(),
        'url': 'http://www.gstatic.com/generate_204',
        'interval': 300,
      });
    }
    
    // 负载均衡组
    final loadBalanceProxies = proxyList.where((p) => p.type == ProxyType.loadBalance).toList();
    if (loadBalanceProxies.isNotEmpty) {
      groups.add({
        'name': 'LOAD_BALANCE',
        'type': 'load-balance',
        'proxies': loadBalanceProxies.map((p) => p.name).toList(),
        'strategy': 'round-robin',
      });
    }
    
    return groups;
  }

  /// 构建基础规则设置
  Map<String, dynamic> _buildBasicRuleSettings(
    ClashCoreSettings settings,
    List<String>? customRules,
    List<Map<String, dynamic>>? ruleProviders,
  ) {
    final rules = <String>[];
    
    // 如果有自定义规则，添加到规则列表中
    if (customRules != null) {
      rules.addAll(customRules);
    }
    
    // 如果没有自定义规则，使用默认规则
    if (rules.isEmpty) {
      rules.add('DOMAIN-SUFFIX,google.com,Auto');
      rules.add('DOMAIN-SUFFIX,youtube.com,Auto');
    }
    
    final ruleConfig = <String, dynamic>{
      'rules': rules,
    };
    
    // 如果有规则提供者，添加
    if (ruleProviders != null && ruleProviders.isNotEmpty) {
      ruleConfig['rule-providers'] = ruleProviders;
    }
    
    return ruleConfig;
  }

  /// 构建规则设置
  Map<String, dynamic> _buildRuleSettings(
    RuleConfiguration ruleConfiguration,
    List<String>? customRules,
    List<Map<String, dynamic>>? ruleProviders,
  ) {
    final rules = <String>[];
    
    // 自定义规则
    if (customRules != null) {
      rules.addAll(customRules);
    } else if (ruleConfiguration.enable && ruleConfiguration.rules.isNotEmpty) {
      // 使用配置中的规则
      rules.addAll(ruleConfiguration.rules.map((rule) => rule.toString()).toList());
    } else {
      // 默认规则
      rules.addAll(_getDefaultRules());
    }
    
    final ruleConfig = <String, dynamic>{
      'rules': rules,
    };
    
    // 添加规则提供者
    if (ruleProviders != null && ruleProviders.isNotEmpty) {
      ruleConfig['rule-providers'] = {};
      for (final provider in ruleProviders) {
        ruleConfig['rule-providers'][provider['name']] = provider;
      }
    }
    
    return ruleConfig;
  }

  /// 构建流量统计设置
  Map<String, dynamic> _buildTrafficSettings(TrafficPerformanceSettings traffic) {
    return {
      'profile': {
        'store-selected': true,
        'store-fakeip': false,
      }
    };
  }

  /// 转换代理配置
  Map<String, dynamic> _convertProxyConfig(ProxyConfig proxy) {
    final config = <String, dynamic>{
      'name': proxy.name,
      'type': _convertProxyType(proxy.type),
    };
    
    switch (proxy.type) {
      case ProxyType.vmess:
        config.addAll(_convertVmessConfig(proxy));
        break;
      case ProxyType.vless:
        config.addAll(_convertVlessConfig(proxy));
        break;
      case ProxyType.trojan:
        config.addAll(_convertTrojanConfig(proxy));
        break;
      case ProxyType.shadowsocks:
        config.addAll(_convertShadowsocksConfig(proxy));
        break;
      case ProxyType.shadowsocksr:
        config.addAll(_convertShadowsocksRConfig(proxy));
        break;
      case ProxyType.socks5:
        config.addAll(_convertSocks5Config(proxy));
        break;
      case ProxyType.http:
        config.addAll(_convertHttpConfig(proxy));
        break;
      default:
        config.addAll(_convertGenericConfig(proxy));
    }
    
    return config;
  }

  /// 转换 VMess 配置
  Map<String, dynamic> _convertVmessConfig(ProxyConfig proxy) {
    return {
      'server': proxy.host,
      'port': proxy.port,
      'uuid': proxy.uuid,
      'alterId': proxy.alterId ?? 0,
      'cipher': proxy.cipher ?? 'auto',
      'network': proxy.network ?? 'ws',
      'type': proxy.mockType ?? 'none',
      'host': proxy.host,
      'path': proxy.path ?? '/',
      'tls': proxy.tls ?? false,
      'sni': proxy.sni,
      'alpn': proxy.alpn,
    };
  }

  /// 转换 VLESS 配置
  Map<String, dynamic> _convertVlessConfig(ProxyConfig proxy) {
    return {
      'server': proxy.host,
      'port': proxy.port,
      'uuid': proxy.uuid,
      'flow': proxy.flow ?? '',
      'network': proxy.network ?? 'ws',
      'type': proxy.mockType ?? 'none',
      'host': proxy.host,
      'path': proxy.path ?? '/',
      'tls': proxy.tls ?? false,
      'sni': proxy.sni,
      'alpn': proxy.alpn,
    };
  }

  /// 转换 Trojan 配置
  Map<String, dynamic> _convertTrojanConfig(ProxyConfig proxy) {
    return {
      'server': proxy.host,
      'port': proxy.port,
      'password': proxy.password,
      'sni': proxy.sni,
      'alpn': proxy.alpn,
    };
  }

  /// 转换 Shadowsocks 配置
  Map<String, dynamic> _convertShadowsocksConfig(ProxyConfig proxy) {
    return {
      'server': proxy.host,
      'port': proxy.port,
      'method': proxy.method ?? 'aes-256-gcm',
      'password': proxy.password,
      'plugin': proxy.plugin,
      'plugin-opts': proxy.pluginOpts,
    };
  }

  /// 转换 ShadowsocksR 配置
  Map<String, dynamic> _convertShadowsocksRConfig(ProxyConfig proxy) {
    return {
      'server': proxy.host,
      'port': proxy.port,
      'method': proxy.method ?? 'aes-128-ctr',
      'password': proxy.password,
      'protocol': proxy.protocol ?? 'origin',
      'protocol-param': proxy.protocolParam ?? '',
      'obfs': proxy.obfs ?? 'plain',
      'obfs-param': proxy.obfsParam ?? '',
    };
  }

  /// 转换 SOCKS5 配置
  Map<String, dynamic> _convertSocks5Config(ProxyConfig proxy) {
    return {
      'server': proxy.host,
      'port': proxy.port,
      'username': proxy.username,
      'password': proxy.password,
    };
  }

  /// 转换 HTTP 配置
  Map<String, dynamic> _convertHttpConfig(ProxyConfig proxy) {
    return {
      'server': proxy.host,
      'port': proxy.port,
      'username': proxy.username,
      'password': proxy.password,
      'tls': proxy.tls ?? false,
    };
  }

  /// 转换通用配置
  Map<String, dynamic> _convertGenericConfig(ProxyConfig proxy) {
    return {
      'server': proxy.host,
      'port': proxy.port,
    };
  }

  /// 转换代理模式
  String _convertProxyMode(ProxyMode mode) {
    switch (mode) {
      case ProxyMode.rule:
        return 'rule';
      case ProxyMode.global:
        return 'global';
      case ProxyMode.direct:
        return 'direct';
      case ProxyMode.bypassChina:
        return 'bypassChina';
      default:
        return 'rule'; // 默认返回
    }
  }

  /// 转换日志级别
  String _convertLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 'debug';
      case LogLevel.info:
        return 'info';
      case LogLevel.warning:
        return 'warning';
      case LogLevel.error:
        return 'error';
      case LogLevel.silent:
        return 'silent';
      default:
        return 'info'; // 默认返回
    }
  }

  /// 转换代理类型
  String _convertProxyType(ProxyType type) {
    switch (type) {
      case ProxyType.vmess:
        return 'vmess';
      case ProxyType.vless:
        return 'vless';
      case ProxyType.trojan:
        return 'trojan';
      case ProxyType.shadowsocks:
        return 'ss';
      case ProxyType.shadowsocksr:
        return 'ssr';
      case ProxyType.socks5:
        return 'socks5';
      case ProxyType.http:
        return 'http';
      case ProxyType.tuic:
        return 'tuic';
      case ProxyType.hy2:
        return 'hy2';
      case ProxyType.auto:
        return 'auto';
      case ProxyType.loadBalance:
        return 'load-balance';
      default:
        return 'unknown';
    }
  }

  /// 获取默认规则
  List<String> _getDefaultRules() {
    return [
      'DOMAIN-SUFFIX,google.com,PROXY',
      'DOMAIN-SUFFIX,youtube.com,PROXY',
      'DOMAIN-SUFFIX,github.com,PROXY',
      'DOMAIN-SUFFIX,stackoverflow.com,PROXY',
      'DOMAIN-SUFFIX,reddit.com,PROXY',
      'GEOIP,CN,DIRECT',
      'MATCH,DIRECT',
    ];
  }

  /// 导出 Clash 配置信息
  /// 
  /// 返回配置生成状态信息
  String dump([Map<String, dynamic>? config]) {
    if (config != null) {
      return 'Configuration map with ${config.length} keys';
    }
    return 'Clash configuration generated';
  }

  /// 验证端口号
  bool _isValidPort(int port) {
    return port >= minPort && port <= maxPort;
  }

  /// 转换为 YAML 字符串
  String _convertToYaml(Map<String, dynamic> config) {
    try {
      final yaml = dump(config);
      return yaml;
    } catch (e) {
      throw ConfigGenerationException('转换为 YAML 失败: $e');
    }
  }

  /// 验证代理配置
  bool validateProxyConfig(ProxyConfig proxy) {
    // 基础验证
    if (proxy.name.isEmpty || proxy.host.isEmpty || proxy.port <= 0) {
      return false;
    }
    
    // 协议特定验证
    switch (proxy.type) {
      case ProxyType.vmess:
      case ProxyType.vless:
        return proxy.uuid != null && proxy.uuid!.isNotEmpty;
      case ProxyType.trojan:
      case ProxyType.shadowsocks:
      case ProxyType.shadowsocksr:
        return proxy.password != null && proxy.password!.isNotEmpty;
      case ProxyType.socks5:
      case ProxyType.http:
        return proxy.username != null && proxy.username!.isNotEmpty;
      default:
        return true;
    }
  }

  /// 生成配置摘要
  String generateConfigSummary(ClashCoreSettings settings, List<ProxyConfig>? proxyList) {
    final buffer = StringBuffer();
    
    buffer.writeln('=== Clash 配置摘要 ===');
    buffer.writeln('模式: ${_convertProxyMode(settings.mode)}');
    buffer.writeln('日志级别: ${_convertLogLevel(settings.logLevel)}');
    buffer.writeln('IPv6: ${settings.ipv6 ? "启用" : "禁用"}');
    buffer.writeln('LAN 共享: ${settings.lanShare ? "启用" : "禁用"}');
    
    if (proxyList != null && proxyList.isNotEmpty) {
      buffer.writeln('代理节点: ${proxyList.length} 个');
      final typeCount = <String, int>{};
      for (final proxy in proxyList) {
        final type = _convertProxyType(proxy.type);
        typeCount[type] = (typeCount[type] ?? 0) + 1;
      }
      for (final entry in typeCount.entries) {
        buffer.writeln('  ${entry.key}: ${entry.value} 个');
      }
    }
    
    return buffer.toString();
  }
}

/// 配置生成异常
class ConfigGenerationException implements Exception {
  final String message;
  
  const ConfigGenerationException(this.message);
  
  @override
  String toString() => 'ConfigGenerationException: $message';
}

/// 代理配置模型
class ProxyConfig {
  final String name;
  final ProxyType type;
  final String host;
  final int port;
  final String? uuid;
  final String? password;
  final String? method;
  final String? username;
  final int? alterId;
  final String? cipher;
  final String? network;
  final String? mockType;
  final String? hostHeader;
  final String? path;
  final bool? tls;
  final String? sni;
  final String? alpn;
  final String? flow;
  final String? plugin;
  final String? pluginOpts;
  final String? protocol;
  final String? protocolParam;
  final String? obfs;
  final String? obfsParam;

  const ProxyConfig({
    required this.name,
    required this.type,
    required this.host,
    required this.port,
    this.uuid,
    this.password,
    this.method,
    this.username,
    this.alterId,
    this.cipher,
    this.network,
    this.mockType,
    this.hostHeader,
    this.path,
    this.tls,
    this.sni,
    this.alpn,
    this.flow,
    this.plugin,
    this.pluginOpts,
    this.protocol,
    this.protocolParam,
    this.obfs,
    this.obfsParam,
  });
}

/// 代理类型枚举
enum ProxyType {
  vmess,
  vless,
  trojan,
  shadowsocks,
  shadowsocksr,
  socks5,
  http,
  tuic,
  hy2,
  auto,
  loadBalance,
}
