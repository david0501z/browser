import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'rule_manager.dart';

/// 模板类型
enum TemplateType {
  network,      // 网络规则模板
  security,     // 安全规则模板
  privacy,      // 隐私保护模板
  performance,  // 性能优化模板
  custom,       // 自定义模板
  industry,     // 行业特定模板
}

/// 模板复杂度
enum TemplateComplexity {
  simple,       // 简单模板
  moderate,     // 中等复杂度
  complex,      // 复杂模板
  advanced,     // 高级模板
}

/// 规则模板
@immutable
class RuleTemplate {
  final String id;
  final String name;
  final String description;
  final TemplateType type;
  final TemplateComplexity complexity;
  final List<RuleConfig> rules;
  final Map<String, dynamic> parameters;
  final List<String> dependencies;
  final String version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? author;
  final String? license;
  final List<String> tags;
  final bool requiresInternet;

  const RuleTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.complexity,
    required this.rules,
    required this.parameters,
    this.dependencies = const [],
    this.version = '1.0',
    required this.createdAt,
    required this.updatedAt,
    this.author,
    this.license,
    this.tags = const [],
    this.requiresInternet = false,
  });

  factory RuleTemplate.fromJson(Map<String, dynamic> json) {
    return RuleTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      TemplateType.values.byName(json['type']),
      TemplateComplexity.values.byName(json['complexity']),
      (json['rules'] as List)
          .map((rule) => RuleConfig.fromJson(rule as Map<String, dynamic>))
          .toList(),
      Map<String, dynamic>.from(json['parameters'] as Map),
      List<String>.from(json['dependencies'] as List),
      json['version'] as String? ?? '1.0',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      author: json['author'] as String?,
      license: json['license'] as String?,
      tags: List<String>.from(json['tags'] as List),
      requiresInternet: json['requiresInternet'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'complexity': complexity.name,
      'rules': rules.map((rule) => rule.toJson()).toList(),
      'parameters': parameters,
      'dependencies': dependencies,
      'version': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'author': author,
      'license': license,
      'tags': tags,
      'requiresInternet': requiresInternet,
    };
  }

  RuleTemplate copyWith({
    String? id,
    String? name,
    String? description,
    TemplateType? type,
    TemplateComplexity? complexity,
    List<RuleConfig>? rules,
    Map<String, dynamic>? parameters,
    List<String>? dependencies,
    String? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? author,
    String? license,
    List<String>? tags,
    bool? requiresInternet,
  }) {
    return RuleTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      complexity: complexity ?? this.complexity,
      rules: rules ?? this.rules,
      parameters: parameters ?? this.parameters,
      dependencies: dependencies ?? this.dependencies,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      author: author ?? this.author,
      license: license ?? this.license,
      tags: tags ?? this.tags,
      requiresInternet: requiresInternet ?? this.requiresInternet,
    );
  }

  /// 获取模板统计信息
  TemplateStats get stats {
    final domainCount = rules.where((r) => r.type == RuleType.domain).length;
    final ipCount = rules.where((r) => r.type == RuleType.ip).length;
    final regexCount = rules.where((r) => r.type == RuleType.regex).length;
    final blockCount = rules.where((r) => r.action == RuleAction.block).length;
    final proxyCount = rules.where((r) => r.action == RuleAction.proxy).length;
    final directCount = rules.where((r) => r.action == RuleAction.direct).length;

    return TemplateStats(
      totalRules: rules.length,
      domainRules: domainCount,
      ipRules: ipCount,
      regexRules: regexCount,
      blockRules: blockCount,
      proxyRules: proxyCount,
      directRules: directCount,
      complexityScore: _calculateComplexityScore(),
    );
  }

  int _calculateComplexityScore() {
    int score = 0;
    
    // 根据规则类型计算复杂度
    for (final rule in rules) {
      switch (rule.type) {
        case RuleType.regex:
          score += 5;
          break;
        case RuleType.cidr:
          score += 3;
          break;
        case RuleType.domain:
          score += 2;
          break;
        case RuleType.ip:
          score += 2;
          break;
        case RuleType.wildcard:
          score += 3;
          break;
        default:
          score += 1;
      }
      
      // 根据规则模式复杂度调整
      if (rule.pattern.length > 100) score += 2;
      if (rule.pattern.contains('*')) score += 1;
      if (rule.pattern.contains('.')) score += 1;
    }
    
    return score;
  }

  @override
  String toString() => 'RuleTemplate(id: $id, name: $name, type: $type, rules: ${rules.length})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RuleTemplate && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// 模板统计信息
