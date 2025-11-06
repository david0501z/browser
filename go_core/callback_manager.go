package callback_manager

import (
	"sync"
	"time"

	"github.com/sirupsen/logrus"
)

// EventType 事件类型
type EventType string

const (
	// 代理相关事件
	EventProxyStarted  EventType = "proxy_started"
	EventProxyStopped  EventType = "proxy_stopped"
	EventModeChanged   EventType = "mode_changed"
	EventConfigChanged EventType = "config_changed"
	
	// 流量相关事件
	EventTrafficUpdated EventType = "traffic_updated"
	EventSpeedChanged   EventType = "speed_changed"
	
	// 连接相关事件
	EventConnectionAdded   EventType = "connection_added"
	EventConnectionRemoved EventType = "connection_removed"
	EventConnectionError   EventType = "connection_error"
	
	// ClashMeta 相关事件
	EventClashStarted  EventType = "clash_started"
	EventClashStopped  EventType = "clash_stopped"
	EventClashError    EventType = "clash_error"
	EventConfigLoaded  EventType = "config_loaded"
	
	// 系统相关事件
	EventSystemError EventType = "system_error"
	EventSystemInfo  EventType = "system_info"
)

// CallbackFunc 回调函数类型
type CallbackFunc func(event EventType, data map[string]interface{})

// CallbackManager 回调管理器
type CallbackManager struct {
	callbacks map[EventType][]CallbackFunc
	mutex     sync.RWMutex
}

// Event 事件结构
type Event struct {
	Type      EventType
	Data      map[string]interface{}
	Timestamp time.Time
}

// NewCallbackManager 创建新的回调管理器
func NewCallbackManager() *CallbackManager {
	return &CallbackManager{
		callbacks: make(map[EventType][]CallbackFunc),
	}
}

// RegisterCallback 注册回调函数
func (cm *CallbackManager) RegisterCallback(event EventType, callback CallbackFunc) {
	cm.mutex.Lock()
	defer cm.mutex.Unlock()

	cm.callbacks[event] = append(cm.callbacks[event], callback)
	logrus.Debugf("注册回调函数，事件类型: %s", event)
}

// UnregisterCallback 取消注册回调函数
func (cm *CallbackManager) UnregisterCallback(event EventType, callback CallbackFunc) {
	cm.mutex.Lock()
	defer cm.mutex.Unlock()

	callbacks := cm.callbacks[event]
	for i, cb := range callbacks {
		// 由于函数无法比较，这里简单地移除所有回调
		// 在实际使用中，可以为每个回调分配唯一ID
		if i < len(callbacks)-1 {
			callbacks[i] = callbacks[i+1]
		}
	}
	cm.callbacks[event] = callbacks[:len(callbacks)-1]
	
	logrus.Debugf("取消注册回调函数，事件类型: %s", event)
}

// ClearCallbacks 清除指定事件的所有回调
func (cm *CallbackManager) ClearCallbacks(event EventType) {
	cm.mutex.Lock()
	defer cm.mutex.Unlock()

	delete(cm.callbacks, event)
	logrus.Debugf("清除所有回调函数，事件类型: %s", event)
}

// TriggerCallback 触发回调
func (cm *CallbackManager) TriggerCallback(event EventType, data map[string]interface{}) {
	// 创建事件
	evt := Event{
		Type:      event,
		Data:      data,
		Timestamp: time.Now(),
	}

	// 获取回调函数列表
	cm.mutex.RLock()
	callbacks := make([]CallbackFunc, len(cm.callbacks[event]))
	copy(callbacks, cm.callbacks[event])
	cm.mutex.RUnlock()

	// 调用所有回调函数
	for _, callback := range callbacks {
		go func(cb CallbackFunc) {
			defer func() {
				if r := recover(); r != nil {
					logrus.Errorf("回调函数 panic: %v", r)
				}
			}()
			cb(evt.Type, evt.Data)
		}(callback)
	}

	logrus.Debugf("触发回调，事件类型: %s，数据: %+v", event, data)
}

