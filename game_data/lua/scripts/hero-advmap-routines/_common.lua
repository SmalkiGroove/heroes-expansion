
function DoCommonRoutine_Start(player, hero) end
function DoCommonRoutine_Daily(player, hero) end
function DoCommonRoutine_Weekly(player, hero) end
function DoCommonRoutine_AfterCombat(player, hero, index) end
function DoCommonRoutine_LevelUp(hero) end

function NoneRoutine()
    -- print("Nothing happens !")
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


function AddPlayer_Resource(player, hero, resource, amount)
	-- print("Adding resources from hero "..hero)
	if amount >= 1 then
		local curamount = GetPlayerResource(player, resource)
		local newamount = curamount + amount
		SetPlayerResource(player, resource, newamount)
		ShowFlyingSign({"/Text/Game/Scripts/Resources/"..RESOURCE_TEXT[resource]..".txt"; num=amount}, hero, player, FLYING_SIGN_TIME)
	end
end

function TakePlayer_Resource(player, resource, amount)
	if amount >= 1 then
		local curamount = GetPlayerResource(player, resource)
		local newamount = curamount - amount
		SetPlayerResource(player, resource, newamount)
	end
end

function AddHero_StatAmount(player, hero, stat, amount)
    if amount >= 1 then
		ChangeHeroStat(hero, stat, amount)
		ShowFlyingSign({"/Text/Game/Scripts/Stats/"..ATTRIBUTE_TEXT[stat]..".txt"; num=amount}, hero, player, FLYING_SIGN_TIME)
	end
end

function AddHero_StatPerLevel(player, hero, stat, coef)
	-- print("Adding statistics to hero "..hero)
	local level = GetHeroLevel(hero)
	local amount = trunc(coef * level)
	if amount >= 1 then
		ChangeHeroStat(hero, stat, amount)
		ShowFlyingSign({"/Text/Game/Scripts/Stats/"..ATTRIBUTE_TEXT[stat]..".txt"; num=amount}, hero, player, FLYING_SIGN_TIME)
	end
end

function AddHero_StatPercent(player, hero, stat, coef)
	-- print("Adding statistics to hero "..hero)
	local current = GetHeroStat(hero, stat)
	local amount = round(coef * current)
	if amount >= 1 then
		ChangeHeroStat(hero, stat, amount)
		ShowFlyingSign({"/Text/Game/Scripts/Stats/"..ATTRIBUTE_TEXT[stat]..".txt"; num=amount}, hero, player, FLYING_SIGN_TIME)
	end
end

function AddHero_RandomSpell(hero, type, tier)
	-- print("Adding random spell to hero "..hero)
	local spells = {}
	if type == SPELL_TYPE_DESTRUCTIVE_MAGIC then
		if tier >= 1 then insert(spells, SPELL_MAGIC_ARROW); insert(spells, SPELL_STONE_SPIKES) end
		if tier >= 2 then insert(spells, SPELL_LIGHTNING_BOLT); insert(spells, SPELL_ICE_BOLT) end
		if tier >= 3 then insert(spells, SPELL_FIREBALL); insert(spells, SPELL_FROST_RING) end
		if tier >= 4 then insert(spells, SPELL_CHAIN_LIGHTNING); insert(spells, SPELL_METEOR_SHOWER); insert(spells, SPELL_DEEP_FREEZE) end
		if tier >= 5 then insert(spells, SPELL_IMPLOSION); insert(spells, SPELL_ARMAGEDDON) end
	elseif type == SPELL_TYPE_DARK_MAGIC then
		if tier >= 1 then insert(spells, SPELL_CURSE); insert(spells, SPELL_SLOW); insert(spells, SPELL_SORROW) end
		if tier >= 2 then insert(spells, SPELL_DISRUPTING_RAY); insert(spells, SPELL_PLAGUE) end
		if tier >= 3 then insert(spells, SPELL_FORGETFULNESS); insert(spells, SPELL_WEAKNESS); insert(spells, SPELL_BLIND) end
		if tier >= 4 then insert(spells, SPELL_BERSERK); insert(spells, SPELL_VAMPIRISM) end
		if tier >= 5 then insert(spells, SPELL_HYPNOTIZE); insert(spells, SPELL_UNHOLY_WORD) end
	elseif type == SPELL_TYPE_LIGHT_MAGIC then
		if tier >= 1 then insert(spells, SPELL_BLESS); insert(spells, SPELL_HASTE) end
		if tier >= 2 then insert(spells, SPELL_STONESKIN); insert(spells, SPELL_DISPEL) end
		if tier >= 3 then insert(spells, SPELL_BLOODLUST); insert(spells, SPELL_REGENERATION); insert(spells, SPELL_DEFLECT_ARROWS) end
		if tier >= 4 then insert(spells, SPELL_DIVINE_VENGEANCE); insert(spells, SPELL_TELEPORT); insert(spells, SPELL_ANTI_MAGIC) end
		if tier >= 5 then insert(spells, SPELL_RESURRECT); insert(spells, SPELL_HOLY_WORD) end
	elseif type == SPELL_TYPE_SUMMONING_MAGIC then
		if tier >= 1 then insert(spells, SPELL_MAGIC_FIST); insert(spells, SPELL_ARCANE_CRYSTAL) end
		if tier >= 2 then insert(spells, SPELL_LAND_MINE); insert(spells, SPELL_WASP_SWARM); insert(spells, SPELL_EARTHQUAKE) end
		if tier >= 3 then insert(spells, SPELL_BLADE_BARRIER); insert(spells, SPELL_ANIMATE_DEAD); insert(spells, SPELL_SUMMON_ELEMENTALS) end
		if tier >= 4 then insert(spells, SPELL_SUMMON_HIVE); insert(spells, SPELL_PHANTOM); insert(spells, SPELL_FIREWALL) end
		if tier >= 5 then insert(spells, SPELL_CELESTIAL_SHIELD); insert(spells, SPELL_CONJURE_PHOENIX) end
	end
	local nb = length(spells)
	local spell = spells[random(0, nb-1, type)]
	if KnowHeroSpell(hero, spell) then spell = spells[random(0, nb-1, type)] end
	TeachHeroSpell(hero, spell)
