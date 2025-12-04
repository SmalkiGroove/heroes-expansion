
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- HAVEN

function Routine_BuildAndRevealStables(player, hero)
    log(DEBUG, "$ Routine_BuildAndRevealStables")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == HAVEN then
                local stables = GetTownBuildingLevel(town, TOWN_BUILDING_HAVEN_STABLE)
                if stables == 0 then
                    UpgradeTownBuilding(town, TOWN_BUILDING_HAVEN_STABLE)
                else
                    AddHeroCreatureType(player, hero, HAVEN, 6, 1, 1)
                end
            end
        end
    end
    for _,obj in GetObjectNamesByType("BUILDING_STABLES") do
        local x,y,z = GetObjectPosition(obj)
        OpenCircleFog(x, y, z, 5, player)
    end
end

function Routine_AddRecruitsPeasants(player, hero)
    log(DEBUG, "$ Routine_AddRecruitsPeasants")
    local amount = trunc(4.2 * GetHeroLevel(hero))
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_PEASANT, amount)
    for _,hut in GetObjectNamesByType("BUILDING_PEASANT_HUT") do
        if GetObjectOwner(hut) == player then
            local current = GetObjectDwellingCreatures(hut, CREATURE_PEASANT)
            SetObjectDwellingCreatures(hut, CREATURE_PEASANT, current + amount)
        end
    end
end

function Routine_PeasantTaxLevel(player, hero, level)
    log(DEBUG, "$ Routine_PeasantTaxLevel")
    local amount = 0
    amount = amount + GetHeroCreatures(hero, CREATURE_PEASANT)
    amount = amount + GetHeroCreatures(hero, CREATURE_MILITIAMAN)
    amount = amount + GetHeroCreatures(hero, CREATURE_LANDLORD)
    GiveResources(player, GOLD, amount, 1)
end

Var_Dougal_TrainCount = 0
function Routine_EnableTrainPeasantsToArchers(player, hero)
    log(DEBUG, "$ Routine_EnableTrainPeasantsToArchers")
    Var_Dougal_TrainCount = 0
end

Var_Dougal_TrainPeasantLock = 0
function Routine_TrainPeasantsToArchers(hero, town)
    log(DEBUG, "$ Routine_TrainPeasantsToArchers")
    if MAP_TOWNS[town] and MAP_TOWNS[town].faction == HAVEN then
        if GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_1) > 0 and GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_2) > 0 then
            if GetTownBuildingLevel(town, TOWN_BUILDING_HAVEN_TRAINING_GROUNDS) > 0 then
                local peasants = GetHeroCreatures(hero, CREATURE_PEASANT)
                local n = 7 - Var_Dougal_TrainCount
                if GetTownBuildingLevel(town, TOWN_BUILDING_HAVEN_MONUMENT_TO_FALLEN_HEROES) > 0 then n = n + 13 end
                n = min(n, peasants)
                if n > 0 then
                    Var_Dougal_TrainPeasantLock = 1
                    local player = GetObjectOwner(hero)
                    QuestionBoxForPlayers(
                        GetPlayerFilter(player),
                        {"/Text/Game/Scripts/HeroSpe/TrainArchers.txt"; num=n},
                        "Routine_TrainPeasantsToArchersConfirm("..player..",'"..hero.."',"..n..")",
                        "Routine_TrainPeasantsToArcherCancel()"
                    )
                end
            end
        end
    end
end
function Routine_TrainPeasantsToArchersConfirm(player, hero, amount)
    RemoveHeroCreatures(hero, CREATURE_PEASANT, amount) sleep(1)
    AddHeroCreatures(hero, CREATURE_ARCHER, amount) sleep(1)
    Var_Dougal_TrainCount = Var_Dougal_TrainCount + amount
    Var_Dougal_TrainPeasantLock = 0
end
function Routine_TrainPeasantsToArcherCancel()
    Var_Dougal_TrainPeasantLock = 0
end

function Routine_GainExpFromTotalGolds(player, hero)
    log(DEBUG, "$ Routine_GainExpFromTotalGolds")
    local level = GetHeroLevel(hero)
    local golds = GetPlayerResource(player, GOLD)
    local ratio = 0.1 + 0.01 * level
    local amount = trunc(golds * ratio)
    AddHeroStatAmount(player, hero, STAT_EXPERIENCE, amount)
end

function Routine_GainPrimaryStats(player, hero, level)
    log(DEBUG, "$ Routine_GainPrimaryStats")
    if mod(level, 10) == 0 then
        ChangeHeroStat(hero, STAT_ATTACK, 1)
        ChangeHeroStat(hero, STAT_DEFENCE, 1)
        ChangeHeroStat(hero, STAT_SPELL_POWER, 1)
        ChangeHeroStat(hero, STAT_KNOWLEDGE, 1)
    end
end

function Routine_UpgradeMonastery(player, hero)
    log(DEBUG, "$ Routine_UpgradeMonastery")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == HAVEN then
                local monastery = GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_5)
                if monastery < 2 then
                    UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_5) sleep()
                    if monastery == 0 then
                        SetObjectDwellingCreatures(town, CREATURE_PRIEST, 0)
                    end
                else
                    local cur = GetObjectDwellingCreatures(town, CREATURE_PRIEST)
                    SetObjectDwellingCreatures(town, CREATURE_PRIEST, cur + 2*WEEKS)
                end
            end
        end
    end
end

function Routine_ConvertPeasantToPriest(player, hero)
    log(DEBUG, "$ Routine_ConvertPeasantToPriest")
    local peasant = nil
    if GetHeroCreatures(hero, CREATURE_PEASANT) > 0 then peasant = CREATURE_PEASANT
    elseif GetHeroCreatures(hero, CREATURE_MILITIAMAN) > 0 then peasant = CREATURE_MILITIAMAN
    elseif GetHeroCreatures(hero, CREATURE_LANDLORD) > 0 then peasant = CREATURE_LANDLORD
    end
    if peasant then
        local convert = 1 + trunc(0.01 * GetHeroCreatures(hero, peasant))
        RemoveHeroCreatures(hero, peasant, convert)
        AddHeroCreatureType(player, hero, HAVEN, 5, convert, 1)
    end
end

