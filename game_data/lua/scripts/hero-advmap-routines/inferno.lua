
function Routine_TransferNightmares(player, hero)
    print("$ Routine_TransferNightmares")
    AddHero_CreatureFromDwelling(player, hero, TOWN_BUILDING_DWELLING_5, CREATURE_NIGHTMARE, 0.4)
end

function Routine_AddHeroHellHounds(player, hero)
    print("$ Routine_AddHeroHellHounds")
    AddHero_CreatureInTypes(player, hero, {CREATURE_HELL_HOUND,CREATURE_CERBERI,CREATURE_FIREBREATHER_HOUND}, 0.9)
end

function Routine_GainAttackPerLevel(player, hero, level)
    print("$ Routine_GainAttackPerLevel")
    if mod(level, 5) == 0 then
        AddHero_StatAmount(player, hero, STAT_ATTACK, 1)
    end
end

function Routine_RezSuccubus(player, hero, combatIndex)
    print("$ Routine_RezSuccubus")
    local cap = 3 + trunc(0.66 * GetHeroLevel(hero))
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 1)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 1, i)
        if died > 0 and contains({CREATURE_SUCCUBUS,CREATURE_INFERNAL_SUCCUBUS,CREATURE_SUCCUBUS_SEDUCER}, creature) then
            local rez = min(cap, died)
            AddHeroCreatures(hero, creature, rez)
        end
    end
end

function Routine_GenerateSulfur(player, hero)
    print("$ Routine_GenerateSulfur")
    local amount = trunc(0.2 * GetHeroLevel(hero))
    AddPlayer_Resource(player, hero, SULFUR, amount)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


START_TRIGGER_INFERNO = {
}

DAILY_TRIGGER_INFERNO = {
    [H_DELEB] = Routine_GenerateSulfur,
}

WEEKLY_TRIGGER_INFERNO = {
    [H_GROK] = Routine_TransferNightmares,
    [H_GRAWL] = Routine_AddHeroHellHounds,
}

LEVEL_UP_INFERNO_HERO = {
    [H_ASH] = Routine_GainAttackPerLevel,
}

AFTER_COMBAT_TRIGGER_INFERNO = {
    [H_BIARA] = Routine_RezSuccubus,
}


function DoInfernoRoutine_Start(player, hero)
    if START_TRIGGER_INFERNO[hero] then
        startThread(START_TRIGGER_INFERNO[hero], player, hero)
    end
end

function DoInfernoRoutine_Daily(player, hero)
    if DAILY_TRIGGER_INFERNO[hero] then
        startThread(DAILY_TRIGGER_INFERNO[hero], player, hero)
    end
end

function DoInfernoRoutine_Weekly(player, hero)
    if WEEKLY_TRIGGER_INFERNO[hero] then
        startThread(WEEKLY_TRIGGER_INFERNO[hero], player, hero)
    end
end

function DoInfernoRoutine_LevelUp(player, hero, level)
    if LEVEL_UP_INFERNO_HERO[hero] then
        startThread(LEVEL_UP_INFERNO_HERO[hero], player, hero, level)
    end
end

function DoInfernoRoutine_AfterCombat(player, hero, index)
    if AFTER_COMBAT_TRIGGER_INFERNO[hero] then
        startThread(AFTER_COMBAT_TRIGGER_INFERNO[hero], player, hero, index)
    end
end


-- print("Loaded Inferno advmap routines")
ROUTINES_LOADED[INFERNO] = 1
