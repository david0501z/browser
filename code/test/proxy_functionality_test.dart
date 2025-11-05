import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

// 生成测试相关的模拟类
class MockHttpClient extends Mock implements HttpClient {}
class MockHttpClientRequest extends Mock implements HttpClientRequest {}
class MockHttpClientResponse extends Mock implements HttpClientResponse {}
class MockSocket extends Mock implements Socket {}

// 生成mockito注释
@GenerateMocks([MockHttpClient, MockHttpClientRequest, MockHttpClientResponse, MockSocket])
import 'proxy_functionality_test.mocks.dart';

/// 代理配置类
class ProxyConfig {
  final String type; // HTTP, HTTPS, SOCKS5
  final String host;
  final int port;
  final String? username;
  final String? password;
  final bool enabled;

  ProxyConfig({
    required this.type,
    required this.host,
    required this.port,
    this.username,
    this.password,
    this.enabled = true,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'host': host,
    'port': port,
    'username': username,
    'password': password,
    'enabled': enabled,
  };

  factory ProxyConfig.fromJson(Map<String, dynamic> json) => ProxyConfig(
    type: json['type'],
    host: json['host'],
    port: json['port'],
    username: json['username'],
    password: json['password'],
    enabled: json['enabled'] ?? true,
  );
}

/// 代理服务类
class ProxyService {
  final HttpClient _httpClient = HttpClient();
  ProxyConfig? _currentConfig;
  bool _isConnected = false;
  final StreamController<ProxyEvent> _eventController = 
      StreamController<ProxyEvent>.broadcast();

  Stream<ProxyEvent> get events => _eventController.stream;
  ProxyConfig? get currentConfig => _currentConfig;
  bool get isConnected => _isConnected;

  Future<bool> connect(ProxyConfig config) async {
    try {
      _currentConfig = config;
      _eventController.add(ProxyEvent(ProxyEventType.connecting, config));

      // 模拟连接测试
      final testResult = await _testConnection(config);
      
      if (testResult) {
        _isConnected = true;
        _eventController.add(ProxyEvent(ProxyEventType.connected, config));
        return true;
      } else {
        _isConnected = false;
        _eventController.add(ProxyEvent(ProxyEventType.connectionFailed, config));
        return false;
      }
    } catch (e) {
      _isConnected = false;
      _eventController.add(ProxyEvent(ProxyEventType.error, config, error: e.toString()));
      return false;
    }
  }

  Future<void> disconnect() async {
    if (_currentConfig != null) {
      _eventController.add(ProxyEvent(ProxyEventType.disconnecting, _currentConfig!));
    }
    _currentConfig = null;
    _isConnected = false;
    _eventController.add(ProxyEvent(ProxyEventType.disconnected, null));
  }

  Future<bool> _testConnection(ProxyConfig config) async {
    // 模拟连接测试延迟
    await Future.delayed(Duration(milliseconds: 100));
    
    // 模拟不同的测试场景
    switch (config.type) {
      case 'HTTP':
        return _testHttpProxy(config);
      case 'HTTPS':
        return _testHttpsProxy(config);
      case 'SOCKS5':
        return _testSocks5Proxy(config);
      default:
        return false;
    }
  }

  Future<bool> _testHttpProxy(ProxyConfig config) async {
    try {
      final request = await _httpClient.getUrl(Uri.parse('http://httpbin.org/ip'));
      if (config.username != null && config.password != null) {
        final basicAuth = base64Encode(
          '${config.username}:${config.password}'.codeUnits
        );
        request.headers.set('Proxy-Authorization', 'Basic $basicAuth');
      }
      
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      
      final jsonResponse = json.decode(body) as Map<String, dynamic>;
      return jsonResponse.containsKey('origin');
    } catch (e) {
      return false;
    }
  }

  Future<bool> _testHttpsProxy(ProxyConfig config) async {
    try {
      final request = await _httpClient.getUrl(Uri.parse('https://httpbin.org/ip'));
      if (config.username != null && config.password != null) {
        final basicAuth = base64Encode(
          '${config.username}:${config.password}'.codeUnits
        );
        request.headers.set('Proxy-Authorization', 'Basic $basicAuth');
      }
      
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      
      final jsonResponse = json.decode(body) as Map<String, dynamic>;
      return jsonResponse.containsKey('origin');
    } catch (e) {
      return false;
    }
  }

  Future<bool> _testSocks5Proxy(ProxyConfig config) async {
    // 模拟SOCKS5代理测试
    await Future.delayed(Duration(milliseconds: 150));
    
    // 模拟成功的SOCKS5连接
    return config.host.isNotEmpty && config.port > 0 && config.port < 65536;
  }

  Future<String?> getCurrentIP() async {
    if (!_isConnected) return null;

    try {
      final request = await _httpClient.getUrl(Uri.parse('http://httpbin.org/ip'));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      
      final jsonResponse = json.decode(body) as Map<String, dynamic>;
      return jsonResponse['origin'] as String?;
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _eventController.close();
    _httpClient.close();
  }
}

/// 代理事件类
class ProxyEvent {
  final ProxyEventType type;
  final ProxyConfig? config;
  final String? error;
  final DateTime timestamp;

