// PUBG-NO-RECOIL-SCRIPTS
// Graphical Tactical Configurator & Interactive Sync
// Zero External Dependencies - Zero Emojis

document.addEventListener('DOMContentLoaded', function () {
  // Navigation Arsenal Tabs
  const tabBtns = document.querySelectorAll('.tab-btn');
  const tabPanes = document.querySelectorAll('.tab-pane');

  tabBtns.forEach(function (btn) {
    btn.addEventListener('click', function () {
      const targetTab = this.getAttribute('data-tab');

      tabBtns.forEach(function (b) { b.classList.remove('active'); });
      tabPanes.forEach(function (pane) { pane.classList.remove('active'); });

      this.classList.add('active');
      const activePane = document.getElementById(targetTab);
      if (activePane) activePane.classList.add('active');
    });
  });

  // Master Configurator View Switcher (Graphical vs Code)
  const viewGraphicalBtn = document.getElementById('viewGraphicalBtn');
  const viewCodeBtn = document.getElementById('viewCodeBtn');
  const graphicalPanel = document.getElementById('graphicalPanel');
  const codePanel = document.getElementById('codePanel');

  if (viewGraphicalBtn && viewCodeBtn && graphicalPanel && codePanel) {
    viewGraphicalBtn.addEventListener('click', function () {
      viewGraphicalBtn.classList.add('active');
      viewCodeBtn.classList.remove('active');
      graphicalPanel.classList.add('active');
      codePanel.classList.remove('active');
    });

    viewCodeBtn.addEventListener('click', function () {
      viewCodeBtn.classList.add('active');
      viewGraphicalBtn.classList.remove('active');
      codePanel.classList.add('active');
      graphicalPanel.classList.remove('active');
      renderLiveCode();
    });
  }

  // Interactive Configuration State
  const configState = {
    crouch: true,
    prone: false,
    breath: true,
    attachments: true,
    attMode: 'NUMLOCK',
    clickMode: 1,
    dmr: true,
    horizontal: 0.60,
    gamma: 0.32,
    toggleMode: 'ANY',
    capsLed: true,
    capsFire: false,
    logging: true
  };

  // Switch references
  const switches = [
    { id: 'cfg_crouch', key: 'crouch' },
    { id: 'cfg_prone', key: 'prone' },
    { id: 'cfg_breath', key: 'breath' },
    { id: 'cfg_attachments', key: 'attachments' },
    { id: 'cfg_dmr', key: 'dmr' },
    { id: 'cfg_caps_led', key: 'capsLed' },
    { id: 'cfg_caps_fire', key: 'capsFire' },
    { id: 'cfg_logging', key: 'logging' }
  ];

  switches.forEach(function (item) {
    const el = document.getElementById(item.id);
    if (!el) return;
    el.addEventListener('change', function () {
      configState[item.key] = this.checked;
      const statusSpan = this.parentElement.querySelector('.switch-status');
      if (statusSpan) {
        statusSpan.textContent = this.checked ? 'ON' : 'OFF';
      }
      renderLiveCode();
    });
  });

  // Segmented Controls
  const segContainers = document.querySelectorAll('.segmented-control');
  segContainers.forEach(function (container) {
    const controlName = container.getAttribute('data-for');
    const buttons = container.querySelectorAll('.seg-btn');

    buttons.forEach(function (btn) {
      btn.addEventListener('click', function () {
        buttons.forEach(function (b) { b.classList.remove('active'); });
        this.classList.add('active');
        const val = this.getAttribute('data-val');

        if (controlName === 'cfg_att_mode') configState.attMode = val;
        else if (controlName === 'cfg_click_mode') configState.clickMode = parseInt(val, 10);
        else if (controlName === 'cfg_gamma') configState.gamma = parseFloat(val);
        else if (controlName === 'cfg_toggle_mode') configState.toggleMode = val;

        renderLiveCode();
      });
    });
  });

  // Range Slider
  const slider = document.getElementById('cfg_horizontal');
  const sliderDisplay = document.getElementById('sliderValDisplay');
  if (slider && sliderDisplay) {
    slider.addEventListener('input', function () {
      const val = parseInt(this.value, 10);
      const floatVal = (val / 100).toFixed(2);
      configState.horizontal = parseFloat(floatVal);
      sliderDisplay.textContent = val + '%';
      renderLiveCode();
    });
  }

  // Live Lua Code Output
  const liveCodeOutput = document.getElementById('liveCodeOutput');

  function renderLiveCode() {
    if (!liveCodeOutput) return;

    const code = `-- DINO V11 - RECOIL COMPENSATION SYSTEM FOR PUBG PC (LOGITECH G HUB)
-- HARDWARE BASELINE: 800 DPI | SensSetting = 1.00 (In-Game Sens: 50) | Win Pointer: 6-11

local MOUSE_DPI = 800
local SensSetting = 1.00

-- Vertical-only trims . Tune in 0.01 steps for your ADS settings.
local SprayVerticalGain = 1.04  -- Full-auto and burst
local DMRVerticalGain   = 1.05  -- Per tap, independent of the refire cadence

-- UE4 Spline Recovery-Damping Exponent
local SplineResponseGamma = ${configState.gamma.toFixed(2)}

-- Feature Toggles
local EnableCrouchMode  = ${configState.crouch}
local EnableProneMode   = ${configState.prone}
local EnableHoldBreath  = ${configState.breath}
local EnableAttachments = ${configState.attachments}
local AttachmentsMode   = "${configState.attMode}"      -- "NUMLOCK" or "ALWAYS"

-- Operation Modes
local ClickMode          = ${configState.clickMode}             -- 1 = LMB only, 3 = RMB + LMB
local DMR_AUTO_TAP       = ${configState.dmr}          -- Rapid single-tap cycling on DMRs
local HorizontalStrength = ${configState.horizontal.toFixed(2)}          -- Master horizontal bias multiplier

-- State Management
local WEAPON_TOGGLE_MODE        = "${configState.toggleMode}"  -- "ANY" or "SAME"
local SYNC_CAPSLOCK_LED         = ${configState.capsLed}   -- Sync physical CapsLock LED
local REQUIRE_CAPSLOCK_FOR_FIRE = ${configState.capsFire}  -- Hardware safety lock
local ENABLE_LOGGING            = ${configState.logging}   -- Telemetry to G Hub console`;

    liveCodeOutput.textContent = code;
  }

  // Initial render
  renderLiveCode();

  // Reset Defaults Button
  const resetBtn = document.getElementById('resetDefaultsBtn');
  if (resetBtn) {
    resetBtn.addEventListener('click', function () {
      // Reset configState
      configState.crouch = true;
      configState.prone = false;
      configState.breath = true;
      configState.attachments = true;
      configState.attMode = 'NUMLOCK';
      configState.clickMode = 1;
      configState.dmr = true;
      configState.horizontal = 0.60;
      configState.gamma = 0.32;
      configState.toggleMode = 'ANY';
      configState.capsLed = true;
      configState.capsFire = false;
      configState.logging = true;

      // Reset switches in DOM
      switches.forEach(function (item) {
        const el = document.getElementById(item.id);
        if (!el) return;
        el.checked = configState[item.key];
        const statusSpan = el.parentElement.querySelector('.switch-status');
        if (statusSpan) statusSpan.textContent = el.checked ? 'ON' : 'OFF';
      });

      // Reset slider
      if (slider && sliderDisplay) {
        slider.value = 60;
        sliderDisplay.textContent = '60%';
      }

      // Reset segmented controls
      segContainers.forEach(function (container) {
        const controlName = container.getAttribute('data-for');
        const buttons = container.querySelectorAll('.seg-btn');
        let defaultVal = 'NUMLOCK';
        if (controlName === 'cfg_click_mode') defaultVal = '1';
        else if (controlName === 'cfg_gamma') defaultVal = '0.32';
        else if (controlName === 'cfg_toggle_mode') defaultVal = 'ANY';

        buttons.forEach(function (btn) {
          if (btn.getAttribute('data-val') === defaultVal) btn.classList.add('active');
          else btn.classList.remove('active');
        });
      });

      renderLiveCode();
      showToast('Settings reset to calibrated defaults.');
    });
  }

  // Toast System
  const toast = document.getElementById('toast');
  function showToast(message) {
    if (!toast) return;
    toast.textContent = message;
    toast.classList.add('show');
    setTimeout(function () {
      toast.classList.remove('show');
    }, 3200);
  }

  // Copy to Clipboard Utility
  async function copyText(text, successMessage) {
    try {
      if (navigator.clipboard && navigator.clipboard.writeText) {
        await navigator.clipboard.writeText(text);
      } else {
        const textarea = document.createElement('textarea');
        textarea.value = text;
        textarea.style.position = 'fixed';
        textarea.style.opacity = '0';
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand('copy');
        document.body.removeChild(textarea);
      }
      showToast(successMessage);
    } catch (err) {
      console.warn('Copy failed:', err);
      showToast('Clipboard copy failed. Please download the file.');
    }
  }

  // Hero Copy Button (Fetches Full Dino.lua)
  const copyScriptBtn = document.getElementById('copyScriptBtn');
  const copyBtnText = document.getElementById('copyBtnText');
  let cachedFullScript = null;

  if (copyScriptBtn) {
    copyScriptBtn.addEventListener('click', async function () {
      try {
        if (!cachedFullScript) {
          const res = await fetch('Dino.lua');
          if (!res.ok) throw new Error('Fetch failed');
          cachedFullScript = await res.text();
        }
        await copyText(cachedFullScript, 'Complete Dino script copied to clipboard.');
        if (copyBtnText) {
          const original = copyBtnText.textContent;
          copyBtnText.textContent = 'COPIED TO CLIPBOARD!';
          setTimeout(function () { copyBtnText.textContent = original; }, 2500);
        }
      } catch (err) {
        console.warn('Direct fetch failed, downloading:', err);
        const a = document.createElement('a');
        a.href = 'Dino.lua';
        a.download = 'Dino.lua';
        a.click();
        showToast('Downloaded Dino.lua directly.');
      }
    });
  }

  // Copy Custom Config Buttons
  const copyCustomScriptBtn = document.getElementById('copyCustomScriptBtn');
  const copyCustomBtnText = document.getElementById('copyCustomBtnText');
  if (copyCustomScriptBtn) {
    copyCustomScriptBtn.addEventListener('click', function () {
      if (liveCodeOutput) {
        copyText(liveCodeOutput.textContent, 'Customized config block copied to clipboard.');
        if (copyCustomBtnText) {
          const original = copyCustomBtnText.textContent;
          copyCustomBtnText.textContent = 'COPIED!';
          setTimeout(function () { copyCustomBtnText.textContent = original; }, 2500);
        }
      }
    });
  }

  const copySourceCodeBtn = document.getElementById('copySourceCodeBtn');
  if (copySourceCodeBtn) {
    copySourceCodeBtn.addEventListener('click', function () {
      if (liveCodeOutput) {
        copyText(liveCodeOutput.textContent, 'Configuration code copied to clipboard.');
      }
    });
  }
});
