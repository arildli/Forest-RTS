

MARKET = "npc_dota_building_market"

if not Utils then
  Utils = {}
end



--[[ -----| Rotation spells |----- ]]--



-- For rotating a building under construction to the left.
function RotateLeft(keys)
  local building = keys.caster
  if not building then
    print("RotateLeft: caster was nil!")
    return
  end
  
  local currentFW = building:GetForwardVector()
  local x = SRing(currentFW.x)
  local y = SRing(currentFW.y)
  local z = 0.0
  
  if x == 1.0 and y == 0.0 then
    x = 0.7
    y = 0.7
  elseif x == 0.7 and y == 0.7 then
    x = 0.0
    y = 1.0
  elseif x == 0.0 and y == 1.0 then
    x = -0.7
    y = 0.7
  elseif x == -0.7 and y == 0.7 then
    x = -1.0
    y = 0.0
  elseif x == -1.0 and y == 0.0 then
    x = -0.7
    y = -0.7
  elseif x == -0.7 and y == -0.7 then
    x = 0.0
    y = -1.0
  elseif x == 0.0 and y == -1.0 then
    x = 0.7
    y = -0.7
  elseif x == 0.7 and y == -0.7 then
    x = 1.0
    y = 0.0
  end
  
  building:SetForwardVector(Vector(x, y, z))
  currentFW = building:GetForwardVector()
  --print("X: "..SRing(currentFW.x)..", Y: "..SRing(currentFW.y)..", Z: "..currentFW.z)
end



-- For rotating a building under construction to the right.
function RotateRight(keys)
  local building = keys.caster
  if not building then
    print("RotateLeft: caster was nil!")
    return
  end
  
  local currentFW = building:GetForwardVector()
  local x = SRing(currentFW.x)
  local y = SRing(currentFW.y)
  local z = 0.0
  
  if x == 1.0 and y == 0.0 then
    x = 0.7
    y = -0.7
  elseif x == 0.7 and y == -0.7 then
    x = 0.0
    y = -1.0
  elseif x == 0.0 and y == -1.0 then
    x = -0.7
    y = -0.7
  elseif x == -0.7 and y == -0.7 then
    x = -1.0
    y = 0.0
  elseif x == -1.0 and y == 0.0 then
    x = -0.7
    y = 0.7
  elseif x == -0.7 and y == 0.7 then
    x = 0.0
    y = 1.0
  elseif x == 0.0 and y == 1.0 then
    x = 0.7
    y = 0.7
  elseif x == 0.7 and y == 0.7 then
    x = 1.0
    y = 0.0
  end
  
  building:SetForwardVector(Vector(x, y, z))
  currentFW = building:GetForwardVector()
  --print("X: "..SRing(currentFW.x)..", Y: "..SRing(currentFW.y)..", Z: "..currentFW.z)
end



-- Performs a simple rounding.
function SRing(number)
  if number > -0.01 and number < 0.01 then
    return 0.0
  elseif number > 0.99 and number < 1.01 then
    return 1.0
  elseif number < -0.99 and number > -1.01 then
    return -1.0
  elseif number < -0.69 and number > -0.71 then
    return -0.7
  elseif number > 0.69 and number < 0.71 then
    return 0.7
  else
    --print("Number: "..number)
  end
end





--     -----| Economy |----- 





-- Spends the specified amount of gold and lumber for the hero if the
-- player has enough of these resources.
function SpendResources(unit, goldAmount, lumberAmount)
  if not unit or not goldAmount or not lumberAmount then
    print("SpendResources: unit, goldAmount or lumberAmount unspecified!")
    return false
  end
  
  local owner = unit:GetOwner()
  local playerID = owner:GetPlayerID()
  if not playerID then
    print("SpendResources: Couldn't get owner of 'hero'!")
    return false
  end
  local hero = PLAYER_HEROES[playerID]
  if not hero then
    print("SpendResources: hero was nil!")
    return false
  end
  local currentGold = PlayerResource:GetGold(playerID)
  
  if currentGold < goldAmount then
    print("Gold required: "..goldAmount..", Current gold: "..currentGold)
    return false
  end
  
  if SpendLumber(hero, lumberAmount) == true then
    PlayerResource:SpendGold(playerID, goldAmount, 0)
    
    ReportStat(owner, goldAmount, "goldSpent")
    ReportStat(owner, lumberAmount, "lumberSpent")
    return true
  else
    print("Lumber required: "..lumberAmount)
    return false
  end
