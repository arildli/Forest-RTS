
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
    AI:BotPrint(bot, "Constructing Main Tent")
    if AI:ConstructBuildingWrapper(bot, "TENT_SMALL") then
        bot.state = "busy"
        return true
    end
end

function ConstructGoldMine(bot)
    AI:BotPrint(bot, "Constructing Gold Mine")
    if AI:ConstructBuildingWrapper(bot, "GOLD_MINE") then
        bot.state = "constructing"
        return true
    end
end

function ConstructBarracks(bot)
    AI:BotPrint(bot, "Constructing Barracks")
    if AI:ConstructBuildingWrapper(bot, "BARRACKS") then
        bot.state = "constructing"
        return true
    end
end

function TrainWorker(bot)
    AI:BotPrint(bot, "Training Worker")
    local unitName = AI:GetWorkerName(bot)
    return AI:TrainUnit(bot, unitName)
end

function TrainMelee(bot)
    AI:BotPrint(bot, "Training Melee")
    local unitName = AI:GetMeleeName(bot)
    return AI:TrainUnit(bot, unitName)
end

function TrainRanged(bot)
    AI:BotPrint(bot, "Training Ranged")
    local unitName = AI:GetRangedName(bot)
    return AI:TrainUnit(bot, unitName)
end

function TrainSiege(bot)
    AI:BotPrint(bot, "Training Siege")
    local unitName = AI:GetSiegeName(bot)
    return AI:TrainUnit(bot, unitName)
end

function TrainCaster(bot)
    AI:BotPrint(bot, "Training Caster")
    local unitName = AI:GetCasterName(bot)
    return AI:TrainUnit(bot, unitName)
end
