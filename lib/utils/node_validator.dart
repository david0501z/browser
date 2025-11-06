import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:ip/ip.dart' as ip;

/// 节点验证器
class NodeValidator {
  static final NodeValidator _instance = NodeValidator._internal();
  factory NodeValidator() => _instance;
  NodeValidator._internal();

  final Dio _dio = Dio();
  
  /// 验证节点
  Future<ValidationResult> validateNode(ProxyNode node) async {
    final errors = <String>[];
    final warnings = <String>[];

    try {
      // 基础验证
      _validateBasicInfo(node, errors, warnings);
      
      // 协议特定验证
      switch (node.type) {
        case ProxyType.vmess:
          _validateVMessConfig(node, errors, warnings);
          break;
        case ProxyType.vless:
          _validateVLessConfig(node, errors, warnings);
          break;
        case ProxyType.ss:
          _validateSSConfig(node, errors, warnings);
          break;
        case ProxyType.trojan:
          _validateTrojanConfig(node, errors, warnings);
          break;
        case ProxyType.socks5:
        case ProxyType.http:
          _validateSimpleProxyConfig(node, errors, warnings);
          break;
        default:
          warnings.add('未知的代理类型: ${node.type}');
          break;
      }

      // 网络连接验证
      await _validateNetworkConnectivity(node, errors, warnings);

      // 安全验证
      _validateSecurity(node, errors, warnings);

      return ValidationResult(
        isValid: errors.isEmpty,
        errors: errors,
        warnings: warnings,
      );
    } catch (e) {
      return ValidationResult(
        isValid: false,
        errors: [...errors, '验证过程出错: $e'],
        warnings: warnings,
      );
    }
  }

