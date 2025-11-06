/// 协议兼容性验证器
/// 提供统一的协议兼容性和功能验证服务
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'protocol_test_suite.dart';
import 'v2ray_test.dart';
import 'vless_test.dart';
import 'hysteria_test.dart';
import 'trojan_test.dart';
import 'ss_ssr_test.dart';

/// 兼容性验证结果
class CompatibilityResult {
  final String protocol;
  final String feature;
  final bool isCompatible;
  final String message;
  final double confidence;
  final List<String> recommendations;

  CompatibilityResult({
    required this.protocol,
    required this.feature,
    required this.isCompatible,
    required this.message,
    required this.confidence,
    required this.recommendations,
  });

  @override
  String toString() {
    return '$protocol - $feature: ${isCompatible ? '✅' : '❌'} ($message)';
  }
}

/// 协议验证配置
class ProtocolValidationConfig {
  final String protocol;
  final String version;
  final Map<String, dynamic> config;
  final List<String> requiredFeatures;
  final List<String> optionalFeatures;
  final Map<String, dynamic> constraints;

  ProtocolValidationConfig({
    required this.protocol,
    required this.version,
    required this.config,
    required this.requiredFeatures,
    required this.optionalFeatures,
    required this.constraints,
  });
}

/// 协议兼容性验证器
class ProtocolValidator {
  static const ProtocolValidator _instance = ProtocolValidator._internal();
  factory ProtocolValidator() => _instance;
  const ProtocolValidator._internal();

  final Map<String, ProtocolCapability> _protocolCapabilities = {
    'V2Ray': ProtocolCapability(
      protocol: 'V2Ray',
      minVersion: '4.0.0',
      supportedTransports: ['tcp', 'ws', 'grpc', 'http', 'quic'],
      supportedSecurity: ['none', 'tls', 'xtls'],
      supportedProtocols: ['vmess', 'vless', 'trojan', 'shadowsocks', 'socks'],
      maxConcurrentConnections: 256,
      features: [
        'splitting',
        'routing',
        'dns',
        'mux',
        'reverse',
        'vnet',
      ],
    ),
    'VLESS': ProtocolCapability(
      protocol: 'VLESS',
      minVersion: '1.0.0',
      supportedTransports: ['tcp', 'ws', 'grpc'],
      supportedSecurity: ['none', 'tls', 'xtls'],
      supportedProtocols: ['vless'],
      maxConcurrentConnections: 256,
      features: [
        'xtls',
        'flow-control',
        'zero-copy',
      ],
    ),
    'Hysteria': ProtocolCapability(
      protocol: 'Hysteria',
      minVersion: '1.0.0',
      supportedTransports: ['udp'],
      supportedSecurity: ['none', 'tls'],
      supportedProtocols: ['hysteria'],
      maxConcurrentConnections: 64,
      features: [
        'bandwidth-control',
        'packet-loss-recovery',
        'fast-open',
        'multiplexing',
      ],
    ),
    'Trojan': ProtocolCapability(
      protocol: 'Trojan',
      minVersion: '1.0.0',
      supportedTransports: ['tcp', 'ws', 'grpc'],
      supportedSecurity: ['none', 'tls', 'xtls'],
      supportedProtocols: ['trojan'],
      maxConcurrentConnections: 128,
      features: [
        'flow-control',
        'xtls',
        ' masquerade',
        'multiplexing',
      ],
    ),
    'Shadowsocks': ProtocolCapability(
      protocol: 'Shadowsocks',
      minVersion: '3.0.0',
      supportedTransports: ['tcp', 'udp'],
      supportedSecurity: ['none'],
      supportedProtocols: ['shadowsocks'],
      maxConcurrentConnections: 512,
      features: [
        'encryption',
        'plugins',
        'obfuscation',
        'multiplexing',
      ],
    ),
  };

