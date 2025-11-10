
function GetHeroLevel(id) return HERO_DATA[id].Level end
function GetHeroSkillMastery(id, skill) return HERO_DATA[id].Skills[skill] end
function HasHeroEquippedArtifact(id, artifact) return HERO_DATA[id].Artifacts[artifact] == 1 end
function HasHeroActiveArtifactSet(id, artfset) return HERO_DATA[id].ArtfSets[artfset] == 1 end

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

function InitializeRandomSeed()
    RANDOM_SEED = RANDOM_SEED + HERO_DATA[0].Level
    RANDOM_SEED = RANDOM_SEED + HERO_DATA[1].Level
end

function GetArmySummary()
    for side = 0,1 do
        local creatures = GetUnits(side, CREATURE)
        for i,cr in creatures do
            local type = GetCreatureType(cr)
            local nb = GetCreatureNumber(cr)
            local x, y = GetUnitPosition(cr)
            STARTING_ARMY[side][cr] = nb
            RANDOM_SEED = RANDOM_SEED + side + type + nb + x + y
        end
    end
end

function RandomCreature(side, seed)
    local creatures = GetUnits(side, CREATURE)
    local stacks = length(creatures)
    if stacks >= 2 then
        return creatures[random(0,stacks-1,seed)]
    elseif stacks == 1 then
        return creatures[0]
    else
        return nil
    end
end

function SetMana(unit,mana)
    repeat
        SetUnitManaPoints(unit,mana)
        sleep(1)
    until GetUnitManaPoints(unit) == mana
end

function RefreshMana(unit,amount)
    local cur = GetUnitManaPoints(unit)
    local max = GetUnitMaxManaPoints(unit)
    if cur < max then
        SetMana(unit, min(cur+amount,max))
    end
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

function TryShootTarget(unit, target, delay)
    startThread(ShootCombatUnit, unit, target)
    sleep(delay or 1)
    return unit ~= CURRENT_UNIT
end

function SummonCreatureSideOffset(side, type, amount, offset, name)
    if amount > 0 then
        SUMMON_ID = SUMMON_ID + 1
        if not name then name = "side-"..side.."_creature-"..type.."_"..SUMMON_ID end
        local x = (side == ATTACKER) and (GRID_X_MIN + offset) or (GRID_X_MAX - offset)
        SummonCreature(side, type, amount, x, -1, 1, name)
        repeat sleep() until exist(name)
        return name
    end
    return nil
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

function IncreaseCreatureStack(side, types, amount)
    local creatures = GetUnits(side, CREATURE)
    for i,cr in creatures do
        local type = GetCreatureType(cr)
        if contains(types, type) then
            local nb = GetCreatureNumber(cr) + amount
            local x,y = GetUnitPosition(cr)
            RemoveCombatUnit(cr)
            repeat sleep() until not exist(cr)
            AddCreature(side, type, nb, x, y, nil, cr)
            repeat sleep() until exist(cr)
            return cr
        end
    end
    return nil
end

function IsCreature2x2(unit)
    local type = GetCreatureType(unit)
    if CREATURES[type][2] >= 6 then return 1 end
    if CREATURES[type][2] == 5 then
        if type == CREATURE_MANTICORE then return 1 end
        if CREATURES[type][1] == PRESERVE or CREATURES[type][1] == NECROPOLIS or CREATURES[type][1] == INFERNO then return 1 end
    end
    if CREATURES[type][2] == 4 then
        if CREATURES[type][1] == HAVEN or CREATURES[type][1] == FORTRESS or CREATURES[type][1] == DUNGEON or CREATURES[type][1] == STRONGHOLD then return 1 end
    end
    return nil
end

function CreatureAtPosition(x,y)
    for side = 0,1 do
        for i,cr in GetUnits(side, CREATURE) do
            local ux,uy = GetUnitPosition(cr)
            if IsCreature2x2(cr) then
                if (x == ux and y == uy) or (x+1 == ux and y == uy) or (x == ux and y+1 == uy) or (x+1 == ux and y+1 == uy) then return side end
            else
                if (x == ux and y == uy) then return side end
            end
        end
    end
    return nil
end

function CanCreatureShoot(unit)
    local side = GetUnitSide(unit)
    local x,y = GetUnitPosition(unit)
    if IsCreature2x2(unit) then
        return 1 -- todo
    else
        for i = -1,1 do for j = -1,1 do
            if i ~= 0 or j ~= 0 then
                if CreatureAtPosition(x+i,y+j) == (1-side) then return nil end
            end
        end end
    end
    return 1
end

function CreatureToUndead(creature)
	if CREATURES[creature][1] == NECROPOLIS or creature == CREATURE_MUMMY then return creature end
	local tier = CREATURES[creature][2]
	return CREATURES_BY_FACTION[NECROPOLIS][tier][1]
end


function Win()
    for side = 0,1 do
        if GetHost(side) == COMPUTER then
            Finish(1-side)
        end
    end
end



-- log(TRACE, "Loaded combat-utils.lua")
ROUTINES_LOADED[9] = 1
