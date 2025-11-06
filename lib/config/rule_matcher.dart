import 'dart:collection';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'rule_manager.dart';

/// 匹配结果
@immutable
class MatchResult {
  final bool isMatch;
  final RuleConfig? matchedRule;
  final MatchType matchType;
  final double confidence;
  final int priority;
  final Map<String, dynamic>? metadata;
  final Duration matchTime;

  const MatchResult({
    required this.isMatch,
    this.matchedRule,
    this.matchType = MatchType.exact,
    this.confidence = 1.0,
    this.priority = 0,
    this.metadata,
    required this.matchTime,
  });

  /// 创建成功匹配结果
  factory MatchResult.success({
    required RuleConfig rule,
    MatchType matchType = MatchType.exact,
    double confidence = 1.0,
    Duration matchTime = Duration.zero,
  }) {
    return MatchResult(
      isMatch: true,
      matchedRule: rule,
      matchType: matchType,
      confidence: confidence,
      priority: rule.priority,
      matchTime: matchTime,
    );
  }

  /// 创建失败匹配结果
  factory MatchResult.noMatch(Duration matchTime) {
    return MatchResult(
      isMatch: false,
      matchTime: matchTime,
    );
  }

  @override
  String toString() {
    if (isMatch) {
      return 'MatchResult{success: ${matchedRule?.name}, type: $matchType, confidence: $confidence}';
    } else {
      return 'MatchResult{no match}';
    }
  }
}

/// 匹配类型
enum MatchType {
  exact,        // 精确匹配
  prefix,       // 前缀匹配
  suffix,       // 后缀匹配
  wildcard,     // 通配符匹配
  regex,        // 正则表达式匹配
  partial,      // 部分匹配
  fuzzy,        // 模糊匹配
}

/// 匹配上下文
@immutable
class MatchContext {
  final String source;
  final int port;
  final String protocol;
  final String? userAgent;
  final DateTime timestamp;
  final Map<String, dynamic>? customData;

  const MatchContext({
    required this.source,
    this.port = 80,
    this.protocol = 'tcp',
    this.userAgent,
    required this.timestamp,
    this.customData,
  });

  factory MatchContext.fromUrl(String url) {
    // 简单的URL解析
    final uri = Uri.parse(url);
    return MatchContext(
      source: uri.host,
      port: uri.port,
      protocol: uri.scheme,
    );
  }

  @override
  String toString() => 'MatchContext{source: $source, port: $port, protocol: $protocol}';
}

/// 匹配统计信息
@immutable
class MatchStats {
  final int totalMatches;
  final int successfulMatches;
  final int failedMatches;
  final int averageMatchTime;
  final Map<MatchType, int> matchTypeStats;
  final Map<String, int> ruleUsageStats;
  final DateTime lastUpdate;

  const MatchStats({
    required this.totalMatches,
    required this.successfulMatches,
    required this.failedMatches,
    required this.averageMatchTime,
    required this.matchTypeStats,
    required this.ruleUsageStats,
    required this.lastUpdate,
  });

  /// 匹配成功率
  double get successRate {
    if (totalMatches == 0) return 0.0;
    return successfulMatches / totalMatches;
  }

  @override
  String toString() {
    return 'MatchStats{total: $totalMatches, success: $successfulMatches, rate: ${(successRate * 100).toStringAsFixed(1)}%}';
  }
}

/// 规则匹配器
class RuleMatcher extends ChangeNotifier {
  static RuleMatcher? _instance;
  static RuleMatcher get instance => _instance ??= RuleMatcher._();

  RuleMatcher._();

  final List<RuleConfig> _rules = [];
  final Queue<MatchResult> _matchHistory = Queue();
  final Map<String, RegExp> _compiledRegexes = {};
  final Map<String, List<RuleConfig>> _rulesByType = {};
  
  MatchStats? _stats;
  int _maxHistorySize = 1000;
  bool _enableCache = true;
  bool _enableOptimization = true;

  /// 当前匹配的规则
  List<RuleConfig> get rules => List.unmodifiable(_rules);

  /// 匹配统计信息
  MatchStats? get stats => _stats;

  /// 匹配历史
  List<MatchResult> get matchHistory => List.unmodifiable(_matchHistory);

