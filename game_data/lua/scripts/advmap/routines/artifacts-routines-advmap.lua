
function Routine_ArtifactPouchOfGolds(player, hero)
    log("$ Routine_ArtifactPouchOfGolds")
    local level = GetHeroLevel(hero)
    AddPlayerResource(player, hero, GOLD, level * 25)
end

function Routine_ArtifactSackOfGolds(player, hero)
    log("$ Routine_ArtifactSackOfGolds")
    local level = GetHeroLevel(hero)
    AddPlayerResource(player, hero, GOLD, level * 50)
end

function Routine_ArtifactHornOfPlenty(player, hero)
    log("$ Routine_ArtifactHornOfPlenty")
    AddPlayerResource(player, hero, WOOD, 1)
    AddPlayerResource(player, hero, ORE, 1)
    AddPlayerResource(player, hero, MERCURY, 1)
    AddPlayerResource(player, hero, CRYSTAL, 1)
    AddPlayerResource(player, hero, SULFUR, 1)
    AddPlayerResource(player, hero, GEM, 1)
end

function Routine_ArtifactCapeOfKings(player, hero)
    log("$ Routine_ArtifactCapeOfKings")
    if GetDate(DAY_OF_WEEK) ~= 1 then
        if HasHeroSkill(hero, PERK_MYTHOLOGY) then
            Routine_MythologyWeeklyGolds(player, hero, 1)
        end
    end
end

Var_BootsOfSwiftJourneyCheck = {}
function Routine_ArtifactBootsOfSwiftJourney(player, hero)
    log("$ Routine_ArtifactBootsOfSwiftJourney")
    Var_BootsOfSwiftJourneyCheck[hero] = not nil
    while IsPlayerCurrent(player) do
        sleep(100)
        if HasArtefact(hero, ARTIFACT_BOOTS_OF_THE_SWIFT_JOUNREY, 1) then
            if Var_BootsOfSwiftJourneyCheck[hero] then
                if GetHeroStat(hero, STAT_MOVE_POINTS) < 100 then
                    ChangeHeroStat(hero, STAT_MOVE_POINTS, 1000)
                    return
                end
            else return end
        else return end
    end
end

function Routine_ArtifactBootsOfSwiftJourneyCancel(player, hero, combatIndex)
    log("$ Routine_ArtifactBootsOfSwiftJourneyCancel")
    Var_BootsOfSwiftJourneyCheck[hero] = nil
end

function Routine_ArtifactBackpackOfOpenRoad(player, hero, level)
    log("$ Routine_ArtifactBackpackOfOpenRoad")
    ChangeHeroStat(hero, STAT_MOVE_POINTS, 9999)
end

function Routine_ArtifactSentinelsHelm(player, hero, level)
    log("$ Routine_ArtifactSentinelsHelm")
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_ATTACK, 2)
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_DEFENCE, 2)
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_MORALE, 2)
end

function Routine_ArtifactSentinelsBoots(player, hero, combatIndex)
    log("$ Routine_ArtifactSentinelsBoots")
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 1)
	for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 1, i)
        if died ~= 0 then return end
    end
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_MORALE, 2)
    ChangeHeroStat(hero, STAT_MOVE_POINTS, 500)
end

function Routine_ArtifactDeathknightBoots(player, hero, combatIndex)
    log("$ Routine_ArtifactDeathknightBoots")
    local value = trunc(0.1 * GetArmyStrength(combatIndex, 0))
    ChangeHeroStat(hero, STAT_MOVE_POINTS, value)
    ChangeHeroStat(hero, STAT_EXPERIENCE, value)
end

function Routine_ArtifactRobeOfTheMagister(player, hero)
    log("$ Routine_ArtifactRobeOfTheMagister")
    local amount = 75 * GetHeroStat(hero, STAT_KNOWLEDGE)
    ChangeHeroStat(hero, STAT_EXPERIENCE, 2 * amount)
    for _,h in GetPlayerHeroes(player) do
        if h ~= hero then
            ChangeHeroStat(h, STAT_EXPERIENCE, amount)
        end
    end
end

function Routine_ArtifactSmithyHammer(player, hero)
    log("$ Routine_ArtifactSmithyHammer")
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_ATTACK, 3)
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_DEFENCE, 3)
end

function Routine_ArtifactMagistersSandals(player, hero)
    log("$ Routine_ArtifactMagistersSandals")
    ChangeHeroStat(hero, STAT_KNOWLEDGE, 1)
end

