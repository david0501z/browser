import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';

import '../models/proxy_node.dart';
import '../services/subscription_service.dart';
import '../services/speed_test_service.dart';
import '../utils/node_validator.dart';

/// 代理节点管理器
class ProxyNodeManager {
  static final ProxyNodeManager _instance = ProxyNodeManager._internal();
  factory ProxyNodeManager() => _instance;
  ProxyNodeManager._internal();

  final SubscriptionService _subscriptionService = SubscriptionService();
  final SpeedTestService _speedTestService = SpeedTestService();
  final NodeValidator _validator = NodeValidator();

  /// 节点列表变更监听器
  final StreamController<List<ProxyNode>> _nodesStreamController = 
      StreamController<List<ProxyNode>>.broadcast();
  Stream<List<ProxyNode>> get nodesStream => _nodesStreamController.stream;

  /// 当前节点列表
  List<ProxyNode> _nodes = [];
  List<ProxyNode> get allNodes => List.unmodifiable(_nodes);

  /// 选中的节点
  ProxyNode? _selectedNode;
  ProxyNode? get selectedNode => _selectedNode;

  /// 初始化管理器
  Future<void> initialize() async {
    try {
      // 从数据库加载节点
      await _loadNodesFromDatabase();
      
      // 通知监听器
      _notifyNodesChanged();
    } catch (e) {
      throw Exception('初始化节点管理器失败: $e');
    }
  }

  /// 加载所有节点
  Future<List<ProxyNode>> loadAllNodes() async {
    try {
      // 从数据库加载节点
      await _loadNodesFromDatabase();
      
      // 通知监听器
      _notifyNodesChanged();
      
      return allNodes;
    } catch (e) {
      throw Exception('加载节点失败: $e');
    }
  }

