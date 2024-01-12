
function Routine_CheckOffence(player, hero, mastery)
    print("$ Routine_CheckOffence")
    local level = GetHeroLevel(hero)
    Routine_CheckOffenceLevelUp(player, hero, mastery, level)
end

function Routine_CheckDefense(player, hero, mastery)
    print("$ Routine_CheckDefense")
    local level = GetHeroLevel(hero)
    Routine_CheckDefenseLevelUp(player, hero, mastery, level)
end

function Routine_CheckLearning(player, hero, mastery)
    print("$ Routine_CheckLearning")
    local level = GetHeroLevel(hero)
    Routine_CheckLearningLevelUp(player, hero, mastery, level)
end

function Routine_CheckSorcery(player, hero, mastery)
    print("$ Routine_CheckSorcery")
    local level = GetHeroLevel(hero)
    Routine_CheckSorceryLevelUp(player, hero, mastery, level)
end

function Routine_CheckVoice(player, hero, mastery)
    print("$ Routine_CheckVoice")
    local level = GetHeroLevel(hero)
    Routine_CheckVoiceLevelUp(player, hero, mastery, level)
end

function Routine_CheckCombat(player, hero, mastery)
    print("$ Routine_CheckCombat")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_COMBAT]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_ATTACK, diff)
        AddHero_StatAmount(player, hero, STAT_DEFENCE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_COMBAT] = value
    end
end

function Routine_CheckCourage(player, hero, mastery)
    print("$ Routine_CheckCourage")
    local level = GetHeroLevel(hero)
    Routine_CheckCourageLevelUp(player, hero, mastery, level)
end

function Routine_CheckAvenger(player, hero, mastery)
    print("$ Routine_CheckAvenger")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_AVENGER]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_LUCK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_AVENGER] = value
    end
end

function Routine_CheckSpiritism(player, hero, mastery)
    print("$ Routine_CheckSpiritism")
    local current = HERO_SKILL_BONUSES[hero][SKILLBONUS_SPIRITISM]
    if mastery > current then
        for rank = 1+current,mastery do
            local school = SPIRITISM_SCHOOL_AFFINITY[hero] and SPIRITISM_SCHOOL_AFFINITY[hero] or SPELL_SCHOOL_ANY
            AddHero_RandomSpellTier(player, hero, school, rank+2)
        end
    end
end

function Routine_CheckPrecision(player, hero, mastery)
    print("$ Routine_CheckPrecision")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_PRECISION]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_LUCK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_PRECISION] = value
    end
end

function Routine_CheckIntelligence(player, hero, mastery)
    print("$ Routine_CheckIntelligence")
    local value = 5 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_INTELLIGENCE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_INTELLIGENCE] = value
    end
end

function Routine_CheckExaltation(player, hero, mastery)
    print("$ Routine_CheckExaltation")
    local value = 3 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_EXALTATION]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_EXALTATION] = value
    end
end

function Routine_CheckArcaneExcellence(player, hero, mastery)
    print("$ Routine_CheckArcaneExcellence")
    local value = 4 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_ARCANE_EXCELLENCE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_ARCANE_EXCELLENCE] = value
    end
end

function Routine_CheckGraduate(player, hero, mastery)
    print("$ Routine_CheckGraduate")
    local value = 3 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_GRADUATE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_GRADUATE] = value
    end
end

function Routine_CheckOccultism(player, hero, mastery)
    print("$ Routine_CheckOccultism")
    local value = 6 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_OCCULTISM]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_OCCULTISM] = value
    end
end

function Routine_CheckSecretsOfDestruct(player, hero, mastery)
    print("$ Routine_CheckSecretsOfDestruct")
    local value = 5 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_SECRETS_OF_DESTRUCT]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_SECRETS_OF_DESTRUCT] = value
    end
end

function Routine_CheckMotivation(player, hero, mastery)
    print("$ Routine_CheckMotivation")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_MOTIVATION]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_MORALE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_MOTIVATION] = value
    end
end

