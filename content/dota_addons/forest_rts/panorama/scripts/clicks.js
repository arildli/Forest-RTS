"use strict"
var right_click_repair = CustomNetTables.GetTableValue("building_settings", "right_click_repair").value;

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
    //$.Msg("OnRightButtonPressed!")

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
        //$.Msg("SendCancelCommand from OnRightButtonPressed!")
        if (!pressedShift) SendCancelCommand()

        // Repair rightclick
        if (right_click_repair && IsCustomBuilding(targetIndex) && Entities.GetHealthPercent(targetIndex) < 100 && IsAlliedUnit(targetIndex, mainSelected)) {
            GameEvents.SendCustomGameEventToServer( "building_helper_repair_command", {targetIndex: targetIndex, queue: pressedShift})
            $.Msg("Repairing target...");
            return true
        }
    }

    // Sets rally point for all selected buildings.
    // Added {
    if (selectedEntities.length > 0)
    {
        var clickPos = Game.ScreenXYToWorld(cursor[0], cursor[1]);
        for (var e of selectedEntities)
        {
            if (IsCustomBuilding(e) && Entities.IsControllableByPlayer(e, iPlayerID)) {
                var mouseTarget = GetMouseTarget();
                $.Msg(mouseTarget);
                if (mouseTarget != 0) {
                    GameEvents.SendCustomGameEventToServer("set_rally_point", {pID: iPlayerID, mainSelected: e, clickPos: clickPos, clickTarget: mouseTarget});
                } else {
                    GameEvents.SendCustomGameEventToServer("set_rally_point", {pID: iPlayerID, mainSelected: e, clickPos: clickPos});
                }
            }
        }
    }
    // }

    // Makes a ranged unit try to enter a tower if clicked on.
    // Added {
    if (Entities.IsRangedAttacker(mainSelected) && IsTower(targetIndex)) {
        var ability = Entities.GetAbilityByName(targetIndex, "srts_enter_tower");
        if (ability !== -1 && Entities.GetTeamNumber(mainSelected) === Entities.GetTeamNumber(targetIndex)) {
            GameEvents.SendCustomGameEventToServer("enter_tower", {towerIndex: targetIndex, unitIndex: mainSelected});
        }
    }
    //}

    return false
}

// Handle Left Button events
function OnLeftButtonPressed() {
    //$.Msg("OnLeftButtonPressed!");
    /*var cursor = GameUI.GetScreenWorldPosition(GameUI.GetCursorPosition());
    var output = '';
    for (var property in cursor) {
        output += property + ": " + cursor[property] + ";\n";
    }
    $.Msg(output);*/

    return false
}

// Added {
function IsTower(entIndex) {
    return (Entities.GetAbilityByName(entIndex, "ability_tower") != -1);
}
// }

function IsCustomBuilding(entIndex) {
    return (Entities.GetAbilityByName( entIndex, "ability_building") != -1)
}


function IsBuilder(entIndex) {
    var tableValue = CustomNetTables.GetTableValue( "builders", entIndex.toString())
    return (tableValue !== undefined) && (tableValue.IsBuilder == 1)
}

function IsAlliedUnit(entIndex, targetIndex) {
    return (Entities.GetTeamNumber(entIndex) == Entities.GetTeamNumber(targetIndex))
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