  /// 添加节点
  Future<ProxyNode> addNode(ProxyNode node) async {
    try {
      final newNode = node.copyWith(
        id: _generateId(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _nodes.add(newNode);
      
      // 保存到数据库
      await _saveNodeToDatabase(newNode);
      
      // 通知监听器
      _notifyNodesChanged();
      
      return newNode;
    } catch (e) {
      throw Exception('添加节点失败: $e');
    }
  }

  /// 批量添加节点
  Future<List<ProxyNode>> addNodes(List<ProxyNode> nodes) async {
    try {
      final newNodes = nodes.map((node) => node.copyWith(
        id: _generateId(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      )).toList();

      _nodes.addAll(newNodes);
      
      // 批量保存到数据库
      await _saveNodesToDatabase(newNodes);
      
      // 通知监听器
      _notifyNodesChanged();
      
      return newNodes;
    } catch (e) {
      throw Exception('批量添加节点失败: $e');
    }
  }

  /// 更新节点
  Future<ProxyNode> updateNode(ProxyNode node) async {
    try {
      final index = _nodes.indexWhere((n) => n.id == node.id);
      if (index == -1) {
        throw Exception('节点不存在');
      }

      final updatedNode = node.copyWith(updatedAt: DateTime.now());
      _nodes[index] = updatedNode;
      
      // 保存到数据库
      await _updateNodeInDatabase(updatedNode);
      
      // 如果更新的是当前选中的节点，更新选中状态
      if (_selectedNode?.id == node.id) {
        _selectedNode = updatedNode;
      }
      
      // 通知监听器
      _notifyNodesChanged();
      
      return updatedNode;
    } catch (e) {
      throw Exception('更新节点失败: $e');
    }
  }

  /// 删除节点
  Future<void> deleteNode(String nodeId) async {
    try {
      final index = _nodes.indexWhere((n) => n.id == nodeId);
      if (index == -1) {
        throw Exception('节点不存在');
      }

      final node = _nodes[index];
      _nodes.removeAt(index);
      
      // 从数据库删除
      await _deleteNodeFromDatabase(nodeId);
      
      // 如果删除的是当前选中的节点，清除选中状态
      if (_selectedNode?.id == nodeId) {
        _selectedNode = null;
      }
      
      // 通知监听器
      _notifyNodesChanged();
    } catch (e) {
      throw Exception('删除节点失败: $e');
    }
  }

  /// 批量删除节点
  Future<void> deleteNodes(List<String> nodeIds) async {
    try {
      for (final nodeId in nodeIds) {
        final index = _nodes.indexWhere((n) => n.id == nodeId);
        if (index != -1) {
          _nodes.removeAt(index);
        }
      }

      // 批量从数据库删除
      await _deleteNodesFromDatabase(nodeIds);
      
      // 检查选中节点是否被删除
      if (_selectedNode != null && nodeIds.contains(_selectedNode!.id)) {
        _selectedNode = null;
      }
      
      // 通知监听器
      _notifyNodesChanged();
    } catch (e) {
      throw Exception('批量删除节点失败: $e');
    }
  }

  /// 选择节点
  Future<void> selectNode(String nodeId) async {
    try {
      final node = _nodes.firstWhere((n) => n.id == nodeId);
      
      if (_selectedNode != null) {
        // 将之前的选中节点标记为非选中
        final prevSelectedIndex = _nodes.indexWhere((n) => n.id == _selectedNode!.id);
        if (prevSelectedIndex != -1) {
          _nodes[prevSelectedIndex] = _nodes[prevSelectedIndex].copyWith(
            status: NodeStatus.normal,
          );
        }
      }

      // 将新节点标记为选中
      final newSelectedIndex = _nodes.indexWhere((n) => n.id == nodeId);
      if (newSelectedIndex != -1) {
        _nodes[newSelectedIndex] = _nodes[newSelectedIndex].copyWith(
          status: NodeStatus.selected,
        );
      }

      _selectedNode = node.copyWith(status: NodeStatus.selected);
      
      // 更新数据库中的选中状态
      await _updateNodeInDatabase(_selectedNode!);
      
      // 通知监听器
      _notifyNodesChanged();
    } catch (e) {
      throw Exception('选择节点失败: $e');
    }
  }

  /// 清除选中节点
  void clearSelectedNode() {
    if (_selectedNode != null) {
      final index = _nodes.indexWhere((n) => n.id == _selectedNode!.id);
      if (index != -1) {
        _nodes[index] = _nodes[index].copyWith(status: NodeStatus.normal);
      }
    }
    _selectedNode = null;
    _notifyNodesChanged();
  }

  /// 切换节点启用状态
  Future<void> toggleNodeEnabled(String nodeId) async {
    try {
      final index = _nodes.indexWhere((n) => n.id == nodeId);
      if (index == -1) {
        throw Exception('节点不存在');
      }

      final node = _nodes[index];
      final updatedNode = node.copyWith(
        enabled: !node.enabled,
        updatedAt: DateTime.now(),
      );

      await updateNode(updatedNode);
    } catch (e) {
      throw Exception('切换节点状态失败: $e');
    }
  }

  /// 切换节点收藏状态
  Future<void> toggleNodeFavorite(String nodeId) async {
    try {
      final index = _nodes.indexWhere((n) => n.id == nodeId);
      if (index == -1) {
        throw Exception('节点不存在');
      }

      final node = _nodes[index];
      final updatedNode = node.copyWith(
        favorite: !node.favorite,
        updatedAt: DateTime.now(),
      );

      await updateNode(updatedNode);
    } catch (e) {
      throw Exception('切换节点收藏状态失败: $e');
    }
  }

  /// 根据条件筛选节点
  List<ProxyNode> filterNodes(NodeFilter filter) {
    return _nodes.where((node) {
      // 类型过滤
      if (filter.types != null && !filter.types!.contains(node.type)) {
        return false;
      }

      // 状态过滤
      if (filter.statuses != null && !filter.statuses!.contains(node.status)) {
        return false;
      }

      // 国家过滤
      if (filter.countries != null) {
        final country = node.geoInfo?.country;
        if (country == null || !filter.countries!.contains(country)) {
          return false;
        }
      }

      // ISP 过滤
      if (filter.isps != null) {
        final isp = node.geoInfo?.isp;
        if (isp == null || !filter.isps!.contains(isp)) {
          return false;
        }
      }

      // 标签过滤
      if (filter.tags != null && filter.tags!.isNotEmpty) {
        final hasTag = filter.tags!.any((tag) => node.tags.contains(tag));
        if (!hasTag) return false;
      }

      // 收藏过滤
      if (filter.isFavorite != null && node.favorite != filter.isFavorite) {
        return false;
      }

      // 启用过滤
      if (filter.isEnabled != null && node.enabled != filter.isEnabled) {
        return false;
      }

      // 延迟过滤
      if (filter.maxLatency != null && 
          (node.latency == null || node.latency! > filter.maxLatency!)) {
        return false;
      }

      // 成功率过滤
      if (filter.minSuccessRate != null) {
        final successRate = node.performance?.successRate ?? 0.0;
        if (successRate < filter.minSuccessRate!) {
          return false;
        }
      }

      // 关键词过滤
      if (filter.keyword != null && filter.keyword!.isNotEmpty) {
        final keyword = filter.keyword!.toLowerCase();
        final searchableText = '${node.name} ${node.remark} ${node.tags.join(' ')}'.toLowerCase();
        if (!searchableText.contains(keyword)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// 对节点进行排序
  List<ProxyNode> sortNodes(List<ProxyNode> nodes, NodeSort sort) {
    final sorted = [...nodes];
    
    sorted.sort((a, b) {
      int comparison = 0;
      
      switch (sort.field) {
        case NodeSortField.name:
          comparison = a.name.compareTo(b.name);
          break;
        case NodeSortField.latency:
          final aLatency = a.latency ?? 999999;
          final bLatency = b.latency ?? 999999;
          comparison = aLatency.compareTo(bLatency);
          break;
        case NodeSortField.speed:
          final aSpeed = a.downloadSpeed ?? 0.0;
          final bSpeed = b.downloadSpeed ?? 0.0;
          comparison = aSpeed.compareTo(bSpeed);
          break;
        case NodeSortField.priority:
          comparison = a.priority.compareTo(b.priority);
          break;
        case NodeSortField.createdAt:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case NodeSortField.successRate:
          final aRate = a.performance?.successRate ?? 0.0;
          final bRate = b.performance?.successRate ?? 0.0;
          comparison = aRate.compareTo(bRate);
          break;
      }
      
      return sort.order == SortOrder.asc ? comparison : -comparison;
    });
    
    return sorted;
  }

  /// 获取最佳节点（基于延迟和成功率）
  ProxyNode? getBestNode({bool onlyEnabled = true}) {
    final candidates = _nodes.where((node) {
      if (onlyEnabled && !node.enabled) return false;
      if (node.latency == null) return false;
      if (node.status == NodeStatus.error || node.status == NodeStatus.timeout) return false;
      return true;
    }).toList();

    if (candidates.isEmpty) return null;

    // 使用加权评分算法
    candidates.sort((a, b) {
      final aScore = _calculateNodeScore(a);
      final bScore = _calculateNodeScore(b);
      return bScore.compareTo(aScore); // 降序排列，分数高的在前
    });

    return candidates.first;
  }

  /// 获取随机节点
  ProxyNode? getRandomNode({bool onlyEnabled = true, NodeFilter? filter}) {
    final candidates = filterNodes(filter ?? const NodeFilter());
    final filtered = candidates.where((node) {
      return !onlyEnabled || node.enabled;
    }).toList();

    if (filtered.isEmpty) return null;

    final random = Random();
    return filtered[random.nextInt(filtered.length)];
  }

  /// 获取最快速的节点
  ProxyNode? getFastestNode({bool onlyEnabled = true}) {
    final candidates = _nodes.where((node) {
      if (onlyEnabled && !node.enabled) return false;
      if (node.downloadSpeed == null) return false;
      return true;
    }).toList();

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) {
      final aSpeed = a.downloadSpeed ?? 0.0;
      final bSpeed = b.downloadSpeed ?? 0.0;
      return bSpeed.compareTo(aSpeed); // 降序排列
    });

    return candidates.first;
  }

  /// 获取最稳定的节点
  ProxyNode? getMostStableNode({bool onlyEnabled = true}) {
    final candidates = _nodes.where((node) {
      if (onlyEnabled && !node.enabled) return false;
      if (node.performance?.stabilityScore == null) return false;
      return true;
    }).toList();

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) {
      final aScore = a.performance?.stabilityScore ?? 0;
      final bScore = b.performance?.stabilityScore ?? 0;
      return bScore.compareTo(aScore); // 降序排列
    });

    return candidates.first;
  }

  /// 批量测试节点
  Future<Map<String, TestResult>> batchTestNodes({
    List<String>? nodeIds,
    int concurrency = 5,
    int timeoutSeconds = 10,
  }) async {
    try {
      final testNodes = nodeIds != null 
          ? _nodes.where((node) => nodeIds.contains(node.id)).toList()
          : _nodes.where((node) => node.enabled).toList();

      if (testNodes.isEmpty) return {};

      final results = <String, TestResult>{};
      final futures = <Future<void>>[];

      // 分批并发测试
      for (var i = 0; i < testNodes.length; i += concurrency) {
        final batch = testNodes.sublist(
          i, 
          (i + concurrency).clamp(0, testNodes.length)
        );

        final batchFutures = batch.map((node) async {
          try {
            final result = await _speedTestService.testNodeLatency(
              node, 
              timeoutSeconds: timeoutSeconds
            );
            
            // 更新节点状态
            final updatedNode = node.copyWith(
              latency: result.latency,
              lastTested: DateTime.now(),
              status: result.success ? NodeStatus.normal : NodeStatus.error,
              errorMessage: result.success ? null : result.error,
            );
            
            await updateNode(updatedNode);
            results[node.id] = result;
          } catch (e) {
            results[node.id] = TestResult(
              success: false,
              latency: null,
              error: e.toString(),
            );
          }
        }).toList();

        futures.addAll(batchFutures);
        await Future.wait(batchFutures);
      }

      return results;
    } catch (e) {
      throw Exception('批量测试节点失败: $e');
    }
  }

  /// 测试单个节点
  Future<TestResult> testNode(String nodeId, {int timeoutSeconds = 10}) async {
    try {
      final node = _nodes.firstWhere((n) => n.id == nodeId);
      
      // 更新节点状态为测试中
      await updateNode(node.copyWith(status: NodeStatus.testing));
      
      final result = await _speedTestService.testNodeLatency(
        node,
        timeoutSeconds: timeoutSeconds,
      );
      
      // 更新节点状态
      final updatedNode = node.copyWith(
        latency: result.latency,
        lastTested: DateTime.now(),
        status: result.success ? NodeStatus.normal : NodeStatus.error,
        errorMessage: result.success ? null : result.error,
      );
      
      await updateNode(updatedNode);
      return result;
    } catch (e) {
      return TestResult(
        success: false,
        latency: null,
        error: e.toString(),
      );
    }
  }

  /// 验证节点配置
  Future<ValidationResult> validateNode(String nodeId) async {
    try {
      final node = _nodes.firstWhere((n) => n.id == nodeId);
      return await _validator.validateNode(node);
    } catch (e) {
      return ValidationResult(
        isValid: false,
        errors: [e.toString()],
        warnings: [],
      );
    }
  }

  /// 批量验证节点
  Future<Map<String, ValidationResult>> validateNodes({List<String>? nodeIds}) async {
    try {
      final nodes = nodeIds != null
          ? _nodes.where((node) => nodeIds.contains(node.id)).toList()
          : _nodes;

      final results = <String, ValidationResult>{};
      
      for (final node in nodes) {
        try {
          final result = await _validator.validateNode(node);
          results[node.id] = result;
        } catch (e) {
          results[node.id] = ValidationResult(
            isValid: false,
            errors: [e.toString()],
            warnings: [],
          );
        }
      }
      
      return results;
    } catch (e) {
      throw Exception('批量验证节点失败: $e');
    }
  }

  /// 获取节点统计信息
  NodeStatistics getStatistics() {
    final totalNodes = _nodes.length;
    final enabledNodes = _nodes.where((n) => n.enabled).length;
    final favoriteNodes = _nodes.where((n) => n.favorite).length;
    
    final typeCounts = <ProxyType, int>{};
    final statusCounts = <NodeStatus, int>{};
    final countryCounts = <String, int>{};
    
    for (final node in _nodes) {
      // 统计类型
      typeCounts[node.type] = (typeCounts[node.type] ?? 0) + 1;
      
      // 统计状态
      statusCounts[node.status] = (statusCounts[node.status] ?? 0) + 1;
      
      // 统计国家
      final country = node.geoInfo?.country;
      if (country != null) {
        countryCounts[country] = (countryCounts[country] ?? 0) + 1;
      }
    }

    // 计算平均延迟
    final testedNodes = _nodes.where((n) => n.latency != null).toList();
    final avgLatency = testedNodes.isNotEmpty
        ? testedNodes.map((n) => n.latency!).reduce((a, b) => a + b) / testedNodes.length
        : null;

    // 计算成功率
    final performanceNodes = _nodes.where((n) => n.performance != null).toList();
    final avgSuccessRate = performanceNodes.isNotEmpty
        ? performanceNodes.map((n) => n.performance!.successRate).reduce((a, b) => a + b) / performanceNodes.length
        : 0.0;

    return NodeStatistics(
      totalNodes: totalNodes,
      enabledNodes: enabledNodes,
      disabledNodes: totalNodes - enabledNodes,
      favoriteNodes: favoriteNodes,
      typeCounts: typeCounts,
      statusCounts: statusCounts,
      countryCounts: countryCounts,
      avgLatency: avgLatency,
      avgSuccessRate: avgSuccessRate,
    );
  }

  /// 清除所有节点
  Future<void> clearAllNodes() async {
    try {
      _nodes.clear();
      _selectedNode = null;
      
      // 清空数据库
      await _clearAllNodesFromDatabase();
      
      // 通知监听器
      _notifyNodesChanged();
    } catch (e) {
      throw Exception('清除所有节点失败: $e');
    }
  }

  /// 计算节点评分
  double _calculateNodeScore(ProxyNode node) {
    // 基础分数
    double score = 100.0;
    
    // 延迟评分（延迟越低分数越高）
    if (node.latency != null) {
      score += (500 - min(node.latency!, 500)) * 0.2;
    }
    
    // 成功率评分
    if (node.performance != null) {
      score += node.performance!.successRate * 2;
      score += node.performance!.stabilityScore * 0.5;
    }
    
    // 优先级评分
    score += node.priority * 10;
    
    // 收藏节点额外加分
    if (node.favorite) {
      score += 20;
    }
    
    return max(score, 0.0);
  }

  /// 通知节点列表变更
  void _notifyNodesChanged() {
    _nodesStreamController.add(List.unmodifiable(_nodes));
  }

  /// 从数据库加载节点
  Future<void> _loadNodesFromDatabase() async {
    // TODO: 从数据库加载节点
    // 这里返回空列表作为示例
    _nodes = [];
  }

  /// 保存节点到数据库
  Future<void> _saveNodeToDatabase(ProxyNode node) async {
    // TODO: 保存单个节点到数据库
  }

  /// 批量保存节点到数据库
  Future<void> _saveNodesToDatabase(List<ProxyNode> nodes) async {
    // TODO: 批量保存节点到数据库
  }

  /// 更新数据库中的节点
  Future<void> _updateNodeInDatabase(ProxyNode node) async {
    // TODO: 更新数据库中的节点
  }

  /// 从数据库删除节点
  Future<void> _deleteNodeFromDatabase(String nodeId) async {
    // TODO: 从数据库删除节点
  }

  /// 批量从数据库删除节点
  Future<void> _deleteNodesFromDatabase(List<String> nodeIds) async {
    // TODO: 批量从数据库删除节点
  }

  /// 清空数据库中的所有节点
  Future<void> _clearAllNodesFromDatabase() async {
    // TODO: 清空数据库中的所有节点
  }

  /// 生成节点 ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           '_' + 
           (DateTime.now().microsecondSinceEpoch % 1000).toString();
  }

  /// 清理资源
  void dispose() {
    _nodesStreamController.close();
  }
}

/// 节点统计信息
class NodeStatistics {
  final int totalNodes;
  final int enabledNodes;
  final int disabledNodes;
  final int favoriteNodes;
  final Map<ProxyType, int> typeCounts;
  final Map<NodeStatus, int> statusCounts;
  final Map<String, int> countryCounts;
  final double? avgLatency;
  final double avgSuccessRate;

  NodeStatistics({
    required this.totalNodes,
    required this.enabledNodes,
    required this.disabledNodes,
    required this.favoriteNodes,
    required this.typeCounts,
    required this.statusCounts,
    required this.countryCounts,
    this.avgLatency,
    required this.avgSuccessRate,
  });
}

/// 测试结果
class TestResult {
  final bool success;
  final int? latency;
  final String? error;
  final DateTime timestamp;

  TestResult({
    required this.success,
    this.latency,
    this.error,
  }) : timestamp = DateTime.now();
}

/// 验证结果
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  ValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
  });
}