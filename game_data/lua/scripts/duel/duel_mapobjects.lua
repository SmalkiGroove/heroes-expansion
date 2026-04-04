
function DuelOverrideStart()
    Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_START_1", "DuelTriggerStart1")
    Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_START_2", "DuelTriggerStart2")
    SetObjectEnabled("DUEL_START_1", nil)
    SetObjectEnabled("DUEL_START_2", nil)
end
function DuelTriggerStart1(hero, obj) DuelStart(1, hero) end
function DuelTriggerStart2(hero, obj) DuelStart(2, hero) end


function DuelOverrideMonolith()
    for _, obj in GetObjectNamesByType("BUILDING_MONOLITH_ONE_WAY_ENTRANCE") do
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerMonolith")
    end
end
function DuelTriggerMonolith(hero, obj)
    ChangeHeroStat(hero, STAT_MOVE_POINTS, -9999)
    local player = GetObjectOwner(hero)
    if DUEL_STAGE[player] == DUEL_STAGE_START then DuelSetup(player, hero)
    elseif DUEL_STAGE[player] == DUEL_STAGE_SETUP then DuelAdventure(player, hero)
    elseif DUEL_STAGE[player] == DUEL_STAGE_ADVENTURE then DuelStaging(player, hero)
    elseif DUEL_STAGE[player] == DUEL_STAGE_STAGING then DuelCastle(player, hero)
    elseif DUEL_STAGE[player] == DUEL_STAGE_CASTLE then DuelBattle(player, hero)
    end
end


function DuelOverrideLighthouse()
    for _, obj in GetObjectNamesByType("BUILDING_LIGHTHOUSE") do
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerLighthouse")
    end
end
function DuelTriggerLighthouse(hero, obj)
    DuelCastle(GetObjectOwner(hero), hero)
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
        MessageBoxForPlayers(GetPlayerFilter(GetObjectOwner(hero)), "/Text/Duel/DolmenMaxLevel.txt")
    end
end


function DuelOverrideSign()
    Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_1", "DuelTriggerSign")
    Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_2", "DuelTriggerSign")
end
function DuelTriggerSign(hero, obj)
    ChangeHeroStat(hero, STAT_MOVE_POINTS, 500)
    local player = GetObjectOwner(hero)
    if DUEL_STAGE[player] == DUEL_STAGE_START then DuelInfoWindow0(player)
    elseif DUEL_STAGE[player] == DUEL_STAGE_SETUP then DuelInfoWindow1(player)
    elseif DUEL_STAGE[player] == DUEL_STAGE_ADVENTURE then DuelInfoWindow2(player)
    elseif DUEL_STAGE[player] == DUEL_STAGE_CASTLE then DuelInfoWindow3(player)
    elseif DUEL_STAGE[player] == DUEL_STAGE_BATTLE then DuelInfoWindow4(player)
    end
end


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
