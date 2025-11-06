import '../models/subscription.dart';
import '../models/proxy_node.dart';
import '../services/subscription_service.dart';
import '../services/proxy_node_manager.dart';
import '../services/import_export_service.dart';
import '../services/speed_test_service.dart';
import '../utils/node_validator.dart';

/// 订阅链接和节点管理示例
class SubscriptionAndNodeManagementExample {
  final SubscriptionService _subscriptionService = SubscriptionService();
  final ProxyNodeManager _nodeManager = ProxyNodeManager();
  final ImportExportService _importExportService = ImportExportService();
  final SpeedTestService _speedTestService = SpeedTestService();
  final NodeValidator _nodeValidator = NodeValidator();

  /// 运行所有示例
  Future<void> runAllExamples() async {
    print('=== 订阅链接和节点管理示例 ===\n');

    try {
      // 初始化管理器
      await _nodeManager.initialize();
      print('✓ 节点管理器初始化完成\n');

      // 示例 1: 订阅管理
      await _subscriptionManagementExample();
      
      // 示例 2: 节点管理
      await _nodeManagementExample();
      
      // 示例 3: 节点验证
      await _nodeValidationExample();
      
      // 示例 4: 节点测试
      await _nodeTestingExample();
      
      // 示例 5: 导入导出
      await _importExportExample();

      print('\n=== 所有示例运行完成 ===');
    } catch (e) {
      print('示例运行出错: $e');
    }
  }

  /// 订阅管理示例
  Future<void> _subscriptionManagementExample() async {
    print('--- 订阅管理示例 ---');
    
    try {
      // 1. 添加订阅
      print('1. 添加订阅链接...');
      final subscription = await _subscriptionService.addSubscription(
        name: '示例订阅',
        url: 'https://example.com/subscription',
        type: SubscriptionType.v2ray,
      );
      print('   ✓ 订阅添加成功: ${subscription.name}\n');

      // 2. 更新订阅
      print('2. 更新订阅...');
      final updateResult = await _subscriptionService.updateSubscriptionById(
        subscription.id,
      );
      if (updateResult.success) {
        print('   ✓ 订阅更新成功，更新了 ${updateResult.addedNodes} 个节点\n');
      } else {
        print('   ✗ 订阅更新失败: ${updateResult.error}\n');
      }

      // 3. 获取所有订阅
      print('3. 获取所有订阅...');
      final subscriptions = await _subscriptionService.getSubscriptions();
      print('   订阅数量: ${subscriptions.length}\n');

      // 4. 导入订阅
      print('4. 导入订阅链接...');
      final subscriptionContent = '''
https://example.com/v2ray-subscription
https://example.com/clash-subscription
https://example.com/ss-subscription
''';
      
      final importResult = await _subscriptionService.importSubscriptionsFromContent(
        content: subscriptionContent,
      );
      print('   ✓ 导入 ${importResult.importedSubscriptions} 个订阅\n');
    } catch (e) {
      print('   ✗ 订阅管理示例出错: $e\n');
    }
  }

