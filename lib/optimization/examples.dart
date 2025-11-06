/// 性能优化使用示例
/// 
/// 展示如何使用代理性能优化和网络处理系统：
/// - 基础使用
/// - 高级配置
/// - 性能监控
/// - 缓存管理
/// - 网络优化
/// - 电池优化
/// - 性能测试
library optimization_examples;

import 'index.dart';

/// 基础使用示例
/// 
/// 演示如何快速初始化和使用性能优化系统
class BasicUsageExample {
  static Future<void> run() async {
    print('=== 基础使用示例 ===');
    
    // 1. 快速初始化优化系统
    final performanceManager = await initOptimizationSystem();
    
    // 2. 使用缓存
    await performanceManager.setCache('user_profile', {
      'name': '张三',
      'age': 25,
      'email': 'zhangsan@example.com',
    });
    
    final profile = await performanceManager.getCache<Map<String, dynamic>>('user_profile');
    print('用户信息: $profile');
    
    // 3. 执行网络请求
    try {
      final response = await performanceManager.executeNetworkRequest(
        host: 'httpbin.org',
        method: 'GET',
        path: '/json',
      );
      
      print('网络请求状态码: ${response.statusCode}');
      print('网络请求头: ${response.headers}');
    } catch (e) {
      print('网络请求失败: $e');
    }
    
    // 4. 查看性能统计
    final stats = performanceManager.integratedStats;
    print('性能分数: ${stats.performanceScore.toStringAsFixed(1)}');
    print('缓存命中率: ${stats.cacheHitRate.toStringAsFixed(1)}%');
    print('内存使用: ${OptimizationUtils.formatBytes(stats.totalMemoryUsage)}');
    
    // 5. 手动触发优化
    await performanceManager.triggerOptimization();
    
    print('基础使用示例完成\n');
    
    // 清理资源
    await performanceManager.dispose();
  }
}

/// 高级配置示例
/// 
/// 演示如何配置高级优化参数
class AdvancedConfigurationExample {
  static Future<void> run() async {
    print('=== 高级配置示例 ===');
    
    // 1. 创建高性能配置
    final highPerformanceConfig = createHighPerformanceConfig();
    
    // 2. 创建省电配置
    final powerSavingConfig = createPowerSavingConfig();
    
    // 3. 自定义性能管理器配置
    final customConfig = PerformanceManagerConfig(
      optimizerConfig: PerformanceConfig(
        enableAutoOptimization: true,
        enableForceGc: true,
        optimizationIntervalSeconds: 30,
        memoryThreshold: 75.0,
        maxConcurrentConnections: 15,
        enableBatteryOptimization: true,
        enableCpuOptimization: true,
      ),
      cacheConfig: CacheConfig(
        enableMemoryCache: true,
        enableDiskCache: true,
        enableNetworkCache: true,
        promoteToMemory: true,
        defaultExpiry: const Duration(hours: 48),
        cleanupInterval: const Duration(minutes: 20),
        preloadInterval: const Duration(minutes: 10),
        maxMemorySize: 150 * 1024 * 1024, // 150MB
        maxDiskSize: 1024 * 1024 * 1024,  // 1GB
        compressionThreshold: 0.85,
      ),
      bandwidthConfig: BandwidthConfig(
        bandwidthLimit: 0, // 无限制
        monitoringInterval: const Duration(seconds: 3),
        maxHistorySize: 1200,
        enableAlerts: true,
        enableOptimization: true,
        enableTrafficLimiting: false,
        alertThreshold: 0.75,
      ),
      enableSmartScheduling: true,
      enableAutoCacheCleanup: true,
      enableIntelligentPreload: true,
      enableAdvancedAnalytics: true,
      reportingInterval: const Duration(minutes: 45),
    );
    
    // 4. 使用自定义配置初始化
    final performanceManager = PerformanceManager();
    await performanceManager.initialize(config: customConfig);
    
    // 5. 监听性能事件
    performanceManager.eventStream.listen((event) {
      print('性能事件: ${event.type} - ${event.data}');
    });
    
    // 6. 获取性能建议
    final recommendations = performanceManager.getRecommendations();
    print('性能建议:');
    for (final recommendation in recommendations) {
      print('  - ${recommendation.title}: ${recommendation.description}');
    }
    
    print('高级配置示例完成\n');
    
    // 清理资源
    await performanceManager.dispose();
  }
}

