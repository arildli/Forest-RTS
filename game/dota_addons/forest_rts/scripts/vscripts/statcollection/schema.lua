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
    game.gm = Stats.game.mode                                                              -- New

    return game
end

-- Returns a table containing data for every player in the game
function BuildPlayersArray()
    local players = {}
    for playerID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            if not PlayerResource:IsBroadcaster(playerID) then

                local hero = PlayerResource:GetSelectedHeroEntity(playerID)
                local stats = Stats:GetPlayer(playerID)

                table.insert(players, {
                    -- steamID32 required in here
                    steamID32 = PlayerResource:GetSteamAccountID(playerID),

                    -- Hero related
                    hn = GetHeroName(playerID), -- Hero Name
                    hl = stats.herolevel, -- Hero Level
                    t = stats.team, -- Team                                                -- New

                    -- Economy
                    gg = stats.goldGained, -- Gold Gained
                    gs = stats.goldSpent,  -- Gold Spent
                    lg = stats.lumberGained, -- Lumber Gained
                    ls = stats.lumberSpent, -- Lumber Spent

                    -- Units
                    utt = stats.trainedTotal, -- Units Trained Total
                    ult = stats.unitsLostTotal, -- Units Lost Total
                    ukt = stats.unitsKilledTotal, -- Units Killed Total
                    td = stats.tentsDestroyed, -- Tents Destroyed                          -- New
                    hk = Stats:GetHeroesKilled(playerID), -- Heroes Killed Total           -- New
                    --wt = Stats:GetWorkerTrained(playerID), -- Worker Units Trained         -- New
                    --wl = Stats:GetWorkerLost(playerID), -- Worker Units Lost               -- New
                    mt = Stats:GetMeleeTrained(playerID), -- Melee Units Trained
                    ml = Stats:GetMeleeLost(playerID), -- Melee Units Lost
                    rt = Stats:GetRangedTrained(playerID), -- Ranged Units Trained
                    rl = Stats:GetRangedLost(playerID), -- Ranged Units Lost
                    ct = Stats:GetCasterTrained(playerID), -- Caster Units Trained
                    cl = Stats:GetCasterLost(playerID), -- Caster Units Lost
                    st = Stats:GetSiegeTrained(playerID), -- Siege Units Trained
                    sl = Stats:GetSiegeLost(playerID), -- Siege Units Lost

                    -- Buildings
                    bct = stats.constructedTotal, -- Buildings Constructed Total
                    blt = stats.buildingsLostTotal, -- Buildings Lost Total
                    bdt = stats.buildingsDestroyedTotal, -- Buildings Destroyed Total

                    -- Upgrades
                    urt = stats.upgradesResearchedTotal, -- Upgrades Researched Total
                    ula = stats.upgradesResearched["srts_upgrade_light_armor"] or 0, -- Upgrade Light Armor
                    uld = stats.upgradesResearched["srts_upgrade_light_damage"] or 0 -- Upgrade Light Damage


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