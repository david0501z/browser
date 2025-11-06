import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'browser_data.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 创建书签表
    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        url TEXT NOT NULL,
        description TEXT,
        favicon TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER,
        tags TEXT,
        orderIndex INTEGER,
        isFolder INTEGER DEFAULT 0
      )
    ''');

    // 创建历史记录表
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        url TEXT NOT NULL,
        description TEXT,
        favicon TEXT,
        visitedAt INTEGER NOT NULL,
        visitCount INTEGER DEFAULT 1,
        duration INTEGER,
        userAgent TEXT,
        referrer TEXT,
        isBookmarked INTEGER DEFAULT 0
      )
    ''');

    // 创建索引
    await db.execute('CREATE INDEX idx_bookmarks_title ON bookmarks(title)');
    await db.execute('CREATE INDEX idx_bookmarks_url ON bookmarks(url)');
    await db.execute('CREATE INDEX idx_bookmarks_tags ON bookmarks(tags)');
    
    await db.execute('CREATE INDEX idx_history_title ON history(title)');
    await db.execute('CREATE INDEX idx_history_url ON history(url)');
    await db.execute('CREATE INDEX idx_history_visitedAt ON history(visitedAt)');
  }

  // 书签相关方法
  Future<int> insertBookmark(Bookmark bookmark) async {
    final db = await database;
    return await db.insert('bookmarks', bookmark.toMap());
  }

  Future<List<Bookmark>> getAllBookmarks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bookmarks',
      orderBy: 'orderIndex ASC, createdAt DESC',
    );
    return List.generate(maps.length, (i) => Bookmark.fromMap(maps[i]));
  }

  Future<List<Bookmark>> searchBookmarks(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bookmarks',
      where: 'title LIKE ? OR url LIKE ? OR tags LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'orderIndex ASC, createdAt DESC',
    );
    return List.generate(maps.length, (i) => Bookmark.fromMap(maps[i]));
  }

  Future<int> updateBookmark(Bookmark bookmark) async {
    final db = await database;
    return await db.update(
      'bookmarks',
      bookmark.toMap(),
      where: 'id = ?',
      whereArgs: [bookmark.id],
    );
  }

  Future<int> deleteBookmark(int id) async {
    final db = await database;
    return await db.delete(
      'bookmarks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMultipleBookmarks(List<int> ids) async {
    final db = await database;
    final placeholders = ids.map((_) => '?').join(',');
    return await db.delete(
      'bookmarks',
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }

  Future<void> reorderBookmarks(List<Bookmark> bookmarks) async {
    final db = await database;
    await db.transaction((txn) async {
      for (int i = 0; i < bookmarks.length; i++) {
        await txn.update(
          'bookmarks',
          {'orderIndex': i},
          where: 'id = ?',
          whereArgs: [bookmarks[i].id],
        );
      }
    });
  }

  // 历史记录相关方法
  Future<int> insertHistory(HistoryItem history) async {
    final db = await database;
    return await db.insert('history', history.toMap());
  }

  Future<List<HistoryItem>> getAllHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'history',
      orderBy: 'visitedAt DESC',
    );
    return List.generate(maps.length, (i) => HistoryItem.fromMap(maps[i]));
  }

  Future<List<HistoryItem>> getHistoryByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'history',
      where: 'visitedAt BETWEEN ? AND ?',
      whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
      orderBy: 'visitedAt DESC',
    );
    return List.generate(maps.length, (i) => HistoryItem.fromMap(maps[i]));
  }

  Future<List<HistoryItem>> searchHistory(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'history',
      where: 'title LIKE ? OR url LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'visitedAt DESC',
    );
    return List.generate(maps.length, (i) => HistoryItem.fromMap(maps[i]));
  }

  Future<int> updateHistory(HistoryItem history) async {
    final db = await database;
    return await db.update(
      'history',
      history.toMap(),
      where: 'id = ?',
      whereArgs: [history.id],
    );
  }

  Future<int> deleteHistory(int id) async {
    final db = await database;
    return await db.delete(
      'history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMultipleHistory(List<int> ids) async {
    final db = await database;
    final placeholders = ids.map((_) => '?').join(',');
    return await db.delete(
      'history',
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }

  Future<int> deleteHistoryByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    return await db.delete(
      'history',
      where: 'visitedAt BETWEEN ? AND ?',
      whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
    );
  }

  Future<int> clearAllHistory() async {
    final db = await database;
    return await db.delete('history');
  }

  Future<void> incrementVisitCount(String url) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'history',
      where: 'url = ?',
      whereArgs: [url],
    );
    
    if (maps.isNotEmpty) {
      final history = HistoryItem.fromMap(maps.first);
      await db.update(
        'history',
        {'visitCount': history.visitCount + 1},
        where: 'id = ?',
        whereArgs: [history.id],
      );
    }
  }

  // 统计方法
  Future<int> getBookmarkCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM bookmarks');
    return result.first['count'] as int;
  }

  Future<int> getHistoryCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM history');
    return result.first['count'] as int;
  }

  Future<int> getHistoryCountByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM history WHERE visitedAt BETWEEN ? AND ?',
      [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
    );
    return result.first['count'] as int;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}