

if not Barbarians then
    -- Globals and constants for the module.
    Barbarians = {
        SCOUT = "npc_dota_creature_barbarian_scout",
        AXE_FIGHTER = "npc_dota_creature_barbarian_axe_fighter",
        RAIDER = "npc_dota_creature_barbarian_raider",
        CATAPULT = "npc_dota_creature_catapult_radiant",

        camps = {},
        mainCamp = nil,
        attackUpdateInterval = 1,
        defaultSpawnStart = 120,
        defaultSpawnRate = 60,
        spawnPoints = {
            Vector(6944, -7264, 512)
        },
        playerMainBuildings = {}
    }

    Barbarians.waves = {
        {{name=Barbarians.SCOUT, count=1}},
        {{name=Barbarians.SCOUT, count=2}},
        {{name=Barbarians.AXE_FIGHTER, count=2}},
        {
            {name=Barbarians.AXE_FIGHTER, count=3},
            {name=Barbarians.SCOUT, count=2}
        },
        {
            {name=Barbarians.AXE_FIGHTER, count=5}
        },
        {
            {name=Barbarians.RAIDER, count=3},
            {name=Barbarians.CATAPULT, count=1}
        }
    }
end

---------------------------------------------------------------------------
-- Initialize the Barbarians module.
---------------------------------------------------------------------------
function Barbarians:Init()
    print("[Barbarians] Initializing module...")

    Barbarians.mainCamp = Barbarians:CreateCamp(Barbarians.spawnPoints[1], true, nil, nil, nil)

    --CustomGameEventManager:RegisterListener("construction_done", Dynamic_Wrap(Barbarians, "OnBuildingConstructed"))
    ListenToGameEvent("construction_done", Dynamic_Wrap(Barbarians, "OnBuildingConstructed"), self)

    Convars:RegisterCommand('bnext', function()
        print("[Barbarians] Spawning the next wave...")
        Barbarians:NextWave()
    end, 'Spawn the next barbarian wave', FCVAR_CHEAT)

    Convars:RegisterCommand('binfo', function()
        print("[Barbarians] Printing info about camps:")
        Barbarians:PrintAllCamps()
    end, 'Spawn the next barbarian wave', FCVAR_CHEAT)
end

---------------------------------------------------------------------------
-- Creates a camp and starts spawning.
---------------------------------------------------------------------------
function Barbarians:Start()
    local mainCamp = Barbarians.mainCamp
    local spawnStart = mainCamp.spawnStart
    local spawnRate = mainCamp.spawnRate
    print("Starting wave spawn in "..spawnStart.." seconds!")
    textColor = "#b0171b"
    local notificationString = "<font color='"..textColor.."'>".."Barbarians".."</font> will start spawning in "..spawnStart.." seconds!"
    DisplayMessageToAll(notificationString)

    -- Spawn the waves regularly.
    Timers:CreateTimer(spawnStart, function()
        mainCamp:NextWave()
        return spawnRate
    end)
end

