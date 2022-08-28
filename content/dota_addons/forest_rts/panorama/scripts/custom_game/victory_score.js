"use strict";

var score = "";
var prefix = "";

function SetInitialScore(keys) {
    prefix = keys.scorePrefix;
    UpdateScore({"score" : keys.score});
}

// Sets the victory score field.
function UpdateScore(keys) {
    score = keys.score;

    $("#VictoryScore").text = prefix + score;

    CheckHudFlipped();
}

// Moves the clock panel to the correct side of the screen
// if the HUD is flipped.
function CheckHudFlipped() {
    var scorePanel = $.FindChildInContext("#VictoryScorePanel");

    $.Msg("Checking for flipped HUD...");
    
    if (Game.IsHUDFlipped()) {
        scorePanel.RemoveClass("Right");
        scorePanel.AddClass("Flipped");
        $.Msg("Flipped!");
    } else {
        scorePanel.AddClass("Right");
        scorePanel.RemoveClass("Flipped");
        $.Msg("Not Flipped.");
    }
}

(function() {
    $("#VictoryScore").text = "";
    GameEvents.SendCustomGameEventToServer("get_initial_score", {})
    GameEvents.Subscribe("initial_score_reply", SetInitialScore);
    GameEvents.Subscribe("update_score", UpdateScore);
    CheckHudFlipped();
})();
