"use strict";

/*
  Contains the code necessary to make the scoreboard on top work as wanted.
  
  This code is mostly taken from Pimp My Peon, with some small adjustments.
  Credit to MNoya for writing the original code.
*/



var scoreboard = {};

// Get panel for team.
function Scoreboard_GetTeamPanel(scoreboardPanel, teamId) {
    var teamPanelName = "_dynamic_team_" + teamId;
    return scoreboardPanel.FindChild(teamPanelName);
}

// Update the score of the specified team.
function Scoreboard_SetTeamScore(teamId, newScore) {
    var teamDetails = Game.GetTeamDetails(teamId);
    if (!teamDetails) {
	print("ERROR (Scoreboard_UpdateTeamScore): Couldn't get details for team!");
	return false;
    }
    teamDetails.team_score = newScore;
    print("team: " + teamId + "\tnew score: " + teamDetails.team_score);
}

// Update the text of a panel.
function Scoreboard_SetTextSafe(panel, childName, textValue) {
    if (panel === null) {
	return;
    }
    var childPanel = panel.FindChildInLayoutFile(childName);
    if (childPanel === null) {
	return;
    }
    childPanel.text = textValue;
}



// Update panel for player.
function Scoreboard_UpdatePlayerPanel(scoreboardConfig, scoreboardPanel, playerId, localPlayerTeamId) {
    var playerPanelName = "_dynamic_player_" + playerId;
    var playerPanel = scoreboardPanel.FindChild(playerPanelName);
    
    // Create new panel if it doesn't exist.
    if (playerPanel === null) {
	playerPanel = $.CreatePanel("Panel", scoreboardPanel, playerPanelName);
	playerPanel.SetAttributeInt("player_id", playerId);
	playerPanel.BLoadLayout(scoreboardConfig.playerXmlName, false, false);
    }
    
    var isTeammate = false;
    var playerInfo = Game.GetPlayerInfo(playerId);
    if (playerInfo) {
	isTeammate = (playerInfo.player_team_id == localPlayerTeamId);

	playerPanel.SetHasClass("is_local_player", (playerId == Game.GetLocalPlayerID()));
	playerPanel.SetHasClass("player_dead", (playerInfo.player_respawn_seconds >= 0));
	playerPanel.SetHasClass("local_player_teammate", isTeammate && (playerId != Game.GetLocalPlayerID()));
	
	/*
	Scoreboard_SetTextSafe(playerPanel, "PlayerName", playerInfo.player_name);
	Scoreboard_SetTextSafe(playerPanel, "Level", playerInfo.player_level);
	Scoreboard_SetTextSafe(playerPanel, "Kills", playerInfo.player_kills);
	Scoreboard_SetTextSafe(playerPanel, "Deaths", playerInfo.player_deaths);
	Scoreboard_SetTextSafe(playerPanel, "Assists", playerInfo.player_assists);
	*/

	// Set player portrait.
	var playerPortrait = playerPanel.FindChildInLayoutFile("HeroIcon");
	if (playerPortrait) {
	    if (playerInfo.player_selected_hero !== "") {
		var hero = playerInfo.player_selected_hero;
		playerPortrait.SetImage("file://{images}/heroes/" + hero + ".png");
	    } else {
		playerPortrait.SetImage("file://{images}/custom_game/unassigned.png");
	    }
	}

	if (playerInfo.player_selected_hero_id == -1) {
	    Scoreboard_SetTextSafe(playerPanel, "HeroName", $.Localize("#DOTA_Scoreboard_Picking_Hero"));
	} else {
	    Scoreboard_SetTextSafe(playerPanel, "HeroName", $.Localize("#"+playerInfo.player_selected_hero));
	}

	// Update portrait if player dc.
	playerPanel.SetHasClass( "player_connection_abandoned", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED );
	playerPanel.SetHasClass( "player_connection_failed", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_FAILED );
	playerPanel.SetHasClass( "player_connection_disconnected", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED );
	
	// Add player color bar.
	var playerColorBar = playerPanel.FindChildInLayoutFile("PlayerColorBar");
	if (playerColorBar !== null) {
	    if (GameUI.CustomUIConfig().team_colors) {
		var teamColor = GameUI.CustomUIConfig().team_colors[playerInfo.player_team_id];
		if (teamColor) {
		    playerColorBar.style.backgroundColor = teamColor;
		}
	    } else {
		var playerColor = "#000000";
		playerColorBar.style.backgroundColor = playerColor;
	    }
	}
    }
}

