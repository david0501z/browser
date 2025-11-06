/// 配置文件验证器
/// 
/// 验证 ClashMeta 配置文件的正确性和完整性

import 'clash_config_generator.dart';
import 'yaml_parser.dart';
import '../core/proxy_config.dart';
import '../core/proxy_types.dart';
import '../logging/logger.dart';
import '../models/app_settings.dart';
import '../models/enums.dart';
import 'dart:io';

/// 配置验证结果
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final List<String> suggestions;
  final ValidationLevel level;
  final DateTime timestamp;

  const ValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    required this.suggestions,
    required this.level,
    required this.timestamp,
  });

  /// 获取验证摘要
  String get summary {
    final buffer = StringBuffer();
    buffer.writeln('=== 配置验证结果 ===');
    buffer.writeln('验证级别: ${level.toString()}');
    buffer.writeln('有效性: ${isValid ? "有效" : "无效"}');
    
    if (errors.isNotEmpty) {
      buffer.writeln('\n错误 ($errors.length):');
      for (final error in errors) {
        buffer.writeln('  ❌ $error');
      }
    }
    
    if (warnings.isNotEmpty) {
      buffer.writeln('\n警告 ($warnings.length):');
      for (final warning in warnings) {
        buffer.writeln('  ⚠️ $warning');
      }
    }
    
    if (suggestions.isNotEmpty) {
      buffer.writeln('\n建议 ($suggestions.length):');
      for (final suggestion in suggestions) {
        buffer.writeln('  💡 $suggestion');
      }
    }
    
    return buffer.toString();
  }

  /// 获取详细报告
  String get detailedReport {
    final buffer = StringBuffer();
    buffer.writeln('=== 配置验证详细报告 ===');
    buffer.writeln('验证时间: ${timestamp.toIso8601String()}');
    buffer.writeln('验证级别: ${level.toString()}');
    buffer.writeln('总体状态: ${isValid ? "✅ 通过" : "❌ 失败"}');
    buffer.writeln();
    
    if (errors.isNotEmpty) {
      buffer.writeln('## 错误详情');
      errors.asMap().forEach((index, error) {
        buffer.writeln('${index + 1}. $error');
      });
      buffer.writeln();
    }
    
    if (warnings.isNotEmpty) {
      buffer.writeln('## 警告详情');
      warnings.asMap().forEach((index, warning) {
        buffer.writeln('${index + 1}. $warning');
      });
      buffer.writeln();
    }
    
    if (suggestions.isNotEmpty) {
      buffer.writeln('## 优化建议');
      suggestions.asMap().forEach((index, suggestion) {
        buffer.writeln('${index + 1}. $suggestion');
      });
      buffer.writeln();
    }
    
    return buffer.toString();
  }
}

/// 验证级别枚举
enum ValidationLevel {
  /// 基础验证
  basic,
  /// 标准验证
  standard,
  /// 严格验证
  strict,
}

/// 配置验证器类
class ConfigValidator {
  static final Logger _logger = Logger('ConfigValidator');

  /// 验证 FlClashSettings 配置
  /// 
  /// [settings] 要验证的配置
  /// [level] 验证级别
  /// [proxyList] 代理列表（可选）
  ValidationResult validateSettings(
    FlClashSettings settings, {
    ValidationLevel level = ValidationLevel.standard,
    List<ProxyConfig>? proxyList,
  }) {
    _logger.info('开始验证 FlClashSettings 配置');
    
    final errors = <String>[];
    final warnings = <String>[];
    final suggestions = <String>[];
    
    // 基础验证
    _validateBasicSettings(settings, errors, warnings, suggestions);
    
    // 端口验证
    _validatePorts(settings.ports, errors, warnings, suggestions);
    
    // DNS 验证
    _validateDnsSettings(settings.dns, errors, warnings, suggestions);
    
    // 代理验证
    if (proxyList != null && proxyList.isNotEmpty) {
      _validateProxyList(proxyList, errors, warnings, suggestions);
    }
    
    // 根据验证级别进行额外验证
    if (level == ValidationLevel.strict) {
      _validateStrict(settings, proxyList, errors, warnings, suggestions);
    }
    
    final isValid = errors.isEmpty;
    _logger.info('配置验证完成: ${isValid ? "有效" : "无效"}');
    
    return ValidationResult(
      isValid: isValid,
      errors: errors,
      warnings: warnings,
      suggestions: suggestions,
      level: level,
      timestamp: DateTime.now(),
    );
  }

