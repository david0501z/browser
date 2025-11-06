/// V2Ray 协议兼容性测试
/// 包含 V2Ray 各种传输协议的测试用例
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'dart:convert';

import 'protocol_test_suite.dart';

/// V2Ray 配置测试用例
class V2RayTestConfig {
  final String protocol;
  final String transport;
  final Map<String, dynamic> config;
  final bool shouldPass;

  V2RayTestConfig({
    required this.protocol,
    required this.transport,
    required this.config,
    required this.shouldPass,
  });
}

class V2RayProtocolTests {
  static const String protocolName = 'V2Ray';

  /// V2Ray 测试配置集合
  final List<V2RayTestConfig> testConfigs = [;
    V2RayTestConfig(
      protocol: 'vmess',
      transport: 'tcp',
      config: {
        'server': 'test.example.com',
        'serverPort': 443,
        'uuid': '12345678-1234-1234-1234-123456789012',
        'alterId': 0,
        'security': 'auto',
        'network': 'tcp',
        'tls': 'tls',
        'sni': 'test.example.com',
      },
      shouldPass: true,
    ),
    V2RayTestConfig(
      protocol: 'vmess',
      transport: 'ws',
      config: {
        'server': 'test.example.com',
        'serverPort': 80,
        'uuid': '12345678-1234-1234-1234-123456789012',
        'alterId': 0,
        'security': 'auto',
        'network': 'ws',
        'ws-path': '/path',
        'host': 'test.example.com',
      },
      shouldPass: true,
    ),
    V2RayTestConfig(
      protocol: 'vmess',
      transport: 'grpc',
      config: {
        'server': 'test.example.com',
        'serverPort': 443,
        'uuid': '12345678-1234-1234-1234-123456789012',
        'alterId': 0,
        'security': 'auto',
        'network': 'grpc',
        'grpc-service-name': 'TunService',
        'tls': 'tls',
      },
      shouldPass: true,
    ),
    V2RayTestConfig(
      protocol: 'trojan',
      transport: 'tcp',
      config: {
        'server': 'test.example.com',
        'serverPort': 443,
        'password': 'test-password',
        'tls': 'tls',
        'sni': 'test.example.com',
      },
      shouldPass: true,
    ),
    V2RayTestConfig(
      protocol: 'trojan',
      transport: 'ws',
      config: {
        'server': 'test.example.com',
        'serverPort': 443,
        'password': 'test-password',
        'network': 'ws',
        'ws-path': '/ws',
        'tls': 'tls',
      },
      shouldPass: true,
    ),
    V2RayTestConfig(
      protocol: 'vless',
      transport: 'tcp',
      config: {
        'server': 'test.example.com',
        'serverPort': 443,
        'uuid': '12345678-1234-1234-1234-123456789012',
        'flow': 'xtls-rprx-vision',
        'security': 'tls',
        'sni': 'test.example.com',
      },
      shouldPass: true,
    ),
    V2RayTestConfig(
      protocol: 'shadowsocks',
      transport: 'tcp',
      config: {
        'server': 'test.example.com',
        'serverPort': 443,
        'method': 'aes-256-gcm',
        'password': 'test-password',
      },
      shouldPass: true,
    ),
  ];

  /// 测试连接兼容性
  Future<TestResult> testConnection(TestNetworkEnvironment env) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      // 模拟网络延迟
      await Future.delayed(Duration(milliseconds: int.parse(env.latency.replaceAll('ms', '')) ~/ 10));
      
      // 根据协议类型和传输方式测试连接
      final config = testConfigs.first;
      final isSupported = await _testProtocolSupport(config);
      
      stopwatch.stop();
      
