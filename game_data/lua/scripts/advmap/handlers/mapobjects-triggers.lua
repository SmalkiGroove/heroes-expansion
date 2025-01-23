
Var_WitchHutVisited = {}
Var_TempleVisited = {}

function Override_WitchHut(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_WitchHut")
    SetObjectEnabled(obj, nil)
    Var_WitchHutVisited[obj] = 0
end

function Override_Temple(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_Temple")
    SetObjectEnabled(obj, nil)
    Var_TempleVisited[obj] = 0
end

function Override_RallyFlag(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_RallyFlag")
    SetObjectEnabled(obj, nil)
end

-----------------------------------------------

function Trigger_WitchHut(hero, obj)
    log("$ Trigger_WitchHut")
    local player = GetObjectOwner(hero)
    if PLAYER_BRAIN[player] == COMPUTER then
        Trigger(OBJECT_TOUCH_TRIGGER, obj, nil)
        SetObjectEnabled(obj, not nil)
        MakeHeroInteractWithObject(hero, obj)
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_WitchHut")
        SetObjectEnabled(obj, nil)
    end
    if Var_WitchHutVisited[obj] == 0 then
        local givestat = random(1,4,TURN)
        QuestionBoxForPlayers(
            GetPlayerFilter(player),
            {"/Text/Game/Scripts/MapObjects/WitchHut.txt"; stat="/GameMechanics/RefTables/HeroAttribute/"..ATTRIBUTE_TEXT_ORIGIN[givestat]..".txt"},
            "Trigger_WitchHut_confirm('"..player.."','"..hero.."','"..obj.."',"..givestat..")",
            "Trigger_WitchHut_cancel('"..player.."','"..hero.."','"..obj.."')"
        )
    else
        Trigger_WitchHut_visited(player, hero, obj)
    end
end
function Trigger_WitchHut_confirm(player, hero, obj, givestat)
    log("$ Trigger_WitchHut_confirm")
    if GetPlayerResource(player, MERCURY) >= 7 then
        MessageBoxForPlayers(
            GetPlayerFilter(0+player),
            {"/Text/Game/Scripts/MapObjects/WitchHutAccepted.txt"; stat="/GameMechanics/RefTables/HeroAttribute/"..ATTRIBUTE_TEXT_ORIGIN[givestat]..".txt"},
            "NoneRoutine"
        )
        RemovePlayerResource(player, MERCURY, 7)
        ChangeHeroStat(hero, STAT_MOVE_POINTS, -9999)
        ChangeHeroStat(hero, givestat, 2)
        GiveExp(hero, 5000)
        Var_WitchHutVisited[obj] = 1
        MarkObjectAsVisited(obj, hero)
    else
        Trigger_WitchHut_cancel(player, hero, obj)
    end
end
function Trigger_WitchHut_cancel(player, hero, obj)
    MessageBoxForPlayers(GetPlayerFilter(0+player), "/Text/Game/Scripts/MapObjects/WitchHutRefused.txt", "NoneRoutine")
end
function Trigger_WitchHut_visited(player, hero, obj)
    MessageBoxForPlayers(GetPlayerFilter(0+player), "/Text/Game/Scripts/MapObjects/WitchHutVisited.txt", "NoneRoutine")
    MarkObjectAsVisited(obj, hero)
end
function WitchHuts_reset()
    for obj,_ in Var_WitchHutVisited do
        Var_WitchHutVisited[obj] = 0
    end
end


function Trigger_Temple(hero, obj)
    log("$ Trigger_Temple")
    local player = GetObjectOwner(hero)
    if PLAYER_BRAIN[player] == COMPUTER then
        Trigger(OBJECT_TOUCH_TRIGGER, obj, nil)
        SetObjectEnabled(obj, not nil)
        MakeHeroInteractWithObject(hero, obj)
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_Temple")
        SetObjectEnabled(obj, nil)
    end
    if Var_TempleVisited[obj] == 0 then
        local exp = 10 * (WEEKS+10) * (WEEKS+10)
        for _,h in GetPlayerHeroes(player) do
            ChangeHeroStat(h, STAT_EXPERIENCE, exp)
            MarkObjectAsVisited(obj, h)
        end
        Var_TempleVisited[obj] = 1
    else
        ShowFlyingSign("/Text/Game/Scripts/MapObjects/TempleVisited.txt", hero, player, FLYING_SIGN_TIME)
        MarkObjectAsVisited(obj, hero)
    end
end
function Temples_reset()
    for obj,_ in Var_TempleVisited do
        Var_TempleVisited[obj] = 0
    end
end


function Trigger_RallyFlag(hero, obj)
    log("$ Trigger_RallyFlag")
    local player = GetObjectOwner(hero)
    if PLAYER_BRAIN[player] == COMPUTER then
        Trigger(OBJECT_TOUCH_TRIGGER, obj, nil)
        SetObjectEnabled(obj, not nil)
        MakeHeroInteractWithObject(hero, obj)
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_RallyFlag")
        SetObjectEnabled(obj, nil)
    end
    ChangeHeroStat(hero, STAT_MOVE_POINTS, 9999)
    MarkObjectAsVisited(obj, hero)
end


-----------------------------------------------

TRIGGER_OVERRIDES = {
    ["BUILDING_WITCH_HUT"] = Override_WitchHut,
    ["BUILDING_TEMPLE"] = Override_Temple,
    ["BUILDING_RALLY_FLAG"] = Override_RallyFlag,
}

function InitializeMapObjects()
    for k,v in TRIGGER_OVERRIDES do
        for _,obj in GetObjectNamesByType(k) do
            startThread(v, obj)
        end
    end
end

-- log("Loaded mapobjects-triggers.lua")
ROUTINES_LOADED[23] = 1
