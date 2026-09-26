--[[PUBG AR + DMR SCRIPT (LEFT-CLICK ONLY)]]--
 
--[[MASTER SCRIPT ENABLE/DISABLE SETTINGS]]--
--------------------------------------------------------------------------------------------------------------
local ar_mode_button = 4 -- MOUSE BUTTON FOR AR MODE (ScrollLock OFF, CapsLock ON)
local dmr_mode_button = 5 -- MOUSE BUTTON FOR DMR MODE (ScrollLock ON, CapsLock OFF)
local st_k="capslock" --TURN ON/OFF MASTER SCRIPT KEY.
local dmr_k="scrolllock" --TURN ON/OFF DMR MODE (ScrollLock ON = DMR, ScrollLock OFF = AR).
 
--[[AR NO RECOIL SETTINGS (AUTOMATIC)]]--
--------------------------------------------------------------------------------------------------------------
local n_r=9 --HOW MANY PIXELS THE MOUSE IS MOVED DOWN DEFAULT: 6
local nr_s=20 --INTERVAL BETWEEN MOUSE MOVEMENTS DEFAULT: 40
local nr_p=0 --DELAY BEFORE STARTING MOUSE MOVEMENTS EACH TIME DEFAULT: 0
 
--[[DMR NO RECOIL SETTINGS (SINGLE TAPS)]]--
--------------------------------------------------------------------------------------------------------------
local dmr_pull=25 -- TOTAL PIXELS TO PULL DOWN PER SINGLE TAP
local dmr_steps=4  -- HOW SMOOTH THE PULL IS (DIVIDES TOTAL PULL)
local dmr_sleep=10 -- DELAY BETWEEN SMOOTHING STEPS IN MILLISECONDS

--[[LEAN-SPAM SETTINGS]]--
--------------------------------------------------------------------------------------------------------------
local lt_k="numlock" --KEY TO TURN ON/OFF LEANSPAM WHILE LEFT CLICKING
local ll_k="Q" --LEFT PEEK KEY SETTING DEFAULT: "Q"
local rl_k="E" --RIGHT PEEK KEY SETTING DEFAULT "E"
local m_l=3 --FINE TUNE SETTING FOR LEAN TIME
 
--[[DON'T MODIFY THESE SETTINGS]]--
--------------------------------------------------------------------------------------------------------------
local l_s=nr_s*(m_l//2)
local l_st=1
local o_r
local ls_s
local l_k
local is_ar_on = false
local is_dmr_on = false
 
--[[FUNCTIONS]]--
--------------------------------------------------------------------------------------------------------------
function lean_spam()
    if l_k == ll_k then
        l_k=rl_k
    else
        l_k=ll_k
    end
    PressKey(l_k)
    Sleep(l_s)
    ReleaseKey(l_k)
    no_recoil=l_s//m_l
end
 
function leandir()
    if ls_s then
        if (l_k == ll_k) then
            return (l_st)
        else
            return -(l_st)
        end
    else
        return 0
    end
end
 
function norecoil() -- AR CONTINUOUS RECOIL
    Sleep(nr_p)
    repeat
        o_r=n_r
        if ls_s then
            if (l_st > m_l) then
                 lean_spam()
                 l_st=0
            else
                l_st=l_st+1
            end
        end
        n_r=o_r
        MoveMouseRelative(leandir(),n_r)
        Sleep(nr_s)
    until not IsMouseButtonPressed(1)
end

function dmr_recoil() -- DMR TAP RECOIL
    -- This smoothly pulls the mouse down exactly once per click
    local step_pull = math.floor(dmr_pull / dmr_steps)
    for i = 1, dmr_steps do
        MoveMouseRelative(0, step_pull)
        Sleep(dmr_sleep)
    end
end
 
--[[MAIN ONEVENT FOR SCRIPT FUNCTIONALITY]]--
--------------------------------------------------------------------------------------------------------------
function OnEvent(event, arg)
    -- Only sync from keyboard locks if it's NOT a button 4 or 5 event
    if not (arg == ar_mode_button or arg == dmr_mode_button) then
        is_ar_on = IsKeyLockOn(st_k)
        is_dmr_on = IsKeyLockOn(dmr_k)
    end

    if (event == "MOUSE_BUTTON_PRESSED") then
        local is_script_active = is_ar_on or is_dmr_on

        if (arg == ar_mode_button or arg == dmr_mode_button) then
            if is_script_active then
                -- Any mode is currently active: turn off the whole script
                if is_ar_on then 
                    PressAndReleaseKey(st_k) 
                    is_ar_on = false
                end
                if is_dmr_on then 
                    PressAndReleaseKey(dmr_k) 
                    is_dmr_on = false
                end
            else
                -- Script is off: enter the respective mode
                if (arg == ar_mode_button) then
                    -- Enter AR mode (CapsLock ON, ScrollLock OFF)
                    PressAndReleaseKey(st_k)
                    is_ar_on = true
                elseif (arg == dmr_mode_button) then
                    -- Enter DMR mode (CapsLock OFF, ScrollLock ON)
                    PressAndReleaseKey(dmr_k)
                    is_dmr_on = true
                end
            end
        end
    end

    if is_ar_on or is_dmr_on then
        EnablePrimaryMouseButtonEvents(true)
    else
        EnablePrimaryMouseButtonEvents(false)
    end
    
    if IsKeyLockOn(lt_k) then
        ls_s=true
    else
        ls_s=false
    end
    
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 1) then
        if is_dmr_on then
            dmr_recoil() -- If DMR is active, do a single DMR pull-down
        elseif is_ar_on then
            norecoil()   -- If AR is active, do continuous AR spray recoil
        end
    end
end