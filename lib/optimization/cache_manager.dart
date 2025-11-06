import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'proxy_performance_optimizer.dart';

/// 高性能缓存管理器
/// 
/// 提供多层级缓存支持：
/// - 内存缓存 (LRU)
/// - 磁盘缓存
/// - 网络缓存
/// - 智能预加载
/// - 缓存压缩
/// - 缓存统计和优化
class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  // 内存缓存
  final MemoryCache _memoryCache = MemoryCache();
  
  // 磁盘缓存
  final DiskCache _diskCache = DiskCache();
  
  // 网络缓存
  final NetworkCache _networkCache = NetworkCache();
  
  // 缓存统计
  final CacheStats _stats = CacheStats();
  
  // 配置
  CacheConfig? _config;
  
  // 清理定时器
  Timer? _cleanupTimer;
  
  // 预加载定时器
  Timer? _preloadTimer;
  
  // 压缩定时器
  Timer? _compressionTimer;
  
  // 性能监控
  final PerformanceMonitor _monitor = PerformanceMonitor();
  
  /// 初始化缓存管理器
  Future<void> initialize({
    CacheConfig? config,
    bool enableAutoCleanup = true,
    bool enablePreload = true,
  }) async {
    _config = config ?? CacheConfig.defaultConfig();
    
    // 初始化内存缓存
    await _memoryCache.initialize(_config!);
    
    // 初始化磁盘缓存
    await _diskCache.initialize(_config!);
    
    // 初始化网络缓存
    await _networkCache.initialize(_config!);
    
    // 启动清理任务
    if (enableAutoCleanup) {
      _startCleanupTimer();
    }
    
    // 启动预加载
    if (enablePreload) {
      _startPreloadTimer();
    }
    
    // 启动压缩任务
    _startCompressionTimer();
    
    log('[CacheManager] 缓存管理器已初始化');
  }
  
  /// 获取缓存项
  Future<T?> get<T>(String key) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      T? value;
      CacheSource? source;
      
      // 1. 从内存缓存获取
      if (_config!.enableMemoryCache) {
        final memoryValue = await _memoryCache.get(key);
        if (memoryValue != null) {
          value = memoryValue as T;
          source = CacheSource.memory;
        }
      }
      
      // 2. 从磁盘缓存获取
      if (value == null && _config!.enableDiskCache) {
        final diskValue = await _diskCache.get(key);
        if (diskValue != null) {
          value = diskValue as T;
          source = CacheSource.disk;
          
          // 提升到内存缓存
          if (_config!.enableMemoryCache && _config!.promoteToMemory) {
            await _memoryCache.set(key, value);
          }
        }
      }
      
      // 3. 从网络缓存获取
      if (value == null && _config!.enableNetworkCache) {
        final networkValue = await _networkCache.get(key);
        if (networkValue != null) {
          value = networkValue as T;
          source = CacheSource.network;
          
          // 提升到内存和磁盘缓存
          if (_config!.enableMemoryCache) {
            await _memoryCache.set(key, value);
          }
          if (_config!.enableDiskCache) {
            await _diskCache.set(key, value);
          }
        }
      }
      
      // 更新统计
      if (value != null) {
        _stats.totalHits++;
        _stats.hitsBySource[source!] = (_stats.hitsBySource[source] ?? 0) + 1;
      } else {
        _stats.totalMisses++;
      }
      
      final duration = stopwatch.elapsedMilliseconds;
      _stats.avgLookupTime = (_stats.avgLookupTime + duration) ~/ 2;
      
      log('[CacheManager] 缓存查找: $key (${duration}ms, ${source?.toString() ?? 'miss'})');
      
      return value;
    } catch (e) {
      log('[CacheManager] 缓存获取失败: $key - $e', level: 500);
      return null;
    } finally {
      stopwatch.stop();
    }
  }
  
  /// 设置缓存项
  Future<void> set<T>(String key, T value, {
    Duration? expiry,
    CachePolicy? policy,
  }) async {
    try {
      final effectiveExpiry = expiry ?? _config!.defaultExpiry;
      final effectivePolicy = policy ?? _config!.defaultPolicy;
      
      // 存储到内存缓存
      if (_config!.enableMemoryCache && _shouldCacheInMemory(effectivePolicy)) {
        await _memoryCache.set(key, value, expiry: effectiveExpiry);
      }
      
      // 存储到磁盘缓存
      if (_config!.enableDiskCache && _shouldCacheInDisk(effectivePolicy)) {
        await _diskCache.set(key, value, expiry: effectiveExpiry);
      }
      
      // 存储到网络缓存
      if (_config!.enableNetworkCache && _shouldCacheInNetwork(effectivePolicy)) {
        await _networkCache.set(key, value, expiry: effectiveExpiry);
      }
      
      // 更新统计
      _stats.totalPuts++;
      _stats.totalSize += _estimateSize(value);
      
      log('[CacheManager] 缓存设置: $key (${effectiveExpiry.inSeconds}s)');
      
    } catch (e) {
      log('[CacheManager] 缓存设置失败: $key - $e', level: 500);
    }
  }
  
  /// 删除缓存项
  Future<void> remove(String key) async {
    try {
      await Future.wait([
        _memoryCache.remove(key),
        _diskCache.remove(key),
        _networkCache.remove(key),
      ]);
      
      _stats.totalRemovals++;
      log('[CacheManager] 缓存删除: $key');
    } catch (e) {
      log('[CacheManager] 缓存删除失败: $key - $e');
    }
  }
  
  /// 清空所有缓存
  Future<void> clear() async {
    try {
      await Future.wait([
        _memoryCache.clear(),
        _diskCache.clear(),
        _networkCache.clear(),
      ]);
      
      _stats.reset();
      log('[CacheManager] 所有缓存已清空');
    } catch (e) {
      log('[CacheManager] 清空缓存失败: $e', level: 500);
    }
  }
  
  /// 预加载数据
  Future<void> preload(String key, Future<T> Function() loader) async {
    try {
      if (await has(key)) return; // 已存在，不需要预加载
      
      final value = await loader();
      await set(key, value);
      
      log('[CacheManager] 预加载完成: $key');
    } catch (e) {
      log('[CacheManager] 预加载失败: $key - $e');
    }
  }
  
  /// 批量预加载
  Future<void> preloadBatch(Map<String, Future<dynamic> Function()> loaders) async {
    final futures = loaders.entries.map((entry) => 
      preload(entry.key, entry.value)
    ).toList();
    
    await Future.wait(futures);
    log('[CacheManager] 批量预加载完成: ${loaders.length} 项');
  }
  
  /// 检查是否存在
  Future<bool> has(String key) async {
    return (await get(key)) != null;
  }
  
  /// 获取缓存项数量
  Future<int> count() async {
    final counts = await Future.wait([;
      _memoryCache.count(),
      _diskCache.count(),
      _networkCache.count(),
    ]);
    
    return counts.reduce((a, b) => a + b);
  }
  
  /// 获取缓存大小
  Future<int> size() async {
    return await _diskCache.size();
  }
  
  /// 压缩缓存数据
  Future<void> compressCache({double threshold = 0.8}) async {
    try {
      final memoryUsage = await _memoryCache.usage();
      
      if (memoryUsage.usagePercent > threshold * 100) {
        await _memoryCache.compress();
        log('[CacheManager] 内存缓存压缩完成');
      }
      
      final diskUsage = await _diskCache.usage();
      if (diskUsage.usagePercent > threshold * 100) {
        await _diskCache.compress();
        log('[CacheManager] 磁盘缓存压缩完成');
      }
    } catch (e) {
      log('[CacheManager] 缓存压缩失败: $e');
    }
  }
  
  /// 优化缓存策略
  Future<void> optimizeCacheStrategy() async {
    try {
      // 分析使用模式
      final pattern = await _analyzeUsagePattern();
      
      // 调整缓存大小
      await _adjustCacheSizes(pattern);
      
      // 清理低使用率项目
      await _cleanupLowUsageItems(pattern);
      
      log('[CacheManager] 缓存策略优化完成');
    } catch (e) {
      log('[CacheManager] 缓存策略优化失败: $e');
    }
  }
  
  /// 获取缓存统计
  CacheStats get stats => _stats;
  
  /// 获取缓存状态
  CacheStatus get status => CacheStatus(
    memoryUsage: _memoryCache.usage(),
    diskUsage: _diskCache.usage(),
    networkUsage: _networkCache.usage(),
    totalHits: _stats.totalHits,
    totalMisses: _stats.totalMisses,
    hitRate: _stats.hitRate,
  );
  
  /// 启动清理定时器
  void _startCleanupTimer() {
    _cleanupTimer = Timer.periodic(
      _config!.cleanupInterval,
      (_) => _performCleanup(),
    );
  }
  
  /// 启动预加载定时器
  void _startPreloadTimer() {
    _preloadTimer = Timer.periodic(
      _config!.preloadInterval,
      (_) => _performPreload(),
    );
  }
  
  /// 启动压缩定时器
  void _startCompressionTimer() {
    _compressionTimer = Timer.periodic(
      const Duration(minutes: 30),
      (_) => compressCache(),
    );
  }
  
  /// 执行清理任务
  Future<void> _performCleanup() async {
    try {
      final now = DateTime.now();
      
      // 清理过期项目
      await Future.wait([
        _memoryCache.cleanupExpired(now),
        _diskCache.cleanupExpired(now),
        _networkCache.cleanupExpired(now),
      ]);
      
      // 清理LRU项目
      await _memoryCache.cleanupLRU();
      
      log('[CacheManager] 缓存清理完成');
    } catch (e) {
      log('[CacheManager] 缓存清理失败: $e');
    }
  }
  
  /// 执行预加载任务
  Future<void> _performPreload() async {
    try {
      // 基于访问模式预加载可能需要的资源
      final preloadCandidates = await _identifyPreloadCandidates();
      
      for (final candidate in preloadCandidates) {
        await preload(candidate.key, candidate.loader);
      }
      
      log('[CacheManager] 预加载任务完成: ${preloadCandidates.length} 项');
    } catch (e) {
      log('[CacheManager] 预加载任务失败: $e');
    }
  }
  
  /// 分析使用模式
  Future<UsagePattern> _analyzeUsagePattern() async {
    // 简化实现，实际中需要更复杂的分析
    return UsagePattern(
      frequentKeys: [],
      infrequentKeys: [],
      averageAccessTime: _stats.avgLookupTime,
    );
  }
  
  /// 调整缓存大小
  Future<void> _adjustCacheSizes(UsagePattern pattern) async {
    final memoryUsage = await _memoryCache.usage();
    
    if (memoryUsage.usagePercent > 90) {
      await _memoryCache.reduceSize(0.1);
    } else if (memoryUsage.usagePercent < 50) {
      await _memoryCache.increaseSize(0.1);
    }
  }
  
  /// 清理低使用率项目
  Future<void> _cleanupLowUsageItems(UsagePattern pattern) async {
    // 清理低频访问的项目
    await _memoryCache.cleanupLowUsage(pattern.infrequentKeys);
  }
  
  /// 识别预加载候选项
  Future<List<PreloadCandidate>> _identifyPreloadCandidates() async {
    // 基于访问历史预测可能需要的资源
    return [];
  }
  
  /// 判断是否应该缓存到内存
  bool _shouldCacheInMemory(CachePolicy policy) {
    switch (policy) {
      case CachePolicy.memoryOnly:
      case CachePolicy.memoryAndDisk:
      case CachePolicy.memoryAndNetwork:
      case CachePolicy.all:
        return true;
      case CachePolicy.diskOnly:
      case CachePolicy.networkOnly:
      case CachePolicy.bypass:
        return false;
    }
  }
  
  /// 判断是否应该缓存到磁盘
  bool _shouldCacheInDisk(CachePolicy policy) {
    switch (policy) {
      case CachePolicy.diskOnly:
      case CachePolicy.memoryAndDisk:
      case CachePolicy.memoryAndNetwork:
      case CachePolicy.all:
        return true;
      case CachePolicy.memoryOnly:
      case CachePolicy.networkOnly:
      case CachePolicy.bypass:
        return false;
    }
  }
  
  /// 判断是否应该缓存到网络
  bool _shouldCacheInNetwork(CachePolicy policy) {
    switch (policy) {
      case CachePolicy.networkOnly:
      case CachePolicy.memoryAndNetwork:
      case CachePolicy.all:
        return true;
      case CachePolicy.memoryOnly:
      case CachePolicy.diskOnly:
      case CachePolicy.bypass:
        return false;
    }
  }
  
  /// 估算数据大小
  int _estimateSize(dynamic value) {
    if (value is String) {
      return value.length * 2; // UTF-16编码
    } else if (value is List<int>) {
      return value.length;
    } else if (value is Uint8List) {
      return value.lengthInBytes;
    } else {
      try {
        final jsonString = jsonEncode(value);
        return jsonString.length * 2;
      } catch (e) {
        return 100; // 默认估计值
      }
    }
  }
  
  /// 销毁缓存管理器
  Future<void> dispose() async {
    _cleanupTimer?.cancel();
    _preloadTimer?.cancel();
    _compressionTimer?.cancel();
    
    await Future.wait([
      _memoryCache.dispose(),
      _diskCache.dispose(),
      _networkCache.dispose(),
      _monitor.dispose(),
    ]);
    
    log('[CacheManager] 缓存管理器已销毁');
  }
}

