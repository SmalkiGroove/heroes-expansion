



COMBAT_PREPART_HERO_ROUTINES = {}

COMBAT_START_HERO_ROUTINES = {}

COMBAT_TURN_HERO_ROUTINES = {}

UNIT_DIED_HERO_ROUTINES = {}


function DoHeroSpeRoutine_CombatPrepare(side, name, id)
    startThread(COMBAT_PREPART_HERO_ROUTINES[name], side, id)
end

function DoHeroSpeRoutine_CombatStart(side, name, id)
    startThread(COMBAT_START_HERO_ROUTINES[name], side, id)
end

function DoHeroSpeRoutine_CombatTurn(side, name, id)
    startThread(COMBAT_TURN_HERO_ROUTINES[name], side, id)
end

function DoHeroSpeRoutine_UnitDied(side, name, id, unit)
    startThread(UNIT_DIED_HERO_ROUTINES[name], side, id, unit)
end


-- print("Loaded hero spe advmap routines")
ROUTINES_LOADED[1] = 1
