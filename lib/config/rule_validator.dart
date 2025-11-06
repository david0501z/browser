import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/enums.dart';
import 'rule_manager.dart';

/// 验证结果
@immutable
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final List<String> warnings;
  final Map<String, dynamic>? details;

  const ValidationResult({
    required this.isValid,
    this.errorMessage,
    this.warnings = const [],
    this.details,
  });

  /// 创建成功的验证结果
  factory ValidationResult.success() {
    return const ValidationResult(isValid: true);
  }

  /// 创建失败的验证结果
  factory ValidationResult.failure(String message, {List<String>? warnings}) {
    return ValidationResult(
      isValid: false,
      errorMessage: message,
      warnings: warnings ?? [],
    );
  }

  /// 创建带警告的验证结果
  factory ValidationResult.successWithWarnings(List<String> warnings, {Map<String, dynamic>? details}) {
    return ValidationResult(
      isValid: true,
      warnings: warnings,
      details: details,
    );
  }

  @override
  String toString() {
    if (isValid) {
      return 'ValidationResult{success${warnings.isNotEmpty ? ', warnings: $warnings' : ''}}';
    } else {
      return 'ValidationResult{failure: $errorMessage${warnings.isNotEmpty ? ', warnings: $warnings' : ''}}';
    }
  }
}

/// 验证规则类型
enum ValidationRuleType {
  syntax,        // 语法验证
  semantic,      // 语义验证
  performance,   // 性能验证
  security,      // 安全验证
  compatibility, // 兼容性验证
}

/// 验证级别
enum ValidationLevel {
  info,      // 信息级别
  warning,   // 警告级别
  error,     // 错误级别
}

/// 验证报告
@immutable
class ValidationReport {
  final RuleConfig? rule;
  final RuleGroup? group;
  final List<ValidationResult> results;
  final DateTime timestamp;
  final String version;

  const ValidationReport({
    this.rule,
    this.group,
    required this.results,
    required this.timestamp,
    this.version = '1.0',
  });

  /// 是否整体验证通过
  bool get isValid {
    return results.every((result) => result.isValid);
  }

  /// 获取错误级别的结果
  List<ValidationResult> get errors {
    return results.where((result) => !result.isValid).toList();
  }

  /// 获取警告级别的结果
  List<ValidationResult> get warnings {
    return results.where((result) => result.isValid && result.warnings.isNotEmpty).toList();
  }

  /// 获取验证摘要
  String get summary {
    final errorCount = errors.length;
    final warningCount = warnings.length;
    
    if (isValid && warningCount == 0) {
      return '验证通过';
    } else if (isValid) {
      return '验证通过，有 $warningCount 个警告';
    } else {
      return '验证失败：$errorCount 个错误，$warningCount 个警告';
    }
  }
}

/// 规则验证器
class RuleValidator {
  static RuleValidator? _instance;
  static RuleValidator get instance => _instance ??= RuleValidator._();

  RuleValidator._();

  // 预定义的验证规则
  static const String _ipV4Regex = r'^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$';
  static const String _cidrRegex = r'^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\/([0-9]|[1-2][0-9]|3[0-2])$';
  static const String _domainRegex = r'^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$';
  static const String _portRegex = r'^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$';
  static const String _protocolRegex = r'^(tcp|udp|http|https|socks4|socks5|quic)$';
  static const String _wildcardRegex = r'^[a-zA-Z0-9*?\-_\.]+$';
  static const String _regexPatternRegex = r'^\/.*\/[gimsuy]*$';

  /// 验证单个规则
  ValidationResult validateRule(RuleConfig rule) {
    final results = <ValidationResult>[];

    // 基本字段验证
    results.add(_validateBasicFields(rule));
    
    // 语法验证
    results.add(_validateSyntax(rule));
    
    // 语义验证
    results.add(_validateSemantics(rule));
    
    // 性能验证
    results.add(_validatePerformance(rule));
    
    // 安全验证
    results.add(_validateSecurity(rule));

    // 获取最终的验证结果
    final errors = results.where((r) => !r.isValid).toList();
    if (errors.isNotEmpty) {
      return ValidationResult.failure(
        errors.first.errorMessage!,
        warnings: results.expand((r) => r.warnings).toList(),
      );
    }

    final warnings = results.expand((r) => r.warnings).toList();
    if (warnings.isNotEmpty) {
      return ValidationResult.successWithWarnings(warnings);
    }

    return ValidationResult.success();
  }

