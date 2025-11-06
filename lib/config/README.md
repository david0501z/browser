# 规则配置和DNS设置系统

## 概述

这是一个完整的规则配置和DNS设置管理系统，专为FlClash浏览器应用设计。该系统提供了强大的规则管理、DNS设置、模板管理、规则验证、匹配算法和DNS保护功能。

## 系统架构

### 核心组件

```
lib/config/
├── rule_manager.dart           # 规则管理器
├── dns_settings_manager.dart   # DNS设置管理器
├── rule_validator.dart         # 规则验证器
├── rule_template_manager.dart  # 规则模板管理器
├── rule_matcher.dart           # 规则匹配算法
├── dns_protection_manager.dart # DNS保护管理器
├── index.dart                  # 统一导出文件
└── config_example.dart         # 使用示例
```

### 核心功能

#### 1. 规则管理 (RuleManager)
- **规则配置**: 支持域名、IP地址、CIDR、端口、协议等多种规则类型
- **规则组管理**: 组织和管理规则组，支持启用/禁用和排序
- **批量操作**: 支持批量导入、导出、启用/禁用规则
- **搜索过滤**: 强大的搜索和过滤功能
- **性能统计**: 详细的规则使用统计和性能报告

#### 2. DNS设置管理 (DNSSettingsManager)
- **多协议支持**: UDP、TCP、TLS、DoH、DoQ协议
- **服务器管理**: 主DNS服务器和备用DNS服务器配置
- **预设配置**: 安全、快速、均衡等预设配置
- **性能监控**: DNS响应时间和成功率监控
- **智能选择**: 自动选择最优DNS服务器

#### 3. 规则验证 (RuleValidator)
- **多层级验证**: 语法、语义、性能、安全验证
- **实时验证**: 规则创建和修改时的实时验证
- **批量验证**: 支持规则文件和配置批量验证
- **详细报告**: 提供详细的验证报告和建议

#### 4. 规则模板管理 (RuleTemplateManager)
- **预定义模板**: 网络、安全、隐私、性能等模板
- **自定义模板**: 支持用户自定义规则模板
- **模板实例化**: 根据参数动态生成规则
- **模板搜索**: 按类型、复杂度、标签搜索模板

#### 5. 规则匹配算法 (RuleMatcher)
- **多种匹配类型**: 精确、前缀、后缀、通配符、正则表达式匹配
- **性能优化**: 预编译正则表达式、智能排序
- **批量匹配**: 支持批量规则匹配
- **匹配统计**: 详细的匹配统计和性能报告

#### 6. DNS保护管理 (DNSProtectionManager)
- **泄漏检测**: 检测IPv6、本地、直连、SmartDNS、透明DNS泄漏
- **保护级别**: 基础、标准、增强、最高四级保护
- **性能优化**: 压缩、缓存、负载均衡等优化
- **健康监控**: DNS服务器健康状态监控

## 使用指南

### 1. 基本初始化

```dart
import 'config/index.dart';

// 初始化所有管理器
await RuleManager.instance.loadFromFile();
await DNSSettingsManager.instance.initialize();
await RuleTemplateManager.instance.initialize();
await DNSProtectionManager.instance.initialize();
```

### 2. 规则管理

```dart
final ruleManager = RuleManager.instance;

// 创建规则
final rule = RuleConfig(
  id: 'custom_rule',
  name: '自定义规则',
  type: RuleType.domain,
  pattern: '*.example.com',
  action: RuleAction.proxy,
  priority: RulePriority.high,
  enabled: true,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// 创建规则组
final group = RuleGroup(
  id: 'my_rules',
  name: '我的规则',
  rules: [rule],
  enabled: true,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// 添加到管理器
await ruleManager.addGroup(group);
await ruleManager.addRule('my_rules', rule);
```

### 3. DNS设置

```dart
final dnsManager = DNSSettingsManager.instance;
await dnsManager.initialize();

// 添加DNS服务器
final dnsServer = DNSServerConfig(
  id: 'custom_dns',
  name: '自定义DNS',
  type: DNSServerType.cloudflare,
  address: '1.1.1.1',
  port: 53,
  protocol: DNSProtocolType.udp,
  enabled: true,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

await dnsManager.addServer(dnsServer);

// 应用预设配置
await dnsManager.applyPreset('secure');
```

### 4. 规则验证

```dart
final validator = RuleValidator.instance;

// 验证单个规则
final result = validator.validateRule(rule);
if (!result.isValid) {
  print('验证失败: ${result.errorMessage}');
}

// 验证规则组
final groupResult = validator.validateGroup(group);
print('验证报告: ${groupResult.summary}');
```

### 5. 规则模板

