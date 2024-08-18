
function NoneRoutine()
    -- log("Trigger nothing !")
end

---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- HAVEN

function Routine_BallistaRandomSalvo(side, hero)
    -- log("Trigger ballista random shoot !")
    local n = 1 + trunc(GetHeroLevel(side) * 0.1)
    for i = 1,n do
        RandomShoot_Ballista(side)
        sleep(600)
    end
end

function Routine_PeasantsMoveNext(side, hero)
    -- log("Trigger peasants play next !")
    if CURRENT_UNIT == hero then
        SetATB_CreatureTypes(side, {CREATURE_PEASANT,CREATURE_MILITIAMAN,CREATURE_LANDLORD}, ATB_NEXT)
    end
end

function Routine_ArchersMoveFirst(side, hero)
    -- log("Trigger archers atb boost !")
    SetATB_CreatureTypes(side, {CREATURE_ARCHER,CREATURE_MARKSMAN,CREATURE_LONGBOWMAN}, ATB_INSTANT)
end

function Routine_InfantryDash(side, hero)
    -- log("Trigger footmen dash !")
    local creatures = GetUnits(side, CREATURE)
    for i,cr in creatures do
        local type = GetCreatureType(cr)
        if type == CREATURE_FOOTMAN or type == CREATURE_SWORDSMAN or type == CREATURE_VINDICATOR then
            UseCombatAbility(cr, SPELL_ABILITY_DASH)
            SetATB_ID(cr, 0.1)
        end
    end
end

function Routine_RetaliationStrike(side, hero)
    -- log("Trigger cast Retaliation Strike on cavalier !")
    local cavalier = "none"
    local max = 0
    for i,cr in GetUnits(side, CREATURE) do
        local type = GetCreatureType(cr)
        if type == CREATURE_CAVALIER or type == CREATURE_PALADIN or type == CREATURE_CHAMPION then
            local nb = GetCreatureNumber(cr)
            if nb > max then
                cavalier = cr
                max = nb
            end
        end
    end
    if max > 0 then
        HeroCast_Target(hero, SPELL_HOLY_CHARGE, NO_COST, cavalier)
    end
end

function Routine_CastPrayer(side, hero)
    -- log("Trigger cast Prayer !")
    HeroCast_Global(hero, SPELL_PRAYER, NO_COST)
end

function Routine_CastRandomStoneskin(side, hero)
    -- log("Trigger random Stoneskin !")
    if CURRENT_UNIT == hero then
        HeroCast_RandomCreature(hero, SPELL_STONESKIN, FREE_MANA, side)
        if IsHuman(side) then SetATB_ID(hero, ATB_INSTANT) end
    end
end

function Routine_GriffinInstantDive(side, hero)
    -- log("Trigger instant dive !")
    for k,v in ROUTINE_VARS.GriffinDives do
        if v == 1 then
            local found = nil
            for i,cr in GetUnits(side, CREATURE) do
                if cr == k then found = not nil end
            end
            if not found then
                SetATB_ID(k, ATB_INSTANT)
                SetATB_ID(CURRENT_UNIT, ATB_NEXT)
            end
        end
    end
    if CURRENT_UNIT_SIDE == side then
        if IsCreature(CURRENT_UNIT) then
            local type = GetCreatureType(CURRENT_UNIT)
            if type == CREATURE_GRIFFIN or type == CREATURE_BATTLE_GRIFFIN or type == CREATURE_ROYAL_GRIFFIN then
                ROUTINE_VARS.GriffinDives[CURRENT_UNIT] = 1
            end
        end
    end
end

function Routine_GriffinDead(side, hero, unit)
    -- log("Trigger dead griffin unregister !")
    if ROUTINE_VARS.GriffinDives[unit] then
        ROUTINE_VARS.GriffinDives[unit] = 0
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- PRESERVE

function Routine_HeroMoveNext(side, hero)
    -- log("Trigger hero play next !")
    if CURRENT_UNIT_SIDE ~= GetUnitSide(hero) then
        local n = 15 + trunc(GetHeroLevel(side) * 0.5)
        if n > random(0, 100, COMBAT_TURN) then
            SetATB_ID(hero, ATB_NEXT)
            ShowFlyingSign("/Text/Game/Scripts/Combat/LoneHunter.txt", hero, 9)
        end
    end
end

function Routine_ResetAtbOnKillEnraged(side, hero, unit)
    -- log("Trigger reset enraged atb !")
    if GetUnitSide(unit) ~= GetUnitSide(hero) and IsCreature(unit) then
        -- SetATB_ID(CURRENT_UNIT, ATB_NEXT)
        for i,cr in GetUnits(side, CREATURE) do
            local type = GetCreatureType(cr)
            if CREATURES[type][1] == PRESERVE and contains({1,3,4,6}, CREATURES[type][2]) then
                if not ROUTINE_VARS.AtbBoosted[cr] then
                    SetATB_ID(cr, ATB_INSTANT)
                    ROUTINE_VARS.AtbBoosted[cr] = not nil
                    HeroCast_Target(hero, SPELL_BLOODLUST, FREE_MANA, cr)
                    return
                end
            end
        end
    end