// Update panel for team.
function Scoreboard_UpdateTeamPanel(scoreboardConfig, scoreboardPanel, teamDetails, teamsInfo) {
    if (!scoreboardPanel) {
	return;
    }

    var teamId = teamDetails.team_id;
    var teamPanelName = "_dynamic_team_" + teamId;
    var teamPanel = Scoreboard_GetTeamPanel(scoreboardPanel, teamId);

    // Create new panel if it doesn't exist.
    if (teamPanel === null) {
	teamPanel = $.CreatePanel("Panel", scoreboardPanel, teamPanelName);
	teamPanel.SetAttributeInt("team_id", teamId);
	teamPanel.BLoadLayout(scoreboardConfig.teamXmlName, false, false);

	var logoXml = GameUI.CustomUIConfig().team_logo_xml;
	if (logoXml) {
	    var teamLogoPanel = teamPanel.FindChildInLayoutFile("TeamLogo");
	    if (teamLogoPanel) {
		teamLogoPanel.SetAttributeInt("team_id", teamId);
		teamLogoPanel.BLoadLayout(logoXml, false, false);
	    }
	}
    }

    // Add local team effect.
    var localPlayerTeamId = -1;
    var localPlayer = Game.GetLocalPlayerInfo();
    if (localPlayer) {
	localPlayerTeamId = localPlayer.player_team_id;
    }
    teamPanel.SetHasClass("local_player_team", localPlayerTeamId == teamId);
    teamPanel.SetHasClass("not_local_player_team", localPlayerTeamId != teamId);
    
    // Update the panel for each player in the team.
    var teamPlayers = Game.GetPlayerIDsOnTeam(teamId);
    var playersContainer = teamPanel.FindChildInLayoutFile("PlayersContainer");
    if (playersContainer) {
	for (var playerId of teamPlayers) {
	    Scoreboard_UpdatePlayerPanel(scoreboardConfig, playersContainer, playerId, localPlayerTeamId);
	}
    }

    teamPanel.SetHasClass("no_players", (teamPlayers.length == 0));
    teamPanel.SetHasClass("one_player", (teamPlayers.length == 1));

    if (teamsInfo.max_team_players < teamPlayers.length) {
	teamsInfo.max_team_players = teamPlayers.length;
    }

    // Update score and name of the team.
    Scoreboard_SetTextSafe(teamPanel, "TeamScore", teamDetails.team_score);
    Scoreboard_SetTextSafe(teamPanel, "TeamName", $.Localize(teamDetails.team_name));

    // Set team color.
    if (GameUI.CustomUIConfig().team_colors) {
	var teamColor = GameUI.CustomUIConfig().team_colors[teamId];
	teamColor = teamColor.replace(";", "");
	var teamColorPanel = teamPanel.FindChildInLayoutFile("TeamColor");
	if (teamColorPanel) {
	    teamNamePanel.style.backgroundColor = teamColor + ";";
	}

	var teamColor_GradentFromTransparentLeft = teamPanel.FindChildInLayoutFile("TeamColor_GradentFromTransparentLeft");
	if (teamColor_GradentFromTransparentLeft) {
	    var gradientText = 'gradient(linear, 0% 0%, 800% 0%, from(#00000000), to('+teamColor+'));';
	    teamColor_GradentFromTransparentLeft.style.backgroundColor = gradientText;
	}
    }
    
    return teamPanel;
}

// Updates the whole scoreboard.
function Scoreboard_UpdateScoreboard() {
    // Get info about teams and create team panels.
    var teamsDetails = [];
    for (var teamId of Game.GetAllTeamIDs()) {
	teamsDetails.push(Game.GetTeamDetails(teamId));
	//printObject(Game.GetTeamDetails(teamId), "Game.GetTeamDetails(teamId)");
    }
    var teamsInfo = {maxTeamPlayers: 0};
    var teamsPanels = [];
    for (var i = 0; i < teamsDetails.length; i++) {
	var curTeamPanel = Scoreboard_UpdateTeamPanel(scoreboard.config, scoreboard.scorePanel, teamsDetails[i], teamsInfo);
	if (curTeamPanel) {
	    teamsPanels[teamsDetails[i].team_id] = curTeamPanel;
	}
    }
    print("Updated scoreboard!");

    // Add code here for sorting if it's needed.
}

