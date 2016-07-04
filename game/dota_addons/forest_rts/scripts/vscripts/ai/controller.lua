---------------------------------------------------------------------------
-- Initializes a new bot.
-- @bot (Table): A table containing info about the bot to init.
---------------------------------------------------------------------------
function AI:InitBot(bot)
    AI:PlaceBuilding(bot.playerID, "npc_dota_building_main_tent_small", Vector(-5984,2144,384))
end

---------------------------------------------------------------------------
-- Attempts to place a building for the specified bot.
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