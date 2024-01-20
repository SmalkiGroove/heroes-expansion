
--------------------------------------------------------------------------------------------------------------------------------------------
-- RACES ID

NEUTRAL = 0
HAVEN = 1
PRESERVE = 2
INFERNO = 3
NECROPOLIS = 4
ACADEMY = 5
DUNGEON = 6
FORTRESS = 7
STRONGHOLD = 8

--------------------------------------------------------------------------------------------------------------------------------------------
-- HEROES

-- haven
H_DUNCAN = 'Duncan'                 -- diplomacy
H_VITTORIO = 'Christian'            -- ballista
H_MAEVE = 'Maeve'                   -- peasants
H_DOUGAL = 'Orrin'                  -- archers
H_LASZLO = 'Laszlo'                 -- footmen
H_KLAUS = 'Sarge'                   -- cavaliers
H_FREYDA = 'Axel'                   -- prayer
H_ISABEL = 'Isabell'                -- bless
H_GODRIC = 'GodricMP'               -- celestial shield
H_NICOLAI = 'Nicolai'               -- suzerain
H_GABRIELLE = 'RedHeavenHero06'     -- ?
H_ALARIC = 'Alaric'                 -- counterspell

-- sylvan
H_WYNGAAL = 'Linaas'                -- logistics
H_KYRRE = 'Kyrre'                   -- experience
H_TALANAR = 'Nadaur'                -- rage
H_JENOVA = 'Jenova'                 -- offender
H_FINDAN = 'Heam'                   -- hunters
H_IVOR = 'Arniel'                   -- wolves
H_DIRAEL = 'Diraya'                 -- wasps
H_VINRAEL = 'Vinrael'               -- haste
H_TIERU = 'Vaniel'                  -- druids
H_YLTHIN = 'Itil'                   -- unicorns
H_ELLESHAR = 'Elleshar'             -- spellpower
H_MELODIA = 'Melodia'               -- regeneration

-- academy
H_HAVEZ = 'Havez'                   -- gremlins
H_RAZZAK = 'Razzak'                 -- golems
H_DAVIUS = 'Davius'                 -- rakshasas
H_NATHIR = 'Astral'                 -- bombardier
H_THEODORUS = 'Timerkhan'           -- exauster
H_GALIB = 'Tan'                     -- magic mirror
H_NUR = 'Nur'                       -- mana regen
H_ZEHIR = 'Zehir'                   -- elementals
H_CYRUS = 'Cyrus'                   -- mages
H_MINASLI = 'Minasli'               -- eagles
H_RISSA = 'Rissa'                   -- time shifter
H_MAAHIR = 'Maahir'                 -- experience

-- fortress
H_INGVAR = 'Ingvar'                 -- defenders
H_KARLI = 'Skeggy'                  -- skirmishers
H_ROLF = 'Rolf'                     -- bear riders
H_HANGVUL = 'Hangvul2'              -- thanes
H_TAZAR = 'Tazar'                   -- initiative
H_WULFSTAN = 'Wulfstan'             -- ballista
H_TOLGHAR = 'KingTolghar'           -- stun rune
H_ERLING = 'Egil'                   -- rune priests
H_HEDWIG = 'Vilma'                  -- evasion
H_BRAND = 'Brand'                   -- fireball
H_EBBA = 'Bersy'                    -- economist
H_INGA = 'Una'                      -- earth spells

-- necropolis
H_VLADIMIR = 'Pelt'                 -- blood drinker
H_ARANTIR = 'Arantir'               -- diplomacy
H_ORSON = 'Straker'                 -- zombies
H_LUCRETIA = 'Tamika'               -- vampires
H_XERXON = 'Xerxon'                 -- black knights
H_KASPAR = 'Gles'                   -- plague tent
H_RAVEN = 'Effig'                   -- reanimator
H_ARCHILUS = 'Archilus'             -- avatar of death
H_THANT = 'Thant'                   -- curse mummies
H_SANDRO = 'Sandro'                 -- ?
H_ORNELLA = 'OrnellaNecro'          -- frost mage
H_DEIRDRE = 'Nemor'                 -- banshee scream

-- inferno
H_GROK = 'Grok'                     -- logistics
H_SHELTEM = 'Sheltem'               -- bombardier
H_GRAWL = 'Guarg'                   -- hell hounds
H_ASH = 'Ash'                       -- offender
H_NYMUS = 'Nymus'                   -- gating
H_MALUSTAR = 'Malustar'             -- explosions
H_CALID = 'Calid2'                  -- fireball
H_MARBAS = 'Marder'                 -- confusion
H_ORLANDO = 'Orlando'               -- ?
H_BIARA = 'Biara'                   -- succubus
H_DELEB = 'Deleb'                   -- fire traps
H_KHABELETH = 'Sovereign2'          -- pit lords