class TemplateStats {
  final int totalRules;
  final int domainRules;
  final int ipRules;
  final int regexRules;
  final int blockRules;
  final int proxyRules;
  final int directRules;
  final int complexityScore;

  const TemplateStats({
    required this.totalRules,
    required this.domainRules,
    required this.ipRules,
    required this.regexRules,
    required this.blockRules,
    required this.proxyRules,
    required this.directRules,
    required this.complexityScore,
  });

  /// 获取复杂度描述
  String get complexityDescription {
    if (complexityScore < 10) return '简单';
    if (complexityScore < 30) return '中等';
    if (complexityScore < 50) return '复杂';
    return '高级';
  }
}

/// 模板实例化结果
@immutable
class TemplateInstantiationResult {
  final bool success;
  final String? errorMessage;
  final List<RuleConfig> generatedRules;
  final Map<String, String> warnings;
  final DateTime timestamp;

  const TemplateInstantiationResult({
    required this.success,
    this.errorMessage,
    required this.generatedRules,
    this.warnings = const {},
    required this.timestamp,
  });

  factory TemplateInstantiationResult.success(List<RuleConfig> rules) {
    return TemplateInstantiationResult(
      success: true,
      generatedRules: rules,
      timestamp: DateTime.now(),
    );
  }

  factory TemplateInstantiationResult.failure(String message, {Map<String, String>? warnings}) {
    return TemplateInstantiationResult(
      success: false,
      errorMessage: message,
      generatedRules: [],
      warnings: warnings ?? {},
      timestamp: DateTime.now(),
    );
  }
}

/// 规则模板管理器
class RuleTemplateManager extends ChangeNotifier {
  static RuleTemplateManager? _instance;
  static RuleTemplateManager get instance => _instance ??= RuleTemplateManager._();

  RuleTemplateManager._();

  final Map<String, RuleTemplate> _templates = {};
  final List<String> _templateCategories = [
    '网络访问',
    '安全防护',
    '隐私保护',
    '性能优化',
    '广告拦截',
    '游戏优化',
    '企业办公',
    '教育机构',
  ];

  // 文件操作相关
  static const String _templatesFileName = 'rule_templates.json';
  static const String _templatesDirName = 'templates';

  /// 获取所有模板
  List<RuleTemplate> get templates => _templates.values.toList();

  /// 获取按类型分类的模板
  Map<TemplateType, List<RuleTemplate>> get templatesByType {
    final Map<TemplateType, List<RuleTemplate>> result = {};
    for (final template in _templates.values) {
      result.putIfAbsent(template.type, () => []).add(template);
    }
    return result;
  }

  /// 获取可用的模板名称
  List<String> get availableTemplates => _templates.keys.toList();

  /// 获取模板分类
  List<String> get categories => List.unmodifiable(_templateCategories);

  /// 初始化模板管理器
  Future<void> initialize() async {
    await loadFromFile();
    
    if (_templates.isEmpty) {
      await _createDefaultTemplates();
    }
    
    notifyListeners();
  }

  /// 创建默认模板
  Future<void> _createDefaultTemplates() async {
    final now = DateTime.now();
    
    // 创建内置模板
    await _createBuiltInTemplates(now);
    
    // 创建网络模板
    await _createNetworkTemplates(now);
    
    // 创建安全模板
    await _createSecurityTemplates(now);
    
    // 创建隐私模板
    await _createPrivacyTemplates(now);
    
    // 创建性能模板
    await _createPerformanceTemplates(now);
    
    await _saveToFile();
  }

