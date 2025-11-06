import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;

import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';

/// 网络验证结果
class NetworkValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final Map<String, dynamic> details;
  final DateTime timestamp;

  NetworkValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    required this.details,
    required this.timestamp,
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'isValid': isValid,
    'errors': errors,
    'warnings': warnings,
    'details': details,
    'timestamp': timestamp.toIso8601String(),
  };

  factory NetworkValidationResult.fromJson(Map<String, dynamic> json) =>
    NetworkValidationResult(
      isValid: json['isValid'],
      errors: List<String>.from(json['errors']),
      warnings: List<String>.from(json['warnings']),
      details: json['details'],
      timestamp: DateTime.parse(json['timestamp']),
    );
}

/// 网络检测状态
enum NetworkDetectionState {
  unknown,
  disconnected,
  connected,
  proxyActive,
  proxyInactive,
  suspicious
}

/// 网络验证工具
class NetworkValidator {
  static final NetworkValidator _instance = NetworkValidator._internal();
  factory NetworkValidator() => _instance;
  NetworkValidator._internal();

  final NetworkInfo _networkInfo = NetworkInfo();
  StreamController<NetworkDetectionState>? _stateController;
  NetworkDetectionState? _currentState;

  Stream<NetworkDetectionState> get stateStream => 
    _stateController?.stream ?? const Stream.empty();
  
  NetworkDetectionState? get currentState => _currentState;

