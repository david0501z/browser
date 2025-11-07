/// YAML 配置文件解析器
/// 
/// 解析 ClashMeta YAML 配置文件并转换为内部数据模型

import 'package:yaml/yaml.dart';
import 'package:logging/logging.dart';
import 'dart:io';
import 'clash_config_generator.dart';
import 'models/models.dart';

/// YAML 解析器类
class YamlParser {
  static final Logger _logger = Logger('YamlParser');

  /// 解析 YAML 配置文件字符串
  /// 
  /// [yamlContent] YAML 配置内容
  /// 返回解析结果
  ParseResult parseConfig(String yamlContent) {
    try {
      _logger.info('开始解析 YAML 配置');
      
      // 解析 YAML 文档
      final yaml = loadYaml(yamlContent);
      if (yaml == null || yaml is! Map) {
        throw ParseException('无效的 YAML 格式');
      }

      final configMap = yaml as Map;
      
      // 验证必需字段
      _validateRequiredFields(configMap);
      
      // 解析各个配置部分
      final proxyList = _parseProxies(configMap['proxies']);
      final proxyGroups = _parseProxyGroups(configMap['proxy-groups']);
      final rules = _parseRules(configMap['rules']);
      final ruleProviders = _parseRuleProviders(configMap['rule-providers']);
      final dnsConfig = _parseDnsConfig(configMap['dns']);
      
      // 合并配置
      final mergedConfig = _mergeConfigs(configMap, proxyList, proxyGroups, rules, ruleProviders, dnsConfig);
      
      _logger.info('YAML 配置解析完成');
      
      return ParseResult(
        config: mergedConfig,
        proxyList: proxyList,
        proxyGroups: proxyGroups,
        rules: rules,
        ruleProviders: ruleProviders,
        rawYaml: yamlContent,
      );
    } on YamlException catch (e) {
      _logger.warning('YAML 格式错误: $e');
      throw ParseException('YAML 格式错误: $e');
    } catch (e) {
      _logger.warning('解析配置失败: $e');
      throw ParseException('解析配置失败: $e');
    }
  }