  /// 创建内置模板
  Future<void> _createBuiltInTemplates(DateTime now) async {
    final builtinTemplates = <RuleTemplate>[
      // 基础网络访问模板
      RuleTemplate(
        id: 'basic_network_access',
        name: '基础网络访问',
        description: '提供基本的网络访问规则，包括常用域名和IP地址',
        type: TemplateType.network,
        complexity: TemplateComplexity.simple,
        rules: [
          RuleConfig(
            id: 'basic_google',
            name: 'Google服务',
            type: RuleType.domain,
            pattern: '*.google.com',
            action: RuleAction.proxy,
            priority: RulePriority.normal,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
          RuleConfig(
            id: 'basic_github',
            name: 'GitHub服务',
            type: RuleType.domain,
            pattern: '*.github.com',
            action: RuleAction.proxy,
            priority: RulePriority.normal,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        parameters: {
          'enableCustomDomains': true,
          'customDomains': [],
          'priority': 'normal',
        },
        version: '1.0',
        createdAt: now,
        updatedAt: now,
        author: 'System',
        tags: ['基础', '网络'],
      ),
      
      // 广告拦截模板
      RuleTemplate(
        id: 'ad_blocking',
        name: '广告拦截',
        description: '拦截常见广告域名和追踪器',
        type: TemplateType.network,
        complexity: TemplateComplexity.moderate,
        rules: [
          RuleConfig(
            id: 'ad_google_ads',
            name: 'Google广告',
            type: RuleType.domain,
            pattern: '*.doubleclick.net',
            action: RuleAction.block,
            priority: RulePriority.high,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
          RuleConfig(
            id: 'ad_facebook_ads',
            name: 'Facebook广告',
            type: RuleType.domain,
            pattern: '*.facebook.com',
            action: RuleAction.proxy,
            priority: RulePriority.normal,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        parameters: {
          'blockLevel': 'aggressive',
          'whitelist': [],
          'customRules': [],
        },
        version: '1.0',
        createdAt: now,
        updatedAt: now,
        author: 'System',
        tags: ['广告', '隐私'],
      ),
    ];

    for (final template in builtinTemplates) {
      _templates[template.id] = template;
    }
  }

  /// 创建网络模板
  Future<void> _createNetworkTemplates(DateTime now) async {
    final networkTemplates = <RuleTemplate>[
      RuleTemplate(
        id: 'social_media',
        name: '社交媒体优化',
        description: '优化社交媒体平台的访问规则',
        type: TemplateType.network,
        complexity: TemplateComplexity.moderate,
        rules: [
          RuleConfig(
            id: 'social_facebook',
            name: 'Facebook',
            type: RuleType.domain,
            pattern: '*.facebook.com',
            action: RuleAction.proxy,
            priority: RulePriority.normal,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
          RuleConfig(
            id: 'social_twitter',
            name: 'Twitter/X',
            type: RuleType.domain,
            pattern: '*.twitter.com',
            action: RuleAction.proxy,
            priority: RulePriority.normal,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
          RuleConfig(
            id: 'social_youtube',
            name: 'YouTube',
            type: RuleType.domain,
            pattern: '*.youtube.com',
            action: RuleAction.proxy,
            priority: RulePriority.normal,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        parameters: {
          'videoQuality': 'auto',
          'enableCDN': true,
          'optimizeStreaming': true,
        },
        version: '1.0',
        createdAt: now,
        updatedAt: now,
        author: 'System',
        tags: ['社交', '视频'],
      ),
      
      RuleTemplate(
        id: 'streaming_services',
        name: '流媒体服务',
        description: '优化流媒体服务的访问规则',
        type: TemplateType.network,
        complexity: TemplateComplexity.complex,
        rules: [
          RuleConfig(
            id: 'stream_netflix',
            name: 'Netflix',
            type: RuleType.domain,
            pattern: '*.netflix.com',
            action: RuleAction.proxy,
            priority: RulePriority.normal,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
          RuleConfig(
            id: 'stream_disney',
            name: 'Disney+',
            type: RuleType.domain,
            pattern: '*.disneyplus.com',
            action: RuleAction.proxy,
            priority: RulePriority.normal,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        parameters: {
          'videoQuality': '4K',
          'enableSubtitles': true,
          'region': 'auto',
        },
        version: '1.0',
        createdAt: now,
        updatedAt: now,
        author: 'System',
        tags: ['流媒体', '视频'],
      ),
    ];

    for (final template in networkTemplates) {
      _templates[template.id] = template;
    }
  }

  /// 创建安全模板
  Future<void> _createSecurityTemplates(DateTime now) async {
    final securityTemplates = <RuleTemplate>[
      RuleTemplate(
        id: 'malware_protection',
        name: '恶意软件防护',
        description: '拦截已知恶意软件和钓鱼网站',
        type: TemplateType.security,
        complexity: TemplateComplexity.complex,
        rules: [
          RuleConfig(
            id: 'sec_malware_blocklist',
            name: '恶意软件黑名单',
            type: RuleType.domain,
            pattern: '*.malware-domain.com',
            action: RuleAction.block,
            priority: RulePriority.critical,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
          RuleConfig(
            id: 'sec_phishing_blocklist',
            name: '钓鱼网站黑名单',
            type: RuleType.domain,
            pattern: '*.phishing-site.com',
            action: RuleAction.block,
            priority: RulePriority.critical,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        parameters: {
          'updateFrequency': 'daily',
          'threatLevel': 'high',
          'enableRealTime': true,
        },
        version: '1.0',
        createdAt: now,
        updatedAt: now,
        author: 'System',
        tags: ['安全', '恶意软件'],
        requiresInternet: true,
      ),
    ];

    for (final template in securityTemplates) {
      _templates[template.id] = template;
    }
  }

  /// 创建隐私模板
  Future<void> _createPrivacyTemplates(DateTime now) async {
    final privacyTemplates = <RuleTemplate>[
      RuleTemplate(
        id: 'privacy_protection',
        name: '隐私保护',
        description: '保护用户隐私，阻止追踪器和数据收集',
        type: TemplateType.privacy,
        complexity: TemplateComplexity.moderate,
        rules: [
          RuleConfig(
            id: 'privacy_google_analytics',
            name: 'Google Analytics',
            type: RuleType.domain,
            pattern: '*.google-analytics.com',
            action: RuleAction.block,
            priority: RulePriority.high,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
          RuleConfig(
            id: 'privacy_facebook_pixel',
            name: 'Facebook Pixel',
            type: RuleType.domain,
            pattern: '*.facebook.net',
            action: RuleAction.block,
            priority: RulePriority.high,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        parameters: {
          'blockLevel': 'strict',
          'preserveFunctionality': true,
          'customBlocklist': [],
        },
        version: '1.0',
        createdAt: now,
        updatedAt: now,
        author: 'System',
        tags: ['隐私', '追踪'],
      ),
    ];

    for (final template in privacyTemplates) {
      _templates[template.id] = template;
    }
  }

  /// 创建性能模板
  Future<void> _createPerformanceTemplates(DateTime now) async {
    final performanceTemplates = <RuleTemplate>[
      RuleTemplate(
        id: 'performance_optimization',
        name: '性能优化',
        description: '优化网络访问性能，缓存常用资源',
        type: TemplateType.performance,
        complexity: TemplateComplexity.moderate,
        rules: [
          RuleConfig(
            id: 'perf_cdn_fastly',
            name: 'Fastly CDN',
            type: RuleType.domain,
            pattern: '*.fastly.com',
            action: RuleAction.direct,
            priority: RulePriority.high,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
          RuleConfig(
            id: 'perf_cloudflare_cdn',
            name: 'Cloudflare CDN',
            type: RuleType.domain,
            pattern: '*.cloudflare.com',
            action: RuleAction.direct,
            priority: RulePriority.high,
            enabled: true,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        parameters: {
          'enableCompression': true,
          'cacheLevel': 'aggressive',
          'dnsOptimization': true,
        },
        version: '1.0',
        createdAt: now,
        updatedAt: now,
        author: 'System',
        tags: ['性能', '优化'],
      ),
    ];

    for (final template in performanceTemplates) {
      _templates[template.id] = template;
    }
  }

  /// 从模板创建规则
  Future<RuleConfig> createRuleFromTemplate(String templateName, Map<String, dynamic>? customParams) async {
    if (!_templates.containsKey(templateName)) {
      throw ArgumentError('模板不存在: $templateName');
    }

    final template = _templates[templateName]!;
    final result = await instantiateTemplate(templateName, customParams);
    
    if (!result.success) {
      throw ArgumentError('模板实例化失败: ${result.errorMessage}');
    }

    if (result.generatedRules.isEmpty) {
      throw ArgumentError('模板没有生成任何规则');
    }

    return result.generatedRules.first;
  }

  /// 实例化模板
  Future<TemplateInstantiationResult> instantiateTemplate(
    String templateId, 
    Map<String, dynamic>? customParams
  ) async {
    if (!_templates.containsKey(templateId)) {
      return TemplateInstantiationResult.failure('模板不存在: $templateId');
    }

    final template = _templates[templateId]!;
    final warnings = <String, String>{};

    try {
      final generatedRules = <RuleConfig>[];
      
      for (final templateRule in template.rules) {
        // 合并参数
        final mergedParams = Map<String, dynamic>.from(template.parameters);
        if (customParams != null) {
          mergedParams.addAll(customParams);
        }

        // 根据参数生成具体规则
        final rule = await _generateRuleFromTemplate(templateRule, mergedParams, warnings);
        generatedRules.add(rule);
      }

      return TemplateInstantiationResult.success(generatedRules);
    } catch (e) {
      return TemplateInstantiationResult.failure('模板实例化失败: $e', warnings: warnings);
    }
  }

  /// 从模板生成具体规则
  Future<RuleConfig> _generateRuleFromTemplate(
    RuleConfig templateRule,
    Map<String, dynamic> parameters,
    Map<String, String> warnings
  ) async {
    var pattern = templateRule.pattern;
    
    // 处理参数替换
    if (parameters.containsKey('customDomains') && 
        templateRule.type == RuleType.domain) {
      final customDomains = parameters['customDomains'] as List<String>?;
      if (customDomains != null && customDomains.isNotEmpty) {
        // 使用自定义域名替换原有模式
        pattern = customDomains.first;
        warnings['customDomains'] = '使用自定义域名替换模板域名';
      }
    }

    if (parameters.containsKey('customIP') && 
        templateRule.type == RuleType.ip) {
      final customIP = parameters['customIP'] as String?;
      if (customIP != null) {
        pattern = customIP;
        warnings['customIP'] = '使用自定义IP地址替换模板IP';
      }
    }

    // 处理动作参数
    var action = templateRule.action;
    if (parameters.containsKey('overrideAction')) {
      try {
        final overrideAction = parameters['overrideAction'] as String;
        action = RuleAction.values.byName(overrideAction);
        warnings['overrideAction'] = '覆盖模板默认动作';
      } catch (e) {
        warnings['overrideAction'] = '无效的动作类型，使用默认动作';
      }
    }

    // 处理优先级参数
    var priority = templateRule.priority;
    if (parameters.containsKey('customPriority')) {
      final customPriority = parameters['customPriority'] as int?;
      if (customPriority != null && 
          customPriority >= RulePriority.lowest && 
          customPriority <= RulePriority.critical) {
        priority = customPriority;
        warnings['customPriority'] = '使用自定义优先级';
      }
    }

    return templateRule.copyWith(
      pattern: pattern,
      action: action,
      priority: priority,
      updatedAt: DateTime.now(),
    );
  }

  /// 搜索模板
  List<RuleTemplate> searchTemplates(String query) {
    query = query.toLowerCase();
    return _templates.values.where((template) {
      return template.name.toLowerCase().contains(query) ||
             template.description.toLowerCase().contains(query) ||
             template.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  /// 按类型筛选模板
  List<RuleTemplate> filterTemplatesByType(TemplateType type) {
    return _templates.values.where((template) => template.type == type).toList();
  }

  /// 按复杂度筛选模板
  List<RuleTemplate> filterTemplatesByComplexity(TemplateComplexity complexity) {
    return _templates.values.where((template) => template.complexity == complexity).toList();
  }

  /// 按标签筛选模板
  List<RuleTemplate> filterTemplatesByTag(String tag) {
    tag = tag.toLowerCase();
    return _templates.values.where((template) {
      return template.tags.any((t) => t.toLowerCase() == tag);
    }).toList();
  }

  /// 获取推荐模板
  List<RuleTemplate> getRecommendedTemplates({int limit = 5}) {
    // 简单的推荐算法：基于模板的使用频率和评分
    final templates = _templates.values.toList();
    templates.sort((a, b) {
      // 优先推荐简单模板和新创建的模板
      final aScore = _calculateRecommendationScore(a);
      final bScore = _calculateRecommendationScore(b);
      return bScore.compareTo(aScore);
    });
    
    return templates.take(limit).toList();
  }

  int _calculateRecommendationScore(RuleTemplate template) {
    int score = 0;
    
    // 复杂度分数（简单模板得分更高）
    switch (template.complexity) {
      case TemplateComplexity.simple:
        score += 10;
        break;
      case TemplateComplexity.moderate:
        score += 8;
        break;
      case TemplateComplexity.complex:
        score += 6;
        break;
      case TemplateComplexity.advanced:
        score += 4;
        break;
    }
    
    // 规则数量分数
    final ruleCount = template.rules.length;
    if (ruleCount >= 5 && ruleCount <= 50) {
      score += 5; // 适中的规则数量
    } else if (ruleCount > 0) {
      score += 2;
    }
    
    // 标签分数
    score += template.tags.length;
    
    // 版本分数（较新版本得分更高）
    final version = double.tryParse(template.version) ?? 1.0;
    score += version.toInt();
    
    return score;
  }

  /// 添加自定义模板
  Future<void> addTemplate(RuleTemplate template) async {
    if (_templates.containsKey(template.id)) {
      throw ArgumentError('模板ID已存在: ${template.id}');
    }

    // 验证模板
    final validationResult = _validateTemplate(template);
    if (!validationResult.isValid) {
      throw ArgumentError('模板验证失败: ${validationResult.errorMessage}');
    }

    _templates[template.id] = template;
    await _saveToFile();
    notifyListeners();
  }

  /// 更新模板
  Future<void> updateTemplate(RuleTemplate template) async {
    if (!_templates.containsKey(template.id)) {
      throw ArgumentError('模板不存在: ${template.id}');
    }

    final updatedTemplate = template.copyWith(updatedAt: DateTime.now());
    
    // 验证更新后的模板
    final validationResult = _validateTemplate(updatedTemplate);
    if (!validationResult.isValid) {
      throw ArgumentError('模板验证失败: ${validationResult.errorMessage}');
    }

    _templates[template.id] = updatedTemplate;
    await _saveToFile();
    notifyListeners();
  }

  /// 删除模板
  Future<void> removeTemplate(String templateId) async {
    if (!_templates.containsKey(templateId)) {
      throw ArgumentError('模板不存在: $templateId');
    }

    _templates.remove(templateId);
    await _saveToFile();
    notifyListeners();
  }

  /// 验证模板
  ValidationResult _validateTemplate(RuleTemplate template) {
    // 基本验证
    if (template.id.isEmpty) {
      return ValidationResult.failure('模板ID不能为空');
    }

    if (template.name.isEmpty) {
      return ValidationResult.failure('模板名称不能为空');
    }

    if (template.rules.isEmpty) {
      return ValidationResult.failure('模板不能为空规则');
    }

    // 验证规则中的ID唯一性
    final ruleIds = <String>{};
    for (final rule in template.rules) {
      if (ruleIds.contains(rule.id)) {
        return ValidationResult.failure('模板中规则ID重复: ${rule.id}');
      }
      ruleIds.add(rule.id);
    }

    return ValidationResult.success();
  }

  /// 导出模板
  Future<String> exportTemplate(String templateId) async {
    if (!_templates.containsKey(templateId)) {
      throw ArgumentError('模板不存在: $templateId');
    }

    final template = _templates[templateId]!;
    final exportData = {
      'template': template.toJson(),
      'exportedAt': DateTime.now().toIso8601String(),
      'version': '1.0',
    };

    return json.encode(exportData);
  }

  /// 导入模板
  Future<void> importTemplate(String jsonData) async {
    try {
      final data = json.decode(jsonData);
      if (data case {'template': final Map<String, dynamic> templateData}) {
        final template = RuleTemplate.fromJson(templateData);
        await addTemplate(template);
      } else {
        throw ArgumentError('无效的模板数据格式');
      }
    } catch (e) {
      throw ArgumentError('导入模板失败: $e');
    }
  }

  /// 获取模板统计信息
  Map<String, dynamic> getTemplateStatistics() {
    final stats = {
      'totalTemplates': _templates.length,
      'byType': <TemplateType, int>{},
      'byComplexity': <TemplateComplexity, int>{},
      'totalRules': 0,
      'averageRulesPerTemplate': 0.0,
      'mostUsedTags': <String, int>{},
    };

    for (final template in _templates.values) {
      // 按类型统计
      stats['byType'][template.type] = (stats['byType'][template.type] ?? 0) + 1;
      
      // 按复杂度统计
      stats['byComplexity'][template.complexity] = (stats['byComplexity'][template.complexity] ?? 0) + 1;
      
      // 规则统计
      stats['totalRules'] += template.rules.length;
      
      // 标签统计
      for (final tag in template.tags) {
        stats['mostUsedTags'][tag] = (stats['mostUsedTags'][tag] ?? 0) + 1;
      }
    }

    if (_templates.isNotEmpty) {
      stats['averageRulesPerTemplate'] = (stats['totalRules'] as int) / _templates.length;
    }

    return stats;
  }

  /// 文件操作
  Future<File> _getTemplatesFile() async {
    final directory = await _getTemplatesDirectory();
    return File(path.join(directory.path, _templatesFileName));
  }

  Future<Directory> _getTemplatesDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final templatesDir = Directory(path.join(appDocDir.path, _templatesDirName));
    
    if (!await templatesDir.exists()) {
      await templatesDir.create(recursive: true);
    }
    
    return templatesDir;
  }

  Future<void> _saveToFile() async {
    try {
      final file = await _getTemplatesFile();
      final data = {
        'templates': _templates.values.map((template) => template.toJson()).toList(),
        'lastModified': DateTime.now().toIso8601String(),
        'version': '1.0',
      };
      
      await file.writeAsString(json.encode(data), flush: true);
    } catch (e) {
      debugPrint('保存模板配置失败: $e');
      rethrow;
    }
  }

  Future<void> loadFromFile() async {
    try {
      final file = await _getTemplatesFile();
      if (!await file.exists()) {
        return;
      }

      final content = await file.readAsString();
      final data = json.decode(content) as Map<String, dynamic>;
      
      _templates.clear();
      
      for (final templateJson in data['templates'] as List) {
        final template = RuleTemplate.fromJson(templateJson as Map<String, dynamic>);
        _templates[template.id] = template;
      }
    } catch (e) {
      debugPrint('加载模板配置失败: $e');
    }
  }

  /// 清理资源
  @override
  void dispose() {
    _templates.clear();
    super.dispose();
  }
}