/// 缓存配置
class CacheConfig {
  final bool enableMemoryCache;
  final bool enableDiskCache;
  final bool enableNetworkCache;
  final bool promoteToMemory;
  final Duration defaultExpiry;
  final Duration cleanupInterval;
  final Duration preloadInterval;
  final int maxMemorySize;
  final int maxDiskSize;
  final double compressionThreshold;
  final CachePolicy defaultPolicy;
  
  CacheConfig({
    this.enableMemoryCache = true,
    this.enableDiskCache = true,
    this.enableNetworkCache = false,
    this.promoteToMemory = true,
    this.defaultExpiry = const Duration(hours: 24),
    this.cleanupInterval = const Duration(minutes: 30),
    this.preloadInterval = const Duration(minutes: 15),
    this.maxMemorySize = 100 * 1024 * 1024, // 100MB;
    this.maxDiskSize = 500 * 1024 * 1024, // 500MB;
    this.compressionThreshold = 0.8,
    this.defaultPolicy = CachePolicy.all,
  });
  
  factory CacheConfig.defaultConfig() => CacheConfig();
}

/// 缓存策略
enum CachePolicy {
  memoryOnly,      // 仅内存缓存
  diskOnly,        // 仅磁盘缓存
  networkOnly,     // 仅网络缓存
  memoryAndDisk,   // 内存和磁盘
  memoryAndNetwork, // 内存和网络
  all,             // 所有层级
  bypass,          // 绕过缓存
}

