

function DuelLogistics(player, hero)
    log.debug("DUEL: DuelLogistics")
    local n = GetHeroSkillMastery(hero, SKILL_LOGISTICS)
    for i = 1,n do
        local cr = CREATURES_BY_FACTION[DUEL_FACTION[player]][i][1]
        local cur = DUEL_TOWN_RECRUITS[player][cr]
        local bonus = 0.1
        if HasHeroSkill(hero, PERK_RECRUITMENT) then bonus = bonus * 2 end
        local new = round(cur * (1 + bonus))
        SetObjectDwellingCreatures(DuelPlayerTown(player), cr, new)
    end
end

function DuelPathfinding(player, hero, level)
    log.debug("DUEL: DuelPathfinding")
    DUEL_PLAYER_DATA.ADVENTURE_DAYS[player] = DUEL_PLAYER_DATA.ADVENTURE_DAYS[player] + 0.1
end

function DuelScouting(player, hero)
    log.debug("DUEL: DuelScouting")
    local x = player == 1 and 121 or 94
    local y = 48
    for i = 0,10 do
        OpenCircleFog(x, y + i*10, 0, 9, player)
    end
end

function DuelSpoilsOfWar(player, hero, level)
    log.debug("DUEL: DuelSpoilsOfWar")
    GiveResources(player, GOLD, 250, 1)
    if mod(level, 4) == 0 then GiveHeroRandomArtifact(player, hero, ARTIFACT_CLASS_MINOR) end
end

function DuelWarPath(player, hero, level)
    log.debug("DUEL: DuelWarPath")
    DUEL_PLAYER_DATA.ADVENTURE_DAYS[player] = DUEL_PLAYER_DATA.ADVENTURE_DAYS[player] + 0.1
end

function DuelLeadership(player, hero, level)
    log.debug("DUEL: DuelLeadership")
    if mod(level, 2) == 0 then
        local n = GetHeroSkillMastery(hero, SKILL_LEADERSHIP)
        local percent = 5 + 5 * n + level
        if HasHeroSkill(hero, PERK_CHARISMA) then percent = percent + 20 end
        for creature, growth in DUEL_CREATURE_GROWTH[DUEL_FACTION[player]] do
            local nb = trunc(0.01 * percent * growth)
            if nb > 0 then AddHeroCreatures(hero, creature, nb) end
        end
    end
end

function DuelDiplomacy(player, hero, level)
    log.debug("DUEL: DuelDiplomacy")
    if mod(level, 2) == 0 then
        local tier = random(1,5)
        local creature = CREATURES_BY_FACTION[DUEL_FACTION[player]][tier][1]
        local nb = round(0.2 * DUEL_CREATURE_GROWTH[DUEL_FACTION[player]][creature])
        if nb > 0 then AddHeroCreatures(hero, creature, nb) end
    end
end

function DuelTaletellers(player, hero)
    log.debug("DUEL: DuelTaletellers")
    LevelUpHero(hero)
end

function DuelGovernance(player, hero, level)
    log.debug("DUEL: DuelGovernance")
    local n = GetHeroSkillMastery(hero, SKILL_GOVERNANCE)
    local amount = 500 * n
    GiveResources(player, GOLD, amount, 1)
end

function DuelGovernance2(player, hero)
    log.debug("DUEL: DuelGovernance2")
    local res = FACTION_RESOURCE[DUEL_FACTION[player]]
    GiveResources(player, res, 5, 1)
end

function DuelGearUp(player, hero)
    log.debug("DUEL: DuelGearUp")
    local count = 0
    for a,data in ARTIFACTS_DATA do
        if data.class == ARTIFACT_CLASS_MINOR then
            if HasArtefact(hero, a, 1) then count = count + 1 end
        end
    end
    GiveResources(player, GOLD, 600 * count)
end

