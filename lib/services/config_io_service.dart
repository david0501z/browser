/// 配置 I/O 服务
/// 
/// 处理配置的读取、写入、保存、导入、导出等操作

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import '../models/app_settings.dart';
import '../config/clash_config_generator.dart';
import '../config/yaml_parser.dart';
import '../config/config_validator.dart';
import '../config/config_template_manager.dart';

/// 配置操作结果
class ConfigOperationResult {
  final bool success;
  final String? filePath;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;
  final Duration? operationDuration;
  final DateTime timestamp;

  const ConfigOperationResult({
    required this.success,
    this.filePath,
    this.errorMessage,
    this.metadata,
    this.operationDuration,
    required this.timestamp,
  });

  /// 创建成功结果
  factory ConfigOperationResult.success({
    String? filePath,
    Map<String, dynamic>? metadata,
    Duration? operationDuration,
  }) {
    return ConfigOperationResult(
      success: true,
      filePath: filePath,
      metadata: metadata,
      operationDuration: operationDuration,
      timestamp: DateTime.now(),
    );
  }

  /// 创建失败结果
  factory ConfigOperationResult.failure(String errorMessage) {
    return ConfigOperationResult(
      success: false,
      errorMessage: errorMessage,
      timestamp: DateTime.now(),
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('=== 配置操作结果 ===');
    buffer.writeln('操作时间: ${timestamp.toIso8601String()}');
    buffer.writeln('操作状态: ${success ? "成功" : "失败"}');
    
    if (filePath != null) {
      buffer.writeln('文件路径: $filePath');
    }
    
    if (errorMessage != null) {
      buffer.writeln('错误信息: $errorMessage');
    }
    
    if (operationDuration != null) {
      buffer.writeln('操作耗时: ${operationDuration.inMilliseconds}ms');
    }
    
    if (metadata != null && metadata!.isNotEmpty) {
      buffer.writeln('元数据:');
      metadata!.forEach((key, value) {
        buffer.writeln('  $key: $value');
      });
    }
    
    return buffer.toString();
  }
}

/// 配置 I/O 服务类
class ConfigIOService {
  static final Logger _logger = Logger('ConfigIOService');
  
  /// 应用文档目录
  static const String _appConfigDir = 'flclash_configs';
  
  /// 配置文件扩展名
  static const String _configExtension = '.yaml';
  
  /// 备份目录
  static const String _backupDir = 'backups';
  
  /// 临时目录
  static const String _tempDir = 'temp';
  
  /// 配置缓存
  final Map<String, String> _configCache = {};
  
  /// 配置监控文件列表
  final List<String> _watchedFiles = [];
  
  /// SharedPreferences 键名常量
  static const String _prefsLastConfigPath = 'last_config_path';
  static const String _prefsAutoSaveEnabled = 'auto_save_enabled';
  static const String _prefsBackupCount = 'backup_count';
  static const String _prefsConfigHistory = 'config_history';

  /// 初始化服务
  Future<void> initialize() async {
    _logger.info('初始化配置 I/O 服务');
    
    await _ensureDirectoriesExist();
    await _loadCachedConfigs();
    
    _logger.info('配置 I/O 服务初始化完成');
  }

  /// 保存配置到文件
  /// 
  /// [config] FlClashSettings 配置
  /// [filePath] 可选的文件路径，为空则使用默认路径
  /// [proxyList] 代理列表
  /// [overwrite] 是否覆盖已存在的文件
  Future<ConfigOperationResult> saveConfig(
    FlClashSettings config, {
    String? filePath,
    List<ProxyConfig>? proxyList,
    bool overwrite = false,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('开始保存配置');
      
      // 生成配置文件内容
      final generator = ClashConfigGenerator();
      final yamlContent = generator.generateClashConfig(config, proxyList: proxyList);
      
      // 验证配置
      final validator = ConfigValidator();
      final validationResult = validator.validateSettings(config, proxyList: proxyList);
      
      if (!validationResult.isValid) {
        return ConfigOperationResult.failure(
          '配置验证失败: ${validationResult.errors.join(", ")}',
        );
      }
      
      // 确定文件路径
      final targetFilePath = filePath ?? await _getDefaultConfigPath();
      
      // 检查文件是否已存在
      final file = File(targetFilePath);
      if (await file.exists() && !overwrite) {
        return ConfigOperationResult.failure('文件已存在: $targetFilePath');
      }
      
      // 创建目录
      await file.parent.create(recursive: true);
      
      // 写入文件
      await file.writeAsString(yamlContent);
      
      // 更新缓存
      _configCache[targetFilePath] = yamlContent;
      
      // 保存最后使用的配置文件路径
      await _saveLastConfigPath(targetFilePath);
      
      // 自动备份
      if (overwrite) {
        await _createBackup(targetFilePath);
      }
      
      stopwatch.stop();
      
      _logger.info('配置保存成功: $targetFilePath');
      
      return ConfigOperationResult.success(
        filePath: targetFilePath,
        metadata: {
          'config_size': yamlContent.length,
          'proxy_count': proxyList?.length ?? 0,
          'validation_errors': validationResult.errors.length,
          'validation_warnings': validationResult.warnings.length,
        },
        operationDuration: stopwatch.elapsed,
      );
      
    } catch (e) {
      stopwatch.stop();
      _logger.warning('保存配置失败: $e');
      
      return ConfigOperationResult.failure('保存配置失败: $e');
    }
  }

