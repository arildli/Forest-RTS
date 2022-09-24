if not NeutralBasesDefinitions then
    NeutralBasesDefinitions = {}
end

function NeutralBasesDefinitions:Init()
    NeutralBasesDefinitions:AddMiddleLumberCamp()
    NeutralBasesDefinitions:AddMiddleEastBase()
end

function NeutralBasesDefinitions:AddMiddleLumberCamp()
    -- Temp setup
    local middleCamp = Neutrals:CreateCamp(Vector(-230, -1536, 384), "Middle Lumber Camp", true)

    -- Right-Top tower
    local curVector = Vector(736, -480, 384)
    Neutrals:CreateTower(curVector, true, middleCamp, Neutrals.ARCHER, true)
    Neutrals:SpawnGuard(Neutrals.BRUTE, Vector(576, -64, 384), middleCamp, DOTA_TEAM_NEUTRALS, true, false)
    Neutrals:SpawnGuard(Neutrals.BRUTE, Vector(576, -384, 384), middleCamp, DOTA_TEAM_NEUTRALS, true, false)
    local bannerRightTop = Neutrals:CreateBuilding("npc_dota_building_prop_banner_owner", Vector(960, -448, 255), true, middleCamp, nil, true)
    Neutrals:MakeGloballyVisible(bannerRightTop)

    -- Right-Bottom tower
    curVector = Vector(864, -1504, 384)
    Neutrals:CreateTower(curVector, true, middleCamp, Neutrals.ARCHER, true)
    local curUnit = Neutrals:SpawnGuard(Neutrals.BRUTE, Vector(384, -1728, 384), middleCamp, DOTA_TEAM_NEUTRALS, true, false, 5)
    --Neutrals:RotateLeft(curUnit, 5)
    curUnit = Neutrals:SpawnGuard(Neutrals.BRUTE, Vector(704, -1728, 384), middleCamp, DOTA_TEAM_NEUTRALS, true, false, 5)
    --Neutrals:RotateLeft(curUnit, 5)
    local bannerBottom = Neutrals:CreateBuilding("npc_dota_building_prop_banner_owner", Vector(832, -1664, 384), true, middleCamp, nil, true)
    Neutrals:RotateLeft(bannerBottom, 5)
    Neutrals:MakeGloballyVisible(bannerBottom)

    -- Left tower
    curVector = Vector(-1120, -1312, 384)
    Neutrals:CreateTower(curVector, true, middleCamp, Neutrals.ARCHER, true)
    local curUnit = Neutrals:SpawnGuard(Neutrals.BRUTE, Vector(-896, -896, 384), middleCamp, DOTA_TEAM_NEUTRALS, true, false, 3)
    --Neutrals:RotateLeft(curUnit, 3)
    curUnit = Neutrals:SpawnGuard(Neutrals.BRUTE, Vector(-896, -1216, 384), middleCamp, DOTA_TEAM_NEUTRALS, true, false, 3)
    --Neutrals:RotateLeft(curUnit, 3)
    local bannerLeft = Neutrals:CreateBuilding("npc_dota_building_prop_banner_owner", Vector(-1280, -1344, 384), true, middleCamp, nil, true)
    Neutrals:RotateLeft(bannerLeft, 3)
    Neutrals:MakeGloballyVisible(bannerLeft)

    -- Market
    local market = Neutrals:CreateBuilding("npc_dota_building_market", Vector(-320, -1536, 384), true, middleCamp, nil, true)
    local curUnit = Neutrals:SpawnGuard(Neutrals.BRUTE, Vector(-256, -1280, 384), middleCamp, DOTA_TEAM_NEUTRALS, true, false, 5)
    --Neutrals:RotateLeft(curUnit, 5)
    Neutrals:RotateLeft(market, 3)
    
    -- Workers
    local workers = {
        Neutrals:SpawnWorker(Vector(256, -1024, 384), market, middleCamp, true, true),
        Neutrals:SpawnWorker(Vector(64, -1216, 384), market, middleCamp, true, true)
    }
end

