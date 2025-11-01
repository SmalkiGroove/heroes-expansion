
function NoneRoutine()
    -- Nothing happens
end



-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER MISC

function StartingBonus(player)
	log(DEBUG, "$ StartingBonus for player "..player)
	local gold = GetPlayerResource(player, GOLD)
	local diff = mod(gold, 10000)
	if diff > 1 then -- bonus resources chosen
		log(DEBUG, "Bonus resources chosen")
		for res = 0,5 do SetPlayerResource(player, res, GetPlayerResource(player, res) + 5) end
		SetPlayerResource(player, GOLD, gold - diff + 5000)
		return
	end
	for res = 0,5 do
		local amount = GetPlayerResource(player, res)
		diff = mod(amount, 10)
		if diff ~= 0 then -- bonus army chosen
			PLAYER_ARMY_BONUS[player] = 1
			SetPlayerResource(player, res, amount - diff)
		end
	end
	if PLAYER_ARMY_BONUS[player] then
		log(DEBUG, "Bonus army chosen")
	else -- bonus artifact chosen
		log(DEBUG, "Bonus artifact chosen")
		local hero = GetPlayerHeroes(player)[0]
		if hero then
			for a = 1,199 do if HasArtefact(hero, a) then RemoveArtefact(hero, a) end end
			GiveHeroRandomArtifact(player, hero, ARTIFACT_CLASS_MAJOR, HEROES[hero].faction)
		end
	end
end

function UpdateTavernHeroes()
    for hero,data in HEROES do
        if not IsHeroAlive(hero) then
            if IsArmyEmpty(hero) then
                startThread(SetStartingArmy, hero)
            end
        end
    end
end

function UpdateTavernFactions()
    for town,data in MAP_TOWNS do
        local owner = GetObjectOwner(town)
        if owner > 0 then
            AllowPlayerTavernRace(owner, FactionToTownType(data.faction), 1)
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- HERO MISC


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


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- COMMON

function PlayerDailyResources(player)
	for res,amount in DAILY_RESOURCES[player] do
		local curamount = GetPlayerResource(player, res)
		local newamount = curamount + amount
		SetPlayerResource(player, res, newamount)
	end
end

function GiveResources(player, resource, amount, now)
	-- log(DEBUG, "$ GiveResources")
	if amount >= 1 then
		if now then
			local curamount = GetPlayerResource(player, res)
			local newamount = curamount + amount
			SetPlayerResource(player, res, newamount)
		else
			DAILY_RESOURCES[player][resource] = DAILY_RESOURCES[player][resource] + amount
		end
	end
end

function AddHeroStatAmount(player, hero, stat, amount)
	-- log(DEBUG, "$ AddHeroStatAmount")
    if amount ~= 0 then
		ChangeHeroStat(hero, stat, amount)
	end
end

function GetHeroLowestStat(hero)
	-- log(DEBUG, "$ GetHeroLowestStat")
	local stat = 0
	local value = 9999
	for s = 1,4 do
		local v = GetHeroStat(hero, s)
		if v < value then
			stat = s
			value = v
		end
	end
	return stat
end

function GetHeroHighestStat(hero)
	-- log(DEBUG, "$ GetHeroHighestStat")
	local stat = 0
	local value = 0
	for s = 1,4 do
		local v = GetHeroStat(hero, s)
			if v > value then
				stat = s
				value = v
			end
		end
	return stat
end

function AddHeroManaUnbound(player, hero, amount)
	-- log(DEBUG, "$ AddHeroManaUnbound")
	local klg = ceil(0.1 * amount)
	ChangeHeroStat(hero, STAT_KNOWLEDGE, klg) sleep()
	ChangeHeroStat(hero, STAT_MANA_POINTS, amount) sleep()
	ChangeHeroStat(hero, STAT_KNOWLEDGE, -klg) sleep()
end

function TeachHeroRandomSpell(player, hero, school, maxtier)
	-- log(DEBUG, "$ TeachHeroRandomSpell")
	local spells = {}
	if school == SPELL_SCHOOL_ANY then
		for tier = 1,maxtier do
			for _,spell in SPELLS_BY_TIER[tier] do
				if not KnowHeroSpell(hero, spell) then insert(spells, spell) end
			end
		end
	else
		local last = 3 * (maxtier - 1)
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
	else
		local spell = spells[random(1, nb, TURN-school)]
		TeachHeroSpell(hero, spell)
	end
end

function TeachHeroRandomSpellTier(player, hero, school, tier)
	-- log(DEBUG, "$ TeachHeroRandomSpellTier")
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
	else
		local spell = spells[random(1, nb, TURN-school)]
		TeachHeroSpell(hero, spell)
	end
end

function GiveHeroRandomArtifact(player, hero, tier, set)
	-- log(DEBUG, "$ GiveHeroRandomArtifact hero="..hero.." tier="..tier.." set="..set)
	tier = tier or 0
	set = set or 0
	local artefacts = {}
	for a,data in ARTIFACTS_DATA do
		if data.special == 0 then
			if tier == 0 or data.class == tier then
				if set == 0 or data.set == set then
					insert(artefacts, a)
				end
			end
		end
	end
	local nb = length(artefacts)
	if nb == 0 then
		return
	elseif nb == 1 then
		GiveArtifact(hero, artefacts[1])
	else
		local artefact = artefacts[random(1, nb, TURN+tier)]
		GiveArtifact(hero, artefact)
	end
