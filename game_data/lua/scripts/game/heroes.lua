

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


SOURCE_LOADED["heroes-data"] = 1