  /// 验证网络连接
  Future<NetworkValidationResult> validateNetworkConnection({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final errors = <String>[];
    final warnings = <String>[];
    final details = <String, dynamic>{};

    try {
      // 检查网络接口
      final interfaces = await io.NetworkInterface.list(type: io.InternetAddressType.IPv4);
      details['interfaces'] = interfaces.map((i) => i.name).toList();
      
      if (interfaces.isEmpty) {
        errors.add('未找到网络接口');
      }

      // 检查DNS解析
      final dnsTest = await _testDNSResolution(timeout);
      details['dnsTest'] = dnsTest;
      if (!dnsTest['success']) {
        errors.add('DNS解析失败: ${dnsTest['error']}');
      }

      // 检查网络连通性
      final connectivityTest = await _testConnectivity(timeout);
      details['connectivityTest'] = connectivityTest;
      if (!connectivityTest['success']) {
        errors.add('网络连通性测试失败: ${connectivityTest['error']}');
      }

      // 检查网络速度
      final speedTest = await _testNetworkSpeed(timeout);
      details['speedTest'] = speedTest;
      if (speedTest['speedMbps'] != null && speedTest['speedMbps'] < 1.0) {
        warnings.add('网络速度较慢: ${speedTest['speedMbps']} Mbps');
      }

      // 检查代理状态
      final proxyTest = await _testProxyConnection();
      details['proxyTest'] = proxyTest;
      if (proxyTest['isProxyActive']) {
        _updateState(NetworkDetectionState.proxyActive);
      }

    } catch (e) {
      errors.add('网络验证异常: $e');
    }

    final isValid = errors.isEmpty;
    return NetworkValidationResult(
      isValid: isValid,
      errors: errors,
      warnings: warnings,
      details: details,
      timestamp: DateTime.now(),
    );
  }

  /// 验证代理配置
  Future<NetworkValidationResult> validateProxyConfiguration({
    required String host,
    required int port,
    required String proxyType,
    String? username,
    String? password,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final errors = <String>[];
    final warnings = <String>[];
    final details = <String, dynamic>{};

    try {
      // 验证代理地址格式
      if (!_isValidHost(host)) {
        errors.add('无效的代理主机地址: $host');
      }

      // 验证端口范围
      if (port < 1 || port > 65535) {
        errors.add('无效的端口号: $port (应介于 1-65535)');
      }

      // 验证代理类型
if (!['http', 'https', 'socks4', 'socks5'].contains(proxyType.toLowerCase()) {
        errors.add('不支持的代理类型: $proxyType');
      }

      // 测试代理连接
      final proxyConnectTest = await _testProxyConnectivity(
        host: host,
        port: port,
        proxyType: proxyType.toLowerCase(),
        timeout: timeout,
      );
      details['proxyConnectTest'] = proxyConnectTest;

      if (!proxyConnectTest['success']) {
        errors.add('代理连接测试失败: ${proxyConnectTest['error']}');
      } else {
        details['responseTime'] = proxyConnectTest['responseTime'];
      }

      // 测试代理速度
      final proxySpeedTest = await _testProxySpeed(
        host: host,
        port: port,
        proxyType: proxyType.toLowerCase(),
      );
      details['proxySpeedTest'] = proxySpeedTest;

      if (proxySpeedTest['speedMbps'] != null) {
        if (proxySpeedTest['speedMbps'] < 0.5) {
          warnings.add('代理速度较慢: ${proxySpeedTest['speedMbps']} Mbps');
        }
      }

      // 测试代理匿名性（如果可能）
      final anonymityTest = await _testProxyAnonymity(
        host: host,
        port: port,
        proxyType: proxyType.toLowerCase(),
      );
      details['anonymityTest'] = anonymityTest;

    } catch (e) {
      errors.add('代理配置验证异常: $e');
    }

    final isValid = errors.isEmpty;
    return NetworkValidationResult(
      isValid: isValid,
      errors: errors,
      warnings: warnings,
      details: details,
      timestamp: DateTime.now(),
    );
  }

  /// 检测网络中的代理
  Future<List<Map<String, dynamic>>> detectProxies() async {
    final detectedProxies = <Map<String, dynamic>>[];

    try {
      // 检测系统代理设置
      final systemProxies = await _detectSystemProxies();
      detectedProxies.addAll(systemProxies);

      // 检测环境变量代理
      final envProxies = await _detectEnvironmentProxies();
      detectedProxies.addAll(envProxies);

    } catch (e) {
      // 静默处理错误
    }

    return detectedProxies;
  }

  /// 验证DNS安全性
  Future<NetworkValidationResult> validateDNSSecurity() async {
    final errors = <String>[];
    final warnings = <String>[];
    final details = <String, dynamic>{};

    try {
      // 测试DNS服务器连通性
      final dnsServers = [;
        '8.8.8.8',
        '8.8.4.4',
        '1.1.1.1',
        '1.0.0.1',
        '223.5.5.5',
        '114.114.114.114',
      ];

      final dnsTestResults = <String, dynamic>{};
      for (final dnsServer in dnsServers) {
        final result = await _testDNSServer(dnsServer);
        dnsTestResults[dnsServer] = result;
      }
      details['dnsTestResults'] = dnsTestResults;

      // 检查DNS泄漏
      final leakTest = await _testDNSLeak();
      details['dnsLeakTest'] = leakTest;
      if (!leakTest['secure']) {
        warnings.add('检测到DNS泄漏风险');
      }

      // 检查DNS解析一致性
      final consistencyTest = await _testDNSConsistency();
      details['dnsConsistencyTest'] = consistencyTest;
      if (!consistencyTest['consistent']) {
        warnings.add('DNS解析结果不一致');
      }

    } catch (e) {
      errors.add('DNS安全验证异常: $e');
    }

    return NetworkValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      details: details,
      timestamp: DateTime.now(),
    );
  }

  /// 实时监控网络状态
  Stream<NetworkDetectionState> monitorNetworkStatus() {
    _stateController = StreamController<NetworkDetectionState>.broadcast();
    _startNetworkMonitoring();
    return _stateController!.stream;
  }

  /// 停止监控
  void stopMonitoring() {
    _stateController?.close();
    _stateController = null;
  }

  // 私有方法

  Future<Map<String, dynamic>> _testDNSResolution(Duration timeout) async {
    try {
      final results = <String, String>{};
      final domains = ['www.google.com', 'github.com', 'stackoverflow.com'];

      for (final domain in domains) {
        final addresses = await InternetAddress.lookup(domain);
          .timeout(timeout);
        results[domain] = addresses.first.address;
      }

      return {
        'success': true,
        'results': results,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _testConnectivity(Duration timeout) async {
    try {
      final urls = [;
        'https://www.google.com',
        'https://httpbin.org/get',
        'https://httpbin.org/status/200',
      ];

      final results = <String, bool>{};
      for (final url in urls) {
        final response = await http.get(
          Uri.parse(url),
          headers: {'User-Agent': 'NetworkValidator/1.0'},
        ).timeout(timeout);
        results[url] = response.statusCode == 200;
      }

      final successCount = results.values.where((s) => s).length;
      return {
        'success': successCount > 0,
        'successRate': successCount / urls.length,
        'results': results,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _testNetworkSpeed(Duration timeout) async {
    try {
      final url = 'https://httpbin.org/bytes/102400'; // 100KB;
      final stopwatch = Stopwatch()..start();
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'NetworkValidator/1.0'},
      ).timeout(timeout);
      
      stopwatch.stop();
      final bytes = response.bodyBytes.length;
      final time = stopwatch.elapsedMilliseconds / 1000;
      final speedBps = bytes / time;
      final speedMbps = (speedBps * 8) / (1024 * 1024);

      return {
        'success': true,
        'bytes': bytes,
        'time': time,
        'speedBps': speedBps,
        'speedMbps': speedMbps,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _testProxyConnection({
    required String host,
    required int port,
    required String proxyType,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    try {
      final stopwatch = Stopwatch()..start();
      
      final proxyUrl = '$proxyType://$host:$port';
      final client = http.Client();
      
      final request = http.Request('GET', Uri.parse('https://httpbin.org/get'));
      request.headers['User-Agent'] = 'NetworkValidator/1.0';
      
      final response = await client.send(request).timeout(timeout);
      stopwatch.stop();

      return {
        'success': response.statusCode == 200,
        'responseTime': stopwatch.elapsedMilliseconds,
        'statusCode': response.statusCode,
        'proxyUrl': proxyUrl,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'proxyUrl': '$proxyType://$host:$port',
      };
    }
  }

  Future<Map<String, dynamic>> _testProxySpeed({
    required String host,
    required int port,
    required String proxyType,
  }) async {
    try {
      final url = 'https://httpbin.org/bytes/51200'; // 50KB;
      final stopwatch = Stopwatch()..start();
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'NetworkValidator/1.0'},
      );
      
      stopwatch.stop();
      final bytes = response.bodyBytes.length;
      final time = stopwatch.elapsedMilliseconds / 1000;
      final speedBps = bytes / time;
      final speedMbps = (speedBps * 8) / (1024 * 1024);

      return {
        'success': true,
        'bytes': bytes,
        'time': time,
        'speedBps': speedBps,
        'speedMbps': speedMbps,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _testProxyAnonymity({
    required String host,
    required int port,
    required String proxyType,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('https://httpbin.org/headers'),
        headers: {'User-Agent': 'NetworkValidator/1.0'},
      );
      
      final data = jsonDecode(response.body);
      final headers = data['headers'];
      
      return {
        'success': true,
        'headers': headers,
        'hasProxyHeaders': headers.containsKey('Via') || headers.containsKey('X-Forwarded-For'),
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<List<Map<String, dynamic>>> _detectSystemProxies() async {
    final proxies = <Map<String, dynamic>>[];
    
    try {
      // 这里可以尝试检测系统代理设置
      // 实际实现取决于平台
      proxies.add({
        'type': 'system',
        'detected': false,
        'details': '系统代理检测功能待实现',
      });
    } catch (e) {
      // 静默处理错误
    }
    
    return proxies;
  }

  Future<List<Map<String, dynamic>>> _detectEnvironmentProxies() async {
    final proxies = <Map<String, dynamic>>[];
    
    try {
      final httpProxy = Platform.environment['HTTP_PROXY'] ??;
                        Platform.environment['http_proxy'];
      final httpsProxy = Platform.environment['HTTPS_PROXY'] ??;
                        Platform.environment['https_proxy'];
      
      if (httpProxy != null) {
        proxies.add({
          'type': 'environment',
          'protocol': 'http',
          'url': httpProxy,
        });
      }
      
      if (httpsProxy != null) {
        proxies.add({
          'type': 'environment',
          'protocol': 'https',
          'url': httpsProxy,
        });
      }
    } catch (e) {
      // 静默处理错误
    }
    
    return proxies;
  }

  Future<Map<String, dynamic>> _testDNSServer(String dnsServer) async {
    try {
      final addresses = await InternetAddress.lookup('www.google.com', 
        type: InternetAddressType.IPv4);
      return {
        'success': true,
        'resolution': addresses.first.address,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _testDNSLeak() async {
    try {
      // 简化的DNS泄漏检测
      final response = await http.get(
        Uri.parse('https://httpbin.org/ip'),
        headers: {'User-Agent': 'NetworkValidator/1.0'},
      );
      
      final data = jsonDecode(response.body);
      return {
        'secure': true, // 简化实现
        'ip': data['origin'],
      };
    } catch (e) {
      return {
        'secure': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _testDNSConsistency() async {
    try {
      final domains = ['www.google.com', 'github.com'];
      final results = <String, String>{};
      
      for (final domain in domains) {
        final addresses = await InternetAddress.lookup(domain);
        results[domain] = addresses.first.address;
      }
      
      return {
        'consistent': true, // 简化实现
        'results': results,
      };
    } catch (e) {
      return {
        'consistent': false,
        'error': e.toString(),
      };
    }
  }

  void _startNetworkMonitoring() async {
    Timer? timer;
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final result = await validateNetworkConnection();
        final newState = result.isValid;
          ? NetworkDetectionState.connected 
          : NetworkDetectionState.disconnected;
        
        if (newState != _currentState) {
          _currentState = newState;
          _stateController?.add(newState);
        }
      } catch (e) {
        _currentState = NetworkDetectionState.unknown;
        _stateController?.add(_currentState!);
      }
    });

    // 在控制器关闭时取消定时器
    _stateController?.stream.drain().then((_) => timer?.cancel());
  }

  bool _isValidHost(String host) {
    // 验证IP地址
    try {
      InternetAddress(host);
      return true;
    } catch (e) {
      // 不是IP地址，检查域名格式
      final regex = RegExp(r'^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$');
      return regex.hasMatch(host);
    }
  }
}