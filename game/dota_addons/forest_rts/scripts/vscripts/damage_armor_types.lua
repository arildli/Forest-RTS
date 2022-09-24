if not DamageArmorTypes then
    DamageArmorTypes = {
        damageMultipliers = {
            srts_armor_type_fortified = {
                srts_damage_type_hero = 0.50,
                srts_damage_type_normal = 0.40,
                srts_damage_type_missile = 0.33,
                srts_damage_type_magic = 0.33,
                srts_damage_type_siege = 2.0,
                srts_damage_type_spear = 1.0
            },

            srts_armor_type_heavy = {
                srts_damage_type_hero = 1.0,
                srts_damage_type_normal = 1.0,
                srts_damage_type_missile = 1.0,
                srts_damage_type_magic = 1.20,
                srts_damage_type_siege = 0.75,
                srts_damage_type_spear = 1.0
            },

            srts_armor_type_medium = {
                srts_damage_type_hero = 1.0,
                srts_damage_type_normal = 1.20,
                srts_damage_type_missile = 1.0,
                srts_damage_type_magic = 1.0,
                srts_damage_type_siege = 0.75,
                srts_damage_type_spear = 1.0
            },
            
            srts_armor_type_light = {
                srts_damage_type_hero = 1.0,
                srts_damage_type_normal = 1.0,
                srts_damage_type_missile = 1.20,
                srts_damage_type_magic = 1.0,
                srts_damage_type_siege = 0.75,
                srts_damage_type_spear = 1.0
            },

            srts_armor_type_unarmored = {
                srts_damage_type_hero = 1.0,
                srts_damage_type_normal = 1.10,
                srts_damage_type_missile = 1.10,
                srts_damage_type_magic = 1.10,
                srts_damage_type_siege = 1.0,
                srts_damage_type_spear = 1.0
            },

            srts_armor_type_hero = {
                srts_damage_type_hero = 1.0,
                srts_damage_type_normal = 0.9,
                srts_damage_type_missile = 0.9,
                srts_damage_type_magic = 0.9,
                srts_damage_type_siege = 0.75,
                srts_damage_type_spear = 1.0
            },

            srts_armor_type_cavalry = {
                srts_damage_type_hero = 1.0,
                srts_damage_type_normal = 1.0,
                srts_damage_type_missile = 1.0,
                srts_damage_type_magic = 1.0,
                srts_damage_type_siege = 1.0,
                srts_damage_type_spear = 2.0
            }
        }
    }

    print("[DamageArmorTypes] Module loaded!")
end

function DamageArmorTypes:HandleAttack(damageValue, attacker, victim, inflictor)
    local victimUnitName = victim:GetUnitName()
    local attackIsAbility = inflictor ~= nil
    local attackType = attacker._attackType or DamageArmorTypes:GetAttackTypeManually(attacker)
    local armorType = victim._armorType or DamageArmorTypes:GetArmorTypeManually(victim)
    local attackerHasSpear = attacker._hasSpear or DamageArmorTypes:HasSpear(attacker)
    local victimIsCavalry = victim._isCavalry or DamageArmorTypes:IsCavalry(victim)

    DamageArmorTypes:DebugPrint("\ndamageValue: " .. damageValue)
    DamageArmorTypes:DebugPrint("victimUnitName: " .. victimUnitName)
    DamageArmorTypes:DebugPrint("attackIsAbility: " .. tostring(attackIsAbility))
    DamageArmorTypes:DebugPrint("attackType: " .. attackType)
    DamageArmorTypes:DebugPrint("armorType: " .. armorType)
    DamageArmorTypes:DebugPrint("attackerHasSpear: " .. tostring(attackerHasSpear))
    DamageArmorTypes:DebugPrint("victimIsCavalry: " .. tostring(victimIsCavalry))

    -- It's an ability if this has a value
    if attackIsAbility then
        attackType = "srts_damage_type_magic"
    end

    -- This can be the case for jungle creeps.
    if attackType == nil then
        DamageArmorTypes:DebugPrint("No attack type -> setting to Normal for unit: " .. attacker:GetUnitName())
        attackType = "srts_damage_type_normal"
    end

    -- This can happen with neutral creeps, so we make them uanarmored.
    if armorType == nil or type(armorType) ~= "string" then
        DamageArmorTypes:DebugPrint("No armor type -> setting to Unarmored")

        armorType = "srts_armor_type_unarmored"
        return damageValue
    end

    local modifiedDamage = DamageArmorTypes:CalculateDamage(damageValue, attackType, armorType, unitName)

    -- We do another round of adjustments if we're dealing with spears against cavalry
    if attackerHasSpear and victimIsCavalry then
        DamageArmorTypes:DebugPrint("Spear vs. Cavalry")

        modifiedDamage = modifiedDamage * 
            DamageArmorTypes:CalculateDamage(modifiedDamage, attackType, armorType, unitName)
    end

    DamageArmorTypes:DebugPrint("Before: " .. damageValue)
    DamageArmorTypes:DebugPrint("After: " .. modifiedDamage)

    return modifiedDamage
