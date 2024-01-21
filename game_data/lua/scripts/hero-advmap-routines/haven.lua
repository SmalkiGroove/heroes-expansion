
function Routine_AddHeroCavaliers(player, hero)
    print("$ Routine_AddHeroCavaliers")
    AddHero_CreatureInTypes(player, hero, {CREATURE_CAVALIER,CREATURE_PALADIN,CREATURE_CHAMPION}, 0.11)
end

function Routine_ActivateArtfsetHaven(player, hero)
    print("$ Routine_ActivateArtfsetHaven")
    -- GiveArtifact(hero, ___, 1)
    -- GiveArtifact(hero, ___, 1)
end

function Routine_AddRecruitsPeasants(player, hero)
    print("$ Routine_AddRecruitsPeasants")
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_PEASANT, 4.5)
end

function Routine_TrainPeasantsToArchersCheck(player, hero, town)
    print("$ Routine_TrainPeasantsToArchersCheck")
    local b = GetTownBuildingLevel(town, TOWN_BUILDING_HAVEN_TRAINING_GROUNDS)
    local max = GetObjectDwellingCreatures(town, CREATURE_PEASANT)
    local n = 0
    if b == 1 then n = 7 elseif b == 2 then n = 20 end
    n = min(n, max)
    if n > 0 then
        QuestionBoxForPlayers(
            GetPlayerFilter(player),
            {"/Text/Game/Scripts/HeroSpe/TrainArchers.txt"; num=n},
            "Routine_TrainPeasantsToArchersConfirm('"..player.."','"..hero.."','"..town.."','"..n.."')", "NoneRoutine"
        )
    end
end

function Routine_TrainPeasantsToArchersConfirm(player, hero, town, amount)
    print("$ Routine_TrainPeasantsToArchersConfirm")
    local peasants = GetObjectDwellingCreatures(town, CREATURE_PEASANT)
    local archers = GetObjectDwellingCreatures(town, CREATURE_ARCHER)
    SetObjectDwellingCreatures(town, TOWN_BUILDING_DWELLING_1, peasants - amount)
    SetObjectDwellingCreatures(town, TOWN_BUILDING_DWELLING_2, archers + amount)
end

function Routine_GainExpFromTotalGolds(player, hero)
    print("$ Routine_GainExpFromTotalGolds")
    local mult = trunc(GetHeroLevel(hero) * 0.1)
    local amount = GetPlayerResource(player, GOLD) * mult
    AddHero_StatAmount(player, hero, STAT_EXPERIENCE, amount)
end

function Routine_AddHeroZealots(player, hero)
    print("$ Routine_AddHeroZealots")
    AddHero_CreatureType(player, hero, CREATURE_ZEALOT, 0.1)
end

function Routine_AddTwoLuckPoints(player, hero)
    print("$ Routine_AddTwoLuckPoints")
    ChangeHeroStat(hero, STAT_LUCK, 2)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


START_TRIGGER_HAVEN = {
    [H_LASZLO] = Routine_ActivateArtfsetHaven,
    [H_ISABEL] = Routine_AddTwoLuckPoints,
}

DAILY_TRIGGER_HAVEN = {
    [H_ALARIC] = Routine_AddHeroZealots,
}

WEEKLY_TRIGGER_HAVEN = {
    [H_MAEVE] = Routine_AddRecruitsPeasants,
    [H_KLAUS] = Routine_AddHeroCavaliers,
    [H_NICOLAI] = Routine_GainExpFromTotalGolds,
}

LEVEL_UP_HAVEN_HERO = {
}

AFTER_COMBAT_TRIGGER_HAVEN = {
}


function DoHavenRoutine_Start(player, hero)
    if START_TRIGGER_HAVEN[hero] then
        startThread(START_TRIGGER_HAVEN[hero], player, hero)
    end
end

function DoHavenRoutine_Daily(player, hero)
    if DAILY_TRIGGER_HAVEN[hero] then
        startThread(DAILY_TRIGGER_HAVEN[hero], player, hero)
    end
end

function DoHavenRoutine_Weekly(player, hero)
    if WEEKLY_TRIGGER_HAVEN[hero] then
        startThread(WEEKLY_TRIGGER_HAVEN[hero], player, hero)
    end
end

function DoHavenRoutine_LevelUp(player, hero, level)
    if LEVEL_UP_HAVEN_HERO[hero] then
        startThread(LEVEL_UP_HAVEN_HERO[hero], player, hero, level)
    end
end

function DoHavenRoutine_AfterCombat(player, hero, index)
    if AFTER_COMBAT_TRIGGER_HAVEN[hero] then
        startThread(AFTER_COMBAT_TRIGGER_HAVEN[hero], player, hero, index)
    end
end


-- print("Loaded Haven advmap routines")
ROUTINES_LOADED[HAVEN] = 1
