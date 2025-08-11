
function NoneRoutine()
    -- log("Nothing happens !")
end



-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER MISC

function StartingBonus(player)
	log("$ StartingBonus for player "..player)
	local gold = GetPlayerResource(player, GOLD)
	local diff = mod(gold, 10000)
	if diff > 1 then -- bonus resources chosen
		log("Bonus resources chosen")
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
		log("Bonus army chosen")
	else -- bonus artifact chosen
		log("Bonus artifact chosen")
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
	else
		local spell = spells[random(1, nb, TURN-school)]
		TeachHeroSpell(hero, spell)
	end
end

function GiveHeroRandomArtifact(player, hero, tier, set)
	log("$ GiveHeroRandomArtifact hero="..hero.." tier="..tier.." set="..set)
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
	log("AddHeroCreaturePerLevel")
	local level = GetHeroLevel(hero)
	local nb = round(coef * level)
	if nb >= 1 then
		AddHeroCreatures(hero, type, nb)
	end
end

function AddHeroCreatureType(player, hero, faction, tier, nb, default)
	log("$ AddHeroCreatureType")
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
