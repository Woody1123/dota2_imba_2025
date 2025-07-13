var panel = $.GetContextPanel()
var veteran_BG = panel.FindChildTraverse('Veteran_BG');
var Course_BG = panel.FindChildTraverse('Course_BG');
var help_BG = panel.FindChildTraverse('HELP_BG2');
var player_BG = panel.FindChildTraverse('Player_BG');
var RDSK_BG = panel.FindChildTraverse('RDSK_BG');

var veteran_data_ROOT = panel.FindChildTraverse('veteran_data_ROOT');
var course_data_ROOT = panel.FindChildTraverse('course_data_ROOT');
var player_data_ROOT = panel.FindChildTraverse('player_data_ROOT');
var random_skills_ROOT = panel.FindChildTraverse('random_skills_ROOT');
var random_skills_BG = panel.FindChildTraverse('random_skills_BG');
var random_skills_1 = panel.FindChildTraverse('random_skills_1');
var random_skills_2 = panel.FindChildTraverse('random_skills_2');
var course_player_1 = panel.FindChildTraverse('course_player_1');
var course_player_2 = panel.FindChildTraverse('course_player_2');
var help_ROOT = panel.FindChildTraverse('help_ROOT');
var help_b = panel.FindChildTraverse('help_b');
var Slotted = panel.FindChildTraverse('Slotted');
var player_LV = panel.FindChildTraverse("player_LV");
var lv_text = panel.FindChildTraverse("data0"); 
var plid = Players.GetLocalPlayer()
var playerInfo = Game.GetPlayerInfo(plid);
var hero_name =  playerInfo.player_selected_hero;
var isCreate=false;
let LV_DATA=
{
    "0": 'file://{images}/custom_game/hud/lv0.png',
    "1": 'file://{images}/custom_game/hud/lv1.png',
    "2": 'file://{images}/custom_game/hud/lv2.png',
    "3": 'file://{images}/custom_game/hud/lv3.png',
    "4": 'file://{images}/custom_game/hud/lv4.png',
    "5": 'file://{images}/custom_game/hud/lv5.png',
    "6": 'file://{images}/custom_game/hud/lv6.png',
    "7": 'file://{images}/custom_game/hud/lv7.png',
    "8": 'file://{images}/custom_game/hud/lv8.png',
}


function SendMSG() {
    if (Players.IsValidPlayerID(plid) && !Players.IsSpectator(plid)) {
        GameEvents.SendCustomGameEventToServer("Show_Data", { name: "Data", id: plid });
    }
}

function GetPlayerData(b) {
    if (Players.IsSpectator(plid)) {return}
    if (b) {
        AnimatePanel(player_BG, { "opacity": "0.5;" });
        var steamid = Game.GetPlayerInfo(Players.GetLocalPlayer()).player_steamid.toString()
        var data = CustomNetTables.GetTableValue("player_data", steamid)
        if (data!=null)
        {
            var lv = GetRankKill(data[1]);
            player_data_ROOT.style.visibility = "visible";
            lv_text.text = $.Localize("#VLV") + lv;
            player_LV.SetImage(LV_DATA[lv]);
            for (var i = 1; i <= 9; i++)
            {
                    var num = i.toString()
                    var name = "#veteran_data" + num
                    var veteran = panel.FindChildTraverse("data" + num);
                    veteran.text = $.Localize(name) + data[i].toString();
            }
        }
    } else {
        AnimatePanel(player_BG, { "opacity": "1;" });
       player_data_ROOT.style.visibility = "collapse";
    }
}

function GetRankKill(k) {
    var lv = 0;
    if (k < 500) {
        lv = 0;
    } else if (k >= 500 && k < 1000) {
        lv = 1;
    } else if (k >= 1000 && k < 1500) {
        lv = 2;
    } else if (k >= 1500 && k < 2000) {
        lv = 3;
    } else if (k >= 2000 && k < 2500) {
        lv = 4;
    } else if (k >= 2500 && k < 3000) {
        lv = 5;
    } else if (k >= 3000 && k < 3500) {
        lv = 6;
    } else if (k >= 3500 && k < 4000) {
        lv = 7;
    } else if (k >= 4500) {
        lv = 8;
    }
    return lv
}


