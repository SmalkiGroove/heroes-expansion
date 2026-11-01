
DUEL_RECRUITS_WEEKS = {}
for i = 1,7 do DUEL_RECRUITS_WEEKS[i] = (1+DUEL_MODE)*6 + trunc(0.5*(8-i)) end

-- extra weekly growth of the base creature of each tier, added to the creatures.lua growth for the town recruits
DUEL_BONUS_GROWTH = {
    [HAVEN] = {
        [CREATURE_PEASANT] = 2,
        [CREATURE_ARCHER] = 1,
        [CREATURE_FOOTMAN] = 1,
        [CREATURE_GRIFFIN] = 0,
        [CREATURE_PRIEST] = 0,
        [CREATURE_CAVALIER] = 0,
        [CREATURE_ANGEL] = 0,
    },
    [INFERNO] = {
        [CREATURE_FAMILIAR] = 0,
        [CREATURE_DEMON] = 2,
        [CREATURE_HELL_HOUND] = 0,
        [CREATURE_SUCCUBUS] = 0,
        [CREATURE_NIGHTMARE] = 1,
        [CREATURE_PIT_FIEND] = 0,
        [CREATURE_DEVIL] = 0,
    },
    [NECROPOLIS] = {
        [CREATURE_SKELETON] = 6,
        [CREATURE_WALKING_DEAD] = 0,
        [CREATURE_MANES] = 0,
        [CREATURE_VAMPIRE] = 0,
        [CREATURE_LICH] = 0,
        [CREATURE_BLACK_KNIGHT] = 0,
        [CREATURE_WIGHT] = 0,
    },
    [PRESERVE] = {
        [CREATURE_BLADE_JUGGLER] = 0,
        [CREATURE_PIXIE] = 4,
        [CREATURE_WOOD_ELF] = 0,
        [CREATURE_DRUID] = 0,
        [CREATURE_UNICORN] = 0,
        [CREATURE_TREANT] = 1,
        [CREATURE_GREEN_DRAGON] = 0,
    },
    [ACADEMY] = {
        [CREATURE_GREMLIN] = 0,
        [CREATURE_STONE_GARGOYLE] = 0,
        [CREATURE_IRON_GOLEM] = 0,
        [CREATURE_MAGI] = 0,
        [CREATURE_GENIE] = 2,
        [CREATURE_RAKSHASA] = 0,
        [CREATURE_GIANT] = 0,
    },
    [DUNGEON] = {
        [CREATURE_SCOUT] = 0,
        [CREATURE_WITCH] = 4,
        [CREATURE_MINOTAUR] = 2,
        [CREATURE_RIDER] = 0,
        [CREATURE_MATRON] = 0,
        [CREATURE_HYDRA] = 0,
        [CREATURE_DEEP_DRAGON] = 0,
    },
    [FORTRESS] = {
        [CREATURE_DEFENDER] = 0,
        [CREATURE_AXE_FIGHTER] = 0,
        [CREATURE_BROWLER] = 4,
        [CREATURE_BEAR_RIDER] = 0,
        [CREATURE_RUNE_MAGE] = 1,
        [CREATURE_THANE] = 0,
        [CREATURE_FIRE_DRAGON] = 0,
    },
    [STRONGHOLD] = {
        [CREATURE_GOBLIN] = 6,
        [CREATURE_SHAMAN] = 0,
        [CREATURE_ORC_WARRIOR] = 0,
        [CREATURE_CENTAUR] = 0,
        [CREATURE_ORCCHIEF_BUTCHER] = 0,
        [CREATURE_WYVERN] = 0,
        [CREATURE_CYCLOP] = 0,
    },
}

DUEL_TOWN_RECRUITS = {{}, {}}

function DuelTownRecruits(player)
    log.trace("/scripts/duel/duel_armies.lua: DuelTownRecruits")
    log.debug("DuelTownRecruits", player)
    local faction = DUEL_FACTION[player]
    local town = DUEL_TOWN_NAME[player][faction]
    for tier = 1,7 do
        local creature = CREATURES_BY_FACTION[faction][tier][1]
        local nb = (GetGrowth(creature) + DUEL_BONUS_GROWTH[faction][creature]) * DUEL_RECRUITS_WEEKS[tier]
        SetObjectDwellingCreatures(town, creature, nb)
        DUEL_TOWN_RECRUITS[player][creature] = nb
    end
end
