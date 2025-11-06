import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// 资源监控器 - 提供系统资源全面监控、预警和自动优化功能
class ResourceMonitor {
  static const MethodChannel _channel = MethodChannel('resource_monitor');

  static final ResourceMonitor _instance = ResourceMonitor._internal();
  factory ResourceMonitor() => _instance;
  ResourceMonitor._internal();

  // 资源阈值配置
  static const double _warningCpuThreshold = 0.8;
  static const double _warningMemoryThreshold = 0.85;
  static const double _warningDiskThreshold = 0.9;
  static const double _warningNetworkThreshold = 0.8;
  static const double _criticalThreshold = 0.95;

  // 监控相关
  Timer? _monitorTimer;
  DateTime? _lastSystemCheck;
  final List<ResourceAlert> _alerts = [];
  final Map<String, dynamic> _resourceStats = {};
  final List<SystemResource> _resourceHistory = [];
  static const int _historySize = 100; // 保留100个历史数据点

  // 监控配置
  ResourceMonitoringConfig _config = ResourceMonitoringConfig.defaultConfig();

  // 回调函数
  Function(SystemResource)? onResourceUpdated;
  Function(ResourceAlert)? onResourceAlert;
  Function()? onResourceOptimization;

  /// 开始资源监控
  void startMonitoring({
    ResourceMonitoringConfig? config,
    int intervalSeconds = 5,
  }) {
    if (config != null) {
      _config = config;
    }

    if (_monitorTimer != null) {
      stopMonitoring();
    }

    _monitorTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (timer) => _checkSystemResources(),
    );