end

function Routine_HunterRandomShoot(side, hero)
    -- log("Trigger hunters random shoot !")
    RandomShoot_CreatureTypes(side, {CREATURE_WOOD_ELF,CREATURE_GRAND_ELF,CREATURE_SHARP_SHOOTER})
    SetATB_CreatureTypes(side, {CREATURE_WOOD_ELF,CREATURE_GRAND_ELF,CREATURE_SHARP_SHOOTER}, 0.1)
end

function Routine_MoveForwardUnits(side, hero)
    -- log("Trigger move forward units !")
    for i,cr in GetUnits(side, CREATURE) do
        local x,y = GetUnitPosition(cr)
        local x0 = (side == ATTACKER) and GRID_X_MIN or GRID_X_MAX
        local x1 = (side == ATTACKER) and (x + 3) or (x - 3)
        if x ~= x0 then MoveCombatUnit(cr, x1, y) end
    end
end

function Routine_WolfDeadRevenge(side, hero, unit)
    -- log("Trigger wolf dead revenge !")
    if GetUnitSide(unit) == GetUnitSide(hero) and IsCreature(unit) then
        if GetCreatureType(unit) == CREATURE_WOLF then
            local x,y = GetUnitPosition(unit)
            local target = nil
            local distance = 1000
            for i,cr in GetUnits(1-side, CREATURE) do
                local xx,yy = GetUnitPosition(cr)
                local dx = x-xx
                local dy = y-yy
                local d = dx*dx + dy*dy
                if d < distance then
                    target = cr
                    distance = d
                end
            end
            if target then
                sleep(100)
                local nb = 0
                for i,cr in GetUnits(side, CREATURE) do
                    if GetCreatureType(cr) == CREATURE_WOLF then
                        AttackCombatUnit(cr, target)
                        nb = nb + 1
                        if nb == 2 then return else sleep(250) end
                    end
                end
            end
        end
    end
end

function Routine_CastSummonHive(side, hero)
    -- log("Trigger summon beehives !")
    local x = (side == ATTACKER) and GRID_X_MAX or GRID_X_MIN
    local y1 = GRID_Y_MIN
    local y2 = GRID_Y_MAX
    while y1 ~= GRID_Y_MIN + 4 do
        HeroCast_Area(hero, SPELL_SUMMON_HIVE, FREE_MANA, x, y1)
        sleep(5)
        if length(GetUnits(side, SPELL_SPAWN)) == 1 then y1 = GRID_Y_MIN + 4 else y1 = y1 + 1 end
    end
    while y2 ~= GRID_Y_MAX - 4 do
        HeroCast_Area(hero, SPELL_SUMMON_HIVE, FREE_MANA, x, y2)
        sleep(5)
        if length(GetUnits(side, SPELL_SPAWN)) == 2 then y2 = GRID_Y_MAX - 4 else y2 = y2 - 1 end
    end
end

function Routine_SpriteManaLink(side, hero)
    -- log("Trigger sprite mana link !")
    if CURRENT_UNIT_SIDE == side then
        if IsCreature(CURRENT_UNIT) then
            if GetCreatureType(CURRENT_UNIT) == CREATURE_SPRITE then
                local amount = trunc(0.1 * GetCreatureNumber(CURRENT_UNIT))
                if amount > 0 then
                    local cur = GetUnitManaPoints(hero)
                    local max = GetUnitMaxManaPoints(hero)
                    SetMana(hero, min(cur+amount, max))
                end
            end
        elseif CURRENT_UNIT == hero then
            for i,cr in GetUnits(side, CREATURE) do
                if GetCreatureType(cr) == CREATURE_SPRITE then
                    local m = 1 + trunc(0.2 * GetHeroLevel(side))
                    local cur = GetUnitManaPoints(cr)
                    local max = GetUnitMaxManaPoints(cr)
                    SetMana(cr, min(cur+m, max))
                end
            end
        end
    end
end

function Routine_CastMassHaste(side, hero)
    -- log("Trigger hero cast Mass Haste !")
    HeroCast_Global(hero, SPELL_MASS_HASTE, FREE_MANA)
end

function Routine_SummonDruidStack(side, hero)
    -- log("Trigger elder druids summoning !")
    local n = GetHeroLevel(side)
    local amount = ceil(0.4 * n * n)
    SummonCreatureStack_X(side, CREATURE_DRUID_OF_THE_COUNCIL, amount, 0)
    sleep(50)
    for i,cr in GetUnits(side, CREATURE) do
        if GetCreatureType(cr) == CREATURE_DRUID_OF_THE_COUNCIL then
            UseCombatAbility(cr, SPELL_ABILITY_POWER_FEED)
            if GetUnitManaPoints(hero) < GetUnitMaxManaPoints(hero) then
                UseCombatAbility(cr, SPELL_ABILITY_MANA_FEED)
            end
        end
    end
