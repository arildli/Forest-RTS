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
    
    local middleCamp = Neutrals:CreateCamp(Vector(-230, -1536, 384), "Middle Lumber Camp")
    -- Right-Top tower
    Neutrals:CreateBuilding("npc_dota_building_watch_tower", Vector(736, -480, 384), true, middleCamp)
    Neutrals:CreateBuilding("npc_dota_building_prop_banner_owner", Vector(960, -448, 255), true, middleCamp)
    -- Right-Bottom tower
    Neutrals:CreateBuilding("npc_dota_building_watch_tower", Vector(864, -1504, 384), true, middleCamp)
    -- Left tower
    Neutrals:CreateBuilding("npc_dota_building_watch_tower", Vector(-1120, -1312, 384), true, middleCamp)
    local bannerLeft = Neutrals:CreateBuilding("npc_dota_building_prop_banner_owner", Vector(-1280, -1344, 384), true, middleCamp)
    Neutrals:RotateLeft(bannerLeft, 3)
    -- Market
    Neutrals:CreateBuilding("npc_dota_building_market", Vector(-320, -1536, 384), true, middleCamp)


    Neutrals:Print("Initialized")
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

    print("Neutrals:CreateBuilding:")
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
        Neutrals:Print("Adding invulnerability to buildings!")
        building:AddAbility("srts_invulnerable")
    end
    building._playerOwned = true

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

function Neutrals:print(...)
    Neutrals:Print(...)
end

function Neutrals:Print(...)
    print("[Neutrals] ".. ...)
end