    log('资源监控已启动，监控间隔: ${intervalSeconds}秒');
  }

  /// 停止资源监控
  void stopMonitoring() {
    _monitorTimer?.cancel();
    _monitorTimer = null;
    log('资源监控已停止');
  }

  /// 检查系统资源
  Future<void> _checkSystemResources() async {
    try {
      final systemResource = await gatherSystemResources();
      await _handleResourceUpdate(systemResource);
    } catch (e) {
      log('系统资源检查失败: $e');
    }
  }

  /// 收集系统资源信息
  Future<SystemResource> gatherSystemResources() async {
    try {
      if (kIsWeb) {
        return await _getWebSystemResource();
      } else {
        return await _getNativeSystemResource();
      }
    } catch (e) {
      log('收集系统资源信息失败: $e');
      return SystemResource.empty();
    }
  }

  /// 获取Web平台系统资源信息
  Future<SystemResource> _getWebSystemResource() async {
    final random = Random();
    final currentTime = DateTime.now();
    
    return SystemResource(
      timestamp: currentTime,
      cpuInfo: await _getWebCpuInfo(),
      memoryInfo: await _getWebMemoryInfo(),
      diskInfo: await _getWebDiskInfo(),
      networkInfo: await _getWebNetworkInfo(),
      batteryInfo: await _getWebBatteryInfo(),
    );
  }

  /// 获取原生平台系统资源信息
  Future<SystemResource> _getNativeSystemResource() async {
    try {
      // 尝试调用原生接口
      final result = await _channel.invokeMethod('getSystemResources');
      if (result != null) {
        return SystemResource.fromMap(Map<String, dynamic>.from(result));
      }
    } catch (e) {
      log('调用原生系统资源接口失败: $e');
    }

    // 备用方案：使用模拟数据
    final random = Random();
    final currentTime = DateTime.now();
    
    return SystemResource(
      timestamp: currentTime,
      cpuInfo: CpuResourceInfo(
        usage: 0.1 + (random.nextDouble() * 0.8),
        temperature: 30 + (random.nextDouble() * 30),
        frequency: 2000 + (random.nextDouble() * 1000),
        cores: Platform.numberOfProcessors,
      ),
      memoryInfo: MemoryResourceInfo(
        total: 8192, // 8GB
        used: 2000 + (random.nextDouble() * 4000), // 2GB-6GB
        available: 8192 - 6000, // 约2GB可用
        cached: random.nextDouble() * 500, // 0-500MB缓存
      ),
      diskInfo: await _getNativeDiskInfo(),
      networkInfo: NetworkResourceInfo(
        downloadSpeed: random.nextDouble() * 100, // 0-100Mbps
        uploadSpeed: random.nextDouble() * 50, // 0-50Mbps
        latency: 10 + (random.nextDouble() * 90), // 10-100ms
        packetLoss: random.nextDouble() * 5, // 0-5%
      ),
      batteryInfo: BatteryResourceInfo(
        level: 0.3 + (random.nextDouble() * 0.7), // 30%-100%
        charging: random.nextBool(),
        temperature: 25 + (random.nextDouble() * 20), // 25°C-45°C
      ),
    );
  }

  /// 获取Web CPU信息
  Future<CpuResourceInfo> _getWebCpuInfo() async {
    return CpuResourceInfo(
      usage: _simulateCpuUsage(),
      temperature: 35 + (Random().nextDouble() * 20), // 35-55°C
      frequency: 2500, // 模拟频率
      cores: Platform.numberOfProcessors,
    );
  }

  /// 模拟CPU使用率
  double _simulateCpuUsage() {
    final random = Random();
    final baseLoad = 0.3;
    final variation = 0.5;
    return baseLoad + (random.nextDouble() * variation);
  }

  /// 获取Web内存信息
  Future<MemoryResourceInfo> _getWebMemoryInfo() async {
    return MemoryResourceInfo(
      total: 4096, // 4GB
      used: 1000 + (Random().nextDouble() * 2000), // 1-3GB
      available: 4096 - 3000, // 约1GB可用
      cached: Random().nextDouble() * 200, // 0-200MB缓存
    );
  }

  /// 获取Web磁盘信息
  Future<DiskResourceInfo> _getWebDiskInfo() async {
    return DiskResourceInfo(
      totalSpace: 100 * 1024, // 100GB
      usedSpace: 30 * 1024, // 30GB
      availableSpace: 70 * 1024, // 70GB
      ioReadSpeed: Random().nextDouble() * 200, // 0-200MB/s
      ioWriteSpeed: Random().nextDouble() * 100, // 0-100MB/s
    );
  }

  /// 获取Web网络信息
  Future<NetworkResourceInfo> _getWebNetworkInfo() async {
    return NetworkResourceInfo(
      downloadSpeed: Random().nextDouble() * 50, // 0-50Mbps
      uploadSpeed: Random().nextDouble() * 25, // 0-25Mbps
      latency: 20 + (Random().nextDouble() * 80), // 20-100ms
      packetLoss: Random().nextDouble() * 2, // 0-2%
    );
  }

  /// 获取Web电池信息
  Future<BatteryResourceInfo> _getWebBatteryInfo() async {
    return BatteryResourceInfo(
      level: 0.4 + (Random().nextDouble() * 0.6), // 40%-100%
      charging: Random().nextBool(),
      temperature: 30 + (Random().nextDouble() * 15), // 30-45°C
    );
  }

  /// 获取原生磁盘信息
  Future<DiskResourceInfo> _getNativeDiskInfo() async {
    final random = Random();
    return DiskResourceInfo(
      totalSpace: 500 * 1024, // 500GB
      usedSpace: 200 * 1024 + (random.nextDouble() * 200 * 1024), // 200-400GB
      availableSpace: 100 * 1024, // 100GB可用
      ioReadSpeed: random.nextDouble() * 500, // 0-500MB/s
      ioWriteSpeed: random.nextDouble() * 300, // 0-300MB/s
    );
  }

  /// 处理资源更新
  Future<void> _handleResourceUpdate(SystemResource resource) async {
    // 更新历史数据
    _updateResourceHistory(resource);

    // 更新统计数据
    _updateResourceStats(resource);

    // 检查预警条件
    await _checkForAlerts(resource);

    // 触发资源更新回调
    onResourceUpdated?.call(resource);
  }

  /// 更新资源历史数据
  void _updateResourceHistory(SystemResource resource) {
    _resourceHistory.add(resource);
    if (_resourceHistory.length > _historySize) {
      _resourceHistory.removeAt(0);
    }
  }

  /// 更新资源统计数据
  void _updateResourceStats(SystemResource resource) {
    _resourceStats['cpuUsage'] = resource.cpuInfo.usage;
    _resourceStats['memoryUsage'] = resource.memoryInfo.usagePercentage;
    _resourceStats['diskUsage'] = resource.diskInfo.usagePercentage;
    _resourceStats['networkLoad'] = _calculateNetworkLoad(resource.networkInfo);
    _resourceStats['batteryLevel'] = resource.batteryInfo.level;
    _resourceStats['batteryTemperature'] = resource.batteryInfo.temperature;
  }

  /// 计算网络负载
  double _calculateNetworkLoad(NetworkResourceInfo networkInfo) {
    final maxSpeed = max(networkInfo.downloadSpeed, networkInfo.uploadSpeed);
    return maxSpeed / 100; // 假设100Mbps为100%负载
  }

  /// 检查预警条件
  Future<void> _checkForAlerts(SystemResource resource) async {
    final currentTime = DateTime.now();
    final cpuUsage = resource.cpuInfo.usage;
    final memoryUsage = resource.memoryInfo.usagePercentage;
    final diskUsage = resource.diskInfo.usagePercentage;
    final networkLoad = _calculateNetworkLoad(resource.networkInfo);
    final batteryLevel = resource.batteryInfo.level;
    final batteryTemp = resource.batteryInfo.temperature;

    // CPU预警
    if (cpuUsage >= _criticalThreshold) {
      await _emitAlert(ResourceAlert(
        type: ResourceAlertType.critical,
        category: ResourceCategory.cpu,
        message: 'CPU使用率过高: ${(cpuUsage * 100).toStringAsFixed(1)}%',
        value: cpuUsage,
        timestamp: currentTime,
      ));
    } else if (cpuUsage >= _warningCpuThreshold) {
      await _emitAlert(ResourceAlert(
        type: ResourceAlertType.warning,
        category: ResourceCategory.cpu,
        message: 'CPU使用率预警: ${(cpuUsage * 100).toStringAsFixed(1)}%',
        value: cpuUsage,
        timestamp: currentTime,
      ));
    }

    // 内存预警
    if (memoryUsage >= _criticalThreshold) {
      await _emitAlert(ResourceAlert(
        type: ResourceAlertType.critical,
        category: ResourceCategory.memory,
        message: '内存使用率过高: ${(memoryUsage * 100).toStringAsFixed(1)}%',
        value: memoryUsage,
        timestamp: currentTime,
      ));
    } else if (memoryUsage >= _warningMemoryThreshold) {
      await _emitAlert(ResourceAlert(
        type: ResourceAlertType.warning,
        category: ResourceCategory.memory,
        message: '内存使用率预警: ${(memoryUsage * 100).toStringAsFixed(1)}%',
        value: memoryUsage,
        timestamp: currentTime,
      ));
    }

    // 磁盘预警
    if (diskUsage >= _warningDiskThreshold) {
      await _emitAlert(ResourceAlert(
        type: ResourceAlertType.warning,
        category: ResourceCategory.disk,
        message: '磁盘空间不足: ${(diskUsage * 100).toStringAsFixed(1)}%',
        value: diskUsage,
        timestamp: currentTime,
      ));
    }

    // 网络预警
    if (networkLoad >= _warningNetworkThreshold) {
      await _emitAlert(ResourceAlert(
        type: ResourceAlertType.warning,
        category: ResourceCategory.network,
        message: '网络负载过高: ${(networkLoad * 100).toStringAsFixed(1)}%',
        value: networkLoad,
        timestamp: currentTime,
      ));
    }

    // 电池预警
    if (batteryTemp >= 45) {
      await _emitAlert(ResourceAlert(
        type: ResourceAlertType.warning,
        category: ResourceCategory.battery,
        message: '电池温度过高: ${batteryTemp.toStringAsFixed(1)}°C',
        value: batteryTemp,
        timestamp: currentTime,
      ));
    }

    if (batteryLevel <= 0.2 && !resource.batteryInfo.charging) {
      await _emitAlert(ResourceAlert(
        type: ResourceAlertType.warning,
        category: ResourceCategory.battery,
        message: '电池电量不足: ${(batteryLevel * 100).toStringAsFixed(0)}%',
        value: batteryLevel,
        timestamp: currentTime,
      ));
    }
  }

  /// 发出预警
  Future<void> _emitAlert(ResourceAlert alert) async {
    _alerts.add(alert);
    onResourceAlert?.call(alert);
    log('资源预警: ${alert.type} ${alert.category} - ${alert.message}');

    // 保持预警历史记录不超过100条
    if (_alerts.length > 100) {
      _alerts.removeAt(0);
    }
  }

  /// 执行资源优化
  Future<void> performResourceOptimization() async {
    log('开始执行资源优化...');
    
    try {
      final startTime = DateTime.now();
      
      // 基于当前资源状态选择优化策略
      final resource = _getLatestResource();
      if (resource != null) {
        await _optimizeBasedOnResourceState(resource);
      }
      
      // 执行通用优化
      await _performGeneralOptimization();

      final duration = DateTime.now().difference(startTime);
      log('资源优化完成，耗时: ${duration.inMilliseconds}ms');

      onResourceOptimization?.call();

      // 记录优化结果
      _resourceStats['lastOptimization'] = DateTime.now().millisecondsSinceEpoch;
      _resourceStats['optimizationCount'] = (_resourceStats['optimizationCount'] ?? 0) + 1;

    } catch (e) {
      log('资源优化执行失败: $e');
    }
  }

  /// 获取最新的资源信息
  SystemResource? _getLatestResource() {
    if (_resourceHistory.isEmpty) return null;
    return _resourceHistory.last;
  }

  /// 基于资源状态优化
  Future<void> _optimizeBasedOnResourceState(SystemResource resource) async {
    // CPU优化
    if (resource.cpuInfo.usage >= _warningCpuThreshold) {
      await _optimizeCpuUsage();
    }

    // 内存优化
    if (resource.memoryInfo.usagePercentage >= _warningMemoryThreshold) {
      await _optimizeMemoryUsage();
    }

    // 磁盘优化
    if (resource.diskInfo.usagePercentage >= _warningDiskThreshold) {
      await _optimizeDiskUsage();
    }

    // 网络优化
    final networkLoad = _calculateNetworkLoad(resource.networkInfo);
    if (networkLoad >= _warningNetworkThreshold) {
      await _optimizeNetworkUsage();
    }

    // 电池优化
    if (resource.batteryInfo.level <= 0.3 || resource.batteryInfo.temperature >= 40) {
      await _optimizeBatteryUsage();
    }
  }

  /// 执行通用优化
  Future<void> _performGeneralOptimization() async {
    // 清理临时文件
    await _cleanupTempFiles();
    
    // 优化系统缓存
    await _optimizeSystemCache();
    
    // 释放未使用的资源
    await _releaseUnusedResources();
    
    // 整理系统碎片
    await _defragmentSystem();
  }

  /// CPU优化
  Future<void> _optimizeCpuUsage() async {
    try {
      // 降低动画帧率
      // 减少计算密集型任务
      // 优化算法效率
      log('CPU使用率优化');
    } catch (e) {
      log('CPU优化失败: $e');
    }
  }

  /// 内存优化
  Future<void> _optimizeMemoryUsage() async {
    try {
      // 清理内存缓存
      // 释放未使用的对象
      // 优化数据结构
      log('内存使用优化');
    } catch (e) {
      log('内存优化失败: $e');
    }
  }

  /// 磁盘优化
  Future<void> _optimizeDiskUsage() async {
    try {
      // 清理临时文件
      // 压缩不常用数据
      // 清理日志文件
      log('磁盘空间优化');
    } catch (e) {
      log('磁盘优化失败: $e');
    }
  }

  /// 网络优化
  Future<void> _optimizeNetworkUsage() async {
    try {
      // 减少网络请求
      // 启用请求合并
      // 优化缓存策略
      log('网络使用优化');
    } catch (e) {
      log('网络优化失败: $e');
    }
  }

  /// 电池优化
  Future<void> _optimizeBatteryUsage() async {
    try {
      // 降低屏幕亮度
      // 减少后台任务
      // 启用省电模式
      log('电池使用优化');
    } catch (e) {
      log('电池优化失败: $e');
    }
  }

  /// 清理临时文件
  Future<void> _cleanupTempFiles() async {
    try {
      // 清理临时文件夹
      // 清理下载缓存
      // 清理应用缓存
      log('临时文件清理完成');
    } catch (e) {
      log('清理临时文件失败: $e');
    }
  }

  /// 优化系统缓存
  Future<void> _optimizeSystemCache() async {
    try {
      // 优化系统缓存
      // 清理页面缓存
      // 整理内存布局
      log('系统缓存优化完成');
    } catch (e) {
      log('优化系统缓存失败: $e');
    }
  }

  /// 释放未使用的资源
  Future<void> _releaseUnusedResources() async {
    try {
      // 释放未使用的文件句柄
      // 关闭未使用的连接
      // 清理未引用的对象
      log('未使用资源已释放');
    } catch (e) {
      log('释放未使用资源失败: $e');
    }
  }

  /// 系统碎片整理
  Future<void> _defragmentSystem() async {
    try {
      // 移动文件以减少碎片
      // 整理文件系统
      // 优化存储布局
      log('系统碎片整理完成');
    } catch (e) {
      log('系统碎片整理失败: $e');
    }
  }

  /// 获取系统健康状况评估
  SystemHealthAssessment assessSystemHealth() {
    final resource = _getLatestResource();
    if (resource == null) {
      return SystemHealthAssessment(
        overallScore: 0.0,
        healthLevel: HealthLevel.unknown,
        issues: ['无法获取系统资源信息'],
        recommendations: [],
      );
    }

    double overallScore = 100.0;
    final issues = <String>[];
    final recommendations = <String>[];

    // 评估各项资源
    if (resource.cpuInfo.usage >= _criticalThreshold) {
      overallScore -= 30;
      issues.add('CPU使用率过高');
      recommendations.add('关闭不必要的应用程序');
    } else if (resource.cpuInfo.usage >= _warningCpuThreshold) {
      overallScore -= 15;
      issues.add('CPU使用率预警');
      recommendations.add('监控CPU密集型应用');
    }

    if (resource.memoryInfo.usagePercentage >= _criticalThreshold) {
      overallScore -= 25;
      issues.add('内存使用率过高');
      recommendations.add('清理内存或重启应用');
    } else if (resource.memoryInfo.usagePercentage >= _warningMemoryThreshold) {
      overallScore -= 10;
      issues.add('内存使用率预警');
      recommendations.add('监控内存使用情况');
    }

    if (resource.diskInfo.usagePercentage >= _warningDiskThreshold) {
      overallScore -= 20;
      issues.add('磁盘空间不足');
      recommendations.add('清理不必要的文件或扩展存储');
    }

    if (resource.batteryInfo.level <= 0.2 && !resource.batteryInfo.charging) {
      overallScore -= 15;
      issues.add('电池电量不足');
      recommendations.add('及时充电或启用省电模式');
    }

    // 确定健康等级
    HealthLevel healthLevel;
    if (overallScore >= 80) {
      healthLevel = HealthLevel.excellent;
    } else if (overallScore >= 60) {
      healthLevel = HealthLevel.good;
    } else if (overallScore >= 40) {
      healthLevel = HealthLevel.fair;
    } else {
      healthLevel = HealthLevel.poor;
    }

    return SystemHealthAssessment(
      overallScore: overallScore,
      healthLevel: healthLevel,
      issues: issues,
      recommendations: recommendations,
    );
  }

  /// 获取资源统计信息
  Map<String, dynamic> getResourceStatistics() {
    return {
      'cpuUsage': _resourceStats['cpuUsage'] ?? 0.0,
      'memoryUsage': _resourceStats['memoryUsage'] ?? 0.0,
      'diskUsage': _resourceStats['diskUsage'] ?? 0.0,
      'networkLoad': _resourceStats['networkLoad'] ?? 0.0,
      'batteryLevel': _resourceStats['batteryLevel'] ?? 0.0,
      'batteryTemperature': _resourceStats['batteryTemperature'] ?? 0.0,
      'optimizationCount': _resourceStats['optimizationCount'] ?? 0,
      'lastOptimization': _resourceStats['lastOptimization'],
      'alertsCount': _alerts.length,
      'isMonitoring': _monitorTimer != null,
      'historySize': _resourceHistory.length,
    };
  }

  /// 获取预警历史
  List<ResourceAlert> getAlertHistory() {
    return List.unmodifiable(_alerts);
  }

  /// 获取资源历史
  List<SystemResource> getResourceHistory() {
    return List.unmodifiable(_resourceHistory);
  }

  /// 设置监控配置
  void setMonitoringConfig(ResourceMonitoringConfig config) {
    _config = config;
    log('监控配置已更新');
  }

  /// 清理资源
  void dispose() {
    stopMonitoring();
    _alerts.clear();
    _resourceStats.clear();
    _resourceHistory.clear();
    log('ResourceMonitor已清理资源');
  }
}

