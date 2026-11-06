# Dino Release Changelog

All notable changes, architectural enhancements, ballistic calibrations, and bug fixes for the **Dino No-Recoil Engine** are documented in this file.

The format is structured in reverse-chronological order (newest release first) following standard software release guidelines.

[![Latest Release](https://img.shields.io/badge/Latest-v8.0-00C853?style=for-the-badge)](#v80--pubg-pc-laser-spray-overhaul-compound-modifiers--dedicated-dmrs)
[![Platform](https://img.shields.io/badge/Platform-Logitech%20G%20Hub%20Lua-00A8FF?style=for-the-badge)](#)
[![PUBG Version](https://img.shields.io/badge/PUBG%20PC-v42+-FF6F00?style=for-the-badge)](#)
[![License](https://img.shields.io/badge/License-MIT-607D8B?style=for-the-badge)](#)

---

## Quick Navigation

* [v8.0 — Laser Spray Overhaul, Compound Modifiers & Dedicated DMRs](#v80--pubg-pc-laser-spray-overhaul-compound-modifiers--dedicated-dmrs)
* [v7.0 — RPD 7.62mm LMG & 65% Keyboard Layout Optimization](#v70--rpd-762mm-lmg-65-keyboard-layout-optimization--arsenal-refresh)
* [v6.0 — DMR Mode, Weapon Tuning Panel & Keybind Overhaul](#v60--dmr-mode-weapon-tuning-panel--keybind-overhaul)
* [v5.0 — Horizontal Control & Timing Precision](#v50--horizontal-control--timing-precision)
* [v4.0 — Spray Transfer Detection](#v40--spray-transfer-detection)
* [v3.0 — Burst Fire & Multi-Click Memory](#v30--burst-fire--adaptive-pull)
* [v2.0 — Ballistic Progressive Decay](#v20--recoil-engine-rewrite)
* [v1.0 — Modifier Keybind System & Engine Tuning](#v10--modifier-keybind-system--engine-tuning)
* [Comprehensive Version Feature Matrix](#comprehensive-feature-matrix)

---

## [v8.0] — PUBG PC Laser Spray Overhaul, Compound Modifiers & Dedicated DMRs
> **Release File:** [`Dino-V8.lua`](Dino-V8.lua)  
> **Base Architecture:** Complete architectural overhaul combining compound modifiers, PUBGIntel per-shot DMR ballistics, burst-fire engines, transparent horizontal micro-bias, and user-calibrated 800 DPI profile.

### Added
* **Data-Mined PUBGIntel Game-File Micro-Biases**: Assigned per-weapon horizontal micro-biases based directly on PUBG's internal directional drift metrics:
  * **Left-Drifting Weapons ($\leftarrow 0.05$ to $0.20$)**: M416 (`+0.035`), Beryl M762 (`+0.060`), AKM (`+0.075`), ACE32 (`+0.050`), Groza (`+0.040`), AUG (`+0.025`), K2 (`+0.025`), MP5K (`+0.020`), M249 (`+0.035`), RPD (`+0.045`). Received gentle **Rightward** micro-counters.
  * **Right-Drifting Weapons ($\rightarrow 0.02$ to $0.10$)**: SCAR-L (`-0.035`), G36C (`-0.035`), QBZ (`-0.015`), Vector (`-0.020`), Micro UZI (`-0.020`), MG3 (`-0.020`). Received gentle **Leftward** micro-counters.
  * **Centered / Laser Weapons**: UMP45, Tommy Gun, P90, MP9, FAMAS, Mutant, M16A4, and all DMRs maintain `0.000` to prevent any artificial lateral kick.
* **Opening Headshot Lock (First 8 Ticks = 0.0)**: Ticks 1 to 8 (~130ms, opening 4–5 bullets) enforce strictly `0.0` horizontal compensation, ensuring initial snap-aim, crosshair placement, and opening headshots remain laser-centered without any lateral pull.
* **Smooth Progressive Linear Ramp-In**: Ticks 9 to 20 fade the micro-bias in linearly (`(i - 8) / 12 * bias_strength`) rather than stepping abruptly, completely eliminating muzzle hitch.
* **Master Horizontal Strength Slider**: Added `HorizontalStrength = 0.60` in the user configuration panel for quick global tuning (adjustable from `0.00` pure vertical to `1.00` full counter).
* **Full Dino V7 Muscle-Memory Keybind Parity**: Restored 100% exact keybind assignments for all 21 weapons from Dino V7 (including ACE32 on `RALT + Mouse 5`, GROZA on `LALT + Mouse 5`, K2 on `RCTRL + Mouse 5`, M249 on `ScrollLock + Mouse 4`, FAMAS on `RSHIFT + Mouse 4`, MG3 on `ScrollLock + Mouse 5`, and DMR on `RSHIFT + Mouse 5`).
* **Compound Modifier System (+700 to +1200) for New Arsenal**: Mapped all remaining new weapons (Mini 14, Mk12, QBU, M16A4, SKS, SLR, Dragunov, Mk14, Mutant, RPD, Tommy Gun, VSS) onto collision-free compound tiers. Resolved AltGr / RALT hardware collision by re-binding Tier 7 (+700) to `LCTRL + LALT + LSHIFT`, completely isolating it from Right Alt.
* **In-Game Sprint Isolation (Left Shift Safeguard)**: Excised `LSHIFT` from single weapon modifier selection in `GetModifierOffset()`. Tier 6 (+600) is strictly bound to `RSHIFT`, ensuring holding Left Shift to sprint or hold breath in-game will never collide with mouse clicks or cause accidental weapon switches.
* **Dedicated PUBGIntel DMR Ballistics Engine**: Replaced generic single-tap compensation with individual per-weapon DMR profiles based directly on pubgintel.com data:
  * **Mini 14**: 16px pull, 3 steps, 6ms sleep, 170ms cadence.
  * **Mk12**: 15px pull, 3 steps, 6ms sleep, 170ms cadence (bipod-damped).
  * **QBU**: 16px pull, 3 steps, 6ms sleep, 170ms cadence.
  * **SKS**: 24px pull, 4 steps, 8ms sleep, 180ms cadence.
  * **SLR**: 28px pull, 4 steps, 8ms sleep, 180ms cadence.
  * **Dragunov (SVD)**: 34px pull, 4 steps, 10ms sleep, 250ms cadence (heavy 7.62 punch).
  * **Mk14 EBR**: 26px pull, 4 steps, 7ms sleep, 160ms cadence.
  * **VSS Vintorez**: 12px pull, 3 steps, 5ms sleep, 120ms cadence.
  * Supports rapid auto-tapping on hold via native hardware mouse pulsing (zero secondary keybindings required).
* **Burst-Fire Weapon Engine**: Dedicated compensation for **Mk47 Mutant** (2-round burst, 600 RPM) and **M16A4** (3-round burst, 800 RPM) with smooth per-shot pull and automatic cycling.
* **Ballistic S-Curve Dynamic Scaling**: Progressive decay shaper (`0.36` opening -> `0.44` climb -> `0.50` peak -> `0.32` floor) eliminates opening muzzle hitch while sustaining rock-solid pull through magazine dumps.
* **Direct Middle-Click Master Standby**: Added `DIRECT_MACRO_OFF_BUTTON = 3` (Middle Click) for instant single-click macro toggle without modifier gymnastics.
* **Extended 6s+ Full Spray Hold**: Expanded spray tick curves to 320–350 ticks (~6s) for ARs, 320–450 ticks (~5s) for SMGs, and 500–650 ticks (~8s) for LMGs. Over-mag hold locks pull at 100% full recoil (`raw_v = last_valid_y`) indefinitely until LMB release.

### Changed
* **User-Tuned Weapon Baseline Integrated**: Preserved the user's fine-tuned weapon profile with `MOUSE_DPI = 800` and `SensSetting = 1.20`, matching their custom vertical `stand` and `crouch` calibrations.
* **Friction-Free Mouse Tracking**: Horizontal micro-bias feeds directly into the sub-pixel accumulator `ApplySubPixelMove` at `~0.006px` per tick (~1 pixel every 35 ticks / 600ms). Physical hand tracking delivers 20–50 pixels of hardware input, effortlessly overpowering the micro-nudge with zero resistance, sticking, or drag when leading moving targets.
* **Restored Battle-Tested Multipliers**: Replaced inflated ~1.86x `ref.lua` multipliers with the battle-tested baseline multipliers (`M416 = 2.65 / 2.12`, `AKM = 3.35 / 2.68`, `Beryl = 3.60 / 2.88`, `M249 = 2.25 / 1.30`), eliminating M249 over-pull into the ground.
* **Zero-Allocation Architecture**: Moved all persistent engine state variables to file scope, eliminating repeated variable allocations inside `OnEvent` and removing garbage-collection stutters.
* **Decoupled CapsLock Toggle**: Macro state is controlled internally by mouse buttons rather than being blocked by Windows UAC security restrictions on synthetic lock keys.

### Removed
* **Vaulted Weapons Excised**: Permanently removed **DP-28** and **PP-19 Bizon** following their removal from PUBG PC world spawn pools.
* **Reallocated Standby Slots**: Repurposed bind `1105` (`RALT + RSHIFT + Mouse 5`) and bind `1006` (`RCTRL + RALT + Mouse 6`) to direct Master Macro OFF / Standby.
* **Ping-Pong Anti-Drift Snap-Back Excised**: Completely removed the legacy `cumulative_x_drift > 3.0` spring correction that previously caused directional reversals and crosshair vibration.
* **Square-Wave Modulo Oscillations Removed**: Eliminated the alternating `(i % 4 == 0)` multiplier from `GenerateHorizontalBias`, providing smooth, uninterrupted drift compensation.
* **Dead Code Cleanup**: Excised 21 duplicate legacy `function Dino(...)` declarations and uncalled legacy routines (~11,000 lines cleaned).

---

## [v7.0] — RPD 7.62mm LMG, 65% Keyboard Layout Optimization & Arsenal Refresh
> **Release File:** [`Dino-V7.lua`](Dino-V7.lua)  
> **Base Architecture:** `Dino-V6.lua` with RPD LMG integration, layout accessibility fixes, and codebase cleanup.

### Added
* **RPD 7.62mm LMG Profile**: Complete compensation curves for PUBG's RPD (750 RPM):
  * Standard 50-round drum and extended 110-round magazine profiles.
  * Tuned `RPD = { stand = 2.18, crouch = 1.74 }` with Tactical Stock damping.
  * Integrated into `is_762` caliber scaling pipeline.

### Changed
* **65% Keyboard Layout Optimization (ScrollLock ↔ NumLock Swap)**:
  * **NumLock**: Toggles **Attachment Mode** across all scripts (accessible on compact 60%/65%/TKL keyboards and laptops).
  * **ScrollLock**: Serves as the `+500` Modifier Key for mouse combos.
  * **Dino-PUBGM.lua**: Mouse 5 toggles DMR mode with `ScrollLock`, while `NumLock` toggles Lean-Spam.

### Removed
* First phase of vaulted weapon cleanup removing legacy DP-28 and Bizon routines from V7.

---

## [v6.0] — DMR Mode, Weapon Tuning Panel & Keybind Overhaul
> **Release File:** [`Dino-V6.lua`](Dino-V6.lua)  
> **Base Architecture:** `Dino-V5.lua` with semi-automatic tap assist and centralized header configuration.

### Added
* **DMR No-Recoil Mode**: Brand-new single-tap recoil compensation for semi-automatic marksman rifles with configurable pull (`dmr_pull = 25`), smoothing steps (`dmr_steps = 4`), and inter-shot timing.
* **Centralized Weapon Tuning Panel**: Introduced the `WeaponTuner` table at the top of the script, allowing players to tune individual weapon multipliers directly without editing engine functions.
* **MP9 SMG Support**: Added dedicated profile and keybinding (`606`) for the MP9 9mm SMG.

### Changed
* **Ergonomic Keybind Reorganization**: Vector moved to `106` (LCTRL + Mouse 6), P90 swapped to `506`, JS9 moved to `306`.

---

## [v5.0] — Horizontal Control & Timing Precision
> **Release File:** [`Dino-V5.lua`](Dino-V5.lua)  
> **Base Architecture:** `Dino-V4.lua` with elapsed-time tracking and cumulative displacement dampening.

### Added
* **Anti-Drift Correction**: Introduced tracking for cumulative horizontal displacement to counteract gradual lateral walking during long sprays.
* **Elapsed-Time Tick Compensation**: Added high-resolution timestamp measurement (`GetRunningTime()`) per tick. Scales pull proportionally if CPU latency delays tick execution, maintaining uniform spray pacing.

---

## [v4.0] — Spray Transfer Detection
> **Release File:** [`Dino-V4.lua`](Dino-V4.lua)  
> **Base Architecture:** `Dino-V3.lua` with intelligent flick detection.

### Added
* **Spray Transfer Detection**: Detects brief trigger releases (< 380ms) occurring after 40+ ticks of continuous fire. Automatically soft-resets the recoil curve to Tick 5 instead of resuming deep in the pattern, preventing severe over-pull when flicking to a second target.

---

## [v3.0] — Burst Fire & Adaptive Pull
> **Release File:** [`Dino-V3.lua`](Dino-V3.lua)  
> **Base Architecture:** `Dino-V2.lua` with multi-click burst memory.

### Added
* **Burst Memory**: If releasing and re-clicking LMB within 380ms, the engine resumes the recoil curve from the previous shot rather than restarting from Bullet 1. Complete reset occurs only after a 380ms+ pause.

---

## [v2.0] — Recoil Engine Rewrite
> **Release File:** `DIno-V2.lua`  
> **Base Architecture:** `Dino-V1.lua` with smooth mathematical decay.

### Added
* **Smooth Decay Curve**: Replaced hard step cutoffs with gradual progressive fade (`0.50` -> `0.30` -> `0.25` late spray).
* **End-of-Mag Extension**: Replaced flat pull cutoffs with decaying pull (30% -> 10%) over 200 ticks using the last valid coordinate.
* **First-Bullet Compensation**: Scaled first two ticks to 60% pull to align with PUBG's delayed first-shot muzzle climb.

---

## [v1.0] — Modifier Keybind System & Engine Tuning
> **Release File:** `Dino-V1.lua`  
> **Base Architecture:** Original `Dino.lua` refactored into a structured modifier system.

### Added
* **Modifier Keybind Engine**: Introduced single-modifier combos across Mouse 4, 5, 6 using `LCTRL (+100)`, `LALT (+200)`, `RCTRL (+300)`, `RALT (+400)`, `NUMLOCK (+500)`, `RSHIFT (+600)`.
* **Full Arsenal Coverage**: Mapped previously unbound weapons (G36C, SCAR-L, QBZ, Groza, ACE32, K2, FAMAS, SMGs, LMGs).
* **Base Tuning**: Adjusted horizontal pull modifier to `0.75` and global pull modifier to `0.50`.

---

## Comprehensive Feature Matrix

| Feature / Architectural Milestone | v1.0 | v2.0 | v3.0 | v4.0 | v5.0 | v6.0 | v7.0 | v8.0 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Modifier Keybind System (+100 to +600)** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Compound Modifiers (+700 to +1200)** | — | — | — | — | — | — | — | ✅ |
| **Smooth Progressive Decay Shaper** | — | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **First-Bullet Kick Mitigation** | — | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Multi-Click Burst Memory (< 380ms)** | — | — | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Spray Transfer Target Flick Detection** | — | — | — | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Elapsed-Time Tick Sleep Compensation** | — | — | — | — | ✅ | ✅ | ✅ | ✅ |
| **Centralized WeaponTuner Panel** | — | — | — | — | — | ✅ | ✅ | ✅ |
| **RPD 7.62mm LMG Profile** | — | — | — | — | — | — | ✅ | ✅ |
| **65% Keyboard Layout NumLock Swap** | — | — | — | — | — | — | ✅ | ✅ |
| **Vaulted Weapons Excised (DP-28 & Bizon)**| — | — | — | — | — | — | Partial | ✅ |
| **Full Active Arsenal (32 Weapons)** | — | — | — | — | — | — | — | ✅ |
| **Dedicated PUBGIntel DMR Engine (8 Guns)**| — | — | — | — | — | Generic | Generic | ✅ |
| **Burst-Fire Engine (Mutant & M16A4)** | — | — | — | — | — | — | — | ✅ |
| **Laser Spray S-Curve (0.36 -> 0.50 -> 0.32)**| — | — | — | — | — | — | — | ✅ |
| **Direct Middle-Click Standby (Button 3)**| — | — | — | — | — | — | — | ✅ |
| **Extended 6s+ Full Spray Recoil Hold** | — | — | — | — | — | — | — | ✅ |
| **Zero-Allocation File-Scope State** | — | — | — | — | — | — | — | ✅ |
| **Sub-Pixel Float Remainder Accumulator** | — | — | — | — | — | — | — | ✅ |
| **User Fine-Tuned Baseline (800 DPI, 1.20)**| — | — | — | — | — | — | — | ✅ |
| **Transparent PUBGIntel Micro H-Bias** | — | — | — | — | — | — | — | ✅ |
| **Headshot Center-Lock (Ticks 1-8: 0.0)** | — | — | — | — | — | — | — | ✅ |
| **Zero Hand-Tracking Friction (No Snap)** | — | — | — | — | — | — | — | ✅ |

---

<div align="center">

**Dino Changelog • Documenting Precision Engineering since 2026**

</div>
