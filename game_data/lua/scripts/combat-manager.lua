
COMBAT_STATE = 0

COMBAT_TURN = 0
CURRENT_UNIT = "none"
CURRENT_UNIT_SIDE = nil

THREAD_LIMIT = 50
THREAD_STATE = 0
THREAD_FINISHER = THREAD_LIMIT

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

function Wait()
    sleep(1)
    THREAD_FINISHER = THREAD_FINISHER - 1
     log.trace("Thread finisher = "..THREAD_FINISHER)
    if THREAD_FINISHER == 0 then THREAD_STATE = 1 end
end

function CheckCombatEnd()
    local alive = nil
    while COMBAT_STATE == 1 do
        for side = 0,1 do
            alive = nil
            for cr,_ in STARTING_ARMY[side] do
                if exist(cr) and GetCreatureNumber(cr) > 0 then
                    alive = not nil
                end
            end
            if not alive then ManageCombatEnd(1-side); break end
        end
        sleep(10)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

function ManageCombatPrepare()
    log.trace("/scripts/combat-manager.lua: ManageCombatPrepare")
    log.debug("ManageCombatPrepare()")
    combatSetPause(1)
    ATTACKER_HERO = GetHero(ATTACKER) and GetHeroName(ATTACKER_HERO_ID) or ""
    DEFENDER_HERO = GetHero(DEFENDER) and GetHeroName(DEFENDER_HERO_ID) or ""
    EnableAutoFinish(nil)
end

function ManageCombatStart()
    log.trace("/scripts/combat-manager.lua: ManageCombatStart")
    log.debug("ManageCombatStart()")
    COMBAT_STATE = 1
    GetArmySummary()

    combatSetPause(1)
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
    startThread(CheckCombatEnd)
end

function ManageCombatTurn(unit)
    log.trace("/scripts/combat-manager.lua: ManageCombatTurn")
    log.debug("ManageCombatTurn", unit)

    if CURRENT_UNIT ~= unit then
        combatSetPause(1)

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
    log.trace("/scripts/combat-manager.lua: ManageUnitDeath")
    log.debug("ManageUnitDeath", unit)

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
end

function ManageCombatEnd(winner)
    log.trace("/scripts/combat-manager.lua: ManageCombatEnd")
    log.debug("ManageCombatEnd", winner)
    COMBAT_STATE = 2
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
    for _,cr in GetUnits(CREATURE, 1-winner) do RemoveCombatUnit(cr) end

    EnableAutoFinish(1)
    combatSetPause(nil)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

SCRIPTS_GROUP = {
    [1] = {
        "/scripts/game/creatures.lua",
        "/scripts/game/spells.lua",
        "/scripts/game/skills.lua",
        "/scripts/game/artifacts.lua",
        "/scripts/game/heroes.lua",
    },
    [2] = {
        "/scripts/combat/combat-data.lua",
        "/scripts/combat/combat-utils.lua",
    },
    [3] = {
        "/scripts/combat/routines/abilities-routines-combat.lua",
        "/scripts/combat/routines/heroes-routines-combat.lua",
        "/scripts/combat/routines/skills-routines-combat.lua",
        "/scripts/combat/routines/artifacts-routines-combat.lua",
    },
}
function LoadScripts(wg)
    log.trace("Loading scripts group "..wg)
    for i, file in SCRIPTS_GROUP[wg] do dofile(file) end
    sleep(1)
end
LoadScripts(1) LoadScripts(2) LoadScripts(3)
