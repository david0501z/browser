# FlClash 浏览器集成实现

本项目为FlClash实现了内置浏览器功能，通过在现有的Tab结构中添加浏览器选项卡，实现统一的用户体验。浏览器流量将通过FlClash的代理引擎和Android VpnService/TUN通道统一转发，确保所有Web请求遵循应用分流规则与策略选择。

## 🎨 UI布局优化

本项目包含完整的浏览器UI布局优化，基于Material Design 3设计规范，提供现代化的用户界面和响应式布局。

### 核心优化特性
- **Material Design 3** - 遵循最新设计规范
- **响应式布局** - 自适应手机、平板、桌面设备
- **主题切换** - 深色/浅色主题无缝切换
- **动画效果** - 流畅的过渡动画和交互反馈
- **触觉反馈** - 支持Android和iOS触觉反馈

### 优化文件
```
code/
├── themes/
│   └── browser_theme.dart              # 浏览器主题配置
├── widgets/
│   ├── responsive_browser_layout.dart  # 响应式布局组件
│   ├── browser_app_bar.dart            # 浏览器应用栏
│   └── browser_bottom_nav.dart         # 底部导航栏
├── example/
│   └── optimized_browser_example.dart  # 完整使用示例
└── UI_OPTIMIZATION_SUMMARY.md          # 详细优化说明
```

### 快速使用
```dart
import 'themes/browser_theme.dart';
import 'widgets/responsive_browser_layout.dart';
import 'widgets/browser_app_bar.dart';
import 'widgets/browser_bottom_nav.dart';

// 应用主题
MaterialApp(
  theme: BrowserTheme.lightTheme,
  home: ResponsiveBrowserLayout(
    showAppBar: true,
    showToolbar: true,
    showBottomNav: true,
    child: BrowserContent(),
  ),
)
```

详细使用说明请参考 `UI_OPTIMIZATION_SUMMARY.md` 文件。

## 功能特性

### 🌐 浏览器核心功能
- ✅ 多标签页管理（新建、关闭、切换）
- ✅ WebView内容渲染和导航控制
- ✅ 智能搜索栏（URL输入和搜索引擎）
- ✅ 页面加载状态和进度显示
- ✅ 前进、后退、刷新功能

### 🎨 用户界面集成
- ✅ 统一Tab结构（仪表盘、代理、日志、浏览器）
- ✅ 流畅的选项卡切换动画
- ✅ 浏览器专用底部导航栏
- ✅ 浮动操作按钮（FAB）
- ✅ Material Design设计规范

### 🔧 高级功能
- ✅ 书签管理（添加、编辑、删除）
- ✅ 历史记录跟踪和管理
- ✅ 隐私模式（无痕浏览）
- ✅ 丰富的浏览器设置选项
- ✅ 下载管理和通知

### 🔗 代理集成
- ✅ 统一流量路由（通过代理引擎转发）
- ✅ 策略组和分流规则支持
- ✅ VpnService/TUN模式集成
- ✅ 代理状态与浏览器同步

## 文件结构

```
code/
├── models/
│   └── browser_models.dart          # 浏览器数据模型
├── providers/
│   └── browser_providers.dart       # 状态管理Provider
├── widgets/
│   └── browser_tab_widget.dart      # 浏览器标签页组件
└── pages/
    ├── main_page_browser_integration.dart  # 主页面集成
    └── browser_settings_page.dart          # 浏览器设置页面
```

## 核心组件说明

### 1. BrowserTabWidget

浏览器标签页的核心组件，负责WebView内容渲染和用户交互。

#### 主要功能：
- WebView内容渲染
- 导航控制界面（前进、后退、刷新）
- 智能搜索栏（支持URL和搜索词输入）
- 工具栏和菜单功能
- 页面事件处理（加载、错误、控制台等）

#### 使用方法：
```dart
BrowserTabWidget(
  tab: browserTab,
  onClose: () => closeTab(),
  onTitleChanged: (title) => updateTitle(title),
  onUrlChanged: (url) => updateUrl(url),
)
```

### 2. BrowserSettingsPage

浏览器设置页面，提供全面的浏览器配置选项。

