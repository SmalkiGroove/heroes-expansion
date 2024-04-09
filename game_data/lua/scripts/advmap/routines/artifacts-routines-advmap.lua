
function Routine_ArtifactPouchOfGolds(player, hero)
    print("$ Routine_ArtifactPouchOfGolds")
    local level = GetHeroLevel(hero)
    AddPlayerResource(player, hero, GOLD, level * 25)
end

function Routine_ArtifactSackOfGolds(player, hero)
    print("$ Routine_ArtifactSackOfGolds")
    local level = GetHeroLevel(hero)
    AddPlayerResource(player, hero, GOLD, level * 50)
end


function Routine_ArtifactHornOfPlenty(player, hero)
    print("$ Routine_ArtifactHornOfPlenty")
    AddPlayerResource(player, hero, WOOD, 1)
    AddPlayerResource(player, hero, ORE, 1)
    AddPlayerResource(player, hero, MERCURY, 1)
    AddPlayerResource(player, hero, CRYSTAL, 1)
    AddPlayerResource(player, hero, SULFUR, 1)
    AddPlayerResource(player, hero, GEM, 1)
end


function Routine_ArtifactGreatLich(player, hero)
    print("$ Routine_ArtifactGreatLich")
    AddHeroCreatureType(player, hero, {CREATURE_LICH,CREATURE_DEMILICH,CREATURE_LICH_MASTER}, 1)
end


function Routine_Restore10Mana(player, hero, combatIndex)
    print("$ Routine_Restore10Mana")
    ChangeHeroStat(hero, STAT_MANA_POINTS, 10)
end

function Routine_HarpyBoots(player, hero, combatIndex)
    print("$ Routine_HarpyBoots")
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_INITIATIVE, 1)
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_SPEED, 1)
end



DAILY_TRIGGER_ARTIFACTS_ROUTINES = {
    [ARTIFACT_ENDLESS_POUCH_OF_GOLD] = Routine_ArtifactPouchOfGolds,
    [ARTIFACT_ENDLESS_SACK_OF_GOLD] = Routine_ArtifactSackOfGolds,
}
WEEKLY_TRIGGER_ARTIFACTS_ROUTINES = {
    [ARTIFACT_HORN_OF_PLENTY] = Routine_ArtifactHornOfPlenty,
}
LEVELUP_TRIGGER_ARTIFACTS_ROUTINES = {
    [ARTIFACT_SANDROS_CLOAK] = Routine_ArtifactGreatLich,
}
AFTER_COMBAT_TRIGGER_ARTIFACTS_ROUTINES = {
    [ARTIFACT_RUNIC_WAR_AXE] = Routine_Restore10Mana,
    [ARTIFACT_RUNIC_WAR_HARNESS] = Routine_Restore10Mana,
}

DAILY_TRIGGER_ARTFSETS_ROUTINES = {
    [ARTFSET_NONE] = NoneRoutine,
}
WEEKLY_TRIGGER_ARTFSETS_ROUTINES = {
    [ARTFSET_NONE] = NoneRoutine,
}
LEVELUP_TRIGGER_ARTFSETS_ROUTINES = {
    [ARTFSET_NONE] = NoneRoutine,
}
AFTER_COMBAT_TRIGGER_ARTFSETS_ROUTINES = {
    [ARTFSET_NONE] = NoneRoutine,
}


function DoArtifactsRoutine_Daily(player, hero)
    for k,v in DAILY_TRIGGER_ARTIFACTS_ROUTINES do
        if HasArtefact(hero, k, 1) then
            startThread(v, player, hero)
        end
    end
    for k,v in DAILY_TRIGGER_ARTFSETS_ROUTINES do
        if HERO_ARTFSETS_STATUS[hero][k] == 1 then
            startThread(v, player, hero)
        end
    end
end

function DoArtifactsRoutine_Weekly(player, hero)
    for k,v in WEEKLY_TRIGGER_ARTIFACTS_ROUTINES do
        if HasArtefact(hero, k, 1) then
            startThread(v, player, hero)
        end
    end
    for k,v in WEEKLY_TRIGGER_ARTFSETS_ROUTINES do
        if HERO_ARTFSETS_STATUS[hero][k] == 1 then
            startThread(v, player, hero)
        end
    end
end

function DoArtifactsRoutine_LevelUp(player, hero, level)
    for k,v in LEVELUP_TRIGGER_ARTIFACTS_ROUTINES do
        if HasArtefact(hero, k, 1) then
            startThread(v, player, hero, level)
        end
    end
    for k,v in LEVELUP_TRIGGER_ARTFSETS_ROUTINES do
        if HERO_ARTFSETS_STATUS[hero][k] == 1 then
            startThread(v, player, hero, level)
        end
    end
end

function DoArtifactsRoutine_AfterCombat(player, hero, index)
    for k,v in AFTER_COMBAT_TRIGGER_ARTIFACTS_ROUTINES do
        if HasArtefact(hero, k, 1) then
            startThread(v, player, hero, index)
        end
    end
    for k,v in AFTER_COMBAT_TRIGGER_ARTFSETS_ROUTINES do
        if HERO_ARTFSETS_STATUS[hero][k] == 1 then
            startThread(v, player, hero, index)
        end
    end
end


-- print("Loaded artifacts-routines-advmap.lua")
ROUTINES_LOADED[12] = 1
