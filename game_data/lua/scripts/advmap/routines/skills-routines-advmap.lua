
function Routine_CheckOffence(player, hero, mastery, level)
    log("$ Routine_CheckOffence")
    local level = level or GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, 0, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_OFFENCE]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_ATTACK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_OFFENCE] = value
    end
end

function Routine_CheckDefense(player, hero, mastery, level)
    log("$ Routine_CheckDefense")
    local level = level or GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, 0, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_DEFENSE]
    if diff ~= 0 then
        if hero == H_HEDWIG then diff = 2 * diff end
        AddHeroStatAmount(player, hero, STAT_DEFENCE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_DEFENSE] = value
    end
end

function Routine_CheckLearning(player, hero, mastery, level)
    log("$ Routine_CheckLearning")
    local level = level or GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, 0, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_LEARNING]
    if diff ~= 0 then
        if hero == H_RANLETH then diff = 2 * diff end
        AddHeroStatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_LEARNING] = value
    end
end

function Routine_CheckSorcery(player, hero, mastery, level)
    log("$ Routine_CheckSorcery")
    local level = level or GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, 0, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_SORCERY]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_SORCERY] = value
    end
end

function Routine_CheckVoice(player, hero, mastery, level)
    log("$ Routine_CheckVoice")
    local level = level or GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, 0, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_VOICE]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_VOICE] = value
    end
end

function Routine_CheckCourage(player, hero, mastery, level)
    log("$ Routine_CheckCourage")
    local level = level or GetHeroLevel(hero)
    local value = mastery + trunc(0.1 * level) * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_COURAGE]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_MORALE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_COURAGE] = value
    end
end

function Routine_CheckAvenger(player, hero, mastery)
    log("$ Routine_CheckAvenger")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_AVENGER]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_LUCK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_AVENGER] = value
    end
end

function Routine_CheckSpiritism(player, hero, mastery)
    log("$ Routine_CheckSpiritism")
    local current = HERO_SKILL_BONUSES[hero][SKILLBONUS_SPIRITISM]
    HERO_SKILL_BONUSES[hero][SKILLBONUS_SPIRITISM] = mastery
    if mastery > current then
        for rank = 1+current,mastery do
            local school = SPIRITISM_SCHOOL_AFFINITY[hero] and SPIRITISM_SCHOOL_AFFINITY[hero] or SPELL_SCHOOL_ANY
            school = school * mod(GetHeroLevel(hero),2)
            TeachHeroRandomSpellTier(player, hero, school, rank+2)
        end
    end
end

function Routine_LearnLightMagic(player, hero, mastery)
    log("$ Routine_LearnLightMagic")
    local diff = mastery - HERO_SKILL_BONUSES[hero][SKILLBONUS_LIGHT_MAGIC]
    if diff > 0 then
        TeachHeroRandomSpellTier(player, hero, SPELL_SCHOOL_LIGHT, mastery+2)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_LIGHT_MAGIC] = mastery
    end
end

function Routine_LearnDarkMagic(player, hero, mastery)
    log("$ Routine_LearnDarkMagic")
    local diff = mastery - HERO_SKILL_BONUSES[hero][SKILLBONUS_DARK_MAGIC]
    if diff > 0 then
        TeachHeroRandomSpellTier(player, hero, SPELL_SCHOOL_DARK, mastery+2)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_DARK_MAGIC] = mastery
    end
end

function Routine_LearnNaturalMagic(player, hero, mastery)
    log("$ Routine_LearnNaturalMagic")
    local diff = mastery - HERO_SKILL_BONUSES[hero][SKILLBONUS_NATURAL_MAGIC]
    if diff > 0 then
        TeachHeroRandomSpellTier(player, hero, SPELL_SCHOOL_NATURAL, mastery+2)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_NATURAL_MAGIC] = mastery
    end
end

function Routine_LearnDestrMagic(player, hero, mastery)
    log("$ Routine_LearnDestrMagic")
    local diff = mastery - HERO_SKILL_BONUSES[hero][SKILLBONUS_DESTRUCT_MAGIC]
    if diff > 0 then
        TeachHeroRandomSpellTier(player, hero, SPELL_SCHOOL_DESTRUCT, mastery+2)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_DESTRUCT_MAGIC] = mastery
    end
end

function Routine_CheckPrecision(player, hero, mastery)
    log("$ Routine_CheckPrecision")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_PRECISION]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_LUCK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_PRECISION] = value
    end
