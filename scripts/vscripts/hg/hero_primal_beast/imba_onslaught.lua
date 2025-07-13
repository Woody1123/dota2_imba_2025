CreateTalents("npc_dota_hero_primal_beast", "hg/hero_primal_beast/imba_onslaught.lua")


imba_onslaught=class({})

--LinkLuaModifier("imba_onslaught", "hg/hero_primal_beast/imba_onslaught.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_onslaught_check", "hg/hero_primal_beast/imba_onslaught.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trample_buff", "hg/hero_primal_beast/imba_trample.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veteran_talent_2_buff", "modifier/veteran_talent/modifier_veteran_talent_2.lua", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier("modifier_imba_gyroshell_boost_morale", "linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_onslaught_charge", "hg/hero_primal_beast/imba_onslaught.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_onslaught_charge_cd", "hg/hero_primal_beast/imba_onslaught.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_onslaught_again", "hg/hero_primal_beast/imba_onslaught.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trample_buff", "hg/hero_primal_beast/imba_trample.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trample_debuff", "hg/hero_primal_beast/imba_trample.lua", LUA_MODIFIER_MOTION_NONE)

function imba_onslaught:IsHiddenWhenStolen() return false end
function imba_onslaught:IsStealable() return true end
function imba_onslaught:OnUpgrade()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local main_ability = self
	local main_abilityName = self:GetAbilityName()
	local main_abilityLevel = self:GetLevel()
	local sub_ability = "imba_onslaught_again"
	local sub_ability_handle = caster:FindAbilityByName(sub_ability)
	local sub_ability_level = sub_ability_handle:GetLevel()
	if sub_ability_level ~= main_abilityLevel then
		sub_ability_handle:SetLevel(main_abilityLevel)
	end
end

function imba_onslaught:OnAbilityPhaseStart()
	if not IsServer() then return end
	local sound_cast = "Hero_PrimalBeast.Onslaught.Channel"
	local cast_particle = "particles/units/heroes/hero_primal_beast/primal_beast_heavy_step_cast.vpcf"
	local cast_particle_2 = "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_chargeup_streaks.vpcf"
	local caster = self:GetCaster()
	self.cast_effect = ParticleManager:CreateParticle(cast_particle, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.cast_effect, 0, caster:GetAbsOrigin()) -- 0: Spotlight position,
	ParticleManager:SetParticleControl(self.cast_effect, 3, caster:GetAbsOrigin()) --3: shell and sprint effect position,
	ParticleManager:SetParticleControl(self.cast_effect, 60, caster:GetAbsOrigin()) --5: roses landing point
	self.cast_effect_2 = ParticleManager:CreateParticle(cast_particle_2, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.cast_effect_2, 0, caster:GetAbsOrigin()) -- 0: Spotlight position,
	ParticleManager:SetParticleControl(self.cast_effect_2, 3, caster:GetAbsOrigin()) --3: shell and sprint effect position,
	ParticleManager:SetParticleControl(self.cast_effect_2, 60, caster:GetAbsOrigin()) --5: roses landing point
	EmitSoundOn(sound_cast, caster)
	return true
end

function imba_onslaught:OnAbilityPhaseInterrupted()
	if not IsServer() then return end
	if self.cast_effect then
		ParticleManager:DestroyParticle(self.cast_effect, false)
		ParticleManager:ReleaseParticleIndex(self.cast_effect)
		ParticleManager:DestroyParticle(self.cast_effect_2, false)
		ParticleManager:ReleaseParticleIndex(self.cast_effect_2)
	end
end


--技能开始时给自身添加碰撞检测和移动修饰器
function imba_onslaught:OnSpellStart()
    local caster=self:GetCaster()
    local roll_modifier = "modifier_imba_onslaught_check"
    self.duration=self:GetSpecialValueFor("max_charge_time")
    self.stun_duration=self:GetSpecialValueFor("stun_duration")


	local ab2 = caster:FindAbilityByName("imba_trample")
	if ab2 and ab2:GetLevel() >=1 then
		caster:AddNewModifier(caster, ab2, "modifier_imba_trample_buff", {duration = self.duration})
	end
	if caster:HasScepter() then
		caster:AddNewModifier(caster, self, "modifier_veteran_talent_2_buff", {duration = self.duration})
	end
    caster:AddNewModifier(caster, self, roll_modifier, {duration = self.duration ,stun_duration = self.stun_duration })
	caster:AddNewModifier(caster, self, "modifier_imba_onslaught_charge", {duration = self.duration})
    --caster:AddNewModifier(caster, self, "modifier_imba_onslaught_charge", {duration = self.duration})
	caster:SwapAbilities("imba_onslaught", "imba_onslaught_again", false, true)
	local ability = caster:FindAbilityByName("imba_onslaught_again")
	ability:StartCooldown(0.6)
	local sound_cast = "Hero_PrimalBeast.Onslaught.Vox"
	caster:StartGesture(ACT_DOTA_RUN_STATUE)
	EmitSoundOn(sound_cast, caster)
end

function imba_onslaught:Bash(target, parent, bUltimate)
	if not IsServer() then return end
	local caster = self:GetCaster()
	local parent_loc	= self:GetCaster():GetAbsOrigin()
	target:EmitSound("Hero_PrimalBeast.Onslaught.Hit")
	local knockback_properties = {
			 center_x 			= parent_loc.x,
			 center_y 			= parent_loc.y,
			 center_z 			= parent_loc.z,
			 duration 			= 0.4,
			 knockback_duration = 0.4,
			 knockback_distance = 200,
			 knockback_height 	= 150,
		}
	local knockback_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_knockback", knockback_properties)

	if knockback_modifier then
		knockback_modifier:SetDuration(self:GetSpecialValueFor("stun_duration"), true)
	end
	local stacks = caster:GetModifierStackCount("modifier_imba_gyroshell_roll", nil)
	local damage = self:GetSpecialValueFor("knockback_damage")
	local stacks = caster:GetModifierStackCount("modifier_imba_onslaught_charge", nil)
	local mag=self:GetSpecialValueFor("again_mag")
	local damageTable = {
						victim 			= target,
						damage 			= (1+stacks*mag)*damage,
						damage_type		= self:GetAbilityDamageType(),
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self
						}
	ApplyDamage(damageTable)
	target:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_onslaught_charge_cd", {duration = self:GetSpecialValueFor("stun_duration")})

end


--碰撞检测
modifier_imba_onslaught_check = class({})

function modifier_imba_onslaught_check:IsHidden() return true end
function modifier_imba_onslaught_check:IsPurgable() return false end
function modifier_imba_onslaught_check:IsPermanent() return false end
function modifier_imba_onslaught_check:IsDebuff() return false end

function modifier_imba_onslaught_check:DeclareFunctions()
	return {
		--MODIFIER_EVENT_ON_DEATH,
	}
end
function modifier_imba_onslaught_check:OnCreated()
	if self:GetAbility() == nil then return end
	self.duration_extend = self:GetAbility():GetSpecialValueFor("duration_extend")
	self.buff = self:GetAbility():GetSpecialValueFor("boost_morale_counter_max")
	self.radius= self:GetAbility():GetSpecialValueFor("knockback_radius")
	self.mag=self:GetAbility():GetSpecialValueFor("again_mag")
	self.caster=self:GetCaster()
	if IsServer() then
		self.gyroshell = self:GetCaster():FindModifierByName("modifier_imba_onslaught_charge")
		self.targets = self.targets or {}
		self:StartIntervalThink(0.05)
	end
end
--[[
function modifier_imba_onslaught_check:OnDeath(keys)
	if not IsServer() then return end

	if (not self.caster:HasScepter()) or keys.attacker~=self.caster or not keys.unit:IsHero() then return end
	if not IsEnemy(keys.unit,self.caster) then return end
	local ability = self.caster:FindAbilityByName("imba_onslaught")
	if ability and ability:IsTrained() then
		ability:SetCurrentAbilityCharges(ability:GetCurrentAbilityCharges()+1)
	end
end
]]

function modifier_imba_onslaught_check:OnIntervalThink()
	if IsServer() then
		if not self:GetCaster():HasModifier("modifier_imba_onslaught_charge") then
			self:Destroy()
		end
		local stacks = self:GetCaster():GetModifierStackCount("modifier_imba_onslaught_charge", nil)
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
			self:GetCaster():GetAbsOrigin(),
			nil,
			self.radius*(stacks*self.mag+1)  ,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,
			FIND_ANY_ORDER,
			false)
		for _,enemy in pairs(enemies) do
				if not enemy:HasModifier("modifier_imba_onslaught_charge_cd") then
					self:GetCaster():FindAbilityByName("imba_onslaught"):Bash(enemy, me)
					--留着给3技能加层
					--local buff_namber = self:GetParent():AddNewModifier(self:GetParent(), self:GetCaster():FindAbilityByName("imba_pangolier_gyroshell"), "modifier_imba_gyroshell_boost_morale", {})
					--if enemy:IsRealHero() then
					--	if buff_namber:GetStackCount() < self.buff then
					--		buff_namber:SetStackCount(buff_namber:GetStackCount() + 1)
					--	end
					--end
				end
		end
	end