  /// 验证协议配置
  Future<List<CompatibilityResult>> validateConfiguration(
    ProtocolValidationConfig config,
  ) async {
    final results = <CompatibilityResult>[];
    
    // 基础协议验证
    results.add(await _validateBasicProtocol(config));
    
    // 传输层验证
    results.addAll(await _validateTransportLayer(config));
    
    // 安全层验证
    results.addAll(await _validateSecurityLayer(config));
    
    // 功能特性验证
    results.addAll(await _validateFeatures(config));
    
    // 性能约束验证
    results.addAll(await _validatePerformanceConstraints(config));
    
    // 兼容性验证
    results.addAll(await _validateCompatibility(config));
    
    return results;
  }

  /// 验证协议栈兼容性
  Future<List<CompatibilityResult>> validateProtocolStack(
    List<ProtocolValidationConfig> configs,
  ) async {
    final results = <CompatibilityResult>[];
    
    for (int i = 0; i < configs.length; i++) {
      for (int j = i + 1; j < configs.length; j++) {
        final config1 = configs[i];
        final config2 = configs[j];
        
        // 验证端口冲突
        results.add(_validatePortConflicts(config1, config2));
        
        // 验证传输协议冲突
        results.add(_validateTransportConflicts(config1, config2));
        
        // 验证安全层冲突
        results.add(_validateSecurityConflicts(config1, config2));
      }
    }
    
    // 验证多协议协调
    results.add(await _validateMultiProtocolCoordination(configs));
    
    return results;
  }

  /// 生成优化建议
  Future<List<String>> generateOptimizationSuggestions(
    ProtocolValidationConfig config,
    List<CompatibilityResult> validationResults,
  ) async {
    final suggestions = <String>[];
    
    for (final result in validationResults) {
      if (!result.isCompatible) {
        suggestions.addAll(result.recommendations);
      }
    }
    
    // 性能优化建议
    suggestions.addAll(await _generatePerformanceOptimizations(config));
    
    // 安全性优化建议
    suggestions.addAll(await _generateSecurityOptimizations(config));
    
    // 兼容性优化建议
    suggestions.addAll(await _generateCompatibilityOptimizations(config));
    
    return suggestions.toSet().toList(); // 去重
  }

  /// 基础协议验证
  Future<CompatibilityResult> _validateBasicProtocol(
    ProtocolValidationConfig config,
  ) async {
    final capability = _protocolCapabilities[config.protocol];
    
    if (capability == null) {
      return CompatibilityResult(
        protocol: config.protocol,
        feature: '基础协议支持',
        isCompatible: false,
        message: '未知协议类型',
        confidence: 0.0,
        recommendations: ['选择支持的协议类型', '检查协议名称拼写'],
      );
    }
    
    // 检查协议版本兼容性
    final isVersionCompatible = _checkVersionCompatibility(
      capability.minVersion,
      config.version,
    );
    
    if (!isVersionCompatible) {
      return CompatibilityResult(
        protocol: config.protocol,
        feature: '版本兼容性',
        isCompatible: false,
        message: '版本不兼容 (最少需要 ${capability.minVersion})',
        confidence: 0.0,
        recommendations: [
          '升级协议版本到 ${capability.minVersion} 或更高',
          '检查配置文件中的版本设置',
        ],
      );
    }
    
    return CompatibilityResult(
      protocol: config.protocol,
      feature: '基础协议支持',
      isCompatible: true,
      message: '协议配置正确',
      confidence: 1.0,
      recommendations: [],
    );
  }

