# 代理状态管理方案

基于 Riverpod 的 Flutter 代理应用状态管理解决方案，提供完整的状态管理、通知器和提供者架构。

## 📁 项目结构

```
lib/
├── models/
│   └── proxy_state.dart          # 状态数据模型
├── providers/
│   └── proxy_providers.dart      # Riverpod 提供者
├── notifiers/
│   └── proxy_notifier.dart       # 状态通知器
├── state/
│   └── proxy_state_manager.dart  # 状态管理器
└── examples/
    └── proxy_management_example.dart # 使用示例
```

## 🏗️ 架构组件

### 1. 数据模型 (`proxy_state.dart`)

定义了完整的代理状态数据结构：

- **ProxyServer**: 代理服务器配置
- **ProxyConnectionState**: 连接状态和流量统计
- **ProxyRule**: 代理规则配置
- **GlobalProxyState**: 全局代理状态
- **SystemProxySettings**: 系统代理设置
- **AutoConnectSettings**: 自动连接设置

#### 主要特性：
- 使用 Freezed 生成不可变数据类
- JSON 序列化支持
- 类型安全的枚举定义
- 完整的字段验证

### 2. 状态通知器 (`proxy_notifier.dart`)

负责状态更新和业务逻辑：

- 代理服务器管理（增删改查）
- 连接状态管理
- 规则管理
- 自动重连逻辑
- 本地存储集成

#### 主要方法：
```dart
// 连接管理
Future<bool> connect(String? serverId)
Future<void> disconnect()

// 服务器管理
Future<void> addServer(ProxyServer server)
Future<void> updateServer(String serverId, ProxyServer server)
Future<void> removeServer(String serverId)

// 规则管理
Future<void> addRule(ProxyRule rule)
Future<void> removeRule(String ruleId)

// 设置管理
Future<void> setGlobalProxy(bool enabled)
Future<void> updateSystemProxySettings(SystemProxySettings settings)
```

### 3. 状态管理器 (`proxy_state_manager.dart`)

提供高级状态管理功能：

- 统一状态管理接口
- 监听器管理
- 智能连接算法
- 错误处理和通知
- 流量监控

#### 主要功能：
```dart
class ProxyStateManager {
  // 监听器管理
  void addStatusListener(Function(ProxyStatus) listener)
  void addTrafficListener(Function(int upload, int download) listener)
  void addErrorListener(Function(String error) listener)
  
  // 智能操作
  Future<bool> smartConnect()  // 自动选择最佳服务器
  Future<bool> addProxyServer()  // 添加服务器
  Future<bool> updateProxyServer()  // 更新服务器
  
  // 查询方法
  ProxyServer? get currentServer
  List<ProxyServer> get enabledServers
  bool get isConnected
}
```

### 4. Riverpod 提供者 (`proxy_providers.dart`)

提供完整的 Riverpod 提供者生态：

#### 核心提供者：
- `proxyNotifierProvider`: 状态通知器提供者
- `globalProxyStateProvider`: 全局状态提供者
- `proxyConnectionStateProvider`: 连接状态提供者

#### 派生提供者：
- `isConnectedProvider`: 连接状态布尔值
- `currentProxyServerProvider`: 当前服务器
- `availableProxyServersProvider`: 可用服务器列表
- `proxyTrafficStatsProvider`: 流量统计

#### 工具提供者：
- `proxyOperationsProvider`: 操作封装器
- `proxyValidatorProvider`: 验证器
- `proxyRuleMatcherProvider`: 规则匹配器
- `proxyConfigManagerProvider`: 配置管理器

## 🚀 使用方法

