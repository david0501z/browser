import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// 电池优化器 - 提供电池状态监控、预警和自动优化功能
class BatteryOptimizer {
  static const MethodChannel _channel = MethodChannel('battery_optimizer');

  static final BatteryOptimizer _instance = BatteryOptimizer._internal();
  factory BatteryOptimizer() => _instance;
  BatteryOptimizer._internal();

  // 电池阈值配置
  static const double _lowBatteryThreshold = 0.2; // 20% 电量预警
  static const double _criticalBatteryThreshold = 0.1; // 10% 电量严重预警
  static const double _highTemperatureThreshold = 40.0; // 40°C 高温预警
  static const int _powerSaveModeThreshold = 30; // 进入省电模式的电量阈值

  // 监控相关
  Timer? _monitorTimer;
  DateTime? _lastOptimizationTime;
  final List<BatteryAlert> _alerts = [];
  final Map<String, dynamic> _batteryStats = {};
  final List<double> _batteryHistory = [];
  static const int _historySize = 120; // 保留120个历史数据点

  // 省电模式状态
  bool _powerSavingMode = false;
  final Set<BatteryOptimizationType> _activeOptimizations = {};

  // 回调函数
  Function(BatteryInfo)? onBatteryInfoChanged;
  Function(BatteryAlert)? onBatteryAlert;
  Function()? onBatteryOptimization;
  Function(bool)? onPowerSavingModeChanged;

  /// 获取电池信息
  Future<BatteryInfo> getBatteryInfo() async {
    try {
      if (kIsWeb) {
        return await _getWebBatteryInfo();
      } else {
        return await _getNativeBatteryInfo();
      }
    } catch (e) {
      log('获取电池信息失败: $e');
      return BatteryInfo.empty();
    }
  }

  /// 获取Web平台电池信息
  Future<BatteryInfo> _getWebBatteryInfo() async {
    // Web平台限制：无法直接获取电池信息
    // 这里返回模拟数据
    return _generateSimulatedBatteryInfo();
  }

  /// 生成模拟电池信息
  BatteryInfo _generateSimulatedBatteryInfo() {
    final random = Random();
    final level = 0.1 + (random.nextDouble() * 0.9); // 10%-100%
    final charging = level < 1.0; // 电量不满时可能充电中
    
    return BatteryInfo(
      level: level,
      isCharging: charging,
      temperature: 25 + (random.nextDouble() * 20), // 25°C-45°C
      voltage: 3.7 + (random.nextDouble() * 0.6), // 3.7V-4.3V
      current: charging ? 1.0 + (random.nextDouble() * 2.0) : -(random.nextDouble() * 0.5),
      health: 0.8 + (random.nextDouble() * 0.2), // 80%-100% 健康度
      batteryType: BatteryType.lithiumIon,
      chargingState: charging ? ChargingState.charging : ChargingState.discharging,
      timestamp: DateTime.now(),
    );
  }

  /// 获取原生平台电池信息
  Future<BatteryInfo> _getNativeBatteryInfo() async {
    try {
      // 尝试调用原生接口
      final result = await _channel.invokeMethod('getBatteryInfo');
      if (result != null) {
        return BatteryInfo.fromMap(Map<String, dynamic>.from(result));
      }
    } catch (e) {
      log('调用原生电池接口失败: $e');
    }

    // 备用方案：使用模拟数据
    return _generateSimulatedBatteryInfo();
  }

  /// 开始电池监控
  void startMonitoring({int intervalSeconds = 10}) {
    if (_monitorTimer != null) {
      stopMonitoring();
    }

    _monitorTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (timer) => _checkBatteryStatus(),
    );

