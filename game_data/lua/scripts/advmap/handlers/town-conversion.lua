
MAP_CONVERTIBLES = {}
HERO_IN_CONVERTIBLE = {}

function HeroInConvertible(hero, obj, value)
    ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, value)
    HERO_IN_CONVERTIBLE[hero] = (value == 1) and obj or nil
end

function CanHeroConvert(hero, obj)
    if IsHeroHuman(hero) then
        if HasHeroSkill(hero, SKILL_GOVERNANCE) then
            if GetObjectOwner(obj) == GetObjectOwner(hero) then
                return HEROES[hero] ~= MAP_CONVERTIBLES[obj][0]
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
    local resource_cost = 20
    local gold_cost = 10000
    if     GetPlayerResource(player, WOOD) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughWood.txt", hero, player, 3)
    elseif GetPlayerResource(player, ORE) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughOre.txt", hero, player, 3)
    elseif GetPlayerResource(player, GOLD) < gold_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughGolds.txt", hero, player, 3)
    else
        TakePlayer_Resource(player, WOOD, resource_cost)
        TakePlayer_Resource(player, ORE, resource_cost)
        TakePlayer_Resource(player, GOLD, gold_cost)
        local faction = HEROES[hero]
        TransformTown(town, FactionToTownType(faction))
        MAP_CONVERTIBLES[town][0] = faction
    end
end

function ConvertDwelling(player, hero, dwelling, tier)
    local resource_cost = 3 * tier
    local gold_cost = 1000 * tier
    if     GetPlayerResource(player, WOOD) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughWood.txt", hero, player, 3)
    elseif GetPlayerResource(player, ORE) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughOre.txt", hero, player, 3)
    elseif GetPlayerResource(player, GOLD) < gold_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughGolds.txt", hero, player, 3)
    else
        TakePlayer_Resource(player, WOOD, resource_cost)
        TakePlayer_Resource(player, ORE, resource_cost)
        TakePlayer_Resource(player, GOLD, gold_cost)
        local faction = HEROES[hero]
        ReplaceDwelling(dwelling, FactionToTownType(faction))
        MAP_CONVERTIBLES[dwelling][0] = faction
    end
end

function HeroVisitConvertible(hero, obj)
    if CanHeroConvert(hero, obj) then
        HeroInConvertible(hero, obj, CUSTOM_ABILITY_ENABLED)
        local x,y,z = GetObjectPosition(hero)
        repeat sleep(10) until not IsEqualPosition(hero, x, y, z)
        HeroInConvertible(hero, obj, CUSTOM_ABILITY_DISABLED)
    else
        SetTriggerConvertible(obj, nil)
        MakeHeroInteractWithObject(hero, obj)
        SetTriggerConvertible(obj, not nil)
    end
end

function SetupMapObjectType(type, faction, tier)
    local names = GetObjectNamesByType(type)
    for _,name in names do
        MAP_CONVERTIBLES[name] = { [0]=faction, [1]=tier }
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


-- print("Loaded town-conversion.lua")
ROUTINES_LOADED[22] = 1