

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


BUILT_TRIGGER_TOWNS_ROUTINES = {
}
LOST_TRIGGER_TOWNS_ROUTINES = {
}
DAILY_TRIGGER_TOWNS_ROUTINES = {
}
WEEKLY_TRIGGER_TOWNS_ROUTINES = {
}


function DoTownsRoutine_Daily(player)
    log("$ DoTownsRoutine_Daily")
    for k,v in DAILY_TRIGGER_TOWNS_ROUTINES do
        
    end
end

function DoTownsRoutine_Weekly(player)
    log("$ DoTownsRoutine_Weekly")
    for k,v in WEEKLY_TRIGGER_TOWNS_ROUTINES do
        
    end
end


-- log("Loaded towns-routines-advmap.lua")
ROUTINES_LOADED[14] = 1
