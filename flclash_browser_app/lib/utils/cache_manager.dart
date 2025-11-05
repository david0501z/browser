import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';

/// 缓存管理器
class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  // 内存缓存
  final LRUCache<String, CacheEntry> _memoryCache = LRUCache(
    maxSize: 50,
    maxSizeBytes: 50 * 1024 * 1024, // 50MB
  );
  
  // 磁盘缓存
  final Map<String, DiskCacheEntry> _diskCacheIndex = {};
  Directory? _cacheDirectory;
  
  // 配置
  CacheConfig? _config;
  Timer? _cleanupTimer;
  bool _isInitialized = false;

  // 统计信息
  int _memoryHits = 0;
  int _memoryMisses = 0;
  int _diskHits = 0;
  int _diskMisses = 0;

  /// 初始化缓存管理器
  Future<void> initialize({
    int maxCacheSize = 100 * 1024 * 1024, // 100MB
    int maxMemoryCache = 50 * 1024 * 1024, // 50MB
    Duration cleanupInterval = const Duration(minutes: 10),
  }) async {
    if (_isInitialized) return;
    
    _config = CacheConfig(
      maxCacheSize: maxCacheSize,
      maxMemoryCache: maxMemoryCache,
      cleanupInterval: cleanupInterval,
    );
    
    // 创建缓存目录
    await _createCacheDirectory();
    
    // 加载磁盘缓存索引
    await _loadDiskCacheIndex();
    
    // 启动清理定时器
    _startCleanupTimer();
    
    _isInitialized = true;
    log('缓存管理器初始化完成');
  }

  /// 创建缓存目录
  Future<void> _createCacheDirectory() async {
    try {
      final directory = await getTemporaryDirectory();
      _cacheDirectory = Directory('${directory.path}/browser_cache');
      
      if (!_cacheDirectory!.existsSync()) {
        await _cacheDirectory!.create(recursive: true);
      }
    } catch (e) {
      log('创建缓存目录失败: $e');
    }
  }

  /// 加载磁盘缓存索引
  Future<void> _loadDiskCacheIndex() async {
    if (_cacheDirectory == null) return;
    
    try {
      final files = await _cacheDirectory!.list().toList();
      
      for (final file in files) {
        if (file is File && file.path.endsWith('.cache')) {
          final metadata = await _loadCacheMetadata(file);
          if (metadata != null) {
            _diskCacheIndex[metadata.key] = metadata;
          }
        }
      }
    } catch (e) {
      log('加载磁盘缓存索引失败: $e');
    }
  }

  /// 加载缓存元数据
  Future<DiskCacheEntry?> _loadCacheMetadata(File file) async {
    try {
      final content = await file.readAsString();
      final data = json.decode(content) as Map<String, dynamic>;
      
      return DiskCacheEntry.fromJson(data);
    } catch (e) {
      // 删除损坏的缓存文件
      try {
        await file.delete();
      } catch (_) {}
      return null;
    }
  }

  /// 启动清理定时器
  void _startCleanupTimer() {
    _cleanupTimer = Timer.periodic(
      _config!.cleanupInterval,
      _performCleanup,
    );
  }

  /// 执行清理任务
  void _performCleanup(Timer timer) {
    _cleanupExpired();
    _cleanupDiskCache();
    _updateMemoryCacheSize();
  }

  /// 存储数据到缓存
  Future<bool> put(String key, dynamic data, {
    Duration? ttl,
    CacheType type = CacheType.data,
  }) async {
    if (!_isInitialized) return false;
    
    try {
      final entry = CacheEntry(
        data: data,
        timestamp: DateTime.now(),
        ttl: ttl,
        type: type,
        size: _calculateSize(data),
      );
      
      // 存储到内存缓存
      _memoryCache.put(key, entry);
      
      // 如果数据较大，同时存储到磁盘
      if (entry.size > 1024 * 1024) { // 1MB
        await _putToDisk(key, entry);
      }
      
      return true;
    } catch (e) {
      log('存储缓存失败: $e');
      return false;
    }
  }

  /// 从缓存获取数据
  Future<T?> get<T>(String key) async {
    if (!_isInitialized) return null;
    
    // 首先尝试从内存缓存获取
    final memoryEntry = _memoryCache.get(key);
    if (memoryEntry != null) {
      if (_isEntryValid(memoryEntry)) {
        _memoryHits++;
        return memoryEntry.data as T;
      } else {
        _memoryCache.remove(key);
      }
    }
    
    _memoryMisses++;
    
    // 从磁盘缓存获取
    final diskEntry = await _getFromDisk(key);
    if (diskEntry != null) {
      _diskHits++;
      
      // 将数据放回内存缓存
      _memoryCache.put(key, diskEntry);
      return diskEntry.data as T;
    }
    
    _diskMisses++;
    return null;
  }

  /// 存储到磁盘缓存
  Future<void> _putToDisk(String key, CacheEntry entry) async {
    if (_cacheDirectory == null) return;
    
    try {
      final fileName = '${key.hashCode}.cache';
      final file = File('${_cacheDirectory!.path}/$fileName');
      
      final metadata = DiskCacheEntry(
        key: key,
        fileName: fileName,
        timestamp: entry.timestamp,
        ttl: entry.ttl,
        size: entry.size,
        type: entry.type,
      );
      
      // 存储数据文件
      if (entry.data is String) {
        await file.writeAsString(entry.data);
      } else if (entry.data is Uint8List) {
        await file.writeAsBytes(entry.data);
      } else {
        final jsonData = json.encode(entry.data);
        await file.writeAsString(jsonData);
      }
      
      // 存储元数据
      final metadataFile = File('${_cacheDirectory!.path}/${fileName}.meta');
      await metadataFile.writeAsString(json.encode(metadata.toJson()));
      
      // 更新索引
      _diskCacheIndex[key] = metadata;
      
    } catch (e) {
      log('存储磁盘缓存失败: $e');
    }
  }

  /// 从磁盘缓存获取
  Future<CacheEntry?> _getFromDisk(String key) async {
    if (_cacheDirectory == null) return null;
    
    final metadata = _diskCacheIndex[key];
    if (metadata == null) return null;
    
    try {
      final file = File('${_cacheDirectory!.path}/${metadata.fileName}');
      if (!file.existsSync()) {
        _diskCacheIndex.remove(key);
        return null;
      }
      
      dynamic data;
      if (metadata.type == CacheType.string) {
        data = await file.readAsString();
      } else if (metadata.type == CacheType.binary) {
        data = await file.readAsBytes();
      } else {
        final content = await file.readAsString();
        data = json.decode(content);
      }
      
      return CacheEntry(
        data: data,
        timestamp: metadata.timestamp,
        ttl: metadata.ttl,
        type: metadata.type,
        size: metadata.size,
      );
      
    } catch (e) {
      log('读取磁盘缓存失败: $e');
      _diskCacheIndex.remove(key);
      return null;
    }
  }

  /// 检查缓存条目是否有效
  bool _isEntryValid(CacheEntry entry) {
    if (entry.ttl == null) return true;
    final age = DateTime.now().difference(entry.timestamp);
    return age < entry.ttl!;
  }

  /// 计算数据大小
  int _calculateSize(dynamic data) {
    if (data is String) {
      return data.length * 2; // UTF-16
    } else if (data is Uint8List) {
      return data.length;
    } else if (data is Map || data is List) {
      return json.encode(data).length * 2;
    }
    return 100; // 默认大小
  }

  /// 清理过期的缓存
  void _cleanupExpired() {
    // 清理内存缓存
    final expiredKeys = <String>[];
    _memoryCache.forEach((key, entry) {
      if (!_isEntryValid(entry)) {
        expiredKeys.add(key);
      }
    });
    
    for (final key in expiredKeys) {
      _memoryCache.remove(key);
    }
    
    // 清理磁盘缓存
    final expiredDiskKeys = <String>[];
    _diskCacheIndex.forEach((key, metadata) {
      if (metadata.ttl != null) {
        final age = DateTime.now().difference(metadata.timestamp);
        if (age >= metadata.ttl!) {
          expiredDiskKeys.add(key);
        }
      }
    });
    
    for (final key in expiredDiskKeys) {
      _removeDiskEntry(key);
    }
  }

  /// 清理磁盘缓存
  void _cleanupDiskCache() {
    if (_cacheDirectory == null) return;
    
    // 计算当前磁盘缓存大小
    int totalSize = 0;
    for (final metadata in _diskCacheIndex.values) {
      totalSize += metadata.size;
    }
    
    // 如果超过限制，删除最旧的条目
    if (totalSize > _config!.maxCacheSize) {
      final sortedEntries = _diskCacheIndex.values
          .sorted((a, b) => a.timestamp.compareTo(b.timestamp));
      
      int removedSize = 0;
      for (final entry in sortedEntries) {
        if (totalSize - removedSize <= _config!.maxCacheSize) break;
        
        _removeDiskEntry(entry.key);
        removedSize += entry.size;
      }
    }
  }

  /// 更新内存缓存大小
  void _updateMemoryCacheSize() {
    final currentSize = _memoryCache.length;
    if (currentSize > _config!.maxMemoryCache ~/ (1024 * 1024)) {
      // 调整LRU缓存大小
      _memoryCache.evictLRU();
    }
  }

  /// 移除磁盘条目
  void _removeDiskEntry(String key) {
    final metadata = _diskCacheIndex[key];
    if (metadata != null) {
      try {
        final file = File('${_cacheDirectory!.path}/${metadata.fileName}');
        final metadataFile = File('${_cacheDirectory!.path}/${metadata.fileName}.meta');
        
        file.deleteSync();
        metadataFile.deleteSync();
      } catch (e) {
        log('删除磁盘缓存失败: $e');
      }
      
      _diskCacheIndex.remove(key);
    }
  }

  /// 清理最旧的条目
  void clearOldestEntries() {
    // 清理内存缓存
    _memoryCache.clear();
    
    // 清理磁盘缓存
    for (final key in _diskCacheIndex.keys) {
      _removeDiskEntry(key);
    }
  }

  /// 获取缓存统计信息
  CacheStats getCacheStats() {
    int totalDiskSize = 0;
    for (final metadata in _diskCacheIndex.values) {
      totalDiskSize += metadata.size;
    }
    
    return CacheStats(
      memoryEntries: _memoryCache.length,
      diskEntries: _diskCacheIndex.length,
      memorySizeBytes: _calculateMemorySize(),
      diskSizeBytes: totalDiskSize,
      memoryHitRate: _memoryHits + _memoryMisses > 0 
          ? _memoryHits / (_memoryHits + _memoryMisses) 
          : 0.0,
      diskHitRate: _diskHits + _diskMisses > 0 
          ? _diskHits / (_diskHits + _diskMisses) 
          : 0.0,
      totalHits: _memoryHits + _diskHits,
      totalMisses: _memoryMisses + _diskMisses,
    );
  }

  /// 计算内存缓存大小
  int _calculateMemorySize() {
    int totalSize = 0;
    _memoryCache.forEach((key, entry) {
      totalSize += entry.size;
    });
    return totalSize;
  }

  /// 移除指定键的缓存
  Future<void> remove(String key) async {
    _memoryCache.remove(key);
    _removeDiskEntry(key);
  }

  /// 清空所有缓存
  Future<void> clear() async {
    _memoryCache.clear();
    
    for (final key in _diskCacheIndex.keys) {
      await _removeDiskEntry(key);
    }
  }

  /// 预热缓存
  Future<void> warmupCache(List<String> keys) async {
    for (final key in keys) {
      await get(key); // 触发缓存加载
    }
  }

  /// 清理所有资源
  void dispose() {
    _cleanupTimer?.cancel();
    _memoryCache.clear();
    _diskCacheIndex.clear();
    _isInitialized = false;
  }
}

