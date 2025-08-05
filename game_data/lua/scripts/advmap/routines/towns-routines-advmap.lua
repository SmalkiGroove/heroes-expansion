

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
            end
        else
            ChangeHeroStat(hero, STAT_SPELL_POWER, bonus)
            ChangeHeroStat(hero, STAT_KNOWLEDGE, bonus)
            MAGIC_GUILD_HERO_BONUSES[hero] = bonus
        end
    end
end

function Routine_DragonTombstone(player, town)
    log("$ Routine_DragonTombstone")
    local prob = 200 + 10 * WEEKS
    prob = prob + GetObjectDwellingCreatures(town, CREATURE_SKELETON)
    local rand = random(0, 999, TURN)
    if rand < prob then
        local prob2 = 100 + WEEKS
        prob2 = prob2 + GetObjectDwellingCreatures(town, CREATURE_MANES)
        rand = random(0, 999, WEEKS)
        if rand < prob2 then
            AddObjectCreatures(town, CREATURE_HORROR_DRAGON, 1)
        else
            AddObjectCreatures(town, CREATURE_BONE_DRAGON, 1)
        end
    end
end


BUILT_TRIGGER_TOWNS_ROUTINES = {
}
LOST_TRIGGER_TOWNS_ROUTINES = {
}
DAILY_TRIGGER_TOWNS_ROUTINES = {
    [420] = Routine_DragonTombstone,
}
WEEKLY_TRIGGER_TOWNS_ROUTINES = {
}


function DoTownsRoutine_Daily(player)
    log("$ DoTownsRoutine_Daily")
    startThread(Routine_MagicGuildsBonus, player)
    for faction,type in Towns_Types do
        local f = faction * 100
        for _,town in GetObjectNamesByType(type) do
            if player == GetObjectOwner(town) then
                for b = 14,25 do
                    if DAILY_TRIGGER_TOWNS_ROUTINES[f+b] then
                        startThread(DAILY_TRIGGER_TOWNS_ROUTINES[f+b], player, town)
                    end
                end
            end
        end
    end
end

function DoTownsRoutine_Weekly(player)
    log("$ DoTownsRoutine_Weekly")
    for faction,type in Towns_Types do
        local f = faction * 100
        for _,town in GetObjectNamesByType(type) do
            if player == GetObjectOwner(town) then
                for b = 14,25 do
                    if WEEKLY_TRIGGER_TOWNS_ROUTINES[f+b] then
                        startThread(WEEKLY_TRIGGER_TOWNS_ROUTINES[f+b], player, town)
                    end
                end
            end
        end
    end
end


-- log("Loaded towns-routines-advmap.lua")
ROUTINES_LOADED[14] = 1
