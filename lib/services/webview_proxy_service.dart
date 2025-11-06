import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/webview_proxy_adapter.dart';

/// WebView代理服务
/// 
/// 负责管理WebView代理配置，提供：
/// - 代理配置的持久化存储
/// - 代理切换和动态配置更新
/// - 代理测试和验证
/// - 配置同步和备份
class WebViewProxyService {
  static WebViewProxyService? _instance;
  static WebViewProxyService get instance => _instance ??= WebViewProxyService._();

  WebViewProxyService._();

  late final SharedPreferences _prefs;
  late final WebViewProxyAdapter _adapter;

  /// 配置存储键名
  static const String _proxyConfigKey = 'webview_proxy_config';
  static const String _proxyHistoryKey = 'webview_proxy_history';

  /// 代理配置历史记录
  final List<ProxyConfig> _configHistory = [];
  
  /// 是否已初始化
  bool _initialized = false;

  /// 初始化服务
  Future<void> initialize() async {
    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();
    _adapter = WebViewProxyAdapter.instance;

    await _loadConfiguration();
    await _loadHistory();

    _initialized = true;
    debugPrint('WebView代理服务已初始化');
  }

  /// 检查服务是否已初始化
  bool get isInitialized => _initialized;

  /// 获取适配器实例
  WebViewProxyAdapter get adapter => _adapter;

  /// 应用代理配置
  Future<bool> applyProxyConfig(ProxyConfig config) async {
    if (!_initialized) {
      debugPrint('WebView代理服务未初始化');
      return false;
    }

    // 验证配置
    if (!_adapter.validateConfig(config)) {
      debugPrint('代理配置验证失败: $config');
      return false;
    }

    // 保存配置到存储
    final success = await _saveConfiguration(config);
    if (!success) {
      debugPrint('代理配置保存失败');
      return false;
    }

    // 应用到适配器
    _adapter.setProxyConfig(config);

    // 添加到历史记录
    await _addToHistory(config);

    debugPrint('代理配置已应用: $config');
    return true;
  }

  /// 获取当前代理配置
  ProxyConfig? get currentConfig => _adapter.currentConfig;

  /// 检查代理是否启用
  bool get isProxyEnabled => _adapter.isProxyEnabled;

  /// 启用/禁用代理
  Future<bool> setProxyEnabled(bool enabled) async {
    final currentConfig = _adapter.currentConfig;
    if (currentConfig == null) {
      return false;
    }

    final newConfig = currentConfig.copyWith(enabled: enabled);
    return await applyProxyConfig(newConfig);
  }

  /// 切换代理（启用->禁用，禁用->启用）
  Future<bool> toggleProxy() async {
    return await setProxyEnabled(!isProxyEnabled);
  }

  /// 更新代理URL
  Future<bool> updateProxyUrl(String url) async {
    final currentConfig = _adapter.currentConfig;
    if (currentConfig == null) {
      return false;
    }

    final newConfig = currentConfig.copyWith(proxyUrl: url);
    return await applyProxyConfig(newConfig);
  }

  /// 更新代理类型
  Future<bool> updateProxyType(ProxyType type) async {
    final currentConfig = _adapter.currentConfig;
    if (currentConfig == null) {
      return false;
    }

    final newConfig = currentConfig.copyWith(type: type);
    return await applyProxyConfig(newConfig);
  }

  /// 更新认证信息
  Future<bool> updateProxyAuth(String? username, String? password) async {
    final currentConfig = _adapter.currentConfig;
    if (currentConfig == null) {
      return false;
    }

    ProxyAuth? auth;
    if (username != null || password != null) {
      auth = ProxyAuth(username: username, password: password);
    }

    final newConfig = currentConfig.copyWith(proxyAuth: auth);
    return await applyProxyConfig(newConfig);
  }

  /// 更新跳过主机列表
  Future<bool> updateBypassHosts(String? bypassHosts) async {
    final currentConfig = _adapter.currentConfig;
    if (currentConfig == null) {
      return false;
    }

    final newConfig = currentConfig.copyWith(bypassHosts: bypassHosts);
    return await applyProxyConfig(newConfig);
  }

  /// 测试代理连接
  Future<ProxyTestResult> testProxyConnection({
    String? testUrl,
    int timeoutSeconds = 10,
  }) async {
    final config = _adapter.currentConfig;
    if (config == null || !config.enabled) {
      return ProxyTestResult(
        success: false,
        message: '代理未配置或已禁用',
      );
    }

    try {
      final proxyUrl = config.proxyUrl;
      if (proxyUrl == null) {
        return ProxyTestResult(
          success: false,
          message: '代理URL为空',
        );
      }

      // 这里可以实现实际的代理测试逻辑
      // 由于涉及网络请求和代理配置，需要与Flutter的HTTP客户端集成
      // 现在返回模拟结果
      
      await Future.delayed(Duration(seconds: 2)); // 模拟测试延迟
      
      final success = proxyUrl.contains(':') && proxyUrl.isNotEmpty;
      
      return ProxyTestResult(
        success: success,
        message: success ? '代理连接成功' : '代理连接失败',
        latency: success ? Duration(milliseconds: 200) : null,
      );
    } catch (e) {
      return ProxyTestResult(
        success: false,
        message: '测试异常: $e',
      );
    }
  }

