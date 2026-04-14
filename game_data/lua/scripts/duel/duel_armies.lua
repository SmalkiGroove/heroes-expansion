
DUEL_RECRUITS_WEEKS = (1 + DUEL_MODE) * 8

DUEL_CREATURE_GROWTH = {
    [HAVEN] = {
        [CREATURE_PEASANT] = 65,
        [CREATURE_ARCHER] = 30,
        [CREATURE_FOOTMAN] = 20,
        [CREATURE_GRIFFIN] = 9,
        [CREATURE_PRIEST] = 5,
        [CREATURE_CAVALIER] = 3,
        [CREATURE_ANGEL] = 1,
    },
    [INFERNO] = {
        [CREATURE_FAMILIAR] = 66,
        [CREATURE_DEMON] = 38,
        [CREATURE_HELL_HOUND] = 22,
        [CREATURE_SUCCUBUS] = 11,
        [CREATURE_NIGHTMARE] = 6,
        [CREATURE_PIT_FIEND] = 3,
        [CREATURE_DEVIL] = 1,
    },
    [NECROPOLIS] = {
        [CREATURE_SKELETON] = 63,
        [CREATURE_WALKING_DEAD] = 39,
        [CREATURE_MANES] = 19,
        [CREATURE_VAMPIRE] = 10,
        [CREATURE_LICH] = 5,
        [CREATURE_BLACK_KNIGHT] = 3,
        [CREATURE_WIGHT] = 1,
    },
    [PRESERVE] = {
        [CREATURE_BLADE_JUGGLER] = 38,
        [CREATURE_PIXIE] = 26,
        [CREATURE_WOOD_ELF] = 14,
        [CREATURE_DRUID] = 9,
        [CREATURE_UNICORN] = 5,
        [CREATURE_TREANT] = 4,
        [CREATURE_GREEN_DRAGON] = 1,
    },
    [ACADEMY] = {
        [CREATURE_GREMLIN] = 51,
        [CREATURE_STONE_GARGOYLE] = 33,
        [CREATURE_IRON_GOLEM] = 20,
        [CREATURE_MAGI] = 10,
        [CREATURE_GENIE] = 7,
        [CREATURE_RAKSHASA] = 3,
        [CREATURE_GIANT] = 1,
    },
    [DUNGEON] = {
        [CREATURE_SCOUT] = 39,
        [CREATURE_WITCH] = 26,
        [CREATURE_MINOTAUR] = 18,
        [CREATURE_RIDER] = 9,
        [CREATURE_MATRON] = 5,
        [CREATURE_HYDRA] = 3,
        [CREATURE_DEEP_DRAGON] = 1,
    },
    [FORTRESS] = {
        [CREATURE_DEFENDER] = 48,
        [CREATURE_AXE_FIGHTER] = 28,
        [CREATURE_BROWLER] = 24,
        [CREATURE_BEAR_RIDER] = 10,
        [CREATURE_RUNE_MAGE] = 6,
        [CREATURE_THANE] = 3,
        [CREATURE_FIRE_DRAGON] = 1,
    },
    [STRONGHOLD] = {
        [CREATURE_GOBLIN] = 64,
        [CREATURE_SHAMAN] = 28,
        [CREATURE_ORC_WARRIOR] = 21,
        [CREATURE_CENTAUR] = 10,
        [CREATURE_ORCCHIEF_BUTCHER] = 6,
        [CREATURE_WYVERN] = 3,
        [CREATURE_CYCLOP] = 1,
    }
}

DUEL_TOWN_RECRUITS = {{}, {}}

function DuelTownRecruits(player)
    log(DEBUG, "DUEL: DuelTownRecruits for player "..player)
    local faction = DUEL_FACTION[player]
    local town = DUEL_TOWN_NAME[player][faction]
    for creature, growth in DUEL_CREATURE_GROWTH[faction] do
        local nb = growth * DUEL_RECRUITS_WEEKS
        SetObjectDwellingCreatures(town, creature, nb)
        DUEL_TOWN_RECRUITS[player][creature] = nb
    end
end
