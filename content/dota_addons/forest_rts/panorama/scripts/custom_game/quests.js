"use strict";

var config = {"questXmlName": "file://{resources}/layout/custom_game/quests_single.xml"};
var allQuests = [];
var questTitleToIndex = {};

function Quests_HasQuest(questObject) {
    return (questTitleToIndex[questObject.questTitle] !== undefined);
}

function Quests_AddQuest(questObject) {
    var newIndex = allQuests.length;
    var questTitle = questObject.questTitle;
    allQuests[newIndex] = {
        questTitle : questTitle,
        completed : questObject.completed,
        requirements : questObject.reqs
    };
    questTitleToIndex[questTitle] = newIndex;
}

function Quests_GetQuest(questTitle) {
    var questIndex = questTitleToIndex[questTitle];
    if (questIndex !== undefined) {
        return allQuests[questIndex];
    }
    return undefined;
}

function Quests_GetQuestPanel(parentPanel, questTitle) {
    return parentPanel.FindChild(questTitle);
}

function Quests_CreateQuestPanel(parentPanel, questTitle, linesAbove) {
    var questPanel = $.CreatePanel("Panel", parentPanel, questTitle);
    questPanel.BLoadLayout(config.questXmlName, false, false);
    questPanel.AddClass("QuestPanel");
    if (linesAbove > 0) {
        var linesAboveClassName = linesAbove + "LinesAbove";
        questPanel.AddClass(linesAboveClassName);
    }
    return questPanel;
}

function Quests_UpdateWholePanel(quests) {
    var lineHeight = 25;

    var parentPanel = $("#QuestPanels");
    var linesAbove = 0;

    for (var key in quests) {
        var curQuest = quests[key];
        var questTitle = curQuest.questTitle;
        var completed = curQuest.completed;
        var requirements = curQuest.reqs;

        if (!Quests_HasQuest(curQuest)) {
            Quests_AddQuest(curQuest);
        }

        linesAbove += Quests_UpdateQuestPanel(parentPanel, curQuest, linesAbove);
    }
}

function Quests_UpdateQuestPanel(parentPanel, questObject, linesAbove) {
    if (!config) {
        $.Msg("Error: 'config' is undeclared!");
        return;
    }

    var questTitle = questObject.questTitle;
    var questPanel = Quests_GetQuestPanel(parentPanel, questTitle);
    if (!questPanel) {
        questPanel = Quests_CreateQuestPanel(parentPanel, questTitle, linesAbove);
    }

    var questNamePanel = questPanel.FindChildInLayoutFile("QuestName");
    if (questNamePanel && questNamePanel.text !== questTitle) {
        SetTextSafe(questPanel, "QuestName", questTitle);
    }

    var reqs = questObject.reqs;
    var reqCount = Object.keys(reqs).length;
    var reqString = ""
    for (var i=1; i<=reqCount; i+=1) {
        var curReq = reqs[i];
        reqString += "- " + curReq.text + "\n";
    }
    var panelHeight = reqCount + "Lines";
    questPanel.AddClass(panelHeight);

    var questReqPanel = questPanel.FindChildInLayoutFile("QuestReqs");
    if (questReqPanel && questReqPanel.text !== reqString) {
        SetTextSafe(questPanel, "QuestReqs", reqString);
    }

    if (questObject.completed && !questPanel.BHasClass("Completed")) {
        questPanel.AddClass("Completed");
    }

    return reqCount + 1;
}

function Quests_QuestTitleClicked() {
    var parentPanel = $("#QuestPanels");
    if (!parentPanel) {
        $.Msg("(Quests_QuestTitleClicked) Didn't find parentPanel for some reason...");
    }
    parentPanel.shown = !parentPanel.shown
    if (parentPanel.shown) {
        parentPanel.RemoveClass("Hidden");
        parentPanel.RemoveClass("LeftShiftedTitle");
    } else {
        parentPanel.AddClass("Hidden");
        parentPanel.AddClass("LeftShiftedTitle");
    }
}

function Quests_OnServerData(keys) {
    Quests_UpdateWholePanel(keys);
}

(function() {
    GameEvents.Subscribe("quest_update", Quests_OnServerData);
})();
