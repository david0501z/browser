import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'log_entry.dart';

/// 日志输出器接口
abstract class LogSink {
  /// 写入日志
  void write(LogEntry entry, String formattedMessage);

  /// 刷新输出（确保所有数据都已输出）
  Future<void> flush();

  /// 关闭输出器
  Future<void> close();
}

/// 可释放的输出器接口
abstract class DisposableSink extends LogSink {
  /// 释放资源
  Future<void> dispose();
}

/// 控制台输出器
class ConsoleSink implements LogSink {
  @override
  void write(LogEntry entry, String formattedMessage) {
    print(formattedMessage);
  }

  @override
  Future<void> flush() async {
    // 控制台输出无需刷新
  }

  @override
  Future<void> close() async {
    // 控制台输出无需关闭
  }
}

/// 文件输出器
class FileSink implements DisposableSink {
  final String _filePath;
  final bool _append;
  final IOSink? _ioSink;
  final StreamController<String> _bufferController = StreamController<String>();
  final Timer? _flushTimer;
  final Duration _flushInterval;
  final int _maxBufferSize;

  FileSink({
    required String filePath,
    bool append = true,
    Duration flushInterval = const Duration(seconds: 1),
    int maxBufferSize = 1000,
  }) : 
    _filePath = filePath,
    _append = append,
    _flushInterval = flushInterval,
    _maxBufferSize = maxBufferSize,
    _ioSink = null {
    
    _initializeFileSink();
  }

  FileSink._withSink({
    required String filePath,
    bool append = true,
    Duration flushInterval = const Duration(seconds: 1),
    int maxBufferSize = 1000,
    required IOSink ioSink,
  }) : 
    _filePath = filePath,
    _append = append,
    _flushInterval = flushInterval,
    _maxBufferSize = maxBufferSize,
    _ioSink = ioSink,
    _flushTimer = null {
    
    _initializeBufferedSink();
  }

  /// 初始化文件输出器
  void _initializeFileSink() {
    try {
      final file = File(_filePath);
      final directory = file.parent;
      
      // 确保目录存在
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      
      final ioSink = file.openWrite(
        mode: _append ? FileMode.append : FileMode.write,
        encoding: utf8,
      );
      
      _flushTimer = Timer.periodic(_flushInterval, (_) {
        flush();
      });
      
      _initializeBufferedSinkWithSink(ioSink);
    } catch (e) {
      print('文件输出器初始化失败: $e');
    }
  }

  /// 初始化带IO sink的缓冲输出器
  void _initializeBufferedSink() {
    try {
      _flushTimer = Timer.periodic(_flushInterval, (_) {
        flush();
      });
      _initializeBufferedSinkWithSink(_ioSink!);
    } catch (e) {
      print('文件输出器初始化失败: $e');
    }
  }

  /// 初始化带IO sink的缓冲输出器
  void _initializeBufferedSinkWithSink(IOSink ioSink) {
    _bufferController.stream.listen(
      (String data) async {
        try {
          ioSink.writeln(data);
        } catch (e) {
          print('文件写入错误: $e');
        }
      },
      onError: (error) {
        print('文件输出器错误: $error');
      },
      onDone: () {
        ioSink.close();
      },
    );
  }

  @override
  void write(LogEntry entry, String formattedMessage) {
    if (_ioSink != null) {
      // 直接写入
      _ioSink!.writeln(formattedMessage);
    } else {
      // 缓冲写入
      _bufferController.add(formattedMessage);
      
      // 如果缓冲区满了，自动刷新
      if (_bufferController.hasListener) {
        // 这里可以实现缓冲区大小检查逻辑
      }
    }
  }

  @override
  Future<void> flush() async {
    if (_ioSink != null) {
      await _ioSink!.flush();
    }
    // 缓冲区会自动处理
  }

  @override
  Future<void> close() async {
    await flush();
    _flushTimer?.cancel();
    await _bufferController.close();
    await _ioSink?.close();
  }

  @override
  Future<void> dispose() async {
    await close();
  }
}