  /// 节点管理示例
  Future<void> _nodeManagementExample() async {
    print('--- 节点管理示例 ---');
    
    try {
      // 1. 创建示例节点
      print('1. 创建示例节点...');
      final vmessNode = ProxyNode(
        id: '',
        name: 'VMess 测试节点',
        type: ProxyType.vmess,
        version: ProxyVersion.vmess,
        server: 'example.com',
        port: 443,
        vmessConfig: VMessConfig(
          uuid: '12345678-1234-1234-1234-123456789abc',
          encryption: 'auto',
          transport: 'ws',
          tls: true,
          sni: 'example.com',
        ),
      );

      final ssNode = ProxyNode(
        id: '',
        name: 'SS 测试节点',
        type: ProxyType.ss,
        version: ProxyVersion.ss,
        server: 'ss.example.com',
        port: 8388,
        ssConfig: SSConfig(
          password: 'test-password',
          method: 'aes-256-gcm',
        ),
      );

      // 2. 添加节点
      print('2. 添加节点...');
      await _nodeManager.addNode(vmessNode);
      await _nodeManager.addNode(ssNode);
      print('   ✓ 节点添加成功\n');

      // 3. 获取所有节点
      print('3. 获取所有节点...');
      final allNodes = _nodeManager.allNodes;
      print('   总节点数: ${allNodes.length}\n');

      // 4. 筛选节点
      print('4. 筛选节点...');
      final vmessNodes = _nodeManager.filterNodes(
        const NodeFilter(types: [ProxyType.vmess]),
      );
      print('   VMess 节点数: ${vmessNodes.length}\n');

      // 5. 排序节点
      print('5. 按延迟排序节点...');
      final sortedNodes = _nodeManager.sortNodes(
        allNodes,
        const NodeSort(field: NodeSortField.latency, order: SortOrder.asc),
      );
      print('   排序完成\n');

      // 6. 获取最佳节点
      print('6. 获取最佳节点...');
      final bestNode = _nodeManager.getBestNode();
      if (bestNode != null) {
        print('   最佳节点: ${bestNode.name}\n');
      } else {
        print('   没有可用的最佳节点\n');
      }

      // 7. 选择节点
      if (allNodes.isNotEmpty) {
        print('7. 选择节点...');
        await _nodeManager.selectNode(allNodes.first.id);
        final selectedNode = _nodeManager.selectedNode;
        print('   选中节点: ${selectedNode?.name ?? '无'}\n');
      }

      // 8. 切换节点状态
      if (allNodes.isNotEmpty) {
        print('8. 切换节点状态...');
        await _nodeManager.toggleNodeEnabled(allNodes.first.id);
        print('   节点状态切换完成\n');
      }

      // 9. 获取统计信息
      print('9. 节点统计信息...');
      final stats = _nodeManager.getStatistics();
      print('   总节点: ${stats.totalNodes}');
      print('   启用节点: ${stats.enabledNodes}');
      print('   收藏节点: ${stats.favoriteNodes}');
      print('   平均延迟: ${stats.avgLatency?.toStringAsFixed(0) ?? 'N/A'}ms');
      print('   平均成功率: ${stats.avgSuccessRate.toStringAsFixed(1)}%\n');
    } catch (e) {
      print('   ✗ 节点管理示例出错: $e\n');
    }
  }

  /// 节点验证示例
  Future<void> _nodeValidationExample() async {
    print('--- 节点验证示例 ---');
    
    try {
      // 1. 验证单个节点
      print('1. 验证单个节点...');
      final allNodes = _nodeManager.allNodes;
      if (allNodes.isNotEmpty) {
        final validationResult = await _nodeValidator.validateNode(allNodes.first);
        print('   验证结果: ${validationResult.summary}');
        if (validationResult.warnings.isNotEmpty) {
          print('   警告: ${validationResult.warnings.join(', ')}');
        }
        print('');
      }

      // 2. 验证节点配置字符串
      print('2. 验证节点配置字符串...');
      const testConfig = 'vmess://eyJ2IjoiMiIsInBzIjoidGVzdCIsImFkZCI6ImV4YW1wbGUuY29tIiwicG9ydCI6IjQ0MyIsImlkIjoiMTIzNDU2NzgtMTIzNC0xMjM0LTEyMzQtMTIzNDU2Nzg5YWJjIiwiYWlkIjoiMCIsIm5ldCI6IndzIiwidHlwZSI6Im5vbmUiLCJob3N0IjoiIiwiUGF0aCI6IiIsInRscyI6InRscyJ9';
      
      final configValidation = _nodeValidator.validateNodeConfig(testConfig);
      print('   配置验证结果: ${configValidation.summary}');
      print('');

      // 3. 批量验证节点
      print('3. 批量验证节点...');
      final batchValidation = await _nodeValidator.batchValidateNodes(allNodes);
      final validCount = batchValidation.values.where((v) => v.isValid).length;
      print('   有效节点: $validCount/${allNodes.length}');
      print('');
    } catch (e) {
      print('   ✗ 节点验证示例出错: $e\n');
    }
  }