function Routine_AddTwoLuckPoints(player, hero)
    log(DEBUG, "$ Routine_AddTwoLuckPoints")
    ChangeHeroStat(hero, STAT_LUCK, 2)
end

function Routine_MovePointsPerGriffin(player, hero)
    log(DEBUG, "$ Routine_MovePointsPerGriffin")
    local movement = GetHeroStat(hero, STAT_MOVE_POINTS)
    local counter = 0
    local n = 0
    n = n + GetHeroCreatures(hero, CREATURE_GRIFFIN)
    n = n + GetHeroCreatures(hero, CREATURE_ROYAL_GRIFFIN)
    n = n + GetHeroCreatures(hero, CREATURE_BATTLE_GRIFFIN)
    while n > counter do
        sleep(2)
        if not IsPlayerCurrent(player) then break end
        local v = round(20 * (1 - counter/n))
        local m = GetHeroStat(hero, STAT_MOVE_POINTS) + v
        if m <= movement then
            ChangeHeroStat(hero, STAT_MOVE_POINTS, v)
            counter = counter + 1
            n = 0 + GetHeroCreatures(hero, CREATURE_GRIFFIN)
            n = n + GetHeroCreatures(hero, CREATURE_ROYAL_GRIFFIN)
            n = n + GetHeroCreatures(hero, CREATURE_BATTLE_GRIFFIN)
        end
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- PRESERVE

Var_Kyrre_BattleWon = 0
function Routine_AddHeroExperience(player, hero)
    log(DEBUG, "$ Routine_AddHeroExperience")
    local exp = 1000 + Var_Kyrre_BattleWon * 50 * (GetHeroLevel(hero) + 10)
    AddHeroStatAmount(player, hero, STAT_EXPERIENCE, exp)
end

function Routine_KyrreVictoryCounter(player, hero, combatIndex)
    log(DEBUG, "$ Routine_KyrreVictoryCounter")
    Var_Kyrre_BattleWon = Var_Kyrre_BattleWon + 1
end

function Routine_UpgradeAvengersGuild(player, hero)
    log(DEBUG, "$ Routine_UpgradeAvengersGuild")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == PRESERVE then
                if GetTownBuildingLevel(town, TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD) < 2 then
                    UpgradeTownBuilding(town, TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD)
                else
                    AddHeroStatAmount(player, hero, STAT_ATTACK, 1)
                    AddHeroStatAmount(player, hero, STAT_KNOWLEDGE, 1)
                end
            end
        end
    end
end 

function Routine_HuntersWeeklyProd(player, hero, combatIndex)
    log(DEBUG, "$ Routine_HuntersWeeklyProd")
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
    log(DEBUG, "$ Routine_AddHeroWolves")
    AddHeroCreatures(hero, CREATURE_WOLF, 1)
    if GetDate(DAY_OF_WEEK) == 1 then
        AddHeroCreatures(hero, CREATURE_WOLF, GetHeroLevel(hero))
    end
end

function Routine_GainAirElementals(player, hero, level)
    log(DEBUG, "$ Routine_GainAirElementals")
    if mod(level, 4) == 0 then
        local nb = GetHeroStat(hero, STAT_KNOWLEDGE)
        AddHeroCreatures(hero, CREATURE_AIR_ELEMENTAL, nb)
    end
end

function Routine_UpgradeMagicGuild(player, hero)
    log(DEBUG, "$ Routine_UpgradeMagicGuild")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == PRESERVE then
                local guild = GetTownBuildingLevel(town, TOWN_BUILDING_MAGIC_GUILD)
                if guild < 5 then UpgradeTownBuilding(town, TOWN_BUILDING_MAGIC_GUILD) end
                local nb = power(2, guild) - 1
                AddHeroCreatures(hero, CREATURE_DRUID, nb)
            end
        end
    end
end

Var_Ylthin_BattleWon = 0
function Routine_YlthinVictoryCounter(player, hero, combatIndex)
    log(DEBUG, "$ Routine_YlthinVictoryCounter")
    Var_Ylthin_BattleWon = Var_Ylthin_BattleWon + 1
    if Var_Ylthin_BattleWon == 25 then
        GiveArtifact(hero, ARTIFACT_UNICORN_HORN_BOW, 0)
        ShowFlyingSign("/Text/Game/Scripts/HeroSpe/GainUnicornBow.txt", hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_HeroCallUnicorns(player, hero)
    log(DEBUG, "$ Routine_HeroCallUnicorns")
    TransferCreatureFromTown(player, hero, TOWN_BUILDING_DWELLING_5, CREATURE_UNICORN, 0.75)
end

Var_Elleshar_BattleWon = 0
function Routine_ElvenSageVictory(player, hero, combatIndex)
    log(DEBUG, "$ Routine_ElvenSageVictory")
    Var_Elleshar_BattleWon = Var_Elleshar_BattleWon + 1
    if mod(Var_Elleshar_BattleWon, 6) == 0 then
        local upgradable = {}
        local maxed = {}
        for sk = 9,12 do
            local m = GetHeroSkillMastery(hero, sk)
            if m == 1 or m == 2 then insert(upgradable, sk) end
            if m >= 3 then insert(maxed, sk) end
        end
        local n = length(upgradable)
        if n == 0 then
            GiveExp(hero, 1000)
        elseif n == 1 then
            GiveHeroSkill(hero, upgradable[1])
        else
            GiveHeroSkill(hero, upgradable[random(1,n,Var_Elleshar_BattleWon)])
        end
        local skill_to_attribute = {[9]=3,[10]=1,[11]=2,[12]=4}
        for _,sk in maxed do
            ChangeHeroStat(hero,skill_to_attribute[sk], 1)
        end
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- FORTRESS

function Routine_AddHeroDefenders(player, hero)
    log(DEBUG, "$ Routine_AddHeroDefenders")
    local amount = trunc(0.3 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, FORTRESS, 1, amount, 1)
end

function Routine_MovePointsPerBear(player, hero)
    log(DEBUG, "$ Routine_MovePointsPerBear")
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
    log(DEBUG, "$ Routine_ReviveBearRiders")
    local max = 1 + trunc(0.66 * GetHeroLevel(hero))
    ResurrectCreatureType(player, hero, combatIndex, FORTRESS, 4, max)
end

function Routine_WorkshopExpertStart(player, hero)
    log(DEBUG, "$ Routine_WorkshopExpertStart")
    GiveArtifact(hero, ARTIFACT_RING_OF_MACHINE_AFFINITY, 1)
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == FORTRESS then
                if GetTownBuildingLevel(town, TOWN_BUILDING_BLACKSMITH) == 0 then
                    UpgradeTownBuilding(town, TOWN_BUILDING_BLACKSMITH)
                else
                    GiveHeroWarMachine(hero, WAR_MACHINE_FIRST_AID_TENT)
                    GiveHeroWarMachine(hero, WAR_MACHINE_AMMO_CART)
                end
            end
        end
    end
end

function Routine_GarnisonDwarvenWorkers(player, hero)
    log(DEBUG, "$ Routine_GarnisonDwarvenWorkers")
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
    log(DEBUG, "$ Routine_ProductionIncreaseDwarvenWorkers")
    local total = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0}
    for obj,data in RESOURCE_GENERATING_OBJECTS do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then
                local workers = GetObjectCreatures(building, CREATURE_DWARF_WORKER)
                workers = min(workers, 400)
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
                total[GOLD] = total[GOLD] + 2 * workers
                if GetDate(DAY_OF_WEEK) == 1 then
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
    end
    for res,amount in total do
        GiveResources(player, res, amount)
    end
