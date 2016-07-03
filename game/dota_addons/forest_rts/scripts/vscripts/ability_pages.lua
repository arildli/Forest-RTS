


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
    if not entity._abilityPages then
        return GetAbilityPageFromDefs(entity:GetUnitName(), entity:GetOwnerHero():GetUnitName(), pageName)
    end
    return entity._abilityPages[pageName]
end

function GetAbilityPagesFromDefs(entityName, ownerHeroname)
    return tech[ownerHeroName][entityName].pages
end

function GetAbilityPageFromDefs(entityName, ownerHeroName, pageName)
    return tech[ownerHeroName][entityName].pages[pageName]
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

        if DEBUG_ABILITY_PAGES == true and abilities[i] then
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
    if not curAbilityPage and pageNumber ~= "PAGE_UPGRADE" then
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

    function AddAbilitiesFromPage(page)
        -- Add spells from the current ability page.
        for i=0, 6 do
            local curNewAbility = page[i]
            if curNewAbility then
                -- Add new ability.
                local curNewAbilityName = curNewAbility["spell"]
                entity:AddAbility(curNewAbilityName)

                -- Set level of ability
                if entity:HasAbility(curNewAbilityName) then
                    print("Entity has ability "..curNewAbilityName)
                    local curAbilityToLevel = entity:FindAbilityByName(curNewAbilityName)
                    local curAbilityLevel = ownerHero:GetAbilityLevelFor(curNewAbilityName)
                    if curAbilityLevel then
                        curAbilityToLevel:SetLevel(curAbilityLevel)
                    else
                        print("GoToPage: ._abilityLevels for that ability was not set!")
                        -- Crash
                        print(nil)          
                    end
                end
            end
        end
    end

    -- In case of upgrade.
    if pageNumber == "PAGE_UPGRADE" then
        -- Temporarily learn the rotation spells.
        local rotateLeft = "srts_rotate_left"
        local rotateRight = "srts_rotate_right"
        local cancelUpgrade = "srts_cancel_upgrade"
   
        entity:AddAbility(rotateLeft)
        entity:AddAbility(rotateRight)
        entity:AddAbility(cancelUpgrade)
        entity:FindAbilityByName(rotateLeft):SetLevel(1)
        entity:FindAbilityByName(rotateRight):SetLevel(1)
        entity:FindAbilityByName(cancelUpgrade):SetLevel(1)
    else
        AddAbilitiesFromPage(curAbilityPage)
        local pageHidden = GetAbilityPage(entity, "HIDDEN")
        if pageHidden then
            print("Adding abilities from pageHidden!")
            AddAbilitiesFromPage(pageHidden)
        end
    end

    -- Add ability_building to buildings if they don't already have it.
    local abilityBuilding = entity:FindAbilityByName("ability_building")
    local abilityBuildingQueue = entity:FindAbilityByName("ability_building_queue")
    local entityName = entity:GetUnitName()

    TechTree:UpdateSpellsForEntity(entity)
    --TechTree:UpdateSpellsHeroOnly(entity)
end



-- Print text if debug mode is on.
function print_ability_pages(funcName, text)
    if DEBUG_ABILITY_PAGES == true then
        print("AbilityPages:"..funcName.."\t"..text)
    end
end













