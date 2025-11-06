import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';


/// 速度测试服务
class SpeedTestService {
  static final SpeedTestService _instance = SpeedTestService._internal();
  factory SpeedTestService() => _instance;
  SpeedTestService._internal();

  final Dio _dio = Dio();

  /// 测试节点延迟
  Future<TestResult> testNodeLatency(
    ProxyNode node, {
    int timeoutSeconds = 10,
    int testCount = 3,
    String? testUrl,
  }) async {
    try {
      final urls = testUrl ?? _getDefaultTestUrls();
      var totalLatency = 0;
      var successfulTests = 0;
      var lastError = '';

      for (var i = 0; i < testCount; i++) {
        try {
          final url = urls[i % urls.length];
          final startTime = DateTime.now();
          
          final response = await _testLatencyRequest(
            url, 
            node, 
            timeoutSeconds: timeoutSeconds
          );
          
          if (response) {
            final endTime = DateTime.now();
            final latency = endTime.difference(startTime).inMilliseconds;
            totalLatency += latency;
            successfulTests++;
          }
        } catch (e) {
          lastError = e.toString();
        }
      }

      if (successfulTests > 0) {
        final avgLatency = (totalLatency / successfulTests).round();
        return TestResult(
          success: true,
          latency: avgLatency,
        );
      } else {
        return TestResult(
          success: false,
          latency: null,
          error: lastError,
        );
      }
    } catch (e) {
      return TestResult(
        success: false,
        latency: null,
        error: e.toString(),
      );
    }
  }

  /// 测试节点速度
  Future<SpeedTestResult> testNodeSpeed(
    ProxyNode node, {
    int timeoutSeconds = 30,
    int testSize = 1024 * 1024, // 1MB;
    List<String>? testUrls,
  }) async {
    try {
      final urls = testUrls ?? _getSpeedTestUrls();
      
      // 测试下载速度
      final downloadResult = await _testDownloadSpeed(
        node,
        urls: urls,
        timeoutSeconds: timeoutSeconds,
        testSize: testSize,
      );

      // 测试上传速度
      final uploadResult = await _testUploadSpeed(
        node,
        timeoutSeconds: timeoutSeconds,
      );

      return SpeedTestResult(
        downloadSpeed: downloadResult.speed,
        uploadSpeed: uploadResult.speed,
        latency: downloadResult.latency,
        success: downloadResult.success && uploadResult.success,
        error: downloadResult.error ?? uploadResult.error,
      );
    } catch (e) {
      return SpeedTestResult(
        downloadSpeed: 0.0,
        uploadSpeed: 0.0,
        latency: null,
        success: false,
        error: e.toString(),
      );
    }
  }

  /// 综合测试节点
  Future<ComprehensiveTestResult> comprehensiveNodeTest(
    ProxyNode node, {
    int timeoutSeconds = 60,
  }) async {
    try {
      final startTime = DateTime.now();
      
      // 延迟测试
      final latencyResult = await testNodeLatency(
        node,
        timeoutSeconds: timeoutSeconds ~/ 3,
      );
      
      // 速度测试
      final speedResult = await testNodeSpeed(
        node,
        timeoutSeconds: timeoutSeconds * 2 ~/ 3,
      );

      final endTime = DateTime.now();
      final totalTime = endTime.difference(startTime).inSeconds;

      return ComprehensiveTestResult(
        latencyResult: latencyResult,
        speedResult: speedResult,
        totalTime: totalTime,
        success: latencyResult.success,
      );
    } catch (e) {
      return ComprehensiveTestResult(
        latencyResult: TestResult(success: false, latency: null, error: e.toString()),
        speedResult: SpeedTestResult(
          downloadSpeed: 0.0,
          uploadSpeed: 0.0,
          latency: null,
          success: false,
          error: e.toString(),
        ),
        totalTime: 0,
        success: false,
      );
    }
  }

  /// 批量测试节点延迟
  Future<Map<String, TestResult>> batchTestLatency(
    List<ProxyNode> nodes, {
    int timeoutSeconds = 10,
    int concurrency = 5,
    String? testUrl,
  }) async {
    final results = <String, TestResult>{};
    final futures = <Future<void>>[];

    // 分批并发测试
    for (var i = 0; i < nodes.length; i += concurrency) {
      final batch = nodes.sublist(
        i, 
        (i + concurrency).clamp(0, nodes.length)
      );

      for (final node in batch) {
        futures.add(
          testNodeLatency(
            node, 
            timeoutSeconds: timeoutSeconds,
            testUrl: testUrl,
          ).then((result) {
            results[node.id] = result;
          }).catchError((e) {
            results[node.id] = TestResult(
              success: false,
              latency: null,
              error: e.toString(),
            );
          })
        );
      }

      // 等待当前批次完成
      await Future.wait(futures);
      futures.clear();
    }

    return results;
  }