end

function Routine_CheckHoldGround(player, hero, mastery)
    log("$ Routine_CheckHoldGround")
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_HOLD_GROUND]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_DEFENCE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_HOLD_GROUND] = value
    end
end

function Routine_CheckIntelligence(player, hero, mastery)
    log("$ Routine_CheckIntelligence")
    local value = 4 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_INTELLIGENCE]
    if diff ~= 0 then
        if hero == H_RANLETH then diff = 1.5 * diff end
        AddHeroStatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_INTELLIGENCE] = value
    end
end

function Routine_CheckExaltation(player, hero, mastery)
    log("$ Routine_CheckExaltation")
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_EXALTATION]
    if diff ~= 0 then
        if hero == H_RANLETH then diff = 2 * diff end
        AddHeroStatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_EXALTATION] = value
    end
end

function Routine_CheckArcaneExcellence(player, hero, mastery)
    log("$ Routine_CheckArcaneExcellence")
    local value = 3 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_ARCANE_EXCELLENCE]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_ARCANE_EXCELLENCE] = value
    end
end

function Routine_CheckGraduate(player, hero, mastery)
    log("$ Routine_CheckGraduate")
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_GRADUATE]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_GRADUATE] = value
    end
end

function Routine_CheckOccultism(player, hero, mastery)
    log("$ Routine_CheckOccultism")
    local value = 5 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_OCCULTISM]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_OCCULTISM] = value
    end
end

function Routine_CheckSecretsOfDestruct(player, hero, mastery)
    log("$ Routine_CheckSecretsOfDestruct")
    local value = 4 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_SECRETS_OF_DESTRUCT]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_SECRETS_OF_DESTRUCT] = value
    end
end

function Routine_CheckGetStronger(player, hero, mastery)
    log("$ Routine_CheckGetStronger")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_GET_STRONGER]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_ATTACK, diff)
        AddHeroStatAmount(player, hero, STAT_DEFENCE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_GET_STRONGER] = value
    end
end

function Routine_CheckGetWiser(player, hero, mastery)
    log("$ Routine_CheckGetWiser")
    local value = mastery * (1000 + round(0.05 * GetHeroStat(hero, STAT_EXPERIENCE)))
    local diff = mastery - HERO_SKILL_BONUSES[hero][SKILLBONUS_GET_WISER]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_EXPERIENCE, value)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_GET_WISER] = mastery
    end
end

function Routine_CheckLastStand(player, hero, mastery)
    log("$ Routine_CheckLastStand")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_LAST_STAND]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_MORALE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_LAST_STAND] = value
    end
end

Var_PlayerPathfinders = {0,0,0,0,0,0,0,0,0}
function Routine_RevealNeutralTowns(player, hero, mastery)
    if mastery > HERO_SKILL_BONUSES[hero][SKILLBONUS_PATHFINDING] then
        local radius = 10 + 5 * Var_PlayerPathfinders[player]
        for town,data in MAP_TOWNS do
            if GetObjectOwner(town) == PLAYER_NONE then OpenCircleFog(data.x, data.y, data.z, radius, player) end
        end
        Var_PlayerPathfinders[player] = Var_PlayerPathfinders[player] + 1
        HERO_SKILL_BONUSES[hero][SKILLBONUS_PATHFINDING] = 1
    end
end

function Routine_GearUp(player, hero, mastery)
    log("$ Routine_GearUp")
    if mastery > HERO_SKILL_BONUSES[hero][SKILLBONUS_GEAR_UP] then
        local faction = HEROES[hero].faction
        local minors = {}
        for set = 1,ARTIFACT_SET_COUNT do
            if set == faction or set > 9 then
                for _,a in ARTIFACT_SETS[set] do
                    if ARTIFACTS_DATA[a].special == 0 and ARTIFACTS_DATA[a].class == ARTIFACT_CLASS_MINOR then
                        insert(minors, a)
                    end
                end
            end
        end
        local artifact = minors[random(1, length(minors), TURN)]
        GiveArtifact(hero, artifact)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_GEAR_UP] = 1
    end
end

