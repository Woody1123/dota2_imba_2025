-- 02 27 by MysticBug-------
----------------------------
----------------------------
CreateTalents("npc_dota_hero_brewmaster", "mb/hero_brewmaster/brewmaster_thunder_clap")


imba_brewmaster_thunder_clap = class({})

LinkLuaModifier("modifier_imba_brewmaster_thunder_clap_motion","mb/hero_brewmaster/brewmaster_thunder_clap.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_thunder_clap_debuff","mb/hero_brewmaster/brewmaster_thunder_clap.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_thunder_clap_buff","mb/hero_brewmaster/brewmaster_thunder_clap.lua", LUA_MODIFIER_MOTION_NONE)

function imba_brewmaster_thunder_clap:IsHiddenWhenStolen()  return false end
function imba_brewmaster_thunder_clap:IsRefreshable()		return true end
function imba_brewmaster_thunder_clap:IsStealable() 	return true end
function imba_brewmaster_thunder_clap:GetCastRange(location, target)
	if self.BaseClass.GetCastRange(self, location, target)==0 then
		return 0
	end
	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_brewmaster_1")
end
--imba 曼吉克斯向前跳跃一段距离，然后再猛击地面 
function imba_brewmaster_thunder_clap:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	local ability = self
	local motion_movement = "modifier_imba_brewmaster_thunder_clap_motion"
	local jump_particle = "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf"

	--跳跃高度设置
	local jump_speed = ability:GetSpecialValueFor("jump_speed")
	local jump_horizontal_distance = ability:GetSpecialValueFor("jump_horizontal_distance") + caster:TG_GetTalentValue("special_bonus_imba_brewmaster_1")

	--传递Kv
    if target_point then
		local dis = (target_point - caster:GetAbsOrigin()):Length2D()
		local dir = (target_point - caster:GetAbsOrigin()):Normalized()
		if dis > jump_horizontal_distance then
		    dis = jump_horizontal_distance
		end
		local dur = dis/ jump_speed
		--载入跳跃
		caster:AddNewModifier(caster, self, motion_movement, {duration = dur,direction = dir})
	end
end

--跳跃
modifier_imba_brewmaster_thunder_clap_motion = class({})

function modifier_imba_brewmaster_thunder_clap_motion:IsBuff() return true end
function modifier_imba_brewmaster_thunder_clap_motion:IsHidden() return true end
function modifier_imba_brewmaster_thunder_clap_motion:IsPurgable() return false end
function modifier_imba_brewmaster_thunder_clap_motion:IsPurgeException() return false end
function modifier_imba_brewmaster_thunder_clap_motion:IsMotionController() return true end
function modifier_imba_brewmaster_thunder_clap_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_imba_brewmaster_thunder_clap_motion:OnCreated(keys)
	--特效
	self.smash_particle = "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf"
	self.smash_sound = "Hero_Brewmaster.ThunderClap"
	--KV
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.debuff_modifier = "modifier_imba_brewmaster_thunder_clap_debuff"
	self.debuff_duration = self:GetAbility():GetSpecialValueFor("duration")
	self.debuff_duration_creeps = self:GetAbility():GetSpecialValueFor("duration_creeps")
	self.buff_modifier = "modifier_imba_brewmaster_thunder_clap_buff"
	self.radius = self:GetAbility():GetSpecialValueFor("radius")

	if IsServer() then
		self.direction = StringToVector(keys.direction)
		self.speed = self:GetAbility():GetSpecialValueFor("jump_speed")
		if not self:CheckMotionControllers() then
			self:Destroy()
		else
			self:StartIntervalThink(FrameTime())
		end
	end
end

function modifier_imba_brewmaster_thunder_clap_motion:OnIntervalThink()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = self:GetAbility():GetSpecialValueFor("jump_height")
	local pos = self:GetParent():GetAbsOrigin() + self.direction * (self.speed / (1.0 / FrameTime()))
	pos = GetGroundPosition(pos, nil)
	pos.z = pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(pos)
end

