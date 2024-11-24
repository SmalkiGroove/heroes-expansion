
function Routine_AbilityCommandBallista(side, unit)
    log("$ Routine_AbilityCommandBallista")
    if GetCreatureNumber(unit) > 10 then
        local x,y = GetUnitPosition(CURRENT_UNIT)
        local ballista = GetWarMachine(CURRENT_UNIT_SIDE, WAR_MACHINE_BALLISTA)
        if ballista then
            if y == 5 or y == 6 then
                if x == 2 + CURRENT_UNIT_SIDE * 13 then
                    ShowFlyingSign("/Text/Game/Scripts/Combat/BallistaCommander.txt", unit, 9)
                    setATB(ballista, 2*ATB_INSTANT) sleep()
                    if GetHero(side) and GetHeroName(GetHero(side)) == H_VITTORIO then
                        TryShootTarget(unit, RandomCreature(1-side,x))
                    else
                        DefendCombatUnit(unit)
                    end
                end
            end
        end 
    end
end

function Routine_AbilityRageOfTheForest(side, unit)
    log("$ Routine_AbilityRageOfTheForest")
    UseCombatAbility(unit, SPELL_ABILITY_RAGE_OF_THE_FOREST)
    SetATB_ID(unit, 0.1)
end

function Routine_AbilityMagneticField(side, unit)
    log("$ Routine_AbilityMagneticField")
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
    if unit ~= "none" and distance > 2 then
        MoveCombatUnit(unit, target[1], target[2])
    end
end

function Routine_AbilityMineField(side, unit)
    log("$ Routine_AbilityMineField")
    local x,y = GetUnitPosition(unit)
    local offset = 2 - 4 * side
    HeroCast_Area(unit, SPELL_LAND_MINE, FREE_MANA, x + offset, y)
end

function Routine_AbilityRefreshMana(side, unit, amount)
    log("$ Routine_AbilityRefreshMana")
    local cur = GetUnitManaPoints(unit)
    local max = GetUnitMaxManaPoints(unit)
    if cur < max then
        SetMana(unit, min(cur+amount,max))
    end
end

function Routine_AbilityRefreshMana5(side, unit)
    Routine_AbilityRefreshMana(side, unit, 5)
end


COMBAT_START_ABILITIES_ROUTINES = {
    [CREATURE_ANGER_TREANT] = Routine_AbilityRageOfTheForest,
    [CREATURE_RUNE_MAGE] = Routine_AbilityMineField,
    [CREATURE_FLAME_MAGE] = Routine_AbilityMineField,
    [CREATURE_FLAME_KEEPER] = Routine_AbilityMineField,
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


-- log("Loaded abilities-routines-combat.lua")
ROUTINES_LOADED[10] = 1