  /// 启用/禁用缓存
  set enableCache(bool value) {
    if (_enableCache != value) {
      _enableCache = value;
      if (!value) {
        _clearCache();
      }
      notifyListeners();
    }
  }

  bool get enableCache => _enableCache;

  /// 启用/禁用优化
  set enableOptimization(bool value) {
    if (_enableOptimization != value) {
      _enableOptimization = value;
      if (value) {
        _optimizeRules();
      }
      notifyListeners();
    }
  }

  bool get enableOptimization => _enableOptimization;

  /// 设置规则列表
  void setRules(List<RuleConfig> rules) {
    _rules.clear();
    _rules.addAll(rules.where((rule) => rule.enabled));
    
    _buildRuleIndex();
    if (_enableOptimization) {
      _optimizeRules();
    }
    
    notifyListeners();
  }

  /// 匹配单个规则
  MatchResult matchRule(String input, MatchContext context, {RuleType? ruleType}) {
    final startTime = DateTime.now();
    final targetRules = ruleType != null ? _rulesByType[ruleType] ?? _rules : _rules;
    
    // 按优先级排序规则
    final sortedRules = _getSortedRules(targetRules);
    
    for (final rule in sortedRules) {
      final result = _matchSingleRule(input, rule, context);
      final matchTime = DateTime.now().difference(startTime);
      
      if (result.isMatch) {
        _recordMatch(result);
        return result.copyWith(matchTime: matchTime);
      }
    }
    
    final matchTime = DateTime.now().difference(startTime);
    final result = MatchResult.noMatch(matchTime);
    _recordMatch(result);
    return result;
  }

  /// 批量匹配
  List<MatchResult> matchRules(List<String> inputs, MatchContext context, {RuleType? ruleType}) {
    return inputs.map((input) => matchRule(input, context, ruleType: ruleType)).toList();
  }

  /// 快速匹配（仅返回匹配的规则，不包含详细信息）
  RuleConfig? quickMatch(String input, {RuleType? ruleType}) {
    final targetRules = ruleType != null ? _rulesByType[ruleType] ?? _rules : _rules;
    final sortedRules = _getSortedRules(targetRules);
    
    for (final rule in sortedRules) {
      if (_isMatch(input, rule)) {
        return rule;
      }
    }
    
    return null;
  }

  /// 匹配域名
  MatchResult matchDomain(String domain, MatchContext context) {
    return matchRule(domain, context, ruleType: RuleType.domain);
  }

  /// 匹配IP地址
  MatchResult matchIP(String ip, MatchContext context) {
    return matchRule(ip, context, ruleType: RuleType.ip);
  }

  /// 匹配CIDR
  MatchResult matchCIDR(String address, MatchContext context) {
    return matchRule(address, context, ruleType: RuleType.cidr);
  }

  /// 匹配端口
  MatchResult matchPort(String port, MatchContext context) {
    return matchRule(port, context, ruleType: RuleType.port);
  }

  /// 匹配协议
  MatchResult matchProtocol(String protocol, MatchContext context) {
    return matchRule(protocol, context, ruleType: RuleType.protocol);
  }

  /// 匹配通配符
  MatchResult matchWildcard(String input, MatchContext context) {
    return matchRule(input, context, ruleType: RuleType.wildcard);
  }

  /// 匹配正则表达式
  MatchResult matchRegex(String input, MatchContext context) {
    return matchRule(input, context, ruleType: RuleType.regex);
  }

  /// 复合匹配（同时检查多种规则类型）
  MatchResult matchComprehensive(String input, MatchContext context) {
    final results = <MatchResult>[];
    
    // 优先检查更具体的规则类型
    final ruleTypes = [;
      RuleType.domain,
      RuleType.ip,
      RuleType.cidr,
      RuleType.regex,
      RuleType.wildcard,
      RuleType.port,
      RuleType.protocol,
    ];
    
    for (final ruleType in ruleTypes) {
      final result = matchRule(input, context, ruleType: ruleType);
      if (result.isMatch) {
        results.add(result);
      }
    }
    
    // 返回最高优先级的匹配结果
    if (results.isNotEmpty) {
      results.sort((a, b) => b.priority.compareTo(a.priority));
      return results.first;
    }
    
    return matchRule(input, context); // 回退到完整匹配
  }

