
function Routine_Houndmasters(side, hero, id, mastery)
    -- print("Trigger Houndmasters !")
    local level = GetHeroLevel(side)
    local amount = 10 + 2 * level + random(1, level, 99)
    if hero == H_IVOR then
        SummonCreatureStack_X(side, CREATURE_WOLF, amount, 1)
        sleep(50)
    end
    SummonCreatureStack_X(side, CREATURE_WOLF, amount, 1)
end


function Routine_ShatterMagic(side, hero, id, mastery)
    -- print("Trigger Shatter Magic !")
    local mult = 0.05 + 0.05 * mastery
    local h = GetHero(1-side)
    if h then
        local max = GetUnitMaxManaPoints(h)
        local cur = GetUnitManaPoints(h)
        if hero == H_MARBAS then max = 2 * max end
        local burn = min(cur, round(mult * max))
        SetMana(h, cur-burn)
    end
    local creatures = GetUnits(1-side, CREATURE)
    for i,cr in creatures do
        local m = GetUnitMaxManaPoints(cr)
        local burn = round(mult * m)
        SetMana(cr, m-burn)
    end
end



COMBAT_START_SKILL_ROUTINES = {
    [PERK_HOUNDMASTERS] = Routine_Houndmasters,
    [SKILL_SHATTER_MAGIC] = Routine_ShatterMagic,
}

COMBAT_TURN_SKILL_ROUTINES = {
}

UNIT_DIED_SKILL_ROUTINES = {
}


function DoSkillRoutine_CombatStart(side, name, id)
    for skill,routine in COMBAT_START_SKILL_ROUTINES do
        local mastery = GetHeroSkillMastery(side, skill)
        if mastery >= 1 then
            routine(side, name, id, mastery)
        end
    end
end

function DoSkillRoutine_CombatTurn(side, name, id)
    for skill,routine in COMBAT_TURN_SKILL_ROUTINES do
        local mastery = GetHeroSkillMastery(side, skill)
        if mastery >= 1 then
            routine(side, name, id, mastery)
        end
    end
end

function DoSkillRoutine_UnitDied(side, name, id, unit)
    for skill,routine in UNIT_DIED_SKILL_ROUTINES do
        local mastery = GetHeroSkillMastery(side, skill)
        if mastery >= 1 then
            routine(side, name, id, mastery, unit)
        end
    end
end


-- print("Loaded skills-routines-combat.lua")
ROUTINES_LOADED[12] = 1
