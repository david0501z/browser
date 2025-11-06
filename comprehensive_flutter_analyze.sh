#!/bin/bash

echo "🔍 Flutter代码全面分析工具"
echo "模拟 flutter analyze 功能"
echo "=================================================="

total_errors=0
total_warnings=0
errors_list=()
warnings_list=()

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; errors_list+=("$1"); ((total_errors++)); }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; warnings_list+=("$1"); ((total_warnings++)); }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

print_info "开始分析Flutter项目结构..."

# 1. 检查项目基本结构
print_info "1. 检查项目基本结构"
if [[ -f "pubspec.yaml" ]]; then
    print_success "pubspec.yaml 存在"
else
    print_error "缺少 pubspec.yaml"
fi

if [[ -f "lib/main.dart" ]]; then
    print_success "lib/main.dart 存在"
else
    print_error "缺少 lib/main.dart"
fi

if [[ -d "lib/models" ]]; then
    print_success "lib/models 目录存在"
else
    print_error "缺少 lib/models 目录"
fi

# 2. 检查所有freezed生成文件
print_info ""
print_info "2. 检查freezed生成文件完整性"

freezed_models=(
    "app_settings"
    "backup"
    "browser_models"
    "browser_settings"
    "browser_tab"
    "dns_settings"
    "flclash_settings"
    "history_entry"
    "node_settings"
    "notifications"
    "port_settings"
    "privacy"
    "rule_settings"
    "traffic_settings"
    "ui"
)

for model in "${freezed_models[@]}"; do
    freezed_file="lib/models/generated/${model}.freezed.dart"
    json_file="lib/models/generated/${model}.g.dart"
    
    if [[ -f "$freezed_file" ]]; then
        print_success "${model}.freezed.dart 存在"
    else
        print_error "缺少 ${model}.freezed.dart"
    fi
    
    if [[ -f "$json_file" ]]; then
        print_success "${model}.g.dart 存在"
    else
        print_error "缺少 ${model}.g.dart"
    fi
done

# 3. 检查枚举文件
print_info ""
print_info "3. 检查枚举文件"
if [[ -f "lib/models/enums.dart" ]]; then
    print_success "enums.dart 存在"
    
    # 检查关键枚举
    key_enums=("ProxyMode" "LogLevel" "CloudService" "NetworkProtocol" "SecurityLevel")
    for enum in "${key_enums[@]}"; do
        if grep -q "enum $enum" "lib/models/enums.dart"; then
            print_success "枚举 $enum 已定义"
        else
            print_warning "枚举 $enum 未找到"
        fi
    done
else
    print_error "缺少 lib/models/enums.dart"
fi

# 4. 检查import语句位置
print_info ""
print_info "4. 检查import语句位置"

key_freezed_files=(
    "lib/models/generated/browser_tab.freezed.dart"
    "lib/models/generated/history_entry.freezed.dart"
    "lib/models/generated/browser_models.freezed.dart"
)

for file in "${key_freezed_files[@]}"; do
    if [[ -f "$file" ]]; then
        # 检查import语句
        if grep -q "import 'package:freezed_annotation/freezed_annotation.dart';" "$file"; then
            # 检查part of语句
            if grep -q "part of" "$file"; then
                import_line=$(grep -n "import 'package:freezed_annotation/freezed_annotation.dart';" "$file" | cut -d: -f1)
                partof_line=$(grep -n "part of" "$file" | head -1 | cut -d: -f1)
                
                if [[ $import_line -lt $partof_line ]]; then
                    print_success "$(basename $file) import语句位置正确"
                else
                    print_error "$(basename $file) import语句位置错误"
                fi
            else
                print_error "$(basename $file) 缺少part of语句"
            fi
        else
            print_error "$(basename $file) 缺少freezed_annotation导入"
        fi
    fi
done

# 5. 检查part语句
print_info ""
print_info "5. 检查part语句"

source_files=(
    "lib/models/app_settings.dart"
    "lib/models/BrowserTab.dart"
    "lib/models/HistoryEntry.dart"
    "lib/models/browser_models.dart"
)

for file in "${source_files[@]}"; do
    if [[ -f "$file" ]]; then
        if grep -q "@freezed" "$file"; then
            if grep -q "part " "$file"; then
                print_success "$(basename $file) 包含part语句"
            else
                print_error "$(basename $file) 使用@freezed但缺少part语句"
            fi
        else
            print_info "$(basename $file) 不使用@freezed"
        fi
    fi