  /// 私有匹配方法

  MatchResult _matchSingleRule(String input, RuleConfig rule, MatchContext context) {
    final startTime = DateTime.now();
    
    if (!_isMatch(input, rule)) {
      return MatchResult.noMatch(DateTime.now().difference(startTime));
    }
    
    final matchType = _getMatchType(input, rule);
    final confidence = _calculateConfidence(input, rule, matchType);
    
    return MatchResult.success(
      rule: rule,
      matchType: matchType,
      confidence: confidence,
      matchTime: DateTime.now().difference(startTime),
    );
  }

  bool _isMatch(String input, RuleConfig rule) {
    switch (rule.type) {
      case RuleType.domain:
        return _matchDomain(input, rule.pattern);
      
      case RuleType.ip:
        return _matchIP(input, rule.pattern);
      
      case RuleType.cidr:
        return _matchCIDR(input, rule.pattern);
      
      case RuleType.port:
        return _matchPort(input, rule.pattern);
      
      case RuleType.protocol:
        return _matchProtocol(input, rule.pattern);
      
      case RuleType.wildcard:
        return _matchWildcard(input, rule.pattern);
      
      case RuleType.regex:
        return _matchRegex(input, rule.pattern);
      
      case RuleType.geoip:
        return _matchGeoIP(input, rule.pattern);
      
      case RuleType.adblock:
        return _matchAdBlock(input, rule.pattern);
      
      case RuleType.custom:
        return _matchCustom(input, rule.pattern);
    }
  }

  bool _matchDomain(String domain, String pattern) {
    if (pattern == domain) return true;
    if (pattern.startsWith('*.')) {
      final suffix = pattern.substring(2);
      return domain.endsWith('.$suffix') || domain == suffix;
    }
    if (pattern.endsWith('.*')) {
      final prefix = pattern.substring(0, pattern.length - 2);
      return domain.startsWith(prefix);
    }
    return false;
  }

  bool _matchIP(String ip, String pattern) {
    return ip == pattern;
  }

  bool _matchCIDR(String address, String pattern) {
    // 简单的CIDR匹配实现
    final parts = pattern.split('/');
    if (parts.length != 2) return false;
    
    final networkIP = parts[0];
    final prefixLength = int.parse(parts[1]);
    
    return _isIPInCIDR(address, networkIP, prefixLength);
  }

  bool _matchPort(String port, String pattern) {
    return port == pattern;
  }

  bool _matchProtocol(String protocol, String pattern) {
    return protocol.toLowerCase() == pattern.toLowerCase();
  }

  bool _matchWildcard(String input, String pattern) {
    // 转换通配符模式为正则表达式
    final regexPattern = pattern;
        .replaceAll('.', r'\.')
        .replaceAll('*', '.*')
        .replaceAll('?', '.');
    
    return RegExp('^$regexPattern\$', caseSensitive: false).hasMatch(input);
  }

  bool _matchRegex(String input, String pattern) {
    try {
      RegExp? regex = _compiledRegexes[pattern];
      if (regex == null) {
        // 解析正则表达式模式
        final regexParts = _parseRegexPattern(pattern);
        regex = RegExp(regexParts.pattern, caseSensitive: regexParts.caseSensitive);
        _compiledRegexes[pattern] = regex;
      }
      
      return regex.hasMatch(input);
    } catch (e) {
      debugPrint('正则表达式匹配错误: $e');
      return false;
    }
  }

  bool _matchGeoIP(String input, String pattern) {
    // 简化的GeoIP匹配
    return input.toUpperCase() == pattern.toUpperCase();
  }

  bool _matchAdBlock(String input, String pattern) {
    if (pattern.startsWith('||')) {
      final domain = pattern.substring(2);
      return input.endsWith(domain);
    } else if (pattern.startsWith('|')) {
      final prefix = pattern.substring(1);
      return input.startsWith(prefix);
    } else {
      return input.contains(pattern);
    }
  }

  bool _matchCustom(String input, String pattern) {
    // 自定义匹配逻辑
    return input.contains(pattern);
  }

