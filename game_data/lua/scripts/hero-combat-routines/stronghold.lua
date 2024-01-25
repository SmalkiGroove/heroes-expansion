GOBLIN_AMOUNT = 0

function Routine_CastHordeAnger(side, hero)
    -- print("Trigger horde's anger !")
    if GetUnitManaPoints(hero) >= 10 then
        HeroCast_RandomCreature(hero, SPELL_WARCRY_SHOUT_OF_MANY, 10, 1-side)
    end
    COMBAT_PAUSE = 0
end

function Routine_CastPowerfulBlowCentaur(side, hero)
    -- print("Trigger powerful blow on centaur !")
    HeroCast_TargetCreatureTypes(hero, SPELL_EFFECT_COORDINATION, NO_COST, side, {CREATURE_CENTAUR,CREATURE_CENTAUR_NOMAD,CREATURE_CENTAUR_MARADEUR})
    COMBAT_PAUSE = 0
end

function Routine_GetMaxGoblinStack(side, hero)
    -- print("Trigger get max goblin stack !")
    for i,cr in GetUnits(side, CREATURE) do
        local type = GetCreatureType(cr)
        if type == CREATURE_GOBLIN or type == CREATURE_GOBLIN_TRAPPER or type == CREATURE_GOBLIN_DEFILER then
            local nb = GetCreatureNumber(cr)
            if nb > GOBLIN_AMOUNT then
                GOBLIN_AMOUNT = nb
            end
        end
    end
    COMBAT_PAUSE = 0
end

function Routine_BallistaRandomShoot(side, hero)
    -- print("Trigger ballista random shoot !")
    RandomShoot_Ballista(side)
    COMBAT_PAUSE = 0
end

function Routine_ShamanCastPowerFeed(side, hero)
    -- print("Trigger shaman cast er feed !")
    CreatureTypesCast_Untargeted(side, {CREATURE_SHAMAN,CREATURE_SHAMAN_WITCH,CREATURE_SHAMAN_HAG}, SPELL_ABILITY_POWER_FEED)
    COMBAT_PAUSE = 0
end

function Routine_CastLightningSpell(side, hero)
    -- print("Trigger lightning spell !")
    local ennemies = GetUnits(1-side,CREATURE)
    local spell = (length(ennemies) >= 4) and SPELL_CHAIN_LIGHTNING or SPELL_LIGHTNING_BOLT
    HeroCast_Target(hero, spell, FREE_MANA, ennemies[0])
    COMBAT_PAUSE = 0
end

function Routine_SummonMatron(side, hero)
    -- print("Trigger summon matron !")
    local m = trunc(GetUnitMaxManaPoints(hero) * 0.1)
    SummonCreatureStack_X(side, CREATURE_MATRON, amount, 0.5 * m * m)
    COMBAT_PAUSE = 0
end

function Routine_BallistaRandomShoot2(side, hero)
    -- print("Trigger ballista random shoot !")
    if CURRENT_UNIT == hero then
        RandomShoot_Ballista(side)
    end
    COMBAT_PAUSE = 0
end

function Routine_CastRandomRegenOrPlague(side, hero)
    -- print("Trigger regen or plague !")
    if CURRENT_UNIT == UNIT_SIDE_PREFIX[side]..'-warmachine-WAR_MACHINE_FIRST_AID_TENT' then
        if mod(TURN, 2) == 0 then
            HeroCast_RandomCreature(hero, SPELL_REGENERATION, FREE_MANA, side)
        else
            HeroCast_RandomCreature(hero, SPELL_PLAGUE, FREE_MANA, 1-side)
        end
    end
    COMBAT_PAUSE = 0
end

function Routine_CastRandomVulnerability(side, hero)
    -- print("Trigger random vulnerability !")
    if CURRENT_UNIT == hero then
        HeroCast_RandomCreature(hero, SPELL_DISRUPTING_RAY, FREE_MANA, 1-side)
        if IsHuman(side) then SetATB_ID(hero, ATB_INSTANT) end
    end
    COMBAT_PAUSE = 0
end


