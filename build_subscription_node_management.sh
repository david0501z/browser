#!/bin/bash

# 订阅链接和节点管理功能构建脚本
# 用于生成 Freezed 和 JSON 序列化代码

echo "=== 订阅链接和节点管理功能构建脚本 ==="
echo ""

# 切换到项目目录
cd "$(dirname "$0")"

echo "1. 检查构建依赖..."
if ! command -v dart &> /dev/null; then
    echo "❌ Dart SDK 未安装或不在 PATH 中"
    exit 1
fi

echo "✅ Dart SDK 可用"
echo ""

echo "2. 检查依赖项..."
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ 未找到 pubspec.yaml 文件"
    exit 1
fi

echo "✅ 项目文件完整"
echo ""

echo "3. 获取依赖..."
dart pub get
if [ $? -ne 0 ]; then
    echo "❌ 依赖获取失败"
    exit 1
fi

echo "✅ 依赖获取成功"
echo ""

echo "4. 生成订阅和节点模型代码..."
dart run build_runner build --delete-conflicting-outputs
if [ $? -ne 0 ]; then
    echo "❌ 代码生成失败"
    exit 1
fi

echo "✅ 代码生成成功"
echo ""

echo "5. 验证生成的代码..."
# 检查关键生成文件是否存在
files_to_check=(
    "lib/models/subscription.freezed.dart"
    "lib/models/subscription.g.dart"
    "lib/models/proxy_node.freezed.dart"
    "lib/models/proxy_node.g.dart"
)

all_files_exist=true
for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file 缺失"
        all_files_exist=false
    fi
done

if [ "$all_files_exist" = true ]; then
    echo ""
    echo "🎉 所有代码生成成功！"
    echo ""
    echo "生成的文件："
    echo "  - lib/models/subscription.freezed.dart"
    echo "  - lib/models/subscription.g.dart"
    echo "  - lib/models/proxy_node.freezed.dart"
    echo "  - lib/models/proxy_node.g.dart"
    echo ""
    echo "接下来可以："
    echo "  1. 运行示例: dart lib/examples/subscription_and_node_management_example.dart"
    echo "  2. 集成到你的应用中使用"
    echo "  3. 根据需要修改和扩展功能"
else
    echo ""
    echo "❌ 代码生成不完整，请检查错误信息"
    exit 1
fi

echo ""
echo "=== 构建完成 ==="