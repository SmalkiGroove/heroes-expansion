ExecConsoleCommand("@BlockGame()")

NB_HUMAN = 0
FIRST_PLAYER = 0
for i = 1,8 do
	if IsHumanPlayer(i) then
		if FIRST_PLAYER == 0 then FIRST_PLAYER = i end
	    NB_HUMAN = NB_HUMAN + 1
	end
end

-- Check Duel Map
startThread(function()
	log.info("Checking for duel map...")
	DUEL_MODE = -1
	GetObjectiveState('DUEL', FIRST_PLAYER)
	DUEL_MODE = GetDifficulty()
	log.info("Duel map detected!")
end)

SCRIPTS_GROUP = {
	[0] = {
		"/scripts/game-vars.lua",
	},
	[1] = {
		"/scripts/game/creatures.lua",
		"/scripts/game/spells.lua",
		"/scripts/game/skills.lua",
		"/scripts/game/artifacts.lua",
		"/scripts/game/heroes.lua",
	},
	[2] = {
		"/scripts/advmap/advmap-data.lua",
		"/scripts/advmap/advmap-utils.lua",
	},
	[3] = {
		"/scripts/advmap/routines/skills-routines-advmap.lua",
		"/scripts/advmap/routines/artifacts-routines-advmap.lua",
		"/scripts/advmap/routines/heroes-routines-advmap.lua",
		"/scripts/advmap/routines/towns-routines-advmap.lua",
	},
	[4] = {
		"/scripts/advmap/handlers/skills-manager.lua",
		"/scripts/advmap/handlers/artifacts-manager.lua",
		"/scripts/advmap/handlers/heroes-manager.lua",
		"/scripts/advmap/handlers/towns-manager.lua",
	},
	[5] = {
		"/scripts/advmap/handlers/starting-armies.lua",
		"/scripts/advmap/handlers/town-conversion.lua",
		"/scripts/advmap/handlers/mapobjects-triggers.lua",
		"/scripts/advmap/handlers/custom-abilities.lua",
	},
}
function LoadScripts(wg)
	log.trace("Loading scripts group "..wg)
	for i, file in SCRIPTS_GROUP[wg] do dofile(file) end
	sleep(1)
end
for i = 0,5 do LoadScripts(i) end
if IsDuelMode() then dofile("/scripts/duel.lua") end


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
	log.info("$ WatchPlayer "..player)
    local tracker = {}
    for _,hero in GetPlayerHeroes(player) do
		local x,y,z = GetObjectPosition(hero)
		tracker[hero] = {
			track = not nil,
			x = x, y = y, z = z,
			move = GetHeroStat(hero, STAT_MOVE_POINTS),
			mana = GetHeroStat(hero, STAT_MANA_POINTS),
		}
		-- ControlHeroCustomAbility(hero, CUSTOM_ABILITY_1, CUSTOM_ABILITY_ENABLED)
    end
	PlayerDailyResources(player)
    while IsPlayerCurrent(player) do
		for _,hero in GetPlayerHeroes(player) do
            ScanHeroArtifacts(hero)
			if tracker[hero].track then
				local mvp = GetHeroStat(hero, STAT_MOVE_POINTS)
				if mvp == 0 then
					log.trace("Hero "..hero.." has 0 move points")
					if IsEqualPosition(hero, tracker[hero].x, tracker[hero].y, tracker[hero].z) then
						Routine_ArtifactBootsOfSwiftJourneyCancel(player, hero, nil)
						if HasHeroSkill(hero, PERK_MEDITATION) and GetHeroStat(hero, STAT_MANA_POINTS) > tracker[hero].mana then
							log.debug("Hero "..hero.." has used Meditation")
							local amount = GetHeroStat(hero, STAT_MANA_POINTS) - tracker[hero].mana
							startThread(ActivateMeditation, player, hero, amount)
						else
							log.debug("Hero "..hero.." has used digging")
							startThread(ActivateDigging, player, hero)
						end
						tracker[hero].track = nil
					end
				elseif mvp < tracker[hero].move then
					tracker[hero].track = nil
				end
			end
			DoHeroSpeRoutine_Continuous(player, hero)
			DoSkillsRoutine_Continuous(player, hero)
			DoArtifactsRoutine_Continuous(player, hero)
        end
		sleep(10)
	end
end

function PlayerDailyHandler(player)
	while (not IsPlayerCurrent(player)) do sleep(1) end
	log.info("Player "..player.." turn "..TURN.." started")
	for i,hero in GetPlayerHeroes(player) do
		ControlHeroCustomAbility(hero, CUSTOM_ABILITY_1, CUSTOM_ABILITY_DISABLED)
		DoHeroSpeRoutine_Daily(player, hero)
		DoSkillsRoutine_Daily(player, hero)
		DoArtifactsRoutine_Daily(player, hero)
		AIDailyBonus(player, hero)
	end
	startThread(DoTownsRoutine_Daily, player)
	WatchPlayer(player, nil)
