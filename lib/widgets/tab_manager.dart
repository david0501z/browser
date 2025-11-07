import '../providers/proxy_widget_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'tab_bar.dart';
import 'tab_preview.dart';

/// 标签页数据模型
class TabData {
  final String id;
  final String title;
  final String url;
  final String? faviconUrl;
  final Uint8List? thumbnail;
  final bool isLoading;
  final DateTime createdAt;
  final DateTime lastVisited;
  final int visitCount;
  final bool isBookmarked;

  TabData({
    required this.id,
    required this.title,
    required this.url,
    this.faviconUrl,
    this.thumbnail,
    this.isLoading = false,
    required this.createdAt,
    required this.lastVisited,
    this.visitCount = 0,
    this.isBookmarked = false,
  });

  TabData copyWith({
    String? id,
    String? title,
    String? url,
    String? faviconUrl,
    Uint8List? thumbnail,
    bool? isLoading,
    DateTime? createdAt,
    DateTime? lastVisited,
    int? visitCount,
    bool? isBookmarked,
  }) {
    return TabData(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      faviconUrl: faviconUrl ?? this.faviconUrl,
      thumbnail: thumbnail ?? this.thumbnail,
      isLoading: isLoading ?? this.isLoading,
      createdAt: createdAt ?? this.createdAt,
      lastVisited: lastVisited ?? this.lastVisited,
      visitCount: visitCount ?? this.visitCount,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'faviconUrl': faviconUrl,
      'thumbnail': thumbnail != null ? base64Encode(thumbnail!) : null,
      'isLoading': isLoading,
      'createdAt': createdAt.toIso8601String(),
      'lastVisited': lastVisited.toIso8601String(),
      'visitCount': visitCount,
      'isBookmarked': isBookmarked,
    };
  }

  factory TabData.fromJson(Map<String, dynamic> json) {
    return TabData(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      faviconUrl: json['faviconUrl'],
      thumbnail: json['thumbnail'] != null;
          ? base64Decode(json['thumbnail']) 
          : null,
      isLoading: json['isLoading'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      lastVisited: DateTime.parse(json['lastVisited']),
      visitCount: json['visitCount'] ?? 0,
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }
}

/// 标签页管理器
class TabManager extends StatefulWidget {
  final Widget? child;
  final Function(TabData)? onTabChanged;
  final Function(TabData)? onTabClosed;
  final Function(TabData)? onTabCreated;
  final int maxTabs;

  const TabManager({
    Key? key,
    this.child,
    this.onTabChanged,
    this.onTabClosed,
    this.onTabCreated,
    this.maxTabs = 20,
  }) : super(key: key);

  @override
  State<TabManager> createState() => _TabManagerState();
}

class _TabManagerState extends State<TabManager> 
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<TabData> _tabs = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isPreviewMode = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    // 添加默认标签页
    _addNewTab('新标签页', 'https://www.google.com');
    _loadTabsFromStorage();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// 添加新标签页
  void _addNewTab(String title, String url, {String? faviconUrl}) {
    if (_tabs.length >= widget.maxTabs) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已达到最大标签页数量')),
      );
      return;
    }

