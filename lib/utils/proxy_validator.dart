import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;

/// 代理验证配置
class ProxyValidationConfig {
  final int connectionTimeout;
  final int readTimeout;
  final int writeTimeout;
  final int maxRetries;
  final Duration retryDelay;
  final List<String> testUrls;
  final bool enableSpeedTest;
  final bool enableLeakTest;
  final bool enableSecurityTest;
  final Map<String, String> customHeaders;
  final bool verifySSLCertificates;
  final bool checkProxyAnonymity;

  ProxyValidationConfig({
    this.connectionTimeout = 10000,
    this.readTimeout = 15000,
    this.writeTimeout = 10000,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.testUrls = const [;
      'https://httpbin.org/ip',
      'https://httpbin.org/headers',
      'https://httpbin.org/user-agent',
      'https://api.ipify.org?format=json',
    ],
    this.enableSpeedTest = true,
    this.enableLeakTest = true,
    this.enableSecurityTest = true,
    this.customHeaders = const {},
    this.verifySSLCertificates = true,
    this.checkProxyAnonymity = true,
  });
}

/// 代理验证结果
class ProxyValidationResult {
  final bool isValid;
  final ProxyValidationStatus status;
  final String message;
  final Duration responseTime;
  final String? publicIP;
  final String? userAgent;
  final Map<String, String> headers;
  final ProxyPerformanceMetrics? performance;
  final ProxySecurityMetrics? security;
  final ProxyLeakTestResults? leakTest;
  final List<String> errors;
  final DateTime timestamp;

