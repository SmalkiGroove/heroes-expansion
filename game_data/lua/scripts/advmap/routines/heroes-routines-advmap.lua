
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- HAVEN

function Routine_DoublePeasantTax(player, hero)
    print("$ Routine_DoublePeasantTax")
    local amount = 0
    amount = amount + GetHeroCreatures(hero, CREATURE_PEASANT)
    amount = amount + GetHeroCreatures(hero, CREATURE_MILITIAMAN)
    amount = amount + GetHeroCreatures(hero, CREATURE_LANDLORD)
    AddPlayerResource(player, hero, GOLD, amount)
end

function Routine_AddHeroCavaliers(player, hero)
    print("$ Routine_AddHeroCavaliers")
    local amount = round(0.11 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, HAVEN, 6, amount)
end

function Routine_ActivateArtfsetHaven(player, hero)
    print("$ Routine_ActivateArtfsetHaven")
    GiveArtifact(hero, 244, 1)
    GiveArtifact(hero, 245, 1)
end

function Routine_AddRecruitsPeasants(player, hero)
    print("$ Routine_AddRecruitsPeasants")
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
    print("$ Routine_EnableTrainPeasantsToArchers")
    Var_Dougal_TrainCount = 0
end

function Routine_TrainPeasantsToArchersCheck(player, hero)
    print("$ Routine_TrainPeasantsToArchersCheck")
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
    print("Train "..amount.." peasants to archers in town "..town)
    local peasants = GetObjectDwellingCreatures(town, CREATURE_PEASANT)
    local archers = GetObjectDwellingCreatures(town, CREATURE_ARCHER)
    SetObjectDwellingCreatures(town, CREATURE_PEASANT, peasants - amount)
    SetObjectDwellingCreatures(town, CREATURE_ARCHER, archers + amount)
    Var_Dougal_TrainCount = Var_Dougal_TrainCount + amount
end

function Routine_GainExpFromTotalGolds(player, hero)
    print("$ Routine_GainExpFromTotalGolds")
    local mult = trunc(GetHeroLevel(hero) * 0.1)
    local amount = GetPlayerResource(player, GOLD) * mult
    AddHeroStatAmount(player, hero, STAT_EXPERIENCE, amount)
end

function Routine_GainPrimaryStats(player, hero, level)
    print("$ Routine_GainPrimaryStats")
    if mod(level, 5) == 0 then
        ChangeHeroStat(hero, STAT_ATTACK, 1)
        ChangeHeroStat(hero, STAT_DEFENCE, 1)
        ChangeHeroStat(hero, STAT_SPELL_POWER, 1)
        ChangeHeroStat(hero, STAT_KNOWLEDGE, 1)
    end
end

function Routine_UpgradeMonastery(player, hero)
    print("$ Routine_UpgradeMonastery")
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
    print("$ Routine_ConvertPeasantToPriest")
    local peasant = nil
    if GetHeroCreatures(hero, CREATURE_PEASANT) > 0 then peasant = CREATURE_PEASANT
    elseif GetHeroCreatures(hero, CREATURE_MILITIAMAN) > 0 then peasant = CREATURE_MILITIAMAN
    elseif GetHeroCreatures(hero, CREATURE_LANDLORD) > 0 then peasant = CREATURE_LANDLORD
    end
    if peasant then
        RemoveHeroCreatures(hero, peasant, 1)
        AddHeroCreatureType(player, hero, HAVEN, 5, 1)
    end
end

function Routine_AddTwoLuckPoints(player, hero)
    print("$ Routine_AddTwoLuckPoints")
    ChangeHeroStat(hero, STAT_LUCK, 2)
end

function Routine_MovePointsPerGriffin(player, hero)
    print("$ Routine_MovePointsPerGriffin")
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
    print("$ Routine_AddHeroExperience")
    local exp = 1000 + Var_Kyrre_BattleWon * 50 * (GetHeroLevel(hero) + 10)
    AddHeroStatAmount(player, hero, STAT_EXPERIENCE, exp)
end

function Routine_KyrreVictoryCounter(player, hero, combatIndex)
    print("$ Routine_KyrreVictoryCounter")
    Var_Kyrre_BattleWon = Var_Kyrre_BattleWon + 1