/// LRU缓存实现
class LRUCache<K, V> {
  final int maxSize;
  final int maxSizeBytes;
  final Map<K, V> _cache = {};
  final Map<K, int> _sizes = {};
  final List<K> _accessOrder = [];
  int _currentSizeBytes = 0;

  LRUCache({
    required this.maxSize,
    required this.maxSizeBytes,
  });

  int get length => _cache.length;

  void put(K key, V value) {
    final size = _calculateSize(value);
    
    // 如果已存在，先移除旧值
    if (_cache.containsKey(key)) {
      _currentSizeBytes -= _sizes[key] ?? 0;
      _cache.remove(key);
      _sizes.remove(key);
      _accessOrder.remove(key);
    }
    
    // 如果超出大小限制，移除最旧的条目
    while ((_cache.length >= maxSize || _currentSizeBytes + size > maxSizeBytes) && 
           _cache.isNotEmpty) {
      _evictOldest();
    }
    
    _cache[key] = value;
    _sizes[key] = size;
    _currentSizeBytes += size;
    _accessOrder.add(key);
  }

  V? get(K key) {
    final value = _cache[key];
    if (value != null) {
      // 更新访问顺序
      _accessOrder.remove(key);
      _accessOrder.add(key);
    }
    return value;
  }

  void remove(K key) {
    if (_cache.containsKey(key)) {
      _currentSizeBytes -= _sizes[key] ?? 0;
      _cache.remove(key);
      _sizes.remove(key);
      _accessOrder.remove(key);
    }
  }

