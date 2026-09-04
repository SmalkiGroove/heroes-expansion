
MAGIC_GUILD_HERO_BONUSES = {}

function SetupTownTavern(town, faction)
    log.trace("/scripts/advmap/handlers/towns-manager.lua: SetupTownTavern")
	for i = 1,8 do
		local enabled = (faction == i) and 1 or 0
		AllowHeroHiringByRaceInTown(town, FactionToTownType(i), enabled)
	end
end

function GetFactionTowns(num)
	log.trace("/scripts/advmap/handlers/towns-manager.lua: GetFactionTowns")
	local towntype = Towns_Types[num] or "TOWN"
    return GetObjectNamesByType(towntype)
end

function GetPlayerTowns(player)
	log.trace("/scripts/advmap/handlers/towns-manager.lua: GetPlayerTowns")
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
    log.trace("/scripts/advmap/handlers/towns-manager.lua: GetHeroTowns")
    local cities = {}
    local towns = GetFactionTowns(HEROES[hero].faction)
    for i,town in towns do
		if GetObjectOwner(town) == player then
			insert(cities,town)
		end
	end
	return cities
end

function GetTownValue(town)
    log.trace("/scripts/advmap/handlers/towns-manager.lua: GetTownValue")
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
    log.trace("/scripts/advmap/handlers/towns-manager.lua: FindMainTown")
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
    log.trace("/scripts/advmap/handlers/towns-manager.lua: CheckMainTown")
    local main_town = PLAYER_MAIN_TOWN[player]
    if player ~= GetObjectOwner(main_town) then
        PLAYER_MAIN_TOWN[player] = FindMainTown(player)
        log.debug("Player "..player.." has new main town : "..PLAYER_MAIN_TOWN[player])
    end
end

function FindClosestTown(player, hero)
	log.trace("/scripts/advmap/handlers/towns-manager.lua: FindClosestTown")
	local x,y,z = GetObjectPosition(hero)
	local closest = nil
	local distance = 1000000000
	for town,data in MAP_TOWNS do
        if GetObjectOwner(town) == player then
            local dx = x - data.x
            local dy = y - data.y
            local dz = (z - data.z) * 1000
            local d = dx*dx + dy*dy + dz*dz
            if d < distance then
                closest = town
                distance = d
            end
        end
    end
	return closest
end

function InitializeMapTowns()
    log.trace("/scripts/advmap/handlers/towns-manager.lua: InitializeMapTowns")
    if IsDuelMode() then return end
    TOWN_TYPES_CENTER_TILE = {
        ["TOWN_HEAVEN"] = {-1,1},
        ["TOWN_PRESERVE"] = {-1,0},
        ["TOWN_INFERNO"] = {-1,1},
        ["TOWN_NECROMANCY"] = {-1,0},
        ["TOWN_ACADEMY"] = {-1,1},
        ["TOWN_DUNGEON"] = {-1,1},
        ["TOWN_FORTRESS"] = {-1,1},
        ["TOWN_STRONGHOLD"] = {0,0},
    }
    local map_size = GetTerrainSize() - 1
    for faction,type in Towns_Types do
        for _,town in GetObjectNamesByType(type) do
            local owner = GetObjectOwner(town)
            if owner > 0 and not PLAYER_MAIN_TOWN[owner] then
                PLAYER_MAIN_TOWN[owner] = town
                if DIFFICULTY > 1 and IsAIPlayer(owner) then UpgradeTownBuilding(town, TOWN_BUILDING_GRAIL) end
            end
            MAP_TOWN_BUILDINGS[town] = {}
            for b = 0,25 do
                local v = GetTownBuildingLevel(town,b)
                MAP_TOWN_BUILDINGS[town][b] = v
            end
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
                                    MAP_TOWNS[town] = {faction=faction, x=xx, y=yy, z=floor}
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
                log.debug("Registered town of faction "..FACTION_TEXT[data.faction].." at coords x="..data.x..",y="..data.y..",z="..data.z.." (entrance)")
            else
                log.debug("Town "..town.." has no entrance ?? (type is "..type..")")
            end
			SetupTownTavern(town, faction)
        end
    end
    for player = 1,8 do
        if GetPlayerState(player) == 1 and not PLAYER_MAIN_TOWN[player] then
            log.debug("WARNING: Player "..player.." has no main town ??")
        end
    end
end


function TownBuildTrigger(player)
    log.trace("/scripts/advmap/handlers/towns-manager.lua: TownBuildTrigger")
    for _,town in GetPlayerTowns(player) do
        if MAP_TOWN_BUILDINGS[town] then
            for b,v in MAP_TOWN_BUILDINGS[town] do
                if GetTownBuildingLevel(town,b) > v then
                    log.debug("Player "..player.." has built "..b.." in town "..town)
                    MAP_TOWN_BUILDINGS[town][b] = v + 1
                    startThread(DoTownsRoutine_Built, player, town, b)
                end
            end
        end
    end
end


-- log.debug("Loaded towns-manager.lua")
