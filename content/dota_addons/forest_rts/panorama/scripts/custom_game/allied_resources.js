"use strict";

function AlliedResources_GetPlayerCountLocalTeam() {
    var localTeamID = Game.GetLocalPlayerInfo().player_team_id;
    return Game.GetTeamDetails(localTeamID).team_num_players;    
}

// Checks the player count on the local team and hides
// the allied resource panel if it's only one on that team.
function AlliedResources_HideIfSolo() {
    var playerCountLocalTeam = AlliedResources_GetPlayerCountLocalTeam();
    // Should be if === 1, but 6 for testing.
    if (playerCountLocalTeam === 6) {
	$("#AlliedResourcesPanel").AddClass("Hidden");
    } else {
	for (var i=1; i<6; i=i+1) {
	    $("#TitlePanel").RemoveClass(i+"Up");   
	}
	var extraSpace = playerCountLocalTeam + "Up";
	$("#TitlePanel").AddClass(extraSpace);
	$.Msg("extraSpaceClass: " + extraSpace);
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
    
    var playerPanel = AlliedResources_GetPlayerPanel(parentPanel, playerID);
    // Create player panel if it doesn't exist.
    if (playerPanel === null) {
	$.Msg("playerPanel was null!");
	playerPanel = $.CreatePanel("Panel", parentPanel, "player"+playerID);
	playerPanel.SetAttributeInt("player_id", playerID);
	playerPanel.AddClass("PlayerPanel");
	playerPanel.AddClass(upClass);
    }

    // Continue to fix panel while getting inspiration from
    // multiteam_top_scoreboard.js.
}

function AlliedResources_UpdateWholePanel() {
    var parentPanel = $("#PlayerPanels");
    // Need to iterate over players on team.
    AlliedResources_UpdatePlayerPanel(parentPanel, 0, {}, "1Up");
    //$.Msg("Update");
    //$.Schedule(1.0, AlliedResources_UpdateWholePanel);
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
    CheckHudFlipped();
    AlliedResources_HideIfSolo();
    AlliedResources_UpdateWholePanel();
    $.Msg();
})();
