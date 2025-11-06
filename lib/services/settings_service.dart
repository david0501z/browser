/// 设置服务
/// 
/// 负责设置的保存、加载、验证、导入导出等功能。
/// 支持设置的版本控制和迁移。
library settings_service;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// 设置服务类
/// 
/// 提供统一的设置管理功能，包括：
/// - 设置的保存和加载
/// - 设置验证和错误处理
/// - 设置导入和导出
/// - 设置版本控制和迁移
/// - 设置实时预览
class SettingsService extends ChangeNotifier {
  static SettingsService? _instance;
  static SettingsService get instance => _instance ??= SettingsService._();
  
  SettingsService._();
  
  /// 设置文件路径
  static const String _settingsFileName = 'app_settings.json';
  static const String _backupFileName = 'app_settings_backup.json';
  
  /// 当前设置
  AppSettings? _currentSettings;
  AppSettings? get currentSettings => _currentSettings;
  
  /// 设置是否已加载
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  
  /// 验证错误列表
  List<String> _validationErrors = [];
  List<String> get validationErrors => _validationErrors;
  
  /// 是否有验证错误
  bool get hasValidationErrors => _validationErrors.isNotEmpty;
  
  /// 设置是否已修改
  bool _isDirty = false;
  bool get isDirty => _isDirty;
  
  /// 加载设置
  /// 
  /// 从本地文件加载设置，如果文件不存在则创建默认设置
  Future<void> loadSettings() async {
    try {
      final directory = await _getStorageDirectory();
      final file = File('${directory.path}/$_settingsFileName');
      
      if (await file.exists()) {
        final content = await file.readAsString();
        final jsonData = jsonDecode(content);
        _currentSettings = AppSettings.fromJson(jsonData);
      } else {
        // 创建默认设置
        _currentSettings = AppSettingsUtils.createDefault();
        await saveSettings();
      }
      
      _isLoaded = true;
      _isDirty = false;
      _validationErrors.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('加载设置失败: $e');
      // 如果加载失败，使用默认设置
      _currentSettings = AppSettingsUtils.createDefault();
      _isLoaded = true;
      _isDirty = false;
      notifyListeners();
    }
  }
  
  /// 保存设置
  /// 
  /// 将当前设置保存到本地文件
  Future<bool> saveSettings() async {
    if (_currentSettings == null) return false;
    
    try {
      final directory = await _getStorageDirectory();
      final file = File('${directory.path}/$_settingsFileName');
      
      // 先备份当前设置
      await _backupCurrentSettings(directory);
      
      // 保存新设置
      final jsonData = _currentSettings!.toJson();
      await file.writeAsString(jsonEncode(jsonData));
      
      _isDirty = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('保存设置失败: $e');
      return false;
    }
  }
  
