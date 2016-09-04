
function AI:IdleHeroAction(bot)
    local hero = bot.hero
    if not hero:IsChanneling() and not hero:HasItemInInventory("item_stack_of_lumber") then
        AI:HarvestLumber(bot, hero)
    end
end

---------------------------------------------------------------------------
-- Predicates for military checks.
---------------------------------------------------------------------------

function IsBaseSafe(bot)
    return (bot.underAttackTimer <= 0)
end

---------------------------------------------------------------------------
-- Military actions.
---------------------------------------------------------------------------

function DefendBase(bot)
    if bot.state ~= "defending_own_base" then
        bot.state = "defending_own_base"
        AI:BotPrint(bot, "Moving to defend own base!")
    end

    local buildings = AI:GetAllBuildings(bot)
    local radius = bot.detectEnemyNearBaseRadius
    for _,building in pairs(buildings) do
        local location = building:GetAbsOrigin()
        local nearbyEnemyUnits = FindUnitsInRadius(bot.team, location, nil, radius, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
            0, FIND_ANY_ORDER, false)
        local nearbyEnemiesCount = #nearbyEnemyUnits
        if nearbyEnemiesCount > 0 then
            AI:BotPrint(bot, nearbyEnemiesCount.." enemies near a "..building:GetUnitName())
        end
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

function HasArmory(bot)
    return AI:HasEntity(bot, "ARMORY")
end

function HasLightDamage(bot)
    local armory = AI:GetBuilding(bot, "ARMORY")
    return (AI:GetUpgradeLevel(bot, "UPGRADE_LIGHT_DAMAGE") > 0) or (armory and armory:IsChanneling())
end

function HasLightArmor(bot)
    local armory = AI:GetBuilding(bot, "ARMORY")
    return (AI:GetUpgradeLevel(bot, "UPGRADE_LIGHT_ARMOR") > 0) or (armory and armory:IsChanneling())
end

function HasDoubleBarracks(bot)
    return AI:HasAtLeast(bot, "BARRACKS", 2)
end

function HasUpgradedTent(bot)
    local tentLarge = AI:GetBuilding(bot, "TENT_LARGE")
    return (tentLarge ~= nil)
end

function HasBarracksAdvanced(bot)
    return AI:HasEntity(bot, "BARRACKS_ADVANCED")
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
    return (sum >= bot.miniForce*bot.multiplier)
end

function HasBaseDefences(bot)
    local hero = bot.hero
    local maxTowerLocations = #bot.base.locations.WATCH_TOWER
    local maxWallLocations = #bot.base.locations.WOODEN_WALL

    local towerCount = AI:GetCountFor(bot, "WATCH_TOWER")
    local wallCount = AI:GetCountFor(bot, "WOODEN_WALL")

    return (towerCount == maxTowerLocations and wallCount == maxWallLocations)
end

function HasTowerDefenders(bot)
    local towers = AI:GetCertainBuildings(bot, "WATCH_TOWER")
    for k,tower in pairs(towers) do
        if AI:IsTowerEmpty(bot, tower) then
            return false
        end
    end
    return true
end

function HasMixedForce(bot)
    local towerUnitCount = AI:GetTowerUnitsCount(bot)
    return (AI:HasAtLeast(bot, "MELEE", bot.mixedMinimumEach*bot.multiplier) and
            AI:HasAtLeast(bot, "RANGED", bot.mixedMinimumEach*bot.multiplier + towerUnitCount))
end

function HasBasicSiege(bot)
    local siegeCount = AI:GetCountFor(bot, "SIEGE")
    return (siegeCount >= bot.basicSiege)
end

function HasDecentForce(bot)
    local meleeCount = AI:GetCountFor(bot, "MELEE")
    local rangedCount = AI:GetCountFor(bot, "RANGED")
    local casterCount = AI:GetCountFor(bot, "CASTER")
    local siegeCount = AI:GetCountFor(bot, "SIEGE")

    AI:BotPrint(bot, "Basic: "..tostring(meleeCount + rangedCount >= bot.decentForceBasicUnits*bot.multiplier).." ("..meleeCount + rangedCount.."/"..bot.decentForceBasicUnits*bot.multiplier..")")
    AI:BotPrint(bot, "Full: "..tostring(meleeCount + rangedCount + casterCount + siegeCount >= bot.decentForceLeastTotal*bot.multiplier).." ("..meleeCount + rangedCount + casterCount + siegeCount.."/"..bot.decentForceLeastTotal*bot.multiplier..")")

    return (meleeCount + rangedCount >= bot.decentForceBasicUnits*bot.multiplier) and
           (meleeCount + rangedCount + casterCount + siegeCount >= bot.decentForceLeastTotal*bot.multiplier)
