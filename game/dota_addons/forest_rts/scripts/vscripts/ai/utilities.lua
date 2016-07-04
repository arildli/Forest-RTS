function GetOppositeTeam(teamID)
    if teamID == DOTA_TEAM_BADGUYS then
        return DOTA_TEAM_GOODGUYS
    else
        return DOTA_TEAM_BADGUYS
    end
end

function GetTeamAsBool(teamID)
    return (teamID == DOTA_TEAM_GOODGUYS)
end

function IsTeamEmpty(teamID)
    local playerCountTeam = PlayerResource:GetPlayerCountForTeam(teamID)
    return (playerCountTeam == 0)
end

function IsTeamDireOrRadiant(teamID)
    return (teamID == DOTA_TEAM_GOODGUYS or teamID == DOTA_TEAM_BADGUYS)
end

function IsTeamNeutrals(teamID)
    return (teamID == DOTA_TEAM_NEUTRALS)
end

function IsOppositeTeamEmpty(teamID)
    return IsTeamEmpty(GetOppositeTeam(teamID))
end