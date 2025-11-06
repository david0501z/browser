/// UI设置模型
@freezed
class UI with _$UI {
  const factory UI({
    /// 主题模式
    @Default(ThemeMode.system) ThemeMode themeMode,
    
    /// 语言设置
    @Default('zh-CN') String language,
    
    /// 是否启用动画
    @Default(true) bool animations,
    
    /// 是否启用沉浸式状态栏
    @Default(true) bool immersiveStatusBar,
    
    /// 是否启用沉浸式导航栏
    @Default(true) bool immersiveNavigationBar,
    
    /// 底部安全区域
    @Default(true) bool safeAreaBottom,
    
    /// 字体大小
    @Default(FontSize.medium) FontSize fontSize,
    
    /// 字体粗细
    @Default(FontWeight.normal) FontWeight fontWeight,
    
    /// 高对比度
    @Default(false) bool highContrast,
    
    /// 粗体标签
    @Default(false) bool boldLabels,
  }) = _UI;
  
  const UI._();
  
  factory UI.fromJson(Map<String, Object?> json) => _$UIFromJson(json);
}

/// 字体粗细枚举
enum FontWeight {
  normal,
  bold,
  w100,
  w200,
  w300,
  w400,
  w500,
  w600,
  w700,
  w800,
  w900,
}