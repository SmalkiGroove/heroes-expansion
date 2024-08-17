
MULT = (GetDifficulty() == 0) and 1.5 or 1

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
    if GetHeroCreatures(hero, 180) ~= 0 then sleep(2) RemoveHeroCreatures(hero, 180, 1) end
end


STARTING_ARMIES = {
    -- haven
    ["Haven"] = { {CREATURE_PEASANT,45}, {CREATURE_ARCHER,15}, {CREATURE_FOOTMAN,7} },
    [H_MAEVE] = { {CREATURE_PEASANT,40}, {CREATURE_PEASANT,40} },
    [H_DOUGAL] = { {CREATURE_ARCHER,12}, {CREATURE_ARCHER,12}, {CREATURE_FOOTMAN,9} },
    [H_LASZLO] = { {CREATURE_FOOTMAN,11}, {CREATURE_FOOTMAN,11} },
    [H_KLAUS] = { {CREATURE_ARCHER,12}, {CREATURE_FOOTMAN,6}, {CREATURE_CAVALIER,1} },
    [H_ALARIC] = { {CREATURE_PEASANT,55}, {CREATURE_PRIEST,1} },
    [H_GABRIELLE] = { {CREATURE_GRIFFIN,6} }, -- +1 griffin
    -- preserve
    ["Sylvan"] = { {CREATURE_BLADE_JUGGLER,35}, {CREATURE_PIXIE,12}, {CREATURE_WOOD_ELF,5} },
    [H_IVOR] = { {CREATURE_WOLF,10}, {CREATURE_WOLF,10} },
    [H_TALANAR] = { {CREATURE_BLADE_JUGGLER,38}, {CREATURE_WOOD_ELF,6}, {CREATURE_DRUID,1} },
    [H_FINDAN] = { {CREATURE_WOOD_ELF,7}, {CREATURE_WOOD_ELF,7} },
    [H_DIRAEL] = { {CREATURE_BLADE_JUGGLER,31}, {CREATURE_SPRITE,17} },
    [H_TIERU] = { {CREATURE_BLADE_JUGGLER,33}, {CREATURE_PIXIE,11}, {CREATURE_DRUID,2} },
    [H_YLTHIN] = { {CREATURE_PIXIE,12}, {CREATURE_WOOD_ELF,5}, {CREATURE_UNICORN,1} }, -- +1 unicorn
    -- academy
    ["Academy"] = { {CREATURE_GREMLIN,40}, {CREATURE_STONE_GARGOYLE,15}, {CREATURE_IRON_GOLEM,7} },
    [H_HAVEZ] = { {CREATURE_GREMLIN,34}, {CREATURE_GREMLIN,34} },
    [H_RAZZAK] = { {CREATURE_STONE_GARGOYLE,20}, {CREATURE_IRON_GOLEM,10} },
    [H_GALIB] = { {CREATURE_STONE_GARGOYLE,18}, {CREATURE_IRON_GOLEM,6}, {CREATURE_GENIE,1} },
    [H_DAVIUS] = { {CREATURE_GREMLIN,36}, {CREATURE_RAKSHASA,1} },
    [H_CYRUS] = { {CREATURE_GREMLIN,34}, {CREATURE_IRON_GOLEM,8}, {CREATURE_MAGI,2} }, -- +1 mage
    [H_MINASLI] = { {CREATURE_GREMLIN,38}, {CREATURE_STONE_GARGOYLE,13}, {CREATURE_SNOW_APE,1} },
    -- fortress
    ["Fortress"] = { {CREATURE_DEFENDER,40}, {CREATURE_AXE_FIGHTER,15}, {CREATURE_BROWLER,7} },
    [H_INGVAR] = { {CREATURE_DEFENDER,35}, {CREATURE_DEFENDER,35} },
    [H_KARLI] = { {CREATURE_DEFENDER,30}, {CREATURE_AXE_FIGHTER,12}, {CREATURE_AXE_FIGHTER,12} },
    [H_ROLF] = { {CREATURE_BEAR_RIDER,3}, {CREATURE_BEAR_RIDER,3} }, -- +1 bear rider
    [H_TAZAR] = { {CREATURE_AXE_FIGHTER,17}, {CREATURE_BROWLER,8}, {CREATURE_BEAR_RIDER,1} },
    [H_HANGVUL] = { {CREATURE_BROWLER,10}, {CREATURE_WARLORD,1} },
    [H_ERLING] = { {CREATURE_DEFENDER,34}, {CREATURE_BROWLER,8}, {CREATURE_RUNE_MAGE,1} }, -- +1 rune priest
    -- necropolis
    ["Necropolis"] = { {CREATURE_SKELETON,45}, {CREATURE_WALKING_DEAD,15}, {CREATURE_MANES,7} },
    [H_ORSON] = { {CREATURE_WALKING_DEAD,9}, {CREATURE_WALKING_DEAD,9}, {CREATURE_WALKING_DEAD,9} },
    [H_LUCRETIA] = { {CREATURE_WALKING_DEAD,16}, {CREATURE_MANES,8}, {CREATURE_VAMPIRE,2} }, -- +1 vampire
    [H_XERXON] = { {CREATURE_SKELETON_WARRIOR,33}, {CREATURE_BLACK_KNIGHT,1} },
    [H_THANT] = { {CREATURE_SKELETON,39}, {CREATURE_WALKING_DEAD,13}, {CREATURE_MUMMY,5} },
    [H_SANDRO] = { {CREATURE_SKELETON,41}, {CREATURE_MANES,7}, {CREATURE_LICH,1} },
    [H_ORNELLA] = { {CREATURE_SKELETON,59}, {CREATURE_VAMPIRE,1} },
    -- inferno
    ["Inferno"] = { {CREATURE_FAMILIAR,45}, {CREATURE_DEMON,15}, {CREATURE_HELL_HOUND,7} },
    [H_GRAWL] = { {CREATURE_HELL_HOUND,6}, {CREATURE_HELL_HOUND,6}, {CREATURE_HELL_HOUND,6} },
    [H_GROK] = { {CREATURE_FAMILIAR,44}, {CREATURE_HELL_HOUND,6}, {CREATURE_NIGHTMARE,1} },
    [H_BIARA] = { {CREATURE_FAMILIAR,38}, {CREATURE_DEMON,18}, {CREATURE_SUCCUBUS,2} }, -- +1 succubus
    [H_ORLANDO] = { {CREATURE_DEMON,23}, {CREATURE_HELL_HOUND,10} },
    [H_KHABELETH] = { {CREATURE_FAMILIAR,50}, {CREATURE_DEMON,20} },
    -- dungeon
    ["Dungeon"] = { {CREATURE_SCOUT,35}, {CREATURE_WITCH,12}, {CREATURE_MINOTAUR,5} },
    [H_VAYSHAN] = { {CREATURE_SCOUT,26}, {CREATURE_SCOUT,26} },
    [H_YRWANNA] = { {CREATURE_WITCH,11}, {CREATURE_WITCH,11} },
    [H_DARKSTORM] = { {CREATURE_MINOTAUR,7}, {CREATURE_MINOTAUR,7} },
    [H_SORGAL] = { {CREATURE_SCOUT,30}, {CREATURE_MINOTAUR,5}, {CREATURE_RIDER,2} },
    [H_ERUINA] = { {CREATURE_SCOUT,26}, {CREATURE_MINOTAUR,6}, {CREATURE_MATRON,1} },
    [H_SHADYA] = { {CREATURE_WITCH,15}, {CREATURE_SHADOW_MISTRESS,1} },
    [H_LETHOS] = { {CREATURE_SCOUT,32}, {CREATURE_WITCH,10}, {CREATURE_MANTICORE,1} },
    -- stronghold
    ["Stronghold"] = { {CREATURE_GOBLIN,45}, {CREATURE_SHAMAN,15}, {CREATURE_ORC_WARRIOR,7} },
    [H_KILGHAN] = { {CREATURE_GOBLIN,37}, {CREATURE_GOBLIN,37} },
    [H_TELSEK] = { {CREATURE_ORC_WARRIOR,10}, {CREATURE_ORC_WARRIOR,10} },
    [H_GARUNA] = { {CREATURE_GOBLIN,38}, {CREATURE_ORC_WARRIOR,8}, {CREATURE_CENTAUR,3} }, -- +1 centaur
    [H_GORSHAK] = { {CREATURE_SHAMAN,13}, {CREATURE_ORC_WARRIOR,9}, {CREATURE_ORC_SLAYER,1} }, -- +1 slayer
    [H_KARUKAT] = { {CREATURE_GOBLIN,40}, {CREATURE_SHAMAN,10}, {CREATURE_WYVERN,1} },
    [H_KUJIN] = { {CREATURE_GOBLIN,35}, {CREATURE_SHAMAN,10}, {CREATURE_SHAMAN,10} },
}

function IsArmyEmpty(hero)
    for i,cr in GetHeroArmy(hero) do
        if cr and cr ~= 0 then
            if i > 1 or GetHeroCreatures(hero, cr) > 1 then
                return nil
            else
                AddHeroCreatures(hero, 180, 1, 6) sleep()
                RemoveHeroCreatures(hero, cr, 1, 0) sleep()
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
