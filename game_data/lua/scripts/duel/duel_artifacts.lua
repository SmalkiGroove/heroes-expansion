

function DuelEndlessSackOfGold(player, hero)
    local value = 15000
    GiveResources(player, GOLD, value)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/EndlessSackOfGold.txt"; arg=value}, "NoneRoutine")
end

function DuelEndlessPouchOfGold(player, hero)
    local value = 5000
    GiveResources(player, GOLD, value)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/EndlessPouchOfGold.txt"; arg=value}, "NoneRoutine")
end

function DuelCapeOfKings(player, hero)
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
    MessageBoxForPlayers(GetPlayerFilter(player),
        { "/Text/Duel/Artifact/CapeOfKings.txt";
            days=DUEL_ADVENTURE_DAYS,
            gov=gov,
            gg=gg, gs=gs, gr=gr,
            ind=ind, myt=myt,
        }, "NoneRoutine")
end

function DuelTurbanOfEnlightenment(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/TurbanOfEnlightenment.txt"; arg=0}, "NoneRoutine")
end

function DuelScaleMailOfEnlightenment(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/ScaleMailOfEnlightenment.txt"; arg=0}, "NoneRoutine")
end

function DuelRobeOfTheMagister(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/RobeOfTheMagister.txt"; arg=0}, "NoneRoutine")
end

function DuelRingOfTheUnrepentant(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/RingOfTheUnrepentant.txt"; arg=0}, "NoneRoutine")
end

function DuelAmuletOfNecromancy(player, hero)    
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/AmuletOfNecromancy.txt"; arg=0}, "NoneRoutine")
end

function DuelBeginnerMagicStick(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/BeginnerMagicStick.txt"; arg=0}, "NoneRoutine")
end

function DuelRunicWarAxe(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/RunicWarAxe.txt"; arg=0}, "NoneRoutine")
end

function DuelRunicWarHarness(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/RunicWarHarness.txt"; arg=0}, "NoneRoutine")
end

function DuelCrownOfLeader(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/CrownOfLeader.txt"; arg=0}, "NoneRoutine")
end

function DuelHornOfPlenty(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/HornOfPlenty.txt"; arg=0}, "NoneRoutine")
end

function DuelSacredSeed(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/SacredSeed.txt"; arg=0}, "NoneRoutine")
end

function DuelFortunePickaxe(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/FortunePickaxe.txt"; arg=0}, "NoneRoutine")
end

function DuelEldenasRedScarf(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/EldenasRedScarf.txt"; arg=0}, "NoneRoutine")
end

function DuelEldenasCirclet(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/EldenasCirclet.txt"; arg=0}, "NoneRoutine")
end

function DuelEldenasRedCoat(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/EldenasRedCoat.txt"; arg=0}, "NoneRoutine")
end

function DuelVikingShield(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/VikingShield.txt"; arg=0}, "NoneRoutine")
end

function DuelFortuneBandOfTheSaint(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/FortuneBandOfTheSaint.txt"; arg=0}, "NoneRoutine")
end

function DuelSentinelsHelm(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/SentinelsHelm.txt"; arg=0}, "NoneRoutine")
end

function DuelSentinelsBoots(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/SentinelsBoots.txt"; arg=0}, "NoneRoutine")
end

function DuelVizirsCap(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/VizirsCap.txt"; arg=0}, "NoneRoutine")
end

function DuelVizirsScimitar(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/VizirsScimitar.txt"; arg=0}, "NoneRoutine")
end

function DuelMagistersSandals(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/MagistersSandals.txt"; arg=0}, "NoneRoutine")
end

function DuelDeathKnightBoots(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/DeathKnightBoots.txt"; arg=0}, "NoneRoutine")
end

function DuelPalaceShoes(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/PalaceShoes.txt"; arg=0}, "NoneRoutine")
end

function DuelHelmOfTheWarmage(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/HelmOfTheWarmage.txt"; arg=0}, "NoneRoutine")
end

function DuelStaffOfTheLyre(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/StaffOfTheLyre.txt"; arg=0}, "NoneRoutine")
end

function DuelPendantOfTheLyre(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/PendantOfTheLyre.txt"; arg=0}, "NoneRoutine")
end

function DuelDwarvenSmithyHammer(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/DwarvenSmithyHammer.txt"; arg=0}, "NoneRoutine")
end

function DuelBearhideWraps(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/BearhideWraps.txt"; arg=0}, "NoneRoutine")
end

function DuelVikingHatchet(player, hero)
    MessageBoxForPlayers(GetPlayerFilter(player), {"/Text/Duel/Artifact/VikingHatchet.txt"; arg=0}, "NoneRoutine")
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
    [ARTIFACT_BEGINNER_MAGIC_STICK] = DuelBeginnerMagicStick,
    [ARTIFACT_RUNIC_WAR_AXE] = DuelRunicWarAxe,
    [ARTIFACT_RUNIC_WAR_HARNESS] = DuelRunicWarHarness,
    [ARTIFACT_CROWN_OF_LEADER] = DuelCrownOfLeader,
    [ARTIFACT_HORN_OF_PLENTY] = DuelHornOfPlenty,
    [ARTIFACT_SACRED_SEED] = DuelSacredSeed,
    [ARTIFACT_FORTUNE_PICKAXE] = DuelFortunePickaxe,
    [ARTIFACT_ELDENAS_RED_SCARF] = DuelEldenasRedScarf,
    [ARTIFACT_ELDENAS_CIRCLET] = DuelEldenasCirclet,
    [ARTIFACT_ELDENAS_RED_COAT] = DuelEldenasRedCoat,
    [ARTIFACT_VIKING_SHIELD] = DuelVikingShield,
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
}