end

function AddHero_CreatureType(player, hero, type, coef)
	-- print("Add specific creature to hero "..hero)
	local level = GetHeroLevel(hero)
	local nb = round(coef * level)
	if nb >= 1 then
		AddHeroCreatures(hero, type, nb)
		ShowFlyingSign({"/Text/Game/Scripts/Reinforcements.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
	end
end

function AddHero_CreatureInTypes(player, hero, types, coef)
	-- print("Add creatures to hero "..hero)
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
		AddHeroCreatures(hero, types[0], nb)
		ShowFlyingSign({"/Text/Game/Scripts/Reinforcements.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
	end
end

function AddHero_CreatureTypesPercent(player, hero, types, coef)
	-- print("Multiply army size for hero "..hero)
	local level = GetHeroLevel(hero)
	local army = GetHeroArmy(hero)
	local total = 0
	for i = 1,7 do
        local cr = army[i]
        if contains(types, cr) then
            local nb = trunc(GetHeroCreatures(hero, cr) * level * coef)
            if nb >= 1 then
                AddHeroCreatures(hero, cr, nb)
                total = total + nb
            end
        end
	end
	ShowFlyingSign({"/Text/Game/Scripts/Reinforcements.txt"; num=total}, hero, player, FLYING_SIGN_TIME)
end

function AddHero_TownRecruits(player, hero, dwelling, creature, coef)
	-- print("Adding recruits from hero "..hero)
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
	-- print("Call creatures from towns to hero "..hero)
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
	-- print("Upgrade recuits from hero "..hero)
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
	local nb = GetHeroCreatures(hero, base)
	RemoveHeroCreatures(hero, base, nb)
	AddHeroCreatures(hero, upgrade, nb)
	ShowFlyingSign({"/Text/Game/Scripts/Evolve.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
end

function ChangeHero_CreatureFusion(player, hero, base, consume, upgrade, coef)
	local nb_base = GetHeroCreatures(hero,base)
	local nb_consume = GetHeroCreatures(hero,consume)
	if nb_consume >= coef then
		local nb = trunc(nb_consume / coef)
		nb = min(nb, nb_base)
		RemoveHeroCreatures(hero, consume, coef * nb)
		RemoveHeroCreatures(hero, base, nb)
		AddHeroCreatures(hero, upgrade, nb)
		ShowFlyingSign({"/Text/Game/Scripts/Evolve.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
	end
end

function ChangeHero_CreatureTransform(player, hero, array)
	local army = GetHeroArmy(hero)
	for i = 1,7 do
        local cr = army[i]
		if cr and cr ~= 0 then
			local type = array[cr]
			if type ~= 0 then
				-- print("transform unit "..cr.." into unit "..type)
				local nb = GetHeroCreatures(hero, cr)
				RemoveHeroCreatures(hero, cr, nb)
				AddHeroCreatures(hero, type, nb)
			end
		end
	end
end

-- print("Loaded common advmap routines")
ROUTINES_LOADED[0] = 1
