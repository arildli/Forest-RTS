--  CustomGameEventManager:Send_ServerToPlayer(player, "player_lumber_changed", { lumber = math.floor(hero:GetLumber()) })


-- Variables
GENERIC_ABILITIES = {}
PLAYER_HEROES = {}
-- For some reason PlayerResource was not found here, therefore the value had
-- to be set inside InitGameMode instead for both PLAYER_COUNT and VICTORY_SCORE.
PLAYER_COUNT = 0
VICTORY_SCORE = 0

COLOR_RADIANT = "#3455ff"
COLOR_RADIANT_RGB = {52,85,255}
--"#3dd296"
--"#1bc0d8"
--"#3455ff"
--"#4789ab"
COLOR_DIRE = "#b0171b"
COLOR_DIRE_RGB = {176,23,27}
MAX_PLAYERS_PER_TEAM = 5
MAX_PLAYERS_WITH_BOT = MAX_PLAYERS_PER_TEAM - 1


-- For some reason the type of self is number in one of the methods...
local prefixGlobal = ""


if not SimpleRTSGameMode then
    SimpleRTSGameMode = {}
    SimpleRTSGameMode.__index = SimpleRTSGameMode
end

if not SRTSGM then
    SRTSGM = SimpleRTSGameMode
end

function SimpleRTSGameMode:new(o)
    o = o or {}
    setmetatable(o, self)
    SIMPLERTS_REFERENCE = o
    return o
end





-- // -----| Init |----- \\ --