end

function Routine_HuntersWeeklyProd(player, hero, combatIndex)
    print("$ Routine_HuntersWeeklyProd")
    for town,data in MAP_TOWNS do
        if data.faction == PRESERVE then
            if GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_3) ~= 0 then
                local fort = GetTownBuildingLevel(town, TOWN_BUILDING_FORT)
                local grail = GetTownBuildingLevel(town, TOWN_BUILDING_GRAIL)
                local multiplier = 1 + 0.5 * grail
                if fort > 1 then multiplier = multiplier + 0.5 * (fort-1) end
                local nb = trunc(14 * multiplier)
                local current = GetObjectDwellingCreatures(town, CREATURE_WOOD_ELF)
                SetObjectDwellingCreatures(town, CREATURE_WOOD_ELF, current + nb)
            end
        end
    end
end

function Routine_AddHeroWolves(player, hero)
    print("$ Routine_AddHeroWolves")
    AddHeroCreaturePerLevel(player, hero, CREATURE_WOLF, 2.0)
end

function Routine_GiveArtifactLegendaryBoots(player, hero, level)
    print("$ Routine_GiveArtifactLegendaryBoots")
    if level == 20 then
        GiveArtifact(hero, ARTIFACT_LEGENDARY_BOOTS)
    end
end

Var_Ylthin_BattleWon = 0
function Routine_YlthinVictoryCounter(player, hero, combatIndex)
    print("$ Routine_YlthinVictoryCounter")
    Var_Ylthin_BattleWon = Var_Ylthin_BattleWon + 1
    if Var_Ylthin_BattleWon == 25 then
        GiveArtifact(hero, ARTIFACT_UNICORN_HORN_BOW, 0)
        ShowFlyingSign("/Text/Game/Scripts/HeroSpe/GainUnicornBow.txt", hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_HeroCallUnicorns(player, hero)
    print("$ Routine_HeroCallUnicorns")
    TransferCreatureFromTown(player, hero, TOWN_BUILDING_DWELLING_5, CREATURE_UNICORN, 0.75)
end

Var_Elleshar_BattleWon = 0
function Routine_ElvenSageVictory(player, hero, combatIndex)
    print("$ Routine_ElvenSageVictory")
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

function Routine_AddHeroDefenders(player, hero)
    print("$ Routine_AddHeroDefenders")
    local amount = trunc(0.3 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, FORTRESS, 1, amount)
end

function Routine_MovePointsPerBear(player, hero)
    print("$ Routine_MovePointsPerBear")
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
    print("$ Routine_ReviveBearRiders")
    local max = 2 + trunc(0.66 * GetHeroLevel(hero))
    ResurrectCreatureType(player, hero, combatIndex, FORTRESS, 4, max)
end

function Routine_GiveArtifactRingOfMachineAffinity(player, hero)
    print("$ Routine_GiveArtifactRingOfMachineAffinity")
    GiveArtifact(hero, ARTIFACT_RING_OF_MACHINE_AFFINITY, 1)
end

function Routine_GarnisonDwarvenWorkers(player, hero)
    print("$ Routine_GarnisonDwarvenWorkers")
    local level = GetHeroLevel(hero)
    local amount1 = 1 + level
    local amount2 = trunc(0.4 * level)
    local amount4 = trunc(0.1 * level)
    for obj,_ in RESOURCE_GENERATING_OBJECTS do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then
                if amount1 > 0 then AddObjectCreatures(building, CREATURE_DEFENDER, amount1) end
                if amount2 > 0 then AddObjectCreatures(building, CREATURE_AXE_FIGHTER, amount2) end
                if amount4 > 0 then AddObjectCreatures(building, CREATURE_BEAR_RIDER, amount4) end
            end
        end
    end
end

function Routine_ProductionIncreaseDwarvenWorkers(player, hero)
    print("$ Routine_ProductionIncreaseDwarvenWorkers")
    for obj,data in RESOURCE_GENERATING_OBJECTS do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then
                local work = 0
                work = work + GetObjectCreatures(building, CREATURE_DEFENDER)
                work = work + GetObjectCreatures(building, CREATURE_STONE_DEFENDER)
                work = work + GetObjectCreatures(building, CREATURE_STOUT_DEFENDER)
                work = work + 2 * GetObjectCreatures(building, CREATURE_AXE_FIGHTER)
                work = work + 2 * GetObjectCreatures(building, CREATURE_AXE_THROWER)
                work = work + 2 * GetObjectCreatures(building, CREATURE_HARPOONER)
                work = work + 5 * GetObjectCreatures(building, CREATURE_BEAR_RIDER)
                work = work + 5 * GetObjectCreatures(building, CREATURE_BLACKBEAR_RIDER)
                work = work + 5 * GetObjectCreatures(building, CREATURE_WHITE_BEAR_RIDER)
                local bonus = trunc(data.amount * work * 0.002)
                if bonus > 0 then AddPlayerResource(player, hero, data.type, bonus) end
            end
        end
    end
end

function Routine_RunePriestDwellingUp(player, hero)
    print("$ Routine_RunePriestDwellingUp")
    if PLAYER_BRAIN[player] ~= HUMAN then return end
    for town,data in MAP_TOWNS do
        if data.faction == FORTRESS then
            if IsHeroInTown(hero, town, 1, 0) then
                local dw = GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_5)
                if dw < 2 then
                    local discount = 1 - 0.05 * GetHeroLevel(hero)
                    local cost = trunc((10000 + dw * 7500) * discount)
                    local name_file = {"Name.txt","Upgraded_Name.txt"}
                    local name = "/Text/Game/TownBuildings/Dwarves/Dwelling_5/"..name_file[dw+1]
                    QuestionBoxForPlayers(
                        GetPlayerFilter(player),
                        {"/Text/Game/Scripts/HeroSpe/RunePriestDwelling.txt"; building=name, golds=cost},
                        "Routine_RunePriestDwellingUpConfirm('"..player.."','"..hero.."','"..town.."','"..TOWN_BUILDING_DWELLING_5.."','"..cost.."')",
                        "NoneRoutine"
                    )
                end
            end
        end
    end
