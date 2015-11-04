  --  CustomGameEventManager:Send_ServerToPlayer(player, "player_lumber_changed", { lumber = math.floor(hero:GetLumber()) })


-- Variables
GENERIC_ABILITIES = {}
PLAYER_HEROES = {}
-- For some reason PlayerResource was not found here, therefore the value had
-- to be set inside InitGameMode instead for both PLAYER_COUNT and VICTORY_SCORE.
PLAYER_COUNT = 0
VICTORY_SCORE = 0

COLOR_DIRE = "#b0171b"
COLOR_RADIANT = "#4789ab"



if SimpleRTSGameMode == nil then
   SimpleRTSGameMode = {}
   SimpleRTSGameMode.__index = SimpleRTSGameMode
end

function SimpleRTSGameMode:new(o)
   o = o or {}
   setmetatable(o, self)
   SIMPLERTS_REFERENCE = o
   return o
end





-- // -----| Init |----- \\ --





---------------------------------------------------------------------------
-- Loads the required modules, sets the gamerules, listens to event
-- and registers commands.
---------------------------------------------------------------------------
function SimpleRTSGameMode:InitGameMode()
   print("[SimpleRTS] Gamemode is initialising.")
   
   -- Load the rest of the modules that requires that the game modes are set
   loadModule('settings')
   loadModule('utils')
   loadModule('resources')
   loadModule('simple_tech_tree')
   loadModule('buildings')
   loadModule('ability_pages')
   loadModule('simple_bot')
   loadModule('timers')
   -- Must be turned off due to crash with the new buildingHelper!
   --loadModule('buildinghelper_old')
   
   -- Setup rules
   GameRules:SetGoldPerTick(0)
   --GameRules:SetGoldPerTick(GOLD_PER_TICK)
   GameRules:SetGoldTickTime(GOLD_TICK_TIME)
   GameRules:SetFirstBloodActive(FIRST_BLOOD_ACTIVE)
   GameRules:SetSameHeroSelectionEnabled(SAME_HERO_ENABLED)
   GameRules:SetHeroSelectionTime(HERO_SELECTION_TIME)
   GameRules:SetPreGameTime(PRE_GAME_TIME)
   GameRules:SetPostGameTime(POST_GAME_TIME)
   GameRules:SetTreeRegrowTime(TREE_REGROW_TIME_SECONDS)
   GameRules:GetGameModeEntity():SetLoseGoldOnDeath(LOSE_GOLD_ON_DEATH)
   GameRules:GetGameModeEntity():SetCameraDistanceOverride(1300)
   
   -- Setup game mode rules
   GameMode = GameRules:GetGameModeEntity()
   GameMode:SetBuybackEnabled(BUYBACK_ENABLED)
   GameMode:SetLoseGoldOnDeath(false)
   GameMode:SetTopBarTeamValuesOverride(true)
   GameMode:SetTopBarTeamValuesVisible(true)
   
   -- Find pathable trees.
   DeterminePathableTrees()

   --BuildingHelper:SetForceUnitsAway(true)
   
   print("[SimpleRTS] Gamemode rules are set.")
   
   -- Init self
   SimpleRTS = self
   self.scoreDire = 0
   self.scoreRadiant = 0
   self.playerCount = 0
   
   -- Filters
   --GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( SimpleRTSGameMode, "FilterExecuteOrder" ), self )

   -- Event Hooks 
   ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(SimpleRTSGameMode, 'onHeroPick'), self)
   ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(SimpleRTSGameMode, 'onGameStateChange'), self)
   ListenToGameEvent('npc_spawned', Dynamic_Wrap(SimpleRTSGameMode, 'onNPCSpawned'), self)
   ListenToGameEvent('entity_killed', Dynamic_Wrap(SimpleRTSGameMode, 'onEntityKilled'), self)
   ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(SimpleRTSGameMode, 'onEntityLevel'), self)
   ListenToGameEvent('tree_cut', Dynamic_Wrap(SimpleRTSGameMode, 'OnTreeCut'), self)
   
   -- Register Listener
   CustomGameEventManager:RegisterListener( "update_selected_entities", Dynamic_Wrap(SimpleRTSGameMode, 'OnPlayerSelectedEntities'))
   CustomGameEventManager:RegisterListener( "repair_order", Dynamic_Wrap(SimpleRTSGameMode, "RepairOrder"))  	
   CustomGameEventManager:RegisterListener( "building_helper_build_command", Dynamic_Wrap(BuildingHelper, "BuildCommand"))
   CustomGameEventManager:RegisterListener( "building_helper_cancel_command", Dynamic_Wrap(BuildingHelper, "CancelCommand"))

   -- Custom Events
   --   ListenToGameEvent('resource_gold_found', Dynamic_Wrap(SimpleRTSGameMode, 'onGoldFound'), self)
   
   -- Register Think
   GameMode:SetContextThink("SimpleRTSThink", Dynamic_Wrap(SimpleRTSGameMode, 'Think'), THINK_TIME)
   
   -- Full units file to get the custom values
   GameRules.AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
   GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
   GameRules.HeroKV = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
   GameRules.ItemKV = LoadKeyValues("scripts/npc/npc_items_custom.txt")
   --GameRules.Requirements = LoadKeyValues("scripts/kv/tech_tree.kv")

   -- Store and update selected units of each pID
   GameRules.SELECTED_UNITS = {}
   
   -- Keeps the blighted gridnav positions
   GameRules.Blight = {}



   -- Register console commands

   -- DebugPrint
   Convars:RegisterConvar('debug_spew', tostring(DEBUG_SPEW), 'Set to 1 to start spewing debug info. Set to 0 to disable.', 0)

   Convars:RegisterCommand('boss', function()
			      
			      local cmdPlayer = Convars:GetCommandClient()
			      local playerHero
			      if cmdPlayer then
				 local playerID = cmdPlayer:GetPlayerID()
				 if playerID ~= nil and playerID ~= -1 then
				    playerHero = PlayerResource:GetSelectedHeroEntity(playerID)
				 end
			      end
			      
			      SimpleBot:MultiplyInitialPatrol(5)
			      PlayerResource:SetGold(cmdPlayer:GetPlayerID(), 99999, true)
			      
			      local newItem = CreateItem("item_blink", playerHero, playerHero)
			      playerHero:AddItem(newItem)
			      newItem = CreateItem("item_heart", playerHero, playerHero)
			      playerHero:AddItem(newItem)
			      newItem = CreateItem("item_assault", playerHero, playerHero)
			      playerHero:AddItem(newItem)
			      newItem = CreateItem("item_mjollnir", playerHero, playerHero)
			      playerHero:AddItem(newItem)
			      newItem = CreateItem("item_rapier", playerHero, playerHero)
			      playerHero:AddItem(newItem)
			      --newItem = CreateItem("item_bundle_of_lumber", playerHero, playerHero)
			      --playerHero:AddItem(newItem)
			      playerHero:IncLumber(1000)
				   end, 'Beefs up the hero of the caller', FCVAR_CHEAT )
   
   Convars:RegisterCommand('debug', function()
			      
			      DEBUG = true
			      SimpleBot:MultiplyInitialPatrol(5)
				    end, 'Enables standard debug mode for lower construction time', FCVAR_CHEAT)
   
   Convars:RegisterCommand('unitCount', function()
			      
			      local cmdPlayer = Convars:GetCommandClient()
			      local playerHero
			      if cmdPlayer then
				 local playerID = cmdPlayer:GetPlayerID()
				 if playerID ~= nil and playerID ~= -1 then
				    playerHero = PlayerResource:GetSelectedHeroEntity(playerID)
				 end
			      end
			      
			      playerHero:PrintUnitCount()
					end, 'Print the unitCount table of the hero of the caller', FCVAR_CHEAT)
   
   Convars:RegisterCommand('start', function()
			      
				    end, 'Start game', FCVAR_CHEAT)
   
   Convars:RegisterCommand('test_endgame', function()
			      
			      GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
			      GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
			      GameRules:Defeated()
					   end, 'Ends the game.', FCVAR_CHEAT)
