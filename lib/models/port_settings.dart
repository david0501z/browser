/// 端口设置数据模型
/// 
/// 该模型定义了代理服务中各种端口的配置选项，包括SOCKS端口、HTTP端口、API端口等。
/// 使用freezed实现不可变数据类，支持JSON序列化。
library port_settings;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'port_settings.freezed.dart';
part 'port_settings.g.dart';

/// 端口设置模型
/// 
/// 包含代理服务中各种端口的配置信息，用于控制不同协议的监听端口。
@freezed
abstract class PortConfiguration with _$PortConfiguration {
  const factory PortConfiguration({
    /// SOCKS代理端口
    /// 
    /// 用于SOCKS协议代理服务的监听端口，默认为1080
    @Default(1080) int socksPort,
    
    /// HTTP代理端口
    /// 
    /// 用于HTTP协议代理服务的监听端口，默认为8080
    @Default(8080) int httpPort,
    
    /// API服务端口
    /// 
    /// 用于内部API服务的监听端口，默认为9090
    @Default(9090) int apiPort,
    
    /// 是否启用重定向
    /// 
    /// 控制是否启用流量重定向功能，默认为false
    @Default(false) bool enableRedirect,
  }) = _PortConfiguration;
  
  /// 从JSON创建PortConfiguration实例
  factory PortConfiguration.fromJson(Map<String, Object?> json) =>
      _$PortConfigurationFromJson(json);
}

/// PortConfiguration扩展方法
/// 
/// 为PortConfiguration模型提供额外的功能方法。
extension PortConfigurationExt on PortConfiguration {
  /// 获取所有端口的列表
  List<int> get allPorts => [;
    socksPort,
    httpPort,
    apiPort,
  ];
  
  /// 检查端口是否有效
  /// 
  /// 验证端口号是否在有效范围内(1-65535)
  bool isValidPort(int port) {
    return port >= 1 && port <= 65535;
  }
  
  /// 验证所有端口配置
  /// 
  /// 返回端口配置中的错误信息列表
  List<String> validatePorts() {
    final errors = <String>[];
    
    // 验证SOCKS端口
    if (!isValidPort(socksPort)) {
      errors.add('SOCKS端口($socksPort)无效，应在1-65535范围内');
    }
    
    // 验证HTTP端口
    if (!isValidPort(httpPort)) {
      errors.add('HTTP端口($httpPort)无效，应在1-65535范围内');
    }
    
    // 验证API端口
    if (!isValidPort(apiPort)) {
      errors.add('API端口($apiPort)无效，应在1-65535范围内');
    }
    
    // 检查端口冲突
    if (socksPort == httpPort) {
      errors.add('SOCKS端口和HTTP端口不能相同');
    }
    if (socksPort == apiPort) {
      errors.add('SOCKS端口和API端口不能相同');
    }
    if (httpPort == apiPort) {
      errors.add('HTTP端口和API端口不能相同');
    }
    
    return errors;
  }
  
  /// 检查是否启用了重定向模式
  /// 
  /// 当启用重定向时，返回相应的描述文本
  String get redirectStatusText {
    return enableRedirect ? '已启用' : '未启用';
  }
  
  /// 获取混合端口配置
  /// 
  /// 返回混合代理端口号，使用HTTP端口作为默认混合端口
  int get mixedPort => httpPort;
  
  /// 获取端口配置摘要
  /// 
  /// 返回端口配置的简要描述信息
  String get portSummary {
    return 'SOCKS:$socksPort, HTTP:$httpPort, API:$apiPort';
  }
}

/// PortConfiguration工具方法
/// 
/// 提供PortConfiguration相关的工具函数。
class PortConfigurationUtils {
  /// 创建默认端口设置
  static PortConfiguration createDefault() {
    return const PortConfiguration();
  }
  
  /// 创建移动端优化端口设置
  /// 
  /// 为移动设备优化端口配置，避免常用端口冲突
  static PortConfiguration createMobileOptimized() {
    return const PortConfiguration(
      socksPort: 10808,
      httpPort: 18080,
      apiPort: 19090,
      enableRedirect: false,
    );
  }
  
  /// 创建开发环境端口设置
  /// 
  /// 为开发环境配置易于记忆的端口号
  static PortConfiguration createDevelopment() {
    return const PortConfiguration(
      socksPort: 1080,
      httpPort: 8080,
      apiPort: 3000,
      enableRedirect: true,
    );
  }
  
  /// 创建安全模式端口设置
  /// 
  /// 配置较为安全的端口范围，降低被扫描发现的风险
  static PortConfiguration createSecureMode() {
    return const PortConfiguration(
      socksPort: 49152,
      httpPort: 49153,
      apiPort: 49154,
      enableRedirect: true,
    );
  }
  
  /// 检查端口是否被系统保留
  /// 
  /// 判断给定的端口号是否被系统保留或常用服务占用
  static bool isReservedPort(int port) {
    // 系统保留端口范围：0-1023
    if (port <= 1023) return true;
    
    // 常用服务端口
    final reservedPorts = {
      21,   // FTP
      22,   // SSH
      23,   // Telnet
      25,   // SMTP
      53,   // DNS
      80,   // HTTP
      110,  // POP3
      143,  // IMAP
      443,  // HTTPS
      993,  // IMAPS
      995,  // POP3S
    };
    
    return reservedPorts.contains(port);
  }
  
  /// 生成可用的端口号
  /// 
  /// 基于起始端口号生成一个可用的端口配置
  static int generateAvailablePort(int startPort) {
    int port = startPort;
    while (port <= 65535) {
      // 这里可以添加端口占用检测逻辑
      // 目前简单地返回起始端口
      if (!isReservedPort(port)) {
        return port;
      }
      port++;
    }
    // 如果没有找到可用端口，返回默认值
    return 1080;
  }
}