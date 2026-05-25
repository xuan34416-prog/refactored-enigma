# 🚀 部署到 GitHub Pages - 详细步骤

## ✅ 已完成的步骤

- ✅ Git 仓库已初始化
- ✅ 所有文件已提交
- ✅ 分支已重命名为 `main`
- ✅ 创建了 `.gitignore` 文件

---

## 📋 接下来的步骤

### 步骤 1：创建 GitHub 仓库

1. **访问 GitHub**：https://github.com/new

2. **填写仓库信息**：
   - **Repository name**: `pomodoro-web`（或者你喜欢的名字）
   - **Description**: `🍅 番茄时钟 - 支持在线更新的 PWA 应用`
   - **Visibility**: 选择 `Public`（公开）或 `Private`（私有）都可以
   - **不要勾选** "Add a README file"
   - **不要勾选** "Add .gitignore"
   - **不要勾选** "Choose a license"

3. **点击 "Create repository"**

---

### 步骤 2：关联本地仓库

在终端中执行以下命令（**替换为你的 GitHub 用户名**）：

```bash
# 添加远程仓库（替换 YOUR_USERNAME 为你的 GitHub 用户名）
git remote add origin https://github.com/YOUR_USERNAME/pomodoro-web.git

# 推送到 GitHub
git push -u origin main
```

**示例**（如果你的用户名是 `zhangsan`）：
```bash
git remote add origin https://github.com/zhangsan/pomodoro-web.git
git push -u origin main
```

---

### 步骤 3：启用 GitHub Pages

1. **进入仓库页面**：https://github.com/YOUR_USERNAME/pomodoro-web

2. **点击 "Settings"**（设置标签页）

3. **左侧菜单找到 "Pages"**

4. **配置 Pages 设置**：
   - **Source**: 选择 `Deploy from a branch`
   - **Branch**: 选择 `main` 分支
   - **Folder**: 选择 `/ (root)`
   - 点击 **"Save"**

5. **等待部署**（大约 1-2 分钟）

6. **获取访问地址**：
   - 页面顶部会显示你的网站地址
   - 格式：`https://YOUR_USERNAME.github.io/pomodoro-web/`

---

### 步骤 4：配置在线更新

#### 4.1 修改 update-check.js

编辑 `www/update-check.js` 文件，找到以下行：

```javascript
const UpdateChecker = {
  currentVersion: '1.1.0',
  
  // 替换为你的 GitHub Pages 地址
  versionApiUrl: 'https://your-domain.com/api/version.json',
  
  // 替换为你的 GitHub Releases 地址
  apkDownloadUrl: 'https://your-domain.com/releases/app-release.apk',
```

**修改为**（替换 YOUR_USERNAME）：

```javascript
const UpdateChecker = {
  currentVersion: '1.1.0',
  
  versionApiUrl: 'https://YOUR_USERNAME.github.io/pomodoro-web/version.json',
  
  apkDownloadUrl: 'https://github.com/YOUR_USERNAME/pomodoro-web/releases/download/v1.1.0/app-release.apk',
```

#### 4.2 创建 version.json

在项目根目录创建 `version.json` 文件：

```json
{
  "version": "1.1.0",
  "minVersion": "1.0.0",
  "releaseDate": "2026-05-25",
  "changelog": "🎉 更新内容：\n- PWA 支持，可离线使用\n- 界面优化，文字更清晰\n- 主题显示效果改进\n\n🐛 问题修复：\n- 修复浅色主题下卡片不可见\n- 修复深色主题下菜单按钮不可见",
  "downloadUrl": "https://github.com/YOUR_USERNAME/pomodoro-web/releases/download/v1.1.0/app-release.apk",
  "forceUpdate": false
}
```

#### 4.3 提交并推送

```bash
git add .
git commit -m "chore: 配置 GitHub Pages 在线更新"
git push
```

---

### 步骤 5：上传 APK 到 Releases