-- dungeon
H_VAYSHAN = 'Ohtarig'               -- scouts
H_YRWANNA = 'Urunir'                -- blood witches
H_DARKSTORM = 'Darkstorm'           -- minotaurs
H_SORGAL = 'Ferigl'                 -- beastmaster
H_SYLSAI = 'Sylsai'                 -- corrupter
H_RAELAG = 'Raelag'                 -- dragon set
H_SINITAR = 'Inagost'               -- power bargain
H_RANLETH = 'Ranleth'               -- learning
H_ERUINA = 'Eruina'                 -- shadow witches
H_SHADYA = 'Kelodin'                -- witch queen
H_LETHOS = 'Dalom'                  -- poisoner
H_SEPHINROTH = 'Sephinroth'         -- elemental vision

-- stronghold
H_KRAGH = 'Hero1'                   -- atb boost
H_GOTAI = 'Gottai'                  -- warcries
H_KILGHAN = 'Hero9'                 -- goblins
H_TELSEK = 'Hero8'                  -- warriors
H_GARUNA = 'Hero3'                  -- centaurs
H_GORSHAK = 'Hero4'                 -- slayers
H_KARUKAT = 'Hero6'                 -- wyverns
H_HAGGASH = 'Hero7'                 -- magic resist
H_MUKHA = 'Mokka'                   -- lightning
H_URGHAT = 'Hero2'                  -- ?
H_ZOULEIKA = 'Zouleika'             -- healing tent
H_KUJIN = 'KujinMP'                 -- shamans


HEROES = {
    [H_DUNCAN]    = HAVEN,        [H_WYNGAAL]  = PRESERVE,     [H_HAVEZ]     = ACADEMY,      [H_INGVAR]    = FORTRESS,
    [H_VITTORIO]  = HAVEN,        [H_KYRRE]    = PRESERVE,     [H_RAZZAK]    = ACADEMY,      [H_KARLI]     = FORTRESS,
    [H_MAEVE]     = HAVEN,        [H_TALANAR]  = PRESERVE,     [H_DAVIUS]    = ACADEMY,      [H_ROLF]      = FORTRESS,
    [H_DOUGAL]    = HAVEN,        [H_JENOVA]   = PRESERVE,     [H_NATHIR]    = ACADEMY,      [H_HANGVUL]   = FORTRESS,
    [H_LASZLO]    = HAVEN,        [H_FINDAN]   = PRESERVE,     [H_THEODORUS] = ACADEMY,      [H_TAZAR]     = FORTRESS,
    [H_KLAUS]     = HAVEN,        [H_IVOR]     = PRESERVE,     [H_GALIB]     = ACADEMY,      [H_WULFSTAN]  = FORTRESS,
    [H_FREYDA]    = HAVEN,        [H_DIRAEL]   = PRESERVE,     [H_NUR]       = ACADEMY,      [H_TOLGHAR]   = FORTRESS,
    [H_ISABEL]    = HAVEN,        [H_VINRAEL]  = PRESERVE,     [H_ZEHIR]     = ACADEMY,      [H_ERLING]    = FORTRESS,
    [H_GODRIC]    = HAVEN,        [H_TIERU]    = PRESERVE,     [H_CYRUS]     = ACADEMY,      [H_HEDWIG]    = FORTRESS,
    [H_NICOLAI]   = HAVEN,        [H_YLTHIN]   = PRESERVE,     [H_MINASLI]   = ACADEMY,      [H_BRAND]     = FORTRESS,
    [H_GABRIELLE] = HAVEN,        [H_ELLESHAR] = PRESERVE,     [H_RISSA]     = ACADEMY,      [H_EBBA]      = FORTRESS,
    [H_ALARIC]    = HAVEN,        [H_MELODIA]  = PRESERVE,     [H_MAAHIR]    = ACADEMY,      [H_INGA]      = FORTRESS,
    
    [H_VLADIMIR] = NECROPOLIS,    [H_GROK]      = INFERNO,     [H_VAYSHAN]    = DUNGEON,     [H_KRAGH]    = STRONGHOLD,
    [H_ARANTIR]  = NECROPOLIS,    [H_SHELTEM]   = INFERNO,     [H_YRWANNA]    = DUNGEON,     [H_GOTAI]    = STRONGHOLD,
    [H_ORSON]    = NECROPOLIS,    [H_GRAWL]     = INFERNO,     [H_DARKSTORM]  = DUNGEON,     [H_KILGHAN]  = STRONGHOLD,
    [H_LUCRETIA] = NECROPOLIS,    [H_ASH]       = INFERNO,     [H_SORGAL]     = DUNGEON,     [H_TELSEK]   = STRONGHOLD,
    [H_XERXON]   = NECROPOLIS,    [H_NYMUS]     = INFERNO,     [H_SYLSAI]     = DUNGEON,     [H_GARUNA]   = STRONGHOLD,
    [H_KASPAR]   = NECROPOLIS,    [H_MALUSTAR]  = INFERNO,     [H_RAELAG]     = DUNGEON,     [H_GORSHAK]  = STRONGHOLD,
    [H_RAVEN]    = NECROPOLIS,    [H_CALID]     = INFERNO,     [H_SINITAR]    = DUNGEON,     [H_KARUKAT]  = STRONGHOLD,
    [H_ARCHILUS] = NECROPOLIS,    [H_MARBAS]    = INFERNO,     [H_RANLETH]    = DUNGEON,     [H_HAGGASH]  = STRONGHOLD,
    [H_THANT]    = NECROPOLIS,    [H_ORLANDO]   = INFERNO,     [H_ERUINA]     = DUNGEON,     [H_MUKHA]    = STRONGHOLD,
    [H_SANDRO]   = NECROPOLIS,    [H_BIARA]     = INFERNO,     [H_SHADYA]     = DUNGEON,     [H_URGHAT]   = STRONGHOLD,
    [H_ORNELLA]  = NECROPOLIS,    [H_DELEB]     = INFERNO,     [H_LETHOS]     = DUNGEON,     [H_ZOULEIKA] = STRONGHOLD,
    [H_DEIRDRE]  = NECROPOLIS,    [H_KHABELETH] = INFERNO,     [H_SEPHINROTH] = DUNGEON,     [H_KUJIN]    = STRONGHOLD,
}