function Routine_ArtifactVizirsCap(player, hero)
    log("$ Routine_ArtifactVizirsCap")
    local total = 0
    for _,obj in Dwellings_T1 do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then total = total + 500 end
        end
    end
    for _,obj in Dwellings_T2 do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then total = total + 500 end
        end
    end
    for _,obj in Dwellings_T3 do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then total = total + 500 end
        end
    end
    for _,obj in Dwellings_MP do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then total = total + 500 end
        end
    end
    AddPlayerResource(player, hero, GOLD, total)
end

function Routine_ArtifactVizirsScimitar(player, hero)
    log("$ Routine_ArtifactVizirsScimitar")
    local faction = HEROES[hero].faction
    for _,town in GetHeroTowns(player, hero) do
        if GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_1) ~= 0 then
            local creature = CREATURES_BY_FACTION[faction][1][1]
            local current = GetObjectDwellingCreatures(town, creature)
            SetObjectDwellingCreatures(town, creature, current + 10)
        end
        if GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_2) ~= 0 then
            local creature = CREATURES_BY_FACTION[faction][2][1]
            local current = GetObjectDwellingCreatures(town, creature)
            SetObjectDwellingCreatures(town, creature, current + 10)
        end
    end
end

function Routine_ArtifactPalaceShoes(player, hero, combatIndex)
    log("$ Routine_ArtifactPalaceShoes")
    local bonus_table = {
        [HERO_BATTLE_BONUS_LUCK] = 1,
        [HERO_BATTLE_BONUS_MORALE] = 1,
        [HERO_BATTLE_BONUS_ATTACK] = 3,
        [HERO_BATTLE_BONUS_DEFENCE] = 3,
        [HERO_BATTLE_BONUS_HITPOINTS] = 6,
        [HERO_BATTLE_BONUS_INITIATIVE] = 2,
        [HERO_BATTLE_BONUS_SPEED] = 1,
    }
    local r = random(0,13,0)
    for k,v in bonus_table do
        if (mod(r,7) == k) or (mod(2*r,7) == k) then GiveHeroBattleBonus(hero, k, v) end
    end
end

function Routine_ArtifactRingOfTheUnrepentant(player, hero, combatIndex)
    log("$ Routine_ArtifactRingOfTheUnrepentant")
    local total = 0
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 1)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 1, i)
        if died > 0 then
            total = total + died
        end
    end
    if total > 0 then
        ChangeHeroStat(hero, STAT_MANA_POINTS, total)
    end
end

function Routine_ArtifactEldenaRedScarf(player, hero)
    log("$ Routine_ArtifactEldenaRedScarf")
    local nb = 5
    for k = 1,WEEKS,4 do nb = 2 * nb end
    AddHeroCreatureType(player, hero, HEROES[hero].faction, 1, nb, 1)
end

function Routine_ArtifactEldenaRedCoat(player, hero)
    log("$ Routine_ArtifactEldenaRedCoat")
    local nb = 4
    for k = 1,WEEKS,4 do nb = 2 * nb end
    AddHeroCreatureType(player, hero, HEROES[hero].faction, 2, nb, 1)
end

function Routine_ArtifactEldenaCirclet(player, hero)
    log("$ Routine_ArtifactEldenaCirclet")
    local nb = 3
    for k = 1,WEEKS,4 do nb = 2 * nb end
    AddHeroCreatureType(player, hero, HEROES[hero].faction, 3, nb, 1)
end


function Routine_ArtifactBeginnerMagicStick(player, hero, combatIndex)
    log("$ Routine_ArtifactBeginnerMagicStick")
    ChangeHeroStat(hero, STAT_MANA_POINTS, 10)
end

function Routine_ArtifactRunicWar(player, hero, combatIndex)
    log("$ Routine_ArtifactRunicWar")
    ChangeHeroStat(hero, STAT_MANA_POINTS, 25)
end

function Routine_ArtifactHelmOfWarmage(player, hero, level)
    log("$ Routine_ArtifactHelmOfWarmage")
    local maxtier = min(2 + trunc(0.2 * level), 5)
    TeachHeroRandomSpell(player, hero, SPELL_SCHOOL_ANY, maxtier)
end

function Routine_ArtifactVikingHatchet(player, hero, combatIndex)
    log("$ Routine_ArtifactVikingHatchet")
    local value = GetArmyStrength(combatIndex, 0)
    AddPlayerResource(player, hero, GOLD, round(0.3 * value))
end

function Routine_ArtifactVikingShield(player, hero, combatIndex)
    log("$ Routine_ArtifactVikingShield")
    local value = GetArmyStrength(combatIndex, 0)
    local split = random(0,4,value)
    AddPlayerResource(player, hero, WOOD, round(0.001 * split * value))
    AddPlayerResource(player, hero, ORE, round(0.001 * (4-split) * value))
