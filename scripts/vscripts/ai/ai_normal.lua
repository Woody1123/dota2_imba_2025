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
	Timers:CreateTimer(0, function()
		if ai_normal and ai_normal.TryEnableToggleAbilities then
			ai_normal:TryEnableToggleAbilities()
		end
		return 60  -- 每 60 秒检查一次
	end)
end

function ai_normal:OnIntervalThink()
	if not IsServer() then return end

	local hero = self.parent
	if self.castUntil and GameRules:GetGameTime() < self.castUntil then
		print("[AI] 技能释放前摇中，跳过操作")
		return
	end
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

	-- 每 60 秒尝试一次购买
	local now = GameRules:GetGameTime()
	self.lastBuyTime = self.lastBuyTime or 0
	if now - self.lastBuyTime >= 60 then
		self:TryBuyItems()
		self.lastBuyTime = now
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
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
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

	-- 找最大施法范围和所有可用物品
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

	if maxCastRange <= 0 or #usableItems == 0 then
		return
	end

	-- 找最大施法范围内敌人
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
	if #enemies == 0 then
		-- 无敌人，直接返回
		return
	end

	for _, item in ipairs(usableItems) do
		local behavior = item:GetBehaviorInt()
		local name = item:GetName()
		local target = enemies[1]

		if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 then
			local success = hero:CastAbilityOnTarget(target, item, -1)
			if not success then
				-- 释放失败，尝试对自己释放（如果对自己释放有效）
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
				-- 对自己身上释放（点目标物品一般不能对自己施法，但部分物品允许）
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
			-- 无目标物品只对敌人释放
			hero:CastAbilityNoTarget(item, -1)
			print("[AI] 使用无目标物品", name)
			local castPoint = item:GetCastPoint() or 0
			local buffer = 0.05
			self.castUntil = GameRules:GetGameTime() + castPoint + buffer
			return
		end
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
	if not hero or not IsValidEntity(hero) then
		return "unknown", "melee"
	end

	local primaryAttr = hero:GetPrimaryAttribute()
	local attrType = "unknown"

	if primaryAttr == DOTA_ATTRIBUTE_STRENGTH then
		attrType = "str"
	elseif primaryAttr == DOTA_ATTRIBUTE_AGILITY then
		attrType = "agi"
	elseif primaryAttr == DOTA_ATTRIBUTE_INTELLECT then
		attrType = "int"
	elseif primaryAttr == DOTA_ATTRIBUTE_ALL then
		-- 使用成长属性判断主属性倾向
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
		ranged = {"item_premium_power_treads","item_imba_gungnir","item_bkb","item_sheepstick_v2","item_greater_crit2","item_skadi_v2"},
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
	local abilityPoints = hero:GetAbilityPoints()

	if abilityPoints <= 0 then
		return
	end

	if not self.abilityLevels then
		self.abilityLevels = {}
	end

	for i = 0, 15 do
		local ability = hero:GetAbilityByIndex(i)
		if ability then
			local abilityName = ability:GetName()
			local abilityLevel = ability:GetLevel()
			local maxLevel = ability:GetMaxLevel()

			if abilityLevel < maxLevel and abilityLevel < level then
				local nextLevel = abilityLevel + 1
				-- 只在缓存没有记录，或缓存值 < 即将升级的等级 时进行升级
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



function ai_normal:TryUseAbilities()
	local hero = self.parent
	if not hero or not hero:IsAlive() or hero:IsStunned() or hero:IsSilenced() then
		return
	end

	-- 搜索范围内敌人
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

			-- 跳过不够蓝的技能
			if ability:GetManaCost(ability:GetLevel()) > hero:GetMana() then goto continue end

			-- 跳过被动技能
			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_PASSIVE) ~= 0 then goto continue end

			-- 检查是否属于“CD短 + 不耗蓝”的技能（只在重生触发一次）
			local isNoMana = ability:GetManaCost(ability:GetLevel()) == 0
			local isShortCD = ability:GetCooldown(ability:GetLevel()) <= 3
			if isNoMana and isShortCD then
				if self.castOnRespawnDone then
					goto continue
				else
					self.castOnRespawnDone = true
				end
			end

			local castPoint = ability:GetCastPoint() or 0
			local buffer = 0.05

			-- 切换技能尝试开启
			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_TOGGLE) ~= 0 then
				if not ability:GetToggleState() then
					hero:CastAbilityToggle(ability, -1)
					print("[AI] 激活切换技能:", ability:GetName())
				end
				goto continue
			end

			-- 单位目标技能
			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 then
				if (hero:GetAbsOrigin() - targetPos):Length2D() <= castRange then
					local success = hero:CastAbilityOnTarget(target, ability, -1)
					if success then
						self.castUntil = GameRules:GetGameTime() + castPoint + buffer
					end
					return
				end
			end

			-- 点目标技能
			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 then
				local success = hero:CastAbilityOnPosition(targetPos, ability, -1)
				if success then
					self.castUntil = GameRules:GetGameTime() + castPoint + buffer
				end
				return
			end

			-- 无目标技能
			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 then
				local success = hero:CastAbilityNoTarget(ability, -1)
				if success then
					self.castUntil = GameRules:GetGameTime() + castPoint + buffer
				end
				return
			end
		end
		::continue::
	end
end


function ai_normal:TryEnableToggleAbilities()
	local hero = self.parent
	if not hero or not hero:IsAlive() then return end

	for i = 0, 5 do
		local ability = hero:GetAbilityByIndex(i)
		if ability
				and ability:IsToggle()
				and not ability:GetToggleState()
				and ability:IsFullyCastable()
				and ability:IsActivated()
				and ability:GetLevel() > 0 then

			print("[AI] 自动开启 toggle 技能:", ability:GetAbilityName())
			ability:ToggleAbility()
		end
	end
end

Timers:CreateTimer(0, function()
	if ai_normal and ai_normal.TryEnableToggleAbilities then
		ai_normal:TryEnableToggleAbilities()
	end
	return 60  -- 每 60 秒检查一次
end)



function ai_normal:OnRespawn()
	self.castOnRespawnDone = false
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
