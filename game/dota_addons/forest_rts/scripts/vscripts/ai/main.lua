if not BH_VERSION then
    require("libraries/buildinghelper")
end
require("AI/utilities")

-- These settings should be set by the user:
local MAX_PLAYERS_PER_TEAM = 5
-- End of settings.

AI = AI or {}



function AI:Init()
    AI.debug = true

    Convars:RegisterCommand("ai.debug", function()
            print("[AI Cheat] ai.debug = true")
            AI.debug = true
        end, "Enables debug text for the AI modules.", FCVAR_CHEAT) 


    Convars:RegisterCommand("ai.addbot.dire", function()
            print("[AI Cheat] Adding Dire bot...")
            AI:AddBot(DOTA_TEAM_BADGUYS)
        end, "Adds a bot to the dire team.", FCVAR_CHEAT)
            

    Convars:RegisterCommand("ai.addbot.radiant", function()
            print("[AI Cheat] Adding Radiant bot...")
            AI:AddBot(DOTA_TEAM_BADGUYS)
        end, "Adds a bot to the radiant team.", FCVAR_CHEAT)

    Convars:RegisterCommand("ai.addbot.neutral", function()
            print("[AI Cheat] Adding Neutral bot...")
            AI:AddBotNeutralTeam()
        end, "Adds a bot to the radiant team.", FCVAR_CHEAT)

    print("[AI] Initialized AI module.")
end


function AI:IsSpaceForBot(teamID)
    local playerCountForTeam = PlayerResource:GetPlayerCountForTeam(teamID)
    return (playerCountForTeam < MAX_PLAYERS_PER_TEAM)
end


function AI:AddBotOppositeTeam(teamID)
    AI:AddBot(GetOppositeTeam(teamID))
end

function AI:AddBotNeutralTeam()
    AI:AddBot(DOTA_TEAM_NEUTRALS)
end

function AI:AddBot(teamID)
    if IsTeamDireOrRadiant(teamID) and not AI:IsSpaceForBot(teamID) then
        AI:Print("No empty player slot was found for a new bot.")
        return false
    end
    if IsTeamNeutrals(teamID) then
        print("Max player count neutrals: "..tostring(PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_NEUTRALS)))
    end

    local bot = Tutorial:AddBot(HERO_NAMES[1],"","",GetTeamAsBool(teamID))
    AI:Print("Added bot to team "..teamID.." (DOTA_TEAM_GOODGUYS: "..DOTA_TEAM_GOODGUYS..", DOTA_TEAM_BADGUYS: "..DOTA_TEAM_BADGUYS..", DOTA_TEAM_NEUTRALS: "..DOTA_TEAM_NEUTRALS..")")
end

function AI:Print(...)
    if AI.debug then
        print("[AI] ".. ...)
    end
end