function Routine_HeroesLegacy(player, hero, mastery)
    log("$ Routine_HeroesLegacy")
    if mastery > HERO_SKILL_BONUSES[hero][SKILLBONUS_HEROES_LEGACY] then
        local faction = HEROES[hero].faction
        local majors = {}
        for set = 1,ARTIFACT_SET_COUNT do
            if set == faction or set > 9 then
                for _,a in ARTIFACT_SETS[set] do
                    if ARTIFACTS_DATA[a].special == 0 and ARTIFACTS_DATA[a].class == ARTIFACT_CLASS_MAJOR then
                        insert(majors, a)
                    end
                end
            end
        end
        local artifact = majors[random(1, length(majors), TURN)]
        GiveArtifact(hero, artifact)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_HEROES_LEGACY] = 1
    end
end

function Routine_Mythology(player, hero, mastery)
    log("$ Routine_Mythology")
    if mastery > HERO_SKILL_BONUSES[hero][SKILLBONUS_MYTHOLOGY] then
        local faction = HEROES[hero].faction
        local relics = {}
        for set = 1,ARTIFACT_SET_COUNT do
            if set == faction or set > 9 then
                for _,a in ARTIFACT_SETS[set] do
                    if ARTIFACTS_DATA[a].special == 0 and ARTIFACTS_DATA[a].class == ARTIFACT_CLASS_RELIC then
                        insert(relics, a)
                    end
                end
            end
        end
        local artifact = relics[random(1, length(relics), TURN)]
        GiveArtifact(hero, artifact)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_MYTHOLOGY] = 1
    end
end

function Routine_CheckBattleCommander(player, hero, mastery)
    log("$ Routine_CheckBattleCommander")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_BATTLE_COMMANDER]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_DEFENCE, 2*diff)
        AddHeroStatAmount(player, hero, STAT_MORALE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_BATTLE_COMMANDER] = value
    end
end

function Routine_CheckKnowYourEnemy(player, hero, mastery)
    log("$ Routine_CheckKnowYourEnemy")
    ControlHeroCustomAbility(hero, CUSTOM_ABILITY_2, mastery)
end

function Routine_CheckFineRune(player, hero, mastery)
    log("$ Routine_CheckFineRune")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_FINE_RUNE]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_FINE_RUNE] = value
    end
end

function Routine_CheckRefreshRune(player, hero, mastery)
    log("$ Routine_CheckRefreshRune")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_REFRESH_RUNE]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_REFRESH_RUNE] = value
    end
end

function Routine_CheckGreaterRune(player, hero, mastery)
    log("$ Routine_CheckGreaterRune")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_GREATER_RUNE]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_GREATER_RUNE] = value
    end
end

function Routine_CheckLordOfTheUndead(player, hero, mastery)
    log("$ Routine_CheckLordOfTheUndead")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_LORD_OF_THE_UNDEAD]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_SPELL_POWER, 3*diff)
        AddHeroStatAmount(player, hero, STAT_KNOWLEDGE, 2*diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_LORD_OF_THE_UNDEAD] = value
    end
end

function Routine_CheckDefendUsAll(player, hero, mastery)
    log("$ Routine_CheckDefendUsAll")
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_DEFEND_US_ALL]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_ATTACK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_DEFEND_US_ALL] = value
    end
end

function Routine_CheckSheerStrength(player, hero, mastery)
    log("$ Routine_CheckSheerStrength")
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_SHEER_STRENGTH]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_ATTACK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_SHEER_STRENGTH] = value
    end
end

function Routine_StaminaBuff(player, hero, mastery)
    log("$ Routine_StaminaBuff")
    if mastery == 1 then
        GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_HITPOINTS, 10)
    end
end

function Routine_RageAwakening(player, hero, mastery)
    log("$ Routine_RageAwakening")
    if mastery == 1 then
        GiveHeroSkill(hero, SKILL_BLOOD_RAGE)
    end
end

function Routine_CheckInfusion(player, hero, mastery)
    log("$ Routine_CheckInfusion")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_INFUSION]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_SPELL_POWER, diff)
        AddHeroManaUnbound(player, hero, 50)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_INFUSION] = value
    end
end

function Routine_CheckEnlightened(player, hero, mastery)
    log("$ Routine_CheckEnlightened")
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_ENLIGHTENED]
    if diff ~= 0 then
        AddHeroStatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_ENLIGHTENED] = value
        ChangeHeroStat(hero, STAT_EXPERIENCE, 1000)
    end
end



