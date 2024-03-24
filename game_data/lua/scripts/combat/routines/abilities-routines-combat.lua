
function Routine_AbilityCommandBallista()
    print("$ Routine_AbilityCommandBallista")
    local x,y = GetUnitPosition(CURRENT_UNIT)
    print("Position is x="..x..",y="..y)
    local ballista = GetWarMachine(CURRENT_UNIT_SIDE, WAR_MACHINE_BALLISTA)
    if ballista then
        if y == 5 or y == 6 then
            if x == CURRENT_UNIT_SIDE * 14 then
                setATB(ballista, ATB_NEXT) sleep()
                DefendCombatUnit(CURRENT_UNIT)
            end
        end
    end
end


COMBAT_PREPARE_ABILITIES_ROUTINES = {
}

COMBAT_START_ABILITIES_ROUTINES = {
}

COMBAT_TURN_ABILITIES_ROUTINES = {
    [CREATURE_MARKSMAN] = Routine_AbilityCommandBallista,
}

UNIT_DIED_ABILITIES_ROUTINES = {
}


function DoAbilitiesRoutine_CombatPrepare()
end

function DoAbilitiesRoutine_CombatStart()
end

function DoAbilitiesRoutine_CombatTurn()
    if IsCreature(CURRENT_UNIT) then
        local type = GetCreatureType(CURRENT_UNIT)
        if COMBAT_TURN_ABILITIES_ROUTINES[type] then
            COMBAT_TURN_ABILITIES_ROUTINES[type]()
        end
    end
end

function DoAbilitiesRoutine_UnitDied(unit)
    for cr,routine in UNIT_DIED_ABILITIES_ROUTINES do
        
    end
end


-- print("Loaded abilities-routines-combat.lua")
ROUTINES_LOADED[10] = 1
