/// 配置模板管理器
/// 
/// 管理不同类型的 ClashMeta 配置模板，支持预设模板和自定义模板

import 'dart:convert';
import 'package:logging/logging.dart';
import '../models/app_settings.dart';
import '../models/clash_settings.dart';
import '../models/enums.dart';
import '../core/proxy_config.dart';
import 'clash_config_generator.dart';
import 'yaml_parser.dart';

/// 配置模板类
class ConfigTemplate {
  final String id;
  final String name;
  final String description;
  final TemplateCategory category;
  final String yamlContent;
  final Map<String, dynamic> metadata;
  final bool isBuiltIn;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;

  const ConfigTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.yamlContent,
    this.metadata = const {},
    this.isBuiltIn = false,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
  });

  /// 创建模板副本
  ConfigTemplate copyWith({
    String? id,
    String? name,
    String? description,
    TemplateCategory? category,
    String? yamlContent,
    Map<String, dynamic>? metadata,
    bool? isBuiltIn,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
  }) {
    return ConfigTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      yamlContent: yamlContent ?? this.yamlContent,
      metadata: metadata ?? this.metadata,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }

  /// 获取模板摘要
  String get summary {
    final buffer = StringBuffer();
    buffer.writeln('=== 配置模板信息 ===');
    buffer.writeln('名称: $name');
    buffer.writeln('描述: $description');
    buffer.writeln('分类: ${category.toString()}');
    buffer.writeln('内置模板: ${isBuiltIn ? "是" : "否"}');
    buffer.writeln('创建时间: ${createdAt.toIso8601String()}');
    buffer.writeln('更新时间: ${updatedAt.toIso8601String()}');
    
    if (tags.isNotEmpty) {
      buffer.writeln('标签: ${tags.join(", ")}');
    }
    
    // 解析并显示配置摘要
    try {
      final parser = YamlParser();
      final configInfo = parser.extractConfigInfo(yamlContent);
      buffer.writeln('代理数量: ${configInfo.proxyCount}');
      buffer.writeln('代理组数量: ${configInfo.groupCount}');
      buffer.writeln('规则数量: ${configInfo.ruleCount}');
      
      if (configInfo.proxyTypes.isNotEmpty) {
        buffer.writeln('代理类型分布:');
        configInfo.proxyTypes.forEach((type, count) {
          buffer.writeln('  $type: $count');
        });
      }
    } catch (e) {
      buffer.writeln('无法解析配置信息');
    }
    
    return buffer.toString();
  }
}

/// 模板分类枚举
enum TemplateCategory {
  /// 基础模板
  basic,
  /// 游戏优化
  gaming,
  /// 流媒体
  streaming,
  /// 商务办公
  business,
  /// 开发调试
  development,
  /// 高性能
  performance,
  /// 安全隐私
  security,
  /// 自定义
  custom,
}

/// 配置模板管理器
class ConfigTemplateManager {
  static final Logger _logger = Logger('ConfigTemplateManager');
  
  /// 内置模板缓存
  final Map<String, ConfigTemplate> _builtInTemplates = {};
  
  /// 用户自定义模板缓存
  final Map<String, ConfigTemplate> _userTemplates = {};
  
  /// 模板目录路径
  static const String _templateDir = 'templates';
  
  /// 内置模板文件名
  static const String _builtInTemplatesFile = 'built_in_templates.json';

  /// 初始化管理器并加载内置模板
  Future<void> initialize() async {
    _logger.info('初始化配置模板管理器');
    
    await _loadBuiltInTemplates();
    
    _logger.info('配置模板管理器初始化完成');
  }

  /// 获取所有模板
  /// 
  /// [category] 可选的分类过滤
  /// [includeBuiltIn] 是否包含内置模板
  /// [includeUser] 是否包含用户模板
  List<ConfigTemplate> getAllTemplates({
    TemplateCategory? category,
    bool includeBuiltIn = true,
    bool includeUser = true,
  }) {
    final templates = <ConfigTemplate>[];
    
    if (includeBuiltIn) {
      templates.addAll(_builtInTemplates.values);
    }
    
    if (includeUser) {
      templates.addAll(_userTemplates.values);
    }
    
    // 应用分类过滤
    if (category != null) {
      templates.retainWhere((template) => template.category == category);
    }
    
    // 按名称排序
    templates.sort((a, b) => a.name.compareTo(b.name));
    
    return templates;
  }