function DuelHeroesLegacy(player, hero)
    log.debug("DUEL: DuelHeroesLegacy")
    local count = 0
    for a,data in ARTIFACTS_DATA do
        if data.class == ARTIFACT_CLASS_MAJOR then
            if HasArtefact(hero, a, 1) then count = count + 1 end
        end
    end
    GiveResources(player, GOLD, 600 * count)
end

function DuelMythology(player, hero)
    log.debug("DUEL: DuelMythology")
    local count = 0
    for a,data in ARTIFACTS_DATA do
        if data.class == ARTIFACT_CLASS_RELIC then
            if HasArtefact(hero, a, 1) then count = count + 1 end
        end
    end
    GiveResources(player, GOLD, 600 * count)
end

function DuelEstates(player, hero, level)
    log.debug("DUEL: DuelEstates")
    local amount = 500 + level * 25
    GiveResources(player, GOLD, amount, 1)
end

function DuelGeology(player, hero, level)
    log.debug("DUEL: DuelEstates")
    GiveResources(player, ORE, 2, 1)
    GiveResources(player, GOLD, level * 50, 1)
end

function DuelIndustry(player, hero)
    log.debug("DUEL: DuelIndustry")
    for res = 0,5 do GiveResources(player, res, 20) end
end

function DuelLearning(player, hero)
    log.debug("DUEL: DuelLearning")
    local n = GetHeroSkillMastery(hero, SKILL_LEARNING)
    local exp = trunc(0.05 * n * DUEL_PLAYER_DATA.TOTAL_EXP[player])
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
end

function DuelIntuition(player, hero)
    log.debug("DUEL: DuelIntuition")
    for school = 1,4 do for tier = 1,3 do
        TeachHeroRandomSpellTier(player, hero, school, tier)
    end end
end

function DuelScholar(player, hero)
    log.debug("DUEL: DuelScholar")
    local mapping = {[9]=4, [10]=2, [11]=1, [12]=3}
    for skill = 9, 12 do
        if not HasHeroSkill(hero, skill) then
            TeachHeroRandomSpell(player, hero, mapping[skill], 5)
        end
    end
end

function DuelMentoring(player, hero)
    log.debug("DUEL: DuelMentoring")
    local exp = trunc(0.15 * DUEL_PLAYER_DATA.TOTAL_EXP[player])
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
end

function DuelMeditation(player, hero)
    log.debug("DUEL: DuelMeditation")
    LevelUpHero(hero)
end

function DuelWarriorsOfTheMagma(player, hero, level)
    log.debug("DUEL: DuelWarriorsOfTheMagma")
    AddHeroCreatures(hero, CREATURE_FIRE_ELEMENTAL, level)
end

function DuelWarriorsOfTheMountain(player, hero, level)
    log.debug("DUEL: DuelWarriorsOfTheMountain")
    AddHeroCreatures(hero, CREATURE_EARTH_ELEMENTAL, level)
end

function DuelWarriorsOfTheSea(player, hero, level)
    log.debug("DUEL: DuelWarriorsOfTheSea")
    AddHeroCreatures(hero, CREATURE_WATER_ELEMENTAL, level)
end

function DuelWarriorsOfTheSky(player, hero, level)
    log.debug("DUEL: DuelWarriorsOfTheSky")
    AddHeroCreatures(hero, CREATURE_AIR_ELEMENTAL, level)
end

function DuelEmpiricism(player, hero)
    log.debug("DUEL: DuelEmpiricism")
    local exp = trunc(0.15 * DUEL_PLAYER_DATA.TOTAL_EXP[player])
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
end

function DuelEmpiricism2(player, hero)
    log.debug("DUEL: DuelEmpiricism2")
    LevelUpHero(hero)
end

function DuelReinforcement(player, hero)
    log.debug("DUEL: DuelReinforcement")
    local amount = trunc(0.15 * GetHeroLevel(hero))
    ChangeHeroStat(hero, STAT_ATTACK, amount)
    ChangeHeroStat(hero, STAT_DEFENCE, amount)
end

