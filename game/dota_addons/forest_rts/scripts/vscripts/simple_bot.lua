



-- Constants

LOWEST_PLAYER_INDEX = 0
HIGHEST_PLAYER_INDEX = 9

local PATROL_CHECK_INTERVAL = 0.1						--   Patrols will be checked this often if they are close enough to a waypoint
local MAX_SPAWNING_COUNT = 50							--   Maximum number of soldiers of each kind that can be spawned at a time
local STANDARD_START_MELEE_COUNT = 2					--   Initial number of melee soldiers spawned at a time
local STANDARD_START_RANGED_COUNT = 2					--   Initial number of ranged soldiers spawned at a time

local RADIANT_SPAWN = Vector(-7000, -6500, 525)			--   Radiant spawn coordinates
local DIRE_SPAWN = Vector(7000, 6500, 525)				--   Dire spawn coordinates
local NO_PATH = -1										--   Should be used when you don't want spawned soldiers to move after spawning.
local STANDARD_PATH = 1									--   Index to the standard path for both the Radiant and the Dire team

local MELEE_UNIT = "npc_dota_creature_soldier_melee"	--   The melee unit to be spawned
local RANGED_UNIT = "npc_dota_creature_soldier_ranged"	--   The ranged unit to be spawned



-- Variables

local paths = {}										-- Contains all the paths for both teams
local units = {}										-- Contains all the spawned units for both teams
local unitsNextIndex = 1
local prevGroupTeam
local prevGroupNumber

local debugShowWaypoints = false



if SimpleBot == nil then
	print("[SimpleBot] Creating new Bot!")
	SimpleBot = {}
	SimpleBot.__index = SimpleBot
end

function SimpleBot:new(o)
	o = o or {}
	setmetatable(o, SimpleBot)
	return o
end





--					-----| Public functions |-----





---------------------------------------------------------------------------
-- Create a new bot with the specified playerIndex and hero. This must
-- be called to initialize the bot.
--
--	* team: Should be either DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS
--	* multiplier: A floating point number that is multiplied with the
--		troop count to be spawned.
--
---------------------------------------------------------------------------
function SimpleBot:Init(team, multiplier)

	if team ~= DOTA_TEAM_GOODGUYS and team ~= DOTA_TEAM_BADGUYS then
		printError("Init", "Invalid team! Needs to be either 'DOTA_TEAM_GOODGUYS' or 'DOTA_TEAM_BADGUYS'!")
		print("Good guys: "..DOTA_TEAM_GOODGUYS.."\tBad guys: "..DOTA_TEAM_BADGUYS.."\tteam: "..team)
		return
	end
	if type(multiplier) ~= "number" or multiplier < 0 or multiplier > 100 then
		printError("Init", "Invalid multiplier! Must be a number!")
		return
	end

	paths = {}
	paths[DOTA_TEAM_GOODGUYS] = {}
	paths[DOTA_TEAM_BADGUYS] = {}
	units = {}
	units[DOTA_TEAM_GOODGUYS] = {}
	units[DOTA_TEAM_BADGUYS] = {}

	Convars:RegisterCommand('patrol.pi', function()
		if not prevGroupTeam or not prevGroupNumber then
			print("Error: no patrols have been spawned yet!")
			return
		end

		print("---------------------------------------------------------------------------")
		print("Printing patrol index of all soldiers:")
		print("---------------------------------------------------------------------------")
		print("")
		print("Index | Patrol Index")
		print("---------------------------------------------------------------------------")
		for index,unit in ipairs(units[prevGroupTeam][prevGroupNumber]) do
			if(type(unit) == "table") then
				local index = unit:GetIndex()
				local patrolIndex = unit:GetPatrolIndex()
				print(string.format("%5s   %5s", index, patrolIndex))
			else
				print("Type of unit was "..type(unit))
			end
		end
		print("---------------------------------------------------------------------------")
	end, 'Prints info about the last waypoint reached for all soldiers', FCVAR_CHEAT )

	-- Setup
	SimpleBot:SetupStandard(team, multiplier)

	Convars:RegisterCommand('patrol.wp', function()
		local curPatrolPath = paths[team][STANDARD_PATH]
		if curPatrolPath then
			for i,wp in ipairs(curPatrolPath) do
				local center = Vector(wp.x, wp.y, wp.z)
				DebugDrawCircle(center, Vector(0,255,0), 5, 150, false, 60)
			end
		end
	end, 'Shows all the waypoints for the current patrolpath', FCVAR_CHEAT )
