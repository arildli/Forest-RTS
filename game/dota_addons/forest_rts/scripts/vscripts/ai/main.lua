-- Created by Arild.
-- Depends on the following:
-- * BuildingHelper 1.1.5

if not AI then
    AI = {
        debug = true,
        bots = {},
        botIDs = {}
    }
end

if not BH_VERSION then
    require("libraries/buildinghelper")
end
require("AI/utilities")
require("AI/controller")


-- These settings should be set by the user:
local MAX_PLAYERS_PER_TEAM = 5

local HEROES = {
    "npc_dota_hero_legion_commander",
    "npc_dota_hero_furion",
    "npc_dota_hero_meepo",
    "npc_dota_hero_skeleton_king",
    "npc_dota_hero_troll_warlord"
}
-- End of settings.



---------------------------------------------------------------------------
-- Initializes this module.
---------------------------------------------------------------------------
function AI:Init()
    ListenToGameEvent('npc_spawned', Dynamic_Wrap(AI, 'OnNPCSpawned'), self)

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
            AI:AddBot(DOTA_TEAM_GOODGUYS)
        end, "Adds a bot to the radiant team.", FCVAR_CHEAT)

    Convars:RegisterCommand("ai.addbot.neutral", function()
            print("[AI Cheat] Adding Neutral bot...")
            AI:AddBotNeutralTeam()
        end, "Adds a bot to the radiant team.", FCVAR_CHEAT)

    print("[AI] Initialized AI module.")
end

---------------------------------------------------------------------------
-- Adds a bot to the DOTA_TEAM_NEUTRALS team if possible.
-- (ADD SUPPORT FOR CHOOSING HERO TO BE SPAWNED!)
-- @heroname (String): The name of the hero, optional.
---------------------------------------------------------------------------
function AI:OnNPCSpawned(keys)
    local spawnedUnit = EntIndexToHScript(keys.entindex)
    if not spawnedUnit:IsIllusion() and spawnedUnit:IsHero() and not spawnedUnit._seen then
        spawnedUnit._seen = true
        local playerID = spawnedUnit:GetPlayerID()
        local player = PlayerResource:GetPlayer(playerID)

        -- A real player or bot already has a (non-default) hero.
        if PlayerResource:GetConnectionState(playerID) ~= 1 or AI:BotHasHero(playerID) then
           return
        end

        AI:Print("New bot spawned!")
        AI.botIDs[playerID] = true
        -- NEED FIXING TO CHOOSE HERO!
        spawnedUnit:SetRespawnsDisabled(true)
        UTIL_Remove(spawnedUnit)
        local botStruct = {
            playerID = playerID,
            team = spawnedUnit:GetTeam(),
            hero = CreateHeroForPlayer("npc_dota_hero_legion_commander", player)
        }
        AI.bots[#AI.bots+1] = botStruct
        AI:InitBot(botStruct)
    end
end

---------------------------------------------------------------------------
-- Get the bot with the specified playerID if present.
-- @playerID (Int): The playerID of the bot.
---------------------------------------------------------------------------
function AI:GetBotByID(playerID)
    for k,bot in pairs(AI.bots) do
        if bot.playerID == playerID then
            return bot
        end
    end
    print("AI:GetBotById: No such bot found!")
    return nil
end

---------------------------------------------------------------------------
-- Checks if the bot already has the right hero.
-- @playerID (Int): The playerID of the bot.
---------------------------------------------------------------------------
function AI:BotHasHero(playerID)
    if AI.botIDs[playerID] then
        return true
    end
    return false
end

---------------------------------------------------------------------------
-- Checks if there's space for another bot on the specified team.
-- @teamID (Int): The identifier of the team to check.
---------------------------------------------------------------------------
function AI:IsSpaceForBot(teamID)
    local playerCountForTeam = PlayerResource:GetPlayerCountForTeam(teamID)
    return (playerCountForTeam < MAX_PLAYERS_PER_TEAM)
end

---------------------------------------------------------------------------
-- Adds a bot to the opposite team of the one specified.
-- This will be Dire if DOTA_TEAM_GOODGUYS is specified or
-- Radiant if DOTA_TEAM_BADGUYS is specified.
-- @teamID (Int): The identifier of the team to spawn at.
---------------------------------------------------------------------------
function AI:AddBotOppositeTeam(teamID, heroname)
    AI:AddBot(GetOppositeTeam(teamID), heroname)
end

---------------------------------------------------------------------------
-- Adds a bot to the DOTA_TEAM_NEUTRALS team if possible.
-- (BROKEN!)
-- @heroname (String): The name of the hero, optional.
---------------------------------------------------------------------------
function AI:AddBotNeutralTeam(heroname)
    AI:AddBot(DOTA_TEAM_NEUTRALS, heroname)
end

function AI:AddBot(teamID, heroname)
    if IsTeamDireOrRadiant(teamID) and not AI:IsSpaceForBot(teamID) then
        AI:Print("No empty player slot was found for a new bot.")
        return false
    end
    if IsTeamNeutrals(teamID) then
        print("Max player count neutrals: "..tostring(PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_NEUTRALS)))
    end
    if not heroname then
        heroname = HEROES[RandomInt(1,#HEROES)]
    end

    Tutorial:AddBot(heroname,"","",GetTeamAsBool(teamID))
    AI:Print("Added bot to team "..teamID.." (DOTA_TEAM_GOODGUYS: "..DOTA_TEAM_GOODGUYS..", DOTA_TEAM_BADGUYS: "..DOTA_TEAM_BADGUYS..", DOTA_TEAM_NEUTRALS: "..DOTA_TEAM_NEUTRALS..")")
end

---------------------------------------------------------------------------
-- Prints a message if debugmode for this module is turned on.
-- Also prepends '[AI] ' to the front.
---------------------------------------------------------------------------
function AI:Print(...)
    if AI.debug then
        print("[AI] ".. ...)
    end
end
