---------------------------------------------------------------------------
-- Initializes a new bot.
-- @bot (Table): A table containing info about the bot to init.
---------------------------------------------------------------------------
function AI:InitBot(bot)
    --AI:PlaceBuilding(bot.playerID, "npc_dota_building_main_tent_small", Vector(-5984,2144,384))
    AI:ConstructBuilding(bot.playerID, "npc_dota_building_main_tent_small", Vector(-5984,2144,384))
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
-- @abilityName (String): The name of the construction ability.
-- @worker (Optional) (unit): The unit to construct with (hero if nil)
---------------------------------------------------------------------------
function AI:ConstructBuilding(playerID, buildingName, position, abilityName, worker)
    local bot = AI:GetBotByID(playerID)
    if not bot then
        AI:Print("Error: Couldn't get structure for id "..playerID.."!")
        return false
    end
    local hero = bot.hero
    if not worker then
        worker = hero
    end
    local buildArgs = {
        builder = hero:GetEntityIndex(),
        Queue = 0,
        PlayerID = playerID,
        X = position.x,
        Y = position.y,
        Z = position.z,
        bot = true
    }

    local abilityName = abilityName or GetConstructionSpellForBuilding(buildingName)
    local abilityLevel = hero:GetAbilityLevelFor(abilityName)
    if abilityLevel < 1 then
        AI:Print("Error: Level requirement not met for "..abilityName.." (playerID: "..playerID..")")
        return false
    end

    -- Make sure to temporarily learn and unlearn the ability if 
    -- the worker doesn't have it, but has its requirements met.
    local hadAbility = worker:HasAbility(abilityName)
    if not hadAbility then
        LearnAbility(worker, abilityName)
    end

    local ability = GetAbilityByName(worker, abilityName)
    local addArgs = {
        caster = worker,
        ability = ability
    }
    --BuildingHelper:AddBuilding(addArgs)
    Build({caster=worker, ability=ability})
    BuildingHelper:BuildCommand(buildArgs)

    if not hadAbility then
        UnlearnAbility(worker, abilityName)
    end
end