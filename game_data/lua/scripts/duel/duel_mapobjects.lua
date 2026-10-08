
----- STAGE TRIGGERS -----

function DuelOverrideStart()
    Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_START", "DuelTriggerStart")
    SetObjectEnabled("DUEL_START", nil)
end
function DuelTriggerStart(hero, obj)
    ExecConsoleCommand("@DuelStart("..GetObjectOwner(hero)..", '"..hero.."')")
end


function DuelOverrideMonolith()
    for _, obj in GetObjectNamesByType("BUILDING_MONOLITH_ONE_WAY_ENTRANCE") do
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerMonolith")
    end
end
function DuelTriggerMonolith(hero, obj)
    ExecConsoleCommand("@DuelNextStage("..GetObjectOwner(hero)..", '"..hero.."')")
end


function DuelOverrideLighthouse()
    for _, obj in GetObjectNamesByType("BUILDING_LIGHTHOUSE") do
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerLighthouse")
        SetObjectEnabled(obj, nil)
    end
end
function DuelTriggerLighthouse(hero, obj)
    ExecConsoleCommand("@DuelNextStage("..GetObjectOwner(hero)..", '"..hero.."')")
end


----- CORE OBJECTS -----

DUEL_DOLMEN_MAX_LEVEL = 20 + DUEL_MODE * 5
DUEL_DOLMEN_LEVELS = {1, 1}

function DuelOverrideDolmen()
    for _, obj in GetObjectNamesByType("BUILDING_LEARNING_STONE") do
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerDolmen")
        SetObjectEnabled(obj, nil)
    end
end
function DuelTriggerDolmen(hero, obj)
    local player = GetObjectOwner(hero)
    if DUEL_DOLMEN_LEVELS[player] < DUEL_DOLMEN_MAX_LEVEL then
        LevelUpHero(hero)
        DUEL_DOLMEN_LEVELS[player] = DUEL_DOLMEN_LEVELS[player] + 1
        ShowFlyingSign({"/Text/Duel/DolmenRemainingUses.txt"; nb=(DUEL_DOLMEN_MAX_LEVEL-DUEL_DOLMEN_LEVELS[player])}, hero, player, FLYING_SIGN_TIME)
    else
        Trigger(OBJECT_TOUCH_TRIGGER, obj, nil)
        MarkObjectAsVisited(obj, hero)
        Popup(player, "/Text/Duel/DolmenMaxLevel.txt")
    end
end


function DuelOverrideSign()
    for p = 1,2 do
        Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_"..p, "DuelTriggerSign0")
        Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_"..p.."_10", "DuelTriggerSign1")
        Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_"..p.."_20", "DuelTriggerSign2")
        Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_"..p.."_30", "DuelTriggerSign3")
        Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_"..p.."_50", "DuelTriggerSign5")
        for j = 1,8 do Trigger(OBJECT_TOUCH_TRIGGER, "DUEL_SIGN_"..p.."_4"..j, "DuelTriggerSign4") end
    end
end
function DuelTriggerSign0(hero, obj) DuelInfoWindow0(GetObjectOwner(hero)) end
function DuelTriggerSign1(hero, obj) DuelInfoWindow1(GetObjectOwner(hero)) end
function DuelTriggerSign2(hero, obj) DuelInfoWindow2(GetObjectOwner(hero)) end
function DuelTriggerSign3(hero, obj) DuelInfoWindow3(GetObjectOwner(hero)) end
function DuelTriggerSign4(hero, obj) DuelInfoWindow4(GetObjectOwner(hero)) end
function DuelTriggerSign5(hero, obj) DuelInfoWindow5(GetObjectOwner(hero)) end


