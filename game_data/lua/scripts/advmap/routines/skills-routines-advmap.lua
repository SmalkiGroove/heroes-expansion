
function Routine_CheckOffence(player, hero, mastery, level)
    print("$ Routine_CheckOffence")
    local level = level or GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, 0, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_OFFENCE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_ATTACK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_OFFENCE] = value
    end
end

function Routine_CheckDefense(player, hero, mastery, level)
    print("$ Routine_CheckDefense")
    local level = level or GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, 0, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_DEFENSE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_DEFENCE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_DEFENSE] = value
    end
end

function Routine_CheckLearning(player, hero, mastery, level)
    print("$ Routine_CheckLearning")
    local level = level or GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, 0, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_LEARNING]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_LEARNING] = value
    end
end

function Routine_CheckSorcery(player, hero, mastery, level)
    print("$ Routine_CheckSorcery")
    local level = level or GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, 0, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_SORCERY]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_SORCERY] = value
    end
end

function Routine_CheckVoice(player, hero, mastery, level)
    print("$ Routine_CheckVoice")
    local level = level or GetHeroLevel(hero)
    local value = StatPerLevelDivisor(level, 0, 8 - mastery)
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_VOICE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_VOICE] = value
    end
end

function Routine_CheckCourage(player, hero, mastery, level)
    print("$ Routine_CheckCourage")
    local level = level or GetHeroLevel(hero)
    local value = mastery + trunc(0.1 * level) * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_COURAGE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_MORALE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_COURAGE] = value
    end
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

function Routine_CheckPrecision(player, hero, mastery)
    print("$ Routine_CheckPrecision")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_PRECISION]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_LUCK, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_PRECISION] = value
    end
end

function Routine_CheckHoldGround(player, hero, mastery)
    print("$ Routine_CheckHoldGround")
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_HOLD_GROUND]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_DEFENCE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_HOLD_GROUND] = value
    end
end

function Routine_CheckIntelligence(player, hero, mastery)
    print("$ Routine_CheckIntelligence")
    local value = 4 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_INTELLIGENCE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_INTELLIGENCE] = value
    end
end

function Routine_CheckExaltation(player, hero, mastery)
    print("$ Routine_CheckExaltation")
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_EXALTATION]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_EXALTATION] = value
    end
end

function Routine_CheckArcaneExcellence(player, hero, mastery)
    print("$ Routine_CheckArcaneExcellence")
    local value = 3 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_ARCANE_EXCELLENCE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_ARCANE_EXCELLENCE] = value
    end
end

function Routine_CheckGraduate(player, hero, mastery)
    print("$ Routine_CheckGraduate")
    local value = 2 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_GRADUATE]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_KNOWLEDGE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_GRADUATE] = value
    end
end

function Routine_CheckOccultism(player, hero, mastery)
    print("$ Routine_CheckOccultism")
    local value = 5 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_OCCULTISM]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_OCCULTISM] = value
    end
end

function Routine_CheckSecretsOfDestruct(player, hero, mastery)
    print("$ Routine_CheckSecretsOfDestruct")
    local value = 4 * mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_SECRETS_OF_DESTRUCT]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_SPELL_POWER, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_SECRETS_OF_DESTRUCT] = value
    end
end

function Routine_CheckGetStronger(player, hero, mastery)
    print("$ Routine_CheckGetStronger")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_GET_STRONGER]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_ATTACK, diff)
        AddHero_StatAmount(player, hero, STAT_DEFENCE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_GET_STRONGER] = value
    end
end

function Routine_CheckGetWiser(player, hero, mastery)
    print("$ Routine_CheckGetWiser")
    local value = 2000
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_GET_WISER]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_EXPERIENCE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_GET_WISER] = value
    end
end

function Routine_CheckLastStand(player, hero, mastery)
    print("$ Routine_CheckLastStand")
    local value = mastery
    local diff = value - HERO_SKILL_BONUSES[hero][SKILLBONUS_LAST_STAND]
    if diff ~= 0 then
        AddHero_StatAmount(player, hero, STAT_MORALE, diff)
        HERO_SKILL_BONUSES[hero][SKILLBONUS_LAST_STAND] = value
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

