
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- HAVEN

function Routine_DoublePeasantTax(player, hero)
    log("$ Routine_DoublePeasantTax")
    local amount = 0
    amount = amount + GetHeroCreatures(hero, CREATURE_PEASANT)
    amount = amount + GetHeroCreatures(hero, CREATURE_MILITIAMAN)
    amount = amount + GetHeroCreatures(hero, CREATURE_LANDLORD)
    AddPlayerResource(player, hero, GOLD, amount)
end

function Routine_AddHeroCavaliers(player, hero)
    log("$ Routine_AddHeroCavaliers")
    local amount = round(0.11 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, HAVEN, 6, amount, 1)
end

function Routine_ActivateArtfsetHaven(player, hero)
    log("$ Routine_ActivateArtfsetHaven")
    GiveArtifact(hero, 244, 1)
    GiveArtifact(hero, 245, 1)
end

function Routine_AddRecruitsPeasants(player, hero)
    log("$ Routine_AddRecruitsPeasants")
    local amount = trunc(4.2 * GetHeroLevel(hero))
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_PEASANT, amount)
    for _,hut in GetObjectNamesByType("BUILDING_PEASANT_HUT") do
        if GetObjectOwner(hut) == player then
            local current = GetObjectDwellingCreatures(hut, CREATURE_PEASANT)
            SetObjectDwellingCreatures(hut, CREATURE_PEASANT, current + amount)
        end
    end
end

Var_Dougal_TrainCount = 0
function Routine_EnableTrainPeasantsToArchers(player, hero)
    log("$ Routine_EnableTrainPeasantsToArchers")
    Var_Dougal_TrainCount = 0
end

function Routine_TrainPeasantsToArchersCheck(player, hero)
    log("$ Routine_TrainPeasantsToArchersCheck")
    if PLAYER_BRAIN[player] ~= HUMAN then return end
    for town,data in MAP_TOWNS do
        if data.faction == HAVEN then
            if IsHeroInTown(hero, town, 1, 0) then
                if GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_1) > 0 and GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_2) > 0 then
                    if GetTownBuildingLevel(town, TOWN_BUILDING_HAVEN_TRAINING_GROUNDS) > 0 then
                        local max = GetObjectDwellingCreatures(town, CREATURE_PEASANT)
                        local n = 7 - Var_Dougal_TrainCount
                        if GetTownBuildingLevel(town, TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES) > 0 then
                            n = n + 13
                        end
                        n = min(n, max)
                        if n > 0 then
                            QuestionBoxForPlayers(
                                GetPlayerFilter(player),
                                {"/Text/Game/Scripts/HeroSpe/TrainArchers.txt"; num=n},
                                "Routine_TrainPeasantsToArchersConfirm('"..player.."','"..hero.."','"..town.."','"..n.."')",
                                "NoneRoutine"
                            )
                        end
                    end
                end
            end
        end
    end
end

function Routine_TrainPeasantsToArchersConfirm(player, hero, town, amount)
    log("Train "..amount.." peasants to archers in town "..town)
    local peasants = GetObjectDwellingCreatures(town, CREATURE_PEASANT)
    local archers = GetObjectDwellingCreatures(town, CREATURE_ARCHER)
    SetObjectDwellingCreatures(town, CREATURE_PEASANT, peasants - amount)
    SetObjectDwellingCreatures(town, CREATURE_ARCHER, archers + amount)
    Var_Dougal_TrainCount = Var_Dougal_TrainCount + amount
end

function Routine_GainExpFromTotalGolds(player, hero)
    log("$ Routine_GainExpFromTotalGolds")
    local amount = trunc(GetPlayerResource(player, GOLD) * GetHeroLevel(hero) * 0.1)
    AddHeroStatAmount(player, hero, STAT_EXPERIENCE, amount)
end

function Routine_GainPrimaryStats(player, hero, level)
    log("$ Routine_GainPrimaryStats")
    if mod(level, 5) == 0 then
        ChangeHeroStat(hero, STAT_ATTACK, 1)
        ChangeHeroStat(hero, STAT_DEFENCE, 1)
        ChangeHeroStat(hero, STAT_SPELL_POWER, 1)
        ChangeHeroStat(hero, STAT_KNOWLEDGE, 1)
    end
end

function Routine_UpgradeMonastery(player, hero)
    log("$ Routine_UpgradeMonastery")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == HAVEN then
                UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_5)
                sleep()
                if GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_5) == 1 then
                    SetObjectDwellingCreatures(town, CREATURE_PRIEST, 0)
                end
            end
        end
    end
end

function Routine_ConvertPeasantToPriest(player, hero)
    log("$ Routine_ConvertPeasantToPriest")
    local peasant = nil
    if GetHeroCreatures(hero, CREATURE_PEASANT) > 0 then peasant = CREATURE_PEASANT
    elseif GetHeroCreatures(hero, CREATURE_MILITIAMAN) > 0 then peasant = CREATURE_MILITIAMAN
    elseif GetHeroCreatures(hero, CREATURE_LANDLORD) > 0 then peasant = CREATURE_LANDLORD
    end
    if peasant then
        RemoveHeroCreatures(hero, peasant, 1)
        AddHeroCreatureType(player, hero, HAVEN, 5, 1, 1)
    end
end

function Routine_AddTwoLuckPoints(player, hero)
    log("$ Routine_AddTwoLuckPoints")
    ChangeHeroStat(hero, STAT_LUCK, 2)
end

function Routine_MovePointsPerGriffin(player, hero)
    log("$ Routine_MovePointsPerGriffin")
    local movement = GetHeroStat(hero, STAT_MOVE_POINTS)
    local n = 0
    n = n + GetHeroCreatures(hero, CREATURE_GRIFFIN)
    n = n + GetHeroCreatures(hero, CREATURE_ROYAL_GRIFFIN)
    n = n + GetHeroCreatures(hero, CREATURE_BATTLE_GRIFFIN)
    while n > 0 do
        sleep(2)
        if not IsPlayerCurrent(player) then break end
        local m = GetHeroStat(hero, STAT_MOVE_POINTS) + 25
        if m <= movement then
            ChangeHeroStat(hero, STAT_MOVE_POINTS, 25)
            n = n - 1
        end
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- PRESERVE

Var_Kyrre_BattleWon = 0
function Routine_AddHeroExperience(player, hero)
    log("$ Routine_AddHeroExperience")
    local exp = 1000 + Var_Kyrre_BattleWon * 50 * (GetHeroLevel(hero) + 10)
    AddHeroStatAmount(player, hero, STAT_EXPERIENCE, exp)
