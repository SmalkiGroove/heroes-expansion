
Towns_Types = {"TOWN_HEAVEN","TOWN_PRESERVE","TOWN_INFERNO","TOWN_NECROMANCY","TOWN_ACADEMY","TOWN_DUNGEON","TOWN_FORTRESS","TOWN_STRONGHOLD"}
Dwellings_T1 = {"BUILDING_PEASANT_HUT","BUILDING_FAIRIE_TREE","BUILDING_IMP_CRUCIBLE","BUILDING_GRAVEYARD","BUILDING_WORKSHOP","BUILDING_BATTLE_ACADEMY","BUILDING_FORTRESS_DEFENDERS","BUILDING_STRONGHOLD_GOBLINS"}
Dwellings_T2 = {"BUILDING_ARCHERS_HOUSE","BUILDING_WOOD_GUARD_QUARTERS","BUILDING_DEMON_GATE","BUILDING_FORGOTTEN_CRYPT","BUILDING_STONE_PARAPET","BUILDING_SHADOW_STONE","BUILDING_FORTRESS_AXEMEN","BUILDING_STRONGHOLD_CENTAURS"}
Dwellings_T3 = {"BUILDING_BARRACKS","BUILDING_HIGH_CABINS","BUILDING_KENNELS","BUILDING_RUINED_TOWER","BUILDING_GOLEM_FORGE","BUILDING_MAZE","BUILDING_FORTRESS_BEAR_RIDERS","BUILDING_STRONGHOLD_WARRIORS"}
Dwellings_MP = {"BUILDING_HEAVEN_MILITARY_POST","BUILDING_PRESERVE_MILITARY_POST","BUILDING_INFERNO_MILITARY_POST","BUILDING_NECROPOLIS_MILITARY_POST","BUILDING_ACADEMY_MILITARY_POST","BUILDING_DUNGEON_MILITARY_POST","BUILDING_FORTRESS_MILITARY_POST","BUILDING_STRONGHOLD_MILITARY_POST"}

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
                return GetHeroFactionID(hero) ~= MAP_CONVERTIBLES[obj][0]
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
        local faction = GetHeroFactionID(hero)
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
        local faction = GetHeroFactionID(hero)
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


-- print("Loaded conversion advmap routines")
ROUTINES_LOADED[20] = 1