end

function Routine_UpgradeRunicShrine(player, hero)
    log(DEBUG, "$ Routine_UpgradeRunicShrine")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == FORTRESS then
                UpgradeTownBuilding(town, TOWN_BUILDING_FORTRESS_RUNIC_SHRINE) sleep(1)
                ChangeHeroStat(hero, STAT_SPELL_POWER, GetTownBuildingLevel(town, TOWN_BUILDING_FORTRESS_RUNIC_SHRINE))
            end
        end
    end
end

function Routine_AddLuckAndMorale(player, hero)
    log(DEBUG, "$ Routine_AddLuckAndMorale")
    ChangeHeroStat(hero, STAT_LUCK, 1)
    ChangeHeroStat(hero, STAT_MORALE, 1)
end

Var_BrandVictoryCounter = 0
function Routine_GiveArtifactBlazingSpellbook(player, hero, combatIndex)
    log(DEBUG, "$ Routine_GiveArtifactBlazingSpellbook")
    Var_BrandVictoryCounter = Var_BrandVictoryCounter + 1
    if Var_BrandVictoryCounter == 10 then
        GiveArtifact(hero, ARTIFACT_BLAZING_SPELLBOOK)
    end
end

function Routine_GiveArtifactRuneOfFlame(player, hero, level)
    log(DEBUG, "$ Routine_GiveArtifactRuneOfFlame")
    if mod(level, 8) == 0 then
        GiveArtifact(hero, ARTIFACT_RUNE_OF_FLAME)
    end
end

Var_Ebba_RunicSpells = {}
for rune,_ in RUNIC_SPELLS do Var_Ebba_RunicSpells[rune] = 0 end

function Routine_GainStatsPerRune(player, hero)
    log(DEBUG, "$ Routine_GainStatsPerRune")
    for rune,tier in RUNIC_SPELLS do
        if KnowHeroSpell(hero, rune) and Var_Ebba_RunicSpells[rune] == 0 then
            AddHeroStatAmount(player, hero, STAT_ATTACK, 1)
            AddHeroStatAmount(player, hero, STAT_DEFENCE, 1)
            AddHeroStatAmount(player, hero, STAT_SPELL_POWER, 1)
            AddHeroStatAmount(player, hero, STAT_KNOWLEDGE, 1)
            TeachHeroRandomSpellTier(player, hero, SPELL_SCHOOL_ANY, tier)
            Var_Ebba_RunicSpells[rune] = 1
        end
    end
end

function Routine_LearnRunicSpell(player, hero)
    log(DEBUG, "$ Routine_LearnRunicSpell")
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
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMY

function Routine_AddOtherHeroesGremlins(player, hero)
    log(DEBUG, "$ Routine_AddOtherHeroesGremlins")
    local amount = GetHeroLevel(hero)
    for _,h in GetPlayerHeroes(player) do
        if h ~= hero and HEROES[h].faction == ACADEMY then
            AddHeroCreatureType(player, h, ACADEMY, 1, amount, 0)
        end
    end
end

function Routine_AssembleGargoyles(player, hero)
    log(DEBUG, "$ Routine_AssembleGargoyles")
    local total = 0
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
        GiveResources(player, ORE, total)
        ShowFlyingSign({"/Text/Game/Scripts/HeroSpe/AssembleGargoyles.txt"; num=total}, hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_FixDestroyedGolems(player, hero, combatIndex)
    log(DEBUG, "$ Routine_FixDestroyedGolems")
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
        GiveResources(player, ORE, total, 1)
        ShowFlyingSign({"/Text/Game/Scripts/HeroSpe/AssembleGargoyles.txt"; num=total}, hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_GenerateGoldsPerDjinn(player, hero)
    log(DEBUG, "$ Routine_GenerateGoldsPerDjinn")
    local djinns = CountHeroCreatureType(player, hero, ACADEMY, 5)
    local amount = GetHeroLevel(hero) * djinns
    GiveResources(player, GOLD, amount)
end

function Routine_RespawnDjinns(player, hero, combatIndex)
    log(DEBUG, "$ Routine_RespawnDjinns")
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

function Routine_UpgradeSilverPavillon(player, hero, level)
    log(DEBUG, "$ Routine_UpgradeSilverPavillon")
    if mod(level, 10) == 0 then
        local amount = 0
        for _,town in GetHeroTowns(player, hero) do
            local pavillon = GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_6)
            if pavillon < 2 then
                UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_6)
                return
            else
                amount = amount + 1
            end
        end
        AddHeroCreatureType(player, hero, ACADEMY, 6, amount * level, 1)
    end
end

function Routine_GainExpPerSulfur(player, hero)
    log(DEBUG, "$ Routine_GainExpPerSulfur")
    local amount = 5 * GetHeroLevel(hero) * GetPlayerResource(player, SULFUR)
    AddHeroStatAmount(player, hero, STAT_EXPERIENCE, amount)
end