end



-- Spends "amount" lumber from the "hero".
function SpendLumber(hero, amount)
  local lumberCount = hero:GetLumber()

  if lumberCount > amount or lumberCount == amount then
     hero:DecLumber(amount)
    return true
  else
    return false
  end
end



-- Gives "amount" number of charges to "itemName" of "hero"
function GiveCharges(hero, amount, itemName)
  
  if not hero or not amount or not itemName then
    return false
  end
  if amount == 0 then
    return true
  end
  
  if hero:HasItemInInventory(itemName) then
    local item = GetItemFromInventory(hero, itemName)
    local currentCharges = item:GetCurrentCharges()
    --print("Charges before: "..currentCharges)
    item:SetCurrentCharges(currentCharges + amount)
    --print("Charges after: "..item:GetCurrentCharges())
    return true
  else
    local newItem = CreateItem(itemName, hero, hero)
    if not newItem then
      return false
    end
    
    newItem:SetCurrentCharges(amount)
    --print("Charges of new item: "..newItem:GetCurrentCharges())
    
    if hero:IsRealHero() then
      if hero:HasInventory() and hero:HasRoomForItem(itemName, false, false) then
	hero:AddItem(newItem)
      else
	CreateItemOnPositionSync(hero:GetOrigin(), newItem)
      end
    else
      hero:AddItem(newItem)
    end
    return true
  end
end



-- Buy gold for lumber.
function BuyGold(unit, wood, gold)
  if not unit or not wood or not gold then
    print("BuyGold: unit, wood or gold was nil!")
    return false
  end
  
  local playerHero = GetPlayerHero(unit:GetOwner():GetPlayerID())
  if SpendLumber(playerHero, wood) == true then
    local owner = unit:GetOwner()
    local ownerID = owner:GetPlayerID()
    local currentGold = PlayerResource:GetReliableGold(ownerID)
    PlayerResource:SetGold(ownerID, currentGold + gold, true)
    return true
  end
  
  return false
end



-- Buy gold for lumber through using a spell.
function BuyGoldFromSpell(keys)
  local unit = keys.caster
  local wood = keys.wood
  local gold = keys.gold
  
  if not unit or not wood or not gold then
    print("BuyGoldFromSpell: unit, wood or gold was nil!")
    return
  else
    if BuyGold(unit, wood, gold) == false then
      print("Gold could not be bought!")
    end
  end
end



-- Transfer all the lumber from a unit to another unit.
function TransferLumber(keys)
  local caster = keys.caster
  local target = keys.target
  local playerID = caster:GetOwner():GetPlayerID()
  local hero = GetPlayerHero(playerID)

  if not caster or not target or not hero then
    print("TransferLumber: caster, target or hero was nil!")
    return false
  end
  
  if target:GetUnitName() == MARKET or target:GetUnitName() == "npc_dota_building_main_tent_small" then
    local lumberCount = GetLumberCount(caster)
    if lumberCount > 0 then
       local lumberItem = GetItemFromInventory(caster, "item_stack_of_lumber")
       if lumberItem then
	  caster:RemoveItem(lumberItem)
       end
       hero:IncLumber(lumberCount)
    else
      print("TransferLumber: caster did not have any lumber!")
    end
  else
    print("TransferLumber: Target was not a Market or Main Tent!")
  end
end



-- Transfer all the lumber from a unit to a hero.
function TransferLumberHero(keys)
  local caster = keys.caster
  local target = keys.target

  if not caster or not target then
    print("TransferLumber: caster or target was nil!")
    return false
  end
  
  local lumberCount = GetLumberCount(caster)
  if lumberCount > 0 then
    SpendLumber(caster, lumberCount)
    GiveCharges(target, lumberCount, "item_stack_of_lumber")
  else
    print("TransferLumber: caster did not have any lumber!")
  end