/// 滚动文件输出器
class RollingFileSink extends DisposableSink {
  final String _directoryPath;
  final String _fileNamePattern;
  final int _maxFileSize; // bytes
  final int _maxFiles;
  final Duration _flushInterval;
  final StreamController<String> _bufferController = StreamController<String>();
  Timer? _flushTimer;
  
  String _currentFileName = '';
  IOSink? _currentFileSink;

  RollingFileSink({
    required String directoryPath,
    String fileNamePattern = 'app_%d{yyyy-MM-dd}.log',
    int maxFileSize = 10 * 1024 * 1024, // 10MB;
    int maxFiles = 5,
    Duration flushInterval = const Duration(seconds: 1),
  }) : 
    _directoryPath = directoryPath,
    _fileNamePattern = fileNamePattern,
    _maxFileSize = maxFileSize,
    _maxFiles = maxFiles,
    _flushInterval = flushInterval {
    
    _initialize();
  }

  /// 初始化滚动文件输出器
  void _initialize() {
    final directory = Directory(_directoryPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    
    _setupCurrentFile();
    _setupFlushTimer();
    _setupBufferListener();
  }

  /// 设置当前文件
  void _setupCurrentFile() {
    final timestamp = DateTime.now();
    final fileName = _formatFileName(_fileNamePattern, timestamp);
    _currentFileName = fileName;
    
    final filePath = '$_directoryPath/$fileName';
    final file = File(filePath);
    
    if (_currentFileSink != null) {
      _currentFileSink!.close();
    }
    
    _currentFileSink = file.openWrite(
      mode: FileMode.append,
      encoding: utf8,
    );
  }

  /// 设置刷新定时器
  void _setupFlushTimer() {
    _flushTimer = Timer.periodic(_flushInterval, (_) {
      flush();
    });
  }

  /// 设置缓冲区监听器
  void _setupBufferListener() {
    _bufferController.stream.listen(
      _handleBufferData,
      onError: _handleBufferError,
      onDone: _handleBufferDone,
    );
  }

  /// 处理缓冲区数据
  Future<void> _handleBufferData(String data) async {
    try {
      // 检查是否需要滚动文件
      if (_shouldRollFile(data)) {
        await _rollFile();
      }
      
      if (_currentFileSink != null) {
        _currentFileSink!.writeln(data);
      }
    } catch (e) {
      print('滚动文件输出器写入错误: $e');
    }
  }

  /// 检查是否需要滚动文件
  bool _shouldRollFile(String newData) {
    if (_currentFileSink == null) return false;
    
    // 这里简化处理，实际应该检查文件大小
    return false;
  }

  /// 滚动文件
  Future<void> _rollFile() async {
    // 关闭当前文件
    await _currentFileSink?.close();
    _currentFileSink = null;
    
    // 重命名当前文件（添加序号）
    await _renameCurrentFile();
    
    // 创建新文件
    _setupCurrentFile();
    
    // 清理旧文件
    await _cleanupOldFiles();
  }

  /// 重命名当前文件
  Future<void> _renameCurrentFile() async {
    final directory = Directory(_directoryPath);
    final files = directory.listSync();
        .where((entity) => entity is File);
        .cast<File>()
        .toList();
    
    // 按修改时间排序
    files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    
    // 如果文件数量超过限制，重命名最旧的文件
    if (files.length >= _maxFiles) {
      final oldestFile = files.last;
      final newName = '${oldestFile.path}.old';
      await oldestFile.rename(newName);
    }
  }

  /// 清理旧文件
  Future<void> _cleanupOldFiles() async {
    final directory = Directory(_directoryPath);
    final files = directory.listSync();
        .where((entity) => entity is File);
        .cast<File>()
        .toList();
    
    // 按修改时间排序
    files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    
    // 删除超出限制的文件
    for (var i = _maxFiles; i < files.length; i++) {
      try {
        await files[i].delete();
      } catch (e) {
        print('删除旧日志文件失败: $e');
      }
    }
  }

  /// 处理缓冲区错误
  void _handleBufferError(error) {
    print('滚动文件输出器错误: $error');
  }

  /// 处理缓冲区完成
  void _handleBufferDone() {
    _currentFileSink?.close();
  }

  /// 格式化文件名
  String _formatFileName(String pattern, DateTime timestamp) {
    // 简单的文件名格式化，支持 %d{yyyy-MM-dd} 格式
    return pattern.replaceAllMapped(
      RegExp(r'%d\{([^}]+)\}'),
      (match) {
        final format = match.group(1);
        switch (format) {
          case 'yyyy-MM-dd':
            return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
          case 'yyyy-MM-dd-HH':
            return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}-${timestamp.hour.toString().padLeft(2, '0')}';
          default:
            return timestamp.toIso8601String();
        }
      },
    );
  }

