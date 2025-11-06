import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'error_recovery_manager.dart';
import 'exception_handler.dart';

/// 崩溃恢复状态
enum CrashRecoveryState {
  /// 空闲状态
  idle,
  /// 正在保存状态
  savingState,
  /// 正在恢复状态
  recovering,
  /// 恢复成功
  recovered,
  /// 恢复失败
  failed,
  /// 需要完整重启
  requiresRestart,
}

/// 应用状态快照
class AppStateSnapshot {
  final String id;
  final DateTime timestamp;
  final String appVersion;
  final Map<String, dynamic> appData;
  final Map<String, dynamic> userPreferences;
  final List<String> crashLog;
  final Map<String, dynamic> systemInfo;
  final String stateHash;
  
  const AppStateSnapshot({
    required this.id,
    required this.timestamp,
    required this.appVersion,
    required this.appData,
    required this.userPreferences,
    required this.crashLog,
    required this.systemInfo,
    required this.stateHash,
  });
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'appVersion': appVersion,
      'appData': appData,
      'userPreferences': userPreferences,
      'crashLog': crashLog,
      'systemInfo': systemInfo,
      'stateHash': stateHash,
    };
  }
  
  /// 从JSON创建快照
  factory AppStateSnapshot.fromJson(Map<String, dynamic> json) {
    return AppStateSnapshot(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      appVersion: json['appVersion'] as String,
      appData: Map<String, dynamic>.from(json['appData'] as Map),
      userPreferences: Map<String, dynamic>.from(json['userPreferences'] as Map),
      crashLog: List<String>.from(json['crashLog'] as List),
      systemInfo: Map<String, dynamic>.from(json['systemInfo'] as Map),
      stateHash: json['stateHash'] as String,
    );
  }
  
  /// 计算状态哈希
  static String computeHash(Map<String, dynamic> data) {
    final jsonString = json.encode(data);
    return jsonString.hashCode.toString();
  }
}

/// 恢复策略配置
class RecoveryStrategyConfig {
  final bool enableAutoSave;
  final Duration saveInterval;
  final int maxSnapshots;
  final bool enableStateRecovery;
  final bool enableDataRecovery;
  final bool enablePreferenceRecovery;
  final List<String> ignoredStateKeys;
  final Duration stateRetentionPeriod;
  
  const RecoveryStrategyConfig({
    this.enableAutoSave = true,
    this.saveInterval = const Duration(minutes: 5),
    this.maxSnapshots = 10,
    this.enableStateRecovery = true,
    this.enableDataRecovery = true,
    this.enablePreferenceRecovery = true,
    this.ignoredStateKeys = const [],
    this.stateRetentionPeriod = const Duration(hours: 24),
  });
}

/// 崩溃检测结果
class CrashDetectionResult {
  final bool isCrash;
  final String crashReason;
  final CrashSeverity severity;
  final Map<String, dynamic> crashContext;
  final String? previousSessionId;
  
  const CrashDetectionResult({
    required this.isCrash,
    required this.crashReason,
    required this.severity,
    required this.crashContext,
    this.previousSessionId,
  });
}

/// 崩溃严重程度
enum CrashSeverity {
  /// 轻微崩溃 - 不影响核心功能
  minor,
  /// 中等崩溃 - 影响部分功能
  moderate,
  /// 严重崩溃 - 影响主要功能
  severe,
  /// 致命崩溃 - 应用完全无法使用
  fatal,
}

/// 恢复选项
class RecoveryOptions {
  final bool restoreAppState;
  final bool restoreUserData;
  final bool restorePreferences;
  final bool showRecoveryDialog;
  final bool continueFromLastSession;
  final String? customMessage;
  
  const RecoveryOptions({
    this.restoreAppState = true,
    this.restoreUserData = true,
    this.restorePreferences = true,
    this.showRecoveryDialog = true,
    this.continueFromLastSession = true,
    this.customMessage,
  });
}

/// 恢复结果
class CrashRecoveryResult {
  final bool success;
  final String message;
  final RecoveryState state;
  final AppStateSnapshot? restoredSnapshot;
  final List<String> restoredComponents;
  final Duration recoveryTime;
  
  const CrashRecoveryResult({
    required this.success,
    required this.message,
    required this.state,
    this.restoredSnapshot,
    this.restoredComponents = const [],
    required this.recoveryTime,
  });
}

/// 崩溃恢复系统
class CrashRecoverySystem {
  static final CrashRecoverySystem _instance = CrashRecoverySystem._internal();
  factory CrashRecoverySystem() => _instance;
  CrashRecoverySystem._internal();
  
  final Logger _logger = Logger('CrashRecoverySystem');
  
