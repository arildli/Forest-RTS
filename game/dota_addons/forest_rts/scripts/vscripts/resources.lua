
if not Resources then
    Resources = {}
end

---------------------------------------------------------------------------
-- Inits the hero with the necessary properties to work with this
-- resource system.
---------------------------------------------------------------------------
function Resources:InitHero(hero, startLumber)
    if not hero or hero:IsRealHero() == false then
        print("Resources:InitHero: hero was either nil or not a hero!")
        return false
    end

    local playerID = hero:GetOwner():GetPlayerID()
    if not playerID then
        print("Resources:InitHero: playerID was nil!")
        return false
    end

    hero.SRES = {}
    hero.SRES.lumber = startLumber or 0

    ---------------------------------------------------------------------------
    -- Returns the gold count of the hero.
    ---------------------------------------------------------------------------
    function hero:GetGold()
        return PlayerResource:GetGold(hero:GetOwner():GetPlayerID())
    end

    ---------------------------------------------------------------------------
    -- Returns the lumber count of the hero.
    ---------------------------------------------------------------------------
    function hero:GetLumber()
        return hero.SRES.lumber
    end

    ---------------------------------------------------------------------------
    -- Returns if the hero has more gold than the specified amount.
    ---------------------------------------------------------------------------
    function hero:HasEnoughGold(amount)
        return hero:GetGold() >= amount
    end

    ---------------------------------------------------------------------------
    -- Returns if the hero has more lumber than the specified amount.
    ---------------------------------------------------------------------------
    function hero:HasEnoughLumber(amount)
        return hero:GetLumber() >= amount
    end

    ---------------------------------------------------------------------------
    -- Sets the gold count of the hero.
    ---------------------------------------------------------------------------
    function hero:SetGold(amount)
        PlayerResource:SetGold(hero:GetOwnerID(), 0, false)
        PlayerResource:SetGold(hero:GetOwnerID(), amount, true)
    end

    ---------------------------------------------------------------------------
    -- Sets the lumber count of the hero.
    ---------------------------------------------------------------------------
    function hero:SetLumber(amount)
        hero.SRES.lumber = amount
        local player = hero:GetOwner()
        CustomGameEventManager:Send_ServerToPlayer(player, "player_lumber_changed", { lumber = math.floor(amount) })
    end

    ---------------------------------------------------------------------------
    -- Increases the gold count of the hero.
    ---------------------------------------------------------------------------
    function hero:IncGold(amount, skipStats)
        hero:SetGold(hero:GetGold() + amount)
        if not skipStats then
            Stats:AddGold(hero:GetOwnerID(), amount)
        end
    end

    ---------------------------------------------------------------------------
    -- Increases the gold count of the hero without modifying the stats.
    ---------------------------------------------------------------------------
    function hero:IncGoldNoStats(amount)
        hero:IncGold(amount, true)
    end

    ---------------------------------------------------------------------------
    -- Increases the lumber count of the hero.
    ---------------------------------------------------------------------------
    function hero:IncLumber(amount, skipStats)
        hero.SRES.lumber = hero.SRES.lumber + amount
        local player = hero:GetOwner()
        if not skipStats then
            Stats:AddLumber(hero:GetOwnerID(), amount)
        end
        CustomGameEventManager:Send_ServerToPlayer(player, "player_lumber_changed", { lumber = math.floor(hero:GetLumber()) })
    end

    ---------------------------------------------------------------------------
    -- Increases the lumber count of the hero without recording stats for it.
    ---------------------------------------------------------------------------
    function hero:IncLumberNoStats(amount)
        hero:IncLumber(amount, true)
    end

    ---------------------------------------------------------------------------
    -- Decreases the gold of the hero.
    ---------------------------------------------------------------------------
    function hero:DecGold(amount, skipStats)
        local oldGold = hero:GetGold()
        hero:SetGold(oldGold - amount)
        if not skipStats then
            Stats:SpendGold(hero:GetOwnerID(), amount)
        end
    end

    ---------------------------------------------------------------------------
    -- Decreases the gold of the hero without recording stats for it.
    ---------------------------------------------------------------------------
    function hero:DecGoldNoStats(amount)
        hero:DecGold(amount, true)
    end

    ---------------------------------------------------------------------------
    -- Decreases the lumber count of the hero.
    ---------------------------------------------------------------------------
    function hero:DecLumber(amount, skipStats)
        hero.SRES.lumber = hero.SRES.lumber - amount
        if hero.SRES.lumber < 0 then
            hero.SRES.lumber = 0
        end
        local player = hero:GetOwner()
        if not skipStats then
            Stats:SpendLumber(hero:GetOwnerID(), amount)
        end
        CustomGameEventManager:Send_ServerToPlayer(player, "player_lumber_changed", { lumber = math.floor(hero:GetLumber()) })
    end

    ---------------------------------------------------------------------------
    -- Decreases the lumber count of the hero without recording stats for it.
    ---------------------------------------------------------------------------
    function hero:DecLumberNoStats(amount)
        hero:DecLumber(amount, true)
    end

    Stats:AddGold(playerID, hero:GetGold())
    Stats:AddLumber(playerID, hero.SRES.lumber)
