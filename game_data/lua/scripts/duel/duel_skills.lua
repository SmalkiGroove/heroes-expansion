

function DuelLogistics(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelLogistics")
    log.debug("DUEL: DuelLogistics")
    local n = GetHeroSkillMastery(hero, SKILL_LOGISTICS)
    local bonus = 0.1
    if HasHeroSkill(hero, PERK_RECRUITMENT) then bonus = bonus * 2 end
    local nb = {0,0,0}
    for i = 1,n do
        local cr = CREATURES_BY_FACTION[DUEL_FACTION[player]][i][1]
        local growth = DUEL_CREATURE_GROWTH[DUEL_FACTION[player]][cr]
        nb[i] = round(growth * (1 + bonus))
        local new = DUEL_TOWN_RECRUITS[player][cr] + nb[i]
        SetObjectDwellingCreatures(DuelPlayerTown(player), cr, new)
        DUEL_TOWN_RECRUITS[player][cr] = new
    end
    Popup(player, {"/Text/Duel/Skill/Logistics.txt"; arg1=nb[1], arg2=nb[2], arg3=nb[3]})
end

function DuelPathfinding(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelPathfinding")
    log.debug("DUEL: DuelPathfinding")
    DUEL_PLAYER_DATA.ADVENTURE_DAYS[player] = DUEL_PLAYER_DATA.ADVENTURE_DAYS[player] + 0.1
    Popup(player, {"/Text/Duel/Skill/Pathfinding.txt"; arg=DUEL_PLAYER_DATA.ADVENTURE_DAYS[player]})
end

function DuelScouting(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelScouting")
    log.debug("DUEL: DuelScouting")
    local x = player == 1 and 121 or 94
    local y = 48
    for i = 0,10 do
        OpenCircleFog(x, y + i*10, 0, 9, player)
    end
    Popup(player, {"/Text/Duel/Skill/Scouting.txt"; arg=0})
end

function DuelSpoilsOfWar(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelSpoilsOfWar")
    log.debug("DUEL: DuelSpoilsOfWar")
    GiveResources(player, GOLD, 250, 1)
    local artifact = 0
    if mod(level, 4) == 0 then
        GiveHeroRandomArtifact(player, hero, ARTIFACT_CLASS_MINOR)
        artifact = 1
    end
    Popup(player, {"/Text/Duel/Skill/SpoilsOfWar.txt"; arg1=250, arg2=artifact})
end

function DuelWarPath(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelWarPath")
    log.debug("DUEL: DuelWarPath")
    DUEL_PLAYER_DATA.ADVENTURE_DAYS[player] = DUEL_PLAYER_DATA.ADVENTURE_DAYS[player] + 0.1
    Popup(player, {"/Text/Duel/Skill/WarPath.txt"; arg=DUEL_PLAYER_DATA.ADVENTURE_DAYS[player] })
end

function DuelLeadership(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelLeadership")
    log.debug("DUEL: DuelLeadership")
    if mod(level, 2) == 0 then
        local n = GetHeroSkillMastery(hero, SKILL_LEADERSHIP)
        local percent = 5 + 5 * n + level
        if HasHeroSkill(hero, PERK_CHARISMA) then percent = percent + 20 end
        local result = {0,0,0,0,0,0,0}
        for creature, growth in DUEL_CREATURE_GROWTH[DUEL_FACTION[player]] do
            local nb = trunc(0.01 * percent * growth)
            if nb > 0 then
                AddHeroCreatures(hero, creature, nb)
                result[GetTier(creature)] = nb
            end
        end
        Popup(player, {"/Text/Duel/Skill/Leadership.txt"; arg1=result[1], arg2=result[2], arg3=result[3], arg4=result[4], arg5=result[5], arg6=result[6], arg7=result[7]})
    end
end

function DuelDiplomacy(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelDiplomacy")
    log.debug("DUEL: DuelDiplomacy")
    if mod(level, 2) == 0 then
        local tier = random(1,5)
        local creature = CREATURES_BY_FACTION[DUEL_FACTION[player]][tier][1]
        local nb = round(0.2 * DUEL_CREATURE_GROWTH[DUEL_FACTION[player]][creature])
        if nb > 0 then AddHeroCreatures(hero, creature, nb) end
        Popup(player, {"/Text/Duel/Skill/Diplomacy.txt"; arg1=nb, arg2=tier})
    end
end

function DuelTaletellers(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelTaletellers")
    log.debug("DUEL: DuelTaletellers")
    LevelUpHero(hero)
    Popup(player, {"/Text/Duel/Skill/Taletellers.txt"; arg=1})
end

function DuelGovernance(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelGovernance")
    log.debug("DUEL: DuelGovernance")
    local n = GetHeroSkillMastery(hero, SKILL_GOVERNANCE)
    local amount = 500 * n
    GiveResources(player, GOLD, amount, 1)
    Popup(player, {"/Text/Duel/Skill/Governance.txt"; arg=amount})
end

function DuelGovernance2(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelGovernance2")
    log.debug("DUEL: DuelGovernance2")
    local res = FACTION_RESOURCE[DUEL_FACTION[player]]
    GiveResources(player, res, 5, 1)
    Popup(player, {"/Text/Duel/Skill/Governance2.txt"; arg=5, gr=RESOURCE_NAME_FILE[res]})
end

function DuelGearUp(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelGearUp")
    log.debug("DUEL: DuelGearUp")
    local count = 0
    for a,data in ARTIFACTS_DATA do
        if data.class == ARTIFACT_CLASS_MINOR then
            if HasArtefact(hero, a, 1) then count = count + 5000 end
        end
    end
    GiveResources(player, GOLD, count)
    Popup(player, {"/Text/Duel/Skill/GearUp.txt"; arg=count})
end

function DuelHeroesLegacy(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelHeroesLegacy")
    local count = 0
    for a,data in ARTIFACTS_DATA do
        if data.class == ARTIFACT_CLASS_MAJOR then
            if HasArtefact(hero, a, 1) then count = count + 7500 end
        end
    end
    GiveResources(player, GOLD, count)
    Popup(player, {"/Text/Duel/Skill/HeroesLegacy.txt"; arg=count})
end

function DuelMythology(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelMythology")
    local count = 0
    for a,data in ARTIFACTS_DATA do
        if data.class == ARTIFACT_CLASS_RELIC then
            if HasArtefact(hero, a, 1) then count = count + 10000 end
        end
    end
    GiveResources(player, GOLD, count)
    Popup(player, {"/Text/Duel/Skill/Mythology.txt"; arg=count})
end

function DuelEstates(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelEstates")
    local amount = 500 + level * 25
    GiveResources(player, GOLD, amount, 1)
    Popup(player, {"/Text/Duel/Skill/Estates.txt"; arg=amount})
end

function DuelGeology(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelGeology")
    GiveResources(player, ORE, 2, 1)
    GiveResources(player, GOLD, level * 50, 1)
    Popup(player, {"/Text/Duel/Skill/Geology.txt"; arg1=2, arg2=level * 50})
end

function DuelIndustry(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelIndustry")
    for res = 0,5 do GiveResources(player, res, 20) end
    Popup(player, {"/Text/Duel/Skill/Industry.txt"; arg=20})
end

function DuelLearning(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelLearning")
    local n = GetHeroSkillMastery(hero, SKILL_LEARNING)
    local exp = trunc(0.05 * n * DUEL_PLAYER_DATA.TOTAL_EXP[player])
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
    Popup(player, {"/Text/Duel/Skill/Learning.txt"; arg=exp})
end

function DuelIntuition(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelIntuition")
    for school = 1,4 do for tier = 1,3 do
        TeachHeroRandomSpellTier(player, hero, school, tier)
    end end
    Popup(player, {"/Text/Duel/Skill/Intuition.txt"; arg=12})
end

function DuelScholar(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelScholar")
    local mapping = {[9]=4, [10]=2, [11]=1, [12]=3}
    local n = 0
    for skill = 9, 12 do
        if not HasHeroSkill(hero, skill) then
            TeachHeroRandomSpell(player, hero, mapping[skill], 5)
            n = n + 1
        end
    end
    Popup(player, {"/Text/Duel/Skill/Scholar.txt"; arg=n})
end

function DuelMentoring(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelMentoring")
    local exp = trunc(0.15 * DUEL_PLAYER_DATA.TOTAL_EXP[player])
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
    Popup(player, {"/Text/Duel/Skill/Mentoring.txt"; arg=exp})
end

function DuelMeditation(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelMeditation")
    LevelUpHero(hero)
    Popup(player, {"/Text/Duel/Skill/Meditation.txt"; arg=1})
end

function DuelWarriorsOfTheMagma(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelWarriorsOfTheMagma")
    AddHeroCreatures(hero, CREATURE_FIRE_ELEMENTAL, level)
    Popup(player, {"/Text/Duel/Skill/WarriorsOfTheMagma.txt"; arg=level})
end

function DuelWarriorsOfTheMountain(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelWarriorsOfTheMountain")
    AddHeroCreatures(hero, CREATURE_EARTH_ELEMENTAL, level)
    Popup(player, {"/Text/Duel/Skill/WarriorsOfTheMountain.txt"; arg=level})
end

function DuelWarriorsOfTheSea(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelWarriorsOfTheSea")
    AddHeroCreatures(hero, CREATURE_WATER_ELEMENTAL, level)
    Popup(player, {"/Text/Duel/Skill/WarriorsOfTheSea.txt"; arg=level})
end

function DuelWarriorsOfTheSky(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelWarriorsOfTheSky")
    AddHeroCreatures(hero, CREATURE_AIR_ELEMENTAL, level)
    Popup(player, {"/Text/Duel/Skill/WarriorsOfTheSky.txt"; arg=level})
end

function DuelEmpiricism(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelEmpiricism")
    local exp = trunc(0.15 * DUEL_PLAYER_DATA.TOTAL_EXP[player])
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
    Popup(player, {"/Text/Duel/Skill/Empiricism.txt"; arg=exp})
end

function DuelEmpiricism2(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelEmpiricism2")
    LevelUpHero(hero)
    Popup(player, {"/Text/Duel/Skill/Empiricism2.txt"; arg=1})
end

function DuelReinforcement(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelReinforcement")
    local amount = trunc(0.15 * GetHeroLevel(hero))
    ChangeHeroStat(hero, STAT_ATTACK, amount)
    ChangeHeroStat(hero, STAT_DEFENCE, amount)
    Popup(player, {"/Text/Duel/Skill/Reinforcement.txt"; arg=amount})
end

function DuelReinforcement2(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelReinforcement2")
    ChangeHeroStat(hero, STAT_ATTACK, 1)
    ChangeHeroStat(hero, STAT_DEFENCE, 1)
    Popup(player, {"/Text/Duel/Skill/Reinforcement.txt"; arg=1})
end

function DuelDespotism(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelDespotism")
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
    Popup(player, {"/Text/Duel/Skill/Despotism.txt"; arg1=bonus, arg2=ATTRIBUTE_NAME_FILE[stat]})
end

function DuelDevotion(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelDevotion")
    LevelUpHero(hero)
    Popup(player, {"/Text/Duel/Skill/Devotion.txt"; arg=1})
end

function DuelBattleWrath(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelBattleWrath")
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_ATTACK, 2)
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_INITIATIVE, 2)
    Popup(player, {"/Text/Duel/Skill/BattleWrath.txt"; arg=2})
end

function DuelWarPolicy(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelWarPolicy")
    for creature, growth in DUEL_CREATURE_GROWTH[DUEL_FACTION[player]] do
        local nb = round(0.01 * level * growth)
        local new = DUEL_TOWN_RECRUITS[player][creature] + nb
        if nb > 0 then
            SetObjectDwellingCreatures(DuelPlayerTown(player), creature, new)
            DUEL_TOWN_RECRUITS[player][creature] = new
        end
    end
    Popup(player, {"/Text/Duel/Skill/WarPolicy.txt"; arg=level})
end

function DuelLungWorkout(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelLungWorkout")
    ChangeHeroStat(hero, STAT_SPELL_POWER, 2)
    ChangeHeroStat(hero, STAT_KNOWLEDGE, 2)
    Popup(player, {"/Text/Duel/Skill/LungWorkout.txt"; arg=2})
end

function DuelNecromancy(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelNecromancy")
    local result = {0,0,0,0,0,0,0}
    local n = GetHeroSkillMastery(hero, SKILL_NECROMANCY)
    local percent = 5 + n * 5 + level * (n+1)
    for tier = 1,7 do
        if mod(level, tier) == 0 then
            local creature = CREATURES_BY_FACTION[NECROPOLIS][tier][1]
            local growth = DUEL_CREATURE_GROWTH[NECROPOLIS][creature]
            local nb = ceil(growth * percent)
            AddHeroCreatures(hero, creature, nb)
            result[tier] = nb
        end
    end
    Popup(player, {"/Text/Duel/Skill/Necromancy.txt"; arg1=result[1], arg2=result[2], arg3=result[3], arg4=result[4], arg5=result[5], arg6=result[6], arg7=result[7]})
end

function DuelHaunting(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelHaunting")
    local amount = 5 * GetHeroLevel(hero)
    AddHeroCreatures(hero, CREATURE_MANES, amount)
    Popup(player, {"/Text/Duel/Skill/Haunting.txt"; arg=amount})
end

function DuelLordOfUndead(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelLordOfUndead")
    local amount = round(0.1 * GetPlayerNecroEnergy(player))
    AddHeroCreatures(hero, CREATURE_SKELETON, amount)
    Popup(player, {"/Text/Duel/Skill/LordOfUndead.txt"; arg=amount})
end

function DuelHeraldOfDeath(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelHeraldOfDeath")
    local amount = 20000
    GiveResources(player, GOLD, amount)
    Popup(player, {"/Text/Duel/Skill/HeraldOfDeath.txt"; arg=amount})
end

function DuelKnowYourEnemy(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelKnowYourEnemy")
    local exp = trunc(0.05 * DUEL_PLAYER_DATA.TOTAL_EXP[player])
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
    Popup(player, {"/Text/Duel/Skill/KnowYourEnemy.txt"; arg=exp})
end

function DuelBattleCommander(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelBattleCommander")
    if mod(level, 3) == 0 then
        local amount = 10 + level
        AddHeroCreatureType(player, hero, PRESERVE, 1, amount, 2)
        Popup(player, {"/Text/Duel/Skill/BattleCommander.txt"; arg=amount})
    end
end

function DuelSpiritism(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelSpiritism")
    ChangeHeroStat(hero, STAT_KNOWLEDGE, 1)
    Popup(player, {"/Text/Duel/Skill/Spiritism.txt"; arg=1})
end

function DuelGoblinSupport(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelGoblinSupport")
    AddHeroCreatures(hero, CREATURE_GOBLIN, 6)
    Popup(player, {"/Text/Duel/Skill/GoblinSupport.txt"; arg=6})
end

function DuelDefendUsAll(player, hero, level)
    log.trace("/scripts/duel/duel_skills.lua: DuelDefendUsAll")
    if mod(level, 4) == 0 then
        local warriors, butchers = 10, 1
        AddHeroCreatures(hero, CREATURE_ORC_WARRIOR, warriors)
        AddHeroCreatures(hero, CREATURE_ORCCHIEF_BUTCHER, butchers)
        Popup(player, {"/Text/Duel/Skill/DefendUsAll.txt"; arg1=warriors, arg2=butchers})
    end
end

function DuelInfusion(player, hero)
    log.trace("/scripts/duel/duel_skills.lua: DuelInfusion")
    AddHeroManaUnbound(player, hero, 50)
    Popup(player, {"/Text/Duel/Skill/Infusion.txt"; arg=50})
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
    [PERK_REINFORCEMENT] = DuelReinforcement2,
    [PERK_DEVOTION] = DuelDevotion,
    [PERK_LUNG_WORKOUT] = DuelLungWorkout,
    [SKILL_SPIRITISM] = DuelSpiritism,
}

DUEL_SKILL_OVERRIDE = {
    [PERK_EMPIRICISM] = 1,
}

function DuelAddSkill(player, hero, skill)
    log.trace("/scripts/duel/duel_skills.lua: DuelAddSkill")
    if DUEL_SKILL_LEARNT_EFFECTS[skill] then
        DUEL_SKILL_LEARNT_EFFECTS[skill](player, hero)
    end
    return (DUEL_SKILL_OVERRIDE[skill] and 1 or nil)
end

function DuelRemoveSkill(player, hero, skill)
    log.trace("/scripts/duel/duel_skills.lua: DuelRemoveSkill")
    return nil
end

    -- [PERK_BATTLE_COMMANDER] = DuelBattleCommander,