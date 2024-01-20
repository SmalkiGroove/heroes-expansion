
function Routine_GenerateGoldPerScout(player, hero)
    print("$ Routine_GenerateGoldPerScout")
    local mult = trunc(GetHeroLevel(hero) * 0.2)
    if mult > 0 then
        local amount = 0
        amount = amount + GetHeroCreatures(hero, CREATURE_SCOUT)
        amount = amount + GetHeroCreatures(hero, CREATURE_ASSASSIN)
        amount = amount + GetHeroCreatures(hero, CREATURE_STALKER)
        AddPlayer_Resource(player, hero, GOLD, amount * mult)
    end
end

function Routine_AddHeroRiders(player, hero)
    print("$ Routine_AddHeroRiders")
    AddHero_CreatureInTypes(player, hero, {CREATURE_RIDER,CREATURE_RAVAGER,CREATURE_BLACK_RIDER}, 0.12)
end

function Routine_GainDragonArtifacts(player, hero, combatIndex)
    print("$ Routine_GainDragonArtifacts")
    local level = GetHeroLevel(hero)
    local rnd = random(1,100,level)
    if (2 * level + 5) > rnd then
        local i = mod(rnd, 8) + 1
        local a = ARTIFACT_SETS[ARTIFACT_SET_DRAGON][i]
        GiveArtifact(hero, a)
    end
end

function Routine_ConvertKnowledgeToSpellpower(player, hero, level)
    print("$ Routine_ConvertKnowledgeToSpellpower")
    local diff = GetHeroStat(hero, STAT_KNOWLEDGE) - level
    if diff > 0 then
        ChangeHeroStat(hero, STAT_KNOWLEDGE, -diff)
        ChangeHeroStat(hero, STAT_SPELL_POWER, diff)
        ShowFlyingSign({"/Text/Game/Scripts/Stats/Spellpower.txt"; num=diff}, hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_AddHeroLevel(player, hero, level)
    print("$ Routine_AddHeroLevel")
    if mod(level, 6) == 0 then
        LevelUpHero(hero)
    end
end

function Routine_ActivateArtfsetEnlightenment(player, hero)
    print("$ Routine_ActivateArtfsetEnlightenment")
    -- GiveArtifact(hero, ___, 1)
    -- GiveArtifact(hero, ___, 1)
end

function Routine_ActivateArtfsetDungeon(player, hero)
    print("$ Routine_ActivateArtfsetDungeon")
    -- GiveArtifact(hero, ___, 1)
    -- GiveArtifact(hero, ___, 1)
end

Var_Sephinroth_Bonus = 0
function Routine_CheckHallOfIntrigue(player, hero)
    print("$ Routine_CheckHallOfIntrigue")
    local nb_halls = 0
    for _,town in GetObjectNamesByType("TOWN_DUNGEON") do
        if GetTownBuildingLevel(town, TOWN_BUILDING_DUNGEON_HALL_OF_INTRIGUE) > 0 then
            nb_halls = nb_halls + 1
        end
    end
    local diff = nb_halls - Var_Sephinroth_Bonus
    if diff ~= 0 then
        ChangeHeroStat(hero, STAT_SPELL_POWER, diff)
    end
end

function Routine_UpgradeToWitches(player, hero)
    print("$ Routine_UpgradeToWitches")
    local max_bloodwitch = GetHeroLevel(hero) * 2
    ChangeHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_1, CREATURE_SCOUT, TOWN_BUILDING_DWELLING_2, CREATURE_WITCH, max_bloodwitch)
    local max_shadowwitch = trunc(GetHeroLevel(hero) * 0.5)
    ChangeHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_4, CREATURE_RIDER, TOWN_BUILDING_DWELLING_5, CREATURE_MATRON, max_shadowwitch)
end

function Routine_AddHeroManticores(player, hero)
    print("$ Routine_AddHeroManticores")
    AddHero_CreatureType(player, hero, CREATURE_MANTICORE, 0.3)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


START_TRIGGER_DUNGEON = {
    [H_RANLETH] = Routine_ActivateArtfsetEnlightenment,
    [H_SEPHINROTH] = Routine_ActivateArtfsetDungeon,
}

DAILY_TRIGGER_DUNGEON = {
    [H_VAYSHAN] = Routine_GenerateGoldPerScout,
    [H_SORGAL] = Routine_AddHeroRiders,
}

WEEKLY_TRIGGER_DUNGEON = {
    [H_SHADYA] = Routine_UpgradeToWitches,
    [H_LETHOS] = Routine_AddHeroManticores,
}

LEVEL_UP_DUNGEON_HERO = {
    [H_SINITAR] = Routine_ConvertKnowledgeToSpellpower,
    [H_SHADYA] = Routine_AddHeroLevel,
}

AFTER_COMBAT_TRIGGER_DUNGEON = {
    [H_RAELAG] = Routine_GainDragonArtifacts,
}


function DoDungeonRoutine_Start(player, hero)
    if START_TRIGGER_DUNGEON[hero] then
        startThread(START_TRIGGER_DUNGEON[hero], player, hero)
    end
end

function DoDungeonRoutine_Daily(player, hero)
    if DAILY_TRIGGER_DUNGEON[hero] then
        startThread(DAILY_TRIGGER_DUNGEON[hero], player, hero)
    end
end

function DoDungeonRoutine_Weekly(player, hero)
    if WEEKLY_TRIGGER_DUNGEON[hero] then
        startThread(WEEKLY_TRIGGER_DUNGEON[hero], player, hero)
    end
end

function DoDungeonRoutine_LevelUp(player, hero, level)
    if LEVEL_UP_DUNGEON_HERO[hero] then
        startThread(LEVEL_UP_DUNGEON_HERO[hero], player, hero, level)
    end
end

function DoDungeonRoutine_AfterCombat(player, hero, index)
    if AFTER_COMBAT_TRIGGER_DUNGEON[hero] then
        startThread(AFTER_COMBAT_TRIGGER_DUNGEON[hero], player, hero, index)
    end
end


-- print("Loaded Dungeon advmap routines")
ROUTINES_LOADED[DUNGEON] = 1
