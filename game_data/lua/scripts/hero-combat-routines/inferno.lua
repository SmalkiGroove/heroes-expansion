
RESET_HERO_ATB = nil

function Routine_CastMarkOfTheDamned(side, hero)
    -- print("Trigger mark of the damned")
    HeroCast_RandomCreature(hero, SPELL_DEMONIC_STRIKE, NO_COST, 1-side)
    COMBAT_PAUSE = 0
end

function Routine_CastRandomBlindness(side, hero)
    -- print("Trigger random blindness !")
    HeroCast_RandomCreature(hero, SPELL_BLIND, FREE_MANA, 1-side)
    COMBAT_PAUSE = 0
end

function Routine_SuccubusRandomShoot(side, hero)
    -- print("Trigger succubus random shoot !")
    RandomShoot_CreatureTypes(side, {CREATURE_SUCCUBUS,CREATURE_INFERNAL_SUCCUBUS,CREATURE_SUCCUBUS_SEDUCER})
    COMBAT_PAUSE = 0
end

function Routine_SummonPitlords(side, hero)
    -- print("Trigger pit lords summoning !")
    local m = GetUnitMaxManaPoints(hero) * 0.1
    local amount = trunc(0.1 * m * m)
    SummonCreatureStack_X(side, CREATURE_BALOR, amount, 0)
    SummonCreatureStack_X(side, CREATURE_BALOR, amount, 0)
    COMBAT_PAUSE = 0
end

function Routine_CastMineFields(side, hero)
    -- print("Trigger mine fields !")
    local x = 12 - 9 * side
    HeroCast_Area(hero, SPELL_LAND_MINE, FREE_MANA, x, 9)
    HeroCast_Area(hero, SPELL_LAND_MINE, FREE_MANA, x, 4)
    COMBAT_PAUSE = 0
end

function Routine_BallistaShootUnit(side, hero)
    -- print("Trigger fireball ballista shoot !")
    if CURRENT_UNIT == UNIT_SIDE_PREFIX[side]..'-warmachine-WAR_MACHINE_BALLISTA' then
        SetATB_ID(CURRENT_UNIT, ATB_ZERO)
    elseif CURRENT_UNIT_SIDE ~= side then
        if IsCreature(CURRENT_UNIT) then
            local m = GetUnitManaPoints(hero)
            if m > 3 then
                TargetShoot_Ballista(side, CURRENT_UNIT)
                SetMana(unit, m-3)
            end
        end
    end
    COMBAT_PAUSE = 0
end

function Routine_DemonicCreatureExplosion(side, hero)
    -- print("Trigger creature explosion !")
    if CURRENT_UNIT_SIDE == side then
        if IsCreature(CURRENT_UNIT) then
            local id = GetCreatureType(CURRENT_UNIT)
            if GetCreatureFactionID(id) == INFERNO then
                local x,y = GetUnitPosition(CURRENT_UNIT)
                UnitCastAreaSpell(CURRENT_UNIT, SPELL_ABILITY_EXPLOSION, x, y)
                SetATB_ID(CURRENT_UNIT, ATB_INSTANT)
            end
        end
    end
    COMBAT_PAUSE = 0
end

function Routine_CastRandomStoneSpikes(side, hero)
    -- print("Trigger random Stone spikes !")
    if CURRENT_UNIT == hero then
        HeroCast_RandomCreatureArea(hero, SPELL_STONE_SPIKES, FREE_MANA, 1-side)
        if IsHuman(side) then SetATB_ID(hero, ATB_INSTANT) end
    end
    COMBAT_PAUSE = 0
end

function Routine_CastRandomFireball(side, hero)
    -- print("Trigger random Fireball !")
    if CURRENT_UNIT == hero then
        HeroCast_RandomCreatureArea(hero, SPELL_FIREBALL, FREE_MANA, 1-side)
        RESET_HERO_ATB = not nil
    elseif RESET_HERO_ATB then
        RESET_HERO_ATB = nil
        SetATB_ID(hero, 0.66)
    end
    COMBAT_PAUSE = 0
end


