import 'package:flutter/material.dart';
import 'widgets/tab_manager.dart';

/// 浏览器标签页管理示例应用
class TabManagementExample extends StatelessWidget {
  const TabManagementExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '浏览器标签页管理',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TabManagementHomePage(),
    );
  }
}

class TabManagementHomePage extends StatefulWidget {
  const TabManagementHomePage({Key? key}) : super(key: key);

  @override
  State<TabManagementHomePage> createState() => _TabManagementHomePageState();
}

class _TabManagementHomePageState extends State<TabManagementHomePage> {
  int _totalTabs = 0;
  int _totalVisits = 0;
  final Set<String> _visitedUrls = {};

  @override
  Widget build(BuildContext context) {
    return TabManager(
      maxTabs: 15,
      onTabChanged: (tab) {
        setState(() {
          _visitedUrls.add(tab.url);
          _totalVisits++;
        });
        print('切换到标签页: ${tab.title} (${tab.url})');
      },
      onTabCreated: (tab) {
        setState(() {
          _totalTabs++;
        });
        print('创建新标签页: ${tab.title} (${tab.url})');
      },
      onTabClosed: (tab) {
        setState(() {
          _totalTabs--;
        });
        print('关闭标签页: ${tab.title} (${tab.url})');
      },
      child: Scaffold(
        body: const Center(
          child: Text(
            '标签页管理示例',
            style: TextStyle(fontSize: 24),
          ),
        ),
        bottomNavigationBar: _buildStatsBar(),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.tab,
            label: '总标签页',
            value: _totalTabs.toString(),
            color: Colors.blue,
          ),
          _buildStatItem(
            icon: Icons.visibility,
            label: '访问次数',
            value: _totalVisits.toString(),
            color: Colors.green,
          ),
          _buildStatItem(
            icon: Icons.link,
            label: '不同网站',
            value: _visitedUrls.length.toString(),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

/// 自定义浏览器主题
class BrowserTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF2196F3),
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        shadowColor: Colors.grey[300],
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: Color(0xFF2196F3),
        unselectedLabelColor: Colors.grey,
        indicatorColor: Color(0xFF2196F3),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF2196F3),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: Color(0xFF2196F3),
        unselectedLabelColor: Colors.grey,
        indicatorColor: Color(0xFF2196F3),
      ),
      cardTheme: const CardTheme(
        color: Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
    );
  }
}

/// 性能监控组件
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const PerformanceMonitor({
    Key? key,
    required this.child,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  int _frameCount = 0;
  DateTime? _startTime;
  double _fps = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _startTime = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Builder(
      builder: (context) {
        return widget.child;
      },
    );
  }

  void _updateFPS() {
    if (_startTime == null) return;

    _frameCount++;
    final now = DateTime.now();
    final elapsed = now.difference(_startTime!).inMilliseconds;

    if (elapsed >= 1000) {
      setState(() {
        _fps = _frameCount / (elapsed / 1000);
        _frameCount = 0;
        _startTime = now;
      });
    }
  }
}

/// 内存使用监控
class MemoryMonitor extends StatefulWidget {
  final Widget child;
  final bool showStats;

  const MemoryMonitor({
    Key? key,
    required this.child,
    this.showStats = false,
  }) : super(key: key);

  @override
  State<MemoryMonitor> createState() => _MemoryMonitorState();
}

class _MemoryMonitorState extends State<MemoryMonitor> {
  String _memoryUsage = '0 MB';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showStats)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '内存: $_memoryUsage',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

void main() {
  runApp(const TabManagementExample());
}