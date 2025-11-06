#!/bin/bash

# FlClash浏览器集成 - 依赖验证和修复脚本
# 用于验证所有依赖是否有效并修复常见问题

echo "🔍 FlClash浏览器集成 - 依赖验证脚本"
echo "========================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查Flutter是否安装
echo -e "${YELLOW}1. 检查Flutter环境...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter未安装或未添加到PATH${NC}"
    echo "请安装Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# 检查Flutter版本
FLUTTER_VERSION=$(flutter --version | head -n 1)
echo -e "${GREEN}✅ Flutter版本: $FLUTTER_VERSION${NC}"

# 进入项目目录
cd flclash_browser_app || exit 1

echo -e "\n${YELLOW}2. 清理项目...${NC}"
flutter clean

echo -e "\n${YELLOW}3. 获取依赖...${NC}"
flutter pub get

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ 依赖获取成功${NC}"
else
    echo -e "${RED}❌ 依赖获取失败${NC}"
    echo -e "${YELLOW}尝试升级依赖...${NC}"
    flutter pub upgrade
    flutter pub get
fi

echo -e "\n${YELLOW}4. 分析依赖关系...${NC}"
flutter pub deps

echo -e "\n${YELLOW}5. 检查Android配置...${NC}"
if [ -f "android/app/src/main/AndroidManifest.xml" ]; then
    if grep -q "flutterEmbedding" android/app/src/main/AndroidManifest.xml; then
        echo -e "${GREEN}✅ Flutter v2 embedding已配置${NC}"
    else
        echo -e "${RED}❌ Flutter v2 embedding未配置${NC}"
        echo "请检查AndroidManifest.xml文件"
    fi
else
    echo -e "${RED}❌ AndroidManifest.xml文件不存在${NC}"
fi

echo -e "\n${YELLOW}6. 检查Flutter Doctor...${NC}"
flutter doctor --android-licenses

echo -e "\n${YELLOW}7. 尝试构建Debug版本...${NC}"
flutter build apk --debug

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Debug版本构建成功！${NC}"
    echo "APK位置: build/app/outputs/flutter-apk/app-debug.apk"
else
    echo -e "${RED}❌ Debug版本构建失败${NC}"
    echo "请检查错误信息并参考DEPENDENCY_FIX.md"
fi

echo -e "\n${YELLOW}8. 最终检查...${NC}"
echo "项目结构验证:"
if [ -f "lib/main.dart" ]; then
    echo -e "${GREEN}✅ lib/main.dart 存在${NC}"
else
    echo -e "${RED}❌ lib/main.dart 不存在${NC}"
fi

if [ -f "pubspec.yaml" ]; then
    echo -e "${GREEN}✅ pubspec.yaml 存在${NC}"
else
    echo -e "${RED}❌ pubspec.yaml 不存在${NC}"
fi

if [ -f "android/app/build.gradle" ]; then
    echo -e "${GREEN}✅ Android配置完整${NC}"
else
    echo -e "${RED}❌ Android配置不完整${NC}"
fi

echo -e "\n${GREEN}🎉 验证完成！${NC}"
echo "如果所有检查都通过，项目就可以正常使用了。"
echo -e "\n${YELLOW}下一步:${NC}"
echo "1. 连接Android设备: flutter devices"
echo "2. 运行应用: flutter run"
echo "3. 构建发布版本: flutter build apk --release"