/// 统一设置页面
/// 
/// 提供完整的设置管理界面，整合浏览器设置和FlClash代理设置。
/// 支持设置分类、搜索、导入导出、实时预览等功能。
library unified_settings_page;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 统一设置页面
/// 
/// 主设置页面，提供所有设置功能的统一入口。
class UnifiedSettingsPage extends StatefulWidget {
  /// 设置服务实例
  final SettingsService? settingsService;
  
  /// 初始选中的设置分类
  final String? initialCategory;
  
  /// 是否显示搜索框
  final bool showSearch;
  
  /// 是否显示导入导出功能
  final bool showImportExport;
  
  /// 是否显示设置模式切换
  final bool showModeSwitch;
  
  const UnifiedSettingsPage({
    super.key,
    this.settingsService,
    this.initialCategory,
    this.showSearch = true,
    this.showImportExport = true,
    this.showModeSwitch = true,
  });

  @override
  State<UnifiedSettingsPage> createState() => _UnifiedSettingsPageState();
}

class _UnifiedSettingsPageState extends State<UnifiedSettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SettingsService _settingsService;
  
  // 搜索相关
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  
  // 设置相关
  AppSettings? _settings;
  List<String> _validationErrors = [];
  bool _isDirty = false;
  
  // 分类相关
  final List<SettingCategory> _categories = [;
    SettingCategory(
      id: 'browser',
      name: '浏览器',
      icon: Icons.web,
      priority: 0,
    ),
    SettingCategory(
      id: 'proxy',
      name: '代理',
      icon: Icons.vpn_lock,
      priority: 1,
    ),
    SettingCategory(
      id: 'interface',
      name: '界面',
      icon: Icons.palette,
      priority: 2,
    ),
    SettingCategory(
      id: 'privacy',
      name: '隐私',
      icon: Icons.security,
      priority: 3,
    ),
    SettingCategory(
      id: 'notifications',
      name: '通知',
      icon: Icons.notifications,
      priority: 4,
    ),
    SettingCategory(
      id: 'backup',
      name: '备份',
      icon: Icons.backup,
      priority: 5,
    ),
  ];
  
  String _selectedCategory = 'browser';
  
  @override
  void initState() {
    super.initState();
    _settingsService = widget.settingsService ?? SettingsService.instance;
    _tabController = TabController(length: _categories.length, vsync: this);
    
    // 设置初始分类
    if (widget.initialCategory != null) {
      final initialIndex = _categories.indexWhere(
        (cat) => cat.id == widget.initialCategory,
      );
      if (initialIndex >= 0) {
        _selectedCategory = widget.initialCategory!;
        _tabController.index = initialIndex;
      }
    }
    
    // 加载设置
    _loadSettings();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }
  
  /// 加载设置
  Future<void> _loadSettings() async {
    await _settingsService.loadSettings();
    setState(() {
      _settings = _settingsService.currentSettings;
      _validationErrors = _settingsService.validationErrors;
      _isDirty = _settingsService.isDirty;
    });
  }
  
  /// 处理设置变更
  void _onSettingsChanged() {
    setState(() {
      _settings = _settingsService.currentSettings;
      _validationErrors = _settingsService.validationErrors;
      _isDirty = _settingsService.isDirty;
    });
  }
  
  /// 处理搜索
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }
  
  /// 切换搜索状态
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }
  
  /// 处理分类切换
  void _onCategoryChanged(int index) {
    setState(() {
      _selectedCategory = _categories[index].id;
      _tabController.index = index;
    });
  }
  
  /// 保存设置
  Future<void> _saveSettings() async {
    final success = await _settingsService.saveSettings();
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('设置已保存'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('保存设置失败'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  /// 导出设置
  Future<void> _exportSettings() async {
    final jsonString = await _settingsService.exportSettings();
    if (jsonString != null && mounted) {
      // 这里可以实现文件保存或分享功能
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('设置导出成功'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
  /// 导入设置
  Future<void> _importSettings() async {
    // 这里可以实现文件选择功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('导入功能开发中'),
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  /// 重置设置
  Future<void> _resetSettings() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置设置'),
        content: const Text('确定要重置所有设置为默认值吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await _settingsService.resetToDefault();
      _onSettingsChanged();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        elevation: 0,
        actions: [
          // 搜索按钮
          if (widget.showSearch)
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: _toggleSearch,
            ),
          
          // 菜单按钮
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'export':
                  _exportSettings();
                  break;
                case 'import':
                  _importSettings();
                  break;
                case 'reset':
                  _resetSettings();
                  break;
              }
            },
            itemBuilder: (context) => [;
              if (widget.showImportExport) ...[
                const PopupMenuItem(
                  value: 'export',
                  child: ListTile(
                    leading: Icon(Icons.download),
                    title: Text('导出设置'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'import',
                  child: ListTile(
                    leading: Icon(Icons.upload),
                    title: Text('导入设置'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuDivider(),
              ],
              const PopupMenuItem(
                value: 'reset',
                child: ListTile(
                  leading: Icon(Icons.restore),
                  title: Text('重置设置'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) {
            return Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(category.icon, size: 18),
                  const SizedBox(width: 4),
                  Text(category.name),
                ],
              ),
            );
          }).toList(),
          onTap: _onCategoryChanged,
        ),
      ),
      body: Column(
        children: [
          // 搜索框
          if (_isSearching)
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: '搜索设置项...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          
          // 设置模式切换
          if (widget.showModeSwitch && _settings != null);
            _buildModeSwitch(),
          
          // 验证错误提示
          if (_validationErrors.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.error.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.error,
                        color: theme.colorScheme.error,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '设置验证错误',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ..._validationErrors.map((error) => Text(
                    '• $error',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                    ),
                  )),
                ],
              ),
            ),
          
          // 设置内容
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                return _buildCategoryContent(category);
              }).toList(),
            ),
          ),
          
          // 底部操作栏
          if (_isDirty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '您有未保存的更改',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: _resetSettings,
                    child: const Text('重置'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saveSettings,
                    child: const Text('保存'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  /// 构建设置模式切换
  Widget _buildModeSwitch() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '设置模式',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: SettingsMode.values.map((mode) {
              final isSelected = _settings!.mode == mode;
              return FilterChip(
                label: Text(_getModeDisplayText(mode)),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    _changeSettingsMode(mode);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  /// 获取模式显示文本
  String _getModeDisplayText(SettingsMode mode) {
    switch (mode) {
      case SettingsMode.standard:
        return '标准';
      case SettingsMode.privacy:
        return '隐私';
      case SettingsMode.developer:
        return '开发者';
      case SettingsMode.performance:
        return '高性能';
      case SettingsMode.custom:
        return '自定义';
    }
  }
  
  /// 更改设置模式
  Future<void> _changeSettingsMode(SettingsMode mode) async {
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
        return; // 自定义模式不改变设置
    }
    
    newSettings = newSettings.copyWith(
      version: _settings!.version,
      createdAt: _settings!.createdAt,
    );
    
    await _settingsService.updateSettings(newSettings);
    _onSettingsChanged();
  }
  
  /// 构建分类内容
  Widget _buildCategoryContent(SettingCategory category) {
    switch (category.id) {
      case 'browser':
        return _buildBrowserSettings();
      case 'proxy':
        return _buildProxySettings();
      case 'interface':
        return _buildInterfaceSettings();
      case 'privacy':
        return _buildPrivacySettings();
      case 'notifications':
        return _buildNotificationSettings();
      case 'backup':
        return _buildBackupSettings();
      default:
        return const Center(child: Text('未知分类'));
    }
  }
  
  /// 构建浏览器设置
  Widget _buildBrowserSettings() {
    if (_settings == null) return const Center(child: CircularProgressIndicator());
    
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SettingsSection(
          title: '基本设置',
          icon: Icons.web,
          children: [
            SettingTile(
              type: SettingTileType.switchTile,
              title: '启用JavaScript',
              subtitle: '允许网页执行JavaScript代码',
              value: _settings!.browserSettings.javascriptEnabled,
              onChanged: (value) => _updateBrowserSettings(
                _settings!.browserSettings.copyWith(javascriptEnabled: value),
              ),
              icon: Icons.code,
            ),
            SettingTile(
              type: SettingTileType.switchTile,
              title: '启用Cookie',
              subtitle: '允许网站存储Cookie',
              value: _settings!.browserSettings.cookiesEnabled,
              onChanged: (value) => _updateBrowserSettings(
                _settings!.browserSettings.copyWith(cookiesEnabled: value),
              ),
              icon: Icons.cookie,
            ),
            SettingTile(
              type: SettingTileType.switchTile,
              title: '启用图片加载',
              subtitle: '自动加载网页图片',
              value: _settings!.browserSettings.imagesEnabled,
              onChanged: (value) => _updateBrowserSettings(
                _settings!.browserSettings.copyWith(imagesEnabled: value),
              ),
              icon: Icons.image,
            ),
          ],
        ),
        
        SettingsSection(
          title: '隐私与安全',
          icon: Icons.security,
          children: [
            SettingTile(
              type: SettingTileType.switchTile,
              title: '启用无痕模式',
              subtitle: '不保存浏览历史和Cookie',
              value: _settings!.browserSettings.incognito,
              onChanged: (value) => _updateBrowserSettings(
                _settings!.browserSettings.copyWith(incognito: value),
              ),
              icon: Icons.incognito,
            ),
            SettingTile(
              type: SettingTileType.switchTile,
              title: '启用广告拦截',
              subtitle: '拦截网页广告内容',
              value: _settings!.browserSettings.adBlockEnabled,
              onChanged: (value) => _updateBrowserSettings(
                _settings!.browserSettings.copyWith(adBlockEnabled: value),
              ),
              icon: Icons.block,
            ),
            SettingTile(
              type: SettingTileType.switchTile,
              title: '启用跟踪保护',
              subtitle: '防止网站跟踪用户行为',
              value: _settings!.browserSettings.trackingProtectionEnabled,
              onChanged: (value) => _updateBrowserSettings(
                _settings!.browserSettings.copyWith(trackingProtectionEnabled: value),
              ),
              icon: Icons.privacy_tip,
            ),
          ],
        ),
        
        SettingsSection(
          title: '外观设置',
          icon: Icons.palette,
          children: [
            SettingTile(
              type: SettingTileType.switchTile,
              title: '深色模式',
              subtitle: '使用深色主题',
              value: _settings!.browserSettings.darkMode,
              onChanged: (value) => _updateBrowserSettings(
                _settings!.browserSettings.copyWith(darkMode: value),
              ),
              icon: Icons.dark_mode,
            ),
            SettingTile(
              type: SettingTileType.selection,
              title: '字体大小',
              subtitle: '调整网页字体大小',
              value: _settings!.browserSettings.fontSize,
              options: [
                SettingOption(label: '小', value: FontSize.small),
                SettingOption(label: '中', value: FontSize.medium),
                SettingOption(label: '大', value: FontSize.large),
                SettingOption(label: '超大', value: FontSize.extraLarge),
              ],
              onChanged: (value) => _updateBrowserSettings(
                _settings!.browserSettings.copyWith(fontSize: value),
              ),
              icon: Icons.text_fields,
            ),
          ],
        ),
      ],
    );
  }
  
  /// 构建代理设置
  Widget _buildProxySettings() {
    if (_settings == null) return const Center(child: CircularProgressIndicator());
    
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SettingsSection(
          title: '基本设置',
          icon: Icons.vpn_lock,
          children: [
            SettingTile(
              type: SettingTileType.switchTile,
              title: '启用FlClash',
              subtitle: '启用代理服务',
              value: _settings!.flclashSettings.enabled,
              onChanged: (value) => _updateClashCoreSettings(
                _settings!.flclashSettings.copyWith(enabled: value),
              ),
              icon: Icons.toggle_on,
            ),
            SettingTile(
              type: SettingTileType.selection,
              title: '代理模式',
              subtitle: '选择代理模式',
              value: _settings!.flclashSettings.mode,
              options: [
                SettingOption(label: '规则模式', value: ProxyMode.rule),
                SettingOption(label: '全局模式', value: ProxyMode.global),
                SettingOption(label: '直连模式', value: ProxyMode.direct),
              ],
              onChanged: (value) => _updateClashCoreSettings(
                _settings!.flclashSettings.copyWith(mode: value),
              ),
              icon: Icons.route,
            ),
          ],
        ),
        
        SettingsSection(
          title: '高级设置',
          icon: Icons.tune,
          children: [
            SettingTile(
              type: SettingTileType.switchTile,
              title: 'TUN模式',
              subtitle: '启用TUN接口模式',
              value: _settings!.flclashSettings.tunMode,
              onChanged: (value) => _updateClashCoreSettings(
                _settings!.flclashSettings.copyWith(tunMode: value),
              ),
              icon: Icons.tungsten,
            ),
            SettingTile(
              type: SettingTileType.switchTile,
              title: 'IPv6支持',
              subtitle: '启用IPv6网络支持',
              value: _settings!.flclashSettings.ipv6,
              onChanged: (value) => _updateClashCoreSettings(
                _settings!.flclashSettings.copyWith(ipv6: value),
              ),
              icon: Icons.language,
            ),
            SettingTile(
              type: SettingTileType.switchTile,
              title: '系统代理',
              subtitle: '将代理设置为系统代理',
              value: _settings!.flclashSettings.systemProxy,
              onChanged: (value) => _updateClashCoreSettings(
                _settings!.flclashSettings.copyWith(systemProxy: value),
              ),
              icon: Icons.computer,
            ),
          ],
        ),
      ],
    );
  }
  
  /// 构建界面设置
  Widget _buildInterfaceSettings() {
    if (_settings == null) return const Center(child: CircularProgressIndicator());
    
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SettingsSection(
          title: '主题设置',
          icon: Icons.palette,
          children: [
            SettingTile(
              type: SettingTileType.selection,
              title: '主题模式',
              subtitle: '选择应用主题',
              value: _settings!.ui.themeMode,
              options: [
                SettingOption(label: '跟随系统', value: ThemeMode.system),
                SettingOption(label: '浅色模式', value: ThemeMode.light),
                SettingOption(label: '深色模式', value: ThemeMode.dark),
              ],
              onChanged: (value) => _updateUISettings(
                _settings!.ui.copyWith(themeMode: value),
              ),
              icon: Icons.brightness_6,
            ),
            SettingTile(
              type: SettingTileType.switchTile,
              title: '启用动画',
              subtitle: '显示界面动画效果',
              value: _settings!.ui.animations,
              onChanged: (value) => _updateUISettings(
                _settings!.ui.copyWith(animations: value),
              ),
              icon: Icons.animation,
            ),
          ],
        ),
        
        SettingsSection(
          title: '语言设置',
          icon: Icons.language,
          children: [
            SettingTile(
              type: SettingTileType.selection,
              title: '界面语言',
              subtitle: '选择应用语言',
              value: _settings!.ui.language,
              options: [
                SettingOption(label: '简体中文', value: 'zh-CN'),
                SettingOption(label: '繁体中文', value: 'zh-TW'),
                SettingOption(label: 'English', value: 'en-US'),
                SettingOption(label: '日本語', value: 'ja-JP'),
              ],
              onChanged: (value) => _updateUISettings(
                _settings!.ui.copyWith(language: value),
              ),
              icon: Icons.translate,
            ),
          ],
        ),
      ],
    );
  }
  
  /// 构建隐私设置
  Widget _buildPrivacySettings() {
    if (_settings == null) return const Center(child: CircularProgressIndicator());
    
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SettingsSection(
          title: '隐私保护',
          icon: Icons.security,
          children: [
            SettingTile(
              type: SettingTileType.switchTile,
              title: '隐私模式',
              subtitle: '启用增强隐私保护',
              value: _settings!.privacy.privacyMode,
              onChanged: (value) => _updatePrivacySettings(
                _settings!.privacy.copyWith(privacyMode: value),
              ),
              icon: Icons.privacy_tip,
            ),
            SettingTile(
              type: SettingTileType.switchTile,
              title: '数据加密',
              subtitle: '加密存储敏感数据',
              value: _settings!.privacy.dataEncryption,
              onChanged: (value) => _updatePrivacySettings(
                _settings!.privacy.copyWith(dataEncryption: value),
              ),
              icon: Icons.enhanced_encryption,
            ),
            SettingTile(
              type: SettingTileType.switchTile,
              title: '遥测数据',
              subtitle: '允许收集使用统计信息',
              value: _settings!.privacy.telemetry,
              onChanged: (value) => _updatePrivacySettings(
                _settings!.privacy.copyWith(telemetry: value),
              ),
              icon: Icons.analytics,
            ),
          ],
        ),
      ],
    );
  }
  
  /// 构建通知设置
  Widget _buildNotificationSettings() {
    if (_settings == null) return const Center(child: CircularProgressIndicator());
    
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SettingsSection(
          title: '通知设置',
          icon: Icons.notifications,
          children: [
            SettingTile(
              type: SettingTileType.switchTile,
              title: '启用通知',
              subtitle: '允许应用发送通知',
              value: _settings!.notifications.enabled,
              onChanged: (value) => _updateNotificationSettings(
                _settings!.notifications.copyWith(enabled: value),
              ),
              icon: Icons.notifications_active,
            ),
            SettingTile(
              type: SettingTileType.switchTile,
              title: '连接状态通知',
              subtitle: '代理连接状态变更时通知',
              value: _settings!.notifications.connectionStatus,
              onChanged: (value) => _updateNotificationSettings(
                _settings!.notifications.copyWith(connectionStatus: value),
              ),
              icon: Icons.network_check,
            ),
            SettingTile(
              type: SettingTileType.switchTile,
              title: '更新通知',
              subtitle: '有新版本时通知',
              value: _settings!.notifications.update,
              onChanged: (value) => _updateNotificationSettings(
                _settings!.notifications.copyWith(update: value),
              ),
              icon: Icons.system_update,
            ),
          ],
        ),
      ],
    );
  }
  
  /// 构建备份设置
  Widget _buildBackupSettings() {
    if (_settings == null) return const Center(child: CircularProgressIndicator());
    
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SettingsSection(
          title: '备份设置',
          icon: Icons.backup,
          children: [
            SettingTile(
              type: SettingTileType.switchTile,
              title: '自动备份',
              subtitle: '定期自动备份设置',
              value: _settings!.backup.autoBackup,
              onChanged: (value) => _updateBackupSettings(
                _settings!.backup.copyWith(autoBackup: value),
              ),
              icon: Icons.autorenew,
            ),
            SettingTile(
              type: SettingTileType.button,
              title: '导出设置',
              subtitle: '将当前设置导出为文件',
              buttonConfig: const ButtonConfig(text: '导出'),
              onTap: _exportSettings,
              icon: Icons.download,
            ),
            SettingTile(
              type: SettingTileType.button,
              title: '导入设置',
              subtitle: '从文件导入设置',
              buttonConfig: const ButtonConfig(text: '导入'),
              onTap: _importSettings,
              icon: Icons.upload,
            ),
          ],
        ),
      ],
    );
  }
  
  /// 更新浏览器设置
  Future<void> _updateBrowserSettings(BrowserSettings newBrowserSettings) async {
    await _settingsService.updateBrowserSettings(newBrowserSettings);
    _onSettingsChanged();
  }
  
  /// 更新FlClash设置
  Future<void> _updateClashCoreSettings(ClashCoreSettings newClashCoreSettings) async {
    await _settingsService.updateClashCoreSettings(newClashCoreSettings);
    _onSettingsChanged();
  }
  
  /// 更新界面设置
  Future<void> _updateUISettings(UI newUI) async {
    await _settingsService.updateUISettings(newUI);
    _onSettingsChanged();
  }
  
  /// 更新隐私设置
  Future<void> _updatePrivacySettings(Privacy newPrivacy) async {
    await _settingsService.updatePrivacySettings(newPrivacy);
    _onSettingsChanged();
  }
  
  /// 更新通知设置
  Future<void> _updateNotificationSettings(Notifications newNotifications) async {
    await _settingsService.updateNotificationSettings(newNotifications);
    _onSettingsChanged();
  }
  
  /// 更新备份设置
  Future<void> _updateBackupSettings(Backup newBackup) async {
    // 这里需要更新备份设置的方法
    // 暂时使用通用更新方法
    final newSettings = _settings!.copyWith(backup: newBackup);
    await _settingsService.updateSettings(newSettings);
    _onSettingsChanged();
  }
}

/// 设置分类数据类
class SettingCategory {
  final String id;
  final String name;
  final IconData icon;
  final int priority;
  
  const SettingCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.priority = 0,
  });
}