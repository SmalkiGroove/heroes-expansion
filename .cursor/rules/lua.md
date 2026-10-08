---
globs: game_data/lua/**/*.lua
alwaysApply: false
---
# Heroes 5 Mod: Lua scripts instructions

The game supports lua 4.0 scripts without any library available (no math or table functions for example).

There are two script runtimes in the game:

- one for adventure map that is loaded when a new game is started, and terminted when the game ends. When a saved game is loaded, the script state and data are restored and the script execution is resumed. This runtime is used for scripts that implement custom mechanics on the adventure map, such as custom hero abilities, or custom events that happen on the adventure map.
- one for combat that is loaded when a battle starts, and terminated when the battle ends. It does not have access to any variable defined in the adventure map scripts and has a separate set of function supported by the game engine. This runtime is used for scripts that implement custom mechanics in battles, such as custom creature abilities, or custom events that happen during battles.


## Entry point

When starting a game, the game engine runs `/scripts/advmap-startup.lua`. The mod contains a modified version of this script that uses `dofile` instructions to load other script files. The `dofile` instruction is threaded and is sometimes followed by `sleep` commands to pause the main thread while it loads variables and function definitions from the loaded scripts.

When engaging a combat during the game, the game engine runs `/scripts/combat-startup.lua`. The mod also contains a modified version of this script that loads other script files in a similar way to the adventure map startup script.

## Available functions

The game engine provides a set of functions that can be used in the scripts to interact with the game state and implement custom mechanics. There are functions for the adventure map runtime and other functions for the combat runtime.

### Adventure map functions

The adventure map runtime provides the following predefined functions for interacting with the game state:

#### Hero Management

- `GetHeroStat(hero, stat)` → number: Get a hero's base stat value (attack, defense, knowledge, spell power, etc)
- `ChangeHeroStat(hero, stat, amount)` → void: Modify a hero stat by a given amount (positive or negative)
- `GetHeroLevel(hero)` → number: Get hero's current level
- `LevelUpHero(hero)` → void: Force hero to level up immediately
- `GetHeroCreatures(hero, creature)` → number: Get count of a specific creature type in hero's army
- `AddHeroCreatures(hero, creature, count, slot)` → void: Add creatures to hero's army at specified slot (-1 for first available)
- `RemoveHeroCreatures(hero, creature, count)` → void: Remove specific creatures from hero's army
- `GetHeroCreaturesTypes(hero)` → creature1, creature2, ...: Return all creature types in hero's army
- `GiveHeroWarMachine(hero, warMachine)` → void: Give hero a war machine (ballista, first aid tent, ammo cart)
- `GiveHeroBattleBonus(hero, bonusType, amount)` → void: Provide hero with battle bonus
- `IsHeroInBoat(hero)` → boolean: Check if hero is currently in a boat
- `IsHeroInTown(hero, town, checkOwner, radius)` → boolean: Check if hero is in/near town

#### Skills and Spells

- `HasHeroSkill(hero, skill)` → boolean: Check if hero has a specific skill learned
- `GetHeroSkillMastery(hero, skill)` → number: Get skill mastery level
- `GiveHeroSkill(hero, skill)` → void: Teach hero a skill
- `TeachHeroSpell(hero, spell)` → void: Teach hero a spell
- `KnowHeroSpell(hero, spell)` → boolean: Check if hero knows a specific spell

#### Artifacts and Items

- `GiveArtifact(hero, artifact, quantity)` → void: Give artifact to hero
- `GiveArtefact(hero, artifact, quantity)` → void: Alternate spelling - Give artifact to hero
- `RemoveArtefact(hero, artifact)` → void: Remove artifact from hero's inventory
- `HasArtefact(hero, artifact, quantity)` → boolean: Check if hero has artifact(s)
- `GetHeroArtifactsCount(hero, artifact)` → number: Count of specific artifact type hero possesses
- `GetArtifactSetItemsCount(hero, set, checkEquipped)` → number: Count artifacts from set hero possesses

#### Custom Abilities

- `ControlHeroCustomAbility(hero, abilityIndex, value)` → void: Enable/disable hero custom ability
  - value: 0 = disabled, 1 or CUSTOM_ABILITY_ENABLED = enabled

#### Player and Resource Management

