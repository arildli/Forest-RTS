---------------------------------------------------------------------------
-- Returns the constant for the opposite team.
-- @teamID (Int): The identifier of the team to get the opposite of.
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
-- @teamID (Int): The identifier of the team to get a bool for.
---------------------------------------------------------------------------
function GetTeamAsBool(teamID)
    return (teamID == DOTA_TEAM_GOODGUYS)
end

---------------------------------------------------------------------------
-- Checks if the team is one of the two default ones.
-- @teamID (Int): The identifier of the team to check.
---------------------------------------------------------------------------
function IsTeamDireOrRadiant(teamID)
    return (teamID == DOTA_TEAM_GOODGUYS or teamID == DOTA_TEAM_BADGUYS)
end

---------------------------------------------------------------------------
-- Checks if the team is the neutral one.
-- @teamID (Int): The identifier of the team to check.
---------------------------------------------------------------------------
function IsTeamNeutrals(teamID)
    return (teamID == DOTA_TEAM_NEUTRALS)
end

---------------------------------------------------------------------------
-- Checks if the team is empty.
-- @teamID (Int): The identifier of the team to check.
---------------------------------------------------------------------------
function IsTeamEmpty(teamID)
    local playerCountTeam = PlayerResource:GetPlayerCountForTeam(teamID)
    return (playerCountTeam == 0)
end

---------------------------------------------------------------------------
-- Checks if the opposite team is empty.
-- @teamID (Int): The identifier of the opposite of the team to check.
---------------------------------------------------------------------------
function IsOppositeTeamEmpty(teamID)
    return IsTeamEmpty(GetOppositeTeam(teamID))
end