
CreateTalents("npc_dota_hero_chaos_knight", "hero/hero_chaos_knight.lua")
imba_chaos_knight_chaos_bolt = class({})

LinkLuaModifier("modifier_imba_chaos_bolt_confuse_thinker", "hero/hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)

function imba_chaos_knight_chaos_bolt:IsHiddenWhenStolen() 		return false end
function imba_chaos_knight_chaos_bolt:IsRefreshable() 			return true end
function imba_chaos_knight_chaos_bolt:IsStealable() 			return true end


function imba_chaos_knight_chaos_bolt:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local pfx_name = "particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt.vpcf"
	caster:EmitSound("Hero_ChaosKnight.ChaosBolt.Cast")
	local info =
	{
		Target = target,
		Source = caster,
		Ability = self,
		EffectName = pfx_name,
		iMoveSpeed = self:GetSpecialValueFor("chaos_bolt_speed"),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
		ExtraData = {},
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function imba_chaos_knight_chaos_bolt:OnProjectileHit_ExtraData(target, pos, keys)
	if not target or target:TG_TriggerSpellAbsorb(self) or target:IsMagicImmune() then
		return
	end

	local caster = self:GetCaster()
	target:EmitSound("Hero_ChaosKnight.ChaosBolt.Impact")

	-- 计算伤害，按 min-max 随机取值
	local damage_min = self:GetSpecialValueFor("damage_min")
	local damage_max = self:GetSpecialValueFor("damage_max")
	local dmg = damage_min + (damage_max - damage_min) * (RandomInt(0, 100) / 100)
	dmg = math.floor(dmg + 0.5)

	-- 计算晕眩时间，按 min-max 随机取值
	local stun_min = self:GetSpecialValueFor("stun_min")
	local stun_max = self:GetSpecialValueFor("stun_max")
	local stun = stun_min + (stun_max - stun_min) * (RandomInt(0, 100) / 100)
	local stun_pfx = math.floor(stun + 0.5)

	-- 创建显示伤害与晕眩时间的粒子特效
	local pfx = ParticleManager:SafeCreateParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_bolt_msg.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControl(pfx, 3, Vector(0, stun_pfx, 4))
	ParticleManager:SetParticleControl(pfx, 4, Vector(stun, #tostring(stun_pfx) + 1, 0))
	ParticleManager:SetParticleControl(pfx, 1, Vector(0, dmg, 4))
	ParticleManager:SetParticleControl(pfx, 2, Vector(stun, #tostring(dmg) + 1, 0))
	ParticleManager:ReleaseParticleIndex(pfx)

	-- 造成伤害
	ApplyDamage({
		attacker = caster,
		victim = target,
		damage = dmg,
		ability = self,
		damage_type = self:GetAbilityDamageType()
	})

	if target:IsAlive() then
		target:AddNewModifier_RS(caster, self, "modifier_imba_stunned", {duration = stun})

		-- 如果晕眩时间小于最大晕眩，且目标没有confuse thinker则添加
		if stun < stun_max and not target:HasModifier("modifier_imba_chaos_bolt_confuse_thinker") then
			target:AddNewModifier(caster, self, "modifier_imba_chaos_bolt_confuse_thinker", {duration = stun_max - stun})
		end
	end

	-- 搜索附近敌人用于弹射
	local bounce_range = self:GetCastRange(pos, target) + caster:GetCastRangeBonus()
	local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),
			pos,
			nil,
			bounce_range,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NO_INVIS,
			FIND_ANY_ORDER,
			false
	)

	if #enemies >= 1 then
		local bounce_chance = self:GetSpecialValueFor("bounce_chance") + caster:TG_GetTalentValue("special_bonus_imba_chaos_knight_1")
		if PseudoRandom:RollPseudoRandom(self, bounce_chance) then
			local new_target = nil
			-- 找第一个不是当前target的单位
			for _, enemy in ipairs(enemies) do
				if enemy ~= target then
					new_target = enemy
					break
				end
			end
			-- 如果没找到则继续弹射给当前target（一般不会）
			if not new_target then
				new_target = target
			end

			if new_target then
				local info = {
					Target = new_target,
					Source = target,
					Ability = self,
					EffectName = "particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt.vpcf",
					iMoveSpeed = self:GetSpecialValueFor("chaos_bolt_speed"),
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
					bDrawsOnMinimap = false,
					bDodgeable = true,
					bIsAttack = false,
					bVisibleToEnemies = true,
					bReplaceExisting = false,
					flExpireTime = GameRules:GetGameTime() + 10,
					bProvidesVision = false,
					ExtraData = {},
				}
				ProjectileManager:CreateTrackingProjectile(info)
			end
		end
	end
end

modifier_imba_chaos_bolt_confuse_thinker = class({})

function modifier_imba_chaos_bolt_confuse_thinker:IsDebuff()			return true end
function modifier_imba_chaos_bolt_confuse_thinker:IsHidden() 			return true end
function modifier_imba_chaos_bolt_confuse_thinker:IsPurgable() 			return true end
function modifier_imba_chaos_bolt_confuse_thinker:IsPurgeException() 	return true end

function modifier_imba_chaos_bolt_confuse_thinker:OnCreated()
	if self:GetAbility() == nil then return end
	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_chaos_bolt_confuse_thinker:OnIntervalThink()
	self:SetDuration(self:GetDuration(), true)
	if not self:GetParent():IsStunned() then
		self:Destroy()
	end
end

function modifier_imba_chaos_bolt_confuse_thinker:OnDestroy()
	if IsServer() and not self:GetParent():IsMagicImmune() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_confuse", {duration = self:GetDuration()})
	end
end

imba_chaos_knight_reality_rift = class({})

LinkLuaModifier("modifier_imba_reality_rift_debuff", "hero/hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaos_illusions", "hero/hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)


function imba_chaos_knight_reality_rift:IsHiddenWhenStolen() 	return false end
function imba_chaos_knight_reality_rift:IsRefreshable() 		return true end
function imba_chaos_knight_reality_rift:IsStealable() 			return true end
function imba_chaos_knight_reality_rift:GetCastRange() return 
self:GetCaster():Has_Aghanims_Shard() and self:GetSpecialValueFor("cast_range_shard") or self:GetSpecialValueFor("cast_range")  end
function imba_chaos_knight_reality_rift:CastFilterResultTarget(target)
	if not IsEnemy(target, self:GetCaster()) then
		return UF_FAIL_FRIENDLY
	end
	if not target:IsUnit() then
		return UF_FAIL_OTHER
	end
	if target:IsMagicImmune() and not self:GetCaster():TG_HasTalent("special_bonus_imba_chaos_knight_2") then
		return UF_FAIL_MAGIC_IMMUNE_ENEMY
	end
end

function imba_chaos_knight_reality_rift:OnAbilityPhaseStart()
	self.target = {}
	local caster = self:GetCaster()

	caster:EmitSound("Hero_ChaosKnight.RealityRift")
	caster:EmitSound("Hero_ChaosKnight.RealityRift.Cast")

	local target = self:GetCursorTarget()
	local distance = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()

	-- 计算随机距离比例，范围限制在 [min, 100]
	local random_dis_min = RandomInt(math.min(((math.max(distance, 1000) - 1000) / 10), 60), 100)
	print(random_dis_min)

	local distance_random = distance * random_dis_min / 100
	local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
	direction.z = 0  -- 忽略高度差

	self.direction = direction

	local pos = GetGroundPosition(caster:GetAbsOrigin() + direction * distance_random, nil)
	self.pos = pos

	self.target[1] = target

	-- 查找附近敌人，满足条件概率加入额外目标
	local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			self:GetCastRange(caster:GetAbsOrigin(), target) + caster:GetCastRangeBonus(),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NO_INVIS + (caster:TG_HasTalent("special_bonus_imba_chaos_knight_2") and DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES or 0),
			FIND_ANY_ORDER,
			false
	)

	for _, enemy in ipairs(enemies) do
		if enemy ~= target and PseudoRandom:RollPseudoRandom(self, self:GetSpecialValueFor("pull_chance")) then
			table.insert(self.target, enemy)
		end
	end

	local pfx_name = "particles/units/heroes/hero_chaos_knight/chaos_knight_reality_rift.vpcf"
	-- 可以在这里判断是否装备了特殊皮肤然后替换粒子

	-- 为所有目标创建特效和播放声音
	for _, tgt in ipairs(self.target) do
		tgt:EmitSound("Hero_ChaosKnight.RealityRift.Target")
		local pfx = ParticleManager:SafeCreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, tgt, PATTACH_POINT_FOLLOW, "attach_hitloc", tgt:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 2, pos)
		ParticleManager:SetParticleControlForward(pfx, 2, direction)
		ParticleManager:ReleaseParticleIndex(pfx)
	end

	return true
end

function imba_chaos_knight_reality_rift:OnSpellStart()
	local caster = self:GetCaster()
	local casters = {caster}
	local target = self.target[1]

	-- 如果目标触发魔法吸收，则技能中断
	if target:TG_TriggerSpellAbsorb(self) then
		return
	end

	-- 创建修改过伤害和经验的幻象
	local illusionModifier = {
		outgoing_damage = 0,
		incoming_damage = 100,
		bounty_base = 0,
		bounty_growth = 0,
		outgoing_damage_structure = 0,
		outgoing_damage_roshan = 0,
	}
	local illusions = CreateIllusions(caster, caster, illusionModifier, 1, 0, true, true)

	illusions[1]:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("duration")})
	illusions[1]:AddNewModifier(caster, self, "modifier_chaos_illusions", {duration = self:GetSpecialValueFor("duration")})

	Timers:CreateTimer(0.1, function()
		illusions[1]:MoveToTargetToAttack(target)
		return nil
	end)
	table.insert(casters, illusions[1])

	-- 找出所有玩家拥有的幻象加入列表
	local allUnits = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3000,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

	for _, unit in ipairs(allUnits) do
		if unit:GetPlayerOwnerID() == caster:GetPlayerOwnerID() and unit:IsIllusion() then
			table.insert(casters, unit)
		end
	end

	-- 将所有相关单位传送到指定位置并攻击目标
	for _, u in ipairs(casters) do
		FindClearSpaceForUnit(u, self.pos + self.direction * -64, false)
		u:MoveToTargetToAttack(target)
	end

	-- 传送目标到另一侧，朝向施法者，停止移动并添加Debuff
	FindClearSpaceForUnit(target, self.pos + self.direction * 64, false)
	target:Stop()
	target:MoveToNPC(caster)
	target:Stop()
	target:SetForwardVector((caster:GetAbsOrigin() - target:GetAbsOrigin()):Normalized())

	for i = 1, #self.target do
		if self.target[i] ~= target then
			FindClearSpaceForUnit(self.target[i], self.pos + self.direction * 64, false)
			self.target[i]:Stop()
			self.target[i]:MoveToNPC(caster)
			self.target[i]:Stop()
			self.target[i]:SetForwardVector((caster:GetAbsOrigin() - self.target[i]:GetAbsOrigin()):Normalized())
		end
		self.target[i]:AddNewModifier_RS(caster, self, "modifier_imba_reality_rift_debuff", {duration = self:GetSpecialValueFor("duration")})
	end
end

modifier_imba_reality_rift_debuff = class({})

function modifier_imba_reality_rift_debuff:IsDebuff()			return true end
function modifier_imba_reality_rift_debuff:IsHidden() 			return false end
function modifier_imba_reality_rift_debuff:IsPurgable() 		return true end
function modifier_imba_reality_rift_debuff:IsPurgeException() 	return true end
function modifier_imba_reality_rift_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_reality_rift_debuff:GetModifierPhysicalArmorBonus() return (0 - self:GetStackCount()) end
function modifier_imba_reality_rift_debuff:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("movement_slow")) end
function modifier_imba_reality_rift_debuff:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("attack_slow")) end

