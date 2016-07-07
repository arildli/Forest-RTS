-- These methods might depend on the mods used in.

function AI:GetEntName(constant, teamID)
    return GetEntityFieldFromConstant(constant, teamID, "name")
end

function AI:GetTrainedAt(constant, teamID)
    return GetEntityFieldFromConstant(constant, teamID, "trainedAt")
end

function AI:GetEntLoc(bot, constant, teamID)
    return bot.base.locations[constant][1]
end

function AI:HasAtLeast(bot, constant, count)
    local hero = bot.hero
    local name = GetEntityNameFromConstant(constant)
    local countOfEntity = hero:GetUnitCountFor(name)
    return (countOfEntity >= count)
end

function AI:HasEntity(bot, constant)
    return AI:HasAtLeast(bot, constant, 1)
end

function AI:ConstructBuildingWrapper(bot, constant)
    return AI:ConstructBuilding(AI:GetEntName(constant, bot.team), AI:GetEntLoc(bot, constant, bot.team), bot.hero)
end

function AI:GetBuilding(bot, constant)
    local buildingName = AI:GetEntName(constant, bot.team)
    local buildings = bot.hero:GetBuildings()
    for index,building in pairs(buildings) do
        if building:GetUnitName() == buildingName then
            return building
        end
    end
    AI:Failure("Bot doesn't have building with name "..constant.." ("..buildingName..")")
    return nil
end

---------------------------------------------------------------------------
-- Gets all the necessary information and performs all necessary
-- checks to determine if and where the unit can be trained.
-- Trains the unit on success.
--
-- @bot (Bot): The bot to train it for.
-- @unitName (string): The name of the unit to train.
-- @return (bool): Whether or not the unit could be trained.
---------------------------------------------------------------------------
function AI:TrainUnit(bot, unitName)
    local abilityName = GetSpellForEntityConst(unitName)
    local buildingConst = AI:GetTrainedAt(unitName, bot.team)
    local building = AI:GetBuilding(bot, buildingConst)
    if not building then
        AI:BotPrint(bot, "Couldn't find building to train "..unitName.." at")
        return false
    elseif building:IsChanneling() then
        AI:BotPrint(bot, "Building already channeling.")
        return false
    end

    local goldCost = GetAbilitySpecial(abilityName, "gold_cost")
    local lumberCost = GetAbilitySpecial(abilityName, "lumber_cost")
    local playerID = bot.playerID
    local player = PlayerResource:GetPlayer(playerID)
    print("Gold cost: "..goldCost..", lumber cost: "..lumberCost)
    if not CanAfford(player, goldCost, lumberCost) then
        AI:BotPrint(bot, "Cannot afford a new "..unitName.." (GoldCost: "..goldCost..", lumberCost: "..lumberCost..")")
        return false
    end
    if not building:HasAbility(abilityName) then
        AI:Failure("The building doesn't have "..abilityName)
        return false
    end

    local ability = building:FindAbilityByName(abilityName)
    building:CastAbilityNoTarget(ability, playerID)
    return true
end

---------------------------------------------------------------------------
-- Predicates for buildingchecks.
---------------------------------------------------------------------------
function HasTent(bot)
    return AI:HasEntity(bot, "TENT_SMALL")
end 

function HasGoldMine(bot)
    return AI:HasEntity(bot, "GOLD_MINE")
end

function Has5Workers(bot)
    local workerName = GetWorkerStructFor(bot.heroname).name
    return AI:HasAtLeast(bot, workerName, 5)
end

---------------------------------------------------------------------------
-- Construction of buildings.
---------------------------------------------------------------------------
function ConstructTent(bot)
    AI:BotPrint(bot, "Constructing Main Tent")
    if AI:ConstructBuildingWrapper(bot, "TENT_SMALL") then
        bot.state = "busy"
    end
end

function ConstructGoldMine(bot)
    AI:BotPrint(bot, "Constructing Gold Mine")
    if AI:ConstructBuildingWrapper(bot, "GOLD_MINE") then
        bot.state = "constructing"
    end
end

function TrainWorker(bot)
    AI:BotPrint(bot, "Training Worker")
    local unitConst = GetWorkerConstFor(bot.heroname)
    AI:TrainUnit(bot, unitConst)
    --[=[
    local building = AI:GetBuilding(bot, "TENT_SMALL")
    if not building then
        AI:Failure("Failed to find Main Tent to train workers from!")
        return false
    elseif building:IsChanneling() then
        AI:BotPrint(bot, "Building already channeling.")
        return false
    end
    local unitName = GetWorkerStructFor(bot.heroname).name
    local spellName = GetSpellForEntity(unitName)
    local goldCost = GetAbilitySpecial(spellName, "gold_cost")
    local lumberCost = GetAbilitySpecial(spellName, "lumber_cost")
    local playerID = bot.playerID
    local player = PlayerResource:GetPlayer(playerID)
    print("Gold cost: "..goldCost..", lumber cost: "..lumberCost)
    if not CanAfford(player, goldCost, lumberCost) then
        AI:BotPrint(bot, "Cannot afford a new "..unitName.." (GoldCost: "..goldCost..", lumberCost: "..lumberCost..")")
        return false
    end
    if not building:HasAbility(spellName) then
        AI:Failure("The building didn't have "..spellName)
        return false
    end
    local ability = building:FindAbilityByName(spellName)
    building:CastAbilityNoTarget(ability, playerID)
    return true
    ]=]
end

---------------------------------------------------------------------------
-- Attempts to place a building for the specified bot.
-- This building is instantly created!
--
-- @playerID (Int): The playerID of the owning bot.
-- @buildingName (String): The name of the building to place.
-- @position (Vector): The positional vector to place the building at.
-- @angle (optional) (Vector?): The angle the building should face.
-- @return (Building): The constructed building on success.
---------------------------------------------------------------------------
function AI:PlaceBuilding(playerID, buildingName, position, angle)
    return PlaceBuilding(playerID, buildingName, position, angle)
end

---------------------------------------------------------------------------
-- Attempts to construct a building for the specified bot the 
-- traditional way.
--
-- @buildingName (String): The name (or constant) of the building to place.
-- @position (Vector): The position to construct the building at.
-- @playerID (Optional) (Int): The playerID of the owning bot.
-- @worker (Optional) (unit): The unit to construct with (hero if nil)
-- NOTE: Either playerID or worker must be specified, but no need to do both.
-- @return (boolean): Whether or not the construction could be initiated.
---------------------------------------------------------------------------
function AI:ConstructBuilding(buildingName, position, worker, playerID)
    if not worker and not playerID then 
        AI:Failure("(AI:ConstructBuilding) Both worker and playerID was nil!"); 
        return false
    end
    if IsConstant(buildingName) then
        buildingName = AI:GetEntName(buildingName, bots.team)
    end

    -- Make sure to have access to both a worker, a playerID and a hero.
    playerID = playerID or worker:GetOwnerID()
    local hero 
    if not worker then
        local bot = AI:GetBotByID(playerID)
        if not bot then
            AI:Print("Error: Couldn't get structure for id "..playerID.."!")
            return false
        end
        hero = bot.hero
        worker = hero
    elseif not playerID then
        local bot = AI:GetBotByID(playerID)
        hero = bot.hero
    end
    if not worker:IsIllusion() and worker:IsRealHero() then
        hero = worker
    end

    -- Check if the worker has the required tech to construct the building.
    local abilityName = GetConstructionSpellForBuilding(buildingName)
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

    ConstructBuilding(worker, ability, position)

    if not hadAbility then
        UnlearnAbility(worker, abilityName)
    end
    return true
end