function Routine_GainSulfurPerBattle(player, hero, combatIndex)
    log(DEBUG, "$ Routine_GainSulfurPerBattle")
    GiveResources(player, SULFUR, 1, 1)
end

function Routine_GetCraftingResources(player, hero, level)
    log(DEBUG, "$ Routine_GetCraftingResources")
    local max = 1 + trunc(0.5 * level)
    local res = random(0, max, TURN)
    if res > 0 then
        local generated = {[WOOD]=0, [ORE]=0, [MERCURY]=0, [CRYSTAL]=0, [SULFUR]=0, [GEM]=0}
        for i = 1,res do
            local r = random(0, 5, level)
            generated[r] = generated[r] + 1
        end
        for r,v in generated do GiveResources(player, r, v, 1) end
    end
end

function Routine_IncreaseKnowledgeTemp(hero, obj)
    log(DEBUG, "$ Routine_IncreaseKnowledgeTemp")
    if MAP_TOWNS[obj] and MAP_TOWNS[obj].faction == ACADEMY then
        local value = GetHeroLevel(hero)
        local x,y,z = GetObjectPosition(hero)
        ChangeHeroStat(hero, STAT_KNOWLEDGE, value)
        repeat sleep(10) until not IsEqualPosition(hero, x, y, z)
        ChangeHeroStat(hero, STAT_KNOWLEDGE, -value)
    end
end

function Routine_AddRecruitsMages(player, hero)
    log(DEBUG, "$ Routine_AddRecruitsMages")
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
    log(DEBUG, "$ Routine_AddOtherHeroesExperience")
    local exp = round(0.01 * GetHeroStat(hero, STAT_EXPERIENCE))
    for _,h in GetPlayerHeroes(player) do
        if h ~= hero then
            AddHeroStatAmount(player, h, STAT_EXPERIENCE, exp)
        end
    end
end

function Routine_GainKnowledgePerWeek(player, hero)
    log(DEBUG, "$ Routine_GainKnowledgePerWeek")
    local amount = 1 + trunc(GetHeroLevel(hero) * 0.1)
    ChangeHeroStat(hero, STAT_KNOWLEDGE, amount)
end

function Routine_RefreshTimeShift(player, hero)
    log(DEBUG, "$ Routine_RefreshTimeShift")
    ControlHeroCustomAbility(hero, CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED)
end

function Routine_AddHeroEaglesPerWeek(player, hero)
    log(DEBUG, "$ Routine_AddHeroEaglesPerWeek")
    AddHeroCreaturePerLevel(player, hero, CREATURE_ARCANE_EAGLE, 0.3)
end

function Routine_AddHeroEaglePerLevel(player, hero, level)
    log(DEBUG, "$ Routine_AddHeroEaglePerLevel")
    AddHeroCreatures(hero, CREATURE_ARCANE_EAGLE, 1)
end

Var_EaglesReviving = {}
function Routine_RebirthEagleToPhoenix(player, hero, combatIndex)
    log(DEBUG, "$ Routine_RebirthEagleToPhoenix")
    local dead_eagles = 0
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 1)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 1, i)
        if creature == CREATURE_ARCANE_EAGLE then
            dead_eagles = dead_eagles + died
        end
    end
    if dead_eagles > 0 then
        local date = TURN + 28 - trunc(0.5 * GetHeroLevel(hero))
        if Var_EaglesReviving[date] then
            Var_EaglesReviving[date] = Var_EaglesReviving[date] + dead_eagles
        else
            Var_EaglesReviving[date] = dead_eagles
        end
    end
end

function Routine_RebirthPhoenixesDaily(player, hero)
    log(DEBUG, "$ Routine_RebirthPhoenixesDaily")
    if Var_EaglesReviving[TURN] then
        AddHeroCreatures(hero, CREATURE_PHOENIX, Var_EaglesReviving[TURN])
        Var_EaglesReviving[TURN] = nil
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- DUNGEON

function Routine_GenerateGoldPerScout(player, hero)
    log(DEBUG, "$ Routine_GenerateGoldPerScout")
    local mult = trunc(GetHeroLevel(hero) * 0.2)
    if mult > 0 then
        local amount = 0
        amount = amount + GetHeroCreatures(hero, CREATURE_SCOUT)
        amount = amount + GetHeroCreatures(hero, CREATURE_ASSASSIN)
        amount = amount + GetHeroCreatures(hero, CREATURE_STALKER)
        GiveResources(player, GOLD, amount * mult)
    end
end

Var_Yrwanna_Corpses = 0
Var_BloodCrystal_Corpses = 1000
function Routine_GainBloodCrystals(player, hero, combatIndex)
    log(DEBUG, "$ Routine_GainBloodCrystals")
    Var_Yrwanna_Corpses = Var_Yrwanna_Corpses + GetArmyStrength(combatIndex, 0)
    while Var_Yrwanna_Corpses >= Var_BloodCrystal_Corpses do
        GiveArtifact(hero, ARTIFACT_BLOOD_CRYSTAL) sleep()
        Var_Yrwanna_Corpses = Var_Yrwanna_Corpses - Var_BloodCrystal_Corpses
        Var_BloodCrystal_Corpses = trunc(Var_BloodCrystal_Corpses * 1.1)
    end
end

function Routine_BuildHallOfIntrigue(player, hero)
    log(DEBUG, "$ Routine_BuildHallOfIntrigue")
    ChangeHeroStat(hero, STAT_LUCK, 1)
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == DUNGEON then
                if GetTownBuildingLevel(town, TOWN_BUILDING_DUNGEON_HALL_OF_INTRIGUE) == 0 then
                    UpgradeTownBuilding(town, TOWN_BUILDING_DUNGEON_HALL_OF_INTRIGUE)
                else
                    ChangeHeroStat(hero, STAT_KNOWLEDGE, 3)
                end
            end
        end
    end
end

function Routine_AddHeroRiders(player, hero)
    log(DEBUG, "$ Routine_AddHeroRiders")
    local amount = round(0.12 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, DUNGEON, 4, amount, 1)
end

