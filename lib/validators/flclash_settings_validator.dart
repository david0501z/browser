/// FlClash 设置验证器
/// 
/// 用于验证 FlClash 代理设置的完整性和有效性

import '../models/app_settings.dart';

class FlClashSettingsValidator {
  /// 验证 FlClash 设置
  /// 
  /// 返回验证错误列表（如果为空则表示验证通过）
  static List<String> validate(FlClashSettings settings) {
    final errors = <String>[];
    
    // 验证端口设置
    if (settings.ports.httpPort < 1 || settings.ports.httpPort > 65535) {
      errors.add('HTTP端口号必须在 1-65535 范围内');
    }
    
    if (settings.ports.httpsPort < 1 || settings.ports.httpsPort > 65535) {
      errors.add('HTTPS端口号必须在 1-65535 范围内');
    }
    
    if (settings.ports.socksPort < 1 || settings.ports.socksPort > 65535) {
      errors.add('SOCKS端口号必须在 1-65535 范围内');
    }
    
    // 验证端口冲突
    final ports = {
      settings.ports.httpPort,
      settings.ports.httpsPort,
      settings.ports.socksPort,
      settings.ports.mixedPort,
    };
    
    if (ports.length < 4) {
      errors.add('端口号不能重复');
    }
    
    // 验证DNS设置
    if (!_isValidIP(settings.dns.primary)) {
      errors.add('主DNS地址格式无效');
    }
    
    if (!_isValidIP(settings.dns.secondary)) {
      errors.add('备用DNS地址格式无效');
    }
    
    if (settings.dns.doh && !_isValidUrl(settings.dns.dohUrl)) {
      errors.add('DoH URL格式无效');
    }
    
    // 验证节点设置
    if (settings.nodes.nodes.isEmpty && settings.enabled) {
      errors.add('启用代理时至少需要配置一个节点');
    }
    
    return errors;
  }
  
  /// 快速验证（返回布尔值）
  static bool isValid(FlClashSettings settings) {
    return validate(settings).isEmpty;
  }
  
  static bool _isValidIP(String ip) {
    final regex = RegExp(r'^([0-9]{1,3}\.){3}[0-9]{1,3}$');
    return regex.hasMatch(ip);
  }
  
  static bool _isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }
}