  /// 传输层验证
  Future<List<CompatibilityResult>> _validateTransportLayer(
    ProtocolValidationConfig config,
  ) async {
    final results = <CompatibilityResult>[];
    final capability = _protocolCapabilities[config.protocol];
    
    if (capability == null) return results;
    
    final networkType = config.config['network'] ?? 'tcp';
    
    // 检查传输协议支持
    if (!capability.supportedTransports.contains(networkType)) {
      results.add(CompatibilityResult(
        protocol: config.protocol,
        feature: '传输协议支持',
        isCompatible: false,
        message: '不支持的传输协议: $networkType',
        confidence: 0.0,
        recommendations: [
          '选择支持的传输协议: ${capability.supportedTransports.join(', ')}',
          '当前配置中network参数可能错误',
        ],
      ));
    }
    
    // 检查协议特性兼容性
    if (networkType == 'quic' && config.protocol == 'V2Ray') {
      results.add(CompatibilityResult(
        protocol: config.protocol,
        feature: 'QUIC 支持',
        isCompatible: true,
        message: 'QUIC 传输支持',
        confidence: 0.9,
        recommendations: ['考虑开启 BBR 拥塞控制'],
      ));
    }
    
    if (networkType == 'grpc' && config.protocol == 'Hysteria') {
      results.add(CompatibilityResult(
        protocol: config.protocol,
        feature: 'gRPC 传输支持',
        isCompatible: false,
        message: 'Hysteria 不支持 gRPC 传输',
        confidence: 1.0,
        recommendations: [
          'Hysteria 仅支持 UDP 传输',
          '考虑使用 V2Ray 或 Trojan 的 gRPC 支持',
        ],
      ));
    }
    
    return results;
  }

  /// 安全层验证
  Future<List<CompatibilityResult>> _validateSecurityLayer(
    ProtocolValidationConfig config,
  ) async {
    final results = <CompatibilityResult>[];
    final capability = _protocolCapabilities[config.protocol];
    
    if (capability == null) return results;
    
    final security = config.config['security'] ?? 'none';
    
    // 检查安全协议支持
    if (!capability.supportedSecurity.contains(security)) {
      results.add(CompatibilityResult(
        protocol: config.protocol,
        feature: '安全协议支持',
        isCompatible: false,
        message: '不支持的安全协议: $security',
        confidence: 0.0,
        recommendations: [
          '选择支持的安全协议: ${capability.supportedSecurity.join(', ')}',
          '检查配置文件中的security参数',
        ],
      ));
    }
    
    // 检查 TLS 配置
    if (security == 'tls') {
      final tlsConfig = config.config['tls'];
      if (tlsConfig == null) {
        results.add(CompatibilityResult(
          protocol: config.protocol,
          feature: 'TLS 配置',
          isCompatible: false,
          message: '启用 TLS 但缺少 TLS 配置',
          confidence: 0.8,
          recommendations: [
            '添加 TLS 配置信息',
            '指定 server_name (SNI)',
            '考虑配置证书验证',
          ],
        ));
      }
    }
    
    // 检查 XTLS 配置
    if (security == 'xtls') {
      if (config.protocol == 'Shadowsocks') {
        results.add(CompatibilityResult(
          protocol: config.protocol,
          feature: 'XTLS 支持',
          isCompatible: false,
          message: 'Shadowsocks 不支持 XTLS',
          confidence: 1.0,
          recommendations: [
            'Shadowsocks 原生不支持 XTLS',
            '考虑使用 Trojan 或 VLESS 协议',
            '可以使用插件实现类似功能',
          ],
        ));
      }
    }
    
    return results;
  }

  /// 功能特性验证
  Future<List<CompatibilityResult>> _validateFeatures(
    ProtocolValidationConfig config,
  ) async {
    final results = <CompatibilityResult>[];
    final capability = _protocolCapabilities[config.protocol];
    
    if (capability == null) return results;
    
    // 检查必需功能
    for (final feature in config.requiredFeatures) {
      if (!capability.features.contains(feature)) {
        results.add(CompatibilityResult(
          protocol: config.protocol,
          feature: '必需功能',
          isCompatible: false,
          message: '缺少必需功能: $feature',
          confidence: 0.0,
          recommendations: [
            '当前协议不支持 $feature 功能',
            '考虑切换到支持该功能的协议',
            '查看协议版本是否需要升级',
          ],
        ));
      }
    }
    
    // 检查可选功能
    for (final feature in config.optionalFeatures) {
      if (capability.features.contains(feature)) {
        results.add(CompatibilityResult(
          protocol: config.protocol,
          feature: '可选功能',
          isCompatible: true,
          message: '支持可选功能: $feature',
          confidence: 0.8,
          recommendations: ['建议启用 $feature 功能提升性能'],
        ));
      }
    }
    
    return results;
  }