end





---------------------------------------------------------------------------
-- Inits the unit or hero with the necessary properties to work with the
-- harvesting system.
---------------------------------------------------------------------------
function Resources:InitHarvester(unit)
    if not unit then
        print("Resources:InitHarvester: unit was nil!")
    end

    unit.HARVESTER = {}
    unit.HARVESTER.treeSearchRadius = 1000
    unit.HARVESTER.deliverSearchRadius = 2000
    unit.HARVESTER.prevTree = nil

    ---------------------------------------------------------------------------
    -- Updates the last tree location so that the worker can return to it
    -- after delivering the lumber to search for other trees to cut.
    ---------------------------------------------------------------------------
    function unit:SetLastTree(tree)
        unit.HARVESTER.prevTree = tree:GetAbsOrigin()
    end

    ---------------------------------------------------------------------------
    -- Returns the worker to the previous tree being cut to search for more
    -- trees.
    ---------------------------------------------------------------------------
    function unit:ReturnToHarvest()
        local newHarvestLocation
        if unit.HARVESTER.prevTree then
            newHarvestLocation = unit.HARVESTER.prevTree:GetCenter()
            unit.HARVESTER.prevTree = nil
        else
            newHarvestLocation = unit:GetAbsOrigin()
        end
        local ownerID = unit:GetOwner():GetPlayerID()
        unit.HARVESTER.newTree = FindEmptyTree(unit, newHarvestLocation, unit.HARVESTER.treeSearchRadius)
        if unit.HARVESTER.newTree then
            local harvestAbility
            if unit:IsRealHero() then
                harvestAbility = unit:FindAbilityByName("srts_harvest_lumber")
            else
                harvestAbility = unit:FindAbilityByName("srts_harvest_lumber_worker")
            end
            if harvestAbility then
                unit:CastAbilityOnTarget(unit.HARVESTER.newTree, harvestAbility, ownerID)
            end
        else
            print("unit:ReturnToHarvest: (Note) couldn't find new tree to harvest!")
        end
    end

    ---------------------------------------------------------------------------
    -- Returns the carried lumber to the nearest Tent or Market if possible.
    ---------------------------------------------------------------------------
    function unit:DeliverLumber()
        local owner = unit:GetOwnerPlayer()
        local ownerID = owner:GetPlayerID()
        local ownerHero = GetPlayerHero(ownerID)
        local unitPosition = unit:GetAbsOrigin()
        local closestDeliveryPoint = nil
        local shortestDeliveryDistance = 100000
        local returnAbility = unit:FindAbilityByName("srts_transfer_lumber")
        if not returnAbility then
            print("unit:DeliverLumber: unit did not have transfer ability!")
        end

        for _,building in pairs(ownerHero:GetBuildings()) do
            if building:IsNull() then
                print("Removed building for being null!")
                ownerHero:RemoveBuilding(building)
            else
                if building and building:IsAlive() and Resources:IsValidDeliveryPoint(building) then
                    local distanceToBuilding = (unitPosition - building:GetAbsOrigin()):Length()
                    if distanceToBuilding < shortestDeliveryDistance then
                        shortestDeliveryDistance = distanceToBuilding
                        closestDeliveryPoint = building
                    end
                end
            end
        end
        if not closestDeliveryPoint then
            print("unit:DeliverLumber: (Warning) No nearby delivery points found!")
        else
            unit:CastAbilityOnTarget(closestDeliveryPoint, returnAbility, ownerID)
        end
    end
