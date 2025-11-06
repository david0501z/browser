# FlClash Go Core Makefile

# 项目配置
PROJECT_NAME := flclash_go_core
MAIN_PACKAGE := .
BUILD_DIR := build
BIN_DIR := $(BUILD_DIR)/bin

# Go 配置
GOCMD := go
GOBUILD := $(GOCMD) build
GOCLEAN := $(GOCMD) clean
GOTEST := $(GOCMD) test
GOGET := $(GOCMD) get
GOMOD := $(GOCMD) mod

# 构建配置
LDFLAGS := -ldflags "-X main.version=$(shell git describe --tags --always --dirty) -X main.build=$(shell date +%Y%m%d-%H%M%S)"

# 目标平台配置
GOOS := $(shell $(GOCMD) env GOOS)
GOARCH := $(shell $(GOCMD) env GOARCH)

# 默认目标
.DEFAULT_GOAL := help

# 帮助信息
.PHONY: help
help:
	@echo "FlClash Go Core 构建工具"
	@echo ""
	@echo "可用命令:"
	@echo "  build        - 构建项目"
	@echo "  build-all    - 构建所有平台"
	@echo "  run          - 运行项目"
	@echo "  test         - 运行测试"
	@echo "  test-coverage- 运行测试并生成覆盖率报告"
	@echo "  fmt          - 格式化代码"
	@echo "  vet          - 运行 go vet"
	@echo "  mod-download - 下载依赖"
	@echo "  mod-tidy     - 整理依赖"
	@echo "  clean        - 清理构建文件"
	@echo "  install      - 安装到系统"
	@echo "  docker-build - 构建 Docker 镜像"
	@echo "  lint         - 代码检查"
	@echo "  bench        - 运行基准测试"
	@echo ""
	@echo "构建平台目标:"
	@echo "  build-linux   - 构建 Linux 版本"
	@echo "  build-windows - 构建 Windows 版本"
	@echo "  build-darwin  - 构建 macOS 版本"

# 构建项目
.PHONY: build
build:
	@echo "构建 FlClash Go Core..."
	@mkdir -p $(BIN_DIR)
	$(GOBUILD) $(LDFLAGS) -o $(BIN_DIR)/$(PROJECT_NAME) $(MAIN_PACKAGE)
	@echo "构建完成: $(BIN_DIR)/$(PROJECT_NAME)"

# 构建所有平台
.PHONY: build-all
build-all: build-linux build-windows build-darwin
	@echo "所有平台构建完成"

# 构建 Linux 版本
.PHONY: build-linux
build-linux:
	@echo "构建 Linux 版本..."
	@mkdir -p $(BIN_DIR)
	GOOS=linux GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(BIN_DIR)/$(PROJECT_NAME)_linux_amd64 $(MAIN_PACKAGE)
	@echo "Linux 版本构建完成"

# 构建 Windows 版本
.PHONY: build-windows
build-windows:
	@echo "构建 Windows 版本..."
	@mkdir -p $(BIN_DIR)
	GOOS=windows GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(BIN_DIR)/$(PROJECT_NAME)_windows_amd64.exe $(MAIN_PACKAGE)
	@echo "Windows 版本构建完成"

# 构建 macOS 版本
.PHONY: build-darwin
build-darwin:
	@echo "构建 macOS 版本..."
	@mkdir -p $(BIN_DIR)
	GOOS=darwin GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(BIN_DIR)/$(PROJECT_NAME)_darwin_amd64 $(MAIN_PACKAGE)
	@echo "macOS 版本构建完成"

# 运行项目
.PHONY: run
run:
	@echo "运行 FlClash Go Core..."
	$(GOCMD) run $(MAIN_PACKAGE)

# 测试
.PHONY: test
test:
	@echo "运行测试..."
	$(GOTEST) -v ./...

# 测试覆盖率
.PHONY: test-coverage
test-coverage:
	@echo "运行测试并生成覆盖率报告..."
	$(GOTEST) -coverprofile=coverage.out ./...
	$(GOCMD) tool cover -html=coverage.out -o coverage.html
	@echo "覆盖率报告已生成: coverage.html"

# 格式化代码
.PHONY: fmt
fmt:
	@echo "格式化代码..."
	$(GOCMD) fmt ./...

