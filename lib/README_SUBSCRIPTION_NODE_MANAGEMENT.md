# 订阅链接和节点管理系统

## 项目概述

本项目实现了一套完整的代理服务器订阅链接和节点管理功能，支持多种代理协议和订阅格式，提供全面的节点验证、测试、筛选和管理功能。

## 系统架构

```
lib/
├── models/                     # 数据模型
│   ├── subscription.dart      # 订阅链接模型
│   └── proxy_node.dart        # 代理节点模型
├── services/                   # 服务层
│   ├── subscription_service.dart     # 订阅服务
│   ├── proxy_node_manager.dart      # 节点管理器
│   ├── speed_test_service.dart      # 速度测试服务
│   └── import_export_service.dart   # 导入导出服务
├── utils/                      # 工具类
│   └── node_validator.dart     # 节点验证器
└── examples/                   # 示例代码
    └── subscription_and_node_management_example.dart
```

## 核心功能

### 1. 订阅链接管理 (subscription_service.dart)

- **订阅链接管理**
  - 添加、删除、更新订阅链接
  - 支持多种订阅格式：V2Ray、Clash、Clash Meta、SS、Trojan
  - 自动检测订阅类型
  - 订阅状态管理（正常、禁用、更新中、错误）

- **订阅内容解析**
  - 支持 Base64 编码的订阅链接
  - 支持 Clash JSON 配置格式
  - 支持 V2Ray 标准订阅格式
  - 自动格式检测和解析

- **订阅更新**
  - 自动更新订阅内容
  - 并发/串行更新选项
  - 更新进度跟踪
  - 错误处理和重试机制

### 2. 代理节点管理 (proxy_node_manager.dart)

- **节点CRUD操作**
  - 添加、删除、更新节点
  - 批量操作支持
  - 节点状态管理

- **节点筛选和排序**
  - 按类型、状态、国家、ISP筛选
  - 按延迟、速度、优先级排序
  - 自定义筛选条件
  - 关键词搜索

- **智能节点选择**
  - 基于延迟和成功率的最佳节点选择
  - 随机节点选择
  - 最快节点选择
  - 最稳定节点选择

- **统计信息**
  - 节点总数、启用数、禁用数
  - 节点类型分布统计
  - 平均延迟和成功率
  - 国家分布统计

### 3. 节点验证 (node_validator.dart)

- **配置验证**
  - 基础信息验证（地址、端口、名称）
  - 协议特定配置验证
  - UUID、密码强度验证
  - 传输配置验证

- **网络安全验证**
  - DNS解析测试
  - 端口连接测试
  - 私有IP检测
  - 知名服务器检测

- **安全评估**
  - 代理服务类型识别
  - 住宅IP检测
  - 敏感关键词检测
  - 安全风险警告

### 4. 节点测试 (speed_test_service.dart)

- **延迟测试**
  - 多轮测试取平均值
  - 支持并发测试
  - 可配置超时时间
  - 测试结果缓存

- **速度测试**
  - 下载速度测试
  - 上传速度测试（简化实现）
  - 综合性能评分
  - 测试结果统计

- **批量测试**
  - 并发节点测试
  - 测试进度跟踪
  - 结果统计分析
  - 错误处理

### 5. 导入导出 (import_export_service.dart)

- **导出功能**
  - 支持多种格式：Clash、V2Ray、SS、Base64、JSON
  - 导出到文件或字符串
  - 支持元数据导出
  - 批量导出操作

- **导入功能**
  - 自动格式检测
  - 节点配置解析
  - 重复节点处理
  - 导入结果统计

- **备份恢复**
  - 完整配置备份
  - 增量备份支持
  - 数据完整性验证
  - 一键恢复功能

## 支持的协议和格式

### 代理协议
- **VMess** - V2Ray 原生协议
- **VLESS** - V2Ray 新一代协议  
- **Shadowsocks** - 经典代理协议
- **ShadowsocksR** - SSR 扩展协议
- **Trojan** - 伪装协议
- **SOCKS5** - 标准代理协议
- **HTTP** - HTTP 代理

### 订阅格式
- **V2Ray 订阅** - 标准 VMess/VLESS/SS URL 格式
- **Clash 配置** - YAML/JSON 格式的完整配置
- **Clash Meta** - 增强版 Clash 配置
- **Base64 订阅** - Base64 编码的订阅内容
- **URL 订阅** - 直接的订阅链接列表

