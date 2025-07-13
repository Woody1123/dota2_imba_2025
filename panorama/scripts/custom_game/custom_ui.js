GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_TEAMS, false );
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, false );
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME, false );
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_PREGAME_STRATEGYUI, true );
GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_TIMEOFDAY, true);
GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_HEROES, false);
GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_BAR_BACKGROUND, false);


GameUI.CustomUIConfig().team_logo_xml = {}
GameUI.CustomUIConfig().team_logo_xml[DOTATeam_t.DOTA_TEAM_GOODGUYS] = "file://{images}/custom_game/team_icons/team_icon_tiger_01.png";
GameUI.CustomUIConfig().team_logo_xml[DOTATeam_t.DOTA_TEAM_BADGUYS ] = "file://{images}/custom_game/team_icons/team_icon_monkey_01.png";

var PreGame = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("PreGame")
var LoadingScreenContent = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("LoadingScreenContent")
var PregameBG = PreGame.FindChildTraverse("PregameBG")
var HeroPickMinimap = PreGame.FindChildTraverse("HeroPickMinimap")
var HeroInspect = PreGame.FindChildTraverse("HeroInspect")
var LockInButton = PreGame.FindChildTraverse("LockInButton")
var RandomButton = PreGame.FindChildTraverse("RandomButton")
Show_PreGame()
function Show_PreGame()
{
    if (!Game.GameStateIs(DOTA_GameState.DOTA_GAMERULES_STATE_HERO_SELECTION))
    {
        PreGame.style.opacity = "0";
        $.Schedule(0.5, Show_PreGame);
    }
    else
    {
        PreGame.style.opacity = "1";
    }
}
if (PreGame.FindChildTraverse("BattlePassHeroUpsell")) {
    PreGame.FindChildTraverse("BattlePassHeroUpsell").style.visibility = "collapse";
    PreGame.FindChildTraverse("FriendsAndFoes").style.visibility = "collapse";
if (PreGame && PreGame.FindChildTraverse("BattlePassHeroData"))
    PreGame.FindChildTraverse("BattlePassHeroData").style.visibility = "collapse";
}
HeroPickMinimap.style.visibility = "collapse";
HeroInspect.style.backgroundColor="#00000050";
LockInButton.style.backgroundColor="#00000090";
RandomButton.style.backgroundColor="#00000090";
