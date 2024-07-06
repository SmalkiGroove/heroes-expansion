
dofile("/scripts/combat/handlers/game-vars.lua")

ENABLE_SCRIPT = 1

COMBAT_TURN = 0
CURRENT_UNIT = "none"
CURRENT_UNIT_SIDE = nil

THREAD_LIMIT = 50
THREAD_STATE = 0
THREAD_FINISHER = THREAD_LIMIT

HERO_DATA = {
    [ATTACKER] = {
        Level = 1,
        Skills = {},
        ArtfSets = {},
    },
    [DEFENDER] = {
        Level = 1,
        Skills = {},
        ArtfSets = {},
    }
}

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

function EnableScript() ENABLE_SCRIPT = 1 end

function CheckEnableScript()
    consoleCmd("@SetGameVar('h5x_combat_init', 'false')")
    repeat sleep() until GetGameVar('h5x_combat_init') == 'false'
    consoleCmd("@if GetGameVar('h5x_combat_init') == 'false' then SetGameVar('h5x_combat_init', 'true') EnableScript() end")
    repeat sleep() until GetGameVar('h5x_combat_init') == 'true'
end

function FetchData(name, id)
    log("Fetch data for hero "..name)
    local level = GetGameVar(VarHeroLevel(name))
    local shattermagic = GetGameVar(VarHeroSkillId(name,SKILL_SHATTER_MAGIC))
    local houndmasters = GetGameVar(VarHeroSkillId(name,PERK_HOUNDMASTERS))
    HERO_DATA[id].Level = 0 + level
    HERO_DATA[id].Skills = {
        [SKILL_SHATTER_MAGIC] = 0 + shattermagic,
        [PERK_HOUNDMASTERS] = 0 + houndmasters,
    }
    log("Lvl "..HERO_DATA[id].Level)
end

function Wait()
    sleep(1)
    THREAD_FINISHER = THREAD_FINISHER - 1
    -- log("Thread finisher = "..THREAD_FINISHER)
    if THREAD_FINISHER == 0 then THREAD_STATE = 1 end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

function ManageCombatPrepare()
    -- log("$ Manage combat prepare")
    -- CheckEnableScript()
    if ENABLE_SCRIPT == 0 then return end

    combatSetPause(1)
    ATTACKER_HERO = GetHero(ATTACKER) and GetHeroName(ATTACKER_HERO_ID) or ""
    DEFENDER_HERO = GetHero(DEFENDER) and GetHeroName(DEFENDER_HERO_ID) or ""
    if ATTACKER_HERO ~= "" then
        startThread(FetchData, ATTACKER_HERO, ATTACKER)
    end
    if DEFENDER_HERO ~= "" then
        startThread(FetchData, DEFENDER_HERO, DEFENDER)
    end
end

function ManageCombatStart()
    -- log("$ Manage combat start")
    if ENABLE_SCRIPT == 0 then return end
    startThread(GetArmySummary, ATTACKER)
    startThread(GetArmySummary, DEFENDER)

    combatSetPause(1)
    DoAbilitiesRoutine_CombatStart()
	if ATTACKER_HERO ~= "" then
        DoSkillRoutine_CombatStart(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID)
		DoHeroSpeRoutine_CombatStart(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID)
	end
	if DEFENDER_HERO ~= "" then
		DoSkillRoutine_CombatStart(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID)
		DoHeroSpeRoutine_CombatStart(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID)
	end
    combatSetPause(nil)
end

function ManageCombatTurn(unit)
    -- log("$ Manage combat turn")
    if ENABLE_SCRIPT == 0 then return end

    if CURRENT_UNIT ~= unit then
        COMBAT_TURN = COMBAT_TURN + 1
        CURRENT_UNIT = unit
        CURRENT_UNIT_SIDE = GetUnitSide(unit)

        combatSetPause(1)
        if ATTACKER_HERO ~= "" then
            DoHeroSpeRoutine_CombatTurn(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID)
        end
        if DEFENDER_HERO ~= "" then
            DoHeroSpeRoutine_CombatTurn(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID)
        end
        DoAbilitiesRoutine_CombatTurn()
        combatSetPause(nil)
    end
end

function ManageUnitDeath(unit)
    -- log("$ Manage unit death")
    if ENABLE_SCRIPT == 0 then return end

    if ATTACKER_HERO ~= "" then
		DoHeroSpeRoutine_UnitDied(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID, unit)
	end
	if DEFENDER_HERO ~= "" then
		DoHeroSpeRoutine_UnitDied(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID, unit)
	end
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

ROUTINES_LOADED = {
	[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0,
	[6] = 0, [7] = 0, [8] = 0, [9] = 0, [10]= 0,
    [11]= 0, [12]= 0, [13]= 0, [14]= 0, [15]= 0,
}

function LoadScript(path, key)
	-- log("Loading script "..path)
	dofile(path) sleep()
	-- repeat sleep() until ROUTINES_LOADED[key] == 1
end

LoadScript("/scripts/game/creatures.lua", 1)
LoadScript("/scripts/game/spells.lua", 2)
LoadScript("/scripts/game/skills.lua",3)
LoadScript("/scripts/game/artifacts.lua", 4)
LoadScript("/scripts/game/heroes.lua", 5)
LoadScript("/scripts/combat/combat-data.lua", 8)
LoadScript("/scripts/combat/combat-utils.lua", 9)
LoadScript("/scripts/combat/routines/abilities-routines-combat.lua", 10)
LoadScript("/scripts/combat/routines/heroes-routines-combat.lua", 11)
LoadScript("/scripts/combat/routines/skills-routines-combat.lua", 12)
LoadScript("/scripts/combat/routines/artifacts-routines-combat.lua", 13)
