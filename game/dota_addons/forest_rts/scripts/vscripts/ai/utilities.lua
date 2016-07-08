-- These methods might depend on the mods used in.

--// -----| Getters |----- \\--

function AI:GetEntName(constant, teamID)
    return GetEntityFieldFromConstant(constant, teamID, "name")
end

function AI:GetTrainedAt(constant, teamID)
    return GetEntityFieldFromConstant(constant, teamID, "trainedAt")
end

function AI:GetEntLoc(bot, constant, teamID)
    return bot.base.locations[constant][1]
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

function AI:GetUnitTypeNames(bot, unitType)
    if not bot.names[unitType] then
        local heroName = bot.hero:GetUnitName()
        local newName = GetUnitStructFor(unitType, heroName).name
        bot.names[unitType] = newName
        return newName
    end
    return bot.names[unitType]
end

function AI:GetWorkerName(bot)
    return bot.names.worker or AI:GetUnitTypeNames(bot, "worker")
end

function AI:GetMeleeName(bot)
    return bot.names.melee or AI:GetUnitTypeNames(bot, "melee")
end

function AI:GetRangedName(bot)
    return bot.names.ranged or AI:GetUnitTypeNames(bot, "ranged")
end

function AI:GetSiegeName(bot)
    return bot.names.siege or AI:GetUnitTypeNames(bot, "siege")
end

function AI:GetCasterName(bot)
    return bot.names.caster or AI:GetUnitTypeNames(bot, "caster")
end



--// -----| Bools |----- \\--

function AI:HasAtLeast(bot, constant, count)
    local hero = bot.hero
    local name
    if IsConstant(constant) then
        name = GetEntityNameFromConstant(constant, bot.team)
    else 
        name = constant
    end
    local countOfEntity = hero:GetUnitCountFor(name)
    return (countOfEntity >= count)
end

function AI:HasEntity(bot, constant)
    return AI:HasAtLeast(bot, constant, 1)
end

function AI:HasEntityTeamSpecific(bot, constant)
    local team = bot.team
    local suffixes = {
        [DOTA_TEAM_GOODGUYS] = "_RADIANT",
        [DOTA_TEAM_BADGUYS] = "_DIRE"
    }
    return AI:HasAtLeast(bot, constant..suffixes[team], 1)
end


function AI:CanAfford(bot, abilityName)
    local goldCost = GetAbilitySpecial(abilityName, "gold_cost")
    local lumberCost = GetAbilitySpecial(abilityName, "lumber_cost")
    print(abilityName.." (gold: "..goldCost..", lumber: "..lumberCost..")".." for player "..bot.playerID)
    return CanAfford(bot.playerID, goldCost, lumberCost)
end



--// -----| Economy |----- \\--

function AI:HarvestLumber(bot, unit)
    if not unit.HARVESTER then
        Resources:InitHarvester(unit)
    end
    local tree = FindEmptyTree(unit, unit:GetAbsOrigin(), unit.HARVESTER.treeSearchRadius)
    if not tree then
        AI:Failure("Failed to find tree in radius "..unit.HARVESTER.treeSearchRadius)
        return
    end

    local harvestAbility = unit:FindAbilityByName("srts_harvest_lumber_worker") or
        unit:FindAbilityByName("srts_harvest_lumber")
    if harvestAbility then
        Timers:CreateTimer({
            endTime = 0.05,
            callback = function()
                unit:CastAbilityOnTarget(tree, harvestAbility, playerID)
            end})
    end
end

function AI:SpendResourcesConstruction(bot, abilityName)
    local goldCost = GetAbilitySpecial(abilityName, "gold_cost")
    local lumberCost = GetAbilitySpecial(abilityName, "lumber_cost")
    AI:SpendResources(bot, goldCost, lumberCost)
end

function AI:SpendResources(bot, gold, lumber)
    local player = PlayerResource:GetPlayer(bot.playerID)
    SpendResourcesNew(player, gold, lumber)
end

function AI:ConstructBuildingWrapper(bot, constant)
    local buildingName = AI:GetEntName(constant, bot.team)
    local location = AI:GetEntLoc(bot, constant, bot.team)
    return AI:ConstructBuilding(bot, buildingName, location)
end



--// -----| Training and Construction |----- \\--

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
    local abilityName = GetSpellForEntity(unitName)
    local buildingConst = AI:GetTrainedAt(unitName, bot.team)
    local building = AI:GetBuilding(bot, buildingConst)
    if not building then
        AI:BotPrint(bot, "Couldn't find building to train "..unitName.." at")
        return false
    elseif building:IsChanneling() then
        AI:BotPrint(bot, "Building already channeling.")
        return false
    end

    local playerID = bot.playerID
    local player = PlayerResource:GetPlayer(playerID)
    if not AI:CanAfford(bot, abilityName) then
        AI:BotPrint(bot, "Cannot afford a new "..unitName)
        return false
    end
    --[=[
    local goldCost = GetAbilitySpecial(abilityName, "gold_cost")
    local lumberCost = GetAbilitySpecial(abilityName, "lumber_cost")
    if not CanAfford(player, goldCost, lumberCost) then
        AI:BotPrint(bot, "Cannot afford a new "..unitName.." (GoldCost: "..goldCost..", lumberCost: "..lumberCost..")")
        return false
    end]=]
    if not building:HasAbility(abilityName) then
        AI:Failure("The building doesn't have "..abilityName)
        return false
    end

    local ability = building:FindAbilityByName(abilityName)
    if ability:GetLevel() == 0 then
        AI:Failure("Cannot train unit "..unitName)
        return false
    end
    building:CastAbilityNoTarget(ability, playerID)
    return true
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
-- @worker (Optional) (unit): The unit to construct with (hero if nil)
-- @return (boolean): Whether or not the construction could be initiated.
---------------------------------------------------------------------------
function AI:ConstructBuilding(bot, buildingName, position, worker)
    if IsConstant(buildingName) then
        buildingName = AI:GetEntName(buildingName, bot.team)
    end

    -- Make sure to have access to both a worker, a playerID and a hero.
    playerID = bot.playerID
    local hero = bot.hero
    if not worker then
        worker = hero
    end

    -- Check if the worker has the required tech to construct the building.
    local abilityName = GetConstructionSpellForBuilding(buildingName)
    local abilityLevel = hero:GetAbilityLevelFor(abilityName)
    if abilityLevel < 1 then
        AI:Print("Error: Level requirement not met for "..abilityName.." (playerID: "..playerID..")")
        return false
    end

    if not AI:CanAfford(bot, abilityName) then
        AI:BotPrint(bot, "Cannot afford a new "..buildingName)
        return false
    end
    AI:SpendResourcesConstruction(bot, abilityName)

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