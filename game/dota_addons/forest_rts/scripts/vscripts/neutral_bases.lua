-- Middle camp
    -- * Banner should be the tintable one.

    -- Right-Top tower: Vector(736, -480, 384)
    -- Right-top top guard: Vector(576, -64, 384)
    -- Right-top bot guard: Vector(576, -384, 384)
    -- Banner: Vector(960, -448, 255)

    -- Market: Vector(-320, -1536, 384) (Rotate 180 deg)

    -- Right-Bottom tower: Vector(864, -1504, 384)
    -- Right-bottom left guard: Vector(384, -1728, 384)
    -- Right-bottom right guard: Vector(704, -1728, 384)
    -- Banner: Vector(896, -1664, 384) (Rotate 90 deg)

    -- Left tower: Vector(-1120, -1312, 384)
    -- Left top guard: Vector(-896, -896, 384)
    -- Left bot guard: Vector(-896, -1216, 384)
    -- Banner: Vector(-1280, -1344, 384) (Rotate 180 deg)



if not Neutrals then
    Neutrals = {}
end

function Neutrals:Init()
    Neutrals.camps = {}

    ListenToGameEvent('entity_killed', Dynamic_Wrap(Neutrals, 'OnUnitKilled'), self)

    -- Temp setup
    local middleCamp = Neutrals:CreateCamp(Vector(-230, -1536, 384), "Middle Lumber Camp")
    -- Right-Top tower
    local curVector = Vector(736, -480, 384)
    Neutrals:CreateTower(curVector, true, middleCamp, "npc_dota_creature_neutral_archer")
    Neutrals:SpawnGuard("npc_dota_creature_neutral_brute", Vector(576, -64, 384), middleCamp, true, false)
    Neutrals:SpawnGuard("npc_dota_creature_neutral_brute", Vector(576, -384, 384), middleCamp, true, false)
    local bannerRightTop = Neutrals:CreateBuilding("npc_dota_building_prop_banner_owner", Vector(960, -448, 255), true, middleCamp)
    Neutrals:MakeGloballyVisible(bannerRightTop)
    -- Right-Bottom tower
    curVector = Vector(864, -1504, 384)
    Neutrals:CreateTower(curVector, true, middleCamp, "npc_dota_creature_neutral_archer")
    local curUnit = Neutrals:SpawnGuard("npc_dota_creature_neutral_brute", Vector(384, -1728, 384), middleCamp, true, false)
    Neutrals:RotateLeft(curUnit, 5)
    curUnit = Neutrals:SpawnGuard("npc_dota_creature_neutral_brute", Vector(704, -1728, 384), middleCamp, true, false)
    Neutrals:RotateLeft(curUnit, 5)
    local bannerBottom = Neutrals:CreateBuilding("npc_dota_building_prop_banner_owner", Vector(832, -1664, 384), true, middleCamp)
    Neutrals:RotateLeft(bannerBottom, 5)
    Neutrals:MakeGloballyVisible(bannerBottom)
    -- Left tower
    curVector = Vector(-1120, -1312, 384)
    Neutrals:CreateTower(curVector, true, middleCamp, "npc_dota_creature_neutral_archer")
    local curUnit = Neutrals:SpawnGuard("npc_dota_creature_neutral_brute", Vector(-896, -896, 384), middleCamp, true, false)
    Neutrals:RotateLeft(curUnit, 3)
    curUnit = Neutrals:SpawnGuard("npc_dota_creature_neutral_brute", Vector(-896, -1216, 384), middleCamp, true, false)
    Neutrals:RotateLeft(curUnit, 3)
    local bannerLeft = Neutrals:CreateBuilding("npc_dota_building_prop_banner_owner", Vector(-1280, -1344, 384), true, middleCamp)
    Neutrals:RotateLeft(bannerLeft, 3)
    Neutrals:MakeGloballyVisible(bannerLeft)
    -- Market
    local market = Neutrals:CreateBuilding("npc_dota_building_market", Vector(-320, -1536, 384), true, middleCamp)
    Neutrals:RotateLeft(market, 3)
    -- Workers
    local workers = {
        Neutrals:SpawnWorker(Vector(256, -1024, 384), market, middleCamp, true, true),
        Neutrals:SpawnWorker(Vector(64, -1216, 384), market, middleCamp, true, true)
    }

    Neutrals:Print("Initialized")
end