### 1. 基础使用

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/proxy_providers.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听连接状态
    final isConnected = ref.watch(isConnectedProvider);
    final proxyStatus = ref.watch(proxyStatusProvider);
    
    // 获取操作接口
    final operations = ref.read(proxyOperationsProvider);
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('连接状态: ${isConnected ? "已连接" : "未连接"}'),
            Text('状态: ${proxyStatus.value}'),
            ElevatedButton(
              onPressed: () => operations.smartConnect(),
              child: Text('智能连接'),
            ),
            ElevatedButton(
              onPressed: () => operations.disconnect(),
              child: Text('断开连接'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 2. 服务器管理

```dart
class ServerManagementWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servers = ref.watch(enabledProxyServersProvider);
    final operations = ref.read(proxyOperationsProvider);
    
    return ListView.builder(
      itemCount: servers.length,
      itemBuilder: (context, index) {
        final server = servers[index];
        return ListTile(
          title: Text(server.name),
          subtitle: Text('${server.server}:${server.port}'),
          trailing: IconButton(
            icon: const Icon(Icons.connect),
            onPressed: () => operations.connect(serverId: server.id),
          ),
        );
      },
    );
  }
}
```

### 3. 监听器使用

```dart
class ProxyListenerWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<ProxyListenerWidget> createState() => _ProxyListenerWidgetState();
}

class _ProxyListenerWidgetState extends ConsumerState<ProxyListenerWidget> {
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
  
  void _onStatusChanged(ProxyStatus status) {
    // 处理状态变化
    print('代理状态变更: ${status.value}');
  }
  
  void _onTrafficUpdated(int upload, int download) {
    // 处理流量更新
    print('上传: $upload, 下载: $download');
  }
  
  void _onErrorOccurred(String error) {
    // 处理错误
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('代理错误: $error')),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Widget 构建逻辑
    return Container();
  }
}
```

### 4. 配置导入导出

```dart
class ConfigManagerWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configManager = ref.read(proxyConfigManagerProvider);
    final operations = ref.read(proxyOperationsProvider);
    
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            // 导出配置
            final config = configManager.exportConfig();
            // 保存到文件或分享
          },
          child: Text('导出配置'),
        ),
        ElevatedButton(
          onPressed: () async {
            // 从文件加载配置
            final config = await _loadConfigFromFile();
            // 导入配置
            await configManager.importConfig(config);
          },
          child: Text('导入配置'),
        ),
      ],
    );
  }
}
```

## 🔧 配置和自定义

### 1. 添加依赖

在 `pubspec.yaml` 中添加必要的依赖：

```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  freezed_annotation: ^2.4.1
  
dev_dependencies:
  riverpod_generator: ^2.3.9
  freezed: ^2.4.6
  build_runner: ^2.4.7
```

### 2. 生成代码

运行代码生成：

```bash
flutter packages pub run build_runner build
```

### 3. 自定义状态

扩展状态模型：

```dart
// 在 proxy_state.dart 中添加新的状态类
@freezed
class CustomProxyState with _$CustomProxyState {
  const factory CustomProxyState({
    required String customField,
    required int customValue,
  }) = _CustomProxyState;
  
  factory CustomProxyState.fromJson(Map<String, dynamic> json) =>
      _$CustomProxyStateFromJson(json);
}
```

## 🧪 测试

### 单元测试

```dart
void main() {
  group('ProxyStateManager Tests', () {
    late ProxyStateManager proxyManager;
    late ProviderContainer container;
    
    setUp(() {
      container = ProviderContainer();
      proxyManager = ProxyStateManager(container);
    });
    
    tearDown(() {
      container.dispose();
    });
    
    test('should add proxy server', () async {
      final success = await proxyManager.addProxyServer(
        name: 'Test Server',
        server: 'test.example.com',
        port: 8080,
        protocol: ProxyProtocol.http,
      );
      
      expect(success, true);
    });
    
    test('should connect to proxy', () async {
      // 添加测试服务器
      await proxyManager.addProxyServer(
        name: 'Test Server',
        server: 'test.example.com',
        port: 8080,
        protocol: ProxyProtocol.http,
      );
      
      // 测试连接
      final success = await proxyManager.smartConnect();
      expect(success, isA<bool>());
    });
  });
}
```

## 📱 完整示例

查看 `examples/proxy_management_example.dart` 文件获取完整的使用示例，包含：

- 状态监听和UI更新
- 服务器列表管理
- 连接状态显示
- 流量统计监控
- 设置管理界面
- 错误处理

## 🔄 状态流程

```
初始化 → 加载配置 → 监听状态变化
   ↓
用户操作 → 状态管理器 → 通知器 → 状态更新 → UI刷新
   ↓
连接建立 → 流量监控 → 数据更新 → 监听器通知
```

## 🛡️ 安全考虑

1. **数据验证**: 所有用户输入都经过验证
2. **错误处理**: 完善的错误捕获和恢复机制
3. **状态一致性**: 不可变数据确保状态一致性
4. **内存管理**: 及时释放资源，防止内存泄漏

## 📈 性能优化

1. **选择性监听**: 只监听需要的状态变化
2. **延迟计算**: 使用 `select()` 方法优化派生状态
3. **缓存机制**: 合理使用提供者缓存
4. **异步操作**: 所有网络操作都是异步的

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支
3. 提交变更
4. 创建 Pull Request

## 📄 许可证

MIT License

## 🔗 相关资源

- [Riverpod 官方文档](https://riverpod.dev/)
- [Freezed 文档](https://pub.dev/packages/freezed)
- [Flutter 状态管理指南](https://docs.flutter.dev/development/data-and-backend/state-mgmt/options)