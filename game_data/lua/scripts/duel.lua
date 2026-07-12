
dofile("/scripts/duel/duel_mapobjects.lua")
dofile("/scripts/duel/duel_armies.lua")
dofile("/scripts/duel/duel_heroes.lua")
dofile("/scripts/duel/duel_skills.lua")
dofile("/scripts/duel/duel_artifacts.lua")
sleep()

DUEL_STAGE_START = 0
DUEL_STAGE_SETUP = 1
DUEL_STAGE_ADVENTURE = 2
DUEL_STAGE_STAGING = 3
DUEL_STAGE_CASTLE = 4
DUEL_STAGE_BATTLE = 5
DUEL_STAGE_END = 6

function DuelSetPlayerStage(player, stage)
    local var = "DUEL_STAGE_"..player
    Register(var, stage)
end
function DuelGetPlayerStage(player)
    local var = "DUEL_STAGE_"..player
    return 0 + GetGameVar(var)
end

function DuelInfoWindow0(player)
    MessageBoxPEST(GetPlayerFilter(player),
        "/Text/Duel/InfoStart.txt",
        "NoneRoutine")
end
function DuelInfoWindow1(player)
    MessageBoxPEST(GetPlayerFilter(player),
        "/Text/Duel/InfoSetup.txt",
        "NoneRoutine")
end
function DuelInfoWindow2(player)
    MessageBoxPEST(GetPlayerFilter(player),
        {"/Text/Duel/InfoAdventure.txt"; days=DUEL_PLAYER_DATA.ADVENTURE_DAYS[player]},
        "NoneRoutine")
end
function DuelInfoWindow3(player)
    MessageBoxPEST(GetPlayerFilter(player),
        "/Text/Duel/InfoStaging.txt",
        "NoneRoutine")
end
function DuelInfoWindow4(player)
    MessageBoxPEST(GetPlayerFilter(player),
        "/Text/Duel/InfoCastle.txt",
        "NoneRoutine")
end
function DuelInfoWindow5(player)
    MessageBoxPEST(GetPlayerFilter(player),
        "/Text/Duel/InfoBattle.txt",
        "NoneRoutine")
end

DUEL_HERO = {GetPlayerHeroes(1)[0], GetPlayerHeroes(2)[0]}
MoveHeroRealTime(DUEL_HERO[1], 103, 209, 0)
MoveHeroRealTime(DUEL_HERO[2], 112, 209, 0)

DUEL_FACTION = {HEROES[DUEL_HERO[1]].faction, HEROES[DUEL_HERO[2]].faction}

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
function DuelPlayerTown(player) return DUEL_TOWN_NAME[player][DUEL_FACTION[player]] end

DUEL_TOWN = {DuelPlayerTown(1), DuelPlayerTown(2)}


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

DUEL_ADVENTURE_DAYS = 5 + 2 * DUEL_MODE

DUEL_PLAYER_DATA = {
    ADVENTURE_DAYS = {DUEL_ADVENTURE_DAYS, DUEL_ADVENTURE_DAYS},
    TOTAL_EXP = {0, 0},
}


function DuelStartingBonus(player)
    log.debug("DUEL: StartingBonus for player "..player)
    startThread(function(player)
        for a = 1,199 do if HasArtefact(DUEL_HERO[player], a) then RemoveArtefact(DUEL_HERO[player], a) break end end
    end, player)
    local amount = 5 * DUEL_MODE + 10
    for r = 0,1 do SetPlayerResource(player, r, 2 * amount) end
    for s = 2,5 do SetPlayerResource(player, s, amount) end
    SetPlayerResource(player, FACTION_RESOURCE[DUEL_FACTION[player]], 2 * amount)
    SetPlayerResource(player, GOLD, 10000 * amount)
    GiveHeroRandomArtifact(player, DUEL_HERO[player], ARTIFACT_CLASS_MINOR, DUEL_FACTION[player] + 10)
end

function DuelMagicGuild(player)
    if DUEL_MODE > 0 then
        SetTownBuildingLimitLevel(DUEL_TOWN[player], TOWN_BUILDING_MAGIC_GUILD, 5)
        UpgradeTownBuilding(DUEL_TOWN[player], TOWN_BUILDING_MAGIC_GUILD)
    end
end

function DuelBorderGuardKey(player, key)
    for k = 1,8 do
        if HasBorderguardKey(player, k) then
            MessageBoxPEST(GetPlayerFilter(player),
                "/Text/Duel/BorderGuardKeyOut.txt",
                "NoneRoutine"
            ) return
        end
    end
    QuestionBoxForPlayers(GetPlayerFilter(player),
        {"/Text/Duel/BorderGuardKeyAsk.txt"; key=key},
        "DuelBorderGuardKeyConfirm("..player..","..key..")",
        "NoneRoutine"
    )
end
function DuelBorderGuardKeyConfirm(player, key)
    local gold = GetPlayerResource(player, GOLD)
    if gold < 50000 then return end
    SetPlayerResource(player, GOLD, gold - 50000)
    GiveBorderguardKey(player, key)
    MessageBoxPEST(GetPlayerFilter(player), {"/Text/Duel/BorderGuardKey.txt"; key=key}, "NoneRoutine")
end


function DuelLevelUp(player, hero, level)
    for skill, func in DUEL_SKILL_LEVELUP_EFFECTS do
        if HasHeroSkill(hero, skill) then func(player, hero, level) end
    end
end

function DuelNextStage(player, hero)
    local stage = DuelGetPlayerStage(player)
    if stage == DUEL_STAGE_START then DuelSetup(player, hero)
    elseif stage == DUEL_STAGE_SETUP then DuelAdventure(player, hero)
    elseif stage == DUEL_STAGE_ADVENTURE then DuelStaging(player, hero)
    elseif stage == DUEL_STAGE_STAGING then DuelCastle(player, hero)
    elseif stage == DUEL_STAGE_CASTLE then DuelBattle(player, hero)
    elseif stage == DUEL_STAGE_BATTLE then DuelEnd(player, hero)
    end