  /// 批量验证节点
  Future<Map<String, ValidationResult>> batchValidateNodes(
    List<ProxyNode> nodes, {
    int concurrency = 10,
  }) async {
    final results = <String, ValidationResult>{};
    final futures = <Future<void>>[];

    // 分批并发验证
    for (var i = 0; i < nodes.length; i += concurrency) {
      final batch = nodes.sublist(
        i, 
        (i + concurrency).clamp(0, nodes.length)
      );

      for (final node in batch) {
        futures.add(
          validateNode(node).then((result) {
            results[node.id] = result;
          }).catchError((e) {
            results[node.id] = ValidationResult(
              isValid: false,
              errors: [e.toString()],
              warnings: [],
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

  /// 验证节点配置字符串
  ValidationResult validateNodeConfig(String configString) {
    final errors = <String>[];
    final warnings = <String>[];

    try {
      // 尝试解析配置
      ProxyNode? node;
      
      if (configString.startsWith('vmess://')) {
        node = _parseVMessConfig(configString, errors, warnings);
      } else if (configString.startsWith('vless://')) {
        node = _parseVLessConfig(configString, errors, warnings);
      } else if (configString.startsWith('ss://')) {
        node = _parseSSConfig(configString, errors, warnings);
      } else if (configString.startsWith('trojan://')) {
        node = _parseTrojanConfig(configString, errors, warnings);
      } else if (configString.startsWith('{')) {
        // 可能是 JSON 格式的 Clash 配置
        node = _parseClashConfig(configString, errors, warnings);
      } else {
        errors.add('不支持的配置格式');
      }

      if (node != null) {
        // 对解析出的节点进行验证
        // 这里简化处理，实际可能需要重新调用 validateNode
        warnings.add('配置解析成功，但建议使用完整验证功能');
      }

      return ValidationResult(
        isValid: errors.isEmpty && node != null,
        errors: errors,
        warnings: warnings,
      );
    } catch (e) {
      return ValidationResult(
        isValid: false,
        errors: [...errors, '配置解析失败: $e'],
        warnings: warnings,
      );
    }
  }

  /// 验证服务器地址
  bool validateServerAddress(String server) {
    try {
      // 检查是否为有效的 IP 地址
      if (ip.IPv4.isValid(server) || ip.IPv6.isValid(server)) {
        return true;
      }
      
      // 检查是否为有效的域名
      final domainRegex = RegExp(
        r'^(?=.{1,253}$)(?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.(?=.{1,63}$)[a-zA-Z0-9-]{1,63}(?<!-)\.(?=.{1,63}$)[a-zA-Z0-9-]{1,63}$'
      );
      
      if (domainRegex.hasMatch(server)) {
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 验证端口号
  bool validatePort(int port) {
    return port >= 1 && port <= 65535;
  }

  /// 验证 UUID 格式
  bool validateUUID(String uuid) {
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidRegex.hasMatch(uuid);
  }

  /// 验证密码强度
  ValidationResult validatePasswordStrength(String password) {
    final errors = <String>[];
    final warnings = <String>[];

    if (password.isEmpty) {
      errors.add('密码不能为空');
      return ValidationResult(isValid: false, errors: errors, warnings: warnings);
    }

    if (password.length < 6) {
      errors.add('密码长度至少 6 个字符');
    } else if (password.length < 8) {
      warnings.add('建议使用至少 8 个字符的密码');
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      warnings.add('建议包含大写字母');
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      warnings.add('建议包含小写字母');
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      warnings.add('建议包含数字');
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      warnings.add('建议包含特殊字符');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// 验证传输配置
  ValidationResult validateTransportConfig(String transport, {String? streamSecurity}) {
    final errors = <String>[];
    final warnings = <String>[];

    final validTransports = ['tcp', 'ws', 'h2', 'grpc', 'quic'];
    if (!validTransports.contains(transport)) {
      errors.add('不支持的传输协议: $transport');
    }

    if (streamSecurity != null) {
      final validSecurity = ['tls', 'xtls', 'reality'];
      if (!validSecurity.contains(streamSecurity)) {
        errors.add('不支持的安全协议: $streamSecurity');
      }
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// 基础信息验证
  void _validateBasicInfo(ProxyNode node, List<String> errors, List<String> warnings) {
    // 验证名称
    if (node.name.trim().isEmpty) {
      errors.add('节点名称不能为空');
    }

    // 验证服务器地址
    if (!validateServerAddress(node.server)) {
      errors.add('无效的服务器地址: ${node.server}');
    }

    // 验证端口
    if (!validatePort(node.port)) {
      errors.add('无效的端口号: ${node.port}');
    }

    // 检查端口是否为常用端口
    if ([21, 22, 23, 25, 53, 80, 110, 443, 993, 995].contains(node.port)) {
      warnings.add('端口 ${node.port} 可能存在安全风险');
    }

    // 检查服务器地址是否为私有 IP
    if (_isPrivateIP(node.server)) {
      warnings.add('使用私有 IP 地址可能无法从外网访问');
    }

    // 检查是否为知名服务器提供商
    if (_isWellKnownServer(node.server)) {
      warnings.add('节点使用知名服务器可能被重点关注');
    }
  }

  /// VMess 配置验证
  void _validateVMessConfig(ProxyNode node, List<String> errors, List<String> warnings) {
    final config = node.vmessConfig;
    if (config == null) {
      errors.add('VMess 节点缺少配置信息');
      return;
    }

    // 验证 UUID
    if (!validateUUID(config.uuid)) {
      errors.add('无效的 UUID 格式');
    }

    // 验证加密方式
    final validEncryption = ['auto', 'none', 'aes-128-gcm', 'aes-192-gcm', 'aes-256-gcm'];
    if (!validEncryption.contains(config.encryption)) {
      warnings.add('不常用的加密方式: ${config.encryption}');
    }

    // 验证传输协议
    final transportValidation = validateTransportConfig(config.transport, streamSecurity: config.streamSecurity);
    errors.addAll(transportValidation.errors);
    warnings.addAll(transportValidation.warnings);

    // 验证 TLS 配置
    if (config.tls == true) {
      if (config.sni == null || config.sni!.trim().isEmpty) {
        warnings.add('TLS 连接建议设置 SNI');
      }
    }
  }

  /// VLESS 配置验证
  void _validateVLessConfig(ProxyNode node, List<String> errors, List<String> warnings) {
    final config = node.vlessConfig;
    if (config == null) {
      errors.add('VLESS 节点缺少配置信息');
      return;
    }

    // 验证 UUID
    if (!validateUUID(config.uuid)) {
      errors.add('无效的 UUID 格式');
    }

    // 验证流控
    final validFlows = ['', 'xtls-rprx-vision', 'xtls-rprx-splice'];
    if (!validFlows.contains(config.flow)) {
      warnings.add('不常用的流控类型: ${config.flow}');
    }

    // 验证传输协议
    final transportValidation = validateTransportConfig(config.transport, streamSecurity: config.streamSecurity);
    errors.addAll(transportValidation.errors);
    warnings.addAll(transportValidation.warnings);

    // 验证 TLS 配置
    if (config.tls == true && config.tlsType == 'xtls') {
      if (config.sni == null || config.sni!.trim().isEmpty) {
        warnings.add('XTLS 连接建议设置 SNI');
      }
    }
  }

  /// SS 配置验证
  void _validateSSConfig(ProxyNode node, List<String> errors, List<String> warnings) {
    final config = node.ssConfig;
    if (config == null) {
      errors.add('SS 节点缺少配置信息');
      return;
    }

    // 验证密码
    if (config.password.trim().isEmpty) {
      errors.add('密码不能为空');
    }

    // 验证加密方法
    final validMethods = [
      'aes-128-gcm', 'aes-192-gcm', 'aes-256-gcm',
      'aes-128-ctr', 'aes-192-ctr', 'aes-256-ctr',
      'rc4-md5', 'salsa20', 'chacha20', 'chacha20-ietf'
    ];
    if (!validMethods.contains(config.method)) {
      warnings.add('不常用的加密方法: ${config.method}');
    }

    // 验证插件
    if (config.plugin != null && config.plugin!.trim().isNotEmpty) {
      final validPlugins = ['obfs', 'obfs-local'];
      if (!validPlugins.contains(config.plugin)) {
        warnings.add('不常用的插件: ${config.plugin}');
      }
    }
  }

  /// Trojan 配置验证
  void _validateTrojanConfig(ProxyNode node, List<String> errors, List<String> warnings) {
    final config = node.trojanConfig;
    if (config == null) {
      errors.add('Trojan 节点缺少配置信息');
      return;
    }

    // 验证密码
    if (config.password.trim().isEmpty) {
      errors.add('密码不能为空');
    }

    // 验证 TLS 配置
    if (config.tlsConfig != null) {
      final tlsConfig = config.tlsConfig!;
      if (tlsConfig.sni.trim().isEmpty) {
        errors.add('TLS 配置缺少 SNI');
      }
    }
  }

  /// 简单代理配置验证
  void _validateSimpleProxyConfig(ProxyNode node, List<String> errors, List<String> warnings) {
    // 验证认证信息
    if (node.auth != null && node.auth!.trim().isNotEmpty) {
      final parts = node.auth!.split(':');
      if (parts.length != 2) {
        warnings.add('SOCKS5 代理认证信息格式错误');
      }
    }

    // 检查常见代理端口
    if (node.port == 1080 || node.port == 3128) {
      warnings.add('使用常见代理端口可能被检测');
    }
  }

  /// 网络连接性验证
  Future<void> _validateNetworkConnectivity(
    ProxyNode node, 
    List<String> errors, 
    List<String> warnings
  ) async {
    try {
      // 测试 DNS 解析
      if (validateServerAddress(node.server)) {
        try {
          final addresses = await InternetAddress.lookup(node.server);
          if (addresses.isEmpty) {
            errors.add('无法解析服务器地址');
          }
        } catch (e) {
          errors.add('DNS 解析失败: $e');
        }
      }

      // 测试端口连接
      final socket = await Socket.connect(node.server, node.port, timeout: Duration(seconds: 5));
      socket.destroy();
    } catch (e) {
      errors.add('网络连接测试失败: $e');
    }
  }

  /// 安全验证
  void _validateSecurity(ProxyNode node, List<String> errors, List<String> warnings) {
    // 检查是否使用了知名代理服务
    if (_isWellKnownProxyService(node.server)) {
      warnings.add('使用知名代理服务可能存在风险');
    }

    // 检查节点名称是否包含敏感信息
    final sensitiveKeywords = ['中国', '国内', '直连', '高速'];
    final nameLower = node.name.toLowerCase();
    if (sensitiveKeywords.any((keyword) => nameLower.contains(keyword))) {
      warnings.add('节点名称可能包含误导信息');
    }

    // 检查是否为住宅 IP
    if (_isResidentialIP(node.server)) {
      warnings.add('使用住宅 IP 可能存在风险');
    }
  }

  /// 解析 VMess 配置字符串
  ProxyNode? _parseVMessConfig(String config, List<String> errors, List<String> warnings) {
    try {
      final base64Data = config.substring(8);
      final jsonData = utf8.decode(base64Decode(base64Data));
      final data = jsonDecode(jsonData) as Map<String, dynamic>;
      
      return ProxyNode(
        id: '',
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
        rawConfig: config,
      );
    } catch (e) {
      errors.add('VMess 配置解析失败: $e');
      return null;
    }
  }

  /// 解析 VLESS 配置字符串
  ProxyNode? _parseVLessConfig(String config, List<String> errors, List<String> warnings) {
    try {
      final uri = Uri.parse(config);
      final queryParams = uri.queryParameters;
      
      return ProxyNode(
        id: '',
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
        rawConfig: config,
      );
    } catch (e) {
      errors.add('VLESS 配置解析失败: $e');
      return null;
    }
  }

  /// 解析 SS 配置字符串
  ProxyNode? _parseSSConfig(String config, List<String> errors, List<String> warnings) {
    try {
      final uri = Uri.parse(config);
      
      return ProxyNode(
        id: '',
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
        rawConfig: config,
      );
    } catch (e) {
      errors.add('SS 配置解析失败: $e');
      return null;
    }
  }

  /// 解析 Trojan 配置字符串
  ProxyNode? _parseTrojanConfig(String config, List<String> errors, List<String> warnings) {
    try {
      final uri = Uri.parse(config);
      final queryParams = uri.queryParameters;
      
      return ProxyNode(
        id: '',
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
        rawConfig: config,
      );
    } catch (e) {
      errors.add('Trojan 配置解析失败: $e');
      return null;
    }
  }

  /// 解析 Clash 配置字符串
  ProxyNode? _parseClashConfig(String config, List<String> errors, List<String> warnings) {
    try {
      final jsonData = jsonDecode(config);
      final proxies = jsonData['proxies'] as List<dynamic>;
      
      if (proxies.isNotEmpty) {
        final proxyData = proxies.first as Map<String, dynamic>;
        final type = proxyData['type'] as String;
        
        // 这里只返回第一个代理作为示例
        switch (type) {
          case 'vmess':
            return _parseVMessFromClash(proxyData, errors, warnings);
          // 可以添加其他类型的解析
          default:
            warnings.add('不支持的 Clash 代理类型: $type');
            return null;
        }
      }
      
      return null;
    } catch (e) {
      errors.add('Clash 配置解析失败: $e');
      return null;
    }
  }

  /// 从 Clash 数据解析 VMess
  ProxyNode? _parseVMessFromClash(Map<String, dynamic> proxyData, List<String> errors, List<String> warnings) {
    try {
      return ProxyNode(
        id: '',
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
        ),
        rawConfig: jsonEncode(proxyData),
      );
    } catch (e) {
      errors.add('从 Clash 数据解析 VMess 失败: $e');
      return null;
    }
  }

  /// 检查是否为私有 IP
  bool _isPrivateIP(String ip) {
    try {
      final address = InternetAddress(ip);
      if (address.type == InternetAddressType.IPv4) {
        final parts = ip.split('.').map(int.parse).toList();
        if (parts[0] == 10) return true;
        if (parts[0] == 172 && parts[1] >= 16 && parts[1] <= 31) return true;
        if (parts[0] == 192 && parts[1] == 168) return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 检查是否为知名服务器
  bool _isWellKnownServer(String server) {
    final knownServers = [
      'amazonaws.com', 'cloudflare.com', 'google.com', 'microsoft.com',
      'github.com', 'stackoverflow.com', 'reddit.com'
    ];
    
    return knownServers.any((domain) => server.contains(domain));
  }

  /// 检查是否为知名代理服务
  bool _isWellKnownProxyService(String server) {
    final knownProxyServices = [
      'expressvpn', 'nordvpn', 'surfshark', 'cyberGhost',
      'protonvpn', 'pia', 'ivacy'
    ];
    
    return knownProxyServices.any((service) => 
      server.toLowerCase().contains(service)
    );
  }

  /// 检查是否为住宅 IP
  bool _isResidentialIP(String server) {
    // 这是一个简化的检查，实际应用中可能需要使用 IP 数据库
    // 住宅 IP 通常不是常见的云服务提供商 IP
    final cloudProviders = [
      'amazonaws.com', 'googleusercontent.com', 'azure.com',
      'digitalocean.com', 'linode.com', 'vultr.com'
    ];
    
    return !cloudProviders.any((provider) => server.contains(provider));
  }

  /// 清理资源
  void dispose() {
    _dio.close();
  }
}

/// 验证结果
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  ValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
  });

  /// 获取验证摘要
  String get summary {
    if (isValid) {
      return '验证通过';
    } else {
      return '验证失败: ${errors.join(', ')}';
    }
  }

  /// 获取警告计数
  int get warningCount => warnings.length;

  /// 获取错误计数
  int get errorCount => errors.length;
}