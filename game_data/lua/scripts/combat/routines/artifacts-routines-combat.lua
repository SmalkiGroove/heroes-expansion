
function Routine_SummonElementalsType(side, hero, type)
    local nb = 10 + trunc(0.2 * GetUnitMaxManaPoints(hero))
    SummonCreature(side, type, nb)
end

function Routine_SummonElementalsAir(side, hero)
    log("$ Routine_SummonElementalsAir")
    Routine_SummonElementalsType(side, hero, CREATURE_AIR_ELEMENTAL)
end

function Routine_SummonElementalsEarth(side, hero)
    log("$ Routine_SummonElementalsEarth")
    Routine_SummonElementalsType(side, hero, CREATURE_EARTH_ELEMENTAL)
end

function Routine_SummonElementalsFire(side, hero)
    log("$ Routine_SummonElementalsFire")
    Routine_SummonElementalsType(side, hero, CREATURE_FIRE_ELEMENTAL)
end

function Routine_SummonElementalsWater(side, hero)
    log("$ Routine_SummonElementalsWater")
    Routine_SummonElementalsType(side, hero, CREATURE_WATER_ELEMENTAL)
end

function Routine_ArtifactMoonCharm(side, hero, unit)
    log("$ Routine_ArtifactMoonCharm")
    if not ROUTINE_VARS.MoonCharm then
        if GetUnitSide(unit) == side and ROUTINE_VARS.InitialCounts[unit] then
            local type = GetCreatureType(unit)
            local x,y = GetUnitPosition(unit)
            local amount = ROUTINE_VARS.InitialCounts[unit]
            AddCreature(side, type, amount, x, y)
            ROUTINE_VARS.MoonCharm = not nil
        end
    end
end


function Routine_ArtfsetFrost(side, hero)
    log("$ Routine_ArtfsetFrost")
    repeat sleep() until CURRENT_UNIT == hero
    HeroCast_AllCreatures(hero, SPELL_DEEP_FREEZE, FREE_MANA, 1-side)
    SetATB_ID(hero, ATB_INSTANT)
end

function Routine_ArtfsetSpirit(side, hero)
    log("$ Routine_ArtfsetSpirit")
    HeroCast_AllCreatures(hero, SPELL_SORROW, FREE_MANA, 1-side)
end

function Routine_ArtfsetBestial(side, hero)
    log("$ Routine_ArtfsetBestial")
    local beasts = { CREATURE_GRIFFIN, CREATURE_UNICORN, CREATURE_WYVERN, CREATURE_HYDRA, CREATURE_NIGHTMARE, CREATURE_WOLF, CREATURE_MANTICORE, CREATURE_SNOW_APE }
    local beast = beasts[random(1,8,0)]
    local tier = CREATURES[beast][2]
    local amount = 0.5 * ((10-tier) * (10-tier) * (10-tier) + tier)
    SummonCreatureStack_X(side, beast, amount, 4)
end

function Routine_ArtfsetGenji1(side, hero, unit)
    log("$ Routine_ArtfsetGenji1")
    if GetUnitSide(unit) ~= side then
        local m = GetUnitManaPoints(hero) + 50
        SetMana(hero, m)
        SetATB_ID(hero, ATB_INSTANT)
    end
end

function Routine_ArtfsetWarLeader(side, hero, unit)
    log("$ Routine_ArtfsetWarLeader")
    if GetUnitSide(unit) ~= side then
        for i,cr in GetUnits(side, CREATURE) do
            local tier = CREATURES[cr][2]
            if tier == 1 or tier == 2 or tier == 3 then
                SetATB_ID(cr, ATB_NEXT)
            end
        end
    end
end


COMBAT_PREPARE_ARTIFACT_ROUTINES = {
}
COMBAT_START_ARTIFACT_ROUTINES = {
    [ARTIFACT_ORB_OF_AIR] = Routine_SummonElementalsAir,
    [ARTIFACT_ORB_OF_EARTH] = Routine_SummonElementalsEarth,
    [ARTIFACT_ORB_OF_FIRE] = Routine_SummonElementalsFire,
    [ARTIFACT_ORB_OF_WATER] = Routine_SummonElementalsWater,
}
COMBAT_TURN_ARTIFACT_ROUTINES = {
}
UNIT_DIED_ARTIFACT_ROUTINES = {
    [ARTIFACT_MOON_CHARM] = Routine_ArtifactMoonCharm,
}

COMBAT_PREPARE_ARTFSET_ROUTINES = {
}
COMBAT_START_ARTFSET_ROUTINES = {
    [ARTFSET_FROST_5PC] = Routine_ArtfsetFrost,
    [ARTFSET_SPIRIT_5PC] = Routine_ArtfsetSpirit,
    [ARTFSET_BESTIAL_4PC] = Routine_ArtfsetBestial,
}
COMBAT_TURN_ARTFSET_ROUTINES = {
}
UNIT_DIED_ARTFSET_ROUTINES = {
    [ARTFSET_GENJI_4PC] = Routine_ArtfsetGenji1,
    [ARTFSET_WAR_4PC] = Routine_ArtfsetWarLeader,
}


function DoArtifactRoutine_CombatPrepare(side, name, id)
    for a,routine in COMBAT_PREPARE_ARTIFACT_ROUTINES do
        if HasHeroEquippedArtifact(side, a) then routine(side, id) end
    end
    for a,routine in COMBAT_PREPARE_ARTFSET_ROUTINES do
        if HasHeroActiveArtifactSet(side, a) then routine(side, id) end
    end
end

function DoArtifactRoutine_CombatStart(side, name, id)
    for a,routine in COMBAT_START_ARTIFACT_ROUTINES do
        if HasHeroEquippedArtifact(side, a) then routine(side, id) end
    end
    for a,routine in COMBAT_START_ARTFSET_ROUTINES do
        if HasHeroActiveArtifactSet(side, a) then routine(side, id) end
    end
end

function DoArtifactRoutine_CombatTurn(side, name, id)
    for a,routine in COMBAT_TURN_ARTIFACT_ROUTINES do
        if HasHeroEquippedArtifact(side, a) then routine(side, id) end
    end
    for a,routine in COMBAT_TURN_ARTFSET_ROUTINES do
        if HasHeroActiveArtifactSet(side, a) then routine(side, id) end
    end
end

function DoArtifactRoutine_UnitDied(side, name, id, unit)
    for a,routine in UNIT_DIED_ARTIFACT_ROUTINES do
        if HasHeroEquippedArtifact(side, a) then routine(side, id, unit) end
    end
    for a,routine in UNIT_DIED_ARTFSET_ROUTINES do
        if HasHeroActiveArtifactSet(side, a) then routine(side, id, unit) end
    end
end


-- log("Loaded artifacts-routines-combat.lua")
ROUTINES_LOADED[13] = 1
