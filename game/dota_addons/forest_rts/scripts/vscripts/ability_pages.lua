


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



-- Create the ability pages for the new unit.
function InitAbilityPage(unit, pageNumber, abilities)
   if not unit or not pageNumber or not abilities then
      print("InitAbilityPages: unit, pageNumber or abilities was nil!")
      return
   end

   -- Create the ability page.
   if not unit._abilityPages then
      unit._abilityPages = {}
   end
   if not unit._abilityLevels then
      unit._abilityLevels = {}
   end
   unit._abilityPages[pageNumber] = {}
   local currentPage = unit._abilityPages[pageNumber]
   local nextAbilityIndex = 0

   if DEBUG_ABILITY_PAGES == true then
      print_ability_pages("\n", "Setting up new ability page with number: "..pageNumber)
      print_ability_pages("", "----------------------------")
   end

   -- Setup the ability page and set ability level to 0.
   for i=1, 6 do
      local textToPrint = "Empty"
      if abilities[i] then
	 local curAbilityName = abilities[i]["spell"]
	 currentPage[nextAbilityIndex] = abilities[i]
	 textToPrint = curAbilityName
	 nextAbilityIndex = nextAbilityIndex + 1
      end

      if DEBUG_ABILITY_PAGES == true then
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



-- Sets the current page of the unit to 'pageNumber'.
function GoToPage(unit, pageNumber)
   -- Error checking.
   if not unit or not pageNumber then
      print("GoToPage: unit or pageNumber was nil!")
      return
   end
   if not unit._abilityPages then
      print("GoToPage: unit did not have ._abilityPages!")
      return
   end
   if not unit._abilityLevels then
      print("GoToPage: unit did not have ._abilityLevels!")
      return
   end

   -- Get current ability page to read from.
   local curAbilityPage = unit._abilityPages[pageNumber]
   if not curAbilityPage then
      print("GoToPage: invalid pageNumber ("..pageNumber..")!")
      return
   end

   --print_ability_pages("GoToPage", "Going to page "..pageNumber)
   --print("------------------")

   -- Remove all current spells.
   for i=0, 6 do
      local curAbility = unit:GetAbilityByIndex(i)
      if curAbility then
	 local curAbilityName = curAbility:GetAbilityName()
	 local curAbilityLevel = curAbility:GetLevel()
	 unit._abilityLevels[curAbilityName] = curAbilityLevel
	 unit:RemoveAbility(curAbilityName)

	 --print_ability_pages("GoToPage", "Removed "..curAbilityName.." at index "..i.."!")
      end
   end

   -- Add spells from the current ability page.
   for i=0, 6 do
      local curNewAbility = curAbilityPage[i]
      if curNewAbility then
	 -- Add new ability.
	 local curNewAbilityName = curNewAbility["spell"]
	 unit:AddAbility(curNewAbilityName)

	 -- Set level of ability.
	 if unit:HasAbility(curNewAbilityName) then
	    local curAbilityToLevel = unit:FindAbilityByName(curNewAbilityName)
	    if unit._abilityLevels[curNewAbilityName] then
	       curAbilityToLevel:SetLevel(unit._abilityLevels[curNewAbilityName])
	    else
	       print("GoToPage: ._abilityLevels for that ability was not set!")
	       curAbilityToLevel:SetLevel(0)
	    end
	 end

	 --print_ability_pages("GoToPage", "Added "..curNewAbilityName.." at index "..i.."!")
      end
   end

   TechTree:UpdateSpellsHeroOnly(unit)
end



-- Print text if debug mode is on.
function print_ability_pages(funcName, text)
   if DEBUG_ABILITY_PAGES == true then
      print("AbilityPages:"..funcName.."\t"..text)
   end
end













