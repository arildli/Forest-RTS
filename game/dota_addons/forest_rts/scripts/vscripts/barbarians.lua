

if not Barbarians then
    Barbarians = {
        SCOUT = "npc_dota_creature_barbarian_scout",

        camps = {},
        spawnPoints = {
            Vector(6944, -7264, 512)
        }
    }

    Barbarians.waves = {
        {{name=Barbarians.SCOUT, count=1}}
    }

    Convars:RegisterCommand('bnext', function()
        print("[Barbarians] Spawning the next wave...")
        for _,camp in pairs(Barbarians.camps) do
            camp:NextWave()
        end
    end, 'Spawn the next barbarian wave', FCVAR_CHEAT)

    Convars:RegisterCommand('binfo', function()
        print("[Barbarians] Printing info about camps:")
        for _,camp in pairs(Barbarians.camps) do
            print("Camp: ")
            print("----------")
            print("\twaveNumber: "..camp.waveNumber)
            print("\tmaxWave: "..#Barbarians.waves)
            print("\tspawnPoint: "..tostring(camp.spawnPoint))
            print()
        end
    end, 'Spawn the next barbarian wave', FCVAR_CHEAT)
end

function Barbarians:Init()
    local camp = {
        waveNumber = 1,
        spawnPoint = Barbarians.spawnPoints[1]
    }

    Barbarians.camps[#Barbarians.camps] = camp

    function camp:NextWave()
        local maxWave = #Barbarians.waves
        local curWave = camp.waveNumber

        if curWave >= maxWave then
            curWave = maxWave
        end

        print("[Barbarians] Spawning wave "..curWave)
        for _,entry in pairs(Barbarians.waves[curWave]) do
            print("\tunitName: "..entry.name..", count: "..entry.count)
        end
    end
end
