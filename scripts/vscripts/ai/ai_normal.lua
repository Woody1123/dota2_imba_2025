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
	self.lastTarget = nil
	self.beingTargetedByTower = false
	self.castUntil = 0

	-- 缓存古代建筑、塔和兵营
	self:CacheEnemyBuildings()

	-- 缓存英雄属性类型，避免重复计算
	self.attrType, self.attackType = GetHeroType(self.parent)

	-- 控制查询间隔计时器
	self.nextUnitSearchTime = 0
	self.unitSearchInterval = 1.5  -- 单位查询间隔（秒）

	-- 购买频率控制
	self.lastBuyTime = 0
	self.buyInterval = 60 -- 每60秒尝试买一次

	-- 分帧计数，用于交替执行技能和物品使用
	self.frameCount = 0

	-- 技能升级缓存，避免重复升级
	self.abilityLevels = {}

	self:StartIntervalThink(0.5)

	-- 每 10 秒尝试自动开启 toggle 技能
	Timers:CreateTimer(0, function()
		if self and self.TryEnableToggleAbilities and self.parent:IsAlive() then
			self:TryEnableToggleAbilities()
		end
		return 10
	end)
end
function ai_normal:OnIntervalThink()
	if not IsServer() then return end

	local hero = self.parent
	if not hero or not hero:IsAlive() then
		if self.debug then print("[AI] Hero dead or nil, skipping AI") end
		return
	end

	local now = GameRules:GetGameTime()
	local playerID = hero:GetPlayerOwnerID()

	-- 玩家控制跳过 AI
	if PlayerResource:IsValidPlayerID(playerID) and not PlayerResource:IsFakeClient(playerID) then
		if self.debug then print("[AI] Hero controlled by player, skipping AI") end
		return
	end

	-- 技能锁定：前摇/通道技能
	local castAbility = hero:GetCurrentActiveAbility()
	if castAbility then
		if hero:IsChanneling() or hero:IsCastingAbility() then
			local castPoint = castAbility:GetCastPoint() or 0
			self.castUntil = now + castPoint + 0.2  -- buffer 避免被打断
			if self.debug then
				print(string.format("[AI] Locking AI for '%s', cast point %.2f, until %.2f",
						castAbility:GetAbilityName(), castPoint, self.castUntil))
			end
			return
		end
	end

	-- 技能释放锁定时间
	if self.castUntil and now < self.castUntil then
		if self.debug then
			print(string.format("[AI] Skill lock active until %.2f, skipping", self.castUntil))
		end
		return
	end

	-- 每 buyInterval 秒尝试购买一次
	self.lastBuyTime = self.lastBuyTime or 0
	if now - self.lastBuyTime >= (self.buyInterval or 10) then
		if self.debug then print("[AI] Trying to buy items") end
		self:TryBuyItems()
		self.lastBuyTime = now
	end

	-- 自动升级技能
	self.abilitiesLeveled = self.abilitiesLeveled or false
	if not self.abilitiesLeveled then
		if self.debug then print("[AI] Trying to level up abilities") end
		self:TryLevelUpAbilities()
		self.abilitiesLeveled = true
	end

	-- 分帧执行：技能和物品交替
	self.frameCount = (self.frameCount or 0) + 1
	if self.frameCount % 2 == 0 then
		if self.debug then print("[AI] Frame using abilities") end
		self:TryUseAbilities()
	else
		if self.debug then print("[AI] Frame using items") end
		self:TryUseItemsOnEnemyInRange()
	end

	-- 单位搜索和攻击逻辑
	self.nextUnitSearchTime = self.nextUnitSearchTime or 0
	if now >= self.nextUnitSearchTime then
		self.nextUnitSearchTime = now + (self.unitSearchInterval or 0.5)
		if self.debug then print("[AI] Searching and attacking units") end
		self:SearchAndAttack()
	end
end

-- 可在 hero 重生或初始化 AI 时重置状态
function ai_normal:ResetAI()
	self.lastBuyTime = 0
	self.nextUnitSearchTime = 0
	self.frameCount = 0
	self.castUntil = 0
	self.abilitiesLeveled = false
end


