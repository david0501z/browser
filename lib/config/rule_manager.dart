import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

/// 规则类型枚举
enum RuleType {
  domain,      // 域名规则
  ip,          // IP地址规则
  ipcidr,      // IP CIDR规则
  url,         // URL规则
  useragent,   // 用户代理规则
  cidr,        // CIDR规则（别名）
  port,        // 端口规则
  protocol,    // 协议规则
  wildcard,    // 通配符规则
  regex,       // 正则表达式规则
  geoip,       // 地理位置IP规则
  adblock,     // 广告屏蔽规则
  custom,      // 自定义规则
}

/// 规则动作枚举
enum RuleAction {
  proxy,       // 走代理
  direct,      // 直连
  reject,      // 拒绝
  block,       // 阻止
}

/// 规则优先级枚举
enum RulePriority {
  high,        // 高优先级
  normal,      // 普通优先级
  low,         // 低优先级
  critical,    // 关键优先级
  lowest,      // 最低优先级
}

/// 规则配置模型
@immutable
class RuleConfig {
  final String id;
  final String name;
  final RuleType type;
  final String pattern;
  final RuleAction action;
  final RulePriority priority;
  final bool enabled;
  final String? description;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RuleConfig({
    required this.id,
    required this.name,
    required this.type,
    required this.pattern,
    required this.action,
    this.priority = RulePriority.normal,
    this.enabled = true,
    this.description,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从JSON创建规则配置
  factory RuleConfig.fromJson(Map<String, dynamic> json) {
    return RuleConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      type: RuleType.values.byName(json['type'] as String),
      pattern: json['pattern'] as String,
      action: RuleAction.values.byName(json['action'] as String),
      priority: RulePriority.values.byName(json['priority'] as String? ?? 'normal'),
      enabled: json['enabled'] as bool? ?? true,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'pattern': pattern,
      'action': action.name,
      'priority': priority.name,
      'enabled': enabled,
      'description': description,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// 复制规则配置
  RuleConfig copyWith({
    String? id,
    String? name,
    RuleType? type,
    String? pattern,
    RuleAction? action,
    RulePriority? priority,
    bool? enabled,
    String? description,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RuleConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      pattern: pattern ?? this.pattern,
      action: action ?? this.action,
      priority: priority ?? this.priority,
      enabled: enabled ?? this.enabled,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'RuleConfig(id: $id, name: $name, type: $type, action: $action)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RuleConfig && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// 规则组配置
@immutable
class RuleGroup {
  final String id;
  final String name;
  final List<RuleConfig> rules;
  final bool enabled;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RuleGroup({
    required this.id,
    required this.name,
    required this.rules,
    this.enabled = true,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RuleGroup.fromJson(Map<String, dynamic> json) {
    return RuleGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      rules: (json['rules'] as List)
          .map((rule) => RuleConfig.fromJson(rule as Map<String, dynamic>));
          .toList(),
      enabled: json['enabled'] as bool? ?? true,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rules': rules.map((rule) => rule.toJson()).toList(),
      'enabled': enabled,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  RuleGroup copyWith({
    String? id,
    String? name,
    List<RuleConfig>? rules,
    bool? enabled,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RuleGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      rules: rules ?? this.rules,
      enabled: enabled ?? this.enabled,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// 规则管理器
class RuleManager extends ChangeNotifier {
  static RuleManager? _instance;
  static RuleManager get instance => _instance ??= RuleManager._();

  RuleManager._();

  final List<RuleGroup> _groups = [];
  final Map<String, RuleConfig> _ruleIndex = {};

  /// 文件操作相关
  static const String _rulesFileName = 'rules_config.json';
  static const String _rulesDirName = 'rules';

  /// 获取所有规则组
  List<RuleGroup> get groups => List.unmodifiable(_groups);

  /// 获取启用的规则组
  List<RuleGroup> get enabledGroups => _groups.where((group) => group.enabled).toList();

  /// 获取所有启用的规则
  List<RuleConfig> get enabledRules {
    return enabledGroups.expand((group) => group.rules).where((rule) => rule.enabled).toList();
  }

  /// 获取规则总数
  int get totalRules => enabledRules.length;

  /// 规则组操作

  /// 添加规则组
  Future<void> addGroup(RuleGroup group) async {
    if (_groups.any((g) => g.id == group.id)) {
      throw ArgumentError('规则组ID已存在: ${group.id}');
    }

    _groups.add(group);
    _indexGroupRules(group);
    
    await _saveToFile();
    notifyListeners();
  }

  /// 更新规则组
  Future<void> updateGroup(RuleGroup group) async {
    final index = _groups.indexWhere((g) => g.id == group.id);
    if (index == -1) {
      throw ArgumentError('规则组不存在: ${group.id}');
    }

    _groups[index] = group.copyWith(updatedAt: DateTime.now());
    _indexGroupRules(group);
    
    await _saveToFile();
    notifyListeners();
  }

  /// 删除规则组
  Future<void> removeGroup(String groupId) async {
    final group = _groups.firstWhere((g) => g.id == groupId);
    _groups.remove(group);
    _unindexGroupRules(group);
    
    await _saveToFile();
    notifyListeners();
  }

  /// 启用/禁用规则组
  Future<void> toggleGroup(String groupId) async {
    final index = _groups.indexWhere((g) => g.id == groupId);
    if (index == -1) {
      throw ArgumentError('规则组不存在: $groupId');
    }

    _groups[index] = _groups[index].copyWith(
      enabled: !_groups[index].enabled,
      updatedAt: DateTime.now(),
    );
    
    await _saveToFile();
    notifyListeners();
  }

  /// 移动规则组位置
  Future<void> moveGroup(String groupId, int newIndex) async {
    if (newIndex < 0 || newIndex >= _groups.length) {
      throw ArgumentError('无效的位置: $newIndex');
    }

    final group = _groups.firstWhere((g) => g.id == groupId);
    _groups.remove(group);
    _groups.insert(newIndex, group);
    
    await _saveToFile();
    notifyListeners();
  }

  /// 规则操作

  /// 添加规则
  Future<void> addRule(String groupId, RuleConfig rule) async {
    final group = _groups.firstWhere((g) => g.id == groupId);

    if (_ruleIndex.containsKey(rule.id)) {
      throw ArgumentError('规则ID已存在: ${rule.id}');
    }

    final updatedRule = rule.copyWith(
      createdAt: rule.createdAt,
      updatedAt: DateTime.now(),
    );

    final updatedGroup = group.copyWith(
      rules: [...group.rules, updatedRule],
      updatedAt: DateTime.now(),
    );

    await updateGroup(updatedGroup);
  }

  /// 更新规则
  Future<void> updateRule(String groupId, String ruleId, RuleConfig rule) async {
    final group = _groups.firstWhere((g) => g.id == groupId);
    final ruleIndex = group.rules.indexWhere((r) => r.id == ruleId);
    
    if (ruleIndex == -1) {
      throw ArgumentError('规则不存在: $ruleId');
    }

    final updatedRule = rule.copyWith(updatedAt: DateTime.now());
    final updatedRules = List<RuleConfig>.from(group.rules);
      ..[ruleIndex] = updatedRule;

    final updatedGroup = group.copyWith(
      rules: updatedRules,
      updatedAt: DateTime.now(),
    );

    await updateGroup(updatedGroup);
  }

  /// 删除规则
  Future<void> removeRule(String groupId, String ruleId) async {
    final group = _groups.firstWhere((g) => g.id == groupId);
    final updatedRules = group.rules.where((r) => r.id != ruleId).toList();

    final updatedGroup = group.copyWith(
      rules: updatedRules,
      updatedAt: DateTime.now(),
    );

    await updateGroup(updatedGroup);
    
    _ruleIndex.remove(ruleId);
  }

  /// 启用/禁用规则
  Future<void> toggleRule(String groupId, String ruleId) async {
    final group = _groups.firstWhere((g) => g.id == groupId);
    final ruleIndex = group.rules.indexWhere((r) => r.id == ruleId);
    
    if (ruleIndex == -1) {
      throw ArgumentError('规则不存在: $ruleId');
    }

    final rule = group.rules[ruleIndex];
    final updatedRule = rule.copyWith(
      enabled: !rule.enabled,
      updatedAt: DateTime.now(),
    );

    final updatedRules = List<RuleConfig>.from(group.rules);
      ..[ruleIndex] = updatedRule;

    final updatedGroup = group.copyWith(
      rules: updatedRules,
      updatedAt: DateTime.now(),
    );

    await updateGroup(updatedGroup);
  }

  /// 移动规则
  Future<void> moveRule(String groupId, String ruleId, int newIndex) async {
    final group = _groups.firstWhere((g) => g.id == groupId);
    final rule = group.rules.firstWhere((r) => r.id == ruleId);
    final updatedRules = List<RuleConfig>.from(group.rules);
      ..remove(rule);

    if (newIndex < 0 || newIndex >= updatedRules.length) {
      throw ArgumentError('无效的位置: $newIndex');
    }

    updatedRules.insert(newIndex, rule);

    final updatedGroup = group.copyWith(
      rules: updatedRules,
      updatedAt: DateTime.now(),
    );

    await updateGroup(updatedGroup);
  }

  /// 批量操作

  /// 批量导入规则
  Future<void> importRules(String groupId, List<RuleConfig> rules) async {
    final group = _groups.firstWhere((g) => g.id == groupId);

    // 检查ID冲突
    for (final rule in rules) {
      if (_ruleIndex.containsKey(rule.id)) {
        throw ArgumentError('规则ID冲突: ${rule.id}');
      }
    }

    final updatedRules = [...group.rules, ...rules];
    final updatedGroup = group.copyWith(
      rules: updatedRules,
      updatedAt: DateTime.now(),
    );

    await updateGroup(updatedGroup);
  }

  /// 批量启用/禁用规则
  Future<void> bulkToggleRules(String groupId, List<String> ruleIds, bool enabled) async {
    final group = _groups.firstWhere((g) => g.id == groupId);
    final updatedRules = group.rules.map((rule) {
      if (ruleIds.contains(rule.id)) {
        return rule.copyWith(enabled: enabled, updatedAt: DateTime.now());
      }
      return rule;
    }).toList();

    final updatedGroup = group.copyWith(
      rules: updatedRules,
      updatedAt: DateTime.now(),
    );

    await updateGroup(updatedGroup);
  }

  /// 导出规则
  Future<String> exportRules(String groupId, {bool enabledOnly = true}) async {
    final group = _groups.firstWhere((g) => g.id == groupId);
    final rulesToExport = enabledOnly ? group.rules.where((r) => r.enabled).toList() : group.rules;
    
    final exportData = {
      'group': group.toJson(),
      'rules': rulesToExport.map((rule) => rule.toJson()).toList(),
      'exportedAt': DateTime.now().toIso8601String(),
      'version': '1.0',
    };

    return json.encode(exportData);
  }

  /// 搜索和过滤

  /// 搜索规则
  List<RuleConfig> searchRules(String query) {
    query = query.toLowerCase();
    return enabledRules.where((rule) {
      return rule.name.toLowerCase().contains(query) ||
             rule.pattern.toLowerCase().contains(query) ||
             (rule.description?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  /// 按类型过滤规则
  List<RuleConfig> filterRulesByType(RuleType type) {
    return enabledRules.where((rule) => rule.type == type).toList();
  }

  /// 按动作过滤规则
  List<RuleConfig> filterRulesByAction(RuleAction action) {
    return enabledRules.where((rule) => rule.action == action).toList();
  }

  /// 排序规则
  List<RuleConfig> sortRules(List<RuleConfig> rules, {bool descending = false}) {
    final sorted = List<RuleConfig>.from(rules);
    sorted.sort((a, b) {
      // 首先按优先级排序
      final priorityOrder = {RulePriority.high: 3, RulePriority.normal: 2, RulePriority.low: 1};
      final priorityCompare = priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
      if (priorityCompare != 0) return descending ? -priorityCompare : priorityCompare;
      
      // 优先级相同时按创建时间排序
      return descending 
          ? b.createdAt.compareTo(a.createdAt)
          : a.createdAt.compareTo(b.createdAt);
    });
    return sorted;
  }

  /// 索引管理
  void _indexGroupRules(RuleGroup group) {
    for (final rule in group.rules) {
      _ruleIndex[rule.id] = rule;
    }
  }

  void _unindexGroupRules(RuleGroup group) {
    for (final rule in group.rules) {
      _ruleIndex.remove(rule.id);
    }
  }

  /// 文件操作
  Future<File> _getRulesFile() async {
    final directory = await _getRulesDirectory();
    return File(path.join(directory.path, _rulesFileName));
  }

  Future<Directory> _getRulesDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final rulesDir = Directory(path.join(appDocDir.path, _rulesDirName));
    
    if (!await rulesDir.exists()) {
      await rulesDir.create(recursive: true);
    }
    
    return rulesDir;
  }

  /// 保存到文件
  Future<void> _saveToFile() async {
    try {
      final file = await _getRulesFile();
      final data = {
        'groups': _groups.map((group) => group.toJson()).toList(),
        'lastModified': DateTime.now().toIso8601String(),
        'version': '1.0',
      };
      
      await file.writeAsString(json.encode(data), flush: true);
    } catch (e) {
      debugPrint('保存规则配置失败: $e');
      rethrow;
    }
  }

  /// 从文件加载
  Future<void> loadFromFile() async {
    try {
      final file = await _getRulesFile();
      if (!await file.exists()) {
        // 创建默认规则组
        await _createDefaultRules();
        return;
      }

      final content = await file.readAsString();
      final data = json.decode(content) as Map<String, dynamic>;
      
      _groups.clear();
      _ruleIndex.clear();
      
      for (final groupJson in data['groups'] as List) {
        final group = RuleGroup.fromJson(groupJson as Map<String, dynamic>);
        _groups.add(group);
        _indexGroupRules(group);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('加载规则配置失败: $e');
      await _createDefaultRules();
    }
  }

  /// 创建默认规则
  Future<void> _createDefaultRules() async {
    final now = DateTime.now();
    
    // 创建默认规则组
    final defaultGroup = RuleGroup(
      id: 'default',
      name: '默认规则',
      rules: [],
      enabled: true,
      description: '系统默认规则组',
      createdAt: now,
      updatedAt: now,
    );

    await addGroup(defaultGroup);
  }

  /// 获取规则统计信息
  RuleStats getStats() {
    int total = 0;
    int enabled = 0;
    final typeStats = <RuleType, int>{};
    final actionStats = <RuleAction, int>{};
    final priorityStats = <RulePriority, int>{};

    for (final group in _groups) {
      for (final rule in group.rules) {
        total++;
        if (rule.enabled) enabled++;
        
        typeStats[rule.type] = (typeStats[rule.type] ?? 0) + 1;
        actionStats[rule.action] = (actionStats[rule.action] ?? 0) + 1;
        priorityStats[rule.priority] = (priorityStats[rule.priority] ?? 0) + 1;
      }
    }

    return RuleStats(
      totalRules: total,
      enabledRules: enabled,
      disabledRules: total - enabled,
      groupCount: _groups.length,
      enabledGroupCount: _groups.where((g) => g.enabled).length,
      typeStats: Map.from(typeStats),
      actionStats: Map.from(actionStats),
      priorityStats: Map.from(priorityStats),
    );
  }

  /// 清理资源
  @override
  void dispose() {
    _groups.clear();
    _ruleIndex.clear();
    super.dispose();
  }
}

/// 规则统计信息
class RuleStats {
  final int totalRules;
  final int enabledRules;
  final int disabledRules;
  final int groupCount;
  final int enabledGroupCount;
  final Map<RuleType, int> typeStats;
  final Map<RuleAction, int> actionStats;
  final Map<RulePriority, int> priorityStats;

  const RuleStats({
    required this.totalRules,
    required this.enabledRules,
    required this.disabledRules,
    required this.groupCount,
    required this.enabledGroupCount,
    required this.typeStats,
    required this.actionStats,
    required this.priorityStats,
  });
}