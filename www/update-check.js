// 版本更新检测模块
const UpdateChecker = {
  // 当前版本号
  currentVersion: '1.1.0',
  
  // 版本信息接口地址（GitHub Pages 地址）
  versionApiUrl: 'https://xuan34416-prog.github.io/Xiaoye-Pomodoro-Timer/version.json',
  
  // APK 下载地址（GitHub Releases 地址）
  apkDownloadUrl: 'https://github.com/xuan34416-prog/Xiaoye-Pomodoro-Timer/releases/download/v1.1.0/app-release.apk',
  
  // 检查更新
  async checkUpdate() {
    try {
      const response = await fetch(this.versionApiUrl, {
        cache: 'no-cache'
      });
      const data = await response.json();
      
      const latestVersion = data.version;
      const needsUpdate = this.compareVersions(latestVersion, this.currentVersion) > 0;
      
      if (needsUpdate) {
        this.showUpdateDialog(data);
      }
      
      return { needsUpdate, latestVersion, data };
    } catch (error) {
      console.warn('检查更新失败:', error);
      return { needsUpdate: false };
    }
  },
  
  // 版本号比较（返回 1: 新版大，0: 相同，-1: 旧版大）
  compareVersions(v1, v2) {
    const parts1 = v1.split('.').map(Number);
    const parts2 = v2.split('.').map(Number);
    
    for (let i = 0; i < Math.max(parts1.length, parts2.length); i++) {
      const num1 = parts1[i] || 0;
      const num2 = parts2[i] || 0;
      
      if (num1 > num2) return 1;
      if (num1 < num2) return -1;
    }
    
    return 0;
  },
  
  // 显示更新提示
  showUpdateDialog(versionInfo) {
    const dialog = document.createElement('div');
    dialog.className = 'update-dialog';
    dialog.innerHTML = `
      <div class="update-overlay" onclick="UpdateChecker.hideDialog()"></div>
      <div class="update-content">
        <div class="update-header">
          <h3>🎉 发现新版本</h3>
          <span class="update-version">v${versionInfo.version}</span>
        </div>
        <div class="update-body">
          ${versionInfo.changelog ? `<div class="update-changelog">${versionInfo.changelog}</div>` : ''}
        </div>
        <div class="update-actions">
          <button class="update-cancel" onclick="UpdateChecker.hideDialog()">稍后更新</button>
          <button class="update-confirm" onclick="UpdateChecker.downloadUpdate()">立即更新</button>
        </div>
      </div>
    `;
    
    document.body.appendChild(dialog);
    setTimeout(() => dialog.classList.add('show'), 10);
  },
  
  // 隐藏对话框
  hideDialog() {
    const dialog = document.querySelector('.update-dialog');
    if (dialog) {
      dialog.classList.remove('show');
      setTimeout(() => dialog.remove(), 300);
    }
  },
  
  // 下载更新
  async downloadUpdate() {
    try {
      // 创建下载链接
      const link = document.createElement('a');
      link.href = this.apkDownloadUrl;
      link.download = 'pomodoro-update.apk';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      
      this.hideDialog();
      
      // 显示下载提示
      this.showToast('开始下载，下载完成后请点击安装');
    } catch (error) {
      console.error('下载失败:', error);
      this.showToast('下载失败，请稍后重试');
    }
  },
  
  // 显示提示
  showToast(message) {
    const toast = document.createElement('div');
    toast.className = 'update-toast';
    toast.textContent = message;
    document.body.appendChild(toast);
    
    setTimeout(() => toast.classList.add('show'), 10);
    setTimeout(() => {
      toast.classList.remove('show');
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }
};

// 应用启动时检查更新（延迟 3 秒，避免影响启动速度）
setTimeout(() => {
  UpdateChecker.checkUpdate();
}, 3000);
