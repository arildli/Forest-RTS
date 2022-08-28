---------------------------------------------------------------------------
-- Init
---------------------------------------------------------------------------
if not PlayerMessages then
    PlayerMessages = {
        DEFAULT_EMPHASIS_COLOR = "#009933"
    }
end

function PlayerMessages:Init()
    ListenToGameEvent("research_done", Dynamic_Wrap(PlayerMessages, "OnResearchComplete"), self)
    ListenToGameEvent("construction_done", Dynamic_Wrap(PlayerMessages, "OnConstructionComplete"), self)
end



---------------------------------------------------------------------------
-- Listeners
---------------------------------------------------------------------------
function PlayerMessages:OnResearchComplete(keys)
    local playerID = keys.playerID
    local researchName = keys.researchName
    local color = PlayerMessages.DEFAULT_EMPHASIS_COLOR

    PlayerMessages:DisplayResearchComplete(playerID, researchName, color)
end

function PlayerMessages:OnConstructionComplete(keys)
    local playerID = keys.playerID
    local buildingName = keys.buildingName
    local color = PlayerMessages.DEFAULT_EMPHASIS_COLOR

    PlayerMessages:DisplayConstructionComplete(playerID, buildingName, color)
end



---------------------------------------------------------------------------
-- Methods
---------------------------------------------------------------------------
function PlayerMessages:DisplayResearchComplete(playerID, tech, color)
    color = color or COLOR_RESEARCH_COMPLETE or DEFAULT_EMPHASIS_COLOR
    local notificationString = "<font color='"..color.."'>"..tech.."</font> ".." Researched!"
    
    -- Timed message on top.
    Notifications:ClearTop(playerID)
    Notifications:Top(playerID, {text=notificationString, duration=5.0})
end

function PlayerMessages:DisplayConstructionComplete(playerID, buildingName, color)
    color = color or COLOR_CONSTRUCTION_COMPLETE or DEFAULT_EMPHASIS_COLOR
    local notificationString = "<font color='"..color.."'>"..buildingName.."</font> ".." Constructed"
    
    -- Timed message on bottom.
    Notifications:ClearBottom(playerID)
    Notifications:Bottom(playerID, {text=notificationString, duration=2.0})
end

function PlayerMessages:DisplayMessageToAll(notificationString, duration)
    -- Timed message on top.
    Notifications:ClearTopFromAll()
    Notifications:TopToAll({text=notificationString, duration=duration or 4.0})
end