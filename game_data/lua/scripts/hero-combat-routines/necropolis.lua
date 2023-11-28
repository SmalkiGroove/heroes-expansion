
AVATAR_OF_DEATH_ID = "none"

function Routine_SummonAndKillEnnemySkeleton(side, hero, data)
    -- print("Trigger summon and kill skeleton !")
    local n = length(GetUnits(1-side, CREATURE))
    SummonCreatureStack_X(1-side, CREATURE_SKELETON, 1, 6)
    repeat sleep(10) until length(GetUnits(1-side, CREATURE)) == n + 1
    HeroCast_Target(hero, SPELL_MAGIC_ARROW, FREE_MANA, GetUnits(1-side, CREATURE)[n])
    COMBAT_PAUSE = 0
end

function Routine_SummonAvatarOfDeath(side, hero, data)
    -- print("Trigger summon avatar of death !")
    local units = GetUnits(side, CREATURE)
    HeroCast_Global(hero, SPELL_ABILITY_AVATAR_OF_DEATH, FREE_MANA)
    sleep(100)
    AVATAR_OF_DEATH_ID = GetUnits(side, CREATURE)[length(units)]
    COMBAT_PAUSE = 0
end

function Routine_CastMassWeakness(side, hero, data)
    -- print("Trigger cast mass weakness !")
    HeroCast_Global(hero, SPELL_MASS_CURSE, FREE_MANA)
    COMBAT_PAUSE = 0
end

function Routine_CastMultipleSorrow(side, hero, data)
    -- print("Trigger random sorrow")
    local e = GetUnits(1-side, CREATURE)
    local m = GetUnitMaxManaPoints(hero) * 0.02
    local n = min(length(e), 1+trunc(m))
    for i = 1,n do
        HeroCast_Target(hero, SPELL_SORROW, FREE_MANA, e[i-1])
    end
    COMBAT_PAUSE = 0
end

function Routine_DuplicateArmyGhosts(side, hero, data)
    -- print("Trigger duplicate ghosts !")
    for i,cr in GetUnits(side, CREATURE) do
        local type = GetCreatureType(cr)
        if type == CREATURE_MANES or type == CREATURE_GHOST or type == CREATURE_POLTERGEIST then
            local nb = GetCreatureNumber(cr)
            local x,y = GetUnitPosition(cr)
            x = x + 1 - side * 2
            SummonCreatureStack_XY(side, type, nb, x, y)
        end
    end
    COMBAT_PAUSE = 0
end

function Routine_CastRandomPlague(side, hero, data)
    -- print("Trigger random Plague !")
    if CURRENT_UNIT == hero then
        HeroCast_RandomCreature(hero, SPELL_PLAGUE, FREE_MANA, 1-side)
        if IsHuman(side) then SetATB_ID(hero, ATB_INSTANT) end
    end
    COMBAT_PAUSE = 0
end

function Routine_SummonZombieStack(side, hero, data)
    -- print("Trigger summon zombies !")
    if CURRENT_UNIT == hero then
        local m = GetUnitManaPoints(hero)
        if m > 0 then SummonCreatureStack(side, CREATURE_DISEASE_ZOMBIE, m) end
    end
    COMBAT_PAUSE = 0
end

function Routine_CastRandomIceBolt(side, hero, data)
    -- print("Trigger random Ice Bolt !")
    if CURRENT_UNIT == hero then
        HeroCast_RandomCreature(hero, SPELL_ICE_BOLT, FREE_MANA, 1-side)
        if IsHuman(side) then SetATB_ID(hero, ATB_INSTANT) end
    end
    COMBAT_PAUSE = 0
end

function Routine_AvatarDead(side, hero, data, unit)
    -- print("Trigger mass Blindness on Avatar of Death's death !")
    if unit == AVATAR_OF_DEATH_ID then
        HeroCast_AllCreatures(hero, SPELL_BLIND, FREE_MANA, 1-side)
        sleep(100); SetMana(hero, 10)
    end
    COMBAT_PAUSE = 0
end


