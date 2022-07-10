"use strict";



function OnPlayerLumberChanged ( args ) {
    var iPlayerID = Players.GetLocalPlayer()
    var lumber = args.lumber

    CheckHudFlipped();
    $('#LumberText').text = lumber
}

function UpdatePlayerGold() {
    var iPlayerID = Players.GetLocalPlayer()
    var gold = Players.GetGold(iPlayerID)

    CheckHudFlipped();
    $('#GoldText').text = gold
    $.Schedule(0.03, UpdatePlayerGold);
}

(function () {
    CheckHudFlipped();
    GameEvents.Subscribe( "player_lumber_changed", OnPlayerLumberChanged );
})();

// Moves the clock panel to the correct side of the screen
// if the HUD is flipped.
function CheckHudFlipped() {
    var resourcesTitlePanel = $.FindChildInContext("#ResourcesTitlePanel");
    var resourcesPanel = $.FindChildInContext("#Resources");
    var lumberPanel = $.FindChildInContext("#LumberPanel");
    var goldPanel = $.FindChildInContext("#GoldPanel");

    if (Game.IsHUDFlipped()) {
    	lumberPanel.RemoveClass("Right");
    	goldPanel.RemoveClass("Right");
        resourcesPanel.RemoveClass("Right");
        resourcesPanel.RemoveClass("RightShadow");
        resourcesTitlePanel.RemoveClass("Right");
        resourcesTitlePanel.RemoveClass("RightShadow");
    	lumberPanel.AddClass("Flipped");
    	goldPanel.AddClass("Flipped");
        resourcesPanel.AddClass("Flipped");
        resourcesPanel.AddClass("FlippedShadow");
        resourcesTitlePanel.AddClass("Flipped");
    } else {
    	lumberPanel.AddClass("Right");
    	goldPanel.AddClass("Right");
        resourcesPanel.AddClass("Right");
        resourcesPanel.AddClass("RightShadow");
        resourcesTitlePanel.AddClass("Right");
        resourcesTitlePanel.AddClass("RightShadow");
    	lumberPanel.RemoveClass("Flipped");
    	goldPanel.RemoveClass("Flipped");
        resourcesPanel.RemoveClass("Flipped");
        resourcesPanel.RemoveClass("FlippedShadow");
        resourcesTitlePanel.RemoveClass("Flipped");
    }
}

(function () {
    //GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_SHOP, false );
    GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_QUICKBUY, false );
    GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_COURIER, false );
    GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PROTECT, false );
    GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_GOLD, false );
    GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS, false );

    $('#LumberText').text = 0;
    $('#GoldText').text = 0;

    CheckHudFlipped();
    $.Schedule(0.03, UpdatePlayerGold);
})();
