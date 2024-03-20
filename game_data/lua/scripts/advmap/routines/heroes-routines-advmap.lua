
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
    AddHeroCreatureType(player, hero, {CREATURE_CAVALIER,CREATURE_PALADIN,CREATURE_CHAMPION}, amount)
end

function Routine_ActivateArtfsetHaven(player, hero)
    print("$ Routine_ActivateArtfsetHaven")
    GiveArtifact(hero, 244, 1)
    GiveArtifact(hero, 245, 1)
end

function Routine_AddRecruitsPeasants(player, hero)
    print("$ Routine_AddRecruitsPeasants")
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_PEASANT, 4.5)
end

function Routine_TrainPeasantsToArchersCheck(player, hero, town)
    print("$ Routine_TrainPeasantsToArchersCheck")
    local b = GetTownBuildingLevel(town, TOWN_BUILDING_HAVEN_TRAINING_GROUNDS)
    local max = GetObjectDwellingCreatures(town, CREATURE_PEASANT)
    local n = 0
    if b == 1 then n = 7 elseif b == 2 then n = 20 end
    n = min(n, max)
    if n > 0 then
        QuestionBoxForPlayers(
            GetPlayerFilter(player),
            {"/Text/Game/Scripts/HeroSpe/TrainArchers.txt"; num=n},
            "Routine_TrainPeasantsToArchersConfirm('"..player.."','"..hero.."','"..town.."','"..n.."')", "NoneRoutine"
        )
    end
end

function Routine_TrainPeasantsToArchersConfirm(player, hero, town, amount)
    print("$ Routine_TrainPeasantsToArchersConfirm")
    local peasants = GetObjectDwellingCreatures(town, CREATURE_PEASANT)
    local archers = GetObjectDwellingCreatures(town, CREATURE_ARCHER)
    SetObjectDwellingCreatures(town, TOWN_BUILDING_DWELLING_1, peasants - amount)
    SetObjectDwellingCreatures(town, TOWN_BUILDING_DWELLING_2, archers + amount)
end

function Routine_GainExpFromTotalGolds(player, hero)
    print("$ Routine_GainExpFromTotalGolds")
    local mult = trunc(GetHeroLevel(hero) * 0.1)
    local amount = GetPlayerResource(player, GOLD) * mult
    AddHeroStatAmount(player, hero, STAT_EXPERIENCE, amount)
end

function Routine_AddHeroZealots(player, hero)
    print("$ Routine_AddHeroZealots")
    AddHeroCreaturePerLevel(player, hero, CREATURE_ZEALOT, 0.1)
end

function Routine_AddTwoLuckPoints(player, hero)
    print("$ Routine_AddTwoLuckPoints")
    ChangeHeroStat(hero, STAT_LUCK, 2)
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

function Routine_RezHunters(player, hero, combatIndex)
    print("$ Routine_RezHunters")
    local max = 3 + GetHeroLevel(hero)
    ResurrectCreatureType(player, hero, combatIndex, PRESERVE, 3, max)
end

function Routine_AddHeroWolves(player, hero)
    print("$ Routine_AddHeroWolves")
    AddHeroCreaturePerLevel(player, hero, CREATURE_WOLF, 2.0)
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
    TransferCreatureFromTown(player, hero, TOWN_BUILDING_DWELLING_5, CREATURE_WHITE_UNICORN, 0.75)
end

function Routine_AddHeroSpellPower(player, hero, combatIndex)
    print("$ Routine_AddHeroSpellPower")
    AddHeroStatAmount(player, hero, STAT_SPELL_POWER, 1)
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- FORTRESS

function Routine_AddHeroDefenders(player, hero)
    print("$ Routine_AddHeroDefenders")
    local amount = round(0.40 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, {CREATURE_DEFENDER,CREATURE_STOUT_DEFENDER,CREATURE_STONE_DEFENDER}, amount)
end

function Routine_AddRecruitsBearRiders(player, hero)
    print("$ Routine_AddRecruitsBearRiders")
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_BEAR_RIDER, 1.5)
end

function Routine_RezSpearwielders(player, hero, combatIndex)
    print("$ Routine_RezSpearwielders")
    local max = 5 + trunc(1.5 * GetHeroLevel(hero))
    ResurrectCreatureType(player, hero, combatIndex, FORTRESS, 2, max)
end

function Routine_GiveArtifactRingOfMachineAffinity(player, hero)
    print("$ Routine_GiveArtifactRingOfMachineAffinity")
    GiveArtifact(hero, ARTIFACT_RING_OF_MACHINE_AFFINITY, 1)
