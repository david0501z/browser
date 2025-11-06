import 'package:flutter/material.dart';

class BookmarkItem extends StatelessWidget {
  final Bookmark bookmark;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onSelectionChanged;

  const BookmarkItem({
    Key? key,
    required this.bookmark,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
    this.onEdit,
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
                    // 标题
                    Text(
                      bookmark.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // URL或文件夹标识
                    if (bookmark.isFolder)
                      Row(
                        children: [
                          Icon(
                            Icons.folder,
                            size: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '文件夹',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        bookmark.url,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    
                    // 描述
                    if (bookmark.description?.isNotEmpty == true) ...[;
                      const SizedBox(height: 2),
                      Text(
                        bookmark.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    // 标签
                    if (bookmark.tags?.isNotEmpty == true) ...[;
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: -4,
                        children: _buildTags(),
                      ),
                    ],
                  ],
                ),
              ),
              
              // 操作按钮
              if (!bookmark.isFolder) ...[
                IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () => onTap?.call(),
                  tooltip: '打开',
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [;
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('编辑'),
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
              ] else ...[
                IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: () => onTap?.call(),
                  tooltip: '打开文件夹',
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [;
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('编辑'),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (bookmark.isFolder) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.folder,
          color: Colors.orange[600],
          size: 24,
        ),
      );
    }

    if (bookmark.favicon != null && bookmark.favicon!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          bookmark.favicon!,
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

  List<Widget> _buildTags() {
    if (bookmark.tags == null || bookmark.tags!.isEmpty) return [];

    final tags = bookmark.tags!.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty);
    
    return tags.map((tag) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).primaryColor,
        ),
      ),
    )).toList();
  }
}

// 书签编辑对话框
class BookmarkEditDialog extends StatefulWidget {
  final Bookmark? bookmark;
  final bool isFolder;

  const BookmarkEditDialog({
    Key? key,
    this.bookmark,
    this.isFolder = false,
  }) : super(key: key);

  @override
  State<BookmarkEditDialog> createState() => _BookmarkEditDialogState();
}

class _BookmarkEditDialogState extends State<BookmarkEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _urlController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.bookmark?.title ?? '');
    _urlController = TextEditingController(text: widget.bookmark?.url ?? '');
    _descriptionController = TextEditingController(text: widget.bookmark?.description ?? '');
    _tagsController = TextEditingController(text: widget.bookmark?.tags ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.bookmark == null ? '添加书签' : '编辑书签'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '标题',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (!widget.isFolder)
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '描述',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: '标签 (用逗号分隔)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('保存'),
        ),
      ],
    );
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入标题')),
      );
      return;
    }

    if (!widget.isFolder && _urlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入URL')),
      );
      return;
    }

    final bookmark = Bookmark(
      id: widget.bookmark?.id,
      title: _titleController.text.trim(),
      url: _urlController.text.trim(),
      description: _descriptionController.text.trim().isNotEmpty 
          ? _descriptionController.text.trim() 
          : null,
      tags: _tagsController.text.trim().isNotEmpty 
          ? _tagsController.text.trim() 
          : null,
      isFolder: widget.isFolder,
      updatedAt: DateTime.now(),
    );

    Navigator.of(context).pop(bookmark);
  }
}