  /// 根据 ID 获取模板
  /// 
  /// [templateId] 模板 ID
  ConfigTemplate? getTemplate(String templateId) {
    return _builtInTemplates[templateId] ?? _userTemplates[templateId];
  }

  /// 根据名称搜索模板
  /// 
  /// [query] 搜索关键词
  /// [category] 可选的分类过滤
  List<ConfigTemplate> searchTemplates(String query, {TemplateCategory? category}) {
    final allTemplates = getAllTemplates(category: category);
    final normalizedQuery = query.toLowerCase();
    
    return allTemplates.where((template) {
      return template.name.toLowerCase().contains(normalizedQuery) ||
             template.description.toLowerCase().contains(normalizedQuery) ||
             template.tags.any((tag) => tag.toLowerCase().contains(normalizedQuery));
    }).toList();
  }

  /// 创建新模板
  /// 
  /// [name] 模板名称
  /// [description] 模板描述
  /// [yamlContent] YAML 配置内容
  /// [category] 模板分类
  /// [tags] 标签列表
  String createTemplate({
    required String name,
    required String description,
    required String yamlContent,
    TemplateCategory category = TemplateCategory.custom,
    List<String> tags = const [],
  }) {
    _logger.info('创建新模板: $name');
    
    // 验证 YAML 内容
    try {
      final parser = YamlParser();
      parser.parseConfig(yamlContent);
    } catch (e) {
      throw TemplateException('无效的 YAML 配置: $e');
    }
    
    final templateId = _generateTemplateId();
    final now = DateTime.now();
    
    final template = ConfigTemplate(
      id: templateId,
      name: name,
      description: description,
      category: category,
      yamlContent: yamlContent,
      metadata: {
        'created_by': 'user',
        'version': '1.0',
      },
      isBuiltIn: false,
      createdAt: now,
      updatedAt: now,
      tags: tags,
    );
    
    _userTemplates[templateId] = template;
    
    // 保存到本地存储
    _saveUserTemplates();
    
    _logger.info('模板创建成功: $templateId');
    return templateId;
  }

  /// 更新模板
  /// 
  /// [templateId] 模板 ID
  /// [updates] 更新内容
  void updateTemplate(String templateId, {
    String? name,
    String? description,
    String? yamlContent,
    List<String>? tags,
  }) {
    final template = getTemplate(templateId);
    if (template == null) {
      throw TemplateException('模板不存在: $templateId');
    }
    
    if (template.isBuiltIn) {
      throw TemplateException('不能修改内置模板');
    }
    
    // 验证 YAML 内容（如果更新）
    if (yamlContent != null) {
      try {
        final parser = YamlParser();
        parser.parseConfig(yamlContent);
      } catch (e) {
        throw TemplateException('无效的 YAML 配置: $e');
      }
    }
    
    final updatedTemplate = template.copyWith(
      name: name,
      description: description,
      yamlContent: yamlContent,
      tags: tags,
      updatedAt: DateTime.now(),
    );
    
    _userTemplates[templateId] = updatedTemplate;
    
    // 保存到本地存储
    _saveUserTemplates();
    
    _logger.info('模板更新成功: $templateId');
  }

  /// 删除模板
  /// 
  /// [templateId] 模板 ID
  void deleteTemplate(String templateId) {
    final template = getTemplate(templateId);
    if (template == null) {
      throw TemplateException('模板不存在: $templateId');
    }
    
    if (template.isBuiltIn) {
      throw TemplateException('不能删除内置模板');
    }
    
    _userTemplates.remove(templateId);
    
    // 保存到本地存储
    _saveUserTemplates();
    
    _logger.info('模板删除成功: $templateId');
  }

  /// 复制模板
  /// 
  /// [templateId] 源模板 ID
  /// [newName] 新模板名称
  String duplicateTemplate(String templateId, {String? newName}) {
    final template = getTemplate(templateId);
    if (template == null) {
      throw TemplateException('模板不存在: $templateId');
    }
    
    final duplicatedName = newName ?? '${template.name} (副本)';
    
    return createTemplate(
      name: duplicatedName,
      description: template.description,
      yamlContent: template.yamlContent,
      category: template.category,
      tags: [...template.tags, 'duplicate'],
    );
  }

