-------------------------------------------------------------------------------------------------------------------------
--  ____  _             
-- |  _ \(_)_ __   ___  
-- | | | | | '_ \ / _ \  
-- | |_| | | | | | (_) |  
-- |____/|_|_| |_|\___/    
--
-- DINO V8 — PRECISION HORIZONTAL BIAS & ZERO-RECOIL WEAPON ENGINE FOR PUBG PC (LOGITECH G HUB)
-- SUBTLE PUBGINTEL HORIZONTAL BIAS | ZERO INTERFERENCE WITH MANUAL MOUSE TRACKING | 800 DPI CALIBRATED
-- DATA-MINED RECOIL PROFILES REFERENCED FROM PUBGINTEL.COM
-------------------------------------------------------------------------------------------------------------------------
--
-- [QUICK STATUS & CONTROLS]
-- MOUSE 4 / 5 / 6 : Press to ACTIVATE weapon; press again (or any weapon button) to turn OFF (Standby)
-- MIDDLE MOUSE (3): Instant Master Standby / Turn OFF (No modifier required)
-- CAPSLOCK ON     : Macro Indicator (Auto-synced with macro state)
-- NUMLOCK ON      : WITH ATTACHMENTS (When EnableAttachments = true & AttachmentsMode = "NUMLOCK")
-- NUMLOCK OFF     : WITHOUT ATTACHMENTS (Bare weapon full pull)
-- HOLD LCTRL      : CROUCH MODE (When EnableCrouchMode = true, ~20% recoil reduction)
-- HOLD LSHIFT     : SCOPED / HOLD-BREATH MODE (When EnableHoldBreath = true, ~10% steady-aim reduction)
--
-------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------
-- [1] USER CONFIGURATION PANEL
-------------------------------------------------------------------------------------------------------------------------

-- Physical mouse DPI note:
local MOUSE_DPI = 800

-- Global Sensitivity Multiplier:
-- Scale this if your in-game Vertical Sensitivity Multiplier or ADS sensitivity differs from baseline.
-- Formula: SensSetting = 46 / (Your In-Game ADS Sensitivity) * (1.00 / Your Vertical Multiplier)
local SensSetting = 1.20

-- =====================================================================================
-- GLOBAL FEATURE TOGGLES (CROUCH, HOLD-BREATH & ATTACHMENTS)
-- =====================================================================================

-- 1. Crouch Mode Toggle:
-- true  = Dynamically detects holding LCTRL while firing, reducing recoil pull by ~20% [Default]
-- false = Disables crouch scaling (recoil pull remains 100% standing pull even if crouching)
local EnableCrouchMode = true

-- 2. Hold Breath / Scoped Steady-Aim Toggle:
-- true  = Dynamically detects holding LSHIFT while firing, reducing recoil pull by ~10% [Default]
-- false = Disables hold-breath scaling (recoil pull is completely unaffected by Shift)
local EnableHoldBreath = true

-- 3. Attachments Compensation Global Toggle:
-- true  = Enables attachment scaling (~22% reduced pull for Compensator/Grips/Tactical Stock) [Default]
-- false = Disables attachment scaling entirely (uses bare-weapon full pull at all times)
local EnableAttachments = true

-- 4. Attachments Trigger Mode (Only active when EnableAttachments = true):
-- "NUMLOCK" = Controlled dynamically by NumLock key (NumLock ON = equipped, NumLock OFF = bare weapon) [Default]
-- "ALWAYS"  = Attachments ALWAYS active (NumLock key not required; recommended for 60%/65%/TKL/Laptop keyboards)
local AttachmentsMode = "NUMLOCK"

-- =====================================================================================
-- OPERATIONAL MODES & CONTROLS
-- =====================================================================================

-- Mouse Button Click Mode:
-- 1 = Recoil active on Left Mouse Button (LMB) only [Default]
-- 3 = Recoil active ONLY when holding Right Mouse Button (RMB) + Left Mouse Button (LMB)
local ClickMode = 1

-- DMR Firing & Auto-Tap Mode:
-- true  = Holding LMB auto-cycles rapid single-taps at the weapon's maximum RPM with recoil control. [Default]
-- false = Precision single-tap assist: compensates recoil per physical click.
local DMR_AUTO_TAP = true

