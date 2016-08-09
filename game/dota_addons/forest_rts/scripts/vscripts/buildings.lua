


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
    building._finished = true

    -- Remove rotation spells.
    building:RemoveAbility(rotateRight)
    building:RemoveAbility(rotateLeft)
    building:RemoveAbility(cancelConstruction)

    local playerHero = building:GetOwnerHero() or GetPlayerHero(building:GetOwner():GetPlayerID())

    -- Register Trained
    TechTree:RegisterIncident(building, true)
    TechTree:AddAbilitiesToEntity(building)

    if not building.gold_cost or not building.lumber_cost then
        print("Either .gold_cost or .lumber_cost was nil!")
    end

    local playerID = building:GetOwnerID()
    Stats:OnTrained(playerID, building, "building")
    Stats:SpendGold(playerID, building.gold_cost)
    Stats:SpendLumber(playerID, building.lumber_cost)

    local event = {
        playerID = building:GetOwnerID(),
        building = building:GetEntityIndex()
    }
    FireGameEvent("construction_done", event)
end



function cancelUpgrade(keys)
end



function prepareUpgrade(keys)
end



function finishUpgrade(keys)
    local caster = keys.caster
    local ability = keys.ability
    local modifier = keys.modifier
    local newBuildingName = keys.newUnitName
    local building = keys.caster
    local buildingOrigin = building:GetOrigin()
    local ownerHero = building:GetOwnerHero()
    local ownerTeam = ownerHero:GetTeamNumber()
    local ownerPlayer = building:GetOwnerPlayer()
    local ownerID = building:GetOwnerID()

    building._upgraded = true
    ownerHero:RemoveBuilding(building)
    local newBuilding = BuildingHelper:UpgradeBuilding(building, newBuildingName)
    newBuilding.gold_cost = keys.goldCost
    newBuilding.lumber_cost = keys.lumberCost
    newBuilding._finished = true
    ownerHero:IncUnitCountFor(newBuildingName)
    TechTree:AddPlayerMethods(newBuilding, ownerPlayer)
    addRallyFunctions(newBuilding)

    if not newBuilding.gold_cost or not newBuilding.lumber_cost then
        print("Either .gold_cost or .lumber_cost was nil!")
    end

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
        caster:Stop()
        return false
    else
        caster._canAfford = true

        -- Finish channeling ASAP if cheat.
        if AI and AI.speedUpTraining then
            Timers:CreateTimer({
                endTime = 0.05,
                callback = function() ability:EndChannel(false)
            end})
            
        end

        return true
    end
end



---------------------------------------------------------------------------
-- Refunds the resources spent on cancel of training spell.
---------------------------------------------------------------------------
function RefundResources(keys)
    local caster = keys.caster
    if caster._canAfford == false then
        return
    end

    local player = caster:GetOwner()
    local playerID = player:GetPlayerID()
    local playerHero = GetPlayerHero(playerID)

    local goldCost = keys.goldCost
    local currentGold = PlayerResource:GetReliableGold(playerID)
    local lumberCost = keys.lumberCost
    playerHero:IncGoldNoStats(goldCost)
    playerHero:IncLumberNoStats(lumberCost)
end

---------------------------------------------------------------------------
-- Refunds the resources spent on the construction of the building.
---------------------------------------------------------------------------
function RefundResourcesConstruction(keys)
    local caster = keys.caster
    if not caster then
        return
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
    playerHero:IncGoldNoStats(goldCost)
    playerHero:IncLumberNoStats(lumberCost)
    --GiveCharges(playerHero, lumberCost, "item_stack_of_lumber")

    caster._wasCancelled = true
    if not keys.keepAlive then
        caster:ForceKill(false)
    end
end

---------------------------------------------------------------------------
-- Gives gold to a player with a gold popup.
---------------------------------------------------------------------------
function GivePlayerGold(keys)
    local caster = keys.caster
    local ownerID = caster:GetOwnerID() or caster:GetPlayerOwnerID()
    local ownerHero = caster:GetOwnerHero()
    local amount = keys.amount

    ownerHero:IncGold(amount)
    PopupGoldGain(caster, amount)
end



---------------------------------------------------------------------------
-- Returns true if building, false otherwise.
--- * building: The unit to check.
---------------------------------------------------------------------------
function IsBuilding(building)
    return IsCustomBuilding(building) or (building._building ~= nil)
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
    Stats:SpendGold(playerID, keys.goldCost)
    Stats:SpendLumber(playerID, keys.lumberCost)

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



---------------------------------------------------------------------------
-- Run when a building gets attacked.
---------------------------------------------------------------------------
function OnBuildingAttacked(event)
    local building = event.caster
    local playerID = building:GetOwnerID()
    local unitEntIndex = building:GetEntityIndex()
    FireGameEvent("building_attacked", {playerID=playerID, building=unitEntIndex})
end



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