/// 缓存管理示例
/// 
/// 演示如何使用各种缓存功能
class CacheManagementExample {
  static Future<void> run() async {
    print('=== 缓存管理示例 ===');
    
    final performanceManager = await initOptimizationSystem();
    
    // 1. 基础缓存操作
    await performanceManager.setCache('simple_data', 'Hello, World!');
    final simpleData = await performanceManager.getCache<String>('simple_data');
    print('简单数据: $simpleData');
    
    // 2. 带过期时间的缓存
    await performanceManager.setCache(
      'temporary_data',
      '这个数据5秒后过期',
      expiry: const Duration(seconds: 5),
    );
    
    await Future.delayed(const Duration(seconds: 2));
    final tempData = await performanceManager.getCache<String>('temporary_data');
    print('临时数据(2秒后): $tempData');
    
    await Future.delayed(const Duration(seconds: 4));
    final expiredData = await performanceManager.getCache<String>('temporary_data');
    print('临时数据(6秒后): $expiredData'); // 应该为null
    
    // 3. 批量预加载
    await performanceManager.preloadBatch({
      'user_1': () async => {'id': 1, 'name': '用户1', 'level': 10},
      'user_2': () async => {'id': 2, 'name': '用户2', 'level': 15},
      'user_3': () async => {'id': 3, 'name': '用户3', 'level': 20},
    });
    
    final user1 = await performanceManager.getCache<Map<String, dynamic>>('user_1');
    print('预加载用户数据: $user1');
    
    // 4. 缓存策略示例
    await performanceManager.setCache(
      'memory_only_data',
      '仅内存缓存',
      policy: CachePolicy.memoryOnly,
    );
    
    await performanceManager.setCache(
      'disk_only_data',
      '仅磁盘缓存',
      policy: CachePolicy.diskOnly,
    );
    
    await performanceManager.setCache(
      'all_cache_data',
      '全层级缓存',
      policy: CachePolicy.all,
    );
    
    // 5. 查看缓存统计
    final cacheStats = performanceManager.cacheStats;
    print('缓存统计:');
    print('  命中率: ${cacheStats.hitRate.toStringAsFixed(1)}%');
    print('  总大小: ${OptimizationUtils.formatBytes(cacheStats.totalSize)}');
    print('  总请求: ${cacheStats.totalHits}');
    
    // 6. 清理特定缓存
    await performanceManager.setCache('temp_key', null); // 通过设置为null来清理
    print('已清理临时缓存');
    
    print('缓存管理示例完成\n');
    
    // 清理资源
    await performanceManager.dispose();
  }
}

