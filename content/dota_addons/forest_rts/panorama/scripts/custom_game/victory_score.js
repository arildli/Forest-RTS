"use strict";

var victoryScore = "";

// Sets the victory score field.
function SetVictoryScore(keys) {
    victoryScore = keys.victoryScore;

    $("#VictoryScore").text = "Win: "+keys.victoryScore;    
    /*if ($("#VictoryScore").text === "") {
	$.Schedule(0.1, SetVictoryScore);
    }*/
}

(function() {
    $("#VictoryScore").text = "Win: 0";
    GameEvents.Subscribe("victory_score", SetVictoryScore);
})();