end



---------------------------------------------------------------------------
-- Initializes the tree system.
--
-- Gatherer methods are borrowed from the currently unfinished
-- Gatherer library in the DotaCraft repo.
---------------------------------------------------------------------------
function Resources:InitTrees()
    if not Gatherer.AllTrees then
        Gatherer.AllTrees = Entities:FindAllByClassname("ent_dota_tree")
        Gatherer.TreeCount = #Gatherer.AllTrees
        -- Do some shit
    end

    local treeMapFile
    local status,ret = pcall(function()
        treeMapFile = require("tree_maps/"..GetMapName())
        if treeMapFile == nil then print("Bloody hell! File is nil!!!") end
        if treeMapFile then
            print("Tree map loaded!")
            Gatherer:LoadTreeMap(treeMapFile)
            return -- Skip heavy tree algorithms
        else
            print("No Tree Map file found for "..GetMapName())
        end
    end)

    local shouldGenerateMap = false
    if not shouldGenerateMap and treeMapFile then
        return
    end
    print("Running HEAVY tree algorithms!")

    Gatherer:DeterminePathableTrees()
    Gatherer:DetermineForests()
    if IsInToolsMode() then
        print("CREATING TREE MAP!")
        Gatherer:GenerateTreeMap()
    end
end

if not Gatherer then
    Gatherer = class({})
end

-- Defined on DeterminePathableTrees() and updated on tree_cut
function CDOTA_MapTree:IsPathable()
    return self.pathable == true
end

-- Defined on DetermineForests()
function CDOTA_MapTree:GetForestID()
    return self.forestID or 0
end

function CDOTA_MapTree:GetTreeID()
    return GetTreeIdForEntityIndex(self:GetEntityIndex())
end

function GetTreeHandleFromId(treeID)
    return EntIndexToHScript(GetEntityIndexForTreeId(tonumber(treeID)))
end

function Gatherer:DetermineForests()
    self.treeForests = {}

    local num = 0
    for _,tree in pairs(self.AllTrees) do
        if not tree.forestID then
            num = num + 1
        end
        Gatherer:MapTreeForest(tree, num)
    end

    -- Set
    for _,tree in pairs(self.AllTrees) do
        local id = tree.forestID
        self.treeForests[id] = self.treeForests[id] or {}
        table.insert(self.treeForests[id], tree)
    end
end

-- Recurse on the trees nearby
function Gatherer:MapTreeForest(tree, ID)
    if not tree.forestID then
        tree.forestID = ID
    end

    local treesNearby = GridNav:GetAllTreesAroundPoint(tree:GetAbsOrigin(), 200, true)
    for k,v in pairs(treesNearby) do
        if not v.forestID then
            Gatherer:MapTreeForest(v, ID)
        end
    end
end

-- Implemented by Noya
--https://en.wikipedia.org/wiki/Flood_fill
function Gatherer:DeterminePathableTrees()

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