end

function modifier_imba_onslaught_check:OnRemoved()
	if IsServer() then
		self:GetCaster():SwapAbilities("imba_onslaught", "imba_onslaught_again", true, false)
		self:StartIntervalThink(-1)
	end
end




modifier_imba_onslaught_charge_cd = class({})

function modifier_imba_onslaught_charge_cd:IsDebuff()			return false end
function modifier_imba_onslaught_charge_cd:IsHidden() 		return true end
function modifier_imba_onslaught_charge_cd:IsPurgable() 		return false end
function modifier_imba_onslaught_charge_cd:IsPurgeException() return false end




modifier_imba_onslaught_charge = class({})

function modifier_imba_onslaught_charge:IsDebuff()			return false end
function modifier_imba_onslaught_charge:IsHidden() 			return false end
function modifier_imba_onslaught_charge:IsPurgable() 			return false end
function modifier_imba_onslaught_charge:IsPurgeException() 	return false end
function modifier_imba_onslaught_charge:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MOVESPEED_LIMIT,
					MODIFIER_PROPERTY_MOVESPEED_MAX,
					MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
					MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
					MODIFIER_EVENT_ON_ORDER,
					MODIFIER_PROPERTY_DISABLE_TURNING
				}
	return funcs
end


function modifier_imba_onslaught_charge:GetModifierDisableTurning()
	if self:GetStackCount()>=4 then
		return 1
	end
	return 0
