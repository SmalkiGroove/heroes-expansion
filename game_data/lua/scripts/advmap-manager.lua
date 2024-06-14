ExecConsoleCommand("@BlockGame()")

NB_HUMAN = 0
FIRST_PLAYER = 0
PLAYER_BRAIN = {
	[1] = OBSERVER,
	[2] = OBSERVER,
	[3] = OBSERVER,
	[4] = OBSERVER,
	[5] = OBSERVER,
	[6] = OBSERVER,
	[7] = OBSERVER,
	[8] = OBSERVER,
}

for i = 1,8 do
	PLAYER_BRAIN[i] = GetPlayerBrain(i)
	if FIRST_PLAYER == 0 and GetPlayerState(i) == PLAYER_ACTIVE then FIRST_PLAYER = i end
	if PLAYER_BRAIN[i] == HUMAN then NB_HUMAN = NB_HUMAN + 1 end
end


ROUTINES_LOADED = {
	[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0, [9] = 0, [10]= 0,
	[11]= 0, [12]= 0, [13]= 0, [14]= 0, [15]= 0, [16]= 0, [17]= 0, [18]= 0, [19]= 0, [20]= 0,
	[21]= 0, [22]= 0, [23]= 0, [24]= 0, [25]= 0, [26]= 0, [27]= 0, [28]= 0, [29]= 0, [30]= 0,
}

function LoadScript(path, key)
	-- print("Loading script "..path)
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
LoadScript("/scripts/advmap/handlers/skills-manager.lua", 16)
LoadScript("/scripts/advmap/handlers/artifacts-manager.lua", 17)
LoadScript("/scripts/advmap/handlers/heroes-manager.lua", 18)
LoadScript("/scripts/advmap/handlers/starting-armies.lua", 21)
LoadScript("/scripts/advmap/handlers/town-conversion.lua", 22)
LoadScript("/scripts/advmap/handlers/custom-abilities.lua", 23)
LoadScript("/scripts/advmap/handlers/game-vars.lua", 30)


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
    local tracker = {}
    for _,hero in GetPlayerHeroes(player) do
		local x,y,z = GetObjectPosition(hero)
		tracker[hero] = {
			check = not nil,
			x = x, y = y, z = z,
			mana = GetHeroStat(hero, STAT_MANA_POINTS),
		}
    end
    while (IsPlayerCurrent(player)) do
		for _,hero in GetPlayerHeroes(player) do
            ScanHeroArtifacts(hero)
			if tracker[hero].check then
				if GetHeroStat(hero, STAT_MOVE_POINTS) == 0 then
					print("Hero "..hero.." has 0 move points")
					if IsEqualPosition(hero, tracker[hero].x, tracker[hero].y, tracker[hero].z) then
						if HasHeroSkill(hero, PERK_MEDITATION) and GetHeroStat(hero, STAT_MANA_POINTS) > tracker[hero].mana then
							print("Hero "..hero.." has used Meditation")
							local amount = GetHeroStat(hero, STAT_MANA_POINTS) - tracker[hero].mana
							startThread(Routine_MeditationExp, player, hero, amount)
						else
							print("Hero "..hero.." has used digging")
							startThread(ActivateDigging, player, hero)
						end
						tracker[hero].check = nil
					end
				end
			end
        end
		sleep(18)
	end
end

function PlayerDailyHandler(player, newweek)
	while (not IsPlayerCurrent(player)) do sleep(10) end
	print("Player "..player.." turn started")
	UpdateTavernHeroes()
	for i,hero in GetPlayerHeroes(player) do
		if newweek then
			startThread(DoHeroSpeRoutine_Weekly, player, hero)
			startThread(DoSkillsRoutine_Weekly, player, hero)
			startThread(DoArtifactsRoutine_Weekly, player, hero)
			sleep(5)
		end
		startThread(DoHeroSpeRoutine_Daily, player, hero)
		startThread(DoSkillsRoutine_Daily, player, hero)
		startThread(DoArtifactsRoutine_Daily, player, hero)
	end
	WatchPlayer(player, nil)
end

function NewDayTrigger()
	TURN = TURN + 1
	print("New day ! Turn "..TURN)
	local newweek = GetDate(DAY_OF_WEEK) == 1
	if newweek then WEEK = WEEK + 1 end
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
		startThread(DoHeroSpeRoutine_AfterCombat, player, hero, combatIndex)
		startThread(DoSkillsRoutine_AfterCombat, player, hero, combatIndex)
		startThread(DoArtifactsRoutine_AfterCombat, player, hero, combatIndex)
	end
end


Trigger(NEW_DAY_TRIGGER, "NewDayTrigger")
Trigger(COMBAT_RESULTS_TRIGGER, "CombatResultsHandler")
Trigger(CUSTOM_ABILITY_TRIGGER, "CustomAbilityHandler")


function AddPlayerHero(player, hero)
	if HEROES[hero].owner then
		print("Comeback hero "..hero)
		startThread(BindHeroLevelUpTrigger, hero)
		startThread(BindHeroSkillTrigger, hero)
	else
		print("Initialize hero "..hero)
		-- startThread(ReplaceStartingArmy, hero)
		startThread(BindHeroLevelUpTrigger, hero)
		startThread(BindHeroSkillTrigger, hero)
		startThread(DoSkillsRoutine_Start, player, hero)
		startThread(DoHeroSpeRoutine_Start, player, hero)
	end
	HEROES[hero].owner = player
	startThread(StoreData, hero)
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
				print("Initialize hero "..hero)
				startThread(ReplaceStartingArmy, hero)
				startThread(BindHeroLevelUpTrigger, hero)
				startThread(BindHeroSkillTrigger, hero)
				startThread(DoSkillsRoutine_Start, player, hero) sleep(1)
				startThread(DoHeroSpeRoutine_Start, player, hero) sleep(1)
				HEROES[hero].owner = player
			end
		end
	end
	UpdateTavernHeroes()
end

for player = 1,8 do
	if (GetPlayerState(player) == 1) then
		for i,hero in GetPlayerHeroes(player) do
			startThread(StoreData, hero)
		end
		startThread(WatchPlayer, player, 1)
	end
end

print("All scripts successfully loaded !")

-- Initializers
function Init()
	InitializeRandomSeed()
	InitializeHeroes()
	InitializeMapTowns()
	InitializeConvertibles()
	ExecConsoleCommand("@UnblockGame()") UnblockGame()
	print("Initializers done. The game can start. Have fun !")
end

-- Script enabler
if NB_HUMAN <= 1 then
	Init()
else
	Trigger(OBJECTIVE_STATE_CHANGE_TRIGGER, 'H5X', FIRST_PLAYER, 'Init') sleep()
	ExecConsoleCommand("@if GetObjectiveState('H5X', FIRST_PLAYER) == OBJECTIVE_UNKNOWN then SetObjectiveState('H5X', OBJECTIVE_ACTIVE, FIRST_PLAYER) end")
end

sleep(300) UnblockGame()
