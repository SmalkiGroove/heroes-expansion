

function ReplaceStartingArmy(hero)
	-- print("$ ReplaceStartingArmy")
    local army = {}
    if STARTING_ARMIES[hero] then
        army = STARTING_ARMIES[hero]
    else
        local faction = FACTION_TEXT[HEROES[hero]] print(faction)
        army = STARTING_ARMIES[faction]
    end
    local k, units, amounts = GetHeroArmySummary(hero)
    for i = 1,k do
        RemoveHeroCreatures(hero, units[i], amounts[i])
    end
    for i = 1,7 do
        if army[i] then
            AddHeroCreatures(hero, army[i][1], army[i][2], i-1)
        end
    end
end


STARTING_ARMIES = {
    -- haven
    ["Haven"] = { {CREATURE_PEASANT,45}, {CREATURE_ARCHER,15}, {CREATURE_FOOTMAN,7} },
    -- preserve
    ["Sylvan"] = { {CREATURE_BLADE_JUGGLER,35}, {CREATURE_PIXIE,12}, {CREATURE_WOOD_ELF,5} },
    -- academy
    ["Academy"] = { {CREATURE_GREMLIN,40}, {CREATURE_STONE_GARGOYLE,15}, {CREATURE_IRON_GOLEM,7} },
    -- fortress
    ["Fortress"] = { {CREATURE_DEFENDER,40}, {CREATURE_AXE_FIGHTER,15}, {CREATURE_BROWLER,7} },
    -- necropolis
    ["Necropolis"] = { {CREATURE_SKELETON,45}, {CREATURE_WALKING_DEAD,15}, {CREATURE_MANES,7} },
    -- inferno
    ["Inferno"] = { {CREATURE_FAMILIAR,45}, {CREATURE_DEMON,15}, {CREATURE_HELL_HOUND,7} },
    -- dungeon
    ["Dungeon"] = { {CREATURE_SCOUT,35}, {CREATURE_WITCH,12}, {CREATURE_MINOTAUR,5} },
    -- stronghold
    ["Stronghold"] = { {CREATURE_GOBLIN,45}, {CREATURE_SHAMAN,15}, {CREATURE_ORC_WARRIOR,7} },
}


-- print("Loaded starting-armies.lua")
ROUTINES_LOADED[21] = 1
