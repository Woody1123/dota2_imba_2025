if ai_normal == nil then
	ai_normal = class({})
end

function ai_normal:IsHidden() return false end
function ai_normal:IsDebuff() return false end
function ai_normal:IsPurgable() return false end
function ai_normal:IsPurgeException() return false end
function ai_normal:RemoveOnDeath() return false end

function ai_normal:OnCreated()
	if not IsServer() then return end

	self.parent = self:GetParent()
	self.enemyTower = nil
	self.lastTarget = nil
	self.beingTargetedByTower = false

	self:StartIntervalThink(0.5)
end

function ai_normal:OnIntervalThink()
	if not IsServer() then return end

	local hero = self.parent
	-- 防止多线程打断：记录通道中时间
	if self.castUntil and GameRules:GetGameTime() < self.castUntil then
		return
	end

	-- 检测通道技能
	if hero:IsChanneling() then
		-- 锁定AI行为几秒（通道技能持续时间）
		self.castUntil = GameRules:GetGameTime() + 3.0
		print("[AI] 通道技能锁定中，跳过指令")
		return
	end
	if hero == nil or not IsValidEntity(hero) or not hero:IsAlive() or hero:IsChanneling() then
		return
	end

	-- 自动升级和释放技能
	self:TryLevelUpAbilities()
	self:TryUseAbilities()
	self:TryBuyItems()
	self:TryUseItemsOnEnemyInRange()
	-- 优先攻击附近敌方英雄
	local enemyHeroes = FindUnitsInRadius(
			hero:GetTeamNumber(),
			hero:GetAbsOrigin(),
			nil,
			1000,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
			FIND_CLOSEST,
			false
	)
	if #enemyHeroes > 0 then
		self:AttackTarget(enemyHeroes[1])
		return
	end

	-- 没有英雄就攻击附近敌方小兵
	local enemyCreeps = FindUnitsInRadius(
			hero:GetTeamNumber(),
			hero:GetAbsOrigin(),
			nil,
			800,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
			FIND_CLOSEST,
			false
	)
	if #enemyCreeps > 0 then
		self:AttackTarget(enemyCreeps[1])
		return
	end

	-- 没有小兵，找最近敌方塔并攻击
	local towers = FindUnitsInRadius(
			hero:GetTeamNumber(),
			hero:GetAbsOrigin(),
			nil,
			1200, -- 攻击塔距离可以调
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
			FIND_CLOSEST,
			false
	)
	for _, tower in ipairs(towers) do
		if tower:IsAlive() and string.find(tower:GetUnitName(), "tower") then
			self:AttackTarget(tower)
			return
		end
	end

	local base = self:FindEnemyAncient(hero)
	if base then
		hero:MoveToPosition(base:GetAbsOrigin())
	end
	self.lastTarget = nil
end
function ai_normal:TryUseItemsOnEnemyInRange()
	local hero = self.parent
	if not hero or not hero:IsAlive() then return end

	-- 需要忽略自动释放的物品列表
	local skipList = {
		item_tpscroll = true,
		item_tango = true,
		item_bottle = true,
		item_faerie_fire = true,
		item_enchanted_mango = true,
		item_magic_wand = true,
		item_magic_stick = true,
		item_premium_power_treads = true,
		item_refresher = true,
	}

	for slot = 0, 5 do
		local item = hero:GetItemInSlot(slot)
		if item and item:IsItem() and item:IsCooldownReady() and item:IsFullyCastable() then
			local name = item:GetName()
			if skipList[name] then
				goto continue
			end

			local behavior = item:GetBehaviorInt()
			local castRange = item:GetCastRange(hero:GetAbsOrigin(), nil)
			if type(castRange) ~= "number" or castRange <= 0 then
				castRange = 600
			end

			local enemies = FindUnitsInRadius(
					hero:GetTeamNumber(),
					hero:GetAbsOrigin(),
					nil,
					castRange,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
					FIND_CLOSEST,
					false
			)

			local hasEnemy = #enemies > 0
			local target = enemies[1]

			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 and hasEnemy then
				hero:CastAbilityOnTarget(target, item, -1)
				print("[AI] 使用物品", name, "对单位", target:GetUnitName())
				return
			elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 and hasEnemy then
				hero:CastAbilityOnPosition(target:GetAbsOrigin(), item, -1)
				print("[AI] 使用物品", name, "对位置", tostring(target:GetAbsOrigin()))
				return
			elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 and hasEnemy then
				-- 有敌人在范围内才释放无目标物品
				hero:CastAbilityNoTarget(item, -1)
				print("[AI] 使用无目标物品", name)
				return
			end
		end
		::continue::
	end
