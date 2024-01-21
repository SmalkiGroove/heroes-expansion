
Var_Kyrre_BattleWon = 0
function Routine_AddHeroExperience(player, hero)
    print("$ Routine_AddHeroExperience")
    local exp = 1000 + Var_Kyrre_BattleWon * 50 * (GetHeroLevel(hero) + 10)
    AddHero_StatPerLevel(player, hero, STAT_EXPERIENCE, 300)
end

function Routine_KyrreVictoryCounter(player, hero, combatIndex)
    print("$ Routine_KyrreVictoryCounter")
    Var_Kyrre_BattleWon = Var_Kyrre_BattleWon + 1
end

function Routine_RezHunters(player, hero, combatIndex)
    print("$ Routine_RezHunters")
    local cap = 5 + GetHeroLevel(hero)
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 1)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 1, i)
        if died > 0 and contains({CREATURE_WOOD_ELF,CREATURE_GRAND_ELF,CREATURE_SHARP_SHOOTER}, creature) then
            local rez = min(cap, died)
            AddHeroCreatures(hero, creature, rez)
        end
    end
end

function Routine_AddHeroWolves(player, hero)
    print("$ Routine_AddHeroWolves")
    AddHero_CreatureType(player, hero, CREATURE_WOLF, 2.0)
end

function Routine_HeroCallUnicorns(player, hero)
    print("$ Routine_HeroCallUnicorns")
    AddHero_CreatureFromDwelling(player, hero, TOWN_BUILDING_DWELLING_5, CREATURE_WHITE_UNICORN, 0.75)
end

function Routine_AddHeroSpellPower(player, hero, combatIndex)
    print("$ Routine_AddHeroSpellPower")
    AddHero_StatAmount(player, hero, STAT_SPELL_POWER, 1)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


START_TRIGGER_PRESERVE = {
}

DAILY_TRIGGER_PRESERVE = {
}

WEEKLY_TRIGGER_PRESERVE = {
    [H_KYRRE] = Routine_AddHeroExperience,
    [H_IVOR] = Routine_AddHeroWolves,
    [H_YLTHIN] = Routine_HeroCallUnicorns,
}

LEVEL_UP_SYLVAN_HERO = {
}

AFTER_COMBAT_TRIGGER_PRESERVE = {
    [H_KYRRE] = Routine_KyrreVictoryCounter,
    [H_FINDAN] = Routine_RezHunters,
    [H_ELLESHAR] = Routine_AddHeroSpellPower,
}


function DoPreserveRoutine_Start(player, hero)
    if START_TRIGGER_PRESERVE[hero] then
        startThread(START_TRIGGER_PRESERVE[hero], player, hero)
    end
end

function DoPreserveRoutine_Daily(player, hero)
    if DAILY_TRIGGER_PRESERVE[hero] then
        startThread(DAILY_TRIGGER_PRESERVE[hero], player, hero)
    end
end

function DoPreserveRoutine_Weekly(player, hero)
    if WEEKLY_TRIGGER_PRESERVE[hero] then
        startThread(WEEKLY_TRIGGER_PRESERVE[hero], player, hero)
    end
end

function DoPreserveRoutine_LevelUp(player, hero, level)
    if LEVEL_UP_SYLVAN_HERO[hero] then
        startThread(LEVEL_UP_SYLVAN_HERO[hero], player, hero, level)
    end
end

function DoPreserveRoutine_AfterCombat(player, hero, index)
    if AFTER_COMBAT_TRIGGER_PRESERVE[hero] then
        startThread(AFTER_COMBAT_TRIGGER_PRESERVE[hero], player, hero, index)
    end
end


-- print("Loaded Preserve advmap routines")
ROUTINES_LOADED[PRESERVE] = 1
