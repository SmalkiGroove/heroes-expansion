


COMBAT_PREPARE_ARTFSET_ROUTINES = {
}

COMBAT_START_ARTFSET_ROUTINES = {
}

COMBAT_TURN_ARTFSET_ROUTINES = {
}

UNIT_DIED_ARTFSET_ROUTINES = {
}


function DoArtifactRoutine_CombatPrepare(side, name, id)
    for a,routine in COMBAT_PREPARE_ARTFSET_ROUTINES do
        
    end
end

function DoArtifactRoutine_CombatStart(side, name, id)
    for a,routine in COMBAT_START_ARTFSET_ROUTINES do
        
    end
end

function DoArtifactRoutine_CombatTurn(side, name, id)
    for a,routine in COMBAT_TURN_ARTFSET_ROUTINES do
        
    end
end

function DoArtifactRoutine_UnitDied(side, name, id, unit)
    for a,routine in UNIT_DIED_ARTFSET_ROUTINES do
        
    end
end


-- print("Loaded artifacts-routines-combat.lua")
ROUTINES_LOADED[13] = 1