  /// 验证代理列表
  /// 
  /// [proxyList] 代理列表
  /// [level] 验证级别
  ValidationResult validateProxyList(
    List<ProxyConfig> proxyList, {
    ValidationLevel level = ValidationLevel.standard,
  }) {
    _logger.info('开始验证代理列表 (${proxyList.length} 个代理)');
    
    final errors = <String>[];
    final warnings = <String>[];
    final suggestions = <String>[];
    
    _validateProxyList(proxyList, errors, warnings, suggestions);
    
    if (level == ValidationLevel.strict) {
      _validateProxyListStrict(proxyList, errors, warnings, suggestions);
    }
    
    final isValid = errors.isEmpty;
    _logger.info('代理列表验证完成: ${isValid ? "有效" : "无效"}');
    
    return ValidationResult(
      isValid: isValid,
      errors: errors,
      warnings: warnings,
      suggestions: suggestions,
      level: level,
      timestamp: DateTime.now(),
    );
  }

  /// 验证 YAML 配置内容
  /// 
  /// [yamlContent] YAML 配置内容
  /// [level] 验证级别
  ValidationResult validateYamlContent(
    String yamlContent, {
    ValidationLevel level = ValidationLevel.standard,
  }) {
    _logger.info('开始验证 YAML 配置内容');
    
    final errors = <String>[];
    final warnings = <String>[];
    final suggestions = <String>[];
    
    try {
      // 先解析 YAML
      final parser = YamlParser();
      final parseResult = parser.parseConfig(yamlContent);
      
      // 验证解析后的配置
      _validateParsedConfig(parseResult, errors, warnings, suggestions);
      
      // 验证基本 YAML 结构
      _validateYamlStructure(yamlContent, errors, warnings, suggestions);
      
    } on Exception catch (e) {
      errors.add('YAML 解析失败: ${e.toString()}');
    }
    
    final isValid = errors.isEmpty;
    _logger.info('YAML 配置验证完成: ${isValid ? "有效" : "无效"}');
    
    return ValidationResult(
      isValid: isValid,
      errors: errors,
      warnings: warnings,
      suggestions: suggestions,
      level: level,
      timestamp: DateTime.now(),
    );
  }

  /// 批量验证配置
  /// 
  /// [configs] 配置列表
  /// [level] 验证级别
  Map<String, ValidationResult> batchValidate(
    Map<String, String> configs, {
    ValidationLevel level = ValidationLevel.standard,
  }) {
    _logger.info('开始批量验证 ${configs.length} 个配置');
    
    final results = <String, ValidationResult>{};
    
    for (final entry in configs.entries) {
      final configName = entry.key;
      final yamlContent = entry.value;
      
      try {
        final result = validateYamlContent(yamlContent, level: level);
        results[configName] = result;
      } catch (e) {
        results[configName] = ValidationResult(
          isValid: false,
          errors: ['验证异常: $e'],
          warnings: [],
          suggestions: [],
          level: level,
          timestamp: DateTime.now(),
        );
      }
    }
    
    _logger.info('批量验证完成');
    return results;
  }

  /// 验证基本设置
  void _validateBasicSettings(
    FlClashSettings settings,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 验证核心版本
    if (settings.coreVersion.isEmpty) {
      warnings.add('核心版本未设置');
      suggestions.add('建议设置正确的 ClashMeta 核心版本');
    }
    
    // 验证代理模式
    if (![ProxyMode.rule, ProxyMode.global, ProxyMode.direct].contains(settings.mode)) {
      errors.add('无效的代理模式: ${settings.mode}');
    }
    
    // 验证日志级别
    if (![LogLevel.debug, LogLevel.info, LogLevel.warning, LogLevel.error].contains(settings.logLevel)) {
      errors.add('无效的日志级别: ${settings.logLevel}');
    }
  }

  /// 验证端口设置
  void _validatePorts(
    PortSettings ports,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 验证 HTTP 端口
    _validateSinglePort('HTTP', ports.httpPort, errors, warnings, suggestions);
    
    // 验证 SOCKS 端口
    _validateSinglePort('SOCKS', ports.socksPort, errors, warnings, suggestions);
    
    // 验证混合端口
    _validateSinglePort('Mixed', ports.mixedPort, errors, warnings, suggestions);
    
    // 验证 API 端口
    _validateSinglePort('API', ports.apiPort, errors, warnings, suggestions);
    
    // 检查端口冲突
    _checkPortConflicts(ports, errors, warnings, suggestions);
  }

