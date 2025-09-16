ExecConsoleCommand("@BlockGame()")

NB_HUMAN = 0
FIRST_PLAYER = 0
for i = 1,8 do
	if IsHumanPlayer(i) then
		if FIRST_PLAYER == 0 then FIRST_PLAYER = i end
	    NB_HUMAN = NB_HUMAN + 1
	end
end

ROUTINES_LOADED = {
	[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0, [9] = 0, [10]= 0,
	[11]= 0, [12]= 0, [13]= 0, [14]= 0, [15]= 0, [16]= 0, [17]= 0, [18]= 0, [19]= 0, [20]= 0,
	[21]= 0, [22]= 0, [23]= 0, [24]= 0, [25]= 0, [26]= 0, [27]= 0, [28]= 0, [29]= 0, [30]= 0,
}

function LoadScript(path, key)
	-- log("Loading script "..path)
	dofile(path)
	repeat sleep(1) until ROUTINES_LOADED[key] == 1
end

LoadScript("/scripts/game/creatures.lua", 1)
LoadScript("/scripts/game/spells.lua", 2)
LoadScript("/scripts/game/skills.lua",3)
LoadScript("/scripts/game/artifacts.lua", 4)
LoadScript("/scripts/game/heroes.lua", 5)
LoadScript("/scripts/advmap/advmap-data.lua", 8)
LoadScript("/scripts/advmap/advmap-utils.lua", 9)
LoadScript("/scripts/advmap/routines/skills-routines-advmap.lua", 11)
LoadScript("/scripts/advmap/routines/artifacts-routines-advmap.lua", 12)
LoadScript("/scripts/advmap/routines/heroes-routines-advmap.lua", 13)
LoadScript("/scripts/advmap/routines/towns-routines-advmap.lua", 14)
LoadScript("/scripts/advmap/handlers/skills-manager.lua", 16)
LoadScript("/scripts/advmap/handlers/artifacts-manager.lua", 17)
LoadScript("/scripts/advmap/handlers/heroes-manager.lua", 18)
LoadScript("/scripts/advmap/handlers/towns-manager.lua", 19)
LoadScript("/scripts/advmap/handlers/starting-armies.lua", 21)
LoadScript("/scripts/advmap/handlers/town-conversion.lua", 22)
LoadScript("/scripts/advmap/handlers/mapobjects-triggers.lua", 23)
LoadScript("/scripts/advmap/handlers/custom-abilities.lua", 25)
LoadScript("/scripts/game-vars.lua", 30)


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


function WatchPlayer(player, wait)
    if wait then
        while (not IsPlayerCurrent(player)) do sleep(10) end
    end
	sleep(10)
	log("$ WatchPlayer "..player)
    local tracker = {}
    for _,hero in GetPlayerHeroes(player) do
		local x,y,z = GetObjectPosition(hero)
		tracker[hero] = {
			track = not nil,
			x = x, y = y, z = z,
			move = GetHeroStat(hero, STAT_MOVE_POINTS),
			mana = GetHeroStat(hero, STAT_MANA_POINTS),
		}
    end
    while IsPlayerCurrent(player) do
		for _,hero in GetPlayerHeroes(player) do
            ScanHeroArtifacts(hero)
			if tracker[hero].track then
				local mvp = GetHeroStat(hero, STAT_MOVE_POINTS)
				if mvp == 0 then
					log("Hero "..hero.." has 0 move points")
					if IsEqualPosition(hero, tracker[hero].x, tracker[hero].y, tracker[hero].z) then
						Routine_ArtifactBootsOfSwiftJourneyCancel(player, hero, nil)
						if HasHeroSkill(hero, PERK_MEDITATION) and GetHeroStat(hero, STAT_MANA_POINTS) > tracker[hero].mana then
							log("Hero "..hero.." has used Meditation")
							local amount = GetHeroStat(hero, STAT_MANA_POINTS) - tracker[hero].mana
							startThread(Routine_MeditationExp, player, hero, amount)
						else
							log("Hero "..hero.." has used digging")
							startThread(ActivateDigging, player, hero)
						end
						tracker[hero].track = nil
					end
				elseif mvp < tracker[hero].move then
					tracker[hero].track = nil
				end
			end
			startThread(DoHeroSpeRoutine_Continuous, player, hero)
			startThread(DoArtifactsRoutine_Continuous, player, hero)
        end
		sleep(15)
	end
end

function PlayerDailyHandler(player)
	while (not IsPlayerCurrent(player)) do sleep(5) end
	log("Player "..player.." turn "..TURN.." started")
	for i,hero in GetPlayerHeroes(player) do
		startThread(DoHeroSpeRoutine_Daily, player, hero)
		startThread(DoSkillsRoutine_Daily, player, hero)
		startThread(DoArtifactsRoutine_Daily, player, hero)
		startThread(AIDailyBonus, player, hero)
	end
	startThread(DoTownsRoutine_Daily, player)
	WatchPlayer(player, nil)
end

function PlayerWeeklyHandler(player)
	while (not IsPlayerCurrent(player)) do sleep(5) end
	log("Player "..player.." week "..WEEKS.." started")
	for i,hero in GetPlayerHeroes(player) do
		startThread(DoHeroSpeRoutine_Weekly, player, hero)
		startThread(DoSkillsRoutine_Weekly, player, hero)
		startThread(DoArtifactsRoutine_Weekly, player, hero)
		startThread(AIWeeklyBonus, player, hero)
	end
	startThread(DoTownsRoutine_Weekly, player)
end

function NewDayTrigger()
	TURN = TURN + 1
	log("New day ! Turn "..TURN)
	local newweek = GetDate(DAY_OF_WEEK) == 1
	if newweek then
		WEEKS = WEEKS + 1
		startThread(WitchHuts_reset)
		startThread(Temples_reset)
	end
	startThread(UpdateTavernHeroes)
	startThread(UpdateTavernFactions)
	for player = 1,8 do
		if (GetPlayerState(player) == 1) then
			if newweek then startThread(PlayerWeeklyHandler, player) sleep(3) end
			startThread(PlayerDailyHandler, player)
		end
	end
	CaravanCountdown()
end

function CombatResultsHandler(combatIndex)
	Register('h5x_combat_init', 'false')
	local hero = GetSavedCombatArmyHero(combatIndex, 1)
	if hero ~= nil then
		local player = GetSavedCombatArmyPlayer(combatIndex, 1)
		startThread(DoHeroSpeRoutine_AfterCombat, player, hero, combatIndex)
		startThread(DoSkillsRoutine_AfterCombat, player, hero, combatIndex)
		startThread(DoArtifactsRoutine_AfterCombat, player, hero, combatIndex)
		sleep(10) ONGOING_BATTLES[hero] = nil
	end
	local loser = GetSavedCombatArmyHero(combatIndex, 0)
	if loser ~= nil then
		local player = GetSavedCombatArmyPlayer(combatIndex, 0)
		startThread(HeroLostBattle, player, loser, hero)
	end
end


Trigger(NEW_DAY_TRIGGER, "NewDayTrigger")
Trigger(COMBAT_RESULTS_TRIGGER, "CombatResultsHandler")
Trigger(CUSTOM_ABILITY_TRIGGER, "CustomAbilityHandler")


function AddPlayerHero(player, hero)
	Register(VarHeroLevel(hero), GetHeroLevel(hero))
	if HEROES[hero].owner == 0 then
		log("Initialize hero "..hero)
		startThread(BindHeroLevelUpTrigger, hero)
		startThread(BindHeroSkillTrigger, hero)
		startThread(DoSkillsRoutine_Start, player, hero)
		startThread(DoHeroSpeRoutine_Start, player, hero)
		startThread(AIRecruitBonus, player, hero)
		MakeHeroReturnToTavernAfterDeath(hero, 1, 0)
	else
		log("Comeback hero "..hero)
		startThread(BindHeroLevelUpTrigger, hero)
		startThread(BindHeroSkillTrigger, hero)
	end
	HEROES[hero].owner = player
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
			startThread(StartingBonus, player)
			DIFFICULTY_MULTIPLIER[player] = IsAIPlayer(player) and (1+0.5*GetDifficulty()) or 1
			for i = 1,8 do AllowPlayerTavernRace(player, FactionToTownType(i), 0) end
			for i,hero in GetPlayerHeroes(player) do
				log("Initialize hero "..hero)
				Register(VarHeroLevel(hero), GetHeroLevel(hero))
				startThread(InitializeArmy, hero)
				startThread(BindHeroLevelUpTrigger, hero)
				startThread(BindHeroSkillTrigger, hero)
				startThread(DoSkillsRoutine_Start, player, hero) sleep(1)
				startThread(DoHeroSpeRoutine_Start, player, hero) sleep(1)
				AllowPlayerTavernRace(player, FactionToTownType(HEROES[hero].faction), 1)
				MakeHeroReturnToTavernAfterDeath(hero, 1, 0)
				HEROES[hero].owner = player
			end
			sleep(1)
			startThread(Routine_MagicGuildsBonus, player)
			startThread(WatchPlayer, player, 1)
		end
	end
	startThread(UpdateTavernHeroes)
end

log("All scripts successfully loaded !")

-- Initializers
function Init()
	if GetDate(DAY) == 1 then
		InitializeRandomSeed()
		InitializeMapTowns()
		InitializeHeroes()
		InitializeConvertibles()
		InitializeMapObjects()
		ExecConsoleCommand("@UnblockGame()") UnblockGame()
		log("Initializers done. The game can start. Have fun !")
	else
		startThread(LoadedGame_GameVars)
	end
end

-- Script enabler
if NB_HUMAN <= 1 then
	log("Single player game detected. Initializing...")
	Init()
else
	log("Multi player game detected. Check state...")
	OBJECTIVE_CHECK = 0
	startThread(function()
		GetObjectiveState('H5X', FIRST_PLAYER)
		OBJECTIVE_CHECK = 1 -- than means the objective exists in the map
	end) sleep(1)
	if OBJECTIVE_CHECK == 1 then
		Trigger(OBJECTIVE_STATE_CHANGE_TRIGGER, 'H5X', FIRST_PLAYER, 'Init') sleep()
		ExecConsoleCommand("@if GetObjectiveState('H5X', FIRST_PLAYER) == OBJECTIVE_UNKNOWN then SetObjectiveState('H5X', OBJECTIVE_ACTIVE, FIRST_PLAYER) else LoadedGame_GameVars() end")
	else
		MessageBoxForPlayers(GetPlayerFilter(FIRST_PLAYER), "/Text/Game/Scripts/InitFail.txt")
	end
end

sleep(30) UnblockGame()