---------------------------------------------------------------------------
-- Called when a unit is killed.
--
-- @event (Table): Contains data about the event.
---------------------------------------------------------------------------
function Neutrals:OnUnitKilled(event)
    local entKilled = EntIndexToHScript(event.entindex_killed)
    if not entKilled._neutrals then
        return
    end
    local entKiller = EntIndexToHScript(event.entindex_attacker)
    local killerID = entKiller:GetPlayerOwnerID()
    local camp = entKilled._camp
    if not camp then
        Neutrals:Print("Neutral unit killed, but not part of camp. Returning...")
        return
    end

    camp.guardsLeft = camp.guardsLeft - 1
    Neutrals:RegisterAsDead(entKilled, camp, killerID)

    local guardsLeft = camp.guardsLeft
    Neutrals:Print("Guards left: "..guardsLeft)
    if guardsLeft <= 0 then
        Neutrals:Print("All guards are dead! Transferring ownership...")
        local newPlayerID = Neutrals:GetNewOwnerID(camp)
        Neutrals:SwitchOwnerOfCamp(camp, newPlayerID)
    end
end

---------------------------------------------------------------------------
-- Decide which player to transfer the ownership of the camp to.
--
-- @building (Building): The camp to decide for.
-- @return (Int): The playerID of the new owner.
---------------------------------------------------------------------------
function Neutrals:GetNewOwnerID(camp)
    local curHighestID = -1
    local curHighest = -1
    for playerID,points in pairs(camp.transferPoints) do
        if points > curHighest then
            curHighest = points
            curHighestID = playerID
        end
    end
    Neutrals:Print("Returning ID "..curHighestID)
    return curHighestID
end

---------------------------------------------------------------------------
-- Rotates a building's rotation the specified number of times.
--
-- @building (Building): The building to rotate left.
-- @times (Int): The number of times to rotate the building 45 degrees.
---------------------------------------------------------------------------
function Neutrals:RotateLeft(building, times)
    for i=0,times do
        RotateLeft({caster = building})
    end
end

---------------------------------------------------------------------------
-- Makes a building visible to both teams.
--
-- @building (Building): The building to make visible.
---------------------------------------------------------------------------
function Neutrals:MakeGloballyVisible(building)
    building:AddAbility("can_be_seen_global")
    building:FindAbilityByName("can_be_seen_global"):SetLevel(1)
end