```dart
final templateManager = RuleTemplateManager.instance;
await templateManager.initialize();

// 从模板创建规则
final customParams = {
  'customDomains': ['myapp.com'],
  'customPriority': RulePriority.high,
};

final rule = await templateManager.createRuleFromTemplate(
  'network_template',
  customParams,
);

// 搜索模板
final templates = templateManager.searchTemplates('网络');
```

### 6. 规则匹配

```dart
final matcher = RuleMatcher.instance;
matcher.setRules(ruleManager.enabledRules);

// 创建匹配上下文
final context = MatchContext(
  source: 'client-device',
  port: 80,
  protocol: 'http',
  timestamp: DateTime.now(),
);

// 执行匹配
final result = matcher.matchComprehensive('example.com', context);
if (result.isMatch) {
  print('匹配规则: ${result.matchedRule?.name}');
}

// 快速匹配
final quickRule = matcher.quickMatch('example.com');
```

### 7. DNS保护

```dart
final protectionManager = DNSProtectionManager.instance;
await protectionManager.initialize();

// 启用DNS保护
final protectionResult = await protectionManager.enableProtection(
  DNSProtectionLevel.enhanced,
);

print('保护状态: ${protectionResult.isProtected}');
print('保护分数: ${protectionResult.protectionScore}%');

// 优化DNS设置
final optimizationResult = await protectionManager.optimizeDNS();
```

## 高级功能

### 1. 批量操作

```dart
// 批量导入规则
final rules = [
  RuleConfig(...),
  RuleConfig(...),
];
await ruleManager.importRules('my_group', rules);

// 批量启用规则
await ruleManager.bulkToggleRules('my_group', ['rule1', 'rule2'], true);

// 导出规则
final exportedData = await ruleManager.exportRules('my_group');
```

### 2. 性能优化

```dart
final matcher = RuleMatcher.instance;

// 启用性能优化
matcher.enableOptimization = true;

// 设置缓存大小
matcher.maxHistorySize = 2000;

// 获取性能报告
final report = matcher.getPerformanceReport();
```

### 3. 自定义配置

```dart
final protectionManager = DNSProtectionManager.instance;

// 更新优化配置
final customConfig = DNSOptimizationConfig(
  enableCompression: true,
  enableCaching: true,
  cacheSize: 2000,
  timeout: Duration(seconds: 3),
);

await protectionManager.updateOptimizationConfig(customConfig);
```

## 配置持久化

所有配置都会自动保存到本地文件系统：

- **规则配置**: `rules_config.json`
- **DNS设置**: `dns_settings.json`
- **模板配置**: `rule_templates.json`
- **保护配置**: `dns_protection/protection_config.json`

配置文件会自动在应用启动时加载，并在修改时自动保存。

## 错误处理

系统提供了完善的错误处理机制：

```dart
try {
  await ruleManager.addRule('group_id', rule);
} on ArgumentError catch (e) {
  print('参数错误: $e');
} on StateError catch (e) {
  print('状态错误: $e');
} catch (e) {
  print('未知错误: $e');
}
```

## 最佳实践

### 1. 规则组织
- 使用有意义的规则组名称
- 按功能或类型分组规则
- 定期清理无效或过期的规则

### 2. DNS优化
- 根据网络环境选择合适的DNS协议
- 定期检查DNS服务器性能
- 启用DNS缓存和压缩功能

### 3. 性能监控
- 定期检查匹配性能统计
- 关注高优先级的规则数量
- 避免过多的复杂正则表达式规则

### 4. 安全考虑
- 启用DNS泄漏保护
- 使用加密的DNS协议（DoH、DoT）
- 定期更新安全模板

## 扩展开发

### 1. 自定义规则类型
```dart
enum CustomRuleType {
  geoLocation,
  deviceType,
  timeBased,
}

class CustomRule extends RuleConfig {
  const CustomRule({
    required super.id,
    required super.name,
    required super.pattern,
    required super.action,
    required super.createdAt,
    required super.updatedAt,
    this.customType,
  });

  final CustomRuleType? customType;
}
```

### 2. 自定义匹配算法
```dart
class CustomMatcher extends RuleMatcher {
  @override
  MatchResult _matchSingleRule(String input, RuleConfig rule, MatchContext context) {
    // 实现自定义匹配逻辑
    return super._matchSingleRule(input, rule, context);
  }
}
```

## 示例代码

完整的示例代码请参考 `config_example.dart` 文件。

## 注意事项

1. 所有管理器都是单例模式，通过 `.instance` 获取实例
2. 修改配置后会自动通知监听器，注意处理UI更新
3. 文件操作可能失败，请确保有足够的存储空间和权限
4. 复杂的正则表达式可能影响性能，建议优化规则模式
5. DNS保护功能需要网络连接，请确保网络可用

## 技术支持

如有问题或建议，请查看示例代码或参考相关文档。