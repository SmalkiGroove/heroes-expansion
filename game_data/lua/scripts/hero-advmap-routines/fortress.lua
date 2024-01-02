
TRANSFORM_ARRAY_FORTRESS = { 0,
92,93,94,95,98,99,96,97,100,101,102,103,104,105,
92,93,94,95,98,99,96,97,100,101,102,103,104,105,
92,93,94,95,98,99,96,97,100,101,104,105,102,103,
94,95,92,93,98,99,96,97,100,101,102,103,104,105,
92,93,94,95,98,99,96,97,100,101,102,103,104,105,
92,93,94,95,98,99,96,97,102,103,100,101,104,105,
0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,
166,167,169,168,170,171,172,
0,0,0,0,
92,93,96,97,98,99,94,95,100,101,102,103,104,105,
166,167,169,168,170,171,172,
166,167,169,168,171,170,172,
167,166,169,168,170,171,172,
166,167,169,168,170,172,171,
166,167,169,168,170,171,172,
0,0,0,0,0,0,0,
166,168,169,167,170,171,172,
0 }


function Routine_GainFortressArtifacts()
    -- Dwarven artfacts set
    local hero = H_HEDWIG
    if GetHeroLevel(hero) == 40 then
        GiveArtifact(hero, ARTIFACT_DWARVEN_MITHRAL_CUIRASS)
        GiveArtifact(hero, ARTIFACT_DWARVEN_MITHRAL_GREAVES)
        GiveArtifact(hero, ARTIFACT_DWARVEN_MITHRAL_HELMET)
        GiveArtifact(hero, ARTIFACT_DWARVEN_MITHRAL_SHIELD)
    end
end

function Routine_AddLuckAndMorale(player, hero)
    --Luck and Morale +2
    AddHero_StatAmount(player, hero, STAT_LUCK, 2)
    AddHero_StatAmount(player, hero, STAT_MORALE, 2)
end

function Routine_AddHeroDefenders(player, hero)
    -- Defenders - 1:1 - 2:3 - 3:5 - 4:7 - 5:9 ... 25:49
    AddHero_CreatureInTypes(player, hero, {CREATURE_DEFENDER,CREATURE_STOUT_DEFENDER,CREATURE_STONE_DEFENDER}, 0.5)
end

function Routine_GenerateCrystalsAndGems(player, hero)
    -- Crystals and Gems - +1 / 5 levels
    local amount = trunc(GetHeroLevel(hero) * 0.2)
    AddPlayer_Resource(player, hero, CRYSTAL, amount)
    AddPlayer_Resource(player, hero, GEM, amount)
end

function Routine_EvolveRunePriests(player, hero)
    -- Rune Priest to Thane (or upgrade) for n Defenders (or upgrade)
    local n = 30 - trunc(GetHeroLevel(hero) * 0.5)
    ChangeHero_CreatureFusion(player, hero, CREATURE_RUNE_MAGE, CREATURE_DEFENDER, CREATURE_THANE, n)
    ChangeHero_CreatureFusion(player, hero, CREATURE_RUNE_MAGE, CREATURE_STOUT_DEFENDER, CREATURE_WARLORD, n)
    ChangeHero_CreatureFusion(player, hero, CREATURE_RUNE_MAGE, CREATURE_STONE_DEFENDER, CREATURE_THUNDER_THANE, n)
end

function Routine_TransformCreaturesToFortressUnits(player, hero)
    -- Transform creatures to Fortress units
    ChangeHero_CreatureTransform(player, hero, TRANSFORM_ARRAY_FORTRESS)
end

function Routine_UpgradeRunePriests(player, hero)
    -- Upgrade Rune Priest to Rune Patriarch
    ChangeHero_CreatureUpgrade(player, hero, CREATURE_RUNE_MAGE, CREATURE_FLAME_MAGE)
end

function Routine_AddHeroExperiencePercent(player, hero)
    -- Exp - 5% total hero exp
    AddHero_StatPercent(player, hero, STAT_EXPERIENCE, 0.05)
end

function Routine_AddRecruitsBearRiders(player, hero)
    -- Bears - 1.75 * level recruits per week
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_BEAR_RIDER, 1.75)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


LEVEL_UP_FORTRESS_HERO = {
    [H_INGVAR] = "NoneRoutine",
    [H_ROLF] = "NoneRoutine",
    [H_WULFSTAN] = "NoneRoutine",
    [H_TAZAR] = "NoneRoutine",
    [H_MAXIMUS] = "NoneRoutine",
    [H_KARLI] = "NoneRoutine",
    [H_HEDWIG] = "Routine_GainFortressArtifacts",
    [H_TOLGHAR] = "NoneRoutine",
    [H_EBBA] = "NoneRoutine",
    [H_ULAND] = "NoneRoutine",
    [H_HAEGEIR] = "NoneRoutine",
    [H_HELMAR] = "NoneRoutine",
    [H_BRAND] = "NoneRoutine",
    [H_ERLING] = "NoneRoutine",
    [H_HANGVUL] = "NoneRoutine",
    [H_BART] = "NoneRoutine",
    [H_INGA] = "NoneRoutine",
}

