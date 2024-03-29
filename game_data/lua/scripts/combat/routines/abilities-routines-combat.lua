
function Routine_AbilityCommandBallista()
    print("$ Routine_AbilityCommandBallista")
    local x,y = GetUnitPosition(CURRENT_UNIT)
    local ballista = GetWarMachine(CURRENT_UNIT_SIDE, WAR_MACHINE_BALLISTA)
    if ballista then
        if y == 5 or y == 6 then
            if x == 2 + CURRENT_UNIT_SIDE * 13 then
                setATB(ballista, ATB_INSTANT) sleep()
                DefendCombatUnit(CURRENT_UNIT)
            end
        end
    end
end

function Routine_AbilityMagneticField()
    print("$ Routine_AbilityMagneticField")
    local x,y = GetUnitPosition(CURRENT_UNIT)
    local unit = "none"
    local distance = 1000
    local target = {0,0}
    for i,cr in GetUnits(1-CURRENT_UNIT_SIDE, CREATURE) do
        local type = GetCreatureType(cr)
        if CREATURES[type][2] <= 3 then
            local xx,yy = GetUnitPosition(cr)
            local dx = x-xx
            local dy = y-yy
            local d = dx*dx + dy*dy
            if d < distance then
                unit = cr
                distance = d
                if 2*dx*dx >= dy*dy then target[1] = xx+sign(dx) else target[1] = xx end
                if 2*dy*dy >= dx*dx then target[2] = yy+sign(dy) else target[2] = yy end
            end
        end
    end
    if distance > 2 then
        SetCombatPosition(unit, target[1], target[2])
    end
end


COMBAT_START_ABILITIES_ROUTINES = {
}

COMBAT_TURN_ABILITIES_ROUTINES = {
    [CREATURE_MARKSMAN] = Routine_AbilityCommandBallista,
    [CREATURE_OBSIDIAN_GOLEM] = Routine_AbilityMagneticField,
}

UNIT_DIED_ABILITIES_ROUTINES = {
}


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
end


-- print("Loaded abilities-routines-combat.lua")
ROUTINES_LOADED[10] = 1