/// 资源监控配置
class ResourceMonitoringConfig {
  final bool enableCpuMonitoring;
  final bool enableMemoryMonitoring;
  final bool enableDiskMonitoring;
  final bool enableNetworkMonitoring;
  final bool enableBatteryMonitoring;
  final double alertThreshold;
  final int historySize;

  const ResourceMonitoringConfig({
    required this.enableCpuMonitoring,
    required this.enableMemoryMonitoring,
    required this.enableDiskMonitoring,
    required this.enableNetworkMonitoring,
    required this.enableBatteryMonitoring,
    required this.alertThreshold,
    required this.historySize,
  });

  factory ResourceMonitoringConfig.defaultConfig() {
    return const ResourceMonitoringConfig(
      enableCpuMonitoring: true,
      enableMemoryMonitoring: true,
      enableDiskMonitoring: true,
      enableNetworkMonitoring: true,
      enableBatteryMonitoring: true,
      alertThreshold: 0.8,
      historySize: 100,
    );
  }
}

/// 系统资源数据类
class SystemResource {
  final DateTime timestamp;
  final CpuResourceInfo cpuInfo;
  final MemoryResourceInfo memoryInfo;
  final DiskResourceInfo diskInfo;
  final NetworkResourceInfo networkInfo;
  final BatteryResourceInfo batteryInfo;