START_TRIGGER_FORTRESS = {
    [H_INGVAR] = NoneRoutine,
    [H_ROLF] = NoneRoutine,
    [H_WULFSTAN] = NoneRoutine,
    [H_TAZAR] = NoneRoutine,
    [H_MAXIMUS] = NoneRoutine,
    [H_KARLI] = NoneRoutine,
    [H_HEDWIG] = NoneRoutine,
    [H_TOLGHAR] = Routine_AddLuckAndMorale,
    [H_EBBA] = NoneRoutine,
    [H_ULAND] = NoneRoutine,
    [H_HAEGEIR] = NoneRoutine,
    [H_HELMAR] = NoneRoutine,
    [H_BRAND] = NoneRoutine,
    [H_ERLING] = NoneRoutine,
    [H_HANGVUL] = NoneRoutine,
    [H_BART] = NoneRoutine,
    [H_INGA] = NoneRoutine,
}

DAILY_TRIGGER_FORTRESS = {
    [H_INGVAR] = Routine_AddHeroDefenders,
    [H_ROLF] = NoneRoutine,
    [H_WULFSTAN] = NoneRoutine,
    [H_TAZAR] = NoneRoutine,
    [H_MAXIMUS] = NoneRoutine,
    [H_KARLI] = NoneRoutine,
    [H_HEDWIG] = NoneRoutine,
    [H_TOLGHAR] = NoneRoutine,
    [H_EBBA] = Routine_GenerateCrystalsAndGems,
    [H_ULAND] = Routine_EvolveRunePriests,
    [H_HAEGEIR] = Routine_TransformCreaturesToFortressUnits,
    [H_HELMAR] = NoneRoutine,
    [H_BRAND] = NoneRoutine,
    [H_ERLING] = Routine_UpgradeRunePriests,
    [H_HANGVUL] = Routine_AddHeroExperiencePercent,
    [H_BART] = NoneRoutine,
    [H_INGA] = NoneRoutine,
}

WEEKLY_TRIGGER_FORTRESS = {
    [H_INGVAR] = NoneRoutine,
    [H_ROLF] = Routine_AddRecruitsBearRiders,
    [H_WULFSTAN] = NoneRoutine,
    [H_TAZAR] = NoneRoutine,
    [H_MAXIMUS] = NoneRoutine,
    [H_KARLI] = NoneRoutine,
    [H_HEDWIG] = NoneRoutine,
    [H_TOLGHAR] = NoneRoutine,
    [H_EBBA] = NoneRoutine,
    [H_ULAND] = NoneRoutine,
    [H_HAEGEIR] = NoneRoutine,
    [H_HELMAR] = NoneRoutine,
    [H_BRAND] = NoneRoutine,
    [H_ERLING] = NoneRoutine,
    [H_HANGVUL] = NoneRoutine,
    [H_BART] = NoneRoutine,
    [H_INGA] = NoneRoutine,
}

AFTER_COMBAT_TRIGGER_FORTRESS = {
    [H_INGVAR] = NoneRoutine,
    [H_ROLF] = NoneRoutine,
    [H_WULFSTAN] = NoneRoutine,
    [H_TAZAR] = NoneRoutine,
    [H_MAXIMUS] = NoneRoutine,
    [H_KARLI] = NoneRoutine,
    [H_HEDWIG] = NoneRoutine,
    [H_TOLGHAR] = NoneRoutine,
    [H_EBBA] = NoneRoutine,
    [H_ULAND] = NoneRoutine,
    [H_HAEGEIR] = NoneRoutine,
    [H_HELMAR] = NoneRoutine,
    [H_BRAND] = NoneRoutine,
    [H_ERLING] = NoneRoutine,
    [H_HANGVUL] = NoneRoutine,
    [H_BART] = NoneRoutine,
    [H_INGA] = NoneRoutine,
}


function DoFortressRoutine_Start(player, hero)
    startThread(START_TRIGGER_FORTRESS[hero], player, hero)
end

function DoFortressRoutine_Daily(player, hero)
    startThread(DAILY_TRIGGER_FORTRESS[hero], player, hero)
end

function DoFortressRoutine_Weekly(player, hero)
    startThread(WEEKLY_TRIGGER_FORTRESS[hero], player, hero)
end

function DoFortressRoutine_AfterCombat(player, hero, index)
    startThread(AFTER_COMBAT_TRIGGER_FORTRESS[hero], player, hero, index)
end

function DoFortressRoutine_LevelUp(player, hero)
    startThread(LEVEL_UP_FORTRESS_HERO[hero], player, hero)
end


-- print("Loaded Fortress advmap routines")
ROUTINES_LOADED[FORTRESS] = 1
