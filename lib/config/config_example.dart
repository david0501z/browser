import 'dart:async';
import 'rule_manager.dart';
import 'dns_settings_manager.dart';
import 'rule_validator.dart';

/// 配置模块使用示例
class ConfigExample {
  
  /// 规则管理示例
  static Future<void> ruleManagementExample() async {
    print('=== 规则管理示例 ===');
    
    // 获取规则管理器实例
    final ruleManager = RuleManager.instance;
    
    // 创建自定义规则
    final customRule = RuleConfig(
      id: 'custom_google',
      name: 'Google服务规则',
      type: RuleType.domain,
      pattern: '*.google.com',
      action: RuleAction.proxy,
      priority: RulePriority.high,
      enabled: true,
      description: 'Google所有服务的代理规则',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // 创建规则组
    final ruleGroup = RuleGroup(
      id: 'network_rules',
      name: '网络规则组',
      rules: [customRule],
      enabled: true,
      description: '包含各种网络访问规则',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // 添加规则组
    await ruleManager.addGroup(ruleGroup);
    print('已添加规则组: ${ruleGroup.name}');
    
    // 添加规则到组
    final domainRule = RuleConfig(
      id: 'github_rule',
      name: 'GitHub规则',
      type: RuleType.domain,
      pattern: '*.github.com',
      action: RuleAction.proxy,
      priority: RulePriority.normal,
      enabled: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await ruleManager.addRule('network_rules', domainRule);
    print('已添加规则: ${domainRule.name}');
    
    // 获取统计信息
    final stats = ruleManager.getStats();
    print('规则统计: 总计${stats.totalRules}条规则，${stats.enabledRules}条启用');
    
    // 搜索规则
    final searchResults = ruleManager.searchRules('google');
    print('搜索"google"的结果: ${searchResults.length}条');
  }
  
  /// DNS设置管理示例
  static Future<void> dnsSettingsExample() async {
    print('\n=== DNS设置管理示例 ===');
    
    // 获取DNS设置管理器
    final dnsManager = DNSSettingsManager.instance;
    
    // 初始化DNS设置
    await dnsManager.initialize();
    print('DNS设置已初始化');
    
    // 获取当前DNS设置
    final settings = dnsManager.settings;
    if (settings != null) {
      print('当前DNS设置: ${settings.servers.length}个主服务器，${settings.fallbackServers.length}个备用服务器');
    }
    
    // 添加自定义DNS服务器
    final customDNSServer = DNSServerConfig(
      id: 'custom_dns',
      name: '自定义DNS服务器',
      type: DNSServerType.custom,
      address: '223.5.5.5',
      port: 53,
      protocol: DNSProtocolType.udp,
      enabled: true,
      secure: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await dnsManager.addServer(customDNSServer);
    print('已添加自定义DNS服务器');
    
    // 应用预设配置
    await dnsManager.applyPreset('secure');
    print('已应用安全预设配置');
    
    // 获取最优DNS服务器
    final optimalServer = await dnsManager.getOptimalDNSServer();
    if (optimalServer != null) {
      print('最优DNS服务器: ${optimalServer.name} (${optimalServer.address}:${optimalServer.port})');
    }
  }
  
  /// 规则验证示例
  static Future<void> ruleValidationExample() async {
    print('\n=== 规则验证示例 ===');
    
    final validator = RuleValidator.instance;
    
    // 创建测试规则
    final testRule = RuleConfig(
      id: 'test_rule',
      name: '测试规则',
      type: RuleType.domain,
      pattern: '*.example.com',
      action: RuleAction.proxy,
      priority: RulePriority.normal,
      enabled: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // 验证规则
    final result = validator.validateRule(testRule);
    print('规则验证结果: ${result.isValid ? '通过' : '失败'}');
    if (!result.isValid) {
      print('错误信息: ${result.errorMessage}');
    }
    if (result.warnings.isNotEmpty) {
      print('警告信息: ${result.warnings.join(', ')}');
    }
    
    // 验证无效规则
    final invalidRule = RuleConfig(
      id: 'invalid_rule',
      name: '', // 空名称，应该触发验证错误
      type: RuleType.domain,
      pattern: '', // 空模式，应该触发验证错误
      action: RuleAction.proxy,
      priority: RulePriority.normal,
      enabled: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    final invalidResult = validator.validateRule(invalidRule);
    print('无效规则验证: ${invalidResult.isValid ? '通过' : '失败'}');
    if (!invalidResult.isValid) {
      print('错误信息: ${invalidResult.errorMessage}');
    }
  }
  
  /// 规则模板管理示例
  static Future<void> ruleTemplateExample() async {
    print('\n=== 规则模板管理示例 ===');
    
    final templateManager = RuleTemplateManager.instance;
    
    // 初始化模板管理器
    await templateManager.initialize();
    print('模板管理器已初始化');
    
    // 获取可用模板
    final availableTemplates = templateManager.availableTemplates;
    print('可用模板: ${availableTemplates.length}个');
    
    // 搜索模板
    final searchResults = templateManager.searchTemplates('网络');
    print('搜索"网络"模板: ${searchResults.length}个');
    
    // 从模板创建规则
    if (availableTemplates.isNotEmpty) {
      final templateName = availableTemplates.first;
      final customRule = await templateManager.createRuleFromTemplate(templateName, {
        'customDomains': ['myapp.com'],
      });
      print('从模板创建规则: ${customRule.name}');
    }
    
    // 获取推荐模板
    final recommended = templateManager.getRecommendedTemplates(limit: 3);
    print('推荐模板: ${recommended.length}个');
    
    // 获取模板统计信息
    final templateStats = templateManager.getTemplateStatistics();
    print('模板统计信息: $templateStats');
  }
  
  /// 规则匹配示例
  static Future<void> ruleMatchingExample() async {
    print('\n=== 规则匹配示例 ===');
    
    final matcher = RuleMatcher.instance;
    
    // 创建测试规则
    final testRules = [
      RuleConfig(
        id: 'google_rule',
        name: 'Google规则',
        type: RuleType.domain,
        pattern: '*.google.com',
        action: RuleAction.proxy,
        priority: RulePriority.high,
        enabled: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      RuleConfig(
        id: 'block_rule',
        name: '阻止规则',
        type: RuleType.domain,
        pattern: '*.ads.com',
        action: RuleAction.block,
        priority: RulePriority.critical,
        enabled: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
    
    // 设置匹配规则
    matcher.setRules(testRules);
    print('已设置${testRules.length}条匹配规则');
    
    // 创建匹配上下文
    final context = MatchContext(
      source: 'test-device',
      port: 80,
      protocol: 'http',
      timestamp: DateTime.now(),
    );
    
    // 执行匹配测试
    final testUrls = [
      'mail.google.com',
      'ads.com',
      'github.com',
    ];
    
    for (final url in testUrls) {
      final result = matcher.matchComprehensive(url, context);
      if (result.isMatch) {
        print('URL "$url" 匹配规则 "${result.matchedRule?.name}"');
      } else {
        print('URL "$url" 无匹配规则');
      }
    }
    
    // 快速匹配测试
    final quickResult = matcher.quickMatch('docs.google.com');
    if (quickResult != null) {
      print('快速匹配结果: ${quickResult.name}');
    }
    
    // 获取匹配统计
    final stats = matcher.stats;
    if (stats != null) {
      print('匹配统计: 总匹配${stats.totalMatches}次，成功率${(stats.successRate * 100).toStringAsFixed(1)}%');
    }
  }
  
  /// DNS保护管理示例
  static Future<void> dnsProtectionExample() async {
    print('\n=== DNS保护管理示例 ===');
    
    final protectionManager = DNSProtectionManager.instance;
    
    // 初始化保护管理器
    await protectionManager.initialize();
    print('DNS保护管理器已初始化');
    
    // 启用DNS保护
    final protectionResult = await protectionManager.enableProtection(DNSProtectionLevel.enhanced);
    print('DNS保护状态: ${protectionResult.isProtected ? '已启用' : '未启用'}');
    print('保护分数: ${protectionResult.protectionScore.toStringAsFixed(1)}%');
    
    if (protectionResult.detectedLeaks.isNotEmpty) {
      print('检测到DNS泄漏: ${protectionResult.detectedLeaks.length}种类型');
    }
    if (protectionResult.warnings.isNotEmpty) {
      print('警告信息: ${protectionResult.warnings.join(', ')}');
    }
    
    // 优化DNS设置
    final optimizationResult = await protectionManager.optimizeDNS();
    print('DNS优化结果: ${optimizationResult.isProtected ? '成功' : '需要进一步优化'}');
    
    // 更新优化配置
    final newConfig = DNSOptimizationConfig(
      enableCompression: true,
      enableCaching: true,
      cacheSize: 2000,
      timeout: const Duration(seconds: 3),
    );
    
    await protectionManager.updateOptimizationConfig(newConfig);
    print('已更新优化配置');
    
    // 获取保护报告
    final report = protectionManager.getProtectionReport();
    print('保护报告状态: ${report['status']}');
  }
  
  /// 完整的工作流程示例
  static Future<void> completeWorkflowExample() async {
    print('\n=== 完整工作流程示例 ===');
    
    // 1. 初始化所有管理器
    await Future.wait([
      RuleManager.instance.loadFromFile(),
      DNSSettingsManager.instance.initialize(),
      RuleTemplateManager.instance.initialize(),
      DNSProtectionManager.instance.initialize(),
    ]);
    
    print('所有管理器已初始化');
    
    // 2. 从模板创建规则
    final templateManager = RuleTemplateManager.instance;
    final ruleManager = RuleManager.instance;
    
    if (templateManager.availableTemplates.isNotEmpty) {
      final templateName = templateManager.availableTemplates.first;
      final customParams = {
        'customDomains': ['myapp.com', 'api.myapp.com'],
        'customPriority': RulePriority.high,
      };
      
      final rule = await templateManager.createRuleFromTemplate(templateName, customParams);
      print('从模板创建规则: ${rule.name}');
      
      // 创建规则组并添加规则
      final group = RuleGroup(
        id: 'app_rules',
        name: '应用规则组',
        rules: [rule],
        enabled: true,
        description: '基于模板创建的应用规则',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await ruleManager.addGroup(group);
      print('已创建并添加规则组');
    }
    
    // 3. 验证规则
    final validator = RuleValidator.instance;
    final enabledRules = ruleManager.enabledRules;
    
    for (final rule in enabledRules) {
      final validationResult = validator.validateRule(rule);
      if (!validationResult.isValid) {
        print('规则验证失败: ${rule.name} - ${validationResult.errorMessage}');
      }
    }
    
    // 4. 设置规则匹配
    final matcher = RuleMatcher.instance;
    matcher.setRules(enabledRules);
    print('已设置${enabledRules.length}条规则进行匹配');
    
    // 5. 优化DNS设置
    final dnsManager = DNSSettingsManager.instance;
    await dnsManager.applyPreset('balanced');
    await dnsManager.initialize();
    
    // 6. 启用DNS保护
    final protectionManager = DNSProtectionManager.instance;
    await protectionManager.enableProtection(DNSProtectionLevel.standard);
    
    print('完整工作流程已完成');
    
    // 7. 执行性能测试
    final testUrls = [
      'myapp.com',
      'api.myapp.com',
      'github.com',
      'google.com',
    ];
    
    final context = MatchContext(
      source: 'test-client',
      port: 443,
      protocol: 'https',
      timestamp: DateTime.now(),
    );
    
    print('\n性能测试结果:');
    for (final url in testUrls) {
      final startTime = DateTime.now();
      final result = matcher.matchComprehensive(url, context);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      
      if (result.isMatch) {
        print('$url: 匹配 ${result.matchedRule?.name} (${duration}ms)');
      } else {
        print('$url: 无匹配规则 (${duration}ms)');
      }
    }
  }
  
  /// 主函数 - 运行所有示例
  static Future<void> main() async {
    print('开始运行配置模块示例...\n');
    
    try {
      await ruleManagementExample();
      await dnsSettingsExample();
      await ruleValidationExample();
      await ruleTemplateExample();
      await ruleMatchingExample();
      await dnsProtectionExample();
      await completeWorkflowExample();
      
      print('\n所有示例运行完成！');
    } catch (e) {
      print('示例运行出错: $e');
      rethrow;
    }
  }
}

// 如果直接运行此文件
void main() {
  ConfigExample.main();
}