import 'package:flutter/material.dart';
import '../data/help_content.dart';
import '../widgets/tutorial_overlay.dart';

/// FAQ页面
/// 提供常见问题解答的浏览和搜索功能
class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _searchController;
  late Animation<double> _searchAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  String _searchQuery = '';
  String _selectedCategory = 'all';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: HelpContent.faqCategories.length + 1, // +1 for "All" tab
      vsync: this,
    );
    _searchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _searchController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });

    if (_isSearching) {
      _searchController.forward();
    } else {
      _searchController.reverse();
      _searchQuery = '';
      _searchController.clear();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  List<FAQItem> _getFilteredFAQs() {
    List<FAQItem> faqs = [];
    
    // 获取所有FAQ
    for (final category in HelpContent.faqCategories) {
      faqs.addAll(category.faqs);
    }

    // 应用搜索过滤
    if (_searchQuery.isNotEmpty) {
      faqs = faqs.where((faq) {
        return faq.question.toLowerCase().contains(_searchQuery) ||
               faq.answer.toLowerCase().contains(_searchQuery) ||
               faq.tags.any((tag) => tag.toLowerCase().contains(_searchQuery));
      }).toList();
    }

    // 应用分类过滤
    if (_selectedCategory != 'all') {
      final category = HelpContent.faqCategories
          .firstWhere((cat) => cat.id == _selectedCategory);
      faqs = faqs.where((faq) => category.faqs.contains(faq)).toList();
    }

    return faqs;
  }

  void _showRelatedTutorial(List<String>? relatedSteps) {
    if (relatedSteps == null || relatedSteps.isEmpty) return;

    final steps = HelpContent.tutorialSteps
        .where((step) => relatedSteps.contains(step.id))
        .toList();

    if (steps.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TutorialOverlayPage(
            steps: steps,
            title: '相关教程',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // 搜索栏
          _buildSearchBar(),
          
          // 分类标签栏
          _buildCategoryTabs(),
          
          // FAQ内容
          Expanded(
            child: _buildFAQContent(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('常见问题'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _toggleSearch,
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'feedback':
                _showFeedbackDialog();
                break;
              case 'contact':
                _showContactDialog();
                break;
              case 'rate':
                _showRatingDialog();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'feedback',
              child: ListTile(
                leading: Icon(Icons.feedback),
                title: Text('反馈建议'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'contact',
              child: ListTile(
                leading: Icon(Icons.contact_support),
                title: Text('联系客服'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'rate',
              child: ListTile(
                leading: Icon(Icons.star),
                title: Text('评分应用'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isSearching ? 80 : 0,
      child: FadeTransition(
        opacity: _searchAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(_searchAnimation),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: '搜索问题或关键词...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        indicatorColor: Theme.of(context).colorScheme.primary,
        tabs: [
          const Tab(text: '全部'),
          ...HelpContent.faqCategories.map(
            (category) => Tab(
              text: category.title,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            if (index == 0) {
              _selectedCategory = 'all';
            } else {
              _selectedCategory = HelpContent.faqCategories[index - 1].id;
            }
          });
        },
      ),
    );
  }

  Widget _buildFAQContent() {
    final filteredFAQs = _getFilteredFAQs();

    if (filteredFAQs.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: filteredFAQs.length,
      itemBuilder: (context, index) {
        final faq = filteredFAQs[index];
        return _FAQExpansionTile(
          key: ValueKey(faq.id),
          faq: faq,
          onRelatedTutorial: _showRelatedTutorial,
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
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? '暂无问题' : '未找到相关问题',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty 
                ? '请稍后再试或联系客服' 
                : '请尝试其他关键词',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => _FeedbackDialog(),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => _ContactDialog(),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => _RatingDialog(),
    );
  }
}

/// FAQ展开/收起组件
class _FAQExpansionTile extends StatefulWidget {
  final FAQItem faq;
  final Function(List<String>?) onRelatedTutorial;

  const _FAQExpansionTile({
    Key? key,
    required this.faq,
    required this.onRelatedTutorial,
  }) : super(key: key);

  @override
  State<_FAQExpansionTile> createState() => _FAQExpansionTileState();
}

class _FAQExpansionTileState extends State<_FAQExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotateAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.faq.question,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: _buildTags(),
            trailing: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotateAnimation.value * 3.14159,
                  child: const Icon(Icons.expand_more),
                );
              },
            ),
            onTap: _toggleExpansion,
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(),
            crossFadeState: _isExpanded 
                ? CrossFadeState.showSecond 
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 4,
      runSpacing: -8,
      children: widget.faq.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            tag,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 8),
          Text(
            widget.faq.answer,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (widget.faq.relatedSteps?.isNotEmpty == true) ...[
            Row(
              children: [
                const Icon(Icons.play_circle_outline, size: 16),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => widget.onRelatedTutorial(widget.faq.relatedSteps),
                  child: const Text('查看相关教程'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// 反馈对话框
class _FeedbackDialog extends StatefulWidget {
  @override
  State<_FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog> {
  final TextEditingController _feedbackController = TextEditingController();
  String _feedbackType = 'suggestion';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('反馈建议'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _feedbackType,
            decoration: const InputDecoration(labelText: '反馈类型'),
            items: const [
              DropdownMenuItem(value: 'suggestion', child: Text('功能建议')),
              DropdownMenuItem(value: 'bug', child: Text('问题报告')),
              DropdownMenuItem(value: 'improvement', child: Text('改进建议')),
            ],
            onChanged: (value) {
              setState(() {
                _feedbackType = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _feedbackController,
            decoration: const InputDecoration(
              labelText: '详细描述',
              hintText: '请详细描述您的建议或遇到的问题...',
            ),
            maxLines: 4,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            _submitFeedback();
          },
          child: const Text('提交'),
        ),
      ],
    );
  }

  void _submitFeedback() {
    final feedback = UserFeedback(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _feedbackType,
      content: _feedbackController.text,
      timestamp: DateTime.now(),
    );

    // 这里可以保存反馈到本地或发送到服务器
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('感谢您的反馈！我们会认真考虑您的建议。'),
      ),
    );
  }
}

/// 联系客服对话框
class _ContactDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('联系客服'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('邮箱支持'),
            subtitle: const Text('support@flclash.com'),
            onTap: () {
              // 打开邮箱应用
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('在线客服'),
            subtitle: const Text('工作日 9:00-18:00'),
            onTap: () {
              // 打开在线客服
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('帮助文档'),
            subtitle: const Text('查看详细使用说明'),
            onTap: () {
              Navigator.of(context).pop();
              // 打开帮助文档
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('关闭'),
        ),
      ],
    );
  }
}

/// 评分对话框
class _RatingDialog extends StatefulWidget {
  @override
  State<_RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<_RatingDialog> {
  double _rating = 0.0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('评分应用'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('请为应用评分'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1.0;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: '评价内容（可选）',
              hintText: '分享您的使用体验...',
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _rating > 0 ? _submitRating : null,
          child: const Text('提交'),
        ),
      ],
    );
  }

  void _submitRating() {
    final feedback = UserFeedback(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'rating',
      content: _commentController.text,
      rating: _rating,
      timestamp: DateTime.now(),
    );

    // 这里可以保存评分到本地或发送到服务器
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('感谢您的评分！'),
      ),
    );
  }
}