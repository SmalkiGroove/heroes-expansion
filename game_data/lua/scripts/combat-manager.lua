
ENABLE_SCRIPT = 0
COMBAT_PAUSE = 0

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

UNIT_SIDE_PREFIX = {
    [0] = "attacker",
    [1] = "defender"
}

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

function EnableScript() ENABLE_SCRIPT = 1 end

function CheckEnableScript()
    consoleCmd("@SetGameVar('h5x_combat_init', 'false')")
    repeat sleep(1) until GetGameVar('h5x_combat_init') == 'false'
    consoleCmd("@if GetGameVar('h5x_combat_init') == 'false' then SetGameVar('h5x_combat_init', 'true') EnableScript() end")
    repeat sleep(1) until GetGameVar('h5x_combat_init') == 'true'
end

function FetchData(hero)
    local level = GetGameVar(VarHeroLevel(hero))
    local attack = GetGameVar(VarHeroStatAttack(hero))
    local defense = GetGameVar(VarHeroStatDefense(hero))
    local spellpower = GetGameVar(VarHeroStatSpellpower(hero))
    local knowledge = GetGameVar(VarHeroStatKnowledge(hero))
    local morale = GetGameVar(VarHeroStatMorale(hero))
    local luck = GetGameVar(VarHeroStatLuck(hero))
    HERO_DATA[hero] = {
        [0] = 0 + level,
        [1] = 0 + attack,
        [2] = 0 + defense,
        [3] = 0 + spellpower,
        [4] = 0 + knowledge,
        [5] = 0 + morale,
        [6] = 0 + luck,
    }
    print("Hero "..hero.." data collected. Lvl "..HERO_DATA[hero][0]..
        " / Att "..HERO_DATA[hero][1].." / Def "..HERO_DATA[hero][2]..
        " / Spp "..HERO_DATA[hero][3].." / Klg "..HERO_DATA[hero][4]..
        " / Mrl "..HERO_DATA[hero][5].." / Lck "..HERO_DATA[hero][6])
end

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

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

function ManageCombatPrepare()
    print("Manage combat prepare")
    CheckEnableScript()
    if ENABLE_SCRIPT == 0 then return end

    ATTACKER_HERO = GetHero(ATTACKER) and GetHeroName(ATTACKER_HERO_ID) or ""
    DEFENDER_HERO = GetHero(DEFENDER) and GetHeroName(DEFENDER_HERO_ID) or ""
    if ATTACKER_HERO ~= "" then
        startThread(FetchData, ATTACKER_HERO)
    end
    if DEFENDER_HERO ~= "" then
        startThread(FetchData, DEFENDER_HERO)
    end
end

function ManageCombatStart()
    print("Manage combat start")
    if ENABLE_SCRIPT == 0 then return end

    Pause()
	if ATTACKER_HERO ~= "" then
		startThread(DoHeroSpeRoutine_CombatStart, ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID)
	end
	if DEFENDER_HERO ~= "" then
		startThread(DoHeroSpeRoutine_CombatStart, DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID)
	end
    Resume()
end

function ManageCombatTurn(unit)
    print("Manage combat turn")
    if ENABLE_SCRIPT == 0 then return end

    if CURRENT_UNIT ~= unit then
        COMBAT_TURN = COMBAT_TURN + 1
        CURRENT_UNIT = unit
        CURRENT_UNIT_SIDE = IsAttacker(unit) and ATTACKER or DEFENDER

        Pause()
        if ATTACKER_HERO ~= "" then
            startThread(DoHeroSpeRoutine_CombatTurn, ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID)
        end
        if DEFENDER_HERO ~= "" then
            startThread(DoHeroSpeRoutine_CombatTurn, DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID)
        end
        Resume()
    end
end

function ManageUnitDeath(unit)
    print("Manage unit death")
    if ENABLE_SCRIPT == 0 then return end

    Pause()
    if ATTACKER_HERO ~= "" then
		startThread(DoHeroSpeRoutine_UnitDied, ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID, unit)
	end
	if DEFENDER_HERO ~= "" then
		startThread(DoHeroSpeRoutine_UnitDied, DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID, unit)
	end
    Resume()
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


function GetHeroLevel(hero) return HERO_DATA[hero][0] end
function GetHeroAttack(hero) return HERO_DATA[hero][1] end
function GetHeroDefense(hero) return HERO_DATA[hero][2] end
function GetHeroSpellpower(hero) return HERO_DATA[hero][3] end
function GetHeroKnowledge(hero) return HERO_DATA[hero][4] end
function GetHeroMorale(hero) return HERO_DATA[hero][5] end
function GetHeroLuck(hero) return HERO_DATA[hero][6] end

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

LoadScript("/scripts/game/creatures.lua", 1)
LoadScript("/scripts/game/spells.lua", 2)
LoadScript("/scripts/game/skills.lua",3)
LoadScript("/scripts/game/artifacts.lua", 4)
LoadScript("/scripts/game/heroes.lua", 5)
LoadScript("/scripts/combat/handlers/game-vars.lua", 6)
LoadScript("/scripts/hero-combat-routines/_common.lua", 8)