  /// 节点测试示例
  Future<void> _nodeTestingExample() async {
    print('--- 节点测试示例 ---');
    
    try {
      final allNodes = _nodeManager.allNodes;
      if (allNodes.isEmpty) {
        print('   没有可测试的节点\n');
        return;
      }

      // 1. 测试单个节点
      print('1. 测试单个节点延迟...');
      final testResult = await _speedTestService.testNodeLatency(
        allNodes.first,
        timeoutSeconds: 10,
        testCount: 3,
      );
      
      if (testResult.success) {
        print('   ✓ 延迟: ${testResult.latency}ms\n');
      } else {
        print('   ✗ 测试失败: ${testResult.error}\n');
      }

      // 2. 综合测试节点
      print('2. 综合测试节点...');
      final comprehensiveResult = await _speedTestService.comprehensiveNodeTest(
        allNodes.first,
        timeoutSeconds: 30,
      );
      
      if (comprehensiveResult.success) {
        print('   ✓ 综合评分: ${comprehensiveResult.score.toStringAsFixed(1)}/100');
        print('   ✓ 总耗时: ${comprehensiveResult.totalTime}秒\n');
      } else {
        print('   ✗ 综合测试失败\n');
      }

      // 3. 批量测试节点
      print('3. 批量测试节点延迟...');
      final batchResults = await _speedTestService.batchTestLatency(
        allNodes.take(3).toList(), // 只测试前3个节点
        timeoutSeconds: 5,
        concurrency: 2,
      );
      
      final successfulTests = batchResults.values.where((r) => r.success).length;
      print('   ✓ 成功测试: $successfulTests/${batchResults.length}\n');

      // 4. 测试连接性
      print('4. 测试网络连接性...');
      final isConnected = await _speedTestService.testConnectivity();
      print('   网络连接: ${isConnected ? '正常' : '异常'}\n');

      // 5. 获取本地 IP
      print('5. 获取本地 IP...');
      final localIP = await _speedTestService.getLocalIP();
      print('   本地 IP: $localIP\n');
    } catch (e) {
      print('   ✗ 节点测试示例出错: $e\n');
    }
  }

  /// 导入导出示例
  Future<void> _importExportExample() async {
    print('--- 导入导出示例 ---');
    
    try {
      final allNodes = _nodeManager.allNodes;
      if (allNodes.isEmpty) {
        print('   没有可导出的节点\n');
        return;
      }

      // 1. 导出节点为不同格式
      print('1. 导出节点为不同格式...');
      
      // V2Ray 格式
      final v2rayContent = await _importExportService.exportNodesToString(
        allNodes,
        ExportFormat.v2ray,
        true,
      );
      print('   ✓ V2Ray 格式: ${v2rayContent.length} 字符');

      // Clash 格式
      final clashContent = await _importExportService.exportNodesToString(
        allNodes,
        ExportFormat.clash,
        true,
      );
      print('   ✓ Clash 格式: ${clashContent.length} 字符');

      // JSON 格式
      final jsonContent = await _importExportService.exportNodesToString(
        allNodes,
        ExportFormat.json,
        true,
      );
      print('   ✓ JSON 格式: ${jsonContent.length} 字符\n');

      // 2. 导入节点
      print('2. 导入节点...');
      final importResult = await _importExportService.importNodesFromContent(
        content: v2rayContent,
        validateNodes: true,
        skipInvalid: true,
      );
      
      if (importResult.success) {
        print('   ✓ 导入成功: ${importResult.importedNodes} 个节点');
        print('   ✓ 有效节点: ${importResult.validNodes} 个');
        if (importResult.errors.isNotEmpty) {
          print('   错误: ${importResult.errors.length} 个');
        }
        print('');
      } else {
        print('   ✗ 导入失败: ${importResult.errors.join(', ')}\n');
      }

      // 3. 复制配置到剪贴板
      print('3. 复制单个节点配置...');
      final nodeConfig = await _importExportService.copyNodeConfigToClipboard(
        allNodes.first,
        ExportFormat.v2ray,
      );
      print('   配置长度: ${nodeConfig.length} 字符\n');

      // 4. 生成备份
      print('4. 生成备份...');
      final backupContent = await _importExportService.generateBackup(
        includeNodes: true,
        includeSubscriptions: true,
        includeSettings: true,
      );
      print('   ✓ 备份大小: ${backupContent.length} 字符\n');

      // 5. 从备份恢复
      print('5. 从备份恢复...');
      final restoreResult = await _importExportService.restoreFromBackup(backupContent);
      print('   恢复结果: ${restoreResult.success ? '成功' : '失败'}');
      if (restoreResult.success) {
        print('   恢复节点: ${restoreResult.totalNodes} 个');
        print('   恢复订阅: ${restoreResult.importedSubscriptions} 个\n');
      } else {
        print('   恢复失败: ${restoreResult.errors.join(', ')}\n');
      }
    } catch (e) {
      print('   ✗ 导入导出示例出错: $e\n');
    }
  }