end

function Routine_RunePriestDwellingUpConfirm(player, hero, town, building, cost)
    UpgradeTownBuilding(town, building)
    RemovePlayerResource(player, GOLD, 0+cost)
end

function Routine_AddLuckAndMorale(player, hero)
    print("$ Routine_AddLuckAndMorale")
    ChangeHeroStat(hero, STAT_LUCK, 1)
    ChangeHeroStat(hero, STAT_MORALE, 1)
end

function Routine_GiveArtifactRuneOfFlame(player, hero)
    print("$ Routine_GiveArtifactRuneOfFlame")
    GiveArtifact(hero, ARTIFACT_RUNE_OF_FLAME, 1)
end

Var_Ebba_SpellpowerBonus = 0
function Routine_GainSpellpowerPerRune(player, hero)
    print("$ Routine_GainSpellpowerPerRune")
    local n = 0
    for rune = SPELL_RUNE_OF_CHARGE,SPELL_RUNE_OF_DRAGONFORM do
        if KnowHeroSpell(hero, rune) then n = n+1 end
    end
    local diff = n - Var_Ebba_SpellpowerBonus
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_SPELL_POWER, diff)
        Var_Ebba_SpellpowerBonus = n
    end
end

function Routine_GenerateCrystalsAndGems(player, hero)
    print("$ Routine_GenerateCrystalsAndGems")
    local n = ceil(GetHeroLevel(hero) * 0.1)
    for rune = SPELL_RUNE_OF_CHARGE,SPELL_RUNE_OF_DRAGONFORM do
        if KnowHeroSpell(hero, rune) then n = n+1 end
    end
    local split = mod(TURN,n)
    AddPlayerResource(player, hero, CRYSTAL, split)
    AddPlayerResource(player, hero, GEM, n-split)
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMY

function Routine_AddOtherHeroesGremlins(player, hero)
    print("$ Routine_AddOtherHeroesGremlins")
    local amount = GetHeroLevel(hero)
    -- local amount = round(0.50 * GetHeroLevel(hero))
    for _,h in GetPlayerHeroes(player) do
        if h ~= hero and HEROES[h].faction == ACADEMY then
            AddHeroCreatureType(player, h, ACADEMY, 1, amount)
        end
    end
