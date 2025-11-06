# GitHub Actions 使用指南

本项目包含两个GitHub Actions工作流，用于自动化文件管理和APK构建流程。

## 工作流概览

### 1. 解压文件并提交 (`extract-and-commit.yml`)

**功能**: 自动解压用户上传的文件压缩包并提交到仓库

**触发方式**:
- 手动触发（推荐）
- Issue评论触发

**使用步骤**:

#### 手动触发方式:
1. 在GitHub仓库页面，点击 "Actions" 标签
2. 选择 "解压文件并提交" 工作流
3. 点击 "Run workflow" 按钮
4. 填写参数:
   - **文件压缩包路径**: 相对于项目根目录的路径（默认: `uploads/archive.zip`）
   - **解压目标路径**: 解压到的目录（默认: `.` 表示项目根目录）
   - **提交信息**: Git提交信息（默认: `chore: 更新文件`）
5. 点击 "Run workflow" 执行

#### Issue评论触发方式:
在任意Issue中评论以下格式：
```
/extract uploads/my-files.zip extract/path "自定义提交信息"
```

### 2. 构建APK (`build-apk.yml`)

**功能**: 自动构建Flutter APK文件

**触发方式**:
- 推送到 `main` 或 `master` 分支
- 提交包含关键文件变更的Pull Request
- 手动触发

**构建类型**:
- **Debug**: 调试版本，包含调试信息
- **Release**: 发布版本，优化编译

**使用步骤**:

#### 自动触发:
当推送代码到主分支或创建Pull Request时自动执行

#### 手动触发:
1. 在GitHub仓库页面，点击 "Actions" 标签
2. 选择 "构建APK" 工作流
3. 点击 "Run workflow" 按钮
4. 选择参数:
   - **构建类型**: debug 或 release
   - **Flutter渠道**: stable, beta, 或 dev
   - **Java版本**: 11, 17, 或 21
5. 点击 "Run workflow" 执行

## 构建产物

### APK文件
- **Debug APK**: 适用于开发和测试
- **Release APK**: 适用于生产环境

构建完成后，APK文件会上传到GitHub Actions的构建产物中，可以直接下载。

### 构建信息
每次构建都会生成包含以下信息的 `build_info.txt`:
- 构建时间
- 构建分支
- 提交哈希
- Flutter版本
- 构建类型
- GitHub Run ID

## 项目配置要求

### 1. 必需的目录结构
```
flclash_browser_app/
├── .github/workflows/          # GitHub Actions
├── lib/                        # Flutter源码
├── android/                    # Android配置
├── pubspec.yaml               # Flutter依赖
└── uploads/                   # 文件上传目录（可选）
```

### 2. 权限要求
GitHub Actions需要以下权限:
- **Contents**: 读写仓库内容
- **Pull requests**: 创建和更新Pull Request
- **Actions**: 读写GitHub Actions
- **Releases**: 创建发布版本（仅Release构建需要）

### 3. 依赖验证
项目已配置依赖验证脚本 `verify_dependencies.sh`，确保所有依赖有效。

## 常见问题解决

### 1. 构建失败 - 依赖问题
如果遇到依赖相关错误:
1. 检查 `pubspec.yaml` 中的依赖版本
2. 运行验证脚本: `bash verify_dependencies.sh`
3. 参考 `DEPENDENCY_FIX.md` 文档

### 2. 构建失败 - Android配置
如果遇到Android相关错误:
1. 确保AndroidManifest.xml包含Flutter v2 embedding配置
2. 检查Android SDK版本兼容性
3. 参考 `BUILD_FIX.md` 文档

### 3. 文件解压失败
如果解压工作流失败:
1. 确保压缩包路径正确
2. 检查压缩包格式（支持.zip格式）
3. 验证文件权限

## 高级用法

### 自定义构建参数
可以通过修改 `build-apk.yml` 来自定义:
- 构建优化选项
- 签名配置（Release构建）
- ProGuard/R8配置

### 条件构建
可以修改触发条件，只在特定文件变更时触发构建:
```yaml
push:
  branches: [ main ]
  paths:
    - 'lib/**'
    - 'android/**'
    - 'pubspec.yaml'
```

### 多环境构建
可以扩展工作流支持多个构建环境:
- 开发环境 (Debug)
- 测试环境 (Profile)
- 生产环境 (Release)

## 最佳实践

1. **代码提交**: 使用有意义的提交信息
2. **分支策略**: 在功能分支上测试，合并到主分支后构建Release
3. **版本管理**: 为Release版本创建Git标签
4. **构建缓存**: 启用Flutter缓存以加速构建
5. **错误处理**: 定期检查构建日志，及时修复问题

## 技术支持

如遇到问题，请检查:
1. GitHub Actions运行日志
2. Flutter doctor输出
3. Android SDK配置
4. 项目依赖兼容性

更多详细信息请参考项目文档:
- `README.md` - 项目概述
- `BUILD_FIX.md` - 构建问题修复
- `DEPENDENCY_FIX.md` - 依赖问题修复