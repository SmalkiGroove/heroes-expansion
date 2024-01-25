
function Routine_DuplicateGolemStack(side, hero)
    -- print("Trigger copy largest golems group !")
    local largest = 0
    local copied_stack = "none"
    local creatures = GetUnits(side, CREATURE)
    for i,cr in creatures do
        local type = GetCreatureType(cr)
        if type == CREATURE_IRON_GOLEM or type == CREATURE_STEEL_GOLEM or type == CREATURE_OBSIDIAN_GOLEM then
            local nb = GetCreatureNumber(cr)
            if nb > largest then
                largest = nb
                copied_stack = cr
            end
        end
    end
    if IsCombatUnit(copied_stack) then
        local x,y = GetUnitPosition(copied_stack)
        SummonCreatureStack_XY(side, GetCreatureType(copied_stack), largest, x, y+1)
    end
    COMBAT_PAUSE = 0
end

function Routine_CastMultipleVulnerability(side, hero)
    -- print("Trigger disrupting rays !")
    HeroCast_AllCreatures(hero, SPELL_DISRUPTING_RAY, FREE_MANA, side)
    COMBAT_PAUSE = 0
end

function Routine_CastRandomSlow(side, hero)
    -- print("Trigger random Slow !")
    if CURRENT_UNIT == hero and GetUnitManaPoints(hero) >= 20 then
        HeroCast_RandomCreature(hero, SPELL_SLOW, NO_COST, 1-side)
        if IsHuman(side) then SetATB_ID(hero, ATB_INSTANT) end
    end
    COMBAT_PAUSE = 0
end

ACADEMY_COMBAT_PREPARE = {
    [H_HAVEZ] = NoneRoutine,
    [H_MINASLI] = NoneRoutine,
    [H_JOSEPHINE] = NoneRoutine,
    [H_RAZZAK] = NoneRoutine,
    [H_DAVIUS] = NoneRoutine,
    [H_RISSA] = NoneRoutine,
    [H_GURVILIN] = NoneRoutine,
    [H_JHORA] = NoneRoutine,
    [H_CYRUS] = NoneRoutine,
    [H_FAIZ] = NoneRoutine,
    [H_MAAHIR] = NoneRoutine,
    [H_NATHIR] = NoneRoutine,
    [H_NUR] = NoneRoutine,
    [H_GALIB] = NoneRoutine,
    [H_ZEHIR] = NoneRoutine,
    [H_THEODORUS] = NoneRoutine,
    [H_EMILIA] = NoneRoutine,
}

ACADEMY_COMBAT_START = {
    [H_HAVEZ] = NoneRoutine,
    [H_MINASLI] = NoneRoutine,
    [H_JOSEPHINE] = NoneRoutine,
    [H_RAZZAK] = Routine_DuplicateGolemStack,
    [H_DAVIUS] = Routine_RakshasasAbility,
    [H_RISSA] = NoneRoutine,
    [H_GURVILIN] = Routine_CastMultipleVulnerability,
    [H_JHORA] = NoneRoutine,
    [H_CYRUS] = Routine_MagesCastMagicFist,
    [H_FAIZ] = NoneRoutine,
    [H_MAAHIR] = NoneRoutine,
    [H_NATHIR] = NoneRoutine,
    [H_NUR] = Routine_CastMultipleArcaneCrystals,
    [H_GALIB] = NoneRoutine,
    [H_ZEHIR] = Routine_CastSummonElementals,
    [H_THEODORUS] = NoneRoutine,
    [H_EMILIA] = Routine_CastSummonHive,
}

ACADEMY_COMBAT_TURN = {
    [H_HAVEZ] = NoneRoutine,
    [H_MINASLI] = Routine_BallistaMoveNext,
    [H_JOSEPHINE] = NoneRoutine,
    [H_RAZZAK] = NoneRoutine,
    [H_DAVIUS] = NoneRoutine,
    [H_RISSA] = Routine_CastRandomSlow,
    [H_GURVILIN] = NoneRoutine,
    [H_JHORA] = NoneRoutine,
    [H_CYRUS] = NoneRoutine,
    [H_FAIZ] = NoneRoutine,
    [H_MAAHIR] = NoneRoutine,
    [H_NATHIR] = NoneRoutine,
    [H_NUR] = NoneRoutine,
    [H_GALIB] = NoneRoutine,
    [H_ZEHIR] = NoneRoutine,
    [H_THEODORUS] = NoneRoutine,
    [H_EMILIA] = NoneRoutine,
}

ACADEMY_UNIT_DIED = {
    [H_HAVEZ] = NoneRoutine,
    [H_MINASLI] = NoneRoutine,
    [H_JOSEPHINE] = NoneRoutine,
    [H_RAZZAK] = NoneRoutine,
    [H_DAVIUS] = NoneRoutine,
    [H_RISSA] = NoneRoutine,
    [H_GURVILIN] = NoneRoutine,
    [H_JHORA] = NoneRoutine,
    [H_CYRUS] = NoneRoutine,
    [H_FAIZ] = NoneRoutine,
    [H_MAAHIR] = NoneRoutine,
    [H_NATHIR] = NoneRoutine,
    [H_NUR] = NoneRoutine,
    [H_GALIB] = NoneRoutine,
    [H_ZEHIR] = NoneRoutine,
    [H_THEODORUS] = NoneRoutine,
    [H_EMILIA] = NoneRoutine,
}


function DoAcademyRoutine_CombatPrepare(side, name, id)
    startThread(ACADEMY_COMBAT_PREPARE[name], side, id)
end

function DoAcademyRoutine_CombatStart(side, name, id)
    startThread(ACADEMY_COMBAT_START[name], side, id)
end

function DoAcademyRoutine_CombatTurn(side, name, id)
    startThread(ACADEMY_COMBAT_TURN[name], side, id)
end

function DoAcademyRoutine_UnitDied(side, name, id, unit)
    startThread(ACADEMY_UNIT_DIED[name], side, id, unit)
end


-- print("Loaded Academy combat routines")
ROUTINES_LOADED[ACADEMY] = 1