end

function Routine_KyrreVictoryCounter(player, hero, combatIndex)
    log("$ Routine_KyrreVictoryCounter")
    Var_Kyrre_BattleWon = Var_Kyrre_BattleWon + 1
end

function Routine_HuntersWeeklyProd(player, hero, combatIndex)
    log("$ Routine_HuntersWeeklyProd")
    local base = 0.5 * GetHeroLevel(hero)
    for town,data in MAP_TOWNS do
        if data.faction == PRESERVE then
            if GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_3) ~= 0 then
                local fort = GetTownBuildingLevel(town, TOWN_BUILDING_FORT)
                local grail = GetTownBuildingLevel(town, TOWN_BUILDING_GRAIL)
                local multiplier = 1 + 0.5 * grail
                if fort > 1 then multiplier = multiplier + 0.5 * (fort-1) end
                local nb = trunc(base * multiplier)
                local current = GetObjectDwellingCreatures(town, CREATURE_WOOD_ELF)
                SetObjectDwellingCreatures(town, CREATURE_WOOD_ELF, current + nb)
            end
        end
    end
end

function Routine_AddHeroWolves(player, hero)
    log("$ Routine_AddHeroWolves")
    AddHeroCreaturePerLevel(player, hero, CREATURE_WOLF, 2.0)
end

function Routine_GiveArtifactLegendaryBoots(player, hero, level)
    log("$ Routine_GiveArtifactLegendaryBoots")
    if level == 20 then
        GiveArtifact(hero, ARTIFACT_LEGENDARY_BOOTS)
    end
end

Var_Ylthin_BattleWon = 0
function Routine_YlthinVictoryCounter(player, hero, combatIndex)
    log("$ Routine_YlthinVictoryCounter")
    Var_Ylthin_BattleWon = Var_Ylthin_BattleWon + 1
    if Var_Ylthin_BattleWon == 25 then
        GiveArtifact(hero, ARTIFACT_UNICORN_HORN_BOW, 0)
        ShowFlyingSign("/Text/Game/Scripts/HeroSpe/GainUnicornBow.txt", hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_HeroCallUnicorns(player, hero)
    log("$ Routine_HeroCallUnicorns")
    TransferCreatureFromTown(player, hero, TOWN_BUILDING_DWELLING_5, CREATURE_UNICORN, 0.75)
end

Var_Elleshar_BattleWon = 0
function Routine_ElvenSageVictory(player, hero, combatIndex)
    log("$ Routine_ElvenSageVictory")
    Var_Elleshar_BattleWon = Var_Elleshar_BattleWon + 1
    if mod(Var_Elleshar_BattleWon, 6) == 0 then
        AddHeroStatAmount(player, hero, STAT_SPELL_POWER, 1)
        AddHeroStatAmount(player, hero, STAT_KNOWLEDGE, 1)
        local upgradable = {}
        for sk = 9,12 do
            if GetHeroSkillMastery(hero, sk) < 3 then insert(upgradable, sk) end
        end
        local n = length(upgradable)
        if n > 0 then
            local sk = upgradable[random(1,n,Var_Elleshar_BattleWon)]
            GiveHeroSkill(hero, sk)
        end
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- FORTRESS

function Routine_LearnWarcries(player, hero, level)
    log("$ Routine_LearnWarcries")
    if level == 10 then
        TeachHeroSpell(hero, SPELL_WARCRY_FEAR_MY_ROAR)
        TeachHeroSpell(hero, SPELL_WARCRY_WORD_OF_THE_CHIEF)
    elseif level == 20 then
        TeachHeroSpell(hero, SPELL_WARCRY_SHOUT_OF_MANY)
        TeachHeroSpell(hero, SPELL_WARCRY_BATTLECRY)
    end
end

function Routine_AddHeroDefenders(player, hero)
    log("$ Routine_AddHeroDefenders")
    local amount = trunc(0.3 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, FORTRESS, 1, amount, 1)
end

function Routine_MovePointsPerBear(player, hero)
    log("$ Routine_MovePointsPerBear")
    local movement = GetHeroStat(hero, STAT_MOVE_POINTS)
    local n = 0
    n = n + GetHeroCreatures(hero, CREATURE_BEAR_RIDER)
    n = n + GetHeroCreatures(hero, CREATURE_BLACKBEAR_RIDER)
    n = n + GetHeroCreatures(hero, CREATURE_WHITE_BEAR_RIDER)
    while n > 0 do
        sleep(2)
        if not IsPlayerCurrent(player) then break end
        local m = GetHeroStat(hero, STAT_MOVE_POINTS) + 10
        if m <= movement then
            ChangeHeroStat(hero, STAT_MOVE_POINTS, 10)
            n = n - 1
        end
    end
end

function Routine_ReviveBearRiders(player, hero, combatIndex)
    log("$ Routine_ReviveBearRiders")
    local max = 1 + trunc(0.66 * GetHeroLevel(hero))
    ResurrectCreatureType(player, hero, combatIndex, FORTRESS, 4, max)
end

function Routine_GiveArtifactRingOfMachineAffinity(player, hero)
    log("$ Routine_GiveArtifactRingOfMachineAffinity")
    GiveArtifact(hero, ARTIFACT_RING_OF_MACHINE_AFFINITY, 1)
end

function Routine_GarnisonDwarvenWorkers(player, hero)
    log("$ Routine_GarnisonDwarvenWorkers")
    local level = GetHeroLevel(hero)
    local amount = 10 + 2 * level
    for obj,_ in RESOURCE_GENERATING_OBJECTS do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then
                AddObjectCreatures(building, CREATURE_DWARF_WORKER, amount)
            end
        end
    end
end

function Routine_ProductionIncreaseDwarvenWorkers(player, hero)
    log("$ Routine_ProductionIncreaseDwarvenWorkers")
    local total = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0}
    for obj,data in RESOURCE_GENERATING_OBJECTS do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then
                local workers = GetObjectCreatures(building, CREATURE_DWARF_WORKER)
                local bonus = trunc(data.amount * workers * 0.01)
                local res = data.type or random(0,5,workers)
                total[res] = total[res] + bonus
            end
        end
    end
    for town,data in MAP_TOWNS do
        if data.faction == FORTRESS then
            if GetObjectOwner(town) == player then
                local workers = GetObjectCreatures(town, CREATURE_DWARF_WORKER)
                total[GOLD] = total[GOLD] + workers
                if GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_6) > 0 then
                    local bonus = trunc(workers * 0.01)
                    if bonus > 0 then
                        local cur = GetObjectDwellingCreatures(town, CREATURE_THANE)
                        SetObjectDwellingCreatures(town, CREATURE_THANE, cur + bonus)
                    end
                end
            end
        end
    end
    for res,amount in total do
        AddPlayerResource(player, hero, res, amount)
    end