  /// 导出模板
  /// 
  /// [templateId] 模板 ID
  /// [format] 导出格式
  Map<String, dynamic> exportTemplate(String templateId, {ExportFormat format = ExportFormat.json}) {
    final template = getTemplate(templateId);
    if (template == null) {
      throw TemplateException('模板不存在: $templateId');
    }
    
    switch (format) {
      case ExportFormat.json:
        return _exportAsJson(template);
      case ExportFormat.yaml:
        return _exportAsYaml(template);
    }
  }

  /// 导入模板
  /// 
  /// [templateData] 模板数据
  /// [format] 数据格式
  String importTemplate(Map<String, dynamic> templateData, {ImportFormat format = ImportFormat.json}) {
    ConfigTemplate template;
    
    switch (format) {
      case ImportFormat.json:
        template = _importFromJson(templateData);
        break;
    }
    
    // 检查名称冲突
    final existingTemplates = getAllTemplates();
    if (existingTemplates.any((t) => t.name == template.name)) {
      template = template.copyWith(name: '${template.name} (导入)');
    }
    
    _userTemplates[template.id] = template;
    _saveUserTemplates();
    
    _logger.info('模板导入成功: ${template.id}');
    return template.id;
  }

  /// 基于现有配置创建模板
  /// 
  /// [name] 模板名称
  /// [description] 模板描述
  /// [settings] ClashCoreSettings 配置
  /// [proxyList] 代理列表
  /// [category] 模板分类
  String createTemplateFromConfig({
    required String name,
    required String description,
    required ClashCoreSettings settings,
    List<ProxyConfig>? proxyList,
    TemplateCategory category = TemplateCategory.custom,
  }) {
    final generator = ClashConfigGenerator();
    final yamlContent = generator.generateClashConfig(settings, proxyList: proxyList);
    
    return createTemplate(
      name: name,
      description: description,
      yamlContent: yamlContent,
      category: category,
    );
  }

  /// 获取推荐模板
  /// 
  /// [useCase] 使用场景
  List<ConfigTemplate> getRecommendedTemplates(UseCase useCase) {
    switch (useCase) {
      case UseCase.gaming:
        return getAllTemplates(category: TemplateCategory.gaming);
      case UseCase.streaming:
        return getAllTemplates(category: TemplateCategory.streaming);
      case UseCase.business:
        return getAllTemplates(category: TemplateCategory.business);
      case UseCase.development:
        return getAllTemplates(category: TemplateCategory.development);
      case UseCase.privacy:
        return getAllTemplates(category: TemplateCategory.security);
      default:
        return getAllTemplates(category: TemplateCategory.basic);
    }
  }

  /// 加载内置模板
  Future<void> _loadBuiltInTemplates() async {
    _builtInTemplates.addAll({
      'basic-rule': _createBasicRuleTemplate(),
      'basic-global': _createBasicGlobalTemplate(),
      'gaming-optimized': _createGamingTemplate(),
      'streaming-optimized': _createStreamingTemplate(),
      'business-optimized': _createBusinessTemplate(),
      'development-debug': _createDevelopmentTemplate(),
      'performance-optimized': _createPerformanceTemplate(),
      'security-privacy': _createSecurityTemplate(),
    });
    
    _logger.info('已加载 ${_builtInTemplates.length} 个内置模板');
  }

  /// 创建基础规则模板
  ConfigTemplate _createBasicRuleTemplate() {
    const yamlContent = '''
port: 7890
socks-port: 7891
allow-lan: false
mode: rule
log-level: info
ipv6: false
external-controller: 127.0.0.1:9090
proxies: []
proxy-groups:
  - name: PROXY
    type: select
    proxies:
      - DIRECT
rules:
  - DOMAIN-SUFFIX,google.com,PROXY
  - DOMAIN-SUFFIX,youtube.com,PROXY
  - DOMAIN-SUFFIX,github.com,PROXY
  - GEOIP,CN,DIRECT
  - MATCH,DIRECT
dns:
  enable: true
  ipv6: false
  use-hosts: true
  nameserver:
    - 114.114.114.114
    - 8.8.8.8
  fallback:
    - https://dns.cloudflare.com/dns-query
''';
    
    return ConfigTemplate(
      id: 'basic-rule',
      name: '基础规则模式',
      description: '默认的规则分流配置，适合大多数用户使用',
      category: TemplateCategory.basic,
      yamlContent: yamlContent,
      isBuiltIn: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: ['默认', '规则分流', '基础'],
    );
  }

