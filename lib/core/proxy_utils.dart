/// 代理工具类
/// 提供各种辅助功能和工具方法

import 'dart:math' as math;
import 'proxy_types.dart';
import 'proxy_config.dart';
import 'traffic_stats.dart';

/// 代理配置工具
class ProxyConfigUtils {
  /// 验证配置
  static List<String> validateConfig(ProxyConfig config) {
    final List<String> errors = [];
    
    // 验证端口
    if (config.port < 1024 || config.port > 65535) {
      errors.add('端口号必须在 1024-65535 范围内');
    }
    
    // 验证IP地址
    if (!_isValidIPAddress(config.listenAddress)) {
      errors.add('监听地址格式无效');
    }
    
    // 验证DNS地址
    if (!_isValidIPAddress(config.primaryDNS)) {
      errors.add('主DNS地址格式无效');
    }
    
    if (!_isValidIPAddress(config.secondaryDNS)) {
      errors.add('辅DNS地址格式无效');
    }
    
    // 验证超时时间
    if (config.connectionTimeout <= 0) {
      errors.add('连接超时必须大于0秒');
    }
    
    if (config.readTimeout <= 0) {
      errors.add('读取超时必须大于0秒');
    }
    
    return errors;
  }
  
  /// 验证IP地址
  static bool _isValidIPAddress(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return false;
    
    for (final part in parts) {
      final number = int.tryParse(part);
      if (number == null || number < 0 || number > 255) {
        return false;
      }
    }
    
    return true;
  }
  
  /// 生成默认配置
  static ProxyConfig generateDefaultConfig() {
    return const ProxyConfig(
      enabled: false,
      mode: 'global',
      port: 7890,
      listenAddress: '127.0.0.1',
      rules: [],
      bypassChina: false,
      bypassLAN: true,
      primaryDNS: '1.1.1.1',
      secondaryDNS: '8.8.8.8',
      dnsOverHttps: false,
      allowInsecure: false,
      enableIPv6: true,
      enableMux: true,
      connectionTimeout: 30,
      readTimeout: 60,
      retryCount: 3,
      enableLog: false,
      logLevel: 'info',
      logPath: '/tmp/proxy.log',
      enableTrafficStats: true,
      enableSpeedTest: true,
      selectedNodeId: '',
      nodes: [],
      customSettings: {},
    );
  }
}

/// 代理规则工具
class ProxyRuleUtils {
  /// 创建域名规则
  static ProxyRule createDomainRule({
    required String name,
    required String domain,
    required ProxyAction action,
    bool enabled = true,
  }) {
    return ProxyRule(
      id: _generateId(),
      name: name,
      type: ProxyRuleType.domain,
      matchType: ProxyMatchType.exact,
      match: domain,
      action: action,
      enabled: enabled,
      priority: 0,
    );
  }
  
  /// 创建IP规则
  static ProxyRule createIPRule({
    required String name,
    required String ip,
    required ProxyAction action,
    bool enabled = true,
  }) {
    return ProxyRule(
      id: _generateId(),
      name: name,
      type: ProxyRuleType.ip,
      matchType: ProxyMatchType.exact,
      match: ip,
      action: action,
      enabled: enabled,
      priority: 0,
    );
  }
  
  /// 创建端口规则
  static ProxyRule createPortRule({
    required String name,
    required String port,
    required ProxyAction action,
    bool enabled = true,
  }) {
    return ProxyRule(
      id: _generateId(),
      name: name,
      type: ProxyRuleType.port,
      matchType: ProxyMatchType.exact,
      match: port,
      action: action,
      enabled: enabled,
      priority: 0,
    );
  }
  
  /// 批量导入规则
  static List<ProxyRule> importRules(List<String> rules) {
    final List<ProxyRule> importedRules = [];
    
    for (final rule in rules) {
      try {
        final parsedRule = _parseRule(rule);
        if (parsedRule != null) {
          importedRules.add(parsedRule);
        }
      } catch (e) {
        // 忽略解析错误的规则
      }
    }
    
    return importedRules;
  }
  
