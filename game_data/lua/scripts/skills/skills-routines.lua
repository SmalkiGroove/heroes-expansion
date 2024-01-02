
function Routine_Offence(player, hero)
    local m = GetHeroSkillMastery(hero, SKILL_OFFENCE)

end


START_TRIGGER_SKILLS_ROUTINES = {
    [SKILL_NONE] = NoneRoutine,
}

DAILY_TRIGGER_SKILLS_ROUTINES = {
    [SKILL_NONE] = NoneRoutine,
}

WEEKLY_TRIGGER_SKILLS_ROUTINES = {
    [SKILL_NONE] = NoneRoutine,
}

LEVELUP_TRIGGER_SKILLS_ROUTINES = {
    [SKILL_NONE] = NoneRoutine,
}

AFTER_COMBAT_TRIGGER_SKILLS_ROUTINES = {
    [SKILL_NONE] = NoneRoutine,
}



function DoSkillsRoutine_Start(player, hero)
    for k,v in START_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            startThread(v, player, hero)
        end
    end
end

function DoSkillsRoutine_Daily(player, hero)
    for k,v in DAILY_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            startThread(v, player, hero)
        end
    end
end

function DoSkillsRoutine_Weekly(player, hero)
    for k,v in WEEKLY_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            startThread(v, player, hero)
        end
    end
end

function DoSkillsRoutine_LevelUp(player, hero)
    for k,v in LEVELUP_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            startThread(v, player, hero)
        end
    end
end

function DoSkillsRoutine_AfterCombat(player, hero, index)
    for k,v in AFTER_COMBAT_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            startThread(v, player, hero, index)
        end
    end
end


-- print("Loaded skills advmap routines")
ROUTINES_LOADED[17] = 1