end





--					-----| Listener functions |-----





---------------------------------------------------------------------------
-- On Hero Pick
---------------------------------------------------------------------------
function SimpleRTSGameMode:onHeroPick(keys)
   local currentPlayer = EntIndexToHScript(keys.player)
   PlayerResource:SetGold(currentPlayer:GetPlayerID(), START_GOLD, true)
   PlayerResource:SetGold(currentPlayer:GetPlayerID(), 0, false)

   --     BH stuff     --

   local hero = EntIndexToHScript(keys.heroindex)
   local player = EntIndexToHScript(keys.player)
   local playerID = hero:GetPlayerID()

   Resources:InitHero(hero)
   
   -- Initialize Variables for Tracking
   player.units = {} -- This keeps the handle of all the units of the player, to iterate for unlocking upgrades
   player.structures = {} -- This keeps the handle of the constructed units, to iterate for unlocking upgrades
   player.buildings = {} -- This keeps the name and quantity of each building
   player.upgrades = {} -- This kees the name of all the upgrades researched
   player.lumber = 0 -- Secondary resource of the player
   
   -- Create city center in front of the hero
   --local position = hero:GetAbsOrigin() + hero:GetForwardVector() * 300
   --local city_center_name = "city_center"
   --local building = BuildingHelper:PlaceBuilding(player, city_center_name, position, true, 5) 
   
   -- Set health to test repair
   --building:SetHealth(building:GetMaxHealth()/3)
   
   -- These are required for repair to know how many resources the building takes
   --building.GoldCost = 100
   --building.LumberCost = 100
   --building.BuildTime = 15
   
   -- Add the building to the player structures list
   --player.buildings[city_center_name] = 1
   --table.insert(player.structures, building)
   
   --CheckAbilityRequirements( hero, player )
   --CheckAbilityRequirements( building, player )
   
   -- Add the hero to the player units list
   table.insert(player.units, hero)
   hero.state = "idle" --Builder state
   
   -- Spawn some peasants around the hero
   --
   --local position = hero:GetAbsOrigin()
   --local numBuilders = 5
   --local angle = 360/numBuilders
   --for i=1,5 do
   --   local rotate_pos = position + Vector(1,0,0) * 100
   --  local builder_pos = RotatePosition(position, QAngle(0, angle*i, 0), rotate_pos)
      
   --   local builder = CreateUnitByName("peasant", builder_pos, true, hero, hero, hero:GetTeamNumber())
   --   builder:SetOwner(hero)
   --   builder:SetControllableByPlayer(playerID, true)
   --   table.insert(player.units, builder)
   --   builder.state = "idle"
      
      -- Go through the abilities and upgrade
     -- CheckAbilityRequirements( builder, player )
