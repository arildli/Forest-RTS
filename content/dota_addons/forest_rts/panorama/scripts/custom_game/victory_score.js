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
    $.Msg("Heyaa!");
}

(function() {
    $("#VictoryScore").text = "";
    GameEvents.SendCustomGameEventToServer("get_initial_score", {})
    GameEvents.Subscribe("initial_score_reply", SetInitialScore);
    GameEvents.Subscribe("update_score", UpdateScore);
})();
