
AI.bases = {}
AI.bases[DOTA_TEAM_GOODGUYS] = {
    {
        name = "Radiant #1 - Top",
        taken = false,
        locations = {    
            --TENT_SMALL = Vector(-5925, 2176, 384),
            TENT_SMALL = Vector(-6656, -1216, 512),
            GOLD_MINE = Vector(-6656, -832, 512),
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
            ARMORY = Vector(-7616, 64, 512),
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

---------------------------------------------------------------------------
-- Attempts to find an empty base spot.
--
-- @teamID (number): The team of the bot.
---------------------------------------------------------------------------
function AI:FindEmptyBase(teamID)
    local bases = AI.bases[teamID]
    for key,base in pairs(bases) do
        if not base.taken then
            AI:Print("Base with name "..base.name.." was free!")
            local newBase = base
            AI.bases[key] = nil
            return newBase
        end
    end
    return nil
end

---------------------------------------------------------------------------
-- Initializes a new bot.
--
-- @bot (table): A table containing info about the bot to init.
---------------------------------------------------------------------------
function AI:InitBot(bot)
    --AI:ConstructBuilding(bot.playerID, "npc_dota_building_main_tent_small", Vector(-5984,2144,384))
    local base = AI:FindEmptyBase(bot.team)
    if not base then
        AI:Failure("Couldn't find empty base, idling...")
        return
    end
    local mainTent = 
    AI:ConstructBuilding(bot.playerID, "npc_dota_building_main_tent_small", base.locations.TENT_SMALL, GetSpellForEntity(TENT_SMALL))
end