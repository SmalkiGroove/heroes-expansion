
function NoneRoutine()
    -- print("Nothing happens !")
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- HERO MISC


function IsHeroHuman(hero)
	local player = GetObjectOwner(hero)
	return PLAYER_BRAIN[player] == HUMAN
end

function GetHeroArmy(hero)
	local type = {}
	type[1], type[2], type[3], type[4], type[5], type[6], type[7] = GetHeroCreaturesTypes(hero)
	return type
end

function GetHeroArmySummary(hero)
	local units = {}
	local amounts = {}
	local k = 0
	local army = GetHeroArmy(hero)
	for i = 1,7 do
		local cr = army[i]
		if cr and cr ~= 0 and not contains(units, cr) then
			local nb = GetHeroCreatures(hero, cr)
			k = k + 1
			units[k] = cr
			amounts[k] = nb
		end
	end
	return k, units, amounts
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- TOWNS


function FactionToTownType(faction)
	local town_type = -1
	if     faction == HAVEN then town_type = TOWN_HEAVEN
	elseif faction == PRESERVE then town_type = TOWN_PRESERVE
	elseif faction == INFERNO then town_type = TOWN_INFERNO
	elseif faction == NECROPOLIS then town_type = TOWN_NECROMANCY
	elseif faction == ACADEMY then town_type = TOWN_ACADEMY
	elseif faction == DUNGEON then town_type = TOWN_DUNGEON
	elseif faction == FORTRESS then town_type = TOWN_FORTRESS
	elseif faction == STRONGHOLD then town_type = TOWN_STRONGHOLD
	end
	return town_type
end

function GetTownFactionID(town)
	local towntype = 0
	if     contains(GetObjectNamesByType("TOWN_HEAVEN"),town) ~= nil then towntype = 1 
	elseif contains(GetObjectNamesByType("TOWN_PRESERVE"),town) ~= nil then towntype = 2 
	elseif contains(GetObjectNamesByType("TOWN_INFERNO"),town) ~= nil then towntype = 3 
	elseif contains(GetObjectNamesByType("TOWN_NECROMANCY"),town) ~= nil then towntype = 4 
	elseif contains(GetObjectNamesByType("TOWN_ACADEMY"),town) ~= nil then towntype = 5 
	elseif contains(GetObjectNamesByType("TOWN_DUNGEON"),town) ~= nil then towntype = 6 
	elseif contains(GetObjectNamesByType("TOWN_FORTRESS"),town) ~= nil then towntype = 7 
	elseif contains(GetObjectNamesByType("TOWN_STRONGHOLD"),town) ~= nil then towntype = 8 end
	return towntype
end

function GetFactionTowns(num)
	local towntype = "TOWN"
	if 	   num == 1 then towntype = "TOWN_HEAVEN"
	elseif num == 2 then towntype = "TOWN_PRESERVE"
	elseif num == 3 then towntype = "TOWN_INFERNO" 
	elseif num == 4 then towntype = "TOWN_NECROMANCY" 
	elseif num == 5 then towntype = "TOWN_ACADEMY" 
	elseif num == 6 then towntype = "TOWN_DUNGEON" 
	elseif num == 7 then towntype = "TOWN_FORTRESS" 
	elseif num == 8 then towntype = "TOWN_STRONGHOLD" end
    local towns = GetObjectNamesByType(towntype)
    return towns
end

function GetPlayerTowns(player)
	local cities = {}
	local towns = GetObjectNamesByType("TOWN")
	for i,town in towns do
		if GetObjectOwner(town) == player then
			insert(cities,town)
		end
	end
	return cities
end

function GetHeroTowns(player, hero)
    local cities = {}
    local factionID = HEROES[hero]
    local towns = GetFactionTowns(factionID)
    for i,town in towns do
		if GetObjectOwner(town) == player then
			insert(cities,town)
		end
	end
	return cities
end

function GetTownValue(town)
    local value = 0
    value = value + GetTownBuildingLevel(town, TOWN_BUILDING_GRAIL) * 10000
    value = value + GetTownBuildingLevel(town, TOWN_BUILDING_TOWN_HALL) * 1000
    value = value + GetTownBuildingLevel(town, TOWN_BUILDING_FORT) * 500
    value = value + GetTownBuildingLevel(town, TOWN_BUILDING_MAGIC_GUILD) * 250
    value = value + GetTownBuildingLevel(town, TOWN_BUILDING_MARKETPLACE) * 250
    value = value + GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_1) * 50
    value = value + GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_2) * 100
    value = value + GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_3) * 150
    value = value + GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_4) * 200
    value = value + GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_5) * 250
    value = value + GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_6) * 300
    value = value + GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_7) * 350
    return value
end

