/// 规则配置类
import 'models/models.dart';
class RuleConfiguration {
  /// 是否启用规则
  final bool enable;
  
  /// 规则模式 (rule/global/direct)
  final String mode;
  
  /// 规则列表
  final List<RuleItem> rules;
  
  /// 规则提供者
  final List<RuleProvider> providers;
  
  /// 规则策略
  final RuleStrategy strategy;
  
  /// 自定义配置
  final Map<String, dynamic> customRules;

  const RuleConfiguration({
    this.enable = true,
    this.mode = 'rule',
    this.rules = const [],
    this.providers = const [],
    this.strategy = RuleStrategy.firstMatch,
    this.customRules = const {},
  });

  /// 从JSON创建
  factory RuleConfiguration.fromJson(Map<String, dynamic> json) {
    return RuleConfiguration(
      enable: json['enable'] ?? true,
      mode: json['mode'] ?? 'rule',
      rules: json['rules'] != null 
          ? (json['rules'] as List).map((rule) => RuleItem.fromJson(rule)).toList() 
          : [],
      providers: json['providers'] != null 
          ? (json['providers'] as List).map((provider) => RuleProvider.fromJson(provider)).toList() 
          : [],
      strategy: RuleStrategy.values.firstWhere(
        (e) => e.name == json['strategy'],
        orElse: () => RuleStrategy.firstMatch,
      ),
      customRules: json['customRules'] ?? {},
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'enable': enable,
      'mode': mode,
      'rules': rules.map((rule) => rule.toJson()).toList(),
      'providers': providers.map((provider) => provider.toJson()).toList(),
      'strategy': strategy.name,
      'customRules': customRules,
    };
  }

  /// 复制并修改
  RuleConfiguration copyWith({
    bool? enable,
    String? mode,
    List<RuleItem>? rules,
    List<RuleProvider>? providers,
    RuleStrategy? strategy,
    Map<String, dynamic>? customRules,
  }) {
    return RuleConfiguration(
      enable: enable ?? this.enable,
      mode: mode ?? this.mode,
      rules: rules ?? this.rules,
      providers: providers ?? this.providers,
      strategy: strategy ?? this.strategy,
      customRules: customRules ?? this.customRules,
    );
  }

  @override
  String toString() {
    return 'RuleConfiguration{enable: $enable, mode: $mode, rules: ${rules.length}, providers: ${providers.length}}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RuleConfiguration &&
        other.enable == enable &&
        other.mode == mode &&
        other.rules == rules &&
        other.providers == providers &&
        other.strategy == strategy &&
        other.customRules == customRules;
  }

  @override
  int get hashCode {
    return enable.hashCode ^
        mode.hashCode ^
        rules.hashCode ^
        providers.hashCode ^
        strategy.hashCode ^
        customRules.hashCode;
  }
}

/// 规则策略枚举
enum RuleStrategy {
  /// 优先匹配
  firstMatch,
  /// 最后匹配
  lastMatch,
  /// 随机匹配
  randomMatch,
}

/// 规则项类
class RuleItem {
  /// 规则类型
  final RuleType type;
  
  /// 规则值
  final String value;
  
  /// 规则动作
  final String action;
  
  /// 规则优先级
  final int priority;
  
  /// 规则描述
  final String? description;

  const RuleItem({
    required this.type,
    required this.value,
    required this.action,
    this.priority = 0,
    this.description,
  });

  /// 从JSON创建
  factory RuleItem.fromJson(Map<String, dynamic> json) {
    return RuleItem(
      type: RuleType.values.firstWhere(
        (e) => e.name == json['type'] ?? 'domain',
        orElse: () => RuleType.domain,
      ),
      value: json['value'] ?? '',
      action: json['action'] ?? '',
      priority: json['priority'] ?? 0,
      description: json['description'],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'value': value,
      'action': action,
      'priority': priority,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'RuleItem{type: $type, value: $value, action: $action, priority: $priority}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RuleItem &&
        other.type == type &&
        other.value == value &&
        other.action == action &&
        other.priority == priority &&
        other.description == description;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        value.hashCode ^
        action.hashCode ^
        priority.hashCode ^
        (description?.hashCode ?? 0);
  }
}

/// 规则提供者类
class RuleProvider {
  /// 提供者名称
  final String name;
  
  /// 提供者类型
  final String type;
  
  /// 提供者URL
  final String url;
  
  /// 是否启用
  final bool enable;
  
  /// 更新间隔（秒）
  final int updateInterval;

  const RuleProvider({
    required this.name,
    required this.type,
    required this.url,
    this.enable = true,
    this.updateInterval = 86400,
  });

  /// 从JSON创建
  factory RuleProvider.fromJson(Map<String, dynamic> json) {
    return RuleProvider(
      name: json['name'] ?? '',
      type: json['type'] ?? 'http',
      url: json['url'] ?? '',
      enable: json['enable'] ?? true,
      updateInterval: json['updateInterval'] ?? 86400,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'url': url,
      'enable': enable,
      'updateInterval': updateInterval,
    };
  }

  @override
  String toString() {
    return 'RuleProvider{name: $name, type: $type, url: $url, enable: $enable}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RuleProvider &&
        other.name == name &&
        other.type == type &&
        other.url == url &&
        other.enable == enable &&
        other.updateInterval == updateInterval;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        type.hashCode ^
        url.hashCode ^
        enable.hashCode ^
        updateInterval.hashCode;
  }
}