#!/bin/bash

# 🚀 GitHub Pages 快速配置脚本
# 使用方法：./quick-github-setup.sh

echo "🍅 番茄时钟 - GitHub Pages 快速配置"
echo "===================================="
echo ""

# 获取 GitHub 用户名
read -p "请输入你的 GitHub 用户名: " GITHUB_USER

if [ -z "$GITHUB_USER" ]; then
    echo "❌ GitHub 用户名不能为空！"
    exit 1
fi

REPO_NAME="pomodoro-web"
REMOTE_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo ""
echo "📋 配置信息："
echo "  GitHub 用户名：${GITHUB_USER}"
echo "  仓库名称：${REPO_NAME}"
echo "  远程地址：${REMOTE_URL}"
echo ""

# 确认
read -p "确认以上信息是否正确？(y/n): " CONFIRM
if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "❌ 已取消配置"
    exit 1
fi

echo ""
echo "⚙️  正在配置..."

# 添加远程仓库
git remote add origin "$REMOTE_URL" 2>/dev/null || {
    echo "⚠️  远程仓库已存在，正在更新地址..."
    git remote set-url origin "$REMOTE_URL"
}

echo "✅ 已添加远程仓库"

# 更新 update-check.js 中的地址
sed -i "s|https://your-domain.com/api/version.json|https://${GITHUB_USER}.github.io/${REPO_NAME}/version.json|g" www/update-check.js
sed -i "s|https://your-domain.com/releases/app-release.apk|https://github.com/${GITHUB_USER}/${REPO_NAME}/releases/download/v1.1.0/app-release.apk|g" www/update-check.js

echo "✅ 已更新 update-check.js"

# 创建 version.json
cat > www/version.json << EOF
{
  "version": "1.1.0",
  "minVersion": "1.0.0",
  "releaseDate": "$(date +%Y-%m-%d)",
  "changelog": "🎉 更新内容：\n- PWA 支持，可离线使用\n- 界面优化，文字更清晰\n- 主题显示效果改进\n\n🐛 问题修复：\n- 修复浅色主题下卡片不可见\n- 修复深色主题下菜单按钮不可见",
  "downloadUrl": "https://github.com/${GITHUB_USER}/${REPO_NAME}/releases/download/v1.1.0/app-release.apk",
  "forceUpdate": false
}
EOF

echo "✅ 已创建 version.json"

# 提交更改
git add .
git commit -m "chore: 配置 GitHub Pages 在线更新 - ${GITHUB_USER}"

echo "✅ 已提交配置"

echo ""
echo "======================================"
echo "✅ 配置完成！"
echo "======================================"
echo ""
echo "📋 接下来的步骤："
echo ""
echo "1️⃣  创建 GitHub 仓库："
echo "   访问：https://github.com/new"
echo "   仓库名：${REPO_NAME}"
echo "   描述：🍅 番茄时钟 - 支持在线更新的 PWA 应用"
echo "   可见性：Public 或 Private"
echo "   ⚠️  不要勾选 Add README/.gitignore/license"
echo ""
echo "2️⃣  推送到 GitHub："
echo "   git push -u origin main"
echo ""
echo "3️⃣  启用 GitHub Pages："
echo "   进入仓库 → Settings → Pages"
echo "   Source: Deploy from a branch"
echo "   Branch: main"
echo "   Folder: / (root)"
echo "   点击 Save"
echo ""
echo "4️⃣  等待 1-2 分钟后访问："
echo "   https://${GITHUB_USER}.github.io/${REPO_NAME}/"
echo ""
echo "5️⃣  上传 APK 到 Releases："
echo "   仓库 → Releases → Create a new release"
echo "   Tag: v1.1.0"
echo "   上传：android/app/build/outputs/apk/release/app-release.apk"
echo ""
echo "📖 详细说明请查看：GITHUB-PAGES-SETUP.md"
echo ""
echo "祝部署顺利！🎉"
echo ""