end


function modifier_imba_onslaught_charge:CheckState()
	return{ [MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			--[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true
		}
end

function modifier_imba_onslaught_charge:GetModifierMoveSpeed_Limit()
	return 1
end

function modifier_imba_onslaught_charge:GetModifierMoveSpeed_Max()
	return 1
end
function modifier_imba_onslaught_charge:GetModifierTurnRate_Percentage()
	if not IsServer() then return end
    local turn_rate=self:GetAbility():GetSpecialValueFor("turn_rate")
	--local turn_slow = 0 - 150
	return -turn_rate*10
end
function modifier_imba_onslaught_charge:OnCreated()
	if self:GetAbility() == nil then return end
	self:GetCaster().onslaught_is_charge = true
	if not IsServer() then
		return
	end

	self.sprinting_effect = "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf"
	self.sprint = ParticleManager:CreateParticle(self.sprinting_effect, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(self.sprint, 0, self:GetCaster():GetAbsOrigin()) --origin

	
	self:AddParticle(self.sprint, false, false, -1, true, false)
	self.model = self:GetCaster():GetModelName()
	--self:GetCaster():SetOriginalModel("models/heroes/pangolier/pangolier_gyroshell2.vmdl")
	self.forwardMoveSpeed = self:GetAbility():GetSpecialValueFor("charge_speed")
	self.mag=self:GetAbility():GetSpecialValueFor("again_mag")
    self:OnIntervalThink()
    self:StartIntervalThink(FrameTime())
end

--开始移动
function modifier_imba_onslaught_charge:OnIntervalThink()
	local caster = self:GetCaster()
	local direction = self:GetParent():GetForwardVector()
	local pos = self:GetParent():GetAbsOrigin()
	local int = self:GetStackCount()
	local speed = self.forwardMoveSpeed + (int * self.forwardMoveSpeed * self.mag)
	if self:GetParent():IsNightmared() or self:GetParent():IsRooted() then
        self:Destroy()
        return
    end


	local next_pos = GetGroundPosition(pos + direction * speed * FrameTime(), nil)
	if caster.onslaught_is_charge and not caster:IsStunned() then
		self:GetParent():SetAbsOrigin(next_pos)
	end
	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 200, false)
end

--移动被终止时
function modifier_imba_onslaught_charge:OnRemoved()
	--if IsServer() then
	--	self:GetCaster():SetOriginalModel(self.model)
	--	self:GetCaster():EmitSound("Hero_Pangolier.Gyroshell.Stop")
	--	self:GetCaster():StopSound("Hero_Pangolier.Gyroshell.Loop")
	--	self:GetCaster():StopSound("Hero_Pangolier.Gyroshell.Layer")
	--end
	if not IsServer() then
		return
	end
	self:GetCaster():RemoveGesture(ACT_DOTA_RUN_STATUE)
	self:GetCaster().roll_is_moving = true
end

--使用停止键主动停止移动
function modifier_imba_onslaught_charge:OnOrder(keys)
	if not IsServer() then
		return
	end
	if keys.unit==self:GetParent() then
		if  keys.order_type == DOTA_UNIT_ORDER_STOP then
			--TG_Remove_Modifier(self:GetParent(),"modifier_imba_onslaught_charge",0)
			self:StartIntervalThink(-1)
			self:Destroy()
		end
	end
end



imba_onslaught_again = class ({})

LinkLuaModifier("imba_onslaught_again_buff", "hg/hero_primal_beast/imba_onslaught.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trample_buff", "hg/hero_primal_beast/imba_trample.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trample_debuff", "hg/hero_primal_beast/imba_trample.lua", LUA_MODIFIER_MOTION_NONE)
function imba_onslaught_again:IsInnateAbility()				return true end
function imba_onslaught_again:IsStealable()					return false end
function imba_onslaught_again:GetAssociatedPrimaryAbilities()	return "imba_onslaught" end

function imba_onslaught_again:OnOwnerSpawned()
	if not IsServer() then return end
	local gyroshell_ability = self:GetCaster():FindAbilityByName("imba_onslaught")
	if gyroshell_ability and gyroshell_ability:IsHidden() then
		self:GetCaster():SwapAbilities("imba_onslaught", "imba_onslaught_again", true, false)
	end
end

function imba_onslaught_again:CastFilterResult(tg)
    local caster=self:GetCaster()
    --if not caster:HasModifier("modifier_blade_dance_move") and (caster:IsNightmared() or caster:IsStunned() or caster:IsFrozen() or caster:IsHexed()) then
	local ability = caster:FindAbilityByName("imba_onslaught")
	if ability and ability:GetCurrentAbilityCharges()<=0 then
        return UF_FAIL_CUSTOM
	end
end

function imba_onslaught_again:GetCustomCastError(tg)
    return "冲完了"
end




function imba_onslaught_again:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_imba_onslaught_charge")
	local modifier_2 =caster:FindModifierByName("modifier_imba_onslaught_check")

	local ability = caster:FindAbilityByName("imba_onslaught")
	local duration= ability:GetSpecialValueFor("max_charge_time")*ability:GetSpecialValueFor("again_mag")
	ability:SetCurrentAbilityCharges(ability:GetCurrentAbilityCharges()-1)
	--冲得更强
	modifier:IncrementStackCount()
	modifier:SetDuration(modifier:GetRemainingTime()+duration, true)
	modifier_2:SetDuration(modifier_2:GetRemainingTime()+duration, true)
	EmitGlobalSound("Imba.Hero_pangolier.gyroshell_stop")

	local ab2 = caster:FindAbilityByName("imba_trample")

	if ab2 and ab2:GetLevel() >=1 then
		caster:AddNewModifier(caster, ab2, "modifier_imba_trample_buff", {duration = modifier:GetRemainingTime()+duration})
	end
	--EmitSoundOn("Imba.Hero_pangolier.gyroshell_stop", caster)
end


