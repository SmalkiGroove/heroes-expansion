
function DoCommonRoutine_Start(player, hero) end
function DoCommonRoutine_Daily(player, hero) end
function DoCommonRoutine_Weekly(player, hero) end
function DoCommonRoutine_LevelUp(player, hero, level) end
function DoCommonRoutine_AfterCombat(player, hero, index) end

function NoneRoutine()
    -- print("Nothing happens !")
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


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

function AddHero_StatPerLevel(player, hero, stat, coef)
	print("$ AddHero_StatPerLevel")
	local level = GetHeroLevel(hero)
	local amount = trunc(coef * level)
	if amount ~= 0 then
		ChangeHeroStat(hero, stat, amount)
		ShowFlyingSign({"/Text/Game/Scripts/Stats/"..ATTRIBUTE_TEXT[stat]..".txt"; num=amount}, hero, player, FLYING_SIGN_TIME)
	end
end

function AddHero_StatPercent(player, hero, stat, coef)
	print("$ AddHero_StatPercent")
	local current = GetHeroStat(hero, stat)
	local amount = round(coef * current)
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

function AddHero_CreatureTypesPercent(player, hero, types, coef)
	print("$ AddHero_CreatureTypesPercent")
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

function ChangeHero_CreatureFusion(player, hero, base, consume, upgrade, coef)
	print("$ ChangeHero_CreatureFusion")
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
	print("$ ChangeHero_CreatureTransform")
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
