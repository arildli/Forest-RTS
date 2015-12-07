"use strict";

// Sets the victory score field.
function SetVictoryScore(keys) {
    $.Msg("Victory score: "+keys.victoryScore);
    $("#VictoryScore").text = "Win: "+keys.victoryScore;
}

(function() {
    $("#VictoryScore").text = "Win: 0";
    GameEvents.Subscribe("victory_score", SetVictoryScore);
})();