function Routine_CheckBattleCommander(player, hero, mastery)
    print("$ Routine_CheckBattleCommander")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_BATTLE_COMMANDER]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_DEFENCE, 2*diff)
        AddHero_StatAmount(player, hero, STAT_MORALE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_BATTLE_COMMANDER] = value
    end
end

function Routine_CheckFineRune(player, hero, mastery)
    print("$ Routine_CheckFineRune")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_FINE_RUNE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_FINE_RUNE] = value
    end
end

function Routine_CheckRefreshRune(player, hero, mastery)
    print("$ Routine_CheckRefreshRune")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_REFRESH_RUNE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_REFRESH_RUNE] = value
    end
end

function Routine_CheckGreaterRune(player, hero, mastery)
    print("$ Routine_CheckGreaterRune")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_GREATER_RUNE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_GREATER_RUNE] = value
    end
end

function Routine_CheckLordOfTheUndead(player, hero, mastery)
    print("$ Routine_CheckLordOfTheUndead")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_LORD_OF_THE_UNDEAD]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, 3*diff)
        AddHero_StatAmount(player, hero, STAT_KNOWLEDGE, 2*diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_LORD_OF_THE_UNDEAD] = value
    end
end

function Routine_CheckDefendUsAll(player, hero, mastery)
    print("$ Routine_CheckDefendUsAll")
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_DEFEND_US_ALL]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_ATTACK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_DEFEND_US_ALL] = value
    end
end

function Routine_CheckSheerStrength(player, hero, mastery)
    print("$ Routine_CheckSheerStrength")
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_SHEER_STRENGTH]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_ATTACK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_SHEER_STRENGTH] = value
    end
end

function Routine_RageAwakening(player, hero, mastery)
    print("$ Routine_RageAwakening")
    GiveHeroSkill(hero, SKILL_BLOOD_RAGE)
end


function Routine_HeraldOfDeathGolds(player, hero, mastery)
    print("$ Routine_HeraldOfDeathGolds")
    local amount = GetHeroCreatures(hero, CREATURE_SKELETON) + GetHeroCreatures(hero, CREATURE_SKELETON_ARCHER) + GetHeroCreatures(hero, CREATURE_SKELETON_WARRIOR)
    AddPlayer_Resource(player, hero, GOLD, amount)
end

function Routine_SpiritismManaRegen(player, hero, mastery)
    print("$ Routine_SpiritismManaRegen")
    local max_mana = 10 * GetHeroStat(hero, STAT_KNOWLEDGE)
    local regen = max_mana * mastery * 0.05
    local missing = max_mana - GetHeroStat(hero, STAT_MANA_POINTS)
    ChangeHeroStat(hero, STAT_MANA_POINTS, min(regen, missing))
end


function Routine_LogisticsWeeklyProd(player, hero, mastery)
    print("$ Routine_LogisticsWeeklyProd")
    for town,data in MAP_TOWNS do
        if IsHeroInTown(hero, town, 1, 1) then
            local fort = GetTownBuildingLevel(town, TOWN_BUILDING_FORT)
            local grail = GetTownBuildingLevel(town, TOWN_BUILDING_GRAIL)
            local multiplier = 1 + 0.5 * grail
            if fort > 1 then multiplier = multiplier + 0.5 * (fort-1) end
            if mastery >= 1 and GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_1) ~= 0 then
                local creature = CREATURES_BY_FACTION[data[0]][1][0]
                local current = GetObjectDwellingCreatures(town, creature)
                SetObjectDwellingCreatures(town, creature, current + 5*multiplier)
            end
            if mastery >= 2 and GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_2) ~= 0 then
                local creature = CREATURES_BY_FACTION[data[0]][2][0]
                local current = GetObjectDwellingCreatures(town, creature)
                SetObjectDwellingCreatures(town, creature, current + 3*multiplier)
            end
            if mastery >= 3 and GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_3) ~= 0 then
                local creature = CREATURES_BY_FACTION[data[0]][3][0]
                local current = GetObjectDwellingCreatures(town, creature)
                SetObjectDwellingCreatures(town, creature, current + 2*multiplier)
            end
        end
    end
