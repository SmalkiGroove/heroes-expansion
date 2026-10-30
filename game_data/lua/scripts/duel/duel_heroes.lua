

function DuelAddTownRecruits(player, creature, nb)
    local new = DUEL_TOWN_RECRUITS[player][creature] + nb
    SetObjectDwellingCreatures(DuelPlayerTown(player), creature, new)
    DUEL_TOWN_RECRUITS[player][creature] = new
end

-- Leadership and Diplomacy bonus, in % of weekly growth per hero level
function DuelHeroLeadershipBonus(hero)
    if hero == H_DUNCAN then return 6 end
    if hero == H_ARANTIR then return 9 end
    return 0
end


---------------------------------------------------------------------------------------------------------------------------------------------
-- SETUP STAGE

DUEL_HERO_DOLMEN_BONUS = {
    [H_NICOLAI] = 3,
    [H_KYRRE] = 3 + DUEL_MODE,
    [H_MAAHIR] = 2 + DUEL_MODE,
    [H_ERUINA] = 1,
    [H_NYMUS] = 1,
    [H_ORLANDO] = 2 + DUEL_MODE,
    [H_GORSHAK] = 1,
}

function DuelDolmenBonus(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelDolmenBonus")
    log.debug("DuelDolmenBonus", player, hero)
    local n = DUEL_HERO_DOLMEN_BONUS[hero]
    DUEL_DOLMEN_LEVELS[player] = DUEL_DOLMEN_LEVELS[player] - n
    Popup(player, {"/Text/Duel/Hero/Dolmen.txt"; arg=n})
end

function DuelYlthinSetup(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelYlthinSetup")
    log.debug("DuelYlthinSetup", player, hero)
    GiveArtefact(hero, ARTIFACT_UNICORN_HORN_BOW, 0)
    Popup(player, "/Text/Duel/Hero/YlthinSetup.txt")
end

function DuelWulfstanSetup(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelWulfstanSetup")
    log.debug("DuelWulfstanSetup", player, hero)
    local nb = DUEL_CREATURE_GROWTH[FORTRESS][CREATURE_DEFENDER]
    AddHeroCreatureType(player, hero, FORTRESS, 1, nb, 1)
    GiveHeroWarMachine(hero, WAR_MACHINE_BALLISTA)
    GiveHeroWarMachine(hero, WAR_MACHINE_FIRST_AID_TENT)
    GiveHeroWarMachine(hero, WAR_MACHINE_AMMO_CART)
    Popup(player, {"/Text/Duel/Hero/WulfstanSetup.txt"; arg=nb})
end

function DuelErlingSetup(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelErlingSetup")
    log.debug("DuelErlingSetup", player, hero)
    ChangeHeroStat(hero, STAT_SPELL_POWER, 4)
    Popup(player, {"/Text/Duel/Hero/ErlingSetup.txt"; arg=4})
end


---------------------------------------------------------------------------------------------------------------------------------------------
-- ADVENTURE STAGE

DUEL_HERO_EXTRA_DAYS = {
    [H_GABRIELLE] = 1,
    [H_ROLF] = 1,
    [H_VLADIMIR] = 2,
}

function DuelExtraAdventureDays(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelExtraAdventureDays")
    log.debug("DuelExtraAdventureDays", player, hero)
    local n = DUEL_HERO_EXTRA_DAYS[hero]
    DUEL_PLAYER_DATA.ADVENTURE_DAYS[player] = DUEL_PLAYER_DATA.ADVENTURE_DAYS[player] + n
    Popup(player, {"/Text/Duel/Hero/AdventureDays.txt"; arg1=n, arg2=DUEL_PLAYER_DATA.ADVENTURE_DAYS[player]})
end

function DuelMinasliDay(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelMinasliDay")
    log.debug("DuelMinasliDay", player, hero)
    AddHeroCreatures(hero, CREATURE_ARCANE_EAGLE, 1)
    Popup(player, {"/Text/Duel/Hero/MinasliDay.txt"; arg=1})
end

function DuelOrnellaFrostLord(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelOrnellaFrostLord")
    log.debug("DuelOrnellaFrostLord", player, hero)
    local factor = 1 + 0.25 * GetHeroLevel(hero)
    for a,p in Var_Ornella_FrostLordSet do
        if p > 0 then
            if (p * factor) > random(0,100) then
                GiveArtefact(hero, a)
                Var_Ornella_FrostLordSet[a] = 0
                Popup(player, {"/Text/Duel/Hero/Ornella.txt"; arg=ARTIFACT_NAME_FILE[a]})
                return
            end
        end
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
-- LEVEL UP

function DuelZouleikaPotion(player, hero, level)
    log.trace("/scripts/duel/duel_heroes.lua: DuelZouleikaPotion")
    log.debug("DuelZouleikaPotion", player, hero, level)
    local potions = {ARTIFACT_POTION_OF_ENLIGHTENMENT,ARTIFACT_POTION_OF_POWER,ARTIFACT_POTION_OF_VISION,ARTIFACT_POTION_OF_SKILL,}
    local potion = potions[random(1,4)]
    GiveArtefact(hero, ARTIFACT_FILLER_POCKET) sleep()
    GiveArtefact(hero, potion) sleep()
    RemoveArtefact(hero, ARTIFACT_FILLER_POCKET)
    Popup(player, {"/Text/Duel/Hero/Zouleika.txt"; arg=ARTIFACT_NAME_FILE[potion]})
end

function DuelEllesharLevelUp(player, hero, level)
    log.trace("/scripts/duel/duel_heroes.lua: DuelEllesharLevelUp")
    log.debug("DuelEllesharLevelUp", player, hero, level)
    if mod(level, 3) == 0 then
        local upgradable, maxed = {}, {}
        local n, known = 0, 0
        for sk = 9,12 do
            local m = GetHeroSkillMastery(hero, sk)
            if m > 0 then known = known + 1 end
            if m == 1 or m == 2 then insert(upgradable, sk) n = n + 1 end
            if m >= 3 then insert(maxed, sk) end
        end
        local upgrade, exp, stats = 0, 0, 0
        if n > 0 then
            GiveHeroSkill(hero, upgradable[random(1,n)])
            upgrade = 1
        elseif known == 0 then
            exp = 1000
            ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
        end
        local skill_to_attribute = {[9]=STAT_SPELL_POWER, [10]=STAT_ATTACK, [11]=STAT_DEFENCE, [12]=STAT_KNOWLEDGE}
        for _,sk in maxed do
            ChangeHeroStat(hero, skill_to_attribute[sk], 1)
            stats = stats + 1
        end
        Popup(player, {"/Text/Duel/Hero/Elleshar.txt"; arg1=upgrade, arg2=exp, arg3=stats})
    end
end

function DuelBersyRunicStats(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelBersyRunicStats")
    log.debug("DuelBersyRunicStats", player, hero)
    local n = 0
    for rune,tier in RUNIC_SPELLS do
        if KnowHeroSpell(hero, rune) and Var_Ebba_RunicSpells[rune] == 0 then
            ChangeHeroStat(hero, STAT_ATTACK, 1)
            ChangeHeroStat(hero, STAT_DEFENCE, 1)
            ChangeHeroStat(hero, STAT_SPELL_POWER, 1)
            ChangeHeroStat(hero, STAT_KNOWLEDGE, 1)
            TeachHeroRandomSpellTier(player, hero, SPELL_SCHOOL_ANY, tier)
            Var_Ebba_RunicSpells[rune] = 1
            n = n + 1
        end
    end
    return n
end

function DuelBersyLevelUp(player, hero, level)
    log.trace("/scripts/duel/duel_heroes.lua: DuelBersyLevelUp")
    log.debug("DuelBersyLevelUp", player, hero, level)
    local learnt = 0
    if mod(level, 4) == 0 then
        local runes, n = {}, 0
        for rune,_ in RUNIC_SPELLS do
            if not KnowHeroSpell(hero, rune) then insert(runes, rune) n = n + 1 end
        end
        if n > 0 then
            TeachHeroSpell(hero, runes[random(1,n)])
            learnt = 1
        end
    end
    local count = DuelBersyRunicStats(player, hero)
    if learnt > 0 or count > 0 then
        Popup(player, {"/Text/Duel/Hero/BersyLevelUp.txt"; arg1=learnt, arg2=count})
    end
end

function DuelArchilusLevelUp(player, hero, level)
    log.trace("/scripts/duel/duel_heroes.lua: DuelArchilusLevelUp")
    log.debug("DuelArchilusLevelUp", player, hero, level)
    local town = DuelPlayerTown(player)
    local before = GetObjectCreatures(town, CREATURE_BONE_DRAGON) + GetObjectCreatures(town, CREATURE_HORROR_DRAGON)
    Routine_DragonTombstone(player, town) sleep()
    local after = GetObjectCreatures(town, CREATURE_BONE_DRAGON) + GetObjectCreatures(town, CREATURE_HORROR_DRAGON)
    if after > before then
        Popup(player, {"/Text/Duel/Hero/Archilus.txt"; arg=after-before})
    end
end

function DuelRaelagLevelUp(player, hero, level)
    log.trace("/scripts/duel/duel_heroes.lua: DuelRaelagLevelUp")
    log.debug("DuelRaelagLevelUp", player, hero, level)
    if random(1,100) <= 10 + level then
        local pieces, n = {}, 0
        for a,data in ARTIFACTS_DATA do
            if data.set == ARTIFACT_SET_DRAGON and not HasArtefact(hero, a, 0) then insert(pieces, a) n = n + 1 end
        end
        if n > 0 then
            local a = pieces[random(1,n)]
            GiveArtefact(hero, a)
            Popup(player, {"/Text/Duel/Hero/RaelagLevelUp.txt"; arg=ARTIFACT_NAME_FILE[a]})
        end
    end
end

function DuelYrwannaLevelUp(player, hero, level)
    log.trace("/scripts/duel/duel_heroes.lua: DuelYrwannaLevelUp")
    log.debug("DuelYrwannaLevelUp", player, hero, level)
    if mod(level, 2) == 0 then
        GiveArtefact(hero, ARTIFACT_BLOOD_CRYSTAL)
        Popup(player, {"/Text/Duel/Hero/YrwannaLevelUp.txt"; arg=GetHeroArtifactsCount(hero, ARTIFACT_BLOOD_CRYSTAL)})
    end
end

function DuelLucretiaLevelUp(player, hero, level)
    log.trace("/scripts/duel/duel_heroes.lua: DuelLucretiaLevelUp")
    log.debug("DuelLucretiaLevelUp", player, hero, level)
    if level >= 15 and not HasHeroSkill(hero, SKILL_DARK_MAGIC) then
        GiveHeroSkill(hero, SKILL_DARK_MAGIC)
        Popup(player, {"/Text/Duel/Hero/Lucretia.txt"; arg=level})
    end
end

function DuelOrnellaLevelUp(player, hero, level)
    DuelOrnellaFrostLord(player, hero)
end


---------------------------------------------------------------------------------------------------------------------------------------------
-- STAGING STAGE
-- HAVEN

function DuelDuncan(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelDuncan")
    log.debug("DuelDuncan", player, hero)
    local gold = 250 * GetHeroLevel(hero)
    GiveResource(player, GOLD, gold)
    Popup(player, {"/Text/Duel/Hero/Gold.txt"; arg=gold})
end

function DuelNicolai(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelNicolai")
    log.debug("DuelNicolai", player, hero)
    local gold = 250 * GetHeroLevel(hero)
    GiveResource(player, GOLD, gold)
    Popup(player, {"/Text/Duel/Hero/Gold.txt"; arg=gold})
end

function DuelMaeve(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelMaeve")
    log.debug("DuelMaeve", player, hero)
    local gold = 500 * GetHeroLevel(hero)
    local nb = 20 * DUEL_ADVENTURE_DAYS
    GiveResource(player, GOLD, gold)
    DuelAddTownRecruits(player, CREATURE_PEASANT, nb)
    Popup(player, {"/Text/Duel/Hero/Maeve.txt"; arg1=gold, arg2=nb})
end

function DuelAlaric(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelAlaric")
    log.debug("DuelAlaric", player, hero)
    local nb = 3 * GetHeroLevel(hero)
    AddHeroCreatureType(player, hero, HAVEN, 5, nb, 1)
    Popup(player, {"/Text/Duel/Hero/Alaric.txt"; arg=nb})
end

-- PRESERVE

function DuelIvor(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelIvor")
    log.debug("DuelIvor", player, hero)
    local nb = 10 * GetHeroLevel(hero)
    AddHeroCreatures(hero, CREATURE_WOLF, nb)
    Popup(player, {"/Text/Duel/Hero/Ivor.txt"; arg=nb})
end

function DuelFindan(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelFindan")
    log.debug("DuelFindan", player, hero)
    local nb = round(0.1 * DUEL_CREATURE_GROWTH[PRESERVE][CREATURE_WOOD_ELF] * GetHeroLevel(hero))
    DuelAddTownRecruits(player, CREATURE_WOOD_ELF, nb)
    ChangeHeroStat(hero, STAT_ATTACK, 1)
    ChangeHeroStat(hero, STAT_KNOWLEDGE, 1)
    Popup(player, {"/Text/Duel/Hero/Findan.txt"; arg1=nb, arg2=1})
end

function DuelTieru(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelTieru")
    log.debug("DuelTieru", player, hero)
    local nb = GetHeroLevel(hero)
    AddHeroCreatureType(player, hero, PRESERVE, 4, nb, 1)
    Popup(player, {"/Text/Duel/Hero/Tieru.txt"; arg=nb})
end

function DuelYlthin(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelYlthin")
    log.debug("DuelYlthin", player, hero)
    local nb = DUEL_TOWN_RECRUITS[player][CREATURE_UNICORN]
    if nb > 0 then
        DuelAddTownRecruits(player, CREATURE_UNICORN, -nb)
        AddHeroCreatureType(player, hero, PRESERVE, 5, nb, 1)
        Popup(player, {"/Text/Duel/Hero/Ylthin.txt"; arg=nb})
    end
end

-- ACADEMY

function DuelHavez(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelHavez")
    log.debug("DuelHavez", player, hero)
    local nb = 6 * GetHeroLevel(hero)
    AddHeroCreatureType(player, hero, ACADEMY, 1, nb, 1)
    Popup(player, {"/Text/Duel/Hero/Havez.txt"; arg=nb})
end

function DuelRazzak(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelRazzak")
    log.debug("DuelRazzak", player, hero)
    local nb = 5 * GetHeroLevel(hero)
    AddHeroCreatureType(player, hero, ACADEMY, 3, nb, 1)
    GiveResource(player, ORE, nb)
    Popup(player, {"/Text/Duel/Hero/Razzak.txt"; arg=nb})
end

function DuelDavius(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelDavius")
    log.debug("DuelDavius", player, hero)
    local nb = 10 + GetHeroLevel(hero)
    AddHeroCreatureType(player, hero, ACADEMY, 6, nb, 1)
    Popup(player, {"/Text/Duel/Hero/Davius.txt"; arg=nb})
end

function DuelNathir(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelNathir")
    log.debug("DuelNathir", player, hero)
    local sulfur = 2 * GetHeroLevel(hero)
    local exp = trunc(0.1 * DUEL_PLAYER_DATA.TOTAL_EXP[player])
    GiveResource(player, SULFUR, sulfur)
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
    Popup(player, {"/Text/Duel/Hero/Nathir.txt"; arg1=sulfur, arg2=exp})
end

function DuelGalib(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelGalib")
    log.debug("DuelGalib", player, hero)
    local level = GetHeroLevel(hero)
    local nb = 2 * level
    local gold = 500 * level
    AddHeroCreatureType(player, hero, ACADEMY, 5, nb, 1)
    GiveResource(player, GOLD, gold)
    Popup(player, {"/Text/Duel/Hero/Galib.txt"; arg1=nb, arg2=gold})
end

function DuelCyrus(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelCyrus")
    log.debug("DuelCyrus", player, hero)
    local nb = 5 * DUEL_ADVENTURE_DAYS
    DuelAddTownRecruits(player, CREATURE_MAGI, nb)
    Popup(player, {"/Text/Duel/Hero/Cyrus.txt"; arg=nb})
end

function DuelMinasli(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelMinasli")
    log.debug("DuelMinasli", player, hero)
    local nb = GetHeroCreatures(hero, CREATURE_ARCANE_EAGLE)
    if nb > 0 then
        UpgradeHeroCreatures(player, hero, CREATURE_ARCANE_EAGLE, CREATURE_PHOENIX)
        Popup(player, {"/Text/Duel/Hero/Minasli.txt"; arg=nb})
    end
end

function DuelMaahir(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelMaahir")
    log.debug("DuelMaahir", player, hero)
    local amount = 3 * DUEL_ADVENTURE_DAYS
    ChangeHeroStat(hero, STAT_KNOWLEDGE, amount)
    Popup(player, {"/Text/Duel/Hero/Maahir.txt"; arg=amount})
end

-- FORTRESS

function DuelIngvar(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelIngvar")
    log.debug("DuelIngvar", player, hero)
    local nb = 12 * GetHeroLevel(hero)
    AddHeroCreatureType(player, hero, FORTRESS, 1, nb, 1)
    Popup(player, {"/Text/Duel/Hero/Ingvar.txt"; arg=nb})
end

function DuelRolf(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelRolf")
    log.debug("DuelRolf", player, hero)
    local nb = 3 * GetHeroLevel(hero)
    AddHeroCreatureType(player, hero, FORTRESS, 4, nb, 1)
    Popup(player, {"/Text/Duel/Hero/Rolf.txt"; arg=nb})
end

function DuelHangvul(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelHangvul")
    log.debug("DuelHangvul", player, hero)
    local gold = 500 * GetHeroLevel(hero)
    GiveResource(player, GOLD, gold)
    DuelAddTownRecruits(player, CREATURE_THANE, 30)
    Popup(player, {"/Text/Duel/Hero/Hangvul.txt"; arg1=gold, arg2=30})
end

function DuelBrand(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelBrand")
    log.debug("DuelBrand", player, hero)
    GiveArtefact(hero, ARTIFACT_BLAZING_SPELLBOOK)
    Popup(player, {"/Text/Duel/Hero/Brand.txt"; arg=ARTIFACT_NAME_FILE[ARTIFACT_BLAZING_SPELLBOOK]})
end

function DuelBersy(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelBersy")
    log.debug("DuelBersy", player, hero)
    local runes = DuelBersyRunicStats(player, hero)
    if runes > 0 then
        Popup(player, {"/Text/Duel/Hero/BersyLevelUp.txt"; arg1=0, arg2=runes})
    end
end

-- NECROPOLIS

function DuelArantir(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelArantir")
    log.debug("DuelArantir", player, hero)
    local gold = 250 * GetHeroLevel(hero)
    GiveResource(player, GOLD, gold)
    Popup(player, {"/Text/Duel/Hero/Gold.txt"; arg=gold})
end

function DuelOrson(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelOrson")
    log.debug("DuelOrson", player, hero)
    local nb = 9 * GetHeroLevel(hero)
    AddHeroCreatureType(player, hero, NECROPOLIS, 2, nb, 1)
    Popup(player, {"/Text/Duel/Hero/Orson.txt"; arg=nb})
end

function DuelXerxon(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelXerxon")
    log.debug("DuelXerxon", player, hero)
    local nb = trunc(0.75 * GetHeroLevel(hero))
    AddHeroCreatureType(player, hero, NECROPOLIS, 6, nb, 1)
    Popup(player, {"/Text/Duel/Hero/Xerxon.txt"; arg=nb})
end

function DuelRaven(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelRaven")
    log.debug("DuelRaven", player, hero)
    local result = {0,0,0}
    for tier = 1,3 do
        local creature = CREATURES_BY_FACTION[NECROPOLIS][tier][1]
        result[tier] = (3 + DUEL_MODE) * DUEL_CREATURE_GROWTH[NECROPOLIS][creature]
        DuelAddTownRecruits(player, creature, result[tier])
    end
    Popup(player, {"/Text/Duel/Hero/Raven.txt"; arg1=result[1], arg2=result[2], arg3=result[3]})
end

function DuelThant(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelThant")
    log.debug("DuelThant", player, hero)
    local nb = 8 * GetHeroLevel(hero)
    AddHeroCreatures(hero, CREATURE_MUMMY, nb)
    Popup(player, {"/Text/Duel/Hero/Thant.txt"; arg=nb})
end

-- INFERNO

function DuelGrawl(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelGrawl")
    log.debug("DuelGrawl", player, hero)
    local nb = 5 * GetHeroLevel(hero)
    AddHeroCreatureType(player, hero, INFERNO, 3, nb, 1)
    Popup(player, {"/Text/Duel/Hero/Grawl.txt"; arg=nb})
end

function DuelAgrael(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelAgrael")
    log.debug("DuelAgrael", player, hero)
    if not KnowHeroSpell(hero, SPELL_ARMAGEDDON) then
        TeachHeroSpell(hero, SPELL_ARMAGEDDON)
        Popup(player, {"/Text/Duel/Hero/Agrael.txt"; arg=0})
    end
end

function DuelOrlando(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelOrlando")
    log.debug("DuelOrlando", player, hero)
    local gold = 500 * GetHeroLevel(hero)
    GiveResource(player, GOLD, gold)
    for creature, growth in DUEL_CREATURE_GROWTH[INFERNO] do
        DuelAddTownRecruits(player, creature, growth)
    end
    Popup(player, {"/Text/Duel/Hero/Orlando.txt"; arg=gold})
end

function DuelKhabeleth(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelKhabeleth")
    log.debug("DuelKhabeleth", player, hero)
    local level = GetHeroLevel(hero)
    local result = {0,0,0,0,0,0,0}
    for tier = 1,7 do
        local creature = CREATURES_BY_FACTION[INFERNO][tier][1]
        local percent = 200 + 5 * level - 10 * tier
        local nb = round(0.01 * percent * DUEL_CREATURE_GROWTH[INFERNO][creature])
        AddHeroCreatureType(player, hero, INFERNO, tier, nb, 1)
        result[tier] = nb
    end
    Popup(player, {"/Text/Duel/Hero/Khabeleth.txt"; arg1=result[1], arg2=result[2], arg3=result[3], arg4=result[4], arg5=result[5], arg6=result[6], arg7=result[7]})
end

-- DUNGEON

function DuelVayshan(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelVayshan")
    log.debug("DuelVayshan", player, hero)
    local gold = 500 * GetHeroLevel(hero)
    GiveResource(player, GOLD, gold)
    Popup(player, {"/Text/Duel/Hero/Gold.txt"; arg=gold})
end

function DuelYrwanna(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelYrwanna")
    log.debug("DuelYrwanna", player, hero)
    local nb = GetHeroArtifactsCount(hero, ARTIFACT_BLOOD_CRYSTAL)
    if nb == 0 then return end
    for i = 1,nb do RemoveArtefact(hero, ARTIFACT_BLOOD_CRYSTAL) sleep() end
    local exp = 10000 * nb
    local witches = 10 * nb
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
    DuelAddTownRecruits(player, CREATURE_WITCH, witches)
    Popup(player, {"/Text/Duel/Hero/Yrwanna.txt"; arg1=nb, arg2=exp, arg3=witches})
end

function DuelSorgal(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelSorgal")
    log.debug("DuelSorgal", player, hero)
    local nb = 3 * GetHeroLevel(hero)
    AddHeroCreatureType(player, hero, DUNGEON, 4, nb, 1)
    Popup(player, {"/Text/Duel/Hero/Sorgal.txt"; arg=nb})
end

function DuelRaelag(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelRaelag")
    log.debug("DuelRaelag", player, hero)
    local pieces = GetArtifactSetItemsCount(hero, ARTIFACT_SET_DRAGON, 1)
    local nb = 0
    if pieces >= 8 then nb = 26
    elseif pieces >= 6 then nb = 16
    elseif pieces >= 4 then nb = 6
    end
    if nb > 0 then
        AddHeroCreatureType(player, hero, DUNGEON, 7, nb, 1)
        Popup(player, {"/Text/Duel/Hero/Raelag.txt"; arg1=pieces, arg2=nb})
    end
end

function DuelShadya(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelShadya")
    log.debug("DuelShadya", player, hero)
    local level = GetHeroLevel(hero)
    local nb1 = min(5 * level, DUEL_TOWN_RECRUITS[player][CREATURE_SCOUT])
    DuelAddTownRecruits(player, CREATURE_SCOUT, -nb1)
    DuelAddTownRecruits(player, CREATURE_WITCH, nb1)
    local nb2 = min(level, DUEL_TOWN_RECRUITS[player][CREATURE_RIDER])
    DuelAddTownRecruits(player, CREATURE_RIDER, -nb2)
    DuelAddTownRecruits(player, CREATURE_MATRON, nb2)
    Popup(player, {"/Text/Duel/Hero/Shadya.txt"; arg1=nb1, arg2=nb2})
end

function DuelLethos(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelLethos")
    log.debug("DuelLethos", player, hero)
    local nb = 3 * GetHeroLevel(hero)
    AddHeroCreatures(hero, CREATURE_MANTICORE, nb)
    Popup(player, {"/Text/Duel/Hero/Lethos.txt"; arg=nb})
end

-- STRONGHOLD

function DuelKragh(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelKragh")
    log.debug("DuelKragh", player, hero)
    local level = GetHeroLevel(hero)
    local result = {0,0,0,0,0,0}
    for tier = 1,6 do
        local creature = CREATURES_BY_FACTION[STRONGHOLD][tier][1]
        local nb = round(0.1 * DUEL_CREATURE_GROWTH[STRONGHOLD][creature] * level)
        AddHeroCreatureType(player, hero, STRONGHOLD, tier, nb, 1)
        result[tier] = nb
    end
    Popup(player, {"/Text/Duel/Hero/Kragh.txt"; arg1=result[1], arg2=result[2], arg3=result[3], arg4=result[4], arg5=result[5], arg6=result[6]})
end

function DuelKilghan(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelKilghan")
    log.debug("DuelKilghan", player, hero)
    local nb = 20 * GetHeroLevel(hero)
    AddHeroCreatureType(player, hero, STRONGHOLD, 1, nb, 1)
    Popup(player, {"/Text/Duel/Hero/Kilghan.txt"; arg=nb})
end

function DuelGaruna(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelGaruna")
    log.debug("DuelGaruna", player, hero)
    local nb = round(0.2 * DUEL_TOWN_RECRUITS[player][CREATURE_CENTAUR])
    DuelAddTownRecruits(player, CREATURE_CENTAUR, nb)
    Popup(player, {"/Text/Duel/Hero/Garuna.txt"; arg=nb})
end

function DuelGorshak(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelGorshak")
    log.debug("DuelGorshak", player, hero)
    local amount = trunc(0.25 * GetHeroLevel(hero))
    ChangeHeroStat(hero, STAT_ATTACK, amount)
    ChangeHeroStat(hero, STAT_DEFENCE, amount)
    Popup(player, {"/Text/Duel/Hero/Gorshak.txt"; arg=amount})
end

function DuelKarukat(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelKarukat")
    log.debug("DuelKarukat", player, hero)
    local nb = GetHeroLevel(hero) + DUEL_MODE * DUEL_CREATURE_GROWTH[STRONGHOLD][CREATURE_WYVERN]
    AddHeroCreatureType(player, hero, STRONGHOLD, 6, nb, 1)
    Popup(player, {"/Text/Duel/Hero/Karukat.txt"; arg=nb})
end

function DuelKujin(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelKujin")
    log.debug("DuelKujin", player, hero)
    local nb = (1 + DUEL_MODE) * DUEL_CREATURE_GROWTH[STRONGHOLD][CREATURE_SHAMAN]
    DuelAddTownRecruits(player, CREATURE_SHAMAN, nb)
    Popup(player, {"/Text/Duel/Hero/Kujin.txt"; arg=nb})
end


---------------------------------------------------------------------------------------------------------------------------------------------
-- CASTLE STAGE

function DuelDougalCastle(player, hero)
    log.trace("/scripts/duel/duel_heroes.lua: DuelDougalCastle")
    log.debug("DuelDougalCastle", player, hero)
    local nb = min(120, GetHeroCreatures(hero, CREATURE_PEASANT))
    if nb > 0 and Prompt(player, {"/Text/Duel/Hero/DougalAsk.txt"; arg=nb}) then
        RemoveHeroCreatures(hero, CREATURE_PEASANT, nb) sleep(1)
        AddHeroCreatures(hero, CREATURE_ARCHER, nb) sleep(1)
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------

DUEL_HERO_SETUP_EFFECTS = {
    [H_NICOLAI] = DuelDolmenBonus,
    [H_KYRRE] = DuelDolmenBonus,
    [H_YLTHIN] = DuelYlthinSetup,
    [H_MAAHIR] = DuelDolmenBonus,
    [H_WULFSTAN] = DuelWulfstanSetup,
    [H_ERLING] = DuelErlingSetup,
    [H_ERUINA] = DuelDolmenBonus,
    [H_NYMUS] = DuelDolmenBonus,
    [H_ORLANDO] = DuelDolmenBonus,
    [H_GORSHAK] = DuelDolmenBonus,
}

DUEL_HERO_ADVENTURE_EFFECTS = {
    [H_GABRIELLE] = DuelExtraAdventureDays,
    [H_ROLF] = DuelExtraAdventureDays,
    [H_VLADIMIR] = DuelExtraAdventureDays,
}

DUEL_HERO_ADVENTURE_DAY_EFFECTS = {
    [H_MINASLI] = DuelMinasliDay,
    [H_ORNELLA] = DuelOrnellaFrostLord,
}

DUEL_HERO_LEVELUP_EFFECTS = {
    [H_ELLESHAR] = DuelEllesharLevelUp,
    [H_EBBA] = DuelBersyLevelUp,
    [H_YRWANNA] = DuelYrwannaLevelUp,
    [H_RAELAG] = DuelRaelagLevelUp,
    [H_LUCRETIA] = DuelLucretiaLevelUp,
    [H_ARCHILUS] = DuelArchilusLevelUp,
    [H_ORNELLA] = DuelOrnellaLevelUp,
    [H_ZOULEIKA] = DuelZouleikaPotion,
}

DUEL_HERO_STAGING_EFFECTS = {
    -- haven
    [H_DUNCAN] = DuelDuncan,
    [H_NICOLAI] = DuelNicolai,
    [H_MAEVE] = DuelMaeve,
    [H_ALARIC] = DuelAlaric,
    -- preserve
    [H_IVOR] = DuelIvor,
    [H_FINDAN] = DuelFindan,
    [H_TIERU] = DuelTieru,
    [H_YLTHIN] = DuelYlthin,
    -- academy
    [H_HAVEZ] = DuelHavez,
    [H_RAZZAK] = DuelRazzak,
    [H_DAVIUS] = DuelDavius,
    [H_NATHIR] = DuelNathir,
    [H_GALIB] = DuelGalib,
    [H_CYRUS] = DuelCyrus,
    [H_MINASLI] = DuelMinasli,
    [H_MAAHIR] = DuelMaahir,
    -- fortress
    [H_INGVAR] = DuelIngvar,
    [H_ROLF] = DuelRolf,
    [H_HANGVUL] = DuelHangvul,
    [H_BRAND] = DuelBrand,
    [H_EBBA] = DuelBersy,
    -- necropolis
    [H_ARANTIR] = DuelArantir,
    [H_ORSON] = DuelOrson,
    [H_XERXON] = DuelXerxon,
    [H_RAVEN] = DuelRaven,
    [H_THANT] = DuelThant,
    -- inferno
    [H_GRAWL] = DuelGrawl,
    [H_AGRAEL] = DuelAgrael,
    [H_ORLANDO] = DuelOrlando,
    [H_KHABELETH] = DuelKhabeleth,
    -- dungeon
    [H_VAYSHAN] = DuelVayshan,
    [H_YRWANNA] = DuelYrwanna,
    [H_SORGAL] = DuelSorgal,
    [H_RAELAG] = DuelRaelag,
    [H_SHADYA] = DuelShadya,
    [H_LETHOS] = DuelLethos,
    -- stronghold
    [H_KRAGH] = DuelKragh,
    [H_KILGHAN] = DuelKilghan,
    [H_GARUNA] = DuelGaruna,
    [H_GORSHAK] = DuelGorshak,
    [H_KARUKAT] = DuelKarukat,
    [H_KUJIN] = DuelKujin,
}

DUEL_HERO_CASTLE_EFFECTS = {
    [H_DOUGAL] = DuelDougalCastle,
}

-- the duel potion pool replaces the regular one
LEVEL_UP_HERO_ROUTINES_HERO[H_ZOULEIKA] = nil