--------------------------------------------------------------------------------------------------------------------------------------------
-- CREATURES

CREATURES = {
    [CREATURE_PEASANT]          = {HAVEN, 1},         [CREATURE_MILITIAMAN]           = {HAVEN, 1},         [CREATURE_LANDLORD ]          = {HAVEN, 1},
    [CREATURE_ARCHER]           = {HAVEN, 2},         [CREATURE_MARKSMAN]             = {HAVEN, 2},         [CREATURE_LONGBOWMAN]         = {HAVEN, 2},
    [CREATURE_FOOTMAN]          = {HAVEN, 3},         [CREATURE_SWORDSMAN]            = {HAVEN, 3},         [CREATURE_VINDICATOR]         = {HAVEN, 3},
    [CREATURE_GRIFFIN]          = {HAVEN, 4},         [CREATURE_ROYAL_GRIFFIN]        = {HAVEN, 4},         [CREATURE_BATTLE_GRIFFIN]     = {HAVEN, 4},
    [CREATURE_PRIEST]           = {HAVEN, 5},         [CREATURE_CLERIC]               = {HAVEN, 5},         [CREATURE_ZEALOT]             = {HAVEN, 5},
    [CREATURE_CAVALIER]         = {HAVEN, 6},         [CREATURE_PALADIN]              = {HAVEN, 6},         [CREATURE_CHAMPION]           = {HAVEN, 6},
    [CREATURE_ANGEL]            = {HAVEN, 7},         [CREATURE_ARCHANGEL]            = {HAVEN, 7},         [CREATURE_SERAPH]             = {HAVEN, 7},
    [CREATURE_BLADE_JUGGLER]    = {PRESERVE, 1},      [CREATURE_WAR_DANCER]           = {PRESERVE, 1},      [CREATURE_BLADE_SINGER]       = {PRESERVE, 1},
    [CREATURE_PIXIE]            = {PRESERVE, 2},      [CREATURE_SPRITE]               = {PRESERVE, 2},      [CREATURE_DRYAD]              = {PRESERVE, 2},
    [CREATURE_WOOD_ELF]         = {PRESERVE, 3},      [CREATURE_GRAND_ELF]            = {PRESERVE, 3},      [CREATURE_SHARP_SHOOTER]      = {PRESERVE, 3},
    [CREATURE_DRUID]            = {PRESERVE, 4},      [CREATURE_DRUID_ELDER]          = {PRESERVE, 4},      [CREATURE_HIGH_DRUID]         = {PRESERVE, 4},
    [CREATURE_UNICORN]          = {PRESERVE, 5},      [CREATURE_WAR_UNICORN]          = {PRESERVE, 5},      [CREATURE_WHITE_UNICORN]      = {PRESERVE, 5},
    [CREATURE_TREANT]           = {PRESERVE, 6},      [CREATURE_TREANT_GUARDIAN]      = {PRESERVE, 6},      [CREATURE_ANGER_TREANT]       = {PRESERVE, 6},
    [CREATURE_GREEN_DRAGON]     = {PRESERVE, 7},      [CREATURE_GOLD_DRAGON]          = {PRESERVE, 7},      [CREATURE_RAINBOW_DRAGON]     = {PRESERVE, 7},
    [CREATURE_GREMLIN]          = {ACADEMY, 1},       [CREATURE_MASTER_GREMLIN]       = {ACADEMY, 1},       [CREATURE_GREMLIN_SABOTEUR]   = {ACADEMY, 1},
    [CREATURE_STONE_GARGOYLE]   = {ACADEMY, 2},       [CREATURE_OBSIDIAN_GARGOYLE]    = {ACADEMY, 2},       [CREATURE_MARBLE_GARGOYLE]    = {ACADEMY, 2},
    [CREATURE_IRON_GOLEM]       = {ACADEMY, 3},       [CREATURE_STEEL_GOLEM]          = {ACADEMY, 3},       [CREATURE_OBSIDIAN_GOLEM]     = {ACADEMY, 3},
    [CREATURE_MAGI]             = {ACADEMY, 4},       [CREATURE_ARCH_MAGI]            = {ACADEMY, 4},       [CREATURE_COMBAT_MAGE]        = {ACADEMY, 4},
    [CREATURE_GENIE]            = {ACADEMY, 5},       [CREATURE_MASTER_GENIE]         = {ACADEMY, 5},       [CREATURE_DJINN_VIZIER]       = {ACADEMY, 5},
    [CREATURE_RAKSHASA]         = {ACADEMY, 6},       [CREATURE_RAKSHASA_RUKH]        = {ACADEMY, 6},       [CREATURE_RAKSHASA_KSHATRI]   = {ACADEMY, 6},
    [CREATURE_GIANT]            = {ACADEMY, 7},       [CREATURE_TITAN]                = {ACADEMY, 7},       [CREATURE_STORM_LORD]         = {ACADEMY, 7},
    [CREATURE_DEFENDER]         = {FORTRESS, 1},      [CREATURE_STOUT_DEFENDER]       = {FORTRESS, 1},      [CREATURE_STONE_DEFENDER]     = {FORTRESS, 1},
    [CREATURE_AXE_FIGHTER]      = {FORTRESS, 2},      [CREATURE_AXE_THROWER]          = {FORTRESS, 2},      [CREATURE_HARPOONER]          = {FORTRESS, 2},
    [CREATURE_BROWLER]          = {FORTRESS, 3},      [CREATURE_BERSERKER]            = {FORTRESS, 3},      [CREATURE_BATTLE_RAGER]       = {FORTRESS, 3},
    [CREATURE_BEAR_RIDER]       = {FORTRESS, 4},      [CREATURE_BLACKBEAR_RIDER]      = {FORTRESS, 4},      [CREATURE_WHITE_BEAR_RIDER]   = {FORTRESS, 4},
    [CREATURE_RUNE_MAGE]        = {FORTRESS, 5},      [CREATURE_FLAME_MAGE]           = {FORTRESS, 5},      [CREATURE_FLAME_KEEPER]       = {FORTRESS, 5},
    [CREATURE_THANE]            = {FORTRESS, 6},      [CREATURE_WARLORD]              = {FORTRESS, 6},      [CREATURE_THUNDER_THANE]      = {FORTRESS, 6},
    [CREATURE_FIRE_DRAGON]      = {FORTRESS, 7},      [CREATURE_MAGMA_DRAGON]         = {FORTRESS, 7},      [CREATURE_LAVA_DRAGON]        = {FORTRESS, 7},
    [CREATURE_SKELETON]         = {NECROPOLIS, 1},    [CREATURE_SKELETON_ARCHER]      = {NECROPOLIS, 1},    [CREATURE_SKELETON_WARRIOR]   = {NECROPOLIS, 1},
    [CREATURE_WALKING_DEAD]     = {NECROPOLIS, 2},    [CREATURE_ZOMBIE]               = {NECROPOLIS, 2},    [CREATURE_DISEASE_ZOMBIE]     = {NECROPOLIS, 2},
    [CREATURE_MANES]            = {NECROPOLIS, 3},    [CREATURE_GHOST]                = {NECROPOLIS, 3},    [CREATURE_POLTERGEIST]        = {NECROPOLIS, 3},
    [CREATURE_VAMPIRE]          = {NECROPOLIS, 4},    [CREATURE_VAMPIRE_LORD]         = {NECROPOLIS, 4},    [CREATURE_NOSFERATU]          = {NECROPOLIS, 4},
    [CREATURE_LICH]             = {NECROPOLIS, 5},    [CREATURE_DEMILICH]             = {NECROPOLIS, 5},    [CREATURE_LICH_MASTER]        = {NECROPOLIS, 5},
    [CREATURE_BONE_DRAGON]      = {NECROPOLIS, 6},    [CREATURE_SHADOW_DRAGON]        = {NECROPOLIS, 6},    [CREATURE_HORROR_DRAGON]      = {NECROPOLIS, 6},
    [CREATURE_WIGHT]            = {NECROPOLIS, 7},    [CREATURE_WRAITH]               = {NECROPOLIS, 7},    [CREATURE_BANSHEE]            = {NECROPOLIS, 7},
    [CREATURE_FAMILIAR]         = {INFERNO, 1},       [CREATURE_IMP]                  = {INFERNO, 1},       [CREATURE_QUASIT]             = {INFERNO, 1},
    [CREATURE_DEMON]            = {INFERNO, 2},       [CREATURE_HORNED_DEMON]         = {INFERNO, 2},       [CREATURE_HORNED_LEAPER]      = {INFERNO, 2},
    [CREATURE_HELL_HOUND]       = {INFERNO, 3},       [CREATURE_CERBERI]              = {INFERNO, 3},       [CREATURE_FIREBREATHER_HOUND] = {INFERNO, 3},
    [CREATURE_SUCCUBUS]         = {INFERNO, 4},       [CREATURE_INFERNAL_SUCCUBUS]    = {INFERNO, 4},       [CREATURE_SUCCUBUS_SEDUCER]   = {INFERNO, 4},
    [CREATURE_NIGHTMARE]        = {INFERNO, 5},       [CREATURE_FRIGHTFUL_NIGHTMARE]  = {INFERNO, 5},       [CREATURE_HELLMARE]           = {INFERNO, 5},
    [CREATURE_PIT_FIEND]        = {INFERNO, 6},       [CREATURE_BALOR]                = {INFERNO, 6},       [CREATURE_PIT_SPAWN]          = {INFERNO, 6},
    [CREATURE_DEVIL]            = {INFERNO, 7},       [CREATURE_ARCHDEVIL]            = {INFERNO, 7},       [CREATURE_ARCH_DEMON]         = {INFERNO, 7},
    [CREATURE_SCOUT]            = {DUNGEON, 1},       [CREATURE_ASSASSIN]             = {DUNGEON, 1},       [CREATURE_STALKER]            = {DUNGEON, 1},
    [CREATURE_WITCH]            = {DUNGEON, 2},       [CREATURE_BLOOD_WITCH]          = {DUNGEON, 2},       [CREATURE_BLOOD_WITCH_2]      = {DUNGEON, 2},
    [CREATURE_MINOTAUR]         = {DUNGEON, 3},       [CREATURE_MINOTAUR_KING]        = {DUNGEON, 3},       [CREATURE_MINOTAUR_CAPTAIN]   = {DUNGEON, 3},
    [CREATURE_RIDER]            = {DUNGEON, 4},       [CREATURE_RAVAGER]              = {DUNGEON, 4},       [CREATURE_BLACK_RIDER]        = {DUNGEON, 4},
    [CREATURE_MATRON]           = {DUNGEON, 5},       [CREATURE_MATRIARCH]            = {DUNGEON, 5},       [CREATURE_SHADOW_MISTRESS]    = {DUNGEON, 5},
    [CREATURE_HYDRA]            = {DUNGEON, 6},       [CREATURE_CHAOS_HYDRA]          = {DUNGEON, 6},       [CREATURE_ACIDIC_HYDRA]       = {DUNGEON, 6},
    [CREATURE_DEEP_DRAGON]      = {DUNGEON, 7},       [CREATURE_BLACK_DRAGON]         = {DUNGEON, 7},       [CREATURE_RED_DRAGON]         = {DUNGEON, 7},
    [CREATURE_GOBLIN]           = {STRONGHOLD, 1},    [CREATURE_GOBLIN_TRAPPER]       = {STRONGHOLD, 1},    [CREATURE_GOBLIN_DEFILER]     = {STRONGHOLD, 1},
    [CREATURE_SHAMAN]           = {STRONGHOLD, 2},    [CREATURE_SHAMAN_WITCH]         = {STRONGHOLD, 2},    [CREATURE_SHAMAN_HAG]         = {STRONGHOLD, 2},
    [CREATURE_ORC_WARRIOR]      = {STRONGHOLD, 3},    [CREATURE_ORC_SLAYER]           = {STRONGHOLD, 3},    [CREATURE_ORC_WARMONGER]      = {STRONGHOLD, 3},
    [CREATURE_CENTAUR]          = {STRONGHOLD, 4},    [CREATURE_CENTAUR_NOMAD]        = {STRONGHOLD, 4},    [CREATURE_CENTAUR_MARADEUR]   = {STRONGHOLD, 4},
    [CREATURE_ORCCHIEF_BUTCHER] = {STRONGHOLD, 5},    [CREATURE_ORCCHIEF_EXECUTIONER] = {STRONGHOLD, 5},    [CREATURE_ORCCHIEF_CHIEFTAIN] = {STRONGHOLD, 5},
    [CREATURE_WYVERN]           = {STRONGHOLD, 6},    [CREATURE_WYVERN_POISONOUS]     = {STRONGHOLD, 6},    [CREATURE_WYVERN_PAOKAI]      = {STRONGHOLD, 6},
    [CREATURE_CYCLOP]           = {STRONGHOLD, 7},    [CREATURE_CYCLOP_UNTAMED]       = {STRONGHOLD, 7},    [CREATURE_CYCLOP_BLOODEYED]   = {STRONGHOLD, 7},
    [CREATURE_WOLF]             = {NEUTRAL, 3},       [CREATURE_MUMMY]                = {NEUTRAL, 3},       [CREATURE_MANTICORE]          = {NEUTRAL, 5},
    [CREATURE_BLACK_KNIGHT]     = {NEUTRAL, 6},       [CREATURE_DEATH_KNIGHT]         = {NEUTRAL, 6},
    [CREATURE_SNOW_APE]         = {NEUTRAL, 7},       [CREATURE_PHOENIX]              = {NEUTRAL, 7},
    [CREATURE_AIR_ELEMENTAL]    = {NEUTRAL, 4},       [CREATURE_EARTH_ELEMENTAL]      = {NEUTRAL, 4},
    [CREATURE_WATER_ELEMENTAL]  = {NEUTRAL, 4},       [CREATURE_FIRE_ELEMENTAL]       = {NEUTRAL, 4},
}