-- 缓存敌方古代建筑、塔和兵营
function ai_normal:CacheEnemyBuildings()
	local hero = self.parent
	local team = hero:GetTeamNumber()

	-- 缓存古代建筑
	local ancientNames = {
		["npc_dota_goodguys_fort"] = true,
		["npc_dota_badguys_fort"] = true,
	}
	self.cachedAncient = nil

	local buildings = FindUnitsInRadius(team, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _, b in ipairs(buildings) do
		if b and b:IsAlive() and ancientNames[b:GetUnitName()] then
			self.cachedAncient = b
			break
		end
	end

	-- 缓存敌方塔
	self.cachedEnemyTowers = {}
	-- 缓存敌方兵营
	self.cachedEnemyBarracks = {}
	for _, b in ipairs(buildings) do
		if b and b:IsAlive() then
			local name = b:GetUnitName()
			if string.find(name, "tower") then
				table.insert(self.cachedEnemyTowers, b)
			elseif string.find(name, "barracks") then
				table.insert(self.cachedEnemyBarracks, b)
			end
		end
	end
end

-- 查找并攻击逻辑
function ai_normal:SearchAndAttack()
	local hero = self.parent
	if not hero or not hero:IsAlive() then return end

	-- 查找附近敌方英雄
	local enemyHeroes = FindUnitsInRadius(
			hero:GetTeamNumber(),
			hero:GetAbsOrigin(),
			nil,
			1000,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false
	)
	if enemyHeroes and #enemyHeroes > 0 then
		self:AttackTarget(enemyHeroes[1])
		return
	end

	-- 查找附近敌方小兵
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
	if enemyCreeps and #enemyCreeps > 0 then
		self:AttackTarget(enemyCreeps[1])
		return
	end

	-- 攻击附近敌方塔（安全版）
	if self.cachedEnemyTowers then
		local validTowers = {}
		for _, tower in ipairs(self.cachedEnemyTowers) do
			if tower and IsValidEntity(tower) and tower:IsAlive() then
				table.insert(validTowers, tower)
			end
		end
		self.cachedEnemyTowers = validTowers  -- 更新缓存，只保留存活单位

		for _, tower in ipairs(self.cachedEnemyTowers) do
			if (hero:GetAbsOrigin() - tower:GetAbsOrigin()):Length2D() <= 1200 then
				self:AttackTarget(tower)
				return
			end
		end
	end

	-- 攻击附近敌方兵营（安全版）
	if self.cachedEnemyBarracks then
		local validBarracks = {}
		for _, barracks in ipairs(self.cachedEnemyBarracks) do
			if barracks and IsValidEntity(barracks) and barracks:IsAlive() then
				table.insert(validBarracks, barracks)
			end
		end
		self.cachedEnemyBarracks = validBarracks  -- 更新缓存，只保留存活单位

		for _, barracks in ipairs(self.cachedEnemyBarracks) do
			if (hero:GetAbsOrigin() - barracks:GetAbsOrigin()):Length2D() <= 1200 then
				self:AttackTarget(barracks)
				return
			end
		end
	end

	-- 移动到敌方古代建筑
	if self.cachedAncient and self.cachedAncient:IsAlive() then
		hero:MoveToPosition(self.cachedAncient:GetAbsOrigin())
		return
	end

	self.lastTarget = nil
end

-- 攻击目标
function ai_normal:AttackTarget(target)
	local now = GameRules:GetGameTime()
	if not target or not target:IsAlive() then
		self.lastTarget = nil
		return
	end
	if self.lastTarget ~= target or (self.lastCommandTime == nil) or (now - self.lastCommandTime > 0.5) then
		self.parent:MoveToTargetToAttack(target)
		self.lastTarget = target
		self.lastCommandTime = now
	end
end

-- 自动升级技能
function ai_normal:TryLevelUpAbilities()
	local hero = self.parent
	local level = hero:GetLevel()
	local abilityPoints = hero:GetAbilityPoints()

	if abilityPoints <= 0 then return end

	for i = 0, 15 do
		local ability = hero:GetAbilityByIndex(i)
		if ability then
			local abilityName = ability:GetName()
			local abilityLevel = ability:GetLevel()
			local maxLevel = ability:GetMaxLevel()

			if abilityLevel < maxLevel and abilityLevel < level then
				local nextLevel = abilityLevel + 1
				if not self.abilityLevels[abilityName] or self.abilityLevels[abilityName] < nextLevel then
					local success = hero:UpgradeAbility(ability)
					if success then
						self.abilityLevels[abilityName] = nextLevel
						print("[AI] 升级技能:", abilityName, "到等级", nextLevel)
						return
					end
				end
			end
		end
	end
end

-- 尝试使用技能
function ai_normal:TryUseAbilities()
	local hero = self.parent
	if not hero or not hero:IsAlive() or hero:IsStunned() or hero:IsSilenced() then return end

	local searchRange = 1000
	local enemies = FindUnitsInRadius(
			hero:GetTeamNumber(),
			hero:GetAbsOrigin(),
			nil,
			searchRange,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false
	)
	if #enemies == 0 then return end
	local target = enemies[1]
	local targetPos = target:GetAbsOrigin()

	for i = 0, 15 do
		local ability = hero:GetAbilityByIndex(i)
		if ability and ability:GetLevel() > 0 and ability:IsCooldownReady() and ability:IsFullyCastable() then
			local behavior = ability:GetBehaviorInt()
			local castRange = ability:GetCastRange(hero:GetAbsOrigin(), nil)
			if not castRange or castRange <= 0 then castRange = 600 end

			if ability:GetManaCost(ability:GetLevel()) > hero:GetMana() then goto continue end

			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_PASSIVE) ~= 0 then goto continue end

			local isNoMana = ability:GetManaCost(ability:GetLevel()) == 0
			local isShortCD = ability:GetCooldown(ability:GetLevel()) <= 3
			if isNoMana and isShortCD then goto continue end

			local castPoint = ability:GetCastPoint() or 0
			local buffer = 0.05

			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_TOGGLE) ~= 0 then
				if not ability:GetToggleState() then
					hero:CastAbilityToggle(ability, -1)
					print("[AI] 激活切换技能:", ability:GetAbilityName())
				end
				goto continue
			end

			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 then
				if (hero:GetAbsOrigin() - targetPos):Length2D() <= castRange then
					local success = hero:CastAbilityOnTarget(target, ability, -1)
					if success then
						self.castUntil = GameRules:GetGameTime() + castPoint + buffer
						print("[AI] 释放单位目标技能:", ability:GetName())
						return
					end
				end
			end

			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 then
				local success = hero:CastAbilityOnPosition(targetPos, ability, -1)
				if success then
					self.castUntil = GameRules:GetGameTime() + castPoint + buffer
					print("[AI] 释放点目标技能:", ability:GetName())
					return
				end
			end

			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 then
				local success = hero:CastAbilityNoTarget(ability, -1)
				if success then
					self.castUntil = GameRules:GetGameTime() + castPoint + buffer
					print("[AI] 释放无目标技能:", ability:GetName())
					return
				end
			end
		end

		::continue::
	end