function Routine_OnslaughtBuff(player, hero, mastery)
    log("$ Routine_OnslaughtBuff")
    if HERO_SKILL_BONUSES[hero][SKILLBONUS_ONSLAUGHT] == 0 then
        GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_INITIATIVE, 2)
        GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_SPEED, 1)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_ONSLAUGHT] = 1
    end
end

function RoutineEstatesDaily(player, hero, mastery)
    log("$ RoutineEstatesDaily")
    local total = 0
    for obj,_ in RESOURCE_GENERATING_OBJECTS do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then
                total = total + 25
            end
        end
    end
    for _,obj in Dwellings_T1 do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then
                total = total + 25
            end
        end
    end
    for _,obj in Dwellings_T2 do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then
                total = total + 25
            end
        end
    end
    for _,obj in Dwellings_T3 do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then
                total = total + 25
            end
        end
    end
    for _,obj in Dwellings_MP do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then
                total = total + 25
            end
        end
    end
    if HasArtefact(hero, ARTIFACT_CROWN_OF_LEADER, 1) then total = 2 * total end
    AddPlayerResource(player, hero, GOLD, total)
end

function Routine_GeologyDaily(player, hero, mastery)
    log("$ Routine_GeologyDaily")
    AddPlayerResource(player, hero, ORE, 1)
end

function Routine_IndustryDaily(player, hero, mastery)
    log("$ Routine_IndustryDaily")
    local total = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0}
    local xh,yh,zh = GetObjectPosition(hero)
    for obj,data in RESOURCE_GENERATING_OBJECTS do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then
                local x,y,z = GetObjectPosition(building)
                if z == zh then
                    local dx = x - xh
                    local dy = y - yh
                    local d = dx * dx + dy * dy
                    local res = data.type or random(0,5,d)
                    if d < 100 then total[res] = total[res] + data.amount end
                end
            end
        end
    end
    for res,amount in total do
        AddPlayerResource(player, hero, res, amount) sleep()
    end
end

function Routine_HeraldOfDeathGolds(player, hero, mastery)
    log("$ Routine_HeraldOfDeathGolds")
    local amount = GetHeroCreatures(hero, CREATURE_SKELETON) + GetHeroCreatures(hero, CREATURE_SKELETON_ARCHER) + GetHeroCreatures(hero, CREATURE_SKELETON_WARRIOR)
    AddPlayerResource(player, hero, GOLD, amount)
end

function Routine_SpiritismManaRegen(player, hero, mastery)
    log("$ Routine_SpiritismManaRegen")
    local max_mana = 10 * GetHeroStat(hero, STAT_KNOWLEDGE)
    local regen = max_mana * mastery * 0.05
    local missing = max_mana - GetHeroStat(hero, STAT_MANA_POINTS)
    ChangeHeroStat(hero, STAT_MANA_POINTS, min(regen, missing))
end



function Routine_WeeklyElementalWarriors(hero, elem)
    local amount = 10 + WEEKS
    if hero == H_ZEHIR then amount = 2 * amount end
    AddHeroCreatures(hero, elem, amount)
end

function Routine_WarriorsOfTheMagma(player, hero, mastery)
    log("$ Routine_WarriorsOfTheMagma")
    Routine_WeeklyElementalWarriors(hero, CREATURE_FIRE_ELEMENTAL)
end
function Routine_WarriorsOfTheSea(player, hero, mastery)
    log("$ Routine_WarriorsOfTheSea")
    Routine_WeeklyElementalWarriors(hero, CREATURE_WATER_ELEMENTAL)
end
function Routine_WarriorsOfTheSky(player, hero, mastery)
    log("$ Routine_WarriorsOfTheSky")
    Routine_WeeklyElementalWarriors(hero, CREATURE_AIR_ELEMENTAL)
end
function Routine_WarriorsOfTheMountain(player, hero, mastery)
    log("$ Routine_WarriorsOfTheMountain")
    Routine_WeeklyElementalWarriors(hero, CREATURE_EARTH_ELEMENTAL)
end

Var_LastVisitedTown = {}
function Routine_LogisticsVisitTown(hero, obj)
    if MAP_TOWNS[obj] then Var_LastVisitedTown[hero] = obj end
end

