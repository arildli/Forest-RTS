


if not Stats then
    Stats = {}
end

--[=[
To add:
- | | Time when last player left the game.
- |x| Current game mode.
- |x| Workers killed and trained.
]=]

function Stats:Init()
    Stats.players = {}
    Stats.game = {
        mode = "Patrols"
    }
end

function Stats:SetGameMode(mode)
    Stats.game.mode = mode
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
        buildingsDestroyedTotal = 0,
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
    if not owner then return end
    local killer = Stats:GetPlayer(killerID)

    local entName = unit:GetUnitName()
    if enttype == "unit" then
        owner.unitsLostTotal = owner.unitsLostTotal + 1
        owner.unitsLost[entName] = (owner.unitsLost[entName] or 0) + 1
        if killer then killer.unitsKilledTotal = killer.unitsKilledTotal + 1 end
    elseif enttype == "building" then
        owner.buildingsLostTotal = owner.buildingsLostTotal + 1
        owner.buildingsLost[entName] = (owner.buildingsLost[entName] or 0) + 1
        if killer and killerID ~= playerID then killer.buildingsDestroyedTotal = killer.buildingsDestroyedTotal + 1 end
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
    print("Stats: "..gold.." GOLD added!")
    local player = Stats:GetPlayer(playerID)
    player.goldGained = player.goldGained + gold
end

function Stats:SpendGold(playerID, gold)
    print("Stats: "..gold.." GOLD SPENT!")
    local player = Stats:GetPlayer(playerID)
    player.goldSpent = player.goldSpent + gold
end

function Stats:AddLumber(playerID, lumber)
    print("Stats: "..lumber.." LUMBER added!")
    local player = Stats:GetPlayer(playerID)
    player.lumberGained = player.lumberGained + lumber
end

function Stats:SpendLumber(playerID, lumber)
    print("Stats: "..lumber.." LUMBER SPENT!")
    local player = Stats:GetPlayer(playerID)
    player.lumberSpent = player.lumberSpent + lumber
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
                print(prefix..k.." = {")
                PrintTable(v, indent + 1)
                print(prefix.." }")
            end
        end
    end
    PrintTable(Stats, 0)
end



-- Useful when using the collected stats.

function Stats:GetUnitTypeTrained(playerID, unitType)
    local player = Stats:GetPlayer(playerID)
    if not player then return nil end

    local unitName = entities[player.heroname][unitType].name
    return player.trained[unitName] or 0
end

function Stats:GetMeleeTrained(playerID)
    return Stats:GetUnitTypeTrained(playerID, "MELEE")
end

function Stats:GetRangedTrained(playerID)
    return Stats:GetUnitTypeTrained(playerID, "RANGED")
end

function Stats:GetCasterTrained(playerID)
    return Stats:GetUnitTypeTrained(playerID, "CASTER")
end

function Stats:GetSiegeTrained(playerID)
    return Stats:GetUnitTypeTrained(playerID, "SIEGE")
end



function Stats:GetUnitTypeLost(playerID, unitType)
    local player = Stats:GetPlayer(playerID)
    if not player then return nil end

    local unitName = entities[player.heroname][unitType].name
    return player.unitsLost[unitName] or 0
end

function Stats:GetMeleeLost(playerID)
    return Stats:GetUnitTypeLost(playerID, "MELEE")
end

function Stats:GetRangedLost(playerID)
    return Stats:GetUnitTypeLost(playerID, "RANGED")
end

function Stats:GetCasterLost(playerID)
    return Stats:GetUnitTypeLost(playerID, "CASTER")
end

function Stats:GetSiegeLost(playerID)
    return Stats:GetUnitTypeLost(playerID, "SIEGE")
end