import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'tab_manager.dart';

/// 标签页预览组件
class TabPreview extends StatefulWidget {
  final TabData tab;
  final VoidCallback onTap;
  final VoidCallback onClose;
  final bool showCloseButton;

  const TabPreview({
    Key? key,
    required this.tab,
    required this.onTap,
    required this.onClose,
    this.showCloseButton = true,
  }) : super(key: key);

  @override
  State<TabPreview> createState() => _TabPreviewState();
}

class _TabPreviewState extends State<TabPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isHovered ? 0.2 : 0.1),
                      blurRadius: _isHovered ? 16 : 8,
                      offset: Offset(0, _isHovered ? 4 : 2),
                    ),
                  ],
                  border: Border.all(
                    color: _isHovered 
                        ? Theme.of(context).primaryColor.withOpacity(0.3)
                        : Colors.grey[300]!,
                    width: _isHovered ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 顶部操作栏
                    _buildTopBar(),
                    // 预览内容区域
                    Expanded(
                      child: _buildPreviewContent(),
                    ),
                    // 底部信息栏
                    _buildBottomBar(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          // 窗口控制按钮
          Row(
            children: [
              _buildWindowButton(Colors.red, Icons.close),
              const SizedBox(width: 6),
              _buildWindowButton(Colors.orange, Icons.minimize),
              const SizedBox(width: 6),
              _buildWindowButton(Colors.green, Icons.square),
            ],
          ),
          const Spacer(),
          // 标签页信息
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  // Favicon
                  _buildFavicon(),
                  const SizedBox(width: 8),
                  // 标题
                  Expanded(
                    child: Text(
                      widget.tab.title.isEmpty ? '新标签页' : widget.tab.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 关闭按钮
          if (widget.showCloseButton)
            GestureDetector(
              onTap: (e) {
                e.stopPropagation();
                widget.onClose();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _isHovered ? Colors.red[100] : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: _isHovered ? Colors.red : Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWindowButton(Color color, IconData icon) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 8,
        color: Colors.white,
      ),
    );
  }

  Widget _buildFavicon() {
    if (widget.tab.faviconUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Image.network(
          widget.tab.faviconUrl!,
          width: 16,
          height: 16,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultFavicon();
          },
        ),
      );
    }
    return _buildDefaultFavicon();
  }

  Widget _buildDefaultFavicon() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(2),
      ),
      child: Icon(
        Icons.language,
        size: 10,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPreviewContent() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: widget.tab.thumbnail != null;
          ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  // 缩略图
                  Positioned.fill(
                    child: Image.memory(
                      widget.tab.thumbnail!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderContent();
                      },
                    ),
                  ),
                  // 加载覆盖层
                  if (widget.tab.isLoading)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ),
                  // URL覆盖层
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                      child: Text(
                        widget.tab.url,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : _buildPlaceholderContent(),
    );
  }

  Widget _buildPlaceholderContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.web,
            size: 32,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            '暂无预览',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          // 访问信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatLastVisited(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '访问 ${widget.tab.visitCount} 次',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          // 书签标识
          if (widget.tab.isBookmarked)
            Icon(
              Icons.bookmark,
              size: 14,
              color: Colors.amber[600],
            ),
          // 加载状态
          if (widget.tab.isLoading)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatLastVisited() {
    final now = DateTime.now();
    final difference = now.difference(widget.tab.lastVisited);
    
    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${widget.tab.lastVisited.year}-${widget.tab.lastVisited.month.toString().padLeft(2, '0')}-${widget.tab.lastVisited.day.toString().padLeft(2, '0')}';
    }
  }
}

/// 标签页缩略图生成器
class TabThumbnailGenerator {
  /// 生成网页缩略图
  static Future<Uint8List?> generateThumbnail({
    required String url,
    required Size size,
    int quality = 80,
  }) async {
    try {
      // 这里可以集成实际的网页截图功能
      // 例如使用 webview_flutter 的 takeScreenshot 方法
      // 或者使用其他第三方截图库
      
      // 模拟生成缩略图
      return await _generateMockThumbnail(url, size, quality);
    } catch (e) {
      print('生成缩略图失败: $e');
      return null;
    }
  }

