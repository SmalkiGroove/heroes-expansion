

function Routine_MagicGuildsBonus(player, town)
    log.trace("/scripts/advmap/routines/towns-routines-advmap.lua: Routine_MagicGuildsBonus")
    PLAYER_MAGIC_GUILD_LEVEL[player] = PLAYER_MAGIC_GUILD_LEVEL[player] + 1
    for _,hero in GetPlayerHeroes(player) do
        startThread(ComputeHeroMagicGuildBonus, player, hero)
    end
end

function Routine_DragonTombstone(player, town)
    log.trace("/scripts/advmap/routines/towns-routines-advmap.lua: Routine_DragonTombstone")
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

function Routine_WatchTowerReveal(player, town)
    log.trace("/scripts/advmap/routines/towns-routines-advmap.lua: Routine_WatchTowerReveal")
    local x, y, z
    if MAP_TOWNS[town] then
        x = MAP_TOWNS[town].x
        y = MAP_TOWNS[town].y
        z = MAP_TOWNS[town].z
    else
        x, y, z = GetObjectPosition(town)
        MAP_TOWNS[town] = {faction = PRESERVE, x = x, y = y, z = z}
    end
    OpenCircleFog(x, y, z, 50, player)
end

function Routine_WatchTower(player, town)
    log.trace("/scripts/advmap/routines/towns-routines-advmap.lua: Routine_WatchTower")
    log.debug("$ Routine_WatchTower")
    local tx = MAP_TOWNS[town].x
    local ty = MAP_TOWNS[town].y
    local tz = MAP_TOWNS[town].z
    for _,hero in GetPlayerHeroes(player) do
        if HEROES[hero].faction == PRESERVE then
            local bonus = 0
            if IsHeroInTown(hero, town, 1, 1) then
                bonus = 1000
            else
                local hx, hy, hz = GetObjectPosition(hero)
                if hz == tz then
                    local dx = hx - tx
                    local dy = hy - ty
                    local d2 = dx*dx + dy*dy
                    if d2 <= 100 then
                        bonus = 1000
                    elseif d2 < 2500 then
                        for i = 1, 40 do
                            local v = i+10
                            if d2 < (v*v) then bonus = 25*(40-i) break end
                        end
                    end
                end
            end
            if bonus > 0 then startThread(Routine_WatchTowerThread, player, hero, bonus) end
        end
    end
end

function Routine_WatchTowerThread(player, hero, amount)
    log.trace("/scripts/advmap/routines/towns-routines-advmap.lua: Routine_WatchTowerThread")
    log.debug("$ Routine_WatchTowerThread")
    local movement = GetHeroStat(hero, STAT_MOVE_POINTS)
    local current = 0
    local counter = 0
    while counter < amount do
        sleep(2)
        if not IsPlayerCurrent(player) then break end
        current = GetHeroStat(hero, STAT_MOVE_POINTS)
        if (movement - current) > 25 then
            ChangeHeroStat(hero, STAT_MOVE_POINTS, current + 25)
            counter = counter + 25
        end
    end
end

function Routine_WolfKennel(player, town)
    log.trace("/scripts/advmap/routines/towns-routines-advmap.lua: Routine_WolfKennel")
    log.debug("$ Routine_WolfKennel")
    local weekly_growth = {
        [INFERNO] = {66, 36, 22, 11, 5, 3, 1},
        [NECROPOLIS] = {57, 39, 19, 10, 5, 3, 1},
        [STRONGHOLD] = {55, 28, 21, 10, 6, 3, 1},
        [NEUTRAL] = {1, 1, 20, 1, 1, 1, 1},
    }
    local feeders = {15,16,47,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,89,90,116,117,118,119,120,121,122,123,124,125,126,129,130,131,132,133,134,135,136,137,152,153,154,155,156,157,158,173,174,175,176,177,179,191}
    local total_value = 0
    for _, creature in feeders do
        local amount = GetObjectCreatures(town, creature)
        if amount > 0 then
            local faction = CREATURES[creature][1]
            local tier = CREATURES[creature][2]
            if faction == NECROPOLIS and tier == 1 then amount = amount * 2 end
            total_value = total_value + amount / weekly_growth[faction][tier]
        end
    end
    local wolves = 2 + round(7 * total_value)
    if wolves > 0 then AddObjectCreatures(town, CREATURE_WOLF, wolves) end
end


BUILT_TRIGGER_TOWNS_ROUTINES = {
    [106] = Routine_MagicGuildsBonus,
    [206] = Routine_MagicGuildsBonus,
    [306] = Routine_MagicGuildsBonus,
    [406] = Routine_MagicGuildsBonus,
    [506] = Routine_MagicGuildsBonus,
    [606] = Routine_MagicGuildsBonus,
    [706] = Routine_MagicGuildsBonus,
    [806] = Routine_MagicGuildsBonus,
    [222] = Routine_WatchTowerReveal,
}
DAILY_TRIGGER_TOWNS_ROUTINES = {
    [119] = Routine_WolfKennel,
    [222] = Routine_WatchTower,
    [420] = Routine_DragonTombstone,
    [521] = Routine_AlchemyLab,
}
WEEKLY_TRIGGER_TOWNS_ROUTINES = {
}


function DoTownsRoutine_Built(player, town, building)
    log.trace("/scripts/advmap/routines/towns-routines-advmap.lua: DoTownsRoutine_Built")
    local faction = MAP_TOWNS[town].faction
    if not faction then return end
    local routine = BUILT_TRIGGER_TOWNS_ROUTINES[faction * 100 + building]
    if routine then
        startThread(routine, player, town)
    end
end

function DoTownsRoutine_Daily(player)
    log.trace("/scripts/advmap/routines/towns-routines-advmap.lua: DoTownsRoutine_Daily")
    log.debug("$ DoTownsRoutine_Daily")
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
    log.trace("/scripts/advmap/routines/towns-routines-advmap.lua: DoTownsRoutine_Weekly")
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

