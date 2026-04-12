

function DuelLogistics(player, hero)
    log(DEBUG, "DUEL: DuelLogistics")
    local n = GetHeroSkillMastery(hero, SKILL_LOGISTICS)
    for i = 1,n do
        local cr = CREATURES_BY_FACTION[DUEL_FACTION[player]][i]
        local cur = DUEL_TOWN_RECRUITS[player][cr]
        local bonus = 0.1
        if HasHeroSkill(hero, PERK_RECRUITMENT) then bonus = bonus * 2 end
        local new = round(cur * (1 + bonus))
        SetObjectDwellingCreatures(DuelPlayerTown(player), cr, new)
    end
end

function DuelPathfinding(player, hero, level)
    log(DEBUG, "DUEL: DuelPathfinding")
    DUEL_PLAYER_DAYS[player] = DUEL_PLAYER_DAYS[player] + 0.1
end

function DuelScouting(player, hero)
    log(DEBUG, "DUEL: DuelScouting")
    local x = player == 1 and 121 or 94
    local y = 48
    for i = 0,10 do
        OpenCircleFog(x, y + i*10, 0, 9, player)
    end
end

function DuelSpoilsOfWar(player, hero, level)
    log(DEBUG, "DUEL: DuelSpoilsOfWar")
    GiveResources(player, GOLD, 250, 1)
    if mod(level, 4) == 0 then GiveHeroRandomArtifact(player, hero, ARTIFACT_CLASS_MINOR) end
end

function DuelWarPath(player, hero, level)
    log(DEBUG, "DUEL: DuelWarPath")
    DUEL_PLAYER_DAYS[player] = DUEL_PLAYER_DAYS[player] + 0.1
end

function DuelLeadership(player, hero, level)
    log(DEBUG, "DUEL: DuelLeadership")
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
    log(DEBUG, "DUEL: DuelDiplomacy")
    if mod(level, 2) == 0 then
        local tier = random(1,5)
        local creature = CREATURES_BY_FACTION[DUEL_FACTION[player]][tier][1]
        local nb = round(0.2 * DUEL_CREATURE_GROWTH[DUEL_FACTION[player]][creature])
        if nb > 0 then AddHeroCreatures(hero, creature, nb) end
    end
end

function DuelTaletellers(player, hero)
    log(DEBUG, "DUEL: DuelTaletellers")
    LevelUpHero(hero)
end

function DuelGovernance(player, hero, level)
    log(DEBUG, "DUEL: DuelGovernance")
    if mod(level, 2) == 0 then
        local n = GetHeroSkillMastery(hero, SKILL_GOVERNANCE)
        local amount = 500 * n
        GiveResources(player, GOLD, amount, 1)
    end
end

function DuelGovernance2(player, hero)
    log(DEBUG, "DUEL: DuelGovernance2")
    local res = FACTION_RESOURCE[DUEL_FACTION[player]]
    GiveResources(player, res, 5, 1)
end

function DuelGearUp(player, hero)
    log(DEBUG, "DUEL: DuelGearUp")
    local count = 0
    for a,data in ARTIFACTS_DATA do
        if data.class == ARTIFACT_CLASS_MINOR then
            if HasArtefact(hero, a, 1) then count = count + 1 end
        end
    end
    GiveResources(player, GOLD, 600 * count)
end

function DuelHeroesLegacy(player, hero)
    log(DEBUG, "DUEL: DuelHeroesLegacy")
    local count = 0
    for a,data in ARTIFACTS_DATA do
        if data.class == ARTIFACT_CLASS_MAJOR then
            if HasArtefact(hero, a, 1) then count = count + 1 end
        end
    end
    GiveResources(player, GOLD, 600 * count)
end

function DuelMythology(player, hero)
    log(DEBUG, "DUEL: DuelMythology")
    local count = 0
    for a,data in ARTIFACTS_DATA do
        if data.class == ARTIFACT_CLASS_RELIC then
            if HasArtefact(hero, a, 1) then count = count + 1 end
        end
    end
    GiveResources(player, GOLD, 600 * count)
end

