


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
    building._playerOwned = true

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

    addRallyFunctions(building)

    -- Register construction in Tech Tree.
    TechTree:RegisterConstruction(building, abilityName)

    local event = {
        playerID = building:GetOwnerID(),
        building = building:GetEntityIndex()
    }
    FireGameEvent("construction_started", event)
end


function addRallyFunctions(building)
    function building:SetRallyPoint(pos)
        building._rallyPoint = Vector(pos["0"], pos["1"], pos["2"])
    end

    function building:GetRallyPoint()
        return building._rallyPoint
    end
end


function finishConstruction(building)  
    if not building:IsAlive() or building._interrupted == true then
        return
    end
    
    local interrupted = "nil"
    if building._interrupted == true then
        interrupted = "true"
    elseif building._interrupted == false then
        interrupted = "false"
    end
    building._building = true
    building._playerOwned = true

    -- Remove rotation spells.
    building:RemoveAbility(rotateRight)
    building:RemoveAbility(rotateLeft)
    building:RemoveAbility(cancelConstruction)

    local playerHero = GetPlayerHero(building:GetOwner():GetPlayerID())

    -- Register Trained
    TechTree:RegisterIncident(building, true)
    TechTree:AddAbilitiesToEntity(building)
    --TechTree:UpdateSpellsForEntity(building, playerHero)

    local playerID = building:GetOwnerID()
    Stats:OnTrained(playerID, building, "building")

    local event = {
        playerID = building:GetOwnerID(),
        building = building:GetEntityIndex()
    }
    FireGameEvent("construction_done", event)
end



function cancelUpgrade(keys)
    local building = keys.caster
    --print("Note: Upgrade cancelled for "..building:GetUnitName())
end



function prepareUpgrade(keys)
    --print("Note: Upgrade started for "..keys.caster:GetUnitName())
end



function finishUpgrade(keys)
    --print("Note: Upgrade finished!")

    local caster = keys.caster
    local ability = keys.ability
    local modifier = keys.modifier
    local newBuildingName = keys.newUnitName
    local building = keys.caster
    local buildingOrigin = building:GetOrigin()
    --print("Note: "..building:GetUnitName().." finished upgrade!")
    local ownerHero = building:GetOwnerHero()
    local ownerTeam = ownerHero:GetTeamNumber()
    local ownerPlayer = building:GetOwnerPlayer()
    local ownerID = building:GetOwnerID()
    --local buildingSize = keys.buildingSize
    --ability:ApplyDataDrivenModifier(caster, building, modifier, {})
    --BuildingHelper:RemoveBuilding(building, true)

    building._upgraded = true
    ownerHero:RemoveBuilding(building)
    local newBuilding = BuildingHelper:UpgradeBuilding(building, newBuildingName)

    --local blockers = BuildingHelper:BlockGridNavSquare(buildingSize, buildingOrigin)
    --local newBuilding = CreateUnitByName(newBuildingName, buildingOrigin, false, ownerHero, ownerPlayer, ownerTeam)
    --newBuilding:SetControllableByPlayer(ownerID, true)
    --newBuilding.blockers = blockers
    newBuilding._finished = true
    ownerHero:IncUnitCountFor(newBuildingName)
    TechTree:AddPlayerMethods(newBuilding, ownerPlayer)
    --newBuilding:SetBaseHealthRegen(0)
    addRallyFunctions(newBuilding)
    finishConstruction(newBuilding)
end








--                  -----| Economy Units and Buildings |-----





---------------------------------------------------------------------------
-- Refunds the gold cost before charging it again.
-- Unit edition of CheckIfCanAfford().
---------------------------------------------------------------------------
function CheckIfCanAffordUnit(keys)
    local goldCost = keys.goldCost
    local caster = keys.caster
    local playerID = caster:GetOwner():GetPlayerID()
    GiveGoldToPlayer(playerID, goldCost)
    return CheckIfCanAfford(keys)
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
        print("CANNOT afford")
        return false
    else
        caster._canAfford = true
        if DEBUG_CONSTRUCT_BUILDING == true then
            print("caster._canAfford set to 'true'")
        end
        print("Can afford!")
        return true
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
        --if DEBUG_CONSTRUCT_BUILDING == true then
        print("Caster can afford: false")
        --end
        return
    end
    if DEBUG_CONSTRUCT_BUILDING == true then
        print("Caster can afford: true")
    end
    print("Refunding resources.")

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
    if not keys.keepAlive then
        print("Killed building after refunding!")
        caster:ForceKill(false)
    end
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
    target._playerOwned = true

    -- Register Trained
    TechTree:RegisterIncident(target, true)
    TechTree:AddAbilitiesToEntity(target)

    -- Update worker panel of owner hero.
    if IsWorker(target) then
        UpdateWorkerPanel(playerHero)
    end

    -- Apply current upgrades.
    ApplyUpgradesOnTraining(target)

    local playerID = target:GetOwnerID()
    Stats:OnTrained(playerID, target, "unit")

    -- EDITED render color
    --[=[
    local targetTeam = target:GetTeamNumber()
    print("targetTeam: "..targetTeam)
    print("Radiant: "..DOTA_TEAM_GOODGUYS)
    print("Dire: "..DOTA_TEAM_BADGUYS)
    local teamColor = {}
    if targetTeam == DOTA_TEAM_GOODGUYS then
        if not COLOR_RADIANT_RGB then
            print("Fuck Radiant!")
        end
        teamColor = COLOR_RADIANT_RGB
    elseif targetTeam == DOTA_TEAM_BADGUYS then
        if not COLOR_DIRE_RGB then
            print("Fuck Dire!")
        end
        teamColor = COLOR_DIRE_RGB
    end
    target:SetRenderColor(teamColor[1], teamColor[2], teamColor[3]) ]=]

    -- Move to rally point if it exists.
    local rallyPoint = caster:GetRallyPoint()
    if rallyPoint then
        Timers:CreateTimer({
            endTime = 0.1,
            callback = function()
            target:MoveToPosition(rallyPoint)
            end})
    end

    FireGameEvent("unit_trained", {playerID=playerID, unit=target:GetEntityIndex()})
end