-- Puts the saved tree map info on each tree handle
function Gatherer:LoadTreeMap(treeMapTable)
    local pathable_count = 0
    for treeID,values in pairs(treeMapTable) do
        local tree = GetTreeHandleFromId(treeID)
        if tree then
            local bPathable = values.pathable == 1
            if bPathable then pathable_count = pathable_count + 1 end
            tree.pathable = bPathable
            tree.forestID = values.forestID
        end
    end

    -- Populate the tree Forests lists
    for _,tree in pairs(self.AllTrees) do
        local id = tree.forestID
        self.treeForests[id] = self.treeForests[id] or {}
        table.insert(self.treeForests[id], tree)
    end

    print("Loaded Tree Map for "..GetMapName())
    print("Pathable count: "..pathable_count.." out of "..self.TreeCount)
    print(#self.treeForests.." Forests loaded.")
end

function Gatherer:GenerateTreeMap()
    local path = "../../dota_addons/".."forest_rts".."/scripts/vscripts/tree_maps/"..GetMapName()..".lua"
    self.treeMap = io.open(path, 'w')
    if not self.treeMap then
        print("Error: Can't open path "..path)
        return
    end

    print("Generating Tree Map for "..GetMapName().."...")
    self.treeMap:write("local trees = {")
    for forestID,treesInForest in pairs(self.treeForests) do
        for _,tree in pairs(treesInForest) do
            local pathable = tree:IsPathable() and 1 or 0
            local forestID = tree:GetForestID()
            --self.treeMap:write("\n"..string.rep(" ",4)..string.format("%4s",tree:GetTreeID()).." = {pathable = "..pathable..", forestID = "..forestID.."},")
            self.treeMap:write("\n"..string.rep(" ",4)..string.format("[%4s]",tree:GetTreeID()).." = {pathable = "..pathable..", forestID = "..forestID.."},")
        end
    end
    self.treeMap:write("\n}\n")
    self.treeMap:write("return trees")
    self.treeMap:close()
    print("Tree Map generated at "..path)
end

-- End Gatherer code.



---------------------------------------------------------------------------
-- Returns true if unit can accept lumber deliveries.
---------------------------------------------------------------------------
function Resources:IsValidDeliveryPoint(building)
    return (IsBuilding(building) and UnitHasAbility(building, "srts_ability_delivery_point"))
end




---------------------------------------------------------------------------
-- Returns whether or not this unit has been inited.
---------------------------------------------------------------------------
function Resources:HasBeenInit(unit)
    return (unit.SRES ~= nil)
end



---------------------------------------------------------------------------
-- Returns the number of lumber the unit is carrying.
---------------------------------------------------------------------------
function Resources:GetLumberCarried(unit)
    local lumberStack = GetItemFromInventory(unit, "item_stack_of_lumber")
    if lumberStack then
        return lumberStack:GetCurrentCharges()
    else
        print("GetLumberCount: unit did not have any lumber!")
        return 0
    end
end



--     -----| Functions |-----



---------------------------------------------------------------------------
-- Cuts the tree and gives lumber to the caster.
---------------------------------------------------------------------------
function HarvestChop(keys)
    local caster = keys.caster
    local target = keys.target
    local amount = keys.lumber
    local teamNumber = caster:GetTeamNumber()

    if not caster.HARVESTER then
        print("caster.HARVESTER was not set!")
        Resources:InitHarvester(caster)
    end

    if target and not keys.nocut then
        target:CutDown(teamNumber)
        --caster:SetLastTree(target)
        caster:DeliverLumber()
    end

    GiveCharges(caster, amount, "item_stack_of_lumber")
end



---------------------------------------------------------------------------
-- Delivers the lumber carried by the unit to the targeted building
-- if valid target.
---------------------------------------------------------------------------
function Resources:HarvestDeliverLumber(keys)
    local caster = keys.caster
    local target = keys.target
    local owningHero = GetPlayerHero(caster:GetOwner():GetPlayerID())

    local isNil = IsNil("Resources:HarvestDeliverLumber", {caster, target, owningHero}, 3)
    if target:IsDeliveryPoint() then
        local amount = Resources:GetLumberCarried()
        if amount > 0 then
            SpendLumber(caster, amount)
            owningHero:IncLumber(amount)
        end
    else
        -- Needs UI Warning
        print("Resources:HarvestDeliverLumber: Invalid Target!")
    end
    return isNil
end



--     -----| Old Utils |-----



-- Gives lumber to the owner of the harvesting unit.
function GiveHarvestedLumber(keys)

    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability

    local owner = caster:GetPlayerOwner()
    local teamNumber = caster:GetTeamNumber()
    local lumberAmount = keys.lumber
    --local playerID = owner:GetPlayerID()
    --local hero = GetPlayerHero(playerID)

    if target then
        target:CutDown(teamNumber)
    end

    GiveCharges(caster, lumberAmount, "item_stack_of_lumber")

    ReportLumberChopped(owner, lumberAmount)
end



-- Gives lumber to the owner of the harvesting unit by spell.
function GiveHarvestedLumberAlt(keys)
    local args = {}
    args["caster"] = keys.caster
    args["lumber"] = keys.amount
    GiveHarvestedLumber(args)
end



-- Increase the amount of lumber chopped for this player.
function ReportLumberChopped(player, amount)
    if not player or not amount then
        print("ReportLumberChopped: player or amount was nil!")
        return
    end

    if not player._lumberGained then
        player._lumberGained = amount
    else
        player._lumberGained = player._lumberGained + amount
    end
end



function printRes(funcName, message)
    if DEBUG_RESOURCES then
        print(funcName..": "..message)
    end
end