/// 网络优化示例
/// 
/// 演示如何使用网络连接优化功能
class NetworkOptimizationExample {
  static Future<void> run() async {
    print('=== 网络优化示例 ===');
    
    final performanceManager = await initOptimizationSystem();
    
    // 1. 基础网络请求
    try {
      final response = await performanceManager.executeNetworkRequest(
        host: 'httpbin.org',
        method: 'GET',
        path: '/get',
        headers: {
          'User-Agent': 'FlClash-Browser/1.0',
          'Accept': 'application/json',
        },
      );
      
      print('HTTP请求成功:');
      print('  状态码: ${response.statusCode}');
      print('  响应头: ${response.headers}');
      
    } catch (e) {
      print('HTTP请求失败: $e');
    }
    
    // 2. POST请求示例
    try {
      final postData = {
        'name': '测试用户',
        'email': 'test@example.com',
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      final postResponse = await performanceManager.executeNetworkRequest(
        host: 'httpbin.org',
        method: 'POST',
        path: '/post',
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(postData),
      );
      
      print('POST请求状态码: ${postResponse.statusCode}');
      
    } catch (e) {
      print('POST请求失败: $e');
    }
    
    // 3. 网络连接统计
    final connectionStats = performanceManager.connectionStats;
    print('网络连接统计:');
    print('  总连接数: ${connectionStats.totalConnections}');
    print('  活跃连接数: ${connectionStats.activeConnections}');
    print('  成功率: ${connectionStats.successRate.toStringAsFixed(1)}%');
    print('  平均响应时间: ${connectionStats.avgResponseTimeMs.toStringAsFixed(0)}ms');
    
    // 4. 带宽监控
    final bandwidthStats = performanceManager.bandwidthStats;
    print('带宽使用统计:');
    print('  当前下载速率: ${OptimizationUtils.formatSpeed(bandwidthStats.currentDownloadRate)}');
    print('  当前上传速率: ${OptimizationUtils.formatSpeed(bandwidthStats.currentUploadRate)}');
    print('  总请求数: ${bandwidthStats.totalRequests}');
    print('  峰值下载速率: ${OptimizationUtils.formatSpeed(bandwidthStats.peakDownloadRate)}');
    
    print('网络优化示例完成\n');
    
    // 清理资源
    await performanceManager.dispose();
  }
}

/// 性能监控示例
/// 
/// 演示如何使用性能监控和分析功能
class PerformanceMonitoringExample {
  static Future<void> run() async {
    print('=== 性能监控示例 ===');
    
    final performanceManager = await initOptimizationSystem();
    
    // 1. 监听性能事件
    performanceManager.eventStream.listen((event) {
      switch (event.type) {
        case EventType.managerInitialized:
          print('性能管理器初始化完成');
          break;
        case EventType.performanceIssue:
          print('性能问题检测到: ${event.data}');
          break;
        case EventType.performanceReport:
          print('性能报告生成: ${event.data}');
          break;
        case EventType.networkRequest:
          print('网络请求完成: ${event.data}');
          break;
        case EventType.manualOptimization:
          print('手动优化已执行');
          break;
        case EventType.statsReset:
          print('统计已重置');
          break;
      }
    });
    
    // 2. 持续监控一段时间
    print('开始性能监控...');
    final monitoringDuration = const Duration(seconds: 30);
    final endTime = DateTime.now().add(monitoringDuration);
    
    while (DateTime.now().isBefore(endTime)) {
      final stats = performanceManager.integratedStats;
      final qualityScore = await performanceManager.getNetworkQualityScore();
      
      print('性能监控数据:');
      print('  综合性能分数: ${stats.performanceScore.toStringAsFixed(1)}');
      print('  网络质量评分: ${qualityScore.toStringAsFixed(2)}');
      print('  内存使用: ${OptimizationUtils.formatBytes(stats.totalMemoryUsage)}');
      print('  活跃连接: ${stats.activeConnections}');
      print('  缓存命中率: ${stats.cacheHitRate.toStringAsFixed(1)}%');
      print('  带宽使用: ${OptimizationUtils.formatSpeed(stats.bandwidthUsage)}');
      
      await Future.delayed(const Duration(seconds: 5));
      print('---');
    }
    
    // 3. 生成性能报告
    print('生成性能报告...');
    final performanceData = await performanceManager.exportPerformanceData();
    
    print('性能数据导出完成');
    print('  报告时间: ${performanceData['managerInfo']['startTime']}');
    print('  最后更新: ${performanceData['managerInfo']['lastUpdateTime']}');
    print('  性能分数: ${performanceData['integratedStats']['performanceScore']}');
    
    // 4. 性能测试
    print('执行性能测试...');
    final testResult = await PerformanceTester.runComprehensiveTest(performanceManager);
    
    print('性能测试结果:');
    print('  测试耗时: ${OptimizationUtils.formatDuration(testResult.duration)}');
    testResult.results.forEach((key, value) {
      print('  $key: $value');
    });
    
    print('性能监控示例完成\n');
    
    // 清理资源
    await performanceManager.dispose();
  }
}

/// 电池和内存优化示例
/// 
/// 演示电池和内存优化功能
class BatteryMemoryOptimizationExample {
  static Future<void> run() async {
    print('=== 电池和内存优化示例 ===');
    
    // 1. 使用省电配置
    final powerSavingConfig = createPowerSavingConfig();
    final performanceManager = PerformanceManager();
    
    await performanceManager.initialize(
      config: powerSavingConfig,
      enableAutoOptimization: true,
    );
    
    print('已启用省电优化模式');
    
    // 2. 模拟大量内存使用
    print('模拟大量内存使用...');
    final largeData = List.generate(10000, (i) => 'data_item_$i' * 100);
    
    for (int i = 0; i < 100; i++) {
      await performanceManager.setCache('large_data_$i', largeData);
      
      // 显示内存使用情况
      if (i % 20 == 0) {
        final stats = performanceManager.integratedStats;
        print('内存使用进度: ${i}/100 - ${OptimizationUtils.formatBytes(stats.totalMemoryUsage)}');
      }
    }
    
    // 3. 查看内存优化效果
    final optimizerStats = performanceManager.optimizerStats;
    print('内存优化统计:');
    print('  当前内存使用: ${OptimizationUtils.formatBytes(optimizerStats.currentMemoryUsage)}');
    print('  峰值内存使用: ${OptimizationUtils.formatBytes(optimizerStats.peakMemoryUsage)}');
    print('  总优化次数: ${optimizerStats.totalOptimizations}');
    print('  平均优化耗时: ${OptimizationUtils.formatDuration(optimizerStats.avgOptimizationDuration)}');
    
    // 4. 手动触发垃圾回收和内存优化
    print('手动触发内存优化...');
    await performanceManager.triggerOptimization();
    
    await Future.delayed(const Duration(seconds: 3));
    
    final statsAfterOptimization = performanceManager.integratedStats;
    print('优化后内存使用: ${OptimizationUtils.formatBytes(statsAfterOptimization.totalMemoryUsage)}');
    
    // 5. 清理大量数据并测试内存回收
    print('清理测试数据...');
    for (int i = 0; i < 100; i++) {
      await performanceManager.setCache('large_data_$i', null);
    }
    
    await Future.delayed(const Duration(seconds: 2));
    
    final finalStats = performanceManager.integratedStats;
    print('清理后内存使用: ${OptimizationUtils.formatBytes(finalStats.totalMemoryUsage)}');
    print('内存回收效果: ${(optimizerStats.peakMemoryUsage - finalStats.totalMemoryUsage) > 0 ? '良好' : '一般'}');
    
    print('电池和内存优化示例完成\n');
    
    // 清理资源
    await performanceManager.dispose();
  }
}

/// 综合性能优化示例
/// 
/// 演示完整的性能优化工作流程
class ComprehensiveOptimizationExample {
  static Future<void> run() async {
    print('=== 综合性能优化示例 ===');
    
    // 1. 初始化高性能配置
    final highConfig = createHighPerformanceConfig();
    final performanceManager = PerformanceManager();
    
    await performanceManager.initialize(
      config: highConfig,
      enableAutoOptimization: true,
    );
    
    print('已初始化高性能优化系统');
    
    // 2. 预热缓存
    print('预热缓存数据...');
    final warmupData = {
      'app_config': {
        'version': '1.0.0',
        'debug': false,
        'cache_enabled': true,
      },
      'user_preferences': {
        'theme': 'dark',
        'language': 'zh-CN',
        'auto_update': true,
      },
      'system_status': {
        'uptime': DateTime.now().toIso8601String(),
        'memory_status': 'normal',
        'network_status': 'connected',
      },
    };
    
    warmupData.forEach((key, value) async {
      await performanceManager.setCache(key, value);
    });
    
    // 3. 执行综合性能测试
    print('执行综合性能测试...');
    final testResult = await PerformanceTester.runComprehensiveTest(performanceManager);
    
    // 4. 模拟实际工作负载
    print('模拟实际工作负载...');
    
    final workloadTasks = <Future<void>>[];
    for (int i = 0; i < 50; i++) {
      workloadTasks.add(_simulateWorkloadTask(performanceManager, i));
    }
    
    await Future.wait(workloadTasks);
    
    // 5. 等待自动优化生效
    print('等待自动优化生效...');
    await Future.delayed(const Duration(seconds: 10));
    
    // 6. 收集最终性能数据
    final finalStats = performanceManager.integratedStats;
    final recommendations = performanceManager.getRecommendations();
    final testResults = await performanceManager.exportPerformanceData();
    
    // 7. 输出综合报告
    print('=== 综合性能报告 ===');
    print('性能分数: ${finalStats.performanceScore.toStringAsFixed(1)}/100');
    print('内存使用: ${OptimizationUtils.formatBytes(finalStats.totalMemoryUsage)}');
    print('缓存命中率: ${finalStats.cacheHitRate.toStringAsFixed(1)}%');
    print('连接成功率: ${finalStats.connectionSuccessRate.toStringAsFixed(1)}%');
    print('网络质量评分: ${await performanceManager.getNetworkQualityScore().then((score) => score.toStringAsFixed(2))}');
    
    if (recommendations.isNotEmpty) {
      print('\n性能建议:');
      for (final recommendation in recommendations) {
        print('  - ${OptimizationUtils.getPriorityDescription(recommendation.priority)}: ${recommendation.title}');
        print('    ${recommendation.description}');
      }
    } else {
      print('\n当前性能良好，暂无优化建议');
    }
    
    print('\n测试结果:');
    testResult.results.forEach((key, value) {
      if (value is num) {
        print('  $key: $value');
      }
    });
    
    print('\n综合性能优化示例完成');
    
    // 清理资源
    await performanceManager.dispose();
  }
  
