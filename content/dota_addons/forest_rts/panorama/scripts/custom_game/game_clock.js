"use strict";

// Updates the game clock.
function UpdateClock() {
    var dotaTime = Game.GetDOTATime(false, true);
    var seconds = dotaTime.toFixed(0);
    var minutes = Math.floor(seconds / 60);
    seconds = seconds % 60;

    if (minutes == -1) {
	minutes = "-0";
    }
    var clockText = minutes + ":";
    
    if (Math.abs(seconds) < 10) {
	clockText = clockText+"0";
    }
    if (seconds < 0) {
	clockText = clockText + Math.abs(seconds);
    } else {
	clockText = clockText + seconds;
    }

    CheckHudFlipped();
    $("#ClockTime").text = clockText;
    $.Schedule(0.1, UpdateClock); 
}

// Moves the clock panel to the correct side of the screen
// if the HUD is flipped.
function CheckHudFlipped() {
    var clockPanel = $.FindChildInContext("#ClockPanel");
    
    if (Game.IsHUDFlipped()) {
	clockPanel.RemoveClass("Right");
	clockPanel.AddClass("Flipped");
    } else {
	clockPanel.AddClass("Right");
	clockPanel.RemoveClass("Flipped");
    }
}

(function() {
    $.Msg("It really is on!");
    UpdateClock();
    CheckHudFlipped();
})();