  /// 性能约束验证
  Future<List<CompatibilityResult>> _validatePerformanceConstraints(
    ProtocolValidationConfig config,
  ) async {
    final results = <CompatibilityResult>[];
    final capability = _protocolCapabilities[config.protocol];
    
    if (capability == null) return results;
    
    // 检查并发连接数
    final expectedConnections = config.constraints['max_connections'] ?? 1;
    if (expectedConnections > capability.maxConcurrentConnections) {
      results.add(CompatibilityResult(
        protocol: config.protocol,
        feature: '并发连接数',
        isCompatible: false,
        message: '并发连接数超限 (期望: $expectedConnections, 限制: ${capability.maxConcurrentConnections})',
        confidence: 0.0,
        recommendations: [
          '减少并发连接数到 ${capability.maxConcurrentConnections} 或更低',
          '考虑使用多实例部署',
          '优化连接复用策略',
        ],
      ));
    }
    
    // 检查带宽配置
    final expectedBandwidth = config.constraints['expected_bandwidth'] ?? 0;
    if (config.protocol == 'Hysteria' && expectedBandwidth > 100) {
      results.add(CompatibilityResult(
        protocol: config.protocol,
        feature: '高带宽支持',
        isCompatible: true,
        message: 'Hysteria 适合高带宽场景',
        confidence: 0.9,
        recommendations: [
          'Hysteria 擅长高带宽传输',
          '建议配置合适的上下行带宽参数',
          '考虑使用 BBR 拥塞控制',
        ],
      ));
    }
    
    return results;
  }

  /// 兼容性验证
  Future<List<CompatibilityResult>> _validateCompatibility(
    ProtocolValidationConfig config,
  ) async {
    final results = <CompatibilityResult>[];
    
    // 检查防火墙兼容性
    if (config.protocol == 'Hysteria' && config.config['network'] == 'udp') {
      results.add(CompatibilityResult(
        protocol: config.protocol,
        feature: '防火墙兼容性',
        isCompatible: false,
        message: 'UDP 流量可能被防火墙阻断',
        confidence: 0.6,
        recommendations: [
          '考虑在防火墙友好的网络环境下使用',
          '可尝试使用 TCP 传输协议的替代方案',
          '配置 UDP 流量放行规则',
        ],
      ));
    }
    
    // 检查移动网络兼容性
    if (config.protocol == 'Hysteria') {
      results.add(CompatibilityResult(
        protocol: config.protocol,
        feature: '移动网络兼容性',
        isCompatible: true,
        message: 'Hysteria 在移动网络下表现良好',
        confidence: 0.8,
        recommendations: [
          'Hysteria 适合移动网络环境',
          '建议配置适中的带宽参数',
          '注意流量消耗控制',
        ],
      ));
    }
    
    // 检查游戏场景兼容性
    if (config.protocol == 'Shadowsocks') {
      results.add(CompatibilityResult(
        protocol: config.protocol,
        feature: '游戏场景兼容性',
        isCompatible: true,
        message: 'Shadowsocks 延迟较低，适合游戏',
        confidence: 0.9,
        recommendations: [
          'Shadowsocks 延迟表现优秀',
          '建议使用 AEAD 加密算法',
          '考虑开启 fast-open 减少握手时间',
        ],
      ));
    }
    
    return results;
  }

