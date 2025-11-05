# FlClash浏览器部署指南

## 目录
1. [部署概述](#部署概述)
2. [环境准备](#环境准备)
3. [开发环境部署](#开发环境部署)
4. [测试环境部署](#测试环境部署)
5. [生产环境部署](#生产环境部署)
6. [持续集成/持续部署](#持续集成持续部署)
7. [监控与维护](#监控与维护)
8. [故障排除](#故障排除)
9. [性能优化](#性能优化)
10. [安全配置](#安全配置)

## 部署概述

### 部署架构

FlClash浏览器采用多环境部署架构，支持开发、测试、预发布和生产环境的完整部署流程。

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   开发环境      │    │   测试环境      │    │   生产环境      │
│   Development   │    │   Testing       │    │   Production    │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • 本地开发      │    │ • 集成测试      │    │ • 正式发布      │
│ • 快速迭代      │    │ • 自动化测试    │    │ • 用户访问      │
│ • 调试模式      │    │ • 性能测试      │    │ • 监控告警      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   CI/CD Pipeline │
                    │   持续集成部署   │
                    └─────────────────┘
```

### 部署策略

#### 1. 蓝绿部署 (Blue-Green Deployment)
- **优势**: 零停机时间，快速回滚
- **适用**: 重大版本更新
- **流程**: 
  1. 部署新版本到"绿"环境
  2. 验证功能正常
  3. 切换流量到"绿"环境
  4. 原"蓝"环境作为备份

#### 2. 滚动部署 (Rolling Deployment)
- **优势**: 渐进式更新，风险较低
- **适用**: 小版本更新
- **流程**:
  1. 分批次更新实例
  2. 每批次验证功能
  3. 异常时自动回滚

#### 3. 金丝雀部署 (Canary Deployment)
- **优势**: 小范围验证，降低风险
- **适用**: 新功能测试
- **流程**:
  1. 先发布给少量用户
  2. 监控关键指标
  3. 逐步扩大发布范围

### 部署环境矩阵

| 环境类型 | 用途 | 部署频率 | 验证方式 | 回滚策略 |
|---------|------|----------|----------|----------|
| 开发环境 | 本地开发 | 实时 | 手动测试 | 重新部署 |
| 测试环境 | 集成测试 | 每日 | 自动化测试 | 自动回滚 |
| 预发布环境 | 验收测试 | 每周 | 手动验收 | 快速回滚 |
| 生产环境 | 用户访问 | 定期 | 监控告警 | 蓝绿回滚 |

## 环境准备

### 系统要求

#### 开发环境要求
- **操作系统**: Windows 10+, macOS 10.15+, Ubuntu 18.04+
- **硬件配置**: 
  - CPU: 4核心以上
  - 内存: 8GB以上
  - 存储: 50GB以上可用空间
- **网络**: 稳定的互联网连接

#### 生产环境要求
- **服务器配置**:
  - CPU: 8核心以上
  - 内存: 16GB以上
  - 存储: 100GB以上SSD
  - 网络: 100Mbps以上带宽

#### 移动设备要求
- **Android**: 6.0+ (API 23+), 2GB+ RAM
- **iOS**: 11.0+, iPhone 6s+/iPad Air 2+

### 开发工具安装

#### 1. Flutter SDK安装

**Windows环境**
```powershell
# 下载Flutter SDK
$ flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.0-stable.zip"
Invoke-WebRequest -Uri $flutterUrl -OutFile "flutter.zip"

# 解压到指定目录
Expand-Archive -Path "flutter.zip" -DestinationPath "C:\flutter"

# 添加到PATH环境变量
$env:PATH += ";C:\flutter\bin"

# 验证安装
flutter doctor
```

**macOS/Linux环境**
```bash
# 下载Flutter SDK
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz

# 解压
tar xf flutter_linux_3.16.0-stable.tar.xz

# 添加到PATH
export PATH="$PATH:`pwd`/flutter/bin"

# 验证安装
flutter doctor
```

#### 2. IDE配置

**Android Studio配置**
```bash
# 安装必要插件
# - Flutter
# - Dart
# - Android SDK
# - IntelliJ IDEA

# 配置SDK路径
# File > Settings > Appearance & Behavior > System Settings > Android SDK
# 设置Android SDK Location
```

**VS Code配置**
```json
{
  "extensions": [
    "dart-code.dart-code",
    "dart-code.flutter",
    "ms-vscode.vscode-typescript-next",
    "bradlc.vscode-tailwindcss",
    "ms-vscode.vscode-json"
  ],
  "settings": {
    "dart.lineLength": 80,
    "editor.formatOnSave": true,
    "files.associations": {
      "*.dart": "dart"
    },
    "dart.openDevTools": "flutter",
    "flutter.deviceId": "chrome"
  }
}
```

#### 3. 依赖工具安装

```bash
# 安装Git
# Windows: 从官网下载安装
# macOS: brew install git
# Ubuntu: sudo apt install git

# 安装Node.js (用于CI/CD)
# 从官网下载LTS版本

# 安装Docker (可选)
# 用于容器化部署
```

### 环境变量配置

#### 开发环境变量
```bash
# .env.development
APP_ENV=development
API_BASE_URL=http://localhost:3000
DEBUG_MODE=true
LOG_LEVEL=debug
DATABASE_URL=sqlite:///browser_dev.db

# 应用配置
APP_NAME=FlClash Browser Dev
APP_VERSION=1.0.0-dev
APP_BUILD_NUMBER=1

# 功能开关
ENABLE_ANALYTICS=false
ENABLE_CRASH_REPORTING=false
ENABLE_PERFORMANCE_MONITORING=true
```

#### 生产环境变量
```bash
# .env.production
APP_ENV=production
API_BASE_URL=https://api.flclash.com
DEBUG_MODE=false
LOG_LEVEL=error
DATABASE_URL=sqlite:///browser_prod.db

# 应用配置
APP_NAME=FlClash Browser
APP_VERSION=1.0.0
APP_BUILD_NUMBER=1001

# 功能开关
ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true
ENABLE_PERFORMANCE_MONITORING=true
```

## 开发环境部署

### 本地开发设置

#### 1. 项目初始化

```bash
# 克隆项目
git clone <repository-url>
cd flclash_browser

# 获取依赖
flutter pub get

# 生成代码
flutter packages pub run build_runner build

# 运行代码检查
flutter analyze

# 运行测试
flutter test
```

#### 2. 调试配置

**Android调试配置**
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<application
    android:label="FlClash Browser Dev"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher"
    android:debuggable="true">
    
    <activity
        android:name=".MainActivity"
        android:exported="true"
        android:launchMode="singleTop"
        android:theme="@style/LaunchTheme"
        android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
        android:hardwareAccelerated="true"
        android:windowSoftInputMode="adjustResize">
        
        <meta-data
          android:name="io.flutter.embedding.android.NormalTheme"
          android:resource="@style/NormalTheme" />
          
        <intent-filter>
            <action android:name="android.intent.action.MAIN"/>
            <category android:name="android.intent.category.LAUNCHER"/>
        </intent-filter>
    </activity>
</application>
```

**iOS调试配置**
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleName</key>
<string>FlClash Browser Dev</string>
<key>CFBundleDisplayName</key>
<string>FlClash Browser Dev</string>
<key>CFBundleIdentifier</key>
<string>com.flclash.browser.dev</string>
<key>CFBundleVersion</key>
<string>1</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0-dev</string>
```

#### 3. 启动开发服务器

```bash
# 启动热重载开发服务器
flutter run

# 指定设备
flutter run -d <device-id>

# 调试模式
flutter run --debug

# 发布模式预览
flutter run --release

# Web平台调试
flutter run -d chrome --debug
```

### 开发工作流

#### 1. 代码提交前检查

```bash
#!/bin/bash
# pre-commit.sh

echo "运行代码分析..."
flutter analyze

echo "运行测试..."
flutter test

echo "检查代码格式..."
dart format --set-exit-if-changed .

echo "生成代码..."
flutter packages pub run build_runner build --delete-conflicting-outputs

echo "所有检查通过！"
```

#### 2. 分支管理策略

```bash
# 功能开发分支
git checkout -b feature/bookmark-management
git checkout -b feature/history-tracking
git checkout -b feature/settings-page

# 修复分支
git checkout -b bugfix/memory-leak
git checkout -b bugfix/ui-crash

# 发布分支
git checkout -b release/v1.0.0
git checkout -b hotfix/v1.0.1
```

## 测试环境部署

### 自动化测试环境

#### 1. 测试设备配置

```yaml
# test_devices.yaml
devices:
  android:
    - name: "Pixel 5 API 30"
      model: "Pixel 5"
      api_level: 30
      resolution: "1080x2340"
    - name: "Samsung Galaxy S21 API 29"
      model: "Galaxy S21"
      api_level: 29
      resolution: "1080x2400"
    - name: "Xiaomi Mi 11 API 28"
      model: "Mi 11"
      api_level: 28
      resolution: "1080x2340"
  
  ios:
    - name: "iPhone 13 Pro iOS 15"
      model: "iPhone13,3"
      ios_version: "15.0"
      resolution: "1170x2532"
    - name: "iPhone 12 iOS 14"
      model: "iPhone13,2"
      ios_version: "14.0"
      resolution: "1170x2532"
    - name: "iPad Air 4 iOS 15"
      model: "iPad13,1"
      ios_version: "15.0"
      resolution: "1640x2360"
```

#### 2. 自动化测试脚本

```bash
#!/bin/bash
# test_runner.sh

set -e

echo "开始自动化测试..."

# 清理之前的测试结果
rm -rf test_results
mkdir -p test_results

# 运行单元测试
echo "运行单元测试..."
flutter test --coverage --coverage=lcov.info
cp coverage/lcov.info test_results/unit_coverage.lcov

# 运行Widget测试
echo "运行Widget测试..."
flutter test test/widget_test.dart
cp test_results/unit_coverage.lcov test_results/widget_coverage.lcov

# 运行集成测试
echo "运行集成测试..."
flutter drive --target=test_driver/app.dart --coverage

# 生成测试报告
echo "生成测试报告..."
dart test/coverage_report.dart

echo "测试完成！结果保存在 test_results/ 目录"
```

#### 3. 性能测试配置

```dart
// test/performance_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flclash_browser/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('性能测试', () {
    testWidgets('应用启动性能测试', (tester) async {
      final binding = tester.binding;
      
      // 记录启动时间
      final timeline = await binding.traceAction(() async {
        app.main();
      });
      
      final summary = TimelineSummary.summarize(timeline);
      final summaryJson = summary.summaryJson;
      
      // 验证启动时间 < 3秒
      final startTime = summaryJson['traceEvents'][0]['ts'];
      final endTime = summaryJson['traceEvents'].last['ts'];
      final duration = (endTime - startTime) / 1000.0; // 转换为秒
      
      expect(duration, lessThan(3.0));
    });
    
    testWidgets('页面切换性能测试', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // 测试书签页面切换
      final bookmarkTab = find.byIcon(Icons.bookmarks);
      await tester.tap(bookmarkTab);
      await tester.pumpAndSettle();
      
      // 测试历史记录页面切换
      final historyTab = find.byIcon(Icons.history);
      await tester.tap(historyTab);
      await tester.pumpAndSettle();
      
      // 验证切换流畅性
      expect(find.text('历史记录'), findsOneWidget);
    });
  });
}
```

### 测试环境部署脚本

```bash
#!/bin/bash
# deploy_test.sh

set -e

APP_NAME="flclash-browser-test"
VERSION="1.0.0-test-$(date +%Y%m%d-%H%M%S)"

echo "部署测试环境: $APP_NAME v$VERSION"

# 构建测试版本
echo "构建测试版本..."
flutter build apk --debug --target=test

# 部署到测试设备
echo "部署到测试设备..."
adb install -r build/app/outputs/flutter-apk/app-debug.apk

# 运行自动化测试
echo "运行自动化测试..."
./test_runner.sh

# 生成测试报告
echo "生成测试报告..."
./scripts/generate_test_report.sh

echo "测试环境部署完成！"
```

## 生产环境部署

### 构建配置

#### 1. Android生产构建

```yaml
# android/app/build.gradle
android {
    compileSdkVersion 34
    minSdkVersion 23
    targetSdkVersion 34
    versionCode 1001
    versionName "1.0.0"

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.release
        }

        debug {
            debuggable true
            minifyEnabled false
            shrinkResources false
        }
    }

    flavorDimensions "environment"
    productFlavors {
        development {
            dimension "environment"
            applicationId "com.flclash.browser.dev"
            resValue "string", "app_name", "FlClash Browser Dev"
        }
        production {
            dimension "environment"
            applicationId "com.flclash.browser"
            resValue "string", "app_name", "FlClash Browser"
        }
    }
}
```

#### 2. iOS生产构建

```xml
<!-- ios/Runner.xcodeproj/project.pbxproj -->
<key>CFBundleDisplayName</key>
<string>FlClash Browser</string>
<key>CFBundleIdentifier</key>
<string>com.flclash.browser</string>
<key>CFBundleName</key>
<string>FlClash Browser</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
<key>CFBundleVersion</key>
<string>1001</string>
<key>LSRequiresIPhoneOS</key>
<true/>
<key>UILaunchStoryboardName</key>
<string>LaunchScreen</string>
<key>UIMainStoryboardFile</key>
<string>Main</string>
<key>UIRequiredDeviceCapabilities</key>
<array>
    <string>armv7</string>
</array>
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
    <string>UIInterfaceOrientationLandscapeLeft</string>
    <string>UIInterfaceOrientationLandscapeRight</string>
</array>
```

### 应用签名

#### 1. 生成密钥库

```bash
# 生成发布密钥库
keytool -genkey -v -keystore ~/flclash-release-key.keystore -alias flclash -keyalg RSA -keysize 2048 -validity 10000

# 密钥库信息示例
# 密码: your_keystore_password
# 姓名: FlClash Team
# 组织: FlClash
# 城市: Beijing
# 省份: Beijing
# 国家: CN
```

#### 2. 密钥库配置

```properties
# android/key.properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=flclash
storeFile=/path/to/flclash-release-key.keystore
```

#### 3. 环境变量设置

```bash
# ~/.bashrc 或 ~/.zshrc
export FLCLASH_KEYSTORE_PASSWORD="your_keystore_password"
export FLCLASH_KEY_PASSWORD="your_key_password"
export FLCLASH_KEY_ALIAS="flclash"
```

### 构建脚本

#### 1. 自动化构建脚本

```bash
#!/bin/bash
# build_release.sh

set -e

VERSION=$1
BUILD_NUMBER=$2

if [ -z "$VERSION" ] || [ -z "$BUILD_NUMBER" ]; then
    echo "用法: $0 <version> <build_number>"
    echo "示例: $0 1.0.0 1001"
    exit 1
fi

echo "开始构建生产版本 v$VERSION ($BUILD_NUMBER)"

# 清理构建目录
echo "清理构建目录..."
flutter clean
flutter pub get

# 生成代码
echo "生成代码..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# 运行测试
echo "运行测试..."
flutter test

# 代码分析
echo "代码分析..."
flutter analyze

# 构建Android APK
echo "构建Android APK..."
flutter build apk --release \
    --build-number=$BUILD_NUMBER \
    --build-name=$VERSION

# 构建Android App Bundle
echo "构建Android App Bundle..."
flutter build appbundle --release \
    --build-number=$BUILD_NUMBER \
    --build-name=$VERSION

# 构建iOS (需要macOS环境)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "构建iOS应用..."
    flutter build ios --release \
        --build-number=$BUILD_NUMBER \
        --build-name=$VERSION \
        --no-codesign
    
    # 导出IPA
    xcodebuild -workspace ios/Runner.xcworkspace \
        -scheme Runner \
        -configuration Release \
        -archivePath build/Runner.xcarchive \
        archive
    
    xcodebuild -exportArchive \
        -archivePath build/Runner.xcarchive \
        -exportPath build/ios \
        -exportOptionsPlist ios/ExportOptions.plist
fi

echo "构建完成！"
echo "Android APK: build/app/outputs/flutter-apk/app-release.apk"
echo "Android AAB: build/app/outputs/bundle/release/app-release.aab"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "iOS IPA: build/ios/Runner.ipa"
fi
```

#### 2. 版本发布脚本

```bash
#!/bin/bash
# release.sh

set -e

VERSION=$1
BUILD_NUMBER=$2

if [ -z "$VERSION" ] || [ -z "$BUILD_NUMBER" ]; then
    echo "用法: $0 <version> <build_number>"
    exit 1
fi

echo "发布版本 v$VERSION ($BUILD_NUMBER)"

# 构建应用
./build_release.sh $VERSION $BUILD_NUMBER

# 创建发布包
echo "创建发布包..."
mkdir -p release/$VERSION
cp build/app/outputs/flutter-apk/app-release.apk release/$VERSION/
cp build/app/outputs/bundle/release/app-release.aab release/$VERSION/

if [[ "$OSTYPE" == "darwin"* ]]; then
    cp build/ios/Runner.ipa release/$VERSION/
fi

# 生成校验和
cd release/$VERSION
sha256sum *.apk *.aab *.ipa > checksums.txt
cd ../..

# 创建发布说明
cat > release/$VERSION/RELEASE_NOTES.md << EOF
# FlClash浏览器 v$VERSION 发布说明

## 版本信息
- 版本号: $VERSION
- 构建号: $BUILD_NUMBER
- 发布日期: $(date +%Y-%m-%d)

## 主要功能
- 书签管理功能
- 历史记录追踪
- 浏览器设置
- 响应式界面

## 技术改进
- 性能优化
- 内存使用优化
- 稳定性改进

## 文件校验
\`\`\`
$(cat release/$VERSION/checksums.txt)
\`\`\`

## 下载链接
- Android APK: [app-release.apk](app-release.apk)
- Android AAB: [app-release.aab](app-release.aab)
EOF

echo "发布包已创建: release/$VERSION/"
```

### 应用商店发布

#### 1. Google Play商店发布

```bash
#!/bin/bash
# publish_play_store.sh

set -e

VERSION=$1
BUILD_NUMBER=$2

if [ -z "$VERSION" ] || [ -z "$BUILD_NUMBER" ]; then
    echo "用法: $0 <version> <build_number>"
    exit 1
fi

echo "发布到Google Play商店 v$VERSION"

# 上传App Bundle
echo "上传App Bundle..."
bundletool build-apks --bundle=build/app/outputs/bundle/release/app-release.aab \
    --output=app.apks \
    --connected-device

# 使用fastlane发布 (需要配置fastlane)
echo "使用fastlane发布..."
cd android
fastlane beta version:$VERSION build:$BUILD_NUMBER
cd ..

echo "Google Play发布完成！"
```

#### 2. Apple App Store发布

```bash
#!/bin/bash
# publish_app_store.sh

set -e

VERSION=$1
BUILD_NUMBER=$2

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "错误: iOS发布只能在macOS上进行"
    exit 1
fi

echo "发布到Apple App Store v$VERSION"

# 使用fastlane发布
echo "使用fastlane发布..."
cd ios
fastlane beta version:$VERSION build:$BUILD_NUMBER
cd ..

echo "App Store发布完成！"
```

## 持续集成/持续部署

### GitHub Actions配置

#### 1. 主工作流

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'
    
    - name: Get dependencies
      run: flutter pub get
    
    - name: Generate code
      run: flutter packages pub run build_runner build --delete-conflicting-outputs
    
    - name: Analyze code
      run: flutter analyze
    
    - name: Run tests
      run: flutter test --coverage
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info

  build:
    runs-on: ubuntu-latest
    needs: test
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'
    
    - name: Get dependencies
      run: flutter pub get
    
    - name: Generate code
      run: flutter packages pub run build_runner build --delete-conflicting-outputs
    
    - name: Build APK
      run: flutter build apk --release
    
    - name: Build App Bundle
      run: flutter build appbundle --release
    
    - name: Upload artifacts
      uses: actions/upload-artifact@v3
      with:
        name: app-release-files
        path: |
          build/app/outputs/flutter-apk/app-release.apk
          build/app/outputs/bundle/release/app-release.aab

  deploy:
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Download artifacts
      uses: actions/download-artifact@v3
      with:
        name: app-release-files
        path: ./build
    
    - name: Deploy to Play Store
      uses: r0adkll/upload-google-play@v1
      with:
        serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
        packageName: com.flclash.browser
        releaseFiles: build/app/outputs/bundle/release/app-release.aab
        track: production
```

#### 2. 移动端构建工作流

```yaml
# .github/workflows/mobile-build.yml
name: Mobile Build

on:
  push:
    branches: [ release/* ]

jobs:
  ios-build:
    runs-on: macos-latest
    if: contains(github.ref, 'release/')
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'
    
    - name: Setup Xcode
      uses: maxim-lobanov/setup-xcode@v1
      with:
        xcode-version: 'latest-stable'
    
    - name: Get dependencies
      run: flutter pub get
    
    - name: Build iOS
      run: flutter build ios --release --no-codesign
    
    - name: Upload IPA
      uses: actions/upload-artifact@v3
      with:
        name: ios-ipa
        path: build/ios/iphoneos/Runner.app

  android-build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'
    
    - name: Build Android
      run: |
        flutter build apk --release
        flutter build appbundle --release
    
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: android-apk
        path: build/app/outputs/flutter-apk/app-release.apk
    
    - name: Upload AAB
      uses: actions/upload-artifact@v3
      with:
        name: android-aab
        path: build/app/outputs/bundle/release/app-release.aab
```

### Docker容器化

#### 1. Dockerfile

```dockerfile
# Dockerfile
FROM ubuntu:22.04

# 安装必要工具
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /opt

# 下载并安装Flutter
RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz -o flutter.tar.xz \
    && tar xf flutter.tar.xz \
    && rm flutter.tar.xz

# 设置环境变量
ENV PATH="/opt/flutter/bin:${PATH}"
ENV ANDROID_HOME="/opt/android-sdk"
ENV PATH="${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${PATH}"

# 下载Android SDK
RUN mkdir -p /opt/android-sdk \
    && curl -L https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -o commandlinetools.zip \
    && unzip commandlinetools.zip -d /opt/android-sdk \
    && rm commandlinetools.zip

# 接受Android licenses
RUN yes | sdkmanager --licenses || true

# 安装Android SDK组件
RUN sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# 设置Flutter配置
RUN flutter config --no-analytics \
    && flutter config --disable-telemetry

# 复制项目文件
COPY . /app
WORKDIR /app

# 获取依赖并构建
RUN flutter pub get \
    && flutter packages pub run build_runner build --delete-conflicting-outputs \
    && flutter build apk --release

# 设置启动命令
CMD ["flutter", "run", "--release"]
```

#### 2. Docker Compose配置

```yaml
# docker-compose.yml
version: '3.8'

services:
  flutter-app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - FLUTTER_ENV=production
      - API_BASE_URL=http://api.flclash.com
    volumes:
      - ./logs:/app/logs
    restart: unless-stopped
    
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    restart: unless-stopped
    
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - flutter-app
    restart: unless-stopped

volumes:
  redis-data:
```

### 自动化部署脚本

#### 1. 部署脚本

```bash
#!/bin/bash
# deploy.sh

set -e

ENVIRONMENT=$1
VERSION=$2
BUILD_NUMBER=$3

if [ -z "$ENVIRONMENT" ] || [ -z "$VERSION" ] || [ -z "$BUILD_NUMBER" ]; then
    echo "用法: $0 <environment> <version> <build_number>"
    echo "示例: $0 production 1.0.0 1001"
    exit 1
fi

echo "开始部署到 $ENVIRONMENT 环境"

# 检查环境
case $ENVIRONMENT in
    development|testing|staging|production)
        echo "部署到 $ENVIRONMENT 环境"
        ;;
    *)
        echo "错误: 不支持的环境 $ENVIRONMENT"
        exit 1
        ;;
esac

# 构建应用
echo "构建应用..."
./build_release.sh $VERSION $BUILD_NUMBER

# 根据环境选择部署策略
case $ENVIRONMENT in
    development)
        echo "部署到开发环境..."
        # 直接部署到开发服务器
        scp -r release/$VERSION/* dev-server:/opt/flclash-browser/
        ;;
    testing)
        echo "部署到测试环境..."
        # 部署到测试服务器并运行自动化测试
        scp -r release/$VERSION/* test-server:/opt/flclash-browser/
        ssh test-server "cd /opt/flclash-browser && ./run_tests.sh"
        ;;
    staging)
        echo "部署到预发布环境..."
        # 使用蓝绿部署
        ./blue_green_deploy.sh staging $VERSION $BUILD_NUMBER
        ;;
    production)
        echo "部署到生产环境..."
        # 使用金丝雀部署
        ./canary_deploy.sh production $VERSION $BUILD_NUMBER
        ;;
esac

echo "部署完成！"

# 发送通知
./scripts/send_notification.sh $ENVIRONMENT $VERSION $BUILD_NUMBER
```

#### 2. 蓝绿部署脚本

```bash
#!/bin/bash
# blue_green_deploy.sh

set -e

ENVIRONMENT=$1
VERSION=$2
BUILD_NUMBER=$3

GREEN_ENV="green-$ENVIRONMENT"
BLUE_ENV="blue-$ENVIRONMENT"

echo "开始蓝绿部署到 $ENVIRONMENT 环境"

# 部署到绿色环境
echo "部署到 $GREEN_ENV 环境..."
./deploy_to_environment.sh $GREEN_ENV $VERSION $BUILD_NUMBER

# 运行健康检查
echo "运行健康检查..."
./health_check.sh $GREEN_ENV

if [ $? -eq 0 ]; then
    echo "健康检查通过，切换流量..."
    
    # 切换流量到绿色环境
    ./switch_traffic.sh $BLUE_ENV $GREEN_ENV
    
    # 保留蓝色环境作为备份
    echo "部署成功！保留 $BLUE_ENV 作为备份"
else
    echo "健康检查失败，回滚到 $BLUE_ENV 环境"
    exit 1
fi
```

## 监控与维护

### 应用监控

#### 1. 性能监控

```dart
// lib/monitoring/performance_monitor.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class PerformanceMonitor {
  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;
  
  static void initialize() {
    if (kDebugMode) return;
    
    _analytics = FirebaseAnalytics.instance;
    _crashlytics = FirebaseCrashlytics.instance;
    
    // 设置全局错误处理器
    FlutterError.onError = _crashlytics!.recordFlutterFatalError;
  }
  
  /// 记录页面加载时间
  static Future<void> recordPageLoadTime(String pageName, Duration loadTime) async {
    if (_analytics == null) return;
    
    await _analytics!.logEvent(
      name: 'page_load_time',
      parameters: {
        'page_name': pageName,
        'load_time_ms': loadTime.inMilliseconds,
      },
    );
  }
  
  /// 记录应用启动时间
  static Future<void> recordAppStartTime(Duration startTime) async {
    if (_analytics == null) return;
    
    await _analytics!.logEvent(
      name: 'app_start_time',
      parameters: {
        'start_time_ms': startTime.inMilliseconds,
      },
    );
  }
  
  /// 记录内存使用情况
  static void recordMemoryUsage() {
    if (_crashlytics == null) return;
    
    final info = ProcessInfo.currentRss;
    _crashlytics!.log('Memory usage: ${info}KB');
  }
  
  /// 记录自定义事件
  static Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    if (_analytics == null) return;
    
    await _analytics!.logEvent(name: name, parameters: parameters);
  }
  
  /// 记录错误
  static void recordError(dynamic exception, StackTrace stackTrace) {
    if (_crashlytics == null) return;
    
    _crashlytics!.recordError(exception, stackTrace);
  }
}
```

#### 2. 用户行为分析

```dart
// lib/analytics/user_analytics.dart
class UserAnalytics {
  static FirebaseAnalytics? _analytics;
  
  static void initialize() {
    _analytics = FirebaseAnalytics.instance;
  }
  
  /// 记录书签操作
  static Future<void> trackBookmarkAction(String action, String bookmarkId) async {
    await _analytics!.logEvent(
      name: 'bookmark_action',
      parameters: {
        'action': action, // 'add', 'edit', 'delete', 'visit'
        'bookmark_id': bookmarkId,
      },
    );
  }
  
  /// 记录历史记录操作
  static Future<void> trackHistoryAction(String action, String url) async {
    await _analytics!.logEvent(
      name: 'history_action',
      parameters: {
        'action': action, // 'view', 'clear', 'search'
        'url': url,
      },
    );
  }
  
  /// 记录设置变更
  static Future<void> trackSettingsChange(String setting, String value) async {
    await _analytics!.logEvent(
      name: 'settings_change',
      parameters: {
        'setting': setting,
        'value': value,
      },
    );
  }
  
  /// 记录用户会话
  static Future<void> trackSessionStart() async {
    await _analytics!.logEvent(name: 'session_start', parameters: {});
  }
  
  static Future<void> trackSessionEnd(int duration) async {
    await _analytics!.logEvent(
      name: 'session_end',
      parameters: {
        'duration_seconds': duration,
      },
    );
  }
}
```

### 日志管理

#### 1. 日志配置

```dart
// lib/logging/logger.dart
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AppLogger {
  static Logger? _logger;
  static File? _logFile;
  
  static Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    _logFile = File('${directory.path}/app.log');
    
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      output: MultiOutput([
        ConsoleOutput(),
        FileOutput(file: _logFile!),
      ]),
      level: kDebugMode ? Level.debug : Level.info,
    );
  }
  
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger?.d(message, error, stackTrace);
  }
  
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger?.i(message, error, stackTrace);
  }
  
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger?.w(message, error, stackTrace);
  }
  
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger?.e(message, error, stackTrace);
  }
  
  static Future<String> getLogContent() async {
    if (_logFile?.exists() ?? false) {
      return await _logFile!.readAsString();
    }
    return '';
  }
  
  static Future<void> clearLogs() async {
    if (_logFile?.exists() ?? false) {
      await _logFile!.writeAsString('');
    }
  }
}
```

#### 2. 日志分析脚本

```bash
#!/bin/bash
# analyze_logs.sh

LOG_FILE=$1
ANALYSIS_TYPE=$2

if [ -z "$LOG_FILE" ] || [ -z "$ANALYSIS_TYPE" ]; then
    echo "用法: $0 <log_file> <analysis_type>"
    echo "分析类型: errors, performance, user_actions"
    exit 1
fi

echo "分析日志文件: $LOG_FILE"
echo "分析类型: $ANALYSIS_TYPE"

case $ANALYSIS_TYPE in
    errors)
        echo "=== 错误分析 ==="
        grep -i "error\|exception" $LOG_FILE | sort | uniq -c | sort -nr
        ;;
    performance)
        echo "=== 性能分析 ==="
        grep -i "load_time\|start_time" $LOG_FILE | awk '{print $NF}' | sort -n
        ;;
    user_actions)
        echo "=== 用户行为分析 ==="
        grep -i "bookmark_action\|history_action" $LOG_FILE | cut -d'=' -f2 | sort | uniq -c
        ;;
    *)
        echo "不支持的分析类型: $ANALYSIS_TYPE"
        exit 1
        ;;
esac
```

### 健康检查

#### 1. 应用健康检查

```dart
// lib/health/health_check.dart
class HealthChecker {
  static Future<HealthStatus> checkAppHealth() async {
    final checks = <String, Future<bool>>{
      'database': _checkDatabase(),
      'network': _checkNetwork(),
      'storage': _checkStorage(),
      'permissions': _checkPermissions(),
    };
    
    final results = <String, bool>{};
    for (final entry in checks.entries) {
      try {
        results[entry.key] = await entry.value;
      } catch (e) {
        results[entry.key] = false;
      }
    }
    
    final allHealthy = results.values.every((result) => result);
    
    return HealthStatus(
      isHealthy: allHealthy,
      checks: results,
      timestamp: DateTime.now(),
    );
  }
  
  static Future<bool> _checkDatabase() async {
    try {
      // 检查数据库连接和基本操作
      final db = await DatabaseService.database;
      final result = await db.query('sqlite_master', limit: 1);
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> _checkNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> _checkStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return await directory.exists();
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> _checkPermissions() async {
    // 检查必要的权限
    return true;
  }
}

class HealthStatus {
  final bool isHealthy;
  final Map<String, bool> checks;
  final DateTime timestamp;
  
  HealthStatus({
    required this.isHealthy,
    required this.checks,
    required this.timestamp,
  });
  
  Map<String, dynamic> toJson() => {
    'is_healthy': isHealthy,
    'checks': checks,
    'timestamp': timestamp.toIso8601String(),
  };
}
```

#### 2. 自动化健康检查脚本

```bash
#!/bin/bash
# health_check.sh

APP_URL=$1
TIMEOUT=${2:-30}

if [ -z "$APP_URL" ]; then
    echo "用法: $0 <app_url> [timeout]"
    exit 1
fi

echo "检查应用健康状态: $APP_URL"

# 检查应用是否响应
echo "检查应用响应..."
if curl -f -s --max-time $TIMEOUT "$APP_URL/health" > /dev/null; then
    echo "✓ 应用响应正常"
else
    echo "✗ 应用无响应"
    exit 1
fi

# 检查数据库连接
echo "检查数据库连接..."
DB_STATUS=$(curl -s "$APP_URL/health" | jq -r '.checks.database')
if [ "$DB_STATUS" = "true" ]; then
    echo "✓ 数据库连接正常"
else
    echo "✗ 数据库连接异常"
fi

# 检查网络连接
echo "检查网络连接..."
NETWORK_STATUS=$(curl -s "$APP_URL/health" | jq -r '.checks.network')
if [ "$NETWORK_STATUS" = "true" ]; then
    echo "✓ 网络连接正常"
else
    echo "✗ 网络连接异常"
fi

# 检查存储空间
echo "检查存储空间..."
STORAGE_STATUS=$(curl -s "$APP_URL/health" | jq -r '.checks.storage')
if [ "$STORAGE_STATUS" = "true" ]; then
    echo "✓ 存储空间正常"
else
    echo "✗ 存储空间异常"
fi

echo "健康检查完成！"
```

## 故障排除

### 常见问题诊断

#### 1. 应用启动问题

**问题**: 应用无法启动或启动后立即崩溃

**诊断步骤**:
```bash
# 检查设备日志
adb logcat | grep -i "flutter\|crash\|exception"

# 检查应用状态
adb shell pm list packages | grep flclash

# 检查权限
adb shell dumpsys package com.flclash.browser | grep permission
```

**解决方案**:
1. 清理应用数据: `adb shell pm clear com.flclash.browser`
2. 重新安装应用: `adb install -r app.apk`
3. 检查设备兼容性
4. 查看详细错误日志

#### 2. 数据库问题

**问题**: 数据库操作失败或数据丢失

**诊断步骤**:
```dart
// 在应用中检查数据库状态
class DatabaseDiagnostics {
  static Future<void> diagnoseDatabase() async {
    try {
      final db = await DatabaseService.database;
      
      // 检查数据库版本
      final version = await db.getVersion();
      print('Database version: $version');
      
      // 检查表结构
      final tables = await db.query('sqlite_master', 
        where: 'type = ?', 
        whereArgs: ['table']
      );
      print('Tables: ${tables.length}');
      
      // 检查数据完整性
      final bookmarkCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM bookmarks'));
      print('Bookmark count: $bookmarkCount');
      
    } catch (e) {
      print('Database error: $e');
    }
  }
}
```

**解决方案**:
1. 重建数据库表结构
2. 恢复数据备份
3. 清理应用缓存
4. 检查存储权限

#### 3. 网络连接问题

**问题**: 无法访问网络或网络请求失败

**诊断步骤**:
```dart
// 网络连接诊断
class NetworkDiagnostics {
  static Future<NetworkStatus> diagnoseNetwork() async {
    final status = NetworkStatus();
    
    try {
      // 检查网络连接
      final connectivityResult = await Connectivity().checkConnectivity();
      status.hasConnection = connectivityResult != ConnectivityResult.none;
      
      // 测试DNS解析
      final result = await InternetAddress.lookup('google.com');
      status.dnsWorking = result.isNotEmpty;
      
      // 测试HTTP请求
      final response = await http.get(Uri.parse('https://httpbin.org/status/200'));
      status.httpWorking = response.statusCode == 200;
      
    } catch (e) {
      status.error = e.toString();
    }
    
    return status;
  }
}
```

**解决方案**:
1. 检查网络设置
2. 验证代理配置
3. 重置网络连接
4. 检查防火墙设置

### 性能问题诊断

#### 1. 内存泄漏检测

```dart
// lib/performance/memory_monitor.dart
class MemoryMonitor {
  static Timer? _timer;
  static List<MemorySnapshot> _snapshots = [];
  
  static void startMonitoring() {
    _timer = Timer.periodic(Duration(minutes: 5), (_) {
      _takeSnapshot();
    });
  }
  
  static void stopMonitoring() {
    _timer?.cancel();
  }
  
  static void _takeSnapshot() {
    final info = ProcessInfo.currentRss;
    final snapshot = MemorySnapshot(
      timestamp: DateTime.now(),
      memoryUsage: info,
    );
    
    _snapshots.add(snapshot);
    
    // 如果快照过多，移除最早的
    if (_snapshots.length > 100) {
      _snapshots.removeAt(0);
    }
    
    // 检查内存增长趋势
    _checkMemoryTrend();
  }
  
  static void _checkMemoryTrend() {
    if (_snapshots.length < 10) return;
    
    final recent = _snapshots.take(10).toList();
    final oldAverage = recent.take(5).map((s) => s.memoryUsage).reduce((a, b) => a + b) / 5;
    final newAverage = recent.skip(5).map((s) => s.memoryUsage).reduce((a, b) => a + b) / 5;
    
    final growthRate = (newAverage - oldAverage) / oldAverage;
    
    if (growthRate > 0.1) { // 10%增长
      AppLogger.warning('Memory leak detected: ${(growthRate * 100).toStringAsFixed(1)}% growth');
    }
  }
  
  static List<MemorySnapshot> getSnapshots() {
    return List.unmodifiable(_snapshots);
  }
}

class MemorySnapshot {
  final DateTime timestamp;
  final int memoryUsage;
  
  MemorySnapshot({
    required this.timestamp,
    required this.memoryUsage,
  });
}
```

#### 2. 性能分析工具

```bash
#!/bin/bash
# performance_analysis.sh

APP_PACKAGE="com.flclash.browser"

echo "开始性能分析..."

# CPU使用率分析
echo "分析CPU使用率..."
adb shell top -n 1 | grep $APP_PACKAGE

# 内存使用分析
echo "分析内存使用..."
adb shell dumpsys meminfo $APP_PACKAGE

# 帧率分析
echo "分析帧率..."
adb shell dumpsys gfxinfo $APP_PACKAGE

# 网络使用分析
echo "分析网络使用..."
adb shell dumpsys netstats detail | grep $APP_PACKAGE

# 生成性能报告
echo "生成性能报告..."
adb shell dumpsys meminfo $APP_PACKAGE > memory_report.txt
adb shell dumpsys gfxinfo $APP_PACKAGE > gfx_report.txt

echo "性能分析完成！报告保存在 memory_report.txt 和 gfx_report.txt"
```

### 错误恢复机制

#### 1. 自动重试机制

```dart
// lib/utils/retry_utils.dart
class RetryUtils {
  static Future<T> retry<T>(
    Future<T> Function() operation, {
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
    bool Function(Exception)? shouldRetry,
  }) async {
    Exception? lastException;
    
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await operation();
      } catch (e) {
        lastException = e as Exception;
        
        if (attempt == maxAttempts) {
          break;
        }
        
        if (shouldRetry != null && !shouldRetry(e)) {
          break;
        }
        
        AppLogger.warning('操作失败，$delay 后重试 (尝试 $attempt/$maxAttempts)');
        await Future.delayed(delay);
        
        // 指数退避
        delay = Duration(milliseconds: delay.inMilliseconds * 2);
      }
    }
    
    throw lastException!;
  }
  
  static bool shouldRetryNetworkError(Exception error) {
    if (error is SocketException) return true;
    if (error is TimeoutException) return true;
    if (error.toString().contains('502') || 
        error.toString().contains('503') ||
        error.toString().contains('504')) {
      return true;
    }
    return false;
  }
}
```

#### 2. 故障恢复脚本

```bash
#!/bin/bash
# recovery.sh

APP_PACKAGE="com.flclash.browser"

echo "开始故障恢复流程..."

# 1. 检查应用状态
echo "检查应用状态..."
if adb shell pm list packages | grep -q $APP_PACKAGE; then
    echo "应用已安装"
else
    echo "应用未安装，开始重新安装..."
    adb install -r app.apk
fi

# 2. 清理应用数据
echo "清理应用数据..."
adb shell pm clear $APP_PACKAGE

# 3. 重启应用服务
echo "重启应用服务..."
adb shell am force-stop $APP_PACKAGE
sleep 2
adb shell am start -n $APP_PACKAGE/.MainActivity

# 4. 验证恢复
echo "验证恢复状态..."
sleep 5
if adb shell dumpsys activity | grep -q $APP_PACKAGE; then
    echo "✓ 应用恢复成功"
else
    echo "✗ 应用恢复失败"
    exit 1
fi

echo "故障恢复完成！"
```

## 性能优化

### 构建优化

#### 1. Flutter构建优化

```yaml
# android/app/build.gradle
android {
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
    
    kotlinOptions {
        jvmTarget = '1.8'
    }
    
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            
            // 启用R8完整模式
            proguardFiles 'proguard-r8-full-mode.txt'
            
            // 优化配置
            debuggable false
            jniDebuggable false
            renderscriptDebuggable false
        }
    }
    
    // 启用并行构建
    dexOptions {
        javaMaxHeapSize "4g"
        incremental true
    }
}
```

#### 2. 资源优化

```bash
#!/bin/bash
# optimize_resources.sh

echo "优化应用资源..."

# 压缩图片资源
echo "压缩图片资源..."
find android/app/src/main/res -name "*.png" -exec optipng -o2 {} \;
find android/app/src/main/res -name "*.jpg" -exec jpegoptim --strip-all --max=85 {} \;

# 优化字体文件
echo "优化字体文件..."
find . -name "*.ttf" -exec fonttools subset {} \;

# 清理未使用的资源
echo "清理未使用的资源..."
flutter clean
flutter pub get

# 重新构建
echo "重新构建应用..."
flutter build apk --release --tree-shake-icons

echo "资源优化完成！"
```

### 运行时优化

#### 1. 内存优化

```dart
// lib/optimization/memory_optimizer.dart
class MemoryOptimizer {
  static Timer? _cleanupTimer;
  
  static void startOptimization() {
    // 定期清理缓存
    _cleanupTimer = Timer.periodic(Duration(minutes: 10), (_) {
      _cleanupCaches();
    });
    
    // 监听应用生命周期
    WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  }
  
  static void _cleanupCaches() {
    // 清理图片缓存
    PaintingBinding.instance.imageCache.clear();
    
    // 清理WebView缓存
    WebViewController().clearCache();
    
    // 清理临时文件
    _cleanupTempFiles();
    
    AppLogger.info('内存优化完成');
  }
  
  static void _cleanupTempFiles() async {
    final tempDir = await getTemporaryDirectory();
    if (await tempDir.exists()) {
      final files = await tempDir.list().toList();
      for (final file in files) {
        if (file is File) {
          final stat = await file.stat();
          if (DateTime.now().difference(stat.modified).inHours > 24) {
            await file.delete();
          }
        }
      }
    }
  }
  
  static void stopOptimization() {
    _cleanupTimer?.cancel();
  }
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        // 应用进入后台，清理资源
        MemoryOptimizer._cleanupCaches();
        break;
      case AppLifecycleState.resumed:
        // 应用回到前台，恢复必要资源
        break;
      default:
        break;
    }
  }
}
```

#### 2. 渲染优化

```dart
// lib/optimization/render_optimizer.dart
class RenderOptimizer {
  static void optimizeListView() {
    // 为ListView启用惰性加载
    // 使用const构造函数
    // 减少不必要的重建
  }
  
  static Widget optimizeBookmarkItem(Bookmark bookmark) {
    return BookmarkItemWidget(
      key: ValueKey(bookmark.id), // 使用稳定的key
      bookmark: bookmark,
    );
  }
  
  static Widget optimizeBookmarkList(List<Bookmark> bookmarks) {
    return ListView.builder(
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return const BookmarkItemWidget(
          key: ValueKey('bookmark_${bookmark.id}'),
          bookmark: null, // 将在构造函数中设置
        )..bookmark = bookmark;
      },
      cacheExtent: 200, // 预渲染范围
    );
  }
}
```

## 安全配置

### 应用安全

#### 1. 代码混淆配置

```proguard
# android/app/proguard-rules.pro

# Flutter特定规则
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# 保留模型类
-keep class com.flclash.browser.models.** { *; }

# 移除日志
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# 优化和混淆
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification
-dontpreverify
```

#### 2. 安全配置检查

```bash
#!/bin/bash
# security_check.sh

echo "开始安全配置检查..."

# 检查APK签名
echo "检查APK签名..."
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk

# 检查权限配置
echo "检查权限配置..."
grep -r "android.permission" android/app/src/main/AndroidManifest.xml

# 检查网络安全性配置
echo "检查网络安全性配置..."
if [ -f "android/app/src/main/res/xml/network_security_config.xml" ]; then
    echo "✓ 网络安全配置存在"
else
    echo "⚠ 网络安全配置缺失"
fi

# 检查调试配置
echo "检查调试配置..."
if grep -q "android:debuggable=\"true\"" android/app/src/main/AndroidManifest.xml; then
    echo "✗ 调试模式未关闭"
else
    echo "✓ 调试模式已关闭"
fi

echo "安全检查完成！"
```

### 数据安全

#### 1. 数据加密

```dart
// lib/security/data_encryption.dart
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart';

class DataEncryption {
  static const String _key = 'your-32-character-secret-key-here';
  
  static Encrypter _getEncrypter() {
    final key = Key.fromBase64(_key);
    return Encrypter(AES(key));
  }
  
  static String encrypt(String data) {
    final encrypter = _getEncrypter();
    final iv = IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(data, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }
  
  static String decrypt(String encryptedData) {
    final encrypter = _getEncrypter();
    final parts = encryptedData.split(':');
    if (parts.length != 2) throw Exception('Invalid encrypted data format');
    
    final iv = IV.fromBase64(parts[0]);
    final encrypted = Encrypted.fromBase64(parts[1]);
    
    return encrypter.decrypt(encrypted, iv: iv);
  }
  
  static String hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
```

#### 2. 安全存储

```dart
// lib/security/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
  
  static Future<void> storeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
  
  static Future<String?> getSecureData(String key) async {
    return await _storage.read(key: key);
  }
  
  static Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }
  
  static Future<Map<String, String>> getAllSecureData() async {
    return await _storage.readAll();
  }
  
  static Future<void> clearAllSecureData() async {
    await _storage.deleteAll();
  }
}
```

---

**文档版本**: v1.0  
**适用版本**: FlClash浏览器 v1.0.0+  
**创建日期**: 2025-11-05  
**最后更新**: 2025-11-05  
**维护者**: DevOps团队

如有部署相关问题，请参考故障排除章节或联系技术支持团队。