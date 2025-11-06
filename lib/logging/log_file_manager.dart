import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'logger.dart';

/// 日志文件管理配置
class LogFileManagerConfig {
  /// 日志目录路径
  final String logDirectory;
  
  /// 最大文件大小（字节）
  final int maxFileSize;
  
  /// 最大文件数量
  final int maxFileCount;
  
  /// 日志文件保留天数
  final int maxRetentionDays;
  
  /// 是否启用压缩
  final bool enableCompression;
  
  /// 压缩级别（0-9）
  final int compressionLevel;
  
  /// 自动清理间隔
  final Duration cleanupInterval;
  
  /// 清理时保留的最小磁盘空间（字节）
  final int minFreeSpace;

  const LogFileManagerConfig({
    required this.logDirectory,
    this.maxFileSize = 10 * 1024 * 1024, // 10MB
    this.maxFileCount = 50,
    this.maxRetentionDays = 30,
    this.enableCompression = false,
    this.compressionLevel = 6,
    this.cleanupInterval = const Duration(hours: 1),
    this.minFreeSpace = 100 * 1024 * 1024, // 100MB
  });
}

/// 日志文件信息
class LogFileInfo {
  /// 文件路径
  final String path;
  
  /// 文件名
  final String name;
  
  /// 文件大小（字节）
  final int size;
  
  /// 创建时间
  final DateTime createdTime;
  
  /// 修改时间
  final DateTime modifiedTime;
  
  /// 是否已压缩
  final bool isCompressed;