- `GetPlayerResource(player, resourceType)` → number: Get player's resource amount
- `SetPlayerResource(player, resourceType, amount)` → void: Set player's resource to exact amount
- `GiveExp(hero, amount)` → void: Give experience directly to hero
- `GetPlayerHeroes(player)` → table: Get list of all heroes owned by player
- `GetPlayerState(player)` → number: Get player state (1 = active/present)
- `GetCurrentPlayer()` → number: Get currently active player number
- `IsPlayerCurrent(player)` → boolean: Check if player is currently active
- `IsAIPlayer(player)` → boolean: Check if player is AI controlled
- `IsHumanPlayer(player)` → boolean: Check if player is human controlled

#### Town and Building Management

- `GetTownHero(town)` → string or nil: Name of the hero garrisoned in the town, or nil if there is none
- `GetTownBuildingLevel(town, building)` → number: Get building upgrade level (0 = not built, 1+ = upgrade levels)
- `UpgradeTownBuilding(town, building)` → void: Build or upgrade town building one level
- `TransformTown(town, townType)` → void: Convert town to different faction
- `ReplaceDwelling(dwelling, townType)` → void: Convert dwelling/structure to different faction
- `AllowHeroHiringByRaceInTown(town, raceType, enabled)` → void: Control which races can be hired in tavern
- `AllowPlayerTavernRace(player, raceType, enabled)` → void: Control which races player can hire in taverns
- `GetObjectDwellingCreatures(town, creature)` → number: Get recruitment count available in town dwelling
- `SetObjectDwellingCreatures(town, creature, amount)` → void: Set recruitment count in town dwelling
- `GetObjectCreature(object, creature)` → number: Get creature count in object
- `GetObjectCreatures(object, creature)` → number: Get creature count from map object

#### Map Objects and Interactions

- `GetObjectPosition(object)` → x, y, z: Get object's map position
- `SetObjectPosition(object, x, y, z, effect)` → void: Move object to new position with optional effect
- `GetObjectOwner(object)` → number: Get owning player of object (0 = neutral/unowned)
- `GetObjectNamesByType(type)` → table: Get list of all object names of given type
- `IsObjectExists(object)` → boolean: Check if object still exists on map
- `RemoveObject(object)` → void: Remove object from map
- `SetObjectEnabled(object, enabled)` → void: Enable/disable object
- `MakeHeroInteractWithObject(hero, object)` → void: Force hero to interact with object
- `MarkObjectAsVisited(object, hero)` → void: Mark object as visited for hero/player
- `AddObjectCreatures(object, creature, count)` → void: Add creatures to map object
- `RemoveObjectCreatures(object, creature, count)` → void: Remove creatures from map object

#### Combat and Army

- `GetSavedCombatArmyCreaturesCount(combatIndex, side)` → number: Get number of creature stacks in saved combat
- `GetSavedCombatArmyCreatureInfo(combatIndex, side, stackIndex)` → creature, count, died: Get creature info from combat save

#### World and Environment

- `GetTerrainSize()` → number: Get map dimensions
- `GetMaxFloor()` → number: Get maximum floor/underworld level
- `GetDate(dateType)` → number: Get game date component (DAY_OF_WEEK, etc)
- `GetDifficulty()` → number: Get game difficulty level
- `IsTilePassable(x, y, floor)` → boolean: Check if map tile is walkable
- `OpenCircleFog(x, y, z, radius, player)` → void: Reveal circular area of map for player

#### Caravans and Logistics

- `CreateCaravan(name, player, startZ, startX, startY, endZ, endX, endY)` → void: Create caravan for reinforcements

#### UI and Messages

- `QuestionBoxForPlayers(playerFilter, text, confirmFunction, cancelFunction)` → void: Show dialog with yes/no options
  - confirmFunction and cancelFunction are string callbacks to execute
- `MessageBoxForPlayers(playerFilter, text, onCloseFunction)` → void: Show message dialog
  - onCloseFunction is a string callback to execute
  - `text` (here and in `QuestionBoxForPlayers` / `ShowFlyingSign`) is either a text file path or a table `{"/Text/...txt"; key=value, ...}` whose values fill the `<value=key>` placeholders of the file. A value can itself be another text file path (e.g. an artifact name file)
