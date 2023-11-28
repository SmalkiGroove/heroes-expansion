COMBAT_PAUSE = 0
COMBAT_READY = nil

COMBAT_TURN = 0
CURRENT_UNIT = "none"
CURRENT_UNIT_SIDE = nil

THREAD_LIMIT = 50
THREAD_STATE = 0
THREAD_FINISHER = THREAD_LIMIT

GRID_X_MIN = 2
GRID_X_MAX = 15
GRID_Y_MIN = 1
GRID_Y_MAX = 12

NO_COST = 0
FREE_MANA = 99

ATB_INSTANT = 1
ATB_NEXT = 0.99
ATB_HALF = 0.5
ATB_ZERO = 0

NO_ATB_RESET_HEROES = {
    [HERO] = { H_BERTRAND, H_FINDAN, H_NEBIROS, H_THRALSAI, H_KRAGH },
    [CREATURE] = { H_WYNGAAL, H_CRAGHACK },
    [WAR_MACHINE] = { },
}

UNIT_SIDE_PREFIX = {
    [0] = "attacker",
    [1] = "defender"
}


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

function Pause()
    COMBAT_PAUSE = 1
    combatSetPause(1)
end

function Resume()
    repeat sleep(5) until COMBAT_PAUSE == 0
    combatSetPause(nil)
end

function Wait()
    sleep(1)
    THREAD_FINISHER = THREAD_FINISHER - 1
    -- print("Thread finisher = "..THREAD_FINISHER)
    if THREAD_FINISHER == 0 then THREAD_STATE = 1 end
end

function ParseData(hero, data)
    local m = GetUnitManaPoints(hero)
    local level = mod(trunc(m * 0.0000001), 100)
    local set1 = mod(trunc(m * 0.00001), 100)
    local set2 = mod(trunc(m * 0.001), 100)
    SetUnitManaPoints(hero, m - 1000000000 - level * 10000000 - set1 * 100000 - set2 * 1000)
    data["LVL"] = level
    data["SET1"] = set1
    data["SET2"] = set2
end

function GetHeroLevel(data)
    return data["LVL"]
end

function GetHeroArtifactSets(data)
    return data["SET1"], data["SET2"]
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

function ResetATB()
    if contains(NO_ATB_RESET_HEROES[CREATURE], ATTACKER_HERO) == nil then
        for i,cr in GetUnits(ATTACKER, CREATURE) do setATB(cr, ATB_ZERO) end
    end
    if contains(NO_ATB_RESET_HEROES[CREATURE], DEFENDER_HERO) == nil then
        for i,cr in GetUnits(DEFENDER, CREATURE) do setATB(cr, ATB_ZERO) end
    end

    if contains(NO_ATB_RESET_HEROES[WAR_MACHINE], ATTACKER_HERO) == nil then
        for i,wm in GetUnits(ATTACKER, WAR_MACHINE) do setATB(wm, ATB_ZERO) end
    end
    if contains(NO_ATB_RESET_HEROES[WAR_MACHINE], DEFENDER_HERO) == nil then
        for i,wm in GetUnits(DEFENDER, WAR_MACHINE) do setATB(wm, ATB_ZERO) end
    end

    if contains(NO_ATB_RESET_HEROES[HERO], ATTACKER_HERO) == nil then
        if ATTACKER_HERO ~= "" then setATB(ATTACKER_HERO_ID, ATB_ZERO) end
    end
    if contains(NO_ATB_RESET_HEROES[HERO], DEFENDER_HERO) == nil then
        if DEFENDER_HERO ~= "" then setATB(DEFENDER_HERO_ID, ATB_ZERO) end
    end

    COMBAT_READY = not nil
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

ROUTINES_LOADED = {
	[0] = 0,
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
	[6] = 0,
	[7] = 0,
	[8] = 0,
}

function LoadScript(path, key)
	-- print("Loading script "..path)
	dofile(path)
	repeat sleep(1) until ROUTINES_LOADED[key] == 1
end

LoadScript("/scripts/hero-combat-routines/_common.lua", 0)
LoadScript("/scripts/hero-combat-routines/academy.lua", ACADEMY)
LoadScript("/scripts/hero-combat-routines/dungeon.lua", DUNGEON)
LoadScript("/scripts/hero-combat-routines/fortress.lua", FORTRESS)
LoadScript("/scripts/hero-combat-routines/haven.lua", HAVEN)
LoadScript("/scripts/hero-combat-routines/inferno.lua", INFERNO)
LoadScript("/scripts/hero-combat-routines/necropolis.lua", NECROPOLIS)
LoadScript("/scripts/hero-combat-routines/preserve.lua", PRESERVE)
LoadScript("/scripts/hero-combat-routines/stronghold.lua", STRONGHOLD)

