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

    if ability:GetAutoCastState() and ability:IsFullyCastable() and 
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

function AutocastAllyAttack(ability, caster, modifier, attacker)
    if not attacker:IsMagicImmune() and ability:GetAutoCastState() and ability:IsFullyCastable()
      and not caster:IsSilenced() then
        if attacker._recentlyBuffed then
            return
        elseif not attacker:HasModifier(modifier) then
            attacker._recentlyBuffed = true
            Timers:CreateTimer({
                endTime = 1.0,
                callback = function()
                    attacker._recentlyBuffed = nil
            end})
            caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
            caster:CastAbilityOnTarget(attacker, ability, caster:GetPlayerOwnerID())
            ability:PayManaCost()
        end
    end
end

function AutocastAllyAttackKeys(keys)
    AutocastAllyAttack(keys.ability, keys.caster, keys.modifier, keys.attacker)
end


function AutocastAllyAttacked(ability, caster, modifier, target)
    if not target:IsMagicImmune() and ability:GetAutoCastState() and ability:IsFullyCastable()
      and not caster:IsSilenced() then
        if target._recentlyBuffed then
            return
        elseif not target:HasModifier(modifier) then
            target._recentlyBuffed = true
            Timers:CreateTimer({
                endTime = 1.0,
                callback = function()
                    target._recentlyBuffed = nil
            end})
            caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
            caster:CastAbilityOnTarget(target, ability, caster:GetPlayerOwnerID())
            ability:PayManaCost()
        end
    end
end

function AutocastAllyAttackedKeys(keys)
    AutocastAllyAttacked(keys.ability, keys.caster, keys.modifier, keys.target)
end


function CurseAutocast(keys)
    Autocast(keys.ability, keys.caster, keys.modifier, DOTA_UNIT_TARGET_TEAM_ENEMY,
        "Both", "Any")
end


function SlowAutocast(keys)
    Autocast(keys.ability, keys.caster, keys.modifier, DOTA_UNIT_TARGET_TEAM_ENEMY,
        "Both", "Any")
end
