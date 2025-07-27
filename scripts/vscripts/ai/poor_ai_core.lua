-- 一个简易的人工智障，只适用于该图

function AI_ADDBOTS()
	LinkLuaModifier("ai_normal", "ai/ai_normal.lua", LUA_MODIFIER_MOTION_NONE)

	-- 固定英雄名
	local hero_name = "npc_dota_hero_bristleback"

	-- 分队英雄列表
	local hero_tab_good = {}
	local hero_tab_bad = {}
	for i = 1, 10 do
		table.insert(hero_tab_good, hero_name)
		table.insert(hero_tab_bad, hero_name)
	end

	-- 统计当前bot数量
	local function CountBotsOnTeam(team)
		local count = 0
		for i = 0, DOTA_MAX_PLAYERS - 1 do
			if PlayerResource:IsValidPlayerID(i) and PlayerResource:IsFakeClient(i) and PlayerResource:GetTeam(i) == team then
				count = count + 1
			end
		end
		return count
	end

	local goodNeed = 10 - CountBotsOnTeam(DOTA_TEAM_GOODGUYS)
	local badNeed = 10 - CountBotsOnTeam(DOTA_TEAM_BADGUYS)

	-- 使用自定义创建方法（不依赖 Tutorial:AddBot）
	for i = 1, goodNeed do
		Timers:CreateTimer(i * 0.3, function()
			CreateCustomAIHero(hero_name, DOTA_TEAM_GOODGUYS)
		end)
	end

	for i = 1, badNeed do
		Timers:CreateTimer(i * 0.3 + 3, function()
			CreateCustomAIHero(hero_name, DOTA_TEAM_BADGUYS)
		end)
	end
end

function CreateCustomAIHero(hero_name, team)
	print('创建ai')
	local spawn_pos = team == DOTA_TEAM_GOODGUYS and Vector(-6000, -6000, 256) or Vector(6000, 6000, 256)
	local hero = CreateUnitByName(hero_name, spawn_pos, true, nil, nil, team)
	if not hero then return end

	hero:SetControllableByPlayer(-1, false)
	hero.is_custom_ai = true
	hero:SetIdleAcquire(true)
	hero:SetAcquisitionRange(800)
	hero:AddExperience(GetXPNeededToReachNextLevel(4), DOTA_ModifyXP_Unspecified, false, false)

	if hero.ai == nil then
		print('加载ai')
		LinkLuaModifier("ai_normal", "ai/ai_normal.lua", LUA_MODIFIER_MOTION_NONE)
		hero.ai = hero:AddNewModifier(hero, nil, "ai_normal", {})
	end

	if not AI_HERO then AI_HERO = {} end
	table.insert(AI_HERO, hero)

	hero:AddNewModifier(hero, nil, "modifier_player", {})
	hero:AddNewModifier(hero, nil, "modifier_item_ultimate_scepter_consumed", {})
	hero:AddNewModifier(hero, nil, "modifier_item_aghanims_shard", {})
end

function GetAllHeroNames()
	return { "npc_dota_hero_bristleback" }
end