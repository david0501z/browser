# FlClash浏览器数据模型

## 概述

本项目为FlClash浏览器功能创建了完整的数据模型，提供了类型安全、功能丰富的浏览器相关数据结构。所有模型都基于Flutter/Dart开发，使用freezed实现不可变数据类，支持完整的JSON序列化。

## 数据模型列表

### 1. BrowserTab (浏览器标签页模型)

**文件**: `browser_tab.dart`

**功能**:
- 表示浏览器标签页的完整状态信息
- 支持固定标签页、无痕模式等特性
- 包含页面加载状态、安全状态等元数据
- 提供丰富的扩展方法和工具函数

**主要字段**:
- `id`: 标签页唯一标识
- `url`: 当前页面URL
- `title`: 页面标题
- `favicon`: 页面图标
- `pinned`: 是否固定
- `incognito`: 是否无痕模式
- `isLoading`: 是否正在加载
- `securityStatus`: 安全状态
- `createdAt/updatedAt`: 时间戳

**特色功能**:
- 自动提取域名和显示标题
- 安全状态检测和显示
- 搜索引擎和社交媒体识别
- URL有效性验证

### 2. Bookmark (书签模型)

**文件**: `bookmark.dart`

**功能**:
- 管理浏览器书签信息
- 支持标签分类和文件夹组织
- 提供书签搜索和排序功能
- 包含访问统计和安全状态

**主要字段**:
- `id`: 书签唯一标识
- `title`: 书签标题
- `url`: 链接地址
- `tags`: 标签列表
- `folder`: 所属文件夹
- `visitCount`: 访问次数
- `isFavorite`: 是否收藏
- `websiteType`: 网站类型

**特色功能**:
- 自动网站类型检测
- 全文搜索支持
- 智能排序和分类
- 书签验证和去重

### 3. HistoryEntry (历史记录模型)

**文件**: `history_entry.dart`

**功能**:
- 记录浏览器访问历史
- 包含详细的访问统计信息
- 支持多种页面类型识别
- 提供访问时长和数据传输统计

**主要字段**:
- `id`: 历史记录唯一标识
- `title`: 页面标题
- `url`: 访问URL
- `visitedAt`: 访问时间
- `duration`: 停留时长(秒)
- `deviceType`: 设备类型
- `loadStatus`: 加载状态
- `dataTransferred`: 数据传输量

**特色功能**:
- 智能停留时长计算
- 页面类型自动识别
- 访问来源追踪
- 设备类型检测

### 4. BrowserSettings (浏览器设置模型)

**文件**: `browser_settings.dart`

**功能**:
- 管理浏览器所有配置选项
- 支持隐私模式和安全设置
- 提供代理配置和扩展管理
- 包含高级设置和同步选项

**主要字段**:
- `userAgent`: 用户代理
- `javascriptEnabled`: JavaScript开关
- `cacheMode`: 缓存模式
- `incognito`: 无痕模式
- `privacyMode`: 隐私模式
- `adBlockEnabled`: 广告拦截
- `proxySettings`: 代理设置
- `syncSettings`: 同步设置

**特色功能**:
- 预设配置模板(隐私模式、开发者模式等)
- 设置验证和错误检查
- 智能推荐配置
- 完整的扩展支持

## 技术特性

### 1. 不可变性设计
- 使用freezed实现不可变数据类
- 提供copyWith方法进行状态更新
- 确保线程安全和数据一致性

### 2. JSON序列化支持
- 完整的fromJson/toJson实现
- 支持数据持久化和传输
- 兼容旧版本数据格式

### 3. 类型安全
- 强类型定义，减少运行时错误
- 枚举类型确保状态一致性
- 泛型支持复杂数据结构

### 4. 扩展方法
- 为每个模型提供丰富的扩展方法
- 增强模型功能，不修改原始类
- 提供便捷的实用工具

### 5. 工具类支持
- 每个模型都有对应的工具类
- 提供创建、验证、转换等方法
- 包含智能检测和自动分类功能

## 使用方法

### 基本导入
```dart
import 'browser_models_detailed.dart';
```

