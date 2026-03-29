
repeat sleep() until DUEL_MODE ~= nil

DUEL_STAGE_START = 0
DUEL_STAGE_SETUP = 1
DUEL_STAGE_ADVENTURE = 2
DUEL_STAGE_CASTLE = 3
DUEL_STAGE_BATTLE = 4
DUEL_STAGE_END = 5

function DuelInfoWindow0(player) MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Duel/InfoStart.txt", "NoneRoutine") end
function DuelInfoWindow1(player) MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Duel/InfoSetup.txt", "NoneRoutine") end
function DuelInfoWindow2(player) MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Duel/InfoAdventure.txt", "NoneRoutine") end
function DuelInfoWindow3(player) MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Duel/InfoCastle.txt", "NoneRoutine") end
function DuelInfoWindow4(player) MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Duel/InfoBattle.txt", "NoneRoutine") end

DUEL_HERO = {GetPlayerHeroes(1)[0], GetPlayerHeroes(2)[0]}

DUEL_TOWN_NAME = {
    {
        [0] = "TOWN_1",
        [1] = "TOWN_HAVEN_1",
        [2] = "TOWN_PRESERVE_1",
        [3] = "TOWN_INFERNO_1",
        [4] = "TOWN_NECROPOLIS_1",
        [5] = "TOWN_ACADEMY_1",
        [6] = "TOWN_DUNGEON_1",
        [7] = "TOWN_FORTRESS_1",
        [8] = "TOWN_STRONGHOLD_1",
    },
    {
        [0] = "TOWN_2",
        [1] = "TOWN_HAVEN_2",
        [2] = "TOWN_PRESERVE_2",
        [3] = "TOWN_INFERNO_2",
        [4] = "TOWN_NECROPOLIS_2",
        [5] = "TOWN_ACADEMY_2",
        [6] = "TOWN_DUNGEON_2",
        [7] = "TOWN_FORTRESS_2",
        [8] = "TOWN_STRONGHOLD_2",
    },
}
DUEL_FACTION = {0, 0}
DUEL_TOWN = {"TOWN_1", "TOWN_2"}

DUEL_START_COORDINATES = {
    {x=93, y=176},
    {x=121, y=176},
}

DUEL_TOWNS_COORDINATES = {
    {
        [HAVEN]      = {x=27, y=181},
        [PRESERVE]   = {x=27, y=112},
        [FORTRESS]   = {x=27, y=43},
        [ACADEMY]    = {x=27, y=89},
        [DUNGEON]    = {x=27, y=66},
        [NECROPOLIS] = {x=27, y=135},
        [INFERNO]    = {x=27, y=158},
        [STRONGHOLD] = {x=27, y=20},
    },
    {
        [HAVEN]      = {x=188, y=180},
        [PRESERVE]   = {x=188, y=111},
        [FORTRESS]   = {x=188, y=42},
        [ACADEMY]    = {x=188, y=88},
        [DUNGEON]    = {x=188, y=65},
        [NECROPOLIS] = {x=188, y=134},
        [INFERNO]    = {x=188, y=157},
        [STRONGHOLD] = {x=188, y=19},
    },
}

DUEL_STAGE = {0, 0}
DUEL_DAYS = {2+DUEL_MODE, 2+DUEL_MODE}


function DuelLevelUp(player, level)
    GiveResources(player, GOLD, 5000, 1)
    if mod(level, 5) == 0 then
        SetTownBuildingLimitLevel(DUEL_TOWN[player], TOWN_BUILDING_MAGIC_GUILD, level/5)
        UpgradeTownBuilding(DUEL_TOWN[player], TOWN_BUILDING_MAGIC_GUILD)
    end
end
function DuelLevelUp1() DuelLevelUp(1, GetHeroLevel(DUEL_HERO[1])) end
function DuelLevelUp2() DuelLevelUp(2, GetHeroLevel(DUEL_HERO[2])) end


function DuelOverrideSign()
    Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_1", "DuelTriggerSign")
    Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_2", "DuelTriggerSign")
end
function DuelTriggerSign(hero, obj)
    local player = GetObjectOwner(hero)
    if DUEL_STAGE[player] == DUEL_STAGE_START then DuelInfoWindow0(player) end
    elseif DUEL_STAGE[player] == DUEL_STAGE_SETUP then DuelInfoWindow1(player) end
    elseif DUEL_STAGE[player] == DUEL_STAGE_ADVENTURE then DuelInfoWindow2(player) end
    elseif DUEL_STAGE[player] == DUEL_STAGE_CASTLE then DuelInfoWindow3(player) end
    elseif DUEL_STAGE[player] == DUEL_STAGE_BATTLE then DuelInfoWindow4(player) end
    end
end

function DuelOverrideStart()
    Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_START_1", "DuelTriggerStart")
    Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_START_2", "DuelTriggerStart")
    SetObjectEnabled("DUEL_START_1", nil)
    SetObjectEnabled("DUEL_START_2", nil)
end
function DuelTriggerStart(hero, obj) DuelStart(GetObjectOwner(hero)) end

