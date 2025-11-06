#!/usr/bin/env python3
"""
FlClash Browser Flutter代码分析工具
用于识别编译错误和代码问题
"""

import os
import re
import json
from pathlib import Path
from typing import List, Dict, Set, Tuple

class FlutterCodeAnalyzer:
    def __init__(self, lib_path: str):
        self.lib_path = Path(lib_path)
        self.dart_files = []
        self.issues = []
        self.file_count = 0
        
    def find_dart_files(self) -> List[Path]:
        """查找所有Dart文件"""
        self.dart_files = list(self.lib_path.rglob("*.dart"))
        return self.dart_files
    
    def check_browser_theme_usage(self) -> List[Dict]:
        """检查main.dart中BrowserTheme.getTheme()调用"""
        issues = []
        main_file = self.lib_path / "main.dart"
        
        if not main_file.exists():
            issues.append({
                'type': 'missing_file',
                'file': str(main_file),
                'message': 'main.dart文件不存在'
            })
            return issues
            
        with open(main_file, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # 检查BrowserTheme.getTheme调用
        if 'BrowserTheme.getTheme' not in content:
            issues.append({
                'type': 'missing_method_call',
                'file': str(main_file),
                'message': 'main.dart中未找到BrowserTheme.getTheme()调用'
            })
        else:
            # 检查调用参数
            lines = content.split('\n')
            for i, line in enumerate(lines, 1):
                if 'BrowserTheme.getTheme' in line:
                    # 检查是否包含必要的参数
                    if 'isDark' not in line or 'primaryColor' not in line:
                        issues.append({
                            'type': 'incomplete_method_call',
                            'file': str(main_file),
                            'line': i,
                            'message': f'BrowserTheme.getTheme调用可能缺少参数: {line.strip()}'
                        })
                    else:
                        issues.append({
                            'type': 'ok',
                            'file': str(main_file),
                            'line': i,
                            'message': 'BrowserTheme.getTheme调用正确'
                        })
        
        return issues
    
    def check_imports(self) -> List[Dict]:
        """检查所有.dart文件的import语句"""
        issues = []
        flutter_widget_classes = {
            'Widget', 'StatelessWidget', 'StatefulWidget', 'ConsumerWidget',
            'ConsumerStatefulWidget', 'ConsumerState', 'State'
        }
        
        for dart_file in self.dart_files:
            with open(dart_file, 'r', encoding='utf-8') as f:
                content = f.read()
                
            lines = content.split('\n')
            has_flutter_import = False
            has_widget_class = False
            
            for i, line in enumerate(lines, 1):
                line = line.strip()
                
                # 检查import语句
                if line.startswith('import ') and 'flutter/material.dart' in line:
                    has_flutter_import = True
                    
                # 检查Widget类定义
                if re.search(r'^class\s+\w+.*Widget', line):
                    has_widget_class = True
                    
            # 检查使用Widget但没有import的情况
            if has_widget_class and not has_flutter_import:
                issues.append({
                    'type': 'missing_flutter_import',
                    'file': str(dart_file),
                    'message': '文件定义了Widget类但缺少flutter/material.dart导入'
                })
        
        return issues
    
    def check_part_statements(self) -> List[Dict]:
        """检查part语句指向的文件是否存在"""
        issues = []
        
        for dart_file in self.dart_files:
            with open(dart_file, 'r', encoding='utf-8') as f:
                content = f.read()
                
            lines = content.split('\n')
            file_dir = dart_file.parent
            
            for i, line in enumerate(lines, 1):
                line = line.strip()
                
                # 检查part语句
                if line.startswith('part '):
                    # 提取文件名
                    match = re.match(r"part\s+'([^']+)'", line)
                    if match:
                        part_file_name = match.group(1)
                        part_file_path = file_dir / part_file_name
                        
                        if not part_file_path.exists():
                            issues.append({
                                'type': 'missing_part_file',
                                'file': str(dart_file),
                                'line': i,
                                'part_file': part_file_name,
                                'message': f'Part文件不存在: {part_file_name}'
                            })
                            
                # 检查part of语句
                elif line.startswith('part of '):
                    # 提取被指向的文件名
                    match = re.match(r"part of\s+'([^']+)'", line)
                    if match:
                        target_file = match.group(1)
                        # 检查目标文件是否存在
                        if not file_dir.joinpath(target_file).exists():
                            issues.append({
                                'type': 'invalid_part_of',
                                'file': str(dart_file),
                                'line': i,
                                'target_file': target_file,
                                'message': f'Part of指向的文件不存在: {target_file}'
                            })
        
        return issues
    
    def check_syntax_errors(self) -> List[Dict]:
        """检查语法错误"""
        issues = []
        
        for dart_file in self.dart_files:
            with open(dart_file, 'r', encoding='utf-8') as f:
                content = f.read()
                
            lines = content.split('\n')
            
            for i, line in enumerate(lines, 1):
                line_stripped = line.strip()
                
                # 检查{;语法错误
                if re.search(r'\{;', line):
                    issues.append({
                        'type': 'syntax_error',
                        'file': str(dart_file),
                        'line': i,
                        'message': f'语法错误: {{; 应为 {{ : {line_stripped}'
                    })
                
                # 检查缺少分号的简单情况
                if (re.search(r'\b(if|for|while|switch)\s*\([^)]*\)\s*$', line_stripped) and
                    not line_stripped.endswith((';', '{', '}'))):
                    # 排除一些特殊情况
                    if not line_stripped.endswith(')') or 'function(' in line_stripped:
                        issues.append({
                            'type': 'potential_missing_semicolon',
                            'file': str(dart_file),
                            'line': i,
                            'message': f'可能缺少分号: {line_stripped}'
                        })
        
        return issues
    
    def check_duplicate_part_files(self) -> List[Dict]:
        """检查重复的part文件定义"""
        issues = []
        part_definitions = {}
        
        for dart_file in self.dart_files:
            with open(dart_file, 'r', encoding='utf-8') as f:
                content = f.read()
                
            lines = content.split('\n')
            
            for i, line in enumerate(lines, 1):
                line = line.strip()
                if line.startswith('part '):
                    match = re.match(r"part\s+'([^']+)'", line)
                    if match:
                        part_file = match.group(1)
                        if part_file not in part_definitions:
                            part_definitions[part_file] = []
                        part_definitions[part_file].append({
                            'file': str(dart_file),
                            'line': i
                        })
        
        # 检查重复定义
        for part_file, definitions in part_definitions.items():
            if len(definitions) > 1:
                issues.append({
                    'type': 'duplicate_part_definition',
                    'part_file': part_file,
                    'definitions': definitions,
                    'message': f'Part文件 {part_file} 被多个文件定义'
                })
        
        return issues
    
    def run_analysis(self) -> Dict:
        """运行完整分析"""
        print("开始分析Flutter代码库...")
        
        # 查找所有Dart文件
        self.dart_files = self.find_dart_files()
        self.file_count = len(self.dart_files)
        print(f"找到 {self.file_count} 个Dart文件")
        
        all_issues = []
        
        # 检查各项问题
        print("检查BrowserTheme调用...")
        all_issues.extend(self.check_browser_theme_usage())
        
        print("检查import语句...")
        all_issues.extend(self.check_imports())
        
        print("检查part语句...")
        all_issues.extend(self.check_part_statements())
        
        print("检查语法错误...")
        all_issues.extend(self.check_syntax_errors())
        
        print("检查重复part文件...")
        all_issues.extend(self.check_duplicate_part_files())
        
        # 统计问题
        issue_types = {}
        for issue in all_issues:
            issue_type = issue.get('type', 'unknown')
            issue_types[issue_type] = issue_types.get(issue_type, 0) + 1
        
        return {
            'total_files': self.file_count,
            'total_issues': len(all_issues),
            'issue_types': issue_types,
            'issues': all_issues
        }
    
    def generate_report(self, results: Dict) -> str:
        """生成分析报告"""
        report = []
        report.append("# FlClash Browser Flutter代码分析报告")
        report.append("")
        report.append(f"## 概览")
        report.append(f"- **文件总数**: {results['total_files']} 个Dart文件")
        report.append(f"- **问题总数**: {results['total_issues']} 个问题")
        report.append("")
        
        # 问题类型统计
        report.append("## 问题类型统计")
        for issue_type, count in results['issue_types'].items():
            type_name = {
                'missing_file': '缺失文件',
                'missing_method_call': '缺失方法调用',
                'incomplete_method_call': '不完整方法调用',
                'ok': '正常',
                'missing_flutter_import': '缺失Flutter导入',
                'missing_part_file': '缺失Part文件',
                'invalid_part_of': '无效Part Of',
                'syntax_error': '语法错误',
                'potential_missing_semicolon': '可能缺少分号',
                'duplicate_part_definition': '重复Part定义'
            }.get(issue_type, issue_type)
            report.append(f"- **{type_name}**: {count} 个")
        report.append("")
        
        # 详细问题列表
        report.append("## 详细问题列表")
        for i, issue in enumerate(results['issues'], 1):
            type_name = {
                'missing_file': '缺失文件',
                'missing_method_call': '缺失方法调用',
                'incomplete_method_call': '不完整方法调用',
                'ok': '正常',
                'missing_flutter_import': '缺失Flutter导入',
                'missing_part_file': '缺失Part文件',
                'invalid_part_of': '无效Part Of',
                'syntax_error': '语法错误',
                'potential_missing_semicolon': '可能缺少分号',
                'duplicate_part_definition': '重复Part定义'
            }.get(issue['type'], issue['type'])
            
            report.append(f"### {i}. {type_name}")
            if 'file' in issue:
                report.append(f"- **文件**: `{issue['file']}`")
            if 'line' in issue:
                report.append(f"- **行号**: {issue['line']}")
            report.append(f"- **描述**: {issue['message']}")
            if 'part_file' in issue:
                report.append(f"- **Part文件**: {issue['part_file']}")
            if 'target_file' in issue:
                report.append(f"- **目标文件**: {issue['target_file']}")
            if 'definitions' in issue:
                report.append(f"- **定义位置**: {issue['definitions']}")
            report.append("")
        
        return '\n'.join(report)

if __name__ == "__main__":
    analyzer = FlutterCodeAnalyzer("/workspace/flclash_browser_app/lib")
    results = analyzer.run_analysis()
    report = analyzer.generate_report(results)
    
    # 保存报告
    with open("/workspace/flutter_codebase_analysis_report.md", "w", encoding="utf-8") as f:
        f.write(report)
    
    print("分析完成！")
    print(f"总共分析了 {results['total_files']} 个文件")
    print(f"发现了 {results['total_issues']} 个问题")
    print("报告已保存到: flutter_codebase_analysis_report.md")