end

function Routine_UpgradeRunePriests(player, hero)
    print("$ Routine_UpgradeRunePriests")
    UpgradeHeroCreatures(player, hero, CREATURE_RUNE_MAGE, CREATURE_FLAME_MAGE)
end

function Routine_AddLuckAndMorale(player, hero)
    print("$ Routine_AddLuckAndMorale")
    ChangeHeroStat(hero, STAT_LUCK, 2)
    ChangeHeroStat(hero, STAT_MORALE, 2)
end

function Routine_GiveArtifactRuneOfFlame(player, hero)
    print("$ Routine_GiveArtifactRuneOfFlame")
    GiveArtifact(hero, ARTIFACT_RUNE_OF_FLAME, 1)
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
    local amount = round(0.50 * GetHeroLevel(hero))
    for _,h in GetPlayerHeroes(player) do
        if h ~= hero and HEROES[h].faction == ACADEMY then
            AddHeroCreatureType(player, h, {CREATURE_GREMLIN,CREATURE_MASTER_GREMLIN,CREATURE_GREMLIN_SABOTEUR}, amount)
        end
    end
end

function Routine_AssembleGargoyles(player, hero)
    print("$ Routine_AssembleGargoyles")
    local max = 2 * GetHeroLevel(hero)
    local total = 0
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

function Routine_AddHeroDjinns(player, hero)
    print("$ Routine_AddHeroDjinns")
    local amount = round(0.30 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, {CREATURE_GENIE,CREATURE_MASTER_GENIE,CREATURE_DJINN_VIZIER}, amount)
end

function Routine_AddRecruitsRakshasas(player, hero)
    print("$ Routine_AddRecruitsRakshasas")
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_6, CREATURE_RAKSHASA, 0.2)
end

function Routine_ActivateArtfsetNecro(player, hero)
    print("$ Routine_ActivateArtfsetNecro")
    GiveArtifact(hero, 251, 1)
    GiveArtifact(hero, 252, 1)
end

function Routine_UpgradeMages(player, hero)
    print("$ Routine_UpgradeMages")
    UpgradeHeroCreatures(player, hero, CREATURE_MAGI, CREATURE_ARCH_MAGI)
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

function Routine_AddHeroEagles(player, hero)
    print("$ Routine_AddHeroEagles")
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
    AddHeroCreatureType(player, hero, {CREATURE_RIDER,CREATURE_RAVAGER,CREATURE_BLACK_RIDER}, amount)
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
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_VAMPIRE, 0.8)
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
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_SKELETON, 2.5)
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_2, CREATURE_WALKING_DEAD, 1.25)
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_3, CREATURE_MANES, 0.5)
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

function Routine_TransferNightmares(player, hero)
    print("$ Routine_TransferNightmares")
    TransferCreatureFromTown(player, hero, TOWN_BUILDING_DWELLING_5, CREATURE_NIGHTMARE, 0.4)
end

function Routine_AddHeroHellHounds(player, hero)
    print("$ Routine_AddHeroHellHounds")
    local amount = round(0.90 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, {CREATURE_HELL_HOUND,CREATURE_CERBERI,CREATURE_FIREBREATHER_HOUND}, amount)
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

function Routine_RezSuccubus(player, hero, combatIndex)
    print("$ Routine_RezSuccubus")
    local cap = 3 + trunc(0.66 * GetHeroLevel(hero))
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 1)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 1, i)
        if died > 0 and contains({CREATURE_SUCCUBUS,CREATURE_INFERNAL_SUCCUBUS,CREATURE_SUCCUBUS_SEDUCER}, creature) then
            local rez = min(cap, died)
            cap = cap - rez
            AddHeroCreatures(hero, creature, rez)
        end
    end
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
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_CENTAUR, 0.75)
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
    AddHeroCreatureType(player, hero, {CREATURE_WYVERN,CREATURE_WYVERN_POISONOUS,CREATURE_WYVERN_PAOKAI}, amount)
end

function Routine_ActivateArtfsetSarIssus(player, hero)
    print("$ Routine_ActivateArtfsetSarIssus")
    GiveArtifact(hero, 247, 1)
    GiveArtifact(hero, 248, 1)
end

function Routine_AddRecruitsShamans(player, hero)
    print("$ Routine_AddRecruitsShamans")
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_2, CREATURE_SHAMAN, 2.4)
end