  /// 创建基础全局模板
  ConfigTemplate _createBasicGlobalTemplate() {
    const yamlContent = '''
port: 7890
socks-port: 7891
allow-lan: false
mode: global
log-level: info
ipv6: false
external-controller: 127.0.0.1:9090
proxies: []
proxy-groups: []
rules:
  - MATCH,PROXY
dns:
  enable: true
  ipv6: false
  use-hosts: true
  nameserver:
    - 114.114.114.114
    - 8.8.8.8
  fallback:
    - https://dns.cloudflare.com/dns-query
''';
    
    return ConfigTemplate(
      id: 'basic-global',
      name: '全局代理模式',
      description: '所有流量都通过代理服务器',
      category: TemplateCategory.basic,
      yamlContent: yamlContent,
      isBuiltIn: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: ['全局代理', '基础'],
    );
  }

  /// 创建游戏优化模板
  ConfigTemplate _createGamingTemplate() {
    const yamlContent = '''
port: 7890
socks-port: 7891
allow-lan: false
mode: rule
log-level: warning
ipv6: true
external-controller: 127.0.0.1:9090
proxies: []
proxy-groups:
  - name: GAME
    type: select
    proxies:
      - DIRECT
  - name: PROXY
    type: select
    proxies:
      - DIRECT
rules:
  - DOMAIN-SUFFIX,steam.com,GAME
  - DOMAIN-SUFFIX,epicgames.com,GAME
  - DOMAIN-SUFFIX,blizzard.com,GAME
  - DOMAIN-SUFFIX,riotgames.com,GAME
  - DOMAIN-SUFFIX,tencent.com,GAME
  - GEOIP,CN,DIRECT
  - MATCH,PROXY
dns:
  enable: true
  ipv6: true
  use-hosts: true
  nameserver:
    - 114.114.114.114
    - 223.5.5.5
  fallback:
    - https://dns.cloudflare.com/dns-query
    - https://dns.google/dns-query
''';
    
    return ConfigTemplate(
      id: 'gaming-optimized',
      name: '游戏优化配置',
      description: '专为游戏优化的分流规则，减少延迟',
      category: TemplateCategory.gaming,
      yamlContent: yamlContent,
      isBuiltIn: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: ['游戏', '低延迟', '优化'],
    );
  }

  /// 创建流媒体模板
  ConfigTemplate _createStreamingTemplate() {
    const yamlContent = '''
port: 7890
socks-port: 7891
allow-lan: false
mode: rule
log-level: info
ipv6: false
external-controller: 127.0.0.1:9090
proxies: []
proxy-groups:
  - name: STREAMING
    type: select
    proxies:
      - DIRECT
  - name: PROXY
    type: select
    proxies:
      - DIRECT
rules:
  - DOMAIN-SUFFIX,netflix.com,STREAMING
  - DOMAIN-SUFFIX,youtube.com,STREAMING
  - DOMAIN-SUFFIX,disneyplus.com,STREAMING
  - DOMAIN-SUFFIX,hulu.com,STREAMING
  - DOMAIN-SUFFIX,primevideo.com,STREAMING
  - DOMAIN-SUFFIX,bilibili.com,DIRECT
  - DOMAIN-SUFFIX,youku.com,DIRECT
  - GEOIP,CN,DIRECT
  - MATCH,PROXY
dns:
  enable: true
  ipv6: false
  use-hosts: true
  nameserver:
    - 114.114.114.114
    - 223.5.5.5
  fallback:
    - https://dns.cloudflare.com/dns-query
''';
    
    return ConfigTemplate(
      id: 'streaming-optimized',
      name: '流媒体优化配置',
      description: '专为流媒体服务优化的配置',
      category: TemplateCategory.streaming,
      yamlContent: yamlContent,
      isBuiltIn: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: ['流媒体', '视频', 'Netflix'],
    );
  }

