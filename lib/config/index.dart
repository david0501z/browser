/// 配置管理模块的公共导出
/// 
/// 这个模块包含了完整的规则配置和DNS设置功能，包括：
/// - 规则管理和配置
/// - DNS设置和优化
/// - 规则验证和模板管理
/// - 规则匹配算法
/// - DNS泄漏保护和优化
/// - Clash配置生成
/// - 配置示例和模板

// 配置生成器
export 'clash_config_generator.dart';

// 配置示例
export 'config_example.dart';

// 规则管理
export 'rule_manager.dart';

// DNS设置管理
export 'dns_settings_manager.dart';

// 规则验证
export 'rule_validator.dart';

// 规则模板管理
export 'rule_template_manager.dart';

// 规则匹配
export 'rule_matcher.dart';

// DNS保护管理
export 'dns_protection_manager.dart';

// 主要管理类快捷导出
export 'rule_manager.dart' show RuleManager, RuleConfig, RuleGroup, RuleStats;
export 'dns_settings_manager.dart' show DNSSettingsManager, DNSSettings, DNSServerConfig, DNSPerformanceMetrics;
export 'rule_template_manager.dart' show RuleTemplateManager, RuleTemplate, TemplateInstantiationResult;
export 'rule_matcher.dart' show RuleMatcher, MatchResult, MatchContext, MatchStats;
export 'dns_protection_manager.dart' show DNSProtectionManager, ProtectionResult, DNSProtectionStatus, DNSOptimizationConfig;

// 工具类和枚举
export 'rule_manager.dart' show RuleType, RuleAction;
export 'dns_settings_manager.dart' show DNSServerType, DNSProtocolType, DNSCacheStrategy, DNSResolutionStrategy;
export 'rule_validator.dart' show ValidationResult, ValidationReport;
export 'rule_template_manager.dart' show TemplateType, TemplateComplexity;
export 'rule_matcher.dart' show MatchType;
export 'dns_protection_manager.dart' show DNSProtectionLevel, DNSLeakType;