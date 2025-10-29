
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

STARTING_ARMY = {
    [0] = {},
    [1] = {},
}

ROUTINE_VARS = {
    HeroTurns = 0,
    TurnMarker = 0,
    GriffinDives = {},
    TimeShifter = not nil,
    GremlinShot = "none",
    AvatarOfDeath = "none",
    Darkstorm = "none",
    Incendiary = 3,
    AtbBoosted = {},
    GoblinsTotal = 0,
    MoonCharm = nil,
    Legendragon = {},
    BallistaCommanders = {},
}

SUMMON_ID = 0

RANGED_CREATURES = {
    3, 4, 107, 9, 10, 110,
    21, 22, 134,
    30, 37, 38, 156,
    47, 48, 147, 49, 50, 148, 190,
    57, 58, 159, 63, 64, 162, 165,
    71, 72, 81, 82,
    94, 95, 167, 100, 101, 170,
    118, 119, 120, 174,
    85, 181, 187, 188,
}

COMBAT_EFFECT_SKILLS = {
    SKILL_GATING,
    SKILL_DARK_MAGIC,
    SKILL_SHATTER_MAGIC,
    PERK_TACTICS,
    PERK_HOUNDMASTERS,
    PERK_PLAGUE_TENT,
    PERK_ELEMENTAL_BALANCE,
    PERK_IMBUE_BALLISTA,
}

COMBAT_EFFECT_ARTIFACTS = {
    ARTIFACT_SENTINELS_BLADE,
    ARTIFACT_MOON_CHARM,
    ARTIFACT_ORB_OF_AIR,
    ARTIFACT_ORB_OF_EARTH,
    ARTIFACT_ORB_OF_FIRE,
    ARTIFACT_ORB_OF_WATER,
}


-- log(TRACE, "Loaded combat-data.lua")
ROUTINES_LOADED[8] = 1
