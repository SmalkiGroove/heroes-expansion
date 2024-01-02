
HEROSPE_LEVELUP_ROUTINES = {
	[0] = DoCommonRoutine_LevelUp,
	[1] = DoHavenRoutine_LevelUp,
	[2] = DoPreserveRoutine_LevelUp,
	[3] = DoInfernoRoutine_LevelUp,
	[4] = DoNecropolisRoutine_LevelUp,
	[5] = DoAcademyRoutine_LevelUp,
	[6] = DoDungeonRoutine_LevelUp,
	[7] = DoFortressRoutine_LevelUp,
	[8] = DoStrongholdRoutine_LevelUp,
}
SKILL_LEVELUP_ROUTINE = DoSkillsRoutine_LevelUp
ARTIFACT_LEVELUP_ROUTINE = DoArtifactsRoutine_LevelUp

LEVEL_UP_HERO_CALLBACK = {}

function HeroLevelUp(hero)
    -- print("Generic level up routine...")
    local player = GetObjectOwner(hero)
    local faction = GetHeroFactionID(hero)
    startThread(LEVELUP_ROUTINES[faction], player, hero)
    startThread(SKILL_LEVELUP_ROUTINE, player, hero)
    startThread(ARTIFACT_LEVELUP_ROUTINE, player, hero)
end

for i,hero in HEROES_ALL do
    LEVEL_UP_HERO_CALLBACK[hero] = "HeroLevelUp_"..hero
end

function BindHeroLevelUpTrigger(hero)
    Trigger(HERO_LEVELUP_TRIGGER, hero, LEVEL_UP_HERO_CALLBACK[hero])
end
function UnbindHeroLevelUpTrigger(hero)
    Trigger(HERO_LEVELUP_TRIGGER, hero, nil)
end