  /// 生成模拟缩略图（用于演示）
  static Future<Uint8List?> _generateMockThumbnail(
    String url,
    Size size,
    int quality,
  ) async {
    // 创建一个简单的缩略图
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // 设置背景色
    final paint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    
    // 绘制标题
    final titlePaint = Paint()..color = Colors.black87;
    final titleText = TextPainter(
      text: TextSpan(
        text: url.length > 30 ? '${url.substring(0, 30)}...' : url,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    titleText.layout(maxWidth: size.width - 20);
    titleText.paint(canvas, const Offset(10, 10));
    
    // 绘制一些模拟内容
    final contentPaint = Paint()..color = Colors.grey[300]!;
    for (int i = 0; i < 3; i++) {
      final y = 40 + i * 30;
      canvas.drawRect(
        Rect.fromLTWH(10, y, size.width - 20, 20),
        contentPaint,
      );
    }
    
    // 完成绘制
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    
    return byteData?.buffer.asUint8List();
  }

  /// 从URL提取favicon
  static String? extractFaviconUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return '${uri.scheme}://${uri.host}/favicon.ico';
    } catch (e) {
      return null;
    }
  }

  /// 优化缩略图大小
  static Uint8List? compressThumbnail(Uint8List thumbnail, {int maxWidth = 300}) {
    try {
      // 这里可以实现图像压缩逻辑
      // 返回压缩后的缩略图
      return thumbnail;
    } catch (e) {
      print('压缩缩略图失败: $e');
      return null;
    }
  }
}

/// 标签页预览网格
class TabPreviewGrid extends StatefulWidget {
  final List<TabData> tabs;
  final Function(int) onTabTap;
  final Function(int) onTabClose;
  final Function(List<int>)? onTabsReordered;

  const TabPreviewGrid({
    Key? key,
    required this.tabs,
    required this.onTabTap,
    required this.onTabClose,
    this.onTabsReordered,
  }) : super(key: key);

  @override
  State<TabPreviewGrid> createState() => _TabPreviewGridState();
}

class _TabPreviewGridState extends State<TabPreviewGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _staggerAnimation;
  List<int> _selectedTabs = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _staggerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          _buildHeader(),
          const SizedBox(height: 16),
          // 预览网格
          Expanded(
            child: _buildPreviewGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          '标签页预览 (${widget.tabs.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        if (_selectedTabs.isNotEmpty) ...[
          TextButton.icon(
            onPressed: _closeSelectedTabs,
            icon: const Icon(Icons.close, size: 16),
            label: Text('关闭选中 (${_selectedTabs.length})'),
          ),
          TextButton(
            onPressed: _clearSelection,
            child: const Text('取消选择'),
          ),
        ] else ...[
          TextButton(
            onPressed: _selectAll,
            child: const Text('全选'),
          ),
          TextButton(
            onPressed: _closeAllTabs,
            child: const Text('关闭所有'),
          ),
        ],
      ],
    );
  }

  Widget _buildPreviewGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: widget.tabs.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _staggerAnimation,
          builder: (context, child) {
            final delay = index * 0.1;
            final progress = (_staggerAnimation.value - delay).clamp(0.0, 1.0);
            
            return Transform.scale(
              scale: progress,
              child: Opacity(
                opacity: progress,
                child: TabPreview(
                  tab: widget.tabs[index],
                  onTap: () => widget.onTabTap(index),
                  onClose: () => widget.onTabClose(index),
                  showCloseButton: !_selectedTabs.contains(index),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _toggleTabSelection(int index) {
    setState(() {
      if (_selectedTabs.contains(index)) {
        _selectedTabs.remove(index);
      } else {
        _selectedTabs.add(index);
      }
    });
  }

  void _closeSelectedTabs() {
    // 按降序排序，避免索引变化问题
    final sortedIndexes = List<int>.from(_selectedTabs)..sort((a, b) => b.compareTo(a));
    
    for (final index in sortedIndexes) {
      widget.onTabClose(index);
    }
    
    _clearSelection();
  }

  void _clearSelection() {
    setState(() {
      _selectedTabs.clear();
    });
  }

  void _selectAll() {
    setState(() {
      _selectedTabs = List<int>.generate(widget.tabs.length, (index) => index);
    });
  }

  void _closeAllTabs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('关闭所有标签页'),
        content: Text('确定要关闭所有 ${widget.tabs.length} 个标签页吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              for (int i = widget.tabs.length - 1; i >= 0; i--) {
                widget.onTabClose(i);
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}