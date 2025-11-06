# GitHub Actions 权限问题解决指南

## 🚨 权限错误诊断

你遇到的错误：
```
remote: Permission to david0501z/browser.git denied to github-actions[bot].
fatal: unable to access 'https://github.com/david0501z/browser/': The requested URL returned error: 403
```

## 🔧 解决方案（按优先级排序）

### 方案1: 修复仓库权限设置（推荐）

#### 步骤1: 检查Actions权限
1. 进入你的GitHub仓库: `https://github.com/david0501z/browser`
2. 点击 `Settings` → `Actions` → `General`
3. 找到 `Workflow permissions` 部分
4. **选择**: `Read and write permissions`
5. **勾选**: `Allow GitHub Actions to create and approve pull requests`

#### 步骤2: 检查分支保护规则
1. 进入 `Settings` → `Branches`
2. 点击你的主分支（如 `main`）的编辑按钮
3. 确保 **勾选**: `Allow GitHub Actions to create and approve pull requests`

### 方案2: 使用安全版本工作流

我已经为你创建了安全版本的工作流：

#### 使用 `extract-and-commit-safe.yml`
这个版本不会直接推送代码，而是创建Pull Request：

1. **优势**:
   - 避免权限问题
   - 提供代码审查机会
   - 更安全的代码管理
   - 便于回滚

2. **使用方法**:
   - 手动触发 "解压文件并提交（安全模式）" 工作流
   - 填写参数后运行
   - 系统会自动创建PR
   - 你可以审查PR内容后手动合并

### 方案3: 配置Personal Access Token（高级）

如果方案1无效，可以配置Personal Access Token：

#### 创建Personal Access Token
1. 进入GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. 点击 "Generate new token (classic)"
3. 勾选权限:
   - `repo` (完整仓库权限)
   - `workflow` (更新GitHub Action工作流文件)
4. 生成并复制token

#### 配置Repository Secret
1. 进入你的仓库 → Settings → Secrets and variables → Actions
2. 点击 "New repository secret"
3. Name: `PERSONAL_ACCESS_TOKEN`
4. Value: 粘贴你生成的token

#### 修改工作流（可选）
如果使用Personal Access Token，修改推送命令：
```bash
git push https://x-access-token:${{ secrets.PERSONAL_ACCESS_TOKEN }}@github.com/${{ github.repository }}.git $BRANCH
```

## 📋 推荐的设置流程

### 立即可行的解决方案

1. **首先尝试方案1**:
   - 检查并修改仓库Actions权限设置
   - 确保选择 "Read and write permissions"

2. **如果仍然失败，使用方案2**:
   - 使用安全版本工作流 `extract-and-commit-safe.yml`
   - 通过Pull Request管理代码更改

3. **最后考虑方案3**:
   - 配置Personal Access Token
   - 使用更高级的权限控制

## 🔍 权限检查清单

### ✅ 仓库设置检查
- [ ] Actions → General → Workflow permissions: "Read and write permissions"
- [ ] Actions → General → 勾选 "Allow GitHub Actions to create and approve pull requests"
- [ ] Settings → Actions → Runners: 确认有可用的运行器

### ✅ 分支保护检查
- [ ] Settings → Branches → 主分支保护规则
- [ ] 勾选 "Allow GitHub Actions to create and approve pull requests"
- [ ] 不需要管理员权限才能推送（如果使用Actions）

### ✅ 工作流配置检查
- [ ] 工作流文件有正确的权限声明
- [ ] 使用正确的认证方式
- [ ] 没有语法错误

## 🚀 立即测试

### 测试步骤
1. 进入你的GitHub仓库
2. 点击 "Actions" 标签
3. 选择 "解压文件并提交（安全模式）" 工作流
4. 点击 "Run workflow"
5. 填写测试参数:
   - 文件压缩包路径: `uploads/test.zip`
   - 解压目标路径: `.`
   - 提交信息: `test: 测试权限`
6. 运行并观察结果

### 预期结果
- ✅ 工作流成功运行
- ✅ 创建Pull Request（如果有更改）
- ✅ 没有权限错误

## 🔄 工作流选择指南

### 使用 `extract-and-commit.yml`（直接推送）
**适用场景**:
- 个人仓库，权限完全开放
- 自动化程度要求高
- 信任工作流的更改

### 使用 `extract-and-commit-safe.yml`（PR模式）
**适用场景**:
- 团队协作项目
- 需要代码审查
- 权限控制严格
- **推荐**: 大多数情况下使用此版本

## 🆘 故障排除

### 如果仍然遇到权限问题

1. **检查仓库是否是Fork**:
   - Fork的仓库可能权限受限
   - 考虑在原始仓库操作

2. **检查组织设置**:
   - 如果仓库在组织下，检查组织级别的Actions设置
   - 联系组织管理员

3. **使用替代方案**:
   - 手动解压文件
   - 本地提交和推送
   - 使用GitHub CLI

### 获取帮助
如果问题持续存在，请提供：
1. 完整的错误日志
2. 仓库设置截图
3. 工作流运行截图

## 📞 下一步

1. **立即尝试**: 方案1（修改仓库权限）
2. **备用方案**: 使用安全版本工作流
3. **验证**: 运行一次测试工作流
4. **文档**: 查看 `GITHUB_ACTIONS.md` 获取更多使用指南

记住：**安全版本工作流是最推荐的解决方案**，它避免了权限问题同时提供了更好的代码管理流程。