end

function Routine_DruidsMoveNext(side, hero)
    -- log("Trigger druids play next !")
    if CURRENT_UNIT == hero then
        SetATB_CreatureTypes(side, {CREATURE_DRUID,CREATURE_DRUID_ELDER,CREATURE_HIGH_DRUID,CREATURE_DRUID_OF_THE_COUNCIL}, ATB_NEXT)
    end
end

function Routine_AllRegeneration(side, hero)
    -- log("Trigger cast regeneration !")
    if CURRENT_UNIT == hero then
        local limit = 5 + trunc(0.2 * GetHeroLevel(side))
        ROUTINE_VARS.HeroTurns = ROUTINE_VARS.HeroTurns + 1
        if ROUTINE_VARS.HeroTurns == limit then
            HeroCast_AllCreatures(hero, SPELL_REGENERATION, FREE_MANA, side)
            SetATB_ID(hero, ATB_INSTANT)
        end
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- FORTRESS

function Routine_BallistaMoveFirst(side, hero)
    -- log("Trigger ballista play first !")
    SetATB_WarMachineType(side, WAR_MACHINE_BALLISTA, ATB_INSTANT)
    -- ShowFlyingSign("/Text/Game/Scripts/Combat/WorkshopExpert.txt", hero, 9)
end

function Routine_SpearWielderCoordination(side, hero)
    -- log("Trigger spearwielders coordination !")
    if CURRENT_UNIT_SIDE == side then
        if IsCreature(CURRENT_UNIT) then
            local type = GetCreatureType(CURRENT_UNIT)
            if type == CREATURE_AXE_FIGHTER or type == CREATURE_AXE_THROWER or type == CREATURE_HARPOONER then
                if GetCreatureNumber(CURRENT_UNIT) > 10 then
                    HeroCast_Target(hero, SPELL_EFFECT_COORDINATION, NO_COST, CURRENT_UNIT)
                end
            end
        end
    end
end

function Routine_ThanesAbility(side, hero)
    -- log("Trigger Thanes ability !")
    local creatures = GetUnits(side, CREATURE)
    for i,cr in creatures do
        if GetCreatureType(cr) == CREATURE_WARLORD then
            local x,y = GetUnitPosition(RandomCreature(1-side, i))
            UseCombatAbility(cr, SPELL_ABILITY_FLAMESTRIKE, x, y)
            SetATB_ID(cr, ATB_HALF)
            sleep(100)
        elseif GetCreatureType(cr) == CREATURE_THUNDER_THANE then
            local x,y = GetUnitPosition(RandomCreature(1-side, i))
            UseCombatAbility(cr, SPELL_ABILITY_STORMBOLT, x, y)
            SetATB_ID(cr, ATB_HALF)
            sleep(100)
        end
    end
end

function Routine_CastFireWalls(side, hero)
    -- log("Trigger cast Fire walls !")
    local m = GetUnitManaPoints(hero)
    local x = 11 - 6 * side
    for _,y in {3,6,9} do
        HeroCast_Area(hero, SPELL_FIREWALL, FREE_MANA, x, y)
        sleep(10)
    end
    SetMana(hero, m)
end

function Routine_RunePriestsMoveFirst(side, hero)
    -- log("Trigger rune priests play first !")
    SetATB_CreatureTypes(side, {CREATURE_RUNE_MAGE,CREATURE_FLAME_MAGE,CREATURE_FLAME_KEEPER}, ATB_INSTANT)
end

function Routine_CastEarthquake(side, hero)
    -- log("Trigger earthquake !")
    -- HeroCast_Area(hero, SPELL_UBER_METEOR_SHOWER, FREE_MANA, x, r)
    HeroCast_Global(hero, SPELL_EARTHQUAKE, FREE_MANA)
    sleep(600)
end

function Routine_DwavenDefendOrder(side, hero)
    -- log("Trigger defend order !")
    if CURRENT_UNIT_SIDE == side then
        if IsCreature(CURRENT_UNIT) then
            local type = GetCreatureType(CURRENT_UNIT)
            if CREATURES[type][1] == FORTRESS then
                startThread(Routine_DwavenDefendOrderWait, CURRENT_UNIT)
            end
        end
    end
end

function Routine_DwavenDefendOrderWait(id)
    repeat sleep(10) until CURRENT_UNIT ~= id
    DefendCombatUnit(id)
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMY

function Routine_RakshasasAbility(side, hero)
    -- log("Trigger rakshasas dash !")
    local creatures = GetUnits(side, CREATURE)
    for i,cr in creatures do
        local type = GetCreatureType(cr)
        if type == CREATURE_RAKSHASA or type == CREATURE_RAKSHASA_RUKH or type == CREATURE_RAKSHASA_KSHATRI then
            UseCombatAbility(cr, SPELL_ABILITY_DASH)
            SetATB_ID(cr, ATB_HALF)
        end
    end
end

