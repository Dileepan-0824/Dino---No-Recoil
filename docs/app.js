// PUBG-NO-RECOIL-SCRIPTS
// Vanilla Client JavaScript - Zero External Dependencies - Zero Emojis

document.addEventListener('DOMContentLoaded', function () {
  // Tab Switching Logic
  const tabBtns = document.querySelectorAll('.tab-btn');
  const tabPanes = document.querySelectorAll('.tab-pane');

  tabBtns.forEach(function (btn) {
    btn.addEventListener('click', function () {
      const targetTab = this.getAttribute('data-tab');

      tabBtns.forEach(function (b) {
        b.classList.remove('active');
      });
      tabPanes.forEach(function (pane) {
        pane.classList.remove('active');
      });

      this.classList.add('active');
      const activePane = document.getElementById(targetTab);
      if (activePane) {
        activePane.classList.add('active');
      }
    });
  });

  // Copy Lua Script to Clipboard
  const copyBtn = document.getElementById('copyScriptBtn');
  const copyBtnText = document.getElementById('copyBtnText');
  const toast = document.getElementById('toast');

  let cachedScriptText = null;

  function showToast(message) {
    if (!toast) return;
    toast.textContent = message;
    toast.classList.add('show');
    setTimeout(function () {
      toast.classList.remove('show');
    }, 3200);
  }

  if (copyBtn) {
    copyBtn.addEventListener('click', async function () {
      try {
        if (!cachedScriptText) {
          const response = await fetch('Dino.lua');
          if (!response.ok) {
            throw new Error('Script fetch error');
          }
          cachedScriptText = await response.text();
        }

        if (navigator.clipboard && navigator.clipboard.writeText) {
          await navigator.clipboard.writeText(cachedScriptText);
        } else {
          // Fallback for older browsers
          const textarea = document.createElement('textarea');
          textarea.value = cachedScriptText;
          textarea.style.position = 'fixed';
          textarea.style.opacity = '0';
          document.body.appendChild(textarea);
          textarea.select();
          document.execCommand('copy');
          document.body.removeChild(textarea);
        }

        const originalText = copyBtnText ? copyBtnText.textContent : 'COPY LUA SCRIPT';
        if (copyBtnText) copyBtnText.textContent = 'COPIED TO CLIPBOARD!';
        showToast('Complete Dino script copied to clipboard.');

        setTimeout(function () {
          if (copyBtnText) copyBtnText.textContent = originalText;
        }, 2500);
      } catch (err) {
        console.warn('Direct fetch failed, falling back to download action:', err);
        const downloadLink = document.createElement('a');
        downloadLink.href = 'Dino.lua';
        downloadLink.download = 'Dino.lua';
        downloadLink.click();
        showToast('Downloaded Dino.lua directly.');
      }
    });
  }
});