---------------------------------------------------------------------------
-- Loads the required modules, sets the gamerules, listens to event
-- and registers commands.
---------------------------------------------------------------------------
function SimpleRTSGameMode:InitGameMode()
    print("[SimpleRTS] Gamemode is initialising.")

    -- Load the rest of the modules that requires that the game modes are set
    loadModule('settings')
    loadModule('utils')
    loadModule('resources')
    loadModule('tech_tree')
    loadModule('buildings')
    loadModule('ability_pages')
    loadModule('simple_bot')
    loadModule('spells')
    loadModule('stats')
    loadModule('libraries/timers')
    loadModule('libraries/selection')
    loadModule('libraries/buildinghelper')
    loadModule('builder')
    loadModule('abilities/autocast')
    loadModule('quests')
    loadModule('neutral_bases')

    -- Added EDITED
    --loadModule('ai/independent_utilities')
    loadModule('ai/main')
    -- DONE

    LinkLuaModifier("modifier_train_unit", "libraries/modifiers/modifier_train_unit", LUA_MODIFIER_MOTION_NONE)

    -- Setup rules
    GameRules:SetGoldPerTick(0)
    --GameRules:SetGoldPerTick(GOLD_PER_TICK)
    GameRules:SetGoldTickTime(GOLD_TICK_TIME)
    GameRules:SetFirstBloodActive(FIRST_BLOOD_ACTIVE)
    GameRules:SetSameHeroSelectionEnabled(SAME_HERO_ENABLED)
    GameRules:SetHeroSelectionTime(HERO_SELECTION_TIME)
    GameRules:SetPreGameTime(PRE_GAME_TIME)
    GameRules:SetPostGameTime(POST_GAME_TIME)
    GameRules:SetTreeRegrowTime(TREE_REGROW_TIME_SECONDS)
    GameRules:GetGameModeEntity():SetLoseGoldOnDeath(LOSE_GOLD_ON_DEATH)
    GameRules:GetGameModeEntity():SetCameraDistanceOverride(1300)

    -- Setup game mode rules
    GameMode = GameRules:GetGameModeEntity()
    GameMode:SetBuybackEnabled(BUYBACK_ENABLED)
    GameMode:SetLoseGoldOnDeath(false)
    GameMode:SetTopBarTeamValuesOverride(true)
    GameMode:SetTopBarTeamValuesVisible(true)
    GameMode:SetLoseGoldOnDeath(false)

    -- Find pathable trees.
    Resources:InitTrees()

    print("[SimpleRTS] Gamemode rules are set.")

    -- Init self
    SimpleRTS = self
    self.scoreDire = 0
    self.scoreRadiant = 0
    self.playerCount = 0

    self.teamColors = {}
    self.teamColors[DOTA_TEAM_GOODGUYS] = {52, 85, 255};
    self.teamColors[DOTA_TEAM_BADGUYS] = {176, 23, 27};

    self.players = {}

    for team=0,10 do
        local color = self.teamColors[team]
        if color then
            SetTeamCustomHealthbarColor(team, color[1], color[2], color[3])
        end
    end

    -- Filters
    GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( SimpleRTSGameMode, "FilterExecuteOrder" ), self )

    -- Event Hooks
    ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(SimpleRTSGameMode, 'onHeroPick'), self)
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(SimpleRTSGameMode, 'onGameStateChange'), self)
    ListenToGameEvent('npc_spawned', Dynamic_Wrap(SimpleRTSGameMode, 'onNPCSpawned'), self)
    ListenToGameEvent('entity_killed', Dynamic_Wrap(SimpleRTSGameMode, 'onEntityKilled'), self)
    ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(SimpleRTSGameMode, 'onEntityLevel'), self)
    ListenToGameEvent('tree_cut', Dynamic_Wrap(SimpleRTSGameMode, 'OnTreeCut'), self)

    -- Register Listener
    CustomGameEventManager:RegisterListener("update_selected_entities", Dynamic_Wrap(SimpleRTSGameMode, 'OnPlayerSelectedEntities'))
    CustomGameEventManager:RegisterListener("set_rally_point", Dynamic_Wrap(SimpleRTSGameMode, "onRallyPointSet"))
    CustomGameEventManager:RegisterListener("get_initial_score", Dynamic_Wrap(SimpleRTSGameMode, "GetInitialScore"))
    CustomGameEventManager:RegisterListener("enter_tower", Dynamic_Wrap(SimpleRTSGameMode, "CastEnterTower"))

    -- Register Think
    GameMode:SetContextThink("SimpleRTSThink", Dynamic_Wrap(SimpleRTSGameMode, 'Think'), THINK_TIME)

    -- Full units file to get the custom values
    GameRules.AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
    GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
    GameRules.HeroKV = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
    GameRules.ItemKV = LoadKeyValues("scripts/npc/npc_items_custom.txt")
    --GameRules.Requirements = LoadKeyValues("scripts/kv/tech_tree.kv")

    -- Store and update selected units of each pID
    GameRules.SELECTED_UNITS = {}

    -- Keeps the blighted gridnav positions
    GameRules.Blight = {}

    -- Initialize the Stats module.
    Stats:Init()

    -- Initialize AI.
    if AI then
        AI:Init()
    end

    -- Initialize the Quests module.
    Quests:Init()

    -- Register console commands
    Convars:RegisterCommand('boss', function()
        local cmdPlayer = Convars:GetCommandClient()
        local playerHero
        if cmdPlayer then
            local playerID = cmdPlayer:GetPlayerID()
            if playerID ~= nil and playerID ~= -1 then
                playerHero = PlayerResource:GetSelectedHeroEntity(playerID)
            end
        end

        local playerID = cmdPlayer:GetPlayerID()
        --SimpleBot:MultiplyInitialPatrol(5)
        PlayerResource:ModifyGold(playerID, 99999, true, 0)
        Stats:AddGold(playerID, 99999)

        local newItem = CreateItem("item_blink", playerHero, playerHero)
        playerHero:AddItem(newItem)
        newItem = CreateItem("item_heart", playerHero, playerHero)
        playerHero:AddItem(newItem)
        newItem = CreateItem("item_assault", playerHero, playerHero)
        playerHero:AddItem(newItem)
        newItem = CreateItem("item_mjollnir", playerHero, playerHero)
        playerHero:AddItem(newItem)
        newItem = CreateItem("item_rapier", playerHero, playerHero)
        playerHero:AddItem(newItem)
        playerHero:IncLumber(1000)
        BuildingHelper:WarpTen(true)
        if not AI then
            AI = {}
        end
        AI.speedUpTraining = true
    end, 'Beefs up the hero of the caller, adds resources and reduces construction time', FCVAR_CHEAT )


    Convars:RegisterCommand('warpten', function()
        BuildingHelper:WarpTen(true)
    end, "Speeds up construction", FCVAR_CHEAT)


    Convars:RegisterCommand('lumber', function()
        local cmdPlayer = Convars:GetCommandClient()
        local playerHero
        if cmdPlayer then
            local playerID = cmdPlayer:GetPlayerID()
            if playerID and playerID ~= -1 then
                playerHero = PlayerResource:GetSelectedHeroEntity(playerID)
                playerHero:IncLumber(1000)
            end
        end
    end, 'Gives the player lumber', FCVAR_CHEAT)


    Convars:RegisterCommand('printstats', function()
        print("Printing stats:\n----------")
        Stats:PrintStatsAll()
    end, 'Shows stats', FCVAR_CHEAT)

    Convars:RegisterCommand("Salve", function()
        local cmdPlayer = Convars:GetCommandClient()
        if cmdPlayer then
            local playerHero
            local playerID = cmdPlayer:GetPlayerID()
            if playerID and playerID ~= -1 then
                playerHero = PlayerResource:GetSelectedHeroEntity(playerID)
            end

            local salves = CreateItem("item_healing_salve", playerHero, playerHero)
            playerHero:AddItem(salves)
        end
    end, "Gives the hero 10 healing salves", FCVAR_CHEAT )


    Convars:RegisterCommand('debug', function()
        DEBUG = true
        SimpleBot:MultiplyInitialPatrol(5)
        VICTORY_SCORE = 25
    end, 'Enables standard debug mode for lower construction time', FCVAR_CHEAT)


    Convars:RegisterCommand('unitCount', function()
        local cmdPlayer = Convars:GetCommandClient()
        local playerHero
        if cmdPlayer then
            local playerID = cmdPlayer:GetPlayerID()
            if playerID ~= nil and playerID ~= -1 then
                playerHero = PlayerResource:GetSelectedHeroEntity(playerID)
            end
        end

        playerHero:PrintUnitCount()
    end, 'Print the unitCount table of the hero of the caller', FCVAR_CHEAT)


    Convars:RegisterCommand('start', function()

    end, 'Start game', FCVAR_CHEAT)


    Convars:RegisterCommand('test_endgame', function()
        GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
        --GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
        GameRules:Defeated()
    end, 'Ends the game.', FCVAR_CHEAT)

    Convars:RegisterCommand('spawn_patrol_army', function()
        local cmdPlayer = Convars:GetCommandClient()
        local playerHero
        if cmdPlayer then
            local playerID = cmdPlayer:GetPlayerID()
            if playerID ~= nil and playerID ~= -1 then
                playerHero = PlayerResource:GetSelectedHeroEntity(playerID)
            end
        end

        local unitName = "npc_dota_creature_soldier_melee"
        local location = playerHero:GetAbsOrigin()
        local count = 30

        --function SimpleBot:SpawnSoldiers(DOTA_TEAM_NEUTRALS, 20, 20, playerHero:GetAbsOrigin(), pathNumber, groupNumber, multiplier)
        for i=0,count do
            CreateUnitByName(unitName, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
        end
    end, 'Spawns a lot of patrol units at the hero location', FCVAR_CHEAT)
end





--                  -----| Listener functions |-----





---------------------------------------------------------------------------
-- On Hero Pick
---------------------------------------------------------------------------
function SimpleRTSGameMode:onHeroPick(keys)
    local currentPlayer = EntIndexToHScript(keys.player)
    PlayerResource:SetGold(currentPlayer:GetPlayerID(), START_GOLD, true)
    PlayerResource:SetGold(currentPlayer:GetPlayerID(), 0, false)

    local hero = EntIndexToHScript(keys.heroindex)
    local player = EntIndexToHScript(keys.player)
    local playerID = hero:GetPlayerID()
    local teamName = GetTeamName(hero:GetTeam())

    Stats:AddPlayer(hero, player, playerID, teamName)
    Resources:InitHero(hero, START_LUMBER)

    Quests:AddPlayer(player)
    local possibleMainQuests = {
        ["Solo"] = "Main Objective Patrols",
        ["Co-Op"] = "Main Objective Patrols",
        ["PvP"] = "Main Objective PvP"
    }
    local mainQuestName = possibleMainQuests[self.gameMode]
    Quests:AddQuest(playerID, mainQuestName)
    Quests:AddQuest(playerID, "Middle Lumber Camp")

    -- Initialize Variables for Tracking
    hero.units = {} -- This keeps the handle of all the units of the player, to iterate for unlocking upgrades
    hero.structures = {} -- This keeps the handle of the constructed units, to iterate for unlocking upgrades
    hero.buildings = {} -- This keeps the name and quantity of each building
    hero.upgrades = {} -- This kees the name of all the upgrades researched
    hero.lumber = 0 -- Secondary resource of the player

    -- Add the hero to the player units list
    table.insert(hero.units, hero)
    hero.state = "idle" --Builder state
end



---------------------------------------------------------------------------
-- On Entity Level
---------------------------------------------------------------------------
function SimpleRTSGameMode:onEntityLevel(keys)
    -- Prevent hero from using ability points by removing them.
    local player = EntIndexToHScript(keys.player)
    local hero = player:GetAssignedHero()
    if not hero then
        print("SimpleRTSGameMode:onEntityLevel: hero was nil!")
    else
        hero:SetAbilityPoints(0)
    end

    local playerID = player:GetPlayerID()
    local newLevel = PlayerResource:GetLevel(playerID)
    Stats:OnLevelUp(playerID, newLevel)
end



---------------------------------------------------------------------------
-- On Game State Change
---------------------------------------------------------------------------
function SimpleRTSGameMode:onGameStateChange(keys)
    local newState = GameRules:State_Get()

    -- Selection state
    if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
        self.radiantCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
        self.direCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
        self.totalCount = self.radiantCount + self.direCount

        VICTORY_SCORE = math.ceil(self.totalCount * KILLS_TO_WIN / 2)
        print("VICTORY_SCORE: "..VICTORY_SCORE)

        self.prefix = "Default: "

        if self.radiantCount > 0 and self.direCount == 0 then
            if self.totalCount > 1 then
                self.gameMode = "Co-Op"
            else
                self.gameMode = "Solo"
            end
            self.botTeam = DOTA_TEAM_BADGUYS
            self.prefix = "Lives: "
            self.playerTeam = DOTA_TEAM_GOODGUYS
        elseif self.direCount > 0 and self.radiantCount == 0 then
            if self.totalCount > 1 then
                self.gameMode = "Co-Op"
            else
                self.gameMode = "Solo"
            end
            self.botTeam = DOTA_TEAM_GOODGUYS
            self.prefix = "Lives: "
            self.playerTeam = DOTA_TEAM_BADGUYS
        elseif self.radiantCount > 0 and self.direCount > 0 then
            self.gameMode = "PvP"
            self.prefix = "Goal: "
        else
            print("radiantCount: "..self.radiantCount.."\tdireCount: "..self.direCount.."\ttotalCount: "..self.totalCount)
            self.prefix = "ErrorPrefix: "
        end

        print("\nself.radiantCount: "..self.radiantCount.."\tself.direCount: "..self.direCount.."\tself.totalCount: "..self.totalCount.."\tself.gameMode: "..self.gameMode.."\tself.prefix: "..self.prefix)

        -- Set the global prefix variable since self doesn't always work...
        prefixGlobal = self.prefix

        -- Add player-like bots
        if AI then
            --[=[
            if IsTeamEmpty(DOTA_TEAM_GOODGUYS) then
                AI:AddBot(DOTA_TEAM_GOODGUYS, "npc_dota_hero_legion_commander")
            elseif IsTeamEmpty(DOTA_TEAM_BADGUYS) then
                AI:AddBot(DOTA_TEAM_BADGUYS, "npc_dota_hero_legion_commander")
            end
            ]=]
        end

        -- Create a timer for sending team resource info to players.
        Timers:CreateTimer(
            function()
                SimpleRTSGameMode:SendTeamResources()
                return 0.5
            end)

        -- Create a timer for sending quest info to players.
        Timers:CreateTimer(
            function()
                SimpleRTSGameMode:SendQuestInfo()
                return 0.5
            end)

    elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
        print("[SimpleRTS] The game has started.")

        -- Initialize the Neutrals module.
        Neutrals:Init()

        if self.gameMode == "Solo" then
            SimpleRTSGameMode:SinglePlayerMode(self.botTeam)
        elseif self.gameMode == "Co-Op" then
            SimpleRTSGameMode:CoOpMode(self.botTeam, self.playerTeam, self.totalCount)
        elseif self.gameMode == "PvP" then
            SimpleRTSGameMode:NormalMode()
        end
    -- Game start
    elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    end
end



---------------------------------------------------------------------------
-- On Game Start
--  Called by onGameStateChange
---------------------------------------------------------------------------
function SimpleRTSGameMode:onGameStart(keys)
    local playerCount = 0
    local radiantCount = 0
    local direCount = 0

    for i=0, HIGHEST_PLAYER_INDEX do
        local currentPlayer = PlayerResource:GetPlayer(i)
        if currentPlayer then
            if not PlayerResource:HasSelectedHero(currentPlayer:GetPlayerID()) then
                PlayerResource:SetHasRepicked(i)
                currentPlayer:MakeRandomHeroSelection()
            end

            local playerTeam = PlayerResource:GetTeam(currentPlayer:GetPlayerID())
            if playerTeam == DOTA_TEAM_GOODGUYS then
                radiantCount = radiantCount + 1
            elseif playerTeam == DOTA_TEAM_BADGUYS then
                direCount = direCount + 1
            end
            playerCount = playerCount + 1
            lastFoundPlayer = currentPlayer
        end
    end
    return playerCount, radiantCount, direCount
end



---------------------------------------------------------------------------
-- On Rally Point Set.
---------------------------------------------------------------------------
function SimpleRTSGameMode:onRallyPointSet(keys)
    print("NOTE: onRallyPointSet called!")

    local player = PlayerResource:GetPlayer(keys.pID)
    local rallyPos = keys.clickPos
    local building = EntIndexToHScript(keys.mainSelected)
    local buildingName = building:GetUnitName()
    if buildingName:find("tent") or buildingName:find("barracks") then
        building:SetRallyPoint(rallyPos)
        print("Rally point set!")
        Notifications:ClearTop(player)
        Notifications:Top(player, {text="Rally point set!", duration=3})
    end
end



---------------------------------------------------------------------------
-- Get Initial Score.
---------------------------------------------------------------------------
function SimpleRTSGameMode:GetInitialScore(keys)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    local prefix = prefixGlobal
    print("Sending "..prefix.." and "..VICTORY_SCORE.." to client!")
    CustomGameEventManager:Send_ServerToPlayer(player, "initial_score_reply", {scorePrefix = prefix, score = VICTORY_SCORE})
end



---------------------------------------------------------------------------
-- Call CastEnterTower.
---------------------------------------------------------------------------
function SimpleRTSGameMode:CastEnterTower(keys)
  CastEnterTower(keys)
end



---------------------------------------------------------------------------
-- Send Team Resources.
---------------------------------------------------------------------------
function SimpleRTSGameMode:SendTeamResources()
    local resources = {}
    for i=0, HIGHEST_PLAYER_INDEX do
        local curPlayerHero = GetPlayerHero(i)
        if curPlayerHero then
            local curTeamNumber = curPlayerHero:GetTeamNumber()
            resources[curTeamNumber] = resources[curTeamNumber] or {}
            resources[curTeamNumber][i] = {
                gold = curPlayerHero:GetGold() or 0,
                lumber = curPlayerHero:GetLumber() or 0,
                workers = curPlayerHero:GetWorkerCount() or 0
            }
        end
    end

    for teamID,teamData in pairs(resources) do
        CustomGameEventManager:Send_ServerToTeam(teamID, "team_resources", {teamData = teamData})
        --CustomGameEventManager:Send_ServerToTeam(teamID, "team_resources", {teamData = teamData})
    end
end



---------------------------------------------------------------------------
-- Send Quest Info.
---------------------------------------------------------------------------
function SimpleRTSGameMode:SendQuestInfo()
    local heroes = HeroList:GetAllHeroes()
    for _,hero in pairs(heroes) do
        local owner = hero:GetOwner()
        local playerID = owner:GetPlayerID()
        local quests = Quests:GetAllQuestsForPlayer(playerID)

        if owner and quests then
            CustomGameEventManager:Send_ServerToPlayer(owner, "quest_update", quests)
        end
    end
end



---------------------------------------------------------------------------
-- On NPC Spawn
---------------------------------------------------------------------------
function SimpleRTSGameMode:onNPCSpawned(keys)
    local spawnedUnit = EntIndexToHScript(keys.entindex)
    if not spawnedUnit:IsIllusion() and spawnedUnit:IsHero() and not spawnedUnit._initialized then
        spawnedUnit._initialized = true
        spawnedUnit:SetAbilityPoints(0)

        local owner = spawnedUnit:GetOwner()
        local playerID = owner:GetPlayerID()
        PLAYER_HEROES[playerID] = spawnedUnit
        TechTree:AddPlayerMethods(spawnedUnit, owner)
        TechTree:InitTechTree(spawnedUnit)
        spawnedUnit._playerOwned = true
    else
        spawnedUnit:SetIdleAcquire(true)
    end
end



---------------------------------------------------------------------------
-- On Entity Killed
---------------------------------------------------------------------------
function SimpleRTSGameMode:onEntityKilled(keys)
    local killedUnit = EntIndexToHScript(keys.entindex_killed)
    local killerUnit
    if keys.entindex_attacker then
        killerUnit = EntIndexToHScript(keys.entindex_attacker)
    end
    local killedTeam = killedUnit:GetTeam()
    local killerTeam = killerUnit:GetTeam()
    local unitName = killedUnit:GetUnitName()

    -- No need for more processing if killed unit was a soldier or neutral.
    if SimpleRTSGameMode:IsSoldier(killedUnit) or killedUnit:IsNeutralUnitType() or (not killedUnit:IsRealHero() and not killedUnit._playerOwned) then
        if killerUnit:IsRealHero() or killerUnit._playerOwned then
            local goldBounty = killedUnit:GetGoldBounty()
            local killerID = killerUnit:GetOwnerID()
            Stats:AddGold(killerID, goldBounty)
            Stats:OnDeathNeutral(killerID, killedUnit)
        end
        return
    end

    --     BH stuff     --

    -- Get owner of killed unit if it's owned by a player.
    local playerHero = nil
    if killedUnit:IsRealHero() then
        playerHero = killedUnit
    elseif killedUnit._ownerPlayer then
        playerHero = killedUnit:GetOwnerHero()
    else
        return
    end

    local killedID = killedUnit:GetOwnerID()
    local killerID
    if killerUnit:IsRealHero() or killerUnit._playerOwned then
        killerID = killerUnit:GetOwnerID()
    end

    -- Building Killed
    if IsBuilding(killedUnit) or IsCustomBuilding(killedUnit) then
        if killedUnit._upgraded then
            print("Returning from 'onEntityKilled' due to unit being upgraded!")
            return
        end

        -- Building Helper grid cleanup
        BuildingHelper:RemoveBuilding(killedUnit, true)
        local building_name = killedUnit:GetUnitName()
        -- Substract 1 to the player building tracking table for that name
        if playerHero.buildings[building_name] then
            playerHero.buildings[building_name] = playerHero.buildings[building_name] - 1
        end

        Stats:OnDeath(killedID, killerID, killedUnit, "building")
    else
        Stats:OnDeath(killedID, killerID, killedUnit, "unit")
    end

    -- Table cleanup
    if playerHero then
        -- Remake the tables
        local table_structures = {}
        for _,building in pairs(playerHero.structures) do
            if building and IsValidEntity(building) and building:IsAlive() then
                table.insert(table_structures, building)
            end
        end
        playerHero.structures = table_structures

        local table_units = {}
        for _,unit in pairs(playerHero.units) do
            if unit and IsValidEntity(unit) then
                table.insert(table_units, unit)
            end
        end
        playerHero.units = table_units
    end

   --     BH stuff end     --


    -- Killed unit was inside a tower.
    if killedUnit._tower then
        RemoveUnitFromTower(killedUnit._tower)
    end

    -- Killed unit was a tower with a unit inside. Make sure he dies too!
    if killedUnit._inside then
        killedUnit._inside:ForceKill(false)
    end

   if (killedUnit:IsRealHero() == true or StringStartsWith(unitName, "npc_dota_building_main_tent")) then
      print("Killed unit was hero or main building.")
      --if not killedUnit._wasCancelled then
      local killedTeamString
      local scoreMessage
      if killedTeam == DOTA_TEAM_GOODGUYS then
     killedTeamString = "<font color='"..COLOR_RADIANT.."'>Radiant</font>"
     self.scoreDire = self.scoreDire + 1
     if StringStartsWith(unitName, "npc_dota_building_main_tent") then
        Stats:OnTentDestroyed(killerID)
        GameRules:SendCustomMessage("A "..killedTeamString.." Main Tent was destroyed!", 0, 0)
     end
      elseif killedTeam == DOTA_TEAM_BADGUYS then
     killedTeamString = "<font color='"..COLOR_DIRE.."'>Dire</font>"
     self.scoreRadiant = self.scoreRadiant + 1
     if StringStartsWith(unitName, "npc_dota_building_main_tent") then
        Stats:OnTentDestroyed(killerID)
        GameRules:SendCustomMessage("A "..killedTeamString.." Main Tent was destroyed!", 0, 0)
     end
      end
      print("Updating scores: "..self.scoreRadiant.." and "..self.scoreDire)
      CustomGameEventManager:Send_ServerToAllClients("new_team_score", {radiantScore=self.scoreRadiant, direScore=self.scoreDire})

      print("Radiant: "..self.scoreRadiant.."\tDire: "..self.scoreDire)

      local gameMode = self.gameMode
      -- In this case, the losing condition is reaching 0 points.
      if gameMode == "Solo" or gameMode == "Co-Op" then
     -- Get lives left.
     local livesLeft
     if self.botTeam == DOTA_TEAM_GOODGUYS then
        livesLeft = VICTORY_SCORE - self.scoreRadiant
     elseif self.botTeam == DOTA_TEAM_BADGUYS then
        livesLeft = VICTORY_SCORE - self.scoreDire
     end

     print("LivesLeft: "..livesLeft.."\tVICTORY_SCORE: "..VICTORY_SCORE)

     -- Check if loss.
     if livesLeft <= 0 then
        if self.botTeam == DOTA_TEAM_GOODGUYS then
           GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
           GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
           GameRules:Defeated()
        elseif self.botTeam == DOTA_TEAM_BADGUYS then
           GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
           GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
           GameRules:Defeated()
        end
     end

     -- Send lives left to players.
     CustomGameEventManager:Send_ServerToAllClients("update_score", {score = livesLeft})
      elseif gameMode == "PvP" then
     -- Check if enough kills have been made
     if self.scoreRadiant >= VICTORY_SCORE then
        print("#simplerts_radiant_victory")
        GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
        --GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
        GameRules:Defeated()
     elseif self.scoreDire >= VICTORY_SCORE then
        print("#simplerts_dire_victory")
        GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
        --GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
        GameRules:Defeated()
     end
      end
   end

    if not killedUnit:IsRealHero() then
        TechTree:RegisterIncident(killedUnit, false)
    end

    -- Update worker panel of killed player.
    local killedHero = killedUnit:GetOwnerHero()
    if killedHero then
        UpdateWorkerPanel(killedHero)
    end
end





--                  -----| Game Modes |-----





---------------------------------------------------------------------------
-- Single Player Mode
---------------------------------------------------------------------------
function SimpleRTSGameMode:SinglePlayerMode(botTeam)
    ---print("[SimpleRTS] Single Player Mode:\tPlayer ID: "..localPlayer:GetPlayerID().."\tBot Team: "..botTeam)
    --SimpleRTSGameMode:ShowCenterMessage("#simplerts_single_player_mode", 5)
    Stats:SetGameMode("Solo")
    SimpleRTSGameMode:spawnSimpleBot(botTeam, 1.1)
end



---------------------------------------------------------------------------
-- Co-Op Mode
---------------------------------------------------------------------------
function SimpleRTSGameMode:CoOpMode(botTeam, activeTeam, playersOnTeam)
    --SimpleRTSGameMode:ShowCenterMessage("#simplerts_co-op_mode_text", 5)

    print("[SimpleRTS] Co-Op versus Soldiers Mode:\tTeam: "..activeTeam.."\tBot Team: "..botTeam)
    print("[SimpleRTS] Player on team: "..playersOnTeam)
    Stats:SetGameMode("Co-Op")
    SimpleRTSGameMode:spawnSimpleBot(botTeam, playersOnTeam*1.1)
end



---------------------------------------------------------------------------
-- PvP Mode
---------------------------------------------------------------------------
function SimpleRTSGameMode:NormalMode()
    Stats:SetGameMode("PvP")
end





--                  -----| Bot |-----





---------------------------------------------------------------------------
-- Spawns a simple bot on the opposite team
---------------------------------------------------------------------------
function SimpleRTSGameMode:spawnSimpleBot(botTeam, multiplier)
    print("[SimpleRTS] Spawning bot at team: "..botTeam.." with multiplier "..multiplier.."!")
    SimpleBot:Init(botTeam, multiplier)
end






-- A tree was cut down
function SimpleRTSGameMode:OnTreeCut(keys)
    --DeepPrintTable(keys)

    local treeX = keys.tree_x
    local treeY = keys.tree_y

    -- Update the pathable trees nearby
    local vecs = {
        Vector(0,64,0),-- N
        Vector(64,64,0), -- NE
        Vector(64,0,0), -- E
        Vector(64,-64,0), -- SE
        Vector(0,-64,0), -- S
        Vector(-64,-64,0), -- SW
        Vector(-64,0,0), -- W
        Vector(-64,64,0) -- NW
    }

    for k=1,#vecs do
        local vec = vecs[k]
        local xoff = vec.x
        local yoff = vec.y
        local pos = Vector(treeX + xoff, treeY + yoff, 0)

        local nearbyTree = GridNav:IsNearbyTree(pos, 96, true)
        --local nearbyTree = GridNav:IsNearbyTree(pos, 64, true)
        if nearbyTree then
            local trees = GridNav:GetAllTreesAroundPoint(pos, 48, true)
            --local trees = GridNav:GetAllTreesAroundPoint(pos, 32, true)
            for _,t in pairs(trees) do
                -- Added {
                --DebugDrawCircle(t:GetAbsOrigin(), Vector(0,255,0), 255, 32, true, 60)
                -- }
                t.pathable = true
            end
        end
    end
end





--                  -----| Utility functions |-----





---------------------------------------------------------------------------
-- Returns the hero for the player with the given ID
-- * playerID: The ID of the player
---------------------------------------------------------------------------
function GetPlayerHero(playerID)
    return PLAYER_HEROES[playerID]
end



---------------------------------------------------------------------------
-- Returns true if the unit is a neutral soldier
-- * unit: The unit to check
---------------------------------------------------------------------------
function SimpleRTSGameMode:IsSoldier(unit)
    local unitName = unit:GetUnitName()
    return unitName == "npc_dota_creature_soldier_melee" or
        unitName == "npc_dota_creature_soldier_ranged"
end



---------------------------------------------------------------------------
-- Think function, unused
---------------------------------------------------------------------------
function SimpleRTSGameMode:Think()
    return THINK_TIME
end





--                  -----| BuildingHelper Stuff |-----





-- Called whenever a player changes its current selection, it keeps a list of entity indexes
function SimpleRTSGameMode:OnPlayerSelectedEntities( event )
    local pID = event.pID

    GameRules.SELECTED_UNITS[pID] = event.selected_entities

    -- This is for Building Helper to know which is the currently active builder
    local mainSelected = GetMainSelectedEntity(pID)
    if IsValidEntity(mainSelected) and IsBuilder(mainSelected) then
        local player = PlayerResource:GetPlayer(pID)
        player.activeBuilder = mainSelected
    end
end
