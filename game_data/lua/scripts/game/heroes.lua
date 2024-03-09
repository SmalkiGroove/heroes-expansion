

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


-- heroes data
HEROES = {
    [H_DUNCAN]    = {faction=HAVEN},        [H_WYNGAAL]  = {faction=PRESERVE},     [H_HAVEZ]     = {faction=ACADEMY},      [H_INGVAR]    = {faction=FORTRESS},
    [H_VITTORIO]  = {faction=HAVEN},        [H_KYRRE]    = {faction=PRESERVE},     [H_RAZZAK]    = {faction=ACADEMY},      [H_KARLI]     = {faction=FORTRESS},
    [H_MAEVE]     = {faction=HAVEN},        [H_TALANAR]  = {faction=PRESERVE},     [H_DAVIUS]    = {faction=ACADEMY},      [H_ROLF]      = {faction=FORTRESS},
    [H_DOUGAL]    = {faction=HAVEN},        [H_JENOVA]   = {faction=PRESERVE},     [H_NATHIR]    = {faction=ACADEMY},      [H_HANGVUL]   = {faction=FORTRESS},
    [H_LASZLO]    = {faction=HAVEN},        [H_FINDAN]   = {faction=PRESERVE},     [H_THEODORUS] = {faction=ACADEMY},      [H_TAZAR]     = {faction=FORTRESS},
    [H_KLAUS]     = {faction=HAVEN},        [H_IVOR]     = {faction=PRESERVE},     [H_GALIB]     = {faction=ACADEMY},      [H_WULFSTAN]  = {faction=FORTRESS},
    [H_FREYDA]    = {faction=HAVEN},        [H_DIRAEL]   = {faction=PRESERVE},     [H_NUR]       = {faction=ACADEMY},      [H_TOLGHAR]   = {faction=FORTRESS},
    [H_ISABEL]    = {faction=HAVEN},        [H_VINRAEL]  = {faction=PRESERVE},     [H_ZEHIR]     = {faction=ACADEMY},      [H_ERLING]    = {faction=FORTRESS},
    [H_GODRIC]    = {faction=HAVEN},        [H_TIERU]    = {faction=PRESERVE},     [H_CYRUS]     = {faction=ACADEMY},      [H_HEDWIG]    = {faction=FORTRESS},
    [H_NICOLAI]   = {faction=HAVEN},        [H_YLTHIN]   = {faction=PRESERVE},     [H_MINASLI]   = {faction=ACADEMY},      [H_BRAND]     = {faction=FORTRESS},
    [H_GABRIELLE] = {faction=HAVEN},        [H_ELLESHAR] = {faction=PRESERVE},     [H_RISSA]     = {faction=ACADEMY},      [H_EBBA]      = {faction=FORTRESS},
    [H_ALARIC]    = {faction=HAVEN},        [H_MELODIA]  = {faction=PRESERVE},     [H_MAAHIR]    = {faction=ACADEMY},      [H_INGA]      = {faction=FORTRESS},
    
    [H_VLADIMIR] = {faction=NECROPOLIS},    [H_GROK]      = {faction=INFERNO},     [H_VAYSHAN]    = {faction=DUNGEON},     [H_KRAGH]    = {faction=STRONGHOLD},
    [H_ARANTIR]  = {faction=NECROPOLIS},    [H_SHELTEM]   = {faction=INFERNO},     [H_YRWANNA]    = {faction=DUNGEON},     [H_GOTAI]    = {faction=STRONGHOLD},
    [H_ORSON]    = {faction=NECROPOLIS},    [H_GRAWL]     = {faction=INFERNO},     [H_DARKSTORM]  = {faction=DUNGEON},     [H_KILGHAN]  = {faction=STRONGHOLD},
    [H_LUCRETIA] = {faction=NECROPOLIS},    [H_ASH]       = {faction=INFERNO},     [H_SORGAL]     = {faction=DUNGEON},     [H_TELSEK]   = {faction=STRONGHOLD},
    [H_XERXON]   = {faction=NECROPOLIS},    [H_NYMUS]     = {faction=INFERNO},     [H_SYLSAI]     = {faction=DUNGEON},     [H_GARUNA]   = {faction=STRONGHOLD},
    [H_KASPAR]   = {faction=NECROPOLIS},    [H_MALUSTAR]  = {faction=INFERNO},     [H_RAELAG]     = {faction=DUNGEON},     [H_GORSHAK]  = {faction=STRONGHOLD},
    [H_RAVEN]    = {faction=NECROPOLIS},    [H_AGRAEL]    = {faction=INFERNO},     [H_SINITAR]    = {faction=DUNGEON},     [H_KARUKAT]  = {faction=STRONGHOLD},
    [H_ARCHILUS] = {faction=NECROPOLIS},    [H_MARBAS]    = {faction=INFERNO},     [H_RANLETH]    = {faction=DUNGEON},     [H_HAGGASH]  = {faction=STRONGHOLD},
    [H_THANT]    = {faction=NECROPOLIS},    [H_ORLANDO]   = {faction=INFERNO},     [H_ERUINA]     = {faction=DUNGEON},     [H_MUKHA]    = {faction=STRONGHOLD},
    [H_SANDRO]   = {faction=NECROPOLIS},    [H_BIARA]     = {faction=INFERNO},     [H_SHADYA]     = {faction=DUNGEON},     [H_URGHAT]   = {faction=STRONGHOLD},
    [H_ORNELLA]  = {faction=NECROPOLIS},    [H_DELEB]     = {faction=INFERNO},     [H_LETHOS]     = {faction=DUNGEON},     [H_ZOULEIKA] = {faction=STRONGHOLD},
    [H_DEIRDRE]  = {faction=NECROPOLIS},    [H_KHABELETH] = {faction=INFERNO},     [H_SEPHINROTH] = {faction=DUNGEON},     [H_KUJIN]    = {faction=STRONGHOLD},
}


-- print("Loaded heroes.lua")
ROUTINES_LOADED[5] = 1