- `ShowFlyingSign(text, hero, player, duration)` → void: Display floating text above hero/object
- `GetPlayerFilter(player)` → filter: Get filter to target specific player for UI functions

#### Triggers and Events

- `Trigger(triggerType, object, functionName)` → void: Set/remove event trigger on object
  - functionName is a string callback; passing nil removes the trigger

#### Console and runtimes communication

- `GetGameVar(variable)` → value: Get value of gamevar registered. The gamevar is not a lua variable
- `SetGameVar(variable, value)` → void: Register gamevar for sharing with combat runtime. The gamevar is not a lua variable
- `consoleCmd(command)` → void: Execute console command as string
- `ExecConsoleCommand(command)` → void: Alternate spelling - Execute console command as string

#### Threading and Execution

- `startThread(function, arg1, arg2, ...)` → void: Start async thread executing function with arguments
  - Function can be provided as reference or callback
- `sleep(milliseconds)` → void: Pause execution for specified milliseconds

#### Logging and Debugging

- `print(message)` → void: Write to game console
  - a `log` table is defined in `common.lua` with `log.error`, `log.warn`, `log.info`, `log.debug` and `log.trace` (each takes a string). They are no-ops until `log.SetLogLevel(level)` enables them (1 = error ... 5 = trace), then print with a `[LEVEL]` prefix. By convention every mod function starts with `log.trace("/scripts/<path>.lua: FunctionName")`

#### Utility Functions (Limited Lua)

The game provides mathematical and table functions since Lua 4.0 standard libraries are not available:

- `contains(table, value)` → boolean: Check if table contains value
- `insert(table, value)` → void: Add value to table
- `length(table)` → number: Get table length
- `random(min, max, seed)` → number: Get random number in range (defined in `common.lua`). It is a deterministic generator over the global `RANDOM_SEED`; the optional `seed` is *added* to `RANDOM_SEED` and every call mutates it, so two calls with the same seed still return different values
- `power(base, exponent)` → number: Raise base to exponent
- `mod(dividend, divisor)` → number: Get remainder of division
- `round(value)` → number: Round to nearest integer
- `ceil(value)` → number: Round up to integer
- `trunc(value)` → number: Truncate to integer
- `min(a, b)` → number: Return minimum of two values
- `max(a, b)` → number: Return maximum of two values
- `abs(value)` → number: Return absolute value

### Combat functions

The combat runtime provides the following predefined functions for implementing combat mechanics and handling battles:

#### Unit Queries

- `GetUnits(side, type)` → table: Returns array of all units on given side filtered by type
  - side: ATTACKER (0) or DEFENDER (1)
  - type: CREATURE, HERO, WAR_MACHINE, BUILDING, or SPELL_SPAWN
- `GetUnitSide(unit)` → number: Returns ATTACKER (0) or DEFENDER (1) identifying unit's side
- `GetUnitType(unit)` → number: Returns unit type constant (HERO, CREATURE, WAR_MACHINE, BUILDING, SPELL_SPAWN)
- `GetUnitPosition(unit)` → x, y: Returns grid coordinates of unit on battlefield
- `GetHeroName(hero_id)` → string: Get hero's name from combat unit ID
  - Parameters: "attacker-hero" or "defender-hero"
- `GetCreatureType(unit)` → number: Returns CREATURE_* constant identifying creature type
- `GetCreatureNumber(unit)` → number: Returns stack count - total number of creatures in unit
- `GetWarMachineType(unit)` → number: Returns WAR_MACHINE_* constant (BALLISTA=1, CATAPULT=2, FIRST_AID_TENT=3, AMMO_CART=4)
- `GetBuildingType(unit)` → number: Returns BUILDING_* constant for defensive building type
- `GetHost(side)` → number: Returns HUMAN (0) or COMPUTER (1) indicating player type controlling side
- `exist(unit)` → truthy/nil: Returns non-nil if unit exists in combat, nil if dead/removed

#### Unit Mana and Energy

- `GetUnitManaPoints(unit)` → number: Returns current mana points of unit
- `GetUnitMaxManaPoints(unit)` → number: Returns maximum mana capacity of unit
- `SetUnitManaPoints(unit, value)` → void: Sets unit's mana to exact value (may require retry loop with sleep() for reliability)
- `GetRageLevel(unit)` → number: Get rage level of unit (Stronghold exclusive creature mechanic)