#### 主要功能：
- 基本设置（搜索引擎、首页、字体大小）
- 隐私与安全（无痕模式、JavaScript开关、隐私保护）
- 内容设置（图片加载、DOM存储、缓存模式）
- 下载设置（目录选择、通知设置）
- 数据管理（导入/导出、清除数据）

### 3. MainPageBrowserIntegration

主页面集成组件，将浏览器无缝集成到FlClash的Tab结构中。

#### 主要功能：
- 扩展现有Tab结构（添加浏览器选项卡）
- 浏览器选项卡管理
- 浮动操作按钮（FAB）控制
- 底部导航栏（浏览器专用）
- 状态同步和动画效果

### 4. 数据模型

使用Freezed实现不可变数据模型：

#### BrowserTab - 浏览器标签页
```dart
class BrowserTab {
  final String id;              // 唯一标识
  final String url;             // 当前URL
  final String? title;          // 页面标题
  final String? favicon;        // 图标URL
  final bool pinned;            // 是否固定
  final DateTime createdAt;     // 创建时间
  final DateTime updatedAt;     // 更新时间
  final bool incognito;         // 无痕模式
}
```

#### BrowserSettings - 浏览器设置
```dart
class BrowserSettings {
  final String? userAgent;              // 用户代理
  final bool javascriptEnabled;         // JavaScript开关
  final bool domStorageEnabled;         // DOM存储开关
  final String searchEngine;            // 默认搜索引擎
  final bool incognito;                 // 无痕模式
  final int fontSize;                   // 字体大小
  // ... 更多设置项
}
```

### 5. 状态管理

基于Riverpod实现响应式状态管理：

#### 主要Provider：
- `browserSettingsProvider` - 浏览器设置
- `browserTabsProvider` - 标签页列表
- `bookmarksProvider` - 书签管理
- `historyProvider` - 历史记录
- `currentTabProvider` - 当前活动标签页

## 数据模型

### TabData
标签页数据模型，包含以下属性：

```dart
class TabData {
  final String id;              // 唯一标识
  final String title;           // 标题
  final String url;             // URL地址
  final String? faviconUrl;     // 网站图标
  final Uint8List? thumbnail;   // 缩略图
  final bool isLoading;         // 是否正在加载
  final DateTime createdAt;     // 创建时间
  final DateTime lastVisited;   // 最后访问时间
  final int visitCount;         // 访问次数
  final bool isBookmarked;      // 是否已收藏
}
```

## 快速开始

### 1. 集成到现有FlClash项目

在 `pubspec.yaml` 中添加必要的依赖：

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9          # 状态管理
  freezed_annotation: ^2.4.1        # 不可变数据模型
  shared_preferences: ^2.2.2        # 数据持久化
  flutter_inappwebview: ^6.0.0      # WebView组件

dev_dependencies:
  build_runner: ^2.4.7              # 代码生成
  freezed: ^2.4.6                   # 不可变类生成
  json_serializable: ^6.7.1         # JSON序列化
```

### 2. 导入组件

```dart
import 'code/pages/main_page_browser_integration.dart';
import 'code/providers/browser_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

### 3. 基本使用

```dart
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPageBrowserIntegration(),
    );
  }
}
```

### 4. 生成代码

运行代码生成命令：

```bash
flutter packages pub run build_runner build
```

## 高级功能

### 自定义浏览器设置

```dart
final customSettings = BrowserSettings(
  searchEngine: 'https://www.baidu.com/s?wd=',
  fontSize: 18,
  javascriptEnabled: false,
  incognito: true,
);

ref.read(browserSettingsProvider.notifier).updateSettings(customSettings);
```

### 浏览器标签页管理

```dart
// 创建新标签页
ref.read(browserTabsProvider.notifier).addTab(
  BrowserTab(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    url: 'https://example.com',
    title: '示例页面',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
);

// 搜索书签
final searchResults = ref.read(bookmarksProvider.notifier)
  .searchBookmarks('Flutter');
```

### 性能监控和优化

```dart
// 针对Flutter 3.27.x性能问题，在AndroidManifest.xml中禁用Impeller
<meta-data
    android:name="io.flutter.embedding.android.EnableImpeller"
    android:value="false" />

// 使用IndexedStack维持标签页状态，避免重建
IndexedStack(
  index: currentTabIndex,
  children: browserTabs.map((tab) => 
    BrowserTabWidget(tab: tab)
  ).toList(),
)
```