function Routine_LogisticsWeeklyProd(player, hero, mastery)
    log("$ Routine_LogisticsWeeklyProd")
    local town = nil
    if Var_LastVisitedTown[hero] then town = Var_LastVisitedTown[hero]
    else town = FindClosestTown(player, hero) end
    if town then
        local faction = MAP_TOWNS[town].faction
        local fort = GetTownBuildingLevel(town, TOWN_BUILDING_FORT)
        local grail = GetTownBuildingLevel(town, TOWN_BUILDING_GRAIL)
        local factor = 1 + 0.5 * grail
        if fort > 1 then factor = factor + 0.5 * (fort-1) end
        local recr = GetHeroSkillMastery(hero, PERK_RECRUITMENT)
        if HasArtefact(hero, ARTIFACT_CROWN_OF_LEADER, 1) then recr = 2 * recr end
        local bonus = 1 + recr
        if hero == H_WYNGAAL then bonus = bonus + 0.05 * GetHeroLevel(hero) end
        if mastery >= 1 and GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_1) ~= 0 then
            local creature = CREATURES_BY_FACTION[faction][1][1]
            local current = GetObjectDwellingCreatures(town, creature)
            local amount = current + 5 * factor * bonus
            SetObjectDwellingCreatures(town, creature, amount)
        end
        if mastery >= 2 and GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_2) ~= 0 then
            local creature = CREATURES_BY_FACTION[faction][2][1]
            local current = GetObjectDwellingCreatures(town, creature)
            local amount = current + 5 * factor * bonus
            SetObjectDwellingCreatures(town, creature, amount)
        end
        if mastery >= 3 and GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_3) ~= 0 then
            local creature = CREATURES_BY_FACTION[faction][3][1]
            local current = GetObjectDwellingCreatures(town, creature)
            local amount = current + 5 * factor * bonus
            SetObjectDwellingCreatures(town, creature, amount)
        end
    end
end

function Routine_GovernanceWeeklyResources(player, hero, mastery)
    log("$ Routine_GovernanceWeeklyResources")
    local golds = { [0]=0, [1]=1000, [2]=2500, [3]=5000 }
    local res = { [HAVEN]=CRYSTAL, [PRESERVE]=GEM, [FORTRESS]=CRYSTAL, [ACADEMY]=GEM, [DUNGEON]=SULFUR, [NECROPOLIS]=MERCURY, [INFERNO]=SULFUR, [STRONGHOLD]=MERCURY }
    local faction = HEROES[hero].faction
    sleep(3) AddPlayerResource(player, hero, GOLD, golds[mastery])
    sleep(3) AddPlayerResource(player, hero, res[faction], mastery)
end

function Routine_GearUpWeeklyGolds(player, hero, mastery)
    log("$ Routine_GearUpWeeklyGolds")
    local count = 0
    for a,data in ARTIFACTS_DATA do
        if data.class == ARTIFACT_CLASS_MINOR then
            if HasArtefact(hero, a, 1) then count = count + 1 end
        end
    end
    AddPlayerResource(player, hero, GOLD, 400 * count)
end

function Routine_HeroesLegacyWeeklyGolds(player, hero, mastery)
    log("$ Routine_HeroesLegacyWeeklyGolds")
    local count = 0
    for a,data in ARTIFACTS_DATA do
        if data.class == ARTIFACT_CLASS_MAJOR then
            if HasArtefact(hero, a, 1) then count = count + 1 end
        end
    end
    AddPlayerResource(player, hero, GOLD, 600 * count)
end

function Routine_MythologyWeeklyGolds(player, hero, mastery)
    log("$ Routine_MythologyWeeklyGolds")
    local count = 0
    for a,data in ARTIFACTS_DATA do
        if data.class == ARTIFACT_CLASS_RELIC then
            if HasArtefact(hero, a, 1) then count = count + 1 end
        end
    end
    AddPlayerResource(player, hero, GOLD, 800 * count)
end

function Routine_GetStrongerWeeklyBonus(player, hero, mastery)
    log("$ Routine_GetStrongerWeeklyBonus")
    AddHeroStatAmount(player, hero, STAT_ATTACK, 1)
    AddHeroStatAmount(player, hero, STAT_DEFENCE, 1)
end

function Routine_GetWiserWeeklyBonus(player, hero, mastery)
    log("$ Routine_GetWiserWeeklyBonus")
    local exp = 1000 + round(0.05 * GetHeroStat(hero, STAT_EXPERIENCE))
    AddHeroStatAmount(player, hero, STAT_EXPERIENCE, exp)
end

function Routine_BattleCommanderWeeklyDancers(player, hero, mastery)
    log("$ Routine_BattleCommanderWeeklyDancers")
    local amount = 27 + 12 * WEEKS
    AddHeroCreatureType(player, hero, PRESERVE, 1, amount, 2)