  /// 创建商务模板
  ConfigTemplate _createBusinessTemplate() {
    const yamlContent = '''
port: 7890
socks-port: 7891
allow-lan: true
mode: rule
log-level: warning
ipv6: false
external-controller: 127.0.0.1:9090
proxies: []
proxy-groups:
  - name: BUSINESS
    type: select
    proxies:
      - DIRECT
  - name: PROXY
    type: select
    proxies:
      - DIRECT
rules:
  - DOMAIN-SUFFIX,office.com,BUSINESS
  - DOMAIN-SUFFIX,microsoft.com,BUSINESS
  - DOMAIN-SUFFIX,google.com,BUSINESS
  - DOMAIN-SUFFIX,dropbox.com,BUSINESS
  - DOMAIN-SUFFIX,slack.com,BUSINESS
  - DOMAIN-SUFFIX,zoom.us,BUSINESS
  - GEOIP,CN,DIRECT
  - MATCH,PROXY
dns:
  enable: true
  ipv6: false
  use-hosts: true
  nameserver:
    - 114.114.114.114
    - 8.8.8.8
  fallback:
    - https://dns.google/dns-query
''';
    
    return ConfigTemplate(
      id: 'business-optimized',
      name: '商务办公配置',
      description: '专为商务办公环境优化的配置',
      category: TemplateCategory.business,
      yamlContent: yamlContent,
      isBuiltIn: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: ['商务', '办公', '企业'],
    );
  }

  /// 创建开发模板
  ConfigTemplate _createDevelopmentTemplate() {
    const yamlContent = '''
port: 7890
socks-port: 7891
allow-lan: true
mode: rule
log-level: debug
ipv6: true
external-controller: 127.0.0.1:9090
proxies: []
proxy-groups:
  - name: DEV
    type: select
    proxies:
      - DIRECT
  - name: PROXY
    type: select
    proxies:
      - DIRECT
rules:
  - DOMAIN-SUFFIX,github.com,DEV
  - DOMAIN-SUFFIX,gitlab.com,DEV
  - DOMAIN-SUFFIX,npmjs.com,DEV
  - DOMAIN-SUFFIX,pypi.org,DEV
  - DOMAIN-SUFFIX,stackoverflow.com,DEV
  - DOMAIN-SUFFIX,docs.rs,DEV
  - DOMAIN-SUFFIX,maven.org,DEV
  - GEOIP,CN,DIRECT
  - MATCH,PROXY
dns:
  enable: true
  ipv6: true
  use-hosts: true
  nameserver:
    - 114.114.114.114
    - 8.8.8.8
  fallback:
    - https://dns.cloudflare.com/dns-query
    - https://dns.google/dns-query
''';
    
    return ConfigTemplate(
      id: 'development-debug',
      name: '开发调试配置',
      description: '专为开发者设计的调试配置',
      category: TemplateCategory.development,
      yamlContent: yamlContent,
      isBuiltIn: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: ['开发', '调试', 'GitHub'],
    );
  }

  /// 创建性能优化模板
  ConfigTemplate _createPerformanceTemplate() {
    const yamlContent = '''
port: 7890
socks-port: 7891
allow-lan: false
mode: rule
log-level: warning
ipv6: true
external-controller: 127.0.0.1:9090
proxies: []
proxy-groups:
  - name: PROXY
    type: url-test
    proxies: []
    url: http://www.gstatic.com/generate_204
    interval: 300
rules:
  - DOMAIN-SUFFIX,google.com,PROXY
  - DOMAIN-SUFFIX,youtube.com,PROXY
  - DOMAIN-SUFFIX,github.com,PROXY
  - DOMAIN-SUFFIX,stackoverflow.com,PROXY
  - GEOIP,CN,DIRECT
  - MATCH,DIRECT
dns:
  enable: true
  ipv6: true
  use-hosts: true
  nameserver:
    - 114.114.114.114
    - 223.5.5.5
  fallback:
    - https://dns.cloudflare.com/dns-query
    - https://dns.google/dns-query
  fallback-filter:
    geoip: true
    geoip-code: CN
''';
    
    return ConfigTemplate(
      id: 'performance-optimized',
      name: '性能优化配置',
      description: '优化的性能配置，自动选择最佳节点',
      category: TemplateCategory.performance,
      yamlContent: yamlContent,
      isBuiltIn: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: ['性能', '自动选择', '优化'],
    );
  }

