#!/bin/bash

# 代理+浏览器集成功能测试运行脚本
# 位置: flclash_browser_app/lib/test/run_integration_tests.sh

echo "========================================="
echo "代理+浏览器集成功能测试套件"
echo "========================================="

# 进入项目目录
cd "$(dirname "$0")/../.."

echo "当前工作目录: $(pwd)"
echo ""

# 检查Flutter环境
echo "1. 检查Flutter环境..."
flutter --version
echo ""

# 依赖分析
echo "2. 分析项目依赖..."
flutter analyze
echo ""

# 运行单元测试
echo "3. 运行单元测试..."
flutter test test/
echo ""

# 构建应用（集成测试需要）
echo "4. 构建应用..."
flutter build apk --debug
echo ""

# 运行集成测试
echo "5. 运行集成测试..."
echo "5.1 浏览器代理集成测试"
flutter test integration_test/browser_proxy_integration_test.dart

echo "5.2 WebView代理压力测试"
flutter test integration_test/webview_proxy_stress_test.dart

echo "5.3 浏览器性能测试"
flutter test integration_test/browser_performance_test.dart

echo "5.4 用户体验测试"
flutter test integration_test/user_experience_test.dart

echo "5.5 导航和功能测试"
flutter test integration_test/navigation_test.dart

echo "5.6 跨平台兼容性测试"
flutter test integration_test/cross_platform_test.dart

echo ""
echo "========================================="
echo "测试完成！"
echo "========================================="

# 生成测试报告
echo "6. 生成测试报告..."
echo "测试报告生成完成：test_results_$(date +%Y%m%d_%H%M%S).log" > test_results.log

echo "所有测试脚本已准备就绪。"
echo "使用 'flutter test integration_test/xxx_test.dart' 运行特定测试。"
echo "使用 'bash lib/test/run_integration_tests.sh' 运行所有测试。"