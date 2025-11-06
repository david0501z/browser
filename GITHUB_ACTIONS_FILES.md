# GitHub Actions 文件清单

## 创建的文件

### 1. 主要工作流文件

#### `.github/workflows/extract-and-commit.yml`
**功能**: 解压文件压缩包并自动提交
- **触发方式**: 手动触发、Issue评论
- **参数**: 压缩包路径、解压路径、提交信息
- **用途**: 批量更新项目文件

#### `.github/workflows/build-apk.yml`
**功能**: 构建Flutter APK文件
- **触发方式**: 推送代码、Pull Request、手动触发
- **构建类型**: Debug、Release
- **特性**: 
  - 自动设置Flutter环境
  - 支持多版本Flutter和Java
  - 自动上传构建产物
  - 支持Android签名配置
  - 集成测试和分析

#### `.github/workflows/setup-signing.yml`
**功能**: 配置Android签名环境
- **触发方式**: 手动触发
- **用途**: 生成签名配置文件和设置指南

### 2. 配置文件

#### `android/local.properties.example`
- **用途**: 本地环境配置模板
- **内容**: Flutter SDK路径、版本信息、签名配置示例

### 3. 文档文件

#### `GITHUB_ACTIONS.md`
- **用途**: 详细的使用指南
- **内容**: 工作流说明、使用步骤、故障排除、最佳实践

#### `SIGNING_SETUP.md`
- **用途**: Android签名配置指南
- **内容**: 密钥库生成、GitHub Secrets配置、故障排除

## 工作流程

### 1. 文件管理流程
```
用户上传文件 → 触发extract-and-commit → 解压文件 → 自动提交 → 完成
```

### 2. APK构建流程
```
代码变更 → 触发build-apk → 设置环境 → 获取依赖 → 构建APK → 上传产物
```

### 3. 签名配置流程
```
手动触发setup-signing → 生成配置文件 → 显示设置指南 → 用户配置Secrets → 完成
```

## 使用场景

### 场景1: 批量更新项目文件
1. 将文件打包为zip格式
2. 上传到仓库的uploads目录
3. 手动触发extract-and-commit工作流
4. 填写压缩包路径和提交信息
5. 自动解压并提交更改

### 场景2: 日常开发构建
1. 推送代码到主分支
2. 自动触发build-apk工作流
3. 构建Debug APK用于测试
4. 下载构建产物进行测试

### 场景3: 发布版本构建
1. 合并代码到主分支
2. 手动触发build-apk工作流
3. 选择Release构建类型
4. 配置Android签名（首次需要）
5. 构建Release APK
6. 自动上传到GitHub Releases

### 场景4: 配置签名环境
1. 手动触发setup-signing工作流
2. 按照生成的指南配置GitHub Secrets
3. 测试Release构建

## 安全注意事项

### 1. 签名密钥安全
- 密钥库文件绝对不能提交到仓库
- 所有签名信息必须通过GitHub Secrets配置
- 定期备份密钥库到安全位置

### 2. 权限控制
- GitHub Actions使用最小权限原则
- 只有必要的secrets会被传递给工作流
- 构建日志不包含敏感信息

### 3. 文件安全
- extract-and-commit工作流会验证文件存在性
- 自动清理临时文件
- 只允许特定格式的压缩包

## 故障排除

### 常见问题
1. **构建失败**: 检查Flutter版本和依赖兼容性
2. **签名失败**: 验证GitHub Secrets配置正确性
3. **解压失败**: 确认压缩包路径和格式正确
4. **权限错误**: 检查仓库Actions权限设置

### 调试方法
1. 查看GitHub Actions运行日志
2. 检查构建产物下载链接
3. 验证Flutter doctor输出
4. 对比本地构建环境配置

## 扩展建议

### 1. 多平台构建
可以扩展工作流支持iOS、web、桌面端构建

### 2. 自动化测试
添加单元测试、集成测试、UI测试到构建流程

### 3. 持续部署
集成Google Play、App Store自动发布

### 4. 代码质量
添加代码覆盖率、静态分析、安全扫描

### 5. 通知系统
集成Slack、邮件、钉钉等通知方式

## 维护建议

### 1. 定期更新
- 每月检查Flutter和依赖版本更新
- 更新GitHub Actions版本
- 审查和更新安全配置

### 2. 监控构建
- 定期检查构建成功率
- 监控构建时间变化
- 分析失败原因和频率

### 3. 文档维护
- 及时更新使用文档
- 记录常见问题和解决方案
- 保持文档与实际配置同步