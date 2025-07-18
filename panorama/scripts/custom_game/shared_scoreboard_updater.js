"use strict";
/*
CustomNetTables.SubscribeNetTableListener("rd_skills", OnNettable2Changed);

function OnNettable2Changed(table_name, key, data) {
    $.Msg("Table ", table_name, " changed: '", key, "' = ", data);
}
*/
//=============================================================================
//=============================================================================


function _ScoreboardUpdater_SetTextSafe(panel, childName, textValue) {
    if (panel === null)
        return;
    var childPanel = panel.FindChildInLayoutFile(childName)
    if (childPanel === null)
        return;

    childPanel.text = textValue;
}

function Get_RDSK(panel, childName, id) {
    if (panel === null)
        return;
    var childPanel = panel.FindChildInLayoutFile(childName)
    if (childPanel === null)
        return;
    var ab = CustomNetTables.GetTableValue("rd_skills", "RDSK")
    if (ab != null && ab[id] != null) {
        childPanel.abilityname = ab[id];
        childPanel.SetPanelEvent('onmouseover', function() {
            $.DispatchEvent("DOTAShowAbilityTooltip", childPanel, childPanel.abilityname);
        });
        childPanel.SetPanelEvent('onmouseout', function() {
            $.DispatchEvent("DOTAHideAbilityTooltip", childPanel);
        });

        childPanel.SetPanelEvent('onactivate', function() {
            if (Players.IsSpectator(id)) { return }
            var hero = Players.GetPlayerSelectedHero(id);
            GameEvents.SendCustomGameEventToServer("OnAbility_Show", { hero: hero, id: id, });
        });
    }
}

function Get_Profile(panel, childName, id, steamid) {
    if (panel === null)
        return;
    var childPanel = panel.FindChildInLayoutFile(childName)
    if (childPanel === null)
        return;
	
    //childPanel.SetPanelEvent('onactivate', function() {
        //$.DispatchEvent("DOTAShowProfilePage", steamid);
   // });
    childPanel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent("DOTAShowProfileCardTooltip", steamid, true);
    });
    childPanel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent("DOTAHideProfileCardTooltip");
    });

}