## API 参考

### BrowserTabWidget 方法

| 方法 | 描述 | 参数 |
|------|------|------|
| `_handleSearchSubmitted()` | 处理搜索提交 | String searchText |
| `_refresh()` | 刷新页面 | 无 |
| `_goForward()` | 前进 | 无 |
| `_goBack()` | 后退 | 无 |

### BrowserSettingsNotifier 方法

| 方法 | 描述 | 参数 |
|------|------|------|
| `updateSettings()` | 更新设置 | BrowserSettings newSettings |
| `resetToDefault()` | 重置为默认设置 | 无 |

### BrowserTabsNotifier 方法

| 方法 | 描述 | 参数 |
|------|------|------|
| `addTab()` | 添加新标签页 | BrowserTab tab |
| `removeTab()` | 关闭标签页 | String tabId |
| `updateTab()` | 更新标签页 | String tabId, BrowserTab updatedTab |
| `togglePinTab()` | 切换固定状态 | String tabId |
| `createNewTab()` | 创建新标签页 | String? url, bool incognito |

### BookmarkNotifier 方法

| 方法 | 描述 | 参数 |
||------|------|------|
| `addBookmark()` | 添加书签 | Bookmark bookmark |
| `removeBookmark()` | 删除书签 | String bookmarkId |
| `updateBookmark()` | 更新书签 | Bookmark updatedBookmark |
| `searchBookmarks()` | 搜索书签 | String query |
| `filterByTag()` | 按标签筛选 | String tag |

### HistoryNotifier 方法

| 方法 | 描述 | 参数 |
|------|------|------|
| `addHistory()` | 添加历史记录 | History history |
| `removeHistory()` | 删除历史记录 | String historyId |
| `clearAll()` | 清空历史记录 | 无 |
| `searchHistory()` | 搜索历史记录 | String query |
| `getTodayHistory()` | 获取今日历史 | 无 |

## 性能优化建议

### 1. 内存管理
- 及时释放不需要的WebView实例
- 使用`IndexedStack`维持标签页状态
- 限制同时显示的标签页数量
- 定期清理历史记录和缓存

### 2. 渲染优化
- 使用`const`构造函数
- 避免在build方法中创建新对象
- 使用`RepaintBoundary`优化重绘
- 针对Flutter 3.27.x禁用Impeller

### 3. 数据持久化
- 使用`SharedPreferences`存储轻量配置
- JSON文件存储标签页和书签数据
- 定期清理过期数据
- 压缩存储的缩略图

## 性能优化系统

本系统为浏览器提供了完整的性能监控、内存管理、缓存优化和后台服务管理功能。

### 核心组件

#### 1. PerformanceService (性能服务)
- **位置**: `code/services/performance_service.dart`
- **功能**: 性能监控、指标收集、事件管理
- **特性**:
  - 实时性能指标监控
  - 内存使用率追踪
  - 性能事件流
  - 自动垃圾回收建议
  - 性能报告生成

#### 2. MemoryManager (内存管理器)
- **位置**: `code/utils/memory_manager.dart`
- **功能**: 内存管理、泄漏检测、对象池
- **特性**:
  - 对象池和内存池管理
  - 内存泄漏自动检测
  - 内存快照和历史追踪
  - 强制内存清理
  - 垃圾回收建议

#### 3. CacheManager (缓存管理器)
- **位置**: `code/utils/cache_manager.dart`
- **功能**: 智能缓存策略、LRU缓存、磁盘缓存
- **特性**:
  - 双重缓存策略（内存+磁盘）
  - LRU算法自动清理
  - 缓存命中率统计
  - TTL过期机制
  - 缓存预热功能

#### 4. PerformanceMonitor (性能监控Widget)
- **位置**: `code/widgets/performance_monitor.dart`
- **功能**: 实时性能监控界面、调试工具
- **特性**:
  - 实时性能指标显示
  - 可视化性能监控面板
  - 内存、缓存、事件监控
  - FPS实时监控
  - 性能事件日志

#### 5. BackgroundService (后台服务)
- **位置**: `code/services/background_service.dart`
- **功能**: 后台标签页管理、冻结机制、智能优化
- **特性**:
  - 后台标签页自动管理
  - 智能冻结机制
  - 内存优化任务队列
  - 应用生命周期管理
  - 标签页合并优化

