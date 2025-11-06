import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:base64/base64.dart' as base64;
import 'package:crypto/crypto.dart';

import 'speed_test_service.dart';

/// 订阅链接服务
class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final Dio _dio = Dio();
  final NodeValidator _validator = NodeValidator();
  final SpeedTestService _speedTestService = SpeedTestService();

  /// 获取订阅链接列表
  Future<List<SubscriptionLink>> getSubscriptions() async {
    try {
      // TODO: 从数据库获取订阅列表
      // 这里返回空列表作为示例，实际应从数据库读取
      return [];
    } catch (e) {
      throw Exception('获取订阅列表失败: $e');
    }
  }

  /// 根据 ID 获取订阅
  Future<SubscriptionLink?> getSubscriptionById(String id) async {
    try {
      final subscriptions = await getSubscriptions();
      return subscriptions.firstWhere((sub) => sub.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 添加订阅
  Future<SubscriptionLink> addSubscription({
    required String name,
    required String url,
    required SubscriptionType type,
    SubscriptionSettings? settings,
  }) async {
    try {
      final subscription = SubscriptionLink(
        id: _generateId(),
        name: name,
        url: url,
        type: type,
        status: SubscriptionStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // TODO: 保存到数据库
      // await _saveSubscriptionToDB(subscription);

      return subscription;
    } catch (e) {
      throw Exception('添加订阅失败: $e');
    }
  }

  /// 更新订阅
  Future<SubscriptionLink> updateSubscription(SubscriptionLink subscription) async {
    try {
      subscription = subscription.copyWith(updatedAt: DateTime.now());
      
      // TODO: 更新数据库中的订阅
      // await _updateSubscriptionInDB(subscription);

      return subscription;
    } catch (e) {
      throw Exception('更新订阅失败: $e');
    }
  }

  /// 删除订阅
  Future<void> deleteSubscription(String subscriptionId) async {
    try {
      // TODO: 从数据库删除订阅及其节点
      // await _deleteSubscriptionFromDB(subscriptionId);
    } catch (e) {
      throw Exception('删除订阅失败: $e');
    }
  }

  /// 更新单个订阅
  Future<UpdateResult> updateSubscriptionById(String subscriptionId, {
    SubscriptionSettings? settings,
  }) async {
    final startTime = DateTime.now();
    
    try {
      final subscription = await getSubscriptionById(subscriptionId);
      if (subscription == null) {
        return UpdateResult(
          success: false,
          subscriptionId: subscriptionId,
          startTime: startTime,
          endTime: DateTime.now(),
          error: '订阅不存在',
        );
      }

      // 更新订阅状态为更新中
      await updateSubscription(subscription.copyWith(
        status: SubscriptionStatus.updating,
      ));

      // 获取订阅内容
      final content = await _fetchSubscriptionContent(subscription.url, settings);
      if (content.isEmpty) {
        throw Exception('订阅内容为空');
      }

      // 解析节点
      final parseResult = await _parseSubscriptionContent(content, subscription.type);
      
      // 验证节点
      final validNodes = <ProxyNode>[];
      for (final node in parseResult.nodes) {
        final validationResult = await _validator.validateNode(node);
        if (validationResult.isValid) {
          validNodes.add(node.copyWith(subscriptionId: subscriptionId));
        }
      }

      // TODO: 保存节点到数据库，替换原有节点
      // await _saveNodesToDB(validNodes);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;

      // 更新订阅状态
      await updateSubscription(subscription.copyWith(
        status: SubscriptionStatus.active,
        lastUpdated: endTime,
        parseStats: ParseStats(
          totalNodes: parseResult.nodes.length,
          validNodes: validNodes.length,
          parseTimeMs: duration,
          lastParsedAt: endTime,
        ),
      ));

      return UpdateResult(
        success: true,
        subscriptionId: subscriptionId,
        addedNodes: validNodes.length,
        updatedNodes: validNodes.length,
        durationMs: duration,
        startTime: startTime,
        endTime: endTime,
      );
    } catch (e) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;

      // 更新订阅状态为错误
      try {
        final subscription = await getSubscriptionById(subscriptionId);
        if (subscription != null) {
          await updateSubscription(subscription.copyWith(
            status: SubscriptionStatus.error,
            errorMessage: e.toString(),
          ));
        }
      } catch (e2) {
        // 忽略状态更新错误
      }

      return UpdateResult(
        success: false,
        subscriptionId: subscriptionId,
        durationMs: duration,
        startTime: startTime,
        endTime: endTime,
        error: e.toString(),
      );
    }
  }

  /// 更新所有订阅
  Future<List<UpdateResult>> updateAllSubscriptions({
    SubscriptionSettings? settings,
    bool concurrent = true,
  }) async {
    try {
      final subscriptions = await getSubscriptions();
      final results = <UpdateResult>[];

      if (concurrent) {
        // 并发更新
        final updateFutures = subscriptions.map((sub) => 
          updateSubscriptionById(sub.id, settings: settings)
        ).toList();
        results.addAll(await Future.wait(updateFutures));
      } else {
        // 串行更新
        for (final sub in subscriptions) {
          final result = await updateSubscriptionById(sub.id, settings: settings);
          results.add(result);
        }
      }

      return results;
    } catch (e) {
      throw Exception('更新所有订阅失败: $e');
    }
  }

  /// 从文件导入订阅
  Future<ImportResult> importSubscriptionsFromFile({
    required String filePath,
    SubscriptionSettings? settings,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('文件不存在');
      }

      final content = await file.readAsString();
      return await importSubscriptionsFromContent(content, settings);
    } catch (e) {
      return ImportResult(
        success: false,
        errors: [e.toString()],
      );
    }
  }

  /// 从内容导入订阅
  Future<ImportResult> importSubscriptionsFromContent({
    required String content,
    SubscriptionSettings? settings,
  }) async {
    try {
      final results = <UpdateResult>[];
      final errors = <String>[];
      final importStats = ImportStats();

      final lines = content.split('\n').map((line) => line.trim()).toList();
      
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.isEmpty || line.startsWith('#')) continue;

        try {
          // 尝试解析为订阅链接
          final subscriptionResult = await _parseSubscriptionLine(line);
          if (subscriptionResult != null) {
            final addResult = await addSubscription(
              name: subscriptionResult['name'],
              url: subscriptionResult['url'],
              type: subscriptionResult['type'],
            );
            
            // 立即更新订阅
            final updateResult = await updateSubscriptionById(addResult.id, settings: settings);
            results.add(updateResult);
            
            if (updateResult.success) {
              importStats.totalImportTimeMs += updateResult.durationMs;
            } else {
              errors.add('订阅 ${addResult.name} 更新失败: ${updateResult.error}');
            }
          }
        } catch (e) {
          errors.add('行 ${i + 1} 解析失败: $e');
        }
      }

      return ImportResult(
        success: errors.isEmpty || results.isNotEmpty,
        importedSubscriptions: results.length,
        totalNodes: results.fold(0, (sum, result) => sum + result.addedNodes),
        validNodes: results.fold(0, (sum, result) => sum + result.addedNodes),
        failedSubscriptions: errors.length,
        errors: errors,
        importStats: importStats,
      );
    } catch (e) {
      return ImportResult(
        success: false,
        errors: [e.toString()],
      );
    }
  }

  /// 解析订阅内容
  Future<_ParseResult> _parseSubscriptionContent(String content, SubscriptionType type) async {
    try {
      final nodes = <ProxyNode>[];
      
      switch (type) {
        case SubscriptionType.clash:
        case SubscriptionType.clashMeta:
          return await _parseClashContent(content);
        case SubscriptionType.v2ray:
          return await _parseV2RayContent(content);
        case SubscriptionType.ss:
          return await _parseSSContent(content);
        case SubscriptionType.trojan:
          return await _parseTrojanContent(content);
        default:
          // 尝试自动检测格式
          return await _parseAutoContent(content);
      }
    } catch (e) {
      throw Exception('解析订阅内容失败: $e');
    }
  }

  /// 解析 Clash 格式
  Future<_ParseResult> _parseClashContent(String content) async {
    final nodes = <ProxyNode>[];
    
    try {
      final jsonData = jsonDecode(content);
      final proxies = jsonData['proxies'] as List<dynamic>;
      
      for (final proxyData in proxies) {
        try {
          final node = _convertClashProxyToNode(proxyData);
          if (node != null) {
            nodes.add(node);
          }
        } catch (e) {
          // 跳过无效的代理配置
          continue;
        }
      }
      
      return _ParseResult(nodes: nodes);
    } catch (e) {
      throw Exception('解析 Clash 配置失败: $e');
    }
  }

  /// 解析 V2Ray 格式
  Future<_ParseResult> _parseV2RayContent(String content) async {
    final nodes = <ProxyNode>[];
    
    try {
      final lines = content.split('\n');
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
        
        try {
          final node = _parseV2RayLine(trimmed);
          if (node != null) {
            nodes.add(node);
          }
        } catch (e) {
          // 跳过无效的行
          continue;
        }
      }
      
      return _ParseResult(nodes: nodes);
    } catch (e) {
      throw Exception('解析 V2Ray 配置失败: $e');
    }
  }

  /// 解析 SS 格式
  Future<_ParseResult> _parseSSContent(String content) async {
    final nodes = <ProxyNode>[];
    
    try {
      final lines = content.split('\n');
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
        
        try {
          final node = _parseSSLine(trimmed);
          if (node != null) {
            nodes.add(node);
          }
        } catch (e) {
          continue;
        }
      }
      
      return _ParseResult(nodes: nodes);
    } catch (e) {
      throw Exception('解析 SS 配置失败: $e');
    }
  }

  /// 解析 Trojan 格式
  Future<_ParseResult> _parseTrojanContent(String content) async {
    final nodes = <ProxyNode>[];
    
    try {
      final lines = content.split('\n');
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
        
        try {
          final node = _parseTrojanLine(trimmed);
          if (node != null) {
            nodes.add(node);
          }
        } catch (e) {
          continue;
        }
      }
      
      return _ParseResult(nodes: nodes);
    } catch (e) {
      throw Exception('解析 Trojan 配置失败: $e');
    }
  }

  /// 自动检测格式
  Future<_ParseResult> _parseAutoContent(String content) async {
    final trimmed = content.trim();
    
    // 检查是否为 JSON 格式
    if (trimmed.startsWith('{')) {
      try {
        final jsonData = jsonDecode(trimmed);
        if (jsonData.containsKey('proxies')) {
          return await _parseClashContent(content);
        }
      } catch (e) {
        // JSON 解析失败，继续尝试其他格式
      }
    }
    
    // 检查是否为 Base64 编码
    if (_isBase64(trimmed)) {
      try {
        final decoded = utf8.decode(base64.Base64.decode(trimmed));
        return await _parseAutoContent(decoded);
      } catch (e) {
        // Base64 解码失败
      }
    }
    
    // 默认尝试 V2Ray 格式
    return await _parseV2RayContent(content);
  }

  /// 获取订阅内容
  Future<String> _fetchSubscriptionContent(String url, SubscriptionSettings? settings) async {
    final dioOptions = BaseOptions(
      connectTimeout: Duration(seconds: settings?.connectTimeoutSeconds ?? 30),
      receiveTimeout: Duration(seconds: settings?.readTimeoutSeconds ?? 60),
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },
    );

    // 如果使用代理
    if (settings?.useProxy == true && settings?.proxyUrl != null) {
      dioOptions.proxy = settings!.proxyUrl!;
    }

    final customDio = Dio(dioOptions);
    
    try {
      final response = await customDio.get(url);
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.statusMessage}');
      }
    } finally {
      customDio.close();
    }
  }

  /// 转换 Clash 代理配置为节点
  ProxyNode? _convertClashProxyToNode(Map<String, dynamic> proxyData) {
    try {
      final type = proxyData['type'] as String;
      final name = proxyData['name'] as String;
      
      switch (type) {
        case 'vmess':
          return _createVMessNodeFromClash(proxyData);
        case 'vless':
          return _createVLessNodeFromClash(proxyData);
        case 'ss':
          return _createSSNodeFromClash(proxyData);
        case 'ssr':
          return _createSSRNodeFromClash(proxyData);
        case 'trojan':
          return _createTrojanNodeFromClash(proxyData);
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// 从 Clash 配置创建 VMess 节点
  ProxyNode _createVMessNodeFromClash(Map<String, dynamic> proxyData) {
    final vmessConfig = VMessConfig(
      uuid: proxyData['uuid'] as String,
      encryption: proxyData['cipher'] as String? ?? 'auto',
      transport: proxyData['network'] as String? ?? 'tcp',
      streamSecurity: proxyData['tls'] == 'tls' ? 'tls' : null,
      path: proxyData['path'] as String?,
      host: proxyData['host'] as String?,
      sni: proxyData['sni'] as String?,
    );

    return ProxyNode(
      id: _generateId(),
      name: proxyData['name'] as String,
      type: ProxyType.vmess,
      version: ProxyVersion.vmess,
      server: proxyData['server'] as String,
      port: int.parse(proxyData['port'].toString()),
      vmessConfig: vmessConfig,
      rawConfig: jsonEncode(proxyData),
    );
  }

  /// 从 Clash 配置创建 VLESS 节点
  ProxyNode _createVLessNodeFromClash(Map<String, dynamic> proxyData) {
    final vlessConfig = VLessConfig(
      uuid: proxyData['uuid'] as String,
      flow: proxyData['flow'] as String? ?? 'xtls-rprx-vision',
      transport: proxyData['network'] as String? ?? 'tcp',
      streamSecurity: proxyData['tls'] == 'tls' ? 'xtls' : null,
      path: proxyData['path'] as String?,
      host: proxyData['host'] as String?,
      sni: proxyData['sni'] as String?,
    );

    return ProxyNode(
      id: _generateId(),
      name: proxyData['name'] as String,
      type: ProxyType.vless,
      version: ProxyVersion.vless,
      server: proxyData['server'] as String,
      port: int.parse(proxyData['port'].toString()),
      vlessConfig: vlessConfig,
      rawConfig: jsonEncode(proxyData),
    );
  }

  /// 从 Clash 配置创建 SS 节点
  ProxyNode _createSSNodeFromClash(Map<String, dynamic> proxyData) {
    final ssConfig = SSConfig(
      password: proxyData['password'] as String,
      method: proxyData['cipher'] as String? ?? 'aes-256-gcm',
      plugin: proxyData['plugin'] as String?,
      pluginOpts: proxyData['plugin-opts'] as Map<String, dynamic>??.toString(),
    );

    return ProxyNode(
      id: _generateId(),
      name: proxyData['name'] as String,
      type: ProxyType.ss,
      version: ProxyVersion.ss,
      server: proxyData['server'] as String,
      port: int.parse(proxyData['port'].toString()),
      ssConfig: ssConfig,
      rawConfig: jsonEncode(proxyData),
    );
  }

  /// 从 Clash 配置创建 SSR 节点
  ProxyNode _createSSRNodeFromClash(Map<String, dynamic> proxyData) {
    // SSR 实现类似 SS，但包含更多配置
    final ssConfig = SSConfig(
      password: proxyData['password'] as String,
      method: proxyData['cipher'] as String? ?? 'aes-128-ctr',
    );

    return ProxyNode(
      id: _generateId(),
      name: proxyData['name'] as String,
      type: ProxyType.ss,
      version: ProxyVersion.ssr,
      server: proxyData['server'] as String,
      port: int.parse(proxyData['port'].toString()),
      ssConfig: ssConfig,
      rawConfig: jsonEncode(proxyData),
    );
  }

  /// 从 Clash 配置创建 Trojan 节点
  ProxyNode _createTrojanNodeFromClash(Map<String, dynamic> proxyData) {
    final trojanConfig = TrojanConfig(
      password: proxyData['password'] as String,
      tlsConfig: proxyData['tls'] == 'tls' ? TLSConfig(
        sni: proxyData['sni'] as String? ?? proxyData['server'] as String,
      ) : null,
    );

    return ProxyNode(
      id: _generateId(),
      name: proxyData['name'] as String,
      type: ProxyType.trojan,
      version: ProxyVersion.trojan,
      server: proxyData['server'] as String,
      port: int.parse(proxyData['port'].toString()),
      trojanConfig: trojanConfig,
      rawConfig: jsonEncode(proxyData),
    );
  }

  /// 解析 V2Ray 行
  ProxyNode? _parseV2RayLine(String line) {
    try {
      if (line.startsWith('vmess://')) {
final decoded = utf8.decode(base64.Base64.decode(line.substring(8));
        final data = jsonDecode(decoded) as Map<String, dynamic>;
        
        return ProxyNode(
          id: _generateId(),
          name: data['ps'] as String? ?? 'VMess Server',
          type: ProxyType.vmess,
          version: ProxyVersion.vmess,
          server: data['add'] as String,
          port: int.parse(data['port'].toString()),
          vmessConfig: VMessConfig(
            uuid: data['id'] as String,
            encryption: data['cipher'] as String? ?? 'auto',
            transport: data['net'] as String? ?? 'tcp',
            streamSecurity: data['tls'] as String?,
            path: data['path'] as String?,
            host: data['host'] as String?,
          ),
          rawConfig: decoded,
        );
      } else if (line.startsWith('vless://')) {
        // VLESS URL 解析
        final uri = Uri.parse(line);
        final queryParams = uri.queryParameters;
        
        return ProxyNode(
          id: _generateId(),
          name: queryParams['remarks'] ?? 'VLESS Server',
          type: ProxyType.vless,
          version: ProxyVersion.vless,
          server: uri.host,
          port: uri.port,
          vlessConfig: VLessConfig(
            uuid: queryParams['id'] ?? '',
            flow: queryParams['flow'] ?? 'xtls-rprx-vision',
            transport: queryParams['type'] ?? 'tcp',
            streamSecurity: queryParams['security'],
            path: queryParams['path'],
            sni: queryParams['sni'],
          ),
          rawConfig: line,
        );
      } else if (line.startsWith('ss://')) {
        return _parseSSLine(line);
      } else if (line.startsWith('trojan://')) {
        return _parseTrojanLine(line);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 解析 SS 行
  ProxyNode? _parseSSLine(String line) {
    try {
      if (line.startsWith('ss://')) {
        final uri = Uri.parse(line);
        
        return ProxyNode(
          id: _generateId(),
          name: uri.fragment.isNotEmpty 
              ? Uri.decodeComponent(uri.fragment) 
              : 'SS Server',
          type: ProxyType.ss,
          version: ProxyVersion.ss,
          server: uri.host,
          port: uri.port,
          ssConfig: SSConfig(
            password: uri.userInfo.split(':').length > 1 
                ? uri.userInfo.split(':')[1] 
                : uri.userInfo,
            method: uri.userInfo.split(':').isNotEmpty 
                ? uri.userInfo.split(':')[0] 
                : 'aes-256-gcm',
          ),
          rawConfig: line,
        );
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 解析 Trojan 行
  ProxyNode? _parseTrojanLine(String line) {
    try {
      if (line.startsWith('trojan://')) {
        final uri = Uri.parse(line);
        final queryParams = uri.queryParameters;
        
        return ProxyNode(
          id: _generateId(),
          name: queryParams['remarks'] ?? 'Trojan Server',
          type: ProxyType.trojan,
          version: ProxyVersion.trojan,
          server: uri.host,
          port: uri.port,
          trojanConfig: TrojanConfig(
            password: uri.userInfo,
            tlsConfig: TLSConfig(
              sni: queryParams['sni'] ?? uri.host,
              alpn: queryParams['alpn']?.split(',') ?? ['http/1.1'],
            ),
          ),
          rawConfig: line,
        );
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 解析订阅行
  Future<Map<String, dynamic>?> _parseSubscriptionLine(String line) async {
    try {
      // 这里可以扩展支持多种订阅格式
      // 例如：订阅链接、配置文件等
      
      // 简单示例：如果是 URL，则返回基本订阅信息
      if (line.startsWith('http://') || line.startsWith('https://')) {
        return {
          'name': '导入的订阅',
          'url': line,
          'type': _detectSubscriptionType(line),
        };
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 检测订阅类型
  SubscriptionType _detectSubscriptionType(String url) {
    if (url.contains('clash')) return SubscriptionType.clash;
    if (url.contains('v2ray') || url.contains('vmess')) return SubscriptionType.v2ray;
    if (url.contains('ss')) return SubscriptionType.ss;
    if (url.contains('trojan')) return SubscriptionType.trojan;
    
    return SubscriptionType.unknown;
  }

  /// 检查是否为 Base64 编码
  bool _isBase64(String str) {
    try {
      base64.Base64.decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 生成 ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           '_' + 
           (DateTime.now().microsecondSinceEpoch % 1000).toString();
  }

  /// 清理资源
  void dispose() {
    _dio.close();
  }
}

/// 解析结果
class _ParseResult {
  final List<ProxyNode> nodes;
  
  _ParseResult({required this.nodes});
}