  const LogFileInfo({
    required this.path,
    required this.name,
    required this.size,
    required this.createdTime,
    required this.modifiedTime,
    this.isCompressed = false,
  });

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'name': name,
      'size': size,
      'createdTime': createdTime.toIso8601String(),
      'modifiedTime': modifiedTime.toIso8601String(),
      'isCompressed': isCompressed,
    };
  }

  /// 从JSON创建
  factory LogFileInfo.fromJson(Map<String, dynamic> json) {
    return LogFileInfo(
      path: json['path'] as String,
      name: json['name'] as String,
      size: json['size'] as int,
      createdTime: DateTime.parse(json['createdTime'] as String),
      modifiedTime: DateTime.parse(json['modifiedTime'] as String),
      isCompressed: json['isCompressed'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'LogFileInfo{name: $name, size: $size bytes, modified: $modifiedTime, compressed: $isCompressed}';
  }
}

/// 日志文件管理器
/// 负责日志文件的生命周期管理、清理、压缩等操作
class LogFileManager {
  final LogFileManagerConfig _config;
  final Logger _logger = Logger();
  Timer? _cleanupTimer;
  
  /// 获取所有日志文件信息
  List<LogFileInfo> _logFiles = [];

  LogFileManager(this._config) {
    _initialize();
  }

  /// 初始化日志文件管理器
  void _initialize() {
    _createLogDirectory();
    _startCleanupTimer();
    _loadLogFiles();
  }

  /// 创建日志目录
  void _createLogDirectory() {
    final directory = Directory(_config.logDirectory);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
      _logger.info('创建日志目录: ${_config.logDirectory}', source: 'LogFileManager');
    }
  }

  /// 启动清理定时器
  void _startCleanupTimer() {
    _cleanupTimer = Timer.periodic(_config.cleanupInterval, (_) {
      performCleanup();
    });
  }

  /// 加载现有日志文件信息
  void _loadLogFiles() {
    try {
      final directory = Directory(_config.logDirectory);
      final files = directory.listSync()
          .where((entity) => entity is File)
          .cast<File>()
          .toList();

      _logFiles = files.map((file) {
        final stat = file.statSync();
        return LogFileInfo(
          path: file.path,
          name: file.uri.pathSegments.last,
          size: stat.size,
          createdTime: stat.changed,
          modifiedTime: stat.modified,
          isCompressed: file.path.endsWith('.gz') || file.path.endsWith('.zip'),
        );
      }).toList();

      _logFiles.sort((a, b) => b.modifiedTime.compareTo(a.modifiedTime));
      
      _logger.debug('加载了 ${_logFiles.length} 个日志文件', source: 'LogFileManager');
    } catch (e) {
      _logger.error('加载日志文件列表失败', exception: e, source: 'LogFileManager');
    }
  }

  /// 重新加载日志文件信息
  void reloadFiles() {
    _loadLogFiles();
  }

  /// 获取所有日志文件信息
  List<LogFileInfo> getAllLogFiles() {
    return List.unmodifiable(_logFiles);
  }

  /// 获取特定日期的日志文件
  List<LogFileInfo> getLogFilesByDate(DateTime date) {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    return _logFiles.where((file) {
      return file.name.contains(dateStr);
    }).toList();
  }

  /// 获取指定时间范围的日志文件
  List<LogFileInfo> getLogFilesByTimeRange(DateTime start, DateTime end) {
    return _logFiles.where((file) {
      return file.modifiedTime.isAfter(start) && file.modifiedTime.isBefore(end);
    }).toList();
  }

  /// 获取文件总大小
  int getTotalSize() {
    return _logFiles.fold(0, (sum, file) => sum + file.size);
  }

  /// 获取可用磁盘空间
  Future<int> getFreeSpace() async {
    try {
      final stat = await Directory(_config.logDirectory).stat();
      // 这里应该获取系统磁盘空间，简化处理
      return 1024 * 1024 * 1024; // 假设1GB可用空间
    } catch (e) {
      _logger.warning('获取磁盘空间失败', exception: e, source: 'LogFileManager');
      return 0;
    }
  }

  /// 检查是否需要进行清理
  bool shouldCleanup() {
    final fileCount = _logFiles.length;
    final totalSize = getTotalSize();
    
    return fileCount > _config.maxFileCount ||
           totalSize > _config.maxFileSize * _config.maxFileCount ||
           _hasOldFiles();
  }

  /// 检查是否有过期文件
  bool _hasOldFiles() {
    final cutoffDate = DateTime.now().subtract(Duration(days: _config.maxRetentionDays));
    return _logFiles.any((file) => file.modifiedTime.isBefore(cutoffDate));
  }

  /// 执行清理操作
  Future<void> performCleanup() async {
    _logger.info('开始执行日志文件清理', source: 'LogFileManager');

    try {
      final actions = <String>[];
      
      // 1. 清理过期文件
      final expiredFiles = _getExpiredFiles();
      if (expiredFiles.isNotEmpty) {
        await _deleteFiles(expiredFiles);
        actions.add('删除了 ${expiredFiles.length} 个过期文件');
      }

      // 2. 压缩旧文件
      if (_config.enableCompression) {
        final compressibleFiles = _getCompressibleFiles();
        if (compressibleFiles.isNotEmpty) {
          await _compressFiles(compressibleFiles);
          actions.add('压缩了 ${compressibleFiles.length} 个文件');
        }
      }

      // 3. 如果文件数量仍然过多，删除最旧的文件
      if (_logFiles.length > _config.maxFileCount) {
        final excessFiles = _getExcessFiles();
        await _deleteFiles(excessFiles);
        actions.add('删除了 ${excessFiles.length} 个多余文件');
      }

      // 4. 清理磁盘空间不足的情况
      await _cleanupIfDiskFull();

      // 重新加载文件列表
      _loadLogFiles();

      if (actions.isNotEmpty) {
        _logger.info('日志清理完成: ${actions.join(', ')}', source: 'LogFileManager');
      }
    } catch (e) {
      _logger.error('日志清理失败', exception: e, source: 'LogFileManager');
    }
  }

  /// 获取过期文件列表
  List<LogFileInfo> _getExpiredFiles() {
    final cutoffDate = DateTime.now().subtract(Duration(days: _config.maxRetentionDays));
    return _logFiles.where((file) => file.modifiedTime.isBefore(cutoffDate)).toList();
  }

  /// 获取可压缩的文件列表
  List<LogFileInfo> _getCompressibleFiles() {
    final cutoffDate = DateTime.now().subtract(Duration(days: 1));
    return _logFiles.where((file) => 
        !file.isCompressed && 
        file.modifiedTime.isBefore(cutoffDate) &&
        file.size > 1024 * 1024 // 大于1MB才压缩
    ).toList();
  }

  /// 获取多余文件列表（超出数量限制的文件）
  List<LogFileInfo> _getExcessFiles() {
    final sortedFiles = List<LogFileInfo>.from(_logFiles);
    sortedFiles.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime)); // 按时间升序
    
    final excessCount = sortedFiles.length - _config.maxFileCount;
    if (excessCount > 0) {
      return sortedFiles.take(excessCount).toList();
    }
    
    return [];
  }

  /// 删除文件
  Future<void> _deleteFiles(List<LogFileInfo> files) async {
    for (final fileInfo in files) {
      try {
        final file = File(fileInfo.path);
        if (await file.exists()) {
          await file.delete();
          _logger.debug('删除日志文件: ${fileInfo.name}', source: 'LogFileManager');
        }
      } catch (e) {
        _logger.warning('删除日志文件失败: ${fileInfo.name}', exception: e, source: 'LogFileManager');
      }
    }
  }

  /// 压缩文件（简化实现，实际应该使用gzip等压缩）
  Future<void> _compressFiles(List<LogFileInfo> files) async {
    for (final fileInfo in files) {
      try {
        final sourceFile = File(fileInfo.path);
        final targetFile = File('${fileInfo.path}.gz');
        
        if (await sourceFile.exists()) {
          final sourceBytes = await sourceFile.readAsBytes();
          // 这里简化处理，实际应该使用gzip压缩
          await targetFile.writeAsBytes(sourceBytes);
          await sourceFile.delete();
          
          _logger.debug('压缩日志文件: ${fileInfo.name}', source: 'LogFileManager');
        }
      } catch (e) {
        _logger.warning('压缩日志文件失败: ${fileInfo.name}', exception: e, source: 'LogFileManager');
      }
    }
  }

  /// 磁盘空间不足时的清理
  Future<void> _cleanupIfDiskFull() async {
    final freeSpace = await getFreeSpace();
    if (freeSpace < _config.minFreeSpace) {
      _logger.warning('磁盘空间不足，开始紧急清理', 
          context: {'freeSpace': freeSpace, 'minRequired': _config.minFreeSpace}, 
          source: 'LogFileManager');

      // 删除最旧的一半文件
      final sortedFiles = List<LogFileInfo>.from(_logFiles);
      sortedFiles.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
      
      final emergencyDeleteCount = (sortedFiles.length / 2).ceil();
      final filesToDelete = sortedFiles.take(emergencyDeleteCount).toList();
      
      await _deleteFiles(filesToDelete);
      _logger.info('紧急清理完成，删除了 ${filesToDelete.length} 个文件', source: 'LogFileManager');
    }
  }

  /// 导出指定日期范围的日志
  Future<String> exportLogs(DateTime start, DateTime end, {String? outputPath}) async {
    final files = getLogFilesByTimeRange(start, end);
    if (files.isEmpty) {
      throw Exception('指定时间范围内没有找到日志文件');
    }

    final buffer = StringBuffer();
    buffer.writeln('# 日志导出 - ${start.toIso8601String()} 到 ${end.toIso8601String()}');
    buffer.writeln('# 导出时间: ${DateTime.now().toIso8601String()}');
    buffer.writeln('# 文件数量: ${files.length}');
    buffer.writeln();

    for (final fileInfo in files) {
      try {
        final file = File(fileInfo.path);
        if (await file.exists()) {
          final content = await file.readAsString();
          buffer.writeln('=== 文件: ${fileInfo.name} ===');
          buffer.writeln(content);
          buffer.writeln();
        }
      } catch (e) {
        _logger.warning('读取日志文件失败: ${fileInfo.name}', exception: e, source: 'LogFileManager');
      }
    }

    final exportContent = buffer.toString();
    
    if (outputPath != null) {
      final outputFile = File(outputPath);
      await outputFile.writeAsString(exportContent);
      _logger.info('日志导出完成: $outputPath', source: 'LogFileManager');
    }

    return exportContent;
  }

  /// 搜索日志内容
  Future<List<String>> searchInLogs(String query, {DateTime? start, DateTime? end}) async {
    final results = <String>[];
    final searchStart = start ?? DateTime.now().subtract(Duration(days: 7));
    final searchEnd = end ?? DateTime.now();
    
    final files = getLogFilesByTimeRange(searchStart, searchEnd);
    
    for (final fileInfo in files) {
      try {
        final file = File(fileInfo.path);
        if (await file.exists()) {
          final lines = await file.readAsLines();
          for (final line in lines) {
            if (line.toLowerCase().contains(query.toLowerCase())) {
              results.add('${fileInfo.name}: $line');
            }
          }
        }
      } catch (e) {
        _logger.warning('搜索日志文件失败: ${fileInfo.name}', exception: e, source: 'LogFileManager');
      }
    }

    return results;
  }

  /// 获取日志目录统计信息
  Map<String, dynamic> getDirectoryStatistics() {
    final now = DateTime.now();
    final stats = <String, dynamic>{
      'totalFiles': _logFiles.length,
      'totalSize': getTotalSize(),
      'oldestFile': _logFiles.isNotEmpty ? _logFiles.last.modifiedTime.toIso8601String() : null,
      'newestFile': _logFiles.isNotEmpty ? _logFiles.first.modifiedTime.toIso8601String() : null,
      'compressedFiles': _logFiles.where((f) => f.isCompressed).length,
      'oldFilesCount': _getExpiredFiles().length,
      'diskSpaceRequired': _config.maxFileCount * _config.maxFileSize,
    };

    // 按大小分组
    final sizeGroups = <String, int>{
      '小于1MB': 0,
      '1MB-10MB': 0,
      '10MB-100MB': 0,
      '大于100MB': 0,
    };

    for (final file in _logFiles) {
      final sizeMB = file.size / (1024 * 1024);
      if (sizeMB < 1) {
        sizeGroups['小于1MB'] = sizeGroups['小于1MB']! + 1;
      } else if (sizeMB < 10) {
        sizeGroups['1MB-10MB'] = sizeGroups['1MB-10MB']! + 1;
      } else if (sizeMB < 100) {
        sizeGroups['10MB-100MB'] = sizeGroups['10MB-100MB']! + 1;
      } else {
        sizeGroups['大于100MB'] = sizeGroups['大于100MB']! + 1;
      }
    }

    stats['sizeGroups'] = sizeGroups;
    
    return stats;
  }

  /// 关闭文件管理器
  void dispose() {
    _cleanupTimer?.cancel();
    _logger.info('日志文件管理器已关闭', source: 'LogFileManager');
  }
}