end

function Routine_UpgradeRunicShrine(player, hero)
    log("$ Routine_UpgradeRunicShrine")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == FORTRESS then
                UpgradeTownBuilding(town, TOWN_BUILDING_FORTRESS_RUNIC_SHRINE)
            end
        end
    end
end

function Routine_AddLuckAndMorale(player, hero)
    log("$ Routine_AddLuckAndMorale")
    ChangeHeroStat(hero, STAT_LUCK, 1)
    ChangeHeroStat(hero, STAT_MORALE, 1)
end

Var_BrandVictoryCounter = 0
function Routine_GiveArtifactBlazingSpellbook(player, hero, combatIndex)
    log("$ Routine_GiveArtifactBlazingSpellbook")
    Var_BrandVictoryCounter = Var_BrandVictoryCounter + 1
    if Var_BrandVictoryCounter == 10 then
        GiveArtifact(hero, ARTIFACT_BLAZING_SPELLBOOK)
    end
end

Var_Ebba_RunicSpells = {}
function Routine_GiveArtifactRuneOfFlame(player, hero)
    log("$ Routine_GiveArtifactRuneOfFlame")
    GiveArtifact(hero, ARTIFACT_RUNE_OF_FLAME)
    for rune,_ in RUNIC_SPELLS do
        Var_Ebba_RunicSpells[rune] = 0
    end
end

function Routine_GainSpellpowerPerRune(player, hero)
    log("$ Routine_GainSpellpowerPerRune")
    for rune,tier in RUNIC_SPELLS do
        if KnowHeroSpell(hero, rune) and Var_Ebba_RunicSpells[rune] == 0 then
            AddHeroStatAmount(player, hero, STAT_SPELL_POWER, 1)
            TeachHeroRandomSpellTier(player, hero, SPELL_SCHOOL_ANY, tier)
            Var_Ebba_RunicSpells[rune] = 1
        end
    end
end

function Routine_LearnRunicSpell(player, hero)
    log("$ Routine_LearnRunicSpell")
	local spells = {}
    for rune,_ in RUNIC_SPELLS do
        if not KnowHeroSpell(hero, rune) then insert(spells, rune) end
    end
    local nb = length(spells)
	if nb == 0 then
	elseif nb == 1 then
		TeachHeroSpell(hero, spells[1])
	else
		local spell = spells[random(1, nb, TURN)]
		TeachHeroSpell(hero, spell)
	end
    -- Routine_GainSpellpowerPerRune(player, hero)
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMY

function Routine_AddOtherHeroesGremlins(player, hero)
    log("$ Routine_AddOtherHeroesGremlins")
    local amount = GetHeroLevel(hero)
    -- local amount = round(0.50 * GetHeroLevel(hero))
    for _,h in GetPlayerHeroes(player) do
        if h ~= hero and HEROES[h].faction == ACADEMY then
            AddHeroCreatureType(player, h, ACADEMY, 1, amount, 0)
        end
    end
end

function Routine_AssembleGargoyles(player, hero)
    log("$ Routine_AssembleGargoyles")
    local max = 2 * GetHeroLevel(hero)
    local assemble_table = {
        [CREATURE_STONE_GARGOYLE] = CREATURE_IRON_GOLEM,
        [CREATURE_OBSIDIAN_GARGOYLE] = CREATURE_STEEL_GOLEM,
        [CREATURE_MARBLE_GARGOYLE] = CREATURE_OBSIDIAN_GOLEM,
    }
    for garg,golem in assemble_table do
        local nb_garg = GetHeroCreatures(hero, garg)
        if mod(nb_garg, 2) == 1 then nb_garg = nb_garg - 1 end
        if nb_garg > 0 then
            local amount = min(max, nb_garg)
            RemoveHeroCreatures(hero, garg, amount)
            AddHeroCreatures(hero, golem, 0.5 * amount)
            total = total + amount
            max = max - amount
        end
    end
    if total > 0 then
        ShowFlyingSign({"/Text/Game/Scripts/HeroSpe/AssembleGargoyles.txt"; num=total}, hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_FixDestroyedGolems(player, hero, combatIndex)
    log("$ Routine_FixDestroyedGolems")
    local total = 0
    local fix_table = {
        [CREATURE_IRON_GOLEM] = CREATURE_STONE_GARGOYLE,
        [CREATURE_STEEL_GOLEM] = CREATURE_OBSIDIAN_GARGOYLE,
        [CREATURE_OBSIDIAN_GOLEM] = CREATURE_MARBLE_GARGOYLE,
    }
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 1)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 1, i)
        if died > 0 then
            if creature == CREATURE_IRON_GOLEM or creature == CREATURE_STEEL_GOLEM or creature == CREATURE_OBSIDIAN_GOLEM then
                local rez = min(GetHeroCreatures(hero, fix_table[creature]), died)
                total = total + rez
                RemoveHeroCreatures(hero, fix_table[creature], rez)
                AddHeroCreatures(hero, creature, rez)
            end
        end
    end
    if total > 0 then
        ShowFlyingSign({"/Text/Game/Scripts/HeroSpe/AssembleGargoyles.txt"; num=total}, hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_GenerateGoldsPerDjinn(player, hero)
    log("$ Routine_GenerateGoldsPerDjinn")
    local djinns = CountHeroCreatureType(player, hero, ACADEMY, 5)
    local amount = GetHeroLevel(hero) * djinns
    AddPlayerResource(player, hero, GOLD, amount)
end

function Routine_RespawnDjinns(player, hero, combatIndex)
    log("$ Routine_RespawnDjinns")
    AddHeroCreatureType(player, hero, ACADEMY, 5, 1, 1)
    local mana = GetHeroStat(hero, STAT_MANA_POINTS)
    local djinns = CountHeroCreatureType(player, hero, ACADEMY, 5)
    local cap = trunc(0.1 * (mana + djinns))
    local rez_total = 0
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 1)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 1, i)
        if died > 0  and cap > 0 then
            if creature == CREATURE_GENIE or creature == CREATURE_MASTER_GENIE or creature == CREATURE_DJINN_VIZIER then
                local rez = min(cap, died)
                cap = cap - rez
                rez_total = rez_total + rez
                AddHeroCreatures(hero, creature, rez)
            end
        end
    end
    local cost = 10 * rez_total - djinns
    ChangeHeroStat(hero, STAT_MANA_POINTS, -cost)
