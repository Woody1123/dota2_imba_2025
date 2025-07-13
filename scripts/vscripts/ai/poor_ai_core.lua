--一个简易的人工智障，只适用于该图----

--添加bot
function AI_ADDBOTS(num)	--根据指令补全机器人
	LinkLuaModifier("ai_normal","ai/ai_normal.lua",LUA_MODIFIER_MOTION_NONE )
	
	local hero_tab = {
"npc_dota_hero_dragon_knight",
"npc_dota_hero_viper",
"npc_dota_hero_skeleton_king",
"npc_dota_hero_axe",
"npc_dota_hero_chaos_knight",
"npc_dota_hero_drow_ranger",
"npc_dota_hero_zuus",
"npc_dota_hero_monkey_king",
"npc_dota_hero_leshrac",
"npc_dota_hero_juggernaut",
"npc_dota_hero_phantom_assassin",
"npc_dota_hero_slardar",
"npc_dota_hero_ancient_apparition",
"npc_dota_hero_skywrath_mage",
"npc_dota_hero_omniknight",
"npc_dota_hero_winter_wyvern",}

	AI_TOWER_MIN_LEVEL = (num*2)-8
	local  valid_player = 0
	local  ai_player = 0
	local  good_player = 0
	local  bad_player = 0
	for i = 0, 19 do
        if PlayerResource:IsValidPlayer( i ) then   
            valid_player = valid_player + 1
            if PlayerResource:GetPlayer( i ):GetTeamNumber() == 2 then
                good_player = good_player + 1
            elseif PlayerResource:GetPlayer( i ):GetTeamNumber() == 3 then
                bad_player = bad_player + 1
            end
        end
    end
	
	for i=1,valid_player do
		for j=1,#hero_tab do
			if CDOTA_PlayerResource.TG_HERO[i]:GetName() == hero_tab[j] then
					table.remove(hero_tab,j)
			end		
		end
	end
	
	ai_player = valid_player
	num = num -1
	
	
	local hero_tab_good = {}
	local hero_tab_bad = {}
	if #hero_tab~= 0 then
		for i =0,num-good_player do
			local ran = RandomInt(1,#hero_tab)
			table.insert(hero_tab_good,hero_tab[ran])
			table.remove(hero_tab,ran)
		end
	end
	
	if #hero_tab~= 0 then
		for i =0,num-bad_player do
			local ran = RandomInt(1,#hero_tab)
			table.insert(hero_tab_bad,hero_tab[ran])
			table.remove(hero_tab,ran)
		end
	end
	
	for k,h in pairs(hero_tab_good) do
	Timers:CreateTimer(3*k, function()
		Tutorial:AddBot(h,"", "", true)
		ai_player = ai_player + 1
		AI_ON(ai_player)	--激活ai
		return nil
		end)
	end
	for k,h in pairs(hero_tab_bad) do
		Timers:CreateTimer(3*k, function()
		Tutorial:AddBot(h,"", "", false)
		ai_player = ai_player + 1
		AI_ON(ai_player)	--激活ai
		return nil
		end)
	end
	--[[
	for i =0,num-good_player do --天辉补全
		Timers:CreateTimer(3*i, function()
		if #hero_tab_good~=0 then
			local ran = RandomInt(1,#hero_tab)
			Tutorial:AddBot(hero_tab[ran],"", "", true)
			table.remove(hero_tab,ran)
			else
			Tutorial:AddBot("npc_dota_hero_axe","", "", true)
		end
		ai_player = ai_player + 1
		AI_ON(ai_player)	--激活ai
		return nil
		end)
	end
	
	for i =0,num-bad_player do	--夜宴补全
		Timers:CreateTimer(3*i, function()
		if #hero_tab~=0 then
			local ran = RandomInt(1,#hero_tab)
			Tutorial:AddBot(hero_tab[ran],"", "", false)
			table.remove(hero_tab,ran)
			else
			Tutorial:AddBot("npc_dota_hero_axe","", "", false)
		end
		ai_player = ai_player + 1
		AI_ON(ai_player)	--激活ai
		return nil 
		end)
	end]]
	--15秒后统一激活ai
	--[[
	Timers:CreateTimer(15, function()
	
	    for i=valid_player+1, 24 do
            if CDOTA_PlayerResource.TG_HERO[i] then
                local hero = CDOTA_PlayerResource.TG_HERO[i]
                if hero~= nil and hero:IsAlive() then                 
					if IsInTable(hero:GetName(),hero_tab) then
						local modifier_name = tostring(hero:GetName()).."_ai"
						--print(modifier_name)
						LinkLuaModifier(modifier_name, "ai/ai_hero/"..modifier_name, LUA_MODIFIER_MOTION_NONE)
						if hero.ai==nil then 
							hero.ai = hero:AddNewModifier(hero,nil,modifier_name,{})
						end	
						
						else
						if hero.ai == nil then
							hero.ai=hero:AddNewModifier(hero,nil,"ai_normal",{})
						end
					end							
					table.insert(AI_HERO,hero)
					hero:AddExperience(GetXPNeededToReachNextLevel(4), DOTA_ModifyXP_Unspecified, false, false)
					hero:AddNewModifier(hero, nil, "modifier_player", {})
                end
            end
        end
	return nil
	end]]
	--确保所有ai都正常再开打
	Timers:CreateTimer(0, function()
		local ai_all_o = 0
		for i = valid_player+1,(num+1)*2 do
			local ai_hero_o  = CDOTA_PlayerResource.TG_HERO[i]
			if ai_hero_o and ai_hero_o.ai then
				ai_all_o = ai_all_o + 1
			end
		end
		--print(ai_all_o)
		--print((num+1)*2-1)
		if ai_all_o == (num+1)*2-1 then 
			AI_START = true
			return nil 
			else
			return 3
		end	
	end)
	
	
	--启动ai行动timer--
	Timers:CreateTimer(0, function()
		if AI_START then 
			for _,hero in pairs(AI_HERO) do
				if hero.ai and hero:IsAlive() then
					hero.ai:think()
				end
			end
		end
		local game_time = GameRules:GetGameTime()/60
		if game_time > 20  then
			PUSH_LEVEL = 3
			else
			if game_time > 10  then
				PUSH_LEVEL = 2
			else
				PUSH_LEVEL = 1
			end
		end
		return 1
		end)	
end		

function AI_ON(ai_player) 
	Timers:CreateTimer(5, function()
		if CDOTA_PlayerResource.TG_HERO[ai_player] then
		local hero = CDOTA_PlayerResource.TG_HERO[ai_player]
		if hero~= nil and hero:IsAlive() then                 
			--print(hero:GetName()) 
			--print(IsInTable(hero:GetName(),AI_HERO_TABLE))
			if IsInTable(hero:GetName(),AI_HERO_TABLE) then
				local modifier_name = tostring(hero:GetName()).."_ai"
				--print(modifier_name)
				LinkLuaModifier(modifier_name, "ai/ai_hero/"..modifier_name, LUA_MODIFIER_MOTION_NONE)
				if hero.ai==nil then 
					hero.ai = hero:AddNewModifier(hero,nil,modifier_name,{})
				end	
				
				else
				if hero.ai == nil then
					hero.ai=hero:AddNewModifier(hero,nil,"ai_normal",{})
				end
			end							
			hero:SetControllableByPlayer(hero:GetPlayerID(), true)
			--print(hero:GetPlayerID())
			--print(hero:GetName())
			table.insert(AI_HERO,hero)
			hero:AddExperience(GetXPNeededToReachNextLevel(4), DOTA_ModifyXP_Unspecified, false, false)
			hero:AddNewModifier(hero, nil, "modifier_player", {})
			hero:AddNewModifier(hero, nil, "modifier_item_ultimate_scepter_consumed", {})
			hero:AddNewModifier(hero, nil, "modifier_item_aghanims_shard", {})
			--print(hero:GetName())
			--print("LVLUP")
		end
	end
	return nil
	end)
end


--判断敌我军力差距
function AI_CHECK_SITUATION(hero) 
	local level = 0
	local enemy_level = 0
	local friend_level = 0
	local enemy_num = 0
	local friend_num = 0
	local friend_table = {}
	local enemy_table = {}
	local unit_table = {}
	local time_level = math.max(15 - math.ceil(GameRules:GetGameTime()/60),AI_TOWER_MIN_LEVEL)
	local units = FindUnitsInRadius(hero:GetTeam(),hero:GetAbsOrigin(),nil,1800,DOTA_UNIT_TARGET_TEAM_BOTH,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE,FIND_CLOSEST,false)
    if #units > 0 then
		for _,unit in pairs(units) do
			if unit:IsAlive() then
				if Is_Chinese_TG(unit,hero) then
						if unit:IsHero() then
							friend_level = friend_level + (unit.lv or 1 )
							friend_num = friend_num + 1
							table.insert(friend_table,unit)
							else
							if unit:IsBuilding() then
								friend_level = friend_level + 1
								if (hero:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D() < 300 then
									friend_level = friend_level + time_level
								end
							end
						end
					else
						if unit:IsHero() then
							enemy_level = enemy_level + (unit.lv or 1 )
							enemy_num = enemy_num + 1
							table.insert(enemy_table,unit)
							else
							if unit:IsBuilding() then
								fenemy_level = enemy_level + 1
								if (hero:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D() < 950 then
									enemy_level = enemy_level + time_level
								end
							end
						end
					end
				end
			end
	end
	
		table.insert(unit_table,friend_table)
		table.insert(unit_table,enemy_table)
		local f_e	= friend_level-enemy_level
		
		table.insert(unit_table,f_e)
		table.insert(unit_table,friend_num-enemy_num)
	return unit_table
end
--进入ai英雄自身的行动判断

--行动-- 只是简单的往对面高地去进攻，摧毁途经得一切
function AI_MOVEABOUT(hero,level,per,pos)
	local pos = pos or nil
	local health_per = (hero:GetHealth()/hero:GetMaxHealth())*100
	local lv = level
	local pos_good = Vector(-6000,-6000,256)--spawner_creep:GetGoodCreepSpawn()
	local pos_bad = Vector(6000,6000,256)--spawner_creep:GetBadCreepSpawn()
	
	
	if  health_per < 20 then
		hero:MoveToPosition(hero:GetTeam()==2 and pos_good or pos_bad)
		hero.action_lv = 30
		hero.stat = 4	-- 逃命
		return 
	end
	
	if hero.ai.unit_table[4] < -3 and lv <= 3 then
		hero:MoveToPosition(hero:GetTeam()==2 and pos_good or pos_bad)
		hero.action_lv = 3
		hero.stat = 3	-- 人太少了 并且不在塔下 跑路
		return 
	end
	
	if hero.stat == 1 and pos~=nil then
		local dir=TG_Direction(hero:GetAbsOrigin(),pos)
		local next_pos = GetGroundPosition(hero:GetAbsOrigin() + dir * 200, hero)
		hero:MoveToPosition(next_pos)
		pos = nil
		return
	end                     	
	
	if (health_per<=per and lv <= 2)  then	--低血后退
		hero:MoveToPosition(hero:GetTeam()==3 and pos_bad or pos_good)
		hero.action_lv = 1 
		hero.stat = 3	
	else
		if lv>=-3 then		--干架
			if hero.attacker_target then
				hero:MoveToTargetToAttack(hero.attacker_target)
				else
				hero:MoveToPositionAggressive(hero:GetTeam()==2 and AI_PUSH_GOOD[PUSH_LEVEL] or AI_PUSH_BAD[PUSH_LEVEL])
			end
				hero.stat = 1
			else --走位
			hero:MoveToPosition(hero:GetTeam()==2 and pos_good or pos_bad)
			hero.stat = 2
		end	
	end
end


--AI的难度与等级最大等级有关 
function AI_LVLUP(hero) 
	if hero:GetLevel()%5==0 then

		local lv = hero:GetLevel()/5 
		if not hero.ai or not hero.ai.ability_table or not hero.ai.item_table or not hero.ai.talent_table or not hero.ai.veteran_talent_table then return end

		if lv <=4 then
			--print("lv=1")
			LEARN_ABILITY(lv,hero,hero.ai.ability_table)
			ADD_ITEM(lv,hero,hero.ai.item_table)
			--hero.ai:learn_ability(lv,hero,hero.ai.ability_table)
			--hero.ai:add_item(lv,hero,hero.ai.item_table)
			else
			if lv<=6 then
				ADD_ITEM(lv,hero,hero.ai.item_table)
				LEARN_TALENT(lv-4,hero,hero.ai.talent_table)
			--	hero.ai:add_item(lv,hero,hero.ai.item_table)
				--hero.ai:learn_talent(lv-4,hero,hero.ai.talent_table)	
				else
				if lv<=8 then
					ADD_ITEM(lv,hero,hero.ai.item_table)
					LEARN_VETERAN_TALENT(lv-6,hero,hero.ai.veteran_talent_table)
				--	hero:add_item(lv,hero,hero.ai.item_table)
					--hero.ai:learn_veteran_talent(lv-6,hero,hero.ai.veteran_talent_table)	
				end
			end
		end	
	end
end
--ai到了指定等级获得的装备技能升级天赋符文等
function LEARN_ABILITY(lv,hero,ability_table)
		for _,ab in pairs(ability_table) do
			if ab then
				ab:SetLevel(lv)
			end
		end	
end

function ADD_ITEM(lv,hero,item_table)   
	if lv <= 6 then
	hero:AddItemByName(item_table[lv])	--普通物品
	end
	if lv == 7 then				--中立物品
		
	end
end 

function LEARN_TALENT(lv,hero,talent_table)   	
	--[[
	for i = (lv-1)*4+9,lv*4+9 do  
		local ab = hero:GetAbilityByIndex(i)   
		if ab then
			print(ab:GetName())
			hero:UpgradeAbility(ab)
		end
	end]]
	
	for i = (lv-1)*4+1, lv*4 do
		local ab = hero:FindAbilityByName(talent_table[i])
		if ab then
			hero:UpgradeAbility(ab)
			--print(ab:GetName())
			--ab:SetLevel(1)
			--hero:AddNewModifier(hero,nil,"modifier_"..ab:GetName(),{})
		end
	end
end

function LEARN_VETERAN_TALENT(lv,hero,veteran_talent_table)   --最后每5级一个3级符文
		hero:RemoveModifierByName(veteran_talent_table[lv])
		local modifier = hero:AddNewModifier(hero,nil,veteran_talent_table[lv],{duration = -1})
			if modifier then
				modifier:SetStackCount(3)
				hero:AddNewModifier(hero,nil,veteran_talent_table[lv],{duration = -1})
				hero:CalculateStatBonus(true)
			end
end