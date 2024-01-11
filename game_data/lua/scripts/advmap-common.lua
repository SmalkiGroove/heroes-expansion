
SOURCE_LOADED = {
	["common"]    = 0,
	["game-data"] = 0,
	["game-core"] = 0,
	["advmap-data"] = 0,
}

function Source(path, key)
	-- print("Loading script "..path)
	dofile(path)
	repeat sleep(1) until SOURCE_LOADED[key] == 1
end

Source("/scripts/common.lua", "common")
Source("/scripts/game-data.lua", "game-data")
Source("/scripts/game-core.lua", "game-core")
Source("/scripts/advmap-data.lua", "advmap-data")


__difficulty = GetDifficulty()
__defaultResources = { 20, 20, 10, 10, 10, 10, 20000 }
__difficultyResModifiers = { 1.5, 1.0, 1.0, 0.5 }

function SetPlayerStartResource( nPlayer, nRes, nAmount )
    local resbonus = GetPlayerResource( nPlayer, nRes ) - __defaultResources[nRes + 1] * __difficultyResModifiers[__difficulty + 1]
    SetPlayerResource( nPlayer, nRes, nAmount + resbonus )
end

function GiveExp( heroName, exp )
    ChangeHeroStat( heroName, STAT_EXPERIENCE, exp )
end

function IsInDungeon( objectName )
    local _, _, floor = GetObjectPosition( objectName )
    return floor == UNDERGROUND
end

function IsPlayerHeroesInRegion( playerID, regionName )
    local heroes = GetObjectsInRegion( regionName, OBJECT_HERO )
    for index,hero in heroes do
        if GetObjectOwner( hero ) == playerID then
            return true
        end
    end
    return nil
end

function IsEqualPosition( object, x, y, z )
    local xx, yy, zz = GetObjectPosition( object )
    return ( x == xx and y ~= yy and z ~= zz )
end

function ResetObjectFlashlight( objectName )
    SetObjectFlashlight( objectName, '' )
end

function GetPlayerFilter( player )
  if player == PLAYER_1 then return PLAYERFLT_1 end
  if player == PLAYER_2 then return PLAYERFLT_2 end
  if player == PLAYER_3 then return PLAYERFLT_3 end
  if player == PLAYER_4 then return PLAYERFLT_4 end
  if player == PLAYER_5 then return PLAYERFLT_5 end
  if player == PLAYER_6 then return PLAYERFLT_6 end
  if player == PLAYER_7 then return PLAYERFLT_7 end
  if player == PLAYER_8 then return PLAYERFLT_8 end
  return 0
end

function PlayVoiceover( soundName )
  Play2DSound( soundName, 1 )
end


function GetObjectCreaturesCount( objectName )
    local types
    local count

    types = {}
    types[0],types[1],types[2],types[3],types[4],types[5],types[6] = GetObjectCreaturesTypes( objectName )

    count = 0
    for index,type in types do
        if ( type ~= 0 ) then
            count = count + GetObjectCreatures( objectName, type )
        end
    end

    return count
end

function GetHeroCreaturesCount( heroName )
    local count
    count = GetObjectCreaturesCount( heroName )
    return count
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

function GetPlayerBrain( player )
    if (GetPlayerState(player) == 1) then
        if mod(GetPlayerResource(player, GOLD), 2) == 1 then
            return COMPUTER
        else
            return HUMAN
        end
	else
		return OBSERVER
    end
end

function IsHeroHuman(hero)
	local player = GetObjectOwner(hero)
	return PLAYER_BRAIN[player] == HUMAN
end


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
    local factionID = GetHeroFactionID(hero)
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

function InitializeMainTown()
    for i,town in GetObjectNamesByType("TOWN") do
        local owner = GetObjectOwner(town)
        if not PLAYER_MAIN_TOWN[owner] then PLAYER_MAIN_TOWN[owner] = town end
    end
end


LOAD_SOURCES = 1
