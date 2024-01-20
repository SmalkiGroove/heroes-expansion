

START_TRIGGER_HERO_ROUTINES = {}

DAILY_TRIGGER_HERO_ROUTINES = {}

WEEKLY_TRIGGER_HERO_ROUTINES = {}

LEVEL_UP_HERO_ROUTINES_HERO = {}

AFTER_COMBAT_TRIGGER_HERO_ROUTINES = {}


function DoHeroSpeRoutine_Start(player, hero)
    if START_TRIGGER_HERO_ROUTINES[hero] then
        startThread(START_TRIGGER_HERO_ROUTINES[hero], player, hero)
    end
end

function DoHeroSpeRoutine_Daily(player, hero)
    if DAILY_TRIGGER_HERO_ROUTINES[hero] then
        startThread(DAILY_TRIGGER_HERO_ROUTINES[hero], player, hero)
    end
end

function DoHeroSpeRoutine_Weekly(player, hero)
    if WEEKLY_TRIGGER_HERO_ROUTINES[hero] then
        startThread(WEEKLY_TRIGGER_HERO_ROUTINES[hero], player, hero)
    end
end

function DoHeroSpeRoutine_LevelUp(player, hero, level)
    if LEVEL_UP_HERO_ROUTINES_HERO[hero] then
        startThread(LEVEL_UP_HERO_ROUTINES_HERO[hero], player, hero, level)
    end
end

function DoHeroSpeRoutine_AfterCombat(player, hero, index)
    if AFTER_COMBAT_TRIGGER_HERO_ROUTINES[hero] then
        startThread(AFTER_COMBAT_TRIGGER_HERO_ROUTINES[hero], player, hero, index)
    end
end


-- print("Loaded hero spe advmap routines")
ROUTINES_LOADED[1] = 1