end



---------------------------------------------------------------------------
-- Multiplies the initial patrol size.
--
--	* multiplier: The multiplier to use.
--
---------------------------------------------------------------------------
function SimpleBot:MultiplyInitialPatrol(multiplier)

	if multiplier then
		STANDARD_START_MELEE_COUNT = STANDARD_START_MELEE_COUNT * multiplier
		STANDARD_START_RANGED_COUNT = STANDARD_START_RANGED_COUNT * multiplier
	end
end



---------------------------------------------------------------------------
-- Adds a new path to the collection of paths that can be chosen from
-- for that team.
--
--	* team: Should be either DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS
--	* path: A table of vector where each vector is a waypoint on the route
--
---------------------------------------------------------------------------
function SimpleBot:AddPath(team, path)

	if not team then
		printError("AddPath", "team was nil")
		return
	end
	if not path then
		printError("AddPath", "path was nil!")
	end

	local teamPaths = paths[team]
	local insertIndex = SimpleBot:GetPathCount(team) + 1
	table.insert(teamPaths, insertIndex, path)

	printDebug("AddPath", "Inserted path for team "..team.." into index "..insertIndex.."!")
end



---------------------------------------------------------------------------
-- Spawns a specified number of ranged and melee units, at a given place,
-- and for a given team.
--
--	* team: The team the soldiers will be spawned for. That is usually the
--		opposite team of the player(s) in the game.
--	* meleeCount: The number of melee soldiers to be spawned.
--	* rangedCount: The number of ranged soldiers to be spawned.
--	* spawnPoint: The point where the soldiers will be spawned. Should be
--		nil if you want to spawn them at the default location set by
--		RADIANT_SPAWN and DIRE_SPAWN. If you do use a Vector, make sure it
--		is valid, as this will NOT be checked.
--	* pathNumber: The path that the spawned soldiers will be patrol.
--		This is the index of the path in the paths table for the given
--		team. Should be nil if you want to use the first and standard path.
--		This path will also be used if the number is invalid, though with
--		an error message. Use NO_PATH if you don't want the soldiers to
--		patrol.
--	* groupNumber: Unless this is the first time a patrol group has been
--		spawned or this is set to nil, where 1 will be used in both cases,
--		this should be the groupNumber of the previous group. This number
--		is used to calculate how many extra troops the new group should
--		have in addition to the base amount. Therefore, use a larger
--		number if you want to start with larger patrol groups.
--	* multiplier: This is multiplied with the meleeCount and rangedCount.
--		Should be nil if you want to use the default multiplier of 1.
--
---------------------------------------------------------------------------
function SimpleBot:SpawnSoldiers(team, meleeCount, rangedCount, spawnPoint, pathNumber, groupNumber, multiplier)

	if not team then
		printError("SpawnSoldiers", "team was nil!")
		return
	end
	if not meleeCount or not rangedCount then
		printError("SpawnSoldiers", "'meleeCount' or 'rangedCount' was nil!")
		return
	end
	if meleeCount > MAX_SPAWNING_COUNT or meleeCount < 0 then
		printError("SpawnSoldiers", "'meleeCount' must be between 0 and "..MAX_SPAWNING_COUNT.."! Spawning "..MAX_SPAWNING_COUNT.." instead!")
		meleeCount = MAX_SPAWNING_COUNT
	end
	if rangedCount > MAX_SPAWNING_COUNT or rangedCount < 0 then
		printError("SpawnSoldiers", "'rangedCount' must be between 0 and "..MAX_SPAWNING_COUNT.."! Spawning "..MAX_SPAWNING_COUNT.." instead!")
		rangedCount = MAX_SPAWNING_COUNT
	end
	if not spawnPoint then
		if team == DOTA_TEAM_GOODGUYS then
			spawnPoint = RADIANT_SPAWN
		elseif team == DOTA_TEAM_BADGUYS then
			spawnPoint = DIRE_SPAWN
		else
			printError("SpawnSoldiers", "'team' must be either DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS if you don't provide a spawnPoint!")
		end
	end
	pathNumber = pathNumber or STANDARD_PATH
	if not groupNumber then
		groupNumber = unitsNextIndex
		unitsNextIndex = unitsNextIndex + 1
	end
	multiplier = multiplier or 1

	if SimpleBot:GetPathCount(team) == 0 then
		PrintError("SpawnSoldiers", "The specified team must have at least 1 path, currently 0!")
		return
	end

	prevGroupTeam = team
	prevGroupNumber = groupNumber
	local groupsForTeam = units[team]
	groupsForTeam[groupNumber] = {}
	local group = groupsForTeam[groupNumber]

	SimpleBot:CreatePatrolUnit(team, meleeCount, MELEE_UNIT, spawnPoint, pathNumber, group, groupNumber, multiplier)
	SimpleBot:CreatePatrolUnit(team, rangedCount, RANGED_UNIT, spawnPoint, pathNumber, group, groupNumber, multiplier)

	print("[SimpleBot] Spawning "..meleeCount*multiplier.." melee units and "..rangedCount*multiplier.." ranged units at team "..team.."!")

	if pathNumber ~= NO_PATH then
		SimpleBot:Patrol(group)
	end
