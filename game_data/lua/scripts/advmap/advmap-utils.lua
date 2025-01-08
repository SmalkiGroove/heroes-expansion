
function NoneRoutine()
    -- log("Nothing happens !")
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

function GetArmyStrength(combatIndex, side)
	local value = 0
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, side)
	for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, side, i)
        value = value + died * power(2, CREATURES[creature][2])
    end
	return value
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
    local factionID = HEROES[hero].faction
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
        log("Player "..player.." has new main town : "..PLAYER_MAIN_TOWN[player])
    end
end

function FindClosestTown(player, hero)
	local x,y,z = GetObjectPosition(hero)
	local closest = nil
	local distance = 1000000000
	for i,town in GetPlayerTowns(player) do
		local tx,ty,tz = GetObjectPosition(town)
		local dx = x - tx
		local dy = y - ty
		local dz = (z - tz) * 1000
		local d = dx*dx + dy*dy + dz*dz
		if d < distance then
			closest = town
			distance = d
		end
	end
	return closest
end

function SetupTownTavern(town, faction)
	for i = 1,8 do
		local enabled = (faction == i) and 1 or 0
		AllowHeroHiringByRaceInTown(town, FactionToTownType(i), enabled)
	end
end

function InitializeMapTowns()
    local map_size = GetTerrainSize() - 1
    for faction,type in Towns_Types do
        for _,town in GetObjectNamesByType(type) do
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
                log("Registered town of faction "..FACTION_TEXT[data.faction].." at coords x="..data.x..",y="..data.y..",z="..data.z.." (entrance)")
            else
                log("Town "..town.." has no entrance ?? (type is "..type..")")
            end
			SetupTownTavern(town, faction)
        end
    end
    for player = 1,8 do
        if GetPlayerState(player) == 1 and not PLAYER_MAIN_TOWN[player] then
            log("Player "..player.." has no main town ??")
        end
    end
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- COMMON


function AddPlayerResource(player, hero, resource, amount)
	log("$ AddPlayerResource")
	if amount >= 1 then
		local curamount = GetPlayerResource(player, resource)
		local newamount = curamount + amount
		SetPlayerResource(player, resource, newamount, hero)
		-- repeat SetPlayerResource(player, resource, newamount, hero) until GetPlayerResource(player, resource) == newamount
		-- ShowFlyingSign({"/Text/Game/Scripts/Resources/"..RESOURCE_TEXT[resource]..".txt"; num=amount}, hero, player, FLYING_SIGN_TIME)
	end
end

function RemovePlayerResource(player, resource, amount)
	log("$ RemovePlayerResource")
	if amount >= 1 then
		local curamount = GetPlayerResource(player, resource)
		local newamount = curamount - amount
		SetPlayerResource(player, resource, newamount)
	end
end

function AddHeroStatAmount(player, hero, stat, amount)
	log("$ AddHeroStatAmount")
    if amount ~= 0 then
		ChangeHeroStat(hero, stat, amount)
		-- ShowFlyingSign({"/Text/Game/Scripts/Stats/"..ATTRIBUTE_TEXT[stat]..".txt"; num=amount}, hero, player, FLYING_SIGN_TIME)
	end
end

function AddHeroLowestStat(player, hero, amount)
	log("$ AddHeroLowestStat")
    if amount ~= 0 then
		local stat = 0
		local value = 9999
		for s = 1,4 do
			local v = GetHeroStat(hero, s)
			if v < value then
				stat = s
				value = v
			end
		end
		if stat ~= 0 then
			ChangeHeroStat(hero, stat, amount)
			-- ShowFlyingSign({"/Text/Game/Scripts/Stats/"..ATTRIBUTE_TEXT[stat]..".txt"; num=amount}, hero, player, FLYING_SIGN_TIME)
		end
	end
end

function AddHeroManaUnbound(player, hero, amount)
	log("$ AddHeroManaUnbound")
	local klg = ceil(0.1 * amount)
	ChangeHeroStat(hero, STAT_KNOWLEDGE, klg) sleep()
	ChangeHeroStat(hero, STAT_MANA_POINTS, amount) sleep()
	ChangeHeroStat(hero, STAT_KNOWLEDGE, -klg) sleep()
end