end

function Routine_UpgradeSilverPavillon(player, hero)
    log("$ Routine_UpgradeSilverPavillon")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == ACADEMY then
                UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_6)
                sleep()
                if GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_6) == 1 then
                    SetObjectDwellingCreatures(town, CREATURE_RAKSHASA, 0)
                end
            end
        end
    end
end

function Routine_GainSulfurPerBattle(player, hero, combatIndex)
    log("$ Routine_GainSulfurPerBattle")
    AddPlayerResource(player, hero, SULFUR, 1)
end

function Routine_GetCraftingResources(player, hero, level)
    log("$ Routine_GetCraftingResources")
    local res = mod(level, 6)
    AddPlayerResource(player, hero, res, 1)
end

function Routine_IncreaseKnowledgeTemp(hero, obj)
    log("$ Routine_IncreaseKnowledgeTemp")
    if MAP_TOWNS[obj] and MAP_TOWNS[obj].faction == ACADEMY then
        local value = GetHeroLevel(hero)
        local x,y,z = GetObjectPosition(hero)
        ChangeHeroStat(hero, STAT_KNOWLEDGE, value)
        repeat sleep(10) until not IsEqualPosition(hero, x, y, z)
        ChangeHeroStat(hero, STAT_KNOWLEDGE, -value)
    end
end

function Routine_AddRecruitsMages(player, hero)
    log("$ Routine_AddRecruitsMages")
    if GetHeroLevel(hero) >= 20 then
        for i,town in GetHeroTowns(player, hero) do
            if GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_4) ~= 0 then
                local fort = GetTownBuildingLevel(town, TOWN_BUILDING_FORT)
                local grail = GetTownBuildingLevel(town, TOWN_BUILDING_GRAIL)
                local multiplier = 1 + 0.5 * grail
                if fort > 1 then multiplier = multiplier + 0.5 * (fort-1) end
                local nb = round(10 * multiplier)
                local current = GetObjectDwellingCreatures(town, CREATURE_MAGI)
                SetObjectDwellingCreatures(town, CREATURE_MAGI, current + nb)
            end
        end
    end
end

function Routine_AddOtherHeroesExperience(player, hero)
    log("$ Routine_AddOtherHeroesExperience")
    local exp = round(0.01 * GetHeroStat(hero, STAT_EXPERIENCE))
    for _,h in GetPlayerHeroes(player) do
        if h ~= hero then
            AddHeroStatAmount(player, h, STAT_EXPERIENCE, exp)
        end
    end
end

function Routine_GainKnowledgePerWeek(player, hero)
    log("$ Routine_GainKnowledgePerWeek")
    local amount = 1 + trunc(GetHeroLevel(hero) * 0.1)
    ChangeHeroStat(hero, STAT_KNOWLEDGE, amount)
end

function Routine_RefreshTimeShift(player, hero)
    log("$ Routine_RefreshTimeShift")
    ControlHeroCustomAbility(hero, CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED)
end

function Routine_AddHeroEaglesPerWeek(player, hero)
    log("$ Routine_AddHeroEaglesPerWeek")
    AddHeroCreaturePerLevel(player, hero, CREATURE_ARCANE_EAGLE, 0.3)
end

function Routine_AddHeroEaglePerLevel(player, hero, level)
    log("$ Routine_AddHeroEaglePerLevel")
    AddHeroCreatures(hero, CREATURE_ARCANE_EAGLE, 1)
end

function Routine_RebirthEagleToPhoenix(player, hero, combatIndex)
    log("$ Routine_RebirthEagleToPhoenix")
    
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- DUNGEON

function Routine_GenerateGoldPerScout(player, hero)
    log("$ Routine_GenerateGoldPerScout")
    local mult = trunc(GetHeroLevel(hero) * 0.2)
    if mult > 0 then
        local amount = 0
        amount = amount + GetHeroCreatures(hero, CREATURE_SCOUT)
        amount = amount + GetHeroCreatures(hero, CREATURE_ASSASSIN)
        amount = amount + GetHeroCreatures(hero, CREATURE_STALKER)
        AddPlayerResource(player, hero, GOLD, amount * mult)
    end
end

function Routine_BuildRitualPit(player, hero)
    log("$ Routine_BuildRitualPit")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == DUNGEON then
                UpgradeTownBuilding(town, TOWN_BUILDING_DUNGEON_RITUAL_PIT)
            end
        end
    end
end

function Routine_AddHeroRiders(player, hero)
    log("$ Routine_AddHeroRiders")
    local amount = round(0.12 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, DUNGEON, 4, amount, 1)
end

function Routine_GainDragonArtifacts(player, hero, combatIndex)
    log("$ Routine_GainDragonArtifacts")
    local level = GetHeroLevel(hero)
    local value = trunc(0.001 * GetArmyStrength(combatIndex, 0))
    log("---DEBUG: value = "..value)
    local rnd = random(1,100,level)
    if (2 * level + value) > rnd then
        local r = value > 20 and 1 or 0
        local i = mod(rnd, 7+r) + 1
        local a = ARTIFACT_SETS[ARTIFACT_SET_DRAGON][i]
        if not HasArtefact(hero, a, 0) then
            GiveArtifact(hero, a)
        end
    end
end

function Routine_ConvertKnowledgeToSpellpower(player, hero, level)
    log("$ Routine_ConvertKnowledgeToSpellpower")
    local diff = GetHeroStat(hero, STAT_KNOWLEDGE) - level
    if diff > 0 then
        ChangeHeroStat(hero, STAT_KNOWLEDGE, -diff)
        ChangeHeroStat(hero, STAT_SPELL_POWER, diff)
        ShowFlyingSign({"/Text/Game/Scripts/Stats/Spellpower.txt"; num=diff}, hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_AddOneLuckPoint(player, hero)
    log("$ Routine_AddOneLuckPoint")
    ChangeHeroStat(hero, STAT_LUCK, 1)
end

function Routine_ActivateArtfsetEnlightenment(player, hero)
    log("$ Routine_ActivateArtfsetEnlightenment")
    GiveArtifact(hero, 230, 1)
    GiveArtifact(hero, 231, 1)
end

function Routine_ActivateArtfsetDungeon(player, hero)
    log("$ Routine_ActivateArtfsetDungeon")
    GiveArtifact(hero, 236, 1)
    GiveArtifact(hero, 237, 1)
    TeachHeroRandomSpell(player, hero, SPELL_SCHOOL_DESTRUCT, 5)
end

Var_Sephinroth_Bonus = 0
function Routine_CheckHallOfIntrigue(player, hero)
    log("$ Routine_CheckHallOfIntrigue")
    local nb_halls = 0
    for _,town in GetHeroTowns(player, hero) do
        if GetTownBuildingLevel(town, TOWN_BUILDING_DUNGEON_HALL_OF_INTRIGUE) > 0 then
            nb_halls = nb_halls + 1
        end
    end
    local diff = nb_halls - Var_Sephinroth_Bonus
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_SPELL_POWER, 2 * diff)
        Var_Sephinroth_Bonus = nb_halls
    end