  /// 从文件加载配置
  /// 
  /// [filePath] 配置文件路径
  Future<ParseResult?> loadConfig(String filePath) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('开始加载配置: $filePath');
      
      // 检查缓存
      if (_configCache.containsKey(filePath)) {
        final cachedContent = _configCache[filePath]!;
        final parser = YamlParser();
        final result = parser.parseConfig(cachedContent);
        
        stopwatch.stop();
        _logger.info('从缓存加载配置成功: $filePath');
        return result;
      }
      
      // 检查文件是否存在
      final file = File(filePath);
      if (!await file.exists()) {
        throw ConfigIOException('配置文件不存在: $filePath');
      }
      
      // 读取文件内容
      final content = await file.readAsString();
      
      // 解析配置
      final parser = YamlParser();
      final result = parser.parseConfig(content);
      
      // 更新缓存
      _configCache[filePath] = content;
      
      // 保存到历史记录
      await _addToHistory(filePath);
      
      stopwatch.stop();
      
      _logger.info('配置加载成功: $filePath');
      
      return result;
      
    } catch (e) {
      stopwatch.stop();
      _logger.warning('加载配置失败: $e');
      return null;
    }
  }

  /// 导入配置文件
  /// 
  /// [sourcePath] 源文件路径
  /// [targetPath] 目标路径，可选
  /// [validate] 是否验证配置
  Future<ConfigOperationResult> importConfig(
    String sourcePath, {
    String? targetPath,
    bool validate = true,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('开始导入配置: $sourcePath');
      
      // 检查源文件
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        return ConfigOperationResult.failure('源文件不存在: $sourcePath');
      }
      
      // 读取并解析配置
      final parser = YamlParser();
      final parseResult = await parser.parseConfigFromFile(sourcePath);
      
      // 验证配置（如果需要）
      if (validate) {
        final validator = ConfigValidator();
        final validationResult = validator.validateYamlContent(parseResult.rawYaml);
        
        if (!validationResult.isValid) {
          return ConfigOperationResult.failure(
            '配置验证失败: ${validationResult.errors.join(", ")}',
          );
        }
      }
      
      // 确定目标路径
      final targetFilePath = targetPath ?? await _generateImportPath(sourcePath);
      
      // 保存导入的配置
      final targetFile = File(targetFilePath);
      await targetFile.create(recursive: true);
      await targetFile.writeAsString(parseResult.rawYaml);
      
      // 更新缓存
      _configCache[targetFilePath] = parseResult.rawYaml;
      
      stopwatch.stop();
      
      _logger.info('配置导入成功: $targetFilePath');
      
      return ConfigOperationResult.success(
        filePath: targetFilePath,
        metadata: {
          'source_path': sourcePath,
          'config_size': parseResult.rawYaml.length,
          'proxy_count': parseResult.proxyList.length,
          'rule_count': parseResult.rules.length,
        },
        operationDuration: stopwatch.elapsed,
      );
      
    } catch (e) {
      stopwatch.stop();
      _logger.warning('导入配置失败: $e');
      
      return ConfigOperationResult.failure('导入配置失败: $e');
    }
  }

  /// 导出配置文件
  /// 
  /// [sourcePath] 源配置文件路径
  /// [targetPath] 目标路径
  /// [format] 导出格式
  Future<ConfigOperationResult> exportConfig(
    String sourcePath, {
    required String targetPath,
    ExportFormat format = ExportFormat.yaml,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('开始导出配置: $sourcePath -> $targetPath');
      
      // 检查源文件
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        return ConfigOperationResult.failure('源文件不存在: $sourcePath');
      }
      
      // 读取配置
      final content = await sourceFile.readAsString();
      
      // 处理导出格式
      String exportContent;
      Map<String, dynamic> metadata = {};
      
      switch (format) {
        case ExportFormat.yaml:
          exportContent = content;
          metadata['format'] = 'yaml';
          break;
        case ExportFormat.json:
          final parser = YamlParser();
          final parseResult = parser.parseConfig(content);
          exportContent = JsonEncoder.withIndent('  ').convert({
            'config': parseResult.config.toJson(),
            'proxies': parseResult.proxyList.map((p) => _proxyToJson(p)).toList(),
            'rules': parseResult.rules,
            'exported_at': DateTime.now().toIso8601String(),
            'version': '1.0',
          });
          metadata['format'] = 'json';
          break;
      }
      
      // 写入目标文件
      final targetFile = File(targetPath);
      await targetFile.create(recursive: true);
      await targetFile.writeAsString(exportContent);
      
      stopwatch.stop();
      
      _logger.info('配置导出成功: $targetPath');
      
      return ConfigOperationResult.success(
        filePath: targetPath,
        metadata: {
          'source_path': sourcePath,
          'export_size': exportContent.length,
          ...metadata,
        },
        operationDuration: stopwatch.elapsed,
      );
      
    } catch (e) {
      stopwatch.stop();
      _logger.warning('导出配置失败: $e');
      
      return ConfigOperationResult.failure('导出配置失败: $e');
    }
  }

  /// 删除配置文件
  /// 
  /// [filePath] 要删除的文件路径
  /// [createBackup] 是否创建备份
  Future<ConfigOperationResult> deleteConfig(
    String filePath, {
    bool createBackup = true,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('开始删除配置: $filePath');
      
      final file = File(filePath);
      if (!await file.exists()) {
        return ConfigOperationResult.failure('文件不存在: $filePath');
      }
      
      // 创建备份（如果需要）
      if (createBackup) {
        await _createBackup(filePath);
      }
      
      // 删除文件
      await file.delete();
      
      // 从缓存中移除
      _configCache.remove(filePath);
      
      stopwatch.stop();
      
      _logger.info('配置删除成功: $filePath');
      
      return ConfigOperationResult.success(
        filePath: filePath,
        metadata: {'backup_created': createBackup},
        operationDuration: stopwatch.elapsed,
      );
      
    } catch (e) {
      stopwatch.stop();
      _logger.warning('删除配置失败: $e');
      
      return ConfigOperationResult.failure('删除配置失败: $e');
    }
  }

  /// 列出配置文件
  /// 
  /// [directory] 目录路径，为空则使用默认配置目录
  /// [recursive] 是否递归搜索
  Future<List<ConfigFileInfo>> listConfigs({
    String? directory,
    bool recursive = false,
  }) async {
    try {
      final targetDir = directory ?? await _getDefaultConfigDirectory();
      final dir = Directory(targetDir);
      
      if (!await dir.exists()) {
        return [];
      }
      
      final configFiles = <ConfigFileInfo>[];
      final fileList = recursive 
          ? await dir.list(recursive: true).toList()
          : await dir.list().toList();
      
      for (final entity in fileList) {
        if (entity is File && entity.path.endsWith(_configExtension)) {
          try {
            final stat = await entity.stat();
            final content = await entity.readAsString();
            final parser = YamlParser();
            final configInfo = parser.extractConfigInfo(content);
            
            configFiles.add(ConfigFileInfo(
              path: entity.path,
              name: entity.uri.pathSegments.last,
              size: stat.size,
              modified: stat.modified,
              proxyCount: configInfo.proxyCount,
              ruleCount: configInfo.ruleCount,
              configType: configInfo.configType,
            ));
          } catch (e) {
            _logger.warning('解析配置文件失败: ${entity.path}, 错误: $e');
          }
        }
      }
      
      // 按修改时间排序
      configFiles.sort((a, b) => b.modified.compareTo(a.modified));
      
      return configFiles;
      
    } catch (e) {
      _logger.warning('列出配置文件失败: $e');
      return [];
    }
  }

  /// 搜索配置文件
  /// 
  /// [query] 搜索关键词
  /// [directory] 搜索目录
  Future<List<ConfigFileInfo>> searchConfigs(String query, {String? directory}) async {
    final allConfigs = await listConfigs(directory: directory);
    final normalizedQuery = query.toLowerCase();
    
    return allConfigs.where((config) {
      return config.name.toLowerCase().contains(normalizedQuery) ||
             config.path.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  /// 创建配置备份
  /// 
  /// [filePath] 要备份的文件路径
  /// [backupName] 备份文件名（可选）
  Future<String?> createBackup(String filePath, {String? backupName}) async {
    try {
      final sourceFile = File(filePath);
      if (!await sourceFile.exists()) {
        return null;
      }
      
      final backupDir = await _getBackupDirectory();
      final fileName = backupName ?? 
          '${DateTime.now().millisecondsSinceEpoch}_${sourceFile.uri.pathSegments.last}';
      final backupPath = '$backupDir/$fileName';
      
      await sourceFile.copy(backupPath);
      
      // 清理旧备份
      await _cleanupOldBackups();
      
      _logger.info('备份创建成功: $backupPath');
      return backupPath;
      
    } catch (e) {
      _logger.warning('创建备份失败: $e');
      return null;
    }
  }

  /// 恢复配置备份
  /// 
  /// [backupPath] 备份文件路径
  /// [targetPath] 目标路径
  Future<ConfigOperationResult> restoreBackup(String backupPath, {String? targetPath}) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      _logger.info('开始恢复备份: $backupPath');
      
      final backupFile = File(backupPath);
      if (!await backupFile.exists()) {
        return ConfigOperationResult.failure('备份文件不存在: $backupPath');
      }
      
      final targetFilePath = targetPath ?? await _getDefaultConfigPath();
      final targetFile = File(targetFilePath);
      
      // 创建当前配置的备份
      if (await targetFile.exists()) {
        await _createBackup(targetFilePath);
      }
      
      // 恢复配置
      await backupFile.copy(targetFilePath);
      
      // 更新缓存
      final content = await targetFile.readAsString();
      _configCache[targetFilePath] = content;
      
      stopwatch.stop();
      
      _logger.info('备份恢复成功: $targetFilePath');
      
      return ConfigOperationResult.success(
        filePath: targetFilePath,
        metadata: {
          'backup_path': backupPath,
          'restored_at': DateTime.now().toIso8601String(),
        },
        operationDuration: stopwatch.elapsed,
      );
      
    } catch (e) {
      stopwatch.stop();
      _logger.warning('恢复备份失败: $e');
      
      return ConfigOperationResult.failure('恢复备份失败: $e');
    }
  }

  /// 获取配置历史记录
  /// 
  /// [limit] 返回记录数量限制
  Future<List<ConfigHistoryEntry>> getConfigHistory({int limit = 20}) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_prefsConfigHistory);
    
    if (historyJson == null) {
      return [];
    }
    
    try {
      final historyList = json.decode(historyJson) as List;
      final entries = historyList
          .map((entry) => ConfigHistoryEntry.fromJson(entry as Map<String, dynamic>))
          .toList();
      
      // 按时间倒序排列并限制数量
      entries.sort((a, b) => b.accessedAt.compareTo(a.accessedAt));
      
      return entries.take(limit).toList();
      
    } catch (e) {
      _logger.warning('解析配置历史记录失败: $e');
      return [];
    }
  }

  /// 清空配置缓存
  void clearCache() {
    _configCache.clear();
    _logger.info('配置缓存已清空');
  }

  /// 启用配置文件监控
  /// 
  /// [filePath] 要监控的文件路径
  void watchConfigFile(String filePath) {
    if (!_watchedFiles.contains(filePath)) {
      _watchedFiles.add(filePath);
      
      final file = File(filePath);
      if (file.existsSync()) {
        file.watch().listen((event) {
          _logger.info('配置文件变更: $filePath, 事件类型: $event');
          // 清除缓存中的对应条目
          _configCache.remove(filePath);
        });
      }
    }
  }

  /// 获取最后使用的配置文件路径
  Future<String?> getLastConfigPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsLastConfigPath);
  }

  /// 确保目录存在
  Future<void> _ensureDirectoriesExist() async {
    final dirs = [
      await _getDefaultConfigDirectory(),
      await _getBackupDirectory(),
      await _getTempDirectory(),
    ];
    
    for (final dirPath in dirs) {
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    }
  }

  /// 获取默认配置目录
  Future<String> _getDefaultConfigDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    return '${appDir.path}/$_appConfigDir';
  }

  /// 获取默认配置文件路径
  Future<String> _getDefaultConfigPath() async {
    final configDir = await _getDefaultConfigDirectory();
    return '$configDir/config$_configExtension';
  }

  /// 获取备份目录
  Future<String> _getBackupDirectory() async {
    final configDir = await _getDefaultConfigDirectory();
    return '$configDir/$_backupDir';
  }

  /// 获取临时目录
  Future<String> _getTempDirectory() async {
    final configDir = await _getDefaultConfigDirectory();
    return '$configDir/$_tempDir';
  }

  /// 生成导入路径
  Future<String> _generateImportPath(String sourcePath) async {
    final configDir = await _getDefaultConfigDirectory();
    final sourceFileName = File(sourcePath).uri.pathSegments.last;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final baseName = sourceFileName.replaceAll(_configExtension, '');
    return '$configDir/${baseName}_import_$timestamp$_configExtension';
  }

  /// 创建备份
  Future<void> _createBackup(String filePath) async {
    await createBackup(filePath);
  }

  /// 清理旧备份
  Future<void> _cleanupOldBackups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final maxBackups = prefs.getInt(_prefsBackupCount) ?? 10;
      
      final backupDir = await _getBackupDirectory();
      final dir = Directory(backupDir);
      
      if (!await dir.exists()) return;
      
      final backupFiles = await dir.list().toList();
      backupFiles.sort((a, b) => 
          FileSystemEntity.statSync(b.path).modified.compareTo(
              FileSystemEntity.statSync(a.path).modified));
      
      // 删除超出限制的备份文件
      for (int i = maxBackups; i < backupFiles.length; i++) {
        if (backupFiles[i] is File) {
          await (backupFiles[i] as File).delete();
        }
      }
      
    } catch (e) {
      _logger.warning('清理旧备份失败: $e');
    }
  }

  /// 加载缓存的配置
  Future<void> _loadCachedConfigs() async {
    final configDir = await _getDefaultConfigDirectory();
    final dir = Directory(configDir);
    
    if (!await dir.exists()) return;
    
    final files = await dir.list().toList();
    for (final entity in files) {
      if (entity is File && entity.path.endsWith(_configExtension)) {
        try {
          final content = await entity.readAsString();
          _configCache[entity.path] = content;
        } catch (e) {
          _logger.warning('加载缓存配置失败: ${entity.path}, 错误: $e');
        }
      }
    }
  }

  /// 保存最后配置路径
  Future<void> _saveLastConfigPath(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsLastConfigPath, filePath);
  }

  /// 添加到历史记录
  Future<void> _addToHistory(String filePath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_prefsConfigHistory);
      
      List<ConfigHistoryEntry> history = [];
      if (historyJson != null) {
        final historyList = json.decode(historyJson) as List;
        history = historyList
            .map((entry) => ConfigHistoryEntry.fromJson(entry as Map<String, dynamic>))
            .toList();
      }
      
      // 移除已存在的相同路径记录
      history.removeWhere((entry) => entry.filePath == filePath);
      
      // 添加新记录
      history.insert(0, ConfigHistoryEntry(
        filePath: filePath,
        name: File(filePath).uri.pathSegments.last,
        accessedAt: DateTime.now(),
      ));
      
      // 限制历史记录数量
      if (history.length > 50) {
        history = history.take(50).toList();
      }
      
      // 保存历史记录
      final historyListJson = json.encode(history.map((e) => e.toJson()).toList());
      await prefs.setString(_prefsConfigHistory, historyListJson);
      
    } catch (e) {
      _logger.warning('更新配置历史失败: $e');
    }
  }

  /// 将代理转换为 JSON
  Map<String, dynamic> _proxyToJson(ProxyConfig proxy) {
    return {
      'name': proxy.name,
      'type': proxy.type.toString(),
      'server': proxy.host,
      'port': proxy.port,
    };
  }
}

