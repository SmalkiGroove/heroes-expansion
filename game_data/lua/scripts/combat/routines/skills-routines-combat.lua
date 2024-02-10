
function Routine_Houndmasters(side, hero)
    -- print("Trigger Houndmasters !")
    local amount = 10
    local x = 2 + side * 13
    SummonCreatureStack_X(side, CREATURE_WOLF, amount, x)
    COMBAT_PAUSE = 0
end



COMBAT_PREPARE_SKILL_ROUTINES = {
    [PERK_HOUNDMASTERS] = Routine_Houndmasters,
}

COMBAT_START_SKILL_ROUTINES = {
}

COMBAT_TURN_SKILL_ROUTINES = {
}

UNIT_DIED_SKILL_ROUTINES = {
}


function DoSkillRoutine_CombatPrepare(side, name, id)
    for _,skill in COMBAT_PREPARE_SKILL_ROUTINES do
        if GetHeroSkillMastery(hero, skill) >= 1 then
            startThread(COMBAT_PREPARE_SKILL_ROUTINES[skill], side, id)
        end
    end
end

function DoSkillRoutine_CombatStart(side, name, id)
    for _,skill in COMBAT_START_SKILL_ROUTINES do
        if GetHeroSkillMastery(hero, skill) >= 1 then
            startThread(COMBAT_START_SKILL_ROUTINES[skill], side, id)
        end
    end
end

function DoSkillRoutine_CombatTurn(side, name, id)
    for _,skill in COMBAT_TURN_SKILL_ROUTINES do
        if GetHeroSkillMastery(hero, skill) >= 1 then
            startThread(COMBAT_TURN_SKILL_ROUTINES[skill], side, id)
        end
    end
end

function DoSkillRoutine_UnitDied(side, name, id, unit)
    for _,skill in UNIT_DIED_SKILL_ROUTINES do
        if GetHeroSkillMastery(hero, skill) >= 1 then
            startThread(UNIT_DIED_SKILL_ROUTINES[skill], side, id, unit)
        end
    end
end


-- print("Loaded skills-routines-combat.lua")
ROUTINES_LOADED[11] = 1
