package proxy_core

import (
	"context"
	"net"

	"github.com/flclash/go_core/internal/callback_manager"
	"github.com/flclash/go_core/internal/traffic_monitor"
	"github.com/sirupsen/logrus"
)

// Mode 代理模式
type Mode string

const (
	ModeGlobal Mode = "global"
	ModeRule   Mode = "rule"
	ModeDirect Mode = "direct"
)

// Config 代理核心配置
type Config struct {
	ListenAddr string
	ListenPort int
	Mode       Mode
	LogLevel   string
	
	// ClashMeta 相关配置
	ClashConfigPath string
	ClashBinPath    string
}

// ProxyCore 代理核心结构体
type ProxyCore struct {
	config       *Config
	listener     net.Listener
	isRunning    bool
	callbackMgr  *callback_manager.CallbackManager
	trafficMgr   *traffic_monitor.TrafficMonitor
	
	// 统计信息
	stats *ProxyStats
}

// ProxyStats 代理统计信息
type ProxyStats struct {
	ConnectedClients int64
	TotalBytes       int64
	UploadBytes      int64
	DownloadBytes    int64
}

// NewProxyCore 创建新的代理核心实例
func NewProxyCore(cfg *Config, callbackMgr *callback_manager.CallbackManager, trafficMgr *traffic_monitor.TrafficMonitor) (*ProxyCore, error) {
	if cfg == nil {
		return nil, NewError("配置不能为空")
	}
	
	if callbackMgr == nil {
		return nil, NewError("回调管理器不能为空")
	}
	
	if trafficMgr == nil {
		return nil, NewError("流量管理器不能为空")
	}

	return &ProxyCore{
		config:      cfg,
		callbackMgr: callbackMgr,
		trafficMgr:  trafficMgr,
		stats:       &ProxyStats{},
		isRunning:   false,
	}, nil
}

// Start 启动代理核心
func (pc *ProxyCore) Start(ctx context.Context) error {
	if pc.isRunning {
		return NewError("代理核心已经在运行")
	}

	logrus.Infof("启动代理核心，监听地址: %s:%d", pc.config.ListenAddr, pc.config.ListenPort)

	// 启动 ClashMeta 进程（如果需要）
	if err := pc.startClashMeta(ctx); err != nil {
		return err
	}

	// 启动本地代理监听器
	if err := pc.startListener(ctx); err != nil {
		return err
	}

	pc.isRunning = true
	
	// 触发启动回调
	pc.callbackMgr.TriggerCallback(callback_manager.EventProxyStarted, map[string]interface{}{
		"mode": pc.config.Mode,
	})
	
	return nil
}

// Stop 停止代理核心
func (pc *ProxyCore) Stop() error {
	if !pc.isRunning {
		return NewError("代理核心未运行")
	}

	logrus.Info("停止代理核心...")

	pc.isRunning = false

	// 停止监听器
	if pc.listener != nil {
		pc.listener.Close()
		pc.listener = nil
	}

	// 停止 ClashMeta 进程
	pc.stopClashMeta()

	// 触发停止回调
	pc.callbackMgr.TriggerCallback(callback_manager.EventProxyStopped, nil)

	logrus.Info("代理核心已停止")
	return nil
}

// GetStats 获取代理统计信息
func (pc *ProxyCore) GetStats() *ProxyStats {
	return pc.stats
}

// SetMode 设置代理模式
func (pc *ProxyCore) SetMode(mode Mode) error {
	if !pc.isRunning {
		return NewError("代理核心未运行")
	}

	pc.config.Mode = mode
	
	logrus.Infof("代理模式已切换到: %s", mode)
	
	// 触发模式切换回调
	pc.callbackMgr.TriggerCallback(callback_manager.EventModeChanged, map[string]interface{}{
		"new_mode": mode,
	})
	
	return nil
}

// startClashMeta 启动 ClashMeta 进程
func (pc *ProxyCore) startClashMeta(ctx context.Context) error {
	// TODO: 实现 ClashMeta 进程的启动和管理
	logrus.Info("ClashMeta 进程启动逻辑待实现")
	return nil
}

// stopClashMeta 停止 ClashMeta 进程
func (pc *ProxyCore) stopClashMeta() {
	// TODO: 实现 ClashMeta 进程的停止
	logrus.Info("ClashMeta 进程停止逻辑待实现")
}

// startListener 启动本地代理监听器
func (pc *ProxyCore) startListener(ctx context.Context) error {
	var err error
	
	address := fmt.Sprintf("%s:%d", pc.config.ListenAddr, pc.config.ListenPort)
	pc.listener, err = net.Listen("tcp", address)
	if err != nil {
		return NewError("启动监听器失败: %v", err)
	}

	go pc.handleConnections(ctx)
	
	return nil
}

// handleConnections 处理客户端连接
func (pc *ProxyCore) handleConnections(ctx context.Context) {
	for {
		conn, err := pc.listener.Accept()
		if err != nil {
			select {
			case <-ctx.Done():
				return
			default:
				logrus.Errorf("接受连接失败: %v", err)
				continue
			}
		}

		go pc.handleClientConnection(conn)
	}
}

// handleClientConnection 处理单个客户端连接
func (pc *ProxyCore) handleClientConnection(conn net.Conn) {
	defer conn.Close()

	logrus.Debugf("新客户端连接: %s", conn.RemoteAddr())

	// 更新连接统计
	pc.stats.ConnectedClients++

	// TODO: 实现具体的代理逻辑
	// 这里需要根据代理模式处理连接：
	// - Global: 流量全部通过 ClashMeta
	// - Rule: 根据规则决定是否通过 ClashMeta
	// - Direct: 直接连接

	// 简单的回显逻辑（待替换）
	buffer := make([]byte, 4096)
	n, err := conn.Read(buffer)
	if err != nil {
		logrus.Errorf("读取连接数据失败: %v", err)
		return
	}

	logrus.Debugf("收到数据: %s", string(buffer[:n]))
	
	// 更新流量统计
	pc.stats.UploadBytes += int64(n)
	
	// 回显数据
	conn.Write(buffer[:n])
}

// NewError 创建新的错误
func NewError(format string, args ...interface{}) error {
	return fmt.Errorf("ProxyCore: "+format, args...)
}