--end
   --
   
   -- Give Initial Resources
   --hero:SetGold(5000, false)
   --ModifyLumber(player, 5000)
   
   -- Lumber tick
   --Timers:CreateTimer(1, function()
--			 ModifyLumber(player, 10)
--			 return 10
--			 end)
   
   -- Give a building ability
--   local item = CreateItem("item_build_wall", hero, hero)
--   hero:AddItem(item)
   
   -- Learn all abilities (this isn't necessary on creatures)
--   for i=0,15 do
--      local ability = hero:GetAbilityByIndex(i)
--      if ability then ability:SetLevel(ability:GetMaxLevel()) end
--   end
--   hero:SetAbilityPoints(0)
end



---------------------------------------------------------------------------
-- On Entity Level
---------------------------------------------------------------------------
function SimpleRTSGameMode:onEntityLevel(keys)
   -- Prevent hero from using ability points by removing them.
   local player = EntIndexToHScript(keys.player)
   if not player then
      print("SimpleRTSGameMode:onEntityLevel: player was nil!")
   else
      local hero = player:GetAssignedHero()
      if not hero then
	 print("SimpleRTSGameMode:onEntityLevel: hero was nil!")
      else
	 hero:SetAbilityPoints(0)
      end
   end
end



---------------------------------------------------------------------------
-- On Game State Change
---------------------------------------------------------------------------
function SimpleRTSGameMode:onGameStateChange(keys)
   local newState = GameRules:State_Get()
   
   -- Selection state
   if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
      PLAYER_COUNT = PlayerResource:GetTeamPlayerCount()
      VICTORY_SCORE = math.ceil(KILLS_TO_WIN * PLAYER_COUNT / 2)
      print("PLAYER_COUNT: "..PLAYER_COUNT.."\tVICTORY_SCORE: "..VICTORY_SCORE)
      
   -- Game start
   elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
      print("[SimpleRTS] The game has started.")
      
      local playerCount, radiantCount, direCount = SimpleRTSGameMode:onGameStart(keys)
      local playerMode
      local botTeam
      
      print("[SimpleRTS] PlayerCount: "..playerCount)
      
      -- SinglePlayer
      if playerCount == 1 then
	 playerMode = "SinglePlayer"
	 
	 -- This is only needed (and only works) when there is only 1 player in the game.
	 local localPlayer = lastFoundPlayer
	 local playerTeam = localPlayer:GetTeam()
	 
	 if playerTeam == DOTA_TEAM_GOODGUYS then
	    botTeam = DOTA_TEAM_BADGUYS
	 elseif playerTeam == DOTA_TEAM_BADGUYS then
	    botTeam = DOTA_TEAM_GOODGUYS
	 end
	 
	 SimpleRTSGameMode:SinglePlayerMode(localPlayer, botTeam)
	 
      elseif playerCount > 1 then
	 -- Co-Op versus Bots
	 if radiantCount > 0 and direCount == 0 then
	    playerMode = "Co-Op"
	    botTeam = DOTA_TEAM_BADGUYS
	    
	    SimpleRTSGameMode:CoOpMode(botTeam, DOTA_TEAM_GOODGUYS, radiantCount)
	    
	 elseif direCount > 0 and radiantCount == 0 then
	    playerMode = "Co-Op"
	    botTeam = DOTA_TEAM_GOODGUYS
	    
	    SimpleRTSGameMode:CoOpMode(botTeam, DOTA_TEAM_BADGUYS, direCount)
	    
	    -- Normal Multiplayer
	 else
	    playerMode = "Normal"
	    
	    SimpleRTSGameMode:NormalMode()
	 end
      end
   end
end



---------------------------------------------------------------------------
-- On Game Start
-- 	Called by onGameStateChange
---------------------------------------------------------------------------
function SimpleRTSGameMode:onGameStart(keys)
   local playerCount = 0
   local radiantCount = 0
   local direCount = 0
   
   for i=0, HIGHEST_PLAYER_INDEX do
      
      local currentPlayer = PlayerResource:GetPlayer(i)
      if currentPlayer then
	 
	 if not PlayerResource:HasSelectedHero(currentPlayer:GetPlayerID()) then
	    PlayerResource:SetHasRepicked(i)
	    currentPlayer:MakeRandomHeroSelection()
	    print("Randomed hero for player "..i)
	 else
	    print("Player with index "..i.." has already picked")
	 end
	 
	 local playerTeam = PlayerResource:GetTeam(currentPlayer:GetPlayerID())
	 if playerTeam == DOTA_TEAM_GOODGUYS then
	    radiantCount = radiantCount + 1
	 elseif playerTeam == DOTA_TEAM_BADGUYS then
	    direCount = direCount + 1
	 end
	 playerCount = playerCount + 1
	 lastFoundPlayer = currentPlayer
      end
   end
   
   return playerCount, radiantCount, direCount
end



---------------------------------------------------------------------------
-- On NPC Spawn
---------------------------------------------------------------------------
function SimpleRTSGameMode:onNPCSpawned(keys)
   local spawnedUnit = EntIndexToHScript(keys.entindex)
   if not spawnedUnit:IsIllusion() and spawnedUnit:IsHero() and not spawnedUnit._initialized then
      spawnedUnit._initialized = true
      spawnedUnit:SetAbilityPoints(0)
      
      local owner = spawnedUnit:GetOwner()
      local playerID = owner:GetPlayerID()
      PLAYER_HEROES[playerID] = spawnedUnit
      SimpleTechTree:InitTechTree(spawnedUnit)
      
      --elseif not spawnedUnit:IsIllusion() and not spawnedUnit:IsHero() and not spawnedUnit:IsNeutralUnitType() then
   else
      local unitName = spawnedUnit:GetUnitName()
      if unitName ~= "npc_dota_creature_worker" and
	 unitName ~= "npc_dota_creature_human_worker" and
	 unitName ~= "npc_dota_creature_forest_worker" and
	 unitName ~= "npc_dota_creature_kobold_worker" and
	 unitName ~= "npc_dota_creature_skeleton_worker" and
      unitName ~= "npc_dota_creature_troll_worker" then --and
	 --not IsCustomBuilding(spawnedUnit) then
	 
	 spawnedUnit:SetIdleAcquire(true)
      end
   end
end



---------------------------------------------------------------------------
-- On Entity Killed
---------------------------------------------------------------------------
function SimpleRTSGameMode:onEntityKilled(keys)
   local killedUnit = EntIndexToHScript(keys.entindex_killed)
   local killerEntity
   if keys.entindex_attacker then
      killerEntity = EntIndexToHScript(keys.entindex_attacker)
   end   
   local killerUnit = killerEntity
   local killedTeam = killedUnit:GetTeam()
   local killerTeam = killerUnit:GetTeam()
   local unitName = killedUnit:GetUnitName()
   
   -- No need for more processing if a soldier
   if SimpleRTSGameMode:IsSoldier(killedUnit) == true then
      return
   end


   --     BH stuff     --
   
   -- Player owner of the unit
   local player = killedUnit:GetPlayerOwner()

   -- Building Killed
   if IsCustomBuilding(killedUnit) then   
      -- Building Helper grid cleanup
      BuildingHelper:RemoveBuilding(killedUnit, true)
      -- Check units for downgrades
      local building_name = killedUnit:GetUnitName()
      -- Substract 1 to the player building tracking table for that name
      if player.buildings[building_name] then
	 player.buildings[building_name] = player.buildings[building_name] - 1
      end
   end

   -- Cancel queue of a builder when killed
   if IsBuilder(killedUnit) then
      BuildingHelper:ClearQueue(killedUnit)
   end

   -- Table cleanup
   if player then
      -- Remake the tables
      local table_structures = {}
      for _,building in pairs(player.structures) do
	 if building and IsValidEntity(building) and building:IsAlive() then
	    --print("Valid building: "..building:GetUnitName())
	    table.insert(table_structures, building)
	 end
      end
      player.structures = table_structures
      
      local table_units = {}
      for _,unit in pairs(player.units) do
	 if unit and IsValidEntity(unit) then
	    table.insert(table_units, unit)
	 end
      end
      player.units = table_units		
   end

   --     BH stuff end     --



   local owner = killedUnit:GetOwner()
   local playerID = owner:GetPlayerID()
   local playerHero = GetPlayerHero(playerID)
   
   -- Needed for buildingHelper to function properly
   --if killedUnit._building and killedUnit._building == true then
   --   killedUnit:RemoveBuilding(true)
   --end
   
   if (killedUnit:IsRealHero() == true or unitName == MAIN_BUILDING.name) and not killedUnit._wasCancelled then      
      local killedTeamString
      local scoreMessage
      if killedTeam == DOTA_TEAM_GOODGUYS then
	 killedTeamString = "<font color='"..COLOR_RADIANT.."'>Radiant</font>"
	 self.scoreDire = self.scoreDire + 1
	 scoreMessage = "<font color='"..COLOR_DIRE.."'>Dire</font> has "..self.scoreDire.."/"..VICTORY_SCORE.." points needed to win!"
	 if unitName == MAIN_BUILDING.name then
	    GameRules:SendCustomMessage("A "..killedTeamString.." Main Tent was destroyed!", 0, 0)
	 end
      elseif killedTeam == DOTA_TEAM_BADGUYS then
	 killedTeamString = "<font color='"..COLOR_DIRE.."'>Dire</font>"
	 self.scoreRadiant = self.scoreRadiant + 1
	 scoreMessage = "<font color='"..COLOR_RADIANT.."'>Radiant</font> has "..self.scoreRadiant.."/"..VICTORY_SCORE.." points needed to win!"
	 if unitName == MAIN_BUILDING.name then
	    GameRules:SendCustomMessage("A "..killedTeamString.." Main Tent was destroyed!", 0, 0)
	 end
      end
      Say(nil, scoreMessage, false)
      
      -- Update the score
      GameMode:SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, self.scoreRadiant)
      GameMode:SetTopBarTeamValue(DOTA_TEAM_BADGUYS, self.scoreDire)
      
      print("Radiant: "..self.scoreRadiant.."\tDire: "..self.scoreDire)
      CustomGameEventManager:Send_ServerToAllClients("updated_team_scores", {radiant=self.scoreRadiant, dire=self.scoreDire})
      
      -- Check if enough kills have been made
      if self.scoreRadiant >= VICTORY_SCORE then
	 print("#simplerts_radiant_victory")
	 GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	 GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
	 GameRules:Defeated()
      elseif self.scoreDire >= VICTORY_SCORE then
	 print("#simplerts_dire_victory")
	 GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	 GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
	 GameRules:Defeated()
      end
   end
   
   SimpleTechTree:RegisterIncident(killedUnit, false)