end

function DuelSetup(player, hero)
    log.debug("DUEL: player "..player.." entered setup stage")
    SetObjectPosition(hero, DUEL_START_COORDINATES[player].x, DUEL_START_COORDINATES[player].y, 0, 4)
    SetObjectRotation(hero, 0)
    DuelSetPlayerStage(player, DUEL_STAGE_SETUP)
end

function DuelAdventure(player, hero)
    log.debug("DUEL: player "..player.." entered adventure stage")
    for skill, func in DUEL_SKILL_ADVENTURE_EFFECTS do
        if HasHeroSkill(hero, skill) then func(player, hero) end
    end
    ChangeHeroStat(hero, STAT_MOVE_POINTS, 9999)
    DuelSetPlayerStage(player, DUEL_STAGE_ADVENTURE)
    DuelAdventureStart(player, hero)
end

function DuelAdventureStart(player, hero)
    DuelInfoWindow2(player)
end

function DuelAdventureDay(player, hero)
    local days = DUEL_PLAYER_DATA.ADVENTURE_DAYS[player] - 1
    if days > 0 then
        MessageBoxPEST(GetPlayerFilter(player), {"/Text/Duel/NewDay.txt"; days=days}, "NoneRoutine")
        DUEL_PLAYER_DATA.ADVENTURE_DAYS[player] = days
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 9999)
    else
        DuelStaging(player, hero)
    end
end

function DuelStaging(player, hero)
    log.debug("DUEL: player "..player.." entered staging stage")
    SetObjectPosition(hero, DUEL_STAGING_COORDINATES[player].x, DUEL_STAGING_COORDINATES[player].y, 0, 2)
    SetObjectRotation(hero, 0)
    DUEL_PLAYER_DATA.TOTAL_EXP[player] = GetHeroStat(hero, STAT_EXPERIENCE)
    sleep(10)
    for skill, func in DUEL_SKILL_STAGING_EFFECTS do
        if HasHeroSkill(hero, skill) then func(player, hero) end
    end
    for artifact, func in DUEL_ARTIFACT_EFFECTS do
        if HasArtefact(hero, artifact, 1) then func(player, hero) end
    end
    PlayerDailyResources(player)
    ChangeHeroStat(hero, STAT_MOVE_POINTS, 9999)
    DuelSetPlayerStage(player, DUEL_STAGE_STAGING)
end

function DuelCastle(player, hero)
    log.debug("DUEL: player "..player.." entered castle stage")
    SetObjectPosition(hero, DUEL_TOWNS_COORDINATES[player][DUEL_FACTION[player]].x, DUEL_TOWNS_COORDINATES[player][DUEL_FACTION[player]].y, 0, 4)
    SetObjectRotation(hero, player == 1 and 270 or 90)
    DuelSetPlayerStage(player, DUEL_STAGE_CASTLE)
end

function DuelBattle(player, hero)
    log.debug("DUEL: player "..player.." entered battle stage")
    OpenCircleFog(100, 100, UNDERGROUND, 99, player)
    ChangeHeroStat(hero, STAT_MANA_POINTS, 999) sleep()
    for skill, func in DUEL_SKILL_BATTLE_EFFECTS do
        if HasHeroSkill(hero, skill) then func(player, hero) end
    end
    DuelSetPlayerStage(player, DUEL_STAGE_BATTLE)
end

function DuelEnd(player, hero)
    log.debug("DUEL: player "..player.." entered end stage")
    DuelSetPlayerStage(player, DUEL_STAGE_END)
end

-------------------------------------------------------------------------------------------------------------------------------------------------

function DuelLoop(player)
    local hero = DUEL_HERO[player]
    local stage = 0
    while stage == DUEL_STAGE_START do
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 100)
        sleep(5)
        stage = DuelGetPlayerStage(player)
    end
    while stage == DUEL_STAGE_SETUP do
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 100)
        sleep(5)
        stage = DuelGetPlayerStage(player)
    end
    while stage == DUEL_STAGE_ADVENTURE do
        if GetHeroStat(hero, STAT_MOVE_POINTS) < 100 then DuelAdventureDay(player, hero) end
        sleep(5)
        stage = DuelGetPlayerStage(player)
    end
    while stage == DUEL_STAGE_STAGING do
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 250)
        sleep(5)
        stage = DuelGetPlayerStage(player)
    end
    while stage == DUEL_STAGE_CASTLE do
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 250)
        sleep(5)
        stage = DuelGetPlayerStage(player)
    end
    while stage == DUEL_STAGE_BATTLE do
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 999)
        sleep(5)
        stage = DuelGetPlayerStage(player)
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------

function DuelMain()
    log.debug("DUEL: bootstrap")

    for player = 1,2 do
        DuelSetPlayerStage(player, DUEL_STAGE_START)
        DuelInfoWindow0(player)
    end

    for player = 1,2 do
        SetObjectOwner(DUEL_TOWN_NAME[player][0], 0)
        SetObjectEnabled(DUEL_TOWN_NAME[player][0], nil)
        SetObjectOwner(DUEL_TOWN[player], player)
        DuelMagicGuild(player)
    end

    DuelOverrideStart()
    DuelOverrideSign()
    DuelOverrideFlag()
    DuelOverrideDolmen()
    DuelOverrideMonolith()
    DuelOverrideLighthouse()

    for player = 1,2 do DuelTownRecruits(player) end

    log.debug("DUEL: start")
    for player = 1,2 do startThread(DuelLoop, player) end
end
