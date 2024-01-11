
INIT_SCRIPTS = 0

function InitMessage(player)
	if INIT_SCRIPTS == 0 then
		MessageBoxForPlayers(GetPlayerFilter(player), "/Text/Game/Scripts/Init.txt", "InitMessage('"..player.."')")
	end
end

for i = 1,8 do
	PLAYER_BRAIN[i] = GetPlayerBrain(i)
	if IsPlayerCurrent(i) then startThread(InitMessage, i) end
end

ROUTINES_LOADED = {
	[0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0,
	[9] = 0, [10]= 0, [11]= 0, [12]= 0, [13]= 0, [14]= 0, [15]= 0, [16]= 0, [17]= 0,
	[18] = 0, [19]= 0, [20]= 0, [21]= 0, [22]= 0, [23]= 0, [24]= 0, [25]= 0, [26]= 0,
}

function LoadScript(path, key)
	print("Loading script "..path)
	dofile(path)
	repeat sleep(1) until ROUTINES_LOADED[key] == 1
end

LoadScript("/scripts/hero-advmap-routines/_common.lua", 0)
LoadScript("/scripts/hero-advmap-routines/academy.lua", ACADEMY)
LoadScript("/scripts/hero-advmap-routines/dungeon.lua", DUNGEON)
LoadScript("/scripts/hero-advmap-routines/fortress.lua", FORTRESS)
LoadScript("/scripts/hero-advmap-routines/haven.lua", HAVEN)
LoadScript("/scripts/hero-advmap-routines/inferno.lua", INFERNO)
LoadScript("/scripts/hero-advmap-routines/necropolis.lua", NECROPOLIS)
LoadScript("/scripts/hero-advmap-routines/preserve.lua", PRESERVE)
LoadScript("/scripts/hero-advmap-routines/stronghold.lua", STRONGHOLD)
LoadScript("/scripts/artifacts/artifacts-data.lua", 10)
LoadScript("/scripts/artifacts/artifacts-manager.lua", 12)
LoadScript("/scripts/artifacts/artifacts-routines.lua", 13)
LoadScript("/scripts/skills/skills-data.lua", 15)
LoadScript("/scripts/skills/skills-manager.lua", 16)
LoadScript("/scripts/skills/skills-routines.lua", 17)
LoadScript("/scripts/_handlers/conversion.lua", 20)
LoadScript("/scripts/_handlers/combat-trigger.lua", 21)
LoadScript("/scripts/_handlers/starting-armies.lua", 22)
LoadScript("/scripts/_handlers/hero-trigger.lua", 23)
LoadScript("/scripts/_handlers/custom-abilities.lua", 25)


ADD_PLAYER_HERO = {
	[1] = "AddPlayer1Hero",
	[2] = "AddPlayer2Hero",
	[3] = "AddPlayer3Hero",
	[4] = "AddPlayer4Hero",
	[5] = "AddPlayer5Hero",
	[6] = "AddPlayer6Hero",
	[7] = "AddPlayer7Hero",
	[8] = "AddPlayer8Hero",
}
REMOVE_PLAYER_HERO = {
	[1] = "RemovePlayer1Hero",
	[2] = "RemovePlayer2Hero",
	[3] = "RemovePlayer3Hero",
	[4] = "RemovePlayer4Hero",
	[5] = "RemovePlayer5Hero",
	[6] = "RemovePlayer6Hero",
	[7] = "RemovePlayer7Hero",
	[8] = "RemovePlayer8Hero",
}

START_ROUTINES = {
	[0] = DoCommonRoutine_Start,
	[1] = DoHavenRoutine_Start,
	[2] = DoPreserveRoutine_Start,
	[3] = DoInfernoRoutine_Start,
	[4] = DoNecropolisRoutine_Start,
	[5] = DoAcademyRoutine_Start,
	[6] = DoDungeonRoutine_Start,
	[7] = DoFortressRoutine_Start,
	[8] = DoStrongholdRoutine_Start,
}

DAILY_ROUTINES = {
	[0] = DoCommonRoutine_Daily,
	[1] = DoHavenRoutine_Daily,
	[2] = DoPreserveRoutine_Daily,
	[3] = DoInfernoRoutine_Daily,
	[4] = DoNecropolisRoutine_Daily,
	[5] = DoAcademyRoutine_Daily,
	[6] = DoDungeonRoutine_Daily,
	[7] = DoFortressRoutine_Daily,
	[8] = DoStrongholdRoutine_Daily,
}

WEEKLY_ROUTINES = {
	[0] = DoCommonRoutine_Weekly,
	[1] = DoHavenRoutine_Weekly,
	[2] = DoPreserveRoutine_Weekly,
	[3] = DoInfernoRoutine_Weekly,
	[4] = DoNecropolisRoutine_Weekly,
	[5] = DoAcademyRoutine_Weekly,
	[6] = DoDungeonRoutine_Weekly,
	[7] = DoFortressRoutine_Weekly,
	[8] = DoStrongholdRoutine_Weekly,
}

AFTER_COMBAT_ROUTINES = {
	[0] = DoCommonRoutine_AfterCombat,
	[1] = DoHavenRoutine_AfterCombat,
	[2] = DoPreserveRoutine_AfterCombat,
	[3] = DoInfernoRoutine_AfterCombat,
	[4] = DoNecropolisRoutine_AfterCombat,
	[5] = DoAcademyRoutine_AfterCombat,
	[6] = DoDungeonRoutine_AfterCombat,
	[7] = DoFortressRoutine_AfterCombat,
	[8] = DoStrongholdRoutine_AfterCombat,
}


function PlayerDailyHandler(player, newweek)
	while (not IsPlayerCurrent(player)) do sleep(10) end
	print("Player "..player.." turn started")
	for i,hero in GetPlayerHeroes(player) do
		local faction = GetHeroFactionID(hero)
		startThread(DAILY_ROUTINES[faction], player, hero)
		-- startThread(DAILY_ROUTINES[x_skills], player, hero)
		startThread(DoArtifactsRoutine_Daily, player, hero)
		if newweek then 
			startThread(WEEKLY_ROUTINES[faction], player, hero)
			-- startThread(WEEKLY_ROUTINES[x_skills], player, hero)
			startThread(DoArtifactsRoutine_Weekly, player, hero)
		end
	end
	WatchPlayer(player, nil)
end

function NewDayTrigger()
	TURN = TURN + 1
	print("New day ! Turn "..TURN)
	local newweek = GetDate(DAY_OF_WEEK) == 1
	for player = 1,8 do
		if (GetPlayerState(player) == 1) then
			startThread(PlayerDailyHandler, player, newweek)
		end
	end
	CaravanCountdown()
end

function CombatResultsHandler(combatIndex)
	local hero = GetSavedCombatArmyHero(combatIndex, 1)
	if hero ~= nil then
		local player = GetSavedCombatArmyPlayer(combatIndex, 1)
		local faction = GetHeroFactionID(hero)
		startThread(AFTER_COMBAT_ROUTINES[faction], player, hero, combatIndex)
		startThread(DoSkillsRoutine_AfterCombat, player, hero, combatIndex)
		startThread(DoArtifactsRoutine_AfterCombat, player, hero, combatIndex)
	end
end


Trigger(NEW_DAY_TRIGGER, "NewDayTrigger")
Trigger(COMBAT_RESULTS_TRIGGER, "CombatResultsHandler")
Trigger(CUSTOM_ABILITY_TRIGGER, "CustomAbilityHandler")


function AddPlayerHero(player, hero)
	local faction = GetHeroFactionID(hero)
	startThread(ReplaceStartingArmy, hero)
	startThread(BindHeroLevelUpTrigger, hero)
	startThread(BindHeroSkillTrigger, hero)
	startThread(START_ROUTINES[faction], player, hero)
end
function AddPlayer1Hero(hero) AddPlayerHero(PLAYER_1, hero) end
function AddPlayer2Hero(hero) AddPlayerHero(PLAYER_2, hero) end
function AddPlayer3Hero(hero) AddPlayerHero(PLAYER_3, hero) end
function AddPlayer4Hero(hero) AddPlayerHero(PLAYER_4, hero) end
function AddPlayer5Hero(hero) AddPlayerHero(PLAYER_5, hero) end
function AddPlayer6Hero(hero) AddPlayerHero(PLAYER_6, hero) end
function AddPlayer7Hero(hero) AddPlayerHero(PLAYER_7, hero) end
function AddPlayer8Hero(hero) AddPlayerHero(PLAYER_8, hero) end

function RemovePlayerHero(hero)
	startThread(UnbindHeroLevelUpTrigger, hero)
	startThread(UnbindHeroSkillTrigger, hero)
end
function RemovePlayer1Hero(hero) RemovePlayerHero(hero) end
function RemovePlayer2Hero(hero) RemovePlayerHero(hero) end
function RemovePlayer3Hero(hero) RemovePlayerHero(hero) end
function RemovePlayer4Hero(hero) RemovePlayerHero(hero) end
function RemovePlayer5Hero(hero) RemovePlayerHero(hero) end
function RemovePlayer6Hero(hero) RemovePlayerHero(hero) end
function RemovePlayer7Hero(hero) RemovePlayerHero(hero) end
function RemovePlayer8Hero(hero) RemovePlayerHero(hero) end

for i = 1,8 do
	Trigger(PLAYER_ADD_HERO_TRIGGER, i, ADD_PLAYER_HERO[i])
	Trigger(PLAYER_REMOVE_HERO_TRIGGER, i, REMOVE_PLAYER_HERO[i])
end

function InitializeHeroes()
	for player = 1,8 do
		if (GetPlayerState(player) == 1) then
			for i,hero in GetPlayerHeroes(player) do
				-- print("Initialize hero "..hero)
				local faction = GetHeroFactionID(hero)
				startThread(ReplaceStartingArmy, hero)
				startThread(BindHeroLevelUpTrigger, hero)
				startThread(BindHeroSkillTrigger, hero)
				sleep(5) startThread(DoSkillsRoutine_Start, player, hero)
				sleep(5) startThread(START_ROUTINES[faction], player, hero)
			end
			sleep(5) startThread(WatchPlayer, player, 1)
		end
	end
end

print("All scripts successfully loaded !")

-- Initializers
InitializeHeroes()
InitializeMainTown()
InitializeCombatHook()
InitializeConvertibles()

print("Initializers done. The game can start. Have fun !")
INIT_SCRIPTS = 1