// TriggerCallbackSync 同步触发回调（按顺序执行）
func (cm *CallbackManager) TriggerCallbackSync(event EventType, data map[string]interface{}) {
	// 创建事件
	evt := Event{
		Type:      event,
		Data:      data,
		Timestamp: time.Now(),
	}

	// 获取回调函数列表
	cm.mutex.RLock()
	callbacks := make([]CallbackFunc, len(cm.callbacks[event]))
	copy(callbacks, cm.callbacks[event])
	cm.mutex.RUnlock()

	// 按顺序调用所有回调函数
	for _, callback := range callbacks {
		func(cb CallbackFunc) {
			defer func() {
				if r := recover(); r != nil {
					logrus.Errorf("回调函数 panic: %v", r)
				}
			}()
			cb(evt.Type, evt.Data)
		}(callback)
	}

	logrus.Debugf("同步触发回调，事件类型: %s，数据: %+v", event, data)
}

// GetCallbackCount 获取指定事件的回调数量
func (cm *CallbackManager) GetCallbackCount(event EventType) int {
	cm.mutex.RLock()
	defer cm.mutex.RUnlock()

	return len(cm.callbacks[event])
}

// GetAllEvents 获取所有已注册的事件类型
func (cm *CallbackManager) GetAllEvents() []EventType {
	cm.mutex.RLock()
	defer cm.mutex.RUnlock()

	events := make([]EventType, 0, len(cm.callbacks))
	for event := range cm.callbacks {
		events = append(events, event)
	}

	return events
}

// EventDataBuilder 事件数据构建器
type EventDataBuilder struct {
	data map[string]interface{}
}

// NewEventDataBuilder 创建新的事件数据构建器
func NewEventDataBuilder() *EventDataBuilder {
	return &EventDataBuilder{
		data: make(map[string]interface{}),
	}
}

// Add 添加键值对
func (edb *EventDataBuilder) Add(key string, value interface{}) *EventDataBuilder {
	edb.data[key] = value
	return edb
}

// Build 构建事件数据
func (edb *EventDataBuilder) Build() map[string]interface{} {
	return edb.data
}

// PredefinedCallback 预定义的回调函数

// LoggingCallback 日志记录回调
func LoggingCallback(event EventType, data map[string]interface{}) {
	logrus.Infof("事件: %s, 数据: %+v", event, data)
}

// ErrorCallback 错误处理回调
func ErrorCallback(event EventType, data map[string]interface{}) {
	if event == EventSystemError || event == EventClashError {
		logrus.Errorf("错误事件: %s, 数据: %+v", event, data)
	}
}

// TrafficCallback 流量统计回调
func TrafficCallback(event EventType, data map[string]interface{}) {
	if event == EventTrafficUpdated {
		uploadSpeed := data["upload_speed"]
		downloadSpeed := data["download_speed"]
		totalUpload := data["total_upload"]
		totalDownload := data["total_download"]
		
		logrus.Infof("流量更新 - 上传速度: %v bytes/s, 下载速度: %v bytes/s, 总上传: %v, 总下载: %v",
			uploadSpeed, downloadSpeed, totalUpload, totalDownload)
	}
}

// ModeCallback 模式切换回调
func ModeCallback(event EventType, data map[string]interface{}) {
	if event == EventModeChanged {
		newMode := data["new_mode"]
		logrus.Infof("代理模式已切换到: %v", newMode)
	}
}

// ConnectionCallback 连接状态回调
func ConnectionCallback(event EventType, data map[string]interface{}) {
	switch event {
	case EventConnectionAdded:
		addr := data["address"]
		logrus.Infof("新连接: %v", addr)
	case EventConnectionRemoved:
		addr := data["address"]
		logrus.Infof("连接已断开: %v", addr)
	case EventConnectionError:
		addr := data["address"]
		err := data["error"]
		logrus.Errorf("连接错误: %v, 错误信息: %v", addr, err)
	}
}