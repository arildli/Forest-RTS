---------------------------------------------------------------------------
-- Adds all the known base locations.
---------------------------------------------------------------------------
function AI:AddBases()
    AI.bases[DOTA_TEAM_GOODGUYS] = {
        {
            name = "Radiant #1 - Top",
            taken = false,
            basetype = "base",
            locations = {    
                --TENT_SMALL = Vector(-5925, 2176, 384),
                TENT_SMALL = {Vector(-6656, -1216, 512)},
                GOLD_MINE = {Vector(-6656, -832, 512)},
                WATCH_TOWER = {
                    -- By tent
                    Vector(-6656, -1216, 512),
                    -- North wall
                    Vector(-6880, 928, 640),
                    Vector(-7456, 864, 640),
                    -- South wall
                    Vector(-6688, -2208, 512),
                    Vector(-7072, -2208, 512)
                },
                WOODEN_WALL = {
                    -- North wall
                    Vector(-7072, 928, 640),
                    Vector(-7264, 928, 640),
                    -- South wall
                    Vector(-6880, -2208, 512)
                },
                ARMORY = {Vector(-7616, 64, 512)},
                BARRACKS = {
                    Vector(-7296, -256, 512),
                    Vector(-7296, -640, 512)
                },
                BARRACKS_ADVANCED = {
                    Vector(-7296, 320, 512)
                },
                HEALING_CRYSTAL = {
                    Vector(-6912, -1664, 512)
                },
                MARKET = {
                    Vector(-6080, 1088, 256) -- Outside
                }
            }
        }
    }

    AI.bases[DOTA_TEAM_BADGUYS] = {

    }
end

AI.priorities = {
    {pred = HasTent, onFail = ConstructTent},
    {pred = HasGoldMine, onFail = ConstructGoldMine},
    {pred = Has5Workers, onFail = TrainWorker}
}

---------------------------------------------------------------------------
-- Initializes a new bot.
--
-- @bot (table): A table containing info about the bot to init.
---------------------------------------------------------------------------
function AI:InitBot(bot)
    --AI:ConstructBuilding(bot.playerID, "npc_dota_building_main_tent_small", Vector(-5984,2144,384))
    bot.base = AI:FindUntakenBase(bot.team)
    if not bot.base then
        AI:Failure("Couldn't find empty base, idling...")
        return
    end

    ListenToGameEvent("construction_started", Dynamic_Wrap(AI, "OnConstructionStarted"), self)
    ListenToGameEvent("construction_done", Dynamic_Wrap(AI, "OnConstructionFinished"), self)
    ListenToGameEvent("unit_trained", Dynamic_Wrap(AI, "OnUnitTrained"), self)

    -- TEMP
    --bot.hero:SetOrigin(Vector(-6880, -2208, 512))

    bot.state = "idle"
    AI:StartThink(bot)
end

---------------------------------------------------------------------------
-- Starts the regular thinking.
--
-- @bot (table): A table containing info about the bot.
---------------------------------------------------------------------------
function AI:StartThink(bot)
    Timers:CreateTimer(function()
        AI:Think(bot)
        return AI.thinkInterval
    end)
end

---------------------------------------------------------------------------
-- The regular thinking that decides what to do next.
--
-- @bot (table): A table containing info about the bot.
---------------------------------------------------------------------------
function AI:Think(bot)
    if bot.state == "idle" then
        AI:BotPrint(bot, "Looking for stuff to do...")
        local action = AI:FindActionToPerform(bot)
        if action then
            action.onFail(bot)
        end
    end
end

---------------------------------------------------------------------------
-- Attempts to find the action to perform that has the highest priority.
--
-- @bot (Bot): The structure holding information about the bot.
-- @return (table (Action)): A table containing a predicate and onfailure
--   functions. {pred, onFail}
---------------------------------------------------------------------------
function AI:FindActionToPerform(bot)
    for k,action in ipairs(AI.priorities) do
        if not action.pred(bot) then
            return action
        end
    end
    AI:Print("I'm out of actions! :(")
    return nil
end

function AI:OnConstructionStarted(keys)
    local playerID = keys.playerID
    local bot = AI:GetBotByID(playerID)
    if not bot or bot.playerID ~= playerID then
        AI:Print("Nope, event wasn't for me!")
        return
    end
    local building = EntIndexToHScript(keys.building)
    AI:Print("Started construction of a new "..building:GetUnitName())
    if bot.state == "constructing" then
        AI:BotPrint(bot, "Now idling")
        bot.state = "idle"
    end
end

function AI:OnConstructionFinished(keys)
    local playerID = keys.playerID
    local bot = AI:GetBotByID(playerID)
    if not bot or bot.playerID ~= playerID then
        AI:Print("Nope, event wasn't for me!")
        return
    end
    local building = EntIndexToHScript(keys.building)
    local buildingName = building:GetUnitName()
    AI:BotPrint(bot, "Construction of a new "..buildingName.." just finished!")
    if buildingName == GetEntityNameFromConstant("TENT_SMALL") or
       buildingName == GetEntityNameFromConstant("GOLD_MINE") then
        AI:BotPrint(bot, "My Main Tent/Gold Mine is finished!")
        bot.state = "idle"
    end
end

function AI:OnUnitTrained(keys)

end



---------------------------------------------------------------------------
-- Attempts to find an empty base spot.
--
-- @teamID (number): The team of the bot.
-- @basetype (string): "base" for base, "outpost" for outpost.
-- @return (table): Table containing info about the base on success.
---------------------------------------------------------------------------
function AI:FindBase(teamID, basetype)
    local bases = AI.bases[teamID]
    for key,base in pairs(bases) do
        if base.basetype == basetype and not base.taken then
            AI:Print("Base with name "..base.name.." was free! Type: "..basetype)
            base.taken = true
            return base
        end
    end
    return nil
end

function AI:FindUntakenBase(teamID)
    return AI:FindBase(teamID, "base")
end

function AI:FindUntakenOutpost(teamID)
    return AI:FindBase(teamID, "outpost")
end