function modifier_imba_reality_rift_debuff:OnCreated()
		if self:GetAbility() == nil then return end
	local armor = self:GetAbility():GetSpecialValueFor("armor_min") + (self:GetAbility():GetSpecialValueFor("armor_max") - self:GetAbility():GetSpecialValueFor("armor_min")) * (RandomInt(0, 100) / 100)
	armor = math.floor(armor + 0.5)
	self:SetStackCount(armor)
end

function modifier_imba_reality_rift_debuff:OnRefresh() self:OnCreated() end

imba_chaos_knight_chaos_strike = class({})

LinkLuaModifier("modifier_imba_chaos_strike_passive", "hero/hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)

function imba_chaos_knight_chaos_strike:GetCooldown(i) return (self.BaseClass.GetCooldown(self, i) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_chaos_knight_3")) end
function imba_chaos_knight_chaos_strike:GetIntrinsicModifierName() return "modifier_imba_chaos_strike_passive" end

modifier_imba_chaos_strike_passive = class({})

function modifier_imba_chaos_strike_passive:IsDebuff()			return false end
function modifier_imba_chaos_strike_passive:IsHidden() 			return true end
function modifier_imba_chaos_strike_passive:IsPurgable() 		return false end
function modifier_imba_chaos_strike_passive:IsPurgeException() 	return false end
function modifier_imba_chaos_strike_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE, MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ATTACK_FAIL} end

function modifier_imba_chaos_strike_passive:OnCreated() self.crit = {} end
function modifier_imba_chaos_strike_passive:OnDestroy() self.crit = nil end

function modifier_imba_chaos_strike_passive:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() and keys.attacker == self:GetParent() and keys.target:IsUnit() and not self:GetParent():PassivesDisabled()  then
		if self:GetAbility():IsCooldownReady() or PseudoRandom:RollPseudoRandom(self:GetAbility(), self:GetAbility():GetSpecialValueFor("extra_chance")) then
			self.crit[keys.record] = true
			self:GetAbility():UseResources(true, false, true, true)
			self:GetParent():EmitSound("Hero_ChaosKnight.ChaosStrike")
			return (self:GetAbility():GetSpecialValueFor("crit_min") + (self:GetAbility():GetSpecialValueFor("crit_max") - self:GetAbility():GetSpecialValueFor("crit_min") * (RandomInt(0, 100) / 100)))
		end
	end
end

function modifier_imba_chaos_strike_passive:OnAttackFail(keys) self.crit[keys.record] = nil end

function modifier_imba_chaos_strike_passive:OnAttackLanded(keys)
	if IsServer() and keys.attacker == self:GetParent() and keys.target:IsUnit() and not self:GetParent():PassivesDisabled() and keys.target:IsAlive() then
		if self.crit[keys.record] then
			self:GetParent():Heal(keys.damage * (self:GetAbility():GetSpecialValueFor("lifesteal") / 100), self:GetAbility())
			local pfx = ParticleManager:SafeCreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex(pfx)
		end
		if self:GetParent():IsRealHero() and not keys.target:IsMagicImmune() and PseudoRandom:RollPseudoRandom(self:GetAbility(), self:GetAbility():GetSpecialValueFor("extra_chance")) then
			local modifier_list = {"modifier_confuse", "modifier_imba_stunned", "modifier_paralyzed", "modifier_disarmed", "modifier_silence", "modifier_rooted", "modifier_hexxed", "modifier_axe_berserkers_call"}
			local list = {}
			while #list < (self:GetAbility():GetSpecialValueFor("max_effects") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_chaos_knight_4")) do
				local new = RandomFromTable(modifier_list)
				if not IsInTable(new, list) then
					list[#list + 1] = new
				end
			end
			for i=1, #list do
				keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), list[i], {duration = self:GetAbility():GetSpecialValueFor("duration")})
			end
		end
		self.crit[keys.record] = nil
	end
