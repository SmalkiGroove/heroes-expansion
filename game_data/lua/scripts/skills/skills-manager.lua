
HERO_SKILL_BONUSES = {}

for hero,_ in HEROES do
    HERO_SKILL_BONUSES[hero] = {
        [SKILLBONUS_OFFENCE] = 0,
        [SKILLBONUS_DEFENSE] = 0,
        [SKILLBONUS_LEARNING] = 0,
        [SKILLBONUS_SORCERY] = 0,
        [SKILLBONUS_VOICE] = 0,
        [SKILLBONUS_COMBAT] = 0,
        [SKILLBONUS_COURAGE] = 0,
        [SKILLBONUS_AVENGER] = 0,
        [SKILLBONUS_SPIRITISM] = 0,
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



START_TRIGGER_SKILLS_ROUTINES = {}

function AddHeroSkill(hero, skill, mastery)
    print("Hero "..hero.." has learnt skill '"..skill.."' at level "..mastery..".")
    if START_TRIGGER_SKILLS_ROUTINES[skill] then
        startThread(START_TRIGGER_SKILLS_ROUTINES[skill], player, hero, mastery)
    end
end
function RemoveHeroSkill(hero, skill, mastery)
    print("Hero "..hero.." has removed skill '"..skill.."' at level "..mastery..".")
    if START_TRIGGER_SKILLS_ROUTINES[skill] then
        startThread(START_TRIGGER_SKILLS_ROUTINES[skill], player, hero, mastery)
    end
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
