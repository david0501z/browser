import 'dart:async';
import 'proxy_service.dart';
import 'proxy_lifecycle_manager.dart';
import 'config_manager.dart';
import 'error_handler.dart';

/// 代理服务使用示例
/// 
/// 展示如何使用高级代理服务架构：
/// - 服务初始化
/// - 代理连接管理
/// - 配置管理
/// - 错误处理
/// - 生命周期管理
class ProxyServiceExample {
  
  /// 运行示例
  static Future<void> run() async {
    print('=== 代理服务使用示例 ===\n');

    try {
      // 1. 初始化服务
      await _initializeServices();
      
      // 2. 设置事件监听
      _setupEventListeners();
      
      // 3. 配置代理
      await _configureProxy();
      
      // 4. 建立连接
      await _establishConnection();
      
      // 5. 监控状态
      await _monitorStatus();
      
      // 6. 错误处理测试
      await _testErrorHandling();
      
      // 7. 清理资源
      await _cleanup();
      
    } catch (e, stackTrace) {
      print('示例运行失败: $e');
      print('堆栈跟踪: $stackTrace');
    }
  }

  /// 初始化服务
  static Future<void> _initializeServices() async {
    print('1. 初始化服务...');
    
    // 初始化错误处理器
    final errorHandler = ErrorHandler.instance;
    await errorHandler.initialize(ErrorHandlingConfig(
      enableConsoleOutput: true,
      enableLogToFile: true,
      enableUserNotification: true,
    ));
    
    // 初始化配置管理器
    final configManager = ConfigManager.instance;
    final configInitialized = await configManager.initialize();
    if (configInitialized) {
      print('✓ 配置管理器初始化成功');
    } else {
      print('✗ 配置管理器初始化失败');
    }
    
    // 初始化生命周期管理器
    final lifecycleManager = ProxyLifecycleManager.instance;
    final lifecycleInitialized = await lifecycleManager.initialize();
    if (lifecycleInitialized) {
      print('✓ 生命周期管理器初始化成功');
    } else {
      print('✗ 生命周期管理器初始化失败');
    }
    
    // 初始化代理服务
    final proxyManager = ProxyServiceManager.instance;
    final proxyInitialized = await proxyManager.initialize();
    if (proxyInitialized) {
      print('✓ 代理服务初始化成功');
    } else {
      print('✗ 代理服务初始化失败');
    }
    
    print('');
  }

  /// 设置事件监听
  static void _setupEventListeners() {
    print('2. 设置事件监听...');
    
    final proxyManager = ProxyServiceManager.instance;
    
    // 监听代理服务事件
    proxyManager.proxyEvents.listen((event) {
      print('📡 代理事件: ${event.type.toString()} - ${event.message}');
    });
    
    // 监听代理状态变化
    proxyManager.proxyStates.listen((state) {
      print('🔄 代理状态: ${state.toString()}');
    });
    
    // 监听生命周期事件
    final lifecycleManager = ProxyLifecycleManager.instance;
    lifecycleManager.eventStream.listen((event) {
      print('🔄 生命周期事件: ${event.type.toString()} - ${event.message}');
    });
    
    // 监听配置事件
    final configManager = ConfigManager.instance;
    configManager.eventStream.listen((event) {
      print('⚙️ 配置事件: ${event.type.toString()} - ${event.message}');
    });
    
    // 监听错误事件
    final errorHandler = ErrorHandler.instance;
    errorHandler.eventStream.listen((event) {
      print('❌ 错误事件: ${event.type.toString()} - ${event.message}');
    });
    
    print('');
  }

  /// 配置代理
  static Future<void> _configureProxy() async {
    print('3. 配置代理...');
    
    final configManager = ConfigManager.instance;
    
    // 设置基本代理配置
    await configManager.setConfig('proxy.type', 'HTTP');
    await configManager.setConfig('proxy.host', '127.0.0.1');
    await configManager.setConfig('proxy.port', 8080);
    await configManager.setConfig('proxy.username', 'user');
    await configManager.setConfig('proxy.password', 'password');
    await configManager.setConfig('proxy.timeout', 30);
    await configManager.setConfig('proxy.autoConnect', false);
    
    // 设置UI配置
    await configManager.setConfig('ui.theme', 'dark');
    await configManager.setConfig('ui.language', 'zh-CN');
    await configManager.setConfig('ui.autoStart', false);
    
    // 设置网络配置
    await configManager.setConfig('network.dns', ['8.8.8.8', '8.8.4.4']);
    await configManager.setConfig('network.bypassLocal', true);
    
    // 添加代理配置
    final proxyConfig = ProxyConfig(
      name: '示例代理',
      type: 'HTTP',
      host: 'proxy.example.com',
      port: 8080,
      username: 'user',
      password: 'pass',
      encryption: 'AES-256',
    );
    
    await configManager.addProxyConfig(proxyConfig);
    
    print('✓ 代理配置完成');
    print('');
  }

