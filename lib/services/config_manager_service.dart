/// 配置文件管理器服务
/// 
/// 整合配置生成、解析、验证、模板管理和 I/O 操作，实现配置的实时更新和动态重载

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import '../models/app_settings.dart';
import '../models/enums.dart';
import '../config/clash_config_generator.dart';
import '../config/yaml_parser.dart';
import '../config/config_validator.dart';
import '../config/config_template_manager.dart';
import '../logging/log_level.dart';
import '../services/config_io_service.dart';

/// 配置状态
enum ConfigState {
  /// 未初始化
  uninitialized,
  /// 加载中
  loading,
  /// 已就绪
  ready,
  /// 更新中
  updating,
  /// 错误状态
  error,
}

/// 配置变更事件类型
enum ConfigChangeEventType {
  /// 配置加载
  configLoaded,
  /// 配置更新
  configUpdated,
  /// 代理更新
  proxyUpdated,
  /// 规则更新
  rulesUpdated,
  /// 模板应用
  templateApplied,
  /// 配置验证
  configValidated,
}

/// 配置变更事件
class ConfigChangeEvent {
  final ConfigChangeEventType type;
  final DateTime timestamp;
  final Map<String, dynamic>? data;
  final String? message;

  const ConfigChangeEvent({
    required this.type,
    required this.timestamp,
    this.data,
    this.message,
  });

  @override
  String toString() {
    return 'ConfigChangeEvent{type: $type, timestamp: $timestamp, message: $message}';
  }
}

/// 完整的配置管理结果
class ConfigManagementResult {
  final bool success;
  final String? configContent;
  final ValidationResult? validationResult;
  final ConfigChangeEvent? changeEvent;
  final String? errorMessage;
  final Duration? operationTime;

  const ConfigManagementResult({
    required this.success,
    this.configContent,
    this.validationResult,
    this.changeEvent,
    this.errorMessage,
    this.operationTime,
  });

  /// 创建成功结果
  factory ConfigManagementResult.success({
    String? configContent,
    ValidationResult? validationResult,
    ConfigChangeEvent? changeEvent,
    Duration? operationTime,
  }) {
    return ConfigManagementResult(
      success: true,
      configContent: configContent,
      validationResult: validationResult,
      changeEvent: changeEvent,
      operationTime: operationTime,
    );
  }

  /// 创建失败结果
  factory ConfigManagementResult.failure(String errorMessage) {
    return ConfigManagementResult(
      success: false,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('=== 配置管理结果 ===');
    buffer.writeln('成功: $success');
    
    if (errorMessage != null) {
      buffer.writeln('错误: $errorMessage');
    }
    
    if (validationResult != null) {
      buffer.writeln('验证状态: ${validationResult!.isValid ? "有效" : "无效"}');
      buffer.writeln('错误数量: ${validationResult!.errors.length}');
      buffer.writeln('警告数量: ${validationResult!.warnings.length}');
    }
    
    if (changeEvent != null) {
      buffer.writeln('变更事件: $changeEvent');
    }
    
    return buffer.toString();
  }
}

/// 配置管理器服务
class ConfigManagerService {
  static final Logger _logger = Logger('ConfigManagerService');
  
  static ConfigManagerService? _instance;
  static ConfigManagerService get instance => _instance ??= ConfigManagerService._();
  
  ConfigManagerService._();
  
  /// 核心组件
  late final ClashConfigGenerator _generator;
  late final YamlParser _parser;
  late final ConfigValidator _validator;
  late final ConfigTemplateManager _templateManager;
  late final ConfigIOService _ioService;
  
  /// 配置状态
  ConfigState _state = ConfigState.uninitialized;
  
  /// 当前配置
  ClashCoreSettings? _currentConfig;
  List<ProxyConfig> _currentProxies = [];
  List<String> _currentRules = [];
  
  /// 事件流控制器
  final StreamController<ConfigChangeEvent> _eventController = 
      StreamController<ConfigChangeEvent>.broadcast();
  
  /// 配置文件变更监听器
  final Map<String, FileSystemWatcher> _fileWatchers = {};
  
