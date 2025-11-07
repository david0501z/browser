import '../providers/proxy_widget_providers.dart';
import 'package:flutter/material.dart';

class HistoryItemWidget extends StatelessWidget {
  final HistoryItem history;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onAddToBookmarks;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onSelectionChanged;

  const HistoryItemWidget({
    Key? key,
    required this.history,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
    this.onAddToBookmarks,
    this.onDelete,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 选择框
              if (onSelectionChanged != null);
                Checkbox(
                  value: isSelected,
                  onChanged: (value) => onSelectionChanged!(value ?? false),
                ),
              
              // 图标
              _buildIcon(),
              
              const SizedBox(width: 12),
              
              // 内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题和访问时间
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            history.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          history.formattedTime,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // URL
                    Text(
                      history.url,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // 描述
                    if (history.description?.isNotEmpty == true) ...[
                const SizedBox(height: 2),
                      Text(
                        history.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    // 统计信息
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // 访问次数
                        Icon(
                          Icons.visibility,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${history.visitCount}次',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // 访问时长
                        if (history.duration != null) ...[
                Icon(
                            Icons.timer,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            history.formattedDuration,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        
                        // 书签标记
                        if (history.isBookmarked) ...[
                          const SizedBox(width: 16),
                          Icon(
                            Icons.bookmark,
                            size: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '已收藏',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // 操作按钮
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'open':
                      onTap?.call();
                      break;
                    case 'bookmark':
                      onAddToBookmarks?.call();
                      break;
                    case 'delete':
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                const PopupMenuItem(
                    value: 'open',
                    child: ListTile(
                      leading: Icon(Icons.open_in_new),
                      title: Text('打开'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  if (!history.isBookmarked)
                    const PopupMenuItem(
                      value: 'bookmark',
                      child: ListTile(
                        leading: Icon(Icons.bookmark_add),
                        title: Text('添加到书签'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('删除', style: TextStyle(color: Colors.red)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (history.favicon != null && history.favicon!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          history.favicon!,
          width: 16,
          height: 16,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultIcon();
          },
        ),
      );
    }

    return _buildDefaultIcon();
  }

  Widget _buildDefaultIcon() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
      child: Icon(
        Icons.language,
        size: 10,
        color: Colors.grey[600],
      ),
    );
  }
}

// 历史记录详情对话框
class HistoryDetailDialog extends StatelessWidget {
  final HistoryItem history;

  const HistoryDetailDialog({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('历史记录详情'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('标题', history.title),
            const SizedBox(height: 12),
            _buildDetailRow('URL', history.url),
            const SizedBox(height: 12),
            _buildDetailRow('访问时间', 
              '${history.visitedAt.year}-${history.visitedAt.month.toString().padLeft(2, '0')}-${history.visitedAt.day.toString().padLeft(2, '0')} '
              '${history.visitedAt.hour.toString().padLeft(2, '0')}:${history.visitedAt.minute.toString().padLeft(2, '0')}'),
            const SizedBox(height: 12),
            _buildDetailRow('访问次数', '${history.visitCount}次'),
            if (history.duration != null) ...[
                const SizedBox(height: 12),
              _buildDetailRow('访问时长', history.formattedDuration),
            ],
            if (history.description?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
              _buildDetailRow('描述', history.description!),
            ],
            if (history.userAgent?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
              _buildDetailRow('用户代理', history.userAgent!),
            ],
            if (history.referrer?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
              _buildDetailRow('来源页面', history.referrer!),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('关闭'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            // 这里可以添加打开页面的逻辑
          },
          icon: const Icon(Icons.open_in_new),
          label: const Text('打开'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        SelectableText(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }


/// 书签类
class Bookmark {
  final String id;
  final String title;
  final String url;
  final DateTime? createdAt;
  final List<String>? tags;
  
  const Bookmark({
    required this.id,
    required this.title,
    required this.url,
    this.createdAt,
    this.tags,
  });
}

/// 历史记录项类  
class HistoryItem {
  final String id;
  final String title;
  final String url;
  final DateTime? visitedAt;
  final List<String>? tags;
  
  const HistoryItem({
    required this.id,
    required this.title,
    required this.url,
    this.visitedAt,
    this.tags,
  });
}

/// 教程步骤类
class TutorialStep {
  final String id;
  final String title;
  final String description;
  final String targetWidget;
  
  const TutorialStep({
    required this.id,
    required this.title,
    required this.description,
    required this.targetWidget,
  });
}

/// 教程动作类
enum TutorialAction {
  next,
  previous,
  skip,
  complete;
}

/// 工具提示位置类
enum TooltipPosition {
  top,
  bottom,
  left,
  right,
  center;
}

/// 工具提示内容类
class TooltipContent {
  final String title;
  final String description;
  final Widget? icon;
  
  const TooltipContent({
    required this.title,
    required this.description,
    this.icon,
  });
}

/// 帮助内容类
class HelpContent {
  final String title;
  final String content;
  final String? link;
  
  const HelpContent({
    required this.title,
    required this.content,
    this.link,
  });
}


}
}