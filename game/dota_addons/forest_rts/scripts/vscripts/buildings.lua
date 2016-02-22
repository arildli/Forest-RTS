


if ConstructionUtils == nil then
   print("[ConstructionUtils] ConstructionUtils is starting!")
   ConstructionUtils = {}
   ConstructionUtils.__index = ConstructionUtils
end

function ConstructionUtils:new(o)
   o = o or {}
   setmetatable(o, ConstructionUtils)
   return o
end




-- FIKS "TO EDIT" I builder.lua!!!





function prepareConstruction(building, abilityName)
   building._interrupted = false

   local owner = building:GetOwner()
   TechTree:AddPlayerMethods(building, owner)

   -- Temporarily learn the rotation spells.
   rotateLeft = "srts_rotate_left"
   rotateRight = "srts_rotate_right"
   cancelConstruction = "srts_cancel_construction"
   
   building:AddAbility(rotateLeft)
   building:AddAbility(rotateRight)
   building:AddAbility(cancelConstruction)
   building:FindAbilityByName(rotateLeft):SetLevel(1)
   building:FindAbilityByName(rotateRight):SetLevel(1)
   building:FindAbilityByName(cancelConstruction):SetLevel(1)
   
   function building:SetRallyPoint(pos)
      building._rallyPoint = Vector(pos["0"], pos["1"], pos["2"])
   end

   function building:GetRallyPoint()
      return building._rallyPoint
   end

   -- Register construction in Tech Tree.
   TechTree:RegisterConstruction(building, abilityName)
end



function finishConstruction(building)
   if not building:IsAlive() or building._interrupted == true then
      --print("attemptConstruction: Note: building was destroyed before finish.")
      print("BUILDING WAS INTERRUPTED OR NOT ALIVE!")
      return
   end
   
   local interrupted = "nil"
   if building._interrupted == true then
      interrupted = "true"
   elseif building._interrupted == false then
      interrupted = "false"
   end
   building._building = true

   -- Remove rotation spells.
   building:RemoveAbility(rotateRight)
   building:RemoveAbility(rotateLeft)
   building:RemoveAbility(cancelConstruction)
   
   local playerHero = GetPlayerHero(building:GetOwner():GetPlayerID())

   -- Register Trained
   TechTree:RegisterIncident(building, true)
   TechTree:AddAbilitiesToEntity(building)
   --TechTree:UpdateSpellsForEntity(building, playerHero)
end





--					-----| Economy Units and Buildings |-----





---------------------------------------------------------------------------
-- Refunds the gold cost before charging it again.
-- Unit edition of CheckIfCanAfford().
---------------------------------------------------------------------------
function CheckIfCanAffordUnit(keys)
   local goldCost = keys.goldCost
   local caster = keys.caster
   local playerID = caster:GetOwner():GetPlayerID()
   GiveGoldToPlayer(playerID, goldCost)
   CheckIfCanAfford(keys)
end



---------------------------------------------------------------------------
-- Check if the player can afford the purchase.
-- Refunds the initial gold cost and stops channeling
-- if not.
---------------------------------------------------------------------------
function CheckIfCanAfford(keys)
   local ability = keys.ability
   local caster = keys.caster
   local goldCost = keys.goldCost
   local lumberCost = keys.lumberCost

   if SpendResources(caster, goldCost, lumberCost) == false then
      caster._canAfford = false
      if DEBUG_CONSTRUCT_BUILDING == true then
	 print("caster._canAfford set to 'false'")
      end
      caster:Stop()
   else
      caster._canAfford = true
      if DEBUG_CONSTRUCT_BUILDING == true then
	 print("caster._canAfford set to 'true'")
      end
   end
end



---------------------------------------------------------------------------
-- Refunds the resources spent on cancel of training spell.
---------------------------------------------------------------------------
function RefundResources(keys)
   local caster = keys.caster
   if not caster then
      print("Caster is nil!")
   end

   if caster._canAfford == false then
      if DEBUG_CONSTRUCT_BUILDING == true then
	 print("Caster can afford: false")
      end
      return
   end
   if DEBUG_CONSTRUCT_BUILDING == true then
      print("Caster can afford: true")
   end

   local player = caster:GetOwner()
   local playerID = player:GetPlayerID()
   local playerHero = GetPlayerHero(playerID)

   local gold = keys.goldCost
   local currentGold = PlayerResource:GetReliableGold(playerID)
   PlayerResource:SetGold(playerID, currentGold + gold, true)
   local lumber = keys.lumberCost
   playerHero:IncLumber(keys.lumberCost)
   --GiveCharges(playerHero, lumber, "item_stack_of_lumber")
end



-- Refunds the resources spent on the construction of the building.
function RefundResourcesConstruction(keys)
   local caster = keys.caster
   if not caster then
      print("Caster is nil!")
      return
   end

   print("\n\t\tRefundResourcesConstruction called!!!\n")

   if DEBUG_CONSTRUCT_BUILDING == true then
      print("Construction cancelled!")
   end

   local player = caster:GetOwner()
   local playerID = player:GetPlayerID()
   local playerHero = GetPlayerHero(playerID)

   local goldCost = caster._goldCost
   local lumberCost = caster._lumberCost
   if not goldCost or not lumberCost then
      print("RefundResourcesConstruction: caster was missing either goldCost or lumberCost!")
      return
   end
   GiveGold({caster = keys.caster, amount = goldCost})
   GiveCharges(playerHero, lumberCost, "item_stack_of_lumber")

   caster._wasCancelled = true
   caster:ForceKill(false)
end



---------------------------------------------------------------------------
-- Returns true if building, false otherwise.
--- * building: The unit to check.
---------------------------------------------------------------------------
function IsBuilding(building)
   return building._building or IsCustomBuilding(building)
end



---------------------------------------------------------------------------
-- Run when a unit is trained to make sure the unit works properly.
---------------------------------------------------------------------------
function OnUnitTrained(keys)
   local caster = keys.caster
   local target = keys.target

   if target:GetUnitName() == "bh_dummy_unit" then
      return
   end
   
   local owner = caster:GetOwnerPlayer() or caster:GetOwner()
   TechTree:AddPlayerMethods(target, owner)

   --local player = caster:GetOwner()
   --local playerID = player:GetPlayerID()
   --local playerHero = GetPlayerHero(playerID)
   local playerHero = caster:GetOwnerHero()
   target:SetOwner(playerHero)
   target:SetHasInventory(true)
   
   -- Register Trained
   TechTree:RegisterIncident(target, true)
   TechTree:AddAbilitiesToEntity(target)

   -- Update worker panel of owner hero.
   if IsWorker(target) then
      UpdateWorkerPanel(playerHero)
   end
   
   -- Apply current upgrades.
   ApplyUpgradesOnTraining(target)

   -- Move to rally point if it exists.
   local rallyPoint = caster:GetRallyPoint()
   if rallyPoint then
      Timers:CreateTimer({
			    endTime = 0.1,
			    callback = function()
			       target:MoveToPosition(rallyPoint)
			    end})
   end
end