end



	-----| Setters and Getters |-----



---------------------------------------------------------------------------
-- Gets and returns paths[team][pathNumber].
--
--	* team: Should be DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS
--	* pathNumber: Should be a positive integer
--
---------------------------------------------------------------------------
function SimpleBot:GetPath(team, pathNumber)

	if team ~= DOTA_TEAM_GOODGUYS and team ~= DOTA_TEAM_BADGUYS then
		printError("GetPath", "Invalid team! Needs to be either 'DOTA_TEAM_GOODGUYS' or 'DOTA_TEAM_BADGUYS'!")
		return
	end
	if not pathNumber then
		printError("GetPath", "pathNumber was nil!")
		return
	end

	printDebug("GetPath", "Team: "..team.."\tPathNumber: "..pathNumber)

	local teamPaths = paths[team]
	local specificPath = teamPaths[pathNumber]
	if not specificPath then
		printError("GetPath", "Invalid pathNumber or path doesn't exist!")
		return
	else
		return specificPath
	end
end



---------------------------------------------------------------------------
-- Gets the number of patrol paths for a given team.
--
--	* team: Should be DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS
--
---------------------------------------------------------------------------
function SimpleBot:GetPathCount(team)
	if not team then
		printError("GetPathCount", "team was nil!")
		return
	end

	local count = 0
	for k,v in pairs(paths[team]) do
		if v then
			count = count + 1
		end
	end
	return count
end





--					-----| Private functions |-----

	-- These function should only be called by the existing code.