end





--					-----| Game Modes |-----





---------------------------------------------------------------------------
-- Single Player Mode
---------------------------------------------------------------------------
function SimpleRTSGameMode:SinglePlayerMode(localPlayer, botTeam)
	SimpleRTSGameMode:ShowCenterMessage("#simplerts_single_player_mode_text", 5)

	print("[SimpleRTS] Single Player Mode:\tPlayer ID: "..localPlayer:GetPlayerID().."\tBot Team: "..botTeam)
	SimpleRTSGameMode:spawnSimpleBot(botTeam, 1.1)
end



---------------------------------------------------------------------------
-- Co-Op Mode
---------------------------------------------------------------------------
function SimpleRTSGameMode:CoOpMode(botTeam, activeTeam, playersOnTeam)
   SimpleRTSGameMode:ShowCenterMessage("#simplerts_co-op_mode_text", 5)

   print("[SimpleRTS] Co-Op versus Soldiers Mode:\tTeam: "..activeTeam.."\tBot Team: "..botTeam)
   print("[SimpleRTS] Player on team: "..playersOnTeam)
   SimpleRTSGameMode:spawnSimpleBot(botTeam, playersOnTeam*1.1)
end



---------------------------------------------------------------------------
-- PvP Mode
---------------------------------------------------------------------------
function SimpleRTSGameMode:NormalMode()
   