START_TRIGGER_HERO_ROUTINES = {
    -- haven
    [H_LASZLO] = Routine_ActivateArtfsetHaven,
    [H_ISABEL] = Routine_AddTwoLuckPoints,
    -- preserve
    -- fortress
    [H_WULFSTAN] = Routine_GiveArtifactRingOfMachineAffinity,
    [H_TOLGHAR] = Routine_AddLuckAndMorale,
    [H_EBBA] = Routine_GiveArtifactRuneOfFlame,
    -- academy
    [H_THEODORUS] = Routine_ActivateArtfsetNecro,
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
    [H_ALARIC] = Routine_AddHeroZealots,
    [H_MAEVE] = Routine_DoublePeasantTax,
    -- preserve
    -- fortress
    [H_INGVAR] = Routine_AddHeroDefenders,
    [H_ERLING] = Routine_UpgradeRunePriests,
    -- academy
    [H_HAVEZ] = Routine_AddOtherHeroesGremlins,
    [H_CYRUS] = Routine_UpgradeMages,
    [H_MAAHIR] = Routine_AddOtherHeroesExperience,
    [H_MINASLI] = Routine_EvolveEagleToPhoenix,
    -- dungeon
    [H_VAYSHAN] = Routine_GenerateGoldPerScout,
    [H_SORGAL] = Routine_AddHeroRiders,
    -- necropolis
    [H_THANT] = Routine_AddHeroMummies,
    -- inferno
    [H_DELEB] = Routine_GenerateSulfur,
    -- stronghold
}

WEEKLY_TRIGGER_HERO_ROUTINES = {
    -- haven
    [H_MAEVE] = Routine_AddRecruitsPeasants,
    [H_KLAUS] = Routine_AddHeroCavaliers,
    [H_NICOLAI] = Routine_GainExpFromTotalGolds,
    -- preserve
    [H_KYRRE] = Routine_AddHeroExperience,
    [H_IVOR] = Routine_AddHeroWolves,
    [H_YLTHIN] = Routine_HeroCallUnicorns,
    -- fortress
    [H_ROLF] = Routine_AddRecruitsBearRiders,
    [H_EBBA] = Routine_GenerateCrystalsAndGems,
    -- academy
    [H_RAZZAK] = Routine_AssembleGargoyles,
    [H_GALIB] = Routine_AddHeroDjinns,
    [H_DAVIUS] = Routine_AddRecruitsRakshasas,
    [H_MINASLI] = Routine_AddHeroEagles,
    -- dungeon
    [H_SHADYA] = Routine_UpgradeToWitches,
    [H_LETHOS] = Routine_AddHeroManticores,
    -- necropolis
    [H_LUCRETIA] = Routine_HeroCallVampires,
    [H_RAVEN] = Routine_AddRecruitsNecropolis,
    [H_XERXON] = Routine_AddHeroBlackKnights,
    [H_DEIRDRE] = Routine_AddHeroBanshees,
    -- inferno
    [H_GROK] = Routine_TransferNightmares,
    [H_GRAWL] = Routine_AddHeroHellHounds,
    -- stronghold
    [H_GARUNA] = Routine_AddRecruitsCentaurs,
    [H_KARUKAT] = Routine_AddHeroWyverns,
    [H_KUJIN] = Routine_AddRecruitsShamans,
}

LEVEL_UP_HERO_ROUTINES_HERO = {
    -- haven
    -- preserve
    -- fortress
    -- academy
    -- dungeon
    [H_SINITAR] = Routine_ConvertKnowledgeToSpellpower,
    [H_SHADYA] = Routine_AddHeroLevel,
    -- necropolis
    -- inferno
    [H_ASH] = Routine_GainAttackPerLevel,
    -- stronghold
}

AFTER_COMBAT_TRIGGER_HERO_ROUTINES = {
    -- haven
    -- preserve
    [H_KYRRE] = Routine_KyrreVictoryCounter,
    [H_FINDAN] = Routine_RezHunters,
    [H_ELLESHAR] = Routine_AddHeroSpellPower,
    [H_YLTHIN] = Routine_YlthinVictoryCounter,
    -- fortress
    [H_KARLI] = Routine_RezSpearwielders,
    -- academy
    -- dungeon
    [H_RAELAG] = Routine_GainDragonArtifacts,
    -- necropolis
    [H_XERXON] = Routine_EvolveBlackKnights,
    -- inferno
    [H_BIARA] = Routine_RezSuccubus,
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
