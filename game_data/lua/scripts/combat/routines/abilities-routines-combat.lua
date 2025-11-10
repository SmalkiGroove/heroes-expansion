
function Routine_AbilityCommandBallista(side, unit)
    log(DEBUG, "$ Routine_AbilityCommandBallista")
    local growth = {[CREATURE_MARKSMAN] = 30}
    if not ROUTINE_VARS.BallistaCommanders[unit] then
        ROUTINE_VARS.BallistaCommanders[unit] = 1
    end
    local ballista = GetWarMachine(side, WAR_MACHINE_BALLISTA)
    if ballista then
        local x,y = GetUnitPosition(unit)
        if y == 5 or y == 6 then
            if x == 2 + side * 13 then
                local type = GetCreatureType(unit)
                local nb = GetCreatureNumber(unit)
                if nb >= growth[type] then
                    if ROUTINE_VARS.BallistaCommanders[unit] == 1 then
                        local value = 10 * growth[type]
                        value = nb / value
                        value = min(ATB_NEXT, value)
                        ShowFlyingSign("/Text/Game/Scripts/Combat/BallistaCommander.txt", unit, 9)
                        setATB(ballista, 2*ATB_INSTANT) sleep()
                        setATB(unit, value)
                    end
                    ROUTINE_VARS.BallistaCommanders[unit] = 1 - ROUTINE_VARS.BallistaCommanders[unit]
                end
            end
        end
    end
end

function Routine_AbilityRageOfTheForest(side, unit)
    log(DEBUG, "$ Routine_AbilityRageOfTheForest")
    UseCombatAbility(unit, SPELL_ABILITY_RAGE_OF_THE_FOREST)
end

function Routine_AbilityMagneticField(side, unit)
    log(DEBUG, "$ Routine_AbilityMagneticField")
    local nb = GetCreatureNumber(unit)
    local x,y = GetUnitPosition(unit)
    local enemy = "none"
    local distance = 1000
    local target = {x=0,y=0}
    for i,cr in GetUnits(1-side, CREATURE) do
        local type = GetCreatureType(cr)
        local tier = CREATURES[type][2]
        if tier <= 3 then
            local xx,yy = GetUnitPosition(cr)
            local dx = x-xx
            local dy = y-yy
            local d = dx*dx + dy*dy
            if d > 2 and d < distance then
                enemy = cr
                distance = d
                if 2*dx*dx >= dy*dy then target.x = xx+sign(dx) else target.x = xx end
                if 2*dy*dy >= dx*dx then target.y = yy+sign(dy) else target.y = yy end
            end
        end
    end
    if enemy ~= "none" then
        startThread(MoveCombatUnit, enemy, target.x, target.y)
    end
end

function Routine_AbilityMineField(side, unit)
    log(DEBUG, "$ Routine_AbilityMineField")
    local x,y = GetUnitPosition(unit)
    local offset = 2 - 4 * side
    HeroCast_Area(unit, SPELL_LAND_MINE, FREE_MANA, x + offset, y)
end

function Routine_AbilityRefreshMana4(side, unit)
    RefreshMana(side, unit, 4)
end

function Routine_AbilityRefreshMana20Percent(side, unit)
    local value = round(GetUnitMaxManaPoints(unit) * 0.2)
    RefreshMana(side, unit, value)
end

function Routine_AbilityManaTempest(side, unit)
    log(DEBUG, "$ Routine_AbilityManaTempest")
    startThread(Routine_AbilityManaTempestThread, side, unit)
end



COMBAT_START_ABILITIES_ROUTINES = {
    [CREATURE_ANGER_TREANT] = Routine_AbilityRageOfTheForest,
}

COMBAT_TURN_ABILITIES_ROUTINES = {
    [CREATURE_MARKSMAN] = Routine_AbilityCommandBallista,
    -- [CREATURE_OBSIDIAN_GOLEM] = Routine_AbilityMagneticField,
}

UNIT_DIED_ABILITIES_ROUTINES = {
}


function DoAbilitiesRoutine_CombatStart()
    for _,cr in GetUnits(ATTACKER, CREATURE) do
        local type = GetCreatureType(cr)
        if COMBAT_START_ABILITIES_ROUTINES[type] then
            COMBAT_START_ABILITIES_ROUTINES[type](ATTACKER, cr)
        end
    end
    for _,cr in GetUnits(DEFENDER, CREATURE) do
        local type = GetCreatureType(cr)
        if COMBAT_START_ABILITIES_ROUTINES[type] then
            COMBAT_START_ABILITIES_ROUTINES[type](DEFENDER, cr)
        end
    end
end

function DoAbilitiesRoutine_CombatTurn()
    if IsCreature(CURRENT_UNIT) then
        local type = GetCreatureType(CURRENT_UNIT)
        if COMBAT_TURN_ABILITIES_ROUTINES[type] then
            COMBAT_TURN_ABILITIES_ROUTINES[type](CURRENT_UNIT_SIDE, CURRENT_UNIT)
        end
    end
end

function DoAbilitiesRoutine_UnitDied(unit)
end


-- log(TRACE, "Loaded abilities-routines-combat.lua")
ROUTINES_LOADED[10] = 1
