
function GetHeroLevel(id) return HERO_DATA[id].Level end
function GetHeroSkillMastery(id, skill) return HERO_DATA[id].Skills[skill] end

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

function GetArmySummary(side)
    local creatures = GetUnits(side, CREATURE)
    for i,cr in creatures do
        local nb = GetCreatureNumber(cr)
        ROUTINE_VARS.InitialCounts[cr] = nb
    end
end

function RandomCreature(side, seed)
    local creatures = GetUnits(side, CREATURE)
    local stacks = length(creatures)
    local target = 0
    if stacks >= 2 then target = random(0,stacks-1,seed) end
    return creatures[target]
end

function SetMana(unit,mana)
    repeat
        SetUnitManaPoints(unit,mana)
        sleep(1)
    until GetUnitManaPoints(unit) == mana
end

function DoCastTargetSpell(unit,spell,mana,target)
    repeat sleep(1) until GetUnitManaPoints(unit) >= mana
	UnitCastAimedSpell(unit,spell,target)
	THREAD_STATE = 1
end

function DoCastAreaSpell(unit,spell,mana,x,y)
    repeat sleep(1) until GetUnitManaPoints(unit) >= mana
	UnitCastAreaSpell(unit,spell,x,y)
	THREAD_STATE = 1
end

function DoCastGlobalSpell(unit,spell,mana)
    repeat sleep(1) until GetUnitManaPoints(unit) >= mana
	UnitCastGlobalSpell(unit,spell)
	THREAD_STATE = 1
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

function RandomShoot_CreatureTypes(side, types)
    local creatures = GetUnits(side,CREATURE)
    for i,cr in creatures do
        if contains(types, GetCreatureType(cr)) then
            ShootCombatUnit(cr, RandomCreature(1-side,1+i))
            sleep(100)
        end
    end
end

function RandomShoot_Ballista(side)
    local ballista = UNIT_SIDE_PREFIX[side]..'-warmachine-WAR_MACHINE_BALLISTA'
    ShootCombatUnit(ballista, RandomCreature(1-side,nil))
end

function TargetShoot_CreatureTypes(side, types, target)
    local creatures = GetUnits(side,CREATURE)
    for i,cr in creatures do
        if contains(types, GetCreatureType(cr)) then
            ShootCombatUnit(cr, target)
            sleep(100)
        end
    end
end

function TargetShoot_Ballista(side, target)
    local ballista = UNIT_SIDE_PREFIX[side]..'-warmachine-WAR_MACHINE_BALLISTA'
    ShootCombatUnit(ballista, target)
end

function CreatureTypesCast_RandomTarget(unit_side, target_side, types, spell)
    local creatures = GetUnits(unit_side, CREATURE)
    for i,cr in creatures do
        if contains(types, GetCreatureType(cr)) then
            UnitCastAimedSpell(cr, spell, RandomCreature(target_side,i))
            sleep(100)
        end
    end
end

function HeroCast_Target(hero, spell, mana, target)
    local m = GetUnitManaPoints(hero)
    if mana == FREE_MANA then SetMana(hero, FREE_MANA) end
    startThread(DoCastTargetSpell, hero, spell, mana, target)
    repeat Wait() until THREAD_STATE == 1
    THREAD_STATE = 0 THREAD_FINISHER = THREAD_LIMIT
    if mana == FREE_MANA then SetMana(hero, m) end
end

function HeroCast_TargetCreatureTypes(hero, spell, mana, side, types)
    local m = GetUnitManaPoints(hero)
    local creatures = GetUnits(side,CREATURE)
    for i,cr in creatures do
        if contains(types, GetCreatureType(cr)) then
            if mana == FREE_MANA then SetMana(hero, FREE_MANA) end
            startThread(DoCastTargetSpell, hero, spell, mana, cr)
            repeat Wait() until THREAD_STATE == 1
            THREAD_STATE = 0 THREAD_FINISHER = THREAD_LIMIT
        end
    end
    if mana == FREE_MANA then SetMana(hero, m) end
end

function HeroCast_AllCreatures(hero, spell, mana, side)
    local m = GetUnitManaPoints(hero)
    local creatures = GetUnits(side, CREATURE)
    for i,cr in creatures do
        if mana == FREE_MANA then SetMana(hero, FREE_MANA) end
        startThread(DoCastTargetSpell, hero, spell, mana, cr)
        repeat Wait() until THREAD_STATE == 1
        THREAD_STATE = 0 THREAD_FINISHER = THREAD_LIMIT
    end
    if mana == FREE_MANA then SetMana(hero, m) end
end

function HeroCast_RandomCreature(hero, spell, mana, side)
    local m = GetUnitManaPoints(hero)
    if mana == FREE_MANA then SetMana(hero, FREE_MANA) end
    startThread(DoCastTargetSpell, hero, spell, mana, RandomCreature(side,m-COMBAT_TURN))
    repeat Wait() until THREAD_STATE == 1
    THREAD_STATE = 0 THREAD_FINISHER = THREAD_LIMIT
    if mana == FREE_MANA then SetMana(hero,m) end
end

function HeroCast_Area(hero, spell, mana, x, y)
    local m = GetUnitManaPoints(hero)
    if mana == FREE_MANA then SetMana(hero, FREE_MANA) end
    startThread(DoCastAreaSpell, hero, spell, mana, x, y)
    repeat Wait() until THREAD_STATE == 1
    THREAD_STATE = 0 THREAD_FINISHER = THREAD_LIMIT
    if mana == FREE_MANA then SetMana(hero, m) end
end

function HeroCast_Global(hero, spell, mana)
    local m = GetUnitManaPoints(hero)
    if mana == FREE_MANA then SetMana(hero, FREE_MANA) end
    startThread(DoCastGlobalSpell, hero, spell, mana)
    repeat Wait() until THREAD_STATE == 1
    THREAD_STATE = 0 THREAD_FINISHER = THREAD_LIMIT
    if mana == FREE_MANA then SetMana(hero, m) end
end

function SummonCreatureStack(side, type, amount)
    if amount > 0 then
        SummonCreature(side, type, amount)
        sleep(1)
    end
end

function SummonCreatureStack_X(side, type, amount, offset)
    if amount > 0 then
        local x = (side == ATTACKER) and (GRID_X_MIN + offset) or (GRID_X_MAX - offset)
        SummonCreature(side, type, amount, x)
        sleep(1)
    end
end

function SummonCreatureStack_XY(side, type, amount, x, y)
    if amount > 0 then
        SummonCreature(side, type, amount, x, y)
        sleep(1)
    end
end

function SetATB_ID(id, value)
    setATB(id, value)
end

function SetATB_CreatureTypes(side, types, value)
    local creatures = GetUnits(side, CREATURE)
    for i,cr in creatures do
        if contains(types, GetCreatureType(cr)) then
            setATB(cr, value)
        end
    end
end

function SetATB_WarMachineType(side, type, value)
    local war_machines = GetUnits(side, WAR_MACHINE)
    for i,wm in war_machines do
        if GetWarMachineType(wm) == type then
            setATB(wm, value)
        end
    end
end

function CreatureToUndead(creature)
	if CREATURES[creature][1] == NECROPOLIS then return creature end
	local tier = CREATURES[creature][2]
	return CREATURES_BY_FACTION[NECROPOLIS][tier][1]
end




-- print("Loaded combat-utils.lua")
ROUTINES_LOADED[9] = 1
