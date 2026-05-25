# 🚀 在线更新部署指南

本指南介绍如何实现应用的在线推送更新，让用户无需连接数据线即可更新应用。

---

## 📋 目录

1. [方案概述](#方案概述)
2. [PWA 自动更新](#pwa-自动更新)
3. [APK 在线下载更新](#apk-在线下载更新)
4. [服务器配置](#服务器配置)
5. [发布流程](#发布流程)

---

## 方案概述

我们提供两种更新方式：

| 方式 | 适用场景 | 优点 | 缺点 |
|------|---------|------|------|
| **PWA 自动更新** | Web 资源更新（HTML/CSS/JS） | 用户无感知，自动更新 | 不能更新原生功能 |
| **APK 在线下载** | 重大功能更新（需要改 Android 代码） | 可更新所有功能 | 需要用户手动确认 |

**推荐策略**：
- 小改动 → PWA 自动更新
- 大更新 → APK 在线下载

---

## PWA 自动更新

### 工作原理

Service Worker 会自动：
1. 检测文件变化
2. 后台下载新资源
3. 下次启动时应用新版本

### 配置说明

Service Worker 文件：[`www/sw.js`](file:///home/foghashing/下载/pomodoro_web_archive/www/sw.js)

```javascript
const CACHE_NAME = 'pomodoro-v1';  // 每次更新时修改版本号
```

### 更新步骤

1. 修改 Web 资源（HTML/CSS/JS）
2. 更新 `sw.js` 中的 `CACHE_NAME`（如：`pomodoro-v2`）
3. 重新构建并部署到服务器
4. 用户打开应用时自动更新

---

## APK 在线下载更新

### 工作原理

1. 应用启动时检查版本信息
2. 发现新版本时显示更新对话框
3. 用户确认后下载 APK
4. 用户手动安装（Android 安全限制）

### 文件说明

- **更新检测脚本**: [`www/update-check.js`](file:///home/foghashing/下载/pomodoro_web_archive/www/update-check.js)
- **版本信息示例**: [`www/version-example.json`](file:///home/foghashing/下载/pomodoro_web_archive/www/version-example.json)

### 配置步骤

#### 1️⃣ 修改版本检测地址

编辑 [`www/update-check.js`](file:///home/foghashing/下载/pomodoro_web_archive/www/update-check.js)：

```javascript
const UpdateChecker = {
  currentVersion: '1.1.0',  // 当前版本号（每次发布时更新）
  
  // 版本信息接口地址（替换为你的服务器地址）
  versionApiUrl: 'https://your-domain.com/api/version.json',
  
  // APK 下载地址（替换为你的服务器地址）
  apkDownloadUrl: 'https://your-domain.com/releases/app-release.apk',
  
  // ... 其他配置
};
```

#### 2️⃣ 创建版本信息文件

在服务器上创建 `version.json` 文件：

```json
{
  "version": "1.2.0",
  "minVersion": "1.0.0",
  "releaseDate": "2026-05-25",
  "changelog": "新增功能：\n- 功能 1\n- 功能 2\n\n修复问题：\n- 问题 1\n- 问题 2",
  "downloadUrl": "https://your-domain.com/releases/app-release.apk",
  "forceUpdate": false
}
```

**字段说明**：
- `version`: 最新版本号
- `minVersion`: 最低支持版本（低于此版本强制更新）
- `changelog`: 更新日志（支持换行）
- `downloadUrl`: APK 下载地址
- `forceUpdate`: 是否强制更新（true/false）

#### 3️⃣ 部署 APK 文件

将生成的 APK 上传到服务器：

```
your-domain.com/
├── api/
│   └── version.json
└── releases/
    └── app-release.apk
```

---

## 服务器配置

### 最低要求

任何能托管静态文件的服务器都可以：

- ✅ GitHub Pages（免费）
- ✅ Vercel（免费）
- ✅ Netlify（免费）
- ✅ 自己的服务器（Nginx/Apache）
- ✅ 对象存储（阿里云 OSS、腾讯云 COS 等）

### 使用 GitHub Pages（推荐）

#### 步骤：

1. **创建 GitHub 仓库**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/your-username/pomodoro-web.git
   git push -u origin main
   ```

2. **启用 GitHub Pages**
   - 进入仓库 Settings → Pages
   - Source 选择 `main` 分支
   - 保存后获得访问地址：`https://your-username.github.io/pomodoro-web/`

3. **配置更新检测**
   
   编辑 `update-check.js`：
   ```javascript
   versionApiUrl: 'https://your-username.github.io/pomodoro-web/version.json',
   apkDownloadUrl: 'https://github.com/your-username/pomodoro-web/releases/download/v1.2.0/app-release.apk'
   ```

4. **创建 version.json**
   ```bash
   # 在仓库根目录创建 version.json
   echo '{
     "version": "1.1.0",
     "changelog": "更新内容...",
     "downloadUrl": "https://github.com/your-username/pomodoro-web/releases/download/v1.1.0/app-release.apk"
   }' > version.json
   ```

5. **发布 APK**
   - 在 GitHub 仓库的 Releases 中上传 APK
   - 下载地址格式：`https://github.com/用户名/仓库/releases/download/版本号/文件名.apk`

### 使用 Vercel

```bash
# 安装 Vercel CLI
npm i -g vercel

# 部署
cd /home/foghashing/下载/pomodoro_web_archive
vercel --prod
```

### 服务器 CORS 配置

如果使用不同的域名托管 API 和 APK，需要配置 CORS：

**Nginx 配置**：
```nginx
location /api/ {
    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Methods' 'GET, OPTIONS' always;
}

location /releases/ {
    add_header 'Access-Control-Allow-Origin' '*' always;
}
```

---

## 发布流程

### 每次发布新版本时的步骤：

#### 1️⃣ 更新版本号

**package.json**:
```json
{
  "version": "1.2.0"  // 更新版本号
}
```

**android/app/build.gradle**:
```gradle
versionCode 3      // 递增（每次 +1）
versionName "1.2.0"  // 与 package.json 一致
```

**update-check.js**:
```javascript
currentVersion: '1.2.0'  // 更新当前版本号
```

#### 2️⃣ 构建 APK

```bash
cd /home/foghashing/下载/pomodoro_web_archive

# 同步 Capacitor
npx cap sync android

# 使用 Android Studio 构建
# 或命令行构建
cd android
./gradlew assembleRelease
```

生成的 APK 位置：
```
android/app/build/outputs/apk/release/app-release.apk
```

#### 3️⃣ 更新版本信息文件

创建/更新 `version.json`：

```json
{
  "version": "1.2.0",
  "releaseDate": "2026-05-25",
  "changelog": "🎉 新增功能：\n- 新功能 1\n- 新功能 2\n\n🐛 问题修复：\n- 修复问题 1\n- 修复问题 2",
  "downloadUrl": "https://your-domain.com/releases/app-release.apk",
  "forceUpdate": false
}
```

#### 4️⃣ 部署到服务器

```bash
# 如果使用 Git 部署
git add .
git commit -m "release: v1.2.0 - 新功能说明"
git push

# 如果使用 Vercel
vercel --prod
```

#### 5️⃣ 上传 APK 到服务器

**GitHub Releases**:
```bash
# 使用 gh 命令行工具
gh release create v1.2.0 android/app/build/outputs/apk/release/app-release.apk --title "v1.2.0" --notes "更新说明"
```

**或直接上传**：
- 进入 GitHub 仓库 → Releases → Create a new release
- 上传 `app-release.apk`

#### 6️⃣ 测试更新

1. 在手机上打开应用
2. 等待 3 秒（更新检测延迟）
3. 应该看到更新对话框
4. 点击下载并测试安装

---

## 🔧 常见问题

### Q1: 用户反馈看不到更新提示？

**检查清单**：
- [ ] `update-check.js` 是否正确引入到 `index.html`
- [ ] `versionApiUrl` 地址是否正确
- [ ] 服务器上的 `version.json` 是否可访问
- [ ] 版本号是否确实高于当前版本

### Q2: APK 下载后无法安装？

**可能原因**：
- Android 需要"允许安装未知来源应用"权限
- APK 签名不一致（无法覆盖安装）
- APK 文件损坏

**解决方案**：
- 提示用户在设置中允许安装未知来源
- 确保使用相同的签名密钥
- 重新下载 APK

### Q3: 如何强制用户更新？

在 `version.json` 中设置：
```json
{
  "forceUpdate": true,
  "minVersion": "1.1.0"  // 低于此版本的用户必须更新
}
```

然后在 `update-check.js` 中添加强制更新逻辑。

---

## 📞 技术支持

如有问题，请查看：
- [Capacitor 文档](https://capacitorjs.com/docs)
- [Service Worker 文档](https://developer.mozilla.org/zh-CN/docs/Web/API/Service_Worker_API)
- [GitHub Pages 文档](https://docs.github.com/zh/pages)

---

## ✅ 检查清单

发布前请确认：

- [ ] 更新了 `package.json` 版本号
- [ ] 更新了 `build.gradle` 版本号和 versionCode
- [ ] 更新了 `update-check.js` 中的 `currentVersion`
- [ ] 更新了 `update-check.js` 中的 API 和 APK 地址
- [ ] 创建了 `version.json` 并上传到服务器
- [ ] 构建并测试了 APK
- [ ] 上传 APK 到服务器/Release
- [ ] 测试了在线更新流程
- [ ] 更新了 `CHANGELOG.md`

祝发布顺利！🎉
