

function FlipTowerSpell(tower)
   local enterSpellName = "srts_enter_tower"
   local leaveSpellName = "srts_leave_tower"
   local enterSpell = tower:FindAbilityByName(enterSpellName)
   local leaveSpell = tower:FindAbilityByName(leaveSpellName)
   if enterSpell then
      tower:RemoveAbility(enterSpellName)
      tower:AddAbility(leaveSpellName)
      leaveSpell = tower:FindAbilityByName(leaveSpellName)
      leaveSpell:SetLevel(1)
   else
      tower:RemoveAbility(leaveSpellName)
      tower:AddAbility(enterSpellName)
      enterSpell = tower:FindAbilityByName(enterSpellName)
      enterSpell:SetLevel(1)
   end
end

function EnterTower(keys)
   local caster = keys.caster
   local target = keys.target
   local ability = keys.ability
   local modifier = keys.modifier

   if IsBuilding(target) then
      SendErrorMessage(caster:GetPlayerOwnerID(), "#error_target_must_be_unit")
      return
   end
   local towerOrigin = caster:GetOrigin()
   local newUnitOrigin = Vector(towerOrigin.x, towerOrigin.y, towerOrigin.z + 200)
   target:SetOrigin(newUnitOrigin)
   ability:ApplyDataDrivenModifier(caster, target, modifier, {})
   
   target._tower = caster
   caster._inside = target

   FlipTowerSpell(caster)
end

function LeaveTower(keys)
   local caster = keys.caster
   RemoveUnitFromTower(caster)
end

function RemoveUnitFromTower(tower)
   local unit = tower._inside
   if not unit:IsNull() and unit:IsAlive() then
      unit:RemoveModifierByName("modifier_inside_tower_buff")
      unit._tower = nil
      FindClearSpaceForUnit(unit, tower:GetOrigin(), true)
   end
   tower._inside = nil
   FlipTowerSpell(tower)
end

function RemoveIfBuilding(keys) 
   local caster = keys.caster
   local modifier = keys.modifier
   if IsBuilding(caster) then
      caster:RemoveModifierByName(modifier)
   end
end



function HeroAttackSpeedAura(keys)
   local caster = keys.caster
   local target = keys.target
   local ability = keys.ability
   local abilityLevel = ability:GetLevel() - 1
   local modifier = keys.modifier
   local duration = ability.GetLevelSpecialValueFor("think_interval", ability_level)
   local casterOwner = caster:GetPlayerOwner()
   local targetOwner = target:GetPlayerOwner()
   
   print("Come on!")

   if casterOwner == targetOwner then
      ability:ApplyDataDrivenModifier(caster, target, modifier, {Duration = duration})
   end
end
