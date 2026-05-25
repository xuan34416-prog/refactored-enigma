# 📱 在线更新功能 - 快速开始

## 🎯 目标

让你能够在添加新功能后，**在线推送更新**到用户的手机，无需使用数据线连接电脑。

---

## ⚡ 5 分钟快速配置

### 方案选择

我们提供两种更新方式：

#### 1️⃣ PWA 自动更新（小改动）
- ✅ 自动检测并更新
- ✅ 用户无感知
- ⚠️ 只能更新 Web 资源（HTML/CSS/JS）

**配置方法**：
```bash
# 每次更新后修改 Service Worker 版本号
# 文件：www/sw.js
const CACHE_NAME = 'pomodoro-v2';  // 递增版本号
```

#### 2️⃣ APK 在线下载（大更新）
- ✅ 可更新所有功能
- ✅ 用户点击确认即可下载
- ⚠️ 需要服务器托管 APK

**配置方法**：继续往下看 👇

---

## 🚀 快速配置在线更新

### 步骤 1：准备服务器

你可以使用以下任一服务（都免费）：

- **GitHub Pages**（推荐）：https://pages.github.com/
- **Vercel**：https://vercel.com/
- **Netlify**：https://www.netlify.com/

### 步骤 2：运行配置脚本

```bash
cd /home/foghashing/下载/pomodoro_web_archive

# 运行配置脚本（替换为你的域名）
./setup-online-update.sh
```

脚本会问你两个问题：
1. 你的域名（如：`https://example.com`）
2. 当前版本号（如：`1.1.0`）

### 步骤 3：部署到服务器

#### 使用 GitHub Pages（最简单）

```bash
# 初始化 Git（如果还没有）
git init
git add .
git commit -m "配置在线更新"

# 推送到 GitHub
git remote add origin https://github.com/你的用户名/仓库名.git
git push -u origin main
```

然后在 GitHub 仓库设置中启用 Pages：
- Settings → Pages
- Source 选择 `main` 分支
- 保存

### 步骤 4：创建版本信息文件

在服务器根目录创建 `version.json`：

```json
{
  "version": "1.1.0",
  "releaseDate": "2026-05-25",
  "changelog": "更新内容说明",
  "downloadUrl": "https://你的域名/releases/app-release.apk",
  "forceUpdate": false
}
```

### 步骤 5：上传 APK

将 APK 上传到服务器的 `releases/` 目录：

```
你的域名/
├── version.json
└── releases/
    └── app-release.apk
```

---

## 📋 发布新版本的完整流程

### 每次添加新功能后：

```bash
# 1. 更新版本号（3 个地方）
#    - package.json: "version": "1.2.0"
#    - android/app/build.gradle: versionCode 3, versionName "1.2.0"
#    - www/update-check.js: currentVersion: '1.2.0'

# 2. 构建 APK
cd android
./gradlew assembleRelease

# 3. 上传 APK 到服务器
#    放到：releases/app-release.apk

# 4. 更新 version.json
#    修改 version 字段和 changelog

# 5. 推送到服务器
git add .
git commit -m "发布 v1.2.0"
git push
```

完成！用户打开应用时会自动检测并提示更新。

---

## 🎨 用户看到的更新界面

当有新版本时，用户会看到：

```
┌─────────────────────────┐
│  🎉 发现新版本    v1.2.0 │
├─────────────────────────┤
│ 更新内容：               │
│ - 新功能 1               │
│ - 新功能 2               │
│ - 优化体验               │
│                         │
│      [稍后更新] [立即更新]│
└─────────────────────────┘
```

用户点击"立即更新"后会自动下载 APK，然后手动安装（Android 安全要求）。

---

## ⚠️ 重要注意事项

### 1. 数据保留
- ✅ **覆盖安装**：数据会保留
- ❌ **卸载重装**：数据会丢失

### 2. 签名一致性
- 必须使用相同的签名密钥
- 否则无法覆盖安装

### 3. Android 权限
- 用户需要允许"安装未知来源应用"
- 第一次安装时会提示

---

## 🔧 测试更新

### 本地测试

```bash
# 启动本地服务器
cd www
python3 -m http.server 8080

# 在手机浏览器访问
http://你的电脑IP:8080
```

### 真机测试

1. 安装当前版本到手机
2. 修改 version.json 的版本号（改大）
3. 刷新页面
4. 应该看到更新对话框

---

## 📖 详细文档

- **完整部署指南**：[DEPLOYMENT.md](DEPLOYMENT.md)
- **更新日志**：[CHANGELOG.md](CHANGELOG.md)
- **配置脚本**：[setup-online-update.sh](setup-online-update.sh)

---

## ❓ 常见问题

### Q: 更新检测多久执行一次？
A: 每次启动应用时都会检测，延迟 3 秒执行，不影响启动速度。

### Q: 可以强制用户更新吗？
A: 可以，在 version.json 中设置 `"forceUpdate": true`。

### Q: 用户不想更新怎么办？
A: 可以点击"稍后更新"，下次启动时还会提示。

### Q: 支持后台自动下载吗？
A: 由于 Android 安全限制，需要用户手动确认下载和安装。

---

## 🎉 完成！

现在你已经配置好在线更新功能了！

下次添加新功能后，只需：
1. 更新版本号
2. 构建新 APK
3. 上传到服务器
4. 更新 version.json

用户就会自动收到更新提示，无需再用数据线连接电脑！🚀