  /// 恢复策略配置
  RecoveryStrategyConfig _config = const RecoveryStrategyConfig();
  
  /// 当前崩溃恢复状态
  CrashRecoveryState _currentState = CrashRecoveryState.idle;
  
  /// 状态变更监听器
  final List<StateChangeListener> _stateListeners = [];
  
  /// 自动保存定时器
  Timer? _autoSaveTimer;
  
  /// 崩溃会话ID
  String? _currentSessionId;
  
  /// 应用状态存储键
  static const String stateStorageKey = 'app_state_snapshot';
  static const String sessionIdKey = 'current_session_id';
  static const String lastCrashTimeKey = 'last_crash_time';
  
  /// 初始化崩溃恢复系统
  Future<void> initialize([RecoveryStrategyConfig? config]) async {
    if (config != null) {
      _config = config;
    }
    
    _logger.info('初始化崩溃恢复系统');
    
    // 生成当前会话ID
    _currentSessionId = _generateSessionId();
    
    // 保存会话ID
    await _saveSessionId();
    
    // 设置定时自动保存
    if (_config.enableAutoSave) {
      _setupAutoSaveTimer();
    }
    
    // 注册全局异常处理器
    _setupGlobalHandlers();
    
    _logger.info('崩溃恢复系统初始化完成，会话ID: $_currentSessionId');
  }
  
  /// 生成会话ID
  String _generateSessionId() {
    return 'SESSION_${DateTime.now().millisecondsSinceEpoch}_${Isolate.current.hashCode}';
  }
  
