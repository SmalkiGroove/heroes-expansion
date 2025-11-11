
dofile("/scripts/game-vars.lua")

COMBAT_TURN = 0
CURRENT_UNIT = "none"
CURRENT_UNIT_SIDE = nil

THREAD_LIMIT = 50
THREAD_STATE = 0
THREAD_FINISHER = THREAD_LIMIT

HERO_DATA = {
    [ATTACKER] = {
        Level = 0,
        Skills = {},
        Artifacts = {},
        ArtfSets = {},
    },
    [DEFENDER] = {
        Level = 0,
        Skills = {},
        Artifacts = {},
        ArtfSets = {},
    }
}

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

function FetchData(name, id)
    log(DEBUG, "Fetch data for hero "..name)
    local temp = GetGameVar(VarHeroLevel(name))
    HERO_DATA[id].Level = 0 + temp
    -- log(TRACE, "* fetched level ok")
    for _,s in COMBAT_EFFECT_SKILLS do
        temp = GetGameVar(VarHeroSkillId(name,s))
        HERO_DATA[id].Skills[s] = temp == "" and 0 or 0 + temp
    end
    -- log(TRACE, "* fetched skills ok")
    for _,a in COMBAT_EFFECT_ARTIFACTS do
        temp = GetGameVar(VarHeroArtifactId(name,a))
        HERO_DATA[id].Artifacts[a] = temp == "" and 0 or 0 + temp
    end
    -- log(TRACE, "* fetched artifacts ok")
    for set = ARTFSET_NONE,ARTFSET_ACTIVABLES_COUNT do
        temp = GetGameVar(VarHeroArtfsetId(name,set))
        HERO_DATA[id].ArtfSets[set] = temp == "" and 0 or 0 + temp
    end
    -- log(TRACE, "* fetched artifact sets ok")
    log(DEBUG, "Hero "..name.." : Lvl "..HERO_DATA[id].Level)
end

function Wait()
    sleep(1)
    THREAD_FINISHER = THREAD_FINISHER - 1
    -- log(TRACE, "Thread finisher = "..THREAD_FINISHER)
    if THREAD_FINISHER == 0 then THREAD_STATE = 1 end
end

function PauseTemp()
    repeat Wait() until THREAD_STATE == 1
    THREAD_STATE = 0 THREAD_FINISHER = THREAD_LIMIT
    combatSetPause(nil)
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

startThread(CheckEnableScript1)

function ManageCombatPrepare()
    log(TRACE, "$ Manage combat prepare")
    -- CheckEnableScript2()
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
    sleep(100)
    InitializeRandomSeed()
    EnableAutoFinish(nil)
end

function ManageCombatStart()
    log(TRACE, "$ Manage combat start")
    if ENABLE_SCRIPT == 0 then return end
    GetArmySummary()
    log(DEBUG, "Combat random seed = "..RANDOM_SEED)

    combatSetPause(1) --startThread(PauseTemp)
    DoAbilitiesRoutine_CombatStart()
	if ATTACKER_HERO ~= "" then
        DoSkillRoutine_CombatStart(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID)
		DoHeroSpeRoutine_CombatStart(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID)
        DoArtifactRoutine_CombatStart(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID)
	end
	if DEFENDER_HERO ~= "" then
		DoSkillRoutine_CombatStart(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID)
		DoHeroSpeRoutine_CombatStart(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID)
		DoArtifactRoutine_CombatStart(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID)
	end
    combatSetPause(nil)
end

function ManageCombatTurn(unit)
    log(TRACE, "$ Manage combat turn - "..unit)
    if ENABLE_SCRIPT == 0 then return end

    if CURRENT_UNIT ~= unit then
        combatSetPause(1) --startThread(PauseTemp)

        COMBAT_TURN = COMBAT_TURN + 1
        CURRENT_UNIT = unit
        CURRENT_UNIT_SIDE = GetUnitSide(unit)

        if ATTACKER_HERO ~= "" then
            DoSkillRoutine_CombatTurn(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID)
            DoHeroSpeRoutine_CombatTurn(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID)
            DoArtifactRoutine_CombatTurn(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID)
        end
        if DEFENDER_HERO ~= "" then
            DoSkillRoutine_CombatTurn(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID)
            DoHeroSpeRoutine_CombatTurn(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID)
            DoArtifactRoutine_CombatTurn(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID)
        end
        DoAbilitiesRoutine_CombatTurn()
        combatSetPause(nil)
    end
end

function ManageUnitDeath(unit)
    log(TRACE, "$ Manage unit death - "..unit)
    if ENABLE_SCRIPT == 0 then return end

    if ATTACKER_HERO ~= "" then
        DoSkillRoutine_UnitDied(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID, unit)
		DoHeroSpeRoutine_UnitDied(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID, unit)
        DoArtifactRoutine_UnitDied(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID, unit)
	end
	if DEFENDER_HERO ~= "" then
        DoSkillRoutine_UnitDied(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID, unit)
		DoHeroSpeRoutine_UnitDied(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID, unit)
		DoArtifactRoutine_UnitDied(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID, unit)
	end

    do
        local winner = nil
        local alive = nil
        for side = 0,1 do
            alive = nil
            for cr,_ in STARTING_ARMY[side] do
                if cr ~= unit and exist(cr) and GetCreatureNumber(cr) > 0 then
                    alive = not nil 
                end
            end
            if not alive then winner = 1 - side; break end
        end
        if winner then ManageCombatEnd(winner) end
    end
end

function ManageCombatEnd(winner)
    log(TRACE, "$ Manage combat end - "..winner)
    if ENABLE_SCRIPT == 1 then
        combatSetPause(1)

        DoAbilitiesRoutine_CombatEnd()
        if ATTACKER_HERO ~= "" then
            DoSkillRoutine_CombatEnd(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID, winner)
            DoHeroSpeRoutine_CombatEnd(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID, winner)
            DoArtifactRoutine_CombatEnd(ATTACKER, ATTACKER_HERO, ATTACKER_HERO_ID, winner)
        end
        if DEFENDER_HERO ~= "" then
            DoSkillRoutine_CombatEnd(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID, winner)
            DoHeroSpeRoutine_CombatEnd(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID, winner)
            DoArtifactRoutine_CombatEnd(DEFENDER, DEFENDER_HERO, DEFENDER_HERO_ID, winner)
        end

        Finish(winner)
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
	-- log(TRACE, "Loading script "..path)
	dofile(path)
	sleep() -- repeat sleep() until ROUTINES_LOADED[key] == 1
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
