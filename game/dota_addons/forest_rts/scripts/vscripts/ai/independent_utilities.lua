-- These functions should be quite independent of the mod it's used in.

---------------------------------------------------------------------------
-- Returns the constant for the opposite team.
--
-- @teamID (number): The identifier of the team to get the opposite of.
---------------------------------------------------------------------------
function GetOppositeTeam(teamID)
    if teamID == DOTA_TEAM_BADGUYS then
        return DOTA_TEAM_GOODGUYS
    else
        return DOTA_TEAM_BADGUYS
    end
end

---------------------------------------------------------------------------
-- Used by Tutorial:AddBot for the last argument.
--
-- @teamID (number): The identifier of the team to get a bool for.
---------------------------------------------------------------------------
function GetTeamAsBool(teamID)
    return (teamID == DOTA_TEAM_GOODGUYS)
end

---------------------------------------------------------------------------
-- Checks if the team is one of the two default ones.
--
-- @teamID (number): The identifier of the team to check.
---------------------------------------------------------------------------
function IsTeamDireOrRadiant(teamID)
    return (teamID == DOTA_TEAM_GOODGUYS or teamID == DOTA_TEAM_BADGUYS)
end

---------------------------------------------------------------------------
-- Checks if the team is the neutral one.
--
-- @teamID (number): The identifier of the team to check.
---------------------------------------------------------------------------
function IsTeamNeutrals(teamID)
    return (teamID == DOTA_TEAM_NEUTRALS)
end

---------------------------------------------------------------------------
-- Checks if the team is empty.
--
-- @teamID (number): The identifier of the team to check.
---------------------------------------------------------------------------
function IsTeamEmpty(teamID)
    local playerCountTeam = PlayerResource:GetPlayerCountForTeam(teamID)
    return (playerCountTeam == 0)
end

---------------------------------------------------------------------------
-- Checks if the opposite team is empty.
--
-- @teamID (number): The identifier of the opposite of the team to check.
---------------------------------------------------------------------------
function IsOppositeTeamEmpty(teamID)
    return IsTeamEmpty(GetOppositeTeam(teamID))
end

---------------------------------------------------------------------------
-- Checks if the string is all uppercase.
--
-- @str (string): The string to check.
---------------------------------------------------------------------------
function IsStringConstant(str)
    return (str:upper() == str)
end

---------------------------------------------------------------------------
-- Prints a vector
--
-- @vector (Vector): The vector to print.
---------------------------------------------------------------------------
function PrintVector(vector)
    print("Vector(x: "..vector.x..", y: "..vector.y..", z: "..vector.z..")")
end

---------------------------------------------------------------------------
-- Returns the distance between two points.
--
-- @v1 (Vector): The first vector.
-- @v2 (Vector): The second vector.
---------------------------------------------------------------------------
function VectorDistance(v1, v2)
    return math.sqrt((v1.x - v2.x)^2 + (v1.y - v2.y)^2 + (v1.z - v2.z)^2)
end

---------------------------------------------------------------------------
-- Orders the unit to move to the location after a small time.
-- Sometimes necessary for movement commands to actually work.
-- 
-- @unit (Unit): The unit to move.
-- @position (Vector): The position to move to.
---------------------------------------------------------------------------
function MoveWithSmallTimer(unit, position)
    Timers:CreateTimer({
        endTime = 0.05,
        callback = function()
            unit:MoveToPosition(position)
    end})
end

---------------------------------------------------------------------------
-- Attempts to place a building for the specified bot.
-- This building is instantly created!
--
-- @playerID (Int): The playerID of the owning bot.
-- @buildingName (String): The name of the building to place.
-- @position (Vector): The positional vector to place the building at.
-- @angle (optional) (Vector?): The angle the building should face.
-- @return (Building): The constructed building on success.
---------------------------------------------------------------------------
function PlaceBuilding(playerID, buildingName, position, angle)
    return BuildingHelper:PlaceBuilding(playerID, buildingName, position, angle)
end

---------------------------------------------------------------------------
-- Constructs a building the ordinary way.
--
-- @worker (Unit): The worker to construct the building.
-- @ability (Ability): The ability to use to construct the building.
-- @position (Vector): The position where the building should be created.
---------------------------------------------------------------------------
function ConstructBuilding(worker, ability, position)
    local playerID = worker:GetPlayerOwnerID()
    -- I've only tried setting Queue to 0, might be better at 1 if queuing
    local buildArgs = {
        builder = worker:GetEntityIndex(),
        Queue = 0,
        PlayerID = playerID,
        X = position.x,
        Y = position.y,
        Z = position.z,
        bot = true
    }

    Build({caster=worker, ability=ability})
    BuildingHelper:BuildCommand(buildArgs)
end