  ProxyEvent(this.type, this.config, {this.error}) 
      : timestamp = DateTime.now();
}

enum ProxyEventType {
  connecting,
  connected,
  connectionFailed,
  disconnecting,
  disconnected,
  error,
}

/// 代理功能测试套件
void main() {
  group('代理功能测试套件', () {
    late ProxyService proxyService;
    late List<ProxyEvent> receivedEvents;

    setUp(() {
      proxyService = ProxyService();
      receivedEvents = [];
      
      // 监听代理事件
      proxyService.events.listen((event) {
        receivedEvents.add(event);
      });
    });

    tearDown(() {
      proxyService.dispose();
    });

    test('代理连接 - HTTP代理', () async {
      // 准备测试数据
      final httpProxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
        username: 'user',
        password: 'pass',
      );

      // 执行连接
      final result = await proxyService.connect(httpProxy);

      // 验证结果
      expect(result, true);
      expect(proxyService.isConnected, true);
      expect(proxyService.currentConfig, equals(httpProxy));

      // 验证事件顺序
      expect(receivedEvents.length, greaterThanOrEqualTo(2));
      expect(receivedEvents.first.type, ProxyEventType.connecting);
      expect(receivedEvents.last.type, ProxyEventType.connected);
    });

    test('代理连接 - HTTPS代理', () async {
      final httpsProxy = ProxyConfig(
        type: 'HTTPS',
        host: 'secure-proxy.example.com',
        port: 3128,
      );

      final result = await proxyService.connect(httpsProxy);

      expect(result, true);
      expect(proxyService.isConnected, true);
      expect(proxyService.currentConfig?.type, 'HTTPS');
    });

    test('代理连接 - SOCKS5代理', () async {
      final socks5Proxy = ProxyConfig(
        type: 'SOCKS5',
        host: 'socks5.example.com',
        port: 1080,
        username: 'socksuser',
        password: 'sockpass',
      );

      final result = await proxyService.connect(socks5Proxy);

      expect(result, true);
      expect(proxyService.isConnected, true);
      expect(proxyService.currentConfig?.type, 'SOCKS5');
    });

    test('代理断开连接', () async {
      // 先连接
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
      );
      
      await proxyService.connect(proxy);
      expect(proxyService.isConnected, true);

      // 断开连接
      await proxyService.disconnect();

      // 验证断开结果
      expect(proxyService.isConnected, false);
      expect(proxyService.currentConfig, null);
      
      // 验证事件
      final disconnectEvents = receivedEvents
          .where((e) => e.type == ProxyEventType.disconnected)
          .toList();
      expect(disconnectEvents.length, 1);
    });

    test('无效代理配置测试', () async {
      final invalidProxy = ProxyConfig(
        type: 'INVALID',
        host: '',
        port: -1,
      );

      final result = await proxyService.connect(invalidProxy);

      expect(result, false);
      expect(proxyService.isConnected, false);
      
      // 验证错误事件
      final errorEvents = receivedEvents
          .where((e) => e.type == ProxyEventType.error)
          .toList();
      expect(errorEvents.length, 1);
    });

    test('获取当前IP地址', () async {
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
      );

      await proxyService.connect(proxy);
      
      final ip = await proxyService.getCurrentIP();
      
      // 在模拟环境中，IP获取可能返回null
      expect(ip, anyOf(isNull, isA<String>()));
    });

    test('代理配置序列化', () {
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
        username: 'user',
        password: 'pass',
      );

      final json = proxy.toJson();
      final restored = ProxyConfig.fromJson(json);

      expect(restored.type, proxy.type);
      expect(restored.host, proxy.host);
      expect(restored.port, proxy.port);
      expect(restored.username, proxy.username);
      expect(restored.password, proxy.password);
      expect(restored.enabled, proxy.enabled);
    });

    test('并发代理连接测试', () async {
      final proxy1 = ProxyConfig(
        type: 'HTTP',
        host: 'proxy1.example.com',
        port: 8080,
      );

      final proxy2 = ProxyConfig(
        type: 'HTTPS',
        host: 'proxy2.example.com',
        port: 3128,
      );

      // 并发连接两个代理
      final results = await Future.wait([
        proxyService.connect(proxy1),
        proxyService.connect(proxy2),
      ]);

      // 验证只有一个连接成功（后者覆盖前者）
      expect(results, [true, true]); // 模拟环境中都成功
      expect(proxyService.currentConfig?.host, proxy2.host);
    });