---------------------------------------------------------------------------
-- Adds the patrol paths and spawns the first wave of soldiers.
--
--	* team: Should be DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS
--	* multiplier: Should be a positive integer or float
--
---------------------------------------------------------------------------
function SimpleBot:SetupStandard(team, multiplier)

	if team ~= DOTA_TEAM_GOODGUYS and team ~= DOTA_TEAM_BADGUYS then
		printError("SetupStandard", "team must be either DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS!")
		return
	end

	-- Registers some path to be used by npcs

	--   Radiant path
	SimpleBot:AddPath(DOTA_TEAM_GOODGUYS, {
		Vector(-5200, -6900, 420),
		Vector(-4150, -7100, 420),
		Vector(-3650, -7400, 420),
		Vector(-3200, -7550, 420),
		Vector(-2750, -7400, 420),
		Vector(-2350, -7150, 420),
		Vector(-2050, -6650, 420),
		Vector(-700, -6650, 420),
		Vector(-375, -7000, 420),
		Vector(200, -7250, 420),
		Vector(1000, -7500, 420),
		Vector(1750, -7600, 420),
		Vector(2450, -7450, 420),
		Vector(3750, -7450, 575),
		Vector(4550, -7150, 575),
		Vector(5550, -6950, 575),
		Vector(6250, -6850, 575),
		Vector(6950, -6600, 575),
		Vector(7200, -5950, 575),
		Vector(7400, -5450, 575),
		Vector(7450, -4500, 420),
		Vector(7150, -3650, 420),
		Vector(6600, -2500, 420),
		Vector(6400, -1800, 300),
		Vector(5150, -650, 164),
		Vector(3900, -1800, 164),
		Vector(3400, -1900, 164),
		Vector(1550, -1900, 300),
		Vector(0, -2150, 420),
		Vector(-500, -2100, 420),
		Vector(-750, -2050, 420),
		Vector(-1450, -1500, 420),
		Vector(-1800, -200, 548),
		Vector(-2800, -50, 548),
		Vector(-3450, 500, 548),
		Vector(-3300, 1200, 548),
		Vector(-3100, 1650, 548),
		Vector(-2350, 2300, 675),
		Vector(-2100, 2300, 675),
		Vector(-1450, 2200, 675),
		Vector(-500, 1650, 675),
		Vector(-125, 1250, 675),
		Vector(320, 1100, 675),
		Vector(1000, 1400, 675),
		Vector(900, 1900, 548),
		Vector(250, 2300, 420),
		Vector(-250, 3100, 300),
		Vector(-1500, 5350, 420),
		Vector(-3000, 5250, 420),
		Vector(-3000, 5900, 548),
		Vector(-3000, 6400, 548),
		Vector(-3450, 6700, 548),
		Vector(-4500, 6650, 675),
		Vector(-5300, 6400, 675),
		Vector(-7050, 6500, 925),
		Vector(-7050, 5100, 925),
		Vector(-7400, 4800, 925),
		Vector(-7400, 3750, 925),
		Vector(-7300, 1600, 675),
		Vector(-7050, -575, 675),
		Vector(-5700, -2050, 420),
		Vector(-5700, -2800, 420),
		Vector(-6500, -3150, 420),
		Vector(-7350, -3600, 420),
		Vector(-7100, -4500, 420),
		Vector(-6800, -5150, 420)
	})

	--   Dire path
	SimpleBot:AddPath(DOTA_TEAM_BADGUYS, {
		Vector(4000, 7000, 675),
		Vector(-3000, 6800, 548),
		Vector(-3000, 5150, 420),
		Vector(-4100, 4400, 300),
		Vector(-4350, 3800, 300),
		Vector(-4150, 3100, 300),
		Vector(-3400, 2250, 548),
		Vector(-3150, 1750, 548),
		Vector(-3400, 400, 548),
		Vector(-2800, -50, 548),
		Vector(-2250, -200, 548),
		Vector(-1750, -100, 548),
		Vector(-850, 150, 675),
		Vector(-200, 450, 675),
		Vector(450, 1100, 675),
		Vector(1050, 1550, 675),
		Vector(-150, 2750, 300),
		Vector(-325, 3300, 300),
		Vector(0, 4000, 300),
		Vector(2350, 3950, 164),
		Vector(3200, 3100, 164),
		Vector(4100, 2700, 164),
		Vector(3600, 1500, 164),
		Vector(2900, 0, 164),
		Vector(2300, -850, 164),
		Vector(2250, -3850, 164),
		Vector(-400, -4500, 164),
		Vector(-1100, -5400, 164),
		Vector(-2100, -5600, 300),
		Vector(-2100, -6600, 420),
		Vector(-750, -6650, 420),
		Vector(-200, -7150, 420),
		Vector(500, -7300, 420),
		Vector(1150, -7550, 420),
		Vector(2250, -7450, 420),
		Vector(3650, -7450, 548),
		Vector(5000, -7000, 548),
		Vector(7000, -6600, 548),
		Vector(7400, -5450, 548),
		Vector(7100, -3100, 420),
		Vector(7750, -2150, 675),
		Vector(7800, -800, 675),
		Vector(7450, 200, 675),
		Vector(7350, 1450, 420),
		Vector(6850, 2300, 420),
		Vector(6850, 5000, 420)
	})

	print("[SimpleBot] Dire and Radiant paths successfully added!")

	ListenToGameEvent('entity_killed', Dynamic_Wrap(SimpleBot, 'onPatrolUnitKilled'), self)

	-- Spawn a standard amount of units
	SimpleBot:SpawnSoldiers(team, STANDARD_START_MELEE_COUNT, STANDARD_START_RANGED_COUNT, nil, nil, nil, multiplier)
