# 高级代理服务架构

## 概述

本项目实现了一个高级代理服务类包装器，用于封装FFI桥接功能，提供完整的代理服务架构。该架构采用模块化设计，包含四个核心服务类，实现了对代理连接的全面管理。

## 架构组成

### 1. ProxyService (代理服务类)
**文件**: `lib/services/proxy_service.dart`

核心代理服务类，提供：
- FFI桥接功能封装
- 代理连接建立和管理
- 代理状态监控
- 连接配置管理
- 事件驱动架构

**主要特性**:
- 单例模式管理
- 异步连接操作
- 状态流管理
- 连接测试功能
- 自动重连机制

**使用示例**:
```dart
// 初始化服务
final proxyManager = ProxyServiceManager.instance;
await proxyManager.initialize();

// 建立连接
await proxyManager.startProxy(
  proxyType: 'HTTP',
  serverHost: 'proxy.example.com',
  serverPort: 8080,
  username: 'user',
  password: 'pass',
);

// 监听状态变化
proxyManager.proxyStates.listen((state) {
  print('代理状态: $state');
});
```

### 2. ProxyLifecycleManager (生命周期管理)
**文件**: `lib/services/proxy_lifecycle_manager.dart`

负责管理代理服务的生命周期：
- 应用生命周期监听
- 代理连接状态管理
- 资源自动回收
- 性能监控和统计

**主要特性**:
- 应用状态跟踪
- 会话管理
- 心跳监控
- 空闲超时处理
- 统计信息收集

**生命周期事件**:
- `appStart` - 应用启动
- `appStop` - 应用停止
- `appPause` - 应用暂停
- `appResume` - 应用恢复
- `proxyStart` - 代理启动
- `proxyStop` - 代理停止

### 3. ConfigManager (配置管理)
**文件**: `lib/services/config_manager.dart`

统一管理应用配置：
- 配置的增删改查
- 配置验证机制
- 配置持久化
- 配置同步

**主要特性**:
- 多类型配置支持
- 配置验证规则
- 嵌套配置键支持
- 自动保存机制
- 代理配置管理

**配置类型**:
- `string` - 字符串类型
- `integer` - 整数类型
- `double` - 浮点数类型
- `boolean` - 布尔类型
- `json` - JSON对象类型
- `list` - 列表类型

**使用示例**:
```dart
final configManager = ConfigManager.instance;

// 设置配置
await configManager.setConfig('proxy.port', 8080);
await configManager.setConfig('network.dns', ['8.8.8.8']);

// 获取配置
final port = configManager.getConfig<int>('proxy.port', 8080);
final dns = configManager.getConfig<List<String>>('network.dns', []);
```

### 4. ErrorHandler (错误处理)
**文件**: `lib/services/error_handler.dart`

提供统一的错误处理机制：
- 错误分类和级别判断
- 错误恢复策略
- 错误日志记录
- 错误统计和报告

**错误类别**:
- `system` - 系统错误
- `network` - 网络错误
- `configuration` - 配置错误
- `permission` - 权限错误
- `ffi` - FFI桥接错误
- `lifecycle` - 生命周期错误
- `ui` - UI错误

**错误处理策略**:
- `ignore` - 忽略错误
- `log` - 记录日志
- `notify` - 显示通知
- `retry` - 重试操作
- `fallback` - 回退到默认
- `crash` - 关闭应用

**使用示例**:
```dart
final errorHandler = ErrorHandler.instance;

await errorHandler.handleError(
  'ProxyConnection',
  '连接失败',
  severity: ErrorSeverity.high,
  category: ErrorCategory.network,
  retryKey: 'proxy_connection',
);
```

## 服务架构特点

### 1. 模块化设计
- 每个服务类独立负责特定功能
- 服务间通过事件和依赖注入进行通信
- 便于维护和扩展

### 2. 事件驱动架构
- 使用StreamController实现事件发布
- 支持异步事件处理
- 提供类型安全的事件系统

### 3. 单例模式
- 确保全局只有一个服务实例
- 避免资源重复分配
- 提供全局访问点

### 4. 错误恢复机制
- 智能错误分类和严重级别判断
- 多种恢复策略支持
- 自动重试和降级处理