function TeachHeroRandomSpell(player, hero, school, maxtier)
	log("$ TeachHeroRandomSpell")
	local spells = {}
	if school == SPELL_SCHOOL_ANY then
		for tier = 1,maxtier do
			for _,spell in SPELLS_BY_TIER[tier] do
				if not KnowHeroSpell(hero, spell) then insert(spells, spell) end
			end
		end
	else
		local last = 3 * (maxtier - 1)
		-- log("Can learn spell up to "..SPELLS_BY_SCHOOL[school][last])
		for i = 1,last do
			local spell = SPELLS_BY_SCHOOL[school][i]
			if not KnowHeroSpell(hero, spell) then insert(spells, spell) end
		end
	end
	local nb = length(spells)
	if nb == 0 then
		return
	elseif nb == 1 then
		TeachHeroSpell(hero, spells[1])
		-- ShowFlyingSign("/Text/Game/Scripts/LearnSpell.txt", hero, player, FLYING_SIGN_TIME)
	else
		local spell = spells[random(1, nb, TURN-school)]
		TeachHeroSpell(hero, spell)
		-- ShowFlyingSign("/Text/Game/Scripts/LearnSpell.txt", hero, player, FLYING_SIGN_TIME)
	end
end

function TeachHeroRandomSpellTier(player, hero, school, tier)
	log("$ TeachHeroRandomSpellTier")
	local spells = {}
	if school == SPELL_SCHOOL_ANY then
		for _,spell in SPELLS_BY_TIER[tier] do
			if not KnowHeroSpell(hero, spell) then insert(spells, spell) end
		end
	else
		for _,spell in SPELLS_BY_TIER[tier] do
			if contains(SPELLS_BY_SCHOOL[school], spell) then
				if not KnowHeroSpell(hero, spell) then insert(spells, spell) end
			end
		end
	end
	local nb = length(spells)
	if nb == 0 then
		return
	elseif nb == 1 then
		TeachHeroSpell(hero, spells[1])
		-- ShowFlyingSign("/Text/Game/Scripts/LearnSpell.txt", hero, player, FLYING_SIGN_TIME)
	else
		local spell = spells[random(1, nb, TURN-school)]
		TeachHeroSpell(hero, spell)
		-- ShowFlyingSign("/Text/Game/Scripts/LearnSpell.txt", hero, player, FLYING_SIGN_TIME)
	end
end