CREATURES_BY_FACTION = {
    [HAVEN] = {
        [1] = {CREATURE_PEASANT, CREATURE_MILITIAMAN, CREATURE_LANDLORD},
        [2] = {CREATURE_ARCHER, CREATURE_MARKSMAN, CREATURE_LONGBOWMAN},
        [3] = {CREATURE_FOOTMAN, CREATURE_SWORDSMAN, CREATURE_VINDICATOR},
        [4] = {CREATURE_GRIFFIN, CREATURE_ROYAL_GRIFFIN, CREATURE_BATTLE_GRIFFIN},
        [5] = {CREATURE_PRIEST, CREATURE_CLERIC, CREATURE_ZEALOT},
        [6] = {CREATURE_CAVALIER, CREATURE_PALADIN, CREATURE_CHAMPION},
        [7] = {CREATURE_ANGEL, CREATURE_ARCHANGEL, CREATURE_SERAPH},
    },
    [PRESERVE] = {
        [1] = {CREATURE_BLADE_JUGGLER, CREATURE_WAR_DANCER, CREATURE_BLADE_SINGER},
        [2] = {CREATURE_PIXIE, CREATURE_SPRITE, CREATURE_DRYAD},
        [3] = {CREATURE_WOOD_ELF, CREATURE_GRAND_ELF, CREATURE_SHARP_SHOOTER},
        [4] = {CREATURE_DRUID, CREATURE_DRUID_ELDER, CREATURE_HIGH_DRUID},
        [5] = {CREATURE_UNICORN, CREATURE_WAR_UNICORN, CREATURE_WHITE_UNICORN},
        [6] = {CREATURE_TREANT, CREATURE_TREANT_GUARDIAN, CREATURE_ANGER_TREANT},
        [7] = {CREATURE_GREEN_DRAGON, CREATURE_GOLD_DRAGON, CREATURE_RAINBOW_DRAGON},
    },
    [ACADEMY] = {
        [1] = {CREATURE_GREMLIN, CREATURE_MASTER_GREMLIN, CREATURE_GREMLIN_SABOTEUR},
        [2] = {CREATURE_STONE_GARGOYLE, CREATURE_OBSIDIAN_GARGOYLE, CREATURE_MARBLE_GARGOYLE},
        [3] = {CREATURE_IRON_GOLEM, CREATURE_STEEL_GOLEM, CREATURE_OBSIDIAN_GOLEM},
        [4] = {CREATURE_MAGI, CREATURE_ARCH_MAGI, CREATURE_COMBAT_MAGE},
        [5] = {CREATURE_GENIE, CREATURE_MASTER_GENIE, CREATURE_DJINN_VIZIER},
        [6] = {CREATURE_RAKSHASA, CREATURE_RAKSHASA_RUKH, CREATURE_RAKSHASA_KSHATRI},
        [7] = {CREATURE_GIANT, CREATURE_TITAN, CREATURE_STORM_LORD},
    },
    [FORTRESS] = {
        [1] = {CREATURE_DEFENDER, CREATURE_STOUT_DEFENDER, CREATURE_STONE_DEFENDER},
        [2] = {CREATURE_AXE_FIGHTER, CREATURE_AXE_THROWER, CREATURE_HARPOONER},
        [3] = {CREATURE_BROWLER, CREATURE_BERSERKER, CREATURE_BATTLE_RAGER},
        [4] = {CREATURE_BEAR_RIDER, CREATURE_BLACKBEAR_RIDER, CREATURE_WHITE_BEAR_RIDER},
        [5] = {CREATURE_RUNE_MAGE, CREATURE_FLAME_MAGE, CREATURE_FLAME_KEEPER},
        [6] = {CREATURE_THANE, CREATURE_WARLORD, CREATURE_THUNDER_THANE},
        [7] = {CREATURE_FIRE_DRAGON, CREATURE_MAGMA_DRAGON, CREATURE_LAVA_DRAGON},
    },
    [NECROPOLIS] = {
        [1] = {CREATURE_SKELETON, CREATURE_SKELETON_ARCHER, CREATURE_SKELETON_WARRIOR},
        [2] = {CREATURE_WALKING_DEAD, CREATURE_ZOMBIE, CREATURE_DISEASE_ZOMBIE},
        [3] = {CREATURE_MANES, CREATURE_GHOST, CREATURE_POLTERGEIST},
        [4] = {CREATURE_VAMPIRE, CREATURE_VAMPIRE_LORD, CREATURE_NOSFERATU},
        [5] = {CREATURE_LICH, CREATURE_DEMILICH, CREATURE_LICH_MASTER},
        [6] = {CREATURE_BONE_DRAGON, CREATURE_SHADOW_DRAGON, CREATURE_HORROR_DRAGON},
        [7] = {CREATURE_WIGHT, CREATURE_WRAITH, CREATURE_BANSHEE},
    },
    [INFERNO] = {
        [1] = {CREATURE_FAMILIAR, CREATURE_IMP, CREATURE_QUASIT},
        [2] = {CREATURE_DEMON, CREATURE_HORNED_DEMON, CREATURE_HORNED_LEAPER},
        [3] = {CREATURE_HELL_HOUND, CREATURE_CERBERI, CREATURE_FIREBREATHER_HOUND},
        [4] = {CREATURE_SUCCUBUS, CREATURE_INFERNAL_SUCCUBUS, CREATURE_SUCCUBUS_SEDUCER},
        [5] = {CREATURE_NIGHTMARE, CREATURE_FRIGHTFUL_NIGHTMARE, CREATURE_HELLMARE},
        [6] = {CREATURE_PIT_FIEND, CREATURE_BALOR, CREATURE_PIT_SPAWN},
        [7] = {CREATURE_DEVIL, CREATURE_ARCHDEVIL, CREATURE_ARCH_DEMON},
    },
    [DUNGEON] = {
        [1] = {CREATURE_SCOUT, CREATURE_ASSASSIN, CREATURE_STALKER},
        [2] = {CREATURE_WITCH, CREATURE_BLOOD_WITCH, CREATURE_BLOOD_WITCH_2},
        [3] = {CREATURE_MINOTAUR, CREATURE_MINOTAUR_KING, CREATURE_MINOTAUR_CAPTAIN},
        [4] = {CREATURE_RIDER, CREATURE_RAVAGER, CREATURE_BLACK_RIDER},
        [5] = {CREATURE_MATRON, CREATURE_MATRIARCH, CREATURE_SHADOW_MISTRESS},
        [6] = {CREATURE_HYDRA, CREATURE_CHAOS_HYDRA, CREATURE_ACIDIC_HYDRA},
        [7] = {CREATURE_DEEP_DRAGON, CREATURE_BLACK_DRAGON, CREATURE_RED_DRAGON},
    },
    [STRONGHOLD] = {
        [1] = {CREATURE_GOBLIN, CREATURE_GOBLIN_TRAPPER, CREATURE_GOBLIN_DEFILER},
        [2] = {CREATURE_SHAMAN, CREATURE_SHAMAN_WITCH, CREATURE_SHAMAN_HAG},
        [3] = {CREATURE_ORC_WARRIOR, CREATURE_ORC_SLAYER, CREATURE_ORC_WARMONGER},
        [4] = {CREATURE_CENTAUR, CREATURE_CENTAUR_NOMAD, CREATURE_CENTAUR_MARADEUR},
        [5] = {CREATURE_ORCCHIEF_BUTCHER, CREATURE_ORCCHIEF_EXECUTIONER, CREATURE_ORCCHIEF_CHIEFTAIN},
        [6] = {CREATURE_WYVERN, CREATURE_WYVERN_POISONOUS, CREATURE_WYVERN_PAOKAI},
        [7] = {CREATURE_CYCLOP, CREATURE_CYCLOP_UNTAMED, CREATURE_CYCLOP_BLOODEYED},
    },
}


