-- Middle camp
    -- * Banner should be the tintable one.

    -- Right-Top tower: Vector(736, -480, 384)
    -- Right-top top guard: Vector(576, -64, 384)
    -- Right-top bot guard: Vector(576, -384, 384)
    -- Banner: Vector(960, -448, 255)

    -- Market: Vector(-320, -1536, 384) (Rotate 180 deg)
    -- Market guard: Vector(-256, -1280, 384)

    -- Right-Bottom tower: Vector(864, -1504, 384)
    -- Right-bottom left guard: Vector(384, -1728, 384)
    -- Right-bottom right guard: Vector(704, -1728, 384)
    -- Banner: Vector(896, -1664, 384) (Rotate 90 deg)

    -- Left tower: Vector(-1120, -1312, 384)
    -- Left top guard: Vector(-896, -896, 384)
    -- Left bot guard: Vector(-896, -1216, 384)
    -- Banner: Vector(-1280, -1344, 384) (Rotate 180 deg)

-- If you want to use this module, make sure to rewrite the 'Neutrals:RotateLeft'
-- method and change the values in the block below!
-- (That is: team colors, team names, unit names etc.)

if not Neutrals then
    Neutrals = {}
    -- Set your team colors here!
    -- If more than two main teams are used, add them using the DOTA_TEAM_xxx constants.
    Neutrals.TEAM_COLORS = {
        [DOTA_TEAM_GOODGUYS] = {52,85,255},
        [DOTA_TEAM_BADGUYS] = {176,23,27},
        [DOTA_TEAM_NEUTRALS] = {128,72,53}
    }
    Neutrals.TEAM_COLORS_HEX = {
        [DOTA_TEAM_GOODGUYS] = "#3455ff",
        [DOTA_TEAM_BADGUYS] = "#b0171b",
        [DOTA_TEAM_NEUTRALS] = "#804835"
    }
    Neutrals.TEAM_NAMES = {
        [DOTA_TEAM_GOODGUYS] = "The Radiant",
        [DOTA_TEAM_BADGUYS] = "The Dire",
        [DOTA_TEAM_NEUTRALS] = "The Neutrals"
    }

    Neutrals.BRUTE = "npc_dota_creature_neutral_brute"
    Neutrals.ARCHER = "npc_dota_creature_neutral_archer"
    Neutrals.WORKER_NAME = "npc_dota_creature_neutral_worker"

    Neutrals.WATCH_TOWER_NAME = "npc_dota_building_watch_tower"
    Neutrals.BANNER_NAME = "npc_dota_building_prop_banner_owner"
    Neutrals.WOODEN_WALL = "npc_dota_building_wooden_wall"
    Neutrals.SMALL_TENT = "npc_dota_building_main_tent_small"
    Neutrals.BARRACKS = "npc_dota_building_barracks_radiant"
end

function Neutrals:Init()
    Neutrals.camps = {}

    ListenToGameEvent('entity_killed', Dynamic_Wrap(Neutrals, 'OnUnitKilled'), self)

    Convars:RegisterCommand('neutrals_middle_radiant', function()
        Neutrals:SwitchOwnerOfCamp(Neutrals.camps["Middle Lumber Camp"], DOTA_TEAM_GOODGUYS)
    end, 'Give command of the middle lumber camp to the radiant', FCVAR_CHEAT)

    Convars:RegisterCommand('neutrals_middle_dire', function()
        Neutrals:SwitchOwnerOfCamp(Neutrals.camps["Middle Lumber Camp"], DOTA_TEAM_BADGUYS)
    end, 'Give command of the middle lumber camp to the dire', FCVAR_CHEAT)

    Convars:RegisterCommand('neutrals_middle_neutrals', function()
        Neutrals:SwitchOwnerOfCamp(Neutrals.camps["Middle Lumber Camp"], DOTA_TEAM_NEUTRALS)
    end, 'Give command of the middle lumber camp to the neutrals', FCVAR_CHEAT)

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

    Neutrals:Print("Guards left: " .. camp.guardsLeft)

    local killerTeam = PlayerResource:GetTeam(killerID)

    -- Units belonging to the neutral team does not have a owning player,
    -- therefore -1.
    if killerID == -1 then
        killerTeam = DOTA_TEAM_NEUTRALS
    end

    Neutrals:RegisterAsDead(entKilled, camp, killerTeam)

    if not camp.isTransferable then
        return
    end

    local guardsLeft = camp.guardsLeft
    --Neutrals:Print("Guards left: "..guardsLeft)
    if guardsLeft <= 0 then
        local newOwnerTeam = Neutrals:GetNewOwnerTeam(camp)
        Neutrals:SwitchOwnerOfCamp(camp, newOwnerTeam)
    end
