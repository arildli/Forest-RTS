
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

function HasBarracks(bot)
    local bool = AI:HasEntity(bot, "BARRACKS")
    return bool
end

function HasMiniForce(bot)
    local hero = bot.hero
    local meleeName = AI:GetMeleeName(bot)
    local rangedName = AI:GetRangedName(bot)

    local meleeCount = hero:GetUnitCountFor(meleeName)
    local rangedCount = hero:GetUnitCountFor(rangedName)
    local sum = meleeCount + rangedCount
    local requirement = 5

    AI:BotPrint(bot, "meleeCount: "..meleeCount..", rangedCount: "..rangedCount..", sum: "..sum)

    return (sum >= requirement)
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
    if AI:ConstructBuildingWrapper(bot, "GOLD_MINE") then
        bot.state = "constructing"
        return true
    end
end

function ConstructBarracks(bot)
    if AI:ConstructBuildingWrapper(bot, "BARRACKS") then
        bot.state = "constructing"
        return true
    end
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