end

function ai_normal:FindEnemyAncient(hero)
	local ancientNames = {
		["npc_dota_goodguys_fort"] = true,
		["npc_dota_badguys_fort"] = true,
	}

	local buildings = FindUnitsInRadius(
			hero:GetTeamNumber(),
			Vector(0, 0, 0),
			nil,
			FIND_UNITS_EVERYWHERE,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
			FIND_CLOSEST,
			false
	)

	for _, b in ipairs(buildings) do
		if b:IsAlive() and ancientNames[b:GetUnitName()] then
			return b
		end
	end
	return nil
end

function GetHeroType(hero)
	if not hero or not IsValidEntity(hero) then return "unknown", "melee" end

	local primaryAttr = hero:GetPrimaryAttribute()
	local attrType = "unknown"

	if primaryAttr == DOTA_ATTRIBUTE_STRENGTH then
		attrType = "str"
	elseif primaryAttr == DOTA_ATTRIBUTE_AGILITY then
		attrType = "agi"
	elseif primaryAttr == DOTA_ATTRIBUTE_INTELLECT then
		attrType = "int"
	end

	local attackType = hero:IsRangedAttacker() and "ranged" or "melee"
	return attrType, attackType
end

local RecommendedItems = {
	str = {
		melee = {"item_imba_blink_boots","item_bkb","item_imba_aegis_heart","item_imba_blade_mail","item_imba_orb","item_imba_greatwyrm_plate"},
		ranged = {"item_imba_blink_boots","item_bkb","item_imba_aegis_heart","item_imba_blade_mail","item_imba_orb","item_imba_greatwyrm_plate"},
	},
	agi = {
		melee = {"item_premium_power_treads","item_imba_harpoon","item_imba_thirst","item_butterfly_ex","item_greater_crit2","item_battle_fury"},
		ranged = {"item_premium_power_treads","item_imba_harpoon","item_imba_thirst","item_butterfly_ex","item_greater_crit2","item_battle_fury"},
	},
	int = {
		melee = {"item_premium_power_treads","item_imba_gungnir","item_bkb","item_imba_thirst","item_greater_crit2","item_skadi_v2"},
		ranged = {"item_premium_power_treads","item_imba_gungnir","item_bkb","item_imba_thirst","item_greater_crit2","item_skadi_v2"},
	}
}
-- AI 购买物品逻辑
function ai_normal:TryBuyItems()
	local hero = self.parent
	if not IsValidEntity(hero) or not hero:IsAlive() then return end

	local attrType, attackType = GetHeroType(hero)
	if not attrType or not attackType or attrType == "unknown" then
		print("[AI] 无法识别英雄主属性或攻击类型", hero:GetName())
		attrType = 'str'
		attackType = 'melee'
	end

	local itemGroup = RecommendedItems[attrType]
	if not itemGroup then
		print("[AI] 未定义属性类型:", attrType)
		return
	end

	local itemList = itemGroup[attackType]
	if not itemList then
		print("[AI] 未定义攻击类型:", attackType, "属性类型:", attrType)
		return
	end

	local currentGold = hero:GetGold()

	for _, itemName in ipairs(itemList) do
		if itemName and itemName ~= "" and not self:HasItem(hero, itemName) then
			local cost = GetItemCost(itemName)
			if cost and currentGold >= cost then
				print("[AI] 购买物品:", itemName)
				local item = CreateItem(itemName, hero, hero)
				if item then
					hero:AddItem(item)
					hero:SpendGold(cost, DOTA_ModifyGold_PurchaseItem)
				end
				return -- 每次只买一个
			end
		end
	end
end