INFERNO_COMBAT_PREPARE = {
    [H_GRAWL] = NoneRoutine,
    [H_NEBIROS] = NoneRoutine,
    [H_MARBAS] = NoneRoutine,
    [H_HARKENRAZ] = NoneRoutine,
    [H_CALH] = NoneRoutine,
    [H_SHELTEM] = NoneRoutine,
    [H_ALASTOR] = NoneRoutine,
    [H_GROK] = NoneRoutine,
    [H_NYMUS] = NoneRoutine,
    [H_JEZEBETH] = NoneRoutine,
    [H_MALUSTAR] = NoneRoutine,
    [H_AGRAEL] = NoneRoutine,
    [H_BIARA] = NoneRoutine,
    [H_KHABELETH] = NoneRoutine,
    [H_ZYDAR] = NoneRoutine,
    [H_DELEB] = NoneRoutine,
    [H_CALID] = NoneRoutine,
}

INFERNO_COMBAT_START = {
    [H_GRAWL] = NoneRoutine,
    [H_NEBIROS] = Routine_CastMarkOfTheDamned,
    [H_MARBAS] = NoneRoutine,
    [H_HARKENRAZ] = NoneRoutine,
    [H_CALH] = NoneRoutine,
    [H_SHELTEM] = NoneRoutine,
    [H_ALASTOR] = Routine_CastRandomBlindness,
    [H_GROK] = NoneRoutine,
    [H_NYMUS] = NoneRoutine,
    [H_JEZEBETH] = NoneRoutine,
    [H_MALUSTAR] = NoneRoutine,
    [H_AGRAEL] = NoneRoutine,
    [H_BIARA] = Routine_SuccubusRandomShoot,
    [H_KHABELETH] = Routine_SummonPitlords,
    [H_ZYDAR] = NoneRoutine,
    [H_DELEB] = Routine_CastMineFields,
    [H_CALID] = NoneRoutine,
}

INFERNO_COMBAT_TURN = {
    [H_GRAWL] = NoneRoutine,
    [H_NEBIROS] = NoneRoutine,
    [H_MARBAS] = NoneRoutine,
    [H_HARKENRAZ] = NoneRoutine,
    [H_CALH] = NoneRoutine,
    [H_SHELTEM] = Routine_BallistaShootUnit,
    [H_ALASTOR] = NoneRoutine,
    [H_GROK] = NoneRoutine,
    [H_NYMUS] = NoneRoutine,
    [H_JEZEBETH] = NoneRoutine,
    [H_MALUSTAR] = NoneRoutine,
    [H_AGRAEL] = Routine_DemonicCreatureExplosion,
    [H_BIARA] = NoneRoutine,
    [H_KHABELETH] = NoneRoutine,
    [H_ZYDAR] = NoneRoutine,
    [H_DELEB] = Routine_CastRandomStoneSpikes,
    [H_CALID] = Routine_CastRandomFireball,
}

INFERNO_UNIT_DIED = {
    [H_GRAWL] = NoneRoutine,
    [H_NEBIROS] = NoneRoutine,
    [H_MARBAS] = NoneRoutine,
    [H_HARKENRAZ] = NoneRoutine,
    [H_CALH] = NoneRoutine,
    [H_SHELTEM] = NoneRoutine,
    [H_ALASTOR] = NoneRoutine,
    [H_GROK] = NoneRoutine,
    [H_NYMUS] = NoneRoutine,
    [H_JEZEBETH] = NoneRoutine,
    [H_MALUSTAR] = NoneRoutine,
    [H_AGRAEL] = NoneRoutine,
    [H_BIARA] = NoneRoutine,
    [H_KHABELETH] = NoneRoutine,
    [H_ZYDAR] = NoneRoutine,
    [H_DELEB] = NoneRoutine,
    [H_CALID] = NoneRoutine,
}


function DoInfernoRoutine_CombatPrepare(side, name, id)
    startThread(INFERNO_COMBAT_PREPARE[name], side, id)
end

function DoInfernoRoutine_CombatStart(side, name, id)
    startThread(INFERNO_COMBAT_START[name], side, id)
end

function DoInfernoRoutine_CombatTurn(side, name, id)
    startThread(INFERNO_COMBAT_TURN[name], side, id)
end

function DoInfernoRoutine_UnitDied(side, name, id, unit)
    startThread(INFERNO_UNIT_DIED[name], side, id, unit)
end


-- print("Loaded Inferno combat routines")
ROUTINES_LOADED[INFERNO] = 1
