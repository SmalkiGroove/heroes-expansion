
function Routine_Houndmasters(side, hero, id, mastery)
    log(DEBUG, "$ Routine_Houndmasters")
    local level = GetHeroLevel(side)
    local amount = 10 + 2 * level + random(1, level, 99)
    if hero == H_IVOR then
        SummonCreatureSideOffset(side, CREATURE_WOLF, amount, 1) sleep()
    end
    if hero == H_GRAWL then
        SummonCreatureSideOffset(side, CREATURE_HELL_HOUND, amount+level, 1) sleep()
    else
        SummonCreatureSideOffset(side, CREATURE_WOLF, amount, 1)
    end
end

function Routine_ElementalBalance(side, hero, id, mastery)
    log(DEBUG, "$ Routine_ElementalBalance")
    local creatures = GetUnits(1-side, CREATURE)
    for i,cr in creatures do
        local type = GetCreatureType(cr)
        if type == CREATURE_AIR_ELEMENTAL then
            local nb = GetCreatureNumber(cr)
            SummonCreatureSideOffset(side, CREATURE_EARTH_ELEMENTAL, nb, 0)
        elseif type == CREATURE_EARTH_ELEMENTAL then
            local nb = GetCreatureNumber(cr)
            SummonCreatureSideOffset(side, CREATURE_AIR_ELEMENTAL, nb, 0)
        elseif type == CREATURE_FIRE_ELEMENTAL then
            local nb = GetCreatureNumber(cr)
            SummonCreatureSideOffset(side, CREATURE_WATER_ELEMENTAL, nb, 0)
        elseif type == CREATURE_WATER_ELEMENTAL then
            local nb = GetCreatureNumber(cr)
            SummonCreatureSideOffset(side, CREATURE_FIRE_ELEMENTAL, nb, 0)
        end
    end
end

function Routine_RandomCreatureRush(side, hero, id, mastery)
    log(DEBUG, "$ Routine_RandomCreatureRush")
    local creature = RandomCreature(side, 0)
    if creature then
        setATB(creature, ATB_NEXT)
        ShowFlyingSign("/Text/Game/Scripts/Combat/Rush.txt", creature, 9)
    end
end

function Routine_ShatterMagic(side, hero, id, mastery)
    log(DEBUG, "$ Routine_ShatterMagic")
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
    log(DEBUG, "$ Routine_ImbueBallista")
    if CURRENT_UNIT == id then
        local ballista = UNIT_SIDE_PREFIX[side]..'-warmachine-WAR_MACHINE_BALLISTA'
        if IsCombatUnit(ballista) then
            setATB(ballista, ATB_NEXT)
        end
    end
end

function Routine_GuardianAngelInit(side, hero, id, mastery)
    log(DEBUG, "$ Routine_GuardianAngelInit")
    EnableAutoFinish(nil)
end

function Routine_GuardianAngelRez(side, hero, id, mastery, unit)
    if GetUnitSide(unit) ~= side then
        for _,cr in GetUnits(1-side, CREATURE) do return end
        combatSetPause(1)
        log(DEBUG, "$ Routine_GuardianAngelRez")
        local rez_stack = "none"
        local rez_power = 0
        for cr,nb in STARTING_ARMY[side] do
            local lost = nb - GetCreatureNumber(cr)
            local type = GetCreatureType(cr)
            local tier = CREATURES[type][2]
            local rez_power_cr = lost * power(2, tier)
            if rez_power_cr > rez_power then
                rez_stack = cr
                rez_power = rez_power_cr
            end
        end
        if rez_power > 0 then
            local angel = "creature_ARCHANGEL-GUARDIAN_ANGEL"
            SummonCreatureSideOffset(side, CREATURE_ARCHANGEL, 1, 1, angel)
            UnitCastAimedSpell(angel, SPELL_ABILITY_RESURRECT_ALLIES, rez_stack)
            Finish(side)
        end
    end
end



COMBAT_START_SKILL_ROUTINES = {
    [SKILL_SHATTER_MAGIC] = Routine_ShatterMagic,
    [PERK_HOUNDMASTERS] = Routine_Houndmasters,
    [PERK_ELEMENTAL_BALANCE] = Routine_ElementalBalance,
    [PERK_RUSH] = Routine_RandomCreatureRush
    [PERK_GUARDIAN_ANGEL] = Routine_GuardianAngelInit,
}

COMBAT_TURN_SKILL_ROUTINES = {
    [PERK_IMBUE_BALLISTA] = Routine_ImbueBallista,
}

UNIT_DIED_SKILL_ROUTINES = {
    [PERK_GUARDIAN_ANGEL] = Routine_GuardianAngelRez,
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


-- log(TRACE, "Loaded skills-routines-combat.lua")
ROUTINES_LOADED[12] = 1