function Routine_BallistaMoveNext(side, hero)
    -- log("Trigger fire ballista ATB boost !")
    if CURRENT_UNIT == hero then
        SetATB_WarMachineType(side, WAR_MACHINE_BALLISTA, ATB_NEXT)
    end
end

function Routine_CastMultipleArcaneCrystals(side, hero)
    -- log("Trigger random arcane crystals !")
    local m = GetUnitManaPoints(hero)
    local n = trunc(0.11 * m)
    local x1 = 15 - 13 * side
    local x2 = 11 - 5 * side
    for i = 1,n do
        HeroCast_Area(hero, SPELL_ARCANE_CRYSTAL, 10, random(x1,x2,m-i), random(GRID_Y_MIN,GRID_Y_MAX,m-i))
        sleep(10)
    end
    SetMana(hero, m-n)
end

function Routine_MagesCastMagicFist(side, hero)
    -- log("Trigger mages magic fist !")
    CreatureTypesCast_RandomTarget(side, 1-side, {CREATURE_MAGI,CREATURE_ARCH_MAGI,CREATURE_COMBAT_MAGE}, SPELL_MAGIC_FIST)
    SetATB_CreatureTypes(side, {CREATURE_MAGI,CREATURE_ARCH_MAGI,CREATURE_COMBAT_MAGE}, 0.1)
end

function Routine_CastSummonElementals(side, hero)
    -- log("Trigger summon elementals !")
    HeroCast_Global(hero, SPELL_SUMMON_ELEMENTALS, FREE_MANA)
end

function Routine_TimeShift(side, hero)
    -- log("Trigger time shift !")
    if CURRENT_UNIT == hero and COMBAT_TURN > 1 then
        local r = 40 + GetHeroLevel(side)
        if r > random(0, 100, COMBAT_TURN) then
            local friendly = RandomCreature(side, COMBAT_TURN)
            local enemy = RandomCreature(1-side, COMBAT_TURN)
            SetATB_ID(friendly, ATB_NEXT)
            ShowFlyingSign("/Text/Game/Scripts/Combat/TimeShift.txt", friendly, 9)
            SetATB_ID(enemy, ATB_ZERO)
            ShowFlyingSign("/Text/Game/Scripts/Combat/TimeShift.txt", enemy, 9)
        end
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- DUNGEON

function Routine_ScoutsMoveFirst(side, hero)
    -- log("Trigger scouts play first !")
    SetATB_CreatureTypes(side, {CREATURE_SCOUT,CREATURE_ASSASSIN,CREATURE_STALKER}, ATB_INSTANT)
end

function Routine_MinotaursMoveNext(side, hero)
    -- log("Trigger minotaurs play next !")
    if CURRENT_UNIT == hero then
        SetATB_CreatureTypes(side, {CREATURE_MINOTAUR,CREATURE_MINOTAUR_KING,CREATURE_MINOTAUR_CAPTAIN}, ATB_NEXT)
    end
end

function Routine_RidersHydraSynergy(side, hero)
    -- log("Trigger riders boost hydras atb !")
    if CURRENT_UNIT_SIDE == side then
        if IsCreature(CURRENT_UNIT) then
            local type = GetCreatureType(CURRENT_UNIT)
            if type == CREATURE_RIDER or type == CREATURE_RAVAGER or type == CREATURE_BLACK_RIDER then
                local r = 25 + trunc(GetHeroLevel(side) * 0.25)
                if r > random(0, 100, COMBAT_TURN) then
                    SetATB_CreatureTypes(side, {CREATURE_HYDRA,CREATURE_CHAOS_HYDRA,CREATURE_ACIDIC_HYDRA}, ATB_NEXT)
                end
            end
        end
    end
end

function Routine_HeroCastRage(side, hero)
    -- log("Trigger hero cast rage")
    local enemies = GetUnits(1-side, CREATURE)
    local v = 1 + trunc(GetHeroLevel(side) * 0.05)
    local n = min(length(enemies), v)
    for i = 1,n do
        HeroCast_Target(hero, SPELL_BERSERK, FREE_MANA, enemies[i-1])
    end
end

function Routine_SummonDeadEnnemyCreature(side, hero, unit)
    -- log("Trigger revive enemy creature !")
    if GetUnitSide(unit) ~= side and ROUTINE_VARS.InitialCounts[unit] then
        local type = GetCreatureType(unit)
        local x,y = GetUnitPosition(unit)
        local p = 10 + GetHeroLevel(side)
        local amount = trunc(ROUTINE_VARS.InitialCounts[unit] * p * 0.01)
        SummonCreatureStack_XY(side, type, amount, x, y)
    end
end