function Routine_GainDragonArtifacts(player, hero, combatIndex)
    log(DEBUG, "$ Routine_GainDragonArtifacts")
    local level = GetHeroLevel(hero)
    local value = trunc(0.001 * GetArmyStrength(combatIndex, 0))
    log(DEBUG, "---DEBUG: value = "..value)
    local rnd = random(1,100,level)
    if (2 * level + value) > rnd then
        local r = (value+level) > 45 and 1 or 0
        local i = 1 + mod(rnd, 7+r)
        local a = ARTIFACT_SETS[ARTIFACT_SET_DRAGON][i]
        while value > 0 do
            if HasArtefact(hero, a, 0) then
                value = value - 2
                rnd = random(1,100,a)
                i = 1 + mod(rnd, 7+r)
                a = ARTIFACT_SETS[ARTIFACT_SET_DRAGON][i]
            else
                GiveArtifact(hero, a) return
            end
        end
    end
end

function Routine_GainWeeklySpellpower(player, hero)
    log(DEBUG, "$ Routine_GainWeeklySpellpower")
    ChangeHeroStat(hero, STAT_SPELL_POWER, 1)
end

function Routine_AddHeroLevel(player, hero, level)
    log(DEBUG, "$ Routine_AddHeroLevel")
    if mod(level, 6) == 0 then
        LevelUpHero(hero)
    end
end

function Routine_UpgradeToWitches(player, hero)
    log(DEBUG, "$ Routine_UpgradeToWitches")
    local max_bloodwitch = trunc(GetHeroLevel(hero) * 1.25)
    TransformTownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_SCOUT, TOWN_BUILDING_DWELLING_2, CREATURE_WITCH, max_bloodwitch)
    local max_shadowwitch = trunc(GetHeroLevel(hero) * 0.25)
    TransformTownRecruits(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_RIDER, TOWN_BUILDING_DWELLING_5, CREATURE_MATRON, max_shadowwitch)
end

function Routine_AddHeroManticores(player, hero)
    log(DEBUG, "$ Routine_AddHeroManticores")
    AddHeroCreaturePerLevel(player, hero, CREATURE_MANTICORE, 0.4)
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- NECROPOLIS

function Routine_GainMovePointsPerLevel(player, hero, level)
    log(DEBUG, "$ Routine_GainMovePointsPerLevel")
    ChangeHeroStat(hero, STAT_MOVE_POINTS, 50 * level)
end

function Routine_UpgradeCrypt(player, hero)
    log(DEBUG, "$ Routine_UpgradeCrypt")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == NECROPOLIS then
                local crypt = GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_2)
                if crypt < 2 then
                    UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_2)
                else
                    AddHeroStatAmount(player, hero, STAT_SPELL_POWER, 3)
                end
            end
        end
    end
end

function Routine_ReviveZombies(player, hero, combatIndex)
    log(DEBUG, "$ Routine_ReviveZombies")
    ResurrectCreatureType(player, hero, combatIndex, NECROPOLIS, 2, GetHeroLevel(hero))
end

Var_Lucretia_BattleWon = 0
function Routine_LearnDarkMagic(player, hero, combatIndex)
    log(DEBUG, "$ Routine_LearnDarkMagic")
    Var_Lucretia_BattleWon = Var_Lucretia_BattleWon + 1
    if Var_Lucretia_BattleWon == 13 then
        GiveHeroSkill(hero, SKILL_DARK_MAGIC)
        ShowFlyingSign("/Text/Game/Scripts/HeroSpe/LearnDarkMagic.txt", hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_AddHeroBlackKnight(player, hero)
    log(DEBUG, "$ Routine_AddHeroBlackKnight")
    AddHeroCreatureType(player, hero, NECROPOLIS, 6, 1, 1)
end

function Routine_ResurrectBlackKnight(player, hero, combatIndex)
    log(DEBUG, "$ Routine_ResurrectBlackKnight")
    local level = GetHeroLevel(hero)
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 1)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 1, i)
        if died > 0 then
            if CREATURES[creature][1] == NECROPOLIS and CREATURES[creature][2] == 6 then
                local rez = ceil(0.01 * level * count)
                rez = min(rez, died)
                AddHeroCreatures(hero, creature, rez)
            end
        end
    end
end

function Routine_AddRecruitsNecropolis(player, hero)
    log(DEBUG, "$ Routine_AddRecruitsNecropolis")
    local amount1 = trunc(2.5 * GetHeroLevel(hero))
    local amount2 = trunc(1.3 * GetHeroLevel(hero))
    local amount3 = trunc(0.5 * GetHeroLevel(hero))
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_SKELETON, amount1)
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_2, CREATURE_WALKING_DEAD, amount2)
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_3, CREATURE_MANES, amount3)
end

function Routine_AddHeroMummies(player, hero)
    log(DEBUG, "$ Routine_AddHeroMummies")
    AddHeroCreaturePerLevel(player, hero, CREATURE_MUMMY, 0.3)
end

function Routine_BansheeHowlBuffs(player, hero, level)
    log(DEBUG, "$ Routine_BansheeHowlBuffs")
    if level == 15 then
        GiveArtifact(hero, ARTIFACT_251)
        GiveArtifact(hero, ARTIFACT_252)
    elseif level == 25 then
        GiveArtifact(hero, ARTIFACT_253)
        GiveArtifact(hero, ARTIFACT_254)
    end
end

function Routine_BuildDragonTombstone(player, hero)
    log(DEBUG, "$ Routine_BuildDragonTombstone")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == NECROPOLIS then
                UpgradeTownBuilding(town, TOWN_BUILDING_NECROMANCY_DRAGON_TOMBSTONE)
            end
        end
    end
end

function Routine_GiveSandrosCloak(player, hero)
    log(DEBUG, "$ Routine_GiveSandrosCloak")
    GiveArtifact(hero, ARTIFACT_SANDROS_CLOAK, 1)
end

function Routine_AddLichesPerKnowledge(player, hero)
    log(DEBUG, "$ Routine_AddLichesPerKnowledge")
    local nb = trunc(0.2 * GetHeroStat(hero, STAT_KNOWLEDGE))
    AddHeroCreatureType(player, hero, NECROPOLIS, 5, nb, 1)
end

