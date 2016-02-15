


if AbilityPages == nil then
   print("[AbilityPages] AbilityPages is starting!")
   AbilityPages = {}
   AbilityPages.__index = AbilityPages
end

function AbilityPages:new(o)
   o = o or {}
   setmetatable(o, AbilityPages)
   return o
end



function GetAbilityPage(entity, pageName)
   return entity._abilityPages[pageName]
end

function SetAbilityPage(entity, pageName, value)
   entity._abilityPages[pageName] = value
end

-- Create the ability pages for the new entity.
function InitAbilityPage(entity, pageNumber, abilities)
   if not entity or not pageNumber or not abilities then
      print("InitAbilityPages: entity, pageNumber or abilities was nil!")
      return
   end

   -- Create the ability page.
   entity._abilityPages = entity._abilityPages or {}
   entity._abilityLevels = entity._abilityLevels or {}
   entity._abilityPages[pageNumber] = {}
   local currentPage = entity._abilityPages[pageNumber]
   --local nextAbilityIndex = 0

   if DEBUG_ABILITY_PAGES == true then
      print_ability_pages("\n", "Setting up new ability page with number: "..pageNumber)
      print_ability_pages("", "----------------------------")
   end

   -- Setup the ability page and set ability level to 0.
   for i=1, 6 do
      local textToPrint = "Empty"
      if abilities[i] then
	 --currentPage[nextAbilityIndex] = abilities[i]
	 currentPage[i-1] = abilities[i]
	 --nextAbilityIndex = nextAbilityIndex + 1
      end

      if DEBUG_ABILITY_PAGES == true then
	 local curAbilityName = abilities[i]["spell"]
	 textToPrint = curAbilityName
	 print_ability_pages("InitAbilityPages", "abilities["..i.."]: "..textToPrint)
      end
   end
end



-- Version of the function that is called by the spells.
-- Forwards the call to 'GoToPage'.
function GoToPageFunction(keys)
   local caster = keys.caster
   local ability = keys.ability
   local pageNumber = keys.pageNumber

   GoToPage(caster, pageNumber)
end



-- Sets the current page of the entity to 'pageNumber'.
function GoToPage(entity, pageNumber)
   -- Get current ability page to read from.
   --local curAbilityPage = entity._abilityPages[pageNumber]
   local curAbilityPage = GetAbilityPage(entity, pageNumber)
   if not curAbilityPage then
      -- Crash
      print(curAbilityPage)
   end
   local ownerHero
   if entity:IsRealHero() then
      ownerHero = entity
   else
      ownerHero = entity:GetOwnerHero()
   end

   -- Remove all current spells.
   for i=0, 6 do
      local curAbility = entity:GetAbilityByIndex(i)
      if curAbility then
	 local curAbilityName = curAbility:GetAbilityName()
	 local curAbilityLevel = curAbility:GetLevel()
	 --entity._abilityLevels[curAbilityName] = curAbilityLevel
	 entity:RemoveAbility(curAbilityName)
      end
   end

   -- Add spells from the current ability page.
   for i=0, 6 do
      local curNewAbility = curAbilityPage[i]
      if curNewAbility then
	 -- Add new ability.
	 local curNewAbilityName = curNewAbility["spell"]
	 entity:AddAbility(curNewAbilityName)

	 -- Set level of ability.
	 if entity:HasAbility(curNewAbilityName) then
	    local curAbilityToLevel = entity:FindAbilityByName(curNewAbilityName)
	    local curAbilityLevel = ownerHero:GetAbilityLevelFor(curNewAbilityName)
	    if curAbilityLevel then
	       --	    if entity._abilityLevels[curNewAbilityName] then
	       --curAbilityToLevel:SetLevel(entity._abilityLevels[curNewAbilityName])
	       curAbilityToLevel:SetLevel(curAbilityLevel)
	    else
	       print("GoToPage: ._abilityLevels for that ability was not set!")
	       -- Crash
	       print(nil)
	    end
	 end
      end
   end

   -- Add ability_building to buildings if they don't already have it.
   local abilityBuilding = entity:FindAbilityByName("ability_building")
   local abilityBuildingQueue = entity:FindAbilityByName("ability_building_queue")
   local entityName = entity:GetUnitName()
   if entityName:find("building") then
      if not entity:HasAbility("ability_building") then
	 entity:AddAbility("ability_building")
	 local abilityBuilding = entity:FindAbilityByName("ability_building")
	 abilityBuilding:SetLevel(1)
      end
      if not entity:HasAbility("ability_building_queue") then
	 entity:AddAbility("ability_building_queue")
	 local abilityBuildingQueue = entity:FindAbilityByName("ability_building_queue")
	 abilityBuildingQueue:SetLevel(1)
      end
   --[=[else
      local abilityUnitName = "srts_ability_unit"
      --local abilityUnit = entity:FindAbilityByName(abilityUnitName)
      if not entity:HasAbility(abilityUnitName) then
	 entity:AddAbility(abilityUnitName)
	 local abilityUnit = entity:FindAbilityByName(abilityUnitName)
	 abilityUnit:SetLevel(1)
      end]=]
   end

   TechTree:UpdateSpellsForEntity(entity)
   --TechTree:UpdateSpellsHeroOnly(entity)
end



-- Print text if debug mode is on.
function print_ability_pages(funcName, text)
   if DEBUG_ABILITY_PAGES == true then
      print("AbilityPages:"..funcName.."\t"..text)
   end
end













