#!/bin/bash

# Flutter构建错误修复验证脚本
# 用于验证所有修复是否成功应用

echo "🔍 开始验证Flutter构建错误修复..."
echo "=================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查函数
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✅ $1 存在${NC}"
        return 0
    else
        echo -e "${RED}❌ $1 不存在${NC}"
        return 1
    fi
}

check_directory() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✅ 目录 $1 存在${NC}"
        return 0
    else
        echo -e "${RED}❌ 目录 $1 不存在${NC}"
        return 1
    fi
}

echo -e "${YELLOW}1. 检查修复后的文件...${NC}"

# 检查主要修复文件
check_file "pubspec.yaml"
check_file "lib/services/database_service.dart"
check_file "lib/services/settings_service.dart"
check_file "lib/utils/device_info_helper.dart"
check_file "lib/themes/browser_theme.dart"
check_file "lib/providers/browser_providers.dart"
check_file "lib/main.dart"

echo ""
echo -e "${YELLOW}2. 检查生成的文件...${NC}"

# 检查生成文件
check_directory "lib/models/generated"
check_file "lib/models/generated/browser_settings.freezed.dart"
check_file "lib/models/generated/browser_settings.g.dart"
check_file "lib/models/generated/app_settings.freezed.dart"
check_file "lib/models/generated/app_settings.g.dart"
check_file "lib/models/generated/flclash_settings.freezed.dart"
check_file "lib/models/generated/flclash_settings.g.dart"
check_file "lib/models/generated/port_settings.freezed.dart"
check_file "lib/models/generated/port_settings.g.dart"
check_file "lib/models/generated/dns_settings.freezed.dart"
check_file "lib/models/generated/dns_settings.g.dart"
check_file "lib/models/generated/rule_settings.freezed.dart"
check_file "lib/models/generated/rule_settings.g.dart"
check_file "lib/models/generated/node_settings.freezed.dart"
check_file "lib/models/generated/node_settings.g.dart"
check_file "lib/models/generated/traffic_settings.freezed.dart"
check_file "lib/models/generated/traffic_settings.g.dart"
check_file "lib/models/generated/ui.freezed.dart"
check_file "lib/models/generated/ui.g.dart"
check_file "lib/models/generated/notifications.freezed.dart"
check_file "lib/models/generated/notifications.g.dart"
check_file "lib/models/generated/privacy.freezed.dart"
check_file "lib/models/generated/privacy.g.dart"
check_file "lib/models/generated/backup.freezed.dart"
check_file "lib/models/generated/backup.g.dart"

echo ""
echo -e "${YELLOW}3. 检查pubspec.yaml中的依赖...${NC}"

# 检查pubspec.yaml中的依赖
if grep -q "freezed_annotation" pubspec.yaml; then
    echo -e "${GREEN}✅ freezed_annotation 依赖已添加${NC}"
else
    echo -e "${RED}❌ freezed_annotation 依赖缺失${NC}"
fi

if grep -q "freezed:" pubspec.yaml; then
    echo -e "${GREEN}✅ freezed 依赖已添加${NC}"
else
    echo -e "${RED}❌ freezed 依赖缺失${NC}"
fi

echo ""
echo -e "${YELLOW}4. 检查关键方法是否存在...${NC}"

# 检查关键方法
if grep -q "static Future<void> initialize()" lib/services/database_service.dart; then
    echo -e "${GREEN}✅ DatabaseService.initialize() 方法已添加${NC}"
else
    echo -e "${RED}❌ DatabaseService.initialize() 方法缺失${NC}"
fi

if grep -q "static Future<void> initialize()" lib/services/settings_service.dart; then
    echo -e "${GREEN}✅ SettingsService.initialize() 方法已添加${NC}"
else
    echo -e "${RED}❌ SettingsService.initialize() 方法缺失${NC}"
fi

if grep -q "static bool isAndroid()" lib/utils/device_info_helper.dart; then
    echo -e "${GREEN}✅ DeviceInfoHelper.isAndroid() 方法已添加${NC}"
else
    echo -e "${RED}❌ DeviceInfoHelper.isAndroid() 方法缺失${NC}"
fi

if grep -q "static ThemeData getTheme" lib/themes/browser_theme.dart; then
    echo -e "${GREEN}✅ BrowserTheme.getTheme() 方法已添加${NC}"
else
    echo -e "${RED}❌ BrowserTheme.getTheme() 方法缺失${NC}"
fi

if grep -q "settingsServiceProvider" lib/providers/browser_providers.dart; then
    echo -e "${GREEN}✅ settingsServiceProvider 已定义${NC}"
else
    echo -e "${RED}❌ settingsServiceProvider 缺失${NC}"
fi

echo ""
echo -e "${YELLOW}5. 检查权限修复...${NC}"

# 检查权限修复
if ! grep -q "Permission.network" lib/main.dart; then
    echo -e "${GREEN}✅ 已移除不存在的 Permission.network${NC}"
else
    echo -e "${RED}❌ 仍存在 Permission.network 引用${NC}"
fi

echo ""
echo -e "${YELLOW}6. 检查导入修复...${NC}"

# 检查导入修复
if grep -q "providers/browser_providers.dart" lib/main.dart; then
    echo -e "${GREEN}✅ 已添加Provider导入${NC}"
else
    echo -e "${RED}❌ Provider导入缺失${NC}"
fi

echo ""
echo "=================================="
echo -e "${GREEN}🎉 修复验证完成！${NC}"
echo ""
echo -e "${YELLOW}如果所有检查都显示 ✅，说明修复成功。${NC}"
echo -e "${YELLOW}如果仍有 ❌，请检查对应的修复步骤。${NC}"
echo ""
echo -e "${YELLOW}下一步操作：${NC}"
echo "1. 运行 'flutter analyze' 检查代码分析"
echo "2. 运行 'flutter build apk --debug' 测试构建"
echo "3. 在Android设备上测试应用功能"