function Routine_DragonStrike(side, hero)
    -- log("Trigger full dragon set !")
    if HasHeroActiveArtifactSet(side, ARTFSET_DRAGON_8PC) then
        local dragon = nil
        local count = 0
        for i,cr in GetUnits(side, CREATURE) do
            local type = GetCreatureType(cr)
            if type == CREATURE_DEEP_DRAGON or type == CREATURE_BLACK_DRAGON or type == CREATURE_RED_DRAGON then
                local nb = GetCreatureNumber(cr)
                if nb > count then
                    dragon = cr
                    count = nb
                end
            end
        end
        if dragon then
            local target = RandomCreature(1-side, count)
            AttackCombatUnit(dragon, target)
            combatPlayEmotion(side, 1)
        end
    end
end

function Routine_RefreshMatronMana(side, hero)
    -- log("Trigger refresh shadow witches mana !")
    if CURRENT_UNIT == hero then
        local prob = 20 + 2 * GetHeroLevel(side)
        for i,cr in GetUnits(side, CREATURE) do
            local type = GetCreatureType(cr)
            if type == CREATURE_MATRON or type == CREATURE_MATRIARCH or type == CREATURE_SHADOW_MISTRESS then
                if random(0,100,COMBAT_TURN+i) < prob then
                    local max = GetUnitMaxManaPoints(cr)
                    SetMana(cr, max)
                end
            end
        end
    end
end

function Routine_CastRandomDeepFrost(side, hero)
    -- log("Trigger cast deep frost !")
    HeroCast_RandomCreature(hero, SPELL_DEEP_FREEZE, FREE_MANA, 1-side)
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- NECROPOLIS

function Routine_SummonAndKillEnnemySkeleton(side, hero)
    -- log("Trigger summon and kill skeleton !")
    local n = length(GetUnits(1-side, CREATURE))
    SummonCreatureStack_X(1-side, CREATURE_SKELETON, 1, 6)
    repeat sleep(10) until length(GetUnits(1-side, CREATURE)) == n + 1
    HeroCast_Target(hero, SPELL_MAGIC_FIST, FREE_MANA, GetUnits(1-side, CREATURE)[n])
end

function Routine_SummonZombieStack(side, hero)
    -- log("Trigger summon zombies !")
    if CURRENT_UNIT == hero then
        local turns = COMBAT_TURN - ROUTINE_VARS.TurnMarker
        local n = 1 + trunc(1.5 * (GetHeroLevel(side) + turns))
        local type = random(1, 3, COMBAT_TURN)
        local id = CREATURES_BY_FACTION[NECROPOLIS][2][type]
        SummonCreatureStack(side, id, n)
        ROUTINE_VARS.TurnMarker = COMBAT_TURN
    end
end

function Routine_FirstAidLastAid(side, hero)
    -- log("Trigger healing tent plague !")
    if GetHeroSkillMastery(side, PERK_PLAGUE_TENT) == 1 then
        local tent = GetWarMachine(side, WAR_MACHINE_FIRST_AID_TENT)
        if tent then
            local x,y = GetUnitPosition(RandomCreature(1-side, GetHeroLevel(side)))
            startThread(UseCombatAbility, tent, SPELL_EFFECT_FIRST_AID_TENT_PLAGUE, x, y)
        end
    end
end

function Routine_EmbalmerManaRegen(side, hero)
    -- log("Trigger regen mana if tent !")
    if CURRENT_UNIT == hero then
        if IsCombatUnit(UNIT_SIDE_PREFIX[side]..'-warmachine-WAR_MACHINE_FIRST_AID_TENT') then
            local m = 1 + GetHeroSkillMastery(side, SKILL_DARK_MAGIC)
            local value = min(GetUnitManaPoints(hero)+m, GetUnitMaxManaPoints(hero))
            SetMana(hero, value)
        end
    end
end

function Routine_SummonAvatarOfDeath(side, hero)
    -- log("Trigger summon avatar of death !")
    local cost = 4 * GetHeroLevel(side)
    if GetUnitManaPoints(hero) >= cost then
        local units = GetUnits(side, CREATURE)
        HeroCast_Global(hero, SPELL_ABILITY_AVATAR_OF_DEATH, cost)
        sleep(100)
        ROUTINE_VARS.AvatarOfDeath = GetUnits(side, CREATURE)[length(units)]
    end
end

function Routine_AvatarDead(side, hero, unit)
    -- log("Trigger mass Sorrow on Avatar of Death's death !")
    if unit == ROUTINE_VARS.AvatarOfDeath then
        HeroCast_AllCreatures(hero, SPELL_SORROW, FREE_MANA, 1-side)
        sleep(100)
        -- SetMana(hero, GetHeroLevel(side))
    end
end

function Routine_CastMassWeakness(side, hero)
    -- log("Trigger cast mass weakness !")
    HeroCast_Global(hero, SPELL_MASS_CURSE, FREE_MANA)
end

function Routine_CastRandomIceBolt(side, hero)
    -- log("Trigger random Ice Bolt !")
    if CURRENT_UNIT == hero then
        HeroCast_RandomCreature(hero, SPELL_ICE_BOLT, 1, 1-side)
        if IsHuman(side) then SetATB_ID(hero, ATB_INSTANT) end
    end
end

