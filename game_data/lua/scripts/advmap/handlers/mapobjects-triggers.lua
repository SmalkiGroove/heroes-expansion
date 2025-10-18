
Var_WitchHutVisited = {}
Var_TempleVisited = {}

function Override_Monsters(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_Monsters")
    SetObjectEnabled(obj, nil)
end

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

function Override_Tavern(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_Tavern")
    SetObjectEnabled(obj, nil)
end

-----------------------------------------------

function Trigger_Monsters(hero, obj)
    log(DEBUG, "$ Trigger_Monsters")
    local x, y, z = GetObjectPosition(obj)
    ONGOING_BATTLES[hero] = {x=x, y=y, z=z}
    startThread(Trigger_Monsters_Ongoing, hero, obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, nil)
    SetObjectEnabled(obj, not nil)
    MakeHeroInteractWithObject(hero, obj)
    sleep(1)
    if IsObjectExists(obj) then
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_Monsters")
        SetObjectEnabled(obj, nil)
    end
end

function Trigger_Monsters_Ongoing(hero, obj)
    local x, y, z = GetObjectPosition(hero)
    while IsObjectExists(hero) do
        log(DEBUG, "Hero "..hero.." is fighting monsters...")
        sleep(5)
        if not IsObjectExists(obj) then return end
        local xx, yy, zz = GetObjectPosition(hero)
        if x ~= xx or y ~= yy then break end
    end
    ONGOING_BATTLES[hero] = nil
end

function Trigger_WitchHut(hero, obj)
    log(DEBUG, "$ Trigger_WitchHut")
    local player = GetObjectOwner(hero)
    if IsAIPlayer(player) then
        Trigger(OBJECT_TOUCH_TRIGGER, obj, nil)
        SetObjectEnabled(obj, not nil)
        MakeHeroInteractWithObject(hero, obj)
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_WitchHut")
        SetObjectEnabled(obj, nil)
    elseif Var_WitchHutVisited[obj] == 0 then
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
    log(DEBUG, "$ Trigger_WitchHut_confirm")
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
    log(DEBUG, "$ Trigger_Temple")
    local player = GetObjectOwner(hero)
    if IsAIPlayer(player) then
        Trigger(OBJECT_TOUCH_TRIGGER, obj, nil)
        SetObjectEnabled(obj, not nil)
        MakeHeroInteractWithObject(hero, obj)
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_Temple")
        SetObjectEnabled(obj, nil)
    elseif Var_TempleVisited[obj] == 0 then
        local exp = 10 * (WEEKS+10) * (WEEKS+10)
        ShowFlyingSign({"/Text/Game/Scripts/MapObjects/Temple.txt"; amount=exp}, hero, player, FLYING_SIGN_TIME)
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
    log(DEBUG, "$ Trigger_RallyFlag")
    local player = GetObjectOwner(hero)
    if IsAIPlayer(player) then
        Trigger(OBJECT_TOUCH_TRIGGER, obj, nil)
        SetObjectEnabled(obj, not nil)
        MakeHeroInteractWithObject(hero, obj)
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_RallyFlag")
        SetObjectEnabled(obj, nil)
    else
        ShowFlyingSign("/Text/Game/Scripts/MapObjects/RallyFlag.txt", hero, player, FLYING_SIGN_TIME)
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 9999)
    end
end


function Trigger_Tavern(hero, obj)
    log(DEBUG, "$ Trigger_Tavern")
    local player = GetObjectOwner(hero)
    QuestionBoxForPlayers(
        GetPlayerFilter(player),
        "/Text/Game/Scripts/MapObjects/Tavern.txt",
        "Trigger_Tavern_confirm('"..player.."','"..hero.."')",
        "NoneRoutine"
    )
end
function Trigger_Tavern_confirm(player, hero)
    local town = FindClosestTown(player, hero)
    ChangeHeroStat(hero, STAT_MOVE_POINTS, -9999)
    SetObjectPosition(hero, MAP_TOWNS[town].x, MAP_TOWNS[town].y, MAP_TOWNS[town].z, 4)
end


-----------------------------------------------

TRIGGER_OVERRIDES = {
    ["CREATURE"] = Override_Monsters,
    ["BUILDING_WITCH_HUT"] = Override_WitchHut,
    ["BUILDING_TEMPLE"] = Override_Temple,
    ["BUILDING_RALLY_FLAG"] = Override_RallyFlag,
    ["BUILDING_TAVERN"] = Override_Tavern,
}

function InitializeMapObjects()
    for k,v in TRIGGER_OVERRIDES do
        for _,obj in GetObjectNamesByType(k) do
            startThread(v, obj)
        end
    end
end

-- log(DEBUG, "Loaded mapobjects-triggers.lua")
ROUTINES_LOADED[23] = 1
