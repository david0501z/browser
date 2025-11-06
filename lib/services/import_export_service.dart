import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../models/proxy_node.dart';
import '../models/subscription.dart';
import '../services/proxy_node_manager.dart';
import '../services/subscription_service.dart';
import '../utils/node_validator.dart';

/// 导入导出服务
class ImportExportService {
  static final ImportExportService _instance = ImportExportService._internal();
  factory ImportExportService() => _instance;
  ImportExportService._internal();

  final ProxyNodeManager _nodeManager = ProxyNodeManager();
  final SubscriptionService _subscriptionService = SubscriptionService();
  final NodeValidator _validator = NodeValidator();

  /// 导出节点到文件
  Future<ExportResult> exportNodesToFile({
    required List<ProxyNode> nodes,
    required ExportFormat format,
    required String filePath,
    bool includeMetadata = true,
  }) async {
    try {
      final content = await exportNodesToString(nodes, format, includeMetadata);
      final file = File(filePath);
      await file.writeAsString(content);
      
      return ExportResult(
        success: true,
        exportedCount: nodes.length,
        format: format,
        filePath: filePath,
      );
    } catch (e) {
      return ExportResult(
        success: false,
        error: e.toString(),
        exportedCount: 0,
        format: format,
        filePath: filePath,
      );
    }
  }

  /// 导出节点到字符串
  Future<String> exportNodesToString(
    List<ProxyNode> nodes, 
    ExportFormat format, 
    bool includeMetadata
  ) async {
    switch (format) {
      case ExportFormat.clash:
        return _exportToClash(nodes, includeMetadata);
      case ExportFormat.v2ray:
        return _exportToV2Ray(nodes, includeMetadata);
      case ExportFormat.ss:
        return _exportToSS(nodes, includeMetadata);
      case ExportFormat.base64:
        return _exportToBase64(nodes, includeMetadata);
      case ExportFormat.json:
        return _exportToJSON(nodes, includeMetadata);
      default:
        throw UnsupportedError('不支持的导出格式: $format');
    }
  }

  /// 导出订阅到文件
  Future<ExportResult> exportSubscriptionsToFile({
    required List<SubscriptionLink> subscriptions,
    required ExportFormat format,
    required String filePath,
  }) async {
    try {
      final content = await exportSubscriptionsToString(subscriptions, format);
      final file = File(filePath);
      await file.writeAsString(content);
      
      return ExportResult(
        success: true,
        exportedCount: subscriptions.length,
        format: format,
        filePath: filePath,
      );
    } catch (e) {
      return ExportResult(
        success: false,
        error: e.toString(),
        exportedCount: 0,
        format: format,
        filePath: filePath,
      );
    }
  }

  /// 导出订阅到字符串
  Future<String> exportSubscriptionsToString(
    List<SubscriptionLink> subscriptions, 
    ExportFormat format
  ) async {
    if (format == ExportFormat.base64) {
      return _exportSubscriptionsToBase64(subscriptions);
    } else {
      // 对于其他格式，返回每行一个订阅 URL
      return subscriptions.map((sub) => sub.url).join('\n');
    }
  }