  /// 验证端口冲突
  CompatibilityResult _validatePortConflicts(
    ProtocolValidationConfig config1,
    ProtocolValidationConfig config2,
  ) {
    final port1 = config1.config['serverPort'] ?? 0;
    final port2 = config2.config['serverPort'] ?? 0;
    
    if (port1 == port2 && port1 > 0) {
      return CompatibilityResult(
        protocol: '${config1.protocol}+${config2.protocol}',
        feature: '端口冲突检查',
        isCompatible: false,
        message: '端口冲突: 两个配置都使用端口 $port1',
        confidence: 1.0,
        recommendations: [
          '修改其中一个配置的端口号',
          '使用端口转发或负载均衡',
          '采用多协议共享端口技术',
        ],
      );
    }
    
    return CompatibilityResult(
      protocol: '${config1.protocol}+${config2.protocol}',
      feature: '端口冲突检查',
      isCompatible: true,
      message: '端口配置无冲突',
      confidence: 1.0,
      recommendations: [],
    );
  }

  /// 验证传输协议冲突
  CompatibilityResult _validateTransportConflicts(
    ProtocolValidationConfig config1,
    ProtocolValidationConfig config2,
  ) {
    final network1 = config1.config['network'] ?? 'tcp';
    final network2 = config2.config['network'] ?? 'tcp';
    
    // 大多数传输协议可以共存
    return CompatibilityResult(
      protocol: '${config1.protocol}+${config2.protocol}',
      feature: '传输协议冲突检查',
      isCompatible: true,
      message: '传输协议 $network1 和 $network2 可以共存',
      confidence: 1.0,
      recommendations: [],
    );
  }

  /// 验证安全层冲突
  CompatibilityResult _validateSecurityConflicts(
    ProtocolValidationConfig config1,
    ProtocolValidationConfig config2,
  ) {
    final security1 = config1.config['security'] ?? 'none';
    final security2 = config2.config['security'] ?? 'none';
    
    // 安全层通常可以共存
    return CompatibilityResult(
      protocol: '${config1.protocol}+${config2.protocol}',
      feature: '安全层冲突检查',
      isCompatible: true,
      message: '安全层 $security1 和 $security2 可以共存',
      confidence: 1.0,
      recommendations: [],
    );
  }

  /// 验证多协议协调
  Future<CompatibilityResult> _validateMultiProtocolCoordination(
    List<ProtocolValidationConfig> configs,
  ) async {
    await Future.delayed(Duration(milliseconds: 100));
    
    final protocols = configs.map((c) => c.protocol).toSet();
    
    if (protocols.length > 3) {
      return CompatibilityResult(
        protocol: '多协议协调',
        feature: '协议数量',
        isCompatible: false,
        message: '同时运行过多协议可能影响性能',
        confidence: 0.7,
        recommendations: [
          '建议限制同时运行的协议数量',
          '考虑按需启用协议',
          '监控系统资源使用情况',
        ],
      );
    }
    
    return CompatibilityResult(
      protocol: '多协议协调',
      feature: '协议数量',
      isCompatible: true,
      message: '协议配置协调性良好',
      confidence: 1.0,
      recommendations: [],
    );
  }

  /// 版本兼容性检查
  bool _checkVersionCompatibility(String minVersion, String currentVersion) {
    final minParts = minVersion.split('.').map(int.parse).toList();
    final currentParts = currentVersion.split('.').map(int.parse).toList();
    
    for (int i = 0; i < 3; i++) {
      if (currentParts[i] < minParts[i]) return false;
      if (currentParts[i] > minParts[i]) return true;
    }
    
    return true;
  }

