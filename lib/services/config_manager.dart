import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 配置项类型
enum ConfigType {
  /// 字符串类型
  string,
  /// 整数类型
  integer,
  /// 浮点数类型
  double,
  /// 布尔类型
  boolean,
  /// JSON对象类型
  json,
  /// 列表类型
  list,
}

/// 配置存储策略
enum ConfigStorageStrategy {
  /// 内存存储
  memory,
  /// 本地文件存储
  localFile,
  /// 云端存储
  cloud,
  /// 混合存储
  hybrid,
}

/// 配置事件类型
enum ConfigEventType {
  /// 配置加载
  configLoaded,
  /// 配置保存
  configSaved,
  /// 配置更新
  configUpdated,
  /// 配置删除
  configDeleted,
  /// 配置重置
  configReset,
  /// 配置验证失败
  configValidationFailed,
}

/// 配置事件
class ConfigEvent {
  final ConfigEventType type;
  final String key;
  final dynamic value;
  final String? message;
  final DateTime timestamp;

  const ConfigEvent({
    required this.type,
    required this.key,
    this.value,
    this.message,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'ConfigEvent{type: $type, key: $key, value: $value, timestamp: $timestamp}';
  }
}

/// 配置验证规则
class ConfigValidationRule {
  final String key;
  final String description;
  final bool required;
  final dynamic minValue;
  final dynamic maxValue;
  final List<dynamic> allowedValues;
  final RegExp? regexPattern;
  final bool Function(dynamic)? customValidator;

  const ConfigValidationRule({
    required this.key,
    required this.description,
    required this.required,
    this.minValue,
    this.maxValue,
    this.allowedValues = const [],
    this.regexPattern,
    this.customValidator,
  });
}

/// 配置验证结果
class ConfigValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  const ConfigValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
  bool get isValidWithWarnings => isValid || warnings.isNotEmpty;
}

/// 代理配置信息
class ProxyConfig {
  final String name;
  final String type; // HTTP, SOCKS5, VMess, Trojan, etc.
  final String host;
  final int port;
  final String? username;
  final String? password;
  final String? encryption;
  final String? uuid;
  final Map<String, dynamic> additionalSettings;
  final bool enabled;
  final DateTime createdAt;
  final DateTime lastUsed;
  final int useCount;

  const ProxyConfig({
    required this.name,
    required this.type,
    required this.host,
    required this.port,
    this.username,
    this.password,
    this.encryption,
    this.uuid,
    this.additionalSettings = const {},
    this.enabled = true,
    DateTime? createdAt,
    DateTime? lastUsed,
    this.useCount = 0,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastUsed = lastUsed ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'host': host,
    'port': port,
    'username': username,
    'password': password,
    'encryption': encryption,
    'uuid': uuid,
    'additionalSettings': additionalSettings,
    'enabled': enabled,
    'createdAt': createdAt.toIso8601String(),
    'lastUsed': lastUsed.toIso8601String(),
    'useCount': useCount,
  };

  factory ProxyConfig.fromJson(Map<String, dynamic> json) => ProxyConfig(
    name: json['name'] as String,
    type: json['type'] as String,
    host: json['host'] as String,
    port: json['port'] as int,
    username: json['username'] as String?,
    password: json['password'] as String?,
    encryption: json['encryption'] as String?,
    uuid: json['uuid'] as String?,
    additionalSettings: Map<String, dynamic>.from(json['additionalSettings'] as Map? ?? {}),
    enabled: json['enabled'] as bool,
    createdAt: DateTime.parse(json['createdAt'] as String),
    lastUsed: DateTime.parse(json['lastUsed'] as String),
    useCount: json['useCount'] as int,
  );

  ProxyConfig copyWith({
    String? name,
    String? type,
    String? host,
    int? port,
    String? username,
    String? password,
    String? encryption,
    String? uuid,
    Map<String, dynamic>? additionalSettings,
    bool? enabled,
    DateTime? lastUsed,
    int? useCount,
  }) => ProxyConfig(
    name: name ?? this.name,
    type: type ?? this.type,
    host: host ?? this.host,
    port: port ?? this.port,
    username: username ?? this.username,
    password: password ?? this.password,
    encryption: encryption ?? this.encryption,
    uuid: uuid ?? this.uuid,
    additionalSettings: additionalSettings ?? this.additionalSettings,
    enabled: enabled ?? this.enabled,
    createdAt: createdAt,
    lastUsed: lastUsed ?? this.lastUsed,
    useCount: useCount ?? this.useCount,
  );
}

/// 应用配置管理器
/// 
/// 负责管理应用配置：
/// - 配置的增删改查
/// - 配置验证
/// - 配置持久化
/// - 配置同步
class ConfigManager {
  static ConfigManager? _instance;
  static ConfigManager get instance => _instance ??= ConfigManager._();
  