#### 5.1 构建 APK

```bash
cd android
./gradlew assembleRelease
```

APK 文件位置：`android/app/build/outputs/apk/release/app-release.apk`

#### 5.2 创建 Release

1. **进入仓库的 Releases 页面**：
   - https://github.com/YOUR_USERNAME/pomodoro-web/releases

2. **点击 "Create a new release"**

3. **填写发布信息**：
   - **Tag version**: `v1.1.0`
   - **Release title**: `v1.1.0 - 初始版本`
   - **Describe this release**: 填写更新内容

4. **上传 APK**：
   - 点击 "Upload binaries"
   - 选择 `android/app/build/outputs/apk/release/app-release.apk`
   - 等待上传完成

5. **点击 "Publish release"**

---

### 步骤 6：测试在线更新

#### 6.1 访问应用

在浏览器中打开：
```
https://YOUR_USERNAME.github.io/pomodoro-web/
```

#### 6.2 测试 PWA 功能

1. **添加到主屏幕**（手机浏览器）：
   - Chrome: 菜单 → "添加到主屏幕"
   - Safari: 分享 → "添加到主屏幕"

2. **离线测试**：
   - 关闭网络
   - 打开应用，应该可以正常使用

#### 6.3 测试在线更新

1. **修改 version.json**，将版本号改为 `1.2.0`

2. **提交并推送**：
   ```bash
   git add version.json
   git commit -m "chore: 更新版本到 1.2.0"
   git push
   ```

3. **等待 1-2 分钟**让 GitHub Pages 更新

4. **刷新应用**，应该看到更新提示对话框

---

## 🎯 后续发布新版本的流程

### 小更新（Web 资源）

```bash
# 1. 修改代码

# 2. 更新 Service Worker 版本号（www/sw.js）
# const CACHE_NAME = 'pomodoro-v2';  // 递增版本号

# 3. 提交并推送
git add .
git commit -m "feat: 更新说明"
git push
```

### 大更新（需要新 APK）

```bash
# 1. 更新版本号（3 个地方）
# - package.json: "version": "1.2.0"
# - android/app/build.gradle: versionCode 3, versionName "1.2.0"
# - www/update-check.js: currentVersion: '1.2.0'

# 2. 构建 APK
cd android
./gradlew assembleRelease

# 3. 创建新的 Release（上传新 APK）
# GitHub → Releases → Create a new release

# 4. 更新 version.json
# 修改 version 字段和 changelog

# 5. 提交并推送
git add .
git commit -m "release: v1.2.0"
git push
```

---

## ⚠️ 常见问题

### Q1: GitHub Pages 显示 404？

**解决方法**：
- 等待 2-5 分钟，GitHub 需要时间构建
- 检查 Settings → Pages 配置是否正确
- 确保 `main` 分支存在

### Q2: 推送失败？

**可能原因**：
- 仓库地址错误
- 没有 GitHub 账号

**解决方法**：
```bash
# 检查远程仓库地址
git remote -v

# 如果错误，删除并重新添加
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/pomodoro-web.git
```

### Q3: 如何更新 Git 配置的用户名和邮箱？

```bash
git config user.name "你的名字"
git config user.email "your-email@example.com"
```

---

## 📞 需要帮助？

- **GitHub Pages 文档**: https://docs.github.com/zh/pages
- **Capacitor 文档**: https://capacitorjs.com/docs
- **项目问题**: 在 GitHub 仓库提 Issue

---

## ✅ 检查清单

完成部署后，请确认：

- [ ] GitHub 仓库已创建
- [ ] 代码已推送到 GitHub
- [ ] GitHub Pages 已启用
- [ ] 可以访问 `https://YOUR_USERNAME.github.io/pomodoro-web/`
- [ ] `version.json` 已创建并配置正确
- [ ] APK 已上传到 Releases
- [ ] 在线更新功能正常工作

祝你部署顺利！🎉
