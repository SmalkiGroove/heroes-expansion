
function Routine_ArtifactMoonCharm(side, hero, unit)
    log("$ Routine_ArtifactMoonCharm")
    if not ROUTINE_VARS.MoonCharm then
        if GetUnitSide(unit) == side and ROUTINE_VARS.InitialCounts[unit] then
            local type = GetCreatureType(unit)
            local x,y = GetUnitPosition(unit)
            local amount = ROUTINE_VARS.InitialCounts[unit]
            AddCreature(side, type, amount, x, y)
            ROUTINE_VARS.MoonCharm = not nil
        end
    end
end


COMBAT_PREPARE_ARTIFACT_ROUTINES = {
}
COMBAT_START_ARTIFACT_ROUTINES = {
}
COMBAT_TURN_ARTIFACT_ROUTINES = {
}
UNIT_DIED_ARTIFACT_ROUTINES = {
    [ARTIFACT_MOON_CHARM] = Routine_ArtifactMoonCharm,
}

COMBAT_PREPARE_ARTFSET_ROUTINES = {
}
COMBAT_START_ARTFSET_ROUTINES = {
}
COMBAT_TURN_ARTFSET_ROUTINES = {
}
UNIT_DIED_ARTFSET_ROUTINES = {
}


function DoArtifactRoutine_CombatPrepare(side, name, id)
    for a,routine in COMBAT_PREPARE_ARTIFACT_ROUTINES do
        if HasHeroEquippedArtifact(side, a) then routine(side, id) end
    end
    for a,routine in COMBAT_PREPARE_ARTFSET_ROUTINES do
        if HasHeroActiveArtifactSet(side, a) then routine(side, id) end
    end
end

function DoArtifactRoutine_CombatStart(side, name, id)
    for a,routine in COMBAT_START_ARTIFACT_ROUTINES do
        if HasHeroEquippedArtifact(side, a) then routine(side, id) end
    end
    for a,routine in COMBAT_START_ARTFSET_ROUTINES do
        if HasHeroActiveArtifactSet(side, a) then routine(side, id) end
    end
end

function DoArtifactRoutine_CombatTurn(side, name, id)
    for a,routine in COMBAT_TURN_ARTIFACT_ROUTINES do
        if HasHeroEquippedArtifact(side, a) then routine(side, id) end
    end
    for a,routine in COMBAT_TURN_ARTFSET_ROUTINES do
        if HasHeroActiveArtifactSet(side, a) then routine(side, id) end
    end
end

function DoArtifactRoutine_UnitDied(side, name, id, unit)
    for a,routine in UNIT_DIED_ARTIFACT_ROUTINES do
        if HasHeroEquippedArtifact(side, a) then routine(side, id, unit) end
    end
    for a,routine in UNIT_DIED_ARTFSET_ROUTINES do
        if HasHeroActiveArtifactSet(side, a) then routine(side, id, unit) end
    end
end


-- log("Loaded artifacts-routines-combat.lua")
ROUTINES_LOADED[13] = 1