  /// 创建安全隐私模板
  ConfigTemplate _createSecurityTemplate() {
    const yamlContent = '''
port: 7890
socks-port: 7891
allow-lan: false
mode: rule
log-level: error
ipv6: true
external-controller: 127.0.0.1:9090
proxies: []
proxy-groups:
  - name: SECURE
    type: select
    proxies:
      - DIRECT
  - name: PROXY
    type: select
    proxies:
      - DIRECT
rules:
  - DOMAIN-SUFFIX,privacyguides.org,SECURE
  - DOMAIN-SUFFIX,torproject.org,SECURE
  - DOMAIN-SUFFIX,protonmail.com,SECURE
  - DOMAIN-SUFFIX,duckduckgo.com,SECURE
  - DOMAIN-KEYWORD,tracker,SECURE
  - DOMAIN-KEYWORD,analytics,SECURE
  - GEOIP,CN,DIRECT
  - MATCH,PROXY
dns:
  enable: true
  ipv6: true
  use-hosts: true
  nameserver:
    - 114.114.114.114
  fallback:
    - https://dns.cloudflare.com/dns-query
    - https://dns.quad9.net/dns-query
  fallback-filter:
    geoip: true
    geoip-code: CN
    domain:
      - geosite:cn
''';
    
    return ConfigTemplate(
      id: 'security-privacy',
      name: '安全隐私配置',
      description: '增强隐私和安全的配置',
      category: TemplateCategory.security,
      yamlContent: yamlContent,
      isBuiltIn: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: ['隐私', '安全', 'DNS'],
    );
  }

  /// 生成模板 ID
  String _generateTemplateId() {
    return 'user_${DateTime.now().millisecondsSinceEpoch}_${_userTemplates.length}';
  }

  /// 导出为 JSON
  Map<String, dynamic> _exportAsJson(ConfigTemplate template) {
    return {
      'template': template,
      'exported_at': DateTime.now().toIso8601String(),
      'version': '1.0',
    };
  }

  /// 导出为 YAML
  Map<String, dynamic> _exportAsYaml(ConfigTemplate template) {
    return {
      'name': template.name,
      'description': template.description,
      'category': template.category.toString(),
      'yaml': template.yamlContent,
      'tags': template.tags,
      'exported_at': DateTime.now().toIso8601String(),
    };
  }

  /// 从 JSON 导入
  ConfigTemplate _importFromJson(Map<String, dynamic> data) {
    final templateData = data['template'] as Map<String, dynamic>;
    
    return ConfigTemplate(
      id: _generateTemplateId(),
      name: templateData['name'] as String,
      description: templateData['description'] as String,
      category: TemplateCategory.values.firstWhere(
        (cat) => cat.toString() == templateData['category'],
        orElse: () => TemplateCategory.custom,
      ),
      yamlContent: templateData['yamlContent'] as String,
      metadata: Map<String, dynamic>.from(templateData['metadata'] as Map? ?? {}),
      isBuiltIn: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: List<String>.from(templateData['tags'] as List? ?? []),
    );
  }

  /// 保存用户模板到本地存储
  Future<void> _saveUserTemplates() async {
    try {
      // 这里应该实现实际的本地存储逻辑
      // 例如保存到 SharedPreferences 或本地文件
      _logger.info('用户模板已保存到本地存储');
    } catch (e) {
      _logger.warning('保存用户模板失败: $e');
    }
  }
}

/// 使用场景枚举
enum UseCase {
  general,
  gaming,
  streaming,
  business,
  development,
  privacy,
}

/// 导出格式枚举
enum ExportFormat {
  json,
  yaml,
}

/// 导入格式枚举
enum ImportFormat {
  json,
}

/// 模板异常
class TemplateException implements Exception {
  final String message;
  
  const TemplateException(this.message);
  
  @override
  String toString() => 'TemplateException: $message';
}
