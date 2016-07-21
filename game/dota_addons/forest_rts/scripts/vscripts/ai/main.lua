--[[ 
    A simple library for creating bots in Dota.
    Author: Arild

    Installation:
    - require 'ai/main' in your code.
    - make sure the settings file can be found on this path: scripts/kv/ai_settings.kv
    - make sure to also have the following installed:
        * BuildingHelper from https://github.com/MNoya/BuildingHelper/releases
        * keyvalues.lua from https://github.com/MNoya/DotaCraft/tree/master/game/dota_addons/dotacraft/scripts/vscripts/libraries

    Usage: 
    - Modify the controller file with the logic for your bot.
      See commands.lua for commands the bot can perform.
    - Call AI:Init() to initialize the module.
    - Use AI:AddBot or AI:AddBotOppositeTeam to spawn a bot. 
]]

if not AI then
    AI = {}
end

if not BH_VERSION then
    require("libraries/buildinghelper")
end
require("AI/independent_utilities")
require("AI/utilities")
require("AI/commands")
require("AI/controller")
require('libraries/keyvalues')


local HEROES = {
    "npc_dota_hero_legion_commander",
    "npc_dota_hero_furion",
    "npc_dota_hero_meepo",
    "npc_dota_hero_skeleton_king",
    "npc_dota_hero_troll_warlord"
}

-- These settings should be set by the user:
local ai_local_settings = {
    MAX_PLAYERS_PER_TEAM = 5,
    HEROTEAM = {
        [HEROES[1]] = DOTA_TEAM_GOODGUYS,
        [HEROES[2]] = DOTA_TEAM_GOODGUYS,
        [HEROES[3]] = DOTA_TEAM_BADGUYS,
        [HEROES[4]] = DOTA_TEAM_BADGUYS,
        [HEROES[5]] = DOTA_TEAM_BADGUYS
    },
    MULTIPLIER = {
        [HEROES[1]] = 1,
        [HEROES[2]] = 1,
        [HEROES[3]] = 1.25,
        [HEROES[4]] = 1.5,
        [HEROES[5]] = 1.1
    },
    RACES = {
        [HEROES[1]] = "Commander",
        [HEROES[2]] = "Furion",
        [HEROES[3]] = "Geomancer",
        [HEROES[4]] = "King of the Dead",
        [HEROES[5]] = "Warlord"
    }
}
-- End of settings.



---------------------------------------------------------------------------
-- Initializes this module.
---------------------------------------------------------------------------
function AI:Init()
    AI:LoadSettings()

    -- Will contain info about the bots.
    AI.bots = {}                                        
    -- Set containing the playerIDs used by bots.
    AI.botIDs = {}        
    -- Contains the valid locations for bases and outposts.
    AI.bases = {}                       
    -- The next spawned bot hero should be set to this.
    AI.nextHero = {}     
    AI.nextHeroIndex = 1
    AI.lastHeroIndex = 1
    AI.thinkInterval = 0.5

    AI:PrintSettings()
    AI:AddBases()

    ListenToGameEvent('npc_spawned', Dynamic_Wrap(AI, 'OnNPCSpawned'), self)

    Convars:RegisterCommand("ai.debug", function()
        print("[AI Cheat] ai.debug = true")
        AI.settings["TESTING"] = true
    end, "Enables debug text for the AI modules.", FCVAR_CHEAT) 


    Convars:RegisterCommand("ai.settings", function()
        AI:PrintSettings()
    end, "Prints the settings of the module.", FCVAR_CHEAT) 


    Convars:RegisterCommand("ai.addbot.dire", function()
        print("[AI Cheat] Adding Dire bot...")
        AI:AddBot(DOTA_TEAM_BADGUYS, HEROES[1])
    end, "Adds a bot to the dire team.", FCVAR_CHEAT)
            

    Convars:RegisterCommand("ai.addbot.radiant", function()
        print("[AI Cheat] Adding Radiant bot...")
        AI:AddBot(DOTA_TEAM_GOODGUYS, HEROES[1])
    end, "Adds a bot to the radiant team.", FCVAR_CHEAT)

    Convars:RegisterCommand("ai.addbot.neutral", function()
        print("[AI Cheat] Adding Neutral bot...")
        AI:AddBotNeutralTeam()
    end, "Adds a bot to the radiant team.", FCVAR_CHEAT)

    Convars:RegisterCommand("ai.testing", function()
        AI:Print("Enabling cheat mode!")
        BuildingHelper:WarpTen(true)
        AI:AddBot(DOTA_TEAM_BADGUYS, HEROES[4])
        AI:AddBot(DOTA_TEAM_GOODGUYS, HEROES[1])
        AI.speedUpTraining = true
        AI.cheat = true

    end, "Speeds up the bot stuff", FCVAR_CHEAT)

    print("[AI] Initialized AI module.")