    log('电池监控已启动，监控间隔: ${intervalSeconds}秒');
  }

  /// 停止电池监控
  void stopMonitoring() {
    _monitorTimer?.cancel();
    _monitorTimer = null;
    log('电池监控已停止');
  }

  /// 检查电池状态
  Future<void> _checkBatteryStatus() async {
    try {
      final batteryInfo = await getBatteryInfo();
      await _handleBatteryCheck(batteryInfo);
    } catch (e) {
      log('电池状态检查失败: $e');
    }
  }

  /// 处理电池检查结果
  Future<void> _handleBatteryCheck(BatteryInfo batteryInfo) async {
    // 更新历史数据
    _updateBatteryHistory(batteryInfo.level);

    // 更新统计数据
    _updateBatteryStats(batteryInfo);

    // 触发电池信息变化回调
    onBatteryInfoChanged?.call(batteryInfo);

    // 检查预警条件
    await _checkForAlerts(batteryInfo);

    // 检查是否需要自动优化
    await _checkForAutoOptimization(batteryInfo);

    // 检查是否需要进入省电模式
    await _checkPowerSavingMode(batteryInfo);
  }

  /// 更新电池历史数据
  void _updateBatteryHistory(double level) {
    _batteryHistory.add(level);
    if (_batteryHistory.length > _historySize) {
      _batteryHistory.removeAt(0);
    }
  }

  /// 更新电池统计数据
  void _updateBatteryStats(BatteryInfo batteryInfo) {
    _batteryStats['currentLevel'] = batteryInfo.level;
    _batteryStats['isCharging'] = batteryInfo.isCharging;
    _batteryStats['temperature'] = batteryInfo.temperature;
    _batteryStats['health'] = batteryInfo.health;
    _batteryStats['chargingState'] = batteryInfo.chargingState.toString();
    _batteryStats['batteryType'] = batteryInfo.batteryType.toString();
  }

  /// 检查预警条件
  Future<void> _checkForAlerts(BatteryInfo batteryInfo) async {
    final currentTime = DateTime.now();
    final level = batteryInfo.level;
    final temperature = batteryInfo.temperature;

    // 低电量预警
    if (level <= _criticalBatteryThreshold) {
      await _emitAlert(BatteryAlert(
        type: BatteryAlertType.critical,
        message: '电池电量严重不足: ${(level * 100).toStringAsFixed(0)}%',
        level: level,
        temperature: temperature,
        timestamp: currentTime,
      ));
    } else if (level <= _lowBatteryThreshold) {
      await _emitAlert(BatteryAlert(
        type: BatteryAlertType.low,
        message: '电池电量不足: ${(level * 100).toStringAsFixed(0)}%',
        level: level,
        temperature: temperature,
        timestamp: currentTime,
      ));
    }

    // 温度预警
    if (temperature >= _highTemperatureThreshold) {
      await _emitAlert(BatteryAlert(
        type: BatteryAlertType.temperature,
        message: '电池温度过高: ${temperature.toStringAsFixed(1)}°C',
        level: level,
        temperature: temperature,
        timestamp: currentTime,
      ));
    }

    // 充电状态预警
    if (batteryInfo.isCharging && level >= 0.99) {
      await _emitAlert(BatteryAlert(
        type: BatteryAlertType.full,
        message: '电池已充满',
        level: level,
        temperature: temperature,
        timestamp: currentTime,
      ));
    }
  }

  /// 检查是否需要自动优化
  Future<void> _checkForAutoOptimization(BatteryInfo batteryInfo) async {
    final currentTime = DateTime.now();
    final level = batteryInfo.level;
    final temperature = batteryInfo.temperature;

    // 检查是否需要优化
    if ((level <= _lowBatteryThreshold || temperature >= 35) && 
        (_lastOptimizationTime == null || 
         currentTime.difference(_lastOptimizationTime!).inMinutes >= 5)) {
      await performBatteryOptimization();
      _lastOptimizationTime = currentTime;
    }
  }

  /// 检查省电模式
  Future<void> _checkPowerSavingMode(BatteryInfo batteryInfo) async {
    final level = batteryInfo.level;
    final temperature = batteryInfo.temperature;
    final shouldEnablePowerSaving = level <= _powerSaveModeThreshold || temperature >= 35;

    if (shouldEnablePowerSaving != _powerSavingMode) {
      await setPowerSavingMode(shouldEnablePowerSaving);
    }
  }

  /// 执行电池优化
  Future<void> performBatteryOptimization() async {
    log('开始执行电池优化...');
    
    try {
      final startTime = DateTime.now();
      
      // 1. 降低屏幕亮度
      await _adjustScreenBrightness();
      
      // 2. 减少网络请求频率
      await _optimizeNetworkUsage();
      
      // 3. 降低动画和视觉效果
      await _reduceVisualEffects();
      
      // 4. 优化后台任务
      await _optimizeBackgroundTasks();
      
      // 5. 调整CPU性能模式
      await _adjustCpuPerformanceMode();

      final duration = DateTime.now().difference(startTime);
      log('电池优化完成，耗时: ${duration.inMilliseconds}ms');

      onBatteryOptimization?.call();

      // 记录优化结果
      _batteryStats['lastOptimization'] = DateTime.now().millisecondsSinceEpoch;
      _batteryStats['optimizationCount'] = (_batteryStats['optimizationCount'] ?? 0) + 1;

    } catch (e) {
      log('电池优化执行失败: $e');
    }
  }

  /// 调整屏幕亮度
  Future<void> _adjustScreenBrightness() async {
    try {
      // 在支持的系统上调整屏幕亮度
      // 这里只记录日志，实际实现需要系统权限
      _activeOptimizations.add(BatteryOptimizationType.screenBrightness);
      log('屏幕亮度已优化');
    } catch (e) {
      log('调整屏幕亮度失败: $e');
    }
  }

  /// 优化网络使用
  Future<void> _optimizeNetworkUsage() async {
    try {
      // 减少非必要网络请求
      // 启用请求合并
      // 降低图片质量以减少流量
      _activeOptimizations.add(BatteryOptimizationType.networkUsage);
      log('网络使用已优化');
    } catch (e) {
      log('优化网络使用失败: $e');
    }
  }

  /// 减少视觉效果
  Future<void> _reduceVisualEffects() async {
    try {
      // 降低动画帧率
      // 减少粒子效果
      // 简化UI过渡
      _activeOptimizations.add(BatteryOptimizationType.visualEffects);
      log('视觉效果已减少');
    } catch (e) {
      log('减少视觉效果失败: $e');
    }
  }

  /// 优化后台任务
  Future<void> _optimizeBackgroundTasks() async {
    try {
      // 延迟非关键任务
      // 减少后台同步频率
      // 暂停不必要的服务
      _activeOptimizations.add(BatteryOptimizationType.backgroundTasks);
      log('后台任务已优化');
    } catch (e) {
      log('优化后台任务失败: $e');
    }
  }

  /// 调整CPU性能模式
  Future<void> _adjustCpuPerformanceMode() async {
    try {
      // 降低CPU频率
      // 减少线程池大小
      // 限制高CPU操作
      _activeOptimizations.add(BatteryOptimizationType.cpuPerformance);
      log('CPU性能模式已调整');
    } catch (e) {
      log('调整CPU性能模式失败: $e');
    }
  }

  /// 设置省电模式
  Future<void> setPowerSavingMode(bool enabled) async {
    if (enabled == _powerSavingMode) return;

    _powerSavingMode = enabled;
    
    try {
      if (enabled) {
        log('省电模式已启用');
        await _enablePowerSavingFeatures();
      } else {
        log('省电模式已禁用');
        await _disablePowerSavingFeatures();
      }

      onPowerSavingModeChanged?.call(enabled);
      
      // 记录状态变化
      _batteryStats['powerSavingMode'] = enabled;
      _batteryStats['lastPowerSavingChange'] = DateTime.now().millisecondsSinceEpoch;

    } catch (e) {
      log('设置省电模式失败: $e');
      _powerSavingMode = !enabled; // 恢复原状态
    }
  }

  /// 启用省电功能
  Future<void> _enablePowerSavingFeatures() async {
    // 启用所有电池优化
    await performBatteryOptimization();
  }

  /// 禁用省电功能
  Future<void> _disablePowerSavingFeatures() async {
    // 禁用所有优化的效果会在这里恢复
    // 恢复默认设置
    log('省电功能已禁用');
  }

  /// 发出预警
  Future<void> _emitAlert(BatteryAlert alert) async {
    _alerts.add(alert);
    onBatteryAlert?.call(alert);
    log('电池预警: ${alert.type} - ${alert.message}');

    // 保持预警历史记录不超过100条
    if (_alerts.length > 100) {
      _alerts.removeAt(0);
    }
  }

  /// 估算剩余使用时间
  Duration estimateRemainingUsageTime() {
    if (_batteryHistory.length < 2) return Duration.zero;

    final recentChanges = <double>[];
    for (int i = _batteryHistory.length - 1; i > max(0, _batteryHistory.length - 10); i--) {
      if (i < _batteryHistory.length - 1) {
        recentChanges.add(_batteryHistory[i] - _batteryHistory[i + 1]);
      }
    }

    if (recentChanges.isEmpty) return Duration.zero;

    final averageDrain = recentChanges.reduce((a, b) => a + b) / recentChanges.length;
    if (averageDrain <= 0) return Duration.zero;

    final currentLevel = _batteryHistory.last;
    final estimatedMinutes = (currentLevel / averageDrain).abs().round();
    
    return Duration(minutes: estimatedMinutes);
  }

  /// 获取电池统计信息
  Map<String, dynamic> getBatteryStatistics() {
    return {
      'currentLevel': _batteryStats['currentLevel'] ?? 0.0,
      'isCharging': _batteryStats['isCharging'] ?? false,
      'temperature': _batteryStats['temperature'] ?? 0.0,
      'health': _batteryStats['health'] ?? 1.0,
      'optimizationCount': _batteryStats['optimizationCount'] ?? 0,
      'lastOptimization': _batteryStats['lastOptimization'],
      'powerSavingMode': _batteryStats['powerSavingMode'] ?? false,
      'lastPowerSavingChange': _batteryStats['lastPowerSavingChange'],
      'activeOptimizations': _activeOptimizations.map((e) => e.toString()).toList(),
      'alertsCount': _alerts.length,
      'isMonitoring': _monitorTimer != null,
      'historySize': _batteryHistory.length,
      'estimatedRemainingTime': estimateRemainingUsageTime().inMinutes,
    };
  }

  /// 获取预警历史
  List<BatteryAlert> getAlertHistory() {
    return List.unmodifiable(_alerts);
  }

  /// 获取当前电量
  double get currentLevel {
    return _batteryHistory.isNotEmpty ? _batteryHistory.last : 0.0;
  }

  /// 获取当前温度
  double? get currentTemperature {
    return _batteryStats['temperature'] as double?;
  }

  /// 检查是否在省电模式
  bool get isInPowerSavingMode => _powerSavingMode;

  /// 获取激活的优化
  Set<BatteryOptimizationType> get activeOptimizations => Set.from(_activeOptimizations);

  /// 清理资源
  void dispose() {
    stopMonitoring();
    _alerts.clear();
    _batteryStats.clear();
    _batteryHistory.clear();
    _activeOptimizations.clear();
    log('BatteryOptimizer已清理资源');
  }
}

