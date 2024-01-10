
COMBAT_TRIGGERING_OBJECTS = {
    "CREATURE",
    "BUILDING_CRYPT",
    "BUILDING_GARGOYLE_STONEVAULT",
    "BUILDING_DWARVEN_TREASURE",
    "BUILDING_BLOOD_TEMPLE",
    "BUILDING_NAGA_BANK",
    "BUILDING_NAGA_TEMPLE",
    "BUILDING_TREANT_THICKET",
    "BUILDING_UNKEMPT",
    "BUILDING_LEAN_TO",
    "BUILDING_SUNKEN_TEMPLE",
    "BUILDING_PYRAMID",
    "BUILDING_DEMOLISH",
    "BUILDING_BUOY",
    "BUILDING_CYCLOPS_STOCKPILE",
    "BUILDING_ABANDONED_MINE",
    "BUILDING_DRAGON_UTOPIA",
}

function SetTriggerCombat(obj, bool)
    if not IsObjectExists(obj) then return end
    Trigger(OBJECT_TOUCH_TRIGGER, obj, bool and "HeroVisitCombatObject" or nil)
    SetObjectEnabled(obj, not bool)
end

function HackHeroMana(hero)
    local temp = 1000000000 + GetHeroLevel(hero) * 10000000 + HERO_ACTIVE_ARTIFACT_SETS[hero][1] * 100000 + HERO_ACTIVE_ARTIFACT_SETS[hero][2] * 1000
    ChangeHeroStat(hero, STAT_KNOWLEDGE, 200000000)
    repeat sleep(1) until GetHeroStat(hero, STAT_KNOWLEDGE) > 200000000
    ChangeHeroStat(hero, STAT_MANA_POINTS, temp)
    repeat sleep(1) until GetHeroStat(hero, STAT_MANA_POINTS) > 1000000000
    ChangeHeroStat(hero, STAT_KNOWLEDGE, -200000000)
end

function RestoreHeroMana(hero)
    if GetHeroStat(hero, STAT_MANA_POINTS) > 1000 then
        local temp = 1000000000 + GetHeroLevel(hero) * 10000000 + HERO_ACTIVE_ARTIFACT_SETS[hero][1] * 100000 + HERO_ACTIVE_ARTIFACT_SETS[hero][2] * 1000
        ChangeHeroStat(hero, STAT_MANA_POINTS, -temp)
    end
end

function WaitForRestoreMana(hero)
    local x,y,z = GetObjectPosition(hero)
    repeat sleep(5) until not IsEqualPosition(hero, x, y, z)
    RestoreHeroMana(hero)
end

function EngageCombat(hero, obj)
    while (GetHeroStat(hero, STAT_KNOWLEDGE) > 200000000 or GetHeroStat(hero, STAT_MANA_POINTS) < 1000000000) do sleep(1) end
    EngageInteraction(hero, obj)
    WaitForRestoreMana(hero)
end

function EngageInteraction(hero, obj)
    if IsObjectExists(obj) then
        SetTriggerCombat(obj, nil)
        MakeHeroInteractWithObject(hero, obj)
        SetTriggerCombat(obj, not nil)
    end
end

function HeroVisitCombatObject(hero, obj)
    if IsHeroHuman(hero) then
        local player = GetObjectOwner(hero)
        local owner = GetObjectOwner(obj)
        if owner and owner == player then
            EngageInteraction(hero, obj)
        else
            startThread(HackHeroMana, hero)
            QuestionBoxForPlayers(GetPlayerFilter(player), "/Text/Game/Scripts/CombatTrigger.txt", "EngageCombat('"..hero.."','"..obj.."')", "RestoreHeroMana('"..hero.."')")
        end
    else
        EngageInteraction(hero, obj)
    end
end

function InitializeCombatHook()
    for _,type in COMBAT_TRIGGERING_OBJECTS do
        for _,obj in GetObjectNamesByType(type) do
            SetTriggerCombat(obj, not nil)
        end
    end
end


-- print("Loaded monster advmap routines")
ROUTINES_LOADED[21] = 1
