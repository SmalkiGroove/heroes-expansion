
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
    if not IsObjectExists(object) then return end
    Trigger(OBJECT_TOUCH_TRIGGER, obj, bool and "HeroVisitCombatObject" or nil)
    SetObjectEnabled(obj, not bool)
end

function HackHeroMana(hero)
    local temp = 1000000000 + GetHeroLevel(hero) * 10000000 + HERO_ACTIVE_ARTIFACT_SETS[hero][1] * 100000 + HERO_ACTIVE_ARTIFACT_SETS[hero][2] * 1000
    ChangeHeroStat(hero, STAT_KNOWLEDGE, 200000000)
    repeat sleep(1) until GetHeroStat(hero, STAT_KNOWLEDGE) > 200000000
    ChangeHeroStat(hero, STAT_MANA_POINTS, temp)
    repeat sleep(1) until GetHeroStat(hero, STAT_MANA_POINTS) > 1000
    ChangeHeroStat(hero, STAT_KNOWLEDGE, -200000000)
    repeat sleep(1) until GetHeroStat(hero, STAT_KNOWLEDGE) < 200000000
end

function RestoreHeroMana(hero)
    local player = GetObjectOwner(hero)
    if PLAYER_BRAIN[player] == HUMAN then sleep(20) end
    if GetHeroStat(hero, STAT_MANA_POINTS) > 1000 then
        local temp = 1000000000 + GetHeroLevel(hero) * 10000000 + HERO_ACTIVE_ARTIFACT_SETS[hero][1] * 100000 + HERO_ACTIVE_ARTIFACT_SETS[hero][2] * 1000
        ChangeHeroStat(hero, STAT_MANA_POINTS, -temp)
    end
end

function EngageCombat(hero, object)
    SetTriggerCombat(obj, nil)
    MakeHeroInteractWithObject(hero, object)
    SetTriggerCombat(obj, not nil)
    startThread(RestoreHeroMana, hero)
end

function HeroVisitCombatObject(hero, object)
    if IsHeroHuman(hero) then
        local player = GetObjectOwner(hero)
        local owner = GetObjectOwner(object)
        if owner and owner == player then
            MakeHeroInteractWithObject(hero, object)
        else
            startThread(HackHeroMana, hero)
            QuestionBoxForPlayers(GetPlayerFilter(player), "/Text/Game/Scripts/CombatTrigger.txt", "EngageCombat('"..hero.."','"..obj.."')", "NoneRoutine")
        end
    else
        EngageCombat(hero, object)
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