end

function Routine_HauntingWeeklyGhosts(player, hero, mastery)
    log("$ Routine_HauntingWeeklyGhosts")
    local amount = 5 + 2 * WEEKS
    for obj,_ in RESOURCE_GENERATING_OBJECTS do
        for _,building in GetObjectNamesByType(obj) do
            if GetObjectOwner(building) == player then
                AddObjectCreatures(building, CREATURE_MANES, amount)
            end
        end
    end
end

function Routine_DefendUsAllWeeklyWarriors(player, hero, mastery)
    log("$ Routine_DefendUsAllWeeklyWarriors")
    local amount = 17 + 7 * WEEKS
    AddHeroCreatureType(player, hero, STRONGHOLD, 3, amount, 1)
end

function Routine_InfusionWeeklyMana(player, hero, mastery)
    log("$ Routine_InfusionWeeklyMana")
    AddHeroManaUnbound(player, hero, 50)
end



function Routine_SpiritismLevelUp(player, hero, mastery, level)
    log("$ Routine_SpiritismLevelUp")
    if not HasHeroSkill(hero, SKILL_BLOOD_RAGE) then
        if mod(level, 2) == 0 then
            TeachHeroRandomSpell(player, hero, SPELL_SCHOOL_ANY, mastery+2)
        end
    end
end



function Routine_LeadershipAfterBattle(player, hero, mastery, combatIndex)
    log("$ Routine_LeadershipAfterBattle")
    if GetSavedCombatArmyHero(combatIndex, 0) then return end
    local x, y, z = GetObjectPosition(hero)
    local town_data = PLAYER_MAIN_TOWN[player] and MAP_TOWNS[PLAYER_MAIN_TOWN[player]] or nil
    -- log("Hero at x="..x..", y="..y)
    local found = nil
    for i = -1,1 do for j = -1,1 do
        objects = GetObjectsFromPath(hero, x+i, y+j, z)
        if length(objects) == 0 then x=x+i; y=y+j; found = not nil; break end
    end if found then break end end
    -- if found then log("Spawn caravan at x="..x..", y="..y) else log("No available tile around hero was found"); return end
    local dx = town_data and town_data.x or x
    local dy = town_data and town_data.y or y
    local dz = town_data and town_data.z or z
    local caravan = "Caravan-"..NB_CARAVAN
    NB_CARAVAN = NB_CARAVAN + 1
    CreateCaravan(caravan, player, z, x, y, dz, dx, dy)
    repeat sleep(1) until IsObjectExists(caravan)
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 0)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 0, i)
        local bonus = 0
        if hero == H_DUNCAN then
            bonus = bonus + GetHeroLevel(hero)
        end
        if hero == H_ARANTIR then
            if CREATURES[creature][1] == NECROPOLIS or creature == CREATURE_BLACK_KNIGHT or creature == CREATURE_DEATH_KNIGHT or creature == CREATURE_MUMMY then
                bonus = bonus + 50
            end
        end
        if HasHeroSkill(hero, PERK_CHARISMA) then
            bonus = bonus + 5 + 5 * mastery
        end
        local amount = trunc(count * (0.05 + 0.05 * mastery + 0.01 * bonus))
        if HasHeroSkill(hero, PERK_HERALD_OF_DEATH) then creature = CreatureToUndead(creature) end
        if amount > 0 then
            AddObjectCreatures(caravan, creature, amount)
        end
    end
    CURRENT_CARAVANS[caravan] = 3
end

function Routine_TaleTellers(player, hero, mastery, combatIndex)
    log("$ Routine_TaleTellers")
    local exp = trunc(0.67 * GetArmyStrength(combatIndex, 0))
    for _,h in GetPlayerHeroes(player) do
        if h ~= hero then
            AddHeroStatAmount(player, h, STAT_EXPERIENCE, exp)
        end
    end
end

Var_SpoilersVictories = {}
function Routine_SpoilsOfWarArtifact(player, hero, mastery, combatIndex)
    log("$ Routine_SpoilsOfWarArtifact")
    Var_SpoilersVictories[hero] = Var_SpoilersVictories[hero] and Var_SpoilersVictories[hero] + 1 or 1
    if mod(Var_SpoilersVictories[hero],10) == 0 then
        local pool = {}
        for artifact,data in ARTIFACTS_DATA do
            if data.special == 0 and data.class == ARTIFACT_CLASS_MINOR then insert(pool, artifact) end
        end
        local artefact = pool[random(1, length(pool), TURN)]
        GiveArtifact(hero, artefact)
    end