function modifier_imba_brewmaster_thunder_clap_motion:OnDestroy()
	if IsServer() then
		--落地
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		--跳跃过程是否可以打断
		self:GetParent():InterruptMotionControllers(true)
		
		--落地特效
		local smash = ParticleManager:CreateParticle(self.smash_particle, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(smash, 0, self:GetCaster():GetAbsOrigin())

		--猛击音效
		EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), self.smash_sound, self:GetCaster())

		--猛击伤害
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),
			self:GetCaster():GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		local enemy_duration = self.debuff_duration
		local enemy_count = 0
		for _,enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
				damage_table = ({
					victim = enemy,
					attacker = self:GetCaster(),
					ability = self:GetAbility(),
					damage = self.damage,
					damage_type = self:GetAbility():GetAbilityDamageType()
				})
				--造成伤害
				ApplyDamage(damage_table)
				--DEBUFF
				if enemy:IsCreep() then
					enemy_duration = self.debuff_duration_creeps
				end
				--减攻速和减移速
				enemy:AddNewModifier_RS(self:GetCaster(), 
					self:GetAbility(), 
					self.debuff_modifier, 
					{duration = enemy_duration})
				enemy:EmitSound("Hero_Brewmaster.ThunderClap.Target")
				enemy_count = enemy_count + 1
			end
		end
		--自己添加BUFF
		self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self:GetAbility(),
			self.buff_modifier,
			{duration = self.debuff_duration_creeps , enemy_count = enemy_count}
			)

		--释放特效
		ParticleManager:ReleaseParticleIndex(smash)

		self.direction = nil
		self.speed = nil
	end
end

-- 允许使用位移技能和位移道具(跳刀)打断平移
function modifier_imba_brewmaster_thunder_clap_motion:OnHorizontalMotionInterrupted() self:Destroy() end
-- 允许使用位移技能和位移道具(跳刀)打断Z轴轨迹
function modifier_imba_brewmaster_thunder_clap_motion:OnVerticalMotionInterrupted() self:Destroy() end
-- 跳跃状态
function modifier_imba_brewmaster_thunder_clap_motion:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY]	= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]					= true,
	}
end


--DEBUFF 减少移速和攻速
modifier_imba_brewmaster_thunder_clap_debuff = class({})

function modifier_imba_brewmaster_thunder_clap_debuff:IsDebuff()		return true end
function modifier_imba_brewmaster_thunder_clap_debuff:IsHidden() 		return false end
function modifier_imba_brewmaster_thunder_clap_debuff:IsPurgable() 		return true end
function modifier_imba_brewmaster_thunder_clap_debuff:IsPurgeException() 	return true end
function modifier_imba_brewmaster_thunder_clap_debuff:GetEffectName() return "particles/basic_ambient/generic_paralyzed.vpcf" end
function modifier_imba_brewmaster_thunder_clap_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_brewmaster_thunder_clap_debuff:ShouldUseOverheadOffset() return true end
function modifier_imba_brewmaster_thunder_clap_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_brewmaster_thunder_clap_debuff:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("attack_speed_slow")) end
function modifier_imba_brewmaster_thunder_clap_debuff:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("movement_slow")) end

--Buff 增加自身攻速和移速
modifier_imba_brewmaster_thunder_clap_buff = class({})

function modifier_imba_brewmaster_thunder_clap_buff:IsDebuff()			return false end
function modifier_imba_brewmaster_thunder_clap_buff:IsHidden() 			return false end
function modifier_imba_brewmaster_thunder_clap_buff:IsPurgable() 		return true end
function modifier_imba_brewmaster_thunder_clap_buff:IsPurgeException() 	return true end
function modifier_imba_brewmaster_thunder_clap_buff:GetEffectName() return "particles/basic_ambient/generic_paralyzed.vpcf" end
function modifier_imba_brewmaster_thunder_clap_buff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_brewmaster_thunder_clap_buff:ShouldUseOverheadOffset() return true end
function modifier_imba_brewmaster_thunder_clap_buff:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_brewmaster_thunder_clap_buff:OnCreated(keys)
	if IsServer() then
		local caster = self:GetCaster()
		self.enemy_count = keys.enemy_count
		self.attack_count = self:GetAbility():GetSpecialValueFor("attack_count")
		self:SetStackCount(self.attack_count)
	end
end
function modifier_imba_brewmaster_thunder_clap_buff:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local enemy_self = self:GetParent()

	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	self:DecrementStackCount()
	if self:GetStackCount() == 0 then
		self:Destroy()
	end
end
function modifier_imba_brewmaster_thunder_clap_buff:GetModifierAttackSpeedBonus_Constant() return (self:GetAbility():GetSpecialValueFor("attack_speed_slow") * self:GetAbility():GetSpecialValueFor("attack_count")) end
function modifier_imba_brewmaster_thunder_clap_buff:GetModifierMoveSpeedBonus_Percentage() return (self:GetAbility():GetSpecialValueFor("movement_slow")) end
function modifier_imba_brewmaster_thunder_clap_buff:OnDestroy()
	if IsServer() then 
		self.enemy_count = nil 
		self.attack_count = nil
	end
end