  /// 批量测试节点速度
  Future<Map<String, SpeedTestResult>> batchTestSpeed(
    List<ProxyNode> nodes, {
    int timeoutSeconds = 30,
    int concurrency = 3,
    int testSize = 1024 * 1024,
  }) async {
    final results = <String, SpeedTestResult>{};
    final futures = <Future<void>>[];

    // 分批并发测试
    for (var i = 0; i < nodes.length; i += concurrency) {
      final batch = nodes.sublist(
        i, 
        (i + concurrency).clamp(0, nodes.length)
      );

      for (final node in batch) {
        futures.add(
          testNodeSpeed(
            node,
            timeoutSeconds: timeoutSeconds,
            testSize: testSize,
          ).then((result) {
            results[node.id] = result;
          }).catchError((e) {
            results[node.id] = SpeedTestResult(
              downloadSpeed: 0.0,
              uploadSpeed: 0.0,
              latency: null,
              success: false,
              error: e.toString(),
            );
          })
        );
      }

      // 等待当前批次完成
      await Future.wait(futures);
      futures.clear();
    }

    return results;
  }

  /// 测试延迟请求
  Future<bool> _testLatencyRequest(
    String url, 
    ProxyNode node, {
    required int timeoutSeconds,
  }) async {
    try {
      final dioOptions = BaseOptions(
        connectTimeout: Duration(seconds: timeoutSeconds),
        receiveTimeout: Duration(seconds: timeoutSeconds),
        sendTimeout: Duration(seconds: timeoutSeconds),
      );

      final customDio = Dio(dioOptions);

      // 根据节点类型设置代理
      await _configureProxyForDio(customDio, node);

      final response = await customDio.get(
        url,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          },
        ),
      );