#### Unit Spawning and Removal

- `AddCreature(side, creature_type, count, x, y, param6, name)` → void: Spawns creature stack at grid position
  - Follow with repeat sleep() until exist(name) returns true
- `SummonCreature(side, creature_type, amount, x, y, param6, name)` → void: Creates summoned creature group in combat (for spell-summoned units)
- `RemoveCombatUnit(unit)` → void: Removes unit from combat (despawn/deletion)

#### Spellcasting

- `UnitCastAimedSpell(caster, spell_id, target_unit)` → void: Cast targeted spell from caster on target unit
- `UnitCastAreaSpell(caster, spell_id, x, y)` → void: Cast area-effect spell at grid coordinates
- `UnitCastGlobalSpell(caster, spell_id)` → void: Cast global spell affecting entire battlefield without targeting
- `UseCombatAbility(unit, ability_id, [x], [y])` → void: Trigger ability (active or passive)
  - Parameters x, y optional based on ability type

#### Movement and Attacks

- `MoveCombatUnit(unit, x, y)` → void: Move unit to grid position without attacking
  - Callback-compatible for use with startThread
- `ShootCombatUnit(attacker, target)` → void: Ranged attack on target unit
  - Callback-compatible - example: startThread(ShootCombatUnit, ballista, enemy)
- `AttackCombatUnit(attacker, target)` → void: Melee attack on target unit
- `DefendCombatUnit(unit)` → void: Set unit into defend/guard stance

#### Animation and Effects

- `playAnimation(unit, animation_name, action_type)` → void: Play animation on unit
  - animation_name: "cast", "happy", "hit", etc.
  - action_type: ONESHOT, IDLE, NON_ESSENTIAL, ONESHOT_STILL
  - Example: playAnimation(unit, "cast", ONESHOT) sleep(500)
- `ShowFlyingSign(text_file_path, unit, duration_frames)` → void: Display floating text above unit
  - text_file_path: e.g., "/Text/Game/Scripts/Combat/TextKey.txt"
  - duration typically in frames (e.g., 9 frames)

#### Turn Order (ATB System)

- `setATB(unit, value)` → void: Set unit's turn order value (0.0-2.0+)
  - Key values: ATB_INSTANT=1 (next turn), ATB_NEXT=0.999 (soon), ATB_HALF=0.5 (medium), ATB_ZERO=0 (just moved)
  - Accepts decimals for fine control

#### Combat Control

- `combatSetPause(flag)` → void: Pause/unpause combat execution
  - flag: 1=pause, nil=unpause
  - Used for synchronized spell timing
- `EnableAutoFinish(flag)` → void: Enable/disable automatic combat completion when winner determined
- `EnableCinematicCamera(flag)` → void: Toggle cinematic camera mode
- `combatPlayEmotion(side, emotion_id)` → void: Play emotional animation for entire combat side
  - side: ATTACKER or DEFENDER
  - emotion_id: integer constant

#### Game Variables and State

- `GetGameVar(variable)` → value: Get value of gamevar registered. The gamevar is not a lua variable
- `SetGameVar(variable, value)` → void: Register gamevar for sharing with adventure map runtime. The gamevar is not a lua variable
- `consoleCmd(command)` → void: Execute console command as string

#### Threading and Timing

- `startThread(function, arg1, arg2, ...)` → void: Start async thread execution
  - All combat movement/spell functions are callback-compatible
  - Example: startThread(DoCastTargetSpell, hero, SPELL_MAGIC_ARROW, 10, target)
- `sleep([milliseconds])` → void: Pause execution
  - milliseconds optional (default 1)
  - Examples: sleep() for 1ms, sleep(500) for 500ms

#### Logging and Debugging

- `print(message)` → void: Write to game console
  - a `log` table is defined in `common.lua` with `log.error`, `log.warn`, `log.info`, `log.debug` and `log.trace` (each takes a string). They are no-ops until `log.SetLogLevel(level)` enables them (1 = error ... 5 = trace), then print with a `[LEVEL]` prefix. By convention every mod function starts with `log.trace("/scripts/<path>.lua: FunctionName")`

#### Utility Functions (Limited Lua)

