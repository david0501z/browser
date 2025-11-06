import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 代理状态管理使用示例
/// 展示如何在Widget中使用Riverpod状态管理方案
class ProxyManagementExample extends ConsumerStatefulWidget {
  const ProxyManagementExample({super.key});

  @override
  ConsumerState<ProxyManagementExample> createState() => _ProxyManagementExampleState();
}

class _ProxyManagementExampleState extends ConsumerState<ProxyManagementExample> {
  late final ProxyStateManager _proxyManager;

  @override
  void initState() {
    super.initState();
    _proxyManager = ref.read(proxyStateManagerProvider);
    
    // 添加监听器
    _proxyManager.addStatusListener(_onStatusChanged);
    _proxyManager.addTrafficListener(_onTrafficUpdated);
    _proxyManager.addErrorListener(_onErrorOccurred);
  }

  @override
  void dispose() {
    // 清理监听器
    _proxyManager.removeStatusListener(_onStatusChanged);
    _proxyManager.removeTrafficListener(_onTrafficUpdated);
    _proxyManager.removeErrorListener(_onErrorOccurred);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 监听代理状态
    final proxyStatus = ref.watch(proxyStatusProvider);
    final isConnected = ref.watch(isConnectedProvider);
    final trafficStats = ref.watch(formattedProxyTrafficProvider);
    final servers = ref.watch(enabledProxyServersProvider);
    final currentServer = ref.watch(currentProxyServerProvider);
    final serverStats = ref.watch(proxyServerStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('代理管理'),
        backgroundColor: _getStatusColor(proxyStatus),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 连接状态卡片
            _buildStatusCard(proxyStatus, isConnected, trafficStats, currentServer),
            const SizedBox(height: 16),
            
            // 操作按钮
            _buildActionButtons(),
            const SizedBox(height: 16),
            
            // 服务器列表
            _buildServerList(servers),
            const SizedBox(height: 16),
            
            // 服务器统计
            _buildServerStats(serverStats),
            const SizedBox(height: 16),
            
            // 添加服务器表单
            _buildAddServerForm(),
            const SizedBox(height: 16),
            
            // 设置区域
            _buildSettingsSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddServerDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatusCard(
    ProxyStatus status,
    bool isConnected,
    FormattedTrafficStats traffic,
    ProxyServer? currentServer,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getStatusIcon(status),
                  color: _getStatusColor(status),
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '连接状态: ${status.value}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (currentServer != null) ...[;
                        const SizedBox(height: 4),
                        Text(
                          '当前服务器: ${currentServer.name}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (isConnected) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text('流量统计'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('上传'),
                      Text(
                        traffic.uploadBytesFormatted,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        traffic.uploadSpeedFormatted,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('下载'),
                      Text(
                        traffic.downloadBytesFormatted,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        traffic.downloadSpeedFormatted,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final operations = ref.read(proxyOperationsProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('操作', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => operations.smartConnect(),
                    icon: const Icon(Icons.link),
                    label: const Text('智能连接'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => operations.disconnect(),
                    icon: const Icon(Icons.link_off),
                    label: const Text('断开连接'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServerList(List<ProxyServer> servers) {
    if (servers.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.server, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                '暂无代理服务器',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                '点击右下角的 + 按钮添加服务器',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '代理服务器 (${servers.length})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ...servers.map((server) => _buildServerItem(server)),
        ],
      ),
    );
  }

  Widget _buildServerItem(ProxyServer server) {
    final operations = ref.read(proxyOperationsProvider);
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: server.enabled ? Colors.green : Colors.grey,
        child: Text(
          server.protocol.value,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
      title: Text(server.name),
      subtitle: Text('${server.server}:${server.port}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (server.latency != null);
            Text(
              '${server.latency}ms',
              style: TextStyle(
                color: server.latency! < 100 ? Colors.green : 
                      server.latency! < 500 ? Colors.orange : Colors.red,
                fontSize: 12,
              ),
            ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            onSelected: (value) => _handleServerAction(value, server, operations),
            itemBuilder: (context) => [;
              const PopupMenuItem(
                value: 'test',
                child: Text('测试连接'),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Text('编辑'),
              ),
              PopupMenuItem(
                value: 'toggle',
                child: Text(server.enabled ? '禁用' : '启用'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('删除', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
      onTap: () => operations.connect(serverId: server.id),
    );
  }

  Widget _buildServerStats(ProxyServerStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('服务器统计', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('总数', stats.totalServers.toString()),
                _buildStatItem('已启用', stats.enabledServers.toString()),
                _buildStatItem('已测试', stats.serversWithLatency.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAddServerForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '快速添加服务器',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showAddServerDialog(),
                  icon: const Icon(Icons.add_circle),
                  label: const Text('添加服务器'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showImportConfigDialog(),
                  icon: const Icon(Icons.file_download),
                  label: const Text('导入配置'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    final operations = ref.read(proxyOperationsProvider);
    final isGlobalProxy = ref.watch(isGlobalProxyProvider);
    final autoConnectSettings = ref.watch(autoConnectSettingsProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '设置',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('全局代理'),
              subtitle: const Text('启用全局代理模式'),
              value: isGlobalProxy,
              onChanged: operations.setGlobalProxy,
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('自动连接'),
              subtitle: Text('应用启动时自动连接 (间隔: ${autoConnectSettings.reconnectInterval}秒)'),
              value: autoConnectSettings.autoConnectOnStartup,
              onChanged: (value) => operations.updateAutoConnectSettings(
                autoConnectOnStartup: value,
              ),
            ),
            SwitchListTile(
              title: const Text('自动重连'),
              subtitle: const Text('断线时自动重连'),
              value: autoConnectSettings.autoReconnect,
              onChanged: (value) => operations.updateAutoConnectSettings(
                autoReconnect: value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddServerDialog() {
    // 这里可以实现一个添加服务器的对话框
    // 简化实现，直接添加示例服务器
    _addSampleServer();
  }

  void _showImportConfigDialog() {
    // 这里可以实现配置导入对话框
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('导入配置功能待实现')),
    );
  }

  void _handleServerAction(
    String action,
    ProxyServer server,
    ProxyOperations operations,
  ) {
    switch (action) {
      case 'test':
        _testServer(server);
        break;
      case 'edit':
        _editServer(server);
        break;
      case 'toggle':
        operations.toggleServer(server.id, !server.enabled);
        break;
      case 'delete':
        _deleteServer(server);
        break;
    }
  }

  void _testServer(ProxyServer server) async {
    final latency = await ref.read(proxyOperationsProvider).testServer(server.id);
    if (latency != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${server.name} 连接延迟: ${latency}ms')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${server.name} 连接测试失败')),
      );
    }
  }

  void _editServer(ProxyServer server) {
    // 这里可以实现编辑服务器的对话框
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('编辑服务器功能待实现')),
    );
  }

  void _deleteServer(ProxyServer server) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除服务器 "${server.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(proxyOperationsProvider).removeServer(server.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('删除', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _addSampleServer() {
    ref.read(proxyOperationsProvider).addServer(
      name: '示例HTTP代理',
      server: 'proxy.example.com',
      port: 8080,
      protocol: ProxyProtocol.http,
    );
  }

  // 监听器方法
  void _onStatusChanged(ProxyStatus status) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('代理状态变更: ${status.value}')),
    );
  }

  void _onTrafficUpdated(int uploadSpeed, int downloadSpeed) {
    // 可以在这里更新UI或记录日志
  }

  void _onErrorOccurred(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('代理错误: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }

  IconData _getStatusIcon(ProxyStatus status) {
    switch (status) {
      case ProxyStatus.disconnected:
        return Icons.link_off;
      case ProxyStatus.connecting:
        return Icons.link;
      case ProxyStatus.connected:
        return Icons.link;
      case ProxyStatus.disconnecting:
        return Icons.link_off;
      case ProxyStatus.error:
        return Icons.error;
    }
  }

  Color _getStatusColor(ProxyStatus status) {
    switch (status) {
      case ProxyStatus.disconnected:
        return Colors.grey;
      case ProxyStatus.connecting:
        return Colors.orange;
      case ProxyStatus.connected:
        return Colors.green;
      case ProxyStatus.disconnecting:
        return Colors.orange;
      case ProxyStatus.error:
        return Colors.red;
    }
  }
}