PREPARE_ROUTINES = {
    [0] = DoCommonRoutine_CombatPrepare,
    [1] = DoHavenRoutine_CombatPrepare,
    [2] = DoPreserveRoutine_CombatPrepare,
    [3] = DoInfernoRoutine_CombatPrepare,
    [4] = DoNecropolisRoutine_CombatPrepare,
    [5] = DoAcademyRoutine_CombatPrepare,
    [6] = DoDungeonRoutine_CombatPrepare,
    [7] = DoFortressRoutine_CombatPrepare,
    [8] = DoStrongholdRoutine_CombatPrepare,
}

START_ROUTINES = {
    [0] = DoCommonRoutine_CombatStart,
    [1] = DoHavenRoutine_CombatStart,
    [2] = DoPreserveRoutine_CombatStart,
    [3] = DoInfernoRoutine_CombatStart,
    [4] = DoNecropolisRoutine_CombatStart,
    [5] = DoAcademyRoutine_CombatStart,
    [6] = DoDungeonRoutine_CombatStart,
    [7] = DoFortressRoutine_CombatStart,
    [8] = DoStrongholdRoutine_CombatStart,
}

TURN_ROUTINES = {
    [0] = DoCommonRoutine_CombatTurn,
    [1] = DoHavenRoutine_CombatTurn,
    [2] = DoPreserveRoutine_CombatTurn,
    [3] = DoInfernoRoutine_CombatTurn,
    [4] = DoNecropolisRoutine_CombatTurn,
    [5] = DoAcademyRoutine_CombatTurn,
    [6] = DoDungeonRoutine_CombatTurn,
    [7] = DoFortressRoutine_CombatTurn,
    [8] = DoStrongholdRoutine_CombatTurn,
}

DEATH_ROUTINES = {
    [0] = DoCommonRoutine_UnitDied,
    [1] = DoHavenRoutine_UnitDied,
    [2] = DoPreserveRoutine_UnitDied,
    [3] = DoInfernoRoutine_UnitDied,
    [4] = DoNecropolisRoutine_UnitDied,
    [5] = DoAcademyRoutine_UnitDied,
    [6] = DoDungeonRoutine_UnitDied,
    [7] = DoFortressRoutine_UnitDied,
    [8] = DoStrongholdRoutine_UnitDied,
}

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

function ManageCombatPrepare()
    -- print("Manage combat prepare")
    ATTACKER_HERO = GetHero(ATTACKER) and GetHeroName(ATTACKER_HERO_ID) or ""
    DEFENDER_HERO = GetHero(DEFENDER) and GetHeroName(DEFENDER_HERO_ID) or ""
    if ATTACKER_HERO ~= "" then
        ATTACKER_RACE = GetHeroFactionID(ATTACKER_HERO)
        ParseData(GetHero(ATTACKER), ATTACKER_HERO_DATA)
        print("Hero "..ATTACKER_HERO.." level "..GetHeroLevel(ATTACKER_HERO_DATA))
    end
    if DEFENDER_HERO ~= "" then
        DEFENDER_RACE = GetHeroFactionID(DEFENDER_HERO)
        ParseData(GetHero(DEFENDER), DEFENDER_HERO_DATA)
        print("Hero "..DEFENDER_HERO.." level "..GetHeroLevel(DEFENDER_HERO_DATA))
    end
end

function ManageCombatStart()
    -- print("Manage combat start")
    Pause()
    ResetATB()
    repeat sleep(1) until COMBAT_READY
    
	if ATTACKER_HERO ~= "" then
        local startroutine = START_ROUTINES[ATTACKER_RACE]
		startThread(startroutine, ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID, ATTACKER_HERO_DATA)
	end
	if DEFENDER_HERO ~= "" then
		local startroutine = START_ROUTINES[DEFENDER_RACE]
		startThread(startroutine, DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID, DEFENDER_HERO_DATA)
	end
    Resume()
end

function ManageCombatTurn(unit)
    -- print("Manage combat turn")
    if CURRENT_UNIT ~= unit then
        COMBAT_TURN = COMBAT_TURN + 1
        CURRENT_UNIT = unit
        CURRENT_UNIT_SIDE = IsAttacker(unit) and ATTACKER or DEFENDER

        Pause()
        if ATTACKER_HERO ~= "" then
            local turnroutine = TURN_ROUTINES[ATTACKER_RACE]
            startThread(turnroutine, ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID, ATTACKER_HERO_DATA)
        end
        if DEFENDER_HERO ~= "" then
            local turnroutine = TURN_ROUTINES[DEFENDER_RACE]
            startThread(turnroutine, DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID, DEFENDER_HERO_DATA)
        end
        Resume()
    end
end

function ManageUnitDeath(unit)
    -- print("Manage unit death")
    Pause()
    if ATTACKER_HERO ~= "" then
        local deathroutine = DEATH_ROUTINES[ATTACKER_RACE]
		startThread(deathroutine, ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID, ATTACKER_HERO_DATA, unit)
	end
	if DEFENDER_HERO ~= "" then
		local deathroutine = DEATH_ROUTINES[DEFENDER_RACE]
		startThread(deathroutine, DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID, DEFENDER_HERO_DATA, unit)
	end
    Resume()
end
