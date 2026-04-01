
function DuelOverrideStart()
    Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_START_1", "DuelTriggerStart1")
    Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_START_2", "DuelTriggerStart2")
    SetObjectEnabled("DUEL_START_1", nil)
    SetObjectEnabled("DUEL_START_2", nil)
end
function DuelTriggerStart1(hero, obj) DuelStart(1, hero) end
function DuelTriggerStart2(hero, obj) DuelStart(2, hero) end

function DuelOverrideSetUp(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerSetUp")
end
function DuelTriggerSetUp(hero, obj) DuelSetUp(GetObjectOwner(hero), hero) end

function DuelOverrideLighthouse(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerLighthouse")
end
function DuelTriggerLighthouse(hero, obj) DuelCastle(GetObjectOwner(hero), hero) end

function DuelOverrideMonolith(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerMonolith")
end
function DuelTriggerMonolith(hero, obj) DuelBattle(GetObjectOwner(hero), hero) end


DUEL_DOLMEN_MAX_LEVEL = 20 + DUEL_MODE * 5
DUEL_DOLMEN_LEVELS = {1, 1}

function DuelOverrideDolmen(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerDolmen")
    SetObjectEnabled(obj, nil)
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
