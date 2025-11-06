/// 代理设置页面
/// 
/// 提供完整的代理服务设置和管理界面。
/// 集成代理模式选择、状态控制、配置管理等功能。
library proxy_settings_page;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 代理设置页面
/// 
/// 提供代理服务的完整设置和管理界面，包括：
/// - 代理模式选择和切换
/// - 代理服务状态控制
/// - 连接配置管理
/// - 高级设置选项
/// - 状态监控和诊断
class ProxySettingsPage extends ConsumerStatefulWidget {
  /// 设置服务实例
  final SettingsService? settingsService;
  
  /// 初始代理模式
  final ProxyMode? initialMode;
  
  /// 是否自动连接
  final bool autoConnect;
  
  /// 是否显示高级设置
  final bool showAdvancedSettings;
  
  /// 是否允许模式切换
  final bool allowModeSwitching;
  
  const ProxySettingsPage({
    super.key,
    this.settingsService,
    this.initialMode,
    this.autoConnect = false,
    this.showAdvancedSettings = true,
    this.allowModeSwitching = true,
  });

  @override
  ConsumerState<ProxySettingsPage> createState() => _ProxySettingsPageState();
}

class _ProxySettingsPageState extends ConsumerState<ProxySettingsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late SettingsService _settingsService;
  
  // 页面状态
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;
  ProxyMode _selectedMode = ProxyMode.rule;
  bool _isFlClashEnabled = false;
  
  // 控制相关
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _settingsService = widget.settingsService ?? SettingsService.instance;
    _selectedMode = widget.initialMode ?? ProxyMode.rule;
    
    // 初始化Tab控制器
    _tabController = TabController(length: 3, vsync: this);
    
    // 初始化FAB动画
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    );
    
    // 加载初始设置
    _loadSettings();
    
    // 监听设置变化
    _tabController.addListener(() {
      setState(() {});
    });
    
    // 监听滚动事件，控制FAB显示
    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && !_fabController.isAnimating) {
        _fabController.forward();
      } else if (_scrollController.offset <= 100 && _fabController.isAnimating) {
        _fabController.reverse();
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _fabController.dispose();
    super.dispose();
  }
  
  /// 加载设置
  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await _settingsService.loadSettings();
      final settings = _settingsService.currentSettings;
      
      setState(() {
        _isFlClashEnabled = settings?.flclashSettings.enabled ?? false;
        _hasUnsavedChanges = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('加载设置失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  /// 保存设置
  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final success = await _settingsService.saveSettings();
      
      if (mounted) {
        if (success) {
          setState(() {
            _hasUnsavedChanges = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('设置已保存'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('保存设置失败'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存设置失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  /// 重置设置
  Future<void> _resetSettings() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置设置'),
        content: const Text('确定要重置所有代理设置为默认值吗？此操作不可撤销。'),
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
      // 重置为默认设置
      final defaultSettings = AppSettingsUtils.createDefault();
      await _settingsService.updateSettings(defaultSettings);
      setState(() {
        _selectedMode = ProxyMode.rule;
        _isFlClashEnabled = false;
        _hasUnsavedChanges = true;
      });
    }
  }
  
  /// 更新代理模式
  void _updateProxyMode(ProxyMode mode) {
    setState(() {
      _selectedMode = mode;
      _hasUnsavedChanges = true;
    });
  }
  
  /// 更新FlClash启用状态
  void _updateFlClashEnabled(bool enabled) {
    setState(() {
      _isFlClashEnabled = enabled;
      _hasUnsavedChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('代理设置'),
        elevation: 0,
        actions: [
          // 设置菜单
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'reset':
                  _resetSettings();
                  break;
                case 'export':
                  _exportSettings();
                  break;
                case 'import':
                  _importSettings();
                  break;
              }
            },
            itemBuilder: (context) => [;
              const PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('导出配置'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'import',
                child: ListTile(
                  leading: Icon(Icons.upload),
                  title: Text('导入配置'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
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
          tabs: const [
            Tab(text: '基础设置'),
            Tab(text: '高级设置'),
            Tab(text: '状态监控'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildBasicSettings(),
                _buildAdvancedSettings(),
                _buildStatusMonitoring(),
              ],
            ),
      floatingActionButton: _hasUnsavedChanges
          ? FadeTransition(
              opacity: _fabAnimation,
              child: FloatingActionButton(
                onPressed: _saveSettings,
                child: const Icon(Icons.save),
              ),
            )
          : null,
    );
  }
  
  /// 构建基础设置页面
  Widget _buildBasicSettings() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 代理控制面板
          ProxyControlPanel(
            showTrafficStats: true,
            showQuickActions: true,
            showServerInfo: true,
            compact: false,
          ),
          
          const SizedBox(height: 16),
          
          // 代理模式选择
          ProxyModeSelector(
            selectedMode: _selectedMode,
            onModeChanged: widget.allowModeSwitching ? _updateProxyMode : null,
            disabled: !widget.allowModeSwitching || !_isFlClashEnabled,
            showDescriptions: true,
            compact: false,
          ),
          
          const SizedBox(height: 16),
          
          // 基本配置设置
          SettingsSection(
            title: '基本配置',
            icon: Icons.settings,
            children: [
              SettingTile(
                type: SettingTileType.switchTile,
                title: '启用FlClash代理',
                subtitle: '开启或关闭FlClash代理服务',
                value: _isFlClashEnabled,
                onChanged: _updateFlClashEnabled,
                icon: Icons.toggle_on,
              ),
              
              SettingTile(
                type: SettingTileType.switchTile,
                title: '开机自启动',
                subtitle: '应用启动时自动连接代理',
                value: ref.watch(autoConnectSettingsProvider).autoConnectOnStartup,
                onChanged: (value) => _updateAutoConnectSettings(
                  autoConnectOnStartup: value,
                ),
                icon: Icons.power,
                enabled: _isFlClashEnabled,
              ),
              
              SettingTile(
                type: SettingTileType.switchTile,
                title: '自动重连',
                subtitle: '连接断开时自动尝试重新连接',
                value: ref.watch(autoConnectSettingsProvider).autoReconnect,
                onChanged: (value) => _updateAutoConnectSettings(
                  autoReconnect: value,
                ),
                icon: Icons.refresh,
                enabled: _isFlClashEnabled,
              ),
              
              SettingTile(
                type: SettingTileType.switchTile,
                title: '系统代理',
                subtitle: '将代理设置为系统代理',
                value: ref.watch(systemProxySettingsProvider).enabled,
                onChanged: (value) => _updateSystemProxySettings(
                  enabled: value,
                ),
                icon: Icons.computer,
                enabled: _isFlClashEnabled,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// 构建高级设置页面
  Widget _buildAdvancedSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 高级配置
          SettingsSection(
            title: '网络设置',
            icon: Icons.network_check,
            children: [
              SettingTile(
                type: SettingTileType.switchTile,
                title: 'IPv6支持',
                subtitle: '启用IPv6网络连接支持',
                value: false, // 需要从实际设置中获取
                onChanged: (value) => _updateAdvancedSettings('ipv6', value),
                icon: Icons.language,
                enabled: _isFlClashEnabled,
              ),
              
              SettingTile(
                type: SettingTileType.switchTile,
                title: 'TUN模式',
                subtitle: '启用TUN接口模式（实验性）',
                value: false, // 需要从实际设置中获取
                onChanged: (value) => _updateAdvancedSettings('tun_mode', value),
                icon: Icons.tungsten,
                enabled: _isFlClashEnabled,
                hasWarning: true,
                warningMessage: 'TUN模式仍在实验阶段，可能影响性能',
              ),
              
              SettingTile(
                type: SettingTileType.selection,
                title: '连接协议',
                subtitle: '选择代理连接协议',
                value: ProxyProtocol.socks5,
                options: [
                  const SettingOption(label: 'SOCKS5', value: ProxyProtocol.socks5),
                  const SettingOption(label: 'HTTP', value: ProxyProtocol.http),
                  const SettingOption(label: 'HTTPS', value: ProxyProtocol.https),
                ],
                onChanged: (value) => _updateAdvancedSettings('protocol', value),
                icon: Icons.security,
                enabled: _isFlClashEnabled,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 性能设置
          SettingsSection(
            title: '性能设置',
            icon: Icons.speed,
            children: [
              SettingTile(
                type: SettingTileType.selection,
                title: '连接超时',
                subtitle: '连接超时时间（秒）',
                value: 30,
                options: [
                  const SettingOption(label: '15秒', value: 15),
                  const SettingOption(label: '30秒', value: 30),
                  const SettingOption(label: '60秒', value: 60),
                ],
                onChanged: (value) => _updateAdvancedSettings('timeout', value),
                icon: Icons.timer,
                enabled: _isFlClashEnabled,
              ),
              
              SettingTile(
                type: SettingTileType.switchTile,
                title: '连接池',
                subtitle: '启用连接池以提高性能',
                value: true,
                onChanged: (value) => _updateAdvancedSettings('connection_pool', value),
                icon: Icons.people,
                enabled: _isFlClashEnabled,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 安全设置
          SettingsSection(
            title: '安全设置',
            icon: Icons.security,
            children: [
              SettingTile(
                type: SettingTileType.switchTile,
                title: 'DNS加密',
                subtitle: '使用加密DNS查询',
                value: true,
                onChanged: (value) => _updateAdvancedSettings('dns_encryption', value),
                icon: Icons.dns,
                enabled: _isFlClashEnabled,
              ),
              
              SettingTile(
                type: SettingTileType.switchTile,
                title: '流量混淆',
                subtitle: '启用流量混淆以绕过检测',
                value: false,
                onChanged: (value) => _updateAdvancedSettings('traffic_obfuscation', value),
                icon: Icons.shuffle,
                enabled: _isFlClashEnabled,
                hasWarning: true,
                warningMessage: '可能影响连接速度',
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// 构建状态监控页面
  Widget _buildStatusMonitoring() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 当前状态
          SettingsSection(
            title: '连接状态',
            icon: Icons.info,
            children: [
              // 这里可以添加状态监控相关组件
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('状态监控功能开发中'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 日志记录
          SettingsSection(
            title: '日志记录',
            icon: Icons.history,
            children: [
              SettingTile(
                type: SettingTileType.switchTile,
                title: '启用连接日志',
                subtitle: '记录代理连接日志信息',
                value: true,
                onChanged: (value) => _updateAdvancedSettings('connection_log', value),
                icon: Icons.note_add,
                enabled: _isFlClashEnabled,
              ),
              
              SettingTile(
                type: SettingTileType.selection,
                title: '日志级别',
                subtitle: '选择日志记录的详细程度',
                value: LogLevel.info,
                options: [
                  const SettingOption(label: '调试', value: LogLevel.debug),
                  const SettingOption(label: '信息', value: LogLevel.info),
                  const SettingOption(label: '警告', value: LogLevel.warning),
                  const SettingOption(label: '错误', value: LogLevel.error),
                ],
                onChanged: (value) => _updateAdvancedSettings('log_level', value),
                icon: Icons.privacy_tip,
                enabled: _isFlClashEnabled,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// 更新自动连接设置
  void _updateAutoConnectSettings({
    bool? autoConnectOnStartup,
    bool? autoReconnect,
    int? reconnectInterval,
    int? maxReconnectAttempts,
  }) {
    final currentSettings = ref.read(autoConnectSettingsProvider);
    final newSettings = currentSettings.copyWith(
      autoConnectOnStartup: autoConnectOnStartup,
      autoReconnect: autoReconnect,
      reconnectInterval: reconnectInterval,
      maxReconnectAttempts: maxReconnectAttempts,
    );
    
    // 这里需要更新设置的逻辑
    setState(() {
      _hasUnsavedChanges = true;
    });
  }
  
  /// 更新系统代理设置
  void _updateSystemProxySettings({
    bool? enabled,
    String? httpProxy,
    String? httpsProxy,
    String? socksProxy,
    List<String>? bypassList,
  }) {
    final currentSettings = ref.read(systemProxySettingsProvider);
    final newSettings = currentSettings.copyWith(
      enabled: enabled,
      httpProxy: httpProxy,
      httpsProxy: httpsProxy,
      socksProxy: socksProxy,
      bypassList: bypassList,
    );
    
    // 这里需要更新设置的逻辑
    setState(() {
      _hasUnsavedChanges = true;
    });
  }
  
  /// 更新高级设置
  void _updateAdvancedSettings(String key, dynamic value) {
    // 这里需要实现高级设置的更新逻辑
    setState(() {
      _hasUnsavedChanges = true;
    });
  }
  
  /// 导出配置
  void _exportSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('配置导出功能开发中'),
      ),
    );
  }
  
  /// 导入配置
  void _importSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('配置导入功能开发中'),
      ),
    );
  }
}

/// 代理设置页面样式
class ProxySettingsPageStyles {
  /// 页面内边距
  static const EdgeInsets pagePadding = EdgeInsets.all(16);
  
  /// 组件间距
  static const double componentSpacing = 16.0;
  
  /// Tab高度
  static const double tabHeight = 48.0;
  
  /// FAB边距
  static const EdgeInsets fabMargin = EdgeInsets.all(16);
  
  /// 滚动控制器阈值
  static const double scrollThreshold = 100.0;
  
  /// 动画持续时间
  static const Duration animationDuration = Duration(milliseconds: 300);
}