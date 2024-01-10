
function Routine_GainArtifactNecromancerHelm(player, hero)
    -- Hero gain artifact Necromancer's Helm
    print("> Routine_GainArtifactNecromancerHelm")
    GiveArtifact(hero, ARTIFACT_SKULL_HELMET)
end

function Routine_AddHeroBlackKnights(player, hero)
    -- Black Knight - 1:5 - 2:15 - 3:25 - 4:35 - 5:45
    print("> Routine_AddHeroBlackKnights")
    AddHero_CreatureType(player, hero, CREATURE_BLACK_KNIGHT, 0.1)
end

function Routine_AddHeroLiches(player, hero)
    -- Lich - 1:5 - 2:13 - 3:21 - 4:30 - 5:38 - 6:46
    print("> Routine_AddHeroLiches")
    AddHero_CreatureInTypes(player, hero, {CREATURE_LICH,CREATURE_DEMILICH,CREATURE_LICH_MASTER}, 0.12)
end

function Routine_GenerateGoldPerNecroCreature(player, hero)
    -- Gold - 1 per creature in army per 10 levels
    print("> Routine_GenerateGoldPerNecroCreature")
    local mult = ceil(GetHeroLevel(hero) * 0.067)
    local army = GetHeroArmy(hero)
    local amount = 0
    for i = 1,7 do
        local cr = army[i]
        if cr and GetCreatureFactionID(cr) == NECROPOLIS then amount = amount + GetHeroCreatures(hero, cr) end
    end
    AddPlayer_Resource(player, hero, GOLD, amount)
end

function Routine_AddHeroMummies(player, hero)
    -- Mummy - 1:2 - 2:6 - 3:10 - 4:14 - 5:18 ... 13:50
    print("> Routine_AddHeroMummies")
    AddHero_CreatureType(player, hero, CREATURE_MUMMY, 0.25)
end

function Routine_HeroCallVampires(player, hero)
    -- Vampires - 1.5 * level transfered
    print("> Routine_HeroCallVampires")
    local coef = 2 / GetHeroLevel(hero)
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_VAMPIRE, coef)
    sleep(10)
    AddHero_CreatureFromDwelling(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_NOSFERATU, 1.5)
end

function Routine_EvolveBlackKnights(player, hero)
    -- B.Knights to D.Knights for 1 Lich
    print("> Routine_EvolveBlackKnights")
    ChangeHero_CreatureFusion(player, hero, CREATURE_BLACK_KNIGHT, CREATURE_LICH, CREATURE_DEATH_KNIGHT, 1)
end

function Routine_AddHeroBanshees(player, hero)
    -- Banshee - 1:8 - 2:22 - 3:36 - 4:50
    print("> Routine_AddHeroBanshees")
    AddHero_CreatureType(player, hero, CREATURE_BANSHEE, 0.07)
end

function Routine_AddRecruitsNecropolis(player, hero)
    -- Skeletons - 3.5 * level recruits per week / Walking deads - 2 * level recruits per week / Manes - 0.75 * level recruits per week
    print("> Routine_AddRecruitsNecropolis")
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_SKELETON, 3.5)
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_2, CREATURE_WALKING_DEAD, 2.0)
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_3, CREATURE_MANES, 0.75)
end

function Routine_GainDefenceNecro(player, hero)
    --Def +1 / 4 levels
    print("> Routine_GainDefenceNecro")
    local level = GetHeroLevel(hero)
    if mod(level, 4) == 0 then
        AddHero_StatAmount(player, hero, STAT_DEFENCE, 1)
    end
end

function Routine_GainNecroArtifacts(player, hero)
    -- Tunic of carved flesh / Amulet of Necromancy / Cursed Ring / Skull of Markal / Tome of dark magic
    print("> Routine_GainNecroArtifacts")
    local level = GetHeroLevel(hero)
    if     level == 10 then GiveArtifact(hero, ARTIFACT_BONESTUDDED_LEATHER)
    elseif level == 20 then GiveArtifact(hero, ARTIFACT_NECROMANCER_PENDANT)
    elseif level == 30 then GiveArtifact(hero, ARTIFACT_JINXING_BAND)
    elseif level == 40 then GiveArtifact(hero, ARTIFACT_SKULL_OF_MARKAL)
    elseif level == 50 then GiveArtifact(hero, ARTIFACT_TOME_OF_DARK_MAGIC)
    end
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


START_TRIGGER_NECROPOLIS = {
    [H_KASPAR] = NoneRoutine,
    [H_VLADIMIR] = NoneRoutine,
    [H_ORSON] = NoneRoutine,
    [H_ORNELLA2] = NoneRoutine,
    [H_LUCRETIA] = NoneRoutine,
    [H_XERXON] = NoneRoutine,
    [H_DEIRDRE] = NoneRoutine,
    [H_NAADIR] = NoneRoutine,
    [H_AISLINN] = NoneRoutine,
    [H_GIOVANNI] = NoneRoutine,
    [H_ARCHILUS] = NoneRoutine,
    [H_ZOLTAN] = NoneRoutine,
    [H_RAVEN] = NoneRoutine,
    [H_ARANTIR] = NoneRoutine,
    [H_THANT] = Routine_GainArtifactNecromancerHelm,
    [H_SANDRO] = NoneRoutine,
    [H_VIDOMINA] = NoneRoutine,
}