//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdatePlayerPanel(scoreboardConfig, playersContainer, playerId, localPlayerTeamId) {
    $.Msg("UpdatePlayerPanel ", scoreboardConfig, " changed: '", playerId, "' = ");
    var playerPanelName = "_dynamic_player_" + playerId;
    var playerPanel = playersContainer.FindChild(playerPanelName);
    if (playerPanel === null) {
        playerPanel = $.CreatePanel("Panel", playersContainer, playerPanelName);
        playerPanel.SetAttributeInt("player_id", playerId);
        playerPanel.BLoadLayout(scoreboardConfig.playerXmlName, false, false);
    }

    playerPanel.SetHasClass("is_local_player", (playerId == Game.GetLocalPlayerID()));

    var ultStateOrTime = PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_HIDDEN; // values > 0 mean on cooldown for that many seconds
    var goldValue = -1;
    var isTeammate = false;
    //player_selected_hero_entity_index
    var playerInfo = Game.GetPlayerInfo(playerId);

    if (playerInfo) {
        isTeammate = (playerInfo.player_team_id == localPlayerTeamId);
        if (isTeammate) {
            ultStateOrTime = Game.GetPlayerUltimateStateOrTime(playerId);
        }
        goldValue = playerInfo.player_gold;

        playerPanel.SetHasClass("player_dead", (playerInfo.player_respawn_seconds >= 0));
        playerPanel.SetHasClass("local_player_teammate", isTeammate && (playerId != Game.GetLocalPlayerID()));

        _ScoreboardUpdater_SetTextSafe(playerPanel, "RespawnTimer", (playerInfo.player_respawn_seconds + 1)); // value is rounded down so just add one for rounded-up
        _ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerName", playerInfo.player_name);
        _ScoreboardUpdater_SetTextSafe(playerPanel, "Level", playerInfo.player_level);
        _ScoreboardUpdater_SetTextSafe(playerPanel, "Kills", playerInfo.player_kills);
        _ScoreboardUpdater_SetTextSafe(playerPanel, "Deaths", playerInfo.player_deaths);
        _ScoreboardUpdater_SetTextSafe(playerPanel, "Assists", playerInfo.player_assists);
        Get_RDSK(playerPanel, "RDSKButton", playerId);
        Get_Profile(playerPanel, "HeroIcon", playerId, playerInfo.player_steamid);
        var playerPortrait = playerPanel.FindChildInLayoutFile("HeroIcon");
        if (playerPortrait) {
            if (playerInfo.player_selected_hero !== "") {
                playerPortrait.SetImage("file://{images}/heroes/" + playerInfo.player_selected_hero + ".png");
            } else {
                playerPortrait.SetImage("file://{images}/custom_game/unassigned.png");
            }
        }

        if (playerInfo.player_selected_hero_id == -1) {
            _ScoreboardUpdater_SetTextSafe(playerPanel, "HeroName", $.Localize("#DOTA_Scoreboard_Picking_Hero"))
        } else {
            _ScoreboardUpdater_SetTextSafe(playerPanel, "HeroName", $.Localize("#" + playerInfo.player_selected_hero))
        }

        var heroNameAndDescription = playerPanel.FindChildInLayoutFile("HeroNameAndDescription");
        if (heroNameAndDescription) {
            if (playerInfo.player_selected_hero_id == -1) {
                heroNameAndDescription.SetDialogVariable("hero_name", $.Localize("#DOTA_Scoreboard_Picking_Hero"));
            } else {
                heroNameAndDescription.SetDialogVariable("hero_name", $.Localize("#" + playerInfo.player_selected_hero));
            }
            heroNameAndDescription.SetDialogVariableInt("hero_level", playerInfo.player_level);
        }

        playerPanel.SetHasClass("player_connection_abandoned", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED);
        playerPanel.SetHasClass("player_connection_failed", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_FAILED);
        playerPanel.SetHasClass("player_connection_disconnected", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED);

        var playerAvatar = playerPanel.FindChildInLayoutFile("AvatarImage");
        if (playerAvatar) {
            playerAvatar.steamid = playerInfo.player_steamid;
        }

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

    var playerItemsContainer = playerPanel.FindChildInLayoutFile("PlayerItemsContainer");
    if (playerItemsContainer) {
        var playerItems = Game.GetPlayerItems(playerId);
        if (playerItems) {
            //		$.Msg( "playerItems = ", playerItems );
            for (var i = playerItems.inventory_slot_min; i < 6; ++i) {
                var itemPanelName = "_dynamic_item_" + i;
                var itemPanel = playerItemsContainer.FindChild(itemPanelName);
                if (itemPanel === null) {
					if (playerItems.inventory[i]) {
                    itemPanel = $.CreatePanel("DOTAItemImage", playerItemsContainer, itemPanelName);
					itemPanel.itemname = playerItems.inventory[i].item_name
					}else
					{
                    itemPanel = $.CreatePanel("DOTAItemImage", playerItemsContainer, itemPanelName);
					itemPanel.itemname = "life_stealer_empty_1"
					}
                }

            }

        }
    }
	
	var playerItemsContainer = playerPanel.FindChildInLayoutFile("PlayerBackbagContainer");
    if (playerItemsContainer) {
        var playerItems = Game.GetPlayerItems(playerId);
        if (playerItems) {
            //		$.Msg( "playerItems = ", playerItems );
            for (var i = 6; i < playerItems.inventory_slot_max; ++i) {
                var itemPanelName = "_dynamic_item_" + i;
                var itemPanel = playerItemsContainer.FindChild(itemPanelName);
                if (itemPanel === null) {
					if (playerItems.inventory[i]) {
                    itemPanel = $.CreatePanel("DOTAItemImage", playerItemsContainer, itemPanelName);
					itemPanel.itemname = playerItems.inventory[i].item_name
					}else
					{
                    itemPanel = $.CreatePanel("DOTAItemImage", playerItemsContainer, itemPanelName);
					itemPanel.itemname = "life_stealer_empty_1"
					}
                }

            }

        }
    }
	
	var playerNeutraContainer = playerPanel.FindChildInLayoutFile("PlayerNeutraContainer");
	if (playerNeutraContainer) {
		var playerItems = Game.GetPlayerItems(playerId);
		
        var extra_item_1 = CustomNetTables.GetTableValue("extra_item", playerId.toString()).extra_1;
		var extra_item_2 = CustomNetTables.GetTableValue("extra_item", playerId.toString()).extra_2;
		var extra_item = [extra_item_1,extra_item_2]

		 for (var i = 0; i < extra_item.length; i++) {
					var itemPanelName = "_dynamic_item_neutra" +i;
					var itemPanel = playerNeutraContainer.FindChild(itemPanelName);
					if (itemPanel === null) {
						if (extra_item[i]==="") {
						itemPanel = $.CreatePanel("DOTAAbilityImage", playerNeutraContainer, itemPanelName);
						itemPanel.AddClass("ability");
						itemPanel.abilityname = "";
						}else
						{

						
						itemPanel = $.CreatePanel("DOTAItemImage", playerNeutraContainer, itemPanelName);
						itemPanel.itemname = extra_item[i].toString()
						}
					}
		 }

        }

	
    var rdAbilityContainer = playerPanel.FindChildInLayoutFile("RdAbilityContainer");
    if (rdAbilityContainer) {
        var playerItems = Game.GetPlayerItems(playerId);
        if (playerItems) {
			var ab = CustomNetTables.GetTableValue("rd_skills", "RDSK");
			if (ab != null && ab[playerId] != null) {
				var rdabilityPanel = rdAbilityContainer.FindChild("RA_END");
                if (rdabilityPanel === null) {
                    rdabilityPanel = $.CreatePanel("DOTAAbilityImage", rdAbilityContainer, "RA_END");
					rdabilityPanel.AddClass("ability");
					rdabilityPanel.abilityname = ab[playerId];
					rdabilityPanel.SetPanelEvent('onmouseover', function() {
						$.DispatchEvent("DOTAShowAbilityTooltip", rdabilityPanel, rdabilityPanel.abilityname);
					});
					rdabilityPanel.SetPanelEvent('onmouseout', function() {
						$.DispatchEvent("DOTAHideAbilityTooltip", rdabilityPanel);
					});
                }
			}

        }
    }

    if (isTeammate) {
        _ScoreboardUpdater_SetTextSafe(playerPanel, "TeammateGoldAmount", goldValue);
    }

    _ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerGoldAmount", goldValue);

    playerPanel.SetHasClass("player_ultimate_ready", (ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_READY));
    playerPanel.SetHasClass("player_ultimate_no_mana", (ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NO_MANA));
    playerPanel.SetHasClass("player_ultimate_not_leveled", (ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NOT_LEVELED));
    playerPanel.SetHasClass("player_ultimate_hidden", (ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_HIDDEN));
    playerPanel.SetHasClass("player_ultimate_cooldown", (ultStateOrTime > 0));
    _ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerUltimateCooldown", ultStateOrTime);
}