  /// 更新设置
  /// 
  /// 更新当前设置并验证
  Future<bool> updateSettings(AppSettings newSettings) async {
    _currentSettings = newSettings.copyWith(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    
    // 验证设置
    _validateCurrentSettings();
    
    _isDirty = true;
    notifyListeners();
    
    return true;
  }
  
  /// 更新浏览器设置
  Future<bool> updateBrowserSettings(BrowserSettings browserSettings) async {
    if (_currentSettings == null) return false;
    
    _currentSettings = _currentSettings!.copyWith(
      browserSettings: browserSettings,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    
    _validateCurrentSettings();
    _isDirty = true;
    notifyListeners();
    
    return true;
  }
  
  /// 更新FlClash设置
  Future<bool> updateClashCoreSettings(ClashCoreSettings flclashSettings) async {
    if (_currentSettings == null) return false;
    
    _currentSettings = _currentSettings!.copyWith(
      flclashSettings: flclashSettings,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    
    _validateCurrentSettings();
    _isDirty = true;
    notifyListeners();
    
    return true;
  }
  
  /// 更新界面设置
  Future<bool> updateUISettings(UI ui) async {
    if (_currentSettings == null) return false;
    
    _currentSettings = _currentSettings!.copyWith(
      ui: ui,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    
    _isDirty = true;
    notifyListeners();
    
    return true;
  }
  
  /// 更新通知设置
  Future<bool> updateNotificationSettings(Notifications notifications) async {
    if (_currentSettings == null) return false;
    
    _currentSettings = _currentSettings!.copyWith(
      notifications: notifications,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    
    _isDirty = true;
    notifyListeners();
    
    return true;
  }
  
  /// 更新隐私设置
  Future<bool> updatePrivacySettings(Privacy privacy) async {
    if (_currentSettings == null) return false;
    
    _currentSettings = _currentSettings!.copyWith(
      privacy: privacy,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    
    _isDirty = true;
    notifyListeners();
    
    return true;
  }
  
  /// 重置为默认设置
  Future<bool> resetToDefault() async {
    _currentSettings = AppSettingsUtils.createDefault();
    _validationErrors.clear();
    _isDirty = true;
    notifyListeners();
    return true;
  }
  
  /// 重置为隐私模式
  Future<bool> resetToPrivacyMode() async {
    _currentSettings = AppSettingsUtils.createPrivacyMode();
    _validationErrors.clear();
    _isDirty = true;
    notifyListeners();
    return true;
  }
  
  /// 重置为开发者模式
  Future<bool> resetToDeveloperMode() async {
    _currentSettings = AppSettingsUtils.createDeveloperMode();
    _validationErrors.clear();
    _isDirty = true;
    notifyListeners();
    return true;
  }
  
  /// 重置为高性能模式
  Future<bool> resetToPerformanceMode() async {
    _currentSettings = AppSettingsUtils.createPerformanceMode();
    _validationErrors.clear();
    _isDirty = true;
    notifyListeners();
    return true;
  }
  
  /// 导出设置
  /// 
  /// 将当前设置导出为JSON字符串
  Future<String?> exportSettings() async {
    if (_currentSettings == null) return null;
    
    try {
      final exportData = AppSettingsUtils.exportToJson(_currentSettings!);
      return jsonEncode(exportData);
    } catch (e) {
      debugPrint('导出设置失败: $e');
      return null;
    }
  }
  
  /// 导入设置
  /// 
  /// 从JSON字符串导入设置
  Future<bool> importSettings(String jsonString) async {
    try {
      final jsonData = jsonDecode(jsonString);
      final importedSettings = AppSettingsUtils.importFromJson(jsonData);
      
      if (importedSettings != null) {
        // 备份当前设置
        final directory = await _getStorageDirectory();
        await _backupCurrentSettings(directory);
        
        _currentSettings = importedSettings;
        _validateCurrentSettings();
        _isDirty = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('导入设置失败: $e');
      return false;
    }
  }
  
  /// 验证当前设置
  void _validateCurrentSettings() {
    if (_currentSettings == null) {
      _validationErrors = [];
      return;
    }
    
    _validationErrors = _currentSettings!.validateSettings();
  }
  
  /// 备份当前设置
  Future<void> _backupCurrentSettings(Directory directory) async {
    try {
      final backupFile = File('${directory.path}/$_backupFileName');
      if (_currentSettings != null) {
        final jsonData = _currentSettings!.toJson();
        await backupFile.writeAsString(jsonEncode(jsonData));
      }
    } catch (e) {
      debugPrint('备份设置失败: $e');
    }
  }
  
  /// 获取存储目录
  Future<Directory> _getStorageDirectory() async {
    if (kIsWeb) {
      // Web平台使用临时目录
      return Directory.systemTemp;
    } else if (Platform.isAndroid || Platform.isIOS) {
      // 移动平台使用应用文档目录
      return await getApplicationDocumentsDirectory();
    } else {
      // 桌面平台使用应用支持目录
      return await getApplicationSupportDirectory();
    }
  }
  
  /// 获取设置统计信息
  Map<String, dynamic> getSettingsStats() {
    if (_currentSettings == null) {
      return {};
    }
    
    return {
      'version': _currentSettings!.version,
      'mode': _currentSettings!.mode.name,
      'browserSettings': {
        'javascriptEnabled': _currentSettings!.browserSettings.javascriptEnabled,
        'cookiesEnabled': _currentSettings!.browserSettings.cookiesEnabled,
        'darkMode': _currentSettings!.browserSettings.darkMode,
        'privacyMode': _currentSettings!.browserSettings.privacyMode.name,
      },
      'flclashSettings': {
        'enabled': _currentSettings!.flclashSettings.enabled,
        'mode': _currentSettings!.flclashSettings.mode.name,
        'tunMode': _currentSettings!.flclashSettings.tunMode,
      },
      'ui': {
        'themeMode': _currentSettings!.ui.themeMode.name,
        'language': _currentSettings!.ui.language,
        'animations': _currentSettings!.ui.animations,
      },
      'privacy': {
        'privacyMode': _currentSettings!.privacy.privacyMode,
        'dataEncryption': _currentSettings!.privacy.dataEncryption,
        'telemetry': _currentSettings!.privacy.telemetry,
      },
      'updatedAt': _currentSettings!.updatedAt,
      'isDirty': _isDirty,
      'hasValidationErrors': hasValidationErrors,
    };
  }
  
  /// 清理临时文件
  Future<void> cleanupTempFiles() async {
    try {
      final directory = await _getStorageDirectory();
      final files = directory.listSync();
      
      for (final file in files) {
        if (file is File && file.path.contains('temp_')) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('清理临时文件失败: $e');
    }
  }
  
  /// 获取设置描述
  String getSettingsDescription() {
    if (_currentSettings == null) return '';
    
    final mode = _currentSettings!.mode;
    final parts = <String>[];
    
    switch (mode) {
      case SettingsMode.standard:
        parts.add('标准模式');
        break;
      case SettingsMode.privacy:
        parts.add('隐私模式');
        parts.add('增强隐私保护');
        break;
      case SettingsMode.developer:
        parts.add('开发者模式');
        parts.add('启用调试功能');
        break;
      case SettingsMode.performance:
        parts.add('高性能模式');
        parts.add('优化性能设置');
        break;
      case SettingsMode.custom:
        parts.add('自定义模式');
        break;
    }
    
    if (_currentSettings!.flclashSettings.enabled) {
      parts.add('代理已启用');
    }
    
    if (_currentSettings!.browserSettings.darkMode) {
      parts.add('深色主题');
    }
    
    return parts.join(' · ');
  }
}

/// 设置变更监听器
/// 
/// 用于监听设置变更的抽象类。
abstract class SettingsChangeListener {
  /// 设置变更回调
  void onSettingsChanged(AppSettings newSettings);
  
  /// 设置验证错误回调
  void onValidationErrors(List<String> errors);
  
  /// 设置保存状态变更回调
  void onSaveStateChanged(bool isDirty);
}

/// 设置变更监听器管理器
class SettingsChangeListeners {
  static final _listeners = <SettingsChangeListener>{
  
  /// 添加监听器
  static void addListener(SettingsChangeListener listener) {
    _listeners.add(listener);
  }
  
  /// 移除监听器
  static void removeListener(SettingsChangeListener listener) {
    _listeners.remove(listener);
  }
}
  
  /// 通知所有监听器设置已变更
  static void notifySettingsChanged(AppSettings newSettings) {
    for (final listener in _listeners) {
      listener.onSettingsChanged(newSettings);
    }
  }
  
  /// 通知所有监听器验证错误
  static void notifyValidationErrors(List<String> errors) {
    for (final listener in _listeners) {
      listener.onValidationErrors(errors);
    }
  }
  
  /// 通知所有监听器保存状态变更
  static void notifySaveStateChanged(bool isDirty) {
    for (final listener in _listeners) {
      listener.onSaveStateChanged(isDirty);
    }
  }
}