  /// 初始化标识
  bool _initialized = false;

  /// 配置变更事件流
  Stream<ConfigChangeEvent> get configChangeEvents => _eventController.stream;
  
  /// 当前配置状态
  ConfigState get state => _state;
  
  /// 当前配置
  ClashCoreSettings? get currentConfig => _currentConfig;
  
  /// 当前代理列表
  List<ProxyConfig> get currentProxies => List.unmodifiable(_currentProxies);
  
  /// 当前规则列表
  List<String> get currentRules => List.unmodifiable(_currentRules);
  
  /// 是否已初始化
  bool get isInitialized => _initialized;

  /// 初始化配置管理器
  Future<void> initialize() async {
    if (_initialized) return;
    
    _logger.info('初始化配置管理器服务');
    _state = ConfigState.loading;
    
    try {
      // 初始化核心组件
      _generator = ClashConfigGenerator();
      _parser = YamlParser();
      _validator = ConfigValidator();
      _templateManager = ConfigTemplateManager();
      _ioService = ConfigIOService();
      
      // 初始化各个组件
      await _templateManager.initialize();
      await _ioService.initialize();
      
      _initialized = true;
      _state = ConfigState.ready;
      
      _emitEvent(ConfigChangeEvent(
        type: ConfigChangeEventType.configLoaded,
        timestamp: DateTime.now(),
        message: '配置管理器初始化完成',
      ));
      
      _logger.info('配置管理器服务初始化完成');
      
    } catch (e) {
      _state = ConfigState.error;
      _logger.severe('配置管理器初始化失败: $e');
      rethrow;
    }
  }

  /// 从 ClashCoreSettings 加载配置
  /// 
  /// [settings] ClashCoreSettings 配置
  /// [proxyList] 代理列表
  /// [rules] 规则列表
  Future<ConfigManagementResult> loadFromSettings(
    ClashCoreSettings settings, {
    List<ProxyConfig>? proxyList,
    List<String>? rules,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('从 ClashCoreSettings 加载配置');
      _state = ConfigState.updating;
      
      // 生成配置内容
      final configContent = _generator.generateClashConfig(
        settings,
        proxyList: proxyList,
        rules: rules,
      );
      
      // 验证配置
      final validationResult = _validator.validateSettings(
        settings,
        proxyList: proxyList,
        level: ValidationLevel.standard,
      );
      
      // 更新内部状态
      _currentConfig = settings;
      _currentProxies = proxyList ?? [];
      _currentRules = rules ?? [];
      
      _state = ConfigState.ready;
      
      stopwatch.stop();
      
      final changeEvent = ConfigChangeEvent(
        type: ConfigChangeEventType.configLoaded,
        timestamp: DateTime.now(),
        data: {
          'proxy_count': _currentProxies.length,
          'rule_count': _currentRules.length,
        },
        message: '配置加载完成',
      );
      
      _emitEvent(changeEvent);
      
      _logger.info('从 ClashCoreSettings 加载配置成功');
      
      return ConfigManagementResult.success(
        configContent: configContent,
        validationResult: validationResult,
        changeEvent: changeEvent,
        operationTime: stopwatch.elapsed,
      );
      
    } catch (e) {
      _state = ConfigState.error;
      stopwatch.stop();
      _logger.warning('从 ClashCoreSettings 加载配置失败: $e');
      
      return ConfigManagementResult.failure('加载配置失败: $e');
    }
  }

  /// 从文件加载配置
  /// 
  /// [filePath] 配置文件路径
  Future<ConfigManagementResult> loadFromFile(String filePath) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('从文件加载配置: $filePath');
      _state = ConfigState.updating;
      
      // 使用 I/O 服务加载配置
      final parseResult = await _ioService.loadConfig(filePath);
      if (parseResult == null) {
        throw ConfigIOException('无法加载配置文件: $filePath');
      }
      
      // 验证配置
      final validationResult = _validator.validateYamlContent(
        parseResult.rawYaml,
        level: ValidationLevel.standard,
      );
      
