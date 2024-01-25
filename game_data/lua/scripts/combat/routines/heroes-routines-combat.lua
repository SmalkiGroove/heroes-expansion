
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- HAVEN


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- PRESERVE


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- FORTRESS


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMY

function Routine_RakshasasAbility(side, hero)
    -- print("Trigger rakshasas dash !")
    CreatureTypesAbility_Untargeted(side, {CREATURE_RAKSHASA,CREATURE_RAKSHASA_RUKH,CREATURE_RAKSHASA_KSHATRI}, SPELL_ABILITY_DASH)
    COMBAT_PAUSE = 0
end

function Routine_BallistaMoveNext(side, hero)
    -- print("Trigger fire ballista ATB boost !")
    if CURRENT_UNIT == hero then
        SetATB_WarMachineType(side, WAR_MACHINE_BALLISTA, ATB_NEXT)
    end
    COMBAT_PAUSE = 0
end

function Routine_CastMultipleArcaneCrystals(side, hero)
    -- print("Trigger random arcane crystals !")
    local n = trunc(GetUnitManaPoints(hero) * 0.05)
    local x1 = 13 - 11 * side
    local x2 = 9 - 3 * side
    for i = 1,n do
        HeroCast_Area(hero, SPELL_ARCANE_CRYSTAL, FREE_MANA, random(x1,x2,i), random(GRID_Y_MIN,GRID_Y_MAX,i))
    end
    COMBAT_PAUSE = 0
end

function Routine_MagesCastMagicFist(side, hero)
    -- print("Trigger mages magic fist !")
    CreatureTypesCast_RandomTarget(side, 1-side, {CREATURE_MAGI,CREATURE_ARCH_MAGI,CREATURE_COMBAT_MAGE}, SPELL_MAGIC_FIST)
    COMBAT_PAUSE = 0
end

function Routine_CastSummonElementals(side, hero)
    -- print("Trigger summon elementals !")
    HeroCast_Global(hero, SPELL_SUMMON_ELEMENTALS, FREE_MANA)
    COMBAT_PAUSE = 0
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- DUNGEON


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- NECROPOLIS


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- INFERNO


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- STRONGHOLD




COMBAT_PREPART_HERO_ROUTINES = {
    -- haven
    -- preserve
    -- fortress
    -- academy
    -- dungeon
    -- necropolis
    -- inferno
    -- stronghold
}

COMBAT_START_HERO_ROUTINES = {
    -- haven
    -- preserve
    -- fortress
    -- academy
    [H_DAVIUS] = Routine_RakshasasAbility,
    [H_NUR] = Routine_CastMultipleArcaneCrystals,
    [H_CYRUS] = Routine_MagesCastMagicFist,
    [H_ZEHIR] = Routine_CastSummonElementals,
    -- dungeon
    -- necropolis
    -- inferno
    -- stronghold
}

COMBAT_TURN_HERO_ROUTINES = {
    -- haven
    -- preserve
    -- fortress
    -- academy
    [H_NATHIR] = Routine_BallistaMoveNext,
    -- dungeon
    -- necropolis
    -- inferno
    -- stronghold
}

UNIT_DIED_HERO_ROUTINES = {
    -- haven
    -- preserve
    -- fortress
    -- academy
    -- dungeon
    -- necropolis
    -- inferno
    -- stronghold
}


function DoHeroSpeRoutine_CombatPrepare(side, name, id)
    startThread(COMBAT_PREPART_HERO_ROUTINES[name], side, id)
end

function DoHeroSpeRoutine_CombatStart(side, name, id)
    startThread(COMBAT_START_HERO_ROUTINES[name], side, id)
end

function DoHeroSpeRoutine_CombatTurn(side, name, id)
    startThread(COMBAT_TURN_HERO_ROUTINES[name], side, id)
end

function DoHeroSpeRoutine_UnitDied(side, name, id, unit)
    startThread(UNIT_DIED_HERO_ROUTINES[name], side, id, unit)
end


-- print("Loaded hero spe advmap routines")
ROUTINES_LOADED[1] = 1
