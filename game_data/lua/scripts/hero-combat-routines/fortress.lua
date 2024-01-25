
function Routine_SummonEarthElementals(side, hero)
    -- print("Trigger summon earth elems !")
    local amount = trunc(GetUnitMaxManaPoints(hero) * 0.5)
    SummonCreatureStack_X(side, {CREATURE_EARTH_ELEMENTAL}, amount, 3)
    SummonCreatureStack_X(side, {CREATURE_EARTH_ELEMENTAL}, amount, 3)
    COMBAT_PAUSE = 0
end

function Routine_BallistaUseHalfATB(side, hero)
    -- print("Trigger ballista use half atb !")
    if CURRENT_UNIT == UNIT_SIDE_PREFIX[side]..'-warmachine-WAR_MACHINE_BALLISTA' then
        SetATB_ID(CURRENT_UNIT, ATB_HALF)
    end
    COMBAT_PAUSE = 0
end

function Routine_CastRandomImplosion(side, hero)
    -- print("Trigger random implosion !")
    if GetUnitManaPoints(hero) >= 250 then
        HeroCast_RandomCreature(hero, SPELL_IMPLOSION, 50, 1-side)
        if IsHuman(side) then SetATB_ID(hero, ATB_INSTANT) end
    end
    COMBAT_PAUSE = 0
end


FORTRESS_COMBAT_PREPARE = {
    [H_INGVAR] = NoneRoutine,
    [H_ROLF] = NoneRoutine,
    [H_WULFSTAN] = NoneRoutine,
    [H_TAZAR] = NoneRoutine,
    [H_MAXIMUS] = NoneRoutine,
    [H_KARLI] = NoneRoutine,
    [H_HEDWIG] = NoneRoutine,
    [H_TOLGHAR] = NoneRoutine,
    [H_EBBA] = NoneRoutine,
    [H_ULAND] = NoneRoutine,
    [H_HAEGEIR] = NoneRoutine,
    [H_HELMAR] = NoneRoutine,
    [H_BRAND] = NoneRoutine,
    [H_ERLING] = NoneRoutine,
    [H_HANGVUL] = NoneRoutine,
    [H_BART] = NoneRoutine,
    [H_INGA] = NoneRoutine,
}

FORTRESS_COMBAT_START = {
    [H_INGVAR] = NoneRoutine,
    [H_ROLF] = NoneRoutine,
    [H_WULFSTAN] = Routine_BallistaMoveFirst,
    [H_TAZAR] = NoneRoutine,
    [H_MAXIMUS] = NoneRoutine,
    [H_KARLI] = Routine_SkirmishersRandomShoot,
    [H_HEDWIG] = NoneRoutine,
    [H_TOLGHAR] = NoneRoutine,
    [H_EBBA] = NoneRoutine,
    [H_ULAND] = Routine_ThanesAbility,
    [H_HAEGEIR] = NoneRoutine,
    [H_HELMAR] = NoneRoutine,
    [H_BRAND] = Routine_CastFireWalls,
    [H_ERLING] = Routine_RunePriestsMoveFirst,
    [H_HANGVUL] = NoneRoutine,
    [H_BART] = Routine_SummonEarthElementals,
    [H_INGA] = Routine_CastMeteorShowers,
}

FORTRESS_COMBAT_TURN = {
    [H_INGVAR] = NoneRoutine,
    [H_ROLF] = NoneRoutine,
    [H_WULFSTAN] = Routine_BallistaUseHalfATB,
    [H_TAZAR] = NoneRoutine,
    [H_MAXIMUS] = NoneRoutine,
    [H_KARLI] = NoneRoutine,
    [H_HEDWIG] = NoneRoutine,
    [H_TOLGHAR] = NoneRoutine,
    [H_EBBA] = NoneRoutine,
    [H_ULAND] = NoneRoutine,
    [H_HAEGEIR] = NoneRoutine,
    [H_HELMAR] = NoneRoutine,
    [H_BRAND] = NoneRoutine,
    [H_ERLING] = NoneRoutine,
    [H_HANGVUL] = NoneRoutine,
    [H_BART] = NoneRoutine,
    [H_INGA] = Routine_CastRandomImplosion,
}

FORTRESS_UNIT_DIED = {
    [H_INGVAR] = NoneRoutine,
    [H_ROLF] = NoneRoutine,
    [H_WULFSTAN] = NoneRoutine,
    [H_TAZAR] = NoneRoutine,
    [H_MAXIMUS] = NoneRoutine,
    [H_KARLI] = NoneRoutine,
    [H_HEDWIG] = NoneRoutine,
    [H_TOLGHAR] = NoneRoutine,
    [H_EBBA] = NoneRoutine,
    [H_ULAND] = NoneRoutine,
    [H_HAEGEIR] = NoneRoutine,
    [H_HELMAR] = NoneRoutine,
    [H_BRAND] = NoneRoutine,
    [H_ERLING] = NoneRoutine,
    [H_HANGVUL] = NoneRoutine,
    [H_BART] = NoneRoutine,
    [H_INGA] = NoneRoutine,
}


function DoFortressRoutine_CombatPrepare(side, name, id)
    startThread(FORTRESS_COMBAT_PREPARE[name], side, id)
end

function DoFortressRoutine_CombatStart(side, name, id)
    startThread(FORTRESS_COMBAT_START[name], side, id)
end

function DoFortressRoutine_CombatTurn(side, name, id)
    startThread(FORTRESS_COMBAT_TURN[name], side, id)
end

function DoFortressRoutine_UnitDied(side, name, id, unit)
    startThread(FORTRESS_UNIT_DIED[name], side, id, unit)
end


-- print("Loaded Fortress combat routines")
ROUTINES_LOADED[FORTRESS] = 1