end

Var_StaffLyreVictories = {}
function Routine_ArtifactStaffOfTheLyre(player, hero, combatIndex)
    log("$ Routine_ArtifactStaffOfTheLyre")
    if Var_StaffLyreVictories[hero] then
        local nb = Var_StaffLyreVictories[hero] + 1
        Var_StaffLyreVictories[hero] = nb
        if mod(nb, 5) == 0 then
            AddHeroLowestStat(player, hero, 1)
        end
    else
        Var_StaffLyreVictories[hero] = 1
    end
end

Var_PendantLyreVictories = {}
function Routine_ArtifactPendantOfTheLyre(player, hero, combatIndex)
    log("$ Routine_ArtifactPendantOfTheLyre")
    if Var_PendantLyreVictories[hero] then
        local nb = Var_PendantLyreVictories[hero] + 1
        Var_PendantLyreVictories[hero] = nb
        if mod(nb, 5) == 0 then
            local exp = 1000 + trunc(0.01 * GetHeroStat(hero, STAT_EXPERIENCE))
            AddHeroStatAmount(player, hero, STAT_EXPERIENCE, exp)
            -- AddHeroManaUnbound(player, hero, 100)
        end
    else
        Var_PendantLyreVictories[hero] = 1
    end
end

function Routine_ArtifactBloodCrystalCount(hero)
    local nb = 0
    repeat
        nb = nb + 1
        RemoveArtefact(hero, ARTIFACT_BLOOD_CRYSTAL) sleep()
    until not HasArtefact(hero, ARTIFACT_BLOOD_CRYSTAL, 0)
    for i = 1,nb do GiveArtifact(hero, ARTIFACT_BLOOD_CRYSTAL) end
    return nb
end

function Routine_ArtifactBloodCrystalExp(player, hero)
    log("$ Routine_ArtifactBloodCrystalExp")
    local nb = Routine_ArtifactBloodCrystalCount(hero)
    AddHeroStatAmount(player, hero, STAT_EXPERIENCE, nb * 250)
end

function Routine_ArtifactBloodCrystalWitches(player, hero)
    log("$ Routine_ArtifactBloodCrystalWitches")
    local nb = Routine_ArtifactBloodCrystalCount(hero)
    AddHeroTownRecruits(player, hero, TOWN_BUILDING_DWELLING_2, CREATURE_WITCH, nb)
end

function Routine_ArtifactBloodCrystalStat(player, hero, level)
    log("$ Routine_ArtifactBloodCrystalStat")
    local nb = Routine_ArtifactBloodCrystalCount(hero)
    ChangeHeroStat(hero, STAT_MOVE_POINTS, nb * 250)
    AddHeroManaUnbound(player, hero, nb * 10)
end

--------------------------------------------------------------------------------------------------------------------------------

function Routine_ArtfsetWanderer(player, hero)
    local mastery = GetHeroSkillMastery(hero, SKILL_LOGISTICS)
    if mastery > 0 then
        Routine_LogisticsWeeklyProd(player, hero, mastery)
    end
end

function Routine_ArtfsetSailor(player, hero)
    log("$ Routine_ArtfsetSailor")
    if IsHeroInBoat(hero) then
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 1000)
    end
end


function Routine_ArtfsetEldena(player, hero)
    log("$ Routine_ArtfsetEldena")
    local faction = HEROES[hero].faction
    local nb4 = 2
    local nb5 = 1
    for k = 1,WEEKS,4 do
        nb4 = 2 * nb4
        nb5 = 2 * nb5
    end
    AddHeroCreatureType(player, hero, faction, 4, nb4, 1)
    AddHeroCreatureType(player, hero, faction, 5, nb5, 1)
end

function Routine_ArtfsetEnlighten(player, hero)
    log("$ Routine_ArtfsetEnlighten")
    AddHeroLowestStat(player, hero, 2)
end

function Routine_ArtfsetWarmage(player, hero)
    log("$ Routine_ArtfsetWarmage")
    local gain = 1
    for s = 9,12 do
        if GetHeroSkillMastery(hero, s) == 3 then
            gain = gain + 2
        end
    end
    ChangeHeroStat(hero, STAT_SPELL_POWER, gain)
    ChangeHeroStat(hero, STAT_KNOWLEDGE, gain)
end

Var_MoonLevelUp = {}
function Routine_ArtfsetMoon(player, hero)
    log("$ Routine_ArtfsetMoon")
    if Var_MoonLevelUp[hero] then
        LevelUpHero(hero)
        Var_MoonLevelUp[hero] = nil
    else
        Var_MoonLevelUp[hero] = not nil
    end