function AddHeroCreaturePerLevel(player, hero, type, coef)
	log("AddHeroCreaturePerLevel")
	local level = GetHeroLevel(hero)
	local nb = round(coef * level)
	if nb >= 1 then
		AddHeroCreatures(hero, type, nb)
		-- ShowFlyingSign({"/Text/Game/Scripts/Reinforcements.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
	end
end

function AddHeroCreatureType(player, hero, faction, tier, nb, default)
	log("$ AddHeroCreatureType")
	if nb >= 1 then
		local army = GetHeroArmy(hero)
		local b = 0
		for i = 1,7 do
            if contains(CREATURES_BY_FACTION[faction][tier], army[i]) then
                AddHeroCreatures(hero, army[i], nb)
                -- ShowFlyingSign({"/Text/Game/Scripts/Reinforcements.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
                return
            end
        end
		if default ~= 0 then
			AddHeroCreatures(hero, CREATURES_BY_FACTION[faction][tier][default], nb)
			-- ShowFlyingSign({"/Text/Game/Scripts/Reinforcements.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
		end
	end
end

function CountHeroCreatureType(player, hero, faction, tier)
	log("$ CountHeroCreatureType")
	local count = 0
	for _,cr in CREATURES_BY_FACTION[faction][tier] do
		count = count + GetHeroCreatures(hero, cr)
	end
	return count
end

function AddHeroTownRecruits(player, hero, dwelling, creature, nb)
	log("AddHeroTownRecruits")
	local towns = GetHeroTowns(player, hero)
	if nb >= 1 then
		for i,town in towns do
			if GetTownBuildingLevel(town, dwelling) ~= 0 then
                local current = GetObjectDwellingCreatures(town, creature)
				SetObjectDwellingCreatures(town, creature, current + nb)
				-- ShowFlyingSign({"/Text/Game/Scripts/Recruits.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
			end
		end
	end
end

function TransferCreatureFromTown(player, hero, dwelling, creature, coef)
	log("$ TransferCreatureFromTown")
	local level = GetHeroLevel(hero)
	local towns = GetHeroTowns(player, hero)
	for i,town in towns do
		if GetTownBuildingLevel(town, dwelling) ~= 0 then
			local recruits = GetObjectDwellingCreatures(town, creature)
			local nb = min(trunc(coef * level), recruits)
			if nb >= 1 then
				SetObjectDwellingCreatures(town, creature, recruits-nb)
				AddHeroCreatureType(player, hero, CREATURES[creature][1], CREATURES[creature][2], nb, 1)
				-- ShowFlyingSign({"/Text/Game/Scripts/Reinforcements.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
			end
		end
	end
end

function TransformTownRecruits(player, hero, dwelling1, creature1, dwelling2, creature2, amount)
	log("$ TransformTownRecruits")
	local towns = GetHeroTowns(player, hero)
	for i,town in towns do
		if GetTownBuildingLevel(town, dwelling1) ~= 0 and GetTownBuildingLevel(town, dwelling2) ~= 0 then
			local recruits1 = GetObjectDwellingCreatures(town, creature1)
			local recruits2 = GetObjectDwellingCreatures(town, creature2)
			local nb = min(amount, recruits1)
			if nb >= 1 then
				SetObjectDwellingCreatures(town, creature1, recruits1 - nb)
				SetObjectDwellingCreatures(town, creature2, recruits2 + nb)
				-- ShowFlyingSign({"/Text/Game/Scripts/Recruits.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
			end
		end
	end
end

function UpgradeHeroCreatures(player, hero, base, upgrade)
	log("$ UpgradeHeroCreatures")
	local nb = GetHeroCreatures(hero, base)
	if nb >= 1 then
		RemoveHeroCreatures(hero, base, nb)
		AddHeroCreatures(hero, upgrade, nb)
		-- ShowFlyingSign({"/Text/Game/Scripts/Evolve.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
	end
end

function ResurrectCreatureType(player, hero, combatIndex, faction, tier, max)
	log("$ ResurrectCreatureType")
	local cap = max
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 1)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 1, i)
        if died > 0 and cap > 0 then
            if CREATURES[creature][1] == faction and CREATURES[creature][2] == tier then
				local rez = min(cap, died)
				cap = cap - rez
				AddHeroCreatures(hero, creature, rez)
			end
        end
    end
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- HELPERS


function IsEqualPosition(object, x, y, z)
    local xx, yy, zz = GetObjectPosition(object)
    return (x == xx and y == yy and z == zz)
end

function CreatureToUndead(creature)
	if CREATURES[creature][1] == NECROPOLIS or creature == CREATURE_MUMMY then return creature end
	local tier = CREATURES[creature][2]
	return CREATURES_BY_FACTION[NECROPOLIS][tier][1]
end

function TransformCreatures(obj, creature, faction)
	local nb = GetObjectCreature(obj, creature)
	local tier = CREATURES[creature][2]
	local cr = CREATURES_BY_FACTION[faction][tier][1]
	RemoveObjectCreatures(obj, creature, nb) sleep()
	AddObjectCreatures(obj, cr, nb) sleep()
end

function InitializeRandomSeed()
	local value = GetTerrainSize() + GetDifficulty()
	for p = 1,8 do
		if (GetPlayerState(p) == 1) then
			value = value + p
			for _,h in GetPlayerHeroes(p) do
				for s = 1,220 do
					if HasHeroSkill(h, s) then value = value + s end
				end
			end
		end
	end
	RANDOM_SEED = value
	log("Random seed = "..RANDOM_SEED)
end

function LoadedGame_GameVars()
	for player = 1,8 do
		if (GetPlayerState(player) == 1) then
			for i,hero in GetPlayerHeroes(player) do
				Register(VarHeroLevel(hero), GetHeroLevel(hero))
				for skill = 1,220 do
					if HasHeroSkill(hero, skill) then Register(VarHeroSkillId(hero, skill), GetHeroSkillMastery(hero, skill)) end
				end
			end
		end
	end
end



function AddAllArtifacts(hero)
	for a = 1,199 do
		if ARTIFACTS_DATA[a].special == 0 then GiveArtifact(hero, a) end
	end
end


-- log("Loaded advmap-utils.lua")
ROUTINES_LOADED[9] = 1