Var_Ornella_FrostLordSet = {
    [ARTIFACT_EVERCOLD_ICICLE]=5,
    [ARTIFACT_FROZEN_HEART]=5,
    [ARTIFACT_CROWN_OF_THE_FROST_LORD]=1,
    [ARTIFACT_SPEAR_OF_THE_FROST_LORD]=1,
}
function Routine_FrostLordArtifacts(player, hero)
    log(DEBUG, "$ Routine_FrostLordArtifacts")
    local factor = 1 + 0.05 * GetHeroLevel(hero)
    for a,p in Var_Ornella_FrostLordSet do
        if (p * factor) > random(0,100,a) then
            GiveArtifact(hero, a)
            Var_Ornella_FrostLordSet[a] = 0
            return
        end
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- INFERNO

function Routine_AddHeroHellHounds(player, hero)
    log(DEBUG, "$ Routine_AddHeroHellHounds")
    local amount = round(0.90 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, INFERNO, 3, amount, 1)
end

function Routine_GainAttackPerLevel(player, hero, level)
    log(DEBUG, "$ Routine_GainAttackPerLevel")
    if mod(level, 5) == 0 then
        AddHeroStatAmount(player, hero, STAT_ATTACK, 1)
    end
end

function Routine_BuildInfernalLoom(player, hero)
    log(DEBUG, "$ Routine_BuildInfernalLoom")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == INFERNO then
                if GetTownBuildingLevel(town, TOWN_BUILDING_INFERNO_INFERNAL_LOOM) == 0 then
                    UpgradeTownBuilding(town, TOWN_BUILDING_INFERNO_INFERNAL_LOOM)
                else
                    ChangeHeroStat(hero, STAT_EXPERIENCE, 5000)
                end
            end
        end
    end
end

Var_AgraelVictoryCounter = 0
function Routine_AgraelVictoryCounter(player, hero, combatIndex)
    log(DEBUG, "$ Routine_AgraelVictoryCounter")
    Var_AgraelVictoryCounter = Var_AgraelVictoryCounter + 1
    if Var_AgraelVictoryCounter == 25 then
        for _,h in GetPlayerHeroes(player) do
            TeachHeroSpell(h, SPELL_ARMAGEDDON)
        end
    end
end

function Routine_AddHeroSuccubus(player, hero, level)
    log(DEBUG, "$ Routine_AddHeroSuccubus")
    local nb = 1 + trunc(0.34 * level)
    AddHeroCreatureType(player, hero, INFERNO, 4, nb, 1)
end

function Routine_GainBonusExpAndRes(player, hero, combatIndex)
    log(DEBUG, "$ Routine_GainBonusExpAndRes")
    local total = 0
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 0)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 0, i)
        local tier = CREATURES[creature][2]
        local value = 2*tier + power(2, tier)
        total = total + count * value
    end
    AddHeroStatAmount(player, hero, STAT_EXPERIENCE, trunc(1.5*total))
    GiveResources(player, GOLD, total, 1)
end

function Routine_TownBuildingUp(player, hero)
    log(DEBUG, "$ Routine_TownBuildingUp")
    if IsAIPlayer(player) then return end
    local mult = 1 - 0.01 * GetHeroLevel(hero)
    local buildings = {
        [TOWN_BUILDING_DWELLING_1] = {round(1500 * mult), round(3500 * mult)},
        [TOWN_BUILDING_DWELLING_2] = {round(2250 * mult), round(5250 * mult)},
        [TOWN_BUILDING_DWELLING_3] = {round(3000 * mult), round(7000 * mult)},
        [TOWN_BUILDING_DWELLING_4] = {round(4500 * mult), round(10500 * mult)},
        [TOWN_BUILDING_DWELLING_5] = {round(6500 * mult), round(14500 * mult)},
        [TOWN_BUILDING_DWELLING_6] = {round(10000 * mult), round(20000 * mult)},
        [TOWN_BUILDING_DWELLING_7] = {round(17500 * mult), round(32500 * mult)},
    }
    local name_root = "/Text/Game/TownBuildings/Inferno/"
    local name_file = {
        [TOWN_BUILDING_DWELLING_1] = {"Dwelling_1/Name.txt", "Dwelling_1/Upgraded_Name.txt"},
        [TOWN_BUILDING_DWELLING_2] = {"Dwelling_2/Name.txt", "Dwelling_2/Upgraded_Name.txt"},
        [TOWN_BUILDING_DWELLING_3] = {"Dwelling_3/Name.txt", "Dwelling_3/Upgraded_Name.txt"},
        [TOWN_BUILDING_DWELLING_4] = {"Dwelling_4/Name.txt", "Dwelling_4/Upgraded_Name.txt"},
        [TOWN_BUILDING_DWELLING_5] = {"Dwelling_5/Name.txt", "Dwelling_5/Upgraded_Name.txt"},
        [TOWN_BUILDING_DWELLING_6] = {"Dwelling_6/Name.txt", "Dwelling_6/Upgraded_Name.txt"},
        [TOWN_BUILDING_DWELLING_7] = {"Dwelling_7/Name.txt", "Dwelling_7/Upgraded_Name.txt"},
    }
    for town,data in MAP_TOWNS do
        if data.faction == INFERNO then
            if IsHeroInTown(hero, town, 1, 0) then
                for k,v in buildings do
                    local cur = GetTownBuildingLevel(town, k)
                    if cur < length(v) then
                        local cost = v[cur+1]
                        if GetPlayerResource(player, GOLD) >= cost then
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
    TakeAwayResources(player, GOLD, 0+cost)
    ChangeHeroStat(hero, STAT_MOVE_POINTS, -500)
end

function Routine_GenerateSulfur(player, hero, level)
    log(DEBUG, "$ Routine_GenerateSulfur")
    GiveResources(player, SULFUR, 1, 1)
end

function Routine_MultiplyTroops(player, hero)
    log(DEBUG, "$ Routine_MultiplyTroops")
    local level = GetHeroLevel(hero)
    local percent = 1 + trunc(0.05 * level)
    local maxtier = 1 + trunc(0.20 * level)
    local tracker = {}
    for i,cr in GetHeroArmy(hero) do
        if cr and cr ~= 0 then
            if not tracker[cr] then
                local faction = CREATURES[cr][1]
                local tier = CREATURES[cr][2]
                if faction == INFERNO and tier <= maxtier then
                    local nb = GetHeroCreatures(hero, cr)
                    local add = trunc(0.01 * percent * nb)
                    if add > 0 then AddHeroCreatures(hero, cr, add) end
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
    log(DEBUG, "$ Routine_GainArmyReinforcement")
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
    log(DEBUG, "$ Routine_GiveArtifactCentaurCrossbow")
    GiveArtifact(hero, ARTIFACT_CENTAUR_CROSSBOW, 1)