end

---------------------------------------------------------------------------
-- Decide which team to transfer the ownership of the camp to.
--
-- @building (Building): The camp to decide for.
-- @return (Int): The new team number.
---------------------------------------------------------------------------
function Neutrals:GetNewOwnerTeam(camp)
    local curHighestTeam = -1
    local curHighest = -1
    for team,points in pairs(camp.transferPoints) do
        if points > curHighest then
            curHighest = points
            curHighestTeam = team
        end
    end
    return curHighestTeam
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
-- @isTransferable (Boolean): Whether the camp will switch owner or not.
-- @return (Camp): The newly created camp object.
---------------------------------------------------------------------------
function Neutrals:CreateCamp(location, campName, isTransferable)
    local camp = {
        name = campName,
        location = location,
        -- Must be killed to take control of base.
        guardsLeft = 0,
        isTransferable = isTransferable,
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
    local newUnit = Neutrals:SpawnUnit(self.WORKER_NAME, location, camp, DOTA_TEAM_NEUTRALS, transferable, invulnerable)
    newUnit._deliveryPoint = market
    newUnit._worker = true
    HarvestLumber(newUnit)

    --Neutrals:MakeGloballyVisible(newUnit)
    return newUnit
end

---------------------------------------------------------------------------
-- Spawns and returns a new neutral unit.
--
-- @unitName (String): The name of the unit to spawn.
-- @location (Vector): The location where the unit will be spawned.
-- @camp (Camp): The unit will be connected to this camp.
-- @owningTeam (Int): The number representing the team to fight for.
-- @transferable (Boolean): Whether or not this unit will be transfered
--   when camp changes owner.
-- @invulnerable (Optional) (Boolean): Can be set to invulnerable
--   if specified.
-- @leftRotations (Optional) (Int): Specifies how many times to rotate 45 deg left.
-- @return (Unit): The newly spawned unit.
---------------------------------------------------------------------------
function Neutrals:SpawnGuard(unitName, location, camp, owningTeam, transferable, invulnerable, leftRotations)
    local newUnit = Neutrals:SpawnUnit(unitName, location, camp, owningTeam, transferable, invulnerable, leftRotations)
    camp.guardsLeft = camp.guardsLeft + 1
    return newUnit
end

---------------------------------------------------------------------------
-- Spawns and returns a new neutral unit.
--
-- @unitName (String): The name of the unit to spawn.
-- @location (Vector): The location where the unit will be spawned.
-- @camp (Camp): The unit will be connected to this camp.
-- @owningTeam (Int): The number representing the team to fight for.
-- @transferable (Boolean): Whether or not this unit will be transfered
--   when camp changes owner.
-- @invulnerable (Optional) (Boolean): Can be set to invulnerable
--   if specified.
-- @leftRotations (Optional) (Int): Specifies how many times to rotate 45 deg left.
-- @return (Unit): The newly spawned unit.
---------------------------------------------------------------------------
function Neutrals:SpawnUnit(unitName, location, camp, owningTeam, transferable, invulnerable, leftRotations)
    local newUnit = CreateUnitByName(unitName, location, true, nil, nil, owningTeam)
    newUnit._camp = camp
    newUnit._neutrals = true

    if transferable then
        Neutrals:MakeTransferable(newUnit, camp, "unit", leftRotations)
    end
    if leftRotations then
        Neutrals:RotateLeft(newUnit, leftRotations)
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
function Neutrals:CreateTower(location, invulnerable, camp, towerUnit, transferable)
    local tower = Neutrals:CreateBuilding(Neutrals.WATCH_TOWER_NAME, location, invulnerable, camp, nil, transferable)
    
    if not towerUnit then
        return tower
    end

    local towerUnit = Neutrals:SpawnUnit(towerUnit, location, camp, DOTA_TEAM_NEUTRALS)
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
-- @transferable (Optional) (Boolean): Whether the building will be transferred 
--   on camp clearing or not.
-- @return (Building): The newly created building.
---------------------------------------------------------------------------
function Neutrals:CreateBuilding(buildingName, location, invulnerable, camp, angle, transferable)
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
    building._building = true
    building._neutral = true

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

    if not building:HasAbility("srts_armor_type_fortified") then
        building:AddAbility("srts_armor_type_fortified")
    end

    SetDamageAndArmorTypes(building)

    if invulnerable then
        building:AddAbility("invulnerable")
        building:FindAbilityByName("invulnerable"):SetLevel(1)
        Neutrals:MakeGloballyVisible(building)
    end

    building._playerOwned = true
    building._neutrals = true
    building._camp = camp
    
    if transferable then
        Neutrals:MakeTransferable(building, camp, "building")
    end

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
-- @leftRotations (Optional) (Int): Specifies how many times to rotate 45 deg left.
---------------------------------------------------------------------------
function Neutrals:MakeTransferable(entity, camp, type, leftRotations)
    camp.transferable[entity] = {
        entity = entity,
        status = "alive",
        spawn = entity:GetAbsOrigin(),
        name = entity:GetUnitName(),
        type = type,
        killerID = nil,
        leftRotations = leftRotations or 0
    }
end

---------------------------------------------------------------------------
-- Makes the unit non-transferable, making sure that the entity neither
-- respawns nor changes owner.
--
-- @entity (Unit/Building): The unit or building to make untransferable.
-- @camp (Camp): The camp the entity belongs to.
---------------------------------------------------------------------------
function Neutrals:RemoveTransferable(entity, camp)
    if camp.transferable[entity] then
        camp.transferable[entity] = nil
    end
end

---------------------------------------------------------------------------
-- Registers the entity as dead so it can be respawned later.
--
-- @entity (Unit/Building): The unit or building to update the info for.
-- @camp (Camp): The camp the entity belongs to.
-- @killerTeam (Int): The team of the player owning the killer.
---------------------------------------------------------------------------
function Neutrals:RegisterAsDead(entity, camp, killerTeam)
    local entStruct = camp.transferable[entity]
    if entStruct then
        entStruct.status = "dead"
        entStruct.killerTeam = killerTeam
    end

    camp.transferPoints[killerTeam] = (camp.transferPoints[killerTeam] or 0) + 1
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
-- Transfers the ownership over the whole camp to a new team.
--
-- @camp (Camp): The camp to switch the ownership of.
-- @newOwnerTeam (Int): The team number of the new owners.
---------------------------------------------------------------------------
function Neutrals:SwitchOwnerOfCamp(camp, newOwnerTeam)
    local entries = camp.transferable
    camp.transferPoints = {}

    local count = 0
    for index,entry in pairs(entries) do
        count = count + 1
        if entry.status == "alive" then
            if entry.name == Neutrals.BRUTE then
                Neutrals:SwitchOwner(entry.entity, newOwnerTeam)
            else
                Neutrals:SwitchOwner(entry.entity, newOwnerTeam)
            end
        else
            local leftRotations = entry.leftRotations
            --Neutrals:Print("\tRespawning "..entry.name.."!")
            Neutrals:SpawnGuard(entry.name, entry.spawn, camp, newOwnerTeam, false, false, leftRotations)
        end
    end
    Neutrals:Print("GuardsLeft in converted camp: "..camp.guardsLeft)

    local newOwnerColor = self.TEAM_COLORS_HEX[newOwnerTeam]
    local notificationString = "<font color='"..newOwnerColor.."'>"..self.TEAM_NAMES[newOwnerTeam].."</font>".." has taken the "..camp.name
    -- Timed message on top.
    Notifications:ClearTopFromAll()
    Notifications:TopToAll({text=notificationString, duration=5.0})
    -- Message on left side, stays for a while.
    GameRules:SendCustomMessage(notificationString, 0, 0)
end

---------------------------------------------------------------------------
-- Creates a new camp object.
--
-- @entity (Unit/Building): The new unit or building to convert.
-- @newOwnerTeam (Int): The team of the new owners.
-- @return (Unit/Building): The converted unit/building.
---------------------------------------------------------------------------
function Neutrals:SwitchOwner(entity, newOwnerTeam)
    entity:SetTeam(newOwnerTeam)
    if entity._inside then
        Neutrals:SwitchOwner(entity._inside, newOwnerTeam)
    end

    local entityName = entity:GetUnitName()
    if entityName == Neutrals.BANNER_NAME then
        local teamColor = self.TEAM_COLORS[newOwnerTeam]
        entity:SetRenderColor(teamColor[1], teamColor[2], teamColor[3])
    end

    return entity
end

function Neutrals:print(...)
    Neutrals:Print(...)
end

function Neutrals:Print(...)
    if DEBUG_NEUTRALS then
        print("[Neutrals] ".. ...)
    end
end
