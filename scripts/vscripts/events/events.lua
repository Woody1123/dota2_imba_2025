
--------------------------------------------------------------------------
-->官方游戏事件
--------------------------------------------------------------------------




--游戏状态改变时
function L_TG:OnGameRulesStateChange(tg)
		print("初始化InitSpawner")
	local State = GameRules:State_Get()
	if State == DOTA_GAMERULES_STATE_STRATEGY_TIME then	
		self:OnSTRATEGY_TIME()
	elseif State == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		self:OnCUSTOM_GAME_SETUP()
	elseif State == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self:OnHERO_SELECTION()
	elseif State == DOTA_GAMERULES_STATE_PRE_GAME then
		self:OnPRE_GAME()
	elseif State == DOTA_GAMERULES_STATE_POST_GAME then
		self:POST_GAME()
	elseif State == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:GAME_IN_PROGRESS()
	elseif State == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD  then
	elseif State == DOTA_GAMERULES_STATE_WAIT_FOR_MAP_TO_LOAD   then
	elseif State == DOTA_GAMERULES_STATE_INIT  then
	end
end

--游戏设置期间
function L_TG:OnCUSTOM_GAME_SETUP()
	print("初始化InitSpawner")
		if RollPercentage(10) then
			GameRules:SendCustomMessage( "本局为复选", 0, 0 )
			GameRules:SetSameHeroSelectionEnabled(true)
		end
		
		if RollPercentage(1) then
			  GameRules:SendCustomMessage( "本局为疯狂星期八", 0, 0 )
			  RandomAbility2=RandomAbility_funny
			  RandomAbility=RandomAbility_funny
			  TK_RD=TK_RD_funny
		end
		
	EmitGlobalSound( "TG.bgm" )
end

--------------------------------------------------------------------------

--赛前
function L_TG:OnPRE_GAME()
	--if GameRules:IsCheatMode() then CreateUnitByNameAsync("npc_dota_hero_target_dummy", Vector(0,0,0), true, nil, nil, DOTA_TEAM_NEUTRALS,function()end)end
end


--------------------------------------------------------------------------


--赛后
function L_TG:POST_GAME()

end


--------------------------------------------------------------------------


--英雄选择期间
function L_TG:OnHERO_SELECTION()
	if GameRules:IsCheatMode() then GameRules:SetSafeToLeave(true) end
	if GetMapName() ~="6v6v6" then
		unit:Init_Roshan()
	end
		building:Set_AB()
end


--------------------------------------------------------------------------


--决策期间
function L_TG:OnSTRATEGY_TIME()
		for i=0, 19 do
			if PlayerResource:IsValidPlayer(i) and not PlayerResource:HasSelectedHero(i) and PlayerResource:GetConnectionState(i) == DOTA_CONNECTION_STATE_CONNECTED then
			PlayerResource:GetPlayer(i):MakeRandomHeroSelection()
			end
		end
		--[[
		if #VOTE_FIGHTER<=9 then
			VOTE_FIGHTER = {}
		end]]
		 if GetMapName() == "10v10mid" then--and not GameRules:IsCheatMode() then
			spawner_creep:Spawner_early()
		 end
end


--------------------------------------------------------------------------


--游戏正式开始时（号角响起）
function L_TG:GAME_IN_PROGRESS()
	GameRules:SetTimeOfDay(0.25)
	if GetMapName() =="6v6v6" then
		Notifications:BottomToAll({text ="#kill1", duration = 3})
	else
		unit:Create_Roshan()
		Notifications:BottomToAll({text ="#kill", duration = 8,style={color="red", ["font-size"]="90px"}})
		
	end
	
	 
	 if GetMapName() == "10v10mid" then
		spawner_creep:InitSpawner()		
	 end    
		Timers:CreateTimer(0, function()
			GetAllHero(function(hero)
				local kill_gap = PlayerResource:GetTeamKills(DOTA_TEAM_BADGUYS)-PlayerResource:GetTeamKills(DOTA_TEAM_GOODGUYS)
				if hero then
					if hero:GetTeamNumber() == 3 then
						 kill_gap = -1*kill_gap
					end
					local gold = math.max(math.floor(kill_gap/4),0)*50+ExtraGold*5		
					--print(hero:GetName()..":"..gold)
					PlayerResource:ModifyGold(hero:GetPlayerOwnerID(),gold,false,DOTA_ModifyGold_Unspecified)
					if hero:GetLevel()<=50  and hero:IsAlive() then
						local xp = (GetXPNeededToReachNextLevel(hero:GetLevel())-GetXPNeededToReachNextLevel(hero:GetLevel()-1))*0.15
						hero:AddExperience(xp, DOTA_ModifyXP_Unspecified, false, false)
					end
					--[[local id=hero:GetPlayerOwnerID()
					if PlayerResource:GetConnectionState(id)==DOTA_CONNECTION_STATE_ABANDONED  and not Is_DATA_TG(GameRules.QuitB,hero) and not Is_DATA_TG(GameRules.QuitG,hero)  then
						local team = hero:GetTeamNumber()
						if team==DOTA_TEAM_BADGUYS then
							CDOTA_PlayerResource.ABANDONED_BAD=CDOTA_PlayerResource.ABANDONED_BAD+1
							table.insert(GameRules.QuitB,hero)
							if CDOTA_PlayerResource.ABANDONED_BAD>=7 then
								Notifications:BottomToAll({text ="夜魇逃跑人数>=7,天辉3秒后获胜", duration = 3})
								Timers:CreateTimer(3, function()
									GAME_LOSE_TEAM = DOTA_TEAM_BADGUYS
									GAME_WIN_TEAM = DOTA_TEAM_GOODGUYS
									GameRules:MakeTeamLose(GAME_LOSE_TEAM)
									GameRules:SetGameWinner(GAME_WIN_TEAM)
								return nil
								end)
							end
						elseif team==DOTA_TEAM_GOODGUYS   then
							CDOTA_PlayerResource.ABANDONED_GOOD=CDOTA_PlayerResource.ABANDONED_GOOD+1
							table.insert(GameRules.QuitG,hero)
							if CDOTA_PlayerResource.ABANDONED_GOOD>=7 then
								Notifications:BottomToAll({text ="天辉逃跑人数>=7,夜魇3秒后获胜", duration = 3})
								Timers:CreateTimer(3, function()
									GAME_LOSE_TEAM = DOTA_TEAM_GOODGUYS
									GAME_WIN_TEAM = DOTA_TEAM_BADGUYS
									GameRules:MakeTeamLose(GAME_LOSE_TEAM)
									GameRules:SetGameWinner(GAME_WIN_TEAM)
								return nil
								end)
							end
						end
					end]]
					
				end
			end)
		return 5
		end)
		--[[
		Timers:CreateTimer(30, function()
				CustomGameEventManager:Send_ServerToAllClients("ExitButton",{})
			return nil
		end)]]
		GameRules:SetRiverPaint(0,99999)
		
		Timers:CreateTimer( "LUAClearTimer", {
        useGameTime = false,
        endTime = 0,
        callback = function()
            local gc1 = collectgarbage( "count" )
            collectgarbage( "collect" )
            local gc2 = collectgarbage( "count" )
			
            if IsInToolsMode() then
                GameRules:SendCustomMessage( "Clear: " .. gc1 .. " 》》 " .. gc2, 0, 0 )
            end
            return 180
        end
     } )
