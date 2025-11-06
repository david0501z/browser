import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'pages/onboarding_page.dart';
import 'pages/browser_page.dart';
import 'pages/unified_settings_page.dart';
import 'pages/bookmarks_page.dart';
import 'pages/history_page.dart';
import 'services/settings_service.dart';
import 'services/database_service.dart';
import 'themes/browser_theme.dart';
import 'utils/device_info_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化数据库
  await DatabaseService.initialize();
  
  // 请求必要权限
  await _requestPermissions();
  
  // 初始化设置服务
  await SettingsService.initialize();
  
  runApp(
    const ProviderScope(
      child: FlClashBrowserApp(),
    ),
  );
}

Future<void> _requestPermissions() async {
  // 请求网络权限
  await Permission.network.request();
  
  // 请求存储权限（Android）
  if (await DeviceInfoHelper.isAndroid()) {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }
  
  // 请求通知权限
  await Permission.notification.request();
}

class FlClashBrowserApp extends ConsumerWidget {
  const FlClashBrowserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsServiceProvider);
    
    return MaterialApp(
      title: 'FlClash浏览器',
      debugShowCheckedModeBanner: false,
      theme: BrowserTheme.getTheme(
        isDark: settings.isDarkMode,
        primaryColor: settings.primaryColor,
      ),
      home: const RootPage(),
      routes: {
        '/browser': (context) => const BrowserPage(),
        '/settings': (context) => const UnifiedSettingsPage(),
        '/bookmarks': (context) => const BookmarksPage(),
        '/history': (context) => const HistoryPage(),
      },
    );
  }
}

class RootPage extends ConsumerStatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  int _currentIndex = 0;
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final isFirstLaunch = await SettingsService.isFirstLaunch();
    setState(() {
      _isFirstLaunch = isFirstLaunch;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 首次启动显示引导页面
    if (_isFirstLaunch) {
      return const OnboardingPage();
    }

    final List<Widget> _pages = [;
      const BrowserPage(),
      const BookmarksPage(),
      const HistoryPage(),
      const UnifiedSettingsPage(),
    ];

    final List<BottomNavigationBarItem> _items = [;
      const BottomNavigationBarItem(
        icon: Icon(Icons.language),
        label: '浏览器',
        activeIcon: Icon(Icons.language),
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.bookmarks),
        label: '书签',
        activeIcon: Icon(Icons.bookmarks),
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: '历史',
        activeIcon: Icon(Icons.history),
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: '设置',
        activeIcon: Icon(Icons.settings),
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _items,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 8,
      ),
      floatingActionButton: _currentIndex == 0 ? _buildFloatingActionButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget? _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // 快速搜索或新标签页
        _showQuickActionDialog();
      },
      child: const Icon(Icons.add),
      tooltip: '快速操作',
    );
  }

  void _showQuickActionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '快速操作',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.add_box,
                  label: '新标签页',
                  onTap: () {
                    Navigator.pop(context);
                    // 打开新标签页
                  },
                ),
                _buildActionButton(
                  icon: Icons.search,
                  label: '快速搜索',
                  onTap: () {
                    Navigator.pop(context);
                    _showSearchDialog();
                  },
                ),
                _buildActionButton(
                  icon: Icons.home,
                  label: '主页',
                  onTap: () {
                    Navigator.pop(context);
                    // 导航到主页
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('快速搜索'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: '输入搜索内容或网址',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            if (value.isNotEmpty) {
              // 处理搜索或网址输入
              _handleSearchInput(value);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  void _handleSearchInput(String input) {
    // 这里可以集成搜索功能或直接打开网址
    // 例如：打开新标签页并加载输入的内容
    print('处理输入: $input');
  }
}