  /// 验证规则组
  ValidationReport validateGroup(RuleGroup group) {
    final results = <ValidationResult>[];

    // 验证基本字段
    results.add(_validateGroupBasicFields(group));

    // 验证所有规则
    for (final rule in group.rules) {
      results.add(validateRule(rule));
    }

    // 验证规则冲突
    results.add(_validateRuleConflicts(group.rules));

    // 验证性能
    results.add(_validateGroupPerformance(group));

    // 验证安全
    results.add(_validateGroupSecurity(group));

    return ValidationReport(
      group: group,
      results: results,
      timestamp: DateTime.now(),
    );
  }

  /// 批量验证规则
  List<ValidationReport> validateRules(List<RuleConfig> rules) {
    return rules.map((rule) {
      return ValidationReport(
        rule: rule,
        results: [validateRule(rule)],
        timestamp: DateTime.now(),
      );
    }).toList();
  }

  /// 验证规则配置
  ValidationResult validateRuleConfig(Map<String, dynamic> config) {
    try {
      // 尝试创建规则对象
      final rule = RuleConfig.fromJson(config);
      return validateRule(rule);
    } catch (e) {
      return ValidationResult.failure('无效的规则配置格式: $e');
    }
  }

  /// 从文件验证规则
  Future<ValidationReport> validateRulesFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return ValidationReport(
          results: [ValidationResult.failure('文件不存在: $filePath')],
          timestamp: DateTime.now(),
        );
      }

      final content = await file.readAsString();
      final data = json.decode(content);

      if (data case {'groups': final List groups}) {
        final results = <ValidationResult>[];
        
        for (final groupData in groups) {
          try {
            final group = RuleGroup.fromJson(groupData as Map<String, dynamic>);
            results.addAll(validateGroup(group).results);
          } catch (e) {
            results.add(ValidationResult.failure('无效的规则组数据: $e'));
          }
        }

        return ValidationReport(
          results: results,
          timestamp: DateTime.now(),
        );
      } else if (data case {'rules': final List rules}) {
        final results = <ValidationResult>[];
        
        for (final ruleData in rules) {
          try {
            final rule = RuleConfig.fromJson(ruleData as Map<String, dynamic>);
            results.add(validateRule(rule));
          } catch (e) {
            results.add(ValidationResult.failure('无效的规则数据: $e'));
          }
        }

        return ValidationReport(
          results: results,
          timestamp: DateTime.now(),
        );
      } else {
        return ValidationReport(
          results: [ValidationResult.failure('不支持的文件格式')],
          timestamp: DateTime.now(),
        );
      }
    } catch (e) {
      return ValidationReport(
        results: [ValidationResult.failure('读取文件失败: $e')],
        timestamp: DateTime.now(),
      );
    }
  }

  /// 验证基本字段
  ValidationResult _validateBasicFields(RuleConfig rule) {
    final warnings = <String>[];

    // 验证ID
    if (rule.id.isEmpty) {
      return ValidationResult.failure('规则ID不能为空');
    }

    if (!RegExp(r'^[a-zA-Z0-9_\-]+$').hasMatch(rule.id)) {
      warnings.add('规则ID包含特殊字符，建议使用字母、数字、下划线和连字符');
    }

    // 验证名称
    if (rule.name.isEmpty) {
      return ValidationResult.failure('规则名称不能为空');
    }

    if (rule.name.length > 100) {
      warnings.add('规则名称过长，建议控制在100字符以内');
    }

    // 验证描述
    if (rule.description != null && rule.description!.length > 500) {
      warnings.add('规则描述过长，建议控制在500字符以内');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证语法
  ValidationResult _validateSyntax(RuleConfig rule) {
    final warnings = <String>[];

    switch (rule.type) {
      case RuleType.domain:
        return _validateDomainPattern(rule.pattern, warnings);
      
      case RuleType.ip:
        return _validateIPPattern(rule.pattern, warnings);
      
      case RuleType.cidr:
        return _validateCIDRPattern(rule.pattern, warnings);
      
      case RuleType.port:
        return _validatePortPattern(rule.pattern, warnings);
      
      case RuleType.protocol:
        return _validateProtocolPattern(rule.pattern, warnings);
      
      case RuleType.wildcard:
        return _validateWildcardPattern(rule.pattern, warnings);
      
      case RuleType.regex:
        return _validateRegexPattern(rule.pattern, warnings);
      
      case RuleType.geoip:
        return _validateGeoIPPattern(rule.pattern, warnings);
      
      case RuleType.adblock:
        return _validateAdBlockPattern(rule.pattern, warnings);
      
      case RuleType.custom:
        return _validateCustomPattern(rule.pattern, warnings);
    }
  }

  /// 验证域名模式
  ValidationResult _validateDomainPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('域名模式不能为空');
    }

    // 简单域名验证
    final domainRegex = RegExp(_domainRegex);
    if (!domainRegex.hasMatch(pattern)) {
      return ValidationResult.failure('无效的域名格式: $pattern');
    }

    // 检查是否为常见域名格式
    if (pattern.startsWith('*.')) {
      warnings.add('使用通配符域名可能影响性能');
    }

    if (pattern.contains('*')) {
      warnings.add('通配符域名规则需要特别注意性能影响');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证IP地址模式
  ValidationResult _validateIPPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('IP地址模式不能为空');
    }

    final ipRegex = RegExp(_ipV4Regex);
    if (!ipRegex.hasMatch(pattern)) {
      return ValidationResult.failure('无效的IP地址格式: $pattern');
    }

    // 检查是否为私有IP地址
    if (_isPrivateIP(pattern)) {
      warnings.add('使用私有IP地址，建议检查是否需要');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证CIDR模式
  ValidationResult _validateCIDRPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('CIDR模式不能为空');
    }

    final cidrRegex = RegExp(_cidrRegex);
    if (!cidrRegex.hasMatch(pattern)) {
      return ValidationResult.failure('无效的CIDR格式: $pattern');
    }

    // 检查CIDR范围
    final parts = pattern.split('/');
    final prefixLength = int.parse(parts[1]);
    
    if (prefixLength < 8) {
      warnings.add('过大的CIDR范围可能影响性能');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证端口模式
  ValidationResult _validatePortPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('端口模式不能为空');
    }

    final portRegex = RegExp(_portRegex);
    if (!portRegex.hasMatch(pattern)) {
      return ValidationResult.failure('无效的端口格式: $pattern');
    }

    final port = int.parse(pattern);
    if (port < 1024) {
      warnings.add('使用系统保留端口，请确保有足够权限');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证协议模式
  ValidationResult _validateProtocolPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('协议模式不能为空');
    }

    final protocolRegex = RegExp(_protocolRegex);
    if (!protocolRegex.hasMatch(pattern)) {
      return ValidationResult.failure('不支持的协议类型: $pattern');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证通配符模式
  ValidationResult _validateWildcardPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('通配符模式不能为空');
    }

    final wildcardRegex = RegExp(_wildcardRegex);
    if (!wildcardRegex.hasMatch(pattern)) {
      return ValidationResult.failure('无效的通配符格式: $pattern');
    }

    // 检查通配符使用情况
    final wildcardCount = RegExp(r'\*').allMatches(pattern).length;
    if (wildcardCount > 3) {
      warnings.add('过多通配符可能影响性能');
    }

    if (pattern.startsWith('*') && pattern.endsWith('*')) {
      warnings.add('前后都有通配符的规则匹配范围较大，建议优化');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证正则表达式模式
  ValidationResult _validateRegexPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('正则表达式模式不能为空');
    }

    // 验证正则表达式格式
    if (!pattern.startsWith('/')) {
      return ValidationResult.failure('正则表达式必须以/开头');
    }

    final lastSlashIndex = pattern.lastIndexOf('/');
    if (lastSlashIndex == -1) {
      return ValidationResult.failure('正则表达式必须以/结尾');
    }

    final regexPattern = pattern.substring(1, lastSlashIndex);
    final flags = pattern.substring(lastSlashIndex + 1);

    try {
      // 验证正则表达式语法
      RegExp(regexPattern);
    } catch (e) {
      return ValidationResult.failure('无效的正则表达式语法: $e');
    }

    // 检查性能相关警告
    if (regexPattern.contains('.*')) {
      warnings.add('使用.*可能影响性能，建议使用更精确的模式');
    }

    if (regexPattern.contains('.*.*')) {
      warnings.add('连续使用.*可能严重影响性能');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证GeoIP模式
  ValidationResult _validateGeoIPPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('GeoIP模式不能为空');
    }

    // 简单的国家代码验证
    if (pattern.length != 2) {
      return ValidationResult.failure('GeoIP国家代码必须为2字符');
    }

    if (!RegExp(r'^[A-Z]{2}$').hasMatch(pattern)) {
      return ValidationResult.failure('GeoIP国家代码必须为大写字母');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证AdBlock模式
  ValidationResult _validateAdBlockPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('AdBlock模式不能为空');
    }

    // 检查常见的AdBlock模式
    if (pattern.startsWith('||')) {
      final domain = pattern.substring(2);
      if (!RegExp(_domainRegex).hasMatch(domain)) {
        return ValidationResult.failure('AdBlock域名格式无效: $domain');
      }
    } else if (pattern.startsWith('|')) {
      // 前缀匹配
      final prefix = pattern.substring(1);
      if (prefix.isEmpty) {
        return ValidationResult.failure('AdBlock前缀不能为空');
      }
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证自定义模式
  ValidationResult _validateCustomPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('自定义模式不能为空');
    }

    // 自定义模式应该有足够的验证信息
    if (pattern.length < 3) {
      warnings.add('自定义模式可能过于简单，建议增加更多匹配条件');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证语义
  ValidationResult _validateSemantics(RuleConfig rule) {
    final warnings = <String>[];

    // 验证动作与类型的匹配性
    if (!_isActionCompatibleWithType(rule.action, rule.type)) {
      return ValidationResult.failure('动作类型与规则类型不兼容');
    }

    // 验证优先级范围
    if (rule.priority < RulePriority.lowest || rule.priority > RulePriority.critical) {
      warnings.add('优先级超出建议范围 (${RulePriority.lowest}-${RulePriority.critical})');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证性能
  ValidationResult _validatePerformance(RuleConfig rule) {
    final warnings = <String>[];

    // 复杂规则警告
    if (rule.pattern.length > 1000) {
      warnings.add('规则模式过长，可能影响匹配性能');
    }

    // 优先级合理性检查
    if (rule.priority == RulePriority.critical && rule.action == RuleAction.block) {
      warnings.add('高优先级的阻止规则可能过于激进');
    }

    // 检查是否存在性能瓶颈模式
    if (_hasPerformanceIssues(rule)) {
      warnings.add('规则可能存在性能问题，建议优化');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证安全
  ValidationResult _validateSecurity(RuleConfig rule) {
    final warnings = <String>[];

    // 安全相关检查
    if (rule.action == RuleAction.block && rule.type == RuleType.domain) {
      // 检查是否为重要域名
      if (_isCriticalDomain(rule.pattern)) {
        warnings.add('阻止关键域名可能影响系统功能');
      }
    }

    // 检查是否存在安全风险的正则表达式
    if (rule.type == RuleType.regex && _hasSecurityRisk(rule.pattern)) {
      warnings.add('正则表达式可能存在安全风险');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证规则组基本字段
  ValidationResult _validateGroupBasicFields(RuleGroup group) {
    final warnings = <String>[];

    if (group.id.isEmpty) {
      return ValidationResult.failure('规则组ID不能为空');
    }

    if (group.name.isEmpty) {
      return ValidationResult.failure('规则组名称不能为空');
    }

    if (group.rules.isEmpty) {
      warnings.add('规则组为空，建议添加规则');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证规则冲突
  ValidationResult _validateRuleConflicts(List<RuleConfig> rules) {
    // 检查是否存在冲突的规则
    final conflicts = <String>[];

    for (int i = 0; i < rules.length; i++) {
      for (int j = i + 1; j < rules.length; j++) {
        final rule1 = rules[i];
        final rule2 = rules[j];

        if (_areRulesConflicting(rule1, rule2)) {
          conflicts.add('规则 "${rule1.name}" 与 "${rule2.name}" 存在冲突');
        }
      }
    }

    if (conflicts.isNotEmpty) {
      return ValidationResult.failure('发现规则冲突: ${conflicts.join(', ')}');
    }

    return ValidationResult.success();
  }

  /// 验证组性能
  ValidationResult _validateGroupPerformance(RuleGroup group) {
    final warnings = <String>[];

    if (group.rules.length > 1000) {
      warnings.add('规则组规则数量过多 (${group.rules.length})，可能影响性能');
    }

    final criticalRules = group.rules.where((r) => r.priority >= RulePriority.high).length;
    if (criticalRules > 10) {
      warnings.add('高优先级规则过多，可能影响整体性能');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 验证组安全
  ValidationResult _validateGroupSecurity(RuleGroup group) {
    final warnings = <String>[];

    final blockRules = group.rules.where((r) => r.action == RuleAction.block).length;
    if (blockRules > group.rules.length * 0.5) {
      warnings.add('阻止规则比例过高 (${(blockRules / group.rules.length * 100).toInt()}%)，可能过于严格');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 私有辅助方法

  bool _isPrivateIP(String ip) {
    final parts = ip.split('.').map(int.parse).toList();
    
    // 检查常见的私有IP范围
    if (parts[0] == 10) return true;
    if (parts[0] == 172 && parts[1] >= 16 && parts[1] <= 31) return true;
    if (parts[0] == 192 && parts[1] == 168) return true;
    if (parts[0] == 127) return true; // 环回地址
    
    return false;
  }

  bool _isActionCompatibleWithType(RuleAction action, RuleType type) {
    // 大部分动作类型与规则类型都是兼容的
    // 这里可以添加具体的兼容性检查逻辑
    return true;
  }

  bool _hasPerformanceIssues(RuleConfig rule) {
    // 检查可能影响性能的规则模式
    if (rule.type == RuleType.regex) {
      if (rule.pattern.contains('.*.*')) return true;
      if (rule.pattern.contains('.{100,}')) return true;
    }
    
    if (rule.type == RuleType.wildcard) {
      final wildcardCount = RegExp(r'\*').allMatches(rule.pattern).length;
      if (wildcardCount > 3) return true;
    }
    
    return false;
  }

  bool _isCriticalDomain(String domain) {
    final criticalDomains = [
      'google.com',
      'facebook.com',
      'amazon.com',
      'microsoft.com',
      'apple.com',
    ];
    
    return criticalDomains.any((critical) => 
        domain == critical || domain.endsWith('.$critical'));
  }

  bool _hasSecurityRisk(String regexPattern) {
    // 检查可能有安全风险的正则表达式
    if (regexPattern.contains('(.)\\1{10,}')) return true; // 重复字符
    if (regexPattern.contains('\\\\')) return true; // 过多转义
    if (regexPattern.length > 500) return true; // 过长模式
    
    return false;
  }

  bool _areRulesConflicting(RuleConfig rule1, RuleConfig rule2) {
    // 简化的冲突检测逻辑
    // 实际实现中需要更复杂的匹配算法
    
    if (rule1.type == rule2.type && rule1.pattern == rule2.pattern) {
      if (rule1.action != rule2.action) {
        return true; // 相同模式但不同动作，可能冲突
      }
    }
    
    return false;
  }

  /// 静态方法：验证单个规则
  static ValidationResult validateRule(RuleConfig rule) {
    return instance.validateRule(rule);
  }

  /// 静态方法：验证规则模式
  static ValidationResult validatePattern(String pattern, RuleType type, {List<String>? warnings}) {
    final localWarnings = warnings ?? <String>[];
    
    switch (type) {
      case RuleType.domain:
        return _validateStaticDomainPattern(pattern, localWarnings);
      
      case RuleType.ip:
        return _validateStaticIPPattern(pattern, localWarnings);
      
      case RuleType.cidr:
        return _validateStaticCIDRPattern(pattern, localWarnings);
      
      case RuleType.port:
        return _validateStaticPortPattern(pattern, localWarnings);
      
      case RuleType.protocol:
        return _validateStaticProtocolPattern(pattern, localWarnings);
      
      case RuleType.wildcard:
        return _validateStaticWildcardPattern(pattern, localWarnings);
      
      case RuleType.regex:
        return _validateStaticRegexPattern(pattern, localWarnings);
      
      case RuleType.geoip:
        return _validateStaticGeoIPPattern(pattern, localWarnings);
      
      case RuleType.adblock:
        return _validateStaticAdBlockPattern(pattern, localWarnings);
      
      case RuleType.custom:
        return _validateStaticCustomPattern(pattern, localWarnings);
    }
  }

  /// 静态方法：验证域名模式
  static ValidationResult _validateStaticDomainPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('域名模式不能为空');
    }

    final domainRegex = RegExp(_domainRegex);
    if (!domainRegex.hasMatch(pattern)) {
      return ValidationResult.failure('无效的域名格式: $pattern');
    }

    if (pattern.startsWith('*.')) {
      warnings.add('使用通配符域名可能影响性能');
    }

    if (pattern.contains('*')) {
      warnings.add('通配符域名规则需要特别注意性能影响');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 静态方法：验证IP地址模式
  static ValidationResult _validateStaticIPPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('IP地址模式不能为空');
    }

    final ipRegex = RegExp(_ipV4Regex);
    if (!ipRegex.hasMatch(pattern)) {
      return ValidationResult.failure('无效的IP地址格式: $pattern');
    }

    if (_isPrivateIP(pattern)) {
      warnings.add('使用私有IP地址，建议检查是否需要');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 静态方法：验证CIDR模式
  static ValidationResult _validateStaticCIDRPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('CIDR模式不能为空');
    }

    final cidrRegex = RegExp(_cidrRegex);
    if (!cidrRegex.hasMatch(pattern)) {
      return ValidationResult.failure('无效的CIDR格式: $pattern');
    }

    final parts = pattern.split('/');
    final prefixLength = int.parse(parts[1]);
    
    if (prefixLength < 8) {
      warnings.add('过大的CIDR范围可能影响性能');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 静态方法：验证端口模式
  static ValidationResult _validateStaticPortPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('端口模式不能为空');
    }

    final portRegex = RegExp(_portRegex);
    if (!portRegex.hasMatch(pattern)) {
      return ValidationResult.failure('无效的端口格式: $pattern');
    }

    final port = int.parse(pattern);
    if (port < 1024) {
      warnings.add('使用系统保留端口，请确保有足够权限');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 静态方法：验证协议模式
  static ValidationResult _validateStaticProtocolPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('协议模式不能为空');
    }

    final protocolRegex = RegExp(_protocolRegex);
    if (!protocolRegex.hasMatch(pattern)) {
      return ValidationResult.failure('不支持的协议类型: $pattern');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 静态方法：验证通配符模式
  static ValidationResult _validateStaticWildcardPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('通配符模式不能为空');
    }

    final wildcardRegex = RegExp(_wildcardRegex);
    if (!wildcardRegex.hasMatch(pattern)) {
      return ValidationResult.failure('无效的通配符格式: $pattern');
    }

    final wildcardCount = RegExp(r'\*').allMatches(pattern).length;
    if (wildcardCount > 3) {
      warnings.add('过多通配符可能影响性能');
    }

    if (pattern.startsWith('*') && pattern.endsWith('*')) {
      warnings.add('前后都有通配符的规则匹配范围较大，建议优化');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 静态方法：验证正则表达式模式
  static ValidationResult _validateStaticRegexPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('正则表达式模式不能为空');
    }

    if (!pattern.startsWith('/')) {
      return ValidationResult.failure('正则表达式必须以/开头');
    }

    final lastSlashIndex = pattern.lastIndexOf('/');
    if (lastSlashIndex == -1) {
      return ValidationResult.failure('正则表达式必须以/结尾');
    }

    final regexPattern = pattern.substring(1, lastSlashIndex);
    final flags = pattern.substring(lastSlashIndex + 1);

    try {
      RegExp(regexPattern);
    } catch (e) {
      return ValidationResult.failure('无效的正则表达式语法: $e');
    }

    if (regexPattern.contains('.*')) {
      warnings.add('使用.*可能影响性能，建议使用更精确的模式');
    }

    if (regexPattern.contains('.*.*')) {
      warnings.add('连续使用.*可能严重影响性能');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 静态方法：验证GeoIP模式
  static ValidationResult _validateStaticGeoIPPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('GeoIP模式不能为空');
    }

    if (pattern.length != 2) {
      return ValidationResult.failure('GeoIP国家代码必须为2字符');
    }

    if (!RegExp(r'^[A-Z]{2}$').hasMatch(pattern)) {
      return ValidationResult.failure('GeoIP国家代码必须为大写字母');
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 静态方法：验证AdBlock模式
  static ValidationResult _validateStaticAdBlockPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('AdBlock模式不能为空');
    }

    if (pattern.startsWith('||')) {
      final domain = pattern.substring(2);
      if (!RegExp(_domainRegex).hasMatch(domain)) {
        return ValidationResult.failure('AdBlock域名格式无效: $domain');
      }
    } else if (pattern.startsWith('|')) {
      final prefix = pattern.substring(1);
      if (prefix.isEmpty) {
        return ValidationResult.failure('AdBlock前缀不能为空');
      }
    }

    return ValidationResult.successWithWarnings(warnings);
  }

  /// 静态方法：验证自定义模式
  static ValidationResult _validateStaticCustomPattern(String pattern, List<String> warnings) {
    if (pattern.isEmpty) {
      return ValidationResult.failure('自定义模式不能为空');
    }

    if (pattern.length < 3) {
      warnings.add('自定义模式可能过于简单，建议增加更多匹配条件');
    }

    return ValidationResult.successWithWarnings(warnings);
  }
}