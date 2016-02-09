"use strict";

var victoryScore = "";

// Sets the victory score field.
function SetVictoryScore(keys) {
    victoryScore = keys.victoryScore;
    $("#VictoryScore").text = "Win: "+victoryScore;
    $.Msg("Heyaa!");

    if ($("#VictoryScore").text === "Win: 0") {
	$.Schedule(0.1, SetVictoryScore);
    }
}

(function() {
    $("#VictoryScore").text = "Win: 0";
    GameEvents.Subscribe("victory_score", SetVictoryScore);
})();