function DuelDespotism(player, hero)
    log.debug("DUEL: DuelDespotism")
    local n = GetHeroSkillMastery(hero, SKILL_DESPOTISM)
    local total = 0
    for i,cr in GetHeroArmy(hero) do
        if cr and cr ~= 0 then
            total = total + GetHeroCreatures(hero, cr)
        end
    end
    local bonus = n
    local threshold = 1200 - n * 200
    while total > threshold do
        bonus = bonus + 1
        total = total - threshold
    end
    local stat = GetHeroHighestStat(hero)
    ChangeHeroStat(hero, stat, bonus)
end

function DuelDevotion(player, hero)
    log.debug("DUEL: DuelDevotion")
    LevelUpHero(hero)
end

function DuelBattleWrath(player, hero)
    log.debug("DUEL: DuelBattleWrath")
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_ATTACK, 2)
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_INITIATIVE, 2)
end

function DuelWarPolicy(player, hero, level)
    log.debug("DUEL: DuelWarPolicy")
    for creature, growth in DUEL_CREATURE_GROWTH[DUEL_FACTION[player]] do
        local cur = DUEL_TOWN_RECRUITS[player][creature]
        local nb = round(0.01 * level * growth)
        if nb > 0 then SetObjectDwellingCreatures(DuelPlayerTown(player), creature, cur + nb) end
    end
end

function DuelLungWorkout(player, hero)
    log.debug("DUEL: DuelLungWorkout")
    ChangeHeroStat(hero, STAT_SPELL_POWER, 1)
    ChangeHeroStat(hero, STAT_KNOWLEDGE, 1)
end

function DuelNecromancy(player, hero, level)
    log.debug("DUEL: DuelNecromancy")
    local n = GetHeroSkillMastery(hero, SKILL_NECROMANCY)
    for tier = 1,7 do
        if mod(level, tier) == 0 then
            local creature = CREATURES_BY_FACTION[NECROPOLIS][tier][1]
            local growth = DUEL_CREATURE_GROWTH[NECROPOLIS][creature]
            local percent = 5 + n * 5 + level * (n+1)
            AddHeroCreatures(hero, creature, ceil(growth * percent))
        end
    end
end

function DuelHaunting(player, hero)
    log.debug("DUEL: DuelHaunting")
    local amount = 5 * GetHeroLevel(hero)
    AddHeroCreatures(hero, CREATURE_MANES, amount)
end

function DuelLordOfUndead(player, hero)
    log.debug("DUEL: DuelLordOfUndead")
    local amount = round(0.1 * GetPlayerNecroEnergy(player))
    AddHeroCreatures(hero, CREATURE_SKELETON, amount)
end

function DuelHeraldOfDeath(player, hero)
    log.debug("DUEL: DuelHeraldOfDeath")
    local amount = 20000
    GiveResources(player, GOLD, amount)
end

function DuelKnowYourEnemy(player, hero)
    log.debug("DUEL: DuelKnowYourEnemy")
    local exp = trunc(0.05 * DUEL_PLAYER_DATA.TOTAL_EXP[player])
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
end

function DuelBattleCommander(player, hero, level)
    log.debug("DUEL: DuelBattleCommander")
    if mod(level, 3) == 0 then
        local amount = 10 + level
        AddHeroCreatureType(player, hero, PRESERVE, 1, amount, 2)
    end
end

function DuelSpiritism(player, hero)
    log.debug("DUEL: DuelSpiritism")
    ChangeHeroStat(hero, STAT_KNOWLEDGE, 1)
end

function DuelGoblinSupport(player, hero, level)
    log.debug("DUEL: DuelGoblinSupport")
    AddHeroCreatures(hero, CREATURE_GOBLIN, 6)
end

function DuelDefendUsAll(player, hero, level)
    log.debug("DUEL: DuelDefendUsAll")
    if mod(level, 4) == 0 then
        AddHeroCreatures(hero, CREATURE_ORC_WARRIOR, 10)
        AddHeroCreatures(hero, CREATURE_ORCCHIEF_BUTCHER, 1)
    end
end