end

function Routine_AddRecruitsCentaurs(player, hero)
    log(DEBUG, "$ Routine_AddRecruitsCentaurs")
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
    log(DEBUG, "$ Routine_GainAttackDefense")
    Var_Gorshak_BattleWon = Var_Gorshak_BattleWon + 1
    if mod(Var_Gorshak_BattleWon, 10) == 0 then
        AddHeroStatAmount(player, hero, STAT_ATTACK, 1)
        AddHeroStatAmount(player, hero, STAT_DEFENCE, 1)
    end
end

function Routine_UpgradeChamberOfWrath(player, hero)
    log(DEBUG, "$ Routine_UpgradeChamberOfWrath")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == STRONGHOLD then
                UpgradeTownBuilding(town, TOWN_BUILDING_DWELLING_5) sleep()
                if GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_5) == 1 then
                    SetObjectDwellingCreatures(town, CREATURE_ORCCHIEF_BUTCHER, 0)
                end
            end
        end
    end
end

function Routine_BuildStrongholdFort(player, hero)
    log(DEBUG, "$ Routine_BuildStrongholdFort")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            if data.faction == STRONGHOLD then
                local fort = GetTownBuildingLevel(town, TOWN_BUILDING_FORT)
                if fort == 0 then
                    UpgradeTownBuilding(town, TOWN_BUILDING_FORT)
                else
                    AddHeroCreatureType(player, hero, STRONGHOLD, 6, 1, 1)
                end
            end
        end
    end
end

Var_ShakKarukat_LastWyvernDay = 1
function Routine_AddHeroWyverns(player, hero)
    log(DEBUG, "$ Routine_AddHeroWyverns")
    local lvl_reduction = trunc(0.34 * GetHeroLevel(hero))
    local max_fort = 0
    for _,town in GetHeroTowns(player, hero) do
        local fort = GetTownBuildingLevel(town, TOWN_BUILDING_FORT)
        if fort > max_fort then max_fort = fort end
    end
    local delay = 21 - lvl_reduction - 3 * max_fort
    if TURN >= Var_ShakKarukat_LastWyvernDay + delay then
        AddHeroCreatureType(player, hero, STRONGHOLD, 6, 1, 1)
        Var_ShakKarukat_LastWyvernDay = TURN
    end
end

function Routine_SacrificeGoblinCorpses(player, hero, combatIndex)
    log(DEBUG, "$ Routine_SacrificeGoblinCorpses")
    local limit = 1 + trunc(0.5 * GetHeroLevel(hero))
    local total = 0
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 1)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 1, i)
        if died > 0 then
            if creature == CREATURE_GOBLIN or creature == CREATURE_GOBLIN_TRAPPER or creature == CREATURE_GOBLIN_DEFILER then
                local nb = min(died, limit-total)
                AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_2, CREATURE_SHAMAN, nb)
                total = total + nb
                if total == limit then return end
            end
        end
    end
end

function Routine_SpiritArtifacts(player, hero, level)
    log(DEBUG, "$ Routine_SpiritArtifacts")
    if level == 7 then
        GiveArtifact(hero, ARTIFACT_TUNIC_OF_CARVED_FLESH)
    elseif level == 11 then
        GiveArtifact(hero, ARTIFACT_CURSED_RING)
    elseif level == 19 then
        GiveArtifact(hero, ARTIFACT_SPIRIT_OF_OPPRESSION)
    elseif level == 23 then
        GiveArtifact(hero, ARTIFACT_DEADWOOD_STAFF)
    elseif level == 29 then
        GiveArtifact(hero, ARTIFACT_SKULL_MASK)
    end
end

function Routine_GainPotionLevelUp(player, hero, level)
    log(DEBUG, "$ Routine_GainPotionLevelUp")
    local potion = random(137, 139, level)
    GiveArtifact(hero, potion)
end





START_TRIGGER_HERO_ROUTINES = {
    -- haven
    [H_ISABEL] = Routine_AddTwoLuckPoints,
    [H_ALARIC] = Routine_UpgradeMonastery,
    [H_DOUGAL] = Routine_EnableTrainPeasantsToArchers,
    [H_KLAUS] = Routine_BuildAndRevealStables,
    -- preserve
    [H_FINDAN] = Routine_UpgradeAvengersGuild,
    [H_TIERU] = Routine_UpgradeMagicGuild,
    -- fortress
    [H_WULFSTAN] = Routine_WorkshopExpertStart,
    [H_TOLGHAR] = Routine_AddLuckAndMorale,
    [H_ERLING] = Routine_UpgradeRunicShrine,
    -- academy
    [H_RISSA] = Routine_RefreshTimeShift,
    -- dungeon
    [H_ERUINA] = Routine_BuildHallOfIntrigue,
    -- necropolis
    [H_ORSON] = Routine_UpgradeCrypt,
    [H_ARCHILUS] = Routine_BuildDragonTombstone,
    [H_SANDRO] = Routine_GiveSandrosCloak,
    -- inferno
    [H_NYMUS] = Routine_BuildInfernalLoom,
    -- stronghold
    [H_GARUNA] = Routine_GiveArtifactCentaurCrossbow,
    [H_GORSHAK] = Routine_UpgradeChamberOfWrath,
    [H_KARUKAT] = Routine_BuildStrongholdFort,
}

