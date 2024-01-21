
function Routine_AddHeroDefenders(player, hero)
    print("$ Routine_AddHeroDefenders")
    AddHero_CreatureInTypes(player, hero, {CREATURE_DEFENDER,CREATURE_STOUT_DEFENDER,CREATURE_STONE_DEFENDER}, 0.4)
end

function Routine_AddRecruitsBearRiders(player, hero)
    print("$ Routine_AddRecruitsBearRiders")
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_BEAR_RIDER, 1.5)
end

function Routine_RezSpearwielders(player, hero, combatIndex)
    print("$ Routine_RezSpearwielders")
    local cap = 5 + GetHeroLevel(hero)
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 1)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 1, i)
        if died > 0 and contains({CREATURE_AXE_FIGHTER,CREATURE_AXE_THROWER,CREATURE_HARPOONER}, creature) then
            local rez = min(cap, died)
            AddHeroCreatures(hero, creature, rez)
        end
    end
end

function Routine_GiveArtifactRingOfMachineAffinity(player, hero)
    print("$ Routine_GiveArtifactRingOfMachineAffinity")
    GiveArtifact(hero, ARTIFACT_RING_OF_MACHINE_AFFINITY, 1)
end

function Routine_UpgradeRunePriests(player, hero)
    print("$ Routine_UpgradeRunePriests")
    ChangeHero_CreatureUpgrade(player, hero, CREATURE_RUNE_MAGE, CREATURE_FLAME_MAGE)
end

function Routine_AddLuckAndMorale(player, hero)
    print("$ Routine_AddLuckAndMorale")
    ChangeHeroStat(hero, STAT_LUCK, 2)
    ChangeHeroStat(hero, STAT_MORALE, 2)
end

function Routine_GiveArtifactRuneOfFlame(player, hero)
    print("$ Routine_GiveArtifactRuneOfFlame")
    GiveArtifact(hero, ARTIFACT_RUNE_OF_FLAME, 1)
end

function Routine_GenerateCrystalsAndGems(player, hero)
    print("$ Routine_GenerateCrystalsAndGems")
    local n = ceil(GetHeroLevel(hero) * 0.1)
    for rune = SPELL_RUNE_OF_CHARGE,SPELL_RUNE_OF_DRAGONFORM do
        if KnowHeroSpell(hero, rune) then n = n+1 end
    end
    local split = mod(TURN,n)
    AddPlayer_Resource(player, hero, CRYSTAL, split)
    AddPlayer_Resource(player, hero, GEM, n-split)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


START_TRIGGER_FORTRESS = {
    [H_WULFSTAN] = Routine_GiveArtifactRingOfMachineAffinity,
    [H_TOLGHAR] = Routine_AddLuckAndMorale,
    [H_EBBA] = Routine_GiveArtifactRuneOfFlame,
}

DAILY_TRIGGER_FORTRESS = {
    [H_INGVAR] = Routine_AddHeroDefenders,
    [H_ERLING] = Routine_UpgradeRunePriests,
}

WEEKLY_TRIGGER_FORTRESS = {
    [H_ROLF] = Routine_AddRecruitsBearRiders,
    [H_EBBA] = Routine_GenerateCrystalsAndGems,
}

LEVEL_UP_FORTRESS_HERO = {
}

AFTER_COMBAT_TRIGGER_FORTRESS = {
    [H_KARLI] = Routine_RezSpearwielders,
}


function DoFortressRoutine_Start(player, hero)
    if START_TRIGGER_FORTRESS[hero] then
        startThread(START_TRIGGER_FORTRESS[hero], player, hero)
    end
end

function DoFortressRoutine_Daily(player, hero)
    if DAILY_TRIGGER_FORTRESS[hero] then
        startThread(DAILY_TRIGGER_FORTRESS[hero], player, hero)
    end
end

function DoFortressRoutine_Weekly(player, hero)
    if WEEKLY_TRIGGER_FORTRESS[hero] then
        startThread(WEEKLY_TRIGGER_FORTRESS[hero], player, hero)
    end
end

function DoFortressRoutine_LevelUp(player, hero, level)
    if LEVEL_UP_FORTRESS_HERO[hero] then
        startThread(LEVEL_UP_FORTRESS_HERO[hero], player, hero, level)
    end
end

function DoFortressRoutine_AfterCombat(player, hero, index)
    if AFTER_COMBAT_TRIGGER_FORTRESS[hero] then
        startThread(AFTER_COMBAT_TRIGGER_FORTRESS[hero], player, hero, index)
    end
end


-- print("Loaded Fortress advmap routines")
ROUTINES_LOADED[FORTRESS] = 1
