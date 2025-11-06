import 'package:flutter/material.dart';

class HistorySearchDelegate extends SearchDelegate<HistoryItem?> {
  final List<HistoryItem> historyItems;
  final Function(String) onSearch;

  HistorySearchDelegate({
    required this.historyItems,
    required this.onSearch,
  });

  @override
  String get searchFieldLabel => '搜索历史记录...';

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

    final results = historyItems.where((item) {
      return item.title.toLowerCase().contains(query.toLowerCase()) ||
             item.url.toLowerCase().contains(query.toLowerCase()) ||
             (item.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();

    if (results.isEmpty) {
      return _buildNoResults();
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          leading: Icon(Icons.language, color: Colors.grey[600]),
          title: Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Text(
                    item.formattedTime,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${item.visitCount}次',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (item.isBookmarked) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.bookmark,
                      size: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ],
              ),
            ],
          ),
          onTap: () {
            close(context, item);
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
          Icons.history,
          size: 64,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),
        Text(
          '搜索历史记录',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '输入关键词搜索访问过的页面',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        // 最近的历史记录
        if (historyItems.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '最近访问',
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
          ...historyItems.take(5).map((item) => ListTile(
            leading: Icon(Icons.language, color: Colors.grey[600]),
            title: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              item.url,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              item.formattedTime,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            onTap: () {
              close(context, item);
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
          '未找到相关历史记录',
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