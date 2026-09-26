

function DuelEndlessSackOfGold(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelEndlessSackOfGold")
    local value = 15000
    GiveResources(player, GOLD, value)
    Popup(player, {"/Text/Duel/Artifact/EndlessSackOfGold.txt"; arg=value})
end

function DuelEndlessPouchOfGold(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelEndlessPouchOfGold")
    local value = 5000
    GiveResources(player, GOLD, value)
    Popup(player, {"/Text/Duel/Artifact/EndlessPouchOfGold.txt"; arg=value})
end

function DuelCapeOfKings(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelCapeOfKings")
    local res = FACTION_RESOURCE[DUEL_FACTION[player]]
    local gov = GetHeroSkillMastery(hero, SKILL_GOVERNANCE)
    local gg = 500 * gov * DUEL_ADVENTURE_DAYS
    local gs = gov * DUEL_ADVENTURE_DAYS
    local gr = RESOURCE_NAME_FILE[res]
    GiveResources(player, GOLD, gg)
    GiveResources(player, res, gs)
    local ind, myt = 0, 0
    if HasHeroSkill(hero, PERK_INDUSTRY) then
        ind = 2 * DUEL_ADVENTURE_DAYS
        for r = 0,5 do GiveResources(player, r, ind) end
    end
    if HasHeroSkill(hero, PERK_MYTHOLOGY) then
        myt = 1000 * DUEL_ADVENTURE_DAYS
        GiveResources(player, GOLD, myt)
    end
    Popup(player, {"/Text/Duel/Artifact/CapeOfKings.txt"; days=DUEL_ADVENTURE_DAYS, gov=gov, gg=gg, gs=gs, gr=gr, ind=ind, myt=myt})
end

function DuelTurbanOfEnlightenment(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelTurbanOfEnlightenment")
    local exp = trunc(0.1 * DUEL_PLAYER_DATA.TOTAL_EXP[player])
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
    Popup(player, {"/Text/Duel/Artifact/TurbanOfEnlightenment.txt"; arg=exp})
end

function DuelScaleMailOfEnlightenment(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelScaleMailOfEnlightenment")
    local exp = trunc(0.2 * DUEL_PLAYER_DATA.TOTAL_EXP[player])
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
    Popup(player, {"/Text/Duel/Artifact/ScaleMailOfEnlightenment.txt"; arg=exp})
end

function DuelRobeOfTheMagister(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelRobeOfTheMagister")
    local exp = trunc(0.01 * GetHeroStat(hero, STAT_KNOWLEDGE) * DUEL_PLAYER_DATA.TOTAL_EXP[player])
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
    Popup(player, {"/Text/Duel/Artifact/RobeOfTheMagister.txt"; arg=exp})
end

function DuelRingOfTheUnrepentant(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelRingOfTheUnrepentant")
    local spells = {}
    local n = 0
    if not KnowHeroSpell(hero, SPELL_TELEPORT) then insert(spells, SPELL_TELEPORT) n = n + 1 end
    if not KnowHeroSpell(hero, SPELL_ANIMATE_DEAD) then insert(spells, SPELL_ANIMATE_DEAD) n = n + 1 end
    if not KnowHeroSpell(hero, SPELL_VAMPIRISM) then insert(spells, SPELL_VAMPIRISM) n = n + 1 end
    if n == 0 then
        for _,spell in SPELLS_BY_TIER[4] do
            if not KnowHeroSpell(hero, spell) then insert(spells, spell) n = n + 1 end
        end
    end
    if n == 0 then return
    else
        local s = spells[random(1,n)]
        TeachHeroSpell(hero, s)
        Popup(player, {"/Text/Duel/Artifact/RingOfTheUnrepentant.txt"; arg=s})
    end
end

function DuelAmuletOfNecromancy(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelAmuletOfNecromancy")
    local amount = round(0.1 * GetPlayerNecroEnergy(player))
    AddHeroCreatures(hero, CREATURE_SKELETON, amount)
    Popup(player, {"/Text/Duel/Artifact/AmuletOfNecromancy.txt"; arg=amount})
end

function DuelCrownOfLeader(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelCrownOfLeader")
    local arg1, arg2, arg3 = 0, 0, 0
    if HasHeroSkill(hero, PERK_ESTATES) then
        GiveResources(player, GOLD, 10000)
        arg1 = 10000
    end
    if HasHeroSkill(hero, PERK_DIPLOMACY) then
        for i = 1,5 do
            local creature = CREATURES_BY_FACTION[DUEL_FACTION[player]][i][1]
            local growth = DUEL_CREATURE_GROWTH[DUEL_FACTION[player]][creature]
            AddHeroCreatures(hero, creature, growth)
        end
        arg2 = 1
    end
    if HasHeroSkill(hero, PERK_RECRUITMENT) then
        local n = GetHeroSkillMastery(hero, SKILL_LOGISTICS)
        for i = 1,n do
            local creature = CREATURES_BY_FACTION[DUEL_FACTION[player]][i][1]
            local growth = DUEL_CREATURE_GROWTH[DUEL_FACTION[player]][creature]
            local new = DUEL_TOWN_RECRUITS[player][creature] + 2 * growth
            SetObjectDwellingCreatures(DuelPlayerTown(player), creature, new)
            DUEL_TOWN_RECRUITS[player][creature] = new
        end
        arg3 = n
    end
    Popup(player, {"/Text/Duel/Artifact/CrownOfLeader.txt"; arg1=arg1, arg2=arg2, arg3=arg3})
end

function DuelHornOfPlenty(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelHornOfPlenty")
    for res = 0,5 do GiveResources(player, res, 10) end
    Popup(player, {"/Text/Duel/Artifact/HornOfPlenty.txt"; arg=10})
end

function DuelSacredSeed(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelSacredSeed")
    GiveResources(player, WOOD, 30)
    Popup(player, {"/Text/Duel/Artifact/SacredSeed.txt"; arg=30})
end

function DuelFortunePickaxe(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelFortunePickaxe")
    GiveResources(player, ORE, 30)
    Popup(player, {"/Text/Duel/Artifact/FortunePickaxe.txt"; arg=30})
end

function DuelEldenasRedScarf(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelEldenasRedScarf")
    local creature = CREATURES_BY_FACTION[DUEL_FACTION[player]][1][1]
    AddHeroCreatures(hero, creature, 100)
    Popup(player, {"/Text/Duel/Artifact/EldenasRedScarf.txt"; arg=100})
end

function DuelEldenasCirclet(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelEldenasCirclet")
    local creature = CREATURES_BY_FACTION[DUEL_FACTION[player]][3][1]
    AddHeroCreatures(hero, creature, 60)
    Popup(player, {"/Text/Duel/Artifact/EldenasCirclet.txt"; arg=60})
end

function DuelEldenasRedCoat(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelEldenasRedCoat")
    local creature = CREATURES_BY_FACTION[DUEL_FACTION[player]][2][1]
    AddHeroCreatures(hero, creature, 80)
    Popup(player, {"/Text/Duel/Artifact/EldenasRedCoat.txt"; arg=80})
end

function DuelFortuneBandOfTheSaint(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelFortuneBandOfTheSaint")
    local amount = trunc(0.0625 * GetHeroLevel(hero))
    ChangeHeroStat(hero, STAT_LUCK, amount)
    Popup(player, {"/Text/Duel/Artifact/FortuneBandOfTheSaint.txt"; arg=amount})
end

function DuelSentinelsHelm(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelSentinelsHelm")
    ChangeHeroStat(hero, STAT_ATTACK, 2)
    ChangeHeroStat(hero, STAT_DEFENCE, 2)
    ChangeHeroStat(hero, STAT_MORALE, 2)
    Popup(player, {"/Text/Duel/Artifact/SentinelsHelm.txt"; arg=2})
end

function DuelSentinelsBoots(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelSentinelsBoots")
    GiveResources(player, GOLD, 5000)
    ChangeHeroStat(hero, STAT_MORALE, 2)
    Popup(player, {"/Text/Duel/Artifact/SentinelsBoots.txt"; arg=2})
end

function DuelVizirsCap(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelVizirsCap")
    local n = 0
    local d1 = Dwellings_T1[DUEL_FACTION[player]]
    local d2 = Dwellings_T2[DUEL_FACTION[player]]
    local d3 = Dwellings_T3[DUEL_FACTION[player]]
    for _,obj in GetObjectNamesByType(d1) do
        if GetObjectOwner(obj) == player then n = n + 5000 end
    end
    for _,obj in GetObjectNamesByType(d2) do
        if GetObjectOwner(obj) == player then n = n + 5000 end
    end
    for _,obj in GetObjectNamesByType(d3) do
        if GetObjectOwner(obj) == player then n = n + 5000 end
    end
    if n == 0 then return end
    GiveResources(player, GOLD, n)
    Popup(player, {"/Text/Duel/Artifact/VizirsCap.txt"; arg=n})
end

function DuelVizirsScimitar(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelVizirsScimitar")
    for i = 1,2 do
        local creature = CREATURES_BY_FACTION[DUEL_FACTION[player]][i][1]
        local new = DUEL_TOWN_RECRUITS[player][creature] + 100
        SetObjectDwellingCreatures(DuelPlayerTown(player), creature, new)
        DUEL_TOWN_RECRUITS[player][creature] = new
    end
    Popup(player, {"/Text/Duel/Artifact/VizirsScimitar.txt"; arg=100})
end

function DuelMagistersSandals(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelMagistersSandals")
    ChangeHeroStat(hero, STAT_KNOWLEDGE, 3)
    Popup(player, {"/Text/Duel/Artifact/MagistersSandals.txt"; arg=3})
end

function DuelDeathKnightBoots(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelDeathKnightBoots")
    local exp = trunc(0.15 * DUEL_PLAYER_DATA.TOTAL_EXP[player])
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
    Popup(player, {"/Text/Duel/Artifact/DeathKnightBoots.txt"; arg=exp})
end

function DuelPalaceShoes(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelPalaceShoes")
    Routine_ArtifactPalaceShoes(player, hero, nil)
    Popup(player, {"/Text/Duel/Artifact/PalaceShoes.txt"; arg=0})
end

function DuelHelmOfTheWarmage(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelHelmOfTheWarmage")
    local n, n4, n5, s4, s5 = 0, 0, 0, {}, {}
    for _,spell in SPELLS_BY_TIER[4] do
        if not KnowHeroSpell(hero, spell) then insert(s4, spell) n4 = n4 + 1 end
    end
    if n4 <= 4 then for _,s in s4 do TeachHeroSpell(hero, s); n = n + 1
    else repeat
        local s = s4[random(1,n4,n4)]
        if not KnowHeroSpell(hero, s) then TeachHeroSpell(hero, s); n = n + 1 end
        until n == 4
    end
    for _,spell in SPELLS_BY_TIER[5] do
        if not KnowHeroSpell(hero, spell) then insert(s5, spell) n5 = n5 + 1 end
    end
    if n5 <= 1 then for _,s in s5 do TeachHeroSpell(hero, s); n = n + 1
    else TeachHeroSpell(hero, s5[random(1,n5,n5)]); n = n + 1
    end
    for _,spell in SPELLS_BY_TIER[1] do
        if not KnowHeroSpell(hero, spell) then TeachHeroSpell(hero, spell); n = n + 1 end
    end
    for _,spell in SPELLS_BY_TIER[2] do
        if not KnowHeroSpell(hero, spell) then TeachHeroSpell(hero, spell); n = n + 1 end
    end
    for _,spell in SPELLS_BY_TIER[3] do
        if not KnowHeroSpell(hero, spell) then TeachHeroSpell(hero, spell); n = n + 1 end
    end
    Popup(player, {"/Text/Duel/Artifact/HelmOfTheWarmage.txt"; arg=n})
end

function DuelStaffOfTheLyre(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelStaffOfTheLyre")
    local attributes = {GetHeroStat(hero, STAT_ATTACK), GetHeroStat(hero, STAT_DEFENCE), GetHeroStat(hero, STAT_SPELL_POWER), GetHeroStat(hero, STAT_KNOWLEDGE)}
    local a1, a2 = 99, 99
    for i = 1,4 do if attributes[i] < a1 then a1 = attributes[i]; a1 = i end end
    for i = 1,4 do if attributes[i] < a2 and i ~= a1 then a2 = attributes[i]; a2 = i end end
    ChangeHeroStat(hero, a1, 4)
    ChangeHeroStat(hero, a2, 4)
    Popup(player, {"/Text/Duel/Artifact/StaffOfTheLyre.txt"; arg1=ATTRIBUTE_NAME_FILE[a1], arg2=ATTRIBUTE_NAME_FILE[a2]})
end

function DuelPendantOfTheLyre(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelPendantOfTheLyre")
    local exp = trunc(0.08 * DUEL_PLAYER_DATA.TOTAL_EXP[player])
    ChangeHeroStat(hero, STAT_EXPERIENCE, exp)
    Popup(player, {"/Text/Duel/Artifact/PendantOfTheLyre.txt"; arg=exp})
end

function DuelDwarvenSmithyHammer(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelDwarvenSmithyHammer")
    ChangeHeroStat(hero, STAT_ATTACK, 3)
    ChangeHeroStat(hero, STAT_DEFENCE, 3)
    Popup(player, {"/Text/Duel/Artifact/DwarvenSmithyHammer.txt"; arg=3})
end

function DuelBearhideWraps(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelBearhideWraps")
    local percent = 15 + 5 * GetHeroSkillMastery(hero, SKILL_LEADERSHIP)
    for creature,growth in DUEL_CREATURE_GROWTH[DUEL_FACTION[player]] do
        local nb = round(0.01 * growth * percent)
        AddHeroCreatures(hero, creature, nb)
    end
    Popup(player, {"/Text/Duel/Artifact/BearhideWraps.txt"; arg=percent})
end

function DuelVikingHatchet(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelVikingHatchet")
    GiveResources(player, GOLD, 5000)
    Popup(player, {"/Text/Duel/Artifact/VikingHatchet.txt"; arg=5000})
end

function DuelVikingShield(player, hero)
    log.trace("/scripts/duel/duel_artifacts.lua: DuelVikingShield")
    GiveResources(player, WOOD, 25)
    GiveResources(player, ORE, 25)
    Popup(player, {"/Text/Duel/Artifact/VikingShield.txt"; arg=25})
end


DUEL_ARTIFACT_EFFECTS = {
    [ARTIFACT_ENDLESS_SACK_OF_GOLD] = DuelEndlessSackOfGold,
    [ARTIFACT_ENDLESS_POUCH_OF_GOLD] = DuelEndlessPouchOfGold,
    [ARTIFACT_CAPE_OF_KINGS] = DuelCapeOfKings,
    [ARTIFACT_TURBAN_OF_ENLIGHTMENT] = DuelTurbanOfEnlightenment,
    [ARTIFACT_SCALE_MAIL_OF_ENLIGHTMENT] = DuelScaleMailOfEnlightenment,
    [ARTIFACT_ROBE_OF_THE_MAGISTER] = DuelRobeOfTheMagister,
    [ARTIFACT_RING_OF_THE_UNREPENTANT] = DuelRingOfTheUnrepentant,
    [ARTIFACT_AMULET_OF_NECROMANCY] = DuelAmuletOfNecromancy,
    [ARTIFACT_CROWN_OF_LEADER] = DuelCrownOfLeader,
    [ARTIFACT_HORN_OF_PLENTY] = DuelHornOfPlenty,
    [ARTIFACT_SACRED_SEED] = DuelSacredSeed,
    [ARTIFACT_FORTUNE_PICKAXE] = DuelFortunePickaxe,
    [ARTIFACT_ELDENAS_RED_SCARF] = DuelEldenasRedScarf,
    [ARTIFACT_ELDENAS_CIRCLET] = DuelEldenasCirclet,
    [ARTIFACT_ELDENAS_RED_COAT] = DuelEldenasRedCoat,
    [ARTIFACT_FORTUNE_BAND_OF_THE_SAINT] = DuelFortuneBandOfTheSaint,
    [ARTIFACT_SENTINELS_HELM] = DuelSentinelsHelm,
    [ARTIFACT_SENTINELS_BOOTS] = DuelSentinelsBoots,
    [ARTIFACT_VIZIRS_CAP] = DuelVizirsCap,
    [ARTIFACT_VIZIRS_SCIMITAR] = DuelVizirsScimitar,
    [ARTIFACT_MAGISTERS_SANDALS] = DuelMagistersSandals,
    [ARTIFACT_DEATH_KNIGHT_BOOTS] = DuelDeathKnightBoots,
    [ARTIFACT_PALACE_SHOES] = DuelPalaceShoes,
    [ARTIFACT_HELM_OF_THE_WARMAGE] = DuelHelmOfTheWarmage,
    [ARTIFACT_STAFF_OF_THE_LYRE] = DuelStaffOfTheLyre,
    [ARTIFACT_PENDANT_OF_THE_LYRE] = DuelPendantOfTheLyre,
    [ARTIFACT_DWARVEN_SMITHY_HAMMER] = DuelDwarvenSmithyHammer,
    [ARTIFACT_BEARHIDE_WRAPS] = DuelBearhideWraps,
    [ARTIFACT_VIKING_HATCHET] = DuelVikingHatchet,
    [ARTIFACT_VIKING_SHIELD] = DuelVikingShield,
}