### 使用方法

#### 1. 初始化性能系统

```dart
import 'code/services/performance_service.dart';
import 'code/services/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化性能服务
  await PerformanceService().initialize();
  
  // 初始化后台服务
  await BackgroundService().initialize();
  
  runApp(MyApp());
}
```

#### 2. 包装应用组件

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PerformanceMonitor(
      showOverlay: true,
      enableDebugMode: true,
      child: MaterialApp(
        title: '高性能浏览器',
        home: BrowserHomePage(),
      ),
    );
  }
}
```

#### 3. 性能测量

```dart
// 开始测量
final measureId = PerformanceService().startMeasure('webview_load');

// 结束测量
PerformanceService().endMeasure(measureId);
```

#### 4. 内存管理

```dart
// 获取内存信息
final memoryInfo = MemoryManager().getCurrentMemoryInfo();

// 强制内存清理
MemoryManager().forceCleanup();

// 跟踪内存分配
MemoryManager().trackAllocation('webview', 1024 * 1024);
```

#### 5. 缓存操作

```dart
// 存储数据
await CacheManager().put('key', data, ttl: Duration(hours: 1));

// 获取数据
final data = await CacheManager().get('key');

// 清理过期缓存
CacheManager().clearOldestEntries();
```

#### 6. 后台标签页管理

```dart
// 添加后台标签页
BackgroundService().addBackgroundTab('tab_1', TabInfo(
  id: 'tab_1',
  url: 'https://example.com',
  title: 'Example',
));

// 冻结标签页
BackgroundService().freezeTab('tab_1');

// 更新访问时间
BackgroundService().updateTabAccessTime('tab_1');
```

### 性能优化特性

#### 智能内存管理
- **对象池**: 复用常用对象，减少GC压力
- **内存泄漏检测**: 自动识别异常内存增长
- **内存压缩**: 定期执行内存整理
- **阈值监控**: 动态调整清理策略

#### 高效缓存策略
- **双重缓存**: 内存缓存 + 磁盘缓存
- **LRU算法**: 智能淘汰最少使用的缓存
- **TTL机制**: 自动清理过期数据
- **缓存预热**: 提前加载常用数据

#### 后台优化机制
- **标签页冻结**: 自动冻结不活跃标签页
- **内存阈值**: 基于内存使用情况优化
- **任务队列**: 批量执行优化任务
- **生命周期管理**: 响应应用状态变化

#### 实时监控
- **性能指标**: FPS、CPU、内存使用率
- **事件追踪**: 完整的事件日志
- **可视化界面**: 直观的性能监控面板
- **调试工具**: 开发模式下的详细调试信息

### 配置选项

#### 性能服务配置
```dart
PerformanceConfig(
  monitoringInterval: Duration(seconds: 5),
  eventRetentionPeriod: Duration(hours: 24),
  memoryWarningThreshold: 80.0,
  maxCacheSize: 100 * 1024 * 1024, // 100MB
  maxMemoryCache: 50 * 1024 * 1024, // 50MB
  defaultThreshold: 1000.0,
)
```

#### 内存管理配置
```dart
MemoryConfig(
  cleanupInterval: Duration(minutes: 5),
  leakDetectionThreshold: 50.0, // 50MB
  gcTriggerThreshold: 85.0, // 85%
  maxSnapshots: 100,
)
```

#### 后台服务配置
```dart
BackgroundConfig(
  cleanupInterval: Duration(minutes: 10),
  freezeCheckInterval: Duration(minutes: 2),
  memoryCheckInterval: Duration(minutes: 5),
  freezeThreshold: Duration(minutes: 15),
  cleanupThreshold: Duration(hours: 2),
  maxBackgroundTabs: 10,
  memoryFreezeThreshold: 50.0, // 50MB
  totalMemoryThreshold: 200.0, // 200MB
)
```

### 最佳实践

1. **定期监控**: 建议在开发阶段开启详细监控
2. **合理配置**: 根据设备性能调整阈值参数
3. **及时清理**: 在适当时机手动触发清理
4. **事件追踪**: 关注性能事件和异常情况
5. **内存优化**: 定期检查内存使用趋势

### 注意事项

- 性能监控会有一定的性能开销，生产环境建议关闭详细监控
- 缓存大小需要根据设备存储空间合理设置
- 后台标签页数量不宜过多，建议不超过20个
- 内存泄漏检测需要一定的历史数据才能准确判断

### 扩展功能

系统支持以下扩展功能：
- 自定义性能指标
- 第三方监控集成
- 性能报告导出
- 远程性能分析
- 自动化性能测试

通过这套完整的性能优化系统，可以显著提升浏览器的运行效率和用户体验。

## 故障排除

### 常见问题

**Q: WebView页面导航缓慢？**
A: Flutter 3.27.x下可能出现Impeller性能问题，解决方案：
1. 在AndroidManifest.xml中禁用Impeller
2. 或降级到Flutter 3.24.5
3. 关闭混合合成模式

**Q: 浏览器流量不走代理？**
A: 确保：
1. VpnService权限已授权
2. 代理服务正在运行
3. 浏览器设置为使用系统代理

**Q: 标签页状态丢失？**
A: 检查：
1. 数据持久化是否正常工作
2. App生命周期管理
3. 状态恢复逻辑

**Q: 内存使用过高？**
A: 优化建议：
1. 限制缩略图大小和数量
2. 及时释放不需要的WebView
3. 定期清理历史记录

### 调试技巧

```dart
// 启用详细日志
final settings = ref.read(browserSettingsProvider);
debugPrint('当前设置: ${settings.toJson()}');

