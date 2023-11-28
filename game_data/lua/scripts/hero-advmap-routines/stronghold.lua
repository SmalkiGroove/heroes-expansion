
function Routine_GainStats()
    local hero = H_KUNYAK
    local player = GetObjectOwner(hero)
    local level = GetHeroLevel(hero)
    if mod(level, 7) == 0 then
        AddHero_StatAmount(player, hero, STAT_ATTACK, 1)
        AddHero_StatAmount(player, hero, STAT_DEFENCE, 1)
    end
end

function Routine_GainArtifactCrownLead()
    local hero = H_CRAGHACK
    local level = GetHeroLevel(hero)
    if level == 10 then 
        GiveArtifact(hero, ARTIFACT_CROWN_OF_LEADER)
    end
end

function Routine_LearnSpellShaman(hero)
    if not HasHeroSkill(hero, HERO_SKILL_DEMONIC_RAGE) then
        local level = GetHeroLevel(hero)
        if mod(level, 2) == 0 then
            local type = random(SPELL_TYPE_LIGHT_MAGIC, SPELL_TYPE_SUMMONING_MAGIC, mod(level,5))
            local tier = ceil(level * 0.15)
            AddHero_RandomSpell(hero, type, tier)
        end
    end
end

function Routine_LearnSpellShaman1()
    Routine_LearnSpellShaman(H_SHAKKARUKAT)
end

function Routine_LearnSpellShaman2()
    Routine_LearnSpellShaman(H_KUJIN)
end

function Routine_LearnSpellShaman3()
    Routine_LearnSpellShaman(H_SHIVA)
end

function Routine_LearnSpellShaman4()
    Routine_LearnSpellShaman(H_MUKHA)
end

function Routine_LearnSpellShaman5()
    Routine_LearnSpellShaman(H_HAGGASH)
end

function Routine_LearnSpellWitch(hero)
    if not HasHeroSkill(hero, HERO_SKILL_DEMONIC_RAGE) then
        local level = GetHeroLevel(hero)
        if mod(level, 2) == 0 then
            local type = random(SPELL_TYPE_DESTRUCTIVE_MAGIC, SPELL_TYPE_DARK_MAGIC, mod(level,5))
            local tier = ceil(level * 0.15)
            AddHero_RandomSpell(hero, type, tier)
        end
    end
end

function Routine_LearnSpellWitch1()
    Routine_LearnSpellWitch(H_URGHAT)
end

function Routine_LearnSpellWitch2()
    Routine_LearnSpellWitch(H_GARUNA)
end

function Routine_LearnSpellWitch3()
    Routine_LearnSpellWitch(H_ZOULEIKA)
end

function Routine_LearnSpellWitch4()
    Routine_LearnSpellWitch(H_ERIKA)
end

function Routine_GainArtifactMachineRing()
    local hero = H_GARUNA
    local level = GetHeroLevel(hero)
    if level == 25 then 
        GiveArtifact(hero, ARTIFACT_RING_OF_MACHINE_AFFINITY)
    end
end

function Routine_AddHeroWyverns(player, hero)
    -- Wyvern - 1:10 - 2:30 - 3:50
    AddHero_CreatureInTypes(player, hero, {CREATURE_WYVERN,CREATURE_WYVERN_POISONOUS,CREATURE_WYVERN_PAOKAI}, 0.05)
end

function Routine_HeroCallCentaurs(player, hero)
    -- Centaurs - 1 * level transfered
    AddHero_CreatureFromDwelling(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_CENTAUR_MARADEUR, 1.0)
end

function Routine_AddRecruitsShamans(player, hero)
    -- Shamans - 3 * level recruits per week
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_2, CREATURE_SHAMAN, 3.0)
end

function Routine_AddRecruitsCyclops(player, hero)
    -- Cyclops - 0.2 * level recruits per week
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_7, CREATURE_CYCLOP, 0.2)
end

function Routine_AddHeroTitans(player, hero)
    -- Titans - 1:7 - 2:20 - 3:34 - 4:47
    AddHero_CreatureType(player, hero, CREATURE_TITAN, 0.075)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


LEVEL_UP_STRONGHOLD_HERO = {
    [H_TELSEK] = "NoneRoutine",
    [H_GORSHAK] = "NoneRoutine",
    [H_GOTAI] = "NoneRoutine",
    [H_AZAR] = "NoneRoutine",
    [H_MATEWA] = "NoneRoutine",
    [H_KUNYAK] = "Routine_GainStats",
    [H_KRAGH] = "NoneRoutine",
    [H_KILGHAN] = "NoneRoutine",
    [H_CRAGHACK] = "Routine_GainArtifactCrownLead",
    [H_KRAAL] = "NoneRoutine",
    [H_SHAKKARUKAT] = "Routine_LearnSpellShaman1",
    [H_KUJIN] = "Routine_LearnSpellShaman2",
    [H_SHIVA] = "Routine_LearnSpellShaman3",
    [H_MUKHA] = "Routine_LearnSpellShaman4",
    [H_HAGGASH] = "Routine_LearnSpellShaman5",
    [H_URGHAT] = "Routine_LearnSpellWitch1",
    [H_GARUNA] = "Routine_LearnSpellWitch2",
    [H_ZOULEIKA] = "Routine_LearnSpellWitch3",
    [H_ERIKA] = "Routine_LearnSpellWitch4",
}

