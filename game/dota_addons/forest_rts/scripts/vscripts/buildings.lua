




WORKER = COMMON_TRAIN_WORKER["name"]


if not CONSTRUCT_BUILDINGS_INIT then
	CONSTRUCT_BUILDINGS_INIT = true

	BUILDING_NAMES = {MAIN_BUILDING, WATCH_TOWER, HEALING_CRYSTAL, BARRACKS_BASIC, MARKET, ARMORY}
	BUILDING_SPELLS = {MAIN_BUILDING_SPELL, WATCH_TOWER_SPELL, HEALING_CRYSTAL_SPELL, BARRACKS_BASIC_SPELL, MARKET_SPELL, ARMORY_SPELL}
end

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
   
   -- Register construction in Tech Tree.
   SimpleTechTree:RegisterConstruction(building, abilityName)
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

   -- Remove rotation spells.
   building:RemoveAbility(rotateRight)
   building:RemoveAbility(rotateLeft)
   building:RemoveAbility(cancelConstruction)
   
   if not building then
      print("attemptConstruction:\tbuilding was nil upon construction finish!")
   end
   
   local playerHero = GetPlayerHero(building:GetOwner():GetPlayerID())

   -- Register Trained
   SimpleTechTree:RegisterIncident(building, true)
   SimpleTechTree:AddAbilitiesToBuilding(building)
   SimpleTechTree:UpdateSpellsOneUnit(playerHero, building)
end





function attemptConstruction(keys)

	local owner = keys.caster
	if SpendResources(owner, keys.goldCost, keys.lumberCost) == true then

		local point = BuildingHelper:AddBuildingToGrid(keys.target_points[1], 2, keys.caster)
		if point ~= -1 then
			local building = CreateUnitByName(keys.buildingName, point, false, owner, owner, owner:GetTeam())
			if not building then
				print("BUILDING WAS NIL!")
				return
			end

			-- In case the building is supposed to have a non-default rotation at start of construction.
			if keys.rotation_x or keys.rotation_y or keys.rotation_z then
				local currentFW = building:GetForwardVector()
				building:SetForwardVector(Vector(keys.rotation_x, keys.rotation_y, keys.rotation_z))
			end

			local buildingName = building:GetUnitName()
			local player = owner:GetOwner()
			local playerID = player:GetPlayerID()
			local playerHero = GetPlayerHero(playerID)
			local abilityName = keys.ability:GetAbilityName()
			local buildTime
			local initialScale = .2 * keys.scale
			if DEBUG then
				buildTime = 1
			else
				--buildTime = keys.buildTime
				buildTime = building:GetMaxHealth() * BUILDINGHELPER_THINK
			end

			if buildingName == MARKET.name then
				building:SetHasInventory(true)
			end

			building._goldCost = keys.goldCost
			building._lumberCost = keys.lumberCost
			building._building = true
			building._interrupted = false

			-- BuildingHelper stuff
			BuildingHelper:AddBuilding(building)
			building:Pack()
			building:UpdateHealth(buildTime, true, keys.scale)
			building:SetControllableByPlayer( keys.caster:GetPlayerID(), true )
			building:SetOwner(playerHero)
			building._owner = player

			-- Temporarily learn the rotation spells.
			local rotateLeft = "srts_rotate_left"
			local rotateRight = "srts_rotate_right"
			local cancelConstruction = "srts_cancel_construction"

			building:AddAbility(rotateLeft)
			building:AddAbility(rotateRight)
			building:AddAbility(cancelConstruction)
			building:FindAbilityByName(rotateLeft):SetLevel(1)
			building:FindAbilityByName(rotateRight):SetLevel(1)
			building:FindAbilityByName(cancelConstruction):SetLevel(1)

			building:SetModelScale(initialScale)
			SimpleTechTree:RegisterConstruction(building, abilityName)

			-- On construction finish
			building:OnCompleted(function()

				if not building:IsAlive() or building._interrupted == true then
					--print("attemptConstruction: Note: building was destroyed before finish.")
					return
				end

				local interrupted = "nil"
				if building._interrupted == true then
					interrupted = "true"
				elseif building._interrupted == false then
					interrupted = "false"
				end

				-- Remove rotation spells.
				building:RemoveAbility(rotateRight)
				building:RemoveAbility(rotateLeft)
				building:RemoveAbility(cancelConstruction)

				if not building then
					print("attemptConstruction:\tbuilding was nil upon construction finish!")
				end

				-- Register Trained
				SimpleTechTree:RegisterIncident(building, true)
				SimpleTechTree:AddAbilitiesToBuilding(building)
				SimpleTechTree:UpdateSpellsOneUnit(playerHero, building)

				print("[ConstructionUtils]: Construction finished!")
			end)
		else
			--Fire a game event here and use Actionscript to let the player know he can't place a building at this spot.
			--GiveCharges(owner, keys.lumberCost, "item_stack_of_lumber")
			local args = {}
			args["caster"] = owner
			args["goldCost"] = keys.goldCost
			args["lumberCost"] = keys.lumberCost
			RefundResources(args)
			print("attemptConstruction: Cannot build there!")
		end
	else
		--FireGameEvent("custom_error_show", {player_ID = owner, _error = "Not enough Lumber!"})
		print("attemptConstruction: Not enough resources!")
	end
end



-- Check if the player can afford the purchase.
function CheckIfCanAfford(keys)
	local ability = keys.ability
	local caster = keys.caster
	local goldCost = keys.goldCost
	local lumberCost = keys.lumberCost

	if not ability then
		print("'ability' is nil!")
		return
	end

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



-- Refunds the resources spent on cancel of training spell.
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



-- Check if the target is a building
--[[
function CheckIfBuilding(keys)
	local ability = keys.ability
	local target = keys.target

	if not ability then
		print("'ability' is nil!")
		return
	end

	if not target._building then
		local caster = ability:GetCaster()
		caster:Stop()
	end
end
]]



---------------------------------------------------------------------------
-- Returns true if building, false otherwise.
--
--	* building: The unit to check.
--
---------------------------------------------------------------------------
function IsBuilding(building)
   return IsCustomBuilding(building)
end



-- Run when a unit is trained to make sure the unit works properly.
function OnUnitTrained(keys)
   local caster = keys.caster
   local target = keys.target
   
   if not caster then
      print("Caster is nil!")
   end
   if not target then
      print("Target is nil!")
   end
   if target:GetUnitName() == "bh_dummy_unit" then
      return
   end
   
   local player = caster:GetOwner()
   local playerID = player:GetPlayerID()
   local playerHero = PLAYER_HEROES[playerID]
   target:SetOwner(playerHero)
   target:SetHasInventory(true)
   
   if not target:GetOwner() then
      print("OnUnitTrained: Couldn't set owner to target!")
   end
   
   -- Register Trained
   SimpleTechTree:RegisterIncident(target, true)
   

	--[[
	local position = target:GetAbsOrigin()
	ExecuteOrderFromTable({ UnitIndex = target:GetEntityIndex(),
							OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
							Position = position, Queue = true })
	print(target:GetUnitName().." moving to position", position")
	]]


--	print("Ownership set to hero!")
end