# 代码检查
.PHONY: vet
vet:
	@echo "运行 go vet..."
	$(GOCMD) vet ./...

# 下载依赖
.PHONY: mod-download
mod-download:
	@echo "下载依赖..."
	$(GOMOD) download

# 整理依赖
.PHONY: mod-tidy
mod-tidy:
	@echo "整理依赖..."
	$(GOMOD) tidy

# 清理构建文件
.PHONY: clean
clean:
	@echo "清理构建文件..."
	$(GOCLEAN)
	rm -rf $(BUILD_DIR)
	rm -f coverage.out coverage.html

# 安装到系统
.PHONY: install
install: build
	@echo "安装到系统..."
	sudo cp $(BIN_DIR)/$(PROJECT_NAME) /usr/local/bin/
	@echo "安装完成"

# 构建 Docker 镜像
.PHONY: docker-build
docker-build:
	@echo "构建 Docker 镜像..."
	docker build -t $(PROJECT_NAME):latest .
	@echo "Docker 镜像构建完成"

# 代码检查
.PHONY: lint
lint:
	@echo "运行代码检查..."
	@if command -v golangci-lint >/dev/null 2>&1; then \
		golangci-lint run; \
	else \
		echo "golangci-lint 未安装，跳过代码检查"; \
		echo "安装命令: go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest"; \
	fi

# 基准测试
.PHONY: bench
bench:
	@echo "运行基准测试..."
	$(GOCMD) test -bench=. -benchmem ./...

# 开发模式运行
.PHONY: dev
dev:
	@echo "开发模式运行..."
	FLCLASH_ENV=development $(GOCMD) run $(MAIN_PACKAGE)

# 发布版本构建
.PHONY: release
release: clean mod-tidy test lint build-all
	@echo "发布版本构建完成"

# CI 构建
.PHONY: ci-build
ci-build: mod-download fmt vet test build
	@echo "CI 构建完成"

# 版本信息
.PHONY: version
version:
	@echo "项目信息:"
	@echo "  版本: $(shell git describe --tags --always --dirty 2>/dev/null || echo '未标记版本')"
	@echo "  构建时间: $(shell date +'%Y-%m-%d %H:%M:%S')"
	@echo "  Go 版本: $(shell go version)"
	@echo "  Git 提交: $(shell git rev-parse HEAD 2>/dev/null || echo '未知')"

# 依赖检查
.PHONY: deps-check
deps-check:
	@echo "检查依赖..."
	@$(GOCMD) mod verify
	@echo "依赖检查完成"

# 调试版本构建
.PHONY: debug
debug:
	@echo "构建调试版本..."
	$(GOBUILD) -gcflags "all=-N -l" -o $(BIN_DIR)/$(PROJECT_NAME)_debug $(MAIN_PACKAGE)
	@echo "调试版本构建完成: $(BIN_DIR)/$(PROJECT_NAME)_debug"

# 性能分析版本
.PHONY: profile
profile:
	@echo "构建性能分析版本..."
	$(GOBUILD) -gcflags "all=-N -l" -o $(BIN_DIR)/$(PROJECT_NAME)_profile $(MAIN_PACKAGE)
	@echo "性能分析版本构建完成: $(BIN_DIR)/$(PROJECT_NAME)_profile"

# 生成 Protobuf 文件（如果需要）
.PHONY: proto
proto:
	@echo "生成 Protobuf 文件..."
	@if command -v protoc >/dev/null 2>&1; then \
		protoc --go_out=. --go_opt=paths=source_relative ./internal/proto/*.proto; \
		echo "Protobuf 文件生成完成"; \
	else \
		echo "protoc 未安装，跳过 Protobuf 生成"; \
	fi

# 更新依赖
.PHONY: update-deps
update-deps:
	@echo "更新依赖..."
	$(GOGET) -u ./...
	$(GOMOD) tidy
	@echo "依赖更新完成"

# 安全检查
.PHONY: security
security:
	@echo "运行安全检查..."
	@if command -v gosec >/dev/null 2>&1; then \
		gosec ./...; \
	else \
		echo "gosec 未安装，跳过安全检查"; \
		echo "安装命令: go install github.com/securecodewarrior/gosec/v2/cmd/gosec@latest"; \
	fi