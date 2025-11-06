import 'package:freezed_annotation/freezed_annotation.dart';

part 'dns_settings.freezed.dart';
part 'dns_settings.g.dart';

/// DNS设置模型
@freezed
class DNSConfiguration with _$DNSConfiguration {
  /// 创建一个DNS设置实例
  const factory DNSConfiguration({
    /// 是否启用DNS配置
    @Default(false) bool enable,
    
    /// DNS服务器列表
    @Default([]) List<String> servers,
    
    /// DNS备用服务器列表
    @Default([]) List<String> fallback,
    
    /// DNS策略（整数参数）
    @Default(0) int strategy,
    
    /// 自定义DNS端口
    @Default(53) int port,
    
    /// 是否启用IPv6 DNS
    @Default(false) bool enableIPv6,
    
    /// 是否启用缓存
    @Default(true) bool enableCache,
    
    /// DNS缓存过期时间(秒)
    @Default(300) int cacheTimeout,
  }) = _DNSConfiguration;

  /// 从JSON创建DNSConfiguration实例
  factory DNSConfiguration.fromJson(Map<String, dynamic> json) =>
      _$DNSConfigurationFromJson(json);
}

/// DNS设置扩展方法
extension DNSConfigurationExt on DNSConfiguration {
  /// 检查DNS配置是否有效
  bool get isValid {
    if (!enable) return true;
    
    // 检查服务器列表不为空
    if (servers.isEmpty && fallback.isEmpty) return false;
    
    // 检查端口号是否有效
    if (port < 1 || port > 65535) return false;
    
    // 检查缓存超时时间是否有效
    if (cacheTimeout < 1) return false;
    
    return true;
  }
  
  /// 获取默认DNS服务器
  List<String> get defaultServers {
    switch (strategy) {
      case 1: // custom
        return servers.isNotEmpty ? servers : ['8.8.8.8', '8.8.4.4'];
      case 2: // doh
        return ['https://dns.cloudflare.com/dns-query'];
      case 3: // dot
        return ['tls://1.1.1.1:853'];
      default: // system
        return ['8.8.8.8', '1.1.1.1'];
    }
  }
  
  /// 是否使用自定义DNS
  bool get customDNS {
    return strategy == 1 && servers.isNotEmpty;
  }
  
  /// 获取DNS服务器列表
  List<String> get dnsServers {
    if (servers.isNotEmpty) {
      return servers;
    }
    return defaultServers;
  }
  
  /// 获取DOH服务器URL
  String get dohServer {
    if (strategy == 2) { // doh
      return 'https://dns.cloudflare.com/dns-query';
    }
    return '';
  }
  
  /// 获取DNS over HTTPS URL
  String get dnsOverHttps {
    if (strategy == 2) { // doh
      return 'https://dns.cloudflare.com/dns-query';
    }
    return '';
  }

  /// 转换为YAML格式配置
  Map<String, dynamic> toYamlConfig() {
    if (!enable) return {};
    
    return {
      'enable': true,
      'servers': servers,
      'fallback': fallback,
      'strategy': strategy,
      'port': port,
      'enable-ipv6': enableIPv6,
      'cache': {
        'enable': enableCache,
        'timeout': cacheTimeout,
      }
    };
  }
}