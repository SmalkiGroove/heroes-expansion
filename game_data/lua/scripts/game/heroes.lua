

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
H_GABRIELLE = 'RedHeavenHero06'     -- griffins
H_ALARIC = 'Alaric'                 -- counterspell

-- sylvan
H_WYNGAAL = 'Linaas'                -- logistics
H_KYRRE = 'Kyrre'                   -- experience
H_TALANAR = 'Nadaur'                -- spite
H_JENOVA = 'Jenova'                 -- offender
H_FINDAN = 'Heam'                   -- hunters
H_IVOR = 'Arniel'                   -- wolves
H_DIRAEL = 'Diraya'                 -- wasps
H_VINRAEL = 'Vinrael'               -- haste
H_TIERU = 'Vaniel'                  -- druids
H_YLTHIN = 'Itil'                   -- unicorns
H_ELLESHAR = 'Elleshar'             -- magic
H_MELODIA = 'Melodia'               -- regeneration

-- academy
H_HAVEZ = 'Havez'                   -- gremlins
H_RAZZAK = 'Razzak'                 -- golems
H_DAVIUS = 'Davius'                 -- rakshasas
H_NATHIR = 'Astral'                 -- bombardier
H_THEODORUS = 'Timerkhan'           -- artificier
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
H_HEDWIG = 'Vilma'                  -- evasion def
H_BRAND = 'Brand'                   -- fireball
H_EBBA = 'Bersy'                    -- runes
H_INGA = 'Una'                      -- earthquake

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
H_SANDRO = 'Sandro'                 -- great lich
H_ORNELLA = 'OrnellaNecro'          -- frost mage
H_DEIRDRE = 'Nemor'                 -- banshee scream

-- inferno
H_GROK = 'Grok'                     -- logistics
H_SHELTEM = 'Sheltem'               -- bombardier
H_GRAWL = 'Guarg'                   -- hell hounds
H_ASH = 'Ash'                       -- offender
H_NYMUS = 'Nymus'                   -- gating
H_MALUSTAR = 'Malustar'             -- explosions
H_AGRAEL = 'Agrael'                 -- fireball
H_MARBAS = 'Marder'                 -- confusion
H_ORLANDO = 'Orlando'               -- conqueror
H_BIARA = 'Biara'                   -- succubus
H_DELEB = 'Deleb'                   -- fire traps
H_KHABELETH = 'Sovereign'           -- satrting gates

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
H_SEPHINROTH = 'Sephinroth'         -- elemental chain

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
H_URGHAT = 'Hero2'                  -- exhauster
H_ZOULEIKA = 'Zouleika'             -- healing tent
H_KUJIN = 'KujinMP'                 -- shamans


