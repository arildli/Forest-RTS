


if not Stats then
    Stats = {}
end

function Stats:Init()
    Stats.players = {}
    Stats.game = {}
end

function Stats:AddPlayer(hero, player, playerID)
    if not Stats.players then Stats:Init() end
    Stats.players[playerID] = {
        heroname = GetHeroConst(hero:GetUnitName()),
        herolevel = hero:GetLevel(),

        trainedTotal = 0,
        constructedTotal = 0,
        unitsLostTotal = 0,
        buildingsLostTotal = 0,
        unitsKilledTotal = 0,
        buildingDestroyedTotal = 0,
        upgradesResearchedTotal = 0,

        trained = {},
        constructed = {},
        unitsLost = {},
        buildingsLost = {},
        upgradesResearched = {},

        goldGained = 0,
        goldSpent = 0,
        lumberGained = 0,
        lumberSpent = 0
    }
end

function Stats:GetPlayer(playerID)
    return Stats.players[playerID]
end

function Stats:OnLevelUp(playerID, newLevel)
    local player = Stats:GetPlayer(playerID)
    if not player then return end
    player.herolevel = newLevel
end



function Stats:OnTrained(playerID, unit, enttype)
    local player = Stats:GetPlayer(playerID)
    if not player then return end
   
    local entName = unit:GetUnitName()
    if enttype == "unit" then
        player.trainedTotal = player.trainedTotal + 1
        player.trained[entName] = (player.trained[entName] or 0) + 1
    elseif enttype == "building" then
        player.constructedTotal = player.constructedTotal + 1
        player.constructed[entName] = (player.constructed[entName] or 0) + 1
    end
end

function Stats:OnDeath(playerID, killerID, unit, enttype)
    local owner = Stats:GetPlayer(playerID)
    if not player then return end
    local killer = Stats:GetPlayer(killerID)

    local entName = unit:GetUnitName()
    if enttype == "unit" then
        owner.unitsLostTotal = owner.unitsLostTotal + 1
        owner.unitsLost[entName] = (owner.unitsLost[entName] or 0) + 1
        if killer then killer.unitsKilledTotal = killer.unitsKilledTotal + 1 end
    elseif enttype == "building" then
        owner.buildingsLostTotal = owner.buildingsLostTotal + 1
        owner.buildingsLost[entName] = (owner.buildingsLost[entName] or 0) + 1
        if killer then killer.buildingsDestroyedTotal = killer.buildingsDestroyedTotal + 1 end
    end
end

function Stats:OnDeathNeutral(killerID, killedUnit)
    local killer = Stats:GetPlayer(killerID)
    if not killer then return end
    killer.unitsKilledTotal = killer.unitsKilledTotal + 1
end

function Stats:OnResearchFinished(playerID, abilityName)
    local player = Stats:GetPlayer(playerID)
    if not player then return end

    player.upgradesResearchedTotal = player.upgradesResearchedTotal + 1
    player.upgradesResearched[abilityName] = (player.upgradesResearched[abilityName] or 0) + 1
end



function Stats:AddGold(playerID, gold)
    local player = Stats:GetPlayer(playerID)
    player.goldGained = player.goldGained + gold
end

function Stats:SpendGold(playerID, gold)
    local player = Stats:GetPlayer(playerID)
    player.lumberSpent = player.lumberSpent - gold
end

function Stats:AddLumber(playerID, lumber)
    local player = Stats:GetPlayer(playerID)
    player.lumberGained = player.lumberGained + lumber
end

function Stats:SpendLumber(playerID, lumber)
    local player = Stats:GetPlayer(playerID)
    player.lumberSpent = player.lumberSpent - lumber
end



function Stats:PrintStatsAll()
    --DeepPrintTable(Stats.players)
    function PrintTable(table, indent)
        local prefix = ""
        for i=0,indent do
            prefix = prefix .. "\t"
        end
        for k,v in pairs(table) do
            if type(v) == "string" or type(v) == "number" then
                print(prefix..k.." = "..v)
            elseif type(v) == "bool" then
                print(prefix..k.." = "..tostring(bool))
            elseif type(v) == "table" then
                PrintTable(v, indent + 1)
            end
        end
    end
    PrintTable(Stats, 0)
end