  /// 高级功能示例
  Future<void> _advancedFeaturesExample() async {
    print('--- 高级功能示例 ---');
    
    try {
      final allNodes = _nodeManager.allNodes;
      
      // 1. 智能节点选择
      print('1. 智能节点选择...');
      final bestNode = _nodeManager.getBestNode();
      final fastestNode = _nodeManager.getFastestNode();
      final randomNode = _nodeManager.getRandomNode();
      final stableNode = _nodeManager.getMostStableNode();
      
      print('   最佳节点: ${bestNode?.name ?? '无'}');
      print('   最快节点: ${fastestNode?.name ?? '无'}');
      print('   随机节点: ${randomNode?.name ?? '无'}');
      print('   最稳定节点: ${stableNode?.name ?? '无'}\n');

      // 2. 复杂筛选
      print('2. 复杂节点筛选...');
      final complexFilter = const NodeFilter(
        types: [ProxyType.vmess, ProxyType.ss],
        isEnabled: true,
        maxLatency: 500,
        minSuccessRate: 80.0,
        keyword: 'test',
      );
      
      final filteredNodes = _nodeManager.filterNodes(complexFilter);
      print('   筛选结果: ${filteredNodes.length} 个节点\n');

      // 3. 批量操作
      print('3. 批量操作...');
      if (allNodes.length >= 2) {
        final nodeIds = allNodes.take(2).map((n) => n.id).toList();
        
        // 批量切换收藏状态
        // 注意：这里需要为 ProxyNodeManager 添加批量切换方法
        print('   批量操作演示完成\n');
      }

      // 4. 性能监控
      print('4. 性能监控...');
      final stats = _nodeManager.getStatistics();
      print('   节点类型分布:');
      for (final entry in stats.typeCounts.entries) {
        print('     ${entry.key}: ${entry.value}');
      }
      print('');
      
    } catch (e) {
      print('   ✗ 高级功能示例出错: $e\n');
    }
  }

  /// 清理资源
  void dispose() {
    _subscriptionService.dispose();
    _nodeManager.dispose();
    _speedTestService.dispose();
    _nodeValidator.dispose();
  }
}

/// 主函数示例
Future<void> main() async {
  final example = SubscriptionAndNodeManagementExample();
  
  try {
    await example.runAllExamples();
  } finally {
    example.dispose();
  }
}

/// 使用说明：
/// 1. 确保已正确设置 pubspec.yaml 依赖
/// 2. 运行此示例前需要初始化数据库
/// 3. 某些网络相关功能需要网络连接
/// 4. 节点测试可能会消耗流量，请注意