end



---------------------------------------------------------------------------
-- Creates a patrol group with the specified number of troops.
--
--	* team: The team the soldiers will be spawned for. That is usually the
--		opposite team of the player(s) in the game.
--	* count: The number of melee soldiers to be spawned.
--	* unitName: The name of the type of units that will be spawned.
--	* location: The point where the units will be spawned.
--	* pathNumber: The path at index pathNumber in paths[team].
--	* group: The group to add the units to. Will be treated as an array.
--	* groupNumber: The index of the group in the team table of unit groups.
--	* Multiplier: Useful for adjustment by difficulty.
--
---------------------------------------------------------------------------
function SimpleBot:CreatePatrolUnit(team, count, unitName, location, pathNumber, group, groupNumber, multiplier)

	if not team or not count or not unitName or not location or not pathNumber or not group or not groupNumber or not multiplier then
		printError("CreatePatrolUnit", "One of the arguments were nil!")
		return
	end

	local troopCount = math.ceil(count * multiplier)
	local arrayLength = #group
	for i=arrayLength+1, arrayLength+troopCount do
		local newUnit = CreateUnitByName(unitName, location, true, nil, nil, team)
		table.insert(group, i, newUnit)
		newUnit.SB = {}
		newUnit.SB.group = group
		newUnit.SB.index = i
		newUnit.SB.path = paths[team][pathNumber]
		newUnit.SB.patrolIndex = 1

		---------------------------------------------------------------------------
		-- Returns the group of the unit.
		---------------------------------------------------------------------------
		function newUnit:GetGroup()

			if newUnit.SB then
				return newUnit.SB.group
			else
				PrintError("GetGroup", "unit.SB was nil!")
			end
		end

		---------------------------------------------------------------------------
		-- Returns the index of the unit in the group.
		---------------------------------------------------------------------------
		function newUnit:GetIndex()

			if newUnit.SB then
				return newUnit.SB.index
			else
				PrintError("GetIndex", "unit.SB was nil!")
			end
		end

		---------------------------------------------------------------------------
		-- Returns the path the unit is following.
		---------------------------------------------------------------------------
		function newUnit:GetPath()

			if newUnit.SB then
				return newUnit.SB.path
			else
				PrintError("GetPath", "unit.SB was nil!")
			end
		end

		---------------------------------------------------------------------------
		-- Returns the waypoint the unit is travelling towards.
		---------------------------------------------------------------------------
		function newUnit:GetDestination()

			if newUnit.SB then
				return newUnit.SB.path[newUnit.SB.patrolIndex]
			else
				PrintError("GetDestination", "unit.SB was nil!")
			end
		end

		---------------------------------------------------------------------------
		-- Returns the index of the next waypoint on the patrol path.
		---------------------------------------------------------------------------
		function newUnit:GetPatrolIndex()

			if newUnit.SB then
				return newUnit.SB.patrolIndex
			else
				PrintError("GetPatrolIndex", "unit.SB was nil!")
			end
		end

		---------------------------------------------------------------------------
		-- Increases the patrol index of the unit.
		---------------------------------------------------------------------------
		function newUnit:IncPatrolIndex()

			if newUnit.SB and newUnit.SB.patrolIndex then
				local pathLength = #newUnit.SB.path
				if newUnit.SB.patrolIndex >= pathLength then
					newUnit.SB.patrolIndex = 1
				else
					newUnit.SB.patrolIndex = newUnit.SB.patrolIndex + 1
				end
			else
				PrintError("IncPatrolIndex", "unit.SB or unit.SB.patrolIndex was nil!")
			end
		end
	end

	if group.SB then
		group.SB.initialCount = group.SB.remaining + troopCount
		group.SB.remaining = group.SB.remaining + troopCount
		return
	end

	group.SB = {}
	group.SB.team = team
	group.SB.initialCount = troopCount
	group.SB.remaining = troopCount
	group.SB.path = paths[team][pathNumber]
	group.SB.pathNumber = pathNumber
	group.SB.groupNumber = groupNumber
	group.SB.multiplier = multiplier

	---------------------------------------------------------------------------
	-- Returns the team of the group.
	---------------------------------------------------------------------------
	function group:GetTeam()

		if group.SB then
			return group.SB.team
		else
			PrintError("GetTeam", "group.SB was nil!")
		end
	end

	---------------------------------------------------------------------------
	-- Returns the initial number of troops in the group.
	---------------------------------------------------------------------------
	function group:GetInitialCount()

		if group.SB then
			return group.SB.initialCount
		else
			PrintError("GetInitialCount", "group.SB was nil!")
		end
	end

	---------------------------------------------------------------------------
	-- Returns the remaining number of troops in the group.
	---------------------------------------------------------------------------
	function group:GetRemaining()

		if group.SB then
			return group.SB.remaining
		else
			PrintError("GetRemaining", "group.SB was nil!")
		end
	end

	---------------------------------------------------------------------------
	-- Decrements the remaining counter.
	---------------------------------------------------------------------------
	function group:DecRemaining()

		if group.SB then
			group.SB.remaining = group.SB.remaining - 1
			return group.SB.remaining
		else
			PrintError("DecRemaining", "group.SB was nil!")
		end
	end

	---------------------------------------------------------------------------
	-- Returns the path of the group.
	---------------------------------------------------------------------------
	function group:GetPath()

		if group.SB then
			return group.SB.path
		else
			PrintError("GetPath", "group.SB was nil!")
		end
	end

	---------------------------------------------------------------------------
	-- Returns the pathNumber of the group.
	---------------------------------------------------------------------------
	function group:GetPathNumber()

		if group.SB then
			return group.SB.pathNumber
		else
			PrintError("GetPathNumber", "group.SB was nil!")
		end
	end

	---------------------------------------------------------------------------
	-- Returns the groupNumber of the group.
	---------------------------------------------------------------------------
	function group:GetGroupNumber()

		if group.SB then
			return group.SB.groupNumber
		else
			PrintError("GetGroupNumber", "group.SB was nil!")
		end
	end

	---------------------------------------------------------------------------
	-- Returns the troop multiplier for the group
	---------------------------------------------------------------------------
	function group:GetMultiplier()

		if group.SB then
			return group.SB.multiplier
		else
			PrintError("GetMultiplier", "group.SB was nil!")
		end
	end

	return newGroup
