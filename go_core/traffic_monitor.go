package traffic_monitor

import (
	"context"
	"sync"
	"time"

	"github.com/flclash/go_core/internal/callback_manager"
	"github.com/sirupsen/logrus"
)

// TrafficData 流量数据
type TrafficData struct {
	Timestamp time.Time
	Upload    int64
	Download  int64
	Total     int64
}

// TrafficStats 流量统计信息
type TrafficStats struct {
	CurrentUpload   int64
	CurrentDownload int64
	CurrentTotal    int64
	
	SessionUpload   int64
	SessionDownload int64
	SessionTotal    int64
	
	History []TrafficData
	
	sync.Mutex
}

// TrafficMonitor 流量监控器
type TrafficMonitor struct {
	stats       *TrafficStats
	callbackMgr *callback_manager.CallbackManager
	
	// 监控配置
	updateInterval time.Duration
	
	// 控制
	ctx    context.Context
	cancel context.CancelFunc
}

// NewTrafficMonitor 创建新的流量监控器
func NewTrafficMonitor(callbackMgr *callback_manager.CallbackManager) *TrafficMonitor {
	ctx, cancel := context.WithCancel(context.Background())
	
	tm := &TrafficMonitor{
		stats: &TrafficStats{
			History: make([]TrafficData, 0),
		},
		callbackMgr:  callbackMgr,
		updateInterval: 1 * time.Second,
		ctx:            ctx,
		cancel:         cancel,
	}

	return tm
}

// Start 启动流量监控
func (tm *TrafficMonitor) Start(ctx context.Context) error {
	logrus.Info("启动流量监控器...")
	
	go tm.monitoringLoop()
	
	return nil
}

// Stop 停止流量监控
func (tm *TrafficMonitor) Stop() {
	logrus.Info("停止流量监控器...")
	
	if tm.cancel != nil {
		tm.cancel()
	}
}

// GetStats 获取当前流量统计
func (tm *TrafficMonitor) GetStats() *TrafficStats {
	tm.stats.Lock()
	defer tm.stats.Unlock()
	
	// 返回副本以避免并发问题
	statsCopy := *tm.stats
	statsCopy.History = make([]TrafficData, len(tm.stats.History))
	copy(statsCopy.History, tm.stats.History)
	
	return &statsCopy
}

// RecordTraffic 记录流量数据
func (tm *TrafficMonitor) RecordTraffic(upload, download int64) {
	tm.stats.Lock()
	defer tm.stats.Unlock()

	// 更新当前流量
	tm.stats.CurrentUpload = upload
	tm.stats.CurrentDownload = download
	tm.stats.CurrentTotal = upload + download

	// 更新会话流量
	tm.stats.SessionUpload = tm.calculateSessionTotal("upload", upload)
	tm.stats.SessionDownload = tm.calculateSessionTotal("download", download)
	tm.stats.SessionTotal = tm.stats.SessionUpload + tm.stats.SessionDownload

	// 添加到历史记录
	trafficData := TrafficData{
		Timestamp: time.Now(),
		Upload:    upload,
		Download:  download,
		Total:     upload + download,
	}
	
	tm.stats.History = append(tm.stats.History, trafficData)
	
	// 保持历史记录在合理范围内
	if len(tm.stats.History) > 3600 { // 保留1小时的数据（按1秒间隔）
		tm.stats.History = tm.stats.History[1:]
	}
}

// ResetSession 重置会话统计
func (tm *TrafficMonitor) ResetSession() {
	tm.stats.Lock()
	defer tm.stats.Unlock()

	logrus.Info("重置会话流量统计")
	
	tm.stats.SessionUpload = 0
	tm.stats.SessionDownload = 0
	tm.stats.SessionTotal = 0
	
	// 清空历史记录
	tm.stats.History = make([]TrafficData, 0)
}