function DuelInfusion(player, hero)
    log.debug("DUEL: DuelInfusion")
    AddHeroManaUnbound(player, hero, 50)
end


DUEL_SKILL_LEVELUP_EFFECTS = {
    [PERK_PATHFINDING] = DuelPathfinding,
    [PERK_SPOILS_OF_WAR] = DuelSpoilsOfWar,
    [PERK_WAR_PATH] = DuelWarPath,
    [SKILL_LEADERSHIP] = DuelLeadership,
    [PERK_DIPLOMACY] = DuelDiplomacy,
    [SKILL_GOVERNANCE] = DuelGovernance,
    [PERK_ESTATES] = DuelEstates,
    [PERK_GEOLOGY] = DuelGeology,
    [PERK_WARRIORS_OF_THE_MAGMA] = DuelWarriorsOfTheMagma,
    [PERK_WARRIORS_OF_THE_MOUNTAIN] = DuelWarriorsOfTheMountain,
    [PERK_WARRIORS_OF_THE_SEA] = DuelWarriorsOfTheSea,
    [PERK_WARRIORS_OF_THE_SKY] = DuelWarriorsOfTheSky,
    [PERK_WAR_POLICY] = DuelWarPolicy,
    [SKILL_NECROMANCY] = DuelNecromancy,
    [PERK_GOBLIN_SUPPORT] = DuelGoblinSupport,
    [PERK_DEFEND_US_ALL] = DuelDefendUsAll,
}

DUEL_SKILL_ADVENTURE_EFFECTS = {
    [PERK_SCOUTING] = DuelScouting,
}

DUEL_SKILL_STAGING_EFFECTS = {
    [SKILL_LOGISTICS] = DuelLogistics,
    [PERK_GEAR_UP] = DuelGearUp,
    [PERK_HEROES_LEGACY] = DuelHeroesLegacy,
    [PERK_MYTHOLOGY] = DuelMythology,
    [PERK_INDUSTRY] = DuelIndustry,
    [SKILL_LEARNING] = DuelLearning,
    [PERK_INTUITION] = DuelIntuition,
    [PERK_SCHOLAR] = DuelScholar,
    [PERK_MENTORING] = DuelMentoring,
    [PERK_EMPIRICISM] = DuelEmpiricism,
    [PERK_REINFORCEMENT] = DuelReinforcement,
    [PERK_HAUNTING] = DuelHaunting,
    [PERK_LORD_OF_UNDEAD] = DuelLordOfUndead,
    [PERK_HERALD_OF_DEATH] = DuelHeraldOfDeath,
    [PERK_KNOW_YOUR_ENEMY] = DuelKnowYourEnemy,
}

DUEL_SKILL_BATTLE_EFFECTS = {
    [SKILL_DESPOTISM] = DuelDespotism,
    [PERK_BATTLE_WRATH] = DuelBattleWrath,
    [PERK_INFUSION] = DuelInfusion,
}

DUEL_SKILL_LEARNT_EFFECTS = {
    [PERK_MEDITATION] = DuelMeditation,
    [PERK_TALETELLERS] = DuelTaletellers,
    [SKILL_GOVERNANCE] = DuelGovernance2,
    [PERK_EMPIRICISM] = DuelEmpiricism2,
    [PERK_DEVOTION] = DuelDevotion,
    [PERK_LUNG_WORKOUT] = DuelLungWorkout,
    [SKILL_SPIRITISM] = DuelSpiritism,
}

DUEL_SKILL_OVERRIDE = {
    [PERK_EMPIRICISM] = 1,
}

function DuelAddSkill(player, hero, skill)
    if DUEL_SKILL_LEARNT_EFFECTS[skill] then
        DUEL_SKILL_LEARNT_EFFECTS[skill](player, hero)
    end
    return (DUEL_SKILL_OVERRIDE[skill] and 1 or nil)
end

function DuelRemoveSkill(player, hero, skill)
    return nil
end

    -- [PERK_BATTLE_COMMANDER] = DuelBattleCommander,