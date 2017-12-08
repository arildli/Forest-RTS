

if not Barbarians then
    -- Globals and constants for the module.
    Barbarians = {
        SCOUT = "npc_dota_creature_barbarian_scout",

        camps = {},
        spawnPoints = {
            Vector(6944, -7264, 512)
        }
    }

    Barbarians.waves = {
        {{name=Barbarians.SCOUT, count=1}},
        {{name=Barbarians.SCOUT, count=2}},
        {{name=Barbarians.SCOUT, count=3}}
    }
end

---------------------------------------------------------------------------
-- Initialize the Barbarians module.
---------------------------------------------------------------------------
function Barbarians:Init()
    Barbarians:CreateCamp(Barbarians.spawnPoints[1])

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
-- Creates and returns a new camp object.
--
-- @spawnPoint (Vector): The location where new units will be spawned.
-- @buildingsInfo (Optional) (Table {buildingName:String, location:Vector}):
--   What buildings the camp will have and where they will be placed.
-- @return (BarbCamp): The newly created camp object.
---------------------------------------------------------------------------
function Barbarians:CreateCamp(spawnPoint, buildingsInfo)
    spawnPoint = spawnPoint or Barbarians.spawnPoints[1]
    buildingsInfo = buildingsInfo or {}

    local camp = {
        waveNumber = 1,
        spawnPoint = spawnPoint
    }

    Barbarians.camps[#Barbarians.camps] = camp

    ---------------------------------------------------------------------------
    -- Prints information about the camp.
    ---------------------------------------------------------------------------
    function camp:Print()
        print("Camp: ")
        print("----------")
        print("\twaveNumber: "..camp.waveNumber)
        print("\tmaxWave: "..#Barbarians.waves)
        print("\tspawnPoint: "..tostring(camp.spawnPoint))
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

        return newUnit
    end

    ---------------------------------------------------------------------------
    -- Spawns the next wave of units for the camp.
    ---------------------------------------------------------------------------
    function camp:NextWave()
        local spawnPoint = camp.spawnPoint
        local maxWave = #Barbarians.waves
        local curWave = camp.waveNumber

        if curWave >= maxWave then
            curWave = maxWave
        end

        print("[Barbarians] Spawning wave "..curWave)
        for _,entry in pairs(Barbarians.waves[curWave]) do
            local unitName = entry.name
            local count = entry.count

            print("\tunitName: "..unitName..", count: "..count)
            for i=1,count do
                camp:SpawnUnit(unitName, spawnPoint)
            end
        end

        if curWave < maxWave then
            print("\tIncreasing curWave ("..curWave..") by 1!")
            camp.waveNumber = curWave + 1
        end
    end

    return camp
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