  ConfigManager._();

  // 事件流控制器
  final StreamController<ConfigEvent> _eventController = StreamController.broadcast();
  Stream<ConfigEvent> get eventStream => _eventController.stream;

  // 配置存储
  final Map<String, dynamic> _memoryConfig = {};
  SharedPreferences? _prefs;
  
  // 验证规则
  final List<ConfigValidationRule> _validationRules = [];
  
  // 代理配置存储
  final Map<String, ProxyConfig> _proxyConfigs = {};
  
  // 默认配置
  static const Map<String, dynamic> _defaultConfig = {
    'proxy': {
      'type': 'HTTP',
      'host': '127.0.0.1',
      'port': 8080,
      'username': null,
      'password': null,
      'autoConnect': false,
      'timeout': 30,
      'retryAttempts': 3,
    },
    'ui': {
      'theme': 'auto',
      'language': 'zh-CN',
      'autoStart': false,
      'minimizeToTray': true,
      'showNotifications': true,
    },
    'network': {
      'dns': ['8.8.8.8', '8.8.4.4'],
      'bypassLocal': true,
      'bypassChina': false,
      'customBypassList': [],
    },
    'security': {
      'enableEncryption': true,
      'keyDerivation': 'PBKDF2',
      'saltLength': 32,
      'iterations': 10000,
    },
    'logging': {
      'level': 'info',
      'maxSize': '10MB',
      'maxFiles': 5,
      'enableConsoleOutput': kDebugMode,
    },
  };

  // 存储策略
  ConfigStorageStrategy _storageStrategy = ConfigStorageStrategy.hybrid;
  
  // 同步控制
  bool _isInitialized = false;
  Timer? _autoSaveTimer;

