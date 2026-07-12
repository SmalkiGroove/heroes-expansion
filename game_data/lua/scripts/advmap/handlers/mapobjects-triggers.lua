
Var_WitchHutVisited = {}
Var_TempleVisited = {}
Var_RallyFlagVisited = {}
Var_WarAcademyVisited = {}
Var_TombOfTheWarriorVisited = {}
Var_IdolOfFortuneVisited = {}
Var_FortuitousSanctuaryVisited = {}

function Override_Monsters(obj)
    local x, y, z = GetObjectPosition(obj)
    for _,gate in MAP_GATES do
        local xx, yy, zz = GetObjectPosition(gate)
        if z == zz and abs(x-xx) < 3 and abs(y-yy) < 3 then
            log.debug("$ Gate found for monsters "..obj)
            return
        end
    end
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

function Override_WarAcademy(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_WarAcademy")
    SetObjectEnabled(obj, nil)
    Var_WarAcademyVisited[obj] = {}
end

function Override_TombOfTheWarrior(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_TombOfTheWarrior")
    SetObjectEnabled(obj, nil)
    Var_TombOfTheWarriorVisited[obj] = {}
end

function Override_IdolOfFortune(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_IdolOfFortune")
    SetObjectEnabled(obj, nil)
    Var_IdolOfFortuneVisited[obj] = nil
end

function Override_SeerHut(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_SeerHut")
    SetObjectEnabled(obj, nil)
end

function Override_MotherEarthShrine(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_MotherEarthShrine")
    SetObjectEnabled(obj, nil)
end

function Override_FortuitousSanctuary(obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, "Trigger_FortuitousSanctuary")
    SetObjectEnabled(obj, nil)
    Var_FortuitousSanctuaryVisited[obj] = 0
end

Var_IdolOfFortuneBonus = {
    [HERO_BATTLE_BONUS_LUCK] = 2,
    [HERO_BATTLE_BONUS_MORALE] = 2,
    [HERO_BATTLE_BONUS_ATTACK] = 6,
    [HERO_BATTLE_BONUS_DEFENCE] = 6,
    [HERO_BATTLE_BONUS_HITPOINTS] = 10,
    [HERO_BATTLE_BONUS_INITIATIVE] = 3,
    [HERO_BATTLE_BONUS_SPEED] = 2,
}
-----------------------------------------------

function Trigger_Monsters(hero, obj)
    log.debug("$ Trigger_Monsters")
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
        log.debug("Hero "..hero.." is fighting monsters...")
        sleep(5)
        if not IsObjectExists(obj) then return end
        local xx, yy, zz = GetObjectPosition(hero)
        if x ~= xx or y ~= yy then break end
    end
    ONGOING_BATTLES[hero] = nil
end

Var_WitchHutResCost = {3,2,4,5}
function Trigger_WitchHut(hero, obj)
    log.debug("$ Trigger_WitchHut")
    local player = GetObjectOwner(hero)
    if IsAIPlayer(player) then
        NoOverrideAI(obj, hero, "Trigger_WitchHut")
    elseif Var_WitchHutVisited[obj] == 0 then
        local givestat = random(1,4,TURN)
        local text_stat = ATTRIBUTE_NAME_FILE[givestat]
        local text_res = "/Text/Game/Script/Resources/"..RESOURCE_TEXT[Var_WitchHutResCost[givestat]]..".txt"
        QuestionBoxForPlayers(
            GetPlayerFilter(player),
            {"/Text/Game/Scripts/MapObjects/WitchHut.txt"; stat=text_stat, res=text_res},
            "Trigger_WitchHut_confirm("..player..",'"..hero.."','"..obj.."',"..givestat..")",
            "Trigger_WitchHut_cancel("..player..",'"..hero.."','"..obj.."')"
        )
    else
        Trigger_WitchHut_visited(player, hero, obj)
    end
end
function Trigger_WitchHut_confirm(player, hero, obj, givestat)
    local res = Var_WitchHutResCost[givestat]
    if GetPlayerResource(player, res) >= 3 then
        MessageBoxForPlayers(
            GetPlayerFilter(player),
            {"/Text/Game/Scripts/MapObjects/WitchHutAccepted.txt"; stat=ATTRIBUTE_NAME_FILE[givestat]},
            "NoneRoutine"
        )
        TakeAwayResources(player, res, 3)
        ChangeHeroStat(hero, STAT_MOVE_POINTS, -9999)
        ChangeHeroStat(hero, givestat, 2)
        GiveExp(hero, 5000)
        Var_WitchHutVisited[obj] = 1
        for _,h in GetPlayerHeroes(player) do MarkObjectAsVisited(obj, h) end
    else
        Trigger_WitchHut_cancel(player, hero, obj)
    end
end
function Trigger_WitchHut_cancel(player, hero, obj)
    MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Game/Scripts/MapObjects/WitchHutRefused.txt", "NoneRoutine")
end
function Trigger_WitchHut_visited(player, hero, obj)
    MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Game/Scripts/MapObjects/WitchHutVisited.txt", "NoneRoutine")
    for _,h in GetPlayerHeroes(player) do MarkObjectAsVisited(obj, h) end
end
function WitchHuts_reset()
    for obj,_ in Var_WitchHutVisited do
        Var_WitchHutVisited[obj] = 0
    end
end


function Trigger_Temple(hero, obj)
    log.debug("$ Trigger_Temple")
    local player = GetObjectOwner(hero)
    if IsAIPlayer(player) then
        NoOverrideAI(obj, hero, "Trigger_Temple")
    elseif Var_TempleVisited[obj] == 0 then
        local exp = 10 * (WEEKS+10) * (WEEKS+10)
        ShowFlyingSign({"/Text/Game/Scripts/MapObjects/Temple.txt"; amount=exp}, hero, player, FLYING_SIGN_TIME)
        for _,h in GetPlayerHeroes(player) do
            ChangeHeroStat(h, STAT_EXPERIENCE, exp)
            for _,h in GetPlayerHeroes(player) do MarkObjectAsVisited(obj, h) end
        end
        Var_TempleVisited[obj] = 1
    else
        ShowFlyingSign("/Text/Game/Scripts/MapObjects/TempleVisited.txt", hero, player, FLYING_SIGN_TIME)
        for _,h in GetPlayerHeroes(player) do MarkObjectAsVisited(obj, h) end
    end
end
function Temples_reset()
    for obj,_ in Var_TempleVisited do
        Var_TempleVisited[obj] = 0
    end
end


function Trigger_RallyFlag(hero, obj)
    log.debug("$ Trigger_RallyFlag")
    local player = GetObjectOwner(hero)
    if IsAIPlayer(player) then
        NoOverrideAI(obj, hero, "Trigger_RallyFlag")
    else
        ShowFlyingSign("/Text/Game/Scripts/MapObjects/RallyFlag.txt", hero, player, FLYING_SIGN_TIME)
        ChangeHeroStat(hero, STAT_MOVE_POINTS, 9999)
    end
end


function Trigger_Tavern(hero, obj)
    log.debug("$ Trigger_Tavern")
    local player = GetObjectOwner(hero)
    QuestionBoxForPlayers(
        GetPlayerFilter(player),
        "/Text/Game/Scripts/MapObjects/Tavern.txt",
        "Trigger_Tavern_confirm("..player..",'"..hero.."')",
        "NoneRoutine"
    )
end
function Trigger_Tavern_confirm(player, hero)
    local town = FindClosestTown(player, hero)
    if town then
        ChangeHeroStat(hero, STAT_MOVE_POINTS, -9999)
        local x = MAP_TOWNS[town].x
        local y = MAP_TOWNS[town].y
        local z = MAP_TOWNS[town].z
        SetObjectPosition(hero, x, y, z, 4)
    end
end


function Trigger_WarAcademy(hero, obj)
    log.debug("$ Trigger_WarAcademy")
    local player = GetObjectOwner(hero)
    if IsAIPlayer(player) then
        NoOverrideAI(obj, hero, "Trigger_WarAcademy")
    elseif Var_WarAcademyVisited[obj][hero] == 1 then
        MessageBoxPEST(player, "/Text/Game/Scripts/MapObjects/WarAcademyVisited.txt", "NoneRoutine")
    else
        local stat = GetHeroLowestStat(hero)
        local wm = WAR_MACHINE_AMMO_CART
        if not HasHeroWarMachine(hero, WAR_MACHINE_BALLISTA) then wm = WAR_MACHINE_BALLISTA
        elseif not HasHeroWarMachine(hero, WAR_MACHINE_FIRST_AID_TENT) then wm = WAR_MACHINE_FIRST_AID_TENT
        end
        local text_stat = ATTRIBUTE_NAME_FILE[stat]
        local text_wm = WAR_MACHINE_NAME_FILE[wm]
        QuestionBoxForPlayers(
            GetPlayerFilter(player),
            {"/Text/Game/Scripts/MapObjects/WarAcademy.txt"; stat=text_stat, wm=text_wm},
            "Trigger_WarAcademy_confirm("..player..",'"..hero.."','"..obj.."',"..stat..","..wm..")",
            "NoneRoutine"
        )
    end
end
function Trigger_WarAcademy_confirm(player, hero, obj, stat, wm)
    GiveHeroWarMachine(hero, wm)
    ChangeHeroStat(hero, stat, 1)
    ChangeHeroStat(hero, STAT_MOVE_POINTS, -9999)
    Var_WarAcademyVisited[obj][hero] = 1
    MarkObjectAsVisited(obj, hero)
end
function WarAcademies_reset()
    for obj,_ in Var_WarAcademyVisited do
        Var_WarAcademyVisited[obj] = {}
    end
end


function Trigger_TombOfTheWarrior(hero, obj)
    log.debug("$ Trigger_TombOfTheWarrior")
    local player = GetObjectOwner(hero)
    if IsAIPlayer(player) then
        NoOverrideAI(obj, hero, "Trigger_TombOfTheWarrior")
    elseif Var_TombOfTheWarriorVisited[obj][hero] then
        ShowFlyingSign("/Text/Game/Scripts/MapObjects/TombOfTheWarriorVisited.txt", hero, player, FLYING_SIGN_TIME)
    else
        ChangeHeroStat(hero, STAT_ATTACK, 1)
        ChangeHeroStat(hero, STAT_DEFENCE, 1)
        ChangeHeroStat(hero, STAT_EXPERIENCE, 3000)
        Var_TombOfTheWarriorVisited[obj][hero] = 1
        MarkObjectAsVisited(obj, hero)
    end
end


function Trigger_IdolOfFortune(hero, obj)
    log.debug("$ Trigger_IdolOfFortune")
    local player = GetObjectOwner(hero)
    if IsAIPlayer(player) then
        NoOverrideAI(obj, hero, "Trigger_IdolOfFortune")
    else
        Var_IdolOfFortuneVisited[obj] = hero
        MarkObjectAsVisited(obj, hero)
        local bonus = random(0,6,TURN)
        GiveHeroBattleBonus(hero, bonus, Var_IdolOfFortuneBonus[bonus])
        MessageBoxPEST(player, "/Text/Game/Scripts/MapObjects/IdolOfFortune.txt", "NoneRoutine")
    end
end
function IdolOfFortune_daily()
    for obj, hero in Var_IdolOfFortuneVisited do
        if hero ~= nil then
            if IsObjectExists(hero) then
                if LAST_BATTLES[hero] == TURN - 1 then
                    local bonus = random(0,6,TURN)
                    GiveHeroBattleBonus(hero, bonus, Var_IdolOfFortuneBonus[bonus])
                end
            else
                Var_IdolOfFortuneVisited[obj] = nil
            end
        end
    end
end


function Trigger_SeerHut(hero, obj)
    log.debug("$ Trigger_SeerHut")
    local player = GetObjectOwner(hero)
    if IsAIPlayer(player) then
        NoOverrideAI(obj, hero, "Trigger_SeerHut")
    else
        QuestionBoxForPlayers(
            GetPlayerFilter(player),
            "/Text/Game/Scripts/MapObjects/SeerHut.txt",
            "Trigger_SeerHut_confirm("..player..")",
            "NoneRoutine"
        )
    end
end
function Trigger_SeerHut_confirm(player)
    TakeAwayResources(player, GOLD, 5000)
    for p = 1,8 do
        if p ~= player and GetPlayerState(p) == 1 then
            if GetPlayerTeam(p) ~= GetPlayerTeam(player) then
                for _,h in GetPlayerHeroes(p) do
                    local x, y, z = GetObjectPosition(h)
                    OpenCircleFog(x, y, z, 2, player)
                end
            end
        end
    end
end


function Trigger_MotherEarthShrine(hero, obj)
    log.debug("$ Trigger_MotherEarthShrine")
    local player = GetObjectOwner(hero)
    if IsAIPlayer(player) then
        NoOverrideAI(obj, hero, "Trigger_MotherEarthShrine")
    else
        QuestionBoxForPlayers(
            GetPlayerFilter(player),
            "/Text/Game/Scripts/MapObjects/MotherEarthShrine.txt",
            "Trigger_MotherEarthShrine_confirm("..player..",'"..hero.."')",
            "NoneRoutine"
        )
    end
end
function Trigger_MotherEarthShrine_confirm(player, hero)
    local faction = HEROES[hero].faction
    local towns = GetHeroTowns(player, hero)
    local total = 0
    local k, units, amounts = GetHeroArmySummary(hero)
    for i = 1, k do
        local creature = units[i]
        local f = CREATURES[creature][1]
        if f ~= faction and f ~= NEUTRAL then
            local count = amounts[i]
            local tier = CREATURES[creature][2]
            local recruit = CREATURES_BY_FACTION[faction][tier][1]
            for _, town in towns do
                if GetTownBuildingLevel(town, 6+tier) > 0 then
                    local cur = GetObjectDwellingCreatures(town, recruit)
                    SetObjectDwellingCreatures(town, recruit, count + cur)
                    RemoveHeroCreatures(hero, creature, count)
                    total = total + count
                    break
                end
            end
        end
    end
    MessageBoxPEST(player, {"/Text/Game/Scripts/MapObjects/MotherEarthShrineDone.txt"; amount=total}, "NoneRoutine")
end


function Trigger_FortuitousSanctuary(hero, obj)
    log.debug("$ Trigger_FortuitousSanctuary")
    local player = GetObjectOwner(hero)
    if IsAIPlayer(player) then
        NoOverrideAI(obj, hero, "Trigger_FortuitousSanctuary")
    elseif Var_FortuitousSanctuaryVisited[obj] == 1 then
        MessageBoxPEST(player, "/Text/Game/Scripts/MapObjects/ArcaneSanctuaryVisited.txt", "NoneRoutine")
    else
        local required_skill = {11, 11, 11, 10, 10, 10, 12, 12, 12, 9, 9, 9}
        local unknown_spells = {}
        local n, c = 0, 0
        for circle = 1, 5 do
            for i, spell in SPELLS_BY_TIER[circle] do
                if circle < 3 or GetHeroSkillMastery(hero, required_skill[i]) > (circle-3) then
                    if not KnowHeroSpell(hero, spell) then insert(unknown_spells, spell); n = n + 1 end
                end
            end
            if n > 0 then c = circle break end
        end
        if n == 0 then
            MessageBoxPEST(player, "/Text/Game/Scripts/MapObjects/ArcaneSanctuaryCancel.txt", "NoneRoutine") return
        elseif n == 1 then
            TeachHeroSpell(hero, unknown_spells[1])
        else
            local s = unknown_spells[random(1, n, TURN-1)]
            TeachHeroSpell(hero, s)
        end
        local txt_arg = "/Text/Game/Scripts/_n/"..c..".txt"
        MessageBoxPEST(player, {"/Text/Game/Scripts/MapObjects/ArcaneSanctuaryAccept.txt"; arg=txt_arg}, "NoneRoutine")
        Var_FortuitousSanctuaryVisited[obj] = 1
        MarkObjectAsVisited(obj, hero)
    end
end


-----------------------------------------------

function RegisterMapGates()
    for _,type in FASTTRAVEL_GATE_OBJECTS do
        for _,obj in GetObjectNamesByType(type) do insert(MAP_GATES, obj) end
    end
end

TRIGGER_OVERRIDES = {
    ["CREATURE"] = Override_Monsters,
    ["BUILDING_WITCH_HUT"] = Override_WitchHut,
    ["BUILDING_TEMPLE"] = Override_Temple,
    ["BUILDING_RALLY_FLAG"] = Override_RallyFlag,
    ["BUILDING_TAVERN"] = Override_Tavern,
    ["BUILDING_WAR_ACADEMY"] = Override_WarAcademy,
    ["BUILDING_TOMB_OF_THE_WARRIOR"] = Override_TombOfTheWarrior,
    ["BUILDING_IDOL_OF_FORTUNE"] = Override_IdolOfFortune,
    ["BUILDING_SEER_HUT"] = Override_SeerHut,
    ["BUILDING_NOMADS_SHAMAN"] = Override_MotherEarthShrine,
    ["BUILDING_FORTUITOUS_SANCTUARY"] = Override_FortuitousSanctuary,
}

function InitializeMapObjects()
    if IsDuelMode() then return end
    RegisterMapGates()
    for k,v in TRIGGER_OVERRIDES do
        for _,obj in GetObjectNamesByType(k) do
            startThread(v, obj)
        end
    end
end

function DailyMapObjects()
    IdolOfFortune_daily()
end

function WeeklyMapObjects()
    WitchHuts_reset()
    Temples_reset()
    WarAcademies_reset()
end

function NoOverrideAI(obj, hero, callback)
    MarkObjectAsVisited(obj, hero)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, nil)
    SetObjectEnabled(obj, not nil)
    MakeHeroInteractWithObject(hero, obj)
    Trigger(OBJECT_TOUCH_TRIGGER, obj, callback)
    SetObjectEnabled(obj, nil)
end

log.trace("Loaded mapobjects-triggers.lua")