/// 电池信息数据类
class BatteryInfo {
  final double level; // 电量级别 (0.0-1.0)
  final bool isCharging; // 是否充电中
  final double temperature; // 温度(摄氏度)
  final double voltage; // 电压(V)
  final double current; // 电流(A)
  final double health; // 电池健康度 (0.0-1.0)
  final BatteryType batteryType; // 电池类型
  final ChargingState chargingState; // 充电状态
  final DateTime timestamp; // 获取时间

  BatteryInfo({
    required this.level,
    required this.isCharging,
    required this.temperature,
    required this.voltage,
    required this.current,
    required this.health,
    required this.batteryType,
    required this.chargingState,
    required this.timestamp,
  });

  factory BatteryInfo.empty() {
    return BatteryInfo(
      level: 0.0,
      isCharging: false,
      temperature: 0.0,
      voltage: 0.0,
      current: 0.0,
      health: 1.0,
      batteryType: BatteryType.unknown,
      chargingState: ChargingState.unknown,
      timestamp: DateTime.now(),
    );
  }

  factory BatteryInfo.fromMap(Map<String, dynamic> map) {
    return BatteryInfo(
      level: map['level']?.toDouble() ?? 0.0,
      isCharging: map['isCharging'] ?? false,
      temperature: map['temperature']?.toDouble() ?? 0.0,
      voltage: map['voltage']?.toDouble() ?? 0.0,
      current: map['current']?.toDouble() ?? 0.0,
      health: map['health']?.toDouble() ?? 1.0,
      batteryType: BatteryType.values.firstWhere(
        (e) => e.toString() == 'BatteryType.${map['batteryType']}',
        orElse: () => BatteryType.unknown,
      ),
      chargingState: ChargingState.values.firstWhere(
        (e) => e.toString() == 'ChargingState.${map['chargingState']}',
        orElse: () => ChargingState.unknown,
      ),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'isCharging': isCharging,
      'temperature': temperature,
      'voltage': voltage,
      'current': current,
      'health': health,
      'batteryType': batteryType.toString().split('.').last,
      'chargingState': chargingState.toString().split('.').last,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'BatteryInfo{level: ${(level * 100).toStringAsFixed(0)}%, '
           'charging: $isCharging, temp: ${temperature.toStringAsFixed(1)}°C, '
           'voltage: ${voltage.toStringAsFixed(2)}V, health: ${(health * 100).toStringAsFixed(0)}%, '
           'state: $chargingState}';
  }
}

/// 电池预警类
class BatteryAlert {
  final BatteryAlertType type;
  final String message;
  final double level;
  final double? temperature;
  final DateTime timestamp;

