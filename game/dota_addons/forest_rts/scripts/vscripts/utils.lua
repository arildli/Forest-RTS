

MARKET = "npc_dota_building_market"

if not Utils then
    Utils = {}
end



--[[ -----| Rotation spells |----- ]]--



-- For rotating a building under construction to the left.
function RotateLeft(keys)
    local building = keys.caster
    if not building then
        print("RotateLeft: caster was nil!")
        return
    end
    
    local currentFW = building:GetForwardVector()
    local x = SRing(currentFW.x)
    local y = SRing(currentFW.y)
    local z = 0.0
    
    if x == 1.0 and y == 0.0 then
        x = 0.7
        y = 0.7
    elseif x == 0.7 and y == 0.7 then
        x = 0.0
        y = 1.0
    elseif x == 0.0 and y == 1.0 then
        x = -0.7
        y = 0.7
    elseif x == -0.7 and y == 0.7 then
        x = -1.0
        y = 0.0
    elseif x == -1.0 and y == 0.0 then
        x = -0.7
        y = -0.7
    elseif x == -0.7 and y == -0.7 then
        x = 0.0
        y = -1.0
    elseif x == 0.0 and y == -1.0 then
        x = 0.7
        y = -0.7
    elseif x == 0.7 and y == -0.7 then
        x = 1.0
        y = 0.0
    end
    
    building:SetForwardVector(Vector(x, y, z))
    currentFW = building:GetForwardVector()
    --print("X: "..SRing(currentFW.x)..", Y: "..SRing(currentFW.y)..", Z: "..currentFW.z)
end



-- For rotating a building under construction to the right.
function RotateRight(keys)
    local building = keys.caster
    if not building then
        print("RotateLeft: caster was nil!")
        return
    end
    
    local currentFW = building:GetForwardVector()
    local x = SRing(currentFW.x)
    local y = SRing(currentFW.y)
    local z = 0.0
    
    if x == 1.0 and y == 0.0 then
        x = 0.7
        y = -0.7
    elseif x == 0.7 and y == -0.7 then
        x = 0.0
        y = -1.0
    elseif x == 0.0 and y == -1.0 then
        x = -0.7
        y = -0.7
    elseif x == -0.7 and y == -0.7 then
        x = -1.0
        y = 0.0
    elseif x == -1.0 and y == 0.0 then
        x = -0.7
        y = 0.7
    elseif x == -0.7 and y == 0.7 then
        x = 0.0
        y = 1.0
    elseif x == 0.0 and y == 1.0 then
        x = 0.7
        y = 0.7
    elseif x == 0.7 and y == 0.7 then
        x = 1.0
        y = 0.0
    end
    
    building:SetForwardVector(Vector(x, y, z))
    currentFW = building:GetForwardVector()
    --print("X: "..SRing(currentFW.x)..", Y: "..SRing(currentFW.y)..", Z: "..currentFW.z)
end



-- Performs a simple rounding.
function SRing(number)
    if number > -0.01 and number < 0.01 then
        return 0.0
    elseif number > 0.99 and number < 1.01 then
        return 1.0
    elseif number < -0.99 and number > -1.01 then
        return -1.0
    elseif number < -0.69 and number > -0.71 then
        return -0.7
    elseif number > 0.69 and number < 0.71 then
        return 0.7
    else
        --print("Number: "..number)
    end
end





--     -----| Economy |----- 





-- Spends the specified amount of gold and lumber for the hero if the
-- player has enough of these resources.
function SpendResources(unit, goldAmount, lumberAmount)
    if not unit or not goldAmount or not lumberAmount then
        print("SpendResources: unit, goldAmount or lumberAmount unspecified!")
        return false
    end
    
    local owner = unit:GetOwner()
    local playerID = owner:GetPlayerID()
    if not playerID then
        print("SpendResources: Couldn't get owner of 'hero'!")
        return false
    end
    local hero = GetPlayerHero(playerID)
    if not hero then
        print("SpendResources: hero was nil!")
        return false
    end
    local currentGold = PlayerResource:GetGold(playerID)
    
    if currentGold < goldAmount then
        print("Gold required: "..goldAmount..", Current gold: "..currentGold)
        return false
    end

    if SpendLumber(hero, lumberAmount) == true then
        PlayerResource:SpendGold(playerID, goldAmount, 0)
        return true
    else
        print("Lumber required: "..lumberAmount)
        return false
    end
end



