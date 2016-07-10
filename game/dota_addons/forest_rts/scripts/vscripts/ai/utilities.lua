-- These methods might depend on the mods used in.

--// -----| Getters |----- \\--

------------------------------------------------------------------
-- Returns the name of the building used to train this unit.
--
-- @bot (Bot): The bot to train for.
-- @constant (UnitConstant): The constant representing the unit to train.
--   Example: WORKER, MELEE, RANGED, SIEGE, CASTER
-- @return (BuildingConstant): The constant representing the building used.
--   Example: TENT_SMALL, BARRACKS, BARRACKS_ADVANCED.
---------------------------------------------------------------------------
function AI:GetTrainedAt(bot, constant)
    local buildingConst = GetEntityFieldFromConstant(constant, bot.team, "trainedAt")
    local hasTeamSuffix = string.find(buildingConst, "_DIRE") or string.find(buildingConst, "_RADIANT")
    if hasTeamSuffix then
        buildingConst = string.sub(buildingConst, 1, hasTeamSuffix-1)
    end
    return buildingConst
end

---------------------------------------------------------------------------
-- Returns a valid location where the building can be constructed.
--
-- @bot (Bot): The bot that wants to build.
-- @constant (UnitContant): The constant representing the building.
-- @return (Vector): A location where the building can be constructed.
---------------------------------------------------------------------------
function AI:GetEntLoc(bot, constant)
    return bot.base.locations[constant][1]
end

---------------------------------------------------------------------------
-- Returns a building of the specified constant if found.
--
-- @bot (Bot): The bot the building belongs to.
-- @constant (BuildingConstant): The constant representing the building
--   to get.
-- @return (Building): A building handle.
---------------------------------------------------------------------------
function AI:GetBuilding(bot, constant)
    local buildingName = AI:GetNameFromConst(bot, constant)
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
-- Returns all units of the specified type.
--
-- @bot (Bot): The bot owning the units.
-- @unitName (string): The name of the units to get.
-- @return (table (Units)): The table of the specified units.
---------------------------------------------------------------------------
function AI:GetCertainUnits(bot, unitName)
    if IsStringConstant(unitName) then
        print(unitName.." was constant!")
        unitName = AI:GetNameFromConst(bot, unitName)
    else
        print("Nope, "..unitName.." was NOT a constant")
    end
    return bot.hero:GetUnitsWithName(unitName)
end

---------------------------------------------------------------------------
-- Converts a constant to a unit or building name.
--
-- @bot (Bot): The requesting bot.
-- @unitType (UnitConstant/BuildingConstant): The constant to convert.
-- @return (string): The name of the building or unit.
---------------------------------------------------------------------------
function AI:GetNameFromConst(bot, unitType)
    if not bot.names[unitType] then
        local heroName = bot.hero:GetUnitName()
        local newName = GetUnitStructFor(unitType, heroName).name
        bot.names[unitType] = newName
        return newName
    end
    return bot.names[unitType]
end

---------------------------------------------------------------------------
-- Converts a name in form of a string to the related constant.
--
-- @bot (Bot): The requesting bot. 
-- @unitName (string): The name to convert.
-- @return (UnitConstant/BuildingConstant): The related constant.
---------------------------------------------------------------------------
function AI:GetConstFromName(bot, unitName)
    return GetConstFor(unitName)
end

---------------------------------------------------------------------------
-- Gets the real unit or building name for a constant.
---------------------------------------------------------------------------
function AI:GetWorkerName(bot)
    return bot.names.WORKER or AI:GetNameFromConst(bot, "WORKER")
end

function AI:GetMeleeName(bot)
    return bot.names.MELEE or AI:GetNameFromConst(bot, "MELEE")
end

function AI:GetRangedName(bot)
    return bot.names.RANGED or AI:GetNameFromConst(bot, "RANGED")
end

function AI:GetSiegeName(bot)
    return bot.names.SIEGE or AI:GetNameFromConst(bot, "SIEGE")
end

function AI:GetCasterName(bot)
    return bot.names.CASTER or AI:GetNameFromConst(bot, "CASTER")
end

function AI:GetMainTentName(bot)
    return bot.names.TENT_SMALL or AI:GetNameFromConst(bot, "TENT_SMALL")
end

function AI:GetGoldMineName(bot)
    return bot.names.GOLD_MINE or AI:GetNameFromConst(bot, "GOLD_MINE")
end

function AI:GetBarracksName(bot)
    return bot.names.BARRACKS or AI:GetNameFromConst(bot, "BARRACKS")
end

---------------------------------------------------------------------------
-- Gets certain locations.
---------------------------------------------------------------------------
function AI:GetBaseLocation(bot)
    return bot.base.locations.TENT_SMALL[1]
end




--// -----| Bools |----- \\--

function AI:HasAtLeast(bot, constant, count)
    local hero = bot.hero
    local name = AI:GetNameFromConst(bot, constant) --GetEntityNameFromConstant(constant)
    local countOfEntity = hero:GetUnitCountFor(name)
    return (countOfEntity >= count)
end

function AI:HasEntity(bot, constant)
    return AI:HasAtLeast(bot, constant, 1)
end

function AI:CanAfford(bot, abilityName)
    local goldCost = GetAbilitySpecial(abilityName, "gold_cost")
    local lumberCost = GetAbilitySpecial(abilityName, "lumber_cost")
    return CanAfford(bot.playerID, goldCost, lumberCost)
end

function AI:UnitShouldReturnToBase(bot, unit)
    return unit:UnitIsLow(bot, unit) and not unit:IsAtBase(bot, unit)
end

function AI:IsAtBase(bot, unit)
    local unitLocation = unit:GetAbsOrigin()
    local baseLocation = AI:GetBaseLocation(bot)
    return VectorDistance(unitLocation, baseLocation) < bot.atBaseThreshold
end

function AI:UnitIsLow(bot, unit)
    local healthPercent = unit:GetHealthPercent()
    if healthPercent < bot.healthThreshold then
        AI:BotPrint(bot, unit:GetUnitName().." has low health, returning to base.")
        AI:UnitReturnToBase()
    end
end



--// -----| Unit Commands |----- \\--

function AI:ReturnToBase(bot, unit)
    local baseLocation = AI:GetBaseLocation(bot)
    MoveWithSmallTimer(unit, baseLocation)
end

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



--// -----| Economy |----- \\--

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
    local buildingName = AI:GetNameFromConst(bot, constant)
    local location = AI:GetEntLoc(bot, constant, bot.heroTeam)
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
    local buildingConst = AI:GetTrainedAt(bot, unitName)
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
-- @buildingName (String): The name of the building to place.
-- @position (Vector): The position to construct the building at.
-- @worker (Optional) (unit): The unit to construct with (hero if nil)
-- @return (boolean): Whether or not the construction could be initiated.
---------------------------------------------------------------------------
function AI:ConstructBuilding(bot, buildingName, position, worker)
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