end

function Routine_ArtfsetVizir(player, hero, combatIndex)
    log("$ Routine_ArtfsetVizir")
    local value = GetArmyStrength(combatIndex, 0)
    local class = ARTIFACT_CLASS_MINOR
    if value > 99999 then class = ARTIFACT_CLASS_RELIC
    elseif value > 9999 then class = ARTIFACT_CLASS_MAJOR
    end
    GiveHeroRandomArtifact(player, hero, class)
end

function Routine_ArtfsetGenji2(player, hero, combatIndex)
    log("$ Routine_ArtfsetGenji2")
    local max = 10 * GetHeroStat(hero, STAT_KNOWLEDGE)
    local diff = GetHeroStat(hero, STAT_MANA_POINTS) - max
    if diff > 0 then
        ChangeHeroStat(hero, STAT_MANA_POINTS, -diff)
        ChangeHeroStat(hero, STAT_EXPERIENCE, 100 * diff)
    end
end



CONTINUOUS_TRIGGER_ARTIFACTS_ROUTINES = {
}
DAILY_TRIGGER_ARTIFACTS_ROUTINES = {
    [ARTIFACT_ENDLESS_POUCH_OF_GOLD] = Routine_ArtifactPouchOfGolds,
    [ARTIFACT_ENDLESS_SACK_OF_GOLD] = Routine_ArtifactSackOfGolds,
    [ARTIFACT_CAPE_OF_KINGS] = Routine_ArtifactCapeOfKings,
    [ARTIFACT_BOOTS_OF_THE_SWIFT_JOUNREY] = Routine_ArtifactBootsOfSwiftJourney,
    [ARTIFACT_ROBE_OF_THE_MAGISTER] = Routine_ArtifactRobeOfTheMagister,
    [ARTIFACT_DWARVEN_SMITHY_HAMMER] = Routine_ArtifactSmithyHammer,
}
WEEKLY_TRIGGER_ARTIFACTS_ROUTINES = {
    [ARTIFACT_HORN_OF_PLENTY] = Routine_ArtifactHornOfPlenty,
    [ARTIFACT_MAGISTERS_SANDALS] = Routine_ArtifactMagistersSandals,
    [ARTIFACT_VIZIRS_CAP] = Routine_ArtifactVizirsCap,
    [ARTIFACT_VIZIRS_SCIMITAR] = Routine_ArtifactVizirsScimitar,
}
LEVELUP_TRIGGER_ARTIFACTS_ROUTINES = {
    [ARTIFACT_BACKPACK_OF_THE_OPEN_ROAD] = Routine_ArtifactBackpackOfOpenRoad,
    [ARTIFACT_SENTINELS_HELM] = Routine_ArtifactSentinelsHelm,
    [ARTIFACT_HELM_OF_THE_WARMAGE] = Routine_ArtifactHelmOfWarmage,
    [ARTIFACT_ELDENAS_RED_SCARF] = Routine_ArtifactEldenaRedScarf,
    [ARTIFACT_ELDENAS_RED_COAT] = Routine_ArtifactEldenaRedCoat,
    [ARTIFACT_ELDENAS_CIRCLET] = Routine_ArtifactEldenaCirclet,
}
AFTER_COMBAT_TRIGGER_ARTIFACTS_ROUTINES = {
    [ARTIFACT_BOOTS_OF_THE_SWIFT_JOUNREY] = Routine_ArtifactBootsOfSwiftJourneyCancel,
    [ARTIFACT_BEGINNER_MAGIC_STICK] = Routine_ArtifactBeginnerMagicStick,
    [ARTIFACT_SENTINELS_BOOTS] = Routine_ArtifactSentinelsBoots,
    [ARTIFACT_RING_OF_THE_UNREPENTANT] = Routine_ArtifactRingOfTheUnrepentant,
    [ARTIFACT_RUNIC_WAR_AXE] = Routine_ArtifactRunicWar,
    [ARTIFACT_RUNIC_WAR_HARNESS] = Routine_ArtifactRunicWar,
    [ARTIFACT_DEATH_KNIGHT_BOOTS] = Routine_ArtifactDeathknightBoots,
    [ARTIFACT_VIKING_HATCHET] = Routine_ArtifactVikingHatchet,
    [ARTIFACT_VIKING_SHIELD] = Routine_ArtifactVikingShield,
    [ARTIFACT_PALACE_SHOES] = Routine_ArtifactPalaceShoes,
    [ARTIFACT_PENDANT_OF_THE_LYRE] = Routine_ArtifactPendantOfTheLyre,
    [ARTIFACT_STAFF_OF_THE_LYRE] = Routine_ArtifactStaffOfTheLyre,
}

