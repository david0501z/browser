/// 配置文件验证器
/// 
/// 提供对代理配置文件的完整性和正确性验证功能
library config_validator;

import 'package:flutter/material.dart';
import '../core/proxy_config.dart';
import '../models/app_settings.dart';
import '../core/model_converter.dart';

/// 验证结果
class ConfigValidationResult {
  /// 是否验证通过
  final bool isValid;
  
  /// 验证错误列表
  final List<String> errors;
  
  /// 验证警告列表
  final List<String> warnings;
  
  /// 验证建议列表
  final List<String> suggestions;
  
  const ConfigValidationResult({
    required this.isValid,
    required this.errors,
    this.warnings = const [],
    this.suggestions = const [],
  });
}

/// 验证级别
enum ValidationLevel {
  /// 错误 - 配置无法使用
  error,
  /// 警告 - 配置可以工作但不理想
  warning,
  /// 建议 - 最佳实践建议
  suggestion,
}

/// 配置验证器
class ConfigValidator {
  /// 验证ProxyConfig的完整性
  static ConfigValidationResult validateProxyConfig(ProxyConfig config) {
    final errors = <String>[];
    final warnings = <String>[];
    final suggestions = <String>[];
    
    // 验证基本字段
    _validateBasicFields(config, errors, warnings, suggestions);
    
    // 验证端口配置
    _validatePortSettings(config, errors, warnings, suggestions);
    
    // 验证DNS配置
    _validateDnsSettings(config, errors, warnings, suggestions);
    
    // 验证规则配置
    _validateRules(config, errors, warnings, suggestions);
    
    // 验证节点配置
    _validateNodes(config, errors, warnings, suggestions);
    
    // 验证代理核心设置
    _validateProxyCoreSettings(config, errors, warnings, suggestions);
    
    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      suggestions: suggestions,
    );
  }
  
  /// 验证FlClashSettings的完整性
  static ConfigValidationResult validateFlClashSettings(FlClashSettings settings) {
    final errors = <String>[];
    final warnings = <String>[];
    final suggestions = <String>[];
    
    // 验证基本启用状态
    if (settings.enabled && settings.nodes.nodes.isEmpty) {
      errors.add('启用代理时至少需要配置一个节点');
    }
    
    // 验证端口冲突
    final ports = {
      settings.ports.httpPort,
      settings.ports.httpsPort,
      settings.ports.socksPort,
      settings.ports.mixedPort,
    };
    
    if (ports.length < 4) {
      errors.add('端口号不能重复');
    }
    
    // 验证端口范围
    if (settings.ports.httpPort < 1 || settings.ports.httpPort > 65535) {
      errors.add('HTTP端口号必须在 1-65535 范围内');
    }
    
    if (settings.ports.httpsPort < 1 || settings.ports.httpsPort > 65535) {
      errors.add('HTTPS端口号必须在 1-65535 范围内');
    }
    
    if (settings.ports.socksPort < 1 || settings.ports.socksPort > 65535) {
      errors.add('SOCKS端口号必须在 1-65535 范围内');
    }
    
    // 验证DNS设置
    if (!_isValidIP(settings.dns.primary)) {
      errors.add('主DNS地址格式无效');
    }
    
    if (!_isValidIP(settings.dns.secondary)) {
      errors.add('备用DNS地址格式无效');
    }
    
    if (settings.dns.doh && !_isValidUrl(settings.dns.dohUrl)) {
      errors.add('DoH URL格式无效');
    }
    
    // 验证模式兼容性
    if (settings.tunMode && settings.mixedMode) {
      errors.add('TUN模式和混合模式不能同时启用');
    }
    
    if (settings.systemProxy && settings.tunMode) {
      errors.add('系统代理和TUN模式不能同时启用');
    }
    
    // 验证代理核心设置
    if (settings.proxyCoreSettings != null) {
      final coreSettings = settings.proxyCoreSettings!;
      
      if (coreSettings.corePath.isEmpty) {
        errors.add('代理核心路径不能为空');
      }
      
      if (coreSettings.restartInterval <= 0) {
        errors.add('重启间隔必须大于0');
      }
      
      if (coreSettings.maxRestartCount < 0) {
        errors.add('最大重启次数不能为负数');
      }
    }
    
    // 性能建议
    if (settings.logLevel == LogLevel.debug) {
      warnings.add('调试模式可能会影响性能，建议在生产环境中使用 info 或 warning 级别');
    }
    
    if (!settings.traffic.enableStats) {
      suggestions.add('启用流量统计有助于监控网络使用情况');
    }
    
    if (!settings.autoUpdate) {
      suggestions.add('启用自动更新可以确保代理核心保持最新版本');
    }
    
    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      suggestions: suggestions,
    );
  }
  
  /// 验证转换的完整性
  static ConfigValidationResult validateConversion(FlClashSettings original, ProxyConfig converted) {
    final errors = <String>[];
    final warnings = <String>[];
    
    // 验证基本字段转换
    if (original.enabled != converted.enabled) {
      errors.add('启用状态转换错误');
    }
    
    if (original.mode.name != converted.mode.toLowerCase()) {
      errors.add('代理模式转换错误');
    }
    
    if (original.ipv6 != converted.enableIPv6) {
      errors.add('IPv6设置转换错误');
    }
    
    // 验证节点转换
    if (original.nodes.nodes.length != converted.nodes.length) {
      errors.add('节点数量转换错误');
    }
    
    // 验证端口转换
    if (original.ports.httpPort != converted.port) {
      warnings.add('HTTP端口转换可能存在差异');
    }
    
    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }
  
  /// 验证基本字段
  static void _validateBasicFields(
    ProxyConfig config,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 验证端口
    if (config.port < 1 || config.port > 65535) {
      errors.add('代理端口号必须在 1-65535 范围内');
    }
    
    // 验证监听地址
    if (config.listenAddress.isEmpty) {
      errors.add('监听地址不能为空');
    }
    
    // 验证代理模式
    if (config.mode.isEmpty) {
      errors.add('代理模式不能为空');
    }
    
    // 验证超时设置
    if (config.connectionTimeout <= 0) {
      errors.add('连接超时必须大于0');
    }
    
    if (config.readTimeout <= 0) {
      errors.add('读取超时必须大于0');
    }
    
    if (config.retryCount < 0) {
      errors.add('重试次数不能为负数');
    }
    
    // 建议设置
    if (config.connectionTimeout > 30) {
      suggestions.add('连接超时较长，建议优化网络配置');
    }
    
    if (config.retryCount > 5) {
      suggestions.add('重试次数较多，可能影响性能');
    }
  }
  
  /// 验证端口设置
  static void _validatePortSettings(
    ProxyConfig config,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 检查常见端口冲突
    final commonPorts = [80, 443, 8080, 8443, 1080];
    if (commonPorts.contains(config.port)) {
      warnings.add('使用了常见端口 $config.port，可能与其他服务冲突');
    }
    
    // 检查端口范围
    if (config.port < 1024 && config.listenAddress != '127.0.0.1') {
      warnings.add('使用系统端口 (<1024) 可能需要管理员权限');
    }
  }
  
  /// 验证DNS设置
  static void _validateDnsSettings(
    ProxyConfig config,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 验证DNS地址
    if (!_isValidIP(config.primaryDNS)) {
      errors.add('主DNS地址格式无效');
    }
    
    if (!_isValidIP(config.secondaryDNS)) {
      errors.add('备用DNS地址格式无效');
    }
    
    if (config.primaryDNS == config.secondaryDNS) {
      warnings.add('主DNS和备用DNS地址相同，建议使用不同的DNS服务器');
    }
    
    // 验证DoH设置
    if (config.dnsOverHttps && config.dohUrl.isEmpty) {
      errors.add('启用DoH时需要配置DoH URL');
    }
  }
  
  /// 验证规则配置
  static void _validateRules(
    ProxyConfig config,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 验证规则ID唯一性
    final ruleIds = <String>{};
    for (final rule in config.rules) {
      if (ruleIds.contains(rule.id)) {
        errors.add('规则ID重复: ${rule.id}');
      }
      ruleIds.add(rule.id);
    }
    
    // 验证规则优先级
    final priorities = config.rules.map((r) => r.priority).toList();
    priorities.sort();
    
    for (int i = 1; i < priorities.length; i++) {
      if (priorities[i] == priorities[i - 1]) {
        warnings.add('存在相同优先级的规则: ${priorities[i]}');
      }
    }
    
    // 建议优化
    if (config.rules.isEmpty) {
      suggestions.add('建议添加路由规则以提高代理效率');
    }
  }
  
  /// 验证节点配置
  static void _validateNodes(
    ProxyConfig config,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 验证节点ID
    final nodeIds = <String>{};
    for (final node in config.nodes) {
      if (nodeIds.contains(node.id)) {
        errors.add('节点ID重复: ${node.id}');
      }
      nodeIds.add(node.id);
    }
    
    // 验证选中节点
    if (config.selectedNodeId.isNotEmpty) {
      final selectedNodeExists = config.nodes.any((n) => n.id == config.selectedNodeId);
      if (!selectedNodeExists) {
        errors.add('选中的节点不存在: ${config.selectedNodeId}');
      }
    }
    
    // 建议优化
    if (config.nodes.length < 2) {
      suggestions.add('建议配置多个节点以提高连接稳定性');
    }
  }
  
  /// 验证代理核心设置
  static void _validateProxyCoreSettings(
    ProxyConfig config,
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
  ) {
    // 从自定义设置中获取代理核心设置
    final coreSettings = config.customSettings['proxyCoreSettings'] as Map<String, dynamic>?;
    if (coreSettings == null) return;
    
    // 验证核心路径
    final corePath = coreSettings['corePath'] as String?;
    if (corePath == null || corePath.isEmpty) {
      errors.add('代理核心路径不能为空');
    }
    
    // 验证重启设置
    final restartInterval = coreSettings['restartInterval'] as int?;
    if (restartInterval != null && restartInterval <= 0) {
      errors.add('重启间隔必须大于0');
    }
    
    final maxRestartCount = coreSettings['maxRestartCount'] as int?;
    if (maxRestartCount != null && maxRestartCount < 0) {
      errors.add('最大重启次数不能为负数');
    }
  }
  
  /// IP地址验证
  static bool _isValidIP(String ip) {
    if (ip.isEmpty) return false;
    final parts = ip.split('.');
    if (parts.length != 4) return false;
    
    for (final part in parts) {
      try {
        final num = int.parse(part);
        if (num < 0 || num > 255) return false;
      } catch (e) {
        return false;
      }
    }
    
    return true;
  }
  
  /// URL验证
  static bool _isValidUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}

/// 验证扩展方法
extension ConfigValidatorExtensions on ProxyConfig {
  /// 验证当前配置
  ConfigValidationResult validate() {
    return ConfigValidator.validateProxyConfig(this);
  }
  
  /// 检查配置是否有效
  bool isValid() {
    return validate().isValid;
  }
}

extension FlClashSettingsValidatorExtensions on FlClashSettings {
  /// 验证当前设置
  ConfigValidationResult validate() {
    return ConfigValidator.validateFlClashSettings(this);
  }
  
  /// 检查设置是否有效
  bool isValid() {
    return validate().isValid;
  }
  
  /// 验证转换后的配置
  ConfigValidationResult validateConversion() {
    final proxyConfig = toProxyConfig();
    return ConfigValidator.validateConversion(this, proxyConfig);
  }
}