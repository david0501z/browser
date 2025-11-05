import 'package:flutter/material.dart';
import 'pages/bookmarks_page.dart';
import 'pages/history_page.dart';

void main() {
  runApp(const BrowserApp());
}

class BrowserApp extends StatelessWidget {
  const BrowserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '浏览器书签和历史记录',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const BookmarksPage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks),
            label: '书签',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '历史记录',
          ),
        ],
      ),
    );
  }
}