-- Spends "amount" lumber from the "hero".
function SpendLumber(hero, amount)
    local lumberCount = hero:GetLumber()

    if lumberCount > amount or lumberCount == amount then
        hero:DecLumberNoStats(amount)
        return true
    else
        return false
    end
end



function HasEnoughLumber(hero, amount)
    local lumber = hero:GetLumber()

    return (lumber >= amount)
end



-- Gives "amount" number of charges to "itemName" of "hero"
function GiveCharges(hero, amount, itemName)
    
    if not hero or not amount or not itemName then
        return false
    end
    if amount == 0 then
        return true
    end
    
    if hero:HasItemInInventory(itemName) then
        local item = GetItemFromInventory(hero, itemName)
        local currentCharges = item:GetCurrentCharges()
        --print("Charges before: "..currentCharges)
        item:SetCurrentCharges(currentCharges + amount)
        --print("Charges after: "..item:GetCurrentCharges())
        return true
    else
        local newItem = CreateItem(itemName, hero, hero)
        if not newItem then
            return false
        end
        
        newItem:SetCurrentCharges(amount)
        --print("Charges of new item: "..newItem:GetCurrentCharges())
        
        if hero:IsRealHero() then
            if hero:HasInventory() and hero:HasRoomForItem(itemName, false, false) then
                hero:AddItem(newItem)
            else
                CreateItemOnPositionSync(hero:GetOrigin(), newItem)
            end
        else
            hero:AddItem(newItem)
        end
        return true
    end
end



-- Give gold to the player.
function GiveGoldToPlayer(playerID, amount)
    local currentGold = PlayerResource:GetReliableGold(playerID)
    PlayerResource:SetGold(playerID, currentGold + amount, true)
end



-- Buy gold for lumber.
function BuyGold(unit, wood, gold)
    if not unit or not wood or not gold then
        print("BuyGold: unit, wood or gold was nil!")
        return false
    end
    
    local playerHero = GetPlayerHero(unit:GetOwner():GetPlayerID())
    if HasEnoughLumber(playerHero, wood) then
        local owner = unit:GetOwner()
        local ownerID = owner:GetPlayerID()
        local currentGold = PlayerResource:GetReliableGold(ownerID)
        playerHero:IncGold(gold)
        playerHero:DecLumber(wood)
        return true
    end
    
    return false
end



-- Buy gold for lumber through using a spell.
function BuyGoldFromSpell(keys)
    local unit = keys.caster
    local wood = keys.wood
    local gold = keys.gold
    
    if not BuyGold(unit, wood, gold) then
        print("Gold could not be bought!")
    end
end



function HarvestLumber(unit)
    if not unit.HARVESTER then
        Resources:InitHarvester(unit)
    end
    local tree = FindEmptyTree(unit, unit:GetAbsOrigin(), unit.HARVESTER.treeSearchRadius)
    if not tree then
        print("HarvestLumber: Failed to find tree in radius "..unit.HARVESTER.treeSearchRadius)
        return
    end

    local harvestAbility = unit:FindAbilityByName("srts_harvest_lumber_worker") or
        unit:FindAbilityByName("srts_harvest_lumber")
    if harvestAbility then
        Timers:CreateTimer({
            endTime = 0.05,
            callback = function()
                unit:CastAbilityOnTarget(tree, harvestAbility, playerID)
            end})
    end
end



-- Transfer all the lumber from a unit to another unit.
function TransferLumber(keys)
    local caster = keys.caster
    local target = keys.target
    local playerID = caster:GetOwner():GetPlayerID()
    local hero = GetPlayerHero(playerID)

    if not caster or not target or not hero then
        print("TransferLumber: caster, target or hero was nil!")
        return false
    end
    
    if Resources:IsValidDeliveryPoint(target) then 
    --if target:GetUnitName() == MARKET or target:GetUnitName() == "npc_dota_building_main_tent_small" then
        local lumberCount = GetLumberCount(caster)
        if lumberCount > 0 then
             local lumberItem = GetItemFromInventory(caster, "item_stack_of_lumber")
             if lumberItem then
            PopupLumber(caster, lumberCount)
            caster:RemoveItem(lumberItem)
             end
             hero:IncLumber(lumberCount)
             caster:ReturnToHarvest()
        else
            --print("TransferLumber: caster did not have any lumber!")
        end
    else
        print("TransferLumber: Target was not a Market or Main Tent!")
    end
end



