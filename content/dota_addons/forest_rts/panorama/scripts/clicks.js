"use strict"

$.Msg("Using clicks.js!")

function GetMouseTarget()
{
    var mouseEntities = GameUI.FindScreenEntities( GameUI.GetCursorPosition() )
    var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() )

    for ( var e of mouseEntities )
    {
        if ( !e.accurateCollision )
            continue
        return e.entityIndex
    }

    for ( var e of mouseEntities )
    {
        return e.entityIndex
    }

    return 0
}

// Handle Right Button events
function OnRightButtonPressed()
{
    $.Msg("OnRightButtonPressed!")

    var iPlayerID = Players.GetLocalPlayer()
    var selectedEntities = Players.GetSelectedEntities( iPlayerID )
    var mainSelected = Players.GetLocalPlayerPortraitUnit() 
    var targetIndex = GetMouseTarget()
    var pressedShift = GameUI.IsShiftDown()
    
    // Added {
    var cursor = GameUI.GetCursorPosition();
    // }

    // Builder Right Click
    if ( IsBuilder( mainSelected ) )
    {
        // Cancel BH
        $.Msg("SendCancelCommand from OnRightButtonPressed!")
        if (!pressedShift) SendCancelCommand()
    }

    // Sets rally point for all selected buildings.
    // Added {
    if (selectedEntities.length > 0)
    {
        var clickPos = Game.ScreenXYToWorld(cursor[0], cursor[1]);
        for (var e of selectedEntities)
        {
            if (IsCustomBuilding(e) && Entities.IsControllableByPlayer(e, iPlayerID)) {
                GameEvents.SendCustomGameEventToServer("set_rally_point", {pID: iPlayerID, mainSelected: e, clickPos: clickPos});
            }
        }
    }
    // }

    return false
}

// Handle Left Button events
function OnLeftButtonPressed() {
    $.Msg("OnLeftButtonPressed!")

    return false
}

function IsBuilder(entIndex) {
    var tableValue = CustomNetTables.GetTableValue( "builders", entIndex.toString())
    return (tableValue !== undefined) && (tableValue.IsBuilder == 1)
}

// Main mouse event callback
GameUI.SetMouseCallback( function( eventName, arg ) {
    var CONSUME_EVENT = true
    var CONTINUE_PROCESSING_EVENT = false
    var LEFT_CLICK = (arg === 0)
    var RIGHT_CLICK = (arg === 1)

    if ( GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE )
        return CONTINUE_PROCESSING_EVENT

    var mainSelected = Players.GetLocalPlayerPortraitUnit()

    if ( eventName === "pressed" || eventName === "doublepressed")
    {
        // Builder Clicks
        if (IsBuilder(mainSelected))
            if (LEFT_CLICK) 
                return (state == "active") ? SendBuildCommand() : OnLeftButtonPressed()
            else if (RIGHT_CLICK) 
                return OnRightButtonPressed()

        if (LEFT_CLICK) 
            return OnLeftButtonPressed()
        else if (RIGHT_CLICK) 
            return OnRightButtonPressed() 
        
    }
    return CONTINUE_PROCESSING_EVENT
} )

// Added {
function IsCustomBuilding( entityIndex ){
    var ability_building = Entities.GetAbilityByName( entityIndex, "ability_building")
    var ability_tower = Entities.GetAbilityByName( entityIndex, "ability_tower")
    return (ability_building != -1 || ability_tower != -1)
}
// }
