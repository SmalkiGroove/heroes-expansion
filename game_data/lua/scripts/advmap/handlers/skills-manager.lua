
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
    if level > 30 then
        local nb = 0
        for i,skill in SKILLS_BY_FACTION do
            if GetHeroSkillMastery(hero, skill) >= 3 then
                nb = nb + 1
            end
        end
        for i,skill in SKILLS_COMMON do
            if GetHeroSkillMastery(hero, skill) >= 1 then
                nb = nb + 1
            end
        end
        if nb == 7 then
            GiveHeroSkill(hero, SKILL_ULTIMATE)
            GiveHeroSkill(hero, SKILL_ULTIMATE)
            GiveHeroSkill(hero, SKILL_ULTIMATE)
            ShowFlyingSign("/Text/Game/Scripts/Ultimate.txt", hero, player, FLYING_SIGN_TIME)
        end
    end
end



function AddHeroSkill(hero, skill, mastery)
    log("Hero "..hero.." has learnt skill '"..skill.."' rank "..mastery..".")
    local player = GetObjectOwner(hero)
    local level = GetHeroLevel(hero)
    if START_TRIGGER_SKILLS_ROUTINES[skill] then
        START_TRIGGER_SKILLS_ROUTINES[skill](player, hero, mastery, level)
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