-- haven
function HeroLevelUp_Duncan() HeroLevelUp(H_DUNCAN) end
function HeroLevelUp_Orrin() HeroLevelUp(H_DOUGAL) end
function HeroLevelUp_Sarge() HeroLevelUp(H_KLAUS) end
function HeroLevelUp_Ving() HeroLevelUp(H_IRINA) end
function HeroLevelUp_Isabell() HeroLevelUp(H_ISABEL) end
function HeroLevelUp_Mardigo() HeroLevelUp(H_LASZLO) end
function HeroLevelUp_Nicolai() HeroLevelUp(H_NICOLAI) end
function HeroLevelUp_GodricMP() HeroLevelUp(H_GODRIC) end
function HeroLevelUp_Axel() HeroLevelUp(H_FREYDA) end
function HeroLevelUp_Brem() HeroLevelUp(H_RUTGER) end
function HeroLevelUp_Maeve() HeroLevelUp(H_MAEVE) end
function HeroLevelUp_Nathaniel() HeroLevelUp(H_ELLAINE) end
function HeroLevelUp_Alaric() HeroLevelUp(H_ALARIC) end
function HeroLevelUp_RedHeavenHero06() HeroLevelUp(H_GABRIELLE) end
function HeroLevelUp_Orlando() HeroLevelUp(H_ORLANDO) end
function HeroLevelUp_Markal() HeroLevelUp(H_MARKAL) end
function HeroLevelUp_Ornella() HeroLevelUp(H_ORNELLA) end
function HeroLevelUp_Jeddite() HeroLevelUp(H_JEDDITE) end
function HeroLevelUp_RedHeavenHero01() HeroLevelUp(H_ANDREAS) end
function HeroLevelUp_RedHeavenHero02() HeroLevelUp(H_LORENZO) end
function HeroLevelUp_RedHeavenHero03() HeroLevelUp(H_VALERIA) end
function HeroLevelUp_RedHeavenHero04() HeroLevelUp(H_BENEDIKT) end
function HeroLevelUp_RedHeavenHero05() HeroLevelUp(H_BERTRAND) end
-- sylvan
function HeroLevelUp_Linaas() HeroLevelUp(H_WYNGAAL) end
function HeroLevelUp_Metlirn() HeroLevelUp(H_ANWEN) end
function HeroLevelUp_Nadaur() HeroLevelUp(H_TALANAR) end
function HeroLevelUp_Ossir() HeroLevelUp(H_OSSIR) end
function HeroLevelUp_Heam() HeroLevelUp(H_FINDAN) end
function HeroLevelUp_Jenova() HeroLevelUp(H_JENOVA) end
function HeroLevelUp_Gillion() HeroLevelUp(H_GILRAEN) end
function HeroLevelUp_Kyrre() HeroLevelUp(H_KYRRE) end
function HeroLevelUp_Arniel() HeroLevelUp(H_IVOR) end
function HeroLevelUp_Mephala() HeroLevelUp(H_MEPHALA) end
function HeroLevelUp_Ildar() HeroLevelUp(H_ALARON) end
function HeroLevelUp_Diraya() HeroLevelUp(H_DIRAEL) end
function HeroLevelUp_Elleshar() HeroLevelUp(H_VINRAEL) end
function HeroLevelUp_Itil() HeroLevelUp(H_YLTHIN) end
function HeroLevelUp_Vaniel() HeroLevelUp(H_TIERU) end
function HeroLevelUp_Gem() HeroLevelUp(H_GEM) end
function HeroLevelUp_Vinrael() HeroLevelUp(H_ELLESHAR) end
function HeroLevelUp_Melodia() HeroLevelUp(H_MELODIA) end
-- academy
function HeroLevelUp_Havez() HeroLevelUp(H_HAVEZ) end
function HeroLevelUp_Minasli() HeroLevelUp(H_MINASLI) end
function HeroLevelUp_Josephine() HeroLevelUp(H_JOSEPHINE) end
function HeroLevelUp_Isher() HeroLevelUp(H_RAZZAK) end
function HeroLevelUp_Davius() HeroLevelUp(H_DAVIUS) end
function HeroLevelUp_Rissa() HeroLevelUp(H_RISSA) end
function HeroLevelUp_Gurvilin() HeroLevelUp(H_GURVILIN) end
function HeroLevelUp_Sufi() HeroLevelUp(H_JHORA) end
function HeroLevelUp_Cyrus() HeroLevelUp(H_CYRUS) end
function HeroLevelUp_Faiz() HeroLevelUp(H_FAIZ) end
function HeroLevelUp_Maahir() HeroLevelUp(H_MAAHIR) end
function HeroLevelUp_Nur() HeroLevelUp(H_NATHIR) end
function HeroLevelUp_Astral() HeroLevelUp(H_NUR) end
function HeroLevelUp_Tan() HeroLevelUp(H_GALIB) end
function HeroLevelUp_Zehir() HeroLevelUp(H_ZEHIR) end
function HeroLevelUp_Timerkhan() HeroLevelUp(H_THEODORUS) end
function HeroLevelUp_Emilia() HeroLevelUp(H_EMILIA) end
function HeroLevelUp_Razzak() HeroLevelUp(H_NARXES) end
-- fortress
function HeroLevelUp_Ingvar() HeroLevelUp(H_INGVAR) end
function HeroLevelUp_Rolf() HeroLevelUp(H_ROLF) end
function HeroLevelUp_Wulfstan() HeroLevelUp(H_WULFSTAN) end
function HeroLevelUp_Tazar() HeroLevelUp(H_TAZAR) end
function HeroLevelUp_Maximus() HeroLevelUp(H_MAXIMUS) end
function HeroLevelUp_Skeggy() HeroLevelUp(H_KARLI) end
function HeroLevelUp_Vilma() HeroLevelUp(H_HEDWIG) end
function HeroLevelUp_KingTolghar() HeroLevelUp(H_TOLGHAR) end
function HeroLevelUp_Bersy() HeroLevelUp(H_EBBA) end
function HeroLevelUp_Hangvul2() HeroLevelUp(H_ULAND) end
function HeroLevelUp_Ufretin() HeroLevelUp(H_HAEGEIR) end
function HeroLevelUp_Ottar() HeroLevelUp(H_HELMAR) end
function HeroLevelUp_Brand() HeroLevelUp(H_BRAND) end
function HeroLevelUp_Egil() HeroLevelUp(H_ERLING) end
function HeroLevelUp_Hangvul() HeroLevelUp(H_HANGVUL) end
function HeroLevelUp_Bart() HeroLevelUp(H_BART) end
function HeroLevelUp_Una() HeroLevelUp(H_INGA) end
function HeroLevelUp_Vegeyr() HeroLevelUp(H_VEGEYR) end
-- necropolis
function HeroLevelUp_Gles() HeroLevelUp(H_KASPAR) end
function HeroLevelUp_Pelt() HeroLevelUp(H_VLADIMIR) end
function HeroLevelUp_Straker() HeroLevelUp(H_ORSON) end
function HeroLevelUp_OrnellaNecro() HeroLevelUp(H_ORNELLA2) end
function HeroLevelUp_Tamika() HeroLevelUp(H_LUCRETIA) end
function HeroLevelUp_Xerxon() HeroLevelUp(H_XERXON) end
function HeroLevelUp_Nemor() HeroLevelUp(H_DEIRDRE) end
function HeroLevelUp_Muscip() HeroLevelUp(H_NAADIR) end
function HeroLevelUp_Aislinn() HeroLevelUp(H_AISLINN) end
function HeroLevelUp_Giovanni() HeroLevelUp(H_GIOVANNI) end
function HeroLevelUp_Archilus() HeroLevelUp(H_ARCHILUS) end
function HeroLevelUp_Aberrar() HeroLevelUp(H_ZOLTAN) end
function HeroLevelUp_Effig() HeroLevelUp(H_RAVEN) end
function HeroLevelUp_Arantir() HeroLevelUp(H_ARANTIR) end
function HeroLevelUp_Thant() HeroLevelUp(H_THANT) end
function HeroLevelUp_Sandro() HeroLevelUp(H_SANDRO) end
function HeroLevelUp_Vidomina() HeroLevelUp(H_VIDOMINA) end
function HeroLevelUp_Nimbus() HeroLevelUp(H_NIMBUS) end
-- inferno
function HeroLevelUp_Calid() HeroLevelUp(H_GRAWL) end
function HeroLevelUp_Jazaz() HeroLevelUp(H_NEBIROS) end
function HeroLevelUp_Marder() HeroLevelUp(H_MARBAS) end
function HeroLevelUp_Harkenraz() HeroLevelUp(H_HARKENRAZ) end
function HeroLevelUp_Calh() HeroLevelUp(H_CALH) end
function HeroLevelUp_Sheltem() HeroLevelUp(H_SHELTEM) end
function HeroLevelUp_Efion() HeroLevelUp(H_ALASTOR) end
function HeroLevelUp_Grok() HeroLevelUp(H_GROK) end
function HeroLevelUp_Nymus() HeroLevelUp(H_NYMUS) end
function HeroLevelUp_Oddrema() HeroLevelUp(H_JEZEBETH) end
function HeroLevelUp_Malustar() HeroLevelUp(H_MALUSTAR) end
function HeroLevelUp_Agrael() HeroLevelUp(H_AGRAEL) end
function HeroLevelUp_Biara() HeroLevelUp(H_BIARA) end
function HeroLevelUp_Sovereign() HeroLevelUp(H_KHABELETH) end
function HeroLevelUp_Zydar() HeroLevelUp(H_ZYDAR) end
function HeroLevelUp_Deleb() HeroLevelUp(H_DELEB) end
function HeroLevelUp_Calid2() HeroLevelUp(H_CALID) end
function HeroLevelUp_Ash() HeroLevelUp(H_ASH) end
-- dungeon
function HeroLevelUp_Ferigl() HeroLevelUp(H_SORGAL) end
function HeroLevelUp_Menel() HeroLevelUp(H_KYTHRA) end
function HeroLevelUp_Agbeth() HeroLevelUp(H_AGBETH) end
function HeroLevelUp_Ranleth() HeroLevelUp(H_RANLETH) end
function HeroLevelUp_Darkstorm() HeroLevelUp(H_DARKSTORM) end
function HeroLevelUp_Urunir() HeroLevelUp(H_YRWANNA) end
function HeroLevelUp_Ohtarig() HeroLevelUp(H_VAYSHAN) end
function HeroLevelUp_Thralsai() HeroLevelUp(H_THRALSAI) end
function HeroLevelUp_Dalom() HeroLevelUp(H_LETHOS) end
function HeroLevelUp_Eruina() HeroLevelUp(H_ERUINA) end
function HeroLevelUp_Sylsai() HeroLevelUp(H_SYLSAI) end
function HeroLevelUp_Inagost() HeroLevelUp(H_SINITAR) end
function HeroLevelUp_Kelodin() HeroLevelUp(H_SHADYA) end
function HeroLevelUp_Raelag() HeroLevelUp(H_RAELAG) end
function HeroLevelUp_Shadwyn() HeroLevelUp(H_YLAYA) end
function HeroLevelUp_Sephinroth() HeroLevelUp(H_SEPHINROTH) end
function HeroLevelUp_Kastore() HeroLevelUp(H_KASTORE) end
function HeroLevelUp_Almegir() HeroLevelUp(H_YRBETH) end
-- stronghold
function HeroLevelUp_Hero8() HeroLevelUp(H_TELSEK) end
function HeroLevelUp_Hero4() HeroLevelUp(H_GORSHAK) end
function HeroLevelUp_Gottai() HeroLevelUp(H_GOTAI) end
function HeroLevelUp_Azar() HeroLevelUp(H_AZAR) end
function HeroLevelUp_Matewa() HeroLevelUp(H_MATEWA) end
function HeroLevelUp_Kunyak() HeroLevelUp(H_KUNYAK) end
function HeroLevelUp_Hero1() HeroLevelUp(H_KRAGH) end
function HeroLevelUp_Hero9() HeroLevelUp(H_KILGHAN) end
function HeroLevelUp_Crag() HeroLevelUp(H_CRAGHACK) end
function HeroLevelUp_Kraal() HeroLevelUp(H_KRAAL) end
function HeroLevelUp_Hero6() HeroLevelUp(H_SHAKKARUKAT) end
function HeroLevelUp_KujinMP() HeroLevelUp(H_KUJIN) end
function HeroLevelUp_Shiva() HeroLevelUp(H_SHIVA) end
function HeroLevelUp_Hero7() HeroLevelUp(H_HAGGASH) end
function HeroLevelUp_Mokka() HeroLevelUp(H_MUKHA) end
function HeroLevelUp_Hero2() HeroLevelUp(H_URGHAT) end
function HeroLevelUp_Hero3() HeroLevelUp(H_GARUNA) end
function HeroLevelUp_Zouleika() HeroLevelUp(H_ZOULEIKA) end
function HeroLevelUp_Erika() HeroLevelUp(H_ERIKA) end
function HeroLevelUp_Quroq() HeroLevelUp(H_QUROQ) end


-- print("Loaded hero trigger advmap routines")
ROUTINES_LOADED[23] = 1
