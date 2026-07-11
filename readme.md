# Dino — No Recoil Script for Logitech Mice

<div align="center">

![Logitech G Hub](img/logitech_logo.png)

**A precision-tuned Lua macro for Logitech G Hub that eliminates weapon recoil in PUBG.**  
Optimized for the **Logitech G102** at **800 DPI** — compatible with all G-Series mice.

[![Latest Release](https://img.shields.io/badge/Latest-V6-brightgreen?style=for-the-badge)](#version-history)
[![PUBG PC](https://img.shields.io/badge/PUBG-PC-blue?style=for-the-badge)](#)
[![PUBG Mobile](https://img.shields.io/badge/PUBG-Mobile-orange?style=for-the-badge)](#pubg-mobile-script)

</div>

---

## Table of Contents

- [What's New in V6](#whats-new-in-v6)
- [Features](#features)
- [Before & After](#before--after)
- [Requirements](#requirements)
- [Recommended Game Settings](#recommended-game-settings)
- [Installation & Setup](#installation--setup)
- [Customization Guide](#customization-guide)
- [Supported Weapons](#supported-weapons)
- [Modifier Keybind System](#modifier-keybind-system)
- [PUBG Mobile Script](#pubg-mobile-script)
- [Version History](#version-history)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## What's New in V6

> **V6 is the biggest update yet** — a complete recoil-control overhaul.

| Feature | Description |
|---------|-------------|
| **DMR No-Recoil Mode** | Brand-new single-tap recoil compensation for DMR/semi-auto weapons. Configurable pull strength, smoothing steps, and tap timing. |
| **Weapon Tuning Panel** | Per-weapon `stand` and `crouch` recoil multipliers for all 23 weapons. Fine-tune any gun's pull directly in the script header. |
| **Keybind Reorganization** | Reshuffled bindings — Vector, P90, JS9, MP9 moved to more ergonomic slots. Bizon & DP-28 freed up (set to `nil` by default). |
| **PUBG Mobile Script** | New standalone `Dino-PUBGM.lua` with AR + DMR dual-mode, lean-spam automation, and simplified controls. |

---

## Features

- **Full Weapon Coverage** — 11 Assault Rifles, 9 SMGs, 3 LMGs + DMR mode with per-weapon recoil patterns
- **Weapon Tuning Panel** — Per-weapon stand/crouch recoil multipliers — tweak any gun without touching the engine
- **DMR No-Recoil** — Single-tap recoil compensation with configurable pull, smoothing, and tap delay
- **Modifier Keybind System** — Bind every weapon using Mouse 4/5/6 + modifier keys (LCTRL, LALT, RCTRL, RALT, NumLock, RSHIFT)
- **Smart Recoil Engine** — Multi-phase pull with smooth decay, burst memory, and spray transfer detection
- **Anti-Drift Correction** — Automatically corrects horizontal crosshair drift during sustained fire
- **Elapsed-Time Compensation** — Scales pull proportionally when ticks run late due to CPU load
- **First-Bullet Compensation** — Reduces initial pull to match PUBG's delayed first-shot recoil
- **Attachment-Aware** — Toggle ScrollLock for with/without attachment profiles
- **Stance-Aware** — Hold LCTRL (crouch) or LSHIFT (scoped) for stance-specific compensation
- **Fully Customizable** — Adjustable sensitivity, click mode, weapon tuning, and key bindings
- **Undetectable** — Uses native Logitech G Hub Lua scripting, no third-party injection

---

## Before & After

<div align="center">

###     Without Script
<img src="img/before.png" width="70%">

###     With Script
<img src="img/after.png" width="70%">

</div>


## Requirements

| Component | Specification |
|-----------|--------------|
| Mouse | Logitech G-Series (optimized for **G102**) |
| DPI | **800** |
| Software | [Logitech G Hub](https://www.logitechg.com/en-us/innovation/g-hub.html) |
| Game | PUBG (PC) or PUBG Mobile (emulator) |
| OS | Windows |

---

## Recommended Game Settings

Configure the following in PUBG for optimal script performance:

- **Mouse DPI:** `800`
- **Vertical Sensitivity Multiplier:** `1.00` — set `SensSetting = 1.00` in script

![Game Settings](img/Game-Settings.png)

---

## Installation & Setup

### Step 1 — Install Logitech G Hub

Download and install [Logitech G Hub](https://www.logitechg.com/en-us/innovation/g-hub.html). Open the app and confirm your mouse is detected.

### Step 2 — Load the Script

1. Download the latest script: **`Dino-V6.lua`**
2. Open Logitech G Hub → select your **PUBG profile**
3. Navigate to **Scripting** (bottom-left panel)
4. Click **Create New Lua Script** → paste the script → **Save**

### Step 3 — In-Game Controls

| Control | Function |
|---------|----------|
| CapsLock ON | Macro **enabled** |
| CapsLock OFF | Macro **disabled** |
| ScrollLock ON | With attachments mode |
| ScrollLock OFF | Without attachments mode |
| Hold LCTRL (keyboard) | Crouch compensation |
| Hold LSHIFT (keyboard) | Scoped / hold-breath compensation |

### Step 4 — Activate & Test

1. Launch PUBG
2. Press a **modifier + mouse button** combo to select your weapon (CapsLock turns ON)
3. Fire — recoil compensation is now active

---

## Customization Guide

### Sensitivity

Adjust the global recoil strength in the script header:

```lua
local SensSetting = 1.15  -- Scale to match your in-game vertical sensitivity
```

**Reference table:**

| Vertical Sensitivity Multiplier | SensSetting |
|--------------------------------|-------------|
| 0.50 | `2.00` |
| 0.75 | `1.33` |
| 1.00 | `1.00` |
| 1.50 | `0.675` |
| 2.00 | `0.50` |

### Click Mode

```lua
local click = 1   -- Left mouse button only (default)
local click = 3   -- Right + left mouse button required
```

### Weapon Tuning Panel (New in V6)

Fine-tune recoil pull strength per weapon directly in the script header. Each weapon has separate `stand` and `crouch` multipliers:

```lua
local WeaponTuner = {
    AKM    = { stand = 2.57, crouch = 2.05 },  -- Heavy 7.62
    M416   = { stand = 1.50, crouch = 1.20 },  -- Baseline anchor
    BERRYL = { stand = 2.71, crouch = 2.17 },  -- Heaviest recoil AR
    -- ... all 23 weapons configurable
}
```

> **Tip:** Increase the value to pull down harder, decrease to soften the pull. The M416 (`1.50`) serves as the baseline — adjust others relative to it.

### DMR Settings (New in V6)

Configure single-tap recoil compensation for DMR/semi-auto weapons:

```lua
local dmr_pull = 25          -- Total pixels pulled down per tap
local dmr_steps = 4          -- Smoothing subdivisions (higher = smoother)
local dmr_sleep = 10         -- Delay between smoothing steps (ms)
local dmr_tap_mode = 1       -- Tap behavior mode
local dmr_tap_delay = 2      -- Delay between taps
local dmr_click_duration = 5 -- Click hold duration
```

---

## Supported Weapons

| Category | Weapons |
|----------|---------|
| **Assault Rifles** (11) | AKM · Beryl · G36C · M416 · SCAR-L · QBZ · AUG · GROZA · ACE32 · K2 · FAMAS |
| **SMGs** (9) | Bizon · Tommy Gun · UMP45 · UZI · Vector · MP5K · P90 · MP9 · JS9 |
| **LMGs** (3) | DP-28 · M249 · MG3 |
| **DMR** (new) | Generic DMR mode — works with any semi-auto weapon |

---

## Modifier Keybind System

All weapons are mapped using **3 mouse buttons** (4, 5, 6) combined with **7 modifier states**. No G-series keyboard required.

### Modifier Table

| Modifier | Offset | Example |
|----------|--------|---------|
| None | +0 | Mouse 4 → `4` |
| LCTRL | +100 | LCTRL + Mouse 5 → `105` |
| LALT | +200 | LALT + Mouse 4 → `204` |
| RCTRL | +300 | RCTRL + Mouse 4 → `304` |
| RALT | +400 | RALT + Mouse 4 → `404` |
| NumLock | +500 | NumLock + Mouse 4 → `504` |
| RSHIFT | +600 | RSHIFT + Mouse 4 → `604` |

### Weapon Bindings (V6)

| Weapon | Bind | Weapon | Bind |
|--------|------|--------|------|
| M416 | `4` | Beryl | `5` |
| MP5K | `6` | AUG | `104` |
| AKM | `105` | Vector | `106` |
| SCAR-L | `204` | GROZA | `205` |
| UMP45 | `206` | G36C | `304` |
| K2 | `305` | JS9 | `306` |
| QBZ | `404` | ACE32 | `405` |
| UZI | `406` | M249 | `504` |
| MG3 | `505` | P90 | `506` |
| FAMAS | `604` | DMR | `605` |
| MP9 | `606` | | |

> **Note:** Bizon, Tommy Gun, and DP-28 are set to `nil` by default in V6. Assign them to any free slot if needed.

---

## PUBG Mobile Script

A separate, standalone script for **PUBG Mobile** (emulator) is included: **`Dino-PUBGM.lua`**

### Features

- **Dual-Mode** — AR continuous spray + DMR single-tap, switchable via Mouse 4 / Mouse 5
- **Lean-Spam Automation** — Toggle with ScrollLock for automatic Q/E lean peeking while firing
- **Simplified Controls** — No modifier combos needed, just two mouse buttons

### Controls

| Control | Function |
|---------|----------|
| Mouse 4 | Toggle **AR mode** (CapsLock ON) |
| Mouse 5 | Toggle **DMR mode** (NumLock ON) |
| ScrollLock ON | Lean-spam enabled |
| ScrollLock OFF | Lean-spam disabled |

### Configuration

```lua
local n_r = 9       -- AR pull-down pixels (default: 9)
local nr_s = 20     -- AR pull interval ms (default: 20)
local dmr_pull = 25 -- DMR pull-down pixels per tap
local dmr_steps = 4 -- DMR smoothing steps
```

---

## Version History

| Version | File | Highlights |
|---------|------|------------|
| Base | `Dino.lua` | Original script with standard keybinds and basic engine |
| V1 | `Dino-V1.lua` | Modifier keybind system, engine tuning (0.75 horizontal, 0.50 pull) |
| V2 | `Dino-V2.lua` | Smooth decay, gradual end-of-mag extension, first-bullet compensation |
| V3 | `Dino-V3.lua` | Burst memory (400ms re-fire resume), adaptive late-spray floor |
| V4 | `Dino-V4.lua` | Spray transfer detection (soft reset on target switch mid-spray) |
| V5 | `Dino-V5.lua` | Anti-drift correction, elapsed-time compensation |
| **V6** | **`Dino-V6.lua`** | **DMR mode, Weapon Tuning Panel, keybind reorganization, MP9 support** |
| Mobile | `Dino-PUBGM.lua` | Standalone PUBG Mobile script with AR/DMR dual-mode + lean-spam |

> See [changelog.md](changelog.md) for full technical documentation of each improvement.

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Script not activating | Ensure G Hub is running and Lua scripting is enabled. Assign script to PUBG profile. Run G Hub as administrator. |
| Recoil feels too strong/weak | Adjust `SensSetting` value or tweak individual weapon values in the `WeaponTuner` table. Verify your mouse is at 800 DPI. |
| Modifier keys not registering | Hold the modifier key **before** pressing the mouse button. Check NumLock state for NumLock binds. |
| G Hub not detecting script | Restart G Hub. Delete and re-import the script. Reinstall G Hub if issues persist. |
| DMR pull too strong/weak | Adjust `dmr_pull` (total pixels) and `dmr_steps` (smoothing) in the DMR settings section. |
| Weapon not bound | Check the Weapon Bindings table. Some weapons are `nil` by default in V6 — assign them a free modifier+button slot. |

---

## License

Open-source and free to use. Provided as-is without warranties. Use responsibly.

---

<div align="center">
  <strong>Enjoy precision aim in PUBG.</strong><br>
  <sub>Dino V6 — July 2026</sub>
</div>
