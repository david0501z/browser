/// 代理模式切换UI演示
/// 
/// 演示如何使用代理模式切换UI组件的示例代码。
/// 包含完整的集成示例和使用说明。
library proxy_ui_demo;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/proxy/index.dart';
import '../pages/proxy_settings_page.dart';
import '../models/enums.dart';
import '../themes/browser_theme.dart';

/// 代理UI组件演示页面
/// 
/// 展示所有代理UI组件的完整用法，包括：
/// - 代理模式选择器
/// - 代理控制面板
/// - 代理状态指示器
/// - 集成使用示例
class ProxyUIDemo extends ConsumerStatefulWidget {
  const ProxyUIDemo({super.key});

  @override
  ConsumerState<ProxyUIDemo> createState() => _ProxyUIDemoState();
}

class _ProxyUIDemoState extends ConsumerState<ProxyUIDemo>
    with TickerProviderStateMixin {
  late TabController _tabController;
  ProxyMode _selectedMode = ProxyMode.rule;
  ProxyStatus _proxyStatus = ProxyStatus.disconnected;
  bool _isConnected = false;
  DateTime? _connectionStartTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // 模拟代理状态变化
    _simulateProxyStatusChanges();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  /// 模拟代理状态变化
  void _simulateProxyStatusChanges() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _proxyStatus = ProxyStatus.connecting;
        });
      }
      
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _proxyStatus = ProxyStatus.connected;
            _isConnected = true;
            _connectionStartTime = DateTime.now();
          });
        }
      });
    });
  }
  
  /// 切换代理状态
  void _toggleConnection() {
    setState(() {
      if (_isConnected) {
        _proxyStatus = ProxyStatus.disconnected;
        _isConnected = false;
        _connectionStartTime = null;
      } else {
        _proxyStatus = ProxyStatus.connecting;
        _isConnected = false;
        _connectionStartTime = null;
        
        // 模拟连接过程
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _proxyStatus = ProxyStatus.connected;
              _isConnected = true;
              _connectionStartTime = DateTime.now();
            });
          }
        });
      }
    });
  }
  
  /// 模拟代理模式切换
  void _simulateModeSwitch() {
    final modes = [ProxyMode.rule, ProxyMode.global, ProxyMode.direct];
    final currentIndex = modes.indexOf(_selectedMode);
    final nextIndex = (currentIndex + 1) % modes.length;
    
    setState(() {
      _selectedMode = modes[nextIndex];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已切换到${_selectedMode.displayName}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('代理UI组件演示'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: '模式选择器'),
            Tab(text: '控制面板'),
            Tab(text: '状态指示器'),
            Tab(text: '完整集成'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildModeSelectorDemo(),
          _buildControlPanelDemo(),
          _buildStatusIndicatorDemo(),
          _buildIntegrationDemo(),
        ],
      ),
    );
  }
  
  /// 构建模式选择器演示
  Widget _buildModeSelectorDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDemoHeader('代理模式选择器'),
          
          // 基本使用
          Text(
            '基本用法',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ProxyModeSelector(
            selectedMode: _selectedMode,
            onModeChanged: (mode) {
              setState(() {
                _selectedMode = mode;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('已选择${mode.displayName}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // 紧凑模式
          Text(
            '紧凑模式',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ProxyModeSelector(
            selectedMode: _selectedMode,
            onModeChanged: (mode) => setState(() => _selectedMode = mode),
            compact: true,
            showDescriptions: false,
          ),
          
          const SizedBox(height: 24),
          
          // 自定义模式
          Text(
            '自定义模式选项',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ProxyModeSelector(
            selectedMode: _selectedMode,
            onModeChanged: (mode) => setState(() => _selectedMode = mode),
            customModes: [
              const ProxyModeOption(
                mode: ProxyMode.rule,
                label: '规则分流',
                icon: Icons.rule,
                description: '智能分流，节省流量',
              ),
              const ProxyModeOption(
                mode: ProxyMode.global,
                label: '全局代理',
                icon: Icons.public,
                description: '所有流量走代理',
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 禁用状态
          Text(
            '禁用状态',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ProxyModeSelector(
            selectedMode: _selectedMode,
            onModeChanged: null,
            disabled: true,
          ),
          
          const SizedBox(height: 16),
          _buildCodeExample('''
// 基本用法
ProxyModeSelector(
  selectedMode: selectedMode,
  onModeChanged: (mode) => setState(() => selectedMode = mode),
)

// 紧凑模式
ProxyModeSelector(
  selectedMode: selectedMode,
  onModeChanged: (mode) => setState(() => selectedMode = mode),
  compact: true,
  showDescriptions: false,
)

// 自定义模式
ProxyModeSelector(
  selectedMode: selectedMode,
  onModeChanged: (mode) => setState(() => selectedMode = mode),
  customModes: [
    ProxyModeOption(
      mode: ProxyMode.rule,
      label: '规则分流',
      icon: Icons.rule,
      description: '智能分流，节省流量',
    ),
  ],
)
          '''),
        ],
      ),
    );
  }
  
  /// 构建控制面板演示
  Widget _buildControlPanelDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDemoHeader('代理控制面板'),
          
          // 完整功能面板
          ProxyControlPanel(
            showTrafficStats: true,
            showQuickActions: true,
            showServerInfo: true,
            compact: false,
          ),
          
          const SizedBox(height: 24),
          
          // 紧凑面板
          Text(
            '紧凑面板',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ProxyControlPanel(
            showTrafficStats: false,
            showQuickActions: false,
            showServerInfo: false,
            compact: true,
          ),
          
          const SizedBox(height: 24),
          
          // 自定义样式
          Text(
            '自定义主题颜色',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ProxyControlPanel(
            primaryColor: Colors.purple,
            showTrafficStats: false,
            compact: true,
          ),
          
          const SizedBox(height: 16),
          _buildCodeExample('''
// 完整功能面板
ProxyControlPanel(
  showTrafficStats: true,
  showQuickActions: true,
  showServerInfo: true,
)

// 紧凑面板
ProxyControlPanel(
  showTrafficStats: false,
  showQuickActions: false,
  showServerInfo: false,
  compact: true,
)

// 自定义主题
ProxyControlPanel(
  primaryColor: Colors.purple,
  showTrafficStats: false,
)
          '''),
        ],
      ),
    );
  }
  
  /// 构建状态指示器演示
  Widget _buildStatusIndicatorDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDemoHeader('代理状态指示器'),
          
          // 基本状态指示器
          Text(
            '基本状态',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ProxyStatusIndicator(
                  status: ProxyStatus.connected,
                  compact: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ProxyStatusIndicator(
                  status: ProxyStatus.connecting,
                  compact: true,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ProxyStatusIndicator(
                  status: ProxyStatus.disconnected,
                  compact: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ProxyStatusIndicator(
                  status: ProxyStatus.error,
                  compact: true,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 详细状态指示器
          Text(
            '详细状态',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ProxyStatusIndicator(
            status: _proxyStatus,
            compact: false,
            showConnectionTime: true,
            connectionStartTime: _connectionStartTime,
          ),
          
          const SizedBox(height: 24),
          
          // 控制按钮
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _toggleConnection,
                icon: Icon(_isConnected ? Icons.link_off : Icons.link),
                label: Text(_isConnected ? '断开连接' : '模拟连接'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _simulateModeSwitch,
                icon: const Icon(Icons.swap_horiz),
                label: const Text('切换模式'),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          _buildCodeExample('''
// 紧凑状态指示器
ProxyStatusIndicator(
  status: ProxyStatus.connected,
  compact: true,
)

// 详细状态指示器
ProxyStatusIndicator(
  status: proxyStatus,
  compact: false,
  showConnectionTime: true,
  connectionStartTime: connectionStartTime,
)

// 自定义主题
ProxyStatusIndicator(
  status: proxyStatus,
  primaryColor: Colors.blue,
  size: 28.0,
)
          '''),
        ],
      ),
    );
  }
  
  /// 构建完整集成演示
  Widget _buildIntegrationDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDemoHeader('完整集成示例'),
          
          // 完整代理设置界面
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 状态指示器
                  ProxyStatusIndicator(
                    status: _proxyStatus,
                    connectionStartTime: _connectionStartTime,
                    showConnectionTime: true,
                    showDetailedStatus: true,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 连接按钮
                  ElevatedButton.icon(
                    onPressed: _toggleConnection,
                    icon: Icon(_isConnected ? Icons.link_off : Icons.link),
                    label: Text(_isConnected ? '断开连接' : '连接代理'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 模式选择器
                  ProxyModeSelector(
                    selectedMode: _selectedMode,
                    onModeChanged: (mode) => setState(() => _selectedMode = mode),
                    compact: false,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 演示导航按钮
          Center(
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProxySettingsPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('打开完整设置页面'),
                ),
                const SizedBox(height: 8),
                Text(
                  '这将打开完整的代理设置页面',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          _buildCodeExample('''
// 完整集成示例
Column(
  children: [
    // 状态指示器
    ProxyStatusIndicator(
      status: proxyStatus,
      showConnectionTime: true,
      connectionStartTime: connectionStartTime,
    ),
    
    const SizedBox(height: 16),
    
    // 控制按钮
    ElevatedButton.icon(
      onPressed: toggleConnection,
      icon: Icon(isConnected ? Icons.link_off : Icons.link),
      label: Text(isConnected ? '断开连接' : '连接代理'),
    ),
    
    const SizedBox(height: 16),
    
    // 模式选择器
    ProxyModeSelector(
      selectedMode: selectedMode,
      onModeChanged: (mode) => setState(() => selectedMode = mode),
    ),
  ],
)

// 打开设置页面
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const ProxySettingsPage(),
  ),
);
          '''),
        ],
      ),
    );
  }
  
  /// 构建演示标题
  Widget _buildDemoHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Theme.of(context).dividerColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Theme.of(context).dividerColor,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建代码示例
  Widget _buildCodeExample(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '代码示例',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              code,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 代理UI组件使用指南
/// 
/// 提供代理UI组件的详细使用说明和最佳实践。
class ProxyUIUsageGuide {
  /// 获取组件导入语句
  static String getImportStatement() => '''
import 'package:your_app/widgets/proxy/index.dart';
import 'package:your_app/pages/proxy_settings_page.dart';
import 'package:your_app/models/enums.dart';
import 'package:your_app/themes/browser_theme.dart';
  ''';
  
  /// 获取基本集成步骤
  static List<String> getIntegrationSteps() => [
    '导入必要的组件和枚举',
    '创建Provider用于状态管理',
    '在需要的地方使用ProxyModeSelector',
    '集成ProxyControlPanel进行状态控制',
    '使用ProxyStatusIndicator显示状态',
    '配置主题颜色保持一致性',
  ];
  
  /// 获取最佳实践建议
  static List<String> getBestPractices() => [
    '始终使用Riverpod进行状态管理',
    '保持UI组件与业务逻辑分离',
    '使用主题颜色确保一致性',
    '为复杂场景提供自定义选项',
    '添加适当的加载和错误状态',
    '支持无障碍访问和本地化',
  ];
}