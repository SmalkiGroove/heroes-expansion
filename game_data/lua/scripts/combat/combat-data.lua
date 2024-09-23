
GRID_X_MIN = 2
GRID_X_MAX = 15
GRID_Y_MIN = 1
GRID_Y_MAX = 11

NO_COST = 0
FREE_MANA = 99

ATB_INSTANT = 1
ATB_NEXT = 0.999
ATB_HALF = 0.5
ATB_ZERO = 0

UNIT_SIDE_PREFIX = {
    [0] = "attacker",
    [1] = "defender"
}

ROUTINE_VARS = {
    InitialCounts = {},
    HeroTurns = 0,
    TurnMarker = 0,
    GriffinDives = {},
    GremlinShot = "none",
    AvatarOfDeath = "none",
    Darkstorm = "none",
    Incendiary = nil,
    AtbBoosted = {},
    GoblinsTotal = 0,
    MoonCharm = nil,
    Legendragon = {},
}

COMBAT_EFFECT_SKILLS = {
    SKILL_GATING,
    SKILL_DARK_MAGIC,
    SKILL_SHATTER_MAGIC,
    PERK_TACTICS,
    PERK_HOUNDMASTERS,
    PERK_PLAGUE_TENT,
    PERK_ELEMENTAL_BALANCE,
}

COMBAT_EFFECT_ARTIFACTS = {
    ARTIFACT_SENTINELS_BLADE,
    ARTIFACT_MOON_CHARM,
    ARTIFACT_ORB_OF_AIR,
    ARTIFACT_ORB_OF_EARTH,
    ARTIFACT_ORB_OF_FIRE,
    ARTIFACT_ORB_OF_WATER,
}


-- log("Loaded combat-data.lua")
ROUTINES_LOADED[8] = 1
