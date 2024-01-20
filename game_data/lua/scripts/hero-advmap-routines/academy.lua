
function Routine_AddOtherHeroesGremlins(player, hero)
    print("$ Routine_AddOtherHeroesGremlins")
    for _,h in GetPlayerHeroes(player) do
        if h ~= hero then
            AddHero_CreatureInTypes(player, h, {CREATURE_GREMLIN,CREATURE_MASTER_GREMLIN,CREATURE_GREMLIN_SABOTEUR}, 0.5)
        end
    end
end

function Routine_AssembleGargoyles(player, hero)
    print("$ Routine_AssembleGargoyles")
    local max = 2 * GetHeroLevel(hero)
    local total = 0
    local assemble_table = {
        [CREATURE_STONE_GARGOYLE] = CREATURE_IRON_GOLEM,
        [CREATURE_OBSIDIAN_GARGOYLE] = CREATURE_STEEL_GOLEM,
        [CREATURE_MARBLE_GARGOYLE] = CREATURE_OBSIDIAN_GOLEM,
    }
    for garg,golem in assemble_table do
        local nb_garg = GetHeroCreatures(hero, garg)
        if mod(nb_garg, 2) == 1 then nb_garg = nb_garg - 1 end
        if nb_garg > 0 then
            local amount = min(max, nb_garg)
            RemoveHeroCreatures(hero, garg, amount)
            AddHeroCreatures(hero, golem, 0.5 * amount)
            total = total + amount
        end
    end
    if total > 0 then
        ShowFlyingSign({"/Text/Game/Scripts/HeroSpe/AssembleGargoyles.txt"; num=total}, hero, player, FLYING_SIGN_TIME)
    end
end

function Routine_AddHeroDjinns(player, hero)
    print("$ Routine_AddHeroDjinns")
    AddHero_CreatureInTypes(player, hero, {CREATURE_GENIE,CREATURE_MASTER_GENIE,CREATURE_DJINN_VIZIER}, 0.3)
end

function Routine_AddRecruitsRakshasas(player, hero)
    print("$ Routine_AddRecruitsRakshasas")
    AddHero_TownRecruits(player, hero, TOWN_BUILDING_DWELLING_6, CREATURE_RAKSHASA, 0.2)
end

function Routine_ActivateArtfsetNecro(player, hero)
    print("$ Routine_ActivateArtfsetNecro")
    -- GiveArtifact(hero, ___, 1)
    -- GiveArtifact(hero, ___, 1)
end

function Routine_UpgradeMages(player, hero)
    print("$ Routine_UpgradeMages")
    ChangeHero_CreatureUpgrade(player, hero, CREATURE_MAGI, CREATURE_ARCH_MAGI)
end

function Routine_AddOtherHeroesExperience(player, hero)
    print("$ Routine_AddOtherHeroesExperience")
    local exp = round(0.01 * GetHeroStat(hero, STAT_EXPERIENCE))
    for _,h in GetPlayerHeroes(player) do
        if h ~= hero then
            AddHero_StatAmount(player, h, STAT_EXPERIENCE, exp)
        end
    end
end

function Routine_AddHeroEagles(player, hero)
    print("$ Routine_AddHeroEagles")
    AddHero_CreatureType(player, hero, CREATURE_SNOW_APE, 0.2)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


START_TRIGGER_ACADEMY = {
    [H_RISSA] = Routine_ActivateArtfsetNecro,
}

DAILY_TRIGGER_ACADEMY = {
    [H_HAVEZ] = Routine_AddOtherHeroesGremlins,
    [H_CYRUS] = Routine_UpgradeMages,
    [H_MAAHIR] = Routine_AddOtherHeroesExperience,
}

WEEKLY_TRIGGER_ACADEMY = {
    [H_RAZZAK] = Routine_AssembleGargoyles,
    [H_GALIB] = Routine_AddHeroDjinns,
    [H_DAVIUS] = Routine_AddRecruitsRakshasas,
    [H_MINASLI] = Routine_AddHeroEagles,
}

LEVEL_UP_ACADEMY_HERO = {
}

AFTER_COMBAT_TRIGGER_ACADEMY = {
}


function DoAcademyRoutine_Start(player, hero)
    if START_TRIGGER_ACADEMY[hero] then
        startThread(START_TRIGGER_ACADEMY[hero], player, hero)
    end
end

function DoAcademyRoutine_Daily(player, hero)
    if DAILY_TRIGGER_ACADEMY[hero] then
        startThread(DAILY_TRIGGER_ACADEMY[hero], player, hero)
    end
end

function DoAcademyRoutine_Weekly(player, hero)
    if WEEKLY_TRIGGER_ACADEMY[hero] then
        startThread(WEEKLY_TRIGGER_ACADEMY[hero], player, hero)
    end
end

function DoAcademyRoutine_LevelUp(player, hero, level)
    if LEVEL_UP_ACADEMY_HERO[hero] then
        startThread(LEVEL_UP_ACADEMY_HERO[hero], player, hero, level)
    end
end

function DoAcademyRoutine_AfterCombat(player, hero, index)
    if AFTER_COMBAT_TRIGGER_ACADEMY[hero] then
        startThread(AFTER_COMBAT_TRIGGER_ACADEMY[hero], player, hero, index)
    end
end


-- print("Loaded Academy advmap routines")
ROUTINES_LOADED[ACADEMY] = 1
