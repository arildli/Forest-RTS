"use strict";

var waveNumber = 0;
var nextWaveTimer = 0;

var modeStarted = false;

// Moves the panels slightly higher up if flipped.
function CheckHudFlipped() {
    var topPanel = $.FindChildInContext("#WaveInfoPanel");

    if (Game.IsHUDFlipped()) {
        topPanel.RemoveClass("Right");
        topPanel.AddClass("Flipped");
    } else {
        topPanel.AddClass("Right");
        topPanel.RemoveClass("Flipped");
    }
}

function UpdateNextWaveTimerValue() {
    if (nextWaveTimer > 0) {
        --nextWaveTimer;
    }

    SetWaveNumberValue(waveNumber);
    SetNextWaveValue(nextWaveTimer);

    $.Schedule(1.0, UpdateNextWaveTimerValue); 
}

function SetDefaultStartValues() {
    SetWaveNumberValue(0);
    SetNextWaveValue("Not started");
}

function SetWaveNumberValue(value) {
    SetTextSafe($("#WaveInfoPanel"), "WaveNumber", "Wave: " + value + "\n");
}

function SetNextWaveValue(value) {
    SetTextSafe($("#WaveInfoPanel"), "NextWaveTimer", "Next: " + value + "\n");
}

function WaveInfo_Update(keys) {
    $.Msg("Called Update!");

    if (!modeStarted) {
        modeStarted = true;
        UpdateNextWaveTimerValue();
    }

    waveNumber = keys.waveNumber;
    nextWaveTimer = keys.nextWave;

    SetWaveNumberValue(waveNumber);
    SetNextWaveValue(nextWaveTimer);
}

(function() {
    GameEvents.Subscribe("wave_info", WaveInfo_Update);
    SetDefaultStartValues();
})();