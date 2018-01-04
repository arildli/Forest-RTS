
if not Quests then
    Quests = {}
end

---------------------------------------------------------------------------
-- Initializes this module.
---------------------------------------------------------------------------
function Quests:Init()
    Quests.players = {}
    Quests.quests = {}
    Quests.questTitleToIndex = {}
    Quests:CreateInitialQuests()

    print("[Quests] Initialized Quests module.")
end

---------------------------------------------------------------------------
-- Adds a new player to keep track of.
--
-- @player (Player): The player to add.
---------------------------------------------------------------------------
function Quests:AddPlayer(player)
    local playerID = player:GetPlayerID()

    PrintQuest("Adding player "..playerID)
    Quests.players[playerID] = {
        quests = {}
    }
end

---------------------------------------------------------------------------
-- Returns the quest structure for the specified player.
--
-- @player (Number): The player ID of the player to search for.
---------------------------------------------------------------------------
function Quests:GetPlayer(playerID)
    return Quests.players[playerID]
end

---------------------------------------------------------------------------
-- Returns all the quests for the specified player.
--
-- @player (Number): The player ID of the player to search for.
---------------------------------------------------------------------------
function Quests:GetAllQuestsForPlayer(playerID)
    local playerStruct = Quests:GetPlayer(playerID)
    if not playerStruct then
        return nil
    end
    return playerStruct.quests
end

---------------------------------------------------------------------------
-- Creates a new quest object.
--
-- @title (String): The name of the quest to create.
-- @descriptions (array (String)): An array of quest descriptions.
-- @predicates (array (Function)): An array of predicates for the
--   requirements.
-- @textOnly (Boolean): If set, quest is only used for the descriptions.
--   predicates can be an empty table in that case.
-- @returns: The newly created quest.
---------------------------------------------------------------------------
function Quests:CreateQuest(title, descriptions, predicates, textOnly)
    if not title or not descriptions or not predicates then
        PrintQuestFailure("Quests:CreateQuest", "'title', 'descriptions' or 'predicates' were nil!")
        return
    elseif not textOnly and #descriptions ~= #predicates then
        PrintQuestFailure("Quests:CreateQuest",
            "'descriptions' and 'predicates' have different lengths!")
        return nil
    end

    local newQuest = {
        questTitle = title,
        completed = false,
        textOnly = textOnly,
        reqs = {}
    }
    for i=1,#descriptions do
        local curDesc = descriptions[i]
        local curPred = predicates[i]
        newQuest.reqs[i] = {
            text = curDesc,
            completed = false,
            pred = curPred
        }
    end

    --Quests:PrintQuest(newQuest)
    return newQuest
end

---------------------------------------------------------------------------
-- Adds a new player to keep track of.
--
-- @playerID (Number): The player ID
-- @questName (String): The full name of the quest.
---------------------------------------------------------------------------
function Quests:AddQuest(playerID, questName)
    local index = Quests.questTitleToIndex[questName]
    local quest = Quests.quests[index]
    if not quest then
        PrintQuestFailure("Quests:AddQuest", "'"..(questName or "nil").."' not found!")
        return
    end
    local playerQuestStruct = Quests:GetPlayer(playerID)
    playerQuestStruct.quests[questName] = quest
    PrintQuest("Added quest '"..questName.."' to player with ID "..playerID)
end

---------------------------------------------------------------------------
-- Adds new quests that can be used.
---------------------------------------------------------------------------
function Quests:CreateInitialQuests()
    Quests.quests = {
        Quests:CreateQuest("How To Play",
            {
                "Find a proper base location",
                "Construct a Main Tent",
                "Train workers to harvest lumber",
                "Build a base",
                "Train an army",
                "Kill enemy players or Barbarians"
            }, {}, true
        ),
        Quests:CreateQuest("Rules",
            {
                "1 point for each hero kill",
                "1 point for each Main Tent destroyed",
                "Be the first to reach the goal"
            }, {}, true
        ),
        Quests:CreateQuest("Single Player/Co-Op",
            {
                "Defend against waves of barbarians",
                "They get stronger as time progresses",
                "Capture the middle camp for extra lumber"
            }, {}, true
        )
    }

    Quests.questTitleToIndex["Main Objective Patrols"] = 1
    Quests.questTitleToIndex["Main Objective PvP"] = 2
    Quests.questTitleToIndex["Middle Lumber Camp"] = 3
end

function Quests:PrintQuest(quest)
    print("[Quests] Printing quest:")
    print("Title: "..quest.questTitle)
    print("Completed: "..tostring(quest.completed))
    for _,req in pairs(quest.reqs) do
        if req.completed then
            print("\t- "..req.text.." (Completed)")
        else
            print("\t- "..req.text)
        end
    end
end

function PrintQuest(...)
    print("[Quests] ".. ...)
end

function PrintQuestFailure(funcName, ...)
    print("[Quests] ERROR ("..funcName.."): " .. ...)
end
