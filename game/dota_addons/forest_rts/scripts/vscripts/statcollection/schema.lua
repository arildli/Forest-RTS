customSchema = class({})

function customSchema:init()

    -- Check the schema_examples folder for different implementations

    -- Flag Example
    -- statCollection:setFlags({version = GetVersion()})

    -- Listen for changes in the current state
    ListenToGameEvent('game_rules_state_change', function(keys)
        local state = GameRules:State_Get()

        -- Send custom stats when the game ends
        if state == DOTA_GAMERULES_STATE_POST_GAME then

            -- Build game array
            local game = BuildGameArray()

            -- Build players array
            local players = BuildPlayersArray()

            -- Print the schema data to the console
            if statCollection.TESTING then
                PrintSchema(game, players)
            end

            -- Send custom stats
            if statCollection.HAS_SCHEMA then
                statCollection:sendCustom({ game = game, players = players })
            end
        end
    end, nil)
end

-------------------------------------

-- In the statcollection/lib/utilities.lua, you'll find many useful functions to build your schema.
-- You are also encouraged to call your custom mod-specific functions

-- Returns a table with our custom game tracking.
function BuildGameArray()
    local game = {}

    -- Add game values here as game.someValue = GetSomeGameValue()

    return game
end

-- Returns a table containing data for every player in the game
function BuildPlayersArray()
    local players = {}
    for playerID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            if not PlayerResource:IsBroadcaster(playerID) then

                local hero = PlayerResource:GetSelectedHeroEntity(playerID)

                table.insert(players, {
                    -- steamID32 required in here
                    steamID32 = PlayerResource:GetSteamAccountID(playerID),

                    -- Example functions for generic stats are defined in statcollection/lib/utilities.lua
                    -- Add player values here as someValue = GetSomePlayerValue(),
                })
            end
        end
    end

    return players
end

-- Prints the custom schema, required to get an schemaID
function PrintSchema(gameArray, playerArray)
    print("-------- GAME DATA --------")
    DeepPrintTable(gameArray)
    print("\n-------- PLAYER DATA --------")
    DeepPrintTable(playerArray)
    print("-------------------------------------")
end

-- Write 'test_schema' on the console to test your current functions instead of having to end the game
if Convars:GetBool('developer') then
    Convars:RegisterCommand("test_schema", function() PrintSchema(BuildGameArray(), BuildPlayersArray()) end, "Test the custom schema arrays", 0)
end