  /// 生成性能优化建议
  Future<List<String>> _generatePerformanceOptimizations(
    ProtocolValidationConfig config,
  ) async {
    final suggestions = <String>[];
    
    await Future.delayed(Duration(milliseconds: 50));
    
    switch (config.protocol) {
      case 'Hysteria':
        suggestions.addAll([
          '启用 fast-open 减少握手时间',
          '配置合适的带宽参数',
          '考虑使用 BBR 拥塞控制算法',
        ]);
        break;
      case 'VLESS':
        suggestions.addAll([
          '启用 XTLS 提升性能和安全性',
          '使用 xtls-rprx-vision 流控',
          '开启多路复用减少连接开销',
        ]);
        break;
      case 'Trojan':
        suggestions.addAll([
          '配置流量伪装提升抗检测能力',
          '启用 WebSocket 传输穿越防火墙',
          '使用合适的 TLS 证书',
        ]);
        break;
      case 'Shadowsocks':
        suggestions.addAll([
          '使用 AEAD 加密算法提升安全性',
          '启用插件增强功能',
          '选择适合设备性能的加密方法',
        ]);
        break;
    }
    
    return suggestions;
  }

  /// 生成安全性优化建议
  Future<List<String>> _generateSecurityOptimizations(
    ProtocolValidationConfig config,
  ) async {
    final suggestions = <String>[];
    
    await Future.delayed(Duration(milliseconds: 50));
    
    if (config.config['security'] == 'none') {
      suggestions.add('建议启用 TLS 或 XTLS 加密');
    }
    
    final sni = config.config['tls']?['server_name'];
    if (sni == null) {
      suggestions.add('配置 SNI (Server Name Indication) 提升 TLS 兼容性');
    }
    
    suggestions.addAll([
      '使用强密码增强安全性',
      '定期更新证书和密钥',
      '启用证书验证防止中间人攻击',
    ]);
    
    return suggestions;
  }

  /// 生成兼容性优化建议
  Future<List<String>> _generateCompatibilityOptimizations(
    ProtocolValidationConfig config,
  ) async {
    final suggestions = <String>[];
    
    await Future.delayed(Duration(milliseconds: 50));
    
    final network = config.config['network'] ?? 'tcp';
    
    if (network == 'quic') {
      suggestions.add('QUIC 可能被某些网络环境阻断，建议准备 TCP 备选方案');
    }
    
    if (config.protocol == 'Hysteria') {
      suggestions.add('Hysteria 使用 UDP，需要确保网络环境支持');
    }
    
    suggestions.addAll([
      '在多个网络环境下测试兼容性',
      '配置多种传输协议备选方案',
      '监控网络质量并自动切换',
    ]);
    
    return suggestions;
  }
}

/// 协议能力描述
class ProtocolCapability {
  final String protocol;
  final String minVersion;
  final List<String> supportedTransports;
  final List<String> supportedSecurity;
  final List<String> supportedProtocols;
  final int maxConcurrentConnections;
  final List<String> features;

  ProtocolCapability({
    required this.protocol,
    required this.minVersion,
    required this.supportedTransports,
    required this.supportedSecurity,
    required this.supportedProtocols,
    required this.maxConcurrentConnections,
    required this.features,
  });
}

/// 验证示例
void main() async {
  print('🔍 协议兼容性验证器测试');
  print('=' * 50);

  final validator = ProtocolValidator();

  // 测试 VLESS 配置
  final vlessConfig = ProtocolValidationConfig(
    protocol: 'VLESS',
    version: '1.5.0',
    config: {
      'server': 'test.example.com',
      'serverPort': 443,
      'uuid': '12345678-1234-1234-1234-123456789012',
      'security': 'xtls',
      'network': 'tcp',
      'flow': 'xtls-rprx-vision',
      'tls': {
        'enabled': true,
        'server_name': 'test.example.com',
      },
    },
    requiredFeatures: ['xtls', 'flow-control'],
    optionalFeatures: ['zero-copy', 'mux'],
    constraints: {
      'max_connections': 100,
      'expected_bandwidth': 50,
    },
  );

  final results = await validator.validateConfiguration(vlessConfig);
  
  print('验证结果:');
  for (final result in results) {
    print(result);
  }

  final suggestions = await validator.generateOptimizationSuggestions(
    vlessConfig,
    results,
  );

  print('\n优化建议:');
  for (final suggestion in suggestions) {
    print('• $suggestion');
  }

  print('\n✅ 协议兼容性验证完成');
}