START_TRIGGER_STRONGHOLD = {
    [H_TELSEK] = NoneRoutine,
    [H_GORSHAK] = NoneRoutine,
    [H_GOTAI] = NoneRoutine,
    [H_AZAR] = NoneRoutine,
    [H_MATEWA] = NoneRoutine,
    [H_KUNYAK] = NoneRoutine,
    [H_KRAGH] = NoneRoutine,
    [H_KILGHAN] = NoneRoutine,
    [H_CRAGHACK] = NoneRoutine,
    [H_KRAAL] = NoneRoutine,
    [H_SHAKKARUKAT] = NoneRoutine,
    [H_KUJIN] = NoneRoutine,
    [H_SHIVA] = NoneRoutine,
    [H_MUKHA] = NoneRoutine,
    [H_HAGGASH] = NoneRoutine,
    [H_URGHAT] = NoneRoutine,
    [H_GARUNA] = NoneRoutine,
    [H_ZOULEIKA] = NoneRoutine,
    [H_ERIKA] = NoneRoutine,
}

DAILY_TRIGGER_STRONGHOLD = {
    [H_TELSEK] = NoneRoutine,
    [H_GORSHAK] = NoneRoutine,
    [H_GOTAI] = NoneRoutine,
    [H_AZAR] = NoneRoutine,
    [H_MATEWA] = NoneRoutine,
    [H_KUNYAK] = NoneRoutine,
    [H_KRAGH] = NoneRoutine,
    [H_KILGHAN] = NoneRoutine,
    [H_CRAGHACK] = NoneRoutine,
    [H_KRAAL] = NoneRoutine,
    [H_SHAKKARUKAT] = Routine_AddHeroWyverns,
    [H_KUJIN] = NoneRoutine,
    [H_SHIVA] = NoneRoutine,
    [H_MUKHA] = NoneRoutine,
    [H_HAGGASH] = NoneRoutine,
    [H_URGHAT] = NoneRoutine,
    [H_GARUNA] = NoneRoutine,
    [H_ZOULEIKA] = NoneRoutine,
    [H_ERIKA] = NoneRoutine,
}

WEEKLY_TRIGGER_TRONGHOLD = {
    [H_TELSEK] = NoneRoutine,
    [H_GORSHAK] = Routine_HeroCallCentaurs,
    [H_GOTAI] = NoneRoutine,
    [H_AZAR] = NoneRoutine,
    [H_MATEWA] = Routine_AddRecruitsCyclops,
    [H_KUNYAK] = NoneRoutine,
    [H_KRAGH] = NoneRoutine,
    [H_KILGHAN] = NoneRoutine,
    [H_CRAGHACK] = NoneRoutine,
    [H_KRAAL] = NoneRoutine,
    [H_SHAKKARUKAT] = NoneRoutine,
    [H_KUJIN] = NoneRoutine,
    [H_SHIVA] = Routine_AddRecruitsShamans,
    [H_MUKHA] = Routine_AddHeroTitans,
    [H_HAGGASH] = NoneRoutine,
    [H_URGHAT] = NoneRoutine,
    [H_GARUNA] = NoneRoutine,
    [H_ZOULEIKA] = NoneRoutine,
    [H_ERIKA] = NoneRoutine,
}

AFTER_COMBAT_TRIGGER_TRONGHOLD = {
    [H_TELSEK] = NoneRoutine,
    [H_GORSHAK] = NoneRoutine,
    [H_GOTAI] = NoneRoutine,
    [H_AZAR] = NoneRoutine,
    [H_MATEWA] = NoneRoutine,
    [H_KUNYAK] = NoneRoutine,
    [H_KRAGH] = NoneRoutine,
    [H_KILGHAN] = NoneRoutine,
    [H_CRAGHACK] = NoneRoutine,
    [H_KRAAL] = NoneRoutine,
    [H_SHAKKARUKAT] = NoneRoutine,
    [H_KUJIN] = NoneRoutine,
    [H_SHIVA] = NoneRoutine,
    [H_MUKHA] = NoneRoutine,
    [H_HAGGASH] = NoneRoutine,
    [H_URGHAT] = NoneRoutine,
    [H_GARUNA] = NoneRoutine,
    [H_ZOULEIKA] = NoneRoutine,
    [H_ERIKA] = NoneRoutine,
}


function DoStrongholdRoutine_Start(player, hero)
    startThread(START_TRIGGER_STRONGHOLD[hero], player, hero)
end

function DoStrongholdRoutine_Daily(player, hero)
    startThread(DAILY_TRIGGER_STRONGHOLD[hero], player, hero)
end

function DoStrongholdRoutine_Weekly(player, hero)
    startThread(WEEKLY_TRIGGER_TRONGHOLD[hero], player, hero)
end

function DoStrongholdRoutine_AfterCombat(player, hero, index)
    startThread(AFTER_COMBAT_TRIGGER_TRONGHOLD[hero], player, hero, index)
end

function DoStrongholdRoutine_LevelUp(hero)
    Trigger(HERO_LEVELUP_TRIGGER, hero, LEVEL_UP_STRONGHOLD_HERO[hero])
end


-- print("Loaded Stronghold advmap routines")
ROUTINES_LOADED[STRONGHOLD] = 1
