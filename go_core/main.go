package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/flclash/go_core/internal/proxy_core"
	"github.com/flclash/go_core/internal/traffic_monitor"
	"github.com/flclash/go_core/internal/callback_manager"
	"github.com/sirupsen/logrus"
)

func main() {
	// 初始化日志
	initLogging()

	logrus.Info("FlClash Go Core 启动中...")

	// 初始化配置管理
	cfg, err := loadConfig()
	if err != nil {
		logrus.Fatalf("加载配置失败: %v", err)
	}

	// 创建回调管理器
	callbackMgr := callback_manager.NewCallbackManager()

	// 创建流量监控器
	trafficMonitor := traffic_monitor.NewTrafficMonitor(callbackMgr)

	// 创建代理核心
	proxyCore, err := proxy_core.NewProxyCore(cfg, callbackMgr, trafficMonitor)
	if err != nil {
		logrus.Fatalf("初始化代理核心失败: %v", err)
	}

	// 设置信号处理
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	setupSignalHandler(ctx, cancel, proxyCore)

	// 启动服务
	if err := startServices(ctx, proxyCore, trafficMonitor); err != nil {
		logrus.Fatalf("启动服务失败: %v", err)
	}

	// 等待中断信号
	<-ctx.Done()
	
	// 清理资源
	cleanup(proxyCore, trafficMonitor)
	
	logrus.Info("FlClash Go Core 已停止")
}

func initLogging() {
	// 设置日志格式
	logrus.SetFormatter(&logrus.TextFormatter{
		FullTimestamp: true,
		DisableColors: false,
	})

	// 设置日志级别
	logrus.SetLevel(logrus.InfoLevel)

	// 如果在开发环境中，可以设置为 Debug 级别
	if os.Getenv("FLCLASH_ENV") == "development" {
		logrus.SetLevel(logrus.DebugLevel)
	}
}

func loadConfig() (*proxy_core.Config, error) {
	// TODO: 从配置文件或环境变量加载配置
	return &proxy_core.Config{
		ListenAddr: "127.0.0.1",
		ListenPort: 7890,
		Mode:       proxy_core.ModeGlobal,
		LogLevel:   "info",
	}, nil
}

func startServices(ctx context.Context, proxyCore *proxy_core.ProxyCore, trafficMonitor *traffic_monitor.TrafficMonitor) error {
	logrus.Info("启动代理核心...")
	if err := proxyCore.Start(ctx); err != nil {
		return fmt.Errorf("启动代理核心失败: %v", err)
	}

	logrus.Info("启动流量监控...")
	if err := trafficMonitor.Start(ctx); err != nil {
		return fmt.Errorf("启动流量监控失败: %v", err)
	}

	logrus.Info("所有服务已启动")
	return nil
}

func setupSignalHandler(ctx context.Context, cancel context.CancelFunc, proxyCore *proxy_core.ProxyCore) {
	c := make(chan os.Signal, 1)
	signal.Notify(c, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		sig := <-c
		logrus.Infof("接收到信号: %v", sig)
		
		// 设置超时关闭
		shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer shutdownCancel()
		
		cancel()
		
		// 等待上下文取消
		<-shutdownCtx.Done()
		
		os.Exit(0)
	}()
}

func cleanup(proxyCore *proxy_core.ProxyCore, trafficMonitor *traffic_monitor.TrafficMonitor) {
	logrus.Info("清理资源...")
	
	if trafficMonitor != nil {
		trafficMonitor.Stop()
	}
	
	if proxyCore != nil {
		proxyCore.Stop()
	}
	
	logrus.Info("资源清理完成")
}