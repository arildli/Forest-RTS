
if not Resources then
  Resources = {}
end

---------------------------------------------------------------------------
-- Inits the hero with the necessary properties to work with this 
-- resource system.
--
--   * hero: The hero to initialize.
--
---------------------------------------------------------------------------
function Resources:InitHero(hero)
  if not hero or hero:IsRealHero() == false then
    print("Resources:InitHero: hero was either nil or not a hero!")
    return false
  end

  local playerID = hero:GetOwner():GetPlayerID()
  if not playerID then
    print("Resources:InitHero: playerID was nil!")
    return false
  end

  hero.SRES = {}
  hero.SRES.lumber = 0

  ---------------------------------------------------------------------------
  -- Returns the gold count of the hero.
  ---------------------------------------------------------------------------
  function hero:GetGold()
     return PlayerResource:GetGold(hero:GetOwner():GetPlayerID())
  end

  ---------------------------------------------------------------------------
  -- Returns the lumber count of the hero.
  ---------------------------------------------------------------------------
  function hero:GetLumber()
    return hero.SRES.lumber
  end

  ---------------------------------------------------------------------------
  -- Returns if the hero has more gold than the specified amount.
  --
  --   * amount: The amount to compare with.
  --
  ---------------------------------------------------------------------------
  function hero:HasEnoughGold(amount)
     return hero:GetGold() >= amount
  end

  ---------------------------------------------------------------------------
  -- Returns if the hero has more lumber than the specified amount.
  --
  --   * amount: The amount to compare with.
  --
  ---------------------------------------------------------------------------
  function hero:HasEnoughLumber(amount)
     return hero:GetLumber() >= amount
  end

  ---------------------------------------------------------------------------
  -- Sets the gold count of the hero.
  --
  --   * amount: The new gold amount.
  --
  ---------------------------------------------------------------------------
  function hero:SetGold(amount)
    local isNil = IsNil("SetGold", {amount}, 1)
    hero.SRES.gold = amount
    return isNil
  end
  
  ---------------------------------------------------------------------------
  -- Sets the lumber count of the hero.
  --
  --   * amount: The new lumber count.
  --
  ---------------------------------------------------------------------------
  function hero:SetLumber(amount)
    hero.SRES.lumber = amount
    local player = hero:GetOwner()
    CustomGameEventManager:Send_ServerToPlayer(player, "player_lumber_changed", { lumber = math.floor(hero:GetLumber()) })
  end
  
  ---------------------------------------------------------------------------
  -- Increases the gold count of the hero.
  --
  --   * amount: The amount to increase with.
  --
  ---------------------------------------------------------------------------
  function hero:IncGold(amount)
    hero.SRES.gold = hero.SRES.gold + amount
  end

  ---------------------------------------------------------------------------
  -- Increases the lumber count of the hero.
  --
  --   * amount: The amount to increase with.
  --
  ---------------------------------------------------------------------------
  function hero:IncLumber(amount)
    hero.SRES.lumber = hero.SRES.lumber + amount
    local player = hero:GetOwner()
    CustomGameEventManager:Send_ServerToPlayer(player, "player_lumber_changed", { lumber = math.floor(hero:GetLumber()) })
  end

  ---------------------------------------------------------------------------
  -- Decreases the lumber count of the hero.
  --
  --   * amount: The amount to decrease with.
  --
  ---------------------------------------------------------------------------
  function hero:DecLumber(amount)
     hero.SRES.lumber = hero.SRES.lumber - amount
     if hero.SRES.lumber < 0 then
	hero.SRES.lumber = 0
     end
     local player = hero:GetOwner()
     CustomGameEventManager:Send_ServerToPlayer(player, "player_lumber_changed", { lumber = math.floor(hero:GetLumber()) })
  end
end



---------------------------------------------------------------------------
-- Returns whether or not this unit has been inited.
---------------------------------------------------------------------------
function Resources:HasBeenInit(unit)
  if not unit.SRES then
    return false
  end
  return true
end



---------------------------------------------------------------------------
-- Returns the number of lumber the unit is carrying.
---------------------------------------------------------------------------
function Resources:GetLumberCarried(unit)
  local lumberStack = GetItemFromInventory(unit, "item_stack_of_lumber")
  if lumberStack then
    return lumberStack:GetCurrentCharges()
  else
    print("GetLumberCount: unit did not have any lumber!")
    return 0
  end
end



--     -----| Functions |-----



---------------------------------------------------------------------------
-- Cuts the tree and gives lumber to the caster.
---------------------------------------------------------------------------
function HarvestChop(keys)
  local caster = keys.caster
  local target = keys.target
  local amount = keys.lumber
  local teamNumber = caster:GetTeamNumber()

  if target then
    target:CutDown(teamNumber)
  end
  GiveCharges(caster, amount, "item_stack_of_lumber")
end



---------------------------------------------------------------------------
-- Delivers the lumber carried by the unit to the targeted building
-- if valid target.
---------------------------------------------------------------------------
function Resources:HarvestDeliverLumber(keys)
  local caster = keys.caster
  local target = keys.target
  local owningHero = GetPlayerHero(caster:GetOwner():GetPlayerID())
  
  local isNil = IsNil("Resources:HarvestDeliverLumber", {caster, target, owningHero}, 3)
  if target:IsDeliveryPoint() then
    local amount = Resources:GetLumberCarried()
    if amount > 0 then
      SpendLumber(caster, amount)
      owningHero:IncLumber(amount)
    end
  else
    -- Needs UI Warning
    print("Resources:HarvestDeliverLumber: Invalid Target!")
  end
  return isNil
end



--     -----| Old Utils |-----



-- Gives lumber to the owner of the harvesting unit.
function GiveHarvestedLumber(keys)
  
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  
  local owner = caster:GetPlayerOwner()
  local playerID = owner:GetPlayerID()
  local teamNumber = caster:GetTeamNumber()
  local lumberAmount = keys.lumber
  local hero = GetPlayerHero(playerID)
  
  if target then
    target:CutDown(teamNumber)
  end
  
  GiveCharges(caster, lumberAmount, "item_stack_of_lumber")
  
  ReportLumberChopped(owner, lumberAmount)
end



-- Gives lumber to the owner of the harvesting unit by spell.
function GiveHarvestedLumberAlt(keys)
  local args = {}
  args["caster"] = keys.caster
  args["lumber"] = keys.amount
  GiveHarvestedLumber(args)
end



-- Increase the amount of lumber chopped for this player.
function ReportLumberChopped(player, amount)
  if not player or not amount then
    print("ReportLumberChopped: player or amount was nil!")
    return
  end

  if not player._lumberGained then
    player._lumberGained = amount
  else
    player._lumberGained = player._lumberGained + amount
  end
end



function printRes(funcName, message)
   if DEBUG_RESOURCES then
      print(funcName..": "..message)
   end
end