// SetUpdateInterval 设置更新间隔
func (tm *TrafficMonitor) SetUpdateInterval(interval time.Duration) {
	tm.updateInterval = interval
}

// GetSpeed 获取当前速度 (bytes/second)
func (tm *TrafficMonitor) GetSpeed() (uploadSpeed, downloadSpeed int64) {
	tm.stats.Lock()
	defer tm.stats.Unlock()
	
	if len(tm.stats.History) < 2 {
		return 0, 0
	}
	
	// 获取最近5秒的数据来计算平均速度
	recentData := tm.getRecentData(5)
	if len(recentData) < 2 {
		return 0, 0
	}
	
	uploadSpeed = tm.calculateSpeed(recentData, "upload")
	downloadSpeed = tm.calculateSpeed(recentData, "download")
	
	return uploadSpeed, downloadSpeed
}

// monitoringLoop 监控循环
func (tm *TrafficMonitor) monitoringLoop() {
	ticker := time.NewTicker(tm.updateInterval)
	defer ticker.Stop()

	for {
		select {
		case <-tm.ctx.Done():
			return
		case <-ticker.C:
			tm.updateTrafficStats()
		}
	}
}

// updateTrafficStats 更新流量统计
func (tm *TrafficMonitor) updateTrafficStats() {
	// 这里应该从实际的网络接口获取真实的流量数据
	// 目前使用模拟数据
	
	upload, download := tm.GetSpeed()
	
	// 模拟随机流量（待替换为实际数据采集）
	tm.RecordTraffic(upload, download)
	
	// 触发流量更新回调
	tm.callbackMgr.TriggerCallback("traffic_updated", map[string]interface{}{
		"upload_speed":   upload,
		"download_speed": download,
		"total_upload":   tm.stats.CurrentUpload,
		"total_download": tm.stats.CurrentDownload,
	})
}

// calculateSessionTotal 计算会话总计
func (tm *TrafficMonitor) calculateSessionTotal(direction string, current int64) int64 {
	// 简单的累计计算（可以扩展为更复杂的逻辑）
	return tm.stats.SessionTotal + current
}

// getRecentData 获取最近的数据点
func (tm *TrafficMonitor) getRecentData(seconds int) []TrafficData {
	tm.stats.Lock()
	defer tm.stats.Unlock()

	if len(tm.stats.History) == 0 {
		return nil
	}

	startIdx := 0
	if len(tm.stats.History) > seconds {
		startIdx = len(tm.stats.History) - seconds
	}

	data := make([]TrafficData, len(tm.stats.History)-startIdx)
	copy(data, tm.stats.History[startIdx:])

	return data
}

// calculateSpeed 计算速度
func (tm *TrafficMonitor) calculateSpeed(data []TrafficData, direction string) int64 {
	if len(data) < 2 {
		return 0
	}

	first := data[0]
	last := data[len(data)-1]

	timeDiff := last.Timestamp.Sub(first.Timestamp).Seconds()
	if timeDiff <= 0 {
		return 0
	}

	var totalDiff int64
	switch direction {
	case "upload":
		totalDiff = last.Upload - first.Upload
	case "download":
		totalDiff = last.Download - first.Download
	default:
		totalDiff = last.Total - first.Total
	}

	return int64(float64(totalDiff) / timeDiff)
}

// GetConnectionStats 获取连接统计
func (tm *TrafficMonitor) GetConnectionStats() map[string]interface{} {
	uploadSpeed, downloadSpeed := tm.GetSpeed()
	
	tm.stats.Lock()
	defer tm.stats.Unlock()
	
	return map[string]interface{}{
		"active_connections": 0, // TODO: 从代理核心获取
		"current_upload":     tm.stats.CurrentUpload,
		"current_download":   tm.stats.CurrentDownload,
		"session_upload":     tm.stats.SessionUpload,
		"session_download":   tm.stats.SessionDownload,
		"upload_speed":       uploadSpeed,
		"download_speed":     downloadSpeed,
	}
}