DAILY_TRIGGER_HERO_ROUTINES = {
    -- haven
    [H_GABRIELLE] = Routine_MovePointsPerGriffin,
    -- preserve
    [H_IVOR] = Routine_AddHeroWolves,
    -- fortress
    [H_INGVAR] = Routine_AddHeroDefenders,
    [H_ROLF] = Routine_MovePointsPerBear,
    [H_HANGVUL] = Routine_ProductionIncreaseDwarvenWorkers,
    -- academy
    [H_HAVEZ] = Routine_AddOtherHeroesGremlins,
    [H_MAAHIR] = Routine_AddOtherHeroesExperience,
    [H_NATHIR] = Routine_GainExpPerSulfur,
    [H_GALIB] = Routine_GenerateGoldsPerDjinn,
    [H_RISSA] = Routine_RefreshTimeShift,
    [H_MINASLI] = Routine_RebirthPhoenixesDaily,
    -- dungeon
    [H_VAYSHAN] = Routine_GenerateGoldPerScout,
    [H_SORGAL] = Routine_AddHeroRiders,
    -- necropolis
    [H_THANT] = Routine_AddHeroMummies,
    [H_ORNELLA] = Routine_FrostLordArtifacts,
    -- inferno
    [H_ORLANDO] = Routine_TownBuildingUp,
    [H_KHABELETH] = Routine_MultiplyTroops,
    -- stronghold
    [H_KARUKAT] = Routine_AddHeroWyverns,
}

WEEKLY_TRIGGER_HERO_ROUTINES = {
    -- haven
    [H_DOUGAL] = Routine_EnableTrainPeasantsToArchers,
    [H_MAEVE] = Routine_AddRecruitsPeasants,
    [H_NICOLAI] = Routine_GainExpFromTotalGolds,
    -- preserve
    [H_KYRRE] = Routine_AddHeroExperience,
    [H_FINDAN] = Routine_HuntersWeeklyProd,
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
    [H_SEPHINROTH] = Routine_GainWeeklySpellpower,
    -- necropolis
    [H_RAVEN] = Routine_AddRecruitsNecropolis,
    [H_XERXON] = Routine_AddHeroBlackKnight,
    -- inferno
    [H_GRAWL] = Routine_AddHeroHellHounds,
    -- stronghold
    [H_GARUNA] = Routine_AddRecruitsCentaurs,
}

LEVEL_UP_HERO_ROUTINES_HERO = {
    -- haven
    [H_MAEVE] = Routine_PeasantTaxLevel,
    [H_NICOLAI] = Routine_GainPrimaryStats,
    -- preserve
    [H_VINRAEL] = Routine_GainAirElementals,
    -- fortress
    [H_EBBA] = Routine_GiveArtifactRuneOfFlame,
    -- academy
    [H_DAVIUS] = Routine_UpgradeSilverPavillon,
    [H_THEODORUS] = Routine_GetCraftingResources,
    [H_MINASLI] = Routine_AddHeroEaglePerLevel,
    -- dungeon
    [H_SHADYA] = Routine_AddHeroLevel,
    -- necropolis
    [H_VLADIMIR] = Routine_GainMovePointsPerLevel,
    [H_SANDRO] = Routine_AddLichesPerKnowledge,
    [H_DEIRDRE] = Routine_BansheeHowlBuffs,
    -- inferno
    [H_ASH] = Routine_GainAttackPerLevel,
    [H_BIARA] = Routine_AddHeroSuccubus,
    [H_DELEB] = Routine_GenerateSulfur,
    -- stronghold
    [H_URGHAT] = Routine_SpiritArtifacts,
    [H_ZOULEIKA] = Routine_GainPotionLevelUp,
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
    [H_YRWANNA] = Routine_GainBloodCrystals,
    [H_RAELAG] = Routine_GainDragonArtifacts,
    -- necropolis
    [H_ORSON] = Routine_ReviveZombies,
    [H_XERXON] = Routine_ResurrectBlackKnight,
    [H_LUCRETIA] = Routine_LearnDarkMagic,
    -- inferno
    [H_AGRAEL] = Routine_AgraelVictoryCounter,
    [H_ORLANDO] = Routine_GainBonusExpAndRes,
    -- stronghold
    [H_KRAGH] = Routine_GainArmyReinforcement,
    [H_GORSHAK] = Routine_GainAttackDefense,
    [H_KUJIN] = Routine_SacrificeGoblinCorpses,
}

CONTINUOUS_TRIGGER_HERO_ROUTINES = {
    -- haven
    -- preserve
    -- fortress
    [H_EBBA] = Routine_GainStatsPerRune,
    -- academy
    -- dungeon
    -- necropolis
    -- inferno
    -- stronghold
}


function DoHeroSpeRoutine_Start(player, hero)
    log(DEBUG, "$ DoHeroSpeRoutine_Start - "..hero)
    if START_TRIGGER_HERO_ROUTINES[hero] then
        startThread(START_TRIGGER_HERO_ROUTINES[hero], player, hero)
    end
end

function DoHeroSpeRoutine_Daily(player, hero)
    log(DEBUG, "$ DoHeroSpeRoutine_Daily - "..hero)
    if DAILY_TRIGGER_HERO_ROUTINES[hero] then
        startThread(DAILY_TRIGGER_HERO_ROUTINES[hero], player, hero)
    end
end

function DoHeroSpeRoutine_Weekly(player, hero)
    log(DEBUG, "$ DoHeroSpeRoutine_Weekly - "..hero)
    if WEEKLY_TRIGGER_HERO_ROUTINES[hero] then
        startThread(WEEKLY_TRIGGER_HERO_ROUTINES[hero], player, hero)
    end
end

function DoHeroSpeRoutine_LevelUp(player, hero, level)
    log(DEBUG, "$ DoHeroSpeRoutine_LevelUp - "..hero)
    if LEVEL_UP_HERO_ROUTINES_HERO[hero] then
        startThread(LEVEL_UP_HERO_ROUTINES_HERO[hero], player, hero, level)
    end
end

function DoHeroSpeRoutine_AfterCombat(player, hero, index)
    log(DEBUG, "$ DoHeroSpeRoutine_AfterCombat - "..hero)
    if AFTER_COMBAT_TRIGGER_HERO_ROUTINES[hero] then
        startThread(AFTER_COMBAT_TRIGGER_HERO_ROUTINES[hero], player, hero, index)
    end
end

function DoHeroSpeRoutine_Continuous(player, hero)
    -- log(DEBUG, "$ DoHeroSpeRoutine_Continuous - "..hero)
    if CONTINUOUS_TRIGGER_HERO_ROUTINES[hero] then
        startThread(CONTINUOUS_TRIGGER_HERO_ROUTINES[hero], player, hero)
    end
end


-- log(TRACE, "Loaded heroes-routines-advmap.lua")
ROUTINES_LOADED[13] = 1
