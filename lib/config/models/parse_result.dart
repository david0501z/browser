/// 解析结果类
class ParseResult {
  /// 解析后的配置
  final Map<String, dynamic> config;
  
  /// 代理列表
  final List<ProxyConfig> proxyList;
  
  /// 代理组列表
  final List<ProxyGroupConfig> proxyGroups;
  
  /// 规则列表
  final List<RuleItem> rules;
  
  /// 规则提供者列表
  final List<RuleProvider> ruleProviders;
  
  /// 原始YAML内容
  final String rawYaml;

  const ParseResult({
    required this.config,
    required this.proxyList,
    required this.proxyGroups,
    required this.rules,
    required this.ruleProviders,
    required this.rawYaml,
  });

  /// 从JSON创建
  factory ParseResult.fromJson(Map<String, dynamic> json) {
    return ParseResult(
      config: json['config'] ?? {},
      proxyList: json['proxyList'] != null 
          ? (json['proxyList'] as List).map((proxy) => ProxyConfig.fromJson(proxy)).toList() 
          : [],
      proxyGroups: json['proxyGroups'] != null 
          ? (json['proxyGroups'] as List).map((group) => ProxyGroupConfig.fromJson(group)).toList() 
          : [],
      rules: json['rules'] != null 
          ? (json['rules'] as List).map((rule) => RuleItem.fromJson(rule)).toList() 
          : [],
      ruleProviders: json['ruleProviders'] != null 
          ? (json['ruleProviders'] as List).map((provider) => RuleProvider.fromJson(provider)).toList() 
          : [],
      rawYaml: json['rawYaml'] ?? '',
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'config': config,
      'proxyList': proxyList.map((proxy) => proxy.toJson()).toList(),
      'proxyGroups': proxyGroups.map((group) => group.toJson()).toList(),
      'rules': rules.map((rule) => rule.toJson()).toList(),
      'ruleProviders': ruleProviders.map((provider) => provider.toJson()).toList(),
      'rawYaml': rawYaml,
    };
  }

  @override
  String toString() {
    return 'ParseResult{proxies: ${proxyList.length}, groups: ${proxyGroups.length}, rules: ${rules.length}, providers: ${ruleProviders.length}}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ParseResult &&
        other.config == config &&
        other.proxyList == proxyList &&
        other.proxyGroups == proxyGroups &&
        other.rules == rules &&
        other.ruleProviders == ruleProviders &&
        other.rawYaml == rawYaml;
  }

  @override
  int get hashCode {
    return config.hashCode ^
        proxyList.hashCode ^
        proxyGroups.hashCode ^
        rules.hashCode ^
        ruleProviders.hashCode ^
        rawYaml.hashCode;
  }
}

/// 解析异常类
class ParseException implements Exception {
  final String message;
  final dynamic cause;

  const ParseException(this.message, [this.cause]);

  @override
  String toString() {
    return 'ParseException{message: $message, cause: $cause}';
  }
}

/// 配置生成异常类
class ConfigGenerationException implements Exception {
  final String message;
  final dynamic cause;

  const ConfigGenerationException(this.message, [this.cause]);

  @override
  String toString() {
    return 'ConfigGenerationException{message: $message, cause: $cause}';
  }
}