  /// 验证单个端口
  void _validateSinglePort(
    String portType,
    int port,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    if (port <= 0 || port > 65535) {
      errors.add('$portType 端口无效: $port (范围: 1-65535)');
    } else if (port < 1024) {
      warnings.add('$portType 端口使用系统端口: $port (可能需要管理员权限)');
    } else if (port >= 49152) {
      warnings.add('$portType 端口使用动态端口范围: $port');
    }
  }

  /// 检查端口冲突
  void _checkPortConflicts(
    PortSettings ports,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    final ports = [ports.httpPort, ports.socksPort, ports.mixedPort, ports.apiPort];
    final portMap = <int, List<String>>{};
    
    for (final port in ports) {
      if (port <= 0) continue;
      portMap.putIfAbsent(port, () => []).add(ports.toString());
    }
    
    for (final entry in portMap.entries) {
      if (entry.value.length > 1) {
        errors.add('端口冲突: 端口 ${entry.key} 被多个服务使用 (${entry.value.join(', ')})');
      }
    }
  }

  /// 验证 DNS 设置
  void _validateDnsSettings(
    DNSSettings dns,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 验证自定义 DNS
    if (dns.customDNS) {
      if (dns.dnsServers.isEmpty) {
        errors.add('启用了自定义 DNS 但未设置 DNS 服务器');
      } else {
        for (final dnsServer in dns.dnsServers) {
          _validateDnsServer(dnsServer, errors, warnings, suggestions);
        }
      }
      
      // 验证 DoH 服务器
      if (dns.dnsOverHttps) {
        if (dns.dohServer == null || dns.dohServer!.isEmpty) {
          errors.add('启用了 DNS over HTTPS 但未设置 DoH 服务器');
        } else if (!_isValidUrl(dns.dohServer!)) {
          errors.add('无效的 DoH 服务器 URL: ${dns.dohServer}');
        }
      }
    }
  }

  /// 验证 DNS 服务器
  void _validateDnsServer(
    String dnsServer,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 验证 IP 地址格式
    if (_isValidIpAddress(dnsServer)) {
      return; // IP 地址格式正确
    }
    
    // 验证域名格式
    if (_isValidDomain(dnsServer)) {
      return; // 域名格式正确
    }
    
    // 验证 DoH 格式
    if (dnsServer.startsWith('https://') && _isValidUrl(dnsServer)) {
      return; // DoH URL 格式正确
    }
    
    errors.add('无效的 DNS 服务器格式: $dnsServer');
  }

  /// 验证代理列表
  void _validateProxyList(
    List<ProxyConfig> proxyList,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    if (proxyList.isEmpty) {
      warnings.add('代理列表为空');
      return;
    }
    
    final proxyNames = <String>{};
    final hostPortPairs = <String>{};
    
    for (int i = 0; i < proxyList.length; i++) {
      final proxy = proxyList[i];
      
      // 检查重复名称
      if (!proxyNames.add(proxy.name)) {
        errors.add('代理名称重复: ${proxy.name}');
      }
      
      // 验证基础字段
      _validateProxyBasic(proxy, i + 1, errors, warnings, suggestions);
      
      // 验证协议特定字段
      _validateProxyProtocolSpecific(proxy, i + 1, errors, warnings, suggestions);
      
      // 检查重复的服务器地址
      final hostPortKey = '${proxy.host}:${proxy.port}';
      if (!hostPortPairs.add(hostPortKey)) {
        warnings.add('代理 ${proxy.name} 与其他代理使用相同的服务器地址: $hostPortKey');
      }
    }
    
    // 验证代理组一致性
    _validateProxyGroupsConsistency(proxyList, errors, warnings, suggestions);
  }

  /// 验证代理基础字段
  void _validateProxyBasic(
    ProxyConfig proxy,
    int index,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    final prefix = '代理 #$index (${proxy.name})';
    
    // 验证名称
    if (proxy.name.isEmpty) {
      errors.add('$prefix: 名称不能为空');
    }
    
    // 验证服务器地址
    if (proxy.host.isEmpty) {
      errors.add('$prefix: 服务器地址不能为空');
    } else if (!_isValidDomain(proxy.host) && !_isValidIpAddress(proxy.host)) {
      warnings.add('$prefix: 服务器地址格式可能无效: ${proxy.host}');
    }
    
    // 验证端口
    if (proxy.port <= 0 || proxy.port > 65535) {
      errors.add('$prefix: 端口无效: ${proxy.port}');
    }
  }

  /// 验证协议特定字段
  void _validateProxyProtocolSpecific(
    ProxyConfig proxy,
    int index,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    final prefix = '代理 #$index (${proxy.name})';
    
    // 这里可以根据需要添加具体的协议验证逻辑
    // 目前简化处理
  }