  /// 初始化配置管理器
  Future<bool> initialize() async {
    try {
      if (_isInitialized) return true;

      // 初始化共享偏好设置
      _prefs = await SharedPreferences.getInstance();
      
      // 设置默认配置
      _setupDefaultConfig();
      
      // 加载保存的配置
      await _loadSavedConfig();
      
      // 设置验证规则
      _setupValidationRules();
      
      // 验证当前配置
      final validationResult = await validateAllConfigs();
      if (!validationResult.isValid) {
        _emitEvent(ConfigEvent(
          type: ConfigEventType.configValidationFailed,
          key: 'general',
          message: 'Configuration validation failed: ${validationResult.errors.join(", ")}',
        ));
      }
      
      // 开始自动保存
      _startAutoSave();
      
      _isInitialized = true;
      
      _emitEvent(ConfigEvent(
        type: ConfigEventType.configLoaded,
        key: 'general',
        message: 'Configuration manager initialized',
      ));

      return true;
    } catch (e, stackTrace) {
      debugPrint('Failed to initialize config manager: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// 设置默认配置
  void _setupDefaultConfig() {
    for (final entry in _defaultConfig.entries) {
      _memoryConfig[entry.key] = entry.value;
    }
  }

  /// 加载保存的配置
  Future<void> _loadSavedConfig() async {
    try {
      for (final entry in _defaultConfig.entries) {
        final key = entry.key;
        final savedValue = _prefs?.getString(key);
        if (savedValue != null) {
          try {
            final decodedValue = jsonDecode(savedValue);
            _memoryConfig[key] = decodedValue;
          } catch (e) {
            debugPrint('Failed to parse saved config for key $key: $e');
          }
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Failed to load saved config: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// 设置验证规则
  void _setupValidationRules() {
    _validationRules.addAll([
      ConfigValidationRule(
        key: 'proxy.port',
        description: 'Proxy port must be between 1 and 65535',
        required: true,
        minValue: 1,
        maxValue: 65535,
      ),
      ConfigValidationRule(
        key: 'proxy.host',
        description: 'Proxy host is required',
        required: true,
      ),
      ConfigValidationRule(
        key: 'network.timeout',
        description: 'Timeout must be between 5 and 300 seconds',
        required: false,
        minValue: 5,
        maxValue: 300,
      ),
      ConfigValidationRule(
        key: 'logging.level',
        description: 'Log level must be one of: debug, info, warn, error',
        required: false,
        allowedValues: ['debug', 'info', 'warn', 'error'],
      ),
    ]);
  }

  /// 开始自动保存
  void _startAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      saveConfig();
    });
  }

  /// 停止自动保存
  void _stopAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
  }

  /// 获取配置值
  T? getConfig<T>(String key, [T? defaultValue]) {
    try {
      // 解析嵌套键 (如 'proxy.port')
      final keys = key.split('.');
      dynamic value = _memoryConfig;
      
      for (final k in keys) {
        if (value is Map<String, dynamic>) {
          value = value[k];
        } else {
          return defaultValue;
        }
      }
      
      return value as T?;
    } catch (e) {
      debugPrint('Error getting config $key: $e');
      return defaultValue;
    }
  }

  /// 设置配置值
  Future<bool> setConfig<T>(String key, T value) async {
    try {
      final keys = key.split('.');
      Map<String, dynamic> current = _memoryConfig;
      
      // 导航到父级配置
      for (int i = 0; i < keys.length - 1; i++) {
        final k = keys[i];
        if (!current.containsKey(k) || current[k] is! Map<String, dynamic>) {
          current[k] = <String, dynamic>{};
        }
        current = current[k] as Map<String, dynamic>;
      }
      
      // 设置值
      current[keys.last] = value;
      
      // 验证配置
      final validationResult = _validateConfig(key, value);
      if (!validationResult.isValid) {
        _emitEvent(ConfigEvent(
          type: ConfigEventType.configValidationFailed,
          key: key,
          value: value,
          message: 'Validation failed: ${validationResult.errors.join(", ")}',
        ));
        return false;
      }
      
      _emitEvent(ConfigEvent(
        type: ConfigEventType.configUpdated,
        key: key,
        value: value,
      ));
      
      return true;
    } catch (e, stackTrace) {
      debugPrint('Error setting config $key to $value: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// 删除配置
  Future<bool> removeConfig(String key) async {
    try {
      final keys = key.split('.');
      Map<String, dynamic> current = _memoryConfig;
      
      // 导航到父级配置
      for (int i = 0; i < keys.length - 1; i++) {
        final k = keys[i];
        if (!current.containsKey(k)) {
          return false;
        }
        current = current[k] as Map<String, dynamic>;
      }
      
      final removed = current.remove(keys.last);
      
      if (removed != null) {
        _emitEvent(ConfigEvent(
          type: ConfigEventType.configDeleted,
          key: key,
          value: removed,
        ));
        return true;
      }
      
      return false;
    } catch (e, stackTrace) {
      debugPrint('Error removing config $key: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// 保存配置到持久化存储
  Future<bool> saveConfig() async {
    try {
      bool success = true;
      
      for (final entry in _memoryConfig.entries) {
        final key = entry.key;
        final value = entry.value;
        
        if (_storageStrategy == ConfigStorageStrategy.memory ||;
            _storageStrategy == ConfigStorageStrategy.cloud) {
          continue;
        }
        
        try {
          final jsonString = jsonEncode(value);
          await _prefs?.setString(key, jsonString);
          
          _emitEvent(ConfigEvent(
            type: ConfigEventType.configSaved,
            key: key,
            value: value,
          ));
        } catch (e) {
          debugPrint('Failed to save config $key: $e');
          success = false;
        }
      }
      
      return success;
    } catch (e, stackTrace) {
      debugPrint('Error saving config: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// 重置配置到默认值
  Future<bool> resetConfig(String key) async {
    try {
      final defaultKeys = key.split('.');
      dynamic defaultValue = _defaultConfig;
      
      for (final k in defaultKeys) {
        if (defaultValue is Map<String, dynamic> && defaultValue.containsKey(k)) {
          defaultValue = defaultValue[k];
        } else {
          return false;
        }
      }
      
      return await setConfig(key, defaultValue);
    } catch (e, stackTrace) {
      debugPrint('Error resetting config $key: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// 验证配置
  ConfigValidationResult _validateConfig(String key, dynamic value) {
    final errors = <String>[];
    final warnings = <String>[];
    
    for (final rule in _validationRules) {
      if (!_matchesKey(rule.key, key)) continue;
      
      // 检查必需字段
      if (rule.required && (value == null || value == '')) {
        errors.add('${rule.key}: ${rule.description}');
        continue;
      }
      
      if (value == null) continue;
      
      // 检查数值范围
      if (rule.minValue != null && value is num && value < rule.minValue) {
        errors.add('${rule.key}: Value must be >= ${rule.minValue}');
      }
      
      if (rule.maxValue != null && value is num && value > rule.maxValue) {
        errors.add('${rule.key}: Value must be <= ${rule.maxValue}');
      }
      
      // 检查允许值
      if (rule.allowedValues.isNotEmpty && !rule.allowedValues.contains(value)) {
        errors.add('${rule.key}: Value must be one of ${rule.allowedValues.join(", ")}');
      }
      
      // 检查正则表达式
      if (rule.regexPattern != null && value is String && !rule.regexPattern!.hasMatch(value)) {
        errors.add('${rule.key}: Invalid format');
      }
      
      // 自定义验证
      if (rule.customValidator != null && !rule.customValidator!(value)) {
        errors.add('${rule.key}: ${rule.description}');
      }
    }
    
    return ConfigValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// 检查键是否匹配规则
  bool _matchesKey(String ruleKey, String configKey) {
    if (ruleKey == configKey) return true;
    
    // 支持通配符匹配
    if (ruleKey.endsWith('.*')) {
      final prefix = ruleKey.substring(0, ruleKey.length - 2);
      return configKey.startsWith(prefix);
    }
    
    return false;
  }

  /// 验证所有配置
  Future<ConfigValidationResult> validateAllConfigs() async {
    final errors = <String>[];
    final warnings = <String>[];
    
    for (final entry in _memoryConfig.entries) {
      final result = _validateConfig(entry.key, entry.value);
      errors.addAll(result.errors);
      warnings.addAll(result.warnings);
    }
    
    return ConfigValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  // 代理配置管理方法
  
  /// 添加代理配置
  Future<bool> addProxyConfig(ProxyConfig config) async {
    try {
      _proxyConfigs[config.name] = config;
      
      _emitEvent(ConfigEvent(
        type: ConfigEventType.configUpdated,
        key: 'proxy.${config.name}',
        value: config.toJson(),
        message: 'Proxy config added: ${config.name}',
      ));
      
      return true;
    } catch (e, stackTrace) {
      debugPrint('Error adding proxy config: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// 获取代理配置
  ProxyConfig? getProxyConfig(String name) {
    return _proxyConfigs[name];
  }

  /// 获取所有代理配置
  List<ProxyConfig> getAllProxyConfigs() {
    return _proxyConfigs.values.toList();
  }

  /// 删除代理配置
  Future<bool> removeProxyConfig(String name) async {
    try {
      final removed = _proxyConfigs.remove(name);
      
      if (removed != null) {
        _emitEvent(ConfigEvent(
          type: ConfigEventType.configDeleted,
          key: 'proxy.$name',
          value: removed.toJson(),
          message: 'Proxy config removed: $name',
        ));
        return true;
      }
      
      return false;
    } catch (e, stackTrace) {
      debugPrint('Error removing proxy config: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// 更新代理配置使用次数
  void updateProxyUsage(String name) {
    final config = _proxyConfigs[name];
    if (config != null) {
      _proxyConfigs[name] = config.copyWith(
        lastUsed: DateTime.now(),
        useCount: config.useCount + 1,
      );
    }
  }

  /// 获取当前代理配置
  ProxyConfig? getCurrentProxyConfig() {
    final proxyConfig = getConfig<Map<String, dynamic>>('proxy');
    if (proxyConfig != null) {
      return ProxyConfig.fromJson(proxyConfig);
    }
    return null;
  }

  /// 设置当前代理配置
  Future<bool> setCurrentProxyConfig(ProxyConfig config) async {
    return await setConfig('proxy', config.toJson());
  }

  /// 获取配置统计信息
  Map<String, dynamic> getStatistics() {
    return {
      'totalConfigs': _memoryConfig.length,
      'proxyConfigs': _proxyConfigs.length,
      'storageStrategy': _storageStrategy.toString(),
      'isInitialized': _isInitialized,
      'autoSaveEnabled': _autoSaveTimer != null,
      'validationRules': _validationRules.length,
      'memoryUsage': '${_memoryConfig.length} items',
    };
  }

  /// 设置存储策略
  void setStorageStrategy(ConfigStorageStrategy strategy) {
    _storageStrategy = strategy;
  }

  /// 发送配置事件
  void _emitEvent(ConfigEvent event) {
    _eventController.add(event);
  }

  /// 获取内存中的所有配置
  Map<String, dynamic> get allConfig => Map.from(_memoryConfig);

  /// 检查是否已初始化
  bool get isInitialized => _isInitialized;

  /// 释放资源
  Future<void> dispose() async {
    try {
      // 保存当前配置
      await saveConfig();
      
      // 停止自动保存
      _stopAutoSave();
      
      // 关闭事件流
      await _eventController.close();
      
      _isInitialized = false;
      _instance = null;
    } catch (e, stackTrace) {
      debugPrint('Error disposing config manager: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }
}