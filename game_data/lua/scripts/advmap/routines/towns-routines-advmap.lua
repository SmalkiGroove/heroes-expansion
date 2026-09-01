

function Routine_MagicGuildsBonus(player)
    local bonus = 0
    for _,town in GetPlayerTowns(player) do
        bonus = bonus + GetTownBuildingLevel(town, TOWN_BUILDING_MAGIC_GUILD)
    end
    for _,hero in GetPlayerHeroes(player) do
        if MAGIC_GUILD_HERO_BONUSES[hero] then
            local diff = bonus - MAGIC_GUILD_HERO_BONUSES[hero]
            if diff ~= 0 then
                ChangeHeroStat(hero, STAT_SPELL_POWER, diff)
                ChangeHeroStat(hero, STAT_KNOWLEDGE, diff)
                MAGIC_GUILD_HERO_BONUSES[hero] = bonus
                sleep() ChangeHeroStat(hero, STAT_MANA_POINTS, diff * 10)
            end
        else
            ChangeHeroStat(hero, STAT_SPELL_POWER, bonus)
            ChangeHeroStat(hero, STAT_KNOWLEDGE, bonus)
            MAGIC_GUILD_HERO_BONUSES[hero] = bonus
            sleep() ChangeHeroStat(hero, STAT_MANA_POINTS, bonus * 10)
        end
    end
end

function Routine_DragonTombstone(player, town)
    log.debug("$ Routine_DragonTombstone")
    local prob = 100 + 10 * WEEKS
    prob = prob + GetObjectDwellingCreatures(town, CREATURE_SKELETON)
    prob = min(prob, 500)
    local rand = random(0, 1000, TURN)
    if rand < prob then
        local prob2 = 100 + WEEKS
        prob2 = prob2 + GetObjectDwellingCreatures(town, CREATURE_MANES)
        rand = random(0, 1000, WEEKS)
        if rand < prob2 then
            AddObjectCreatures(town, CREATURE_HORROR_DRAGON, 1)
        else
            AddObjectCreatures(town, CREATURE_BONE_DRAGON, 1)
        end
    end
end

function Routine_AlchemyLab(player, town)
    log.debug("$ Routine_AlchemyLab")
    local hero = GetTownHero(town)
    if not hero then return end
    local artificier = GetHeroSkillMastery(hero, SKILL_ARTIFICIER)
    if artificier == 0 then return end
    local k, units, amounts = GetHeroArmySummary(hero)
    local total_value = 0
    for i = 1, k do
        local creature = units[i]
        local amount = amounts[i]
        if CREATURES[creature] then
            local faction = CREATURES[creature][1]
            local tier = CREATURES[creature][2]
            if faction ~= ACADEMY and faction ~= NEUTRAL then
                local value = amount * power(2, tier-1)
                total_value = total_value + value
                RemoveHeroCreatures(hero, creature, amount)
            end
        end
    end
    if total_value == 0 then return end
    local multiplier = 1 + 0.1 * artificier
    total_value = trunc(total_value * multiplier)
    local awards = {}
    while total_value > 0 do
        local range = min(256, total_value)
        local x = random(1, range, total_value)
        if x < 32 then
            awards[GOLD] = (awards[GOLD] or 0) + x
            total_value = total_value - x
        elseif x < 64 then
            local res = mod(total_value, 2)
            local n = round(0.05 * x)
            awards[res] = (awards[res] or 0) + n
            total_value = total_value - 20*n
        elseif x < 128 then
            local res = random(2,5,x)
            local n = round(0.025 * x)
            awards[res] = (awards[res] or 0) + n
            total_value = total_value - 40*n
        else
            local potion = ARTIFACT_POTION_OF_MANA + mod(total_value, 3)
            awards[potion] = (awards[potion] or 0) + 1
            total_value = total_value - 100
        end
    end
    for award,amount in awards do
        if award <= GOLD then GiveResources(player, award, amount) sleep()
        else for i = 1, amount do GiveArtifact(hero, award) sleep() end
        end
    end
end


BUILT_TRIGGER_TOWNS_ROUTINES = {
}
LOST_TRIGGER_TOWNS_ROUTINES = {
}
DAILY_TRIGGER_TOWNS_ROUTINES = {
    [420] = Routine_DragonTombstone,
    [521] = Routine_AlchemyLab,
}
WEEKLY_TRIGGER_TOWNS_ROUTINES = {
}


function DoTownsRoutine_Daily(player)
    log.debug("$ DoTownsRoutine_Daily")
    startThread(Routine_MagicGuildsBonus, player)
    for faction,type in Towns_Types do
        local f = faction * 100
        for _,town in GetObjectNamesByType(type) do
            if player == GetObjectOwner(town) then
                for b = 14,25 do
                    if DAILY_TRIGGER_TOWNS_ROUTINES[f+b] then
                        if GetTownBuildingLevel(town, b) > 0 then
                            startThread(DAILY_TRIGGER_TOWNS_ROUTINES[f+b], player, town)
                        end
                    end
                end
            end
        end
    end
end

function DoTownsRoutine_Weekly(player)
    log.debug("$ DoTownsRoutine_Weekly")
    for faction,type in Towns_Types do
        local f = faction * 100
        for _,town in GetObjectNamesByType(type) do
            if player == GetObjectOwner(town) then
                for b = 14,25 do
                    if WEEKLY_TRIGGER_TOWNS_ROUTINES[f+b] then
                        if GetTownBuildingLevel(town, b) > 0 then
                            startThread(WEEKLY_TRIGGER_TOWNS_ROUTINES[f+b], player, town)
                        end
                    end
                end
            end
        end
    end
end


log.trace("Loaded towns-routines-advmap.lua")