end

function Routine_AssembleGargoyles(player, hero)
    print("$ Routine_AssembleGargoyles")
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
    print("$ Routine_FixDestroyedGolems")
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
                AddHeroCreatures(hero, creature, rez)
            end
        end
    end
    if total > 0 then
        ShowFlyingSign({"/Text/Game/Scripts/HeroSpe/AssembleGargoyles.txt"; num=total}, hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_GenerateGoldsPerDjinn(player, hero)
    print("$ Routine_GenerateGoldsPerDjinn")
    local djinns = CountHeroCreatureType(player, hero, ACADEMY, 5)
    local amount = GetHeroLevel(hero) * djinns
    AddPlayerResource(player, hero, GOLD, amount)
end

function Routine_RespawnDjinns(player, hero, combatIndex)
    print("$ Routine_RespawnDjinns")
    AddHeroCreatureType(player, hero, ACADEMY, 5, nb)
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
    print("$ Routine_AddRecruitsRakshasas")
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

function Routine_ActivateArtfsetNecro(player, hero)
    print("$ Routine_ActivateArtfsetNecro")
    GiveArtifact(hero, 251, 1)
    GiveArtifact(hero, 252, 1)
end

function Routine_AddRecruitsMages(player, hero)
    print("$ Routine_AddRecruitsMages")
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

function Routine_AddOtherHeroesExperience(player, hero)
    print("$ Routine_AddOtherHeroesExperience")
    local exp = round(0.01 * GetHeroStat(hero, STAT_EXPERIENCE))
    for _,h in GetPlayerHeroes(player) do
        if h ~= hero then
            AddHeroStatAmount(player, h, STAT_EXPERIENCE, exp)
        end
    end
end

function Routine_RefreshTimeShift(player, hero)
    print("$ Routine_RefreshTimeShift")
    ControlHeroCustomAbility(hero, CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED)
end

function Routine_AddHeroEaglesPerWeek(player, hero)
    print("$ Routine_AddHeroEaglesPerWeek")
    AddHeroCreaturePerLevel(player, hero, CREATURE_SNOW_APE, 0.2)
end

function Routine_AddHeroEaglePerLevel(player, hero, level)
    print("$ Routine_AddHeroEaglePerLevel")
    AddHeroCreaturePerLevel(player, hero, CREATURE_SNOW_APE, 0.2)
end

function Routine_EvolveEagleToPhoenix(player, hero)
    print("$ Routine_EvolveEagleToPhoenix")
    for town,data in MAP_TOWNS do
        if data.faction == ACADEMY then
            if IsHeroInTown(hero, town, 0, 1) then
                local mana = GetHeroStat(hero, STAT_MANA_POINTS)
                local crystals = GetPlayerResource(player, CRYSTAL)
                local eagles = GetHeroCreatures(hero, CREATURE_SNOW_APE)
                local max = min(trunc(0.02*mana), trunc(0.34*crystals))
                local amount = min(max, eagles)
                if amount > 0 then
                    ChangeHeroStat(hero, STAT_MOVE_POINTS, -9999)
                    RemoveHeroCreatures(hero, CREATURE_SNOW_APE, amount)
                    AddHeroCreatures(hero, CREATURE_PHOENIX, amount)
                end
            end
        end
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- DUNGEON

function Routine_GenerateGoldPerScout(player, hero)
    print("$ Routine_GenerateGoldPerScout")
    local mult = trunc(GetHeroLevel(hero) * 0.2)
    if mult > 0 then
        local amount = 0
        amount = amount + GetHeroCreatures(hero, CREATURE_SCOUT)
        amount = amount + GetHeroCreatures(hero, CREATURE_ASSASSIN)
        amount = amount + GetHeroCreatures(hero, CREATURE_STALKER)
        AddPlayerResource(player, hero, GOLD, amount * mult)
    end
end

function Routine_AddHeroRiders(player, hero)
    print("$ Routine_AddHeroRiders")
    local amount = round(0.12 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, DUNGEON, 4, amount)
end

function Routine_GainDragonArtifacts(player, hero, combatIndex)
    print("$ Routine_GainDragonArtifacts")
    local level = GetHeroLevel(hero)
    local rnd = random(1,100,level)
    if (2 * level + 5) > rnd then
        local i = mod(rnd, 8) + 1
        local a = ARTIFACT_SETS[ARTIFACT_SET_DRAGON][i]
        GiveArtifact(hero, a)
    end
end

function Routine_ConvertKnowledgeToSpellpower(player, hero, level)
    print("$ Routine_ConvertKnowledgeToSpellpower")
    local diff = GetHeroStat(hero, STAT_KNOWLEDGE) - level
    if diff > 0 then
        ChangeHeroStat(hero, STAT_KNOWLEDGE, -diff)
        ChangeHeroStat(hero, STAT_SPELL_POWER, diff)
        ShowFlyingSign({"/Text/Game/Scripts/Stats/Spellpower.txt"; num=diff}, hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_AddHeroLevel(player, hero, level)
    print("$ Routine_AddHeroLevel")
    if mod(level, 6) == 0 then
        LevelUpHero(hero)
    end
end

function Routine_ActivateArtfsetEnlightenment(player, hero)
    print("$ Routine_ActivateArtfsetEnlightenment")
    GiveArtifact(hero, 230, 1)
    GiveArtifact(hero, 231, 1)
end

function Routine_ActivateArtfsetDungeon(player, hero)
    print("$ Routine_ActivateArtfsetDungeon")
    GiveArtifact(hero, 236, 1)
    GiveArtifact(hero, 237, 1)
    TeachHeroRandomSpell(player, hero, SPELL_SCHOOL_DESTRUCT, 5)
end

Var_Sephinroth_Bonus = 0
function Routine_CheckHallOfIntrigue(player, hero)
    print("$ Routine_CheckHallOfIntrigue")
    local nb_halls = 0
    for _,town in GetObjectNamesByType("TOWN_DUNGEON") do
        if GetTownBuildingLevel(town, TOWN_BUILDING_DUNGEON_HALL_OF_INTRIGUE) > 0 then
            nb_halls = nb_halls + 1
        end
    end
    local diff = nb_halls - Var_Sephinroth_Bonus
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_SPELL_POWER, diff)
    end
end

function Routine_UpgradeToWitches(player, hero)
    print("$ Routine_UpgradeToWitches")
    local max_bloodwitch = GetHeroLevel(hero) * 2
    TransformTownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_SCOUT, TOWN_BUILDING_DWELLING_2, CREATURE_WITCH, max_bloodwitch)
    local max_shadowwitch = trunc(GetHeroLevel(hero) * 0.5)
    TransformTownRecruits(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_RIDER, TOWN_BUILDING_DWELLING_5, CREATURE_MATRON, max_shadowwitch)
