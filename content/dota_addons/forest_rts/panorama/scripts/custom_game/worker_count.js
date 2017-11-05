"use strict";

// Sets the worker count field.
function SetWorkerCount(keys) {
    var maxWorkerCount = keys.maxWorkerCount;
    var workerCount = keys.newWorkerCount;
    $.Msg("Received worker update: (cur/max): "+workerCount + "/" + maxWorkerCount);
    CheckHudFlipped();
    $("#WorkerCount").text = workerCount + " / " + maxWorkerCount;
}

// Moves the clock panel to the correct side of the screen
// if the HUD is flipped.
function CheckHudFlipped() {
    var workerPanel = $.FindChildInContext("#WorkerPanel");

    if (Game.IsHUDFlipped()) {
        workerPanel.RemoveClass("Right");
        workerPanel.AddClass("Flipped");
    } else {
        workerPanel.AddClass("Right");
        workerPanel.RemoveClass("Flipped");
    }
}

(function() {
    $("#WorkerCount").text = "0 / 10";
    GameEvents.Subscribe("new_worker_count", SetWorkerCount);
    CheckHudFlipped();
})();
