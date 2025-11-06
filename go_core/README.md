# FlClash Go Core

FlClash Go Core 是 FlClash 项目的核心 Go 模块，提供代理服务、流量监控和回调管理功能。

## 功能特性

- **代理核心**: 基于 ClashMeta 的代理服务管理
- **流量监控**: 实时流量统计和监控
- **回调管理**: 事件驱动的回调系统
- **多平台支持**: 支持 Linux、Windows、macOS
- **模块化设计**: 清晰的代码结构和依赖管理

## 目录结构

```
go_core/
├── main.go                  # 主入口文件
├── go.mod                   # Go 模块定义
├── Makefile                 # 构建脚本
├── README.md               # 项目文档
└── internal/               # 内部实现包
    └── internal.go         # 包声明文件
```

## 核心组件

### 1. ProxyCore (代理核心)
- 管理 ClashMeta 进程
- 处理客户端连接
- 支持多种代理模式 (Global/Rule/Direct)

### 2. TrafficMonitor (流量监控)
- 实时流量统计
- 速度监控
- 历史数据记录

### 3. CallbackManager (回调管理)
- 事件驱动系统
- 异步回调处理
- 预定义回调函数

## 快速开始

### 环境要求
- Go 1.21+
- ClashMeta 二进制文件（可选）

### 构建和运行

```bash
# 下载依赖
make mod-download

# 运行项目
make run

# 构建项目
make build

# 运行测试
make test

# 查看所有命令
make help
```

### 开发模式

```bash
# 开发模式运行（启用调试日志）
make dev

# 代码格式化和检查
make fmt
make vet

# 运行基准测试
make bench
```

## 配置说明

代理核心支持以下配置选项：

```go
type Config struct {
    ListenAddr string    // 监听地址
    ListenPort int       // 监听端口
    Mode       Mode      // 代理模式
    LogLevel   string    // 日志级别
    
    // ClashMeta 相关
    ClashConfigPath string  // 配置文件路径
    ClashBinPath    string  // 二进制文件路径
}
```

## 代理模式

- **Global**: 所有流量通过 ClashMeta
- **Rule**: 根据规则决定是否代理
- **Direct**: 直接连接，不使用代理

## 回调事件

系统支持以下事件类型：

- `proxy_started/stopped`: 代理服务启动/停止
- `mode_changed`: 代理模式切换
- `traffic_updated`: 流量数据更新
- `connection_added/removed`: 连接添加/移除
- `clash_started/stopped/error`: ClashMeta 状态

## 开发指南

### 添加新的回调事件

1. 在 `callback_manager.go` 中定义新的事件类型
2. 在相应的组件中调用 `TriggerCallback`
3. 注册回调函数处理事件

### 扩展代理功能

1. 在 `proxy_core.go` 中添加新的方法
2. 实现具体的代理逻辑
3. 更新配置结构以支持新功能

### 流量监控扩展

1. 在 `traffic_monitor.go` 中添加新的监控指标
2. 实现数据收集逻辑
3. 更新统计结构

## 构建平台

支持以下平台的交叉编译：

- Linux (amd64/arm64)
- Windows (amd64/arm64)
- macOS (amd64/arm64)

```bash
# 构建所有平台
make build-all

# 构建特定平台
make build-linux
make build-windows
make build-darwin
```

## 测试

```bash
# 运行所有测试
make test

# 生成覆盖率报告
make test-coverage

# 运行基准测试
make bench
```

## 代码质量

```bash
# 代码格式化
make fmt

# 代码检查
make vet

# 静态分析（需要安装 golangci-lint）
make lint

# 安全检查（需要安装 gosec）
make security
```

## Docker 构建

```bash
# 构建 Docker 镜像
make docker-build
```

## 注意事项

1. 这是一个基础框架，完整功能需要进一步开发
2. ClashMeta 集成逻辑需要根据实际需求实现
3. 流量监控目前使用模拟数据，需要集成真实的网络接口
4. 错误处理和日志记录可以进一步完善

## 许可证

与主项目保持一致的许可证。

## 贡献

请遵循项目的代码规范和测试要求。

## 更新日志

- v0.1.0: 初始版本，包含基础框架和组件结构