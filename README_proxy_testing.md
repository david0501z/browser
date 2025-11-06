# 代理测试和验证功能

本文档介绍了 FlClash 浏览器应用中的代理测试和验证功能，包括各种测试工具、性能监控和网络验证功能。

## 功能概述

### 1. 代理测试服务 (ProxyTestService)
- **位置**: `lib/services/proxy_test_service.dart`
- **功能**: 提供全面的代理连接测试功能

#### 测试类型
- **连通性测试 (connectivity)**: 测试代理是否能够正常连接到目标服务器
- **速度测试 (speed)**: 测试代理的下载速度和响应时间
- **DNS测试 (dns)**: 测试代理的DNS解析功能
- **泄漏测试 (leak)**: 检测DNS泄漏和IP泄漏
- **延迟测试 (latency)**: 测试连接到各个服务器的网络延迟
- **带宽测试 (bandwidth)**: 测试代理的带宽性能

#### 主要特性
- 支持多种测试类型和自定义测试URL
- 实时测试结果流
- 测试结果历史记录
- 支持并发测试

#### 使用示例
```dart
final testService = ProxyTestService();

// 设置代理配置
final proxy = ProxyConfig(
  host: '127.0.0.1',
  port: 1080,
  type: ProxyType.socks5,
);
testService.setProxyConfig(proxy);

// 执行单个测试
final result = await testService.runSingleTest(ProxyTestType.connectivity);

// 执行完整测试套件
final results = await testService.runFullTestSuite(
  proxy: proxy,
  testTypes: [
    ProxyTestType.connectivity,
    ProxyTestType.speed,
    ProxyTestType.dns,
  ],
);

// 监听测试结果
testService.testResults.listen((result) {
  print('测试结果: ${result.testType.name} - ${result.success}');
});
```

### 2. 网络验证工具 (NetworkValidator)
- **位置**: `lib/services/network_validator.dart`
- **功能**: 验证网络连接状态和代理配置

#### 主要功能
- **网络连接验证**: 检查网络接口、DNS解析、连通性和速度
- **代理配置验证**: 验证代理地址、端口和类型
- **代理检测**: 自动检测系统中的代理设置
- **DNS安全性**: 检查DNS泄漏和解析一致性
- **实时监控**: 监控网络状态变化

#### 使用示例
```dart
final validator = NetworkValidator();

// 验证网络连接
final result = await validator.validateNetworkConnection();

// 验证代理配置
final proxyResult = await validator.validateNetworkConfiguration(
  host: '127.0.0.1',
  port: 1080,
  proxyType: 'socks5',
);

// 检测系统代理
final proxies = await validator.detectProxies();

// 监控网络状态
validator.monitorNetworkStatus().listen((state) {
  print('网络状态: $state');
});
```

### 3. 代理性能监控器 (ProxyPerformanceMonitor)
- **位置**: `lib/services/proxy_performance_monitor.dart`
- **功能**: 实时监控代理性能和指标

#### 监控指标
- **响应时间**: 平均响应时间和延迟分布
- **吞吐量**: 每秒处理的请求数
- **成功率**: 请求成功的百分比
- **错误率**: 请求失败的百分比
- **统计数据**: 总请求数、成功数、失败数

#### 主要特性
- 实时性能采样
- 可配置的监控参数
- 性能告警功能
- 历史数据存储和导出
- 性能趋势分析

#### 使用示例
```dart
final monitor = ProxyPerformanceMonitor();

// 配置监控参数
monitor.configure(PerformanceMonitoringConfig(
  samplingInterval: Duration(seconds: 30),
  maxSampleCount: 100,
  testUrls: [
    'https://www.google.com',
    'https://httpbin.org/get',
  ],
));

// 开始监控
monitor.startMonitoring();

// 监听性能指标
monitor.metrics.listen((metrics) {
  print('响应时间: ${metrics.responseTime}ms');
  print('成功率: ${(metrics.successRate * 100).toFixed(1)}%');
});

// 获取性能摘要
final summary = monitor.getPerformanceSummary(duration: Duration(hours: 1));

// 导出数据
final exportData = await monitor.exportMetrics();

// 检查告警
final alerts = monitor.checkPerformanceAlerts();
```

### 4. 代理测试Widget (ProxyTestWidget)
- **位置**: `lib/widgets/test/proxy_test_widget.dart`
- **功能**: 提供完整的用户界面来执行代理测试

#### 界面特性
- **代理配置**: 输入代理地址、端口和类型
- **测试选项**: 选择要执行的测试类型
- **实时结果**: 显示测试进度和结果
- **性能监控**: 实时性能图表和指标
- **网络验证**: 显示网络验证状态
- **结果导出**: 导出测试数据

#### 使用示例
```dart
ProxyTestWidget(
  initialProxy: proxyConfig,
  showPerformanceMonitor: true,
  showNetworkValidator: true,
  onTestComplete: (result) {
    print('测试完成: ${result.testType.name}');
  },
  onValidationComplete: (result) {
    print('网络验证: ${result.isValid}');
  },
  onMetricsUpdate: (metrics) {
    print('性能更新: ${metrics.responseTime}ms');
  },
)
```

### 5. 使用示例 (ProxyTestExample)
- **位置**: `lib/examples/proxy_test_example.dart`
- **功能**: 完整的使用示例，演示所有功能