  static Future<void> _simulateWorkloadTask(PerformanceManager manager, int taskId) async {
    // 模拟各种工作负载
    await manager.setCache('task_data_$taskId', 'task_$taskId');
    await Future.delayed(Duration(milliseconds: Random().nextInt(100) + 50));
    await manager.getCache<String>('task_data_$taskId');
    await Future.delayed(Duration(milliseconds: Random().nextInt(50) + 25));
  }
}

/// 主函数 - 运行所有示例
Future<void> main() async {
  print('开始性能优化示例演示...\n');
  
  try {
    // 运行基础示例
    await BasicUsageExample.run();
    await Future.delayed(const Duration(seconds: 2));
    
    // 运行高级配置示例
    await AdvancedConfigurationExample.run();
    await Future.delayed(const Duration(seconds: 2));
    
    // 运行缓存管理示例
    await CacheManagementExample.run();
    await Future.delayed(const Duration(seconds: 2));
    
    // 运行网络优化示例
    await NetworkOptimizationExample.run();
    await Future.delayed(const Duration(seconds: 2));
    
    // 运行性能监控示例
    await PerformanceMonitoringExample.run();
    await Future.delayed(const Duration(seconds: 2));
    
    // 运行电池内存优化示例
    await BatteryMemoryOptimizationExample.run();
    await Future.delayed(const Duration(seconds: 2));
    
    // 运行综合优化示例
    await ComprehensiveOptimizationExample.run();
    
    print('\n所有示例演示完成！');
    
  } catch (e, stackTrace) {
    print('示例运行出错: $e');
    print('StackTrace: $stackTrace');
  }
}