function Routine_RaiseUndead(side, hero, unit)
    -- log("Trigger raise undead equivalent !")
    if GetUnitSide(unit) ~= side and ROUTINE_VARS.InitialCounts[unit] then
        local dead = GetCreatureType(unit)
        local type = CreatureToUndead(dead)
        local x,y = GetUnitPosition(unit)
        local p = 10 + GetHeroLevel(side)
        local amount = trunc(ROUTINE_VARS.InitialCounts[unit] * p * 0.01)
        SummonCreatureStack_XY(side, type, amount, x, y)
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- INFERNO

function Routine_BallistaShootUnit(side, hero)
    -- log("Trigger fireball ballista shoot !")
    if CURRENT_UNIT == UNIT_SIDE_PREFIX[side]..'-warmachine-WAR_MACHINE_BALLISTA' then
        SetATB_ID(CURRENT_UNIT, ATB_ZERO)
    elseif CURRENT_UNIT_SIDE ~= side then
        if IsCreature(CURRENT_UNIT) then
            local m = GetUnitManaPoints(hero)
            if m >= 3 then
                TargetShoot_Ballista(side, CURRENT_UNIT)
                SetMana(hero, m-3)
                ShowFlyingSign("/Text/Game/Scripts/Combat/Bombardier.txt", hero, 9)
            end
        end
    end
end

function Routine_ResetAtbOnKillHellhounds(side, hero, unit)
    -- log("Trigger reset hellhounds atb !")
    if GetUnitSide(unit) ~= GetUnitSide(hero) then
        -- SetATB_ID(CURRENT_UNIT, ATB_NEXT)
        for i,cr in GetUnits(side, CREATURE) do
            local type = GetCreatureType(cr)
            if type == CREATURE_HELL_HOUND or type == CREATURE_CERBERI or type == CREATURE_FIREBREATHER_HOUND then
                if not ROUTINE_VARS.AtbBoosted[cr] then
                    SetATB_ID(cr, ATB_INSTANT)
                    ROUTINE_VARS.AtbBoosted[cr] = not nil
                    return
                end
            end
        end
    end
end

function Routine_BoostHeroAtbOnDeath(side, hero, unit)
    -- log("Trigger reset hero atb !")
    if GetUnitSide(unit) == GetUnitSide(hero) then
        if IsCreature(unit) then
            SetATB_ID(hero, ATB_INSTANT)
        end
    end
end

function Routine_DemonicCreatureExplosion(side, hero)
    -- log("Trigger creature explosion !")
    if CURRENT_UNIT_SIDE == side then
        if IsCreature(CURRENT_UNIT) then
            local id = GetCreatureType(CURRENT_UNIT)
            if CREATURES[id][1] == INFERNO then
                local x,y = GetUnitPosition(CURRENT_UNIT)
                UnitCastAreaSpell(CURRENT_UNIT, SPELL_ABILITY_EXPLOSION, x, y)
                SetATB_ID(CURRENT_UNIT, ATB_INSTANT)
            end
        end
    end
end

function Routine_CastRandomFireball(side, hero)
    -- log("Trigger random Fireball !")
    if CURRENT_UNIT == hero then
        local mana = GetUnitManaPoints(hero)
        if mana >= 3 then
            local x,y = GetUnitPosition(RandomCreature(1-side, COMBAT_TURN))
            HeroCast_Area(hero, SPELL_FIREBALL, FREE_MANA, x, y)
            SetMana(hero, mana - 3)
            if GetHeroLevel(side) < 20 then
                ROUTINE_VARS.Incendiary = not nil
            else
                SetATB_ID(hero, ATB_INSTANT)
            end
        end
    elseif ROUTINE_VARS.Incendiary then
        ROUTINE_VARS.Incendiary = nil
        SetATB_ID(hero, 0.55)
    end
end

function Routine_CastMineFields(side, hero)
    -- log("Trigger mine fields !")
    local x = 12 - 9 * side
    HeroCast_Area(hero, SPELL_LAND_MINE, FREE_MANA, x, 9)
    HeroCast_Area(hero, SPELL_LAND_MINE, FREE_MANA, x, 3)
end

function Routine_SummonEarthElementals(side, hero)
    -- log("Trigger summon earth elementals !")
    if CURRENT_UNIT == hero then
        local nb = 3 + trunc(GetHeroLevel(side) * 0.1)
        local amount = 1 + trunc(GetHeroLevel(side) * 0.2)
        for i = 1,nb do
            SummonCreature(side, CREATURE_EARTH_ELEMENTAL, amount)
            sleep(4)
        end
    end
end

function Routine_InfernoGating(side, hero)
    -- log("Trigger inferno gating !")
    local gating_tier = 2 * GetHeroSkillMastery(side, SKILL_GATING)
    for i,cr in GetUnits(side, CREATURE) do
        local id = GetCreatureType(cr)
        if CREATURES[id][1] == INFERNO and CREATURES[id][2] <= gating_tier then
            local nb = GetCreatureNumber(cr)
            local x = random(GRID_X_MIN, GRID_X_MAX, nb)
            local y = random(GRID_Y_MIN, GRID_Y_MAX, id)
            UnitCastAreaSpell(cr, SPELL_ABILITY_GATING, x, y)
        end
    end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- STRONGHOLD