  /// 建立连接
  static Future<void> _establishConnection() async {
    print('4. 建立代理连接...');
    
    final proxyManager = ProxyServiceManager.instance;
    
    // 尝试建立连接
    final connected = await proxyManager.startProxy(
      proxyType: 'HTTP',
      serverHost: 'proxy.example.com',
      serverPort: 8080,
      username: 'user',
      password: 'pass',
      additionalConfig: {
        'encryption': 'AES-256',
        'timeout': 30,
      },
    );
    
    if (connected) {
      print('✓ 代理连接建立成功');
      
      // 测试连接
      final testResult = await proxyManager.testProxyConnection('https://www.google.com');
      print('✓ 代理连接测试: ${testResult ? "成功" : "失败"}');
    } else {
      print('✗ 代理连接建立失败');
    }
    
    print('');
  }

  /// 监控状态
  static Future<void> _monitorStatus() async {
    print('5. 监控服务状态...');
    
    final proxyManager = ProxyServiceManager.instance;
    final lifecycleManager = ProxyLifecycleManager.instance;
    final configManager = ConfigManager.instance;
    
    // 等待一段时间观察状态变化
    await Future.delayed(const Duration(seconds: 3));
    
    // 获取当前状态
    final currentState = proxyManager.currentProxyState;
    final isConnected = proxyManager.isProxyConnected;
    final currentConnection = proxyManager.currentConnection;
    
    print('📊 当前代理状态: $currentState');
    print('📊 连接状态: ${isConnected ? "已连接" : "未连接"}');
    
    if (currentConnection != null) {
      print('📊 连接信息: ${currentConnection.serverHost}:${currentConnection.serverPort}');
    }
    
    // 获取配置统计
    final configStats = configManager.getStatistics();
    print('📊 配置统计: $configStats');
    
    // 获取生命周期统计
    final lifecycleStats = lifecycleManager.getStatistics();
    print('📊 生命周期统计: ${lifecycleStats['sessionId']} - 会话活跃: ${lifecycleStats['isActive']}');
    
    print('');
  }

  /// 测试错误处理
  static Future<void> _testErrorHandling() async {
    print('6. 测试错误处理...');
    
    final errorHandler = ErrorHandler.instance;
    final proxyManager = ProxyServiceManager.instance;
    
    // 模拟网络错误
    await errorHandler.handleError(
      'NetworkTest',
      '模拟网络连接失败',
      severity: ErrorSeverity.high,
      category: ErrorCategory.network,
      context: {'test': true},
    );
    
    // 模拟配置错误
    await errorHandler.handleError(
      'ConfigTest',
      '模拟配置解析失败',
      severity: ErrorSeverity.medium,
      category: ErrorCategory.configuration,
      context: {'test': true},
    );
    
    // 模拟FFI错误
    await errorHandler.handleError(
      'FFITest',
      '模拟FFI桥接失败',
      severity: ErrorSeverity.critical,
      category: ErrorCategory.ffi,
      context: {'test': true},
    );
    
    // 获取错误统计
    final errorStats = errorHandler.getStatistics();
    print('📊 错误统计:');
    print('  - 总错误数: ${errorStats.totalErrors}');
    print('  - 恢复错误数: ${errorStats.recoveredErrors}');
    print('  - 最常见错误: ${errorStats.mostCommonError}');
    print('  - 最后错误时间: ${errorStats.lastErrorTime}');
    
    print('');
  }

  /// 清理资源
  static Future<void> _cleanup() async {
    print('7. 清理资源...');
    
    try {
      // 停止代理服务
      final proxyManager = ProxyServiceManager.instance;
      await proxyManager.stopProxy();
      print('✓ 代理服务已停止');
      
      // 释放代理管理器
      await proxyManager.dispose();
      print('✓ 代理管理器已释放');
      
      // 释放配置管理器
      final configManager = ConfigManager.instance;
      await configManager.dispose();
      print('✓ 配置管理器已释放');
      
      // 释放生命周期管理器
      final lifecycleManager = ProxyLifecycleManager.instance;
      await lifecycleManager.dispose();
      print('✓ 生命周期管理器已释放');
      
      // 释放错误处理器
      final errorHandler = ErrorHandler.instance;
      await errorHandler.dispose();
      print('✓ 错误处理器已释放');
      
      print('✓ 所有资源清理完成');
      
    } catch (e, stackTrace) {
      print('✗ 资源清理失败: $e');
      print('✗ 堆栈跟踪: $stackTrace');
    }
  }
}

/// 主函数 - 运行示例
Future<void> main() async {
  await ProxyServiceExample.run();
}