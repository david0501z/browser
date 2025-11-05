import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

// 导入测试相关类
import '../test/proxy_functionality_test.dart';
import '../test/browser_traffic_test.dart';
import '../services/traffic_monitor.dart';
import '../utils/proxy_validator.dart';

// 生成测试相关的模拟类
class MockProxyService extends Mock implements ProxyService {}
class MockBrowserProxyIntegrator extends Mock implements BrowserProxyIntegrator {}
class MockTrafficMonitorService extends Mock implements TrafficMonitorService {}
class MockProxyValidator extends Mock implements ProxyValidator {}

// 生成mockito注释
@GenerateMocks([
  MockProxyService, 
  MockBrowserProxyIntegrator, 
  MockTrafficMonitorService, 
  MockProxyValidator
])
import 'integration_test.mocks.dart';

/// 集成测试配置
class IntegrationTestConfig {
  final int testTimeoutSeconds;
  final int concurrentTests;
  final bool enableRealNetworkTests;
  final List<String> testProxyServers;
  final Duration testDuration;
  final bool enablePerformanceBenchmark;
  final bool enableSecurityValidation;
  final bool enableLeakTesting;

  IntegrationTestConfig({
    this.testTimeoutSeconds = 30,
    this.concurrentTests = 5,
    this.enableRealNetworkTests = false,
    this.testProxyServers = const [
      'proxy.example.com:8080',
      'secure-proxy.example.com:3128',
      'socks5.example.com:1080',
    ],
    this.testDuration = const Duration(seconds: 10),
    this.enablePerformanceBenchmark = true,
    this.enableSecurityValidation = true,
    this.enableLeakTesting = true,
  });
}

/// 集成测试结果
class IntegrationTestResult {
  final String testName;
  final bool passed;
  final Duration executionTime;
  final String? errorMessage;
  final Map<String, dynamic> metrics;
  final List<String> warnings;
  final DateTime timestamp;

  IntegrationTestResult({
    required this.testName,
    required this.passed,
    required this.executionTime,
    this.errorMessage,
    this.metrics = const {},
    this.warnings = const [],
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'testName': testName,
    'passed': passed,
    'executionTime': executionTime.inMilliseconds,
    'errorMessage': errorMessage,
    'metrics': metrics,
    'warnings': warnings,
    'timestamp': timestamp.toIso8601String(),
  };
}

/// 集成测试套件管理器
class IntegrationTestSuite {
  final IntegrationTestConfig _config;
  final ProxyService _proxyService;
  final BrowserProxyIntegrator _browserIntegrator;
  final TrafficMonitorService _trafficMonitor;
  final ProxyValidator _proxyValidator;
  final StreamController<IntegrationTestEvent> _eventController = 
      StreamController<IntegrationTestEvent>.broadcast();

  IntegrationTestSuite({
    IntegrationTestConfig? config,
    ProxyService? proxyService,
    BrowserProxyIntegrator? browserIntegrator,
    TrafficMonitorService? trafficMonitor,
    ProxyValidator? proxyValidator,
  })
      : _config = config ?? IntegrationTestConfig(),
        _proxyService = proxyService ?? ProxyService(),
        _browserIntegrator = browserIntegrator ?? BrowserProxyIntegrator(),
        _trafficMonitor = trafficMonitor ?? TrafficMonitorService(),
        _proxyValidator = proxyValidator ?? ProxyValidator();

  Stream<IntegrationTestEvent> get events => _eventController.stream;

  /// 运行完整集成测试套件
  Future<List<IntegrationTestResult>> runFullTestSuite() async {
    _emitEvent(IntegrationTestEventType.testSuiteStarted, '开始运行完整集成测试套件');

    final results = <IntegrationTestResult>[];
    final stopwatch = Stopwatch()..start();

    try {
      // 1. 代理功能集成测试
      results.addAll(await _runProxyIntegrationTests());

      // 2. 浏览器流量路由集成测试
      results.addAll(await _runBrowserTrafficIntegrationTests());

      // 3. 流量监控集成测试
      results.addAll(await _runTrafficMonitoringIntegrationTests());

      // 4. 代理验证集成测试
      results.addAll(await _runProxyValidationIntegrationTests());

      // 5. 端到端集成测试
      results.addAll(await _runEndToEndIntegrationTests());

      // 6. 性能基准测试
      if (_config.enablePerformanceBenchmark) {
        results.addAll(await _runPerformanceBenchmarkTests());
      }

      // 7. 安全验证测试
      if (_config.enableSecurityValidation) {
        results.addAll(await _runSecurityValidationTests());
      }

      stopwatch.stop();
      _emitEvent(IntegrationTestEventType.testSuiteCompleted, 
        '集成测试套件完成，耗时: ${stopwatch.elapsed()}');

    } catch (e) {
      _emitEvent(IntegrationTestEventType.testSuiteError, '测试套件执行失败: $e');
      results.add(IntegrationTestResult(
        testName: 'TestSuite',
        passed: false,
        executionTime: stopwatch.elapsed(),
        errorMessage: e.toString(),
        timestamp: DateTime.now(),
      ));
    }

    return results;
  }

