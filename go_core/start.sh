#!/bin/bash

# FlClash Go Core 启动脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
}

# 检查 Go 是否安装
check_go() {
    if ! command -v go &> /dev/null; then
        log_error "Go 未安装，请先安装 Go 1.21+"
        exit 1
    fi
    
    GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
    log_info "Go 版本: $GO_VERSION"
}

# 检查依赖
check_dependencies() {
    log_info "检查依赖..."
    
    if [ ! -f "go.mod" ]; then
        log_error "go.mod 文件不存在"
        exit 1
    fi
    
    # 整理依赖
    log_info "整理 Go 依赖..."
    go mod tidy
}

# 构建项目
build_project() {
    log_info "构建项目..."
    make build
    
    if [ $? -eq 0 ]; then
        log_info "构建成功"
    else
        log_error "构建失败"
        exit 1
    fi
}

# 运行项目
run_project() {
    local args="$@"
    
    if [ -z "$args" ]; then
        log_info "运行项目 (开发模式)..."
        make dev
    else
        log_info "运行项目 (参数: $args)..."
        ./build/bin/flclash_go_core $args
    fi
}

# 显示帮助
show_help() {
    echo "FlClash Go Core 启动脚本"
    echo ""
    echo "用法: $0 [选项] [参数]"
    echo ""
    echo "选项:"
    echo "  -h, --help     显示帮助信息"
    echo "  -c, --check    检查环境和依赖"
    echo "  -b, --build    构建项目"
    echo "  -r, --run      运行项目"
    echo "  -a, --all      执行完整流程 (检查 + 构建 + 运行)"
    echo ""
    echo "示例:"
    echo "  $0 --help"
    echo "  $0 --check"
    echo "  $0 --build"
    echo "  $0 --run --port=7890 --mode=global"
    echo "  $0 --all"
    echo ""
    echo "环境变量:"
    echo "  FLCLASH_ENV    设置环境 (development/production)"
    echo "  FLCLASH_PORT   设置端口"
    echo "  FLCLASH_MODE   设置代理模式"
}

# 主函数
main() {
    local action=""
    local args=""
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -c|--check)
                action="check"
                shift
                ;;
            -b|--build)
                action="build"
                shift
                ;;
            -r|--run)
                action="run"
                shift
                ;;
            -a|--all)
                action="all"
                shift
                ;;
            *)
                if [ -z "$action" ]; then
                    action="run"
                fi
                args="$args $1"
                shift
                ;;
        esac
    done
    
    # 设置默认操作
    if [ -z "$action" ]; then
        action="check"
    fi
    
    # 执行操作
    case $action in
        check)
            log_info "执行环境检查..."
            check_go
            check_dependencies
            log_info "环境检查完成"
            ;;
        build)
            log_info "执行构建..."
            check_go
            check_dependencies
            build_project
            ;;
        run)
            log_info "运行项目..."
            if [ ! -f "./build/bin/flclash_go_core" ]; then
                log_warn "可执行文件不存在，先执行构建..."
                check_go
                check_dependencies
                build_project
            fi
            run_project $args
            ;;
        all)
            log_info "执行完整流程..."
            check_go
            check_dependencies
            build_project
            run_project $args
            ;;
        *)
            log_error "未知操作: $action"
            show_help
            exit 1
            ;;
    esac
}

# 错误处理
trap 'log_error "脚本执行失败，退出代码: $?"' ERR

# 执行主函数
main "$@"