end





--					-----| Bot |-----





---------------------------------------------------------------------------
-- Spawns a simple bot on the opposite team
---------------------------------------------------------------------------
function SimpleRTSGameMode:spawnSimpleBot(botTeam, multiplier)
   print("[SimpleRTS] Spawning bot at team: "..botTeam.." with multiplier "..multiplier.."!")
   SimpleBot:Init(botTeam, multiplier)
end






-- A tree was cut down
function SimpleRTSGameMode:OnTreeCut(keys)
   --DeepPrintTable(keys)
   
   local treeX = keys.tree_x
   local treeY = keys.tree_y
   
   -- Update the pathable trees nearby
   local vecs = {
      Vector(0,64,0),-- N
      Vector(64,64,0), -- NE
      Vector(64,0,0), -- E
      Vector(64,-64,0), -- SE
      Vector(0,-64,0), -- S
      Vector(-64,-64,0), -- SW
      Vector(-64,0,0), -- W
      Vector(-64,64,0) -- NW
   }
   
   for k=1,#vecs do
      local vec = vecs[k]
      local xoff = vec.x
      local yoff = vec.y
      local pos = Vector(treeX + xoff, treeY + yoff, 0)
      
      local nearbyTree = GridNav:IsNearbyTree(pos, 96, true)
      --local nearbyTree = GridNav:IsNearbyTree(pos, 64, true)
      if nearbyTree then
	 local trees = GridNav:GetAllTreesAroundPoint(pos, 48, true)
	 --local trees = GridNav:GetAllTreesAroundPoint(pos, 32, true)
	 for _,t in pairs(trees) do
	    --DebugDrawCircle(t:GetAbsOrigin(), Vector(0,255,0), 255, 32, true, 60)
	    t.pathable = true
	 end
      end
   end
