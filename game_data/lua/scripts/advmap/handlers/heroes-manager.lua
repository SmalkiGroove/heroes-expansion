
LEVEL_UP_HERO_CALLBACK = {}

for hero,_ in HEROES do
    LEVEL_UP_HERO_CALLBACK[hero] = "HeroLevelUp_"..hero
end

function BindHeroLevelUpTrigger(hero)
    Trigger(HERO_LEVELUP_TRIGGER, hero, LEVEL_UP_HERO_CALLBACK[hero])
end
function UnbindHeroLevelUpTrigger(hero)
    Trigger(HERO_LEVELUP_TRIGGER, hero, nil)
end


function HeroLevelUp(hero)
    local level = GetHeroLevel(hero)
    local player = GetObjectOwner(hero)
    log(DEBUG, "Hero "..hero.." leveled up to level "..level)
    Register(VarHeroLevel(hero), level)
    startThread(DoHeroSpeRoutine_LevelUp, player, hero, level)
    startThread(DoSkillsRoutine_LevelUp, player, hero, level)
    startThread(DoArtifactsRoutine_LevelUp, player, hero, level)
end


-- haven
function HeroLevelUp_Duncan() HeroLevelUp(H_DUNCAN) end
function HeroLevelUp_Christian() HeroLevelUp(H_VITTORIO) end
function HeroLevelUp_Maeve() HeroLevelUp(H_MAEVE) end
function HeroLevelUp_Orrin() HeroLevelUp(H_DOUGAL) end
function HeroLevelUp_Laszlo() HeroLevelUp(H_LASZLO) end
function HeroLevelUp_Sarge() HeroLevelUp(H_KLAUS) end
function HeroLevelUp_Axel() HeroLevelUp(H_FREYDA) end
function HeroLevelUp_Isabell() HeroLevelUp(H_ISABEL) end
function HeroLevelUp_GodricMP() HeroLevelUp(H_GODRIC) end
function HeroLevelUp_Nicolai() HeroLevelUp(H_NICOLAI) end
function HeroLevelUp_RedHeavenHero06() HeroLevelUp(H_GABRIELLE) end
function HeroLevelUp_Alaric() HeroLevelUp(H_ALARIC) end

-- sylvan
function HeroLevelUp_Linaas() HeroLevelUp(H_WYNGAAL) end
function HeroLevelUp_Kyrre() HeroLevelUp(H_KYRRE) end
function HeroLevelUp_Nadaur() HeroLevelUp(H_TALANAR) end
function HeroLevelUp_Jenova() HeroLevelUp(H_JENOVA) end
function HeroLevelUp_Heam() HeroLevelUp(H_FINDAN) end
function HeroLevelUp_Arniel() HeroLevelUp(H_IVOR) end
function HeroLevelUp_Diraya() HeroLevelUp(H_DIRAEL) end
function HeroLevelUp_Vinrael() HeroLevelUp(H_VINRAEL) end
function HeroLevelUp_Vaniel() HeroLevelUp(H_TIERU) end
function HeroLevelUp_Itil() HeroLevelUp(H_YLTHIN) end
function HeroLevelUp_Elleshar() HeroLevelUp(H_ELLESHAR) end
function HeroLevelUp_Melodia() HeroLevelUp(H_MELODIA) end

-- academy
function HeroLevelUp_Havez() HeroLevelUp(H_HAVEZ) end
function HeroLevelUp_Razzak() HeroLevelUp(H_RAZZAK) end
function HeroLevelUp_Davius() HeroLevelUp(H_DAVIUS) end
function HeroLevelUp_Astral() HeroLevelUp(H_NATHIR) end
function HeroLevelUp_Timerkhan() HeroLevelUp(H_THEODORUS) end
function HeroLevelUp_Tan() HeroLevelUp(H_GALIB) end
function HeroLevelUp_Nur() HeroLevelUp(H_NUR) end
function HeroLevelUp_Zehir() HeroLevelUp(H_ZEHIR) end
function HeroLevelUp_Cyrus() HeroLevelUp(H_CYRUS) end
function HeroLevelUp_Minasli() HeroLevelUp(H_MINASLI) end
function HeroLevelUp_Rissa() HeroLevelUp(H_RISSA) end
function HeroLevelUp_Maahir() HeroLevelUp(H_MAAHIR) end

-- fortress
function HeroLevelUp_Ingvar() HeroLevelUp(H_INGVAR) end
function HeroLevelUp_Skeggy() HeroLevelUp(H_KARLI) end
function HeroLevelUp_Rolf() HeroLevelUp(H_ROLF) end
function HeroLevelUp_Hangvul2() HeroLevelUp(H_HANGVUL) end
function HeroLevelUp_Tazar() HeroLevelUp(H_TAZAR) end
function HeroLevelUp_Wulfstan() HeroLevelUp(H_WULFSTAN) end
function HeroLevelUp_KingTolghar() HeroLevelUp(H_TOLGHAR) end
function HeroLevelUp_Egil() HeroLevelUp(H_ERLING) end
function HeroLevelUp_Vilma() HeroLevelUp(H_HEDWIG) end
function HeroLevelUp_Brand() HeroLevelUp(H_BRAND) end
function HeroLevelUp_Bersy() HeroLevelUp(H_EBBA) end
function HeroLevelUp_Una() HeroLevelUp(H_INGA) end