end

function Routine_OnslaughtReset(player, hero, mastery, combatIndex)
    log("$ Routine_OnslaughtReset")
    HERO_SKILL_BONUSES[hero][SKILLBONUS_ONSLAUGHT] = 0
end



function Routine_MeditationExp(player, hero, amount)
    log("$ Routine_MeditationExp")
    AddHeroStatAmount(player, hero, STAT_EXPERIENCE, 50 * amount)
end


START_TRIGGER_SKILLS_ROUTINES = {
    [SKILL_OFFENCE] = Routine_CheckOffence,
    [SKILL_DEFENSE] = Routine_CheckDefense,
    [SKILL_LEARNING] = Routine_CheckLearning,
    [SKILL_SORCERY] = Routine_CheckSorcery,
    [SKILL_VOICE] = Routine_CheckVoice,
    [SKILL_LIGHT_MAGIC] = Routine_LearnLightMagic,
    [SKILL_DARK_MAGIC] = Routine_LearnDarkMagic,
    [SKILL_NATURAL_MAGIC] = Routine_LearnNaturalMagic,
    [SKILL_DESTRUCTIVE_MAGIC] = Routine_LearnDestrMagic,
    [SKILL_COURAGE] = Routine_CheckCourage,
    [SKILL_AVENGER] = Routine_CheckAvenger,
    [SKILL_SPIRITISM] = Routine_CheckSpiritism,
    [PERK_PRECISION] = Routine_CheckPrecision,
    [PERK_HOLD_GROUND] = Routine_CheckHoldGround,
    [PERK_INTELLIGENCE] = Routine_CheckIntelligence,
    [PERK_EXALTATION] = Routine_CheckExaltation,
    [PERK_ARCANE_EXCELLENCE] = Routine_CheckArcaneExcellence,
    [PERK_GRADUATE] = Routine_CheckGraduate,
    [PERK_OCCULTISM] = Routine_CheckOccultism,
    [PERK_SECRETS_OF_DESTRUCT] = Routine_CheckSecretsOfDestruct,
    [PERK_GET_STRONGER] = Routine_CheckGetStronger,
    [PERK_GET_WISER] = Routine_CheckGetWiser,
    [PERK_ONSLAUGHT] = Routine_OnslaughtBuff,
    [PERK_LAST_STAND] = Routine_CheckLastStand,
    [PERK_PATHFINDING] = Routine_RevealNeutralTowns,
    [PERK_GEAR_UP] = Routine_GearUp,
    [PERK_HEROES_LEGACY] = Routine_HeroesLegacy,
    [PERK_MYTHOLOGY] = Routine_Mythology,
    [PERK_BATTLE_COMMANDER] = Routine_CheckBattleCommander,
    [PERK_KNOW_YOUR_ENEMY] = Routine_CheckKnowYourEnemy,
    [PERK_FINE_RUNE] = Routine_CheckFineRune,
    [PERK_REFRESH_RUNE] = Routine_CheckRefreshRune,
    [PERK_GREATER_RUNE] = Routine_CheckGreaterRune,
    [PERK_LORD_OF_UNDEAD] = Routine_CheckLordOfTheUndead,
    [PERK_DEFEND_US_ALL] = Routine_CheckDefendUsAll,
    [PERK_SHEER_STRENGTH] = Routine_CheckSheerStrength,
    [PERK_STAMINA] = Routine_StaminaBuff,
    [PERK_RAGE_AWAKENING] = Routine_RageAwakening,
    [PERK_INFUSION] = Routine_CheckInfusion,
    [PERK_ENLIGHTENED] = Routine_CheckEnlightened,
}

DAILY_TRIGGER_SKILLS_ROUTINES = {
    [PERK_ONSLAUGHT] = Routine_OnslaughtBuff,
    [PERK_ESTATES] = RoutineEstatesDaily,
    [PERK_GEOLOGY] = Routine_GeologyDaily,
    [PERK_INDUSTRY] = Routine_IndustryDaily,
    [PERK_HERALD_OF_DEATH] = Routine_HeraldOfDeathGolds,
    [SKILL_SPIRITISM] = Routine_SpiritismManaRegen,
}

