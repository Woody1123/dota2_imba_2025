--一个简易的人工智障，只适用于该图----


--添加bot
function AI_ADDBOTS()
	LinkLuaModifier("ai_normal", "ai/ai_normal.lua", LUA_MODIFIER_MOTION_NONE)

	-- 自定义：获取所有英雄名称列表（你自己实现）
	local allHeroes = GetAllHeroNames()

	-- 打乱英雄顺序函数
	local function ShuffleTable(t)
		for i = #t, 2, -1 do
			local j = RandomInt(1, i)
			t[i], t[j] = t[j], t[i]
		end
	end
	ShuffleTable(allHeroes)

	-- 分队英雄列表（可以根据你想法调整）
	local hero_tab_good = {}
	local hero_tab_bad = {}
	for i = 1, 10 do
		table.insert(hero_tab_good, allHeroes[i])
	end
	for i = 11, 20 do
		table.insert(hero_tab_bad, allHeroes[i])
	end

	-- 统计当前bot数量
	local function CountBotsOnTeam(team)
		local count = 0
		for i = 0, DOTA_MAX_PLAYERS-1 do
			if PlayerResource:IsValidPlayerID(i) and PlayerResource:IsFakeClient(i) and PlayerResource:GetTeam(i) == team then
				count = count + 1
			end
		end
		return count
	end

	-- 补足天辉队bot到10个
	local goodNeed = 10 - CountBotsOnTeam(DOTA_TEAM_GOODGUYS)
	local badNeed = 10 - CountBotsOnTeam(DOTA_TEAM_BADGUYS)

	local ai_player = 0

	-- 添加天辉bot，补足缺口
	for k = 1, goodNeed do
		local h = hero_tab_good[k]
		if h then
			Timers:CreateTimer(3 * k, function()
				Tutorial:AddBot(h, "", "", true) -- 天辉
				ai_player = ai_player + 1
				AI_ON(ai_player)
				return nil
			end)
		end
	end

	-- 添加夜魇bot，补足缺口
	for k = 1, badNeed do
		local h = hero_tab_bad[k]
		if h then
			Timers:CreateTimer(3 * k, function()
				Tutorial:AddBot(h, "", "", false) -- 夜魇
				ai_player = ai_player + 1
				AI_ON(ai_player)
				return nil
			end)
		end
	end
end