  /// 导出规则
  static List<String> exportRules(List<ProxyRule> rules) {
    return rules.map(_formatRule).toList();
  }
  
  /// 解析规则字符串
  static ProxyRule? _parseRule(String ruleString) {
    final parts = ruleString.split(',');
    if (parts.length < 4) return null;
    
    try {
      return ProxyRule(
        id: _generateId(),
        name: parts[0],
        type: ProxyRuleType.values.firstWhere(
          (type) => type.name == parts[1],
          orElse: () => ProxyRuleType.domain,
        ),
        matchType: ProxyMatchType.values.firstWhere(
          (type) => type.name == parts[2],
          orElse: () => ProxyMatchType.exact,
        ),
        match: parts[3],
        action: ProxyAction.values.firstWhere(
          (action) => action.name == parts[4],
          orElse: () => ProxyAction.proxy,
        ),
        enabled: parts.length > 5 ? parts[5] == 'true' : true,
        priority: parts.length > 6 ? int.parse(parts[6]) : 0,
      );
    } catch (e) {
      return null;
    }
  }
  
  /// 格式化规则
  static String _formatRule(ProxyRule rule) {
    return '${rule.name},${rule.type.name},${rule.matchType.name},${rule.match},${rule.action.name},${rule.enabled},${rule.priority}';
  }
  
  /// 生成唯一ID
  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

/// 节点管理工具
class ProxyNodeUtils {
  /// 创建节点
  static ProxyNode createNode({
    required String name,
    required String server,
    required int port,
    required ProxyNodeType type,
    String protocol = 'http',
    String region = '',
    List<String> tags = const [],
  }) {
    return ProxyNode(
      id: _generateNodeId(),
      name: name,
      type: type,
      server: server,
      port: port,
      protocol: protocol,
      auth: '',
      encryption: '',
      proxyId: '',
      status: NodeStatus.disconnected,
      latency: 0,
      bandwidth: 0,
      region: region,
      tags: tags,
      available: true,
      config: {},
    );
  }
  
  /// 批量导入节点
  static List<ProxyNode> importNodes(List<String> nodes) {
    final List<ProxyNode> importedNodes = [];
    
    for (final nodeString in nodes) {
      try {
        final parsedNode = _parseNode(nodeString);
        if (parsedNode != null) {
          importedNodes.add(parsedNode);
        }
      } catch (e) {
        // 忽略解析错误的节点
      }
    }
    
    return importedNodes;
  }
  
  /// 导出节点
  static List<String> exportNodes(List<ProxyNode> nodes) {
    return nodes.map(_formatNode).toList();
  }
  
  /// 解析节点字符串
  static ProxyNode? _parseNode(String nodeString) {
    final parts = nodeString.split(',');
    if (parts.length < 4) return null;
    
    try {
      return ProxyNode(
        id: parts[0],
        name: parts[1],
        type: ProxyNodeType.values.firstWhere(
          (type) => type.name == parts[2],
          orElse: () => ProxyNodeType.http,
        ),
        server: parts[3],
        port: int.parse(parts[4]),
        protocol: parts.length > 5 ? parts[5] : 'http',
        auth: parts.length > 6 ? parts[6] : '',
        encryption: parts.length > 7 ? parts[7] : '',
        proxyId: parts.length > 8 ? parts[8] : '',
        status: NodeStatus.disconnected,
        latency: 0,
        bandwidth: 0,
        region: parts.length > 9 ? parts[9] : '',
        tags: parts.length > 10 ? parts[10].split(';') : [],
        available: true,
        config: {},
      );
    } catch (e) {
      return null;
    }
  }
  
  /// 格式化节点
  static String _formatNode(ProxyNode node) {
    final tags = node.tags.join(';');
    return '${node.id},${node.name},${node.type.name},${node.server},${node.port},${node.protocol},${node.auth},${node.encryption},${node.proxyId},${node.region},${tags}';
  }
  