// Set default settings and set up the panels.
function Scoreboard_InitializeScoreboard() {
    // Add files to the each side of the scoreboard if set.
    if (GameUI.CustomUIConfig().multiteam_top_scoreboard) {
	var cfg = GameUI.CustomUIConfig().multiteam_top_scoreboard;
	if (cfg.LeftInjextXMLFile) {
	    $("#LeftInjectXMLFile").BLoadLayout(cfg.LeftInjectXMLFile, false, false);
	}
	if (cfg.RightInjextXMLFile) {
	    $("#RightInjectXMLFile").BLoadLayout(cfg.RightInjectXMLFile, false, false);
	}
    }

    GameUI.CustomUIConfig().scoreboard = {};
    scoreboard = GameUI.CustomUIConfig().scoreboard;

    // Set config that should be used for the scoreboard.
    scoreboard.config = {
	"teamXmlName": "file://{resources}/layout/custom_game/multiteam_top_scoreboard_team.xml",
	"playerXmlName": "file://{resources}/layout/custom_game/multiteam_top_scoreboard_player.xml",
	"sort": false
    };
    scoreboard.scorePanel = $("#MultiteamScoreboard");
    if (!scoreboard.scorePanel) {
	print("ERROR (Scoreboard): Couldn't get #MultiteamScoreboard!");
    }
    
    Scoreboard_UpdateScoreboard();
}



// -----| Event functions |----- \\

// Update the score for the specified team.
function Scoreboard_NewTeamScore(keys) {
    print("Updated score!");
    Scoreboard_SetTeamScore(keys.teamId, keys.score);
}



(function () {
    Scoreboard_InitializeScoreboard();

    GameEvents.Subscribe("new_team_score", Scoreboard_NewTeamScore);
    GameEvents.Subscribe("updated_team_scores", Scoreboard_UpdateScoreboard);
})();


























function Test() {
    // Set Score to a certain amount for team 2:
    // Remember to copy SetTextSafe and use it to find the exact panel
    var teamID = 2;
    var team2PanelName = "#_dynamic_team_" + teamID
    var teamPanel = $.Localize(team2PanelName);
    //printObject(GameUI.CustomUIConfig().multiteam_top_scoreboard, "GameUI");
    /*
    var contextPanel = $.GetContextPanel();
    //var objectData = printObject(contextPanel, "ContextPanel");
    var teamPanel = contextPanel.FindChild(team2PanelName);
    if(teamPanel)
	print("TeamPanel found!!!");
    else
	print("TeamPanel was NOT found...");
    
    print("ChildCount of contextPanel: " + contextPanel.GetChildCount());
    var children = contextPanel.Children();
    printObject(children, "Children of ContextPanel");
    print("Length: " + children.length);
    printObject(GameUI.CustomUIConfig(), "GameUI", true);
    var scoreLabel = teamPanel.findChildInLayoutFile("TeamScore"); // id
    if(scoreLabel) {
	$.Msg("scoreLabel is undefined!");
    }else{
	$.Msg("scoreLabel was NOT undefined!");
    }*/
}


/*
//=============================================================================
//=============================================================================
function _Scoreboard_SetText( panel, childName, textValue ) {
    if ( panel === null ) {
	return;
    }
    var childPanel = panel.findChildInLayoutFile( childName );
    if ( childPanel === null ) {
	return;
    }
}

//=============================================================================
//=============================================================================
function _Scoreboard_UpdateTeamPanel( ) {
    
}

//=============================================================================
//=============================================================================
function UpdateScore( args ) {
    $('#GoldText').text = args.radiant;
    $('#LumberText').text = args.dire;
}

(function() {
    GameEvents.Subscribe("updated_team_scores", UpdateScore);
    scoreboardInfo.scoreboardConfig = {
	"teamXmlName" : "file://{resources}/layout/custom_game/multiteam_top_scoreboard_team.xml" 
    };
    scoreboardInfo.teamIDs = []
    for ( var teamId of Game.GetAllTeamIDs() ) {
	scoreboardInfo.teamsList.push( teamId );
    }
 //   $('#GoldText').text = 99999;
//    $('#LumberText').text = 99999;
})();
*/






/*
(function()
{
	if ( GameUI.CustomUIConfig().multiteam_top_scoreboard )
	{
		var cfg = GameUI.CustomUIConfig().multiteam_top_scoreboard;
		if ( cfg.LeftInjectXMLFile )
		{
			$( "#LeftInjectXMLFile" ).BLoadLayout( cfg.LeftInjectXMLFile, false, false );
		}
		if ( cfg.RightInjectXMLFile )
		{
			$( "#RightInjectXMLFile" ).BLoadLayout( cfg.RightInjectXMLFile, false, false );
		}
	}
	
	if ( ScoreboardUpdater_InitializeScoreboard === null ) { $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." ); }

	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/multiteam_top_scoreboard_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/multiteam_top_scoreboard_player.xml",
	};
	g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#MultiteamScoreboard" ) );

	UpdateScoreboard();
})();*/
