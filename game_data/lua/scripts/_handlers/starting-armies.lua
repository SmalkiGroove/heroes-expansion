

function ReplaceStartingArmy(hero)
	-- print("Starting army for hero "..hero)
	if STARTING_ARMIES[hero] and STARTING_ARMIES[hero][1] then
		-- AddHeroCreatures(hero, CREATURE_WOLF, 1, 6) sleep(1)
		local k, units, amounts = GetHeroArmySummary(hero)
		for i = 1,k do
			-- print("Remove hero creature type : "..units[i].." - "..amounts[i])
			RemoveHeroCreatures(hero, units[i], amounts[i])
		end
		for i = 1,7 do
			if STARTING_ARMIES[hero][i] then
				-- print("Add hero creature type "..STARTING_ARMIES[hero][i][1].." - "..STARTING_ARMIES[hero][i][2])
				AddHeroCreatures(hero, STARTING_ARMIES[hero][i][1], STARTING_ARMIES[hero][i][2], i-1)
			end
		end
		-- sleep(1) RemoveHeroCreatures(hero, CREATURE_WOLF, 1)
	end
end



INIT_T1X = 100
INIT_T1 = 80
INIT_T2X = 50
INIT_T2 = 40
INIT_T3X = 30
INIT_T3 = 20
INIT_T4X = 13
INIT_T4 = 10
INIT_T5X = 7
INIT_T5 = 5
INIT_T6X = 3
INIT_T6 = 2
INIT_T7 = 1