STRONGHOLD_COMBAT_PREPARE = {
    [H_TELSEK] = NoneRoutine,
    [H_GORSHAK] = NoneRoutine,
    [H_GOTAI] = NoneRoutine,
    [H_AZAR] = NoneRoutine,
    [H_MATEWA] = NoneRoutine,
    [H_KUNYAK] = NoneRoutine,
    [H_KRAGH] = NoneRoutine,
    [H_KILGHAN] = NoneRoutine,
    [H_CRAGHACK] = NoneRoutine,
    [H_KRAAL] = NoneRoutine,
    [H_SHAKKARUKAT] = NoneRoutine,
    [H_KUJIN] = NoneRoutine,
    [H_SHIVA] = NoneRoutine,
    [H_MUKHA] = NoneRoutine,
    [H_HAGGASH] = NoneRoutine,
    [H_URGHAT] = NoneRoutine,
    [H_GARUNA] = NoneRoutine,
    [H_ZOULEIKA] = NoneRoutine,
    [H_ERIKA] = NoneRoutine,
}

STRONGHOLD_COMBAT_START = {
    [H_GORSHAK] = NoneRoutine,
    [H_AZAR] = Routine_CastHordeAnger,
    [H_MATEWA] = NoneRoutine,
    [H_KUNYAK] = NoneRoutine,
    [H_KRAGH] = Routine_CastPowerfulBlowCentaur,
    [H_KILGHAN] = Routine_GetMaxGoblinStack,
    [H_KRAAL] = Routine_BallistaRandomShoot,
    [H_SHAKKARUKAT] = NoneRoutine,
    [H_KUJIN] = NoneRoutine,
    [H_SHIVA] = Routine_ShamanCastPowerFeed,
    [H_HAGGASH] = NoneRoutine,
    [H_URGHAT] = NoneRoutine,
    [H_GARUNA] = NoneRoutine,
    [H_ZOULEIKA] = NoneRoutine,
    [H_ERIKA] = Routine_SummonMatron,
}

STRONGHOLD_COMBAT_TURN = {
    [H_TELSEK] = NoneRoutine,
    [H_GORSHAK] = NoneRoutine,
    [H_GOTAI] = NoneRoutine,
    [H_AZAR] = NoneRoutine,
    [H_MATEWA] = Routine_CyclopsMoveNext,
    [H_KUNYAK] = NoneRoutine,
    [H_KRAGH] = NoneRoutine,
    [H_CRAGHACK] = NoneRoutine,
    [H_KRAAL] = Routine_BallistaRandomShoot2,
    [H_SHAKKARUKAT] = NoneRoutine,
    [H_KUJIN] = NoneRoutine,
    [H_SHIVA] = Routine_ShamansManaRegen,
    [H_MUKHA] = NoneRoutine,
    [H_HAGGASH] = NoneRoutine,
    [H_URGHAT] = NoneRoutine,
    [H_GARUNA] = Routine_CastRandomRegenOrPlague,
    [H_ZOULEIKA] = Routine_CastRandomVulnerability,
    [H_ERIKA] = NoneRoutine,
}

STRONGHOLD_UNIT_DIED = {
    [H_TELSEK] = NoneRoutine,
    [H_GORSHAK] = NoneRoutine,
    [H_GOTAI] = NoneRoutine,
    [H_AZAR] = NoneRoutine,
    [H_MATEWA] = NoneRoutine,
    [H_KUNYAK] = NoneRoutine,
    [H_KRAGH] = NoneRoutine,
    [H_KILGHAN] = NoneRoutine,
    [H_CRAGHACK] = NoneRoutine,
    [H_KRAAL] = NoneRoutine,
    [H_SHAKKARUKAT] = NoneRoutine,
    [H_KUJIN] = NoneRoutine,
    [H_SHIVA] = NoneRoutine,
    [H_MUKHA] = NoneRoutine,
    [H_HAGGASH] = NoneRoutine,
    [H_URGHAT] = NoneRoutine,
    [H_GARUNA] = NoneRoutine,
    [H_ZOULEIKA] = NoneRoutine,
    [H_ERIKA] = NoneRoutine,
}


function DoStrongholdRoutine_CombatPrepare(side, name, id)
    startThread(STRONGHOLD_COMBAT_PREPARE[name], side, id)
end

function DoStrongholdRoutine_CombatStart(side, name, id)
    startThread(STRONGHOLD_COMBAT_START[name], side, id)
end

function DoStrongholdRoutine_CombatTurn(side, name, id)
    startThread(STRONGHOLD_COMBAT_TURN[name], side, id)
end

function DoStrongholdRoutine_UnitDied(side, name, id, unit)
    startThread(STRONGHOLD_UNIT_DIED[name], side, id, unit)
end


-- print("Loaded Stronghold combat routines")
ROUTINES_LOADED[STRONGHOLD] = 1
