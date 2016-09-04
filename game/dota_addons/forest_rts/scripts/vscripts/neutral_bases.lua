
if not Neutrals then
    Neutrals = {}
end

function Neutrals:Init()
    Neutrals.camps = {}
    --Neutrals:CreateCamp()
    -- Right-Bottom tower: Vector(672, -1312, 384)
    -- Right-Top tower: Vector(736, -480, 384)
    Neutrals:Print("Initialized")
end

---------------------------------------------------------------------------
-- Spawns and returns a new neutral unit.
--
-- @unitName (String): The name of the unit to spawn.
-- @location (Vector): The location where the unit will be spawned.
-- @camp (Optional) (Camp): The unit will be connected to this camp
--   if specified.
-- @return (Unit): The newly spawned unit.
---------------------------------------------------------------------------
function Neutrals:SpawnUnit(unitName, location, camp)
    local newUnit = CreateUnitByName(unitName, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
    newUnit._camp = camp
    return newUnit
end

---------------------------------------------------------------------------
-- Modified version of the BuildingHelper:PlaceBuilding method.
-- Creates and returns a new building.
--
-- @buildingName (String): The name of the building to create.
-- @location (Vector): The location where the building will be created.
-- @camp (Optional) (Camp): The building will be connected to this camp
--   if specified.
-- @angle (Optional) (Vector): The angle the building will face.
-- @return (Building): The newly created building.
---------------------------------------------------------------------------
function Neutrals:CreateBuilding(buildingName, location, camp, angle)
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

    -- Return the created building
    return building
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
    entity:SetControllableByPlayer(newPlayerID, true)
    entity:SetOwner(newOwnerHero)
    if entity._inside then
        Neutrals:SwitchOwner(entity._inside, newPlayerID, newOwnerHero)
    end
    return entity
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
        units = {}
    }
    Neutrals.camps[#Neutrals.camps+1] = camp

    Neutrals:Print("Created new camp with id "..campName or #Neutrals.camps)
end

function Neutrals:print(...)
    Neutrals:Print(...)
end

function Neutrals:Print(...)
    print("[Neutrals] ".. ...)
end