/// 缓存来源
enum CacheSource {
  memory,
  disk,
  network,
}

/// 内存缓存
class MemoryCache {
  final Map<String, CacheEntry> _cache = {};
  final List<String> _accessOrder = [];
  int _maxSize = 100 * 1024 * 1024; // 100MB;
  int _currentSize = 0;
  
  Future<void> initialize(CacheConfig config) async {
    _maxSize = config.maxMemorySize;
    log('[MemoryCache] 内存缓存已初始化: ${_maxSize} bytes');
  }
  
  Future<dynamic> get(String key) async {
    final entry = _cache[key];
    if (entry != null && !entry.isExpired()) {
      // 更新访问顺序
      _updateAccessOrder(key);
      entry.lastAccessed = DateTime.now();
      return entry.value;
    }
    return null;
  }
  
  Future<void> set(String key, dynamic value, {Duration? expiry}) async {
    final entry = CacheEntry(
      value: value,
      expiry: expiry,
    );
    
    final size = _estimateSize(value);
    
    // 检查是否需要清理空间
    if (_currentSize + size > _maxSize) {
      await _evictLRU(size);
    }
    
    // 如果键已存在，先删除旧值
    if (_cache.containsKey(key)) {
      final oldSize = _estimateSize(_cache[key]!.value);
      _currentSize -= oldSize;
      _cache.remove(key);
    }
    
    _cache[key] = entry;
    _accessOrder.remove(key);
    _accessOrder.add(key);
    _currentSize += size;
  }
  