end

function Routine_AddHeroManticores(player, hero)
    print("$ Routine_AddHeroManticores")
    AddHeroCreaturePerLevel(player, hero, CREATURE_MANTICORE, 0.3)
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- NECROPOLIS

function Routine_HeroCallVampires(player, hero)
    print("$ Routine_HeroCallVampires")
    local amount = trunc(0.7 * GetHeroLevel(hero))
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_VAMPIRE, amount)
    sleep(10)
    TransferCreatureFromTown(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_NOSFERATU, 1.2)
end

function Routine_AddHeroBlackKnights(player, hero)
    print("$ Routine_AddHeroBlackKnights")
    AddHeroCreaturePerLevel(player, hero, CREATURE_BLACK_KNIGHT, 0.25)
end

function Routine_EvolveBlackKnights(player, hero, combatIndex)
    print("$ Routine_EvolveBlackKnights")
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
    print("$ Routine_AddRecruitsNecropolis")
    local amount1 = trunc(2.5 * GetHeroLevel(hero))
    local amount2 = trunc(1.3 * GetHeroLevel(hero))
    local amount3 = trunc(0.5 * GetHeroLevel(hero))
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_SKELETON, amount1)
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_2, CREATURE_WALKING_DEAD, amount2)
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_3, CREATURE_MANES, amount3)
end

function Routine_AddHeroMummies(player, hero)
    print("$ Routine_AddHeroMummies")
    AddHeroCreaturePerLevel(player, hero, CREATURE_MUMMY, 0.3)