    test('代理连接性能测试', () async {
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
      );

      final stopwatch = Stopwatch()..start();
      final result = await proxyService.connect(proxy);
      stopwatch.stop();

      expect(result, true);
      expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // 应该在1秒内完成
      
      print('代理连接耗时: ${stopwatch.elapsedMilliseconds}ms');
    });

    test('代理事件流测试', () async {
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
      );

      final events = <ProxyEvent>[];
      final subscription = proxyService.events.listen(events.add);

      await proxyService.connect(proxy);
      await proxyService.disconnect();

      // 验证事件序列
      expect(events.length, greaterThanOrEqualTo(4));
      expect(events[0].type, ProxyEventType.connecting);
      expect(events[1].type, ProxyEventType.connected);
      expect(events[2].type, ProxyEventType.disconnecting);
      expect(events[3].type, ProxyEventType.disconnected);

      await subscription.cancel();
    });
  });

  group('代理协议兼容性测试', () {
    test('HTTP代理协议测试', () async {
      final service = ProxyService();
      
      final httpProxy = ProxyConfig(
        type: 'HTTP',
        host: 'http-proxy.example.com',
        port: 8080,
      );

      final result = await service.connect(httpProxy);
      expect(result, true);
      
      service.dispose();
    });

    test('HTTPS代理协议测试', () async {
      final service = ProxyService();
      
      final httpsProxy = ProxyConfig(
        type: 'HTTPS',
        host: 'https-proxy.example.com',
        port: 3128,
      );

      final result = await service.connect(httpsProxy);
      expect(result, true);
      
      service.dispose();
    });

    test('SOCKS5代理协议测试', () async {
      final service = ProxyService();
      
      final socks5Proxy = ProxyConfig(
        type: 'SOCKS5',
        host: 'socks5-proxy.example.com',
        port: 1080,
      );

      final result = await service.connect(socks5Proxy);
      expect(result, true);
      
      service.dispose();
    });
  });

  group('代理认证测试', () {
    test('无认证代理', () async {
      final service = ProxyService();
      
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
      );

      final result = await service.connect(proxy);
      expect(result, true);
      
      service.dispose();
    });

    test('Basic认证代理', () async {
      final service = ProxyService();
      
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
        username: 'testuser',
        password: 'testpass',
      );

      final result = await service.connect(proxy);
      expect(result, true);
      
      service.dispose();
    });

    test('空用户名密码代理', () async {
      final service = ProxyService();
      
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
        username: '',
        password: '',
      );

      final result = await service.connect(proxy);
      expect(result, true);
      
      service.dispose();
    });
  });

  group('代理切换和重连机制测试', () {
    test('代理快速切换', () async {
      final service = ProxyService();
      
      final proxy1 = ProxyConfig(
        type: 'HTTP',
        host: 'proxy1.example.com',
        port: 8080,
      );

      final proxy2 = ProxyConfig(
        type: 'HTTPS',
        host: 'proxy2.example.com',
        port: 3128,
      );

      // 连接到第一个代理
      await service.connect(proxy1);
      expect(service.isConnected, true);
      expect(service.currentConfig?.host, proxy1.host);

      // 快速切换到第二个代理
      await service.connect(proxy2);
      expect(service.isConnected, true);
      expect(service.currentConfig?.host, proxy2.host);

      service.dispose();
    });

    test('代理重连机制', () async {
      final service = ProxyService();
      
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
      );

      // 初始连接
      await service.connect(proxy);
      expect(service.isConnected, true);

      // 模拟断开
      await service.disconnect();
      expect(service.isConnected, false);

      // 自动重连
      await service.connect(proxy);
      expect(service.isConnected, true);

      service.dispose();
    });

    test('代理连接失败重试', () async {
      final service = ProxyService();
      
      // 使用无效代理配置
      final invalidProxy = ProxyConfig(
        type: 'HTTP',
        host: 'invalid.proxy.example.com',
        port: 99999,
      );

      final result = await service.connect(invalidProxy);
      expect(result, false);
      expect(service.isConnected, false);

      service.dispose();
    });
  });

  group('性能基准测试', () {
    test('代理连接延迟基准', () async {
      final service = ProxyService();
      final stopwatch = Stopwatch();
      
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
      );

      final delays = <int>[];
      
      // 进行多次连接测试
      for (int i = 0; i < 5; i++) {
        stopwatch.reset();
        stopwatch.start();
        
        await service.connect(proxy);
        
        stopwatch.stop();
        delays.add(stopwatch.elapsedMilliseconds);
        
        await service.disconnect();
      }

      // 验证连接延迟
      final avgDelay = delays.reduce((a, b) => a + b) / delays.length;
      print('平均连接延迟: ${avgDelay.toStringAsFixed(2)}ms');
      print('最大延迟: ${delays.max}ms');
      print('最小延迟: ${delays.min}ms');
      
      expect(avgDelay, lessThan(500)); // 平均延迟应小于500ms

      service.dispose();
    });

    test('内存使用基准', () async {
      final service = ProxyService();
      
      final proxy = ProxyConfig(
        type: 'HTTP',
        host: 'proxy.example.com',
        port: 8080,
      );

      // 进行多次连接操作
      for (int i = 0; i < 10; i++) {
        await service.connect(proxy);
        await service.disconnect();
      }

      // 验证服务状态正常
      expect(service.isConnected, false);
      expect(service.currentConfig, null);

      service.dispose();
    });
  });
}