end

function Routine_HauntingWeeklyGhosts(player, hero, mastery)
    print("$ Routine_HauntingWeeklyGhosts")
    local amount = 10 + 5 * WEEK
    for _,type in RESOURCE_GENERATING_OBJECTS do
        for _,building in GetObjectNamesByType(type) do
            if GetObjectOwner(building) == player then
                AddObjectCreatures(building, CREATURE_GHOST, amount)
            end
        end
    end
end


function Routine_CheckOffenceLevelUp(player, hero, mastery, level)
    print("$ Routine_CheckOffenceLevelUp")
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_OFFENCE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_ATTACK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_OFFENCE] = value
    end
end

function Routine_CheckDefenseLevelUp(player, hero, mastery, level)
    print("$ Routine_CheckDefenseLevelUp")
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_DEFENSE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_DEFENCE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_DEFENSE] = value
    end
end

function Routine_CheckLearningLevelUp(player, hero, mastery, level)
    print("$ Routine_CheckLearningLevelUp")
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_LEARNING]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_LEARNING] = value
    end
end

function Routine_CheckSorceryLevelUp(player, hero, mastery, level)
    print("$ Routine_CheckSorceryLevelUp")
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_SORCERY]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_SORCERY] = value
    end
end

function Routine_CheckVoiceLevelUp(player, hero, mastery, level)
    print("$ Routine_CheckVoiceLevelUp")
    local level = GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, mastery, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_VOICE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_VOICE] = value
    end
end

function Routine_CheckCourageLevelUp(player, hero, mastery, level)
    print("$ Routine_CheckCourageLevelUp")
    local level = GetHeroLevel(hero)
    local value = mastery + trunc(0.1 * level) * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_COURAGE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_MORALE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_COURAGE] = value
    end
end

function Routine_SpiritismLevelUp(player, hero, mastery, level)
    print("$ Routine_SpiritismLevelUp")
    if not HasHeroSkill(hero, SKILL_BLOOD_RAGE) then
        AddHero_RandomSpell(player, hero, SPELL_SCHOOL_ANY, mastery+2)
    end
end


function Routine_LeadershipAfterBattle(player, hero, mastery, combatIndex)
    print("$ Routine_LeadershipAfterBattle")
    if GetSavedCombatArmyHero(combatIndex, 0) then return end
    local x, y, z = GetObjectPosition(hero)
    local town_data = PLAYER_MAIN_TOWN[player] and MAP_TOWNS[PLAYER_MAIN_TOWN[player]] or nil
    print("Hero at x="..x..", y="..y)
    local found = nil
    for i = -1,1 do for j = -1,1 do
        objects = GetObjectsFromPath(hero, x+i, y+j, z)
        if length(objects) == 0 then x=x+i; y=y+j; found = not nil; break end
    end if found then break end end
    if found then print("Spawn caravan at x="..x..", y="..y) else print("No available tile around hero was found"); return end
    local dx = town_data and town_data[1] or x
    local dy = town_data and town_data[2] or y
    local dz = town_data and town_data[3] or z
    local caravan = "Caravan-"..NB_CARAVAN
    NB_CARAVAN = NB_CARAVAN + 1
    CreateCaravan(caravan, player, z, x, y, dz, dx, dy)
    repeat sleep(1) until IsObjectExists(caravan)
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 0)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 0, i)
        local amount = trunc(died * (0.05 + 0.05 * mastery))
        AddObjectCreatures(caravan, creature, amount)
    end
    CURRENT_CARAVANS[caravan] = 3
end