end

function Routine_AddHeroBanshees(player, hero)
    print("$ Routine_AddHeroBanshees")
    AddHeroCreaturePerLevel(player, hero, CREATURE_BANSHEE, 0.06)
end

function Routine_GiveSandrosCloak(player, hero)
    print("$ Routine_GiveSandrosCloak")
    GiveArtifact(hero, ARTIFACT_SANDROS_CLOAK, 1)
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- INFERNO

function Routine_NightmareWeeklyProd(player, hero)
    print("$ Routine_NightmareWeeklyProd")
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_5, CREATURE_NIGHTMARE, 1)
end

function Routine_AddHeroHellHounds(player, hero)
    print("$ Routine_AddHeroHellHounds")
    local amount = round(0.90 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, INFERNO, 3, amount)
end

function Routine_RestoreManaAfterBattle(player, hero, combatIndex)
    print("$ Routine_RestoreManaAfterBattle")
    ChangeHeroStat(hero, STAT_MANA_POINTS, GetHeroLevel(hero))
end

function Routine_GainAttackPerLevel(player, hero, level)
    print("$ Routine_GainAttackPerLevel")
    if mod(level, 5) == 0 then
        AddHeroStatAmount(player, hero, STAT_ATTACK, 1)
    end
end

function Routine_ActivateArtfsetHunter(player, hero)
    print("$ Routine_ActivateArtfsetHunter")
    GiveArtifact(hero, 232, 1)
    GiveArtifact(hero, 233, 1)
end

function Routine_AddHeroSuccubus(player, hero)
    print("$ Routine_AddHeroSuccubus")
    AddHeroCreatureType(player, hero, INFERNO, 4, GetHeroLevel(hero))
end

function Routine_GainBonusExpAndRes(player, hero, combatIndex)
    print("$ Routine_GainBonusExpAndRes")
    local total = 0
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 0)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 0, i)
        local tier = CREATURES[creature][2]
        local value = tier + power(2, tier)
        total = total + count * value
    end
    AddHeroStatAmount(player, hero, STAT_EXPERIENCE, total)
    AddPlayerResource(player, hero, GOLD, trunc(0.5*total))
end

function Routine_TownBuildingUp(player, hero)
    print("$ Routine_TownBuildingUp")
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
                    [TOWN_BUILDING_INFERNO_SACRIFICIAL_PIT] = {5500},
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
    print("$ Routine_GenerateSulfur")
    local amount = trunc(0.2 * GetHeroLevel(hero))
    AddPlayerResource(player, hero, SULFUR, amount)
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- STRONGHOLD

function Routine_AddRecruitsCentaurs(player, hero)
    print("$ Routine_AddRecruitsCentaurs")
    local amount = trunc(0.75 * GetHeroLevel(hero))
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_CENTAUR, amount)
end

Var_Gorshak_BattleWon = 0
function Routine_GainAttackDefense(player, hero, combatIndex)
    print("$ Routine_GainAttackDefense")
    Var_Gorshak_BattleWon = Var_Gorshak_BattleWon + 1
    if mod(Var_Gorshak_BattleWon, 10) == 0 then
        AddHeroStatAmount(player, hero, STAT_ATTACK, 1)
        AddHeroStatAmount(player, hero, STAT_DEFENCE, 1)
    end
end

function Routine_AddHeroWyverns(player, hero)
    print("$ Routine_AddHeroWyverns")
    local amount = round(0.22 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, STRONGHOLD, 6, amount)
end

function Routine_ActivateArtfsetSarIssus(player, hero)
    print("$ Routine_ActivateArtfsetSarIssus")
    GiveArtifact(hero, 247, 1)
    GiveArtifact(hero, 248, 1)
end