  /// 从文件解析 YAML 配置
  /// 
  /// [filePath] 文件路径
  /// 返回解析结果
  Future<ParseResult> parseConfigFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw ParseException('配置文件不存在: $filePath');
      }
      
      final content = await file.readAsString();
      return parseConfig(content);
    } catch (e) {
      _logger.warning('从文件解析配置失败: $e');
      throw ParseException('从文件解析配置失败: $e');
    }
  }

  /// 解析代理列表
  List<ProxyConfig> _parseProxies(dynamic proxiesData) {
    final proxyList = <ProxyConfig>[];
    
    if (proxiesData == null || proxiesData is! List) {
      return proxyList;
    }
    
    for (final proxyData in proxiesData) {
      if (proxyData is! Map) continue;
      
      try {
        final proxy = _parseSingleProxy(proxyData);
        if (proxy != null) {
          proxyList.add(proxy);
        }
      } catch (e) {
        _logger.warning('解析代理配置失败: $e');
      }
    }
    
    return proxyList;
  }

  /// 解析单个代理配置
  ProxyConfig? _parseSingleProxy(Map proxyData) {
    try {
      final name = proxyData['name']?.toString() ?? '';
      final typeStr = proxyData['type']?.toString() ?? '';
      
      if (name.isEmpty || typeStr.isEmpty) {
        return null;
      }
      
      final type = _parseProxyType(typeStr);
      final host = proxyData['server']?.toString() ?? '';
      final port = _parseInt(proxyData['port']) ?? 0;
      
      if (host.isEmpty || port <= 0) {
        return null;
      }
      
      // 根据代理类型解析特定字段
      switch (type) {
        case ProxyType.vmess:
          return ProxyConfig(
            name: name,
            type: type,
            host: host,
            port: port,
            uuid: proxyData['uuid']?.toString(),
            alterId: _parseInt(proxyData['alterId']),
            cipher: proxyData['cipher']?.toString(),
            network: proxyData['network']?.toString(),
            mockType: proxyData['type']?.toString(),
            hostHeader: proxyData['host']?.toString(),
            path: proxyData['path']?.toString(),
            tls: _parseBool(proxyData['tls']),
            sni: proxyData['sni']?.toString(),
            alpn: proxyData['alpn']?.toString(),
          );
          
        case ProxyType.vless:
          return ProxyConfig(
            name: name,
            type: type,
            host: host,
            port: port,
            uuid: proxyData['uuid']?.toString(),
            flow: proxyData['flow']?.toString(),
            network: proxyData['network']?.toString(),
            mockType: proxyData['type']?.toString(),
            hostHeader: proxyData['host']?.toString(),
            path: proxyData['path']?.toString(),
            tls: _parseBool(proxyData['tls']),
            sni: proxyData['sni']?.toString(),
            alpn: proxyData['alpn']?.toString(),
          );
          
        case ProxyType.trojan:
          return ProxyConfig(
            name: name,
            type: type,
            host: host,
            port: port,
            password: proxyData['password']?.toString(),
            sni: proxyData['sni']?.toString(),
            alpn: proxyData['alpn']?.toString(),
          );
          
        case ProxyType.shadowsocks:
          return ProxyConfig(
            name: name,
            type: type,
            host: host,
            port: port,
            method: proxyData['method']?.toString(),
            password: proxyData['password']?.toString(),
            plugin: proxyData['plugin']?.toString(),
            pluginOpts: proxyData['plugin-opts']?.toString(),
          );
          
        case ProxyType.shadowsocksr:
          return ProxyConfig(
            name: name,
            type: type,
            host: host,
            port: port,
            method: proxyData['method']?.toString(),
            password: proxyData['password']?.toString(),
            protocol: proxyData['protocol']?.toString(),
            protocolParam: proxyData['protocol-param']?.toString(),
            obfs: proxyData['obfs']?.toString(),
            obfsParam: proxyData['obfs-param']?.toString(),
          );
          
        case ProxyType.socks5:
        case ProxyType.http:
          return ProxyConfig(
            name: name,
            type: type,
            host: host,
            port: port,
            username: proxyData['username']?.toString(),
            password: proxyData['password']?.toString(),
            tls: _parseBool(proxyData['tls']),
          );
          
        default:
          return ProxyConfig(
            name: name,
            type: type,
            host: host,
            port: port,
          );
      }
    } catch (e) {
      _logger.warning('解析代理配置异常: $e');
      return null;
    }
  }

  /// 解析代理组
  List<ProxyGroup> _parseProxyGroups(dynamic groupsData) {
    final groups = <ProxyGroup>[];
    
    if (groupsData == null || groupsData is! List) {
      return groups;
    }
    
    for (final groupData in groupsData) {
      if (groupData is! Map) continue;
      
      try {
        final name = groupData['name']?.toString() ?? '';
        final typeStr = groupData['type']?.toString() ?? '';
        final type = _parseProxyGroupType(typeStr);
        final proxies = _parseStringList(groupData['proxies']);
        
        if (name.isNotEmpty) {
          groups.add(ProxyGroup(
            name: name,
            type: type,
            proxies: proxies,
            url: groupData['url']?.toString(),
            interval: _parseInt(groupData['interval']),
          ));
        }
      } catch (e) {
        _logger.warning('解析代理组失败: $e');
      }
    }
    
    return groups;
  }

  /// 解析规则
  List<String> _parseRules(dynamic rulesData) {
    if (rulesData == null) {
      return [];
    }
    
    return _parseStringList(rulesData);
  }

  /// 解析规则提供者
  List<Map<String, dynamic>> _parseRuleProviders(dynamic providersData) {
    final providers = <Map<String, dynamic>>[];
    
    if (providersData == null || providersData is! Map) {
      return providers;
    }
    
    for (final entry in providersData.entries) {
      if (entry.value is! Map) continue;
      
      try {
        final provider = {
          'name': entry.key.toString(),
          ...entry.value as Map,
        };
        providers.add(provider);
      } catch (e) {
        _logger.warning('解析规则提供者失败: $e');
      }
    }
    
    return providers;
  }

  /// 解析 DNS 配置
  Map<String, dynamic>? _parseDnsConfig(dynamic dnsData) {
    if (dnsData == null || dnsData is! Map) {
      return null;
    }
    
    return {
      'enable': _parseBool(dnsData['enable']) ?? false,
      'ipv6': _parseBool(dnsData['ipv6']) ?? false,
      'use-hosts': _parseBool(dnsData['use-hosts']) ?? true,
      'nameserver': _parseStringList(dnsData['nameserver']),
      'fallback': _parseStringList(dnsData['fallback']),
      'fallback-filter': dnsData['fallback-filter'],
    };
  }

  /// 合并配置
  ClashCoreSettings _mergeConfigs(
    Map configMap,
    List<ProxyConfig> proxyList,
    List<ProxyGroup> proxyGroups,
    List<String> rules,
    List<Map<String, dynamic>> ruleProviders,
    Map<String, dynamic>? dnsConfig,
  ) {
    // 解析基本设置
    final port = _parseInt(configMap['port']) ?? 7890;
    final socksPort = _parseInt(configMap['socks-port']) ?? 7891;
    final mixedPort = _parseInt(configMap['mixed-port']) ?? 7890;
    final apiPort = _extractPortFromController(configMap['external-controller']) ?? 9090;
    
    final mode = _parseProxyMode(configMap['mode']);
    final logLevel = _parseLogLevel(configMap['log-level']);
    final allowLan = _parseBool(configMap['allow-lan']) ?? false;
    final ipv6 = _parseBool(configMap['ipv6']) ?? false;
    
    // 解析 DNS 设置
    DNSSettings dnsSettings;
    if (dnsConfig != null && dnsConfig['enable'] == true) {
      final nameservers = List<String>.from(dnsConfig['nameserver'] ?? []);
      dnsSettings = DNSSettings(
        primary: nameservers.isNotEmpty ? nameservers.first : '223.5.5.5',
        secondary: nameservers.length > 1 ? nameservers[1] : null,
        proxyServers: List<String>.from(dnsConfig['nameserver'] ?? []),
        directServers: List<String>.from(dnsConfig['fallback'] ?? []),
      );
    } else {
      dnsSettings = const DNSSettings();
    }
    
    // 解析端口设置
    final portSettings = PortSettings(
      httpPort: port,
      socksPort: socksPort,
      mixedPort: mixedPort,
      controllerPort: apiPort,
    );
    
    // 创建合并的配置
    return ClashCoreSettings(
      enabled: false,
      mode: mode,
      coreVersion: '',
      configPath: null,
      logLevel: logLevel,
      autoUpdate: true,
      ipv6: ipv6,
      tunMode: false,
      mixedMode: false,
      systemProxy: false,
      lanShare: allowLan,
      dnsForward: false,
      ports: portSettings,
      dns: dnsSettings,
      rules: const RuleConfiguration(),
      nodes: const NodeSettings(),
      traffic: const TrafficPerformanceSettings(),
    );
  }

  /// 验证必需字段
  void _validateRequiredFields(Map configMap) {
    // Clash 基本不需要强制字段，但可以做一些基本验证
    if (configMap.isEmpty) {
      throw ParseException('配置文件为空');
    }
  }

  /// 解析代理类型
  ProxyType _parseProxyType(String typeStr) {
    switch (typeStr.toLowerCase()) {
      case 'vmess':
        return ProxyType.vmess;
      case 'vless':
        return ProxyType.vless;
      case 'trojan':
        return ProxyType.trojan;
      case 'ss':
        return ProxyType.shadowsocks;
      case 'ssr':
        return ProxyType.shadowsocksr;
      case 'socks5':
        return ProxyType.socks5;
      case 'http':
        return ProxyType.http;
      case 'tuic':
        return ProxyType.tuic;
      case 'hy2':
        return ProxyType.hy2;
      default:
        _logger.warning('未知的代理类型: $typeStr');
        return ProxyType.socks5;
    }
  }

  /// 解析代理组类型
  ProxyGroupType _parseProxyGroupType(String typeStr) {
    switch (typeStr.toLowerCase()) {
      case 'select':
        return ProxyGroupType.select;
      case 'url-test':
        return ProxyGroupType.urlTest;
      case 'load-balance':
        return ProxyGroupType.loadBalance;
      case 'fallback':
        return ProxyGroupType.fallback;
      default:
        return ProxyGroupType.select;
    }
  }

  /// 解析代理模式
  ProxyMode _parseProxyMode(String modeStr) {
    switch (modeStr.toLowerCase()) {
      case 'rule':
        return ProxyMode.rule;
      case 'global':
        return ProxyMode.global;
      case 'direct':
        return ProxyMode.direct;
      default:
        return ProxyMode.rule;
    }
  }

  /// 解析日志级别
  LogLevel _parseLogLevel(String levelStr) {
    switch (levelStr.toLowerCase()) {
      case 'debug':
        return LogLevel.debug;
      case 'info':
        return LogLevel.info;
      case 'warning':
        return LogLevel.warning;
      case 'error':
        return LogLevel.error;
      default:
        return LogLevel.info;
    }
  }

  /// 解析布尔值
  bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true' || lower == '1' || lower == 'yes') return true;
      if (lower == 'false' || lower == '0' || lower == 'no') return false;
    }
    return null;
  }

  /// 解析整数
  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  /// 解析字符串列表
  List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is String) {
      return [value];
    }
    return [];
  }

  /// 从外部控制器提取端口号
  int? _extractPortFromController(String? controller) {
    if (controller == null) return null;
    
    final parts = controller.split(':');
    if (parts.length >= 2) {
      return int.tryParse(parts.last);
    }
    return null;
  }

  /// 检测配置文件类型
  ConfigType detectConfigType(String yamlContent) {
    try {
      final yaml = loadYaml(yamlContent);
      if (yaml is! Map) return ConfigType.unknown;
      
      final proxies = yaml['proxies'];
      final rules = yaml['rules'];
      
      if (proxies is List && proxies.isNotEmpty) {
        final firstProxy = proxies.first;
        if (firstProxy is Map && firstProxy['type'] != null) {
          final type = firstProxy['type'].toString().toLowerCase();
          
          if (type.contains('vmess') || type.contains('vless') || type.contains('trojan')) {
            return ConfigType.clash;
          } else if (type.contains('ss') || type.contains('socks') || type.contains('http')) {
            return ConfigType.shadowsocks;
          }
        }
      }
      
      if (rules is List && rules.isNotEmpty) {
        return ConfigType.clash;
      }
      
      return ConfigType.unknown;
    } catch (e) {
      return ConfigType.invalid;
    }
  }

  /// 提取配置文件信息
  ConfigInfo extractConfigInfo(String yamlContent) {
    final yaml = loadYaml(yamlContent);
    final configMap = yaml as Map? ?? {};
    
    final proxies = configMap['proxies'] as List?;
    final proxyGroups = configMap['proxy-groups'] as List?;
    final rules = configMap['rules'] as List?;
    
    final proxyCount = proxies?.length ?? 0;
    final groupCount = proxyGroups?.length ?? 0;
    final ruleCount = rules?.length ?? 0;
    
    final proxyTypes = <String, int>{};
    if (proxies != null) {
      for (final proxy in proxies) {
        if (proxy is Map) {
          final type = proxy['type']?.toString() ?? 'unknown';
          proxyTypes[type] = (proxyTypes[type] ?? 0) + 1;
        }
      }
    }
    
    return ConfigInfo(
      proxyCount: proxyCount,
      groupCount: groupCount,
      ruleCount: ruleCount,
      proxyTypes: proxyTypes,
      hasRules: ruleCount > 0,
      hasGroups: groupCount > 0,
      configType: detectConfigType(yamlContent),
    );
  }
}