-- Mark the tree occupied.
function RegisterHarvesterAtTree(keys)
     local caster = keys.caster
     local target = keys.target
     target._harvester = caster

     if not caster.HARVESTER then
            Resources:InitHarvester(caster)
     end

     caster.HARVESTER.prevTree = target
end

-- Mark the tree free for harvest.
function UnregisterHarvesterAtTree(keys)
     local caster = keys.caster
     local target = keys.target
     target._harvester = nil
end

-- Checks if the tree has a worker harvesting it.
function TreeIsEmpty(tree)
     if tree._harvester then
            return false
     end
     return true
end

-- Try to find a nearby unoccupied tree near the unit.
function FindEmptyTree(unit, location, radius)
     local nearbyTrees = GridNav:GetAllTreesAroundPoint(location, radius, true)

     -- EDITED
     --[=[for _,tree in pairs(nearbyTrees) do
            -- IsTreePathable(tree)
            local color
            if IsTreePathable(tree) then
         color = Vector(35, 231, 38)
            else
         color = Vector(238, 2, 2)
            end
            DebugDrawCircle(tree:GetCenter(), color, 5, 100, false, 3)
     end
     DebugDrawCircle(location, Vector(200, 200, 200), 5, radius, false, 3)
     ]=]
     -- DONE

     -- EDITED
     local pathableTrees = GetAllPathableTreesFromList(location.z, nearbyTrees)
     -- DONE
     --local pathableTrees = GetAllPathableTreesFromList(nearbyTrees)
     if #pathableTrees == 0 then
            print("FindEmptyTree: No nearby empty trees found!")
            return nil
     end
     
     local sortedList = SortListByClosest(pathableTrees, location)
     for _,tree in pairs(sortedList) do
            if TreeIsEmpty(tree) and IsTreePathable(tree) then
         return tree
            end
     end
end

-- Checks if the tree is pathable.
function IsTreePathable( tree )
     return tree.pathable
end

function GetAllPathableTreesFromList( height, list )
     local pathable_trees = {}
     for _,tree in pairs(list) do
            if IsTreePathable(tree) then
         table.insert(pathable_trees, tree)
            end
            -- EDITED
            --[=[local treeHeight = tree:GetCenter().z
            if IsTreePathable(tree) and treeHeight == height then
         table.insert(pathable_trees, tree)
            end
            ]=]
            -- DONE
     end
     return pathable_trees
end

function GetClosestEntityToPosition(list, position)
     local distance = 20000
     local closest = nil
     
     for k,ent in pairs(list) do
            local this_distance = (position - ent:GetAbsOrigin()):Length()
            if this_distance < distance then
         distance = this_distance
         closest = k
            end
     end
     
     return closest   
end