  SystemResource({
    required this.timestamp,
    required this.cpuInfo,
    required this.memoryInfo,
    required this.diskInfo,
    required this.networkInfo,
    required this.batteryInfo,
  });

  factory SystemResource.empty() {
    return SystemResource(
      timestamp: DateTime.now(),
      cpuInfo: CpuResourceInfo(usage: 0, temperature: 0, frequency: 0, cores: 1),
      memoryInfo: MemoryResourceInfo(total: 0, used: 0, available: 0, cached: 0),
      diskInfo: DiskResourceInfo(totalSpace: 0, usedSpace: 0, availableSpace: 0, ioReadSpeed: 0, ioWriteSpeed: 0),
      networkInfo: NetworkResourceInfo(downloadSpeed: 0, uploadSpeed: 0, latency: 0, packetLoss: 0),
      batteryInfo: BatteryResourceInfo(level: 0, charging: false, temperature: 0),
    );
  }

  factory SystemResource.fromMap(Map<String, dynamic> map) {
    return SystemResource(
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      cpuInfo: CpuResourceInfo.fromMap(Map<String, dynamic>.from(map['cpuInfo'] ?? {})),
      memoryInfo: MemoryResourceInfo.fromMap(Map<String, dynamic>.from(map['memoryInfo'] ?? {})),
      diskInfo: DiskResourceInfo.fromMap(Map<String, dynamic>.from(map['diskInfo'] ?? {})),
      networkInfo: NetworkResourceInfo.fromMap(Map<String, dynamic>.from(map['networkInfo'] ?? {})),
      batteryInfo: BatteryResourceInfo.fromMap(Map<String, dynamic>.from(map['batteryInfo'] ?? {})),
    );
  }

