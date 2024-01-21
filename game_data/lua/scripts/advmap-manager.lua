
ExecConsoleCommand("@BlockGame()")
ExecConsoleCommand("@GAME_READY = 0")
ExecConsoleCommand("@SetGameVar('h5x_init','false')")

function ScriptEnabler()
	ExecConsoleCommand(
		"@repeat sleep(1) until GAME_READY == 1"..
		" if GetGameVar('h5x_init') == 'false' then"..
		" SetGameVar('h5x_init','true')"..
		" Init()"..
		" end"
	)
end

for i = 1,8 do
	PLAYER_BRAIN[i] = GetPlayerBrain(i)
	if PLAYER_BRAIN[i] == HUMAN then NB_HUMAN = NB_HUMAN + 1 end
end

if NB_HUMAN == 1 then
	ScriptEnabler()
else
	for i = 1,8 do
		if PLAYER_BRAIN[i] == HUMAN and IsPlayerCurrent(i) then
			MessageBoxForPlayers(GetPlayerFilter(i), "/Text/Game/Scripts/Init.txt", "ScriptEnabler")
			break
		end
	end
end

ROUTINES_LOADED = {
	[0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0,
	[9] = 0, [10]= 0, [11]= 0, [12]= 0, [13]= 0, [14]= 0, [15]= 0, [16]= 0, [17]= 0,
	[18] = 0, [19]= 0, [20]= 0, [21]= 0, [22]= 0, [23]= 0, [24]= 0, [25]= 0, [26]= 0,
}

function LoadScript(path, key)
	-- print("Loading script "..path)
	dofile(path)
	repeat sleep(1) until ROUTINES_LOADED[key] == 1
end

LoadScript("/scripts/advmap-data", 0)
LoadScript("/scripts/data/creatures-data", 1)
LoadScript("/scripts/data/spells-data", 2)
LoadScript("/scripts/artifacts/artifacts-data.lua", 10)
LoadScript("/scripts/artifacts/artifacts-manager.lua", 12)
LoadScript("/scripts/artifacts/artifacts-routines.lua", 13)
LoadScript("/scripts/skills/skills-data.lua", 15)
LoadScript("/scripts/skills/skills-manager.lua", 16)
LoadScript("/scripts/skills/skills-routines.lua", 17)
LoadScript("/scripts/_handlers/conversion.lua", 20)
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


function WatchPlayer(player, wait)
    if wait then
        while (not IsPlayerCurrent(player)) do sleep(10) end
    end
    local tracker = {}
    for _,hero in GetPlayerHeroes(player) do
		local x,y,z = GetObjectPosition(hero)
		tracker[hero] = {
			[0] = GetHeroStat(hero, STAT_MANA_POINTS),
			[1] = x, [2] = y, [3] = z,
			[9] = not nil
		}
    end
    while (IsPlayerCurrent(player)) do
		for _,hero in GetPlayerHeroes(player) do
            ScanHeroArtifacts(hero)
			StoreData(hero)
			if tracker[hero][9] then
				if GetHeroStat(hero, STAT_MOVE_POINTS) == 0 then
					print("Hero "..hero.." has 0 move points")
					if IsEqualPosition(hero, tracker[hero][1], tracker[hero][2], tracker[hero][3]) then
						if HasHeroSkill(hero, PERK_MEDITATION) and GetHeroStat(hero, STAT_MANA_POINTS) > tracker[hero][0] then
							print("Hero "..hero.." has used Meditation")
							startThread(Routine_MeditationExp, player, hero)
						else
							print("Hero "..hero.." has used digging")
							startThread(ActivateDigging, player, hero)
						end
						tracker[hero][9] = nil
					end
				end
			end
        end
		sleep(50)
	end
end

function PlayerDailyHandler(player, newweek)
	while (not IsPlayerCurrent(player)) do sleep(10) end
	BlockGame()
	print("Player "..player.." turn started")
	for i,hero in GetPlayerHeroes(player) do
		local faction = HEROES[hero]
		startThread(DoHeroSpeRoutine_Daily, player, hero)
		startThread(DoSkillsRoutine_Daily, player, hero)
		startThread(DoArtifactsRoutine_Daily, player, hero)
		if newweek then
			startThread(DoHeroSpeRoutine_Weekly, player, hero)
			startThread(DoSkillsRoutine_Weekly, player, hero)
			startThread(DoArtifactsRoutine_Weekly, player, hero)
		end
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
		local faction = HEROES[hero]
		startThread(DoHeroSpeRoutine_AfterCombat, player, hero, combatIndex)
		startThread(DoSkillsRoutine_AfterCombat, player, hero, combatIndex)
		startThread(DoArtifactsRoutine_AfterCombat, player, hero, combatIndex)
	end
end


Trigger(NEW_DAY_TRIGGER, "NewDayTrigger")
Trigger(COMBAT_RESULTS_TRIGGER, "CombatResultsHandler")
Trigger(CUSTOM_ABILITY_TRIGGER, "CustomAbilityHandler")


function AddPlayerHero(player, hero)
	local faction = HEROES[hero]
	startThread(ReplaceStartingArmy, hero)
	startThread(BindHeroLevelUpTrigger, hero)
	startThread(BindHeroSkillTrigger, hero)
	startThread(DoHeroSpeRoutine_Start, player, hero)
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
				local faction = HEROES[hero]
				startThread(ReplaceStartingArmy, hero)
				startThread(BindHeroLevelUpTrigger, hero)
				startThread(BindHeroSkillTrigger, hero)
				sleep(1) startThread(DoSkillsRoutine_Start, player, hero)
				sleep(1) startThread(DoHeroSpeRoutine_Start, player, hero)
			end
			sleep(1) startThread(WatchPlayer, player, 1)
		end
	end
end

function InitializeGameVars()
	for player = 1,8 do
		if (GetPlayerState(player) == 1) then
			for i,hero in GetPlayerHeroes(player) do
				StoreData(hero)
			end
		end
	end
end

print("All scripts successfully loaded !")
ExecConsoleCommand("@GAME_READY = 1")

-- Initializers
function Init()
	InitializeHeroes()
	InitializeMapTowns()
	InitializeConvertibles()
	InitializeGameVars()
	ExecConsoleCommand("@UnblockGame()") UnblockGame()
	print("Initializers done. The game can start. Have fun !")
end