end



---------------------------------------------------------------------------
-- Makes the group follow the pathIndex of team.
--
--	* group: The group that will start patrolling.
--
---------------------------------------------------------------------------
function SimpleBot:Patrol(group)

	if not group or not group.SB or group:GetRemaining() <= 0 then
		printError("RegisterPatrol", "Invalid group!")
		return
	end

	local path = group:GetPath()
	if not path then
		PrintError("RegisterPatrol", "path was nil!")
		return
	end

	-- Timer needed as the move command didn't seem to work without it.
	Timers:CreateTimer({
		endTime = 0.05,
		callback = function()
			for _,unit in ipairs(group) do
				unit:MoveToPositionAggressive(unit:GetDestination())
			end
		end
	})

	-- The waypoint check.
	Timers:CreateTimer(0, function()

		local patrolGroup = group
		local previousUnit

		for index,unit in ipairs(group) do

			if not unit:IsNull() and unit:IsAlive() then

				local currentDestination = unit:GetDestination()
				local currentLocation = unit:GetCenter()

				local slack = 200
				local vectorDestMaxX = currentDestination.x + slack
				local vectorDestMinX = currentDestination.x - slack
				local vectorDestMaxY = currentDestination.y + slack
				local vectorDestMinY = currentDestination.y - slack

				-- Check if unit has reached waypoint
				if currentLocation.x > vectorDestMinX and currentLocation.x < vectorDestMaxX and
					currentLocation.y > vectorDestMinY and currentLocation.y < vectorDestMaxY then

					unit:IncPatrolIndex()

					-- Again, the timer seems to be required for the movement to work.
					Timers:CreateTimer({
						endTime = 0.05,
						callback = function()
							unit:MoveToPositionAggressive(unit:GetDestination())
						end
					})
				end
			end
		end

	  return PATROL_CHECK_INTERVAL
    end)
