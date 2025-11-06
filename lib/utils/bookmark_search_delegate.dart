import 'package:flutter/material.dart';

class BookmarkSearchDelegate extends SearchDelegate<Bookmark?> {
  final List<Bookmark> bookmarks;
  final Function(String) onSearch;

  BookmarkSearchDelegate({
    required this.bookmarks,
    required this.onSearch,
  });

  @override
  String get searchFieldLabel => '搜索书签...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    if (query.isEmpty) {
      return _buildDefaultView();
    }

    final results = bookmarks.where((bookmark) {
      return bookmark.title.toLowerCase().contains(query.toLowerCase()) ||
             bookmark.url.toLowerCase().contains(query.toLowerCase()) ||
             (bookmark.tags?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
             (bookmark.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();

    if (results.isEmpty) {
      return _buildNoResults();
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final bookmark = results[index];
        return ListTile(
          leading: bookmark.isFolder
              ? Icon(Icons.folder, color: Theme.of(context).primaryColor)
              : Icon(Icons.language, color: Colors.grey[600]),
          title: Text(
            bookmark.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (bookmark.isFolder)
                Text('文件夹', style: TextStyle(color: Theme.of(context).primaryColor))
              else
                Text(
                  bookmark.url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (bookmark.tags?.isNotEmpty == true);
                Text(
                  '标签: ${bookmark.tags}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
          onTap: () {
            close(context, bookmark);
          },
        );
      },
    );
  }

  Widget _buildDefaultView() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Icon(
          Icons.search,
          size: 64,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),
        Text(
          '搜索书签',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '输入关键词搜索书签标题、URL或标签',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        // 最近的书签
        if (bookmarks.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.bookmarks, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '最近的书签',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...bookmarks.take(5).map((bookmark) => ListTile(
            leading: bookmark.isFolder
                ? Icon(Icons.folder, color: Theme.of(context).primaryColor)
                : Icon(Icons.language, color: Colors.grey[600]),
            title: Text(
              bookmark.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: bookmark.isFolder
                ? Text('文件夹', style: TextStyle(color: Theme.of(context).primaryColor))
                : Text(
                    bookmark.url,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            onTap: () {
              close(context, bookmark);
            },
          )),
        ],
      ],
    );
  }

  Widget _buildNoResults() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Icon(
          Icons.search_off,
          size: 64,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),
        Text(
          '未找到相关书签',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '尝试使用不同的关键词搜索',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}