function FindMainTown(player)
    local main_town = nil
    local max_value = 0
    local towns = GetPlayerTowns(player)
    for i,town in towns do
        local value = GetTownValue(town)
        if value > max_value then
            main_town = town
            max_value = value
        end
    end
    return main_town
end

function CheckMainTown(player)
    local main_town = PLAYER_MAIN_TOWN[player]
    if player ~= GetObjectOwner(main_town) then
        PLAYER_MAIN_TOWN[player] = FindMainTown(player)
        print("Player "..player.." has new main town : "..PLAYER_MAIN_TOWN[player])
    end
end

function InitializeMapTowns()
    local map_size = GetTerrainSize() - 1
    for faction,type in Towns_Types do
        for _,town in GetObjectNamesByType(type) do
            MAP_TOWNS_COUNT = MAP_TOWNS_COUNT + 1
            local owner = GetObjectOwner(town)
            if not PLAYER_MAIN_TOWN[owner] then PLAYER_MAIN_TOWN[owner] = town end
            local x,y,floor = GetObjectPosition(town)
            local dx = TOWN_TYPES_CENTER_TILE[type][1]
            local dy = TOWN_TYPES_CENTER_TILE[type][2]
            local found = nil
            for i = -1,1 do for j = -1,1 do
                if abs(i) ~= abs(j) then
                    local xx = x + i*(5+dy) + j*dx
                    local yy = y + j*(5+dy) - i*dx
                    if (xx+i >= 0 and xx+i <= map_size and yy+j >= 0 and yy+j <= map_size) then
                        if IsTilePassable(xx, yy, floor) then
                            if not (IsTilePassable(xx+j, yy+i, floor) or IsTilePassable(xx-j, yy-i, floor)) then
                                if IsTilePassable(xx+i, yy+j, floor) then
                                    MAP_TOWNS[town] = {[0]=faction, [1]=xx, [2]=yy, [3]=floor}
                                    found = not nil
                                    break
                                end
                            end
                        end
                    end
                end
            end if found then break end end
            if found then
                local data = MAP_TOWNS[town]
                print("Registered town of faction "..FACTION_TEXT[data[0]].." at coords x="..data[1]..",y="..data[2]..",z="..data[3].." (entrance)")
            else
                print("Town "..town.." has no entrance ?? (type is "..type..")")
            end
        end
    end
    for player = 1,8 do
        if GetPlayerState(player) == 1 and not PLAYER_MAIN_TOWN[player] then
            print("Player "..player.." has no main town ??")
        end
    end
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- COMMON


function AddPlayer_Resource(player, hero, resource, amount)
	print("$ AddPlayer_Resource")
	if amount >= 1 then
		local curamount = GetPlayerResource(player, resource)
		local newamount = curamount + amount
		SetPlayerResource(player, resource, newamount)
		ShowFlyingSign({"/Text/Game/Scripts/Resources/"..RESOURCE_TEXT[resource]..".txt"; num=amount}, hero, player, FLYING_SIGN_TIME)
	end
end

function TakePlayer_Resource(player, resource, amount)
	print("$ TakePlayer_Resource")
	if amount >= 1 then
		local curamount = GetPlayerResource(player, resource)
		local newamount = curamount - amount
		SetPlayerResource(player, resource, newamount)
	end
end

function AddHero_StatAmount(player, hero, stat, amount)
	print("$ AddHero_StatAmount")
    if amount ~= 0 then
		ChangeHeroStat(hero, stat, amount)
		ShowFlyingSign({"/Text/Game/Scripts/Stats/"..ATTRIBUTE_TEXT[stat]..".txt"; num=amount}, hero, player, FLYING_SIGN_TIME)
	end
end

function AddHero_RandomSpell(player, hero, school, maxtier)
	print("$ AddHero_RandomSpell")
	local spells = {}
	if school == SPELL_SCHOOL_ANY then
		for tier = 1,maxtier do
			for _,spell in SPELLS_BY_TIER[tier] do
				insert(spells, spell)
			end
		end
	else
		local last = 3 * (maxtier - 1)
		print("Can learn spell up to "..SPELLS_BY_SCHOOL[school][last])
		for i = 1,last do
			insert(spells, SPELLS_BY_SCHOOL[school][i])
		end
	end
	local nb = length(spells)
	local spell = SPELL_NONE
	local tries = 5
	repeat
		tries = tries - 1
		spell = spells[random(0, nb-1, TURN-school)]
	until tries == 0 or not KnowHeroSpell(hero, spell)
	if tries ~= 0 then
		TeachHeroSpell(hero, spell)
		ShowFlyingSign("/Text/Game/Scripts/LearnSpell.txt", hero, player, FLYING_SIGN_TIME)
	end
end

