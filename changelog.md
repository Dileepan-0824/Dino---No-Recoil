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
| **9** | Adaptive Late-Spray Floor | Replaces the flat `0.25` late-spray modifier with a dynamic value: high-recoil guns (AKM/Beryl, y > 15) get up to `0.30`, low-recoil SMGs stay near `0.22` |

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

## All Fixes Summary

| Fix | V1 | V2 | V3 | V4 | V5 |
|-----|----|----|----|----|-----|
| Modifier Keybind System | ✅ | ✅ | ✅ | ✅ | ✅ |
| Engine Tuning (0.75 horiz, 0.50 pull) | ✅ | ✅ | ✅ | ✅ | ✅ |
| 1 — Smooth Decay | | ✅ | ✅ | ✅ | ✅ |
| 4 — End-of-Mag Extension | | ✅ | ✅ | ✅ | ✅ |
| 5 — First-Bullet Comp | | ✅ | ✅ | ✅ | ✅ |
| 7 — Burst Memory | | | ✅ | ✅ | ✅ |
| 9 — Adaptive Late-Spray Floor | | | ✅ | ✅ | ✅ |
| 10 — Spray Transfer Detection | | | | ✅ | ✅ |
| 16 — Anti-Drift Correction | | | | | ✅ |
| 17 — Elapsed-Time Compensation | | | | | ✅ |
