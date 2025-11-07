/// DNS设置类
class DNSSettings {
  /// 是否启用DNS
  final bool enable;
  
  /// 主DNS服务器
  final String primary;
  
  /// 备用DNS服务器
  final String? secondary;
  
  /// DNS监听地址
  final String listen;
  
  /// 代理DNS服务器列表
  final List<String> proxyServers;
  
  /// 直连DNS服务器列表
  final List<String> directServers;
  
  /// 强制域名使用特定DNS
  final Map<String, String> forceDomainDns;
  
  /// 跳过证书验证的域名
  final List<String> skipCertVerifyDomains;
  
  /// IPv6 DNS
  final String? ipv6;
  
  /// 本地DNS优先级
  final bool preferH3;

  const DNSSettings({
    this.enable = true,
    this.primary = '223.5.5.5',
    this.secondary,
    this.listen = '127.0.0.1',
    this.proxyServers = const ['8.8.8.8', '8.8.4.4'],
    this.directServers = const ['223.5.5.5', '114.114.114.114'],
    this.forceDomainDns = const {},
    this.skipCertVerifyDomains = const [],
    this.ipv6,
    this.preferH3 = false,
  });

  /// 验证DNS服务器地址格式
  static bool isValidDnsServer(String dns) {
    final ipv4RegExp = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    final domainRegExp = RegExp(r'^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$');
    return ipv4RegExp.hasMatch(dns) || domainRegExp.hasMatch(dns);
  }

  /// 获取所有DNS服务器列表
  List<String> get allServers {
    final servers = <String>{};
    servers.add(primary);
    if (secondary != null) servers.add(secondary!);
    servers.addAll(proxyServers);
    servers.addAll(directServers);
    return servers.toList();
  }

  /// 从JSON创建
  factory DNSSettings.fromJson(Map<String, dynamic> json) {
    return DNSSettings(
      enable: json['enable'] ?? true,
      primary: json['primary'] ?? '223.5.5.5',
      secondary: json['secondary'],
      listen: json['listen'] ?? '127.0.0.1',
      proxyServers: json['proxyServers'] != null 
          ? List<String>.from(json['proxyServers']) 
          : const ['8.8.8.8', '8.8.4.4'],
      directServers: json['directServers'] != null 
          ? List<String>.from(json['directServers']) 
          : const ['223.5.5.5', '114.114.114.114'],
      forceDomainDns: json['forceDomainDns'] != null 
          ? Map<String, String>.from(json['forceDomainDns']) 
          : const {},
      skipCertVerifyDomains: json['skipCertVerifyDomains'] != null 
          ? List<String>.from(json['skipCertVerifyDomains']) 
          : const [],
      ipv6: json['ipv6'],
      preferH3: json['preferH3'] ?? false,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'enable': enable,
      'primary': primary,
      'secondary': secondary,
      'listen': listen,
      'proxyServers': proxyServers,
      'directServers': directServers,
      'forceDomainDns': forceDomainDns,
      'skipCertVerifyDomains': skipCertVerifyDomains,
      'ipv6': ipv6,
      'preferH3': preferH3,
    };
  }

  /// 复制并修改
  DNSSettings copyWith({
    bool? enable,
    String? primary,
    String? secondary,
    String? listen,
    List<String>? proxyServers,
    List<String>? directServers,
    Map<String, String>? forceDomainDns,
    List<String>? skipCertVerifyDomains,
    String? ipv6,
    bool? preferH3,
  }) {
    return DNSSettings(
      enable: enable ?? this.enable,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      listen: listen ?? this.listen,
      proxyServers: proxyServers ?? this.proxyServers,
      directServers: directServers ?? this.directServers,
      forceDomainDns: forceDomainDns ?? this.forceDomainDns,
      skipCertVerifyDomains: skipCertVerifyDomains ?? this.skipCertVerifyDomains,
      ipv6: ipv6 ?? this.ipv6,
      preferH3: preferH3 ?? this.preferH3,
    );
  }

  @override
  String toString() {
    return 'DNSSettings{enable: $enable, primary: $primary, secondary: $secondary, listen: $listen}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DNSSettings &&
        other.enable == enable &&
        other.primary == primary &&
        other.secondary == secondary &&
        other.listen == listen &&
        other.proxyServers == proxyServers &&
        other.directServers == directServers &&
        other.forceDomainDns == forceDomainDns &&
        other.skipCertVerifyDomains == skipCertVerifyDomains &&
        other.ipv6 == ipv6 &&
        other.preferH3 == preferH3;
  }

  @override
  int get hashCode {
    return enable.hashCode ^
        primary.hashCode ^
        (secondary?.hashCode ?? 0) ^
        listen.hashCode ^
        proxyServers.hashCode ^
        directServers.hashCode ^
        forceDomainDns.hashCode ^
        skipCertVerifyDomains.hashCode ^
        (ipv6?.hashCode ?? 0) ^
        preferH3.hashCode;
  }
}