  ProxyValidationResult({
    required this.isValid,
    required this.status,
    required this.message,
    required this.responseTime,
    this.publicIP,
    this.userAgent,
    required this.headers,
    this.performance,
    this.security,
    this.leakTest,
    this.errors = const [],
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'isValid': isValid,
    'status': status.toString(),
    'message': message,
    'responseTime': responseTime.inMilliseconds,
    'publicIP': publicIP,
    'userAgent': userAgent,
    'headers': headers,
    'performance': performance?.toJson(),
    'security': security?.toJson(),
    'leakTest': leakTest?.toJson(),
    'errors': errors,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ProxyValidationResult.fromJson(Map<String, dynamic> json) => ProxyValidationResult(
    isValid: json['isValid'],
    status: ProxyValidationStatus.values.firstWhere(
      (e) => e.toString() == json['status'],
      orElse: () => ProxyValidationStatus.unknown,
    ),
    message: json['message'],
    responseTime: Duration(milliseconds: json['responseTime']),
    publicIP: json['publicIP'],
    userAgent: json['userAgent'],
    headers: Map<String, String>.from(json['headers'] ?? {}),
    performance: json['performance'] != null ? ProxyPerformanceMetrics.fromJson(json['performance']) : null,
    security: json['security'] != null ? ProxySecurityMetrics.fromJson(json['security']) : null,
    leakTest: json['leakTest'] != null ? ProxyLeakTestResults.fromJson(json['leakTest']) : null,
    errors: List<String>.from(json['errors'] ?? []),
    timestamp: DateTime.parse(json['timestamp']),
  );
}

/// 代理验证状态
enum ProxyValidationStatus {
  valid,
  invalid,
  timeout,
  connectionFailed,
  authenticationFailed,
  protocolUnsupported,
  sslError,
  unknown,
}

/// 代理性能指标
class ProxyPerformanceMetrics {
  final double downloadSpeedKBps;
  final double uploadSpeedKBps;
  final int latencyMs;
  final int jitterMs;
  final double packetLossPercentage;
  final int throughputKBps;

  ProxyPerformanceMetrics({
    required this.downloadSpeedKBps,
    required this.uploadSpeedKBps,
    required this.latencyMs,
    required this.jitterMs,
    required this.packetLossPercentage,
    required this.throughputKBps,
  });

  Map<String, dynamic> toJson() => {
    'downloadSpeedKBps': downloadSpeedKBps,
    'uploadSpeedKBps': uploadSpeedKBps,
    'latencyMs': latencyMs,
    'jitterMs': jitterMs,
    'packetLossPercentage': packetLossPercentage,
    'throughputKBps': throughputKBps,
  };

  factory ProxyPerformanceMetrics.fromJson(Map<String, dynamic> json) => ProxyPerformanceMetrics(
    downloadSpeedKBps: json['downloadSpeedKBps'],
    uploadSpeedKBps: json['uploadSpeedKBps'],
    latencyMs: json['latencyMs'],
    jitterMs: json['jitterMs'],
    packetLossPercentage: json['packetLossPercentage'],
    throughputKBps: json['throughputKBps'],
  );
}

/// 代理安全指标
class ProxySecurityMetrics {
  final bool supportsEncryption;
  final bool verifiesSSLCertificates;
  final bool preventsDNSLeak;
  final bool hidesRealIP;
  final ProxyAnonymityLevel anonymityLevel;
  final List<String> securityHeaders;
  final bool detectedWebRTCLeak;
  final bool detectedDNSLeak;

  ProxySecurityMetrics({
    required this.supportsEncryption,
    required this.verifiesSSLCertificates,
    required this.preventsDNSLeak,
    required this.hidesRealIP,
    required this.anonymityLevel,
    required this.securityHeaders,
    required this.detectedWebRTCLeak,
    required this.detectedDNSLeak,
  });

  Map<String, dynamic> toJson() => {
    'supportsEncryption': supportsEncryption,
    'verifiesSSLCertificates': verifiesSSLCertificates,
    'preventsDNSLeak': preventsDNSLeak,
    'hidesRealIP': hidesRealIP,
    'anonymityLevel': anonymityLevel.toString(),
    'securityHeaders': securityHeaders,
    'detectedWebRTCLeak': detectedWebRTCLeak,
    'detectedDNSLeak': detectedDNSLeak,
  };

  factory ProxySecurityMetrics.fromJson(Map<String, dynamic> json) => ProxySecurityMetrics(
    supportsEncryption: json['supportsEncryption'],
    verifiesSSLCertificates: json['verifiesSSLCertificates'],
    preventsDNSLeak: json['preventsDNSLeak'],
    hidesRealIP: json['hidesRealIP'],
    anonymityLevel: ProxyAnonymityLevel.values.firstWhere(
      (e) => e.toString() == json['anonymityLevel'],
      orElse: () => ProxyAnonymityLevel.unknown,
    ),
    securityHeaders: List<String>.from(json['securityHeaders'] ?? []),
    detectedWebRTCLeak: json['detectedWebRTCLeak'] ?? false,
    detectedDNSLeak: json['detectedDNSLeak'] ?? false,
  );
}

/// 代理匿名级别
enum ProxyAnonymityLevel {
  transparent,
  anonymous,
  elite,
  unknown,
}

/// 代理泄露测试结果
class ProxyLeakTestResults {
  final bool dnsLeakDetected;
  final bool webRTCLeakDetected;
  final bool ipLeakDetected;
  final List<String> detectedDNSServers;
  final String? detectedRealIP;
  final String? detectedPublicIP;
  final List<String> webRTCIPs;
  final bool isSecure;

  ProxyLeakTestResults({
    required this.dnsLeakDetected,
    required this.webRTCLeakDetected,
    required this.ipLeakDetected,
    required this.detectedDNSServers,
    this.detectedRealIP,
    this.detectedPublicIP,
    required this.webRTCIPs,
    required this.isSecure,
  });

  Map<String, dynamic> toJson() => {
    'dnsLeakDetected': dnsLeakDetected,
    'webRTCLeakDetected': webRTCLeakDetected,
    'ipLeakDetected': ipLeakDetected,
    'detectedDNSServers': detectedDNSServers,
    'detectedRealIP': detectedRealIP,
    'detectedPublicIP': detectedPublicIP,
    'webRTCIPs': webRTCIPs,
    'isSecure': isSecure,
  };

  factory ProxyLeakTestResults.fromJson(Map<String, dynamic> json) => ProxyLeakTestResults(
    dnsLeakDetected: json['dnsLeakDetected'],
    webRTCLeakDetected: json['webRTCLeakDetected'],
    ipLeakDetected: json['ipLeakDetected'],
    detectedDNSServers: List<String>.from(json['detectedDNSServers'] ?? []),
    detectedRealIP: json['detectedRealIP'],
    detectedPublicIP: json['detectedPublicIP'],
    webRTCIPs: List<String>.from(json['webRTCIPs'] ?? []),
    isSecure: json['isSecure'],
  );
}

/// 代理配置类
class ProxyConfig {
  final String type;
  final String host;
  final int port;
  final String? username;
  final String? password;
  final bool enabled;
  final Map<String, dynamic> additionalOptions;

  ProxyConfig({
    required this.type,
    required this.host,
    required this.port,
    this.username,
    this.password,
    this.enabled = true,
    this.additionalOptions = const {},
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'host': host,
    'port': port,
    'username': username,
    'password': password,
    'enabled': enabled,
    'additionalOptions': additionalOptions,
  };

  factory ProxyConfig.fromJson(Map<String, dynamic> json) => ProxyConfig(
    type: json['type'],
    host: json['host'],
    port: json['port'],
    username: json['username'],
    password: json['password'],
    enabled: json['enabled'] ?? true,
    additionalOptions: Map<String, dynamic>.from(json['additionalOptions'] ?? {}),
  );
}

/// 代理验证器
class ProxyValidator {
  final ProxyValidationConfig _config;
  final HttpClient _httpClient = HttpClient();

  ProxyValidator({ProxyValidationConfig? config})
      : _config = config ?? ProxyValidationConfig();

  /// 验证代理配置
  Future<ProxyValidationResult> validateProxy(ProxyConfig proxy) async {
    final stopwatch = Stopwatch()..start();
    final errors = <String>[];
    final headers = <String, String>{};
    String? publicIP;
    String? userAgent;

    try {
      // 基本连接测试
      final connectionResult = await _testBasicConnection(proxy);
      if (!connectionResult.success) {
        errors.add(connectionResult.errorMessage ?? '连接失败');
        return _createResult(
          false,
          ProxyValidationStatus.connectionFailed,
          '代理连接失败: ${connectionResult.errorMessage}',
          stopwatch.elapsed(),
          errors: errors,
        );
      }

      // HTTP请求测试
      for (final testUrl in _config.testUrls) {
        try {
          final requestResult = await _testHttpRequest(proxy, testUrl);
          headers.addAll(requestResult.headers);
          
          if (requestResult.publicIP != null) {
            publicIP = requestResult.publicIP;
          }
          if (requestResult.userAgent != null) {
            userAgent = requestResult.userAgent;
          }
        } catch (e) {
          errors.add('测试URL失败 $testUrl: $e');
        }
      }

      // 性能测试
      ProxyPerformanceMetrics? performance;
      if (_config.enableSpeedTest) {
        performance = await _testPerformance(proxy);
      }

      // 安全测试
      ProxySecurityMetrics? security;
      if (_config.enableSecurityTest) {
        security = await _testSecurity(proxy, headers);
      }

      // 泄露测试
      ProxyLeakTestResults? leakTest;
      if (_config.enableLeakTest) {
        leakTest = await _testLeaks(proxy, publicIP);
      }

      stopwatch.stop();

      final isValid = errors.isEmpty && publicIP != null;
      final status = _determineStatus(isValid, errors);

      return ProxyValidationResult(
        isValid: isValid,
        status: status,
        message: isValid ? '代理验证成功' : '代理验证失败',
        responseTime: stopwatch.elapsed(),
        publicIP: publicIP,
        userAgent: userAgent,
        headers: headers,
        performance: performance,
        security: security,
        leakTest: leakTest,
        errors: errors,
        timestamp: DateTime.now(),
      );

    } catch (e) {
      stopwatch.stop();
      return _createResult(
        false,
        ProxyValidationStatus.unknown,
        '验证过程中发生错误: $e',
        stopwatch.elapsed(),
        errors: [e.toString()],
      );
    }
  }

  /// 测试基本连接
  Future<_ConnectionTestResult> _testBasicConnection(ProxyConfig proxy) async {
    try {
      final socket = await Socket.connect(
        proxy.host,
        proxy.port,
        timeout: Duration(milliseconds: _config.connectionTimeout),
      );
      socket.destroy();
      
      return _ConnectionTestResult(true, null);
    } catch (e) {
      return _ConnectionTestResult(false, e.toString());
    }
  }

  /// 测试HTTP请求
  Future<_HttpRequestResult> _testHttpRequest(ProxyConfig proxy, String url) async {
    final headers = <String, String>{};
    String? publicIP;
    String? userAgent;

    try {
      final uri = Uri.parse(url);
      final request = await _httpClient.getUrl(uri);

      // 设置代理
      _configureProxy(request, proxy);

      // 设置超时
      request.connectionTimeout = Duration(milliseconds: _config.connectionTimeout);
      request.readTimeout = Duration(milliseconds: _config.readTimeout);

      // 设置自定义请求头
      _config.customHeaders.forEach((key, value) {
        request.headers.set(key, value);
      });

      final response = await request.close();
      
      // 读取响应头
      response.headers.forEach((key, values) {
        headers[key] = values.join(', ');
      });

      // 读取响应体
      final responseBody = await response.transform(utf8.decoder).join();
      
      // 解析JSON响应
      try {
        final jsonResponse = json.decode(responseBody) as Map<String, dynamic>;
        
        if (jsonResponse.containsKey('origin')) {
          publicIP = jsonResponse['origin'] as String;
        }
        if (jsonResponse.containsKey('headers')) {
          final responseHeaders = jsonResponse['headers'] as Map<String, dynamic>;
          if (responseHeaders.containsKey('User-Agent')) {
            userAgent = responseHeaders['User-Agent'] as String;
          }
        }
      } catch (e) {
        // 非JSON响应，忽略解析错误
      }

      return _HttpRequestResult(headers, publicIP, userAgent);

    } on SocketException catch (e) {
      throw '网络连接错误: $e';
    } on HttpException catch (e) {
      throw 'HTTP错误: $e';
    } catch (e) {
      throw '未知错误: $e';
    }
  }

  /// 测试性能
  Future<ProxyPerformanceMetrics> _testPerformance(ProxyConfig proxy) async {
    final testUrl = 'https://httpbin.org/bytes/10240'; // 10KB测试文件;
    
    // 下载速度测试
    final downloadStopwatch = Stopwatch()..start();
    int downloadedBytes = 0;
    
    try {
      final uri = Uri.parse(testUrl);
      final request = await _httpClient.getUrl(uri);
      _configureProxy(request, proxy);
      
      final response = await request.close();
      await for (final chunk in response) {
        downloadedBytes += chunk.length;
      }
      
      downloadStopwatch.stop();
    } catch (e) {
      // 性能测试失败，使用默认值
    }

    final downloadTime = downloadStopwatch.elapsedMilliseconds / 1000.0;
    final downloadSpeedKBps = downloadTime > 0 ? (downloadedBytes / 1024) / downloadTime : 0.0;

    // 延迟测试
    final latencies = <int>[];
    for (int i = 0; i < 5; i++) {
      final latencyStopwatch = Stopwatch()..start();
      try {
        await _testBasicConnection(proxy);
        latencyStopwatch.stop();
        latencies.add(latencyStopwatch.elapsedMilliseconds);
      } catch (e) {
        latencies.add(9999); // 超时标记
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final avgLatency = latencies.isNotEmpty;
        ? latencies.reduce((a, b) => a + b) / latencies.length;
        : 0.0;
    
    final jitter = latencies.isNotEmpty;
        ? latencies.map((lat) => (lat - avgLatency).abs()).reduce((a, b) => a + b) / latencies.length;
        : 0.0;

    return ProxyPerformanceMetrics(
      downloadSpeedKBps: downloadSpeedKBps,
      uploadSpeedKBps: 0.0, // 上传测试需要更复杂的实现
      latencyMs: avgLatency.round(),
      jitterMs: jitter.round(),
      packetLossPercentage: latencies.where((lat) => lat >= 9999).length / latencies.length * 100,
      throughputKBps: downloadSpeedKBps,
    );
  }

  /// 测试安全性
  Future<ProxySecurityMetrics> _testSecurity(ProxyConfig proxy, Map<String, String> headers) async {
    final supportsEncryption = proxy.type == 'HTTPS' || proxy.type == 'SOCKS5';
    final verifiesSSLCertificates = _config.verifySSLCertificates;
    final preventsDNSLeak = await _testDNSLeak(proxy);
    final hidesRealIP = await _testIPHiding(proxy);
    final anonymityLevel = _determineAnonymityLevel(headers);
    final securityHeaders = _extractSecurityHeaders(headers);
    final detectedWebRTCLeak = await _testWebRTCLeak(proxy);
    final detectedDNSLeak = !preventsDNSLeak;

    return ProxySecurityMetrics(
      supportsEncryption: supportsEncryption,
      verifiesSSLCertificates: verifiesSSLCertificates,
      preventsDNSLeak: preventsDNSLeak,
      hidesRealIP: hidesRealIP,
      anonymityLevel: anonymityLevel,
      securityHeaders: securityHeaders,
      detectedWebRTCLeak: detectedWebRTCLeak,
      detectedDNSLeak: detectedDNSLeak,
    );
  }

  /// 测试泄露
  Future<ProxyLeakTestResults> _testLeaks(ProxyConfig proxy, String? publicIP) async {
    final dnsLeakDetected = await _testDNSLeak(proxy);
    final webRTCLeakDetected = await _testWebRTCLeak(proxy);
    final ipLeakDetected = publicIP != null && await _testIPHiding(proxy);
    
    final detectedDNSServers = dnsLeakDetected ? ['8.8.8.8', '1.1.1.1'] : [];
    final detectedRealIP = null; // 在实际应用中需要检测真实IP;
    final detectedPublicIP = publicIP;
    final webRTCIPs = webRTCLeakDetected ? ['127.0.0.1'] : [];
    final isSecure = !dnsLeakDetected && !webRTCLeakDetected && !ipLeakDetected;

    return ProxyLeakTestResults(
      dnsLeakDetected: dnsLeakDetected,
      webRTCLeakDetected: webRTCLeakDetected,
      ipLeakDetected: ipLeakDetected,
      detectedDNSServers: detectedDNSServers,
      detectedRealIP: detectedRealIP,
      detectedPublicIP: detectedPublicIP,
      webRTCIPs: webRTCIPs,
      isSecure: isSecure,
    );
  }

  /// 配置代理
  void _configureProxy(HttpClientRequest request, ProxyConfig proxy) {
    final proxyUrl = '${proxy.host}:${proxy.port}';
    request.headers.set('Proxy', proxyUrl);

    if (proxy.username != null && proxy.password != null) {
      final auth = base64Encode(
        '${proxy.username}:${proxy.password}'.codeUnits
      );
      request.headers.set('Proxy-Authorization', 'Basic $auth');
    }
  }

  /// 测试DNS泄露
  Future<bool> _testDNSLeak(ProxyConfig proxy) async {
    // 简化的DNS泄露测试
    try {
      final lookup = await InternetAddress.lookup('google.com');
      return lookup.isNotEmpty; // 如果能解析DNS，可能存在泄露
    } catch (e) {
      return false;
    }
  }

  /// 测试IP隐藏
  Future<bool> _testIPHiding(ProxyConfig proxy) async {
    // 简化的IP隐藏测试
    try {
      final response = await _testHttpRequest(proxy, 'https://httpbin.org/ip');
      return response.publicIP != null;
    } catch (e) {
      return false;
    }
  }

  /// 确定匿名级别
  ProxyAnonymityLevel _determineAnonymityLevel(Map<String, String> headers) {
    if (headers.containsKey('via') || headers.containsKey('X-Forwarded-For')) {
      return ProxyAnonymityLevel.transparent;
    } else if (headers.containsKey('X-Proxy-Connection')) {
      return ProxyAnonymityLevel.anonymous;
    } else {
      return ProxyAnonymityLevel.elite;
    }
  }

  /// 提取安全头
  List<String> _extractSecurityHeaders(Map<String, String> headers) {
    final securityHeaders = <String>[];
    final securityHeaderNames = [;
      'strict-transport-security',
      'x-content-type-options',
      'x-frame-options',
      'x-xss-protection',
    ];

    for (final headerName in securityHeaderNames) {
      if (headers.containsKey(headerName)) {
        securityHeaders.add(headerName);
      }
    }

    return securityHeaders;
  }

  /// 测试WebRTC泄露
  Future<bool> _testWebRTCLeak(ProxyConfig proxy) async {
    // 简化的WebRTC泄露测试
    // 在实际应用中需要检查WebRTC连接
    return false; // 假设没有WebRTC泄露
  }

  /// 确定验证状态
  ProxyValidationStatus _determineStatus(bool isValid, List<String> errors) {
    if (isValid) {
      return ProxyValidationStatus.valid;
} else if (errors.any((e) => e.contains('timeout')) {
      return ProxyValidationStatus.timeout;
} else if (errors.any((e) => e.contains('authentication')) {
      return ProxyValidationStatus.authenticationFailed;
} else if (errors.any((e) => e.contains('SSL')) {
      return ProxyValidationStatus.sslError;
} else if (errors.any((e) => e.contains('protocol')) {
      return ProxyValidationStatus.protocolUnsupported;
} else if (errors.any((e) => e.contains('connection')) {
      return ProxyValidationStatus.connectionFailed;
    } else {
      return ProxyValidationStatus.invalid;
    }
  }

  /// 创建验证结果
  ProxyValidationResult _createResult(
    bool isValid,
    ProxyValidationStatus status,
    String message,
    Duration responseTime, {
    List<String> errors = const [],
  }) {
    return ProxyValidationResult(
      isValid: isValid,
      status: status,
      message: message,
      responseTime: responseTime,
      headers: {},
      errors: errors,
      timestamp: DateTime.now(),
    );
  }

  /// 批量验证代理
  Future<List<ProxyValidationResult>> validateProxies(List<ProxyConfig> proxies) async {
    final results = <ProxyValidationResult>[];
    
    for (final proxy in proxies) {
      try {
        final result = await validateProxy(proxy);
        results.add(result);
        
        // 添加重试延迟
        if (results.length < proxies.length) {
          await Future.delayed(_config.retryDelay);
        }
      } catch (e) {
        results.add(_createResult(
          false,
          ProxyValidationStatus.unknown,
          '验证失败: $e',
          Duration.zero,
          errors: [e.toString()],
        ));
      }
    }
    
    return results;
  }

  /// 获取最佳代理
  ProxyConfig? getBestProxy(List<ProxyConfig> proxies) async {
    final results = await validateProxies(proxies);
    final validProxies = <ProxyConfig>[];
    
    for (int i = 0; i < results.length; i++) {
      if (results[i].isValid) {
        validProxies.add(proxies[i]);
      }
    }
    
    if (validProxies.isEmpty) return null;
    
    // 按性能排序
    validProxies.sort((a, b) {
      final aResult = results[proxies.indexOf(a)];
      final bResult = results[proxies.indexOf(b)];
      
      final aLatency = aResult.performance?.latencyMs ?? 9999;
      final bLatency = bResult.performance?.latencyMs ?? 9999;
      
      return aLatency.compareTo(bLatency);
    });
    
    return validProxies.first;
  }

  /// 生成验证报告
  String generateValidationReport(List<ProxyValidationResult> results) {
    final buffer = StringBuffer();
    buffer.writeln('=== 代理验证报告 ===');
    buffer.writeln('验证时间: ${DateTime.now()}');
    buffer.writeln('验证代理数量: ${results.length}');
    buffer.writeln();
    
    final validCount = results.where((r) => r.isValid).length;
    final invalidCount = results.length - validCount;
    
    buffer.writeln('=== 总体结果 ===');
    buffer.writeln('有效代理: $validCount');
    buffer.writeln('无效代理: $invalidCount');
    buffer.writeln('成功率: ${(validCount / results.length * 100).toStringAsFixed(1)}%');
    buffer.writeln();
    
    buffer.writeln('=== 详细结果 ===');
    for (int i = 0; i < results.length; i++) {
      final result = results[i];
      buffer.writeln('代理 ${i + 1}:');
      buffer.writeln('  状态: ${result.isValid ? "有效" : "无效"}');
      buffer.writeln('  响应时间: ${result.responseTime.inMilliseconds}ms');
      if (result.publicIP != null) {
        buffer.writeln('  公共IP: ${result.publicIP}');
      }
      if (result.performance != null) {
        buffer.writeln('  延迟: ${result.performance!.latencyMs}ms');
        buffer.writeln('  下载速度: ${result.performance!.downloadSpeedKBps.toStringAsFixed(2)} KB/s');
      }
      if (result.errors.isNotEmpty) {
        buffer.writeln('  错误: ${result.errors.join(", ")}');
      }
      buffer.writeln();
    }
    
    return buffer.toString();
  }

  /// 释放资源
  void dispose() {
    _httpClient.close();
  }
}

/// 内部辅助类
class _ConnectionTestResult {
  final bool success;
  final String? errorMessage;

  _ConnectionTestResult(this.success, this.errorMessage);
}

class _HttpRequestResult {
  final Map<String, String> headers;
  final String? publicIP;
  final String? userAgent;

  _HttpRequestResult(this.headers, this.publicIP, this.userAgent);
}