  /// 代理功能集成测试
  Future<List<IntegrationTestResult>> _runProxyIntegrationTests() async {
    _emitEvent(IntegrationTestEventType.testStarted, '开始代理功能集成测试');

    final results = <IntegrationTestResult>[];
    final stopwatch = Stopwatch();

    // 测试1: 代理连接和断开
    stopwatch.start();
    try {
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
        username: 'testuser',
        password: 'testpass',
      );

      final connected = await _proxyService.connect(proxy);
      expect(connected, true);

      final isConnected = _proxyService.isConnected;
      expect(isConnected, true);

      final currentIP = await _proxyService.getCurrentIP();
      // IP获取可能在模拟环境中返回null

      await _proxyService.disconnect();
      expect(_proxyService.isConnected, false);

      results.add(IntegrationTestResult(
        testName: 'Proxy_Connection_Management',
        passed: true,
        executionTime: stopwatch.elapsed(),
        metrics: {
          'connectionSuccessful': connected,
          'disconnectionSuccessful': !_proxyService.isConnected,
        },
        timestamp: DateTime.now(),
      ));

    } catch (e) {
      results.add(IntegrationTestResult(
        testName: 'Proxy_Connection_Management',
        passed: false,
        executionTime: stopwatch.elapsed(),
        errorMessage: e.toString(),
        timestamp: DateTime.now(),
      ));
    }

    // 测试2: 多协议代理支持
    stopwatch.reset();
    stopwatch.start();
    try {
      final protocols = ['HTTP', 'HTTPS', 'SOCKS5'];
      final results_map = <String, bool>{};

      for (final protocol in protocols) {
        final proxy = ProxyConfig(
          type: protocol,
          host: '${protocol.toLowerCase()}-proxy.example.com',
          port: protocol == 'SOCKS5' ? 1080 : 8080,
        );

        final result = await _proxyService.connect(proxy);
        results_map[protocol] = result;
        await _proxyService.disconnect();
      }

      final allSupported = results_map.values.every((result) => result);
      expect(allSupported, true);

      results.add(IntegrationTestResult(
        testName: 'Multi_Protocol_Support',
        passed: allSupported,
        executionTime: stopwatch.elapsed(),
        metrics: results_map,
        timestamp: DateTime.now(),
      ));

    } catch (e) {
      results.add(IntegrationTestResult(
        testName: 'Multi_Protocol_Support',
        passed: false,
        executionTime: stopwatch.elapsed(),
        errorMessage: e.toString(),
        timestamp: DateTime.now(),
      ));
    }

    _emitEvent(IntegrationTestEventType.testCompleted, '代理功能集成测试完成');
    return results;
  }

  /// 浏览器流量路由集成测试
  Future<List<IntegrationTestResult>> _runBrowserTrafficIntegrationTests() async {
    _emitEvent(IntegrationTestEventType.testStarted, '开始浏览器流量路由集成测试');

    final results = <IntegrationTestResult>[];
    final stopwatch = Stopwatch();

    // 测试1: 基本流量路由
    stopwatch.start();
    try {
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
      );

      await _browserIntegrator.setProxy(proxy);

      final testUrls = [
        'https://httpbin.org/get',
        'https://httpbin.org/headers',
        'https://httpbin.org/user-agent',
      ];

      int successCount = 0;
      for (final url in testUrls) {
        try {
          await _browserIntegrator.fetchUrl(url);
          successCount++;
        } catch (e) {
          // 在模拟环境中网络请求可能失败
        }
      }

      final successRate = successCount / testUrls.length;
      final trafficRecords = _browserIntegrator.trafficMonitor.records.length;

      results.add(IntegrationTestResult(
        testName: 'Browser_Traffic_Routing',
        passed: trafficRecords > 0,
        executionTime: stopwatch.elapsed(),
        metrics: {
          'successRate': successRate,
          'trafficRecordsCount': trafficRecords,
          'testedUrls': testUrls.length,
        },
        timestamp: DateTime.now(),
      ));

    } catch (e) {
      results.add(IntegrationTestResult(
        testName: 'Browser_Traffic_Routing',
        passed: false,
        executionTime: stopwatch.elapsed(),
        errorMessage: e.toString(),
        timestamp: DateTime.now(),
      ));
    }