///////////////////////////////////////////////////////////

function OnRDSK() {
    AnimatePanel(RDSK_BG, { "opacity": "0.5;" }, 0, "ease-in", 0.2);
    random_skills_ROOT.style.visibility = "visible";
    if (isCreate==false)
    {
        isCreate=true;
        for (var index = 0; index < RandomAbility.length; index++) {
            var pp = $.CreatePanel("DOTAAbilityImage", random_skills_1, "abilityID");
            pp.AddClass("ability");
            pp.abilityname = RandomAbility[index];
            PanelEvent(pp, pp.abilityname);
        }
		
        for (var index = 0; index < RandomAbility2.length; index++) {
            var pp = $.CreatePanel("DOTAAbilityImage", random_skills_2, "abilityID");
            pp.AddClass("ability");
            pp.abilityname = RandomAbility2[index];
            PanelEvent(pp, pp.abilityname);
        }
    }
}

function HideRDSK() {
    AnimatePanel(RDSK_BG, { "opacity": "1;" }, 0, "ease-in", 0.2);
    random_skills_ROOT.style.visibility = "collapse";
}

function PanelEvent(pp,name) {
    pp.SetPanelEvent('onmouseover', function () {
        $.DispatchEvent("DOTAShowAbilityTooltip", pp, name);
    });
    pp.SetPanelEvent('onmouseout', function () {
        $.DispatchEvent("DOTAHideAbilityTooltip", pp);
    });
}
 
function On_HELP() {
	if (help_ROOT.style.visibility == "visible"){
		AnimatePanel(help_BG, { "opacity": "1;" }, 0, "ease-in", 0.2);
		help_ROOT.style.visibility = "collapse";
	}else{
		AnimatePanel(help_BG, { "opacity": "0.5;" }, 0, "ease-in", 0.2);
		help_ROOT.style.visibility = "visible";
	
		 var pp = $.CreatePanel("Image", help_b, "");
		pp.AddClass("help");			
	}
}
function Hide_OnCourse_hero() {
    AnimatePanel(help_BG, { "opacity": "1;" }, 0, "ease-in", 0.2);
    help_ROOT.style.visibility = "collapse";
}
///////////////////////////////////////////////////////////

var button_Veteran = [
    panel.FindChildTraverse("button_Veteran0"),
    panel.FindChildTraverse("button_Veteran1"),
    panel.FindChildTraverse("button_Veteran2"),
    panel.FindChildTraverse("button_Veteran3"),
]
var Veteran = [
    panel.FindChildTraverse("veteran0"),
    panel.FindChildTraverse("veteran1"),
    panel.FindChildTraverse("veteran2"),
    panel.FindChildTraverse("veteran3"),
]

function OnVeteran() {
    AnimatePanel(veteran_BG, { "opacity": "0.5;" }, 0, "ease-in", 0.2);
    veteran_data_ROOT.style.visibility = "visible";

}

function HideVeteran() {
    AnimatePanel(veteran_BG, { "opacity": "1;" }, 0, "ease-in", 0.2);
    veteran_data_ROOT.style.visibility = "collapse";
}

function ButtonVeteran(id) {
    for (let index = 0; index < button_Veteran.length; index++) {
        if (index == id)
        {
            button_Veteran[index].AddClass("button_Veteran_class1");
            Veteran[index].style.visibility = "visible";
        }else{
            button_Veteran[index].RemoveClass("button_Veteran_class1");
            Veteran[index].style.visibility = "collapse";
        }
    }
}







