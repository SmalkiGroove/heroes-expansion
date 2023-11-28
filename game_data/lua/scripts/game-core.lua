
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

function GetCreatureFactionID(id)
	local race = 0
	if 	   (id >= 1 and id <= 14) or (id >= 106 and id <= 112) then race = 1
	elseif (id >= 43 and id <= 56) or (id >= 145 and id <= 151) then race = 2
	elseif (id >= 15 and id <= 28) or (id >= 131 and id <= 137) then race = 3
	elseif (id >= 29 and id <= 42) or (id >= 152 and id <= 158) then race = 4
	elseif (id >= 57 and id <= 70) or (id >= 159 and id <= 165) then race = 5
	elseif (id >= 71 and id <= 84) or (id >= 138 and id <= 144) then race = 6
	elseif (id >= 92 and id <= 105) or (id >= 166 and id <= 172) then race = 7
	elseif (id >= 117 and id <= 130) or (id >= 173 and i <= 179) then race = 8 end
	return race
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

function GetHeroFactionID(hero)
	local race = 0
	if 	   contains(HEROES_HAVEN,hero) ~= nil then race = 1 
	elseif contains(HEROES_SYLVAN,hero) ~= nil then race = 2 
	elseif contains(HEROES_INFERNO,hero) ~= nil then race = 3 
	elseif contains(HEROES_NECRO,hero) ~= nil then race = 4 
	elseif contains(HEROES_ACADEMY,hero) ~= nil then race = 5 
	elseif contains(HEROES_DUNGEON,hero) ~= nil then race = 6 
	elseif contains(HEROES_FORTRESS,hero) ~= nil then race = 7 	
	elseif contains(HEROES_ORCS,hero) ~= nil then race = 8 end
	return race
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

function GetHeroTowns(player,hero)
    local cities = {}
    local factionID = GetHeroFactionID(hero)
    local towns = GetFactionTowns(factionID)
    for i,town in towns do
		if GetObjectOwner(town) == player then
			insert(cities,town)
		end
	end
	return cities
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
			-- print("Hero "..hero.." army contains "..nb.." creatures of type "..cr)
			k = k + 1
			units[k] = cr
			amounts[k] = nb
		end
	end
	return k, units, amounts
end

function IsHeroHuman(hero)
	local player = GetObjectOwner(hero)
	return PLAYER_BRAIN[player] == HUMAN
end


SOURCE_LOADED["game-core"] = 1