function Routine_StaminaBuff(player, hero, mastery)
    print("$ Routine_StaminaBuff")
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_HITPOINTS, 10)
end

function Routine_RageAwakening(player, hero, mastery)
    print("$ Routine_RageAwakening")
    GiveHeroSkill(hero, SKILL_BLOOD_RAGE)
end



function Routine_OnslaughtBuff(player, hero, mastery)
    print("$ Routine_OnslaughtBuff")
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_INITIATIVE, 2)
    GiveHeroBattleBonus(hero, HERO_BATTLE_BONUS_SPEED, 1)
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
            local faction = data[0]
            local fort = GetTownBuildingLevel(town, TOWN_BUILDING_FORT)
            local grail = GetTownBuildingLevel(town, TOWN_BUILDING_GRAIL)
            local multiplier = 1 + 0.5 * grail
            if fort > 1 then multiplier = multiplier + 0.5 * (fort-1) end
            if mastery >= 1 and GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_1) ~= 0 then
                local creature = CREATURES_BY_FACTION[faction][1][1]
                local current = GetObjectDwellingCreatures(town, creature)
                SetObjectDwellingCreatures(town, creature, current + 5*multiplier)
            end
            if mastery >= 2 and GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_2) ~= 0 then
                local creature = CREATURES_BY_FACTION[faction][2][1]
                local current = GetObjectDwellingCreatures(town, creature)
                SetObjectDwellingCreatures(town, creature, current + 3*multiplier)
            end
            if mastery >= 3 and GetTownBuildingLevel(town, TOWN_BUILDING_DWELLING_3) ~= 0 then
                local creature = CREATURES_BY_FACTION[faction][3][1]
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
        local amount = trunc(count * (0.05 + 0.05 * mastery))
        if HasHeroSkill(hero, PERK_CHARISMA) then amount = 2 * amount end
        AddObjectCreatures(caravan, creature, amount)
    end
    CURRENT_CARAVANS[caravan] = 3
end

function Routine_TaleTellers(player, hero, mastery, combatIndex)
    print("$ Routine_TaleTellers")
    local exp = 0
    local stacks = GetSavedCombatArmyCreaturesCount(combatIndex, 0)
    for i = 0,stacks-1 do
        local creature, count, died = GetSavedCombatArmyCreatureInfo(combatIndex, 0, i)
        exp = exp + count * power(2, CREATURES[creature][2])
    end
    for _,h in GetPlayerHeroes(player) do
        if h ~= hero then
            AddHero_StatAmount(player, h, STAT_EXPERIENCE, exp)
        end
    end
end



function Routine_MeditationExp(player, hero, amount)
    print("$ Routine_MeditationExp")
    local value = (50 + amount) * GetHeroLevel(hero)
    AddHero_StatAmount(player, hero, STAT_EXPERIENCE, value)
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
    [PERK_FINE_RUNE] = Routine_CheckFineRune,
    [PERK_REFRESH_RUNE] = Routine_CheckRefreshRune,
    [PERK_GREATER_RUNE] = Routine_CheckGreaterRune,
    [PERK_LORD_OF_UNDEAD] = Routine_CheckLordOfTheUndead,
    [PERK_DEFEND_US_ALL] = Routine_CheckDefendUsAll,
    [PERK_SHEER_STRENGTH] = Routine_CheckSheerStrength,
    [PERK_STAMINA] = Routine_StaminaBuff,
    [PERK_RAGE_AWAKENING] = Routine_RageAwakening,
}

DAILY_TRIGGER_SKILLS_ROUTINES = {
    [PERK_ONSLAUGHT] = Routine_OnslaughtBuff,
    [PERK_HERALD_OF_DEATH] = Routine_HeraldOfDeathGolds,
    [SKILL_SPIRITISM] = Routine_SpiritismManaRegen,
}

WEEKLY_TRIGGER_SKILLS_ROUTINES = {
    [SKILL_LOGISTICS] = Routine_LogisticsWeeklyProd,
    [PERK_HAUNTING] = Routine_HauntingWeeklyGhosts,
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
    [PERK_STAMINA] = Routine_StaminaBuff,
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


-- print("Loaded skills-routines-advmap.lua")
ROUTINES_LOADED[11] = 1