end

-- 尝试使用物品
function ai_normal:TryUseItemsOnEnemyInRange()
	local hero = self.parent
	if not hero or not hero:IsAlive() then return end

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

	local maxCastRange = 0
	local usableItems = {}

	for slot = 0, 5 do
		local item = hero:GetItemInSlot(slot)
		if item and item:IsItem() and item:IsCooldownReady() and item:IsFullyCastable() then
			local name = item:GetName()
			if not skipList[name] then
				local castRange = item:GetCastRange(hero:GetAbsOrigin(), nil)
				if type(castRange) ~= "number" or castRange <= 0 then
					castRange = 600
				end

				if castRange > maxCastRange then
					maxCastRange = castRange
				end

				table.insert(usableItems, item)
			end
		end
	end

	if maxCastRange <= 0 or #usableItems == 0 then return end

	local enemies = FindUnitsInRadius(
			hero:GetTeamNumber(),
			hero:GetAbsOrigin(),
			nil,
			maxCastRange,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false
	)

	if #enemies == 0 then return end

	for _, item in ipairs(usableItems) do
		local name = item:GetName()
		local target = enemies[1]

		if item:IsCooldownReady() and item:IsFullyCastable() then
			local behavior = item:GetBehaviorInt()

			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 then
				local success = hero:CastAbilityOnTarget(target, item, -1)
				if not success then
					success = hero:CastAbilityOnTarget(hero, item, -1)
					if success then
						print("[AI] 物品", name, "对敌方释放失败，改为对自己释放")
					end
				else
					print("[AI] 使用物品", name, "对单位", target:GetUnitName())
				end
				if success then return end

			elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 then
				local success = hero:CastAbilityOnPosition(target:GetAbsOrigin(), item, -1)
				if not success then
					local pos = hero:GetAbsOrigin()
					success = hero:CastAbilityOnPosition(pos, item, -1)
					if success then
						print("[AI] 物品", name, "对敌方释放失败，改为对自己位置释放")
					end
				else
					print("[AI] 使用物品", name, "对位置", tostring(target:GetAbsOrigin()))
				end
				if success then return end

			elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 then
				hero:CastAbilityNoTarget(item, -1)
				local castPoint = item:GetCastPoint() or 0
				local buffer = 0.05
				self.castUntil = GameRules:GetGameTime() + castPoint + buffer
				return
			end
		end
	end
