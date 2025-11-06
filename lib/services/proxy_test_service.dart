import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/proxy_types.dart';

/// 代理测试结果
class ProxyTestResult {
  final String testId;
  final ProxyTestType testType;
  final bool success;
  final Duration duration;
  final String? message;
  final Map<String, dynamic>? details;
  final DateTime timestamp;

  const ProxyTestResult({
    required this.testId,
    required this.testType,
    required this.success,
    required this.duration,
    this.message,
    this.details,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'testId': testId,
    'testType': testType.name,
    'success': success,
    'duration': duration.inMilliseconds,
    'message': message,
    'details': details,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ProxyTestResult.fromJson(Map<String, dynamic> json) => ProxyTestResult(
    testId: json['testId'],
    testType: ProxyTestType.values.firstWhere(
      (e) => e.name == json['testType'],
    ),
    success: json['success'],
    duration: Duration(milliseconds: json['duration']),
    message: json['message'],
    details: json['details'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

/// 代理测试类型
enum ProxyTestType {
  connectivity,     // 连通性测试
  speed,           // 速度测试
  dns,             // DNS测试
  leak,            // 泄漏测试
  latency,         // 延迟测试
  bandwidth        // 带宽测试
}

/// 代理测试服务
class ProxyTestService {
  static final ProxyTestService _instance = ProxyTestService._internal();
  factory ProxyTestService() => _instance;
  ProxyTestService._internal();

  // 测试结果流控制器
  final StreamController<ProxyTestResult> _testResultController = 
    StreamController<ProxyTestResult>.broadcast();
  
  Stream<ProxyTestResult> get testResults => _testResultController.stream;

  // 测试配置
  static const Duration _defaultTimeout = Duration(seconds: 30);
  static const List<String> _speedTestUrls = [
    'https://www.google.com/favicon.ico',
    'https://httpbin.org/delay/1',
    'https://httpbin.org/bytes/102400',
  ];
  
  static const List<String> _dnsTestServers = [
    '8.8.8.8',
    '8.8.4.4',
    '1.1.1.1',
    '1.0.0.1',
  ];

  // 测试代理配置
  ProxyConfig? _currentProxy;
  HttpClient? _httpClient;

  /// 设置当前代理配置
  void setProxyConfig(ProxyConfig proxy) {
    _currentProxy = proxy;
    _createHttpClient();
  }

  /// 创建带代理的HTTP客户端
  void _createHttpClient() {
    _httpClient?.close();
    _httpClient = HttpClient();
    
    if (_currentProxy != null) {
      final proxy = _currentProxy!;
      switch (proxy.type) {
        case ProxyType.http:
          _httpClient!.findProxy = (uri) => 
            'PROXY ${proxy.host}:${proxy.port}';
          break;
        case ProxyType.socks:
          _httpClient!.findProxy = (uri) => 
            'PROXY socks5://${proxy.host}:${proxy.port}';
          break;
        default:
          _httpClient!.findProxy = (uri) => null;
      }
    } else {
      _httpClient!.findProxy = (uri) => null;
    }
  }

  /// 执行完整测试套件
  Future<List<ProxyTestResult>> runFullTestSuite({
    ProxyConfig? proxy,
    List<ProxyTestType> testTypes = const [
      ProxyTestType.connectivity,
      ProxyTestType.latency,
      ProxyTestType.speed,
      ProxyTestType.dns,
    ],
  }) async {
    setProxyConfig(proxy ?? _currentProxy!);
    final results = <ProxyTestResult>[];
    
    for (final testType in testTypes) {
      try {
        final result = await runSingleTest(testType);
        results.add(result);
      } catch (e) {
        results.add(ProxyTestResult(
          testId: 'test_${testType.name}_${DateTime.now().millisecondsSinceEpoch}',
          testType: testType,
          success: false,
          duration: Duration.zero,
          message: '测试失败: $e',
          timestamp: DateTime.now(),
        ));
      }
    }
    
    return results;
  }

  /// 执行单个测试
  Future<ProxyTestResult> runSingleTest(ProxyTestType testType) async {
    final stopwatch = Stopwatch()..start();
    final testId = 'test_${testType.name}_${DateTime.now().millisecondsSinceEpoch}';

    try {
      dynamic result;
      switch (testType) {
        case ProxyTestType.connectivity:
          result = await _testConnectivity();
          break;
        case ProxyTestType.speed:
          result = await _testSpeed();
          break;
        case ProxyTestType.dns:
          result = await _testDNS();
          break;
        case ProxyTestType.leak:
          result = await _testLeak();
          break;
        case ProxyTestType.latency:
          result = await _testLatency();
          break;
        case ProxyTestType.bandwidth:
          result = await _testBandwidth();
          break;
      }

      final duration = stopwatch.stop();
      final testResult = ProxyTestResult(
        testId: testId,
        testType: testType,
        success: true,
        duration: duration,
        message: '测试成功',
        details: result is Map ? result : {'result': result},
        timestamp: DateTime.now(),
      );

      _testResultController.add(testResult);
      return testResult;

    } catch (e) {
      final duration = stopwatch.stop();
      final testResult = ProxyTestResult(
        testId: testId,
        testType: testType,
        success: false,
        duration: duration,
        message: '测试失败: $e',
        timestamp: DateTime.now(),
      );

      _testResultController.add(testResult);
      return testResult;
    }
  }

  /// 测试连通性
  Future<Map<String, dynamic>> _testConnectivity() async {
    final targetUrls = [
      'https://www.google.com',
      'https://httpbin.org/get',
      'https://httpbin.org/status/200',
    ];

    final results = <String, dynamic>{};
    
    for (final url in targetUrls) {
      try {
        final response = await _makeRequest(url);
        results[url] = {
          'status': response.statusCode,
          'success': response.statusCode == 200,
          'responseTime': DateTime.now(),
        };
      } catch (e) {
        results[url] = {
          'error': e.toString(),
          'success': false,
        };
      }
    }

    final successCount = results.values
      .where((r) => r['success'] == true)
      .length;
    
    return {
      'totalTests': targetUrls.length,
      'successfulTests': successCount,
      'successRate': (successCount / targetUrls.length * 100).toStringAsFixed(1),
      'results': results,
      'overall': successCount == targetUrls.length,
    };
  }

  /// 测试速度
  Future<Map<String, dynamic>> _testSpeed() async {
    final results = <String, dynamic>{};
    final speeds = <double>[];

    for (final url in _speedTestUrls) {
      try {
        final stopwatch = Stopwatch()..start();
        final response = await _makeRequest(url);
        stopwatch.stop();

        final bytes = response.bodyBytes.length;
        final time = stopwatch.elapsedMilliseconds / 1000; // 秒
        final speedBps = bytes / time; // 字节/秒
        final speedMbps = (speedBps * 8) / (1024 * 1024); // Mbps

        speeds.add(speedMbps);
        results[url] = {
          'bytes': bytes,
          'time': time,
          'speedBps': speedBps,
          'speedMbps': speedMbps.toStringAsFixed(2),
          'success': true,
        };
      } catch (e) {
        results[url] = {
          'error': e.toString(),
          'success': false,
        };
      }
    }

    if (speeds.isNotEmpty) {
      final avgSpeed = speeds.reduce((a, b) => a + b) / speeds.length;
      final maxSpeed = speeds.reduce((a, b) => a > b ? a : b);
      final minSpeed = speeds.reduce((a, b) => a < b ? a : b);

      return {
        'averageSpeed': '${avgSpeed.toStringAsFixed(2)} Mbps',
        'maxSpeed': '${maxSpeed.toStringAsFixed(2)} Mbps',
        'minSpeed': '${minSpeed.toStringAsFixed(2)} Mbps',
        'testResults': results,
        'overallSuccess': speeds.length == _speedTestUrls.length,
      };
    }

    return {
      'error': '速度测试失败',
      'testResults': results,
      'overallSuccess': false,
    };
  }

  /// 测试DNS
  Future<Map<String, dynamic>> _testDNS() async {
    final results = <String, dynamic>{};
    final testDomains = [
      'www.google.com',
      'github.com',
      'stackoverflow.com',
      'httpbin.org',
    ];

    for (final domain in testDomains) {
      try {
        final ip = await InternetAddress.lookup(domain);
        results[domain] = {
          'ip': ip.first.address,
          'success': true,
        };
      } catch (e) {
        results[domain] = {
          'error': e.toString(),
          'success': false,
        };
      }
    }

    final successCount = results.values
      .where((r) => r['success'] == true)
      .length;

    return {
      'totalDomains': testDomains.length,
      'successfulResolutions': successCount,
      'successRate': '${(successCount / testDomains.length * 100).toStringAsFixed(1)}%',
      'results': results,
      'overall': successCount == testDomains.length,
    };
  }

  /// 测试泄漏
  Future<Map<String, dynamic>> _testLeak() async {
    // 这里可以实现DNS泄漏和IP泄漏检测
    // 通过请求特定的检测服务来判断是否有泄漏
    
    final leakTestUrls = [
      'https://httpbin.org/ip',  // 检测IP
      'https://httpbin.org/dns', // 检测DNS
    ];

    final results = <String, dynamic>{};
    
    for (final url in leakTestUrls) {
      try {
        final response = await _makeRequest(url);
        final data = jsonDecode(response.body);
        
        results[url] = {
          'data': data,
          'success': true,
        };
      } catch (e) {
        results[url] = {
          'error': e.toString(),
          'success': false,
        };
      }
    }

    return {
      'leakTestResults': results,
      'overallSuccess': results.values.every((r) => r['success'] == true),
    };
  }

  /// 测试延迟
  Future<Map<String, dynamic>> _testLatency() async {
    final targetUrls = [
      'https://www.google.com',
      'https://github.com',
      'https://stackoverflow.com',
    ];

    final latencies = <String, double>{};
    
    for (final url in targetUrls) {
      try {
        final stopwatch = Stopwatch()..start();
        await _makeRequest(url);
        stopwatch.stop();
        
        latencies[url] = stopwatch.elapsedMilliseconds.toDouble();
      } catch (e) {
        latencies[url] = -1; // 错误标识
      }
    }

    final validLatencies = latencies.values.where((l) => l >= 0).toList();
    
    if (validLatencies.isNotEmpty) {
      final avgLatency = validLatencies.reduce((a, b) => a + b) / validLatencies.length;
      final minLatency = validLatencies.reduce((a, b) => a < b ? a : b);
      final maxLatency = validLatencies.reduce((a, b) => a > b ? a : b);

      return {
        'averageLatency': '${avgLatency.toStringAsFixed(0)}ms',
        'minLatency': '${minLatency.toStringAsFixed(0)}ms',
        'maxLatency': '${maxLatency.toStringAsFixed(0)}ms',
        'detailedLatencies': latencies,
        'overallSuccess': validLatencies.length == targetUrls.length,
      };
    }

    return {
      'error': '延迟测试失败',
      'detailedLatencies': latencies,
      'overallSuccess': false,
    };
  }

  /// 测试带宽
  Future<Map<String, dynamic>> _testBandwidth() async {
    // 简单的带宽测试，下载较大的文件测试速度
    final testUrl = 'https://httpbin.org/bytes/1048576'; // 1MB
    
    try {
      final stopwatch = Stopwatch()..start();
      final response = await _makeRequest(testUrl);
      stopwatch.stop();

      final bytes = response.bodyBytes.length;
      final time = stopwatch.elapsedMilliseconds / 1000;
      final speedBps = bytes / time;
      final speedMbps = (speedBps * 8) / (1024 * 1024);

      return {
        'downloadSize': '${(bytes / 1024 / 1024).toStringAsFixed(2)}MB',
        'downloadTime': '${time.toStringAsFixed(2)}s',
        'bandwidth': '${speedMbps.toStringAsFixed(2)} Mbps',
        'overallSuccess': true,
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'overallSuccess': false,
      };
    }
  }

  /// 发起HTTP请求
  Future<http.Response> _makeRequest(String url, {
    Duration timeout = _defaultTimeout,
  }) async {
    if (_httpClient != null) {
      // 使用自定义HTTP客户端
      final request = await _httpClient!.getUrl(Uri.parse(url));
      request.headers.set('User-Agent', 'FlClash-Test/1.0');
      
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      
      return http.Response(body, response.statusCode);
    } else {
      // 使用默认客户端
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'FlClash-Test/1.0'},
      ).timeout(timeout);
      
      return response;
    }
  }

  /// 清理资源
  void dispose() {
    _testResultController.close();
    _httpClient?.close();
  }

  /// 获取测试历史
  Future<List<ProxyTestResult>> getTestHistory() async {
    // 这里可以从数据库或文件中加载历史测试结果
    return [];
  }

  /// 保存测试结果
  Future<void> saveTestResult(ProxyTestResult result) async {
    // 这里可以将测试结果保存到本地存储
  }
}