DAILY_TRIGGER_NECROPOLIS = {
    [H_KASPAR] = NoneRoutine,
    [H_VLADIMIR] = NoneRoutine,
    [H_ORSON] = NoneRoutine,
    [H_ORNELLA2] = NoneRoutine,
    [H_LUCRETIA] = NoneRoutine,
    [H_XERXON] = Routine_AddHeroBlackKnights,
    [H_DEIRDRE] = NoneRoutine,
    [H_NAADIR] = NoneRoutine,
    [H_AISLINN] = NoneRoutine,
    [H_GIOVANNI] = NoneRoutine,
    [H_ARCHILUS] = NoneRoutine,
    [H_ZOLTAN] = Routine_AddHeroLiches,
    [H_RAVEN] = Routine_GenerateGoldPerNecroCreature,
    [H_ARANTIR] = NoneRoutine,
    [H_THANT] = Routine_AddHeroMummies,
    [H_SANDRO] = NoneRoutine,
    [H_VIDOMINA] = NoneRoutine,
}

WEEKLY_TRIGGER_NECROPOLIS = {
    [H_KASPAR] = NoneRoutine,
    [H_VLADIMIR] = NoneRoutine,
    [H_ORSON] = NoneRoutine,
    [H_ORNELLA2] = NoneRoutine,
    [H_LUCRETIA] = Routine_HeroCallVampires,
    [H_XERXON] = Routine_EvolveBlackKnights,
    [H_DEIRDRE] = Routine_AddHeroBanshees,
    [H_NAADIR] = NoneRoutine,
    [H_AISLINN] = NoneRoutine,
    [H_GIOVANNI] = NoneRoutine,
    [H_ARCHILUS] = NoneRoutine,
    [H_ZOLTAN] = NoneRoutine,
    [H_RAVEN] = NoneRoutine,
    [H_ARANTIR] = Routine_AddRecruitsNecropolis,
    [H_THANT] = NoneRoutine,
    [H_SANDRO] = NoneRoutine,
    [H_VIDOMINA] = NoneRoutine,
}

LEVEL_UP_NECRO_HERO = {
    [H_KASPAR] = NoneRoutine,
    [H_VLADIMIR] = NoneRoutine,
    [H_ORSON] = NoneRoutine,
    [H_ORNELLA2] = Routine_GainDefenceNecro,
    [H_LUCRETIA] = NoneRoutine,
    [H_XERXON] = NoneRoutine,
    [H_DEIRDRE] = NoneRoutine,
    [H_NAADIR] = NoneRoutine,
    [H_AISLINN] = NoneRoutine,
    [H_GIOVANNI] = NoneRoutine,
    [H_ARCHILUS] = NoneRoutine,
    [H_ZOLTAN] = NoneRoutine,
    [H_RAVEN] = NoneRoutine,
    [H_ARANTIR] = NoneRoutine,
    [H_THANT] = Routine_GainNecroArtifacts,
    [H_SANDRO] = NoneRoutine,
    [H_VIDOMINA] = NoneRoutine,
}

AFTER_COMBAT_TRIGGER_NECROPOLIS = {
    [H_KASPAR] = NoneRoutine,
    [H_VLADIMIR] = NoneRoutine,
    [H_ORSON] = NoneRoutine,
    [H_ORNELLA2] = NoneRoutine,
    [H_LUCRETIA] = NoneRoutine,
    [H_XERXON] = NoneRoutine,
    [H_DEIRDRE] = NoneRoutine,
    [H_NAADIR] = NoneRoutine,
    [H_AISLINN] = NoneRoutine,
    [H_GIOVANNI] = NoneRoutine,
    [H_ARCHILUS] = NoneRoutine,
    [H_ZOLTAN] = NoneRoutine,
    [H_RAVEN] = NoneRoutine,
    [H_ARANTIR] = NoneRoutine,
    [H_THANT] = NoneRoutine,
    [H_SANDRO] = NoneRoutine,
    [H_VIDOMINA] = NoneRoutine,
}


function DoNecropolisRoutine_Start(player, hero)
    startThread(START_TRIGGER_NECROPOLIS[hero], player, hero)
end

function DoNecropolisRoutine_Daily(player, hero)
    startThread(DAILY_TRIGGER_NECROPOLIS[hero], player, hero)
end

function DoNecropolisRoutine_Weekly(player, hero)
    startThread(WEEKLY_TRIGGER_NECROPOLIS[hero], player, hero)
end

function DoNecropolisRoutine_LevelUp(player, hero)
    startThread(LEVEL_UP_NECRO_HERO[hero], player, hero)
end

function DoNecropolisRoutine_AfterCombat(player, hero, index)
    startThread(AFTER_COMBAT_TRIGGER_NECROPOLIS[hero], player, hero, index)
end


-- print("Loaded Necropolis advmap routines")
ROUTINES_LOADED[NECROPOLIS] = 1
