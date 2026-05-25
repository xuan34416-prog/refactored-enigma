#!/bin/bash

# 🚀 番茄时钟 - 在线更新配置脚本
# 使用方法：./setup-online-update.sh

echo "🍅 番茄时钟 - 在线更新配置"
echo "=========================="
echo ""

# 获取用户输入
read -p "请输入你的域名（如：https://example.com）: " DOMAIN
read -p "请输入当前版本号（如：1.1.0）: " VERSION

if [ -z "$DOMAIN" ] || [ -z "$VERSION" ]; then
    echo "❌ 输入不能为空！"
    exit 1
fi

echo ""
echo "⚙️  正在配置..."

# 更新 update-check.js
sed -i "s|https://your-domain.com/api/version.json|${DOMAIN}/api/version.json|g" www/update-check.js
sed -i "s|https://your-domain.com/releases/app-release.apk|${DOMAIN}/releases/app-release.apk|g" www/update-check.js
sed -i "s|currentVersion: '[0-9.]*'|currentVersion: '${VERSION}'|g" www/update-check.js

echo "✅ 已更新 update-check.js"

# 创建 version.json 示例
cat > www/version.json << EOF
{
  "version": "${VERSION}",
  "minVersion": "1.0.0",
  "releaseDate": "$(date +%Y-%m-%d)",
  "changelog": "🎉 更新内容：\n- 新功能\n- 优化体验\n\n🐛 问题修复：\n- 修复已知问题",
  "downloadUrl": "${DOMAIN}/releases/app-release.apk",
  "forceUpdate": false
}
EOF

echo "✅ 已创建 version.json"

# 提示
echo ""
echo "✅ 配置完成！"
echo ""
echo "📋 下一步操作："
echo "1. 在服务器上创建以下目录结构："
echo "   ${DOMAIN}/"
echo "   ├── api/"
echo "   │   └── version.json"
echo "   └── releases/"
echo "       └── app-release.apk"
echo ""
echo "2. 将 www/version.json 上传到服务器的 api/ 目录"
echo ""
echo "3. 构建 APK 并上传到 releases/ 目录"
echo "   cd android && ./gradlew assembleRelease"
echo ""
echo "4. 测试更新功能"
echo ""
echo "📖 详细说明请查看：DEPLOYMENT.md"
echo ""