---------------------------------------------------------------------------
-- Creates and returns a new camp object.
--
-- @spawnPoint (Vector): The location where new units will be spawned.
-- @allPlayers (Optional) (Boolean): Specifies whether the camp will spawn
--   units to attack all the players or not.
-- @buildingsInfo (Optional) (Table {buildingName:String, location:Vector}):
--   What buildings the camp will have and where they will be placed
-- @spawnRate (Optional) (Int): How often to spawn new waves. If unset,
--   a default value is used instead.
-- @spawnStart (Optional) (Int): When to start spawning the waves. If unset,
--   a default value is used instead.
-- @return (BarbCamp): The newly created camp object.
---------------------------------------------------------------------------
function Barbarians:CreateCamp(spawnPoint, allPlayers, buildingsInfo, spawnRate, spawnStart)
    spawnPoint = spawnPoint or Barbarians.spawnPoints[1]
    allPlayers = allPlayers or false
    buildingsInfo = buildingsInfo or {}
    spawnRate = spawnRate or Barbarians.defaultSpawnRate
    spawnStart = spawnStart or Barbarians.defaultSpawnStart

    local camp = {
        waveNumber = 1,
        spawnPoint = spawnPoint,
        allPlayers = allPlayers,
        spawnRate = spawnRate,
        spawnStart = spawnStart
    }

    Barbarians.camps[#Barbarians.camps+1] = camp

    ---------------------------------------------------------------------------
    -- Prints information about the camp.
    ---------------------------------------------------------------------------
    function camp:Print()
        local curWave = camp.waveNumber
        print("Camp: ")
        print("----------")
        print("\twaveNumber: "..curWave)
        print("\tmaxWave: "..#Barbarians.waves)
        print("\tspawnPoint: "..tostring(camp.spawnPoint))
        print("\tunits wave "..curWave..":")
        for _,entry in pairs(Barbarians.waves[curWave]) do
            local unitName = entry.name
            local count = entry.count
            print("\t\tUnit: "..unitName.." (count: "..count..")")
        end
        print()
    end

    ---------------------------------------------------------------------------
    -- Spawns and returns a new barbarian unit.
    --
    -- @unitName (String): The name of the unit to spawn.
    -- @location (Vector): The location where the unit will be spawned.
    -- @invulnerable (Optional) (Boolean): Can be set to invulnerable
    --   if specified.
    -- @leftRotations (Optional) (Int): Specifies how many times to rotate 45 deg left.
    -- @return (Unit): The newly spawned unit.
    ---------------------------------------------------------------------------
    function camp:SpawnUnit(unitName, location, invulnerable, leftRotations)
        local newUnit = CreateUnitByName(unitName, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
        newUnit._camp = camp

        if invulnerable then
            newUnit:AddAbility("invulnerable")
            newUnit:FindAbilityByName("invulnerable"):SetLevel(1)
        end
        if leftRotations then
            Barbarians:RotateLeft(newUnit, leftRotations)
        end

        ---------------------------------------------------------------------------
        -- Finds a target building or hero to attack.
        ---------------------------------------------------------------------------
        function newUnit:GetAttackTarget()
            local playerID = newUnit._targetID
            local mainBuilding = Barbarians.playerMainBuildings[playerID]
            local targetPlayerHero = GetPlayerHero(playerID)

            if mainBuilding and not mainBuilding:IsNull() and mainBuilding:IsAlive() then
                return mainBuilding
            end
            return targetPlayerHero
        end

        ---------------------------------------------------------------------------
        -- Attempts to attack target building or hero.
        ---------------------------------------------------------------------------
        function newUnit:AttackTarget()
            local targetID = newUnit._targetID
            local attackTarget = newUnit:GetAttackTarget()

            if attackTarget and not attackTarget:IsNull() and attackTarget:IsAlive() then
                local targetLocation = attackTarget:GetAbsOrigin()
                newUnit:MoveToPositionAggressive(targetLocation)
                --newUnit:MoveToTargetToAttack(attackTarget)
            else
                print("[Barbarians] Nope, target not found!")
            end
        end

        return newUnit
    end

    ---------------------------------------------------------------------------
    -- Spawns the a wave of units for a specific player.
    --
    -- @waveNumber (Int): The index of the wave to use.
    -- @playerID (Int): The ID of the player to send the units to.
    -- @return (Table {Units}): A table of the newly spawned units.
    ---------------------------------------------------------------------------
    function camp:SpawnWave(waveNumber, playerID)
        local unitsSpawned = {}

        for _,entry in pairs(Barbarians.waves[waveNumber]) do
            local unitName = entry.name
            local count = entry.count

            print("\tunitName: "..unitName..", count: "..count)
            for i=1,count do
                local newUnit = camp:SpawnUnit(unitName, spawnPoint)
                newUnit._targetID = playerID
                unitsSpawned[#unitsSpawned+1] = newUnit
            end
        end

        return unitsSpawned
    end

    ---------------------------------------------------------------------------
    -- Spawns the a wave of units for all the players by calling
    -- camp:SpawnWave for each one. Check the description there for more
    -- information.
    ---------------------------------------------------------------------------
    function camp:SpawnWaveAllPlayers(waveNumber)
        local unitsSpawned = {}

        for playerID=0, PlayerResource:GetPlayerCount() do
            local curPlayer = PlayerResource:GetPlayer(playerID)
            if curPlayer then
                print("[Barbarians] Spawning wave number "..waveNumber.." for player "..playerID)
                local newlySpawnedGroup = camp:SpawnWave(waveNumber, playerID)
                for _,unit in pairs(newlySpawnedGroup) do
                    unitsSpawned[#unitsSpawned+1] = unit
                end
            end
        end

        return unitsSpawned
    end

    ---------------------------------------------------------------------------
    -- Spawns the next wave of units for the camp.
    ---------------------------------------------------------------------------
    function camp:NextWave()
        local spawnPoint = camp.spawnPoint
        local allPlayers = camp.allPlayers
        local maxWave = #Barbarians.waves
        local curWave = camp.waveNumber
        local spawnedUnits = {}

        if curWave >= maxWave then
            curWave = maxWave
        end

        if allPlayers then
            spawnedUnits = camp:SpawnWaveAllPlayers(curWave)
        else
            -- Temporarily using playerID 0.
            spawnedUnits = camp:SpawnWave(curWave, 0)
        end

        if curWave < maxWave then
            camp.waveNumber = curWave + 1
        end

        -- Attack the players, and do it regularly in case it moves.
        Timers:CreateTimer(0, function()
            for _,unit in pairs(spawnedUnits) do
                unit:AttackTarget()
            end
            return Barbarians.attackUpdateInterval
        end)
    end

    return camp
end

---------------------------------------------------------------------------
-- Gets called whenever a building has finished construction.
--
-- @keys (Table): A table with information about the construction event.
---------------------------------------------------------------------------
function Barbarians:OnBuildingConstructed(keys)
    local playerID = keys.playerID
    local building = EntIndexToHScript(keys.building)
    local buildingName = building:GetUnitName()

    -- If the building is the main building of a player.
    if string.find(buildingName, "main_tent") then
        Barbarians.playerMainBuildings[playerID] = building
    end
end

---------------------------------------------------------------------------
-- Rotates a building's rotation the specified number of times.
--
-- @building (Building): The building to rotate left.
-- @times (Int): The number of times to rotate the building 45 degrees.
---------------------------------------------------------------------------
function Barbarians:RotateLeft(building, times)
    for i=0,times do
        RotateLeft({caster = building})
    end
end

---------------------------------------------------------------------------
-- Prints information about all the camps.
---------------------------------------------------------------------------
function Barbarians:PrintAllCamps()
    for _,camp in pairs(Barbarians.camps) do
        camp:Print()
    end
end

---------------------------------------------------------------------------
-- Spawns the next wave for all the camps.
---------------------------------------------------------------------------
function Barbarians:NextWave()
    for _,camp in pairs(Barbarians.camps) do
        camp:NextWave()
    end
end
