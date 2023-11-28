
Dwellings_T1 = {"BUILDING_PEASANT_HUT","BUILDING_FAIRIE_TREE","BUILDING_IMP_CRUCIBLE","BUILDING_GRAVEYARD","BUILDING_WORKSHOP","BUILDING_BATTLE_ACADEMY","BUILDING_FORTRESS_DEFENDERS","BUILDING_STRONGHOLD_GOBLINS"}
Dwellings_T2 = {"BUILDING_ARCHERS_HOUSE","BUILDING_WOOD_GUARD_QUARTERS","BUILDING_DEMON_GATE","BUILDING_FORGOTTEN_CRYPT","BUILDING_STONE_PARAPET","BUILDING_SHADOW_STONE","BUILDING_FORTRESS_AXEMEN","BUILDING_STRONGHOLD_CENTAURS"}
Dwellings_T3 = {"BUILDING_BARRACKS","BUILDING_HIGH_CABINS","BUILDING_KENNELS","BUILDING_RUINED_TOWER","BUILDING_GOLEM_FORGE","BUILDING_MAZE","BUILDING_FORTRESS_BEAR_RIDERS","BUILDING_STRONGHOLD_WARRIORS"}
Dwellings_MP = {"BUILDING_HEAVEN_MILITARY_POST","BUILDING_PRESERVE_MILITARY_POST","BUILDING_INFERNO_MILITARY_POST","BUILDING_NECROPOLIS_MILITARY_POST","BUILDING_ACADEMY_MILITARY_POST","BUILDING_DUNGEON_MILITARY_POST","BUILDING_FORTRESS_MILITARY_POST","BUILDING_STRONGHOLD_MILITARY_POST"}
Towns_Types = {"TOWN_HEAVEN","TOWN_PRESERVE","TOWN_INFERNO","TOWN_NECROMANCY","TOWN_ACADEMY","TOWN_DUNGEON","TOWN_FORTRESS","TOWN_STRONGHOLD"}


function GetBuildingRace(tier_table, building)
    local race = 0
    for i = 1,8 do
		if contains(GetObjectNamesByType(tier_table[i]), building) then race = i end
	end
    return race
end

function ConvertDwelling(hero, dwelling, tier)
    local player = GetObjectOwner(hero)
    local race = GetHeroFactionID(hero)

    local resource_cost = 0; local gold_cost = 0
    if     tier == 'T1' then resource_cost = 3; gold_cost = 1000
    elseif tier == 'T2' then resource_cost = 6; gold_cost = 2000
    elseif tier == 'T3' then resource_cost = 9; gold_cost = 3000
    elseif tier == 'MP' then resource_cost = 15; gold_cost = 5000
    end

    if     GetPlayerResource(player, WOOD) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughWood.txt", hero, player, 3)
    elseif GetPlayerResource(player, ORE) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughOre.txt", hero, player, 3)
    elseif GetPlayerResource(player, GOLD) < gold_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughGolds.txt", hero, player, 3)
    else
        TakePlayer_Resource(player, WOOD, resource_cost)
        TakePlayer_Resource(player, ORE, resource_cost)
        TakePlayer_Resource(player, GOLD, gold_cost)
        local x,y,z = GetObjectPosition(dwelling)
        ReplaceDwelling(dwelling, FactionToTownType(race))
        Trigger(OBJECT_TOUCH_TRIGGER, dwelling, nil)
        SetObjectEnabled(dwelling, not nil)
        MakeHeroInteractWithObject(hero, dwelling)
    end
end

function ConvertTown(hero, town)
    local player = GetObjectOwner(hero)
    local race = GetHeroFactionID(hero)

    local resource_cost = 20; local gold_cost = 10000
    if     GetPlayerResource(player, WOOD) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughWood.txt", hero, player, 3)
    elseif GetPlayerResource(player, ORE) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughOre.txt", hero, player, 3)
    elseif GetPlayerResource(player, GOLD) < gold_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughGolds.txt", hero, player, 3)
    else
        TakePlayer_Resource(player, WOOD, resource_cost)
        TakePlayer_Resource(player, ORE, resource_cost)
        TakePlayer_Resource(player, GOLD, gold_cost)
        local x,y,z = GetObjectPosition(town)
        TransformTown(town, FactionToTownType(race))
        Trigger(OBJECT_TOUCH_TRIGGER, town, nil)
        SetObjectEnabled(town, not nil)
        MakeHeroInteractWithObject(hero, town)
    end
end

function JustVisitBuilding(hero, building, event)
    Trigger(OBJECT_TOUCH_TRIGGER, building, nil)
    SetObjectEnabled(building, not nil)
    MakeHeroInteractWithObject(hero, building)
    Trigger(OBJECT_TOUCH_TRIGGER, building, event)
    SetObjectEnabled(building, nil)
end


--------------------------------------------------------------------------------------------------------------------------------------------------------

