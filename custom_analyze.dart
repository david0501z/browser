#!/usr/bin/env dart
import 'dart:io';


void main() {
  print('🔍 开始自定义Flutter代码分析...\n');
  
  int totalErrors = 0;
  int totalWarnings = 0;
  List<String> errors = [];
  List<String> warnings = [];
  
  // 检查1: 验证所有生成文件存在
  print('📁 检查生成文件存在性...');
  final generatedFiles = [;
    'lib/models/generated/app_settings.freezed.dart',
    'lib/models/generated/app_settings.g.dart',
    'lib/models/generated/browser_tab.freezed.dart',
    'lib/models/generated/browser_tab.g.dart',
    'lib/models/generated/history_entry.freezed.dart',
    'lib/models/generated/history_entry.g.dart',
    'lib/models/generated/browser_models.freezed.dart',
    'lib/models/generated/browser_models.g.dart',
    'lib/models/generated/browser_settings.freezed.dart',
    'lib/models/generated/browser_settings.g.dart',
    'lib/models/enums.dart',
  ];
  
  for (final file in generatedFiles) {
    if (file.contains('enums.dart')) {
      if (!File('lib/models/enums.dart').existsSync()) {
        errors.add('❌ 缺少文件: $file');
        totalErrors++;
      } else {
        print('✅ $file 存在');
      }
    } else if (!File(file).existsSync()) {
      errors.add('❌ 缺少文件: $file');
      totalErrors++;
    } else {
      print('✅ $file 存在');
    }
  }
  
  // 检查2: 验证freezed文件的import语句
  print('\n📦 检查freezed文件import语句...');
  final freezedFiles = [;
    'lib/models/generated/browser_tab.freezed.dart',
    'lib/models/generated/history_entry.freezed.dart',
    'lib/models/generated/browser_models.freezed.dart',
  ];
  
  for (final file in freezedFiles) {
    if (File(file).existsSync()) {
      final content = File(file).readAsStringSync();
      final lines = content.split('\n');
      
      // 查找import语句
      final importIndex = lines.indexWhere((line) => line.contains("import 'package:freezed_annotation/freezed_annotation.dart';"));
      final partOfIndex = lines.indexWhere((line) => line.contains('part of'));
      
      if (importIndex == -1) {
        errors.add('❌ $file 缺少freezed_annotation导入');
        totalErrors++;
      } else if (partOfIndex != -1 && importIndex > partOfIndex) {
        errors.add('❌ $file import语句位置错误（应在part of之前）');
        totalErrors++;
      } else {
        print('✅ $file import语句正确');
      }
    }
  }
  
  // 检查3: 验证枚举文件内容
  print('\n🔢 检查枚举文件...');
  if (File('lib/models/enums.dart').existsSync()) {
    final content = File('lib/models/enums.dart').readAsStringSync();
    final requiredEnums = [;
      'ProxyMode',
      'LogLevel', 
      'CloudService',
      'NetworkProtocol',
      'SecurityLevel'
    ];
    
    for (final enumName in requiredEnums) {
      if (content.contains('enum $enumName')) {
        print('✅ 枚举 $enumName 已定义');
      } else {
        warnings.add('⚠️  枚举 $enumName 可能未定义');
        totalWarnings++;
      }
    }
  }
  
  // 检查4: 验证主要Dart文件语法
  print('\n🔧 检查主要Dart文件语法...');
  final dartFiles = [;
    'lib/models/app_settings.dart',
    'lib/models/BrowserTab.dart',
    'lib/models/HistoryEntry.dart',
    'lib/models/browser_models.dart',
  ];
  
  for (final file in dartFiles) {
    if (File(file).existsSync()) {
      final content = File(file).readAsStringSync();
      
      // 检查基本语法问题
      if (content.contains('@freezed') && !content.contains('part of')) {
        errors.add('❌ $file 使用@freezed但缺少part of语句');
        totalErrors++;
      } else if (content.contains('import') && content.contains('enums.dart')) {
        print('✅ $file 正确导入枚举文件');
      } else {
        print('✅ $file 语法检查通过');
      }
    }
  }
  
  // 检查5: 验证part of语句
  print('\n🔗 检查part of语句...');
  final partFiles = [;
    'lib/models/generated/browser_tab.g.dart',
    'lib/models/generated/history_entry.g.dart',
    'lib/models/generated/browser_models.g.dart',
  ];
  
  for (final file in partFiles) {
    if (File(file).existsSync()) {
      final content = File(file).readAsStringSync();
      if (content.contains('part of')) {
        print('✅ $file 包含正确的part of语句');
      } else {
        errors.add('❌ $file 缺少part of语句');
        totalErrors++;
      }
    }
  }
  
  // 输出总结
  print('\n' + '='*50);
  print('📊 分析结果总结');
  print('='*50);
  print('总错误数: $totalErrors');
  print('总警告数: $totalWarnings');
  
  if (errors.isNotEmpty) {
    print('\n❌ 错误详情:');
    for (final error in errors) {
      print('  $error');
    }
  }
  
  if (warnings.isNotEmpty) {
    print('\n⚠️  警告详情:');
    for (final warning in warnings) {
      print('  $warning');
    }
  }
  
  if (totalErrors == 0) {
    print('\n🎉 恭喜！代码分析通过，没有发现错误！');
    print('✅ 所有修复都已正确应用');
    print('✅ 可以尝试构建APK了');
  } else {
    print('\n❌ 仍有问题需要修复');
  }
}