end




--------------------------------------------------------------------------


--有单位复活或者出生时
function L_TG:OnNPCSpawned(tg)
	--[[
		{
		entindex                        	= 1120 (number)
		game_event_name                 	= "npc_spawned" (string)
		game_event_listener             	= -1409286142 (number)
		splitscreenplayer               	= -1 (number)
		}
	]]
    local npc = EntIndexToHScript(tg.entindex)
	if npc == nil then
		return
	end

	if npc:IsIllusion() then
		Timers:CreateTimer(0.3,function()
			if npc:HasModifier("modifier_item_moon_shard_consumed") then
				local player = PlayerResource:GetPlayer(npc:GetPlayerOwnerID()):GetAssignedHero()

				npc:AddNewModifier(player,nil,"modifier_illusion_moon_shard_buff",{duration = -1})
			end
			return nil
		end)
		
	end
	--player:Player_Spawned(npc)
	unit:courier(npc)
	--unit:Set_AB(npc)
end


--------------------------------------------------------------------------

--英雄第一次出生
function L_TG:OnHeroFinishSpawn(tg)
	--[[
		{
		 	heroindex - int
 			hero - string
		}
	]]
	local PLhero = EntIndexToHScript( tg.heroindex )
	if PLhero == nil then
		return
	end
	player:First_Player_Spawned(PLhero)

	--洗牌投票奖励 如果参与了投票但是没成功就会触发
	if #VOTE_FIGHTER <= VOTE_LIMIT then
		for _,id in pairs(VOTE_FIGHTER) do
			local PL=PlayerResource:GetPlayer(id)
			if  PL then
				local HERO=PL:GetAssignedHero()
				if HERO and HERO:IS_TrueHero_TG() and PLhero:GetName()==HERO:GetName() then
					HERO:AddItemByName("item_tome_of_knowledge")
					HERO:ModifyGold( 1000 , true, DOTA_ModifyGold_Unspecified )
				end
			end
		end
	end
	
end


--------------------------------------------------------------------------


