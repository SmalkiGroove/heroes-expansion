
Var_WitchHutVisited = {}

function Override_WitchHut(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_WitchHut")
    SetObjectEnabled(obj, nil)
    Var_WitchHutVisited[obj] = 0
end

-----------------------------------------------

function Trigger_WitchHut(hero, obj)
    log("$ Trigger_WitchHut")
    local player = GetObjectOwner(hero)
    if Var_WitchHutVisited[obj] == 0 then
        local givestat = random(1,4,TURN)
        QuestionBoxForPlayers(
            GetPlayerFilter(player),
            {"/Text/Game/Scripts/MapObjects/WitchHut.txt"; stat="/GameMechanics/RefTables/HeroAttribute/"..ATTRIBUTE_TEXT_ORIGIN[givestat]..".txt"},
            "Trigger_WitchHut_confirm('"..player.."','"..hero.."','"..obj.."',"..givestat..")",
            "Trigger_WitchHut_cancel('"..player.."','"..hero.."','"..obj.."')"
        )
    else
        Trigger_WitchHut_cancel(player, hero, obj)
    end
end
function Trigger_WitchHut_confirm(player, hero, obj, givestat)
    log("$ Trigger_WitchHut_confirm")
    print("givestat : "..givestat)
    if GetPlayerResource(player, MERCURY) >= 10 then
        MessageBoxForPlayers(
            GetPlayerFilter(player),
            {"/Text/Game/Scripts/MapObjects/WitchHutAccepted.txt"; stat="/GameMechanics/RefTables/HeroAttribute/"..ATTRIBUTE_TEXT_ORIGIN[givestat]..".txt"},
            "NoneRoutine"
        )
        RemovePlayerResource(player, MERCURY, 10)
        ChangeHeroStat(hero, STAT_MOVE_POINTS, -9999)
        ChangeHeroStat(hero, givestat, 2)
        GiveExp(hero, 5000)
        Var_WitchHutVisited[obj] = 1
    else
        Trigger_WitchHut_cancel(player, hero, obj)
    end
end
function Trigger_WitchHut_cancel(player, hero, obj)
    MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Game/Scripts/MapObjects/WitchHutRefused.txt", "NoneRoutine")
    Var_WitchHutVisited[obj] = 1
end

function WitchHuts_reset()
    for obj,_ in Var_WitchHutVisited do
        Var_WitchHutVisited[obj] = 0
    end
end

-----------------------------------------------

TRIGGER_OVERRIDES = {
    ["BUILDING_WITCH_HUT"] = Override_WitchHut,
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
