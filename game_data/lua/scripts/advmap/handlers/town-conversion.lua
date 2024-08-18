
MAP_CONVERTIBLES = {}
HERO_IN_CONVERTIBLE = {}

function HeroInConvertible(hero, obj, value)
    -- log("$ HeroInConvertible")
    ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, value)
    HERO_IN_CONVERTIBLE[hero] = (value == 1) and obj or nil
end

function EnableTownConversionAbility(hero, obj)
    log("$ EnableTownConversionAbility")
    HeroInConvertible(hero, obj, CUSTOM_ABILITY_ENABLED)
    local x,y,z = GetObjectPosition(hero)
    repeat sleep(10) until not IsEqualPosition(hero, x, y, z)
    HeroInConvertible(hero, obj, CUSTOM_ABILITY_DISABLED)
    log("Hero moved - conversion ability disabled")
end

function CanHeroConvert(hero, obj)
    -- log("$ CanHeroConvert obj="..obj)
    if IsHeroHuman(hero) then
        if HasHeroSkill(hero, SKILL_GOVERNANCE) then
            if GetObjectOwner(obj) == GetObjectOwner(hero) then
                local fh = HEROES[hero].faction
                local fo = MAP_CONVERTIBLES[obj].faction
                return fh ~= fo
            end
        end
    end
    return nil
end

function SetTriggerConvertible(obj, bool)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, bool and "HeroVisitConvertible" or nil)
    SetObjectEnabled(obj, not bool)
end

function ConvertTown(player, hero, town)
    -- log("$ ConvertTown")
    local resource_cost = 20
    local gold_cost = 10000
    if     GetPlayerResource(player, WOOD) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughWood.txt", hero, player, 3)
    elseif GetPlayerResource(player, ORE) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughOre.txt", hero, player, 3)
    elseif GetPlayerResource(player, GOLD) < gold_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughGolds.txt", hero, player, 3)
    else
        RemovePlayerResource(player, WOOD, resource_cost)
        RemovePlayerResource(player, ORE, resource_cost)
        RemovePlayerResource(player, GOLD, gold_cost)
        local f = HEROES[hero].faction
        TransformTown(town, FactionToTownType(f))
        SetupTownTavern(town, f)
        MAP_CONVERTIBLES[town] = { faction=f, tier=0 }
    end
end

function ConvertDwelling(player, hero, dwelling, tier)
    -- log("$ ConvertDwelling")
    local resource_cost = 3 * tier
    local gold_cost = 1000 * tier
    if     GetPlayerResource(player, WOOD) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughWood.txt", hero, player, 3)
    elseif GetPlayerResource(player, ORE) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughOre.txt", hero, player, 3)
    elseif GetPlayerResource(player, GOLD) < gold_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughGolds.txt", hero, player, 3)
    else
        RemovePlayerResource(player, WOOD, resource_cost)
        RemovePlayerResource(player, ORE, resource_cost)
        RemovePlayerResource(player, GOLD, gold_cost)
        local f = HEROES[hero].faction
        ReplaceDwelling(dwelling, FactionToTownType(f))
        MAP_CONVERTIBLES[dwelling] = { faction=f, tier=tier }
    end
end

function HeroVisitConvertible(hero, obj)
    log("$ HeroVisitConvertible")
    if hero == H_THEODORUS then startThread(Routine_IncreaseKnowledgeTemp, hero, obj) end
    if HasHeroSkill(hero, SKILL_LOGISTICS) then startThread(Routine_LogisticsVisitTown, hero, obj) end
    if CanHeroConvert(hero, obj) then startThread(EnableTownConversionAbility, hero, obj) end
    SetTriggerConvertible(obj, nil)
    MakeHeroInteractWithObject(hero, obj)
    SetTriggerConvertible(obj, not nil)
end

function SetupMapObjectType(type, f, t)
    local names = GetObjectNamesByType(type)
    for _,name in names do
        MAP_CONVERTIBLES[name] = { faction=f, tier=t }
        SetTriggerConvertible(name, not nil)
    end
end

function InitializeConvertibles()
	for faction = 1,8 do
		SetupMapObjectType(Towns_Types[faction], faction, 0)
		SetupMapObjectType(Dwellings_T1[faction], faction, 1)
		SetupMapObjectType(Dwellings_T2[faction], faction, 2)
		SetupMapObjectType(Dwellings_T3[faction], faction, 3)
		SetupMapObjectType(Dwellings_MP[faction], faction, 5)
	end
end


-- log("Loaded town-conversion.lua")
ROUTINES_LOADED[22] = 1
