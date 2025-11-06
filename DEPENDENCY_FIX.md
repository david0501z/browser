# 依赖验证和修复指南

## 🔧 已修复的问题

### 1. AndroidManifest.xml - Flutter v2 embedding
✅ **已添加Flutter v2 embedding配置**：
```xml
<meta-data
    android:name="flutterEmbedding"
    android:value="2" />
```

### 2. pubspec.yaml - 移除无效依赖
✅ **已移除有问题的依赖**：
- ❌ `performance_monitor: ^0.1.0` (已移除)
- ✅ 使用Flutter内置性能监控工具

## 📋 当前有效依赖清单

### 核心依赖
- `flutter: sdk` ✅
- `flutter_riverpod: ^2.4.9` ✅
- `flutter_inappwebview: ^6.0.0` ✅

### 数据库和存储
- `sqflite: ^2.3.0` ✅
- `shared_preferences: ^2.2.2` ✅
- `path: ^1.8.3` ✅

### UI和媒体
- `cupertino_icons: ^1.0.2` ✅
- `lottie: ^2.7.0` ✅
- `cached_network_image: ^3.3.0` ✅
- `flutter_svg: ^2.0.9` ✅

### 网络和通信
- `http: ^1.1.2` ✅
- `url_launcher: ^6.2.2` ✅
- `permission_handler: ^11.1.0` ✅

### 数据处理
- `json_annotation: ^4.8.1` ✅
- `crypto: ^3.0.3` ✅
- `encrypt: ^5.0.3` ✅

### 系统信息
- `device_info_plus: ^9.1.1` ✅

## 🧪 验证依赖有效性

### 运行依赖检查
```bash
cd flclash_browser_app
flutter pub deps
```

### 检查特定依赖
```bash
# 检查某个依赖是否存在
flutter pub info flutter_inappwebview
flutter pub info flutter_riverpod
```

## 🚀 重新构建项目

### 清理并重新获取依赖
```bash
flutter clean
flutter pub get
```

### 如果有依赖问题，尝试：
```bash
flutter pub upgrade
flutter pub deps
```

## ⚠️ 常见依赖问题及解决方案

### 问题1: 依赖版本冲突
```bash
# 解决方案
flutter pub upgrade --major-versions
```

### 问题2: 某个依赖不存在
```bash
# 检查依赖是否存在
flutter pub search package_name

# 如果不存在，寻找替代方案
```

### 问题3: 平台特定问题
```bash
# Android特定
flutter pub get
flutter build apk

# iOS特定（如果需要）
cd ios && pod install && cd ..
```

## 🔍 性能监控替代方案

由于移除了 `performance_monitor`，推荐使用：

### 1. Flutter DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### 2. 内置性能监控
- 使用Flutter Inspector
- Performance tab
- Memory tab

### 3. 自定义性能监控
在代码中实现：
```dart
import 'dart:developer';

class PerformanceMonitor {
  static void logPerformance(String operation, Duration duration) {
    log('$operation took ${duration.inMilliseconds}ms');
  }
}
```

## ✅ 验证修复成功

构建成功后，你应该看到：
1. ✅ `flutter build apk` 成功
2. ✅ 没有依赖错误
3. ✅ 应用正常启动

---

**🎯 现在所有依赖问题都已修复，项目应该可以正常构建！**