var button_Course = [
    panel.FindChildTraverse("button_Course0"),
    panel.FindChildTraverse("button_Course1"),
    panel.FindChildTraverse("button_Course2"),
    panel.FindChildTraverse("button_Course3"),
]
var Course = [
    panel.FindChildTraverse("course0"),
    panel.FindChildTraverse("course1"),
    panel.FindChildTraverse("course2"),
    panel.FindChildTraverse("course3"),
]


function OnCourse() {
	//AnimatePanel(veteran_BG, { "opacity": "0.5;" }, 0, "ease-in", 0.2);
   // veteran_data_ROOT.style.visibility = "visible";
    AnimatePanel(course_BG, { "opacity": "0.5;" }, 0, "ease-in", 0.2);
    course_data_ROOT.style.visibility = "visible";

}

function HideCourse() {
    AnimatePanel(course_BG, { "opacity": "1;" }, 0, "ease-in", 0.2);
    course_data_ROOT.style.visibility = "collapse";
}

function ButtonCourse(id) {
    for (let index = 0; index < button_Course.length; index++) {
        if (index == id)
        {
            button_Course[index].AddClass("button_Course_class1");
            Course[index].style.visibility = "visible";
        }else{
            button_Course[index].RemoveClass("button_Course_class1");
            Course[index].style.visibility = "collapse";
        }
    }
}


var start_item_1 = ["item_magic_shoes","item_ward_dispenser","item_smoke_of_deceit","item_flask","item_aghanims_shard","item_ultimate_scepter","item_urn_of_shadows"]
var start_item_2 = ["item_premium_tranquil_boots","item_ward_dispenser","item_smoke_of_deceit","item_flask","item_aghanims_shard","item_ultimate_scepter","item_urn_of_shadows"]
var start_item_3 = ["item_bkbs","item_ward_dispenser","item_smoke_of_deceit","item_boots","item_ultimate_scepter","item_flask","item_aghanims_shard"]
//一般法师核心
var magic_item_core = ["item_imba_blink_boots","item_sheepstick_v2","item_octarine_core_v2","item_bkb","item_ward_dispenser"]
var magic_item_other = ["item_veil_of_evil","item_nullifier_v2","item_three_knives","item_imba_ether","item_wind_waker","item_bloodthorn_v2","item_imba_black_blade"]

//阴间人
var yinjian_item = ["item_imba_blink_boots","item_sheepstick_v2","item_octarine_core_v2","item_bkb","item_ward_dispenser","item_heavens_halberd_v2"]
var yinjian_item_other = ["item_imba_orb","item_wind_waker","item_imba_black_blade","item_imba_aegis_heart","item_imba_pipe","item_aeon_disk","item_imba_ether"]

//物理_近战
var physics_item_core = ["item_bkb","item_imba_blink_boots","item_enchanted_edge","item_greater_crit_v2","item_abyssal_blade_v2","item_monkey_king_bar_v2"]
var physics_item_other = ["item_sphere","item_laojie","item_butterfly_v2","item_premium_phase_boots","item_imba_death","item_butterfly_v2","item_imba_mist_relics"]

//物理_远程
var physics_range_item_core = ["item_bkb","item_imba_blink_boots","item_greater_crit_v2","item_monkey_king_bar_v2"]
var physics_range_item_other = ["item_sky_lance","item_abyssal_blade_v2","item_imba_mist_relics","item_laojie","item_premium_phase_boots","item_imba_death","item_butterfly_v2"]

//刮痧
var specia_item_core = ["item_bkb","item_imba_blink_boots","item_imba_black_blade","item_monkey_king_bar_v2"]
var specia_item_other = ["item_veil_of_evil","item_three_knives","item_octarine_core_v2","item_sky_lance","item_sheepstick_v2"]

//肉爹
var tank_item_core = ["item_bkb","item_imba_greatwyrm_plate","item_imba_aegis_heart"]
var tank_item_other = ["item_imba_pipe","item_eternal_armor","item_imba_orb","item_greaves_v2","item_heavens_halberd_v2","item_imba_vladmir","item_imba_blade_mail_2"]

