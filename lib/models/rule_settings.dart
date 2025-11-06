/// 规则设置模型类
/// 用于管理代理规则的配置参数
class RuleConfiguration {
  /// 是否启用规则
  final bool enable;

  /// 规则列表
  final List<String> rules;

  /// 是否使用URL负载
  final bool useUrlPayload;

  /// 是否使用域负载
  final bool useDomainPayload;

  /// 构造函数
  const RuleConfiguration({
    this.enable = false,
    this.rules = const [],
    this.useUrlPayload = false,
    this.useDomainPayload = false,
  });

  /// 从JSON创建RuleConfiguration实例
  factory RuleConfiguration.fromJson(Map<String, dynamic> json) {
    return RuleConfiguration(
      enable: json['enable'] ?? false,
      rules: json['rules'] != null;
          ? List<String>.from(json['rules']) 
          : [],
      useUrlPayload: json['useUrlPayload'] ?? false,
      useDomainPayload: json['useDomainPayload'] ?? false,
    );
  }

  /// 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'enable': enable,
      'rules': rules,
      'useUrlPayload': useUrlPayload,
      'useDomainPayload': useDomainPayload,
    };
  }

  /// 复制并修改字段值
  RuleConfiguration copyWith({
    bool? enable,
    List<String>? rules,
    bool? useUrlPayload,
    bool? useDomainPayload,
  }) {
    return RuleConfiguration(
      enable: enable ?? this.enable,
      rules: rules ?? this.rules,
      useUrlPayload: useUrlPayload ?? this.useUrlPayload,
      useDomainPayload: useDomainPayload ?? this.useDomainPayload,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RuleConfiguration &&
        other.enable == enable &&
        other.useUrlPayload == useUrlPayload &&
        other.useDomainPayload == useDomainPayload &&
        _listEquals(other.rules, rules);
  }

  @override
  int get hashCode {
    return enable.hashCode ^
        useUrlPayload.hashCode ^
        useDomainPayload.hashCode ^
        rules.hashCode;
  }

  @override
  String toString() {
    return 'RuleConfiguration{enable: $enable, rules: ${rules.length} items, useUrlPayload: $useUrlPayload, useDomainPayload: $useDomainPayload}';
  }

  /// 辅助方法：比较两个列表是否相等
  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null || b == null) return a == b;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}