end

function HasBasicCasters(bot)
    local casterCount = AI:GetCountFor(bot, "CASTER")
    return (casterCount >= bot.basicCasters)
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

function ConstructArmory(bot)
    return AI:ConstructBuildingWrapper(bot, "ARMORY")
end

function ConstructBarracksAdvanced(bot)
    return AI:ConstructBuildingWrapper(bot, "BARRACKS_ADVANCED")
end

function ConstructBaseDefences(bot)
    local maxTowerLocations = #bot.base.locations.WATCH_TOWER
    local maxWallLocations = #bot.base.locations.WOODEN_WALL
    local towerCount = AI:GetCountFor(bot, "WATCH_TOWER") 
    local wallCount = AI:GetCountFor(bot, "WOODEN_WALL")

    local enoughTowers = (towerCount == maxTowerLocations)
    if not enoughTowers then
        return ConstructWatchTower(bot)
    end
    local enoughtWalls = (wallCount == maxWallLocations)
    if not enoughWalls then
        return ConstructWoodenWall(bot)
    end
    return false
end

function ResearchLightDamage(bot)
    return AI:Research(bot, "UPGRADE_LIGHT_DAMAGE", "ARMORY")
end

function ResearchLightArmor(bot)
    return AI:Research(bot, "UPGRADE_LIGHT_ARMOR", "ARMORY")
end

function UpgradeSmallTent(bot)
    return AI:Research(bot, "TENT_LARGE", "TENT_SMALL")
end

function FillTowers(bot)
    local rangedUnits = AI:GetCertainUnits(bot, "RANGED")
    if not rangedUnits or #rangedUnits == 0 then
        TrainRanged(bot)
        return false
    end
    for k,unit in pairs(rangedUnits) do
        if not AI:IsUnitInside(bot, unit) and unit.AI.state == "idle" then
            local emptyTower = AI:GetEmptyTower(bot)
            if emptyTower then
                AI:EnterTower(bot, unit, emptyTower)
                emptyTower._occupied = true
                unit._enteringTower = true
            else
                break
            end
        end
    end
    local emptyTower = AI:GetEmptyTower(bot)
    if emptyTower then
        TrainRanged(bot)
        return false
    end
    return true
end

function TrainMixedForce(bot)
    local towerUnitCount = AI:GetTowerUnitsCount(bot)
    if not AI:HasAtLeast(bot, "MELEE", bot.mixedMinimumEach*bot.multiplier) then
        TrainMelee(bot)
        return false
    elseif not AI:HasAtLeast(bot, "RANGED", bot.mixedMinimumEach*bot.multiplier + towerUnitCount) then
        TrainRanged(bot)
        return false
    end
    return true
end

function TrainBasicSiege(bot)
    TrainSiege(bot)
end

function TrainBasicCasters(bot)
    TrainCaster(bot)
end


function TrainDecentForce(bot)
    local decentForceBasicMin = bot.decentForceBasicUnits*bot.multiplier
    local meleeCount = AI:GetCountFor(bot, "MELEE")
    local rangedCount = AI:GetCountFor(bot, "RANGED")
    local siegeCount = AI:GetCountFor(bot, "SIEGE")
    local casterCount = AI:GetCountFor(bot, "CASTER")
    local basicUnitsCount = meleeCount + rangedCount
    local totalCount = meleeCount + rangedCount + siegeCount + casterCount
    if meleeCount < decentForceBasicMin/2 then
        TrainMelee(bot)
    end
    if rangedCount < decentForceBasicMin/2 then
        TrainRanged(bot)
    end
    if siegeCount < bot.basicSiege then
        AI:TrainSiege(bot)
    end
    if totalCount < bot.decentForceLeastTotal*bot.multiplier then
        TrainMelee(bot)
    end
    return true
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