var Hero_item = [
[["npc_dota_hero_omniknight"],start_item_2,tank_item_core,tank_item_other],
[["npc_dota_hero_enigma"],start_item_3,["item_refresher","item_imba_blink_boots","item_bkb"],yinjian_item_other],
[["npc_dota_hero_tiny"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_pudge"],start_item_2,tank_item_core,tank_item_other],
[["npc_dota_hero_naga_siren"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_magnataur"],start_item_3,["item_refresher","item_imba_blink_boots","item_bkb"],yinjian_item_other],
[["npc_dota_hero_marci"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_treant"],start_item_3,magic_item_core,magic_item_other],

[["npc_dota_hero_slardar"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_night_stalker"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_jakiro"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_antimage"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_void_spirit"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_lycan"],physics_item_core,physics_item_other],

[["npc_dota_hero_alchemist"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_skeleton_king"],start_item_3,physics_item_core,physics_item_other],

[["npc_dota_hero_alchemist"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_skeleton_king"],start_item_3,physics_item_core,physics_item_other],

[["npc_dota_hero_techies"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_batrider"],start_item_2,magic_item_core,magic_item_other],
[["npc_dota_hero_ursa"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_faceless_void"],start_item_2,magic_item_core,magic_item_other],
[["npc_dota_hero_furion"],start_item_3,physics_range_item_core,physics_range_item_other],
[["npc_dota_hero_chaos_knight"],start_item_3,physics_item_core,physics_range_item_other],
[["npc_dota_hero_sniper"],start_item_3,physics_range_item_core,physics_range_item_other],
[["npc_dota_hero_doom_bringer"],start_item_3,specia_item_core,specia_item_other],
[["npc_dota_hero_ember_spirit"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_templar_assassin"],start_item_3,physics_range_item_core,physics_range_item_other],
[["npc_dota_hero_earthshaker"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_pangolier"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_centaur"],start_item_2,tank_item_core,tank_item_other],
[["npc_dota_hero_rattletrap"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_brewmaster"],start_item_3,physics_item_core.physics_item_other],
[["npc_dota_hero_bounty_hunter"],start_item_2,physics_item_core,physics_item_other],
[["npc_dota_hero_beastmaster"],start_item_3,["item_siege","item_imba_relic_chip"],tank_item_core],
[["npc_dota_hero_huskar"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_troll_warlord"],start_item_3,physics_range_item_core,physics_range_item_other],
[["npc_dota_hero_disruptor"],start_item_2,magic_item_core,magic_item_other],
[["npc_dota_hero_dazzle"],start_item_3,yinjian_item,yinjian_item_other],
[["npc_dota_hero_slark"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_storm_spirit"],start_item_3,specia_item_core,specia_item_other],
[["npc_dota_hero_rubick"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_grimstroke"],start_item_1,yinjian_item,yinjian_item_other],
[["npc_dota_hero_skywrath_mage"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_pugna"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_dragon_knight"],start_item_1,tank_item_core,tank_item_other],
[["npc_dota_hero_shadow_shaman"],start_item_2,magic_item_core,magic_item_other],
[["npc_dota_hero_legion_commander"],["item_bkbs","item_boots"],["item_bkb","item_imba_blade_mail_2","item_enchanted_edge","item_imba_blink_boots","item_greater_crit_v2","item_abyssal_blade_v2"],physics_item_other],
[["npc_dota_hero_wisp"],start_item_2,tank_item_core,tank_item_other],
[["npc_dota_hero_vengefulspirit"],start_item_1,tank_item_core,tank_item_other],
[["npc_dota_hero_undying"],start_item_1,tank_item_core,tank_item_other],
[["npc_dota_hero_tidehunter"],start_item_1,tank_item_core,tank_item_other],
[["npc_dota_hero_keeper_of_the_light"],start_item_2,yinjian_item,yinjian_item_other],
[["npc_dota_hero_juggernaut"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_clinkz"],start_item_3,physics_range_item_core,physics_range_item_other],
[["npc_dota_hero_death_prophet"],start_item_1,tank_item_core,tank_item_other],
[["npc_dota_hero_mars"],start_item_1,tank_item_core,tank_item_other],
[["npc_dota_hero_life_stealer"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_crystal_maiden"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_queenofpain"],start_item_1,magic_item_core,magic_item_other],
[["npc_dota_hero_bristleback"],start_item_1,tank_item_core,tank_item_other],
[["npc_dota_hero_medusa"],start_item_3,physics_range_item_core,physics_range_item_other],
[["npc_dota_hero_lich"],start_item_2,magic_item_core,magic_item_other],
[["npc_dota_hero_elder_titan"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_chen"],start_item_2,tank_item_core,tank_item_other],
[["npc_dota_hero_terrorblade"],start_item_3,physics_range_item_core,physics_range_item_other],
[["npc_dota_hero_sand_king"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_shredder"],start_item_2,tank_item_core,tank_item_other],
[["npc_dota_hero_obsidian_destroyer"],start_item_3,specia_item_core,specia_item_other],
[["npc_dota_hero_nyx_assassin"],start_item_2,tank_item_core,tank_item_other],
[["npc_dota_hero_kunkka"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_drow_ranger"],start_item_3,physics_range_item_core,physics_range_item_other],
[["npc_dota_hero_necrolyte"],start_item_3,physics_range_item_core,physics_range_item_other],
[["npc_dota_hero_winter_wyvern"],start_item_3,specia_item_core,specia_item_other],
[["npc_dota_hero_phoenix"],start_item_2,tank_item_core,tank_item_other],
[["npc_dota_hero_windrunner"],start_item_3,specia_item_core,specia_item_other],
[["npc_dota_hero_spectre"],start_item_3,tank_item_core,tank_item_other],
[["npc_dota_hero_morphling"],start_item_2,tank_item_core,tank_item_other],
[["npc_dota_hero_invoker"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_bane"],start_item_2,yinjian_item,yinjian_item_other],
[["npc_dota_hero_venomancer"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_snapfire"],start_item_3,physics_range_item_core,physics_range_item_other],
[["npc_dota_hero_abyssal_underlord"],start_item_2,physics_item_core,physics_item_other],
[["npc_dota_hero_broodmother"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_lina"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_viper"],start_item_3,specia_item_core,specia_item_other],
[["npc_dota_hero_axe"],start_item_3,["item_bkb","item_imba_greatwyrm_plate","item_imba_aegis_heart","item_imba_blade_mail_2","item_imba_blink_boots"],tank_item_other],
[["npc_dota_hero_luna"],start_item_3,physics_range_item_core,physics_range_item_other],
[["npc_dota_hero_ancient_apparition"],start_item_3,specia_item_core,specia_item_other],
[["npc_dota_hero_tusk"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_mirana"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_weaver"],start_item_3,tank_item_core,tank_item_other],
[["npc_dota_hero_abaddon"],start_item_1,tank_item_core,tank_item_other],
[["npc_dota_hero_earth_spirit"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_puck"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_phantom_lancer"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_dark_seer"],start_item_2,magic_item_core,magic_item_other],
[["npc_dota_hero_dawnbreaker"],start_item_3,tank_item_core,tank_item_other],
[["npc_dota_hero_razor"],start_item_3,tank_item_core,tank_item_other],
[["npc_dota_hero_nevermore"],start_item_3,physics_range_item_core,physics_range_item_other],
[["npc_dota_hero_spirit_breaker"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_hoodwink"],start_item_3,specia_item_core,specia_item_other],
[["npc_dota_hero_ogre_magi"],start_item_3,["item_imba_dagon_10"],magic_item_core],
[["npc_dota_hero_monkey_king"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_shadow_demon"],start_item_2,yinjian_item,yinjian_item_other],
[["npc_dota_hero_dark_willow"],start_item_3,specia_item_core,specia_item_other],
[["npc_dota_hero_bloodseeker"],start_item_2,yinjian_item,yinjian_item_other],
[["npc_dota_hero_oracle"],start_item_2,yinjian_item,yinjian_item_other],
[["npc_dota_hero_lion"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_riki"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_phantom_assassin"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_witch_doctor"],start_item_3,["item_monkey_king_bar_v2"],physics_range_item_core],
[["npc_dota_hero_leshrac"],start_item_3,magic_item_core,magic_item_other],
[["npc_dota_hero_enchantress"],start_item_3,specia_item_core,specia_item_other],
[["npc_dota_hero_visage"],start_item_3,specia_item_core,specia_item_other],
[["npc_dota_hero_silencer"],start_item_2,specia_item_core,specia_item_other],
[["npc_dota_hero_sven"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_gyrocopter"],start_item_3,physics_item_core,physics_item_other],
[["npc_dota_hero_zuus"],start_item_3,specia_item_core,specia_item_other],
[["npc_dota_hero_warlock"],start_item_3,yinjian_item,yinjian_item_other],
[["npc_dota_hero_tinker"],start_item_3,["item_imba_soul","item_imba_blink_boots","item_sheepstick_v2","item_imba_dagon_10"],yinjian_item_other]


]




var RandomAbility =
[
        "multishot", "chilling_touch", "axe_sprint", "berserkers_call", "counter_helix", "double_edge", "dragon_blood", "dragon_tail", "searing_chains",
        "rocket_barrage", "blade_dance", "torrent", "howl", "mystic_snake", "crippling_fear", "essence_aura", "purification", "fortunes_end", "shackleshot",
        "powershot", "poison_nova", "storm_bolt", "slug", "hellfire_blast", "shock", "caustic_finale", "icarus_dive", "phantom_strike", "malefice", "stifling_dagger",
        "epicenter", "refraction", "wave_of_silence", "corrosive_skin", "nethertoxin", "plague_ward", "venomous_gale", "warcry", "sniper_roll", "burrowstrike",
        "imba_rattletrap_battery_assault", "guardian_angel", "sanity_eclipse", "boundless_strike", "shapeshift", "healing_ward", "midnight_pulse", "seriously_punch",
        "ion_shell", "culling_blade", "ice_vortex", "ice_blast", "imba_storm_spirit_electric_vortex", "imba_storm_spirit_ball_lightning", "grenade", "echo_stomp",
        "guided_missile", "imba_bounty_hunter_shuriken_toss", "imba_chaos_knight_chaos_bolt", "imba_chaos_knight_chaos_strike", "imba_lina_dragon_slave", "imba_lina_light_strike_array",
        "imba_razor_plasma_field", "oldsky_aseal", "imba_leshrac_pulse_nova", "aghsfort_mars_spear", "imba_mirana_arrow", "imba_mirana_leap", "hoof_stomp", "breathe_fire",
        "sleight_of_fist", "song_of_the_siren", "voodoo", "decay", "windrun", "bulldoze", "charge_of_darkness", "greater_bash", "dual_breath", "ice_path", "macropyre",
        "toss_", "wdnmd", "shell_", "money", "mount", "dog", "gamble", "thunderstorm", "deerskin", "des_build", "fight", "kill_trees", "reduce", "laser_turret", "counterattack",
        "tower", "aphotic_shield", "death_coil", "frostmourne", "purification_new", "guardian_angel_new", "imba_queenofpain_blink", "imba_queenofpain_shadow_strike", "imba_queenofpain_scream_of_pain",
        "imba_queenofpain_sonic_wave", "imba_huskar_inner_fire", "imba_huskar_burning_spear", "imba_huskar_berserkers_blood", "polymerization", "forbid", "deception",
        "mother_love", "tp_tp", "assembly", "imba_witch_doctor_voodoo_switcheroo", "imba_witch_doctor_voodoo_restoration", "brain_sap", "enfeeble", "nightmare",
        "imba_tiny_grow", "imba_tiny_avalanche", "imba_treant_natures_grasp", "imba_light_radiant_bind", "imba_light_blinding_light", "imba_luna_lucent_beam",
        "imba_luna_lunar_blessing", "imba_spectre_desolate", "imba_phantom_lancer_spirit_lance", "prot", "flesh_heap", "dismember", "mountain", "shockwave",
        "imba_phantom_lancer_doppelwalk", "imba_phantom_lancer_phantom_edge", "imba_bristleback_viscous_nasal_goo", "imba_bristleback_quill_spray", "empower",
        "unstable_concoction_throw", "winters_curse", "splinter_blast",
        "pangolier_swashbuckle", "tidehunter_anchor_smash", "rattletrap_hookshot", "earthshaker_aftershock", "warlock_rain_of_chaos", "pudge_meat_hook", "queenofpain_blink",
        "shadow_shaman_voodoo", "faceless_void_time_walk", "dark_troll_warlord_ensnare", "polar_furbolg_ursa_warrior_thunder_clap", "centaur_khan_war_stomp", "roshan_spell_block",
        "roshan_slam", "hoodwink_scurry", "filler_ability", "necronomicon_archer_aoe", "satyr_hellcaller_shockwave", "victory", "fiery_soul", "laguna_blade", "supernova",
        "ra_mango_tree", "ra_flask", "ra_clarity", "ra_cheese","ra_greater_crit","ra_hand_of_midas",

]


var RandomAbility2 =
[
        "ra_branches",
        "filler_ability",
        "roshan_spell_block",
        "necronomicon_archer_aoe",
        "shredder_reactive_armor",
        "dragon_knight_dragon_blood",
        "omniknight_degen_aura",
        "huskar_burning_spear",
        "bounty_hunter_jinada",
        "ursa_fury_swipes",
        "ogre_magi_bloodlust",
        "troll_warlord_fervor",
        "centaur_return",
        "pangolier_heartpiercer",
        "life_stealer_feast",
        "pudge_flesh_heap",
        "earthshaker_aftershock",
        "sven_great_cleave",
        "drow_ranger_marksmanship",
        "razor_eye_of_the_storm",
        "crystal_maiden_brilliance_aura",
        "kunkka_tidebringer",
        "tiny_grow",
        "sniper_headshot",
        "beastmaster_inner_beast",
        "dragon_knight_elder_dragon_form",
        "huskar_berserkers_blood",
        "antimage_mana_break",
        "axe_counter_helix",
        "abaddon_frostmourne",
        "pangolier_lucky_shot",
        "jakiro_liquid_fire",
        "luna_lunar_blessing",
        "viper_poison_attack",
        "beastmaster_boar_poison",
        "nevermore_dark_lord",
        "storm_spirit_overload",
        "greater_bash",
        "tower1_watchtower",
        "blade_dance",
        "chilling_touch",
        "c_return",
        "untouchable",
        "rip_tide",
        "counter_helix",
        "natural_order_spirit",
        "impetus",
        "feral_impulse",
        "corrosive_skin",
        "poison_sting",
        "blur",
        "divine_favor",
        "hunter_in_the_night",
        "poison_attack",
        "degen_aura",
        "imba_storm_spirit_overload",
        "dlzuus_al",
        "oldtroll_fervor",
        "wdnmd",
        "polymerization",
        "tower",
        "counterattack",
        "laser_turret",
        "reduce",
        "kill_trees",
        "victory",
        "fight",
        "des_build",
        "deerskin",
        "gamble",
        "dog",
        "money",
        "mount",
        "deception",
        "mother_love",
        "tp_tp",
        "assembly",
        "imba_tiny_grow",
        "imba_luna_lunar_blessing",
        "imba_spectre_desolate",
        "imba_phantom_lancer_phantom_edge",
        "imba_bristleback_warpath",
        "prot",
        "fiery_soul",
]
GameEvents.Subscribe("open_help", On_HELP);