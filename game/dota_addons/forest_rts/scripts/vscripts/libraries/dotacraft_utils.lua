-- Copied from the DotaCraft repository:
-- https://github.com/MNoya/DotaCraft

-- Returns all visible enemies in radius of the unit/point
function FindEnemiesInRadius( unit, radius, point )
    local team = unit:GetTeamNumber()
    local position = point or unit:GetAbsOrigin()
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
    return FindUnitsInRadius(team, position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
end

-- Returns all units (friendly and enemy) in radius of the unit/point
function FindAllUnitsInRadius( unit, radius, point )
    local team = unit:GetTeamNumber()
    local position = point or unit:GetAbsOrigin()
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    return FindUnitsInRadius(team, position, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, target_type, flags, FIND_ANY_ORDER, false)
end

-- Returns all units in radius of a point
function FindAllUnitsAroundPoint( unit, point, radius )
    local team = unit:GetTeamNumber()
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    return FindUnitsInRadius(team, point, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, target_type, flags, FIND_ANY_ORDER, false)
end

function FindAlliesInRadius( unit, radius, point )
    local team = unit:GetTeamNumber()
    local position = point or unit:GetAbsOrigin()
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE
    return FindUnitsInRadius(team, position, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_CLOSEST, false)
end

-- Filters buildings and mechanical units
function FindOrganicAlliesInRadius( unit, radius, point )
    local team = unit:GetTeamNumber()
    local position = point or unit:GetAbsOrigin()
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE
    local allies = FindUnitsInRadius(team, position, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_CLOSEST, false)
    local organic_allies = {}
    for _,ally in pairs(allies) do
        if not IsBuilding(ally) and not IsMechanical(ally) then
            table.insert(organic_allies, ally)
        end
    end
    return organic_allies
end