  /// 验证代理组一致性
  void _validateProxyGroupsConsistency(
    List<ProxyConfig> proxyList,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    final proxyNames = proxyList.map((p) => p.name).toSet();
    
    // 检查所有代理都有唯一名称
    if (proxyNames.length != proxyList.length) {
      errors.add('代理名称存在重复');
    }
    
    // 建议添加负载均衡
    if (proxyList.length > 1) {
      suggestions.add('建议为多个代理配置负载均衡组');
    }
  }

  /// 验证严格模式
  void _validateStrict(
    FlClashSettings settings,
    List<ProxyConfig>? proxyList,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 验证更严格的配置选项
    _validateAdvancedSettings(settings, errors, warnings, suggestions);
    
    if (proxyList != null) {
      _validateProxyListStrict(proxyList, errors, warnings, suggestions);
    }
  }

  /// 验证高级设置
  void _validateAdvancedSettings(
    FlClashSettings settings,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 验证 Tun 模式
    if (settings.tunMode) {
      if (!settings.ipv6) {
        suggestions.add('建议在使用 Tun 模式时启用 IPv6');
      }
    }
    
    // 验证混合模式
    if (settings.mixedMode) {
      suggestions.add('混合模式可能会影响性能，建议仅在必要时使用');
    }
    
    // 验证系统代理
    if (settings.systemProxy) {
      warnings.add('系统代理可能需要管理员权限');
    }
  }

  /// 严格验证代理列表
  void _validateProxyListStrict(
    List<ProxyConfig> proxyList,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 验证代理性能
    _validateProxyPerformance(proxyList, warnings, suggestions);
    
    // 验证安全性
    _validateProxySecurity(proxyList, errors, warnings, suggestions);
    
    // 验证配置完整性
    _validateProxyCompleteness(proxyList, errors, warnings, suggestions);
  }

  /// 验证代理性能
  void _validateProxyPerformance(
    List<ProxyConfig> proxyList,
    List<String> warnings,
    List<String> suggestions,
  ) {
    if (proxyList.length > 50) {
      suggestions.add('代理数量较多，建议使用代理组管理');
    }
  }

  /// 验证代理安全性
  void _validateProxySecurity(
    List<ProxyConfig> proxyList,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 检查明文传输
    for (final proxy in proxyList) {
      // 这里可以添加具体的安全性检查逻辑
    }
  }

  /// 验证代理完整性
  void _validateProxyCompleteness(
    List<ProxyConfig> proxyList,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    for (final proxy in proxyList) {
      // 检查可选字段的完整性
      // 这里可以添加具体的完整性检查逻辑
    }
  }

  /// 验证解析后的配置
  void _validateParsedConfig(
    dynamic parseResult,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 验证代理列表
    if (parseResult is Map && parseResult['proxies'] != null) {
      // 处理代理列表验证逻辑
    }
    
    // 验证规则
    if (parseResult is Map && (parseResult['rules'] == null || (parseResult['rules'] as List).isEmpty)) {
      warnings.add('配置文件未包含任何规则');
    }
  }

  /// 验证 YAML 结构
  void _validateYamlStructure(
    String yamlContent,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 检查 YAML 基本结构
    try {
      final lines = yamlContent.split('\n');
      final hasProxies = lines.any((line) => line.trim().startsWith('proxies:'));
      final hasRules = lines.any((line) => line.trim().startsWith('rules:'));
      
      if (!hasProxies) {
        warnings.add('配置文件未包含代理列表');
      }
      
      if (!hasRules) {
        warnings.add('配置文件未包含规则列表');
      }
      
    } catch (e) {
      errors.add('YAML 结构验证失败: $e');
    }
  }

  /// 验证 IP 地址格式
  bool _isValidIpAddress(String input) {
    final ipRegex = RegExp(
      r'^(\d{1,3}\.){3}\d{1,3}$',
    );
    if (!ipRegex.hasMatch(input)) return false;
    
    final parts = input.split('.');
    return parts.every((part) {
      final num = int.tryParse(part);
      return num != null && num >= 0 && num <= 255;
    });
  }

  /// 验证域名格式
  bool _isValidDomain(String input) {
    final domainRegex = RegExp(
      r'^[a-zA-Z0-9]([a-zA-Z0-9\-\.]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-\.]{0,61}[a-zA-Z0-9])?)*$',
    );
    return domainRegex.hasMatch(input);
  }

  /// 验证 URL 格式
  bool _isValidUrl(String input) {
    try {
      Uri.parse(input);
      return true;
    } catch (e) {
      return false;
    }
  }
}
