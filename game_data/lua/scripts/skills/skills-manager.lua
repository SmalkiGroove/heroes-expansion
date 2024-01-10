
NB_CARAVAN = 0
CURRENT_CARAVANS = {}

function CaravanCountdown()
    print("$ CaravanCountdown")
    local caravans = {}
    for k,v in CURRENT_CARAVANS do
        if v > 0 then caravans[k] = v-1
        elseif IsObjectExists(k) then RemoveObject(k)
        end
    end
    CURRENT_CARAVANS = caravans
end

HERO_SKILL_BONUSES = {}

for hero,_ in HEROES do
    HERO_SKILL_BONUSES[hero] = {
        [SKILLBONUS_OFFENCE] = 0,
        [SKILLBONUS_DEFENSE] = 0,
        [SKILLBONUS_LEARNING] = 0,
        [SKILLBONUS_SORCERY] = 0,
        [SKILLBONUS_VOICE] = 0,
        [SKILLBONUS_COURAGE] = 0,
        [SKILLBONUS_PRECISION] = 0,
        [SKILLBONUS_INTELLIGENCE] = 0,
        [SKILLBONUS_EXALTATION] = 0,
        [SKILLBONUS_ARCANE_EXCELLENCE] = 0,
        [SKILLBONUS_GRADUATE] = 0,
        [SKILLBONUS_OCCULTISM] = 0,
        [SKILLBONUS_SECRETS_OF_DESTRUCT] = 0,
        [SKILLBONUS_MOTIVATION] = 0,
        [SKILLBONUS_SHEER_STRENGTH] = 0,
    }
end

function StatPerLevelDivisor(level, base, divisor)
    local value = base
    local div = divisor
    for i = 1,level do
        if i == div then
            value = value + 1
            div = div + divisor
        end
    end
    return value
end

function ManageSkillBonus_Offence(player, hero, mastery)
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 7 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_OFFENCE]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_ATTACK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_OFFENCE] = value
    end
end

function ManageSkillBonus_Defense(player, hero, mastery)
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 7 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_DEFENSE]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_DEFENCE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_DEFENSE] = value
    end
end

function ManageSkillBonus_Learning(player, hero, mastery)
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 7 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_LEARNING]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_LEARNING] = value
    end
end

function ManageSkillBonus_Sorcery(player, hero, mastery)
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 7 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_SORCERY]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_SORCERY] = value
    end
end

function ManageSkillBonus_Voice(player, hero, mastery)
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 7 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_VOICE]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_VOICE] = value
    end
end

function ManageSkillBonus_Courage(player, hero, mastery)
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 7 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_COURAGE]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_MORALE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_COURAGE] = value
    end
end

function ManageSkillBonus_Precision(player, hero, mastery)
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_PRECISION]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_LUCK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_PRECISION] = value
    end
end

function ManageSkillBonus_Intelligence(player, hero, mastery)
    local value = 5 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_INTELLIGENCE]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_INTELLIGENCE] = value
    end
end

function ManageSkillBonus_Exaltation(player, hero, mastery)
    local value = 3 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_EXALTATION]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_EXALTATION] = value
    end
end

function ManageSkillBonus_ArcaneExcellence(player, hero, mastery)
    local value = 4 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_ARCANE_EXCELLENCE]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_ARCANE_EXCELLENCE] = value
    end
end

function ManageSkillBonus_Graduate(player, hero, mastery)
    local value = 3 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_GRADUATE]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_GRADUATE] = value
    end
end

function ManageSkillBonus_Occultism(player, hero, mastery)
    local value = 6 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_OCCULTISM]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_OCCULTISM] = value
    end
end

function ManageSkillBonus_SecretsOfDestruct(player, hero, mastery)
    local value = 5 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_SECRETS_OF_DESTRUCT]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_SECRETS_OF_DESTRUCT] = value
    end
end

function ManageSkillBonus_Motivation(player, hero, mastery)
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_MOTIVATION]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_MORALE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_MOTIVATION] = value
    end
end

function ManageSkillBonus_SheerStrength(player, hero, mastery)
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_SHEER_STRENGTH]
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_ATTACK, diff)
        ChangeHeroStat(hero, STAT_DEFENCE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_SHEER_STRENGTH] = value
    end
end


HERO_SKILLS_TRIGGERS = {
    [SKILLBONUS_OFFENCE] = ManageSkillBonus_Offence,
    [SKILLBONUS_DEFENSE] = ManageSkillBonus_Defense,
    [SKILLBONUS_LEARNING] = ManageSkillBonus_Learning,
    [SKILLBONUS_SORCERY] = ManageSkillBonus_Sorcery,
    [SKILLBONUS_VOICE] = ManageSkillBonus_Voice,
    [SKILLBONUS_COURAGE] = ManageSkillBonus_Courage,
    [SKILLBONUS_PRECISION] = ManageSkillBonus_Precision,
    [SKILLBONUS_INTELLIGENCE] = ManageSkillBonus_Intelligence,
    [SKILLBONUS_EXALTATION] = ManageSkillBonus_Exaltation,
    [SKILLBONUS_ARCANE_EXCELLENCE] = ManageSkillBonus_ArcaneExcellence,
    [SKILLBONUS_GRADUATE] = ManageSkillBonus_Graduate,
    [SKILLBONUS_OCCULTISM] = ManageSkillBonus_Occultism,
    [SKILLBONUS_SECRETS_OF_DESTRUCT] = ManageSkillBonus_SecretsOfDestruct,
    [SKILLBONUS_MOTIVATION] = ManageSkillBonus_Motivation,
    [SKILLBONUS_SHEER_STRENGTH] = ManageSkillBonus_SheerStrength,
}


function AddHeroSkill(hero, skill, mastery)
    print("Hero "..hero.." has learnt skill '"..skill.."' at level "..mastery..".")
end
function RemoveHeroSkill(hero, skill, mastery)
    print("Hero "..hero.." has removed skill '"..skill.."' at level "..mastery..".")
end

function BindHeroSkillTrigger(hero)
    Trigger(HERO_ADD_SKILL_TRIGGER, hero, "AddHeroSkill")
    Trigger(HERO_REMOVE_SKILL_TRIGGER, hero, "RemoveHeroSkill")
end
function UnbindHeroSkillTrigger(hero)
    Trigger(HERO_ADD_SKILL_TRIGGER, hero, nil)
    Trigger(HERO_REMOVE_SKILL_TRIGGER, hero, nil)
end


-- print("Loaded skills management script")
ROUTINES_LOADED[16] = 1