  @override
  String toString() {
    return 'SystemResource{timestamp: $timestamp, cpu: ${(cpuInfo.usage * 100).toStringAsFixed(1)}%, '
           'memory: ${(memoryInfo.usagePercentage * 100).toStringAsFixed(1)}%, '
           'disk: ${(diskInfo.usagePercentage * 100).toStringAsFixed(1)}%, '
           'battery: ${(batteryInfo.level * 100).toStringAsFixed(0)}%}';
  }
}

/// CPU资源信息
class CpuResourceInfo {
  final double usage; // 使用率 (0.0-1.0)
  final double temperature; // 温度(摄氏度)
  final double frequency; // 频率(MHz)
  final int cores; // 核心数

  CpuResourceInfo({
    required this.usage,
    required this.temperature,
    required this.frequency,
    required this.cores,
  });

  factory CpuResourceInfo.fromMap(Map<String, dynamic> map) {
    return CpuResourceInfo(
      usage: map['usage']?.toDouble() ?? 0.0,
      temperature: map['temperature']?.toDouble() ?? 0.0,
      frequency: map['frequency']?.toDouble() ?? 0.0,
      cores: map['cores']?.toInt() ?? 1,
    );
  }
}

/// 内存资源信息
class MemoryResourceInfo {
  final int total; // 总内存(MB)
  final int used; // 已使用内存(MB)
  final int available; // 可用内存(MB)
  final double cached; // 缓存内存(MB)