function Routine_AddRecruitsShamans(player, hero)
    print("$ Routine_AddRecruitsShamans")
    local amount = trunc(2.3 * GetHeroLevel(hero))
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_2, CREATURE_SHAMAN, amount)
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
    [H_EBBA] = Routine_GiveArtifactRuneOfFlame,
    -- academy
    [H_DAVIUS] = Routine_UpgradeSilverPavillon,
    [H_THEODORUS] = Routine_ActivateArtfsetNecro,
    [H_RISSA] = Routine_RefreshTimeShift,
    -- dungeon
    [H_RANLETH] = Routine_ActivateArtfsetEnlightenment,
    [H_SEPHINROTH] = Routine_ActivateArtfsetDungeon,
    -- necropolis
    [H_SANDRO] = Routine_GiveSandrosCloak,
    -- inferno
    [H_BIARA] = Routine_ActivateArtfsetHunter,
    -- stronghold
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
    [H_ERLING] = Routine_RunePriestDwellingUp,
    [H_EBBA] = Routine_GainSpellpowerPerRune,
    -- academy
    [H_HAVEZ] = Routine_AddOtherHeroesGremlins,
    [H_MAAHIR] = Routine_AddOtherHeroesExperience,
    [H_GALIB] = Routine_GenerateGoldsPerDjinn,
    [H_RISSA] = Routine_RefreshTimeShift,
    [H_MINASLI] = Routine_EvolveEagleToPhoenix,
    -- dungeon
    [H_VAYSHAN] = Routine_GenerateGoldPerScout,
    [H_SORGAL] = Routine_AddHeroRiders,
    -- necropolis
    [H_THANT] = Routine_AddHeroMummies,
    -- inferno
    [H_ORLANDO] = Routine_TownBuildingUp,
    [H_DELEB] = Routine_GenerateSulfur,
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
    [H_EBBA] = Routine_GenerateCrystalsAndGems,
    -- academy
    [H_RAZZAK] = Routine_AssembleGargoyles,
    [H_CYRUS] = Routine_AddRecruitsMages,
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
    [H_KUJIN] = Routine_AddRecruitsShamans,
}

LEVEL_UP_HERO_ROUTINES_HERO = {
    -- haven
    [H_NICOLAI] = Routine_GainPrimaryStats,
    -- preserve
    [H_VINRAEL] = Routine_GiveArtifactLegendaryBoots,
    -- fortress
    -- academy
    [H_MINASLI] = Routine_AddHeroEaglePerLevel,
    -- dungeon
    [H_SINITAR] = Routine_ConvertKnowledgeToSpellpower,
    [H_SHADYA] = Routine_AddHeroLevel,
    -- necropolis
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
    -- academy
    [H_RAZZAK] = Routine_FixDestroyedGolems,
    [H_GALIB] = Routine_RespawnDjinns,
    -- dungeon
    [H_RAELAG] = Routine_GainDragonArtifacts,
    -- necropolis
    [H_XERXON] = Routine_EvolveBlackKnights,
    -- inferno
    [H_SHELTEM] = Routine_RestoreManaAfterBattle,
    [H_ORLANDO] = Routine_GainBonusExpAndRes,
    -- stronghold
    [H_GORSHAK] = Routine_GainAttackDefense,
}


function DoHeroSpeRoutine_Start(player, hero)
    if START_TRIGGER_HERO_ROUTINES[hero] then
        startThread(START_TRIGGER_HERO_ROUTINES[hero], player, hero)
    end
end

function DoHeroSpeRoutine_Daily(player, hero)
    if DAILY_TRIGGER_HERO_ROUTINES[hero] then
        startThread(DAILY_TRIGGER_HERO_ROUTINES[hero], player, hero)
    end
end

function DoHeroSpeRoutine_Weekly(player, hero)
    if WEEKLY_TRIGGER_HERO_ROUTINES[hero] then
        startThread(WEEKLY_TRIGGER_HERO_ROUTINES[hero], player, hero)
    end
end

function DoHeroSpeRoutine_LevelUp(player, hero, level)
    if LEVEL_UP_HERO_ROUTINES_HERO[hero] then
        startThread(LEVEL_UP_HERO_ROUTINES_HERO[hero], player, hero, level)
    end
end

function DoHeroSpeRoutine_AfterCombat(player, hero, index)
    if AFTER_COMBAT_TRIGGER_HERO_ROUTINES[hero] then
        startThread(AFTER_COMBAT_TRIGGER_HERO_ROUTINES[hero], player, hero, index)
    end
end


-- print("Loaded heroes-routines-advmap.lua")
ROUTINES_LOADED[13] = 1
