/// 配置文件系统使用示例
/// 
/// 演示如何使用配置生成、解析、验证、模板管理和 I/O 操作

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../models/enums.dart';
import '../config/clash_config_generator.dart';
import '../config/yaml_parser.dart';
import '../config/config_validator.dart';
import '../config/config_template_manager.dart';
import '../services/config_io_service.dart';
import '../services/config_manager_service.dart';

/// 配置系统使用示例主页面
class ConfigSystemExamplePage extends StatefulWidget {
  const ConfigSystemExamplePage({Key? key}) : super(key: key);

  @override
  State<ConfigSystemExamplePage> createState() => _ConfigSystemExamplePageState();
}

class _ConfigSystemExamplePageState extends State<ConfigSystemExamplePage> {
  late ConfigManagerService _configManager;
  String _logOutput = '';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeConfigSystem();
  }

  @override
  void dispose() {
    _configManager.dispose();
    super.dispose();
  }

  /// 初始化配置系统
  Future<void> _initializeConfigSystem() async {
    _addLog('开始初始化配置系统...');
    
    try {
      _configManager = ConfigManagerService.instance;
      await _configManager.initialize();
      
      // 监听配置变更事件
      _configManager.configChangeEvents.listen((event) {
        _addLog('收到配置变更事件: ${event.type} - ${event.message}');
      });
      
      setState(() {
        _isInitialized = true;
      });
      
      _addLog('配置系统初始化完成');
    } catch (e) {
      _addLog('配置系统初始化失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('配置系统示例'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 初始化状态
            _buildSectionTitle('系统状态'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('初始化状态: ${_isInitialized ? "已完成" : "未完成"}'),
                    Text('当前状态: ${_configManager.state}'),
                    if (_configManager.currentConfig != null) ...[
                      Text('当前代理数量: ${_configManager.currentProxies.length}'),
                      Text('当前规则数量: ${_configManager.currentRules.length}'),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 基本操作示例
            if (_isInitialized) ...[
              _buildSectionTitle('基本操作示例'),
              _buildOperationButtons(),
              
              const SizedBox(height: 20),
              
              // 模板管理示例
              _buildSectionTitle('模板管理示例'),
              _buildTemplateButtons(),
              
              const SizedBox(height: 20),
              
              // 配置管理示例
              _buildSectionTitle('配置管理示例'),
              _buildConfigManagementButtons(),
              
              const SizedBox(height: 20),
            ],
            
            // 日志输出
            _buildSectionTitle('操作日志'),
            Card(
              child: Container(
                width: double.infinity,
                height: 300,
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _logOutput,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildOperationButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _createBasicConfig,
                  child: const Text('创建基础配置'),
                ),
                ElevatedButton(
                  onPressed: _validateCurrentConfig,
                  child: const Text('验证当前配置'),
                ),
                ElevatedButton(
                  onPressed: _showConfigSummary,
                  child: const Text('显示配置摘要'),
                ),
                ElevatedButton(
                  onPressed: _testProxyValidation,
                  child: const Text('测试代理验证'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _showAvailableTemplates,
                  child: const Text('查看模板列表'),
                ),
                ElevatedButton(
                  onPressed: _applyBasicTemplate,
                  child: const Text('应用基础模板'),
                ),
                ElevatedButton(
                  onPressed: _applyGamingTemplate,
                  child: const Text('应用游戏模板'),
                ),
                ElevatedButton(
                  onPressed: _createCustomTemplate,
                  child: const Text('创建自定义模板'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigManagementButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _loadConfigFromFile,
                  child: const Text('从文件加载'),
                ),
                ElevatedButton(
                  onPressed: _saveConfigToFile,
                  child: const Text('保存到文件'),
                ),
                ElevatedButton(
                  onPressed: _exportConfig,
                  child: const Text('导出配置'),
                ),
                ElevatedButton(
                  onPressed: _importConfig,
                  child: const Text('导入配置'),
                ),
                ElevatedButton(
                  onPressed: _enableFileWatching,
                  child: const Text('启用文件监控'),
                ),
                ElevatedButton(
                  onPressed: _realtimeUpdateConfig,
                  child: const Text('实时更新配置'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 添加日志
  void _addLog(String message) {
    setState(() {
      final timestamp = DateTime.now().toIso8601String();
      _logOutput = '[$timestamp] $message\n$_logOutput';
    });
  }

  /// 创建基础配置示例
  void _createBasicConfig() async {
    _addLog('创建基础配置示例...');
    
    try {
      // 创建 FlClashSettings
      final settings = FlClashSettings(
        enabled: true,
        mode: ProxyMode.rule,
        logLevel: LogLevel.info,
        ipv6: false,
        lanShare: false,
        ports: const PortSettings(
          httpPort: 7890,
          socksPort: 7891,
          mixedPort: 7890,
          apiPort: 9090,
        ),
        dns: const DNSSettings(
          customDNS: false,
          dnsServers: ['114.114.114.114', '8.8.8.8'],
          dnsOverHttps: false,
        ),
      );
      
      // 创建示例代理
      final proxies = [
        ProxyConfig(
          name: '示例 VMess 节点',
          type: ProxyType.vmess,
          host: 'example.com',
          port: 443,
          uuid: '12345678-1234-1234-1234-123456789012',
          alterId: 0,
          cipher: 'auto',
          network: 'ws',
          path: '/path',
          tls: true,
          sni: 'example.com',
        ),
        ProxyConfig(
          name: '示例 Shadowsocks 节点',
          type: ProxyType.shadowsocks,
          host: 'ss.example.com',
          port: 8388,
          method: 'aes-256-gcm',
          password: 'password123',
        ),
      ];
      
      // 创建示例规则
      final rules = [
        'DOMAIN-SUFFIX,google.com,PROXY',
        'DOMAIN-SUFFIX,youtube.com,PROXY',
        'DOMAIN-SUFFIX,github.com,PROXY',
        'GEOIP,CN,DIRECT',
        'MATCH,DIRECT',
      ];
      
      // 使用配置管理器加载配置
      final result = await _configManager.loadFromSettings(
        settings,
        proxyList: proxies,
        rules: rules,
      );
      
      if (result.success) {
        _addLog('基础配置创建成功');
        _addLog('代理数量: ${proxies.length}');
        _addLog('规则数量: ${rules.length}');
      } else {
        _addLog('基础配置创建失败: ${result.errorMessage}');
      }
      
    } catch (e) {
      _addLog('创建基础配置异常: $e');
    }
  }

  /// 验证当前配置
  void _validateCurrentConfig() {
    _addLog('验证当前配置...');
    
    final validationResult = _configManager.validateCurrentConfig();
    
    _addLog('验证结果: ${validationResult.isValid ? "有效" : "无效"}');
    _addLog('错误数量: ${validationResult.errors.length}');
    _addLog('警告数量: ${validationResult.warnings.length}');
    _addLog('建议数量: ${validationResult.suggestions.length}');
    
    if (validationResult.errors.isNotEmpty) {
      _addLog('主要错误:');
      for (final error in validationResult.errors.take(3)) {
        _addLog('  - $error');
      }
    }
  }

  /// 显示配置摘要
  void _showConfigSummary() {
    _addLog('显示配置摘要...');
    
    final summary = _configManager.getConfigSummary();
    _addLog(summary);
  }

  /// 测试代理验证
  void _testProxyValidation() {
    _addLog('测试代理验证...');
    
    // 创建一些测试代理
    final testProxies = [
      ProxyConfig(
        name: '有效 VMess 代理',
        type: ProxyType.vmess,
        host: 'valid.example.com',
        port: 443,
        uuid: '12345678-1234-1234-1234-123456789012',
      ),
      ProxyConfig(
        name: '无效 VMess 代理（缺少 UUID）',
        type: ProxyType.vmess,
        host: 'invalid.example.com',
        port: 443,
        // 缺少 uuid
      ),
      ProxyConfig(
        name: '无效代理（无效端口）',
        type: ProxyType.shadowsocks,
        host: 'test.example.com',
        port: 99999, // 无效端口
        method: 'aes-256-gcm',
        password: 'password',
      ),
    ];
    
    final validator = ConfigValidator();
    final result = validator.validateProxyList(testProxies);
    
    _addLog('代理验证结果: ${result.isValid ? "有效" : "无效"}');
    _addLog('发现 ${result.errors.length} 个错误');
    
    for (final error in result.errors) {
      _addLog('  错误: $error');
    }
  }

  /// 显示可用模板
  void _showAvailableTemplates() {
    _addLog('获取可用模板列表...');
    
    final templates = _configManager.getAvailableTemplates();
    
    _addLog('找到 ${templates.length} 个模板:');
    for (final template in templates.take(5)) {
      _addLog('  - ${template.name} (${template.category})');
    }
  }

  /// 应用基础模板
  void _applyBasicTemplate() async {
    _addLog('应用基础模板...');
    
    try {
      final result = await _configManager.applyTemplate('basic-rule');
      
      if (result.success) {
        _addLog('基础模板应用成功');
      } else {
        _addLog('基础模板应用失败: ${result.errorMessage}');
      }
    } catch (e) {
      _addLog('应用基础模板异常: $e');
    }
  }

  /// 应用游戏模板
  void _applyGamingTemplate() async {
    _addLog('应用游戏优化模板...');
    
    try {
      final result = await _configManager.applyTemplate('gaming-optimized');
      
      if (result.success) {
        _addLog('游戏优化模板应用成功');
      } else {
        _addLog('游戏优化模板应用失败: ${result.errorMessage}');
      }
    } catch (e) {
      _addLog('应用游戏模板异常: $e');
    }
  }

  /// 创建自定义模板
  void _createCustomTemplate() async {
    _addLog('创建自定义模板...');
    
    try {
      final templateId = await _configManager.createCustomTemplate(
        name: '自定义示例模板',
        description: '这是一个自定义的配置模板示例',
        tags: ['示例', '自定义'],
      );
      
      _addLog('自定义模板创建成功: $templateId');
    } catch (e) {
      _addLog('创建自定义模板异常: $e');
    }
  }

  /// 从文件加载配置示例
  void _loadConfigFromFile() async {
    _addLog('从文件加载配置示例...');
    
    try {
      // 这里使用一个模拟的路径，实际使用时应该使用真实的文件路径
      const filePath = '/path/to/config.yaml';
      
      final result = await _configManager.loadFromFile(filePath);
      
      if (result.success) {
        _addLog('配置文件加载成功');
        _addLog('代理数量: ${result.changeEvent?.data?['proxy_count']}');
      } else {
        _addLog('配置文件加载失败: ${result.errorMessage}');
      }
    } catch (e) {
      _addLog('从文件加载配置异常: $e');
    }
  }

  /// 保存配置到文件示例
  void _saveConfigToFile() async {
    _addLog('保存配置到文件示例...');
    
    try {
      final result = await _configManager.saveToFile();
      
      if (result.success) {
        _addLog('配置保存成功');
      } else {
        _addLog('配置保存失败: ${result.errorMessage}');
      }
    } catch (e) {
      _addLog('保存配置异常: $e');
    }
  }

  /// 导出配置示例
  void _exportConfig() async {
    _addLog('导出配置示例...');
    
    try {
      const exportPath = '/path/to/exported_config.yaml';
      
      final result = await _configManager.exportConfig(
        exportPath,
        format: ExportFormat.yaml,
      );
      
      if (result.success) {
        _addLog('配置导出成功: $exportPath');
      } else {
        _addLog('配置导出失败: ${result.errorMessage}');
      }
    } catch (e) {
      _addLog('导出配置异常: $e');
    }
  }

  /// 导入配置示例
  void _importConfig() async {
    _addLog('导入配置示例...');
    
    try {
      const importPath = '/path/to/import_config.yaml';
      
      final result = await _configManager.importConfig(
        importPath,
        validate: true,
      );
      
      if (result.success) {
        _addLog('配置导入成功');
      } else {
        _addLog('配置导入失败: ${result.errorMessage}');
      }
    } catch (e) {
      _addLog('导入配置异常: $e');
    }
  }

  /// 启用文件监控示例
  void _enableFileWatching() {
    _addLog('启用配置文件监控示例...');
    
    const watchPath = '/path/to/config.yaml';
    
    try {
      _configManager.enableFileWatching(watchPath);
      _addLog('文件监控已启用: $watchPath');
    } catch (e) {
      _addLog('启用文件监控异常: $e');
    }
  }

  /// 实时更新配置示例
  void _realtimeUpdateConfig() async {
    _addLog('实时更新配置示例...');
    
    try {
      // 创建更新后的设置
      final updatedSettings = FlClashSettings(
        enabled: true,
        mode: ProxyMode.global, // 改为全局模式
        logLevel: LogLevel.debug, // 改为调试级别
        ipv6: true, // 启用 IPv6
        lanShare: true, // 启用 LAN 共享
        ports: const PortSettings(
          httpPort: 1080,
          socksPort: 1081,
          mixedPort: 1080,
          apiPort: 9091,
        ),
      );
      
      final result = await _configManager.realtimeUpdate(
        updatedSettings,
        immediateApply: true,
      );
      
      if (result.success) {
        _addLog('配置实时更新成功');
        _addLog('更新操作时间: ${result.operationTime?.inMilliseconds}ms');
      } else {
        _addLog('配置实时更新失败: ${result.errorMessage}');
      }
    } catch (e) {
      _addLog('实时更新配置异常: $e');
    }
  }
}

/// 独立的配置系统使用示例函数
class ConfigSystemExample {
  static Future<void> runBasicExample() async {
    print('=== 配置文件系统基本使用示例 ===');
    
    // 1. 初始化系统
    final configManager = ConfigManagerService.instance;
    await configManager.initialize();
    print('✅ 配置系统初始化完成');
    
    // 2. 创建示例配置
    final settings = FlClashSettings(
      enabled: true,
      mode: ProxyMode.rule,
      logLevel: LogLevel.info,
    );
    
    final proxies = [
      ProxyConfig(
        name: '示例 VMess 节点',
        type: ProxyType.vmess,
        host: 'example.com',
        port: 443,
        uuid: '12345678-1234-1234-1234-123456789012',
      ),
    ];
    
    // 3. 加载配置
    final loadResult = await configManager.loadFromSettings(settings, proxyList: proxies);
    if (loadResult.success) {
      print('✅ 配置加载成功');
    } else {
      print('❌ 配置加载失败: ${loadResult.errorMessage}');
    }
    
    // 4. 验证配置
    final validationResult = configManager.validateCurrentConfig();
    print('📋 配置验证结果: ${validationResult.isValid ? "有效" : "无效"}');
    if (validationResult.errors.isNotEmpty) {
      print('❌ 配置错误: ${validationResult.errors.join(", ")}');
    }
    
    // 5. 应用模板
    final templateResult = await configManager.applyTemplate('basic-rule');
    if (templateResult.success) {
      print('✅ 模板应用成功');
    } else {
      print('❌ 模板应用失败: ${templateResult.errorMessage}');
    }
    
    // 6. 显示配置摘要
    final summary = configManager.getConfigSummary();
    print('📊 配置摘要:\n$summary');
    
    // 7. 清理资源
    configManager.dispose();
    print('🧹 资源清理完成');
  }
  
  static Future<void> runAdvancedExample() async {
    print('=== 配置文件系统高级功能示例 ===');
    
    // 初始化各个组件
    final generator = ClashConfigGenerator();
    final parser = YamlParser();
    final validator = ConfigValidator();
    final templateManager = ConfigTemplateManager();
    final ioService = ConfigIOService();
    
    // 初始化组件
    await templateManager.initialize();
    await ioService.initialize();
    
    print('✅ 所有组件初始化完成');
    
    // 1. 生成复杂配置
    final complexSettings = FlClashSettings(
      enabled: true,
      mode: ProxyMode.rule,
      logLevel: LogLevel.debug,
      ipv6: true,
      tunMode: true,
      mixedMode: false,
      systemProxy: false,
      lanShare: false,
      dnsForward: false,
      ports: const PortSettings(
        httpPort: 7890,
        socksPort: 7891,
        mixedPort: 7890,
        apiPort: 9090,
      ),
      dns: const DNSSettings(
        customDNS: true,
        dnsServers: ['223.5.5.5', '114.114.114.114'],
        dnsOverHttps: false,
      ),
    );
    
    final complexProxies = [
      ProxyConfig(
        name: 'VMess-HK-01',
        type: ProxyType.vmess,
        host: 'hk1.example.com',
        port: 443,
        uuid: '11111111-1111-1111-1111-111111111111',
        alterId: 0,
        cipher: 'auto',
        network: 'ws',
        path: '/vmess',
        tls: true,
        sni: 'hk1.example.com',
        alpn: 'h2,http/1.1',
      ),
      ProxyConfig(
        name: 'VMess-US-01',
        type: ProxyType.vmess,
        host: 'us1.example.com',
        port: 443,
        uuid: '22222222-2222-2222-2222-222222222222',
        alterId: 0,
        cipher: 'auto',
        network: 'ws',
        path: '/vmess',
        tls: true,
        sni: 'us1.example.com',
        alpn: 'h2,http/1.1',
      ),
      ProxyConfig(
        name: 'SS-JP-01',
        type: ProxyType.shadowsocks,
        host: 'jp1.example.com',
        port: 8388,
        method: 'aes-256-gcm',
        password: 'ss_password_123',
        plugin: 'v2ray-plugin',
        pluginOpts: 'server;tls;host=jp1.example.com;path=/ss',
      ),
    ];
    
    final complexRules = [
      'DOMAIN-SUFFIX,google.com,PROXY',
      'DOMAIN-SUFFIX,youtube.com,PROXY',
      'DOMAIN-SUFFIX,github.com,PROXY',
      'DOMAIN-SUFFIX,stackoverflow.com,PROXY',
      'DOMAIN-SUFFIX,netflix.com,NETFLIX',
      'DOMAIN-SUFFIX,disneyplus.com,STREAMING',
      'DOMAIN-SUFFIX,steam.com,GAME',
      'DOMAIN-SUFFIX,epicgames.com,GAME',
      'GEOIP,CN,DIRECT',
      'MATCH,PROXY',
    ];
    
    // 生成配置 YAML
    final yamlContent = generator.generateClashConfig(
      complexSettings,
      proxyList: complexProxies,
      rules: complexRules,
    );
    
    print('✅ 复杂配置生成完成');
    
    // 2. 解析配置
    final parseResult = parser.parseConfig(yamlContent);
    if (parseResult != null) {
      print('✅ 配置解析成功');
      print('   - 代理数量: ${parseResult.proxyList.length}');
      print('   - 规则数量: ${parseResult.rules.length}');
      print('   - 代理组数量: ${parseResult.proxyGroups.length}');
    }
    
    // 3. 验证配置
    final complexValidation = validator.validateYamlContent(yamlContent);
    print('📋 复杂配置验证结果: ${complexValidation.isValid ? "有效" : "无效"}');
    if (complexValidation.warnings.isNotEmpty) {
      print('⚠️  配置警告: ${complexValidation.warnings.take(3).join(", ")}');
    }
    
    // 4. 创建自定义模板
    final customTemplateId = await templateManager.createTemplate(
      name: '复杂配置模板',
      description: '包含多个代理和复杂规则的配置模板',
      yamlContent: yamlContent,
      category: TemplateCategory.performance,
      tags: ['复杂', '多节点', '性能优化'],
    );
    
    print('✅ 自定义模板创建成功: $customTemplateId');
    
    // 5. 保存配置到文件
    final saveResult = await ioService.saveConfig(
      complexSettings,
      proxyList: complexProxies,
      overwrite: true,
    );
    
    if (saveResult.success) {
      print('✅ 配置保存成功: ${saveResult.filePath}');
    } else {
      print('❌ 配置保存失败: ${saveResult.errorMessage}');
    }
    
    // 6. 导出配置
    final exportResult = await ioService.exportConfig(
      saveResult.filePath ?? '',
      targetPath: '/tmp/exported_config.json',
      format: ExportFormat.json,
    );
    
    if (exportResult.success) {
      print('✅ 配置导出成功: ${exportResult.filePath}');
    }
    
    print('🎉 高级功能示例完成');
  }
}
