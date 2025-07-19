var panel = $.GetContextPanel()
var Veteran_Talent = panel.FindChildTraverse('Veteran_Talent');
var view_1 = panel.FindChildTraverse('veteran_talent_view_1_ta');
var view_2 = panel.FindChildTraverse('veteran_talent_view_2_ta');
var view_3 = panel.FindChildTraverse('veteran_talent_view_3_ta');
var view_4 = panel.FindChildTraverse('veteran_talent_view_4_ta');
var view_5 = panel.FindChildTraverse('veteran_talent_view_5_ta');
var point_1 = panel.FindChildTraverse('veteran_talent_1_point');
var point_2 = panel.FindChildTraverse('veteran_talent_2_point');
var point_3 = panel.FindChildTraverse('veteran_talent_3_point');
var point_4 = panel.FindChildTraverse('veteran_talent_4_point');
var point_5 = panel.FindChildTraverse('veteran_talent_5_point');
var point_count = panel.FindChildTraverse('veteran_talent_point_text');
	
var point_table = [point_1,point_2,point_3,point_4,point_5,point_count]	
var talent_view = [view_1,view_2,view_3,view_4,view_5]
var veteran_talent_ROOT = panel.FindChildTraverse('veteran_talent_ROOT');
var plid = Players.GetLocalPlayer()
var playerInfo = Game.GetPlayerInfo(plid);
var hero_name =  playerInfo.player_selected_hero;
function FindDotaHudElement_t(sElement) {
    var BaseHud = $.GetContextPanel();
    return BaseHud.FindChildTraverse(sElement);
}

function IsInTable(V) {
	var name = 0;

	for (var i = 0; i < Hero_item.length; i++) {

		if (Hero_item[i][0][0] == V) {
			name = i;
		}
	}	
    return name;
}
function SendMSG() {
    if (Players.IsValidPlayerID(plid) && !Players.IsSpectator(plid)) {
        GameEvents.SendCustomGameEventToServer("Show_Data", { name: "Data", id: plid });
    }
}


function OnVeteran_talent() {
	UpdateTalentPoint();
	
	var name =  playerInfo.player_selected_hero
	 AnimatePanel(Veteran_Talent, { "opacity": "0.5;" }, 0, "ease-in", 0.2);
    veteran_talent_ROOT.style.visibility = "visible";
	 //var course2 = CustomNetTables.GetTableValue("course","name_1");
	

	 //[["item_bkbs","item_bkbs","item_bkbs"],["item_bkbs","item_bkbs","item_bkbs"],["item_bkbs","item_bkbs","item_bkbs"]]
		//var it = course[2];
        isCreate1=true;
        for (var index = 0; index < talent_view.length; ++index) {
           // var pp = $.CreatePanel("DOTAItemImage",talent_view[index], "c");
			//pp.AddClass("abil");
           // pp.itemname =veteran_talent[index].toString();//Hero_item[index];
		    var pp = $.CreatePanel("DOTAAbilityImage", talent_view[index], "ab");
            pp.AddClass("abil");
            pp.abilityname = veteran_talent[index].toString();
            PanelEvent(pp, pp.abilityname);
            //PanelEvent(pp, pp.abilityname);

}
}
function PanelEvent(pp,name) {
    pp.SetPanelEvent('onmouseover', function () {
        $.DispatchEvent("DOTAShowAbilityTooltip", pp, name);
    });
    pp.SetPanelEvent('onmouseout', function () {
        $.DispatchEvent("DOTAHideAbilityTooltip", pp);
    });
}

function Hide_Veteran_talent() {
    AnimatePanel(Veteran_Talent, { "opacity": "1;" }, 0, "ease-in", 0.2);
    veteran_talent_ROOT.style.visibility = "collapse";
}

function GetTalentPoint(){
	point_1 = 1;
	point_2 = 2;
	point_3 = 3;
	point_use = 4;
	point_count = 4;
}

function UpdateTalentPoint(){
	//获取客户端数据
    var point_table_client = CustomNetTables.GetTableValue("veteran_talent", plid.toString()).tb
	for (var index = 0; index < point_table.length; ++index) {
           point_table[index].text = point_table_client[index+1];
        }
}


function use_point(data,data2){
	var point_count = point_table.length - 1
	if(data2 == -1 && Number(point_table[data].text) >=1 ){
		point_table[data].text = Number(point_table[data].text) + data2
		point_table[point_count].text = Number(point_table[point_count].text) - data2
	}
	
	if(data2 == 1 && Number(point_table[data].text <=2) && Number(point_table[point_count].text >=1)){
		point_table[data].text = Number(point_table[data].text) + data2
		point_table[point_count].text = Number(point_table[point_count].text) - data2
	}	
}


function buy_point(){
	//向客户端发消息
	//最后元素为剩余点数
	 GameEvents.SendCustomGameEventToServer("OnBuy_VeteranTalent_Point", {id: plid});
	 //$.Msg(msg)
}

function BuyPointSuccess(){
	point_table[point_table.length-1].text = Number(point_table[point_table.length-1].text) + 1
}

//重置点数 获取前端显示的点数 随后将数据发送给后端 后端再更新ui
function re_point(){
	
	var point = Number(point_table[point_table.length-1].text)
	for(var index = 0; index < point_table.length-1; ++index){
		point = Number(point_table[index].text) + point;		
	}
	GameEvents.SendCustomGameEventToServer("OnRe_VeteranTalent_Point", {id: plid,point:point});
}
//确定点数 获取前端数据 发送给后端 后端更新ui
function sure_point(){
	 var point_table_sure = [0,0,0,0,0,0]
	for (var index = 0; index < point_table.length; ++index) {
           point_table_sure[index] = point_table[index].text;
        }
	 GameEvents.SendCustomGameEventToServer("OnSure_VeteranTalent_Point", {id: plid,tab:point_table_sure});
	 
}



var veteran_talent = 
[
	"imba_veteran_talent_1","imba_veteran_talent_2","imba_veteran_talent_3","imba_veteran_talent_4","imba_veteran_talent_5"
]



//注册前端事件 lua使用前面字段调用前端后后面字段方法
GameEvents.Subscribe("buy_talent_point_success", BuyPointSuccess);
GameEvents.Subscribe("update_talent_point", UpdateTalentPoint);

(function() {
	 GameEvents.SendCustomGameEventToServer("VeterantTalent_Initialization", {id: plid});
})()
