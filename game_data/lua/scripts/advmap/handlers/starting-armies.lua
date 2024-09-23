
MULT = (5 - GetDifficulty()) * 0.25

function SetStartingArmy(hero)
	-- log("$ SetStartingArmy hero="..hero)
    local army = {}
    if STARTING_ARMIES[hero] then
        army = STARTING_ARMIES[hero]
    else
        local faction = FACTION_TEXT[HEROES[hero].faction]
        army = STARTING_ARMIES[faction]
    end
    for i = 1,7 do
        if army[i] then
            local creature = army[i][1]
            local nb = round(MULT * army[i][2])
            AddHeroCreatures(hero, creature, nb, i-1)
        end
    end
    sleep(3)
    while GetHeroCreatures(hero, 180) > 0 do RemoveHeroCreatures(hero, 180, 1) sleep() end
end


STARTING_ARMIES = {
    -- haven
    ["Haven"] = { {CREATURE_PEASANT,90}, {CREATURE_ARCHER,40}, {CREATURE_FOOTMAN,22} },
    [H_MAEVE] = { {CREATURE_PEASANT,75}, {CREATURE_PEASANT,75} },
    [H_DOUGAL] = { {CREATURE_ARCHER,30}, {CREATURE_ARCHER,30}, {CREATURE_FOOTMAN,30} },
    [H_LASZLO] = { {CREATURE_FOOTMAN,20}, {CREATURE_FOOTMAN,20} },
    [H_KLAUS] = { {CREATURE_ARCHER,30}, {CREATURE_FOOTMAN,20}, {CREATURE_CAVALIER,1} },
    [H_ALARIC] = { {CREATURE_PEASANT,100}, {CREATURE_PRIEST,2} },
    [H_GABRIELLE] = { {CREATURE_GRIFFIN,10} }, -- +1 griffin
    -- preserve
    ["Sylvan"] = { {CREATURE_BLADE_JUGGLER,57}, {CREATURE_PIXIE,29}, {CREATURE_WOOD_ELF,18} },
    [H_IVOR] = { {CREATURE_WOLF,20}, {CREATURE_WOLF,20} },
    [H_TALANAR] = { {CREATURE_BLADE_JUGGLER,57}, {CREATURE_WOOD_ELF,18}, {CREATURE_DRUID,4} },
    [H_FINDAN] = { {CREATURE_WOOD_ELF,14}, {CREATURE_WOOD_ELF,14} },
    [H_DIRAEL] = { {CREATURE_BLADE_JUGGLER,45}, {CREATURE_SPRITE,35} },
    [H_TIERU] = { {CREATURE_BLADE_JUGGLER,38}, {CREATURE_PIXIE,22}, {CREATURE_DRUID,8} },
    [H_YLTHIN] = { {CREATURE_PIXIE,22}, {CREATURE_WOOD_ELF,14}, {CREATURE_UNICORN,2} }, -- +1 unicorn
    -- academy
    ["Academy"] = { {CREATURE_GREMLIN,76}, {CREATURE_STONE_GARGOYLE,42}, {CREATURE_IRON_GOLEM,22} },
    [H_HAVEZ] = { {CREATURE_GREMLIN,51}, {CREATURE_GREMLIN,51} },
    [H_RAZZAK] = { {CREATURE_STONE_GARGOYLE,50}, {CREATURE_IRON_GOLEM,30} },
    [H_GALIB] = { {CREATURE_STONE_GARGOYLE,33}, {CREATURE_IRON_GOLEM,20}, {CREATURE_GENIE,2} },
    [H_DAVIUS] = { {CREATURE_GREMLIN,89}, {CREATURE_RAKSHASA,1} },
    [H_CYRUS] = { {CREATURE_GREMLIN,51}, {CREATURE_IRON_GOLEM,20}, {CREATURE_MAGI,7} }, -- +1 mage
    [H_MINASLI] = { {CREATURE_GREMLIN,51}, {CREATURE_STONE_GARGOYLE,33}, {CREATURE_ARCANE_EAGLE,1} },
    -- fortress
    ["Fortress"] = { {CREATURE_DEFENDER,72}, {CREATURE_AXE_FIGHTER,38}, {CREATURE_BROWLER,21} },
    [H_INGVAR] = { {CREATURE_DEFENDER,60}, {CREATURE_DEFENDER,60} },
    [H_KARLI] = { {CREATURE_DEFENDER,48}, {CREATURE_AXE_FIGHTER,48} },
    [H_ROLF] = { {CREATURE_BEAR_RIDER,6}, {CREATURE_BEAR_RIDER,6} }, -- +1 bear rider
    [H_TAZAR] = { {CREATURE_AXE_FIGHTER,28}, {CREATURE_BROWLER,19}, {CREATURE_BEAR_RIDER,4} },
    [H_HANGVUL] = { {CREATURE_BROWLER,29}, {CREATURE_THUNDER_THANE,1} },
    [H_ERLING] = { {CREATURE_DEFENDER,48}, {CREATURE_BROWLER,19}, {CREATURE_RUNE_MAGE,2} }, -- +1 rune priest
    -- necropolis
    ["Necropolis"] = { {CREATURE_SKELETON,85}, {CREATURE_WALKING_DEAD,45}, {CREATURE_MANES,21} },
    [H_ORSON] = { {CREATURE_WALKING_DEAD,19}, {CREATURE_WALKING_DEAD,19}, {CREATURE_WALKING_DEAD,19} },
    [H_LUCRETIA] = { {CREATURE_WALKING_DEAD,39}, {CREATURE_MANES,19}, {CREATURE_VAMPIRE,4} }, -- +1 vampire
    [H_XERXON] = { {CREATURE_SKELETON_WARRIOR,57}, {CREATURE_BLACK_KNIGHT,1} },
    [H_THANT] = { {CREATURE_SKELETON,57}, {CREATURE_WALKING_DEAD,39}, {CREATURE_MUMMY,19} },
    [H_SANDRO] = { {CREATURE_SKELETON,63}, {CREATURE_MANES,23}, {CREATURE_LICH,3} },
    [H_ORNELLA] = { {CREATURE_SKELETON,85}, {CREATURE_VAMPIRE,5} },
    -- inferno
    ["Inferno"] = { {CREATURE_FAMILIAR,99}, {CREATURE_DEMON,44}, {CREATURE_HELL_HOUND,22} },
    [H_GRAWL] = { {CREATURE_HELL_HOUND,13}, {CREATURE_HELL_HOUND,13}, {CREATURE_HELL_HOUND,13} },
    [H_GROK] = { {CREATURE_FAMILIAR,70}, {CREATURE_HELL_HOUND,30}, {CREATURE_NIGHTMARE,2} },
    [H_BIARA] = { {CREATURE_FAMILIAR,66}, {CREATURE_DEMON,36}, {CREATURE_SUCCUBUS,8} }, -- +1 succubus
    [H_ORLANDO] = { {CREATURE_DEMON,55}, {CREATURE_HELL_HOUND,25} },
    [H_KHABELETH] = { {CREATURE_FAMILIAR,111}, {CREATURE_DEMON,55} },
    -- dungeon
    ["Dungeon"] = { {CREATURE_SCOUT,58}, {CREATURE_WITCH,32}, {CREATURE_MINOTAUR,18} },
    [H_VAYSHAN] = { {CREATURE_SCOUT,39}, {CREATURE_SCOUT,39} },
    [H_YRWANNA] = { {CREATURE_WITCH,23}, {CREATURE_WITCH,23} },
    [H_DARKSTORM] = { {CREATURE_MINOTAUR,16}, {CREATURE_MINOTAUR,16} },
    [H_SORGAL] = { {CREATURE_SCOUT,45}, {CREATURE_MINOTAUR,19}, {CREATURE_RIDER,5} },
    [H_ERUINA] = { {CREATURE_SCOUT,45}, {CREATURE_MINOTAUR,19}, {CREATURE_MATRON,2} },
    [H_SHADYA] = { {CREATURE_WITCH,36}, {CREATURE_SHADOW_MISTRESS,2} },
    [H_LETHOS] = { {CREATURE_SCOUT,39}, {CREATURE_WITCH,23}, {CREATURE_MANTICORE,3} },
    -- stronghold
    ["Stronghold"] = { {CREATURE_GOBLIN,82}, {CREATURE_SHAMAN,38}, {CREATURE_ORC_WARRIOR,23} },
    [H_KILGHAN] = { {CREATURE_GOBLIN,80}, {CREATURE_GOBLIN,80} },
    [H_TELSEK] = { {CREATURE_ORC_WARRIOR,20}, {CREATURE_ORC_WARRIOR,20} },
    [H_GARUNA] = { {CREATURE_GOBLIN,69}, {CREATURE_ORC_WARRIOR,21}, {CREATURE_CENTAUR,4} }, -- +1 centaur
    [H_GORSHAK] = { {CREATURE_SHAMAN,38}, {CREATURE_ORC_WARRIOR,23}, {CREATURE_ORCCHIEF_BUTCHER,2} }, -- +1 slayer
    [H_KARUKAT] = { {CREATURE_GOBLIN,69}, {CREATURE_SHAMAN,33}, {CREATURE_WYVERN,1} },
    [H_KUJIN] = { {CREATURE_GOBLIN,55}, {CREATURE_SHAMAN_WITCH,23}, {CREATURE_SHAMAN_WITCH,23} },
}

function IsArmyEmpty(hero)
    for i,cr in GetHeroArmy(hero) do
        if cr and cr ~= 0 then
            if i > 1 or GetHeroCreatures(hero, cr) > 1 then
                return nil
            else
                AddHeroCreatures(hero, 180, 1, 6) sleep(1)
                RemoveHeroCreatures(hero, cr, 1, 0) sleep(1)
            end
        end
    end
    return not nil
end

function InitializeArmy(hero)
    if IsArmyEmpty(hero) then
        SetStartingArmy(hero)
    end
end

function UpdateTavernHeroes()
    for hero,data in HEROES do
        if not IsHeroAlive(hero) then
            if IsArmyEmpty(hero) then
                startThread(SetStartingArmy, hero)
            end
        end
    end
end

function UpdateTavernFactions()
    for town,data in MAP_TOWNS do
        local owner = GetObjectOwner(town)
        if owner > 0 then
            AllowPlayerTavernRace(owner, FactionToTownType(data.faction), 1)
        end
    end
end

-- log("Loaded starting-armies.lua")
ROUTINES_LOADED[21] = 1
