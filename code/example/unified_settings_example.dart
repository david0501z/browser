/// 统一设置系统使用示例
/// 
/// 演示如何在应用中使用统一设置系统。
library unified_settings_example;

import 'package:flutter/material.dart';
import '../pages/unified_settings_page.dart';
import '../services/settings_service.dart';
import '../models/app_settings.dart';

/// 设置示例页面
/// 
/// 演示统一设置系统的各种使用方式。
class SettingsExamplePage extends StatefulWidget {
  const SettingsExamplePage({super.key});

  @override
  State<SettingsExamplePage> createState() => _SettingsExamplePageState();
}

class _SettingsExamplePageState extends State<SettingsExamplePage> {
  late SettingsService _settingsService;
  
  @override
  void initState() {
    super.initState();
    _settingsService = SettingsService.instance;
    _initializeSettings();
  }
  
  /// 初始化设置
  Future<void> _initializeSettings() async {
    await _settingsService.loadSettings();
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置系统示例'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _openSettings(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 设置概览
          _buildSettingsOverview(),
          
          const SizedBox(height: 24),
          
          // 快速操作
          _buildQuickActions(),
          
          const SizedBox(height: 24),
          
          // 设置统计
          _buildSettingsStats(),
          
          const SizedBox(height: 24),
          
          // 模式切换
          _buildModeSwitcher(),
          
          const SizedBox(height: 24),
          
          // 导入导出示例
          _buildImportExportExample(),
        ],
      ),
    );
  }
  
  /// 构建设置概览
  Widget _buildSettingsOverview() {
    final settings = _settingsService.currentSettings;
    
    if (settings == null) {
      return const Card(
        child: ListTile(
          leading: CircularProgressIndicator(),
          title: Text('正在加载设置...'),
        ),
      );
    }
    
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('设置概览'),
            subtitle: Text('当前应用设置状态'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('设置模式', settings.modeDisplayText),
                _buildInfoRow('浏览器JavaScript', 
                    settings.browserSettings.javascriptEnabled ? '已启用' : '已禁用'),
                _buildInfoRow('FlClash代理', 
                    settings.flclashSettings.enabled ? '已启用' : '已禁用'),
                _buildInfoRow('深色模式', 
                    settings.browserSettings.darkMode ? '已启用' : '已禁用'),
                _buildInfoRow('隐私模式', 
                    settings.privacy.privacyMode ? '已启用' : '已禁用'),
                _buildInfoRow('最后更新', 
                    _formatTimestamp(settings.updatedAt)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建快速操作
  Widget _buildQuickActions() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            leading: Icon(Icons.flash_on),
            title: Text('快速操作'),
            subtitle: Text('常用的设置操作'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _openSettings(),
                  icon: const Icon(Icons.settings),
                  label: const Text('打开设置'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _applyPrivacyMode(),
                  icon: const Icon(Icons.security),
                  label: const Text('隐私模式'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _applyDeveloperMode(),
                  icon: const Icon(Icons.developer_mode),
                  label: const Text('开发者模式'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _applyPerformanceMode(),
                  icon: const Icon(Icons.speed),
                  label: const Text('高性能模式'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _resetToDefault(),
                  icon: const Icon(Icons.restore),
                  label: const Text('重置默认'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建设置统计
  Widget _buildSettingsStats() {
    final stats = _settingsService.getSettingsStats();
    
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            leading: Icon(Icons.analytics),
            title: Text('设置统计'),
            subtitle: Text('详细的设置数据分析'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('浏览器功能', 
                        '${stats['browserSettings']?['javascriptEnabled'] == true ? 1 : 0}/1'),
                    _buildStatItem('代理功能', 
                        '${stats['flclashSettings']?['enabled'] == true ? 1 : 0}/1'),
                    _buildStatItem('隐私功能', 
                        '${stats['privacy']?['privacyMode'] == true ? 1 : 0}/1'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('界面主题', 
                        stats['ui']?['themeMode'] ?? 'unknown'),
                    _buildStatItem('语言', 
                        stats['ui']?['language'] ?? 'unknown'),
                    _buildStatItem('动画', 
                        stats['ui']?['animations'] == true ? '开启' : '关闭'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建模式切换器
  Widget _buildModeSwitcher() {
    final settings = _settingsService.currentSettings;
    
    if (settings == null) return const SizedBox.shrink();
    
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            leading: Icon(Icons.tune),
            title: Text('设置模式'),
            subtitle: Text('快速切换预设配置'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildModeButton(
                        '标准模式',
                        Icons.standard,
                        SettingsMode.standard,
                        settings.mode == SettingsMode.standard,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildModeButton(
                        '隐私模式',
                        Icons.security,
                        SettingsMode.privacy,
                        settings.mode == SettingsMode.privacy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildModeButton(
                        '开发者模式',
                        Icons.developer_mode,
                        SettingsMode.developer,
                        settings.mode == SettingsMode.developer,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildModeButton(
                        '高性能模式',
                        Icons.speed,
                        SettingsMode.performance,
                        settings.mode == SettingsMode.performance,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建导入导出示例
  Widget _buildImportExportExample() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            leading: Icon(Icons.backup),
            title: Text('设置备份'),
            subtitle: Text('导入导出设置配置'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _exportSettings,
                        icon: const Icon(Icons.download),
                        label: const Text('导出设置'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _importSettings,
                        icon: const Icon(Icons.upload),
                        label: const Text('导入设置'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '导出的设置将以JSON格式保存，可以用于备份或分享给其他设备。',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建信息行
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
  
  /// 构建统计项
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  /// 构建模式按钮
  Widget _buildModeButton(
    String label,
    IconData icon,
    SettingsMode mode,
    bool selected,
  ) {
    return ElevatedButton(
      onPressed: () => _changeMode(mode),
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.blue : null,
        foregroundColor: selected ? Colors.white : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
  
  /// 格式化时间戳
  String _formatTimestamp(int timestamp) {
    if (timestamp == 0) return '从未更新';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
           '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
  
  /// 打开设置页面
  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UnifiedSettingsPage(),
      ),
    );
  }
  
  /// 应用隐私模式
  Future<void> _applyPrivacyMode() async {
    await _settingsService.resetToPrivacyMode();
    setState(() {});
    _showMessage('已应用隐私模式');
  }
  
  /// 应用开发者模式
  Future<void> _applyDeveloperMode() async {
    await _settingsService.resetToDeveloperMode();
    setState(() {});
    _showMessage('已应用开发者模式');
  }
  
  /// 应用高性能模式
  Future<void> _applyPerformanceMode() async {
    await _settingsService.resetToPerformanceMode();
    setState(() {});
    _showMessage('已应用高性能模式');
  }
  
  /// 重置为默认设置
  Future<void> _resetToDefault() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认重置'),
        content: const Text('确定要重置所有设置为默认值吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await _settingsService.resetToDefault();
      setState(() {});
      _showMessage('已重置为默认设置');
    }
  }
  
  /// 切换模式
  Future<void> _changeMode(SettingsMode mode) async {
    AppSettings newSettings;
    
    switch (mode) {
      case SettingsMode.standard:
        newSettings = AppSettingsUtils.createDefault();
        break;
      case SettingsMode.privacy:
        newSettings = AppSettingsUtils.createPrivacyMode();
        break;
      case SettingsMode.developer:
        newSettings = AppSettingsUtils.createDeveloperMode();
        break;
      case SettingsMode.performance:
        newSettings = AppSettingsUtils.createPerformanceMode();
        break;
      case SettingsMode.custom:
        return;
    }
    
    await _settingsService.updateSettings(newSettings);
    setState(() {});
    _showMessage('已切换到${newSettings.modeDisplayText}');
  }
  
  /// 导出设置
  Future<void> _exportSettings() async {
    final jsonString = await _settingsService.exportSettings();
    if (jsonString != null) {
      // 这里可以实现文件保存或分享功能
      _showMessage('设置导出成功，长度: ${jsonString.length} 字符');
      
      // 示例：显示导出的JSON（实际应用中应该保存到文件）
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('导出的设置'),
          content: SingleChildScrollView(
            child: SelectableText(jsonString),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('关闭'),
            ),
          ],
        ),
      );
    } else {
      _showMessage('设置导出失败');
    }
  }
  
  /// 导入设置
  Future<void> _importSettings() async {
    // 这里可以实现文件选择功能
    // 暂时使用示例JSON进行演示
    final exampleJson = '''
    {
      "version": "1.0.0",
      "createdAt": 1234567890000,
      "updatedAt": 1234567890000,
      "mode": "standard",
      "browserSettings": {
        "javascriptEnabled": true,
        "cookiesEnabled": true,
        "darkMode": false
      },
      "flclashSettings": {
        "enabled": false,
        "mode": "rule"
      },
      "ui": {
        "themeMode": "system",
        "language": "zh-CN",
        "animations": true
      },
      "notifications": {
        "enabled": true,
        "connectionStatus": true,
        "update": true
      },
      "privacy": {
        "privacyMode": false,
        "dataEncryption": true,
        "telemetry": false
      },
      "backup": {
        "autoBackup": false,
        "backupInterval": 7,
        "cloudBackup": false
      }
    }
    ''';
    
    final success = await _settingsService.importSettings(exampleJson);
    if (success) {
      setState(() {});
      _showMessage('设置导入成功');
    } else {
      _showMessage('设置导入失败');
    }
  }
  
  /// 显示消息
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// 主示例应用
/// 
/// 演示如何在应用入口使用统一设置系统。
class SettingsExampleApp extends StatelessWidget {
  const SettingsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '统一设置系统示例',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SettingsExamplePage(),
      routes: {
        '/settings': (context) => const UnifiedSettingsPage(),
      },
    );
  }
}

/// 示例：如何在主应用中使用设置系统
class MainAppWithSettings extends StatefulWidget {
  const MainAppWithSettings({super.key});

  @override
  State<MainAppWithSettings> createState() => _MainAppWithSettingsState();
}

class _MainAppWithSettingsState extends State<MainAppWithSettings> {
  late SettingsService _settingsService;
  
  @override
  void initState() {
    super.initState();
    _settingsService = SettingsService.instance;
    _initializeApp();
  }
  
  /// 初始化应用
  Future<void> _initializeApp() async {
    await _settingsService.loadSettings();
    
    // 应用设置到UI主题
    _applyTheme();
    
    // 监听设置变更
    SettingsChangeListeners.addListener(_settingsListener);
  }
  
  @override
  void dispose() {
    SettingsChangeListeners.removeListener(_settingsListener);
    super.dispose();
  }
  
  /// 应用主题设置
  void _applyTheme() {
    final settings = _settingsService.currentSettings;
    if (settings != null) {
      // 这里可以根据设置动态调整应用主题
      // 例如：根据ui.themeMode设置MaterialApp的主题模式
    }
  }
  
  /// 设置变更监听器
  SettingsChangeListener _settingsListener = SettingsChangeListener(
    onSettingsChanged: (newSettings) {
      // 设置变更时重新应用主题
      _applyTheme();
    },
    onValidationErrors: (errors) {
      // 处理验证错误
      print('设置验证错误: $errors');
    },
    onSaveStateChanged: (isDirty) {
      // 处理保存状态变更
      print('设置保存状态: ${isDirty ? "有未保存的更改" : "已保存"}');
    },
  );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('主应用'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: const Center(
        child: Text('主应用界面'),
      ),
    );
  }
}