### 创建模型实例
```dart
// 创建浏览器标签页
final tab = BrowserTab(
  id: 'tab_123',
  url: 'https://example.com',
  title: '示例网站',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// 创建书签
final bookmark = Bookmark(
  id: 'bm_456',
  title: '示例书签',
  url: 'https://example.com',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// 创建设置
final settings = BrowserSettings(
  javascriptEnabled: true,
  cacheMode: CacheMode.defaultCache,
);
```

### 使用工具方法
```dart
// 使用工具类创建实例
final tab = BrowserTabUtils.create(
  url: 'https://flutter.dev',
  title: 'Flutter官网',
);

final bookmark = BookmarkUtils.createFromUrl(
  url: 'https://github.com',
);

final history = HistoryEntryUtils.createFromUrl(
  url: 'https://docs.flutter.dev',
  title: 'Flutter文档',
);

// 使用预设配置
final privacySettings = BrowserSettingsUtils.createPrivacyMode();
final devSettings = BrowserSettingsUtils.createDeveloperMode();
```

### 数据验证
```dart
// 验证设置配置
final errors = BrowserSettingsUtils.validateSettings(settings);
if (errors.isNotEmpty) {
  print('配置错误: $errors');
}
```

### JSON序列化
```dart
// 序列化
final json = tab.toJson();

// 反序列化
final fromJson = BrowserTab.fromJson(json);
```

## 集成指南

### 1. 添加依赖
在`pubspec.yaml`中添加必要依赖：
```yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  build_runner: ^2.4.7
```

### 2. 生成代码
运行代码生成器：
```bash
flutter packages pub run build_runner build
```

### 3. 状态管理集成
可以与Riverpod、Provider等状态管理方案结合使用：
```dart
// Riverpod示例
final browserTabProvider = StateProvider<BrowserTab>((ref) {
  return BrowserTabUtils.create(url: 'about:blank');
});

final bookmarksProvider = StateNotifierProvider<BookmarkNotifier, List<Bookmark>>((ref) {
  return BookmarkNotifier();
});
```

### 4. 数据持久化
结合shared_preferences、sqflite等实现数据持久化：
```dart
// SharedPreferences示例
final prefs = await SharedPreferences.getInstance();
await prefs.setString('browser_settings', jsonEncode(settings.toJson()));

// SQLite示例
final db = await openDatabase('browser.db');
await db.insert('bookmarks', bookmark.toJson());
```

## 最佳实践

### 1. 模型使用
- 优先使用工具类创建模型实例
- 利用扩展方法简化常用操作
- 及时进行数据验证

### 2. 性能优化
- 使用不可变对象减少内存占用
- 合理使用copyWith避免对象重建
- 批量操作时考虑使用集合方法

### 3. 错误处理
- 始终验证输入数据
- 使用try-catch处理JSON解析错误
- 提供合理的默认值

### 4. 测试建议
- 为每个模型编写单元测试
- 测试JSON序列化/反序列化
- 验证工具方法的正确性

## 扩展指南

### 1. 添加新字段
在模型中添加新字段时：
1. 在抽象类中定义字段
2. 添加适当的默认值
3. 更新fromJson/toJson方法
4. 更新相关扩展方法

### 2. 添加新枚举
定义新的枚举类型：
1. 使用`enum`关键字定义
2. 添加到相关模型中
3. 更新扩展方法处理新枚举

### 3. 添加新工具方法
在工具类中添加实用方法：
1. 保持方法的纯函数特性
2. 添加完整的文档注释
3. 包含适当的错误处理

## 兼容性

- **Flutter版本**: 3.0+
- **Dart版本**: 3.0+
- **平台支持**: Android、iOS、Web、Desktop
- **依赖包**: freezed_annotation, json_annotation

## 许可证

本项目遵循FlClash项目的许可证条款。

## 贡献

欢迎提交Issue和Pull Request来改进这些数据模型。

## 更新日志

### v1.0.0
- 初始版本发布
- 实现四个核心数据模型
- 添加完整的文档和示例
- 支持JSON序列化和工具方法