DUEL_KEY_LIMIT = 2
DUEL_KEY_COST = {22500, 22500, 15000, 15000, 22500, 22500, 22500, 35000}
DUEL_KEY_ARTIFACTS = {
    [1] = {ARTIFACT_DRAGON_SCALE_ARMOR,ARTIFACT_DRAGON_SCALE_SHIELD,ARTIFACT_DRAGON_WING_MANTLE,ARTIFACT_DRAGON_BONE_GRAVES},
    [2] = {ARTIFACT_ORB_OF_AIR,ARTIFACT_ORB_OF_EARTH,ARTIFACT_ORB_OF_FIRE,ARTIFACT_ORB_OF_WATER},
    [3] = {ARTIFACT_TITANS_TRIDENT,ARTIFACT_EVERCOLD_ICICLE,ARTIFACT_SOLAR_RING,ARTIFACT_EMERALD_SLIPPERS},
    [4] = {ARTIFACT_MAGNETIC_RING,ARTIFACT_CLOAK_OF_SYLANNA,ARTIFACT_FROZEN_HEART,ARTIFACT_PHOENIX_FEATHER_CAPE},
    [5] = {ARTIFACT_DRAGON_FLAME_TONGUE,ARTIFACT_DRAGON_TALON_CROWN,ARTIFACT_DRAGON_TEETH_NECKLACE,ARTIFACT_DRAGON_EYE_RING},
    [6] = {ARTIFACT_WAR_BANNER,ARTIFACT_WAR_DRUMS,ARTIFACT_WAR_HORN,ARTIFACT_NECKLACE_OF_VICTORY},
    [7] = {ARTIFACT_GENJIS_HAT,ARTIFACT_GENJIS_VEST,ARTIFACT_GENJIS_SANDALS,ARTIFACT_GENJIS_SILKSWORD},
    [8] = {ARTIFACT_TOME_OF_LIGHT,ARTIFACT_TOME_OF_DARKNESS,ARTIFACT_TOME_OF_NATURE,ARTIFACT_TOME_OF_DESTRUCTION},
}

function DuelBorderGuardKey(player, key)
    local possessed_keys = 0
    for k = 1,8 do if HasBorderguardKey(player, k) then possessed_keys = possessed_keys + 1 end end
    if possessed_keys >= DUEL_KEY_LIMIT then
        Popup(player, "/Text/Duel/BorderGuardKeyOut.txt") return
    end
    if Prompt(player, {"/Text/Duel/BorderGuardKeyAsk.txt"; key=key, cost=DUEL_KEY_COST[key]}) then
        local gold = GetPlayerResource(player, GOLD)
        if gold < DUEL_KEY_COST[key] then return end
        SetPlayerResource(player, GOLD, gold - DUEL_KEY_COST[key])
        GiveBorderguardKey(player, key)
        Popup(player, {"/Text/Duel/BorderGuardKey.txt"; key=key})
    end
end

function DuelWishFountain(player, nb)
    for _,artifact in DUEL_KEY_ARTIFACTS[nb] do
        local text_artifact = ARTIFACT_NAME_FILE[artifact]
        if Prompt(player, {"/Text/Duel/FountainWish.txt"; artifact=text_artifact}) then
            local fountain = "P"..player.."_FOUNTAIN_"..nb
            Trigger(OBJECT_TOUCH_TRIGGER, fountain, nil)
            GiveArtifact(player, artifact) return
        end
    end
end

function DuelOverrideWagon()
    for p = 1,2 do for k = 1,8 do
        local wagon = "P"..p.."_BORDER_GUARD_KEY_"..k
        Trigger(OBJECT_TOUCH_TRIGGER, wagon, "DuelTriggerWagon"..k)
        SetObjectEnabled(wagon, nil)
    end end
end
function DuelTriggerWagon1(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 1) end
function DuelTriggerWagon2(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 2) end
function DuelTriggerWagon3(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 3) end
function DuelTriggerWagon4(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 4) end
function DuelTriggerWagon5(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 5) end
function DuelTriggerWagon6(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 6) end
function DuelTriggerWagon7(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 7) end
function DuelTriggerWagon8(hero, obj) DuelBorderGuardKey(GetObjectOwner(hero), 8) end


function DuelOverrideFountain()
    for p = 1,2 do for k = 1,8 do
        local fountain = "P"..p.."_FOUNTAIN_"..k
        Trigger(OBJECT_TOUCH_TRIGGER, fountain, "DuelTriggerFountain"..k)
        SetObjectEnabled(fountain, nil)
    end end
end
function DuelTriggerFountain1(hero, obj) DuelWishFountain(GetObjectOwner(hero), 1) end
function DuelTriggerFountain2(hero, obj) DuelWishFountain(GetObjectOwner(hero), 2) end
function DuelTriggerFountain3(hero, obj) DuelWishFountain(GetObjectOwner(hero), 3) end
function DuelTriggerFountain4(hero, obj) DuelWishFountain(GetObjectOwner(hero), 4) end
function DuelTriggerFountain5(hero, obj) DuelWishFountain(GetObjectOwner(hero), 5) end
function DuelTriggerFountain6(hero, obj) DuelWishFountain(GetObjectOwner(hero), 6) end
function DuelTriggerFountain7(hero, obj) DuelWishFountain(GetObjectOwner(hero), 7) end
function DuelTriggerFountain8(hero, obj) DuelWishFountain(GetObjectOwner(hero), 8) end