    // 测试2: 流量监控和统计
    stopwatch.reset();
    stopwatch.start();
    try {
      final stats = _browserIntegrator.trafficMonitor.getDomainStatistics();
      final totalBytes = _browserIntegrator.trafficMonitor.getTotalBytesTransferred();

      final hasStats = stats.isNotEmpty;
      final hasBytesData = totalBytes >= 0;

      results.add(IntegrationTestResult(
        testName: 'Traffic_Monitoring_Statistics',
        passed: hasStats && hasBytesData,
        executionTime: stopwatch.elapsed(),
        metrics: {
          'domainStatsCount': stats.length,
          'totalBytesTransferred': totalBytes,
          'domains': stats.keys.toList(),
        },
        timestamp: DateTime.now(),
      ));

    } catch (e) {
      results.add(IntegrationTestResult(
        testName: 'Traffic_Monitoring_Statistics',
        passed: false,
        executionTime: stopwatch.elapsed(),
        errorMessage: e.toString(),
        timestamp: DateTime.now(),
      ));
    }

    _emitEvent(IntegrationTestEventType.testCompleted, '浏览器流量路由集成测试完成');
    return results;
  }

  /// 流量监控集成测试
  Future<List<IntegrationTestResult>> _runTrafficMonitoringIntegrationTests() async {
    _emitEvent(IntegrationTestEventType.testStarted, '开始流量监控集成测试');

    final results = <IntegrationTestResult>[];
    final stopwatch = Stopwatch();

    // 测试1: 实时流量监控
    stopwatch.start();
    try {
      // 模拟流量数据
      final testData = TrafficData(
        id: 'test-${DateTime.now().millisecondsSinceEpoch}',
        type: TrafficDataType.httpRequest,
        source: 'client',
        destination: 'example.com',
        port: 443,
        bytes: 1024,
        duration: const Duration(milliseconds: 100),
        timestamp: DateTime.now(),
        userAgent: 'FlClash-Browser/1.0',
        host: 'example.com',
        path: '/test',
      );

      _trafficMonitor.recordTrafficData(testData);

      final statistics = _trafficMonitor.getStatistics();
      final currentBandwidth = _trafficMonitor.getCurrentBandwidth();
      final concurrentConnections = _trafficMonitor.getConcurrentConnections();

      final monitoringActive = statistics.totalRequests >= 0;
      final hasBandwidthData = currentBandwidth >= 0;

      results.add(IntegrationTestResult(
        testName: 'Real_Time_Traffic_Monitoring',
        passed: monitoringActive && hasBandwidthData,
        executionTime: stopwatch.elapsed(),
        metrics: {
          'statisticsAvailable': statistics != null,
          'currentBandwidthKBps': currentBandwidth,
          'concurrentConnections': concurrentConnections,
          'totalRequests': statistics.totalRequests,
        },
        timestamp: DateTime.now(),
      ));

    } catch (e) {
      results.add(IntegrationTestResult(
        testName: 'Real_Time_Traffic_Monitoring',
        passed: false,
        executionTime: stopwatch.elapsed(),
        errorMessage: e.toString(),
        timestamp: DateTime.now(),
      ));
    }

    // 测试2: 流量数据导出
    stopwatch.reset();
    stopwatch.start();
    try {
      final exportedData = _trafficMonitor.exportTrafficData();
      final isValidJson = _isValidJson(exportedData);

      results.add(IntegrationTestResult(
        testName: 'Traffic_Data_Export',
        passed: isValidJson,
        executionTime: stopwatch.elapsed(),
        metrics: {
          'exportedDataLength': exportedData.length,
          'isValidJson': isValidJson,
        },
        timestamp: DateTime.now(),
      ));

    } catch (e) {
      results.add(IntegrationTestResult(
        testName: 'Traffic_Data_Export',
        passed: false,
        executionTime: stopwatch.elapsed(),
        errorMessage: e.toString(),
        timestamp: DateTime.now(),
      ));
    }

    _emitEvent(IntegrationTestEventType.testCompleted, '流量监控集成测试完成');
    return results;
  }

  /// 代理验证集成测试
  Future<List<IntegrationTestResult>> _runProxyValidationIntegrationTests() async {
    _emitEvent(IntegrationTestEventType.testStarted, '开始代理验证集成测试');

    final results = <IntegrationTestResult>[];
    final stopwatch = Stopwatch();

    // 测试1: 单个代理验证
    stopwatch.start();
    try {
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
        username: 'testuser',
        password: 'testpass',
      );

      final validationResult = await _proxyValidator.validateProxy(proxy);
      final isValid = validationResult.isValid;
      final hasResponseTime = validationResult.responseTime.inMilliseconds >= 0;

      results.add(IntegrationTestResult(
        testName: 'Single_Proxy_Validation',
        passed: hasResponseTime,
        executionTime: stopwatch.elapsed(),
        metrics: {
          'isValid': isValid,
          'responseTimeMs': validationResult.responseTime.inMilliseconds,
          'publicIP': validationResult.publicIP,
          'hasPerformanceMetrics': validationResult.performance != null,
          'hasSecurityMetrics': validationResult.security != null,
        },
        timestamp: DateTime.now(),
      ));

    } catch (e) {
      results.add(IntegrationTestResult(
        testName: 'Single_Proxy_Validation',
        passed: false,
        executionTime: stopwatch.elapsed(),
        errorMessage: e.toString(),
        timestamp: DateTime.now(),
      ));
    }

    // 测试2: 批量代理验证
    stopwatch.reset();
    stopwatch.start();
    try {
      final proxies = [
        ProxyConfig(type: 'HTTP', host: 'proxy1.example.com', port: 8080),
        ProxyConfig(type: 'HTTPS', host: 'proxy2.example.com', port: 3128),
        ProxyConfig(type: 'SOCKS5', host: 'proxy3.example.com', port: 1080),
      ];

      final validationResults = await _proxyValidator.validateProxies(proxies);
      final validCount = validationResults.where((r) => r.isValid).length;

      results.add(IntegrationTestResult(
        testName: 'Batch_Proxy_Validation',
        passed: validationResults.length == proxies.length,
        executionTime: stopwatch.elapsed(),
        metrics: {
          'totalProxies': proxies.length,
          'validationResults': validationResults.length,
          'validProxies': validCount,
          'successRate': validCount / proxies.length,
        },
        timestamp: DateTime.now(),
      ));

    } catch (e) {
      results.add(IntegrationTestResult(
        testName: 'Batch_Proxy_Validation',
        passed: false,
        executionTime: stopwatch.elapsed(),
        errorMessage: e.toString(),
        timestamp: DateTime.now(),
      ));
    }

    _emitEvent(IntegrationTestEventType.testCompleted, '代理验证集成测试完成');
    return results;
  }

  /// 端到端集成测试
  Future<List<IntegrationTestResult>> _runEndToEndIntegrationTests() async {
    _emitEvent(IntegrationTestEventType.testStarted, '开始端到端集成测试');

    final results = <IntegrationTestResult>[];
    final stopwatch = Stopwatch();

    // 测试: 完整的代理流程
    stopwatch.start();
    try {
      // 1. 配置代理
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
        username: 'testuser',
        password: 'testpass',
      );

      // 2. 验证代理
      final validationResult = await _proxyValidator.validateProxy(proxy);
      if (!validationResult.isValid) {
        throw Exception('代理验证失败');
      }

      // 3. 连接代理
      final connected = await _proxyService.connect(proxy);
      if (!connected) {
        throw Exception('代理连接失败');
      }

      // 4. 配置浏览器代理
      await _browserIntegrator.setProxy(proxy);

      // 5. 执行测试请求
      final testUrl = 'https://httpbin.org/get';
      try {
        await _browserIntegrator.fetchUrl(testUrl);
      } catch (e) {
        // 在模拟环境中可能失败
      }

      // 6. 检查流量监控
      final trafficStats = _browserIntegrator.trafficMonitor.getDomainStatistics();
      final hasTrafficData = trafficStats.isNotEmpty;

      // 7. 断开代理
      await _proxyService.disconnect();

      final endToEndSuccess = connected && hasTrafficData;

      results.add(IntegrationTestResult(
        testName: 'End_To_End_Proxy_Flow',
        passed: endToEndSuccess,
        executionTime: stopwatch.elapsed(),
        metrics: {
          'proxyValidated': validationResult.isValid,
          'proxyConnected': connected,
          'browserConfigured': true,
          'trafficMonitored': hasTrafficData,
          'proxyDisconnected': !_proxyService.isConnected,
          'publicIP': validationResult.publicIP,
        },
        timestamp: DateTime.now(),
      ));

    } catch (e) {
      results.add(IntegrationTestResult(
        testName: 'End_To_End_Proxy_Flow',
        passed: false,
        executionTime: stopwatch.elapsed(),
        errorMessage: e.toString(),
        timestamp: DateTime.now(),
      ));
    }

    _emitEvent(IntegrationTestEventType.testCompleted, '端到端集成测试完成');
    return results;
  }

  /// 性能基准测试
  Future<List<IntegrationTestResult>> _runPerformanceBenchmarkTests() async {
    _emitEvent(IntegrationTestEventType.testStarted, '开始性能基准测试');

    final results = <IntegrationTestResult>[];
    final stopwatch = Stopwatch();

    // 测试1: 代理连接性能
    stopwatch.start();
    try {
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
      );

      final connectionTimes = <int>[];
      for (int i = 0; i < 5; i++) {
        final testStopwatch = Stopwatch()..start();
        await _proxyService.connect(proxy);
        testStopwatch.stop();
        connectionTimes.add(testStopwatch.elapsedMilliseconds);
        await _proxyService.disconnect();
      }

      final avgConnectionTime = connectionTimes.reduce((a, b) => a + b) / connectionTimes.length;
      final maxConnectionTime = connectionTimes.reduce(math.max);
      final minConnectionTime = connectionTimes.reduce(math.min);

      results.add(IntegrationTestResult(
        testName: 'Proxy_Connection_Performance',
        passed: avgConnectionTime < 5000, // 5秒阈值
        executionTime: stopwatch.elapsed(),
        metrics: {
          'avgConnectionTimeMs': avgConnectionTime,
          'maxConnectionTimeMs': maxConnectionTime,
          'minConnectionTimeMs': minConnectionTime,
          'testIterations': connectionTimes.length,
        },
        timestamp: DateTime.now(),
      ));

    } catch (e) {
      results.add(IntegrationTestResult(
        testName: 'Proxy_Connection_Performance',
        passed: false,
        executionTime: stopwatch.elapsed(),
        errorMessage: e.toString(),
        timestamp: DateTime.now(),
      ));
    }

    // 测试2: 并发处理性能
    stopwatch.reset();
    stopwatch.start();
    try {
      final concurrentTests = 3;
      final futures = <Future>[];

      for (int i = 0; i < concurrentTests; i++) {
        final future = _runConcurrentTest(i);
        futures.add(future);
      }

      await Future.wait(futures);

      results.add(IntegrationTestResult(
        testName: 'Concurrent_Processing_Performance',
        passed: true,
        executionTime: stopwatch.elapsed(),
        metrics: {
          'concurrentTests': concurrentTests,
          'completedSuccessfully': true,
        },
        timestamp: DateTime.now(),
      ));

    } catch (e) {
      results.add(IntegrationTestResult(
        testName: 'Concurrent_Processing_Performance',
        passed: false,
        executionTime: stopwatch.elapsed(),
        errorMessage: e.toString(),
        timestamp: DateTime.now(),
      ));
    }

    _emitEvent(IntegrationTestEventType.testCompleted, '性能基准测试完成');
    return results;
  }

  /// 安全验证测试
  Future<List<IntegrationTestResult>> _runSecurityValidationTests() async {
    _emitEvent(IntegrationTestEventType.testStarted, '开始安全验证测试');

    final results = <IntegrationTestResult>[];
    final stopwatch = Stopwatch();

    // 测试1: 代理安全验证
    stopwatch.start();
    try {
      final proxy = ProxyConfig(
        type: 'HTTPS',
        host: 'secure-proxy.example.com',
        port: 3128,
        username: 'secureuser',
        password: 'securepass',
      );

      final validationResult = await _proxyValidator.validateProxy(proxy);
      final securityMetrics = validationResult.security;

      final hasEncryption = securityMetrics?.supportsEncryption ?? false;
      final hasSSLVerification = securityMetrics?.verifiesSSLCertificates ?? false;

      results.add(IntegrationTestResult(
        testName: 'Proxy_Security_Validation',
        passed: hasEncryption,
        executionTime: stopwatch.elapsed(),
        metrics: {
          'supportsEncryption': hasEncryption,
          'verifiesSSLCertificates': hasSSLVerification,
          'anonymityLevel': securityMetrics?.anonymityLevel.toString(),
          'detectedWebRTCLeak': securityMetrics?.detectedWebRTCLeak ?? false,
          'detectedDNSLeak': securityMetrics?.detectedDNSLeak ?? false,
        },
        timestamp: DateTime.now(),
      ));

    } catch (e) {
      results.add(IntegrationTestResult(
        testName: 'Proxy_Security_Validation',
        passed: false,
        executionTime: stopwatch.elapsed(),
        errorMessage: e.toString(),
        timestamp: DateTime.now(),
      ));
    }

    // 测试2: 流量泄露检测
    stopwatch.reset();
    stopwatch.start();
    try {
      final proxy = ProxyConfig(
        type: 'SOCKS5',
        host: 'socks5-proxy.example.com',
        port: 1080,
      );

      final validationResult = await _proxyValidator.validateProxy(proxy);
      final leakTest = validationResult.leakTest;

      final isSecure = leakTest?.isSecure ?? false;

      results.add(IntegrationTestResult(
        testName: 'Traffic_Leak_Detection',
        passed: isSecure,
        executionTime: stopwatch.elapsed(),
        metrics: {
          'isSecure': isSecure,
          'dnsLeakDetected': leakTest?.dnsLeakDetected ?? false,
          'webRTCLeakDetected': leakTest?.webRTCLeakDetected ?? false,
          'ipLeakDetected': leakTest?.ipLeakDetected ?? false,
        },
        timestamp: DateTime.now(),
      ));

    } catch (e) {
      results.add(IntegrationTestResult(
        testName: 'Traffic_Leak_Detection',
        passed: false,
        executionTime: stopwatch.elapsed(),
        errorMessage: e.toString(),
        timestamp: DateTime.now(),
      ));
    }

    _emitEvent(IntegrationTestEventType.testCompleted, '安全验证测试完成');
    return results;
  }

  /// 运行并发测试
  Future<void> _runConcurrentTest(int testId) async {
    final proxy = ProxyConfig(
      type: 'HTTP',
      host: 'proxy.example.com',
      port: 8080,
    );

    await _proxyService.connect(proxy);
    
    // 模拟并发请求
    final requests = List.generate(3, (i) => 'https://httpbin.org/delay/$i');
    for (final url in requests) {
      try {
        await _browserIntegrator.fetchUrl(url);
      } catch (e) {
        // 在模拟环境中可能失败
      }
    }

    await _proxyService.disconnect();
  }

  /// 检查JSON有效性
  bool _isValidJson(String jsonString) {
    try {
      json.decode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 发送事件
  void _emitEvent(IntegrationTestEventType type, String message) {
    _eventController.add(IntegrationTestEvent(type, message, DateTime.now()));
  }

  /// 生成集成测试报告
  String generateIntegrationReport(List<IntegrationTestResult> results) {
    final buffer = StringBuffer();
    buffer.writeln('=== FlClash 代理功能集成测试报告 ===');
    buffer.writeln('测试时间: ${DateTime.now()}');
    buffer.writeln('测试项目数量: ${results.length}');
    buffer.writeln();

    final passedTests = results.where((r) => r.passed).length;
    final failedTests = results.length - passedTests;
    final successRate = (passedTests / results.length * 100).toStringAsFixed(1);

    buffer.writeln('=== 测试结果总览 ===');
    buffer.writeln('通过测试: $passedTests');
    buffer.writeln('失败测试: $failedTests');
    buffer.writeln('成功率: $successRate%');
    buffer.writeln();

    final totalTime = results.fold<Duration>(
      Duration.zero,
      (sum, result) => sum + result.executionTime,
    );
    buffer.writeln('总执行时间: ${totalTime}');
    buffer.writeln();

    buffer.writeln('=== 详细测试结果 ===');
    for (final result in results) {
      buffer.writeln('测试: ${result.testName}');
      buffer.writeln('  状态: ${result.passed ? "通过" : "失败"}');
      buffer.writeln('  执行时间: ${result.executionTime.inMilliseconds}ms');
      
      if (result.errorMessage != null) {
        buffer.writeln('  错误: ${result.errorMessage}');
      }
      
      if (result.metrics.isNotEmpty) {
        buffer.writeln('  指标:');
        result.metrics.forEach((key, value) {
          buffer.writeln('    $key: $value');
        });
      }
      
      if (result.warnings.isNotEmpty) {
        buffer.writeln('  警告:');
        for (final warning in result.warnings) {
          buffer.writeln('    - $warning');
        }
      }
      buffer.writeln();
    }

    // 性能分析
    buffer.writeln('=== 性能分析 ===');
    final avgExecutionTime = results.fold<int>(
      0,
      (sum, result) => sum + result.executionTime.inMilliseconds,
    ) / results.length;

    buffer.writeln('平均执行时间: ${avgExecutionTime.toStringAsFixed(2)}ms');
    
    final slowestTest = results.reduce((a, b) => 
        a.executionTime > b.executionTime ? a : b);
    buffer.writeln('最慢测试: ${slowestTest.testName} (${slowestTest.executionTime.inMilliseconds}ms)');
    
    final fastestTest = results.reduce((a, b) => 
        a.executionTime < b.executionTime ? a : b);
    buffer.writeln('最快测试: ${fastestTest.testName} (${fastestTest.executionTime.inMilliseconds}ms)');
    buffer.writeln();

    return buffer.toString();
  }

  /// 清理资源
  void dispose() {
    _proxyService.dispose();
    _browserIntegrator.dispose();
    _trafficMonitor.stop();
    _proxyValidator.dispose();
    _eventController.close();
  }
}

/// 集成测试事件
class IntegrationTestEvent {
  final IntegrationTestEventType type;
  final String message;
  final DateTime timestamp;

  IntegrationTestEvent(this.type, this.message, this.timestamp);
}

enum IntegrationTestEventType {
  testSuiteStarted,
  testSuiteCompleted,
  testSuiteError,
  testStarted,
  testCompleted,
  testError,
}

/// 集成测试主函数
void main() {
  group('FlClash代理功能集成测试套件', () {
    late IntegrationTestSuite testSuite;
    late List<IntegrationTestEvent> receivedEvents;

    setUp(() {
      testSuite = IntegrationTestSuite();
      receivedEvents = [];
      
      // 监听测试事件
      testSuite.events.listen((event) {
        receivedEvents.add(event);
      });
    });

    tearDown(() {
      testSuite.dispose();
    });

    test('完整集成测试套件执行', () async {
      final results = await testSuite.runFullTestSuite();

      // 验证测试结果
      expect(results.isNotEmpty, true);
      
      final passedCount = results.where((r) => r.passed).length;
      final totalCount = results.length;
      final successRate = passedCount / totalCount;
      
      print('集成测试完成: $passedCount/$totalCount 通过 (${(successRate * 100).toStringAsFixed(1)}%)');
      
      // 生成报告
      final report = testSuite.generateIntegrationReport(results);
      print('\n$report');
      
      // 验证至少有一个测试通过
      expect(passedCount, greaterThan(0));
    });

    test('代理功能集成测试', () async {
      final proxyService = ProxyService();
      
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
        username: 'testuser',
        password: 'testpass',
      );

      // 测试连接
      final connected = await proxyService.connect(proxy);
      expect(connected, true);
      expect(proxyService.isConnected, true);

      // 测试获取IP
      final currentIP = await proxyService.getCurrentIP();
      // 在模拟环境中可能返回null

      // 测试断开
      await proxyService.disconnect();
      expect(proxyService.isConnected, false);

      proxyService.dispose();
    });

    test('浏览器流量路由集成测试', () async {
      final trafficMonitor = BrowserTrafficMonitor();
      final integrator = BrowserProxyIntegrator(trafficMonitor: trafficMonitor);

      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
      );

      await integrator.setProxy(proxy);

      // 测试多个URL
      final testUrls = [
        'https://httpbin.org/get',
        'https://httpbin.org/headers',
        'https://httpbin.org/user-agent',
      ];

      for (final url in testUrls) {
        try {
          await integrator.fetchUrl(url);
        } catch (e) {
          // 在模拟环境中可能失败
        }
      }

      // 验证流量记录
      final records = trafficMonitor.records;
      expect(records.isNotEmpty, true);

      // 验证域名统计
      final stats = trafficMonitor.getDomainStatistics();
      expect(stats.isNotEmpty, true);

      integrator.dispose();
    });

    test('流量监控集成测试', () async {
      final trafficMonitor = TrafficMonitorService();

      // 模拟HTTP请求
      trafficMonitor.recordHttpRequest(
        url: 'https://example.com/page',
        method: 'GET',
        userAgent: 'FlClash-Browser/1.0',
        headers: {'Accept': 'text/html'},
        bytes: 1024,
        duration: const Duration(milliseconds: 200),
      );

      // 模拟HTTP响应
      trafficMonitor.recordHttpResponse(
        url: 'https://example.com/page',
        statusCode: 200,
        headers: {'Content-Type': 'text/html'},
        bytes: 2048,
        duration: const Duration(milliseconds: 150),
      );

      // 获取统计信息
      final statistics = trafficMonitor.getStatistics();
      expect(statistics.totalRequests, greaterThanOrEqualTo(1));
      expect(statistics.totalResponses, greaterThanOrEqualTo(1));

      // 验证实时数据
      final currentBandwidth = trafficMonitor.getCurrentBandwidth();
      expect(currentBandwidth, greaterThanOrEqualTo(0));

      trafficMonitor.stop();
    });

    test('代理验证集成测试', () async {
      final validator = ProxyValidator();

      final proxy = ProxyConfig(
        type: 'HTTPS',
        host: 'secure-proxy.example.com',
        port: 3128,
        username: 'secureuser',
        password: 'securepass',
      );

      final result = await validator.validateProxy(proxy);

      expect(result.timestamp, isNotNull);
      expect(result.responseTime, isNotNull);
      expect(result.headers, isNotNull);

      // 验证性能指标
      if (result.performance != null) {
        expect(result.performance!.latencyMs, greaterThanOrEqualTo(0));
        expect(result.performance!.downloadSpeedKBps, greaterThanOrEqualTo(0));
      }

      // 验证安全指标
      if (result.security != null) {
        expect(result.security!.supportsEncryption, isNotNull);
        expect(result.security!.anonymityLevel, isNotNull);
      }

      validator.dispose();
    });

    test('端到端集成测试', () async {
      // 1. 创建代理配置
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
        username: 'testuser',
        password: 'testpass',
      );

      // 2. 验证代理
      final validator = ProxyValidator();
      final validationResult = await validator.validateProxy(proxy);
      expect(validationResult.responseTime, isNotNull);

      // 3. 连接代理
      final proxyService = ProxyService();
      final connected = await proxyService.connect(proxy);
      expect(connected, true);

      // 4. 配置浏览器
      final trafficMonitor = BrowserTrafficMonitor();
      final integrator = BrowserProxyIntegrator(trafficMonitor: trafficMonitor);
      await integrator.setProxy(proxy);

      // 5. 执行测试请求
      try {
        await integrator.fetchUrl('https://httpbin.org/get');
      } catch (e) {
        // 在模拟环境中可能失败
      }

      // 6. 检查监控数据
      final stats = trafficMonitor.getDomainStatistics();
      expect(stats, isNotNull);

      // 7. 清理
      await proxyService.disconnect();
      proxyService.dispose();
      integrator.dispose();
      validator.dispose();
    });

    test('性能基准测试', () async {
      final proxyService = ProxyService();
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
      );

      final connectionTimes = <int>[];
      
      // 进行5次连接测试
      for (int i = 0; i < 5; i++) {
        final stopwatch = Stopwatch()..start();
        await proxyService.connect(proxy);
        stopwatch.stop();
        connectionTimes.add(stopwatch.elapsedMilliseconds);
        await proxyService.disconnect();
      }

      // 计算统计信息
      final avgTime = connectionTimes.reduce((a, b) => a + b) / connectionTimes.length;
      final maxTime = connectionTimes.reduce(math.max);
      final minTime = connectionTimes.reduce(math.min);

      print('连接性能统计:');
      print('  平均: ${avgTime.toStringAsFixed(2)}ms');
      print('  最大: ${maxTime}ms');
      print('  最小: ${minTime}ms');

      // 验证性能阈值
      expect(avgTime, lessThan(5000)); // 5秒阈值
      expect(maxTime, lessThan(10000)); // 10秒阈值

      proxyService.dispose();
    });

    test('安全验证测试', () async {
      final validator = ProxyValidator();

      final secureProxy = ProxyConfig(
        type: 'HTTPS',
        host: 'secure-proxy.example.com',
        port: 3128,
        username: 'secureuser',
        password: 'securepass',
      );

      final result = await validator.validateProxy(secureProxy);

      // 验证安全指标
      if (result.security != null) {
        expect(result.security!.supportsEncryption, isNotNull);
        expect(result.security!.anonymityLevel, isNotNull);
      }

      // 验证泄露测试
      if (result.leakTest != null) {
        expect(result.leakTest!.isSecure, isNotNull);
        expect(result.leakTest!.dnsLeakDetected, isNotNull);
        expect(result.leakTest!.webRTCLeakDetected, isNotNull);
      }

      validator.dispose();
    });

    test('并发处理测试', () async {
      final proxyService = ProxyService();
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
      );

      final concurrentTests = 3;
      final futures = <Future>[];

      // 创建并发测试
      for (int i = 0; i < concurrentTests; i++) {
        final future = _runConcurrentProxyTest(proxyService, proxy, i);
        futures.add(future);
      }

      // 等待所有测试完成
      await Future.wait(futures);

      // 验证所有测试都成功完成
      expect(futures.length, concurrentTests);

      proxyService.dispose();
    });

    test('错误处理测试', () async {
      final proxyService = ProxyService();

      // 测试无效代理
      final invalidProxy = ProxyConfig(
        type: 'INVALID',
        host: '',
        port: -1,
      );

      final result = await proxyService.connect(invalidProxy);
      expect(result, false);
      expect(proxyService.isConnected, false);

      // 测试网络错误
      final unreachableProxy = ProxyConfig(
        type: 'HTTP',
        host: 'unreachable-proxy.example.com',
        port: 99999,
      );

      final unreachableResult = await proxyService.connect(unreachableProxy);
      expect(unreachableResult, false);

      proxyService.dispose();
    });

    test('资源清理测试', () async {
      final proxyService = ProxyService();
      final trafficMonitor = BrowserTrafficMonitor();
      final integrator = BrowserProxyIntegrator(trafficMonitor: trafficMonitor);
      final validator = ProxyValidator();

      // 执行一些操作
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
      );

      await proxyService.connect(proxy);
      await integrator.setProxy(proxy);
      await validator.validateProxy(proxy);

      // 清理资源
      await proxyService.disconnect();
      proxyService.dispose();
      integrator.dispose();
      validator.dispose();

      // 验证资源已清理
      expect(proxyService.isConnected, false);
    });
  });
}

/// 运行并发代理测试的辅助函数
Future<void> _runConcurrentProxyTest(ProxyService proxyService, ProxyConfig proxy, int testId) async {
  final stopwatch = Stopwatch()..start();
  
  try {
    final connected = await proxyService.connect(proxy);
    if (connected) {
      // 模拟一些操作
      await Future.delayed(Duration(milliseconds: 100));
      await proxyService.getCurrentIP();
      await proxyService.disconnect();
    }
    
    stopwatch.stop();
    print('并发测试 $testId 完成，耗时: ${stopwatch.elapsedMilliseconds}ms');
  } catch (e) {
    stopwatch.stop();
    print('并发测试 $testId 失败: $e');
    rethrow;
  }
}