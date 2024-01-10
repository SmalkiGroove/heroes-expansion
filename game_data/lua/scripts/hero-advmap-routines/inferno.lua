
function Routine_AddHeroHellHounds(player, hero)
    -- Hell hounds - 1:2 - 2:5 - 3:8 - 4:11 - ... - 17:50
    print("$ Routine_AddHeroHellHounds")
    AddHero_CreatureInTypes(player, hero, {CREATURE_HELL_HOUND,CREATURE_CERBERI,CREATURE_FIREBREATHER_HOUND}, 0.33)
end

function Routine_GenerateSulfur(player, hero)
    -- Sulfur - +1 / 3 levels
    print("$ Routine_GenerateSulfur")
    local amount = trunc(0.34 * GetHeroLevel(hero))
    AddPlayer_Resource(player, hero, SULFUR, amount)
end

function Routine_AddHeroNightmares(player, hero)
    -- Nightmare - 1:5 - 2:13 - 3:21 - 4:30 - 5:38 - 6:46
    print("$ Routine_AddHeroNightmares")
    AddHero_CreatureInTypes(player, hero, {CREATURE_NIGHTMARE,CREATURE_FRIGHTFUL_NIGHTMARE,CREATURE_HELLMARE}, 0.12)
end

function Routine_AddHeroFireDragons(player, hero)
    -- Fire Dragon - 1:2 - 2:5 - 3:9 - 4:12 - 5:15 ... 15:49
    print("$ Routine_AddHeroFireDragons")
    AddHero_CreatureType(player, hero, CREATURE_FIRE_DRAGON, 0.3)
end

function Routine_GenerateCrystal(player, hero)
    -- Crystals - +1 / 3 levels
    print("$ Routine_GenerateCrystal")
    local amount = trunc(0.34 * GetHeroLevel(hero))
    AddPlayer_Resource(player, hero, SULFUR, amount)
end

function Routine_AddHeroSuccubi(player, hero)
    -- Succubus - 1:1 - 2:3 - 3:5 - 4:7 - ... - 25:49
    print("$ Routine_AddHeroSuccubi")
    AddHero_CreatureInTypes(player, hero, {CREATURE_SUCCUBUS,CREATURE_INFERNAL_SUCCUBUS,CREATURE_SUCCUBUS_SEDUCER}, 0.5)
end

function Routine_AddRecruitsInferno(player, hero)
    -- Imps - 2.5 * level recruits per week / Horned demons - 1.5 * level recruits per week / Devils - 0.1 * level recruits per week
    print("$ Routine_AddRecruitsInferno")
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_FAMILIAR, 2.5)
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_2, CREATURE_DEMON, 1.5)
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_7, CREATURE_DEVIL, 0.1)
end

function Routine_GainAttackInferno(player, hero, level)
    --Att +1 / 5 levels
    print("$ Routine_GainAttackInferno")
    if mod(level, 5) == 0 then
        AddHero_StatAmount(player, hero, STAT_ATTACK, 1)
    end
end

function Routine_AddRandomStat(player, hero, level)
    -- Random attribute - +1 / lvl + lvl / 10
    print("$ Routine_AddRandomStat")
    local stat = random(1, 4, level)
    local amount = 1 + trunc(level * 0.1)
    AddHero_StatAmount(player, hero, stat, amount)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


START_TRIGGER_INFERNO = {
    [H_GRAWL] = NoneRoutine,
    [H_NEBIROS] = NoneRoutine,
    [H_MARBAS] = NoneRoutine,
    [H_HARKENRAZ] = NoneRoutine,
    [H_CALH] = NoneRoutine,
    [H_SHELTEM] = NoneRoutine,
    [H_ALASTOR] = NoneRoutine,
    [H_GROK] = NoneRoutine,
    [H_NYMUS] = NoneRoutine,
    [H_JEZEBETH] = NoneRoutine,
    [H_MALUSTAR] = NoneRoutine,
    [H_AGRAEL] = NoneRoutine,
    [H_BIARA] = NoneRoutine,
    [H_KHABELETH] = NoneRoutine,
    [H_ZYDAR] = NoneRoutine,
    [H_DELEB] = NoneRoutine,
    [H_CALID] = NoneRoutine,
}