---------------------------------------------------------------------------
-- Creates a new camp object.
--
-- @location (Vector): The location where the unit will be spawned.
-- @campName (String): The name of the new camp.
-- @return (Camp): The newly created camp object.
---------------------------------------------------------------------------
function Neutrals:CreateCamp(location, campName)
    local camp = {
        name = campName,
        location = location,
        -- Must be killed to take control of base.
        guardsLeft = 0,
        -- These will work for the current owner of the camp. Dead entities will
        -- be respawned on owner change.
        transferable = {},
        -- Points will be given to a certain playerID when they last hit a unit.
        transferPoints = {}
    }
    Neutrals.camps[#Neutrals.camps+1] = camp
    Neutrals.camps[campName] = camp

    Neutrals:Print("Created new camp with id "..campName or #Neutrals.camps)
    return camp
end

---------------------------------------------------------------------------
-- Spawns and returns a new neutral unit.
--
-- @location (Vector): The location where the unit will be spawned.
-- @market (Building): The building to deliver resources to.
-- @camp (Camp): The unit will be connected to this camp.
-- @transferable (Boolean): Whether or not this unit will be transfered
--   when camp changes owner.
-- @invulnerable (Optional) (Boolean): Can be set to invulnerable
--   if specified.
-- @return (Unit): The newly spawned unit.
---------------------------------------------------------------------------
function Neutrals:SpawnWorker(location, market, camp, transferable, invulnerable)
    local newUnit = Neutrals:SpawnUnit("npc_dota_creature_neutral_worker", location, camp, transferable, invulnerable)
    newUnit._deliveryPoint = market
    newUnit._worker = true
    HarvestLumber(newUnit)

    Neutrals:MakeGloballyVisible(newUnit)
    return newUnit
end

---------------------------------------------------------------------------
-- Spawns and returns a new neutral unit.
--
-- @location (Vector): The location where the unit will be spawned.
-- @camp (Camp): The unit will be connected to this camp.
-- @transferable (Boolean): Whether or not this unit will be transfered
--   when camp changes owner.
-- @invulnerable (Optional) (Boolean): Can be set to invulnerable
--   if specified.
-- @return (Unit): The newly spawned unit.
---------------------------------------------------------------------------
function Neutrals:SpawnGuard(unitName, location, camp, transferable, invulnerable)
    local newUnit = Neutrals:SpawnUnit(unitName, location, camp, transferable, invulnerable)
    camp.guardsLeft = camp.guardsLeft + 1
    return newUnit
end

---------------------------------------------------------------------------
-- Spawns and returns a new neutral unit.
--
-- @unitName (String): The name of the unit to spawn.
-- @location (Vector): The location where the unit will be spawned.
-- @camp (Camp): The unit will be connected to this camp.
-- @transferable (Boolean): Whether or not this unit will be transfered
--   when camp changes owner.
-- @invulnerable (Optional) (Boolean): Can be set to invulnerable
--   if specified.
-- @return (Unit): The newly spawned unit.
---------------------------------------------------------------------------
function Neutrals:SpawnUnit(unitName, location, camp, transferable, invulnerable)
    local newUnit = CreateUnitByName(unitName, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
    newUnit._camp = camp
    newUnit._neutrals = true
    newUnit._camp = camp

    if transferable then
        Neutrals:MakeTransferable(newUnit, camp, "unit")
    end

    if invulnerable then
        newUnit:AddAbility("invulnerable")
        newUnit:FindAbilityByName("invulnerable"):SetLevel(1)
    end

    return newUnit
end

---------------------------------------------------------------------------
-- Creates a tower and adds a unit into it if specified.
--
-- @location (Vector): The location to place the tower.
-- @invulnerable (Boolean): Whether or not to make the tower invulnerable.
-- @camp (Optional) (Camp): The camp object to add it to if specified.
-- @towerUnit (Optional) (String): The name of the unit to put into the tower.
-- @return (Building): The newly created tower.
---------------------------------------------------------------------------
function Neutrals:CreateTower(location, invulnerable, camp, towerUnit)
    local tower = Neutrals:CreateBuilding("npc_dota_building_watch_tower", location, invulnerable, camp)
    if not towerUnit then
        return tower
    end

    local towerUnit = Neutrals:SpawnUnit(towerUnit, location, camp)
    local keys = {
        unitIndex = towerUnit:GetEntityIndex(),
        towerIndex = tower:GetEntityIndex()
    }

    tower:AddAbility("srts_enter_tower")
    tower:FindAbilityByName("srts_enter_tower"):SetLevel(1)

    Timers:CreateTimer({
        endTime = 0.05,
        callback = function()
            CastEnterTower(keys)
        end}
    )
    return tower
end

---------------------------------------------------------------------------
-- Modified version of the BuildingHelper:PlaceBuilding method.
-- Creates and returns a new building.
--
-- @buildingName (String): The name of the building to create.
-- @location (Vector): The location where the building will be created.
-- @invulnerable (Boolean): Whether or not the building will be invulnerable.
-- @camp (Optional) (Camp): The building will be connected to this camp
--   if specified.
-- @angle (Optional) (Vector): The angle the building will face.
-- @return (Building): The newly created building.
---------------------------------------------------------------------------
function Neutrals:CreateBuilding(buildingName, location, invulnerable, camp, angle)
    local construction_size = construction_size or BuildingHelper:GetConstructionSize(buildingName)
    local pathing_size = pathing_size or BuildingHelper:GetBlockPathingSize(buildingName)
    BuildingHelper:SnapToGrid(construction_size, location)

    -- Spawn point obstructions before placing the building
    local gridNavBlockers = BuildingHelper:BlockGridSquares(construction_size, pathing_size, location)

    -- Adjust the model position z
    local model_offset = GetUnitKV(buildingName, "ModelOffset") or 0
    local model_location = Vector(location.x, location.y, location.z + model_offset)

    -- Spawn the building
    local building = CreateUnitByName(buildingName, model_location, false, nil, nil, DOTA_TEAM_NEUTRALS)
    building:SetNeverMoveToClearSpace(true)
    building:SetAbsOrigin(model_location)
    building.construction_size = construction_size
    building.blockers = gridNavBlockers

    -- Disable turning. If DisableTurning unit KV setting is not defined, use the global setting
    local disableTurning = GetUnitKV(buildingName, "DisableTurning")
    if not disableTurning then
        if BuildingHelper.Settings["DISABLE_BUILDING_TURNING"] then
            building:AddNewModifier(building, nil, "modifier_disable_turning", {})
        end
    elseif disableTurning == 1 then
        building:AddNewModifier(building, nil, "modifier_disable_turning", {})
    end

    if angle then
        building:SetAngles(0,-angle,0)
    end

    if not building:HasAbility("ability_building") then
        building:AddAbility("ability_building")
    end

    if invulnerable then
        building:AddAbility("invulnerable")
        building:FindAbilityByName("invulnerable"):SetLevel(1)
        Neutrals:MakeGloballyVisible(building)
    end
    building._playerOwned = true
    building._neutrals = true
    building._camp = camp
    Neutrals:MakeTransferable(building, camp, "building")

    -- Return the created building
    return building
end

---------------------------------------------------------------------------
-- Makes the entity transferable, meaning it will always work for the
-- current owner of the camp.
--
-- @entity (Unit/Building): The unit or building to make transferable.
-- @camp (Camp): The camp the entity belongs to.
-- @type (String): Whether the entity is a building or a unit.
---------------------------------------------------------------------------
function Neutrals:MakeTransferable(entity, camp, type)
    camp.transferable[entity] = {
        entity = entity,
        status = "alive",
        spawn = entity:GetAbsOrigin(),
        name = entity:GetUnitName(),
        type = type,
        killerID = nil
    }
end

---------------------------------------------------------------------------
-- Registers the entity as dead so it can be respawned later.
--
-- @entity (Unit/Building): The unit or building to update the info for.
-- @camp (Camp): The camp the entity belongs to.
-- @killerID (Int): The playerID of the player owning the killer.
---------------------------------------------------------------------------
function Neutrals:RegisterAsDead(entity, camp, killerID)
    local entStruct = camp.transferable[entity]
    if entStruct then
        entStruct.status = "dead"
        entStruct.killerID = killerID
    end
    camp.transferPoints[killerID] = (camp.transferPoints[killerID] or 0) + 1
end

---------------------------------------------------------------------------
-- Chceks if the loyalty of the unit can be transferred to a new owner.
-- If true, this means the resources gathered by a worker will be given
-- to, or that a soldier will fight for, the new owner if the ownership
-- of the camp changes.
--
-- @entity (Unit/Building): The unit or building to check.
-- @return (Boolean): Whether or not the loyalty can be changed.
---------------------------------------------------------------------------
function Neutrals:IsTransferable(entity)
    if not entity._camp then
        return false
    end
    local camp = entity._camp
    local entry = camp[entity]
    return (entry ~= nil)
end

---------------------------------------------------------------------------
-- Transfers the ownership over the whole camp to a new player.
--
-- @camp (Camp): The camp to switch the ownership of.
-- @newPlayerID (Int): The playerID of the new owner.
---------------------------------------------------------------------------
function Neutrals:SwitchOwnerOfCamp(camp, newPlayerID)
    --[=[
    camp.transferable[entity] = {
        entity = entity,
        status = "alive",
        spawn = entity:GetAbsOrigin(),
        name = entity:GetUnitName(),
        type = type,
        killerID = nil
    }
    ]=]

    local entries = camp.transferable
    local newOwnerHero = PlayerResource:GetSelectedHeroEntity(newPlayerID)
    Neutrals:Print("Name of new owner hero: "..newOwnerHero:GetUnitName())

    for index,entry in pairs(entries) do
        if entry.status == "alive" then
            Neutrals:SwitchOwner(entry.entity, newPlayerID, newOwnerHero)
        else
            Neutrals:Print("Current "..entry.name.." is dead! Will deal with h** later...")
        end
    end
end

---------------------------------------------------------------------------
-- Creates a new camp object.
--
-- @entity (Unit/Building): The new unit or building to convert.
-- @newPlayerID (Int): The playerID of the new owner.
-- @newOwnerHero (Hero): The hero of the new owner.
-- @return (Unit/Building): The converted unit/building.
---------------------------------------------------------------------------
function Neutrals:SwitchOwner(entity, newPlayerID, newOwnerHero)
    --entity:SetControllableByPlayer(newPlayerID, true)
    Neutrals:Print("Switched ownership of "..entity:GetUnitName().." to "..newPlayerID)
    local newOwnerTeam = PlayerResource:GetTeam(newPlayerID)
    entity:SetTeam(newOwnerTeam)
    --entity:SetOwner(newOwnerHero)
    if entity._inside then
        Neutrals:SwitchOwner(entity._inside, newPlayerID, newOwnerHero)
    end
    return entity
end

function Neutrals:print(...)
    Neutrals:Print(...)
end

function Neutrals:Print(...)
    print("[Neutrals] ".. ...)
end
