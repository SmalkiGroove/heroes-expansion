
function ManageSkillBonus_Offence(player, hero, mastery)
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 7 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_OFFENCE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_ATTACK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_OFFENCE] = value
    end
end

function ManageSkillBonus_Defense(player, hero, mastery)
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 7 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_DEFENSE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_DEFENCE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_DEFENSE] = value
    end
end

function ManageSkillBonus_Learning(player, hero, mastery)
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 7 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_LEARNING]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_LEARNING] = value
    end
end

function ManageSkillBonus_Sorcery(player, hero, mastery)
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 7 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_SORCERY]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_SORCERY] = value
    end
end

function ManageSkillBonus_Voice(player, hero, mastery)
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 7 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_VOICE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_VOICE] = value
    end
end

function ManageSkillBonus_Combat(player, hero, mastery)
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_COMBAT]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_ATTACK, diff)
        AddHero_StatAmount(player, hero, STAT_DEFENCE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_COMBAT] = value
    end
end

function ManageSkillBonus_Courage(player, hero, mastery)
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 7 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_COURAGE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_MORALE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_COURAGE] = value
    end
end

function ManageSkillBonus_Precision(player, hero, mastery)
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_PRECISION]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_LUCK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_PRECISION] = value
    end
end

function ManageSkillBonus_Intelligence(player, hero, mastery)
    local value = 5 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_INTELLIGENCE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_INTELLIGENCE] = value
    end
end

function ManageSkillBonus_Exaltation(player, hero, mastery)
    local value = 3 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_EXALTATION]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_EXALTATION] = value
    end
end

function ManageSkillBonus_ArcaneExcellence(player, hero, mastery)
    local value = 4 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_ARCANE_EXCELLENCE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_ARCANE_EXCELLENCE] = value
    end
end

function ManageSkillBonus_Graduate(player, hero, mastery)
    local value = 3 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_GRADUATE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_GRADUATE] = value
    end
end

function ManageSkillBonus_Occultism(player, hero, mastery)
    local value = 6 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_OCCULTISM]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_OCCULTISM] = value
    end
end

function ManageSkillBonus_SecretsOfDestruct(player, hero, mastery)
    local value = 5 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_SECRETS_OF_DESTRUCT]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_SECRETS_OF_DESTRUCT] = value
    end
end

function ManageSkillBonus_Motivation(player, hero, mastery)
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_MOTIVATION]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_MORALE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_MOTIVATION] = value
    end
end

function ManageSkillBonus_SheerStrength(player, hero, mastery)
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_SHEER_STRENGTH]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_ATTACK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_SHEER_STRENGTH] = value
    end
end

function Routine_Leadership(player, hero, mastery, combatIndex)
    print("$ Routine_Leadership")
    local x, y, z = GetObjectPosition(hero)
    local dx, dy, dz = GetObjectPosition(PLAYER_MAIN_TOWN[player])
    print("Hero at x="..x..", y="..y)
    local found = nil
    for i = -1,1 do for j = -1,1 do
        objects = GetObjectsFromPath(hero, x+i, y+j, z)
        if length(objects) == 0 then x=x+i; y=y+j; found = not nil; break end
    end if found then break end end
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
    CURRENT_CARAVANS[caravan] = 3
end

START_TRIGGER_SKILLS_ROUTINES = {
    [SKILL_OFFENCE] = ManageSkillBonus_Offence,
    [SKILL_DEFENSE] = ManageSkillBonus_Defense,
    [SKILL_LEARNING] = ManageSkillBonus_Learning,
    [SKILL_SORCERY] = ManageSkillBonus_Sorcery,
    [SKILL_VOICE] = ManageSkillBonus_Voice,
    [SKILL_COMBAT] = ManageSkillBonus_Combat,
    [SKILL_COURAGE] = ManageSkillBonus_Courage,
    [PERK_PRECISION] = ManageSkillBonus_Precision,
    [PERK_INTELLIGENCE] = ManageSkillBonus_Intelligence,
    [PERK_EXALTATION] = ManageSkillBonus_Exaltation,
    [PERK_ARCANE_EXCELLENCE] = ManageSkillBonus_ArcaneExcellence,
    [PERK_GRADUATE] = ManageSkillBonus_Graduate,
    [PERK_OCCULTISM] = ManageSkillBonus_Occultism,
    [PERK_SECRETS_OF_DESTRUCT] = ManageSkillBonus_SecretsOfDestruct,
    [PERK_MOTIVATION] = ManageSkillBonus_Motivation,
    [PERK_SHEER_STRENGTH] = ManageSkillBonus_SheerStrength,
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
    [SKILL_LEADERSHIP] = Routine_Leadership,
}


function DoSkillsRoutine_Start(player, hero)
    for k,v in START_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            local mastery = GetHeroSkillMastery(hero, k)
            startThread(v, player, hero, mastery)
        end
    end
end

function DoSkillsRoutine_Daily(player, hero)
    for k,v in DAILY_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            local mastery = GetHeroSkillMastery(hero, k)
            startThread(v, player, hero, mastery)
        end
    end
end

function DoSkillsRoutine_Weekly(player, hero)
    for k,v in WEEKLY_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            local mastery = GetHeroSkillMastery(hero, k)
            startThread(v, player, hero, mastery)
        end
    end
end

function DoSkillsRoutine_LevelUp(player, hero, level)
    for k,v in LEVELUP_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            local mastery = GetHeroSkillMastery(hero, k)
            startThread(v, player, hero, mastery, level)
        end
    end
end

function DoSkillsRoutine_AfterCombat(player, hero, index)
    for k,v in AFTER_COMBAT_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            local mastery = GetHeroSkillMastery(hero, k)
            startThread(v, player, hero, mastery, index)
        end
    end
end


-- print("Loaded skills advmap routines")
ROUTINES_LOADED[17] = 1
