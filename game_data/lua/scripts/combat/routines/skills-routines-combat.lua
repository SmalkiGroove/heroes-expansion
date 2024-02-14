
function Routine_Houndmasters(side, hero, id, mastery)
    -- print("Trigger Houndmasters !")
    local level = GetHeroLevel(side)
    local amount = 10 + 2 * level + random(1, level, 99)
    local x = 1 + side * 11
    if hero == H_IVOR then
        SummonCreatureStack_X(side, CREATURE_WOLF, amount, x)
        sleep(50)
    end
    SummonCreatureStack_X(side, CREATURE_WOLF, amount, x)
end


function Routine_ShatterMagic(side, hero, id, mastery)
    -- print("Trigger Shatter Magic !")
    local mult = 0.95 - 0.05 * mastery
    
end



COMBAT_PREPARE_SKILL_ROUTINES = {
    [PERK_HOUNDMASTERS] = Routine_Houndmasters,
}

COMBAT_START_SKILL_ROUTINES = {
    [SKILL_SHATTER_MAGIC] = Routine_ShatterMagic,
}

COMBAT_TURN_SKILL_ROUTINES = {
}

UNIT_DIED_SKILL_ROUTINES = {
}


function DoSkillRoutine_CombatPrepare(side, name, id)
    for skill,routine in COMBAT_PREPARE_SKILL_ROUTINES do
        local mastery = GetHeroSkillMastery(side, skill)
        if mastery >= 1 then
            startThread(routine, side, name, id, mastery)
        end
    end
end

function DoSkillRoutine_CombatStart(side, name, id)
    for skill,routine in COMBAT_START_SKILL_ROUTINES do
        local mastery = GetHeroSkillMastery(side, skill)
        if mastery >= 1 then
            startThread(routine, side, name, id, mastery)
        end
    end
end

function DoSkillRoutine_CombatTurn(side, name, id)
    for skill,routine in COMBAT_TURN_SKILL_ROUTINES do
        local mastery = GetHeroSkillMastery(side, skill)
        if mastery >= 1 then
            startThread(routine, side, name, id, mastery)
        end
    end
end

function DoSkillRoutine_UnitDied(side, name, id, unit)
    for skill,routine in UNIT_DIED_SKILL_ROUTINES do
        local mastery = GetHeroSkillMastery(side, skill)
        if mastery >= 1 then
            startThread(routine, side, name, id, mastery, unit)
        end
    end
end


-- print("Loaded skills-routines-combat.lua")
ROUTINES_LOADED[11] = 1