end

function PlayerWeeklyHandler(player)
	--while (not IsPlayerCurrent(player)) do sleep(1) end
	log.info("Player "..player.." week "..WEEKS.." started")
	for i,hero in GetPlayerHeroes(player) do
		DoHeroSpeRoutine_Weekly(player, hero)
		DoSkillsRoutine_Weekly(player, hero)
		DoArtifactsRoutine_Weekly(player, hero)
		AIWeeklyBonus(player, hero)
	end
	startThread(DoTownsRoutine_Weekly, player)
end

function NewDayTrigger()
	TURN = TURN + 1
	log.info("New day ! Turn "..TURN)
	if IsDuelMode() then return end
	local newweek = GetDate(DAY_OF_WEEK) == 1
	if newweek then
		WEEKS = WEEKS + 1
		startThread(WeeklyMapObjects)
	end
	startThread(DailyMapObjects)
	startThread(UpdateTavernHeroes)
	startThread(UpdateTavernFactions)
	for player = 1,8 do
		if (GetPlayerState(player) == 1) then
			DAILY_RESOURCES[player] = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0}
			if newweek then startThread(PlayerWeeklyHandler, player) sleep(1) end
			startThread(PlayerDailyHandler, player)
		end
	end
	CaravanCountdown()
end

function CombatResultsHandler(combatIndex)
	if IsDuelMode() then return ExecConsoleCommand("@DuelAfterCombat()") end
	local hero = GetSavedCombatArmyHero(combatIndex, 1)
	if hero ~= nil then
		WON_BATTLES[hero] = WON_BATTLES[hero] + 1
		local player = GetSavedCombatArmyPlayer(combatIndex, 1)
		DoHeroSpeRoutine_AfterCombat(player, hero, combatIndex)
		DoSkillsRoutine_AfterCombat(player, hero, combatIndex)
		DoArtifactsRoutine_AfterCombat(player, hero, combatIndex)
		ONGOING_BATTLES[hero] = nil
		LAST_BATTLES[hero] = TURN
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
		log.debug("Initialize hero "..hero)
		startThread(BindHeroLevelUpTrigger, hero)
		startThread(BindHeroSkillTrigger, hero)
		startThread(DoSkillsRoutine_Start, player, hero)
		startThread(DoHeroSpeRoutine_Start, player, hero)
		startThread(AIRecruitBonus, player, hero)
		MakeHeroReturnToTavernAfterDeath(hero, 1, 0)
		WON_BATTLES[hero] = 0
		LAST_BATTLES[hero] = 0
	else
		log.debug("Comeback hero "..hero)
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
			DIFFICULTY_MULTIPLIER[player] = IsAIPlayer(player) and (1+0.5*DIFFICULTY) or 1
			for i = 1,8 do AllowPlayerTavernRace(player, FactionToTownType(i), 0) end
			for i,hero in GetPlayerHeroes(player) do
				log.debug("Initialize hero "..hero)
				Register(VarHeroLevel(hero), GetHeroLevel(hero))
				startThread(InitializeArmy, hero)
				startThread(BindHeroLevelUpTrigger, hero)
				startThread(BindHeroSkillTrigger, hero)
				startThread(DoSkillsRoutine_Start, player, hero) sleep(1)
				startThread(DoHeroSpeRoutine_Start, player, hero) sleep(1)
				AllowPlayerTavernRace(player, FactionToTownType(HEROES[hero].faction), 1)
				MakeHeroReturnToTavernAfterDeath(hero, 1, 0)
				HEROES[hero].owner = player
				WON_BATTLES[hero] = 0
				LAST_BATTLES[hero] = 0
			end
			if not IsDuelMode() then
				startThread(Routine_MagicGuildsBonus, player)
				startThread(WatchPlayer, player, 1)
			end
		end
	end
	startThread(UpdateTavernHeroes)
end

log.info("All scripts successfully loaded !")

-- Initializers
function Init()
	if GetDate(DAY) == 1 then
		InitializeRandomSeed()
		InitializeMapTowns()
		InitializeHeroes()
		InitializeConvertibles()
		InitializeMapObjects()
		ExecConsoleCommand("@UnblockGame()") UnblockGame()
		log.info("Initializers done. The game can start. Have fun !")
		if IsDuelMode() then ExecConsoleCommand("@DuelMain()") end
	else
		startThread(LoadedGame_GameVars)
	end
end

-- Script enabler
if NB_HUMAN <= 1 then
	log.debug("Single player game detected. Initializing...")
	Init()
else
	log.debug("Multi player game detected. Check state...")
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

sleep(10) UnblockGame()
