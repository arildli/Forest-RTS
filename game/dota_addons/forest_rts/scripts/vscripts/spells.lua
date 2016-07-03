

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

   if IsBuilding(target) or not IsRanged(target) then
      SendErrorMessage(caster:GetPlayerOwnerID(), "#error_target_must_be_ranged_unit")
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



function ApplyUpgradeUnits(keys)
   local caster = keys.caster
   local ability = keys.ability
   local abilityName = ability:GetAbilityName()
   local ownerHero = caster:GetOwnerHero()
   local itemName = ownerHero.TT.techDef[abilityName].item
   ownerHero:SetAbilityLevelFor(abilityName, 0)
   ownerHero:SetUnitCountFor(abilityName, 1)
   for _,unit in pairs(ownerHero:GetUnits()) do
      if not IsWorker(unit) then
	 local newItem = CreateItem(itemName, unit, unit)
	 unit:AddItem(newItem)
      end
   end

   TechTree:UpdateTechTree(ownerHero, ownerHero, true)
end

function ApplyUpgradesOnTraining(unit)
   local ownerHero = unit:GetOwnerHero()

   -- Get upgrade item if upgrade is unlocked.
   local function UpgradeItem(upgradeSpellName)
      local upgradeLevel = ownerHero:GetUnitCountFor(upgradeSpellName)
      if upgradeLevel > 0 then
	 return ownerHero.TT.techDef[upgradeSpellName].item
      else
	 return nil
      end
   end
   
   -- Add upgrade item to newly trained unit if unlocked.
   local function AddUpgradeItem(upgradeItemName)
      local newItem = CreateItem(upgradeItemName, unit, unit)
      unit:AddItem(newItem)
   end
   
   -- Combine
   if not IsWorker(unit) then
      local armorUpgradeItem = UpgradeItem("srts_upgrade_light_armor")
      if armorUpgradeItem then
	 AddUpgradeItem(armorUpgradeItem)
      end
      local damageUpgradeItem = UpgradeItem("srts_upgrade_light_damage")
      if damageUpgradeItem then
	 AddUpgradeItem(damageUpgradeItem)
      end
   end
end



function Autocast(keys)
   local caster = keys.caster
   local attacker = keys.attacker
   local ability = keys.ability
   local modifier = keys.modifier

   if ability:GetAutoCastState() then
      if not attacker:HasModifier(modifier) then
	 caster:CastAbilityOnTarget(attacker, ability, caster:GetOwnerID())
      end
   end
end



function CanAfford(player, gold, wood)
   local playerID = player:GetPlayerID()
   local hero = GetPlayerHero(playerID)
   local curGold = PlayerResource:GetGold(playerID)
   local curLumber = hero:GetLumber()
   if curGold >= gold and curLumber >= wood then
      return true
   else
      return false
   end
end



function GiveResources(player, gold, wood)
   local playerID = player:GetPlayerID()
   local hero = GetPlayerHero(playerID)
   hero:IncLumber(wood)
   local curGold = PlayerResource:GetReliableGold(playerID)
   PlayerResource:SetGold(playerID, curGold + gold, true)
end

function RefundGoldTooltip(player, gold)
   local playerID = player:GetPlayerID()
   local hero = GetPlayerHero(playerID)
   local curGold = PlayerResource:GetReliableGold(playerID)
   PlayerResource:SetGold(playerID, curGold + gold, true)
end

function RefundResourcesSpell(keys)
   RefundResourcesID(keys.caster:GetOwnerID(), keys.goldCost, keys.lumberCost)
end

function RefundResources(player, gold, lumber)
   RefundResourcesID(player:GetPlayerID(), gold, lumber)
end

function RefundResourcesID(playerID, gold, lumber)
   local hero = GetPlayerHero(playerID)
   hero:IncGold(gold)
   hero:IncLumber(lumber)   
end

function SpendResourcesNew(player, goldCost, lumberCost)
   local playerID = player:GetPlayerID()
   local hero = GetPlayerHero(playerID)
   local curGold = PlayerResource:GetReliableGold(playerID)
   PlayerResource:SetGold(playerID, curGold - goldCost, true)
   hero:DecLumber(lumberCost)
end

function BuyItem(keys)
   local shop = keys.caster
   local ability = keys.ability
   local itemName = keys.item
   local goldCost = keys.goldCost or 0
   local lumberCost = keys.lumberCost or 0
   local buyRange = 900.0
   local amount = keys.amount or 1
   local buyerHero = shop:GetOwnerHero()
   local buyerPlayer = shop:GetOwnerPlayer()
   local buyerHeroLocation = buyerHero:GetAbsOrigin()
   local buyerID = shop:GetOwnerID()
   
   shop._canAfford = nil
   -- We need to give back the gold before checking.
   RefundGoldTooltip(buyerPlayer, goldCost)

   --if not CheckIfCanAfford({goldCost=goldCost, lumberCost=lumberCost, caster=shop, ability=keys.ability}) then
   if not CanAfford(buyerPlayer, goldCost, lumberCost) then
      SendErrorMessage(buyerID, "#error_not_enough_resources")
      print("Cannot afford, retuning from BuyItem.")
      return
   end

   if shop:GetRangeToUnit(buyerHero) > buyRange then
      SendErrorMessage(buyerID, "#error_hero_outside_shop_range")
      return
   end

   SpendResourcesNew(buyerPlayer, goldCost, lumberCost)
   GiveCharges(buyerHero, amount, itemName)
end