end





--					-----| Utility functions |-----





---------------------------------------------------------------------------
-- Returns the hero for the player with the given ID
--
--	* playerID: The ID of the player
--
---------------------------------------------------------------------------
function GetPlayerHero(playerID)
   return PLAYER_HEROES[playerID]
end



---------------------------------------------------------------------------
-- Returns true if the unit is a neutral soldier
--
--	* unit: The unit to check
--
---------------------------------------------------------------------------
function SimpleRTSGameMode:IsSoldier(unit)
   if not unit then
      print("SimpleRTSGameMode:isSoldie: unit was nil!")
      return
   end
   
   local unitName = unit:GetUnitName()
   if unitName == "npc_dota_creature_soldier_melee" or
   unitName == "npc_dota_creature_soldier_ranged" then
      
      return true
   else
      return false
   end
end



---------------------------------------------------------------------------
-- Think function, unused
---------------------------------------------------------------------------
function SimpleRTSGameMode:Think()
   return THINK_TIME
end



---------------------------------------------------------------------------
-- Shows a message to all clients
--
--	* msg: The message to print in ALL CAPS
--	* dur: The duration to show the message
--
---------------------------------------------------------------------------
function SimpleRTSGameMode:ShowCenterMessage(msg, dur)
   local msg = {
      message = msg,
      duration = dur
   }
   print("[SimpleRTS] Sending message to all clients.")
   FireGameEvent("show_center_message", msg)
end





--					-----| BuildingHelper Stuff |-----





-- Called whenever a player changes its current selection, it keeps a list of entity indexes
function SimpleRTSGameMode:OnPlayerSelectedEntities( event )
   local pID = event.pID
   
   GameRules.SELECTED_UNITS[pID] = event.selected_entities
   
   -- This is for Building Helper to know which is the currently active builder
   local mainSelected = GetMainSelectedEntity(pID)
   if IsValidEntity(mainSelected) and IsBuilder(mainSelected) then
      local player = PlayerResource:GetPlayer(pID)
      player.activeBuilder = mainSelected
   end
end