  /// 生成节点ID
  static String _generateNodeId() {
    return 'node_${DateTime.now().millisecondsSinceEpoch}';
  }
}

/// 流量统计工具
class ProxyStatsUtils {
  /// 计算平均速度
  static double calculateAverageSpeed(int totalBytes, int timeInSeconds) {
    if (timeInSeconds <= 0) return 0;
    return totalBytes / timeInSeconds;
  }
  
  /// 计算速度等级
  static SpeedLevel calculateSpeedLevel(int speed) {
    if (speed < 100 * 1024) return SpeedLevel.slow; // < 100KB/s
    if (speed < 1024 * 1024) return SpeedLevel.normal; // < 1MB/s
    if (speed < 10 * 1024 * 1024) return SpeedLevel.fast; // < 10MB/s
    return SpeedLevel.veryFast; // >= 10MB/s;
  }
  
  /// 计算连接成功率
  static double calculateSuccessRate(int totalConnections, int failedConnections) {
    if (totalConnections == 0) return 0;
    return ((totalConnections - failedConnections) / totalConnections) * 100;
  }
  
  /// 生成统计报告
  static Map<String, dynamic> generateStatsReport(TrafficStats stats) {
    final uploadBytes = stats.uploadBytes;
    final downloadBytes = stats.downloadBytes;
    final totalBytes = uploadBytes + downloadBytes;
    final averageSpeed = calculateAverageSpeed(totalBytes, stats.connectionTime);
    
    return {
      '总流量': TrafficFormatter.formatBytes(totalBytes),
      '上行流量': TrafficFormatter.formatBytes(uploadBytes),
      '下行流量': TrafficFormatter.formatBytes(downloadBytes),
      '当前速度': TrafficFormatter.formatSpeed(stats.downloadSpeed),
      '平均速度': TrafficFormatter.formatSpeed(averageSpeed),
      '连接时长': TrafficFormatter.formatDuration(stats.connectionTime),
      '连接次数': stats.connectionCount,
      '成功率': '${stats.connectionSuccessRate.toStringAsFixed(1)}%',
      '错误次数': stats.errorCount,
    };
  }
}

/// 速度等级
enum SpeedLevel {
  slow,
  normal,
  fast,
  veryFast,
}

/// 字符串工具
class ProxyStringUtils {
  /// 编码JSON字符串
  static String encodeJson(Map<String, dynamic> data) {
    return jsonEncode(data);
  }
  
  /// 解码JSON字符串
  static Map<String, dynamic> decodeJson(String jsonString) {
    return jsonDecode(jsonString);
  }
  
  /// 验证URL格式
  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// 验证域名格式
  static bool isValidDomain(String domain) {
    final regex = RegExp(r'^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$');
    return regex.hasMatch(domain);
  }
  
  /// 验证端口号
  static bool isValidPort(int port) {
    return port >= 1 && port <= 65535;
  }
  
  /// 验证IP地址
  static bool isValidIP(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return false;
    
    for (final part in parts) {
      final number = int.tryParse(part);
      if (number == null || number < 0 || number > 255) {
        return false;
      }
    }
    
    return true;
  }
  
  /// 生成随机字符串
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = math.Random();
return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length));
  }
  
  /// 截断字符串
  static String truncateString(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}

/// 网络工具
class ProxyNetworkUtils {
  /// 检查网络连接
  static Future<bool> checkNetworkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  /// 解析主机名和端口
  static Map<String, int> parseHostAndPort(String address) {
    final parts = address.split(':');
    if (parts.length != 2) {
      throw FormatException('无效的地址格式');
    }
    
    final host = parts[0];
    final port = int.parse(parts[1]);
    
    if (!ProxyStringUtils.isValidIP(host) && !ProxyStringUtils.isValidDomain(host)) {
      throw FormatException('无效的主机名');
    }
    
    if (!ProxyStringUtils.isValidPort(port)) {
      throw FormatException('无效的端口号');
    }
    
    return {'host': host, 'port': port};
  }
  
  /// 获取本地IP地址
  static Future<String?> getLocalIPAddress() async {
    try {
      final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
      for (final interface in interfaces) {
        for (final address in interface.addresses) {
          if (!address.isLoopback && !address.isLinkLocal) {
            return address.address;
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}