The game provides mathematical and table functions since Lua 4.0 standard libraries are not available:

- `contains(table, value)` → boolean: Check if table contains value
- `insert(table, value)` → void: Add value to table
- `length(table)` → number: Get table length
- `random(min, max, seed)` → number: Get random number in range (defined in `common.lua`). It is a deterministic generator over the global `RANDOM_SEED`; the optional `seed` is *added* to `RANDOM_SEED` and every call mutates it, so two calls with the same seed still return different values
- `power(base, exponent)` → number: Raise base to exponent
- `mod(dividend, divisor)` → number: Get remainder of division
- `round(value)` → number: Round to nearest integer
- `ceil(value)` → number: Round up to integer
- `trunc(value)` → number: Truncate to integer
- `min(a, b)` → number: Return minimum of two values
- `max(a, b)` → number: Return maximum of two values
- `abs(value)` → number: Return absolute value


## Events

Some game events allow to trigger custom scripts when they happen. In the adventure map, they are defined by a set of available triggers that we can bind to a function call. In combat, the engine directly executes some predefined functions when certain events happen.

### Adventure map events

The types of triggers that are supported are:

- `NEW_DAY_TRIGGER`: every time a new in-game day begins
- `PLAYER_ADD_HERO_TRIGGER`: when a hero is recruited by a player
- `PLAYER_REMOVE_HERO_TRIGGER`: when a hero is removed from a player
- `OBJECTIVE_STATE_CHANGE_TRIGGER`: when the state of an objective changes
- `OBJECT_TOUCH_TRIGGER`: when an object is interacted with by a hero
- `OBJECT_CAPTURE_TRIGGER`: when an object is captured by a hero
- `REGION_ENTER_AND_STOP_TRIGGER`: when entering a region and stopping
- `REGION_ENTER_WITHOUT_STOP_TRIGGER`: when entering a region without stopping
- `HERO_LEVELUP_TRIGGER`: when a hero levels up
- `WAR_FOG_ENTER_TRIGGER`: when entering the war fog
- `COMBAT_RESULTS_TRIGGER`: after every battle
- `CUSTOM_ABILITY_TRIGGER`: when a custom ability is used
- `REGION_EXIT_TRIGGER`: when exiting a region
- `HERO_ADD_SKILL_TRIGGER`: when a new skill is learnt by a hero
- `HERO_REMOVE_SKILL_TRIGGER`: when a skill is removed from a hero
- `HERO_TOUCH_TRIGGER`: when a hero is touched

