

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
    if GetObjectCreatures(town, CREATURE_SKELETON) >= 50 then
        for i,cr in GetObjectCreaturesTypes(town) do
            if not cr or cr == 0 then
                RemoveObjectCreatures(town, CREATURE_SKELETON, 50)
                AddObjectCreatures(town, GetObjectCreatures(town, CREATURE_MANES) >= 5 and CREATURE_HORROR_DRAGON or CREATURE_BONE_DRAGON, 1)
                return
            end
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