CONTINUOUS_TRIGGER_ARTFSETS_ROUTINES = {
    [ARTFSET_SAILOR_3PC] = Routine_ArtfsetSailor,
}
DAILY_TRIGGER_ARTFSETS_ROUTINES = {
    [ARTFSET_NONE] = NoneRoutine,
}
WEEKLY_TRIGGER_ARTFSETS_ROUTINES = {
    [ARTFSET_WANDERER_2PC] = Routine_ArtfsetWanderer,
}
LEVELUP_TRIGGER_ARTFSETS_ROUTINES = {
    [ARTFSET_ELDENA_3PC] = Routine_ArtfsetEldena,
    [ARTFSET_ENLIGHTEN_4PC] = Routine_ArtfsetEnlighten,
    [ARTFSET_WARMAGE_5PC] = Routine_ArtfsetWarmage,
    [ARTFSET_MOON_4PC] = Routine_ArtfsetMoon,
}
AFTER_COMBAT_TRIGGER_ARTFSETS_ROUTINES = {
    [ARTFSET_VIZIR_4PC] = Routine_ArtfsetVizir,
    [ARTFSET_GENJI_4PC] = Routine_ArtfsetGenji2,
}


function DoArtifactsRoutine_Continuous(player, hero)
    -- log("$ DoArtifactsRoutine_Continuous - "..hero)
    for k,v in CONTINUOUS_TRIGGER_ARTIFACTS_ROUTINES do
        if HasArtefact(hero, k, 1) then
            startThread(v, player, hero)
        end
    end
    for k,v in CONTINUOUS_TRIGGER_ARTFSETS_ROUTINES do
        if HERO_ARTFSETS_STATUS[hero][k] == 1 then
            startThread(v, player, hero)
        end
    end
end

function DoArtifactsRoutine_Daily(player, hero)
    log("$ DoArtifactsRoutine_Daily - "..hero)
    for k,v in DAILY_TRIGGER_ARTIFACTS_ROUTINES do
        if HasArtefact(hero, k, 1) then
            startThread(v, player, hero)
        end
    end
    for k,v in DAILY_TRIGGER_ARTFSETS_ROUTINES do
        if HERO_ARTFSETS_STATUS[hero][k] == 1 then
            startThread(v, player, hero)
        end
    end
    if HasArtefact(hero, ARTIFACT_BLOOD_CRYSTAL, 0) then startThread(Routine_ArtifactBloodCrystalExp, player, hero) end
end

function DoArtifactsRoutine_Weekly(player, hero)
    log("$ DoArtifactsRoutine_Weekly - "..hero)
    for k,v in WEEKLY_TRIGGER_ARTIFACTS_ROUTINES do
        if HasArtefact(hero, k, 1) then
            startThread(v, player, hero)
        end
    end
    for k,v in WEEKLY_TRIGGER_ARTFSETS_ROUTINES do
        if HERO_ARTFSETS_STATUS[hero][k] == 1 then
            startThread(v, player, hero)
        end
    end
    if HasArtefact(hero, ARTIFACT_BLOOD_CRYSTAL, 0) then startThread(Routine_ArtifactBloodCrystalWitches, player, hero) end
end

function DoArtifactsRoutine_LevelUp(player, hero, level)
    log("$ DoArtifactsRoutine_LevelUp - "..hero)
    for k,v in LEVELUP_TRIGGER_ARTIFACTS_ROUTINES do
        if HasArtefact(hero, k, 1) then
            startThread(v, player, hero, level)
        end
    end
    for k,v in LEVELUP_TRIGGER_ARTFSETS_ROUTINES do
        if HERO_ARTFSETS_STATUS[hero][k] == 1 then
            startThread(v, player, hero, level)
        end
    end
    if HasArtefact(hero, ARTIFACT_BLOOD_CRYSTAL, 0) then startThread(Routine_ArtifactBloodCrystalStat, player, hero) end
end

function DoArtifactsRoutine_AfterCombat(player, hero, index)
    log("$ DoArtifactsRoutine_AfterCombat - "..hero)
    for k,v in AFTER_COMBAT_TRIGGER_ARTIFACTS_ROUTINES do
        if HasArtefact(hero, k, 1) then
            startThread(v, player, hero, index)
        end
    end
    for k,v in AFTER_COMBAT_TRIGGER_ARTFSETS_ROUTINES do
        if HERO_ARTFSETS_STATUS[hero][k] == 1 then
            startThread(v, player, hero, index)
        end
    end
end


-- log("Loaded artifacts-routines-advmap.lua")
ROUTINES_LOADED[12] = 1
