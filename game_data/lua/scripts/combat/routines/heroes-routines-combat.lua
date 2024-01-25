
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- HAVEN


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- PRESERVE


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- FORTRESS

function Routine_BallistaMoveFirst(side, hero)
    -- print("Trigger ballista play first !")
    SetATB_WarMachineType(side, WAR_MACHINE_BALLISTA, ATB_INSTANT)
    COMBAT_PAUSE = 0
end

function Routine_SkirmishersRandomShoot(side, hero)
    -- print("Trigger spearwielders random shoot !")
    RandomShoot_CreatureTypes(side, {CREATURE_AXE_FIGHTER,CREATURE_AXE_THROWER,CREATURE_HARPOONER})
    COMBAT_PAUSE = 0
end

function Routine_ThanesAbility(side, hero)
    -- print("Trigger Thanes ability !")
    CreatureTypesAbility_RandomTarget(side, 1-side, {CREATURE_WARLORD}, SPELL_ABILITY_FLAMESTRIKE)
    CreatureTypesAbility_RandomTarget(side, 1-side, {CREATURE_THUNDER_THANE}, SPELL_ABILITY_STORMBOLT)
    COMBAT_PAUSE = 0
end

function Routine_CastFireWalls(side, hero)
    -- print("Trigger cast Fire walls !")
    local m = GetUnitManaPoints(hero)
    local x = 11 - 7 * side
    for y = GRID_Y_MIN+1,GRID_Y_MAX-1 do
        HeroCast_Area(hero, SPELL_FIREWALL, FREE_MANA, x, y)
    end
    SetMana(hero, m)
    COMBAT_PAUSE = 0
end

function Routine_RunePriestsMoveFirst(side, hero)
    -- print("Trigger rune priests play first !")
    SetATB_CreatureTypes(side, {CREATURE_RUNE_MAGE,CREATURE_FLAME_MAGECREATURE_FLAME_KEEPER}, ATB_INSTANT)
    COMBAT_PAUSE = 0
end

function Routine_CastEarthquake(side, hero)
    -- print("Trigger earthquake !")
    -- HeroCast_Area(hero, SPELL_UBER_METEOR_SHOWER, FREE_MANA, x, r)
    sleep(600)
    COMBAT_PAUSE = 0
end


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

function Routine_ScoutsMoveFirst(side, hero)
    -- print("Trigger scouts play first !")
    SetATB_CreatureTypes(side, {CREATURE_SCOUT,CREATURE_ASSASSIN,CREATURE_STALKER}, ATB_INSTANT)
    COMBAT_PAUSE = 0
end

function Routine_CastVampirismOnWitches(side, hero)
    -- print("Trigger cast Vampirism !")
    local w = {}
    for i,cr in GetUnits(side, CREATURE) do
        local type = GetCreatureType(CURRENT_UNIT)
        if type == CREATURE_WITCH or type == CREATURE_BLOOD_WITCH or type == CREATURE_BLOOD_WITCH_2 then
            insert(w, cr)
        end
    end
    local m = trunc(GetUnitMaxManaPoints(hero) * 0.01)
    local n = min(length(w), 1 + m)
    for i = 1,n do
        HeroCast_Target(hero, SPELL_VAMPIRISM, FREE_MANA, w[i])
    end
    COMBAT_PAUSE = 0
end

function Routine_MinotaursMoveNext(side, hero)
    -- print("Trigger minotaurs play next !")
    if CURRENT_UNIT == hero then
        SetATB_CreatureTypes(side, {CREATURE_MINOTAUR,CREATURE_MINOTAUR_KING,CREATURE_MINOTAUR_CAPTAIN}, ATB_NEXT)
    end
    COMBAT_PAUSE = 0
end

function Routine_RidersHydraSynergy(side, hero)
    -- print("Trigger riders boost hydras atb !")
    if CURRENT_UNIT_SIDE == side then
        local type = GetCreatureType(CURRENT_UNIT)
        if type == CREATURE_RIDER or type == CREATURE_RAVAGER or type == CREATURE_BLACK_RIDER then
            local r = 20 + trunc(GetUnitMaxManaPoints(hero) * 0.2)
            if random(0, 100, COMBAT_TURN) <= r then
                SetATB_CreatureTypes(side, {CREATURE_HYDRA,CREATURE_CHAOS_HYDRA,CREATURE_ACIDIC_HYDRA}, ATB_NEXT)
            end
        end
    end
    COMBAT_PAUSE = 0
end

function Routine_HeroCastRage(side, hero)
    -- print("Trigger hero cast rage")
    local ennemies = GetUnits(1-side, CREATURE)
    local m = trunc(GetUnitMaxManaPoints(hero) * 0.02)
    local n = min(length(ennemies), m)
    for i = 1,n do
        HeroCast_Target(hero, SPELL_BERSERK, FREE_MANA, ennemies[i-1])
    end
    COMBAT_PAUSE = 0
end

function Routine_SummonDeadEnnemyCreature(side, hero, unit)
    -- print("Trigger revive ennemy creature !")
    if CURRENT_UNIT_SIDE ~= side then
        local type = GetCreatureType(unit)
        local x,y = GetUnitPosition(unit)
        local amount = trunc(GetUnitMaxManaPoints(hero) * 0.1)
        SummonCreatureStack_XY(side, type, amount, x, y)
    end
    COMBAT_PAUSE = 0
end

function Routine_FullDragonSet(side, hero)
    -- print("Trigger full dragon set !")
end

function Routine_RefreshMatronMana(side, hero)
    -- print("Trigger refresh shadow witches mana !")
    if CURRENT_UNIT == hero then
        for i,cr in GetUnits(side, CREATURE) do
            local type = GetCreatureType(cr)
            if type == CREATURE_MATRON or type == CREATURE_MATRIARCH or type == CREATURE_SHADOW_MISTRESS then
                local m = GetUnitMaxManaPoints(cr)
                SetMana(cr, m)
            end
        end
    end
    COMBAT_PAUSE = 0
end

function Routine_CastRandomDeepFrost(side, hero)
    -- print("Trigger cast deep frost !")
    HeroCast_RandomCreature(hero, SPELL_DEEP_FREEZE, FREE_MANA, 1-side)
    COMBAT_PAUSE = 0
end


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
    [H_BRAND] = Routine_CastFireWalls,
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
    [H_WULFSTAN] = Routine_BallistaMoveFirst,
    [H_KARLI] = Routine_SkirmishersRandomShoot,
    [H_HANGVUL] = Routine_ThanesAbility,
    [H_ERLING] = Routine_RunePriestsMoveFirst,
    [H_INGA] = Routine_CastEarthquake,
    -- academy
    [H_DAVIUS] = Routine_RakshasasAbility,
    [H_NUR] = Routine_CastMultipleArcaneCrystals,
    [H_CYRUS] = Routine_MagesCastMagicFist,
    [H_ZEHIR] = Routine_CastSummonElementals,
    -- dungeon
    [H_VAYSHAN] = Routine_ScoutsMoveFirst,
    [H_SYLSAI] = Routine_HeroCastRage,
    [H_SHADYA] = Routine_CastRandomDeepFrost,
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
    [H_DARKSTORM] = Routine_MinotaursMoveNext,
    [H_SORGAL] = Routine_RidersHydraSynergy,
    [H_ERUINA] = Routine_RefreshMatronMana,
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
    [H_SYLSAI] = Routine_SummonDeadEnnemyCreature,
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
