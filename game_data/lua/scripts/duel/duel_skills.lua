
dofile("/scripts/game/skills.lua") sleep(1)


function DuelLogistics(player, hero)
end
function DuelPathfinding(player, hero)
end
function DuelScouting(player, hero)
end
function DuelRecruitment(player, hero)
end
function DuelSpoilsOfWar(player, hero)
end
function DuelWarPath(player, hero)
end
function DuelLeadership(player, hero)
end
function DuelDiplomacy(player, hero)
end
function DuelTaletellers(player, hero)
end
function DuelGovernance(player, hero)
end
function DuelGearUp(player, hero)
end
function DuelHeroesLegacy(player, hero)
end
function DuelMythology(player, hero)
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
end
function DuelGoblinSupport(player, hero)
end
function DuelDefendUsAll(player, hero)
end
function DuelInfusion(player, hero)
end


DUEL_SKILL_EFFECTS = {
    [SKILL_LOGISTICS] = DuelLogistics,
    [PERK_PATHFINDING] = DuelPathfinding,
    [PERK_SCOUTING] = DuelScouting,
    [PERK_RECRUITMENT] = DuelRecruitment,
    [PERK_SPOILS_OF_WAR] = DuelSpoilsOfWar,
    [PERK_WAR_PATH] = DuelWarPath,
    [SKILL_LEADERSHIP] = DuelLeadership,
    [PERK_DIPLOMACY] = DuelDiplomacy,
    [PERK_TALETELLERS] = DuelTaletellers,
    [SKILL_GOVERNANCE] = DuelGovernance,
    [PERK_GEAR_UP] = DuelGearUp,
    [PERK_HEROES_LEGACY] = DuelHeroesLegacy,
    [PERK_MYTHOLOGY] = DuelMythology,
    [PERK_ESTATES] = DuelEstates,
    [PERK_GEOLOGY] = DuelGeology,
    [PERK_INDUSTRY] = DuelIndustry,
    [SKILL_LEARNING] = DuelLearning,
    [PERK_INTUITION] = DuelIntuition,
    [PERK_SCHOLAR] = DuelScholar,
    [PERK_MENTORING] = DuelMentoring,
    [PERK_MEDITATION] = DuelMeditation,
    [PERK_WARRIORS_OF_THE_MAGMA] = DuelWarriorsOfTheMagma,
    [PERK_WARRIORS_OF_THE_MOUNTAIN] = DuelWarriorsOfTheMountain,
    [PERK_WARRIORS_OF_THE_SEA] = DuelWarriorsOfTheSea,
    [PERK_WARRIORS_OF_THE_SKY] = DuelWarriorsOfTheSky,
    [PERK_EMPIRICISM] = DuelEmpiricism,
    [PERK_REINFORCEMENT] = DuelReinforcement,
    [SKILL_DESPOTISM] = DuelDespotism,
    [PERK_DEVOTION] = DuelDevotion,
    [PERK_BATTLE_WRATH] = DuelBattleWrath,
    [PERK_WAR_POLICY] = DuelWarPolicy,
    [PERK_LUNG_WORKOUT] = DuelLungWorkout,
    [SKILL_NECROMANCY] = DuelNecromancy,
    [PERK_HAUNTING] = DuelHaunting,
    [PERK_LORD_OF_UNDEAD] = DuelLordOfUndead,
    [PERK_HERALD_OF_DEATH] = DuelHeraldOfDeath,
    [PERK_KNOW_YOUR_ENEMY] = DuelKnowYourEnemy,
    [PERK_BATTLE_COMMANDER] = DuelBattleCommander,
    [SKILL_SPIRITISM] = DuelSpiritism,
    [PERK_GOBLIN_SUPPORT] = DuelGoblinSupport,
    [PERK_DEFEND_US_ALL] = DuelDefendUsAll,
    [PERK_INFUSION] = DuelInfusion,
}
