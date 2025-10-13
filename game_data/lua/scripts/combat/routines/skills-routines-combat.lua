
function Routine_Houndmasters(side, hero, id, mastery)
    -- log("Trigger Houndmasters !")
    local level = GetHeroLevel(side)
    local amount = 10 + 2 * level + random(1, level, 99)
    if hero == H_IVOR then
        SummonCreatureStack_X(side, CREATURE_WOLF, amount, 1) sleep(10)
    end
    if hero == H_GRAWL then
        SummonCreatureStack_X(side, CREATURE_HELL_HOUND, amount+level, 1)
    else
        SummonCreatureStack_X(side, CREATURE_WOLF, amount, 1)
    end
end

function Routine_ElementalBalance(side, hero, id, mastery)
    -- log("Trigger Elemental Balance !")
    local creatures = GetUnits(1-side, CREATURE)
    for i,cr in creatures do
        local type = GetCreatureType(cr)
        if type == CREATURE_AIR_ELEMENTAL then
            local nb = GetCreatureNumber(cr)
            SummonCreatureStack_X(side, CREATURE_EARTH_ELEMENTAL, nb, 0)
            sleep(50)
        elseif type == CREATURE_EARTH_ELEMENTAL then
            local nb = GetCreatureNumber(cr)
            SummonCreatureStack_X(side, CREATURE_AIR_ELEMENTAL, nb, 0)
            sleep(50)
        elseif type == CREATURE_FIRE_ELEMENTAL then
            local nb = GetCreatureNumber(cr)
            SummonCreatureStack_X(side, CREATURE_WATER_ELEMENTAL, nb, 0)
            sleep(50)
        elseif type == CREATURE_WATER_ELEMENTAL then
            local nb = GetCreatureNumber(cr)
            SummonCreatureStack_X(side, CREATURE_FIRE_ELEMENTAL, nb, 0)
            sleep(50)
        end
    end
end

function Routine_ShatterMagic(side, hero, id, mastery)
    -- log("Trigger Shatter Magic !")
    local mult = 0.1 * mastery
    local h = GetHero(1-side)
    if h then
        local max = GetUnitMaxManaPoints(h)
        local cur = GetUnitManaPoints(h)
        if hero == H_MARBAS then max = 2 * max end
        local burn = min(cur, round(mult * max))
        SetMana(h, cur-burn)
        ShowFlyingSign("/Text/Game/Scripts/Combat/ShatterMagic.txt", h, 9)
    end
    local creatures = GetUnits(1-side, CREATURE)
    for i,cr in creatures do
        local m = GetUnitMaxManaPoints(cr)
        if m > 0 then
            local burn = round(mult * m)
            SetMana(cr, m-burn)
            ShowFlyingSign("/Text/Game/Scripts/Combat/ShatterMagic.txt", cr, 9)
        end
    end
end

function Routine_ImbueBallista(side, hero, id, mastery)
    -- log("Trigger Imbue Ballista !")
    if CURRENT_UNIT == hero then
        local ballista = UNIT_SIDE_PREFIX[side]..'-warmachine-WAR_MACHINE_BALLISTA'
        if IsCombatUnit(ballista) then
            setATB(ballista, ATB_NEXT)
        end
    end
end



COMBAT_START_SKILL_ROUTINES = {
    [PERK_HOUNDMASTERS] = Routine_Houndmasters,
    [PERK_ELEMENTAL_BALANCE] = Routine_ElementalBalance,
    [SKILL_SHATTER_MAGIC] = Routine_ShatterMagic,
}

COMBAT_TURN_SKILL_ROUTINES = {
    [PERK_IMBUE_BALLISTA] = Routine_ImbueBallista,
}

UNIT_DIED_SKILL_ROUTINES = {
}


function DoSkillRoutine_CombatStart(side, name, id)
    for skill,routine in COMBAT_START_SKILL_ROUTINES do
        local mastery = GetHeroSkillMastery(side, skill)
        if mastery >= 1 then
            routine(side, name, id, mastery)
        end
    end
end

function DoSkillRoutine_CombatTurn(side, name, id)
    for skill,routine in COMBAT_TURN_SKILL_ROUTINES do
        local mastery = GetHeroSkillMastery(side, skill)
        if mastery >= 1 then
            routine(side, name, id, mastery)
        end
    end
end

function DoSkillRoutine_UnitDied(side, name, id, unit)
    for skill,routine in UNIT_DIED_SKILL_ROUTINES do
        local mastery = GetHeroSkillMastery(side, skill)
        if mastery >= 1 then
            routine(side, name, id, mastery, unit)
        end
    end
end


-- log("Loaded skills-routines-combat.lua")
ROUTINES_LOADED[12] = 1