--------------------------------------------------------------------------------------------------------------------------------------------
-- ARTIFACT SETS

ARTFSET_NONE = 0
ARTFSET_HAVEN_4PC = 1
ARTFSET_HAVEN_4PCX = 2
ARTFSET_HAVEN_6PC = 3
ARTFSET_HAVEN_6PCX = 4
ARTFSET_SYLVAN_4PC = 5
ARTFSET_SYLVAN_4PCX = 6
ARTFSET_SYLVAN_6PC = 7
ARTFSET_SYLVAN_6PCX = 8
ARTFSET_ACADEMY_4PC = 9
ARTFSET_ACADEMY_4PCX = 10
ARTFSET_ACADEMY_6PC = 11
ARTFSET_ACADEMY_6PCX = 12
ARTFSET_DWARVEN_4PC = 13
ARTFSET_DWARVEN_4PCX = 14
ARTFSET_DWARVEN_6PC = 15
ARTFSET_DWARVEN_6PCX = 16
ARTFSET_NECRO_4PC = 17
ARTFSET_NECRO_4PCX = 18
ARTFSET_NECRO_6PC = 19
ARTFSET_NECRO_6PCX = 20
ARTFSET_INFERNO_4PC = 21
ARTFSET_INFERNO_4PCX = 22
ARTFSET_INFERNO_6PC = 23
ARTFSET_INFERNO_6PCX = 24
ARTFSET_DUNGEON_4PC = 25
ARTFSET_DUNGEON_4PCX = 26
ARTFSET_DUNGEON_6PC = 27
ARTFSET_DUNGEON_6PCX = 28
ARTFSET_ORCS_4PC = 29
ARTFSET_ORCS_4PCX = 30
ARTFSET_ORCS_6PC = 31
ARTFSET_ORCS_6PCX = 32
ARTFSET_DRAGON_4PC = 33
ARTFSET_DRAGON_6PC = 34
ARTFSET_DRAGON_8PC = 35
ARTFSET_ENLIGHTEN_4PC = 36
ARTFSET_FROST_5PC = 37
ARTFSET_GENJI_4PC = 38
ARTFSET_ELDENA_3PC = 39
ARTFSET_WAR_4PC = 40
ARTFSET_VIZIR_5PC = 41
ARTFSET_SPIRIT_5PC = 42
ARTFSET_WARMAGE_5PC = 43
ARTFSET_BANDIT_5PC = 44
ARTFSET_BESTIAL_5PC = 45
ARTFSET_SAINT_4PC = 46
ARTFSET_SAINT_6PC = 47
ARTFSET_ARCHANGEL_5PC = 48
ARTFSET_SAILOR_3PC = 49
ARTFSET_MOON_4PC = 50
ARTFSET_HUNTER_4PC = 51