end



-- Gives gold to the specified player
function GiveGold(keys)
  if not keys.caster or not keys.amount then
    print("GiveGold: caster or amount was nil!")
    return false
  end
  
  local gold = keys.amount
  local caster = keys.caster
  local owner = caster:GetOwner()
  local ownerID = owner:GetPlayerID()
  local currentGold = PlayerResource:GetReliableGold(ownerID)
  PlayerResource:SetGold(ownerID, currentGold + gold, true)
  return true
end



-- Returns a handle to the first occurence of the item if the hero has it
function GetItemFromInventory(hero, itemName)
  
  if not hero or not itemName then
    return nil
  end
  
  if hero:HasItemInInventory(itemName) then
    for i=0, 5 do
      local currentItem = hero:GetItemInSlot(i)
      if currentItem and currentItem:GetAbilityName() == itemName then
	return currentItem
      end
    end
  else
    return nil
  end
end



-- Returns the number of lumber the unit is carrying.
function GetLumberCount(unit)
  local lumberStack = GetItemFromInventory(unit, "item_stack_of_lumber")
  if lumberStack then
    return lumberStack:GetCurrentCharges()
  else
    print("GetLumberCount: unit did not have any lumber!")
    return 0
  end
end



--[[ -----| Other |----- ]]--



---------------------------------------------------------------------------
-- Temporarily grants vision of the caster to the other team.
---------------------------------------------------------------------------
function GiveVisionOfUnit(keys)
  local caster = keys.caster
  local target = keys.target
  
  local team = caster:GetTeam()
  if team == DOTA_TEAM_GOODGUYS then
    team = DOTA_TEAM_BADGUYS
  elseif team == DOTA_TEAM_BADGUYS then
    team = DOTA_TEAM_GOODGUYS
  end
  
  AddFOWViewer(team, caster:GetAbsOrigin(), 500, 0.75, true)
end



---------------------------------------------------------------------------
-- Function used to test if an ability works.
---------------------------------------------------------------------------
function AbilityTestPrint(keys)
  local ability = keys.ability
  if not ability then print("Ability Was nil, but function was still called!") end
  print("Calling from ability: "..ability:GetAbilityName())
end



---------------------------------------------------------------------------
-- Returns the ability if unit has it, nil otherwise.
--
--	* unit: The unit to check
--	* abilityName: The ability to look for
--
---------------------------------------------------------------------------
function UnitHasAbility(unit, abilityName)  
  for i=0, 5 do
    local ability = unit:GetAbilityByIndex(i)
    if ability and ability:GetAbilityName() == abilityName then
      return ability
    end
  end
  return nil
end



---------------------------------------------------------------------------
-- Checks if any of the variables are nil.
--   * funcName: Name of the function calling this.
--   * vars: The table containing the variables to be checked.
--   * len: The number of elements in the vars table.
---------------------------------------------------------------------------
function IsNil(funcName, vars, len)
  local varsType = type(vars)
  if varsType == "table" then
    local proper = true
    for i=1,len do
      local cur = vars[i]
      if not cur then
	print(funcName..": index "..i.." is nil!")
	proper = false
      end
    end
    return proper
  else
    print("IsNull: vars must be a table, was "..varsType)
    return false
  end
end





--[[ -----| Spell Replacement |----- ]]--





-- Prints info if DEBUG mode.
function printDebug(functionName, message)
  if DEBUG == true then
    print(functionName.."   DEBUG: "..message)
  end
end





--[[ -----| Report Stats |----- ]]--





-- Increase the chosen stat
function ReportStat(player, amount, statName)
  if not player or not amount or not statName then
    print("ReportStat: player, amount or statName was nil!")
    return
  end
  
  if not player._stats then
    player._stats = {}
  end
  
  if not player._stats[statName] then
    player._stats[statName] = amount
  else
    player._stats[statName] = player._stats[statName] + amount
  end
  
  if DEBUG_UTILS == true then
    print("Stat: "..statName.."\tValue: "..player._stats[statName])
  end
end
