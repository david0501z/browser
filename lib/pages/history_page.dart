import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final DatabaseService _databaseService = DatabaseService();
  
  List<HistoryItem> _historyItems = [];
  List<HistoryItem> _selectedHistoryItems = [];
  bool _isSelectionMode = false;
  bool _isLoading = true;
  String _searchQuery = '';

  // 筛选选项
  String _filterType = 'all'; // all, today, week, month, bookmarked;
  DateTime _filterStartDate = DateTime.now();
  DateTime _filterEndDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final history = await _databaseService.getAllHistory();
      setState(() {
        _historyItems = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('加载历史记录失败: $e');
    }
  }

  List<HistoryItem> _getFilteredHistory() {
    var filtered = _historyItems;
    
    // 搜索过滤
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               item.url.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               (item.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }
    
    // 时间过滤
    switch (_filterType) {
      case 'today':
        final today = DateTime.now();
        final startOfDay = DateTime(today.year, today.month, today.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));
        filtered = filtered.where((item) => 
            item.visitedAt.isAfter(startOfDay) && item.visitedAt.isBefore(endOfDay)
        ).toList();
        break;
      case 'week':
        final now = DateTime.now();
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final startOfWeekDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        final endOfWeek = startOfWeekDay.add(const Duration(days: 7));
        filtered = filtered.where((item) => 
            item.visitedAt.isAfter(startOfWeekDay) && item.visitedAt.isBefore(endOfWeek)
        ).toList();
        break;
      case 'month':
        final now = DateTime.now();
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 1);
        filtered = filtered.where((item) => 
            item.visitedAt.isAfter(startOfMonth) && item.visitedAt.isBefore(endOfMonth)
        ).toList();
        break;
      case 'bookmarked':
        filtered = filtered.where((item) => item.isBookmarked).toList();
        break;
      case 'custom':
        filtered = filtered.where((item) => 
item.visitedAt.isAfter(_filterStartDate) && item.visitedAt.isBefore(_filterEndDate.add(const Duration(days: 1))
        ).toList();
        break;
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('历史记录'),
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
                  value: 'today',
                  child: ListTile(
                    leading: Icon(Icons.today),
                    title: Text('今天'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'week',
                  child: ListTile(
                    leading: Icon(Icons.calendar_view_week),
                    title: Text('本周'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'month',
                  child: ListTile(
                    leading: Icon(Icons.calendar_month),
                    title: Text('本月'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'bookmarked',
                  child: ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text('已收藏'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'custom',
                  child: ListTile(
                    leading: Icon(Icons.date_range),
                    title: Text('自定义时间'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: _onMenuSelected,
              itemBuilder: (context) => [;
                const PopupMenuItem(
                  value: 'clear_today',
                  child: ListTile(
                    leading: Icon(Icons.today),
                    title: Text('清除今天'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_week',
                  child: ListTile(
                    leading: Icon(Icons.calendar_view_week),
                    title: Text('清除本周'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: ListTile(
                    leading: Icon(Icons.delete_sweep, color: Colors.red),
                    title: Text('清除全部', style: TextStyle(color: Colors.red)),
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
              icon: const Icon(Icons.bookmark_add),
              onPressed: _addSelectedToBookmarks,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelected,
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildHistoryList(),
    );
  }

  Widget _buildHistoryList() {
    final filteredHistory = _getFilteredHistory();

    if (filteredHistory.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: filteredHistory.length,
      itemBuilder: (context, index) {
        final item = filteredHistory[index];
        final isSelected = _selectedHistoryItems.contains(item);
        
        return HistoryItemWidget(
          history: item,
          isSelected: isSelected,
          onTap: () => _openHistoryItem(item),
          onLongPress: () => _toggleSelection(item),
          onSelectionChanged: (selected) => _onSelectionChanged(item, selected),
          onAddToBookmarks: () => _addToBookmarks(item),
          onDelete: () => _deleteHistoryItem(item),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '暂无历史记录',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '浏览网页后，历史记录将显示在这里',
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
    final result = await showSearch<HistoryItem?>(
      context: context,
      delegate: HistorySearchDelegate(
        historyItems: _historyItems,
        onSearch: (query) => setState(() => _searchQuery = query),
      ),
    );
    
    if (result != null) {
      _openHistoryItem(result);
    }
  }

  void _onFilterSelected(String value) async {
    if (value == 'custom') {
      final dateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now(),
        initialDateRange: DateTimeRange(
          start: _filterStartDate,
          end: _filterEndDate,
        ),
      );
      
      if (dateRange != null) {
        setState(() {
          _filterType = value;
          _filterStartDate = dateRange.start;
          _filterEndDate = dateRange.end;
        });
      }
    } else {
      setState(() {
        _filterType = value;
      });
    }
  }

  void _onMenuSelected(String value) async {
    switch (value) {
      case 'clear_today':
        await _clearHistoryByTimeRange('today');
        break;
      case 'clear_week':
        await _clearHistoryByTimeRange('week');
        break;
      case 'clear_all':
        await _clearAllHistory();
        break;
    }
  }

  Future<void> _clearHistoryByTimeRange(String range) async {
    DateTime start, end;
    
    switch (range) {
      case 'today':
        final today = DateTime.now();
        start = DateTime(today.year, today.month, today.day);
        end = start.add(const Duration(days: 1));
        break;
      case 'week':
        final now = DateTime.now();
        start = now.subtract(Duration(days: now.weekday - 1));
        start = DateTime(start.year, start.month, start.day);
        end = start.add(const Duration(days: 7));
        break;
      default:
        return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清除'),
        content: Text('确定要清除${range == 'today' ? '今天' : '本周'}的历史记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('清除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _databaseService.deleteHistoryByDateRange(start, end);
        await _loadHistory();
        _showSnackBar('历史记录已清除');
      } catch (e) {
        _showErrorSnackBar('清除失败: $e');
      }
    }
  }

  Future<void> _clearAllHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清除'),
        content: const Text('确定要清除所有历史记录吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('清除全部'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _databaseService.clearAllHistory();
        await _loadHistory();
        _showSnackBar('所有历史记录已清除');
      } catch (e) {
        _showErrorSnackBar('清除失败: $e');
      }
    }
  }

  void _toggleSelection(HistoryItem item) {
    setState(() {
      if (_selectedHistoryItems.contains(item)) {
        _selectedHistoryItems.remove(item);
      } else {
        _selectedHistoryItems.add(item);
      }
      _isSelectionMode = _selectedHistoryItems.isNotEmpty;
    });
  }

  void _onSelectionChanged(HistoryItem item, bool selected) {
    setState(() {
      if (selected) {
        if (!_selectedHistoryItems.contains(item)) {
          _selectedHistoryItems.add(item);
        }
      } else {
        _selectedHistoryItems.remove(item);
      }
      _isSelectionMode = _selectedHistoryItems.isNotEmpty;
    });
  }

  void _selectAll() {
    setState(() {
      if (_selectedHistoryItems.length == _getFilteredHistory().length) {
        _selectedHistoryItems.clear();
      } else {
        _selectedHistoryItems = List.from(_getFilteredHistory());
      }
    });
  }

  void _openHistoryItem(HistoryItem item) {
    // 打开历史记录页面
    _showSnackBar('打开: ${item.title}');
  }

  Future<void> _addToBookmarks(HistoryItem item) async {
    try {
      final bookmark = Bookmark(
        title: item.title,
        url: item.url,
        description: item.description,
        favicon: item.favicon,
      );
      
      await _databaseService.insertBookmark(bookmark);
      
      // 更新历史记录中的书签标记
      item.isBookmarked = true;
      await _databaseService.updateHistory(item);
      
      await _loadHistory();
      _showSnackBar('已添加到书签');
    } catch (e) {
      _showErrorSnackBar('添加书签失败: $e');
    }
  }

  Future<void> _addSelectedToBookmarks() async {
    if (_selectedHistoryItems.isEmpty) return;
    
    try {
      for (final item in _selectedHistoryItems) {
        final bookmark = Bookmark(
          title: item.title,
          url: item.url,
          description: item.description,
          favicon: item.favicon,
        );
        
        await _databaseService.insertBookmark(bookmark);
        
        // 更新历史记录中的书签标记
        item.isBookmarked = true;
        await _databaseService.updateHistory(item);
      }
      
      setState(() {
        _selectedHistoryItems.clear();
        _isSelectionMode = false;
      });
      
      await _loadHistory();
      _showSnackBar('已添加选中的项目到书签');
    } catch (e) {
      _showErrorSnackBar('添加书签失败: $e');
    }
  }

  Future<void> _deleteHistoryItem(HistoryItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除"${item.title}"的历史记录吗？'),
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
        await _databaseService.deleteHistory(item.id!);
        await _loadHistory();
        _showSnackBar('已删除');
      } catch (e) {
        _showErrorSnackBar('删除失败: $e');
      }
    }
  }

  Future<void> _deleteSelected() async {
    if (_selectedHistoryItems.isEmpty) return;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除选中的${_selectedHistoryItems.length}条历史记录吗？'),
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
        final ids = _selectedHistoryItems.map((h) => h.id!).toList();
        await _databaseService.deleteMultipleHistory(ids);
        setState(() {
          _selectedHistoryItems.clear();
          _isSelectionMode = false;
        });
        await _loadHistory();
        _showSnackBar('已删除选中的历史记录');
      } catch (e) {
        _showErrorSnackBar('删除失败: $e');
      }
    }
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