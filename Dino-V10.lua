-------------------------------------------------------------------------------------------------------------------------
--                __
--               / _)      ____  _             
--      _.----._/ /       |  _ \(_)_ __   ___  
--     /         /        | | | | | '_ \ / _ \ 
--  __/ (  | (  |         | |_| | | | | | (_) |
-- /__.-'|_|--|_|         |____/|_|_| |_|\___/ 
--
-- DINO V10 - UE4 CUBIC HERMITE SPLINE BALLISTIC ENGINE FOR PUBG PC (LOGITECH G HUB)
-------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------
-- [1] USER CONFIGURATION
-------------------------------------------------------------------------------------------------------------------------

local MOUSE_DPI = 800
local SensSetting = 1.00

-- UE4 Spline Recovery-Damping Exponent (0.25 = flatter late spray, 0.32 = calibrated PUBG equilibrium, 0.50 = steep climb)
local SplineResponseGamma = 0.32

-- Feature Toggles
local EnableCrouchMode  = true
local EnableProneMode   = false          -- Set true if you bind Prone to a modifier or hold LALT+LCTRL while prone
local EnableHoldBreath  = true
local EnableAttachments = true
local AttachmentsMode   = "NUMLOCK"      -- "NUMLOCK" or "ALWAYS"

-- Operation Modes
local ClickMode          = 1             -- 1 = LMB only, 3 = RMB + LMB
local DMR_AUTO_TAP       = true          -- True = Auto-cycling rapid single-taps on hold
local HorizontalStrength = 0.60          -- Master horizontal bias multiplier (0.00 to 1.00)

-- State Management
local WEAPON_TOGGLE_MODE        = "ANY"  -- "ANY" = any weapon button toggles standby, "SAME" = current button only
local DIRECT_MACRO_OFF_BUTTON   = nil    -- Instant standby mouse button (e.g. 3 for Middle Mouse Click, or nil)
local SYNC_CAPSLOCK_LED         = true   -- Sync physical CapsLock LED with macro active/standby state
local REQUIRE_CAPSLOCK_FOR_FIRE = false  -- Hardware safety: true requires CapsLock ON to pull recoil
local ENABLE_LOGGING            = true   -- Print telemetry and weapon profiles to G Hub console

-------------------------------------------------------------------------------------------------------------------------
-- [2] WEAPON TUNING PROFILES (USER SENSITIVITY ANCHORED )
-------------------------------------------------------------------------------------------------------------------------
-- • stand       : Standing vertical multiplier calibrated to user's 800 DPI / SensSetting = 1.00 baseline
-- • crouch      : Exact PUBG game-file RecoilModifier_Crouch ratio (0.88 Beryl/Mutant, 0.86 AUG, 0.84 ARs, 0.85 SMGs, 0.56 LMGs)
-- • prone       : Exact PUBG game-file RecoilModifier_Prone ratio
-- • att_scale   : Vertical attachment multiplier from ATTACH_POOLS (Compensator + Foregrip + Stock)
-- • att_h_scale : Horizontal attachment multiplier from ATTACH_POOLS
-- • h_bias      : Directional counter-drift micro-bias (+ = counters Left gun drift, - = counters Right gun drift)
-------------------------------------------------------------------------------------------------------------------------

local WeaponTuner = {
    -- Assault Rifles (5.56mm & 7.62mm)
    M416     = { stand = 2.85, crouch = 2.39, prone = 1.99, att_scale = 0.74, att_h_scale = 0.82, h_bias =  0.035 },
    BERRYL   = { stand = 3.48, crouch = 3.06, prone = 2.44, att_scale = 0.73, att_h_scale = 0.84, h_bias =  0.060, is_762 = true },
    AKM      = { stand = 3.20, crouch = 2.69, prone = 2.24, att_scale = 0.85, att_h_scale = 0.90, h_bias =  0.075, is_762 = true },
    AUG      = { stand = 3.16, crouch = 2.72, prone = 2.21, att_scale = 0.74, att_h_scale = 0.84, h_bias =  0.025 },
    ACE32    = { stand = 3.00, crouch = 2.52, prone = 2.10, att_scale = 0.73, att_h_scale = 0.82, h_bias =  0.050, is_762 = true },
    SCAR_L   = { stand = 2.69, crouch = 2.26, prone = 1.88, att_scale = 0.74, att_h_scale = 0.84, h_bias = -0.035 },
    QBZ      = { stand = 2.79, crouch = 2.34, prone = 1.95, att_scale = 0.74, att_h_scale = 0.84, h_bias = -0.032 },
    G36C     = { stand = 2.85, crouch = 2.39, prone = 1.99, att_scale = 0.74, att_h_scale = 0.84, h_bias = -0.035 },
    K2       = { stand = 2.85, crouch = 2.39, prone = 1.99, att_scale = 0.85, att_h_scale = 0.90, h_bias =  0.025 },
    GROZA    = { stand = 3.25, crouch = 2.73, prone = 2.27, att_scale = 1.00, att_h_scale = 1.00, h_bias =  0.040, is_762 = true },
    FAMAS    = { stand = 2.68, crouch = 2.25, prone = 1.88, att_scale = 0.85, att_h_scale = 0.90, h_bias =  0.030 },
    MUTANT   = { stand = 3.44, crouch = 3.03, prone = 2.41, att_scale = 0.73, att_h_scale = 0.82, h_bias =  0.000, is_762 = true },
    M16A4    = { stand = 2.69, crouch = 2.26, prone = 1.88, att_scale = 0.78, att_h_scale = 0.85, h_bias =  0.000 },

    -- Submachine Guns (9mm, .45 ACP, 5.7mm)
    UMP45    = { stand = 2.38, crouch = 2.02, prone = 1.67, att_scale = 0.72, att_h_scale = 0.75, h_bias = -0.025, is_smg = true },
    VECTOR   = { stand = 2.78, crouch = 2.36, prone = 1.95, att_scale = 0.72, att_h_scale = 0.75, h_bias = -0.018, is_smg = true },
    UZI      = { stand = 2.11, crouch = 1.79, prone = 1.48, att_scale = 1.00, att_h_scale = 0.80, h_bias =  0.000, is_smg = true },
    MP5K     = { stand = 2.36, crouch = 2.01, prone = 1.65, att_scale = 0.68, att_h_scale = 0.75, h_bias = -0.018, is_smg = true },
    TOMMY    = { stand = 2.42, crouch = 2.06, prone = 1.69, att_scale = 0.85, att_h_scale = 1.00, h_bias = -0.010, is_smg = true },
    P90      = { stand = 2.31, crouch = 1.96, prone = 1.62, att_scale = 1.00, att_h_scale = 1.00, h_bias =  0.000, is_smg = true },
    MP9      = { stand = 2.26, crouch = 1.92, prone = 1.58, att_scale = 1.00, att_h_scale = 0.80, h_bias =  0.000, is_smg = true },
    JS9      = { stand = 2.31, crouch = 1.96, prone = 1.62, att_scale = 0.80, att_h_scale = 0.75, h_bias = -0.015, is_smg = true },

    -- Light Machine Guns (Update 44.1 Calibrated with Full-Magazine Sustained Relief)
    M249     = { stand = 1.84, crouch = 1.02, prone = 0.45, att_scale = 0.86, att_h_scale = 0.92, h_bias =  0.000 },
    MG3      = { stand = 1.76, crouch = 0.88, prone = 0.48, att_scale = 1.00, att_h_scale = 1.00, h_bias =  0.000, is_762 = true },
    RPD      = { stand = 2.04, crouch = 1.18, prone = 0.48, att_scale = 0.82, att_h_scale = 0.92, h_bias =  0.000, is_762 = true },

    -- Designated Marksman Rifles (Per-Shot Spline Escalation & Frame-Safe Refire Cadence)
    DRAGUNOV = { stand = 1.00, crouch = 0.75, prone = 0.55, att_scale = 0.72, att_h_scale = 0.72, pull = 36, h_pull =  0.0, steps = 4, sleep = 10, delay = 345, ramp = 0.12 },
    SLR      = { stand = 1.00, crouch = 0.75, prone = 0.55, att_scale = 0.72, att_h_scale = 0.72, pull = 30, h_pull =  0.0, steps = 4, sleep = 8,  delay = 195, ramp = 0.08 },
    SKS      = { stand = 1.00, crouch = 0.75, prone = 0.55, att_scale = 0.76, att_h_scale = 0.72, pull = 26, h_pull =  0.0, steps = 4, sleep = 8,  delay = 195, ramp = 0.07 },
    MK14     = { stand = 4.10, crouch = 3.07, prone = 2.15, att_scale = 0.72, att_h_scale = 0.72, h_bias =  0.045, is_762 = true },
    MINI14   = { stand = 1.00, crouch = 0.75, prone = 0.55, att_scale = 0.80, att_h_scale = 0.90, pull = 17, h_pull =  0.0, steps = 4, sleep = 8,  delay = 195, ramp = 0.07 },
    MK12     = { stand = 1.00, crouch = 0.75, prone = 0.20, att_scale = 0.70, att_h_scale = 0.90, pull = 16, h_pull =  0.0, steps = 4, sleep = 8,  delay = 195, ramp = 0.08 },
    VSS      = { stand = 2.25, crouch = 1.69, prone = 1.25, att_scale = 0.85, att_h_scale = 0.85, h_bias =  0.000, is_smg = true },
}

-------------------------------------------------------------------------------------------------------------------------
-- [3] KEYBINDINGS (100% MUSCLE-MEMORY PARITY WITH DINO V9)
-------------------------------------------------------------------------------------------------------------------------

-- MODIFIER TIER TABLE:
-- TIER  0 (+0)    : None (Mouse Button only)
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

-- 4-Series: Mouse Button 4 (5.56mm Arsenal)
local BIND_M416        = 4     -- Mouse 4
local BIND_AUG         = 104   -- LCTRL + Mouse 4
local BIND_SCAR_L      = 204   -- LALT + Mouse 4
local BIND_G36C        = 304   -- RCTRL + Mouse 4
local BIND_QBZ         = 404   -- RALT + Mouse 4
local BIND_FAMAS       = 604   -- RSHIFT + Mouse 4
local BIND_MK12        = 804   -- LCTRL + LSHIFT + Mouse 4
local BIND_MINI14      = 904   -- LALT + LSHIFT + Mouse 4
local BIND_M16A4       = 1004  -- RCTRL + RALT + Mouse 4
local BIND_M249        = 1104  -- RALT + RSHIFT + Mouse 4

-- 5-Series: Mouse Button 5 (7.62mm Arsenal)
local BIND_BERRYL      = 5     -- Mouse 5
local BIND_AKM         = 105   -- LCTRL + Mouse 5
local BIND_GROZA       = 205   -- LALT + Mouse 5
local BIND_K2          = 305   -- RCTRL + Mouse 5
local BIND_ACE32       = 405   -- RALT + Mouse 5
local BIND_MG3         = 605   -- RSHIFT + Mouse 5
local BIND_SKS         = 705   -- LCTRL + LALT + LSHIFT + Mouse 5
local BIND_SLR         = 805   -- LCTRL + LSHIFT + Mouse 5
local BIND_DRAGUNOV    = 905   -- LALT + LSHIFT + Mouse 5
local BIND_MK14        = 1005  -- RCTRL + RALT + Mouse 5
local BIND_MUTANT      = 1105  -- RALT + RSHIFT + Mouse 5
local BIND_RPD         = 1205  -- RCTRL + RSHIFT + Mouse 5

-- 6-Series: Mouse Button 6 (SMGs, VSS)
local BIND_MP5K        = 6     -- Mouse 6
local BIND_VECTOR      = 106   -- LCTRL + Mouse 6
local BIND_UMP45       = 206   -- LALT + Mouse 6
local BIND_JS9         = 306   -- RCTRL + Mouse 6
local BIND_UZI         = 406   -- RALT + Mouse 6
local BIND_MP9         = 606   -- RSHIFT + Mouse 6
local BIND_VSS         = 806   -- LCTRL + LSHIFT + Mouse 6
local BIND_TOMMY       = 906   -- LALT + LSHIFT + Mouse 6
local BIND_P90         = 1006  -- RCTRL + RALT + Mouse 6

-- Logitech G Keyboard Direct Mappings
local KeyboardBinds = {
    [1]  = BIND_M416,
    [2]  = BIND_BERRYL,
    [3]  = BIND_MINI14,
    [4]  = BIND_SLR,
    [5]  = BIND_AUG,
    [6]  = BIND_AKM,
    [7]  = BIND_SKS,
    [8]  = BIND_DRAGUNOV,
    [9]  = BIND_MP5K,
    [10] = BIND_VECTOR,
    [11] = BIND_M249,
    [12] = 0, -- Standby / Macro Off
}

-------------------------------------------------------------------------------------------------------------------------
-- [4]  UE4 CUBIC HERMITE SPLINE ENGINE & WEAPON DATABASE
-------------------------------------------------------------------------------------------------------------------------
-- Format per keyframe: { t = time_sec, v = value, at = arrive_tangent, lt = leave_tangent, m = "C" (Cubic) or "L" (Linear) }
-------------------------------------------------------------------------------------------------------------------------

local UE4Splines = {
    HK416 = {
        v = {
            { t = 0.000000, v = 0.360000, at = 0.469369, lt = 0.469371, m = "C" },
            { t = 1.400000, v = 0.800000, at = 0.220453, lt = 0.220453, m = "C" },
            { t = 3.081069, v = 1.039231, at = 0.042967, lt = 0.042967, m = "C" },
            { t = 3.303680, v = 1.142027, at = 0.582808, lt = 0.582805, m = "C" },
        },
        h = {
            { t = 0.000000, v = 0.095000, at = 0.126818, lt = 0.126819, m = "C" },
            { t = 0.500000, v = 0.152000, at = 0.116250, lt = 0.116252, m = "C" },
            { t = 2.300000, v = 0.351500, at = 0.307059, lt = 0.307058, m = "C" },
        }
    },
    BERRYL = {
        v = {
            { t = 0.000000, v = 0.600000, at = 0.609046, lt = 0.609047, m = "C" },
            { t = 0.500000, v = 0.900000, at = 0.163138, lt = 0.163133, m = "C" },
            { t = 1.600000, v = 1.050000, at = 0.218275, lt = 0.218272, m = "C" },
            { t = 2.600000, v = 1.200000, at = 0.270874, lt = 0.270879, m = "C" },
            { t = 3.100000, v = 1.350000, at = 0.550641, lt = 0.550645, m = "C" },
        },
        h = {
            { t = 0.000000, v = 0.160000, at = 0.042324, lt = 0.042320, m = "C" },
            { t = 0.800000, v = 0.190000, at = 0.024616, lt = 0.024619, m = "C" },
            { t = 2.100000, v = 0.320000, at = 0.069822, lt = 0.069823, m = "C" },
            { t = 3.100000, v = 0.360000, at = 0.078461, lt = 0.078458, m = "C" },
        }
    },
    AKM = {
        v = {
            { t = 0.000000, v = 0.550000, at = 0.609046, lt = 0.609047, m = "C" },
            { t = 0.500000, v = 0.800000, at = 0.065880, lt = 0.065877, m = "C" },
            { t = 1.500000, v = 1.000000, at = 0.302177, lt = 0.302176, m = "C" },
            { t = 2.600000, v = 1.300000, at = 0.319824, lt = 0.319828, m = "C" },
            { t = 2.750000, v = 1.400000, at = 1.019866, lt = 1.019874, m = "C" },
        },
        h = {
            { t = 0.000000, v = 0.130000, at = 0.178297, lt = 0.178294, m = "C" },
            { t = 0.800000, v = 0.180000, at = 0.067885, lt = 0.067889, m = "C" },
            { t = 2.400000, v = 0.400000, at = 0.347659, lt = 0.347654, m = "C" },
        }
    },
    AUG = {
        v = {
            { t = 0.000000, v = 0.415000, at = 0.667796, lt = 0.000000, m = "C" },
            { t = 1.500000, v = 0.896000, at = 0.265278, lt = 0.265278, m = "C" },
            { t = 2.880000, v = 1.179000, at = 0.374614, lt = 0.374612, m = "C" },
            { t = 3.300000, v = 1.268000, at = 0.000000, lt = 0.000000, m = "C" },
        },
        h = {
            { t = 0.000000, v = 0.088400, at = 0.013708, lt = 0.013708, m = "C" },
            { t = 0.500000, v = 0.120600, at = 0.122615, lt = 0.122611, m = "C" },
            { t = 2.430000, v = 0.307800, at = 0.060488, lt = 0.060484, m = "C" },
        }
    },
    ACE32 = {
        v = {
            { t = 0.000000, v = 0.550000, at = 0.609046, lt = 0.609047, m = "C" },
            { t = 0.500000, v = 0.800000, at = 0.163138, lt = 0.163133, m = "C" },
            { t = 1.600000, v = 1.000000, at = 0.218275, lt = 0.218272, m = "C" },
            { t = 2.600000, v = 1.100000, at = 0.270874, lt = 0.270879, m = "C" },
            { t = 3.100000, v = 1.300000, at = 0.550641, lt = 0.550645, m = "C" },
            { t = 3.300000, v = 1.350000, at = 0.000000, lt = 0.000000, m = "L" },
        },
        h = {
            { t = 0.000000, v = 0.140000, at = 0.042324, lt = 0.042320, m = "C" },
            { t = 0.800000, v = 0.190000, at = 0.024616, lt = 0.024619, m = "C" },
            { t = 2.100000, v = 0.310000, at = 0.069822, lt = 0.069823, m = "C" },
            { t = 3.100000, v = 0.350000, at = 0.078461, lt = 0.078458, m = "C" },
        }
    },
    SCAR_L = {
        v = {
            { t = 0.000000, v = 0.307000, at = 0.011103, lt = 0.011101, m = "C" },
            { t = 1.500000, v = 0.720000, at = 0.293188, lt = 0.293187, m = "C" },
            { t = 2.500000, v = 0.960000, at = 0.085447, lt = 0.253723, m = "C" },
            { t = 2.800000, v = 1.104000, at = 1.080392, lt = 1.080389, m = "C" },
        },
        h = {
            { t = 0.000000, v = 0.086000, at = 0.000000, lt = 0.000000, m = "C" },
            { t = 0.250000, v = 0.134000, at = 0.164094, lt = 0.164090, m = "C" },
            { t = 2.250000, v = 0.307000, at = 0.264509, lt = 0.264515, m = "C" },
        }
    },
    QBZ = {
        v = {
            { t = 0.000000, v = 0.330000, at = 0.011103, lt = 0.011101, m = "C" },
            { t = 1.344499, v = 0.733899, at = 0.231691, lt = 0.231688, m = "C" },
            { t = 2.500000, v = 0.950000, at = 0.085447, lt = 0.253723, m = "C" },
            { t = 2.800000, v = 1.200000, at = 0.090848, lt = 0.090848, m = "C" },
        },
        h = {
            { t = 0.000000, v = 0.080000, at = 0.000000, lt = 0.000000, m = "C" },
            { t = 0.699315, v = 0.160000, at = 0.113050, lt = 0.113048, m = "C" },
            { t = 2.400000, v = 0.310000, at = 0.264509, lt = 0.264515, m = "C" },
        }
    },
    G36C = {
        v = {
            { t = 0.000000, v = 0.360000, at = 0.469369, lt = 0.469371, m = "C" },
            { t = 1.400000, v = 0.800000, at = 0.220453, lt = 0.220453, m = "C" },
            { t = 3.081069, v = 1.039231, at = 0.042967, lt = 0.042967, m = "C" },
            { t = 3.460272, v = 1.200000, at = 0.000000, lt = 0.000000, m = "L" },
        },
        h = {
            { t = 0.000000, v = 0.100000, at = 0.126818, lt = 0.126819, m = "C" },
            { t = 0.500000, v = 0.160000, at = 0.116250, lt = 0.116252, m = "C" },
            { t = 2.300000, v = 0.350000, at = 0.307059, lt = 0.307058, m = "C" },
        }
    },
    K2 = {
        v = {
            { t = 0.000000, v = 0.360000, at = 0.386960, lt = 0.386962, m = "C" },
            { t = 1.400000, v = 0.800000, at = 0.282288, lt = 0.282289, m = "C" },
            { t = 3.081069, v = 0.950000, at = 0.042967, lt = 0.042967, m = "C" },
            { t = 3.303680, v = 1.100000, at = 0.582808, lt = 0.582805, m = "C" },
        },
        h = {
            { t = 0.000000, v = 0.100000, at = 0.126818, lt = 0.126819, m = "C" },
            { t = 0.500000, v = 0.150000, at = 0.116250, lt = 0.116252, m = "C" },
            { t = 2.450000, v = 0.305000, at = 0.239371, lt = 0.239370, m = "C" },
        }
    },
    FAMAS = {
        v = {
            { t = 0.000000, v = 0.250000, at = 0.667796, lt = 0.000000, m = "C" },
            { t = 1.500000, v = 0.650000, at = 0.225694, lt = 0.225694, m = "C" },
            { t = 2.880000, v = 0.900000, at = 0.374614, lt = 0.374612, m = "C" },
        },
        h = {
            { t = 0.000000, v = 0.080000, at = 0.013708, lt = 0.013708, m = "C" },
            { t = 0.500000, v = 0.110000, at = 0.122615, lt = 0.122611, m = "C" },
            { t = 2.430000, v = 0.250000, at = 0.060488, lt = 0.060484, m = "C" },
        }
    },
    UMP9 = {
        v = {
            { t = 0.000000, v = 0.500000, at = 0.000000, lt = 0.000000, m = "L" },
            { t = 0.982115, v = 0.750000, at = 0.000000, lt = 0.000000, m = "L" },
            { t = 2.125708, v = 0.900000, at = 0.132463, lt = 0.132463, m = "C" },
            { t = 2.502299, v = 0.951368, at = 0.153502, lt = 0.153502, m = "C" },
        },
        h = {
            { t = 0.000000, v = 0.119000, at = 0.000000, lt = 0.000000, m = "C" },
            { t = 0.800000, v = 0.143000, at = 0.053868, lt = 0.053870, m = "C" },
            { t = 2.500000, v = 0.171000, at = 0.009128, lt = 0.009128, m = "C" },
        }
    },
    VECTOR = {
        v = {
            { t = 0.000000, v = 0.230437, at = 0.656208, lt = 0.656207, m = "C" },
            { t = 1.000000, v = 0.500000, at = 0.184782, lt = 0.184782, m = "C" },
            { t = 2.000000, v = 0.600000, at = 0.071202, lt = 0.071200, m = "C" },
            { t = 3.100000, v = 0.850000, at = 0.734846, lt = 0.734844, m = "C" },
        },
        h = {
            { t = 0.000000, v = 0.130000, at = 0.034230, lt = 0.034231, m = "C" },
            { t = 0.683354, v = 0.160000, at = 0.021646, lt = 0.021646, m = "C" },
            { t = 1.816106, v = 0.180000, at = 0.008722, lt = 0.008722, m = "C" },
            { t = 3.000000, v = 0.260000, at = 0.135740, lt = 0.135740, m = "C" },
        }
    },
    UZI = {
        v = {
            { t = 0.000000, v = 0.213000, at = 0.000000, lt = 0.000000, m = "C" },
            { t = 0.500000, v = 0.283000, at = 0.265042, lt = 0.265041, m = "C" },
            { t = 2.125708, v = 0.595000, at = 0.000000, lt = 0.000000, m = "L" },
            { t = 3.460272, v = 0.723000, at = 0.000000, lt = 0.000000, m = "L" },
        },
        h = {
            { t = 0.000000, v = 0.108000, at = 0.000000, lt = 0.000000, m = "C" },
            { t = 0.250000, v = 0.144000, at = 0.066392, lt = 0.066393, m = "C" },
            { t = 2.000000, v = 0.270000, at = 0.291373, lt = 0.291371, m = "C" },
        }
    },
    MP5K = {
        v = {
            { t = 0.000000, v = 0.523000, at = 0.000000, lt = 0.000000, m = "L" },
            { t = 0.982115, v = 0.665000, at = 0.135714, lt = 0.135714, m = "C" },
            { t = 2.100000, v = 0.808000, at = 0.094158, lt = 0.094158, m = "C" },
            { t = 3.000000, v = 0.855000, at = 0.002385, lt = 0.002385, m = "C" },
        },
        h = {
            { t = 0.000000, v = 0.112000, at = 0.000000, lt = 0.000000, m = "C" },
            { t = 0.800000, v = 0.121000, at = 0.023377, lt = 0.023379, m = "C" },
            { t = 2.000000, v = 0.140000, at = 0.008969, lt = 0.008966, m = "C" },
            { t = 2.500000, v = 0.167000, at = 0.093573, lt = 0.093572, m = "C" },
            { t = 3.000000, v = 0.205000, at = -0.024949, lt = -0.024948, m = "C" },
        }
    },
    THOMPSON = {
        v = {
            { t = 0.000000, v = 0.372000, at = 0.435002, lt = 0.435001, m = "C" },
            { t = 1.000000, v = 0.651000, at = 0.070529, lt = 0.070527, m = "C" },
            { t = 2.000000, v = 0.744000, at = 0.177143, lt = 0.177143, m = "C" },
            { t = 3.100000, v = 1.023000, at = 0.022881, lt = 0.022881, m = "C" },
        },
        h = {
            { t = 0.000000, v = 0.067000, at = 0.109294, lt = 0.109295, m = "C" },
            { t = 0.800000, v = 0.143000, at = 0.029497, lt = 0.029497, m = "C" },
            { t = 3.000000, v = 0.200000, at = 0.042704, lt = 0.126099, m = "C" },
        }
    },
    MP9 = {
        v = {
            { t = 0.000000, v = 0.420000, at = 0.043400, lt = 0.043398, m = "C" },
            { t = 1.000000, v = 0.500000, at = 0.078562, lt = 0.078561, m = "C" },
            { t = 2.200000, v = 0.630000, at = 0.087714, lt = 0.087706, m = "C" },
            { t = 2.950000, v = 0.450000, at = 0.001888, lt = 0.001888, m = "C" },
        },
        h = {
            { t = 0.000000, v = 0.110000, at = 0.000000, lt = 0.000000, m = "C" },
            { t = 1.000000, v = 0.130000, at = 0.022345, lt = 0.022345, m = "C" },
            { t = 2.000000, v = 0.155000, at = 0.009128, lt = 0.009128, m = "L" },
            { t = 2.850000, v = 0.180000, at = 0.000000, lt = 0.000000, m = "L" },
            { t = 3.000000, v = 0.220000, at = 0.000000, lt = 0.000000, m = "L" },
        }
    },
    JS9 = {
        v = {
            { t = 0.000000, v = 0.496000, at = 0.043400, lt = 0.043398, m = "C" },
            { t = 1.000024, v = 0.597000, at = 0.078562, lt = 0.078561, m = "C" },
            { t = 2.490517, v = 0.751000, at = 0.102629, lt = 0.102623, m = "C" },
            { t = 3.483880, v = 0.897000, at = 0.001888, lt = 0.001888, m = "C" },
        },
        h = {
            { t = 0.000000, v = 0.127000, at = 0.000000, lt = 0.000000, m = "C" },
            { t = 1.000000, v = 0.150000, at = 0.022345, lt = 0.022345, m = "C" },
            { t = 2.085920, v = 0.231000, at = 0.009128, lt = 0.009128, m = "L" },
            { t = 3.229953, v = 0.272000, at = 0.000000, lt = 0.000000, m = "L" },
        }
    },
    M249 = {
        v = {
            { t = 0.000000, v = 0.330000, at = 0.000000, lt = 0.000000, m = "C" },
            { t = 1.202519, v = 0.459696, at = 0.239286, lt = 0.239286, m = "C" },
            { t = 2.800000, v = 1.000000, at = 0.000000, lt = 0.000000, m = "L" },
            { t = 3.483150, v = 0.700000, at = 0.000000, lt = 0.000000, m = "L" },
        },
        h = {
            { t = 0.000000, v = 0.120000, at = 0.000000, lt = 0.000000, m = "L" },
            { t = 1.400000, v = 0.200000, at = 0.064331, lt = 0.064331, m = "C" },
            { t = 2.750000, v = 0.400000, at = 0.462949, lt = 0.462948, m = "C" },
            { t = 3.300000, v = 0.660000, at = 0.000000, lt = 0.000000, m = "L" },
        }
    },
    MG3 = {
        v = {
            { t = 0.000000, v = 0.330000, at = 0.000000, lt = 0.000000, m = "C" },
            { t = 1.202519, v = 0.459696, at = 0.218605, lt = 0.218605, m = "C" },
            { t = 2.150000, v = 0.800000, at = 0.000000, lt = 0.000000, m = "L" },
            { t = 2.900000, v = 0.600000, at = 0.000000, lt = 0.000000, m = "L" },
            { t = 3.100000, v = 0.450000, at = 0.000000, lt = 0.000000, m = "L" },
        },
        h = {
            { t = 0.000000, v = 0.114000, at = 0.000000, lt = 0.000000, m = "L" },
            { t = 1.200000, v = 0.142500, at = 0.064331, lt = 0.064331, m = "C" },
            { t = 2.200000, v = 0.304000, at = 0.323774, lt = 0.323775, m = "L" },
            { t = 3.000000, v = 0.589000, at = 0.000000, lt = 0.000000, m = "L" },
        }
    },
    RPD = {
        v = {
            { t = 0.000000, v = 0.360000, at = 0.000000, lt = 0.000000, m = "C" },
            { t = 1.202519, v = 0.510000, at = 0.333953, lt = 0.333953, m = "C" },
            { t = 2.150000, v = 1.078000, at = 0.000000, lt = 0.000000, m = "L" },
            { t = 3.100000, v = 0.709091, at = 0.000000, lt = 0.000000, m = "L" },
        },
        h = {
            { t = 0.000000, v = 0.118000, at = 0.000000, lt = 0.000000, m = "L" },
            { t = 1.200000, v = 0.199000, at = 0.064331, lt = 0.064331, m = "C" },
            { t = 2.200000, v = 0.400000, at = 0.323774, lt = 0.323775, m = "L" },
            { t = 3.000000, v = 0.644286, at = 0.000000, lt = 0.000000, m = "L" },
        }
    },
}

-- Exact UE4 Cubic Bezier / Hermite evaluator (matches  ps_bez & ps_sample)
local function CubicBezier(p0, p1, p2, p3, a)
    local p01  = p0  + (p1  - p0)  * a
    local p12  = p1  + (p2  - p1)  * a
    local p23  = p2  + (p3  - p2)  * a
    local p012 = p01 + (p12 - p01) * a
    local p123 = p12 + (p23 - p12) * a
    return p012 + (p123 - p012) * a
end

local function SampleCubicSpline(keys, t)
    if not keys or #keys == 0 then return 0.0 end
    if t <= keys[1].t then return keys[1].v end
    local n = #keys
    local last = keys[n]
    if t >= last.t then return last.v end
    local i = 1
    while i < n and keys[i + 1].t <= t do
        i = i + 1
    end
    local k1 = keys[i]
    local k2 = keys[i + 1]
    local diff = k2.t - k1.t
    if diff <= 0 then return k1.v end
    local a = (t - k1.t) / diff
    if k1.m == "L" then
        return k1.v + (k2.v - k1.v) * a
    end
    return CubicBezier(k1.v, k1.v + k1.lt * diff / 3.0, k2.v - k2.at * diff / 3.0, k2.v, a)
end

-- Generates the exact recovery-damped UE4 spline spray curve with RecoilSpeed_Vertical (rsv) opening lock
local function GenerateSplineSpray(spline_name, base_scale, rsv, tick_ms, ticks)
    local curve = {}
    local sp = UE4Splines[spline_name]
    local v_keys = sp and sp.v
    local v0 = (v_keys and v_keys[1] and v_keys[1].v) or 0.36
    local gamma = SplineResponseGamma or 0.32
    rsv = rsv or 12.0
    local is_lmg = (spline_name == "M249" or spline_name == "MG3" or spline_name == "RPD")

    for i = 1, ticks do
        local t = (i * tick_ms) / 1000.0
        local sp_v = SampleCubicSpline(v_keys, t)
        local ratio = sp_v / v0
        if ratio < 0.1 then ratio = 0.1 end
        local damped_ratio = ratio ^ gamma
        -- First-shot RecoilSpeed_Vertical (rsv) camera rise envelope (prevents downward hitch on Shot 1)
        local opening_env = 1.0 - 0.26 * math.exp(-rsv * t * 1.60)
        -- Sustained LMG belt recovery relief (prevents late-magazine downward over-pull across 75-150 rounds)
        local lmg_relief = 1.0
        if is_lmg and t > 2.00 then
            local progress = math.min((t - 2.00) / 3.20, 1.0)
            lmg_relief = 1.0 - (0.14 * progress)
        end
        curve[i] = base_scale * damped_ratio * opening_env * lmg_relief
    end
    return curve
end

-- Generates progressive horizontal bias curve scaled along the weapon's UE4 horizontal spline h(t)
local function GenerateSplineHorizontalBias(spline_name, bias_strength, tick_ms, ticks, lock_ticks)
    local curve = {}
    bias_strength = bias_strength or 0.0
    if math.abs(bias_strength) < 0.001 then
        for i = 1, ticks do
            curve[i] = 0.0
        end
        return curve
    end

    local sp = UE4Splines[spline_name]
    local h_keys = sp and sp.h
    local h0 = (h_keys and h_keys[1] and h_keys[1].v) or 0.10
    local h_ref = SampleCubicSpline(h_keys, 1.25)
    if h_ref <= 0 then h_ref = h0 end

    lock_ticks = lock_ticks or 8
    local ramp_span = 12

    for i = 1, ticks do
        if i <= lock_ticks then
            -- Opening headshot lock (first ~130ms dead-center)
            curve[i] = 0.0
        else
            local t = (i * tick_ms) / 1000.0
            local sp_h = SampleCubicSpline(h_keys, t)
            local h_scale = (sp_h / h_ref) ^ 0.35
            if i <= (lock_ticks + ramp_span) then
                local progress = (i - lock_ticks) / ramp_span
                curve[i] = bias_strength * progress * h_scale
            else
                curve[i] = bias_strength * h_scale
            end
        end
    end
    return curve
end

local Weapons = {
    -- Assault Rifles ( UE4 Spline Calibrated)
    [BIND_M416] = {
        name = "M416", type = "AUTO", caliber = "5.56", rpm = 700, tbs_ms = 85.7, tick_ms = 17, rsv = 12.0,
        v_curve = GenerateSplineSpray("HK416", 3.794, 12.0, 17, 360),
        h_curve = GenerateSplineHorizontalBias("HK416", WeaponTuner.M416.h_bias, 17, 360, 8),
        tuner = WeaponTuner.M416
    },
    [BIND_BERRYL] = {
        name = "Beryl M762", type = "AUTO", caliber = "7.62", rpm = 700, tbs_ms = 85.7, tick_ms = 17, rsv = 16.5,
        v_curve = GenerateSplineSpray("BERRYL", 4.798, 16.5, 17, 360),
        h_curve = GenerateSplineHorizontalBias("BERRYL", WeaponTuner.BERRYL.h_bias, 17, 360, 8),
        tuner = WeaponTuner.BERRYL
    },
    [BIND_AKM] = {
        name = "AKM", type = "AUTO", caliber = "7.62", rpm = 600, tbs_ms = 100.0, tick_ms = 20, rsv = 15.0,
        v_curve = GenerateSplineSpray("AKM", 4.664, 15.0, 20, 320),
        h_curve = GenerateSplineHorizontalBias("AKM", WeaponTuner.AKM.h_bias, 20, 320, 7),
        tuner = WeaponTuner.AKM
    },
    [BIND_AUG] = {
        name = "AUG A3", type = "AUTO", caliber = "5.56", rpm = 720, tbs_ms = 83.3, tick_ms = 17, rsv = 10.0,
        v_curve = GenerateSplineSpray("AUG", 4.385, 10.0, 17, 360),
        h_curve = GenerateSplineHorizontalBias("AUG", WeaponTuner.AUG.h_bias, 17, 360, 9),
        tuner = WeaponTuner.AUG
    },
    [BIND_ACE32] = {
        name = "ACE32", type = "AUTO", caliber = "7.62", rpm = 680, tbs_ms = 88.2, tick_ms = 17, rsv = 15.0,
        v_curve = GenerateSplineSpray("ACE32", 4.443, 15.0, 17, 360),
        h_curve = GenerateSplineHorizontalBias("ACE32", WeaponTuner.ACE32.h_bias, 17, 360, 8),
        tuner = WeaponTuner.ACE32
    },
    [BIND_SCAR_L] = {
        name = "SCAR-L", type = "AUTO", caliber = "5.56", rpm = 650, tbs_ms = 92.3, tick_ms = 18, rsv = 15.0,
        v_curve = GenerateSplineSpray("SCAR_L", 3.348, 15.0, 18, 340),
        h_curve = GenerateSplineHorizontalBias("SCAR_L", WeaponTuner.SCAR_L.h_bias, 18, 340, 8),
        tuner = WeaponTuner.SCAR_L
    },
    [BIND_QBZ] = {
        name = "QBZ95", type = "AUTO", caliber = "5.56", rpm = 650, tbs_ms = 92.3, tick_ms = 18, rsv = 14.0,
        v_curve = GenerateSplineSpray("QBZ", 3.687, 14.0, 18, 340),
        h_curve = GenerateSplineHorizontalBias("QBZ", WeaponTuner.QBZ.h_bias, 18, 340, 8),
        tuner = WeaponTuner.QBZ
    },
    [BIND_G36C] = {
        name = "G36C", type = "AUTO", caliber = "5.56", rpm = 700, tbs_ms = 85.7, tick_ms = 17, rsv = 15.0,
        v_curve = GenerateSplineSpray("G36C", 3.824, 15.0, 17, 360),
        h_curve = GenerateSplineHorizontalBias("G36C", WeaponTuner.G36C.h_bias, 17, 360, 8),
        tuner = WeaponTuner.G36C
    },
    [BIND_K2] = {
        name = "K2", type = "AUTO", caliber = "5.56", rpm = 700, tbs_ms = 85.7, tick_ms = 17, rsv = 13.0,
        v_curve = GenerateSplineSpray("K2", 3.883, 13.0, 17, 360),
        h_curve = GenerateSplineHorizontalBias("K2", WeaponTuner.K2.h_bias, 17, 360, 9),
        tuner = WeaponTuner.K2
    },
    [BIND_GROZA] = {
        name = "Groza", type = "AUTO", caliber = "7.62", rpm = 750, tbs_ms = 80.0, tick_ms = 16, rsv = 14.0,
        v_curve = GenerateSplineSpray("BERRYL", 4.886, 14.0, 16, 360),
        h_curve = GenerateSplineHorizontalBias("BERRYL", WeaponTuner.GROZA.h_bias, 16, 360, 8),
        tuner = WeaponTuner.GROZA
    },
    [BIND_FAMAS] = {
        name = "FAMAS G2", type = "AUTO", caliber = "5.56", rpm = 900, tbs_ms = 66.7, tick_ms = 13, rsv = 10.0,
        v_curve = GenerateSplineSpray("FAMAS", 3.313, 10.0, 13, 420),
        h_curve = GenerateSplineHorizontalBias("FAMAS", WeaponTuner.FAMAS.h_bias, 13, 420, 10),
        tuner = WeaponTuner.FAMAS
    },
    [BIND_MUTANT] = {
        name = "Mk47 Mutant", type = "BURST", caliber = "7.62", rpm = 800, tbs_ms = 75.0, burst_count = 2,
        v_curve = { 13.8, 16.5 },
        h_curve = { 0.0, 0.0 },
        burst_escalation = { 1.00, 1.12, 1.20, 1.25 },
        tuner = WeaponTuner.MUTANT
    },
    [BIND_M16A4] = {
        name = "M16A4", type = "BURST", caliber = "5.56", rpm = 800, tbs_ms = 75.0, burst_count = 3,
        v_curve = { 9.8, 12.0, 13.6 },
        h_curve = { 0.0, 0.0, 0.0 },
        burst_escalation = { 1.00, 1.12, 1.20, 1.26 },
        tuner = WeaponTuner.M16A4
    },

    -- Submachine Guns ( UE4 Spline Calibrated)
    [BIND_UMP45] = {
        name = "UMP45 (UMP9)", type = "AUTO", caliber = "9mm", rpm = 670, tbs_ms = 89.6, tick_ms = 18, rsv = 10.0,
        v_curve = GenerateSplineSpray("UMP9", 3.129, 10.0, 18, 340),
        h_curve = GenerateSplineHorizontalBias("UMP9", WeaponTuner.UMP45.h_bias, 18, 340, 8),
        tuner = WeaponTuner.UMP45
    },
    [BIND_VECTOR] = {
        name = "Vector", type = "AUTO", caliber = "9mm", rpm = 1101, tbs_ms = 54.5, tick_ms = 11, rsv = 15.0,
        v_curve = GenerateSplineSpray("VECTOR", 3.047, 15.0, 11, 420),
        h_curve = GenerateSplineHorizontalBias("VECTOR", WeaponTuner.VECTOR.h_bias, 11, 420, 10),
        tuner = WeaponTuner.VECTOR
    },
    [BIND_UZI] = {
        name = "Micro UZI", type = "AUTO", caliber = "9mm", rpm = 1250, tbs_ms = 48.0, tick_ms = 10, rsv = 15.0,
        v_curve = GenerateSplineSpray("UZI", 2.755, 15.0, 10, 460),
        h_curve = GenerateSplineHorizontalBias("UZI", WeaponTuner.UZI.h_bias, 10, 460, 10),
        tuner = WeaponTuner.UZI
    },
    [BIND_MP5K] = {
        name = "MP5K", type = "AUTO", caliber = "9mm", rpm = 901, tbs_ms = 66.6, tick_ms = 13, rsv = 12.0,
        v_curve = GenerateSplineSpray("MP5K", 3.286, 12.0, 13, 380),
        h_curve = GenerateSplineHorizontalBias("MP5K", WeaponTuner.MP5K.h_bias, 13, 380, 9),
        tuner = WeaponTuner.MP5K
    },
    [BIND_TOMMY] = {
        name = "Tommy Gun", type = "AUTO", caliber = ".45", rpm = 750, tbs_ms = 80.0, tick_ms = 16, rsv = 15.0,
        v_curve = GenerateSplineSpray("THOMPSON", 2.994, 15.0, 16, 380),
        h_curve = GenerateSplineHorizontalBias("THOMPSON", WeaponTuner.TOMMY.h_bias, 16, 380, 9),
        tuner = WeaponTuner.TOMMY
    },
    [BIND_P90] = {
        name = "P90", type = "AUTO", caliber = "5.7mm", rpm = 1000, tbs_ms = 60.0, tick_ms = 12, rsv = 11.0,
        v_curve = GenerateSplineSpray("MP9", 3.313, 11.0, 12, 420),
        h_curve = GenerateSplineHorizontalBias("MP9", WeaponTuner.P90.h_bias, 12, 420, 10),
        tuner = WeaponTuner.P90
    },
    [BIND_MP9] = {
        name = "MP9", type = "AUTO", caliber = "9mm", rpm = 1000, tbs_ms = 60.0, tick_ms = 12, rsv = 11.0,
        v_curve = GenerateSplineSpray("MP9", 3.190, 11.0, 12, 420),
        h_curve = GenerateSplineHorizontalBias("MP9", WeaponTuner.MP9.h_bias, 12, 420, 10),
        tuner = WeaponTuner.MP9
    },
    [BIND_JS9] = {
        name = "JS9", type = "AUTO", caliber = "9mm", rpm = 900, tbs_ms = 66.7, tick_ms = 13, rsv = 11.0,
        v_curve = GenerateSplineSpray("JS9", 3.300, 11.0, 13, 380),
        h_curve = GenerateSplineHorizontalBias("JS9", WeaponTuner.JS9.h_bias, 13, 380, 10),
        tuner = WeaponTuner.JS9
    },

    -- Light Machine Guns (Update 44.1 UE4 Spline Calibrated with Full-Magazine Sustained Relief)
    [BIND_M249] = {
        name = "M249", type = "AUTO", caliber = "5.56", rpm = 800, tbs_ms = 75.0, tick_ms = 15, rsv = 15.0,
        v_curve = GenerateSplineSpray("M249", 3.460, 15.0, 15, 600),
        h_curve = GenerateSplineHorizontalBias("M249", WeaponTuner.M249.h_bias, 15, 600, 10),
        tuner = WeaponTuner.M249
    },
    [BIND_MG3] = {
        name = "MG3", type = "AUTO", caliber = "7.62", rpm = 990, tbs_ms = 60.6, tick_ms = 12, rsv = 16.0,
        v_curve = GenerateSplineSpray("MG3", 2.950, 16.0, 12, 680),
        h_curve = GenerateSplineHorizontalBias("MG3", WeaponTuner.MG3.h_bias, 12, 680, 10),
        tuner = WeaponTuner.MG3
    },
    [BIND_RPD] = {
        name = "RPD", type = "AUTO", caliber = "7.62", rpm = 750, tbs_ms = 80.0, tick_ms = 16, rsv = 15.5,
        v_curve = GenerateSplineSpray("RPD", 3.280, 15.5, 16, 550),
        h_curve = GenerateSplineHorizontalBias("RPD", WeaponTuner.RPD.h_bias, 16, 550, 9),
        tuner = WeaponTuner.RPD
    },

    -- Designated Marksman Rifles ( Per-Shot & Full-Auto Calibrated)
    [BIND_DRAGUNOV] = {
        name = "Dragunov (SVD)", type = "DMR", caliber = "7.62", rpm = 180, tbs_ms = 333.3, max_mag = 25,
        tuner = WeaponTuner.DRAGUNOV
    },
    [BIND_SLR] = {
        name = "SLR", type = "DMR", caliber = "7.62", rpm = 330, tbs_ms = 181.8, max_mag = 25,
        tuner = WeaponTuner.SLR
    },
    [BIND_SKS] = {
        name = "SKS", type = "DMR", caliber = "7.62", rpm = 330, tbs_ms = 181.8, max_mag = 25,
        tuner = WeaponTuner.SKS
    },
    [BIND_MK14] = {
        name = "Mk14 EBR", type = "AUTO", caliber = "7.62", rpm = 670, tbs_ms = 90.0, tick_ms = 15, rsv = 11.5,
        v_curve = GenerateSplineSpray("BERRYL", 5.175, 11.5, 15, 360),
        h_curve = GenerateSplineHorizontalBias("BERRYL", WeaponTuner.MK14.h_bias, 15, 360, 8),
        tuner = WeaponTuner.MK14
    },
    [BIND_MINI14] = {
        name = "Mini 14", type = "DMR", caliber = "5.56", rpm = 330, tbs_ms = 181.8, max_mag = 35,
        tuner = WeaponTuner.MINI14
    },
    [BIND_MK12] = {
        name = "Mk12", type = "DMR", caliber = "5.56", rpm = 330, tbs_ms = 181.8, max_mag = 35,
        tuner = WeaponTuner.MK12
    },
    [BIND_VSS] = {
        name = "VSS Vintorez", type = "AUTO", caliber = "9mm", rpm = 700, tbs_ms = 85.7, tick_ms = 17, rsv = 10.5,
        v_curve = GenerateSplineSpray("UMP9", 3.007, 10.5, 17, 360),
        h_curve = GenerateSplineHorizontalBias("UMP9", WeaponTuner.VSS.h_bias, 17, 360, 8),
        tuner = WeaponTuner.VSS
    },
}

-------------------------------------------------------------------------------------------------------------------------
-- [5] RECOIL CORE ENGINE (PHASE-LOCKED DEADLINE SCHEDULER & SUB-PIXEL INTEGRATOR)
-------------------------------------------------------------------------------------------------------------------------

local recoil_active = false
local current_weapon_id = nil
local current_weapon = nil

local remainder_x = 0.0
local remainder_y = 0.0

local spray_tick_count = 0
local saved_spray_tick_count = 0
local last_tick_time = 0
local last_valid_y = 0.0
local last_macro_end_time = 0
local emergency_off_requested = false

local function LogMessage(msg)
    if ENABLE_LOGGING then
        OutputLogMessage(msg .. "\n")
    end
end

local banner_logged = false

local function LogBanner()
    if not ENABLE_LOGGING or banner_logged then return end
    banner_logged = true
    LogMessage("----------------------------------------------------------------")
    LogMessage("               __")
    LogMessage("              / _)      ____  _             ")
    LogMessage("     _.----._/ /       |  _ \\(_)_ __   ___  ")
    LogMessage("    /         /        | | | | | '_ \\ / _ \\ ")
    LogMessage(" __/ (  | (  |         | |_| | | | | | (_) |")
    LogMessage("/__.-'|_|--|_|         |____/|_|_| |_|\\___/ ")
    LogMessage("")
    LogMessage("[DINO V10] UE4 CUBIC SPLINE BALLISTIC ENGINE FOR PUBG PC")
    LogMessage("----------------------------------------------------------------")
end

local function ResetSprayState()
    remainder_x = 0.0
    remainder_y = 0.0
    spray_tick_count = 0
    saved_spray_tick_count = 0
    last_tick_time = 0
    last_valid_y = 0.0
end

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

-- Helper for ClickMode 3 (Hold RMB + LMB): in G Hub Lua IsMouseButtonPressed(3) is Right Mouse Button
local function IsAimingActive()
    if ClickMode ~= 3 then return true end
    return IsMouseButtonPressed(3) or IsMouseButtonPressed(2)
end

-- Detects if the user pressed a side weapon-toggle button (Mouse 4 / Mouse 5) or Standby button mid-loop
-- so any active firing loop aborts immediately (< 10ms) and switches to Standby.
local function CheckEmergencyInterrupt()
    if IsMouseButtonPressed(4) or IsMouseButtonPressed(5) then
        emergency_off_requested = true
        return true
    end
    if DIRECT_MACRO_OFF_BUTTON and IsMouseButtonPressed(DIRECT_MACRO_OFF_BUTTON) then
        emergency_off_requested = true
        return true
    end
    return false
end

-- Safely cleans up virtual LMB state and re-enables primary button events without self-retriggering OnEvent
local function CleanupAutoTrigger(did_virtual_press)
    if did_virtual_press then
        ReleaseMouseButton(1)
        Sleep(10)
    end
    EnablePrimaryMouseButtonEvents(true)
    last_macro_end_time = GetRunningTime()
end

-- Evaluates real-time Standing / Crouching / Prone & Separate Vertical/Horizontal Attachment Multipliers
local function GetRecoilModifiers(tuner)
    local stance_mult
    if EnableProneMode and IsModifierPressed("lctrl") and IsModifierPressed("lalt") then
        stance_mult = tuner.prone or (tuner.stand and (tuner.stand * 0.70)) or 0.70
    elseif EnableCrouchMode and IsModifierPressed("lctrl") then
        stance_mult = tuner.crouch or (tuner.stand and (tuner.stand * 0.84)) or 0.84
    else
        stance_mult = tuner.stand or 1.00
    end

    if EnableHoldBreath and IsModifierPressed("lshift") then
        stance_mult = stance_mult * 0.90
    end

    local att_v_mult = 1.00
    local att_h_mult = 1.00
    if EnableAttachments then
        if AttachmentsMode == "ALWAYS" or (AttachmentsMode == "NUMLOCK" and IsKeyLockOn("numlock")) then
            att_v_mult = tuner.att_scale or 0.78
            att_h_mult = tuner.att_h_scale or att_v_mult
        end
    end

    return stance_mult, att_v_mult, att_h_mult
end

-- Phase-Locked UE4 Spline Auto-Recoil Engine
local function ExecuteAutoRecoil(w)
    local now = GetRunningTime()
    local time_gap = now - last_tick_time

    if time_gap > 200 then
        if time_gap <= 380 and saved_spray_tick_count <= 40 then
            spray_tick_count = saved_spray_tick_count
        elseif time_gap <= 380 and saved_spray_tick_count > 40 then
            spray_tick_count = 10
        else
            spray_tick_count = 0
            remainder_x = 0.0
            remainder_y = 0.0
        end
    end

    local tick_ms = w.tick_ms or 17
    local v_curve = w.v_curve
    local h_curve = w.h_curve
    local max_ticks = #v_curve

    -- Anchor virtual spray origin and phase-locked deadline clock
    local spray_origin_time = now - (spray_tick_count * tick_ms)
    local next_tick_deadline = now
    local prev_step_time = now - tick_ms

    repeat
        local step_now = GetRunningTime()
        local actual_dt = step_now - prev_step_time
        prev_step_time = step_now

        -- Elapsed-time ratio compensation (absorbs Windows OS scheduler jitter without losing pull)
        local dt_scale = actual_dt / tick_ms
        if dt_scale < 0.75 then
            dt_scale = 0.75
        elseif dt_scale > 1.35 then
            dt_scale = 1.35
        end

        spray_tick_count = spray_tick_count + 1
        saved_spray_tick_count = spray_tick_count

        -- Compute real elapsed time index along the UE4 spline curve
        local elapsed_ms = step_now - spray_origin_time
        local time_tick_idx = math.floor((elapsed_ms / tick_ms) + 0.5)
        if time_tick_idx < 1 then time_tick_idx = 1 end
        local curve_idx = spray_tick_count
        if math.abs(time_tick_idx - spray_tick_count) >= 2 then
            curve_idx = time_tick_idx
        end

        local stance_mult, att_v_mult, att_h_mult = GetRecoilModifiers(w.tuner)

        local raw_v = 0.0
        local raw_h = 0.0

        if curve_idx <= max_ticks then
            raw_v = v_curve[curve_idx] or v_curve[max_ticks]
            raw_h = (h_curve and h_curve[curve_idx]) or (w.tuner.h_bias or 0.0)
            last_valid_y = raw_v
        else
            raw_v = last_valid_y
            raw_h = (h_curve and h_curve[max_ticks]) or (w.tuner.h_bias or 0.0)
        end

        local final_v = raw_v * stance_mult * att_v_mult * SensSetting * dt_scale

        local final_h = 0.0
        if HorizontalStrength > 0 and math.abs(raw_h) > 0.0005 then
            final_h = raw_h * stance_mult * att_h_mult * SensSetting * HorizontalStrength * dt_scale
        end

        ApplySubPixelMove(final_h, final_v)

        -- Phase-locked deadline sleep prevents cumulative timer drift over 30-100 round sprays
        next_tick_deadline = next_tick_deadline + tick_ms
        local after_move_time = GetRunningTime()
        local sleep_ms = next_tick_deadline - after_move_time
        if sleep_ms >= 1 then
            Sleep(sleep_ms)
        else
            next_tick_deadline = after_move_time
            Sleep(1)
        end

        last_tick_time = GetRunningTime()

        if not IsMouseButtonPressed(1) then
            break
        end

        if not IsAimingActive() or CheckEmergencyInterrupt() then
            break
        end

    until not IsMouseButtonPressed(1)

    last_macro_end_time = last_tick_time
end

-- Master DMR Tap-Assist & Rapid Auto-Cycle Engine (with Anti-Echo Event Suppression & Clean Exit Release)
local function ExecuteDMRRecoil(w)
    local t = w.tuner
    local base_pull = t.pull or 26
    local h_pull = (t.h_pull or 0.0) * HorizontalStrength
    local steps = t.steps or 4
    local sleep_per_step = t.sleep or 8
    local inter_shot_delay = t.delay or 195
    local rapid_ramp = t.ramp or 0.08

    local stance_mult, att_v_mult, att_h_mult = GetRecoilModifiers(t)

    local function CompensateSingleShot(shot_mult)
        shot_mult = shot_mult or 1.00
        local final_pull = base_pull * shot_mult * stance_mult * att_v_mult * SensSetting
        local final_h = h_pull * shot_mult * stance_mult * att_h_mult * SensSetting
        local step_v = final_pull / steps
        local step_h = final_h / steps

        for s = 1, steps do
            if CheckEmergencyInterrupt() then return false end
            ApplySubPixelMove(step_h, step_v)
            Sleep(sleep_per_step)
        end
        return true
    end

    if not DMR_AUTO_TAP then
        CompensateSingleShot(1.00)
        last_macro_end_time = GetRunningTime()
        return
    end

    local pulse_ms = 12
    local settle_ms = 6
    local recoil_duration = steps * sleep_per_step
    local first_shot_cooldown = inter_shot_delay - pulse_ms - recoil_duration
    local next_shot_cooldown = inter_shot_delay - pulse_ms - settle_ms - recoil_duration
    if first_shot_cooldown < 15 then first_shot_cooldown = 15 end
    if next_shot_cooldown < 15 then next_shot_cooldown = 15 end

    local shot_index = 0
    -- Supports full 30-round Extended Magazine on 5.56mm DMRs (Mini 14 / Mk12) with headroom
    local max_mag_shots = w.max_mag or 35
    local did_virtual_press = false

    -- Suppress synthetic MOUSE_BUTTON_PRESSED(1) events while pulsing PressMouseButton(1) (as in Dino-V7)
    -- so G Hub never queues a phantom OnEvent("MOUSE_BUTTON_PRESSED", 1) after physical LMB release!
    EnablePrimaryMouseButtonEvents(false)

    while IsMouseButtonPressed(1) and shot_index < max_mag_shots do
        if not IsAimingActive() or CheckEmergencyInterrupt() then break end

        shot_index = shot_index + 1

        if shot_index > 1 then
            if not IsMouseButtonPressed(1) or CheckEmergencyInterrupt() then break end
            ReleaseMouseButton(1)
            Sleep(pulse_ms)
            if CheckEmergencyInterrupt() then
                did_virtual_press = false
                break
            end
            PressMouseButton(1)
            did_virtual_press = true
            Sleep(settle_ms)
        end

        stance_mult, att_v_mult, att_h_mult = GetRecoilModifiers(t)

        -- Progressive DMR rapid-tap escalation from per_shot_recoil_curves.json
        local esc_steps = math.min(shot_index - 1, 3)
        local shot_mult = 1.00 + (esc_steps * rapid_ramp)

        if not CompensateSingleShot(shot_mult) then
            break
        end

        local active_cooldown = (shot_index == 1) and first_shot_cooldown or next_shot_cooldown
        local sleep_cycles = math.floor(active_cooldown / 10)
        local rem_sleep = active_cooldown - (sleep_cycles * 10)
        local released = false
        for c = 1, sleep_cycles do
            if not IsMouseButtonPressed(1) or not IsAimingActive() or CheckEmergencyInterrupt() then
                released = true
                break
            end
            Sleep(10)
        end
        if released then break end
        if rem_sleep > 0 then
            if not IsMouseButtonPressed(1) or not IsAimingActive() or CheckEmergencyInterrupt() then
                break
            end
            Sleep(rem_sleep)
        end
    end

    CleanupAutoTrigger(did_virtual_press)
end

-- Master Burst-Fire Engine (M16A4 3-rd & Mk47 Mutant 2-rd with Anti-Echo Event Suppression)
local function ExecuteBurstRecoil(w)
    local count = w.burst_count or 2
    local v_curve = w.v_curve
    local h_curve = w.h_curve
    local esc_table = w.burst_escalation
    local t = w.tuner

    local burst_steps = 4
    local step_sleep = 12
    local pulse_ms = 12
    local settle_ms = 6
    local cycle_cooldown = (count == 3) and 95 or 110

    local stance_mult, att_v_mult, att_h_mult = GetRecoilModifiers(t)

    local function CompensateBurst(burst_idx)
        local esc_mult = 1.00
        if esc_table then
            esc_mult = esc_table[math.min(burst_idx, #esc_table)] or 1.00
        end

        for i = 1, count do
            local raw_v = (v_curve and v_curve[i]) or 12.0
            local raw_h = (h_curve and h_curve[i]) or (t.h_bias or 0.0)
            local total_v = raw_v * esc_mult * stance_mult * att_v_mult * SensSetting * 0.35
            if (t and t.is_762) or w.caliber == "7.62" then
                total_v = total_v * 0.89
            end
            local total_h = raw_h * esc_mult * stance_mult * att_h_mult * SensSetting * HorizontalStrength * 0.35
            local sub_v = total_v / burst_steps
            local sub_h = total_h / burst_steps

            for s = 1, burst_steps do
                if CheckEmergencyInterrupt() then return false end
                ApplySubPixelMove(sub_h, sub_v)
                Sleep(step_sleep)
            end
        end
        return true
    end

    local burst_index = 0
    local max_bursts = 25
    local did_virtual_press = false

    EnablePrimaryMouseButtonEvents(false)

    while IsMouseButtonPressed(1) and burst_index < max_bursts do
        if not IsAimingActive() or CheckEmergencyInterrupt() then break end

        burst_index = burst_index + 1
        stance_mult, att_v_mult, att_h_mult = GetRecoilModifiers(t)

        if burst_index > 1 then
            if not IsMouseButtonPressed(1) or CheckEmergencyInterrupt() then break end
            ReleaseMouseButton(1)
            Sleep(pulse_ms)
            if CheckEmergencyInterrupt() then
                did_virtual_press = false
                break
            end
            PressMouseButton(1)
            did_virtual_press = true
            Sleep(settle_ms)
        end

        if not CompensateBurst(burst_index) then
            break
        end

        local sleep_cycles = math.floor(cycle_cooldown / 10)
        local rem_sleep = cycle_cooldown - (sleep_cycles * 10)
        local released = false
        for c = 1, sleep_cycles do
            if not IsMouseButtonPressed(1) or not IsAimingActive() or CheckEmergencyInterrupt() then
                released = true
                break
            end
            Sleep(10)
        end
        if released then break end
        if rem_sleep > 0 then
            if not IsMouseButtonPressed(1) or not IsAimingActive() or CheckEmergencyInterrupt() then
                break
            end
            Sleep(rem_sleep)
        end
    end

    CleanupAutoTrigger(did_virtual_press)
end

-------------------------------------------------------------------------------------------------------------------------
-- [6] MODIFIER RESOLUTION & WEAPON SELECTION
-------------------------------------------------------------------------------------------------------------------------

local function GetModifierOffset()
    local is_lctrl  = IsModifierPressed("lctrl")
    local is_lalt   = IsModifierPressed("lalt")
    local is_lshift = IsModifierPressed("lshift")
    local is_rctrl  = IsModifierPressed("rctrl")
    local is_ralt   = IsModifierPressed("ralt")
    local is_rshift = IsModifierPressed("rshift")
    local is_scroll = IsKeyLockOn("scrolllock")

    if is_lctrl and is_lalt and is_lshift then
        return 700  -- Tier 7: LCTRL + LALT + LSHIFT
    elseif is_rctrl and is_rshift then
        return 1200 -- Tier 12: RCTRL + RSHIFT
    elseif is_ralt and is_rshift then
        return 1100 -- Tier 11: RALT + RSHIFT
    elseif is_rctrl and is_ralt then
        return 1000 -- Tier 10: RCTRL + RALT
    elseif is_lalt and is_lshift then
        return 900  -- Tier 9: LALT + LSHIFT
    elseif is_lctrl and is_lshift then
        return 800  -- Tier 8: LCTRL + LSHIFT
    elseif is_rshift then
        return 600  -- Tier 6: RSHIFT
    elseif is_scroll then
        return 500  -- Tier 5: ScrollLock
    elseif is_ralt then
        return 400  -- Tier 4: RALT
    elseif is_rctrl then
        return 300  -- Tier 3: RCTRL
    elseif is_lalt then
        return 200  -- Tier 2: LALT
    elseif is_lctrl then
        return 100  -- Tier 1: LCTRL
    end

    return 0        -- Tier 0: No Modifier
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
    if not bind_id or bind_id == 0 then
        SetMacroActive(false)
        current_weapon = nil
        current_weapon_id = nil
        ResetSprayState()
        LogMessage("[DINO V10] State: Standby")
        return
    end

    local found = Weapons[bind_id]
    if not found then return end

    if recoil_active then
        if WEAPON_TOGGLE_MODE == "ANY" or current_weapon_id == bind_id then
            SetMacroActive(false)
            current_weapon = nil
            current_weapon_id = nil
            ResetSprayState()
            LogMessage("[DINO V10] State: Standby")
            return
        end
    end

    current_weapon_id = bind_id
    current_weapon = found
    SetMacroActive(true)
    ResetSprayState()
    LogMessage(string.format("[DINO V10] Active: %s [%s] | %d RPM | Stand: %.2f | Crouch: %.2f | H-Bias: %.3f",
        found.name, found.type, found.rpm or 0,
        found.tuner and found.tuner.stand or 1.0,
        found.tuner and found.tuner.crouch or 0.8,
        found.tuner and found.tuner.h_bias or 0.0))
end

-------------------------------------------------------------------------------------------------------------------------
-- [7] EVENT DISPATCHER
-------------------------------------------------------------------------------------------------------------------------

EnablePrimaryMouseButtonEvents(true)

local is_firing = false

function OnEvent(event, arg)
    if event == "MOUSE_BUTTON_PRESSED" then
        if arg == 1 then
            -- Ignore synthetic echo events queued within 45ms of a macro ending
            if is_firing or (GetRunningTime() - last_macro_end_time < 45) then
                return
            end
            local can_fire = recoil_active and current_weapon
            if REQUIRE_CAPSLOCK_FOR_FIRE then
                can_fire = can_fire and IsKeyLockOn("capslock")
            end

            if can_fire then
                if ClickMode == 1 or IsAimingActive() then
                    is_firing = true
                    emergency_off_requested = false
                    if current_weapon.type == "AUTO" then
                        ExecuteAutoRecoil(current_weapon)
                    elseif current_weapon.type == "DMR" then
                        ExecuteDMRRecoil(current_weapon)
                    elseif current_weapon.type == "BURST" then
                        ExecuteBurstRecoil(current_weapon)
                    end
                    is_firing = false
                    if emergency_off_requested then
                        emergency_off_requested = false
                        SelectWeapon(0)
                    end
                end
            end
            return
        end

        if DIRECT_MACRO_OFF_BUTTON and arg == DIRECT_MACRO_OFF_BUTTON then
            SetMacroActive(false)
            current_weapon = nil
            current_weapon_id = nil
            ResetSprayState()
            LogMessage("[DINO V10] State: Standby")
            return
        end

        if arg >= 4 then
            -- Ignore side-button release bounce if it already triggered an in-loop emergency standby
            if GetRunningTime() - last_macro_end_time < 60 and not recoil_active then
                return
            end
            local mod_offset = GetModifierOffset()
            local bind_id = arg + mod_offset
            SelectWeapon(bind_id)
        end

    elseif event == "G_PRESSED" then
        if KeyboardBinds and KeyboardBinds[arg] then
            SelectWeapon(KeyboardBinds[arg])
        end

    elseif event == "MOUSE_BUTTON_RELEASED" then
        if arg == 1 then
            last_tick_time = GetRunningTime()
        end

    elseif event == "PROFILE_ACTIVATED" then
        EnablePrimaryMouseButtonEvents(true)
        ResetSprayState()
        if not banner_logged then
            LogBanner()
        else
            LogMessage("----------------------------------------------------------------")
        end
        LogMessage("[DINO V10] System Initialized (UE4 Cubic Hermite Spline Engine)")
        LogMessage(string.format("[DINO V10] Config: DPI=%d | Sens=%.2f | Gamma=%.2f | H-Strength=%.2f",
            MOUSE_DPI, SensSetting, SplineResponseGamma, HorizontalStrength))
        LogMessage(string.format("[DINO V10] Toggles: Crouch=%s | SteadyAim=%s | Attachments=%s (%s) | AutoTap=%s",
            EnableCrouchMode and "ON" or "OFF",
            EnableHoldBreath and "ON" or "OFF",
            EnableAttachments and "ON" or "OFF",
            AttachmentsMode,
            DMR_AUTO_TAP and "ON" or "OFF"))
        LogMessage("----------------------------------------------------------------")

    elseif event == "PROFILE_DEACTIVATED" then
        ReleaseMouseButton(1)
        SetMacroActive(false)
        ResetSprayState()
    end
end

LogBanner()
