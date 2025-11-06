/// 模型转换器
/// 
/// 实现 ClashCoreSettings 与 ProxyConfig 之间的互相转换
library model_converter;

import 'app_settings.dart';

/// ClashCoreSettings 与 ProxyConfig 转换器
class ModelConverter {
  /// 将 ClashCoreSettings 转换为 ProxyConfig
  static ProxyConfig flClashSettingsToProxyConfig(ClashCoreSettings flClashSettings) {
    return ProxyConfig(
      enabled: flClashSettings.enabled,
      mode: _convertProxyMode(flClashSettings.mode),
      port: flClashSettings.ports.httpPort,
      listenAddress: flClashSettings.ports.allowLan ? '0.0.0.0' : '127.0.0.1',
      
      // 路由规则配置
      rules: _convertRules(flClashSettings.rules),
      bypassChina: flClashSettings.rules.bypassChina,
      bypassLAN: flClashSettings.rules.bypassLan,
      
      // DNS配置
      primaryDNS: flClashSettings.dns.primary,
      secondaryDNS: flClashSettings.dns.secondary,
      dnsOverHttps: flClashSettings.dns.doh,
      
      // 安全配置
      allowInsecure: false,
      enableIPv6: flClashSettings.ipv6,
      enableMux: true,
      
      // 连接配置
      connectionTimeout: 30,
      readTimeout: 60,
      retryCount: 3,
      
      // 日志配置
      enableLog: flClashSettings.logLevel != LogLevel.error,
      logLevel: _convertLogLevel(flClashSettings.logLevel),
      logPath: '/tmp/proxy.log',
      
      // 流量配置
      enableTrafficStats: flClashSettings.traffic.enableStats,
      enableSpeedTest: flClashSettings.traffic.enableSpeed,
      
      // 节点配置
      selectedNodeId: flClashSettings.nodes.currentNodeId ?? '',
      nodes: flClashSettings.nodes.nodes,
      
      // 自定义配置
      customSettings: {
        'tunMode': flClashSettings.tunMode,
        'mixedMode': flClashSettings.mixedMode,
        'systemProxy': flClashSettings.systemProxy,
        'lanShare': flClashSettings.lanShare,
        'dnsForward': flClashSettings.dnsForward,
        'autoUpdate': flClashSettings.autoUpdate,
        'coreVersion': flClashSettings.coreVersion,
        'configPath': flClashSettings.configPath,
        'trafficSettings': flClashSettings.traffic.toJson(),
        'proxyCoreSettings': flClashSettings.proxyCoreSettings?.toJson(),
      },
    );
  }
  
  /// 将 ProxyConfig 转换为 ClashCoreSettings
  static ClashCoreSettings proxyConfigToClashCoreSettings(ProxyConfig proxyConfig) {
    final customSettings = proxyConfig.customSettings;
    
    return ClashCoreSettings(
      enabled: proxyConfig.enabled,
      mode: _convertProxyModeFromString(proxyConfig.mode),
      coreVersion: customSettings['coreVersion'] as String? ?? '',
      configPath: customSettings['configPath'] as String?,
      logLevel: _convertLogLevelFromString(proxyConfig.logLevel),
      autoUpdate: customSettings['autoUpdate'] as bool? ?? true,
      ipv6: proxyConfig.enableIPv6,
      tunMode: customSettings['tunMode'] as bool? ?? false,
      mixedMode: customSettings['mixedMode'] as bool? ?? false,
      systemProxy: customSettings['systemProxy'] as bool? ?? false,
      lanShare: customSettings['lanShare'] as bool? ?? false,
      dnsForward: customSettings['dnsForward'] as bool? ?? false,
      
      ports: PortSettings(
        httpPort: proxyConfig.port,
        httpsPort: proxyConfig.port + 1,
        socksPort: proxyConfig.port + 2,
        mixedPort: proxyConfig.port + 3,
        allowLan: proxyConfig.listenAddress == '0.0.0.0',
        lanOnly: false, // 默认值
      ),
      
      dns: DNSSettings(
        primary: proxyConfig.primaryDNS,
        secondary: proxyConfig.secondaryDNS,
        doh: proxyConfig.dnsOverHttps,
        dohUrl: 'https://cloudflare-dns.com/dns-query', // 默认值
        bypassChina: proxyConfig.bypassChina,
      ),
      
      rules: RuleConfiguration(
        bypassChina: proxyConfig.bypassChina,
        bypassLan: proxyConfig.bypassLAN,
        bypassPrivate: proxyConfig.bypassLAN,
        customRules: [],
        ruleProviders: [],
      ),
      
      nodes: NodeSettings(
        currentNodeId: proxyConfig.selectedNodeId.isNotEmpty ? proxyConfig.selectedNodeId : null,
        nodes: proxyConfig.nodes,
        autoSelect: false, // 默认值
        latencyTestUrl: 'http://www.gstatic.com/generate_204', // 默认值
        sortMode: NodeSortMode.latency, // 默认值
      ),
      
      traffic: _convertTrafficControlSettings(customSettings['trafficSettings'] as Map<String, dynamic>?),
      
      proxyCoreSettings: _convertProxyCoreSettings(customSettings['proxyCoreSettings'] as Map<String, dynamic>?),
    );
  }
  
  /// 转换代理模式
  static String _convertProxyMode(ProxyMode mode) {
    switch (mode) {
      case ProxyMode.rule:
        return 'rule';
      case ProxyMode.global:
        return 'global';
      case ProxyMode.direct:
        return 'direct';
    }
  }
  
  /// 从字符串转换代理模式
  static ProxyMode _convertProxyModeFromString(String mode) {
    switch (mode.toLowerCase()) {
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
  
  /// 转换日志级别
  static String _convertLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 'debug';
      case LogLevel.info:
        return 'info';
      case LogLevel.warning:
        return 'warning';
      case LogLevel.error:
        return 'error';
    }
  }
  
