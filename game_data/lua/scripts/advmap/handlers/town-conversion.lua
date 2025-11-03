
MAP_CONVERTIBLES = {}
HERO_IN_CONVERTIBLE = {}

function HeroInConvertible(hero, obj, value)
    ControlHeroCustomAbility(hero, CUSTOM_ABILITY_4, value)
    HERO_IN_CONVERTIBLE[hero] = (value == 1) and obj or nil
end

function EnableTownConversionAbility(hero, obj)
    log(DEBUG, "$ EnableTownConversionAbility")
    HeroInConvertible(hero, obj, CUSTOM_ABILITY_ENABLED)
    local x,y,z = GetObjectPosition(hero)
    repeat sleep(10) until not IsEqualPosition(hero, x, y, z)
    HeroInConvertible(hero, obj, CUSTOM_ABILITY_DISABLED)
    log(DEBUG, "Hero moved - conversion ability disabled")
end

function CanHeroConvert(hero, obj)
    local player = GetObjectOwner(hero)
    if IsHumanPlayer(player) then
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
    log(DEBUG, "$ ConvertTown")
    local resource_cost = 20
    local gold_cost = 10000
    if     GetPlayerResource(player, WOOD) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughWood.txt", hero, player, 3)
    elseif GetPlayerResource(player, ORE) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughOre.txt", hero, player, 3)
    elseif GetPlayerResource(player, GOLD) < gold_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughGolds.txt", hero, player, 3)
    else
        TakeAwayResources(player, WOOD, resource_cost)
        TakeAwayResources(player, ORE, resource_cost)
        TakeAwayResources(player, GOLD, gold_cost)
        local f = HEROES[hero].faction
        TransformTown(town, FactionToTownType(f))
        SetupTownTavern(town, f)
        MAP_CONVERTIBLES[town] = { faction=f, tier=0 }
    end
end

function ConvertDwelling(player, hero, dwelling, tier)
    log(DEBUG, "$ ConvertDwelling")
    local resource_cost = 3 * tier
    local gold_cost = 1000 * tier
    if     GetPlayerResource(player, WOOD) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughWood.txt", hero, player, 3)
    elseif GetPlayerResource(player, ORE) < resource_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughOre.txt", hero, player, 3)
    elseif GetPlayerResource(player, GOLD) < gold_cost then ShowFlyingSign("/Text/Game/Scripts/Resources/xNotEnoughGolds.txt", hero, player, 3)
    else
        TakeAwayResources(player, WOOD, resource_cost)
        TakeAwayResources(player, ORE, resource_cost)
        TakeAwayResources(player, GOLD, gold_cost)
        local f = HEROES[hero].faction
        ReplaceDwelling(dwelling, FactionToTownType(f))
        MAP_CONVERTIBLES[dwelling] = { faction=f, tier=tier }
    end
end

function HeroVisitConvertible(hero, obj)
    log(DEBUG, "$ HeroVisitConvertible")
    if hero == H_DOUGAL then
        startThread(Routine_TrainPeasantsToArchers, hero, obj)
        repeat sleep() until Var_Dougal_TrainPeasantLock == 0
    end
    if hero == H_THEODORUS then
        startThread(Routine_IncreaseKnowledgeTemp, hero, obj)
    end
    if HasHeroSkill(hero, SKILL_LOGISTICS) then
        startThread(Routine_LogisticsVisitTown, hero, obj)
    end
    if CanHeroConvert(hero, obj) then startThread(EnableTownConversionAbility, hero, obj) end
    SetTriggerConvertible(obj, nil)
    MakeHeroInteractWithObject(hero, obj)
    SetTriggerConvertible(obj, not nil)
end

function SetupConvertibleTrigger(type, f, t)
    local names = GetObjectNamesByType(type)
    for _,name in names do
        MAP_CONVERTIBLES[name] = { faction=f, tier=t }
        SetTriggerConvertible(name, not nil)
    end
end

function InitializeConvertibles()
	for faction = 1,8 do
		SetupConvertibleTrigger(Towns_Types[faction], faction, 0)
		SetupConvertibleTrigger(Dwellings_T1[faction], faction, 1)
		SetupConvertibleTrigger(Dwellings_T2[faction], faction, 2)
		SetupConvertibleTrigger(Dwellings_T3[faction], faction, 3)
		SetupConvertibleTrigger(Dwellings_MP[faction], faction, 5)
	end
end


-- log(TRACE, "Loaded town-conversion.lua")
ROUTINES_LOADED[22] = 1