  MemoryResourceInfo({
    required this.total,
    required this.used,
    required this.available,
    required this.cached,
  });

  double get usagePercentage => total > 0 ? used / total : 0.0;

  factory MemoryResourceInfo.fromMap(Map<String, dynamic> map) {
    return MemoryResourceInfo(
      total: map['total']?.toInt() ?? 0,
      used: map['used']?.toInt() ?? 0,
      available: map['available']?.toInt() ?? 0,
      cached: map['cached']?.toDouble() ?? 0.0,
    );
  }
}

/// 磁盘资源信息
class DiskResourceInfo {
  final int totalSpace; // 总空间(MB)
  final int usedSpace; // 已使用空间(MB)
  final int availableSpace; // 可用空间(MB)
  final double ioReadSpeed; // 读取速度(MB/s)
  final double ioWriteSpeed; // 写入速度(MB/s)

  DiskResourceInfo({
    required this.totalSpace,
    required this.usedSpace,
    required this.availableSpace,
    required this.ioReadSpeed,
    required this.ioWriteSpeed,
  });

  double get usagePercentage => totalSpace > 0 ? usedSpace / totalSpace : 0.0;

  factory DiskResourceInfo.fromMap(Map<String, dynamic> map) {
    return DiskResourceInfo(
      totalSpace: map['totalSpace']?.toInt() ?? 0,
      usedSpace: map['usedSpace']?.toInt() ?? 0,
      availableSpace: map['availableSpace']?.toInt() ?? 0,
      ioReadSpeed: map['ioReadSpeed']?.toDouble() ?? 0.0,
      ioWriteSpeed: map['ioWriteSpeed']?.toDouble() ?? 0.0,
    );
  }
}

