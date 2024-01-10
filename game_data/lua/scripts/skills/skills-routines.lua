
function Routine_Leadership(player, hero, combatIndex)
    local mastery = GetHeroSkillMastery(hero, SKILL_LEADERSHIP)
    local x, y, z = GetObjectPosition(hero)
    local dx, dy, dz = GetObjectPosition(PLAYER_MAIN_TOWN[player])
    print("Hero at x="..x..", y="..y)
    local found = nil
    for i = -1,1 do for j = -1,1 do
        objects = GetObjectsFromPath(hero, x+i, y+j, z)
        if length(objects) == 0 then x=x+i; y=y+j; found = not nil; break end
    end end
    if found then print("Spawn caravan at x="..x..", y="..y) else print("No available tile around hero was found"); return end
    local caravan = "Caravan-"..NB_CARAVAN
    NB_CARAVAN = NB_CARAVAN + 1
    CreateCaravan(caravan, player, z, x, y, z, x, y)
    repeat sleep(1) until IsObjectExists(caravan)
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 0)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 0, i)
        local amount = trunc(died * (0.05 + 0.05 * mastery))
        AddObjectCreatures(caravan, creature, amount)
    end
    sleep(1)
    MakeHeroInteractWithObject(hero, caravan)
end

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
    [SKILL_LEADERSHIP] = Routine_Leadership,
}


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
