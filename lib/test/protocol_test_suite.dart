/// 代理协议测试套件主入口
/// 提供统一的测试框架和测试用例管理
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'v2ray_test.dart';
import 'vless_test.dart';
import 'hysteria_test.dart';
import 'trojan_test.dart';
import 'ss_ssr_test.dart';
import 'protocol_validator.dart';

@GenerateMocks([TestNetworkEnvironment])
import 'protocol_test_suite.mocks.dart';

/// 测试网络环境模拟器
class TestNetworkEnvironment {
  final String name;
  final String latency;
  final String packetLoss;
  final int bandwidth;
  final bool isStable;
  final Map<String, dynamic> networkConditions;

  TestNetworkEnvironment({
    required this.name,
    required this.latency,
    required this.packetLoss,
    required this.bandwidth,
    required this.isStable,
    required this.networkConditions,
  });
}

/// 测试结果类
class TestResult {
  final String protocolName;
  final String testCase;
  final bool passed;
  final String message;
  final Duration duration;
  final Map<String, dynamic> metrics;

  TestResult({
    required this.protocolName,
    required this.testCase,
    required this.passed,
    required this.message,
    required this.duration,
    required this.metrics,
  });

  @override
  String toString() {
    return '${passed ? '✅' : '❌'} $protocolName - $testCase: $message';
  }
}

/// 协议测试套件
class ProtocolTestSuite {
  static final ProtocolTestSuite _instance = ProtocolTestSuite._internal();
  factory ProtocolTestSuite() => _instance;
  ProtocolTestSuite._internal();

  final List<TestNetworkEnvironment> networkEnvironments = [;
    TestNetworkEnvironment(
      name: '高速网络',
      latency: '10ms',
      packetLoss: '0.1%',
      bandwidth: 100000, // 100Mbps
      isStable: true,
      networkConditions: {
        'rtt': 10,
        'jitter': 2,
        'throughput': 100000000,
        'stability': 0.99,
      },
    ),
    TestNetworkEnvironment(
      name: '中等网络',
      latency: '50ms',
      packetLoss: '1%',
      bandwidth: 10000, // 10Mbps
      isStable: true,
      networkConditions: {
        'rtt': 50,
        'jitter': 10,
        'throughput': 10000000,
        'stability': 0.95,
      },
    ),
    TestNetworkEnvironment(
      name: '弱网络',
      latency: '200ms',
      packetLoss: '5%',
      bandwidth: 1000, // 1Mbps
      isStable: false,
      networkConditions: {
        'rtt': 200,
        'jitter': 50,
        'throughput': 1000000,
        'stability': 0.80,
      },
    ),
    TestNetworkEnvironment(
      name: '移动网络',
      latency: '80ms',
      packetLoss: '2%',
      bandwidth: 5000, // 5Mbps
      isStable: false,
      networkConditions: {
        'rtt': 80,
        'jitter': 20,
        'throughput': 5000000,
        'stability': 0.90,
      },
    ),
  ];

  final List<TestResult> _results = [];

  /// 运行所有协议测试
  Future<List<TestResult>> runAllTests() async {
    _results.clear();

    print('🧪 开始运行代理协议兼容性测试套件...');
    print('=' * 60);

    // 运行各个协议的测试
    await _runV2RayTests();
    await _runVLESSTests();
    await _runHysteriaTests();
    await _runTrojanTests();
    await _runShadowsocksTests();

    print('=' * 60);
    print('📊 测试完成！总测试数: ${_results.length}');
    print('✅ 通过: ${_results.where((r) => r.passed).length}');
    print('❌ 失败: ${_results.where((r) => !r.passed).length}');

    return _results;
  }

  /// 添加测试结果
  void addResult(TestResult result) {
    _results.add(result);
    print(result);
  }