end

-- AI 购买物品逻辑
local RecommendedItems = {
	str = {
		melee = {"item_imba_blink_boots","item_bkb","item_imba_aegis_heart","item_imba_blade_mail","item_imba_orb","item_imba_greatwyrm_plate"},
		ranged = {"item_imba_blink_boots","item_bkb","item_imba_aegis_heart","item_imba_blade_mail","item_imba_orb","item_imba_greatwyrm_plate"},
	},
	agi = {
		melee = {"item_premium_power_treads","item_imba_harpoon","item_imba_thirst","item_butterfly_ex","item_greater_crit2","item_battle_fury"},
		ranged = {"item_premium_power_treads","item_bkb","item_imba_thirst","item_butterfly_ex","item_greater_crit2","item_battle_fury"},
	},
	int = {
		melee = {"item_premium_power_treads","item_imba_gungnir","item_bkb","item_imba_thirst","item_greater_crit2","item_skadi_v2"},
		ranged = {"item_premium_power_treads","item_imba_gungnir","item_bkb","item_sheepstick_v2","item_greater_crit2","item_skadi_v2"},
	}
}

function ai_normal:TryBuyItems()
	local hero = self.parent
	if not IsValidEntity(hero) or not hero:IsAlive() then return end

	local attrType, attackType = self.attrType, self.attackType
	if not attrType or not attackType or attrType == "unknown" then
		attrType = 'str'
	end

	local itemGroup = RecommendedItems[attrType]
	if not itemGroup then return end

	local itemList = itemGroup[attackType]
	if not itemList then return end

	local currentGold = hero:GetGold()

	for _, itemName in ipairs(itemList) do
		if itemName and itemName ~= "" and not self:HasItem(hero, itemName) then
			local cost = GetItemCost(itemName)
			if cost and currentGold >= cost then
				local item = CreateItem(itemName, hero, hero)
				if item then
					hero:AddItem(item)
					hero:SpendGold(cost, DOTA_ModifyGold_PurchaseItem)
					print("[AI] 购买物品:", itemName)
				end
				return
			end
		end
	end
end

function ai_normal:HasItem(hero, itemName)
	for i = 0, 8 do
		local item = hero:GetItemInSlot(i)
		if item and item:GetName() == itemName then
			return true
		end
	end
	return false
end

-- 自动开启切换技能
function ai_normal:TryEnableToggleAbilities()
	local hero = self.parent
	if not hero or not hero:IsAlive() then return end

	for i = 0, 15 do
		local ability = hero:GetAbilityByIndex(i)
		if ability and ability:GetLevel() > 0 then
			local behavior = ability:GetBehaviorInt()
			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_TOGGLE) ~= 0 then
				if not ability:GetToggleState() and ability:IsCooldownReady() and ability:IsFullyCastable() then
					hero:CastAbilityToggle(ability, -1)
					print("[AI] 自动开启切换技能:", ability:GetName())
				end
			end
		end
	end
end

-- 计算英雄主属性及攻击类型
function GetHeroType(hero)
	if not hero or not IsValidEntity(hero) then
		return "str", "melee"
	end

	local primaryAttr = hero:GetPrimaryAttribute()
	local attrType = "str"

	if primaryAttr == DOTA_ATTRIBUTE_STRENGTH then
		attrType = "str"
	elseif primaryAttr == DOTA_ATTRIBUTE_AGILITY then
		attrType = "agi"
	elseif primaryAttr == DOTA_ATTRIBUTE_INTELLECT then
		attrType = "int"
	elseif primaryAttr == DOTA_ATTRIBUTE_ALL then
		local strGain = hero:GetStrengthGain()
		local agiGain = hero:GetAgilityGain()
		local intGain = hero:GetIntellectGain()

		if strGain >= agiGain and strGain >= intGain then
			attrType = "str"
		elseif agiGain >= strGain and agiGain >= intGain then
			attrType = "agi"
		else
			attrType = "int"
		end
	end

	local attackType = hero:IsRangedAttacker() and "ranged" or "melee"
	return attrType, attackType
end