function ai_normal:HasItem(hero, itemName)
	for i = 0, 8 do  -- 主物品栏和背包共 9 个格子
		local item = hero:GetItemInSlot(i)
		if item and item:GetName() == itemName then
			return true
		end
	end
	return false
end
function ai_normal:TryLevelUpAbilities()
	local hero = self.parent
	local level = hero:GetLevel()

	for i = 0, 15 do
		local ability = hero:GetAbilityByIndex(i)
		if ability then
			local abilityLevel = ability:GetLevel()
			-- 升级到当前英雄等级，但不超过技能最大等级
			if abilityLevel < ability:GetMaxLevel() and abilityLevel < level then
				hero:UpgradeAbility(ability)
				print("升级技能:", ability:GetName(), "到等级", abilityLevel + 1)
				-- 只升级一个技能，避免同时升级多个技能（可以根据策略改）
				return
			end
		end
	end
end

-- 新增：尝试释放技能
function ai_normal:TryUseAbilities()
	local hero = self.parent
	if hero:IsStunned() or hero:IsSilenced() then return end

	for i = 0, 15 do
		local ability = hero:GetAbilityByIndex(i)
		if ability and ability:IsCooldownReady() and ability:IsFullyCastable() then
			local behavior = ability:GetBehaviorInt()
			local castRange = ability:GetCastRange(hero:GetAbsOrigin(), nil)
			if type(castRange) ~= "number" or castRange <= 0 then
				castRange = 600
			end
			if ability:GetManaCost(ability:GetLevel()) > hero:GetMana() then
				goto continue
			end

			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 then
				-- 找敌人目标施法
				local enemies = FindUnitsInRadius(
						hero:GetTeamNumber(),
						hero:GetAbsOrigin(),
						nil,
						castRange,
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
						FIND_CLOSEST,
						false
				)
				if #enemies > 0 then
					local success = hero:CastAbilityOnTarget(enemies[1], ability, -1)
					if not success then
						-- 如果失败，尝试对自己施法
						hero:CastAbilityOnTarget(hero, ability, -1)
					end
					return
				end

			elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 then
				local enemies = FindUnitsInRadius(
						hero:GetTeamNumber(),
						hero:GetAbsOrigin(),
						nil,
						castRange,
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
						FIND_CLOSEST,
						false
				)
				if #enemies > 0 then
					local pos = enemies[1]:GetAbsOrigin()
					local success = hero:CastAbilityOnPosition(pos, ability, -1)
					if not success then
						-- 如果失败，尝试对自己施法（无目标）
						if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 then
							hero:CastAbilityNoTarget(ability, -1)
						end
					end
					return
				end

			elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 then
				hero:CastAbilityNoTarget(ability, -1)
				return
			end
		end
		::continue::
	end
end



function ai_normal:AttackTarget(target)
	local now = GameRules:GetGameTime()
	if not target or not target:IsAlive() then
		self.lastTarget = nil
		return
	end
	if self.lastTarget ~= target or (self.lastCommandTime == nil) or (now - self.lastCommandTime > 0.5) then
		self.parent:MoveToTargetToAttack(target)
		--print(self.parent:GetName(), "开始攻击目标", target:GetName())
		self.lastTarget = target
		self.lastCommandTime = now
	end
end


function ai_normal:FindClosestEnemyTower(unit)
	local towers = FindUnitsInRadius(
			unit:GetTeamNumber(),
			unit:GetAbsOrigin(),
			nil,
			3000,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
			FIND_CLOSEST,
			false
	)

	for _, tower in ipairs(towers) do
		if tower:IsAlive() and string.find(tower:GetUnitName(), "tower") then
			return tower
		end
	end
	return nil
end

function ai_normal:IsTargetedByEnemyTower()
	local hero = self.parent
	local towers = FindUnitsInRadius(
			hero:GetTeamNumber(),
			hero:GetAbsOrigin(),
			nil,
			1200,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
			FIND_ANY_ORDER,
			false
	)
	for _, tower in pairs(towers) do
		-- 如果塔的攻击目标是自己，则说明被塔仇恨
		if tower:GetAttackTarget() == hero then
			return true
		end
	end
	return false
end