  /// 从字符串转换日志级别
  static LogLevel _convertLogLevelFromString(String level) {
    switch (level.toLowerCase()) {
      case 'debug':
        return LogLevel.debug;
      case 'info':
        return LogLevel.info;
      case LogLevel.warning:
        return LogLevel.warning;
      case LogLevel.error:
        return LogLevel.error;
      default:
        return LogLevel.info;
    }
  }
  
  /// 转换规则
  static List<ProxyRule> _convertRules(RuleConfiguration ruleConfiguration) {
    final rules = <ProxyRule>[];
    
    // 添加绕过中国大陆规则
    if (ruleSettings.bypassChina) {
      rules.add(ProxyRule(
        id: 'bypass-china',
        name: '绕过中国大陆',
        type: ProxyRuleType.domain,
        matchType: ProxyMatchType.suffix,
        match: '.cn',
        action: ProxyAction.direct,
        enabled: true,
        priority: 1,
      ));
    }
    
    // 添加绕过局域网规则
    if (ruleSettings.bypassLan) {
      rules.addAll([
        ProxyRule(
          id: 'bypass-lan-1',
          name: '绕过局域网段1',
          type: ProxyRuleType.ip,
          matchType: ProxyMatchType.prefix,
          match: '192.168.',
          action: ProxyAction.direct,
          enabled: true,
          priority: 2,
        ),
        ProxyRule(
          id: 'bypass-lan-2',
          name: '绕过局域网段2',
          type: ProxyRuleType.ip,
          matchType: ProxyMatchType.prefix,
          match: '10.',
          action: ProxyAction.direct,
          enabled: true,
          priority: 2,
        ),
        ProxyRule(
          id: 'bypass-lan-3',
          name: '绕过局域网段3',
          type: ProxyRuleType.ip,
          matchType: ProxyMatchType.prefix,
          match: '172.16.',
          action: ProxyAction.direct,
          enabled: true,
          priority: 2,
        ),
      ]);
    }
    
    // 添加自定义规则
    for (int i = 0; i < ruleSettings.customRules.length; i++) {
      final rule = ruleSettings.customRules[i];
      rules.add(ProxyRule(
        id: 'custom-rule-$i',
        name: '自定义规则${i + 1}',
        type: ProxyRuleType.domain,
        matchType: ProxyMatchType.contains,
        match: rule,
        action: ProxyAction.proxy,
        enabled: true,
        priority: 10 + i,
      ));
    }
    
    return rules;
  }
  
  /// 转换流量设置
  static TrafficPerformanceSettings _convertTrafficControlSettings(Map<String, dynamic>? trafficSettings) {
    if (trafficSettings == null) {
      return const TrafficPerformanceSettings();
    }
    
    return TrafficPerformanceSettings(
      maxSpeed: trafficSettings['maxSpeed'] as int? ?? 0,
      bandwidthLimit: trafficSettings['bandwidthLimit'] as int? ?? 0,
      throttle: trafficSettings['throttle'] as bool? ?? false,
      bufferSize: trafficSettings['bufferSize'] as int? ?? 64,
      downloadSpeed: trafficSettings['downloadSpeed'] as int? ?? 0,
      uploadSpeed: trafficSettings['uploadSpeed'] as int? ?? 0,
      connectionTimeout: trafficSettings['connectionTimeout'] as int? ?? 5000,
      keepAlive: trafficSettings['keepAlive'] as bool? ?? true,
    );
  }
  
  /// 转换代理核心设置
  static ProxyCoreSettings? _convertProxyCoreSettings(Map<String, dynamic>? proxyCoreSettings) {
    if (proxyCoreSettings == null) {
      return null;
    }
    
    return ProxyCoreSettings(
      enabled: proxyCoreSettings['enabled'] as bool? ?? true,
      coreType: ProxyCoreType.clashMeta, // 默认值
      coreVersion: proxyCoreSettings['coreVersion'] as String? ?? '',
      corePath: proxyCoreSettings['corePath'] as String? ?? '',
      tempPath: proxyCoreSettings['tempPath'] as String? ?? '',
      workingPath: proxyCoreSettings['workingPath'] as String? ?? '',
      debugMode: proxyCoreSettings['debugMode'] as bool? ?? false,
      autoRestart: proxyCoreSettings['autoRestart'] as bool? ?? true,
      restartInterval: proxyCoreSettings['restartInterval'] as int? ?? 300,
      maxRestartCount: proxyCoreSettings['maxRestartCount'] as int? ?? 3,
      coreArgs: Map<String, String>.from(proxyCoreSettings['coreArgs'] as Map? ?? {}),
      environmentVars: Map<String, String>.from(proxyCoreSettings['environmentVars'] as Map? ?? {}),
    );
  }
  
  /// 验证转换结果的完整性
  static bool validateConversion(ClashCoreSettings original, ProxyConfig converted) {
    // 检查基本字段是否正确转换
    if (original.enabled != converted.enabled) return false;
    if (_convertProxyMode(original.mode) != converted.mode) return false;
    if (original.ipv6 != converted.enableIPv6) return false;
    
    return true;
  }
  
  /// 批量转换节点列表
  static List<ProxyNode> convertNodesFromClashCoreSettings(ClashCoreSettings flClashSettings) {
    return flClashSettings.nodes.nodes;
  }
  
  /// 从 ProxyConfig 批量转换节点到 ClashCoreSettings
  static List<ProxyNode> convertNodesFromProxyConfig(ProxyConfig proxyConfig) {
    return proxyConfig.nodes;
  }
}