-- Horizontal Recoil Compensation Master Multiplier:
-- 0.60 = Subtle, transparent micro-stabilization (counters gun's natural directional bias without fighting manual hand movement)
-- 1.00 = Full strength counter-drift
-- 0.00 = Pure vertical only (zero horizontal compensation)
local HorizontalStrength = 0.60

-- =====================================================================================
-- TOGGLE & SHUTOFF MODES
-- =====================================================================================

-- Weapon Button Toggle Behavior (When macro is currently active):
-- "ANY"  : [RECOMMENDED - ref.lua & Dino-V7 behavior]
--          Pressing ANY weapon mouse button (Mouse 4, 5, 6) turns the macro completely OFF (Standby).
--          Example: Click Mouse 4 -> M416 ON. Click Mouse 4 (or Mouse 5) -> Macro turns OFF.
-- "SAME" : Pressing the CURRENT weapon's button turns it OFF.
--          Pressing a DIFFERENT weapon's button switches weapon immediately without turning off.
local WEAPON_TOGGLE_MODE = "ANY"

-- Direct Standby / Macro Off Button (Optional single-click shutoff):
-- Set to a mouse button number (e.g. 3 for Middle Mouse Click) to instantly turn macro OFF.
-- Set to nil or false to disable.
local DIRECT_MACRO_OFF_BUTTON = nil

-- Sync Keyboard CapsLock LED:
-- true  = Attempts to toggle physical CapsLock key LED when activating/deactivating.
-- false = Operates purely internally (recommended if G Hub / Windows blocks synthetic lock keys).
local SYNC_CAPSLOCK_LED = true

-- Require CapsLock ON for Recoil Firing:
-- true  = Physical CapsLock LED MUST be ON for recoil to pull (hardware safety killswitch).
-- false = Macro active state is controlled 100% by your mouse buttons (recommended & 100% reliable).
local REQUIRE_CAPSLOCK_FOR_FIRE = false

-- Dynamic Logging to Logitech G Hub Script Console
local ENABLE_LOGGING = true

-------------------------------------------------------------------------------------------------------------------------
-- [2] WEAPON TUNING PANEL (USER-CALIBRATED BASELINE + PUBGINTEL MINOR H-BIAS)
-- Fine-tuned for laser sprays without restricting manual horizontal mouse tracking!
-- Positive h_bias (+): Counters leftward gun drift by applying gentle right micro-compensation.
-- Negative h_bias (-): Counters rightward gun drift by applying gentle left micro-compensation.
-------------------------------------------------------------------------------------------------------------------------
local WeaponTuner = {
    -- ASSAULT RIFLES (User Fine-Tuned + PUBGIntel Game-File Micro H-Bias)
    M416     = { stand = 2.65, crouch = 2.12, att_scale = 0.78, h_bias =  0.035 }, -- Left bias (0.10) -> Subtle Right counter
    BERRYL   = { stand = 3.60, crouch = 2.88, att_scale = 0.75, h_bias =  0.060 }, -- Left kick (0.10) -> Smooth Right counter
    AKM      = { stand = 3.35, crouch = 2.68, att_scale = 0.85, h_bias =  0.075 }, -- Heavy Left (0.20) -> Controlled Right counter
    AUG      = { stand = 2.70, crouch = 2.16, att_scale = 0.78, h_bias =  0.025 }, -- Slight Left (0.05) -> Gentle Right counter
    ACE32    = { stand = 3.35, crouch = 2.68, att_scale = 0.76, h_bias =  0.050 }, -- Left bias (0.10) -> Smooth Right counter
    SCAR_L   = { stand = 2.50, crouch = 2.00, att_scale = 0.78, h_bias = -0.035 }, -- Right bias (0.10) -> Gentle Left counter
    QBZ      = { stand = 2.60, crouch = 2.08, att_scale = 0.78, h_bias = -0.015 }, -- Slight Right (0.02) -> Minimal Left counter
    G36C     = { stand = 2.45, crouch = 1.96, att_scale = 0.78, h_bias = -0.035 }, -- Right bias (0.10) -> Gentle Left counter
    K2       = { stand = 2.70, crouch = 2.16, att_scale = 0.82, h_bias =  0.025 }, -- Slight Left (0.05) -> Gentle Right counter
    GROZA    = { stand = 3.70, crouch = 2.96, att_scale = 0.88, h_bias =  0.040 }, -- Slight Left (0.05) -> Gentle Right counter
    FAMAS    = { stand = 2.95, crouch = 2.36, att_scale = 0.85, h_bias =  0.000 }, -- High RPM, balanced center -> Pure vertical
    MUTANT   = { stand = 3.20, crouch = 2.56, att_scale = 0.76, h_bias =  0.000 }, -- 2-rd burst -> Pure vertical laser
    M16A4    = { stand = 2.50, crouch = 2.00, att_scale = 0.78, h_bias =  0.000 }, -- 3-rd burst -> Pure vertical laser

    -- SUBMACHINE GUNS (Pure Vertical Focus with Subtle Micro-Tuning)
    UMP45    = { stand = 1.95, crouch = 1.56, att_scale = 0.78, h_bias =  0.000 }, -- Stable baseline SMG -> Pure vertical
    VECTOR   = { stand = 2.35, crouch = 1.88, att_scale = 0.75, h_bias = -0.020 }, -- Slight Right (0.03) -> Micro Left counter
    UZI      = { stand = 2.15, crouch = 1.72, att_scale = 0.78, h_bias = -0.020 }, -- Slight Right (0.03) -> Micro Left counter
    MP5K     = { stand = 2.20, crouch = 1.76, att_scale = 0.75, h_bias =  0.020 }, -- Slight Left (0.03) -> Micro Right counter
    TOMMY    = { stand = 2.25, crouch = 1.80, att_scale = 0.85, h_bias =  0.000 }, -- .45 Drum -> Pure vertical laser
    P90      = { stand = 2.15, crouch = 1.72, att_scale = 1.00, h_bias =  0.000 }, -- Crate laser -> Pure vertical
    MP9      = { stand = 2.10, crouch = 1.68, att_scale = 1.00, h_bias =  0.000 }, -- Integrated suppressor -> Pure vertical
    JS9      = { stand = 2.15, crouch = 1.72, att_scale = 0.78, h_bias =  0.015 }, -- Slight Left (0.02) -> Minimal Right counter

    -- LIGHT MACHINE GUNS (Tamed Pull & Bipod Profiles)
    M249     = { stand = 2.25, crouch = 1.30, att_scale = 0.88, h_bias =  0.035 }, -- Sustained Left -> Subtle Right counter
    MG3      = { stand = 2.40, crouch = 1.35, att_scale = 1.00, h_bias = -0.020 }, -- Bipod Right -> Subtle Left counter
    RPD      = { stand = 2.55, crouch = 1.60, att_scale = 0.82, h_bias =  0.045 }, -- Heavy drum Left -> Smooth Right counter
   
    -- DESIGNATED MARKSMAN RIFLES (PUBGIntel Per-Shot Calibrated - 0.0 h_pull to prevent side kick)
    DRAGUNOV = { stand = 1.00, crouch = 0.80, att_scale = 0.82, pull = 34, h_pull = 0.0, steps = 4, sleep = 10, delay = 250 },
    SLR      = { stand = 1.00, crouch = 0.80, att_scale = 0.80, pull = 28, h_pull = 0.0, steps = 4, sleep = 8,  delay = 180 },
    SKS      = { stand = 1.00, crouch = 0.80, att_scale = 0.72, pull = 24, h_pull = 0.0, steps = 4, sleep = 8,  delay = 180 },
    MK14     = { stand = 1.00, crouch = 0.75, att_scale = 0.75, pull = 26, h_pull = 0.0, steps = 4, sleep = 7,  delay = 160 },
    MINI14   = { stand = 1.00, crouch = 0.80, att_scale = 0.80, pull = 16, h_pull = 0.0, steps = 3, sleep = 6,  delay = 170 },
    MK12     = { stand = 1.00, crouch = 0.75, att_scale = 0.76, pull = 15, h_pull = 0.0, steps = 3, sleep = 6,  delay = 170 },
    QBU      = { stand = 1.00, crouch = 0.75, att_scale = 0.80, pull = 16, h_pull = 0.0, steps = 3, sleep = 6,  delay = 170 },
    VSS      = { stand = 1.00, crouch = 0.80, att_scale = 0.85, pull = 12, h_pull = 0.0, steps = 3, sleep = 5,  delay = 120 },
    DMR_GEN  = { stand = 1.00, crouch = 0.80, att_scale = 0.78, pull = 22, h_pull = 0.0, steps = 4, sleep = 8,  delay = 180 },
}

-------------------------------------------------------------------------------------------------------------------------
-- [3] MASTER KEYBINDINGS SYSTEM (CALIBER-ALIGNED BUTTON MAPPING)
-- • 4-SERIES (MOUSE BUTTON 4) : ALL 5.56mm WEAPONS (ARs, DMRs, LMGs)
-- • 5-SERIES (MOUSE BUTTON 5) : ALL 7.62mm WEAPONS (ARs, DMRs, LMGs)
-- • 6-SERIES (MOUSE BUTTON 6) : ALL SMGs (9mm/.45/5.7mm), VSS, & STANDBY
--
-- TIER  0 (+0)    : None (Mouse 4, 5, 6)
-- TIER  1 (+100)  : LCTRL + Mouse Button
-- TIER  2 (+200)  : LALT + Mouse Button
-- TIER  3 (+300)  : RCTRL + Mouse Button
-- TIER  4 (+400)  : RALT + Mouse Button
-- TIER  5 (+500)  : ScrollLock ON + Mouse Button
-- TIER  6 (+600)  : RSHIFT + Mouse Button
-- TIER  7 (+700)  : LCTRL + LALT + LSHIFT + Mouse Button
-- TIER  8 (+800)  : LCTRL + LSHIFT + Mouse Button
-- TIER  9 (+900)  : LALT + LSHIFT + Mouse Button
-- TIER 10 (+1000) : RCTRL + RALT + Mouse Button
-- TIER 11 (+1100) : RALT + RSHIFT + Mouse Button
-- TIER 12 (+1200) : RCTRL + RSHIFT + Mouse Button
-------------------------------------------------------------------------------------------------------------------------

-- =====================================================================================
-- 4-SERIES: 5.56mm WEAPONS (ALL ASSIGNED TO MOUSE 4)
-- =====================================================================================
local BIND_M416     = 4     -- Mouse 4                   (5.56 AR - Meta) [V7]
local BIND_AUG      = 104   -- LCTRL + Mouse 4          (5.56 AR - High RPM) [V7]
local BIND_SCAR_L   = 204   -- LALT + Mouse 4           (5.56 AR - Stable) [V7]
local BIND_G36C     = 304   -- RCTRL + Mouse 4          (5.56 AR - Low Recoil) [V7]
local BIND_QBZ      = 404   -- RALT + Mouse 4           (5.56 AR - Sanhok) [V7]
local BIND_M249     = 504   -- ScrollLock + Mouse 4     (5.56 LMG - 150-rd) [V7]
local BIND_FAMAS    = 604   -- RSHIFT + Mouse 4         (5.56 AR - 900 RPM Crate) [V7]
local BIND_MINI14   = 704   -- LCTRL + LALT + LSHIFT + Mouse 4 (5.56 DMR - 990 m/s)
local BIND_MK12     = 804   -- LCTRL + LSHIFT + Mouse 4 (5.56 DMR - Bipod)
local BIND_QBU      = 904   -- LALT + LSHIFT + Mouse 4  (5.56 DMR - Sanhok)
local BIND_M16A4    = 1004  -- RCTRL + RALT + Mouse 4   (5.56 Burst AR)
local BIND_MACRO_OFF_4 = 1104 -- RALT + RSHIFT + Mouse 4 (Master Macro OFF / Standby)

-- =====================================================================================
-- 5-SERIES: 7.62mm WEAPONS & EXTENDED ARs (ALL ASSIGNED TO MOUSE 5)
-- =====================================================================================
local BIND_BERRYL   = 5     -- Mouse 5                   (7.62 AR - Meta Monster) [V7]
local BIND_AKM      = 105   -- LCTRL + Mouse 5          (7.62 AR - Heavy Punch) [V7]
local BIND_GROZA    = 205   -- LALT + Mouse 5           (7.62 AR - Crate Beast) [V7]
local BIND_K2       = 305   -- RCTRL + Mouse 5          (5.56 AR - Taego) [V7]
local BIND_ACE32    = 405   -- RALT + Mouse 5           (7.62 AR - Controllable) [V7]
local BIND_MG3      = 505   -- ScrollLock + Mouse 5     (7.62 LMG - 990 RPM Crate) [V7]
local BIND_DMR      = 605   -- RSHIFT + Mouse 5         (Universal DMR Tap Assist) [V7]
local BIND_SKS      = 705   -- LCTRL + LALT + LSHIFT + Mouse 5 (7.62 DMR - Full Attachment)
local BIND_SLR      = 805   -- LCTRL + LSHIFT + Mouse 5 (7.62 DMR - Heavy Punch)
local BIND_DRAGUNOV = 905   -- LALT + LSHIFT + Mouse 5  (7.62 DMR - 10.0 Kick SVD)
local BIND_MK14     = 1005  -- RCTRL + RALT + Mouse 5   (7.62 DMR - Auto/Semi Crate)
local BIND_MUTANT   = 1105  -- RALT + RSHIFT + Mouse 5  (7.62 Burst AR - 2-rd)
local BIND_RPD      = 1205  -- RCTRL + RSHIFT + Mouse 5 (7.62 LMG - 750 RPM)

-- =====================================================================================
-- 6-SERIES: SMGs, SPECIALS & STANDBY (ALL ASSIGNED TO MOUSE 6)
-- =====================================================================================
local BIND_MP5K     = 6     -- Mouse 6                   (9mm SMG - Versatile) [V7]
local BIND_VECTOR   = 106   -- LCTRL + Mouse 6          (9mm SMG - 1100 RPM) [V7]
local BIND_UMP45    = 206   -- LALT + Mouse 6           (9mm SMG - Laser) [V7]
local BIND_JS9      = 306   -- RCTRL + Mouse 6          (9mm SMG - Rondo) [V7]
local BIND_UZI      = 406   -- RALT + Mouse 6           (9mm SMG - 1250 RPM) [V7]
local BIND_P90      = 506   -- ScrollLock + Mouse 6     (5.7mm SMG - Crate Laser) [V7]
local BIND_MP9      = 606   -- RSHIFT + Mouse 6         (9mm SMG - Suppressed) [V7]
local BIND_TOMMY    = 706   -- LCTRL + LALT + LSHIFT + Mouse 6 (.45 ACP SMG - Drum)
local BIND_VSS      = 806   -- LCTRL + LSHIFT + Mouse 6 (9mm DMR - Subsonic Suppressed)
local BIND_DMR_GEN  = 906   -- LALT + LSHIFT + Mouse 6  (Universal DMR Tap Assist)
local BIND_MACRO_OFF_6 = 1006 -- RCTRL + RALT + Mouse 6 (Master Macro OFF / Standby)
local BIND_MACRO_OFF= 1106  -- RALT + RSHIFT + Mouse 6  (Master Macro OFF / Standby)

-- LOGITECH G KEYBOARDS (OPTIONAL G-KEY BINDINGS)
-- Maps G1 to G12 keys directly to weapons for Logitech G-Keyboard owners.
local KeyboardBinds = {
    [1] = BIND_M416,     -- G1  -> M416
    [2] = BIND_BERRYL,   -- G2  -> Beryl M762
    [3] = BIND_MINI14,   -- G3  -> Mini 14
    [4] = BIND_SLR,      -- G4  -> SLR
    [5] = BIND_AUG,      -- G5  -> AUG
    [6] = BIND_AKM,      -- G6  -> AKM
    [7] = BIND_SKS,      -- G7  -> SKS
    [8] = BIND_DRAGUNOV, -- G8  -> Dragunov
    [9] = BIND_MP5K,     -- G9  -> MP5K
    [10]= BIND_VECTOR,   -- G10 -> Vector
    [11]= BIND_M249,     -- G11 -> M249
    [12]= BIND_MACRO_OFF,-- G12 -> Macro Off
}

-------------------------------------------------------------------------------------------------------------------------
-- [4] WEAPON DATABASE & RECOIL CURVES (DATA-MINED FROM PUBGINTEL)
-------------------------------------------------------------------------------------------------------------------------

local function GenerateBaseSpray(start_v, peak_v, end_v, ticks)
    local curve = {}
    local ramp_ticks = math.floor(ticks * 0.25)
    local settle_ticks = math.floor(ticks * 0.50)
    
    for i = 1, ticks do
        if i <= ramp_ticks then
            local progress = i / ramp_ticks
            curve[i] = start_v + (peak_v - start_v) * progress
        elseif i <= settle_ticks then
            local progress = (i - ramp_ticks) / (settle_ticks - ramp_ticks)
            curve[i] = peak_v - (peak_v - end_v) * (progress * 0.4)
        else
            curve[i] = end_v
        end
    end
    return curve
end

-- Generates smooth horizontal micro-bias curves.
-- • Ticks 1 to 8 (~first 4-5 shots): 0.0 dead-center to allow flawless opening headshot acquisition.
-- • Ticks 9 to 20: Progressive linear ramp-in of the micro-bias without sudden jerky steps.
-- • Ticks 21+: Sustained smooth micro-bias without square-wave oscillations.
local function GenerateHorizontalBias(bias_strength, ticks)
    local curve = {}
    bias_strength = bias_strength or 0.0
    if math.abs(bias_strength) < 0.001 then
        for i = 1, ticks do
            curve[i] = 0.0
        end
        return curve
    end
    for i = 1, ticks do
        if i <= 8 then
            curve[i] = 0.0
        elseif i <= 20 then
            local progress = (i - 8) / 12
            curve[i] = bias_strength * progress
        else
            curve[i] = bias_strength
        end
    end
    return curve
end

local Weapons = {
    -- ASSAULT RIFLES (PUBGIntel Calibrated - Extended ~6s Active Spray Curves)
    [BIND_M416] = {
        name = "M416", type = "AUTO", caliber = "5.56", rpm = 700, tick_ms = 17,
        v_curve = GenerateBaseSpray(9.0, 12.0, 13.5, 350),
        h_curve = GenerateHorizontalBias(WeaponTuner.M416.h_bias, 350),
        tuner = WeaponTuner.M416
    },
    [BIND_BERRYL] = {
        name = "Beryl M762", type = "AUTO", caliber = "7.62", rpm = 700, tick_ms = 17,
        v_curve = GenerateBaseSpray(12.5, 17.5, 19.0, 350),
        h_curve = GenerateHorizontalBias(WeaponTuner.BERRYL.h_bias, 350),
        tuner = WeaponTuner.BERRYL
    },
    [BIND_AKM] = {
        name = "AKM", type = "AUTO", caliber = "7.62", rpm = 600, tick_ms = 20,
        v_curve = GenerateBaseSpray(13.0, 17.0, 18.5, 320),
        h_curve = GenerateHorizontalBias(WeaponTuner.AKM.h_bias, 320),
        tuner = WeaponTuner.AKM
    },
    [BIND_AUG] = {
        name = "AUG", type = "AUTO", caliber = "5.56", rpm = 750, tick_ms = 16,
        v_curve = GenerateBaseSpray(9.0, 12.0, 13.5, 350),
        h_curve = GenerateHorizontalBias(WeaponTuner.AUG.h_bias, 350),
        tuner = WeaponTuner.AUG
    },
    [BIND_ACE32] = {
        name = "ACE32", type = "AUTO", caliber = "7.62", rpm = 680, tick_ms = 17,
        v_curve = GenerateBaseSpray(12.0, 16.5, 18.0, 350),
        h_curve = GenerateHorizontalBias(WeaponTuner.ACE32.h_bias, 350),
        tuner = WeaponTuner.ACE32
    },
    [BIND_SCAR_L] = {
        name = "SCAR-L", type = "AUTO", caliber = "5.56", rpm = 625, tick_ms = 19,
        v_curve = GenerateBaseSpray(8.2, 11.0, 12.5, 320),
        h_curve = GenerateHorizontalBias(WeaponTuner.SCAR_L.h_bias, 320),
        tuner = WeaponTuner.SCAR_L
    },
    [BIND_QBZ] = {
        name = "QBZ", type = "AUTO", caliber = "5.56", rpm = 650, tick_ms = 18,
        v_curve = GenerateBaseSpray(8.5, 11.5, 13.0, 320),
        h_curve = GenerateHorizontalBias(WeaponTuner.QBZ.h_bias, 320),
        tuner = WeaponTuner.QBZ
    },
    [BIND_G36C] = {
        name = "G36C", type = "AUTO", caliber = "5.56", rpm = 650, tick_ms = 18,
        v_curve = GenerateBaseSpray(8.0, 10.8, 12.2, 320),
        h_curve = GenerateHorizontalBias(WeaponTuner.G36C.h_bias, 320),
        tuner = WeaponTuner.G36C
    },
    [BIND_K2] = {
        name = "K2", type = "AUTO", caliber = "5.56", rpm = 700, tick_ms = 17,
        v_curve = GenerateBaseSpray(9.0, 12.0, 13.5, 350),
        h_curve = GenerateHorizontalBias(WeaponTuner.K2.h_bias, 350),
        tuner = WeaponTuner.K2
    },
    [BIND_GROZA] = {
        name = "GROZA", type = "AUTO", caliber = "7.62", rpm = 750, tick_ms = 16,
        v_curve = GenerateBaseSpray(13.0, 18.0, 20.0, 350),
        h_curve = GenerateHorizontalBias(WeaponTuner.GROZA.h_bias, 350),
        tuner = WeaponTuner.GROZA
    },
    [BIND_FAMAS] = {
        name = "FAMAS", type = "AUTO", caliber = "5.56", rpm = 900, tick_ms = 13,
        v_curve = GenerateBaseSpray(9.5, 12.5, 14.0, 400),
        h_curve = GenerateHorizontalBias(WeaponTuner.FAMAS.h_bias, 400),
        tuner = WeaponTuner.FAMAS
    },
    [BIND_MUTANT] = {
        name = "Mk47 Mutant", type = "BURST", caliber = "7.62", rpm = 600, burst_count = 2,
        v_curve = { 14.0, 17.5 },
        h_curve = { 0.0, 0.0 },
        tuner = WeaponTuner.MUTANT
    },
    [BIND_M16A4] = {
        name = "M16A4", type = "BURST", caliber = "5.56", rpm = 800, burst_count = 3,
        v_curve = { 9.0, 11.5, 13.5 },
        h_curve = { 0.0, 0.0, 0.0 },
        tuner = WeaponTuner.M16A4
    },

    -- SUBMACHINE GUNS (Pure Vertical Lasers - Extended ~5s Active Spray Curves)
    [BIND_UMP45] = {
        name = "UMP45", type = "AUTO", caliber = "9mm", rpm = 650, tick_ms = 18,
        v_curve = GenerateBaseSpray(6.5, 8.5, 9.8, 320),
        h_curve = GenerateHorizontalBias(WeaponTuner.UMP45.h_bias, 320),
        tuner = WeaponTuner.UMP45
    },
    [BIND_VECTOR] = {
        name = "Vector", type = "AUTO", caliber = "9mm", rpm = 1100, tick_ms = 11,
        v_curve = GenerateBaseSpray(7.5, 10.2, 11.5, 400),
        h_curve = GenerateHorizontalBias(WeaponTuner.VECTOR.h_bias, 400),
        tuner = WeaponTuner.VECTOR
    },
    [BIND_UZI] = {
        name = "Micro UZI", type = "AUTO", caliber = "9mm", rpm = 1250, tick_ms = 10,
        v_curve = GenerateBaseSpray(7.0, 9.4, 10.8, 450),
        h_curve = GenerateHorizontalBias(WeaponTuner.UZI.h_bias, 450),
        tuner = WeaponTuner.UZI
    },
    [BIND_MP5K] = {
        name = "MP5K", type = "AUTO", caliber = "9mm", rpm = 900, tick_ms = 13,
        v_curve = GenerateBaseSpray(7.2, 9.8, 11.2, 350),
        h_curve = GenerateHorizontalBias(WeaponTuner.MP5K.h_bias, 350),
        tuner = WeaponTuner.MP5K
    },
    [BIND_TOMMY] = {
        name = "Tommy Gun", type = "AUTO", caliber = ".45", rpm = 700, tick_ms = 17,
        v_curve = GenerateBaseSpray(7.8, 10.5, 11.8, 350),
        h_curve = GenerateHorizontalBias(WeaponTuner.TOMMY.h_bias, 350),
        tuner = WeaponTuner.TOMMY
    },
    [BIND_P90] = {
        name = "P90", type = "AUTO", caliber = "5.7mm", rpm = 1000, tick_ms = 12,
        v_curve = GenerateBaseSpray(7.2, 9.8, 11.2, 400),
        h_curve = GenerateHorizontalBias(WeaponTuner.P90.h_bias, 400),
        tuner = WeaponTuner.P90
    },
    [BIND_MP9] = {
        name = "MP9", type = "AUTO", caliber = "9mm", rpm = 1000, tick_ms = 12,
        v_curve = GenerateBaseSpray(7.0, 9.4, 10.8, 400),
        h_curve = GenerateHorizontalBias(WeaponTuner.MP9.h_bias, 400),
        tuner = WeaponTuner.MP9
    },
    [BIND_JS9] = {
        name = "JS9", type = "AUTO", caliber = "9mm", rpm = 900, tick_ms = 13,
        v_curve = GenerateBaseSpray(7.2, 9.6, 11.0, 350),
        h_curve = GenerateHorizontalBias(WeaponTuner.JS9.h_bias, 350),
        tuner = WeaponTuner.JS9
    },

    -- LIGHT MACHINE GUNS (Tamed Pull & Bipod Profiles - Extended ~8s Active Spray Curves)
    [BIND_M249] = {
        name = "M249", type = "AUTO", caliber = "5.56", rpm = 800, tick_ms = 15,
        v_curve = GenerateBaseSpray(9.2, 13.0, 15.0, 550),
        h_curve = GenerateHorizontalBias(WeaponTuner.M249.h_bias, 550),
        tuner = WeaponTuner.M249
    },
    [BIND_MG3] = {
        name = "MG3", type = "AUTO", caliber = "7.62", rpm = 990, tick_ms = 12,
        v_curve = GenerateBaseSpray(10.0, 14.0, 16.0, 650),
        h_curve = GenerateHorizontalBias(WeaponTuner.MG3.h_bias, 650),
        tuner = WeaponTuner.MG3
    },
    [BIND_RPD] = {
        name = "RPD", type = "AUTO", caliber = "7.62", rpm = 750, tick_ms = 16,
        v_curve = GenerateBaseSpray(11.0, 15.0, 17.0, 500),
        h_curve = GenerateHorizontalBias(WeaponTuner.RPD.h_bias, 500),
        tuner = WeaponTuner.RPD
    },

    -- DESIGNATED MARKSMAN RIFLES (PUBGIntel Extracted Single-Tap Profiles)
    [BIND_DRAGUNOV] = {
        name = "Dragunov (SVD)", type = "DMR", caliber = "7.62", rpm = 200,
        tuner = WeaponTuner.DRAGUNOV
    },
    [BIND_SLR] = {
        name = "SLR", type = "DMR", caliber = "7.62", rpm = 330,
        tuner = WeaponTuner.SLR
    },
    [BIND_SKS] = {
        name = "SKS", type = "DMR", caliber = "7.62", rpm = 330,
        tuner = WeaponTuner.SKS
    },
    [BIND_MK14] = {
        name = "Mk14 EBR", type = "DMR", caliber = "7.62", rpm = 350,
        tuner = WeaponTuner.MK14
    },
    [BIND_MINI14] = {
        name = "Mini 14", type = "DMR", caliber = "5.56", rpm = 350,
        tuner = WeaponTuner.MINI14
    },
    [BIND_MK12] = {
        name = "Mk12", type = "DMR", caliber = "5.56", rpm = 350,
        tuner = WeaponTuner.MK12
    },
    [BIND_QBU] = {
        name = "QBU", type = "DMR", caliber = "5.56", rpm = 350,
        tuner = WeaponTuner.QBU
    },
    [BIND_VSS] = {
        name = "VSS Vintorez", type = "DMR", caliber = "9mm", rpm = 700,
        tuner = WeaponTuner.VSS
    },
    [BIND_DMR_GEN] = {
        name = "DMR Generic", type = "DMR", caliber = "Universal", rpm = 330,
        tuner = WeaponTuner.DMR_GEN
    },
    [BIND_DMR] = {
        name = "DMR Generic", type = "DMR", caliber = "Universal", rpm = 330,
        tuner = WeaponTuner.DMR_GEN
    },
}

-------------------------------------------------------------------------------------------------------------------------
-- [5] RECOIL CORE ENGINE (SUB-PIXEL PRECISION & ZERO-LAG EXECUTION)
-------------------------------------------------------------------------------------------------------------------------

local recoil_active = false
local current_weapon_id = nil
local current_weapon = nil

-- Sub-pixel remainder accumulators
local remainder_x = 0
local remainder_y = 0

-- Spray memory & state trackers
local spray_tick_count = 0
local saved_spray_tick_count = 0
local last_tick_time = 0
local last_valid_y = 0

local function LogMessage(msg)
    if ENABLE_LOGGING then
        OutputLogMessage(msg .. "\n")
    end
end

local function ResetSprayState()
    remainder_x = 0
    remainder_y = 0
    spray_tick_count = 0
    saved_spray_tick_count = 0
    last_tick_time = 0
    last_valid_y = 0
end

-- Precision Sub-Pixel Movement Execution
local function ApplySubPixelMove(delta_x, delta_y)
    local target_x = remainder_x + delta_x
    local target_y = remainder_y + delta_y
    local int_x = math.floor(target_x + 0.5)
    local int_y = math.floor(target_y + 0.5)
    
    remainder_x = target_x - int_x
    remainder_y = target_y - int_y

    if int_x ~= 0 or int_y ~= 0 then
        MoveMouseRelative(int_x, int_y)
    end
end

-- Calculates real-time stance and attachment multipliers based on global user toggles
local function GetRecoilModifiers(tuner)
    -- 1. Crouch Mode Evaluation
    local stance_mult
    if EnableCrouchMode and IsModifierPressed("lctrl") then
        stance_mult = tuner.crouch or (tuner.stand and (tuner.stand * 0.80)) or 0.80
    else
        stance_mult = tuner.stand or 1.00
    end

    -- 2. Hold-Breath / Scoped Steady-Aim Evaluation
    if EnableHoldBreath and IsModifierPressed("lshift") then
        stance_mult = stance_mult * 0.90
    end

    -- 3. Attachments Evaluation
    local att_mult = 1.00
    if EnableAttachments then
        if AttachmentsMode == "ALWAYS" or (AttachmentsMode == "NUMLOCK" and IsKeyLockOn("numlock")) then
            att_mult = tuner.att_scale or 0.78
        end
    end

    return stance_mult, att_mult
end

-- Master Auto-Recoil Routine (Laser Spray Engine with Transparent Horizontal Micro-Bias)
local function ExecuteAutoRecoil(w)
    local now = GetRunningTime()
    local time_gap = now - last_tick_time

    -- Burst Memory & Spray Transfer Handling
    if time_gap > 200 then
        if time_gap <= 380 and saved_spray_tick_count <= 40 then
            spray_tick_count = saved_spray_tick_count -- Resume burst
        elseif time_gap <= 380 and saved_spray_tick_count > 40 then
            spray_tick_count = 6 -- Spray transfer soft reset
        else
            spray_tick_count = 0 -- Full reset
        end
    end

    local tick_ms = w.tick_ms or 17
    local v_curve = w.v_curve
    local h_curve = w.h_curve
    local max_ticks = #v_curve

    repeat
        local step_start_time = GetRunningTime()
        spray_tick_count = spray_tick_count + 1
        saved_spray_tick_count = spray_tick_count

        -- 1. Determine Real-time Stance & Attachment Multipliers
        local stance_mult, att_mult = GetRecoilModifiers(w.tuner)

        -- 2. Refined Laser Spray S-Curve Progressive Decay Multiplier
        local decay_mult
        if spray_tick_count <= 2 then
            decay_mult = 0.36
        elseif spray_tick_count <= 6 then
            decay_mult = 0.44
        elseif spray_tick_count <= 12 then
            decay_mult = 0.50
        elseif spray_tick_count <= 40 then
            local fade = (spray_tick_count - 12) / 28
            decay_mult = 0.50 - (fade * 0.18)
        else
            decay_mult = 0.32 -- Rock-solid sustained spray floor (maintains solid pull indefinitely)
        end

        -- 3. Calculate Raw Pull from Curve or Extended Hold
        local raw_v = 0
        local raw_h = 0

        if spray_tick_count <= max_ticks then
            raw_v = v_curve[spray_tick_count] or v_curve[max_ticks]
            raw_h = (h_curve and h_curve[spray_tick_count]) or (w.tuner.h_bias or 0)
            last_valid_y = raw_v
        else
            -- Extended Continuous Hold: Maintain 100% full recoil pull indefinitely!
            raw_v = last_valid_y
            raw_h = (w.tuner.h_bias or 0)
        end

        -- 4. Caliber Tuning
        if w.caliber == "7.62" then
            raw_v = raw_v * 0.96
        elseif w.caliber == "9mm" or w.caliber == ".45" then
            raw_v = raw_v * 0.92
        end

        -- 5. Vertical Recoil Pull Scaling
        local final_v = raw_v * stance_mult * att_mult * decay_mult * SensSetting

        -- 6. Horizontal Micro-Bias Scaling (Zero Friction / Fully Transparent to Hand Movement)
        -- Applies subtle sub-pixel stabilization without ping-pong springs or oscillating jitter.
        local final_h = 0
        if HorizontalStrength > 0 and math.abs(raw_h) > 0.001 then
            final_h = raw_h * stance_mult * att_mult * decay_mult * SensSetting * HorizontalStrength
        end

        -- 7. Apply Sub-Pixel Movement
        ApplySubPixelMove(final_h, final_v)

        -- 8. Precision Timing Sleep
        local elapsed = GetRunningTime() - step_start_time
        local remaining_sleep = tick_ms - elapsed
        if remaining_sleep > 0 then
            Sleep(remaining_sleep)
        else
            Sleep(1)
        end

        last_tick_time = GetRunningTime()

        -- Break immediately when LMB is released
        if not IsMouseButtonPressed(1) then
            break
        end

        -- If ClickMode 3, stop immediately when RMB (ADS - Button 2) is released
        if ClickMode == 3 and not IsMouseButtonPressed(2) then
            break
        end

    until not IsMouseButtonPressed(1)
end

-- Master DMR Tap-Assist & Auto-Cycle Routine
local function ExecuteDMRRecoil(w)
    local t = w.tuner
    local pull = t.pull or 26
    local h_pull = (t.h_pull or 0) * HorizontalStrength
    local steps = t.steps or 4
    local sleep_per_step = t.sleep or 8
    local inter_shot_delay = t.delay or 180

    -- Stance & Attachment Multipliers
    local stance_mult, att_mult = GetRecoilModifiers(t)
    local final_pull = pull * stance_mult * att_mult * SensSetting
    local final_h = h_pull * stance_mult * att_mult * SensSetting
    local step_v = final_pull / steps
    local step_h = final_h / steps

    -- Smooth sub-pixel recoil compensation for a single shot
    local function CompensateSingleShot()
        for s = 1, steps do
            ApplySubPixelMove(step_h, step_v)
            Sleep(sleep_per_step)
        end
    end

    -- 1. Single-Tap Assist Mode: Only compensate the single physical click
    if not DMR_AUTO_TAP then
        CompensateSingleShot()
        return
    end

    -- =========================================================================
    -- AUTO-TAP RAPID FIRE MODE (Hold LMB to auto-cycle rapid shots at max RPM)
    -- Native Hardware Mouse Pulsing: Zero keyboard binds or secondary keys required.
    -- =========================================================================
    local recoil_duration = steps * sleep_per_step
    local cooldown = inter_shot_delay - 25 - recoil_duration
    if cooldown < 15 then cooldown = 15 end

    local shot_index = 0

    while IsMouseButtonPressed(1) do
        if ClickMode == 3 and not IsMouseButtonPressed(2) then break end

        shot_index = shot_index + 1

        -- Shot 1 is initiated by the player physically pressing LMB.
        -- Hold for 25ms to let PUBG register the hit, then explicitly release the trigger
        -- so the game's semi-automatic firing pin and bolt reset.
        -- For subsequent shots (Shot 2+), pulse the trigger down then up.
        if shot_index > 1 then
            PressMouseButton(1)
            Sleep(25)
            ReleaseMouseButton(1)
        else
            Sleep(25)
            ReleaseMouseButton(1)
        end

        -- Dynamically re-evaluate stance (crouch/stand) and attachment modifiers mid-spray
        stance_mult, att_mult = GetRecoilModifiers(t)
        final_pull = pull * stance_mult * att_mult * SensSetting
        final_h = h_pull * stance_mult * att_mult * SensSetting
        step_v = final_pull / steps
        step_h = final_h / steps

        -- Smoothly apply sub-pixel recoil pull-down for this shot
        CompensateSingleShot()

        -- Break immediately if the player released LMB during the recoil pull
        if not IsMouseButtonPressed(1) then break end

        -- Cooldown spacing to match the weapon's maximum calibrated semi-auto RPM
        Sleep(cooldown)
    end

    -- Ensure clean mouse state upon release
    ReleaseMouseButton(1)
end

-- Master Burst-Fire Routine (Mutant, M16A4)
local function ExecuteBurstRecoil(w)
    local count = w.burst_count or 2
    local v_curve = w.v_curve
    local h_curve = w.h_curve
    local t = w.tuner
    local inter_bullet_delay = w.rpm == 800 and 24 or 32
    local burst_steps = 3
    local step_sleep = math.floor(inter_bullet_delay / burst_steps)
    local cycle_cooldown = w.rpm == 800 and 110 or 125

    -- Stance & Attachment Multipliers
    local stance_mult, att_mult = GetRecoilModifiers(t)

    -- Smooth sub-pixel recoil compensation for a single burst
    local function CompensateBurst()
        for i = 1, count do
            local raw_v = (v_curve and v_curve[i]) or 12.0
            local raw_h = (h_curve and h_curve[i]) or (t.h_bias or 0)
            local total_v = raw_v * stance_mult * att_mult * SensSetting * 0.35
            local total_h = raw_h * stance_mult * att_mult * SensSetting * HorizontalStrength * 0.35
            local sub_v = total_v / burst_steps
            local sub_h = total_h / burst_steps

            for s = 1, burst_steps do
                ApplySubPixelMove(sub_h, sub_v)
                Sleep(step_sleep)
            end
        end
    end

    local burst_index = 0

    while IsMouseButtonPressed(1) do
        if ClickMode == 3 and not IsMouseButtonPressed(2) then break end

        burst_index = burst_index + 1

        -- Re-evaluate stance dynamically mid-spray
        stance_mult, att_mult = GetRecoilModifiers(t)

        -- Burst 1 was triggered by physical LMB. Release to reset burst sear.
        -- Bursts 2+ are pulsed natively.
        if burst_index > 1 then
            PressMouseButton(1)
            Sleep(30)
            ReleaseMouseButton(1)
        else
            Sleep(30)
            ReleaseMouseButton(1)
        end

        CompensateBurst()

        if not IsMouseButtonPressed(1) then break end

        Sleep(cycle_cooldown)
    end

    ReleaseMouseButton(1)
end

-------------------------------------------------------------------------------------------------------------------------
-- [6] WEAPON SELECTION & MODIFIER RESOLVER
-------------------------------------------------------------------------------------------------------------------------

local function GetModifierOffset()
    local is_lctrl  = IsModifierPressed("lctrl")
    local is_lalt   = IsModifierPressed("lalt")
    local is_lshift = IsModifierPressed("lshift")
    local is_rctrl  = IsModifierPressed("rctrl")
    local is_ralt   = IsModifierPressed("ralt")
    local is_rshift = IsModifierPressed("rshift")
    local is_scroll = IsKeyLockOn("scrolllock")

    -- Check multi-modifier tiers first (3-key check before 2-key checks)
    if is_lctrl and is_lalt and is_lshift then
        return 700  -- Tier 7 (LCTRL + LALT + LSHIFT - isolated from RALT/AltGr)
    elseif is_rctrl and is_rshift then
        return 1200 -- Tier 12
    elseif is_ralt and is_rshift then
        return 1100 -- Tier 11
    elseif is_rctrl and is_ralt then
        return 1000 -- Tier 10
    elseif is_lalt and is_lshift then
        return 900  -- Tier 9
    elseif is_lctrl and is_lshift then
        return 800  -- Tier 8
    -- Check single-modifier tiers (RSHIFT strictly; Left Shift alone is reserved for in-game sprint)
    elseif is_rshift then
        return 600  -- Tier 6 (RSHIFT only - FAMAS / DMR / MP9) [V7]
    elseif is_scroll then
        return 500  -- Tier 5 (ScrollLock - M249 / MG3 / P90) [V7]
    elseif is_ralt then
        return 400  -- Tier 4 (RALT / AltGr - QBZ / ACE32 / UZI) [V7]
    elseif is_rctrl then
        return 300  -- Tier 3 (RCTRL - G36C / K2 / JS9) [V7]
    elseif is_lalt then
        return 200  -- Tier 2 (LALT - SCAR-L / GROZA / UMP45) [V7]
    elseif is_lctrl then
        return 100  -- Tier 1 (LCTRL - AUG / AKM / VECTOR) [V7]
    end

    return 0 -- Tier 0 (No modifier)
end

local function SetMacroActive(enable)
    recoil_active = enable
    if SYNC_CAPSLOCK_LED then
        if enable then
            if not IsKeyLockOn("capslock") then
                PressAndReleaseKey("capslock")
            end
        else
            if IsKeyLockOn("capslock") then
                PressAndReleaseKey("capslock")
            end
        end
    end
end

local function SelectWeapon(bind_id)
    if bind_id == BIND_MACRO_OFF or bind_id == BIND_MACRO_OFF_4 or bind_id == BIND_MACRO_OFF_6 then
        SetMacroActive(false)
        current_weapon = nil
        current_weapon_id = nil
        ResetSprayState()
        LogMessage("[Dino-V8] MACRO DEACTIVATED (STANDBY)")
        return
    end

    local found = Weapons[bind_id]
    if not found then return end

    -- Check if macro is currently active
    if recoil_active then
        if WEAPON_TOGGLE_MODE == "ANY" or current_weapon_id == bind_id then
            -- Turn macro OFF (Standby)
            SetMacroActive(false)
            current_weapon = nil
            current_weapon_id = nil
            ResetSprayState()
            LogMessage("[Dino-V8] MACRO TURNED OFF (STANDBY) — Press any weapon button to activate")
            return
        end
    end

    -- Turn macro ON or switch weapon
    current_weapon_id = bind_id
    current_weapon = found
    SetMacroActive(true)
    ResetSprayState()
    LogMessage(string.format("[Dino-V8] ON: %s | %s | %d RPM | H-Bias: %.3f", 
        found.name, found.type, found.rpm or 0, found.tuner and found.tuner.h_bias or 0))
end

-------------------------------------------------------------------------------------------------------------------------
-- [7] MAIN ONEVENT DISPATCHER (ZERO-DELAY FAST PATH)
-------------------------------------------------------------------------------------------------------------------------

EnablePrimaryMouseButtonEvents(true)

local is_firing = false

function OnEvent(event, arg)
    -- MOUSE BUTTON EVENTS
    if event == "MOUSE_BUTTON_PRESSED" then
        -- Fast Path: Left Mouse Button Firing (Button 1)
        if arg == 1 then
            if is_firing then return end
            local can_fire = recoil_active and current_weapon
            if REQUIRE_CAPSLOCK_FOR_FIRE then
                can_fire = can_fire and IsKeyLockOn("capslock")
            end

            if can_fire then
                -- Check ClickMode requirement (ClickMode 3 requires RMB / Button 2 held)
                if ClickMode == 1 or (ClickMode == 3 and IsMouseButtonPressed(2)) then
                    is_firing = true
                    if current_weapon.type == "AUTO" then
                        ExecuteAutoRecoil(current_weapon)
                    elseif current_weapon.type == "DMR" then
                        ExecuteDMRRecoil(current_weapon)
                    elseif current_weapon.type == "BURST" then
                        ExecuteBurstRecoil(current_weapon)
                    end
                    is_firing = false
                end
            end
            return
        end

        -- Direct Macro Off Button (e.g. Middle Click - Button 3)
        if DIRECT_MACRO_OFF_BUTTON and arg == DIRECT_MACRO_OFF_BUTTON then
            SetMacroActive(false)
            current_weapon = nil
            current_weapon_id = nil
            ResetSprayState()
            LogMessage("[Dino-V8] MACRO TURNED OFF (STANDBY) — Direct button pressed")
            return
        end

        -- Weapon Selection Combos (Buttons 4, 5, 6, 7, 8, etc.)
        if arg >= 4 then
            local mod_offset = GetModifierOffset()
            local bind_id = arg + mod_offset
            SelectWeapon(bind_id)
        end

    -- LOGITECH G-KEYBOARD DIRECT SELECTION (G1..G12)
    elseif event == "G_PRESSED" then
        if KeyboardBinds and KeyboardBinds[arg] then
            SelectWeapon(KeyboardBinds[arg])
        end

    elseif event == "MOUSE_BUTTON_RELEASED" then
        if arg == 1 then
            -- Reset tick timers when releasing fire
            last_tick_time = GetRunningTime()
        end

    -- PROFILE ACTIVATION / DEACTIVATION
    elseif event == "PROFILE_ACTIVATED" then
        EnablePrimaryMouseButtonEvents(true)
        ResetSprayState()
        LogMessage("---------------------------------------------------------")
        LogMessage("  DINO V8 INITIALIZED — 800 DPI CALIBRATED (H-BIAS ACTIVE)")
        LogMessage(string.format("  Toggles: Crouch=%s | Breath=%s | Attachments=%s (%s)",
            EnableCrouchMode and "ON" or "OFF",
            EnableHoldBreath and "ON" or "OFF",
            EnableAttachments and "ON" or "OFF",
            AttachmentsMode))
        LogMessage(string.format("  DMR Auto-Tap: %s (Native Mouse Pulsing)",
            DMR_AUTO_TAP and "ON" or "OFF"))
        LogMessage(string.format("  H-Strength: %.2f (Transparent Manual Tracking)", HorizontalStrength))
        LogMessage("  Press any weapon key combo to activate.")
        LogMessage("---------------------------------------------------------")

    elseif event == "PROFILE_DEACTIVATED" then
        SetMacroActive(false)
        ResetSprayState()
    end
end

-------------------------------------------------------------------------------------------------------------------------
-- END OF DINO V8 SCRIPT
-------------------------------------------------------------------------------------------------------------------------