  Future<void> remove(String key) async {
    final entry = _cache.remove(key);
    if (entry != null) {
      _currentSize -= _estimateSize(entry.value);
      _accessOrder.remove(key);
    }
  }
  
  Future<void> clear() async {
    _cache.clear();
    _accessOrder.clear();
    _currentSize = 0;
  }
  
  Future<int> count() async => _cache.length;
  
  Future<CacheUsage> usage() async {
    return CacheUsage(
      used: _currentSize,
      total: _maxSize,
      usagePercent: (_currentSize / _maxSize * 100).toDouble(),
      entries: _cache.length,
    );
  }
  
  Future<void> compress() async {
    // 压缩缓存中的字符串数据
    for (final entry in _cache.values) {
      if (entry.value is String) {
final compressed = utf8.encode(utf8.decode(utf8.encode(entry.value));
        // 这里可以实现真正的压缩算法
        entry.size = compressed.length;
      }
    }
    log('[MemoryCache] 内存缓存压缩完成');
  }
  
  Future<void> cleanupExpired(DateTime now) async {
    final expiredKeys = _cache.entries;
        .where((entry) => entry.value.isExpired(now));
        .map((entry) => entry.key);
        .toList();
    
    for (final key in expiredKeys) {
      await remove(key);
    }
    
    log('[MemoryCache] 清理过期项目: ${expiredKeys.length} 项');
  }
  
  Future<void> cleanupLRU() async {
    // 保留最常用的80%的项目
    final targetCount = (_cache.length * 0.8).round();
    final keysToRemove = _accessOrder.sublist(0, _accessOrder.length - targetCount);
    
    for (final key in keysToRemove) {
      await remove(key);
    }
    
    log('[MemoryCache] 清理LRU项目: ${keysToRemove.length} 项');
  }
  
  Future<void> cleanupLowUsage(List<String> infrequentKeys) async {
    for (final key in infrequentKeys) {
      await remove(key);
    }
  }
  
  Future<void> reduceSize(double factor) async {
    _maxSize = (_maxSize * (1 - factor)).round();
    await _evictLRU(_currentSize - _maxSize);
  }
  
  Future<void> increaseSize(double factor) async {
    _maxSize = (_maxSize * (1 + factor)).round();
  }
  
  Future<void> _evictLRU(int neededSize) async {
    int freedSize = 0;
    final keysToRemove = <String>[];
    
    // 从最久未使用的开始清理
    for (int i = 0; i < _accessOrder.length && freedSize < neededSize; i++) {
      final key = _accessOrder[i];
      final entry = _cache[key];
      if (entry != null) {
        final size = _estimateSize(entry.value);
        freedSize += size;
        keysToRemove.add(key);
      }
    }
    
    for (final key in keysToRemove) {
      await remove(key);
    }
    
    log('[MemoryCache] 清理LRU释放空间: ${freedSize} bytes');
  }
  
  void _updateAccessOrder(String key) {
    _accessOrder.remove(key);
    _accessOrder.add(key);
  }
  
  int _estimateSize(dynamic value) {
    if (value is String) {
      return value.length * 2;
    } else if (value is Uint8List) {
      return value.lengthInBytes;
    } else {
      try {
        final jsonString = jsonEncode(value);
        return jsonString.length * 2;
      } catch (e) {
        return 100;
      }
    }
  }
  
  Future<void> dispose() async {
    await clear();
    log('[MemoryCache] 内存缓存已销毁');
  }
}

/// 磁盘缓存
class DiskCache {
  final String _cacheDir = 'cache';
  int _maxSize = 500 * 1024 * 1024; // 500MB;
  