### 5. 配置管理
- 类型安全的配置访问
- 配置验证和默认值
- 持久化存储支持

### 6. 生命周期管理
- 完整的应用状态跟踪
- 资源自动管理
- 性能监控和统计

## FFI桥接抽象

该架构提供了完整的FFI桥接抽象层：

### 1. 平台支持
- Android (libclash.so)
- Windows (clash.dll)
- Linux (libclash.so)
- macOS (libclash.dylib)

### 2. 核心功能
- `proxy_connect` - 建立代理连接
- `proxy_disconnect` - 断开代理连接
- `proxy_test` - 测试代理连接
- `proxy_get_status` - 获取代理状态
- `proxy_set_config` - 设置代理配置

### 3. 错误处理
- FFI调用异常捕获
- 错误代码解析
- 平台特定错误处理

## 使用指南

### 1. 初始化服务
```dart
// 初始化所有服务
await ErrorHandler.instance.initialize();
await ConfigManager.instance.initialize();
await ProxyLifecycleManager.instance.initialize();
await ProxyServiceManager.instance.initialize();
```

### 2. 配置代理
```dart
final configManager = ConfigManager.instance;
await configManager.setConfig('proxy.type', 'HTTP');
await configManager.setConfig('proxy.host', '127.0.0.1');
await configManager.setConfig('proxy.port', 8080);
```

### 3. 建立连接
```dart
final proxyManager = ProxyServiceManager.instance;
final connected = await proxyManager.startProxy(
  proxyType: 'HTTP',
  serverHost: 'proxy.example.com',
  serverPort: 8080,
  username: 'user',
  password: 'pass',
);
```

### 4. 监控状态
```dart
// 监听代理状态
proxyManager.proxyStates.listen((state) {
  print('代理状态变化: $state');
});

// 监听代理事件
proxyManager.proxyEvents.listen((event) {
  print('代理事件: ${event.type} - ${event.message}');
});
```

### 5. 错误处理
```dart
final errorHandler = ErrorHandler.instance;
errorHandler.eventStream.listen((event) {
  print('错误事件: ${event.message}');
});
```

### 6. 清理资源
```dart
await ProxyServiceManager.instance.dispose();
await ConfigManager.instance.dispose();
await ProxyLifecycleManager.instance.dispose();
await ErrorHandler.instance.dispose();
```

## 最佳实践

### 1. 服务初始化
- 在应用启动时按顺序初始化所有服务
- 检查初始化结果并处理失败情况
- 设置适当的错误处理机制

### 2. 内存管理
- 及时释放服务实例
- 关闭事件流控制器
- 取消定时器和监听器

### 3. 错误处理
- 使用合适的错误严重级别
- 提供有意义的错误上下文
- 实现适当的恢复策略

### 4. 配置管理
- 使用类型安全的方法访问配置
- 设置合理的默认值
- 定期验证配置的有效性

### 5. 性能优化
- 避免在事件处理器中执行耗时操作
- 使用适当的缓存策略
- 监控内存使用情况

## 扩展指南

### 1. 添加新的代理类型
1. 在`ProxyConfig`中添加新的代理类型支持
2. 实现相应的配置验证规则
3. 添加特定的处理逻辑

### 2. 添加新的错误处理策略
1. 创建新的`ErrorRecoveryStrategy`
2. 实现自定义恢复逻辑
3. 注册到错误处理器

### 3. 添加新的配置类型
1. 扩展`ConfigType`枚举
2. 实现相应的类型处理逻辑
3. 添加配置验证规则

### 4. 添加新的生命周期事件
1. 扩展`LifecycleType`枚举
2. 实现事件处理逻辑
3. 添加相应的监听器

## 注意事项

1. **线程安全**: 所有服务类设计为单例，确保线程安全
2. **资源管理**: 务必在应用退出时释放所有服务资源
3. **错误处理**: 始终提供适当的错误处理和恢复机制
4. **配置验证**: 在使用配置前进行验证，确保配置的有效性
5. **性能监控**: 定期检查服务性能，及时发现和解决问题

## 技术栈

- **Dart 3.0+**
- **Flutter Framework**
- **FFI (Foreign Function Interface)**
- **SharedPreferences**
- **Stream API**
- **Async/Await**

## 许可证

本项目采用 MIT 许可证。