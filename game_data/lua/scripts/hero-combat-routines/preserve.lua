
ENRAGED_CREATURES_ELVEN_FURY = {
    CREATURE_BLADE_JUGGLER, CREATURE_WAR_DANCER, CREATURE_BLADE_SINGER,
    CREATURE_WOOD_ELF, CREATURE_GRAND_ELF, CREATURE_SHARP_SHOOTER,
    CREATURE_DRUID, CREATURE_DRUID_ELDER, CREATURE_HIGH_DRUID,
    CREATURE_TREANT, CREATURE_TREANT_GUARDIAN, CREATURE_ANGER_TREANT,
}

function Routine_AngerTreantsAbility(side, hero)
    -- print("Trigger anger treants rage of forest !")
    CreatureTypesAbility_Untargeted(side, {CREATURE_ANGER_TREANT}, SPELL_ABILITY_RAGE_OF_THE_FOREST)
    COMBAT_PAUSE = 0
end

function Routine_CastBloodlustEnraged(side, hero)
    -- print("Trigger bloodlust on enraged !")
    HeroCast_TargetCreatureTypes(hero, SPELL_BLOODLUST, FREE_MANA, side, ENRAGED_CREATURES_ELVEN_FURY)
    COMBAT_PAUSE = 0
end

function Routine_SiphonEnnemyMana(side, hero)
    -- print("Trigger siphon mana !")
    local hero_cur_mana = GetUnitManaPoints(hero)
    local hero_max_mana = GetUnitMaxManaPoints(hero)
    local siphon = trunc(hero_max_mana * 0.1)
    local amount = 0
    local ennemies = GetUnits(1-side, CREATURE)
    for i,en in ennemies do
        local mana = GetUnitManaPoints(en)
        if mana >= 0 then
            SetMana(en, max(mana-siphon,0))
            amount = amount + min(mana,siphon)
        end
    end
    local new_mana = min(hero_cur_mana+amount, hero_max_mana)
    SetMana(hero, new_mana)
    COMBAT_PAUSE = 0
end

function Routine_SummonWolfStack(side, hero)
    -- print("Trigger spawn wolves pack !")
    if CURRENT_UNIT == hero then
        local amount = trunc(GetUnitManaPoints(hero) * 0.34)
        if amount > 0 then SummonCreatureStack(side, CREATURE_WOLF, amount) end
    end
    COMBAT_PAUSE = 0
end


SYLVAN_COMBAT_PREPARE = {
    [H_WYNGAAL] = NoneRoutine,
    [H_ANWEN] = NoneRoutine,
    [H_TALANAR] = NoneRoutine,
    [H_OSSIR] = NoneRoutine,
    [H_FINDAN] = NoneRoutine,
    [H_JENOVA] = NoneRoutine,
    [H_GILRAEN] = NoneRoutine,
    [H_KYRRE] = NoneRoutine,
    [H_IVOR] = NoneRoutine,
    [H_MEPHALA] = NoneRoutine,
    [H_ALARON] = NoneRoutine,
    [H_DIRAEL] = NoneRoutine,
    [H_VINRAEL] = NoneRoutine,
    [H_YLTHIN] = NoneRoutine,
    [H_TIERU] = NoneRoutine,
    [H_GEM] = NoneRoutine,
    [H_ELLESHAR] = NoneRoutine,
}

SYLVAN_COMBAT_START = {
    [H_WYNGAAL] = NoneRoutine,
    [H_ANWEN] = Routine_AngerTreantsAbility,
    [H_TALANAR] = Routine_CastBloodlustEnraged,
    [H_FINDAN] = NoneRoutine,
    [H_JENOVA] = NoneRoutine,
    [H_GILRAEN] = NoneRoutine,
    [H_KYRRE] = NoneRoutine,
    [H_IVOR] = NoneRoutine,
    [H_MEPHALA] = NoneRoutine,
    [H_DIRAEL] = NoneRoutine,
    [H_VINRAEL] = NoneRoutine,
    [H_YLTHIN] = NoneRoutine,
    [H_GEM] = Routine_SiphonEnnemyMana,
    [H_ELLESHAR] = NoneRoutine,
}

SYLVAN_COMBAT_TURN = {
    [H_WYNGAAL] = NoneRoutine,
    [H_ANWEN] = NoneRoutine,
    [H_TALANAR] = NoneRoutine,
    [H_OSSIR] = NoneRoutine,
    [H_JENOVA] = NoneRoutine,
    [H_GILRAEN] = NoneRoutine,
    [H_KYRRE] = NoneRoutine,
    [H_IVOR] = Routine_SummonWolfStack,
    [H_MEPHALA] = NoneRoutine,
    [H_DIRAEL] = NoneRoutine,
    [H_VINRAEL] = NoneRoutine,
    [H_YLTHIN] = NoneRoutine,
    [H_TIERU] = NoneRoutine,
    [H_GEM] = NoneRoutine,
    [H_ELLESHAR] = NoneRoutine,
}

SYLVAN_UNIT_DIED = {
    [H_WYNGAAL] = NoneRoutine,
    [H_ANWEN] = NoneRoutine,
    [H_OSSIR] = NoneRoutine,
    [H_FINDAN] = NoneRoutine,
    [H_JENOVA] = NoneRoutine,
    [H_GILRAEN] = NoneRoutine,
    [H_KYRRE] = NoneRoutine,
    [H_IVOR] = NoneRoutine,
    [H_MEPHALA] = NoneRoutine,
    [H_ALARON] = NoneRoutine,
    [H_DIRAEL] = NoneRoutine,
    [H_VINRAEL] = NoneRoutine,
    [H_YLTHIN] = NoneRoutine,
    [H_TIERU] = NoneRoutine,
    [H_GEM] = NoneRoutine,
    [H_ELLESHAR] = NoneRoutine,
}


function DoPreserveRoutine_CombatPrepare(side, name, id)
    startThread(SYLVAN_COMBAT_PREPARE[name], side, id)
end

function DoPreserveRoutine_CombatStart(side, name, id)
    startThread(SYLVAN_COMBAT_START[name], side, id)
end

function DoPreserveRoutine_CombatTurn(side, name, id)
    startThread(SYLVAN_COMBAT_TURN[name], side, id)
end

function DoPreserveRoutine_UnitDied(side, name, id, unit)
    startThread(SYLVAN_UNIT_DIED[name], side, id, unit)
end


-- print("Loaded Preserve combat routines")
ROUTINES_LOADED[PRESERVE] = 1
