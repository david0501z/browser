import 'package:flutter/material.dart';

/// WebView代理配置管理页面
/// 
/// 提供WebView代理配置的完整管理界面，包括：
/// - 代理启用/禁用
/// - 代理类型选择（HTTP/HTTPS/SOCKS4/SOCKS5）
/// - 代理服务器地址和端口配置
/// - 代理认证设置
/// - 跳过主机列表配置
/// - 代理连接测试
/// - 配置历史和快速切换
class WebViewProxyConfigPage extends StatefulWidget {
  const WebViewProxyConfigPage({Key? key}) : super(key: key);

  @override
  State<WebViewProxyConfigPage> createState() => _WebViewProxyConfigPageState();
}

class _WebViewProxyConfigPageState extends State<WebViewProxyConfigPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 表单控制器
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bypassHostsController = TextEditingController();

  // 当前配置状态
  bool _proxyEnabled = false;
  ProxyType _proxyType = ProxyType.http;
  bool _testingConnection = false;
  ProxyTestResult? _testResult;

  // 滚动控制器
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    _initializeForm();
    
    // 监听代理配置变更
    WebViewProxyService.instance.addConfigListener(_onProxyConfigChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _bypassHostsController.dispose();
    _scrollController.dispose();
    
    WebViewProxyService.instance.removeConfigListener(_onProxyConfigChanged);
    super.dispose();
  }

  /// 初始化表单数据
  void _initializeForm() async {
    await WebViewProxyService.instance.initialize();
    
    final config = WebViewProxyService.instance.currentConfig;
    if (config != null) {
      setState(() {
        _proxyEnabled = config.enabled;
        _proxyType = config.type;
        _nameController.text = config.name ?? '';
        _urlController.text = config.proxyUrl ?? '';
        _usernameController.text = config.proxyAuth?.username ?? '';
        _passwordController.text = config.proxyAuth?.password ?? '';
        _bypassHostsController.text = config.bypassHosts ?? '';
      });
    }
  }

  /// 代理配置变更回调
  void _onProxyConfigChanged(ProxyConfig? oldConfig, ProxyConfig? newConfig) {
    if (mounted && newConfig != null) {
      setState(() {
        _proxyEnabled = newConfig.enabled;
        _proxyType = newConfig.type;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView代理设置'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _testConnection,
            tooltip: '测试连接',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveConfiguration,
            tooltip: '保存配置',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '基本设置'),
            Tab(text: '高级设置'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBasicSettingsTab(),
          _buildAdvancedSettingsTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// 构建基本设置标签页
  Widget _buildBasicSettingsTab() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 代理启用开关
            Card(
              child: SwitchListTile(
                title: const Text('启用代理'),
                subtitle: const Text('通过代理服务器访问网络'),
                value: _proxyEnabled,
                onChanged: (value) {
                  setState(() {
                    _proxyEnabled = value;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 代理类型选择
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '代理类型',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<ProxyType>(
                      value: _proxyType,
                      decoration: const InputDecoration(
                        labelText: '选择代理类型',
                        border: OutlineInputBorder(),
                      ),
                      items: ProxyType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(_getProxyTypeDisplayName(type)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _proxyType = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 代理服务器地址
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '代理服务器',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        labelText: '代理服务器地址',
                        hintText: 'http://proxy.example.com:8080',
                        border: OutlineInputBorder(),
                      ),
                      validator: _proxyEnabled ? _validateUrl : null,
                      onSaved: (value) {
                        if (value != null) {
                          _urlController.text = value;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 配置名称
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '配置名称',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: '配置名称（可选）',
                        hintText: '如：公司代理、家庭代理',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建高级设置标签页
  Widget _buildAdvancedSettingsTab() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 认证设置
          Card(
            child: ExpansionTile(
              title: const Text('认证设置'),
              subtitle: const Text('代理服务器认证信息'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: '用户名',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: '密码',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 跳过主机设置
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '跳过代理的主机',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _bypassHostsController,
                    decoration: const InputDecoration(
                      labelText: '主机列表',
                      hintText: 'localhost,127.0.0.1,192.168.*.*',
                      helperText: '多个主机用逗号分隔',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 测试结果
          if (_testResult != null);
            Card(
              child: ListTile(
                leading: Icon(
                  _testResult!.success ? Icons.check_circle : Icons.error,
                  color: _testResult!.success ? Colors.green : Colors.red,
                ),
                title: Text(_testResult!.message),
                subtitle: _testResult!.latency != null;
                    ? Text('延迟: ${_testResult!.latency!.inMilliseconds}ms')
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  /// 构建底部操作栏
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _testingConnection ? null : _testConnection,
              icon: _testingConnection
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.network_check),
              label: Text(_testingConnection ? '测试中...' : '测试连接'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _resetToDefault,
              icon: const Icon(Icons.restore),
              label: const Text('重置默认'),
            ),
          ),
        ],
      ),
    );
  }

  /// 验证URL格式
  String? _validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入代理服务器地址';
    }
    
    try {
      final uri = Uri.parse(value);
      if (uri.host.isEmpty || uri.port == 0) {
        return '请输入有效的服务器地址';
      }
    } catch (e) {
      return '请输入有效的URL格式';
    }
    
    return null;
  }

  /// 获取代理类型显示名称
  String _getProxyTypeDisplayName(ProxyType type) {
    switch (type) {
      case ProxyType.http:
        return 'HTTP 代理';
      case ProxyType.https:
        return 'HTTPS 代理';
      case ProxyType.socks4:
        return 'SOCKS4 代理';
      case ProxyType.socks5:
        return 'SOCKS5 代理';
    }
  }

  /// 测试连接
  Future<void> _testConnection() async {
    if (!_validateCurrentConfig()) {
      return;
    }

    setState(() {
      _testingConnection = true;
      _testResult = null;
    });

    try {
      final result = await WebViewProxyService.instance.testProxyConnection();
      
      if (mounted) {
        setState(() {
          _testResult = result;
          _testingConnection = false;
        });
      }
      
      if (!result.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _testingConnection = false;
          _testResult = ProxyTestResult(
            success: false,
            message: '测试异常: $e',
          );
        });
      }
    }
  }

  /// 保存配置
  Future<void> _saveConfiguration() async {
    if (!_validateCurrentConfig()) {
      return;
    }

    try {
      final config = ProxyConfig(
        enabled: _proxyEnabled,
        proxyUrl: _urlController.text.trim(),
        type: _proxyType,
        proxyAuth: _buildProxyAuth(),
        bypassHosts: _bypassHostsController.text.trim().isEmpty
            ? null
            : _bypassHostsController.text.trim(),
        name: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
      );

      final success = await WebViewProxyService.instance.applyProxyConfig(config);
      
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('代理配置已保存'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('代理配置保存失败'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存配置时发生错误: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 构建代理认证信息
  ProxyAuth? _buildProxyAuth() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    
    if (username.isEmpty && password.isEmpty) {
      return null;
    }
    
    return ProxyAuth(username: username.isEmpty ? null : username, password: password.isEmpty ? null : password);
  }

  /// 验证当前配置
  bool _validateCurrentConfig() {
    if (!_proxyEnabled) {
      return true; // 禁用代理的配置总是有效的
    }

    final error = _validateUrl(_urlController.text);
    if (error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }

    // 验证认证信息
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    
    if ((username.isEmpty && password.isNotEmpty) || 
        (username.isNotEmpty && password.isEmpty)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('用户名和密码需要同时填写或同时留空'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }

    return true;
  }

  /// 重置为默认配置
  Future<void> _resetToDefault() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认重置'),
        content: const Text('确定要重置代理配置为默认状态吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await WebViewProxyService.instance.resetToDefault();
      
      setState(() {
        _proxyEnabled = false;
        _proxyType = ProxyType.http;
        _nameController.clear();
        _urlController.clear();
        _usernameController.clear();
        _passwordController.clear();
        _bypassHostsController.clear();
        _testResult = null;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('代理配置已重置为默认状态'),
          ),
        );
      }
    }
  }
}