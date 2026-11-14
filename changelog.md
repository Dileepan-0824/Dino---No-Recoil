# Dino Release Changelog

All notable changes, architectural enhancements, ballistic calibrations, and bug fixes for the **Dino No-Recoil Engine** are documented in this file.

The format is structured in reverse-chronological order (newest release first) following standard software release guidelines.

[![Latest Release](https://img.shields.io/badge/Latest-v10.0-00C853?style=for-the-badge)](#v100--ue4-cubic-hermite-spline-engine--full-ballistic-overhaul)
[![Platform](https://img.shields.io/badge/Platform-Logitech%20G%20Hub%20Lua-00A8FF?style=for-the-badge)](#)
[![PUBG Version](https://img.shields.io/badge/PUBG%20PC-v44+-FF6F00?style=for-the-badge)](#)
[![License](https://img.shields.io/badge/License-MIT-607D8B?style=for-the-badge)](#)

---

## Quick Navigation

* [v10.0 — UE4 Cubic Hermite Spline Engine & Full Ballistic Overhaul](#v100--ue4-cubic-hermite-spline-engine--full-ballistic-overhaul)
* [v9.2 — Weapon Tuner Calibration & Recoil Curve Refinements](#v92--weapon-tuner-calibration--recoil-curve-refinements)
* [v9.1 — Modifier Tier Table & State Management Cleanup](#v91--modifier-tier-table--state-management-cleanup)
* [v9.0 — Ballistic Engine Overhaul & Continuous Recoil Hold](#v90--ballistic-engine-overhaul--continuous-recoil-hold)
* [v8.0 — Laser Spray Overhaul, Compound Modifiers & Dedicated DMRs](#v80--laser-spray-overhaul-compound-modifiers--dedicated-dmrs)
* [v7.0 — RPD 7.62mm LMG & 65% Keyboard Layout Optimization](#v70--rpd-762mm-lmg-65-keyboard-layout-optimization--arsenal-refresh)
* [v6.0 — DMR Mode, Weapon Tuning Panel & Keybind Overhaul](#v60--dmr-mode-weapon-tuning-panel--keybind-overhaul)
* [v5.0 — Horizontal Control & Timing Precision](#v50--horizontal-control--timing-precision)
* [v4.0 — Spray Transfer Detection](#v40--spray-transfer-detection)
* [v3.0 — Burst Fire & Multi-Click Memory](#v30--burst-fire--adaptive-pull)
* [v2.0 — Ballistic Progressive Decay](#v20--recoil-engine-rewrite)
* [v1.0 — Modifier Keybind System & Engine Tuning](#v10--modifier-keybind-system--engine-tuning)
* [Comprehensive Version Feature Matrix](#comprehensive-feature-matrix)

---

## [v10.0] — UE4 Cubic Hermite Spline Engine & Full Ballistic Overhaul
> **Release File:** [`Dino-V10.lua`](Dino-V10.lua)  
> **Base Architecture:** Transitioned engine to Unreal Engine 4 cubic Hermite spline interpolation model. Keyframe evaluation provides exact mathematically continuous curve matching for vertical rise, horizontal sway, and recovery dynamics.

### Added
* **UE4 Cubic Hermite Spline Interpolator**: Replaced linear step approximations with cubic Hermite spline evaluation (`EvalSpline`) calculating arrive and leave tangents, tangent modes, and exponential recovery response (`SplineResponseGamma = 0.32`).
* **Game-Calibrated Stance Multipliers**: Integrated exact game-file stance coefficients:
  * **Assault Rifles**: Standard ARs (`0.84` crouch, `0.70` prone); AUG A3 (`0.86` crouch, `0.70` prone); Beryl M762 & MK47 Mutant (`0.88` crouch, `0.70` prone).
  * **Designated Marksman Rifles**: Universal `0.75` crouch multiplier across all DMR platforms.
  * **Light Machine Guns**: M249 (`0.54` crouch, `0.25` prone); MG3 (`0.50` crouch, `0.27` prone); RPD (`0.58` crouch, `0.24` prone).
* **Full-Auto Continuous Hold for VSS & Mk14**: Dedicated high-cadence continuous spray logic for automatic marksman rifles.
* **Compound Attachment Scaling**: Multiplicative vertical and horizontal scaling factoring compensators, foregrips, and stocks from verified attachment multiplier tables.
* **Streamlined Repository Structure**: Maintained Dino-V10 exclusively on `main` for clean production deployment.

---

## [v9.2] — Weapon Tuner Calibration & Recoil Curve Refinements
> **Release File:** `Dino-V9.lua`  
> **Base Architecture:** Targeted fine-tuning of weapon tuner baseline scalars, LMG sustained relief, mid-spray boosts for AUG and Vector, and ACE32 spline calibration.

### Changed
* **LMG Sustained Spray Relief**: Moderated vertical curves and tuner baselines across M249 (`2.00 / 1.05`), MG3 (`1.92 / 0.90`), and RPD (`2.25 / 1.30`) to eliminate over-pull during high-capacity sustained firing.
* **Mid-Spray Curve Boosts**: Enhanced mid-magazine pull for AUG (`9.2 -> 12.6 -> 14.2`) and Vector (`7.6 -> 10.8 -> 12.2`) to prevent climb during mid-spray transitions.
* **7.62mm AR Pattern Reductions**: Moderated spray curves and tuner values for AKM, Beryl M762, and Groza.
* **ACE32 Curve Calibration**: Calibrated `v_curve` (`11.0, 15.0, 16.4, 350`) while maintaining tuner values (`3.00, 2.28`).

---

## [v9.1] — Modifier Tier Table & State Management Cleanup
> **Release File:** `Dino-V9.lua`  
> **Base Architecture:** Formalized modifier tier documentation, updated custom keybindings, excised generic DMR references, and clarified state management.

### Added
* **Formalized Modifier Tier Table**: Structured documentation of Tiers 0 through 12 (+0 to +1200) mapping modifier keys to weapon offsets.
* **Clean State Management**: Streamlined single-line telemetry and state documentation.

### Removed
* **Generic DMR Routines Excised**: Cleaned out obsolete generic DMR profiles in favor of dedicated per-weapon cadences.

---

## [v9.0] — Ballistic Engine Overhaul & Continuous Recoil Hold
> **Release File:** `Dino-V9.lua`  
> **Base Architecture:** Full-auto continuous recoil hold, horizontal micro-bias integration, and startup telemetry console logging.

### Added
* **Continuous Hold Logic**: Persistent continuous hold logic maintaining full recoil pull indefinitely until Left Mouse Button release.
* **Startup Telemetry Logging**: Console output for active profiles, sensitivity parameters, and weapon switches.

---

## [v8.0] — Laser Spray Overhaul, Compound Modifiers & Dedicated DMRs
> **Release File:** `Dino-V8.lua`  
> **Base Architecture:** Complete architectural overhaul combining compound modifiers, per-shot DMR ballistics, burst-fire engines, transparent horizontal micro-bias, and user-calibrated 800 DPI profile.

### Added
* **Game-File Calibrated Micro-Biases**: Assigned per-weapon horizontal micro-biases based directly on game directional drift metrics:
  * **Left-Drifting Weapons**: M416 (`+0.035`), Beryl M762 (`+0.060`), AKM (`+0.075`), ACE32 (`+0.050`), Groza (`+0.040`), AUG (`+0.025`), K2 (`+0.025`), MP5K (`+0.020`), M249 (`+0.035`), RPD (`+0.045`). Received gentle Rightward micro-counters.
  * **Right-Drifting Weapons**: SCAR-L (`-0.035`), G36C (`-0.035`), QBZ (`-0.015`), Vector (`-0.020`), Micro UZI (`-0.020`), MG3 (`-0.020`). Received gentle Leftward micro-counters.
  * **Centered Weapons**: UMP45, Tommy Gun, P90, MP9, FAMAS, Mutant, M16A4, and all DMRs maintain `0.000` to prevent lateral kick.
* **Opening Headshot Lock (First 8 Ticks = 0.0)**: Ticks 1 to 8 (~130ms, opening 4–5 bullets) enforce strictly `0.0` horizontal compensation, ensuring initial snap-aim, crosshair placement, and opening headshots remain centered without lateral pull.
* **Smooth Progressive Linear Ramp-In**: Ticks 9 to 20 fade the micro-bias in linearly (`(i - 8) / 12 * bias_strength`) rather than stepping abruptly, eliminating muzzle hitch.
* **Master Horizontal Strength Slider**: Added `HorizontalStrength = 0.60` in the user configuration panel for quick global tuning (adjustable from `0.00` pure vertical to `1.00` full counter).
* **Full Dino V7 Muscle-Memory Keybind Parity**: Restored exact keybind assignments for all 21 weapons from Dino V7 (including ACE32 on `RALT + Mouse 5`, GROZA on `LALT + Mouse 5`, K2 on `RCTRL + Mouse 5`, M249 on `ScrollLock + Mouse 4`, FAMAS on `RSHIFT + Mouse 4`, MG3 on `ScrollLock + Mouse 5`, and DMR on `RSHIFT + Mouse 5`).
* **Compound Modifier System (+700 to +1200) for Expanded Arsenal**: Mapped remaining weapons onto collision-free compound tiers. Resolved AltGr / RALT hardware collision by re-binding Tier 7 (+700) to `LCTRL + LALT + LSHIFT`, isolating it from Right Alt.
* **In-Game Sprint Isolation (Left Shift Safeguard)**: Excised `LSHIFT` from single weapon modifier selection in `GetModifierOffset()`. Tier 6 (+600) is strictly bound to `RSHIFT`, ensuring holding Left Shift to sprint or hold breath in-game will never collide with mouse clicks or cause accidental weapon switches.
* **Dedicated Per-Weapon DMR Ballistics Engine**: Replaced generic single-tap compensation with individual per-weapon DMR profiles:
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
* **Ballistic S-Curve Dynamic Scaling**: Progressive decay shaper (`0.36` opening -> `0.44` climb -> `0.50` peak -> `0.32` floor) eliminates opening muzzle hitch while sustaining pull through magazine dumps.
* **Direct Middle-Click Master Standby**: Added `DIRECT_MACRO_OFF_BUTTON = 3` (Middle Click) for instant single-click macro toggle without modifier combinations.
* **Extended 6s+ Full Spray Hold**: Expanded spray tick curves to 320–350 ticks (~6s) for ARs, 320–450 ticks (~5s) for SMGs, and 500–650 ticks (~8s) for LMGs. Over-mag hold locks pull at 100% full recoil indefinitely until LMB release.

### Changed
* **User-Tuned Weapon Baseline Integrated**: Preserved the user's fine-tuned weapon profile with `MOUSE_DPI = 800` and `SensSetting = 1.00`, matching custom vertical `stand` and `crouch` calibrations.
* **Friction-Free Mouse Tracking**: Horizontal micro-bias feeds directly into the sub-pixel accumulator `ApplySubPixelMove` at `~0.006px` per tick (~1 pixel every 35 ticks / 600ms). Physical hand tracking delivers 20–50 pixels of hardware input, effortlessly overpowering the micro-nudge with zero resistance, sticking, or drag when leading moving targets.
* **Restored Baseline Multipliers**: Replaced inflated multipliers with clean baseline values (`M416 = 2.65 / 2.12`, `AKM = 3.35 / 2.68`, `Beryl = 3.60 / 2.88`, `M249 = 2.25 / 1.30`), eliminating M249 over-pull into the ground.
* **Zero-Allocation Architecture**: Moved all persistent engine state variables to file scope, eliminating repeated variable allocations inside `OnEvent` and removing garbage-collection stutters.
* **Decoupled CapsLock Toggle**: Macro state is controlled internally by mouse buttons rather than being blocked by Windows UAC security restrictions on synthetic lock keys.

### Removed
* **Vaulted Weapons Excised**: Permanently removed **DP-28** and **PP-19 Bizon** following their removal from PC world spawn pools.
* **Reallocated Standby Slots**: Repurposed bind `1105` (`RALT + RSHIFT + Mouse 5`) and bind `1006` (`RCTRL + RALT + Mouse 6`) to direct Master Macro OFF / Standby.
* **Anti-Drift Snap-Back Excised**: Completely removed legacy spring corrections that previously caused directional reversals and crosshair vibration.
* **Square-Wave Modulo Oscillations Removed**: Eliminated the alternating `(i % 4 == 0)` multiplier from `GenerateHorizontalBias`, providing smooth, uninterrupted drift compensation.
* **Dead Code Cleanup**: Excised duplicate legacy function declarations and uncalled routines.

---

## [v7.0] — RPD 7.62mm LMG & 65% Keyboard Layout Optimization
> **Release File:** `Dino-V7.lua`

### Added
* **RPD Light Machine Gun Support**: Added weapon profile for the 7.62mm RPD LMG.
* **65% Keyboard Support**: Re-routed keybinds to accommodate keyboards lacking dedicated function rows or numpads.

---

## [v6.0] — DMR Mode, Weapon Tuning Panel & Keybind Overhaul
> **Release File:** `Dino-V6.lua`

### Added
* **Initial WeaponTuner Architecture**: Centralized weapon multiplier table for rapid manual adjustments.
* **Single-Tap DMR Mode**: Semi-automatic single-tap cadence engine.

---

## [v5.0] — Horizontal Control & Timing Precision
> **Release File:** `Dino-V5.lua`

### Added
* **Elapsed-Time Compensation**: Tick delta compensation for frame-rate consistency.
* **Initial Horizontal Sway Tracking**: Accumulator framework for horizontal pull.

---

## [v4.0] — Spray Transfer Detection
> **Release File:** `Dino-V4.lua`

### Added
* **Spray Transfer Support**: Soft accumulator reset when rapid hand movement is detected mid-spray.

---

## [v3.0] — Burst Fire & Multi-Click Memory
> **Release File:** `Dino-V3.lua`

### Added
* **Burst Memory**: Refire window memory preserving recoil progression during rapid tap-bursting.

---

## [v2.0] — Ballistic Progressive Decay
> **Release File:** `Dino-V2.lua`

### Added
* **Progressive Linear Decay Shaper**: Initial non-linear compensation curve.
* **First-Shot Kick Dampening**: Early tick smoothing to address initial muzzle climb.

---

## [v1.0] — Modifier Keybind System & Engine Tuning
> **Release File:** `Dino-V1.lua`

### Added
* **Modifier Keybind Framework**: Initial mouse side-button + modifier architecture.

---

## Comprehensive Feature Matrix

| Feature / Architectural Milestone | v1.0 | v2.0 | v3.0 | v4.0 | v5.0 | v6.0 | v7.0 | v8.0 | v9.0-v9.2 | v10.0 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Modifier Keybind System (+100 to +600)** | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| **Compound Modifiers (+700 to +1200)** | — | — | — | — | — | — | — | Yes | Yes | Yes |
| **Smooth Progressive Decay Shaper** | — | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| **First-Bullet Kick Mitigation** | — | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| **Multi-Click Burst Memory** | — | — | Yes | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| **Spray Transfer Detection** | — | — | — | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| **Elapsed-Time Tick Compensation** | — | — | — | — | Yes | Yes | Yes | Yes | Yes | Yes |
| **Centralized WeaponTuner Panel** | — | — | — | — | — | Yes | Yes | Yes | Yes | Yes |
| **RPD 7.62mm LMG Profile** | — | — | — | — | — | — | Yes | Yes | Yes | Yes |
| **Full Active Arsenal (32+ Weapons)** | — | — | — | — | — | — | — | Yes | Yes | Yes |
| **Dedicated Per-Weapon DMR Engine** | — | — | — | — | — | Generic | Generic | Yes | Yes | Yes |
| **Burst-Fire Engine (Mutant & M16A4)** | — | — | — | — | — | — | — | Yes | Yes | Yes |
| **Direct Middle-Click Standby** | — | — | — | — | — | — | — | Yes | Yes | Yes |
| **Extended Full Spray Recoil Hold** | — | — | — | — | — | — | — | Yes | Yes | Yes |
| **Zero-Allocation File-Scope State** | — | — | — | — | — | — | — | Yes | Yes | Yes |
| **Sub-Pixel Float Remainder Accumulator** | — | — | — | — | — | — | — | Yes | Yes | Yes |
| **Transparent Micro H-Bias** | — | — | — | — | — | — | — | Yes | Yes | Yes |
| **Headshot Center-Lock (Ticks 1-8: 0.0)** | — | — | — | — | — | — | — | Yes | Yes | Yes |
| **Continuous Full-Auto Recoil Hold** | — | — | — | — | — | — | — | — | Yes | Yes |
| **UE4 Hermite Cubic Spline Engine** | — | — | — | — | — | — | — | — | — | Yes |
| **Game-Calibrated Stance Multipliers** | — | — | — | — | — | — | — | — | — | Yes |
| **Compound Attachment Pool Scaling** | — | — | — | — | — | — | — | — | — | Yes |

---

<div align="center">

**Dino Changelog • Documenting Precision Engineering**

</div>
