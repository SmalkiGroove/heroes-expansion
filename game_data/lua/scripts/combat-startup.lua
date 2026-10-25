function StopTrigger() end --needed for lualib
dofile = doFile
dofile('/scripts/config.lua')

function IsHuman(side) return GetHost(side) == HUMAN end
function IsComputer(side) return GetHost(side) == COMPUTER end

MODE_NORMAL = 0
MODE_MANUAL = 1
MODE_AUTO = 2

ATTACKER = 0
DEFENDER = 1

HERO = 0
CREATURE = 1
WAR_MACHINE = 2
BUILDING = 3
SPELL_SPAWN = 4

function IsAttacker(unit) return GetUnitSide(unit) == ATTACKER end
function IsDefender(unit) return GetUnitSide(unit) == DEFENDER end
function IsHero(unit) return GetUnitType(unit) == HERO end
function IsCreature(unit) return GetUnitType(unit) == CREATURE end
function IsWarMachine(unit) return GetUnitType(unit) == WAR_MACHINE end
function IsBuilding(unit) return GetUnitType(unit) == BUILDING end
function IsSpellSpawn(unit) return GetUnitType(unit) == SPELL_SPAWN end

ATTACKER_HERO_ID = "attacker-hero"
DEFENDER_HERO_ID = "defender-hero"
ATTACKER_HERO = ""
DEFENDER_HERO = ""


function GetHero(side)
	local units = GetUnits(side, HERO)
	for index, unit in units do
		return unit
	end
	return nil
end
-- Warning!!! Do not remove variables 'temp' in these functions:
-- due the lua engine error game may (and probably will) crash.
function GetCreatures(side) local temp = GetUnits(side, CREATURE) return temp end
function GetWarMachines(side) local temp = GetUnits(side, WAR_MACHINE) return temp end
function GetBuildings(side) local temp = GetUnits(side, BUILDING) return temp end
function GetSpellSpawns(side) local temp = GetUnits(side, SPELL_SPAWN) return temp end

function GetAttackerHero() local temp = GetHero(ATTACKER) return temp end
function GetDefenderHero() local temp = GetHero(DEFENDER) return temp end
function GetAttackerCreatures() local temp = GetCreatures(ATTACKER) return temp end
function GetDefenderCreatures() local temp = GetCreatures(DEFENDER) return temp end
function GetAttackerWarMachines() local temp = GetWarMachines(ATTACKER) return temp end
function GetDefenderWarMachines() local temp = GetWarMachines(DEFENDER) return temp end
function GetAttackerBuildings() local temp = GetBuildings(ATTACKER) return temp end
function GetDefenderBuildings() local temp = GetBuildings(DEFENDER) return temp end
function GetAttackerSpellSpawns() local temp = GetSpellSpawns(ATTACKER) return temp end
function GetDefenderSpellSpawns() local temp = GetSpellSpawns(DEFENDER) return temp end

function GetWarMachine(side, type)
	local units = GetWarMachines(side)
	for index, unit in units do
		if GetWarMachineType(unit) == type then
			return unit
		end
	end
	return nil
end
function GetAttackerWarMachine(type) local temp = GetWarMachine(ATTACKER, type) return temp end
function GetDefenderWarMachine(type) local temp = GetWarMachine(DEFENDER, type) return temp end

function GetBuilding(side, type)
	local units = GetBuildings(side)
	for index, unit in units do
		if GetBuildingType(unit) == type then
			return unit
		end
	end
	return nil
end
function GetAttackerBuilding(type) local temp = GetBuilding(ATTACKER, type) return temp end
function GetDefenderBuilding(type) local temp = GetBuilding(DEFENDER, type) return temp end


function createCombatAliases()

	BUILDING_WALL = 1
	BUILDING_GATE = 2
	BUILDING_LEFT_TOWER = 3
	BUILDING_BIG_TOWER = 4
	BUILDING_MOAT = 5
	BUILDING_RIGHT_TOWER = 6
	BUILDING_MAGIC_WALL = 7

    --
    -- Animation Action Types
    --
    --INVISIBLE = 0
    IDLE = 1
    ONESHOT_STILL = 2
    ONESHOT = 3
    --MOVE = 4
    NON_ESSENTIAL = 5

    --
    -- dumb command aliasing
    --
    ExecConsoleCommand = consoleCmd

    ShowCombatHighlighting = showHighlighting

    MoveCombatUnit = commandMove
    AttackCombatUnit = commandMoveAttack
    ShootCombatUnit = commandShot
    UseCombatAbility = commandDoSpecial
    DefendCombatUnit = commandDefend
    GetCombatPosition = pos
    SetCombatPosition = displace
    IsCombatUnit = exist
    AddCombatUnit = addUnit
    RemoveCombatUnit = removeUnit
end

function createTutorialAliases()
    ShowTutorialMessage = showMessage
    HideTutorialMessage = clearMessage
end

dofile("/scripts/common.lua") sleep()
dofile("/scripts/combat-manager.lua") sleep()

function DoPrepare()
	ManageCombatPrepare()
	return nil
end

function DoStart()
	ManageCombatStart()
	return nil
end

-- nil: the unit's turn is played normally (player or AI); not nil would mean the script played it
function UnitMove(unitName)
	ManageCombatTurn(unitName)
	return nil
end

-- Called by the H5X DLL after each attack (creature, war machine, hero): defined here so the call never reads a nil global
function UnitAttack(attacker, defender) end

function UnitDeath(unitName)
	ManageUnitDeath(unitName)
end

EnableCinematicCamera(nil)