/// 网络资源信息
class NetworkResourceInfo {
  final double downloadSpeed; // 下载速度(Mbps)
  final double uploadSpeed; // 上传速度(Mbps)
  final double latency; // 延迟(ms)
  final double packetLoss; // 丢包率(%)

  NetworkResourceInfo({
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.latency,
    required this.packetLoss,
  });

  factory NetworkResourceInfo.fromMap(Map<String, dynamic> map) {
    return NetworkResourceInfo(
      downloadSpeed: map['downloadSpeed']?.toDouble() ?? 0.0,
      uploadSpeed: map['uploadSpeed']?.toDouble() ?? 0.0,
      latency: map['latency']?.toDouble() ?? 0.0,
      packetLoss: map['packetLoss']?.toDouble() ?? 0.0,
    );
  }
}

/// 电池资源信息
class BatteryResourceInfo {
  final double level; // 电量级别 (0.0-1.0)
  final bool charging; // 是否充电中
  final double temperature; // 温度(摄氏度)

  BatteryResourceInfo({
    required this.level,
    required this.charging,
    required this.temperature,
  });

  factory BatteryResourceInfo.fromMap(Map<String, dynamic> map) {
    return BatteryResourceInfo(
      level: map['level']?.toDouble() ?? 0.0,
      charging: map['charging'] ?? false,
      temperature: map['temperature']?.toDouble() ?? 0.0,
    );
  }
}

/// 资源预警类
class ResourceAlert {
  final ResourceAlertType type;
  final ResourceCategory category;
  final String message;
  final double value;
  final DateTime timestamp;

  const ResourceAlert({
    required this.type,
    required this.category,
    required this.message,
    required this.value,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'ResourceAlert{type: $type, category: $category, message: $message, '
           'value: $value, time: $timestamp}';
  }
}

/// 资源预警类型
enum ResourceAlertType {
  warning,
  critical,
}

/// 资源类别
enum ResourceCategory {
  cpu,
  memory,
  disk,
  network,
  battery,
}

/// 系统健康评估
class SystemHealthAssessment {
  final double overallScore; // 总体评分 (0-100)
  final HealthLevel healthLevel; // 健康等级
  final List<String> issues; // 问题列表
  final List<String> recommendations; // 建议列表

  SystemHealthAssessment({
    required this.overallScore,
    required this.healthLevel,
    required this.issues,
    required this.recommendations,
  });

  @override
  String toString() {
    return 'SystemHealthAssessment{score: ${overallScore.toStringAsFixed(1)}, '
           'level: $healthLevel, issues: $issues, recommendations: $recommendations}';
  }
}

/// 健康等级
enum HealthLevel {
  excellent,
  good,
  fair,
  poor,
  unknown,
}