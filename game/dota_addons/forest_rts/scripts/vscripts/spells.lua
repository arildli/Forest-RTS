

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
