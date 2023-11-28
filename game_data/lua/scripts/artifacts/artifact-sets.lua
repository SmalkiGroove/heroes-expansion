

function SetHeroActiveSet(hero, pieces, set)
    local faction = GetHeroFactionID(hero)

    local activations = set[0]
    if set[faction] then activations = set[faction] end

    local artfset = 0
    local before = 0
    
    for n,v in activations do
        if pieces >= n then artfset = v end
        if contains(HERO_ACTIVE_ARTIFACT_SETS[hero], v) then before = v end
    end

    if before == artfset then
        print("Hero "..hero.." artifact set "..artfset.." has not changed")
    else
        print("Hero "..hero.." artifact set has changed from "..before.." to "..artfset)
        replace(HERO_ACTIVE_ARTIFACT_SETS[hero], before, artfset, nil)
        print("["..HERO_ACTIVE_ARTIFACT_SETS[hero][1]..","..HERO_ACTIVE_ARTIFACT_SETS[hero][2].."]")
    end
end

function UpdateArtifactSets(hero, previous, artifact)
    for set = 1,10 do
        if contains(ARTIFACT_SETS[set], previous) or contains(ARTIFACT_SETS[set], artifact) then
            local pieces = 0
            for _,a in ARTIFACT_SETS[set] do
                if HasArtefact(hero, a, 1) then
                    pieces = pieces + 1
                end
            end
            SetHeroActiveSet(hero, pieces, ARTIFACT_SETS_ACTIVATIONS[set])
        end
    end
end


