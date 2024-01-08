
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

function Routine_GainStats(player, hero)
    local level = GetHeroLevel(hero)
    if mod(level, 7) == 0 then
        AddHero_StatAmount(player, hero, STAT_ATTACK, 1)
        AddHero_StatAmount(player, hero, STAT_DEFENCE, 1)
    end
end

function Routine_GainArtifactCrownLead(player, hero)
    local level = GetHeroLevel(hero)
    if level == 10 then 
        GiveArtifact(hero, ARTIFACT_CROWN_OF_LEADER)
    end
end

function Routine_LearnSpellShaman(player, hero)
    if not HasHeroSkill(hero, 172) then
        local level = GetHeroLevel(hero)
        if mod(level, 2) == 0 then
            local type = random(SPELL_TYPE_LIGHT_MAGIC, SPELL_TYPE_SUMMONING_MAGIC, mod(level,5))
            local tier = ceil(level * 0.15)
            AddHero_RandomSpell(hero, type, tier)
        end
    end
end

function Routine_LearnSpellWitch(player, hero)
    if not HasHeroSkill(hero, 172) then
        local level = GetHeroLevel(hero)
        if mod(level, 2) == 0 then
            local type = random(SPELL_TYPE_DESTRUCTIVE_MAGIC, SPELL_TYPE_DARK_MAGIC, mod(level,5))
            local tier = ceil(level * 0.15)
            AddHero_RandomSpell(hero, type, tier)
        end
    end
end

function Routine_GainArtifactMachineRing(player, hero)
    local level = GetHeroLevel(hero)
    if level == 25 then 
        GiveArtifact(hero, ARTIFACT_RING_OF_MACHINE_AFFINITY)
    end
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


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

LEVEL_UP_STRONGHOLD_HERO = {
    [H_TELSEK] = NoneRoutine,
    [H_GORSHAK] = NoneRoutine,
    [H_GOTAI] = NoneRoutine,
    [H_AZAR] = NoneRoutine,
    [H_MATEWA] = NoneRoutine,
    [H_KUNYAK] = Routine_GainStats,
    [H_KRAGH] = NoneRoutine,
    [H_KILGHAN] = NoneRoutine,
    [H_CRAGHACK] = Routine_GainArtifactCrownLead,
    [H_KRAAL] = NoneRoutine,
    [H_SHAKKARUKAT] = Routine_LearnSpellShaman,
    [H_KUJIN] = Routine_LearnSpellShaman,
    [H_SHIVA] = Routine_LearnSpellShaman,
    [H_MUKHA] = Routine_LearnSpellShaman,
    [H_HAGGASH] = Routine_LearnSpellShaman,
    [H_URGHAT] = Routine_LearnSpellWitch,
    [H_GARUNA] = Routine_LearnSpellWitch,
    [H_ZOULEIKA] = Routine_LearnSpellWitch,
    [H_ERIKA] = Routine_LearnSpellWitch,
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

function DoStrongholdRoutine_LevelUp(player, hero)
    startThread(LEVEL_UP_STRONGHOLD_HERO[hero], player, hero)
end

function DoStrongholdRoutine_AfterCombat(player, hero, index)
    startThread(AFTER_COMBAT_TRIGGER_TRONGHOLD[hero], player, hero, index)
end


-- print("Loaded Stronghold advmap routines")
ROUTINES_LOADED[STRONGHOLD] = 1