--------------------------------------------------------------------------------------------------------------------------------------------
-- SPELL TYPES

SPELL_SCHOOL_ANY = 0
SPELL_SCHOOL_LIGHT = 1
SPELL_SCHOOL_DARK = 2
SPELL_SCHOOL_NATURAL = 3
SPELL_SCHOOL_DESTRUCT = 4

--------------------------------------------------------------------------------------------------------------------------------------------
-- SPELL TABLES

SPELLS_BY_TIER = {
    [1] = {SPELL_BLESS, SPELL_CURSE, SPELL_LAND_MINE, SPELL_MAGIC_ARROW},
    [2] = {SPELL_HASTE, SPELL_STONESKIN, SPELL_SLOW, SPELL_PLAGUE, SPELL_WASP_SWARM, SPELL_ARCANE_CRYSTAL, SPELL_LIGHTNING_BOLT, SPELL_ICE_BOLT},
    [3] = {SPELL_BLOODLUST, SPELL_DEFLECT_ARROWS, SPELL_DISPEL, SPELL_WEAKNESS, SPELL_DISRUPTING_RAY, SPELL_SORROW, SPELL_FORGETFULNESS, SPELL_REGENERATION, SPELL_SUMMON_ELEMENTALS, SPELL_STONE_SPIKES, SPELL_FIREBALL, SPELL_FROST_RING},
    [4] = {SPELL_BLADE_BARRIER, SPELL_DIVINE_VENGEANCE, SPELL_BLIND, SPELL_TELEPORT, SPELL_ANIMATE_DEAD, SPELL_VAMPIRISM, SPELL_ANTI_MAGIC, SPELL_EARTHQUAKE, SPELL_SUMMON_HIVE, SPELL_MAGIC_FIST, SPELL_CHAIN_LIGHTNING, SPELL_FIREWALL},
    [5] = {SPELL_HOLY_WORD, SPELL_CELESTIAL_SHIELD, SPELL_RESURRECT, SPELL_UNHOLY_WORD, SPELL_BERSERK, SPELL_PHANTOM, SPELL_METEOR_SHOWER, SPELL_HYPNOTIZE, SPELL_CONJURE_PHOENIX, SPELL_DEEP_FREEZE, SPELL_IMPLOSION, SPELL_ARMAGEDDON},
}