function AddHero_RandomSpellTier(player, hero, school, tier)
	print("$ AddHero_RandomSpellTier")
	local spells = {}
	if school == SPELL_SCHOOL_ANY then
		spells = SPELLS_BY_TIER[tier]
	else
		for _,spell in SPELLS_BY_TIER[tier] do
			if contains(SPELLS_BY_SCHOOL[school], spell) then
				insert(spells, spell)
			end
		end
	end
	local nb = length(spells)
	local spell = SPELL_NONE
	local tries = 5
	repeat
		tries = tries - 1
		spell = spells[random(0, nb-1, TURN-school)]
	until tries == 0 or not KnowHeroSpell(hero, spell)
	if tries ~= 0 then
		TeachHeroSpell(hero, spell)
		ShowFlyingSign("/Text/Game/Scripts/LearnSpell.txt", hero, player, FLYING_SIGN_TIME)
	end
end

function AddHero_CreatureType(player, hero, type, coef)
	print("AddHero_CreatureType")
	local level = GetHeroLevel(hero)
	local nb = round(coef * level)
	if nb >= 1 then
		AddHeroCreatures(hero, type, nb)
		ShowFlyingSign({"/Text/Game/Scripts/Reinforcements.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
	end
end

function AddHero_CreatureInTypes(player, hero, types, coef)
	print("$ AddHero_CreatureInTypes")
	local level = GetHeroLevel(hero)
	local nb = round(coef * level)
	if nb >= 1 then
		local army = GetHeroArmy(hero)
		local b = 0
		for i = 1,7 do
            if contains(types, army[i]) then
                AddHeroCreatures(hero, army[i], nb)
                ShowFlyingSign({"/Text/Game/Scripts/Reinforcements.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
                return
            end
        end
		AddHeroCreatures(hero, types[1], nb)
		ShowFlyingSign({"/Text/Game/Scripts/Reinforcements.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
	end
end

function AddHero_TownRecruits(player, hero, dwelling, creature, coef)
	print("AddHero_TownRecruits")
	local level = GetHeroLevel(hero)
	local towns = GetHeroTowns(player, hero)
	local nb = round(coef * level)
	if nb >= 1 then
		for i,town in towns do
			if GetTownBuildingLevel(town, dwelling) ~= 0 then
                local current = GetObjectDwellingCreatures(town, creature)
				SetObjectDwellingCreatures(town, creature, current + nb)
				ShowFlyingSign({"/Text/Game/Scripts/Recruits.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
			end
		end
	end
end

function AddHero_CreatureFromDwelling(player, hero, dwelling, creature, coef)
	print("$ AddHero_CreatureFromDwelling")
	local level = GetHeroLevel(hero)
	local towns = GetHeroTowns(player, hero)
	for i,town in towns do
		if GetTownBuildingLevel(town, dwelling) ~= 0 then
			local recruits = GetObjectDwellingCreatures(town, creature)
			local nb = min(trunc(coef * level), recruits)
			if nb >= 1 then
				SetObjectDwellingCreatures(town, creature, recruits-nb)
				AddHeroCreatures(hero, creature, nb)
				ShowFlyingSign({"/Text/Game/Scripts/Reinforcements.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
			end
		end
	end
end

function ChangeHero_TownRecruits(player, hero, dwelling1, creature1, dwelling2, creature2, amount)
	print("$ ChangeHero_TownRecruits")
	local towns = GetHeroTowns(player, hero)
	for i,town in towns do
		if GetTownBuildingLevel(town, dwelling1) ~= 0 and GetTownBuildingLevel(town, dwelling2) ~= 0 then
			local recruits1 = GetObjectDwellingCreatures(town, creature1)
			local recruits2 = GetObjectDwellingCreatures(town, creature2)
			local nb = min(amount, recruits1)
			if nb >= 1 then
				SetObjectDwellingCreatures(town, creature1, recruits1 - nb)
				SetObjectDwellingCreatures(town, creature2, recruits2 + nb)
				ShowFlyingSign({"/Text/Game/Scripts/Recruits.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
			end
		end
	end
end

function ChangeHero_CreatureUpgrade(player, hero, base, upgrade)
	print("$ ChangeHero_CreatureUpgrade")
	local nb = GetHeroCreatures(hero, base)
	RemoveHeroCreatures(hero, base, nb)
	AddHeroCreatures(hero, upgrade, nb)
	ShowFlyingSign({"/Text/Game/Scripts/Evolve.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- HELPERS


function IsEqualPosition(object, x, y, z)
    local xx, yy, zz = GetObjectPosition(object)
    return (x == xx and y == yy and z == zz)
end



-- print("Loaded advmap-utils.lua")
ROUTINES_LOADED[9] = 1