function DuelOverrideSetUp(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerSetUp")
end
function DuelTriggerSetUp(hero, obj) DuelSetUp(GetObjectOwner(hero)) end

function DuelOverrideMonolith(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerMonolith")
end
function DuelTriggerMonolith(hero, obj) DuelBattle(GetObjectOwner(hero)) end


DUEL_DOLMEN_MAX_LEVEL = 20 + DUEL_MODE * 5
DUEL_DOLMEN_LEVELS = {1, 1}

function DuelOverrideDolmen(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerDolmen")
    SetObjectEnabled(obj, nil)
end

function DuelTriggerDolmen(hero, obj)
    local player = GetObjectOwner(hero)
    if DUEL_DOLMEN_LEVELS[player] < DUEL_DOLMEN_MAX_LEVEL then
        LevelUpHero(hero)
        DUEL_DOLMEN_LEVELS[player] = DUEL_DOLMEN_LEVELS[player] + 1
    else
        Trigger(OBJECT_TOUCH_TRIGGER, obj, nil)
        MessageBoxForPlayers(GetPlayerFilter(GetObjectOwner(hero)), "/Text/Duel/DolmenMaxLevel.txt")
    end
end



-------------------------------------------------------------------------------------------------------------------------------------------------

function DuelStart(player)
    SetObjectOwner(DUEL_TOWN[player], player)
    SetObjectPosition(DUEL_HERO[player], DUEL_START_COORDINATES[player].x, DUEL_START_COORDINATES[player].y)
    DUEL_STAGE[player] = DUEL_STAGE_SETUP
end

function DuelSetUp(player)
    local hero = DUEL_HERO[player]
    local player = GetObjectOwner(hero)
    local x,y,z = GetObjectPosition(hero)
    ChangeHeroStat(hero, STAT_MOVE_POINTS, -9999)
    SetObjectPosition(hero, x, y-5, z)
    DUEL_STAGE[player] = DUEL_STAGE_ADVENTURE
end

function DuelNewDay(player)
    local days = DUEL_DAYS[player]
    if days > 0 then
        MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/NewDay.txt"; days=days}, "NoneRoutine")
        DUEL_DAYS[player] = days - 1
        ChangeHeroStat(DUEL_HERO[player], STAT_MOVE_POINTS, 9999)
    else
        DuelCastle(player)
    end
end

function DuelCastle(player)
    SetObjectPosition(DUEL_HERO[player], DUEL_TOWNS_COORDINATES[player][DUEL_FACTION[player]].x, DUEL_TOWNS_COORDINATES[player][DUEL_FACTION[player]].y)
    SetObjectRotation(DUEL_HERO[player], 270)
    DUEL_STAGE[player] = DUEL_STAGE_CASTLE
end

function DuelBattle(player)
    OpenCircleFog(100, 100, UNDERGROUND, 99, player)
    DUEL_STAGE[player] = DUEL_STAGE_BATTLE
end

function DuelEnd(player)
    DUEL_STAGE[player] = DUEL_STAGE_END
end

function DuelLoop(player)
    while DUEL_STAGE[player] == DUEL_STAGE_START do 
        ChangeHeroStat(DUEL_HERO[player], STAT_MOVE_POINTS, 100)
        sleep(5)
    end
    print("DUEL: player "..player.." entered setup stage")
    while DUEL_STAGE[player] == DUEL_STAGE_SETUP do
        ChangeHeroStat(DUEL_HERO[player], STAT_MOVE_POINTS, 100)
        sleep(5)
    end
    print("DUEL: player "..player.." entered adventure stage")
    while DUEL_STAGE[player] == DUEL_STAGE_ADVENTURE do
        if GetHeroStat(DUEL_HERO[player], STAT_MOVE_POINTS) < 100 then DuelNewDay(player) end
        sleep(5)
    end
    print("DUEL: player "..player.." entered castle stage")
    while DUEL_STAGE[player] == DUEL_STAGE_CASTLE do
        ChangeHeroStat(DUEL_HERO[player], STAT_MOVE_POINTS, 100)
        sleep(5)
    end
    print("DUEL: player "..player.." entered battle stage")
    while DUEL_STAGE[player] == DUEL_STAGE_BATTLE do
        ChangeHeroStat(DUEL_HERO[player], STAT_MOVE_POINTS, 999)
        sleep(5)
    end
end



-------------------------------------------------------------------------------------------------------------------------------------------------

function DuelMain()
    print("DUEL: bootstrap")
    for player = 1,2 do DuelInfoWindow(player) end
    for _,town in DUEL_TOWN do
        for build = TOWN_BUILDING_SPECIAL_0, TOWN_BUILDING_SPECIAL_6 do
            startThread(SetTownBuildingLimitLevel, town, build, 0)
        end
    end

    DUEL_FACTION = {HEROES[DUEL_HERO[1]].faction, HEROES[DUEL_HERO[2]].faction}
    DUEL_TOWN = {DUEL_TOWN_NAME[1][DUEL_FACTION[1]], DUEL_TOWN_NAME[2][DUEL_FACTION[2]]}
    
    Trigger(HERO_LEVELUP_TRIGGER, DUEL_HERO[1], "DuelLevelUp1")
    Trigger(HERO_LEVELUP_TRIGGER, DUEL_HERO[2], "DuelLevelUp2")

    DuelOverrideSign()
    DuelOverrideStart()

    for _, obj in GetObjectNamesByType("BUILDING_HUT_OF_MAGI") do DuelOverrideSetUp(obj) end
    for _, obj in GetObjectNamesByType("BUILDING_LEARNING_STONE") do DuelOverrideDolmen(obj) end
    for _, obj in GetObjectNamesByType("BUILDING_MONOLITH_ONE_WAY_ENTRANCE") do DuelOverrideMonolith(obj) end

    print("DUEL: start")
    for p=1,2 do startThread(DuelLoop, p) end
end