  /// 保存会话ID
  Future<void> _saveSessionId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(sessionIdKey, _currentSessionId!);
    } catch (e) {
      _logger.error('保存会话ID失败: $e');
    }
  }
  
  /// 设置自动保存定时器
  void _setupAutoSaveTimer() {
    _autoSaveTimer = Timer.periodic(_config.saveInterval, (timer) {
      _performAutoSave();
    });
  }
  
  /// 执行自动保存
  Future<void> _performAutoSave() async {
    if (_currentState == CrashRecoveryState.savingState) {
      _logger.debug('正在保存状态，跳过本次自动保存');
      return;
    }
    
    _logger.debug('执行自动状态保存');
    await saveCurrentState();
  }
  
  /// 设置全局处理器
  void _setupGlobalHandlers() {
    // Flutter框架异常
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };
    
    // 平台级错误
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      return _handlePlatformError(error, stackTrace);
    };
    
    // 应用程序生命周期
    AppLifecycleState.values.forEach((state) {
      // 这里可以添加生命周期相关的处理
    });
  }
  
  /// 处理Flutter错误
  void _handleFlutterError(FlutterErrorDetails details) {
    _logger.error('Flutter框架异常检测', error: details.exception, stackTrace: details.stack);
    
    // 记录崩溃日志
    _addCrashLog('Flutter Error: ${details.exception.toString()}');
    
    // 触发状态保存
    _triggerStateSave('flutter_error');
  }
  
  /// 处理平台错误
  bool _handlePlatformError(Object error, StackTrace stackTrace) {
    _logger.error('平台级异常检测', error: error, stackTrace: stackTrace);
    
    // 记录崩溃日志
    _addCrashLog('Platform Error: ${error.toString()}');
    
    // 触发状态保存
    _triggerStateSave('platform_error');
    
    // 返回true阻止应用崩溃
    return true;
  }
  
  /// 触发状态保存
  void _triggerStateSave(String reason) {
    Future.microtask(() async {
      await saveCurrentState(reason);
    });
  }
  
  /// 添加崩溃日志
  void _addCrashLog(String log) {
    // 实际实现中，这里会将日志添加到快照中
    _logger.warning('崩溃日志: $log');
  }
  
  /// 保存当前应用状态
  Future<AppStateSnapshot> saveCurrentState([String? reason]) async {
    if (_currentState == CrashRecoveryState.savingState) {
      _logger.warning('正在保存状态，跳过重复保存');
      throw StateError('正在保存状态');
    }
    
    _updateState(CrashRecoveryState.savingState);
    
    try {
      _logger.info('保存应用状态: ${reason ?? '手动保存'}');
      
      final snapshot = await _createStateSnapshot(reason);
      
      // 保存快照
      await _saveSnapshot(snapshot);
      
      // 清理过期快照
      await _cleanupOldSnapshots();
      
      _logger.info('应用状态保存成功: ${snapshot.id}');
      _updateState(CrashRecoveryState.idle);
      
      return snapshot;
    } catch (e) {
      _logger.error('保存应用状态失败: $e');
      _updateState(CrashRecoveryState.failed);
      rethrow;
    }
  }
  
  /// 创建状态快照
  Future<AppStateSnapshot> _createStateSnapshot(String? reason) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 收集应用数据
    final appData = <String, dynamic>{};
    final userPreferences = <String, dynamic>{};
    final systemInfo = <String, dynamic>{};
    final crashLog = <String>[];
    
    // 从SharedPreferences获取数据
    for (final key in prefs.getKeys()) {
      final value = prefs.get(key);
      if (value != null) {
        if (_isUserPreference(key)) {
          userPreferences[key] = _serializePreferenceValue(value);
        } else {
          appData[key] = _serializePreferenceValue(value);
        }
      }
    }
    
    // 过滤忽略的状态键
    for (final ignoredKey in _config.ignoredStateKeys) {
      appData.remove(ignoredKey);
      userPreferences.remove(ignoredKey);
    }
    
    // 系统信息
    systemInfo.addAll({
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'locale': Platform.localeName,
      'isLowMemoryDevice': PlatformDispatcher.instance.lowMemory,
      'devicePixelRatio': PlatformDispatcher.instance.devicePixelRatio,
    });
    
    // 计算状态哈希
    final stateData = {
      'appData': appData,
      'userPreferences': userPreferences,
      'systemInfo': systemInfo,
    };
    final stateHash = AppStateSnapshot.computeHash(stateData);
    
    // 创建快照
    final snapshot = AppStateSnapshot(
      id: _generateSnapshotId(),
      timestamp: DateTime.now(),
      appVersion: _getAppVersion(),
      appData: appData,
      userPreferences: userPreferences,
      crashLog: crashLog,
      systemInfo: systemInfo,
      stateHash: stateHash,
    );
    
    return snapshot;
  }
  
  /// 保存快照
  Future<void> _saveSnapshot(AppStateSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(snapshot.toJson());
    await prefs.setString(stateStorageKey, jsonString);
  }
  
  /// 生成快照ID
  String _generateSnapshotId() {
    return 'SNAPSHOT_${DateTime.now().millisecondsSinceEpoch}';
  }
  
  /// 检查是否为用户偏好设置
  bool _isUserPreference(String key) {
    // 这里可以根据具体需求定义哪些是用户偏好设置
    return key.startsWith('user_') || 
           key.startsWith('pref_') || 
           key.startsWith('settings_');
  }
  
  /// 序列化偏好设置值
  dynamic _serializePreferenceValue(dynamic value) {
    if (value is List) {
return List<String>.from(value.map((e) => e.toString());
    } else if (value is Map) {
      return Map<String, String>.fromEntries(
(value as Map).entries.map((e) => MapEntry(e.key.toString(), e.value.toString()),
      );
    }
    return value;
  }
  
  /// 获取应用版本
  String _getAppVersion() {
    // 实际实现中，这里应该从包信息中获取版本号
    return '1.0.0+1';
  }
  
  /// 清理过期快照
  Future<void> _cleanupOldSnapshots() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 获取所有快照ID
      final snapshotIds = prefs.getStringList('snapshot_ids') ?? [];
      
      // 过滤过期快照
      final currentTime = DateTime.now();
      final validSnapshotIds = <String>[];
      
      for (final id in snapshotIds) {
        final snapshotKey = 'snapshot_$id';
        final snapshotJson = prefs.getString(snapshotKey);
        
        if (snapshotJson != null) {
          final snapshot = AppStateSnapshot.fromJson(json.decode(snapshotJson));
          final age = currentTime.difference(snapshot.timestamp);
          
          if (age <= _config.stateRetentionPeriod) {
            validSnapshotIds.add(id);
          } else {
            // 删除过期快照
            await prefs.remove(snapshotKey);
          }
        }
      }
      
      // 保存有效快照ID列表
      await prefs.setStringList('snapshot_ids', validSnapshotIds);
      
      // 限制快照数量
      if (validSnapshotIds.length > _config.maxSnapshots) {
        final snapshotsToRemove = validSnapshotIds.sublist(0, validSnapshotIds.length - _config.maxSnapshots);
        for (final id in snapshotsToRemove) {
          await prefs.remove('snapshot_$id');
        }
        final remainingIds = validSnapshotIds.sublist(snapshotsToRemove.length);
        await prefs.setStringList('snapshot_ids', remainingIds);
      }
      
    } catch (e) {
      _logger.error('清理过期快照失败: $e');
    }
  }
  
  /// 检测崩溃
  Future<CrashDetectionResult> detectCrash() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 检查上次崩溃时间
      final lastCrashTime = prefs.getString(lastCrashTimeKey);
      final lastSessionId = prefs.getString(sessionIdKey);
      
      if (lastCrashTime != null && lastSessionId != null) {
        final lastCrash = DateTime.parse(lastCrashTime);
        final timeSinceCrash = DateTime.now().difference(lastCrash);
        
        // 如果崩溃时间在5分钟内，认为是异常终止
        if (timeSinceCrash < const Duration(minutes: 5)) {
          return CrashDetectionResult(
            isCrash: true,
            crashReason: '检测到之前的异常终止',
            severity: CrashSeverity.moderate,
            crashContext: {
              'lastCrashTime': lastCrash.toIso8601String(),
              'timeSinceCrash': timeSinceCrash.inSeconds,
            },
            previousSessionId: lastSessionId,
          );
        }
      }
      
      // 更新最后崩溃时间（当前为正常启动）
      await prefs.setString(lastCrashTimeKey, DateTime.now().toIso8601String());
      
      return CrashDetectionResult(
        isCrash: false,
        crashReason: '正常启动',
        severity: CrashSeverity.minor,
        crashContext: {},
      );
      
    } catch (e) {
      _logger.error('崩溃检测失败: $e');
      return CrashDetectionResult(
        isCrash: true,
        crashReason: '检测过程异常: $e',
        severity: CrashSeverity.severe,
        crashContext: {'error': e.toString()},
      );
    }
  }
  
  /// 执行崩溃恢复
  Future<CrashRecoveryResult> performRecovery([
    RecoveryOptions? options,
  ]) async {
    final stopwatch = Stopwatch()..start();
    final recoveryOptions = options ?? const RecoveryOptions();
    
    try {
      _logger.info('开始崩溃恢复过程');
      _updateState(CrashRecoveryState.recovering);
      
      // 检测崩溃状态
      final crashDetection = await detectCrash();
      
      if (!crashDetection.isCrash) {
        stopwatch.stop();
        return const CrashRecoveryResult(
          success: true,
          message: '未检测到崩溃，无需恢复',
          state: CrashRecoveryState.recovered,
          recoveryTime: Duration.zero,
        );
      }
      
      // 获取最近的快照
      final snapshot = await _getLatestSnapshot();
      if (snapshot == null) {
        stopwatch.stop();
        return CrashRecoveryResult(
          success: false,
          message: '没有找到可恢复的状态快照',
          state: CrashRecoveryState.failed,
          recoveryTime: stopwatch.elapsed,
        );
      }
      
      // 显示恢复选项对话框
      if (recoveryOptions.showRecoveryDialog) {
        final shouldRestore = await _showRecoveryDialog(snapshot, crashDetection);
        if (!shouldRestore) {
          stopwatch.stop();
          return CrashRecoveryResult(
            success: false,
            message: '用户取消恢复',
            state: CrashRecoveryState.failed,
            recoveryTime: stopwatch.elapsed,
          );
        }
      }
      
      final restoredComponents = <String>[];
      
      // 恢复应用状态
      if (recoveryOptions.restoreAppState) {
        await _restoreAppState(snapshot);
        restoredComponents.add('应用状态');
      }
      
      // 恢复用户数据
      if (recoveryOptions.restoreUserData) {
        await _restoreUserData(snapshot);
        restoredComponents.add('用户数据');
      }
      
      // 恢复用户偏好设置
      if (recoveryOptions.restorePreferences) {
        await _restorePreferences(snapshot);
        restoredComponents.add('用户偏好');
      }
      
      stopwatch.stop();
      _updateState(CrashRecoveryState.recovered);
      
      _logger.info('崩溃恢复成功，耗时: ${stopwatch.elapsed}');
      
      return CrashRecoveryResult(
        success: true,
        message: '恢复成功',
        state: CrashRecoveryState.recovered,
        restoredSnapshot: snapshot,
        restoredComponents: restoredComponents,
        recoveryTime: stopwatch.elapsed,
      );
      
    } catch (e) {
      _logger.error('崩溃恢复失败: $e');
      stopwatch.stop();
      _updateState(CrashRecoveryState.failed);
      
      return CrashRecoveryResult(
        success: false,
        message: '恢复失败: $e',
        state: CrashRecoveryState.failed,
        recoveryTime: stopwatch.elapsed,
      );
    }
  }
  
  /// 获取最新的快照
  Future<AppStateSnapshot?> _getLatestSnapshot() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final snapshotJson = prefs.getString(stateStorageKey);
      
      if (snapshotJson != null) {
        return AppStateSnapshot.fromJson(json.decode(snapshotJson));
      }
      
      return null;
    } catch (e) {
      _logger.error('获取最新快照失败: $e');
      return null;
    }
  }
  
  /// 显示恢复对话框
  Future<bool> _showRecoveryDialog(AppStateSnapshot snapshot, CrashDetectionResult crashDetection) async {
    // 这里应该实现UI对话框逻辑
    // 暂时返回true表示总是恢复
    _logger.info('显示恢复对话框');
    
    // 实际实现中，这里会显示一个对话框询问用户是否要恢复
    // 用户可以选择恢复或重新开始
    return true;
  }
  
  /// 恢复应用状态
  Future<void> _restoreAppState(AppStateSnapshot snapshot) async {
    _logger.info('恢复应用状态');
    
    final prefs = await SharedPreferences.getInstance();
    
    // 恢复应用数据
    for (final entry in snapshot.appData.entries) {
      await prefs.setString(entry.key, json.encode(entry.value));
    }
  }
  
  /// 恢复用户数据
  Future<void> _restoreUserData(AppStateSnapshot snapshot) async {
    _logger.info('恢复用户数据');
    
    // 这里应该实现用户数据的恢复逻辑
    // 可能包括数据库数据、文件数据等
    
    await Future.delayed(Duration(milliseconds: 100)); // 模拟恢复过程
  }
  
  /// 恢复用户偏好设置
  Future<void> _restorePreferences(AppStateSnapshot snapshot) async {
    _logger.info('恢复用户偏好设置');
    
    final prefs = await SharedPreferences.getInstance();
    
    // 恢复用户偏好设置
    for (final entry in snapshot.userPreferences.entries) {
      await prefs.setString(entry.key, entry.value.toString());
    }
  }
  
  /// 清除所有状态数据
  Future<void> clearAllStateData() async {
    _logger.info('清除所有状态数据');
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _logger.info('状态数据清除完成');
    } catch (e) {
      _logger.error('清除状态数据失败: $e');
    }
  }
  
  /// 清除崩溃历史
  Future<void> clearCrashHistory() async {
    _logger.info('清除崩溃历史');
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(lastCrashTimeKey);
      await prefs.remove(sessionIdKey);
      _logger.info('崩溃历史清除完成');
    } catch (e) {
      _logger.error('清除崩溃历史失败: $e');
    }
  }
  
  /// 获取崩溃统计
  Future<Map<String, dynamic>> getCrashStatistics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      return {
        'totalCrashes': prefs.getInt('total_crashes') ?? 0,
        'lastCrashTime': prefs.getString(lastCrashTimeKey),
        'sessionId': prefs.getString(sessionIdKey),
        'hasActiveSnapshot': prefs.containsKey(stateStorageKey),
        'snapshotCount': (prefs.getStringList('snapshot_ids') ?? []).length,
      };
    } catch (e) {
      _logger.error('获取崩溃统计失败: $e');
      return {};
    }
  }
  
  /// 更新状态
  void _updateState(CrashRecoveryState newState) {
    final oldState = _currentState;
    _currentState = newState;
    
    _logger.info('崩溃恢复状态变更: $oldState -> $newState');
    
    // 通知监听器
    for (final listener in _stateListeners) {
      try {
        listener(oldState, newState);
      } catch (e) {
        _logger.error('通知状态监听器失败: $e');
      }
    }
  }
  
  /// 添加状态变更监听器
  void addStateChangeListener(StateChangeListener listener) {
    _stateListeners.add(listener);
  }
  
  /// 移除状态变更监听器
  void removeStateChangeListener(StateChangeListener listener) {
    _stateListeners.remove(listener);
  }
  
  /// 获取当前状态
  CrashRecoveryState get currentState => _currentState;
  
  /// 获取当前会话ID
  String? get currentSessionId => _currentSessionId;
  
  /// 更新配置
  void updateConfig(RecoveryStrategyConfig newConfig) {
    _config = newConfig;
    
    // 重新设置自动保存定时器
    if (_autoSaveTimer != null) {
      _autoSaveTimer?.cancel();
    }
    
    if (_config.enableAutoSave) {
      _setupAutoSaveTimer();
    }
    
    _logger.info('更新崩溃恢复配置');
  }
  
  /// 获取配置
  RecoveryStrategyConfig get config => _config;
  
  /// 关闭系统
  Future<void> dispose() async {
    _logger.info('关闭崩溃恢复系统');
    
    // 取消定时器
    _autoSaveTimer?.cancel();
    
    // 清理监听器
    _stateListeners.clear();
    
    // 保存当前状态
    await saveCurrentState('系统关闭');
  }
}

/// 状态变更监听器
typedef StateChangeListener = void Function(CrashRecoveryState oldState, CrashRecoveryState newState);