function HeroVisitDwellingT1(hero, dwelling)
    if IsHeroHuman(hero) and GetObjectOwner(dwelling) == GetObjectOwner(hero) and GetBuildingRace(Dwellings_T1, dwelling) ~= GetHeroFactionID(hero) then
        QuestionBoxForPlayers(
            GetPlayerFilter(GetObjectOwner(hero)),
            {"/Text/Game/Scripts/DwellingConversion.txt"; wood=3,ore=3,gold=1000},
            "ConvertDwelling('"..hero.."','"..dwelling.."','T1')",
            "JustVisitBuilding('"..hero.."','"..dwelling.."','HeroVisitDwellingT1')"
        )
    else
        JustVisitBuilding(hero, dwelling, 'HeroVisitDwellingT1')
    end
end

function HeroVisitDwellingT2(hero, dwelling)
    if IsHeroHuman(hero) and GetObjectOwner(dwelling) == GetObjectOwner(hero) and GetBuildingRace(Dwellings_T2, dwelling) ~= GetHeroFactionID(hero) then
        QuestionBoxForPlayers(
            GetPlayerFilter(GetObjectOwner(hero)),
            {"/Text/Game/Scripts/DwellingConversion.txt"; wood=6,ore=6,gold=2000},
            "ConvertDwelling('"..hero.."','"..dwelling.."','T2')",
            "JustVisitBuilding('"..hero.."','"..dwelling.."','HeroVisitDwellingT2')"
        )
    else
        JustVisitBuilding(hero, dwelling, 'HeroVisitDwellingT2')
    end
end

function HeroVisitDwellingT3(hero, dwelling)
    if IsHeroHuman(hero) and GetObjectOwner(dwelling) == GetObjectOwner(hero) and GetBuildingRace(Dwellings_T3, dwelling) ~= GetHeroFactionID(hero) then
        QuestionBoxForPlayers(
            GetPlayerFilter(GetObjectOwner(hero)),
            {"/Text/Game/Scripts/DwellingConversion.txt"; wood=9,ore=9,gold=3000},
            "ConvertDwelling('"..hero.."','"..dwelling.."','T3')",
            "JustVisitBuilding('"..hero.."','"..dwelling.."','HeroVisitDwellingT3')"
        )
    else
        JustVisitBuilding(hero, dwelling, 'HeroVisitDwellingT3')
    end
end

function HeroVisitDwellingMP(hero, dwelling)
    if IsHeroHuman(hero) and GetObjectOwner(dwelling) == GetObjectOwner(hero) and GetBuildingRace(Dwellings_MP, dwelling) ~= GetHeroFactionID(hero) then
        QuestionBoxForPlayers(
            GetPlayerFilter(GetObjectOwner(hero)),
            {"/Text/Game/Scripts/DwellingConversion.txt"; wood=15,ore=15,gold=5000},
            "ConvertDwelling('"..hero.."','"..dwelling.."','MP')",
            "JustVisitBuilding('"..hero.."','"..dwelling.."','HeroVisitDwellingMP')"
        )
    else
        JustVisitBuilding(hero, dwelling, 'HeroVisitDwellingMP')
    end
end

function HeroVisitTown(hero, town)
    if IsHeroHuman(hero) and GetObjectOwner(town) == GetObjectOwner(hero) and GetBuildingRace(Towns_Types, town) ~= GetHeroFactionID(hero) then
        QuestionBoxForPlayers(
            GetPlayerFilter(GetObjectOwner(hero)),
            {"/Text/Game/Scripts/TownConversion.txt"; wood=20,ore=20,gold=10000},
            "ConvertTown('"..hero.."','"..town.."')",
            "JustVisitBuilding('"..hero.."','"..town.."','HeroVisitTown')"
        )
    else
        JustVisitBuilding(hero, town, 'HeroVisitTown')
    end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------

function TriggerOnMapObjectType(object_type, trigger_type, handler)
    local names = GetObjectNamesByType(object_type)
    for i,name in names do
        Trigger(trigger_type, name, handler)
        SetObjectEnabled(name, nil)
    end
end


function EnableBuildingConversion()
	for i = 1,8 do
		TriggerOnMapObjectType(Dwellings_T1[i], OBJECT_TOUCH_TRIGGER, "HeroVisitDwellingT1")
		TriggerOnMapObjectType(Dwellings_T2[i], OBJECT_TOUCH_TRIGGER, "HeroVisitDwellingT2")
		TriggerOnMapObjectType(Dwellings_T3[i], OBJECT_TOUCH_TRIGGER, "HeroVisitDwellingT3")
		TriggerOnMapObjectType(Dwellings_MP[i], OBJECT_TOUCH_TRIGGER, "HeroVisitDwellingMP")
		TriggerOnMapObjectType(Towns_Types[i], OBJECT_TOUCH_TRIGGER, "HeroVisitTown")
	end
end


-- print("Loaded conversion advmap routines")
ROUTINES_LOADED[x_conversion] = 1