  /// 从文件导入节点
  Future<NodeImportResult> importNodesFromFile({
    required String filePath,
    ExportFormat? format,
    bool validateNodes = true,
    bool skipInvalid = true,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('文件不存在: $filePath');
      }

      final content = await file.readAsString();
      return await importNodesFromContent(
        content: content,
        format: format,
        validateNodes: validateNodes,
        skipInvalid: skipInvalid,
      );
    } catch (e) {
      return NodeImportResult(
        success: false,
        errors: [e.toString()],
      );
    }
  }

  /// 从内容导入节点
  Future<NodeImportResult> importNodesFromContent({
    required String content,
    ExportFormat? format,
    bool validateNodes = true,
    bool skipInvalid = true,
  }) async {
    try {
      ExportFormat detectedFormat = format ?? _detectFormat(content);
      
      List<ProxyNode> nodes;
      switch (detectedFormat) {
        case ExportFormat.clash:
          nodes = await _parseClashNodes(content);
          break;
        case ExportFormat.v2ray:
          nodes = await _parseV2RayNodes(content);
          break;
        case ExportFormat.ss:
          nodes = await _parseSSNodes(content);
          break;
        case ExportFormat.base64:
          nodes = await _parseBase64Nodes(content);
          break;
        case ExportFormat.json:
          nodes = await _parseJSONNodes(content);
          break;
        default:
          throw UnsupportedError('不支持的导入格式');
      }

      final validationResults = validateNodes 
          ? await _validator.batchValidateNodes(nodes)
          : <String, ValidationResult>{};

      final validNodes = <ProxyNode>[];
      final errors = <String>[];

      for (final node in nodes) {
        final validation = validationResults[node.id];
        if (validation != null && !validation.isValid) {
          if (skipInvalid) {
            errors.addAll(validation.errors);
            continue;
          } else {
            errors.addAll(validation.errors);
          }
        }
        validNodes.add(node);
      }

      if (validNodes.isNotEmpty) {
        await _nodeManager.addNodes(validNodes);
      }

      return NodeImportResult(
        success: validNodes.isNotEmpty || !skipInvalid,
        importedNodes: validNodes.length,
        validNodes: validNodes.length,
        invalidNodes: nodes.length - validNodes.length,
        errors: errors,
        nodes: validNodes,
        importStats: NodeImportStats(
          vmessCount: validNodes.where((n) => n.type == ProxyType.vmess).length,
          vlessCount: validNodes.where((n) => n.type == ProxyType.vless).length,
          ssCount: validNodes.where((n) => n.type == ProxyType.ss).length,
          ssrCount: validNodes.where((n) => n.type == ProxyType.ssr).length,
          trojanCount: validNodes.where((n) => n.type == ProxyType.trojan).length,
          parseErrors: errors.length,
        ),
      );
    } catch (e) {
      return NodeImportResult(
        success: false,
        errors: [e.toString()],
      );
    }
  }

  /// 导入订阅链接
  Future<ImportResult> importSubscriptionsFromContent({
    required String content,
    SubscriptionType? type,
    bool validateSubscriptions = true,
  }) async {
    return await _subscriptionService.importSubscriptionsFromContent(
      content: content,
    );
  }

  /// 复制节点配置到剪贴板
  Future<String> copyNodeConfigToClipboard(ProxyNode node, ExportFormat format) async {
    final content = await exportNodesToString([node], format, false);
    // 这里需要使用剪贴板插件，实际实现中会添加相应的依赖
    return content;
  }

  /// 批量复制节点配置
  Future<Map<String, String>> copyNodesConfigToClipboard(
    List<ProxyNode> nodes, 
    ExportFormat format
  ) async {
    final results = <String, String>{};
    
    for (final node in nodes) {
      try {
        final content = await exportNodesToString([node], format, false);
        results[node.id] = content;
      } catch (e) {
        results[node.id] = 'Error: $e';
      }
    }
    
    return results;
  }

  /// 导出为 Clash 配置
  String _exportToClash(List<ProxyNode> nodes, bool includeMetadata) {
    final proxies = nodes.map((node) {
      switch (node.type) {
        case ProxyType.vmess:
          return _convertToClashVMess(node);
        case ProxyType.vless:
          return _convertToClashVLess(node);
        case ProxyType.ss:
          return _convertToClashSS(node);
        case ProxyType.ssr:
          return _convertToClashSSR(node);
        case ProxyType.trojan:
          return _convertToClashTrojan(node);
        default:
          return null;
      }
    }).where((proxy) => proxy != null).toList();

    final config = {
      'proxies': proxies,
      'proxy-groups': [
        {
          'name': 'Proxy',
          'type': 'select',
          'proxies': proxies.map((proxy) => proxy!['name']).toList(),
        },
      ],
      'rules': [
        'DOMAIN-SUFFIX,google.com,Proxy',
        'DOMAIN-KEYWORD,google,Proxy',
        'GEOIP,CN,DIRECT',
        'MATCH,Proxy',
      ],
    };

    return JsonEncoder.withIndent('  ').convert(config);
  }

  /// 导出为 V2Ray 配置
  String _exportToV2Ray(List<ProxyNode> nodes, bool includeMetadata) {
    return nodes.map((node) {
      switch (node.type) {
        case ProxyType.vmess:
          return _convertToV2RayVMess(node);
        case ProxyType.vless:
          return _convertToV2RayVLess(node);
        case ProxyType.ss:
          return _convertToV2RaySS(node);
        case ProxyType.trojan:
          return _convertToV2RayTrojan(node);
        default:
          return '';
      }
    }).join('\n');
  }

  /// 导出为 SS 配置
  String _exportToSS(List<ProxyNode> nodes, bool includeMetadata) {
    return nodes.where((node) => node.type == ProxyType.ss).map((node) {
      final ssConfig = node.ssConfig;
      if (ssConfig == null) return '';
      
      final authInfo = '${ssConfig.method}:${ssConfig.password}';
      final base64Auth = base64Encode(utf8.encode(authInfo));
      final fragment = Uri.encodeComponent(node.name);
      
      return 'ss://$base64Auth@${node.server}:${node.port}#$fragment';
    }).join('\n');
  }

  /// 导出为 Base64 配置
  String _exportToBase64(List<ProxyNode> nodes, bool includeMetadata) {
    final config = nodes.map((node) => node.rawConfig ?? '').join('\n');
    return base64Encode(utf8.encode(config));
  }

  /// 导出为 JSON 配置
  String _exportToJSON(List<ProxyNode> nodes, bool includeMetadata) {
    return JsonEncoder.withIndent('  ').convert(nodes.map((node) => node.toJson()).toList());
  }

  /// 导出订阅为 Base64
  String _exportSubscriptionsToBase64(List<SubscriptionLink> subscriptions) {
    final urls = subscriptions.map((sub) => sub.url).join('\n');
    return base64Encode(utf8.encode(urls));
  }

  /// 转换为 Clash VMess 格式
  Map<String, dynamic> _convertToClashVMess(ProxyNode node) {
    final config = node.vmessConfig;
    return {
      'name': node.name,
      'type': 'vmess',
      'server': node.server,
      'port': node.port,
      'uuid': config?.uuid ?? '',
      'cipher': config?.encryption ?? 'auto',
      'network': config?.transport ?? 'tcp',
      'tls': config?.tls == true ? 'tls' : '',
      'sni': config?.sni,
      'path': config?.path,
      'host': config?.host,
    };
  }

  /// 转换为 Clash VLESS 格式
  Map<String, dynamic> _convertToClashVLess(ProxyNode node) {
    final config = node.vlessConfig;
    return {
      'name': node.name,
      'type': 'vless',
      'server': node.server,
      'port': node.port,
      'uuid': config?.uuid ?? '',
      'flow': config?.flow ?? '',
      'network': config?.transport ?? 'tcp',
      'tls': config?.tls == true ? 'tls' : '',
      'sni': config?.sni,
      'path': config?.path,
    };
  }

  /// 转换为 Clash SS 格式
  Map<String, dynamic> _convertToClashSS(ProxyNode node) {
    final config = node.ssConfig;
    return {
      'name': node.name,
      'type': 'ss',
      'server': node.server,
      'port': node.port,
      'cipher': config?.method ?? 'aes-256-gcm',
      'password': config?.password ?? '',
    };
  }

  /// 转换为 Clash SSR 格式
  Map<String, dynamic> _convertToClashSSR(ProxyNode node) {
    final config = node.ssConfig;
    return {
      'name': node.name,
      'type': 'ssr',
      'server': node.server,
      'port': node.port,
      'cipher': config?.method ?? 'aes-128-ctr',
      'password': config?.password ?? '',
    };
  }

  /// 转换为 Clash Trojan 格式
  Map<String, dynamic> _convertToClashTrojan(ProxyNode node) {
    final config = node.trojanConfig;
    return {
      'name': node.name,
      'type': 'trojan',
      'server': node.server,
      'port': node.port,
      'password': config?.password ?? '',
      'tls': config?.tlsConfig != null ? 'tls' : '',
      'sni': config?.tlsConfig?.sni,
      'alpn': config?.tlsConfig?.alpn.join(','),
    };
  }

  /// 转换为 V2Ray VMess 格式
  String _convertToV2RayVMess(ProxyNode node) {
    final config = node.vmessConfig;
    final vmessData = {
      'v': '2',
      'ps': node.name,
      'add': node.server,
      'port': node.port.toString(),
      'id': config?.uuid ?? '',
      'aid': '0',
      'net': config?.transport ?? 'tcp',
      'type': 'none',
      'host': config?.host ?? '',
      'path': config?.path ?? '',
      'tls': config?.tls == true ? 'tls' : '',
    };
    
    final jsonData = jsonEncode(vmessData);
    final base64Data = base64Encode(utf8.encode(jsonData));
    
    return 'vmess://$base64Data';
  }

  /// 转换为 V2Ray VLESS 格式
  String _convertToV2RayVLess(ProxyNode node) {
    final config = node.vlessConfig;
    final uri = Uri(
      scheme: 'vless',
      userInfo: config?.uuid ?? '',
      host: node.server,
      port: node.port,
      queryParameters: {
        if (config?.flow?.isNotEmpty == true) 'flow': config!.flow,
        'type': config?.transport ?? 'tcp',
        if (config?.streamSecurity != null) 'security': config!.streamSecurity,
        if (config?.path != null) 'path': config!.path,
        if (config?.sni != null) 'sni': config!.sni,
        'remarks': node.name,
      },
    );
    
    return uri.toString();
  }

  /// 转换为 V2Ray SS 格式
  String _convertToV2RaySS(ProxyNode node) {
    final config = node.ssConfig;
    final authInfo = '${config?.method}:${config?.password}';
    final base64Auth = base64Encode(utf8.encode(authInfo));
    final fragment = Uri.encodeComponent(node.name);
    
    return 'ss://$base64Auth@${node.server}:${node.port}#$fragment';
  }

  /// 转换为 V2Ray Trojan 格式
  String _convertToV2RayTrojan(ProxyNode node) {
    final config = node.trojanConfig;
    final uri = Uri(
      scheme: 'trojan',
      userInfo: config?.password ?? '',
      host: node.server,
      port: node.port,
      queryParameters: {
        if (config?.tlsConfig?.sni != null) 'sni': config!.tlsConfig!.sni!,
        if (config?.tlsConfig?.alpn.isNotEmpty == true) 
          'alpn': config!.tlsConfig!.alpn.join(','),
        'remarks': node.name,
      },
    );
    
    return uri.toString();
  }

  /// 解析 Clash 节点
  Future<List<ProxyNode>> _parseClashNodes(String content) async {
    final nodes = <ProxyNode>[];
    
    try {
      final jsonData = jsonDecode(content);
      final proxies = jsonData['proxies'] as List<dynamic>;
      
      for (final proxyData in proxies) {
        try {
          final node = _convertFromClashProxy(proxyData as Map<String, dynamic>);
          if (node != null) {
            nodes.add(node);
          }
        } catch (e) {
          // 跳过无效的代理配置
          continue;
        }
      }
    } catch (e) {
      throw Exception('解析 Clash 配置失败: $e');
    }
    
    return nodes;
  }

  /// 从 Clash 代理转换
  ProxyNode? _convertFromClashProxy(Map<String, dynamic> proxyData) {
    final type = proxyData['type'] as String;
    
    switch (type) {
      case 'vmess':
        return ProxyNode(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: proxyData['name'] as String,
          type: ProxyType.vmess,
          version: ProxyVersion.vmess,
          server: proxyData['server'] as String,
          port: int.parse(proxyData['port'].toString()),
          vmessConfig: VMessConfig(
            uuid: proxyData['uuid'] as String,
            encryption: proxyData['cipher'] as String? ?? 'auto',
            transport: proxyData['network'] as String? ?? 'tcp',
            streamSecurity: proxyData['tls'] == 'tls' ? 'tls' : null,
            path: proxyData['path'] as String?,
            host: proxyData['host'] as String?,
            sni: proxyData['sni'] as String?,
          ),
          rawConfig: jsonEncode(proxyData),
        );
      case 'ss':
        return ProxyNode(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: proxyData['name'] as String,
          type: ProxyType.ss,
          version: ProxyVersion.ss,
          server: proxyData['server'] as String,
          port: int.parse(proxyData['port'].toString()),
          ssConfig: SSConfig(
            password: proxyData['password'] as String,
            method: proxyData['cipher'] as String? ?? 'aes-256-gcm',
          ),
          rawConfig: jsonEncode(proxyData),
        );
      // 可以添加其他类型的解析
      default:
        return null;
    }
  }

  /// 解析 V2Ray 节点
  Future<List<ProxyNode>> _parseV2RayNodes(String content) async {
    final nodes = <ProxyNode>[];
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
    
    return nodes;
  }

  /// 解析单行 V2Ray 配置
  ProxyNode? _parseV2RayLine(String line) {
    if (line.startsWith('vmess://')) {
      return _parseVMessLine(line);
    } else if (line.startsWith('vless://')) {
      return _parseVLessLine(line);
    } else if (line.startsWith('ss://')) {
      return _parseSSLine(line);
    } else if (line.startsWith('trojan://')) {
      return _parseTrojanLine(line);
    }
    return null;
  }

  /// 解析 VMess 行
  ProxyNode _parseVMessLine(String line) {
    final base64Data = line.substring(8);
    final jsonData = utf8.decode(base64Decode(base64Data));
    final data = jsonDecode(jsonData) as Map<String, dynamic>;
    
    return ProxyNode(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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
      rawConfig: line,
    );
  }

  /// 解析 VLESS 行
  ProxyNode _parseVLessLine(String line) {
    final uri = Uri.parse(line);
    final queryParams = uri.queryParameters;
    
    return ProxyNode(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: queryParams['remarks'] ?? 'VLESS Server',
      type: ProxyType.vless,
      version: ProxyVersion.vless,
      server: uri.host,
      port: uri.port,
      vlessConfig: VLessConfig(
        uuid: queryParams['id'] ?? '',
        flow: queryParams['flow'] ?? '',
        transport: queryParams['type'] ?? 'tcp',
        streamSecurity: queryParams['security'],
        path: queryParams['path'],
        sni: queryParams['sni'],
      ),
      rawConfig: line,
    );
  }

  /// 解析 SS 行
  ProxyNode _parseSSLine(String line) {
    final uri = Uri.parse(line);
    
    return ProxyNode(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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

  /// 解析 Trojan 行
  ProxyNode _parseTrojanLine(String line) {
    final uri = Uri.parse(line);
    final queryParams = uri.queryParameters;
    
    return ProxyNode(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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

  /// 解析 SS 节点
  Future<List<ProxyNode>> _parseSSNodes(String content) async {
    final nodes = <ProxyNode>[];
    final lines = content.split('\n');
    
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      
      if (trimmed.startsWith('ss://')) {
        try {
          final node = _parseSSLine(trimmed);
          nodes.add(node);
        } catch (e) {
          continue;
        }
      }
    }
    
    return nodes;
  }

  /// 解析 Base64 节点
  Future<List<ProxyNode>> _parseBase64Nodes(String content) async {
    try {
      final decoded = utf8.decode(base64Decode(content.trim()));
      return await _parseV2RayNodes(decoded);
    } catch (e) {
      throw Exception('Base64 解码失败: $e');
    }
  }

  /// 解析 JSON 节点
  Future<List<ProxyNode>> _parseJSONNodes(String content) async {
    try {
      final nodesData = jsonDecode(content) as List<dynamic>;
      return nodesData.map((data) => ProxyNode.fromJson(data as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('JSON 解析失败: $e');
    }
  }

  /// 检测文件格式
  ExportFormat _detectFormat(String content) {
    final trimmed = content.trim();
    
    // 检查是否为 JSON 格式
    if (trimmed.startsWith('{')) {
      try {
        final jsonData = jsonDecode(trimmed);
        if (jsonData.containsKey('proxies')) {
          return ExportFormat.clash;
        }
        return ExportFormat.json;
      } catch (e) {
        // JSON 解析失败，继续检测其他格式
      }
    }
    
    // 检查是否为 Base64 编码
    if (_isBase64(trimmed)) {
      try {
        final decoded = utf8.decode(base64Decode(trimmed));
        return _detectFormat(decoded);
      } catch (e) {
        // Base64 解码失败
      }
    }
    
    // 检查是否包含 VMess/SS 等 URL
    if (trimmed.contains('vmess://') || trimmed.contains('ss://')) {
      return ExportFormat.v2ray;
    }
    
    return ExportFormat.v2ray; // 默认格式
  }

  /// 检查是否为 Base64 编码
  bool _isBase64(String str) {
    try {
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 生成导出文件备份
  Future<String> generateBackup({
    bool includeNodes = true,
    bool includeSubscriptions = true,
    bool includeSettings = true,
  }) async {
    final backup = <String, dynamic>{
      'version': '1.0',
      'timestamp': DateTime.now().toIso8601String(),
      'nodes': includeNodes ? _nodeManager.allNodes.map((n) => n.toJson()).toList() : [],
      'subscriptions': includeSubscriptions ? await _subscriptionService.getSubscriptions() : [],
      'settings': includeSettings ? {} : {}, // TODO: 添加设置导出
    };
    
    return JsonEncoder.withIndent('  ').convert(backup);
  }

  /// 从备份恢复
  Future<ImportResult> restoreFromBackup(String backupContent) async {
    try {
      final backup = jsonDecode(backupContent) as Map<String, dynamic>;
      
      if (backup.containsKey('nodes')) {
        final nodesData = backup['nodes'] as List<dynamic>;
        final nodes = nodesData.map((data) => 
          ProxyNode.fromJson(data as Map<String, dynamic>)
        ).toList();
        
        await _nodeManager.addNodes(nodes);
      }
      
      // TODO: 恢复订阅和设置
      
      return ImportResult(
        success: true,
        importedSubscriptions: backup.containsKey('subscriptions') 
            ? (backup['subscriptions'] as List).length 
            : 0,
        totalNodes: backup.containsKey('nodes') 
            ? (backup['nodes'] as List).length 
            : 0,
      );
    } catch (e) {
      return ImportResult(
        success: false,
        errors: [e.toString()],
      );
    }
  }
}

/// 导出结果
class ExportResult {
  final bool success;
  final int exportedCount;
  final ExportFormat format;
  final String filePath;
  final String? error;

  ExportResult({
    required this.success,
    required this.exportedCount,
    required this.format,
    required this.filePath,
    this.error,
  });
}