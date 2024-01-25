
GRID_X_MIN = 2
GRID_X_MAX = 15
GRID_Y_MIN = 1
GRID_Y_MAX = 12

NO_COST = 0
FREE_MANA = 99

ATB_INSTANT = 1
ATB_NEXT = 0.99
ATB_HALF = 0.5
ATB_ZERO = 0

UNIT_SIDE_PREFIX = {
    [0] = "attacker",
    [1] = "defender"
}

ROUTINE_VARS = {
    ["avatar-id"] = "none",
    ["calid-atb"] = nil,
}

-- print("Loaded combat-data.lua")
ROUTINES_LOADED[8] = 1
