function Autocast(ability, caster, modifierName, targetTeam, targetType, findType)
    local castRange = ability:GetCastRange()

    local possibleTargetTypes = {
        Basic = DOTA_UNIT_TARGET_BASIC,
        Hero = DOTA_UNIT_TARGET_HERO,
        Both = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
    }
    local possibleFindTypes = {
        Any = FIND_ANY_ORDER,
        Closest = FIND_CLOSEST,
        Farthest = FIND_FARTHEST,
        Everywhere = FIND_UNITS_EVERYWHERE
    }
    targetType = possibleTargetTypes[targetType] or targetType or possibleTargetTypes["Both"]
    findType = possibleFindTypes[findType] or findType or possibleFindTypes["Any"]

    if ability:GetAutoCastState() and ability:IsFullyCastable() and ability:IsOwnersManaEnough() and 
      not caster:IsSilenced() and not caster:IsChanneling() then
        local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 
          castRange, targetTeam, targetType, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, targetType, false)

        local target
        for k,unit in pairs(units) do
            if not unit:HasModifier(modifierName) and not IsCustomBuilding(unit) then
                target = unit
                break
            end
        end

        if target then
            caster:CastAbilityOnTarget(target, ability, caster:GetPlayerOwnerID())
            caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
            ability:PayManaCost()
        end
    end
end


function CurseAutocast(keys)
    Autocast(keys.ability, keys.caster, keys.modifier, DOTA_UNIT_TARGET_TEAM_ENEMY,
        "Both", "Any")
end

function SlowAutocast(keys)
    Autocast(keys.ability, keys.caster, keys.modifier, DOTA_UNIT_TARGET_TEAM_ENEMY,
        "Both", "Any")
end

function FrenzyAutocast(keys)
    Autocast(keys.ability, keys.caster, keys.modifier, DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        "Basic", "Any")
end

function LivingArmorAutocast(keys)
    Autocast(keys.ability, keys.caster, keys.modifier, DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        "Basic", "Any")
end