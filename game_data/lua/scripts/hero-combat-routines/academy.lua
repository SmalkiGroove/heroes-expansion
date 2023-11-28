
function Routine_DuplicateGolemStack(side, hero, data)
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

function Routine_RakshasasAbility(side, hero, data)
    -- print("Trigger rakshasas dash !")
    CreatureTypesAbility_Untargeted(side, {CREATURE_RAKSHASA,CREATURE_RAKSHASA_RUKH,CREATURE_RAKSHASA_KSHATRI}, SPELL_ABILITY_DASH)
    COMBAT_PAUSE = 0
end

function Routine_CastMultipleVulnerability(side, hero, data)
    -- print("Trigger disrupting rays !")
    HeroCast_AllCreatures(hero, SPELL_DISRUPTING_RAY, FREE_MANA, side)
    COMBAT_PAUSE = 0
end

function Routine_MagesCastMagicFist(side, hero, data)
    -- print("Trigger mages magic fist !")
    CreatureTypesCast_RandomTarget(side, 1-side, {CREATURE_MAGI,CREATURE_ARCH_MAGI,CREATURE_COMBAT_MAGE}, SPELL_MAGIC_FIST)
    COMBAT_PAUSE = 0
end

function Routine_CastMultipleArcaneCrystals(side, hero, data)
    -- print("Trigger random arcane crystals !")
    local n = trunc(GetUnitManaPoints(hero) * 0.05)
    local x1 = 13 - 11 * side
    local x2 = 9 - 3 * side
    for i = 1,n do
        HeroCast_Area(hero, SPELL_ARCANE_CRYSTAL, FREE_MANA, random(x1,x2,i), random(GRID_Y_MIN,GRID_Y_MAX,i))
    end
    COMBAT_PAUSE = 0
end

function Routine_CastSummonElementals(side, hero, data)
    -- print("Trigger summon elementals !")
    HeroCast_Global(hero, SPELL_SUMMON_ELEMENTALS, FREE_MANA)
    COMBAT_PAUSE = 0
end

function Routine_CastSummonHive(side, hero, data)
    -- print("Trigger summon beehives !")
    local x = 15 - 13 * side
    HeroCast_Area(hero, SPELL_SUMMON_HIVE, FREE_MANA, x, GRID_Y_MIN)
    HeroCast_Area(hero, SPELL_SUMMON_HIVE, FREE_MANA, x, GRID_Y_MAX)
    COMBAT_PAUSE = 0
end

function Routine_BallistaMoveNext(side, hero, data)
    -- print("Trigger fire ballista ATB boost !")
    if CURRENT_UNIT == hero then
        SetATB_WarMachineType(side, WAR_MACHINE_BALLISTA, ATB_NEXT)
    end
    COMBAT_PAUSE = 0
end

function Routine_CastRandomSlow(side, hero, data)
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


function DoAcademyRoutine_CombatPrepare(side, name, id, data)
    startThread(ACADEMY_COMBAT_PREPARE[name], side, id, data)
end

function DoAcademyRoutine_CombatStart(side, name, id, data)
    startThread(ACADEMY_COMBAT_START[name], side, id, data)
end

function DoAcademyRoutine_CombatTurn(side, name, id, data)
    startThread(ACADEMY_COMBAT_TURN[name], side, id, data)
end

function DoAcademyRoutine_UnitDied(side, name, id, data, unit)
    startThread(ACADEMY_UNIT_DIED[name], side, id, data, unit)
end


-- print("Loaded Academy combat routines")
ROUTINES_LOADED[ACADEMY] = 1
