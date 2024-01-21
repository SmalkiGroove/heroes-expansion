
dofile("/scripts/common.lua") sleep(1)


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

function UnblockGameTimer(player)
    if PLAYER_BRAIN[player] == COMPUTER then sleep(15) end
    UnblockGame()
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



function Register(var, value)
    ExecConsoleCommand("@SetGameVar('"..var.."','"..value.."')")
end
function SetVarString(var, value)
	return "SetGameVar('"..var.."','"..value.."') "
end


function VarHeroLevel(hero)
	return "h5x_hero_"..hero.."_level"
end
function VarHeroStatAttack(hero)
	return "h5x_hero_"..hero.."_stat_attack"
end
function VarHeroStatDefense(hero)
	return "h5x_hero_"..hero.."_stat_defense"
end
function VarHeroStatSpellpower(hero)
	return "h5x_hero_"..hero.."_stat_spellpower"
end
function VarHeroStatKnowledge(hero)
	return "h5x_hero_"..hero.."_stat_knowledge"
end
function VarHeroStatMorale(hero)
	return "h5x_hero_"..hero.."_stat_morale"
end
function VarHeroStatLuck(hero)
	return "h5x_hero_"..hero.."_stat_luck"
end
function VarHeroSkillId(hero, skill)
	return "h5x_hero_"..hero.."_skill_"..id
end
function VarHeroArtifactId(hero, artifact)
	return "h5x_hero_"..hero.."_artifact_"..id
end


function StoreData(hero)
	local setvars = SetVarString(VarHeroLevel(hero),GetHeroLevel(hero))..
					SetVarString(VarHeroStatAttack(hero),GetHeroStat(hero, STAT_ATTACK))..
					SetVarString(VarHeroStatDefense(hero),GetHeroStat(hero, STAT_DEFENCE))..
					SetVarString(VarHeroStatSpellpower(hero),GetHeroStat(hero, STAT_SPELL_POWER))..
					SetVarString(VarHeroStatKnowledge(hero),GetHeroStat(hero, STAT_KNOWLEDGE))..
					SetVarString(VarHeroStatMorale(hero),GetHeroStat(hero, STAT_MORALE))..
					SetVarString(VarHeroStatLuck(hero),GetHeroStat(hero, STAT_LUCK))
    -- print(setvars)
	ExecConsoleCommand("@"..setvars)
end



LOAD_SOURCES = 1
