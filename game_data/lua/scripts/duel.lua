
dofile("/scripts/duel/duel_heroes.lua")
dofile("/scripts/duel/duel_skills.lua")
dofile("/scripts/duel/duel_artifacts.lua")
dofile("/scripts/duel/duel_mapobjects.lua")
dofile("/scripts/duel/duel_armies.lua")

DUEL_STAGE_START = 0
DUEL_STAGE_SETUP = 1
DUEL_STAGE_ADVENTURE = 2
DUEL_STAGE_STAGING = 3
DUEL_STAGE_CASTLE = 4
DUEL_STAGE_BATTLE = 5
DUEL_STAGE_END = 6

function DuelInfoWindow0(player) MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Duel/InfoStart.txt", "NoneRoutine") end
function DuelInfoWindow1(player) MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Duel/InfoSetup.txt", "NoneRoutine") end
function DuelInfoWindow2(player) MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Duel/InfoAdventure.txt", "NoneRoutine") end
function DuelInfoWindow4(player) MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Duel/InfoCastle.txt", "NoneRoutine") end
function DuelInfoWindow5(player) MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Duel/InfoBattle.txt", "NoneRoutine") end

DUEL_HERO = {GetPlayerHeroes(1)[0], GetPlayerHeroes(2)[0]}
MoveHeroRealTime(DUEL_HERO[1], 103, 209, 0)
MoveHeroRealTime(DUEL_HERO[2], 112, 209, 0)

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

DUEL_STAGING_COORDINATES = {
    {x=93, y=35},
    {x=121, y=35},
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
DUEL_DAYS = {5+2*DUEL_MODE, 5+2*DUEL_MODE}


function DuelLevelUp(player, level)
    GiveResources(player, GOLD, 5000, 1)
    if mod(level, 5) == 0 then
        SetTownBuildingLimitLevel(DUEL_TOWN[player], TOWN_BUILDING_MAGIC_GUILD, level/5)
        UpgradeTownBuilding(DUEL_TOWN[player], TOWN_BUILDING_MAGIC_GUILD)
    end
end

function DuelBorderGuardKey(player, key)
    for k = 1,8 do
        if HasBorderguardKey(player, k) then
            MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Duel/BorderGuardKeyOut.txt", "NoneRoutine") return
        end
    end
    GiveBorderguardKey(player, key)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/BorderGuardKey.txt"; key=key}, "NoneRoutine")
end

function DuelStart(player, hero)
    SetObjectPosition(hero, DUEL_START_COORDINATES[player].x, DUEL_START_COORDINATES[player].y)
    SetObjectRotation(hero, 0)
    DuelStage(player, DUEL_STAGE_SETUP)
    -- ExecConsoleCommand("@DuelStage("..player..","..DUEL_STAGE_SETUP..")")
end

function DuelAdventure(player, hero)
    DuelStage(player, DUEL_STAGE_ADVENTURE)
    -- ExecConsoleCommand("@DuelStage("..player..","..DUEL_STAGE_ADVENTURE..")")
end

function DuelAdventureDay(player, hero)
    local days = DUEL_DAYS[player]
    if days > 0 then
        MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/NewDay.txt"; days=days}, "NoneRoutine")
        DUEL_DAYS[player] = days - 1
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 9999)
    else
        DuelStaging(player, hero)
    end
end

function DuelStaging(player, hero)
    SetObjectPosition(hero, DUEL_STAGING_COORDINATES[player].x, DUEL_STAGING_COORDINATES[player].y)
    SetObjectRotation(hero, 0)
    sleep(10)
    for artifact, func in DUEL_ARTIFACT_EFFECTS do
        if HasArtefact(hero, artifact, 1) then func(player, hero) end
    end
    ChangeHeroStat(hero, STAT_MOVE_POINTS, 9999)
    DuelStage(player, DUEL_STAGE_STAGING)
    -- ExecConsoleCommand("@DuelStage("..player..","..DUEL_STAGE_STAGING..")")
end

function DuelCastle(player, hero)
    SetObjectPosition(hero, DUEL_TOWNS_COORDINATES[player][DUEL_FACTION[player]].x, DUEL_TOWNS_COORDINATES[player][DUEL_FACTION[player]].y)
    SetObjectRotation(hero, player == 1 and 270 or 90)
    DuelStage(player, DUEL_STAGE_CASTLE)
    -- ExecConsoleCommand("@DuelStage("..player..","..DUEL_STAGE_CASTLE..")")
end

function DuelBattle(player, hero)
    OpenCircleFog(100, 100, UNDERGROUND, 99, player)
    ChangeHeroStat(hero, STAT_MANA_POINTS, 999)
    DuelStage(player, DUEL_STAGE_BATTLE)
    -- ExecConsoleCommand("@DuelStage("..player..","..DUEL_STAGE_BATTLE..")")
end

function DuelEnd(player, hero)
    DuelStage(player, DUEL_STAGE_END)
    -- ExecConsoleCommand("@DuelStage("..player..","..DUEL_STAGE_END..")")
end

-------------------------------------------------------------------------------------------------------------------------------------------------

function DuelStage(player, stage)
    DUEL_STAGE[player] = stage
end

function DuelLoop(player)
    local hero = DUEL_HERO[player]
    while DUEL_STAGE[player] == DUEL_STAGE_START do 
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 100)
        sleep(5)
    end
    print("DUEL: player "..player.." entered setup stage")
    while DUEL_STAGE[player] == DUEL_STAGE_SETUP do
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 100)
        sleep(5)
    end
    print("DUEL: player "..player.." entered adventure stage")
    while DUEL_STAGE[player] == DUEL_STAGE_ADVENTURE do
        if GetHeroStat(hero, STAT_MOVE_POINTS) < 100 then DuelAdventureDay(player, hero) end
        sleep(5)
    end
    print("DUEL: player "..player.." entered staging stage")
    while DUEL_STAGE[player] == DUEL_STAGE_STAGING do
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 250)
        sleep(5)
    end
    print("DUEL: player "..player.." entered castle stage")
    while DUEL_STAGE[player] == DUEL_STAGE_CASTLE do
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 250)
        sleep(5)
    end
    print("DUEL: player "..player.." entered battle stage")
    while DUEL_STAGE[player] == DUEL_STAGE_BATTLE do
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 999)
        sleep(5)
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------

function DuelMain()
    print("DUEL: bootstrap")

    for player = 1,2 do DuelInfoWindow0(player) end

    for _,town in DUEL_TOWN do SetObjectOwner(town, 0) SetObjectEnabled(town, nil) end

    DUEL_FACTION = {HEROES[DUEL_HERO[1]].faction, HEROES[DUEL_HERO[2]].faction}
    DUEL_TOWN = {DUEL_TOWN_NAME[1][DUEL_FACTION[1]], DUEL_TOWN_NAME[2][DUEL_FACTION[2]]}

    for player = 1,2 do SetObjectOwner(DUEL_TOWN[player], player) end

    DuelOverrideSign()
    DuelOverrideFlag()
    DuelOverrideDolmen()
    DuelOverrideMonolith()
    DuelOverrideStart()

    for i=1,2 do for j=1,8 do
        DuelTownRecruits(DUEL_TOWN_NAME[i][j], DUEL_CREATURE_GROWTH[DUEL_FACTION[i]], DUEL_RECRUITS_WEEKS)
    end end

    print("DUEL: start")
    for p=1,2 do startThread(DuelLoop, p) end
end