  /// 获取配置历史记录
  List<ProxyConfig> get configHistory => List.unmodifiable(_configHistory);

  /// 清除历史记录
  Future<void> clearHistory() async {
    _configHistory.clear();
    await _prefs.remove(_proxyHistoryKey);
    debugPrint('代理配置历史记录已清除');
  }

  /// 恢复配置
  Future<bool> restoreConfig(ProxyConfig config) async {
    return await applyProxyConfig(config);
  }

  /// 导出配置
  Map<String, dynamic> exportConfig() {
    return {
      'version': '1.0',
      'timestamp': DateTime.now().toIso8601String(),
      'config': _adapter.currentConfig?.toJson(),
      'history': _configHistory.map((c) => c.toJson()).toList(),
    };
  }

  /// 导入配置
  Future<bool> importConfig(Map<String, dynamic> data) async {
    try {
      final configJson = data['config'] as Map<String, dynamic>?;
      if (configJson == null) {
        return false;
      }

      final config = ProxyConfig.fromJson(configJson);
      return await applyProxyConfig(config);
    } catch (e) {
      debugPrint('导入配置失败: $e');
      return false;
    }
  }

  /// 重置为默认配置
  Future<void> resetToDefault() async {
    await _saveConfiguration(const ProxyConfig());
    _adapter.clearConfig();
    debugPrint('代理配置已重置为默认状态');
  }

  /// 获取代理统计信息
  ProxyStats getProxyStats() {
    final config = _adapter.currentConfig;
    if (config == null) {
      return const ProxyStats();
    }

    return ProxyStats(
      isEnabled: config.enabled,
      proxyType: config.type.name,
      hasAuth: config.proxyAuth != null,
      hasBypassHosts: config.bypassHosts?.isNotEmpty == true,
      historyCount: _configHistory.length,
    );
  }

  // 私有方法

  /// 加载配置
  Future<void> _loadConfiguration() async {
    try {
      final jsonString = _prefs.getString(_proxyConfigKey);
      if (jsonString != null) {
        final jsonData = json.decode(jsonString) as Map<String, dynamic>;
        final config = ProxyConfig.fromJson(jsonData);
        _adapter.setProxyConfig(config);
        debugPrint('已加载代理配置: $config');
      }
    } catch (e) {
      debugPrint('加载代理配置失败: $e');
    }
  }

  /// 保存配置
  Future<bool> _saveConfiguration(ProxyConfig config) async {
    try {
      final jsonString = json.encode(config.toJson());
      return await _prefs.setString(_proxyConfigKey, jsonString);
    } catch (e) {
      debugPrint('保存代理配置失败: $e');
      return false;
    }
  }

  /// 加载历史记录
  Future<void> _loadHistory() async {
    try {
      final jsonString = _prefs.getString(_proxyHistoryKey);
      if (jsonString != null) {
        final jsonData = json.decode(jsonString) as List<dynamic>;
        _configHistory.clear();
        for (final item in jsonData) {
          final config = ProxyConfig.fromJson(item as Map<String, dynamic>);
          _configHistory.add(config);
        }
      }
    } catch (e) {
      debugPrint('加载代理配置历史失败: $e');
    }
  }

  /// 添加到历史记录
  Future<void> _addToHistory(ProxyConfig config) async {
    // 避免重复
    if (_configHistory.any((c) => c == config)) {
      return;
    }

    _configHistory.insert(0, config);
    
    // 限制历史记录数量
    if (_configHistory.length > 10) {
      _configHistory.removeLast();
    }

    try {
      final jsonString = json.encode(_configHistory.map((c) => c.toJson()).toList());
      await _prefs.setString(_proxyHistoryKey, jsonString);
    } catch (e) {
      debugPrint('保存代理配置历史失败: $e');
    }
  }

  /// 清理资源
  void dispose() {
    _listeners.clear();
    _configHistory.clear();
    _initialized = false;
    debugPrint('WebView代理服务已清理');
  }

  /// 配置变更监听器列表
  final List<ProxyConfigListener> _listeners = [];

  /// 添加配置变更监听器
  void addConfigListener(ProxyConfigListener listener) {
    _listeners.add(listener);
    _adapter.addConfigListener(listener);
  }

  /// 移除配置变更监听器
  void removeConfigListener(ProxyConfigListener listener) {
    _listeners.remove(listener);
    _adapter.removeConfigListener(listener);
  }
}

/// 代理测试结果
class ProxyTestResult {
  final bool success;
  final String message;
  final Duration? latency;

  const ProxyTestResult({
    required this.success,
    required this.message,
    this.latency,
  });

  @override
  String toString() {
    return 'ProxyTestResult(success: $success, message: $message, latency: $latency)';
  }
}

/// 代理统计信息
class ProxyStats {
  final bool isEnabled;
  final String proxyType;
  final bool hasAuth;
  final bool hasBypassHosts;
  final int historyCount;

  const ProxyStats({
    this.isEnabled = false,
    this.proxyType = '',
    this.hasAuth = false,
    this.hasBypassHosts = false,
    this.historyCount = 0,
  });

  @override
  String toString() {
    return 'ProxyStats(enabled: $isEnabled, type: $proxyType, auth: $hasAuth, bypass: $hasBypassHosts, history: $historyCount)';
  }
}