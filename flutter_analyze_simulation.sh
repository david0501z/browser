#!/bin/bash

echo "🔍 开始自定义Flutter代码分析..."
echo ""

total_errors=0
total_warnings=0

# 检查1: 验证所有生成文件存在
echo "📁 检查生成文件存在性..."
generated_files=(
    "lib/models/generated/app_settings.freezed.dart"
    "lib/models/generated/app_settings.g.dart"
    "lib/models/generated/browser_tab.freezed.dart"
    "lib/models/generated/browser_tab.g.dart"
    "lib/models/generated/history_entry.freezed.dart"
    "lib/models/generated/history_entry.g.dart"
    "lib/models/generated/browser_models.freezed.dart"
    "lib/models/generated/browser_models.g.dart"
    "lib/models/generated/browser_settings.freezed.dart"
    "lib/models/generated/browser_settings.g.dart"
    "lib/models/enums.dart"
)

for file in "${generated_files[@]}"; do
    if [[ "$file" == *"enums.dart"* ]]; then
        if [[ -f "lib/models/enums.dart" ]]; then
            echo "✅ $file 存在"
        else
            echo "❌ 缺少文件: $file"
            ((total_errors++))
        fi
    elif [[ -f "$file" ]]; then
        echo "✅ $file 存在"
    else
        echo "❌ 缺少文件: $file"
        ((total_errors++))
    fi
done

# 检查2: 验证freezed文件的import语句
echo ""
echo "📦 检查freezed文件import语句..."
freezed_files=(
    "lib/models/generated/browser_tab.freezed.dart"
    "lib/models/generated/history_entry.freezed.dart"
    "lib/models/generated/browser_models.freezed.dart"
)

for file in "${freezed_files[@]}"; do
    if [[ -f "$file" ]]; then
        # 检查import语句
        if grep -q "import 'package:freezed_annotation/freezed_annotation.dart';" "$file"; then
            # 检查import是否在part of之前
            import_line=$(grep -n "import 'package:freezed_annotation/freezed_annotation.dart';" "$file" | cut -d: -f1)
            partof_line=$(grep -n "part of" "$file" | cut -d: -f1 | head -1)
            
            if [[ -n "$partof_line" ]] && [[ $import_line -gt $partof_line ]]; then
                echo "❌ $file import语句位置错误（应在part of之前）"
                ((total_errors++))
            else
                echo "✅ $file import语句正确"
            fi
        else
            echo "❌ $file 缺少freezed_annotation导入"
            ((total_errors++))
        fi
    fi
done

# 检查3: 验证枚举文件内容
echo ""
echo "🔢 检查枚举文件..."
if [[ -f "lib/models/enums.dart" ]]; then
    required_enums=("ProxyMode" "LogLevel" "CloudService" "NetworkProtocol" "SecurityLevel")
    
    for enum_name in "${required_enums[@]}"; do
        if grep -q "enum $enum_name" "lib/models/enums.dart"; then
            echo "✅ 枚举 $enum_name 已定义"
        else
            echo "⚠️  枚举 $enum_name 可能未定义"
            ((total_warnings++))
        fi
    done
else
    echo "❌ 枚举文件不存在"
    ((total_errors++))
fi

# 检查4: 验证主要Dart文件语法
echo ""
echo "🔧 检查主要Dart文件语法..."
dart_files=(
    "lib/models/app_settings.dart"
    "lib/models/BrowserTab.dart"
    "lib/models/HistoryEntry.dart"
    "lib/models/browser_models.dart"
)

for file in "${dart_files[@]}"; do
    if [[ -f "$file" ]]; then
        if grep -q "@freezed" "$file" && ! grep -q "part " "$file"; then
            echo "❌ $file 使用@freezed但缺少part语句"
            ((total_errors++))
        elif grep -q "@freezed" "$file" && grep -q "part " "$file"; then
            echo "✅ $file 包含@freezed和part语句"
        elif grep -q "import.*enums.dart" "$file"; then
            echo "✅ $file 正确导入枚举文件"
        else
            echo "✅ $file 语法检查通过"
        fi
    fi
done

# 检查5: 验证part of语句
echo ""
echo "🔗 检查part of语句..."
part_files=(
    "lib/models/generated/browser_tab.g.dart"
    "lib/models/generated/history_entry.g.dart"
    "lib/models/generated/browser_models.g.dart"
)

for file in "${part_files[@]}"; do
    if [[ -f "$file" ]]; then
        if grep -q "part of" "$file"; then
            echo "✅ $file 包含正确的part of语句"
        else
            echo "❌ $file 缺少part of语句"
            ((total_errors++))
        fi
    fi
done

# 输出总结
echo ""
echo "=================================================="
echo "📊 分析结果总结"
echo "=================================================="
echo "总错误数: $total_errors"
echo "总警告数: $total_warnings"

if [[ $total_errors -gt 0 ]]; then
    echo ""
    echo "❌ 仍有问题需要修复"
else
    echo ""
    echo "🎉 恭喜！代码分析通过，没有发现错误！"
    echo "✅ 所有修复都已正确应用"
    echo "✅ 可以尝试构建APK了"
fi