/// 解析结果类
class ParseResult {
  final ClashCoreSettings config;
  final List<ProxyConfig> proxyList;
  final List<ProxyGroup> proxyGroups;
  final List<String> rules;
  final List<Map<String, dynamic>> ruleProviders;
  final String rawYaml;

  const ParseResult({
    required this.config,
    required this.proxyList,
    required this.proxyGroups,
    required this.rules,
    required this.ruleProviders,
    required this.rawYaml,
  });
}

/// 代理组类
class ProxyGroup {
  final String name;
  final ProxyGroupType type;
  final List<String> proxies;
  final String? url;
  final int? interval;

  const ProxyGroup({
    required this.name,
    required this.type,
    required this.proxies,
    this.url,
    this.interval,
  });
}

/// 代理组类型枚举
enum ProxyGroupType {
  select,
  urlTest,
  loadBalance,
  fallback,
}

/// 配置类型枚举
enum ConfigType {
  clash,
  shadowsocks,
  unknown,
  invalid,
}

/// 配置信息类
class ConfigInfo {
  final int proxyCount;
  final int groupCount;
  final int ruleCount;
  final Map<String, int> proxyTypes;
  final bool hasRules;
  final bool hasGroups;
  final ConfigType configType;

  const ConfigInfo({
    required this.proxyCount,
    required this.groupCount,
    required this.ruleCount,
    required this.proxyTypes,
    required this.hasRules,
    required this.hasGroups,
    required this.configType,
  });
}

/// 解析异常
class ParseException implements Exception {
  final String message;
  
  const ParseException(this.message);
  
  @override
  String toString() => 'ParseException: $message';
}
