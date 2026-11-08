-------------------------------------------------------------------------------------------------------------------------
--                __
--               / _)      ____  _             
--      _.----._/ /       |  _ \(_)_ __   ___  
--     /         /        | | | | | '_ \ / _ \ 
--  __/ (  | (  |         | |_| | | | | | (_) |
-- /__.-'|_|--|_|         |____/|_|_| |_|\___/ 
--
-- DINO V9 - ZERO RECOIL BALLISTIC ENGINE FOR PUBG PC (LOGITECH G HUB)
-------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------
-- [1] USER CONFIGURATION
-------------------------------------------------------------------------------------------------------------------------

local MOUSE_DPI = 800
local SensSetting = 1.20

-- Feature Toggles
local EnableCrouchMode = true
local EnableHoldBreath = true
local EnableAttachments = true
local AttachmentsMode = "NUMLOCK" -- "NUMLOCK" or "ALWAYS"

-- Operation Modes
local ClickMode = 1              -- 1 = LMB only, 3 = RMB + LMB
local DMR_AUTO_TAP = true        -- True = Auto-cycling on hold
local HorizontalStrength = 0.60  -- Master horizontal bias multiplier (0.00 to 1.00)

-- State Management
local WEAPON_TOGGLE_MODE = "ANY" -- "ANY" = any bound key toggles standby, "SAME" = toggle current
local DIRECT_MACRO_OFF_BUTTON = nil
local SYNC_CAPSLOCK_LED = true
local REQUIRE_CAPSLOCK_FOR_FIRE = false
local ENABLE_LOGGING = true

-------------------------------------------------------------------------------------------------------------------------
-- [2] WEAPON TUNING PROFILES
-------------------------------------------------------------------------------------------------------------------------

local WeaponTuner = {
    -- Assault Rifles
    M416     = { stand = 2.85, crouch = 2.28, att_scale = 0.78, h_bias =  0.035 },
    BERRYL   = { stand = 3.87, crouch = 3.09, att_scale = 0.75, h_bias =  0.060, is_762 = true },
    AKM      = { stand = 3.60, crouch = 2.88, att_scale = 0.85, h_bias =  0.075, is_762 = true },
    AUG      = { stand = 2.90, crouch = 2.32, att_scale = 0.78, h_bias =  0.025 },
    ACE32    = { stand = 3.60, crouch = 2.88, att_scale = 0.76, h_bias =  0.050, is_762 = true },
    SCAR_L   = { stand = 2.69, crouch = 2.15, att_scale = 0.78, h_bias = -0.035 },
    QBZ      = { stand = 2.79, crouch = 2.23, att_scale = 0.78, h_bias = -0.015 },
    G36C     = { stand = 2.63, crouch = 2.11, att_scale = 0.78, h_bias = -0.035 },
    K2       = { stand = 2.90, crouch = 2.32, att_scale = 0.82, h_bias =  0.025 },
    GROZA    = { stand = 3.97, crouch = 3.18, att_scale = 0.88, h_bias =  0.040, is_762 = true },
    FAMAS    = { stand = 3.17, crouch = 2.53, att_scale = 0.85, h_bias =  0.000 },
    MUTANT   = { stand = 3.44, crouch = 2.75, att_scale = 0.76, h_bias =  0.000, is_762 = true },
    M16A4    = { stand = 2.69, crouch = 2.15, att_scale = 0.78, h_bias =  0.000 },

    -- Submachine Guns
    UMP45    = { stand = 2.09, crouch = 1.68, att_scale = 0.78, h_bias =  0.000, is_smg = true },
    VECTOR   = { stand = 2.52, crouch = 2.02, att_scale = 0.75, h_bias = -0.020, is_smg = true },
    UZI      = { stand = 2.31, crouch = 1.85, att_scale = 0.78, h_bias = -0.020, is_smg = true },
    MP5K     = { stand = 2.36, crouch = 1.89, att_scale = 0.75, h_bias =  0.020, is_smg = true },
    TOMMY    = { stand = 2.42, crouch = 1.93, att_scale = 0.85, h_bias =  0.000, is_smg = true },
    P90      = { stand = 2.31, crouch = 1.85, att_scale = 1.00, h_bias =  0.000, is_smg = true },
    MP9      = { stand = 2.26, crouch = 1.80, att_scale = 1.00, h_bias =  0.000, is_smg = true },
    JS9      = { stand = 2.31, crouch = 1.85, att_scale = 0.78, h_bias =  0.015, is_smg = true },

    -- Light Machine Guns
    M249     = { stand = 2.42, crouch = 1.40, att_scale = 0.88, h_bias =  0.035 },
    MG3      = { stand = 2.58, crouch = 1.45, att_scale = 1.00, h_bias = -0.020, is_762 = true },
    RPD      = { stand = 2.74, crouch = 1.72, att_scale = 0.82, h_bias =  0.045, is_762 = true },

    -- Designated Marksman Rifles
    DRAGUNOV = { stand = 1.00, crouch = 0.80, att_scale = 0.82, pull = 36, h_pull = 0.0, steps = 4, sleep = 10, delay = 250 },
    SLR      = { stand = 1.00, crouch = 0.80, att_scale = 0.80, pull = 30, h_pull = 0.0, steps = 4, sleep = 8,  delay = 180 },
    SKS      = { stand = 1.00, crouch = 0.80, att_scale = 0.72, pull = 26, h_pull = 0.0, steps = 4, sleep = 8,  delay = 180 },
    MK14     = { stand = 4.25, crouch = 3.15, att_scale = 0.75, h_bias =  0.050, is_762 = true },
    MINI14   = { stand = 1.00, crouch = 0.80, att_scale = 0.80, pull = 17, h_pull = 0.0, steps = 3, sleep = 6,  delay = 170 },
    MK12     = { stand = 1.00, crouch = 0.75, att_scale = 0.76, pull = 16, h_pull = 0.0, steps = 3, sleep = 6,  delay = 170 },
    QBU      = { stand = 1.00, crouch = 0.75, att_scale = 0.80, pull = 17, h_pull = 0.0, steps = 3, sleep = 6,  delay = 170 },
    VSS      = { stand = 2.25, crouch = 1.80, att_scale = 0.85, h_bias =  0.000, is_smg = true },
    DMR_GEN  = { stand = 1.00, crouch = 0.80, att_scale = 0.78, pull = 24, h_pull = 0.0, steps = 4, sleep = 8,  delay = 180 },
}

-------------------------------------------------------------------------------------------------------------------------
-- [3] KEYBINDINGS
-------------------------------------------------------------------------------------------------------------------------

-- 4-Series: Mouse Button 4 (5.56mm Arsenal)
local BIND_M416        = 4     -- Mouse 4
local BIND_AUG         = 104   -- LCTRL + Mouse 4
local BIND_SCAR_L      = 204   -- LALT + Mouse 4
local BIND_G36C        = 304   -- RCTRL + Mouse 4
local BIND_QBZ         = 404   -- RALT + Mouse 4
local BIND_M249        = 504   -- ScrollLock + Mouse 4
local BIND_FAMAS       = 604   -- RSHIFT + Mouse 4
local BIND_MINI14      = 704   -- LCTRL + LALT + LSHIFT + Mouse 4
local BIND_MK12        = 804   -- LCTRL + LSHIFT + Mouse 4
local BIND_QBU         = 904   -- LALT + LSHIFT + Mouse 4
local BIND_M16A4       = 1004  -- RCTRL + RALT + Mouse 4
local BIND_MACRO_OFF_4 = 1104  -- RALT + RSHIFT + Mouse 4

-- 5-Series: Mouse Button 5 (7.62mm Arsenal)
local BIND_BERRYL      = 5     -- Mouse 5
local BIND_AKM         = 105   -- LCTRL + Mouse 5
local BIND_GROZA       = 205   -- LALT + Mouse 5
local BIND_K2          = 305   -- RCTRL + Mouse 5
local BIND_ACE32       = 405   -- RALT + Mouse 5
local BIND_MG3         = 505   -- ScrollLock + Mouse 5
local BIND_DMR         = 605   -- RSHIFT + Mouse 5
local BIND_SKS         = 705   -- LCTRL + LALT + LSHIFT + Mouse 5
local BIND_SLR         = 805   -- LCTRL + LSHIFT + Mouse 5
local BIND_DRAGUNOV    = 905   -- LALT + LSHIFT + Mouse 5
local BIND_MK14        = 1005  -- RCTRL + RALT + Mouse 5
local BIND_MUTANT      = 1105  -- RALT + RSHIFT + Mouse 5
local BIND_RPD         = 1205  -- RCTRL + RSHIFT + Mouse 5

-- 6-Series: Mouse Button 6 (SMGs, VSS, Standby)
local BIND_MP5K        = 6     -- Mouse 6
local BIND_VECTOR      = 106   -- LCTRL + Mouse 6
local BIND_UMP45       = 206   -- LALT + Mouse 6
local BIND_JS9         = 306   -- RCTRL + Mouse 6
local BIND_UZI         = 406   -- RALT + Mouse 6
local BIND_P90         = 506   -- ScrollLock + Mouse 6
local BIND_MP9         = 606   -- RSHIFT + Mouse 6
local BIND_TOMMY       = 706   -- LCTRL + LALT + LSHIFT + Mouse 6
local BIND_VSS         = 806   -- LCTRL + LSHIFT + Mouse 6
local BIND_DMR_GEN     = 906   -- LALT + LSHIFT + Mouse 6
local BIND_MACRO_OFF_6 = 1006  -- RCTRL + RALT + Mouse 6
local BIND_MACRO_OFF   = 1106  -- RALT + RSHIFT + Mouse 6

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
    [12] = BIND_MACRO_OFF,
}

-------------------------------------------------------------------------------------------------------------------------
-- [4] WEAPON DATABASE & BALLISTIC CURVES
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
    -- Assault Rifles
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

    -- Submachine Guns
    [BIND_UMP45] = {
        name = "UMP45", type = "AUTO", caliber = "9mm", rpm = 600, tick_ms = 20,
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

    -- Light Machine Guns
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

    -- Designated Marksman Rifles
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
        name = "Mk14 EBR", type = "AUTO", caliber = "7.62", rpm = 700, tick_ms = 17,
        v_curve = GenerateBaseSpray(14.0, 19.0, 21.0, 350),
        h_curve = GenerateHorizontalBias(WeaponTuner.MK14.h_bias, 350),
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
        name = "VSS Vintorez", type = "AUTO", caliber = "9mm", rpm = 700, tick_ms = 17,
        v_curve = GenerateBaseSpray(7.0, 9.5, 10.8, 350),
        h_curve = GenerateHorizontalBias(WeaponTuner.VSS.h_bias, 350),
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
-- [5] RECOIL CORE ENGINE
-------------------------------------------------------------------------------------------------------------------------

local recoil_active = false
local current_weapon_id = nil
local current_weapon = nil

local remainder_x = 0
local remainder_y = 0

local spray_tick_count = 0
local saved_spray_tick_count = 0
local last_tick_time = 0
local last_valid_y = 0

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
    LogMessage("[DINO V9] ZERO RECOIL BALLISTIC ENGINE FOR PUBG PC (LOGITECH G HUB)")
    LogMessage("----------------------------------------------------------------")
end

local function ResetSprayState()
    remainder_x = 0
    remainder_y = 0
    spray_tick_count = 0
    saved_spray_tick_count = 0
    last_tick_time = 0
    last_valid_y = 0
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

local function GetRecoilModifiers(tuner)
    local stance_mult
    if EnableCrouchMode and IsModifierPressed("lctrl") then
        stance_mult = tuner.crouch or (tuner.stand and (tuner.stand * 0.80)) or 0.80
    else
        stance_mult = tuner.stand or 1.00
    end

    if EnableHoldBreath and IsModifierPressed("lshift") then
        stance_mult = stance_mult * 0.90
    end

    local att_mult = 1.00
    if EnableAttachments then
        if AttachmentsMode == "ALWAYS" or (AttachmentsMode == "NUMLOCK" and IsKeyLockOn("numlock")) then
            att_mult = tuner.att_scale or 0.78
        end
    end

    return stance_mult, att_mult
end

local function ExecuteAutoRecoil(w)
    local now = GetRunningTime()
    local time_gap = now - last_tick_time

    if time_gap > 200 then
        if time_gap <= 380 and saved_spray_tick_count <= 40 then
            spray_tick_count = saved_spray_tick_count
        elseif time_gap <= 380 and saved_spray_tick_count > 40 then
            spray_tick_count = 6
        else
            spray_tick_count = 0
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

        local stance_mult, att_mult = GetRecoilModifiers(w.tuner)

        local decay_mult
        if spray_tick_count <= 2 then
            decay_mult = 0.42
        elseif spray_tick_count <= 6 then
            decay_mult = 0.48
        elseif spray_tick_count <= 12 then
            decay_mult = 0.55
        elseif spray_tick_count <= 40 then
            local fade = (spray_tick_count - 12) / 28
            decay_mult = 0.55 - (fade * 0.15)
        else
            decay_mult = 0.40
        end

        local raw_v = 0
        local raw_h = 0

        if spray_tick_count <= max_ticks then
            raw_v = v_curve[spray_tick_count] or v_curve[max_ticks]
            raw_h = (h_curve and h_curve[spray_tick_count]) or (w.tuner.h_bias or 0)
            last_valid_y = raw_v
        else
            raw_v = last_valid_y
            raw_h = (w.tuner.h_bias or 0)
        end

        if (w.tuner and w.tuner.is_762) or w.caliber == "7.62" then
            raw_v = raw_v * 0.89
        elseif (w.tuner and w.tuner.is_smg) or w.caliber == "9mm" or w.caliber == ".45" then
            raw_v = raw_v * 0.92
        end

        local final_v = raw_v * stance_mult * att_mult * decay_mult * SensSetting

        local final_h = 0
        if HorizontalStrength > 0 and math.abs(raw_h) > 0.001 then
            final_h = raw_h * stance_mult * att_mult * decay_mult * SensSetting * HorizontalStrength
        end

        ApplySubPixelMove(final_h, final_v)

        local elapsed = GetRunningTime() - step_start_time
        local remaining_sleep = tick_ms - elapsed
        if remaining_sleep > 0 then
            Sleep(remaining_sleep)
        else
            Sleep(1)
        end

        last_tick_time = GetRunningTime()

        if not IsMouseButtonPressed(1) then
            break
        end

        if ClickMode == 3 and not IsMouseButtonPressed(2) then
            break
        end

    until not IsMouseButtonPressed(1)
end

local function ExecuteDMRRecoil(w)
    local t = w.tuner
    local pull = t.pull or 26
    local h_pull = (t.h_pull or 0) * HorizontalStrength
    local steps = t.steps or 4
    local sleep_per_step = t.sleep or 8
    local inter_shot_delay = t.delay or 180

    local stance_mult, att_mult = GetRecoilModifiers(t)
    local final_pull = pull * stance_mult * att_mult * SensSetting
    local final_h = h_pull * stance_mult * att_mult * SensSetting
    local step_v = final_pull / steps
    local step_h = final_h / steps

    local function CompensateSingleShot()
        for s = 1, steps do
            ApplySubPixelMove(step_h, step_v)
            Sleep(sleep_per_step)
        end
    end

    if not DMR_AUTO_TAP then
        CompensateSingleShot()
        return
    end

    local recoil_duration = steps * sleep_per_step
    local cooldown = inter_shot_delay - 25 - recoil_duration
    if cooldown < 15 then cooldown = 15 end

    local shot_index = 0

    while IsMouseButtonPressed(1) do
        if ClickMode == 3 and not IsMouseButtonPressed(2) then break end

        shot_index = shot_index + 1

        if shot_index > 1 then
            PressMouseButton(1)
            Sleep(25)
            ReleaseMouseButton(1)
        end

        stance_mult, att_mult = GetRecoilModifiers(t)
        final_pull = pull * stance_mult * att_mult * SensSetting
        final_h = h_pull * stance_mult * att_mult * SensSetting
        step_v = final_pull / steps
        step_h = final_h / steps

        for s = 1, steps do
            ApplySubPixelMove(step_h, step_v)
            Sleep(sleep_per_step)
        end

        local sleep_cycles = math.floor(cooldown / 10)
        for c = 1, sleep_cycles do
            if not IsMouseButtonPressed(1) then break end
            if ClickMode == 3 and not IsMouseButtonPressed(2) then break end
            Sleep(10)
        end
    end
end

local function ExecuteBurstRecoil(w)
    local count = w.burst_count or 2
    local v_curve = w.v_curve
    local h_curve = w.h_curve
    local t = w.tuner
    local inter_bullet_delay = w.rpm == 800 and 24 or 32
    local burst_steps = 3
    local step_sleep = math.floor(inter_bullet_delay / burst_steps)
    local cycle_cooldown = w.rpm == 800 and 110 or 125

    local stance_mult, att_mult = GetRecoilModifiers(t)

    local function CompensateBurst()
        for i = 1, count do
            local raw_v = (v_curve and v_curve[i]) or 12.0
            local raw_h = (h_curve and h_curve[i]) or (t.h_bias or 0)
            local total_v = raw_v * stance_mult * att_mult * SensSetting * 0.35
            if (t and t.is_762) or w.caliber == "7.62" then
                total_v = total_v * 0.89
            end
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

        if burst_index > 1 then
            PressMouseButton(1)
            Sleep(25)
            ReleaseMouseButton(1)
        end

        CompensateBurst()

        local sleep_cycles = math.floor(cycle_cooldown / 10)
        for c = 1, sleep_cycles do
            if not IsMouseButtonPressed(1) then break end
            if ClickMode == 3 and not IsMouseButtonPressed(2) then break end
            Sleep(10)
        end
    end
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
    if bind_id == BIND_MACRO_OFF or bind_id == BIND_MACRO_OFF_4 or bind_id == BIND_MACRO_OFF_6 then
        SetMacroActive(false)
        current_weapon = nil
        current_weapon_id = nil
        ResetSprayState()
        LogMessage("[DINO V9] State: Standby")
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
            LogMessage("[DINO V9] State: Standby")
            return
        end
    end

    current_weapon_id = bind_id
    current_weapon = found
    SetMacroActive(true)
    ResetSprayState()
    LogMessage(string.format("[DINO V9] Active: %s [%s] | %d RPM | H-Bias: %.3f", 
        found.name, found.type, found.rpm or 0, found.tuner and found.tuner.h_bias or 0))
end

-------------------------------------------------------------------------------------------------------------------------
-- [7] EVENT DISPATCHER
-------------------------------------------------------------------------------------------------------------------------

EnablePrimaryMouseButtonEvents(true)

local is_firing = false

function OnEvent(event, arg)
    if event == "MOUSE_BUTTON_PRESSED" then
        if arg == 1 then
            if is_firing then return end
            local can_fire = recoil_active and current_weapon
            if REQUIRE_CAPSLOCK_FOR_FIRE then
                can_fire = can_fire and IsKeyLockOn("capslock")
            end

            if can_fire then
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

        if DIRECT_MACRO_OFF_BUTTON and arg == DIRECT_MACRO_OFF_BUTTON then
            SetMacroActive(false)
            current_weapon = nil
            current_weapon_id = nil
            ResetSprayState()
            LogMessage("[DINO V9] State: Standby")
            return
        end

        if arg >= 4 then
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
        LogMessage("[DINO V9] System Initialized ")
        LogMessage(string.format("[DINO V9] Config: Sens=%.2f | H-Strength=%.2f", SensSetting, HorizontalStrength))
        LogMessage(string.format("[DINO V9] Toggles: Crouch=%s | SteadyAim=%s | Attachments=%s (%s) | AutoTap=%s",
            EnableCrouchMode and "ON" or "OFF",
            EnableHoldBreath and "ON" or "OFF",
            EnableAttachments and "ON" or "OFF",
            AttachmentsMode,
            DMR_AUTO_TAP and "ON" or "OFF"))
        LogMessage("----------------------------------------------------------------")

    elseif event == "PROFILE_DEACTIVATED" then
        SetMacroActive(false)
        ResetSprayState()
    end
end

LogBanner()