end

imba_chaos_knight_phantasm = class({})

LinkLuaModifier("modifier_imba_phantasm_buff", "hero/hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantasm_cooldown", "hero/hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantasm_delay", "hero/hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)

function imba_chaos_knight_phantasm:IsHiddenWhenStolen() 	return false end
function imba_chaos_knight_phantasm:IsRefreshable() 		return true end
function imba_chaos_knight_phantasm:IsStealable() 			return true end
function imba_chaos_knight_phantasm:GetBehavior() return self:GetCaster():Has_Aghanims_Shard() and DOTA_ABILITY_BEHAVIOR_UNIT_TARGET or DOTA_ABILITY_BEHAVIOR_NO_TARGET end

function imba_chaos_knight_phantasm:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() or caster
	target:EmitSound("Hero_ChaosKnight.Phantasm")
	target:RemoveModifierByName("modifier_imba_phantasm_buff")
	target:RemoveModifierByName("modifier_imba_phantasm_cooldown")
	target:AddNewModifier(caster, self, "modifier_imba_phantasm_buff", {duration = self:GetSpecialValueFor("duration")})
end

modifier_imba_phantasm_buff = class({})

function modifier_imba_phantasm_buff:IsDebuff()			return false end
function modifier_imba_phantasm_buff:IsHidden() 		return false end
function modifier_imba_phantasm_buff:IsPurgable() 		return false end
function modifier_imba_phantasm_buff:IsPurgeException() return false end
function modifier_imba_phantasm_buff:AllowIllusionDuplicate() return false end
function modifier_imba_phantasm_buff:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_phantasm_buff:GetEffectName() return "particles/hero/chaos_knight/chaos_knight_phantasm.vpcf" end
function modifier_imba_phantasm_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_phantasm_buff:OnCreated()
		if self:GetAbility() == nil then return end
	self.ability=self:GetAbility()
	self.parent=self:GetParent()
    self.attack_count=self.ability:GetSpecialValueFor("attack_count")
    self.attack_cooldown=self.ability:GetSpecialValueFor("attack_cooldown")
	if IsServer() and self.parent:HasScepter() then
		self.attack_count=self.attack_count+1
		self.attack_cooldown=1
	end
end

function modifier_imba_phantasm_buff:OnAttackLanded(keys)
	if IsServer() and not self.parent.phantasm and keys.attacker == self.parent and keys.target:IsAlive() and not self.parent:HasModifier("modifier_imba_phantasm_cooldown") then
		for i=0,self.attack_count do
			self.parent:AddNewModifier(self:GetCaster(), self.ability, "modifier_imba_phantasm_delay", {duration = 0.3, target = keys.target:entindex()})
			local pfx = ParticleManager:SafeCreateParticle("particles/hero/chaos_knight/chaos_knight_phantasm_attack.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(pfx, 0, keys.target, PATTACH_ABSORIGIN_FOLLOW, nil, keys.target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 2, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx)
		end
		local cooldown = math.min((1 /self.parent:GetAttacksPerSecond(false)), self.attack_cooldown)
		self.parent:AddNewModifier(self:GetCaster(), self.ability, "modifier_imba_phantasm_cooldown", {duration =  self.attack_cooldown})
	end
end

modifier_imba_phantasm_cooldown = class({})

function modifier_imba_phantasm_cooldown:IsDebuff()			return false end
function modifier_imba_phantasm_cooldown:IsHidden() 		return true end
function modifier_imba_phantasm_cooldown:IsPurgable() 		return false end
function modifier_imba_phantasm_cooldown:IsPurgeException() return false end

modifier_imba_phantasm_delay = class({})

function modifier_imba_phantasm_delay:IsDebuff()			return false end
function modifier_imba_phantasm_delay:IsHidden() 			return true end
function modifier_imba_phantasm_delay:IsPurgable() 			return false end
function modifier_imba_phantasm_delay:IsPurgeException() 	return false end
function modifier_imba_phantasm_delay:RemoveOnDeath() 		return false end
function modifier_imba_phantasm_delay:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_phantasm_delay:OnCreated(keys)
		if self:GetAbility() == nil then return end
	if IsServer() then
		self:SetStackCount(keys.target)
	end
end

function modifier_imba_phantasm_delay:OnDestroy()
	if IsServer() then
		if EntIndexToHScript(self:GetStackCount()):IsAlive() then
			self:GetParent().phantasm = true
			self:GetParent():PerformAttack(EntIndexToHScript(self:GetStackCount()), false, true, true, true, false, false, false)
			self:GetParent().phantasm = nil
		end
	end
end

imba_chaos_knight_chaos= class({})
LinkLuaModifier("modifier_chaos_passive", "hero/hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaos_illusions", "hero/hero_chaos_knight.lua", LUA_MODIFIER_MOTION_NONE)
function imba_chaos_knight_chaos:IsHiddenWhenStolen() 	return false end
function imba_chaos_knight_chaos:IsRefreshable() 		return true end
function imba_chaos_knight_chaos:IsStealable() 			return true end
function imba_chaos_knight_chaos:GetIntrinsicModifierName() return "modifier_chaos_passive" end
function imba_chaos_knight_chaos:GetBehavior() return self:GetCaster():HasScepter() and DOTA_ABILITY_BEHAVIOR_NO_TARGET or DOTA_ABILITY_BEHAVIOR_PASSIVE end
function imba_chaos_knight_chaos:OnSpellStart()
	local caster = self:GetCaster()
	local dur = self:GetSpecialValueFor("ill_dur")
	local modifier=
            {
                outgoing_damage=0,
                incoming_damage=100,
                bounty_base=0,
                bounty_growth=0,
                outgoing_damage_structure=0,
                outgoing_damage_roshan=0,
            }
	local illusions=CreateIllusions(caster, caster, modifier, 1, 0, true, true)
	illusions[1]:AddNewModifier(caster, self, "modifier_kill", {duration=dur})
	illusions[1]:AddNewModifier(caster, self, "modifier_chaos_illusions", {duration=dur})
	--illusions[1]:AddNewModifier(caster, self, "modifier_unit_remove", {duration=dur})
end


modifier_chaos_passive = class({})
function modifier_chaos_passive:IsDebuff()			return false end
function modifier_chaos_passive:IsHidden() 			return false end
function modifier_chaos_passive:IsPurgable() 		return false end
function modifier_chaos_passive:IsPurgeException() 	return false end
function modifier_chaos_passive:DeclareFunctions() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,} end


function modifier_chaos_passive:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("att")
end

function modifier_chaos_passive:GetModifierIncomingDamageConstant(keys)	 
	return -(keys.damage*self:GetStackCount()*self:GetAbility():GetSpecialValueFor("re")*0.01) 
end

function modifier_chaos_passive:OnCreated()
	if IsServer() then
		self:OnIntervalThink()
		if not self:GetParent():IsIllusion() then
			self:StartIntervalThink(0.2)
		end
		--
	end
end
function modifier_chaos_passive:OnIntervalThink()
		if IsServer() then
			self.chaos = RandomInt(-25,100)
			self:SetStackCount(self.chaos)
			self:GetParent():CalculateStatBonus(true)
		end
end

modifier_chaos_illusions=class({})

function modifier_chaos_illusions:IsHidden() 		
    return true 
end

function modifier_chaos_illusions:IsPurgable() 		
    return false 
end

function modifier_chaos_illusions:IsPurgeException() 
    return false 
end

function modifier_chaos_illusions:IsIllusion() 
    return true 
end

function modifier_chaos_illusions:DeclareFunctions() 
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_IS_ILLUSION,
    } 
end

function modifier_chaos_illusions:GetIsIllusion() 
    return 1
end

function modifier_chaos_illusions:OnCreated() 
	if self:GetAbility() == nil then return end
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
	self.caster = self:GetCaster()
	if IsServer() then 
		local item = self:GetCaster():FindItemInInventory("item_bkb") 
		if item then
			self.caster:EmitSound("DOTA_Item.BlackKingBar.Activate")
			self.parent:AddNewModifier(self.caster,item,"modifier_item_bkb_buff",{duration = 7})
		end
	end
end
function modifier_chaos_illusions:OnAttackLanded(tg) 
    if not IsServer() then
		return
    end
	if tg.attacker == self.parent and tg.target:IsAlive() and self.caster:IsAlive() and not tg.target:IsBuilding() then
		self.caster:PerformAttack(tg.target, true, true, true, false, false, false, true)	
	end
end