WEEKLY_TRIGGER_SKILLS_ROUTINES = {
    [PERK_WARRIORS_OF_THE_MAGMA] = Routine_WarriorsOfTheMagma,
    [PERK_WARRIORS_OF_THE_SEA] = Routine_WarriorsOfTheSea,
    [PERK_WARRIORS_OF_THE_SKY] = Routine_WarriorsOfTheSky,
    [PERK_WARRIORS_OF_THE_MOUNTAIN] = Routine_WarriorsOfTheMountain,
    [SKILL_LOGISTICS] = Routine_LogisticsWeeklyProd,
    [SKILL_GOVERNANCE] = Routine_GovernanceWeeklyResources,
    [PERK_GEAR_UP] = Routine_GearUpWeeklyGolds,
    [PERK_HEROES_LEGACY] = Routine_HeroesLegacyWeeklyGolds,
    [PERK_MYTHOLOGY] = Routine_MythologyWeeklyGolds,
    [PERK_GET_STRONGER] = Routine_GetStrongerWeeklyBonus,
    [PERK_GET_WISER] = Routine_GetWiserWeeklyBonus,
    [PERK_BATTLE_COMMANDER] = Routine_BattleCommanderWeeklyDancers,
    [PERK_HAUNTING] = Routine_HauntingWeeklyGhosts,
    [PERK_DEFEND_US_ALL] = Routine_DefendUsAllWeeklyWarriors,
    [PERK_INFUSION] = Routine_InfusionWeeklyMana,
}

LEVELUP_TRIGGER_SKILLS_ROUTINES = {
    [SKILL_OFFENCE] = Routine_CheckOffence,
    [SKILL_DEFENSE] = Routine_CheckDefense,
    [SKILL_LEARNING] = Routine_CheckLearning,
    [SKILL_SORCERY] = Routine_CheckSorcery,
    [SKILL_VOICE] = Routine_CheckVoice,
    [SKILL_COURAGE] = Routine_CheckCourage,
    [SKILL_SPIRITISM] = Routine_SpiritismLevelUp,
}

AFTER_COMBAT_TRIGGER_SKILLS_ROUTINES = {
    [SKILL_LEADERSHIP] = Routine_LeadershipAfterBattle,
    [PERK_TALETELLERS] = Routine_TaleTellers,
    [PERK_SPOILS_OF_WAR] = Routine_SpoilsOfWarArtifact,
    [PERK_ONSLAUGHT] = Routine_OnslaughtReset,
    [PERK_STAMINA] = Routine_StaminaBuff,
}


function DoSkillsRoutine_Start(player, hero)
    log("$ DoSkillsRoutine_Start - "..hero)
    for skill = 1,207 do
        if HasHeroSkill(hero, skill) then
            local mastery = GetHeroSkillMastery(hero, skill)
            Register(VarHeroSkillId(hero, skill), mastery)
            if START_TRIGGER_SKILLS_ROUTINES[skill] then
                startThread(START_TRIGGER_SKILLS_ROUTINES[skill], player, hero, mastery)
            end
        end
    end
end

function DoSkillsRoutine_Daily(player, hero)
    log("$ DoSkillsRoutine_Daily - "..hero)
    for k,v in DAILY_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            local mastery = GetHeroSkillMastery(hero, k)
            startThread(v, player, hero, mastery)
        end
    end
end

function DoSkillsRoutine_Weekly(player, hero)
    log("$ DoSkillsRoutine_Weekly - "..hero)
    for k,v in WEEKLY_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            local mastery = GetHeroSkillMastery(hero, k)
            startThread(v, player, hero, mastery)
        end
    end
end

function DoSkillsRoutine_LevelUp(player, hero, level)
    log("$ DoSkillsRoutine_LevelUp - "..hero)
    for k,v in LEVELUP_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            local mastery = GetHeroSkillMastery(hero, k)
            startThread(v, player, hero, mastery, level)
        end
    end
end

function DoSkillsRoutine_AfterCombat(player, hero, index)
    log("$ DoSkillsRoutine_AfterCombat - "..hero)
    for k,v in AFTER_COMBAT_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            local mastery = GetHeroSkillMastery(hero, k)
            startThread(v, player, hero, mastery, index)
        end
    end
end


-- log("Loaded skills-routines-advmap.lua")
ROUTINES_LOADED[11] = 1