      // 更新内部状态
      _currentConfig = parseResult.config;
      _currentProxies = parseResult.proxyList;
      _currentRules = parseResult.rules;
      
      _state = ConfigState.ready;
      
      stopwatch.stop();
      
      final changeEvent = ConfigChangeEvent(
        type: ConfigChangeEventType.configLoaded,
        timestamp: DateTime.now(),
        data: {
          'file_path': filePath,
          'proxy_count': _currentProxies.length,
          'rule_count': _currentRules.length,
        },
        message: '从文件加载配置完成',
      );
      
      _emitEvent(changeEvent);
      
      _logger.info('从文件加载配置成功: $filePath');
      
      return ConfigManagementResult.success(
        configContent: parseResult.rawYaml,
        validationResult: validationResult,
        changeEvent: changeEvent,
        operationTime: stopwatch.elapsed,
      );
      
    } catch (e) {
      _state = ConfigState.error;
      stopwatch.stop();
      _logger.warning('从文件加载配置失败: $e');
      
      return ConfigManagementResult.failure('从文件加载配置失败: $e');
    }
  }

  /// 应用配置模板
  /// 
  /// [templateId] 模板 ID
  /// [customizations] 自定义选项
  Future<ConfigManagementResult> applyTemplate(
    String templateId, {
    Map<String, dynamic>? customizations,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('应用配置模板: $templateId');
      _state = ConfigState.updating;
      
      // 获取模板
      final template = _templateManager.getTemplate(templateId);
      if (template == null) {
        throw TemplateException('模板不存在: $templateId');
      }
      
      // 解析模板配置
      final parseResult = _parser.parseConfig(template.yamlContent);
      
      // 应用自定义选项
      ClashCoreSettings customizedConfig = parseResult.config;
      if (customizations != null) {
        customizedConfig = _applyCustomizations(customizedConfig, customizations);
      }
      
      // 更新内部状态
      _currentConfig = customizedConfig;
      _currentProxies = parseResult.proxyList;
      _currentRules = parseResult.rules;
      
      _state = ConfigState.ready;
      
      stopwatch.stop();
      
      final changeEvent = ConfigChangeEvent(
        type: ConfigChangeEventType.templateApplied,
        timestamp: DateTime.now(),
        data: {
          'template_id': templateId,
          'template_name': template.name,
          'proxy_count': _currentProxies.length,
          'customizations_applied': customizations?.isNotEmpty ?? false,
        },
        message: '模板应用完成: ${template.name}',
      );
      
      _emitEvent(changeEvent);
      
      _logger.info('配置模板应用成功: $templateId');
      
      return ConfigManagementResult.success(
        configContent: template.yamlContent,
        validationResult: null,
        changeEvent: changeEvent,
        operationTime: stopwatch.elapsed,
      );
      
    } catch (e) {
      _state = ConfigState.error;
      stopwatch.stop();
      _logger.warning('应用配置模板失败: $e');
      
      return ConfigManagementResult.failure('应用模板失败: $e');
    }
  }

  /// 更新代理配置
  /// 
  /// [proxies] 新的代理列表
  Future<ConfigManagementResult> updateProxies(List<ProxyConfig> proxies) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('更新代理配置: ${proxies.length} 个代理');
      
      // 验证代理配置
      final validationResult = _validator.validateProxyList(
        proxies,
        level: ValidationLevel.standard,
      );
      
      if (!validationResult.isValid) {
        return ConfigManagementResult.failure(
          '代理配置验证失败: ${validationResult.errors.join(", ")}',
        );
      }
      
      // 更新代理列表
      _currentProxies = proxies;
      
      // 如果有当前配置，重新生成配置内容
      String? configContent;
      if (_currentConfig != null) {
        configContent = _generator.generateClashConfig(
          _currentConfig!,
          proxyList: proxies,
        );
      }
      
      stopwatch.stop();
      
      final changeEvent = ConfigChangeEvent(
        type: ConfigChangeEventType.proxyUpdated,
        timestamp: DateTime.now(),
        data: {
          'proxy_count': proxies.length,
          'proxy_types': _countProxyTypes(proxies),
        },
        message: '代理配置更新完成',
      );
      
      _emitEvent(changeEvent);
      
      _logger.info('代理配置更新成功');
      
      return ConfigManagementResult.success(
        configContent: configContent,
        validationResult: validationResult,
        changeEvent: changeEvent,
        operationTime: stopwatch.elapsed,
      );
      
    } catch (e) {
      _logger.warning('更新代理配置失败: $e');
      return ConfigManagementResult.failure('更新代理配置失败: $e');
    }
  }

  /// 更新规则配置
  /// 
  /// [rules] 新的规则列表
  Future<ConfigManagementResult> updateRules(List<String> rules) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('更新规则配置: ${rules.length} 条规则');
      
      _currentRules = rules;
      
      // 如果有当前配置，重新生成配置内容
      String? configContent;
      if (_currentConfig != null) {
        configContent = _generator.generateClashConfig(
          _currentConfig!,
          proxyList: _currentProxies,
          rules: rules,
        );
      }
      
      stopwatch.stop();
      
      final changeEvent = ConfigChangeEvent(
        type: ConfigChangeEventType.rulesUpdated,
        timestamp: DateTime.now(),
        data: {
          'rule_count': rules.length,
          'rule_types': _analyzeRules(rules),
        },
        message: '规则配置更新完成',
      );
      
      _emitEvent(changeEvent);
      
      _logger.info('规则配置更新成功');
      
      return ConfigManagementResult.success(
        configContent: configContent,
        changeEvent: changeEvent,
        operationTime: stopwatch.elapsed,
      );
      
    } catch (e) {
      _logger.warning('更新规则配置失败: $e');
      return ConfigManagementResult.failure('更新规则配置失败: $e');
    }
  }

  /// 保存配置到文件
  /// 
  /// [filePath] 可选的文件路径
  Future<ConfigManagementResult> saveToFile({String? filePath}) async {
    try {
      if (_currentConfig == null) {
        return ConfigManagementResult.failure('没有可保存的配置');
      }
      
      final ioResult = await _ioService.saveConfig(
        _currentConfig!,
        filePath: filePath,
        proxyList: _currentProxies,
      );
      
      if (ioResult.success) {
        final changeEvent = ConfigChangeEvent(
          type: ConfigChangeEventType.configUpdated,
          timestamp: DateTime.now(),
          data: {
            'file_path': ioResult.filePath,
            'proxy_count': _currentProxies.length,
          },
          message: '配置保存完成',
        );
        
        _emitEvent(changeEvent);
        
        return ConfigManagementResult.success(
          changeEvent: changeEvent,
        );
      } else {
        return ConfigManagementResult.failure(ioResult.errorMessage ?? '保存失败');
      }
      
    } catch (e) {
      return ConfigManagementResult.failure('保存配置失败: $e');
    }
  }

  /// 实时更新配置
  /// 
  /// [newSettings] 新的设置
  /// [immediateApply] 是否立即应用更改
  Future<ConfigManagementResult> realtimeUpdate(
    ClashCoreSettings newSettings, {
    bool immediateApply = false,
  }) async {
    if (!immediateApply) {
      // 延迟应用，将更改加入队列
      _scheduleUpdate(newSettings);
      return ConfigManagementResult.success(message: '更新已加入队列');
    }
    
    // 立即应用更改
    return await _applySettingsUpdate(newSettings);
  }

  /// 启用配置文件监控
  /// 
  /// [filePath] 要监控的文件路径
  void enableFileWatching(String filePath) {
    if (_fileWatchers.containsKey(filePath)) return;
    
    final watcher = File(filePath).watch();
    watcher.listen((event) {
      _logger.info('检测到配置文件变更: $filePath, 事件: $event');
      
      // 延迟加载，避免频繁变更
      Timer(const Duration(milliseconds: 1000), () {
        loadFromFile(filePath);
      });
    });
    
    _fileWatchers[filePath] = watcher;
  }

  /// 禁用配置文件监控
  /// 
  /// [filePath] 要停止监控的文件路径
  void disableFileWatching(String filePath) {
    final watcher = _fileWatchers.remove(filePath);
    watcher?.close();
  }

  /// 获取配置摘要
  String getConfigSummary() {
    if (_currentConfig == null) {
      return '没有活动的配置';
    }
    
    return _generator.generateConfigSummary(_currentConfig!, _currentProxies);
  }

  /// 验证当前配置
  ValidationResult validateCurrentConfig() {
    if (_currentConfig == null) {
      return ValidationResult(
        isValid: false,
        errors: ['没有可验证的配置'],
        warnings: [],
        suggestions: [],
        level: ValidationLevel.standard,
        timestamp: DateTime.now(),
      );
    }
    
    return _validator.validateSettings(
      _currentConfig!,
      proxyList: _currentProxies,
      level: ValidationLevel.standard,
    );
  }

  /// 获取可用模板列表
  List<ConfigTemplate> getAvailableTemplates({TemplateCategory? category}) {
    return _templateManager.getAllTemplates(category: category);
  }

  /// 创建自定义模板
  Future<String> createCustomTemplate({
    required String name,
    required String description,
    List<String>? tags,
  }) async {
    if (_currentConfig == null) {
      throw ConfigIOException('没有可创建模板的配置');
    }
    
    return _templateManager.createTemplateFromConfig(
      name: name,
      description: description,
      settings: _currentConfig!,
      proxyList: _currentProxies,
      tags: tags ?? [],
    );
  }

  /// 导出配置
  /// 
  /// [targetPath] 目标路径
  /// [format] 导出格式
  Future<ConfigManagementResult> exportConfig(
    String targetPath, {
    ExportFormat format = ExportFormat.yaml,
  }) async {
    if (_currentConfig == null) {
      return ConfigManagementResult.failure('没有可导出的配置');
    }
    
    final configContent = _generator.generateClashConfig(
      _currentConfig!,
      proxyList: _currentProxies,
      rules: _currentRules,
    );
    
    final ioResult = await _ioService.exportConfig(
      '', // 不需要源文件路径，因为我们要导出当前配置
      targetPath: targetPath,
      format: format,
    );
    
    if (ioResult.success) {
      return ConfigManagementResult.success();
    } else {
      return ConfigManagementResult.failure(ioResult.errorMessage ?? '导出失败');
    }
  }

  /// 导入配置
  /// 
  /// [filePath] 要导入的文件路径
  /// [targetPath] 目标路径（可选）
  Future<ConfigManagementResult> importConfig(
    String filePath, {
    String? targetPath,
    bool validate = true,
  }) async {
    final ioResult = await _ioService.importConfig(
      filePath,
      targetPath: targetPath,
      validate: validate,
    );
    
    if (ioResult.success && ioResult.filePath != null) {
      return await loadFromFile(ioResult.filePath!);
    } else {
      return ConfigManagementResult.failure(ioResult.errorMessage ?? '导入失败');
    }
  }

  /// 释放资源
  void dispose() {
    // 关闭文件监听器
    for (final watcher in _fileWatchers.values) {
      watcher.close();
    }
    _fileWatchers.clear();
    
    // 关闭事件流
    _eventController.close();
    
    _initialized = false;
    _logger.info('配置管理器服务已释放');
  }

  /// 应用自定义选项
  ClashCoreSettings _applyCustomizations(
    ClashCoreSettings config,
    Map<String, dynamic> customizations,
  ) {
    var updatedConfig = config;
    
    // 应用端口自定义
    if (customizations.containsKey('ports')) {
      final portsData = customizations['ports'] as Map<String, dynamic>?;
      if (portsData != null) {
        updatedConfig = updatedConfig.copyWith(
          ports: PortSettings(
            httpPort: portsData['httpPort'] ?? config.ports.httpPort,
            socksPort: portsData['socksPort'] ?? config.ports.socksPort,
            mixedPort: portsData['mixedPort'] ?? config.ports.mixedPort,
            apiPort: portsData['apiPort'] ?? config.ports.apiPort,
          ),
        );
      }
    }
    
    // 应用代理模式自定义
    if (customizations.containsKey('mode')) {
      final modeStr = customizations['mode'].toString();
      final mode = ProxyMode.values.firstWhere(
        (m) => m.toString().split('.').last == modeStr,
        orElse: () => config.mode,
      );
      updatedConfig = updatedConfig.copyWith(mode: mode);
    }
    
    // 应用日志级别自定义
    if (customizations.containsKey('logLevel')) {
      final levelStr = customizations['logLevel'].toString();
      final level = LogLevel.values.firstWhere(
        (l) => l.toString().split('.').last == levelStr,
        orElse: () => config.logLevel,
      );
      updatedConfig = updatedConfig.copyWith(logLevel: level);
    }
    
    return updatedConfig;
  }

  /// 应用设置更新
  Future<ConfigManagementResult> _applySettingsUpdate(ClashCoreSettings newSettings) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('应用设置更新');
      _state = ConfigState.updating;
      
      // 生成新的配置内容
      final configContent = _generator.generateClashConfig(
        newSettings,
        proxyList: _currentProxies,
        rules: _currentRules,
      );
      
      // 更新内部状态
      _currentConfig = newSettings;
      
      _state = ConfigState.ready;
      
      stopwatch.stop();
      
      final changeEvent = ConfigChangeEvent(
        type: ConfigChangeEventType.configUpdated,
        timestamp: DateTime.now(),
        data: {
          'mode': newSettings.mode.toString(),
          'logLevel': newSettings.logLevel.toString(),
        },
        message: '配置更新完成',
      );
      
      _emitEvent(changeEvent);
      
      _logger.info('设置更新应用成功');
      
      return ConfigManagementResult.success(
        configContent: configContent,
        changeEvent: changeEvent,
        operationTime: stopwatch.elapsed,
      );
      
    } catch (e) {
      _state = ConfigState.error;
      stopwatch.stop();
      _logger.warning('应用设置更新失败: $e');
      
      return ConfigManagementResult.failure('应用设置更新失败: $e');
    }
  }

  /// 延迟更新调度
  void _scheduleUpdate(ClashCoreSettings newSettings) {
    // 清除之前的定时器
    Timer? previousTimer;
    
    previousTimer?.cancel();
    
    // 设置新的定时器，1秒后执行
    previousTimer = Timer(const Duration(seconds: 1), () {
      _applySettingsUpdate(newSettings);
    });
  }

  /// 统计代理类型
  Map<String, int> _countProxyTypes(List<ProxyConfig> proxies) {
    final counts = <String, int>{};
    for (final proxy in proxies) {
      final type = proxy.type.toString().split('.').last;
      counts[type] = (counts[type] ?? 0) + 1;
    }
    return counts;
  }

  /// 分析规则
  Map<String, int> _analyzeRules(List<String> rules) {
    final analysis = <String, int>{
      'total': rules.length,
      'domain_suffix': 0,
      'domain_keyword': 0,
      'geoip': 0,
      'ip_cidr': 0,
      'match': 0,
    };
    
    for (final rule in rules) {
      final trimmedRule = rule.trim();
      if (trimmedRule.startsWith('DOMAIN-SUFFIX,')) {
        analysis['domain_suffix'] = (analysis['domain_suffix'] ?? 0) + 1;
      } else if (trimmedRule.startsWith('DOMAIN-KEYWORD,')) {
        analysis['domain_keyword'] = (analysis['domain_keyword'] ?? 0) + 1;
      } else if (trimmedRule.startsWith('GEOIP,')) {
        analysis['geoip'] = (analysis['geoip'] ?? 0) + 1;
      } else if (trimmedRule.startsWith('IP-CIDR,')) {
        analysis['ip_cidr'] = (analysis['ip_cidr'] ?? 0) + 1;
      } else if (trimmedRule.startsWith('MATCH,')) {
        analysis['match'] = (analysis['match'] ?? 0) + 1;
      }
    }
    
    return analysis;
  }

  /// 发送配置变更事件
  void _emitEvent(ConfigChangeEvent event) {
    if (!_eventController.isClosed) {
      _eventController.add(event);
    }
  }
}