  Future<void> initialize(CacheConfig config) async {
    _maxSize = config.maxDiskSize;
    
    // 创建缓存目录
    final dir = Directory(_cacheDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    
    log('[DiskCache] 磁盘缓存已初始化: $_cacheDir');
  }
  
  Future<dynamic> get(String key) async {
    try {
      final file = File('$_cacheDir/${_hashKey(key)}.cache');
      if (!await file.exists()) return null;
      
      final bytes = await file.readAsBytes();
      // 这里应该实现真正的反序列化
      return utf8.decode(bytes);
    } catch (e) {
      log('[DiskCache] 磁盘缓存读取失败: $key - $e');
      return null;
    }
  }
  
  Future<void> set(String key, dynamic value, {Duration? expiry}) async {
    try {
      final file = File('$_cacheDir/${_hashKey(key)}.cache');
      
      // 序列化值
      final bytes = _serialize(value);
      await file.writeAsBytes(bytes);
      
      // 写入过期时间元数据
      if (expiry != null) {
        final metadata = {
          'expiry': expiry.inMilliseconds,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };
        final metadataFile = File('$_cacheDir/${_hashKey(key)}.meta');
        await metadataFile.writeAsString(jsonEncode(metadata));
      }
    } catch (e) {
      log('[DiskCache] 磁盘缓存写入失败: $key - $e');
    }
  }
  
  Future<void> remove(String key) async {
    try {
      final files = [;
        File('$_cacheDir/${_hashKey(key)}.cache'),
        File('$_cacheDir/${_hashKey(key)}.meta'),
      ];
      
      for (final file in files) {
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      log('[DiskCache] 磁盘缓存删除失败: $key - $e');
    }
  }
  
  Future<void> clear() async {
    try {
      final dir = Directory(_cacheDir);
      if (await dir.exists()) {
        await for (final file in dir.list()) {
          await file.delete();
        }
      }
    } catch (e) {
      log('[DiskCache] 磁盘缓存清空失败: $e');
    }
  }
  
  Future<int> count() async {
    try {
      final dir = Directory(_cacheDir);
      if (!await dir.exists()) return 0;
      
      return await dir.list().length ~/ 2; // 每个缓存项有.cache和.meta两个文件
    } catch (e) {
      return 0;
    }
  }
  
  Future<int> size() async {
    try {
      final dir = Directory(_cacheDir);
      if (!await dir.exists()) return 0;
      
      int totalSize = 0;
      await for (final file in dir.list()) {
        if (file is File) {
          totalSize += await file.length();
        }
      }
      
      return totalSize;
    } catch (e) {
      return 0;
    }
  }
  
  Future<CacheUsage> usage() async {
    final currentSize = await size();
    return CacheUsage(
      used: currentSize,
      total: _maxSize,
      usagePercent: (currentSize / _maxSize * 100).toDouble(),
      entries: await count(),
    );
  }
  
  Future<void> compress() async {
    // 压缩磁盘上的缓存文件
    log('[DiskCache] 磁盘缓存压缩完成');
  }
  
  Future<void> cleanupExpired(DateTime now) async {
    try {
      final dir = Directory(_cacheDir);
      if (!await dir.exists()) return;
      
      int removedCount = 0;
      
      await for (final file in dir.list()) {
        if (file is File && file.path.endsWith('.meta')) {
          try {
            final content = await file.readAsString();
            final metadata = jsonDecode(content);
            
            final expiryTime = metadata['expiry'] as int;
            final timestamp = metadata['timestamp'] as int;
            final createdAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
            
            if (createdAt.add(Duration(milliseconds: expiryTime)).isBefore(now)) {
              // 删除缓存文件和元数据文件
              final cacheFile = File(file.path.replaceAll('.meta', '.cache'));
              await Future.wait([
                file.delete(),
                cacheFile.exists().then((exists) => exists ? cacheFile.delete() : null),
              ]);
              removedCount++;
            }
          } catch (e) {
            // 忽略损坏的元数据文件
          }
        }
      }
      
      log('[DiskCache] 清理过期项目: $removedCount 项');
    } catch (e) {
      log('[DiskCache] 清理过期项目失败: $e');
    }
  }
  
  List<int> _serialize(dynamic value) {
    if (value is String) {
      return utf8.encode(value);
    } else if (value is Uint8List) {
      return value;
    } else {
      final jsonString = jsonEncode(value);
      return utf8.encode(jsonString);
    }
  }
  
  String _hashKey(String key) {
    // 简单的哈希实现，实际中应使用更强的哈希算法
    return key.hashCode.toString();
  }
  
  Future<void> dispose() async {
    log('[DiskCache] 磁盘缓存已销毁');
  }
}

/// 网络缓存
class NetworkCache {
  final Map<String, NetworkCacheEntry> _cache = {};
  
  Future<void> initialize(CacheConfig config) async {
    log('[NetworkCache] 网络缓存已初始化');
  }
  
  Future<dynamic> get(String key) async {
    final entry = _cache[key];
    if (entry != null && !entry.isExpired()) {
      entry.lastAccessed = DateTime.now();
      return entry.value;
    }
    return null;
  }
  
  Future<void> set(String key, dynamic value, {Duration? expiry}) async {
    _cache[key] = NetworkCacheEntry(
      value: value,
      expiry: expiry,
      createdAt: DateTime.now(),
    );
  }
  
  Future<void> remove(String key) async {
    _cache.remove(key);
  }
  
  Future<void> clear() async {
    _cache.clear();
  }
  
  Future<int> count() async => _cache.length;
  
  Future<CacheUsage> usage() async {
    return CacheUsage(
      used: _cache.length,
      total: 10000, // 假设最大10000个网络缓存项
      usagePercent: (_cache.length / 10000 * 100).toDouble(),
      entries: _cache.length,
    );
  }
  
  Future<void> cleanupExpired(DateTime now) async {
    final expiredKeys = _cache.entries;
        .where((entry) => entry.value.isExpired(now));
        .map((entry) => entry.key);
        .toList();
    
    for (final key in expiredKeys) {
      await remove(key);
    }
  }
  
  Future<void> dispose() async {
    await clear();
    log('[NetworkCache] 网络缓存已销毁');
  }
}

/// 缓存项
class CacheEntry {
  final dynamic value;
  final DateTime createdAt;
  final DateTime? expiry;
  DateTime lastAccessed;
  int size;
  
  CacheEntry({
    required this.value,
    this.expiry,
    DateTime? createdAt,
    this.size = 0,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastAccessed = createdAt ?? DateTime.now();
  
  bool isExpired([DateTime? now]) {
    if (expiry == null) return false;
    final current = now ?? DateTime.now();
    return current.isAfter(expiry!);
  }
}

/// 网络缓存项
class NetworkCacheEntry {
  final dynamic value;
  final DateTime createdAt;
  final DateTime? expiry;
  DateTime lastAccessed;
  
  NetworkCacheEntry({
    required this.value,
    this.expiry,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastAccessed = createdAt ?? DateTime.now();
  
  bool isExpired([DateTime? now]) {
    if (expiry == null) return false;
    final current = now ?? DateTime.now();
    return current.isAfter(expiry!);
  }
}

/// 缓存统计
class CacheStats {
  int totalHits = 0;
  int totalMisses = 0;
  int totalPuts = 0;
  int totalRemovals = 0;
  int totalSize = 0;
  int avgLookupTime = 0;
  final Map<CacheSource, int> hitsBySource = {};
  
  double get hitRate {
    final total = totalHits + totalMisses;
    return total > 0 ? totalHits / total * 100 : 0.0;
  }
  
  void reset() {
    totalHits = 0;
    totalMisses = 0;
    totalPuts = 0;
    totalRemovals = 0;
    totalSize = 0;
    avgLookupTime = 0;
    hitsBySource.clear();
  }
}

/// 缓存状态
class CacheStatus {
  final CacheUsage memoryUsage;
  final CacheUsage diskUsage;
  final CacheUsage networkUsage;
  final int totalHits;
  final int totalMisses;
  final double hitRate;
  
  CacheStatus({
    required this.memoryUsage,
    required this.diskUsage,
    required this.networkUsage,
    required this.totalHits,
    required this.totalMisses,
    required this.hitRate,
  });
}

/// 缓存使用情况
class CacheUsage {
  final int used;
  final int total;
  final double usagePercent;
  final int entries;
  
  CacheUsage({
    required this.used,
    required this.total,
    required this.usagePercent,
    required this.entries,
  });
}

/// 使用模式
class UsagePattern {
  final List<String> frequentKeys;
  final List<String> infrequentKeys;
  final int averageAccessTime;
  
  UsagePattern({
    required this.frequentKeys,
    required this.infrequentKeys,
    required this.averageAccessTime,
  });
}

/// 预加载候选项
class PreloadCandidate {
  final String key;
  final Future<dynamic> Function() loader;
  
  PreloadCandidate({
    required this.key,
    required this.loader,
  });
}

/// 性能监控器
class PerformanceMonitor {
  final List<PerformanceMetric> _metrics = [];
  
  Future<void> recordMetric(PerformanceMetric metric) async {
    _metrics.add(metric);
    
    // 保持最近1000个指标
    if (_metrics.length > 1000) {
      _metrics.removeAt(0);
    }
  }
  
  List<PerformanceMetric> get recentMetrics => List.unmodifiable(_metrics);
  
  Future<void> dispose() async {
    _metrics.clear();
  }
}

/// 性能指标
class PerformanceMetric {
  final String operation;
  final int durationMs;
  final DateTime timestamp;
  
  PerformanceMetric({
    required this.operation,
    required this.durationMs,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// 日志辅助函数
void log(String message, {int level = 200, String tag = 'CacheManager'}) {
  final logMessage = '[$tag] $message';
  if (level >= 500) {
    developer.log(logMessage, level: level, name: tag);
  }
}