/// 配置文件信息
class ConfigFileInfo {
  final String path;
  final String name;
  final int size;
  final DateTime modified;
  final int proxyCount;
  final int ruleCount;
  final ConfigType configType;

  const ConfigFileInfo({
    required this.path,
    required this.name,
    required this.size,
    required this.modified,
    required this.proxyCount,
    required this.ruleCount,
    required this.configType,
  });

  @override
  String toString() {
    return 'ConfigFileInfo{name: $name, proxyCount: $proxyCount, ruleCount: $ruleCount, size: $size bytes, modified: $modified}';
  }
}

/// 配置历史记录
class ConfigHistoryEntry {
  final String filePath;
  final String name;
  final DateTime accessedAt;

  const ConfigHistoryEntry({
    required this.filePath,
    required this.name,
    required this.accessedAt,
  });

  factory ConfigHistoryEntry.fromJson(Map<String, dynamic> json) {
    return ConfigHistoryEntry(
      filePath: json['filePath'] as String,
      name: json['name'] as String,
      accessedAt: DateTime.parse(json['accessedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'name': name,
      'accessedAt': accessedAt.toIso8601String(),
    };
  }
}

/// 配置 I/O 异常
class ConfigIOException implements Exception {
  final String message;
  
  const ConfigIOException(this.message);
  
  @override
  String toString() => 'ConfigIOException: $message';
}

/// 导出格式枚举
enum ExportFormat {
  yaml,
  json,
}