  /// 运行V2Ray测试
  Future<void> _runV2RayTests() async {
    print('\n🔹 V2Ray 协议测试');
    final v2rayTests = V2RayProtocolTests();

    for (final env in networkEnvironments) {
      final result = await v2rayTests.testConnection(env);
      addResult(result);
    }

    final configResult = await v2rayTests.testConfigValidation();
    addResult(configResult);

    final performanceResult = await v2rayTests.testPerformance();
    addResult(performanceResult);
  }

  /// 运行VLESS测试
  Future<void> _runVLESSTests() async {
    print('\n🔹 VLESS 协议测试');
    final vlessTests = VLESSProtocolTests();

    for (final env in networkEnvironments) {
      final result = await vlessTests.testConnection(env);
      addResult(result);
    }

    final configResult = await vlessTests.testConfigValidation();
    addResult(configResult);

    final performanceResult = await vlessTests.testPerformance();
    addResult(performanceResult);
  }

  /// 运行Hysteria测试
  Future<void> _runHysteriaTests() async {
    print('\n🔹 Hysteria 协议测试');
    final hysteriaTests = HysteriaProtocolTests();

    for (final env in networkEnvironments) {
      final result = await hysteriaTests.testConnection(env);
      addResult(result);
    }

    final configResult = await hysteriaTests.testConfigValidation();
    addResult(configResult);

    final performanceResult = await hysteriaTests.testPerformance();
    addResult(performanceResult);
  }

  /// 运行Trojan测试
  Future<void> _runTrojanTests() async {
    print('\n🔹 Trojan 协议测试');
    final trojanTests = TrojanProtocolTests();

    for (final env in networkEnvironments) {
      final result = await trojanTests.testConnection(env);
      addResult(result);
    }

    final configResult = await trojanTests.testConfigValidation();
    addResult(configResult);

    final performanceResult = await trojanTests.testPerformance();
    addResult(performanceResult);
  }

  /// 运行Shadowsocks/SSR测试
  Future<void> _runShadowsocksTests() async {
    print('\n🔹 Shadowsocks/SSR 协议测试');
    final ssTests = SS_SSRProtocolTests();

    for (final env in networkEnvironments) {
      final result = await ssTests.testConnection(env);
      addResult(result);
    }

    final configResult = await ssTests.testConfigValidation();
    addResult(configResult);

    final performanceResult = await ssTests.testPerformance();
    addResult(performanceResult);
  }

  /// 获取测试报告
  String generateReport() {
    final buffer = StringBuffer();
    buffer.writeln('📋 代理协议测试报告');
    buffer.writeln('=' * 50);
    buffer.writeln('测试时间: ${DateTime.now().toIso8601String()}');
    buffer.writeln('测试环境数量: ${networkEnvironments.length}');
    buffer.writeln('');

    // 按协议分组
    final protocols = <String, List<TestResult>>{};
    for (final result in _results) {
      protocols.putIfAbsent(result.protocolName, () => []);
      protocols[result.protocolName]!.add(result);
    }

    for (final entry in protocols.entries) {
      buffer.writeln('🔸 ${entry.key} 协议');
      final passed = entry.value.where((r) => r.passed).length;
      final total = entry.value.length;
      buffer.writeln('  通过率: $passed/$total (${(passed/total*100).toStringAsFixed(1)}%)');
      buffer.writeln('');

      for (final result in entry.value) {
        buffer.writeln('  ${result.toString()}');
      }
      buffer.writeln('');
    }

    final overallPassed = _results.where((r) => r.passed).length;
    final overallTotal = _results.length;
    buffer.writeln('📊 总体统计');
    buffer.writeln('总测试数: $overallTotal');
    buffer.writeln('通过数: $overallPassed');
    buffer.writeln('失败数: ${overallTotal - overallPassed}');
    buffer.writeln('总体通过率: ${(overallPassed/overallTotal*100).toStringAsFixed(1)}%');

    return buffer.toString();
  }
}

void main() async {
  // 运行协议测试套件
  final suite = ProtocolTestSuite();
  final results = await suite.runAllTests();

  // 生成测试报告
  final report = suite.generateReport();
  print('\n$report');
}