end

function Routine_AddHeroLevel(player, hero, level)
    log("$ Routine_AddHeroLevel")
    if mod(level, 6) == 0 then
        LevelUpHero(hero)
    end
end

function Routine_UpgradeToWitches(player, hero)
    log("$ Routine_UpgradeToWitches")
    local max_bloodwitch = trunc(GetHeroLevel(hero) * 1.25)
    TransformTownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_SCOUT, TOWN_BUILDING_DWELLING_2, CREATURE_WITCH, max_bloodwitch)
    local max_shadowwitch = trunc(GetHeroLevel(hero) * 0.25)
    TransformTownRecruits(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_RIDER, TOWN_BUILDING_DWELLING_5, CREATURE_MATRON, max_shadowwitch)
end

function Routine_AddHeroManticores(player, hero)
    log("$ Routine_AddHeroManticores")
    AddHeroCreaturePerLevel(player, hero, CREATURE_MANTICORE, 0.3)
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- NECROPOLIS

function Routine_GainMovePointsPerLevel(player, hero, level)
    log("$ Routine_GainMovePointsPerLevel")
    ChangeHeroStat(hero, STAT_MOVE_POINTS, 50 * level)
end

function Routine_ReviveZombies(player, hero, combatIndex)
    log("$ Routine_ReviveZombies")
    ResurrectCreatureType(player, hero, combatIndex, NECROPOLIS, 2, GetHeroLevel(hero))
end

function Routine_HeroCallVampires(player, hero)
    log("$ Routine_HeroCallVampires")
    if GetHeroLevel(hero) >= 20 then
        for i,town in GetHeroTowns(player, hero) do
            if GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_4) ~= 0 then
                local fort = GetTownBuildingLevel(town, TOWN_BUILDING_FORT)
                local grail = GetTownBuildingLevel(town, TOWN_BUILDING_GRAIL)
                local multiplier = 1 + 0.5 * grail
                if fort > 1 then multiplier = multiplier + 0.5 * (fort-1) end
                local nb = round(10 * multiplier)
                local current = GetObjectDwellingCreatures(town, CREATURE_VAMPIRE)
                SetObjectDwellingCreatures(town, CREATURE_VAMPIRE, current + nb)
            end
        end
    end
    sleep(1)
    TransferCreatureFromTown(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_VAMPIRE, 1.2)
end

function Routine_AddHeroBlackKnights(player, hero)
    log("$ Routine_AddHeroBlackKnights")
    AddHeroCreaturePerLevel(player, hero, CREATURE_BLACK_KNIGHT, 0.25)
end

function Routine_EvolveBlackKnights(player, hero, combatIndex)
    log("$ Routine_EvolveBlackKnights")
    local max = trunc(GetHeroLevel(hero) * 0.15)
    local bks = GetHeroCreatures(hero, CREATURE_BLACK_KNIGHT)
    local nb = min(bks, max)
    if nb > 0 then
        RemoveHeroCreatures(hero, CREATURE_BLACK_KNIGHT, nb)
        AddHeroCreatures(hero, CREATURE_DEATH_KNIGHT, nb)
        ShowFlyingSign({"/Text/Game/Scripts/Evolve.txt"; num=nb}, hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_AddRecruitsNecropolis(player, hero)
    log("$ Routine_AddRecruitsNecropolis")
    local amount1 = trunc(2.5 * GetHeroLevel(hero))
    local amount2 = trunc(1.3 * GetHeroLevel(hero))
    local amount3 = trunc(0.5 * GetHeroLevel(hero))
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_SKELETON, amount1)
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_2, CREATURE_WALKING_DEAD, amount2)
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_3, CREATURE_MANES, amount3)
end

function Routine_AddHeroMummies(player, hero)
    log("$ Routine_AddHeroMummies")
    AddHeroCreaturePerLevel(player, hero, CREATURE_MUMMY, 0.3)
end

function Routine_AddHeroBanshees(player, hero)
    log("$ Routine_AddHeroBanshees")
	local nb = round(0.06 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, NECROPOLIS, 7, nb, 1)
end

function Routine_BuildDragonTombstone(player, hero)
    log("$ Routine_BuildDragonTombstone")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == NECROPOLIS then
                UpgradeTownBuilding(town, TOWN_BUILDING_NECROMANCY_DRAGON_TOMBSTONE)
            end
        end
    end
end

function Routine_GiveSandrosCloak(player, hero)
    log("$ Routine_GiveSandrosCloak")
    GiveArtifact(hero, ARTIFACT_SANDROS_CLOAK, 1)
end

function Routine_AddLichesPerKnowledge(player, hero)
    log("$ Routine_AddLichesPerKnowledge")
    local nb = trunc(0.25 * GetHeroStat(hero, STAT_KNOWLEDGE))
    AddHeroCreatureType(player, hero, NECROPOLIS, 5, nb, 1)
end

Var_Ornella_BattleWon = 0
function Routine_FrostLordArtifacts(player, hero, combatIndex)
    log("$ Routine_FrostLordArtifacts")
    Var_Ornella_BattleWon = Var_Ornella_BattleWon + 1
    if Var_Ornella_BattleWon == 7 then
        GiveArtifact(hero, ARTIFACT_EVERCOLD_ICICLE)
    elseif Var_Ornella_BattleWon == 15 then
        GiveArtifact(hero, ARTIFACT_FROZEN_HEART)
    elseif Var_Ornella_BattleWon == 20 then
        GiveArtifact(hero, ARTIFACT_SHIELD_OF_CRYSTAL_ICE)
    elseif Var_Ornella_BattleWon == 30 then
        GiveArtifact(hero, ARTIFACT_CROWN_OF_THE_FROST_LORD)
    elseif Var_Ornella_BattleWon == 35 then
        GiveArtifact(hero, ARTIFACT_SPEAR_OF_THE_FROST_LORD)
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- INFERNO

function Routine_NightmareWeeklyProd(player, hero)
    log("$ Routine_NightmareWeeklyProd")
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_5, CREATURE_NIGHTMARE, 1)
end