-- heroes data
HEROES = {
    [H_DUNCAN]    = {faction=HAVEN,owner=0},      [H_WYNGAAL]  = {faction=PRESERVE,owner=0},  [H_HAVEZ]     = {faction=ACADEMY,owner=0},   [H_INGVAR]    = {faction=FORTRESS,owner=0},
    [H_VITTORIO]  = {faction=HAVEN,owner=0},      [H_KYRRE]    = {faction=PRESERVE,owner=0},  [H_RAZZAK]    = {faction=ACADEMY,owner=0},   [H_KARLI]     = {faction=FORTRESS,owner=0},
    [H_MAEVE]     = {faction=HAVEN,owner=0},      [H_TALANAR]  = {faction=PRESERVE,owner=0},  [H_DAVIUS]    = {faction=ACADEMY,owner=0},   [H_ROLF]      = {faction=FORTRESS,owner=0},
    [H_DOUGAL]    = {faction=HAVEN,owner=0},      [H_JENOVA]   = {faction=PRESERVE,owner=0},  [H_NATHIR]    = {faction=ACADEMY,owner=0},   [H_HANGVUL]   = {faction=FORTRESS,owner=0},
    [H_LASZLO]    = {faction=HAVEN,owner=0},      [H_FINDAN]   = {faction=PRESERVE,owner=0},  [H_THEODORUS] = {faction=ACADEMY,owner=0},   [H_TAZAR]     = {faction=FORTRESS,owner=0},
    [H_KLAUS]     = {faction=HAVEN,owner=0},      [H_IVOR]     = {faction=PRESERVE,owner=0},  [H_GALIB]     = {faction=ACADEMY,owner=0},   [H_WULFSTAN]  = {faction=FORTRESS,owner=0},
    [H_FREYDA]    = {faction=HAVEN,owner=0},      [H_DIRAEL]   = {faction=PRESERVE,owner=0},  [H_NUR]       = {faction=ACADEMY,owner=0},   [H_TOLGHAR]   = {faction=FORTRESS,owner=0},
    [H_ISABEL]    = {faction=HAVEN,owner=0},      [H_VINRAEL]  = {faction=PRESERVE,owner=0},  [H_ZEHIR]     = {faction=ACADEMY,owner=0},   [H_ERLING]    = {faction=FORTRESS,owner=0},
    [H_GODRIC]    = {faction=HAVEN,owner=0},      [H_TIERU]    = {faction=PRESERVE,owner=0},  [H_CYRUS]     = {faction=ACADEMY,owner=0},   [H_HEDWIG]    = {faction=FORTRESS,owner=0},
    [H_NICOLAI]   = {faction=HAVEN,owner=0},      [H_YLTHIN]   = {faction=PRESERVE,owner=0},  [H_MINASLI]   = {faction=ACADEMY,owner=0},   [H_BRAND]     = {faction=FORTRESS,owner=0},
    [H_GABRIELLE] = {faction=HAVEN,owner=0},      [H_ELLESHAR] = {faction=PRESERVE,owner=0},  [H_RISSA]     = {faction=ACADEMY,owner=0},   [H_EBBA]      = {faction=FORTRESS,owner=0},
    [H_ALARIC]    = {faction=HAVEN,owner=0},      [H_MELODIA]  = {faction=PRESERVE,owner=0},  [H_MAAHIR]    = {faction=ACADEMY,owner=0},   [H_INGA]      = {faction=FORTRESS,owner=0},
    
    [H_VLADIMIR] = {faction=NECROPOLIS,owner=0},  [H_GROK]      = {faction=INFERNO,owner=0},  [H_VAYSHAN]    = {faction=DUNGEON,owner=0},  [H_KRAGH]    = {faction=STRONGHOLD,owner=0},
    [H_ARANTIR]  = {faction=NECROPOLIS,owner=0},  [H_SHELTEM]   = {faction=INFERNO,owner=0},  [H_YRWANNA]    = {faction=DUNGEON,owner=0},  [H_GOTAI]    = {faction=STRONGHOLD,owner=0},
    [H_ORSON]    = {faction=NECROPOLIS,owner=0},  [H_GRAWL]     = {faction=INFERNO,owner=0},  [H_DARKSTORM]  = {faction=DUNGEON,owner=0},  [H_KILGHAN]  = {faction=STRONGHOLD,owner=0},
    [H_LUCRETIA] = {faction=NECROPOLIS,owner=0},  [H_ASH]       = {faction=INFERNO,owner=0},  [H_SORGAL]     = {faction=DUNGEON,owner=0},  [H_TELSEK]   = {faction=STRONGHOLD,owner=0},
    [H_XERXON]   = {faction=NECROPOLIS,owner=0},  [H_NYMUS]     = {faction=INFERNO,owner=0},  [H_SYLSAI]     = {faction=DUNGEON,owner=0},  [H_GARUNA]   = {faction=STRONGHOLD,owner=0},
    [H_KASPAR]   = {faction=NECROPOLIS,owner=0},  [H_MALUSTAR]  = {faction=INFERNO,owner=0},  [H_RAELAG]     = {faction=DUNGEON,owner=0},  [H_GORSHAK]  = {faction=STRONGHOLD,owner=0},
    [H_RAVEN]    = {faction=NECROPOLIS,owner=0},  [H_AGRAEL]    = {faction=INFERNO,owner=0},  [H_SINITAR]    = {faction=DUNGEON,owner=0},  [H_KARUKAT]  = {faction=STRONGHOLD,owner=0},
    [H_ARCHILUS] = {faction=NECROPOLIS,owner=0},  [H_MARBAS]    = {faction=INFERNO,owner=0},  [H_RANLETH]    = {faction=DUNGEON,owner=0},  [H_HAGGASH]  = {faction=STRONGHOLD,owner=0},
    [H_THANT]    = {faction=NECROPOLIS,owner=0},  [H_ORLANDO]   = {faction=INFERNO,owner=0},  [H_ERUINA]     = {faction=DUNGEON,owner=0},  [H_MUKHA]    = {faction=STRONGHOLD,owner=0},
    [H_SANDRO]   = {faction=NECROPOLIS,owner=0},  [H_BIARA]     = {faction=INFERNO,owner=0},  [H_SHADYA]     = {faction=DUNGEON,owner=0},  [H_URGHAT]   = {faction=STRONGHOLD,owner=0},
    [H_ORNELLA]  = {faction=NECROPOLIS,owner=0},  [H_DELEB]     = {faction=INFERNO,owner=0},  [H_LETHOS]     = {faction=DUNGEON,owner=0},  [H_ZOULEIKA] = {faction=STRONGHOLD,owner=0},
    [H_DEIRDRE]  = {faction=NECROPOLIS,owner=0},  [H_KHABELETH] = {faction=INFERNO,owner=0},  [H_SEPHINROTH] = {faction=DUNGEON,owner=0},  [H_KUJIN]    = {faction=STRONGHOLD,owner=0},
}


-- log(TRACE, "Loaded heroes.lua")
ROUTINES_LOADED[5] = 1