DAILY_TRIGGER_INFERNO = {
    [H_GRAWL] = Routine_AddHeroHellHounds,
    [H_NEBIROS] = NoneRoutine,
    [H_MARBAS] = NoneRoutine,
    [H_HARKENRAZ] = Routine_GenerateSulfur,
    [H_CALH] = NoneRoutine,
    [H_SHELTEM] = NoneRoutine,
    [H_ALASTOR] = NoneRoutine,
    [H_GROK] = Routine_AddHeroNightmares,
    [H_NYMUS] = NoneRoutine,
    [H_JEZEBETH] = NoneRoutine,
    [H_MALUSTAR] = NoneRoutine,
    [H_AGRAEL] = NoneRoutine,
    [H_BIARA] = NoneRoutine,
    [H_KHABELETH] = NoneRoutine,
    [H_ZYDAR] = NoneRoutine,
    [H_DELEB] = NoneRoutine,
    [H_CALID] = NoneRoutine,
}

WEEKLY_TRIGGER_INFERNO = {
    [H_GRAWL] = NoneRoutine,
    [H_NEBIROS] = NoneRoutine,
    [H_MARBAS] = Routine_AddHeroFireDragons,
    [H_HARKENRAZ] = NoneRoutine,
    [H_CALH] = NoneRoutine,
    [H_SHELTEM] = NoneRoutine,
    [H_ALASTOR] = NoneRoutine,
    [H_GROK] = NoneRoutine,
    [H_NYMUS] = NoneRoutine,
    [H_JEZEBETH] = NoneRoutine,
    [H_MALUSTAR] = NoneRoutine,
    [H_AGRAEL] = NoneRoutine,
    [H_BIARA] = NoneRoutine,
    [H_KHABELETH] = NoneRoutine,
    [H_ZYDAR] = Routine_AddRecruitsInferno,
    [H_DELEB] = NoneRoutine,
    [H_CALID] = NoneRoutine,
}

LEVEL_UP_INFERNO_HERO = {
    [H_GRAWL] = NoneRoutine,
    [H_NEBIROS] = Routine_GainAttackInferno,
    [H_MARBAS] = NoneRoutine,
    [H_HARKENRAZ] = NoneRoutine,
    [H_CALH] = NoneRoutine,
    [H_SHELTEM] = NoneRoutine,
    [H_ALASTOR] = NoneRoutine,
    [H_GROK] = NoneRoutine,
    [H_NYMUS] = NoneRoutine,
    [H_JEZEBETH] = NoneRoutine,
    [H_MALUSTAR] = Routine_AddRandomStat,
    [H_AGRAEL] = NoneRoutine,
    [H_BIARA] = NoneRoutine,
    [H_KHABELETH] = NoneRoutine,
    [H_ZYDAR] = NoneRoutine,
    [H_DELEB] = NoneRoutine,
    [H_CALID] = NoneRoutine,
}

AFTER_COMBAT_TRIGGER_INFERNO = {
    [H_GRAWL] = NoneRoutine,
    [H_NEBIROS] = NoneRoutine,
    [H_MARBAS] = NoneRoutine,
    [H_HARKENRAZ] = NoneRoutine,
    [H_CALH] = NoneRoutine,
    [H_SHELTEM] = NoneRoutine,
    [H_ALASTOR] = NoneRoutine,
    [H_GROK] = NoneRoutine,
    [H_NYMUS] = NoneRoutine,
    [H_JEZEBETH] = NoneRoutine,
    [H_MALUSTAR] = NoneRoutine,
    [H_AGRAEL] = NoneRoutine,
    [H_BIARA] = NoneRoutine,
    [H_KHABELETH] = NoneRoutine,
    [H_ZYDAR] = NoneRoutine,
    [H_DELEB] = NoneRoutine,
    [H_CALID] = NoneRoutine,
}


function DoInfernoRoutine_Start(player, hero)
    startThread(START_TRIGGER_INFERNO[hero], player, hero)
end

function DoInfernoRoutine_Daily(player, hero)
    startThread(DAILY_TRIGGER_INFERNO[hero], player, hero)
end

function DoInfernoRoutine_Weekly(player, hero)
    startThread(WEEKLY_TRIGGER_INFERNO[hero], player, hero)
end

function DoInfernoRoutine_LevelUp(player, hero, level)
    startThread(LEVEL_UP_INFERNO_HERO[hero], player, hero, level)
end

function DoInfernoRoutine_AfterCombat(player, hero, index)
    startThread(AFTER_COMBAT_TRIGGER_INFERNO[hero], player, hero, index)
end


-- print("Loaded Inferno advmap routines")
ROUTINES_LOADED[INFERNO] = 1