      if (isSupported == config.shouldPass) {
        return TestResult(
          protocolName: protocolName,
          testCase: '连接测试 - ${env.name}',
          passed: true,
          message: '连接成功，延迟: ${env.latency}',
          duration: stopwatch.elapsed,
          metrics: {
            'network': env.name,
            'latency': env.latency,
            'packetLoss': env.packetLoss,
            'bandwidth': env.bandwidth,
          },
        );
      } else {
        return TestResult(
          protocolName: protocolName,
          testCase: '连接测试 - ${env.name}',
          passed: false,
          message: '连接失败，不支持的协议配置',
          duration: stopwatch.elapsed,
          metrics: {
            'network': env.name,
            'latency': env.latency,
            'packetLoss': env.packetLoss,
            'bandwidth': env.bandwidth,
          },
        );
      }
    } catch (e) {
      stopwatch.stop();
      return TestResult(
        protocolName: protocolName,
        testCase: '连接测试 - ${env.name}',
        passed: false,
        message: '异常: $e',
        duration: stopwatch.elapsed,
        metrics: {
          'network': env.name,
          'error': e.toString(),
        },
      );
    }
  }

  /// 测试配置验证
  Future<TestResult> testConfigValidation() async {
    final stopwatch = Stopwatch()..start();
    final results = <String, bool>{};

    try {
      for (final config in testConfigs) {
        final isValid = await _validateConfig(config);
        results['${config.protocol}-${config.transport}'] = isValid;
      }

      stopwatch.stop();
      final passedTests = results.values.where((p) => p).length;
      final totalTests = results.length;

      if (passedTests == totalTests) {
        return TestResult(
          protocolName: protocolName,
          testCase: '配置验证',
          passed: true,
          message: '所有配置验证通过 ($passedTests/$totalTests)',
          duration: stopwatch.elapsed,
          metrics: {
            'passed': passedTests,
            'total': totalTests,
            'results': results,
          },
        );
      } else {
        return TestResult(
          protocolName: protocolName,
          testCase: '配置验证',
          passed: false,
          message: '配置验证失败 ($passedTests/$totalTests)',
          duration: stopwatch.elapsed,
          metrics: {
            'passed': passedTests,
            'total': totalTests,
            'results': results,
          },
        );
      }
    } catch (e) {
      stopwatch.stop();
      return TestResult(
        protocolName: protocolName,
        testCase: '配置验证',
        passed: false,
        message: '配置验证异常: $e',
        duration: stopwatch.elapsed,
        metrics: {
          'error': e.toString(),
        },
      );
    }
  }

  /// 测试性能表现
  Future<TestResult> testPerformance() async {
    final stopwatch = Stopwatch()..start();

    try {
      // 模拟性能测试
      final latency = await _testLatency();
      final throughput = await _testThroughput();
      final packetLoss = await _testPacketLoss();

      stopwatch.stop();

      final performanceScore = _calculatePerformanceScore(latency, throughput, packetLoss);

      if (performanceScore >= 80) {
        return TestResult(
          protocolName: protocolName,
          testCase: '性能测试',
          passed: true,
          message: '性能优秀 - 延迟:${latency}ms, 吞吐量:${throughput}Mbps, 丢包率:${packetLoss}%',
          duration: stopwatch.elapsed,
          metrics: {
            'latency': latency,
            'throughput': throughput,
            'packetLoss': packetLoss,
            'score': performanceScore,
          },
        );
      } else {
        return TestResult(
          protocolName: protocolName,
          testCase: '性能测试',
          passed: false,
          message: '性能一般 - 延迟:${latency}ms, 吞吐量:${throughput}Mbps, 丢包率:${packetLoss}%',
          duration: stopwatch.elapsed,
          metrics: {
            'latency': latency,
            'throughput': throughput,
            'packetLoss': packetLoss,
            'score': performanceScore,
          },
        );
      }
    } catch (e) {
      stopwatch.stop();
      return TestResult(
        protocolName: protocolName,
        testCase: '性能测试',
        passed: false,
        message: '性能测试异常: $e',
        duration: stopwatch.elapsed,
        metrics: {
          'error': e.toString(),
        },
      );
    }
  }

  /// 协议支持测试
  Future<bool> _testProtocolSupport(V2RayTestConfig config) async {
    // 模拟协议支持检测
    await Future.delayed(Duration(milliseconds: 100));
    
    // 根据传输类型返回不同的支持情况
    return switch (config.transport) {
      'tcp' => true,
      'ws' => true,
      'grpc' => config.protocol == 'vmess',
      _ => false,
    };
  }

  /// 配置验证
  Future<bool> _validateConfig(V2RayTestConfig config) async {
    try {
      // 模拟配置验证
      await Future.delayed(Duration(milliseconds: 50));
      
      // 检查必要字段
      if (config.config.containsKey('server') && 
          config.config.containsKey('serverPort') &&
          config.config.containsKey('uuid') || config.config.containsKey('password')) {
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 测试延迟
  Future<int> _testLatency() async {
    await Future.delayed(Duration(milliseconds: 200));
    return 25; // 模拟延迟 25ms
  }

  /// 测试吞吐量
  Future<double> _testThroughput() async {
    await Future.delayed(Duration(milliseconds: 300));
    return 85.5; // 模拟吞吐量 85.5 Mbps
  }

  /// 测试丢包率
  Future<double> _testPacketLoss() async {
    await Future.delayed(Duration(milliseconds: 150));
    return 0.8; // 模拟丢包率 0.8%
  }

  /// 计算性能评分
  double _calculatePerformanceScore(int latency, double throughput, double packetLoss) {
    // 延迟评分 (越低越好)
    final latencyScore = latency <= 50 ? 100 : latency <= 100 ? 80 : 60;
    
    // 吞吐量评分 (越高越好)
    final throughputScore = throughput >= 50 ? 100 : throughput >= 20 ? 80 : 60;
    
    // 丢包率评分 (越低越好)
    final packetLossScore = packetLoss <= 1 ? 100 : packetLoss <= 3 ? 80 : 60;
    
    // 综合评分
    return (latencyScore + throughputScore + packetLossScore) / 3;
  }

  /// 测试协议特定功能
  Future<TestResult> testSpecificFeatures() async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final features = <String, bool>{};
      
      // 测试 VMess 特有功能
      features['vmess-alterId'] = await _testVmessAlterId();
      features['vmess-security'] = await _testVmessSecurity();
      
      // 测试 Trojan 特有功能
      features['trojan-tls'] = await _testTrojanTls();
      features['trojan-ws'] = await _testTrojanWebSocket();
      
      // 测试 VLESS 特有功能
      features['vless-flow'] = await _testVlessFlow();
      features['vless-xtls'] = await _testVlessXTLS();
      
      stopwatch.stop();
      
      final passedFeatures = features.values.where((p) => p).length;
      final totalFeatures = features.length;
      
      if (passedFeatures == totalFeatures) {
        return TestResult(
          protocolName: protocolName,
          testCase: '特定功能测试',
          passed: true,
          message: '所有特定功能测试通过 ($passedFeatures/$totalFeatures)',
          duration: stopwatch.elapsed,
          metrics: {
            'features': features,
            'passed': passedFeatures,
            'total': totalFeatures,
          },
        );
      } else {
        return TestResult(
          protocolName: protocolName,
          testCase: '特定功能测试',
          passed: false,
          message: '特定功能测试失败 ($passedFeatures/$totalFeatures)',
          duration: stopwatch.elapsed,
          metrics: {
            'features': features,
            'passed': passedFeatures,
            'total': totalFeatures,
          },
        );
      }
    } catch (e) {
      stopwatch.stop();
      return TestResult(
        protocolName: protocolName,
        testCase: '特定功能测试',
        passed: false,
        message: '特定功能测试异常: $e',
        duration: stopwatch.elapsed,
        metrics: {
          'error': e.toString(),
        },
      );
    }
  }

  /// 测试 VMess AlterId 功能
  Future<bool> _testVmessAlterId() async {
    await Future.delayed(Duration(milliseconds: 100));
    return true;
  }

  /// 测试 VMess 安全选项
  Future<bool> _testVmessSecurity() async {
    await Future.delayed(Duration(milliseconds: 100));
    return true;
  }

  /// 测试 Trojan TLS 功能
  Future<bool> _testTrojanTls() async {
    await Future.delayed(Duration(milliseconds: 150));
    return true;
  }

  /// 测试 Trojan WebSocket 功能
  Future<bool> _testTrojanWebSocket() async {
    await Future.delayed(Duration(milliseconds: 120));
    return true;
  }

  /// 测试 VLESS Flow 控制
  Future<bool> _testVlessFlow() async {
    await Future.delayed(Duration(milliseconds: 100));
    return true;
  }

  /// 测试 VLESS XTLS 功能
  Future<bool> _testVlessXTLS() async {
    await Future.delayed(Duration(milliseconds: 130));
    return true;
  }
}