end

function AddHeroCreaturePerLevel(player, hero, type, coef)
	-- log(DEBUG, "AddHeroCreaturePerLevel")
	local level = GetHeroLevel(hero)
	local nb = round(coef * level)
	if nb >= 1 then
		AddHeroCreatures(hero, type, nb)
	end
end

function AddHeroCreatureType(player, hero, faction, tier, nb, default)
	-- log(DEBUG, "$ AddHeroCreatureType")
	if nb >= 1 then
		local army = GetHeroArmy(hero)
		for i = 1,7 do
            if contains(CREATURES_BY_FACTION[faction][tier], army[i]) then
                AddHeroCreatures(hero, army[i], nb)
                return
            end
        end
		if default ~= 0 then
			AddHeroCreatures(hero, CREATURES_BY_FACTION[faction][tier][default], nb)
		end
	end
end

function CountHeroCreatureType(player, hero, faction, tier)
	-- log(DEBUG, "$ CountHeroCreatureType")
	local count = 0
	for _,cr in CREATURES_BY_FACTION[faction][tier] do
		count = count + GetHeroCreatures(hero, cr)
	end
	return count
end

function AddHeroTownRecruits(player, hero, dwelling, creature, nb)
	-- log(DEBUG, "AddHeroTownRecruits")
	local towns = GetHeroTowns(player, hero)
	if nb >= 1 then
		for i,town in towns do
			if GetTownBuildingLevel(town, dwelling) ~= 0 then
                local current = GetObjectDwellingCreatures(town, creature)
				SetObjectDwellingCreatures(town, creature, current + nb)
			end
		end
	end
end

function TransferCreatureFromTown(player, hero, dwelling, creature, coef)
	-- log(DEBUG, "$ TransferCreatureFromTown")
	local level = GetHeroLevel(hero)
	local towns = GetHeroTowns(player, hero)
	for i,town in towns do
		if GetTownBuildingLevel(town, dwelling) ~= 0 then
			local recruits = GetObjectDwellingCreatures(town, creature)
			local nb = min(trunc(coef * level), recruits)
			if nb >= 1 then
				SetObjectDwellingCreatures(town, creature, recruits-nb)
				AddHeroCreatureType(player, hero, CREATURES[creature][1], CREATURES[creature][2], nb, 1)
			end
		end
	end
end

function TransformTownRecruits(player, hero, dwelling1, creature1, dwelling2, creature2, amount)
	-- log(DEBUG, "$ TransformTownRecruits")
	local towns = GetHeroTowns(player, hero)
	for i,town in towns do
		if GetTownBuildingLevel(town, dwelling1) ~= 0 and GetTownBuildingLevel(town, dwelling2) ~= 0 then
			local recruits1 = GetObjectDwellingCreatures(town, creature1)
			local recruits2 = GetObjectDwellingCreatures(town, creature2)
			local nb = min(amount, recruits1)
			if nb >= 1 then
				SetObjectDwellingCreatures(town, creature1, recruits1 - nb)
				SetObjectDwellingCreatures(town, creature2, recruits2 + nb)
			end
		end
	end
end

function UpgradeHeroCreatures(player, hero, base, upgrade)
	-- log(DEBUG, "$ UpgradeHeroCreatures")
	local nb = GetHeroCreatures(hero, base)
	if nb >= 1 then
		RemoveHeroCreatures(hero, base, nb)
		AddHeroCreatures(hero, upgrade, nb)
	end
end

function ResurrectCreatureType(player, hero, combatIndex, faction, tier, max)
	-- log(DEBUG, "$ ResurrectCreatureType")
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

function CreatureToUndead(cr)
	if CREATURES[cr][1] == NECROPOLIS or cr == CREATURE_MUMMY or cr == CREATURE_BONE_DRAGON or cr == CREATURE_SHADOW_DRAGON or cr == CREATURE_HORROR_DRAGON then
		return cr
	end
	local tier = CREATURES[cr][2]
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
	log(DEBUG, "Random seed = "..RANDOM_SEED)
end

function LoadedGame_GameVars()
	consoleCmd('console_size 9999')
	consoleCmd('game_writelog 1')
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



function CheckEnableCheat()
	if not ENABLE_CHEAT then log(ERROR, "!!! Cheating is disabled !!!") end
	return ENABLE_CHEAT
end

function RevealMap()
	if not CheckEnableCheat() then return end
	for player = 1,8 do
		if IsHumanPlayer(player) then
			for z = 0,GetMaxFloor() do OpenCircleFog(1, 1, z, 9999, player) end
		end
	end
end
function AddAllArtifacts(hero)
	if not CheckEnableCheat() then return end
	for a = 1,199 do
		if ARTIFACTS_DATA[a].special == 0 then GiveArtifact(hero, a) end
	end
end
function Lv25(hero)
	if not CheckEnableCheat() then return end
	if not hero then hero = GetPlayerHeroes(GetCurrentPlayer())[0] end
	ChangeHeroStat(hero, STAT_EXPERIENCE, 200000)
end


-- log(TRACE, "Loaded advmap-utils.lua")
ROUTINES_LOADED[9] = 1