//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdateTeamPanel(scoreboardConfig, containerPanel, teamDetails, teamsInfo) {
    if (!containerPanel)
        return;

    var teamId = teamDetails.team_id;
    //	$.Msg( "_ScoreboardUpdater_UpdateTeamPanel: ", teamId );

    var teamPanelName = "_dynamic_team_" + teamId;
    var teamPanel = containerPanel.FindChild(teamPanelName);
    if (teamPanel === null) {
        //		$.Msg( "UpdateTeamPanel.Create: ", teamPanelName, " = ", scoreboardConfig.teamXmlName );
        teamPanel = $.CreatePanel("Panel", containerPanel, teamPanelName);
        teamPanel.SetAttributeInt("team_id", teamId);
        teamPanel.BLoadLayout(scoreboardConfig.teamXmlName, false, false);
        teamPanel.style.backgroundSize = "100%";
        teamPanel.style.backgroundRepeat = "no-repeat";
        teamPanel.style.backgroundPosition = "50% 50%";
        teamPanel.style.border = "5px solid #000000";
        var logo_xml = GameUI.CustomUIConfig().team_logo_xml;
        var teamnme = "";
        if (logo_xml) {
            var teamLogoPanel = teamPanel.FindChildInLayoutFile("TeamLogo");
            if (teamLogoPanel) {
                teamLogoPanel.SetAttributeInt("team_id", teamId);
                teamLogoPanel.BLoadLayout(logo_xml, false, false);
                switch (teamId) {
                    case 2:
                        teamPanel.style.backgroundImage = "url('file://{images}/custom_game/bg/bg2.jpg')";
                        teamLogoPanel.style.backgroundImage = "url('file://{images}/custom_game/hud/good.png')"; 
                        teamnme = "老狗队"; 
                        break;
                    case 3:
                        teamPanel.style.backgroundImage = "url('file://{images}/custom_game/bg/bg10.jpg')";
                        teamLogoPanel.style.backgroundImage = "url('file://{images}/custom_game/hud/bad.png')";
                        teamnme = "老鹿队";
                        break;
                    case 6:
                        teamPanel.style.backgroundImage = "url('file://{images}/custom_game/bg/bg10.jpg')";
                        teamLogoPanel.style.backgroundImage = "url('file://{images}/custom_game/team_icons/team_icon_rooster_01.png')";
                        teamnme = "然然队";
                        break;
                    default:
                        teamPanel.style.backgroundImage = "url('file://{images}/custom_game/bg/bg10.jpg')";
                        teamLogoPanel.style.backgroundImage = "url('file://{images}/custom_game/team_icons/team_icon_rooster_01.png')";
                        teamnme = "然然队";
                        break;
                }
                teamLogoPanel.SetPanelEvent('onmouseover', function() {
                    $.DispatchEvent("DOTAShowTextTooltip", teamnme);
                });
                teamLogoPanel.SetPanelEvent('onmouseout', function() {
                    $.DispatchEvent("DOTAHideTextTooltip");
                });
            }
        }
    }

    var localPlayerTeamId = -1;
    var localPlayer = Game.GetLocalPlayerInfo();
    if (localPlayer) {
        localPlayerTeamId = localPlayer.player_team_id;
    }
    teamPanel.SetHasClass("local_player_team", localPlayerTeamId == teamId);
    teamPanel.SetHasClass("not_local_player_team", localPlayerTeamId != teamId);

    var teamPlayers = Game.GetPlayerIDsOnTeam(teamId)
    var playersContainer = teamPanel.FindChildInLayoutFile("PlayersContainer");
    if (playersContainer) {
        for (var playerId of teamPlayers) {
            _ScoreboardUpdater_UpdatePlayerPanel(scoreboardConfig, playersContainer, playerId, localPlayerTeamId)
        }
    }

    teamPanel.SetHasClass("no_players", (teamPlayers.length == 0))
    teamPanel.SetHasClass("one_player", (teamPlayers.length == 1))

    if (teamsInfo.max_team_players < teamPlayers.length) {
        teamsInfo.max_team_players = teamPlayers.length;
    }

    _ScoreboardUpdater_SetTextSafe(teamPanel, "TeamScore", teamDetails.team_score)
    _ScoreboardUpdater_SetTextSafe(teamPanel, "TeamName", $.Localize(teamDetails.team_name))

    if (GameUI.CustomUIConfig().team_colors) {
        var teamColor = GameUI.CustomUIConfig().team_colors[teamId];
        var teamColorPanel = teamPanel.FindChildInLayoutFile("TeamColor");

        teamColor = teamColor.replace(";", "");

        if (teamColorPanel) {
            teamNamePanel.style.backgroundColor = teamColor + ";";
        }

        var teamColor_GradentFromTransparentLeft = teamPanel.FindChildInLayoutFile("TeamColor_GradentFromTransparentLeft");
        if (teamColor_GradentFromTransparentLeft) {
            var gradientText = 'gradient( linear, 0% 0%, 800% 0%, from( #00000000 ), to( ' + teamColor + ' ) );';
            //			$.Msg( gradientText );
            teamColor_GradentFromTransparentLeft.style.backgroundColor = gradientText;
        }
    }

    return teamPanel;
}