## 快速开始

### 1. 基本使用
```dart
import 'package:flutter/material.dart';
import 'lib/services/proxy_test_service.dart';
import 'lib/services/network_validator.dart';
import 'lib/services/proxy_performance_monitor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('代理测试')),
        body: ProxyTestWidget(),
      ),
    );
  }
}
```

### 2. 自定义测试
```dart
// 创建代理配置
final proxy = ProxyConfig(
  host: '127.0.0.1',
  port: 1080,
  type: ProxyType.socks5,
);

// 执行测试
final testService = ProxyTestService();
testService.setProxyConfig(proxy);

// 执行连通性测试
final connectivityResult = await testService.runSingleTest(
  ProxyTestType.connectivity,
);

// 执行速度测试
final speedResult = await testService.runSingleTest(
  ProxyTestType.speed,
);
```

### 3. 性能监控
```dart
// 创建性能监控器
final monitor = ProxyPerformanceMonitor();

// 配置监控参数
monitor.configure(PerformanceMonitoringConfig(
  samplingInterval: Duration(seconds: 30),
  testUrls: ['https://www.google.com'],
));

// 开始监控
monitor.startMonitoring();

// 监听实时指标
monitor.metrics.listen((metrics) {
  print('响应时间: ${metrics.responseTime}ms');
  print('成功率: ${(metrics.successRate * 100).toFixed(1)}%');
});
```

## 配置参数

### PerformanceMonitoringConfig
```dart
const PerformanceMonitoringConfig({
  this.samplingInterval = const Duration(seconds: 30),    // 采样间隔
  this.maxSampleCount = 100,                             // 最大样本数
  this.testUrls = const [                               // 测试URL列表
    'https://www.google.com',
    'https://httpbin.org/get',
  ],
  this.timeout = const Duration(seconds: 10),            // 超时时间
  this.concurrentRequests = 5,                          // 并发请求数
  this.enableAutoStart = false,                         // 自动开始
  this.alertThresholds = const Duration(seconds: 5),    // 告警阈值
});
```

## 测试结果说明

### ProxyTestResult
- **success**: 测试是否成功
- **duration**: 测试耗时
- **message**: 测试结果消息
- **details**: 详细的测试数据
- **testType**: 测试类型

### NetworkValidationResult
- **isValid**: 网络是否有效
- **errors**: 错误列表
- **warnings**: 警告列表
- **details**: 详细验证信息

### PerformanceMetrics
- **responseTime**: 响应时间 (毫秒)
- **throughput**: 吞吐量 (请求/秒)
- **successRate**: 成功率 (0-1)
- **totalRequests**: 总请求数
- **successfulRequests**: 成功请求数
- **failedRequests**: 失败请求数

## 注意事项

1. **网络权限**: 确保应用具有网络访问权限
2. **代理配置**: 验证代理地址和端口的正确性
3. **测试频率**: 避免过于频繁的测试，以免影响性能
4. **超时设置**: 根据网络环境调整超时时间
5. **数据存储**: 定期清理过期的测试数据

## 故障排除

### 常见问题

1. **测试超时**: 增加超时时间或检查网络连接
2. **DNS解析失败**: 检查DNS设置或切换DNS服务器
3. **代理连接失败**: 验证代理服务器是否正常运行
4. **性能数据异常**: 检查测试URL的可访问性

### 调试技巧

```dart
// 启用调试日志
debugEnableLogs(true);

// 监听网络状态变化
NetworkValidator().stateStream.listen((state) {
  print('网络状态变更: $state');
});

// 检查测试告警
final alerts = monitor.checkPerformanceAlerts();
for (final alert in alerts) {
  print('告警: ${alert['message']}');
}
```

## 扩展功能

### 自定义测试
可以扩展 `ProxyTestService` 来添加自定义测试类型：

```dart
class CustomTestType extends ProxyTestType {
  const CustomTestType._(String name) : super._(name);
  
  static const custom = CustomTestType._('custom');
}

class ExtendedProxyTestService extends ProxyTestService {
  Future<ProxyTestResult> runCustomTest() async {
    // 实现自定义测试逻辑
    return ProxyTestResult(
      testId: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      testType: CustomTestType.custom,
      success: true,
      duration: Duration(seconds: 5),
      timestamp: DateTime.now(),
    );
  }
}
```

### 自定义监控
可以扩展 `ProxyPerformanceMonitor` 来添加自定义指标：

```dart
class ExtendedPerformanceMonitor extends ProxyPerformanceMonitor {
  void addCustomMetric(String name, double value) {
    // 添加自定义指标
    final metrics = PerformanceMetrics(
      timestamp: DateTime.now(),
      responseTime: value,
      throughput: 0,
      successRate: 1.0,
      totalRequests: 1,
      successfulRequests: 1,
      failedRequests: 0,
      errorRate: 0,
      additionalMetrics: {'custom_metric': value},
    );
    
    _addMetrics(metrics);
  }
}
```

## 相关文档

- [代理状态管理](../README_PROXY_STATE_MANAGEMENT.md)
- [订阅和节点管理](../README_SUBSCRIPTION_NODE_MANAGEMENT.md)
- [核心代理API](核心代理API文档)