  @override
  void write(LogEntry entry, String formattedMessage) {
    _bufferController.add(formattedMessage);
  }

  @override
  Future<void> flush() async {
    await _currentFileSink?.flush();
  }

  @override
  Future<void> close() async {
    _flushTimer?.cancel();
    await _bufferController.close();
    await _currentFileSink?.close();
  }

  @override
  Future<void> dispose() async {
    await close();
  }
}

/// 内存输出器（用于实时日志显示）
class MemorySink extends DisposableSink {
  final int _maxEntries;
  final List<String> _entries = [];
  final StreamController<String> _streamController = StreamController<String>.broadcast();
  final int _maxBufferSize;

  MemorySink({
    int maxEntries = 1000,
    int maxBufferSize = 10000,
  }) : 
    _maxEntries = maxEntries,
    _maxBufferSize = maxBufferSize;

  /// 获取日志条目流
  Stream<String> get stream => _streamController.stream;

  /// 获取所有日志条目
  List<String> get entries => List.unmodifiable(_entries);

  /// 清空所有日志条目
  void clear() {
    _entries.clear();
  }

  @override
  void write(LogEntry entry, String formattedMessage) {
    _entries.add(formattedMessage);
    
    // 限制内存中存储的条目数量
    while (_entries.length > _maxEntries) {
      _entries.removeAt(0);
    }
    
    // 发送流事件
    if (!_streamController.isClosed) {
      _streamController.add(formattedMessage);
    }
  }

  @override
  Future<void> flush() async {
    // 内存输出器无需刷新
  }

  @override
  Future<void> close() async {
    await _streamController.close();
  }

  @override
  Future<void> dispose() async {
    await close();
  }
}

/// 网络输出器
class NetworkSink implements DisposableSink {
  final String _url;
  final Map<String, String> _headers;
  final Duration _timeout;
  final StreamController<String> _bufferController = StreamController<String>();
  final Timer? _flushTimer;

  NetworkSink({
    required String url,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 30),
    Duration flushInterval = const Duration(seconds: 5),
  }) : 
    _url = url,
    _headers = headers ?? {'Content-Type': 'application/json'},
    _timeout = timeout,
    _flushTimer = Timer.periodic(flushInterval, (_) => flush()) {
    
    _setupBufferListener();
  }

  /// 设置缓冲区监听器
  void _setupBufferListener() {
    _bufferController.stream.listen(
      _sendLogEntry,
      onError: (error) {
        print('网络输出器错误: $error');
      },
    );
  }

  /// 发送日志条目
  Future<void> _sendLogEntry(String logData) async {
    try {
      // 在Flutter中，dart:io的HttpClient不可用，这里仅为示例
      // 实际使用时需要使用http包或其他网络库
      print('发送日志到网络: $_url');
      print(logData);
    } catch (e) {
      print('网络日志发送失败: $e');
    }
  }

  @override
  void write(LogEntry entry, String formattedMessage) {
    final logJson = json.encode(entry.toJson());
    _bufferController.add(logJson);
  }

  @override
  Future<void> flush() async {
    // 网络输出器的刷新逻辑
    // 实际实现时需要发送缓冲区中的所有数据
  }

  @override
  Future<void> close() async {
    _flushTimer?.cancel();
    await _bufferController.close();
  }

  @override
  Future<void> dispose() async {
    await close();
  }
}