Refer to [Trigger and events](#triggers-and-events) to see how to bind a function to a trigger.

### Combat events

When the game transitions from adventure map screen to combat screen, after loading `combat-startup.lua`, the engine calls the `DoPrepare()` function from this script.

When the player has finished placing its units and starts the combat, the engine calls the `DoStart()` function from `combat-startup.lua`.

For every unit turn in combat, the engine calls the `UnitMove(unit)` function from `combat-startup.lua`, with `unit` being a generated identifier of the unit.

When a unit dies, the engine calls the `UnitDeath(unit)` function from `combat-startup.lua`, with `unit` being a generated identifier of the unit.

From each of these functions, we can call other functions defined in the loaded scripts to implement custom mechanics that should happen when these events are triggered.


## Fetch data from adventure map script in combat script

Since the combat script runtime is separate from the adventure map script runtime, we cannot directly access any variable defined in the adventure map scripts. However, we can use the `Register(variable, value)` function to register any variable from the adventure map scripts that we want to access in the combat scripts. This function allows us to store a variable in a way that it can be accessed from the combat runtime when a combat starts.

## Mod conventions and helpers

### Lua 4 gotchas

- Iterate tables with `for k,v in t do` (no `pairs`/`ipairs`). Numeric loops `for i = 1,n do` work as usual.
- There is no `#` operator: use `length(t)`. `insert(t, v)` builds 1-based arrays.
- Functions cannot read local variables of an enclosing function (no closures over locals): pass them as arguments instead (e.g. `startThread(func, arg1, arg2)`).
- Booleans are `nil` / non-nil: `Prompt` returns `1` or `nil`, `HasHeroSkill` and similar return non-nil or `nil`.

### Coding style

- Every function starts with `log.trace("/scripts/<path>.lua: FunctionName")`, optionally followed by a `log.debug(...)`.
- Feature-specific effects are written as one small function per effect, then registered in dispatch tables declared at the bottom of the file (e.g. `START_TRIGGER_HERO_ROUTINES`, `DUEL_SKILL_STAGING_EFFECTS`).
- Heroes are always referenced with the `H_*` constants of `game/heroes.lua`: the script name of a hero often differs from its display name (`H_DOUGAL = 'Orrin'`, `H_KRAGH = 'Hero1'`).

### Adventure map helpers (`advmap/advmap-utils.lua`)

- `GiveResources(player, res, amount, now)`: with `now`, resources are given immediately. Without it, the amount is added to `DAILY_RESOURCES[player]` and only paid when `PlayerDailyResources(player)` runs.
- `TakeAwayResources(player, res, amount)`, `AddHeroStatAmount(player, hero, stat, amount)`, `GetHeroLowestStat(hero)`, `GetHeroHighestStat(hero)`.
- `Popup(player, msg)`: message box that waits until `player` is the current player. `Prompt(player, msg)`: yes/no box that blocks and returns `1` (yes) or `nil` (no).
- `GetHeroArmy(hero)` → table of the 7 slot creature types (0 or nil for empty slots).
- `AddHeroCreatureType(player, hero, faction, tier, nb, default)`: adds `nb` creatures to the existing stack of that faction tier (base or upgraded); if none, adds `CREATURES_BY_FACTION[faction][tier][default]` (`default = 0` means add nothing). Prefer it over `AddHeroCreatures` for faction creatures.
- `CountHeroCreatureType(player, hero, faction, tier)`, `UpgradeHeroCreatures(player, hero, base, upgrade)`, `AddHeroCreaturePerLevel(player, hero, creature, coef)`.
- `TeachHeroRandomSpell(player, hero, school, maxtier)`, `TeachHeroRandomSpellTier(player, hero, school, tier)` (`SPELL_SCHOOL_ANY` for any school), `GiveHeroRandomArtifact(player, hero, class, set)`, `AddHeroManaUnbound(player, hero, amount)` (mana above the maximum).
- `GetHeroTowns`, `AddHeroTownRecruits`, `TransferCreatureFromTown` and `TransformTownRecruits` rely on the town data registered at game start (`MAP_TOWNS`). They do not work in duel mode.

### Game data tables (`game/*.lua`, `texts.lua`)

- `CREATURES_BY_FACTION[faction][tier] = {base, upgrade1, upgrade2}`; `GetFaction(creature)`, `GetTier(creature)`, `GetGrowth(creature)`.
- `ARTIFACTS_DATA[artifact] = {class, slot, set, special}` (`special = 1` artifacts are excluded from random rewards).
- `SPELLS_BY_TIER[tier]`, `SPELLS_BY_SCHOOL[school]`, `RUNIC_SPELLS[rune] = tier`.
- `texts.lua` maps IDs to text files: `RESOURCE_NAME_FILE`, `ATTRIBUTE_NAME_FILE`, `ARTIFACT_NAME_FILE`, `WAR_MACHINE_NAME_FILE`. Use them as message values to display names.

### Hero routines

`advmap/routines/heroes-routines-advmap.lua` holds the hero specialization routines, dispatched by hero through these tables: `START_TRIGGER_HERO_ROUTINES`, `DAILY_TRIGGER_HERO_ROUTINES`, `WEEKLY_TRIGGER_HERO_ROUTINES`, `LEVEL_UP_HERO_ROUTINES_HERO`, `AFTER_COMBAT_TRIGGER_HERO_ROUTINES` and `CONTINUOUS_TRIGGER_HERO_ROUTINES` (run in a loop by `WatchPlayer` while the player is active). Skills and artifacts follow the same pattern in their own routine files.

### Text files

- Script texts are UTF-16 LE files with BOM and CRLF line endings, without a trailing newline.
- Popup format: `<h3>Title:<body>`, an empty line, then the body with `<value=key>` placeholders.
- Duel popups live in `game_texts/texts-duel-EN/Text/Duel/{Skill,Artifact,Hero}/` (EN first, other languages translated afterwards).


## Duel mode

The duel map reuses the adventure map runtime with its own scripts (`/scripts/duel.lua` and `/scripts/duel/*.lua`), loaded only in duel mode.

### Detection and difficulty

`DUEL_MODE` is `-1` on regular maps, otherwise the difficulty level (0 to 3). Test it with `IsDuelMode()`. "Per difficulty level" in duel descriptions means `DUEL_MODE`.

### What runs and what does not

- Disabled: the new day handler (no daily/weekly routines), `WatchPlayer` (no continuous routines, no `ScanHeroArtifacts`, so `HERO_ARTFSETS_PIECES` is never updated: use `GetArtifactSetItemsCount` instead), after-combat routines (`CombatResultsHandler` calls `DuelAfterCombat`), town registration (`MAP_TOWNS` stays empty), town visit triggers and map object overrides.
- Still running: start routines (`DoHeroSpeRoutine_Start`...), level-up routines (`LEVEL_UP_HERO_ROUTINES_HERO`...) and skill triggers (which also call `DuelAddSkill`).
- To replace a regular routine by a duel version, remove its entry from the routine table in a duel script (e.g. `LEVEL_UP_HERO_ROUTINES_HERO[H_ZOULEIKA] = nil`, or `DUEL_SKILL_OVERRIDE` for skill start routines).

### Stages and effect tables

Stages are START → SETUP → ADVENTURE → STAGING → CASTLE → BATTLE → END (`DuelNextStage`). Each stage entry point in `duel.lua` dispatches effect tables:

| Stage / event | Hero effects (`duel_heroes.lua`) | Skill / artifact effects |
|---|---|---|
| Setup starts (`DuelSetup`) | `DUEL_HERO_SETUP_EFFECTS` | |
| Adventure starts (`DuelAdventure`) | `DUEL_HERO_ADVENTURE_EFFECTS` | `DUEL_SKILL_ADVENTURE_EFFECTS` |
| Each adventure day ends (`DuelAdventureDay`) | `DUEL_HERO_ADVENTURE_DAY_EFFECTS` | |
| Level up (`DuelLevelUp`) | `DUEL_HERO_LEVELUP_EFFECTS` | `DUEL_SKILL_LEVELUP_EFFECTS` |
| Skill learnt (`DuelAddSkill`) | | `DUEL_SKILL_LEARNT_EFFECTS` |
| Staging = end of adventure (`DuelStaging`) | `DUEL_HERO_STAGING_EFFECTS` | `DUEL_SKILL_STAGING_EFFECTS`, `DUEL_ARTIFACT_STAGING_EFFECTS` |
| Castle starts (`DuelCastle`) | `DUEL_HERO_CASTLE_EFFECTS` | |
| Battle starts (`DuelBattle`) | | `DUEL_SKILL_BATTLE_EFFECTS` |

Effect functions have the signature `DuelXxx(player, hero)` (`DuelXxx(player, hero, level)` for level-up effects) and end with a `Popup(player, {"/Text/Duel/...txt"; ...})` describing what was gained.

### Duel data

- `DUEL_HERO[player]`, `DUEL_FACTION[player]`, `DUEL_TOWN[player]` / `DuelPlayerTown(player)`.
- `DUEL_CREATURE_GROWTH[faction][creature]`: weekly growth of the faction base creatures ("weekly growth" in descriptions).
- `DUEL_TOWN_RECRUITS[player][creature]`: mirror of the town dwellings. Always modify town recruits with `DuelAddTownRecruits(player, creature, nb)` so both stay in sync.
- `DUEL_ADVENTURE_DAYS` (base amount of days), `DUEL_PLAYER_DATA.ADVENTURE_DAYS[player]` (remaining days, can be increased), `DUEL_PLAYER_DATA.TOTAL_EXP[player]` (hero experience at staging).
- `DUEL_DOLMEN_MAX_LEVEL` and `DUEL_DOLMEN_LEVELS[player]`: decrease the latter to grant extra Dolmen uses.

### Pitfalls

- `DuelStartingBonus` removes the hero's first artifact at game start: give start-of-game artifacts at the setup stage.
- At staging, give gold with `GiveResources` without `now`: `DuelStaging` pays it through `PlayerDailyResources`. In other stages, use `now = 1`.
- Hero staging effects run before skill and artifact staging effects.