## 技术特点

### 1. 性能优化
- **并发处理** - 支持订阅和节点测试的并发操作
- **异步编程** - 全程使用 async/await，避免阻塞
- **内存管理** - 智能缓存和资源清理
- **批量操作** - 高效的批量数据库操作

### 2. 错误处理
- **异常捕获** - 完整的错误处理机制
- **重试机制** - 网络请求自动重试
- **降级策略** - 部分功能失败时的备用方案
- **用户友好** - 详细的错误信息和警告

### 3. 扩展性
- **插件化设计** - 易于添加新的代理协议
- **配置灵活** - 丰富的配置选项
- **接口标准化** - 统一的 API 接口
- **模块化架构** - 松耦合的模块设计

### 4. 安全性
- **输入验证** - 严格的参数验证
- **安全扫描** - 节点安全风险评估
- **数据保护** - 本地数据加密存储
- **权限控制** - 细粒度的权限管理

## 使用示例

### 基本使用

```dart
// 1. 初始化管理器
final nodeManager = ProxyNodeManager();
await nodeManager.initialize();

// 2. 添加订阅
final subscriptionService = SubscriptionService();
final subscription = await subscriptionService.addSubscription(
  name: '我的订阅',
  url: 'https://example.com/subscription',
  type: SubscriptionType.v2ray,
);

// 3. 更新订阅
final updateResult = await subscriptionService.updateSubscriptionById(
  subscription.id,
);

// 4. 获取节点
final nodes = nodeManager.allNodes;

// 5. 测试节点
final speedTestService = SpeedTestService();
final testResult = await speedTestService.testNodeLatency(nodes.first);

// 6. 选择最佳节点
final bestNode = nodeManager.getBestNode();
if (bestNode != null) {
  await nodeManager.selectNode(bestNode.id);
}
```

### 高级功能

```dart
// 筛选节点
final filteredNodes = nodeManager.filterNodes(
  NodeFilter(
    types: [ProxyType.vmess, ProxyType.ss],
    maxLatency: 200,
    minSuccessRate: 90.0,
    keyword: '高速',
  ),
);

// 排序节点
final sortedNodes = nodeManager.sortNodes(
  filteredNodes,
  NodeSort(
    field: NodeSortField.latency,
    order: SortOrder.asc,
  ),
);

// 批量测试
final batchResults = await speedTestService.batchTestLatency(
  nodes,
  concurrency: 5,
);

// 导出节点
final importExportService = ImportExportService();
final exportResult = await importExportService.exportNodesToFile(
  nodes: nodes,
  format: ExportFormat.clash,
  filePath: '/path/to/export.yaml',
);

// 导入节点
final importResult = await importExportService.importNodesFromFile(
  filePath: '/path/to/import.yaml',
  validateNodes: true,
  skipInvalid: true,
);
```

## 依赖项

在 `pubspec.yaml` 中添加以下依赖：

```yaml
dependencies:
  dio: ^5.3.0          # HTTP 客户端
  freezed_annotation: ^2.4.1   # 数据模型
  json_annotation: ^4.8.1     # JSON 序列化
  crypto: ^3.0.3              # 加密功能
  collection: ^1.17.2         # 集合操作
  ip: ^2.0.0                  # IP 地址处理

dev_dependencies:
  build_runner: ^2.4.7        # 代码生成
  freezed: ^2.4.6             # Freezed 代码生成
  json_serializable: ^6.7.1   # JSON 序列化代码生成
```

## 运行示例

```dart
void main() async {
  final example = SubscriptionAndNodeManagementExample();
  await example.runAllExamples();
  example.dispose();
}
```

## 注意事项

1. **网络连接** - 某些功能需要网络连接才能正常工作
2. **流量消耗** - 节点测试会消耗一定的网络流量
3. **权限要求** - 可能需要网络访问权限
4. **数据库初始化** - 使用前需要初始化数据库
5. **错误处理** - 建议实现适当的错误处理机制

## 扩展建议

1. **数据库存储** - 实现持久化存储
2. **图形界面** - 开发用户友好的管理界面
3. **自动更新** - 实现订阅的自动更新机制
4. **性能优化** - 进一步优化大规模节点的处理性能
5. **云同步** - 添加云端同步功能

---

本系统提供了完整的订阅链接和节点管理解决方案，具备良好的扩展性和维护性，适用于各种代理管理应用场景。