function DuelEstates(player, hero)
end
function DuelGeology(player, hero)
end
function DuelIndustry(player, hero)
end
function DuelLearning(player, hero)
end
function DuelIntuition(player, hero)
end
function DuelScholar(player, hero)
end
function DuelMentoring(player, hero)
end
function DuelMeditation(player, hero)
end
function DuelWarriorsOfTheMagma(player, hero)
end
function DuelWarriorsOfTheMountain(player, hero)
end
function DuelWarriorsOfTheSea(player, hero)
end
function DuelWarriorsOfTheSky(player, hero)
end
function DuelEmpiricism(player, hero)
end
function DuelReinforcement(player, hero)
end
function DuelDespotism(player, hero)
end
function DuelDevotion(player, hero)
end
function DuelBattleWrath(player, hero)
end
function DuelWarPolicy(player, hero)
end
function DuelLungWorkout(player, hero)
end
function DuelNecromancy(player, hero)
end
function DuelHaunting(player, hero)
end
function DuelLordOfUndead(player, hero)
end
function DuelHeraldOfDeath(player, hero)
end
function DuelKnowYourEnemy(player, hero)
end
function DuelBattleCommander(player, hero)
end

function DuelSpiritism(player, hero)
    ChangeHeroStat(hero, STAT_KNOWLEDGE, 1)
end

function DuelGoblinSupport(player, hero, level)
    AddHeroCreatures(hero, CREATURE_GOBLIN, 6)
end

function DuelDefendUsAll(player, hero, level)
    if mod(level, 4) == 0 then
        AddHeroCreatures(hero, CREATURE_ORC_WARRIOR, 10)
        AddHeroCreatures(hero, CREATURE_ORCCHIEF_BUTCHER, 1)
    end
end

function DuelInfusion(player, hero)
    AddHeroManaUnbound(player, hero, 50)
end


DUEL_SKILL_LEVELUP_EFFECTS = {
    [PERK_PATHFINDING] = DuelPathfinding,
    [PERK_SPOILS_OF_WAR] = DuelSpoilsOfWar,
    [PERK_WAR_PATH] = DuelWarPath,
    [SKILL_LEADERSHIP] = DuelLeadership,
    [PERK_DIPLOMACY] = DuelDiplomacy,
    [SKILL_GOVERNANCE] = DuelGovernance,
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
}

DUEL_SKILL_BATTLE_EFFECTS = {
    [PERK_INFUSION] = DuelInfusion,
}

DUEL_SKILL_LEARNT_EFFECTS = {
    [PERK_TALETELLERS] = DuelTaletellers,
    [SKILL_GOVERNANCE] = DuelGovernance2,
    [SKILL_SPIRITISM] = DuelSpiritism,
}

function DuelAddSkill(player, hero, skill, mastery)
    if DUEL_SKILL_LEARNT_EFFECTS[skill] then DUEL_SKILL_LEARNT_EFFECTS[skill](player, hero) end
end

function DuelRemoveSkill(player, hero, skill, mastery)
end

    -- [PERK_ESTATES] = DuelEstates,
    -- [PERK_GEOLOGY] = DuelGeology,
    -- [PERK_INDUSTRY] = DuelIndustry,
    -- [SKILL_LEARNING] = DuelLearning,
    -- [PERK_INTUITION] = DuelIntuition,
    -- [PERK_SCHOLAR] = DuelScholar,
    -- [PERK_MENTORING] = DuelMentoring,
    -- [PERK_MEDITATION] = DuelMeditation,
    -- [PERK_WARRIORS_OF_THE_MAGMA] = DuelWarriorsOfTheMagma,
    -- [PERK_WARRIORS_OF_THE_MOUNTAIN] = DuelWarriorsOfTheMountain,
    -- [PERK_WARRIORS_OF_THE_SEA] = DuelWarriorsOfTheSea,
    -- [PERK_WARRIORS_OF_THE_SKY] = DuelWarriorsOfTheSky,
    -- [PERK_EMPIRICISM] = DuelEmpiricism,
    -- [PERK_REINFORCEMENT] = DuelReinforcement,
    -- [SKILL_DESPOTISM] = DuelDespotism,
    -- [PERK_DEVOTION] = DuelDevotion,
    -- [PERK_BATTLE_WRATH] = DuelBattleWrath,
    -- [PERK_WAR_POLICY] = DuelWarPolicy,
    -- [PERK_LUNG_WORKOUT] = DuelLungWorkout,
    -- [SKILL_NECROMANCY] = DuelNecromancy,
    -- [PERK_HAUNTING] = DuelHaunting,
    -- [PERK_LORD_OF_UNDEAD] = DuelLordOfUndead,
    -- [PERK_HERALD_OF_DEATH] = DuelHeraldOfDeath,
    -- [PERK_KNOW_YOUR_ENEMY] = DuelKnowYourEnemy,
    -- [PERK_BATTLE_COMMANDER] = DuelBattleCommander,