function Routine_CastRallingCry(side, hero)
    -- log("Trigger ralling cry !")
    if CURRENT_UNIT == hero then
        HeroCast_Global(hero, SPELL_WARCRY_RALLING_CRY, FREE_MANA)
        if IsHuman(side) then SetATB_ID(hero, ATB_INSTANT) end
    end
end

function Routine_CastBattlecry(side, hero)
    -- log("Trigger battlecry !")
    HeroCast_Global(hero, SPELL_WARCRY_BATTLECRY, FREE_MANA)
end

function Routine_CastCallOfBlood(side, hero)
    -- log("Trigger call of blood !")
    HeroCast_TargetCreatureTypes(hero, SPELL_WARCRY_CALL_OF_BLOOD, FREE_MANA, side, {CREATURE_ORC_WARRIOR,CREATURE_ORC_SLAYER,CREATURE_ORC_WARMONGER})
end

function Routine_CountInitialGoblins(side, hero)
    -- log("Trigger count goblins")
    local creatures = GetUnits(side, CREATURE)
    local goblins = 0
    for i,cr in creatures do
        local type = GetCreatureType(cr)
        if type == CREATURE_GOBLIN or type == CREATURE_GOBLIN_TRAPPER or type == CREATURE_GOBLIN_DEFILER then
            goblins = goblins + GetCreatureNumber(cr)
        end
    end
    ROUTINE_VARS.GoblinsTotal = trunc(0.1 * goblins)
end

function Routine_SummonGoblinStack(side, hero)
    -- log("Trigger summon goblins !")
    if CURRENT_UNIT == hero then
        SummonCreatureStack(side, CREATURE_GOBLIN, ROUTINE_VARS.GoblinsTotal)
    end
end

function Routine_WatchRageLevels(side, hero)
    -- log("Trigger watch rage levels !")
    startThread(Routine_WatchRageLevelsThread, side, hero)
end

function Routine_WatchRageLevelsThread(side, hero)
    local RageLevels = {}
    while 1 do
        local up = nil
        for i,cr in GetUnits(side, CREATURE) do
            local type = GetCreatureType(cr)
            if CREATURES[type][1] == STRONGHOLD and CREATURES[type][2] ~= 6 then
                if not RageLevels[cr] then
                    RageLevels[cr] = GetRageLevel(cr)
                else
                    if RageLevels[cr] < GetRageLevel(cr) then up = not nil end
                    RageLevels[cr] = GetRageLevel(cr)
                end
            end
        end
        if up then SetATB_ID(hero, 1) end
        sleep(100)
    end
end

function Routine_HealingTentMoveNext(side, hero)
    -- log("Trigger healing tent play next !")
    if CURRENT_UNIT == hero then
        SetATB_WarMachineType(side, WAR_MACHINE_FIRST_AID_TENT, ATB_NEXT)
    end
end

function Routine_ShamansManaRegen(side, hero)
    -- log("Trigger shamans mana !")
    if CURRENT_UNIT_SIDE == side then
        if IsCreature(CURRENT_UNIT) then
            local type = GetCreatureType(CURRENT_UNIT)
            if type == CREATURE_SHAMAN or type == CREATURE_SHAMAN_WITCH or type == CREATURE_SHAMAN_HAG then
                local n = 1 + trunc(GetHeroLevel(side) * 0.1)
                local m = GetUnitManaPoints(CURRENT_UNIT)
                SetMana(CURRENT_UNIT, m + n)
            end
        end
    end
end

function Routine_CastRandomLightningBolt(side, hero)
    -- log("Trigger cast lightning bolt !")
    if CURRENT_UNIT == hero then
        HeroCast_RandomCreature(hero, SPELL_LIGHTNING_BOLT, 1, 1-side)
        if IsHuman(side) then SetATB_ID(hero, ATB_INSTANT) end
    end
end



