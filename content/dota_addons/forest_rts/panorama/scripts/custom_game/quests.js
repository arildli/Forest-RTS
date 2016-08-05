"use strict";

/*
Copied over from player_resources.

var config = {"playerXmlName": "file://{resources}/layout/custom_game/allied_resources_player.xml"};
var playerResources = [];
var portraitAdded = [];
var lastPlayerScore = [];

function GetLocalTeamID() {
    return Game.GetLocalPlayerInfo().player_team_id;
}

function GetPlayerCountLocalTeam() {
    return Game.GetTeamDetails(GetLocalTeamID()).team_num_players;    
}

function GetPlayerIDsLocalTeam() {
    return Game.GetPlayerIDsOnTeam(GetLocalTeamID());
}

// Checks the player count on the local team and hides
// the allied resource panel if it's only one on that team.
function AlliedResources_HideIfSolo() {
    var playerCountLocalTeam = GetPlayerCountLocalTeam();
    // Should be if === 1, but 6 for testing.
    if (playerCountLocalTeam === 1) {
    $("#AlliedResourcesPanel").AddClass("Hidden");
    } else {
    var postFix = "UpTitle";
    var titlePanel = $("#TitlePanel");
    for (var i=1; i<6; i=i+1) {
        titlePanel.RemoveClass(i+postFix);   
    }
    var extraSpace = (playerCountLocalTeam-1) + postFix;
    titlePanel.AddClass(extraSpace);

    AlliedResources_UpdateWholePanel();
    }
}

// Returns the panel of a player if it exists.
function AlliedResources_GetPlayerPanel(parentPanel, playerID) {
    var playerPanelName = "player" + playerID;
    return parentPanel.FindChild(playerPanelName);
}

// Update the text of an existing panel.
function AlliedResources_SetTextSafe(panel, childName, text) {
    if (panel === null) {
    return;
    }
    var childPanel = panel.FindChildInLayoutFile(childName);
    if (childPanel === null) {
    return;
    }
    childPanel.text = text;
}

// Updates the panel of a player if it exists or creates
// it if it doesn't.
function AlliedResources_UpdatePlayerPanel(parentPanel, playerID, playerConfig, upClass) {
    if (!playerConfig) {
    return;
    }
    
    var postFix = "UpPlayer";
    var playerPanel = AlliedResources_GetPlayerPanel(parentPanel, playerID);
    // Create player panel if it doesn't exist.
    if (playerPanel === null) {
    $.Msg("playerPanel was null!");
    playerPanel = $.CreatePanel("Panel", parentPanel, "player"+playerID);
    playerPanel.SetAttributeInt("player_id", playerID);
    playerPanel.BLoadLayout(config.playerXmlName, false, false);
    playerPanel.AddClass("PlayerPanel");
    playerPanel.AddClass(upClass);
    $.Msg("upClass: " + upClass);
    }

    var playerInfo = Game.GetPlayerInfo(playerID);
    if (playerInfo && !portraitAdded[playerID]) {
    // Set player portrait.
    var playerPortrait = playerPanel.FindChildInLayoutFile("PlayerImage");
    if (playerPortrait) {
        if (playerInfo.player_selected_hero !== "") {
        var hero = playerInfo.player_selected_hero;
        playerPortrait.SetImage("file://{images}/heroes/" + hero + ".png");
        portraitAdded[playerID] = true;
        } else {
        playerPortrait.SetImage("file://{images}/custom_game/unassigned.png");
        }
    }
    
    var playerName = playerInfo.player_name;
    if (!playerName) {
        playerName = "Name not found";
    }
    AlliedResources_SetTextSafe(playerPanel, "PlayerName", playerName);
    }
    
    // Update the values in the panel.
    var playerData = playerResources[playerID];
    if (playerData) {
    var playerGold = playerData.gold;
    var playerLumber = playerData.lumber;
    var playerWorkers = playerData.workers;
    
    // Return if info hasn't changed since last. 
    var playerScore = lastPlayerScore[playerID];
    if (playerScore &&
        playerScore.gold === playerGold &&
        playerScore.lumber === playerLumber &&
        playerScore.workers === playerWorkers) {
        return;
    }
    
    lastPlayerScore[playerID] = {
        gold : playerGold,
        lumber : playerLumber,
        workers : playerWorkers
    };
    AlliedResources_SetTextSafe(playerPanel, "GoldCount", playerGold);
    AlliedResources_SetTextSafe(playerPanel, "LumberCount", playerLumber);
    AlliedResources_SetTextSafe(playerPanel, "WorkerCount", playerWorkers);
    }
}

function AlliedResources_UpdateWholePanel() {
    var playerCountTeam = GetPlayerCountLocalTeam();
    // Should be 1.
    if (playerCountTeam === 1) {
    return;
    }

    var parentPanel = $("#PlayerPanels");
    // Need to iterate over players on team.
    var localTeamIDs = GetPlayerIDsLocalTeam();
    var localPlayerID = Players.GetLocalPlayer();
    var counter = 1;
    for (var curID of localTeamIDs) {
    if (curID === localPlayerID) {
        continue;
    }
    var curMarginClass = counter + "UpPlayer";
    AlliedResources_UpdatePlayerPanel(parentPanel, curID, config, curMarginClass);
    counter = counter + 1;
    }
}

function AlliedResources_UpdatePlayerData(keys) {
    playerResources = keys.teamData;
    
    AlliedResources_UpdateWholePanel();
}

// Moves the panels slightly higher up if flipped.
function CheckHudFlipped() {
    var topPanel = $.FindChildInContext("#AlliedResourcesPanel");
    
    if (Game.IsHUDFlipped()) {
    topPanel.AddClass("Flipped");
    } else {
    topPanel.RemoveClass("Flipped");
    }
}

(function() {
    GameEvents.Subscribe("team_resources", AlliedResources_UpdatePlayerData);

    CheckHudFlipped();
    AlliedResources_HideIfSolo();
})();
*/