-- necropolis
function HeroLevelUp_Pelt() HeroLevelUp(H_VLADIMIR) end
function HeroLevelUp_Arantir() HeroLevelUp(H_ARANTIR) end
function HeroLevelUp_Straker() HeroLevelUp(H_ORSON) end
function HeroLevelUp_Tamika() HeroLevelUp(H_LUCRETIA) end
function HeroLevelUp_Xerxon() HeroLevelUp(H_XERXON) end
function HeroLevelUp_Gles() HeroLevelUp(H_KASPAR) end
function HeroLevelUp_Effig() HeroLevelUp(H_RAVEN) end
function HeroLevelUp_Archilus() HeroLevelUp(H_ARCHILUS) end
function HeroLevelUp_Thant() HeroLevelUp(H_THANT) end
function HeroLevelUp_Sandro() HeroLevelUp(H_SANDRO) end
function HeroLevelUp_OrnellaNecro() HeroLevelUp(H_ORNELLA) end
function HeroLevelUp_Nemor() HeroLevelUp(H_DEIRDRE) end

-- inferno
function HeroLevelUp_Grok() HeroLevelUp(H_GROK) end
function HeroLevelUp_Sheltem() HeroLevelUp(H_SHELTEM) end
function HeroLevelUp_Guarg() HeroLevelUp(H_GRAWL) end
function HeroLevelUp_Ash() HeroLevelUp(H_ASH) end
function HeroLevelUp_Nymus() HeroLevelUp(H_NYMUS) end
function HeroLevelUp_Malustar() HeroLevelUp(H_MALUSTAR) end
function HeroLevelUp_Agrael() HeroLevelUp(H_AGRAEL) end
function HeroLevelUp_Marder() HeroLevelUp(H_MARBAS) end
function HeroLevelUp_Orlando() HeroLevelUp(H_ORLANDO) end
function HeroLevelUp_Biara() HeroLevelUp(H_BIARA) end
function HeroLevelUp_Deleb() HeroLevelUp(H_DELEB) end
function HeroLevelUp_Sovereign2() HeroLevelUp(H_KHABELETH) end

-- dungeon
function HeroLevelUp_Ohtarig() HeroLevelUp(H_VAYSHAN) end
function HeroLevelUp_Urunir() HeroLevelUp(H_YRWANNA) end
function HeroLevelUp_Darkstorm() HeroLevelUp(H_DARKSTORM) end
function HeroLevelUp_Ferigl() HeroLevelUp(H_SORGAL) end
function HeroLevelUp_Sylsai() HeroLevelUp(H_SYLSAI) end
function HeroLevelUp_Raelag() HeroLevelUp(H_RAELAG) end
function HeroLevelUp_Inagost() HeroLevelUp(H_SINITAR) end
function HeroLevelUp_Ranleth() HeroLevelUp(H_RANLETH) end
function HeroLevelUp_Eruina() HeroLevelUp(H_ERUINA) end
function HeroLevelUp_Kelodin() HeroLevelUp(H_SHADYA) end
function HeroLevelUp_Dalom() HeroLevelUp(H_LETHOS) end
function HeroLevelUp_Sephinroth() HeroLevelUp(H_SEPHINROTH) end

-- stronghold
function HeroLevelUp_Hero1() HeroLevelUp(H_KRAGH) end
function HeroLevelUp_Gottai() HeroLevelUp(H_GOTAI) end
function HeroLevelUp_Hero9() HeroLevelUp(H_KILGHAN) end
function HeroLevelUp_Hero8() HeroLevelUp(H_TELSEK) end
function HeroLevelUp_Hero3() HeroLevelUp(H_GARUNA) end
function HeroLevelUp_Hero4() HeroLevelUp(H_GORSHAK) end
function HeroLevelUp_Hero6() HeroLevelUp(H_KARUKAT) end
function HeroLevelUp_Hero7() HeroLevelUp(H_HAGGASH) end
function HeroLevelUp_Mokka() HeroLevelUp(H_MUKHA) end
function HeroLevelUp_Hero2() HeroLevelUp(H_URGHAT) end
function HeroLevelUp_Zouleika() HeroLevelUp(H_ZOULEIKA) end
function HeroLevelUp_KujinMP() HeroLevelUp(H_KUJIN) end


function HeroLostBattle(player, hero, opponent)
    log(DEBUG, "$ HeroLostBattle "..hero)
    if opponent ~= nil then
        for a = 200,255 do
            if HasArtefact(opponent, a) then RemoveArtefact(opponent, a) end
        end
    end
end

function AIDailyBonus(player, hero)
    if IsAIPlayer(player) then
        log(DEBUG, "$ AIDailyBonus for "..hero)
        local amount = 125 * TURN * DIFFICULTY
        GiveExp(hero, amount)
    end
end

function AIWeeklyBonus(player, hero)
    if IsAIPlayer(player) then
        log(DEBUG, "$ AIWeeklyBonus for "..hero)
        local faction = HEROES[hero].faction
        local n = min(WEEKS,7)
        for i = 1,n do
            local amount = WEEKS * (8-i) * DIFFICULTY
            AddHeroCreatureType(player, hero, faction, i, amount, 1)
            sleep(1)
        end
    end
end

function AIRecruitBonus(player, hero)
    if IsAIPlayer(player) then
        log(DEBUG, "$ AIRecruitBonus for "..hero)
        if DIFFICULTY > 0 then
            ChangeHeroStat(hero, STAT_ATTACK, DIFFICULTY)
            ChangeHeroStat(hero, STAT_DEFENCE, DIFFICULTY)
            ChangeHeroStat(hero, STAT_KNOWLEDGE, DIFFICULTY)
            ChangeHeroStat(hero, STAT_SPELL_POWER, DIFFICULTY)
            GiveHeroRandomArtifact(player, hero, DIFFICULTY)
        end
    end
end

-- log(TRACE, "Loaded heroes-manager.lua")
ROUTINES_LOADED[18] = 1