  void clear() {
    _cache.clear();
    _sizes.clear();
    _accessOrder.clear();
    _currentSizeBytes = 0;
  }

  void forEach(void Function(K key, V value) f) {
    _cache.forEach(f);
  }

  void _evictOldest() {
    if (_accessOrder.isEmpty) return;
    
    final oldestKey = _accessOrder.removeAt(0);
    _currentSizeBytes -= _sizes[oldestKey] ?? 0;
    _cache.remove(oldestKey);
    _sizes.remove(oldestKey);
  }

  void evictLRU() {
    if (_accessOrder.isNotEmpty) {
      final lruKey = _accessOrder.removeAt(0);
      _currentSizeBytes -= _sizes[lruKey] ?? 0;
      _cache.remove(lruKey);
      _sizes.remove(lruKey);
    }
  }

  int _calculateSize(V value) {
    if (value is String) {
      return value.length * 2;
    } else if (value is Uint8List) {
      return value.length;
    } else if (value is Map || value is List) {
      return json.encode(value).length * 2;
    }
    return 100;
  }
}

/// 缓存条目
class CacheEntry {
  final dynamic data;
  final DateTime timestamp;
  final Duration? ttl;
  final CacheType type;
  final int size;

  CacheEntry({
    required this.data,
    required this.timestamp,
    this.ttl,
    required this.type,
    required this.size,
  });
}