// 监控标签页状态
ref.listen(browserTabsProvider, (previous, next) {
  print('标签页数量变化: ${previous.length} -> ${next.length}');
});
```

## 配置要求

### 1. Android权限
在AndroidManifest.xml中添加：
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```

### 2. Flutter配置
针对性能问题，在android/app/src/main/AndroidManifest.xml中添加：
```xml
<meta-data
    android:name="io.flutter.embedding.android.EnableImpeller"
    android:value="false" />
```

## 开发计划

### Phase 1: 基础功能 ✅
- [x] 浏览器标签页组件
- [x] WebView集成
- [x] 基础导航功能
- [x] 设置页面

### Phase 2: 高级功能 🔄
- [ ] 书签管理
- [ ] 历史记录
- [ ] 下载管理
- [ ] 隐私模式

### Phase 3: 代理集成 ⏳
- [ ] FFI桥接
- [ ] VpnService集成
- [ ] 流量路由
- [ ] 策略组支持

### Phase 4: 优化完善 📋
- [ ] 性能优化
- [ ] 错误处理
- [ ] 用户体验优化
- [ ] 文档完善

## 贡献指南

欢迎提交 Issue 和 Pull Request！

### 开发环境
- Flutter 3.24.5+ (推荐) 或 3.27.x (需禁用Impeller)
- Dart 3.0+
- Android SDK

### 测试
```bash
flutter test
flutter test --coverage
# 生成代码
flutter packages pub run build_runner build
```

### 代码规范
- 遵循 Dart 官方代码规范
- 使用Freezed实现不可变数据模型
- 遵循Riverpod状态管理最佳实践
- 添加适当的注释和文档

## 许可证

本项目基于FlClash项目许可证，遵循相同的开源协议。

## 更新日志

### v1.1.0 - UI布局优化版本
- ✨ 新增现代化UI组件系统
- ✨ Material Design 3设计规范支持
- ✨ 响应式布局适配多设备
- ✨ 深色/浅色主题切换功能
- ✨ 流畅动画和触觉反馈
- ✨ 浏览器应用栏优化
- ✨ 增强底部导航栏
- ✨ 完整使用示例和文档

### v1.0.0
- 初始版本发布
- 浏览器标签页管理功能
- 统一Tab结构集成
- 基础导航和设置功能
- 状态管理和数据模型

---

更多详细信息请查看源代码注释和示例文件。

## 已知问题

### Flutter 3.27.x性能问题
- **现象**: WebView页面导航缓慢
- **解决方案**: 禁用Impeller或降级到3.24.5
- **状态**: 已提供配置方案

### Android VpnService生命周期
- **现象**: 停止连接后服务可能未完全停止
- **解决方案**: 状态机+二次停止兜底
- **状态**: 需要在集成阶段验证