# Dino Version Changelog

## V1 — Modifier Keybind System & Engine Tuning
> Base: `Dino.lua` (original) + keybind overhaul + engine tuning

### Keybind System
| Change | Description |
|--------|-------------|
| **Modifier Table** | Added modifier key combo system: LCTRL (+100), LALT (+200), RCTRL (+300), RALT (+400), NUMLOCK (+500), RSHIFT (+600) |
| **All Weapons Reassigned** | Every weapon slot now uses modifier combos for activation (e.g., AKM = 105 instead of 7, AUG = 104, GROZA = 205, etc.) |
| **Full Weapon Coverage** | Previously nil weapons (G36C, SCAR_L, QBZ, GROZA, ACE32, K2, FAMAS, BIZON, UMP45, UZI, VECTOR, P90, JS9, DP28, M249, MG3) now all have assigned binds |

### Engine Tuning
| Change | From (Original) | To (V1) |
|--------|-----------------|---------| 
| Horizontal Pull Modifier | `0.55` | `0.75` |
| Global Pull Modifier (initial) | `0.575` | `0.50` |
| End-of-Mag Extension ticks | `150` (~2.5s) | `360` (~6s) |

---

## V2 — Recoil Engine Rewrite
> Base: `Dino-V1.lua` + 3 engine improvements

| Fix | Name | Description |
|-----|------|-------------|
| **1** | Smooth Decay | Replaces hard 0.50 → 0.25 cutoff with gradual linear fade: `0.50` (ticks 1-10) → smooth fade to `0.30` (ticks 11-40) → `0.30` settling (ticks 41-80) → flat `0.25` late spray |
| **4** | End-of-Mag Extension | Replaces flat 25% pull with gradually decaying pull (30% → 10%) over 200 ticks using the last known pull values |
| **5** | First-Bullet Compensation | Reduces pull to 60% for the first 2 ticks (~34ms) because PUBG's first-bullet recoil kicks in slightly later |

---

## V3 — Burst Fire & Adaptive Pull
> Base: `V2` + 2 improvements

| Fix | Name | Description |
|-----|------|-------------|
| **7** | Burst Memory | If you release and re-click within 400ms, resumes the pattern from where you left off instead of restarting from bullet 1. Full reset only after 400ms+ gap |

---

## V4 — Spray Transfer Detection
> Base: `V3` + 1 improvement

| Fix | Name | Description |
|-----|------|-------------|
| **10** | Spray Transfer Detection | If you've been spraying 40+ ticks and briefly release (< 400ms), soft-resets to tick 5 instead of resuming. Prevents over-compensation when flicking to a new target mid-spray |

---

## V5 — Horizontal Control & Timing Precision
> Base: `V4` + 2 improvements

| Fix | Name | Description |
|-----|------|-------------|
| **16** | Anti-Drift Correction | Tracks cumulative horizontal displacement. If total drift exceeds ±5px, applies 10% correction back toward center each tick. Prevents crosshair from slowly walking sideways during long sprays |
| **17** | Elapsed-Time Compensation | Measures actual tick duration vs expected 17ms. If a tick ran late (e.g. 25ms due to CPU load), scales that tick's pull proportionally (clamped 0.7x–1.5x) to maintain consistency |

---

## V7 — RPD 7.62mm LMG, 65% Keyboard Layout Optimization & Arsenal Refresh
> Base: `V6` + RPD LMG integration + 65% layout keybind swap + vaulted weapons cleanup

### RPD 7.62mm LMG Support (New Weapon)
- **750 RPM Recoil Engine Profile**: Implemented full auto compensation curves for PUBG's new RPD (Update 42.3/43.1).
- **Stance & Magazine Support**:
  - `RPDD` / `RPDD_`: 50-round standard magazine profiles for standing and crouching.
  - `RPDatt` / `RPDatt_`: Extended 110-round magazine profiles with Tactical/Heavy Stock recoil damping.
- **WeaponTuner Multipliers**: Added `RPD = { stand = 2.18, crouch = 1.74 }` tuned specifically for 750 RPM 7.62mm kick.
- **Engine Pipeline Integration**: Hooked into `is_762` profile (`y = y * 0.95`) and inherits Burst Memory, Spray Transfer Detection, Anti-Drift, and Elapsed-Time Compensation.

### 65% Keyboard Layout Optimization (ScrollLock ↔ NumLock Swap)
- **Accessibility Fix**: Users on compact 65%, 75%, 60%, TKL keyboards and laptops frequently lack a dedicated physical `ScrollLock` key.
- **Functionality Swap**:
  - **NumLock**: Now toggles **Attachment Mode** across all version scripts (NumLock ON = attachments, OFF = without attachments).
  - **ScrollLock**: Now serves as the **+500 Modifier Key** for mouse combos.
  - **Dino-PUBGM.lua**: Swapped so Mouse 5 toggles DMR mode with `ScrollLock`, while `NumLock` toggles Lean-Spam.