STARTING_ARMIES = {
    -- haven
    [H_DUNCAN] = { {CREATURE_PEASANT,INIT_T1}, {CREATURE_ARCHER,INIT_T2}, {CREATURE_FOOTMAN,INIT_T3} },
    [H_DOUGAL] = { {CREATURE_ARCHER,INIT_T2X}, {CREATURE_ARCHER,INIT_T2X} },
    [H_KLAUS] = { {CREATURE_ARCHER,INIT_T2}, {CREATURE_FOOTMAN,INIT_T3}, {CREATURE_CAVALIER,INIT_T6} },
    [H_IRINA] = { {CREATURE_GRIFFIN,INIT_T4}, {CREATURE_GRIFFIN,INIT_T4} },
    [H_ISABEL] = { {CREATURE_PEASANT,INIT_T1}, {CREATURE_SERAPH,INIT_T7} },
    [H_LASZLO] = { {CREATURE_FOOTMAN,INIT_T3X}, {CREATURE_VINDICATOR,INIT_T3} },
    [H_NICOLAI] = { {CREATURE_ARCHER,INIT_T2}, {CREATURE_FOOTMAN,INIT_T3}, {CREATURE_PRIEST,INIT_T5} },
    [H_GODRIC] = { {CREATURE_PEASANT,INIT_T1}, {CREATURE_ARCHER,INIT_T2}, {CREATURE_FOOTMAN,INIT_T3} },
    [H_FREYDA] = { {CREATURE_PEASANT,INIT_T1}, {CREATURE_ARCHER,INIT_T2}, {CREATURE_FOOTMAN,INIT_T3} },
    [H_RUTGER] = { {CREATURE_PEASANT,INIT_T1}, {CREATURE_PEASANT,INIT_T1}, {CREATURE_CAVALIER,INIT_T6} },
    [H_MAEVE] = { {CREATURE_PEASANT,INIT_T1}, {CREATURE_ARCHER,INIT_T2}, {CREATURE_GRIFFIN,INIT_T4} },
    [H_ELLAINE] = { {CREATURE_PEASANT,INIT_T1}, {CREATURE_PEASANT,INIT_T1}, {CREATURE_PEASANT,INIT_T1} },
    [H_ALARIC] = { {CREATURE_MILITIAMAN,INIT_T1}, {CREATURE_MARKSMAN,INIT_T2} },
    [H_GABRIELLE] = { {CREATURE_SWORDSMAN,INIT_T3}, {CREATURE_ZEALOT,INIT_T5} },
    [H_ORLANDO] = { {CREATURE_PEASANT,INIT_T1X}, {CREATURE_ARCHER,INIT_T2X}, {CREATURE_FOOTMAN,INIT_T3X} },
    [H_MARKAL] = { {CREATURE_PEASANT,INIT_T1}, {CREATURE_ARCHER,INIT_T2}, {CREATURE_FOOTMAN,INIT_T3} },
    -- preserve
    [H_WYNGAAL] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_ANWEN] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_TALANAR] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_OSSIR] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_FINDAN] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_JENOVA] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_GILRAEN] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_KYRRE] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_IVOR] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_MEPHALA] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_ALARON] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_DIRAEL] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_VINRAEL] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_YLTHIN] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_TIERU] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_GEM] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    [H_ELLESHAR] = { {CREATURE_BLADE_JUGGLER,INIT_T1} },
    -- academy
    [H_HAVEZ] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_MINASLI] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_JOSEPHINE] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_RAZZAK] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_DAVIUS] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_RISSA] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_GURVILIN] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_JHORA] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_CYRUS] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_FAIZ] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_MAAHIR] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_NATHIR] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_NUR] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_GALIB] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_ZEHIR] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_THEODORUS] = { {CREATURE_GREMLIN,INIT_T1} },
    [H_EMILIA] = { {CREATURE_GREMLIN,INIT_T1} },
    -- fortress
    [H_INGVAR] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_ROLF] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_WULFSTAN] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_TAZAR] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_MAXIMUS] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_KARLI] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_HEDWIG] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_TOLGHAR] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_EBBA] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_ULAND] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_HAEGEIR] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_HELMAR] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_BRAND] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_ERLING] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_HANGVUL] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_BART] = { {CREATURE_DEFENDER,INIT_T1} },
    [H_INGA] = { {CREATURE_DEFENDER,INIT_T1} },
    -- necropolis
    [H_KASPAR] = { {CREATURE_SKELETON,INIT_T1}, {CREATURE_WALKING_DEAD,INIT_T2}, {CREATURE_MANES,INIT_T3} },
    [H_VLADIMIR] = { {CREATURE_SKELETON,INIT_T1}, {CREATURE_WALKING_DEAD,INIT_T2}, {CREATURE_MANES,INIT_T3} },
    [H_ORSON] = { {CREATURE_WALKING_DEAD,INIT_T2}, {CREATURE_WALKING_DEAD,INIT_T2}, {CREATURE_WALKING_DEAD,INIT_T2} },
    [H_ORNELLA2] = { {CREATURE_SKELETON,INIT_T1}, {CREATURE_WALKING_DEAD,INIT_T2}, {CREATURE_LICH,INIT_T5} },
    [H_LUCRETIA] = { {CREATURE_VAMPIRE,INIT_T4}, {CREATURE_VAMPIRE,INIT_T4} },
    [H_XERXON] = { {CREATURE_SKELETON,INIT_T1}, {CREATURE_MANES,INIT_T3}, {CREATURE_BLACK_KNIGHT,INIT_T7} },
    [H_DEIRDRE] = { {CREATURE_SKELETON,INIT_T1}, {CREATURE_WALKING_DEAD,INIT_T2}, {CREATURE_BANSHEE,INIT_T7} },
    [H_NAADIR] = { {CREATURE_MANES,INIT_T3X}, {CREATURE_MANES,INIT_T3X} },
    [H_AISLINN] = { {CREATURE_SKELETON,INIT_T1}, {CREATURE_WALKING_DEAD,INIT_T2}, {CREATURE_MANES,INIT_T3} },
    [H_GIOVANNI] = { {CREATURE_SKELETON,INIT_T1}, {CREATURE_WALKING_DEAD,INIT_T2}, {CREATURE_MANES,INIT_T3} },
    [H_ARCHILUS] = { {CREATURE_SKELETON,INIT_T1}, {CREATURE_WALKING_DEAD,INIT_T2}, {CREATURE_MANES,INIT_T3} },
    [H_ZOLTAN] = { {CREATURE_GHOST,INIT_T3X}, {CREATURE_LICH_MASTER,INIT_T5X} },
    [H_RAVEN] = { {CREATURE_SKELETON,INIT_T1}, {CREATURE_SKELETON,INIT_T1}, {CREATURE_WALKING_DEAD,INIT_T2} },
    [H_ARANTIR] = { {CREATURE_SKELETON,INIT_T1X}, {CREATURE_WALKING_DEAD,INIT_T2X}, {CREATURE_MANES,INIT_T3X} },
    [H_THANT] = { {CREATURE_MUMMY,INIT_T5}, {CREATURE_MUMMY,INIT_T5}, {CREATURE_MUMMY,INIT_T5} },
    [H_SANDRO] = { {CREATURE_SKELETON,INIT_T1}, {CREATURE_WALKING_DEAD,INIT_T2}, {CREATURE_MANES,INIT_T3}, {CREATURE_VAMPIRE,INIT_T4} },
    [H_VIDOMINA] = { {CREATURE_WALKING_DEAD,INIT_T2X}, {CREATURE_HORROR_DRAGON,INIT_T6} },
    -- inferno
    [H_GRAWL] = { {CREATURE_HELL_HOUND,INIT_T3X}, {CREATURE_HELL_HOUND,INIT_T3X} },
    [H_NEBIROS] = { {CREATURE_FAMILIAR,INIT_T1}, {CREATURE_DEMON,INIT_T2}, {CREATURE_HELL_HOUND,INIT_T3} },
    [H_MARBAS] = { {CREATURE_FAMILIAR,INIT_T1}, {CREATURE_DEMON,INIT_T2}, {CREATURE_HELL_HOUND,INIT_T3} },
    [H_HARKENRAZ] = { {CREATURE_FAMILIAR,INIT_T1}, {CREATURE_FAMILIAR,INIT_T1}, {CREATURE_FAMILIAR,INIT_T1} },
    [H_CALH] = { {CREATURE_FAMILIAR,INIT_T1}, {CREATURE_DEMON,INIT_T2}, {CREATURE_HELL_HOUND,INIT_T3} },
    [H_SHELTEM] = { {CREATURE_FAMILIAR,INIT_T1}, {CREATURE_DEMON,INIT_T2}, {CREATURE_HELL_HOUND,INIT_T3} },
    [H_ALASTOR] = { {CREATURE_FAMILIAR,INIT_T1}, {CREATURE_DEMON,INIT_T2}, {CREATURE_SUCCUBUS,INIT_T4} },
    [H_GROK] = { {CREATURE_FAMILIAR,INIT_T1}, {CREATURE_HELL_HOUND,INIT_T3}, {CREATURE_NIGHTMARE,INIT_T5} },
    [H_NYMUS] = { {CREATURE_FAMILIAR,INIT_T1X}, {CREATURE_DEMON,INIT_T2X}, {CREATURE_HELL_HOUND,INIT_T3X} },
    [H_JEZEBETH] = { {CREATURE_FAMILIAR,INIT_T1}, {CREATURE_FAMILIAR,INIT_T1}, {CREATURE_HELL_HOUND,INIT_T3} },
    [H_MALUSTAR] = { {CREATURE_FAMILIAR,INIT_T1}, {CREATURE_DEMON,INIT_T2}, {CREATURE_HELL_HOUND,INIT_T3} },
    [H_AGRAEL] = { {CREATURE_IMP,INIT_T1}, {CREATURE_HORNED_DEMON,INIT_T2}, {CREATURE_CERBERI,INIT_T3} },
    [H_BIARA] = { {CREATURE_FAMILIAR,INIT_T1}, {CREATURE_HELL_HOUND,INIT_T3}, {CREATURE_SUCCUBUS,INIT_T4} },
    [H_KHABELETH] = { {CREATURE_FAMILIAR,INIT_T1}, {CREATURE_DEMON,INIT_T2}, {CREATURE_HELL_HOUND,INIT_T3} },
    [H_ZYDAR] = { {CREATURE_FAMILIAR,2*INIT_T1}, {CREATURE_DEMON,2*INIT_T2}, {CREATURE_DEVIL,INIT_T7} },
    [H_DELEB] = { {CREATURE_DEMON,INIT_T2}, {CREATURE_DEMON,INIT_T2}, {CREATURE_DEMON,INIT_T2} },
    [H_CALID] = { {CREATURE_FAMILIAR,INIT_T1X}, {CREATURE_DEMON,INIT_T2X} },
    -- dungeon
    [H_SORGAL] = { {CREATURE_SCOUT,INIT_T1} },
    [H_KYTHRA] = { {CREATURE_SCOUT,INIT_T1} },
    [H_AGBETH] = { {CREATURE_SCOUT,INIT_T1} },
    [H_RANLETH] = { {CREATURE_SCOUT,INIT_T1} },
    [H_DARKSTORM] = { {CREATURE_SCOUT,INIT_T1} },
    [H_YRWANNA] = { {CREATURE_SCOUT,INIT_T1} },
    [H_VAYSHAN] = { {CREATURE_SCOUT,INIT_T1} },
    [H_THRALSAI] = { {CREATURE_SCOUT,INIT_T1} },
    [H_LETHOS] = { {CREATURE_SCOUT,INIT_T1} },
    [H_ERUINA] = { {CREATURE_SCOUT,INIT_T1} },
    [H_SYLSAI] = { {CREATURE_SCOUT,INIT_T1} },
    [H_SINITAR] = { {CREATURE_SCOUT,INIT_T1} },
    [H_SHADYA] = { {CREATURE_SCOUT,INIT_T1} },
    [H_RAELAG] = { {CREATURE_SCOUT,INIT_T1} },
    [H_YLAYA] = { {CREATURE_SCOUT,INIT_T1} },
    [H_SEPHINROTH] = { {CREATURE_SCOUT,INIT_T1} },
    [H_KASTORE] = { {CREATURE_SCOUT,INIT_T1} },
    -- stronghold
    [H_TELSEK] = { {CREATURE_ORC_WARRIOR,INIT_T3}, {CREATURE_ORC_WARRIOR,INIT_T3}, {CREATURE_ORC_WARRIOR,INIT_T3} },
    [H_GORSHAK] = { {CREATURE_CENTAUR,INIT_T4}, {CREATURE_CENTAUR,INIT_T4} },
    [H_GOTAI] = { {CREATURE_GOBLIN,INIT_T1}, {CREATURE_SHAMAN,INIT_T2}, {CREATURE_ORC_WARRIOR,INIT_T3} },
    [H_AZAR] = { {CREATURE_GOBLIN,INIT_T1}, {CREATURE_SHAMAN,INIT_T2}, {CREATURE_ORC_WARRIOR,INIT_T3} },
    [H_MATEWA] = { {CREATURE_GOBLIN,INIT_T1X}, {CREATURE_CYCLOP,INIT_T7} },
    [H_KUNYAK] = { {CREATURE_SHAMAN,INIT_T2}, {CREATURE_ORC_WARRIOR,INIT_T3}, {CREATURE_ORCCHIEF_BUTCHER,INIT_T5} },
    [H_KRAGH] = { {CREATURE_GOBLIN,INIT_T1}, {CREATURE_ORC_WARRIOR,INIT_T3}, {CREATURE_CENTAUR,INIT_T4} },
    [H_KILGHAN] = { {CREATURE_GOBLIN,INIT_T1X}, {CREATURE_GOBLIN,INIT_T1X} },
    [H_CRAGHACK] = { {CREATURE_GOBLIN,INIT_T1}, {CREATURE_SHAMAN,INIT_T2}, {CREATURE_ORC_WARRIOR,INIT_T3} },
    [H_KRAAL] = { {CREATURE_GOBLIN,INIT_T1}, {CREATURE_SHAMAN,INIT_T2}, {CREATURE_ORC_WARRIOR,INIT_T3} },
    [H_SHAKKARUKAT] = { {CREATURE_WYVERN_POISONOUS,INIT_T6X} },
    [H_KUJIN] = { {CREATURE_GOBLIN,INIT_T1X}, {CREATURE_SHAMAN,INIT_T2X} },
    [H_SHIVA] = { {CREATURE_SHAMAN,INIT_T2X}, {CREATURE_SHAMAN,INIT_T2X} },
    [H_HAGGASH] = { {CREATURE_GOBLIN,2*INIT_T1}, {CREATURE_SHAMAN,2*INIT_T2}, {CREATURE_ORC_WARRIOR,2*INIT_T3} },
    [H_MUKHA] = { {CREATURE_SHAMAN,INIT_T2X}, {CREATURE_ORC_WARRIOR,INIT_T3} },
    [H_URGHAT] = { {CREATURE_GOBLIN,INIT_T1X}, {CREATURE_SHAMAN,INIT_T2X} },
    [H_GARUNA] = { {CREATURE_GOBLIN,INIT_T1}, {CREATURE_SHAMAN,INIT_T2}, {CREATURE_ORC_WARRIOR,INIT_T3} },
    [H_ZOULEIKA] = { {CREATURE_GOBLIN,INIT_T1}, {CREATURE_SHAMAN,INIT_T2}, {CREATURE_ORC_WARRIOR,INIT_T3} },
    [H_ERIKA] = { {CREATURE_GOBLIN,INIT_T1X}, {CREATURE_SHAMAN,INIT_T2X} },
}


-- print("Loaded starting armies advmap routines")
ROUTINES_LOADED[22] = 1