COMBAT_START_HERO_ROUTINES = {
    -- haven
    [H_VITTORIO] = Routine_BallistaRandomSalvo,
    [H_DOUGAL] = Routine_ArchersMoveFirst,
    [H_LASZLO] = Routine_InfantryDash,
    [H_KLAUS] = Routine_RetaliationStrike,
    [H_FREYDA] = Routine_CastPrayer,
    -- preserve
    [H_FINDAN] = Routine_HunterRandomShoot,
    [H_WYNGAAL] = Routine_MoveForwardUnits,
    [H_DIRAEL] = Routine_CastSummonHive,
    [H_VINRAEL] = Routine_CastMassHaste,
    [H_TIERU] = Routine_SummonDruidStack,
    -- fortress
    [H_WULFSTAN] = Routine_BallistaMoveFirst,
    [H_HANGVUL] = Routine_ThanesAbility,
    [H_BRAND] = Routine_CastFireWalls,
    [H_ERLING] = Routine_RunePriestsMoveFirst,
    [H_INGA] = Routine_CastEarthquake,
    -- academy
    [H_DAVIUS] = Routine_RakshasasAbility,
    [H_NUR] = Routine_CastMultipleArcaneCrystals,
    [H_CYRUS] = Routine_MagesCastMagicFist,
    [H_ZEHIR] = Routine_CastSummonElementals,
    -- dungeon
    [H_VAYSHAN] = Routine_ScoutsMoveFirst,
    [H_SYLSAI] = Routine_HeroCastRage,
    [H_RAELAG] = Routine_DragonStrike,
    [H_SHADYA] = Routine_CastRandomDeepFrost,
    -- necropolis
    [H_VLADIMIR] = Routine_SummonAndKillEnnemySkeleton,
    [H_KASPAR] = Routine_FirstAidLastAid,
    [H_THANT] = Routine_CastMassWeakness,
    [H_ARCHILUS] = Routine_SummonAvatarOfDeath,
    -- inferno
    [H_DELEB] = Routine_CastMineFields,
    [H_KHABELETH] = Routine_InfernoGating,
    -- stronghold
    [H_GOTAI] = Routine_CastBattlecry,
    [H_KILGHAN] = Routine_CountInitialGoblins,
    [H_TELSEK] = Routine_CastCallOfBlood,
    [H_HAGGASH] = Routine_WatchRageLevels,
}

COMBAT_TURN_HERO_ROUTINES = {
    -- haven
    [H_MAEVE] = Routine_PeasantsMoveNext,
    [H_GABRIELLE] = Routine_GriffinInstantDive,
    [H_GODRIC] = Routine_CastRandomStoneskin,
    -- preserve
    [H_JENOVA] = Routine_HeroMoveNext,
    [H_DIRAEL] = Routine_SpriteManaLink,
    [H_TIERU] = Routine_DruidsMoveNext,
    [H_MELODIA] = Routine_AllRegeneration,
    -- fortress
    [H_KARLI] = Routine_SpearWielderCoordination,
    [H_HEDWIG] = Routine_DwavenDefendOrder,
    -- academy
    [H_NATHIR] = Routine_BallistaMoveNext,
    [H_RISSA] = Routine_TimeShift,
    -- dungeon
    [H_DARKSTORM] = Routine_MinotaursMoveNext,
    [H_SORGAL] = Routine_RidersHydraSynergy,
    [H_ERUINA] = Routine_RefreshMatronMana,
    -- necropolis
    [H_KASPAR]= Routine_EmbalmerManaRegen,
    [H_ORSON] = Routine_SummonZombieStack,
    [H_ORNELLA] = Routine_CastRandomIceBolt,
    -- inferno
    [H_SHELTEM] = Routine_BallistaShootUnit,
    [H_MALUSTAR] = Routine_DemonicCreatureExplosion,
    [H_AGRAEL] = Routine_CastRandomFireball,
    [H_DELEB] = Routine_SummonEarthElementals,
    -- stronghold
    [H_KRAGH] = Routine_CastRallingCry,
    [H_KILGHAN] = Routine_SummonGoblinStack,
    [H_ZOULEIKA] = Routine_HealingTentMoveNext,
    [H_KUJIN] = Routine_ShamansManaRegen,
    [H_MUKHA] = Routine_CastRandomLightningBolt,
}

UNIT_DIED_HERO_ROUTINES = {
    -- haven
    [H_GABRIELLE] = Routine_GriffinDead,
    -- preserve
    [H_TALANAR] = Routine_ResetAtbOnKillEnraged,
    [H_IVOR] = Routine_WolfDeadRevenge,
    -- fortress
    -- academy
    -- dungeon
    [H_SYLSAI] = Routine_SummonDeadEnnemyCreature,
    -- necropolis
    [H_ARCHILUS] = Routine_AvatarDead,
    [H_SANDRO] = Routine_RaiseUndead,
    -- inferno
    [H_GRAWL] = Routine_ResetAtbOnKillHellhounds,
    [H_ASH] = Routine_BoostHeroAtbOnDeath,
    -- stronghold
}


function DoHeroSpeRoutine_CombatStart(side, name, id)
    if COMBAT_START_HERO_ROUTINES[name] then
        COMBAT_START_HERO_ROUTINES[name](side, id)
    end
end

function DoHeroSpeRoutine_CombatTurn(side, name, id)
    if COMBAT_TURN_HERO_ROUTINES[name] then
        COMBAT_TURN_HERO_ROUTINES[name](side, id)
    end
end

function DoHeroSpeRoutine_UnitDied(side, name, id, unit)
    if UNIT_DIED_HERO_ROUTINES[name] then
        UNIT_DIED_HERO_ROUTINES[name](side, id, unit)
    end
end


-- log("Loaded heroes-routines-combat.lua")
ROUTINES_LOADED[11] = 1