//=============================================================================
//=============================================================================
function _ScoreboardUpdater_ReorderTeam(scoreboardConfig, teamsParent, teamPanel, teamId, newPlace, prevPanel) {
    //	$.Msg( "UPDATE: ", GameUI.CustomUIConfig().teamsPrevPlace );
    var oldPlace = null;
    if (GameUI.CustomUIConfig().teamsPrevPlace.length > teamId) {
        oldPlace = GameUI.CustomUIConfig().teamsPrevPlace[teamId];
    }
    GameUI.CustomUIConfig().teamsPrevPlace[teamId] = newPlace;

    if (newPlace != oldPlace) {
        //		$.Msg( "Team ", teamId, " : ", oldPlace, " --> ", newPlace );
        teamPanel.RemoveClass("team_getting_worse");
        teamPanel.RemoveClass("team_getting_better");
        if (newPlace > oldPlace) {
            teamPanel.AddClass("team_getting_worse");
        } else if (newPlace < oldPlace) {
            teamPanel.AddClass("team_getting_better");
        }
    }

    // teamsParent.MoveChildAfter(teamPanel, prevPanel);
}

// sort / reorder as necessary
function compareFunc(a, b) // GameUI.CustomUIConfig().sort_teams_compare_func;
{
    if (a.team_score < b.team_score) {
        return 1; // [ B, A ]
    } else if (a.team_score > b.team_score) {
        return -1; // [ A, B ]
    } else {
        return 0;
    }
};

