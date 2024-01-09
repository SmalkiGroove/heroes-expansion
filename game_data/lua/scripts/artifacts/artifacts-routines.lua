
function Routine_ArtifactSackOfGolds(player, hero)
    local level = GetHeroLevel(hero)
    AddPlayer_Resource(player, hero, GOLD, level * 25)
end


DAILY_TRIGGER_ARTIFACTS_ROUTINES = {
    [ARTIFACT_NONE] = NoneRoutine,
    [ARTIFACT_ENDLESS_BAG_OF_GOLD] = Routine_ArtifactSackOfGolds,
}
WEEKLY_TRIGGER_ARTIFACTS_ROUTINES = {
    [ARTIFACT_NONE] = NoneRoutine,
}
LEVELUP_TRIGGER_ARTIFACTS_ROUTINES = {
    [ARTIFACT_NONE] = NoneRoutine,
}
AFTER_COMBAT_TRIGGER_ARTIFACTS_ROUTINES = {
    [ARTIFACT_NONE] = NoneRoutine,
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
        if contains(HERO_ACTIVE_ARTIFACT_SETS[hero], k) then
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
        if contains(HERO_ACTIVE_ARTIFACT_SETS[hero], k) then
            startThread(v, player, hero)
        end
    end
end

function DoArtifactsRoutine_LevelUp(player, hero)
    for k,v in LEVELUP_TRIGGER_ARTIFACTS_ROUTINES do
        if HasArtefact(hero, k, 1) then
            startThread(v, player, hero)
        end
    end
    for k,v in LEVELUP_TRIGGER_ARTFSETS_ROUTINES do
        if contains(HERO_ACTIVE_ARTIFACT_SETS[hero], k) then
            startThread(v, player, hero)
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
        if contains(HERO_ACTIVE_ARTIFACT_SETS[hero], k) then
            startThread(v, player, hero, index)
        end
    end
end


-- print("Loaded artifacts advmap routines")
ROUTINES_LOADED[13] = 1