### Vaulted Weapons Cleanup
- Removed **DP-28** and **PP-19 Bizon** from `Dino-V7.lua` following their removal from the active game pool.
- Removed all corresponding variables, `WeaponTuner` entries, `OnEvent` triggers, and 8 recoil routines (~11,500 lines of dead code cleaned).

---

## V6 — DMR Mode, Weapon Tuning Panel & Keybind Overhaul
> Base: `V5` + 4 major additions

### DMR No-Recoil Mode (New)
| Setting | Default | Description |
|---------|---------|-------------|
| `dmr_pull` | `25` | Total pixels pulled down per single tap |
| `dmr_steps` | `4` | Number of smoothing subdivisions |
| `dmr_sleep` | `10` | Delay between smoothing steps (ms) |
| `dmr_tap_mode` | `1` | Tap behavior mode |
| `dmr_tap_delay` | `2` | Delay between taps |
| `dmr_click_duration` | `5` | Click hold duration |

### Weapon Tuning Panel (New)
Added a `WeaponTuner` table at the top of the script allowing per-weapon recoil multiplier customization:

| Weapon | Stand | Crouch | Notes |
|--------|-------|--------|-------|
| AKM | 2.57 | 2.05 | Heavy 7.62 |
| M416 | 1.50 | 1.20 | **Baseline anchor** |
| Beryl | 2.71 | 2.17 | Heaviest recoil AR |
| SCAR-L | 1.49 | 1.20 | Slightly less than M416 |
| QBZ | 1.58 | 1.28 | Close to SCAR |
| ACE32 | 2.27 | 1.81 | Heavy 7.62, controllable |
| K2 | 1.56 | 1.25 | Slightly more than M416 |
| FAMAS | 1.76 | 1.42 | Higher RPM |
| GROZA | 2.34 | 1.88 | Crate 7.62, very heavy |
| AUG | 1.48 | 1.22 | Crate AR, lowest recoil |
| G36C | 1.46 | 1.17 | Vikendi, very low |
| DP-28 | 1.80 | 1.45 | Slow RPM, moderate |
| M249 | 2.20 | 1.76 | Heavy sustained |
| MG3 | 2.12 | 1.70 | Fast RPM LMG |
| Bizon | 1.20 | 0.97 | Very low recoil |
| Tommy | 1.38 | 1.11 | Slow, moderate |
| UMP45 | 1.16 | 0.94 | Lowest recoil SMG |
| UZI | 1.20 | 0.97 | Low, very fast |
| Vector | 1.36 | 1.10 | Fast RPM |
| MP5K | 1.26 | 1.02 | Medium SMG |
| P90 | 1.33 | 1.08 | Medium, large mag |
| MP9 | 1.25 | 1.02 | Low recoil |
| JS9 | 1.28 | 1.04 | Low-medium |

### Keybind Changes
| Weapon | V5 Bind | V6 Bind | Change |
|--------|---------|---------|--------|
| Vector | `506` | `106` | Moved for ergonomics |
| P90 | `106` | `506` | Swapped with Vector |
| MP9 | `nil` | `606` | **Now bound** |
| JS9 | `606` | `306` | Moved |
| Bizon | `306` | `nil` | Freed (assign as needed) |
| DP-28 | `605` | `nil` | Freed (slot given to DMR) |
| DMR | — | `605` | **New slot** |

### PUBG Mobile Script (New)
Added standalone `Dino-PUBGM.lua` with:
- AR + DMR dual-mode switching (Mouse 4 / Mouse 5)
- Lean-spam automation (ScrollLock toggle)
- Simplified single-button controls for emulator play

---

## All Fixes Summary

| Fix | V1 | V2 | V3 | V4 | V5 | V6 | V7 |
|-----|----|----|----|----|----|-----|-----|
| Modifier Keybind System | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Engine Tuning (0.75 horiz, 0.50 pull) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 1 — Smooth Decay | | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 4 — End-of-Mag Extension | | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 5 — First-Bullet Comp | | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 7 — Burst Memory | | | ✅ | ✅ | ✅ | ✅ | ✅ |
| 10 — Spray Transfer Detection | | | | ✅ | ✅ | ✅ | ✅ |
| 16 — Anti-Drift Correction | | | | | ✅ | ✅ | ✅ |
| 17 — Elapsed-Time Compensation | | | | | ✅ | ✅ | ✅ |
| DMR No-Recoil Mode | | | | | | ✅ | ✅ |
| Weapon Tuning Panel | | | | | | ✅ | ✅ |
| Keybind Reorganization | | | | | | ✅ | ✅ |
| PUBG Mobile Script | | | | | | ✅ | ✅ |
| RPD 7.62mm LMG Support | | | | | | | ✅ |
| 65% Keyboard Layout Keybind Swap | | | | | | | ✅ |
| Vaulted Weapons Cleanup (DP-28 & Bizon) | | | | | | | ✅ |