  /// 辅助方法

  bool _isIPInCIDR(String ip, String networkIP, int prefixLength) {
    final ipParts = ip.split('.').map(int.parse).toList();
    final networkParts = networkIP.split('.').map(int.parse).toList();
    
    if (ipParts.length != 4 || networkParts.length != 4) return false;
    
    // 计算网络掩码
    int mask = 0;
    for (int i = 0; i < prefixLength; i++) {
      mask |= (1 << (31 - i));
    }
    
    // 比较网络部分
    for (int i = 0; i < 4; i++) {
      final ipPart = ipParts[i];
      final networkPart = networkParts[i];
      final maskPart = (mask >> ((3 - i) * 8)) & 0xFF;
      
      if ((ipPart & maskPart) != (networkPart & maskPart)) {
        return false;
      }
    }
    
    return true;
  }

  MatchType _getMatchType(String input, RuleConfig rule) {
    switch (rule.type) {
      case RuleType.domain:
        if (rule.pattern == input) return MatchType.exact;
        if (rule.pattern.startsWith('*.')) return MatchType.suffix;
        if (rule.pattern.endsWith('.*')) return MatchType.prefix;
        return MatchType.partial;
      
      case RuleType.ip:
        return MatchType.exact;
      
      case RuleType.cidr:
        return MatchType.partial;
      
      case RuleType.port:
        return MatchType.exact;
      
      case RuleType.protocol:
        return MatchType.exact;
      
      case RuleType.wildcard:
        return MatchType.wildcard;
      
      case RuleType.regex:
        return MatchType.regex;
      
      case RuleType.geoip:
        return MatchType.exact;
      
      case RuleType.adblock:
        return MatchType.partial;
      
      case RuleType.custom:
        return MatchType.partial;
    }
  }

  double _calculateConfidence(String input, RuleConfig rule, MatchType matchType) {
    double confidence = 1.0;
    
    // 根据匹配类型调整置信度
    switch (matchType) {
      case MatchType.exact:
        confidence = 1.0;
        break;
      case MatchType.prefix:
        confidence = 0.9;
        break;
      case MatchType.suffix:
        confidence = 0.9;
        break;
      case MatchType.wildcard:
        confidence = 0.8;
        break;
      case MatchType.regex:
        confidence = 0.7;
        break;
      case MatchType.partial:
        confidence = 0.6;
        break;
      case MatchType.fuzzy:
        confidence = 0.5;
        break;
    }
    
    // 根据规则优先级调整
    if (rule.priority >= RulePriority.critical) {
      confidence += 0.1;
    } else if (rule.priority <= RulePriority.low) {
      confidence -= 0.1;
    }
    
    return confidence.clamp(0.0, 1.0);
  }

  List<RuleConfig> _getSortedRules(List<RuleConfig> rules) {
    if (!_enableOptimization) {
      return List.from(rules);
    }
    
    // 按优先级排序，相同优先级按创建时间排序
    rules.sort((a, b) {
      final priorityCompare = b.priority.compareTo(a.priority);
      if (priorityCompare != 0) return priorityCompare;
      return b.createdAt.compareTo(a.createdAt);
    });
    
    return rules;
  }

  void _buildRuleIndex() {
    _rulesByType.clear();
    
    for (final rule in _rules) {
      _rulesByType.putIfAbsent(rule.type, () => []).add(rule);
    }
  }

  void _optimizeRules() {
    // 缓存常用的正则表达式
    _compiledRegexes.clear();
    
    for (final rule in _rules) {
      if (rule.type == RuleType.regex) {
        try {
          final regexParts = _parseRegexPattern(rule.pattern);
          final regex = RegExp(regexParts.pattern, caseSensitive: regexParts.caseSensitive);
          _compiledRegexes[rule.pattern] = regex;
        } catch (e) {
          debugPrint('预编译正则表达式失败: ${rule.pattern}, $e');
        }
      }
    }
  }

  void _recordMatch(MatchResult result) {
    if (_matchHistory.length >= _maxHistorySize) {
      _matchHistory.removeFirst();
    }
    _matchHistory.add(result);
    
    // 更新统计信息
    _updateStats(result);
  }

