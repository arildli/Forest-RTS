

if not Stats then
   Stats = {}
end

function Stats:new(o)
   o = o or {}
   setmetatable(0, self)
   return o
end

function Stats:Init()
   Stats.players = {}
   Stats.playerCount = 0
   Stats.inited = true
end

function Stats:AddPlayer(hero, player, playerID)
   if not Stats.inited then
      return
   end

   Stats.playerCount = Stats.playerCount + 1

   Stats.players[playerID] = {
      playerID = playerID,
      hero = {
	 heroname = hero:GetUnitName(),
	 level = 1
      },
      entities = {
	 trainedCountTotal = 0,
	 constructedCountTotal = 0,

	 killedCountTotal = 0,
	 destroyedCountTotal = 0,

	 lostUnitCountTotal = 0,
	 lostBuildingCountTotal = 0,

	 trained = {},
	 killed = {},
	 lost = {}
      }
   }
end

---------------------------------------------------------------------------
-- Get the player object for playerID.
---------------------------------------------------------------------------
function Stats:GetPlayer(playerID) 
   return Stats.players[playerID]
end

---------------------------------------------------------------------------
-- Increments
-- * Level for hero of playerID.
---------------------------------------------------------------------------
function Stats:OnLevelUp(playerID, newLevel)
   if not Stats.inited then
      return
   end
   local player = Stats:GetPlayer(playerID)
   player.hero.level = newLevel
end

---------------------------------------------------------------------------
-- Increments the counters for
-- * Unit/building count trained/constructed for unit type of owner.
-- * Total unit/building count trained or constructed for owner.
---------------------------------------------------------------------------
function Stats:OnTrained(playerID, unit, enttype)
   if not Stats.inited then
      return
   end

   local player = Stats:GetPlayer(playerID)
   local unitName = unit:GetUnitName()

   local trainedUnitCount = player.entities.trained[unitName] or 0
   player.entities.trained[unitName] = trainedUnitCount + 1

   if enttype == "unit" then
      player.entities.trainedCountTotal = player.entities.trainedCountTotal + 1
   elseif enttype == "building" then
      player.entities.constructedCountTotal = player.entities.constructedCountTotal + 1
   end
end

---------------------------------------------------------------------------
-- Increments the counters for
-- * Unit count killed of unit type for killer.
-- * Total unit count killed of unit type for killer.
---------------------------------------------------------------------------
function Stats:OnDeathNeutral(playerID, unit)
   if not Stats.inited then
      return
   end

   local player = Stats:GetPlayer(playerID)
   local unitName = unit:GetUnitName()

   local killedCountTotal = player.entities.killedCountTotal
   player.entities.killedCountTotal = killedCountTotal + 1
   local killedUnitCount = player.entities.killed[unitName] or 0
   player.entities.killed[unitName] = killedUnitCount + 1
end

---------------------------------------------------------------------------
-- Increments the counters for
-- * Unit/building count killed of unit type for killer.
-- * Unit/building count lost of unit type for owner.
-- * Total unit/building count killed for killer.
-- * Total unit/building count lost for owner.
---------------------------------------------------------------------------
function Stats:OnDeath(playerID, killerID, unit, enttype)
   if not Stats.inited then
      return
   end

   local playerOwner = Stats:GetPlayer(playerID)
   local playerKiller = Stats:GetPlayer(killerID)
   local unitName = unit:GetUnitName()

   if not playerOwner then
      print("Sigh, playerOwner was nil!")
   end

   if enttype == "unit" then
      if killerID then
	 local killerKilledCountTotal = playerKiller.entities.killedCountTotal
	 playerKiller.entities.killedCountTotal = killerKilledCountTotal + 1 
	 local killerKilled = playerKiller.entities.killed[unitName] or 0
	 playerKiller.entities.killed[unitName] = killerKilled + 1
      end

      if playerID then
	 local ownerLostUnitCountTotal = playerOwner.entities.lostUnitCountTotal
	 playerOwner.entities.lostUnitCountTotal = ownerLostUnitCountTotal + 1
	 local ownerDeadCount = playerOwner.entities.lost[unitName] or 0
	 playerOwner.entities.lost[unitName] = ownerDeadCount + 1
      end

   elseif enttype == "building" then
      if killerID then
	 local killerDestroyedCountTotal = playerKiller.entities.destroyedCountTotal
	 playerKiller.entities.destroyedCountTotal = killerDestroyedCountTotal + 1 
	 local killerKilled = playerKiller.entities.killed[unitName] or 0
	 playerKiller.entities.killed[unitName] = killerKilled + 1
      end

      if playerID then
	 local ownerLostBuildingCountTotal = playerOwner.entities.lostBuildingCountTotal
	 playerOwner.entities.lostBuildingCountTotal = ownerLostBuildingCountTotal + 1
	 local ownerDeadCount = playerOwner.entities.lost[unitName] or 0
	 playerOwner.entities.lost[unitName] = ownerDeadCount + 1
      end
   end

end

---------------------------------------------------------------------------
-- Prints all the stats recorded for all players.
---------------------------------------------------------------------------
function Stats:PrintStatsAll()
   if not Stats.inited then
      return
   end

   print("Printing stats for game:")
   print("------------------------")
   print("playerCount: "..Stats.playerCount)
   for id,player in pairs(Stats.players) do
      Stats:PrintStatsForPlayer(id)
   end
end 

---------------------------------------------------------------------------
-- Prints all the stats recorded for the specified player.
---------------------------------------------------------------------------
function Stats:PrintStatsForPlayer(playerID)
   if not Stats.inited then
      return
   end

   local player = Stats.players[playerID]
   if not player then
      print("[Stats:PrintStatsForPlayer] Error: Failed to find player with id "..playerID.."!")
      return
   end
   print("Printing stats for player "..playerID)
   print("---------------------------")
   print("playerID: "..playerID)
   print("hero:")
   print("\tname: "..player.hero.heroname)
   print("\tlevel: "..player.hero.level)
   print("entities:")
   print("\ttrainedCountTotal: "..player.entities.trainedCountTotal)
   print("\tconstructedCountTotal: "..player.entities.constructedCountTotal)
   print("\tkilledCountTotal: "..player.entities.killedCountTotal)
   print("\tdestroyedCountTotal: "..player.entities.destroyedCountTotal)
   print("\tlostUnitCountTotal: "..player.entities.lostUnitCountTotal)
   print("\tlostBuildingCountTotal: "..player.entities.lostBuildingCountTotal)
   print("")
   print("\ttrained:")
   
   print("\tkilled:")
   
   print("\tlost:")
end