/// 磁盘缓存条目
class DiskCacheEntry {
  final String key;
  final String fileName;
  final DateTime timestamp;
  final Duration? ttl;
  final int size;
  final CacheType type;

  DiskCacheEntry({
    required this.key,
    required this.fileName,
    required this.timestamp,
    this.ttl,
    required this.size,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'file_name': fileName,
      'timestamp': timestamp.toIso8601String(),
      'ttl': ttl?.inMilliseconds,
      'size': size,
      'type': type.toString(),
    };
  }

  factory DiskCacheEntry.fromJson(Map<String, dynamic> json) {
    return DiskCacheEntry(
      key: json['key'],
      fileName: json['file_name'],
      timestamp: DateTime.parse(json['timestamp']),
      ttl: json['ttl'] != null ? Duration(milliseconds: json['ttl']) : null,
      size: json['size'],
      type: CacheType.values.firstWhere(
        (t) => t.toString() == json['type'],
        orElse: () => CacheType.data,
      ),
    );
  }
}

/// 缓存类型
enum CacheType {
  string,
  binary,
  json,
  data,
}

/// 缓存统计
class CacheStats {
  final int memoryEntries;
  final int diskEntries;
  final int memorySizeBytes;
  final int diskSizeBytes;
  final double memoryHitRate;
  final double diskHitRate;
  final int totalHits;
  final int totalMisses;

  CacheStats({
    required this.memoryEntries,
    required this.diskEntries,
    required this.memorySizeBytes,
    required this.diskSizeBytes,
    required this.memoryHitRate,
    required this.diskHitRate,
    required this.totalHits,
    required this.totalMisses,
  });

  Map<String, dynamic> toMap() {
    return {
      'memory_entries': memoryEntries,
      'disk_entries': diskEntries,
      'memory_size_bytes': memorySizeBytes,
      'disk_size_bytes': diskSizeBytes,
      'memory_hit_rate': memoryHitRate,
      'disk_hit_rate': diskHitRate,
      'total_hits': totalHits,
      'total_misses': totalMisses,
    };
  }
}

/// 缓存配置
class CacheConfig {
  final int maxCacheSize;
  final int maxMemoryCache;
  final Duration cleanupInterval;

  CacheConfig({
    required this.maxCacheSize,
    required this.maxMemoryCache,
    required this.cleanupInterval,
  });
}