  void _updateStats(MatchResult result) {
    final now = DateTime.now();
    
    if (_stats == null) {
      _stats = MatchStats(
        totalMatches: result.isMatch ? 1 : 0,
        successfulMatches: result.isMatch ? 1 : 0,
        failedMatches: result.isMatch ? 0 : 1,
        averageMatchTime: result.matchTime.inMilliseconds,
        matchTypeStats: {result.matchType: 1},
        ruleUsageStats: result.matchedRule != null ? {result.matchedRule!.id: 1} : {},
        lastUpdate: now,
      );
    } else {
      final newStats = _stats!;
      final newMatchTypeStats = Map<MatchType, int>.from(newStats.matchTypeStats);
      final newRuleUsageStats = Map<String, int>.from(newStats.ruleUsageStats);
      
      if (result.isMatch) {
        newMatchTypeStats[result.matchType] = (newMatchTypeStats[result.matchType] ?? 0) + 1;
        
        if (result.matchedRule != null) {
          newRuleUsageStats[result.matchedRule!.id] =;
              (newRuleUsageStats[result.matchedRule!.id] ?? 0) + 1;
        }
      }
      
      // 计算新的平均匹配时间
      final totalTime = newStats.averageMatchTime * newStats.totalMatches +;
                       result.matchTime.inMilliseconds;
      final newTotalMatches = newStats.totalMatches + 1;
      final newAverageTime = totalTime ~/ newTotalMatches;
      
      _stats = MatchStats(
        totalMatches: newTotalMatches,
        successfulMatches: newStats.successfulMatches + (result.isMatch ? 1 : 0),
        failedMatches: newStats.failedMatches + (result.isMatch ? 0 : 1),
        averageMatchTime: newAverageTime,
        matchTypeStats: newMatchTypeStats,
        ruleUsageStats: newRuleUsageStats,
        lastUpdate: now,
      );
    }
  }

  void _clearCache() {
    _compiledRegexes.clear();
  }

  /// 正则表达式解析
  ({String pattern, bool caseSensitive}) _parseRegexPattern(String pattern) {
    if (!pattern.startsWith('/')) {
      return (pattern: pattern, caseSensitive: false);
    }
    
    final lastSlashIndex = pattern.lastIndexOf('/');
    if (lastSlashIndex == -1) {
      return (pattern: pattern, caseSensitive: false);
    }
    
    final regexPattern = pattern.substring(1, lastSlashIndex);
    final flags = pattern.substring(lastSlashIndex + 1);
    
    bool caseSensitive = !flags.contains('i');
    
    return (pattern: regexPattern, caseSensitive: caseSensitive);
  }

  /// 获取匹配性能报告
  Map<String, dynamic> getPerformanceReport() {
    if (_stats == null) return {};
    
    final report = <String, dynamic>{
      'totalMatches': _stats!.totalMatches,
      'successRate': '${(_stats!.successRate * 100).toStringAsFixed(1)}%',
      'averageMatchTime': '${_stats!.averageMatchTime}ms',
      'matchTypeDistribution': <String, int>{},
      'topUsedRules': <String, int>{},
    };
    
    // 匹配类型分布
    for (final entry in _stats!.matchTypeStats.entries) {
      report['matchTypeDistribution'][entry.key.name] = entry.value;
    }
    
    // 最常用的规则
    final sortedRules = _stats!.ruleUsageStats.entries.toList();
      ..sort((a, b) => b.value.compareTo(a.value));
    
    for (final entry in sortedRules.take(10)) {
      report['topUsedRules'][entry.key] = entry.value;
    }
    
    return report;
  }

  /// 清除统计信息
  void clearStats() {
    _stats = null;
    _matchHistory.clear();
    notifyListeners();
  }

  /// 设置历史记录最大大小
  set maxHistorySize(int size) {
    _maxHistorySize = size;
    while (_matchHistory.length > size) {
      _matchHistory.removeFirst();
    }
    notifyListeners();
  }

  int get maxHistorySize => _maxHistorySize;

  /// 清理资源
  @override
  void dispose() {
    _rules.clear();
    _compiledRegexes.clear();
    _rulesByType.clear();
    _matchHistory.clear();
    super.dispose();
  }
}