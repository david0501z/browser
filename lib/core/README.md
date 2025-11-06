# Flutter FFI桥接基础代码

## 概述

本目录包含了一个完整的Flutter FFI桥接系统的基础代码，用于实现代理服务的跨平台通信。系统基于Dart FFI（Foreign Function Interface）机制，提供与原生代理库的交互接口。

## 文件结构

```
lib/core/
├── index.dart                     # 模块导出文件
├── proxy_core_interface.dart      # 核心接口定义
├── proxy_core_bridge.dart         # FFI桥接实现
├── proxy_config.dart              # 配置数据模型
├── traffic_stats.dart             # 流量统计模型
├── proxy_state.dart               # 状态管理模型
├── proxy_state_manager.dart       # 状态管理器
├── proxy_types.dart               # 类型定义
├── proxy_utils.dart               # 工具类
├── proxy_constants.dart           # 常量定义
├── freezed_annotation.dart        # 免费zed注解简化实现
├── proxy_config.g.dart            # 配置模型生成代码
├── traffic_stats.g.dart           # 流量统计生成代码
└── proxy_state.g.dart             # 状态管理生成代码
```

## 核心组件

### 1. 接口定义 (proxy_core_interface.dart)

定义了与原生库交互的标准接口：
- `ProxyCoreInterface`: 主要接口类
- `ProxyResult`: 操作结果封装
- `ProxyStatus`: 状态枚举
- `ProxyNode`: 代理节点信息
- `ProxyConfigParams`: 配置参数

### 2. FFI桥接实现 (proxy_core_bridge.dart)

实现了实际的FFI桥接逻辑：
- `ProxyCoreBridge`: 桥接实现类
- `ProxyCoreNativeApi`: 原生API封装
- 库加载和函数指针管理
- 异步操作支持

### 3. 数据模型

#### 配置模型 (proxy_config.dart)
- `ProxyConfig`: 代理配置实体
- `ProxyRule`: 代理规则
- `ProxyNode`: 代理节点
- `TrafficConfig`: 流量统计配置

#### 流量统计 (traffic_stats.dart)
- `TrafficStats`: 流量统计数据
- `TrafficHistory`: 流量历史记录
- `TrafficAlertConfig`: 流量警告配置
- `TrafficMonitor`: 流量监控器
- `TrafficFormatter`: 格式化工具

#### 状态管理 (proxy_state.dart)
- `ProxyState`: 代理状态
- `StateHistory`: 状态变更历史
- `StateChangeEvent`: 状态变更事件
- `ProxyStateManager`: 状态管理器

### 4. 工具和常量

#### 类型定义 (proxy_types.dart)
定义了系统使用的所有枚举类型：
- 协议类型、认证类型
- 日志级别、连接状态
- 错误类型、操作类型等

#### 工具类 (proxy_utils.dart)
提供各种辅助功能：
- `ProxyConfigUtils`: 配置工具
- `ProxyRuleUtils`: 规则工具
- `ProxyNodeUtils`: 节点工具
- `ProxyStatsUtils`: 统计工具
- `ProxyStringUtils`: 字符串工具
- `ProxyNetworkUtils`: 网络工具

#### 常量定义 (proxy_constants.dart)
系统使用的各种常量：
- `ProxyConstants`: 代理服务常量
- `ProxyStateConstants`: 状态常量
- `TrafficStatsConstants`: 流量统计常量
- `NetworkConstants`: 网络常量
- `SecurityConstants`: 安全常量
- `LogConstants`: 日志常量
- `ErrorMessages`: 错误消息常量

## 使用方法

### 1. 初始化

```dart
import 'package:flclash_browser_app/lib/core/index.dart';

// 初始化代理服务
await ProxyServiceManager().initialize();
```

### 2. 启动/停止代理

```dart
final serviceManager = ProxyServiceManager();

// 启动代理
final startResult = await serviceManager.start();
if (startResult.success) {
  print('代理启动成功');
}

// 停止代理
final stopResult = await serviceManager.stop();
```

### 3. 配置代理

```dart
final config = ProxyConfig(
  enabled: true,
  mode: 'global',
  port: 7890,
  listenAddress: '127.0.0.1',
  // ... 其他配置
);

await serviceManager.configure(config);
```

### 4. 节点管理

```dart
// 获取节点列表
final nodes = await serviceManager.getNodes();

// 切换节点
await serviceManager.switchNode('node-id-1');
```

### 5. 状态监听

```dart
// 监听状态变化
final stateManager = ProxyStateManager();
stateManager.addListener(() {
  final currentState = stateManager.currentState;
  print('当前状态: ${currentState.connectionState}');
});

// 监听状态变更事件
stateManager.stateChanges.listen((event) {
  print('状态变更: ${event.state}');
});
```

### 6. 流量统计

```dart
// 获取流量统计
final stats = await serviceManager.getTrafficStats();
print('上行流量: ${TrafficFormatter.formatBytes(stats.uploadBytes)}');
print('下行流量: ${TrafficFormatter.formatBytes(stats.downloadBytes)}');
print('当前速度: ${TrafficFormatter.formatSpeed(stats.downloadSpeed)}');
```

## 注意事项

### 1. 原生库依赖

系统依赖于原生代理库：
- Android: `libproxycore.so`
- iOS: `libproxycore.dylib`

这些库需要单独实现和部署。

### 2. 权限要求

根据代理服务的特性，可能需要以下权限：
- 网络访问权限
- 后台运行权限
- VPN权限（如适用）

### 3. 错误处理

系统提供了完整的错误处理机制：
- 状态管理中的错误状态跟踪
- 结果封装中的错误信息
- 异常捕获和日志记录

### 4. 性能考虑

- 状态更新使用事件驱动模式
- 流量统计支持缓存和批处理
- 异步操作避免阻塞UI线程

## 扩展性

系统设计具有良好的扩展性：

1. **接口驱动**: 基于接口定义，可以轻松替换实现
2. **类型安全**: 使用Dart的类型系统和枚举
3. **模块化设计**: 各组件独立，易于测试和维护
4. **配置灵活**: 支持多种配置方式和自定义参数

## 下一步

1. 实现具体的原生代理库
2. 添加更多代理协议支持
3. 完善错误处理和恢复机制
4. 增加单元测试和集成测试
5. 优化性能和内存使用