
HERO_SKILL_BONUSES = {}

for hero,_ in HEROES do
    HERO_SKILL_BONUSES[hero] = {}
    for skb = 1,_skillbonus_id do
        HERO_SKILL_BONUSES[hero][skb] = 0
    end
end

NB_CARAVAN = 0
CURRENT_CARAVANS = {}

function CaravanCountdown()
    log("$ CaravanCountdown")
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


function CheckForUltimate(player, hero, level)
    -- log("$ CheckForUltimate")
    if HasHeroSkill(hero, SKILL_ULTIMATE) then return end
    if level >= 25 then
        local nb = 0
        for _,skill in SKILLS_BY_FACTION do
            if HasHeroSkill(hero, skill.ult) then return end
            if GetHeroSkillMastery(hero, skill.base) >= 3 then
                nb = nb + 1
            end
        end
        for _,skill in SKILLS_COMMON do
            if HasHeroSkill(hero, skill) then
                nb = nb + 1
            end
        end
        if nb == 7 then
            GiveHeroSkill(hero, SKILL_ULTIMATE) sleep()
            GiveHeroSkill(hero, SKILL_ULTIMATE) sleep()
            GiveHeroSkill(hero, SKILL_ULTIMATE) sleep()
            ShowFlyingSign("/Text/Game/Scripts/Ultimate.txt", hero, player, FLYING_SIGN_TIME)
        end
    end
end


ABSOLUTE_MASTERIES = {H_ISABEL=0, H_TALANAR=0, H_EBBA=0, H_THEODORUS=0, H_SINITAR=0, H_RAVEN=0, H_NYMUS=0, H_TELSEK=0}

function AddHeroSkill(hero, skill, mastery)
    log("Hero "..hero.." has learnt skill '"..skill.."' rank "..mastery..".")
    local player = GetObjectOwner(hero)
    local level = GetHeroLevel(hero)
    if START_TRIGGER_SKILLS_ROUTINES[skill] then
        START_TRIGGER_SKILLS_ROUTINES[skill](player, hero, mastery, level)
    end
    if ABSOLUTE_MASTERIES[hero] then
        if ABSOLUTE_MASTERIES[hero] == 0 then
            local f = HEROES[hero].faction
            local n = 0
            n = n + GetHeroSkillMastery(hero, SKILLS_BY_FACTION[f].base)
            for _,sk in SKILLS_BY_FACTION[f].perks do n = n + GetHeroSkillMastery(hero, sk) end
            if n == 6 then
                GiveHeroSkill(hero, SKILLS_BY_FACTION[f].base)
                ABSOLUTE_MASTERIES[hero] = 1
            end
        end
    end
    Register(VarHeroSkillId(hero, skill), mastery)
    CheckForUltimate(player, hero, level)
end
function RemoveHeroSkill(hero, skill, mastery)
    log("Hero "..hero.." has removed skill '"..skill.."' rank "..mastery..".")
    local player = GetObjectOwner(hero)
    local level = GetHeroLevel(hero)
    if START_TRIGGER_SKILLS_ROUTINES[skill] then
        START_TRIGGER_SKILLS_ROUTINES[skill](player, hero, mastery, level)
    end
    Register(VarHeroSkillId(hero, skill), mastery)
end

function BindHeroSkillTrigger(hero)
    Trigger(HERO_ADD_SKILL_TRIGGER, hero, "AddHeroSkill")
    Trigger(HERO_REMOVE_SKILL_TRIGGER, hero, "RemoveHeroSkill")
end
function UnbindHeroSkillTrigger(hero)
    Trigger(HERO_ADD_SKILL_TRIGGER, hero, nil)
    Trigger(HERO_REMOVE_SKILL_TRIGGER, hero, nil)
end


-- log("Loaded skills-manager.lua")
ROUTINES_LOADED[16] = 1
