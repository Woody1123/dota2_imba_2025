var panel = $.GetContextPanel()
var Vote_root = panel.FindChildTraverse('vote_Root');
var vote_text = panel.FindChildTraverse('vote_title');
var Vote_fun_root = panel.FindChildTraverse('vote_fun_Root');
var vote_fun_text = panel.FindChildTraverse('vote_fun_title');
function FindDotaHudElement_t(sElement) {
    var BaseHud = $.GetContextPanel().GetParent().GetParent().GetParent();
    return BaseHud.FindChildTraverse(sElement);
}


function OnVoteShuffle(){
	if (Game.GameStateIs(DOTA_GameState.DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP)){
		var plid = Players.GetLocalPlayer();
		if (Players.IsValidPlayerID(plid)){
		FindDotaHudElement_t("ShuffleVoteButton").enabled = 0;
	   // FindDotaHudElement_t("ShuffleVoteButton").style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #808080FF ), to( #404040FF ) )';
		GameEvents.SendCustomGameEventToServer("OnVoteForShuffle", {id: plid});
		}
	}	
}

function UpdataShuffleVote(){
	var votes = CustomNetTables.GetTableValue("imba_vote", "shuffle_vote").agree;
    var enable = CustomNetTables.GetTableValue("imba_vote", "shuffle_vote").enable;
	var max = CustomNetTables.GetTableValue("imba_vote", "shuffle_vote").max;
	var te = FindDotaHudElement_t("ShuffleVoteNum")
	if (te) {
			$.Msg(votes)
    FindDotaHudElement_t("ShuffleVoteNum").text = votes+"/"+max;
    if (enable == 1) {
        FindDotaHudElement_t("ShuffleVoteNum").style.color = '#48FF00';
    } else {
        FindDotaHudElement_t("ShuffleVoteNum").style.color = '#ffffff';
    }
	if (votes==max){
		Shuffle();	
	}
		
	}
}


function OnVoteFun(){
	if (Game.GameStateIs(DOTA_GameState.DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP)){
		var plid = Players.GetLocalPlayer();
		if (Players.IsValidPlayerID(plid)){
		FindDotaHudElement_t("FunVoteButton").enabled = 0;
	   // FindDotaHudElement_t("ShuffleVoteButton").style.backgroundColor = 'gradient( linear, 0% 0%, 0% 100%, from( #808080FF ), to( #404040FF ) )';
		GameEvents.SendCustomGameEventToServer("OnVoteForFun", {id: plid});
		}
	}	
}

function UpdataFunVote(){
	var votes = CustomNetTables.GetTableValue("imba_vote_fun", "fun_vote").agree;
    var enable = CustomNetTables.GetTableValue("imba_vote_fun", "fun_vote").enable;
	var max = CustomNetTables.GetTableValue("imba_vote_fun", "fun_vote").max;
	var te = FindDotaHudElement_t("FunVoteNum")
	if (te) {
			$.Msg(votes)
    FindDotaHudElement_t("FunVoteNum").text = votes+"/"+max;
    if (enable == 1) {
        FindDotaHudElement_t("FunVoteNum").style.color = '#48FF00';
    } else {
        FindDotaHudElement_t("FunVoteNum").style.color = '#ffffff';
    }
	if (votes>=max){
		GameEvents.SendCustomGameEventToServer("FunMode_Enable",{});
	}
		
	}
}

function Shuffle(){
	 Game.ShufflePlayerTeamAssignments();
	 Game.SetRemainingSetupTime(15);
}

GameEvents.Subscribe("updata_shuffle_vote", UpdataShuffleVote);
GameEvents.Subscribe("updata_fun_vote", UpdataFunVote);
(function() {
	//var date = new Date();
	//var day = date.getDate();
	//if (day%10==8) {
		//vote_text.text = $.Localize("#Nofun");
	//}else{
		// vote_text.text = $.Localize("#Shuffle");
	//}
	 //GameEvents.SendCustomGameEventToServer("Vote_Initialization",{});
})()