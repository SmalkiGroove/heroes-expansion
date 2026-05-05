
function DuelOverrideStart()
    Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_START_1", "DuelTriggerStart1")
    Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_START_2", "DuelTriggerStart2")
    SetObjectEnabled("DUEL_START_1", nil)
    SetObjectEnabled("DUEL_START_2", nil)
end
function DuelTriggerStart1(hero, obj) DuelSetup(1, hero) end
function DuelTriggerStart2(hero, obj) DuelSetup(2, hero) end


function DuelOverrideMonolith()
    for _, obj in GetObjectNamesByType("BUILDING_MONOLITH_ONE_WAY_ENTRANCE") do
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerMonolith")
    end
end
function DuelTriggerMonolith(hero, obj)
    ExecConsoleCommand("@DuelNextStage("..GetObjectOwner(hero)..", '"..hero.."')")
end


function DuelOverrideLighthouse()
    for _, obj in GetObjectNamesByType("BUILDING_LIGHTHOUSE") do
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerLighthouse")
        SetObjectEnabled(obj, nil)
    end
end
function DuelTriggerLighthouse(hero, obj)
    ExecConsoleCommand("@DuelNextStage("..GetObjectOwner(hero)..", '"..hero.."')")
end


DUEL_DOLMEN_MAX_LEVEL = 20 + DUEL_MODE * 5
DUEL_DOLMEN_LEVELS = {1, 1}

function DuelOverrideDolmen()
    for _, obj in GetObjectNamesByType("BUILDING_LEARNING_STONE") do
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerDolmen")
        SetObjectEnabled(obj, nil)
    end
end
function DuelTriggerDolmen(hero, obj)
    local player = GetObjectOwner(hero)
    if DUEL_DOLMEN_LEVELS[player] < DUEL_DOLMEN_MAX_LEVEL then
        LevelUpHero(hero)
        DUEL_DOLMEN_LEVELS[player] = DUEL_DOLMEN_LEVELS[player] + 1
    else
        Trigger(OBJECT_TOUCH_TRIGGER, obj, nil)
        MessageBoxPEST(GetPlayerFilter(GetObjectOwner(hero)), "/Text/Duel/DolmenMaxLevel.txt")
    end
end


function DuelOverrideSign()
    for p = 1,2 do
        Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_"..p, "DuelTriggerSign0")
        Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_"..p.."_10", "DuelTriggerSign1")
        Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_"..p.."_20", "DuelTriggerSign2")
        Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_"..p.."_30", "DuelTriggerSign3")
        Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_"..p.."_50", "DuelTriggerSign5")
        for j = 1,8 do Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_"..p.."_4"..j, "DuelTriggerSign4") end
    end
end
function DuelTriggerSign0(hero, obj) DuelInfoWindow0(GetObjectOwner(hero)) end
function DuelTriggerSign1(hero, obj) DuelInfoWindow1(GetObjectOwner(hero)) end
function DuelTriggerSign2(hero, obj) DuelInfoWindow2(GetObjectOwner(hero)) end
function DuelTriggerSign3(hero, obj) DuelInfoWindow3(GetObjectOwner(hero)) end
function DuelTriggerSign4(hero, obj) DuelInfoWindow4(GetObjectOwner(hero)) end
function DuelTriggerSign5(hero, obj) DuelInfoWindow5(GetObjectOwner(hero)) end


function DuelOverrideFlag()
    local flags = {}
    for p = 1,2 do for k = 1,8 do
        local flag = "P"..p.."_BORDER_GUARD_KEY_"..k
        Trigger(OBJECT_TOUCH_TRIGGER, flag, "DuelTriggerFlag"..k)
        SetObjectEnabled(flag, nil)
    end end
end
function DuelTriggerFlag1(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 1) end
function DuelTriggerFlag2(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 2) end
function DuelTriggerFlag3(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 3) end
function DuelTriggerFlag4(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 4) end
function DuelTriggerFlag5(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 5) end
function DuelTriggerFlag6(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 6) end
function DuelTriggerFlag7(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 7) end
function DuelTriggerFlag8(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 8) end
