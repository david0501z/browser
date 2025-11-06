/// 优化模块测试文件
/// 
/// 验证优化模块的基本导入和功能
library optimization_test;

import 'index.dart';

void main() async {
  print('=== 优化模块测试开始 ===');
  
  try {
    // 测试基础导入
    print('✓ 基础类导入成功');
    
    // 测试配置创建
    final defaultConfig = createDefaultConfig();
    print('✓ 默认配置创建成功');
    
    final highPerfConfig = createHighPerformanceConfig();
    print('✓ 高性能配置创建成功');
    
    final powerSavingConfig = createPowerSavingConfig();
    print('✓ 省电配置创建成功');
    
    // 测试工具类
    final formattedBytes = OptimizationUtils.formatBytes(1024 * 1024);
    print('✓ 工具类方法调用成功: $formattedBytes');
    
    final qualityDesc = OptimizationUtils.getNetworkQualityLevel(QualityLevel.good);
    print('✓ 工具类枚举转换成功: $qualityDesc');
    
    print('=== 所有测试通过 ===');
    
  } catch (e, stackTrace) {
    print('❌ 测试失败: $e');
    print('StackTrace: $stackTrace');
  }
  
  print('=== 优化模块测试完成 ===');
}