end

---------------------------------------------------------------------------
-- Loads the settings to use from a KV file.
---------------------------------------------------------------------------
function AI:LoadSettings()
    AI.settings = LoadKeyValues("scripts/kv/ai_settings.kv")

    AI.settings["TESTING"] = tobool(AI.settings["TESTING"])
end

---------------------------------------------------------------------------
-- Prints the current settings.
---------------------------------------------------------------------------
function AI:PrintSettings()
    AI:Print("Printing settings:")
    for k,v in pairs(AI.settings) do
        AI:Print("\t"..k..": "..tostring(v))
    end
end

---------------------------------------------------------------------------
-- Makes sure the newest bot hero spawns as the right one.
--
-- @heroname (string): The name of the hero, optional.
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
        spawnedUnit:SetRespawnsDisabled(true)
        UTIL_Remove(spawnedUnit)
        local nextHeroName = AI.nextHero[AI.nextHeroIndex] or "npc_dota_hero_legion_commander"
        print("NextHeroName: "..nextHeroName)
        local botStruct = {
            playerID = playerID,
            team = spawnedUnit:GetTeam(),
            hero = CreateHeroForPlayer(nextHeroName, player),
            heroname = nextHeroName,
            names = {},
            fleeWhenLowHealth = true,
            lowHealthThreshold = 20,
            highHealthThreshold = 80,
            atBaseThreshold = 1200,
            base = nil,
            detectEnemyNearBaseRadius = 900,
            multiplier = ai_local_settings.MULTIPLIER[nextHeroName],
            miniForce = 5,
            decentForceBasicUnits = 16,
            decentForceLeastTotal = 20,
            underAttackTimer = 0,
            underAttackTimerMax = 5 / AI.thinkInterval,
            mixedMinimumEach = 5,
            basicSiege = 3,
            basicCasters = 4,
            heroTeam = ai_local_settings.HEROTEAM[nextHeroName],
            race = ai_local_settings.RACES[nextHeroName]
        }
        AI.nextHeroIndex = AI.nextHeroIndex + 1
        AI.bots[#AI.bots+1] = botStruct
        if AI.cheat then
            local hero = botStruct.hero
            Resources:InitHero(hero)
            hero:SetGold(99999)
            hero:SetLumber(99999)
            hero:AddAbility("srts_hero_vision")
            hero:FindAbilityByName("srts_hero_vision"):SetLevel(1)
            hero:SetBaseMoveSpeed(650)
        end
        AI:InitBot(botStruct)
    end
end

---------------------------------------------------------------------------
-- Get the bot with the specified playerID if present.
--
-- @playerID (number): The playerID of the bot.
-- @return (Bot): A table containing information about the bot.
---------------------------------------------------------------------------
function AI:GetBotByID(playerID)
    for k,bot in pairs(AI.bots) do
        if bot.playerID == playerID then
            return bot
        end
    end
    return nil
end

---------------------------------------------------------------------------
-- Returns a table with all the bots.
--
-- @return (Bot): A table containing information about the bot.
---------------------------------------------------------------------------
function AI:GetAllBots()
    return AI.bots
end

---------------------------------------------------------------------------
-- Checks if the bot already has the right hero.
--
-- @playerID (number): The playerID of the bot.
-- @return (boolean): Whether or not the bot has been inited yet.
---------------------------------------------------------------------------
function AI:BotHasHero(playerID)
    if AI.botIDs[playerID] then
        return true
    end
    return false
end

---------------------------------------------------------------------------
-- Checks if there's space for another bot on the specified team.
--
-- @teamID (number): The identifier of the team to check.
-- @return (boolean): Whether or not the team has space for a new bot.
---------------------------------------------------------------------------
function AI:IsSpaceForBot(teamID)
    local playerCountForTeam = PlayerResource:GetPlayerCountForTeam(teamID)
    return (playerCountForTeam < ai_local_settings.MAX_PLAYERS_PER_TEAM)
end

---------------------------------------------------------------------------
-- Adds a bot to the opposite team of the one specified.
-- This will be Dire if DOTA_TEAM_GOODGUYS is specified or
-- Radiant if DOTA_TEAM_BADGUYS is specified.
--
-- @teamID (number): The identifier of the team to spawn at.
-- @heroname (string): The name of the hero to spawn.
---------------------------------------------------------------------------
function AI:AddBotOppositeTeam(teamID, heroname)
    AI:AddBot(GetOppositeTeam(teamID), heroname)
end

---------------------------------------------------------------------------
-- Adds a bot to the DOTA_TEAM_NEUTRALS team if possible.
-- (BROKEN!)
--
-- @heroname (string): The name of the hero, optional.
---------------------------------------------------------------------------
--function AI:AddBotNeutralTeam(heroname)
--    AI:AddBot(DOTA_TEAM_NEUTRALS, heroname)
--end

---------------------------------------------------------------------------
-- Adds a new bot to the specified team.
-- ONLY works for Radiant and Dire due to restriction in Tutorial:AddBot!
--
-- @teamID (number): The identifier of the team to spawn at.
-- @heroname (string) (Optional): The name of the hero.
-- @return (boolean): Whether or not a new bot was added.
---------------------------------------------------------------------------
function AI:AddBot(teamID, heroname)
    if not IsTeamDireOrRadiant(teamID) then
        AI:Failure("Team must be DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS!")
        return false
    elseif not AI:IsSpaceForBot(teamID) then
        AI:Failure("No empty player slot was found on team "..teamID.."!")
        return false
    end
    AI:Print("Max player count neutrals: "..tostring(PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_NEUTRALS)))
    if not heroname then
        heroname = "npc_dota_hero_legion_commander"
    end
    AI.nextHero[AI.lastHeroIndex] = "npc_dota_hero_legion_commander" --heroname
    AI.lastHeroIndex = AI.lastHeroIndex + 1

    Tutorial:AddBot(heroname,"","",GetTeamAsBool(teamID))
    --Tutorial:AddBot("npc_dota_hero_legion_commander","","",GetTeamAsBool(teamID))
    AI:Print("Added bot to team "..teamID.." (DOTA_TEAM_GOODGUYS: "..DOTA_TEAM_GOODGUYS..", DOTA_TEAM_BADGUYS: "..DOTA_TEAM_BADGUYS..", DOTA_TEAM_NEUTRALS: "..DOTA_TEAM_NEUTRALS..")")
    return true
end

---------------------------------------------------------------------------
-- Prints a message if debugmode for this module is turned on.
-- Also prepends '[AI] ' to the front.
---------------------------------------------------------------------------
function AI:Print(...)
    if AI.settings["TESTING"] then
        print("[AI] ".. ...)
    end
end

function AI:print(...)
    AI:Print(...)
end

function AI:BotPrint(bot, ...)
    if not ... then
        print("ERROR: ... was nil!")
    end
    AI:Print("["..bot.race.." - "..bot.playerID.."] ".. ...)
end

---------------------------------------------------------------------------
-- Prints an error message.
-- Also prepends '[AI] (ERROR) ' to the front.
---------------------------------------------------------------------------
function AI:Failure(...)
    print("[AI] (ERROR) ".. ...)
end
