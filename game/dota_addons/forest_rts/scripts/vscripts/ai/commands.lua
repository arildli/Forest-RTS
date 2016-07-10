
function AI:IdleHeroAction(bot)
    local hero = bot.hero
    if not hero:IsChanneling() and not hero:HasItemInInventory("item_stack_of_lumber") then
        AI:HarvestLumber(bot, hero)
    end
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

function HasBarracks(bot)
    return AI:HasEntity(bot, "BARRACKS")
end

function HasHealingCrystal(bot)
    return AI:HasEntity(bot, "HEALING_CRYSTAL")
end

function HasMarket(bot)
    return AI:HasEntity(bot, "MARKET")
end

function Has5Workers(bot)
    local workerName = AI:GetWorkerName(bot)
    local hasEnough = AI:HasAtLeast(bot, workerName, 5)
    return hasEnough
end

function Has10Workers(bot)
    local workerName = AI:GetWorkerName(bot)
    local hasEnough = AI:HasAtLeast(bot, workerName, 10)
    return hasEnough
end

function HasMiniForce(bot)
    local hero = bot.hero

    local meleeCount = AI:GetCountFor(bot, "MELEE")
    local rangedCount = AI:GetCountFor(bot, "RANGED")
    local sum = meleeCount + rangedCount
    local requirement = 5

    AI:BotPrint(bot, "meleeCount: "..meleeCount..", rangedCount: "..rangedCount..", sum: "..sum)

    return (sum >= requirement)
end

function HasBaseDefences(bot)
    local hero = bot.hero
    local maxTowerLocations = #bot.base.locations.WATCH_TOWER
    local maxWallLocations = #bot.base.locations.WOODEN_WALL

    local towerCount = AI:GetCountFor(bot, "WATCH_TOWER")
    local wallCount = AI:GetCountFor(bot, "WOODEN_WALL")

    local bool = (towerCount == maxTowerLocations and wallCount == maxWallLocations)
    AI:BotPrint(bot, "HasBaseDefences: "..tostring(bool))
    return bool
end

---------------------------------------------------------------------------
-- Construction of buildings.
---------------------------------------------------------------------------
function ConstructTent(bot)
    if AI:ConstructBuildingWrapper(bot, "TENT_SMALL") then
        bot.state = "busy"
        return true
    end
end

function ConstructGoldMine(bot)
    return AI:ConstructBuildingWrapper(bot, "GOLD_MINE")
end

function ConstructBarracks(bot)
    return AI:ConstructBuildingWrapper(bot, "BARRACKS")
end

function ConstructHealingCrystal(bot)
    return AI:ConstructBuildingWrapper(bot, "HEALING_CRYSTAL")
end

function ConstructMarket(bot)
    return AI:ConstructBuildingWrapper(bot, "MARKET")
end

function ConstructWatchTower(bot)
    return AI:ConstructBuildingWrapper(bot, "WATCH_TOWER")
end

function ConstructWoodenWall(bot)
    return AI:ConstructBuildingWrapper(bot, "WOODEN_WALL")
end

function ConstructBaseDefences(bot)
    local hero = bot.hero

    local maxTowerLocations = #bot.base.locations.WATCH_TOWER
    local maxWallLocations = #bot.base.locations.WOODEN_WALL
    local towerCount = AI:GetCountFor(bot, "WATCH_TOWER") 
    local wallCount = AI:GetCountFor(bot, "WOODEN_WALL")

    local enoughTowers = (towerCount == maxTowerLocations)
    if not enoughTowers then
        AI:BotPrint(bot, "Didn't have enough towers ("..maxTowerLocations.."), building more... (cur: "..towerCount..")")
        return ConstructWatchTower(bot)
    end
    local enoughtWalls = (wallCount == maxWallLocations)
    if not enoughWalls then
        AI:BotPrint(bot, "Didn't have enough walls ("..maxWallLocations.."), buildign more... (cur: "..wallCount..")")
        return ConstructWoodenWall(bot)
    end
    AI:BotPrint(bot, "Had enough towers and walls, but still had to construct more...")
    return false
end

---------------------------------------------------------------------------
-- Training of units.
---------------------------------------------------------------------------

function TrainWorker(bot)
    local unitName = AI:GetWorkerName(bot)
    return AI:TrainUnit(bot, unitName)
end

function TrainMelee(bot)
    local unitName = AI:GetMeleeName(bot)
    return AI:TrainUnit(bot, unitName)
end

function TrainRanged(bot)
    local unitName = AI:GetRangedName(bot)
    return AI:TrainUnit(bot, unitName)
end

function TrainSiege(bot)
    local unitName = AI:GetSiegeName(bot)
    return AI:TrainUnit(bot, unitName)
end

function TrainCaster(bot)
    local unitName = AI:GetCasterName(bot)
    return AI:TrainUnit(bot, unitName)
end
