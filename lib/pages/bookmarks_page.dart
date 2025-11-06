import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final DatabaseService _databaseService = DatabaseService();
  
  List<Bookmark> _bookmarks = [];
  List<Bookmark> _selectedBookmarks = [];
  bool _isSelectionMode = false;
  bool _isLoading = true;
  String _searchQuery = '';

  // 筛选选项
  String _filterType = 'all'; // all, folders, bookmarks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookmarks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarks() async {
    setState(() => _isLoading = true);
    try {
      final bookmarks = await _databaseService.getAllBookmarks();
      setState(() {
        _bookmarks = bookmarks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('加载书签失败: $e');
    }
  }

  List<Bookmark> _getFilteredBookmarks() {
    var filtered = _bookmarks;
    
    // 搜索过滤
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((bookmark) {
        return bookmark.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               bookmark.url.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               (bookmark.tags?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }
    
    // 类型过滤
    switch (_filterType) {
      case 'folders':
        filtered = filtered.where((bookmark) => bookmark.isFolder).toList();
        break;
      case 'bookmarks':
        filtered = filtered.where((bookmark) => !bookmark.isFolder).toList();
        break;
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('书签管理'),
        actions: [
          if (!_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _showSearch,
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list),
              onSelected: _onFilterSelected,
              itemBuilder: (context) => [;
                const PopupMenuItem(
                  value: 'all',
                  child: ListTile(
                    leading: Icon(Icons.list),
                    title: Text('全部'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'folders',
                  child: ListTile(
                    leading: Icon(Icons.folder),
                    title: Text('文件夹'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'bookmarks',
                  child: ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text('书签'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ] else ...[
            TextButton(
              onPressed: () => _selectAll(),
              child: const Text('全选', style: TextStyle(color: Colors.white)),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelected,
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.bookmarks), text: '书签'),
            Tab(icon: Icon(Icons.folder), text: '文件夹'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildBookmarkList(),
                _buildFolderList(),
              ],
            ),
      floatingActionButton: _isSelectionMode
          ? null
          : FloatingActionButton(
              onPressed: _showAddDialog,
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildBookmarkList() {
    final filteredBookmarks = _getFilteredBookmarks();
        .where((bookmark) => !bookmark.isFolder);
        .toList();

    if (filteredBookmarks.isEmpty) {
      return _buildEmptyState('暂无书签', '点击右下角按钮添加书签');
    }

    return _buildBookmarkListView(filteredBookmarks);
  }

  Widget _buildFolderList() {
    final filteredBookmarks = _getFilteredBookmarks();
        .where((bookmark) => bookmark.isFolder);
        .toList();

    if (filteredBookmarks.isEmpty) {
      return _buildEmptyState('暂无文件夹', '点击右下角按钮创建文件夹');
    }

    return _buildBookmarkListView(filteredBookmarks);
  }

  Widget _buildBookmarkListView(List<Bookmark> bookmarks) {
    return ReorderableListView.builder(
      itemCount: bookmarks.length,
      onReorder: (oldIndex, newIndex) {
        _reorderBookmarks(oldIndex, newIndex, bookmarks);
      },
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        final isSelected = _selectedBookmarks.contains(bookmark);
        
        return BookmarkItem(
          key: ValueKey(bookmark.id),
          bookmark: bookmark,
          isSelected: isSelected,
          onTap: () => _openBookmark(bookmark),
          onLongPress: () => _toggleSelection(bookmark),
          onSelectionChanged: (selected) => _onSelectionChanged(bookmark, selected),
          onEdit: () => _editBookmark(bookmark),
          onDelete: () => _deleteBookmark(bookmark),
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _tabController.index == 0 ? Icons.bookmarks : Icons.folder,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showSearch() async {
    final result = await showSearch<Bookmark?>(
      context: context,
      delegate: BookmarkSearchDelegate(
        bookmarks: _bookmarks,
        onSearch: (query) => setState(() => _searchQuery = query),
      ),
    );
    
    if (result != null) {
      _openBookmark(result);
    }
  }

  void _onFilterSelected(String value) {
    setState(() {
      _filterType = value;
    });
  }

  void _toggleSelection(Bookmark bookmark) {
    setState(() {
      if (_selectedBookmarks.contains(bookmark)) {
        _selectedBookmarks.remove(bookmark);
      } else {
        _selectedBookmarks.add(bookmark);
      }
      _isSelectionMode = _selectedBookmarks.isNotEmpty;
    });
  }

  void _onSelectionChanged(Bookmark bookmark, bool selected) {
    setState(() {
      if (selected) {
        if (!_selectedBookmarks.contains(bookmark)) {
          _selectedBookmarks.add(bookmark);
        }
      } else {
        _selectedBookmarks.remove(bookmark);
      }
      _isSelectionMode = _selectedBookmarks.isNotEmpty;
    });
  }

  void _selectAll() {
    setState(() {
      if (_selectedBookmarks.length == _getFilteredBookmarks().length) {
        _selectedBookmarks.clear();
      } else {
        _selectedBookmarks = List.from(_getFilteredBookmarks());
      }
    });
  }

  void _openBookmark(Bookmark bookmark) {
    if (bookmark.isFolder) {
      // 打开文件夹逻辑
      _showSnackBar('打开文件夹: ${bookmark.title}');
    } else {
      // 打开书签逻辑
      _showSnackBar('打开: ${bookmark.title}');
    }
  }

  void _editBookmark(Bookmark bookmark) async {
    final result = await showDialog<Bookmark>(
      context: context,
      builder: (context) => BookmarkEditDialog(
        bookmark: bookmark,
        isFolder: bookmark.isFolder,
      ),
    );
    
    if (result != null) {
      try {
        await _databaseService.updateBookmark(result);
        await _loadBookmarks();
        _showSnackBar('书签已更新');
      } catch (e) {
        _showErrorSnackBar('更新书签失败: $e');
      }
    }
  }

  void _showAddDialog() async {
    final isFolder = _tabController.index == 1;
    final result = await showDialog<Bookmark>(
      context: context,
      builder: (context) => BookmarkEditDialog(
        isFolder: isFolder,
      ),
    );
    
    if (result != null) {
      try {
        await _databaseService.insertBookmark(result);
        await _loadBookmarks();
        _showSnackBar(isFolder ? '文件夹已创建' : '书签已添加');
      } catch (e) {
        _showErrorSnackBar('添加失败: $e');
      }
    }
  }

  Future<void> _deleteBookmark(Bookmark bookmark) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除"${bookmark.title}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      try {
        await _databaseService.deleteBookmark(bookmark.id!);
        await _loadBookmarks();
        _showSnackBar('已删除');
      } catch (e) {
        _showErrorSnackBar('删除失败: $e');
      }
    }
  }

  Future<void> _deleteSelected() async {
    if (_selectedBookmarks.isEmpty) return;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除选中的${_selectedBookmarks.length}个项目吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      try {
        final ids = _selectedBookmarks.map((b) => b.id!).toList();
        await _databaseService.deleteMultipleBookmarks(ids);
        setState(() {
          _selectedBookmarks.clear();
          _isSelectionMode = false;
        });
        await _loadBookmarks();
        _showSnackBar('已删除选中的项目');
      } catch (e) {
        _showErrorSnackBar('删除失败: $e');
      }
    }
  }

  void _reorderBookmarks(int oldIndex, int newIndex, List<Bookmark> bookmarks) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final bookmark = bookmarks.removeAt(oldIndex);
      bookmarks.insert(newIndex, bookmark);
    });
    
    // 更新数据库中的顺序
    _databaseService.reorderBookmarks(bookmarks);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}