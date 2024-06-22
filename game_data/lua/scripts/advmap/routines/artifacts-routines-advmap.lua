
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


function Routine_ArtifactRunicWar(player, hero, combatIndex)
    print("$ Routine_ArtifactRunicWar")
    ChangeHeroStat(hero, STAT_MANA_POINTS, 10)
end

Var_StaffLyreVictories = {}
function Routine_ArtifactStaffOfTheLyre(player, hero, combatIndex)
    print("$ Routine_ArtifactStaffOfTheLyre")
    if Var_StaffLyreVictories[hero] then
        local nb = Var_StaffLyreVictories[hero] + 1
        Var_StaffLyreVictories[hero] = nb
        if mod(nb, 5) == 0 then
            AddHeroLowestStat(player, hero, 1)
        end
    else
        Var_StaffLyreVictories[hero] = 1
    end
end

Var_PendantLyreVictories = {}
function Routine_ArtifactPendantOfTheLyre(player, hero, combatIndex)
    print("$ Routine_ArtifactPendantOfTheLyre")
    if Var_PendantLyreVictories[hero] then
        local nb = Var_PendantLyreVictories[hero] + 1
        Var_PendantLyreVictories[hero] = nb
        if mod(nb, 5) == 0 then
            local exp = 1000 + trunc(0.01 * GetHeroStat(hero, STAT_EXPERIENCE))
            AddHeroStatAmount(player, hero, STAT_EXPERIENCE, exp)
            AddHeroManaUnbound(player, hero, 100)
        end
    else
        Var_PendantLyreVictories[hero] = 1
    end
end


function Routine_ArtfsetSailor(player, hero)
    print("$ Routine_ArtfsetSailor")
    if IsHeroInBoat(hero) then
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 1000)
    end
end


function Routine_ArtfsetEnlighten(player, hero)
    print("$ Routine_ArtfsetEnlighten")
    AddHeroLowestStat(player, hero, 2)
end



CONTINUOUS_TRIGGER_ARTIFACTS_ROUTINES = {
}
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
    [ARTIFACT_RUNIC_WAR_AXE] = Routine_ArtifactRunicWar,
    [ARTIFACT_RUNIC_WAR_HARNESS] = Routine_ArtifactRunicWar,
}

CONTINUOUS_TRIGGER_ARTFSETS_ROUTINES = {
    [ARTFSET_SAILOR_3PC] = Routine_ArtfsetSailor,
}
DAILY_TRIGGER_ARTFSETS_ROUTINES = {
    [ARTFSET_NONE] = NoneRoutine,
}
WEEKLY_TRIGGER_ARTFSETS_ROUTINES = {
    [ARTFSET_NONE] = NoneRoutine,
}
LEVELUP_TRIGGER_ARTFSETS_ROUTINES = {
    [ARTFSET_ENLIGHTEN_4PC] = Routine_ArtfsetEnlighten,
}
AFTER_COMBAT_TRIGGER_ARTFSETS_ROUTINES = {
    [ARTFSET_NONE] = NoneRoutine,
}


function DoArtifactsRoutine_Continuous(player, hero)
    for k,v in CONTINUOUS_TRIGGER_ARTIFACTS_ROUTINES do
        if HasArtefact(hero, k, 1) then
            startThread(v, player, hero)
        end
    end
    for k,v in CONTINUOUS_TRIGGER_ARTFSETS_ROUTINES do
        if HERO_ARTFSETS_STATUS[hero][k] == 1 then
            startThread(v, player, hero)
        end
    end
end

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