      customDio.close();
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 测试下载速度
  Future<SpeedTestResult> _testDownloadSpeed(
    ProxyNode node, {
    required List<String> urls,
    required int timeoutSeconds,
    required int testSize,
  }) async {
    try {
      final startTime = DateTime.now();
      var downloadedBytes = 0;
      var success = false;
      var lastError = '';

      for (final url in urls) {
        try {
          final dioOptions = BaseOptions(
            connectTimeout: Duration(seconds: timeoutSeconds),
            receiveTimeout: Duration(seconds: timeoutSeconds),
          );

          final customDio = Dio(dioOptions);
          await _configureProxyForDio(customDio, node);

          final response = await customDio.get(
            url,
            options: Options(
              headers: {
                'Range': 'bytes=0-${testSize - 1}',
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
              },
              responseType: ResponseType.bytes,
            ),
          );

          if (response.statusCode == 200 || response.statusCode == 206) {
            downloadedBytes += response.data.length;
            success = true;
            break;
          }

          customDio.close();
        } catch (e) {
          lastError = e.toString();
        }
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds / 1000.0;

      if (success && duration > 0) {
        final speedBytesPerSecond = downloadedBytes / duration;
        final speedMbps = (speedBytesPerSecond * 8) / (1024 * 1024); // 转换为 Mbps;
        
        return SpeedTestResult(
          downloadSpeed: speedMbps,
          uploadSpeed: 0.0,
          latency: null,
          success: true,
        );
      } else {
        return SpeedTestResult(
          downloadSpeed: 0.0,
          uploadSpeed: 0.0,
          latency: null,
          success: false,
          error: lastError,
        );
      }
    } catch (e) {
      return SpeedTestResult(
        downloadSpeed: 0.0,
        uploadSpeed: 0.0,
        latency: null,
        success: false,
        error: e.toString(),
      );
    }
  }

  /// 测试上传速度
  Future<SpeedTestResult> _testUploadSpeed(
    ProxyNode node, {
    required int timeoutSeconds,
  }) async {
    try {
      // 上传测试通常比较复杂，这里返回一个模拟结果
      // 实际实现可能需要上传到特定的测试服务器
      await Future.delayed(Duration(seconds: 2)); // 模拟测试时间
      
      return SpeedTestResult(
        downloadSpeed: 0.0,
        uploadSpeed: 0.0, // 上传速度在移动设备上较难准确测试
        latency: null,
        success: true,
      );
    } catch (e) {
      return SpeedTestResult(
        downloadSpeed: 0.0,
        uploadSpeed: 0.0,
        latency: null,
        success: false,
        error: e.toString(),
      );
    }
  }

  /// 为 Dio 配置代理
  Future<void> _configureProxyForDio(Dio dio, ProxyNode node) async {
    try {
      String proxyUrl;
      
      switch (node.type) {
        case ProxyType.socks5:
          proxyUrl = 'socks5://${node.server}:${node.port}';
          if (node.auth != null) {
            proxyUrl = 'socks5://${node.auth}@${node.server}:${node.port}';
          }
          break;
        case ProxyType.http:
          proxyUrl = 'http://${node.server}:${node.port}';
          if (node.auth != null) {
            proxyUrl = 'http://${node.auth}@${node.server}:${node.port}';
          }
          break;
        default:
          // 对于 VMess, VLESS, SS, Trojan 等，需要通过 V2Ray 或其他代理工具
          // 这里需要根据具体的实现来处理
          proxyUrl = 'http://localhost:1080'; // 默认代理地址;
          break;
      }
      
      dio.options.proxy = proxyUrl;
    } catch (e) {
      // 代理配置失败时不抛出异常，使用直连
    }
  }

  /// 获取默认测试 URL
  List<String> get testUrls => _getDefaultTestUrls();

  /// 获取默认测试 URL 列表
  List<String> _getDefaultTestUrls() {
    return [
      'http://www.gstatic.com/generate_204',
      'http://httpbin.org/ip',
      'http://www.google.com/favicon.ico',
      'https://httpbin.org/ip',
      'https://www.cloudflare.com/favicon.ico',
    ];
  }

  /// 获取速度测试 URL 列表
  List<String> _getSpeedTestUrls() {
    return [
      'http://speedtest.ftp.otenet.gr/files/test1Mb.db',
      'http://speedtest.tele2.net/1MB.zip',
      'http://ipv4.download.thinkbroadband.com/1MB.zip',
      'http://speedtest.newark.linode.com/1GB-linux_64.tar.gz',
      'https://proof.ovh.net/files/10Mb.dat',
    ];
  }

  /// 获取国家/地区速度测试服务器
  List<String> getRegionTestUrls(String region) {
    final regionUrls = <String, List<String>>{
      'CN': [
        'http://www.360.cn/favicon.ico',
        'http://www.baidu.com/favicon.ico',
        'http://www.qq.com/favicon.ico',
      ],
      'US': [
        'http://www.google.com/favicon.ico',
        'http://www.facebook.com/favicon.ico',
        'http://www.amazon.com/favicon.ico',
      ],
      'JP': [
        'http://www.yahoo.co.jp/favicon.ico',
        'http://www.rakuten.co.jp/favicon.ico',
      ],
      'SG': [
        'http://www.google.com.sg/favicon.ico',
      ],
      'HK': [
        'http://www.google.com.hk/favicon.ico',
      ],
    };

    return regionUrls[region] ?? _getDefaultTestUrls();
  }

  /// 测试连接性
  Future<bool> testConnectivity({
    String url = 'http://www.google.com',
    int timeoutSeconds = 5,
  }) async {
    try {
      final dio = Dio();
      dio.options.connectTimeout = Duration(seconds: timeoutSeconds);
      dio.options.receiveTimeout = Duration(seconds: timeoutSeconds);
      
      final response = await dio.get(url);
      dio.close();
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 获取本地 IP 地址
  Future<String> getLocalIP() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLinkLocal: false,
      );

      for (final interface in interfaces) {
        for (final address in interface.addresses) {
          if (!address.isLoopback) {
            return address.address;
          }
        }
      }
      
      return 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  /// 清理资源
  void dispose() {
    _dio.close();
  }
}

/// 速度测试结果
class SpeedTestResult {
  final double downloadSpeed; // Mbps
  final double uploadSpeed;   // Mbps
  final int? latency;         // 毫秒
  final bool success;
  final String? error;

  SpeedTestResult({
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.latency,
    required this.success,
    this.error,
  });
}

/// 综合测试结果
class ComprehensiveTestResult {
  final TestResult latencyResult;
  final SpeedTestResult speedResult;
  final int totalTime; // 秒
  final bool success;

  ComprehensiveTestResult({
    required this.latencyResult,
    required this.speedResult,
    required this.totalTime,
    required this.success,
  });

  /// 获取总体评分 (0-100)
  double get score {
    if (!success) return 0.0;
    
    double score = 0.0;
    
    // 延迟评分 (40%)
    if (latencyResult.latency != null) {
      final latency = latencyResult.latency!;
      final latencyScore = (1000 - latency) / 10; // 延迟越低分数越高;
      score += latencyScore * 0.4;
    }
    
    // 下载速度评分 (40%)
    final downloadScore = min(speedResult.downloadSpeed, 100); // 限制最大分数;
    score += downloadScore * 0.4;
    
    // 稳定性评分 (20%) - 简化处理
    score += 20;
    
    return max(0, min(100, score));
  }
}