SPELLS_BY_SCHOOL = {
    [SPELL_SCHOOL_LIGHT]    = {SPELL_BLESS, SPELL_HASTE, SPELL_STONESKIN, SPELL_BLOODLUST, SPELL_DEFLECT_ARROWS, SPELL_DISPEL, SPELL_BLADE_BARRIER, SPELL_DIVINE_VENGEANCE, SPELL_BLIND, SPELL_HOLY_WORD, SPELL_CELESTIAL_SHIELD, SPELL_RESURRECT},
    [SPELL_SCHOOL_DARK]     = {SPELL_CURSE, SPELL_SLOW, SPELL_PLAGUE, SPELL_WEAKNESS, SPELL_DISRUPTING_RAY, SPELL_SORROW, SPELL_TELEPORT, SPELL_ANIMATE_DEAD, SPELL_VAMPIRISM, SPELL_UNHOLY_WORD, SPELL_BERSERK, SPELL_PHANTOM},
    [SPELL_SCHOOL_NATURAL]  = {SPELL_LAND_MINE, SPELL_WASP_SWARM, SPELL_ARCANE_CRYSTAL, SPELL_FORGETFULNESS, SPELL_REGENERATION, SPELL_SUMMON_ELEMENTALS, SPELL_ANTI_MAGIC, SPELL_EARTHQUAKE, SPELL_SUMMON_HIVE, SPELL_METEOR_SHOWER, SPELL_CONJURE_PHOENIX, SPELL_HYPNOTIZE},
    [SPELL_SCHOOL_DESTRUCT] = {SPELL_MAGIC_ARROW, SPELL_LIGHTNING_BOLT, SPELL_ICE_BOLT, SPELL_STONE_SPIKES, SPELL_FIREBALL, SPELL_FROST_RING, SPELL_MAGIC_FIST, SPELL_CHAIN_LIGHTNING, SPELL_FIREWALL, SPELL_DEEP_FREEZE, SPELL_IMPLOSION, SPELL_ARMAGEDDON},
}

SOURCE_LOADED["game-data"] = 1