function SortListByClosest( list, position )
        local trees = {}
        for _,v in pairs(list) do
                trees[#trees+1] = v
        end

        local sorted_list = {}
        for _,tree in pairs(list) do
                local closest_tree = GetClosestEntityToPosition(trees, position)
                sorted_list[#sorted_list+1] = trees[closest_tree]
                trees[closest_tree] = nil -- Remove it
        end
        return sorted_list
end

-- Implemented by Noya
--https://en.wikipedia.org/wiki/Flood_fill
function DeterminePathableTrees()
     
    --------------------------
    --      Flood Fill      --
    --------------------------

    print("DeterminePathableTrees")
     
    local world_positions = {}
    local valid_trees = {}
    local seen = {}
     
    --Set Q to the empty queue.
    local Q = {}

    --Add node to the end of Q.
    table.insert(Q, Vector(-7200, -6600, 0))
    --table.insert(Q, Vector(0,0,0))
     
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

    while #Q > 0 do
        --Set n equal to the first element of Q and Remove first element from Q.
        local position = table.remove(Q)
            
        --If the color of n is equal to target-color:
        local blocked = GridNav:IsBlocked(position) or not GridNav:IsTraversable(position)
        if not blocked then
         
            table.insert(world_positions, position)
         
            -- Mark position processed.
            seen[GridNav:WorldToGridPosX(position.x)..","..GridNav:WorldToGridPosX(position.y)] = 1
            for k=1,#vecs do
                local vec = vecs[k]
                local xoff = vec.x
                local yoff = vec.y
                local pos = Vector(position.x + xoff, position.y + yoff, position.z)

                -- Add unprocessed nodes
                if not seen[GridNav:WorldToGridPosX(pos.x)..","..GridNav:WorldToGridPosX(pos.y)] then
                    table.insert(world_positions, position)
                    table.insert(Q, pos)
                end
            end
        else
            local nearbyTree = GridNav:IsNearbyTree(position, 64, true)
            if nearbyTree then
                local trees = GridNav:GetAllTreesAroundPoint(position, 1, true)
                if #trees > 0 then
                    local t = trees[1]
                    t.pathable = true
                    table.insert(valid_trees,t)
                end
            end
        end
    end

    print("Number of valid trees: "..#valid_trees)
end


-- Transfer all the lumber from a unit to a hero.
function TransferLumberHero(keys)
    local caster = keys.caster
    local target = keys.target

    if not caster or not target then
        print("TransferLumber: caster or target was nil!")
        return false
    end
    
    local lumberCount = GetLumberCount(caster)
    if lumberCount > 0 then
        SpendLumber(caster, lumberCount)
        GiveCharges(target, lumberCount, "item_stack_of_lumber")
    else
        print("TransferLumber: caster did not have any lumber!")
    end
end



-- Gives gold to the specified player
--[=[
function GiveGold(keys)
    if not keys.caster or not keys.amount then
        print("GiveGold: caster or amount was nil!")
        return false
    end
    
    local gold = keys.amount
    local caster = keys.caster
    local owner = caster:GetOwner()
    local ownerID = owner:GetPlayerID()
    local currentGold = PlayerResource:GetReliableGold(ownerID)
    PopupGoldGain(caster, gold)
    PlayerResource:SetGold(ownerID, currentGold + gold, true)
    print("GiveGold called!")
    Stats:AddGold(ownerID, gold)
    return true
end]=]



-- Returns a handle to the first occurence of the item if the hero has it
function GetItemFromInventory(hero, itemName)
    
    if not hero or not itemName then
        return nil
    end
    
    if hero:HasItemInInventory(itemName) then
        for i=0, 5 do
            local currentItem = hero:GetItemInSlot(i)
            if currentItem and currentItem:GetAbilityName() == itemName then
        return currentItem
            end
        end
    else
        return nil
    end
end



-- Returns the number of lumber the unit is carrying.
function GetLumberCount(unit)
    local lumberStack = GetItemFromInventory(unit, "item_stack_of_lumber")
    if lumberStack then
        return lumberStack:GetCurrentCharges()
    else
        print("GetLumberCount: unit did not have any lumber!")
        return 0
    end
end



--[[ -----| Other |----- ]]--



---------------------------------------------------------------------------
-- Returns a copy of the specified table.
-- Taken from http://lua-users.org/wiki/CopyTable.
-- * orig: Table to copy
---------------------------------------------------------------------------
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end



---------------------------------------------------------------------------
-- Temporarily grants vision of the caster to the other team.
---------------------------------------------------------------------------
function GiveVisionOfUnit(keys)
    local caster = keys.caster
    local target = keys.target
    
    local team = caster:GetTeam()
    if team == DOTA_TEAM_GOODGUYS then
        team = DOTA_TEAM_BADGUYS
    elseif team == DOTA_TEAM_BADGUYS then
        team = DOTA_TEAM_GOODGUYS
    end
    
    AddFOWViewer(team, caster:GetAbsOrigin(), 500, 0.75, true)
end



---------------------------------------------------------------------------
-- Temporarily grants vision of the caster to the other team.
---------------------------------------------------------------------------
function GiveVisionOfHero(keys)
    local caster = keys.caster
    local target = keys.target
    
    local team = caster:GetTeam()
    if team == DOTA_TEAM_GOODGUYS then
        team = DOTA_TEAM_BADGUYS
    elseif team == DOTA_TEAM_BADGUYS then
        team = DOTA_TEAM_GOODGUYS
    end
    
    AddFOWViewer(team, caster:GetAbsOrigin(), 3000, 0.75, true)
end



---------------------------------------------------------------------------
-- Function used to test if an ability works.
---------------------------------------------------------------------------
function AbilityTestPrint(keys)
    local ability = keys.ability
    if not ability then print("Ability Was nil, but function was still called!") end
    if keys.text then
         print("(ability:GetAbilityName()): "..keys.text)
    else
         print("Calling from ability: "..ability:GetAbilityName())
    end
end



---------------------------------------------------------------------------
-- Returns the ability if unit has it, nil otherwise.
--
--  * unit: The unit to check
--  * abilityName: The ability to look for
--
---------------------------------------------------------------------------
function UnitHasAbility(unit, abilityName)  
    for i=0, 6 do
        local ability = unit:GetAbilityByIndex(i)
        if ability and ability:GetAbilityName() == abilityName then
            return ability
        end
    end
    return nil
end


---------------------------------------------------------------------------
-- Checks if the specified unit is ranged.
-- @unit: The unit to check.
-- @abilityName: The name of the ability to get.
---------------------------------------------------------------------------
function GetAbilityByName(unit, abilityName)
        return UnitHasAbility(unit, abilityName)
end



---------------------------------------------------------------------------
-- Checks if the specified unit is ranged.
--- * unit: The unit to check.
---------------------------------------------------------------------------
function IsRanged(unit)
     return unit:GetAttackRange() > 150 and 
            unit:GetUnitName() ~= "npc_dota_creature_kobold_guard_1"
end



---------------------------------------------------------------------------
-- Checks if the specified unit is ranged.
---------------------------------------------------------------------------
function GetAllAbilities(unit)
        local abilities = {}
        for i=0, 6 do
                local ability = unit:GetAbilityByIndex(i)
                if ability then
                        local index = ability:GetAbilityName()
                        abilities[index] = ability
                end
        end
        return abilities
end



---------------------------------------------------------------------------
-- Adds a new ability to the unit and skills it.
---------------------------------------------------------------------------
function LearnAbility(unit, abilityName)
    unit:AddAbility(abilityName)
    if unit:HasAbility(abilityName) then
        local ability = unit:FindAbilityByName(abilityName)
        ability:SetLevel(1)
    end
end



---------------------------------------------------------------------------
-- Unlearns and removes an ability from the unit
---------------------------------------------------------------------------
function UnlearnAbility(unit, abilityName)
    unit:RemoveAbility(abilityName)
end




---------------------------------------------------------------------------
-- Checks if the specified unit is a worker.
--- * unit: The unit to check.
---------------------------------------------------------------------------
function IsWorker(unit)
    return unit:GetUnitName():find("worker")
end



---------------------------------------------------------------------------
-- Updates the worker count panel of the player.
---------------------------------------------------------------------------
function UpdateWorkerPanel(playerHero)
    local ownerPlayer = playerHero:GetOwnerPlayer()
    if not ownerPlayer then
        print("Error: Couldn't get owner of hero!")
        return
    end
    local playerID = playerHero:GetOwnerID()
    if IsBot(playerID) then
        return
    end
    local curWorkerCount = playerHero:GetWorkerCount()
    CustomGameEventManager:Send_ServerToPlayer(ownerPlayer, "new_worker_count", {maxWorkerCount=MAX_WORKER_COUNT, newWorkerCount=curWorkerCount})
end



---------------------------------------------------------------------------
-- Checks if any of the variables are nil.
--   * funcName: Name of the function calling this.
--   * vars: The table containing the variables to be checked.
--   * len: The number of elements in the vars table.
---------------------------------------------------------------------------
function IsNil(funcName, vars, len)
    local varsType = type(vars)
    if varsType == "table" then
        local proper = true
        for i=1,len do
            local cur = vars[i]
            if not cur then
        print(funcName..": index "..i.." is nil!")
        proper = false
            end
        end
        return proper
    else
        print("IsNull: vars must be a table, was "..varsType)
        return false
    end
end

---------------------------------------------------------------------------
-- Checks if the player is a bot.
-- @playerID: The playerID of the player to check.
---------------------------------------------------------------------------
function IsBot(playerID)
    return (PlayerResource:GetConnectionState(playerID) == 1)
end





--[[ -----| Spell Replacement |----- ]]--





-- Prints info if DEBUG mode.
function printDebug(functionName, message)
    if DEBUG == true then
        print(functionName.."   DEBUG: "..message)
    end
end





--[[ -----| Report Stats |----- ]]--





-- Increase the chosen stat
function ReportStat(player, amount, statName)
    if not player or not amount or not statName then
        print("ReportStat: player, amount or statName was nil!")
        return
    end
    
    if not player._stats then
        player._stats = {}
    end
    
    if not player._stats[statName] then
        player._stats[statName] = amount
    else
        player._stats[statName] = player._stats[statName] + amount
    end
    
    if DEBUG_UTILS == true then
        print("Stat: "..statName.."\tValue: "..player._stats[statName])
    end
end