NECROPOLIS_COMBAT_PREPARE = {
    [H_KASPAR] = NoneRoutine,
    [H_VLADIMIR] = NoneRoutine,
    [H_ORSON] = NoneRoutine,
    [H_ORNELLA2] = NoneRoutine,
    [H_LUCRETIA] = NoneRoutine,
    [H_XERXON] = NoneRoutine,
    [H_DEIRDRE] = NoneRoutine,
    [H_NAADIR] = NoneRoutine,
    [H_AISLINN] = NoneRoutine,
    [H_GIOVANNI] = NoneRoutine,
    [H_ARCHILUS] = NoneRoutine,
    [H_ZOLTAN] = NoneRoutine,
    [H_RAVEN] = NoneRoutine,
    [H_ARANTIR] = NoneRoutine,
    [H_THANT] = NoneRoutine,
    [H_SANDRO] = NoneRoutine,
    [H_VIDOMINA] = NoneRoutine,
}

NECROPOLIS_COMBAT_START = {
    [H_KASPAR] = NoneRoutine,
    [H_VLADIMIR] = Routine_SummonAndKillEnnemySkeleton,
    [H_ORSON] = NoneRoutine,
    [H_ORNELLA2] = NoneRoutine,
    [H_LUCRETIA] = NoneRoutine,
    [H_XERXON] = NoneRoutine,
    [H_DEIRDRE] = NoneRoutine,
    [H_NAADIR] = Routine_DuplicateArmyGhosts,
    [H_AISLINN] = Routine_CastMassWeakness,
    [H_GIOVANNI] = NoneRoutine,
    [H_ARCHILUS] = Routine_SummonAvatarOfDeath,
    [H_ZOLTAN] = NoneRoutine,
    [H_RAVEN] = NoneRoutine,
    [H_ARANTIR] = NoneRoutine,
    [H_THANT] = NoneRoutine,
    [H_SANDRO] = NoneRoutine,
    [H_VIDOMINA] = Routine_CastMultipleSorrow,
}

NECROPOLIS_COMBAT_TURN = {
    [H_KASPAR] = Routine_CastRandomPlague,
    [H_VLADIMIR] = NoneRoutine,
    [H_ORSON] = Routine_SummonZombieStack,
    [H_ORNELLA2] = NoneRoutine,
    [H_LUCRETIA] = NoneRoutine,
    [H_XERXON] = NoneRoutine,
    [H_DEIRDRE] = NoneRoutine,
    [H_NAADIR] = NoneRoutine,
    [H_AISLINN] = NoneRoutine,
    [H_GIOVANNI] = Routine_CastRandomIceBolt,
    [H_ARCHILUS] = NoneRoutine,
    [H_ZOLTAN] = NoneRoutine,
    [H_RAVEN] = NoneRoutine,
    [H_ARANTIR] = NoneRoutine,
    [H_THANT] = NoneRoutine,
    [H_SANDRO] = NoneRoutine,
    [H_VIDOMINA] = NoneRoutine,
}

NECROPOLIS_UNIT_DIED = {
    [H_KASPAR] = NoneRoutine,
    [H_VLADIMIR] = NoneRoutine,
    [H_ORSON] = NoneRoutine,
    [H_ORNELLA2] = NoneRoutine,
    [H_LUCRETIA] = NoneRoutine,
    [H_XERXON] = NoneRoutine,
    [H_DEIRDRE] = NoneRoutine,
    [H_NAADIR] = NoneRoutine,
    [H_AISLINN] = NoneRoutine,
    [H_GIOVANNI] = NoneRoutine,
    [H_ARCHILUS] = Routine_AvatarDead,
    [H_ZOLTAN] = NoneRoutine,
    [H_RAVEN] = NoneRoutine,
    [H_ARANTIR] = NoneRoutine,
    [H_THANT] = NoneRoutine,
    [H_SANDRO] = NoneRoutine,
    [H_VIDOMINA] = NoneRoutine,
}


function DoNecropolisRoutine_CombatPrepare(side, name, id, data)
    startThread(NECROPOLIS_COMBAT_PREPARE[name], side, id, data)
end

function DoNecropolisRoutine_CombatStart(side, name, id, data)
    startThread(NECROPOLIS_COMBAT_START[name], side, id, data)
end

function DoNecropolisRoutine_CombatTurn(side, name, id, data)
    startThread(NECROPOLIS_COMBAT_TURN[name], side, id, data)
end

function DoNecropolisRoutine_UnitDied(side, name, id, data, unit)
    startThread(NECROPOLIS_UNIT_DIED[name], side, id, data, unit)
end


-- print("Loaded Necropolis combat routines")
ROUTINES_LOADED[NECROPOLIS] = 1
