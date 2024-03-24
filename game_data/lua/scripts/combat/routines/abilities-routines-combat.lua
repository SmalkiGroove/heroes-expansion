


COMBAT_PREPARE_ABILITIES_ROUTINES = {
}

COMBAT_START_ABILITIES_ROUTINES = {
}

COMBAT_TURN_ABILITIES_ROUTINES = {
}

UNIT_DIED_ABILITIES_ROUTINES = {
}


function DoArtifactRoutine_CombatPrepare(side, name, id)
    for cr,routine in COMBAT_PREPARE_ABILITIES_ROUTINES do
        
    end
end

function DoArtifactRoutine_CombatStart(side, name, id)
    for cr,routine in COMBAT_START_ABILITIES_ROUTINES do
        
    end
end

function DoArtifactRoutine_CombatTurn(side, name, id)
    for cr,routine in COMBAT_TURN_ABILITIES_ROUTINES do
        
    end
end

function DoArtifactRoutine_UnitDied(side, name, id, unit)
    for cr,routine in UNIT_DIED_ABILITIES_ROUTINES do
        
    end
end


-- print("Loaded abilities-routines-combat.lua")
ROUTINES_LOADED[10] = 1