end



---------------------------------------------------------------------------
-- Checks if everyone in the group is dead.
---------------------------------------------------------------------------
function SimpleBot:onPatrolUnitKilled(keys)

	local victim = EntIndexToHScript(keys.entindex_killed)
	if not victim.SB then
		return
	end
	local group = victim:GetGroup()
	if not group then
		PrintError("CheckPatrolDeath", "group was nil!")
		return
	end
	local unitIndex = victim:GetIndex()
	table.remove(group, unitIndex)
	local remaining = group:DecRemaining()

	if remaining > 0 then
		return
	end

	local team = group:GetTeam()
	local initialCount = group:GetInitialCount()
	local groupNumber = group:GetGroupNumber() + 1
	local multiplier = group:GetMultiplier()
	local pathNumber = group:GetPathNumber() + 1
	if pathNumber > SimpleBot:GetPathCount(team) then
		pathNumber = STANDARD_PATH
	end

	local countToSpawn = (initialCount/2+1)*multiplier

	SimpleBot:SpawnSoldiers(team, math.floor(initialCount/2+1), math.floor(initialCount/2+1), nil, pathNumber, groupNumber, multiplier)

	group = nil

	print("Spawning new patrol group...")
	printDebug("CheckPatrolGroup", "Patrol group killed! Spawning another one for team "..team.."!")

end



---------------------------------------------------------------------------
-- Calculates the number of extra troops that will be spawned on the next patrol summoned,
-- based on the groupNumber. The formula is currently too easy to justify this function,
-- but the formula might change in the future.
---------------------------------------------------------------------------
function SimpleBot:GroupNumberToTroopCount(groupNumber, difficulty)

	if not groupNumber then
		printError("GroupNumberToTroopCount", "groupNumber was nil!")
		return
	end

	difficulty = difficulty or 1.0
	local troopCount = math.floor(groupNumber * difficulty)
	if troopCount > MAX_SPAWNING_COUNT then
		troopCount = MAX_SPAWNING_COUNT
	end

	printDebug("GroupNumberToTroopCount", "TroopCount for new group: "..troopCount)

	return troopCount
end





--					-----| Utility functions |-----





---------------------------------------------------------------------------
-- Used for printing debug info.
---------------------------------------------------------------------------
function printDebug(functionName, message)
	if DEBUG_SIMPLE_BOT == true then
		print("SimpleBot:"..functionName.."   DEBUG: "..message)
	end
end



---------------------------------------------------------------------------
-- Used for printing error messages.
---------------------------------------------------------------------------
function printError(functionName, message)
	print("SimpleBot:"..functionName.."   DEBUG: "..message)
end