function Routine_AddHeroHellHounds(player, hero)
    log("$ Routine_AddHeroHellHounds")
    local amount = round(0.90 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, INFERNO, 3, amount, 1)
end

function Routine_RestoreManaAfterBattle(player, hero, combatIndex)
    log("$ Routine_RestoreManaAfterBattle")
    ChangeHeroStat(hero, STAT_MANA_POINTS, GetHeroLevel(hero))
end

function Routine_GainAttackPerLevel(player, hero, level)
    log("$ Routine_GainAttackPerLevel")
    if mod(level, 5) == 0 then
        AddHeroStatAmount(player, hero, STAT_ATTACK, 1)
    end
end

Var_AgraelVictoryCounter = 0
function Routine_AgraelVictoryCounter(player, hero, combatIndex)
    log("$ Routine_AgraelVictoryCounter")
    Var_AgraelVictoryCounter = Var_AgraelVictoryCounter + 1
    if Var_AgraelVictoryCounter == 25 then
        for _,h in GetPlayerHeroes(player) do
            TeachHeroSpell(h, SPELL_ARMAGEDDON)
        end
    end
end

function Routine_ActivateArtfsetHunter(player, hero)
    log("$ Routine_ActivateArtfsetHunter")
    GiveArtifact(hero, 232, 1)
    GiveArtifact(hero, 233, 1)
end

function Routine_AddHeroSuccubus(player, hero)
    log("$ Routine_AddHeroSuccubus")
    AddHeroCreatureType(player, hero, INFERNO, 4, GetHeroLevel(hero), 1)
end

function Routine_GainBonusExpAndRes(player, hero, combatIndex)
    log("$ Routine_GainBonusExpAndRes")
    local total = 0
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 0)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 0, i)
        local tier = CREATURES[creature][2]
        local value = 2*tier + power(2, tier)
        total = total + count * value
    end
    AddHeroStatAmount(player, hero, STAT_EXPERIENCE, trunc(1.2*total))
    AddPlayerResource(player, hero, GOLD, trunc(0.8*total))
end

function Routine_TownBuildingUp(player, hero)
    log("$ Routine_TownBuildingUp")
    if PLAYER_BRAIN[player] ~= HUMAN then return end
    for town,data in MAP_TOWNS do
        if data.faction == INFERNO then
            if IsHeroInTown(hero, town, 1, 0) then
                local buildings = {
                    [TOWN_BUILDING_MARKETPLACE] = {500, 4500},
                    [TOWN_BUILDING_DWELLING_1] = {1500, 3500},
                    [TOWN_BUILDING_DWELLING_2] = {2250, 5250},
                    [TOWN_BUILDING_DWELLING_3] = {3000, 7000},
                    [TOWN_BUILDING_DWELLING_4] = {4500, 10500},
                    [TOWN_BUILDING_DWELLING_5] = {6500, 14500},
                    [TOWN_BUILDING_DWELLING_6] = {10000, 20000},
                    [TOWN_BUILDING_DWELLING_7] = {17500, 32500},
                    [TOWN_BUILDING_INFERNO_INFERNAL_LOOM] = {3000},
                }
                local name_root = "/Text/Game/TownBuildings/Inferno/"
                local name_file = {
                    [TOWN_BUILDING_MARKETPLACE] = {"Marketplace/Name.txt", "Marketplace/Resource_Silo_Name.txt"},
                    [TOWN_BUILDING_DWELLING_1] = {"Dwelling_1/Name.txt", "Dwelling_1/Upgraded_Name.txt"},
                    [TOWN_BUILDING_DWELLING_2] = {"Dwelling_2/Name.txt", "Dwelling_2/Upgraded_Name.txt"},
                    [TOWN_BUILDING_DWELLING_3] = {"Dwelling_3/Name.txt", "Dwelling_3/Upgraded_Name.txt"},
                    [TOWN_BUILDING_DWELLING_4] = {"Dwelling_4/Name.txt", "Dwelling_4/Upgraded_Name.txt"},
                    [TOWN_BUILDING_DWELLING_5] = {"Dwelling_5/Name.txt", "Dwelling_5/Upgraded_Name.txt"},
                    [TOWN_BUILDING_DWELLING_6] = {"Dwelling_6/Name.txt", "Dwelling_6/Upgraded_Name.txt"},
                    [TOWN_BUILDING_DWELLING_7] = {"Dwelling_7/Name.txt", "Dwelling_7/Upgraded_Name.txt"},
                    [TOWN_BUILDING_INFERNO_INFERNAL_LOOM] = {"Special_1/Name.txt"},
                    [TOWN_BUILDING_INFERNO_SACRIFICIAL_PIT] = {"Special_5/Name.txt"},
                }
                for k,v in buildings do
                    local cur = GetTownBuildingLevel(town, k)
                    if cur < length(v) then
                        local cost = v[cur+1]
                        if (750 * GetHeroLevel(hero) >= cost) and (GetPlayerResource(player, GOLD) >= cost) then
                            local name = name_root..name_file[k][cur+1]
                            QuestionBoxForPlayers(
                                GetPlayerFilter(player),
                                {"/Text/Game/Scripts/HeroSpe/TownBuildingUp.txt"; building=name, golds=cost},
                                "Routine_TownBuildingUpConfirm('"..player.."','"..hero.."','"..town.."','"..k.."','"..cost.."')",
                                "NoneRoutine"
                            )
                            break
                        end
                    end
                end
            end
        end
    end
end

function Routine_TownBuildingUpConfirm(player, hero, town, building, cost)
    UpgradeTownBuilding(town, building)
    RemovePlayerResource(player, GOLD, 0+cost)
    ChangeHeroStat(hero, STAT_MOVE_POINTS, -500)
end

function Routine_GenerateSulfur(player, hero)
    log("$ Routine_GenerateSulfur")
    local amount = trunc(0.2 * GetHeroLevel(hero))
    AddPlayerResource(player, hero, SULFUR, amount)
end

function Routine_MultiplyTroops(player, hero)
    log("$ Routine_MultiplyTroops")
    local level = GetHeroLevel(hero)
    local percent = 1 + trunc(0.13 * level)
    local maxtier = 1 + trunc(0.22 * level)
    local tracker = {}
    for i,cr in GetHeroArmy(hero) do
        if cr and cr ~= 0 then
            if not tracker[cr] then
                local faction = CREATURES[cr][1]
                local tier = CREATURES[cr][2]
                if faction == INFERNO and tier <= maxtier then
                    local nb = GetHeroCreatures(cr)
                    local add = trunc(0.01 * percent * nb)
                    AddHeroCreatures(hero, cr, add)
                    tracker[cr] = 1
                end
            end
        end
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- STRONGHOLD

