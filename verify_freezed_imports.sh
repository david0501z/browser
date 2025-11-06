#!/bin/bash

# Freezed生成文件导入语句验证脚本
echo "🔍 检查Freezed生成文件的导入语句..."
echo "=================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查函数
check_import() {
    local file=$1
    if grep -q "import 'package:freezed_annotation/freezed_annotation.dart';" "$file"; then
        echo -e "${GREEN}✅ $file 导入语句正确${NC}"
        return 0
    else
        echo -e "${RED}❌ $file 缺少导入语句${NC}"
        return 1
    fi
}

echo -e "${YELLOW}检查所有freezed生成文件...${NC}"

# 检查所有freezed文件
files=(
    "lib/models/generated/app_settings.freezed.dart"
    "lib/models/generated/browser_settings.freezed.dart"
    "lib/models/generated/flclash_settings.freezed.dart"
    "lib/models/generated/port_settings.freezed.dart"
    "lib/models/generated/dns_settings.freezed.dart"
    "lib/models/generated/rule_settings.freezed.dart"
    "lib/models/generated/node_settings.freezed.dart"
    "lib/models/generated/traffic_settings.freezed.dart"
    "lib/models/generated/ui.freezed.dart"
    "lib/models/generated/notifications.freezed.dart"
    "lib/models/generated/privacy.freezed.dart"
    "lib/models/generated/backup.freezed.dart"
)

total=0
passed=0

for file in "${files[@]}"; do
    total=$((total + 1))
    if check_import "$file"; then
        passed=$((passed + 1))
    fi
done

echo ""
echo -e "${YELLOW}检查导入语句位置...${NC}"

# 检查导入语句是否在part语句之前
for file in "${files[@]}"; do
    if grep -q "import 'package:freezed_annotation/freezed_annotation.dart';" "$file"; then
        import_line=$(grep -n "import 'package:freezed_annotation/freezed_annotation.dart';" "$file" | cut -d: -f1)
        part_line=$(grep -n "part of" "$file" | cut -d: -f1)
        
        if [ "$import_line" -lt "$part_line" ]; then
            echo -e "${GREEN}✅ $file 导入语句位置正确${NC}"
        else
            echo -e "${RED}❌ $file 导入语句位置错误${NC}"
        fi
    fi
done

echo ""
echo "=================================="
echo -e "检查结果: ${passed}/${total} 个文件通过"

if [ "$passed" -eq "$total" ]; then
    echo -e "${GREEN}🎉 所有freezed文件导入语句检查通过！${NC}"
else
    echo -e "${RED}❌ 还有 ${total} 个文件需要修复${NC}"
fi
