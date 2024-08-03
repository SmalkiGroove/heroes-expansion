

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
    [H_DUNCAN]    = {faction=HAVEN,owner=nil},      [H_WYNGAAL]  = {faction=PRESERVE,owner=nil},  [H_HAVEZ]     = {faction=ACADEMY,owner=nil},   [H_INGVAR]    = {faction=FORTRESS,owner=nil},
    [H_VITTORIO]  = {faction=HAVEN,owner=nil},      [H_KYRRE]    = {faction=PRESERVE,owner=nil},  [H_RAZZAK]    = {faction=ACADEMY,owner=nil},   [H_KARLI]     = {faction=FORTRESS,owner=nil},
    [H_MAEVE]     = {faction=HAVEN,owner=nil},      [H_TALANAR]  = {faction=PRESERVE,owner=nil},  [H_DAVIUS]    = {faction=ACADEMY,owner=nil},   [H_ROLF]      = {faction=FORTRESS,owner=nil},
    [H_DOUGAL]    = {faction=HAVEN,owner=nil},      [H_JENOVA]   = {faction=PRESERVE,owner=nil},  [H_NATHIR]    = {faction=ACADEMY,owner=nil},   [H_HANGVUL]   = {faction=FORTRESS,owner=nil},
    [H_LASZLO]    = {faction=HAVEN,owner=nil},      [H_FINDAN]   = {faction=PRESERVE,owner=nil},  [H_THEODORUS] = {faction=ACADEMY,owner=nil},   [H_TAZAR]     = {faction=FORTRESS,owner=nil},
    [H_KLAUS]     = {faction=HAVEN,owner=nil},      [H_IVOR]     = {faction=PRESERVE,owner=nil},  [H_GALIB]     = {faction=ACADEMY,owner=nil},   [H_WULFSTAN]  = {faction=FORTRESS,owner=nil},
    [H_FREYDA]    = {faction=HAVEN,owner=nil},      [H_DIRAEL]   = {faction=PRESERVE,owner=nil},  [H_NUR]       = {faction=ACADEMY,owner=nil},   [H_TOLGHAR]   = {faction=FORTRESS,owner=nil},
    [H_ISABEL]    = {faction=HAVEN,owner=nil},      [H_VINRAEL]  = {faction=PRESERVE,owner=nil},  [H_ZEHIR]     = {faction=ACADEMY,owner=nil},   [H_ERLING]    = {faction=FORTRESS,owner=nil},
    [H_GODRIC]    = {faction=HAVEN,owner=nil},      [H_TIERU]    = {faction=PRESERVE,owner=nil},  [H_CYRUS]     = {faction=ACADEMY,owner=nil},   [H_HEDWIG]    = {faction=FORTRESS,owner=nil},
    [H_NICOLAI]   = {faction=HAVEN,owner=nil},      [H_YLTHIN]   = {faction=PRESERVE,owner=nil},  [H_MINASLI]   = {faction=ACADEMY,owner=nil},   [H_BRAND]     = {faction=FORTRESS,owner=nil},
    [H_GABRIELLE] = {faction=HAVEN,owner=nil},      [H_ELLESHAR] = {faction=PRESERVE,owner=nil},  [H_RISSA]     = {faction=ACADEMY,owner=nil},   [H_EBBA]      = {faction=FORTRESS,owner=nil},
    [H_ALARIC]    = {faction=HAVEN,owner=nil},      [H_MELODIA]  = {faction=PRESERVE,owner=nil},  [H_MAAHIR]    = {faction=ACADEMY,owner=nil},   [H_INGA]      = {faction=FORTRESS,owner=nil},
    
    [H_VLADIMIR] = {faction=NECROPOLIS,owner=nil},  [H_GROK]      = {faction=INFERNO,owner=nil},  [H_VAYSHAN]    = {faction=DUNGEON,owner=nil},  [H_KRAGH]    = {faction=STRONGHOLD,owner=nil},
    [H_ARANTIR]  = {faction=NECROPOLIS,owner=nil},  [H_SHELTEM]   = {faction=INFERNO,owner=nil},  [H_YRWANNA]    = {faction=DUNGEON,owner=nil},  [H_GOTAI]    = {faction=STRONGHOLD,owner=nil},
    [H_ORSON]    = {faction=NECROPOLIS,owner=nil},  [H_GRAWL]     = {faction=INFERNO,owner=nil},  [H_DARKSTORM]  = {faction=DUNGEON,owner=nil},  [H_KILGHAN]  = {faction=STRONGHOLD,owner=nil},
    [H_LUCRETIA] = {faction=NECROPOLIS,owner=nil},  [H_ASH]       = {faction=INFERNO,owner=nil},  [H_SORGAL]     = {faction=DUNGEON,owner=nil},  [H_TELSEK]   = {faction=STRONGHOLD,owner=nil},
    [H_XERXON]   = {faction=NECROPOLIS,owner=nil},  [H_NYMUS]     = {faction=INFERNO,owner=nil},  [H_SYLSAI]     = {faction=DUNGEON,owner=nil},  [H_GARUNA]   = {faction=STRONGHOLD,owner=nil},
    [H_KASPAR]   = {faction=NECROPOLIS,owner=nil},  [H_MALUSTAR]  = {faction=INFERNO,owner=nil},  [H_RAELAG]     = {faction=DUNGEON,owner=nil},  [H_GORSHAK]  = {faction=STRONGHOLD,owner=nil},
    [H_RAVEN]    = {faction=NECROPOLIS,owner=nil},  [H_AGRAEL]    = {faction=INFERNO,owner=nil},  [H_SINITAR]    = {faction=DUNGEON,owner=nil},  [H_KARUKAT]  = {faction=STRONGHOLD,owner=nil},
    [H_ARCHILUS] = {faction=NECROPOLIS,owner=nil},  [H_MARBAS]    = {faction=INFERNO,owner=nil},  [H_RANLETH]    = {faction=DUNGEON,owner=nil},  [H_HAGGASH]  = {faction=STRONGHOLD,owner=nil},
    [H_THANT]    = {faction=NECROPOLIS,owner=nil},  [H_ORLANDO]   = {faction=INFERNO,owner=nil},  [H_ERUINA]     = {faction=DUNGEON,owner=nil},  [H_MUKHA]    = {faction=STRONGHOLD,owner=nil},
    [H_SANDRO]   = {faction=NECROPOLIS,owner=nil},  [H_BIARA]     = {faction=INFERNO,owner=nil},  [H_SHADYA]     = {faction=DUNGEON,owner=nil},  [H_URGHAT]   = {faction=STRONGHOLD,owner=nil},
    [H_ORNELLA]  = {faction=NECROPOLIS,owner=nil},  [H_DELEB]     = {faction=INFERNO,owner=nil},  [H_LETHOS]     = {faction=DUNGEON,owner=nil},  [H_ZOULEIKA] = {faction=STRONGHOLD,owner=nil},
    [H_DEIRDRE]  = {faction=NECROPOLIS,owner=nil},  [H_KHABELETH] = {faction=INFERNO,owner=nil},  [H_SEPHINROTH] = {faction=DUNGEON,owner=nil},  [H_KUJIN]    = {faction=STRONGHOLD,owner=nil},
}


-- log("Loaded heroes.lua")
ROUTINES_LOADED[5] = 1