START_TRIGGER_SKILLS_ROUTINES = {
    [SKILL_OFFENCE] = Routine_CheckOffence,
    [SKILL_DEFENSE] = Routine_CheckDefense,
    [SKILL_LEARNING] = Routine_CheckLearning,
    [SKILL_SORCERY] = Routine_CheckSorcery,
    [SKILL_VOICE] = Routine_CheckVoice,
    [SKILL_COMBAT] = Routine_CheckCombat,
    [SKILL_COURAGE] = Routine_CheckCourage,
    [SKILL_AVENGER] = Routine_CheckAvenger,
    [SKILL_SPIRITISM] = Routine_CheckSpiritism,
    [PERK_PRECISION] = Routine_CheckPrecision,
    [PERK_INTELLIGENCE] = Routine_CheckIntelligence,
    [PERK_EXALTATION] = Routine_CheckExaltation,
    [PERK_ARCANE_EXCELLENCE] = Routine_CheckArcaneExcellence,
    [PERK_GRADUATE] = Routine_CheckGraduate,
    [PERK_OCCULTISM] = Routine_CheckOccultism,
    [PERK_SECRETS_OF_DESTRUCT] = Routine_CheckSecretsOfDestruct,
    [PERK_MOTIVATION] = Routine_CheckMotivation,
    [PERK_FINE_RUNE] = Routine_CheckFineRune,
    [PERK_REFRESH_RUNE] = Routine_CheckRefreshRune,
    [PERK_GREATER_RUNE] = Routine_CheckGreaterRune,
    [PERK_LORD_OF_UNDEAD] = Routine_CheckLordOfTheUndead,
    [PERK_DEFEND_US_ALL] = Routine_CheckDefendUsAll,
    [PERK_SHEER_STRENGTH] = Routine_CheckSheerStrength,
    [PERK_RAGE_AWAKENING] = Routine_RageAwakening,
}

DAILY_TRIGGER_SKILLS_ROUTINES = {
    [PERK_HERALD_OF_DEATH] = Routine_HeraldOfDeathGolds,
    [SKILL_SPIRITISM] = Routine_SpiritismManaRegen,
}

WEEKLY_TRIGGER_SKILLS_ROUTINES = {
    [SKILL_LOGISTICS] = Routine_LogisticsWeeklyProd,
    [PERK_HAUNTING] = Routine_HauntingWeeklyGhosts,
}

LEVELUP_TRIGGER_SKILLS_ROUTINES = {
    [SKILL_OFFENCE] = Routine_CheckOffenceLevelUp,
    [SKILL_DEFENSE] = Routine_CheckDefenseLevelUp,
    [SKILL_LEARNING] = Routine_CheckLearningLevelUp,
    [SKILL_SORCERY] = Routine_CheckSorceryLevelUp,
    [SKILL_VOICE] = Routine_CheckVoiceLevelUp,
    [SKILL_COURAGE] = Routine_CheckCourageLevelUp,
    [SKILL_SPIRITISM] = Routine_SpiritismLevelUp,
}

AFTER_COMBAT_TRIGGER_SKILLS_ROUTINES = {
    [SKILL_LEADERSHIP] = Routine_LeadershipAfterBattle,
}


function DoSkillsRoutine_Start(player, hero)
    for k,v in START_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            print("Hero "..hero.." has strating skill "..k)
            local mastery = GetHeroSkillMastery(hero, k)
            startThread(v, player, hero, mastery)
        end
    end
end

function DoSkillsRoutine_Daily(player, hero)
    for k,v in DAILY_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            local mastery = GetHeroSkillMastery(hero, k)
            startThread(v, player, hero, mastery)
        end
    end
end

function DoSkillsRoutine_Weekly(player, hero)
    for k,v in WEEKLY_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            local mastery = GetHeroSkillMastery(hero, k)
            startThread(v, player, hero, mastery)
        end
    end
end

function DoSkillsRoutine_LevelUp(player, hero, level)
    for k,v in LEVELUP_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            local mastery = GetHeroSkillMastery(hero, k)
            startThread(v, player, hero, mastery, level)
        end
    end
end

function DoSkillsRoutine_AfterCombat(player, hero, index)
    for k,v in AFTER_COMBAT_TRIGGER_SKILLS_ROUTINES do
        if HasHeroSkill(hero, k) then
            local mastery = GetHeroSkillMastery(hero, k)
            startThread(v, player, hero, mastery, index)
        end
    end
end


-- print("Loaded skills advmap routines")
ROUTINES_LOADED[17] = 1