function AI_ON(ai_player)
	Timers:CreateTimer(5, function()
		print('启动ai')
		if CDOTA_PlayerResource.TG_HERO[ai_player] then
			local hero = CDOTA_PlayerResource.TG_HERO[ai_player]
			if hero ~= nil and hero:IsAlive() then
				local playerID = hero:GetPlayerID()
				-- 判断是否是玩家控制，如果是玩家则不加AI Modifier
				if not PlayerResource:IsFakeClient(playerID) then
					print("玩家控制英雄，不加 AI")
					return nil
				end
				local hero_name = hero:GetName()
				local modifier_name = hero_name .. "_ai"
				local ai_loaded = false

				--if IsInTable(hero_name, AI_HERO_TABLE) then
				--	local script_path = "ai/ai_hero/" .. modifier_name
				--	local success = pcall(function()
				--		LinkLuaModifier(modifier_name, script_path, LUA_MODIFIER_MOTION_NONE)
				--	end)
				--
				--	if success then
				--		hero.ai = hero:AddNewModifier(hero, nil, modifier_name, {})
				--		ai_loaded = true
				--	else
				--		print("[AI] 未找到专属AI脚本，已切换为通用AI: " .. hero_name)
				--	end
				--end

				if not ai_loaded then
					if hero.ai == nil then
						print('增加normalai')
						LinkLuaModifier("ai_normal", "ai/ai_normal.lua", LUA_MODIFIER_MOTION_NONE)
						hero.ai = hero:AddNewModifier(hero, nil, "ai_normal", {})
					end
				end

				-- **这里不调用SetControllableByPlayer(false)，默认允许玩家控制**

				table.insert(AI_HERO, hero)
				hero:AddExperience(GetXPNeededToReachNextLevel(4), DOTA_ModifyXP_Unspecified, false, false)
				hero:AddNewModifier(hero, nil, "modifier_player", {})
				hero:AddNewModifier(hero, nil, "modifier_item_ultimate_scepter_consumed", {})
				hero:AddNewModifier(hero, nil, "modifier_item_aghanims_shard", {})
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

function GetAllHeroNames()
	return {
		"npc_dota_hero_antimage",
		"npc_dota_hero_axe",
		"npc_dota_hero_bane",
		"npc_dota_hero_bloodseeker",
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_drow_ranger",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_mirana",
		"npc_dota_hero_morphling",
		"npc_dota_hero_nevermore",
		"npc_dota_hero_phantom_lancer",
		"npc_dota_hero_puck",
		"npc_dota_hero_pudge",
		"npc_dota_hero_razor",
		"npc_dota_hero_sand_king",
		"npc_dota_hero_storm_spirit",
		"npc_dota_hero_sven",
		"npc_dota_hero_tiny",
		"npc_dota_hero_vengefulspirit",
		"npc_dota_hero_windrunner",
		"npc_dota_hero_zuus",
		"npc_dota_hero_kunkka",
		"npc_dota_hero_lina",
		"npc_dota_hero_lion",
		"npc_dota_hero_shadow_shaman",
		"npc_dota_hero_slardar",
		"npc_dota_hero_tidehunter",
		"npc_dota_hero_witch_doctor",
		"npc_dota_hero_riki",
		"npc_dota_hero_enigma",
		"npc_dota_hero_tinker",
		"npc_dota_hero_sniper",
		"npc_dota_hero_necrolyte",
		"npc_dota_hero_warlock",
		"npc_dota_hero_beastmaster",
		"npc_dota_hero_queenofpain",
		"npc_dota_hero_venomancer",
		"npc_dota_hero_faceless_void",
		"npc_dota_hero_skeleton_king",
		"npc_dota_hero_death_prophet",
		"npc_dota_hero_phantom_assassin",
		"npc_dota_hero_pugna",
		"npc_dota_hero_templar_assassin",
		"npc_dota_hero_viper",
		"npc_dota_hero_luna",
		"npc_dota_hero_dragon_knight",
		"npc_dota_hero_dazzle",
		"npc_dota_hero_rattletrap",
		"npc_dota_hero_leshrac",
		"npc_dota_hero_furion",
		"npc_dota_hero_life_stealer",
		"npc_dota_hero_dark_seer",
		"npc_dota_hero_clinkz",
		"npc_dota_hero_omniknight",
		"npc_dota_hero_enchantress",
		"npc_dota_hero_huskar",
		"npc_dota_hero_night_stalker",
		"npc_dota_hero_broodmother",
		"npc_dota_hero_bounty_hunter",
		"npc_dota_hero_weaver",
		"npc_dota_hero_jakiro",
		"npc_dota_hero_batrider",
		"npc_dota_hero_chen",
		"npc_dota_hero_spectre",
		"npc_dota_hero_doom_bringer",
		"npc_dota_hero_ancient_apparition",
		"npc_dota_hero_invoker",
		"npc_dota_hero_silencer",
		"npc_dota_hero_obsidian_destroyer",
		"npc_dota_hero_lycan",
		"npc_dota_hero_brewmaster",
		"npc_dota_hero_shadow_demon",
		"npc_dota_hero_lone_druid",
		"npc_dota_hero_chaos_knight",
		"npc_dota_hero_meepo",
		"npc_dota_hero_treant",
		"npc_dota_hero_ogre_magi",
		"npc_dota_hero_undying",
		"npc_dota_hero_rubick",
		"npc_dota_hero_disruptor",
		"npc_dota_hero_nyx_assassin",
		"npc_dota_hero_naga_siren",
		"npc_dota_hero_keeper_of_the_light",
		"npc_dota_hero_wisp",
		"npc_dota_hero_visage",
		"npc_dota_hero_slark",
		"npc_dota_hero_medusa",
		"npc_dota_hero_troll_warlord",
		"npc_dota_hero_centaur",
		"npc_dota_hero_magnataur",
		"npc_dota_hero_shredder",
		"npc_dota_hero_bristleback",
		"npc_dota_hero_tusk",
		"npc_dota_hero_skywrath_mage",
		"npc_dota_hero_abaddon",
		"npc_dota_hero_elder_titan",
		"npc_dota_hero_legion_commander",
		"npc_dota_hero_techies",
		"npc_dota_hero_ember_spirit",
		"npc_dota_hero_earth_spirit",
		"npc_dota_hero_underlord",
		"npc_dota_hero_templar_assassin",
		"npc_dota_hero_terrorblade",
		"npc_dota_hero_phoenix",
		"npc_dota_hero_oracle",
		"npc_dota_hero_winter_wyvern",
		"npc_dota_hero_arc_warden",
		"npc_dota_hero_abyssal_underlord",
		"npc_dota_hero_monkey_king",
		"npc_dota_hero_dark_willow",
		"npc_dota_hero_pangolier",
		"npc_dota_hero_grimstroke",
		"npc_dota_hero_mars",
		"npc_dota_hero_rubick",
		"npc_dota_hero_snapfire",
		"npc_dota_hero_void_spirit",
		"npc_dota_hero_morphling", -- 有些英雄可能重复，去重时注意
	}
end