HERO_ACTIVE_ARTIFACT_SETS = {
    -- haven
    [H_DUNCAN] = {0,0},
    [H_DOUGAL] = {0,0},
    [H_KLAUS] = {0,0},
    [H_IRINA] = {0,0},
    [H_ISABEL] = {0,0},
    [H_LASZLO] = {0,0},
    [H_NICOLAI] = {0,0},
    [H_GODRIC] = {0,0},
    [H_FREYDA] = {0,0},
    [H_RUTGER] = {0,0},
    [H_MAEVE] = {0,0},
    [H_ELLAINE] = {0,0},
    [H_ALARIC] = {0,0},
    [H_GABRIELLE] = {0,0},
    [H_ORLANDO] = {0,0},
    [H_MARKAL] = {0,0},
    -- preserve
    [H_WYNGAAL] = {0,0},
    [H_ANWEN] = {0,0},
    [H_TALANAR] = {0,0},
    [H_OSSIR] = {0,0},
    [H_FINDAN] = {0,0},
    [H_JENOVA] = {0,0},
    [H_GILRAEN] = {0,0},
    [H_KYRRE] = {0,0},
    [H_IVOR] = {0,0},
    [H_MEPHALA] = {0,0},
    [H_ALARON] = {0,0},
    [H_DIRAEL] = {0,0},
    [H_VINRAEL] = {0,0},
    [H_YLTHIN] = {0,0},
    [H_TIERU] = {0,0},
    [H_GEM] = {0,0},
    [H_ELLESHAR] = {0,0},
    -- academy
    [H_HAVEZ] = {0,0},
    [H_MINASLI] = {0,0},
    [H_JOSEPHINE] = {0,0},
    [H_RAZZAK] = {0,0},
    [H_DAVIUS] = {0,0},
    [H_RISSA] = {0,0},
    [H_GURVILIN] = {0,0},
    [H_JHORA] = {0,0},
    [H_CYRUS] = {0,0},
    [H_FAIZ] = {0,0},
    [H_MAAHIR] = {0,0},
    [H_NATHIR] = {0,0},
    [H_NUR] = {0,0},
    [H_GALIB] = {0,0},
    [H_ZEHIR] = {0,0},
    [H_THEODORUS] = {0,0},
    [H_EMILIA] = {0,0},
    -- fortress
    [H_INGVAR] = {0,0},
    [H_ROLF] = {0,0},
    [H_WULFSTAN] = {0,0},
    [H_TAZAR] = {0,0},
    [H_MAXIMUS] = {0,0},
    [H_KARLI] = {0,0},
    [H_HEDWIG] = {0,0},
    [H_TOLGHAR] = {0,0},
    [H_EBBA] = {0,0},
    [H_ULAND] = {0,0},
    [H_HAEGEIR] = {0,0},
    [H_HELMAR] = {0,0},
    [H_BRAND] = {0,0},
    [H_ERLING] = {0,0},
    [H_HANGVUL] = {0,0},
    [H_BART] = {0,0},
    [H_INGA] = {0,0},
    -- necropolis
    [H_KASPAR] = {0,0},
    [H_VLADIMIR] = {0,0},
    [H_ORSON] = {0,0},
    [H_ORNELLA2] = {0,0},
    [H_LUCRETIA] = {0,0},
    [H_XERXON] = {0,0},
    [H_DEIRDRE] = {0,0},
    [H_NAADIR] = {0,0},
    [H_AISLINN] = {0,0},
    [H_GIOVANNI] = {0,0},
    [H_ARCHILUS] = {0,0},
    [H_ZOLTAN] = {0,0},
    [H_RAVEN] = {0,0},
    [H_ARANTIR] = {0,0},
    [H_THANT] = {0,0},
    [H_SANDRO] = {0,0},
    [H_VIDOMINA] = {0,0},
    -- inferno
    [H_GRAWL] = {0,0},
    [H_NEBIROS] = {0,0},
    [H_MARBAS] = {0,0},
    [H_HARKENRAZ] = {0,0},
    [H_CALH] = {0,0},
    [H_SHELTEM] = {0,0},
    [H_ALASTOR] = {0,0},
    [H_GROK] = {0,0},
    [H_NYMUS] = {0,0},
    [H_JEZEBETH] = {0,0},
    [H_MALUSTAR] = {0,0},
    [H_AGRAEL] = {0,0},
    [H_BIARA] = {0,0},
    [H_KHABELETH] = {0,0},
    [H_ZYDAR] = {0,0},
    [H_DELEB] = {0,0},
    [H_CALID] = {0,0},
    -- dungeon
    [H_SORGAL] = {0,0},
    [H_KYTHRA] = {0,0},
    [H_AGBETH] = {0,0},
    [H_RANLETH] = {0,0},
    [H_DARKSTORM] = {0,0},
    [H_YRWANNA] = {0,0},
    [H_VAYSHAN] = {0,0},
    [H_THRALSAI] = {0,0},
    [H_LETHOS] = {0,0},
    [H_ERUINA] = {0,0},
    [H_SYLSAI] = {0,0},
    [H_SINITAR] = {0,0},
    [H_SHADYA] = {0,0},
    [H_RAELAG] = {0,0},
    [H_YLAYA] = {0,0},
    [H_SEPHINROTH] = {0,0},
    [H_KASTORE] = {0,0},
    -- stronghold
    [H_TELSEK] = {0,0},
    [H_GORSHAK] = {0,0},
    [H_GOTAI] = {0,0},
    [H_AZAR] = {0,0},
    [H_MATEWA] = {0,0},
    [H_KUNYAK] = {0,0},
    [H_KRAGH] = {0,0},
    [H_KILGHAN] = {0,0},
    [H_CRAGHACK] = {0,0},
    [H_KRAAL] = {0,0},
    [H_SHAKKARUKAT] = {0,0},
    [H_KUJIN] = {0,0},
    [H_SHIVA] = {0,0},
    [H_HAGGASH] = {0,0},
    [H_MUKHA] = {0,0},
    [H_URGHAT] = {0,0},
    [H_GARUNA] = {0,0},
    [H_ZOULEIKA] = {0,0},
    [H_ERIKA] = {0,0},
}


-- print("Loaded artifact sets script")
ROUTINES_LOADED[x_artifacts_sets] = 1