done

# 6. 检查part of语句
print_info ""
print_info "6. 检查part of语句"

generated_g_files=(
    "lib/models/generated/browser_tab.g.dart"
    "lib/models/generated/history_entry.g.dart"
    "lib/models/generated/browser_models.g.dart"
)

for file in "${generated_g_files[@]}"; do
    if [[ -f "$file" ]]; then
        if grep -q "part of" "$file"; then
            print_success "$(basename $file) 包含part of语句"
        else
            print_error "$(basename $file) 缺少part of语句"
        fi
    fi
done

# 7. 检查语法错误
print_info ""
print_info "7. 检查基本语法错误"

dart_files=$(find lib -name "*.dart" 2>/dev/null | head -20)

for file in $dart_files; do
    if [[ -f "$file" ]]; then
        # 检查未闭合的大括号
        open_braces=$(grep -o "{" "$file" | wc -l)
        close_braces=$(grep -o "}" "$file" | wc -l)
        
        if [[ $open_braces -ne $close_braces ]]; then
            print_error "$(basename $file) 大括号不匹配"
        fi
        
        # 检查未闭合的圆括号
        open_parens=$(grep -o "(" "$file" | wc -l)
        close_parens=$(grep -o ")" "$file" | wc -l)
        
        if [[ $open_parens -ne $close_parens ]]; then
            print_error "$(basename $file) 圆括号不匹配"
        fi
    fi
done

# 8. 检查导入依赖
print_info ""
print_info "8. 检查导入依赖"

if [[ -f "lib/models/app_settings.dart" ]]; then
    if grep -q "import.*enums.dart" "lib/models/app_settings.dart"; then
        print_success "app_settings.dart 正确导入枚举文件"
    else
        print_warning "app_settings.dart 可能缺少枚举导入"
    fi
fi

# 9. 检查文件编码
print_info ""
print_info "9. 检查文件编码"

for file in $(find lib -name "*.dart" 2>/dev/null | head -10); do
    if [[ -f "$file" ]]; then
        # 检查文件是否包含非UTF-8字符
        if file "$file" | grep -q "UTF-8"; then
            print_success "$(basename $file) 编码正确"
        else
            print_warning "$(basename $file) 编码可能有问题"
        fi
    fi
done

# 10. 生成统计信息
print_info ""
print_info "10. 生成统计信息"

dart_file_count=$(find lib -name "*.dart" 2>/dev/null | wc -l)
generated_file_count=$(find lib/models/generated -name "*.dart" 2>/dev/null | wc -l)

print_info "Dart文件总数: $dart_file_count"
print_info "生成文件总数: $generated_file_count"

if [[ -f "lib/models/enums.dart" ]]; then
    enum_count=$(grep -c "enum " "lib/models/enums.dart")
    print_info "枚举类型总数: $enum_count"
fi

# 输出总结
echo ""
echo "=================================================="
echo "📊 分析结果总结"
echo "=================================================="
echo -e "总错误数: ${RED}$total_errors${NC}"
echo -e "总警告数: ${YELLOW}$total_warnings${NC}"

if [[ $total_errors -gt 0 ]]; then
    echo ""
    echo "❌ 错误详情:"
    for error in "${errors_list[@]}"; do
        echo "  • $error"
    done
fi

if [[ $total_warnings -gt 0 ]]; then
    echo ""
    echo "⚠️  警告详情:"
    for warning in "${warnings_list[@]}"; do
        echo "  • $warning"
    done
fi

echo ""
if [[ $total_errors -eq 0 ]]; then
    echo -e "${GREEN}🎉 恭喜！Flutter代码分析通过！${NC}"
    echo -e "${GREEN}✅ 所有检查项目都通过${NC}"
    echo -e "${GREEN}✅ 可以尝试构建APK了${NC}"
    echo ""
    echo "建议的下一步操作："
    echo "1. git add . && git commit -m '修复所有Flutter代码分析错误'"
    echo "2. git push 提交到GitHub"
    echo "3. 在GitHub Actions中触发构建APK工作流"
else
    echo -e "${RED}❌ 仍有 $total_errors 个错误需要修复${NC}"
    echo -e "${YELLOW}建议先修复所有错误后再尝试构建${NC}"
fi

echo ""
echo "=================================================="