function Routine_GainArmyReinforcement(player, hero, combatIndex)
    log("$ Routine_GainArmyReinforcement")
    local mem_tiers = {}
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 1)
    for i = 0,stacks-1 do
        local creature, _, _ = GetSavedCombatArmyCreatureInfo(combatIndex, 1, i)
        if CREATURES[creature][1] == STRONGHOLD then
            local tier = CREATURES[creature][2]
            if not mem_tiers[tier] and tier ~= 6 then
                local div = tier * (tier + 1)
                local nb = trunc(1.5 * GetHeroLevel(hero) / div)
                AddHeroCreatures(hero, creature, nb)
                mem_tiers[tier] = 1
            end
        end
    end
end

function Routine_GiveArtifactCentaurCrossbow(player, hero)
    log("$ Routine_GiveArtifactCentaurCrossbow")
    GiveArtifact(hero, ARTIFACT_CENTAUR_CROSSBOW)
end

function Routine_AddRecruitsCentaurs(player, hero)
    log("$ Routine_AddRecruitsCentaurs")
    for i,town in GetHeroTowns(player, hero) do
        if GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_4) ~= 0 then
            local fort = GetTownBuildingLevel(town, TOWN_BUILDING_FORT)
            local grail = GetTownBuildingLevel(town, TOWN_BUILDING_GRAIL)
            local multiplier = 1 + 0.5 * grail
            if fort > 1 then multiplier = multiplier + 0.5 * (fort-1) end
            local nb = round(2 * multiplier)
            local current = GetObjectDwellingCreatures(town, CREATURE_CENTAUR)
            SetObjectDwellingCreatures(town, CREATURE_CENTAUR, current + nb)
        end
    end
end

Var_Gorshak_BattleWon = 0
function Routine_GainAttackDefense(player, hero, combatIndex)
    log("$ Routine_GainAttackDefense")
    Var_Gorshak_BattleWon = Var_Gorshak_BattleWon + 1
    if mod(Var_Gorshak_BattleWon, 10) == 0 then
        AddHeroStatAmount(player, hero, STAT_ATTACK, 1)
        AddHeroStatAmount(player, hero, STAT_DEFENCE, 1)
    end
end

function Routine_UpgradeChamberOfWrath(player, hero)
    log("$ Routine_UpgradeChamberOfWrath")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == STRONGHOLD then
                UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_5)
                sleep()
                if GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_5) == 1 then
                    SetObjectDwellingCreatures(town, CREATURE_ORCCHIEF_BUTCHER, 0)
                end
            end
        end
    end
end

function Routine_AddHeroWyverns(player, hero)
    log("$ Routine_AddHeroWyverns")
    local amount = round(0.22 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, STRONGHOLD, 6, amount, 1)
end

function Routine_ActivateArtfsetNecro(player, hero)
    log("$ Routine_ActivateArtfsetNecro")
    GiveArtifact(hero, 251, 1)
    GiveArtifact(hero, 252, 1)
end

function Routine_ActivateArtfsetSarIssus(player, hero)
    log("$ Routine_ActivateArtfsetSarIssus")
    GiveArtifact(hero, 247, 1)
    GiveArtifact(hero, 248, 1)
end

function Routine_SacrificeGoblinDaily(player, hero)
    log("$ Routine_SacrificeGoblinDaily")
    for _,goblin in CREATURES_BY_FACTION[STRONGHOLD][1] do
        if GetHeroCreatures(hero, goblin) > 0 then
            RemoveHeroCreatures(hero, goblin, 1)
            AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_2, CREATURE_SHAMAN, 1)
            if GetHeroLevel(hero) >= 10 then AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_3, CREATURE_ORC_WARRIOR, 1) end
            return
        end
    end
end





START_TRIGGER_HERO_ROUTINES = {
    -- haven
    [H_LASZLO] = Routine_ActivateArtfsetHaven,
    [H_ISABEL] = Routine_AddTwoLuckPoints,
    [H_ALARIC] = Routine_UpgradeMonastery,
    -- preserve
    -- fortress
    [H_WULFSTAN] = Routine_GiveArtifactRingOfMachineAffinity,
    [H_TOLGHAR] = Routine_AddLuckAndMorale,
    [H_ERLING] = Routine_UpgradeRunicShrine,
    [H_EBBA] = Routine_GiveArtifactRuneOfFlame,
    -- academy
    [H_DAVIUS] = Routine_UpgradeSilverPavillon,
    [H_RISSA] = Routine_RefreshTimeShift,
    -- dungeon
    [H_YRWANNA] = Routine_BuildRitualPit,
    [H_ERUINA] = Routine_AddOneLuckPoint,
    [H_RANLETH] = Routine_ActivateArtfsetEnlightenment,
    [H_SEPHINROTH] = Routine_ActivateArtfsetDungeon,
    -- necropolis
    [H_ARCHILUS] = Routine_BuildDragonTombstone,
    [H_SANDRO] = Routine_GiveSandrosCloak,
    -- inferno
    [H_BIARA] = Routine_ActivateArtfsetHunter,
    -- stronghold
    [H_GARUNA] = Routine_GiveArtifactCentaurCrossbow,
    [H_GORSHAK] = Routine_UpgradeChamberOfWrath,
    [H_URGHAT] = Routine_ActivateArtfsetNecro,
    [H_KUJIN] = Routine_ActivateArtfsetSarIssus,
}

DAILY_TRIGGER_HERO_ROUTINES = {
    -- haven
    [H_DOUGAL] = Routine_TrainPeasantsToArchersCheck,
    [H_MAEVE] = Routine_DoublePeasantTax,
    [H_GABRIELLE] = Routine_MovePointsPerGriffin,
    -- preserve
    -- fortress
    [H_INGVAR] = Routine_AddHeroDefenders,
    [H_ROLF] = Routine_MovePointsPerBear,
    [H_HANGVUL] = Routine_ProductionIncreaseDwarvenWorkers,
    [H_EBBA] = Routine_GainSpellpowerPerRune,
    -- academy
    [H_HAVEZ] = Routine_AddOtherHeroesGremlins,
    [H_MAAHIR] = Routine_AddOtherHeroesExperience,
    [H_GALIB] = Routine_GenerateGoldsPerDjinn,
    [H_RISSA] = Routine_RefreshTimeShift,
    -- dungeon
    [H_VAYSHAN] = Routine_GenerateGoldPerScout,
    [H_SORGAL] = Routine_AddHeroRiders,
    [H_SEPHINROTH] = Routine_CheckHallOfIntrigue,
    -- necropolis
    [H_THANT] = Routine_AddHeroMummies,
    -- inferno
    [H_ORLANDO] = Routine_TownBuildingUp,
    [H_DELEB] = Routine_GenerateSulfur,
    [H_KHABELETH] = Routine_MultiplyTroops,
    -- stronghold
}