end

-- In case of errors we just return the original damage value to not mess things up too much.
function DamageArmorTypes:CalculateDamage(damageValue, attackType, armorType, victimUnitName)
    local armorTypeModifierValues = DamageArmorTypes.damageMultipliers[armorType]
    if armorTypeModifierValues == nil then
        --print("[DamageArmorTypes] Error: Couldn't find armorType '" .. armorType .. " in the table!")
        return damageValue
    end

    local damageModifier = armorTypeModifierValues[attackType]
    if damageModifier == nil then
        --print("[DamageArmorTypes] Error: Couldn't find attackType '" .. attackType .. " in the table!")
        return damageValue
    end

    return damageValue * damageModifier
end

function DamageArmorTypes:GetAttackTypeManually(attacker)
    local attackType = nil

    if attacker:HasAbility("srts_damage_type_hero") then
        attackType = "srts_damage_type_hero"
    elseif attacker:HasAbility("srts_damage_type_normal") then
        attackType = "srts_damage_type_normal"
    elseif attacker:HasAbility("srts_damage_type_missile") then
        attackType = "srts_damage_type_missile"
    elseif attacker:HasAbility("srts_damage_type_magic") then
        attackType = "srts_damage_type_magic"
    elseif attacker:HasAbility("srts_damage_type_siege") then
        attackType = "srts_damage_type_siege"
    elseif attacker:HasAbility("srts_damage_type_spear") then
        attackType = "srts_damage_type_spear"
    end

    if attackType ~= nil then
        DamageArmorTypes:DebugPrint("[DamageArmorTypes] Caching attack type for attacker: " .. attacker:GetUnitName() .. " = " .. attackType)

        attacker._attackType = attackType
        return attackType
    end

    DamageArmorTypes:DebugPrint("[DamageArmorTypes] Couldn't find damage modifier...")

    return ""
end

function DamageArmorTypes:GetArmorTypeManually(victim)
    local armorType = nil

    if victim:HasAbility("srts_armor_type_fortified") then
        armorType = "srts_armor_type_fortified"
    elseif victim:HasAbility("srts_armor_type_heavy") then
        armorType = "srts_armor_type_heavy"
    elseif victim:HasAbility("srts_armor_type_medium") then
        armorType = "srts_armor_type_medium"
    elseif victim:HasAbility("srts_armor_type_light") then
        armorType = "srts_armor_type_light"
    elseif victim:HasAbility("srts_armor_type_unarmored") then
        armorType = "srts_armor_type_unarmored"
    elseif victim:HasAbility("srts_armor_type_hero") then
        armorType = "srts_armor_type_hero"
    end

    if armorType ~= nil then
        DamageArmorTypes:DebugPrint("[DamageArmorTypes] Caching armor type for victim: " .. victim:GetUnitName() .. " = " .. armorType)

        victim._armorType = armorType
        return armorType
    end

    DamageArmorTypes:DebugPrint("[DamageArmorTypes] Couldn't find armor modifier...")

    return ""
end

function DamageArmorTypes:HasSpear(unit)
    return unit:HasAbility("srts_damage_type_spear")
end

function DamageArmorTypes:IsCavalry(unit)
    return unit:HasAbility("srts_armor_type_cavalry")
end

function DamageArmorTypes:DebugPrint(input)
    if DEBUG_DAMAGE_ARMOR_TYPES then
        print("[DamageArmorTypes] " .. input)
    end
end