function NeutralBasesDefinitions:AddMiddleEastBase()
    -- Coordinates
    local troopLocation = Vector(3808, -1824, 128)
    local tentLocation = Vector(3488, -2976, 128)
    local barracksLocation = Vector(3520, -3328, 128)

    -- West side
    local westTowerNorthLocation = Vector(2720, -3360, 128)
    local westPalisadeNorthLocation = Vector(2656, -3552, 128)
    local westPalisadeSouthLocation = Vector(2656, -3936, 128)
    local westTowerSouthLocation = Vector(2720, -4128, 128)

    local westGuard1Location = Vector(3072, -3904, 128)
    local westGuard2Location = Vector(3072, -3904, 128)

    local worker1Location = Vector(3712, -2688, 128)
    local worker2Location = Vector(3456, -2688, 128)
    local worker3Location = Vector(3264, -2944, 128)
    
    -- North side
    local northTowerEastLocation = Vector(4448, -2272, 128)
    local northPalisadeWestLocation = Vector(4064, -2272, 128)
    local northPalisadeEastLocation = Vector(4256, -2272, 128)
    local northTowerWestLocation = Vector(3872, -2272, 128)

    local northGuard1Location = Vector(4096, -2496, 128)
    local northGuard2Location = Vector(4288, -2496, 128)

    -- Setup
    -- Camp
    local camp = Neutrals:CreateCamp(tentLocation, "Middle East Base", false)

    -- West side
    Neutrals:CreateTower(westTowerNorthLocation, false, camp, Neutrals.ARCHER, false)
    local westPalisadeNorth = Neutrals:CreateBuilding(Neutrals.WOODEN_WALL, westPalisadeNorthLocation, false, camp, nil, false)
    Neutrals:RotateLeft(westPalisadeNorth, 3)
    local westPalisadeSouth = Neutrals:CreateBuilding(Neutrals.WOODEN_WALL, westPalisadeSouthLocation, false, camp, nil, false)
    Neutrals:RotateLeft(westPalisadeSouth, 3)
    Neutrals:CreateTower(westTowerSouthLocation, false, camp, Neutrals.ARCHER, false)

    Neutrals:SpawnGuard(Neutrals.BRUTE, westGuard1Location, camp, DOTA_TEAM_NEUTRALS, false, false, 3)
    Neutrals:SpawnGuard(Neutrals.BRUTE, westGuard2Location, camp, DOTA_TEAM_NEUTRALS, false, false, 3)

    -- North side
    Neutrals:CreateTower(northTowerEastLocation, false, camp, Neutrals.ARCHER, false)
    local northPalisadeWest = Neutrals:CreateBuilding(Neutrals.WOODEN_WALL, northPalisadeWestLocation, false, camp, nil, false)
    Neutrals:RotateLeft(northPalisadeWest, 1)
    local northPalisadeEast = Neutrals:CreateBuilding(Neutrals.WOODEN_WALL, northPalisadeEastLocation, false, camp, nil, false)
    Neutrals:RotateLeft(northPalisadeEast, 1)
    Neutrals:CreateTower(northTowerWestLocation, false, camp, Neutrals.ARCHER, false)

    Neutrals:SpawnGuard(Neutrals.ARCHER, northGuard1Location, camp, DOTA_TEAM_NEUTRALS, false, false, 3)
    Neutrals:SpawnGuard(Neutrals.ARCHER, northGuard2Location, camp, DOTA_TEAM_NEUTRALS, false, false, 3)

    -- Inside base
    local tent = Neutrals:CreateBuilding(Neutrals.SMALL_TENT, tentLocation, false, camp, nil, false)
    local barracks = Neutrals:CreateBuilding(Neutrals.BARRACKS, barracksLocation, false, camp, nil, false)

    -- Workers
    local workers = {
        Neutrals:SpawnWorker(worker1Location, tent, camp, false, false),
        Neutrals:SpawnWorker(worker2Location, tent, camp, false, false),
        Neutrals:SpawnWorker(worker3Location, tent, camp, false, false)
    }
end