WEEKLY_TRIGGER_HERO_ROUTINES = {
    -- haven
    [H_DOUGAL] = Routine_EnableTrainPeasantsToArchers,
    [H_MAEVE] = Routine_AddRecruitsPeasants,
    [H_KLAUS] = Routine_AddHeroCavaliers,
    [H_NICOLAI] = Routine_GainExpFromTotalGolds,
    -- preserve
    [H_KYRRE] = Routine_AddHeroExperience,
    [H_FINDAN] = Routine_HuntersWeeklyProd,
    [H_IVOR] = Routine_AddHeroWolves,
    [H_YLTHIN] = Routine_HeroCallUnicorns,
    -- fortress
    [H_HANGVUL] = Routine_GarnisonDwarvenWorkers,
    [H_EBBA] = Routine_LearnRunicSpell,
    -- academy
    [H_RAZZAK] = Routine_AssembleGargoyles,
    [H_CYRUS] = Routine_AddRecruitsMages,
    [H_MAAHIR] = Routine_GainKnowledgePerWeek,
    [H_MINASLI] = Routine_AddHeroEaglesPerWeek,
    -- dungeon
    [H_SHADYA] = Routine_UpgradeToWitches,
    [H_LETHOS] = Routine_AddHeroManticores,
    -- necropolis
    [H_LUCRETIA] = Routine_HeroCallVampires,
    [H_RAVEN] = Routine_AddRecruitsNecropolis,
    [H_XERXON] = Routine_AddHeroBlackKnights,
    [H_DEIRDRE] = Routine_AddHeroBanshees,
    -- inferno
    [H_GROK] = Routine_NightmareWeeklyProd,
    [H_GRAWL] = Routine_AddHeroHellHounds,
    -- stronghold
    [H_GARUNA] = Routine_AddRecruitsCentaurs,
    [H_KARUKAT] = Routine_AddHeroWyverns,
    [H_KUJIN] = Routine_SacrificeGoblinDaily,
}

LEVEL_UP_HERO_ROUTINES_HERO = {
    -- haven
    [H_NICOLAI] = Routine_GainPrimaryStats,
    -- preserve
    [H_VINRAEL] = Routine_GiveArtifactLegendaryBoots,
    -- fortress
    [H_TAZAR] = Routine_LearnWarcries,
    -- academy
    [H_THEODORUS] = Routine_GetCraftingResources,
    [H_MINASLI] = Routine_AddHeroEaglePerLevel,
    -- dungeon
    [H_SINITAR] = Routine_ConvertKnowledgeToSpellpower,
    [H_SHADYA] = Routine_AddHeroLevel,
    -- necropolis
    [H_VLADIMIR] = Routine_GainMovePointsPerLevel,
    [H_SANDRO] = Routine_AddLichesPerKnowledge,
    -- inferno
    [H_ASH] = Routine_GainAttackPerLevel,
    [H_BIARA] = Routine_AddHeroSuccubus,
    -- stronghold
}

AFTER_COMBAT_TRIGGER_HERO_ROUTINES = {
    -- haven
    [H_ALARIC] = Routine_ConvertPeasantToPriest,
    -- preserve
    [H_KYRRE] = Routine_KyrreVictoryCounter,
    [H_ELLESHAR] = Routine_ElvenSageVictory,
    [H_YLTHIN] = Routine_YlthinVictoryCounter,
    -- fortress
    [H_ROLF] = Routine_ReviveBearRiders,
    [H_BRAND] = Routine_GiveArtifactBlazingSpellbook,
    -- academy
    [H_RAZZAK] = Routine_FixDestroyedGolems,
    [H_NATHIR] = Routine_GainSulfurPerBattle,
    [H_GALIB] = Routine_RespawnDjinns,
    [H_MINASLI] = Routine_RebirthEagleToPhoenix,
    -- dungeon
    [H_RAELAG] = Routine_GainDragonArtifacts,
    -- necropolis
    [H_ORSON] = Routine_ReviveZombies,
    [H_XERXON] = Routine_EvolveBlackKnights,
    [H_ORNELLA] = Routine_FrostLordArtifacts,
    -- inferno
    [H_SHELTEM] = Routine_RestoreManaAfterBattle,
    [H_AGRAEL] = Routine_AgraelVictoryCounter,
    [H_ORLANDO] = Routine_GainBonusExpAndRes,
    -- stronghold
    [H_KRAGH] = Routine_GainArmyReinforcement,
    [H_GORSHAK] = Routine_GainAttackDefense,
}


function DoHeroSpeRoutine_Start(player, hero)
    log("$ DoHeroSpeRoutine_Start - "..hero)
    if START_TRIGGER_HERO_ROUTINES[hero] then
        startThread(START_TRIGGER_HERO_ROUTINES[hero], player, hero)
    end
end

function DoHeroSpeRoutine_Daily(player, hero)
    log("$ DoHeroSpeRoutine_Daily - "..hero)
    if DAILY_TRIGGER_HERO_ROUTINES[hero] then
        startThread(DAILY_TRIGGER_HERO_ROUTINES[hero], player, hero)
    end
end

function DoHeroSpeRoutine_Weekly(player, hero)
    log("$ DoHeroSpeRoutine_Weekly - "..hero)
    if WEEKLY_TRIGGER_HERO_ROUTINES[hero] then
        startThread(WEEKLY_TRIGGER_HERO_ROUTINES[hero], player, hero)
    end
end

function DoHeroSpeRoutine_LevelUp(player, hero, level)
    log("$ DoHeroSpeRoutine_LevelUp - "..hero)
    if LEVEL_UP_HERO_ROUTINES_HERO[hero] then
        startThread(LEVEL_UP_HERO_ROUTINES_HERO[hero], player, hero, level)
    end
end

function DoHeroSpeRoutine_AfterCombat(player, hero, index)
    log("$ DoHeroSpeRoutine_AfterCombat - "..hero)
    if AFTER_COMBAT_TRIGGER_HERO_ROUTINES[hero] then
        startThread(AFTER_COMBAT_TRIGGER_HERO_ROUTINES[hero], player, hero, index)
    end
end


-- log("Loaded heroes-routines-advmap.lua")
ROUTINES_LOADED[13] = 1