function stableCompareFunc(a, b) {
    var unstableCompare = compareFunc(a, b);
    if (unstableCompare != 0) {
        return unstableCompare;
    }

    if (GameUI.CustomUIConfig().teamsPrevPlace.length <= a.team_id) {
        return 0;
    }

    if (GameUI.CustomUIConfig().teamsPrevPlace.length <= b.team_id) {
        return 0;
    }

    //			$.Msg( GameUI.CustomUIConfig().teamsPrevPlace );

    var a_prev = GameUI.CustomUIConfig().teamsPrevPlace[a.team_id];
    var b_prev = GameUI.CustomUIConfig().teamsPrevPlace[b.team_id];
    if (a_prev < b_prev) // [ A, B ]
    {
        return -1; // [ A, B ]
    } else if (a_prev > b_prev) // [ B, A ]
    {
        return 1; // [ B, A ]
    } else {
        return 0;
    }
};

//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdateAllTeamsAndPlayers(scoreboardConfig, teamsContainer) {
    //	$.Msg( "_ScoreboardUpdater_UpdateAllTeamsAndPlayers: ", scoreboardConfig );

    var teamsList = [];
    for (var teamId of Game.GetAllTeamIDs()) {
        teamsList.push(Game.GetTeamDetails(teamId));
    }

    // update/create team panels
    var teamsInfo = { max_team_players: 0 };
    var panelsByTeam = [];
    for (var i = 0; i < teamsList.length; ++i) {
        var teamPanel = _ScoreboardUpdater_UpdateTeamPanel(scoreboardConfig, teamsContainer, teamsList[i], teamsInfo);
        if (teamPanel) {
            panelsByTeam[teamsList[i].team_id] = teamPanel;
        }
    }

    if (teamsList.length > 1) {
        //		$.Msg( "panelsByTeam: ", panelsByTeam );

        // sort
        if (scoreboardConfig.shouldSort) {
            teamsList.sort(stableCompareFunc);
        }

        //		$.Msg( "POST: ", teamsAndPanels );

        // reorder the panels based on the sort
        var prevPanel = panelsByTeam[teamsList[0].team_id];
        for (var i = 0; i < teamsList.length; ++i) {
            var teamId = teamsList[i].team_id;
            var teamPanel = panelsByTeam[teamId];
            _ScoreboardUpdater_ReorderTeam(scoreboardConfig, teamsContainer, teamPanel, teamId, i, prevPanel);
            prevPanel = teamPanel;
        }
        //		$.Msg( GameUI.CustomUIConfig().teamsPrevPlace );
    }

    //	$.Msg( "END _ScoreboardUpdater_UpdateAllTeamsAndPlayers: ", scoreboardConfig );
}


//=============================================================================
//=============================================================================
function ScoreboardUpdater_InitializeScoreboard(scoreboardConfig, scoreboardPanel) {
    GameUI.CustomUIConfig().teamsPrevPlace = [];
    if (typeof(scoreboardConfig.shouldSort) === 'undefined') {
        // default to true
        scoreboardConfig.shouldSort = true;
    }
    _ScoreboardUpdater_UpdateAllTeamsAndPlayers(scoreboardConfig, scoreboardPanel);
    return { "scoreboardConfig": scoreboardConfig, "scoreboardPanel": scoreboardPanel }
}


//=============================================================================
//=============================================================================
function ScoreboardUpdater_SetScoreboardActive(scoreboardHandle, isActive) {
    if (scoreboardHandle.scoreboardConfig === null || scoreboardHandle.scoreboardPanel === null) {
        return;
    }

    if (isActive) {
        _ScoreboardUpdater_UpdateAllTeamsAndPlayers(scoreboardHandle.scoreboardConfig, scoreboardHandle.scoreboardPanel);
    }
}

//=============================================================================
//=============================================================================
function ScoreboardUpdater_GetTeamPanel(scoreboardHandle, teamId) {
    if (scoreboardHandle.scoreboardPanel === null) {
        return;
    }

    var teamPanelName = "_dynamic_team_" + teamId;
    return scoreboardHandle.scoreboardPanel.FindChild(teamPanelName);
}

//=============================================================================
//=============================================================================
function ScoreboardUpdater_GetSortedTeamInfoList(scoreboardHandle) {
    var teamsList = [];
    for (var teamId of Game.GetAllTeamIDs()) {
        teamsList.push(Game.GetTeamDetails(teamId));
    }

    if (teamsList.length > 1) {
        teamsList.sort(stableCompareFunc);
    }

    return teamsList;
}