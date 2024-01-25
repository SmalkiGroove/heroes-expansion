
function Routine_InvokeBladeBarriers(side, hero)
    -- print("Trigger cast Blade Barriers !")
    local m = GetUnitManaPoints(hero)
    local x1 = 12 - 9 * side
    local x2 = 11 - 7 * side
    for y= GRID_Y_MIN+1,GRID_Y_MAX-1 do
        HeroCast_Area(hero, SPELL_BLADE_BARRIER, FREE_MANA, x1, y)
        HeroCast_Area(hero, SPELL_BLADE_BARRIER, FREE_MANA, x2, GRID_Y_MAX-y+1)
    end
    SetMana(hero, m)
    COMBAT_PAUSE = 0
end

function Routine_HeroMoveFirst(side, hero)
    -- print("Trigger hero play first !")
    SetATB_ID(hero, ATB_INSTANT)
    COMBAT_PAUSE = 0
end

function Routine_CastRandomLightningBolt(side, hero)
    -- print("Trigger cast lightning bolt !")
    HeroCast_RandomCreature(hero, SPELL_LIGHTNING_BOLT, FREE_MANA, 1-side)
    COMBAT_PAUSE = 0
end

function Routine_CastConjurePhoenix(side, hero)
    -- print("Trigger cast conjure phoenix !")
    HeroCast_Global(hero, SPELL_CONJURE_PHOENIX, FREE_MANA)
    COMBAT_PAUSE = 0
end


DUNGEON_COMBAT_PREPARE = {
    [H_SORGAL] = NoneRoutine,
    [H_KYTHRA] = NoneRoutine,
    [H_AGBETH] = NoneRoutine,
    [H_RANLETH] = NoneRoutine,
    [H_DARKSTORM] = NoneRoutine,
    [H_YRWANNA] = NoneRoutine,
    [H_VAYSHAN] = NoneRoutine,
    [H_THRALSAI] = NoneRoutine,
    [H_LETHOS] = NoneRoutine,
    [H_ERUINA] = NoneRoutine,
    [H_YRBETH] = NoneRoutine,
    [H_SYLSAI] = NoneRoutine,
    [H_SINITAR] = NoneRoutine,
    [H_SHADYA] = NoneRoutine,
    [H_RAELAG] = NoneRoutine,
    [H_YLAYA] = NoneRoutine,
    [H_SEPHINROTH] = NoneRoutine,
    [H_KASTORE] = NoneRoutine,
}

DUNGEON_COMBAT_START = {
    [H_SORGAL] = NoneRoutine,
    [H_KYTHRA] = NoneRoutine,
    [H_AGBETH] = Routine_InvokeBladeBarriers,
    [H_RANLETH] = NoneRoutine,
    [H_DARKSTORM] = NoneRoutine,
    [H_YRWANNA] = Routine_CastVampirismOnWitches,
    [H_VAYSHAN] = Routine_ScoutsMoveFirst,
    [H_THRALSAI] = Routine_HeroMoveFirst,
    [H_LETHOS] = NoneRoutine,
    [H_ERUINA] = NoneRoutine,
    [H_YRBETH] = NoneRoutine,
    [H_SYLSAI] = Routine_HeroCastRage,
    [H_SINITAR] = NoneRoutine,
    [H_SHADYA] = Routine_CastRandomDeepFrost,
    [H_RAELAG] = NoneRoutine,
    [H_YLAYA] = Routine_CastRandomLightningBolt,
    [H_SEPHINROTH] = NoneRoutine,
    [H_KASTORE] = Routine_CastConjurePhoenix,
}

DUNGEON_COMBAT_TURN = {
    [H_SORGAL] = Routine_RidersHydraSynergy,
    [H_KYTHRA] = NoneRoutine,
    [H_AGBETH] = NoneRoutine,
    [H_RANLETH] = NoneRoutine,
    [H_DARKSTORM] = Routine_MinotaursMoveNext,
    [H_YRWANNA] = NoneRoutine,
    [H_VAYSHAN] = NoneRoutine,
    [H_THRALSAI] = NoneRoutine,
    [H_LETHOS] = NoneRoutine,
    [H_ERUINA] = Routine_RefreshMatronMana,
    [H_YRBETH] = NoneRoutine,
    [H_SYLSAI] = NoneRoutine,
    [H_SINITAR] = NoneRoutine,
    [H_SHADYA] = NoneRoutine,
    [H_RAELAG] = NoneRoutine,
    [H_YLAYA] = Routine_CastRandomLightningBolt2,
    [H_SEPHINROTH] = NoneRoutine,
    [H_KASTORE] = NoneRoutine,
}

DUNGEON_UNIT_DIED = {
    [H_SORGAL] = NoneRoutine,
    [H_KYTHRA] = NoneRoutine,
    [H_AGBETH] = NoneRoutine,
    [H_RANLETH] = NoneRoutine,
    [H_DARKSTORM] = NoneRoutine,
    [H_YRWANNA] = NoneRoutine,
    [H_VAYSHAN] = NoneRoutine,
    [H_THRALSAI] = NoneRoutine,
    [H_LETHOS] = NoneRoutine,
    [H_ERUINA] = NoneRoutine,
    [H_YRBETH] = NoneRoutine,
    [H_SYLSAI] = Routine_SummonDeadEnnemyCreature,
    [H_SINITAR] = NoneRoutine,
    [H_SHADYA] = NoneRoutine,
    [H_RAELAG] = NoneRoutine,
    [H_YLAYA] = NoneRoutine,
    [H_SEPHINROTH] = NoneRoutine,
    [H_KASTORE] = NoneRoutine,
}

function DoDungeonRoutine_CombatPrepare(side, name, id)
    startThread(DUNGEON_COMBAT_PREPARE[name], side, id)
end

function DoDungeonRoutine_CombatStart(side, name, id)
    startThread(DUNGEON_COMBAT_START[name], side, id)
end

function DoDungeonRoutine_CombatTurn(side, name, id)
    startThread(DUNGEON_COMBAT_TURN[name], side, id)
end

function DoDungeonRoutine_UnitDied(side, name, id, unit)
    startThread(DUNGEON_UNIT_DIED[name], side, id, unit)
end


-- print("Loaded Dungeon combat routines")
ROUTINES_LOADED[DUNGEON] = 1