    final newTab = TabData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      url: url,
      faviconUrl: faviconUrl,
      createdAt: DateTime.now(),
      lastVisited: DateTime.now(),
    );

    setState(() {
      _tabs.add(newTab);
      _tabController = TabController(
        length: _tabs.length,
        vsync: this,
      );
    });

    // 切换到新标签页
    _tabController.animateTo(_tabs.length - 1);
    
    widget.onTabCreated?.call(newTab);
    _saveTabsToStorage();
  }

  /// 关闭标签页
  void _closeTab(int index) {
    if (_tabs.isEmpty) return;

    final closedTab = _tabs[index];
    setState(() {
      _tabs.removeAt(index);
      _tabController = TabController(
        length: _tabs.length,
        vsync: this,
      );
    });

    // 如果关闭的是当前标签页，切换到相邻标签页
    if (_tabController.index >= _tabs.length) {
      _tabController.animateTo(_tabs.length - 1);
    }

    widget.onTabClosed?.call(closedTab);
    _saveTabsToStorage();
  }

  /// 切换标签页
  void _switchTab(int index) {
    if (index < 0 || index >= _tabs.length) return;

    setState(() {
      _tabController.index = index;
      // 更新最后访问时间
      _tabs[index] = _tabs[index].copyWith(
        lastVisited: DateTime.now(),
        visitCount: _tabs[index].visitCount + 1,
      );
    });

    widget.onTabChanged?.call(_tabs[index]);
    _saveTabsToStorage();
  }

  /// 关闭其他标签页
  void _closeOtherTabs(int keepIndex) {
    final keepTab = _tabs[keepIndex];
    setState(() {
      _tabs.clear();
      _tabs.add(keepTab);
      _tabController = TabController(length: 1, vsync: this);
    });
    _tabController.animateTo(0);
    _saveTabsToStorage();
  }

  /// 关闭所有标签页
  void _closeAllTabs() {
    setState(() {
      _tabs.clear();
      _tabController = TabController(length: 0, vsync: this);
    });
    _saveTabsToStorage();
  }

  /// 更新标签页信息
  void updateTab(String id, {
    String? title,
    String? url,
    String? faviconUrl,
    Uint8List? thumbnail,
    bool? isLoading,
  }) {
    final index = _tabs.indexWhere((tab) => tab.id == id);
    if (index != -1) {
      setState(() {
        _tabs[index] = _tabs[index].copyWith(
          title: title,
          url: url,
          faviconUrl: faviconUrl,
          thumbnail: thumbnail,
          isLoading: isLoading,
          lastVisited: DateTime.now(),
        );
      });
      _saveTabsToStorage();
    }
  }

  /// 切换预览模式
  void _togglePreviewMode() {
    setState(() {
      _isPreviewMode = !_isPreviewMode;
    });
    
    if (_isPreviewMode) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  /// 保存标签页数据到本地存储
  Future<void> _saveTabsToStorage() async {
    try {
      final List<Map<String, dynamic>> tabsJson =;
          _tabs.map((tab) => tab.toJson()).toList();
      final String tabsData = jsonEncode(tabsJson);
      
      // 这里可以使用SharedPreferences或其他存储方式
      // await SharedPreferences.getInstance().setString('tabs', tabsData);
      print('标签页数据已保存: ${_tabs.length}个标签页');
    } catch (e) {
      print('保存标签页数据失败: $e');
    }
  }

  /// 从本地存储加载标签页数据
  Future<void> _loadTabsFromStorage() async {
    try {
      // 这里可以从SharedPreferences或其他存储方式加载
      // final String? tabsData = await SharedPreferences.getInstance().getString('tabs');
      // if (tabsData != null) {
      //   final List<dynamic> tabsJson = jsonDecode(tabsData);
      //   final List<TabData> loadedTabs = tabsJson
      //       .map((json) => TabData.fromJson(json))
      //       .toList();
      //   
      //   setState(() {
      //     _tabs.clear();
      //     _tabs.addAll(loadedTabs);
      //     _tabController = TabController(length: _tabs.length, vsync: this);
      //   });
      // }
      
      print('标签页数据加载完成');
    } catch (e) {
      print('加载标签页数据失败: $e');
    }
  }

  /// 处理键盘快捷键
  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      // Ctrl+T: 新建标签页
      if (event.logicalKey == LogicalKeyboardKey.keyT &&
          HardwareKeyboard.instance.isControlPressed) {
        _addNewTab('新标签页', 'https://www.google.com');
      }
      // Ctrl+W: 关闭当前标签页
      else if (event.logicalKey == LogicalKeyboardKey.keyW &&
               HardwareKeyboard.instance.isControlPressed) {
        if (_tabController.index >= 0 && _tabController.index < _tabs.length) {
          _closeTab(_tabController.index);
        }
      }
      // Ctrl+1-9: 切换到对应标签页
      else if (HardwareKeyboard.instance.isControlPressed) {
        for (int i = 1; i <= 9; i++) {
          if (event.logicalKey == LogicalKeyboardKey.digit1 + i - 1) {
            final tabIndex = i - 1;
            if (tabIndex < _tabs.length) {
              _switchTab(tabIndex);
            }
            break;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyT): 
            const NewTabIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyW): 
            const CloseTabIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit1): 
            const SwitchTabIntent(0),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit2): 
            const SwitchTabIntent(1),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit3): 
            const SwitchTabIntent(2),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit4): 
            const SwitchTabIntent(3),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit5): 
            const SwitchTabIntent(4),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit6): 
            const SwitchTabIntent(5),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit7): 
            const SwitchTabIntent(6),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit8): 
            const SwitchTabIntent(7),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit9): 
            const SwitchTabIntent(8),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          NewTabIntent: CallbackAction<NewTabIntent>(
            onInvoke: (_) => _addNewTab('新标签页', 'https://www.google.com'),
          ),
          CloseTabIntent: CallbackAction<CloseTabIntent>(
            onInvoke: (_) {
              if (_tabController.index >= 0 && _tabController.index < _tabs.length) {
                _closeTab(_tabController.index);
              }
            },
          ),
          SwitchTabIntent: CallbackAction<SwitchTabIntent>(
            onInvoke: (intent) {
              final tabIndex = intent.index;
              if (tabIndex < _tabs.length) {
                _switchTab(tabIndex);
              }
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: KeyboardListener(
            onKeyEvent: _handleKeyEvent,
            child: Scaffold(
              key: _scaffoldKey,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: CustomTabBar(
                  tabs: _tabs,
                  currentIndex: _tabController.index,
                  onTabTap: _switchTab,
                  onTabClose: _closeTab,
                  onNewTab: () => _addNewTab('新标签页', 'https://www.google.com'),
                  onTogglePreview: _togglePreviewMode,
                  isPreviewMode: _isPreviewMode,
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: _tabs.isEmpty 
                        ? _buildEmptyState()
                        : _isPreviewMode
                            ? _buildPreviewMode()
                            : _buildNormalMode(),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _addNewTab('新标签页', 'https://www.google.com'),
                child: const Icon(Icons.add),
                tooltip: '新建标签页 (Ctrl+T)',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.tab_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '暂无标签页',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _addNewTab('新标签页', 'https://www.google.com'),
            icon: const Icon(Icons.add),
            label: const Text('新建标签页'),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalMode() {
    return TabBarView(
      controller: _tabController,
      children: _tabs.map((tab) {
        return TabContent(
          tab: tab,
          onUpdate: (title, url, faviconUrl, thumbnail, isLoading) {
            updateTab(tab.id,
              title: title,
              url: url,
              faviconUrl: faviconUrl,
              thumbnail: thumbnail,
              isLoading: isLoading,
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildPreviewMode() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          return TabPreview(
            tab: _tabs[index],
            onTap: () {
              _switchTab(index);
              _togglePreviewMode();
            },
            onClose: () => _closeTab(index),
          );
        },
      ),
    );
  }
}

/// 标签页内容组件
class TabContent extends StatefulWidget {
  final TabData tab;
  final Function(String title, String url, String? faviconUrl, Uint8List? thumbnail, bool isLoading) onUpdate;

  const TabContent({
    Key? key,
    required this.tab,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<TabContent> {
  late TextEditingController _urlController;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.tab.url);
    _isLoading = widget.tab.isLoading;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 地址栏
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                if (widget.tab.faviconUrl != null);
                  Image.network(
                    widget.tab.faviconUrl!,
                    width: 16,
                    height: 16,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.language, size: 16);
                    },
                  )
                else
                  const Icon(Icons.language, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: '输入网址或搜索...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (value) {
                      _navigateToUrl(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _navigateToUrl(_urlController.text),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
          // 内容区域
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: widget.tab.thumbnail != null;
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.memory(
                        widget.tab.thumbnail!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : _buildWebViewPlaceholder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebViewPlaceholder() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.web,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            widget.tab.title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.tab.url,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _navigateToUrl(_urlController.text),
            child: const Text('加载页面'),
          ),
        ],
      ),
    );
  }

  void _navigateToUrl(String url) {
    // 这里可以集成WebView或其他浏览器引擎
    final cleanUrl = url.trim();
    if (cleanUrl.isEmpty) return;

    // 简单的URL验证和格式化
    String finalUrl;
    if (cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://')) {
      finalUrl = cleanUrl;
    } else if (cleanUrl.contains('.')) {
      finalUrl = 'https://$cleanUrl';
    } else {
      finalUrl = 'https://www.google.com/search?q=${Uri.encodeComponent(cleanUrl)}';
    }

    widget.onUpdate(
      cleanUrl,
      finalUrl,
      null, // faviconUrl
      null, // thumbnail
      true, // isLoading
    );
  }
}

/// 自定义Intent类
class NewTabIntent extends Intent {}

class CloseTabIntent extends Intent {}


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

class SwitchTabIntent extends Intent {
  final int index;
  const SwitchTabIntent(this.index);
}