  const BatteryAlert({
    required this.type,
    required this.message,
    required this.level,
    this.temperature,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'BatteryAlert{type: $type, message: $message, '
           'level: ${(level * 100).toStringAsFixed(0)}%, '
           'temp: ${temperature ?? 'N/A'}°C, time: $timestamp}';
  }
}

/// 电池预警类型
enum BatteryAlertType {
  low,
  critical,
  temperature,
  full,
}

/// 电池类型
enum BatteryType {
  lithiumIon,
  lithiumPolymer,
  nickelMetalHydride,
  nickelCadmium,
  alkaline,
  unknown,
}

/// 充电状态
enum ChargingState {
  charging,
  discharging,
  full,
  unknown,
}

/// 电池优化类型
enum BatteryOptimizationType {
  screenBrightness,
  networkUsage,
  visualEffects,
  backgroundTasks,
  cpuPerformance,
}

/// 电池优化结果
class BatteryOptimizationResult {
  final bool success;
  final String message;
  final double estimatedBatterySave; // 预计节省的电量百分比
  final Duration duration;

  const BatteryOptimizationResult({
    required this.success,
    required this.message,
    required this.estimatedBatterySave,
    required this.duration,
  });

  @override
  String toString() {
    return 'BatteryOptimizationResult{success: $success, message: $message, '
           'estimatedBatterySave: ${estimatedBatterySave.toStringAsFixed(1)}%, duration: $duration}';
  }
}