----- ADVENTURE OBJECTS -----

function DuelOverrideWitchHut()
    for _, obj in GetObjectNamesByType("BUILDING_WITCH_HUT") do
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerWitchHut")
        SetObjectEnabled(obj, nil)
        Var_WitchHutVisited[obj] = 0
    end
end
function DuelTriggerWitchHut(hero, obj)
    local player = GetObjectOwner(hero)
    if Var_WitchHutVisited[obj] == 0 then
        local givestat = random(1,4)
        local rescost = Var_WitchHutResCost[givestat]
        local text_stat = ATTRIBUTE_NAME_FILE[givestat]
        local text_res = "/Text/Game/Script/Resources/"..RESOURCE_TEXT[rescost]..".txt"
        if Prompt(player, {"/Text/Game/Scripts/MapObjects/WitchHut.txt"; stat=text_stat, res=text_res}) then
            Popup(player, {"/Text/Game/Scripts/MapObjects/WitchHutAccepted.txt"; stat=text_stat})
            TakeAwayResources(player, rescost, 3)
            ChangeHeroStat(hero, givestat, 3)
            Var_WitchHutVisited[obj] = 1
            MarkObjectAsVisited(obj, hero)
        else
            Popup(player, "/Text/Game/Scripts/MapObjects/WitchHutRefused.txt")
        end
    else
        Popup(player, "/Text/Game/Scripts/MapObjects/WitchHutVisited.txt")
        MarkObjectAsVisited(obj, hero)
    end
end


function DuelOverrideWarAcademy()
    for _, obj in GetObjectNamesByType("BUILDING_WAR_ACADEMY") do
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerWarAcademy")
        SetObjectEnabled(obj, nil)
        Var_WarAcademyVisited[obj] = {}
    end
end
function DuelTriggerWarAcademy(hero, obj)
    local player = GetObjectOwner(hero)
    if Var_WarAcademyVisited[obj][hero] ~= 1 then
        local stat = GetHeroLowestStat(hero)
        ChangeHeroStat(hero, stat, 2)
        Var_WarAcademyVisited[obj][hero] = 1
        MarkObjectAsVisited(obj, hero)
        Popup(player, {"/Text/Game/Scripts/MapObjects/WarAcademyAccepted.txt"; stat=ATTRIBUTE_NAME_FILE[stat]})
    else
        Popup(player, "/Text/Game/Scripts/MapObjects/WarAcademyVisited.txt")
        MarkObjectAsVisited(obj, hero)
    end
end


function DuelOverrideSanctuary()
    for _, obj in GetObjectNamesByType("BUILDING_FORTUITOUS_SANCTUARY") do
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerSanctuary")
        SetObjectEnabled(obj, nil)
        Var_FortuitousSanctuaryVisited[obj] = 0
    end
end
function DuelTriggerSanctuary(hero, obj)
    Trigger_FortuitousSanctuary(hero, obj)
end


function DuelOverrideTombOfTheWarrior()
    for _, obj in GetObjectNamesByType("BUILDING_TOMB_OF_THE_WARRIOR") do
        Trigger(OBJECT_TOUCH_TRIGGER, obj, "DuelTriggerTombOfTheWarrior")
        SetObjectEnabled(obj, nil)
        Var_TombOfTheWarriorVisited[obj] = {}
    end
end
function DuelTriggerTombOfTheWarrior(hero, obj)
    local player = GetObjectOwner(hero)
    if Var_TombOfTheWarriorVisited[obj][hero] then
        ShowFlyingSign("/Text/Game/Scripts/MapObjects/TombOfTheWarriorVisited.txt", hero, player, FLYING_SIGN_TIME)
    else
        ChangeHeroStat(hero, STAT_ATTACK, 1)
        ChangeHeroStat(hero, STAT_DEFENCE, 1)
        ChangeHeroStat(hero, STAT_EXPERIENCE, 10000)
        Var_TombOfTheWarriorVisited[obj][hero] = 1
        MarkObjectAsVisited(obj, hero)
    end
end

