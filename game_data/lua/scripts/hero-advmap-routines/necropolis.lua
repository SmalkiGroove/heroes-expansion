
function Routine_HeroCallVampires(player, hero)
    print("$ Routine_HeroCallVampires")
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_VAMPIRE, 0.8)
    sleep(10)
    AddHero_CreatureFromDwelling(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_NOSFERATU, 1.2)
end

function Routine_AddHeroBlackKnights(player, hero)
    print("$ Routine_AddHeroBlackKnights")
    AddHero_CreatureType(player, hero, CREATURE_BLACK_KNIGHT, 0.1)
end

function Routine_EvolveBlackKnights(player, hero, combatIndex)
    print("$ Routine_EvolveBlackKnights")
    local max = trunc(GetHeroLevel(hero) * 0.15)
    local bks = GetHeroCreatures(hero, CREATURE_BLACK_KNIGHT)
    local nb = min(bks, max)
    if nb > 0 then
        RemoveHeroCreatures(hero, CREATURE_BLACK_KNIGHT, nb)
        AddHeroCreatures(hero, CREATURE_DEATH_KNIGHT, nb)
        ShowFlyingSign({"/Text/Game/Scripts/Evolve.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_AddRecruitsNecropolis(player, hero)
    print("$ Routine_AddRecruitsNecropolis")
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_SKELETON, 2.5)
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_2, CREATURE_WALKING_DEAD, 1.25)
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_3, CREATURE_MANES, 0.5)
end

function Routine_AddHeroMummies(player, hero)
    print("$ Routine_AddHeroMummies")
    AddHero_CreatureType(player, hero, CREATURE_MUMMY, 0.85)
end

function Routine_AddHeroBanshees(player, hero)
    print("$ Routine_AddHeroBanshees")
    AddHero_CreatureType(player, hero, CREATURE_BANSHEE, 0.06)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


START_TRIGGER_NECROPOLIS = {
}

DAILY_TRIGGER_NECROPOLIS = {
    [H_XERXON] = Routine_AddHeroBlackKnights,
}

WEEKLY_TRIGGER_NECROPOLIS = {
    [H_LUCRETIA] = Routine_HeroCallVampires,
    [H_RAVEN] = Routine_AddRecruitsNecropolis,
    [H_THANT] = Routine_AddHeroMummies,
    [H_DEIRDRE] = Routine_AddHeroBanshees,
}

LEVEL_UP_NECRO_HERO = {
}

AFTER_COMBAT_TRIGGER_NECROPOLIS = {
    [H_XERXON] = Routine_EvolveBlackKnights,
}


function DoNecropolisRoutine_Start(player, hero)
    if START_TRIGGER_NECROPOLIS[hero] then
        startThread(START_TRIGGER_NECROPOLIS[hero], player, hero)
    end
end

function DoNecropolisRoutine_Daily(player, hero)
    if DAILY_TRIGGER_NECROPOLIS[hero] then
        startThread(DAILY_TRIGGER_NECROPOLIS[hero], player, hero)
    end
end

function DoNecropolisRoutine_Weekly(player, hero)
    if WEEKLY_TRIGGER_NECROPOLIS[hero] then
        startThread(WEEKLY_TRIGGER_NECROPOLIS[hero], player, hero)
    end
end

function DoNecropolisRoutine_LevelUp(player, hero, level)
    if LEVEL_UP_NECRO_HERO[hero] then
        startThread(LEVEL_UP_NECRO_HERO[hero], player, hero, level)
    end
end

function DoNecropolisRoutine_AfterCombat(player, hero, index)
    if AFTER_COMBAT_TRIGGER_NECROPOLIS[hero] then
        startThread(AFTER_COMBAT_TRIGGER_NECROPOLIS[hero], player, hero, index)
    end
end


-- print("Loaded Necropolis advmap routines")
ROUTINES_LOADED[NECROPOLIS] = 1