--当某个单位被击杀时
function L_TG:OnEntityKilled(tg)
	--[[
	damagebits
	entindex_attacker
	entindex_killed
	splitscreenplayer

	DeepPrintTable(tg)
	]]
   	local attacker =tg.entindex_attacker and EntIndexToHScript(tg.entindex_attacker) or nil
	local unit =tg.entindex_killed and EntIndexToHScript(tg.entindex_killed) or nil
	--人头胜利
	--判断劣势方
	
	if unit:IsTrueHero() and Is_DATA_TG(CDOTA_PlayerResource.TG_HERO,unit) then
		local UT=unit:GetTeam()
		GK=GetTeamHeroKills(DOTA_TEAM_GOODGUYS)
		BK=GetTeamHeroKills(DOTA_TEAM_BADGUYS)
		local T1=GetTeamHeroKills(DOTA_TEAM_CUSTOM_1)
		--local MAX=TG_Table_Value({GK,BK,T1},0)
		local TEAM=UT==DOTA_TEAM_GOODGUYS and "bad" or "good"
			if KILL_TIPS then
				if GK ==250 or BK == 250  then
					KILL_TIPS=false
					EmitAnnouncerSoundForTeam("ann_custom_team_alerts_02", UT)
					--Notifications:BottomToAll({image="file://{images}/custom_game/hud/"..TEAM..".png", duration=5.0,continue=true})
					Notifications:BottomToAll({text = "#"..TEAM, duration = 5.0, style = {["font-size"] = "50px", color = "#ffffff",border="5px solid #ffffff"}})
				end
			end
			if GK >= KILLSNUM then
					GAME_LOSE_TEAM = DOTA_TEAM_BADGUYS
					GAME_WIN_TEAM = DOTA_TEAM_GOODGUYS
					GameRules:MakeTeamLose(GAME_LOSE_TEAM)
					GameRules:SetGameWinner(GAME_WIN_TEAM)
			elseif BK >= KILLSNUM then
					GAME_LOSE_TEAM = DOTA_TEAM_GOODGUYS
					GAME_WIN_TEAM = DOTA_TEAM_BADGUYS
					GameRules:MakeTeamLose(GAME_LOSE_TEAM)
					GameRules:SetGameWinner(GAME_WIN_TEAM)
			elseif T1 and T1 >= KILLSNUM then
					GAME_LOSE_TEAM = DOTA_TEAM_GOODGUYS
					GAME_WIN_TEAM = DOTA_TEAM_CUSTOM_1
					GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
					GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
					GameRules:SetGameWinner(DOTA_TEAM_CUSTOM_1)
			end
	end
	--[[

    if unit:IsCreep() then
		local pos = unit:GetAbsOrigin()
		local team = nil
		local pos_2 = Vector(0,0,0)
		if (pos - GOODGUYS):Length2D()<1500 then
			team = DOTA_TEAM_GOODGUYS
			pos_2 = GOODGUYS
		end
		if (pos - BADGUYS):Length2D()<1500 then
			team = DOTA_TEAM_BADGUYS
			pos_2 = BADGUYS
		end
		if  team~=nil and RollPseudoRandomPercentage(35,0,nil) then
			local index = RandomInt(1,#IMBA_RUNE_MODIFIER)
			local run = IMBA_RUNE_MODIFIER[index]
			for i=1, #CDOTA_PlayerResource.TG_HERO do
				if CDOTA_PlayerResource.TG_HERO[i] then
					local target = CDOTA_PlayerResource.TG_HERO[i]
					if target~= nil and  target:IsAlive() then
						if target:GetTeamNumber() == team and (pos_2 - target:GetAbsOrigin()):Length2D() <= 2000 then
							target:AddNewModifier(target, nil,run , {duration = 18})--"modifier_rune_regen_tg"
						end
					end
				end
			end
		end
	end
	
		
		if unit:IsNeutralUnitType() then
			RollCreature(unit,attacker)
			RollDrops(unit,attacker)
		else
			
		end
		
	if unit:IsTrueHero() and not AI_MODE  then 
		-- RollDropsHeros(unit,attacker)
		RollDropsGolds(unit,attacker)
	end
	]]
end                                                                            


function RollDrops(unit,attacker)
    local DropInfo = GameRules.DropTable["neutral_items"]
	local t = GameRules:GetDOTATime(false, false)
    if DropInfo then
		local tableI = "0"
		if t>600 and t<=900  then
			if RollPercentage(30) then
				tableI="4"
			else	
				tableI="5"
			end
		end 

		if tableI ~= "0" then
			
			for item_name,chance in pairs(DropInfo[tableI]) do
				if RollPercentage(chance) then
					-- Create the item
					-- local item = CreateItem(item_name, nil, nil)
					local pos = unit:GetAbsOrigin()
					-- local drop = CreateItemOnPositionSync( pos, item )
					local pos_launch = pos+RandomVector(Script_RandomFloat(150,200))
					-- item:LaunchLoot(false, 200, 0.75, pos_launch)
					DropNeutralItemAtPositionForHero(item_name,pos_launch,attacker,tonumber(tableI),true)
				end
			end
		end
    end
end



function RollDropsHeros(unit,attacker)
    local DropInfo = GameRules.DropTable["hero_items"]
	local t = GameRules:GetDOTATime(false, false)
    if DropInfo then
		if RollPercentage(10) then
			local random_i = RandomInt(1,3)
			local ItemTable = DropInfo[tostring(random_i)]
			local item = CreateItem(ItemTable.name, nil, nil)
			--print(ItemTable.name)
			local pos = unit:GetAbsOrigin()
			local drop = CreateItemOnPositionSync( pos, item )
			local pos_launch = pos+RandomVector(Script_RandomFloat(150,200))
			item:LaunchLoot(false, 200, 0.75, pos_launch,nil)	
		end
    end
end

function RollDropsGolds(unit,attacker)
	local t = GameRules:GetDOTATime(false, false)
	
	if RollPercentage(20) and t < 1200 then
		local item = CreateItem("item_bag_of_gold", nil, nil)
		local pos = unit:GetAbsOrigin()
		local drop = CreateItemOnPositionSync( pos, item )
		local pos_launch = pos+RandomVector(Script_RandomFloat(150,200))
		item:LaunchLoot(false, 200, 0.75, pos_launch,nil)	
	end
    
end
function RollCreature(unit,attacker)
    local DropInfo = GameRules.DropTable["happycat_items"]
	local t = GameRules:GetDOTATime(false, false)
	local team = attacker:GetTeamNumber()
	local chance = 1
	if GetMapName() ~="6v6v6" then
		GK=GetTeamHeroKills(DOTA_TEAM_GOODGUYS)
		BK=GetTeamHeroKills(DOTA_TEAM_BADGUYS)
		if  team == DOTA_TEAM_GOODGUYS  then
			if BK-GK>=10 then
				chance = BK-GK
			 end
			 chance=chance+GODTOWERKILLED
		end
		if team == DOTA_TEAM_BADGUYS then
			if GK-BK>=10 then
				chance = GK-BK
			end
			chance=chance+BADTOWERKILLED
		end
		if GetMapName() =="10v10" then
		 	chance = 3
		end
		if DropInfo then
			if t>480 then
				if RollPercentage(chance) then
					local random_i = RandomInt(1,3)
					local ItemTable = DropInfo[tostring(random_i)]
					if team == DOTA_TEAM_GOODGUYS then
						if ItemTable.multiplegood~="0" then
							ItemTable.multiplegood =tostring(tonumber(ItemTable.multiplegood)-1)
							local item = CreateItem(ItemTable.name, nil, nil)
							local pos = unit:GetAbsOrigin()
							local drop = CreateItemOnPositionSync( pos, item )
							local pos_launch = pos+RandomVector(Script_RandomFloat(150,200))
							item:LaunchLoot(false, 200, 0.75, pos_launch,nil)
						end
					end
					if team == DOTA_TEAM_BADGUYS then
						if ItemTable.multiplebad~="0" then
							ItemTable.multiplebad =tostring(tonumber(ItemTable.multiplebad)-1)
							local item = CreateItem(ItemTable.name, nil, nil)
							local pos = unit:GetAbsOrigin()
							local drop = CreateItemOnPositionSync( pos, item )
							local pos_launch = pos+RandomVector(Script_RandomFloat(150,200))
							item:LaunchLoot(false, 200, 0.75, pos_launch,nil)
						end
					end
				end
			end
		end	
	else
		chance = 20
		if DropInfo then
			if t>600 then
				if RollPercentage(chance) then
					local random_i = RandomInt(1,3)
					local ItemTable = DropInfo[tostring(random_i)]
					if team == DOTA_TEAM_GOODGUYS then
						if ItemTable.multiplegood~="0" then
							ItemTable.multiplegood =tostring(tonumber(ItemTable.multiplegood)-1)
							local item = CreateItem(ItemTable.name, nil, nil)
							local pos = unit:GetAbsOrigin()
							local drop = CreateItemOnPositionSync( pos, item )
							local pos_launch = pos+RandomVector(Script_RandomFloat(150,200))
							item:LaunchLoot(false, 200, 0.75, pos_launch,nil)
						end
					end
					if team == DOTA_TEAM_BADGUYS then
						if ItemTable.multiplebad~="0" then
							ItemTable.multiplebad =tostring(tonumber(ItemTable.multiplebad)-1)
							local item = CreateItem(ItemTable.name, nil, nil)
							local pos = unit:GetAbsOrigin()
							local drop = CreateItemOnPositionSync( pos, item )
							local pos_launch = pos+RandomVector(Script_RandomFloat(150,200))
							item:LaunchLoot(false, 200, 0.75, pos_launch,nil)
						end
					end
					if team == DOTA_TEAM_CUSTOM_1 then
						if ItemTable.multiple3~="0" then
							ItemTable.multiple3 =tostring(tonumber(ItemTable.multiplebad)-1)
							local item = CreateItem(ItemTable.name, nil, nil)
							local pos = unit:GetAbsOrigin()
							local drop = CreateItemOnPositionSync( pos, item )
							local pos_launch = pos+RandomVector(Script_RandomFloat(150,200))
							item:LaunchLoot(false, 200, 0.75, pos_launch,nil)
						end
					end
				end
			end
		end	
	end
	
end
--------------------------------------------------------------------------


--当玩家升级时
function L_TG:OnPlayerLevelUp(tg)
		--[[
	{
		player                          	= 1 (number)
		player_id                       	= 0 (number)
		PlayerID                        	= 0 (number)
		game_event_listener             	= 1610612741 (number)
		game_event_name                 	= "dota_player_gained_level" (string)
		hero_entindex                   	= 892 (number)
		level                           	= 6 (number)
		splitscreenplayer               	= -1 (number)
	}
]]

	
	local hero=EntIndexToHScript(tg.hero_entindex)
	--print(hero:GetName())
		--	print("LVLUP_1")
	if GetMapName() =="10v10mid" then
		if hero then
			if IsInTable(hero,AI_HERO) then
			--	print(hero:GetName())
		--	print("LVLUP_2")
				AI_LVLUP(hero)
			end
		end
	end
	
	
	if hero then
		veteran_talent_contral:OnHero_lvlup(hero)
		local lv=tg.level
		if (lv==6 or lv==11 or lv==16)then
			if hero.Random_Skill and IsValidEntity(hero.Random_Skill) then
				local maxlv=hero.Random_Skill:GetMaxLevel()
				local currlv=hero.Random_Skill:GetLevel()
				if currlv<maxlv then
					hero.Random_Skill:SetLevel(currlv+1)
				end
			end
		end
		--[[
		if lv==5 then
			hero:AddItemByName("item_tier2_token")
		end
		if lv==10 then
			hero:AddItemByName("item_tier3_token")
		end
		if lv==15 then
			hero:AddItemByName("item_tier4_token")
		end
		if lv==20 then
			hero:AddItemByName("item_tier5_token")
		end
		if lv==25 then

		end
		if lv==30 then
			
		end]]
		----------------------------------------------------------
		if PlayerResource:GetConnectionState(tg.player_id) == DOTA_CONNECTION_STATE_ABANDONED then
			hero:SetMinimumGoldBounty(0)
			hero:SetMaximumGoldBounty(0)
			hero:SetCustomDeathXP(0)
		else
			hero:SetMinimumGoldBounty(lv*15)
			hero:SetMaximumGoldBounty(lv*15)
		end
	end

end


--------------------------------------------------------------------------


--当捡起物品时
--
--
--dota_item_picked_up(itemname: string, PlayerID: PlayerID, ItemEntityIndex: EntityIndex, HeroEntityIndex: EntityIndex): void
function L_TG:OnItemPickedUp(tg)
	--[[
		{
			game_event_name                 	= "dota_item_picked_up" (string)
			itemname                        	= "item_blink" (string)
			game_event_listener             	= 1258291209 (number)
			PlayerID                        	= 0 (number)
			splitscreenplayer               	= -1 (number)
			ItemEntityIndex                 	= 280 (number)
			HeroEntityIndex                 	= 888 (number)
		}
	]]
	--print(tg.itemname)
		if  tg.itemname=="item_aegis_v2" then
		local hero=EntIndexToHScript(tg.HeroEntityIndex)
		local item=EntIndexToHScript(tg.ItemEntityIndex)
		if hero~=nil then
			for i=1, #CDOTA_PlayerResource.TG_HERO do
				if CDOTA_PlayerResource.TG_HERO[i] then
					local hero2 = CDOTA_PlayerResource.TG_HERO[i]
					if hero2~= nil and  hero2:IsAlive() then
						if  Is_Chinese_TG(hero2,hero)  and (hero:GetAbsOrigin() - hero2:GetAbsOrigin()):Length2D() <= 2000 then
							hero2:AddNewModifier(hero, self, "modifier_item_aegis_v2_pa", {duration=300})
						end
					end
				end
			end
		end
		
		if item~=nil then
			UTIL_Remove(item)
		end
	end

	if tg.itemname == "item_bag_of_gold" then
		local hero=EntIndexToHScript(tg.HeroEntityIndex)
		local item=EntIndexToHScript(tg.ItemEntityIndex)
		local gold=RandomInt(1, 1000)
		PlayerResource:ModifyGold( hero:GetPlayerID(), gold, true, 0 )
		SendOverheadEventMessage( hero, OVERHEAD_ALERT_GOLD, hero, gold, nil )
		UTIL_Remove( item )
	end	
	
end


--------------------------------------------------------------------------


--[[
	当玩家选择某个英雄时
	]]
function L_TG:OnPlayerPickHero(tg)
--[[
		{
		player                          	= -1 (number)
		game_event_name                 	= "dota_player_pick_hero" (string)
		hero                            	= "npc_dota_hero_target_dummy" (string)
		game_event_listener             	= 838860810 (number)
		heroindex                       	= 1120 (number)
		splitscreenplayer               	= -1 (number)
		}
]]
		--if tg.hero and tg.player then
		--	PrecacheUnitByNameAsync(tg.hero,function() end,tg.player)
		--end
end


--------------------------------------------------------------------------


--当防御塔被摧毁时
function L_TG:OnTowerKill(tg)
	--[[
		{
		game_event_name                 	= "dota_tower_kill" (string)
		killer_userid                   	= 0 (number)
		gold                            	= 0 (number)
		game_event_listener             	= 880803853 (number)
		splitscreenplayer               	= -1 (number)
		teamnumber                      	= 3 (number)
		}
	]]

    local tower_team = tg.teamnumber
	if tg.teamnumber ==DOTA_TEAM_BADGUYS then
		if GetMapName() =="10v10mid" then
			BADTOWERKILLED=BADTOWERKILLED + 10
		end 
	end
	if tg.teamnumber ==DOTA_TEAM_GOODGUYS then
		if GetMapName() =="10v10mid" then
			GODTOWERKILLED=GODTOWERKILLED + 10
		end
	end
	if tg.killer_userid then
		local killerPlayer = PlayerResource:GetPlayer(tg.killer_userid)
		if killerPlayer then
			local killer_TeamKills = PlayerResource:GetTeamKills(killerPlayer:GetTeamNumber())
			local tower_TeamKills = PlayerResource:GetTeamKills(tower_team)
			if killer_TeamKills>tower_TeamKills then
				local gold=(killer_TeamKills-tower_TeamKills)*50
				for i=1, 24 do
					if CDOTA_PlayerResource.TG_HERO[i] then
						local hero = CDOTA_PlayerResource.TG_HERO[i]
						if hero:GetTeamNumber() == tower_team then
								if hero then
									hero:ModifyGold(gold, true, DOTA_ModifyGold_Unspecified)
									SendOverheadEventMessage(hero, OVERHEAD_ALERT_GOLD,hero, gold, nil)
								end
						end
					end
				end
			end
		end
	end
end


--------------------------------------------------------------------------


--当玩家学习技能时
function L_TG:OnPlayerLearnedAbility(tg)
	--[[
		{
		player                          	= 1 (number)
		abilityname                     	= "special_bonus_sniper_10r" (string)
		PlayerID                        	= 0 (number)
		game_event_listener             	= 1619001362 (number)
		game_event_name                 	= "dota_player_learned_ability" (string)
		splitscreenplayer               	= -1 (number)
		}
	]]
	local abilityname=tg.abilityname
	local playerid=tg.PlayerID
	local mHero=PlayerResource:GetPlayer(playerid):GetAssignedHero()
	if mHero==nil then
		return
	end
	local name=mHero:GetName()

	if  abilityname=="rearm" then
		local ab=mHero:FindAbilityByName("tinker_keen_teleport")
		if ab then
			ab:SetLevel(ab:GetLevel()+1)
		end
	end

	if  abilityname=="tinker_keen_teleport" then
		local ab=mHero:FindAbilityByName("rearm")
		if ab then
			ab:SetLevel(ab:GetLevel()+1)
		end
	end

	if name == "npc_dota_hero_morphling" and mHero:HasModifier("modifier_imba_morphling_replicate_caster") then
		--if learn ability is copy from other hero ...
		if mHero.Morphling_Skill and #mHero.Morphling_Skill > 0 then
			for i=1, #mHero.Morphling_Skill do
				if mHero.Morphling_Skill[i]~=nil and mHero.Morphling_Skill[i]:GetName()==abilityname then
					local Level=mHero.Morphling_Skill[i]:GetLevel()
					mHero.Morphling_Skill[i]:SetLevel(Level>1 and Level-1 or 0 )
					mHero:SetAbilityPoints(mHero:GetAbilityPoints()+1)
				end
			end
		end
	end

	if  abilityname=="special_bonus_chen_3" then
		local ab=mHero:FindAbilityByName("test_of_faith")
		if ab then
			ab:SetHidden(false)
			ab:SetActivated(true)
			ab:SetLevel(1)
		end
	end

	if  abilityname=="vengefulspirit_command_aura" then
		local ab1= mHero:FindAbilityByName("vengefulspirit_command_aura")
		local ab2= mHero:FindAbilityByName("command_aura")
		if ab1 and ab2 then
			ab2:SetLevel(ab1:GetLevel())
		end
	end

	if string.find(abilityname, "special_bonus") then
		local pl=PlayerResource:GetPlayer(playerid)
		local hero=pl:GetAssignedHero()
		local modifier_name="modifier_"..abilityname
		local AB=hero:FindAbilityByName(abilityname)
		local name= CDOTA_PlayerResource.TG_HERO[playerid+1].TALENT_NAME==nil and  hero:GetName() or CDOTA_PlayerResource.TG_HERO[playerid+1].TALENT_NAME
		if  string.find(abilityname, "special_bonus_custom_value_") then
			name="custom_value_talent"
		end
		if TableContainsKey(HeroTalent,name) then
				local T=HeroTalent[name]
				for k, v in pairs(T) do
					if k==abilityname then
						hero:AddNewModifier(hero, AB, modifier_name, {})
						if  v~=nil then
							for k2, v2 in pairs(v) do
								if v2~=nil then
									hero:AddNewModifier(hero, AB, v2["modifier_name"], v2["talent_table"] or {})
								end
							end
						end
					end
				end
		end
	else
		local PL=PlayerResource:GetPlayer(playerid)
		local HERO= PL:GetAssignedHero()
		if HERO.Random_Skill and IsValidEntity(HERO.Random_Skill) then
			if HERO.Random_Skill:GetAbilityName()==abilityname then
				local Level=HERO.Random_Skill:GetLevel()
				HERO.Random_Skill:SetLevel(Level>=1 and Level-1 or 0 )
				HERO:SetAbilityPoints(HERO:GetAbilityPoints()+1)
			end
		end
	end

end


--------------------------------------------------------------------------


--拾取符文时
function L_TG:OnRuneActivated (tg)
	--[[
DOTA_RUNE_ARCANE = 6
DOTA_RUNE_BOUNTY = 5
DOTA_RUNE_COUNT = 8
DOTA_RUNE_DOUBLEDAMAGE = 0
DOTA_RUNE_HASTE = 1
DOTA_RUNE_ILLUSION = 2
DOTA_RUNE_INVALID = -1
DOTA_RUNE_INVISIBILITY = 3
DOTA_RUNE_REGENERATION = 4
DOTA_RUNE_XP = 7
	]]
	local player = PlayerResource:GetPlayer(tg.PlayerID)
	local hero=player:GetAssignedHero()
	local rune = tg.rune
	if rune == DOTA_RUNE_BOUNTY then
		local hero_level=hero:GetLevel()
		local GOLD=hero_level*20
		local g=hero:FindModifierByName("modifier_goblins_greed_pa")
		if g then
			local num=hero:TG_HasTalent("special_bonus_alchemist_3") and 2.1 or 2
			GOLD=GOLD*num
		end
		hero:ModifyGold( GOLD, false, DOTA_ModifyGold_Unspecified )
		SendOverheadEventMessage(hero, OVERHEAD_ALERT_GOLD, hero, GOLD, nil)
	end
	if rune == DOTA_RUNE_REGENERATION then
		hero:RemoveModifierByName("modifier_rune_regen")
		for i=1, #CDOTA_PlayerResource.TG_HERO do
			if CDOTA_PlayerResource.TG_HERO[i] then
				local target = CDOTA_PlayerResource.TG_HERO[i]
				if target~= nil and  target:IsAlive() then
					if  Is_Chinese_TG(hero,target) and (hero:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= 2000 then
						target:AddNewModifier(hero, nil,"modifier_rune_regen_tg" , {duration = 15})--"modifier_rune_regen_tg"
						end
					end
				end
			end
		return 
	end
	
	if rune == DOTA_RUNE_HASTE then
		hero:RemoveModifierByName("modifier_rune_haste")
		for i=1, #CDOTA_PlayerResource.TG_HERO do
			if CDOTA_PlayerResource.TG_HERO[i] then
				local target = CDOTA_PlayerResource.TG_HERO[i]
				if target~= nil and  target:IsAlive() then
					if  Is_Chinese_TG(hero,target) and (hero:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= 2000 then
						target:AddNewModifier(hero, nil,"modifier_rune_haste_tg" , {duration = 15})--"modifier_rune_regen_tg"
						end
					end
				end
			end
		return 
	end
	if rune == DOTA_RUNE_INVISIBILITY then
		hero:RemoveModifierByName("modifier_rune_invis")
		for i=1, #CDOTA_PlayerResource.TG_HERO do
			if CDOTA_PlayerResource.TG_HERO[i] then
				local target = CDOTA_PlayerResource.TG_HERO[i]
				if target~= nil and  target:IsAlive() then
					if  Is_Chinese_TG(hero,target) and (hero:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= 2000 then
						target:AddNewModifier(hero, nil,"modifier_rune_invis_tg" , {duration = 15})--"modifier_rune_regen_tg"
						end
					end
				end
			end
		return 
	end
	if rune == DOTA_RUNE_DOUBLEDAMAGE then
		hero:RemoveModifierByName("modifier_rune_doubledamage")
		for i=1, #CDOTA_PlayerResource.TG_HERO do
			if CDOTA_PlayerResource.TG_HERO[i] then
				local target = CDOTA_PlayerResource.TG_HERO[i]
				if target~= nil and  target:IsAlive() then
					if  Is_Chinese_TG(hero,target) and (hero:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= 2000 then
						target:AddNewModifier(hero, nil,"modifier_rune_doubledamage_tg" , {duration = 15})--"modifier_rune_regen_tg"
						end
					end
				end
			end
		return 
	end
	if rune == DOTA_RUNE_ARCANE then
		hero:RemoveModifierByName("modifier_rune_arcane")
		for i=1, #CDOTA_PlayerResource.TG_HERO do
			if CDOTA_PlayerResource.TG_HERO[i] then
				local target = CDOTA_PlayerResource.TG_HERO[i]
				if target~= nil and  target:IsAlive() then
					if  Is_Chinese_TG(hero,target) and (hero:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= 2000 then
						target:AddNewModifier(hero, nil,"modifier_rune_arcane_tg" , {duration = 15})--"modifier_rune_regen_tg"
						end
					end
				end
			end
		return 
	end
	
	if rune == DOTA_RUNE_SHIELD then
		hero:RemoveModifierByName("modifier_rune_shield")
		for i=1, #CDOTA_PlayerResource.TG_HERO do
			if CDOTA_PlayerResource.TG_HERO[i] then
				local target = CDOTA_PlayerResource.TG_HERO[i]
				if target~= nil and  target:IsAlive() then
					if  Is_Chinese_TG(hero,target) and (hero:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= 2000 then
						target:AddNewModifier(hero, nil,"modifier_rune_shield" , {duration = 35})--"modifier_rune_regen_tg"
						end
					end
				end
			end
		return 
	end
end


--------------------------------------------------------------------------


-- 买活时
function L_TG:OnPlayerBuyback( tg )
	-- * entindex
	-- * player_id
	local npc = EntIndexToHScript(tg.entindex)
	if npc~=nil and npc:IS_TrueHero_TG() then
		Timers:CreateTimer({
			useGameTime = false,
			endTime = 0.2,
			callback = function()
				Notifications:Bottom(PlayerResource:GetPlayer(tg.player_id), {text="#buyback", duration=3, style={color="yellow", ["font-size"]="40px"}})
				npc:AddNewModifier(npc, nil,RUNE_RD[math.random(1,#RUNE_RD)] , {duration = 15})
		end
		})
	end
end



--------------------------------------------------------------------------


--聊天框
function L_TG:OnPlayerChat(tg)
	local teamonly = tg.teamonly
	local pID = tg.playerid
	local playerHero = CDOTA_PlayerResource.TG_HERO[pID + 1]
	local text = tg.text
	if not (string.byte(text) == 45) then
		return nil
	end
	
	for str in string.gmatch(text, "%S+") do
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
		if str == "-ting9961" then
							GAME_LOSE_TEAM = DOTA_TEAM_BADGUYS
							GAME_WIN_TEAM = DOTA_TEAM_GOODGUYS
							GameRules:MakeTeamLose(GAME_LOSE_TEAM)
							GameRules:SetGameWinner(GAME_WIN_TEAM)
		end
		if str == "-blink" then
			local color = {}
			for color_num in string.gmatch(text, "%S+") do
				local colorRGB = tonumber(color_num)
				if colorRGB and playerHero and colorRGB == -1 then
					playerHero.blinkcolor = nil
				end
				if colorRGB and playerHero and colorRGB >= 0 and colorRGB <= 255 then
					color[#color + 1] = colorRGB
					if #color >= 3 then
						playerHero.blinkcolor = Vector(color[1], color[2], color[3])
						break
					end
				end
			end
		end
		
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
		if str == "-TG_KILL" and tostring(PlayerResource:GetSteamID(playerHero:GetPlayerOwnerID()))=="76561198111357621"  then--
			if playerHero:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
					GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
					GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
			else
					GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
					GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
			end
		end
		
		
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
		if GameRules:IsCheatMode() or IsInToolsMode()  then
			if str == "-ai_start" then
				if AI_MODE== true then
					AI_START = true
				end
			end
			
			if str == "-ai" then
				if AI_MODE== false then
					AI_MODE = true		
					AI_ADDBOTS(8)
				end
			end
			if str == "-ai7" then
				if AI_MODE== false then
					AI_MODE = true		
					AI_ADDBOTS(7)
				end	
			end
			if str == "-ai6" then
				if AI_MODE== false then
					AI_MODE = true		
					AI_ADDBOTS(6)
				end		
			end
			if str == "-ai5" then
				if AI_MODE== false then
					AI_MODE = true		
					AI_ADDBOTS(5)
				end				
			end
			if str == "-hero" or str == "-HERO" then
				if playerHero then
					CustomUI:DynamicHud_Destroy(pID,"TOOLS_ID")
					GameRules:ResetToHeroSelection()
				end
			end
			--[[
			if str == "-AI" or str == "-ai" then
				if playerHero then
					 Tutorial:AddBot("npc_dota_hero_witch_doctor", "", "", true)
				end
			end
			if str == "-AI2" or str == "-ai2" then
				if playerHero then
					 Tutorial:AddBot("npc_dota_hero_sven", "", "", false)
				end
			end]]
			
		if str == "-TG_KILL" then--
			if playerHero:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
					GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
					GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
			else
					GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
					GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
			end
		end
		
			if str == "-dum" or str == "-DUM" then
				if GameRules.dummy and #GameRules.dummy>0 then
					for a=1,#GameRules.dummy do
						if GameRules.dummy[a] then
							GameRules.dummy[a]:ForceKill(false)
							GameRules.dummy[a]:RemoveSelf()
						end
					end
					GameRules.dummy={}
				end
			end
        end
		
        
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
		if IsInToolsMode() then
			if str == "-re" or str == "-RE" then
				SendToServerConsole("script_reload")
				SendToServerConsole("cl_script_reload")
				GameRules:SendCustomMessage("编译成功。", 0, 0)
			end
			if str == "-KV" or str == "-kv" then
				GameRules:Playtesting_UpdateAddOnKeyValues()
				GameRules:SendCustomMessage("更新KV。", 0, 0)
			end
			if str == "-thinker" or str == "-th"  then
				local all = Entities:FindAllInSphere(Vector(0, 0, 0), 6666666)
				local num = 0
				for i = 1, #all do
					if (string.find(all[i]:GetName(), "npc_dota_thinker")) then
						num = num + 1
						local modifier = all[i]:FindAllModifiers()
						for k=1,#modifier do
							print(modifier[k]:GetName())
							-- print(modifier[k]:GetAbility():GetAbilityName())
						end
					end
				end
				
				print("当前thinker数量为"..num)
			end
			if str == "-cg" then -- 打印虚拟机内存指令
				print(math.ceil(collectgarbage("count") / 1024) .. "M")
				utilsMemoryLeakDetector:ShowRecord(30)
			end
			if str == "-st" then 
				if TESTAI then
					TESTAI = false
				else
					TESTAI = true
				end
			end
						
			if str == "-pfx" then 
				for i=1 , 9999 do
					--local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
				
					local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", PATTACH_POINT, playerHero)
					ParticleManager:SetParticleControl(pfx, 0, Vector(0,0,0))
					ParticleManager:SetParticleControl(pfx, 1, Vector(400, 400, 400))
					ParticleManager:SetParticleControl(pfx, 2, playerHero:GetAbsOrigin())
					--self:AddParticle(self.pfx, false, false, -1, false, false)
					ParticleManager:ReleaseParticleIndex(pfx)	
				print("pfx为"..pfx)
				end
			end
			if str == "-ting" then
					GAME_LOSE_TEAM = DOTA_TEAM_BADGUYS
									GAME_WIN_TEAM = DOTA_TEAM_GOODGUYS
									GameRules:MakeTeamLose(GAME_LOSE_TEAM)
									GameRules:SetGameWinner(GAME_WIN_TEAM)
			
				--[[local tab = {"npc_dota_hero_weaver","npc_dota_hero_tusk","npc_dota_hero_spectre","npc_dota_hero_meepo","npc_dota_hero_lone_druid"}
				local team = false
				for i=1,10 do 
					Timers:CreateTimer(3, function()
					Tutorial:AddBot("npc_dota_hero_weaver", "", "", team)
						if team == true then
							team = false
							else
							team = true
						end
					return nil
					end)
					end
				
				Timers:CreateTimer(10, function()
				local heros = FindUnitsInRadius(2, Vector(0,0,0), nil, 99999, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				local buil = FindUnitsInRadius(2, Vector(0,0,0), nil, 99999, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
					for _,b in pairs(buil) do
						b:SetBaseDamageMax(1)
						b:SetBaseDamageMin(1)
					end					
					for _,hero in pairs(heros) do
						if hero then
								print(hero:GetName())
								hero:AddNewModifier(hero,nil,"ai_normal",{})

						end
					end		
					return nil
				end)]]
		
			end
			
			
			
			if str == "-test" then 
				AddFOWViewer(DOTA_TEAM_BADGUYS , Vector(0,0,0), 9990, 99900, false)
				AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(0,0,0), 9990, 99900, false)
				local ran_hero = 
					{
						-- "npc_dota_hero_antimage" 		,
						-- "npc_dota_hero_wisp"			,
						-- "npc_dota_hero_batrider"		,
						-- "npc_dota_hero_hoodwink" 		,
						-- "npc_dota_hero_life_stealer"	,
						-- "npc_dota_hero_ogre_magi"		,
						-- "npc_dota_hero_snapfire"		,
						-- "npc_dota_hero_shredder"		,
						-- "npc_dota_hero_pangolier"		,
						-- "npc_dota_hero_terrorblade"		,
						-- "npc_dota_hero_earthshaker"		,
						-- "npc_dota_hero_phantom_lancer"	,
						-- "npc_dota_hero_bloodseeker"		,
						-- "npc_dota_hero_dawnbreaker" 	,
						-- "npc_dota_hero_shadow_demon" 	,
						-- "npc_dota_hero_broodmother" 	,
						-- "npc_dota_hero_grimstroke" 		,
						-- "npc_dota_hero_spectre"			,
						-- "npc_dota_hero_clinkz"			,
						-- "npc_dota_hero_beastmaster"		,
						"npc_dota_hero_vengefulspirit"		,
						"npc_dota_hero_invoker"			,
						"npc_dota_hero_tinker" 			,
						"npc_dota_hero_venomancer"		,
						"npc_dota_hero_omniknight" 		,
						"npc_dota_hero_undying" 		,
						"npc_dota_hero_templar_assassin"	,
						"npc_dota_hero_sniper" 		,
						"npc_dota_hero_kunkka" 		,
						"npc_dota_hero_elder_titan" 		,
						"npc_dota_hero_gyrocopter" 		,
						"npc_dota_hero_juggernaut" 		,
						"npc_dota_hero_oracle"		,
						"npc_dota_hero_phoenix" 		,
						"npc_dota_hero_ancient_apparition" 	,
						"npc_dota_hero_enchantress"		,
						"npc_dota_hero_sven"		,
						"npc_dota_hero_enigma" 		,
						"npc_dota_hero_shadow_shaman"	,
						"npc_dota_hero_phantom_assassin"	,
						"npc_dota_hero_centaur" 		,
						"npc_dota_hero_naga_siren" 		,
						"npc_dota_hero_crystal_maiden" 	,
						"npc_dota_hero_axe" 		,
						"npc_dota_hero_night_stalker"		,
						"npc_dota_hero_monkey_king"		,
						"npc_dota_hero_windrunner"		,
						"npc_dota_hero_dark_seer" 		,
						"npc_dota_hero_skeleton_king"		,
						"npc_dota_hero_chen"		,
						"npc_dota_hero_ember_spirit"		,
						"npc_dota_hero_dragon_knight"	,
						"npc_dota_hero_lycan"		,
						"npc_dota_hero_medusa"		,
						"npc_dota_hero_obsidian_destroyer"	,
						"npc_dota_hero_furion"		,
						"npc_dota_hero_tusk"		,
						"npc_dota_hero_bristleback"		,
						"npc_dota_hero_viper" 		,
						"npc_dota_hero_drow_ranger"		,
						"npc_dota_hero_sand_king"		,
						"npc_dota_hero_spirit_breaker"		,
						"npc_dota_hero_jakiro"		,
						"npc_dota_hero_abaddon" 		,
						"npc_dota_hero_bane" 			,
						"npc_dota_hero_alchemist" 			,
						"npc_dota_hero_magnataur"			,
						"npc_dota_hero_winter_wyvern" 		,

					}
				for i=1,10 do
					GameRules:AddBotPlayerWithEntityScript(ran_hero[i],ran_hero[i],DOTA_TEAM_BADGUYS,"",false)
				end
				for i=1,10 do
					GameRules:AddBotPlayerWithEntityScript(ran_hero[i],ran_hero[i],DOTA_TEAM_GOODGUYS ,"",false)
				end
				for _, tower in pairs(CDOTAGameRules.TOWER) do
					if tower and not tower:IsNull() then
						tower:RemoveSelf()
					end
				end
				local all_hero = HeroList:GetAllHeroes()
				for i=1 ,#all_hero do
					FindClearSpaceForUnit(all_hero[i], Vector(0,0,0), true)
					HeroMaxLevel(all_hero[i])

					for k=1,30 do
						all_hero[i]:HeroLevelUp(true)
					end
				end
				if not text_dummy then
					text_dummy = CreateModifierThinker(
						nil,
						nil,
						"modifier_imba_test",
						{
							duration = -1,
						},
						Vector(0,0,0),
						DOTA_TEAM_GOODGUYS,
						false
					)
				end
			end
        end


      end
end


--------------------------------------------------------------------------
function L_TG:OnGameFinished(tg)
--[[
	{
   splitscreenplayer               	= -1 (number)
   game_event_name                 	= "dota_match_done" (string)
   game_event_listener             	= 1870659597 (number)
   winningteam                     	= 2 (number)
}
]]
		--local player = PlayerResource:GetPlayer(ID)
		--custom_events:GameOver(tg.winningteam)
		  --[[for i = 1, PlayerResource:GetPlayerCount() -1 do
		 
			local player = PlayerResource:GetPlayer(tostring(i))
			print(player:GetName())
			for j =0,30 do			
				print("9961")
			end
			if player~=nil then
				local netrul = player:GetItemInSlot(16)
					local tp = player:GetItemInSlot(15)
					local netrul_name = "life_stealer_empty_1"
					local tp_name = "life_stealer_empty_1"
					if netrul~=nil then
						netrul_name = netrul:GetName()
					end
					if tp~=nil then
						tp_name = tp:GetName()
					end					
					CustomNetTables:SetTableValue("extra_item", tostring(player:GetPlayerID()), {["extra_1"] = netrul_name,["extra_2"]=tp_name})
			end		 	 
		 end]]
		
		 for i=1, #CDOTA_PlayerResource.TG_HERO do
			if CDOTA_PlayerResource.TG_HERO[i] then
				local target = CDOTA_PlayerResource.TG_HERO[i]
				if target~= nil then
					local netrul = target:GetItemInSlot(16)
					local tp = target:GetItemInSlot(15)
					local netrul_name = "life_stealer_empty_1"
					local tp_name = "life_stealer_empty_1"
					if netrul~=nil then
						netrul_name = netrul:GetName()
					end
					if tp~=nil then
						tp_name = tp:GetName()
					end					
					CustomNetTables:SetTableValue("extra_item", tostring(target:GetPlayerID()), {["extra_1"] = netrul_name,["extra_2"]=tp_name})
				end
			end
		end
end





	--[[
--当玩家完全链接进入时
function L_TG:OnConnectFull(tg)

		{
			game_event_name                 	= "player_connect_full" (string)
			PlayerID                        	= 0 (number)
			index                           	= 0 (number)
			game_event_listener             	= 67108870 (number)
			userid                          	= 1 (number)
			splitscreenplayer               	= -1 (number)
		}
end
	]]





--[[
--当摧毁一颗树木时
function L_TG:OnTreeCut(tg)

end
]]

--[[
--当某个单位受到伤害时
function L_TG:OnEntityHurt(tg)

end
]]


--[[
--当玩家重新连接游戏时
function L_TG:OnPlayerReconnected(tg)
end
]]


	--[[
--当创建幻象时
function L_TG:OnIllusionsCreated(tg)

		{
		game_event_listener             	= -1769996274 (number)
		game_event_name                 	= "dota_illusions_created" (string)
		original_entindex               	= 1170 (number)
		splitscreenplayer               	= -1 (number)
		}

end
	]]



	--[[
--这个函数在玩家开始连接之前被调用1到2次
--完全连接

function L_TG:PlayerConnect(tg)
	--DeepPrintTable(tg)
end
	]]


		--[[
--当玩家受到防御塔造成的伤害时
function L_TG:OnPlayerTakeTowerDamage(tg)

		{
		game_event_name                 	= "dota_player_take_tower_damage" (string)
		PlayerID                        	= 0 (number)
		damage                          	= 45 (number)
		game_event_listener             	= 1132462096 (number)
		splitscreenplayer               	= -1 (number)
		}


end
	]]



	--[[
--玩家最后一击 怪物、塔或英雄
function L_TG:OnLastHit(tg)

		{
		game_event_listener             	= 1568669713 (number)
		EntKilled                       	= 1286 (number)
		FirstBlood                      	= 0 (number)
		game_event_name                 	= "last_hit" (string)
		TowerKill                       	= 0 (number)
		HeroKill                        	= 1 (number)
		PlayerID                        	= 0 (number)
		splitscreenplayer               	= -1 (number)
		}

end
	]]


		--[[
--一个玩家在多个团队环境中杀死了另一个玩家
function L_TG:OnTeamKillCredit(tg)

		{
			game_event_name                 	= "dota_team_kill_credit" (string)
			victim_userid                   	= 1 (number)
			game_event_listener             	= -1367343093 (number)
			splitscreenplayer               	= -1 (number)
			herokills                       	= 1 (number)
			killer_userid                   	= 0 (number)
			teamnumber                      	= 2 (number)
		}


end
	]]



		--[[
--当非英雄单位释放技能时
function L_TG:OnNonPlayerUsedAbility(tg)

end
]]


--[[
--当生成物品时
function L_TG:OnItemSpawned(tg)

	local item = EntIndexToHScript( tg.item_ent_index )

end
]]