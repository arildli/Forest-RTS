---------------------------------------------------------------------------
-- Initializes a new bot.
-- @bot (Table): A table containing info about the bot to init.
---------------------------------------------------------------------------
function AI:InitBot(bot)
    --AI:PlaceBuilding(bot.playerID, "npc_dota_building_main_tent_small", Vector(-5984,2144,384))
    --AI:ConstructBuilding(bot.playerID, "npc_dota_building_main_tent_small", Vector(-5984,2144,384))
end

---------------------------------------------------------------------------
-- Attempts to place a building for the specified bot.
-- This building is instantly created!
-- @playerID (Int): The playerID of the owning bot.
-- @buildingName (String): The name of the building to place.
-- @position (Vector): The positional vector to place the building at.
-- @angle (optional) (Vector?): The angle the building should face.
-- @return (building): The constructed building on success.
---------------------------------------------------------------------------
function AI:PlaceBuilding(playerID, buildingName, position, angle)
    local constructionSize = BuildingHelper:GetConstructionSize(buildingName)
    local blockPathingSize = BuildingHelper:GetBlockPathingSize(buildingName)
    angle = angle or BuildingHelper.UnitKV[buildingName]["ModelRotation"] or 0
    return BuildingHelper:PlaceBuilding(playerID, buildingName, position)
end



---------------------------------------------------------------------------
-- Attempts to construct a building for the specified bot the 
-- traditional way.
-- @playerID (Int): The playerID of the owning bot.
-- @buildingName (String): The name of the building to place.
-- @position (Vector): The position to construct the building at.
---------------------------------------------------------------------------
-- PUT ON HOLD!
function AI:ConstructBuilding(playerID, buildingName, position)
    local bot = AI:GetBotByID(playerID)
    if not bot then
        AI:Print("Error: Couldn't get structure for id "..playerID.."!")
        return false
    end
    local buildArgs = {
        builder = bot.hero:GetEntityIndex(),
        Queue = 0,
        PlayerID = playerID,
        X = position.x,
        Y = position.y,
        Z = position.z,
        bot = true
    }

    local addArgs = {
        caster = bot.hero,
        ability = GetConstructionSpellForBuilding(buildingName)
    }
    BuildingHelper:AddBuilding(addArgs)
    BuildingHelper:BuildCommand(buildArgs)
end