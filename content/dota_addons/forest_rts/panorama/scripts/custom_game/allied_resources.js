"use strict";

// Checks the player count on the local team and hides
// the allied resource panel if it's only one on that team.
function HideIfSolo() {
    var localTeamID = Game.GetLocalPlayerInfo().player_team_id
    var playerCountLocalTeam = Game.GetTeamDetails(localTeamID).team_num_players;
    // Should be if === 1, but 6 for testing.
    if (playerCountLocalTeam === 6) {
	$("#AlliedResourcesPanel").AddClass("Hidden");
    } else {
	// Add classes 1-5 to add more space for new
	// player panels.
    }
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
    HideIfSolo();
    $.Msg();
})();
