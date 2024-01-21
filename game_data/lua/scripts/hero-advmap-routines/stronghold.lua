
function Routine_AddRecruitsCentaurs(player, hero)
    print("$ Routine_AddRecruitsCentaurs")
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_CENTAUR, 0.75)
end

Var_Gorshak_BattleWon = 0
function Routine_GainAttackDefense(player, hero, combatIndex)
    print("$ Routine_GainAttackDefense")
    Var_Gorshak_BattleWon = Var_Gorshak_BattleWon + 1
    if mod(Var_Gorshak_BattleWon, 10) == 0 then
        AddHero_StatAmount(player, hero, STAT_ATTACK, 1)
        AddHero_StatAmount(player, hero, STAT_DEFENCE, 1)
    end
end

function Routine_AddHeroWyverns(player, hero)
    print("$ Routine_AddHeroWyverns")
    AddHero_CreatureInTypes(player, hero, {CREATURE_WYVERN,CREATURE_WYVERN_POISONOUS,CREATURE_WYVERN_PAOKAI}, 0.25)
end

function Routine_ActivateArtfsetSarIssus(player, hero)
    print("$ Routine_ActivateArtfsetSarIssus")
    -- GiveArtifact(hero, ___, 1)
    -- GiveArtifact(hero, ___, 1)
end

function Routine_AddRecruitsShamans(player, hero)
    print("$ Routine_AddRecruitsShamans")
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_2, CREATURE_SHAMAN, 2.4)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


START_TRIGGER_STRONGHOLD = {
    [H_KUJIN] = Routine_ActivateArtfsetSarIssus,
}

DAILY_TRIGGER_STRONGHOLD = {
}

WEEKLY_TRIGGER_TRONGHOLD = {
    [H_GARUNA] = Routine_AddRecruitsCentaurs,
    [H_SHAKKARUKAT] = Routine_AddHeroWyverns,
    [H_KUJIN] = Routine_AddRecruitsShamans,
}

LEVEL_UP_STRONGHOLD_HERO = {
}

AFTER_COMBAT_TRIGGER_TRONGHOLD = {
    [H_GORSHAK] = Routine_GainAttackDefense,
}


function DoStrongholdRoutine_Start(player, hero)
    if START_TRIGGER_STRONGHOLD[hero] then
        startThread(START_TRIGGER_STRONGHOLD[hero], player, hero)
    end
end

function DoStrongholdRoutine_Daily(player, hero)
    if DAILY_TRIGGER_STRONGHOLD[hero] then
        startThread(DAILY_TRIGGER_STRONGHOLD[hero], player, hero)
    end
end

function DoStrongholdRoutine_Weekly(player, hero)
    if WEEKLY_TRIGGER_TRONGHOLD[hero] then
        startThread(WEEKLY_TRIGGER_TRONGHOLD[hero], player, hero)
    end
end

function DoStrongholdRoutine_LevelUp(player, hero, level)
    if LEVEL_UP_STRONGHOLD_HERO[hero] then
        startThread(LEVEL_UP_STRONGHOLD_HERO[hero], player, hero, level)
    end
end

function DoStrongholdRoutine_AfterCombat(player, hero, index)
    if AFTER_COMBAT_TRIGGER_TRONGHOLD[hero] then
        startThread(AFTER_COMBAT_TRIGGER_TRONGHOLD[hero], player, hero, index)
    end
end


-- print("Loaded Stronghold advmap routines")
ROUTINES_LOADED[STRONGHOLD] = 1
